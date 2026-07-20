# C421 / F2 — Lean conic pairing-forgetting quotient

**Lane:** `clebsch`

**Date:** 2026-07-20

**Verdict:** `GREEN AFTER REFEREE-ADEQUACY REPAIR. The landed theorem types are kernel-backed at the
exact bounded scope recorded below. The source, gate, and report now distinguish those theorems from
the stronger projective, matching-space, boundary, counting, switch-span, and general-connectivity
consequences that are not formalized. Axiom audit and the post-repair guarded elaborations are clean;
no downstream exit uses the missing general switch theorem.`

## What this task formalizes

F2 of the replacement-spine Lean campaign
([`notes/2026-07-20-clebsch-lean-formalization-plan.md`](2026-07-20-clebsch-lean-formalization-plan.md)).
It Lean-formalizes C403's standard-conic pairing-forgetting quotient
([`notes/2026-07-20-c403-arrangement-complement-distance.md`](2026-07-20-c403-arrangement-complement-distance.md),
§ *Pairing-forgetting quotient and factorization kernel*), the structural input consumed by the
C406 harmonic quotient
([`notes/2026-07-20-c406-matching-module.md`](2026-07-20-c406-matching-module.md)).

Work on the standard conic `C : XZ − Y² = 0` with Veronese `ν(s,t) = [s² : st : t²]`.  For distinct
conic points `ν(sᵢ,tᵢ), ν(sⱼ,tⱼ)` the canonically scaled secant is
`L_ij = tᵢtⱼ X − (sᵢtⱼ + tᵢsⱼ) Y + sᵢsⱼ Z`.

## Owned modules

| module | role |
|:---|:---|
| `lean/RelativeConicArcs/ClebschConicMatchingQuotient.lean` | the quotient API (all content) |
| `lean/RelativeConicArcs/Gates/ClebschConicMatchingQuotient.lean` | import-only validation gate |

No generated matching census: the module is symbolic, consistent with the F2 plan slice
("reusable quotient API plus a light paper-facing theorem; no generated matching census").  It
imports the existing conic/projective API (`RelativeConicArcs.Conic`) and `Mathlib`.

## Exit theorems (one namespace `RelativeConicArcs.ConicMatchingQuotient`)

Over the weakest ring (any `CommRing R`):

- **Secant pullback** — `secant_veronese`:
  `ν*(L_ij) = (tᵢs − sᵢt)(tⱼs − sⱼt)`, plus `conicForm_veronese : Q(s²,st,t²) = 0`.
- **Four-endpoint switch identity** — `secant_switch`:
  `L_ab L_cd − L_ac L_bd = [a,d][b,c]·(XZ − Y²)`, `[i,j] = sᵢtⱼ − tᵢsⱼ`.  This is the plane lift of
  the matching switch `{ab,cd} ↦ {ac,bd}`.  The bracket pairing `[a,d][b,c]` is the unique correct
  one (checked symbolically; the three alternative pairings fail).
- **Quotient divisibility** — `conicForm_dvd_secant_switch`: the switch difference is an explicit
  multiple of `conicForm X Y Z`, so every switch difference lies in the conic ideal.

Parent forgetting (matchings as lists of endpoint pairs, `CommRing R`):

- `matchingProduct_veronese`: the Veronese pullback of a matching's secant product equals the product
  of the Veronese linear factors over the flattened endpoint list.
- **Parent forgetting** — `matchingProduct_veronese_congr`: two matchings whose endpoint lists agree
  up to permutation — in particular any two perfect matchings of the same endpoint set — have equal
  pullbacks; the factorization map forgets the parent matching.

Augmentation kernel (free space `ι → K` on the matchings, `Field K`, `Fintype ι`):

- `sumFunctional`, `augmentation`, `mem_augmentation`: the augmentation hyperplane `{a : ∑ᵢ aᵢ = 0}`.
- **Generic rank-one kernel = augmentation** — `ker_restriction`: for an arbitrary nonzero scalar
  `F`, the explicitly defined map `a ↦ (∑ᵢ aᵢ)·F` has kernel exactly the augmentation. Lean does not
  define the geometric matching-restriction map or prove it equals this map.
- **Augmentation dimension** — `finrank_augmentation`: `dim = card ι − 1`. Lean does not prove here
  that the index type has `(2r−1)!!` elements.

Full-rational-evaluation boundary (finite field, `Field K`, `Fintype K`):

- **Boundary-form vanishing** — `boundaryForm_eq_zero`: the defined polynomial value
  `s^q t − s t^q` vanishes for all `s,t` in the finite field. Lean does not connect this form to a
  full endpoint product or a matching word in this module.
- **Sub-boundary zero set / nonvanishing** — `prod_veroneseFactor_eq_zero_iff`,
  `prod_veroneseFactor_ne_zero`: the product vanishes iff some displayed bracket vanishes, and it is
  nonzero when every displayed bracket is nonzero. Lean does not impose valid/distinct projective
  representatives, identify the zero set with `S`, compare two endpoint sets, or prove a word
  weight in these theorems.

Switch connectivity (matchings as fixed-point-free involutions on `Fin m`):

- **Switch reversibility (any size)** — `isSwitch_symm`: a four-endpoint switch is undone by a
  four-endpoint switch, so switch adjacency is symmetric.  Depends on no axioms.
- **Base four-endpoint generator** — `base_switch_triangle`: the three matchings of a `4`-set are
  pairwise single switches (a complete switch triangle).
- **Base connectivity** — `base_switchConnected`: every perfect matching of a `4`-set is
  switch-connected (`Relation.ReflTransGen` of switch adjacency) to the base matching `{01,23}`.

### Scope of switch connectivity (declared boundary)

Formalized in-kernel are arbitrary-size switch reversibility, the three `Fin 4` matchings, their
complete switch triangle, and connectivity of every `Fin 4` perfect matching to the base. General
`2n` connectivity is a familiar conceptual induction but is not a Lean theorem here. It is unused by
the generic `ker_restriction` and `finrank_augmentation` theorems. It must be classified as external
and unused, or separately formalized before any paper calls it Lean-backed.

## Symbolic cross-check of the load-bearing identities

The two polynomial identities were verified independently with `sympy` before formalization:
`secant_veronese`, `secant_switch` (with the unique bracket pairing `[a,d][b,c]`), and the conic
pullback.  The Lean proofs of both are by `ring` after unfolding, so the checker boundary is Lean's
kernel plus `ring`.

## Validation

- Guarded single-file elaboration: `lean/scripts/guarded-lean
  RelativeConicArcs/ClebschConicMatchingQuotient.lean` — clean (no warnings, no errors).
- Gate build + exact-target `--no-build` aggregate confirmation through the unattended queue:
  `lean/scripts/lean-build-queue.py run RelativeConicArcs.Gates.ClebschConicMatchingQuotient
  --profile single --threads 1 --cores 20-23`.
- **Axiom audit** (`#print axioms` on every terminal, in the module): each depends only on the
  standard `[propext, Classical.choice, Quot.sound]` (or fewer; `isSwitch_symm` depends on none).  No
  `sorryAx`, no project-local axiom.

## Verification map delta

The exact displayed algebraic identities, list-permutation pullback equality, generic rank-one
kernel/dimension results, pointwise factor-zero/nonzero results, finite-field boundary-form identity,
arbitrary-size switch reversibility, and `Fin 4` switch results are kernel-backed. The stronger
geometric and general-connectivity consequences listed in the review below are not. No
`ClebschGateway*.lean` module or `ReflectionArrangementDecoding.lean` was edited; the task adds two
new modules only. F3 may consume only the exact theorem types, not the former prose gloss.

## Source artifacts

| file | bytes | SHA-256 |
|:---|---:|:---|
| `lean/RelativeConicArcs/ClebschConicMatchingQuotient.lean` | 15,241 | `2c355d852f02490ac2a688e0c5770c5ae829ca2ce31d4b35bfc27d54469c6df2` |
| `lean/RelativeConicArcs/Gates/ClebschConicMatchingQuotient.lean` | 783 | `bf378789f1b2f3fd5b6e2a0731a2f153e3b819bffba55c85aafeb946ea6c4d03` |

Hashes are for the committed sources; regenerate with `sha256sum` from `lean/`.

## Judgment-call record

- **General switch connectivity:** did not add the arbitrary-`2n` induction. The only landed
  connectivity theorem is on `Fin 4`; arbitrary-size reversibility is separate. The general theorem
  is unused by the direct generic augmentation calculation, so it is classified as external and
  unused rather than opportunistically expanding F2. Reopen only if a published claim or downstream
  theorem requires arbitrary-`2n` connectivity.
- **Matching restriction versus generic rank-one map:** retained the useful generic theorem
  `ker_restriction`, but stopped calling it the geometric matching-restriction map. A future
  application must prove the missing identification and matching count before inheriting geometric
  kernel/dimension language.
- **Projective endpoint and boundary consequences:** retained the exact factor-product and
  finite-field identities, but removed zero-set, word-weight, distinct-endpoint, and full-product
  conclusions that lack validity/distinctness/counting/bridge theorems. These are not implicit
  corollaries in the trust ledger.
- **No matching census:** kept F2 symbolic. The three `Fin 4` matchings are a fixed base example,
  not evidence for a general census or connectivity theorem.

## Independent cold review — 2026-07-20

**Reviewer:** Codex. **Disposition:** initial `NO-GO`, then `GO` after the source/gate/report adequacy
repair. The theorem bodies were unchanged. Post-repair guarded elaboration succeeded for both
`RelativeConicArcs/ClebschConicMatchingQuotient.lean` and its import-only gate; the terminal audit
printed only `propext`, `Classical.choice`, and `Quot.sound` (or no axioms for `isSwitch_symm`). The
theorem implementation landed in `5db65a06`; the referee-adequacy repair and final hashes landed in
`86ee1547`.

Findings and dispositions:

1. The false arbitrary-`CommRing` projective-equality gloss on the bracket was removed.
2. Generic augmentation kernel/dimension prose now states the missing geometric identification,
   matching count, and switch-span boundary explicitly.
3. Zero-set, distinct-word, and weight prose was narrowed to the proved pointwise bracket criteria.
4. Boundary-form vanishing is no longer presented as a theorem about full-endpoint products.
5. General `2n` connectivity is explicitly absent; only arbitrary-size reversibility and `Fin 4`
   connectivity are claimed.

### Required closing review checklist

**Archival gate:** the task must not be marked complete or moved from the live queue to the archive
until its report and checklist are complete, an independent referee-style review has been explicitly
requested and recorded, every finding has been fixed or the claimed exit has been narrowed, and a
post-fix review records final `GO`. A green elaboration/build or an initial implementation verdict is
not sufficient. Archive only after the final report, checklist, review dispositions, and C320 ledger
delta agree with the committed artifacts.

- [x] Read and restate every landed theorem type with its exact domain and hypotheses.
- [x] Assign the exact landed algebraic and `Fin 4` results the full-trust Lean route, subject to the
  recorded build/axiom evidence.
- [x] Detect vacuity/definition laundering and hidden assumptions: the definitions are substantive,
  but several prose consequences require missing projective-validity, distinctness, counting, and
  geometric bridge hypotheses.
- [x] Make every source comment/docstring and gate description no stronger than the theorem types;
  findings 1--5 above were resolved and guarded elaboration remained green.
- [x] Classify general `2n` connectivity as external and unused; do not inherit a Lean label from
  reversibility or the `Fin 4` base.
- [x] Confirm the named gate imports the content module and guarded-elaborate both final files.
- [x] Identify every claimed public terminal under “Exit theorems”; C320 must extract the final
  committed theorem statements and load-bearing definitions verbatim for the paper's adequacy
  appendix rather than reuse the former prose gloss.
- [x] Record exact files, terminals, landed source hashes, validation commands, and the reported
  standard-axioms-only audit; no generated data or certificate is involved.
- [x] Confirm no `sorry`, `native_decide`, project-local axiom, reverse internal reference, task ID,
  or novelty claim appears in the reviewed Lean files.
- [x] Recompute source byte counts/hashes; all four C421 source/gate values match this report.
- [x] State the precise exclusions and trust downgrades in this review and the corrected
  verification-map delta.
- [x] Record the independent reviewer, date, initial `NO-GO`, repairs, and final `GO`.
- [x] Supply C320's proposed ledger delta: exact algebraic/list/generic-linear/pointwise finite-field
  and `Fin 4` terminals are full-trust Lean; the geometric matching-kernel identification,
  double-factorial dimension, switch span, exact projective zero-set/weight, full-endpoint product
  bridge, and arbitrary-`2n` connectivity are not Lean-formalized.
