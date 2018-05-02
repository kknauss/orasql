CC = gcc-3
CFLAGS = -mno-cygwin 
OBJ=sqldp.o
SRC=sqldp.c
EXE=sqldp.exe

all:	sqldp

clean:
	rm -f *.o $(EXE)

install: $(EXE)
	install -m 0755 $(EXE) ../

.PHONY:	install

$(EXE):	$(OBJ)
	$(CC) $(CFLAGS) $(SRC) -o $(EXE)
