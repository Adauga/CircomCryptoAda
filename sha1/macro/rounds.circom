/*
ROUND0b(a, b, c, d, e, i)
    SCHEDULE(i)
    ROUNDTAIL(a, b, e, ((b & c) | (~b & d)), i, 0x5A827999)

ROUND1(a, b, c, d, e, i)
    SCHEDULE(i)
    ROUNDTAIL(a, b, e, (b ^ c ^ d), i, 0x6ED9EBA1) <== xor3

ROUND2(a, b, c, d, e, i)
    SCHEDULE(i)
    ROUNDTAIL(a, b, e, ((b & c) ^ (b & d) ^ (c & d)), i, 0x8F1BBCDC) <==xor3

ROUND3(a, b, c, d, e, i)
    SCHEDULE(i)
*/