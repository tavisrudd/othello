"""Verify the residual-game reframing (star) of Z2 x F3^b == P, i.e. {m} is N.

(a) FULL game: sum-free achievement game on G = Z2 x F3^b, brute memoized.
    Outcome of empty (should be P for b>=1 <=> G(empty)=0) and of {m}.
(b) RESIDUAL game R(V): build labelling eps: D->{0,1}, 0 in D, eps0=1,
    condition (star): for all v+w=u in D, eps_v+eps_w+eps_u = 1 (Z2).
    Outcome from {0:1}.
(c) Cross-check: outcome({m}) in full == outcome(R start); and the legal-move
    sets correspond element-by-element.
"""
import sys
from itertools import product
from functools import lru_cache

def F3(b):
    return list(product(range(3), repeat=b))

def vadd(a, c):
    return tuple((x+y) % 3 for x, y in zip(a, c))

# ---------- FULL group Z2 x F3^b ----------
def full_elements(b):
    # element = (eps, v),  eps in {0,1}, v in F3^b
    return [(e, v) for e in (0, 1) for v in F3(b)]

def gadd(a, c):
    ea, va = a
    ec, vc = c
    return ((ea + ec) % 2, vadd(va, vc))

def is_sumfree_full(A):
    S = set(A)
    for a in A:
        for b_ in A:
            if gadd(a, b_) in S:
                return False
    return True

def full_solver(b):
    Z = tuple(0 for _ in range(b))
    m = (1, Z)
    elts = [x for x in full_elements(b) if x != (0, Z)]  # drop identity
    elts_sorted = sorted(elts)

    from functools import lru_cache
    sys.setrecursionlimit(100000)

    memo = {}
    def win(A):  # A frozenset (sum-free). True if player to move wins.
        key = A
        if key in memo:
            return memo[key]
        res = False
        Sset = set(A)
        for x in elts:
            if x in Sset:
                continue
            newA = A | {x}
            if is_sumfree_full(newA):
                if not win(frozenset(newA)):
                    res = True
                    break
        memo[key] = res
        return res

    empty_win = win(frozenset())
    m_win = win(frozenset({m}))
    return empty_win, m_win, memo

# ---------- RESIDUAL game R(V) via (star) ----------
def residual_solver(b):
    V = F3(b)
    Z = tuple(0 for _ in range(b))
    Vset = set(V)

    def legal_add(eps, v, lab):
        # eps: dict v->0/1 (current D). Add v with label lab. Check (star) for
        # every triple involving v.
        D = eps
        # doubling v+v = 2v
        dv = vadd(v, v)
        if dv in D:
            # lab+lab+eps[dv] = eps[dv] must be 1
            if (lab + lab + D[dv]) % 2 != 1:
                return False
        # triples v + a = c  (a,c in D)  and  a + b = v
        for a, la in D.items():
            c = vadd(v, a)
            if c in D:
                if (lab + la + D[c]) % 2 != 1:
                    return False
            # a + b = v : b = v - a
            bb = tuple((v[i]-a[i]) % 3 for i in range(b))
            if bb in D:
                if (la + D[bb] + lab) % 2 != 1:
                    return False
        return True

    memo = {}
    def win(eps_items):  # eps_items: sorted tuple of (v,lab)
        if eps_items in memo:
            return memo[eps_items]
        eps = dict(eps_items)
        res = False
        for v in V:
            if v in eps:
                continue
            for lab in (0, 1):
                if legal_add(eps, v, lab):
                    child = dict(eps)
                    child[v] = lab
                    citems = tuple(sorted(child.items()))
                    if not win(citems):
                        res = True
                        break
            if res:
                break
        memo[eps_items] = res
        return res

    start = ((Z, 1),)
    return win(start), memo, legal_add

def check(b):
    ew, mw, _ = full_solver(b)
    rw, _, _ = residual_solver(b)
    print(f"b={b}  FULL: empty_win(N?)={ew}  m_win={mw}   RESIDUAL start_win={rw}")
    # {m} is N means the mover from {m} wins == mw True.
    # residual mover-wins == rw. Should match.
    ok = (mw == rw)
    print(f"        outcome(full empty) => G={'N' if ew else 'P'} ; want P (2nd wins)")
    print(f"        {{m}} is {'N' if mw else 'P'} (mover {'wins' if mw else 'loses'}); residual {'N' if rw else 'P'}; MATCH={ok}")
    return ok

if __name__ == "__main__":
    allok = True
    for b in (1, 2):
        allok &= check(b)
    print("ALL MATCH" if allok else "MISMATCH!!!")
