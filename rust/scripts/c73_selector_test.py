#!/usr/bin/env python3
"""C73 predeclare-then-unblind selector test.

PREDECLARED value-blind selectors (each maps frame A -> a set of candidate-secant lines,
using ONLY: S3, the reconstructed conic, the legal-escape cell set; never P/N values):

  L1  max-incidence      : candidate secant(s) with the most legal escape cells on the line.
  L2  pp-pencil          : ALL candidate secants through a product point ti*tj/tk.
  L3  pp-max-incidence   : among secants through product points, the max-legal-incidence one(s).
  L4  pp-to-burned       : secant(w_pp, 0) and secant(w_pp, oo) for each product point.
  L5  max-incidence-uniq : L1 restricted to the case where the argmax is unique.

Unblind metrics per selector, per class (values used ONLY here, for scoring):
  sel_is_packet : at the 3 q=17 extremal classes, does the selected set contain the packet line?
  hasP_any      : does SOME selected line carry a P escape? (recursion-lemma existence)
  hasP_all      : do ALL selected lines carry a P escape?
  onP_pp        : is the selected line's on-conic point a product point that is P?
"""
import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from c73_secant_algebra import parse, analyze, PRIME_FILES, DATA, inv, observed_packet
from c73_explore import product_points

def selectors(rec):
    q = rec['q']; cand = rec['cand']
    pp = set(product_points(q, rec['tframe']))
    # L1
    mx = max(d['nlegal'] for d in cand.values())
    L1 = {k for k, d in cand.items() if d['nlegal'] == mx}
    # L2
    L2 = {k for k in cand if k[1] in pp}
    # L3
    if L2:
        mx3 = max(cand[k]['nlegal'] for k in L2)
        L3 = {k for k in L2 if cand[k]['nlegal'] == mx3}
    else:
        L3 = set()
    # L4
    L4 = {k for k in cand if k[1] in pp and k[0] in ('0', 'oo')}
    # L5
    L5 = L1 if len(L1) == 1 else set()
    return dict(L1=L1, L2=L2, L3=L3, L4=L4, L5=L5), mx

def line_hasP(rec, key):
    return any(v == 'P' for _, v, _ in rec['cand'][key]['hit'])

def packet_keys(rec):
    """candidate secants whose hit-set contains all P children (the observed packet lines)."""
    Ps = set(rec['Ps'])
    if not Ps:
        return set()
    return {k for k, d in rec['cand'].items()
            if Ps <= set(cell for cell, v, p in d['hit'])}

def run(qs):
    summary = {}
    for q in qs:
        classes = parse(os.path.join(DATA, PRIME_FILES[q]))
        recs = analyze(q, classes)
        extremal = {c for c, r in recs.items()
                    if observed_packet(r, q)[0] and len(r['Ps']) >= 3 and r['onP'] == 1}
        per = {}
        for c, rec in recs.items():
            sels, mx = selectors(rec)
            pk = packet_keys(rec)
            row = {}
            for name, S in sels.items():
                if not S:
                    row[name] = dict(n=0, hasP_any=None, hasP_all=None, is_packet=None)
                    continue
                hasP = [line_hasP(rec, k) for k in S]
                row[name] = dict(
                    n=len(S),
                    hasP_any=any(hasP),
                    hasP_all=all(hasP),
                    is_packet=bool(S & pk) if pk else None,
                )
            per[c] = dict(row=row, extremal=(c in extremal), onP=rec['onP'],
                          esc=rec['esc'], mx=mx, npk=len(pk))
        summary[q] = per
    return summary

def report(summary):
    for q, per in summary.items():
        print(f'\n########## q={q} ##########')
        # per-class table
        hdr = f'  {"cls":>3} {"ext":>3} {"onP":>3} {"esc":>3} {"L1n":>3} {"L1P?":>4} {"L1pk":>4} ' \
              f'{"L3n":>3} {"L3P?":>4} {"L4n":>3} {"L4P?":>4}'
        print(hdr)
        for c in sorted(per):
            r = per[c]; row = r['row']
            def cell(name):
                d = row[name]
                if d['n'] == 0:
                    return ('  -', '  -', '  -')
                return (f'{d["n"]:>3}',
                        ('  Y' if d['hasP_any'] else '  N'),
                        ('  Y' if d['is_packet'] else ('  -' if d['is_packet'] is None else '  N')))
            l1 = cell('L1'); l3 = cell('L3'); l4 = cell('L4')
            print(f'  {c:>3} {"Y" if r["extremal"] else " ":>3} {r["onP"]:>3} {r["esc"]:>3} '
                  f'{l1[0]} {l1[1]:>4} {l1[2]:>4} {l3[0]} {l3[1]:>4} {l4[0]} {l4[1]:>4}')
        # aggregates
        for name in ('L1', 'L2', 'L3', 'L4', 'L5'):
            defined = [c for c in per if per[c]['row'][name]['n'] > 0]
            hasP_any = [c for c in defined if per[c]['row'][name]['hasP_any']]
            hasP_all = [c for c in defined if per[c]['row'][name]['hasP_all']]
            uniq = [c for c in defined if per[c]['row'][name]['n'] == 1]
            fails = [c for c in defined if not per[c]['row'][name]['hasP_any']]
            ext = [c for c in per if per[c]['extremal']]
            ext_pk = [c for c in ext if per[c]['row'][name]['is_packet']]
            print(f'  [{name}] defined={len(defined)}/{len(per)} '
                  f'hasP_any={len(hasP_any)} hasP_all={len(hasP_all)} unique={len(uniq)} '
                  f'FAIL(no P)={fails} extremal_pk={len(ext_pk)}/{len(ext)}')

if __name__ == '__main__':
    qs = [int(a) for a in sys.argv[1:]] or [11, 17, 13, 19, 5, 7]
    report(run(qs))
