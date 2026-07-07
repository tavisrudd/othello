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
2. **The projective column as a clean open problem in their language:** our sum-free `F₂` data
   gives nofil value 0 on `PG(m,2)` = `STS(2^{m+1}−1)` for `m ≤ 4` (orders 7, 15, 31); `m ≥ 5`
   (order 63) is open — and pairing proofs are obstructed (a linear involution `1+N` over `F₂` has
   fixed space of dim ≥ k/2; handoff R5). Conjecture: value 0 for all `m`.
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

## Actions

- Cite nofil in: the sum-free/affine-cap paper (prior art + corollary 1–2 above), the OEIS draft
  (reference list), the projective cap paper (PSPACE motivation).
- The `m = 5` projective column (`STS(63)`, = `F₂⁶` sum-free) is a concrete compute target that
  settles the smallest open case of conjecture 2 (needs the canonical solver import; the naive
  memo blew 1.3 GB).
- Community/venue signal: J. Combinatorial Designs published the genus; Huggan–Huntemann–Stevens
  are the natural readers/referees (+ Games of No Chance for the CGT side).
