# C80 — q23 iterable obligation-deletion rewrite

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-26.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

The first q23 `F_d \ R0` edge admits a strictly stronger ranked proof than
cardinality descent: its defect obligations can be required only to
disappear, never to be replaced.

For a state `S`, let `Def(S)` be the already fixed incidence-defined locus
of moves with no immediate response into `B_small`. Define the marked
deletion rewrite

```text
S --x/y--> S+x+y

iff

x in Def(S),
y is a legal reply after x, and
Def(S+x+y) is a strict subset of Def(S).
```

Let `F_del` be the hereditary survivor obtained by requiring such a rewrite
for every current defect obligation, with `Def=empty` as the boundary.
Finite-set induction proves `F_del` P: nondefect moves already reply into
`B_small`, while every defect move rewrites to a strict subset and therefore
terminates.

This is an iterable growing-rank rule. Its local formula is independent of
the current rank and of q; the number of rewrites may grow with
`|Def(S)|`. It is stronger than `F_d`, which permits a cardinality drop that
creates replacement defects.

On the first exact q23 `F_d \ R0` target:

```text
initial defect rank:        30
initial Omega:              72
states in one proof DAG:    29
witness edges:              32
maximum rewrite depth:       2
rank histogram:       30^1 1^2 0^26
```

More strongly, on the complete marked response graph at this target,
`F_del` and `F_d` agree edge-for-edge:

```text
defect/reply candidates:   525
F_d edges:                 118
F_del edges:               118
disagreements:               0
```

This is a finite q23 compression, not a uniform odd-q coverage theorem.
C82 remains gated.

## The first rewrite

The target is

```text
S = {
  (0,0), (1,1), (2,12), (3,8),
  (4,6), (6,5), (12,20), (16,15)
}.
```

Its sole `R0`-failing obligation is answered by

```text
x = (14,3)
y = (18,21)

Def(S+x+y) = {(5,13)}.
```

Thus this exchange does not merely lower the rank `30 -> 1`; it deletes
twenty-nine of the old obligations and creates none. The remaining
obligation has two discharges:

```text
(5,13) -> (17,22)
(5,13) -> (22,9)
```

and both send the defect locus to the empty set.

There is a normalized pencil diagnostic. The old selected secant
`(12,20)(16,15)`, the marked rewrite chord
`(14,3)(18,21)`, and the second discharge chord
`(5,13)(22,9)` all have affine direction `16`. Intrinsically, the three
lines meet at the same point of the deleted line at infinity.

This is useful shape evidence, not the rewrite theorem: the alternative
discharge `(17,22)` is also sound and does not use that direction. No
canonical pencil selector is claimed.

## Why this is the right strengthening

The rank `d=|Def|` forgets the identity of obligations. A reply may reduce
the number of defects while replacing old obligations by unrelated new
ones. That is enough for well-foundedness but gives no object that can be
transported through repeated exchanges.

The inclusion rewrite retains exactly the missing datum:

```text
old obligation locus
    |
    | delete the played obligation and possibly others
    v
strict subset of the same locus
```

The datum is projectively natural because `Def`, legality, and set inclusion
are projectively natural. It is also fixed-format: membership in the next
obligation locus is checked by the same incidence formula as membership in
the old one. No minimax value, `F_d` query, matching list, scalar fit, or
bounded-depth shell appears in the local rule.

The limitation is equally exact. Membership in the hereditary survivor
`F_del` still requires an opponent-complete choice of deletion rewrites.
The present certificate proves that choice only on this finite target.
Uniform C80 needs a direct projective relation supplying a deletion reply
for every obligation and preserving the same condition at successors.

## Soundness

Suppose `S` lies in `F_del`.

- If an opponent move `x` is not in `Def(S)`, the definition of `Def`
  supplies a reply into the proved P-boundary `B_small`.
- If `x` is in `Def(S)`, the `F_del` datum supplies a legal reply `y` with
  `Def(S+x+y) ⊊ Def(S)` and successor again in `F_del`.
- Strict inclusion of finite sets strictly lowers cardinality.

Induction on `|Def(S)|` therefore proves that every opponent move has a
reply to a P-position, hence `S` is P. The proof does not use the C54 value
label.

The finite checker additionally reconstructs every stored state, verifies
that the witnesses cover its exact defect locus, replays both moves, and
checks strict set inclusion and closure of the proof DAG.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_q23_obligation_deletion_rewrite.py
python3 rust/scripts/c80_q23_obligation_deletion_rewrite.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_obligation_deletion_rewrite.py` | 13,445 | `9d3542a47d998b65d01f3599c259b8175b144b95ccad1bc1fb2c0ea9adcbbb01` |
| `notes/2026-07-26-c80-q23-obligation-deletion-rewrite.json` | 19,836 | `627cace51be519a7050123f08dd5c727a0e1dc8f861419ba0b418d95c72b2af4` |

The JSON is canonical sorted data. `--check` regenerates it in a temporary
directory and requires byte equality. The stored proof DAG is then replayed
from masks rather than trusted as a Boolean result.

The generator and replay share the normalized q23 prime-grid incidence
implementation used by the preceding C80 certificates. There is no
independent second geometry engine for these 525 candidates; that is the
remaining computational trust limitation. Mathematical soundness of the
rewrite induction is independent of the finite census.

## `ej` + `tt` closeout

The `ej` pass strengthened the requested one-edge rewrite to the full marked
response graph: every one of the 118 `F_d` edges is an obligation-deletion
edge, and there are no extra `F_del` edges among 525 candidates. It also
extracted the shared-pencil diagnostic without promoting it to a selector.

The Tao-style correction is to rank by a partially ordered object before
searching for another number. Strict inclusion retains obligation identity
and exposes the precise next falsifier: a sound `F_d` edge whose lower-rank
successor necessarily creates a new defect. Such an edge would separate
cardinality descent from the iterable deletion mechanism immediately.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] Can the first `F_d \ R0` edge be written as an iterable rank
  update rather than a new fixed shell?** Yes: require strict deletion of
  the incidence-defined defect locus.
- **[SETTLED] Does the rewrite cover only the displayed witness?** No. On
  the complete root response graph, `F_del=F_d` on all 525 candidates,
  with 118 accepted edges.
- **[SETTLED] Does the marked exchange create replacement obligations?**
  No. It sends the 30-element locus to the old singleton `{(5,13)}`.
- **[OPEN — C80] Does obligation deletion continue to equal defect-rank
  descent on the remaining q23 controls?** No domain beyond the first
  mismatch target was tested here.
- **[OPEN — C80] Can a bounded projective reply correspondence prove
  opponent completeness for the deletion rewrite uniformly in q?**
- **[OPEN — C80/C82 gate] Are projected deletion fibres abundant enough
  for a field-uniform count once soundness is proved?**

## Vibe

This is genuine forward motion: the recursive rank now carries an intrinsic
object that can be rewritten without creating debt. The risk has also become
crisp—one replacement-defect edge would kill the mechanism—so the next
q23 sweep is highly decision-informative.

go C80 cap sweep q23 F_d edges for the first obligation-deletion failure
