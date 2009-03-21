public class Threading : GLib.Object
{
    public static void* thread_func()
    {
        while ( true )
        {
            message( "thread running" );
            Thread.usleep( 1000 * 300 );
        }
        return null;
    }
}

static int main( string[] args )
{
    if (!Thread.supported()) {
        stderr.printf("Cannot run without threads.\n");
        return 0;
    }

    var t = new Threading();

    try
    {
        Thread.create( t.thread_func, false);
    }
    catch (ThreadError ex)
    {
        return 0;
    }

    while ( true )
    {
        Thread.usleep( 1000 * 500 );
        message( "yo" );
    }
    return 0;
}

