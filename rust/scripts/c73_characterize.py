#!/usr/bin/env python3
"""C73: characterize what L1 (max-incidence secant) actually selects, value-blind.
Is the selected on-conic point a product point? What frame-point type? On/off-conic P?"""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from c73_secant_algebra import parse, analyze, PRIME_FILES, DATA, inv, observed_packet
from c73_explore import product_points

def frame_type(F, tframe):
    if F in ('0', 'oo'):
        return 'burned'
    return 'played'

def run(q):
    classes = parse(os.path.join(DATA, PRIME_FILES[q]))
    recs = analyze(q, classes)
    print(f'==== q={q} : L1 selection characterization ====')
    print(f'  {"cls":>3} {"ext":>3} {"onP":>3} {"nleg":>4} {"tie":>3} '
          f'{"selF":>5} {"selw":>4} {"wPP?":>4} {"onV":>3} {"Pon":>3} {"Poff":>4} {"conic2ndPP":>10}')
    n_wpp = 0; n_total = 0; n_onP_is_selw = 0
    for c, rec in sorted(recs.items()):
        cand = rec['cand']; q_ = rec['q']
        pp = product_points(q_, rec['tframe'])
        mx = max(d['nlegal'] for d in cand.values())
        sel = sorted([k for k, d in cand.items() if d['nlegal'] == mx],
                     key=lambda k: (str(k[0]), k[1]))
        tie = len(sel)
        ext = observed_packet(rec, q)[0] and len(rec['Ps']) >= 3 and rec['onP'] == 1
        # report the first selected secant (they should be geometrically similar)
        F, w = sel[0]
        d = cand[(F, w)]
        onV = next((v for cell, v, p in d['hit'] if p == 'on'), '?')
        Pon = sum(1 for cell, v, p in d['hit'] if p == 'on' and v == 'P')
        Poff = sum(1 for cell, v, p in d['hit'] if p != 'on' and v == 'P')
        # is EVERY tied selection's on-conic point a product point?
        all_wpp = all(k[1] in pp for k in sel)
        # does EVERY tied selection's on-conic intersection point land on a P child?
        def on_is_P(key):
            return any(p == 'on' and v == 'P' for cell, v, p in cand[key]['hit'])
        all_onP = all(on_is_P(k) for k in sel)
        n_total += 1
        if all_wpp:
            n_wpp += 1
        if all_onP:
            n_onP_is_selw += 1
        print(f'  {c:>3} {"Y" if ext else " ":>3} {rec["onP"]:>3} {mx:>4} {tie:>3} '
              f'{str(F):>5} {w:>4} {"Y" if w in pp else "N":>4} {onV:>3} {Pon:>3} {Poff:>4} '
              f'{"allPP" if all_wpp else "mixed":>10}')
    print(f'  SUMMARY q={q}: ALL-L1-selected-on-conic-are-product-points: {n_wpp}/{n_total};  '
          f'EVERY-L1-selected-secant-has-its-on-conic-point-P: {n_onP_is_selw}/{n_total}')

if __name__ == '__main__':
    for q in ([int(a) for a in sys.argv[1:]] or [17, 11, 13, 19]):
        run(q)
