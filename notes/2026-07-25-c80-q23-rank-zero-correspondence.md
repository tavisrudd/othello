# C80 — q23 rank-zero defect correspondence

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

The 91 q23 fibres that reject recursive minimum-rank choice admit one exact
nonrecursive incidence rule. In fact the rule covers all 118 fibres and
exactly recovers every recursive-survivor reply on the tested control.

For

```text
T = S4(1,2,3,4) + (0,0) + (5,2),
```

define

```text
R0(T;o,p) iff, for U=T+o+p,
  every x in Def(U) has a legal reply y
  with Def(U+x+y)=empty.
```

This is a fixed-depth, projectively natural incidence sentence. It does not
query minimax, a P/N label, or recursive survivor membership.

The complete q23 census gives:

```text
outer opponent fibres:                    118
legal outer replies:                    7,986
R0 replies:                             1,240
fibres containing an R0 reply:        118/118
R0 replies proved sound:            1,240/1,240
recursive F_d replies:                  1,240
recursive F_d replies outside R0:           0
```

Thus `R0` is not merely a sound subpacket on this finite domain:

```text
R0 = F_d
```

on all 7,986 q23 outer candidates.

This compresses the finite recursive certificate completely. It does not
prove uniform odd-q coverage: `R0` is one additional fixed shell, and C80's
existing square-root depth obstruction rules out treating fixed-depth
absorption as the general mechanism. C82 remains gated.

## Direct soundness

Let `U=T+o+p` satisfy `R0`.

- If the next opponent `x` is not in `Def(U)`, the definition of `Def`
  supplies a legal reply into `B_small`.
- If `x` lies in `Def(U)`, `R0` supplies a reply `y` with
  `Def(U+x+y)=empty`.
- Defect rank zero means every following opponent has a reply into
  `B_small`, so `U+x+y` lies in `Shell_small` and is P.

Therefore every opponent from `U` has a P reply and `U` is P. The argument is
finite-depth and uses only the already proved `B_small` terminal/two-move
boundary.

Every ingredient—legality, `B_small`, `Def`, and the two alternating
quantifiers in `R0`—is defined by projective incidence. Hence the relation
commutes with projective transport without choosing coordinates, a matching,
or a canonical reply.

## What selects the farsighted replies

At the first greedy obstruction, outer opponent `(6,3)` has 66 legal replies.
Exactly 13 satisfy `R0`. Their defect ranks are

```text
22^1 23^1 25^1 27^2 28^2 30^1 32^3 37^2.
```

The greedy reply `(12,22)` has rank 16 and is rejected: its canonical descent
eventually stalls at `1 -> 1`. The previously extracted witness `(17,22)` has
rank 22 and lies in `R0`.

The reason to retain more defects is now direct. For an `R0` target, every
current defect obligation can be annihilated in one exchange. The selector is
not maximizing or minimizing the number of defects; it preserves a complete
rank-zero response fibre.

## Extremal rules remain false

Six natural scalar or extremal proxies were checked against all 118 fibres:

| direct rule | fibres with a sound selected reply | fibres whose entire selected relation is sound |
| --- | ---: | ---: |
| maximum defect rank | 40 | 24 |
| maximum minimum descent degree | 62 | 24 |
| maximum total descent edges | 31 | 30 |
| maximum minimum degree, then edges | 41 | 41 |
| maximum minimum rank drop, then degree | 45 | 45 |
| maximum defect-deletion updates | 37 | 37 |

The first five fail already at opponent `(6,3)`; the deletion-update rule
first fails at `(6,4)`. No scalar extremum explains `R0`.

The intrinsic projected `R0` fibre degree ranges from 1 through 22. One outer
fibre has a unique reply, so the finite relation contains a genuine
knife-edge even though its total density is substantial.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_q23_rank_zero_correspondence.py
python3 rust/scripts/c80_q23_rank_zero_correspondence.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_rank_zero_correspondence.py` | 13,285 | `e2a6add73471702695cd39683fd0b55c35af2e70bb1979f85a6bda1aa6f2bee0` |
| `notes/2026-07-25-c80-q23-rank-zero-correspondence.json` | 153,831 | `3f5243751407b27c9d9900adef4cd0a8b55d46dfbdea9059cca34f8a7eaed49e` |

The JSON is canonical sorted data. `--check` regenerates it in a temporary
directory and requires byte equality.

The generator reconstructs the normalized q23 incidence geometry and tests
all 7,986 replies. Direct soundness of `R0` is mathematical. The comparison
with `F_d` replays the recursive defect-rank checker from the preceding C80
certificate and finds exact edge equality. Both computations share the same
prime-grid incidence implementation; no independent second geometry engine
was used. No C54 archive, minimax result, or P/N label is consulted.

## `ej` + `tt` closeout

The `ej` pass upgraded a selector scout into an exact finite compression:
after `R0` passed 118/118, all 7,986 candidates were recursively labelled.
The direct relation captured all 1,240 survivor edges with no extras and no
misses. It also retained the complete projected fibre-degree distribution
rather than choosing coordinate-dependent representatives.

The Tao-style correction is that this success is simultaneously stronger
and narrower than the previous recursive result. It is stronger because the
q23 response map no longer needs recursion at all. It is narrower because
the formula is visibly another fixed shell. The known growing-depth barrier
means the next informative test is not to fit a finer statistic on this
control, but to find the first q23 or larger-order P control where `F_d`
strictly exceeds `R0`.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] What distinguishes the 91 nonminimum fibres?** A reply must
  preserve a complete one-exchange path from every defect to defect rank
  zero; minimizing current rank is irrelevant.
- **[SETTLED] Is the rule merely sufficient?** On this finite domain it is
  exact: `R0=F_d` on all 7,986 candidates.
- **[SETTLED negative] Can a simple extremal statistic replace `R0`?** No;
  all six proof-shaped extrema fail opponent completeness.
- **[OPEN — C80] Why does the normalized q23 control collapse to one
  rank-zero layer despite the general growing-depth obstruction?**
- **[OPEN — C80] Which next canonical q23 P control first has an `F_d`
  reply outside `R0`, or first lacks `R0` coverage?**
- **[OPEN — C80/C82 gate] What growing-rank algebraic update replaces the
  fixed-depth `R0` relation uniformly in odd q?**

## Vibe

The finite recursion has disappeared completely, which is an excellent
compression. The remaining risk is clear: this may be a q23 shallow-endgame
coincidence, and only an out-of-sample control can tell.

go C80 cap test R0 on the next canonical q23 P control and extract the first depth-two failure
