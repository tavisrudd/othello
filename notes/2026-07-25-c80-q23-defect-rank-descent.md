# C80 — q23 defect-rank descent census

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

Defect rank survives the complete q23 control census, but greedy minimum-rank
choice does not.

Let

```text
Def(S) = {
  x in Legal(S) :
  no legal reply y makes S+x+y satisfy B_small
}

d(S) = |Def(S)|.
```

Define the well-founded ranked survivor `F_d` directly:

```text
d(S)=0,

or

for every x in Def(S), there is a legal y such that
  d(S+x+y) < d(S)
  and S+x+y lies in F_d.
```

Moves outside `Def(S)` already have a reply into the proved P-boundary
`B_small`. Induction on `d` therefore proves every `F_d` state P.

For the normalized q23 control

```text
T = S4(1,2,3,4) + (0,0) + (5,2),
```

all 118 outer opponent fibres have a reply into `F_d`. Consequently `T` has
a direct defect-rank P-certificate independent of the C54 P label.

The requested nondecreasing obstruction exists only for the greedy rule
"choose an outer reply of minimum defect rank." Only 27 of the 118 fibres
have a recursively certified minimum-rank reply; 91 require accepting a
higher initial rank. The first greedy failure occurs at outer opponent
`(6,3)`.

This is a finite q23 theorem, not a uniform odd-q descent theorem. C82 remains
gated.

## Complete q23 census

The local one-step test is unexpectedly strong:

```text
outer opponent fibres:                         118/118 pass
legal outer replies tested:                    7,986
outer replies passing local defect descent:    7,986/7,986
fibres with a passing minimum-rank reply:       118/118
```

Thus no follower at this layer contains a defect opponent whose every reply
is nondecreasing.

The recursive ranked-survivor test then checks:

```text
ranked states visited:             24,568
defect obligations checked:        25,479
legal replies examined:            87,111
defect ranks visited:               0 through 28
outer fibres entering F_d:          118/118
```

The chosen initial witness ranks range from 3 through 28. Search orders outer
replies by `(defect rank, canonical cell index)`, so a minimum-rank recursive
witness is used whenever one exists.

## First nondecreasing obstruction

The first obstruction to recursive greedy minimum-rank choice is:

```text
outer opponent:       (6,3)
greedy outer reply:   (12,22)
initial defect rank:  16
```

Following the canonical lower-rank witnesses reaches

```text
S = {
  (0,0), (1,1), (2,12), (3,8), (4,6),
  (5,2), (6,3), (7,16), (12,22), (19,5)
}

d(S) = 1
Omega(S) = 0
Legal(S) = 9.
```

Its unique defect opponent is `(20,13)`. After that move there are three
legal replies, but the minimum successor rank is still one. The two
minimizers are

```text
(17,15), (22,15),
```

and both give `1 -> 1`, so strict descent is impossible.

This is not an obstruction to the existential survivor. In the same outer
fibre, reply `(17,22)` begins at defect rank 22 and recursively reaches rank
zero. The finite strategy must sometimes retain more obligations now to
preserve future rank descent.

## Soundness

The proof uses no minimax or archived value query.

- If `d(S)=0`, every legal opponent has a reply into `B_small`, so `S` is P.
- At positive rank, nondefect opponents have the defining direct
  `B_small` reply.
- Defect opponents use the certified reply into a strictly lower `F_d`
  state.
- Natural-number induction on `d` proves P.

The generator reconstructs every legal locus and `B_small` test from the
normalized prime-grid incidence engine. It checks all local followers before
building the recursive witness. It also reconstructs the displayed greedy
obstruction from its selected cells and rechecks that none of the three
replies lowers rank.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_q23_defect_rank_descent.py
python3 rust/scripts/c80_q23_defect_rank_descent.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_defect_rank_descent.py` | 23,088 | `c64a5b9fe05a49525cebe97bc92d89b2629066f0d46d2e05441e21764da34295` |
| `notes/2026-07-25-c80-q23-defect-rank-descent.json` | 545,964 | `1f5040597cb8e3a78186a368a6049d4c916ce1e5aa5ffcbb61a03d7120cb82cf` |

The JSON is canonical sorted data. `--check` regenerates it in a temporary
directory and requires byte equality.

The trusted computational boundary is the normalized q23 prime-grid
incidence implementation inherited from the prior small-shell and
defect-three certificates. No C54 archive, P/N label, or game solver is
consulted. The exhaustive recurrence and its replay use the same incidence
implementation; there is no second independent q23 geometry engine for this
pass. Mathematical soundness of the recorded response map follows from the
displayed induction.

## `ej` + `tt` closeout

The `ej` pass strengthened the requested minimum-defect-fibre test in two
directions for free: it tested all 7,986 legal outer replies, then recursively
closed the rank condition rather than stopping after one rank drop. This
turned an expected falsifier into a finite structural P-certificate for `T`.

The Tao-style correction is the quantifier order. The greedy rule fails, but
the existential rank survivor passes:

```text
not  choose a smallest d immediately,

but

for every opponent, choose some reply whose entire lower-rank obligation
tree closes.
```

The 91/118 nonminimal choices are the load-bearing signal. Any uniform
incidence theorem must explain why temporarily retaining extra defects
creates a descending continuation; minimizing `d` is provably the wrong
exchange principle.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] Is there a local nondecreasing obstruction among the 7,986
  q23 outer followers?** No; every follower passes one-step descent.
- **[SETTLED] Does the full recursive defect-rank survivor cover the q23
  control?** Yes, all 118 outer fibres.
- **[SETTLED negative] Does recursive minimum-rank choice suffice?** No.
  Only 27/118 fibres have a minimum-rank recursive witness.
- **[EXTRACTED] What is the first nondecreasing obstruction?** The
  rank-one, overload-zero state above after greedy reply `(12,22)`; opponent
  `(20,13)` has three replies and minimum successor rank one.
- **[OPEN — C80] Why does accepting a larger current defect rank restore
  future strict descent in all 91 exceptional fibres?**
- **[OPEN — C80] Is there a projective, bounded-formula exchange rule that
  selects an `F_d` reply without recursively evaluating `F_d`?**
- **[OPEN — C80/C82 gate] Does the same ranked survivor cover other q23
  controls and all odd q?**

## Vibe

This is a strong finite win and a useful correction: defect rank is viable,
but only with farsighted reply selection. The remaining gap is exactly the
nonrecursive geometric selector, not rank soundness.

go C80 cap extract a nonrecursive incidence rule for the 91 q23 fibres that require nonminimum defect rank
