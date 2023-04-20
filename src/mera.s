	.file	"mera.c"
	.text
	.section	.rodata
.LC0:
	.string	"%d\n"
	.text
	.globl	main
	.type	main, @function
main:
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	$12, -12(%rbp)
	movl	$5, -8(%rbp)
	movl	-12(%rbp), %edx
	movl	-8(%rbp), %eax
	addl	%edx, %eax
	imull	-8(%rbp), %eax
	movl	%eax, %ecx
	movl	-12(%rbp), %eax
	subl	-8(%rbp), %eax
	cltd
	idivl	-8(%rbp)
	movl	%eax, %esi
	movl	%ecx, %eax
	cltd
	idivl	%esi
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:






















pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movl	$12, %eax
	movl	%eax, -12(%rbp)
	movl	$5, %ebx
	movl	%ebx, -16(%rbp)
	movl	$6, %ecx
	movl	%ecx, -20(%rbp)
	movl	-12(%rbp), %ecx
	cltd
	idivl	-16(%rbp)
	movl	%eax, -28(%rbp)
	movl	-28(%rbp), %edx
	movl	%edx, -24(%rbp)
	mov	$printLabel, %rdi