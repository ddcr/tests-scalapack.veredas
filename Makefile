#
#Copyright (C) 2018 by Domingos Rodrigues <ddcr@lcc.ufmg.br> LCC-CENPAD/MG
#
# Template file
#

SHELL = /bin/sh
DEFS = -DPACKAGE_NAME=\"scalapack\" -DPACKAGE_TARNAME=\"scalapack\" -DPACKAGE_VERSION=\"2.0.2\" -DPACKAGE_STRING=\"scalapack\ 2.0.2\" -DPACKAGE_BUGREPORT=\"https://github.com/openhpc/ohpc\" -DPACKAGE_URL=\"\" -DPACKAGE=\"scalapack\" -DVERSION=\"2.0.2\" -DHAVE_LIBOPENBLAS=1

#
# Choose compilation type: Intel framework (mpiifort) | GNU framework (mpif90)
#
COMPILER_TYPE ?= gnu5

#
# We use the LMOD system to set up the shell environment (e.g. PATH, 
# LD_LIBRARY_PATH, and othe environment variables). This is necessary
# for packages and/or compilers installed in nonstandard locations
#

ifeq ($(COMPILER_TYPE), intel)
############################################
# Intel MPI compilers
# Need to load the corresponding modulefiles
# module purge
# module load intel/14.0.1
############################################
CC  := icc
CXX := icpc
FC  := ifort

CXXFLAGS := 
CFLAGS   := 
FFLAGS   := 
endif

ifeq ($(COMPILER_TYPE), gnu5)
############################################
# GCC
# Need to load the corresponding modulefiles
# module purge
# module load gcc/5.4.0
# module load openblas
############################################

CC  := mpicc
CXX := mpicxx
FC  := mpif90
F77 := mpif77

CCLD  := $(CC)
CXXLD := $(CXX)
F77LD := $(F77)

GNU_LIBDIR := /usr/local/ohpc/pub/compiler/gcc/5.4.0/lib64
LDADD =

#LDFLAGS = -L/usr/local/ohpc/pub/libs/gnu/mvapich2/scalapack/2.0.2/lib -L/usr/local/ohpc/pub/libs/gnu/openblas/0.2.19/lib
#LIBOBJS = 
#LIBS = -lopenblas -lscalapack -lopenblas 



CPPFLAGS =
CXXFLAGS := -O2
CFLAGS   := -O2
FFLAGS   := -O2
LDFLAGS  := -Wl,-rpath,$(GNU_LIBDIR) -Wl,-rpath,$(OPENBLAS_LIB) -Wl,-rpath,$(SCALAPACK_LIB)
LDFLAGS  += -w -L$(OPENBLAS_LIB) -L$(SCALAPACK_LIB)
LIBS     := -lopenblas_omp -lscalapack

AM_CPPFLAGS =
AM_CXXFLAGS =
AM_CFLAGS   = 
AM_FFLAGS   =

COMPILE    := $(CC)  $(DEFS) -I. $(INCLUDES) $(AM_CPPFLAGS) $(CPPFLAGS) $(AM_CFLAGS)   $(CFLAGS)
CXXCOMPILE := $(CXX) $(DEFS) -I. $(INCLUDES) $(AM_CPPFLAGS) $(CPPFLAGS) $(AM_CXXFLAGS) $(CXXFLAGS)
F77COMPILE := $(F77) $(AM_FFLAGS) $(FFLAGS)

LINK    = $(CCLD)  $(AM_CFLAGS)   $(CFLAGS)   $(LDFLAGS) -o $@
CXXLINK = $(CXXLD) $(AM_CXXFLAGS) $(CXXFLAGS) $(LDFLAGS) -o $@
F77LINK = $(F77LD) $(AM_FFLAGS)   $(FFLAGS)   $(LDFLAGS) -o $@
endif


CC_V = @echo "  CC  " $@;
CXX_V = @echo "  CXX  " $@;
F77_V = @echo "  F77  " $@;
CC_V =
CXX_V =
F77_V =

F77LD_V = @echo "  F77LD  " $@;
CXXLD_V = @echo "  CXXLD  " $@;
F77LD_V =
CXXLD_V =

#-------------------------------------------------------------------------------------
EXEEXT=.x
BUILD_DIR = build

PROGRAMS = psscaex$(EXEEXT) pdscaex$(EXEEXT) pcscaex$(EXEEXT) \
	   pzscaex$(EXEEXT)

pcscaex_OBJECTS = pcscaex.o pdscaexinfo.o
pdscaex_OBJECTS = pdscaex.o pdscaexinfo.o
psscaex_OBJECTS = psscaex.o pdscaexinfo.o
pzscaex_OBJECTS = pzscaex.o pdscaexinfo.o

psscaex_SOURCES = psscaex.f pdscaexinfo.f
pdscaex_SOURCES = pdscaex.f pdscaexinfo.f
pcscaex_SOURCES = pcscaex.f pdscaexinfo.f
pzscaex_SOURCES = pzscaex.f pdscaexinfo.f

SOURCES = $(pcscaex_SOURCES) $(pdscaex_SOURCES) $(psscaex_SOURCES) \
	  $(pzscaex_SOURCES)

pcscaex$(EXEEXT): $(pcscaex_OBJECTS) $(pcscaex_DEPENDENCIES) $(EXTRA_pcscaex_DEPENDENCIES) 
	@rm -f pcscaex$(EXEEXT)
	$(F77LD_V)$(F77LINK) $(pcscaex_OBJECTS) $(LDADD) $(LIBS)

pdscaex$(EXEEXT): $(pdscaex_OBJECTS) $(pdscaex_DEPENDENCIES) $(EXTRA_pdscaex_DEPENDENCIES) 
	@rm -f pdscaex$(EXEEXT)
	$(F77LD_V)$(F77LINK) $(pdscaex_OBJECTS) $(LDADD) $(LIBS)

psscaex$(EXEEXT): $(psscaex_OBJECTS) $(psscaex_DEPENDENCIES) $(EXTRA_psscaex_DEPENDENCIES) 
	@rm -f psscaex$(EXEEXT)
	$(F77LD_V)$(F77LINK) $(psscaex_OBJECTS) $(LDADD) $(LIBS)

pzscaex$(EXEEXT): $(pzscaex_OBJECTS) $(pzscaex_DEPENDENCIES) $(EXTRA_pzscaex_DEPENDENCIES) 
	@rm -f pzscaex$(EXEEXT)
	$(F77LD_V)$(F77LINK) $(pzscaex_OBJECTS) $(LDADD) $(LIBS)

#-------------------------------------------------------------------------------------

#-----------------------------------------------------------------------
help:
ifeq ($(COMPILER_TYPE), intel)
	@echo "Para compiladores da Intel MPI não esquecer executar:"
	@echo "a) module purge                                      "
	@echo "b) module load intel                                 "
endif
ifeq ($(COMPILER_TYPE), gnu5)
	@echo "Para compiladores GNU/mvapich2 não esquecer executar:"
	@echo "a) module purge                                      "
	@echo "b) module load gnu                                   "
	@echo "c) module load mvapich2                              "
	@echo "d) module load scalapack                             "
endif
	@echo "Para verificar os modulos carregados:                "
	@echo " module list                                         "
	@echo "                                                     "
	@echo "Para compilar codigo fonte:                          "
	@echo "  make clean                                         "
	@echo "  make all                                           "
#-----------------------------------------------------------------------

all: $(PROGRAMS)

#--------------------------------------------------------------------------------------
DEPDIR := .deps
$(shell mkdir -p $(DEPDIR) >/dev/null)
DEPFLAGS = -MT $@ -MD -MP -MF $(DEPDIR)/$*.Tpo

# c source
.c.o:   $(DEPDIR)/%.Po
	$(CC_V)$(COMPILE) $(DEPFLAGS) -c -o $@ $<
	@mv -f $(DEPDIR)/$*.Tpo $(DEPDIR)/$*.Po && touch $@

# c++ source
.cpp.o: $(DEPDIR)/%.Po
	$(CXX_V)$(CXXCOMPILE) $(DEPFLAGS) -c -o $@ $<
	@mv -f $(DEPDIR)/$*.Tpo $(DEPDIR)/$*.Po && touch $@

# fortran source
.f.o:
	$(F77_V)$(F77COMPILE) -c -o $@ $<

$(DEPDIR)/%.Po: ;
.PRECIOUS: $(DEPDIR)/%.Po

include $(wildcard $(patsubst %,$(DEPDIR)/%.Po,$(basename $(SOURCES))))
#--------------------------------------------------------------------------------------

clean-PROGRAMS:
	-test -z "$(PROGRAMS)" || rm -f $(PROGRAMS)
clean-generic:

clean-compile:
	-rm -f *.o

clean: clean-PROGRAMS clean-compile

.DEFAULT_GOAL := help  
.SUFFIXES:
.SUFFIXES: .c .cpp .f .o .obj

.PHONY: clean-PROGRAMS clean-compile
.SECONDARY:

MKDIR_P ?= mkdir -p
