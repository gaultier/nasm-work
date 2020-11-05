.text

// rax: integer argumet
// Returns: void
// No stack usage
// Uses int_to_string_data
print_int: 
    pushq %rbp
    movq %rsp, %rbp

    subq $32, %rsp // char data[21]
  
    xorq %r8, %r8 // r8: Loop index and length
    movq %rsp, %rsi // end ptr
    
    int_to_string_loop:
        cmpq $0, %rax // While n != 0
        jz int_to_string_end

        decq %rsi // end--

        // n / 10
        movq $10, %rcx 
        xorq %rdx, %rdx
        idiv %rcx
    
        // *end = rem + '0'
        add $48, %rdx // Convert integer to character by adding '0'
        movb %dl, (%rsi)

        incq %r8 // len++
        jmp int_to_string_loop

    int_to_string_end:
      movq $0x2000004, %rax
      movq $1, %rdi
      movq %r8, %rdx
      movq %rsp, %rsi
      subq %r8, %rsi

      syscall
      xorq %rax, %rax

      // Epilog
      addq $32, %rsp
      popq %rbp
      ret
    

.global _main
_main:
    pushq %rbp
    movq %rsp, %rbp

    movq $789, %rax
    call print_int


    movq $12, %rax
    call print_int

    popq %rbp
    ret

