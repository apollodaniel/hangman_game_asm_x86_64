%include "random.inc"

section .text

global _start

_start:
	call get_random_word

	mov rax, 0x1
	mov rbx, 0x0
	int 0x80
