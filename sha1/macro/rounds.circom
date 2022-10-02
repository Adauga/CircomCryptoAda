pragma circom 2.0.0;

/*
SCHEDULE(i)                                                            
    temp = schedule[(i - 3) & 0xF] ^ schedule[(i - 8) & 0xF]^            
            schedule[(i - 14) & 0xF] ^ schedule[(i - 16) & 0xF];          
    schedule[i & 0xF] = temp << 1 | temp >> 31;  <==RotR
*/
template schedule(i) {
	signal input in[16];
	signal output out[16];

	signal temp;

	temp <-- in[(i - 3) & 0xF] ^ in[(i - 8) & 0xF]^            
                in[(i - 14) & 0xF] ^ in[(i - 16) & 0xF];


    for (var k = 0; k < 16; k++) {
    	if (k != (i & 0xF)) {
    		out[k] <== in[k];
    	}
    }
	out[i & 0xF] <-- (temp << 1) | (temp >> 31);
}

/*
ROUNDTAIL(a, b, e, f, i, k)                                            
    e += ((((a << 5 | a >> 27) + f) + k) + schedule[i & 0xF]);             
    b = b << 30 | b >> 2;
*/
template roundTail(i) {
	signal input in[16];
	signal input a;
	signal input b;
	signal input e;
	signal input f;
	signal input k;
	signal output e_upd;
	signal output b_upd;

	e_upd <-- e + (((((a << 5) | (a >> 27)) + f) + k) + in[i & 0xF]);
	e_upd - e_upd === 0;
	b_upd <-- (b << 30) | (b >> 2);
	b_upd - b_upd === 0;
}

/*
ROUND0a(a, b, c, d, e, i)                                               
    schedule[i] = (block[i] << 24) | ((block[i] & 0xFF00) << 8) |           
                      ((block[i] >> 8) & 0xFF00) | (block[i] >> 24);           
    ROUNDTAIL(a, b, e, ((b & c) | (~b & d)), i, 0x5A827999)
*/
template roundA(i) {
	signal input schedule[16];
	signal input block[16];
	signal input a;
	signal input b;
	signal input c;
	signal input d;
	signal input e;
	signal output e_upd;
	signal output b_upd;
	signal output schedule_upd[16];
	var k;

	component roundT = roundTail(i);

	for (k = 0; k < 16; k++) {
		if (k != i) {
			schedule_upd[k] <== schedule[k];
		}
	}
	schedule_upd[i] <-- ((block[i] << 24) | ((block[i] & 0xFF00) << 8) | ((block[i] >> 8) & 0xFF00) | (block[i] >> 24));
	for (var k = 0; k < 16; k++) {
		roundT.in[k] <== schedule_upd[k];
	}
	roundT.a <== a;
	roundT.b <== b;
	roundT.e <== e;
	roundT.f <-- ((b & c) | (~b & d));
	roundT.k <== 0x5A827999;
	e_upd <== roundT.e_upd;
	b_upd <== roundT.b_upd;
}

/*
ROUND0b(a, b, c, d, e, i)
    SCHEDULE(i)
    ROUNDTAIL(a, b, e, ((b & c) | (~b & d)), i, 0x5A827999)
*/
template roundB(i) {
	signal input schedule[16];
	signal input a;
	signal input b;
	signal input c;
	signal input d;
	signal input e;
	signal output e_upd;
	signal output b_upd;
	signal output schedule_upd[16];
	var k;

	component scheduleComp = schedule(i);
	component roundT = roundTail(i);

	for (k = 0; k < 16; k++) {
		scheduleComp.in[k] <== schedule[k];
	}
	for (k = 0; k < 16; k++) {
		roundT.in[k] <== scheduleComp.out[k];
	}
	roundT.a <== a;
	roundT.b <== b;
	roundT.e <== e;
	roundT.f <-- ((b & c) | (~b & d));
	roundT.k <== 0x5A827999;

	e_upd <== roundT.e_upd;
	b_upd <== roundT.b_upd;
	for (k = 0; k < 16; k++) {
		schedule_upd[k] <== scheduleComp.out[k];
	}
}

/*
ROUND1(a, b, c, d, e, i)
    SCHEDULE(i)
    ROUNDTAIL(a, b, e, (b ^ c ^ d), i, 0x6ED9EBA1)
*/
template round1(i) {
	signal input schedule[16];
	signal input a;
	signal input b;
	signal input c;
	signal input d;
	signal input e;
	signal output e_upd;
	signal output b_upd;
	signal output schedule_upd[16];
	var k;

	component scheduleComp = schedule(i);
	component roundT = roundTail(i);

	for (k = 0; k < 16; k++) {
		scheduleComp.in[k] <== schedule[k];
	}
	for (k = 0; k < 16; k++) {
		roundT.in[k] <== scheduleComp.out[k];
	}

	roundT.a <== a;
	roundT.b <== b;
	roundT.e <== e;
	roundT.f <-- (b ^ c ^ d);
	roundT.k <== 0x6ED9EBA1;

	e_upd <== roundT.e_upd;
	b_upd <== roundT.b_upd;

	for (k = 0; k < 16; k++) {
		schedule_upd[k] <== scheduleComp.out[k];
	}
}

/*
ROUND2(a, b, c, d, e, i)
    SCHEDULE(i)
    ROUNDTAIL(a, b, e, ((b & c) ^ (b & d) ^ (c & d)), i, 0x8F1BBCDC) <==xor3 
*/
template round2(i) {
	signal input schedule[16];
	signal input a;
	signal input b;
	signal input c;
	signal input d;
	signal input e;
	signal output e_upd;
	signal output b_upd;
	signal output schedule_upd[16]

	component scheduleComp = schedule(i);
	component roundT = roundTail(i);

	for (k = 0; k < 16; k++) {
		scheduleComp.in[k] <== schedule[k];
	}
	for (k = 0; k < 16; k++) {
		roundT.in[k] <== scheduleComp.out[k];
	}

	roundT.a <== a;
	roundT.b <== b;
	roundT.e <== e;
	roundT.f <-- ((b & c) ^ (b & d) ^ (c & d));
	roundT.k <== 0x8F1BBCDC;

	e_upd <== roundT.e_upd;
	b_upd <== roundT.b_upd;

	for (k = 0; k < 16; k++) {
		schedule_upd[k] <== scheduleComp.out[k];
	}
}

/*
ROUND3(a, b, c, d, e, i)
    SCHEDULE(i)                 
    ROUNDTAIL(a, b, e, (b ^ c ^ d), i, 0xCA62C1D6)
*/
template round3(i) {
	signal input schedule[16];
	signal input a;
	signal input b;
	signal input c;
	signal input d;
	signal input e;
	signal output e_upd;
	signal output b_upd;
	signal output schedule_upd[16]

	component scheduleComp = schedule(i);
	component roundT = roundTail(i);

	for (k = 0; k < 16; k++) {
		scheduleComp.in[k] <== schedule[k];
	}
	for (k = 0; k < 16; k++) {
		roundT.in[k] <== scheduleComp.out[k];
	}

	roundT.a <== a;
	roundT.b <== b;
	roundT.e <== e;
	roundT.f <-- (b ^ c ^ d);
	roundT.k <== 0xCA62C1D6;

	e_upd <== roundT.e_upd;
	b_upd <== roundT.b_upd;

	for (k = 0; k < 16; k++) {
		schedule_upd[k] <== scheduleComp.out[k];
	}
}