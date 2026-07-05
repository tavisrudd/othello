"""Does the SECOND player win n=0 mod6 using only moves that keep |A xor -A| <= c?
If yes for small uniform c => an S2 bounded-defect certificate exists (provable)."""
import sys
sys.setrecursionlimit(1_000_000)
from sumfree_game import addable_Zn

def neg_mask(A,n):
    B=0; x=A
    while x:
        i=(x&-x).bit_length()-1; x&=x-1
        B|=1<<((-i)%n)
    return B

def p2_wins_bounded(n, c):
    def asym(A): return bin(A ^ neg_mask(A,n)).count("1")
    memo={}
    def f(A, p1_to_move):
        key=(A,p1_to_move)
        r=memo.get(key)
        if r is not None: return r
        elts=[i for i in range(n) if A>>i&1]
        moves=addable_Zn(A,n,elts)
        if p1_to_move:
            # P2 wins iff every P1 move leads to a P2-win (and if no move, P1 loses => P2 wins)
            res=True
            for x in moves:
                if not f(A|(1<<x), False):
                    res=False; break
        else:
            # P2 to move, constrained: wins iff some legal move (asym<=c) leads to P2-win
            res=False
            for x in moves:
                B=A|(1<<x)
                if asym(B)<=c and f(B, True):
                    res=True; break
        memo[key]=res
        return res
    return f(0, True)

for n in [6,12,18,24]:
    row=[]
    for c in [2,4,6,8,10,12]:
        w=p2_wins_bounded(n,c)
        row.append(f"c={c}:{'WIN' if w else '-'}")
        if w: break  # smallest c that works
    print(f"n={n:>2}: {'  '.join(row)}")
print("CONSTRAINED_DONE")
