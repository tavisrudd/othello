# Universal rank-two residue verification

The rational calculation is proved in the manuscript. These programs check
its finite identities; neither proves a quantum input, cluster persistence,
low-dimensional vanishing or lattice transport.

derive.py uses SymPy 1.14.0 over Q(a,b,q), q(2a+b) nonzero. It computes the
rational split, both Sylvester equations, derivative correction, residue,
original-basis Frobenius recurrence, cubic normalization and Fano values.
check_indicial.py uses independent Fraction Gaussian elimination at four
nonzero rational q-values and recovers each quadratic from three exponent
evaluations. These checks corroborate the symbolic general-domain proof.
The degree-four control is arithmetic only: no quantum input is imported.

From the paper root:
    uv run --with sympy==1.14.0 python verification/check_universal_residue.py

Regenerate by redirecting stdout of universal-residue/derive.py and
universal-residue/check_indicial.py to their adjacent .json files, in that
order, then refresh SHA256SUMS. The aggregate checker requires exact output
equality and recorded byte hashes. No randomness is used.
