#!/usr/bin/env python3
"""Conjecture D1 — exhaustive verification + strike/repair anatomy.

D1: a rho-symmetric even-board position with exactly one live long-diagonal
pair has G <= 1.

n = 6, 8, 10: full game DAG (every reachable position), filter rho-symmetric,
bucket by d = number of live diagonal rho-pairs, record max G per bucket.
Also enumerates the symmetric-play class (placed set rho-invariant) and
compares it against the DAG-filtered symmetric class.

For every d=1 position A with live pair {e, re = rho(e)}:
  gA    = G(A)
  Ae    = A \\ N[e]  (strike child; G(Ae) = G(A \\ N[re]) by symmetry)
  Delta = Ae & N[re] (the scar: squares live after the strike whose
                      rho-partner died with the strike)
  C     = Ae \\ N[re] (the symmetric diagonal-free core)
Hypotheses tested per position:
  H1 (value formula): G(A) = 1  <=>  G(Ae) = 0
  H2 (non-diag children are N): every non-diagonal child A_s has G >= 1
  H3 (D1-critical): if G(Ae) = 0 then no child of A has value 1
  Lemma C (proven, code check): Delta empty ==> G(Ae) = 0
  Converse probe: Delta nonempty ==> G(Ae) >= 1 ?
Repair anatomy for G(Ae) >= 1 (defender can answer the strike):
  winning replies t in Ae, classified: t in Delta? kills whole scar?
  residual rho-symmetric ("perfect repair")? residual admits a closed
  pairing (static S1 witness)? or neither ("deep repair" only).
Mirror-failure anatomy for non-diagonal children (the H2 proof landscape):
  for each non-diag s: does rho(s) win from A_s? else does a strike win?
  else what class of move wins?
"""
import sys, os, time
from collections import Counter, defaultdict

sys.setrecursionlimit(1000000)
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', '2026-07-03-geometry'))
from small_boards import build          # noqa: E402
from cgtlib import closed_pairing       # noqa: E402


def rho_sq(n, s):
    r, c = divmod(s, n)
    return (n - 1 - r) * n + (n - 1 - c)


def diag_mask(n):
    m = 0
    for i in range(n):
        m |= 1 << (i * n + i)
        m |= 1 << (i * n + (n - 1 - i))
    return m


def bits(m):
    while m:
        b = m & -m
        yield b.bit_length() - 1
        m ^= b


class Board:
    def __init__(self, n):
        self.n = n
        self.att = build(n)
        self.N = n * n
        self.full = (1 << self.N) - 1
        self.diagm = diag_mask(n)
        self.rho = [rho_sq(n, s) for s in range(self.N)]
        self.memo = {}

    def mask_rho(self, mask):
        out = 0
        rho = self.rho
        m = mask
        while m:
            b = m & -m
            out |= 1 << rho[b.bit_length() - 1]
            m ^= b
        return out

    def grundy(self, avail):
        memo = self.memo
        att = self.att

        def g(a):
            if a == 0:
                return 0
            v = memo.get(a)
            if v is not None:
                return v
            vals = set()
            x = a
            while x:
                b = x & -x
                vals.add(g(a & ~att[b.bit_length() - 1]))
                x ^= b
            r = 0
            while r in vals:
                r += 1
            memo[a] = r
            return r
        return g(avail)

    def sq_name(self, s):
        r, c = divmod(s, self.n)
        return f"({r},{c})"


def sym_play_positions(bd):
    """All avail masks reachable by placing rho-invariant independent sets
    (unions of non-diagonal rho-pairs)."""
    n = bd.n
    pairs = []
    for q in range(bd.N):
        if (bd.diagm >> q) & 1:
            continue
        rq = bd.rho[q]
        if q < rq:
            pairs.append((1 << q | 1 << rq, bd.att[q] | bd.att[rq]))
    res = set()

    def dfs(i, placed_att):
        res.add(bd.full & ~placed_att)
        for j in range(i, len(pairs)):
            pm, pa = pairs[j]
            if placed_att & pm:
                continue
            dfs(j + 1, placed_att | pa)
    dfs(0, 0)
    return res


def d_of(bd, A):
    return (A & bd.diagm).bit_count() // 2


def anatomy_d1(bd, A, do_pairing=True, pairing_cap=30):
    """Full analysis of one symmetric d=1 position. Returns record dict."""
    att = bd.att
    livediag = A & bd.diagm
    assert livediag.bit_count() == 2
    e = (livediag & -livediag).bit_length() - 1
    re = bd.rho[e]
    assert (livediag >> re) & 1 and re != e
    Ae = A & ~att[e]
    Delta = Ae & att[re]
    C = Ae & ~att[re]
    gA = bd.grundy(A)
    gstar = bd.grundy(Ae)
    rec = dict(A=A, e=e, gA=gA, gstar=gstar, nlive=A.bit_count(),
               Delta=Delta, nDelta=Delta.bit_count(), nC=C.bit_count())

    # Lemma C (proven) code check + converse probe
    rec['lemC_ok'] = (Delta != 0) or (gstar == 0)
    rec['conv_hit'] = (Delta != 0) and (gstar == 0)  # scar exists, strike still safe

    # children scan
    child_vals = {gstar}
    nd = []  # (s, gAs, dApair, gAp, e_live, re_live)
    fine = Counter()  # (gstar==0, pair_killed_by_exchange, G(A'), G(A_s))
    for s in bits(A & ~bd.diagm):
        As = A & ~att[s]
        gAs = bd.grundy(As)
        rs = bd.rho[s]
        Ap = As & ~att[rs]
        gAp = bd.grundy(Ap)
        dAp = d_of(bd, Ap)
        nd.append((s, gAs, dAp, gAp,
                   bool((As >> e) & 1), bool((As >> re) & 1)))
        child_vals.add(gAs)
        fine[(gstar == 0, dAp == 0, gAp, gAs)] += 1
    rec['fine'] = fine

    # 1-child anatomy for the N-side gap: gstar=0, pair-killing exchange
    # (G(A_s) must be >= 2; where does its 1-child live?)
    one_children = []
    if gstar == 0:
        for (s, gAs, dAp, gAp, e_live, re_live) in nd:
            if dAp != 0:
                continue
            As = A & ~att[s]
            Ds = As & att[bd.rho[s]]  # the s-scar inside A_s
            ones = []
            for m in bits(As):
                if bd.grundy(As & ~att[m]) == 1:
                    if m in (e, re):
                        cl = 'strike'
                    elif (Ds >> m) & 1:
                        cl = 'scar_s'
                    else:
                        cl = 'other'
                    ones.append((m, cl))
            one_children.append((s, gAs, e_live, re_live,
                                 Counter(c for _, c in ones), len(ones)))
    rec['one_children'] = one_children
    rec['child_vals'] = sorted(child_vals)
    rec['H1_ok'] = (gA == 1) == (gstar == 0)
    rec['H2_viol'] = [x for x in nd if x[1] == 0]
    rec['H3_viol'] = [x for x in nd if x[1] == 1] if gstar == 0 else []
    rec['D1_ok'] = gA <= 1
    rec['nd'] = nd

    # mirror-failure anatomy for non-diag children (H2 landscape)
    mf = Counter()
    mf_detail = []
    for (s, gAs, dAp, gAp, e_live, re_live) in nd:
        if gAs == 0:
            mf['child_P'] += 1     # H2 violation bucket
            continue
        if gAp == 0:
            mf['mirror_wins'] += 1
            continue
        # mirror fails; what wins from A_s?
        As = A & ~att[s]
        win_classes = set()
        for m in bits(As):
            if bd.grundy(As & ~att[m]) == 0:
                if m in (e, re):
                    win_classes.add('strike')
                elif m == bd.rho[s]:
                    win_classes.add('mirror')  # cannot happen (gAp != 0)
                elif (Delta >> m) & 1 or (bd.mask_rho(Delta) >> m) & 1:
                    win_classes.add('scarline')
                else:
                    win_classes.add('other')
        mf['mirror_fails'] += 1
        mf_detail.append((s, gAs, dAp, gAp, sorted(win_classes)))
    rec['mf'] = mf
    rec['mf_detail'] = mf_detail

    # repair anatomy
    if gstar >= 1:
        T = [t for t in bits(Ae) if bd.grundy(Ae & ~att[t]) == 0]
        cls = []
        for t in T:
            resid = Ae & ~att[t]
            t_in_D = bool((Delta >> t) & 1)
            kills = (Delta & ~att[t]) == 0
            sym = resid == bd.mask_rho(resid)
            s1 = None
            if do_pairing and not sym and resid.bit_count() <= pairing_cap:
                s1 = closed_pairing(list(bits(resid)), att) is not None
            cls.append(dict(t=t, in_Delta=t_in_D, kills_scar=kills,
                            resid_sym=sym, resid_n=resid.bit_count(), s1=s1))
        rec['repairs'] = cls
    else:
        rec['repairs'] = None
    return rec


def run_board(n, do_pairing=True):
    print(f"\n=== n={n} ===")
    t0 = time.time()
    bd = Board(n)
    groot = bd.grundy(bd.full)
    print(f"G({n}) = {groot}  [{len(bd.memo)} reachable positions, "
          f"{time.time()-t0:.1f}s]")
    # filter symmetric
    sym = [a for a in list(bd.memo.keys()) + [bd.full, 0]
           if a == bd.mask_rho(a)]
    sym = sorted(set(sym))
    splay = sym_play_positions(bd)
    only_dag = [a for a in sym if a not in splay]
    only_play = [a for a in splay if a not in bd.memo and a != bd.full]
    print(f"rho-symmetric reachable: {len(sym)}; symmetric-play class: "
          f"{len(splay)}; DAG-only: {len(only_dag)}; play-only-not-in-DAG: "
          f"{len(only_play)}")
    if only_dag:
        dd = Counter(d_of(bd, a) for a in only_dag)
        print(f"  DAG-only positions by d: {dict(sorted(dd.items()))} "
              f"(reachable symmetric positions with NO symmetric placement)")
    # d histogram with max G
    byd = defaultdict(list)
    for a in sym:
        byd[d_of(bd, a)].append(bd.grundy(a))
    print("d-histogram (count : max G):",
          {d: (len(v), max(v)) for d, v in sorted(byd.items())})

    # d=1 anatomy
    recs = []
    for a in sym:
        if d_of(bd, a) == 1:
            recs.append(anatomy_d1(bd, a, do_pairing=do_pairing))
    report_d1(bd, recs)
    print(f"[n={n} total {time.time()-t0:.1f}s, memo {len(bd.memo)}]")
    return bd, recs


def report_d1(bd, recs):
    n_pos = len(recs)
    print(f"\n-- d=1 anatomy: {n_pos} positions --")
    if not n_pos:
        return
    gvals = Counter(r['gA'] for r in recs)
    print(f"G(A) histogram: {dict(sorted(gvals.items()))}   "
          f"D1 {'HOLDS' if all(r['D1_ok'] for r in recs) else 'VIOLATED'}")
    h1 = [r for r in recs if not r['H1_ok']]
    print(f"H1 (G(A)=1 <=> strike child P): violations {len(h1)}")
    for r in h1[:5]:
        print(f"   A={r['A']:#x} gA={r['gA']} gstar={r['gstar']}")
    h2 = [r for r in recs if r['H2_viol']]
    print(f"H2 (all non-diag children N): positions with a P non-diag child: "
          f"{len(h2)}")
    for r in h2[:5]:
        ss = [bd.sq_name(x[0]) for x in r['H2_viol']]
        print(f"   A={r['A']:#x} gA={r['gA']} gstar={r['gstar']} P-children at {ss}")
    h3 = [r for r in recs if r['H3_viol']]
    print(f"H3 (gstar=0 ==> no value-1 child): violations {len(h3)}")
    lemc = [r for r in recs if not r['lemC_ok']]
    print(f"Lemma C (Delta empty ==> strike child P): violations {len(lemc)} "
          f"(must be 0 — proven)")
    conv = [r for r in recs if r['conv_hit']]
    nDempty = sum(1 for r in recs if r['nDelta'] == 0)
    print(f"Delta empty: {nDempty}/{n_pos}; converse probe (Delta nonempty "
          f"but strike child still P): {len(conv)} positions")
    for r in conv[:6]:
        print(f"   A={r['A']:#x} nlive={r['nlive']} |Delta|={r['nDelta']} "
              f"gA={r['gA']}")

    # mirror-failure aggregate
    agg = Counter()
    for r in recs:
        agg.update(r['mf'])
    print(f"non-diag children: {dict(agg)}  "
          f"(mirror_wins = rho(s) refutes A_s; mirror_fails = needs another move)")
    wc = Counter()
    for r in recs:
        for (_s, _g, _d, _gp, wcl) in r['mf_detail']:
            wc[tuple(wcl)] += 1
    if wc:
        print(f"  mirror-fails winning-move classes: {dict(wc)}")
        # show a couple
        shown = 0
        for r in recs:
            for (s, g, d, gp, wcl) in r['mf_detail']:
                if shown < 6:
                    print(f"   ex: A={r['A']:#x} s={bd.sq_name(s)} G(A_s)={g} "
                          f"d(A')={d} G(A')={gp} winners={wcl}")
                    shown += 1

    # fine-structure joint histogram of mirrored exchanges
    fine = Counter()
    for r in recs:
        fine.update(r['fine'])
    print("\nfine structure of non-diag children "
          "(strike_child_P, exchange_kills_pair, G(A'), G(A_s)) : count")
    for k in sorted(fine):
        print(f"   {k}: {fine[k]}")

    # 1-child anatomy (N-side gap): where do the 1-children of pair-killing
    # non-diag children live, when the strike child is P?
    oc_stat = Counter()
    oc_zero = []
    for r in recs:
        for (s, gAs, e_live, re_live, clhist, n1) in r['one_children']:
            oc_stat['cases'] += 1
            if n1 == 0:
                oc_stat['NO_1_CHILD'] += 1
                oc_zero.append((r['A'], s, gAs))
            for cl, c in clhist.items():
                oc_stat[f'1child_{cl}'] += c
            if 'strike' in clhist:
                oc_stat['case_has_strike_1child'] += 1
            if e_live or re_live:
                oc_stat['case_pair_sq_live_in_As'] += 1
    print(f"\n1-child anatomy (gstar=0, pair-killing s): {dict(oc_stat)}")
    for a, s, g in oc_zero[:5]:
        print(f"   NO 1-child: A={a:#x} s={bd.sq_name(s)} G(A_s)={g}")

    # kills_scar <=> resid_sym per-reply check
    ks_mismatch = 0
    for r in recs:
        for c in (r['repairs'] or []):
            if c['kills_scar'] != c['resid_sym']:
                ks_mismatch += 1
    print(f"per-reply kills_scar <=> resid_sym mismatches: {ks_mismatch}")

    # repair anatomy aggregate
    rep = [r for r in recs if r['repairs'] is not None]
    print(f"\nrepair anatomy over {len(rep)} strike-refutable positions "
          f"(gstar>=1):")
    stat = Counter()
    for r in rep:
        cl = r['repairs']
        stat['positions'] += 1
        stat['t_total'] += len(cl)
        stat['t_in_Delta'] += sum(1 for c in cl if c['in_Delta'])
        stat['t_kills_scar'] += sum(1 for c in cl if c['kills_scar'])
        stat['t_perfect(sym)'] += sum(1 for c in cl if c['resid_sym'])
        stat['t_s1'] += sum(1 for c in cl if c['s1'])
        stat['t_s1_checked'] += sum(1 for c in cl if c['s1'] is not None)
        if any(c['resid_sym'] for c in cl):
            stat['pos_any_perfect'] += 1
        elif any(c['s1'] for c in cl):
            stat['pos_any_s1_only'] += 1
        else:
            stat['pos_deep_only'] += 1
        if all(c['in_Delta'] for c in cl):
            stat['pos_all_t_in_Delta'] += 1
    print(f"  {dict(stat)}")
    deep = [r for r in rep if not any(c['resid_sym'] or c['s1']
                                      for c in r['repairs'])]
    for r in deep[:6]:
        cl = r['repairs']
        print(f"   deep-only: A={r['A']:#x} nlive={r['nlive']} "
              f"|Delta|={r['nDelta']} winning t: "
              f"{[(bd.sq_name(c['t']), 'D' if c['in_Delta'] else '-', c['resid_n']) for c in cl]}")


if __name__ == '__main__':
    ns = [int(x) for x in sys.argv[1:]] or [6, 8]
    for n in ns:
        run_board(n, do_pairing=True)
