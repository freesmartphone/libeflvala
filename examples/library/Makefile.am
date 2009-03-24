include $(top_srcdir)/Makefile.decl

NULL = 

AUTOMAKE_OPTIONS = subdir-objects

INCLUDES = \
	$(DEPS_CFLAGS) \
	$(THREAD_CFLAGS) \
	-include $(CONFIG_HEADER) \
	$(NULL)

BUILT_SOURCES = .vala.stamp

bin_PROGRAMS = mainloops

mainloops_VALASOURCES = \
	mainloops.vala \
	$(NULL)

mainloops_SOURCES = \
	$(mainloops_VALASOURCES:.vala=.c) \
	$(mainloops_VALASOURCES:.vala=.h) \
	\
	$(NULL)

.vala.stamp: $(mainloops_VALASOURCES)
	$(VALAC) -c --vapidir $(top_srcdir)/vapi \
	            --vapidir ../../eflvala \
	            --pkg dbus-glib-1 \
	            --pkg eflvala-1.0 \
	            --pkg eina \
	            --pkg evas \
	            --pkg ecore \
	            --pkg elm \
	            --pkg posix \
	            --save-temps \
	            --thread \
	            --basedir $(top_srcdir) $^
	touch $@

mainloops_LDADD = \
	$(DEPS_LIBS) \
	$(THREAD_LIBS) \
	../../eflvala/libeflvala.la \
	$(NULL)

EXTRA_DIST += \
	$(mainloops_VALASOURCES) \
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
