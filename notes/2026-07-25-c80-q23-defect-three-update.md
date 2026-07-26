# C80 — q23 defect-three rank update

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

The unique minimum-defect q23 follower has a direct, projectively natural
rank-carrying repair.

For any state `S`, define

```text
Def(S) = {
  x in Legal(S) :
  no legal reply y makes S+x+y satisfy B_small
}

d(S) = |Def(S)|.
```

For the closest failed follower from the q23 small-shell census,

```text
U = S4(1,2,3,4)
    + (0,0) + (5,2)
    + (9,16) + (17,18),
```

the exact defect locus is

```text
Def(U) = {(7,13), (15,22), (19,4)}.
```

These three points are noncollinear and pairwise mutually legal. If the
opponent plays any one defect point, reply with either of the other two.
Every one of the six oriented defect exchanges sends

```text
d=3 -> d=0.
```

The 21 nondefect opponents already have direct replies into `B_small`.
Consequently all 24 opponents are covered by a 50-edge sound
correspondence:

```text
 8 terminal
36 two-mutually-legal-move
 6 defect exchange.
```

Every selected edge lowers `Omega` from 18 to zero or two. Thus `U` is P by
a direct rank argument, without a minimax query, explicit matching, or
anonymous extra shell.

This is a positive local growing-rank model, not yet a uniform C80 theorem.
The same defect-descent condition has not been tested across the other 116
q23 outer fibres, whose minimum defects range through 22.

## Intrinsic defect geometry

The three defect points have homogeneous representatives

```text
(1,15,10), (1,3,20), (1,22,17)
```

and determinant seven in `GF(23)`, hence they are noncollinear. Each pair is
a legal continuation pair at `U`; equivalently, the induced conflict graph
on `Def(U)` is `3K1`.

The selected target stabilizer has order two. Its nonidentity element swaps

```text
(7,13) <-> (15,22)
```

and fixes `(19,4)`, so the defect orbits have sizes `2+1`. The reply rule
“choose either other defect point” retains all six oriented edges and is
equivariant despite the nontransitive action.

The active zero-load blocks at `U` have sizes

```text
3^10 4^2 6^1,
```

whose excess sums to `Omega(U)=18`. The two-point stabilizer orbit meets one
four-point block at each endpoint. The fixed defect point meets the
six-point block and one three-point block. Thus the defect set is not one
active-line orbit or a single overload block; its clean invariant is
mutual legality plus the rank-zero exchange update.

## Complete response rule

### Nondefect opponents

For `x not in Def(U)`, the definition of `Def` supplies a legal reply into
`B_small`. Retaining all such replies gives:

```text
8 terminal edges
36 edges leaving exactly two mutually legal moves.
```

Those 44 followers are P by the previously proved small-boundary argument.

### Defect opponents

For `x in Def(U)`, neither terminal nor two-move boundary is reachable
immediately. But both other points of `Def(U)` remain legal replies.
Selecting either `y` gives

```text
Def(U+x+y) = empty.
```

Rank zero means that every next opponent has a direct reply into `B_small`;
therefore `U+x+y` lies in `Shell_small` and is P. This proves all six defect
edges sound.

The combined fibre-degree histogram is:

```text
degree 1:  3 opponents
degree 2: 17 opponents
degree 3:  3 opponents
degree 4:  1 opponent.
```

All 50 edges land at defect rank zero. Forty-eight land at `Omega=0`; the
two exchanged edges between `(7,13)` and `(15,22)` land at `Omega=2`.

## Rank lemma suggested by the example

The finite proof instantiates the following field-uniform induction pattern.
Let `B_small` be any proved P boundary and define `Def` as above. A class of
states is P if:

1. every nondefect opponent has its defining reply into `B_small`; and
2. every defect opponent has a reply to a state of strictly smaller defect
   rank satisfying the same update condition.

Soundness follows by induction on the natural number `d(S)`. Unlike a fixed
shell depth, `d` may grow with q. Its update is computed directly from
incidence rather than by querying the cap-game value.

The q23 state proves only the rank-three instance, with every exceptional
edge jumping directly to zero. A usable C80 theorem still needs a
field-uniform reason that suitable defect replies exist and keep satisfying
the update condition at all lower ranks. Defining the recursive closure
without such a reason would merely rename `F_cc`.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_q23_defect_three_update.py
python3 rust/scripts/c80_q23_defect_three_update.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_defect_three_update.py` | 11,845 | `4e4a97d5c76fd7951885cef9ca0f9e7f26a13dbef1209be97616eaa2485a802f` |
| `notes/2026-07-25-c80-q23-defect-three-update.json` | 24,099 | `e25ccbc53938265e2483a56f44f3ffcde9252a3bee07124d66e396580288f865` |

The generator reconstructs `U`, computes `Def` from the fixed incidence
formula, checks all pairwise legality and noncollinearity directly, records
the active blocks, and evaluates every response edge. It recomputes the
order-two target stabilizer and its action on the defect locus.

The JSON is canonical sorted data. `--check` regenerates it in a temporary
directory and requires byte equality.

Soundness of the rank update is mathematical. The target classification and
complete finite fibre census retain the normalized q23 prime-grid
computational trust boundary. No archived P/N value is used: the displayed
response certificate itself proves `U` P.

## `ej` + `tt` closeout

The `ej` pass retained both replies from each defect point rather than
choosing a coordinate-dependent mate. This exposes the intrinsic relation:
the defect locus is a legal three-cap and its complete directed graph is the
rank update.

The Tao-style caution is that one successful `3 -> 0` jump does not prove
defect rank is globally monotone. The next falsifier must apply the same
local update predicate to every q23 outer fibre and stop at the first defect
opponent with no lower-rank reply.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] What is the minimum q23 defect locus?** Three noncollinear,
  pairwise mutually legal points.
- **[SETTLED] Is its asymmetry coordinate-dependent?** No. The target
  stabilizer has orbits `2+1`, and the full six-edge defect relation is
  equivariant.
- **[PROVED for this target] Can every defect move lower the rank?** Yes.
  Either other defect point is legal and sends `d=3` to zero.
- **[PROVED for this target] Is the combined reply rule sound and complete?**
  Yes: `24/24` opponents, 50 sound edges, strict `Omega` decrease.
- **[OPEN — C80] Does every q23 failed outer fibre admit a reply target whose
  defect opponents all have lower-rank replies?**
- **[OPEN — C80] Is there a projective incidence characterization of the
  lower-rank defect reply beyond recomputing `Def`?**
- **[OPEN — C80/C82 gate] Can defect-rank descent be proved and counted
  uniformly in odd q?**

## Vibe

The q23 failure was not a dead end: its smallest obstruction is itself a
clean equivariant reply packet with a genuine well-founded rank drop.

go C80 cap test defect-rank descent on every q23 outer fibre and extract the first nondecreasing obstruction
