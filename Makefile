.POSIX:

.SUFFIXES:
.SUFFIXES: .asm .exe .o

FORMAT = macho64

.asm.o:
	nasm -f $(FORMAT) $<

.o.exe:
	ld -e _start -static $< -o $@

.PHONY: clean
clean:
	rm -f *.o *.exe

