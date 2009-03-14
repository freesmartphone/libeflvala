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
[CCode (cprefix = "Eina_", lower_case_cprefix = "eina_", cheader_filename = "Eina.h")]
namespace Eina
{
    public int init();
    public int shutdown();

    //=======================================================================
    [Compact]
    public class List<G>
    {
        [ReturnsModifiedPointer ()]
        public void append( G# data );

        public uint count();

        public weak G data_find( G# data );
        // ???
        public List<G> data_find_list( G# data );

        public weak G nth( uint n );

        [ReturnsModifiedPointer ()]
        public void prepend( G# data );

        [ReturnsModifiedPointer ()]
        public void remove( G# data );

        public static void init();
        public static void shutdown();
    }
}
