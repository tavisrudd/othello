"""Check displayed geometric witnesses; optionally replay arithmetic with Sage."""
import argparse
import json
import hashlib
from itertools import combinations
from pathlib import Path
from frame_model import Field, model

ROOT = Path(__file__).resolve().parent


def normalized(resolution):
    return sorted(sorted(sorted(block) for block in part) for part in resolution)


def compose(a, b):
    """Right-to-left composition: (a b)(i) = a(b(i))."""
    return tuple(a[b[i]] for i in range(len(a)))


def generated_group(generators, identity):
    seen = {identity}; todo = [identity]
    while todo:
        p = todo.pop()
        for g in generators:
            h = compose(g, p)
            if h not in seen:
                seen.add(h); todo.append(h)
    return seen


def exceptional_group_record(q, tau):
    f, points, words, edges, _ = model(q)
    index = {word: i for i, word in enumerate(words)}
    actions = [lambda a,b,c,d: (b,a,f.div(1,c),f.div(1,d)),
               lambda a,b,c,d: (c,f.div(1,b),a,f.sub(1,d)),
               lambda a,b,c,d: (f.sub(1,a),f.sub(1,b),d,c)]
    generators = [tuple(index[action(*word)] for word in words) for action in actions]
    identity = tuple(range(len(points)))
    frame = generated_group(generators, identity)
    assert len(frame) == 24
    if q == 8:
        sigma = tuple(index[tuple(f.power(a,2) for a in word)] for word in words)
        s = compose(generators[1], compose(generators[2], generators[1]))
        z = compose(s, tuple(tau))
        assert compose(z,z) == identity and z != identity
        assert all(compose(z,g) == compose(g,z) for g in generators)
        assert compose(z,compose(sigma,z)) == compose(sigma,sigma)
        assert compose(sigma,compose(sigma,sigma)) == identity and sigma != identity
        extra_generators = [sigma,z]
    else:
        # Antipodal involution of the octahedral graph.
        edge_set = set(edges)
        z = tuple(next(j for j in range(len(points)) if j != i and
                       tuple(sorted((i,j))) not in edge_set) for i in range(len(points)))
        assert compose(z,z) == identity and z not in frame
        assert all(compose(z,g) == compose(g,z) for g in generators)
        extra_generators = [z]
    extra = generated_group(extra_generators, identity)
    assert len(extra) == (6 if q == 8 else 2)
    assert frame & extra == {identity}
    assert all(compose(g,h) == compose(h,g) for g in generators for h in extra_generators)
    product = {compose(g,h) for g in frame for h in extra}
    assert len(product) == (144 if q == 8 else 48)
    assert all(sorted(tuple(sorted((g[a],g[b]))) for a,b in edges) == edges for g in product)
    return dict(q=q,frame_generators=generators,extra_generators=extra_generators,
                frame_order=len(frame),extra_order=len(extra),intersection_order=1,
                product_order=len(product),composition='right-to-left')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--sage', action='store_true')
    ap.add_argument('--update-groups', action='store_true')
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

    metadata = json.loads((ROOT / 'evidence.json').read_text())['entries']['boundary']['archived_artifact']
    assert hashlib.sha256((ROOT / 'boundary.json').read_bytes()).hexdigest() == metadata['boundary_sha256']
    for q in (9, 16, 25):
        f, points, words, _, _ = model(q)
        index = {word: i for i, word in enumerate(words)}
        actions = [lambda a,b,c,d: (b,a,f.div(1,c),f.div(1,d)),
                   lambda a,b,c,d: (c,f.div(1,b),a,f.sub(1,d)),
                   lambda a,b,c,d: (f.sub(1,a),f.sub(1,b),d,c)]
        generators = [tuple(index[action(*word)] for word in words) for action in actions]
        frobenius = tuple(index[tuple(f.power(a,f.p) for a in word)] for word in words)
        assert all(tuple(g[frobenius[i]] for i in range(len(words))) ==
                   tuple(frobenius[g[i]] for i in range(len(words))) for g in generators)
        identity = tuple(range(len(words)))
        def generated(permutations):
            seen = {identity}; todo = [identity]
            while todo:
                p = todo.pop()
                for g in permutations:
                    h = tuple(g[p[i]] for i in range(len(words)))
                    if h not in seen: seen.add(h); todo.append(h)
            return seen
        assert len(generated(generators)) == 24
        assert len(generated(generators + [frobenius])) == 24*f.e
    print('PASS displayed Hamming generators and Frobenius, q=9,16,25')

    group_records = [exceptional_group_record(rec['q'],rec['exotic_representative'])
                     for rec in records if rec['q'] in (5,8)]
    for rec in group_records:
        assert rec['product_order'] == next(r['automorphism_order'] for r in records if r['q']==rec['q'])
    payload = json.dumps(dict(schema='continuation-exceptional-groups-v1',records=group_records),
                         sort_keys=True,separators=(',',':'))+'\n'
    group_path = ROOT/'exceptional-groups.json'
    if args.update_groups: group_path.write_text(payload)
    else: assert group_path.read_text() == payload, 'exceptional group certificate changed'
    print('PASS exceptional direct products S4 x C2 (q=5), S4 x S3 (q=8)')

    if args.sage:
        from sage.all import GF, PolynomialRing, SymmetricGroup
        for rec in group_records:
            n = len(rec['frame_generators'][0]); symmetric = SymmetricGroup(n)
            frame = symmetric.subgroup([symmetric([i+1 for i in g]) for g in rec['frame_generators']])
            extra = symmetric.subgroup([symmetric([i+1 for i in g]) for g in rec['extra_generators']])
            full = symmetric.subgroup(list(frame.gens())+list(extra.gens()))
            assert frame.order() == rec['frame_order'] and extra.order() == rec['extra_order']
            assert frame.intersection(extra).order() == 1 and full.order() == rec['product_order']
            assert all(g*h == h*g for g in frame.gens() for h in extra.gens())
        print('PASS independent Sage/GAP exceptional subgroup orders and intersections')
        models = [Field(q) for q in (8, 9, 16, 25)]
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
