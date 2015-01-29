EXEC = clc
ARCH = 64
CC = gcc
CCFLAGS = -O
LDFLAGS =

ifdef AMDAPPSDKROOT
	CCFLAGS := $(CCFLAGS) -I"$(AMDAPPSDKROOT)/include"
	ifeq ($(ARCH), 64)
		LDFLAGS := $(LDFLAGS) -L"$(AMDAPPSDKROOT)/lib/x86_64" -lOpenCL
	else
		LDFLAGS := $(LDFLAGS) -L"$(AMDAPPSDKROOT)/lib/x86" -lOpenCL
	endif
endif

ifeq ($(OS), Windows_NT)
	EXEC := $(EXEC).exe
	RM = del
else
	RM = rm
	ifeq ($(shell uname -s), Darwin)
		ifndef AMDAPPSDKROOT
			CC = gcc
			LDFLAGS := $(LDFLAGS) -framework OpenCL
		endif
	endif
endif

$(EXEC): clcmpl.o cl_error.o
	$(CC) $^ -o $@ $(LDFLAGS)

clcmpl.o: clcmpl.c cl_error.h Makefile
	$(CC) -c $< -o $@ $(CCFLAGS)

cl_error.o: cl_error.c cl_error.h Makefile
	$(CC) -c $< -o $@ $(CCFLAGS)

clean:
	$(RM) $(EXEC) clcmpl.o cl_error.o

.PHONY: clean
