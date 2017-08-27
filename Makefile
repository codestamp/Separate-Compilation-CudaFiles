NVCC=nvcc

CUDA_INCLUDEPATH=/usr/local/cuda/include

NVCC_OPTS=-O3 -arch=sm_20 -Xcompiler -Wall -Xcompiler -Wextra -m64 -Wno-deprecated-gpu-targets

GCC_OPTS=-O3 -Wall -Wextra -m64

hw: main.o vectoradd.o 
	$(NVCC) -o hw main.o vectoradd.o 

vectoradd.o: vectoradd.cu kernel.h
	$(NVCC) -c vectoradd.cu $(NVCC_OPTS)

main.o: main.cpp kernel.h
	g++ -c main.cpp -I $(GCC_OPTS) -I $(CUDA_INCLUDEPATH)

clean:
	rm -f *.o hw

