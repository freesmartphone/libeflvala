public class CommunicationThread : GLib.Object
{
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
        return true;
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
        return null;
    }

}

static int main( string[] args )
{
    if (!Thread.supported()) {
        stderr.printf("Cannot run without threads.\n");
        return 0;
    }

    var commt = new CommunicationThread();
    var uit = new UserInterfaceThread( args );

    try
    {
        Thread.create( commt.run, false );
        Thread.create( uit.run, false );
    }
    catch ( ThreadError ex )
    {
        error( "%s", ex.message );
        return -1;
    }

    while ( true )
    {
        Thread.usleep( 1000 * 500 );
        message( "main thread still running..." );
    }
    return 0;
}

