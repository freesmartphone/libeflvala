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

static EflVala.Application theApp;

//=======================================================================
public class EflVala.Application : GLib.Object
//=======================================================================
{
    private EflVala.EThread _ethread;
    private EflVala.GThread _gthread;

    //
    // public
    //

    public Application( string[] args )
    {
        debug( "Application()" );
        Elm.init( args ); //FIXME: might be better done elsewhere (i.e. from within the E thread?)
        assert ( theApp == null );
        theApp = this;
        _createThreads();
    }

    public int run()
    {
        _ethread.run();
        _gthread.run();
        _ethread.join();
        _gthread.join();
        return 0;
    }

    public void quit()
    {
        _ethread.quit();
        _gthread.quit();
    }

    public virtual void setupFrontend()
    {
    }

    public virtual void setupBackend()
    {
    }

    //
    // private
    //

    private void _createThreads()
    {
        if ( !GLib.Thread.supported() )
        {
            error( "Cannot run without threads!" );
        }

        _ethread = new EflVala.EThread();
        _gthread = new EflVala.GThread();
    }
}
