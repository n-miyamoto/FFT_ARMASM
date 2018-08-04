#include <stdio.h>
#include <string.h>

#include "fft_arm9e.h"

#define N 16

int main(void){
	
	short x[2*N];
	short y[2*N];
	
	memset(x,0,4*N);
	memset(y,0,4*N);

	fft_16_arm9e(x, y, N);

	for(int i=0;i<N;i++){
		printf("%d + %d i \n", y[2*i], y[2*i+1]);
	}

	return 0;
}
