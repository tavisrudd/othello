"""Exact Laurent-matrix witness against KS v1 Proposition 2.1, rank three."""
from pathlib import Path
from fractions import Fraction as F
import json
import runpy

lin = runpy.run_path(str(Path(__file__).with_name('2026-09-09-c1133-independent-checks.py')))
eye, zero, add, mul, scale = (lin[x] for x in ['eye','zero','add','mul','scale'])


def tidy(a):
    return {k:v for k,v in a.items() if v != zero(3,3)}


def plus(a,b):
    return tidy({k:add(a.get(k,zero(3,3)),b.get(k,zero(3,3))) for k in a.keys()|b.keys()})


def times(a,b):
    out = {}
    for i,x in a.items():
        for j,y in b.items():
            out[i+j] = add(out.get(i+j,zero(3,3)),mul(x,y))
    return tidy(out)


def derivative(a):
    return tidy({k-1:scale(k,v) for k,v in a.items() if k})


def gauge(k,g,gi):
    assert times(g,gi) == times(gi,g) == {0:eye(3)}
    return plus(times(times(gi,k),g),times(gi,derivative(g)))


def serialize(a):
    return {str(k):[[str(x) for x in row] for row in v] for k,v in sorted(a.items())}


def run():
    n = [[F(0),F(1),F(0)],[F(0),F(0),F(1)],[F(0),F(0),F(0)]]
    h = zero(3,3);h[2][0] = F(1)
    g,gi = {0:eye(3),1:h},{0:eye(3),1:scale(-1,h)}
    s = {i:[[F(i == j == k) for j in range(3)] for k in range(3)] for i in range(3)}
    si = {-i:v for i,v in s.items()}
    comm = add(mul(n,h),scale(-1,mul(h,n)))
    out = {}
    for label,ds in [('trivial_monodromy',[F(0)]*3),
                     ('distinct_nonunit_monodromy',[F(1,7),F(2,7),F(3,7)])]:
        d = [[ds[i] if i == j else F(0) for j in range(3)] for i in range(3)]
        k0 = tidy({-2:n,-1:d})
        k = gauge(k0,g,gi)
        assert k[-2] == n
        assert k[-1] == add(d,comm)
        assert k[-1][1][0] == 1 and k[-1][2][1] == -1
        assert min(k) == -2
        # The shearing S makes the original connection logarithmic.
        logarithmic = gauge(k0,s,si)
        assert set(logarithmic) == {-1}
        expected = add(n,[[ds[i]+i if i == j else F(0) for j in range(3)] for i in range(3)])
        assert logarithmic[-1] == expected
        # T = G^-1 S provides the same logarithmic lattice for the example.
        t,ti = times(gi,s),times(si,g)
        assert gauge(k,t,ti) == logarithmic
        out[label] = {'connection_coefficients':serialize(k),
                      'logarithmic_residue':serialize(logarithmic),
                      'regular_frame_change':serialize(g),
                      'logarithmic_lattice_frame':serialize(t),
                      'logarithmic_residue_eigenvalues':[str(ds[i]+i) for i in range(3)],
                      'lower_residue_entries':['1','-1']}
    return {'status':'PASS','source':'arXiv:2607.22074v1, Proposition 2.1',
            'scope':'rank-three counterexample to K[-1] being upper triangular in the original frame',
            'examples':out}


if __name__ == '__main__':
    result = run()
    Path(__file__).with_suffix('.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
    print(result['status']+': two exact framing counterexamples, including distinct nonunit monodromy')
