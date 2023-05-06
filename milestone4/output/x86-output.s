	.text
	.globl	main
	.type	main, @function
BreakContinueDemo:
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$160, %rsp
	movq	%rdi, -8(%rbp)
	movq	16(%rbp), %r8
	movq	%r8, -8(%rbp)
	movl	$20, %ecx
	movl	%ecx, -28(%rbp)
	movslq	-28(%rbp), %rdi
	call	malloc
	movq	%rax, -36(%rbp)
	movq	-36(%rbp), %rax
	movl	$1, 0(%rax)
	movl	$2, 4(%rax)
	movl	$3, 8(%rax)
	movl	$4, 12(%rax)
	movl	$5, 16(%rax)
	movq	-36(%rbp), %r8
	movq	%r8, -16(%rbp)
L6:
	movl	$0, %edx
	movl	%edx, -20(%rbp)
L5:
	movl	-20(%rbp), %r14d
	movl	$5, %r15d
	cmpl	%r15d, %r14d
	setl	%al
	movb	%al, -37(%rbp)
	movb	-37(%rbp), %al
	cmpb	$1, %al
	je L3
	jmp L4
L0:
	movl	-20(%rbp), %ecx
	movl	%ecx, -41(%rbp)
	movl	-20(%rbp), %edx
	movl	$1, %r14d
	addl	%edx, %r14d
	movl	%r14d, -20(%rbp)
	jmp L5
L3:
	movl	-20(%rbp), %r15d
	movl	$1, %ecx
	imull	%ecx, %r15d
	movl	%r15d, -45(%rbp)
	movl	-45(%rbp), %edx
	movl	$4, %r14d
	imull	%r14d, %edx
	movl	%edx, -49(%rbp)
	movq	$16, %r9
	movq	%r9, -57(%rbp)
	movq	-16(%rbp), %r10
	movq	%r10, -65(%rbp)
	movq	-65(%rbp), %r11
	movslq	-49(%rbp), %r12
	addq	%r11, %r12
	movl	(%r12), %eax
	movl	%eax, -69(%rbp)
	movl	-69(%rbp), %r15d
	movl	$3, %ecx
	cmpl	%r15d, %ecx
	sete	%al
	movb	%al, -70(%rbp)
	movb	-70(%rbp), %bl
	cmpb	$1, %bl
	je L1
	jmp L2
L1:
	jmp L4
	jmp L2
L2:
	movl	-20(%rbp), %edx
	movl	$1, %r14d
	imull	%r14d, %edx
	movl	%edx, -74(%rbp)
	movl	-74(%rbp), %r15d
	movl	$4, %ecx
	imull	%ecx, %r15d
	movl	%r15d, -78(%rbp)
	movq	$16, %r13
	movq	%r13, -86(%rbp)
	movq	-16(%rbp), %r8
	movq	%r8, -94(%rbp)
	movq	-94(%rbp), %r9
	movslq	-78(%rbp), %r10
	addq	%r9, %r10
	movl	(%r10), %eax
	movl	%eax, -98(%rbp)
	movl	-98(%rbp), %edx
	movl	%edx, -102(%rbp)
	mov	$printLabel, %rdi
	movslq	-102(%rbp), %rsi
	xor	%rax, %rax
	call	printf
	jmp L0
L4:
L13:
	movl	$0, %r14d
	movl	%r14d, -20(%rbp)
L12:
	movl	-20(%rbp), %r15d
	movl	$5, %ecx
	cmpl	%ecx, %r15d
	setl	%al
	movb	%al, -103(%rbp)
	movb	-103(%rbp), %al
	cmpb	$1, %al
	je L10
	jmp L11
L7:
	movl	-20(%rbp), %edx
	movl	%edx, -107(%rbp)
	movl	-20(%rbp), %r14d
	movl	$1, %r15d
	addl	%r14d, %r15d
	movl	%r15d, -20(%rbp)
	jmp L12
L10:
	movl	-20(%rbp), %ecx
	movl	$1, %edx
	imull	%edx, %ecx
	movl	%ecx, -111(%rbp)
	movl	-111(%rbp), %r14d
	movl	$4, %r15d
	imull	%r15d, %r14d
	movl	%r14d, -115(%rbp)
	movq	$16, %r11
	movq	%r11, -123(%rbp)
	movq	-16(%rbp), %r12
	movq	%r12, -131(%rbp)
	movq	-131(%rbp), %r13
	movslq	-115(%rbp), %r8
	addq	%r13, %r8
	movl	(%r8), %eax
	movl	%eax, -135(%rbp)
	movl	-135(%rbp), %ecx
	movl	$3, %edx
	cmpl	%ecx, %edx
	sete	%al
	movb	%al, -136(%rbp)
	movb	-136(%rbp), %bl
	cmpb	$1, %bl
	je L8
	jmp L9
L8:
	jmp L7
	jmp L9
L9:
	movl	-20(%rbp), %r14d
	movl	$1, %r15d
	imull	%r15d, %r14d
	movl	%r14d, -140(%rbp)
	movl	-140(%rbp), %ecx
	movl	$4, %edx
	imull	%edx, %ecx
	movl	%ecx, -144(%rbp)
	movq	$16, %r9
	movq	%r9, -152(%rbp)
	movq	-16(%rbp), %r10
	movq	%r10, -160(%rbp)
	movq	-160(%rbp), %r11
	movslq	-144(%rbp), %r12
	addq	%r11, %r12
	movl	(%r12), %eax
	movl	%eax, -164(%rbp)
	movl	-164(%rbp), %r14d
	movl	%r14d, -168(%rbp)
	mov	$printLabel, %rdi
	movslq	-168(%rbp), %rsi
	xor	%rax, %rax
	call	printf
	jmp L7
L11:
	movq	%rbp, %rsp
	popq	%rbp
	ret
printLabel:
	.asciz	"%d\n" 
