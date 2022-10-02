pragma circom 2.0.0;

include "rounds.circom";

/*
ROUND0a_UNROLL(i)
        ROUND0a(a, b, c, d, e, (0 + i)); b/ e
        ROUND0a(e, a, b, c, d, (1 + i)); a/ d
        ROUND0a(d, e, a, b, c, (2 + i)); e/ c
        ROUND0a(c, d, e, a, b, (3 + i)); d/ b
        ROUND0a(b, c, d, e, a, (4 + i))  c/ a
*/
template roundAUnroll(i) {
	signal input schedule[16];
	signal input block[16];
	signal input a;
	signal input b;
	signal input c;
	signal input d;
	signal input e;
	signal output a_upd;
	signal output b_upd;
	signal output c_upd;
	signal output d_upd;
	signal output e_upd;
	signal output schedule_upd[16];
	var k;

	signal temp_a;
	signal temp_b;
	signal temp_c;
	signal temp_d;
	signal temp_e;

	component round1_A = roundA(i);
	component round2_A = roundA(1 + i);
	component round3_A = roundA(2 + i);
	component round4_A = roundA(3 + i);
	component round5_A = roundA(4 + i);

	for (k = 0; k < 16; k++) {
		round1_A.block[k] <== block[k];
		round1_A.schedule[k] <== schedule[k];
	}
	round1_A.a <== a;
	round1_A.b <== b;
	round1_A.c <== c;
	round1_A.d <== d;
	round1_A.e <== e;

	temp_a <== a;
	temp_b <== round1_A.b_upd;
	temp_c <== c;
	temp_d <== d;
	temp_e <== round1_A.e_upd;

	for (k = 0; k < 16; k++) {
		round2_A.block[k] <== block[k];
		round2_A.schedule[k] <== round1_A.schedule_upd[k];
	}
	round2_A.a <== temp_e;
	round2_A.b <== temp_a;
	round2_A.c <== temp_b;
	round2_A.d <== temp_С;
	round2_A.e <== temp_d;

	temp_a <== round2_A.b_upd;
	temp_d <== round2_A.e_upd;

	for (k = 0; k < 16; k++) {
		round3_A.block[k] <== block[k];
		round3_A.schedule[k] <== round2_A.schedule_upd[k];
	}
	round3_A.a <== temp_d;
	round3_A.b <== temp_e;
	round3_A.c <== temp_a;
	round3_A.d <== temp_b;
	round3_A.e <== temp_e;

	temp_e <== round3_A.b_upd;
	temp_c <== round3_A.e_upd;

	for (k = 0; k < 16; k++) {
		round4_A.block[k] <== block[k];
		round4_A.schedule[k] <== round3_A.schedule_upd[k];
	}
	round4_A.a <== temp_c;
	round4_A.b <== temp_d;
	round4_A.c <== temp_e;
	round4_A.d <== temp_a;
	round4_A.e <== temp_b;

	temp_d <== round4_A.b_upd;
	temp_b <== round4_A.e_upd;

	for (k = 0; k < 16; k++) {
		round5_A.block[k] <== block[k];
		round5_A.schedule[k] <== round4_A.schedule_upd[k];
	}
	round5_A.a <== temp_b;
	round5_A.b <== temp_с;
	round5_A.c <== temp_d;
	round5_A.d <== temp_e;
	round5_A.e <== temp_a;

	temp_c <== round5_A.b_upd;
	temp_a <== round5_A.e_upd;

	a_upd <== temp_a;
	b_upd <== temp_b;
	c_upd <== temp_c;
	d_upd <== temp_d;
	e_upd <== temp_e;
	for (k = 0; k < 16; k++) {
		schedule_upd[k] <== round5_A.schedule_upd[k];
	}
}