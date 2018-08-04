gcc -c main.c
gcc -c fft_arm9e.s
gcc -o out main.o fft_arm9e.o

