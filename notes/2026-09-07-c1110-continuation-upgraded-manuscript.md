# C1110 — first draft and local export preparation

**Lane:** `continuation`. **Status:** first draft prepared; independent review remains open.

The user requested an exportable first draft and then explicitly retained ownership
of GitHub. No repository creation, push, release or DOI deposit is part of this work.

## Draft

Title: *Reconstructing projective frames from their continuation graphs*.
The 11-page draft integrates C295's stable-range corollary, C1109's constructive
recognition proof and independently replayed exact boundary. It distinguishes
written mathematics, finite computation and absent Lean coverage. N2 remains a
scope remark, and the six-point Clebsch seed is not confused with the q=11 frame.

The paper root contains the PDF, source, a pinned Nix environment, MIT license,
CITATION.cff, .zenodo.json, public verification scripts, canonical finite data,
source-only claim/evidence maps and integrity manifests. No DOI is fabricated.
The source recognizer is slower than generic graph isomorphism on the recorded
controls; the paper claims a representation and correctness result, not speedup.

## Review and validation

- Written proof pass: clarified the shifted-isotopy q>=5 hypothesis, removed an
  overbroad one-point automorphism assertion, and replaced the Lucas invocation
  with the elementary prime-power coefficient argument.
- Constructive pass: filled the missing cyclic-division-table step between pencil
  recovery and coordinates; verified final recognition checks every adjacency and
  the bijection rather than accepting a four-partition decomposition alone.
- Source pass: annotated all 20 statement-like environments with absent Lean
  coverage, checked statement digests/dependencies/evidence links, and linked the
  numerical table directly to the finite certificate. Metadata mutation tests
  reject altered coverage, census data, missing evidence and changed certificates.
- Computation: Sage 10.7 and pinned Sage 10.9 generate byte-identical boundary data;
  separate Python/nauty replay agrees. Recognition tests cover relabellings and
  duplicate/clone/deletion/degree-preserving-switch failures at q=13,17,19.
- Typesetting: two byte-identical PDF builds at a fixed epoch, no undefined
  references or overfull boxes; all 11 pages visually inspected. Equation labels
  were converted to numbered environments after visual review caught inherited
  display-counter misuse. The final rebuild passed before export.

This is an internal proof/prose pass and independent computational replay, not an
independent cold mathematical/prose referee report. That acceptance item and the
exact public Clebsch comparison remain open under C1110. C273's Lean release
obligation remains open and no Lean build was attempted. The user's first-draft
request does not imply completion of those publication-readiness gates.

## ej/tt closeout and mystery ledger

The finite exception now has an exact information-loss description: q=5 changes
pencil grouping on the same blocks, while q=8 exchanges disjoint block systems.
This is included with the census. A computation-free explanation of q=8 and a
practically faster recognizer remain explicit questions, not hidden proof gaps.
No additional out-of-scope discovery was identified; the discovery companion is
unchanged. No new tasks were allocated beyond the approved six-task plan.

## Verified local export

The guarded exporter materialized `~/src/math-papers/continuation-graph-rigidity`
from authority commit `4b7d602f3052a27bb5b519cac1adcca931751342`.
Its 31 public source files passed the private-reference audit with zero findings;
the exporter added provenance and its manifest (33 tracked files total).
The new independent local Git history begins at
`da8db37068c8cb7797fc9ff4134c1ebf64316099`.

Inside the standalone repository, the following passed:

```sh
nix develop path:. --command bash -c 'make check && python3 verification/check_manuscript_build.py'
```

Exporter verification passed after the initial local commit. The manifest content
SHA-256 is `d1c24554f5a157576514f892bd25907128f6b204c5f5a82a0acf31a9e5a93ae5`.
The standalone PDF and `verification/SHA256SUMS` are byte-identical to the
committed authority. The deterministic PDF is 325997 bytes and 11 pages.
Citation and Zenodo metadata are included; no DOI has been assigned and no GitHub
operation was performed. The author handles those actions.

A combined image/tool display exceeded the conversation output budget during
export inspection. Recovery used bounded export-manifest verification and the
standalone checks above; no materialization was repeated over an existing tree.


## Cold sub-agent referee review

At the author's explicit request a fresh-context sub-agent reviewed the exported
commit `da8db37068c8cb7797fc9ff4134c1ebf64316099`, without prior task reports or
author explanations. Its full report is
`notes/2026-09-07-c1110-continuation-cold-referee.md`. It read all manuscript
proofs and the public verification implementation and successfully replayed
`make check`. It found no main theorem, recognition, or census defect.

Two required revisions remain: restrict the general intersection/code
representation to k>=2 (and distinct points in the intersection formula), and
correct the Bruno–Mella attribution to the compactified moduli space with its
hypotheses. Recommended changes clarify shared exact-cover code and the partite
hypergraph mechanism, plus local quantifiers and exposition. The parent
corroborated the small-cap error and independently rechecked export provenance
and citation metadata. No manuscript or standalone content was changed during
review. This is an independent agent reading, not an external human referee or
comprehensive novelty clearance. C1110 remains open for revision and validation.

The review's explicit ej/tt closeout separates the purely partite clique bound
from geometric centre recovery; its mystery ledger retains the computation-free
q=7 and q=8 explanations as open questions, without finding a correctness gap.
