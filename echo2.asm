# as echo2.asm -o echo2.o && ld -lSystem echo2.o -o echo2.exe
.section __TEXT,__text

.globl _main
_main:
    # prolog
    pushq %rbp
    movq %rsp, %rbp

    movq 8(%rsi), %rdi # argv[1]
    
    callq _puts

    xorl %eax, %eax

    # epilog
    popq %rbp
    retq
