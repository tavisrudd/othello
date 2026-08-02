#!/usr/bin/env python3
"""C756 saturated-internal: numerical verification of the affine-line case theorem.

A *coherent system* over odd q is a set Z = {z_1,...,z_{t+1}} in F_{q^2} \\ F_q,
t = (q+1)/2, no two elements conjugate, with

    (A)  chi(z_i - z_j)   = delta        for all i != j,
    (B)  chi(z_i - z_j^q) = -delta       for all i != j,

where chi is the quadratic character of F_{q^2} and delta = (-1)^t.

THEOREM (affine-line case).  If a coherent system is contained in an F_q-affine
line of F_{q^2} then q = 5.

The proof splits by the direction of the line.

  Case (a)  L = a + F_q with a not in F_q.  Requires delta = +1.  Setting
            c = a - a^q = d*s (d in F_q^*), condition (B) says
            chi_q(w^2 - eps*d^2) = -delta for every nonzero w in U - U, where
            Z = a + U.  The admissible set T_a has size (q +/- 1)/2, while
            Cauchy-Davenport/Kneser forces U - U = F_q because |U| = (q+3)/2.

  Case (b)  L = b*F_q after translating the unique rational point of L to 0,
            with b = beta + s, beta in F_q.  Then Z = b*U with U inside F_q^*,
            (A) is equivalent to chi(b) = delta, and (B) becomes
            chi_q(g(u_i/u_j)) = -delta with
                g(r) = N(b)*(r^2 + 1) - Tr(b^2)*r.
            g is irreducible exactly when beta != 0, so the admissible ratio set
            T_b has size at most (q+1)/2, while |U| = (q+3)/2 > |F_q^*|/2 forces
            U*U^{-1} = F_q^*, i.e. every r != 1 must lie in T_b (q-2 elements).

This script checks every quantitative step over the prime fields q <= 43, and
exhibits the q = 5 frames inside their line.

Replay:  python3 2026-08-02-c756-line-case-verification.py
"""

from __future__ import annotations

import json
from hashlib import sha256
from itertools import combinations
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-08-02-c756-line-case-verification.json"

PRIMES = [5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43]


def legendre(a: int, q: int) -> int:
    a %= q
    if a == 0:
        return 0
    return 1 if pow(a, (q - 1) // 2, q) == 1 else -1


def least_nonsquare(q: int) -> int:
    return next(e for e in range(2, q) if legendre(e, q) == -1)


class Quad:
    """F_{q^2} = F_q(s), s^2 = eps."""

    def __init__(self, q: int, eps: int) -> None:
        self.q = q
        self.eps = eps

    def mul(self, x, y):
        q, eps = self.q, self.eps
        return ((x[0] * y[0] + eps * x[1] * y[1]) % q, (x[0] * y[1] + x[1] * y[0]) % q)

    def sub(self, x, y):
        q = self.q
        return ((x[0] - y[0]) % q, (x[1] - y[1]) % q)

    def conj(self, x):
        return (x[0], (-x[1]) % self.q)

    def norm(self, x):
        return (x[0] * x[0] - self.eps * x[1] * x[1]) % self.q

    def chi(self, x):
        return legendre(self.norm(x), self.q)


def max_ratio_free_set(allowed: set[int], q: int) -> int:
    """Largest U inside F_q^* with every ratio of distinct elements in `allowed`."""
    verts = list(range(1, q))
    adj = {v: set() for v in verts}
    for a, b in combinations(verts, 2):
        ia = pow(a, q - 2, q)
        ib = pow(b, q - 2, q)
        if (b * ia) % q in allowed and (a * ib) % q in allowed:
            adj[a].add(b)
            adj[b].add(a)
    best = 0

    def expand(clique, cand):
        nonlocal best
        if len(clique) + len(cand) <= best:
            return
        if not cand:
            best = max(best, len(clique))
            return
        cand = sorted(cand)
        while cand:
            v = cand.pop(0)
            if len(clique) + 1 + len(cand) <= best:
                return
            expand(clique + [v], [w for w in cand if w in adj[v]])
        best = max(best, len(clique))

    expand([], verts)
    return best


def max_difference_free_set(allowed: set[int], q: int) -> int:
    """Largest U inside F_q with every nonzero difference in `allowed`."""
    verts = list(range(q))
    adj = {v: set() for v in verts}
    for a, b in combinations(verts, 2):
        if (a - b) % q in allowed and (b - a) % q in allowed:
            adj[a].add(b)
            adj[b].add(a)
    best = 0

    def expand(clique, cand):
        nonlocal best
        if len(clique) + len(cand) <= best:
            return
        if not cand:
            best = max(best, len(clique))
            return
        cand = sorted(cand)
        while cand:
            v = cand.pop(0)
            if len(clique) + 1 + len(cand) <= best:
                return
            expand(clique + [v], [w for w in cand if w in adj[v]])
        best = max(best, len(clique))

    expand([], verts)
    return best


def analyse(q: int, exhaustive: bool) -> dict:
    eps = least_nonsquare(q)
    F = Quad(q, eps)
    t = (q + 1) // 2
    n = t + 1
    delta = 1 if t % 2 == 0 else -1

    # sanity: chi(s) = chi_q(-eps) = delta, so conjugate differences sit in class delta
    assert F.chi((0, 1)) == delta, (q, "chi(s) != delta")

    row = {
        "q": q,
        "eps": eps,
        "t": t,
        "arc_size": n,
        "delta": delta,
        "case_a_possible": delta == 1,
    }

    # ---- case (b): lines meeting F_q in one point -------------------------
    case_b = []
    for beta in range(q):
        b = (beta, 1)
        if F.chi(b) != delta:
            continue  # (A) fails outright
        A = F.norm(b)
        tau = (2 * (beta * beta + eps)) % q
        if beta == 0:
            case_b.append({"beta": beta, "degenerate": True, "T_size": 0})
            continue
        T = set()
        for r in range(1, q):
            g = (A * (r * r + 1) - tau * r) % q
            assert g != 0, (q, beta, r, "g has a rational root")
            if legendre(g, q) == -delta:
                T.add(r)
        entry = {
            "beta": beta,
            "degenerate": False,
            "T_size": len(T),
            "T_bound_ok": len(T) <= (q + 1) // 2,
            "one_in_T": 1 in T,
        }
        assert entry["T_bound_ok"]
        assert not entry["one_in_T"], (q, beta, "r=1 admissible, contradicts g(1)=-4eps")
        if exhaustive:
            entry["max_U"] = max_ratio_free_set(T, q)
        case_b.append(entry)
    row["case_b_max_T"] = max(e["T_size"] for e in case_b) if case_b else None
    row["case_b_needed_T"] = q - 2
    row["case_b_impossible_by_counting"] = row["case_b_max_T"] < q - 2
    if exhaustive:
        row["case_b_max_U"] = max(e.get("max_U", 0) for e in case_b)
        row["case_b_exhaustive_clear"] = row["case_b_max_U"] < n

    # ---- case (a): lines that are cosets of F_q ---------------------------
    if delta == 1:
        case_a = []
        for d in range(1, q):
            T = set()
            for w in range(1, q):
                val = (w * w - eps * d * d) % q
                assert val != 0
                if legendre(val, q) == -delta:
                    T.add(w)
            entry = {"d": d, "T_size": len(T), "T_bound_ok": len(T) <= (q + 1) // 2}
            assert entry["T_bound_ok"]
            if exhaustive:
                entry["max_U"] = max_difference_free_set(T, q)
            case_a.append(entry)
        row["case_a_max_T"] = max(e["T_size"] for e in case_a)
        row["case_a_needed_T"] = q - 1
        row["case_a_impossible_by_counting"] = row["case_a_max_T"] < q - 1
        if exhaustive:
            row["case_a_max_U"] = max(e.get("max_U", 0) for e in case_a)
            row["case_a_exhaustive_clear"] = row["case_a_max_U"] < n
    else:
        row["case_a_max_T"] = None
        row["case_a_impossible_by_counting"] = True  # (A) already fails

    return row


FRAMES = [
    [(0, 1), (1, 4), (2, 2), (4, 3)],
    [(0, 1), (4, 4), (1, 3), (3, 2)],
]


def frame_report() -> list[dict]:
    q, eps = 5, 2
    F = Quad(q, eps)
    t, delta = 3, -1
    out = []
    for frame in FRAMES:
        # coherence
        for i, j in combinations(range(4), 2):
            assert F.chi(F.sub(frame[i], frame[j])) == delta
            assert F.chi(F.sub(frame[i], F.conj(frame[j]))) == -delta
            assert F.chi(F.sub(frame[j], F.conj(frame[i]))) == -delta
        # line containment: all differences are F_q-multiples of one direction
        base = frame[0]
        diffs = [F.sub(z, base) for z in frame[1:]]
        b = diffs[0]
        binv_norm = pow(F.norm(b), q - 2, q)
        ratios = []
        for dvec in diffs:
            prod = F.mul(dvec, F.conj(b))
            ratio = ((prod[0] * binv_norm) % q, (prod[1] * binv_norm) % q)
            assert ratio[1] == 0, "not collinear"
            ratios.append(ratio[0])
        # translate the line's rational point to 0: solve base + lam*b in F_q
        lam = (-base[1] * pow(b[1], q - 2, q)) % q if b[1] else None
        origin = (base[0] + lam * b[0]) % q if lam is not None else None
        U = sorted(((r - lam) % q) for r in [0] + ratios)
        beta_dir = (b[0] * pow(b[1], q - 2, q)) % q  # b ~ beta + s
        A = (beta_dir * beta_dir - eps) % q
        tau = (2 * (beta_dir * beta_dir + eps)) % q
        T = {r for r in range(1, q)
             if legendre((A * (r * r + 1) - tau * r) % q, q) == -delta}
        needed = {(u * pow(v, q - 2, q)) % q for u in U for v in U if u != v}
        out.append({
            "frame": [f"{a}+{b_}s" for a, b_ in frame],
            "direction_beta": beta_dir,
            "line_rational_point": origin,
            "U": U,
            "U_is_all_of_Fq_star": U == list(range(1, q)),
            "T": sorted(T),
            "T_size": len(T),
            "needed_ratios": sorted(needed),
            "ratios_inside_T": needed <= T,
            "q_minus_2": q - 2,
        })
    return out


def main() -> None:
    rows = [analyse(q, exhaustive=(q <= 19)) for q in PRIMES]
    frames = frame_report()
    payload = {
        "task": "C756",
        "claim": "a coherent system contained in an F_q-affine line forces q=5",
        "primes": PRIMES,
        "rows": rows,
        "frames": frames,
        "source_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
    }
    OUTPUT.write_text(json.dumps(payload, indent=1, sort_keys=True) + "\n")

    print(f"{'q':>3} {'delta':>5} {'k':>3} {'maxT_b':>6} {'need':>4} "
          f"{'maxU_b':>6} {'maxT_a':>6} {'maxU_a':>6}")
    for r in rows:
        print(f"{r['q']:>3} {r['delta']:>5} {r['arc_size']:>3} "
              f"{r['case_b_max_T']:>6} {r['case_b_needed_T']:>4} "
              f"{r.get('case_b_max_U', '-'):>6} "
              f"{str(r['case_a_max_T']):>6} {r.get('case_a_max_U', '-'):>6}")
    bad = [r["q"] for r in rows
           if r["q"] > 5 and not (r["case_b_impossible_by_counting"]
                                  and r["case_a_impossible_by_counting"])]
    print("counterexample fields:", bad if bad else "none")
    for f in frames:
        print(f"frame {f['frame']}: U={f['U']} T={f['T']} "
              f"ratios_in_T={f['ratios_inside_T']}")
    print("certificate:", OUTPUT.name)


if __name__ == "__main__":
    main()
