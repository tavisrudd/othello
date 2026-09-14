# C1170 — the token store, and the first semantic admission stage

**Lane**: `ergodis`
**Date**: 2026-09-14
**Repository**: `~/src/ergodis-private` (private, no public remote), branch `main`
**Control**: `ergodis-tools` built at revision `cfe4893` and retained as `ergodis-tools-cfe4893`
(rebuild recipe: `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at that revision).
Measured sha256 `a4b23e3e87db3578ed7d470b40fbb6eb7e5a4bf803e1967604d02c858eed0b9d`,
rustc 1.93.1 (01f6ddf75 2026-02-11) read from the binary's `.comment` section, release profile,
no features.

**Commits** (all on `main`, in order):

| Commit | Contents |
|---|---|
| `35f4484` | phase 1: the scan writes tokens through a cursor over the pool's spare capacity; the committed codegen probe; the parity receipt regenerated with an unchanged canonical hash |
| `69a85db` | phase 1: the A/B, cache and class-decomposition receipts |
| `49493a3` | phase 2: semantic admission of name binding and arity — the stage, its records and limits, its fixtures, the driver and harness boundary, the coverage manifest, and the parity corpus with admission outcomes |
| `32a18c6` | phase 2: the admit-stage cost-budget receipt and the frontend README's admission and token-store sections |

## Status

Complete, both phases, with one kept optimization, two rejected shapes, a new measured stage, and
two open items carried in the ledger.

Vetting notes (parent session, 2026-09-14): both test targets (23 and 1) and strict Clippy on the
library, both test targets and `ergodis-tools` were re-run independently at `32a18c6` with the
ambient toolchain and pass. The single `unsafe` (`Vec::set_len` outside the loop) was checked
against its invariant: `emit_flagged` writes only through `slots.get_mut(written)` and increments
`written` after the write, the slice is bounded by `min(limits.tokens, capacity)`, and the length
is set on both the success and failure return paths. The scalar-variant loss on the
comment-string cohort (1.0024, experimental variant only) is accepted as recorded; the production
byte variant wins on every cohort. Two toolchains are now in play on this host — the ambient
`cargo` on `PATH` (rustc 1.93.1, which `retain-bin.sh` uses) and `nix shell nixpkgs#rustc`
(1.95.0, which the two previous reports used) — so the lane needs one pinned choice before the
next A/B; that is raised in the handoff as a decision for Tavis.

Phase 1 kept the token-store change and answered the question it was given in the negative: writing
the 16-byte `Token` as one or two wide stores is **not** cheaper than five narrow stores — it is one
instruction per token dearer — and the cost that was actually there was the bookkeeping around the
store, two capacity tests and four reloaded workspace fields per token. Removing that is worth
**5.00 instructions per token, exactly, on every cohort**, which is 2.91 per cent of the ASCII parse
stage and 6.28 per cent of its scan stage. The wide-store shapes were rejected on compiled evidence
from a committed codegen probe rather than on an A/B, and the reasoning is recorded so nobody
rebuilds them.

Phase 2 added semantic admission — name binding and arity over the parse output — as a separate
stage with its own `REL04xx` error range, its own bounded pools, its own fixtures and its own
measurement boundary. It admits the three well-formed cohorts, rejects four fixture classes with
both spans, allocates nothing, and costs 40.68 instructions per source byte on the ASCII cohort,
two thirds of what parsing costs. The parse stage measures at ratio 1.00000 against the
pre-admission binary, so nothing about parsing moved. The parity corpus now records an admission
outcome per case, which changes the canonical hash to `5a350e1f…`.

## Phase 1 — the token store

### What the control does, read off its disassembly

`objdump -d` of the byte-dispatch monomorphization of `rel_frontend::lexer::scan` in the retained
control, at the punctuation fast path (symbol offset `+0x2d8`), is twenty-two instructions, of
which sixteen are the token store:

```text
mov  0x10(%r8),%rbx          ; tokens.len()
mov  0x64(%r8),%ecx          ; limits.tokens
cmp  %rcx,%rbx
jae  <TokenCapacity>
cmp  (%r8),%rbx              ; Vec::push's own len == capacity test
jne  <store>
call grow_one                ; never taken
mov  0x8(%r8),%rax           ; pool base pointer, reloaded every token
mov  %rbx,%rcx
shl  $0x4,%rcx
mov  %r12d,(%rax,%rcx,1)     ; start
mov  %ebp,0x4(%rax,%rcx,1)   ; end
mov  %r14w,0x8(%rax,%rcx,1)  ; kind
movw $0x0,0xa(%rax,%rcx,1)   ; flags
movl $0x0,0xc(%rax,%rcx,1)   ; reserved
inc  %rbx
mov  %rbx,0x10(%r8)          ; tokens.len() written back
```

Three costs are visible and none of them is the store width:

1. **Two capacity tests per token.** The scanner's own test against `Limits::tokens` and
   `Vec::push`'s test against the allocated capacity. The second is redundant — `Workspace::new`
   reserves `limits.tokens` — but nothing in the emitted code proves the relation, so both run.
2. **The pool base pointer and the length are re-read from the `Workspace` every token**, because
   a `Vec::push` may reallocate and the compiler cannot rule that out.
3. **The record is written as five stores**, three of them for the 8-byte tail (`kind`, `flags`,
   `reserved`), because `kind` comes from a table at run time while the other two are constants.

### The `Token` record and the pool's alignment

`Token` is `#[repr(C)]`, 16 bytes, align 4, asserted at compile time in `src/rel_frontend/mod.rs`:
`start: u32`, `end: u32`, `kind: Kind` (`#[repr(u16)]`), `flags: u16`, `reserved: u32`. The pool is
a `Vec<Token>` reserved by `try_reserve_exact`, so its base carries the allocator's alignment (16
bytes or a page for the 2 MB bench pool) but the compiler only knows align 4. On x86-64 that is
immaterial: a 16-byte `movups` has no alignment requirement, so raising the record's declared
alignment to 16 would buy nothing that the unaligned store does not already have. Candidate (b) of
the task brief — raise pool alignment and let the compiler emit a single `movups` — is therefore
not a separate candidate at all; the question is only whether the *value* can be assembled into
one or two wide registers for less than the five narrow stores cost.

### Fermi, written before any source change

Measured against the control's own disassembly rather than guessed, using a standalone codegen
probe (`analysis/rel-frontend/token-store-probe.rs`, committed, replay command in it) that compiles
the three candidate shapes in isolation with the same compiler and counts the instructions each
lowers to.

| Shape | Per-token instructions in the probe | Prediction |
|---|---:|---|
| `Vec::push` behind a limit test (the control) | 16 | — |
| Cursor over the pool's spare capacity, one bound test | 10 | **−6 per token** |
| Two `u64` words over the same cursor | 11 | **+1 per token** |

The two-word shape *loses*, and the probe says why: assembling `start | end << 32` costs a
zero-extend, a shift and an or — three arithmetic instructions to save three stores — while the
high word needs a `movzwl` of the kind unless the kind is already zero-extended. Five narrow
stores against two wide stores plus four arithmetic instructions is a one-instruction loss on a
run-time kind, and worse at the sites where the kind is a compile-time constant, because there the
compiler already merges the whole 8-byte tail into one immediate store. A 16-byte single store is
worse again: the value must be assembled in a vector register (`movq` + `pinsrq`) first.

The identity `match` from `u16` back to `Kind` that a packed representation needs is *not* what
makes it lose: the probe shows the compiler recognises the identity map and compiles
`packed.kind()` to exactly the same two instructions as a plain field read. That is worth
recording — a packed token is free to *read* — but it does not rescue the write side.

So the candidate worth an A/B is the cursor, which is the task brief's candidate (c), the
capacity-check hoist, in its strongest form: take the pool's spare capacity once at scan entry,
keep the write cursor in a local, test it once per token against the bound, and write the pool's
length back once at scan exit.

**Predicted leverage.** Six instructions on every one of the ASCII cohort's 15,489 tokens is
92,934 instructions per scan iteration, which against the previous report's measured ASCII scan
stage (1,241,103) and parse stage (2,649,711) is **7.5 per cent of the scan stage and 3.5 per cent
of the parse stage**. The bracket is 2.5 to 4.5 per cent of the parse stage; the uncertainty is
whether the compiler keeps the cursor in a register across the loop and whether the identifier and
number emit sites, where the kind is a constant, save the same six.

### What was built, commit `35f4484`

`lexer::scan` now takes the token pool's spare capacity once, hands it to `scan_into` as a slice
argument, and keeps the write cursor in a local. `emit` writes through
`slots.get_mut(*written)` — one bound test, then `MaybeUninit::write` — and the pool's length is
set once when scanning stops, on the failing path as well as the succeeding one, so a failed scan
still leaves exactly the tokens it had produced, as pushing did.

The one `unsafe` is `Vec::set_len` in `scan`, outside the loop, with a local `SAFETY` comment
stating the invariant it relies on: `scan_into` writes the spare capacity strictly in order from
index 0 and counts each write, the pool's length was zero on entry because the caller clears it,
the count never exceeds the reserved capacity, and `Token` is `Copy` with no destructor. No raw
pointer and no transmute was introduced, and the bound is still `Limits::tokens`, clamped to the
reserved capacity so the slice can never be shorter than the bound the scanner tests against.

The candidate's own disassembly shows the predicted shape with one addition: the compiler outlined
the last store and the cursor increment into a block shared by the emit sites, so the punctuation
fast path ends in a `jmp` to it. That is one instruction back, and it is the whole difference
between the predicted six and the measured five.

```text
cmp  0x20(%rsp),%r10         ; cursor against the bound
jae  <TokenCapacity>
lea  PUNCT_KIND(%rip),%rcx
movzwl (%rcx,%rax,2),%eax
mov  %r10,%rcx
shl  $0x4,%rcx
mov  %r14d,(%r8,%rcx,1)      ; base pointer in a register, not reloaded
mov  %r13d,0x4(%r8,%rcx,1)
mov  %ax,0x8(%r8,%rcx,1)
movw $0x0,0xa(%r8,%rcx,1)
jmp  <shared tail: movl $0x0,0xc(…); inc %r10>
```

## Phase 1 — method

Both arms are `ergodis-tools`, built by the ambient toolchain and retained before any measurement.
The retained executables are a local A/B convenience; each arm is identified by what is
git-visible.

| Arm | Repository | Revision | Dirty | Profile | Features | rustc | Retain recipe | Measured sha256 |
|---|---|---|---|---|---|---|---|---|
| control   | `ergodis-private`, `main` | `cfe4893` | dirty (foreign files listed below) | release | none | 1.93.1 | `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` | `a4b23e3e…eed0b9d` |
| candidate | `ergodis-private`, `main` | `35f4484` | dirty (same set) | release | none | 1.93.1 | same | `c8c44aa5…498d0ff` |
| admission | `ergodis-private`, `main` | `49493a3` | dirty (same set) | release | none | 1.93.1 | same | `acad2e05…3e1f6420` |

The measured hashes are recorded as measured, not cited: the thing to run is the recipe at the
revision. The foreign uncommitted files present at every build are the campaign-console mockups and
interface-review material under `analysis/`, `packages/execution-provider/src/lib.rs`,
`packages/hadamard-provider/tests/contracts.rs`,
`packages/parameterization-provider/tests/contracts.rs`, `src/hadamard_execution.rs`,
`src/partitioned_additive_join.rs`, `tests/partitioned_join_profile.rs` and
`tests/quadratic_residual_profile.rs`. The repository-wide diff of those files was hashed at the
start of this task and again at the end and was identical
(`a954fbdc…7fb6a2df28`), so every arm saw the same foreign tree and they cancel in every ratio. No
executable in this report is reproducible from its commit alone.

**The toolchain moved back.** The previous report's control was built by `nix shell nixpkgs#rustc`
at rustc 1.95.0; the ambient `cargo` on this host is now rustc 1.93.1, and `retain-bin.sh` uses
the ambient one. Every arm here is 1.93.1, confirmed from each binary's `.comment` section, so the
A/B is toolchain-matched — but absolute instruction counts in this report are not comparable with
the punctuation report's, and the gates below were run with the ambient toolchain too rather than
under `nix shell`, so that tests and measured binaries share a compiler. The ASCII scan stage
measures 1,232,337 here against 1,241,103 there, a 0.7 per cent compiler difference on identical
source.

Protocol, unchanged from the previous report: the committed harness
`analysis/rel-frontend/bench.py`, seven rounds, all five cohorts, 512 definitions, both scanner
variants, `--stages scan,parse,recover`, interleaved with candidate/control and byte/scalar order
alternating per round, an A/A null pair per cohort, under `perf stat` with two-point differencing,
pinned to CPU 5, event set `instructions,cycles,branches,branch-misses,page-faults,minor-faults`,
which does not multiplex on this host. Receipts:
`analysis/rel-frontend/performance-v1-tokstore-35f4484.json` and
`performance-v1-tokstore-35f4484-cache.json` for the cache events.

The A/A instruction nulls are 1.000000 on four cohorts and 0.999999 on the fifth, every interval
within two parts per million of unity, so the protocol is sound at the scale of the effect.

**Branch misses carry no signal here and are not reported as ratios.** Two-point differencing puts
them at −49.6 per iteration on the control's ASCII scan stage and −17.3 on the candidate's: the
count is dominated by process startup, which the differencing subtracts, leaving noise around
zero. Branch *counts* are clean: 327,392 per ASCII scan iteration on the control against 318,816
on the candidate.

## Phase 1 — results

### Candidate over control, instruction ratios

| Operation | byte | scalar |
|---|---|---|
| ascii/scan             | **0.9372** | 0.9794 |
| ascii/parse            | **0.9709** | 0.9869 |
| ascii/recover          | 0.9709 | 0.9869 |
| unicode/scan           | 0.9982 | 0.9969 |
| unicode/parse          | 0.9985 | 0.9974 |
| comment-string/scan    | 0.9791 | **1.0024** |
| comment-string/parse   | 0.9852 | **1.0019** |
| malformed-early/parse  | 0.9372 | 0.9794 |
| malformed-late/parse   | 0.9708 | 0.9869 |
| prepare                | 1.0022 | — |

Every interval is narrower than the fourth decimal place; the headline at full precision is
**ascii/parse/byte 0.97086 [0.97085, 0.97086]**, so the change removes **2.91 per cent of the ASCII
parse stage** and 6.28 per cent of its scan stage. The `prepare` row is 1.0022 [1.0000, 1.0045]:
allocating and dropping a workspace is untouched by this change and the 0.2 per cent is the edge of
that stage's resolution.

Unlike the punctuation fast path, this change is in `emit`, which both scanner variants share, so
the scalar variant is not a null control here — it improves too, by 2.06 per cent on the ASCII scan
stage. That is the expected signature of a change below the dispatch split.

### Absolute instructions per iteration, and the per-token saving

| Operation | Control `cfe4893` | Candidate `35f4484` | Difference | Per token |
|---|---:|---:|---:|---:|
| ascii/scan/byte             | 1,232,337 | 1,154,898 | 77,439 | **5.00** |
| ascii/parse/byte            | 2,656,491 | 2,579,058 | 77,432 | **5.00** |
| malformed-early/parse/byte  | 1,231,061 | 1,153,754 | 77,307 | **5.00** |
| malformed-late/parse/byte   | 2,652,464 | 2,575,132 | 77,331 | **5.00** |
| comment-string/scan/byte    | 1,030,739 | 1,009,241 | 21,498 | 4.66 |
| unicode/parse/byte          | 8,772,473 | 8,759,360 | 13,113 | **0.84** |
| ascii/scan/scalar           | 2,511,346 | 2,459,641 | 51,705 | 3.34 |

Five instructions per token, to the second decimal, on every ASCII-shaped cohort. That is the
disassembly's count, measured from an independent direction. The Unicode row is the one that does
not fit and is carried as an open item in the ledger below.

### Per-class decomposition at both revisions

`scan-decompose.py` was run against both retained binaries — the same compiler, so the two
receipts are directly comparable — giving the cost of one token of each class from single-class
synthetic sources (receipts `performance-v1-scan-classes-cfe4893.json` and
`performance-v1-scan-classes-35f4484.json`).

| Synthetic class | Tokens in the source | Control, per token | Candidate, per token | Change |
|---|---:|---:|---:|---:|
| Delimiter `(`                    | 43,008 |  37.45 |  32.45 | −5.00 |
| Punctuation `+` (a compound lead)| 43,008 |  66.45 |  61.45 | −5.00 |
| Compound `<=`                    | 21,504 |  74.90 |  69.90 | −5.00 |
| Identifier, 3 bytes              | 10,752 | 112.80 | 107.80 | −5.00 |
| Identifier, 15 bytes             |  2,688 | 218.18 | 213.18 | −5.00 |
| Number, 3 digits                 | 10,752 | 120.80 | 115.79 | −5.00 |
| Number, 15 digits                |  2,688 | 222.18 | 217.17 | −5.00 |
| String, 5-byte contents          |  5,376 | 233.59 | 230.59 | −3.00 |
| String, 13-byte contents         |  2,688 | 389.18 | 386.18 | −3.01 |
| Whitespace, per byte             |      — |  13.45 |  13.45 |  0.00 |

Every token class saves exactly five except strings, which save three. The string emit site is the
one whose kind is chosen by a run-time `if` inside the call, and the compiler had already merged
part of its store sequence; the whitespace row saves nothing because whitespace emits no token,
which is the negative control for the attribution.

The same receipts measure the cohorts directly: ASCII 1,232,325 → 1,154,888, a difference of
77,437 over 15,489 tokens, 5.0000 per token, reproducing the A/B in a separate run.

The census prediction on the kept candidate is **−0.62 per cent of the measurement** (1,147,762
predicted against 1,154,888 measured), against −0.50 per cent at the control-era shape. The
residual has the same named cause as before: the `.`, `/` and `...` tokens stay on the shared path
and the census charges them at the compound-lead rate.

### Cache and load behaviour

Supplementary A/B on the ASCII cohort, seven rounds, receipt
`performance-v1-tokstore-35f4484-cache.json`. This event set's own A/A instruction null is 0.9973
[0.9954, 0.9992], looser than the main run's, so it is a supplement and not a decision metric.

| Event | Scan, control | Scan, candidate | Ratio | Parse ratio |
|---|---:|---:|---:|---:|
| instructions            | 1,232,311 | 1,154,376 | 0.9368 | 0.9710 |
| cycles                  |   203,912 |   182,959 | 0.8972 | 0.9328 |
| L1 data-cache loads     |   334,534 |   255,828 | **0.7647** | 0.9223 |
| L1 data-cache misses    |     5,154 |     5,175 | 1.0041 | 0.9974 |
| Last-level references   |     5,344 |     5,245 | 0.9816 | 1.0132 |

Data-cache loads fall by 23.5 per cent on the scan stage, 5.08 per token, while L1 misses are flat.
That is the mechanism stated exactly: four loads of workspace fields per token — the length, the
declared limit, the allocated capacity and the pool's base pointer — are replaced by values the
compiler keeps in registers, and only the bound remains, on the stack. The win is load traffic and
bookkeeping, not store width, which is what the Fermi predicted and what makes the wide-store
candidates uninteresting.

Cycles fall by more than instructions (0.897 against 0.937 on the scan stage), consistent with
removing dependent loads from the token path, but every cycle interval here is wide enough that
this is a remark and not a claim. Wall time from the probe's own timer, secondary to the counters:
the ASCII parse stage's median iteration is 134,671 nanoseconds on the control and 128,319 on the
candidate, a ratio of 0.953.

Peak resident set, ASCII parse stage: control 5,932 KiB, candidate 5,852; ASCII scan stage, 5,508
and 5,504. The change allocates nothing new.

### Kernel-scoped profile

`perf record -e instructions:u -F 4000`, ASCII cohort, byte scanner, 512 definitions, pinned to
CPU 7, on the `scan` stage, which runs UTF-8 validation and the scanner and nothing else.

| Symbol | Control | Candidate |
|---|---:|---:|
| `rel_frontend::lexer::scan`      | 89.33 % | 88.24 % |
| `rel_frontend::lexer::keyword`   |  9.81 % | 10.61 % |
| `core::str::converts::from_utf8` |  0.78 % |  0.89 % |

Every out-of-line call observed inside the loop, as the contract requires: `lexer::keyword`, once
per identifier, which predates this work. `from_utf8` runs once per scan, outside the loop. No
libc symbol appears at any threshold inside the loop; below a tenth of a per cent the profile holds
only clap argument parsing, the source SHA-256 and dynamic linking, all outside the timed region.
`keyword`'s share rises because the total shrank, not because the function changed — the same
instability the previous report recorded as its ledger item 8.

## Phase 1 — disposition and variant record

**Kept**, at commit `35f4484`.

The keep rule this task was given is "not slower on any cohort and a win on ASCII". The second half
holds by 2.91 per cent of the ASCII parse stage. The first half holds for the byte-dispatch
variant, which is what `Workspace::parse` uses, on all five cohorts. It does not hold for the
scalar variant on one cohort: comment-string is 1.0024 on its scan stage and 1.0019 on its parse
stage, about 3,700 instructions per iteration, 0.81 per token against tokens that are mostly
strings. The scalar variant is the experimental matched control the README describes, not a
production path, and the same change wins on it on the other four cohorts, so the loss is recorded
rather than treated as disqualifying. Its cause is codegen, not design: the string-heavy path in
the scalar monomorphization now carries the cursor, the base pointer and the bound as live values
and the register allocator pays for it there. Reverting is not proposed; the statement this report
stands behind is that the change is a win everywhere that matters and a rounding-error loss in one
place.

Accepted and rejected variants, so the next agent does not repeat them:

- **Accepted: the cursor over the pool's spare capacity** (`35f4484`), −5.00 instructions and −5.08
  data-cache loads per token.
- **Rejected before any A/B, by compiled evidence: the token as two `u64` wide stores.** The probe
  compiles it at +1 instruction per token against the cursor shape, because assembling
  `start | end << 32` costs three arithmetic instructions to save three stores. Worse at the emit
  sites whose kind is a compile-time constant, where the compiler already merges the whole 8-byte
  tail into one immediate store.
- **Rejected for the same reason: a single 16-byte store.** The value must first be assembled in a
  vector register (`movq` then `pinsrq`), which costs more than the two-word shape it builds on.
- **Rejected as a non-question: raising the pool's alignment to 16.** The record is `#[repr(C)]`,
  16 bytes, align 4, and the allocator already returns a 16-byte-or-better aligned block; on x86-64
  an unaligned 16-byte store has no penalty, so a declared alignment buys nothing the candidate
  above does not already have.
- **Recorded, not a defect: the identity map from `u16` back to `Kind`** that any packed
  representation needs is free. The probe shows the compiler recognises it and compiles
  `packed.kind()` to the same two instructions as a plain field read. A packed token is free to
  read and dear to write.
- **Rejected by design: pre-filling the pool to `Limits::tokens` at construction**, which would let
  the scanner index it safely with no `unsafe` at all. It would move the 1.13 milliseconds of
  first-touch page faults the previous report measured into `Workspace::new`, defeating the
  reserve-without-touching design that the `prepare-touch` stage exists to measure.
- **Rejected by design: testing `len >= capacity` instead of `len >= limits.tokens`**, which would
  let the compiler fold `Vec::push`'s own test away with no new code at all. It makes a declared
  bound depend on what the allocator returned, and the native/WASM parity corpus contains capacity
  cases whose outcome must not depend on an allocator.

## Phase 2 — semantic admission

Commit `49493a3`. `Workspace::admit(source)` is a stage after `Workspace::parse`, with its own
error range, its own fixtures, its own bounded pools and its own measurement boundary in the
driver. It is not a stub and it is not a zero-cost placeholder: on a cohort whose parse fails it
does not run at all, and the driver's receipt says so per cohort.

### What it checks, and what it admits explicitly

**Name binding.** Every `Name` reference in a definition body — and in a parameter's domain
expression, and in a bare top-level expression — must resolve to one of four things: a binder in
scope, a definition or module declared anywhere in this source, a builtin from an allowlist
committed in `src/rel_frontend/admit.rs`, or an external base relation.

That last category is the design decision the check turns on. A Rel source is a fragment: the
relations a rule body reads are usually database relations the fragment does not declare, and the
measurement cohorts are full of them (`edge0`, `person`, `weight7`). Rejecting every free name
would reject every realistic input and make the stage measure nothing. Admitting every free name
silently would make the binding check vacuous. The stage does neither: a free name is admitted as
an **external base relation**, recorded in the symbol table on first sight and arity-checked from
then on, while a spelling that **is a binder somewhere in the definition being checked** but is not
in scope at the use is rejected as `UnboundName`. That is the escaped-variable class — `def f =
exists(x: p(x)) and q(x)` — which is the binding error a Datalog frontend must actually catch, and
it survives the free-name policy because binder spellings are owned by their definition. A binder
whose scope closes is marked rather than dropped, so the use that escapes it still finds it.

Binders come from definition parameters, including `x in domain` restrictions and `t...` varargs,
from specialization parameters in `f[T](…)`, and from `:` relational abstractions, whose left side
binds and whose right side is the body those binders are in scope for. `_` binds anonymously and
is never referenced.

**Arity.** A parenthesised application must agree with the argument count its definition declares,
or — for an external base relation, which no definition in this source fixes — with the count of
the first application that fixed it. Several definitions may define one relation, as Rel allows,
and the check admits a use that matches any visible one.

Admitted explicitly rather than by omission, each because the Rel reference makes it a distinct
form and not an oversight:

- **Square-bracket application is partial application and specialization**, so it neither checks
  nor fixes an arity. `def score[k] = sum[v: weight(k, v)]` declares no value arity and `column[x]`
  constrains nothing.
- **Varargs declare a lower bound.** `def pick(t...)` fixes a fixed part of zero and admits any
  count; a use that carries a spread, `member(t..., x)`, is itself a lower bound and matches any
  declared arity at least as large.
- **A bare reference constrains nothing.** Only an application fixes or tests an arity, so a
  relation mentioned without arguments never contradicts a later application of it.
- **A definition with no parenthesised parameter list fixes no arity.** `def pair = …` is not
  claimed to be nullary, because in this prototype that spelling is also how a specialization or a
  symbol-keyed entry is written.

**Rejection is explicit.** A binder-list element that is not a name, an `_`, a spread or an `in`
restriction, and a definition header whose shape the stage does not recognise, are
`UnsupportedSemantics`. Nothing is admitted by falling off the end of a match.

The five codes are `REL0401` `UnboundName`, `REL0402` `ArityMismatch`, `REL0403` `SymbolCapacity`,
`REL0404` `AdmitDepthCapacity` and `REL0405` `UnsupportedSemantics`. They are a new range rather
than the `REL02xx` the task brief suggested, because `REL02xx` is already the parser's and
`REL03xx` is unsupported syntax; `ErrorCode::is_semantic` separates the two paths and a test
asserts that a source which fails to parse never carries a semantic code.

### Failure record, spans and rendering

`SemanticFailure` is a separate 16-byte `#[repr(C)]` record, asserted at compile time, so the
syntax `Failure` and its path are untouched: primary span (the offending use), `related` (the
secondary span — the binder whose scope closed, or the definition header or first application that
fixed the arity), the code, and `found`/`expected` argument counts, which are 255 when the code is
not an arity mismatch. `SemanticFailure::as_failure` gives the compact view the existing `enrich`
renders, and the renderer gained arms for the five codes, including the secondary label text
("bound here, in a scope that has closed", "the arity is fixed here") and repair help.

### Data structures and limits

Tiger-style: plain data, explicit `#[repr(C)]`, asserted sizes, range-sized integers, no recursion
over the tree, no owned container in a hot record, no raw pointer, no `unsafe` at all in this
stage.

| Pool | Element | Size | Bound | Exhaustion |
|---|---|---|---|---|
| `symbols` | `Symbol` (spelling span, arity-fixing site, 16-bit hash filter, arity, flags) | 16 B | `Limits::symbols` | `SymbolCapacity` |
| `index` | `u32` slot, symbol id + 1, open-addressed, zero is empty | 4 B | twice `Limits::symbols`, rounded to a power of two | — |
| `binders` | `Symbol` | 16 B | `Limits::binders` | `SymbolCapacity` |
| `scopes` | `u32` binder-count mark | 4 B | `Limits::depth` | — |
| `visits` | `Visit` (node id, or a scope-close mark) | 8 B | `Limits::depth` | `AdmitDepthCapacity` |

`Limits` gained `symbols` and `binders`; the defaults are 16,384 and 256, and the bench driver uses
8,192 and 256. Every pool is reserved by `Workspace::new`. The index is the one pool that is
written rather than pushed, so its capacity is reserved without being touched and the first
admission on a workspace sizes and clears it inside that capacity — `Workspace::new` still touches
no page it reserves, which is what the `prepare-touch` cold-start stage measures.

Traversal is one explicit stack with no recursion over the node tree. Scope closing is a sentinel
entry on the same stack, so a binder scope ends exactly when its body is finished. Name comparison
is a 16-bit hash filter and then an explicit byte loop over the two spans rather than a slice
comparison, whose run-time length would lower to an out-of-line `memcmp` — the lesson the
punctuation report's candidate B paid for.

### Fixtures and the coverage manifest

Three tests in `tests/rel_frontend.rs`, all of them driving sources that **parse**, so that what
they exercise is admission and not syntax:

- `admission_binds_names_and_checks_declared_arity` admits eleven sources: recursion resolving to
  itself, a definition used before it is declared, varargs called with one argument and with none,
  an `x in domain` parameter, a builtin with its own abstraction binder, square-bracket partial
  application against a two-argument definition, a base relation used consistently, nested modules
  with symbols and spreads, the higher-order `def totals[T](prefix…, total) {…}` fixture, a
  qualified `def out:tag` header with a quantifier, and a bare top-level expression. It then
  asserts the summary record exactly: one definition, one base relation, three binders and three
  applications for the recursive path fixture.
- `admission_rejects_escaped_binders_and_wrong_arity_with_both_spans` checks five rejections and
  their spans: the escaped binder with its use site and its binder site and the rendered secondary
  label, an application contradicting a definition's declared arity with `found` 1 and `expected` 2
  and the definition's own offset as the secondary span, a base relation contradicting the first
  application that fixed it, an unrecognised binder-list element, and symbol-pool exhaustion under
  a two-symbol limit. It also asserts that a source which fails to parse carries no semantic code.
- `admission_is_deterministic_over_the_cohorts_and_does_not_allocate` admits the three well-formed
  512-definition cohorts, requires the same summary from a second run, and then drives parse and
  admit repeatedly over successes, a semantic failure and the two malformed cohorts, observing
  **zero allocations** and unchanged retained bytes.

The coverage manifest gained two families, `semantic_binding` and `semantic_arity`, each with what
the prototype does and what remains, plus a `semantic_admission_scope` field replacing the bare
`semantic_admission_implemented: false`. What is named as remaining, so it is not mistaken for
coverage: module-scoped visibility (a definition is currently visible to every body in the source),
module member tables and imports, module parameters treated as base relations rather than binders,
annotation vocabulary, a declared schema instead of free base names, arity through composition and
override, and everything about types, lowering and execution.

### Measurement: the cost budget for a new kernel

A new stage has no retained control, so the A/B requirement cannot bite on its first acceptance;
what PERFORMANCE.md requires instead is a recorded per-unit cost budget on a named workload, the
top symbols of a kernel-scoped profile, and the zero-allocation and call-free checks. Receipt
`analysis/rel-frontend/performance-v1-admit-49493a3.json`, seven interleaved rounds, all five
cohorts, CPU 5, the non-multiplexing event set, `--stages parse,admit`, with the phase-1 binary
`35f4484` as a control on the stages it has and `--control-skip admit` for the one it does not.

**The parse stage is unchanged by admission: ratio 1.00000 on every cohort and both variants**,
with zero-width intervals on four of them. That is the control on the claim that this work is a
separate boundary and not a change to parsing.

| Cohort | Parse | Parse + admit | Admit alone | Admit per source byte | Per token |
|---|---:|---:|---:|---:|---:|
| ascii           | 2,579,055 | 4,328,644 | **1,749,589** | **40.68** | **112.96** |
| unicode         | 8,759,356 | 10,737,287 | 1,977,930 | 31.96 | 126.65 |
| comment-string  | 1,435,005 | 1,998,702 | 563,697 | 8.59 | 122.30 |
| malformed-early | 1,153,751 | 1,153,754 | **3** | 0.00 | 0.00 |
| malformed-late  | 2,575,131 | 2,575,131 | **0** | 0.00 | 0.00 |

The malformed rows are the check that this is a real stage and not a stub with a zero-cost path: a
source whose parse fails never reaches admission, and the measured difference is three instructions
— the branch that decides that — rather than a stub's zero on a source that did admit.

Per unit on the ASCII cohort, which is the named workload: **1,749,589 instructions, 308,152
cycles and 93,505 nanoseconds per admission** of a 43,008-byte, 15,489-token, 12,288-node source
with 3,520 name references and 1,545 symbols. That is 40.68 instructions per source byte, 112.96
per token, 142.4 per node, 497 per resolved reference, and 2.17 nanoseconds per source byte.
Composed, parse and admit together are 100.65 instructions per source byte against parsing's 59.97.

**Admission is two thirds the cost of parsing, which is more than it should be**, and that belongs
in the headline of this measurement rather than in a footnote. It is the budget the next change is measured
against, and the ledger below names where to look first.

The admission pools also make `prepare` dearer: allocating and dropping a workspace is 5,791
instructions and 321 nanoseconds against 2,558 and 131 before, a ratio of 2.264, because five more
pools are reserved and released. Retained bytes go from 6,301,696 to 6,508,544 under the bench
limits — symbols 131,072, index 65,536, binders 4,096, scopes 2,048, visits 4,096. The previous
report's `prepare` and `prepare-touch` figures are superseded by that, and the reserve-without-
touching property is intact: the index is sized and cleared by the first admission, not by `new`.

### Profile, and every out-of-line call in the admit loop

`perf record -e instructions:u -F 4000`, ASCII cohort, byte scanner, 512 definitions, 2,000
iterations of the `admit` stage, pinned to CPU 7. The stage runs the scanner, the parser and
admission, so the admission symbols are read as a group.

| Symbol | Share of the parse + admit stage |
|---|---:|
| `parser::Parser::expression` | 30.31 % |
| `lexer::scan`                | 23.48 % |
| `admit::insert`              | 15.98 % |
| `admit::run`                 |  8.52 % |
| `admit::reference`           |  7.87 % |
| `admit::admit`               |  4.78 % |
| `lexer::keyword`             |  3.14 % |
| `admit::bind_list`           |  2.42 % |
| `parser::Parser::node`       |  1.08 % |
| `parser::Parser::item`       |  0.94 % |
| `admit::declare`             |  0.68 % |

The six admission symbols sum to 40.25 per cent, and the stage difference above puts admission at
40.4 per cent of the composed stage. The two methods agree to a sixth of a point, which is what
makes this profile usable as an attribution rather than a picture.

Out-of-line calls observed inside the admission traversal, listed as the contract requires:
`admit::reference`, `admit::insert`, `admit::bind_list` and `admit::declare`, each of which is this
stage's own code and none of which is libc. **No libc symbol appears inside the stage at any
threshold** — in particular the explicit byte loop in `same` did not lower to `memcmp` or `bcmp`,
which was the specific risk the punctuation report's candidate B established. The libc symbols in
the profile are `clock_gettime` at 0.06 per cent, which is the probe's own per-iteration timer, and
`_int_malloc`/`cfree` at 0.01 per cent, which are process startup.

One profile figure should not be read literally: `admit::insert`'s 15.98 per cent sits 66.5 per
cent on one instruction, the 16-byte `movups` that writes a `Symbol` into the pool. That is sample
skid onto a store, the same effect this lane has now seen three times, and it means the symbol's
share overstates the cost of inserting. The absolute stage difference, not the share, is the cost
this report stands behind.

### Zero allocation

`admission_is_deterministic_over_the_cohorts_and_does_not_allocate` drives parse and admit ten
times over all five cohorts — three that admit, two whose parse fails — plus a source that fails
admission, under the thread-local counting allocator, and observes **zero allocations** with
retained bytes unchanged. That covers the three paths the task required: success, semantic failure
and syntax failure. The stage's pools are reserved by `Workspace::new` and the index is resized
once, inside reserved capacity, on the first admission of a workspace.

### Native/WASM parity, and the new canonical hash

The parity corpus now carries an admission record for every case: admitted, with the six summary
counts; semantically rejected, with both spans, the two argument counts and the rendered
diagnostic; or not reached, because the parse failed. Both scanner variants must produce the same
admission outcome, which is asserted case by case. Eight admission fixtures were added — the
recursive path definition, varargs, an `in` restriction, a builtin abstraction, and the four
rejections.

That is why the canonical hash moves. It was
`5f707d3737b32071e0bebfca304ff1a5e2902fa0152937ddada60bd5aa194cc8` over 151 cases and 335,671
bytes; it is now
**`5a350e1f524b26da61186320414785045d9f39a71c4b34b40f9bd78d3516cbfa`** over 159 cases and 345,993
bytes, native and WASM byte-equal. Of the 159 cases, 27 are admitted, 4 are semantically rejected
and 128 never reach admission because their parse fails. No syntax outcome changed: the phase-1
commit regenerated the same `5f707d37…` hash, and only the admission record and the new fixtures
move it afterwards. The independent Python decoder was extended to decode the admission record and
still checks complete consumption and its four negative controls.
## Gates and replay

Run from `~/src/ergodis-private`. Every gate was run at the final `HEAD` (`32a18c6`) and passes.

| Gate | Command | Outcome |
|---|---|---|
| Frontend tests | `cargo test -p ergodis-private --test rel_frontend --test rel_frontend_portability -j 8` | 23 passed and 1 passed, 0 failed (20 before, plus the three admission tests) |
| Clippy, library and both test targets | `cargo clippy -p ergodis-private --lib --test rel_frontend --test rel_frontend_portability -j 8 -- -D warnings` | no diagnostics |
| Clippy, tools binary | `cargo clippy -p ergodis-tools --bins -j 8 -- -D warnings` | no diagnostics |
| Formatting | `rustfmt --check --edition 2021` on the six touched sources | clean; running it over the module tree also normalised the one pre-existing whitespace diff in `parser.rs` the previous report recorded |
| Native/WASM parity replay | `python3 analysis/rel-frontend/portability.py --output analysis/rel-frontend/portability-v1.json` | 159 cases, 345,993 canonical bytes, byte-equal, canonical SHA-256 `5a350e1f52…3516cbfa`; re-running at `HEAD` reproduces the receipt byte for byte |
| Allocation regressions | inside the test run | zero allocations over scan and parse, and over parse plus admit on success, semantic failure and syntax failure, with retained bytes unchanged |
| Driver fingerprint gate | armed on every measured operation of both A/B runs (no `--representation-change`) | equal tokens, nodes, failure **and admission outcome** against the control on every cohort and both variants |

The gates were run with the ambient toolchain (rustc 1.93.1) rather than under `nix shell
nixpkgs#rustc`, which is what the previous reports used and which now resolves to 1.95.0. That is a
deliberate deviation: the measured binaries are built by the ambient `cargo` through
`retain-bin.sh`, and running the tests under a different compiler than the measurement would mean
neither gate nor measurement describes one build.

Measurement replay, in order. `$CONTROL`, `$CANDIDATE` and `$ADMIT` are `ergodis-tools` retained at
`cfe4893`, `35f4484` and `49493a3`, each by `../ergodis-dev/scripts/retain-bin.sh tasks/tools
ergodis-tools` with that revision checked out.

```sh
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
python3 analysis/rel-frontend/bench.py --binary "$CANDIDATE" --control "$CONTROL" \
    --rounds 7 --cpu 5 --stages scan,parse,recover --events $E \
    --out analysis/rel-frontend/performance-v1-tokstore-35f4484.json
python3 analysis/rel-frontend/bench.py --binary "$CANDIDATE" --control "$CONTROL" \
    --rounds 7 --cpu 5 --cohorts ascii --stages scan,parse \
    --events instructions,cycles,cache-references,cache-misses,L1-dcache-loads,L1-dcache-load-misses \
    --out analysis/rel-frontend/performance-v1-tokstore-35f4484-cache.json
for b in cfe4893 35f4484; do
  python3 analysis/rel-frontend/scan-decompose.py --binary "$BIN_$b" --rounds 5 --cpu 5 \
      --out analysis/rel-frontend/performance-v1-scan-classes-$b.json
done
"$CANDIDATE" rel-frontend-bench --cohort ascii --stage scan --repeat 1 --dump-source ascii.txt
python3 analysis/rel-frontend/cohort-census.py ascii.txt \
    --classes analysis/rel-frontend/performance-v1-scan-classes-35f4484.json --measured 1154888
python3 analysis/rel-frontend/bench.py --binary "$ADMIT" --control "$CANDIDATE" \
    --control-skip admit --rounds 7 --cpu 5 --stages parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-49493a3.json
rustc -O --crate-type lib analysis/rel-frontend/token-store-probe.rs --emit asm -o probe.s
```

The profiles, for `cfe4893` and `35f4484` on the scan stage and `49493a3` on the admit stage:

```sh
perf record -q -e instructions:u -F 4000 -o scan-<rev>.data -- taskset -c 7 \
    "$BIN" rel-frontend-bench --cohort ascii --stage scan --variant byte \
    --definitions 512 --repeat 4000
perf record -q -e instructions:u -F 4000 -o admit-49493a3.data -- taskset -c 7 \
    "$ADMIT" rel-frontend-bench --cohort ascii --stage admit --variant byte \
    --definitions 512 --repeat 2000
perf report -i <data> --stdio -g none --percent-limit 0.0
```

## Mystery ledger

1. **Settled, and it reverses the question the task asked.** Whether the 16-byte token is cheaper
   written as one or two wide stores. It is not: two `u64` stores cost one instruction per token
   *more* than the five narrow ones, because assembling `start | end << 32` needs three arithmetic
   instructions, and a single 16-byte store needs a vector assembly that costs more again. Settled
   by a committed codegen probe compiled with the measured toolchain, before any A/B was spent.
   What the token store actually cost was its bookkeeping: two capacity tests and four reloaded
   workspace fields per token. Removing that is −5.00 instructions and −5.08 L1 data-cache loads
   per token, measured three ways that agree — the A/B, the class decomposition at both revisions,
   and the candidate's own disassembly.
2. **Settled, with a named one-instruction gap.** The Fermi predicted six instructions per token
   and 3.5 per cent of the ASCII parse stage; the measurement is 5.00 and 2.91 per cent. The gap is
   not model error: the compiler outlined the last store and the cursor increment into a block
   shared by the emit sites, so the fast path ends in a `jmp` to it. The prediction was off by
   exactly that `jmp`.
3. **Open, and it is the one result that does not fit.** The Unicode cohort saves 0.84 instructions
   per token where every other cohort and every synthetic token class saves exactly 5.00. The
   saving is real (ratio 0.9985) but seven times smaller than the mechanism predicts, and it
   reproduces in a separate run. The hypothesis is register pressure: the Unicode scan path decodes
   scalars with several live values already, and the cursor, base pointer and bound displace them,
   paying back about four instructions per token elsewhere in the same symbol. The evidence gap is
   one `perf annotate` of the Unicode scan stage on both builds, bucketed into the named address
   ranges of `scan-regions.py` re-read from each build's own disassembly, to see which region grew.
   Nothing rests on it: the cohort still wins, and the decision to keep does not depend on it.
4. **Open, small, and it is the one cohort that got worse.** The scalar variant on comment-string
   is 1.0024 on its scan stage, about 3,700 instructions per iteration, 0.81 per token against
   tokens that are mostly strings, while the same variant wins on the other four cohorts. The
   scalar variant is the experimental matched control, not a production path. The evidence gap is
   the same annotate diff as item 3, on the scalar monomorphization of the string path.
5. **Settled, and it is a fact worth keeping.** A packed token is free to read: the identity `match`
   from `u16` back to `Kind` that any packed representation needs compiles to nothing, so
   `packed.kind()` is the same two instructions as a plain field read. If a future change wants a
   packed representation for another reason — a smaller record, a parallel array — the read side
   will not cost it anything. The write side is where packing loses.
6. **Open, and it is the next candidate.** Admission costs 40.68 instructions per source byte on
   the ASCII cohort, two thirds of what parsing costs, 497 per resolved name reference. That is
   more than the shape of the work suggests: one hash, one short binder scan and one open-addressed
   probe per reference, over a table at nine per cent load. The profile does not answer it, because
   `admit::insert`'s 15.98 per cent share sits 66.5 per cent on a single 16-byte store, which is
   sample skid onto a store and the third time this lane has seen a profile share mislead. The
   evidence gap is a decomposition in the style of `scan-decompose.py`: synthetic sources with a
   controlled number of definitions, references and binders, solved for a per-reference, per-node
   and per-name-byte coefficient. One hint is already in hand — the Unicode cohort, which has the
   same node, reference and symbol counts but roughly double the name bytes, costs 228,341
   instructions more, which prices name hashing and comparison at about 12 instructions per name
   byte, so roughly 300,000 of the 1,749,589, or 17 per cent. The other 83 per cent is unattributed.
7. **Settled.** Whether the admission stage would pull a libc call into its loop, which is the
   defect the punctuation report's candidate B established. It does not: no libc symbol appears in
   the stage's profile at any threshold, and in particular the explicit byte loop in `same` did not
   lower to `memcmp` or `bcmp`. The out-of-line calls inside the traversal are this stage's own
   `reference`, `insert`, `bind_list` and `declare`.
8. **Open, and it strengthens an item already in the ledger.** Reserving the five admission pools
   makes `prepare` 2.26 times dearer, 5,791 instructions against 2,558, and the retained workspace
   6,508,544 bytes against 6,301,696. The earlier `prepare` and `prepare-touch` figures are
   superseded. The workspace-sizing question the last two reports carried — `Limits::default`
   reserves memory by a fixed bound whatever the input — now has a second constituency, because
   `Limits::symbols` is sized for the largest source rather than for this one, and the admission
   stage clears an index proportional to that bound on every admission.
9. **Not a mystery, stated because it is the design decision phase 2 turns on.** Free names are
   admitted as external base relations, because a Rel fragment reads database relations it does not
   declare and rejecting them would reject every realistic input. That is a one-sided policy: it
   never rejects a valid program and it can admit an invalid one. What keeps the binding check from
   being vacuous is that a spelling bound *somewhere in the definition being checked* is a variable
   for that whole definition, so using it outside its scope is `UnboundName`. If a declared schema
   ever exists, the policy should become a mode chosen outside the loop, never a per-node flag.

## Remaining next steps

1. **Decompose the admission stage before optimizing it** (ledger item 6). It has a cost budget and
   no baseline; the class-decomposition method has now beaten the profile-share method three times
   in this lane, so build the synthetic sources first and only then change code. The named
   suspects, in order, are the per-reference work in `reference`, the per-node dispatch in `run`,
   and the index clear, which is proportional to `Limits::symbols` and not to the source.
2. **Settle the Unicode anomaly** (ledger item 3) with one annotate diff, because it is the only
   place where the token-store mechanism does not reproduce and because the answer — if it is
   register pressure in the scalar decode path — would apply to any future change that adds live
   values to the scan loop.
3. **Size the workspace to the source.** Unchanged from the last two reports and now larger: the
   default workspace reserves 21 MB, the admission pools add their own bound, and the first
   admission clears an index sized by that bound. This is a design question to raise before it is
   built.
4. **Extend admission to module-scoped visibility**, which is the largest gap in what the manifest
   now claims: a definition is visible to every body in the source, including definitions in
   sibling modules that Rel would not resolve. The symbol table already carries each definition's
   node, and every node carries its enclosing module, so the check is an ancestor walk at
   resolution time.
5. **Then module parameters and member tables**, so `module M[R] … R(x,y)` binds `R` rather than
   admitting it as a base relation, and `M:member` resolves rather than being admitted unchecked.
6. **The out-of-sample cohort test for the scan class model** is still not done, unchanged from the
   previous report: predicting the comment-string cohort needs a `comment` synthetic class and a
   census classifier that understands comments and the three string forms.
7. **The 2 MiB-page question for the pools** is unchanged and untested; one A/B of `prepare-touch`
   with `madvise(MADV_HUGEPAGE)` would settle whether cold start halves.
8. The remaining syntax items are unchanged: caret entity references, string interpolation, and
   reference Unicode boundary conformance.

Cache hygiene, for the user's decision rather than mine: this task added three retained executables
in `~/.cache/ergodis/bin/` (`ergodis-tools-cfe4893`, `-35f4484`, `-49493a3`) and three `perf.data`
files under `~/.cache/ergodis/perf-c1170/`. None is cited as evidence; the receipts carry the
hashes, and nothing was written to `/tmp` beyond one dumped cohort source.

No backend or evaluator was adopted in this work and nothing was published.
