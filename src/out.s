	.text
	.globl	main
	.type	main, @function
Prime:
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movq	%rdi, -8(%rbp)
	movq	16(%rbp), %r8
	movq	%r8, -8(%rbp)
	movl	$1, %ecx
	movl	%ecx, -12(%rbp)
L4:
	movl	$0, %edx
	movl	%edx, -16(%rbp)
L3:
	movl	-16(%rbp), %r14d
	movl	$10, %r15d
	cmpl	%r15d, %r14d
	setl	%al
	movb	%al, -29(%rbp)
	movb	-29(%rbp), %al
	cmpb	$1, %al
	je L1
	jmp L2
L0:
	movl	-16(%rbp), %ecx
	movl	%ecx, -33(%rbp)
	movl	-16(%rbp), %edx
	movl	$1, %r14d
	addl	%edx, %r14d
	movl	%r14d, -16(%rbp)
	jmp L3
L1:
	movl	-12(%rbp), %r15d
	movl	%r15d, -37(%rbp)
	movl	-12(%rbp), %ecx
	movl	$1, %edx
	addl	%ecx, %edx
	movl	%edx, -12(%rbp)
	jmp L0
L2:
L9:
	movl	$0, %r14d
	movl	%r14d, -20(%rbp)
L8:
	movl	-20(%rbp), %r15d
	movl	$10, %ecx
	cmpl	%ecx, %r15d
	setl	%al
	movb	%al, -38(%rbp)
	movb	-38(%rbp), %bl
	cmpb	$1, %bl
	je L6
	jmp L7
L5:
	movl	-20(%rbp), %edx
	movl	%edx, -42(%rbp)
	movl	-20(%rbp), %r14d
	movl	$1, %r15d
	addl	%r14d, %r15d
	movl	%r15d, -20(%rbp)
	jmp L8
L6:
	movl	$10, %ecx
	movl	%ecx, -24(%rbp)
	movl	-12(%rbp), %edx
	movl	-24(%rbp), %r14d
	addl	%edx, %r14d
	movl	%r14d, -12(%rbp)
	jmp L5
L7:
	movl	$0, %r15d
	movl	%r15d, -28(%rbp)
	movl	-12(%rbp), %ecx
	movl	%ecx, -46(%rbp)
	mov	$printLabel, %rdi
	movslq	-46(%rbp), %rsi
	xor	%rax, %rax
	call	printf
	movq	%rbp, %rsp
	popq	%rbp
	ret
printLabel:
	.asciz	"%d\n" 
