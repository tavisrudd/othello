#!/usr/bin/env python3
"""A5 (a'): structure of the P-certificate reply book for the smallest-orbit / knife-edge child.

The smallest-orbit anchor picks WHICH on-conic child to certify P; the mechanism refutation
(a5_exception_orbits.py) shows P-ness is not a point-stabilizer mirror. This probes the actual
committed reply-book certs (notes/certs/gridcap-q{q}.cert, C12) to ask: is the winning strategy a
fixed pairing (an involution on live cells) after all, or is it irreducibly adaptive?

Per class it tests, over ALL book nodes:
  (P1) pure-pairing: reply is a function of the move alone (node-independent)?
  (P2) that move->reply function is a fixed-point-free involution (sigma(sigma(x))=x, no fixed cell)?
  (P3) node-0 (move,reply) pairs form a matching (each cell in <=1 pair)?
  fan-in: how concentrated replies are (max #moves sharing one reply cell), book depth, size.
"""
import sys, os
from collections import defaultdict, Counter

CERTS = os.path.join(os.path.dirname(__file__), '..', '..', 'notes', 'certs')

def parse_cert(q):
    classes = {}
    cur = None
    for line in open(os.path.join(CERTS, f'gridcap-q{q}.cert')):
        t = line.split()
        if not t or t[0].startswith('#'):
            continue
        if t[0] == 'CLASS':
            ci = int(t[1])
            # CLASS ci s3 r,c r,c r,c escape e witness r,c onconic b book .. nodes N rows R terms T
            d = dict(ci=ci, rows=[], node0size=None)
            kv = {}
            i = 2
            while i < len(t):
                if t[i] == 's3':
                    kv['s3'] = t[i+1:i+4]; i += 4
                else:
                    kv[t[i]] = t[i+1]; i += 2
            d.update(escape=int(kv['escape']), witness=kv['witness'], onconic=kv['onconic'],
                     nodes=int(kv['nodes']), nrows=int(kv['rows']), terms=int(kv['terms']))
            classes[ci] = d; cur = d
        elif t[0] == 'R':
            ci, nid = int(t[1]), int(t[2])
            move, reply, cid = t[3], t[4], int(t[5])
            classes[ci]['rows'].append((nid, move, reply, cid))
        elif t[0] == 'N':
            ci, nid = int(t[1]), int(t[2])
            if nid == 0:
                classes[ci]['node0size'] = len(t) - 3
    return classes

def analyze_class(d):
    rows = d['rows']
    # (P1) reply a function of move alone across all nodes?
    move_to_replies = defaultdict(set)
    for nid, mv, rp, cid in rows:
        move_to_replies[mv].add(rp)
    pure_fn = all(len(v) == 1 for v in move_to_replies.values())
    # (P2) if pure, is it an fpf involution?
    fpf_invol = False
    if pure_fn:
        sigma = {mv: next(iter(v)) for mv, v in move_to_replies.items()}
        fpf_invol = (all(sigma.get(rp) == mv for mv, rp in sigma.items())
                     and all(mv != rp for mv, rp in sigma.items()))
    # (P3) node-0 pairs form a matching?
    n0 = [(mv, rp) for nid, mv, rp, cid in rows if nid == 0]
    seen = Counter()
    for mv, rp in n0:
        seen[mv] += 1; seen[rp] += 1
    n0_matching = all(v <= 1 for v in seen.values())
    # fan-in: replies used at node 0
    reply_fanin = Counter(rp for mv, rp in n0)
    max_fanin = max(reply_fanin.values()) if reply_fanin else 0
    n0_moves = len(n0)
    return dict(pure_fn=pure_fn, fpf_invol=fpf_invol, n0_matching=n0_matching,
                n0_moves=n0_moves, max_fanin=max_fanin,
                n0_distinct_replies=len(reply_fanin))

KNIFE = {11: (4, 7), 17: (2, 17, 19)}

def run(q):
    classes = parse_cert(q)
    ke = set(KNIFE.get(q, ()))
    print(f'==== q={q} cert reply-book structure ====')
    print(f'  {"cls":>3} {"KE":>2} {"esc":>3} {"onc":>3} {"nodes":>6} {"rows":>6} '
          f'{"pureFn":>6} {"fpfInv":>6} {"n0match":>7} {"n0mv":>5} {"maxFanIn":>8} {"n0repl":>6}')
    for ci in sorted(classes):
        d = classes[ci]; a = analyze_class(d)
        print(f'  {ci:>3} {"KE" if ci in ke else "":>2} {d["escape"]:>3} {d["onconic"]:>3} '
              f'{d["nodes"]:>6} {d["nrows"]:>6} {str(a["pure_fn"]):>6} {str(a["fpf_invol"]):>6} '
              f'{str(a["n0_matching"]):>7} {a["n0_moves"]:>5} {a["max_fanin"]:>8} '
              f'{a["n0_distinct_replies"]:>6}')

if __name__ == '__main__':
    for q in ([int(a) for a in sys.argv[1:]] or [11, 17]):
        run(q)
