#!/usr/bin/env python3
"""C73 exploration: characterize the observed packet inside the candidate-secant family."""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from c73_secant_algebra import parse, analyze, PRIME_FILES, DATA, inv, observed_packet

def product_points(q, tframe):
    t1, t2, t3 = tframe
    return {
        (t2 * t3 % q) * inv(t1, q) % q: ('t2t3/t1', (t2, t3, t1)),
        (t1 * t3 % q) * inv(t2, q) % q: ('t1t3/t2', (t1, t3, t2)),
        (t1 * t2 % q) * inv(t3, q) % q: ('t1t2/t3', (t1, t2, t3)),
    }

def packet_candidates(rec):
    """Return list of (F,w) candidate secants whose hit-set == the full observed P set."""
    q = rec['q']; Pset = set(rec['Ps'])
    res = []
    for (F, w), d in rec['cand'].items():
        cells = set(cell for cell, v, p in d['hit'])
        # candidate secant "is the packet" if every P child lies on it AND it carries no extra escape
        if Pset and Pset <= cells:
            res.append((F, w, d, cells == Pset))
    return res

def main():
    q = int(sys.argv[1]) if len(sys.argv) > 1 else 17
    classes = parse(os.path.join(DATA, PRIME_FILES[q]))
    recs = analyze(q, classes)
    for c, rec in recs.items():
        found, rep, Ps = observed_packet(rec, q)
        if not (found and len(Ps) >= 3):
            continue
        pp = product_points(q, rec['tframe'])
        print(f'\n=== q={q} cls={c} S3={rec["S3"]} rho={rec["rho"]} A={rec["A"]} B={rec["B"]} '
              f'tframe={rec["tframe"]} esc={rec["esc"]} onP={rec["onP"]} ===')
        print(f'  product points (value-blind): {pp}')
        oncells = {((rec["rho"]+w)%q, (rec["A"]+rec["B"]*inv(w,q))%q): w for w in rec['cand_w']}
        onP_cells = [(cell, w) for cell, w in oncells.items() if (cell, 'P', 'on') in
                     [(c2, v, p) for c2, v, p in rec['children']]]
        # locate the on-conic P child
        onP_children = [(cell, w) for cell, v, p in rec['children'] if p == 'on' and v == 'P'
                        for w in [ (cell[0]-rec["rho"])%q ]]
        print(f'  on-conic P child(ren): {onP_children}   is product-point? '
              f'{[(cell, w, w in pp, pp.get(w)) for cell,w in onP_children]}')
        print(f'  all P children: {Ps}')
        pk = packet_candidates(rec)
        for F, w, d, exact in pk:
            print(f'  PACKET secant: F={F} w={w} (w product? {w in pp}: {pp.get(w)}) '
                  f'nlegal={d["nlegal"]} nP={d["nP"]} exact={exact} hits={[(cell,v,p) for cell,v,p in d["hit"]]}')

if __name__ == '__main__':
    main()
