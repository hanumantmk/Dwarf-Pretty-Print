default: test dwarfparse.so

LFLAGS+= -ldl
CFLAGS+= -Wall -Werror -ggdb3 -O0

clean:
	rm -f *.o test dwarfparse.* AutoMakefile

test: dwarfpp.o test.o
	$(CC) $(CFLAGS) $^ -o $@ $(LFLAGS)

dwarfpp.o: Makefile dwarfpp.c dwarfpp.h uthash.h utlist.h utstring.h
	$(CC) $(CFLAGS) -c dwarfpp.c

test.o: Makefile test.c dwarfpp.h test.h uthash.h utlist.h utstring.h
	$(CC) $(CFLAGS) -c test.c

dwarfparse.so: test
	./parse_syms test --li test.c --name foo_t > dwarfparse.c
	gcc -fPIC $(CFLAGS) -c dwarfparse.c
	gcc -fPIC $(CFLAGS) -c dwarfpp.c
	gcc -shared -o dwarfparse.so dwarfparse.o dwarfpp.o
