# C799 — Paper III aligned-design Lean closure

**Lane:** `clebsch`

**Status:** complete; normalized seven-point classifier, symbolic third-point
disambiguation, overlap consistency, query count, conference transport,
forty-seven-declaration audit, both formal replays, and paper release gate are
green; shared aligned-design API handed to C815

## Objective

Close the formal gap around Paper III's aligned-design reverse theorem.  Give
kernel-checked statements matching the manuscript's labelled two-graph
faithfulness theorem, its selected-query decoder, and the conference-signing
corollary, without turning finite search or an implementation into the claimed
proof.

## Scope

1. Formalize two-graphs as triangle bits satisfying the four-set parity law and
   define aligned four-sets and global complementation.
2. Formalize rooted graph reconstruction and the Ramsey anchor reduction on
   seven vertices, reusing the existing rooted triangle declarations where
   their types match the paper.
3. Prove the seven-point cut-signature lemma, including the balanced-cut pair
   ambiguity and its elimination by the third outside point.
4. Globalize by connected overlap of seven-subsets and prove faithfulness for
   every finite labelled vertex set of cardinality at least seven.
5. Formalize the anchor-relative selected family, prove the exact count
   `3*n^2 - 23*n + 45`, and prove deterministic anchor discovery in at most
   twenty aligned-four-set tests.
6. Transport the theorem to symmetric conference signings using
   `det C[Q] = 3 - 2*w(Q)`, with switching, global negation, and one calibrated
   triangle product stated exactly.
7. Extend the Paper III import-only gate, axiom audit, source hashes, formal
   map, trust row, and paper-local replay.  Preserve an explicit human boundary
   for any classical Ramsey or finite-cardinality fact imported rather than
   proved in the package.

## Dependency and boundaries

C792 owns the final wording and must freeze the human theorem before this task
freezes Lean interfaces.  C799 may tighten that proof if formalization exposes
a missing case, but it does not add noisy recovery, testing, coding, privacy,
ETF, physical, or higher-moment material to Paper III.

## Acceptance

The formal statements correspond line by line to the frozen manuscript theorem;
the seven-point ambiguity elimination and quadratic query count are no longer
human-only; every declaration in the paper-facing closure has a complete axiom
audit and referee-ready prose; the guarded shared aggregate gate and both
paper-local formal replays pass; and the trust manifests claim neither more nor
less than the elaborated theorem package.

Acceptance passed.  The exact result, trust boundary, replay commands, hashes,
and closeout ledger are recorded in
`notes/2026-08-02-c799-paper-iii-aligned-design-lean-closure.md`.
