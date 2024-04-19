result: .asciz "%ld"
input: .asciz "%ld"

.global main
main:
    # Prologue
    push %rbp
    mov %rsp,%rbp
    
    # ask user for base 
    mov $input, %rdi    # enter format string to rdi (first arg)
    sub $16, %rsp       # reserve space for both inputs
    lea -8(%rbp), %rsi  # rsi points to -8 rbp
    mov $0, %rax        
    call scanf          # (call scanf)
    
    # ask for exp.
    mov $input, %rdi    # enter format string to rdi (first arg)
    lea -16(%rbp), %rsi # rsi points to -16
    mov $0, %rax        
    call scanf          # (call scanf)
    #----
    mov -8(%rbp),  %rdi # base. move first input to rdi
    mov -16(%rbp), %rsi # exp.  move second input to rsi
    
    call pow
    
    mov $result, %rdi   # add format string to printf
    mov %rax, %rsi      # move them to right register
    mov $0, %rax        
    call printf         # call printf
    
    # Epilogue -------
    mov %rbp, %rsp
    pop %rbp

    mov $0, %rdi
    call exit
pow:
    push %rbp
    mov %rsp,%rbp
    mov $1,%rax     

powloop:
    cmpq $0,%rsi    # compare if exp is 0 , gets decremented each loop
    jle exitloop    # if 0 = exit loop

    mulq  %rdi      # multiplies RAX with rdi
    decq  %rsi      # decrement exp
    jmp powloop     # CONTINUE LOOP
    
exitloop:
    mov %rbp, %rsp
    pop %rbp

    ret
    
