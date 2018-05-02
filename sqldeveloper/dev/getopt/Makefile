CC = gcc
CFLAGS = -DDEBUG -DNOEXEC -mno-cygwin 
OBJ=mygetopt.o
SRC=mygetopt.c
EXE=mygetopt.exe

all:	mygetopt

clean:
	rm -f *.o $(EXE)

install: $(EXE)
	install -m 0755 $(EXE) ../

.PHONY:	install

$(EXE):	$(OBJ)
	$(CC) $(CFLAGS) $(SRC) -o $(EXE)

#	cp -p $(EXE) ../
