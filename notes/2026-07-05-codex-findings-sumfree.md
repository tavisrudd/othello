# Codex findings: sum-free game solver and socle-reduction probes

Date: 2026-07-05.

This report reflects the updated assignment status: `Z2 x F3^b = P` is already proved by the
fixed-point-free sigma mirror in `2026-07-05-sumfree-zmf3b-theorem.md`. The remaining open target is
the socle reduction `outcome(G) = outcome(G[6])`, after first repairing the solver's root-symmetry
bug.

## Files added

- `sumfree_solver.py`: corrected bitmask outcome solver.
- `verify_strategy.py`: all-lines strategy verifier.
- `socle_reduction_probe.py`: corrected solver-based `G` vs `G[6]` probe plus local rho-mirror
  obstruction search.

No Rust source was modified.

## Corrected solver

The solver stores a position as a Python integer bitmask and maintains:

- `S(A) = {a+b : a,b in A}`
- `D(A) = {a-b : a,b in A}`
- `T(A) = {x : 2x in A}`

For sum-free `A`, a move `x` is legal iff:

`x != 0` and `x notin A | S(A) | D(A) | T(A)`.

This was unit-tested against a brute Schur-triple scan on `(3)`, `(4)`, `(5)`, `(2,2)`, `(2,3)`,
`(3,3)`, and `(2,3,3)`.

Canonicalization is conservative: every memo key is either the raw bitmask or the minimum over an
explicitly enumerated subgroup of verified automorphisms. Root search now uses actual orbit
representatives, not blanket root transitivity. In particular, `Z8`, `Z10`, and `Z2 x F3^b` are no
longer treated as root-transitive.

## Correctness gate

Run under `ulimit -Sv 819200` / `--mem-mb 800`. Peak RSS: 57 MB.

| group | expected | got | first winning move if N |
|---|---:|---:|---|
| `F3^2` | N | N | `(0, 1)` |
| `F3^3` | N | N | `(0, 0, 1)` |
| `Z2 x F3^2` | P | P | - |
| `Z2 x F3^3` | P | P | - |
| `Z5` | P | P | - |
| `Z6` | P | P | - |
| `Z7` | P | P | - |
| `Z8` | N | N | `(4,)` |
| `Z9` | N | N | `(1,)` |
| `Z10` | N | N | `(5,)` |
| `Z11` | P | P | - |
| `Z2^2` | P | P | - |
| `Z4^2` | P | P | - |

The corrected `Z2 x F3^3` empty solve used monomial canonicalization: 1,354,118 nodes, 369,656 TT
entries, 121.15s, 56 MB RSS.

## Larger targets

- `F3^4`: exact solver did not finish in the allotted run. Stopped at 1,050,000 nodes, 329,419 TT
  entries, 498.2s, 39 MB RSS. This is a time/canonicalization wall, not a memory wall.
- `F3^5`: not attempted exactly after the `F3^4` wall. The theorem `F3^n=N` supplies the outcome.
- `Z2 x F3^3`: reconfirmed P by corrected solver. The residual `{m}` is N; a winning move from
  `{(1,0,0,0)}` is `(0,0,0,1)` (110,138 nodes, 48,538 TT entries, 5.50s, 20 MB).
- `Z2 x F3^4`: exact residual `{m}` solve did not finish. Stopped at 730,000 nodes, 348,740 TT
  entries, 436.7s, 42 MB RSS. The updated theorem note proves P for all `b`, but this Python solver
  did not independently compute the `b=4` outcome.

## Strategy harness checks

`verify_strategy.py` branches every opponent move and applies a chosen hero strategy. For arbitrary
strategies it memoizes raw states, because canonical memoization is only sound when the strategy is
equivariant under the same automorphisms.

Solver-backed table strategy:

- `{m}` in `Z2 x F3^2`: verified, 38 verifier nodes, 29 memo states.
- `{m}` in `Z2 x F3^3`: verified, 77,062 verifier nodes, 50,890 memo states.

Sigma theorem validation, using `2026-07-05-sigma-verify.py` functions under the 800 MB cap:

- `b=1`: brute `{m}=N`, `{m,p}=P`; adversarial sigma mirror wins.
- `b=2`: brute `{m}=N`, `{m,p}=P`; 10 sigma-symmetric positions and 24 local checks for each tested
  `a`, 0 violations; adversarial mirror wins.
- `b=3`: 2,872 sigma-symmetric positions and 22,848 checks for each tested `a`, 0 violations;
  adversarial mirror wins.

I also tested the now-superseded hyperplane candidates. They do not give a clean strategy:

- `slice_pair` fails immediately after `{m}, (0,1,0), (0,0,1)` because the reflected pure-axis mate
  hits the order-3 doubling obstruction.
- Affine/hybrid repairs fix that first branch but fail later; a bounded "try negation/unique move"
  repair still fails on `b=2`, e.g. path
  `{m}, (0,1,0), (1,0,1), (1,0,2), (0,2,1)` leaves the hero stuck.

This is now mostly historical, since the sigma theorem supersedes the hyperplane plan.

## Socle-reduction data

Using `socle_reduction_probe.py` with the corrected solver, all tested groups matched `G[6]`:

| group | `outcome(G)` | `outcome(G[6])` | `|G[6]|` | first winning move if N |
|---|---:|---:|---:|---|
| `Z5` | P | P | 1 | - |
| `Z7` | P | P | 1 | - |
| `Z5 x Z3` | N | N | 3 | `(0, 1)` |
| `Z7 x Z3` | N | N | 3 | `(0, 1)` |
| `Z5 x Z9` | N | N | 3 | `(0, 3)` |
| `Z5 x Z3^2` | N | N | 9 | `(0, 0, 1)` |
| `Z2 x Z5` | N | N | 2 | `(1, 0)` |
| `Z2 x Z5 x Z3` | P | P | 6 | - |
| `Z5 x Z2^2` | P | P | 4 | - |
| `Z10` | N | N | 2 | `(5,)` |
| `Z14` | N | N | 2 | `(7,)` |
| `Z30` | P | P | 6 | - |

The natural rho mirror was also probed locally. It fixes the `{2,3}` part and negates the coprime
part. It works when the fixed part has no 3-torsion, but fails as soon as fixed 3-torsion is present:

- OK: `Z5`, `Z7`, `Z2 x Z5`, `Z5 x Z2^2`, `Z10`, `Z14`.
- Fails: `Z5 x Z3`, `Z7 x Z3`, `Z5 x Z9`, `Z5 x Z3^2`, `Z2 x Z5 x Z3`, `Z30`.

Representative first obstruction:

`Z5 x Z3`, `A={(2,0),(3,0)}`, opponent `y=(1,1)`, rho reply `(4,1)` is illegal because
`(1,1) + (3,0) = (4,1)`.

The same pattern appears in the other failures: a coprime-part element already paired under rho can
combine with the new opponent move to equal the rho reply. In formula terms, the bad triple is
`a + y = rho(y)` with `a = rho(y)-y` in the current rho-symmetric set. Full negation excludes this
via `A=-A`; partial negation loses that link because the 3-part is fixed.

So the straightforward "lift the socle strategy and pair all coprime elements by rho" route is not a
proof. Any socle-reduction proof has to coordinate the socle play with these coprime-pair blockers,
or use a different invariant.

## Verified vs inferred

Verified by the scripts added or rerun here:

- Incremental legality condition against brute scans.
- Correctness gate outcomes, including the fixed `Z8=N` and `Z10=N` root cases.
- `Z2 x F3^3=P` with corrected root handling.
- Solver-backed all-lines winning strategies from `{m}` for `Z2 x F3^2` and `Z2 x F3^3`.
- Sigma mirror local/adversarial checks for `b<=3`.
- Socle outcome matches for the listed groups.
- Rho local mirror failures and first obstruction triples for the listed groups.

Inferred from companion theorem notes, not newly exact-solved here:

- `F3^n=N` for all `n`, including `F3^4` and `F3^5`.
- `Z2 x F3^b=P` for all `b`, including `b=4,5`.
- The full abelian classification modulo the socle-reduction conjecture.

Not proved here:

- The socle reduction.
- A BSGS/partition-backtrack minimal-image canonicalizer strong enough to exact-solve `F3^4`/`F3^5`
  in Python.
- An outcome-preserving strategy that neutralizes coprime factors when the socle has 3-torsion.

## Addendum: Five Socle-Reduction Attacks

After the assignment update adding "SOCLE REDUCTION — FIVE PARALLEL ATTACKS", I added
`socle_five_attacks.py` and reran the relevant probes under a 2 GB cap
(`ulimit -Sv 2097152`, `--mem-mb 2048`). Peak observed RSS in these small probes was 34 MB.

### Attack 1: Atomic Peels

Small exact peel table:

| peel | base | lifted | base | lifted | holds? | mirrorability |
|---|---|---|---:|---:|---:|---|
| `P_cop(5)` | `Z3` | `Z3 x Z5` | N | N | yes | rho fails, 8 local failures |
| `P_cop(5)` | `Z3^2` | `Z3^2 x Z5` | N | N | yes | rho fails, 416 local failures |
| `P_cop(5)` | `Z2 x Z3` | `Z2 x Z3 x Z5` | P | P | yes | rho fails, 48 local failures |
| `P_cop(5)` | `Z2^2` | `Z2^2 x Z5` | P | P | yes | rho ok |
| `P_2(2)` | `Z3 x Z2` | `Z3 x Z4` | P | P | yes | not tested |
| `P_2(2)` | `Z3^2 x Z2` | `Z3^2 x Z4` | P | P | yes | not tested |
| `P_3(2)` | `Z3^2` | `Z3 x Z9` | N | N | yes | not tested |
| `P_3(2)` | `Z2 x Z3^2` | `Z2 x Z3 x Z9` | P | P | yes | not tested |

This supports the assignment's conjectured split: the peel outcome holds in these cases, but the
simple coprime rho involution is mirror-clean only when the fixed part has no 3-torsion.

### Attack 2: Grundy Data

Small Grundy table:

| group | Grundy |
|---|---:|
| `Z2` | 1 |
| `Z3` | 1 |
| `Z5` | 0 |
| `Z7` | 0 |
| `Z9` | 1 |
| `Z10` | 1 |
| `Z14` | 2 |
| `Z3^2` | 1 |
| `Z5 x Z3` | 2 |
| `Z3 x Z9` | 1 |
| `Z2 x Z3` | 0 |
| `Z2 x Z3 x Z5` | 0 |

No nimber identity is visible: `Z14` vs `Z2` is again `2` vs `1`, and `Z5 x Z3` vs `Z3` is `2` vs
`1`. The data is still compatible with an outcome-only law. I do not have a credible periodic
nimber-difference conjecture from this small table.

### Attack 3: Quotient by `6G`

Outcome agrees with the coordinate quotient `G/6G` in the tested cases, but the naive quotient map is
not a game morphism on positions: it can send a sum-free set to a non-sum-free image.

Examples:

- `Z9 -> Z3`: `{(3,)}` maps to `{(0,)}`, which is not sum-free.
- `Z5 x Z3 -> Z3`: `{(1,0)}` maps to `{(0,)}`, not sum-free.
- `Z2 x Z5 x Z3 -> Z2 x Z3`: `{(0,1,0)}` maps to `{(0,0)}`, not sum-free.
- `Z4 x Z3^2 -> Z2 x Z3^2`: `{(0,0,2),(1,0,1)}` maps to a non-sum-free set.

So `G -> G/6G` may preserve outcomes empirically, but not through the simplest "project every
position" correspondence.

### Attack 4: Hard Coprime Peel Strategy

Target `Z3^2 x Z5`:

- Corrected solver: N, winning first move `(0,1,0)` in `(Z3,Z3,Z5)` coordinates.
- Solver-backed all-lines table strategy verifies: 153,910 verifier nodes, 93,411 memo states,
  135,950 solver nodes, 34 MB RSS.
- The natural combined strategy from `2026-07-05-sumfree-lemmaR.py` fails:
  `Z5 x Z3^2` has 1,284 illegal-response failures over 12,707 explored opponent nodes.

Representative failure in `(Z5,Z3,Z3)` coordinates:

`A = {001,400,012,100,420,110}`, opponent `012` (order-3), proposed B-game reply `020` is illegal.

This is not yet a bounded-local-repair strategy. It is a precise obstruction for the obvious
"socle B-game + negation/pair coprime part" lift: mixed coprime elements already in `A` can veto the
socle reply.

### Attack 5: LMSF Terminal-Parity Tables

Small locally maximal sum-free size distributions:

| group | LMSF sizes | parity |
|---|---|---|
| `Z3` | `[1]` | odd |
| `Z9` | `[3]` | odd |
| `Z3^2` | `[3]` | odd |
| `Z2 x Z3` | `[2,3]` | mixed |
| `Z5 x Z3` | `[3,4,5,6]` | mixed |

State walls under the current simple enumerator:

- `Z3 x Z9`
- `Z2 x Z3^2`

The parity route remains plausible but not yet informative: the first mixed coprime example
`Z5 x Z3` already has both parities among LMSF sizes, so a proof would need an achievable-parity or
strategy-specific correspondence, not just "all maximal sets have the same parity".

## Addendum: Further Proof Attempts

After the "try anything" prompt, I pushed on the smallest hard coprime peel `F3^2 x Z5`.

### Oracle Strategy Shape

I added `socle_strategy_extract.py` to classify the corrected solver's table strategy for
`Z3 x Z3 x Z5`.

The oracle strategy is not close to a quotient mirror:

- explored strategy states: 93,410
- hero reply records: 76,954
- replies in the expected `F3^2` sigma-mirror fiber: only 7,197
- replies in other `F3^2` fibers: 69,757

So a proof that only "mirrors the socle coordinate and chooses a better coprime label" cannot match
the actual small strategy.

The terminal sizes produced by the oracle strategy are all odd:

| terminal size | count in explored strategy DAG |
|---:|---:|
| 7 | 207 |
| 9 | 737 |
| 11 | 159 |
| 15 | 12 |

This supports a possible terminal-parity proof, but it is strategy-specific: the full LMSF
enumerator still walls on `Z3^2 x Z5`, so I do not know whether all maximal sets there are odd.

### Mirror Families Closed

Tested and failed:

- `F3^2 x Z5`: open `(o,0)` and mirror `(h,k) -> (-o-h,-k)`.
- `F3^2 x Z5`: all affine reflections `(h,k) -> (-o-h,c-k)` for several nonzero `o` and all
  `c in Z5`; none verified.
- `Z2 x F3^2 x Z5`: sigma on the `F3^2` label plus negation on the `Z5` coordinate,
  `(eps,v,k) -> (1-eps,a-v,-k)`, fails locally and adversarially.
- `Z2 x F3^2 x Z5`: all affine fixed-point-free involutions of the form
  `(eps,v,k) -> (1-eps, A v + a, lambda k + c)` with `A^2=I` in `GL(2,3)` and
  `lambda in {1,-1}` on `Z5`; 276 candidates tested, none verified.

Representative failure for the mixed sigma/negation strategy in `Z2 x F3^2 x Z5`:

`(1,0,0,0) -> (0,1,0,0) -> (0,0,0,1) -> (1,1,0,4) -> ... -> (0,1,0,2)`,
where the mirror strategy has no legal reply.

### Hyperplane-Coset Strategy

For `F3^2 x Z5`, the odd sum-free hyperplane coset
`S = {second F3 coordinate = 1}` has size 15. Two tests failed:

- Greedy "always play the first legal move in S" fails after 13 verifier nodes.
- The stronger asymmetric game "hero must play in S, opponent can play anywhere" is losing for the
  hero: 34,915 searched states.

Thus a terminal-hyperplane proof cannot simply force play inside one fixed odd maximal sum-free set.

### Extra Grundy Data

Additional exact Grundy computations under the 2 GB cap:

| group | Grundy |
|---|---:|
| `Z3 x Z5` | 2 |
| `Z3 x Z7` | 1 |
| `Z3 x Z11` | 1 |
| `Z3 x Z13` | 1 |
| `Z3^2 x Z5` | 2 |

The run for `Z3^2 x Z7` did not finish quickly and was stopped. This further weakens the hope for a
simple constant nimber shift under coprime peeling.

### Current Proof Status

No proof of the socle reduction was completed. The strongest current positive lead is terminal
parity: the verified oracle strategy for `F3^2 x Z5` forces only odd terminal sizes, even though its
move choices are highly state-dependent. The strongest negative conclusion is that broad global
mirror/involution approaches are now closed for the smallest hard coprime peel and for the analogous
`s2=1` P-side peel.

## Addendum: Continued Socle-Reduction Proof Search

Further checks after continuing from the terminal-parity lead:

### Sigma-Fiber Strategy Is Impossible

For `F3^2 x Z5`, first move `(0,1,0)`, I solved the restricted game where every hero response must
lie in the `F3^2` sigma-mirror fiber of the opponent move, with arbitrary choice of the `Z5` label.
Result: losing for the hero after only 8 searched states. Thus the oracle's frequent exits from the
sigma fiber are essential, not an artifact of tie-breaking.

### Maximal Completions After First Move Have Mixed Parity

Using the automorphism stabilizer of the first move `(0,1,0)`, all maximal completion sizes after
that first move were computed canonically:

`[6, 7, 8, 9, 10, 11, 12, 14, 15]`.

So the first move alone does not force odd terminal parity. The parity proof, if it exists, must use
an active strategy, not merely the fact that every completion of the opening has odd size.

### Adaptive Affine Mirrors Are Insufficient

I added `adaptive_affine_mirror_probe.py` and searched all affine involutions of `F3^2 x Z5` of the
form `GL(2,3) x Aut(Z5)` plus translation, on sampled oracle P-positions.

Out of the first 200 oracle P-positions checked:

- 43 admitted a clean affine involution mirror.
- 157 did not.

Example P-position with no clean affine mirror:

`{(0,1,0), (2,2,4), (1,2,0)}`.

This rules out the optimistic "the strategy maintains some adaptive affine mirror" explanation.

### Kernel-Discarding Quotient Projection Also Fails

I also tested quotient projection to `G/6G` while discarding elements that map to zero. This still
does not send sum-free sets to sum-free sets. Examples:

- `Z9`: `{(4,), (5,)}` maps to `{(1,), (2,)}`, not sum-free in `Z3`.
- `Z5 x Z3`: `{(0,2), (1,1)}` maps to `{(1,), (2,)}`, not sum-free in `Z3`.
- `Z2 x Z5 x Z3`: `{(0,0,2), (0,1,1)}` maps to `{(0,1), (0,2)}`, not sum-free in `Z2 x Z3`.

So even a "project non-kernel moves only" morphism is not sound.

## Addendum: Rule Book Residue Shrink

I added `strategy_book_miner.py` to test a "book style" proof architecture for the smallest hard
peel `F3^2 x Z5`.

The strategy form is:

1. First play `(0,1,0)`.
2. At each hero turn, try a fixed ordered list of structural reply families.
3. If no family contains a solver-certified winning reply, use an explicit canonical book entry.

This is not a proof, because the miner uses the solver to choose a winning reply inside each family.
But it measures how much of the oracle strategy can be covered by broad pattern rules, and how small
the remaining finite residue is.

### Meaningful rule shrink

Using only mirror-like rules:

- terminal move
- full negation
- rho on the new factor
- sigma with same/negated `Z5` coordinate

the verified strategy tree needs a book of 4,129 canonical positions.

Using broader but still interpretable local families:

- terminal move
- full negation
- rho
- same `F3^2` fiber, any `Z5` label
- sigma `F3^2` fiber, any `Z5` label
- negated `F3^2` fiber, any `Z5` label
- same `Z5` fiber, any `F3^2` label
- negated `Z5` fiber, any `F3^2` label
- if opponent is in the socle, reply in a mixed fiber
- if opponent is mixed, reply in the socle

the all-lines strategy verifies with a book of only **201 canonical positions**:

- visited states: 128,657
- terminal sizes under this rule+book strategy: `{7: 228, 9: 762, 11: 174, 15: 15}`
- solver nodes used by the verifier/miner: 198,240
- peak RSS: 58 MB

This is the best nontrivial residue shrink so far: the hard peel can be reduced to a small finite
exception book after proving a handful of broad local reply lemmas.

Adding only two coprime-coordinate shift families, `k_reply = k_opp + 1` and `k_reply = k_opp + 3`,
shrinks the book slightly further to **186 canonical positions**. Adding all four shifts
`k+1,k+2,k+3,k+4` shrinks the book to zero, but that is tautological in this finite setting because
together with `sameK` it covers every possible `Z5` coordinate. I do not count that as structural
progress.

### Interpretation

This suggests a plausible "book proof" route:

- Prove the broad local family lemmas.
- Generate and independently verify the 201-entry canonical exception book.
- Try to generalize the finite book by stabilizer or orbit patterns, or use it as the base case for
  an induction over coprime/higher-power factors.

The residue is now small enough to inspect manually or to feed into a certificate checker, but it is
not yet a human proof of the socle reduction.
