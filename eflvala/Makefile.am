include $(top_srcdir)/Makefile.decl

NULL = 

AUTOMAKE_OPTIONS = subdir-objects

vapidir = $(datadir)/vala/vapi

dist_vapi_DATA = \
	eflvala-1.0.vapi \
	$(NULL)
                
SUBDIRS = \
	$(NULL)

INCLUDES = \
	$(DEPS_CFLAGS) \
	-include $(CONFIG_HEADER) \
	$(NULL)

eflvalaincludedir = $(includedir)/eflvala-1.0/eflvala
eflvalainclude_HEADERS = \
	$(libeflvala_la_VALASOURCES:.vala=.h) \
	$(NULL)

BUILT_SOURCES = .vala.stamp

lib_LTLIBRARIES = \
	libeflvala.la \
	$(NULL)

libeflvala_la_VALASOURCES = \
	application.vala \
	notificationqueue.vala \
	objects.vala \
	thread.vala \
	statemachine.vala \
	$(NULL)

libeflvala_la_SOURCES = \
	$(libeflvala_la_VALASOURCES:.vala=.c) \
	$(libeflvala_la_VALASOURCES:.vala=.h) \
	\
	$(NULL)

.vala.stamp: $(libeflvala_la_VALASOURCES)
	$(VALAC) -c --vapidir $(top_srcdir)/vapi \
		--pkg dbus-glib-1 \
		--pkg eina \
		--pkg evas \
		--pkg ecore \
		--pkg elm \
		--pkg posix \
		--library=eflvala-1.0 \
		--save-temps \
		--thread \
		--basedir $(top_srcdir) $^
	touch $@

libeflvala_la_LIBADD = \
	$(DEPS_LIBS) \
	-lutil \
	$(NULL)

EXTRA_DIST += \
	eflvala-1.0.pc.in \
	eflvala-1.0.vapi \
	$(libeflvala_la_VALASOURCES) \
	$(BUILT_SOURCES) \
	$(NULL)

CLEANFILES = \
	*.c \
	*.h \
	$(BUILT_SOURCES) \
	$(NULL)

DISTCLEANFILES = \
	$(NULL)

MAINTAINERCLEANFILES = \
	Makefile.in \
	eflvala-1.0.gir \
	eflvala-1.0.vapi \
	$(NULL)
