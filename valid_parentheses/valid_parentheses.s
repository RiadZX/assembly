.data
valid: .string "valid"
invalid: .string "invalid"
.text

.include "basic.s"

.global main

# *******************************************************************************************
# Subroutine: check_validity                                                                *
# Description: checks the validity of a string of parentheses as defined in Assignment 6.   *
# Parameters:                                                                               *
#   first: the string that should be check_validity                                         *
#   return: the result of the check, either "valid" or "invalid"                            *
# *******************************************************************************************
check_validity:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	push %r10
	push %r10
	#your code goes here
	mov %rdi,%r10 #save anchor point
	
loop:
	mov (%rdi),%rdi #saves character into rdi.
	mov $0,%r9
	mov %dil,%r9b

	cmpb $0,%r9b
	je exitloop #if null byte then exit.

	// else check if its an open bracket
	cmpb $60, %r9b #angle
	je pushbrack

	cmpb $91, %r9b #square
	je pushbrack

	cmpb $40,%r9b #round
	je pushbrack
	
	cmpb $123, %r9b #curly
	je pushbrack

	//else check if its closed.
	cmpb $62, %r9b #if closed angle then pop the stack and check if its equals
	je popangle

	cmpb $93, %r9b #if closed square then pop the stack and check if its equals
	je popsquare

	cmpb $41, %r9b #if closed round then pop the stack and check if its equals
	je popround
	
	cmpb $125, %r9b #if closed curly then pop the stack and check if its equals
	je popcurly


continue:
	add $1,%r10 #increment to next byte.
	mov %r10,%rdi#move address
	jmp loop
exitloop:
	jmp validprint
exitloopinvalidunalligned:
	push $0
exitloopinvalid:
	jmp i
exitprogram:
	
	# epilogue
	pop %r10
	pop %r10
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

main:
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq	$MESSAGE, %rdi		# first parameter: address of the message
	call	check_validity		# call check_validity

	mov %rax,%rdi
	mov $0, %rax
	call printf

	popq	%rbp			# restore base pointer location 
	movq	$0, %rdi		# load program exit code
	call	exit			# exit the program
i:
invalidprint:
	
	// mov $invalid,%rdi
	// mov $0,%rax
	// call printf
	mov $invalid,%rax
	JMP exitprogram

v:
validprint:
	#check if stack is empty
	add $16, %rsp
	cmp %rbp,%rsp
	jne exitloopinvalidunalligned

	// mov $valid,%rdi
	// mov $0,%rax
	// call printf
	mov $valid,%rax
	jmp exitprogram

pushbrack:
	push %r9
	jmp continue #continue with the loop.


popangle:
	pop %r11
	cmp $60, %r11
	jne exitloopinvalid
	
	jmp continue
popsquare:
	
	pop %r11
	cmp $91, %r11
	jne exitloop
	
	jmp continue
popround:
	
	pop %r11
	cmp $40, %r11
	jne exitloopinvalid
	
	jmp continue
popcurly:

	pop %r11
	cmp $123, %r11
	jne exitloopinvalid
	
	jmp continue