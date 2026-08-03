# Reed--Solomon lane discovery track

**Lane:** `reed-solomon`

Append-only companion for incidental observations and musings under
`notes/discovery-track-conventions.md`. The lane was initialized from planned C398/C474 follow-up
work, so there is no incidental entry at creation.

## 2026-07-22 — ej pass on the C475 base (session review, no allocation)

Provenance: user-requested ej pass over the lane after C475 closed.  Items 1, 2, and 4 are
symbolic rereadings of C475's committed identities, checked by hand against small examples; item 3
is a framing lead carrying a novelty-risk flag.  Logging allocates nothing.

1. **The syndrome plane is `Sym^2(P^1)` and secant incidence is the harmonic invariant.**  The
   linear bijection `u -> Q_u`, `Q_u(t)=u_0 t^2-2u_1 t+u_2`, identifies the projective syndrome
   plane with unordered point-pairs of `P^1` (rational pair, conjugate pair over `F_q^2`, or
   double point).  C475's affine identity (5) factors the secant determinant as `(t-s)` times
   *exactly* the classical joint harmonic invariant `ac'+a'c-2bb'` of the pairs `{s,t}` and
   `roots(Q_u)`.  Hence: a deep syndrome of a conic-supported GRS code is an unordered point-pair
   harmonic with **no** support pair; C475's `beta_u(v_i,v_j)` is the joint harmonic invariant of
   two pairs; the rank-one stratum is the locus of double points, with the radical equal to the
   doubled point; and the square class of `Delta(u)` (projectively well defined, since `u -> rho u`
   scales `Delta` by `rho^2`) is the rational-pair/conjugate-pair — equivalently
   exterior/interior — dichotomy.  Consequences: the C476 orbit problem is literally the
   `PGammaL_2(q)` orbit problem for `(6+2)`-point configurations on the line, with `(rank,
   Delta-class)` as free coarse invariants that any orbit census should stratify by; a C477
   collision is a cross-ratio resonance between two marked pairs relative to the support sextic,
   so its "discriminant geometry" already has a classical home before any new machinery.
2. **Characteristic two: the nucleus is a universal deep hole.**  Taking `u=(0,1,0)` (the nucleus
   of the standard conic), (5)'s second factor is `s+t` and (6) gives `1`, both nonzero on distinct
   support points; so the nucleus is a deep syndrome of *every* conic sub-support in
   characteristic two, its `beta` is the symplectic bracket, and its four-cycle atlas consists of
   pure cross-ratios of the support.  Prediction for C476's `q=8` row: a distinguished singleton
   orbit with support-only atlas, and no interior/exterior dichotomy (the pair dictionary
   degenerates with it).
3. **The atlas fragments the joint invariant ring of a binary sextic and quadratic.**  Under item
   1, a six-point support is a binary sextic and a syndrome a binary quadratic, so the lane's
   target — all-field orbit reconstruction with explicit discriminant — is a finite-field
   instance of the classical joint-covariant theory of `(sextic, quadratic)` (transvectants,
   apolarity, catalecticants; literal Clebsch territory).  This both supplies C477 discriminator
   candidates (resultant of `f` and `Q_u`; apolar covariants) and raises a novelty risk: before
   any external wording, a claim-specific audit must check finite-field joint-invariant
   literature.  Internal use as vocabulary is free.
4. **Free count on the rank-one stratum.**  A chord of the conic meets it only at its two support
   points, so for any six-point conic support all `q-5` conic points off the support are deep and
   rank one.  C476's radical-orbit computation is therefore the stabilizer action on a set of
   known size `q-5` per support.

## 2026-07-22 — typed-output framing import from the certified torsor close

Provenance: `2026-07-22-master-stroke-ej.md` (section 4.2); framing lead, no allocation.

C484 (q=8 `C3` orientation descent) should import C473's pointed/unpointed output-type discipline
wholesale: state recovery as unqualified on the pointed category and as a torsor identification
after forgetting, rather than as a qualified failure. C482's pure/child-relative separation is the
moduli-level analogue (continuous fibre loss vs free finite torsor); C485 can adopt the close's
typed phrasing for the child-relative clause verbatim. The crowns C486 battery (T_11 bridge) may
give the RS extremal fibre the certified torsor object directly.

## 2026-07-22 — item-3 novelty flag discharged

Provenance: user-requested literature-priority audit over the day's landed and ej results;
`2026-07-22-reed-solomon-landed-results-literature-audit.md`. The item-3 flag (2026-07-22 ej entry:
"before any external wording, a claim-specific audit must check finite-field joint-invariant
literature") is now discharged. Finding: the closest predecessor is Dür 1991, "The decoding of
extended Reed--Solomon codes," which decodes Cauchy/RS codes "using an analogue of the classical
theory of apolarity of binary forms" — so apolarity-of-binary-forms for RS is pre-empted at the
tool level. The specific (binary sextic, binary quadratic) joint-covariant / harmonic-invariant
framing tied to deep-hole orbit reconstruction has no predecessor located over the covered indices
(MathSciNet/Google Scholar NOT COVERED; Dür 1991 body not reached, verdict rests on its abstract).
Internal use as vocabulary remains free; external wording must cite and distinguish Dür 1991.

## 2026-07-22 — C491 incidental observations

- **Stab-12 sporadic pattern.** The sporadic deep-hole orbits with stabilizer order 12 occur at
  exactly the sporadic prime fields q ≡ 1 mod 3 (q = 7, 13, 19: sizes 28, 182, 570), and their
  pencils contain no linear×irreducible-quadratic member at all (members are only
  double-root or irreducible cubics). Smells like equianharmonic/j=0 pencils whose arithmetic
  S₃ image degenerates; a uniform description would explain most of the sporadic mass.
  Certified data in `2026-07-22-c491-prs-deep-hole-census.json`; no allocation.
- **q=8 sporadic torsor.** The three sporadic 252-orbits at q=8 are a single Frobenius orbit
  (PΓL fuses 3→1), i.e. a Gal(F₈/F₂)-torsor on a cubic-twist parameter — same flavor as the
  C484 q=8 colour-orbit C₃. Possible common mechanism with the frozen redundancy-three q=8
  story; not developed.
- **Sporadic vanishing gap.** Weil bookkeeping proves no S₃-stratum deep holes for q ≥ 41 but
  the census shows none already for q = 16 and all 23 ≤ q ≤ 37; the true threshold is a bounded
  curve-theoretic question (sharpen the 4+24 discard constants and Aubry–Perret on the (2,2)
  fiber-square curve). Cheap if ever needed for a clean paper statement.

## 2026-07-22 — C499 resolution of C491 sporadic leads

The "stab-12 sporadic pattern" and "q=8 sporadic torsor" leads above were promoted to C499 and are
settled in `2026-07-22-c499-sporadic-pencil-structure.md`: the stab-12 orbits are equianharmonic
(j=0) A₄ pencils (redundancy-five analogue of O⁺/O⁻), the q=8 trio is one free Gal(F₈/F₂) torsor
paralleling C484's colour C₃, and sporadicity is a bounded-q accident (the equianharmonic locus
persists for all q≡1 mod3 but is deep only at q∈{7,13,19}). The "sporadic vanishing gap" lead
remains open discovery-track material (C491 Lemma 7 already proved q≥23; no allocation).

- **j-map paper framing (for C500).** The branch/ramification j-invariant of the Hankel pencil is a
  rational modulus on syndrome space that organizes the whole redundancy-five classification: T/S are
  its degenerate boundary, O± are j=0 in the cyclic (C₃) stratum, type-I sporadics are j=0 in the S₃
  stratum (same modulus, different deck group). Could restructure the C491/C499 material as strata of
  one j-map; also the type-I cover φ_f is plausibly the classical tetrahedral trigonal map (explicit
  normal form, unverified). Type-I deepness is n₁₁₁ = 0 where n₁₁₁ is the S₃ identity-class count
  ≈ (q+1)/6 (bounded-q accident, C491 Lemma 7); the degree-3 cover's S₃-Galois closure has arithmetic
  genus 1, so a candidate CM (j=0) point-count could give the exact {7,13,19} threshold. (NB: an
  earlier "splits only on two special A₄-orbits / n₁₁₁ ∈ {0,4,6}" reading was a low-q artifact — it
  fails at q=67 where a free orbit splits; corrected in the report.) Identifying that genus-1/CM curve
  is the concrete C500 follow-up. Paper-structure lead; no allocation.
- **Numeric collision.** At q=13 the tangent family T and the type-I sporadic share (size 182,
  stab-order 12) but not the group — T's stabilizer is the cyclic q−1 torus, the sporadic's is A₄.
  Reminder that (size, stab-order) is not a complete orbit invariant; group structure + branch type
  is. Incidental.

### 2026-07-23 — redundancy-nine modular lift grows in characteristic seven

**Provenance:** C513 extra-juice Lucas/nucleus calculation after the redundancy-eight acceptance
gate passed.
**Was I looking for this?:** no — C513 classified degree-seven syndromes; this probes the next
degree only to identify the cheapest successor gate.
**Observed / musing:** degree-seven NRC nuclei have consecutive-row lifts in degree eight equal to
`P<e4>` in characteristic five and `P<e2,e3,e4,e5,e6>` in characteristic seven. The latter is much
larger than C513's two candidate lines, even though the generic four-marker forecast remains
deletion degree 36, exact normalized integer threshold 50 (C512 closed bound 51), and first
prime-power threshold 53.
**Why it may matter / strongest question:** redundancy nine may acquire a genuinely higher-
dimensional modular arithmetic problem; determine whether the characteristic-seven four-space is
shallow, persistent, or split by extension-degree deck data before allocating that application.
**Second-order refinement:** the characteristic-five point is shallow for every `q>5`, via
`(t^5-t)(t-a)` with the infinity factor retained. The characteristic-seven four-space is
projectively `det^2 tensor Sym^4(E)`, the binary-quartic representation from C491, and admits no
universal split septic because common annihilation forces `d1=...=d6=0`, hence a seventh power.
More generally, in characteristic `p` the top nucleus of the degree-`p` NRC lifts at syndrome
degree `p+1` to `P(det^2 tensor Sym^(p-3)(E))`: the `p=3,5,7` cases are respectively the C491
nucleus point, a binary-quadratic plane in C509, and the new binary-quartic four-space. Across the
whole prime-diagonal carrier, common annihilation leaves only `<x^p,y^p>`, a `p`-th-power pencil;
therefore no universal squarefree witness exists and the modular problem is intrinsically
orbitwise.
**Third-order refinement:** at `q=p=7`, every split squarefree septic is the complement of one
point `r` in `P1(F_7)`, and its Hankel-kernel condition is exactly `h(r)=0` for the corresponding
binary quartic. Thus the modular carrier is deep exactly on the `819` rootless projective quartics
and shallow on the other `1982`. Over larger characteristic-seven fields a rational root remains a
sufficient shallowness witness, but rootlessness is not yet known to imply deepness.
**Collision warning:** the tempting `q=49` candidate
`(t^5-t)(t^2+5)` is not squarefree: the residual roots `plus-or-minus3` already occur in
`t^5-t`. It supplies no rootless-but-shallow witness, and the derived elliptic parameter count
cannot be promoted without removing the full collision divisor. The residual-quadratic
discriminant remains a useful detector only together with determinant, diagonal, and collision
gates.
**Evidence:** CHECKED linear support, universal-witness, and `q=7` inclusion--exclusion
calculations; larger-field rootless sufficiency remains untested.
**Status:** open lead.

### 2026-07-24 — correction to the characteristic-seven collision warning

The preceding warning is false over `F_49`: the roots of `t^5-t` and `t^2+5` are disjoint there,
so their product is a valid split squarefree septic.  The associated rootless quartic is shallow,
which disproves rootless sufficiency already at `q=49`; the later redundancy-nine theorem makes
the entire characteristic-seven carrier shallow at that field order.

**Provenance:** exact boundary reconciliation in
`notes/2026-07-24-c542-prs-redundancy-eight-lean.md`, using the checked witness recorded in
`notes/2026-07-23-c513-prs-redundancy-eight.md` and the closed theorem boundary in
`notes/2026-07-23-c516-prs-redundancy-nine.md`.
**Evidence:** CHECKED witness; LEAN boundary record keeps only the q=7/q=49 statements.
**Status:** retired -> q=49 rootless sufficiency is false.

### 2026-08-02 — carrier geometry does not generate transverse packages

**Provenance:** Version 2 synthesis and independent geometry cold read.
**Was I looking for this?:** no — the synthesis was expected to promote the
closed recursive carrier directly to the old uniform numerical theorem.
**Observed:** the exact reduced carrier theorem classifies polar lines
contained in the terminal bad union.  It does not construct or exhaust the
one-step lower packages on every transverse stratum at an arbitrary new
redundancy.  The finite-depth escape theorem explicitly requires those
packages stage by stage.
**Discriminator:** any future unconditional all-\(r\) threshold must print a
uniform transverse-stratum atlas, its integral covers, and marker/collision
budgets.  Further primary decomposition or Lucas-carrier refinement cannot
close this gate.  Fixed R10 is separate and is closed by its printed
five-marker package.
**Evidence:** manuscript theorem scope was narrowed to the explicit package
hypothesis; R8--R10 remain unconditional after fixed-level discharge.
**Status:** open structural lead; no task allocated by the synthesis.
