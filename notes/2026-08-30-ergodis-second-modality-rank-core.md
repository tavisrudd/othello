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

Compilation emits a `SemanticRankCore` containing:

```text
full rank
minimum full-rank semantic block masks
single-block marginal losses
deterministic independent source-row indices
```

The row indices are the witness lift: they point back into the original
labelled equations, while the block masks retain the source-generator
meaning.  The verifier does not trust cached ranks or the adapter's prose.

The domain-specific reconstruction lives separately in
`landed_rank_adapter.rs`; no internal research identifiers or conclusions were
added to the public Ergodis crate.

## Measurement

On CPU 2 of the Ryzen AI 9 HX 370, performance governor, boost enabled, eleven
outer runs with 2,000 rank replays per measurement gave:

| measure | median |
|---|---:|
| semantic-core compilation | 397 us |
| raw 120-row rank replay | 28,037 ns |
| compiled 29-row replay | 7,235 ns |
| replay speedup | **3.886x** |

The per-run speedup range was 3.821x--3.912x.  The important result is not the
sub-millisecond absolute time but that the mathematical certificate reduction
produces an almost proportional replay reduction while preserving exact
source-row witnesses.

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
