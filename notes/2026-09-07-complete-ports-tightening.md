# Complete-ports: authorized tightening

Date: 2026-09-07. The user accepted the five cuts proposed after the literature
audit, allowing formal-verification details to move to companion documentation
or an appendix. This pass uses the companion documentation.

## Disposition

1. Removed the detailed measurement subsection, timing tables and benchmark
   graphic from the manuscript. Historical records and their versioned identities
   remain in the Ergodis evidence documentation and the paper's artifact manifest.
   The mathematical optimizer, running example, bilinear application and practical
   recovery-decision discussion remain.
2. Reduced formal verification to the exact sequence, the explicit limit of its
   coverage, the source-lowering/checker boundary and documentation pointers.
   Moved declaration names, toolchain/Mathlib identity and axiom details to
   `verification/README.md`; corrected the reviewer guide's destination link.
3. Deleted the programme-perspective coda.
4. Removed the bandwidth and adversity-catalog outlook from this paper's
   conclusion. Their development remains outside the manuscript's theorem chain.
5. Replaced the conclusion with two paragraphs and cut repeated explanations
   of labels, repricing, witness reconstruction and interface sufficiency from
   the optimization section. Retained qualifications that affect correctness.

Updated the paper README, reviewer guide, verification README and section map
to describe the shorter manuscript. The optional contextual proofs remain in
place: the user's accepted numbered cuts did not request their relocation.

## Validation

- Before: 45 pages. After: **40 pages**.
- All **62** theorem/proposition/lemma/corollary/proof environments compare
  byte-for-byte equal with authority commit `d42414dc6` across the section
  sources. No mathematical statement or proof was removed or rewritten.
- Deterministic `make update-pdf check`: PASS, 40 pages, warning-free,
  32 registered claims and four unchanged Lean terminals. The expected-page
  identity was updated to the measured count without relaxing any check.
- Visually inspected the changed optimizer opening, repair-decision discussion,
  verification/conclusion page and bibliography opening (pages 27, 31, 38, 39).
- No stale references to the removed benchmark table, programme coda or
  bandwidth paragraph remain in the manuscript and its reader guides.
- No Lean execution, benchmark rerun, change to the literature verdicts, or
  fresh referee assessment. The previous Astra reports refer to their stated
  earlier versions. No numerical referee assessments are recorded.
- PDF SHA-256:
  `2e50958b4a1f2710b50512cbb5d028aafcd75b607a8721b103c6cca2863c3e0f`.

## Closeout

The final editorial check found that the old Lean README did not itself list
all four declarations; the exact details were therefore preserved explicitly
in `verification/README.md` instead of merely asserting that they were already
documented. This settles the only documentation gap introduced by the cuts.
No new mathematical mystery arose. C325 and C953 remain open. Export identity
and the final mirror commit are recorded in the handoff archive after sync.
