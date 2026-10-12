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

using Eina;
using Gee;

//===========================================================================
public void test_eina_list()
{
    int[] data = { 6, 9, 42, 1, 7, 9, 81, 1664, 1337 };

    Eina.init();
    Eina.List<int> l = null;

    l.append( data[0] );
    assert ( l != null );
    assert ( l.count() == 1 );

    l.prepend( data[1] );
    assert ( l != null );
    assert ( l.count() == 2 );

    l.append( data[2] );
    assert ( l != null );
    assert ( l.count() == 3 );

    /* eina_list_remove() removes the *first* occurrence of the value.
     * The list is { 9, 6, 42 } here, so removing 6 drops one node. */
    l.remove( data[0] );
    assert ( l != null );
    assert ( l.count() == 2 );

    /* 1337 is not in the list: remove() returns NULL and leaves it alone. */
    l.remove( data[8] );
    assert ( l != null );
    assert ( l.count() == 2 );

    /* eina_list_data_find_list() returns the sublist starting at the
     * first node holding the data, so for a 2-element list { 9, 42 }
     * searching for 42 yields exactly one remaining element.  The result
     * borrows from `l' and must not be owned/freed separately. */
    unowned Eina.List<int> l2 = l.data_find_list( data[2] );
    assert ( l2 != null );
    assert ( l2.count() == 1 );

    var item = l.data_find( data[2] );
    assert ( item == data[2] );

    /* convert the remaining Eina.List contents into a Gee.ArrayList:
     * peek_gee_list() copies without touching the original list, so `l`
     * stays valid and is freed below when the owned reference is dropped.
     * (The consuming variant is Eflvala.gee_list<int>( (owned) l ).) */
    var gee = Eflvala.peek_gee_list<int>( l );
    assert ( gee.size == (int) l.count() );
    assert ( gee.contains( data[1] ) );
    assert ( gee.contains( data[2] ) );

    l = null;

    /*
    Eina.shutdown();
    */
}


//===========================================================================
void main( string[] args )
{
    Test.init( ref args );

    Test.add_func( "/Eina/List", test_eina_list );
    Test.add_func( "/Gee/HashMap", test_gee_hashmap );

    Test.run();
}

//===========================================================================
// The view state transition maps use Gee.HashMap (gee-0.8); verify the
// collection semantics the library relies on.
public void test_gee_hashmap()
{
    var map = new HashMap<string, int>();
    assert ( map.size == 0 );

    map["to_configuration"] = 1;
    map["to_main"] = 2;
    assert ( map.size == 2 );
    assert ( map["to_configuration"] == 1 );
    assert ( map.has_key( "to_main" ) );
    assert ( !map.has_key( "nonexistent" ) );
    assert ( map["nonexistent"] == 0 ); // missing keys yield the default value

    map.unset( "to_main" );
    assert ( map.size == 1 );
}
