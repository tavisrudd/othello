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
