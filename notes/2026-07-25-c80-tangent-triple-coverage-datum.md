# C80 — tangent-plus-triple coverage datum

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

The full continuation complex has an exact bounded-arity coverage coordinate,
but greedily minimizing it is not a sound reply rule.

For a target `T`, legal opponent/reply pair `x,y`, and
`V=Legal(T)`, let `C_x,C_y` be the tangent pair-conflict neighborhoods of
`x,y` in `V`, and let `L_xy` be the remaining legal trace on the line `xy`.
Then

```text
kappa_T(x,y) = |Legal(T+x+y)|
             = |V|-2-|C_x|-|C_y|+|C_x intersect C_y|-|L_xy|.
```

Thus `kappa=0` is exactly the terminal-reply condition. This is the desired
tangent-plus-collinear-triple decomposition, and the generator verifies it
against direct grid legality on every legal pair in the four q17 repair
targets and the q19 control.

The natural candidate “reply with minimum `kappa`” fails:

- At q17 the ten terminal-core opponents have minimum zero. The 22 isolates
  have minimum deficiencies `1^8 2^13 3^1`, but only `4/22` have any
  P-valued minimizer. Across all 32 opponent fibres the minimizing
  correspondence has 64 oriented edges, split `21 P + 43 N`.
- At q19 every opponent is a terminal-graph isolate. The minimum-deficiency
  histogram is `3^3 4^17 5^8 6^18 7^4 8^1`; only `19/51` opponents have a
  P-valued minimizer. Its 76 oriented minimizing edges split
  `21 P + 55 N`.

So `kappa` is an exact residual-height coordinate, not a value certificate.
Maximum coverage repeats the earlier maximum-drain failure in a sharper
form: making the legal locus as small as possible can enter an N absorber.
C82 remains gated.

## Exact identity

After adding `x`, the legal vertices removed from `V-{x}` are precisely
`C_x`; similarly for `y`. Inclusion-exclusion therefore leaves

```text
|V|-2-|C_x|-|C_y|+|C_x intersect C_y|.
```

The only new obstruction requiring both moves at once is collinearity with
the pair `x,y`. Its still-legal trace is `L_xy`. This trace is disjoint from
both one-move conflict neighborhoods, so subtracting `|L_xy|` gives exactly
the legal locus after both moves.

This proof uses the two kinds of minimal nonface in the continuation complex:
tangent-coordinate pair conflicts and collinear triples. It applies to conic
moves, split intruders, and external intruders without a matching-domain
case split.

## Finite falsifier

The four q17 repair targets are transported copies and have the same census:

| opponent status | minimum `kappa` | opponents | any P minimizer |
| --- | ---: | ---: | ---: |
| terminal core | 0 | 10 | 10 |
| isolate | 1 | 8 | included below |
| isolate | 2 | 13 | included below |
| isolate | 3 | 1 | included below |
| all isolates | 1–3 | 22 | 4 |

The terminal core is recovered exactly because `kappa=0` means that the
opponent/reply pair is a maximal two-face. The new information is negative:
18 of the 22 obligations outside that graph are sent only to N positions by
every maximum-coverage reply.

At q19 the minimum is never bounded by the q17 range: it spans `3..8`.
This does not by itself prove that the minimum grows unboundedly with `q`,
but it removes both the q17 constant-three guess and value soundness at the
first control order.

Every recorded minimum fibre, terminal/core label, and P/N multiset commutes
with the full projective stabilizer. The failure is therefore intrinsic, not
a coordinate or tie-breaking artifact.

## What survives

`kappa` is useful as an exact **obligation size**:

```text
kappa_T(x,y) = number of uncovered legal continuations.
```

The next proof object must carry structure on that uncovered locus rather
than merely minimize its cardinality. In particular, a viable rewrite has
to preserve a positive boundary resource while updating the tangent/triple
coverage obligation. A scalar lexicographic patch is low-value: the prior
overload, retention, and feature-threshold probes already show that finite
separation does not supply a recursive proof.

The cheapest next test is to classify the q17 `kappa=1,2` uncovered loci and
ask whether their one-/two-point obligations admit one direct,
transport-natural rewrite separating the four P-carrying isolates from the
18 N-only isolates. That is a proof-object test, not another profile fit.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_tangent_triple_coverage_datum.py
python3 rust/scripts/c80_tangent_triple_coverage_datum.py --check
```

The generator reconstructs the four q17 targets and q19 control, checks the
coverage identity against the direct legal mask for every pair, evaluates
all minimizing successors by exact grid recursion, tests strict-kernel
membership, and recomputes representative fibres under the full
stabilizers. The JSON is canonical sorted data; `--check` regenerates it and
requires byte equality.

Artifact hashes are recorded after final regeneration:

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_tangent_triple_coverage_datum.py` | 11,726 | `f7bd4d77d21d607422a7186f96c704cfd1a63a67fee90f6188a08ecdce2354cd` |
| `notes/2026-07-25-c80-tangent-triple-coverage-datum.json` | 194,108 | `f0b411405bfeb2d8234838be49628226c80e6edf4b4b1c5693a419101fde9777` |

The coverage identity has a field-uniform proof above. P/N labels and the
finite q17/q19 censuses retain the normalized prime-grid computational trust
boundary; they are not a uniform game theorem.

## `ej` + `tt` closeout

The `ej` upgrade separates the exact mathematical gain from the failed
strategy. The tangent-plus-triple formula is not merely another feature: it
is exactly the residual legal height. The failure is specifically the
greedy order placed on that exact datum.

The Tao-style correction is to keep the uncovered locus as an obligation
object. Cardinality forgets whether its remaining moves form a P-preserving
reply shell, which is precisely what the `21 P + 43 N` and `21 P + 55 N`
splits expose. A future rule must rewrite that locus directly and prove
soundness before any abundance count.

No incidental discovery-track item arose.

## Mystery ledger

- **[PROVED] What does tangent-plus-triple coverage measure?** Exactly
  `|Legal(T+x+y)|`.
- **[PROVED] When is a legal pair terminal?** Exactly when `kappa=0`.
- **[SETTLED negative] Is minimum `kappa` a sound q17 repair rule?** No. Only
  `4/22` terminal-graph isolates have a P-valued minimizer.
- **[SETTLED negative] Does the q17 deficiency bound `kappa<=3` persist to
  q19?** No; the q19 minima range from three through eight.
- **[SETTLED] Can tie-breaking or coordinates repair the census?** No. All
  minimizers are retained and the fibres commute with projective transport.
- **[OPEN — C80] What intrinsic structure distinguishes the four q17
  P-carrying isolate obligations from the 18 N-only obligations?**
- **[OPEN — C80] Is there a direct rewrite on the uncovered locus that
  preserves a positive boundary resource while lowering `Omega`?**
- **[OPEN — C80/C82 gate] Can such sound fibres be proved
  opponent-complete uniformly in odd `q`?**

## Vibe

The continuation-complex transfer worked exactly at the structural level and
failed exactly at the greedy-value level. That is a clean reduction: the
remaining object is the uncovered locus, not another matching or scalar.

go C80 cap classify the q17 kappa-one/two uncovered-locus obligations and test a direct rewrite
