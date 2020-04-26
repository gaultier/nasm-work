.SUFFIXES:
.SUFFIXES: .asm .exe .o

.asm.o:
	nasm -f macho64 $<

.o.exe:
	ld -e _start -static $< -o $@

.PHONY: clean
clean:
	rm *.o *.exe

