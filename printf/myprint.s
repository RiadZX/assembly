
.data
pc: .string "%"
x: .string "Hello %s %d %u"
y: .string "World!"
.text
.global main

main:
    push %rbp
    mov %rsp,%rbp

    mov $x, %rdi
    mov $y, %rsi
    mov $-20,%rdx
    mov $4444,%rcx

    call my_printf

    mov %rbp, %rsp
    pop %rbp
    ret

my_printf:
    # Prologue
    push %rbp
    mov %rsp,%rbp
    
    #Arguments pushed on the stack
    push %r9
    push %r8
    push %rcx
    push %rdx
    push %rsi
    
    #Registers to be saved before returning.
    push %r15
    push %r14
    push %r13
    push %r12
    push %r11
    push %r10
    push %r10

    #setup.
    mov $0,   %r15  #string iterator
    mov $0,   %r14  #Format Counter.
    mov $0,   %r13  #Current character from string.

    my_print_loop:
        push %rdi
        push %rdi
        
        lea (%rdi,%r15,1),%r13 #this now stores the character address.
        mov (%r13),%r12 #this stores the actual character and not the address.

        cmpb $0,%r12b
        je exit_my_print

        cmpb $0x25,%r12b #if character is a %, then we have to do special formatting stuff.
        je format_print 

        push %rdi
        push %rsi
        push %rcx
        push %rdx
        push %r8
        push %r9
        push %r10
        push %r11
        mov %r13,%rdi #we need to pass the address instead of the value.
        call print_char
        pop %r11
        pop %r10
        pop %r9
        pop %r8
        pop %rdx
        pop %rcx
        pop %rsi
        pop %rdi
    my_print_continue:
        inc %r15
        pop %rdi
        pop %rdi
        
        jmp my_print_loop

    exit_my_print:
        #exit program
        pop %rdi
        pop %rdi
    
        pop %r10
        pop %r10
        pop %r11
        pop %r12
        pop %r13
        pop %r14
        pop %r15
        
        pop %rsi
        pop %rdx
        pop %rcx
        pop %r8
        pop %r9
        
        mov %rbp, %rsp
        pop %rbp
        ret

print_string:
    # Prologue
    push %rbp
    mov %rsp,%rbp
    
    push %r14
    push %r15

    movq %rdi, %rsi #string to print.
    
    jmp calculateStringLength
    backaftercalulcatinglength:
    mov %rax,%rdx #how many bytes

    movq $1 , %rdi #std out 1
    movq $1 , %rax # syswrite
    syscall

    pop %r15
    pop %r14
    
    #exit program
    mov %rbp, %rsp
    pop %rbp
    ret

print_char:
    # Prologue
    push %rbp
    mov %rsp,%rbp

    movq %rdi, %rsi #char to print.
    
    mov $1,%rdx #how many bytes
    movq $1 , %rdi #std out 1
    movq $1 , %rax # syswrite
    syscall

    #exit subroutine.
    mov %rbp, %rsp
    pop %rbp
    ret

calculateStringLength:
    push %r13 #stores char byte

    mov $0,%rax #length
    
    lengthlooper:
        
        mov (%rdi,%rax,1),%r13 #this now stores the character byte.

        cmp $0,%r13b
        je exitlengthlooper
        
        inc %rax

        jmp lengthlooper

    exitlengthlooper:
        pop %r13
        jmp backaftercalulcatinglength

format_print:
    #check next character.
    inc %r15 #increment the index
    inc %r13 #increment the pointer, to point to next character.
    mov (%r13),%r12

    cmp $0x25,%r12b #if character is a %, then print the %
    je print_percentage

    cmp $0x73,%r12b #if character is a s, then print the string.
    je print_string_format

    cmp $0x75,%r12b #if character is a u, then print the unsigned integer 
    je print_unsigned_integer

    cmp $0x64,%r12b #if character is a d, then print the signed integer 
    je print_signed_integer
    
    //else print the percentage and the current char.
    mov $pc, %rdi
    call print_char
    
    mov %r13, %rdi
    call print_char

    jmp my_print_continue
    
print_percentage:
    mov $pc, %rdi
    call print_char

    #go back to the printer
    jmp my_print_continue

print_string_format:
    inc %r14 #increase format counter
    #GET ARGUMENT TO PASS IN PRINT STRING
   
    call get_argument
    
    mov %rax, %rdi
    call print_string
    

    jmp my_print_continue

print_signed_integer:
    
    inc %r14 #increase format counter
    #GET ARGUMENT.
   
    call get_argument
   
    mov %rax, %rdi

    cmp $0, %rdi #check if number is negative, if so. print - + n*-1
    jge nonnegative
    // else, its negative
    push %rdi
    push $0x2D
    
    lea (%rsp), %rdi
    call print_char

    pop %rdi #remove the sign.s
    pop %rdi
    
    #multiply number by -1
    mov $-1, %rax
    mul %rdi
    mov %rax, %rdi
    nonnegative:
    #print the number in rdi.
    call print_number

    jmp my_print_continue

print_unsigned_integer:
    inc %r14 #increase format counter
    
    call get_argument
    
    mov %rax,%rdi
    call print_number
   
    #PRINT IT.
    jmp my_print_continue

print_number:
    push %rbp
    mov %rsp, %rbp

    mov $0, %rdx  #high address of dividend
    mov %rdi, %rax #low address of dividend
    mov $0, %r8 #counter  of division.
    divloop:
        mov $0, %rdx  #high address of dividend
        inc %r8
        mov $10, %rdi #divisor
        div %rdi

        r0:
            cmp $0, %rdx
            jne r1

            push $0x30
            push $0x30
            jmp continueloopnumber
        r1:
            cmp $1, %rdx
            jne r2

            push $0x31
            push $0x31
            jmp continueloopnumber
        r2:
            cmp $2, %rdx
            jne r3

            push $0x32
            push $0x32
            jmp continueloopnumber
        r3:
            cmp $3, %rdx
            jne r4

            push $0x33
            push $0x33
            jmp continueloopnumber
        r4:
            cmp $4, %rdx
            jne r5

            push $0x34
            push $0x34
            jmp continueloopnumber
        r5:
            cmp $5, %rdx
            jne r6

            push $0x35
            push $0x35
            jmp continueloopnumber
        r6:
            cmp $6, %rdx
            jne r7

            push $0x36
            push $0x36
            jmp continueloopnumber
        r7:
            cmp $7, %rdx
            jne r8

            push $0x37
            push $0x37
            jmp continueloopnumber
        r8:
            cmp $8, %rdx
            jne r9

            push $0x38
            push $0x38
            jmp continueloopnumber
        r9:
            push $0x39
            push $0x39

        continueloopnumber:
        cmp $0, %rax
        je printnumbersjmp
        //mov %rax, %rdi
        jmp divloop

    printnumbersjmp: 
        cmp $0, %r8
        je exitnumbersprinter

        #pop %rdi #this doesnt work as this gets the char. we need the address.
        push %rdi
        lea 8(%rsp),%rdi
        push %rsi
        push %rcx
        push %rdx
        push %r8
        push %r9
        push %r10
        push %r11
        call print_char
        pop %r11
        pop %r10
        pop %r9
        pop %r8
        pop %rdx
        pop %rcx
        pop %rsi
        pop %rdi
        
        pop %rdi
        pop %rdi

        dec %r8
        jmp printnumbersjmp
    #print chars. and then exit.
    #----------------------------------------------------------------------------------------
    exitnumbersprinter:

        mov %rbp, %rsp
        pop %rbp
        ret
get_argument:
    mov %rbp, %rdx
    push %rbp
    mov %rsp,%rbp
    cmp $6, %r14
    jge reachedrbp
    a1:
        cmp $1, %r14
        jne a2
        mov -40(%rdx),%rax
        jmp ea
    a2:
        cmp $2, %r14
        jne a3
        mov -32(%rdx),%rax
        jmp ea
    a3:
        cmp $3, %r14
        jne a4
        mov -24(%rdx),%rax
        jmp ea
    a4:
        cmp $4, %r14
        jne a5
        mov -16(%rdx),%rax
        jmp ea
    a5:
        mov -8(%rdx),%rax
        jmp ea
    reachedrbp:
        mov %r14,%rax
        sub $6,%rax
        mov 16(%rdx,%rax,8),%rax
        ea:
            mov %rbp,%rsp
            pop %rbp
            ret