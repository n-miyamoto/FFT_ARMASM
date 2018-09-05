#include <stdio.h>
#include <string.h>

#include "fft_arm9e.h"

#define N 4

int main(void){
	int i=0;	
	short x[2*N];
	short y[2*N];
	
	memset(x,0,4*N);
	memset(y,0,4*N);

	for(i=0;i<N;i++){
		x[2*i] = 1;
		x[2*i+1]=0;
	}
	fft_16_arm9e(y, x, N);

	for(i=0;i<N;i++){
		printf("%d + %d i \n", x[2*i], x[2*i+1]);
	}

	for(i=0;i<N;i++){
		printf("%d + %d i \n", y[2*i], y[2*i+1]);
	}

	return 0;
}
