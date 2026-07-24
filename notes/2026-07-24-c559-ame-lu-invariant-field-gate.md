# C559 — fixed-copy LU contractions do not generate the pencil coordinate

**Lane:** `ame-lu`

**Date:** 2026-07-24

**Status:** complete; exact negative gate with a stronger all-fixed-copy
replacement

## Result

The proposed four-copy invariant-field route does not work.  On an
equal-phase state supported by a linear code, every permutation-contraction
local-unitary invariant is a power of the field order determined by the rank
of one homogeneous linear system.  Consequently its value is constant on the
generic rank stratum of any algebraic code family.  Party-orbit sums remain
constant there.

For the admitted six-point pencil, the field generated inside
`\(\mathbb Q(t)\)` by the generic values of all degree-`(4,4)`
party-symmetrized permutation contractions is therefore the constant field
`\(\mathbb Q\)`, not `\(\mathbb Q(z)\)`.  If the field order is retained as a
formal parameter, replace `\(\mathbb Q\)` by `\(\mathbb Q(q)\)`; the conclusion
is unchanged because no `\(t\)` remains.

This is not a counterexample to restricted LU/LC orbit coincidence.  It
closes only the proposed invariant-field proof.  C560 must use genuine
local-unitary rigidity—most plausibly simultaneous-flattening/support
recovery or exact finite-component classification—not another fixed-copy
rank-divisor calculation.

## The contraction-rank lemma

Let `\(C\leq\mathbb F_q^n\)` be a linear `[n,k]` code with full-rank generator
matrix `\(G\)`, and put

```text
|Psi_C> = q^(-k/2) sum_(x in C) |x>.
```

Fix a copy number `\(m\)`.  A permutation contraction is specified by
`\(\boldsymbol\sigma=(\sigma_1,\ldots,\sigma_n)\in S_m^n\)`: at party `\(i\)`,
ket copy `\(a\)` is contracted with bra copy `\(\sigma_i(a)\)`.  Let
`\(M_{\boldsymbol\sigma}(G)\)` be the `\(nm\)`-row linear system on ket
messages `\(u_1,\ldots,u_m\in\mathbb F_q^k\)` and bra messages
`\(v_1,\ldots,v_m\in\mathbb F_q^k\)` whose equations are

\[
   (u_aG)_i=(v_{\sigma_i(a)}G)_i
   \qquad(1\leq i\leq n,\;1\leq a\leq m).
\]

If `\(r_{\boldsymbol\sigma}(G)\)` is its rank, then the normalized contraction
is exactly

\[
 I_{\boldsymbol\sigma}(\Psi_C)
   =q^{\,km-r_{\boldsymbol\sigma}(G)}.                 \tag{1}
\]

Indeed, the system has `\(2km\)` message variables and hence
`\(q^{2km-r}\)` solutions.  The `\(2m\)` normalized tensor factors contribute
`\(q^{-km}\)`, giving (1).  This proof uses no Pauli label as an LU invariant;
it evaluates the basis-free tensor contraction directly.

The multilinear first fundamental theorem for the local unitary group says
that these permutation diagrams span the degree-`(m,m)` LU invariants.
When `\(q\geq m\)`, the local permutation diagrams lie in the stable
Schur--Weyl range.  Common relabelling of ket and bra copies replaces
`\(S_m^n\)` by diagonal left/right diagram classes; imposing party symmetry
then takes `\(S_n\)` orbit sums.  Thus at `\(n=6,m=4,q\geq4\)`, party-orbit
sums of these diagrams give the required stable spanning basis.  Formula
(1) evaluates every member.

## Generic constancy

Let `\(G(t)\)` have entries in an integral domain and let `\(K\)` be its
fraction field.  For a fixed diagram, put

\[
r_\eta=\operatorname{rank}_{K}M_{\boldsymbol\sigma}(G(t)).
\]
Some `\(r_\eta\)`-minor is a nonzero polynomial, while every larger minor
vanishes identically.  Away from the zero locus of the nonzero maximal
minors, the specialized rank is `\(r_\eta\)`.  Formula (1) is therefore
constant on that dense open set.

There are only finitely many diagrams at fixed `\(m\)`.  Intersecting their
generic-rank opens shows that **every fixed-copy LU invariant is generically
constant on a linear-code pencil**.  Any party-orbit sum or other fixed
linear combination has the same property.  Its restriction as a rational
function is constant, so it cannot generate a nonconstant pencil coordinate.

The same argument works for every fixed `\(m\)`, not only `\(m=4\)`.  The
open set depends on `\(m\)`, and this statement does not bound the copy
degree needed to separate the finite set of states over one fixed field.

## Exact reconciliation with C397, C548, and C550

For the six-party pencil, `\(k=3\)`.  C548's fixed four-copy diagram has
generic quotient-matrix rank `\(21\)`, so (1) gives

\[
 q^{12-21}=q^{-9}.
\]

On either rank-drop component its rank is `\(20\)`, so its value is
`\(q^{-8}\)`.  C548 proves that the reduced jump scheme across the 720 party
relabelings is

\[
   (B^2-2A^2)(9B^2-4A^2)=0,
\]

or `\((z-2)(9z-4)=0\)`.  This is exactly a **rank-jump divisor**, not the
value of a rational invariant.  C550's transport sheaf explains why those
two jump components and their multiplicities occur.

The q=13 orbit sum from C397 is also forced by (1).  Off the divisor it is
`\(720q^{-9}\)`.  On the component with 192 active rank-20 diagrams it is

\[
 192q^{-8}+528q^{-9}=(192q+528)q^{-9};
\]

at `\(q=13\)` this is `\(3024q^{-9}\)`, the recorded value.  The separator is
exact and arbitrary-LU invariant, but it detects membership in a special
rank stratum rather than recovering generic `\(z\)`.

## Why the proposed field was ill-typed

The projective pencil has a classical function field and C396 proves that
its quotient coordinate is `\(z\)`.  The associated quantum states do not
form one complex algebraic tensor family of fixed local dimension while
`\(q\)` and the finite-field arithmetic vary.  Their contraction values are
finite-field solution counts.  Treating those counts as rational functions
of `\(t\)` conflates:

1. polynomial maximal minors, whose zero schemes record rank jumps; and
2. normalized contraction values, which are powers of `\(q\)` on the rank
   strata.

C548/C550 correctly prove the first kind of statement and explicitly stop
before claiming coordinate recovery.  C559 makes that stop structural.

## Evidence and trust boundary

No new computation is load-bearing in C559.  The contraction-rank lemma and
generic-constancy argument are direct linear algebra.  The numerical
specializations above are algebraic consequences of the already frozen
C397/C548/C550 ranks and multiplicities; their exact scripts, certificates,
replay commands, hashes, and independent checks remain in those reports.

The conclusion does not claim:

- that the restricted LU/LC orbit theorem is false;
- that all-copy LU invariants fail to separate two fixed-field states;
- a copy-degree lower bound depending on `\(q\)`; or
- that every LU intertwiner between equal-phase code states is Clifford.

## `ej` and Tao closeout

The closeout yields three upgrades.

First, the negative result is not peculiar to C550's selected contraction:
formula (1) closes every fixed-copy permutation-contraction field route on
every algebraic family of equal-phase linear-code states.

Second, the divisor theorem gains its correct conceptual role.  Its
nonconstant algebra is carried by maximal minors and their degeneracy
schemes; the invariant values themselves retain only rank-stratum
membership.  This explains why C550 found a clean divisor but no pencil
coordinate.

Third, the correct C560 attack is now sharply constrained.  A proof of
restricted LU/LC coincidence must recover the local computational bases or
the code support from the tensor itself, or classify the zero-dimensional
components of the simultaneous-flattening intertwiner equations.  More
fixed-degree rank signatures can supply falsifiers and exceptional loci, but
not a generic rational coordinate.

## Mystery ledger

| Feature | Disposition |
|---|---|
| Whether four-copy orbit sums generate `Q(z)` | **Settled negatively:** their generic field is constant. |
| Why C548 nevertheless sees `(z-2)(9z-4)` | **Settled:** it is the maximal-minor rank-jump divisor. |
| Whether the obstruction is special to four copies | **Settled negatively:** every fixed copy degree is generically constant. |
| Whether restricted LU and LC orbit partitions coincide | **Open; C560 owns it:** requires support/flattening rigidity or exact component classification. |
| Whether a copy degree growing with `q` separates every fixed-field pencil class | **Open but not a manuscript gate:** no uniform bound or counterexample is supplied here. |

No C559 mystery remains.

## Vibe check

The planned route fails, but cleanly and for a structural reason.  The
failure prevents the paper from mistaking a degeneracy divisor for a
coordinate and leaves a much narrower, mathematically honest rigidity
problem for C560.
