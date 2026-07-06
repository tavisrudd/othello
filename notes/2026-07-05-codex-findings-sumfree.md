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

## Superseding Update: Socle Reduction Is False

The assignment was updated after the book-residue work: the socle reduction is false. The current
counterexample is `Z3^2 x Z7 = P` while its socle `G[6]=Z3^2` is `N`. Therefore the previous goal
"prove outcome depends only on the socle" and the finite-book route are superseded.

I switched to the new target: characterize the `s2<=1, r3>=2` slice, starting with the adaptive
second-player strategy for `Z3^2 x Z7 = P`.

### Go Solver Checks

Using `notes/sumfree-go/cmd_par/sumfree_par.go`, capped by `ulimit -Sv 2097152`, I confirmed:

- `Z3^2 x Z7` from empty: `P`, `0` winning openings, about `902k` nodes with `j=4`.
- After socle opening `(0,1,0)`: `N`, exactly `36` winning replies. These are precisely the mixed
  elements `(w,c)` with `w` off the socle line `<(0,1)>` and `c != 0`.
- After mixed opening `(1,0,1)`: `18` winning replies; negation `(2,0,6)` is among them.
- After coprime opening `(0,0,1)`: `18` winning replies; negation `(0,0,6)` is not among them.

The `p=5` contrast is sharp:

- In `Z3^2 x Z5`, after the same socle opening `(0,1,0)`, the position is `P` with `0` winning
  replies. This is exactly why the socle opening wins for first player at `p=5` but not at `p=7`.

I also tried `p=11` with a 60-second timeout:

- Full reply set after socle opening `(0,1,0)`: timed out after about `4.2M` nodes, `348 MB`.
- Candidate pair `(0,1,0);(1,0,1)`: timed out after about `4.5M` nodes, `348 MB`.

So `p=11` still needs a structural proof or a more compact targeted solver; brute probing remains
inconclusive under the current cap.

### Capped Strategy Extraction for `Z3^2 x Z7`

I patched the Go parallel solver with `--strategy-cap N` and added instrumentation for negation
status. Built a temporary binary at `/tmp/sumfree_par_cap`; no notes binary was overwritten.

Run:

`/tmp/sumfree_par_cap 3,3,7 -j 4 --par-ply 6 --strategy --strategy-cap 500000`

Result:

- strategy-tree positions: `500,000` capped
- decisions: `2,759,440`
- negation replies: `963,612` (`34.9%`)
- exceptions: `1,795,828`
- peak RSS: `181 MB`

By opponent move kind:

- decisions: `mixed=2,522,176`, `socle=237,258`, `coprime=6`
- negation hits: `mixed=963,612`; none for socle or coprime
- exceptions: `mixed=1,558,564`, `socle=237,258`, `coprime=6`

Exception reply kinds:

- `mixed -> mixed`: `1,410,708`
- `mixed -> socle`: `147,856`
- `socle -> mixed`: `204,318`
- `socle -> socle`: `32,940`
- `coprime -> coprime`: `6`

Negation status on exceptions:

- illegal negation: `mixed=1,453,218`, `socle=237,258`
- legal but losing negation: `mixed=105,346`, `coprime=6`

This is a useful structural split. The second-player strategy is not "negation plus a small finite
repair": negation is used only on mixed moves, and even when negation is legal it is sometimes the
wrong strategic reply. The adaptive strategy has to manage mixed elements as a resource, while socle
and pure-coprime moves are handled by non-negation rules.

### Local Line After a Socle Reply

One canonical winning answer to the socle opening is:

`(0,1,0) -> (1,0,1)`.

The resulting two-move position is `P`. From it there are `54` legal first-player continuations:
`6` coprime, `6` socle, `42` mixed.

Representative winning reply sets from the next ply:

- coprime continuation `(0,0,1)`: `7` winning replies, negation not included.
- socle continuation `(1,0,0)`: `5` winning replies, all non-negation.
- mixed continuation `(0,1,1)`: `4` winning replies, non-negation.
- mixed continuation `(1,0,2)`: `4` winning replies, non-negation.
- mixed continuation `(2,1,1)`: `10` winning replies, non-negation.

This reinforces that the first winning mixed reply does not set up a simple negation mirror. It sets
up a P-position with many locally different repair options.

## Round-4 Nimber Pivot

The assignment was updated again: the new focus is the component-decomposition Grundy engine and a
proof of the nimber laws, not more adaptive strategy extraction. I treated
`notes/sumfree-go/cmd_grundy/grundy.go` as read-only and used the built `notes/sumfree-go/grundy`
binary for checks under `ulimit -Sv 2097152`.

### Warm-Up: `G(Z3 x Z_p)=*1` for `p>=7`

Since `Z3 x Z_p` is cyclic for prime `p != 3`, this is the cyclic group `Z_{3p}`. The root has only
three first-move orbits under multiplication by units:

- order `3`: representative `p`;
- order `p`: representative `3`;
- order `3p`: representative `1`.

Exact Grundy values:

| `p` | `G(Z_{3p})` | after order-3 move `p` | after order-`p` move `3` | after generator move `1` |
|---:|---:|---:|---:|---:|
| 5 | 2 | 0 | **1** | 4 |
| 7 | 1 | 0 | 2 | 2 |
| 11 | 1 | 0 | 0 | 6 |
| 13 | 1 | 0 | 3 | 0 |
| 17 | 1 | 0 | 3 | 3 |
| 19 | 1 | 0 | 3 | 3 |

So the theorem `G(Z3 x Z_p)=*1` reduces cleanly to a singleton-orbit lemma:

1. The order-3 singleton `{p}` is always `*0` by the known `n ≡ 3 mod 6` proof: opening on the
   order-3 obstruction blocks its negative mate, and the remaining game is negation-mirrored.
2. For `p>=7`, neither the order-`p` singleton nor the generator singleton has nimber `*1`.
3. Therefore the root option set contains `0` and does not contain `1`, so the root mex is `1`.

This also sharpens the `p=5` explanation in the `r3=1` family: the whole reason `Z3 x Z5 = Z15` has
root value `*2` is that the order-5 singleton has value exactly `*1`. It is not just "small p noise";
the `*1` option appears in exactly the first-move orbit that disappears from the mex obstruction for
checked `p>=7`.

Second-move option histograms for the order-`p` singleton:

| start | child-value histogram |
|---|---|
| `Z15` after `{3}` | `{0: 4, 3: 7}` |
| `Z21` after `{3}` | `{0: 4, 1: 3, 4: 2, 5: 8}` |
| `Z33` after `{3}` | `{1: 13, 2: 4, 3: 4, 5: 2, 7: 4, 8: 2}` |

This explains the observed singleton values:

- `Z15/{3}` has mex `{0,3}` = `1`.
- `Z21/{3}` has mex `{0,1,4,5}` = `2`.
- `Z33/{3}` has no child value `0`, hence the singleton is `0`.

### Component-Decomposition Observation

At depth 1, the residual armed Schur graph is still connected for all three singleton orbits:

| `p` | order-3 singleton | order-`p` singleton | generator singleton |
|---:|---:|---:|---:|
| 5 | one component, size 12 | one component, size 11 | one component, size 11 |
| 7 | one component, size 18 | one component, size 17 | one component, size 17 |
| 11 | one component, size 30 | one component, size 29 | one component, size 29 |
| 13 | one component, size 36 | one component, size 35 | one component, size 35 |
| 17 | one component, size 48 | one component, size 47 | one component, size 47 |
| 19 | one component, size 54 | one component, size 53 | one component, size 53 |

So the component method is not a one-ply root decomposition. The proof has to show the singleton-orbit
lemma by controlling the deeper armed components. For the warm-up, the right immediate target is:

> Prove that in `Z_{3p}`, `p>=7`, the two non-order-3 singleton positions never have value `*1`.

That is strictly weaker and more concrete than proving the full cyclic nimber sequence, and it exactly
proves the Round-4 warm-up.

### Data That Would Most Constrain the Law

Useful next nimbers to request from the compute side:

- More singleton-orbit rows for `Z_{3p}` at primes `p>=23`, especially whether the order-`p` and
  generator singleton values stabilize at `3` or continue varying.
- For the main `r3=2` conjecture: exact `G(Z3^2 x Z_p)` for `p=11,13,17`, plus the post-socle-opening
  nimber after `{(0,1,0)}`.
- First-move orbit nimbers for `Z3^2 x Z_p`: socle-line, mixed, and pure-coprime representatives.

## Round-5 Warm-Up Reduction

The assignment's Round-5 update sharpened the warm-up to one lemma:

> In `Z_{3p}`, `p>=7`, neither non-order-3 singleton has nimber `*1`.

There is an even cleaner sufficient lemma.

### Two-Move Lemma Candidate

For `p>=7`, in `Z_{3p}`:

- `G({p,1}) = *1`
- `G({p,3}) = *1`

Verified values:

| `p` | `G({p,1})` | `G({p,3})` |
|---:|---:|---:|
| 7 | 1 | 1 |
| 11 | 1 | 1 |
| 13 | 1 | 1 |
| 17 | 1 | 1 |
| 19 | 1 | 1 |

`p=23` did not finish in a 45-second local timeout for either two-move position, but memory stayed
small (`~78 MB`). This is a good candidate to request from the compute side.

If the two-move lemma is proved, the warm-up closes immediately:

1. The order-3 singleton `{p}` has value `*0` by the existing `n ≡ 3 mod 6` obstruction proof.
2. The order-`p` singleton `{3}` has a legal move to `{3,p}`, which has value `*1`; hence
   `G({3}) != *1`.
3. The generator singleton `{1}` has a legal move to `{1,p}`, which has value `*1`; hence
   `G({1}) != *1`.
4. Therefore the root option set contains `0` and does not contain `1`, so
   `G(Z_{3p}) = mex(options) = *1`.

This shifts the proof obligation from two arbitrary singleton positions to the two explicit
two-move positions `{p,1}` and `{p,3}`.

### What Failed

For `{p,1}`, the tempting P-child is `{p,1,(p+1)/2}`. It is indeed a P-position for checked
`p=7,11,13,17,19`, but the obvious affine reflection

`x -> p+1-x`

only verifies as a full mirror at `p=7`; it fails for `p>=11`. So the proof of the P-child, and of the
two-move lemma, still needs the component/nimber machinery rather than a static affine mirror.

A stronger possible lemma also failed:

> "`G({p,a})=*1` for every legal `a` outside the order-3 subgroup."

Counterexample at `p=11`: several legal `a ≡ 2 mod 3` give `G({p,a})=*3`. So the correct statement is
not "any second move after the obstruction"; it is specific to the two orbit representatives needed
for the root proof.

### Best Next Data Request

Ask compute side for:

- `G({p,1})` and `G({p,3})` in `Z_{3p}` for `p=23,29,31`.
- Component-type/nimber distributions for the two positions `{p,1}` and `{p,3}` at `p=11` or `p=13`,
  especially the child-value distribution showing why the option values include `0` but exclude `1`.

That data should reveal whether the two-move lemma has a stable component proof or splits by
`p mod 3`.

### Round-5 Analytic Tightening

The two-move lemma can be stated as a pure mex criterion. For `A={p,1}` or `A={p,3}` in `Z_{3p}`,
checked primes `p=7,11,13,17,19` have:

1. at least one legal child of value `0`;
2. no legal child of value `1`.

So `G(A)=1`. The full child-value histograms were:

| start | `p=7` | `p=11` | `p=13` | `p=17` | `p=19` |
|---|---|---|---|---|---|
| `{p,1}` | `{0:9, 2:2, 3:1}` | `{0:5, 2:6, 5:7, 6:6}` | `{0:7, 2:5, 3:10, 5:1, 7:4, 8:3}` | `{0:27, 2:3, 4:2, 5:6, 6:3, 10:1}` | `{0:12, 2:8, 3:3, 6:7, 7:14, 9:1, 11:2, 12:1}` |
| `{p,3}` | `{0:5, 2:2, 3:5}` | `{0:7, 2:4, 4:1, 5:6, 6:5, 7:1}` | `{0:10, 2:7, 3:2, 5:1, 6:2, 7:5, 8:3}` | `{0:19, 2:1, 3:1, 4:2, 5:10, 6:1, 7:2, 9:2, 10:1, 11:2, 12:1}` | `{0:16, 2:10, 3:2, 6:1, 7:13, 9:1, 11:3, 12:2}` |

This is a better target than "find a nice P-child": the invariant to prove is the missing `1` in
the child spectrum.

For the generator branch `{p,1}`, one P-child has a clean form. Put

- `a=p` (order `3`),
- `b=1` (generator),
- `s=a+b`,
- `c=s/2=(p+1)/2`.

Then `{a,b,c}` is P for checked `p=7,11,13,17,19`. The natural affine reflection

`rho(x)=s-x`

is not a proof by itself, but its failure set is now finite and explicit. If `y` is legal after
`{a,b,c}` and `z=rho(y)`, then adding `z` after `y` fails only in these cases:

- the doubling-chain obstruction: `3y=s` or `3y=2s` (present only when `p == 2 mod 3`, giving three
  mirror pairs, hence six opponent moves);
- the quarter-point obstruction: `y=3s/4`, `z=s/4`, where `z+z=c` and `z+c=y` (one opponent move
  when it is legal; for `p=7` it is already illegal).

Observed reflection failures for `{p,1,(p+1)/2}`:

| `p` | failures of `rho(x)=p+1-x` |
|---:|---|
| 7 | `[]` |
| 11 | `[4,8,9,15,19,26,30]` |
| 13 | `[30]` |
| 17 | `[6,12,23,29,39,40,46]` |
| 19 | `[15]` |

So a book-style proof for this P-child no longer has to control the whole residual game: the affine
mirror controls all but at most seven first deviations, and those deviations are given by two
linear congruence patterns.

For the order-`p` branch `{p,3}`, the earlier candidates `(p+3)/2`, `(p-3)/2`, `(p+1)/2`, `p-1`, and
`p+1` cover some small primes but all miss at `p=19`. The update below gives the missing uniform
candidate: `6-p`.

### Round-5 Update: Common AP-Mirror Residue for Both Two-Move Branches

The assignment update reports that the fingerprint engine confirms the two-move lemma through
`p=29`:

- `G({p,1})=1` for `p=23,29`;
- `G({p,3})=1` for `p=23,29`.

More importantly, the order-`p` branch now has the same kind of explicit P-child as the generator
branch. The missing uniform representative was

`c = 2*3 - p = 6-p mod 3p`.

For `p>=11`, the position `{p,3,6-p}` is P in every checked case:

| `p` | `6-p mod 3p` | `G({p,3,6-p})` |
|---:|---:|---:|
| 11 | 28 | 0 |
| 13 | 32 | 0 |
| 17 | 40 | 0 |
| 19 | 44 | 0 |
| 23 | 52 | 0 |

At `p=7`, this particular child has value `2`, so the small base case still uses a different P-child
such as `5=(p+3)/2`.

Both explicit P-children are instances of the same arithmetic-progression mirror lemma. Work in
`Z_{3p}` and put `a=p`, so `3a=0`. Let `v` be the midpoint and let

`T(v) = {a, v, 2v-a}`.

The affine reflection

`rho(x) = 2v - x`

swaps `a <-> 2v-a` and fixes `v`. If `y` is legal after `T(v)`, `z=rho(y)`, and adding `z` after `y`
is illegal, then the obstruction is one of only three linear equations:

1. `3y = 2v`;
2. `3y = 4v`;
3. `2y = 3v`.

Sketch of the reduction: any new Schur violation involving `z` and two old points reflects to an
already-forbidden violation involving `y`, except when the new triple uses `y` itself or the fixed
point `v`. The cases are exactly `y+y=z`, `z+z=y`, and `z+v=y`/`z+z=v`, which give the three equations
above. The apparent extra cases `z+a=y` and `z+(2v-a)=y` force `y+v=2v-a` or `y+a=2v-a`, so `y` was
not legal in the first place; this is where `3a=0` is used.

This single lemma explains both finite residues:

- Generator branch `{p,1}`: choose `v=(p+1)/2`, so `2v-a=1`. This recovers the previous mirror
  `rho(x)=p+1-x`.
- Order-`p` branch `{p,3}`: choose `v=3`, so `2v-a=6-p`. This gives the new mirror
  `rho(x)=6-x`.

For `{p,3,6-p}`, the reflection failures are therefore explicitly

`{2,4,p+2,p+4,2p+2,2p+4,q_p}`, where `q_p = 9/2 mod 3p`,

with sorting modulo `3p`. Observed:

| `p` | failures of `rho(x)=6-x` after `{p,3,6-p}` |
|---:|---|
| 11 | `[2,4,13,15,21,24,26]` |
| 13 | `[2,4,15,17,24,28,30]` |
| 17 | `[2,4,19,21,30,36,38]` |
| 19 | `[2,4,21,23,33,40,42]` |
| 23 | `[2,4,25,27,39,48,50]` |

So both required two-move positions have an explicit AP child whose residual is controlled by a
mirror except for at most seven algebraically specified first deviations. The remaining proof residue
has been narrowed to:

1. prove the seven exceptional branches have P-replies uniformly, hence `T(v)` is P;
2. prove the other legal children of `{p,1}` and `{p,3}` never have value `1`.

The AP-mirror lemma handles the first P-child candidate uniformly; it does not yet prove the missing
`1` in the full child spectrum.

## Round-6 Recheck: Current Target Is Missing `*1`

The assignment was updated again after the AP-child correction. The `*0`-present half is now closed:
for every non-order-3 `k`, `{p,k,-k}` is `*0` by Fact C applied to the symmetric set `{k,-k}`. So the
AP-child route and the finite-exception book for `6-p` are superseded.

The active target is now the single remaining half of the two-move lemma:

> For every prime `p>=7`, no legal child of `{p,1}` or `{p,3}` has nimber `*1`.

I re-ran the relevant `--compdump` checks with the correct cyclic `--start` syntax, using semicolons
(`--start 'p;k'`). Comma syntax is for coordinates in product groups, not multiple elements in a
cyclic group.

Correct parent-level compdump confirmations:

| start | child-nimber histogram | component structure |
|---|---|---|
| `{11,1}` | `*0:5 *2:6 *5:7 *6:6` | every child one component |
| `{11,3}` | `*0:7 *2:4 *4:1 *5:6 *6:5 *7:1` | every child one component |
| `{13,1}` | `*0:7 *2:5 *3:10 *5:1 *7:4 *8:3` | every child one component |
| `{13,3}` | `*0:10 *2:7 *3:2 *5:1 *6:2 *7:5 *8:3` | every child one component |
| `{23,1}` | `*0:34 *3:2 *4:16 *5:3 *9:2 *10:3` | every child one component |
| `{23,3}` | `*0:53 *3:1 *4:2 *9:2 *10:2` | every child one component |

This strengthens the compute-side warning: the missing `*1` is not an XOR cancellation fact at this
depth.

### CRT/Fiber Reduction

There is a cleaner model after the order-3 element `p` has been played. Use CRT coordinates

`Z_{3p} ~= F_p x F_3`.

The element `p` has `F_p` coordinate `0`. If a non-order-3 element `x` is present, then `x+p` and
`x-p` are immediately illegal because they complete a Schur triple with `p`. Therefore, after `p` is
placed, each nonzero `F_p` fiber can contain at most one played element.

The residual game can be viewed as building a partial colored set

`f: S subset F_p^* -> F_3`,

with one color per used `F_p` coordinate, and forbidding colored Schur equations

`r_i + r_j = r_l` and `c_i + c_j = c_l`.

Automorphisms fixing `p` have multiplier `u == 1 mod 3`, so they preserve the `F_3` color and scale
the `F_p` coordinate. Thus the two starts normalize to one used fiber:

- `{p,1}` becomes the colored point `(1,1)`;
- `{p,3}` becomes the colored point `(1,0)`.

The missing-`*1` statement is equivalently: after either initial colored point, every legal second
colored point `(s,d)` gives a two-defect colored position whose Grundy value is never `1`.

### Reply-Formula Mining

For each non-P child of `{p,k}` through `p=19`, I mined its moves to `*1`. Every sampled non-P child
does have at least one `*1` option, as mex requires, but the witness is not a simple uniform affine
formula in `p,k,y`.

Sample set: all non-P children of `{p,1}` and `{p,3}` for `p=11,13,17,19` (`185` cases). Results:

- the mate replies `-k` or `-y` hit a `*1` option in `130/185` cases;
- no single formula `a*p + b*k + c*y` with `a in {0,1,2}` and `|b|,|c|<=5` hits a `*1` option in all
  cases;
- a greedy cover over that small affine family still needed `12` formulas, with irregular leftovers.

So the proof is not a closed-form reply table.

## Round-7 Doc Check: Updated Current Instructions

The assignment now has an authoritative "CURRENT INSTRUCTIONS" block, superseding the Round-6 text
and my previous proposed next step. The open statement remains the `*1`-absent half, but the method is
more sharply pinned:

> For `p>=7`, no child of `{p,1}` or `{p,3}` has nimber `*1`.

Equivalently in the colored-fiber frame: a **bare two-defect** position `{p,e,z}` with no symmetric
colored pair is never `*1`.

The previous induction idea "every non-P two-defect has a one-defect `*1` child" is false; the
compute note reports `33/91` failures at `p=11`. Also, two-defect `*1` positions do exist, but every
one seen carries at least one symmetric colored pair. Therefore the right recursion variable is not
just defect count; it is `(defect-count, pair-count)`.

Current ruled-out routes:

- child-level component/XOR decomposition;
- AP-mirror `*0` route;
- fixed single-token pairing/mirror on `{p,e}+*1`;
- static board-signature or `F_3`-color monovariants;
- more brute sweeps past the current oracle range.

Current viable route:

- Build an adaptive, non-pairing strategy for `{p,e}+*1`.
- Use the mirror-break lemma: for a single-defect board `{p} union S union {d}` with `S=-S`, every
  legal move mirrors under negation except the at-most-three moves whose mirrors hit the defect blocks
  `{2d, d+p, d/2}`.
- Induct/control the state by `(defect-count, pair-count)` in the colored-fiber model.

### Adaptive Strategy Shape

I added `2026-07-06-sumfree-defect-automaton.py` to extract an oracle responder strategy for
`{p,e}+*1` for small `p`, choosing replies in this
priority order where possible:

1. take the token if Alice's board move lands on a P child;
2. mirror Alice's new move if that lands back on a `*1` board;
3. close an existing defect if that lands back on a `*1` board;
4. otherwise choose a `*1` board reply minimizing `(defect-count, -pair-count, size)`.

This is not a proof, but it describes the adaptive lane's shape.

Reproduce:

`python3 notes/2026-07-06-sumfree-defect-automaton.py --primes 7,11,13 --branches 1,3 --max-rows 12`

| start | token-present `*1` boards reached | reply counts |
|---|---:|---|
| `{7,1}` | 4 | mirror 3, take-token 19 |
| `{7,3}` | 8 | close-defect 4, adaptive 3, take-token 22 |
| `{11,1}` | 89 | mirror 38, close-defect 23, adaptive 47, take-token 327 |
| `{11,3}` | 82 | mirror 37, close-defect 22, adaptive 39, take-token 352 |
| `{13,1}` | 220 | mirror 123, close-defect 64, adaptive 64, take-token 1248 |
| `{13,3}` | 204 | mirror 144, close-defect 49, adaptive 48, take-token 1130 |

The reached token-present `*1` boards lie in a simple shape ladder:

`(size, defects, pairs) = (2,1,0), (4,1,1), (4,3,0), (6,1,2), (6,3,1), (6,5,0), ...`

So the adaptive strategy naturally tracks `(defect-count, pair-count)`: mirror/close-defect moves
shift toward more pairs, while genuinely adaptive replies sometimes create higher odd defect-count
boards with fewer pairs. This matches the current assignment's warning that pair-count, not just
defect-count, is load-bearing.

Transition grammar visible in the oracle:

- `mirror-new`: `(size, defects, pairs) -> (size+2, defects, pairs+1)`;
- `close-defect`: also shifts toward one more symmetric pair, usually preserving the defect count
  after Alice creates a fresh defect;
- `old/new-defect-block` and `adaptive-other`: typically
  `(size, defects, pairs) -> (size+2, defects+2, pairs)`;
- `take-token`: Alice has moved to a P child, so Rita cashes the `*1` token and leaves the board game
  at `*0`.

This suggests a proof by defining a safe recursively-generated class `Safe(d,c)` of token-present
`*1` boards: every Alice move either is a P child (cash token), admits a pair-gaining mirror/close
reply, or is one of the defect-block cases where Rita can move to the next higher-defect same-pair
safe class. The missing piece is a symbolic existence proof for the last branch.

### Defect-Block Candidate Is Incomplete

I also tested a local candidate for the `*1` reply from a non-P bare two-defect board `{p,k,y}`:
try closing either defect (`-k`, `-y`) or playing the negation of one of either defect's three
mirror-break blocks (`-2d`, `-(d+p)`, `-d/2` for `d in {k,y}`).

Coverage among non-P children of `{p,k}`:

| p | k | non-P children | covered by close/break candidates | misses |
|---:|---:|---:|---:|---:|
| 11 | 1 | 19 | 16 | 3 |
| 11 | 3 | 17 | 12 | 5 |
| 13 | 1 | 23 | 19 | 4 |
| 13 | 3 | 20 | 16 | 4 |
| 17 | 1 | 15 | 15 | 0 |
| 17 | 3 | 23 | 23 | 0 |
| 19 | 1 | 36 | 32 | 4 |
| 19 | 3 | 32 | 32 | 0 |

Thus the three-block mirror-break lemma is the right localization for single-defect boards, but a
bare two-defect proof still needs a genuinely adaptive recursion. The local "close a defect or reply
at a defect block" rule is not sufficient.

### Initial-Layer Colored Probe

I added `2026-07-06-sumfree-initial-layer.py` to isolate the first hard layer. It normalizes
`{p,e,y}` in the colored-fiber coordinates by the unique multiplier `u == 1 (mod 3)` with
`u e == 1 (mod p)`, so the initial defect is `(1, e mod 3)`, and then records every `*1`
reply `z` to the non-P child.

Reproduce:

`python3 notes/2026-07-06-sumfree-initial-layer.py --primes 7,11,13 --branches 1,3 --max-rows 6`

This sharpened the previous negative result:

- even after considering **all** `*1` replies, not just the oracle's chosen reply, there are
  initial children whose only `*1` replies are `adaptive-other`;
- the adaptive-only residue already appears at `p=11,13`, so the first transition
  `(2,1,0) -> (4,3,0)` cannot be replaced by "mirror, close a defect, or hit one of the three
  defect-blocks";
- a small normalized affine cover is fragmented.  For example:

| start | P children | adaptive-only non-P children | greedy small-affine cover of adaptive-only |
|---|---:|---:|---|
| `{11,1}` | 5 | 3 | `2y;cy+ce`, `1-y;cy+ce`, `2y-1;cy` |
| `{11,3}` | 7 | 5 | `-2y+1;1` hits 2, then three singleton formulas |
| `{13,1}` | 7 | 4 | `-2y;-ce` hits 2, then two singleton formulas |
| `{13,3}` | 10 | 4 | four singleton formulas |

The Go oracle gives the larger first-layer sanity check quickly:

- `{17,1}` child spectrum is `{*0:27 *2:3 *4:2 *5:6 *6:3 *10:1}`;
- `{17,3}` child spectrum is `{*0:19 *2:1 *3:1 *4:2 *5:10 *6:1 *7:2 *9:2 *10:1 *11:2 *12:1}`.

So `*1` is still absent at the base layer, but the P-locus has become large rather than cleaner.

I also checked whether the shape ladder itself could be the invariant. It cannot: among canonical
positions with `p` present and `2p` absent, shape is only a coarse guide.  For instance:

| p | shape `(size, defects, pairs)` | `*1` boards / all boards |
|---:|---|---:|
| 11 | `(4,1,1)` | `10/17` |
| 11 | `(4,3,0)` | `24/92` |
| 11 | `(6,3,1)` | `91/161` |
| 13 | `(4,1,1)` | `13/25` |
| 13 | `(4,3,0)` | `43/155` |
| 13 | `(6,3,1)` | `241/526` |

So `(defect-count, pair-count)` is the recursion variable, but not the whole state descriptor.
The eventual safe class needs an additional mex/strategy witness.

Conclusion: the proof obligation should be stated as a closure property of a recursively generated
safe class, not as a closed-form reply function.  A plausible next lemma is:

> For every safe one-defect token position `{p} union S union D + *1`, any Alice move either lands on a
> P child, admits a pair-gaining safe reply, or admits a defect-expanding safe reply.  The last case is
> allowed to depend on the current safe witness, not just on `(p,e,y)`.

This is closer to a strategy certificate / invariant than to a formula table.  The first layer shows
why the witness has to carry recursion state: the same normalized affine forms that help one residue
class are singleton-only in another.

## R3=2 Doc Check: Two 2-Element P-Lemmas

The assignment's current block now also promotes the rank-2 lift:

`G(Z_3^2 x Z_p)=*0` for `p>=7`

has been reduced by the compute note to two existential P-lemmas:

- **Lemma A:** `{(0,1,0),(1,0,1)}=*0`;
- **Lemma B:** `{(0,0,1),(0,1,1)}=*0`.

Lemma A certifies both the socle and mixed openings; Lemma B certifies the coprime opening.
The p=5 exception localizes to Lemma A (`*3` at p=5), while Lemma B remains P at p=5.

I added `2026-07-06-r32-pairing-mine.py`, which uses the existing Go `grundy` oracle to mine the
first reply layer after one of these 2-element P positions.  It summarizes reply types and tests
small formulas of the form

`b = c_a a + c_s s + c_t t`

where `a` is Alice's move and `{s,t}` is the candidate P-position.

Reproduce:

`python3 notes/2026-07-06-r32-pairing-mine.py 7 0,1,0 1,0,1 --max-rows 16`

`python3 notes/2026-07-06-r32-pairing-mine.py 7 0,0,1 0,1,1 --max-rows 16`

At p=7:

| lemma | legal Alice moves from `{s,t}` | best small formula hit | greedy cover shape |
|---|---:|---|---|
| A `{socle,mixed}` | 54 | `2a-s+2t` hits `21/54` | needs 11 formula pieces in the tested family |
| B `{coprime,mixed}` | 53 | `-s-t` hits `46/53` | `-s-t` hits 46, then 5 and 2 more |

The "mutual partner" count printed by the script is mostly a sanity check: if `{s,t,a,b}` is a P
child then the set is unordered, so `a` and `b` reply to each other whenever both are legal from
`{s,t}`.  It is not itself a proof certificate.  The useful information is the formula coverage and
the type split.

### Lemma B: Zero-Sum Triple Lead (Killed at p=11)

This subsection is now historical.  Compute session `--5` directly refuted the proposed uniform
zero-sum-triple mechanism at `p=11`, so none of the p=7 observations below should be used as a proof
route for Lemma B.

The refuting value is:

`{s,t,-s-t}={(0,0,1),(0,1,1),(0,2,9)}`

in `Z_3^2 x Z_11`, with value `*6`, not `*1`.  Its child spectrum is

`{*0:30 *1:2 *2:1 *3:4 *4:30 *5:1 *8:12}`.

Thus the claim "every legal child of `{s,t,-s-t}` is P" is false at `p=11`.  The constant reply
`r=-s-t` explains a large p=7 pocket but does not win uniformly.

The p=7 mining originally suggested a cleaner first-layer mechanism than Lemma A.  Let

`s=(0,0,1)`, `t=(0,1,1)`, and `r=-s-t=(0,2,-2)`.

At `p=7`, the zero-sum triple `{s,t,r}` has value `*1`, and every one of its legal children is P:

`grundy 3,3,7 --start '0,0,1;0,1,1;0,2,5' --children`

returns child spectrum `{*0:46}` and hence `G({s,t,r})=*1`.

At p=7, this explains the large constant-reply pocket in Lemma B: if Alice plays a move `a` from
`{s,t}` and `r` remains legal, Bob can reply `r`, landing on the P child `{s,t,r,a}` of the zero-sum
triple.

The moves that make `r` illegal are bounded and algebraic.  For `p>=7`, they are contained in

`{ r, -s, -t, 2r, r-s, r-t, s-r, t-r, r/2 }`,

with overlaps depending on `p`.  Counts from the legality calculation:

| p | blockers for the reply `r=-s-t` |
|---:|---:|
| 7 | 7 including `r` itself |
| 11 | 9 including `r` itself |
| 13 | 9 including `r` itself |

At `p=5`, this bounded-blocker description fails in the expected small-prime way: many off-subgroup
moves block `r`, and the zero-sum triple still has value `*1` but only one P child.  The p=11
computation shows that the p=7 success was another small-prime coincidence, not a p>=7 separation.

The blocker-set derivation is elementary.  Assume Alice has made a legal move `a` from `{s,t}` and
Bob wants to add `r`.  Since `{s,t,a}` and `{s,t,r}` are already sum-free, a new Schur violation after
adding `r` must use both `a` and `r`, or use `r+r=a`, or use `a+a=r`.  Thus the only possibilities are

- `a=r` (Alice has taken the intended reply);
- `2r=a`;
- `2a=r`, i.e. `a=r/2`;
- `a+r=s` or `a+r=t`, i.e. `a=s-r` or `a=t-r`;
- `a+s=r` or `a+t=r`, i.e. `a=r-s` or `a=r-t`;
- `s+r=a` or `t+r=a`, i.e. `a=-t` or `a=-s` because `r=-s-t`.

Intersecting this nine-element candidate set with the legal moves from `{s,t}` gives the actual
blockers.  Some candidates can be illegal before Bob moves; for example at `p=7`, `r-s=(0,2,4)` is
not an Alice move because `2(r-s)=t`.

For the seven p=7 blocker cases, the Go oracle gives P replies in each case.  Example spectra:

- Alice `a=r=(0,2,5)`: child spectrum `{*0:46}`, so after Alice takes `r`, Bob can play any legal
  child of the zero-sum triple.
- Alice `a=-s=(0,0,6)`: child spectrum includes `*0:8`.
- Alice `a=2r=s-r=(0,1,3)`: child spectrum includes `*0:3`.

This was the proposed proof split for Lemma B, now invalid:

1. Prove the zero-sum triple lemma for `p>=7`: every legal child of `{s,t,-s-t}` is P.
2. Handle the bounded Schur-blocker set for `r` by a small algebraic table.

Step 1 is false at `p=11`.  Do not continue this as a proof route.  The remaining open question is
whether Lemma B itself, `{s,t}=*0`, survives at `p=11`; if it does, its proof has to use a different
P-reply/adaptive certificate.

### Lemma B: What the Zero-Sum Triple Is Not

I checked two tempting simplifications of the zero-sum triple route.

First, the triple is not explained purely by its cyclic subgroup.  It lies in the subgroup
`{first coordinate = 0} ~= Z_3 x Z_p ~= Z_{3p}`.  In CRT coordinates it is:

| p | cyclic coordinates for `{s,t,r}` in `Z_{3p}` | cyclic value |
|---:|---|---|
| 7 | `{15,1,5}` | `*1`, children all `*0` |
| 11 | `{12,1,20}` | `*0` |
| 13 | `{27,1,11}` | `*6` |
| 17 | `{18,1,32}` | `*5` |

So the full `Z_3^2 x Z_p` ambient structure is doing real work; the cyclic subgroup value does not
uniformly carry the triple.

Second, I added two mirror-certificate probes:

- `2026-07-06-r32-zero-triple-mirror.py`: tests point reflections `x -> c-x`;
- `2026-07-06-r32-affine-involution-cert.py`: tests structured affine involutions
  `(h,k) -> (M h + b, alpha k + beta)` with `M in GL(2,3)` and `alpha in {1,-1}`.

At p=7 neither family certifies any of the 46 P-children of `{s,t,r}`:

`python3 notes/2026-07-06-r32-affine-involution-cert.py --p 7 --max-rows 12`

reports `certified children: 0/46`.

Thus even before the p=11 refutation, the cleaner Lemma-B zero-sum triple was not a hidden global
affine mirror.  The split that looked useful at p=7 was:

- generic first reply `r=-s-t`;
- bounded blocker table for when `r` is unavailable;
- adaptive proof/certificate for the P children of `{s,t,r}`.

After compute session `--5`, this split should be treated as a p=7 postmortem only.

I added `2026-07-06-r32-position-reply-mine.py` to inspect that last layer.  Representative p=7
P-children of `{s,t,r}` have small but piecewise oracle-reply covers:

| child `a` added to `{s,t,r}` | legal opponent moves | greedy cover in tested linear forms |
|---|---:|---|
| `(0,0,3)` coprime | 42 | 2 pieces |
| `(1,0,0)` socle | 35 | 5 pieces |
| `(1,0,1)` mixed | 34 | 5 pieces |

At p=7 this pointed to a finite adaptive certificate for the zero-sum triple children, not an
involution lemma.  Since the triple fails at p=11, mining those certificates is no longer a direct
Lemma-B proof path; it is useful only for understanding why the p=7 pocket was misleading.

I then computed the stabilizer orbits of legal children of `{s,t,r}` under the subgroup of
`GL(2,3) x F_p^*` that fixes the triple.  Since `s=(0,0,1)` is the only pure-coprime point in the
triple, the `F_p^*` scale is forced to `1`; the stabilizer is the 6-element subgroup of `GL(2,3)`
fixing the socle vector of `t`.

Orbit counts by legality only:

| p | legal children of `{s,t,r}` | stabilizer orbits | inline orbits | off-line orbits |
|---:|---:|---:|---:|---:|
| 7 | 46 | 11 | 4 | 7 |
| 11 | 80 | 25 | 14 | 11 |
| 13 | 98 | 33 | 20 | 13 |
| 17 | 134 | 49 | 32 | 17 |

The off-line part is one orbit for each `Z_p` fiber (`k=0,...,p-1`).  Thus the hoped-for "small
finite table" was already too optimistic; after the p=11 failure, the p=7 table is best kept as
reverse-engineering data rather than a prototype to lift.

### Lemma B: Fiber-Level Prototype at p=7

I added `2026-07-06-r32-zero-triple-fiber-mine.py` to mine the off-line family

`B_k = {s,t,r,(1,0,k)}`.

At p=7 all seven `B_k` are P, but their largest reply pockets are not a single uniform formula in
the tested linear family.  The script output:

| k | legal opponent moves from `B_k` | greedy cover piece sizes | first piece |
|---:|---:|---|---|
| 0 | 35 | `16 11 5 2 1` | `-2s+r-a` |
| 1 | 34 | `17 9 5 2 1` | `-2s+t-r` |
| 2 | 34 | `21 7 4 1 1` | `-2s-t-r+2a` |
| 3 | 35 | `22 9 4` | `-2s+2t+r` |
| 4 | 34 | `14 10 5 3 1 1` | `-2s-t+a` |
| 5 | 35 | `13 8 5 4 2 1 1 1` | `-2s+t+r+2a` |
| 6 | 34 | `14 10 4 3 2 1` | `-2s-t-r-2a` |

The first pieces are all constant replies (coefficient of the opponent move is `0`), but the
constant varies with the fiber.  Counting literal constant replies confirms this is not just a
coefficient-tie artifact; e.g. the best constants cover:

| k | best literal constant reply | hits |
|---:|---|---:|
| 0 | `(2,2,3)` | 16 |
| 1 | `(0,2,1)` | 17 |
| 2 | `(2,0,3)` | 21 |
| 3 | `(0,1,5)` | 22 |
| 4 | `(1,2,1)` | 14 |
| 5 | `(2,0,0)` | 13 |
| 6 | `(1,0,1)` | 14 |

The p=7 data looks like "constant-pocket plus repairs" with the constant depending on `k`, but the
p=11 failure of the parent triple means these `B_k` boards are not currently high-value Lemma-B
targets.

Local p=11 spot checks of `B_0` and `B_1` both hit a 60-second timeout with the Go oracle:

- `grundy 3,3,11 --start '0,0,1;0,1,1;0,2,9;1,0,0'`;
- `grundy 3,3,11 --start '0,0,1;0,1,1;0,2,9;1,0,1'`.

These timeouts are now superseded by the full p=11 triple computation.  Even if some `B_k` happen to
be P at p=11, the parent `{s,t,r}` is not `*1`, so the zero-sum-triple route no longer supplies the
generic first reply for Lemma B.

### Lemma B: Alpha Reflection Diagnostic

The compute note points out a special Lemma-B involution

`alpha(a,b,k)=(-a,b,k)`,

fixing the axis subgroup `F={a=0}` that contains `s,t,r`.  I added
`2026-07-06-r32-alpha-mine.py` to measure exactly what this handle does.

At the first layer from `{s,t}` for p=7:

- axis legal moves: `11`;
- off-axis legal moves: `42`;
- `alpha` reply illegal: `6`;
- `alpha` reply legal: `36`;
- among legal `alpha` replies, values are `*0:20, *3:10, *4:2, *6:4`.

The illegal `alpha` replies are precisely where the deposited axis sum

`d=a+alpha(a)`

is already forbidden by the seed structure:

| Alice move `a` | `alpha(a)` | deposit |
|---|---|---|
| `(1,0,0)` | `(2,0,0)` | `(0,0,0)` |
| `(1,0,4)` | `(2,0,4)` | `s=(0,0,1)` |
| `(1,2,4)` | `(2,2,4)` | `t=(0,1,1)` |

and the three `a_1=2` mirrors of these.

The legal `alpha` reply is not value-preserving.  The full alpha-pair board's value is also not the
standalone axis value:

| deposit `d` | full `{s,t,a,alpha(a)}` value | standalone axis `{s,t,d}` value |
|---|---:|---:|
| `(0,0,2)` | `*0` | `*3` |
| `(0,0,3)` | `*3` | `*1` |
| `(0,0,6)` | `*4` | `*3` |
| `(0,1,0)` | `*0` | `*0` |
| `(0,1,4)` | `*3` | `*1` |
| `(0,2,0)` | `*6` | `*2` |
| `(0,2,4)` | `*3` | `*0` |

So `alpha` confirms the coupling mechanism but does not by itself prove Lemma B.

I also checked whether `alpha` helps one layer later, from the zero-sum triple `{s,t,r}`.  It does
not: among off-axis legal children of `{s,t,r}` at p=7, `alpha` is illegal for `8`; for the `34`
legal `alpha` replies, values are `*1:28, *2:4, *5:2` and **none are P**.

Conclusion: `alpha` is best treated as a diagnostic for the axis-deposit obstruction, not as the
strategy.  The actual Lemma-B certificate, if Lemma B survives at p=11, must use a different reply
mechanism than the zero-sum-triple constant lane.

Finally, I tried the boolean solver on the first higher-p fiber targets:

- `sumfree_par 3,3,11 --start '0,0,1;0,1,1;0,2,9;1,0,0'`;
- `sumfree_par 3,3,11 --start '0,0,1;0,1,1;0,2,9;1,0,1'`.

Both hit a 60-second timeout after roughly `3.6-3.7M` nodes, so Claude's higher-n compute remains
the right source for these confirmations.

### Lemma B: Current Next Data Needed

The live branch is now:

- direct value of Lemma B at `p=11`, i.e. `{(0,0,1),(0,1,1)}`;
- if it is P, dump first-layer P replies from `{s,t}` at `p=11`;
- compare formula coverage for the non-`r=-s-t` p=7 candidates, especially `-a-s+t` and
  `-a+2s-2t`;
- if Lemma B is not P at `p=11`, the two-lemma reduction needs a replacement P-reply for the coprime
  opening rather than a proof of this representative.

Until that data arrives, the safe statement is: Lemma A/B remain the right stated targets from the
assignment, but Lemma B's p=7 zero-sum triple explanation has been killed.
