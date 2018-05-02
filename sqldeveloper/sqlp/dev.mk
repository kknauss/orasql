CC = gcc-3
CFLAGS = -DDEBUG -DNOEXEC -mno-cygwin 
OBJ=sqlpl.o
SRC=sqlpl.c
EXE=sqlpl.exe

all:	sqlpl

clean:
	rm -f *.o $(EXE)

install: $(EXE)
	install -m 0755 $(EXE) ../

.PHONY:	install

$(EXE):	$(OBJ)
	$(CC) $(CFLAGS) $(SRC) -o $(EXE)
