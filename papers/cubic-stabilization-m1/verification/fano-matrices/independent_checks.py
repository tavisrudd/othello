"""Independent Fraction elimination; no import of the table or SymPy.

Consumes the frozen matrix certificate. Checks all characteristic polynomials,
cyclicity and all nine rank-two residues using explicit separated Jordan frames.
"""
from fractions import Fraction as F
from pathlib import Path
import json
import sys


def eye(n):
    return [[F(i == j) for j in range(n)] for i in range(n)]


def zero(n, m):
    return [[F(0) for _ in range(m)] for _ in range(n)]


def add(a, b):
    return [[x+y for x, y in zip(r, s)] for r, s in zip(a, b)]


def scale(c, a):
    return [[c*x for x in r] for r in a]


def mul(a, b):
    return [[sum(x*y for x, y in zip(r, col)) for col in zip(*b)] for r in a]


def power(a, n):
    r = eye(len(a))
    for _ in range(n):
        r = mul(r, a)
    return r


def rref(a):
    a = [r[:] for r in a]
    pivots = []
    for j in range(len(a[0])):
        k = next((k for k in range(len(pivots), len(a)) if a[k][j]), None)
        if k is None:
            continue
        i = len(pivots)
        a[i], a[k] = a[k], a[i]
        c = a[i][j]
        a[i] = [x/c for x in a[i]]
        for k in range(len(a)):
            if k != i:
                c = a[k][j]
                a[k] = [x-c*y for x, y in zip(a[k], a[i])]
        pivots.append(j)
        if len(pivots) == len(a):
            break
    return a, pivots


def inverse(a):
    n = len(a)
    rows, pivots = rref([r+s for r, s in zip(a, eye(n))])
    assert pivots == list(range(n))
    return [r[n:] for r in rows]


def kernel(a):
    a, pivots = rref(a)
    vectors = []
    for j in range(len(a[0])):
        if j in pivots:
            continue
        v = [F(k == j) for k in range(len(a[0]))]
        for i, p in enumerate(pivots):
            v[p] = -a[i][j]
        vectors.append([[x] for x in v])
    return vectors


def columns(vectors):
    return [[v[i][0] for v in vectors] for i in range(len(vectors[0]))]


def charpoly(a):
    # Faddeev--LeVerrier, descending coefficients.
    b = eye(len(a))
    out = [F(1)]
    for k in range(1, len(a)+1):
        ab = mul(a, b)
        c = -sum(ab[i][i] for i in range(len(a)))/k
        out.append(c)
        b = add(ab, scale(c, eye(len(a))))
    assert b == zero(len(a), len(a))
    return out


EXPECTED = {
    'g2': [1,-1728,0,0,0], 'g3': [1,-256,0,0,0],
    'g4': [1,-108,0,0,0], 'g5': [1,-64,0,0,0],
    'g6': [1,-44,-16,0,0], 'g7': [1,-34,1,0,0],
    'g8': [1,-26,-27,0,0], 'g9': [1,-24,16,0,0],
    'g10': [1,-18,-27,0,0],
    'g12': [1,F(-68,5),F(-616,25),F(-252,125),F(-1504,625)],
    'd1': [1,0,-1728,0,0], 'd2': [1,0,-256,0,0],
    'd3': [1,0,-108,0,0], 'd4': [1,0,-64,0,0],
    'd5': [1,0,-44,0,-16], 'quadric': [1,0,0,-108,0],
    'projective_space': [1,0,0,0,-256],
}


def rank_two_residue(u, d):
    u2 = power(u, 2)
    v = next(v for v in kernel(u2) if mul(u, v) != zero(4, 1))
    vectors = [mul(u, v), v]
    for col in zip(*u2):
        candidate = [[x] for x in col]
        trial = columns(vectors+[candidate])
        if len(rref(trial)[1]) > len(vectors):
            vectors.append(candidate)
    assert len(vectors) == 4
    change = columns(vectors)
    ui = mul(mul(inverse(change), u), change)
    di = mul(mul(inverse(change), d), change)
    assert [r[:2] for r in ui[:2]] == [[0,1],[0,0]]
    assert [r[2:] for r in ui[:2]] == zero(2,2)
    assert [r[:2] for r in ui[2:]] == zero(2,2)
    n = [[F(0),F(1)],[F(0),F(0)]]
    m = [r[2:] for r in ui[2:]]
    dcb = [r[:2] for r in di[2:]]
    dbc = [r[2:] for r in di[:2]]
    mi = inverse(m)
    x = scale(-1, add(mul(mi,dcb),mul(mul(power(mi,2),dcb),n)))
    assert add(add(mul(m,x),scale(-1,mul(x,n))),dcb) == zero(2,2)
    b1 = mul(dbc,x)
    assert di[1][0] == 0
    residue = [[di[0][0],F(1)],[b1[1][0],di[1][1]-1]]
    delta = (residue[0][0]-residue[1][1])**2+4*residue[1][0]
    return residue, delta


def run():
    src = Path(__file__).with_name('finite_checks.json')
    rows = json.loads(src.read_text())['families']
    assert set(rows) == set(EXPECTED)
    grading = [[F(3-2*i,2) if i == j else F(0) for j in range(4)] for i in range(4)]
    out = {}
    for name, row in sorted(rows.items()):
        u = [[F(x) for x in r] for r in row['shifted_counting_matrix']]
        cp = charpoly(u)
        assert cp == EXPECTED[name], (name,cp)
        unit = [[F(i == 0)] for i in range(4)]
        cyclic = columns([mul(power(u,k),unit) for k in range(4)])
        assert all(cyclic[i][i] == 1 for i in range(4))
        assert all(cyclic[i][j] == 0 for i in range(4) for j in range(i))
        result = {'characteristic_coefficients': list(map(str,cp)), 'cyclic_determinant': '1'}
        if row['rank_two_certificates']:
            assert len(row['rank_two_certificates']) == 1
            residue, delta = rank_two_residue(u, grading)
            assert delta == F(row['rank_two_certificates'][0]['delta'])
            result.update(residue=[[str(x) for x in r] for r in residue], delta=str(delta))
        out[name] = result
    assert sum('delta' in r for r in out.values()) == 9
    return {'status':'PASS', 'scope':'17 characteristic polynomials and cyclicity; 9 independently separated rank-two residues', 'families':out}


if __name__ == '__main__':
    result = run()
    destination = Path(__file__).with_suffix('.json')
    rendered = json.dumps(result,indent=2,sort_keys=True)+'\n'
    if '--check' in sys.argv:
        assert destination.read_text() == rendered, 'independent certificate is stale'
    else:
        destination.write_text(rendered)
    print(result['status']+': '+result['scope'])
