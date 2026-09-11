# C1133 — implementation map for the A/B integration plan

**Lane:** `cubic-threefolds`. **Date:** 2026-09-10.
**Status:** planning inventory of current manuscript and proof-note material.
No manuscript or registry has been edited by this inventory.

## Existing material: preserve, move, or explicitly dispose

Paths in this table are relative to `papers/cubic-stabilization-m1/`.
Destinations refer to the proposed sections in
`notes/2026-09-10-c1133-ab-integration-plan.md`; final filenames can be chosen
at implementation without renaming stable semantic theorem labels.

| Current source / stable identifier | Proposed treatment | Dependency or coverage precaution |
|---|---|---|
| `cubic_stabilization_m1.tex`, title and abstract | Preserve cubic-first title identity; rewrite abstract around cubic, A, method, B; update input order after sections are complete | Replace abstract's core IK claim only after P¹ proof is integrated; do not advertise omitted optional outputs |
| `sections/01-introduction.tex`, `thm:every-cubic` | Keep statement exactly; add precise A/B statements and one reading map | Its mathematical scope stays unconditional; formal annotation continues to report actual coverage |
| Same introduction, stable-rationality and sharpness discussion | Retain concise verified context; keep companion claims separate from headline proof | A conditional or unverified companion result cannot enter the cubic proof through introductory prose |
| `sections/02-qdm-marker.tex`, `prop:generic-spectral-connection-splitting` | Shared local setup in numerical section; technical splitting proof can be appendix-supported | Define original lattice and scalar extension conventions before use |
| `lem:A0preserve`, `prop:rank2-rigidity`, `prop:residue-discriminant-exponents` | Numerical construction; display canonical modification and its residue, with central proof argument | Keep resonant distinction visible when the stronger count first appears |
| `lem:cyclic-primary-persistence` | State full bulk scope in numerical section; give proof there if short, otherwise precise appendix pointer | The P¹ replacement needs all transverse even derivatives, not just small/divisor parameters |
| `lem:faithful-center-base-change` | Exact geometric lemma and proof mechanism in blowup section; completion details in appendix | Fixed-base version is an additional B obligation, not automatic quotient restriction |
| `prop:intrinsic-count-formulas` | Separate required blowup formula from stronger arbitrary-bundle assertion | General bundle formula retains IK if kept; narrower endpoint lemma cannot replace it verbatim |
| `prop:universal-rank-two-residue`, cubic subsection, `eq:RX` | Main cubic calculation and uniform numerical input for A | Preserve finite-jet/derivative term; detailed gauge calculations can move |
| `prop:atomic-lowdim` | Numerical surface-vanishing section, with explicit ruled-product replacement | No invocation of dimension-four birational invariance to establish center vanishing |
| `thm:marker-ledger`, `prop:qdm-operation-ledgers` | General formalism goes to optional extensions; body uses concrete proved formula | The abstract birational criterion's proof only uses blowup formula and vanishing; its unused bundle premise can be removed with matched statement/coverage review |
| `sections/03-applications.tex`, `thm:index-two-classification` | Retain its semantic label as an index-two consequence of A, with concise exact statement | Add a new label for A; do not relabel this narrower statement as all seventeen families |
| `cor:v14-one-step` | Retain as concise consequence of A; optional birational proof becomes a remark | Distinguish use of birational triviality of a bundle from quantum bundle comparison |
| `cor:threefold-marker` for arbitrary threefold Y | Keep in an explicitly optional general-results appendix, or defer with recorded ownership | Its current proof uses general P¹ doubling and therefore still needs IK; the nine-endpoint replacement is insufficient |
| `cor:voisin-separation`, `cor:fermat-separation`, `cor:coprime-separation` | Keep a compact cubic/zero-cycle consequences paragraph or subsection after the cubic proof | Ordinary CH₀ projective-bundle formula is not the quantum IK theorem; do not remove it by a keyword sweep |
| `sections/04-motivic.tex`, full additive/spectral extension | Move as a coherent optional appendix/supplement, keeping complete proofs and exact scope; omit abstract advertisement if peripheral | Its all-dimensional bundle formulas and K₀/(L−1) conclusions retain general IK input |
| `prop:hodge-marker-separation` | Optional illustrative example alongside additive material | Equal Hodge diamonds are not equal Hodge structures; do not frame this as contradiction to B |
| `cor:factorization-spectrum` and dimension-five discussion | Optional limitations/application subsection | Arbitrary P^m stabilization formula is not supplied by the new P¹ endpoint lemma |
| Rank-three pairing counterexample at end of `04-motivic.tex` | Technical limitation remark near any optional higher-rank lattice discussion | A's rank-three odd selector does not require a rank-three modified logarithmic lattice |
| `sections/05-cubic-check.tex`, `prop:cubic-block-data` | Keep complete independent split-basis check in technical appendix | Preserve evidence and semantic references; ensure only one global `\appendix` command after reorganization |

The default proposal preserves optional legacy results in an explicitly
separated appendix/supplement until the author chooses a narrower package.
It does not silently delete results to achieve a page budget. Their retained
presence means **IK is removed from the core A/B proof, not necessarily
from the paper's bibliography or every theorem**.

## New material and its exact homes

All following sources are under `notes/`. They must become complete
mathematical prose in the paper, not citations to audit conclusions.

| Source | Import into proposed paper | What must not be omitted |
|---|---|---|
| `2026-09-10-c1133-transport-input-reduction.md`, §§1–2 | Blowup comparison matching; endpoint P¹ lemma; ruled-product calculation | Spectator horizontal Novikov variables, original tensor lattice, mixed-bulk continuation and elliptic N=0 case |
| `2026-09-09-c1133-fixed-base-proof.md` | B's fixed-base lemma and full-fiber cancellation | Direct injection proof, independent occurrence coordinates, rational descent, common group, periodization boundary |
| `2026-09-09-c1133-transport-vanishing-audit.md` | Parity/equivariant geometric comparison and rank-three surface argument | Use full even ranks, not invariant-fiber ranks; omit IK adaptation from core when replacement suffices |
| `cubic-threefolds-tasks/c1133-m1-upgrade-proof-packet.md`, numerical and Hodge parts | Precise A/B statements, safe selection rule and endpoint recovery | Treat placeholder proof instructions as work to replace, not as completed manuscript proofs |
| `2026-09-09-c1133-geometric-source-audit.md` and finite audit/evidence | Nine detected-family table and all-member provenance appendix | Exhaustion, every-member deformation/model bridges, eight positive rationality inputs |
| `2026-09-09-c1133-arithmetic-audit.md` | Short D proof after B | Short finite-kernel/polarization route; no twists/effectivity or implicit polarized initial isogeny |
| Acceptance map and source register | Implementation checklist and citation matching only | Their acceptance language is not mathematical evidence inside a proof |

## Tests before choosing one paper versus two

1. Read the introduction and section openings without the technical proofs.
   A reader should distinguish three claims: irrationality of every cubic
   after one stabilization; A's complete rationality classification; B's
   rational H³ conservation on nine families. They should not infer A from B.
2. Follow the numerical proof and every cited lemma while omitting Part II.
   There must be no needed Hodge-fixed base, Tannakian construction or B lemma.
3. Read B's proof as an extension of Part I. Enumerate the genuinely new
   arguments and repeated material; replace repeated proofs with exact
   references, but never identify two different coefficient bases for brevity.
4. Compare the rendered Part II length and specialist prerequisites against
   the plan's 4–6 page core target. If it expands substantially, first remove
   optional C/D detours and repeated setup; then reevaluate a companion.
   The target is an editorial diagnostic, not a correctness limit.
5. Follow every retained general threefold, arbitrary bundle, motive and
   higher-stabilization claim separately. Each keeps the inputs it still uses.

## Scoped implementation batches

**Batch 1:** hierarchy/front matter and semantic-label inventory, then
numerical rearrangement without claiming new coverage.
**Batch 2:** actual reduced P¹/blowup proof, technical appendices and A.
**Batch 3:** B with fixed-base/full-fiber comparison and cancellation.
**Batch 4:** C/D placement, optional legacy disposition and repetition pass.
**Batch 5:** owning annotations, source/evidence/dependency records and
required manuscript/formal checks, followed by rendered specialist and
adjacent-reader review. Each coherent batch must preserve accurate records;
Batch 5 is a final reconciliation, not permission to leave earlier
statement edits with stale annotations.

This map does not execute any build or prescribe a manual Lean command.
The corresponding routed guides govern those implementation operations.

## EJ + TT and Mystery ledger

The bounded inventory exposed a concrete editorial dependency trap:
`cor:threefold-marker` and the additive spectrum results are stronger than
the special endpoint lemma. Their general IK input is retained explicitly.
The quantum and CH₀ projective-bundle formulas are also separated, so a
textual cleanup cannot erase the latter's valid use.

The rank-three limitation concerns modified lattices, not A's parity
selector; the plan must not make this old caution look like an unresolved
premise of A. These points are settled at the planning level. The remaining
editorial gate is the referee's comparison of the architecture options and
the later measured length of B's assembled proof. No new mathematical
mystery or external literature claim is introduced.
