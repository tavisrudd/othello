# C912 — Hypothesis 4.7H conditionalization of the cubic stabilization paper

**Date:** 2026-08-15 · **Lane:** `clebsch` · **Task:** C912 (active; author-close only)

## What was done

Applied the author's edit specification (`/tmp/opus_edit_spec_one_stabilization.md`)
to `papers/cubic-stabilization-m1/`.  The unresolved positive-filtration
bulk-displacement step is now a manually named hypothesis rather than an
asserted proof step, and every statement that depends on it says so.

Authority commit `76b016341`, with the author's review fixes at `bca9aec73`.
Warning-free deterministic build at **32 pages**, PDF SHA-256
`446242498cbb0a5e48c74e9aad31450984feec575b5876fae86206bf7abbcbb0`;
`make check` (lint, formal-static, manuscript, warnings) exits zero.

## Author review pass, same day

The author reviewed the first build and found no new mathematical damage, but
seven localized remnants.  All are repaired in `bca9aec73`.

- The common Levelt--Turrittin ramification in the choice-independence
  paragraph was written `z=u^E`, colliding with the reconstruction coordinate
  of Proposition 4.7.  It is now `z=\widetilde w^{\,E}`.  The author narrowed
  the original blanket rule accordingly: the prohibition is on bare `u` as a
  loop or ramified loop coordinate, not on `u` generally, so the cubic
  calculation's scalar units `u_\pm(z)` correctly stayed.
- The abstract's separation sentence and its Yang--Yu--Zhu stabilization
  clause, and the matching introduction sentence for Corollary 1.4, stated
  conditional consequences without the hypothesis.  All three now carry it;
  these are the sentences most likely to be quoted outside the paper.
- Lemma 4.5's proof, both halves of Proposition 4.7's proof, and Lemma 4.9's
  receiver paragraph still said the construction "compares the framed
  operators" or formed a "transported operator".  Each now says
  comparison-transported matrix and names the coefficient extension (4.0d).
- The Hahn receiver paragraph claimed that comparison maps, gauges, and framed
  operators all coexist in one receiver, which would have undercut the reason
  for the hypothesis.  It now says the comparison maps and gauges used in the
  algebraic conjugacy calculation coexist there, and that no intrinsic framed
  operator at the shifted bulk point is defined in it.
- The introduction's "the quantum theorem applies to every smooth cubic
  threefold" now distinguishes the unconditional cubic packet computation from
  the conditional one-stabilization conclusion, and the Section 5 "both
  conclusions hold" passage makes the same split for the `A_5`-family and the
  coprime-degree family.
- Lemma 4.9 called `p^spec` a framed operator; it now names it as the
  characteristic polynomial of the intrinsic specialized framed operator.

Not a defect: the author read Lemma 4.1A's `D'` as `D^0` in the PDF.  The
source is `\(D,D'\)`, the same prime convention the manuscript already uses
for `Y'` and `r'`; this is a glyph-extraction artifact in the reader.

## The hypothesis

**Hypothesis 4.7H (Reconstruction-displacement invariance)**, inserted after
Lemma 4.6 and before Proposition 4.7 as an unnumbered environment, so no
existing statement number moved.  It asserts invariance of the algebraic
multiplicities of `e^{±πi/3}` under exactly two families of positive-filtration
bulk displacements: the reconstruction tails left after the unit and
fixed-divisor terms are separated in the blowup and projective-bundle
decompositions, and the divisor-tagging family of Lemma 4.9.  It explicitly
asserts nothing for an arbitrary bulk displacement.

## New unconditional lemma

**Lemma 4.1A (Frame transport over a coefficient field)**, also unnumbered,
placed after Definition 4.1 and before Definition 4.2.  For a gauge
`G ∈ GL_n(K((z)))` over an algebraically closed characteristic-zero `K`, the
framed operators of gauge-equivalent modules are conjugate, because `σ(G)=G`
for the original-disc turn `σ`.  This closes the frame-transport step referee A
was owed *for the comparison isomorphisms*: Iritani's `Ψ` and Iritani--Koto's
`Φ` and their inverses are `z`-polynomial, so the lemma applies to them
directly.  It is not applied to the pro-Laurent bulk gauge of Lemma 4.5, and
the lemma says so.

## Status partition after the edit

Unconditional: Sections 2--3 entire; Definition 4.1 and `ν_6`; Lemma 4.1A;
Lemma 4.6; Proposition 4.12 (`ν_6(X)=2`, with an explicit sentence saying it
does not use the hypothesis); every universal `CH_0`-triviality assertion,
including all four in the introduction and Theorem 1.5's first conclusion.

Conditional on Hypothesis 4.7H: Proposition 4.7 with (4.2) and (4.3);
Lemma 4.9; Proposition 4.10; Theorem 4.11; Theorem 1.1; the irrationality
clauses of Corollaries 1.2--1.4 and Theorem 1.5; Corollary 4.13; and every
Section 5 sentence asserting irrationality after one stabilization.

## Downgraded claims

- Lemma 4.3's statement and proof no longer claim that an integral-`z`
  pro-Laurent gauge preserves the original-`z`-disc frame.  Both now say the
  result is an algebraic conjugacy statement in the inverse-limit coefficient
  algebra and nothing more.
- Lemma 4.5 now produces a *comparison-transported matrix*, not a framed
  operator, and its proof ends by naming Hypothesis 4.7H as exactly what would
  identify that matrix with an intrinsic framed operator at the shifted bulk
  point.
- Equation (4.6b), the full polynomial equality `p^tag = p^spec`, is deleted.
  Lemma 4.9 now derives equality of primitive-sixth multiplicities only, from
  the hypothesis plus the surviving injectivity equality (4.6a)
  `p^tag = p^int`.
- Proposition 4.10's proof says "if the canonical bundle of `T` is nef" in
  prose, removing the collision with the coefficient field `K_T`.

## Not done, by instruction

No exploratory material from the frame-transport memo was imported: no
mixed-order receiver inequality, no Sylvester/block-evolution calculation, no
Kato transport operators, no HYZZ repair narrative, no `±1/18` regression
variant.  The title is unchanged.  No stable-irrationality claim was added.  No
quantum-Künneth shortcut for `X × P^1` was invented.

## Metadata alignment and export, same day

The author's second review pass took two standalone-safety edits in the
introduction (the separation sentence before Corollary 1.2 and the genus-eight
`nu_6=2` sentence, both now carrying the hypothesis in their own sentence),
landed at `62f51b5bf`.  Final manuscript: 32 pages, PDF SHA-256
`742d4510ba37d8254edb1800093756809bf383ddcb992baa780ad1a30c10dbeb`.

All four non-manuscript surfaces then carried the unconditional claim and are
corrected at `7ed8fc604`, each using one canonical status sentence:

- `README.md`: headline description and trust boundary, the latter now naming
  the unresolved step explicitly.
- `.zenodo.json`: description rewritten, plain-ASCII as that file requires.
- `claim-proof-novelty-ledger.md`: explicit `STATUS:` markers per claim family
  — conditional for the main theorem, birational invariance, and the
  genus-eight corollary; mixed for the separation family, whose universal
  `CH_0`-triviality half is unconditional; unconditional for graph saturation
  and for a new row covering the cubic packet, which the ledger had never
  carried as its own claim family.
- `papers/summary/README.md`: seven occurrences, including a headline bullet
  that was titled "Unconditionally", both infinite-family table rows (whose
  own preamble requires a conditional statement to display its hypothesis), the
  papers table row, and the quoted abstract, retranscribed verbatim from the
  manuscript.  A new unconditional `nu_6 = 2` row was added to the
  infinite-family table.  The two cubic rationality papers also moved out of
  the Clebsch-series paragraph, where they did not belong.

The Lean companion README and the `BirationalDeduction` docstring needed no
change: both already exposed the operation formulas as supplied premises and
described the deductions as conditional.

A repository-wide scan for the unconditional claim phrases returns only
qualified hits.

Export is complete and unpushed.  `plan` reports the repository active with
zero reference findings, `audit` zero findings, `sync` from `7ed8fc604` changed
nine files with no deletions, and `verify` accepts 120 tracked files.  The
mirror's own `make check` passes and its rebuilt PDF hashes byte-identically to
the authority.  Standalone commit `f6d1480`.  The portfolio summary is not
carried by the exporter, so its mirror was refreshed by copying the authority
tree; the trees are identical and its commit is `5bd57c9`.  The claim ledger is
excluded from the export by `papers/repositories.toml` as a private surface,
which is why its internal task references do not reach the audit.

## Residuals for the author

1. The detector table in Section 5 lists `ν_6(P^3)=0`, which now depends on the
   conditional projective-bundle formula (4.2).  Neither the edit
   specification nor either review pass covered that row; it is the one
   remaining spot inside the manuscript where the partition is not explicit.
2. The next Zenodo release deposits the new description as a new version; the
   existing deposit keeps the unconditional one until then.
3. Nothing is pushed.  Publishing both the standalone repository and the
   portfolio summary remains the author's decision.
