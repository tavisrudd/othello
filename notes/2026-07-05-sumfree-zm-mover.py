"""Z2 x F3^b = P attempt: via the proven s2=1 reduction, this is '{m} is N'
(m = the unique order-2 element). Reverse-engineering + candidate mover-mirrors.

Result (b>=2): the three natural mover-mirrors all FAIL on the m-coset (1,.):
  - gamma(e,h)=(e+1,-h) [glide]        : gamma(y)+gamma(y)=y doubling on (0,.).
  - negation-on-H (e,h)->(e,-h)        : O3 doubling on (0,.) coset.
  - psi: (0,h)->(0,2o-h), (1,h)->(1,-h): m-coset negation has the O3 doubling.
The tension: fixing m needs an ORIGIN-centered H-reflection (= negation, which
has the O3 doubling); any off-origin center moves m. So {m} is N has no clean
single-involution mover-mirror for b>=2 (unlike b=1, Lemma 4). Open.
"""
from itertools import product


def build(b):
    mods = (2,) + (3,) * b
    elems = list(product(range(2), *[range(3) for _ in range(b)]))
    idx = {e: i for i, e in enumerate(elems)}
    zero = idx[tuple([0] * (b + 1))]
    N = len(elems)
    add = [[idx[tuple((x + y) % mm for x, y, mm in zip(elems[i], elems[j], mods))]
            for j in range(N)] for i in range(N)]
    return mods, elems, idx, zero, add, N


def sf(A, add):
    S = set(A)
    for a in A:
        for c in A:
            if add[a][c] in S:
                return False
    return True


def check_mirror(b, phi, start, name, cap=200000):
    """BFS phi-symmetric sum-free sets from `start`; test A|{y,phi y} sum-free."""
    mods, elems, idx, zero, add, N = build(b)
    ground = [i for i in range(N) if i != zero]
    ph = [phi(i, elems, idx, b) for i in range(N)]
    bad = tested = 0
    seen = {start}
    stack = [start]
    while stack:
        A = stack.pop()
        As = set(A)
        for y in ground:
            if y in As or ph[y] == y:
                continue
            if not sf(As | {y}, add):
                continue
            py = ph[y]
            tested += 1
            S = As | {y, py}
            ok = py != zero and py != y and py not in As and sf(S, add)
            if not ok:
                bad += 1
            else:
                A2 = frozenset(S)
                if A2 not in seen and len(A2) < N and len(seen) < cap:
                    seen.add(A2)
                    stack.append(A2)
    print(f"  Z2xF3^{b} [{name}]: tests={tested} VIOLATIONS={bad}  "
          f"{'clean' if bad == 0 else 'FAIL'}")


def gamma(i, elems, idx, b):
    e = elems[i]
    return idx[((e[0] + 1) % 2,) + tuple((-e[k]) % 3 for k in range(1, b + 1))]


def psi(i, elems, idx, b):
    e = elems[i]; eps = e[0]; h = e[1:]
    o = tuple([0] * (b - 1) + [1])
    if eps == 0:
        nh = tuple((2 * o[k] - h[k]) % 3 for k in range(b))
    else:
        nh = tuple((-h[k]) % 3 for k in range(b))
    return idx[(eps,) + nh]


if __name__ == "__main__":
    for b in [1, 2, 3]:
        mods, elems, idx, zero, add, N = build(b)
        m = idx[(1,) + tuple([0] * b)]
        oc = idx[(0,) + tuple([0] * (b - 1) + [1])]
        check_mirror(b, gamma, frozenset(), "glide gamma")
        check_mirror(b, psi, frozenset([m, oc]), "psi (fix m,(0,o))")
    print("ZM_MOVER_DONE")
