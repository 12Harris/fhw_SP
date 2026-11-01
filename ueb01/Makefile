# -------------------------- #
# Fachhochschule Wedel       #
# SP-Uebung, Aufgabe 1       #
# Author: aan, avh, mhe, tti #
#                            #
# Makefile                   #
# -------------------------- #

# Source codes
SOURCE = ueb01.c

# Target name
BINARY = ueb01

# Bats Device Under Test
DUT = $(BINARY)

# Flag that states that warnings will not lead to compilation errors
FORCE = false

# Compiler
CC = gcc

# Doc generator
DOC = doxygen

# Compiler flags
CFLAGS_BASE = -c -g -std=c11 -pedantic -Wall -Wextra -Wvla
CFLAGS_VARS =
ifeq ($(FORCE),true)
CFLAGS = $(CFLAGS_BASE) $(CFLAGS_VARS)
else
CFLAGS = $(CFLAGS_BASE) -Werror $(CFLAGS_VARS)
endif

# Linker flags
LDFLAGS =

# Object files
OBJECTS = $(SOURCE:.c=.o)

.PHONY: default all force test doc clean help

default: all

# Create program
all: $(BINARY)

# Create program, compile without -Werror
force:
	@make all FORCE=true

# Run Bats tests
test: $(DUT)
	@echo "  Running Bats tests"
	@./runBats "./$(DUT)" ./test/*.bats
	@echo "  ... done"

# Create html documentation
doc:
	@echo "  Creating documentation"
	$(DOC)
	@echo "  ... done"

# Clean the project
clean:
	@echo "  Deleting all generated files"
	rm -f $(OBJECTS) $(BINARY) *~ doxygen.log
	rm -rf doc/
	@echo "  ... done"

# Show help
help:
	@echo "Options:"
	@echo "make all         - create program (default target)"
	@echo "make force       - compile without -Werror"
	@echo "make test        - run Bats tests"
	@echo "make doc         - create documentation"
	@echo "make clean       - clean up"

# Compile a single file with a header file
%.o : %.c %.h
	@echo "  Building $@"
	$(CC) $(CFLAGS) -o $@ $<
	@echo "  ... done"

# Compile a single file without a header file
%.o : %.c
	@echo "  Building $@"
	$(CC) $(CFLAGS) -o $@ $<
	@echo "  ... done"

# Link files to an executable
$(BINARY) : $(OBJECTS)
	@echo "  Linking $@"
	$(CC) $(OBJECTS) -o $(BINARY) $(LDFLAGS)
	@echo "  ... done"

