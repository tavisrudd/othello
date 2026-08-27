# C973 third sprint closeout — arbitrary-digit Lucas structure

Date: 2026-08-26  
Status: 30-minute checkpoint; C973 remains active

## 1. Acceptance result

The sprint did not continue R-level enumeration.  It proved the requested
multi-digit structural upgrade:

- coupled least-digit exact sequences for every maximal Lucas carrier `C_d`
  and Pascal nucleus `Z_d`;
- an explicit finite filtration by determinant twists, divided powers, and
  Frobenius twists, determined by the base-`p` digits of `d=r-2`;
- exact carrier dimension, codimension, projective point count, and density;
- a closed classification of every empty-carrier redundancy; and
- nonsplitting whenever both rational-module sides of an exact sequence are
  nonzero.

The full proof is
`c973-2026-08-26-digit-stripping-exact-sequence.md`.  Commit `938c60e84`
contains its first accepted form; the final sprint additions are committed
with this closeout.
The convention, boundary, equivariance, endpoint, nonsplitting, and
coding-promotion seams pass the author-side hostile audit in
`c973-2026-08-26-digit-stripping-hostile-audit.md`.

## 2. Strongest theorem boundary

For `d=pD+a`, the carrier strips either to a Frobenius-twisted nucleus quotient
or, only when `a=p-1`, to a smaller carrier quotient.  The nucleus itself has a
parallel digit-stripping sequence.  Iteration terminates on the digits.

If `d=sum d_i p^i`, put `nu=product(d_i+1)` and let `eta` be the number of
consecutive nonzero runs in Pascal row `d`, given explicitly by the digit
product above the first non-`p-1` digit.  Then

```
dim C_d = d+2-nu-eta,
codim C_d = nu+eta.
```

For `d>=p`, the carrier is empty exactly when `d+1` or `d+2` has one nonzero
base-`p` digit.  At the simultaneous-marker threshold this gives the infinite
small-characteristic family

```
SplitFree_r(F_q) subseteq P_r(F_q).
```

This is a split-free theorem; deep-hole promotion still requires the separate
covering-radius gate.

## 3. Structural versus computational boundary

The theorem is structural.  Its universal quantifiers follow from Lucas'
identity and the exact translation/scaling/inversion action.  The bounded
checker is a regression/falsification aid only.  It covers primes through 13
and lower rows through 24, checks support partitions, triangularity,
rescalings, dimensions, empty-carrier classification, and the visible
nonsplitting leakage.

The q=49 R11/R12 result remains mixed in the previously documented way:
orbit reduction is structural, while seven locator-existence statements are
computationally certified and independently replayed.

## 4. Software and paper consequence

The software successor should add a typed digit-analysis prepass, not string
family identifiers.  The natural cases are `TensorSubmodule`,
`NucleusQuotient`, and `CarrierQuotient`, together with exact dimensions and
digit data.  No classification consequence may flow from a quotient until
pointed abundance is proved stable through the nonsplit extension.

The frozen-paper successor map now calls for one digit-stripping theorem, one
one-carry/characteristic-seven corollary, and supplemental q=49 certificates.
It explicitly avoids separate R11/R12/R13 sections.

## 5. ej + tt and mystery ledger

The `ej` pass completed the nucleus recursion, dimension/count formulas, and
empty-carrier classification.  The `tt` pass challenged the implicit direct-
sum picture; the upper-unipotent leakage proves the extensions are genuinely
nonsplit whenever both rational-module terms are present.

- Settled: arbitrary-digit carrier identification at the filtered-module
  level.
- Settled: exact empty-carrier redundancies and unresolved carrier density.
- Settled: direct-sum induction is unavailable in every nontrivial extension.
- Open: arithmetic transport of pointed shallow witnesses through nonsplit
  extensions; this is now the main mathematical gate.
- Open: independent representation-theory review and the previously recorded
  external review of the simultaneous-selector seams.
- Open: literature/priority audit against classical binary Weyl-module
  filtrations; `c973-2026-08-26-module-literature-preaudit.md` found likely
  classical predecessors at metadata/partial depth, so no novelty claim is
  made.
- Owner: C973 for mathematics; software and manuscript changes require
  separately allocated successors.

Vibe: the carrier geometry is organized; the remaining difficulty is honestly
arithmetic, not another missing digit calculation.
