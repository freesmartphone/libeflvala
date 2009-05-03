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
    public void init();
    public void shutdown();

    public int render_method_lookup( string name );

    //=======================================================================
    [Compact]
    [CCode (cname = "Evas", free_function = "evas_free")]
    public class Canvas
    {
        [CCode (cname = "evas_new" )]
        public Canvas();

        public void output_method_set( int render_method );
        public int output_method_get();

        public void output_size_set( int w, int h );
        public void output_size_get( out int w, out int h );
        public void output_viewport_set( Coord x, Coord y, Coord w, Coord h );
        public void output_viewport_get( out Coord x, out Coord y, out Coord w, out Coord h );

        public Coord coord_screen_x_to_world( int x );
        public Coord coord_screen_y_to_world( int y );
        public int coord_world_x_to_screen( Coord x );
        public int coord_world_y_to_screen( Coord y );

        public void pointer_output_xy_get( out int x, out int y );
        public void pointer_canvas_xy_get( out Coord x, out Coord y );
        public int pointer_button_down_mask_get();
        public bool pointer_inside_get();

        public void data_attach_set( void *data );
        public void* data_attach_get();
    }

    //=======================================================================
    [SimpleType]
    [BooleanType]
    public struct Bool {}

    //=======================================================================
    [SimpleType]
    [IntegerType (rank=6)]
    public struct Coord {}

    //=======================================================================
    [SimpleType]
    [IntegerType (rank=6)]
    public struct FontSize {}

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
        public bool visible_get();

        public weak Canvas evas_get();

        public void size_hint_align_set( double x, double y );
        public void size_hint_min_set( Coord w, Coord h );
        public void size_hint_max_set( Coord w, Coord h );
        public void size_hint_padding_set( Coord l, Coord r, Coord t, Coord b );
        public void size_hint_weight_set( double x, double y );

        public void name_set( string name );
        public weak string name_get();

        public void layer_set( int layer );

        public void smart_callback_add( string event, SmartCallback func );
    }

    //=======================================================================
    [Compact]
    [CCode (cheader_filename = "Evas.h", cname = "Evas_Object", cprefix = "evas_object_text_", free_function = "evas_object_del")]
    public class Text : Object
    {
        [CCode (cname = "evas_object_text_add")]
        public Text( Canvas e );

        public void text_set( string text );
        public weak string text_get();
    }

    //=======================================================================
    [Compact]
    [CCode (cheader_filename = "Evas.h", cname = "Evas_Object", cprefix = "evas_object_image_", free_function = "evas_object_del")]
    public class Image : Object
    {
        [CCode (cname = "evas_object_image_add")]
        public Image( Canvas e );

        public void size_set( int w, int h );
        public void size_get( out int w, out int h);

        public void filled_set(bool setting );
        public void file_set( string file, string key );

        public void data_set( void* data );

        //public void   data_convert( Evas_Colorspace to_cspace );
        //public void*   data_get( in Evas_Object* obj, bool for_writing );

        public void data_copy_set( void* data );
        public void data_update_add( int x, int y, int w, int h );

        public void alpha_set( bool has_alpha );
        public bool alpha_get();
    }
}

