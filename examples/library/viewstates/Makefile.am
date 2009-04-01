include $(top_srcdir)/Makefile.decl

NULL = 

AUTOMAKE_OPTIONS = subdir-objects

INCLUDES = \
	$(DEPS_CFLAGS) \
	$(THREAD_CFLAGS) \
	-include $(CONFIG_HEADER) \
	$(NULL)

BUILT_SOURCES = .vala.stamp

bin_PROGRAMS = viewstates

viewstates_VALASOURCES = \
	viewstates.vala \
	$(NULL)

viewstates_SOURCES = \
	$(viewstates_VALASOURCES:.vala=.c) \
	$(viewstates_VALASOURCES:.vala=.h) \
	\
	$(NULL)

.vala.stamp: $(viewstates_VALASOURCES)
	$(VALAC) -c --vapidir $(top_srcdir)/vapi \
	            --vapidir ../../../eflvala \
	            --pkg dbus-glib-1 \
	            --pkg eflvala-1.0 \
	            --pkg eina \
	            --pkg evas \
	            --pkg ecore \
	            --pkg elm \
	            --save-temps \
	            --thread \
	            --basedir $(top_srcdir) $^
	touch $@

viewstates_LDADD = \
	$(DEPS_LIBS) \
	$(THREAD_LIBS) \
	../../../eflvala/libeflvala.la \
	$(NULL)

EXTRA_DIST += \
	$(viewstates_VALASOURCES) \
	.vala.stamp \
	$(NULL)

CLEANFILES = \
	*.c \
	*.h \
	.vala.stamp \
	$(NULL)

DISTCLEANFILES = \
	$(NULL)

MAINTAINERCLEANFILES = \
	Makefile.in \
	$(NULL)
