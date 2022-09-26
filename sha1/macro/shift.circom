pragma circom 2.0.0;

template ShR(n, r) {
    signal input in[n];
    signal output out[n];

    for (var i=0; i<n; i++) {
        if (i+r >= n) {
            out[i] <== 0;
        } else {
            out[i] <== in[ i+r ];
        }
    }
}

template ShL(n, l) {
	signal input in[n];
	signal output out[n];

	for (var i = n; i > 0; i--) {
		if (i < l) {
			out[i] <== 0;
		} else {
			out[i] <== in[i - l];
		}
	}
}