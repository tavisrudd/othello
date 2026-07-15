# Adversarial takeover audit — Clebsch and gem-mining

**Date**: 2026-07-14
**Scope**: documentation-first takeover of the `clebsch` and `gem-mining` lanes. No manuscript,
checker, or Lean source is changed by this audit. It records the claim failures, ownership, repair
tasks, and gates that must be settled before implementation or submission.

## Executive verdict

The Clebsch rigidity computation is a plausible publishable spine, but the current manuscript is a
major-revision draft rather than a converged paper. Its most urgent defects are correctness defects,
not polish: it identifies projective syndrome directions with received-word deep holes, counts
support triples as leaders, and overstates the scope of the perturbation and q=11 theorems. The
classical Edge/BSW ancestry is still absent from the prose and two load-bearing BSW sources remain
unread.

The gem-mining hexad theorem is a separate, note-sized result with a stronger trust boundary: C147 is
machine-checked and has a short orbit/involution proof. Its remaining exposure is literature and
positioning, especially the same-invariant BDMP near miss and inaccessible extension-count sources.
It must not become a third spine inside the Clebsch paper.

## Exact coding levels the Clebsch paper must distinguish

For the `[6,3,4]₁₁` code, `|C|=11³=1331` and the projective uncovered locus has 12 points.

| Object | Exact count | Correct interpretation |
|---|---:|---|
| projective deep-hole syndrome directions | 12 | the conic's `F₁₁`-points |
| nonzero affine syndromes / deep-hole cosets | 120 | ten scalar multiples over each direction |
| received-word deep holes | 159720 | 120 cosets, each containing 1331 received words |
| minimum-weight leaders across all deep-hole cosets | 2400 | 20 leaders in each of 120 cosets |
| support patterns in one deep-hole coset | 20 | the `C(6,3)` coordinate triples; these split `10+10` |

The paper's defensible headline is therefore “the projective deep-hole syndrome locus is exactly a
conic,” not “the complete set of deep holes is exactly a conic.” A deep hole is a received word `v`
with `d(v,C)=ρ`, not a vector at distance `ρ` from every codeword.

## Clebsch issue ledger and ownership

| Severity | Issue | Owner | Required disposition |
|---|---|---|---|
| correctness blocker | deep holes, syndromes, cosets, leaders, and support triples conflated; title/abstract/corollary dimensionally false | **C163** | rewrite every occurrence against the exact table above |
| correctness blocker | parity-check columns placed in `PG(k−1,q)` in general instead of `PG(n−k−1,q)` | **C163** | correct the general dictionary; note the present self-dual coincidence |
| correctness blocker | projective arc stabilizer silently called the pure permutation automorphism group | **C163** | state and prove the monomial/projective group and its induced support action |
| theorem repair | chirality proposition calls 20 supports the code's 20 leaders; no coefficient-aware action or shipped checker | **C164** | state per-coset `10+10` and global 2400-leader invariant; durable checker |
| theorem repair | the 252-neighbour spectrum is correct but unshipped; global “nearest other six-arc” gloss is false literally | **C165** | commit checker, define local graph/metric, preserve spectrum, remove/localize gloss |
| theorem repair | “phenomenon is specific to q=11” exceeds the theorem, which leaves non-`A₅` q≤14 open | **C166** | synchronize theorem, abstract, section opening, and open question |
| proof gap | q=9 checker tests one witness but not the asserted uniqueness of the relevant `A₅` subgroup/orbit class | **C166** | prove/cite conjugacy classification or enumerate every class |
| prior-art blocker | no Clebsch 1871 / Edge 1956 / BSW 1991–92 / Van de Voorde lineage or exterior-set vocabulary in prose | **C146** | re-base related work and priority footnote |
| novelty exposure | two BSW originals unread; one is titled “Characterization of complete exterior sets of conics” | **C153** | read originals and retract or calibrate the covering claim immediately |
| priority exposure | Sadeh thesis and earliest `(iv)⟺(v)` source unresolved | **C131/C161** | primary-source ownership ledger |
| internal contradiction | Klein section says both `11∤60` and that this is reduction at a prime dividing the group order | **C128/C167** | certify exact syzygy/reduction, remove incompatible genre sentence |
| unsupported claim | “Bayes-optimal error floor for any decoder” lacks channel, prior, and loss; latent-variable claim is undefined | **C167** | delete, not hedge |
| scope failure | dual, Mathieu, ten-arc, Klein, and statistical asides compete with the rigidity spine; one foil is called “generic” | **C167** | retain only material that advances the main theorem or its positioning |
| reproducibility | gap, chirality, and syzygy claims lack paper-package checkers; no integrated manifest/hash/replay gate | **C128/C164/C165/C168** | durable artifacts followed by full closeout |
| documentation | live handoff retains hundreds of lines of superseded exploration and contradictory status claims | **C168** | move history to companion archive; leave only current map |
| provenance blocker | not every computation cited by the draft currently resolves to a paper-package checker | **C128/C164/C165/C168** | require every cited script/Lean source to be Git-tracked; manifest path, blob/hash, command, output |

### Double-check of the two unrelated `252` claims

The number must not be globally walked back. There are two different uses:

- **One-point perturbations: `252` is correct.** An independent enumeration of all 133 projective
  points found exactly 42 legal replacement points for each of the six deleted Clebsch vertices.
  The 252 resulting six-arcs are distinct and reproduce
  `{18:30,19:60,20:90,22:42,24:30}` for `|U(A') △ C|`; the surviving-conic-point spectrum is
  `{4:60,6:132,7:60}`. This agrees with the earlier independent Claude/Fable recomputation recovered
  from sessions `b64674bd` and `9b212ae1`. C165 therefore preserves these finite clauses.
- **Conic six-subsets: `252` is not the global count.** There are `C(12,6)=924` six-subsets of a
  12-point conic. The `252` appearing in the rigidity sweep is only the number of concyclic
  representatives among its 1548 frame-normalized representatives.

The perturbation theorem's closing sentence still needs correction. Literal globality is refuted
without a search: the conic projectivity `(X,Y,Z) ↦ (4X,2Y,Z)` preserves `XZ=Y²` but sends the stated
Clebsch arc to a distinct arc
`{(0,1,2),(1,2,10),(1,4,4),(1,5,0),(1,6,10),(1,10,3)}`. Equivariance gives the same deep-hole conic,
and a direct recomputation confirms `U(A')=C`, hence symmetric-difference distance zero. The valid
result is the exact gap over the fixed arc's one-point-replacement neighbourhood, not over every
other embedded six-arc.

## Gem-mining / hexad issue ledger and ownership

| Severity | Issue | Owner | Required disposition |
|---|---|---|---|
| submission exposure | open-access extension-count audit found BDMP using the same object, invariant, notation, q=11 computation, and the w=5 identity; PGOFF and Korchmáros–Storme–Szőnyi remain unread | **C169** | close inaccessible sources and make BDMP the nearest same-invariant citation |
| citation gate | published source for the 132+132 PSL/PGL split still missing | **C156** | source exact two-system statement; do not misuse CO-TR §8 at p=11 |
| citation gate | inferred Hirschfeld/Semple–Kneebone theorem numbers were never checked | **C157** | pin exact sources or replace with verified CO-TR/Nguyen references |
| write-up | C147 result is durable but not yet a focused note | **C155** | write the involution identity, orbit proof, `t+|U|=82`, and q=23 mechanism-negative |
| cross-lane seam | Clebsch's on-conic spectrum and C155's hexad theorem share `|U|`; double ownership would recreate the salami problem | **C155/C167** | C155 owns theorem; Clebsch cites only the identity/explanation |
| checker mismatch | Clebsch's Mathieu script constructs one Steiner system, while the correct polarity theorem necessarily concerns two | **C155/C167** | use C147's two-system verifier; cut or explicitly test the Clebsch transversals against both |
| scope control | q=23 is a mechanism-negative, not the first rung of a Mathieu tower; U-atlas/q=5 are separate hunts | **C155**, with **C159/C160** separate | short note only; no speculative family spine |

## Work order and gates

### Clebsch

1. **C163 first**: no later prose work is trustworthy until the coding objects and counts are fixed.
2. **C146 in parallel**, with C153 remaining the external headline gate.
3. **C164–C166**: repair the three theorem statements and their verification boundaries.
4. **C128 + C167**: certify or prune the decorative sections and produce the single-spine draft.
5. **C168 last**: replay, compile, citation audit, cross-paper-number check, adversarial reread, and
   handoff archival cleanup.

### Gem-mining

1. C155 may draft now from C147 and the completed open-access extension-count audit.
2. **C169**, **C156**, and **C157** gate submission, not drafting.
3. C159 and C160 remain independent; neither may expand C155 without an explicit scope decision.

## Trust rules for the takeover

- A task is not “certified” merely because an ephemeral or unshipped script once produced the number.
- Every computation cited or relied on by a manuscript has a Git-tracked script or Lean source;
  the final manifest records `git ls-files` success, path, blob/SHA-256, command, and expected output.
- Every finite theorem names its durable checker, exact command, output, and independent or
  kernel-checked corroboration where claimed.
- “Deep holes,” “cosets,” “syndromes,” “leaders,” and “supports” are never used interchangeably.
- Literature negatives are reported with their unread ledger; “not found” is never upgraded to
  “verified novel.”
- Results shared by two manuscripts get one owner and an explicit citation seam before either ships.

## Grade forecast after the queued repairs

**As received by this takeover:** `C+ / major revision`. The central computation was promising, but
coding objects were conflated, the global gap gloss was false, q=11 uniqueness was conditional,
several numerical claims lacked durable checkers, the automorphism claims were imprecise, and the
manuscript had multiple decorative spines. The two unread BSW papers also left a real headline
priority exposure.

**After all correctness, scope, reproducibility, and literature gates land:** predicted `A−`
(roughly `8.5/10`) as a finite-geometry/coding paper, with the following component grades:

| component | forecast | reason |
|---|---:|---|
| correctness and trust | A | strict Lean core, fail-closed exhaustive checkers, exact manifest, explicit trust boundaries |
| theorem strength | A− | unconditional all-prime-power isolation, monomial/affine orbit theorem, global sharp gap, local orbit resolution |
| novelty | A−, conditional | rigidity/gap/chirality/why-11 survive the searches; BSW originals remain the last serious exposure |
| exposition and scope | A− | one spine after C167; object-level coding semantics and ownership seams are explicit |
| conceptual depth | A− | C173 now explains Petersen/chirality through the five self-polar triangles; the global rigidity theorem remains a finite exact classification |
| reproducibility | A | every cited computation Git-indexed, hashed, replayed, and expected-output checked after C168 |

The reason not to predict a clean `A` is structural, not a missing cleanup item: the paper's main
rigidity theorem is an exact small-field classification, and part of its setup is shared with a
companion paper. C170/C171/C172 make that classification unusually strong and C167 makes it
coherent, but they do not turn it into a broad family theorem.

**Collision sensitivity.** If either unread BSW original already states that the exterior set's
joins miss exactly the conic, the setup must be reattributed and the optimistic ceiling moves toward
`B+/A−`; the rigidity characterization, sharp gaps, chirality, code-orbit structure, and
unconditional q=11 isolation still survive. If BSW is clear and the Sadeh/Edge ownership ledger is
clean, `A−` is the most likely final grade. C173 has now landed and raises the conceptual component
to `A−` without changing the overall grade.
