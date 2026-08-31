# C80 — the consumed-label Hall instance, exhaustively at q=11

**Lane:** `cap`. **Task:** C80. **Date:** 2026-08-30.
Canonical status: `2026-07-25-c80-status-ledger.md`.

## 1. What the prior probe actually established, and what it did not

The C80 ancestral-secant Hall probe
(`2026-08-30-c80-ancestral-secant-hall-probe.md`) reported that the
ancestral-secant edge relation is Hall-saturated on the certified-reply domain
while failing on 1,266 raw `q=11` exchanges. Those two statements need to be
separated before anything can be built on them.

**The certified-reply domain restriction.** The C985 scout
(`ergodis-private/scripts/projective_hall_scout.py --p-admission`) counts a
reply only when the *whole* game-semantic admission predicate of the proved
strict-overload survivor holds: the current state `A` lies in `K_Omega`, its
overload satisfies `Omega(A) > 0`, the reply's successor satisfies
`Omega(A+o+h) < Omega(A)`, and the successor itself lies in `K_Omega`.
`K_Omega` is the recursively defined survivor of
`rust/scripts/c80_strict_overload_kernel.py`: at `Omega = 0` membership is
exactly Node--Kayles Grundy zero on the full legal-point conflict graph (the
`Y_NK` boundary law), and at `Omega > 0` it demands, for every legal opponent,
an `Omega`-descending reply back into `K_Omega`.

**The `q=11` certified domain is empty of the phenomenon being tested.** The
committed admission evidence
`ergodis-private/evidence/c80-ancestral-secant-p-admission-q11-1000.json`
records, over 334 sampled `K_Omega` states and 23,000 certified replies,

```text
certified_replies_with_new_defects = 0
ancestral_secant_edges             = 0
minimum_certified_support_surplus  = 0
```

Not one certified `q=11` reply creates a genuinely new defect, and not one
consumes an old defect label either. The `q=11` Hall instance on the certified
domain is therefore empty on both sides. The probe's "saturated on the
certified domain" line is carried entirely by the `q=13` control, whose 596
certified new-defect replies are the only nonvacuous positive evidence in that
table. **The `q=11` row proved nothing, in either direction.**

**The 1,266 raw failures.** They are the ancestral-secant Hall failures of the
*unrestricted* exchange domain: 1,000 deterministic size-four `F_11` states
(xorshift64 seed 98,508,030), all complete opponent/reply exchanges `(o,h)`
with `o, h in Def(A)` and `h` legal in `A+o`, of which 6,652 create at least
one genuinely new defect. On 1,266 of those the ancestral-secant relation has
a Hall-deficient set; 1,524 individual new defects have degree zero.

**Which side of the crown they block.** They refute the ancestral-secant
relation as a *universal per-exchange invariant*. They do not touch the
existential, opponent-complete statement C80 actually needs — that every
opponent has *some* admitted reply whose exchange satisfies Hall and support
descent — because a failing exchange only matters if its successor is a
position the survivor would ever enter. Section 4 settles that question
exhaustively: none of them is.

## 2. The exact Hall instance

Fix an odd prime `q` and a legal size-four residual state `A` in the `q x q`
grid cap game (legality: no two selected points share a row or a column, and
no three are collinear over `F_q`). Write

- `Legal(S)` for the legal points of `S`;
- `Omega(S)` for the total capacity-two overload, summing
  `max(0, |Legal(S) ∩ L| - 2)` over slope lines `L` disjoint from `S`;
- `B_small(S)` for the small boundary: `Omega(S) = 0` and `Legal(S)` is either
  empty or a mutually legal pair;
- `Def(S) = { o in Legal(S) : no r in Legal(S+o) has B_small(S+o+r) }`.

A **complete old-labelled exchange** is a pair `(o,h)` with `o in Def(A)`,
`h in Def(A)`, and `h in Legal(A+o)`. Its two sides are

```text
created  = Def(A+o+h) \ ( Def(A+o) ∪ Def(A) )     genuinely new defects
consumed = Def(A) \ Def(A+o+h)                    consumed ancestral labels
```

The bipartite Hall instance is `created -> consumed` under a structural,
label-defined edge relation. Two relations are solved here; neither is a
growing matching table, and neither refers to game value.

1. **Ancestral-secant relation.** `z -- ell` when the line `z ell` carries a
   point of `A`, that is a point selected *before* the exchange. Bounded
   projective incidence data only.
2. **Complete relation.** Every new defect is adjacent to every consumed
   label. This is projectively natural and needs no incidence data at all; its
   Hall condition collapses to the single count inequality
   `|consumed| >= |created|`.

**Strict support descent as a property of the matching.** Given an injective
`M : created -> consumed`, recharge each new defect `z` with the consumed
label `M(z)`. Injectivity blocks new/new collisions and consumption blocks
new/retained collisions, so the charged support of `A+o+h` is
`|Def(A)| - |consumed| + |created|`. Strict descent is therefore exactly
`|consumed| > |created|`; equality leaves the support flat and forces a
tiebreak. The two lexicographic candidates are `(support, Omega)` and
`(Omega, support)`.

## 3. Exhaustive `q=11` outcome

`ergodis-private/src/bin/c80_hall_rematch.rs` enumerates **every** legal
size-four `F_11` residual state and every complete old-labelled exchange out
of it, compiles both Hall instances, and solves each with the allocation-free
`ergodis_private::hall_core::HallWorkspace`.

| quantity | exhaustive `q=11` |
| --- | ---: |
| legal size-four states | 1,560,900 |
| complete old-labelled exchanges | 10,890,000 |
| exchanges creating a new defect | 10,164,000 |
| genuinely new defects created | 16,698,000 |
| maximum new defects in one exchange | 2 |
| **complete-relation Hall failures (`\|consumed\| < \|created\|`)** | **0** |
| equality exchanges (`\|consumed\| = \|created\|`) | 363,000 |
| **`(support, Omega)` lexicographic failures** | **0** |
| **`(Omega, support)` lexicographic failures** | **0** |
| ancestral-secant edges | 30,492,000 |
| ancestral-secant zero-degree new defects | 2,371,600 |
| ancestral-secant Hall failures | 1,984,400 |

The state count is exactly `121 * 100 * 72 * 43 / 24`, confirming the
enumeration against the known extension counts (`q^2 - 9q + 21 = 43` legal
size-four extensions of a size-three residual).

**The exact global statement proved at `q=11`.** For every legal size-four
residual state over `F_11` and every complete old-labelled exchange out of it:

1. the consumed-label count is at least the new-defect count, so the complete
   relation always admits a saturating injective assignment
   `created -> consumed`;
2. both `(charged support, Omega)` and `(Omega, charged support)` strictly
   decrease across the exchange;
3. strict support-cardinality descent alone is **false**: 363,000 exchanges
   (3.6% of the defect-creating ones) leave the support flat, and in every one
   of those `Omega` drops to zero;
4. the ancestral-secant refinement is **false as a universal invariant**:
   1,984,400 exchanges (19.5%) are Hall-deficient, 1,500,400 with a singleton
   deficient set (a degree-zero new defect) and 484,000 with a deficient set of
   size two.

So there is **no support-deficit set at `q=11`** under the projectively
natural complete relation, and the crown's strict-descent clause is refuted
there. The correct well-founded coordinate at `q=11` is the lexicographic pair,
not the support cardinality alone.

## 4. Triage of the 1,266 (and of all 1,984,400)

Every ancestral-secant Hall failure was classified against the admission
predicate. The classification is uniform and admits no exceptions.

| class | 1,000-state sample | exhaustive `q=11` |
| --- | ---: | ---: |
| Hall failures | 1,266 | 1,984,400 |
| with `Omega(A) = 0` (state outside the survivor's live region) | 0 | 0 |
| without strict `Omega` descent | 0 | 0 |
| passing both cheap admission necessities | 1,266 | 1,984,400 |
| with `Omega(A+o+h) = 0` | 1,266 | 1,984,400 |
| **with `Y_NK` Grundy zero, i.e. successor in `K_Omega`** | **0** | **0** |
| Grundy decision above the vertex cap | 0 | 0 |

**Per-class certificate.** Every failing exchange has `Omega(A+o+h) = 0`, so
by the proved `Y_NK` boundary law the successor's value is decided by the
Node--Kayles Grundy value of its full legal-point conflict graph, and
`K_Omega` membership in the base case is exactly Grundy zero. That Grundy
value is nonzero for every one of the 1,984,400 successors. Each failing
successor is therefore an **N-position**, outside `K_Omega` and outside every
sound survivor. No failure persists as a candidate support-deficit set.

The same holds for the 363,000 equality exchanges: all have `Omega = 0`
successors with nonzero Grundy value. The C985 hostile-scout witness
`A = {(0,0),(1,7),(5,4),(7,6)}, o = (4,9), h = (6,1)` is one member of this
class, and the census shows it is typical, not exceptional.

**The stronger fact behind the triage.** Restricting attention to failures was
unnecessary. Over *all* 10,164,000 defect-creating exchanges at `q=11`:

```text
successors with Omega = 0            10,164,000   (every one)
successors with Omega > 0                     0
successors inside the Y_NK boundary           0   (every one is N)
```

**At `q=11`, no complete old-labelled exchange that creates a genuinely new
defect can be part of any sound survivor strategy.** This upgrades the C985
sampled observation `certified_replies_with_new_defects = 0` to an exhaustive
theorem on this domain, and it explains it: the crown's Hall instance at
`q=11` is empty because the whole defect-creating exchange class is
game-semantically dead there.

**Why `q=11` degenerates.** The residual game entered at size four over `F_11`
is essentially over by size six. Sampled legal-set sizes and overloads:

| field | `\|S\|=4` legal | `Omega>0` | `\|S\|=5` legal | `Omega>0` | `\|S\|=6` legal | `Omega>0` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `q=11` | 19.8 | 98% | 6.3 | 9% | 1.2 | 0% |
| `q=13` | 40.3 | 100% | 17.5 | 99% | 5.4 | 3% |

At `q=11` the successor of a complete exchange has on average about one legal
move left; the absorption clock is already exhausted and the position is a
terminal shell. At `q=13` the same successor still has a live game with
positive overload in a measurable fraction of cases. The `q=11` vacuity is a
legal-density coincidence of the small field, not evidence about the crown.

## 5. Targeted `q=13` replication

The same driver, unchanged, on deterministic `q=13` samples:

| control | exchanges | with new defects | complete-relation failures | equality exchanges | ancestral-secant Hall failures |
| --- | ---: | ---: | ---: | ---: | ---: |
| 300 states | 122,742 | 31,584 | 0 | 0 | 0 |
| 2,000 states | 826,372 | 206,440 | 0 | 0 | 0 |
| 50,000 states | 20,703,372 | 5,129,570 | 0 | 0 | 0 |

At `q=13`, on 5,129,570 defect-creating complete old-labelled exchanges, both
crown clauses hold with **no exceptions and no admission restriction**: the
sparse ancestral-secant relation saturates every instance, and the support
cardinality drops *strictly* every time. The domain is also nonvacuous
game-semantically — in the 50,000-state control, 60,788 successors lie in the
`Y_NK` base boundary of `K_Omega` and 81,044 have `Omega > 0`.

`q=13` is therefore the smallest field where the crown has content, and where
the strict-descent clause the queue asks for is actually true on the evidence.

## 6. Independent verification

`notes/2026-08-30-c80-hall-helper.py` is a from-scratch Python replay sharing
no code path with the Rust driver: collinearity by affine determinant rather
than precomputed slope classes, explicit line sets for `Omega`, Kuhn augmenting
paths plus an alternating-reachability sweep for the Hall deficiency, and an
independent Node--Kayles Grundy solver. It additionally cross-checks against
the authoritative `rust/scripts/c80_strict_overload_kernel.py` kernel.

Results: the exhaustive run's first failure and all eight retained admission
candidates replay exactly — defect loci, `created`/`consumed`, ancestral-secant
neighbourhoods, deficient set and its neighbourhood, `Omega` triple, charged
support, and successor Grundy — and `StrictKernel` agrees on `Omega`, the
boundary Grundy value, and `K_Omega` membership (`False`) for every one.
Independent sampling reproduces the qualitative split: at `q=11`, 48 Hall
failures in 250 exchanges with zero complete-relation failures, zero
`Omega > 0` successors and zero P successors; at `q=13`, zero Hall failures in
540 exchanges with 18 P successors.

The driver also reproduces the two committed Rust scout evidence files bit for
bit on every shared counter:
`c80-ancestral-secant-q11-1000.json` (7,138 / 6,652 / 10,974 / 20,138 / 1,524 /
1,266 / 242 / 0 / 0) and `c80-ancestral-secant-q13-300.json` (122,742 / 31,584 /
38,572 / 411,307 / 0 / 0 / 0 / 0 / 0).

**The exhaustive `q=11` first failure**, first in the word-lexicographic bitset
order over `(A, o, h)`:

```text
A        = {(5,9),(6,4),(7,1),(8,0)}
o        = (0,6)
h        = (2,8)
Def(A)   = {(0,6),(2,8),(3,7),(10,10)}
Def(A+o) = {}
Def(A+o+h) = {(4,7),(9,5)}          both genuinely new
consumed = {(0,6),(2,8),(3,7),(10,10)}
ancestral-secant degrees        = 0, 1
Hall-deficient set  Z = {(4,7)},  N(Z) = {}
Omega    = 8 -> 0 -> 0
charged support = 4 -> 2           (strict surplus 2 under the complete relation)
successor Node-Kayles Grundy = 1   (N-position; not in K_Omega)
```

## 7. `hall_core` interface notes

`HallWorkspace` fits this problem exactly and needed no changes.

- Construction sizes every buffer once; `solve` over caller-owned CSR
  `offsets`/`neighbors` allocates nothing, so a worker reuses one workspace
  across millions of instances. The exhaustive `q=11` census ran 10.16 million
  solves in 39 seconds wall on 16 threads, including the Node--Kayles decision
  for every successor.
- A negative result exposes the alternating-reachable deficient left set and
  its exact neighbourhood, which is precisely the "first support-deficit set"
  artifact the C80 gate asks for. The independent Python reachability sweep
  agreed with it on every extracted record.
- One caveat worth recording: on the complete relation the matcher is a
  verifier, not the hot algorithm — Hall there is the single inequality
  `|consumed| >= |created|`, and calling the engine only confirms it. The
  engine earns its place on the sparse ancestral-secant relation.
- The dense-row-bitmap concern from the C985 note does not bite here: instances
  have at most 4 left vertices and at most about 35 right vertices.

## 8. Replay

From the repository root:

```sh
CARGO_TARGET_DIR=~/.cache/ergodis/target-c1018-c80 \
  cargo build --release --manifest-path ergodis-private/Cargo.toml \
  --bin c80_hall_rematch

B=~/.cache/ergodis/target-c1018-c80/release/c80_hall_rematch
C=~/.cache/ergodis/c1018

E=ergodis-private/evidence

# exhaustive q=11 census with the full Y_NK admission decision (~40 s, 16 threads)
$B --q 11 --exhaustive --full-admission --deterministic --threads 16 \
   --candidate-cap 8 --summary $E/c80-hall-rematch-q11-exhaustive.json

# exact reproduction of the committed q=13 Rust scout evidence file (~1 s)
$B --q 13 --states 300 --seed 98508030 --deterministic --threads 16 \
   --summary $E/c80-hall-rematch-q13-300.json

# targeted q=13 replication (~2 min, 16 threads)
$B --q 13 --states 50000 --seed 98508030 --deterministic --threads 16 \
   --full-admission --grundy-cap 24 --candidate-cap 64 \
   --summary $E/c80-hall-rematch-q13-50000.json

# exact reproduction of the committed q=11 Rust scout evidence file; 763 KB, so
# it stays out of the evidence tree and is regenerated on demand
$B --q 11 --states 1000 --seed 98508030 --deterministic --threads 16 \
   --summary $C/q11-sample-1000.json

# independent replay and cross-check against the authoritative C80 kernel
nix shell nixpkgs#python313 -c python3 notes/2026-08-30-c80-hall-helper.py \
  --records $E/c80-hall-rematch-q11-exhaustive.json --q11-states 40 --q13-states 6

sha256sum -c $E/SHA256SUMS
```

`--deterministic` omits the wall-clock field, and admission candidates are
selected as the globally smallest by the canonical `(state, opponent, causal)`
exchange key rather than by arrival order, so the emitted summary is
byte-reproducible and independent of the thread count. Both properties were
checked directly: a repeat 16-thread exhaustive `q=11` run is byte-identical,
and a 5-thread run differs only in the recorded `threads` field.

| artifact | SHA-256 |
| --- | --- |
| `ergodis-private/src/bin/c80_hall_rematch.rs` | `7d09180000f7e2889c1bb660a4d1864bfe8522ca4423ae4a7ced8096faac248c` |
| `notes/2026-08-30-c80-hall-helper.py` | `26c3dbb02228a42d7172550ac49614105f799597ec0d5ac0171656cf7e610fc0` |
| `ergodis-private/evidence/c80-hall-rematch-q11-exhaustive.json` | `4dc646b99d0c8fe92cd2ae0cacae76b6eec656740232b57e5167c7e0321039d4` |
| `ergodis-private/evidence/c80-hall-rematch-q13-300.json` | `f90256811e1d72e454be9553dad4439c5ecd4e718742f3af5b4a99470f8b69ff` |
| `ergodis-private/evidence/c80-hall-rematch-q13-50000.json` | `2774ecf21782b488aeb66d4f962ebeb0493fb091b07a1b0a82641634a095888d` |

The three summaries are in place under `ergodis-private/evidence/` and their
hashes are appended to that directory's `SHA256SUMS`, which verifies clean.
Nothing is staged or committed here.

**Foreign-lane note.** `cargo clippy` over `ergodis-private` currently fails to
compile the library: `src/g53_search.rs` and `src/lib.rs` carry in-flight
uncommitted edits from another session, and `G53SearchOutcome` is constructed
without its `active_quotient_shifts` and `active_subgroup_identities` fields.
`cargo build --bin c80_hall_rematch` is unaffected and passes. This is not a
cap-lane change and was not touched here; it is raised for the owning lane.

## 9. `ej` + `tt` closeout

**`ej`.** Three free upgrades were taken in this wave. The sampled `q=11`
control was replaced by an exhaustive one at no meaningful cost, converting a
1,000-state diagnostic into an exact statement over all 1,560,900 size-four
states. The triage was widened from the 1,266 failures to all 10,164,000
defect-creating exchanges, which turned a per-failure classification into the
much stronger vacuity theorem. And the `q=13` control was scaled from 300 to
50,000 states, giving 5.1 million exception-free instances of exactly the two
properties the crown needs.

**`tt`.** The Tao-style question is not "does the edge relation work" but "does
the instance exist". Asking it exposed that the entire `q=11` layer — the field
where every prior C80 falsifier was found — is game-semantically empty for this
crown. Two consequences follow immediately. First, no amount of `q=11` search
can produce the support-deficit counterexample the acceptance gate asks for;
that search must move to `q=13`. Second, the `q=11` one-to-many falsifier that
killed causal one-label transport is itself an N-position artifact, so it
constrains the *edge language* but carries no strategy content — which the
prior probe suspected and this census settles.

The remaining field-uniformity gap is now sharply shaped. What is needed is a
proof of `|consumed| >= |created|` (with strict inequality for `q >= 13`) from
the projective incidence structure of a complete exchange, plus the
opponent-complete entry theorem. The counting statement, not a matching
statement, is the crown.

## 10. Mystery ledger

- **[SETTLED]** *Was the ancestral-secant edge Hall-saturated on the certified
  `q=11` domain?* Vacuously. That domain contains zero certified replies that
  create a defect, exhaustively, not merely in the 1,000-state sample.
- **[SETTLED]** *What are the 1,266 raw failures?* Ancestral-secant Hall
  deficiencies on unrestricted `q=11` complete old-labelled exchanges. All
  1,266 — and all 1,984,400 in the exhaustive census — have an `Omega = 0`,
  Grundy-nonzero, hence N-position successor. Certified away with an exact
  per-class certificate.
- **[SETTLED negative]** *Does strict support-cardinality descent hold at
  `q=11`?* No. 363,000 exhaustive exchanges leave support flat. The
  lexicographic pair `(support, Omega)` descends without exception.
- **[SETTLED]** *Is there a support-deficit set at `q=11`?* No, under the
  complete relation, exhaustively over size-four roots. The ancestral-secant
  deficits all sit on dead positions.
- **[SETTLED]** *Why is `q=11` degenerate?* Legal-set collapse: a size-six
  `F_11` residual has about one legal move, so the game ends before the
  absorption clock can matter. `q=13` retains a live game at the same depth.
- **[OPEN — C80]** *Does `|consumed| >= |created|` hold field-uniformly?* Zero
  counterexamples in 10,890,000 exhaustive `q=11` and 20,703,372 sampled `q=13`
  exchanges, but no proof. This is the live counting statement.
- **[OPEN — C80]** *Does the sparse ancestral-secant relation survive above
  `q=13`?* Zero failures on 5.1 million `q=13` instances; `q=17`/`q=19` untested
  and the local charge-transport lemma is still missing.
- **[OPEN — C80]** *Do the exhaustive `q=11` facts survive past size-four
  roots and past old-labelled exchanges?* Both restrictions are inherited from
  the existing scouts. Lifting the old-label restriction multiplies the
  exchange count by roughly 200; lifting the size-four restriction changes the
  problem.
- **[OPEN — C80/C82 gate]** *Opponent-complete entry.* Untouched by this wave.

## 11. Proposed next step for the cap-lane handoff

Proposed replacement for the handoff's **Next action** (not applied here):

> The `q=11` layer is exhaustively closed and carries no crown content: every
> complete old-labelled exchange creating a genuinely new defect lands in an
> N-position, so `q=11` can supply neither a support-deficit counterexample nor
> positive Hall evidence. Move the whole search to `q=13`, where 5.1 million
> exchanges satisfy both crown clauses without exception. The live statement is
> the counting inequality `|consumed| >= |created|`, strict for `q >= 13`,
> proved from the projective incidence structure of a complete exchange —
> not a matching theorem. `q=11` is discharged as the equality base case.

## 12. Vibe

Good wave. Nothing was proved uniformly, but the crown's `q=11` layer went
from an ambiguous 1,266-failure diagnostic to an exact, independently replayed
closure, and the reason it was ambiguous — the field is too small to host the
phenomenon — is now a measured fact rather than a suspicion. The disappointment
is that strict support descent is false at `q=11`; the compensation is that
`q=13` satisfies it 5.1 million times with no exceptions and no admission
restriction, which is much better evidence than the crown had this morning.

**Status: complete.**

go C80 cap prove the complete-exchange counting inequality `|consumed| >= |created|` at q>=13 from projective incidence, discharging q=11 as the equality base
