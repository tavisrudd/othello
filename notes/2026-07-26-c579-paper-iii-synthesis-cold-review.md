# C579 Paper III synthesis and cold review

**Lane:** `clebsch`

**Date:** 2026-07-26

## Verdict

Paper III is a coherent twelve-page two-leg candidate:

1. the rational Hitchin incidence cover has square class \(5J_0\), becomes
   the constant golden torsor on the nonbranch Clebsch chart, and its
   explicit golden fibre and exchanger have the proved specialization at
   \(11\); and
2. the same integral Clebsch cubic line is the four-channel restriction of
   the degree-six Gaunt--Steinhardt invariant.

The cold review is `GO`.  It found one material scope defect in the entering
draft: “the Hitchin deck exchange reduces modulo \(11\)” could be read as a
global good-reduction theorem for the geometric incidence cover, although
C653 proves that comparison only over an unspecified cofinite base.  The
paper now states the exact result: the displayed golden fibre and integral
exchanger have good reduction at \(11\).  The abstract, main theorem,
conclusion, trust ledger, and verification guide all carry this boundary.

The review also removed the stale target/gate/Klein language, defined the
harmonic \(F_y\) in the page-one theorem, supplied the spherical-moment
formula behind the exact Gaunt scalar, mapped the main theorem and the
\(A_4\) hinge into the trust ledger, and removed the unused Klein
bibliography.  The main theorem is on page 1.

## Human proof and exact-audit boundary

Human mechanisms carry the paper:

- the golden fibre fixes the rational square class of Hitchin's known
  degree-two cover;
- localization at an odd cubic explains why orientation forgetting is
  generically quadratic;
- the \(A_5\) character decomposition and uniqueness of the cubic invariant
  reduce the finite tensor bridge to one scalar;
- the cubic through both golden configurations forces the common \(A_4\)
  stabilizer;
- the reflection factorization of the exchanger gives its nonsquare spinor
  class; and
- the Petersen spectrum, uniqueness of the invariant cubic, and the
  displayed spherical-moment formula prove the harmonic restriction.

Certificates are restricted to exact audits of explicit matrices, finite
carriers, contractions, and arithmetic constants.  The aggregate release
gate does not run Lean.  The existing
`RelativeConicArcs.ClebschTensorBridge` terminal is documented only as an
optional check of the final literal \(4^3\)-tensor equality; it is not a
premise of the theorem or release decision and does not formalize the
geometric or representation-theoretic argument.

## Trust surface

The release surface consists of:

- nine frozen theorem-like statements in
  `papers/clebsch-passages/verification/statement_identity.json`;
- twelve claim rows in
  `papers/clebsch-passages/verification/trust_manifest.json`;
- the C651 finite-tensor primary calculation and independent replay;
- the C652 arithmetic-cover primary certificate, independent replay, and
  checksum gate;
- the C655 harmonic primary certificate, independent replay, and checksum
  gate; and
- a warning-free manuscript build checked by the aggregate runner.

The empirical descriptor row `PH-4` remains inventory and is not a premise
of the main theorem.

Run from `papers/clebsch-passages/`:

```text
python3 verification/verify_release.py
```

The clean replay reports thirteen `PASS` lines followed by
`Paper III release: ALL CHECKS PASS`.  It checks theorem identity, ledger
coverage, three independent exact evidence pairs, evidence hashes, and the
manuscript build.  It does not prove a global integral incidence comparison
at \(11\), an integral equality of the characteristic-zero and finite-field
normalizations, or empirical utility of the harmonic descriptor.

## Frozen artifact fingerprints

| artifact | bytes | SHA-256 |
|---|---:|---|
| `verification/extract_statement_identity.py` | 4,489 | `be6bf5dfd823d7a866f4f1d5015208a6dc734a1c1079ae59e962688a22e91020` |
| `verification/statement_identity.json` | 9,787 | `b2b78fefdbb5bb3410e873ada6876ba8ab10862138ca80137bb2538e2a14121b` |
| `verification/trust_manifest.json` | 8,427 | `373545b191a24eb287f147e2f93912fd328908cf4a56acf76a862c783f325b60` |
| `verification/verify_release.py` | 3,893 | `fb802afe3566c60a2de527a039a2f879c7352ebd57abc8323e4b378476375012` |
| `clebsch_passages.pdf` | 116,259 | `ba95b57bf7267e0ea9b4c052972eb30118583e91a68f6eec468bbdf56c126923` |

These fingerprints describe the final pre-commit replay.  The evidence
bundles retain their own committed checksum manifests and independent
reproduction commands.

## Extra-juice and Tao closeout

The cheap theorem upgrade was to remove the normalization-dependent scalar
\(4\) from the headline while retaining it in the exact finite bridge
theorem.  The page-one result now asserts the invariant line, which is the
cross-characteristic content; the denominator divisible by \(11\) prevents
a stronger scalar comparison.

The same pass made the harmonic scalar independently human-recoverable from
the displayed axes and the standard even-monomial moment formula.  This
keeps the mechanism in the proof and leaves the two implementations as
audits.

## Mystery ledger

- **Settled:** the two paper legs meet on
  \(\langle\sigma_3\rangle\), not on a normalization that reduces through
  characteristic \(11\).
- **Settled:** the exact mod-\(11\) theorem concerns the explicit golden
  fibre and exchanger, so it does not assume a global integral Hitchin
  incidence model.
- **Settled:** the harmonic scalar has a direct human derivation from zonal
  harmonics and spherical moments.
- **Open but bounded in the paper:** the minimal bad-prime set for the
  geometric incidence comparison.  Closing it requires an explicit integral
  incidence compactification and normalization comparison.
- **Outside C579:** empirical utility of the four-channel descriptor and any
  cycle-theoretic relation to the Klein \(55\)-curve lattice.
- **No further task-owned mystery remains.**

## Vibe check

Good.  The former catalogue is now a short paper with one memorable cubic
line, two mathematically distinct realizations, and an unusually explicit
boundary between human proof, exact audit, and what is not claimed.
