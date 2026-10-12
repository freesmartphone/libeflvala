/* 
 * File Name: eina_list.vala
 * Creation Date: 22-03-2009
 * Last Modified:
 *
 * Authored by Frederik 'playya' Sdun <Frederik.Sdun@googlemail.com>
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
 */
using Eina;
using Gee;

public static int main( string[] _args )
{
    Eina.init();
    gee_list_example();
    eina_file_example();
    eina_error_example();
    // the engine list returned by the EFL is converted into a Gee.ArrayList
    var engines = gee_list_from_eina_iterator( EcoreEvas.engines_get().iterator_new() );
    debug( "gee: %u evas engines", engines.size );
    Eina.shutdown();
    return 0;
}

//=================================================================
// Demonstration of the generic list implementation: lists returned by
// the EFL are Eina.List/Eina.Iterator based, which get converted into
// Gee.ArrayList (from gee-0.8) for idiomatic Vala iteration.
public static void gee_list_example()
{
    var a = new ArrayList<string>();
    var b = new ArrayList<string>();
    a.add( "Alfred" );
    a.add( "Anton" );
    b.add( "Batman" );
    b.add( "Bar" );
    b.add( "aaaa" );
    debug( "list a:" );
    foreach ( string s in a ) { debug( "\tdata: %s", s ); }
    debug( "list b:" );
    foreach ( string s in b ) { debug( "\tdata: %s", s ); }
    // prepend semantics of the old Eina.List example: a reversed, then merged into b
    var index = 0;
    foreach ( string s in a )
    {
        b.insert( index++, s );
    }
    debug( "list merged:" );
    foreach ( string s in b ) { debug( "\tdata: %s", s ); }
    b.sort( ( x, y ) => GLib.strcmp( x, y ) );
    debug( "list sorted:" );
    foreach ( string s in b ) { debug( "\tdata: %s", s ); }
}

// Convert an Eina.Iterator over strings into a Gee.ArrayList<string>.
public static ArrayList<string> gee_list_from_eina_iterator( owned Eina.Iterator<string> it )
{
    var list = new ArrayList<string>();
    string? data = null;
    while ( it.next( ref data ) )
    {
        if ( data != null ) { list.add( data ); }
    }
    return list;
}
//=================================================================
public static void eina_file_example()
{
    string path = GLib.Environment.get_variable( "PWD" );

    stdout.printf("Dir \tName\n");
    File.dir_list( path, true, dir_print, null );
}
public void dir_print( string? name, string? path, void* _data )
{
    string p = "%s/%s".printf( path, name );
    var v = FileUtils.test( p, GLib.FileTest.IS_DIR ).to_string();
    stdout.printf( "%s\t%s\n", v, p );
}
//=================================================================
public static void eina_error_example()
{
    var e1 = Eina.Error( "Foobar" );
    var e2 = Eina.Error( "Moep Meop" );
    var e3 = Eina.Error( "Chooo Choo" );
    e1.set();
    e2.set();
    e3.set();

}
