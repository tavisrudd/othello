# C925 uniform level-two theorem: cold-referee repair audit

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Verdict

**Accept after one substantive certificate repair.**  The two suspected
descent failures are not fatal.  The generic product identity is genuinely
equivariant, and the good tangent slice descends on every twist once its
incidence open is formulated correctly.  The first symbolic cover was,
however, logically too weak: it checked the slice determinants but not the
smoothness minors of the same chosen tangent centres.  A fourth witness and
the corrected products (D_iM_i) close that gap on the entire smooth Cox
moduli.

Consequently the audit retains the statements

\[
 S\times\mathbf A^2\text{ rational}
\]

for every minimal Tschinkel--Zhang type (I_0,I_1,I_2,I_3), and

\[
 X\times\mathbf P^2\text{ rational}
\]

for both displayed Tschinkel--Zhang cubic families.  Together with the local
(m=1) theorem, both explicit cubic threefolds have exact threshold two.

## 1. Equivariant generic trivialization: proved

Let \(\mathcal T\to S\) be the universal torsor under the Neron--Severi
torus \(T\).  Tschinkel--Zhang Remark 2.2 states that in their
stable-permutation setting \(H^1(F,T)=0\) for every extension \(F/K\).  In
particular the generic fibre over \(K(S)\) has a rational point.  Translation
by the resulting rational section gives the explicitly equivariant map

\[
 S\times T\dashrightarrow\mathcal T,qquad (s,t)\mapsto\sigma(s)t.
\]

After quotienting the anticanonical scalar this becomes a
(T_0)-equivariant birationality

\[
 Z\sim_K S\times T_0.
\]

The saturated Galois-stable lattice defines an actual subtorus
(T_3\subset T_0), so taking Rosenlicht quotients gives

\[
 Z/T_3\sim_K S\times(T_0/T_3).
\]

This is the required statement.  Proposition 2.3 alone would only advertise
a birational product; the rational-section construction is what supplies the
equivariance needed here.

## 2. Good tangent section on every twist: repaired and proved

Write

\[
 \Delta=ab(a-1)(b-1)(a-b).
\]

The earlier certificate showed that three four-hyperplane evaluation
determinants had no common zero on \(\Delta\ne0\).  That did not by itself
show that the corresponding fixed Jacobian minor was nonzero.  The repaired
certificate tests the products (D_iM_i).

For the first three witnesses, localizing at \(\Delta\) and exhausting the
eight alternatives (D_i=0) or (M_i=0) leaves only

\[
 3a-b-2=0,qquad
 Q_0(b)=0
\]

or

\[
 3a-b-2=0,qquad (3b-26)(3b-13)=0,
\]

where

\[
 Q_0=31223016b^2-435944529b+1306078948.
\]

On that line the fourth product has primitive numerator

\[
 -(b-1)^4(4b-17)(16b-85)
 (83246b^2-872181b+2185995).
\]

The two products are coprime.  Besides the exact polynomial gcd in the
checker, the report records the four cross-evaluations and the nonzero
quadratic resultant, so the last step is human-checkable without trusting a
large Groebner basis.

The descent is then an incidence argument.  For each geometric surface, good
triples consisting of a tangent centre, a three-frame in the
boundary-vanishing conormal space, and an orbit test point form a nonempty
open in an irreducible parameter space.  Its projection to the tangent-centre
factor contains a nonempty open.  Tschinkel--Zhang Lemma 2.1 gives dense
(K)-points on the universal torsor and hence on its projectivization, so a
good centre can be chosen over (K).  Over that centre the good frames form a
nonempty (K)-open in affine frame space; an infinite field supplies a
(K)-point.  The split-coordinate witnesses themselves need not descend.

## 3. Extracted birational map

Let \(\lambda_1,\lambda_2,\lambda_3\) cut the good codimension-three
tangent slice, and let (q_j) be the components of a general point in the
four surviving weight blocks.  Define

\[
 A(q)_{ij}=\lambda_i(q_j),\qquad
 \kappa_j(q)=(-1)^j\det A(q)_{\widehat j}.
\]

All four \(\kappa_j\) are nonzero on the certified open.  The unique orbit
correction is

\[
 \chi^{w_j-w_0}(t(q))=\kappa_j(q)/\kappa_0(q),
 \qquad j=1,2,3.
\]

Unimodularity makes these Laurent monomials rather than radicals.  Cramer's
identity puts (t(q)q) in the slice, while uniqueness makes the formula
Galois equivariant and orbit-invariant.  If
(\rho_0,\ldots,\rho_4) are the other five tangent-projection coordinates,
then

\[
 [q]\longmapsto
 [\rho_0(t(q)q):\cdots:\rho_4(t(q)q)]
\]

is a concrete birational map (Z/T_3\dashrightarrow\mathbf P^4).

The inverse is the inverse tangent projection on the slice.  It is uniquely
specified by the twenty Cox quadrics, the three slice equations, and the five
displayed projective coordinates.  Expanding that quadratic elimination and
an explicit Hilbert-90 section for the nonsplit type-(I_1) and type-(I_3)
generic fibres remains optional constructive work; it is not a proof gate.

## Referee classification

| class | item | disposition |
|---|---|---|
| proved | (Z\sim S\times T_0) equivariantly | Generic section from Tschinkel--Zhang Remark 2.2. |
| proved after repair | good (K)-defined tangent slice on every minimal twist | Four (D_iM_i) witnesses plus incidence descent. |
| proved | one-point quotient and rationality | Unimodular signed-minor formula and OADP tangent projection. |
| repairable prose/citation | nonminimal reduction to degree at least five | Classical del Pezzo contraction/rationality step should receive a precise source before publication. |
| optional | full coordinate parametrization of the two displayed cubics | Inverse tangent elimination and explicit nonsplit section not expanded. |
| fatal | none | No remaining defect changes the level-two theorem. |

## Source and reproducibility boundary

Primary source read: Yuri Tschinkel and Zhijia Zhang, *Universal torsors over
quartic del Pezzo surfaces and stable rationality*, arXiv:2608.20029v1,
PDF SHA-256
`be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.
Read depth for this audit: Section 2 through Proposition 2.3, Section 3
through Corollary 3.5, and the type classification and subgroup statement in
Section 4.  This audit makes no global novelty claim.

Repaired primary bundle:

- `notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.py`,
  30,048 bytes, SHA-256
  `ead9ec015efd2a3fe74f8bb809ab449d53d651e3ef47e592ffd12387d20636cd`;
- `notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.json`,
  20,477 bytes, SHA-256
  `5f4ff4d6e6dc06e308b791198635f956cf6c6f8dd9a6ee5992875078be9a4dff`.

Replay from `/home/tavis/src/othello`:

    uv run --with sympy==1.14.0 python3 \
      notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.json

Independent lattice/window replay:

    python3 \
      notes/cubic-threefolds-tasks/c925-i1-level2-saturation-independent-check.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-i1-level2-saturation-independent-check.json

Full type-I3 replay:

    uv run --with sympy==1.14.0 python3 \
      notes/cubic-threefolds-tasks/c925-i3-level4-cubic-slice-check.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-i3-level4-cubic-slice-check.json

## Replacement manuscript

The surviving theorem is now presented in the new, separate manuscript
`papers/quartic-del-pezzo-level-two/`.  It does not overwrite or delete
`papers/cubic-stabilization-irrationality/`.

The six-page paper leads with the uniform level-two theorem, proves the
higher-rank unimodular-window quotient theorem with the signed-minor map,
explains the saturated lattice and projective mu-2 kernel, treats all four
Tschinkel--Zhang minimal types, and derives both cubic families, exact
threshold two, and the fourfold cancellation corollary. It states explicitly
that the four-type result is not a classification of every subgroup of
`W(D5)`, and that Tschinkel--Zhang's universal-torsor theorem remains an
input.

The manuscript carries typographically empty provenance annotations, a
claim map with statement digests, imported-source and evidence registries, a
tracked compact slice certificate, and a fail-closed metadata/checksum gate.
Its claim--proof--novelty ledger records the bounded 45-result screen and the
incomplete three-graph closure; no global first-priority sentence appears in
the paper. `make check` passes without TeX warnings, and the six-page PDF was
visually inspected at pages 1, 3, and 6.

## EJ + TT closeout

The cheap extra extraction is the signed-minor orbit correction above: it
turns the existence proof into a formula and simultaneously proves that no
hidden finite cover survives the saturation repair.  The Tao-style audit
asked whether the argument was using abstract rationality where equivariance
was needed, whether a geometric witness was being mistaken for a descended
one, and whether the determinant cover certified its own tangent centres.
The first two are resolved structurally; the third exposed and repaired the
only substantive defect.

## Mystery ledger

| status | feature | evidence gap or owner |
|---|---|---|
| settled | equivariant generic splitting | Rational section over `K(S)`. |
| settled | incidence descent on every twist | Dense `K`-points plus nonempty frame open. |
| settled | determinant/smoothness mismatch | Fourth witness and corrected product certificate. |
| settled | absence of a hidden finite quotient | Unimodular Laurent formula for `t(q)`. |
| open, optional | compact inverse tangent formula | Explicit elimination, not a theorem gate. |
| open, publication gate | global priority | Existing bounded audit is not forward-citation closure. |
| open, citation repair | nonminimal surface reduction | Add an exact classical source before manuscript promotion. |
| settled | intrinsic saturation explanation | Even-sum lattice of index two; the spurious degree is the parameter mu-2 kernel. |
| settled in the relevant domain | subgroup classification | All four hereditary-H1 types admit the restricted full-I3 window; arbitrary `W(D5)` subgroups remain unclassified. |
