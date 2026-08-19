# C920 — removing the divisor-tagging hypothesis for minimal rational ruled centers

**Task:** C920 (`cubic-threefolds`).
**Date:** 2026-08-18.
**Manuscript:** `papers/cubic-stabilization-epilogue/`.
**Authority commits:** `ee4f72d44`, `eb9b34622`, `b4d416a62`, `17e2d2a6f`,
`2c030a8fc`, `b9ba88d26`.
**Card:** `cubic-threefolds-tasks/c920-minimal-ruled-tagging-removal.md`.

Hypothesis 5.7T, the divisor-tagging specialization invariance of the epilogue,
previously carried two of the center classes that weak factorization produces in
dimension four: the rational geometrically ruled surfaces and the nonminimal
ones.  It now carries only centers that are neither minimal nor geometrically
ruled.  `rem:tagging-scope`, the proof of `prop:low-dimensional-vanishing`, and
the hypothesis lines of `thm:nu6-birational-invariance`, `cor:v14-one-step` and
`thm:every-cubic-conditional` say so.

The scope is stated that way, rather than as "nonminimal", because `F_1` is a
geometrically ruled surface that is not minimal — it is the projective plane
blown up at a point — and it is covered by the new argument.  The cases now
proved directly exhaust the minimal surfaces: a minimal smooth projective
surface has nef canonical class, or is the projective plane, or is
geometrically ruled over a curve.

## The mathematics

### Reduction to index at most one

The specialized statement needs the small quantum cohomology of a Hirzebruch
surface `F_a` after an external Novikov specialization, and the toric quantum
Stanley--Reisner presentation is unavailable there: it is a theorem only for
Fano toric manifolds, and it fails for `F_a` with `a` at least two.  For `F_2`
the presentation would give `F * F = q_s (S * S)`, whose point component is
`-2 q_s`, while the first Chern number of every effective class is even, so no
three-point invariant can contribute a point component to `F * F`.  For `F_3`
the presented ring has rank five over the Novikov ring, not four.

The route taken instead is deformation, in a single step.  For `a` at least two
put `k = floor(a/2)`, so that `k` and `a - k` are both at least one; a general
pair of sections of `O(k)` and `O(a-k)` has no common zero and defines an
injection of `O` into `O(k) + O(a-k)` whose quotient is `O(a)` by degree.  The
extensions with class a multiple of that one extension class form a vector
bundle over the affine line, and its projectivization is a smooth projective
family whose zero fibre is `F_a` and whose every nonzero fibre is
`P(O(k) + O(a-k))`, isomorphic to `F_{a-2k}` after twisting by `O(-k)`.

Iterating the naive `a` to `a-2` step is *not* correct: for `a` at least four
the general nonzero extension of `O(a)` by `O` has middle term `O(j) + O(a-j)`
with `j` the integer part of `a/2`, not `O(1) + O(a-1)`, so the general fibre of
the universal family is `F_{a-2k}` rather than `F_{a-2}`.  The single-step
family above avoids the question by landing where it is wanted in one move.

Genus-zero Gromov--Witten invariants are invariants of a deformation class, and
a smooth projective family carries a smooth family of Kaehler forms while every
symplectic four-manifold is semipositive, so the invariance applies.  The
ruling is global over the base, so the parallel transport fixes the fibre class;
writing its value on `s` as `alpha s_0 + beta f`, pairing with `f` gives
`alpha = 1` and the self-intersection gives `beta = -k`.  Hence
`f` goes to `f`, `s + k f` goes to the negative section `s_0` of `F_{a-2k}`, and
the divisor class `S + k F`, of self-intersection `-a + 2k`, goes to the
negative section as a divisor.

So only two base cases are needed, and both are Fano: `F_0` through the
Gromov--Witten product formula, and `F_1` through the toric presentation, which
the report also verifies directly from the genus-zero invariants of the del
Pezzo surface.

### Truncation

The transported theory determines the small quantum product of `F_a` itself, and
only three Novikov monomials survive.  A three-point invariant with two divisor
insertions vanishes unless the first Chern number of the class lies between one
and two, and by deformation invariance it vanishes unless the transported class
is effective, that is unless `m >= n k` for `beta = m f + n s`.  Since

    c_1 . beta = 2(m - nk) + 2n   for a = 2k,
    c_1 . beta = 2(m - nk) + n    for a = 2k+1,

the bound forces `n <= 1` in the even case and `n <= 2` in the odd one, and then
`m = nk` except for `beta = f`.  The surviving classes are `f` and `s + kf` for
`a` even, and `f`, `s + kf` and `2(s + kf)` for `a` odd.  So the product carries
no infinite Novikov sum — which is exactly what fails for the toric presentation
— and the two monomials for `f` and `s + kf` generate every coefficient that
occurs.

### The two Euler quartics

Writing `u` for the specialized value of the fibre class and `w` for that of
`s + k f`, the specialized ring is `A[S♭, F]` modulo `(S♭² - u, F² - w)` for `a`
even and modulo `(S♭² + S♭F - u, F² - w S♭)` for `a` odd, with Euler class
`2 S♭ + 2 F` and `2 S♭ + 3 F` respectively.  The characteristic polynomial of
Euler multiplication on the rank-four even cohomology is

    a even:  X^4 - 8(u + w) X^2 + 16(u - w)^2
    a odd:   X^4 + w X^3 - 8u X^2 - 36uw X + 16u^2 - 27u w^2

with discriminants `2^24 u^2 w^2 (u - w)^2` and
`-u^2 w^2 (256u + 27w^2)^3`.

Strict Novikov admissibility keeps `u` and `w` nonzero, so the whole degeneracy
question is one equation: `u = w` in the even case, `256u + 27w^2 = 0` in the
odd one.

### Why the centers never degenerate

The valuation law `v(chi(Q^d)) = l(d)` with `l` positive on nonzero effective
classes settles every index of at least two.  There `v(u) = l(f)` and
`v(w) = l(s) + k l(f)` with `k` at least one, so `v(w) > v(u)`; the even locus
needs `u = w` and the odd locus needs `v(u) = v(w^2)`, and both are excluded.

Index one is the exception, because there `k = 0` and the two lengths may agree.
The center specializations of the blowup comparison are graded-monomial: their
associated graded is a Laurent monoid ring and `chi_j(Q_C^d) = Q^{i_* d}
u^{rho_C . d}` is one of its monomials, with coefficient one.  A vanishing
`256u + 27w^2` at equal valuations would give
`256 gr(u) + 27 gr(w)^2 = 0` between two monomials of a basis; distinct
monomials are linearly independent and equal ones would need `256 + 27 = 0`.
The manuscript records the condition as `def:monomial-specialization`, verifies
it for the center maps in `lem:center-maps-monomial`, and
`prop:low-dimensional-vanishing` now asks for it, but only when the target is
`F_1`.  The condition is called *graded-monomial* because Definition 5.5 already
uses "monomial map" for a different property, of the source rather than the
target.

Index zero needs neither argument.  The Gromov--Witten product formula makes the
specialized module of `P^1 x P^1` the tensor product of the two specialized
projective-line modules, because every entry of the connection matrix lies in
the Novikov ring of the product and applying the specialization entrywise
commutes with the identification.  Each factor has simple Euler spectrum by
nonvanishing of its own specialized value alone, so both framed operators are
trivial and so is their tensor product.  This is the route that covers the
specializations identifying the two rulings, which the quartic route cannot: for
`F_0` the collision `u = w` is genuinely reachable.

### The collision trichotomy

For completeness the degenerate spectra are described rather than assumed away.
On `u = w` the even quartic is `X^2 (X^2 - 16u)`; on `256u + 27w^2 = 0`, written
with `w = 16s` so that `u = -27 s^2`, the odd quartic is
`(X + 18s)^2 (X^2 - 20 s X + 612 s^2)`, whose quadratic factor has roots
`10s ± 16e` with `e^2 = -2 s^2`.  In both cases exactly one root is double and
the other two are simple and distinct from it, so a degenerate specialization has
one spectral block of rank two and two of rank one, and no block of rank three or
four.  A rank-two block over an algebraically closed field has trace twice and
determinant the square of its eigenvalue, so Cayley--Hamilton makes its centred
matrix square to zero.

## Lean

Four new modules in the paper-bundled package, all built through the guarded
queue.

`Quantum/QuarticSpectralSeparation.lean` proves the general separation step: a
monic complex quartic splits, its coefficients are the signed elementary
symmetric functions of the four roots, the universal quartic discriminant is
therefore the squared product of the pairwise root differences, and a nonzero
discriminant makes every root multiplicity at most one, hence every maximal
generalized eigenspace of a matrix with that characteristic polynomial a line.
It also proves the complementary bound used for degenerate specializations: a
squared linear factor times a quadratic whose roots differ from the repeated one
has every multiplicity at most two, and the repeated root has multiplicity
exactly two.

`Quantum/HirzebruchEulerSpectrum.lean` evaluates the discriminant on the two
displayed quartics, derives the two degeneracy criteria for nonzero specialized
values, exhibits the even splitting and both degenerate splittings, proves that
the parametrization of the odd locus is surjective, composes each degenerate
splitting with the distinctness of its two remaining roots to give root
multiplicities two, one and one, carries that to maximal generalized eigenspaces
of dimension at most two with the one at the repeated root of dimension exactly
two, and proves that a rank-two block has square-zero nilpotent part.

`Quantum/MonomialSpecializationSeparation.lean` derives inside the algebraic core
of strict Novikov admissibility that lengths are additive and scale, that units
and negation leave a valuation unchanged, and hence the two valuation
exclusions; and separately that a combination of two members of a linearly
independent family with coefficients `256` and `27` cannot vanish.

`Applications/HirzebruchSpecializedVanishing.lean` assembles the vanishing
statements: the quadric surface through the product route and the two parities
through the discriminant route.

Twenty-two reviewer terminals were added, all reporting `propext,
Classical.choice, Quot.sound`.  Coverage moved from 50 claims — 5 absent, 23
fragmentary, 21 conditional, 1 complete over 241 terminals — to 56 claims — 6
absent, 25 fragmentary, 24 conditional, 1 complete over 263 terminals.  The one
new absent row is `lem:center-maps-monomial`, the verification that the center
specializations are graded-monomial, which has no formal counterpart because the
package builds no associated graded ring.

### Scope

Lean constructs no variety, no quantum cohomology, no Novikov specialization, no
Euler multiplication and no Levelt--Turrittin decomposition.  The two quartics
enter as displayed polynomials; the deformation reduction and the toric
presentation are not formalized.  The Gromov--Witten product formula, the tensor
compatibility of the formal decomposition, and the conclusion of the
multiplicity-one Euler block lemma are typed premises, as is the additivity of
the leading-term map on two summands of equal valuation.

## Evidence bundle

`verification/hirzebruch_euler_spectrum.py` builds the multiplication matrix,
the characteristic polynomial, the discriminant, the factorization on the
degeneracy locus and the eigenspace dimension at the repeated root, and writes
the canonical certificate `verification/hirzebruch-euler-spectrum.json` with the
manifest `verification/hirzebruch-euler-spectrum.sha256`.

Replay, from the paper directory:

```text
uv run --with sympy python3 verification/hirzebruch_euler_spectrum.py
uv run --with sympy python3 verification/hirzebruch_euler_spectrum.py --check
```

The `--check` form regenerates in memory, compares with the tracked certificate
and the tracked digests, and leaves the worktree unchanged.  The generator fails
loudly if any recorded check is negative.

The recorded cross-checks are: the presentation degenerates at the origin to the
classical cohomology ring of `F_a` for every index from zero to twelve; the
presentation and the quartic are homogeneous for the Novikov grading; the
characteristic polynomial agrees with the one obtained by eliminating the two
divisor generators from the ideal; the discriminant agrees with the squared
product of the pairwise root differences of an explicit splitting in the even
case and with a resultant against the parametrizing quartic in the odd case;
Euler multiplication is self-adjoint for the trace form; the presentation for
`F_2` agrees with the relations computed directly from the genus-zero
invariants; and the degenerate spectrum has multiplicities one, one, two with a
two-dimensional eigenspace at the repeated root.

The bundle establishes the quartics, their discriminants and the degenerate
block structure *for the presented ring*.  It does not establish that the
presented ring is the small quantum cohomology of the surface; that is the
deformation reduction, argued in the manuscript and not computational.

## Referee passes

Three cold reads were run against the diff and then repeated against the
repaired diff: one on the mathematics
(`2026-08-18-c920-referee-mathematics.md`), one on exposition and internal
consistency (`2026-08-18-c920-referee-prose.md`), and one on the referee-facing
Lean prose and the evidence generator
(`2026-08-18-c920-referee-lean-prose.md`).

The mathematics pass verified both quartics, both discriminants, both degenerate
factorizations and the `F_1` invariant computation independently, and found
three defects that are now repaired: the iterated deformation family was false
for index at least four, the truncation of the quantum product was asserted
without proof, and the intrinsic vanishing of the minimal model had been deleted
while the surviving branch still used it.  It also found the terminology
collision that renamed the class.

The Lean pass found one docstring asserting the converse of its own structure
field, one module header claiming a coverage the module does not have, and a
real gap: the degenerate splittings and the multiplicity bounds were separate
statements, never composed, so the manuscript's degenerate case was not
formalized.  That gap was closed by proving the composition rather than by
weakening the prose.

## Validation

- Guarded builds of the four new modules, the reviewer interface, and the axiom
  audit.
- `make check`: lint, source-only formal check, deterministic manuscript build,
  warning rejection.  The document is warning-free at 52 pages.
- Axiom-log check against the captured audit output over 260 terminals.
- Evidence bundle `--check` replay.

## Mystery ledger

- **Settled by this pass.** The toric quantum Stanley--Reisner presentation
  cannot be used for a Hirzebruch surface of index at least two.  The card's
  strand one asked for exactly that derivation; it would have produced a false
  ring.  The failure is visible two ways, through the point component of `F * F`
  for index two and through the rank of the presented ring for index three, and
  the deformation reduction replaces it.
- **Settled by this pass.** The quadric surface cannot be handled by the
  discriminant route, because its degeneracy locus `u = w` is reachable by a
  center specialization: the two rulings can have the same monomial image.  The
  product formula, which needs no relation between the two values, is not merely
  a convenience there but the only available route.
- **Settled by this pass, and asymmetric.** The valuation law alone settles every
  index of at least two; index one needs the finer monomial structure of the
  center specialization, and index zero needs neither.  The asymmetry comes from
  the shift `k = floor(a/2)`, which separates the two valuations exactly when it
  is positive.
- **Open, and the reason the hypothesis survives.** Nonminimal surfaces.  Every
  such surface is an iterated point blowup, and carrying the intrinsic blowup
  formula past the external center specialization needs the support or
  base-change statement `rem:tagging-scope` names as missing.  Its even
  cohomology also has rank four plus the number of blowups, so the quartic
  discriminant does not apply.  Evidence gap: no statement about the support of
  Iritani's blowup comparison after coefficient specialization.  Owner: a
  successor task.
- **Open.** The degenerate specializations are described but not concluded.  If
  a rank-two Euler block did occur, the package could say its nilpotent part is
  square-zero but not that the block contributes nothing to the primitive-sixth
  count; the multiplicity-one Euler block lemma covers rank one only.  This is
  invisible in the present proof because no center specialization degenerates,
  and it would become load-bearing only for a specialization outside the ones
  weak factorization produces.  Evidence gap: no rank-two analogue of
  `lem:simple-euler-block`.  Owner: whichever successor needs the specialized
  statement for an arbitrary strictly admissible map.
- **Settled by this pass, and structurally pleasant.** The odd degeneracy factor
  is not an artefact of the eigenvalue map.  The four points of the specialized
  spectrum are parametrized by the roots of `t^4 + w t^3 - u w^2`, through
  `S♭ = t^2 / w` and eigenvalue `2 t^2 / w + 3 t`, and that parametrizing quartic
  has discriminant `-u^2 w^6 (256u + 27w^2)`.  The Euler spectrum therefore
  degenerates exactly when the spectral cover does, and not because the two-to-one
  eigenvalue map identifies two distinct points.  The positivity of `256` and `27`
  is what the leading-term argument consumes; nothing weaker about them would do.
