#!/usr/bin/env python3
"""C210 Packet 4: reconstruction and projective genuineness.

The first two exact-split branches have

    R = T * U,     U = Q^2*T + delta*N*G1*G2a.

The checker proves that ``T=0`` reconstructs a repeated seed/repair point,
while a rational ``U=0`` point is genuine away from ``G2a=0``.  Branch 3 is
affine-linear and its noncoincident component loses at most the two points over
``u=a*p`` at either branch intersection.  A complete GF(8) census classifies
the bounded exceptions left after deleting ``G2a=0``; direct projective
incidence witnesses independently verify the coordinate conventions.
"""

from __future__ import annotations

import collections
import itertools
import json
import shutil
import subprocess

from analyze_c210_a_nonzero_b_zero import pulled_quadratics, sform
from analyze_c210_a_nonzero_dAS_census import (
    GF8_INV,
    add as gf8_add,
    mul as gf8_mul,
    square as gf8_square,
    theta as gf8_theta,
)
from analyze_c210_a_zero_factorization_strata import trace_one_pullback
from analyze_c210_exceptional_quadratic_locus import line_key, repair_points
from analyze_c210_residue_hypergraph import build_context


NORMALIZED_GF8_EXCEPTIONS = {
    (1, 2, 4, 5),
    (1, 3, 4, 3),
    (1, 4, 6, 7),
    (1, 5, 6, 5),
    (1, 6, 2, 3),
    (1, 7, 2, 7),
    (2, 4, 6, 1),
    (2, 5, 1, 5),
    (2, 7, 5, 7),
    (3, 1, 1, 5),
    (3, 3, 6, 7),
    (3, 5, 5, 1),
    (4, 3, 7, 3),
    (4, 6, 2, 1),
    (4, 7, 1, 7),
    (5, 1, 1, 7),
    (5, 5, 2, 3),
    (5, 7, 7, 1),
    (6, 2, 4, 1),
    (6, 3, 1, 3),
    (6, 5, 3, 5),
    (7, 1, 1, 3),
    (7, 3, 3, 1),
    (7, 7, 4, 5),
}


def singular_certificate(
    coefficient_strings: tuple[str, ...], cover_string: str, H_string: str, J_string: str
) -> None:
    A, B, C, D, E, F = coefficient_strings
    lines = [
        "ring r=2,(rr,t,u,e,delta,a,b,p,w,h0,h1),(lp(3),dp);",
        "poly theta=w^2+w+1; poly N=a^2+a+1;",
        "poly Q=u^2+u*delta+delta^2;",
        "poly G1=u^2+u*p+p^2*theta;",
        "poly G2a=u^3+u^2*delta+u*p^2*theta+delta*p^2*theta"
        "+delta^2*p+delta*a*G1;",
        "poly T0=p^2*theta+a*delta*p; poly L=delta*b+delta^2;",
        "poly k0=T0+L; poly k1=delta*N*p+a*T0+L;",
        f"poly A={A}; poly B={B}; poly Cc={C};",
        f"poly D={D}; poly E={E}; poly Fc={F};",
        f"poly R={cover_string}; poly H={H_string}; poly J={J_string};",
        "poly q0=A*rr^2+B*rr+Cc; poly q1=D*rr^2+E*rr+Fc;",
        "if(H-delta*N*G1!=0){exit(1);}",
        # Branch 1: T1 is precisely the left-repair/seed coincidence factor.
        "poly T1=a*t^2+b*t+h1;",
        "poly U1=Q^2*T1+delta*N*G1*G2a;",
        "poly R1=subst(subst(R,e,0),h0,0);",
        "if(R1-T1*U1!=0){exit(2);}",
        "poly rec1=subst(subst(J+t*H,e,0),h0,0);",
        "if(reduce(rec1,std(ideal(T1)))!=0){exit(3);}",
        "poly q01=subst(subst(subst(q0,rr,t),e,0),h0,0);",
        "poly q11=subst(subst(subst(q1,rr,t),e,0),h0,0);",
        "if(reduce(q01,std(ideal(T1)))!=0){exit(4);}",
        "if(reduce(q11,std(ideal(T1)))!=0){exit(5);}",
        # Branch 2: h0=k0 and T2=h1+k1 plus the graph terms; T2 is the
        # right-repair/seed coincidence factor, reconstructed by rr=t+u.
        "poly h2=p^2*theta+delta^2+delta*b+delta*a*p;",
        "poly L2=a*p^2*theta+delta*a*p+delta^2+delta*b+delta*p+h1;",
        "if(h2-k0!=0 || L2-(h1+k1)!=0){exit(6);}",
        "poly T2=a*t^2+b*t+L2;",
        "poly U2=Q^2*T2+delta*N*G1*G2a;",
        "poly R2=subst(subst(R,e,delta),h0,h2);",
        "if(R2-T2*U2!=0){exit(7);}",
        "poly rec2=subst(subst(J+(t+u)*H,e,delta),h0,h2);",
        "if(reduce(rec2,std(ideal(T2)))!=0){exit(8);}",
        "poly q02=subst(subst(subst(q0,rr,t+u),e,delta),h0,h2);",
        "poly q12=subst(subst(subst(q1,rr,t+u),e,delta),h0,h2);",
        "if(reduce(q02,std(ideal(T2)))!=0){exit(9);}",
        "if(reduce(q12,std(ideal(T2)))!=0){exit(10);}",
        # On either branch, T=U=0 forces G1*G2a=0 exactly.  The report uses
        # the odd-tower rootlessness of G1 to leave only G2a=0.
        "if(U1+Q^2*T1-delta*N*G1*G2a!=0){exit(11);}",
        "if(U2+Q^2*T2-delta*N*G1*G2a!=0){exit(12);}",
        # Branch 3: both w fibers have G1=Q, G2a=(u+a*p)Q.  T3 is the
        # chi0 component and V3 the chi1 component after cancelling Q^2.
        "poly Q3=subst(Q,delta,p);",
        "if(subst(subst(G1,delta,p),w,0)-Q3!=0){exit(13);}",
        "if(subst(subst(G1,delta,p),w,1)-Q3!=0){exit(14);}",
        "if(subst(subst(G2a,delta,p),w,0)-(u+a*p)*Q3!=0){exit(15);}",
        "if(subst(subst(G2a,delta,p),w,1)-(u+a*p)*Q3!=0){exit(16);}",
        "poly L3=h1+e*b+e*N*(u+p+(a+1)*e);",
        "poly T3=a*t^2+b*t+L3; poly V3=T3+p*N*(u+a*p);",
        "if(subst(T3,e,0)-T1!=0){exit(17);}",
        # At e=p, T3 is the branch-2 noncoincident component (labels swap).
        "poly T2b=subst(subst(subst(T2,delta,p),w,0),e,p);",
        "if(subst(T3,e,p)-(T2b+p*N*(u+a*p))!=0){exit(18);}",
        "if(T3+V3-p*N*(u+a*p)!=0){exit(19);}",
        'print("a-nonzero genuineness certificate passes");',
    ]
    singular = shutil.which("Singular")
    command = (
        [singular, "-q"]
        if singular
        else ["nix", "shell", "nixpkgs#singular", "--command", "Singular", "-q"]
    )
    completed = subprocess.run(
        command,
        input="\n".join(lines),
        text=True,
        capture_output=True,
        check=True,
        timeout=300,
    )
    assert completed.stderr == "", completed.stderr
    assert completed.stdout.strip() == "a-nonzero genuineness certificate passes", (
        completed.stdout
    )


def gf8_trace(value: int) -> int:
    return gf8_add(value, gf8_square(value), gf8_square(gf8_square(value)))


def gf8_genuine_counts(
    delta: int, a: int, b: int, p: int, w: int
) -> tuple[int, int]:
    N = gf8_add(gf8_square(a), a, 1)
    C = gf8_mul(a, delta, N, gf8_square(GF8_INV[b]))
    counts = [0, 0]
    for u in range(8):
        Q = gf8_add(gf8_square(u), gf8_mul(u, delta), gf8_square(delta))
        G1 = gf8_add(
            gf8_square(u), gf8_mul(u, p), gf8_mul(gf8_square(p), gf8_theta(w))
        )
        G2a = gf8_add(
            gf8_mul(gf8_square(u), u),
            gf8_mul(gf8_square(u), delta),
            gf8_mul(u, gf8_square(p), gf8_theta(w)),
            gf8_mul(delta, gf8_square(p), gf8_theta(w)),
            gf8_mul(gf8_square(delta), p),
            gf8_mul(delta, a, G1),
        )
        if G2a == 0:
            continue
        r = gf8_mul(C, G1, G2a, GF8_INV[gf8_square(Q)])
        counts[gf8_trace(r)] += 1
    return counts[0], counts[1]


def gf8_exception_census() -> dict[str, object]:
    histogram: collections.Counter[tuple[int, int]] = collections.Counter()
    normalized = set()
    exceptional_geometries = 0
    for delta in range(1, 8):
        inverse_delta = GF8_INV[delta]
        for a in range(1, 8):
            for b in range(1, 8):
                for p in range(1, 8):
                    for w in range(8):
                        counts = gf8_genuine_counts(delta, a, b, p, w)
                        histogram[counts] += 1
                        if 0 not in counts:
                            continue
                        assert counts[0] == 0 and counts[1] in (5, 7)
                        exceptional_geometries += 1
                        normalized.add(
                            (
                                a,
                                gf8_mul(b, inverse_delta),
                                gf8_mul(p, inverse_delta),
                                gf8_theta(w),
                            )
                        )

    expected_histogram = {
        (0, 5): 210,
        (0, 7): 126,
        (1, 4): 630,
        (1, 6): 630,
        (1, 7): 210,
        (2, 3): 966,
        (2, 5): 2982,
        (2, 6): 1176,
        (3, 2): 798,
        (3, 4): 3500,
        (3, 5): 1638,
        (4, 1): 336,
        (4, 3): 1890,
        (4, 4): 1806,
        (5, 2): 1050,
        (5, 3): 840,
        (6, 1): 210,
        (6, 2): 210,
    }
    assert histogram == expected_histogram
    assert sum(histogram.values()) == 7**4 * 8
    assert exceptional_geometries == 336
    assert normalized == NORMALIZED_GF8_EXCEPTIONS
    return {
        "geometry_count": 7**4 * 8,
        "genuine_u_counts_by_trace_histogram": {
            f"{key[0]},{key[1]}": value for key, value in sorted(histogram.items())
        },
        "exception_geometry_count": exceptional_geometries,
        "exception_constant_classes_per_branch": exceptional_geometries * 4,
        "exception_rule": "normalized tuple (a,b/delta,p/delta,theta) is listed and Tr(c_i)=0",
        "normalized_exception_records": [list(row) for row in sorted(normalized)],
        "nonexception_constant_classes_per_branch": 7**4 * 8 * 8
        - exceptional_geometries * 4,
    }


def projective_witnesses() -> dict[str, object]:
    context = build_context(1)
    field = context.ambient
    base = context.base_values
    add, mul = field.add, field.mul

    def total(*values: int) -> int:
        out = 0
        for value in values:
            out = add(out, value)
        return out

    generator = next(
        value
        for value in base
        if value not in (0, 1)
        and total(mul(mul(value, value), value), value, 1) == 0
    )

    def embed(value: int) -> int:
        return total(
            mul(generator, generator) if value & 4 else 0,
            generator if value & 2 else 0,
            1 if value & 1 else 0,
        )

    def run(name: str, values: tuple[int, ...]) -> dict[str, object]:
        e, delta, a, b, p, w, h0, h1 = (embed(value) for value in values)
        f = add(e, delta)
        theta = total(mul(w, w), w, 1)
        N = total(mul(a, a), a, 1)
        T0 = total(mul(mul(p, p), theta), mul(mul(a, delta), p))
        L = total(mul(delta, b), mul(delta, delta))
        k0 = total(T0, L)
        k1 = total(mul(mul(delta, N), p), mul(a, T0), L)
        by_seed = {}
        for seed_name, seed_height in (
            ("alpha", context.alpha),
            ("beta", context.beta),
        ):
            g0, g1 = context.coordinates(seed_height)
            c0, c1 = add(h0, g0), add(h1, g1)
            d0, d1 = add(c0, k0), add(c1, k1)
            left = dict(zip(base, repair_points(context, e, a, b, c0, c1)))
            right = dict(zip(base, repair_points(context, f, a, b, d0, d1)))
            genuine = set()
            coincident = set()
            for u, t, r in itertools.product(base, repeat=3):
                s = add(r, u)
                seed = (t, seed_height)
                if line_key(context, left[r], right[s]) != line_key(
                    context, left[r], seed
                ):
                    continue
                target = genuine if len({left[r], right[s], seed}) == 3 else coincident
                target.add((u, t))

            expected_genuine = set()
            expected_coincident = set()
            for u, t in itertools.product(base, repeat=2):
                Q = total(mul(u, u), mul(u, delta), mul(delta, delta))
                G1 = total(mul(u, u), mul(u, p), mul(mul(p, p), theta))
                G2a = total(
                    mul(mul(u, u), u),
                    mul(mul(u, u), delta),
                    mul(mul(u, mul(p, p)), theta),
                    mul(mul(delta, mul(p, p)), theta),
                    mul(mul(delta, delta), p),
                    mul(mul(delta, a), G1),
                )
                if name == "branch1":
                    branch_L = h1
                elif name == "branch2":
                    branch_L = total(
                        mul(mul(a, mul(p, p)), theta),
                        mul(mul(delta, a), p),
                        mul(delta, delta),
                        mul(delta, b),
                        mul(delta, p),
                        h1,
                    )
                else:
                    branch_L = total(
                        h1,
                        mul(e, b),
                        mul(mul(e, N), total(u, p, mul(add(a, 1), e))),
                    )
                T = total(mul(a, mul(t, t)), mul(b, t), branch_L)
                U = total(
                    mul(mul(Q, Q), T), mul(mul(mul(delta, N), G1), G2a)
                )
                if name in ("branch1", "branch2"):
                    if U == 0 and T != 0:
                        expected_genuine.add((u, t))
                    if name == "branch2" and T == 0:
                        expected_coincident.add((u, t))
                elif T == 0 or U == 0:
                    expected_genuine.add((u, t))
            assert genuine == expected_genuine, (name, seed_name)
            assert coincident == expected_coincident, (name, seed_name)
            by_seed[seed_name] = {
                "genuine_points": len(genuine),
                "coincident_points_seen_by_line_key": len(coincident),
            }
        return {"GF8_values_e_delta_a_b_p_w_h0_h1": list(values), **by_seed}

    witnesses = {
        "branch1": run("branch1", (0, 1, 1, 1, 1, 0, 0, 0)),
        "branch2": run("branch2", (1, 1, 1, 1, 1, 0, 0, 1)),
        "branch3": run("branch3", (2, 1, 1, 1, 1, 0, 0, 0)),
    }
    assert witnesses["branch1"]["alpha"]["genuine_points"] == 6
    assert witnesses["branch2"]["alpha"] == {
        "genuine_points": 6,
        "coincident_points_seen_by_line_key": 16,
    }
    assert witnesses["branch3"]["alpha"]["genuine_points"] == 14
    return witnesses


def main() -> None:
    ring, coefficients = pulled_quadratics()
    A, B, C, D, E, F = coefficients
    H = ring.add(ring.mul(D, B), ring.mul(A, E))
    J = ring.add(ring.mul(D, C), ring.mul(A, F))
    _, cover = trace_one_pullback()
    singular_certificate(
        tuple(sform(value) for value in coefficients),
        sform(cover),
        sform(H),
        sform(J),
    )
    census = gf8_exception_census()
    witnesses = projective_witnesses()
    print(
        json.dumps(
            {
                "scope": "three known a*delta*N*b*p!=0 exact-split branches",
                "coincidence_classification": {
                    "branch1": "T1=a*t^2+b*t+h1 reconstructs r=t (left repair equals seed)",
                    "branch2": "T2=a*t^2+b*t+L2 reconstructs r=t+u (right repair equals seed)",
                    "other_factor": "U=Q^2*T+delta*N*G1*G2a; away from T=0 it is genuine",
                    "intersection": "T=U=0 forces G2a=0 at odd-tower rational u because G1 has no rational root",
                    "branch3": "choose chi1 at e=0 and chi0 otherwise; at e=p or 0 remove at most the two points over u=a*p",
                },
                "large_field_bound": "genus<=2: #genuine >= q-4*sqrt(q)-6, hence positive for every odd-tower q>=512",
                "gf8_exceptions": census,
                "projective_incidence_witnesses": witnesses,
                "conclusion": "every known branch is genuine-collision-bearing for q>=512; at q=8 branches 1 and 2 have exactly the certified bounded exception classes, while branch 3 is always genuine-collision-bearing",
                "does_not_prove": [
                    "arithmetic completeness of the three residue branches",
                    "genuineness on the separate b=0,q=8 boundary",
                    "arc legality, affine coverage, or C-completeness of any q=8 exception",
                ],
                "trusted_boundary": "universal collision quadratics/resultant, exact GF(2) Singular identities, direct GF(8) arithmetic, and independent GF(64) projective line_key incidence",
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
