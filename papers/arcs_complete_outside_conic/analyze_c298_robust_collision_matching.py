#!/usr/bin/env python3
"""C298: exact projection audit for the C210 collision correspondence.

The checker rebuilds the universal ordered collision equations in the three
vertex parameters ``(t,r,s)``, certifies the reconstruction degree bounds, and
uses exact Singular arithmetic to isolate the only genuine constant-vertex
components.  Those components occur on the ``a=0, delta=b=p`` intersections
of the first/second-coset branches with branch 3.
"""

from __future__ import annotations

import json
import itertools
import shutil
import subprocess
import sys

from analyze_c210_a_nonzero_b_zero import pulled_quadratics, sform
from analyze_c210_a_zero_artin_schreier_divisor import (
    restrict_zero,
    singular_poly,
    t_coefficient,
    trace_one_pullback,
)
from analyze_c210_a_zero_factorization_strata import TVARS
from analyze_c210_exceptional_quadratic_locus import line_key, repair_points
from analyze_c210_residue_hypergraph import build_context
from analyze_c210_seed_cross_repair_curve import (
    BinaryRing,
    NAMES,
    expected_quadratics,
)


def degree(poly, variable: str) -> int:
    index = TVARS.index(variable)
    return max((monomial[index] for monomial in poly), default=-1)


def universal_triple_degrees() -> dict[str, object]:
    """Rebuild q0,q1 after u=s+r and record their vertex degrees."""
    ring = BinaryRing()
    v = ring.variables
    coefficients = tuple(
        ring.substitute(poly, "u", ring.add(v["s"], v["r"]))
        for poly in expected_quadratics(ring)
    )
    A, B, C, D, E, F = coefficients
    q0 = ring.add(ring.mul(A, ring.square(v["r"])), ring.mul(B, v["r"]), C)
    q1 = ring.add(ring.mul(D, ring.square(v["r"])), ring.mul(E, v["r"]), F)

    def data(poly):
        coordinate_degrees = {
            name: max(monomial[NAMES.index(name)] for monomial in poly)
            for name in ("t", "r", "s")
        }
        total_degree = max(
            sum(monomial[NAMES.index(name)] for name in ("t", "r", "s"))
            for monomial in poly
        )
        return {
            "coordinate_degrees": coordinate_degrees,
            "total_vertex_degree": total_degree,
            "term_count": len(poly),
        }

    result = {"q0": data(q0), "q1": data(q1)}
    assert result == {
        "q0": {
            "coordinate_degrees": {"t": 2, "r": 2, "s": 2},
            "total_vertex_degree": 3,
            "term_count": 27,
        },
        "q1": {
            "coordinate_degrees": {"t": 2, "r": 2, "s": 2},
            "total_vertex_degree": 3,
            "term_count": 32,
        },
    }
    return result


def run_singular(lines: list[str]) -> str:
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
    return completed.stdout.strip()


def singular_projection_certificate(
    a2_string: str,
    a1_string: str,
    a0_string: str,
    H_string: str,
    J_string: str,
) -> None:
    """Certify the two collapsed stars and exclude all other split-line collapses."""
    lines = [
        # Polynomial-ring elimination on the e=0 and e=delta a=0 branches.
        "ring rp=2,(u,t,c,delta,b,p,w,h1,e,h0,a),dp;",
        f"poly A2={a2_string}; poly A1={a1_string}; poly A0={a0_string};",
        "poly theta=w^2+w+1; poly R0=A2*t^2+A1*t+A0;",
        f"poly HH={H_string}; poly JJ={J_string};",
        "poly RT=subst(subst(R0,e,0),h0,0); poly LT=t*b+h1;",
        "poly MT=RT/LT; if(MT*LT-RT!=0 || diff(MT,t)-b*(u^2+u*delta+delta^2)^2!=0){exit(1);}",
        "poly H0=subst(subst(subst(HH,a,0),e,0),h0,0);",
        "poly J0=subst(subst(subst(JJ,a,0),e,0),h0,0);",
        "poly P0r=resultant(MT,J0+c*H0,t);",
        "poly P0s=resultant(MT,J0+(u+c)*H0,t);",
        "ideal I0r=coeffs(P0r,u); ideal I0s=coeffs(P0s,u);",
        "ideal G0r=std(I0r); ideal G0s=std(I0s);",
        # Necessity under delta*b*p != 0: delta=b, then b=p, then w in GF(2).
        "if(reduce(delta*(delta+b),G0r)!=0){exit(2);}",
        "if(reduce(delta*b^2*p*(b+p),G0r)!=0){exit(3);}",
        "if(reduce(delta*b*p^2*(p*(w^2+w)+b+p),G0r)!=0){exit(4);}",
        "if(reduce(delta*(b*c+b^2+b*p+h1),G0r)!=0){exit(5);}",
        # No constant-s component exists on the genuine e=0 cofactor.
        "if(reduce(delta^2,G0s)!=0){exit(6);}",
        # Sufficiency of the two w fibers and c=h1/p when delta=b=p.
        "ideal C00=std(ideal(delta+p,b+p,w,b*c+h1));",
        "ideal C01=std(ideal(delta+p,b+p,w+1,b*c+h1));",
        "if(reduce(P0r,C00)!=0 || reduce(P0r,C01)!=0){exit(7);}",
        # The e=delta branch is the left/right mirror.
        "poly HA=p^2*theta+delta^2+delta*b;",
        "poly RA=subst(subst(R0,e,delta),h0,HA);",
        "poly LA=delta^2+t*b+delta*b+delta*p+h1; poly MA=RA/LA;",
        "if(MA*LA-RA!=0 || diff(MA,t)-b*(u^2+u*delta+delta^2)^2!=0){exit(8);}",
        "poly Hd=subst(subst(subst(HH,a,0),e,delta),h0,HA);",
        "poly Jd=subst(subst(subst(JJ,a,0),e,delta),h0,HA);",
        "poly Pdr=resultant(MA,Jd+c*Hd,t);",
        "poly Pds=resultant(MA,Jd+(u+c)*Hd,t);",
        "ideal Idr=coeffs(Pdr,u); ideal Ids=coeffs(Pds,u);",
        "ideal Gdr=std(Idr); ideal Gds=std(Ids);",
        "if(reduce(delta^2,Gdr)!=0){exit(9);}",
        "if(reduce(delta*(delta+b),Gds)!=0){exit(10);}",
        "if(reduce(delta*b^2*p*(b+p),Gds)!=0){exit(11);}",
        "if(reduce(delta*b*p^2*(p*(w^2+w)+b+p),Gds)!=0){exit(12);}",
        "if(reduce(delta*(b*c+b^2+h1),Gds)!=0){exit(13);}",
        "ideal Cd0=std(ideal(delta+p,b+p,w,b*c+b^2+h1));",
        "ideal Cd1=std(ideal(delta+p,b+p,w+1,b*c+b^2+h1));",
        "if(reduce(Pds,Cd0)!=0 || reduce(Pds,Cd1)!=0){exit(14);}",
        # Generic branch-3 lines: exact four constant-coordinate tests.
        "ring rf=(2,e,a,b,p,h1,c,delta,w,h0),(u,t),lp;",
        f"poly HH=subst(subst(imap(rp,HH),delta,p),w,0);",
        f"poly JJ=subst(subst(imap(rp,JJ),delta,p),w,0);",
        "poly N=a^2+a+1;",
        "poly T3=a*t^2+b*t+h1+e*b+e*N*(u+p+(a+1)*e);",
        "poly V3=T3+p*N*(u+a*p);",
        "poly RT=reduce(JJ+c*HH,std(ideal(T3)));",
        "poly ST=reduce(JJ+(u+c)*HH,std(ideal(T3)));",
        "poly RV=reduce(JJ+c*HH,std(ideal(V3)));",
        "poly SV=reduce(JJ+(u+c)*HH,std(ideal(V3)));",
        "if(e^2*N*lead(RT)-a^2*p*t^5!=0){exit(15);}",
        "if(e^3*N^2*lead(ST)-a^3*p*t^6!=0){exit(16);}",
        "if((e+p)^3*N^2*lead(RV)-a^3*p*t^6!=0){exit(17);}",
        "if((e+p)^2*N*lead(SV)-a^2*p*t^5!=0){exit(18);}",
        # On a=0 branch 3, L1 can collapse only in s and L2 only in r.
        "poly HZ=subst(subst(subst(HH,a,0),h0,e*(e+b+p)),delta,p);",
        "poly JZ=subst(subst(subst(JJ,a,0),h0,e*(e+b+p)),delta,p);",
        "poly L1=u*e+e^2+t*b+e*b+e*p+h1; poly L2=L1+u*p;",
        "poly R1=reduce(JZ+c*HZ,std(ideal(L1)));",
        "poly S1=reduce(JZ+(u+c)*HZ,std(ideal(L1)));",
        "poly R2=reduce(JZ+c*HZ,std(ideal(L2)));",
        "poly S2=reduce(JZ+(u+c)*HZ,std(ideal(L2)));",
        "if(e^2*lead(R1)-b^2*p*t^3!=0){exit(19);}",
        "if(e^3*lead(S1)-b^2*p*(e+b)*t^3!=0){exit(20);}",
        "if((e+p)^3*lead(R2)-b^2*p*(e+b+p)*t^3!=0){exit(21);}",
        "if((e+p)^2*lead(S2)-b^2*p*t^3!=0){exit(22);}",
        # Specialize coefficient parameters before returning to a fraction
        # field; Singular subst does not act on coefficient-field symbols.
        "setring rp;",
        "poly H1b=subst(subst(subst(subst(subst(HH,a,0),delta,p),w,0),h0,b*p),e,b);",
        "poly J1b=subst(subst(subst(subst(subst(JJ,a,0),delta,p),w,0),h0,b*p),e,b);",
        "poly H2b=subst(subst(subst(subst(subst(HH,a,0),delta,p),w,0),h0,0),e,b+p);",
        "poly J2b=subst(subst(subst(subst(subst(JJ,a,0),delta,p),w,0),h0,0),e,b+p);",
        "ring rs=(2,b,p,h1,c),(u,t),lp;",
        "poly H1=imap(rp,H1b); poly J1=imap(rp,J1b);",
        "poly K1=u*b+b^2+t*b+b^2+b*p+h1;",
        "poly S1b=reduce(J1+(u+c)*H1,std(ideal(K1)));",
        "poly W=b^2*t^2+b^2*p*t+b^2*p^2+b*p*h1+h1^2;",
        "if(b^3*S1b-p*(b*p+b*c+h1)*W!=0){exit(23);}",
        "poly H2=imap(rp,H2b); poly J2=imap(rp,J2b);",
        "poly K2=u*(b+p)+(b+p)^2+t*b+(b+p)*b+(b+p)*p+h1+u*p;",
        "poly R2b=reduce(J2+c*H2,std(ideal(K2)));",
        "if(b^3*R2b-p*(b*c+h1)*W!=0){exit(24);}",
        'print("C298 projection certificate passes");',
    ]
    output = run_singular(lines)
    assert output == "C298 projection certificate passes", output


def direct_terminal_star_check() -> dict[str, object]:
    """Independent GF(64) projective-incidence replay of both terminal stars."""
    context = build_context(1)
    field = context.ambient
    base = context.base_values
    add, mul = field.add, field.mul

    def total(*values: int) -> int:
        out = 0
        for value in values:
            out = add(out, value)
        return out

    def run(e: int, h0: int, expected_side: str, expected_constant: int):
        delta = b = p = 1
        w = h1 = 0
        f = add(e, delta)
        theta = total(mul(w, w), w, 1)
        k0 = total(mul(mul(p, p), theta), mul(delta, b), mul(delta, delta))
        k1 = total(mul(delta, p), mul(delta, b), mul(delta, delta))
        by_seed = {}
        for seed_name, seed_height in (
            ("alpha", context.alpha),
            ("beta", context.beta),
        ):
            g0, g1 = context.coordinates(seed_height)
            c0, c1 = add(h0, g0), add(h1, g1)
            d0, d1 = add(c0, k0), add(c1, k1)
            left = dict(zip(base, repair_points(context, e, 0, b, c0, c1)))
            right = dict(zip(base, repair_points(context, f, 0, b, d0, d1)))
            edges = set()
            for u, t, r in itertools.product(base, repeat=3):
                if u == 0:
                    continue
                s = add(r, u)
                seed = (t, seed_height)
                if line_key(context, left[r], right[s]) != line_key(
                    context, left[r], seed
                ):
                    continue
                if len({left[r], right[s], seed}) == 3:
                    edges.add((t, r, s))
            assert len(edges) == 7
            coordinate = 1 if expected_side == "r" else 2
            assert {edge[coordinate] for edge in edges} == {expected_constant}
            assert len({edge[0] for edge in edges}) == 7
            assert len({edge[3 - coordinate] for edge in edges}) == 7
            by_seed[seed_name] = len(edges)
        return by_seed

    return {
        "field": "PG(2,64) with GF(8) layer parameters",
        "e0_left_star": run(0, 0, "r", 0),
        "edelta_right_star": run(1, 1, "s", 1),
    }


def main() -> None:
    triple_degrees = universal_triple_degrees()
    ring, coefficients = pulled_quadratics()
    A, B, C, D, E, F = coefficients
    H = ring.add(ring.mul(D, B), ring.mul(A, E))
    J = ring.add(ring.mul(D, C), ring.mul(A, F))
    _, cover = trace_one_pullback()

    degree_table = {
        "cover": {"u": degree(cover, "u"), "t": degree(cover, "t")},
        "H": {"u": degree(H, "u"), "t": degree(H, "t")},
        "J": {"u": degree(J, "u"), "t": degree(J, "t")},
    }
    assert degree_table == {
        "cover": {"u": 6, "t": 4},
        "H": {"u": 2, "t": 0},
        "J": {"u": 3, "t": 2},
    }

    cover_a0 = restrict_zero(cover, "a")
    a2 = t_coefficient(cover_a0, 2)
    a1 = t_coefficient(cover_a0, 1)
    a0 = t_coefficient(cover_a0, 0)
    singular_projection_certificate(
        singular_poly(a2),
        singular_poly(a1),
        singular_poly(a0),
        sform(H),
        sform(J),
    )
    direct_stars = direct_terminal_star_check()

    # On a=b=0, r=t+K(u)/H and s=t+u+K(u)/H, so every univariate-u
    # collision component has degree-one maps to all three vertex classes.
    constant_height_shift = restrict_zero(
        restrict_zero(ring.add(J, ring.mul(ring.v["t"], H)), "a"), "b"
    )
    assert degree(constant_height_shift, "t") == 0
    assert degree(constant_height_shift, "u") == 3

    print(
        json.dumps(
            {
                "scope": "C210 ordered seed-left-repair-right-repair collision correspondence",
                "universal_equations": triple_degrees,
                "reconstruction_degrees": degree_table,
                "bezout_fiber_bound": 9,
                "constant_height": {
                    "identity": "J+t*H is t-free on a=b=0",
                    "vertex_maps_on_each_genuine_u_root_component": {
                        "t": 1,
                        "r": 1,
                        "r+u": 1,
                    },
                },
                "genuine_constant_vertex_components": [
                    {
                        "conditions": "a=0, delta=p, w in {0,1}, h0=e*(e+b+p), e=b",
                        "component": "L1=0",
                        "constant_map": "r+u=p+h1/b",
                    },
                    {
                        "conditions": "a=0, delta=p, w in {0,1}, h0=e*(e+b+p), e=b+p",
                        "component": "L2=0",
                        "constant_map": "r=h1/b",
                    },
                ],
                "terminal_projection_collapse_loci": [
                    {
                        "conditions": "a=0, e=0, delta=b=p, w in {0,1}, h0=0",
                        "component": "L2=p*(t+u)+h1=0",
                        "constant_map": "r=h1/p",
                        "star": "q-1 genuine edges in the oriented cover share one left-repair vertex",
                    },
                    {
                        "conditions": "a=0, e=delta=b=p, w in {0,1}, h0=p^2",
                        "component": "L1=p*(t+u+p)+h1=0",
                        "constant_map": "r+u=p+h1/p",
                        "star": "q-1 genuine edges in the oriented cover share one right-repair vertex",
                    },
                ],
                "matching_consequence": {
                    "outside_two_terminal_stars": "for M genuine points on one certified component, Delta<=9, nu>=ceil(M/25), tau>=ceil(M/9)",
                    "on_each_terminal_star": "nu=tau=1 for the oriented collision cover",
                },
                "duplicate_audit": "H!=0 gives one r=J/H; u=r+s and fixed layer colors make the ordered triple unique; repeated-point factors are excluded before counting",
                "independent_projective_replay": direct_stars,
                "trusted_boundary": "exact GF(2) sparse-polynomial reconstruction, Singular resultants/Groebner reduction over GF(2), and Bezout plus elementary hypergraph counting in the report",
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
