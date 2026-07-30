# C611 — exterior-set mechanism and v2 disposition

**Lane:** `clebsch`

**Opened:** 2026-07-25

**Status:** active by explicit user selection; no Paper I v1 blocker.

## Objective

Seek a conceptual exterior-set arc mechanism behind the terminal
\(q=13,17,19\) behaviour, then route any earned result to Paper I v2 or its
actual owning paper.

## Entry state

- Paper I v1 already has its accepted theorem and exact terminal searches.
- C662 supplies the human partial-cover and saturation mechanism but stops
  one unit short at \(q=13\).
- C605 remains load-bearing for the terminal exclusions.
- C690 sharpens the q=13 endpoint: a terminal eight-arc exists if and only
  if the \(78\times78\) binary passant/internal incidence matrix has a
  weight-eight nullword. All nullwords have even weight, so the exclusion
  is exactly \(d\ge10\). C665's defining-characteristic transitive-sheet
  machinery does not reach this cross-characteristic support gate.
- The q=13 gate is now closed by the tangent-triple theorem in
  `notes/2026-07-29-c611-q13-tangent-triples.md`. Fixing one internal point
  gives a 42-vertex compatibility graph of clique number five, certified by
  six cyclic difference sets and a five-row unique-closure lemma. Hence a
  weight-eight nullword, which would require a local seven-clique, cannot
  exist. The extra-juice follow-up exhausts the two forced weight-ten
  passant-pencil profiles and constructs a dihedral weight-twelve word, so
  the exact distance is \(d=12\). The `ej2` pass classifies all \(364\)
  minimum words into one \(S_4\) and three \(D_{24}\) projective orbits.
  Pair concurrence in the minimum supports intrinsically reconstructs join
  type: \(7,9,12\) means passant and \(6,8\) means secant. The `ej3` pass
  uses triple-concurrence histograms to recover all six elliptic orbitals.
  Among the resulting \(1716\) passant seven-cliques, exactly \(78\) have
  zero concurrence on every triple; these are precisely the row supports
  of \(M\). Thus the minimum-weight layer self-reconstructs the parity-check
  geometry. Each of the four minimum-word orbits independently spans the
  full 36-dimensional code, and the code, minimum hypergraph, and elliptic
  scheme all have automorphism group \(\operatorname{PGL}(2,13)\) of order
  \(2184\). Orbitwise generation is conceptual: the four orbit-Gram
  matrices are \(A_9,A_9,A_{12},A_{10}\), and the mod-two association
  algebra forces each passant orbital to have rank \(36\).

## Work package

1. retain the closed \(q=13\) tangent-triple certificate and its exact
   Paper I v2/companion boundary;
2. test coherent-configuration or rational-dual certificates at
   \(q=17,19\);
3. distinguish a uniform human theorem from a reformulation of the existing
   searches; and
4. assign every result to v2 or the correct neighboring paper.

## Acceptance

A conceptual theorem with a clear evidence boundary and disposition, or a
sharp negative explaining why the finite searches remain irreducible.

## Boundaries and records

Do not reopen, delay, or silently strengthen Paper I v1.

Full task specification:
`notes/2026-07-25-c611-exterior-set-mechanism-v2-disposition.md`.
The C690 transfer and its exact incidence replay are in
`notes/2026-07-29-c690-paper-i-rigidity-upgrades.md`.
