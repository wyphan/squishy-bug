FC = ftn
FCFLAGSNOOPT = -g -G2 -O0
FCFLAGSOPT = -g -G2 -O1
OMPFLAGS = -homp
LDFLAGS =

default: test

clean:
	-rm -f *.o *.s *.mod

distclean: clean
	-rm -f *.x core
	@echo

all: test

test.O0.x: src.F90
	@echo "Compiling with -O0"
	@echo
	$(FC) $(FCFLAGSNOOPT) $(OMPFLAGS) $< -o $@
	@echo
	@echo "1. This works"
	./test.O0.x 16777215 1
	@echo
	@echo "2. This also works"
	./test.O0.x 16777216 1
	@echo

test.O1.x: src.F90
	@echo "Compiling with -O1"
	@echo
	$(FC) $(FCFLAGSOPT) $(OMPFLAGS) $< -o $@
	@echo
	@echo "3. This works"
	./test.O1.x 16777215 1
	@echo
	@echo "4. This doesn't work"
	./test.O1.x 16777216 1
	@echo

test: distclean test.O0.x test.O1.x
