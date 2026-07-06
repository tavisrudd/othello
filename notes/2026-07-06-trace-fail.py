r"""Trace the shortest line by which P1 defeats the bulk-forced antidiagonal mirror
(free axis replies) at a given q. Confirms the poison mechanism: an occupied axis point p
lies on the unique phi-invariant 'anti-axis' line M_p through it; P1 plays a bulk z in M_p,
and phi(z) is then forbidden by the collinear triple {z, phi(z), p}.
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
    row_mask = [0]*N; col_mask=[0]*N
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


def main(q, a=1, s=1):
    F,cells,idx,N,rc,lt = build(q)
    ainv=F.inv(a)
    f=lambda r,c:(F.add(F.mul(a,c),s),F.sub(F.mul(ainv,r),F.mul(ainv,s)))
    phi=[idx[f(*cells[i])] for i in range(N)]
    axis=[i for i in range(N) if phi[i]==i]
    forced_ok=[False]*N
    for x in range(N):
        px=phi[x];rx,cx=cells[x];rp,cp=cells[px]
        forced_ok[x]=(px!=x) and (rp!=rx) and (cp!=cx)
    ALL=(1<<N)-1
    def fb(fo,ch,yi):
        nf=fo|rc[yi];c=ch
        while c:
            b=c&(-c);c^=b;nf|=lt[yi][b.bit_length()-1]
        return nf

    memo={}
    # returns (p2_wins, witness_line) where witness_line is P1's defeating continuation if lose
    def p1(ch,fo,trail):
        avail=ALL&~ch&~fo
        a2=avail
        while a2:
            y=a2&(-a2);a2^=y;yi=y.bit_length()-1
            nf=fb(fo,ch,yi);nch=ch|y
            if forced_ok[yi]:
                ri=phi[yi];rb=1<<ri
                if (nch&rb) or (nf&rb):
                    return False, trail+[("P1-bulk",cells[yi]),("POISON: forced mirror",cells[ri],"illegal")]
                nf2=fb(nf,nch,ri)
                w,line=p1(nch|rb,nf2,trail+[("P1-bulk",cells[yi]),("P2-mirror",cells[ri])])
                if not w:
                    return False,line
            else:
                # axis / problem move: free reply
                avail2=ALL&~nch&~nf; ok=False; best=None
                b=avail2
                while b:
                    zb=b&(-b);b^=zb;zi=zb.bit_length()-1
                    nf2=fb(nf,nch,zi)
                    w,line=p1(nch|zb,nf2,trail+[("P1-axis",cells[yi]),("P2-free",cells[zi])])
                    if w:
                        ok=True;break
                    if best is None: best=line
                if not ok:
                    return False, (best if best else trail+[("P1-axis",cells[yi]),("P2 stuck",)])
        return True, None

    x1i=idx[(0,0)];x2i=phi[x1i]
    f1=fb(0,0,x1i);ch1=1<<x1i;f2=fb(f1,ch1,x2i);ch2=ch1|(1<<x2i)
    trail=[("P1-open",cells[x1i]),("P2-open=phi",cells[x2i])]
    win,line=p1(ch2,f2,trail)
    print(f"q={q} phi(a={a},s={s})  axis={ [cells[i] for i in axis] }")
    print(f"  P2 {'WINS' if win else 'LOSES'}")
    if not win:
        print("  P1's defeating line:")
        for step in line:
            print("   ", step)


if __name__=="__main__":
    q=int(sys.argv[1]) if len(sys.argv)>1 else 11
    main(q)
