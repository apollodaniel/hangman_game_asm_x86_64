; Author: Apollo Daniel
; Date: 10/10/2006
; generates a random number by reading /dev/urandom (unsigned random)
; supports interval
; the return is a random integer ( needs to be converted to string to print )
; currently online support 0-256 interval
; return on ah

section .data
	; location
	filename db "/dev/urandom", 0x0

	; words list
		w0: db "gato", 0xA, 0x0
		w1: db "livro", 0xA, 0x0
		w2: db "parede", 0xA, 0x0
		w3: db "sol", 0xA, 0x0
		w4: db "carro", 0xA, 0x0
		w5: db "porta", 0xA, 0x0
		w6: db "rio", 0xA, 0x0
		w7: db "flor", 0xA, 0x0
		w8: db "chave", 0xA, 0x0
		w9: db "banana", 0xA, 0x0
		w10: db "casa", 0xA, 0x0
		w11: db "janela", 0xA, 0x0
		w12: db "mesa", 0xA, 0x0
		words: dq w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12
	; --

	words_len: db 0xC ; 12 items
section .bss
	buffer: resb 0x5

section .text

global get_random_word

; receive interval on al, and bl
; al is start, bl end
; get random number and return into rax
get_random_number:
	; set received values
 ; dec 1 from bl to prevent overflowing interval end mov [start], al

	; open /dev/urandom
	mov rax, 0x5 ; sys open
	mov rbx, filename
	mov rcx, 0
	mov rdx, 0
	int 0x80

	; rax will stores the result with the file descriptor
	mov rdi, rax

	; read /dev/urandom by 1 byte
	mov rax, 0x3 ; read
	mov rbx, rdi
	mov rcx, buffer
	mov rdx, 0x1 ; read single byte
	int 0x80

	; close /dev/urandom
	mov rax, 0x6
	mov rbx, rdi
	int 0x80

	; check if is lower than interval start
	xor rax, rax

	mov cl, [words_len]
	inc cl

	mov al, [buffer]
	; set interval start
	mov bl, cl ; set interval end

	div bl
	 ; random number is here

	mov [buffer], ah

	ret


get_random_word:
	xor rax, rax
	xor rbx, rbx

	; result returned on ah
	call get_random_number

	mov rax, 0x8 ; tamanho array
	mov rcx, [buffer] ; 8 bytes each
	mul rcx

	lea rdi, [words] ; gets value from first item mref
	mov rsi, [rdi+rax]

	xor rcx, rcx

	call count_loop

	sub rsi, rcx

	ret

count_loop:
	cmp byte [rsi], 0x0
	jne increment

	ret

increment:
	inc rsi
	inc cx
	jmp count_loop
