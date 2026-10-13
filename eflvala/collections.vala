/**
 * Copyright (C) 2009-2026 The eflvala authors
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

/* Gee migration: idiomatic collection helpers for EFL bindings.
 *
 * EFL C APIs hand out singly linked `Eina_List` and opaque `Eina_Iterator`
 * objects. These pure-Vala extension methods convert them into
 * `Gee.ArrayList` (gee-0.8), which is the canonical collection type of this
 * binding. No extra C code is required -- everything below compiles to
 * regular Vala generics code.
 *
 * Note: these cannot live inside vapi/eina.vapi itself -- Vala forbids
 * instantiating generic types from a class type parameter inside a .vapi,
 * and generic compact classes cannot be subclassed.
 */

namespace Eflvala
{
    /**
     * Copy the contents of an owned `Eina.List` into a new `Gee.ArrayList`.
     *
     * The Eina list is consumed (freed via `eina_list_free`, registered as
     * the class' `free_function`) after its elements have been copied. Use
     * this on caller-owned lists returned by functions such as
     * `Edje.file_collection_list()` or `Evas.font_path_list()`.
     */
    public static Gee.ArrayList<G> gee_list<G>(owned Eina.List<G>? list)
    {
        var result = new Gee.ArrayList<G>();
        for (unowned Eina.List<G> i = list; i != null; i = i.next) {
            result.add(i.data);
        }
        return result;
    }

    /**
     * Snapshot a borrowed (`unowned`) `Eina.List` into a new `Gee.ArrayList`.
     *
     * The original list is *not* freed -- it is owned by whoever handed it
     * out (typically an EFL widget). Use this on getters such as
     * `Elm.List.items_get()`.
     */
    public static Gee.ArrayList<G> peek_gee_list<G>(Eina.List<G>? list)
    {
        var result = new Gee.ArrayList<G>();
        for (unowned Eina.List<G> i = list; i != null; i = i.next) {
            result.add(i.data);
        }
        return result;
    }

    /**
     * Drain an owned `Eina.Iterator` into a new `Gee.ArrayList`.
     *
     * Named `iterate_to_gee_list()` rather than `gee_list()` because Vala
     * does not allow overloading on the (erased) generic type parameter.
     *
     * The iterator is consumed and freed after traversal. Works with the
     * iterators returned by EFL APIs such as `EcoreEvas.engines_get()`.
     */
    public static Gee.ArrayList<G> iterate_to_gee_list<G>(owned Eina.Iterator<G> it)
    {
        var result = new Gee.ArrayList<G>();
        G? data = null;
        while (it.next(ref data)) {
            result.add(data);
        }
        return result;
    }
}
