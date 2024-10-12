%include "random.inc"

section .data
	; greet msg
	greet_msg: db "Seja bem vindo ao jogo da forca", 0xA
	greet_tam: equ $- greet_msg
	; input msg
	input_msg: db "Digite uma letra: "
	input_tam: equ $- input_msg

	; game result messages
	; sucess
	game_sucess_msg: db 0xA, "Parabéns, você ganhou!!", 0xA, "A palavra secreta era: "
	game_sucess_tam: equ $- game_sucess_msg
	; fail
	game_fail_msg: db 0xA, "Poxa, você perdeu :/", 0xA, "A palavra secreta era: "
	game_fail_tam: equ $- game_fail_msg

	; input result messages
	; sucess
	sucess_msg: db "Você acertou!!", 0xA, 0xA
	sucess_tam: equ $- sucess_msg
	; fail
	; 	head
	fail_msg_head: db "Você errou, você possui "
	fail_tam_head: equ $- fail_msg_head
	; 	tail
	fail_msg_tail: db " tentativas restantes.", 0xA, 0xA
	fail_tam_tail: equ $- fail_msg_tail


	; result
	result_buffer: times 16 db 0
	; tries
	tries db 0x5
	; secret word
	secret_word: dq 0x0
	secret_word_size: dw 0x0
	; user guess
	correct_guess: times 6 db 0x0
	current_guess: dq 0x0
	guessed_char: db 0x0

section .text

global _start

_start:
	; greet msg
	mov rax, 0x4
	mov rbx, 0x1
	mov rcx, greet_msg
	mov rdx, greet_tam
	int 0x80

	; start current guess
	;mov qword [current_guess], correct_guess

	; get secret word
	call get_random_word

	mov qword [current_guess], correct_guess

	mov rax, [rsi]

	mov qword [secret_word], rax ; gets secret word

	movzx rcx, cx
	; valor cx funciona normal mas secreto_word_size com o valor de cx nao
	dec rcx
	mov	[secret_word_size], rcx; get secret word size

guess_char:
	; no more attempts ( lose )
	xor rcx, rcx
	mov cl, [tries]
	cmp cl, 0x0

	jle print_lose_message
	; has attempts


	call verify_win
	cmp rax, 0x1
	je print_win_message

	; input msg
	mov rax, 0x4
	mov rbx, 0x1
	mov rcx, input_msg
	mov rdx, input_tam ; get the value of input tam
	int 0x80

	; read stdin
	mov rax, 0x3 ; read
	mov rbx, 0x0 ; stdin
	mov rcx, guessed_char
	mov rdx, secret_word_size
	int 0x80

	; verify if guessed char exists on secret word
	lea rsi, [secret_word]
	movzx rbx, word [secret_word_size]
	mov rdx, [guessed_char]
	call verify_char

	; rax is the result of verify char
	cmp rax, 0x1
	je .addGuess

	; decrement tries and push his string value to stack
	movzx rcx, byte [tries]
	dec cl
	mov [tries], cl

	test cl, cl
	jz print_lose_message

	add cl, '0'

	sub rsp, 4
	mov byte [rsp], cl

	; error message start
	mov rax, 0x4
	mov rbx, 0x1
	mov rcx, fail_msg_head
	mov rdx, fail_tam_head
	int 0x80

	; print tries
	mov rax, 0x1
	mov rdi, 0x1
	mov rsi, rsp
	mov rdx, 0x1
	syscall

	; pop stack
	add rsp, 4

	; print error message end
	mov rax, 0x4
	mov rbx, 0x1
	mov rcx, fail_msg_tail
	mov rdx, fail_tam_tail
	int 0x80
	; error message end

	jmp guess_char ; restart loop

	; acertou
	.addGuess:
		; set guessed_char to current_guess
		mov al, [guessed_char]
		mov rdi, [current_guess]
		mov byte [rdi], al

		; increment_it
		mov rcx, [current_guess]

		;mov rax, [correct_guess]
		;add rax, [secret_word_size]

		;cmp rcx, rax; verify if it doesnt overflow the size
		;jge print_win_message

		inc rcx

		mov [current_guess], cl

		; print sucess message
		mov rax, 0x4
		mov rbx, 0x1
		mov rcx, sucess_msg
		mov rdx, sucess_tam
		int 0x80

		; restarts loop
		jmp guess_char


; verify win
; verifies if on correct_guess all secred word chars are present ( except \0 and \n )
verify_win:
	lea rsi, [secret_word]

	mov rax, 0x1 ; main boolean - checks if the entire sentence is true
	mov rcx, 0x0 ; counter

	call verify_win_loop

	ret

verify_win_loop:
	; check if loop reached the end
	mov dx, word [secret_word_size]
	cmp cx, dx ; counter is less than the secret_word_size
	jl .loop_body

	ret

	.loop_body:

		; verify char match
		; save values on stack
		; 0 -> rcx
		push rcx

		mov rbx, 0x6 ; correct_guess size
		mov rdx, [rsi] ; char to verify

		; save current rsi on stack
		push rsi

		lea rsi, [correct_guess] ; buffer (correct_guess)
		call verify_char

		; pop from stack after using it on verify char
		mov rsi, [rsp]
		pop rsi

		; retrieve counter from stack
		mov rcx, [rsp]
		pop rcx

		; stop if no char is found on correct_guess verify char
		cmp rax, 0x0
		je .finish

		inc rsi
		inc rcx
		jmp verify_win_loop

		.finish:
			inc rsi
			mov cx, word [secret_word_size]
			jmp verify_win_loop

; verify char exists on buffer
; rsi -> buffer adress
; rbx -> buffer size
; rdx -> char
; return result on rax -> 0x1=true | 0x0 = false
verify_char:
	mov rax, 0x0
	mov rcx, 0x0

	test rdx, rdx
	jnz .body

	ret

	.body:
		cmp rdx, 0xA
		jne .call_loop

	ret

	.call_loop:
		call verify_char_loop

	ret

verify_char_loop:
	; loop finish condition
	cmp rcx, rbx
	jl .body

	ret

	.body:
		cmp dl, byte [rsi]
		jne .next

		mov rax, 0x1
		ret

		.next:
			inc rsi
			inc rcx
			jmp verify_char_loop

; print game result messages
print_win_message:
	inc byte [secret_word_size] ; include \n on end of string

	mov rax, 0x4
	mov rbx, 0x1
	mov rcx, game_sucess_msg
	mov rdx, game_sucess_tam
	int 0x80

	mov rax, 0x4
	mov rbx, 0x1
	mov rcx, secret_word
	mov rdx, [secret_word_size]
	int 0x80

	jmp exit

print_lose_message:
	inc byte [secret_word_size] ; include \n on end of string

	mov rax, 0x4
	mov rbx, 0x1
	mov rcx, game_fail_msg
	mov rdx, game_fail_tam
	int 0x80

	mov rax, 0x4
	mov rbx, 0x1
	mov rcx, secret_word
	mov rdx, [secret_word_size]
	int 0x80

	jmp exit

exit:
	mov rax, 0x1
	mov rbx, 0x0
	int 0x80
