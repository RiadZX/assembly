.global brainfuck

.data
BUFFER: .skip 30000

.text
format_str: .asciz "We should be executing the following code:\n%s\n"
format_char: .asciz "%c"

brainfuck:
	pushq 	%rbp
	movq 	%rsp, %rbp

	mov 	%rdi, %r12	#r12 = PROGRAM_START 
	xor 	%r13, %r13	#r13 = PROGRAM_POINTER 

	push 	$0			#Reserve empty space for scanf
	push 	$0			#Reserve empty space for scanf
	xor 	%r14, %r14	#r14 = DATA_POINTER 
	mov 	$BUFFER, %r15  #r15 = DATA_START

	movq 	%rdi, %rsi
	movq 	$format_str, %rdi
	movq 	$0, %rax	
	call 	printf

	jmp 	programLoop

programLoop:
	xor 	%rax, %rax
	movb 	(%r12,%r13), %al

	cmp		$62, %al #>
	je 		incDataPointer
	cmp 	$60, %al #<
	je 		decDataPointer
	cmp 	$43, %al #+
	je 		incByte
	cmp 	$45, %al #-
	je 		decByte
	cmp 	$91, %al #[
	je 		jumpToClosed
	cmp 	$93, %al #]
	je 		jumpBackToOpen
	cmp 	$46, %al #.
	je 		outputData
	cmp 	$44, %al #,
	je 		inputData
	cmp 	$0, %al #EOF
	jne 	finishInstruction

	movq 	%rbp, %rsp
	popq 	%rbp
	ret

finishInstruction:
	inc 	%r13
	jmp 	programLoop

incDataPointer:
	inc 	%r14;

	cmp 	$30000, %r14
	jne 	finishInstruction
	#Data pointer to start
	xor 	%r14, %r14
	jmp 	finishInstruction

decDataPointer:
	dec 	%r14
	cmp 	$-1, %r14
	jne 	finishInstruction
	#Data pointer to end
	mov 	$29999, %r14
	jmp 	finishInstruction

incByte:
	incb 	(%r15,%r14)
	jmp 	finishInstruction

decByte:
	decb 	(%r15,%r14)
	jmp 	finishInstruction

jumpToClosed:
	cmpb 	$0,(%r15,%r14)
	jne 	finishInstruction

	xor 	%rax, %rax

	mov 	$91, %rdi #comparsion 1
	mov 	$93, %rsi #comparsion 2
	mov 	$1, %rdx  #direction of search

	jmp 	findBracketLoop

jumpBackToOpen:
	cmpb 	$0,(%r15,%r14)
	je 		finishInstruction

	xor 	%rax, %rax

	mov 	$93, %rdi #comparsion 1
	mov 	$91, %rsi #comparsion 2
	mov 	$-1, %rdx #direction of search
	
	jmp 	findBracketLoop

findBracketLoop:
	add 	%rdx, %r13

	cmpb 	%dil, (%r12,%r13) 	#check for [
	je 		increaseDepth 		#depth increases
	cmpb 	%sil, (%r12,%r13) 	#check for ]
	jne 	findBracketLoop		#not ]? -> restart loop 

	cmp	 	$0, %rax
	je 		programLoop
	#Decrease depth
	dec 	%rax
	jmp 	findBracketLoop

increaseDepth:
	inc 	%rax
	jmp 	findBracketLoop

outputData:
	mov 	$format_char, %rdi   	
	xor 	%rsi, %rsi	
    movb 	(%r15,%r14), %sil 		#Move character to printf input		
    mov 	$0, %rax        			
    call 	printf  			#Print character that was pushed to stack

	jmp 	finishInstruction

inputData:
	mov 	$format_char, %rdi   
	leaq 	-8(%rbp), %rsi 
	xor 	%rax, %rax
    call 	scanf          #Scan for input (both integers)

	movb 	-8(%rbp), %al;
	movb 	%al, (%r15,%r14)

	jmp 	finishInstruction




