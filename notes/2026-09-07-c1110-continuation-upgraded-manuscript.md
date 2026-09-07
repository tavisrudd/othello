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
  display-counter misuse. The final rebuild is required before export.

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

Export verification and final commit identities are recorded after synchronization.
