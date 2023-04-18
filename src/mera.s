	.file	"mera.c"
	.text
	.section	.rodata
.LC0:
	.string	"%d \n"
	.text
	.globl	main
	.type	main, @function
main:
	endbr64
	# pushq	%rbp
	# movq	%rsp, %rbp
	# subq	$16, %rsp
	# movl	$5, -12(%rbp)
	# movl	$1, -8(%rbp)
	# movl	-8(%rbp), %eax
	# movl	-12(%rbp), %edx
	# movl	%eax, %ecx
	# sall	%cl, %edx
	# movl	%edx, %eax
	# movl	%eax, -4(%rbp)
	pushq   %rbp
        movq    %rsp, %rbp
        subq    $20, %rsp
        movl    $5, %eax
        movl    %eax, -4(%rbp)
        movl    $1, %ebx
        movl    %ebx, -8(%rbp)
        movl    -8(%rbp), %ecx
        movl    -4(%rbp), %edx
        sall    %cl, %edx
        movl    %edx, -16(%rbp)
        movl    -16(%rbp), %eax
        movl    %eax, -12(%rbp)
	movl	-12(%rbp), %eax
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
