public class CommunicationThread : GLib.Object
{
    bool quitflag;

    public static CommunicationThread self;
    public static MainLoop loop;


    public CommunicationThread()
    {
        assert ( self == null );
        self = this;
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

    public UserInterfaceThread( string[] args )
    {
        assert ( self == null );
        self = this;

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
        return true;
    }

    public static void* run()
    {
        self.timer = new Ecore.Timer( 1, self.watcher );
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

