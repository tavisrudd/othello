# C913 Package D — orbit-cylinder lemma and one-chart appendix

**Lane**: `clebsch` · **Date**: 2026-08-14 · **Scope**: referee Majors 3 and 4
for `papers/cubic-stabilization-irrationality`.

## Major 3 — orbit-cylinder disjointness (`lem:orbit-cylinder-disjoint`)

The two-sentence assertion after `prop:support-collapse` is now a lemma with
a self-contained proof, designed to make the referee's resolution question
moot rather than answer it limb by limb.  Statement: for a smooth projective
Gm-variety with two chamber linearizations at which stable = semistable with
free semistable loci, and a bistable point with trivial stabilizer, the orbit
closure adds exactly the two Białynicki–Birula limits; the fibre weight
μ_u(w) of the interpolated polarization L_u = L_-^{1-u} ⊗ L_+^u is affine in
u, strictly positive at w_0 and strictly negative at w_∞ across all of
[0,1], while a fixed component semistable at some L_u has μ_u = 0; so the
orbit closure misses every fixed component occurring at an intermediate
polarization, and the equivariant Poincaré dual restricts to the endpoint
point classes.  Proof inputs: Mumford's numerical criterion
(`MumfordGIT`, new bib entry) in fibre-weight form, verified by the
elementary P(V) weight computation in the proof.

Resolution persistence (referee's part (b)) dissolves: the hypotheses live
on the resolved completion itself — Definition 8.1(i) plus bistability of
the cylinder orbit — so no compatibility between the resolution and the
orbit limits is needed; the numerical criterion is evaluated upstairs.

Source verification: the Włodarczyk extraction
(`2026-08-14-c913-wlodarczyk-2bprime-extraction.md`, cache key
arXiv:math/9904074) showed the source states NO isomorphism locus for the
resolution and does no GIT on the completion.  Two prose corrections
followed: bistability of the cylinder orbit is now derived from Definition
8.1(i)'s identification of extreme quotients being an identification of
birational varieties (not attributed to Włodarczyk), and the
iso-over-cylinder claim is now justified by canonicity of the resolution
over the smooth glued double line-bundle space, matching the actual proof of
Proposition 2(B′).

## Major 4 — one-chart appendix (`app:one-chart`)

New Appendix A (sections/appendix-one-chart.tex), drafted by an Opus
sub-agent from a fixed outline and the Woodward extraction
(`2026-08-14-c913-woodward-qk-extraction.md`), then reviewed line by line
and corrected in this session.  Five subsections: graded setup and the
derived fixed-section stack; evaluation at 1 and the attractor algebra
(unique-extension lemma, sign-dependence lemma — the attractor ideal depends
only on sign(a), the mechanism identifying consecutive tail degrees;
one-chart equivalence; two-chart descent); tangent complexes and the
2-commutative square (invariant Čech presentation; Woodward's POT as
truncation; the square proved via naturality at the equivalence plus a
Čech-level equality of representatives); µ_k-equivariance and rigidification
(a = b/k, stabilizer element θ^b, congruence class = b mod k, gerbe descent
via π_*π^* ≃ id); attached bubbles, cutting, Artin reduction.

Framing fact enforced throughout: Woodward's framework is classical
Behrend–Fantechi POTs over Artin domain stacks (no derived stacks anywhere
in QK III); the manuscript's derived layer is auxiliary and every comparison
lands back in his relative POT and virtual classes.

Review corrections applied to the draft: the unique-extension lemma's
statement now names the exponent-a twist explicitly (it had said "graded
ring maps" while using the twisted grading); the in-text square sentence in
the proof of `thm:tailwise-derived` was rewritten to match the appendix's
argument (naturality at the equivalence + equality of representatives)
instead of the "both adjoint" phrasing the referee objected to; the two
imported comparisons now carry citations — mapping-stack cotangent formula
(`ToenVezzosiHAGII`, new bib entry) and classical-POT-as-truncation
(`SchurgToenVezzosi`, new bib entry).  All Woodward locators in the appendix
(Definition 9.7, Lemmas 9.8/9.9, Corollary 9.10, equations (35)/(54)–(59),
Proposition 7.14, Example 9.15, QK II Propositions 4.3/5.21, Section 4.3)
were verified against the extraction file.

## Open points for the author

1. The `F^0_{≤0}V` subscript convention: the direct computation selects the
   nonnegative rotation-weight part in the natural indexing.  The appendix
   defines the subcomplexes intrinsically and treats the subscript as
   notation, so nothing is wrong, but a convention check upstream is worth a
   pass before submission.
2. The two imported derived comparisons (`ToenVezzosiHAGII`,
   `SchurgToenVezzosi`) are the appendix's only unproved inputs, now
   explicitly cited and isolated in its closing remark.  This satisfies the
   "no compressed derived/POT bridge remains implicit" gate by making the
   bridge explicit rather than proving it.
3. The expected-versus-open labels for Definition 8.1(i)–(iii) from
   Package C still await sign-off.

## Validation

`make check` green end to end: release surface (new required labels
`lem:orbit-cylinder-disjoint`, `app:one-chart`), endpoint regression,
spacing lint, deterministic manuscript check at 39 pages, warning-free,
tracked PDF byte-current.  Ledger updated: new lemma row; theorem row now
names the appendix and its two imports.
