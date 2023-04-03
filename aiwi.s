	.file	"aiwi.c"
	.text
	.globl	proc
	.type	proc, @function
proc:
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -36(%rbp)
	movl	%esi, -40(%rbp)
	movl	$0, -36(%rbp)
	jmp	.L2
.L3:
	movl	$10, -24(%rbp)
	movl	$12, -20(%rbp)
	movl	$0, -16(%rbp)
	movl	$0, -12(%rbp)
	movl	$0, -8(%rbp)
	movl	$0, -4(%rbp)
	addl	$1, -36(%rbp)
.L2:
	cmpl	$9, -36(%rbp)
	jle	.L3
	movl	$0, %eax
	popq	%rbp
	ret
	.size	proc, .-proc
	.globl	proc2
	.type	proc2, @function
proc2:
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$24, %rsp
	movl	%edi, -20(%rbp)
	movl	-20(%rbp), %eax
	movl	$1, %esi
	movl	%eax, %edi
	call	proc
	movl	%eax, -4(%rbp)
	nop
	leave
	ret
	.size	proc2, .-proc2
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
