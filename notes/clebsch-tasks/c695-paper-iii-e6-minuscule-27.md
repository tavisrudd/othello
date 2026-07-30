# C695 — Paper III \(E_6\) minuscule \(27\)

**Lane:** `clebsch`

**Opened:** 2026-07-29

**Status:** complete; full operator-derived \(27\), minuscule dictionary, and
row-swap classification proved in
`notes/2026-07-29-c695-e6-minuscule-27.md`.

## Objective

Complete C682's operator-theoretic Schläfli double-six to the full
twenty-seven-line configuration and identify it with the
\(A_1\times A_5\) branching of the minuscule \(E_6\) representation
\[
27=(2\otimes6^\vee)\oplus\bigwedge\nolimits^2 6.
\]

Here \(A_1,A_5\) denote Dynkin types.  The finite icosahedral \(A_5\)
enters only after restriction through its six-axis permutation module.

## Work package

1. Starting from C682's six pairs \(E_i,E_i'\), construct the fifteen
   complementary lines \(L_{ij}\) intrinsically from the same
   transvectant/apolar data.
2. Prove the complete twenty-seven-line incidence relation and give the
   exact equivariant dictionary
   \[
   \{E_i,E_i'\}\leftrightarrow2\otimes6^\vee,\qquad
   \{L_{ij}\}\leftrightarrow\bigwedge^2 6.
   \]
3. Test whether the apolar-polar row swap is the Weyl involution of the
   \(A_1\) factor.  Treat identification with the outer automorphism
   exchanging \(27\) and \(27^\vee\) as a separate kill test.
4. Compare the resulting special Clebsch locus with the
   \(A_1\times A_5\) maximal-subgroup branch excluded by generic
   \(E_6\)-monodromy in Krämer--Litt--Maculan,
   arXiv:2604.20970.
5. If the construction closes cleanly, propose the smallest Paper III v2
   theorem or cliffhanger that states it without importing the cubic
   threefold monodromy machinery.

## Acceptance

A positive result requires explicit formulas or an invariant construction,
the full incidence table, and an exact representation-theoretic
identification.  A dimension match \(12+15=27\) alone does not pass.

A negative result must identify precisely why C682's twelve operator lines
do not canonically determine the remaining fifteen in the chosen
Mukai--Umemura/Clebsch model.

## Boundaries

- Do not conflate the algebraic group \(E_6\), the Weyl group \(W(E_6)\),
  and the Kleinian/McKay \(E_8\) appearing elsewhere in C682.
- Do not reopen or delay frozen Paper III v1.
- Run a targeted novelty audit before any manuscript-facing priority claim.
- Any finite incidence claim needs a committed exact replay and independent
  check under the research-reproducibility rules.

## Starting sources

- `notes/2026-07-28-c682-operator-schlafli.md`
- `notes/2026-07-29-c690-paper-i-rigidity-upgrades.md`
- Krämer--Litt--Maculan, arXiv:2604.20970, especially the
  \(A_1\times A_5\) branching \(27=12+15\)
