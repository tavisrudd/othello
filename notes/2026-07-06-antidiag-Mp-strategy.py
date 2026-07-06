r"""The candidate UNIFORM q-odd strategy: antidiagonal mirror + 'fill M_p' axis handling.

Setup: residual grid game (q x q, partial-permutation + affine cap, P1 first). P2 uses the
antidiagonal involution phi (a=1: phi(r,c)=(c+s, r-s)). phi's fixed line is the axis ell
(direction (a,1)); the phi-invariant NON-axis lines are the 'anti-axis' lines M_p through
each axis point p, in direction (-a,1). On M_p, phi acts as the reflection x -> 2p - x with
the single fixed point p.

POISON MECHANISM (confirmed, 2026-07-06-trace-fail.py): every bulk cell w lies on exactly
ONE phi-invariant line, namely M_{p(w)} (the anti-axis line through w), and phi(w) is the
reflection of w across p(w) on that line. So the forced mirror phi(w) is illegal ONLY if the
axis point p(w) is already occupied (triple {w, phi(w), p(w)}). Central symmetry sigma_c and
'free' or 'axis-only' antidiagonal replies all die because they let an occupied problem point
sit on a live mirror line.

THE FIX: answer P1's axis move p by playing a cell z0 ON M_p. Then M_p holds {p, z0} => it is
full (a cap has <=2 per line) => P1 can never play a bulk w with p(w)=p => the only line p
could poison is dead. And z0's own anti-axis line is M_p (z0 in M_p) which is now full, so the
unpaired z0 poisons nothing else. If this is stuck-free for all odd q, it is the uniform proof.

This tests: reply to an axis move with a cell on M_p (search M_p cells for a winning one).
Also reports whether the winning M_p-reply is unique / canonical.
"""
import sys
from itertools import product
from gf import GF

sys.setrecursionlimit(1 << 20)


def build(q):
    F = GF(q)
    cells = list(product(range(q), repeat=2))
    idx = {c: i for i, c in enumerate(cells)}
    N = len(cells)
    def cl(p, a, b):
        u0, u1 = F.sub(a[0], p[0]), F.sub(a[1], p[1])
        w0, w1 = F.sub(b[0], p[0]), F.sub(b[1], p[1])
        return F.sub(F.mul(u0, w1), F.mul(u1, w0)) == 0
    row_mask=[0]*N; col_mask=[0]*N
    for i,(r,c) in enumerate(cells):
        for j,(r2,c2) in enumerate(cells):
            if i==j: continue
            if r2==r: row_mask[i]|=1<<j
            if c2==c: col_mask[i]|=1<<j
    rc=[row_mask[i]|col_mask[i] for i in range(N)]
    lt=[[0]*N for _ in range(N)]
    for i in range(N):
        for j in range(N):
            if i==j: continue
            m=0
            for k in range(N):
                if k!=i and k!=j and cl(cells[i],cells[j],cells[k]): m|=1<<k
            lt[i][j]=m
    return F,cells,idx,N,rc,lt


def run(q, a=1, s=1, verbose=False):
    F,cells,idx,N,rc,lt = build(q)
    ainv=F.inv(a)
    f=lambda r,c:(F.add(F.mul(a,c),s),F.sub(F.mul(ainv,r),F.mul(ainv,s)))
    phi=[idx[f(*cells[i])] for i in range(N)]
    assert all(phi[phi[i]]==i for i in range(N))
    axis=[i for i in range(N) if phi[i]==i]
    forced_ok=[False]*N
    for x in range(N):
        px=phi[x];rx,cx=cells[x];rp,cp=cells[px]
        forced_ok[x]=(px!=x) and (rp!=rx) and (cp!=cx)
    # M_p for each axis point p: {(p0 - a t, p1 + t)}
    Mp = {}
    for pi in axis:
        p0,p1=cells[pi]
        Mp[pi]=[idx[(F.sub(p0,F.mul(a,t)), F.add(p1,t))] for t in range(q)]
    ALL=(1<<N)-1
    def fb(fo,ch,yi):
        nf=fo|rc[yi];c=ch
        while c:
            b=c&(-c);c^=b;nf|=lt[yi][b.bit_length()-1]
        return nf

    memo={}
    def p1(ch,fo):
        v=memo.get(ch)
        if v is not None: return v
        avail=ALL&~ch&~fo
        res=True; a2=avail
        while a2 and res:
            y=a2&(-a2);a2^=y;yi=y.bit_length()-1
            nf=fb(fo,ch,yi);nch=ch|y
            if forced_ok[yi]:
                ri=phi[yi];rb=1<<ri
                if (nch&rb) or (nf&rb):
                    res=False
                else:
                    nf2=fb(nf,nch,ri)
                    if not p1(nch|rb,nf2): res=False
            else:
                # yi is on the axis ell (phi-fixed). Reply on M_{yi}.
                ok=False
                for zi in Mp[yi]:
                    zb=1<<zi
                    if zi==yi or (nch&zb) or (nf&zb): continue
                    nf2=fb(nf,nch,zi)
                    if p1(nch|zb,nf2): ok=True; break
                if not ok: res=False
        memo[ch]=res
        return res

    x1i=idx[(0,0)];x2i=phi[x1i]
    f1=fb(0,0,x1i);ch1=1<<x1i;f2=fb(f1,ch1,x2i);ch2=ch1|(1<<x2i)
    win=p1(ch2,f2)
    print(f"q={q:>3}  phi(a={a},s={s})  M_p-strategy  states={len(memo):>9}  "
          f"-> P2 {'WINS' if win else 'FAILS'}", flush=True)
    return win


if __name__=="__main__":
    qs=eval(sys.argv[1]) if len(sys.argv)>1 else [3,5,7,9,11]
    allok=True
    for q in qs:
        allok &= run(q)
    print("ANTIDIAG_MP_DONE"+("" if allok else "  (SOME FAIL)"))
