#Set your Kokkos path to something appropriate
KOKKOS_PATH = ${HOME}/Kokkos/kokkos
KOKKOS_DEVICES := "Cuda,OpenMP"
KOKKOS_ARCH := "Volta70"
KOKKOS_CUDA_OPTIONS := enable_lambda
SRC = $(wildcard *.cc)

default: build
	echo "Start Build"

CXXFLAGS = -g -O3 -DUSE_OMP=1 -DRAJA_USE_GETTIME -I./includes -I./
#-fopenmp-targets=amdgcn-amd-amdhsa -Xopenmp-target=amdgcn-amd-amdhsa -march=gfx90a
#-fopenmp -target x86_64-pc-linux-gnu -fopenmp-targets=amdgcn-amd-amdhsa -Xopenmp-target=amdgcn-amd-amdhsa -march=gfx90a

ifeq ( $(USE_MPI), yes)
CXX = mpicxx
CXXFLAGS += -DUSE_MPI=1
else
CXX = ${KOKKOS_PATH}/bin/nvcc_wrapper
CXXFLAGS += -DUSE_MPI=0
endif

LINK = ${CXX}

LINKFLAGS = #-lineinfo
EXE = lulesh.kk

DEPFLAGS = -M

OBJ = $(SRC:.cc=.o)
LIB =

include $(KOKKOS_PATH)/Makefile.kokkos

build: $(EXE)

$(EXE): $(OBJ) $(KOKKOS_LINK_DEPENDS)
	$(LINK) $(KOKKOS_LDFLAGS) $(LINKFLAGS) $(EXTRA_PATH) $(OBJ) $(KOKKOS_LIBS) $(LIB) -o $(EXE)

clean: kokkos-clean
	rm -f *.o

# Compilation rules

%.o:%.cc $(KOKKOS_CPP_DEPENDS) lulesh.h lulesh_tuple.h
	$(CXX) $(KOKKOS_CPPFLAGS) $(KOKKOS_CXXFLAGS) $(CXXFLAGS) $(EXTRA_INC) -c $<



