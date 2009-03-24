/**
 * Copyright (C) 2009 Michael 'Mickey' Lauer <mlauer@vanille-media.de>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 */

// This is for testing how to best deal with the two distinct threads,
// it may evolve in a Application class in libeflvala that hides the
// nasty details of the two threads / mainloops involved.

// What we need next is a thread-safe Queue where the inter-thread
// communication happens. Plus, both the mainloops need a way to
// be notified of new commands in the Queue without polling.
// I'll resort to the same technique I used in the ELAN project.

public class Command : GLib.Object
{
}

public class QueueWithNotifier<T> : GLib.Object
{
    private Queue<T> q;
    private static int counter = 0;
    private int readfd = -1;
    private int writefd = -1;

    public QueueWithNotifier()
    {
        int[] fds = { 0, 0 };
        var ok = Posix.pipe( fds );
        assert( ok != -1 );
        debug( "fds = %d, %d", fds[0], fds[1] );
        readfd = fds[0];
        writefd = fds[1];
    }

    ~QueueWithNotifier()
    {
        if ( readfd != -1 )
            Posix.close( readfd );
        if ( writefd != -1 )
            Posix.close( writefd );
    }

    public T read()
    {
        char[] dot = { '.' };
        var number = Posix.read( readfd, dot, 1 );
        assert ( number == 1 );
        // generate T
        return new Command();
    }

    public void write( T message )
    {
        char[] dot = { '.' };
        var number = Posix.write( writefd, dot, 1 );
        assert ( number == 1 );
    }

    public int getReadFd()
    {
        return readfd;
    }

    public int getWriteFd()
    {
        return writefd;
    }
}

public class BidirectionalThreadQueue : GLib.Object
{
    public enum Identifier
    {
        COMMUNICATION_THREAD,
        GUI_THREAD;
    }
    private static QueueWithNotifier<Command> toGuiQ;
    private static QueueWithNotifier<Command> toCommQ;

    private Identifier owner;

    public BidirectionalThreadQueue( Identifier id )
    {
        owner = id;
        switch ( id )
        {
            case Identifier.COMMUNICATION_THREAD:
                assert ( toGuiQ == null );
                toGuiQ = new QueueWithNotifier<Command>();
                break;
            case Identifier.GUI_THREAD:
                assert ( toCommQ == null );
                toCommQ = new QueueWithNotifier<Command>();
                break;
            default:
                assert_not_reached();
        }
    }

    public void getFds( out int readfd, out int writefd )
    {
        switch ( owner )
        {
            case Identifier.COMMUNICATION_THREAD:
                readfd = toCommQ.getReadFd();
                writefd = toGuiQ.getWriteFd();
                break;
            case Identifier.GUI_THREAD:
                readfd = toGuiQ.getReadFd();
                writefd = toCommQ.getWriteFd();
                break;
            default:
                assert_not_reached();
        }
    }

    public Command? read()
    {
        switch ( owner )
        {
            case Identifier.COMMUNICATION_THREAD:
                return toCommQ.read();
                break;
            case Identifier.GUI_THREAD:
                return toGuiQ.read();
                break;
            default:
                assert_not_reached();
        }
    }

    public void write( Command command )
    {
        switch ( owner )
        {
            case Identifier.COMMUNICATION_THREAD:
                toGuiQ.write( command );
                break;
            case Identifier.GUI_THREAD:
                toCommQ.write( command );
                break;
            default:
                assert_not_reached();
        }
    }

}

public class CommunicationThread : GLib.Object
{
    bool quitflag;

    public static CommunicationThread self;
    public static MainLoop loop;

    public BidirectionalThreadQueue q;
    private IOChannel ioc;

    public CommunicationThread()
    {
        assert ( self == null );
        self = this;
        q = new BidirectionalThreadQueue( BidirectionalThreadQueue.Identifier.COMMUNICATION_THREAD );
    }

    public bool canReadFromQ( IOChannel source, IOCondition c )
    {
        debug( "G thread can read from Q" );
        var command = q.read();
        q.write( new Command() );
        return true;
    }

    public bool watcher()
    {
        debug( "G mainloop still running" );
        if ( !quitflag )
            return true;
        else
        {
            loop.quit();
            return false;
        }
    }

    public void shutdown()
    {
        quitflag = true;
    }

    public static void* run()
    {
        assert ( self != null );
        loop = new MainLoop( null, false );
        Timeout.add_seconds( 1, self.watcher );
        int readfd;
        int writefd;
        self.q.getFds( out readfd, out writefd );
        self.ioc = new GLib.IOChannel.unix_new( readfd );
        self.ioc.add_watch( IOCondition.IN, self.canReadFromQ );
        debug( "INTO G mainloop" );
        loop.run();
        debug( "OUT OF G mainloop" );
        return null;
    }
}

public class UserInterfaceThread : GLib.Object
{
    public static UserInterfaceThread self;
    public CommunicationThread commthread;
    public Ecore.Timer timer;
    public Elm.Win win;

    public Ecore.FdHandler fdhandler;

    public BidirectionalThreadQueue q;

    int writefd = -1;

    public UserInterfaceThread( string[] args )
    {
        assert ( self == null );
        self = this;

        q = new BidirectionalThreadQueue( BidirectionalThreadQueue.Identifier.GUI_THREAD );

        Elm.init( args );

        win = new Elm.Win( null, "myWindow", Elm.WinType.BASIC );
        win.title_set( "Elementary meets Vala" );
        win.autodel_set( true );
        win.resize( 320, 320 );
        win.smart_callback_add( "delete-request", Elm.exit );
        win.show();

        var layout = new Elm.Layout( win );
        layout.file_set( "/usr/local/share/elementary/objects/test.edj", "layout" );
        layout.size_hint_weight_set( 1.0, 1.0 );
        layout.show();
        win.resize_object_add( layout );

    }

    public void setCommThread( CommunicationThread commthread )
    {
        this.commthread = commthread;
    }

    ~UserInterfaceThread()
    {
        Elm.shutdown();
    }

    public bool watcher()
    {
        debug( "E mainloop still running" );
        Posix.write( writefd, ".", 1 );
        return true;
    }

    public bool canReadFromQ( Ecore.FdHandler fdhandler )
    {
        debug( "E thread can read from Q" );
        var command = q.read();
        return true;
    }

    public static void* run()
    {
        self.timer = new Ecore.Timer( 1, self.watcher );

        int readfd;
        self.q.getFds( out readfd, out self.writefd );

        self.fdhandler = new Ecore.FdHandler( readfd, Ecore.FdHandlerFlags.READ, self.canReadFromQ, null );

        debug( "INTO E mainloop" );
        Elm.run();
        debug( "OUT OF E mainloop" );
        self.commthread.shutdown();
        return null;
    }

}

static int main( string[] args )
{
    if ( !Thread.supported() ) {
        error( "Cannot run without threads.\n" );
        return 0;
    }

    var commt = new CommunicationThread();
    var uit = new UserInterfaceThread( args );
    uit.setCommThread( commt );

    unowned Thread t1;
    unowned Thread t2;

    try
    {
        t1 = Thread.create( commt.run, true );
        t2 = Thread.create( uit.run, true );
    }
    catch ( ThreadError ex )
    {
        error( "%s", ex.message );
        return -1;
    }

    t1.join();
    t2.join();

    debug( "all threads exited OK." );

    return 0;
}

