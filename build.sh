gcc -c main.c -march=armv5te -marm
gcc -c fft_arm9e.s -march=armv5te -marm 
gcc -o out main.o fft_arm9e.o -march=armv5te -marm
./out
