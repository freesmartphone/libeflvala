/*
 * Elm.Pager was removed from Elementary; Naviframe is the replacement.
 * These symbols keep the in-tree elm.vapi / ViewStateMachine compiling
 * against current EFL.
 */
#include <Elementary.h>

Evas_Object *
elm_pager_add(Evas_Object *parent)
{
    return elm_naviframe_add(parent);
}

void
elm_pager_content_push(Evas_Object *obj, Evas_Object *content)
{
    elm_naviframe_item_push(obj, NULL, NULL, NULL, content, NULL);
}

void
elm_pager_content_pop(Evas_Object *obj)
{
    elm_naviframe_item_pop(obj);
}

static Elm_Object_Item *
pager_item_for_content(const Evas_Object *obj, const Evas_Object *content)
{
    const Eina_List *l;
    Elm_Object_Item *it;

    EINA_LIST_FOREACH(elm_naviframe_items_get(obj), l, it)
    {
        if (elm_object_item_content_get(it) == content)
            return it;
    }
    return NULL;
}

void
elm_pager_content_promote(Evas_Object *obj, Evas_Object *content)
{
    Elm_Object_Item *it = pager_item_for_content(obj, content);
    if (it)
        elm_naviframe_item_promote(it);
}

Evas_Object *
elm_pager_content_bottom_get(const Evas_Object *obj)
{
    Elm_Object_Item *it = elm_naviframe_bottom_item_get(obj);
    return it ? elm_object_item_content_get(it) : NULL;
}

Evas_Object *
elm_pager_content_top_get(const Evas_Object *obj)
{
    Elm_Object_Item *it = elm_naviframe_top_item_get(obj);
    return it ? elm_object_item_content_get(it) : NULL;
}
