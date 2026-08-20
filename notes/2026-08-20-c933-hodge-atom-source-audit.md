# C933 Hodge-atom specialization source audit

**Date:** 2026-08-20

**Lane:** `cubic-threefolds`

**Scope:** the strictly one-step companion
`papers/hodge-atom-marker-ledger/`

## Verdict

The standard Hodge atom is an exact specialization of an
occurrence-indexed marker ledger once three levels are kept distinct: a local
spectral-cover component, its geometric atomic (F)-bundle, and its abstract
class after the elementary equivalences.  The companion can prove the
occurrence expansion, presented thin groupoid, free commutative-monoid fold,
dimension filtration, and weak-factorization obstruction internally.

The geometric provider record remains imported: spectral decomposition,
blowup decomposition, and projective-bundle decomposition.  The companion
will cite those inputs at theorem level and will not claim to reprove the
non-archimedean quantum comparison.  It also will not use the source's
unproved formal-type constancy remark or attach primitive-sixth monodromy to a
Hodge atom.

Four sources are characterized below.  None was read cover to cover for this
audit; all four were read partially at the exact locators stated.

## Source record

| source | read depth and access | exact use |
|---|---|---|
| L. Katzarkov, M. Kontsevich, T. Pantev, and T. Yue Yu, *Birational Invariants from Hodge Structures and Quantum Multiplication*, arXiv:2508.05105v2 | **Partial.** Cached PDF and text, key `arXiv:2508.05105`, SHA-256 `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64`; Sections 4.1--4.3, 5.2.1--5.4 read.  The arXiv record was rechecked on 2026-08-20 and still lists v2, revised 2026-03-06. | Theorem 4.1; Theorems 4.5 and 4.11; Definition 5.10; Sections 5.2.3--5.2.6; Definitions 5.16 and 5.21; Propositions 5.17, 5.22, and 5.30. |
| H. Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3 | **Partial.** Cached PDF, SHA-256 `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`; Theorem 5.18 and the coefficient statements listed in the C930 QDM audit read there. | Primary geometric source underlying the blowup provider cited by Katzarkov--Kontsevich--Pantev--Yu. |
| H. Iritani and Y. Koto, *Quantum cohomology of projective bundles*, arXiv:2307.03696v4 | **Partial.** Cached PDF, SHA-256 `5139f8e0c9d46f8ccb8cb415396a0fb1fb357719b7dcfbca46234a9735b57624`; Theorem 5.1 and Remarks 5.2--5.3 read in the C930 QDM audit. | Primary geometric source underlying the projective-bundle provider cited by Katzarkov--Kontsevich--Pantev--Yu. |
| D. Abramovich, K. Karu, K. Matsuki, and J. Wlodarczyk, *Torification and factorization of birational maps*, JAMS 15 (2002), 531--572 | **Partial.** Published paper, Theorem 0.1.1, as checked for the C930 theorem graph. | Projective weak factorization with smooth centers. |

## Exact type map

For a smooth projective (X), the source starts with the finite set
(pi_0(\widetilde U_X)) of connected components of the reduced unramified
Euler spectral cover and assigns a positive degree (m_X(a)) to each
component.  The companion replaces this weighted set by the occurrence set

\[
 \operatorname{Occ}(X)=
 \{(a,j):a\in\pi_0(\widetilde U_X),\ 1\le j\le m_X(a)\}.
\]

Disjoint-union, blowup, and projective-bundle decompositions give bijections
of occurrence sets.  Their generated equivalence relation determines a thin
groupoid (Pi_{mathrm{Hdg}}).  Its set of connected components is the
source's abstract Hodge-atom set, while

\[
 \mathcal L_{mathrm{Hdg}}
 =\operatorname{Sym}^{\sqcup}(\pi_0\Pi_{mathrm{Hdg}})
\]

is the occurrence ledger.  The chemical formula of (X) is the image of
(operatorname{Occ}(X)) in this free commutative monoid.

This identifies the formalism without identifying abstract Hodge atoms with
geometric atomic (F)-bundles.  Proposition 5.22 supplies only a map from the
former to the latter; no injectivity statement is available or needed.

## Internal and imported proof boundary

The companion proves internally:

1. expansion of multiplicities into occurrences;
2. descent through the generated thin groupoid;
3. the universal commutative-monoid fold;
4. the three chemical-formula identities from the provider bijections;
5. descent of carrier height and the dimension filtration;
6. the weak-factorization non-rationality criterion; and
7. its rank-two projective-bundle, hence one-step, specialization.

The companion imports only the existence and compatibility of the geometric
provider bijections.  It makes no assertion about two or more projective
stabilizations and does not use the decorated cubic formal-monodromy route.

## Point-of-use requirements

- Cite Katzarkov--Kontsevich--Pantev--Yu Definition 5.10 where local Hodge
  atoms and multiplicities are introduced.
- Cite their Theorems 4.1, 4.5, and 4.11 at the provider record.
- Cite their Definition 5.16 and Proposition 5.30 only after the companion's
  abstract quotient and filtration have been constructed.
- Cite Iritani Theorem 5.18 and Iritani--Koto Theorem 5.1 as the primary QDM
  inputs behind the corresponding provider clauses.
- State explicitly that the geometric atomic (F)-bundle set of Definition
  5.21 is a different quotient and that Proposition 5.22 need not be
  injective.
- Refer to the epilogue's direct-QDM atom only as a sibling specialization of
  the common marker-ledger theorem.

## Boundary

This is a source and typing audit, not a novelty search.  It makes no absence
claim.  No unreachable intended source remains for the statements assigned
to the companion.
