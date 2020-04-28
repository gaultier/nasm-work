.POSIX:

.SUFFIXES:
.SUFFIXES: .nasm .exe .o

FORMAT = macho64
LDFLAGS = -lSystem

.nasm.o:
	nasm -f $(FORMAT) $<

.o.exe:
	$(LD) $(LDFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -f *.o *.exe

