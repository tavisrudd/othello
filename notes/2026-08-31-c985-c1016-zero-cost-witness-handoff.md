# C1016: type-based optimization experiments to try

**Lane:** `complete-ports`

**Audience:** the agent owning the in-flight private C1016 kernels

**Scope:** advisory handoff only. No C1016 source, binary, report, or public
Ergodis API was changed for this investigation.

## Purpose and recommendation

This is an action memo for C1016, not a report on C985. It ranks the type-level
representations C1016 should prototype to remove real work from its search and
synthesis kernels. The common pattern is:

`cold validation -> private typed witness -> branch-free fixed-shape kernel`.

Start with `ResidualTuple<T, 7>` / `MatchingFamily<Spec>`, then
`ShiftPack<MASK>`. Those are the two candidates most likely to speed the live
solve because they can fuse repeated C1016 work. Try `PackedProfile<Layout>`
and `ActivePrefix<N>` next. Use `ValidatedRegistry` for the lower-priority
evolve/candidate-evaluation path, not as a replacement for already-specialized
fixed adapters.

The marker may be zero-sized, but the objective is not clever typing by itself.
A candidate is useful only when the invariant lets the hot kernel omit
validation, dynamic shape work, bounds checks, unpacking, or redundant theorem
tests.

## Ranked shortlist

| Rank | Type shape | C1016 target | Expected mechanism |
|---:|---|---|---|
| 1 | `ResidualTuple<T, 7>` plus `MatchingFamily<Spec>` | seven residual matchings / bounded group aggregation | fixed trip count, fused aggregation, SIMD/unrolling |
| 2 | `ShiftPack<MASK>` | q1/q2/q3/q6/q9 residual tests | eliminate active-shift dispatch and fuse updates |
| 3 | `PackedProfile<Layout>` and `Residue<M>` | quotient keys, mod-7/mod-49 profiles, pair fibres | make width/range invariants travel with packed values |
| 4 | `ActivePrefix<N>` / `KernelShape<N>` | quotient-prefix and low-dimensional loops | remove length checks and dynamic loop bounds after one cold dispatch |
| 5 | `ValidatedRegistry` typestate | evolved/runtime theorem programs | validate once at promotion rather than once per evaluation |

The first four can affect solve-time kernels. The fifth is specifically for
the evolve daemon's runtime programs; current sealed adapters already receive
compiler specialization through the ordinary closure API.

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

For evolved/runtime registries, prefer a compact typestate witness:

```rust
struct UncheckedRegistry<'a>(&'a [RuleSpec]);
struct ValidatedRegistry<'a>(&'a [RuleSpec]);
```

Only the validator can construct the second type. Promotion from candidate to
executable theorem program performs identity uniqueness, conclusion range,
self-premise, and budget checks once. Derive/replay then consume only the
validated type. The representation is still just a two-word slice and should
be passed by reference.

Do **not** apply this to the current fixed adapter registries for speed. The
compiler already sees their static rule arrays through
`derive_horn_closure_into` and emits specialized straight-line code. A compact
runtime-slice witness was about 1.84x slower than that static control. The type
may still clarify authority, but it has no performance case there.

For genuinely runtime rules, the boundary reverses. A 15-pair disposable
diagnostic comparing the current validation-on-every-call path with a compact
validate-once witness found runtime/witness ratios of 2.648x cycles
(`t=53.48`), 2.415x instructions, 2.957x branches, and 2.524x wall
(`t=12.74`). This is not retained C1016 evidence, but it is strong enough to
make the evolved-program path the proper target for a durable A/B after the
live edit window closes.

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

## Type experiments C1016 should run

Run the candidates in this order, keeping each as a private, independently
revertible A/B:

1. `ResidualTuple<T, 7>` and `MatchingFamily<Spec>`: fuse the seven residual
   matching calculations and their bounded multiset/group aggregates. Compare
   a compact scalar loop, explicit unrolling, and the best applicable SIMD
   shape.
2. `ShiftPack<MASK>`: specialize the dominant q-shift families once outside
   search, reuse common loads and partial sums, and retain a runtime-mask
   fallback.
3. `PackedProfile<Layout>` plus `Residue<M>`: prevalidate packing and modular
   domains, then replace repeated extraction/range work with constant
   shifts/masks and canonical-width arithmetic.
4. `ActivePrefix<N>` or `KernelShape<N>`: specialize only the measured hot
   low-dimensional cases, with one cold dispatch and an unspecialized fallback.
5. `ValidatedRegistry`: move validation out of repeated evolved-program
   evaluation while preserving the compact loop representation.

The first two have the strongest solve-time case because they can fuse work
that C1016 currently repeats. The fifth primarily accelerates theorem
generation/testing in the daemon.

## Validated-registry experiment

For runtime evolved programs, try these in order:

1. `ValidatedRegistry<'a>(&'a [RuleSpec])`: a private constructor performs
   registry validation once; the hot closure keeps the current compact loop
   and receives the witness by reference. The witness is a two-word slice,
   but no per-rule or per-call validation remains.
2. When a runtime program is promoted into a sealed reusable theorem, test
   `ValidatedRegistry<'a, const N: usize>(&'a [RuleSpec; N])` separately. One
   pointer replaces the fat pointer, but monomorphization/code-size gates are
   mandatory.
3. Do not replace existing static adapters with a ZST wrapper for performance;
   the ordinary API already specializes them. A ZST remains useful only as an
   authority token or API boundary.
4. If initial facts and the goal are fixed and derivation is invoked
   repeatedly, test a validated immutable transcript template. Copying seven
   16-byte records or returning a borrowed transcript may dominate recomputing
   an identical closure. This is valid only when the adapter semantics prove
   the transcript is invariant.

Count real evolve-campaign evaluations before promotion. If runtime registry
evaluation is cold, the seven-residual search kernels still have higher EV.

## Measurement-derived constraints

A disposable real-API prototype established two constraints for these type
experiments:

- Existing fixed Horn adapters are already compiler-specialized through the
  ordinary API. Wrapping them in a ZST does not itself remove work.
- Construct hot transcript records as complete values. Field-by-field mutation
  changed two wide stores into 8+4+2+1-byte stores and caused an approximately
  11% cycle regression despite fewer instructions and branches. Whole-record
  assignment removed that regression.

The useful lesson for C1016 is narrow: inspect generated code and counters for
every typed representation. A zero-byte marker is free in layout, but the
surrounding source shape can still worsen stores, scheduling, code size, or
front-end pressure. Admit a type-level specialization only when it eliminates
measured hot work in the real kernel.

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

After the live C1016 edit window closes, start with the private `N=7`
residual-aggregation A/B because it has the best chance to remove solve-time
work. Then add `ValidatedRegistry<'a>` at the evolved-program promotion
boundary and measure it on real candidate-evaluation traffic. Leave the fixed
adapters unchanged unless an authority/API argument independently justifies a
migration.
