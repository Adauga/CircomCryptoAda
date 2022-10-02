pragma circom 2.0.0;

include "macro/rounds.circom";
include "macro/rounds.circom";

template Main() {
    signal input a;
    signal input b;
    signal output out;

    component rounds = roundTail(3);
    component rounds1 = roundA(3);
    component rounds2 = roundB(3);
    component rounds3 = round1(3);
}

component main = Main();