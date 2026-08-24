# C954: dual failure thresholds for bounded linear recovery

**Lane:** `complete-ports`

**Date:** 2026-08-24

**Status:** COMPLETE; theorem, literature, manuscript, release, and repaired
fresh-cold-read gates pass

## Result

Let (K_P\subseteq D_P\leq\mathbb F_q^J) be the nested code pair associated
with a target set, let (ell=\dim(D_P/K_P)), let (H\subseteq J) be the
surviving helpers, and put (F=J\setminus H).  The exact pointwise identity is

\[
 \ell-\dim\bigl(W_P\cap\operatorname{span}(G_H)\bigr)
 =\dim(K_P^\perp\cap\mathbb F_q^F)
  -\dim(D_P^\perp\cap\mathbb F_q^F).
\]

Therefore, for (1\leq t\leq\ell),

\[
 M_t(K_P^\perp,D_P^\perp)
 =\min\left\{|F|:
 \dim\bigl(W_P\cap\operatorname{span}(G_{J\setminus F})\bigr)
 \leq\ell-t\right\}.
\]

Thus the dual-pair relative generalized Hamming weight is the minimum number
of helper failures leaving at least (t) target dimensions ambiguous.

This is not a relative Wei-duality theorem.  In general, the RGHW hierarchy of
a nested pair does not determine the RGHW hierarchy of its dual pair.  The
input is the pointwise shortening--puncturing identity; the paper-specific
step is its recovery interpretation through the associated nested pair.

## Proof audit

For any (C\leq\mathbb F_q^J), puncturing onto (F) gives

\[
 \dim C-\dim(C\cap\mathbb F_q^H)
 =\dim(C|_F)
 =|F|-\dim(C^\perp\cap\mathbb F_q^F).
\]

Subtracting the instances (C=D_P) and (C=K_P), then using
(dim D_P-\dim K_P=ell) and the exact-sequence interpretation of the
recovered subspace, proves the pointwise identity.  If the displayed dual
relative dimension is at least (t), a (t)-dimensional subspace of a complement
to (D_P^\perp\cap\mathbb F_q^F) inside
(K_P^\perp\cap\mathbb F_q^F) is supported on (F); conversely every
RGHW witness is supported on a failed set attaining that relative dimension.
This proves the minimum-failure formula with no monotonicity or dual-hierarchy
assumption.

An ephemeral binary sanity check tested the pointwise identity and threshold
formula on 30,240 survivor/failure sets across random nested pairs of lengths
two through seven.  It passed.  The manuscript claim depends only on the
human proof above; the check is not paper evidence and no reproducibility
claim is made for it.

## Literature audit

**Read-depth summary:** zero sources were newly read at full-text depth; three
primary sources were read partially at the exact sections listed below.  This
audit establishes attribution and guards against a false duality claim.  It
does not make a novelty or priority claim.

- **Partial:** Luo, Mitrpant, Vinck, and Chen, *Some New Characters on the
  Wire-Tap Channel of Type II*, published IEEE version.  Read Lemma 1 and
  Theorem 2 with their proofs and the definitions of RDLP and inverse RDLP.
  These give the shortening/projection identity and its nested-code profile
  form.  Cache key `10.1109/TIT.2004.842763`; SHA-256
  `eecbc9e01441c1a6955eeb60d17536856957c9d8b3b5ce110dbd1226d9276fd1`.
- **Partial:** Geil, Martin, Matsumoto, Ruano, and Luo, *Relative generalized
  Hamming weights of one-point algebraic geometric codes*, arXiv preprint.
  Read the information-leakage derivation, equations (1)--(3), and the RGHW
  and RDLP definitions.  Equation (2) states the pointwise dual identity used
  here.  Cache key `arXiv:1403.7985`; SHA-256
  `25e31e23e4238ae33a08b4730c558fe071861a87c6e4fc0e1161d4bbcda581e7`.
- **Partial:** San-José, *An algorithm for computing generalized Hamming
  weights and the Sage package GHWs*, arXiv preprint.  Read Theorems 2.3--2.8
  and Example 2.10.  Example 2.10 proves that equal RGHW hierarchies need not
  give equal dual-pair RGHW hierarchies, so “relative Wei duality” would be
  false here.  Cache key `arXiv:2503.17764`; SHA-256
  `98bebce176b7f711a90f6a2ba0224dd77e4883eb0939c8aca237d571e9d1654b`.

### One-month delta screen

The official arXiv API was queried over 2026-07-24 00:00 through 2026-08-24
23:59 with `start=0` and `max_results=50`.  The exact searches and returned
counts were:

1. `all:"relative generalized Hamming weight" AND submittedDate:[202607240000 TO 202608242359]` — 0;
2. `all:"relative dimension length profile" AND submittedDate:[202607240000 TO 202608242359]` — 0;
3. `(all:"nested code pair" OR all:"relative generalized weights") AND (all:erasure OR all:ambiguity OR all:recovery) AND submittedDate:[202607240000 TO 202608242359]` — 0.

The API returned valid Atom responses with explicit zero `totalResults`, not
errors.  MathSciNet and Google Scholar were not covered.  Because the
manuscript attributes the identity as established mathematics and makes no
absence claim, those access gaps do not gate this upgrade.

## Manuscript and trust boundary

The manuscript adds Proposition `prop:dual-failure-threshold` after the
relative dimension/length profile.  Its coverage is `absent`; the paper-local
Lean package still proves only the associated exact sequence.  The claim
manifest now has 18 statements: one Lean-complete statement and 17 human-only
statements.  No formal coverage was inferred from the exact sequence.

The prior C948 report incorrectly called the input “relative Wei duality.”  Its
Section 8 now states the pointwise shortening--puncturing identity and records
the San-José counterexample to hierarchy-level dual determination.

## Validation

- `make update-pdf`: PASS, 18 pages, warning-free, 18 claims, four Lean terminals;
- `make check`: PASS with deterministic tracked-PDF identity;
- fresh independent manuscript cold read: PASS after repairing one misuse of
  “complement”; the repaired proof, citations, terminology, manifest boundary,
  and rendered integration all passed reread.

## Post-close local export

Authority commit `8dcd6d591` was audited and synchronized through
`papers/scripts/export-paper-repos.py` to the existing standalone repository.
The mirror release gate passes with 18 warning-free pages, 18 claims, and four
Lean terminals; exporter verification reports 40 tracked files derived from
the same authority commit.  The forward mirror commit is `171da01`.  No push,
tag, deposit, or submission was performed.

## Mystery ledger

### Settled

- The complement is (F=J\setminus H), and the dual pair is ordered
  (D_P^\perp\subseteq K_P^\perp).
- The threshold uses relative dimension at least (t), which is equivalent to
  an RGHW witness by taking a complement; no equality-level gap remains.
- The result is pointwise shortening--puncturing duality, not relative Wei
  duality.
- The upgrade uses established coding-theory terms and introduces no named
  invariant.

### Open

- C955 owns the coefficient-presentation spectrum: for fixed
  (K_P\subseteq D_P) and target dimension, characterize the attainable
  values of (d(I^\perp)) and hence the attainable additive confinement
  thresholds.
