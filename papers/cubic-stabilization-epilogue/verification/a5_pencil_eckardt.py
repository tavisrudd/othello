#!/usr/bin/env python3
"""Eckardt points on the nonstandard A_5-cubic pencil, in two models.

Rational model.  A_5 = PSL(2,5) acts on the six points of P^1(F_5); on the
sum-zero subspace of Q^6 that permutation module is the five-dimensional
irreducible module W_5.  The A_5-invariant cubics there are spanned by the
power sum p_3 = sum x_i^3 and by the sum T_1 of one of the two A_5-orbits of
ten squarefree monomials x_i x_j x_k, so the pencil is

    F_{a,b} = a * p_3 + b * T_1   restricted to   x_1 + ... + x_6 = 0,

and the member (a, b) = (1, 0) is the Segre cubic threefold.

Monomial model.  W_5 = Ind_{A_4}^{A_5}(chi) for a nontrivial cubic character
chi of a point stabilizer, realized by monomial matrices with cube-root
entries.  The invariant cubics are spanned by the Fermat form and by a second
form with cube-root coefficients.  This model is an independent construction
of the same pencil and contains the Fermat member explicitly.

Eckardt criterion.  A point p of a smooth cubic threefold X = {F = 0} is an
Eckardt point -- the tangent hyperplane section is a cone with vertex p --
exactly when the Hessian of F at p has rank at most two.  In coordinates with
p = [1:0:0:0:0] and F = x_0^2 L + x_0 Q + C, the Hessian at p is
[[0, 2L], [2L^t, 2Q]]; the cone condition is that Q vanishes on {L = 0}; and
for a smooth X the form L is nonzero, so the two conditions agree.  The
Singular tests below therefore compute the dimension of the affine cone cut
out by F together with the three-by-three minors of the Hessian: cone
dimension 0 means the projective Eckardt scheme is empty.

Replay, from the paper directory:
    python3 verification/a5_pencil_eckardt.py \
        --report verification/a5-pencil-models.txt --sing /tmp/a5-pencil.sing
    nix shell nixpkgs#singular --command Singular -q /tmp/a5-pencil.sing \
        > verification/a5-pencil-eckardt.txt
    python3 verification/a5_pencil_eckardt.py --check verification/a5-pencil-models.txt

The first command records the model checks and writes the Singular input, the
second records the Eckardt and smoothness computation, and the third recomputes
the model checks and compares them with the tracked file.  Only the second
needs Singular 4.4.1; the others need the standard library alone.
"""

from itertools import combinations, combinations_with_replacement, permutations, product
import sys

# ------------------------------------------- A_5 on the six points of P^1(F_5)


def _act(mat, z):
    a, b, c, d = mat
    if z == 5:
        num, den = a, c
    else:
        num, den = (a * z + b) % 5, (c * z + d) % 5
    if den % 5 == 0:
        return 5
    return (num * pow(den, 3, 5)) % 5


def _perm(mat):
    return tuple(_act(mat, z) for z in range(6))


def _mul6(p, q):
    return tuple(p[q[i]] for i in range(6))


def a5_on_six_points():
    gens = [_perm((1, 1, 0, 1)), _perm((0, 4, 1, 0))]
    grp = {tuple(range(6))}
    frontier = [tuple(range(6))]
    while frontier:
        p = frontier.pop()
        for g in gens:
            r = _mul6(g, p)
            if r not in grp:
                grp.add(r)
                frontier.append(r)
    return sorted(grp)


A5_SIX = a5_on_six_points()
assert len(A5_SIX) == 60

ORBITS = []
_seen = set()
for t in [frozenset(t) for t in combinations(range(6), 3)]:
    if t in _seen:
        continue
    orb = {t}
    frontier = [t]
    while frontier:
        u = frontier.pop()
        for g in A5_SIX:
            v = frozenset(g[i] for i in u)
            if v not in orb:
                orb.add(v)
                frontier.append(v)
    _seen |= orb
    ORBITS.append(sorted(tuple(sorted(o)) for o in orb))
assert [len(o) for o in ORBITS] == [10, 10]
ORB1 = ORBITS[0]


def invariant_cubic_dimension():
    """dim (Sym^3 W_5)^{A_5}, from the permutation module on six points."""
    def sym_trace(g, k):
        total = 0
        for expo in product(range(k + 1), repeat=6):
            if sum(expo) == k and all(expo[i] == expo[g[i]] for i in range(6)):
                total += 1
        return total
    s3 = sum(sym_trace(g, 3) for g in A5_SIX)
    s2 = sum(sym_trace(g, 2) for g in A5_SIX)
    return (s3 - s2) // len(A5_SIX)


def rational_model_checks():
    for g in A5_SIX:
        assert sorted(tuple(sorted(g[i] for i in t)) for t in ORB1) == sorted(ORB1)
    swap = (1, 0, 2, 3, 4, 5)
    not_s6 = sorted(tuple(sorted(swap[i] for i in t)) for t in ORB1) != sorted(ORB1)
    return not_s6


# ---------------------------------------------- the monomial model of W_5

LET = [1, 2, 3, 4, 5]


def sign(p):
    s = 1
    p = list(p)
    for i in range(len(p)):
        for j in range(i + 1, len(p)):
            if p[i] > p[j]:
                s = -s
    return s


A5_FIVE = [{i + 1: p[i] for i in range(5)} for p in permutations(LET) if sign(p) == 1]
IDENT = {i: i for i in LET}


def mul(g, h):
    return {i: g[h[i]] for i in LET}


def inv(g):
    return {v: k for k, v in g.items()}


CYC = {1: 2, 2: 3, 3: 4, 4: 5, 5: 1}


def power(g, n):
    r = IDENT
    for _ in range(n):
        r = mul(r, g)
    return r


REP = {i: power(CYC, i % 5) for i in LET}
V4 = [IDENT,
      {1: 2, 2: 1, 3: 4, 4: 3, 5: 5},
      {1: 3, 2: 4, 3: 1, 4: 2, 5: 5},
      {1: 4, 2: 3, 3: 2, 4: 1, 5: 5}]
T3 = {1: 2, 2: 3, 3: 1, 4: 4, 5: 5}


def chi(h):
    for k in range(3):
        tk = power(T3, k)
        for v in V4:
            if mul(tk, v) == h:
                return k
    raise ValueError("not in the point stabilizer")


def mono_matrix(g):
    """columns of Ind(chi): y_i -> omega^k y_{g(i)}."""
    cols = {}
    for i in LET:
        j = g[i]
        cols[i] = (j, chi(mul(inv(REP[j]), mul(g, REP[i]))))
    return cols


def act_on_monomial(g, m):
    cols = mono_matrix(g)
    k = 0
    img = []
    for i in m:
        j, e = cols[i]
        k = (k + e) % 3
        img.append(j)
    return tuple(sorted(img)), k


def monomial_invariants():
    """the two invariant cubics, as {monomial: exponent of omega}."""
    gens = [CYC, {1: 2, 2: 1, 3: 4, 4: 3, 5: 5}]
    seen = set()
    out = []
    for m in combinations_with_replacement(LET, 3):
        if m in seen:
            continue
        lab = {m: 0}
        stack = [m]
        good = True
        while stack:
            cur = stack.pop()
            for g in gens:
                img, k = act_on_monomial(g, cur)
                want = (lab[cur] + k) % 3
                if img in lab:
                    if lab[img] != want:
                        good = False
                else:
                    lab[img] = want
                    stack.append(img)
        seen |= set(lab)
        if good:
            out.append(lab)
    return out


def check_monomial_invariance(lab):
    """the cubic sum_m omega^{lab(m)} m is fixed by every element of A_5."""
    for g in A5_FIVE:
        img = {}
        for m, k in lab.items():
            j, e = act_on_monomial(g, m)
            img[j] = (k + e) % 3
        if set(img) != set(lab) or any(img[m] != lab[m] for m in lab):
            return False
    return True


# ------------------------------------------------------------ Singular output

SUB = "(-(x1+x2+x3+x4+x5))"
VARS = ["x1", "x2", "x3", "x4", "x5", "x6"]
OMEGA_POWER = {0: "1", 1: "w", 2: "(-1-w)"}


def poly_p3():
    return "+".join("%s^3" % v for v in VARS).replace("x6", SUB)


def poly_T1():
    return "+".join("*".join(VARS[i] for i in t) for t in ORB1).replace("x6", SUB)


def poly_monomial(lab):
    return "+".join("%s*%s" % (OMEGA_POWER[k], "*".join("x%d" % i for i in m))
                    for m, k in sorted(lab.items()))


PROC = '''proc report(string name, poly F)
{
  ideal J = jacob(F);
  int dJ = dim(std(J));
  matrix H = jacob(jacob(F));
  ideal E = F, minor(H,3);
  ideal sE = std(E);
  int dE = dim(sE);
  int degE = 0;
  if (dE > 0) { degE = mult(sE); }
  name + ": jacobian-cone-dim " + string(dJ)
       + " eckardt-cone-dim " + string(dE)
       + " eckardt-cone-degree " + string(degE);
}
'''


def singular_input(invs):
    fermat = [lab for lab in invs if all(len(set(m)) == 1 for m in lab)][0]
    other = [lab for lab in invs if lab is not fermat][0]
    lines = ["ring r = 0,(x1,x2,x3,x4,x5),dp;",
             "poly p3 = %s;" % poly_p3(),
             "poly T1 = %s;" % poly_T1(),
             PROC,
             '"--- rational model: the pencil a*p3 + b*T1 on the sum-zero space";',
             'report("pencil(1,0)=Segre", p3);',
             'report("pencil(1,1)", p3 + T1);',
             'report("pencil(1,2)", p3 + 2*T1);',
             'report("pencil(1,3)", p3 + 3*T1);',
             'report("pencil(2,1)", 2*p3 + T1);',
             'report("pencil(0,1)", T1);',
             '"--- controls: Fermat and two Yang-Yu-Zhu members";',
             'report("fermat", x1^3+x2^3+x3^3+x4^3+x5^3);',
             'report("yyz(1,1,1,1,1,1,1)", x1^2*x3 + x2^3 + x1*x3^2 + x4^2*x5'
             ' + x4*x5^2 + x1*x2*x3 + x2*x4*x5);',
             'report("yyz(1,2,3,4,5,0,0)", x1^2*x3 + 2*x2^3 + 3*x1*x3^2'
             ' + 4*x4^2*x5 + 5*x4*x5^2);',
             "kill r;",
             "ring r2 = (0,w),(x1,x2,x3,x4,x5),dp;",
             "minpoly = w^2+w+1;",
             "poly F1 = %s;" % poly_monomial(fermat),
             "poly F2 = %s;" % poly_monomial(other),
             '"--- monomial model: the pencil a*F1 + b*F2";',
             'report("mono(1,0)=fermat", F1);',
             'report("mono(0,1)", F2);',
             'report("mono(1,1)", F1 + F2);',
             'report("mono(1,2)", F1 + 2*F2);',
             'report("mono(1,-3)", F1 - 3*F2);',
             "quit;"]
    return "\n".join(lines) + "\n"


def main():
    invs = monomial_invariants()
    lines = [
        "group order (six-point model): %d" % len(A5_SIX),
        "triple orbit sizes: %s" % [len(o) for o in ORBITS],
        "dimension of the invariant cubics: %d" % invariant_cubic_dimension(),
        "T_1 is A_5-invariant and not S_6-invariant: %s" % rational_model_checks(),
        "orbit used for T_1: %s" % (ORB1,),
        "monomial-model invariant directions: %d" % len(invs),
        "each monomial-model invariant is fixed by all of A_5: %s"
        % all(check_monomial_invariance(lab) for lab in invs),
        "the Fermat form is one of them: %s"
        % any(all(len(set(m)) == 1 for m in lab) for lab in invs),
    ]
    report = "\n".join(lines) + "\n"

    if "--check" in sys.argv:
        path = sys.argv[sys.argv.index("--check") + 1]
        with open(path) as fh:
            recorded = fh.read()
        if recorded != report:
            sys.stderr.write("model checks differ from %s\n" % path)
            return 1
        print("model checks agree with", path)
        return 0

    if "--report" in sys.argv:
        path = sys.argv[sys.argv.index("--report") + 1]
        with open(path, "w") as fh:
            fh.write(report)
        print("model checks written to", path)
    else:
        sys.stdout.write(report)

    if "--sing" in sys.argv:
        path = sys.argv[sys.argv.index("--sing") + 1]
        with open(path, "w") as fh:
            fh.write(singular_input(invs))
        print("singular input written to", path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
