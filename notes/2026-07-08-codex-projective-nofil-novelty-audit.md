# Projective Nofil/cap novelty audit

Date: 2026-07-08.

## Verdict

Conservative public claim:

> We study the normal-play impartial Nofil/cap-avoidance game on the 3-uniform hypergraph of
> collinearity triples in finite affine and projective geometries.  This specializes to HHS Nofil
> on Steiner triple systems when every line has three points.  To our knowledge, the infinite
> projective-family outcomes proved here, including `PG(n,2)` for `n >= 1` and `PG(2m-1,q)` for
> odd `q`, have not previously been recorded for this impartial shared game.

Use the novelty claim at the level of **application/outcome theorem in this game**, not at the
level of the ingredients.  Nofil, pairing strategies, elliptic projective involutions, and colored
tic-tac-toe/avoidance games are all prior art.

## Sources Checked

Primary sources reached:

- Huggan--Huntemann--Stevens, *The combinatorial game Nofil played on Steiner Triple Systems*,
  arXiv:2103.13501 / JCD 2022.
  The paper explicitly defines Nofil as an impartial shared-point normal-play game on block
  designs; chosen points are not owned by either player, and the legal set avoids completing a
  block.  It also says the game can be played on any hypergraph, though the paper focuses on STSs.
  Source: <https://arxiv.org/abs/2103.13501> and ar5iv lines 15--28.
- Huggan--Huntemann--Stevens, *Minimal Graph Embeddings via Point Deletions in Steiner triple
  systems*, arXiv:2510.24935.
  This follow-up is about graph embeddings via STS point deletions; its abstract does not announce
  new geometric-family outcome theorems.
  Source: <https://arxiv.org/abs/2510.24935>.
- Danziger--Huggan--Malik--Marbach, *Tic-Tac-Toe on an Affine Plane of order 4*,
  arXiv:2009.11363.
  This confirms the finite-plane tic-tac-toe lane is a positional/colored game: players alternately
  choose points, and a player wins by owning all points of a line.  It is not impartial shared
  Nofil.
  Source: <https://arxiv.org/abs/2009.11363>.

Searches run:

- `Nofil projective space`, `Nofil PG`, `Nofil PG(3,2)`, `Nofil affine`,
  `Nofil Steiner triple systems projective`.
- `projective cap game`, `cap avoidance game finite geometry`, `cap set game projective`,
  `fixed-point-free involution projective game`, `elliptic involution Nofil`.
- `Clark Mancini Van Hook misere tic-tac-toe`, `projective binary Steiner triple systems
  misere tic-tac-toe`, `Alice Bob monochromatic block projective Steiner triple`.
- Public `site:mathscinet.ams.org` and `site:zbmath.org` probes for `Nofil projective` and
  `cap avoidance game projective`.

No search result found a theorem stating the impartial shared cap/Nofil outcome for all
`PG(n,2)`, or for all odd-`q` odd-dimensional projective spaces by a fixed-point-free projective
involution.

I could not verify a full text for Clark--Mancini--Van Hook in this environment.  The accessible
description supplied in our notes should still be treated as adjacent colored/partizan avoidance
unless the full paper shows otherwise.

## HHS Relationship

HHS is the right prior-art anchor for our ruleset.

What they cover:

- Nofil is the same normal-play impartial shared game convention, on block designs/STSs.
- They compute all STSs up to order 15 and samples at 19, 21, 25.
- They explicitly identify STS(7) as the projective plane over `F_2` and STS(9) as the affine
  plane over `F_3`; both have nim-value 0.
- They prove a vertex-transitivity result: if a hypergraph has a vertex-transitive automorphism
  group, the initial Nofil value is either 0 or 1.
- They connect later positions to Node-Kayles and PSPACE-completeness via graph embeddings.

What they do not appear to cover:

- An infinite projective binary family theorem `PG(n,2)` / `STS(2^(n+1)-1)` is P for all `n >= 1`.
- Any `q > 2` projective-space cap game on the 3-uniform collinearity-triple hypergraph.
- The odd-dimensional odd-`q` projective theorem via an elliptic/fixed-point-free collineation.

## Clark--Mancini--Van Hook Guard

Keep this distinction in the paper:

- Their described game: colored/partizan avoidance. Alice and Bob own separate point sets; a player
  loses by making a monochromatic block.
- Our game: impartial shared normal play. There is one common selected set; the move is illegal if
  it would create a collinear triple; last legal move wins.

Those games can share geometric strategy ideas but do not imply one another.  Do not cite
Clark--Mancini--Van Hook as covering `PG(n,2)` Nofil unless a full-text check verifies a theorem
for the shared impartial convention.

## Recommended Wording

Use:

> The game is Nofil/impartial hypergraph avoidance in the sense of
> Huggan--Huntemann--Stevens, applied to the 3-uniform hypergraph whose edges are collinearity
> triples.  For `AG(n,3)` and `PG(n,2)`, where geometric lines have three points, this is literally
> Nofil on the affine/projective Steiner triple systems.  For projective spaces over `q > 2`, it is
> not Nofil on the line design; it is Nofil on the collinearity-triple hypergraph.

Use:

> The fixed-point-free projective involution is classical, and the copycat strategy is standard.
> The contribution is recognizing that it gives the shared cap/Nofil outcome
> `PG(2m-1,q)=P` for every odd `q`.

Avoid:

- "We introduce Nofil."
- "Fixed-point-free projective involutions are new."
- "Colored misere tic-tac-toe results imply our Nofil theorem."
- "For `q > 2`, this is Nofil on projective lines as blocks."

## Action Items

- Cite HHS for the ruleset, STS small computations, Node-Kayles bridge, and PSPACE motivation.
- Cite finite-plane tic-tac-toe only as adjacent colored/positional-game background.
- Keep the novelty sentence qualified with "to our knowledge" until Clark--Mancini--Van Hook is
  fully retrieved and checked.
