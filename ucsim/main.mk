#
# S51 main.mk
#
# (c) Drotos Daniel, Talker Bt. 1997,99
#

STARTYEAR	= 1997

SHELL		= /bin/sh
CXX		= g++
#CPP		= gcc -E
CXXCPP		= g++ -E
RANLIB		= ranlib
INSTALL		= /usr/bin/install -c

PRJDIR		= .
SIMDIR		= sim.src
CMDDIR		= cmd.src
GUIDIR		= gui.src

DEFS            = $(subs -DHAVE_CONFIG_H,,-DHAVE_CONFIG_H)
# FIXME: -Imcs51 must be removed!!!
CPPFLAGS        =  -I$(PRJDIR) -I$(PRJDIR)/$(SIMDIR) \
		  -I$(CMDDIR) -I$(GUIDIR)
CFLAGS          = -g -O2 -I$(PRJDIR) -Wall
CXXFLAGS        = -g -O2 -gstabs+ -g3 -pipe -I$(PRJDIR) -Wall
M_OR_MM         = -MM

EXEEXT		= 

LIB_LIST	= util cmd sim
UCSIM_LIBS	= -Wl,--start-group $(patsubst %,-l%,$(LIB_LIST)) -Wl,--end-group
UCSIM_LIB_FILES	= $(patsubst %,lib%.a,$(LIB_LIST))

prefix          = /usr/local
exec_prefix     = ${prefix}
bindir          = ${exec_prefix}/bin
libdir          = ${exec_prefix}/lib
datadir         = ${prefix}/share
includedir      = ${prefix}/include
mandir          = ${prefix}/man
man1dir         = $(mandir)/man1
man2dir         = $(mandir)/man2
infodir         = ${prefix}/info
srcdir          = .

OBJECTS         = pobj.o globals.o utils.o error.o app.o option.o
SOURCES		= $(patsubst %.o,%.cc,$(OBJECTS))
UCSIM_OBJECTS	= ucsim.o
UCSIM_SOURCES	= $(patsubst %.o,%.cc,$(UCSIM_OBJECTS))
ALL_SOURCES	= $(SOURCES) $(UCSIM_SOURCES)

enable_ucsim	= no


# Compiling entire program or any subproject
# ------------------------------------------
all: checkconf libs

libs: libutil.a

main_app: checkconf ucsim_app

# Compiling and installing everything and runing test
# ---------------------------------------------------
install: all installdirs


# Deleting all the installed files
# --------------------------------
uninstall:
	rm -f $(DESTDIR)$(bindir)/s51$(EXEEXT)
	rm -f $(DESTDIR)$(bindir)/savr$(EXEEXT)
	rm -f $(DESTDIR)$(bindir)/serialview$(EXEEXT)
	rm -f $(DESTDIR)$(bindir)/portmon$(EXEEXT)


# Performing self-test
# --------------------
check:

test:

# Performing installation test
# ----------------------------
installcheck:


# Creating installation directories
# ---------------------------------
installdirs:


# Creating dependencies
# ---------------------
dep: main.dep

main.dep: $(ALL_SOURCES) *.h
	$(CXXCPP) $(CPPFLAGS) $(M_OR_MM) $(ALL_SOURCES) >main.dep

include main.dep
include clean.mk

#parser.cc: parser.y

#plex.cc: plex.l

# My rules
# --------
libutil.a: $(OBJECTS)
	ar -rcu $*.a $(OBJECTS)
	$(RANLIB) $*.a


ifeq ($(enable_ucsim),yes)
ucsim_app: libs ucsim
else
ucsim_app:
endif

ucsim: $(UCSIM_OBJECTS) $(UCSIM_LIB_FILES)
	echo $(UCSIM_LIB_FILES)
	$(CXX) $(CXXFLAGS) -o $@ $< -L$(PRJDIR) $(UCSIM_LIBS)

ptt: ptt.o
	$(CXX) $(CXXFLAGS) -o $@ $< -lpthread
.cc.o:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@


# Remaking configuration
# ----------------------
checkconf:
	@if [ -f devel ]; then\
	  $(PRJDIR)/mkecho $(PRJDIR) "MAIN.MK checkconf";\
	  $(MAKE) -f conf.mk srcdir="$(srcdir)" freshconf;\
	fi

# End of main_in.mk/main.mk
