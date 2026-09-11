"""Exact algebra check for the C1133 ruled-product reduction; no GW oracle."""
import argparse
import hashlib
import json
from pathlib import Path

import sympy as s

HERE = Path(__file__).resolve()
OUT = HERE.with_suffix('.json')
HASHES = HERE.with_suffix('.sha256')


def certificate():
    v, a, b, c, Q, k, x = s.symbols('v a b c Q k x')
    coords = [v, a, b, c]
    # Q denotes q*exp(b); retain b in the classical term.
    F = v*v*c/2 + v*a*b + c*Q

    def derivative(f, i):
        return s.diff(f, coords[i]) + (Q*s.diff(f, Q) if i == 2 else 0)

    pairing = s.Matrix([[0, 0, 0, 1], [0, 0, 1, 0],
                        [0, 1, 0, 0], [1, 0, 0, 0]])
    products = []
    for i in range(4):
        columns = []
        for j in range(4):
            cubic = s.Matrix([derivative(derivative(derivative(F, i), j), l)
                              for l in range(4)])
            columns.append(pairing.inv()*cubic)
        products.append(s.Matrix.hstack(*columns))
    one, h, p, hp = products
    I, zero = s.eye(4), s.zeros(4)

    def equal(A, B):
        assert (A-B).applyfunc(s.simplify) == zero

    equal(one, I)
    equal(h*h, zero)
    equal(h*p, hp)
    equal(p*p, Q*(I+c*h))
    for i in range(4):
        for j in range(4):
            coeff = products[i][:, j]
            equal(products[i]*products[j],
                  sum((coeff[l]*products[l] for l in range(4)), zero))
    pprime = (I-c*h/2)*p
    U = k*h+2*p-c*hp
    equal(pprime*pprime, Q*I)
    equal(U, k*h+2*pprime)
    assert s.factor(U.charpoly(x).as_expr()) == (x*x-4*Q)**2
    # After Q=t^2, genuine separated projectors, including k=0.
    t = s.symbols('t', nonzero=True)
    Ut, ht = U.subs(Q, t*t), h.subs(Q, t*t)
    pt = pprime.subs(Q, t*t)
    ranks = []
    for sign in [-1, 1]:
        E = (I+sign*pt/t)/2
        equal(E*E, E)
        assert s.simplify(s.trace(E)) == 2
        N = (Ut-sign*2*t*I)*E
        equal(N, k*ht*E)
        equal(N*N, zero)
        equal(N.subs(k, 0), zero)
        assert N.rank() == 1
        ranks.append({'sign': sign, 'even_rank': 2,
                      'nilpotent_rank_over_Q_c_t_k': 1,
                      'nilpotent_rank_at_k_zero': 0})
    return {'schema': 'c1133-ruled-product-v1', 'sympy': s.__version__,
            'basis': ['1', 'h', 'p', 'hp'],
            'potential_input': 'v^2*c/2 + v*a*b + c*Q; d_b(Q)=Q',
            'relations_verified': ['h^2=0', 'h*p=hp', 'p^2=Q*(1+c*h)',
                                   "p_prime^2=Q", "U=k*h+2*p_prime"],
            'associativity_pairs_checked': 16,
            'characteristic_polynomial': '(x^2-4*Q)^2',
            'blocks': ranks,
            'boundary': 'Checks consequences of the supplied potential, not its GW derivation or transport.'}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    data = (json.dumps(certificate(), indent=2, sort_keys=True)+'\n').encode()
    rows = []
    for path, blob in [(HERE, HERE.read_bytes()), (OUT, data)]:
        rows.append(f'{hashlib.sha256(blob).hexdigest()}  {path.name}  {len(blob)} bytes')
    manifest = ('\n'.join(rows)+'\n').encode()
    if args.check:
        assert OUT.read_bytes() == data
        assert HASHES.read_bytes() == manifest
    else:
        OUT.write_bytes(data)
        HASHES.write_bytes(manifest)
    print('Verified potential algebra, 16 associativity pairs, two rank-two blocks, elliptic zero operator.')


if __name__ == '__main__':
    main()
