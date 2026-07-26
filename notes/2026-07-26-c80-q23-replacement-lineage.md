# C80 — q23 replacement lineage and ancestral charge

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-26.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

The first exact q23 replacement edge has a projectively natural lineage and
a set-valued ancestral charge. It repairs strict obligation deletion on the
entire marked target, not merely on the exceptional fibre.

Let `T` be the rank-27 target from the obligation-deletion sweep. Its unique
nondeletion fibre is

```text
x = (12,15)  ->  y = (22,14).
```

The replacement `z=(21,17)` is created by the opponent half-move `x`, before
the reply `y` is selected. The exact defect ranks are

```text
T             27
T+x            7   (one new defect: z)
T+x+y          2   (no new defect from y)
```

Thus `x` is the causal parent of `z`. Label retained defects by their old
labels and transport the old label `x` to `z`:

```text
current defect       ancestral label
(17,19)              (17,19)
(21,17)              (12,15)
```

The label support drops by strict inclusion from the 27-point old defect
locus to `{(17,19),(12,15)}`. The successor is already in `F_del`, so later
rewrites only delete labels. All other 26 old defect fibres have ordinary
strict-deletion replies into `F_del` (between one and eleven witnesses per
fibre). Consequently the whole marked target has a charged proof:

```text
26 strict-deletion fibres
+ 1 one-to-one lineage-transfer fibre
= 27/27 covered, 0 uncovered.
```

This is a finite q23 proof object, not a uniform odd-q theorem. It identifies
the right strengthening of literal inclusion: order ancestral label support,
not the current locations carrying those labels.

## Projective lineage

The causal label transfer has a bounded incidence certificate.

Before `x` is played, `z` is not a defect. It has exactly one immediate
reply into the small structural boundary:

```text
z=(21,17) -> r=(5,13),
Legal(T+z+r) = {w=(17,19), q=(22,9)}.
```

This is the two-nonconflicting-move `B_small` boundary. The opponent `x`
kills `q` on the newly saturated secant through the old selected point
`a=(4,6)`:

```text
a, x, q are collinear,
line(a,x,q) = [1:17:9].
```

It leaves `w` legal, so the former two-point boundary becomes the one-point
N-position `{w}`. This is exactly when `z` becomes defective. The reply `y`
creates no further defect.

At the successor, both remaining defects `w` and `z` have the same unique
rank-zero reply `p=(10,13)`. Conversely, when the opponent plays `p`, the
reply `h=(11,3)` reaches a new two-point boundary:

```text
Legal(T+x+y+p+h) = {w,z}.
```

The boundary pair therefore undergoes the endpoint transport

```text
{w,q} -> {w,z}.
```

The common endpoint `w` is retained and the killed endpoint `q` is replaced
by `z`. The new endpoint is not a fitted coordinate: it has the intrinsic
projective construction

```text
z = line(q,p) ∩ line(r,h).
```

Indeed `q,z,p` and `r,z,h` are the two certified collinear triples. Together
with the causal secant `a,x,q`, these incidences give a bounded projective
lineage flag. Every object used—legality, `Def`, the `B_small` boundary,
line incidence, and the marked exchange—commutes with projective transport.

## Charged-survivor schema

The local extraction suggests the following proof-object interface.

Carry a finite ancestral label set `L` and a label on each current defect.
Retained defects keep their labels. A newly created defect may inherit a
label from a defect consumed in the marked exchange, provided:

1. the inheritance is supplied by a direct projective incidence relation;
2. distinct current defects receive distinct ancestral labels; and
3. the successor label support is a strict subset of `L`.

Nondefect opponents still reply directly into `B_small`. Defect opponents
reply into another charged state. Induction on the finite label support then
proves P, just as finite-set inclusion proved `F_del`.

At the present edge the update is forced: only `z` is created, it is created
by `x`, and branching is one. The incidence flag above supplies the direct
transport, while the successor's membership in `F_del` closes the subtree.

This schema is stronger than cardinality descent because it preserves
obligation identity through replacement, but it does not yet solve C80.
A uniform theorem must prevent one ancestral label from branching into
several descendants, give a bounded-formula incidence update without
encoding a strategy tree, and cover every defect fibre. An arbitrary
point-to-label table would violate the anti-packing gate; the claim here is
only the bounded one-transfer flag at the first replacement edge.

## Exact domain and trust boundary

The certificate reconstructs the first `F_d \ F_del` target from the
canonical q23 control index 20 and checks:

- the complete defect loci before the exchange, after `x`, and after `y`;
- all 27 root fibres, including the unique nondeletion fibre;
- uniqueness of the old boundary reply, the common rank-zero reply, and the
  causal replacement;
- the killed and transported two-point boundary endpoints;
- the three projective collinearities and normalized killing-secant
  coefficients; and
- closure of the replacement successor in `F_del`.

The primary replay uses the existing normalized q23 bitmask engine. An
independent reference implementation recomputes legality from affine
determinants and independently implements `Omega`, `B_small`, and `Def`; it
agrees on all three complete defect loci and both boundary certificates.
Both implementations use the same mathematical normalized-grid convention,
but no survivor result or cached defect set is shared.

The computation makes no claim about later q23 replacement edges, other
q23 roots, extension fields, or uniform odd q.

## Reproduction

Working directory:

```text
/home/tavis/src/othello/rust
```

Commands:

```text
python3 scripts/c80_q23_replacement_lineage.py
python3 scripts/c80_q23_replacement_lineage.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_replacement_lineage.py` | 19,021 | `dbf2d7aa497cea113f0c02391170fd1832fef371e2f4c87466955acbc1081e60` |
| `notes/2026-07-26-c80-q23-replacement-lineage.json` | 9,322 | `64fbc15786300e1d6e378863a55111134ef2678d30b1bfd261a03e8f22881fce` |

The JSON is canonical sorted data. `--check` regenerates it in a temporary
directory and requires byte equality.

## `ej` + `tt` closeout

The cheap `ej` upgrade promoted the one-edge observation to full root
coverage: the marked target has exactly 26 deletion fibres and one lineage
fibre. It also found the stronger boundary endpoint transport
`{w,q}->{w,z}` and the projective intersection formula for `z`, rather than
recording only a causal timestamp.

The Tao-style correction is that the useful rank is not another scalar.
Literal point identity was too rigid, while bare cardinality forgot too
much. A finite set of ancestral projective labels is the intermediate
object: labels may move through a certified incidence flag, but their
support must strictly shrink. The anti-vacuity condition is essential—the
update may not be an arbitrary relabelling or an encoded response tree.

The next decisive falsifier is the next q23 `F_d` edge with replacement:
test whether every new defect has an injective bounded-incidence ancestry in
consumed old defects. Branching, an ancestry collision, or the absence of a
projective flag would close this charged-survivor route.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] Which half of the exchange creates the replacement?** The
  opponent `x=(12,15)` creates the sole new defect; the reply creates none.
- **[SETTLED] Is there a projective causal certificate?** Yes. The old
  boundary pair loses `q` on the new secant `a-x-q`, and the endpoint
  replacement satisfies `z=line(q,p)∩line(r,h)`.
- **[SETTLED] Can the charge cover the complete marked root?** Yes:
  26 strict-deletion fibres plus the one label-transfer fibre cover all 27.
- **[OPEN — C80] Does injective ancestral transport survive the next
  replacement edge, or does one consumed label branch into several new
  defects?**
- **[OPEN — C80] Can the bounded incidence flag be stated uniformly without
  carrying an explicit growing label table?**
- **[OPEN — C80/C82 gate] Is the resulting charged correspondence
  opponent-complete and countable uniformly in odd q?**

## Vibe

This is the first replacement mechanism that is geometric rather than
merely numerical. It repairs the exact q23 failure cleanly and exposes a
sharp next falsifier, but it remains one finite edge away from any uniform
claim.

go C80 cap test injective ancestral charge on the next q23 replacement edge
