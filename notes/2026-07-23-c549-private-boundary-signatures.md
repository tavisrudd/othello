# C549 — private-boundary truncation and residual signature quotient

**Lane:** `cap`. **Status:** complete. **Predecessors:** C528/C547.

## Verdict

The corrected local law is true and Lean-checked:

> A complete rank-three gadget attached to an arbitrary ambient game through
> a labelled boundary depends on its private vertex set only through
> `min(2, |U|)`, together with the selected ambient state and selected private
> occupancy.

The formal proof is a two-sided move bisimulation, not an option-count
heuristic. It preserves the complete rooted normal-play game and hence its
Grundy value.

The frozen projective residual cores give the sharp negative consumer verdict:

> The theorem has **no private vertex to remove** in any q17 or q19 core.

Every one of the 1,256 q17 and 924,985 q19 gadget incidences has private
multiplicity class zero: each gadget vertex participates in a load-one pair
constraint or another active load-zero gadget. Consequently the raw and
private-truncated residuals are identical in all 48,433 states.

After exact label-free rooted-game quotienting, the number of distinct follower
signatures at one core grows:

```text
q17: maximum 10; 21 distinct child signatures globally
q19: maximum 21; 654 distinct child signatures globally
```

The number of root game signatures grows from 8 to 2,881. Thus growth is
game-visible, not merely redundant cell labelling. This is a bounded finite
census verdict only: two orders do not prove asymptotic unboundedness.

The local theorem therefore does not explain the observed frozen-corpus
`SG <= 5`. The defect skeleton must retain external link/coupling data; strict
private multiplicity is absent.

## Lean theorem

Module:

```text
CapGame.PrivateBoundary
```

Main declarations:

- `FiniteBuildGame.grundy_eq_of_move_bisimulation`;
- `FiniteBuildGame.PrivateBoundary.Valid`;
- `FiniteBuildGame.PrivateBoundary.SameSignature`;
- `FiniteBuildGame.PrivateBoundary.grundy_eq_of_truncated_private_card`.

For board types `γ ⊕ U` and `γ ⊕ V`, validity consists of:

```text
ambientValid(selected ambient vertices)
and
|selected boundary vertices| + |selected private vertices| <= 2.
```

`SameSignature` requires equality of the complete selected ambient set and
equality of selected private cardinality. Under

```text
min 2 (Fintype.card U) = min 2 (Fintype.card V),
```

every ambient move matches itself. A legal private move can be matched because
its source occupancy is below two and equality of the truncated total
cardinalities guarantees an unselected private vertex on the other side. The
same argument in reverse supplies a two-sided move bisimulation. Recursive
option-set equality then gives equality of Grundy values.

This formalizes arbitrary ambient constraints on the boundary, not merely the
five-/six-vertex example from C547. It also covers already occupied gadgets:
the private occupancy may be zero, one, or two.

Scoped elaboration:

```text
cd /home/tavis/src/othello
lean/scripts/guarded-lean CapGame/PrivateBoundary.lean
```

Result: PASS. The terminal axiom audit is exactly:

```text
[propext, Classical.choice, Quot.sound]
```

There are no project-specific axioms, `sorry`, native decisions, or finite
tables in the theorem. The module is imported by `ProjectiveCap.lean`.

## Exact quotient definition

For a frozen residual core:

- vertices are the currently legal affine cells;
- load-one lines give forbidden pairs;
- load-zero lines containing at least three legal cells give complete
  rank-three gadgets;
- a vertex is private to a gadget exactly when it lies in no forbidden pair
  and in no other active gadget.

The reduction retains at most two private vertices per gadget. Private sets of
distinct gadgets are disjoint under this definition, so the Lean theorem can
be applied successively.

The game-visible signature is defined recursively:

```text
signature(position)
  = the set of distinct signatures of its legal children.
```

The empty option set is the terminal signature. Exact tuple interning gives
canonical integer identifiers with no probabilistic hashing. This is the
coarsest extensional signature of the finite rooted game tree: it discards
labels and duplicate options but retains all normal-play behavior. Its child
set is therefore the exact follower quotient relevant to mex.

## Census

| quantity | q17 | q19 |
|---|---:|---:|
| frozen residual cores | 349 | 48,084 |
| legal vertices | 8–17 | 14–37 |
| private vertices removed | 0 | 0 |
| private multiplicity classes | `0^1256` | `0^924985` |
| distinct root game signatures | 8 | 2,881 |
| distinct child game signatures | 21 | 654 |
| maximum follower signatures at one root | 10 | 21 |
| interned game signatures over the census | 30 | 3,468 |
| chosen sets visited | 22,607 | 14,825,484 |

The q17 per-root follower counts are

```text
2^5 3^200 4^30 5^48 8^3 10^63.
```

The q19 counts occupy every value from 2 through 21. In particular, 82 roots
have 21 distinct follower signatures. This rules out both candidate readings:

- **not redundant-label growth:** the exact label-free rooted quotient grows;
- **not a bounded strict-private family on this corpus:** no strict-private
  reduction fires, while root and follower types grow sharply.

It does not rule out a broader compression by externally attached twin classes,
incidence modules, or a Dawson/path-cycle defect skeleton. Those retain more
coupling data than the theorem's private set and remain the live C528 target.

## Dependency and consumer map

```text
FiniteBuildGame.grundy_eq_of_move_bisimulation
  └─ PrivateBoundary.grundy_eq_of_truncated_private_card
       └─ normalize each genuinely private gadget set to size 0/1/2
            └─ factor child SG through normalized boundary signatures
                 └─ FiniteBuildGame.grundy_le_card_of_follower_signature
```

The combination is mathematically valid but conditional: geometry must bound
the normalized child-signature type. On the frozen cores the exact type count
needed at a root is at most 10 for q17 and 21 for q19. Hence the theorem gives
fixed-order mex bounds, but no q-independent bound and nothing competitive
with the separately computed `SG <= 5`.

The contrast is itself informative. At q19, 2,881 exact root games collapse to
only the previously certified nimbers `1,2,4,5`. The small nimbers therefore
come from systematic mex omissions or value collisions among many
game-inequivalent followers, not from having at most five follower games.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Generate and replay:

```text
python3 rust/scripts/c549_private_boundary_signatures.py
python3 rust/scripts/c549_private_boundary_signatures.py --check
```

Both commands exhaust exactly the q17/q19 `capOVER` residual children
reconstructed from the committed frozen three-intruder inputs. The replay
regenerates the canonical JSON and checks it byte-for-byte. No q23 state is
generated or tested. There is no randomness.

Artifacts:

```text
rust/scripts/c549_private_boundary_signatures.py
  14,297 bytes
  sha256 df70584d113545ba2369319cf57448de2c8bdefccf7e10d7d9563e8a0adb306b

notes/2026-07-23-c549-private-boundary-signatures.json
  7,617 bytes
  sha256 5d95099852542ec47447d27590c810928b25c2615d64935175774766d33ac4d2
```

The JSON embeds SHA-256 hashes and byte counts for every frozen input and
helper source. It also stores SHA-256 digests of the sorted per-state result
rows.

Independent check:

- all 349 q17 roots are recomputed by a separate nested-`frozenset` signature
  implementation; zero disagreements;
- the q19 quotient is checked by deterministic byte-for-byte replay, but the
  independent nested representation is not materialized at q19 because it
  would duplicate deeply nested objects over 14.8 million visited chosen sets;
- transition semantics and exact untruncated SG at q19 are independently
  guarded by C528's direct projective-geometry recursion on a deterministic
  100-state slice, zero disagreements:
  `notes/2026-07-23-c528-grundy-conic-census.json`, 54,467 bytes,
  SHA-256
  `17dd3f416f8e4a4c358f5b7c6ea0116e4ef0a0b0a09d736af2f1f21845ae6138`.

Thus there is no independent full q19 implementation of the recursively
interned identifiers; the exact finite claim rests on the tracked generator,
its canonical replay, the Lean local theorem, and the stated predecessor
cross-check boundary.

## Mystery ledger — ej + tt closeout

- **[SETTLED] Is `min(2,|U|)` plus occupancy the correct local datum?**
  Yes. The Lean theorem proves full rooted-game/Grundy equivalence under
  arbitrary ambient boundary constraints.
- **[SETTLED negative] Does strict private-boundary truncation compress the
  frozen q17/q19 coupled cores?** No. Every gadget-private multiplicity is
  zero; no vertex is removed in 48,433 states.
- **[SETTLED negative] Is observed signature growth only redundant labels?**
  No. Exact label-free root types grow `8 -> 2,881`, child types
  `21 -> 654`, and the maximum per-root follower quotient `10 -> 21`.
- **[OPEN — load-bearing] Why is SG at most 5 while exact follower-game count
  reaches 21?** The evidence now excludes raw gadget size, isolated bulk,
  duplicate options, strict private leaves, and conic type. The missing law
  must constrain mex values across externally coupled defect signatures.
  Owner: C528's whole-residual defect-skeleton/Dawson component law.
- **[OPEN] What is the minimal broader boundary object?** The finite evidence
  requires external link data. The next discriminator is whether vertices with
  identical external pair/triple links can be quotiented as modules, or
  whether path/cycle placement must be retained. This is part of C528, not a
  claim of the present theorem.
- **[OPEN, inherited] Why does SG 3 dominate q17 and disappear at q19?** The
  rapidly growing rooted-game quotient makes a small static class explanation
  less plausible; exact mex/component structure remains the evidence gap.

The `ej` pass harvested the reusable two-sided Grundy-bisimulation theorem and
made the consumer implication explicit. The `tt` pass insisted on measuring
the strict hypothesis before interpreting the quotient; that exposed the
strongest possible failure—there are no private vertices—and separated
game-visible growth from label multiplicity. No genuine mystery beyond the
three open coupling/mex questions above remains.

## Vibe

Excellent local theorem, decisive negative global consumer. The result removes
an attractive but false explanation of `SG <= 5` and tells C528 exactly what
must be richer: external incidence modules or the full defect skeleton, not
private gadget tails.
