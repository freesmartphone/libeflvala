/**
 * (C) 2009 Michael 'Mickey' Lauer <mlauer@vanille-media.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 **/
public static int main( string[] args)
{
    /* init */
    EcoreEvas.init();
    Edje.init();

    /* create a window */
    var ee = new EcoreEvas.Window( "software_x11", 0, 0, 320, 480, null );
    ee.title_set( "Edje Example Application" );
    ee.show();
    var evas = ee.evas_get();

    /* create an edje */
    var background = new Edje.Object( evas );
    background.file_set( "/tmp/angstrom-bootmanager.edj", "background" );
    background.resize( 320, 480 );
    background.layer_set( 0 );
    background.show();

    var buttons = new Edje.Object( evas );
    buttons.file_set( "/tmp/angstrom-bootmanager.edj", "buttons" );
    buttons.resize( 320, 480 );
    buttons.layer_set( 1 );
    buttons.show();

    /* get pointer to object in part */
    assert( background.part_exists( "version" ) );
    var text = (Evas.Text) background.part_object_get( "version" ); // as Evas.Text;
    text.text_set( "Hello Edje World!" );

    /* main loop */
    Ecore.MainLoop.begin();

    /* shutdown */
    Edje.shutdown();
    EcoreEvas.init();
    return 0;
}

