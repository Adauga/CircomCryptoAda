/* Xor4 function for sha1

Multi-Factor XOR

A ^ B ^ C ^ D ...

in my case 4, in bitwise ignore power

out = ad−8a7bd+28abd−56abd+70abd−56abd+28abd−8abd+bd−4acd+24abcd−60abcd+80abcd−60abcd+24abcd−4bcd+6acd−24abcd+36abcd−24abcd+6bcd−4acd+8abcd−4bcd+cd =>
out = −8abd+4abcd+6abd−2acd−2bcd+ad+bd+cd =>
out = 4abcd−2abd−2acd−2bcd+ad+bd+c
out = a(4bcd - 2bd - 2cd + d) - 2bcd + bd + c

*/

pragma circom 2.0.0;

template Xor4(n) {
	signal input a[n];
	signal input b[n];
	signal input c[n];
	signal input d[n];

	signal output out[n];

	for (var k=0; k<n; k++) {
        out[k] <== a[k] * (4*b[k]*c[k]*d[k] - 2*b[k]*d[k] - 2*c[k]*d[k] +d[k]) - 2*b[k]*c[k]*d[k] + b[k]*d[k] + c[k];
    }
}
