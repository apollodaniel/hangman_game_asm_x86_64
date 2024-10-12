# Hangman game in Assembly x86_64 ( Intel syntax )
This is a hangman game made in assembly using random words.
The generation of random numbers was done using `/dev/urandom`.

> Caso deseje a explicação completa em português navege até `# Jogo da Forca em Assembly x86_64 (Sintaxe Intel)`


## How it works
### main.asm
#### guess_char
Main application loop where the input are asked and processed
#### verify_win
Verifies if the user already won the game

Return:
- `rax` -> 0x0 (false) or 0x1 (true)

#### verify_win_loop
The loop of verify_win
#### verify_char
Verifies if a char is present on a buffer

Args:
- `rdx` -> Char
- `rsi` -> buffer
- `rbx` -> buffer_size

Return:
- `rax` -> 0x0 (false) or 0x1 (true)

#### print_win_message
Finishes the game and print win message
#### print_lose_message
Same as win, but for lose
#### exit
Stops program execution

### random.inc
Contains functions necessary to get random numbers and words.

#### get_random_word
Returns a random word as a pointer on rsi, and size on rcx.

> Returns words in brazilian portuguese


## Some info
This is a project for learning, as a beginner, I can make mistakes, so any suggestions and pull request is welcome to improve the code.



# Jogo da Forca em Assembly x86_64 (Sintaxe Intel)
Este é um jogo da forca feito em assembly usando palavras aleatórias.
A geração de números aleatórios foi feita usando `/dev/urandom`.

## Como funciona
### main.asm
#### guess_char
Loop principal da aplicação onde as entradas são solicitadas e processadas.
#### verify_win
Verifica se o usuário já ganhou o jogo.

Retorno:
- `rax` -> 0x0 (falso) ou 0x1 (verdadeiro)


#### verify_win_loop
O loop de verify_win.
#### verify_char
Verifica se um char está presente em um buffer.

Args:
- `rdx` -> Char
- `rsi` -> buffer
- `rbx` -> buffer_size

Retorno:
- `rax` -> 0x0 (falso) ou 0x1 (verdadeiro)

#### print_win_message
Finaliza o jogo e imprime a mensagem de vitória.
#### print_lose_message
Mesma coisa que a de vitória, mas para derrota.
#### exit
Para a execução do programa.

### random.inc
Contém funções necessárias para obter números e palavras aleatórias.

#### get_random_word
Retorna uma palavra aleatória como um ponteiro em `rsi` e o tamanho em `rcx`.

> Retorna palavras em português brasileiro.


## Algumas informações
Este é um projeto para aprendizado. Como iniciante, posso cometer erros, então qualquer sugestão e pull request são bem-vindos para melhorar o código.

