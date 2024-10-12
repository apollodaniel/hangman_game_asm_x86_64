name = test
all: run $(name).o $(name) clean

run: $(name)
	@./$(name)
$(name).o: $(name).asm
	@nasm -f elf64 $(name).asm -o $(name).o
$(name): $(name).o
	@ld $(name).o -o $(name)
clean: $(name).o $(name)
	@rm $(name).o $(name)
