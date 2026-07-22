#!/usr/bin/env python3
"""Independent finite residue replay for C457; imports no primary code."""

import json
from pathlib import Path


def mul(x, y, p):
    a, b, c, d = x
    e, f, g, h = y
    return ((a*e+b*g)%p, (a*f+b*h)%p, (c*e+d*g)%p, (c*f+d*h)%p)


def add(xs, p):
    return tuple(sum(x[i] for x in xs) % p for i in range(4))


def scale(a, x, p):
    return tuple(a*y % p for y in x)


def qmat(q, I, J, p):
    one = (1, 0, 0, 1)
    K = mul(I, J, p)
    return add([scale(q[0], one, p), scale(q[1], I, p), scale(q[2], J, p), scale(q[3], K, p)], p)


def closure(gens, p):
    one = (1, 0, 0, 1)
    seen, todo = {one}, [one]
    while todo:
        x = todo.pop()
        for g in gens:
            y = mul(x, g, p)
            if y not in seen:
                seen.add(y)
                todo.append(y)
    return seen


def norm(g, p):
    z = next(x for x in g if x)
    z = pow(z, -1, p)
    return tuple(x*z % p for x in g)


def inverse(g, p):
    a, b, c, d = g
    z = pow((a*d-b*c) % p, -1, p)
    return (d*z%p, -b*z%p, -c*z%p, a*z%p)


def conjugate(group, c, p):
    ci = inverse(c, p)
    return {norm(mul(mul(c, g, p), ci, p), p) for g in group}


def point(g, x, p):
    a, b, c, d = g
    if x == p:
        return p if c == 0 else a*pow(c, -1, p) % p
    den = (c*x+d) % p
    return p if den == 0 else (a*x+b)*pow(den, -1, p) % p


def matching(g, pairs, p):
    return tuple(sorted(tuple(sorted((point(g, a, p), point(g, b, p)))) for a, b in pairs))


def pgl(p):
    return {
        norm((a,b,c,d), p)
        for a in range(p) for b in range(p) for c in range(p) for d in range(p)
        if (a*d-b*c) % p
    }


def check_case(p, I, J, gens, comparison, target, spin_order):
    spin = closure(tuple(qmat(g, I, J, p) for g in gens), p)
    projective = {norm(g, p) for g in spin}
    compared = conjugate(projective, comparison, p)
    target = tuple(sorted(tuple(sorted(edge)) for edge in target))
    stabilizer = {g for g in pgl(p) if matching(g, target, p) == target}
    assert len(spin) == spin_order
    assert compared == stabilizer
    return len(spin), len(projective), len(stabilizer)


def main():
    inv2_11 = 6
    I11, J11 = (0,1,10,0), (1,3,3,10)
    base = ((0,1),(2,5),(3,7),(4,9),(6,8),(10,11))
    mate = ((0,10),(1,11),(2,7),(3,5),(4,8),(6,9))
    h3 = []
    for phi, comparison, target in ((8,(0,1,2,1),base),(4,(0,1,2,5),mate)):
        H = (inv2_11,)*4
        G = ((1-phi)*inv2_11%11, phi*inv2_11%11, 0, inv2_11)
        h3.append(check_case(11, I11, J11, (H,G), comparison, target, 120))

    inv2_7 = 4
    b3 = []
    for s, target in (
        (3,((0,7),(1,3),(2,6),(4,5))),
        (4,((0,7),(1,5),(2,3),(4,6))),
    ):
        I, J = (0,1,6,0), (2,s,s,5)
        R = (pow(s,-1,7),pow(s,-1,7),0,0)
        H = (inv2_7,)*4
        b3.append(check_case(7, I, J, (R,H), (1,s,0,1), target, 48))

    certificate = json.loads(Path(__file__).with_name("2026-07-21-c457-quaternion-order-reduction.json").read_text())
    assert h3 == [(120,60,60),(120,60,60)]
    assert b3 == [(48,24,24),(48,24,24)]
    assert certificate["icosian_order"]["reduced_trace_discriminant"] == [1,0]
    assert certificate["binary_octahedral_order"]["reduced_trace_discriminant"] == [1,0]
    print("C457 independent residue replay: OK")


if __name__ == "__main__":
    main()
