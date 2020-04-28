.POSIX:

.SUFFIXES:
.SUFFIXES: .nasm .exe .o

FORMAT = macho64

.nasm.o:
	nasm -f $(FORMAT) $<

.o.exe:
	ld -e main -lc $< -o $@

.PHONY: clean
clean:
	rm -f *.o *.exe

