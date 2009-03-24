include $(top_srcdir)/Makefile.decl

if MAKE_EXAMPLES
  EXAMPLE_SUBDIR = examples
endif

SUBDIRS = vapi eflvala tests $(EXAMPLE_SUBDIR)

NULL =

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = eflvala-1.0.pc

EXTRA_DIST += eflvala-1.0.pc

MAINTAINERCLEANFILES = aclocal.m4 compile config.guess config.sub \
                       configure depcomp install-sh ltmain.sh     \
                       Makefile.in missing config.h.in            \
                       mkinstalldirs \
                       eflvala-1.0.pc \
                       $(NULL)

