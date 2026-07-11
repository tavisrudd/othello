#!/usr/bin/env python3
"""A5 anchor / exception characterization.

The A5 (ON) target is min-witness >= 1: every size-3 class has >= 1 on-conic P child.
C73's L1 (max-incidence secant) on-conic point is P at every tested class EXCEPT the
q=11 D10-tie knife-edge classes (cls 4,7), so A5 = generic L-discharge + a q=11 exception.

On-conic child values are Stab(frame)-invariant (a frame-stabilizing projectivity transports
the whole follower game, Lemma I). So P children come in whole Stab-orbits. This script computes,
per class: the frame {0,oo,t1,t2,t3} stabilizer inside PGL(2,q), its orbits on the on-conic child
params w, and each orbit's value + size, to characterize the P children at the exception classes.
"""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from c73_secant_algebra import parse, analyze, PRIME_FILES, DATA, inv

def mobius_all(q):
    """All PGL(2,q) as (a,b,c,d) normalized; act on P^1 = {0..q-1, 'oo'}."""
    out = []
    for a in range(q):
        for b in range(q):
            for c in range(q):
                for d in range(q):
                    if (a * d - b * c) % q == 0:
                        continue
                    z = next(x for x in (a, b, c, d) if x)
                    if z != 1:
                        continue  # normalize leading nonzero to 1
                    out.append((a, b, c, d))
    return out

def act(m, x, q):
    a, b, c, d = m
    if x == 'oo':
        return 'oo' if c % q == 0 else (a * inv(c, q)) % q
    den = (c * x + d) % q
    return 'oo' if den == 0 else ((a * x + b) % q) * inv(den, q) % q

def frame_params(rec):
    """The 5-frame on P^1: {'oo', 0, t1, t2, t3} in this script's param convention."""
    return ['oo', 0] + list(rec['tframe'])

def value_of_w(rec, w):
    """P/N of the on-conic child at param w (via its cell)."""
    rho, A, B, q = rec['rho'], rec['A'], rec['B'], rec['q']
    cell = ((rho + w) % q, (A + B * inv(w, q)) % q)
    for c, v, p in rec['children']:
        if p == 'on' and tuple(c) == cell:
            return v
    return '?'

def run(q):
    recs = analyze(q, parse(os.path.join(DATA, PRIME_FILES[q])))
    G = mobius_all(q)
    assert len(G) == q * (q * q - 1)
    print(f'==== q={q}  (|PGL|={len(G)}) ====')
    anchors = []
    for c in sorted(recs):
        rec = recs[c]
        frame = frame_params(rec)
        fset = set(frame)
        stab = [m for m in G if {act(m, x, q) for x in frame} == fset]
        cand_w = list(rec['cand_w'])
        # orbits of stab on cand_w
        remaining = set(cand_w)
        orbits = []
        while remaining:
            w0 = min(remaining, key=str)
            orb = set()
            frontier = [w0]
            while frontier:
                x = frontier.pop()
                if x in orb:
                    continue
                orb.add(x)
                for m in stab:
                    y = act(m, x, q)
                    if y in remaining and y not in orb:
                        frontier.append(y)
            orbits.append(sorted(orb))
            remaining -= orb
        orb_desc = []
        for orb in orbits:
            vals = {value_of_w(rec, w) for w in orb}
            v = vals.pop() if len(vals) == 1 else '/'.join(sorted(vals))
            orb_desc.append(f'{v}x{len(orb)}')
        onP = rec['onP']
        # verdict tests for the A5 anchor "smallest Stab-orbit is P"
        sized = sorted(((len(orb), {value_of_w(rec, w) for w in orb}) for orb in orbits))
        min_sz = sized[0][0]
        min_orbs = [vals for sz, vals in sized if sz == min_sz]
        smallest_all_P = all(vals == {'P'} for vals in min_orbs)
        smallest_uniq = len([1 for sz, _ in sized if sz == min_sz]) == 1
        # any singleton (frame-fixed on-conic point) that is N?
        n_singleton = any(sz == 1 and 'N' in vals for sz, vals in sized)
        anchors.append((c, smallest_all_P, smallest_uniq, n_singleton))
        flag = '  <== q=11 knife-edge (L1 exception)' if (q == 11 and c in (4, 7)) else ''
        print(f'  cls {c:>2}: |Stab|={len(stab):>3}  onP={onP:>2}  min-orbit={min_sz}'
              f'{"(uniq)" if smallest_uniq else "(tie)"}  orbits[val x size]={orb_desc}{flag}')
    nclass = len(anchors)
    sp = sum(1 for _, s, _, _ in anchors if s)
    su = sum(1 for _, _, u, _ in anchors if u)
    nsing = sum(1 for _, _, _, n in anchors if n)
    print(f'  VERDICT q={q}: smallest-orbit-all-P {sp}/{nclass};  '
          f'smallest-orbit-unique {su}/{nclass};  N-singleton(frame-fixed-N) classes {nsing}')

if __name__ == '__main__':
    for q in ([int(a) for a in sys.argv[1:]] or [11, 13, 17, 19]):
        run(q)
