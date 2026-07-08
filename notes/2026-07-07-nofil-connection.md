# Nofil: published prior art for our cap/sum-free game genus (2026-07-07)

Source: M. A. Huggan, S. Huntemann, B. Stevens, *The combinatorial game Nofil played on Steiner
triple systems*, J. Combin. Designs 30 (2022) 19–47; arXiv:2103.13501. Follow-up: arXiv:2510.24935
(2025, minimal graph embeddings via point deletions in STS). Found 2026-07-07 during the
lit-search pass; this note fixes the exact relationship and the imports/exports.

## The game and the convention match

Nofil ("Next One to FIll is the Loser") on a block design: a move chooses an unplayed point that
does **not** complete a block of played points (block-filling moves are illegal — a point whose
block has all other points played is unplayable); **last player to move wins** (normal play).

**This is exactly our cap-achievement convention.** Their genus = ours restricted to 3-uniform
designs (STS). Placement of our games:

| Our game                                | In nofil terms                                                        |
|-----------------------------------------|-----------------------------------------------------------------------|
| cap game on `AG(n,3)` (cap sets)        | nofil on the **affine STS family** `STS(3ⁿ)` — every `AG(n,3)` is an STS |
| `F₂^{m+1}` sum-free = `PG(m,2)` cap game | nofil on the **projective STS family** `STS(2^{m+1}−1)`               |
| cap game on `AG(n,q)`, `PG(2,q)`, q > 3 | same genus on the collinear-**triple** 3-uniform hypergraph (not an STS: pairs lie in many triples) |
| sum-free game on `Z_n`                  | same genus on the Schur-triple hypergraph (not an STS)                 |

The two classical infinite STS families (affine and projective) are exactly our two solved/computed
columns. Cross-checks: their STS(7) (Fano = `PG(2,2)`) has nim-value 0 — matches our `PG(2,2) = P`;
their STS(9) (unique = `AG(2,3)`) has nim-value 0 — matches our affine theorem's specialization. ✓

## What our results give their program (exports)

1. **★ First infinite STS family with determined nofil outcome:** our `AG(n,q)` theorem
   (`2026-07-04-capset-game-theorem.md`) specializes to **nofil on `AG(n,3)` is a second-player
   win for every `n`** — and by their Proposition 6 (vertex-transitive ⇒ nim-value ∈ {0,1}) the
   nim-value is exactly **0**, `STS(3ⁿ)` for all `n`. Their paper is exhaustive to order 15 plus
   samples at 19, 21, 25; no infinite family was known.
2. **The projective column in their language:** Lean now proves nofil value 0 on
   `PG(m,2)` = `STS(2^{m+1}−1)` for every `m ≥ 1`. The proof is
   the non-linear translation mirror on the vector model: after `a,b`, the line point `a+b` is
   blocked and translation by `a+b` pairs the remaining live nonzero vectors. The Lean route is to
   bridge binary projective caps to the existing `F₂^k` sum-free theorem
   (`Sumfree.Game.nonzero_initial_isP_zmod2_of_finrank_ge_two`), not to use a linear projective
   involution. The projective theorem names are
   `Projective.initialPStatement_binary_of_finrank_ge_two` and
   `Projective.initialPStatement_binary_of_projectiveDim_ge_one`.
3. **Their order-mod-6 nim-parity pattern gets counterexample structure:** in their data,
   `v ≡ 1 (mod 6)` systems trend to odd nim-values (13 → 1, 19 sample → all 1, 25 → {1,3}) with
   the Fano plane (v=7, value 0) the exception. Our `PG(4,2) = P` adds **v = 31 ≡ 1 (mod 6),
   value 0** — the projective family systematically violates the odd-trend, suggesting the right
   statement conditions on structure, not on `v mod 6`. (The affine family, `3ⁿ ≡ 3 (mod 6)`,
   value 0, is consistent with their even-trend.)

## What their results give us (imports)

1. **PSPACE-completeness (their Cor. 11):** deciding the outcome of nofil positions on STS is
   PSPACE-complete, via Theorem 10 (every graph embeds in a large-enough STS so that a nofil
   position's available hypergraph is that graph, reducing from Node-Kayles). Import for our
   papers' motivation: general positions of this genus are intractable, so **theorems for
   structured families (affine/projective/sum-free) are the tractable frontier**, and the
   `PG(2,q)` open kernel lives just past it.
2. **Endgame = Node-Kayles equivalence:** once the available hypergraph collapses to a graph,
   nofil IS Node-Kayles — the published counterpart of our armed-Schur-component disjunctive-sum
   decomposition (verified for the sum-free game). Their embedding machinery (+ the 2025
   follow-up) is the hardness toolkit if we ever want complexity statements for `AG(n,q)`/`PG(2,q)`
   positions.
3. **Proposition 6** (vertex-transitivity ⇒ nim ∈ {0,1}): the 1-orbit case of our frame-chain
   `SizeValueConstant` machinery (already formalized in `lean/CapGame/BuildGame.lean`); our
   version transports values through orbit-constant size layers 1..4, which is what a referee
   should map to their Prop 6.
4. **Calibration:** generic STS outcomes are wild (STS(13): both systems value 1; STS(15): 73/80
   value 0, values up to 3; STS(21): 941/1000 value 0; STS(25): mixed {1,3}). P on our infinite
   families is special, not generic — strengthens the significance claim.

## Novelty / literature-risk status (2026-07-08)

Conservative claim:

> To our knowledge, the fixed-point-free involution argument has not been recorded for Nofil/cap
> avoidance on finite projective spaces. It is an elementary pairing strategy built from classical
> projective geometry, but its application here gives a closed projective family: for every odd
> `q`, the impartial cap game on `PG(2m−1,q)` is a P-position.

What is **not** novel:

- Nofil as impartial hypergraph avoidance. HHS explicitly allow the game on any hypergraph, while
  focusing on STSs.
- Whole-board mirror / pairing strategies as a general game-theoretic pattern.
- Fixed-point-free nonsplit/elliptic projective involutions as finite projective geometry.

What currently appears **new in our context**:

- Applying the Nofil/cap-avoidance rules to the 3-uniform collinearity-triple hypergraph of
  `PG(d,q)` for `q > 2`, rather than to the projective line design.
- The theorem `PG(2m−1,q)=P` for all odd `q`, proved by a fixed-point-free projective collineation
  and a whole-board mirror in the impartial/shared game.
- The comparison between this impartial theorem and the colored/partizan avoidance-game literature
  on affine/projective Steiner triple systems.

Wording guard for papers/talks:

> For `q > 2`, our projective game is not Nofil on the line design/STSs, but it is the same
> impartial hypergraph-avoidance ruleset applied to the 3-uniform collinearity-triple hypergraph.

Literature search status:

- HHS cover the Nofil genus, compute the geometric STS(7) and STS(9), prove the vertex-transitive
  nim-value bound `G ∈ {0,1}`, and develop Node-Kayles embedding/hardness. They do **not** appear
  to state a projective-space family theorem or the odd-dimensional elliptic-involution mirror.
- Searches for `Nofil PG/projective space/cap game`, `PG(2m−1,q) Nofil`, and
  `projective cap game fixed-point-free involution` found no indexed prior occurrence.
- General misere tic-tac-toe / positional-game mirroring is adjacent prior art only. It is usually
  colored/owned-point or draw-forcing, not this impartial normal-play cap game.
- Clark--Mancini--Van Hook remains unverified from a full text. Based on the accessible abstract,
  it studies a different partizan colored avoidance game on projective binary STSs; do not cite it
  as covering our impartial `PG(n,2)`/Nofil theorem without checking the paper.

## Actions

- Cite nofil in: the sum-free/affine-cap paper (prior art + corollary 1–2 above), the OEIS draft
  (reference list), the projective cap paper (PSPACE motivation).
- ~~Replace the old `m = 5` compute target with a Lean target: prove the binary projective bridge
  `PG(m,2)` cap/nofil = `F₂^{m+1}` sum-free on nonzero vectors, then instantiate the existing
  spare-order-two theorem for rank at least 2.~~ DONE 2026-07-08 in
  `ProjectiveCap/Binary.lean`.
- Prior-art check still needed: Clark--Mancini--Van Hook study a partizan colored avoidance
  variant of misere tic-tac-toe on projective binary Steiner triple systems, not the impartial
  shared nofil game. Verify the full paper before making novelty claims, but the abstract does not
  appear to cover this theorem.
- Before public novelty language: use the conservative wording from
  [`2026-07-08-codex-projective-nofil-novelty-audit.md`](2026-07-08-codex-projective-nofil-novelty-audit.md).
  The targeted public-index search found no prior occurrence of the projective-family theorem in
  this impartial shared game, but Clark--Mancini--Van Hook still needs full-text verification
  before making stronger claims.
- Community/venue signal: J. Combinatorial Designs published the genus; Huggan–Huntemann–Stevens
  are the natural readers/referees (+ Games of No Chance for the CGT side).
