# Ergodis second-modality control: exact semantic rank cores

**Date:** 2026-08-30

## Outcome

Ergodis now instantiates the same compile/reduce/replay architecture in a
second mathematical modality.  The first control compiled finite-set overlap
and affine group actions.  This control compiles labelled linear equations
over `GF(9)` into a minimum semantic generator core and an exact row-basis
certificate.

The landed representation-theory calculation is deliberately used as a
control because its answer was already frozen independently.  For the extra
`L(2,0)` channel in `Sym^2(Sym^3 E)`, the Rust adapter reconstructs the four
generator actions from field arithmetic rather than consuming the Python
answer.  It obtains:

- 120 raw intertwiner equations in 30 variables;
- rank 29 and Hom dimension one;
- a deterministic 29-row replay basis, a 4.138-fold equation reduction;
- row counts `20/4/5/0` from `u(1)/u(a)/Weyl/torus`;
- exactly the three minimum full-rank block cores
  `{u(1),u(a),Weyl}`, `{u(1),Weyl,torus}`, and
  `{u(a),Weyl,torus}`;
- rank loss one when Weyl is removed and zero for each other single-block
  ablation.

These values exactly match the pre-existing Python rank-core extraction.  The
Rust certificate verifier independently reconstructs the selected subsystem,
checks that its rank is 29, replays all minimum cores and single-block
ablations, and exhausts every smaller block subset.  This is a bounded finite
certificate, not an all-field representation theorem.

The adapter also reconstructs and certifies the complete frozen five-channel
control corpus rather than specializing to that one example:

| digits | variables | rank | Hom dim. | minimum core | core count |
|---|---:|---:|---:|---:|---:|
| `(0,0)` | 10 | 10 | 0 | 2 | 4 |
| `(0,2)` | 30 | 29 | 1 | 3 | 3 |
| `(1,1)` | 40 | 40 | 0 | 3 | 3 |
| `(2,0)` | 30 | 29 | 1 | 3 | 3 |
| `(2,2)` | 90 | 90 | 0 | 3 | 3 |

Every row is rebuilt from the same field/tensor adapter and every certificate
is replayed.  The different dimensions, ranks, and two distinct minimum-core
shapes are a direct guard against answer-specific logic.

## Architecture

`semantic_rank.rs` separates the reusable compiler from the landed domain
adapter.  `SmallField` is a statically dispatched arithmetic interface; a
`BlockSystem<F>` stores one dense row-major arena plus semantic block offsets.
`RankWorkspace<F>` pre-sizes its elimination matrix once;
every subsequent block-rank query copies into that arena and eliminates
without allocation, recursion, or dynamic dispatch.  Fixed-cardinality block
subsets use the existing Gosper iterator rather than scanning all masks at
every size.  An independent `GF(2)` control exercises the same compiler to
guard against accidentally baking the landed `GF(9)` answer into the engine.
The `GF(9)` adapter's add, multiply, negation, and inverse operations are tiny
compile-time tables.  Exhaustive field-law tests check the table adapter; the
elimination loop therefore replaces division/remainder arithmetic with two
indexed loads without weakening the arithmetic trust boundary.

Compilation emits a `SemanticRankCore` containing:

```text
full rank
minimum full-rank semantic block masks
single-block marginal losses
deterministic independent source-row indices
```

The row indices are the witness lift: they point back into the original
labelled equations, while the block masks retain the source-generator
meaning.  They are emitted in the machine-readable result and evidence, with
`block=floor(row/30)`, `output=floor((row%30)/3)`, and `input=row%3`.  The
verifier does not trust cached ranks or the adapter's prose.

The domain-specific reconstruction lives separately in
`landed_rank_adapter.rs`; no internal research identifiers or conclusions were
added to the public Ergodis crate.

## Measurement

On CPU 2 of the Ryzen AI 9 HX 370, performance governor, boost enabled, eleven
outer runs with 2,000 rank replays per measurement gave:

| measure | median |
|---|---:|
| semantic-core compilation | 107 us |
| raw 120-row rank replay | 6,798 ns |
| compiled 29-row replay | 1,986 ns |
| replay speedup | **3.443x** |

The per-run speedup range was 3.343x--3.530x.  Against direct `GF(9)` digit
arithmetic, table compilation separately improves compiler time by 3.710x,
raw replay by 4.124x, and core replay by 3.643x.  The important result is not the
sub-millisecond absolute time but that the mathematical certificate reduction
produces an almost proportional replay reduction while preserving exact
source-row witnesses.

The census binary also has an isolated `--replay-kernel raw|core` counter mode.
It performs no serialization or control-corpus work, allocates its workspace
before the timed loop, and makes every replay allocation-free.  Five
`perf stat` repetitions pinned to CPU 2, with 500,000 replays per process,
measured:

| counter | raw | compiled core | raw/core |
|---|---:|---:|---:|
| cycles | 17.111 B | 4.767 B | **3.589x** |
| instructions | 137.730 B | 39.689 B | **3.470x** |
| branches | 29.806 B | 8.400 B | **3.548x** |
| branch misses | 4.546 M | 1.039 M | **4.376x** |
| elapsed | 3.719 s | 0.997 s | **3.729x** |

The six counters were multiplexed at approximately 83.3% coverage; `perf`
scaled the reported counts.  The instruction and branch reductions closely
track the row-certificate reduction, directly supporting theorem-driven work
elimination.  Cache counters were also sampled but are omitted from the claim
because their five-run variance was high.

Machine-readable evidence is in
`ergodis-private/evidence/semantic-rank-census-v1.json`.

## What this establishes

This is stronger evidence for the cross-domain thesis than a second orbit
census would have been.  The common engine shape is now literal across two
modalities:

```text
structured source object
-> precompiled exact arena
-> semantic reduction
-> minimal/irredundant core
-> independently replayable lift to source witnesses
```

The affine control uses partition identities and generator closure.  The rank
control uses semantic block ablation and finite-field elimination.  They share
bounded enumeration, pre-sized workspaces, exact witnesses, and a strict
finite-certificate boundary.

## Highest-value extension

Implement the `GF(25)` arithmetic adapter and feed the same generic block
compiler the landed `q=25` and first exponent-three systems.  Label variables
and rows by incoming/outgoing carry, digit state, torus alias, and Weyl
partner.  Quotienting states with identical future pivot behaviour would then
test the genuinely new minimal-realization claim rather than only reproduce
the known catalecticant control.
