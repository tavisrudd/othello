# C985 to C1016: type-driven hot-kernel optimization shortlist

**Lane:** `complete-ports`

**Audience:** the agent owning the in-flight private C1016 kernels

**Scope:** advisory handoff only. No C1016 source, binary, report, or public
Ergodis API was changed for this investigation.

## Purpose

This memo ranks the type-level representations C1016 should try to remove real
work from its search and synthesis kernels. The common pattern is:

`cold validation -> private typed witness -> branch-free fixed-shape kernel`.

The marker may be zero-sized, but the objective is not clever typing by
itself. A candidate is useful only when the invariant lets the hot kernel omit
validation, dynamic shape work, bounds checks, unpacking, or redundant theorem
tests.

## Ranked shortlist

| Rank | Type shape | C1016 target | Expected mechanism |
|---:|---|---|---|
| 1 | `ResidualTuple<T, 7>` plus `MatchingFamily<Spec>` | seven residual matchings / bounded group aggregation | fixed trip count, fused aggregation, SIMD/unrolling |
| 2 | `ShiftPack<MASK>` | q1/q2/q3/q6/q9 residual tests | eliminate active-shift dispatch and fuse updates |
| 3 | `PackedProfile<Layout>` and `Residue<M>` | quotient keys, mod-7/mod-49 profiles, pair fibres | make width/range invariants travel with packed values |
| 4 | `ActivePrefix<N>` / `KernelShape<N>` | quotient-prefix and low-dimensional loops | remove length checks and dynamic loop bounds after one cold dispatch |
| 5 | `ValidatedRegistry` typestate | Horn derive/replay and promoted theorem programs | move registry validation out of repeated calls while preserving compact code |

The first four can affect solve-time kernels. The fifth is worthwhile only if
campaign counters show that theorem closure/evaluation is invoked frequently.

## 1. Seven-residual aggregation

This is the clearest response to the C1015/C1016 friction report. Use an owned
fixed-width value, not a slice carrying a runtime length:

```rust
#[repr(transparent)]
struct ResidualTuple<T, const N: usize>([T; N]);

struct MatchingFamily<Spec>(PhantomData<fn() -> Spec>);
```

`Spec` may provide a compile-time incidence table only when the seven
matchings are sealed theorem data. If the matchings are evolved, store the
validated compact table once and keep only the tuple dimension static. The
kernel should compute equality masks, extrema, sums, and multiset fingerprints
in one pass rather than materializing seven independent results.

Prototype `N=7` separately from the generic fallback. Check scalar, explicitly
unrolled, and SIMD forms; trust counters rather than assuming unrolling wins.

## 2. Fixed quotient-shift packs

Represent the active q1/q2/q3/q6/q9 family by a compile-time mask:

```rust
struct ShiftPack<const MASK: u16>;
```

A cold match selects one of the few masks actually used by C1016, then invokes
one fused kernel. The type can expose the ordered representatives and exact
active count. This removes per-node `active_shift` branches and permits shared
loads/intermediates across several residual equations.

Do not instantiate every possible mask. Specialize the observed dominant
families and retain one generic runtime-mask fallback to control code size.

## 3. Packed profiles, residues, and bounded IDs

Use transparent newtypes whose private constructors establish packing
preconditions:

```rust
#[repr(transparent)] struct Residue<const M: u16>(u16);
#[repr(transparent)] struct OrbitId<const N: usize>(u8);
#[repr(transparent)] struct PackedProfile<Layout>(u64, PhantomData<Layout>);
```

This is especially valuable for mod-7/mod-49 lifts, quotient profile keys, and
the fixed pair-fibre workspace. It prevents the recurring failure where a
shift width or range guard lives in one caller rather than travelling with the
packed value. A sealed table wrapper may use unchecked indexing internally;
the unsafe primitive must remain private to the module owning the invariant.

`Layout` should encode field offsets and widths as associated constants. Cold
construction proves non-overlap and total width; hot extraction then becomes
constant shifts/masks with no repeated validation.

## 4. Active-prefix and low-dimension dispatch

For a small measured family of dimensions, match once outside search:

```rust
match active_prefix {
    3 => solve::<3>(...),
    5 => solve::<5>(...),
    10 => solve::<10>(...),
    _ => solve_dynamic(...),
}
```

Inside `solve::<N>`, use `[T; N]` or typed views rather than passing `N`
again. This can remove loop bounds, repeated `min(active, capacity)`, slice
length checks, and inactive-suffix clearing. It is appropriate for quotient
prefixes, class counts, and other genuinely small shapes. Gate code size and
the smallest solve separately.

## 5. Validated theorem registries

Prefer a compact typestate witness first:

```rust
struct UncheckedRegistry<'a>(&'a [RuleSpec]);
struct ValidatedRegistry<'a>(&'a [RuleSpec]);
```

Only the validator can construct the second type. Derive/replay then omit
identity uniqueness, conclusion range, and self-premise checks. If the rule
count matters, test `ValidatedRegistry<'a, const N: usize>(&'a [RuleSpec; N])`
as a separate encoding. A sealed zero-sized `Validated<Program>` is the final
option, not the default, because full specialization can worsen code shape.

## What not to force into phantoms

- The learned 90-cell DAG is runtime data. Use typed dense node IDs and
  predecoded fixed-size nodes, but optimize it through layout, branch order,
  or a threaded/table evaluator.
- Evolved rule programs and matching families cannot be represented by a ZST
  unless their complete identity is promoted into sealed compile-time data.
- Arbitrary runtime dimensions need at least a byte or pointer. A phantom may
  attest their validation but cannot carry the value.

## Acceptance matrix

For every candidate, record:

1. exact result/work/transcript parity;
2. zero allocator events in the measured region;
3. one-thread and parallel counters where the kernel participates in search;
4. instructions, cycles, branches, branch misses, and code size;
5. a small control and the largest representative case;
6. struct size/alignment assertions and no public unsafe constructor;
7. the runtime frequency of the eliminated operation.

Reject an encoding when it improves isolated instruction count but loses
cycles or harms the small control. Dispatch must remain outside the solve
loop.

## Horn witness cautionary experiment

Use types to make cold-established invariants travel into hot kernels, but do
not assume that a zero-sized witness is automatically the fastest encoding.
The first real-API Horn prototype removed instructions and branches yet made
cycles worse because its field-by-field transcript construction prevented wide
stores.

The best immediate C1016 targets are the seven-residual aggregation and fixed
quotient-shift kernels, where type-level dimensions can remove genuinely hot
loop work. The Horn proof compiler should first try a compact validated-slice
witness rather than a fully monomorphized ZST program.

## What was measured

A disposable side prototype included the current
`ergodis-private/src/proof_synthesis.rs` implementation without editing it. It
compared:

1. the real `derive_horn_closure_into` over the seven registered q29 rules;
2. a zero-byte `Validated<Q29>` marker whose associated program supplied the
   same rules after a cold validation pass.

Both paths produced byte-identical eight-slot workspaces and identical
`(facts, used)` results. Seven order-rotated pairs of 20 million derivations
gave baseline/ZST ratios:

- instructions: `1.029407910x` in the ZST version's favour;
- branches: `1.086943402x` in the ZST version's favour;
- cycles: `0.898931773x`, `t=-3.64`, a material ZST regression;
- wall: `1.004776176x`, `t=0.10`, unresolved.

The witness itself was exactly zero bytes. Assembly then exposed an accidental
store-shape difference: the control used two eight-byte stores per transcript
record, while the prototype used 8+4+2+1-byte stores. Reconstructing a local
record and assigning it whole restored the paired wide stores. In the corrected
diagnostic, ZST cycles became unresolved rather than regressing, but it used
2.86% more instructions while saving 4.00% branches. It still has no admission
case. The compact validated-slice variant is the next proper experiment.

An earlier synthetic control reported a much larger ZST win, but it had
artificially hidden the dynamic rule slice from the optimizer. It was not
representative of the real closure API and must not be cited as expected C1016
speedup.

## Why the first encoding lost

The first prototype filled the public transcript fields through a mutable
reference. LLVM emitted four stores per 16-byte record: 8+4+2+1 bytes. The
existing kernel constructs the record as a value and emits two eight-byte
stores. Seven repetitions of the narrower store sequence created enough store-
port and dependency pressure to lose cycles despite retiring fewer total
instructions.

Constructing `RuleApplication::EMPTY` locally, filling it, and assigning the
whole record restored paired wide stores. The corrected ZST body is 640 bytes
versus 658 bytes for the baseline, and the cycle regression disappears. This
is a code-generation lesson, not evidence that ZSTs inherently damage the
front end.

This is the same small-solve/code-shape hazard already observed elsewhere in
Ergodis: monomorphization is useful only when the eliminated work exceeds the
I-cache, front-end, and scheduling cost of the expanded kernel.

## Recommended Horn witness sequence

Try these in order, retaining the existing implementation as the A/B control:

1. `ValidatedRegistry<'a>(&'a [RuleSpec])`: a private constructor performs
   registry validation once; the hot closure keeps the current compact loop
   and receives the witness by reference. The witness is a two-word slice,
   but no per-rule or per-call validation remains.
2. `ValidatedRegistry<'a, const N: usize>(&'a [RuleSpec; N])`: one pointer
   rather than a fat pointer. Prevent full unrolling initially with an explicit
   non-inlined compact kernel; measure code size as well as counters.
3. Only if those win, consider a sealed ZST `Validated<Program>` for adapters
   whose complete program is compile-time data. Gate every program size
   separately; do not infer the seven-rule result from smaller registries.
4. If initial facts and the goal are also fixed and derivation is invoked
   repeatedly, test a validated immutable transcript template. Copying seven
   16-byte records or returning a borrowed transcript may dominate recomputing
   an identical closure. This is valid only when the adapter semantics prove
   the transcript is invariant.

Do not optimize this kernel merely because its isolated benchmark is easy to
run. First count real campaign invocations. If closure generation is cold, the
seven-residual search kernels have much higher EV.

## Safety and performance rules

- A phantom is evidence only when all constructors are private and the cold
  validator establishes the represented invariant.
- Assert size and alignment for every hot wrapper. A one-byte value must stay
  one byte; a ZST must stay zero bytes.
- Do not put presentation tags into each hot value. Carry them at the owning
  matrix/program/workspace boundary, or use a compile-time/generative brand.
- Dispatch once before search. Never match a shape, modulus, or theorem kind
  per node.
- Keep generic fallbacks for rare dimensions and masks; specialize only
  measured dominant shapes.
- Gate single-thread and parallel modes, exact work/checksum/transcript parity,
  allocator events, instructions, cycles, branches, branch misses, code size,
  and small-case regressions.
- No live C1016 implementation should be changed until its current owner has
  committed or handed off the relevant files.

## Suggested first experiment

After the live C1016 edit window closes, add a private-only
`ValidatedRegistry<'a>` beside the existing closure API. Benchmark all ten
adapters in `proof-synthesis-perf`, not q29 alone, and record actual campaign
call counts. In parallel, build a separate `N=7` residual-aggregation A/B;
that is the more likely solve-time win.
