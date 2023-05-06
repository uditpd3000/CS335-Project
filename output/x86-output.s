	.text
	.global	age
	.data
	.type	gb, @object
	.size	gb, 4
age:
	.long	9
	.text
	.globl	main
	.type	main, @function
AgeCheck:
AgeCheck.Constr:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$144, %rsp
	movq	%rdi, -8(%rbp)
	movl	16(%rbp), %ecx
	movl	%ecx, -12(%rbp)
	movl	-12(%rbp), %ecx
	movl	%ecx, age(%rip)
	movq	-8(%rbp), %rdi
	movq	%rbp, %rsp
	popq	%rbp
	ret
sayAge:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movl	age(%rip), %edx
	movl	%edx, -16(%rbp)
	mov	$printLabel, %rdi
	movslq	-16(%rbp), %rsi
	xor	%rax, %rax
	call	printf
	movq	%rbp, %rsp
	popq	%rbp
	ret
isAdult:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movl	age(%rip), %r14d
	movl	$18, %r15d
	cmpl	%r15d, %r14d
	setge	%al
	movb	%al, -13(%rbp)
	movb	-13(%rbp), %al
	cmpb	$1, %al
	je L1
	jmp L0
L0:
	movl	$0, %ecx
	movslq	%ecx, %rax
	jmp L2
L1:
	movl	$1, %edx
	movslq	%edx, %rax
	jmp L2
L2:
	movq	%rbp, %rsp
	popq	%rbp
	ret
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$128, %rsp
	movq	%rdi, -8(%rbp)
	movq	16(%rbp), %r8
	movq	%r8, -8(%rbp)
	movl	$20, %r14d
	movl	%r14d, -36(%rbp)
	movslq	-36(%rbp), %rdi
	call	malloc
	movq	%rax, -44(%rbp)
	movq	-44(%rbp), %rax
	movl	$10, 0(%rax)
	movl	$17, 4(%rax)
	movl	$22, 8(%rax)
	movl	$35, 12(%rax)
	movl	$12, 16(%rax)
	movq	-44(%rbp), %r8
	movq	%r8, -16(%rbp)
L9:
	movl	$0, %r15d
	movl	%r15d, -20(%rbp)
L8:
	movl	-20(%rbp), %ecx
	movl	$5, %edx
	cmpl	%edx, %ecx
	setl	%al
	movb	%al, -45(%rbp)
	movb	-45(%rbp), %bl
	cmpb	$1, %bl
	je L6
	jmp L7
L3:
	movl	-20(%rbp), %r14d
	movl	%r14d, -49(%rbp)
	movl	-20(%rbp), %r15d
	movl	$1, %ecx
	addl	%r15d, %ecx
	movl	%ecx, -20(%rbp)
	jmp L8
L6:
	movl	-20(%rbp), %edx
	movl	$1, %r14d
	imull	%r14d, %edx
	movl	%edx, -53(%rbp)
	movl	-53(%rbp), %r15d
	movl	$4, %ecx
	imull	%ecx, %r15d
	movl	%r15d, -57(%rbp)
	movq	$16, %r9
	movq	%r9, -65(%rbp)
	movq	-16(%rbp), %r10
	movq	%r10, -73(%rbp)
	movq	-73(%rbp), %r11
	movslq	-57(%rbp), %r12
	addq	%r11, %r12
	movl	(%r12), %eax
	movl	%eax, -77(%rbp)
	movl	-77(%rbp), %edx
	movl	%edx, -81(%rbp)
	movl	$16, %r14d
	movl	%r14d, -85(%rbp)
	movslq	-85(%rbp), %rdi
	call	malloc
	movq	%rax, -93(%rbp)
	movq	-93(%rbp), %rdi
	subq	$12, %rsp
	movl	-81(%rbp), %r15d
	subq	$4,%rsp
	movl	%r15d, (%rsp)
	call	AgeCheck.Constr
	subq	$16, %rsp
	movq	%rdi, -101(%rbp)
	movq	-101(%rbp), %r13
	movq	%r13, -28(%rbp)
	movq	-28(%rbp), %rdi
	call	sayAge
	subq	$0, %rsp
	movl	$0, %ecx
	movl	%ecx, -32(%rbp)
	movq	-28(%rbp), %rdi
	call	isAdult
	movq	%rax, -105(%rbp)
	subq	$0, %rsp
	movl	-105(%rbp), %edx
	movl	%edx, -32(%rbp)
	movl	-32(%rbp), %r14d
	movl	$1, %r15d
	cmpl	%r14d, %r15d
	sete	%al
	movb	%al, -106(%rbp)
	movb	-106(%rbp), %al
	cmpb	$1, %al
	je L4
	jmp L5
L4:
	movl	-20(%rbp), %ecx
	movl	$1, %edx
	imull	%edx, %ecx
	movl	%ecx, -110(%rbp)
	movl	-110(%rbp), %r14d
	movl	$4, %r15d
	imull	%r15d, %r14d
	movl	%r14d, -114(%rbp)
	movq	$16, %r8
	movq	%r8, -122(%rbp)
	movq	-16(%rbp), %r9
	movq	%r9, -130(%rbp)
	movq	-130(%rbp), %r10
	movslq	-114(%rbp), %r11
	addq	%r10, %r11
	movl	(%r11), %eax
	movl	%eax, -134(%rbp)
	movl	-134(%rbp), %ecx
	movl	%ecx, -138(%rbp)
	mov	$printLabel, %rdi
	movslq	-138(%rbp), %rsi
	xor	%rax, %rax
	call	printf
	jmp L5
L5:
	jmp L3
L7:
	movq	%rbp, %rsp
	popq	%rbp
	ret
printLabel:
	.asciz	"%d\n" 
