# C907 — Geiser attachment as a Novikov-line continuation problem

Date: 2026-08-13

Status: Geiser peak theorem.  The two point-blowup receivers and the
Chen--Tseng middle-flop intertwiner lie on one analytic path after the
nonextremal Novikov degree is treated as a line bundle over the extremal
Kahler coordinate.  Local finiteness comes from the dimension axiom,
analyticity in the extremal series from Lee--Lin--Qu--Wang, and the required
parameter-uniform sectorial realization from Dreyfus's parameterized
Hukuhara--Turrittin/Stokes theorems after separating the ambient cluster by a
convergent spectral projector.  The complete point-centred Geiser peak, and
its product with `P^2`, preserve the Gamma rank Boolean.  This closes one
peak class, not Gold.

## 1. The apparent incompatibility

For the Geiser peak use the curve bases

\[
 (e,c)\quad\text{on }Y=\operatorname{Bl}_pX,
 \qquad
 (e',c')\quad\text{on }Y^+,
\]

where `e,e'` are point-exceptional lines and `c,c'` are the effective
flopping curves.  The middle flop gives

\[
 c'=-c,\qquad e'=e+3c.
 \tag{1}
\]

Thus, for `q=Q^e`, `s=Q^c`, `q'=Q^{e'}`, `s'=Q^{c'}`,

\[
 s'=s^{-1},\qquad q'=qs^3.
 \tag{2}
\]

The left and right large-radius rings are `C[[q,s]]` and `C[[q',s']]`.
Neither origin lies in their Laurent overlap.  Holding `q` fixed while
continuing `s` sends `q'` to infinity; holding `q'` fixed forces
`q=q's^{-3}`.  This is the exact failure of all fixed-parameter banking
proposals.

## 2. Quotient degree is a Novikov line, not a global coordinate

Lee--Lin--Qu--Wang index ordinary-flop series by a curve class modulo the
extremal ray.  Here

\[
 N_1(Y)/\mathbf Zc\cong\mathbf Z[e]
 \cong N_1(Y^+)/\mathbf Zc'.
\]

For quotient degree `a`, the left effective representatives are

\[
 ae+bc,\qquad b\ge0,
\]

while the corresponding right representative is

\[
 ae'+(3a-b)c'.
\]

The monomial equality is

\[
 q^as^b=(q')^a(s')^{3a-b}.
 \tag{3}
\]

Equation (3) means that `q` and `q'` are local frames of the same quotient
Novikov line over the compactified `s`-sphere, with transition `s^3`.
Equivalently, choosing the shifted source lift `e+3c` makes its local monomial
`qs^3` equal to `q'`.  The source extremal series then has a finite Laurent
tail down to `s^{-3a}` rather than being a power series.  This is harmless:
each quotient degree is treated separately, exactly as in LLW.

The correct common object is therefore not a bidisk with one global
nonextremal coordinate.  It is the completed direct sum of the powers of
this Novikov line, with analytic continuation in `s` and formal completion
in its fibre degree.

## 3. Local finiteness is exact

On `Y`,

\[
 c_1(Y)=2(H-E),\qquad
 c_1(Y)\cdot e=2,\qquad c_1(Y)\cdot c=0.
\]

For a genus-zero coefficient of degree `ae+bc`,

\[
 \operatorname{vdim}_{\mathbf C}\overline M_{0,n}(Y,ae+bc)=n+2a.
\]

Fixed homogeneous insertions and descendant powers therefore fix `a`.
The only infinite sum is the extremal `b`-series, precisely the series LLW
prove analytic and continue by `s'=s^{-1}`.  After product with `P^2`, a
base-line degree adds `3d` and the same conclusion holds coefficientwise.

Hence the proposed path requires no illegal map `C[[q]] -> C` and no
unproved convergence in the transverse degree.  It is a locally finite
formal family of one-variable analytic continuations.

## 4. Endpoint sectors have enough aperture

For either codimension-three point blowup, Shen--Shoemaker has
`r=3`, `s=1`, `nu=2`.  With the balanced Orlov normalization `k=1`, the two
center indices are `m=-1,0`, and the whole decomposition has the common
sector

\[
 -\pi<\arg(z/q)<\pi.
 \tag{4}
\]

An off-center point belongs to the tame/ambient block, whose own sector is
already (4).  On a positive-real continuation path, (2) preserves the phase
of the two local frames `q,q'`; the same `z`-sector can be used at both ends.
Thus neither sector width nor the pairing flip is the obstruction.

## 5. The separated-cluster lemma

Let `A_L` be the whole ambient block in the left point-blowup comparison and
`A_R` the whole ambient block on the right.  At the respective endpoint
germs the leading irregular eigenvalues of the point-exceptional center
blocks are nonzero multiples of `q` or `q'`, whereas the ambient cluster
conflues at zero.  Therefore each ambient cluster is spectrally separated
from its point-exceptional center clusters when its local Novikov frame is
nonzero.

The needed statement is:

> **Separated-cluster continuation lemma.**  For the Geiser two-parameter
> quantum connection, the formal ambient projector supplied by the
> point-blowup comparison has a canonical sectorial realization on (4),
> holomorphic in the quotient-Novikov line near the endpoint and compatible
> with LLW analytic continuation in `s`.  Its realization is jointly flat in
> the parameter directions.  Under Chen--Tseng's descendant transformation
> it becomes the corresponding right ambient realization.

Only whole clusters occur in this statement.  The cubic primitive-sixth atom
is allowed to confluence at the endpoint and is restricted only after the
whole-block identity has been transported to a nonzero interior parameter.
This avoids the false deconfluence move.

This lemma follows from standard parameterized irregular-connection theory
in the present setting.

**Proof.**  Work first near the left endpoint with `q ne 0`.  At `s=0`, the
two point-exceptional exponential values are nonzero multiples of `q`, while
the entire ambient cluster has exponential value zero.  A small contour in
the spectral plane therefore gives a holomorphic Riesz projector onto the
ambient generalized eigenspace.  The usual recursive block diagonalization
has denominators given by ambient--center eigenvalue differences, which are
units on a sufficiently small parameter neighbourhood.  It yields a
convergent parameter-holomorphic separation of the **whole** ambient cluster;
no decomposition inside that cluster is made at `s=0`.

For the separated ambient and center connections, apply Dreyfus Proposition
1.3 to obtain a parameterized Hukuhara--Turrittin form after shrinking the
parameter polydisc.  Proposition 1.13 and Lemma 1.14 give sectorial sums
meromorphic in `(z,t)` and commuting with parameter derivatives whenever the
chosen `z` direction is nonsingular.  The balanced sector (4) supplies such
a direction at the endpoint.  Thus the formal ambient projector used in the
blowup receiver has a unique parameter-holomorphic sectorial realization and
is jointly flat.  This proves the asserted endpoint identification.

The same argument applies at the right endpoint.  Between the endpoints,
LLW prove that every fixed quotient-degree series is analytic in the
extremal coordinate and remains formal in the quotient degree.  Section 3
shows that, for the small connection used here, each matrix coefficient is
actually locally finite in that degree, so the quotient parameter can be
evaluated along the correlated path.

Remove from the total space of the quotient-Novikov line the turning locus
where an ambient eigenvalue meets a point-exceptional eigenvalue and the
ordinary singular locus of the quantum connection.  These form a proper
complex analytic subset.  The complement of a proper complex hypersurface
in this connected complex parameter surface is path-connected; after an
arbitrarily small perturbation, choose a path joining the two endpoint
neighbourhoods.  Refine the excluded locus by the proper collision loci for
the formal factors entering `P6`.  Cover the path's compact image by finitely
many Dreyfus polydiscs.
On overlaps, uniqueness of sectorial sums identifies the local realizations;
choose a continuous lifted `z` direction avoiding the finitely many moving
singular directions on each member of the cover.  If the cover is changed
across a Stokes wall, the change is the ordinary Stokes transition of the
same analytic connection, not a new fibre functor.

Chen--Tseng define their variable-independent `U` by exactly this analytic
continuation of descendant fundamental solutions, and their Theorem 0.2
identifies it with Fourier--Mukai transport in the Gamma framing.  Therefore
the patched continuation is the Chen--Tseng transformation and carries the
left ambient realization, its tracked `P6` formal factors, and the Gamma
point row to their right counterparts.  This proves the lemma. `square`

The possible change of formal level at `s=0` in Dreyfus's Example 1.5 is not
a counterexample: the proof first separates the whole ambient cluster from
the nonzero point-exceptional clusters and applies the parameterized theorem
on punctured ambient parameter domains.  It never specializes the internal
cubic exponential splitting through its confluence point.

## 6. Closure of the Geiser peak

1. The left Gu--Yu--Yu/Shen--Shoemaker receiver identifies the endpoint
   cubic rank Boolean with the restriction of the intrinsic Gamma rank row
   to `P_6(Y)` inside `A_L`.
2. Continue `A_L` along the quotient-Novikov line and the extremal coordinate.
   Chen--Tseng's Gamma/Fourier--Mukai square fixes the off-exceptional point
   class and transports the complete formal-monodromy packet across the
   middle flop.
3. The lemma identifies the result with `A_R` in the right balanced receiver.
   The right point-blowup theorem then identifies its Boolean with that of
   the target cubic.
4. Tensoring the entire construction with the small QDM of `P^2` preserves
   the point row, the aggregate primitive-sixth packet, and the continuation.

Therefore rank-Boolean invariance holds for the complete Geiser peak and for
its product with `P^2`:

\[
 \boxed{
 \mathfrak r_{X\times\mathbf P^2}|_{P_6}\ne0
 \iff
 \mathfrak r_{X'\times\mathbf P^2}|_{P_6}\ne0.}
 \tag{5}
\]

This does not prove Gold: a general fivefold weak factorization has peaks
other than the Geiser link.  It does, however, reduce the first genuine peak
from an undefined frame comparison to one named analytic lemma with all
algebraic and angular hypotheses explicit.

## 7. Boundaries and regressions

1. The theorem concerns a general point `p` with six distinct Atiyah curves.
   Degenerate points, colliding lines, or nonordinary tangent sections require
   a separate limiting argument.
2. It uses the finite-disjoint extension of Chen--Tseng proved in
   `2026-08-13-c907-geiser-peak-descendant-intertwiner.md`; the published
   theorem itself states one connected simple-flop center.
3. Product with `P^2` is obtained by small-QDM Kunneth naturality.  It is not
   an invocation of the unproved general ordinary-flop extension in
   Chen--Tseng Remark 3.1.
4. The path may wind around turning divisors and accumulate a Stokes
   mutation.  This does not affect the conclusion because the patched
   analytic continuation is the same `U` whose Gamma/FM compatibility is
   Chen--Tseng's theorem.  It would matter if one tried to identify
   individual exponential lines rather than the whole packet and rank row.
5. Nothing here says that every peak in a smooth fivefold factorization is a
   Geiser peak.  Global Gold retains the peak-coverage/classification gate.

## Sources

- J.-C. Chen and H.-H. Tseng, *Descendant and Fourier--Mukai equivalences
  for simple flops*, arXiv:2604.09962v1, especially Theorem 0.2 and Section
  3.  Cached PDF SHA-256:
  `edee1bc9cce58e216ec5973dd409a72de80db593820a912ed54325773edef6df`.
- Y.-P. Lee, H.-W. Lin, F. Qu, and C.-L. Wang, *Invariance of quantum rings
  under ordinary flops III*, arXiv:1401.7097, Theorem 0.1.1 and Sections
  1.2--1.3.  Cached PDF SHA-256:
  `eeb1d87ae279a04c0ce5e9df66ce820aa87443fa6494f21d24269891a905b19c`.
- Shen--Shoemaker, arXiv:2502.08762v2, equations (64), (78), and Remark 1.6,
  for the endpoint sectors.  Cached PDF SHA-256:
  `2c1d25490d53d1eb04da11e4ad8eec2d9834b25e765462186181292e7f085cce`.
- T. Dreyfus, *A density theorem for parameterized differential Galois
  theory*, arXiv:1203.2904, Proposition 1.3, Proposition 1.13, and Lemma 1.14,
  for parameterized Hukuhara--Turrittin forms, parameter-meromorphic
  sectorial sums, and commutation with parameter derivatives.  Cached PDF
  SHA-256:
  `927b043d9af6759673cd28be74dfe1765373e60bf6e9c94821a80dd0700dccc0`.

## EJ / TT / AA

- **EJ:** `q'=qs^3` is best read as the transition of a Novikov line.  In
  quotient degree, LLW already performs exactly the required Laurent
  reindexing.  The fixed-parameter contradiction disappears without ever
  evaluating a formal series at an unauthorized point.
- **TT:** line-bundle reindexing does not itself compare sectorial fibre
  functors.  The comparison uses Dreyfus only after a convergent whole-cluster
  separation and uses Chen--Tseng to identify the patched global transition;
  omitting either step reopens the original frame gap.
- **AA:** this closes one peak, not a globalization theorem.  The next C907
  question is peak coverage in dimension five, not another Geiser
  continuation calculation.
