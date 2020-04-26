; Prompt for a character on stdin and show it

BITS 64
CPU X64
DEFAULT REL


%define stdin 0
%define stdout 1
%define stderr 2
%define syscall_exit 0x2000001
%define syscall_read 0x2000003
%define syscall_write 0x2000004

; Analog to write(2): ssize_t write(int fildes, const void *buf, size_t nbyte);
%macro write 3
    mov rax, syscall_write
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
    mov rdx, rax,
    cmp rdx, 0
    jl error
%endmacro

; Analog to read(2): ssize_t read(int fildes, void *buf, size_t nbyte)
%macro read 3
    mov rax, syscall_read
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
    mov rdx, rax,
    cmp rdx, 0
    jl error
%endmacro

%macro exit 1
    mov rdi, %1
    mov rax, syscall_exit
    syscall
%endmacro

; rdi=n 
; rsi=res string 
; rdx = res string len
uint_to_string:
        mov rax, rdi
        mov rcx, 10
        div rcx
        add rdi, 48
        mov [rdi], rdx
        xor rax, rax
        xor rdx, rdx
        ret

sum:
    add rdi, rdi
    mov rax, rdi
    ret

global _start

section .data

	query_string:		db	"Enter a character:  "
	query_string_len:	equ	$ - query_string
	out_string:			db	"You have input:  "
	out_string_len:		equ	$ - out_string
        err_string: db "Error with syscall"
        err_string_len: equ $- err_string
        bytes_read_string: db "Bytes read: "
        bytes_read_string_len: equ $ - bytes_read_string

section .bss

	in_char:			resw 1 + 4
        in_char_string resw 256

section .text

_start:
        ; show prompt
        write stdout, query_string, query_string_len

	; read in the character
        read stdin, in_char, 5 ; get 5 bytes from the kernel's buffer (one for the carriage return)
        mov r8, rax ; remember how many bytes were read

	; show user the output
        write stdout, out_string, out_string_len
        write stdout, in_char, 5

        write stdout, bytes_read_string, bytes_read_string_len

        ;mov rdi, r8
        ;mov rsi, in_char_string
        ;mov rdx, 5
        ;align 16
        ;call uint_to_string
        ;mov [in_char_string], BYTE 0
        ;mov [in_char_string + 1], BYTE 0
        ;mov [in_char_string + 2], BYTE 0
        ;mov [in_char_string + 3], BYTE 0
        ;mov [in_char_string + 4], BYTE 0
        mov rdi, 55
        call sum
        mov [in_char_string], rax
        write stdout, in_char_string, 1

	exit 0

error:
    write stderr, err_string, err_string_len
    exit rdx
