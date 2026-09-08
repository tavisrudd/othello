"""Check displayed geometric witnesses; optionally replay arithmetic with Sage."""
import argparse
import json
from itertools import combinations
from pathlib import Path
from frame_model import Field, model

ROOT = Path(__file__).resolve().parent


def normalized(resolution):
    return sorted(sorted(sorted(block) for block in part) for part in resolution)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--sage', action='store_true')
    args = ap.parse_args()
    _, points, words, edges, _ = model(7)
    witness = [(2, 3), (2, 4), (5, 4), (6, 2), (6, 4)]
    ids = [points.index(p) for p in witness]
    assert [words[i] for i in ids] == [
        (2, 3, 3, 4), (2, 4, 4, 5), (5, 4, 3, 6),
        (6, 2, 3, 5), (6, 4, 5, 4)]
    assert all(tuple(sorted(pair)) in edges for pair in combinations(ids, 2))
    assert all(len({words[i][c] for i in ids}) > 1 for c in range(4))
    displayed = {
        5: [(2, 5)],
        8: [(2, 21), (3, 6), (4, 9), (5, 29), (7, 19), (8, 27),
            (10, 25), (11, 28), (12, 24), (13, 20), (16, 23), (18, 22)],
    }
    records = json.loads((ROOT / 'boundary.json').read_text())['records']
    for rec in records:
        q = rec['q']
        if q not in displayed:
            continue
        _, points, _, edges, geometric = model(q)
        permutation = list(range(len(points)))
        for a, b in displayed[q]:
            permutation[a], permutation[b] = b, a
        assert permutation == rec['exotic_representative']
        assert sorted(tuple(sorted((permutation[a], permutation[b])))
                      for a, b in edges) == edges
        image = normalized([[[permutation[v] for v in block] for block in part]
                            for part in geometric])
        assert image != geometric and image in rec['all_resolutions']
        if q == 8:
            assert sorted(permutation[v] for v in [0, 1, 2, 3, 4]) == [0, 1, 6, 9, 21]
            assert not ({tuple(b) for p in image for b in p} &
                        {tuple(b) for p in geometric for b in p})
        else:
            assert points[2] == (3, 2) and points[5] == (4, 3)
    print('PASS five-clique words and both displayed exceptional involutions')

    if args.sage:
        from sage.all import GF, PolynomialRing
        models = [Field(q) for q in (9, 16, 25)]
        alternate = Field(16)
        alternate.mod = (1, 0, 0, 1, 1)
        models.append(alternate)
        for f in models:
            ring = PolynomialRing(GF(f.p), 'X')
            polynomial = ring(list(f.mod))
            assert polynomial.is_irreducible()
            field = GF(f.q, name='a', modulus=polynomial)
            values = [sum(c * field.gen()**i for i, c in enumerate(f.digits(x)))
                      for x in range(f.q)]
            assert len(set(values)) == f.q
            for x in range(f.q):
                assert values[f.power(x, f.p)] == values[x]**f.p
                for y in range(f.q):
                    assert values[f.add(x, y)] == values[x] + values[y]
                    assert values[f.sub(x, y)] == values[x] - values[y]
                    assert values[f.mul(x, y)] == values[x] * values[y]
                    if y:
                        assert values[f.div(x, y)] == values[x] / values[y]
            print('PASS Sage arithmetic q=%d modulus=%s' % (f.q, f.mod))


if __name__ == '__main__':
    main()
