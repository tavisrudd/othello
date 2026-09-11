# C1133 — B body prototype and integration test

**Lane:** `cubic-threefolds`. **Date:** 2026-09-10.
**Disposition:** B's central proof drafted and rendered; the prototype
supports the two-part single-paper architecture P. This is a working section
for integration, not a new assembled-paper or independent-referee acceptance.
The existing manuscript, its claim map and formal coverage are unchanged.

## Deliverable and measured result

`2026-09-10-c1133-b-body-prototype.tex` and its adjacent PDF contain the
complete additional body argument for B, using the explicitly recalled
numerical results that will precede it. The rendered prototype is **five
pages including its working-note opening and three bibliographic entries**.
It uses the current paper's 11pt article format, A4 paper and 29mm margins;
the measurement was not achieved by shrinking the typography. The final
cancellation/weight/descent proof is kept together on the final page.

This is inside the plan's 4–6 page target for the Hodge section and below
the referee's roughly 6–8 added-page split-review trigger. It supplies a
positive reason to keep B in the paper. It does not measure the whole
revised paper, establish empirical reader comprehension or bind pagination
after integration into the complete manuscript.

## What the body now proves

1. Exact theorem statement with the nine-family set defined before use.
2. A common rational Hodge group for every comparison and auxiliary surface
   model; fixed bulk parameters with the full cohomology fiber retained.
3. Direct faithfulness of the actual reduced fixed-base map. The finite
   ample-degree slice and Vandermonde argument are in the body, together
   with the regular inverse, canonical lattice and occurrence separation.
4. The safe whole-primary selector, its equivariant blowup formula and
   vanishing on all low-dimensional centers. The elliptic case is explicit.
5. Constancy of representation multiplicities, endpoint recovery of all
   H³ and doubling under the specialized P¹ lemma in all even bulk directions.
6. Cancellation of 2[H³], recovery of pure weight three and rational descent
   by the determinant polynomial on the rational equivariant-Hom space.

No numerical classification statement invokes B. The draft introduces no
very-general hypothesis, integral identification, principal polarization
claim or general projective-bundle formula. C and D are left outside this
prototype; their additional hypotheses therefore do not obscure B.

## What is reused rather than redeveloped

| Existing proof material | Prototype treatment | Integration obligation |
|---|---|---|
| Generic regular splitting, cyclic persistence and rank-two residue rigidity | Recalled as preceding numerical lemmas; fixed-base application checked | Put exact semantic cross-references in place of the working phrase “Part I” |
| Original reduced rings and completed coefficient realization | Ring and decisive injection argument printed; construction conventions reused | Retain full completion proof in the numerical/technical sections |
| Point/curve/nef-surface and ruled-product calculations | Short fixed-base verification, including b₂=1 and elliptic N=0 | Do not replace this by a claim that generic decompositions agree on both bases |
| Nine-family finite data and every-member identification | Only the two required block configurations recalled, with their exact family lists | Keep the full finite/geometric provenance in A's section and appendix |
| Specialized P¹ product proof | Tensor-lattice starting point and every mixed direction specified; new equivariant continuation proved | Cite the precise earlier endpoint lemma, not an arbitrary big quantum tensor formula |

The principal unavoidable overlap is checking numerical constructions on
the Hodge-fixed base. The prototype restates their needed properties in
short proofs but does not reproduce the nine matrices, gauge calculations,
cyclic trace recurrence, GW potential derivation or classification bridges.
The additional work is organized in four subsections, with one comparison
lemma and one operation/vanishing proposition before the theorem's final
proof. No new general theory is introduced solely for organization.

## Review and validation boundary

The root reread the complete fixed-base and transport/vanishing notes,
packet §§23–26 and the relevant Iritani Hodge source passage, then checked
the prototype against the plan referee's six required body arguments.
All five initial rendered pages were visually inspected. The final layout
change keeps the last proof together; the affected pages were rechecked.
The final TeX log has no overfull/underfull boxes, unresolved references,
undefined citations or LaTeX warnings. The Nix environment emits a
deprecation notice about its existing texlive package; compilation succeeds.

This prototype has not received a new cold referee read. Earlier reviews
cover the underlying distributed arguments at their recorded boundaries;
they do not automatically approve this new wording. Full manuscript
integration, its annotated-artifact checks and assembled-PDF cold reads
remain the next gates. No Lean operation or paper-mirror export occurred.

Of the three external works cited in the prototype, Iritani's Hodge note
was previously read in full; the blowup and Behrend works were read partially
at their relevant primary passages. The current pass reread Iritani Hodge
v2 §3 (extraction 547–660) for the common group, Tate and equivariance
conventions. No new source or novelty search is claimed. Exact prior depths
and hashes remain in `2026-09-09-c1133-literature-sources.json`.

## Replay and artifacts

From `/home/tavis/src/othello`, create the build directory and compile:

```sh
mkdir -p /tmp/persistent/tavis/c1133-b-prototype
SOURCE_DATE_EPOCH=1767225600 FORCE_SOURCE_DATE=1 ~/.claude/bin/run-quiet "nix develop /home/tavis/src/othello/papers#manuscript --command latexmk -xelatex -interaction=nonstopmode -halt-on-error -outdir=/tmp/persistent/tavis/c1133-b-prototype /home/tavis/src/othello/notes/2026-09-10-c1133-b-body-prototype.tex"
```

The tracked PDF is the resulting build PDF, copied beside its source.
`2026-09-10-c1133-b-body-prototype.sha256` records both files' SHA-256 and
byte counts. The TeX source is the exact generator for this layout artifact;
it is not a mathematical computation certificate. The working compiler log
is `/tmp/persistent/tavis/c1133-b-prototype/2026-09-10-c1133-b-body-prototype.log`.
Page previews were made with Poppler's `pdftoppm -scale-to 1100 -png`.

## EJ + TT and Mystery ledger

The closeout asks whether the reader needs the full periodized-category
formalism in order to follow the cancellation. They do not. A short source
attribution explains the common Hodge group; the proof then records ordinary
representation multiplicities in R(G_C). At the end, p−q together with the
known pure weight p+q=3 recovers the Hodge bidegree, and rational Hom descent
finishes. This expresses the same argument with less categorical overhead.

- **Settled:** B's essential body fits the intended section budget while
  retaining the fixed-base proof and the full final cancellation argument.
- **Settled:** the present prototype creates no reason to split B from A.
  Proceed with P; retain P′ (D proof in an appendix) if arithmetic alone
  later causes excessive length.
- **Open measurement:** total integrated length, pages to the cubic proof,
  final duplication and adjacent-reader comprehension. The assembled-paper
  review owns these gates; five standalone pages do not settle them.
- **No new mathematical mystery:** the remaining work is integration and
  independent reading of the actual assembled prose, with the existing
  geometric-source boundaries maintained.
