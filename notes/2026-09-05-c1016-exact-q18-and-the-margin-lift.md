# C1016 — the seventeen low-order characters solved exactly, and the lift that carries them

**Lane**: `ergodis` · **Task**: C1016 · 2026-09-05.

The predecessor (`2026-09-05-c1016-character-domain-move-set-and-corpus-width.md`)
closed the character domain as a source of moves and as a source of weights, and
left exactly one thing open there: the characters of low order carry exact
low-dimensional conditions, the search enforces none of them, and the order-two
one — `sum_b u_b^2 = 523` in the halved variables — sits at the same energy on
the plateau as on a random lift. This pass takes that opening. The seventeen
low-order characters turn out to be a single condition the campaign already had
a name and a verifier for, it is satisfiable, and the state that satisfies it
lifts to the full carrier without obstruction.

## The seventeen characters are one condition, and it is the q18 level

The nontrivial characters of order 2, 3, 6, 9 and 18 number
`phi(2) + phi(3) + phi(6) + phi(9) + phi(18) = 1 + 2 + 2 + 6 + 6 = 17`, and they
are precisely the characters of `Z/522` that factor through the projection
`Z/522 -> Z/18`. All seventeen are therefore carried by the 72 aggregate
coefficients

    B_b(x) = sum_{p = x mod 18} y_b(p),      b = 1..4,  x in Z/18,

each a sum of 29 signs and hence an odd integer in `[-29, 29]`. In the position
domain the whole family is one statement about their aggregate autocorrelation.
Summing the carrier law — `sum_b A_b(g) = 2088` at `g = 0` and `-4` at every
other shift — over each fibre of the projection, which has 29 preimages, gives

    A18(0) = 2088 + 28 * (-4) = 1976,      A18(s) = 29 * (-4) = -116  (s != 0).

That is exactly the `Z/18` quotient-PAF theorem the reduction programme
synthesized from complete character-sector coverage, and the derivation above
reproduces the archived subset-count form (`15603` at shift zero, `15080`
elsewhere) exactly under the substitution `B = 2 b - 29`. It is also, verbatim,
the target table already compiled into the private `Q18PairSplit` adapter, the
`q18_local_repair` kernel and both q18 Z3 models. **Enforcing the seventeen
low-order characters is enforcing the exact q18 shell**, and the campaign had
built the verifier for it and then never solved it: the archive prices an
exhaustive attack at `7.125992e74` assignments and records a stochastic probe as
explicitly cheap and unlaunched.

## The order-two character on its own

The order-two character is the one the predecessor singled out. Since 174 is
even, parity is constant on each fibre of `Z/522 -> Z/174`, so `z_b(-1)` is
already determined by a `q174` state, and `u_b = z_b(-1)/2` is an integer. Row
sums fix its parity: for the three blocks of row sum zero the even and odd
halves are negatives of each other and `u_b` is a sum of 261 signs, hence odd;
for the block of row sum two, `u_b` is that sum less one, hence even. Three odd
squares contribute 3 modulo 8 and `523 = 3 mod 8`, so the even coordinate's
square must be divisible by 8:

**The order-two condition `sum_b u_b^2 = 523` forces `u_1 = 0 mod 4`.**

Jacobi's formula gives `r_4(523) = 8 (1 + 523) = 4192` ordered signed
representations, which the oracle enumerates and confirms; **1,048** of them
place the even coordinate in the special block, and every one of those has
`u_1 = 0 mod 4`. So the order-two character alone confines four integers to
1,048 points.

Measured on the banked states, the campaign is nowhere near that variety. Across
the 24 carrier-fibre plateau states, `sum_b u_b^2 - 523` runs from `-40` to
`+60` and is never zero, and **17 of the 24 sit in the class `u_1 = 2 mod 4`,
which cannot reach 523 at all** without a cross-parity transfer. The same holds
on the twelve `q174` plateau states. This is not a failure of the search so much
as a blind spot in it: the order-two character is one of 174 in the `q174`
objective, so a deviation there costs almost nothing to carry.

## An exact q18 quadruple, and the seed defect that hid it

The unlaunched probe runs in seconds once its seeding is fixed. `q18
unassumed-evolve` is a hill climber whose twelve worker streams were derived as
`0x9e3779b97f4a7c15 ^ worker`, with no way to choose the base, so a longer run
extended the same twelve trajectories rather than restarting them: 2,000,000
mutations reached a combined-PAF squared deviation of 160 and 10,000,000 reached
128, and that was the whole reachable set. Adding a base seed exposed the same
striding defect the shell miner had to be fixed for — three base seeds one apart
gave three identical results, because `seed ^ worker` maps adjacent bases onto
overlapping worker streams. Mixing the worker stream through SplitMix64
finalization instead makes adjacent seeds independent (128, 64, 64, 192 on
seeds 1 to 4).

With restarts working, `scripts/q18_mine.sh` runs rounds of twelve workers at
20,000,000 mutations each, roughly two seconds a round, and hands every round's
best coefficients to the radius-four `q18 local-repair` families. The climber
alone saturates between 64 and 192 and never reaches zero. **Round eleven's near
miss repaired exactly** (base seed 788,000,810, climber best 112), giving

    A18 = [1976, -116, -116, -116, -116, -116, -116, -116, -116, -116]

on coefficients that are all odd, all within `[-29, 29]`, with row sums
`(2, 0, 0, 0)`. Its order-two vector is `u = (8, -3, 21, -3)`, and
`64 + 9 + 441 + 9 = 523`. This is banked as
`evidence/q18-exact-quadruple.json` and verified by an independent Python oracle
that derives the law from the carrier law rather than reading a target table.

## The lift is not obstructed

The archive left the lifting question open in the strongest terms: a compressed
q18 witness "neither certifies absence nor lifts by itself to the four 522-bit
rows", and it named the next required reduction as an algebraic theorem linking
the q18 boundary tables to the 18-by-29 binary lifts. Half of that is now
settled, and it is settled in the permissive direction.

By CRT, `Z/522 = Z/18 x Z/29`, so **one block simply is an 18-by-29 binary
matrix**: its row sums are the q18 coefficients and its column sums are the q29
coefficients. A block realizing a given `(q18, q29)` margin pair therefore
exists exactly when Gale--Ryser holds, and Ryser's algorithm constructs one —
which is what the private `binary_margin_lift` kernel behind
`q18 q29-bridge` already does.

Gale--Ryser never binds at these margins. Every one of the **2,208** cross-state
margin pairs formed from the 24 banked states — one state's q18 row margins
against another's q29 column margins, four blocks each — is realizable, and so
is the exact q18 quadruple against a banked exact `q29` shell, on all four
blocks. The bridge reports `q18_exact` and `q29_exact` both true, all four
blocks compatible, and returns a concrete 522-bit candidate with row sums
`(2, 0, 0, 0)`.

**That state is exact at 45 of the 521 nontrivial characters at once** — the
seventeen of order dividing 18 and the twenty-eight of order dividing 29 — by
construction rather than by search.

## What the lifted state is worth, and why the first number misleads

All four rows below come from one independently defined scorer,
`sum_{g != 0} (sum_b A_b(g) + 4)^2` over all 521 nonzero shifts, computed from
signs alone and sharing nothing with the engine. It sits at roughly twice the
engine's banked `carrier_score`, which sums the independent half of the
symmetric shift pairs — exactly twice on some banked states (30,272 against
15,136) and within a fraction of a per cent on others (29,856 against 14,960),
so the two are related functionals rather than the same one and the engine's
field is not used as a scale here.

| state                                              | full score  |
|----------------------------------------------------|------------:|
| canonical Ryser lift of the exact q18 quadruple     |   1,758,528 |
| unconstrained random state with the same row sums   |     995,968 |
| random point of the same margin fibre (200k swaps)  |     935,904 |
| banked carrier plateau state                        |      30,272 |

The canonical lift is worse than random, and that is an artifact of Ryser's
construction, not a property of the constraint. The margin fibre is connected by
the 2-by-2 alternating swap, which preserves both row and column sums and
therefore keeps all 45 characters exact; walking the canonical point 200,000
such swaps lands at 935,904, **statistically indistinguishable from an
unconstrained random state**. Freezing 45 characters costs the other 476
nothing, which is what the isotypic reading predicted: those classes carry 3.4%
of the plateau's residual energy.

So the exact q18 quadruple is a legitimate seed and the fibre around it is
ordinary. What is not yet built is the search inside it.

## Correctness gates

- the q18 targets are derived from the carrier law by summation over the fibre,
  not read from a table, and agree with the archived subset-count form and with
  the private adapter's compiled targets;
- the banked quadruple has all coefficients odd and within `[-29, 29]`, row sums
  `(2, 0, 0, 0)`, and aggregate autocorrelation equal to the law at all eighteen
  shifts;
- the order-two enumeration reproduces Jacobi's `r_4(523) = 4192` independently,
  and every admissible vector has `u_1 = 0 mod 4`;
- the bridge report is replayed from its own canonical matrices: the row margins
  are the q18 input, all four blocks pass an independent Gale--Ryser test, and
  the recomputed full PAF score equals the reported one;
- every score in the comparison table comes from the same independent scorer,
  applied to signs alone, so the four rows are on one scale; and
- `cargo test --release --workspace --all-targets` passes with the seeding
  change in place.

## Provenance

The derivation of the q18 law, the order-two parity argument and the `u_1 = 0
mod 4` exclusion are proved structural. The order-two enumeration and the
verification of the banked quadruple are exact computational. The Gale--Ryser
compatibility and the margin construction are proved. The climber and the
mining loop are heuristic and their misses have no pruning authority over
anything; the hit is exact because it is directly replayed, not because the
climber found it.

## Replay

Branch `c1016-full-2092-campaign` of `ergodis-private`, at
`~/src/ergodis-worktrees/c1016-full-2092/ergodis-private`.

    cargo build --release -p hadamard-2092
    cargo test --release --workspace --all-targets -- --test-threads=1

    bash scripts/q18_mine.sh evidence/q18-mine 400 12 20000000 777000777

    hadamard q18 q29-bridge evidence/q18-exact-quadruple.json \
        evidence/q18-bridge-q29-input.json

    python3 scripts/q18_low_order_replay.py evidence/q18-exact-quadruple.json \
        evidence/q18-q29-bridge.json

Evidence hashes are in that repository's `evidence/SHA256SUMS`.

## What comes next

The fibre-constrained search. The move is the 2-by-2 alternating swap on the
18-by-29 matrix, it preserves both margins and so keeps all 45 characters exact
for the whole descent, and the campaign's exact incremental delta algebra
applies to it unchanged. The open question is the only one that matters: can a
descent restricted to that fibre reach the depth the unrestricted search reaches
— the banked plateau near 30,272 in the units above — while holding 45
characters at zero? The fibre is statistically ordinary at its random point, so
there is no reason from the starting distribution to expect it cannot; the
constraint is a restriction of the move set, and that is what has to be measured.

Two smaller items follow from the same reading. The corpus of exact q18
quadruples is currently one; mining is cheap and a corpus would let the bridge
rotate over `(q18, q29)` pairs the way phase two rotates over shells. And the
`u_1 = 0 mod 4` exclusion is an exact necessary condition computable in one pass
over a `q174` state, so it can be used as a filter or a tie-break wherever
`q174` states are banked.

## Mystery ledger

- **The exact q18 shell was reachable in seconds and had been priced at
  `7.1e74`.** The gap is not an error in the estimate — that is an exhaustive
  count — but it does mean the shell's solution density is high enough that a
  climber plus a radius-four repair finds a point in eleven rounds. Settled as
  a fact; what remains unexplained is how large the solution set is, which
  nothing here measures.
- **The lift is unobstructed at every margin pair tested, 2,208 of 2,208.**
  Expected from how balanced the margins are, but it was named in the archive as
  an open risk and is now measured. Settled.
- **The canonical lift is worse than random while its fibre is exactly as good
  as random.** Ryser's greedy staircase is a pathological point of an ordinary
  set. Settled, and it is the reason the first bridge number must not be read as
  a verdict on the approach.
- **Whether the fibre-constrained descent reaches the unrestricted depth.**
  Open, and it is the whole question. The exact gate is a descent inside the
  margin fibre measured against the unrestricted plateau at equal wall clock.
- **Why the search leaves the order-two character untouched.** Explained rather
  than mysterious — it is one character of 174 and costs almost nothing to carry
  — but the consequence is that 17 of 24 banked plateau states are in a residue
  class that cannot complete. Whether enforcing the class as a filter changes
  the plateau is untested.
