	.text
	.globl	main
	.type	main, @function
SieveOfEratosthenesDemo:
sieveOfEratosthenes:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$176, %rsp
	movq	%rdi, -8(%rbp)
	movl	16(%rbp), %ecx
	movl	%ecx, -12(%rbp)
	movl	$400, %ecx
	movl	%ecx, -36(%rbp)
	movslq	-36(%rbp), %rdi
	call	malloc
	movq	%rax, -44(%rbp)
	movq	-44(%rbp), %r8
	movq	%r8, -20(%rbp)
L4:
	movl	$2, %edx
	movl	%edx, -24(%rbp)
L3:
	movl	-24(%rbp), %r14d
	movl	-24(%rbp), %r15d
	imull	%r15d, %r14d
	movl	%r14d, -48(%rbp)
	movl	-48(%rbp), %ecx
	movl	-12(%rbp), %edx
	cmpl	%edx, %ecx
	setle	%al
	movb	%al, -49(%rbp)
	movb	-49(%rbp), %al
	cmpb	$1, %al
	je L1
	jmp L2
L0:
	movl	-24(%rbp), %r14d
	movl	%r14d, -53(%rbp)
	movl	-24(%rbp), %r15d
	movl	$1, %ecx
	addl	%r15d, %ecx
	movl	%ecx, -24(%rbp)
	jmp L3
L1:
	movl	-24(%rbp), %edx
	movl	$1, %r14d
	imull	%r14d, %edx
	movl	%edx, -57(%rbp)
	movl	-57(%rbp), %r15d
	movl	$4, %ecx
	imull	%ecx, %r15d
	movl	%r15d, -61(%rbp)
	movq	$20, %r9
	movq	%r9, -69(%rbp)
	movq	-20(%rbp), %r10
	movq	%r10, -77(%rbp)
	movq	-77(%rbp), %r11
	movslq	-61(%rbp), %r12
	addq	%r11, %r12
	movl	$1, %edx
	movl	%edx, (%r12)
	jmp L0
L2:
	movl	$0, %r14d
	movl	$1, %r15d
	imull	%r15d, %r14d
	movl	%r14d, -81(%rbp)
	movl	-81(%rbp), %ecx
	movl	$4, %edx
	imull	%edx, %ecx
	movl	%ecx, -85(%rbp)
	movq	$20, %r13
	movq	%r13, -93(%rbp)
	movq	-20(%rbp), %r8
	movq	%r8, -101(%rbp)
	movq	-101(%rbp), %r9
	movslq	-85(%rbp), %r10
	addq	%r9, %r10
	movl	$0, %r14d
	movl	%r14d, (%r10)
	movl	$1, %r15d
	movl	$1, %ecx
	imull	%ecx, %r15d
	movl	%r15d, -105(%rbp)
	movl	-105(%rbp), %edx
	movl	$4, %r14d
	imull	%r14d, %edx
	movl	%edx, -109(%rbp)
	movq	$20, %r11
	movq	%r11, -117(%rbp)
	movq	-20(%rbp), %r12
	movq	%r12, -125(%rbp)
	movq	-125(%rbp), %r13
	movslq	-109(%rbp), %r8
	addq	%r13, %r8
	movl	$0, %r15d
	movl	%r15d, (%r8)
	movl	-12(%rbp), %ecx
	movl	$2, %edx
	cmpl	%ecx, %edx
	sete	%al
	movb	%al, -126(%rbp)
	movb	-126(%rbp), %bl
	cmpb	$1, %bl
	je L5
	jmp L6
L5:
	movl	$1, %r14d
	movslq	%r14d, %rax
	jmp L6
L6:
L20:
	movl	$2, %r15d
	movl	%r15d, -24(%rbp)
L19:
	movl	-24(%rbp), %ecx
	movl	-24(%rbp), %edx
	imull	%edx, %ecx
	movl	%ecx, -130(%rbp)
	movl	-130(%rbp), %r14d
	movl	-12(%rbp), %r15d
	cmpl	%r15d, %r14d
	setle	%al
	movb	%al, -131(%rbp)
	movb	-131(%rbp), %al
	cmpb	$1, %al
	je L17
	jmp L18
L7:
	movl	-24(%rbp), %ecx
	movl	%ecx, -135(%rbp)
	movl	-24(%rbp), %edx
	movl	$1, %r14d
	addl	%edx, %r14d
	movl	%r14d, -24(%rbp)
	jmp L19
L17:
	movl	-24(%rbp), %r15d
	movl	$1, %ecx
	imull	%ecx, %r15d
	movl	%r15d, -139(%rbp)
	movl	-139(%rbp), %edx
	movl	$4, %r14d
	imull	%r14d, %edx
	movl	%edx, -143(%rbp)
	movq	$20, %r9
	movq	%r9, -151(%rbp)
	movq	-20(%rbp), %r10
	movq	%r10, -159(%rbp)
	movq	-159(%rbp), %r11
	movslq	-143(%rbp), %r12
	addq	%r11, %r12
	movl	(%r12), %eax
	movl	%eax, -163(%rbp)
	movl	-163(%rbp), %r15d
	movl	$1, %ecx
	cmpl	%r15d, %ecx
	sete	%al
	movb	%al, -164(%rbp)
	movb	-164(%rbp), %bl
	cmpb	$1, %bl
	je L15
	jmp L16
L15:
	movl	-12(%rbp), %edx
	movl	%edx, %eax
	movl	-24(%rbp), %r14d
	movl	%r14d, %ecx
	cltd
	idivl	%ecx
	movl	%edx, -168(%rbp)
	movl	-168(%rbp), %r15d
	movl	$0, %ecx
	cmpl	%r15d, %ecx
	sete	%al
	movb	%al, -169(%rbp)
	movb	-169(%rbp), %al
	cmpb	$1, %al
	je L8
	jmp L9
L8:
	movl	$0, %edx
	movslq	%edx, %rax
	jmp L9
L9:
L14:
	movl	-24(%rbp), %r14d
	movl	-24(%rbp), %r15d
	imull	%r15d, %r14d
	movl	%r14d, -173(%rbp)
	movl	-173(%rbp), %ecx
	movl	%ecx, -28(%rbp)
L13:
	movl	-28(%rbp), %edx
	movl	-12(%rbp), %r14d
	cmpl	%r14d, %edx
	setle	%al
	movb	%al, -174(%rbp)
	movb	-174(%rbp), %bl
	cmpb	$1, %bl
	je L11
	jmp L12
L10:
	movl	-28(%rbp), %r15d
	movl	-24(%rbp), %ecx
	addl	%r15d, %ecx
	movl	%ecx, -28(%rbp)
	jmp L13
L11:
	movl	-28(%rbp), %edx
	movl	$1, %r14d
	imull	%r14d, %edx
	movl	%edx, -178(%rbp)
	movl	-178(%rbp), %r15d
	movl	$4, %ecx
	imull	%ecx, %r15d
	movl	%r15d, -182(%rbp)
	movq	$20, %r13
	movq	%r13, -190(%rbp)
	movq	-20(%rbp), %r8
	movq	%r8, -198(%rbp)
	movq	-198(%rbp), %r9
	movslq	-182(%rbp), %r10
	addq	%r9, %r10
	movl	$0, %edx
	movl	%edx, (%r10)
	jmp L10
L12:
	jmp L16
L16:
	jmp L7
L18:
	movl	$1, %r14d
	movslq	%r14d, %rax
	movq	%rbp, %rsp
	popq	%rbp
	ret
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -8(%rbp)
	movq	16(%rbp), %r8
	movq	%r8, -8(%rbp)
	movl	$7, %r15d
	movl	%r15d, -12(%rbp)
	movl	$2, %ecx
	movl	%ecx, -16(%rbp)
	subq	$12, %rsp
	movl	-12(%rbp), %edx
	subq	$4,%rsp
	movl	%edx, (%rsp)
	movq	-8(%rbp), %rdi
	call	sieveOfEratosthenes
	movq	%rax, -20(%rbp)
	subq	$16, %rsp
	movl	-20(%rbp), %r14d
	movl	$1, %r15d
	cmpl	%r14d, %r15d
	sete	%al
	movb	%al, -21(%rbp)
	movb	-21(%rbp), %al
	cmpb	$1, %al
	je L23
	jmp L24
L23:
	movl	-12(%rbp), %ecx
	movl	%ecx, -25(%rbp)
	mov	$printLabel, %rdi
	movslq	-25(%rbp), %rsi
	xor	%rax, %rax
	call	printf
	subq	$12, %rsp
	movl	-16(%rbp), %edx
	subq	$4,%rsp
	movl	%edx, (%rsp)
	movq	-8(%rbp), %rdi
	call	sieveOfEratosthenes
	movq	%rax, -29(%rbp)
	subq	$16, %rsp
	movl	-29(%rbp), %r14d
	movl	$1, %r15d
	cmpl	%r14d, %r15d
	sete	%al
	movb	%al, -30(%rbp)
	movb	-30(%rbp), %bl
	cmpb	$1, %bl
	je L21
	jmp L22
L21:
	movl	-16(%rbp), %ecx
	movl	%ecx, -34(%rbp)
	mov	$printLabel, %rdi
	movslq	-34(%rbp), %rsi
	xor	%rax, %rax
	call	printf
	jmp L22
L22:
	jmp L24
L24:
	movq	%rbp, %rsp
	popq	%rbp
	ret
printLabel:
	.asciz	"%d\n" 
