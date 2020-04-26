BITS 64
CPU X64


%define stdin 0
%define stdout 1
%define syscall_write 0x2000004
%define syscall_read 0x2000003

; Analog to write(2): ssize_t write(int fildes, const void *buf, size_t nbyte);
%macro write 3
    mov rax, syscall_write
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

; Analog to read(2): ssize_t read(int fildes, void *buf, size_t nbyte)
%macro read 3
    mov rax, syscall_read
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

global _start

section .data

	query_string:		db	"Enter a character:  "
	query_string_len:	equ	$ - query_string
	out_string:			db	"You have input:  "
	out_string_len:		equ	$ - out_string

section .bss

	in_char:			resw 4

section .text

_start:
        ; show prompt
        write stdout, query_string, query_string_len

	; read in the character
        read stdin, in_char, 2 ; get 2 bytes from the kernel's buffer (one for the carriage return)
	; show user the output
        write stdout, out_string, out_string_len
        write stdout, in_char, 2 ; the second byte is to apply the carriage return expected in the string

	; exit system call
	mov	rax, 0x2000001		; exit system call
	xor     rdi, rdi
	syscall
