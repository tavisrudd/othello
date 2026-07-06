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

## Round-6 AP-Child Check

The Round-6 banner asks for a uniform proof that the AP-child

`T(v) = {p, v, 2v-p}`

is P in the two cases `v=(p+1)/2` and `v=3`, i.e.

- `{p,1,(p+1)/2}` is P for all primes `p>=7`;
- `{p,3,6-p}` is P for all primes `p>=11`.

The second requested statement is false as written. The exact component-Grundy data already recorded
in `2026-07-05-sumfree-nimber-engine.md` and `2026-07-05-sumfree-warmup-reduction.md` gives

`G({29,3,64}) = *4` in `Z_87`,

so `{p,3,6-p}` is not a P-position at `p=29`. The current `HEAD` commit message repeats the same
conclusion: `{31,3,68}=*0` recovers at `p=31`, but the `p=29` value remains a sporadic `*4`
exception. Therefore no uniform proof of the Round-6 `{p,3,6-p}` claim can exist.

This does not refute the two-move lemma `G({p,3})=*1`; it refutes only this proposed uniform P-child
witness. The corrected target for the `*0`-present half must allow a finite exception book for the
`{p,3}` branch, at least including `p=7` and `p=29`, while the `{p,1,(p+1)/2}` branch remains
compatible with all recorded data.
