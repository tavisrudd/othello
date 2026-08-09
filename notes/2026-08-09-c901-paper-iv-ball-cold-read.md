# C901 Paper IV round-1 cold read: Ball persona

## Frozen materials and scope

- Manuscript PDF: `papers/q13-passant-code/passant_code_q13.pdf`, SHA-256
  `715fdb6500c34386f92f61ba6fd328da8fd95a60e657c644e9e5a097e0b73fce`.
- Textual authority used because `pdftotext` was unavailable:
  `papers/q13-passant-code/passant_code_q13.tex`, SHA-256
  `12e19dd0c2f4a83e25f2a023ebd23b35bdb8415649cbac993853a0488a2ec033`.
- Assigned source: Ball--Lavrauw, *Arcs in finite projective spaces*, cached as
  `arXiv:1908.10772`, SHA-256
  `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`,
  Section 7 through Lemma 29.
- Manuscript scope: Section 2 through the end of the weight-eight subsection,
  and only the weight-eight row of the proof-boundary table. I did not inspect
  verification source, prior reviews, handoffs, or the excluded task files.

## Strongest theorem supported in scope

Within the assigned portion, the strongest code statement is that a nonzero
word cannot have weight eight (and hence, using the preceding parity and lower
bound, has weight at least ten). More sharply, the local 42-vertex graph forced
by a hypothetical weight-eight support has clique number exactly five, whereas
the support would require a seven-clique. This read does not assess the later
weight-ten exclusion needed for the section title's distance-twelve conclusion.

## Causal proof spine

1. At a support point of a weight-eight word, parity on the seven passant rows
   forces each passant through that point to contain exactly one of the other
   seven support points. Repeating this at every support point makes every
   support join passant and forbids three collinear support points. The support
   is therefore an eight-arc.
2. There are fourteen lines through a point of `PG(2,13)`. The seven support
   joins consume the passant half of the pencil. The other seven lines are at
   once the arc tangents and the conic secants. Consequently the displayed
   product `T_P` is the Ball--Lavrauw tangent function `f_{\{P\}}`, up to an
   irrelevant scalar.
3. In Ball--Lavrauw Lemma 27, `k=3`, `D` is empty, and
   `t=q+k-1-|A|=13+3-1-8=7`. Thus the cyclic identity has sign
   `(-1)^{t+1}=+1`. Its left-to-right quotient is exactly the manuscript's
   `h(P,Q,R)`. Each rescaling of `T_P` occurs once above and once below the
   fraction, so no normalization choice remains.
4. Fixing `P=(1:0:2)`, the other seven support points must lie among the 42
   internal points joined to `P` by passants, and every pair must have passant
   join and `h=1`. They therefore form a seven-clique in the stated local
   graph.
5. The given projectivity splits this domain into the three displayed
   14-cycles. The six difference sets reproduce the local graph. The explicitly
   specified symmetric integer matrix has diagonal 40 and edge entries -10.
   Its stated characteristic polynomial is exact; because every nonzero factor
   is positive on the negative real axis and the matrix is real symmetric, the
   matrix is positive semidefinite, of rank 28.
6. A clique characteristic vector then gives
   `0 <= 10c(5-c)`, hence `c <= 5`, contradicting the required seven-clique.

## Independent checks

I reconstructed `PG(2,13)` directly from normalized projective coordinates.
There are 78 internal points, seven passants and seven secants through the
chosen internal point, and exactly 42 other internal points joined to it by a
passant. The three displayed seeds have disjoint gamma-orbits of length 14 and
cover precisely those 42 points. Direct evaluation of the seven-secants
products reproduces all six displayed difference sets.

I then reconstructed the 42-square matrix from its six circulant first rows.
Exact integer traces and Newton identities reproduce the displayed
characteristic polynomial, with an `x^14` factor and no further zero root.
Independently, the local graph has exactly fourteen five-cliques: the fourteen
translates displayed in the paper; their incidence vectors have rank 14. Thus
the normalization, graph domain, PSD obstruction, and optional equality-case
claim all survive an independent calculation without the verification source.

## Earliest unsupported implication

There is no unsupported implication in the load-bearing weight-eight
exclusion. The first statement whose derivation is not exposed in the prose is
the later, nonessential assertion that solving the kernel's 0--1 constraints
gives precisely fourteen maximum cliques. It is fully determined by the
displayed data and my independent enumeration confirms it, but the manuscript
does not show those constraints or their short solution. This does not affect
the exclusion of a seven-clique.

## Ranked findings

1. **Exposition friction (low; no effect on the theorem).** In the
   proof-boundary row, “Segre's lemma gives the 42-vertex graph” compresses two
   logically different steps. Segre supplies the `h=1` condition; conic-pencil
   counting and the explicit orbit computation supply the 42-point domain and
   its graph. A slightly more exact sentence would make the human/exact boundary
   faithful to the proof.
2. **Convention clarity (low; no effect on the theorem).** The main text says
   that the sign is not negative but does not display `t=7` and
   `(-1)^{t+1}=1`. Adding that one calculation would remove the likeliest
   finite-geometry normalization doubt at negligible cost.
3. **Unexplained computation (low; non-load-bearing).** The exact matrix and
   characteristic factorization are sufficient to check positive
   semidefiniteness, and the manuscript explains the decisive sign argument.
   By contrast, the subsequent classification of all five-cliques is only
   summarized as solving 0--1 constraints. Either show the compact constraints
   or label this as an optional exact check; it is not needed for weight eight.

## Verdict

**GO.** The tangent-set identification is correct, the Lemma 27 sign and
normalization are correct, the local graph has the stated complete domain, and
the manuscript supplies enough exact matrix data and spectral explanation for
the PSD clique obstruction to be independently checked. The findings above are
editorial clarifications, not gaps in the theorem-facing argument.

## Packet-relative novelty

Relative to the packet's general lemma of tangents, the manuscript's new step
is the concrete identification of the eight-arc tangent products with conic
secant pencils and their conversion into a sharp 42-vertex positive-semidefinite
clique obstruction over `F_13`.
