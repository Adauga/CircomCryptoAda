pragma circom 2.0.0;


template sha1_compress(x) {
	signal input state[5][32];
	signal input last_block[64][8];

	signal block[16][32];
	signal output a[32];
	signal output b[32];
	signal output c[32];
	signal output d[32];
	signal output e[32];
	signal shedule[16][32];
	signal temp[32];

	a <== state[0];

	//tempate last block -> block

    /*
    ROUND0a_UNROLL(0);
    ROUND0a_UNROLL(5);
    ROUND0a_UNROLL(10);

    ROUND0b_UNROLL;

    ROUND1_UNROLL(0);
    ROUND1_UNROLL(5);
    ROUND1_UNROLL(10);
    ROUND1_UNROLL(15);;

	ROUND2_UNROLL(0);
    ROUND2_UNROLL(5);
    ROUND2_UNROLL(10);
    ROUND2_UNROLL(15);

    ROUND3_UNROLL(0);
    ROUND3_UNROLL(5);
    ROUND3_UNROLL(10);
    ROUND3_UNROLL(15);
    */



}