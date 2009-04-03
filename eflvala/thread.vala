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

public delegate bool EflVala.FdCallback( int fd );

//=======================================================================
public class EflVala.Thread : GLib.Object
//=======================================================================
{
    private unowned GLib.Thread _thread;
    protected EflVala.BidirectionalThreadQueue q;

    public Thread()
    {
        debug( "constructing thread (%p)", this );
    }

    ~Thread()
    {
        debug( "destructing thread (%p)", this );
    }

    public void run()
    {
        assert ( _thread == null );
        _thread = GLib.Thread.create( _run, true );
    }

    public void join()
    {
        assert ( _thread != null );
        _thread.join();
    }

    public virtual void mainfunc()
    {
    }

    public virtual void quit()
    {
    }

    public virtual bool command( EflVala.Command cmd )
    {
        return false;
    }

    public virtual void send( EflVala.Command cmd )
    {
        q.write( cmd );
    }

    //
    // internal
    //

    private void* _run()
    {
        mainfunc();
        return null;
    }
}

//=======================================================================
public class EflVala.GThread : EflVala.Thread
//=======================================================================
{
    private GLib.MainLoop mainloop;
    private GLib.IOChannel iochannel;

    public GThread()
    {
        debug( "constructing G thread" );
        // create mainloop
        mainloop = new GLib.MainLoop( null, false );
        // create commqueue
        q = new EflVala.BidirectionalThreadQueue( EflVala.BidirectionalThreadQueue.Identifier.COMMUNICATION_THREAD );
    }

    public override void mainfunc()
    {
        debug( "G mainfunc" );
        // give app a chance to init its backend
        theApp.setupBackend();
        // setup debug watcher
        Timeout.add_seconds( 1, _secondsTimeout );
        // hook q into mainloop
        iochannel = new GLib.IOChannel.unix_new( q.getReadFd() );
        iochannel.add_watch( GLib.IOCondition.IN, _canReadFromQueue );
        // and run
        mainloop.run();
    }

    public override void quit()
    {
        mainloop.quit();
    }

    public override bool command( EflVala.Command cmd )
    {
        debug( "G Thread got command: '%s'", cmd.command );
        theApp.handleCommandFromFrontend( cmd );
        return true;
    }

    //
    // internal
    //
    private bool _canReadFromQueue( GLib.IOChannel source, GLib.IOCondition condition )
    {
        return command( q.read() );
    }

    private bool _secondsTimeout()
    {
        debug( "G still running" );
        return true;
    }
}

//=======================================================================
public class EflVala.EThread : EflVala.Thread
//=======================================================================
{
    private Ecore.Timer timer;
    private Ecore.FdHandler fdhandler;

    public EThread()
    {
        debug( "constructing E thread" );
        // create mainloop
        //Elm.init( theApp.args() );
        // create commqueue
        q = new EflVala.BidirectionalThreadQueue( EflVala.BidirectionalThreadQueue.Identifier.GUI_THREAD );
    }

    ~EThread()
    {
        Elm.shutdown();
    }

    public override void mainfunc()
    {
        debug( "E mainfunc" );
        // give app a chance to init its frontend
        theApp.setupFrontend();
        // setup debug watcher
        timer = new Ecore.Timer( 1.0, _secondsTimeout );
        // hook q into mainloop
        fdhandler = new Ecore.FdHandler( q.getReadFd(), Ecore.FdHandlerFlags.READ, _canReadFromQueue, null );
        // and run
        Elm.run();
    }

    public override void quit()
    {
        Elm.exit();
    }

    public override bool command( EflVala.Command cmd )
    {
        debug( "E Thread got command: '%s'", cmd.command );
        theApp.handleCommandFromBackend( cmd );
        return true;
    }

    //
    // internal
    //

    private bool _canReadFromQueue( Ecore.FdHandler fdhandler )
    {
        return command( q.read() );
    }

    private bool _secondsTimeout()
    {
        debug( "E still running" );
        return true;
    }
}
