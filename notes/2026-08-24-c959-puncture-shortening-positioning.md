# C959: puncturing--shortening identification and theorem positioning

**Lane:** `complete-ports`

**Date:** 2026-08-24

## Result

For the target/helper split (E=P\sqcup J), the manuscript's associated
nested pair is literally
\[
 K_P=\operatorname{short}_J(I^\perp)
 \subseteq
 D_P=\operatorname{punct}_J(I^\perp).
\]
Indeed, (a\in D_P) exactly when some (p\in\mathbb F_q^P) makes
\((p,a)\in I^\perp=\ker(G_P\mid G_J)\), while (a\in K_P) exactly when
\((0,a)\in I^\perp\). Consequently the pair depends only on the inner code
and the target/helper split; changing the row basis of a generator matrix does
nothing to it. Standard puncturing--shortening duality also gives
\[
 D_P^\perp=\operatorname{short}_J(I),
 \qquad
 K_P^\perp=\operatorname{punct}_J(I).
\]
Thus the failure-side nested pair is formed directly from the primal inner
code.

This identification fixes the paper's novelty boundary. The equation
\(\mu_t(P)=M_t(D_P,K_P)\) is the standard nested-code RGHW support invariant
specialized to the pair induced by a target/helper split, together with an
explicit normalized-recovery correspondence. The paper's principal results
are instead:

1. exact arbitrary-rank transfer after the finite outer-dual-distance gate,
   with threshold (M_t(D_P,K_P)+d(I^\perp)) and preservation of normalized
   equations and exact supports; and
2. the exact ungated finite rank-one formula over all outer-functional fibers,
   with the Singer construction proving that it can decide transfer when the
   ordinary support-distance gate cannot.

The coefficient-presentation separation now says precisely that different
ambient inner-dual realizations of one abstract nested pair can have different
values of (d(I^\perp)). It no longer suggests that a row-basis change of one
fixed code changes the pair.

## Manuscript changes

- Added `prop:puncture-shorten-pair`, including the dual identities above.
- Rewrote the abstract, introduction, README, metadata, conclusion, theorem
  map, proof ledger, reviewer guide, claim manifest, and portfolio summary to
  use the canonical description.
- Added the trace-pairing argument identifying the functional dual with
  (O^\perp), rather than leaving its nondegeneracy step implicit.
- Made the random-outer-family existence argument explicit at the two
  first-moment exponents.
- Shortened the MDS reconstruction result to its coefficient-layer content.
- Kept the verification section before the conclusion so that the paper ends
  with its mathematical synthesis; its prose explicitly marks the new
  puncturing--shortening proposition, weighted theorem, and Singer strictness
  construction as human-only.
- Corrected the C957 literature-audit read-depth count from two partial primary
  sources to the three sources actually listed there.

No hypothesis, reliability polynomial, transfer threshold, positive-density
claim, or formal-coverage status was strengthened by editorial wording.

## Literature audit

**Read-depth summary for C959:** zero sources were newly read at full-text
depth; one primary source was read partially. The earlier exact-transfer and
one-month searches are recorded in C948 and C957. C957 has three partial
primary-source reads and an explicit 2026-07-24 through 2026-08-24 arXiv delta
screen.

- **Partial, published version:** Kurihara, Uyematsu, and Matsumoto, *Secret
  Sharing Schemes Based on Linear Codes Can Be Precisely Characterized by the
  Relative Generalized Hamming Weight*, IEICE Transactions on Fundamentals
  E95-A (2012), 2067--2075, DOI `10.1587/transfun.E95.A.2067`. Read the
  abstract and introduction, Sections 2.1--2.2 and 3.1--3.2, including the
  RDLP/RGHW threshold statements. These portions establish that exact
  information and reconstruction thresholds for nested linear-code secret
  sharing are already characterized by RDLPs and RGHWs. Cache key
  `10.1587/transfun.E95.A.2067`; SHA-256
  `fb9ff1882908f58735fed34c85cafb1f53dfac0effc90b84b7a487fe368827d8`.

Two final web searches were used only as an orientation check, not as an
exhaustive priority negative:

1. `"relative generalized Hamming weight" puncturing shortening concatenated code recovery target helpers`;
2. `"puncturing" "shortening" "relative generalized Hamming weights" local recovery concatenation`.

Their returned pages surfaced standard RGHW, secret-sharing, and code-pair
puncturing literature, but no item combining the canonical target/helper pair
with the manuscript's coefficient-level exact concatenation theorem. This
limited check licenses no standalone absence claim. MathSciNet, zbMATH, and
Google Scholar were not covered by C959; the manuscript makes no claim that
would require a new exhaustive negative beyond the recorded C948/C957 audits.

## Verification and anti-smuggling audit

The authority release gate passes with 21 pages, no TeX warnings, 21 registered
claims, and four Lean reviewer terminals. The tracked PDF is byte-identical to
a deterministic rebuild. The formal claim map marks the new
puncturing--shortening proposition absent; only the elementary exact-sequence
statement remains Lean-complete.

The new proposition is proved directly from (I^\perp=\ker G) and standard
puncturing--shortening duality. The trace-duality expansion uses only
(L\)-linearity and nondegeneracy of the finite-field trace pairing. The random
outer-family paragraph prints both expectation exponents. No computation,
certificate, genericity assumption, hidden nonzero projection, or formal claim
is used to carry these changes.

## EJ and TT closeout

The cheap unifying consequence was the dual identity
\((D_P^\perp,K_P^\perp)=(\operatorname{short}_J(I),
\operatorname{punct}_J(I))\). It was added because it makes the failure-side
hierarchy canonical without introducing terminology.

The theorem-scope reread found no remaining conflict among the finite gated,
eventual, and ungated rank-one quantifiers. The abstract states the nonzero
target-block projection required by the ungated theorem. The coefficient
separation concerns different ambient inner codes, not a row-basis change.

## Mystery ledger

- **Settled in C959:** whether the associated pair depends on a represented
  generator matrix. It does not; it is the literal shortening--puncturing pair
  above.
- **Settled in C959:** whether the dual failure hierarchy has an equally native
  description. It is the shortening--puncturing pair of the primal inner code.
- **Open under C955:** classify how the additive confinement spectrum varies
  over ambient inner-dual realizations of a fixed abstract nested pair.
- **Open under C957's successor programme:** obtain an arbitrary-rank analogue
  of the ungated weighted finite formula. This requires a higher-rank outer
  functional optimization and is not used by the present paper.

No other task-owned mystery remains.

## Export status

Authority and standalone commit identities are recorded after synchronization.
