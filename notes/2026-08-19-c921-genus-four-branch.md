# C921 — the genus-four branch is closed negative

**Lane:** `cubic-threefolds` · **Date:** 2026-08-19 · **Task:** C921

## Result

For all but finitely many `b` in `B^circ`, the four-dimensional factor `A_b` of the
intermediate Jacobian of the nonstandard `A_5`-pencil is **not** the Jacobian of an
irreducible genus-four curve. The first of the two routes C921 inherited from C914 into
Voisin's codimension-at-most-three components is therefore closed negative, and the
pencil's membership in those components now rests on the second route alone: an
odd-degree isogeny from `J(X_b)` to the Jacobian of an irreducible genus-five curve.

A second, cheaper statement falls out of the same frame and is recorded below: the
genus-five route cannot be realized by an *isomorphism* of principally polarized abelian
varieties, only by an isogeny of degree greater than one, because genus-five curves with
a faithful `A_5`-action are rigid while the pencil is not isotrivial.

## Inputs taken from C914 and the epilogue

- `H_1(J(X_b), Q) = Lambda_Q tensor M_Q`, where `Lambda = Z^Omega / Z 1` is the six-axis
  lattice with the form `kappa` of matrix `6 I_6 - J_6`, and `M = H_1(E_b, Z)` for
  Hartlieb's elliptic factor. The `A_5`-action is on `Lambda` alone.
- At an axis `H` in `Omega` with class `v`, `kappa(v,v) = 5` is a unit at two, and the
  odd-degree splitting of C914 has `E'`-part `L cap (Qv tensor M_Q)` and four-dimensional
  part `A_b` supported on `v^perp`.
- `A_b` is isogenous to `E_b^4`, the family is non-isotrivial in coarse moduli, and `E_b`
  has no complex multiplication at the geometric generic point.

## The `D_5`-frame

Let `D_5` be the stabilizer of the axis `H` in `A_5`, of order ten. `A_5` is
two-transitive on the six axes, so `D_5` is transitive on the remaining five with
point stabilizer of order two, and

    Q^Omega = Q e_H  +  Q[D_5 / C_2] = 1 + (1 + V_1 + V_2),

with `V_1` and `V_2` the two two-dimensional irreducible representations of `D_5`.
Dividing by the all-ones vector leaves `Lambda_Q = 1 + V_1 + V_2`, whose trivial summand
is spanned by the `D_5`-fixed class `v`. Hence

    v^perp = V_1 + V_2   and   H^{1,0}(A_b) = V_1 + V_2,

since the Hodge structure is `Lambda tensor M` with `D_5` acting through `Lambda` only.
`D_5` fixes `v`, so it preserves both factors of the C914 splitting and their induced
polarizations, and acts faithfully on `A_b`.

## Step one: Torelli forces a curve with the same action

Suppose `A_b` is isomorphic as a principally polarized abelian variety to `J(C)` for an
irreducible genus-four curve `C`. By Torelli, `Aut(J(C), Theta)` is `Aut(C) x {±1}` for
`C` non-hyperelliptic and `Aut(C)` for `C` hyperelliptic. No element of `D_5` acts as
`-1` on `A_b`: reflections have trace zero on `V_1 + V_2` and elements of order five have
trace `-1`, while `-1` has trace `-4`. So `D_5` meets `{±1}` trivially and acts faithfully
on `C`, and the analytic representation on `H^0(C, Omega)` agrees with `V_1 + V_2` up to
tensoring by a character of `D_5`, which fixes both `V_i`.

## Step two: one branch datum, and no representation-theoretic obstruction

Riemann--Hurwitz for `C -> C/D_5` with `2g - 2 = 6` gives quotient genus zero and total
ramification `26`, with each branch point of stabilizer order `e` contributing
`10 - 10/e`. `D_5` has elements of orders one, two and five only, so the contributions are
`5` and `8`, and `5a + 8b = 26` forces `a = b = 2`: the branch datum is `(2,2,5,5)` over
the projective line, uniquely. Quotient genus one or more is impossible.

For such a cover, each reflection fixes two points and each element of order five fixes
four. The Eichler trace formula gives, for `s` of order five with tangent characters
`zeta^u, zeta^{-u}` over one branch point and `zeta^w, zeta^{-w}` over the other,

    tr(s | H^0(Omega)) = 1 + [zeta^u/(1 - zeta^u) + zeta^{-u}/(1 - zeta^{-u})] + [same for w]
                       = 1 - 1 - 1 = -1,

independently of the local data, since `zeta^a/(1 - zeta^a) + zeta^{-a}/(1 - zeta^{-a}) = -1`.
The three candidate analytic representations `V_1 + V_2`, `2V_1`, `2V_2` have traces `-1`,
`2 cos 72 degrees` doubled, and `2 cos 144 degrees` doubled, so the first is forced.

**So the representation of `D_5` on `H^0(C, Omega)` matches `A_b` exactly, for every
genus-four curve with a faithful `D_5`-action.** The cheapest attack — obstruct the
Jacobian by comparing characters — is dead, and dead for a reason, not by accident.

## Step three: the curves are explicit

`C -> C/C_5` is a cyclic quintic cover of a rational curve branched at the four points
lying under the order-five fixed points, and the reflection acts on that line with two
fixed points, which lie under the two branch points of order two. So the four branch
points form two orbits of size two, none of them fixed, and after normalizing the
involution to `x -> -x` the curve is

    C_{m,n,t}:  y^5 = (x-1)^m (x+1)^{5-m} (x-t)^n (x+t)^{5-n},   m, n in {1,2,3,4}.

The dihedral action is explicit: `sigma(x,y) = (x, zeta_5 y)` and
`iota(x,y) = (-x, (x^2-1)(x^2-t^2)/y)`, using
`f(x) f(-x) = [(x^2-1)(x^2-t^2)]^5`; then `iota^2 = 1` and
`iota sigma iota = sigma^{-1}`. Every exponent is prime to five, so the cover is
irreducible, and four branch points give genus `(5-1)(4-2)/2 = 4`.

Relabelling the points inside an orbit sends `(m,n)` to `(5-m,n)` or `(m,5-n)`; the
Moebius map `x -> t/x` swaps the orbits and sends `(m,n)` to `(n,m)`; replacing the deck
generator by another sends `(m,n)` to `(lambda m, lambda n)` for `lambda` a unit modulo
five. These identifications leave exactly **two** families, represented by
`(m,n) = (1,1)` and `(1,2)`, each with the single modulus `t`.

## Step four: the moduli count

The tangent space to the moduli of principally polarized fourfolds at `A_b` is
`Sym^2` of the analytic representation, and

    (Sym^2 V_1)^{D_5} = (Sym^2 V_2)^{D_5} = 1,   (V_1 tensor V_2)^{D_5} = 0,

so `D_5`-equivariant deformations form a **two**-dimensional space. Both the pencil-side
family `b -> A_b` and each curve-side family `t -> J(C_{m,n,t})` are one-dimensional
inside it. Two one-dimensional families in a surface either share a component or meet in
finitely many points.

If they shared a component, then, since every `A_b` is isogenous to `E_b^4`, a dense
subset of that curve family would consist of Jacobians isogenous to the fourth power of
an elliptic curve. Being isogenous to a power of an elliptic curve is a countable union
of closed conditions, so one of them would have to be the whole component: **every**
member of that family would be isogenous to a fourth power.

## Step five: the computation that refutes exactly that

For one member of each of the two families the Jacobian is not isogenous, over any
extension of any field, to a power of an elliptic curve.

Method. Count points of `C_{m,n,3}` over `F_{p^k}` for `k = 1..4`, assemble the
degree-eight Weil polynomial, take its squarefree part, and ask whether two distinct
Frobenius eigenvalues have a ratio that is a root of unity. If `J` were isogenous over
some `F_{q^r}` to the fourth power of an elliptic curve, the eigenvalues of the `r`-th
power of Frobenius would take only two values, so some ratio would be a root of unity.

The test needs no bound on `r`. Every Frobenius eigenvalue has absolute value `sqrt(q)`
under every complex embedding, so every ratio has all its conjugates on the unit circle,
and by Kronecker's theorem such a ratio is a root of unity exactly when it is an algebraic
integer. A ratio lies in the compositum of two fields of degree at most eight, so a root
of unity among the ratios has order `m` with `phi(m) <= 64`, hence `m <= 210`; and the
ratio has order dividing `m` exactly when the characteristic polynomial of the `m`-th
power of Frobenius acquires a repeated root. Testing every such `m` decides it.

Result, at `t = 3` and `p = 11` and `p = 31`, for both families: the Weil polynomial is
the square of an irreducible quartic, its four distinct eigenvalues stay distinct under
every `m <= 210`, and no extension makes the characteristic polynomial a fourth power.
Since the curves have good reduction at those primes and endomorphisms specialize, the
Jacobians in characteristic zero are not isogenous to a fourth power either.

That contradicts the alternative of step four, so the pencil-side and curve-side families
meet in at most finitely many points, which is the stated result.

## Evidence bundle

| artifact | bytes | sha256 |
|---|---|---|
| `2026-08-19-c921-d5-genus-four-jacobians.py` | 12498 | `3f7ef508af2eac8b6d9c69e42d4aef3fe667e59a95b00b9527d1ef121b1c2e99` |
| `2026-08-19-c921-d5-genus-four-jacobians.txt` | 3295 | `31fe73e2ead762d6b280032563e0418ed76c1a12ff4af1e4819448ad448fd906` |

Manifest: `notes/2026-08-19-c921-d5-genus-four-jacobians.sha256`.

Replay, from the repository root:

    uv run --with sympy --with mpmath python3 \
        notes/2026-08-19-c921-d5-genus-four-jacobians.py \
        > notes/2026-08-19-c921-d5-genus-four-jacobians.txt
    uv run --with sympy --with mpmath python3 \
        notes/2026-08-19-c921-d5-genus-four-jacobians.py --check \
        notes/2026-08-19-c921-d5-genus-four-jacobians.txt
    (cd notes && sha256sum -c 2026-08-19-c921-d5-genus-four-jacobians.sha256)

The `--check` mode regenerates in memory and compares against the tracked output without
touching the worktree; it reports OK for the committed pair.

Inputs and conventions: branch points `1, -1, t, -t` with `t = 3`; exponent vectors
`(m, 5-m, n, 5-n)` for `(m,n)` in `{(1,1), (1,2)}`; primes `11` and `31`, both congruent
to one modulo five and both leaving the four branch points distinct; finite fields built
from the lexicographically first monic irreducible polynomial of each degree; the fibre
over `x = infinity` contributing five points, the cover being unramified there.

Cross-checks, all reported in the certificate: `#C(F_p)` recomputed by a double loop over
the prime field independent of the field implementation; the Weil bound
`|#C(F_{p^k}) - p^k - 1| <= 8 p^{k/2}`; the functional equation of the Weil polynomial;
and every root having absolute value `sqrt(p)` to thirty digits, with deviation below
`4e-31`. No independent third-party implementation was used; a wrong point count would
have to preserve all four of those invariants simultaneously.

## What this does not prove

- It does not decide C921. The second route — `J(X_b)` odd-degree isogenous to the
  Jacobian of an irreducible genus-five curve, with no product decomposition — is
  untouched except for the rigidity remark below.
- It gives finiteness, not emptiness: finitely many pencil members may still have `A_b`
  a genus-four Jacobian, and the exceptional set is not computed.
- The computation certifies two curves at two primes. The structural steps carry the
  statement from those two curves to the two families.

## Extra juice from the same frame

**The genus-five route needs a genuine isogeny — but this was already classical.**
Clemens and Griffiths prove that the intermediate Jacobian of a smooth cubic threefold is
neither the Jacobian of a curve nor a product of Jacobians; that is the content of their
irrationality theorem. So `J(X_b)` is never isomorphic to a genus-five Jacobian, for every
member, and the second route was never open at the isomorphism level. The dihedral frame
above reproves a weaker form of this by rigidity — if `J(X_b)` were isomorphic to `J(C)`,
Torelli would give `C` a faithful `A_5`-action, Riemann--Hurwitz forces the unique branch
datum `(3,3,5)` over the line, three branch points leave no modulus, so such curves are
rigid and a non-isotrivial family can meet them only finitely often. Worth recording as a
consistency check on the frame, not as a new statement.

**Why every Weil polynomial came out a square.** Over the rationals `D_5` has one
four-dimensional irreducible representation, namely `V_1 + V_2` with character field
`Q(sqrt 5)`. So the rational isotypic decomposition of `J(C)` has a single
four-dimensional piece, and `J(C)` is isogenous to the square of an abelian surface with
real multiplication by `Q(sqrt 5)`. The square in the factorization is forced by
representation theory and carries no extra information — in particular it is *not*
evidence that the curve-side and pencil-side families agree, even though C914 records the
same `B^2` shape for `A_b` through van Geemen and Yamauchi.

## What the factor actually is, and where that leads

Write `Lambda = Z^Omega / Z 1` in the basis `f_i = e_i mod 1` for the five axes other than
`H`. Then `v = -(f_1 + ... + f_5)`, `kappa(f_i, v) = -1`, so

    v^perp = { x in Z^5 : sum x_i = 0 }  with  kappa(x,y) = 6 <x,y>,

which is **six times the `A_4` root lattice**, exactly. So the four-dimensional factor is

    A_b  isogenous to  E_b tensor_Z A_4,

with the polarization form `6 kappa_{A_4}` tensor the symplectic form of `H_1(E_b)`; the
principal polarization of C914 lives on a finite-index overlattice of `A_4 tensor M`.
`kappa(v,v) = 5` is the discriminant of `A_4`, as it must be.

This is a better handle than the moduli comparison used above, because it is uniform in
`b`. Three things follow that are worth queueing rather than closing here.

- The question "for which even lattices `L` is `E tensor L` a Jacobian" has a literature —
  Jacobians isogenous or isomorphic to powers of an elliptic curve, in the line of
  Ekedahl--Serre and of Kani's work on Jacobians isomorphic to products of elliptic curves.
  A hit for `L = A_4` would replace "all but finitely many `b`" with "every `b`", and would
  do it structurally.
- The two-dimensional moduli of `D_5`-fourfolds carrying `V_1 + V_2` is a Hilbert modular
  surface for `Q(sqrt 5)`. Our family is the locus of tensor-type points, a modular curve
  in it; the curve-side family is another curve in it. Their intersection number is the
  size of the exceptional set, and Hirzebruch--Zagier theory computes intersection numbers
  of exactly such cycles. That would locate, or at least bound, the finite set this report
  leaves unlocated.
- Deligne--Mostow describe the monodromy of cyclic quintic covers of the line branched at
  four points as an explicit lattice in `PU(1,1)`, for each exponent vector. Zariski
  density of that monodromy would give the generic endomorphism algebra directly, and would
  replace the point-count step of this report with a citation. The two exponent vectors
  needed are `(1,4,1,4)/5` and `(1,4,2,3)/5`.

## Mystery ledger

- **Why the two one-dimensional families are so close and still distinct.** Both live in
  the same two-dimensional moduli of `D_5`-fourfolds, both are isogenous to squares of
  real-multiplication surfaces, and both carry the identical analytic representation. What
  separates them is only whether that surface is isogenous to the square of an elliptic
  curve. Partly settled by the closeout pass above: the pencil side is the tensor locus
  `E_b tensor A_4` in a Hilbert modular surface for `Q(sqrt 5)`, which is a modular curve
  in it, so the separation is between two named cycles rather than between a family and a
  computation. Turning that into a proof still needs the generic endomorphism algebra of
  the curve side, which the point count supplies and Deligne--Mostow monodromy would
  supply better.
- **The exceptional finite set is unlocated.** The argument gives no bound on how many
  pencil members could have `A_b` a genus-four Jacobian, and no method to find them. The
  closeout pass names a route that did not exist when the result was proved — an
  intersection number of two cycles on a Hilbert modular surface, in the range of
  Hirzebruch--Zagier theory — but it has not been carried out. The same gap sits in C914's
  two finiteness propositions, so it is a pattern in this program rather than a defect of
  this step.
- **The genus-five route has no frame yet.** Torelli is unavailable once the comparison is
  an isogeny of degree greater than one, and nothing here replaces it. The natural next
  move is the lattice side: ask which odd-degree isogenies from a genus-five Jacobian are
  compatible with the exotic two-primary gluing kernel, the same instrument that decided
  the product routes in C914.
- No further mystery is claimed: the representation theory, the branch data, and the
  moduli counts are all forced, and each was checked twice.
