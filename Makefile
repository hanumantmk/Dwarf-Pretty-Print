default: AUTOMAKEFILE_DEFAULT dwarfparse.so

-include AutoMakefile

LFLAGS+= -ldl
CFLAGS+= -Wall -Werror -ggdb3 -O0

clean: AUTOMAKEFILE_CLEAN
	rm -f dwarfparse.* AutoMakefile

dwarfparse.so: test
	./parse_syms test --li test.c --name foo_t > dwarfparse.c
	gcc -fPIC $(CFLAGS) -c dwarfparse.c
	gcc -fPIC $(CFLAGS) -c dwarfpp.c
	gcc -shared -o dwarfparse.so dwarfparse.o dwarfpp.o

AutoMakefile: Makefile *.c *.h
	./gen_makefile.pl --makefile_name=Makefile --find_targets -f AutoMakefile

