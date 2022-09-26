pragma circom 2.0.0;

include "xor3.circom";

/*
 SCHEDULE(i)                                                            
      temp = schedule[(i - 3) & 0xF] ^ schedule[(i - 8) & 0xF]^            
                schedule[(i - 14) & 0xF] ^ schedule[(i - 16) & 0xF];          
     schedule[i & 0xF] = temp << 1 | temp >> 31;  <==RotR
*/

template Shedule(i) {
	signal input in[16][32];
	singal output out[32];
	var k;

	signal temp;

    component xor4 = Xor4(32);
    component rotateR = RotR(32, 1); 

    for (k = 0; k < 32; k++) {
    	xor4.a[k] <== in[(i - 3) & 0xF][k];
    	xor4.b[k] <== in[(i - 8) & 0xF][k];
    	xor4.c[k] <== in[(i - 14) & 0xF][k];
    	xor4.d[k] <== in[(i - 16) & 0xF][k];
    }

    for (k = 0; k < 32; k++) {
    	rotateR.in[k] <== xor4.out[k];
    }

	for (k = 0; k < 32; k++) {
		out[k] <== rotateR.out[k];
	}
}