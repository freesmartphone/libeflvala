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

public class EflVala.Thread : GLib.Object
{
    private unowned GLib.Thread _thread;

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

    private void* _run()
    {
        debug( "_run..." );
        while ( true )
        {
            debug( "still running..." );
            _thread.usleep( 1000 * 300 );
        }
    }
}
