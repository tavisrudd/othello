#!/usr/bin/env python3
"""Tactic-1 experiment: strictly-matched residual involution for Z3^2 x Z_p.

The reduction says root = P  <=>  each of the 3 openings (socle/coprime/mixed) is
an N-position  <=>  each opening s0 has *some* reply t after which the SECOND player
(Bob) wins the residual sub-game from {s0,t}.

Tactic 1 (lit scout, ranked #1): try to make that "Bob wins from {s0,t}" a clean
MIRROR: an affine involution pi of G with pi({s0,t})={s0,t}, Bob replies pi(x) to
every Alice move x, and the played set stays pi-invariant + sum-free.

Two verifier strengths:
  - PURE fpf:  every legal move x has pi(x)!=x and pi(x) legal (existing verify).
  - STRICT (self-blocking clique): a legal fixed point x (pi(x)=x) is allowed IF
    the set of legal fixed points is a self-blocking clique (pairwise-conflicting).
    When Alice plays such an x, no other fixed point remains legal; Bob then falls
    back to an EXACT solve of the (now smaller, fixed-point-free) residual.  This is
    the "self-blocking core the seed absorbs" relaxation the lit note flagged untested.

Reports, per opening and per p, whether ANY (t,pi) certifies the opening is N, and
the eigen-structure of the winning pi (so a hit yields a writeable uniform proof).
"""
from __future__ import annotations
import argparse, itertools, sys
sys.setrecursionlimit(1000000)

# ----- group arithmetic on F3 x F3 x Z_p -----
def add(a, b, mods):
    return ((a[0]+b[0])%3, (a[1]+b[1])%3, (a[2]+b[2])%mods[2])

def can_add(board_set, z, mods):
    """board_set sum-free; can we add z keeping sum-free?  O(|S|) incremental."""
    p = mods[2]
    if z in board_set:
        return False
    # 2z == z impossible (z!=0). 2z in S?
    dz = ((2*z[0])%3, (2*z[1])%3, (2*z[2])%p)
    if dz in board_set:
        return False
    for a in board_set:
        # z + a  (a triple z+a=c needs c in S; also a+a=z; also z=a+b i.e. z-a in S)
        s = add(z, a, mods)
        if s in board_set:      # z + a = c in S
            return False
        # a + a = z ?
        aa = ((2*a[0])%3, (2*a[1])%3, (2*a[2])%p)
        if aa == z:
            return False
    # existing pair a+b = z ?
    for a in board_set:
        need = ((z[0]-a[0])%3, (z[1]-a[1])%3, (z[2]-a[2])%p)
        if need in board_set:
            return False
    return True

def legal_moves(board_set, elems, mods):
    return [x for x in elems if can_add(board_set, x, mods)]

# ----- affine involutions of G -----
def det2(M): return (M[0][0]*M[1][1]-M[0][1]*M[1][0])%3
def mat_vec(M,h): return ((M[0][0]*h[0]+M[0][1]*h[1])%3,(M[1][0]*h[0]+M[1][1]*h[1])%3)
def mat_mul(A,B):
    return tuple(tuple(sum(A[i][k]*B[k][j] for k in range(2))%3 for j in range(2)) for i in range(2))
def gl23():
    out=[]
    for v in itertools.product(range(3),repeat=4):
        M=((v[0],v[1]),(v[2],v[3]))
        if det2(M): out.append(M)
    return out

def eig_structure(M):
    """dims of +1 and -1 eigenspaces of an F3 involution M (2x2)."""
    # M x = x  ->  (M-I)x=0 ; M x = -x -> (M+I)x=0
    def kerdim(N):
        # rank of 2x2 over F3
        rows=[[N[0][0]%3,N[0][1]%3],[N[1][0]%3,N[1][1]%3]]
        # rank
        r=0
        m=[row[:] for row in rows]
        for c in range(2):
            piv=None
            for rr in range(r,2):
                if m[rr][c]%3: piv=rr;break
            if piv is None: continue
            m[r],m[piv]=m[piv],m[r]
            inv=pow(m[r][c],1,3); inv=[0,1,2][m[r][c]]  # inverse in F3: 1->1,2->2
            invv={1:1,2:2}[m[r][c]%3]
            m[r]=[(x*invv)%3 for x in m[r]]
            for rr in range(2):
                if rr!=r and m[rr][c]%3:
                    f=m[rr][c]
                    m[rr]=[(m[rr][j]-f*m[r][j])%3 for j in range(2)]
            r+=1
        return 2-r
    Im=((1,0),(0,1))
    MpI=((M[0][0]+1,M[0][1]),(M[1][0],M[1][1]+1))
    MmI=((M[0][0]-1,M[0][1]),(M[1][0],M[1][1]-1))
    return kerdim(MpI), kerdim(MmI)  # (dim +1 eigenspace, dim -1 eigenspace)

def affine_specs(p, allow_beta=True):
    I=((1,0),(0,1))
    for M in gl23():
        if mat_mul(M,M)!=I: continue
        for b in itertools.product(range(3),repeat=2):
            if tuple((mat_vec(M,b)[i]+b[i])%3 for i in range(2))!=(0,0): continue
            for alpha in (1,-1):
                betas=[0] if alpha==1 else (list(range(p)) if allow_beta else [0])
                for beta in betas:
                    yield (M,b,alpha%p if alpha==1 else (alpha%p), alpha, beta)

def make_pi(spec, p):
    M,b,_,alpha,beta=spec
    def pi(x):
        h=mat_vec(M,(x[0],x[1]))
        return ((h[0]+b[0])%3,(h[1]+b[1])%3,(alpha*x[2]+beta)%p)
    return pi

def set_invariant(board_set, pi):
    return all(pi(x) in board_set for x in board_set)

# ----- exact solver (only for fixed-point fallback; memoized, small residuals) -----
def exact_win(board_set, elems, mods, memo, budget):
    """True if player-to-move WINS (normal play). budget guards blowup."""
    if budget[0] <= 0:
        return None  # unknown / gave up
    key = frozenset(board_set)
    if key in memo:
        return memo[key]
    budget[0]-=1
    moves = legal_moves(board_set, elems, mods)
    if not moves:
        memo[key]=False; return False   # no move -> lose
    res=False
    for z in moves:
        child=set(board_set); child.add(z)
        w=exact_win(child, elems, mods, memo, budget)
        if w is None:
            memo[key]=None; return None
        if w is False:      # opponent loses -> we win
            res=True; break
    memo[key]=res; return res

# ----- mirror verifier -----
def count_defects(board, pi, elems, mods, max_states):
    """Mirror the bulk; at each 'defect' (mate illegal or fixed point) COUNT it and
    prune (assume handleable). Returns (min-viable?, distinct_defect_positions,
    defect_move_kinds, states). Cheap: no exact-solve. A low count => candidate cert."""
    bset=frozenset(board)
    if not set_invariant(bset, pi):
        return None
    seen=set(); defects=[]
    def rec(A):
        if A in seen: return
        if len(seen)>=max_states: return
        seen.add(A)
        for x in legal_moves(A, elems, mods):
            y=pi(x)
            if y==x or not can_add(set(A)|{x}, y, mods):
                defects.append((A,x)); continue
            child=frozenset(set(A)|{x,y})
            if not set_invariant(child, pi):
                defects.append((A,x)); continue
            rec(child)
    rec(bset)
    # distinct defect Alice-moves (the "defect set" the substitution rule must cover)
    dmoves=set(x for _,x in defects)
    return len(defects), dmoves, len(seen)

def verify(board, pi, elems, mods, max_states, strict=False, defect_solve=False,
          solve_budget=300000, max_defects=8, stats=None):
    """board: iterable start position (pi-invariant, Bob has just achieved symmetry,
    Alice to move). Returns (ok, reason, states).

    strict:        legal fixed points allowed iff they form a self-blocking clique,
                   handled by an exact Bob-to-move solve of A|{x}.
    defect_solve:  ALSO handle 'mate illegal' (a swapped-pair defect, like the n=0mod6
                   n/2->n/3 case): exact-solve A|{x} (Bob to move) and require Bob wins.
                   Mirror on the bulk, exact-solve on the bounded defect branches."""
    bset=frozenset(board)
    if not set_invariant(bset, pi):
        return False,"not-invariant",0
    seen={}
    exact_memo={}
    shared_budget=[solve_budget]   # total exact-solve work per spec
    if stats is None: stats={}
    stats.setdefault("defect_branches",0); stats.setdefault("defect_solve_nodes",0)
    def rec(A):
        if A in seen: return seen[A]
        if len(seen)>=max_states:
            seen[A]=False; return False
        moves=legal_moves(A, elems, mods)
        fixed=[x for x in moves if pi(x)==x]
        if fixed and strict:
            for i in range(len(fixed)):
                for j in range(i+1,len(fixed)):
                    if can_add(set(A)|{fixed[i]}, fixed[j], mods):
                        seen[A]=False; return False  # two fixed pts coexist -> not a clique
        for x in moves:
            y=pi(x)
            mate_illegal = (y!=x) and (not can_add(set(A)|{x}, y, mods))
            is_fixed = (y==x)
            if is_fixed or mate_illegal:
                if is_fixed and not (strict or defect_solve):
                    seen[A]=False; return False
                if mate_illegal and not defect_solve:
                    seen[A]=False; return False
                # defect: exact-solve A|{x}, BOB to move, Bob must win.
                stats["defect_branches"]+=1
                child=set(A); child.add(x)
                w=exact_win(child, elems, mods, exact_memo, shared_budget)
                stats["defect_solve_nodes"]=len(exact_memo)
                if w is not True:
                    seen[A]=False; return False
                continue
            child=frozenset(set(A)|{x,y})
            if not set_invariant(child, pi):
                seen[A]=False; return False
            if not rec(child):
                seen[A]=False; return False
        seen[A]=True; return True
    ok=rec(bset)
    return ok, ("ok" if ok else "mirror-break"), len(seen)

OPENINGS={"socle":(0,1,0),"coprime":(0,0,1),"mixed":(1,0,1)}

def kind(x):
    soc=(x[0],x[1])!=(0,0); cop=x[2]!=0
    return "mixed" if soc and cop else "socle" if soc else "coprime" if cop else "zero"

def search(p, openings, max_states, strict, defect_solve, allow_beta, verbose):
    mods=(3,3,p)
    elems=[e for e in itertools.product(range(3),range(3),range(p)) if any(e)]
    specs=list(affine_specs(p, allow_beta))
    print(f"=== p={p}  |G|={3*3*p}  affine involutions={len(specs)}  strict={strict} defect_solve={defect_solve} ===")
    for oname in openings:
        s0=OPENINGS[oname]
        R=legal_moves({s0}, elems, mods)
        found=None
        tried=0
        for spec in specs:
            pi=make_pi(spec, p)
            cands=[]
            ps=pi(s0)
            if ps==s0:
                cands=[r for r in R if pi(r)==r]
            else:
                if ps in R:
                    cands=[ps]
            for t in cands:
                board={s0,t}
                if not set_invariant(board, pi): continue
                tried+=1
                st={}
                ok,reason,states=verify(board, pi, elems, mods, max_states,
                                        strict=strict, defect_solve=defect_solve, stats=st)
                if ok:
                    found=(spec,t,states,st); break
            if found: break
        if found:
            spec,t,states,st=found
            M,b,_,alpha,beta=spec
            ep,em=eig_structure(M)
            print(f"  {oname:8s}: *** CERT FOUND *** reply t={t} ({kind(t)})  states={states}")
            print(f"            pi: M={M} (eig +1 dim={ep}, -1 dim={em}), b={b}, alpha={alpha}, beta={beta}")
            print(f"            defect_branches={st.get('defect_branches')}  defect_solve_memo={st.get('defect_solve_nodes')}")
        else:
            print(f"  {oname:8s}: no certificate  ({tried} invariant (t,pi) boards tried)")

def rank(p, openings, max_states, allow_beta):
    """For each opening, rank all invariant (t,pi) boards by defect count (cheap)."""
    mods=(3,3,p)
    elems=[e for e in itertools.product(range(3),range(3),range(p)) if any(e)]
    specs=list(affine_specs(p, allow_beta))
    print(f"=== RANK p={p}  specs={len(specs)} ===")
    for oname in openings:
        s0=OPENINGS[oname]
        R=legal_moves({s0}, elems, mods)
        results=[]
        for spec in specs:
            pi=make_pi(spec, p)
            ps=pi(s0)
            cands=[r for r in R if pi(r)==r] if ps==s0 else ([ps] if ps in R else [])
            for t in cands:
                board={s0,t}
                if not set_invariant(board, pi): continue
                cd=count_defects(board, pi, elems, mods, max_states)
                if cd is None: continue
                ndef,dmoves,states=cd
                results.append((ndef,len(dmoves),states,spec,t))
        results.sort(key=lambda r:(r[0],r[1]))
        print(f"  {oname:8s}: {len(results)} boards, best defect counts:")
        for ndef,ndm,states,spec,t in results[:6]:
            M,b,_,alpha,beta=spec; ep,em=eig_structure(M)
            print(f"     defects={ndef:4d} distinct={ndm:3d} states={states:5d}  t={t} M+1d={ep}-1d={em} a={alpha} b={b} beta={beta}")

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--ps", type=str, default="7,11,13")
    ap.add_argument("--openings", type=str, default="socle,coprime,mixed")
    ap.add_argument("--max-states", type=int, default=300000)
    ap.add_argument("--strict", action="store_true")
    ap.add_argument("--defect-solve", action="store_true",
                    help="mirror on bulk, exact-solve bounded defect branches (Bob to move)")
    ap.add_argument("--no-beta", action="store_true", help="only linear (beta=0)")
    ap.add_argument("--rank", action="store_true", help="cheap: rank specs by defect count")
    ap.add_argument("--verbose", action="store_true")
    a=ap.parse_args()
    ps=[int(x) for x in a.ps.split(",")]
    ops=a.openings.split(",")
    for p in ps:
        if a.rank:
            rank(p, ops, a.max_states, not a.no_beta)
        else:
            search(p, ops, a.max_states, a.strict, a.defect_solve, not a.no_beta, a.verbose)

if __name__=="__main__":
    main()
