.data
output: .asciz "%ld"
input: .asciz "%ld"

.text
.global main

main:
    # Prologue
    push %rbp
    mov %rsp,%rbp

    # CODE
    # ask user for input
    mov $input, %rdi       # enter format string to rdi (first arg)
    sub $16, %rsp          # reserve space
    lea -8(%rbp), %rsi     # rsi points to -8 rbp so to input
    mov $0, %rax           # (convention)
    call scanf             # (call scanf)
    
    mov -8(%rbp), %rdi         # n
    
    call factorial         # sui
    
    mov $output, %rdi      # move output string to print
    mov %rax, %rsi         # Move factorial output to format string arg
    mov $0, %rax           # (convention)
    call printf            # (call printf)
    
    # Epilogue
    mov %rbp, %rsp
    pop %rbp

    # call exit
    mov $0, %rdi
    call exit
factorial:
    mov %rdi, %rax # set rax to rdi
innerfactorial:
    # prologue
    push %rbp
    mov %rsp, %rbp

    # in case of 0!
    cmpq $0, %rdi
    jle casezero

    dec %rdi             # decrement n
    cmpq $0, %rdi        # compare it with 1 to check for basecase
    jle basecase         # if base case return
    
    push %rdi            # push current number to this stack
    push $0              # just so that stack is 16 bit alligned
    call innerfactorial
    pop %rcx             # just so that stack is 16 bit alligned - to remove the 0
    pop %rdi
    mulq %rdi       

basecase:    
    # Epilogue
    mov %rbp, %rsp
    pop %rbp
    ret
casezero:
    mov %rbp, %rsp
    pop %rbp
    mov $1, %rax
    ret

