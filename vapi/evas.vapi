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
[CCode (cprefix = "Evas_", lower_case_cprefix = "evas_", cheader_filename = "Evas.h")]
namespace Evas
{
    //=======================================================================
    [SimpleType]
    [BooleanType]
    public struct Bool {}

    //=======================================================================
    [SimpleType]
    [IntegerType (rank=6)]
    public struct Coord {}

    //=======================================================================
    [CCode (instance_pos = 0)]
    public delegate void SmartCallback( Evas.Object obj, void* event_info );

    //=======================================================================
    [Compact]
    [CCode (cheader_filename = "Evas.h")]
    public abstract class Object
    {
        public void del();
        public void hide();
        public void resize( Coord w, Coord h );
        public void show();

        public void size_hint_align_set( double x, double y );
        public void size_hint_min_set( Coord w, Coord h );
        public void size_hint_max_set( Coord w, Coord h );
        public void size_hint_padding_set( Coord l, Coord r, Coord t, Coord b );
        public void size_hint_weight_set( double x, double y );

        public void name_set( string name );
        public weak string name_get ( );

        public void smart_callback_add( string event, SmartCallback func );
    }
}

