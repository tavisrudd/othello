#!/usr/bin/env python3
"""C73: full candidate-secant incidence dump for chosen classes.
For each on-conic candidate w and each frame point F, print legal/P/offP counts."""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from c73_secant_algebra import parse, analyze, PRIME_FILES, DATA, inv
from c73_explore import product_points

def dump(q, only=None):
    classes = parse(os.path.join(DATA, PRIME_FILES[q]))
    recs = analyze(q, classes)
    for c, rec in recs.items():
        if only is not None and c not in only:
            continue
        pp = product_points(q, rec['tframe'])
        Ps = set(rec['Ps'])
        onP_w = set((cell[0]-rec['rho']) % q for cell, v, p in rec['children'] if p == 'on' and v == 'P')
        print(f'\n=== q={q} cls={c} tframe={rec["tframe"]} esc={rec["esc"]} '
              f'product_pts={sorted(pp)} onP_params={sorted(onP_w)} ===')
        print(f'  {"F":>4} {"w":>3} {"isPP":>4} {"onV":>3} {"nleg":>4} {"nP":>3} {"noff":>4} {"noffP":>5}')
        # sort: product-point candidates first
        rows = []
        for (F, w), d in rec['cand'].items():
            onv = 'P' if w in onP_w else 'N'
            rows.append((0 if w in pp else 1, w, str(F), F, w, w in pp, onv, d['nlegal'], d['nP'], d['noff'], d['noffP']))
        for _, _, _, F, w, isPP, onv, nl, nP, noff, noffP in sorted(rows):
            mark = ' <<PACKET' if set(cell for cell,v,p in rec['cand'][(F,w)]['hit']) >= Ps and Ps else ''
            star = '*' if isPP else ' '
            print(f'  {str(F):>4} {w:>3} {star:>4} {onv:>3} {nl:>4} {nP:>3} {noff:>4} {noffP:>5}{mark}')

if __name__ == '__main__':
    q = int(sys.argv[1]); only = [int(x) for x in sys.argv[2:]] or None
    dump(q, only)
