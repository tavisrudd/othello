#!/usr/bin/env python3
"""DEFINITIVE test: does Rita's explicit strategy win {p,e}+*1 against ALL Alice play?

Rita's policy (she is the responder; Alice moves first in {p,e}+*1):
  DEFECT MODE (token present, board = {p} U Sym U {d}, Sym symmetric, d the lone defect):
    Alice takes token          -> Rita plays -d           (then FACTC mode on {p}USym U{d,-d})
    Alice plays m == -d         -> Rita takes token        (then FACTC mode)
    Alice plays m, -m legal     -> Rita plays -m (mirror), defect stays d
    Alice plays m, -m illegal   -> Rita plays -d (migrate), new defect = m
    (if neither -m nor -d legal -> STUCK = strategy fails)
  FACTC MODE (token gone, board = {p} U symmetric):
    Alice plays m               -> Rita plays -m (Fact C guarantees legal)
    (m can't be order-3: p present, 2p dead)

We verify by exhaustive Alice-minimax that Rita, following this policy, always has a
legal reply and makes the last move (Alice eventually cannot move) on EVERY line."""
import sys
sys.setrecursionlimit(1000000)

class G:
    def __init__(self,p,e):
        self.p=p; self.e=e; self.n=3*p
    def can_add(self,B,z):
        n=self.n
        if z in B: return False
        if (2*z)%n in B or (2*z)%n==z: return False
        for a in B:
            if (z+a)%n in B: return False
            if (a+a)%n==z: return False
            if (z-a)%n in B: return False
        return True

TOKEN='TOK'

def verify(p,e,limit_report=5):
    g=G(p,e); n=g.n
    fails=[]
    # state: (board frozenset, token bool, d or None, mode 'D'/'F')
    # returns True if Rita (following policy) wins from this state with Alice to move.
    from functools import lru_cache
    memo={}
    def rita_move(board, token, d, mode, m):
        """given Alice just did move m (an int, or TOKEN), return Rita's (board',token',d',mode')
           or None if stuck / illegal."""
        n=g.n
        if mode=='F':
            # token already gone; board symmetric; Alice played element m
            assert m!=TOKEN
            B2=set(board); B2.add(m)
            r=(-m)%n
            if r in B2 or not g.can_add(B2,r): return None   # Fact C should prevent this
            B2.add(r)
            return (frozenset(B2), False, None, 'F')
        # mode D, token present
        if m==TOKEN:
            # Rita plays -d
            B2=set(board)
            r=(-d)%n
            if r in B2 or not g.can_add(B2,r): return None
            B2.add(r)
            return (frozenset(B2), False, None, 'F')
        # Alice played element m into board
        B2=set(board); B2.add(m)
        if m==(-d)%n:
            # Rita takes token -> factC mode, board unchanged (now symmetric)
            return (frozenset(B2), False, None, 'F')
        rm=(-m)%n
        if rm not in B2 and g.can_add(B2,rm):
            # mirror
            B3=set(B2); B3.add(rm)
            return (frozenset(B3), token, d, 'D')   # defect stays d
        rd=(-d)%n
        if rd not in B2 and g.can_add(B2,rd):
            # migrate: play -d, new defect = m
            B3=set(B2); B3.add(rd)
            return (frozenset(B3), token, m, 'D')
        return None  # STUCK

    def alice_all_moves(board, token, mode):
        mv=[z for z in range(n) if g.can_add(board,z)]
        if mode=='D' and token:
            mv=mv+[TOKEN]
        return mv

    def rita_wins(board, token, d, mode, depth=0):
        # Alice to move. Rita wins iff for ALL Alice moves, resulting Rita-reply leads to Rita win,
        # AND if Alice has no move, Alice loses (Rita wins).
        key=(board,token,d,mode)
        if key in memo: return memo[key]
        amoves=alice_all_moves(board, token, mode)
        if not amoves:
            memo[key]=True   # Alice cannot move -> Alice loses -> Rita wins
            return True
        res=True
        for m in amoves:
            reply=rita_move(board, token, d, mode, m)
            if reply is None:
                # Rita stuck after Alice's m -> strategy fails
                if len(fails)<limit_report:
                    fails.append(('STUCK', sorted(board), token, d, mode, m))
                res=False; break
            b2,t2,d2,mo2=reply
            # after Rita's reply it's Alice's turn again
            if not rita_wins(b2,t2,d2,mo2,depth+1):
                if len(fails)<limit_report:
                    fails.append(('LOSE', sorted(board),token,d,mode,m,'->',sorted(b2)))
                res=False; break
        memo[key]=res
        return res

    # initial: board {p,e}, token present, defect = e, mode D. Alice to move.
    ok=rita_wins(frozenset({p%n, e%n}), True, e%n, 'D')
    print(f"p={p} e={e} Z{n}: Rita strategy WINS all lines = {ok}   (states={len(memo)})")
    for f in fails:
        print("   FAIL:", f)
    return ok

if __name__=="__main__":
    allok=True
    for p in [7,11,13,17]:
        for e in [3,1]:
            allok &= verify(p,e)
    print("\nALL OK:", allok)
