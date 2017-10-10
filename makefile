###################################################################################
#Define all the compilers and their options
FC= ifort
MPIFC= mpif90
FFLAGS= -g -O3 -i8 -r8 -w -no-wrap-margin -module ../build/modules
FLIBS_PAR=-L${MKLROOT}/lib/intel64 -mkl=sequential -lmkl_rt -lpthread -lm -ldl
FLIBS_SEQ=-L${MKLROOT}/lib/intel64 -mkl=sequential -lmkl_rt -lpthread -lm -ldl
INCLUDE= -I${MKLROOT}/include
BUILDDIR= ../build
OBJDIR= ../build/objects

###################################################################################
#List the object files and their dependencies
#Define some variables with common files
COMFILES= $(OBJDIR)/blas.o $(OBJDIR)/linpack.o $(OBJDIR)/timer.o \
	$(OBJDIR)/lbfgsb.o $(OBJDIR)/nr_fft.o \
	$(OBJDIR)/verletmodule.o

#1D double well potential:
1DFILES= $(OBJDIR)/mcmod_1d.o

#Malonaldehyde:
MALONFILES= $(OBJDIR)/pes_malonaldehyde.o $(OBJDIR)/mcmod_malon.o

#Malonaldehyde Wang:
# $(OBJDIR)/mcmod_wmalon.o: mcmod_wmalon.f90
# 	$(FC) -c $(FFLAGS) $(WMALONFLAGS) $< -o $@

WMALONFILES= $(OBJDIR)/mcmod_wmalon.o
FFLAGS+= -O -I./mod_malon
WMALONLIBS= -L. -lpes

#Water dimer:
WATDIMFILES= $(OBJDIR)/mcmod_waterdimer.o
WATDIMLIBS= -L../../Water/ -lmbpol -cxxlib

#Methane Clathrate:
CLATHFILES= $(OBJDIR)/watermethane.o $(OBJDIR)/mcmod_clathrate.o

#Compilation commands for object files
$(OBJDIR)/%.o: %.f
	$(FC) -c $(FFLAGS) $< -o $@

$(OBJDIR)/%.o: %.f90
	$(FC) -c $(FFLAGS) $< -o $@

$(OBJDIR)/pimd_par.o: pimd_par.f90
	$(MPIFC) -c $(FFLAGS) $< -o $@


###################################################################################
#Rules for the final executables

#1D double well potential:
pimd_1d_par: $(1DFILES) $(COMFILES) $(OBJDIR)/pimd_par.o
	$(MPIFC) $(FFLAGS) $(COMFILES) $(1DFILES) $(OBJDIR)/pimd_par.o -o $(BUILDDIR)/$@ $(FLIBS_PAR)

pimd_1d_ser: $(1DFILES) $(COMFILES) $(OBJDIR)/pimd_ser.o
	$(FC) $(FFLAGS) $(COMFILES) $(1DFILES) $(OBJDIR)/pimd_ser.o -o $(BUILDDIR)/$@ $(FLIBS_SEQ)


#Malonaldehyde:
pimd_malon_par: $(MALONFILES) $(COMFILES) $(OBJDIR)/pimd_par.o
	$(MPIFC) $(FFLAGS) $(COMFILES) $(MALONFILES) $(OBJDIR)/pimd_par.o -o $(BUILDDIR)/$@ $(FLIBS_PAR)

pimd_malon_ser: $(MALONFILES) $(COMFILES) $(OBJDIR)/pimd_ser.o
	$(FC) $(FFLAGS) $(COMFILES) $(MALONFILES) $(OBJDIR)/pimd_ser.o -o $(BUILDDIR)/$@ $(FLIBS_SEQ)

rpi_malon: $(MALONFILES) $(COMFILES) $(OBJDIR)/rpi.o
	$(FC) $(FFLAGS) $(COMFILES) $(MALONFILES) $(OBJDIR)/rpi.o -o $(BUILDDIR)/$@ $(FLIBS_SEQ)

#Wang Malonaldehyde:
pimd_wmalon_par: $(WMALONFILES) $(COMFILES) $(OBJDIR)/pimd_par.o
	$(MPIFC) $(FFLAGS) $(WMALONFLAGS) $(COMFILES) $(WMALONFILES) $(OBJDIR)/pimd_par.o -o $(BUILDDIR)/$@  $(WMALONLIBS) $(FLIBS_PAR)

pimd_wmalon_ser: $(WMALONFILES) $(COMFILES) $(OBJDIR)/pimd_ser.o
	$(FC) $(FFLAGS) $(WMALONFLAGS) $(COMFILES) $(WMALONFILES) $(OBJDIR)/pimd_ser.o -o $(BUILDDIR)/$@ $(WMALONLIBS) $(FLIBS_SEQ)

#Water Dimer:
pimd_watdim_par: $(WATDIMFILES) $(COMFILES) $(OBJDIR)/pimd_par.o
	$(MPIFC) $(FFLAGS) $(COMFILES) $(WATDIMFILES) $(OBJDIR)/pimd_par.o -o $(BUILDDIR)/$@ $(FLIBS_PAR) $(WATDIMLIBS)

pimd_watdim_ser: $(MALONFILES) $(COMFILES) $(OBJDIR)/pimd_ser.o
	$(FC) $(FFLAGS) $(COMFILES) $(MALONFILES) $(OBJDIR)/pimd_ser.o -o $(BUILDDIR)/$@ $(FLIBS_SEQ) $(WATDIMLIBS)

#Clathrate
pimd_clath_par: $(CLATHFILES) $(COMFILES) $(OBJDIR)/pimd_par.o
	$(MPIFC) $(FFLAGS) $(COMFILES) $(CLATHFILES) $(OBJDIR)/pimd_par.o -o $(BUILDDIR)/$@ $(FLIBS_PAR) $(WATDIMLIBS)

pimd_clath_ser: $(CLATHFILES) $(COMFILES) $(OBJDIR)/pimd_ser.o
	$(FC) $(FFLAGS) $(COMFILES) $(CLATHFILES) $(OBJDIR)/pimd_ser.o -o $(BUILDDIR)/$@ $(FLIBS_SEQ) $(WATDIMLIBS)


.PHONY: clean

clean:
	rm -f *.o
