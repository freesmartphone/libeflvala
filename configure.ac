AC_INIT([libeflvala], [0.1.0.0], [mlauer@vanille-media.de], [libeflvala])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_HEADERS(config.h)
AM_INIT_AUTOMAKE([dist-bzip2])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

AC_PROG_CC
AM_PROG_CC_C_O
AC_DISABLE_STATIC
AC_PROG_LIBTOOL

AC_PATH_PROG(VALAC, valac, valac)
AC_SUBST(VALAC)

AC_SUBST(CFLAGS)
AC_SUBST(CPPFLAGS)
AC_SUBST(LDFLAGS)

VALA_REQUIRED=0.7.9
EINA_REQUIRED=0.0.0
EVAS_REQUIRED=0.0.0
ECORE_REQUIRED=0.0.0
EDJE_REQUIRED=0.0.0
ELM_REQUIRED=0.0.0
GLIB_REQUIRED=2.18.0
DBUS_REQUIRED=1.2.1
DBUS_GLIB_REQUIRED=0.74

PKG_CHECK_MODULES(VALA,
  vala-1.0 >= $VALA_REQUIRED)

PKG_CHECK_MODULES(DEPS,
  dbus-1 >= $DBUS_REQUIRED
  dbus-glib-1 >= $DBUS_GLIB_REQUIRED
  eina-0 >= $EINA_REQUIRED
  evas >= $EVAS_REQUIRED
  ecore >= $ECORE_REQUIRED
  edje >= $EDJE_REQUIRED
  elementary >= $ELM_REQUIRED
  glib-2.0 >= $GLIB_REQUIRED
  gobject-2.0 >= $GLIB_REQUIRED)
AC_SUBST(DEPS_CFLAGS)
AC_SUBST(DEPS_LIBS)

AC_ARG_WITH(edje-cc,
[  --with-edje-cc=PATH	specify a specific path to edje_cc],
[
  v=$withval;
  edje_cc=$v
  echo "  Enlightenment edje_cc explicitly set to "$edje_cc;
],[
  edje_cc=$(pkg-config --variable=prefix edje)/bin/edje_cc
])
AC_SUBST(edje_cc)


# shall we compile the library? [default=yes]
AC_ARG_ENABLE(library,      [  --disable-library	skip building the eflvala library [[default=no]]])
AM_CONDITIONAL(MAKE_LIBRARY, test x$enable_library != xno)
AC_MSG_CHECKING([whether to compile the eflvala library])
if test "$enable_library" != no; then
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
fi

# shall we compile the examples? [default=yes]
AC_ARG_ENABLE(examples,      [  --disable-examples	skip building the examples [[default=no]]])
AM_CONDITIONAL(MAKE_EXAMPLES, test x$enable_examples != xno)
AC_MSG_CHECKING([whether to compile the example apps])
if test "$enable_examples" != no; then
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
fi


AC_CONFIG_FILES([
  Makefile
  data/Makefile
  data/images/Makefile
  data/objects/Makefile
  eflvala/Makefile
  vapi/Makefile
  tests/Makefile
  examples/Makefile
  examples/eina/Makefile
  examples/ecore/Makefile
  examples/ecore-signals/Makefile
  examples/ecore-glib/Makefile
  examples/edje/Makefile
  examples/elementary/Makefile
  examples/library/Makefile
  examples/library/application/Makefile
  examples/library/dialer/Makefile
  examples/library/viewstates/Makefile
  eflvala-1.0.pc])

AC_OUTPUT
