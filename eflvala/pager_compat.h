#ifndef PAGER_COMPAT_H
#define PAGER_COMPAT_H

#include <Elementary.h>

/* Elm.Pager was removed from Elementary; Naviframe is the replacement.
 * These declarations keep the in-tree elm.vapi / ViewStateMachine compiling
 * against current EFL.
 */

EAPI Evas_Object *elm_pager_add(Evas_Object *parent);
EAPI void elm_pager_content_push(Evas_Object *obj, Evas_Object *content);
EAPI void elm_pager_content_pop(Evas_Object *obj);
EAPI void elm_pager_content_promote(Evas_Object *obj, Evas_Object *content);
EAPI Evas_Object *elm_pager_content_bottom_get(const Evas_Object *obj);
EAPI Evas_Object *elm_pager_content_top_get(const Evas_Object *obj);

#endif
