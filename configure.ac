AC_INIT([libeflvala], [0.0.0.1], [mlauer@vanille-media.de], [libeflvala])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_HEADERS(config.h)
AM_INIT_AUTOMAKE([dist-bzip2])

AC_PROG_CC
AM_PROG_CC_C_O
AC_DISABLE_STATIC
AC_PROG_LIBTOOL

AC_PATH_PROG(VALAC, valac, valac)
AC_SUBST(VALAC)

AC_SUBST(CFLAGS)
AC_SUBST(CPPFLAGS)
AC_SUBST(LDFLAGS)

EVAS_REQUIRED=0.0.0
ECORE_REQUIRED=0.0.0
ELM_REQUIRED=0.0.0
GLIB_REQUIRED=2.18.0

PKG_CHECK_MODULES(DEPS,
  evas >= $EVAS_REQUIRED
  ecore >= $ECORE_REQUIRED
  elementary >= $ELM_REQUIRED
  glib-2.0 >= $GLIB_REQUIRED
  gobject-2.0 >= $GLIB_REQUIRED)
AC_SUBST(DEPS_CFLAGS)
AC_SUBST(DEPS_LIBS)

PKG_CHECK_MODULES(THREAD,
  gthread-2.0 >= $GLIB_REQUIRED)
AC_SUBST(THREAD_CFLAGS)
AC_SUBST(THREAD_LIBS)

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
AM_CONDITIONAL(MAKE_LIBRARY, test "$enable_library" != no)
AC_MSG_CHECKING([whether to compile the eflvala library])
if test "$enable_library" != no; then
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
fi
    
# shall we compile the examples? [default=yes]
AC_ARG_ENABLE(examples,      [  --disable-examples	skip building the examples [[default=no]]])
AM_CONDITIONAL(MAKE_EXAMPLES, test "$enable_examples" != no)
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
  examples/vapi/Makefile
  examples/library/Makefile
  eflvala-1.0.pc])

AC_OUTPUT
