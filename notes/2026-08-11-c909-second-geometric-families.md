# C909 — Second-family reconnaissance for the two detectors

Date: 2026-08-11  
Status: bounded structural reconnaissance; no manuscript, PDF, mirror, Lean,
or reviewer-dossier edits

## Executive verdict

No genuinely new geometric family currently has both detectors proved after
one stabilization.  The only proved conjunction in the bounded pass is the
odd-isogeny locus inside the smooth cubic-threefold family: Voisin supplies
universal (CH_0)-triviality from an integral minimal-class cycle, while the
C904/C907 bridge supplies irrationality of (X\times\mathbf P^1) for every
smooth cubic threefold.  This is a useful control family, but it does not
explain a second geometry.

The best genuinely new candidates are:

1. (V_4=Q_1\cap Q_2\subset\mathbf P^5), the degree-four del Pezzo/Fano
   threefold.  Beauville--Etesse--Höring--Liu--Voisin identify its genus-two
   curve (C), its line variety (F_1(V_4)\simeq J(C)), and its intermediate
   Jacobian (J(V_4)\simeq J(C)).  This makes the minimal-class and universal
   cycle side look favorable, but the cited source does not prove an integral
   Chow decomposition for (V_4), and the available small-quantum calculation
   has only the naive ((3,1)) spectrum.  The one-step atom is therefore an
   open gate, not a theorem.
2. Special cubic fourfolds of discriminant (D\not\equiv0\pmod4).  Voisin
   proves universal (CH_0)-triviality for this family.  KKPYY prove an
   enhanced twisted-K3 atom obstruction for a very general cubic fourfold
   containing a plane, but do not prove that this atom survives one
   stabilization or exclude all threefold carriers.  The two loci have not
   been matched; this is a plausible test family, not a verified pair.
3. Smooth quartic threefolds are an atom-side near miss.  Cai proves a
   multiplicity-three big-quantum obstruction to symplectic irrationality,
   but this proves only irrationality of the threefold itself.  No universal
   (CH_0)-trivial subfamily or one-step carrier-exclusion theorem is supplied
   by the source.  It should not be counted as a second separation family.

Thus the bounded answer to C909’s “second family” request is **candidate-level
only**.  The next useful work is a theorem-grade (V_4) gate audit (integral
decomposition first, then the actual big-quantum/Serre atom), not a census of
Fano threefolds.

## Detector A: proved control family inside cubics

Let (mathcal L_{mathrm{odd}}) be the locus of smooth cubic threefolds whose
principally polarized intermediate Jacobian admits an odd-degree isogeny to a
Jacobian (or a product of Jacobians).  Voisin’s Theorem 1.7 and the proof of
Theorem 4.5 give the following source-backed chain:

* the Jacobian carries an algebraic one-cycle of an odd multiple of the
  primitive class;
* the Prym construction gives an algebraic even multiple;
* odd/even cancellation gives the primitive minimal class
  (	heta^4/4!\) integrally;
* for a smooth cubic threefold, Corollary 4.4 upgrades this algebraicity to a
  Chow-theoretic decomposition of the diagonal, equivalently universal
  (CH_0)-triviality.

The atom side is independent of this construction: Cai’s cubic quantum block
has formal exponents (pm1/6), and KKPYY Example 6.21 identifies the block
with the unsplit cubic zero atom.  The local C904/C907 bridge then uses the
free positive atom group, projective-bundle multiplicity, and the exclusion of
primitive sixth-root formal monodromy from points, curves, and surfaces to
prove (X\times\mathbf P^1) irrational for every smooth cubic threefold.

**Verdict:** both detectors proved, but this is a sublocus of the original
cubic geometry.  It demonstrates that the two inputs can coexist; it does not
yet establish a second geometric mechanism.

## Candidate A: (V_4), intersection of two quadrics

### What is proved

For a smooth threefold (Y=Q_1\cap Q_2\subset\mathbf P^5), the
Beauville--Etesse--Höring--Liu--Voisin paper (Section 4.1, using Reid) records
the hyperelliptic genus-two curve (C\to\mathbf P^1) branched at the six
singular quadrics and the principally polarized isomorphism

\[
  J(Y)\simeq J(C),
  \qquad F_1(Y)\simeq J(C).
\]

The universal family of lines over (F_1(Y)) is an explicit codimension-two
cycle on (F_1(Y)\times Y).  Consequently (V_4) has the right geometric
inputs for the general rationally connected threefold criterion in Voisin,
Theorem 1.6: torsion-free (H^3), a universal codimension-two cycle, and an
algebraic minimal class on the Jacobian.  This proves a cohomological
decomposition criterion for (V_4), but the cited theorem does **not** by
itself give the integral Chow decomposition needed for universal (CH_0) in
the same way as cubic Corollary 4.4.  The exact integral upgrade is therefore
an open gate in this note, not an asserted theorem.

### Atom-side audit

The primary quantum-period source gives the small-quantum/naive spectrum for
rank-one Fano threefold (V_4) as

\[
  (\lambda-232q)(\lambda+24q)^3,
  \qquad \mathrm{NAD}(V_4)=(3,1).
\]

This has no visible primitive-sixth-root block.  It is not a disproof: the
naive small spectrum need not equal the big Hodge-atom decomposition.  But it
means that the cubic (pm1/6) mechanism does not transfer formally.  KKPYY
only says, at the end of Example 6.21, that a similar approach applies to
other three-dimensional Fanos; it does not calculate a (V_4) atom or its
Serre/formal-monodromy carrier height.

**Verdict:** plausible second family, but presently speculative on both the
integral (CH_0) upgrade and the one-step atom.  A useful first gate is to
compute the actual big-quantum (V_4) atom and test whether its Serre data can
occur on a surface; only after that should one attempt (V_4\times\mathbf P^1).

## Candidate B: special cubic fourfolds

Voisin proves that a special smooth cubic fourfold with discriminant not
divisible by (4) has universally trivial (CH_0) (Theorem 1.4 and the
discussion in the introduction).  This is a genuine integral diagonal
criterion, but it is not an intermediate-Jacobian divisor-product statement.

KKPYY’s Theorem 6.8 proves non-rationality of a very general cubic fourfold
using the (24)-dimensional zero-eigenvalue Hodge atom, and Example 6.17 gives
an enhanced twisted-K3 atom for a very general cubic fourfold containing a
plane.  Their enhanced-atom paragraph explicitly says that integral
structures and blowup compatibility are forthcoming.  Even granting that
enhancement, their criterion excludes carriers of dimension at most
(dim X-2=2); it does not exclude all threefold carriers for
(X\times\mathbf P^1).  Therefore no one-step irrationality statement for
the Voisin (D\not\equiv0\pmod4) family is currently sourced here.

**Verdict:** strong universal-(CH_0) side and strong zero-stabilization atom
side in nearby cubic-fourfold loci, but no matched one-step theorem.  The
containing-plane locus (D=8) should not be silently identified with Voisin’s
(D\not\equiv0\pmod4) family.

## Candidate C: quartic threefolds

Cai proves that every smooth quartic threefold is symplectically irrational.
The proof uses a multiplicity-three eigenvalue of big quantum multiplication
and a symplectic blowup decomposition; in complex dimension three, points and
surfaces have multiplicity at most two.  This is a genuine atom-like
irrationality detector, but it is a detector for (X), not for
(X\times\mathbf P^1): after one stabilization, threefold centers are no
longer excluded by that multiplicity bound.  The source gives no universal
(CH_0)-trivial quartic subfamily.  Keep quartics as a computational test of
carrier-height ideas, not as a claimed separation family.

## Does a general two-detector theorem say more than packaging?

At the purely formal level, no.  If detector A is an integral cycle or
divisor-product criterion and detector B is an additive atom invariant, then
“A holds and B survives the chosen stabilization” implies the conjunction by
definition.  A theorem that merely names the two invariants and repeats their
closure properties is packaging.

There is substantive content only if the theorem proves at least one of the
following:

1. a checkable geometric hypothesis forces detector A without using detector
   B (for example, an intrinsic cofactor-saturation theorem or an explicit
   universal cycle);
2. a birational/quantum hypothesis forces detector B with a carrier-height
   bound independent of the A-side geometry;
3. the two conditions are genuinely separable in parameter space, ideally
   with a non-isotrivial family where A holds and B fails, and another where B
   holds and A fails; or
4. the theorem supplies a new functorial product/deformation principle that
   produces simultaneous examples from independent input families.

The bounded evidence currently supplies (1) and (2) only for the cubic
control family.  It does not supply (3) for a new geometry: (V_4) lacks the
integral Chow upgrade and a one-step atom, special cubic fourfolds lack the
threefold-carrier exclusion, and quartics lack the universal-(CH_0) input.
Therefore a broad “two-detector separation theorem” would presently be
packaging unless it first closes one of those exact gates.

## Source ledger and coverage

Opening summary: 0 sources were read at full text in this bounded pass; 5
primary sources were read partially at the sections listed below.  The cache
keys and hashes identify the exact fetched bytes.  This is a source-positioning
note, not a literature-wide novelty or priority verdict; MathSciNet and a
full citation-graph audit were not attempted.

* Voisin, *On the universal (CH_0) group of cubic hypersurfaces*,
  arXiv:1407.7261, partial: Introduction/Theorems 1.6--1.7, Theorem 4.1,
  Corollary 4.4, Theorem 4.5.  Cache SHA-256
  `514e5634d920f4b8e9c6797f3de5ad34afea65624ba23cc764d329ebcdd2c4e4`.
* Katzarkov--Kontsevich--Pantev--Yu, *Birational Invariants from Hodge
  Structures and Quantum Multiplication*, arXiv:2508.05105v2, partial:
  Introduction, §§4--6, especially Theorem 6.8, Example 6.17, Example 6.19,
  Example 6.21, and Proposition 5.30.  Cache SHA-256
  `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64`.
* Beauville--Etesse--Höring--Liu--Voisin, *Symmetric tensors on the
  intersection of two quadrics and Lagrangian fibration*, arXiv:2304.10919,
  partial: Introduction, §§2 and 4.1.  Cache SHA-256
  `559a5f4fde84f4e1f553117e938b209960553072175b6de4215eaaf56c6a2494`.
* Böhning--Graf von Bothmer--Su’a, *Naive atoms of blowups: examples*,
  arXiv:2606.17884, partial: Introduction, §§3--4 and §10.  This source
  explicitly labels its small-quantum construction “naive” and warns that
  big-quantum atoms can differ; it is reconnaissance, not proof of a Hodge
  atom.  Cache SHA-256
  `d346bb0300a78e766386519b90dec93120f76e0f67c6ac22341c4eaead66762`.
* Cai, *The quartic threefold is symplectically irrational*,
  arXiv:2605.29143v2, partial: Abstract and Introduction/Theorem 1.3.  Cache
  SHA-256 `5d5f5b9858e795e2a376e2bbf57a6d6b393995ab0642f0498add69e9f2e438c3`.

The cubic (pm1/6) input and the one-step theorem are additionally recorded
in the local C904/C907 reports; those reports cite Cai’s cubic source and the
KKPYY primary text.  Their use here is an import of already closed local work,
not a duplicate C907 proof.

## Mystery ledger

* **Settled:** the only proved simultaneous pair in this pass is the odd-
  isogeny cubic control locus; it is not a new ambient geometry.
* **Settled:** V4’s line/Jacobian geometry is explicit, but “cohomological
  decomposition” is not silently upgraded to integral universal (CH_0).
* **Settled:** V4’s naive ((3,1)) small spectrum does not certify a big atom;
  the actual atom computation is the owning successor gate.
* **Settled:** cubic-fourfold (D\not\equiv0\pmod4) and containing-plane
  examples are different source loci; no overlap is assumed.
* **Open evidence gap:** a second family with both detectors proved after one
  stabilization.  Owning successor: a V4 integral-Chow/large-quantum audit.

Vibe check: the control mechanism is real, but the hoped-for second geometry
is not yet source-verified; V4 is the cleanest next gate and quartic/cubic-fourfold
near-misses should not be promoted as results.
