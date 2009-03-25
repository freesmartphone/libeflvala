/**
 * Copyright (C) 2009 Michael 'Mickey' Lauer <mlauer@vanille-media.de>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 **/

// This is for testing how to best deal with the two distinct threads,
// it may evolve in a Application class in libeflvala that hides the
// nasty details of the two threads / mainloops involved.

public class CommunicationThread : GLib.Object
{
    bool quitflag;

    public static CommunicationThread self;
    public static MainLoop loop;

    public EflVala.BidirectionalThreadQueue q;
    private IOChannel ioc;

    public CommunicationThread()
    {
        assert ( self == null );
        self = this;
        q = new EflVala.BidirectionalThreadQueue( EflVala.BidirectionalThreadQueue.Identifier.COMMUNICATION_THREAD );
    }

    public bool canReadFromQ( IOChannel source, IOCondition c )
    {
        debug( "G thread can read from Q" );
        var command = q.read();
        debug( "G thread got command '%s", command.command );
        q.write( new EflVala.Command( "G --> E") );
        q.write( new EflVala.Command( "G --> E") );
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

    public EflVala.BidirectionalThreadQueue q;

    public UserInterfaceThread( string[] args )
    {
        assert ( self == null );
        self = this;

        q = new EflVala.BidirectionalThreadQueue( EflVala.BidirectionalThreadQueue.Identifier.GUI_THREAD );

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
        q.write( new EflVala.Command( "E --> G" ) );
        return true;
    }

    public bool canReadFromQ( Ecore.FdHandler fdhandler )
    {
        debug( "E thread can read from Q" );
        var command = q.read();
        debug( "E thread got command '%s", command.command );
        return true;
    }

    public static void* run()
    {
        self.timer = new Ecore.Timer( 1, self.watcher );

        int writefd;
        int readfd;
        self.q.getFds( out readfd, out writefd );

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

