# C577 — Paper II newer-math audit

**Lane:** `clebsch`

**Date:** 2026-07-31

## Verdict

The C694 v2 arc is not yet release-ready under the repository's current
proof standard.  The finite evidence, trust partition, and the
hyperplane-square Lean theorem are well delimited, and no computational
counterexample or formal mismatch was found.  The load-bearing all-\(q\)
classification nevertheless depends on three human identifications that the
manuscript states but does not prove at referee depth:

1. the projective--trade bridge from a nonprincipal head of the sheet module
   to the quadratic moment kernel or an outer-parity splitting;
2. the modular-Hermite/Lucas-socle rule, including the claim that it computes
   the finite-group Hom space rather than only possible composition factors;
   and
3. the adjacent-wall identification that makes the \(R\otimes T\) correction
   unique and forces its simultaneous nonzero trace and \(Y\otimes R\) spill.

The generic first-wall programs intentionally verify formulas conditional on
the second and third identifications.  The trust manifest says so accurately.
That honesty prevents a trust overclaim, but it does not replace the missing
human proof.  Theorem~`thm:balanced-orbit-completeness`, and hence clause
(ii) of the main theorem, must remain blocked until those bridges are expanded
into a complete argument or imported from precise published results.

## Literature audit

This audit names two sources, neither read at full text; both were read
partially from cached primary-source PDFs.  No novelty or priority negative is
issued, so no forward-citation closure is claimed.

- Michael Giudici, *Maximal subgroups of almost simple groups with socle
  PSL(2,q)*, arXiv:math/0703685 (2007).  **Read depth: partial** — cached
  preprint, Section 2, Theorem 2.2 and Lemma 2.3.  Cache key
  `arXiv:math/0703685`, SHA-256
  `2c829b573dadf9ee2c71a9f85f92e1fb2d7443f64242dbe4a829c6246d9ae8e9`.
  Theorem 2.2 supports the maximal-subgroup list used after (3.2k), and
  Lemma 2.3 supports fusion of the paired exceptional classes by the outer
  diagonal automorphism.  It does not supply the modular head, Lucas-socle,
  projective--trade, or adjacent-wall assertions in the preceding lemma.

- Gonzalo Rodríguez-Pajares, Diego Ruano, and Flavio Salizzoni,
  *A combinatorial description of when a self-associated set of points fails
  to be arithmetically Gorenstein*, arXiv:2512.16766v1 (2025).
  **Read depth: partial** — cached v1 preprint, Theorem 3.11 and Corollaries
  3.12--3.13.  Cache key `arXiv:2512.16766`, SHA-256
  `9dc89d58c45537bdd3d7844903da5de7d4d55aef9550dd6ddba36064c03882ca`.
  These results support the manuscript's contextual statement that the
  Schur-square defect of a self-dual code equals its block/decomposability
  defect and that indecomposability is equivalent to arithmetic
  Gorensteinness for the associated point set.  The manuscript citation now
  pinpoints these results.

The new all-\(q\) proof also invokes modular Hermite reciprocity,
Lucas-separated socle embeddings, and an adjacent dual-Weyl wall without a
public citation.  They may be original arguments, but in that case the paper
must prove them fully.  If they are imported, the release pass must identify
the exact source and theorem.  The present audit did not locate or verify such
an antecedent, and therefore licenses no absence claim.

## Trust-ledger audit

The thirteen evidence bundles are separated by semantic role, carry tracked
checksum manifests, and give independent replays for the new generic-wall,
q=9, radial, and Gorenstein calculations.  The claim map correctly assigns:

- `generic-first-wall` and `small-field-trade` to the all-\(q\)
  classification;
- `shared-radial` to the common alternating-cycle lemma; and
- `gorenstein-gate` plus the abstract hyperplane-square implication to the
  cubic/Gorenstein arc.

The ledger's boundary that the generic checker is conditional on the
Lucas-socle and adjacent-wall theorems is exact.  The q=9 bundle is exhaustive
only at q=9, and the q=13,17,19 rows are correctly marked as cross-checks.
The manuscript verification table now names the q=9 replay explicitly and
identifies the kernel-checked hyperplane-square implication.

One limitation remains structural rather than metadata-level: assigning
`certificate` to the classification theorem records genuine local evidence,
but the certificate cannot discharge its human identification seams.  The
current boundary text prevents a literal overclaim, so the ledger need not be
relabelled; release readiness depends on repairing the proof.

## Lean audit

`RelativeConicArcs.HyperplaneSquare.cubicAnnihilator_eq_zero` matches the
paper's full-support quadratic-annihilator lemma: it is field-generic, assumes
a unital nonconstant function space and a full-support quadratic annihilator
line, and proves that every cubic annihilator is zero.  Its source contains a
self-contained mathematical header and docstring and uses no axioms beyond
the release allowlist.

The Paper II gate also exposes twenty-three arithmetic-gluing terminals and
two Hilbert-symmetry terminals.  The verification prose correctly says that
the Hilbert gate is a retained v1 check and is not used by the v2 Gorenstein
proof.  Lean does **not** formalize the all-\(q\) projective--trade bridge,
Lucas-socle theorem, first-wall identifications, shared Dickson recurrence, or
maximal-isotropic Gorenstein argument.  The paper does not claim otherwise.

The verification introduction previously defined Lean support as a “finite
implication,” which was false for the abstract hyperplane-square theorem.
That wording is repaired to “stated implication.”

## Repairs made

- Corrected the stale references (3.2l), (4.8), and (4.10) to (3.2i),
  (4.6b), and (4.6d).
- Added the theorem-level pinpoint for the 2025 self-dual-code criterion.
- Added the exhaustive q=9 replay and kernel-checked hyperplane-square
  implication to the verification table.
- Corrected the verification README so all three Lean gates are named.
- Replaced the stale handoff command `./scripts/verify-all.sh`, which does
  not exist in the Paper II package, by the actual aggregate entry point
  `python3 verification/verify_release.py`.

These are editorial and trust-surface repairs.  They do not close the
all-\(q\) proof-depth blocker.

## Validation

- Authoritative and standalone metadata gates pass with 26 statement
  identities and 13 evidence bundles.
- Both thirty-page PDFs rebuild successfully, and targeted warning scans are
  empty.
- The authoritative and standalone TeX and verification README files are
  byte-identical; each repository regenerated its statement identity and PDF.
- A fresh targeted elaboration of
  `RelativeConicArcs.Gates.ClebschHyperplaneSquare` did not finish within
  the bounded wait budget and was stopped.  No Lean source or gate changed in
  this audit.  The pinned C694 aggregate result remains the last full
  elaboration evidence; this audit's Lean verdict comes from exact source and
  theorem-interface review, not from claiming a new completed run.

## Mystery ledger

| feature | status | exact gap or gate |
|---|---|---|
| all-\(q\) first-wall formulas | computationally settled conditional on the human identifications | C746 owns projective--trade; C747 owns Lucas-socle and first-wall non-splitting; C748 integrates and cold-reads; C749 attacks and freezes the final human proof |
| q=9 endpoint | settled | exhaustive primary and independent generator replay |
| common \(B_3/H_3\) radial mechanism | settled at the paper's claimed two configurations | human Dickson recurrence plus independent exact replay |
| maximal-isotropic Gorenstein pairing | no defect found | complete human proof in the manuscript; finite ideal/socle replay is independent support |
| hyperplane-square implication | settled | exact Lean theorem and short human proof agree; C750 owns the remaining all-\(q\) formal closure after all four human rounds |
| historical priority of the v2 classification | deliberately unresolved | no priority wording and no absence verdict |

Vibe check: the evidence engineering is strong and unusually candid, but the
headline all-field theorem currently outruns the written proof.  This is a
repairable theorem-exposition problem, not evidence of a false result.
