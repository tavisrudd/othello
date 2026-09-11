import itertools
import json
from collections import Counter
from fractions import Fraction
from math import comb


def stabilizer_six_qubits():
    words = ('XZZXII','IXZZXI','XIXZZI','ZXIXZI','XXXXXX','ZZZZZZ')
    def label(word):
        return tuple((int(c in 'XY'), int(c in 'ZY')) for c in word)
    generators = tuple(map(label, words))
    assert all(sum(a[0]*b[1] + a[1]*b[0] for a,b in zip(u,v)) % 2 == 0
               for u,v in itertools.combinations(generators,2))
    labels = []
    for bits in itertools.product(range(2), repeat=6):
        labels.append(tuple(tuple(sum(bits[k]*generators[k][j][a] for k in range(6)) % 2 for a in range(2)) for j in range(6)))
    assert len(set(labels)) == 64
    assert min(sum(v != (0,0) for v in row) for row in labels[1:]) == 4
    coefficients = list(itertools.product(range(2), repeat=6))
    B, C = {0,1,2}, {3,4,5}
    supports = [B | {j} for j in sorted(C)] + [C | {i} for i in sorted(B)]
    subgroup_coeffs = [tuple(bits for bits,row in zip(coefficients,labels) if all(row[j] == (0,0) for j in range(6) if j not in S)) for S in supports]
    assert all(len(group) == 4 for group in subgroup_coeffs)
    for chosen in itertools.combinations(subgroup_coeffs,3):
        span = {tuple(sum(v[j] for v in vectors) % 2 for j in range(6))
                for vectors in itertools.product(*chosen)}
        assert len(span) == 64
    failures = []
    for chi in coefficients[1:]:
        failures.append(tuple(any(sum(x*y for x,y in zip(chi,bits))%2 for bits in group) for group in subgroup_coeffs))
    histogram = Counter(map(sum, failures))
    assert histogram == {4:45, 6:18}
    for s in range(1,7):
        for chosen in itertools.combinations(range(6),s):
            gap = min(Fraction(sum(row[i] for i in chosen),s) for row in failures)
            expected = Fraction(max(0,s-2),s)
            assert gap == expected
    weights = (Fraction(0),Fraction(1,15),Fraction(2,15),Fraction(3,15),Fraction(4,15),Fraction(5,15))
    assert min(sum(w*b for w,b in zip(weights,row)) for row in failures) == sum(sorted(weights)[:4])
    return {'generators_symplectically_commute':True,'minimum_label_support':4, 'all_20_half_libraries_span':True, 'character_failure_histogram':dict(histogram), 'all_63_nonempty_two_star_subsets_checked':True,'weighted_gap_checked':True}


def spectra():
    output = {}
    for m,q in ((2,3),(3,2)):
        Q=q*q
        A={0:1}
        for w in range(m+1,2*m+1):
            A[w]=comb(2*m,w)*sum((-1)**j*comb(w,j)*(Q**(w-m-j)-1) for j in range(w-m))
        assert sum(A.values()) == q**(2*m)
        assert all(n>=0 for n in A.values())
        output[f'm={m},q={q}']=A
    return output


if __name__ == '__main__':
    result={'exact_six_qubit_checks':stabilizer_six_qubits(),'weight_enumerator_arithmetic':spectra()}
    print(json.dumps(result,indent=2))
