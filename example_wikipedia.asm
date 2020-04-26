BITS 64
CPU X64


%define stdout 1
%define syscall_write 0x2000004

; Analog to write(2): ssize_t write(int fildes, const void *buf, size_t nbyte);
%macro write 3
    mov rax, syscall_write
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

        write stdout, query_string, query_string_len

	; read in the character
	mov	rax, 0x2000003		; read system call
	mov	rdi, 0				; stdin
	mov	rsi, in_char		; address for storage, declared in section .bss
	mov	rdx, 2				; get 2 bytes from the kernel's buffer (one for the carriage return)
	syscall

	; show user the output
	mov	rax, 0x2000004		; write system call
	mov	rdi, 1				; stdout
	mov	rsi, out_string
	mov	rdx, out_string_len
	syscall

	mov	rax, 0x2000004		; write system call
	mov	rdi, 1				; stdout
	mov	rsi, in_char
	mov	rdx, 2				; the second byte is to apply the carriage return expected in the string
	syscall

	; exit system call
	mov	rax, 0x2000001		; exit system call
	xor     rdi, rdi
	syscall
