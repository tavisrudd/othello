# C1102 — referee response and accessibility revision

Date: 2026-09-07. Internal agent review, not external peer review.

The cold report is preserved unchanged in `2026-09-07-c1102-cold-referee.md`
(commit a78937049). Verdict: minor mathematical revision, substantive accessibility
revision. The targeted reread is `2026-09-07-c1102-referee-reread.md`; its conclusion
is that the accessibility revision succeeds, with no new central mathematical error.
Its local residual comments have been addressed below.

## Audience and editorial changes

Primary audience: quantum-information researchers working on transversal gates and
magic-state preparation. Adjacent audience: finite geometers and invariant theorists.
The opening now states the operational question and distinguishes the p=11
Clifford-product exclusion from the p=7 menu-specific preparation advantage.
The signed-orthogonality dictionary is attributed to its predecessors, with Watson's
stronger logical-triple constraints distinguished from the arbitrary coupled cubic.
The contribution account identifies the resource interpretation, exact spectra and
bounded preparation result without asking the reader to consult an internal ledger.

The conic construction has a roadmap and a coefficient-detail skip; Hessian rank
is motivated before its formula, with a one-variable cubic example. Weighted rank
and the three-step factory argument are introduced before the interval proof.
CSS, QRM, RS, the augmentation module, conference cubic, invariant pencil and
chordal cubic are glossed at their interfaces. The optional Macaulay paragraph
moves to the coordinates appendix. Authors and read versions were added to the
bibliography; the Hessian source remains explicitly a preprint. Audit counts,
approval mechanics and task identifiers were removed from rendered mathematical
prose; canonical N1–N9 positioning and read depths remain in the supporting audit.

## Mathematical corrections

- Actual representatives: h2=h composed with q=2 times normalized second cubic.
  Because q squared is identity, it exchanges h and h2 exactly. The state map
  to the normalized representative is 7q, with inverse 8q; 2 times 8 cubed=1 mod 11.
- Geometric lifts: the old non-equivariance inference is not used. A new exact
  test checks all 1320 reconstructed PGL2(11) actions: exactly 60 preserve V5,
  all restrictions have determinant 1, whereas q has determinant -1.
- Sheet reversal: coordinate negation sends the full homogeneous phase to its
  negative, so the inverse gate is Clifford-conjugate. The q-exchange scope is
  explicitly limited to the shadow. Both changes preserve the appropriate
  Clifford resource class; they have different fixed-coordinate meanings.
- The q permutation now has its exact six-pair order; the coefficient basis is
  e_i-e_5. The chosen conference signing has invariant triangle products.
- The factory proof explicitly uses preservation of overlaps by its final
  Clifford. The abstract includes the independent uniform-Z/ideal-Clifford
  assumptions. The last open question is explicitly about the finite absence
  at primes 17,19, not an unproved all-primes stopping claim.

## Reproducibility and validation

Replay from the repository root:

```
nix develop path:$PWD/papers/clebsch-cubic-phase#manuscript --command make -C papers/clebsch-cubic-phase pdf
```

The ten statement identities, 107 pinned source/input hashes, references, exact
rational inequalities, complete p=7 finite census and new shadow check pass.
The new atomic bundle is `verification/shadow_check.py`,
`verification/shadow-certificate.json`, this report and the checksum/claim registries.
The check reads the three committed, pinned bridge/pencil/action intermediates;
reuses their finite-field substitution functions; and independently compares all
geometric restrictions. It is deterministic, standard-library, under one second.
It does not independently derive the geometric representation or shadow censuses.
The referee separately ran this check and checked its conventions against sources.
The large p=11 and distance-three searches remain attributed recorded executions.

Revised PDF: 12 pages, SHA256 `a7c4200facd3099fce04d92a25081504f9c2835158834038c6ac1a60f3be87e2`.
Baseline: 11 pages at commit fb93f5c02, SHA256
`c503a7247384114ab053ea0c465a635fa4bc8d7726ed6ef6949383345d519a0a`.
Final build has no overfull/underfull boxes or unresolved references.
A fresh source-only copy builds a byte-identical PDF. Rendered pages 1,8,9,12
were inspected; final ragged-right bibliography fixes stretched spacing. The pinned TeX scheme emits a future-deprecation
notice. No toolchain migration was needed for this revision.

## Mystery ledger — explicit ej + tt closeout

After acceptance of the scoped checks, the cheap extra-value pass settled the
projective-versus-actual scalar issue and replaced the invalid non-equivariance
shortcut by an exhaustive restriction comparison plus the determinant explanation.
The two sign choices now have a unified Clifford-class reading, with their
fixed-coordinate distinction retained. No unexplained scalar or local review
issue remains. Arbitrary full-gate lifts, exact Clifford-aware synthesis costs,
large-prime recurrence and unrestricted preparation remain the mathematical
questions already stated in the manuscript; this editorial pass does not claim
to settle them or allocate successor work.

## Remaining submission gates

Author metadata and standalone archival packaging with an immutable locator remain.
The style guide's blind before/after specialist and adjacent-reader comparison has
not been performed; neither internal agent report substitutes for it. No external
acceptance, publication, mirror synchronization or Lean coverage is claimed.
