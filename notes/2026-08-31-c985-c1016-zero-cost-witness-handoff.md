# C985 to C1016: zero-cost witnesses and fixed-shape hot kernels

**Lane:** `complete-ports`

**Audience:** the agent owning the in-flight private C1016 kernels

**Scope:** advisory handoff only. No C1016 source, binary, report, or public
Ergodis API was changed for this investigation.

## Bottom line

Use types to make cold-established invariants travel into hot kernels, but do
not assume that a zero-sized witness is automatically the fastest encoding.
The first real-API Horn prototype removed instructions and branches yet made
cycles worse because LLVM expanded the fixed program into a large branchy
straight-line kernel.

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

The witness itself was exactly zero bytes. The instruction and branch counts
were essentially deterministic, while cycle and wall measurements were much
noisier. Nevertheless, all seven cycle pairs favoured the existing kernel, so
the first ZST encoding is rejected.

An earlier synthetic control reported a much larger ZST win, but it had
artificially hidden the dynamic rule slice from the optimizer. It was not
representative of the real closure API and must not be cited as expected C1016
speedup.

## Why the first encoding lost

The associated-program constant let LLVM fully specialize and expand all
seven rule tests and transcript writes. That removed loop/validation work but
created a roughly 700-byte, heavily branched closure body. The existing
generic kernel retained a compact predictable loop. On this host, fewer
retired instructions did not mean fewer cycles.

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

## Higher-EV C1016 type shapes

### Seven residual matchings

Represent the fixed family as something like
`ResidualTuple<T, const N: usize>` backed by `[T; N]`, with private checked
construction and an asserted transparent or C layout. For the observed
seven-matching case, dispatch once to `N=7` outside search. This can give LLVM
fixed trip counts for aggregation, equality masks, min/max, and multiset
fingerprints.

If the matching incidence pattern is fixed theorem data, a zero-sized
`MatchingFamily<Spec>` can supply it. If it is evolved/runtime data, keep a
pointer to a validated compact table; a phantom cannot carry arbitrary data.

### Quotient-shift packs

The fixed q1/q2/q3/q6/q9 family is a good fit for
`ShiftPack<const MASK: u16>`. Match the small set of supported masks before
the solve loop, then fuse all active residual updates/tests in one
monomorphized kernel. Retain a generic fallback to avoid combinatorial code
growth.

### Residues and bounded indices

`#[repr(transparent)] Residue<const M: u16>(u16)` and
`OrbitId<const N: usize>(u8)` can validate at construction and carry the
invariant at no extra storage cost. A sealed collection wrapper may then use
unchecked indexing internally while exposing only safe operations. Keep the
unsafe primitive private to the module that owns the invariant.

### Packed keys

Use `PackedKey<Layout>` or `PackedProfile<const BITS: u8>` when a cold
constructor has proved widths and non-overlap. The marker is free; the packed
integer remains the complete runtime representation. This directly addresses
the recurring C1016 failure mode where packing guards live in one caller
instead of travelling with the value.

### Learned 90-cell DAG

The learned table is runtime data, so a phantom mostly strengthens safety. For
speed, prefer predecoded fixed-size node records, dense node IDs, branch-order
profiling, and possibly a threaded/table evaluator. Do not force its dynamic
contents into monomorphized types.

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
