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

//=======================================================================
public class EflVala.QueueWithNotifier<T> : GLib.Object
//=======================================================================
{
    private GLib.Queue<T> q;
    private static int counter = 0;
    private int readfd = -1;
    private int writefd = -1;

    public QueueWithNotifier()
    {
        q = new GLib.Queue<T>();
        int[] fds = { 0, 0 };
        var ok = Posix.pipe( fds );
        if ( ok == -1 )
            critical( "could not create posix pipes: %s", Posix.strerror( Posix.errno ) );
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
        return q.pop_tail();
    }

    public void write( T message )
    {
        q.push_head( message );
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
