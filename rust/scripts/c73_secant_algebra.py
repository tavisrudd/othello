#!/usr/bin/env python3
"""C73 - value-blind secant-packet: conic reconstruction + candidate-secant algebra.

Reads the exact feat dumps (notes/data/codex-feat{q}*.out). For each canonical
size-3 class it:
  * reconstructs the localizing hyperbola  (r-rho)(c-A) = B  from the (value-blind)
    conic cell set  S3 u {pos=on escapes};
  * recovers the projective 5-frame parameters  {0, oo, t1, t2, t3}  on P^1;
  * enumerates the FULL family of frame-point / on-conic-candidate secants
    (5 frame points x (q-4) on-conic candidate cells), each an explicit line;
  * records, per candidate secant, the legal escape cells it meets and their P/N
    values (values only used for the unblind step and for locating the observed
    packet -- never inside a selector formula).

Secant algebra (derived in the report):
  conic point at param t (t in F_q^*):  cell = (rho + t, A + B/t)
  param 0  = burned point (0:1:0)  ->  secant(w,0) = { r = rho + w }      (const-r line)
  param oo = burned point (1:0:0)  ->  secant(w,oo)= { c = A + B/w }      (const-c line)
  secant(u,v) both finite:  u v (c-A) + B((r-rho) - (u+v)) = 0

No new solves. Pure parse + prime-field arithmetic. q=9 (GF(9)) is skipped:
non-prime, needs GF tables; the depleted orders {11,17} and controls {13,19} are prime.
"""
import re, sys, os
from collections import defaultdict, Counter

DATA = os.path.join(os.path.dirname(__file__), '..', '..', 'notes', 'data')
PRIME_FILES = {
    5:  'codex-feat5.out',
    7:  'codex-feat7.out',
    11: 'codex-feat11-c15.out',
    13: 'codex-feat13-c15.out',
    17: 'codex-feat17.out',
    19: 'codex-feat19-c15.out',
}

def inv(x, q):
    return pow(x % q, q - 2, q)

def parse(fn):
    """Return {cls: {'S3':[(r,c)*3], 'child':[((r,c),val,pos)], 'esc':int, 'onP':int}}."""
    classes = {}
    for line in open(fn):
        m = re.match(r'CLS q=(\d+) cls=(\d+) S3=\[\(([^)]+)\), \(([^)]+)\), \(([^)]+)\)\] '
                     r'escape=(\d+) bad=(\d+) onP=(\d+) onN=(\d+) extP=(\d+) extN=(\d+) intP=(\d+) intN=(\d+)', line)
        if m:
            q = int(m.group(1)); c = int(m.group(2))
            s3 = [tuple(map(int, g.split(', '))) for g in (m.group(3), m.group(4), m.group(5))]
            D = classes.setdefault(c, dict(child=[]))
            D.update(q=q, S3=s3, esc=int(m.group(6)), bad=int(m.group(7)),
                     onP=int(m.group(8)), onN=int(m.group(9)),
                     extP=int(m.group(10)), extN=int(m.group(11)),
                     intP=int(m.group(12)), intN=int(m.group(13)))
        m = re.match(r'X q=(\d+) cls=(\d+) x=(\d+),(\d+) val=([PN]) pos=(on|ext|int)', line)
        if m:
            c = int(m.group(2))
            classes.setdefault(c, dict(child=[]))
            classes[c]['child'].append(((int(m.group(3)), int(m.group(4))), m.group(5), m.group(6)))
    return classes

def reconstruct_conic(q, S3, on_cells):
    """rho = row absent from conic cells; A = col absent; B = (r-rho)(c-A). Assert consistency."""
    conic = list(S3) + list(on_cells)
    rows = set(r for r, c in conic); cols = set(c for r, c in conic)
    miss_r = [r for r in range(q) if r not in rows]
    miss_c = [c for c in range(q) if c not in cols]
    assert len(miss_r) == 1 and len(miss_c) == 1, (q, miss_r, miss_c, len(conic))
    rho, A = miss_r[0], miss_c[0]
    Bs = set(((r - rho) * (c - A)) % q for r, c in conic)
    assert len(Bs) == 1, (q, Bs)
    B = Bs.pop()
    # value-blind cross checks
    assert len(conic) == q - 1
    assert all((r - rho) % q != 0 and (c - A) % q != 0 for r, c in conic)
    return rho, A, B

def param(q, rho, cell):
    return (cell[0] - rho) % q  # t = r - rho

def secant_line_pred(q, rho, A, B, w, F):
    """Return predicate cell->bool for the secant through on-conic param w and frame point F.
    F in {'0','oo'} or an integer finite param."""
    if F == '0':                      # { r = rho + w }
        rr = (rho + w) % q
        return lambda cell: cell[0] % q == rr
    if F == 'oo':                     # { c = A + B/w }
        cc = (A + B * inv(w, q)) % q
        return lambda cell: cell[1] % q == cc
    t = F % q                         # secant(w,t): t*w*(c-A) + B*((r-rho)-(w+t)) = 0
    coefC = (t * w) % q
    def pred(cell):
        r, c = cell
        return (coefC * ((c - A) % q) + B * (((r - rho) - (w + t)) % q)) % q == 0
    return pred

def analyze(q, classes):
    out = {}
    for c in sorted(classes):
        D = classes[c]
        if 'S3' not in D:
            continue
        S3 = D['S3']
        on_cells = [cell for cell, v, p in D['child'] if p == 'on']
        rho, A, B = reconstruct_conic(q, S3, on_cells)
        tframe = sorted(param(q, rho, p) for p in S3)      # {t1,t2,t3}
        frame_pts = ['0', 'oo'] + tframe
        # on-conic candidate params (value-blind = F_q^* minus tframe)
        cand_w = [param(q, rho, cell) for cell in on_cells]
        assert sorted(cand_w) == sorted(set(range(1, q)) - set(tframe)), (q, c)
        children = D['child']
        # observed packet: is there a line through all P children?
        Ps = [cell for cell, v, p in children if v == 'P']
        # candidate secants incidence table
        cand = {}   # (F, w) -> dict(oncell, legal[list of (cell,val,pos)], nP, nlegal)
        for w in cand_w:
            oncell = ((rho + w) % q, (A + B * inv(w, q)) % q)
            for F in frame_pts:
                pred = secant_line_pred(q, rho, A, B, w, F)
                hit = [(cell, v, p) for cell, v, p in children if pred(cell)]
                cand[(F, w)] = dict(oncell=oncell, hit=hit,
                                    nlegal=len(hit),
                                    nP=sum(1 for _, v, _ in hit if v == 'P'),
                                    noff=sum(1 for _, v, p in hit if p != 'on'),
                                    noffP=sum(1 for _, v, p in hit if p != 'on' and v == 'P'))
        out[c] = dict(q=q, cls=c, S3=S3, rho=rho, A=A, B=B, tframe=tframe,
                      cand_w=cand_w, esc=D['esc'], onP=D['onP'], Ps=Ps, cand=cand,
                      children=children)
    return out

def observed_packet(rec, q):
    """Find the line (if any) containing ALL P children of this class.
    Returns (found, line_repr, list_of_P_cells) — value-based, used only to locate ground truth."""
    Ps = rec['Ps']
    if len(Ps) < 3:
        # <3 points are trivially collinear; report but flag
        return (len(Ps) <= 2, 'trivial(<=2 P)', Ps)
    (x1, y1), (x2, y2) = Ps[0], Ps[1]
    col = all(((x2 - x1) * (y - y1) - (y2 - y1) * (x - x1)) % q == 0 for x, y in Ps)
    return (col, f'through {Ps[0]},{Ps[1]}', Ps)

if __name__ == '__main__':
    qs = [int(a) for a in sys.argv[1:]] or [11, 17, 13, 19, 5, 7]
    for q in qs:
        fn = os.path.join(DATA, PRIME_FILES[q])
        classes = parse(fn)
        recs = analyze(q, classes)
        print(f'==== q={q}  classes={len(recs)} ====')
        for c, rec in recs.items():
            found, rep, Ps = observed_packet(rec, q)
            flag = 'ALL-P-COLLINEAR' if (found and len(Ps) >= 3) else ''
            print(f'  cls={c:2d} S3={rec["S3"]} rho={rec["rho"]} A={rec["A"]} B={rec["B"]} '
                  f'tframe={rec["tframe"]} esc={rec["esc"]} onP={rec["onP"]} '
                  f'#P={len(Ps)} {flag}')
