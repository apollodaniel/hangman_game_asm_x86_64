section .data
	; ATTEMPTS db 0x5
	; msg db "Seja bem vindo ao jogo da forca!", 0xA, 0x0
	; tam equ $- msg
	f0: db "maca", 0xA, 0x0
	f1: db "banana", 0xA, 0x0
	f2: db "manga", 0xA, 0x0
	f3: db "abacaxi", 0xA, 0x0

	fruits: dq f0, f1, f2, f3

	fruits_item_size: db 8

section .text

global _start

_start:
	mov eax, 0x8
	mov ecx, 0x3
	mul ecx

	lea rdi, [fruits]
	mov rsi, [rdi+rax] ; gets value from first item mref

	xor rcx, rcx

count_loop:
	cmp byte [rsi], 0x0
	je exit

	inc cx
	inc rsi

	jmp count_loop

exit:
	sub rsi, rcx

	mov rax, 0x4
	mov rbx, 0x1
	mov rdx, rcx
	mov rcx, rsi
	int 0x80

	mov rax, 0x1
	mov rbx, 0x0
	int 0x80
