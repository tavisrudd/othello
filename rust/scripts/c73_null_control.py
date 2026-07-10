#!/usr/bin/env python3
"""C73 null-model control + cls-2 mechanism dissection.

Null model: over ALL frame-point/on-conic candidate secants, the base rate at which a
secant carries a P escape / has its on-conic point P, vs the L1 (max-incidence) selector.
This calibrates whether L1's hit rate is meaningful (q=17: many N children) or a base-rate
artifact (q=13,19: bad~0, every escape P)."""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from c73_secant_algebra import parse, analyze, PRIME_FILES, DATA, inv

def null_model(qs):
    print('Null model: fraction of ALL candidate secants carrying >=1 P escape and with on-conic P,')
    print('vs the L1 max-incidence secant.')
    print(f'{"q":>3} {"#cand/cls":>9} {"anyP-rate":>10} {"onP-rate":>9} | {"L1 anyP":>9} {"L1 onP":>8}')
    for q in qs:
        recs = analyze(q, parse(os.path.join(DATA, PRIME_FILES[q])))
        tot=anyP=onP=l1any=l1on=ncls=ncand=0
        for c, rec in recs.items():
            ncls += 1; cand = rec['cand']; ncand = len(cand)
            mx = max(d['nlegal'] for d in cand.values())
            for k, d in cand.items():
                tot += 1
                anyP += any(v == 'P' for _, v, _ in d['hit'])
                onP += any(p == 'on' and v == 'P' for _, v, p in d['hit'])
            sel = [k for k, d in cand.items() if d['nlegal'] == mx]
            l1any += all(any(v == 'P' for _, v, _ in cand[k]['hit']) for k in sel)
            l1on += all(any(p == 'on' and v == 'P' for _, v, p in cand[k]['hit']) for k in sel)
        print(f'{q:>3} {ncand:>9} {anyP/tot:>10.3f} {onP/tot:>9.3f} | {str(l1any)+"/"+str(ncls):>9} '
              f'{str(l1on)+"/"+str(ncls):>8}')

def dissect(q, c):
    """Point-by-point classification of L1's selected line for one class."""
    rec = analyze(q, parse(os.path.join(DATA, PRIME_FILES[q])))[c]
    cand = rec['cand']; rho, A, B = rec['rho'], rec['A'], rec['B']
    mx = max(d['nlegal'] for d in cand.values())
    F, w = sorted([k for k, d in cand.items() if d['nlegal'] == mx], key=lambda k: (str(k[0]), k[1]))[0]
    S3 = rec['S3']
    used_rows = {r for r, _ in S3}; used_cols = {cc for _, cc in S3}
    print(f'q={q} cls={c} S3={S3} conic(rho={rho},A={A},B={B}) L1 secant (F={F}, w={w}), nlegal={mx}')
    if F == '0':
        line = [((rho + w) % q, cc) for cc in range(q)]
        print(f'  line: r = rho+w = {(rho+w)%q}  (secant through burned point 0 = row-parallel)')
    elif F == 'oo':
        cc0 = (A + B * inv(w, q)) % q
        line = [(r, cc0) for r in range(q)]
        print(f'  line: c = A+B/w = {cc0}  (secant through burned point oo = col-parallel)')
    else:
        line = []
        for r in range(q):
            for cval in range(q):
                if (F * w % q) * ((cval - A) % q) % q == (B * ((F + w) - (r - rho))) % q % q:
                    line.append((r, cval))
    childmap = {cell: (v, p) for cell, v, p in rec['children']}
    onset = {cell for cell, v, p in rec['children'] if p == 'on'}
    forb = []
    for cell in line:
        r, cc = cell
        tags = []
        if r in used_rows: tags.append('usedRow')
        if cc in used_cols: tags.append('usedCol')
        if cell in childmap: tags.append('LEGAL-' + childmap[cell][1] + '-' + childmap[cell][0])
        if cell in S3: tags.append('S3')
        if not tags: tags.append('illegal(S3-secant)')
        forb.append((cell, ' '.join(tags)))
    nlegal = sum(1 for _, t in forb if 'LEGAL' in t)
    nP = sum(1 for _, t in forb if 'LEGAL' in t and t.endswith('-P'))
    print(f'  points on line ({len(line)}): {nlegal} legal, {nP} P')
    for cell, t in forb:
        print(f'    {cell}: {t}')

if __name__ == '__main__':
    null_model([11, 13, 17, 19])
    print('\n--- mechanism dissection: q=17 extremal cls=2 (packet = row r=5) ---')
    dissect(17, 2)
