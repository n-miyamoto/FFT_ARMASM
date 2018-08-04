gcc -c main.c -march=armv5
gcc -c fft_arm9e.s -march=armv5
gcc -o out main.o fft_arm9e.o -march=armv5
./out
