prefix = /usr
libdir = $(prefix)/lib/bind9

CFLAGS=-fPIC -Wall -g -I../include
MYSQL_LIBS=-lmysqlclient

all: dlz_mysqldyn_mod.so

dlz_dbi.o: ../common/dlz_dbi.c
	$(CC) $(CFLAGS) -c ../common/dlz_dbi.c

dlz_mysqldyn_mod.so: dlz_mysqldyn_mod.c dlz_dbi.o
	$(CC) $(CFLAGS) -shared -o dlz_mysqldyn_mod.so \
		dlz_mysqldyn_mod.c dlz_dbi.o $(MYSQL_LIBS)

clean:
	rm -f dlz_mysqldyn_mod.so *.o

install: dlz_mysqldyn_mod.so
	mkdir -p $(DESTDIR)$(libdir)
	install dlz_mysqldyn_mod.so $(DESTDIR)$(libdir)
