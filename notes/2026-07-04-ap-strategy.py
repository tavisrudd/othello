"""Validate P2 strategies for the 3-AP-free game on Z_n.
  even n: whole-board translation mirror  tau(x)=x+n/2 (fpf involution).
  odd  n: move-then-mirror reflection.  P1 opens a; P2 replies b; center
          c=(a+b)/2 (midpoint) self-blocks; mirror sigma_c(x)=2c-x.
Report whether the specific mirror beats ALL P1 play (P2 never stuck, P1 first
stuck). A failure means THAT mirror is not a winning strategy (the game may still
be P by another strategy)."""
import sys
from functools import lru_cache
from ap_free_zn import ap_free

sys.setrecursionlimit(1 << 20)


def legal(A, n):
    return [x for x in range(n) if x not in A and ap_free(A | {x}, n)]


def verify_even(n):
    assert n % 2 == 0
    m = n // 2

    def solver(reply):
        memo = {}
        def p1(Afs):
            if Afs in memo:
                return memo[Afs]
            A = set(Afs)
            res = True
            for y in legal(A, n):
                yp = reply(y)
                if yp == y or yp in A:
                    res = False; break
                if not ap_free(A | {y, yp}, n):
                    res = False; break
                if not p1(frozenset(A | {y, yp})):
                    res = False; break
            memo[Afs] = res
            return res
        return p1

    rep = lambda y: (y + m) % n
    bad = []
    for x in range(n):
        xp = rep(x)
        if xp == x:
            bad.append(("vfix", x)); continue
        if not solver(rep)(frozenset({x, xp})):
            bad.append(("open", x))
    return len(bad) == 0, bad


def verify_odd(n):
    assert n % 2 == 1
    inv2 = (n + 1) // 2

    def solver(c):
        memo = {}
        refl = lambda y: (2 * c - y) % n
        def p1(Afs):
            if Afs in memo:
                return memo[Afs]
            A = set(Afs)
            res = True
            for y in legal(A, n):
                yp = refl(y)
                if yp == y or yp in A:
                    res = False; break
                if not ap_free(A | {y, yp}, n):
                    res = False; break
                if not p1(frozenset(A | {y, yp})):
                    res = False; break
            memo[Afs] = res
            return res
        return p1

    a = 0
    bad = []
    for b in range(1, n):
        c = ((a + b) * inv2) % n
        if not solver(c)(frozenset({a, b})):
            bad.append(("open", a, b, c))
    # P2 gets to CHOOSE b; strategy wins iff SOME b works for the a=0 opening,
    # AND (by 2-transitivity-ish) we also need it to hold for P1's actual opening.
    # Simpler correct check: game is a P-position iff EVERY P1 opening {a} is N.
    # Here we test: does the reflection mirror (some center) refute opening a=0?
    return len(bad) < (n - 1), bad  # True if at least one b-center works


if __name__ == "__main__":
    print("EVEN n: translation-n/2 mirror beats all P1 play?")
    for n in [2, 4, 6, 8, 10, 12, 14, 16, 20, 24]:
        ok, bad = verify_even(n)
        print(f"  n={n:2d} ({'4|n' if n%4==0 else '2 mod4'}): {ok}"
              + ("" if ok else f"  fails at {bad[:4]}"), flush=True)
    print("ODD n: does SOME reflection-center refute the a=0 opening?")
    for n in [3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23]:
        ok, bad = verify_odd(n)
        nwins = (n - 1) - len(bad)
        print(f"  n={n:2d}: some-center-works={ok}  ({nwins}/{n-1} b-centers win the a=0 refutation)",
              flush=True)
    print("AP_STRATEGY_DONE")
