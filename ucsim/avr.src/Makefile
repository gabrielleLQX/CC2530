#
# uCsim avr.src/Makefile
#
# (c) Drotos Daniel, Talker Bt. 1997
#

STARTYEAR	= 1997

SHELL		= /bin/sh
CXX		= g++
CPP		= gcc -E
CXXCPP		= g++ -E
RANLIB		= ranlib
INSTALL		= /usr/bin/install -c

PRJDIR		= ..

DEFS            = $(subs -DHAVE_CONFIG_H,,-DHAVE_CONFIG_H)
CPPFLAGS        =  -I. -I$(PRJDIR) \
		  -I$(PRJDIR)/cmd.src -I$(PRJDIR)/sim.src -I$(PRJDIR)/gui.src
CFLAGS          = -g -O2 -Wall
CXXFLAGS        = -g -O2 -gstabs+ -g3 -pipe -Wall
M_OR_MM         = -MM
PICOPT		= -fPIC
SHAREDLIB	= yes
EXEEXT		= 

LIBS		= -lnsl  -L$(PRJDIR) -Wl,--start-group -lsim -lutil -lcmd -lguiucsim -Wl,--end-group
DL		= -ldl
dl_ok		= yes

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

OBJECTS_SHARED	= glob.o \
		  simavr.o avr.o port.o \
		  inst.o bit_inst.o jump_inst.o move_inst.o logic_inst.o \
		  arith_inst.o
OBJECTS_EXE	= savr.o
OBJECTS		= $(OBJECTS_SHARED) $(OBJECTS_EXE)

enable_dlso	= no
dlso_ok		= no

AVRASM		= tavrasm
TEST_OBJ	= test_bit.hex test_dis.hex test_mov.hex test_jmp.hex \
		  test_arith.hex test_call.hex


# Compiling entire program or any subproject
# ------------------------------------------
all: checkconf otherlibs avr.src


# Compiling and installing everything and runing test
# ---------------------------------------------------
install: all installdirs
	$(INSTALL) -s savr$(EXEEXT) $(DESTDIR)$(bindir)


# Deleting all the installed files
# --------------------------------
uninstall:
	rm -f $(DESTDIR)$(bindir)/savr


# Performing self-test
# --------------------
check: $(TEST_OBJ)

test:


# Performing installation test
# ----------------------------
installcheck:


# Creating installation directories
# ---------------------------------
installdirs:
	test -d $(DESTDIR)$(bindir) || $(INSTALL) -d $(DESTDIR)$(bindir)


# Creating dependencies
# ---------------------
dep: Makefile.dep

Makefile.dep: *.cc *.h
	$(CXXCPP) $(CPPFLAGS) $(M_OR_MM) *.cc >Makefile.dep

include Makefile.dep
include clean.mk

#parser.cc: parser.y

#plex.cc: plex.l

# My rules
# --------
.SUFFIXES: .asm .hex

avr.src: savr$(EXEEXT) shared_lib

savr$(EXEEXT): $(OBJECTS) $(PRJDIR)/*.a
	$(CXX) $(CXXFLAGS) $(OBJECTS) $(LIBS) -o $@

ifeq ($(dlso_ok),yes)
shared_lib: $(PRJDIR)/savr.so
else
shared_lib:
	@$(PRJDIR)/mkecho $(PRJDIR) "No AVR shared lib made."
	@$(PRJDIR)/mkecho $(PRJDIR) "(SHAREDLIB="$(SHAREDLIB)",dl_ok="$(dl_ok)",enable_dlso="$(enable_dlso)")"
endif

$(PRJDIR)/savr.so: $(OBJECTS_SHARED)
	$(CXX) -shared $(OBJECTS_SHARED) -o $(PRJDIR)/savr.so

otherlibs:
	cd $(PRJDIR)/cmd.src && $(MAKE) all
	cd $(PRJDIR)/sim.src && $(MAKE) all

.cc.o:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@

.asm.hex:
	$(AVRASM) -l $< -o $@ -e $<.lst


# Remaking configuration
# ----------------------
checkconf:
	@if [ -f $(PRJDIR)/devel ]; then\
	  $(MAKE) -f conf.mk srcdir="$(srcdir)" PRJDIR="$(PRJDIR)" freshconf;\
	fi

# End of avr.src/Makefile.in
