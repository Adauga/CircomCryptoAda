pragma circom 2.0.0;

template state(x) {
    signal output out[32];
    var c[5] = [0x67452301,
             0xEFCDAB89,
             0x98BADCFE,
             0x10325476,
             0xC3D2E1F0];

    for (var i=0; i<32; i++) {
        out[i] <== (c[x] >> i) & 1;
    }
}