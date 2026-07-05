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
