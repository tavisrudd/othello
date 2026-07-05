"""Extract Z9xZ3=N winning strategy, correct turn parity. o=(0,1) socle center.
Record, for each opponent move y (in context), the set of winning hero replies.
Look for: a mirror on the socle F3^2 + a rule on the order-9 layers.
"""
from itertools import product
from collections import defaultdict
import sys
sys.setrecursionlimit(1000000)

def gadd(x,y): return ((x[0]+y[0])%9, (x[1]+y[1])%3)
def gneg(x):   return ((-x[0])%9, (-x[1])%3)
def gsub(x,y): return ((x[0]-y[0])%9, (x[1]-y[1])%3)
ELTS=[(i,j) for i in range(9) for j in range(3)]; Z=(0,0)
NZ=[x for x in ELTS if x!=Z]
def is_sf(A):
    S=set(A)
    for a in A:
        for b in A:
            if gadd(a,b) in S: return False
    return True
def order(x):
    n=1;y=x
    while y!=Z: y=gadd(y,x);n+=1
    return n
memo={}
def win(A):
    if A in memo: return memo[A]
    S=set(A);res=False
    for x in NZ:
        if x in S: continue
        nA=A|{x}
        if is_sf(nA) and not win(frozenset(nA)): res=True;break
    memo[A]=res;return res

o=(0,1)
assert not win(frozenset({o}))   # {o} is P (opp to move loses)
pi=lambda x: x[0]%3              # quotient G -> Z3

# walk: A is OPP-to-move (P-position). For each opp move y, record hero winning replies.
reply=defaultdict(set)        # y -> set of winning replies (across contexts)
ctx=defaultdict(int)
seen=set()
def walk(A):                  # A: opp to move, P-position
    if A in seen: return
    seen.add(A); S=set(A)
    for y in NZ:
        if y in S: continue
        if is_sf(A|{y}):
            H=frozenset(A|{y})   # hero to move (N)
            wr=[r for r in NZ if r not in H and is_sf(H|{r}) and not win(frozenset(H|{r}))]
            for r in wr: reply[y].add(r)
            ctx[y]+=1
            if wr:
                walk(frozenset(H|{wr[0]}))   # follow one winning reply
walk(frozenset({o}))

# analysis
print(f"o={o} (socle). {len(reply)} distinct opponent moves seen.\n")
def classify(y): return "socle" if order(y)==3 else "ord9"
# hypothesis tags
def sig_socle(y):     # F3^2 reflection on socle: -o-y  (only meaningful if y socle)
    return gneg(gadd(o,y))
uniq=0
print("SOCLE opponent moves (order 3):")
for y in sorted(reply):
    if classify(y)!="socle": continue
    opts=reply[y]; s=sig_socle(y)
    print(f"  y={y}: replies={sorted(opts)}  -o-y={s} {'IN' if s in opts else 'OUT'}")
print("\nORDER-9 opponent moves:")
for y in sorted(reply):
    if classify(y)!="ord9": continue
    opts=reply[y]
    negy=gneg(y); negoy=gneg(gadd(o,y))
    tags=[]
    if negy in opts: tags.append("-y")
    if negoy in opts: tags.append("-o-y")
    # is every winning reply order-9? same layer?
    orders=sorted(set(order(r) for r in opts))
    layers=sorted(set(pi(r) for r in opts))
    print(f"  y={y} pi={pi(y)}: {len(opts)} replies, reply-orders={orders}, reply-pi={layers}"
          f"  {'['+','.join(tags)+']' if tags else ''}")
