# C1170 — three priced optimizations to the semantic admission stage

**Lane**: `ergodis`
**Date**: 2026-09-14
**Repository**: `~/src/ergodis-private` (private, no public remote), branch `main`, from `45df44c`

**Control**: `ergodis-tools` built at revision `185015e` and retained as `ergodis-tools-185015e`
(retain recipe: `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at that revision).
Measured sha256 `59d8b1e622b912077d92f5b2eae159ea170942c642ddfa15ac36ea857783e249`, rustc 1.95.0
(59807616e 2026-04-14) read from the binary's `.comment` section, release profile, no features.
`git diff --stat 185015e 45df44c -- src/ tests/ tasks/` is empty, so the Rust sources this task
starts from are byte-identical to the ones the control was built from: the decomposition task
changed only scripts, receipts and documentation.

Every candidate is measured against a control retained at the revision the tree carried when that
candidate's work started, so each A/B isolates one change; the composed saving is one further A/B of
the final revision against `185015e`. Every build, test, Clippy run, retain and measurement in this
report ran under `nix develop ~/src/ergodis` (rustc 1.95.0, pinned through the core flake).

**Commits** (all on `main`, in order):

| Commit | Contents | Disposition |
|---|---|---|
| `7817627` | candidate 1: `insert` takes the caller's 32-bit hash instead of the span | **kept** |
| `065197e` | candidate 1's A/B receipt | — |
| `de35905` | candidate 2: a compile-time first-byte and length gate ahead of the `BUILTINS` walk, and its test | **kept** |
| `49bbb9a` | candidate 3: one node-pool scan, with the definition ids recorded in a bounded pool | **kept** |
| `6d27015` | candidates 2 and 3's receipts, the composed receipt, and the frontend README's admission-optimization section | — |

No candidate was reverted, so there is no instructive negative in this task; the negatives it does
carry are two mispriced Fermis, both explained in the ledger.

## Status

Complete, three candidates built and all three kept. **The ASCII admission stage is 0.7727
[0.772671, 0.772675] of the retained control `ergodis-tools-185015e`** — 1,347,415 instructions
against 1,743,837, a saving of 396,422 per admission of a 43,008-byte source. Unicode is 0.7778 and
comment-string 0.7028; the composed parse-plus-admit stage on ASCII is 0.9068. **The parse stage
measures 1.000000 in all four A/B runs**, so nothing about scanning or parsing moved, and the
admission difference and the stage ratio agree throughout.

The three ratios, measured one at a time against a control retained at the revision the tree then
carried, are 0.9525 (hash each name once), 0.8676 (the `BUILTINS` gate) and 0.9350 (one node-pool
scan). Their product is 0.77267 against the 0.77267 measured end to end: the changes do not
interact. The decomposition report projected 20.2 per cent for these three; the measured composed
saving is **22.7 per cent**.

Every gate passed: 24 frontend tests and 1 portability test, zero allocations, strict Clippy on the
library, both test targets and the tools binary, the native/WASM canonical hash unchanged at
`5a350e1f…` after every candidate, and the driver's output gate — equal tokens, nodes, failures,
**admission summaries** and representation fingerprints — armed on every operation of all four runs.
The one cost is `prepare`, which reserves one more pool and rises 12.7 per cent, 5,755 instructions
to 6,485, with retained bytes up 32,768 and peak RSS unchanged.

Two Fermis were materially wrong and both are diagnosed rather than fudged. Hashing once saved
47 per cent more than predicted, because removing the `&[u8]` argument made `insert` inlinable and
all 1,545 inserts stopped paying a call. The `BUILTINS` gate saved 31 per cent more than the
decomposition report's price, because that price came from a fitted coefficient that is joint with
the insert following it, while the compiled walk is 228 instructions per first sight — and the
unicode cohort, where the length test alone rejects every spelling, confirms the compiled reading to
0.02 per cent. **The lesson for the lane: the fitted model finds candidates and the disassembly
prices them — and a signature change must be priced for what it does to inlining, not only for the
instructions it removes from the loop.**

Vibe check: very good. Three for three, the savings compose exactly, the biggest remaining term —
the traversal's per-visit bookkeeping at roughly a quarter of what is left — is untouched and is the
obvious next move, and the two surprises both taught the lane something about its own cost model
rather than costing it a revert.

## Candidate 1 — hash each name once

### Fermi, written before the change

The decomposition report prices this at 5.6 per cent, from "1,545 re-hashed spellings, 12,320
bytes at 7.90 instructions per byte". **That price is too high by a factor of 1.7, and the
correction was made before implementing.** `insert` has two callers. `reference` computes the full
32-bit hash of the spelling — it needs it to filter the binder scan and to index the open-addressed
probe — and then hands `insert` only the span, so those inserts genuinely hash twice. `declare`
never hashes: its insert is the only hash of that spelling, so moving the hash into `declare`
relocates work rather than removing it.

Splitting the census by caller (the committed `admit-census.py`, with `insert` wrapped to record its
caller; the totals reproduce the report's 1,545 inserts and 25,477 hashed bytes):

| Cohort | inserts from `declare` | its bytes | inserts from `reference` | its bytes |
|---|---:|---:|---:|---:|
| ascii | 640 | 5,176 | 905 | **7,144** |
| unicode | 640 | 9,848 | 905 | **14,853** |
| comment-string | 512 | 3,474 | 384 | **3,119** |

Only the `reference` column is removable. At the fitted 7.90 instructions per hashed byte that is
**7,144 × 7.90 = 56,400 instructions, 3.2 per cent** of the ASCII cohort's measured 1,743,823.
Read the other way — the FNV body is seven instructions per byte and the loop's entry and exit are
about five per call, amortized in the fitted coefficient over an average 4.3-byte name while these
names average 7.9 bytes — the prediction is 7,144 × 7 + 905 × 5 = **54,500, 3.1 per cent**. The
Fermi is therefore **3.1 to 3.2 per cent on ASCII**, and by the same arithmetic 6.0 per cent on
unicode (14,853 bytes against a 1,972,176-instruction stage) and 4.4 per cent on comment-string.

### What was built, commit `7817627`

`insert(w, source, symbol)` becomes `insert(w, hash, symbol)`. `reference` passes the hash it
already has; `declare` computes `hash_of` at the call site. No new state, no new pool, no change to
what is admitted or rejected.

The compiled shape confirms the count. Admission's out-of-line symbols in the control are `run`
(425 instructions), `admit` (277), `insert` (84), `declare` (162), `bind_list` (332) and `reference`
(360). In the candidate **`insert` has no symbol at all**: it is inlined into its two callers,
which grow to `declare` 233 (+71) and `reference` 407 (+47). Counting the FNV multiply
`imul $0x1000193`, which appears exactly once per hash loop, the control has one in `insert` and one
in `reference`; the candidate has one in `declare` and one in `reference`. A first sight therefore
runs one hash loop where it ran two.

### A/B, candidate `7817627` over control `185015e`

Seven interleaved rounds, all five cohorts, both scanner variants, `--stages parse,admit`, CPU 5,
event set `instructions,cycles,branches,branch-misses,page-faults,minor-faults` at 100 per cent
enabled, fingerprint gate armed. One-minute load average 8.12 before the run and 1.62 after; the
box is shared, so cycle ratios are wide and instruction ratios decide. Receipt
`analysis/rel-frontend/performance-v1-admit-hash-once-7817627.json`.

**The A/A instruction nulls are 1.000000 on all five cohorts**, intervals within six parts per
million of unity, so the protocol carries the effect.

**The parse stage is 1.000000 on every cohort and both variants** — no ThinLTO shift this time, so
the stage ratios are readable directly and the admission difference and the stage ratio agree.

| Operation | candidate | control | ratio |
|---|---:|---:|---:|
| ascii/parse/byte | 2,507,822 | 2,507,823 | 1.000000 |
| ascii/parse/scalar | 3,868,241 | 3,868,241 | 1.000000 |
| ascii/admit/byte | 4,168,829 | 4,251,648 | **0.980521** |
| ascii/admit/scalar | 5,529,245 | 5,612,066 | 0.985242 |
| unicode/parse/byte | 8,733,246 | 8,733,248 | 1.000000 |
| unicode/admit/byte | 10,560,958 | 10,705,419 | 0.986506 |
| unicode/admit/scalar | 11,377,719 | 11,522,185 | 0.987462 |
| comment-string/parse/byte | 1,401,985 | 1,401,983 | 1.000002 |
| comment-string/admit/byte | 1,919,548 | 1,962,742 | 0.977993 |
| comment-string/admit/scalar | 2,417,163 | 2,460,361 | 0.982442 |
| malformed-early/admit/byte | 1,098,186 | 1,098,180 | 1.000005 |
| malformed-late/admit/byte | 2,504,017 | 2,504,016 | 1.000001 |
| prepare | 5,764 | 5,767 | 0.999491 |

Admission alone, as `admit` minus `parse` on the same cohort and variant:

| Cohort / variant | candidate | control | ratio | saved |
|---|---:|---:|---:|---:|
| ascii / byte | 1,661,006 | 1,743,825 | **0.9525** | 82,819 |
| ascii / scalar | 1,661,004 | 1,743,825 | 0.9525 | 82,821 |
| unicode / byte | 1,827,713 | 1,972,172 | 0.9268 | 144,459 |
| unicode / scalar | 1,827,710 | 1,972,178 | 0.9267 | 144,469 |
| comment-string / byte | 517,563 | 560,759 | 0.9230 | 43,197 |
| comment-string / scalar | 517,552 | 560,749 | 0.9230 | 43,196 |
| malformed-early | 4 | 1 | — | — |
| malformed-late | −6 | −8 | — | — |

The malformed cohorts are the control on the claim that this is a real stage: their admission
difference is a handful of instructions either way, which is the branch that decides a failed parse
never reaches admission, and it is unchanged.

### The measurement exceeded the Fermi by half, and the mechanism is the inlined call

Predicted 54,500 to 56,400 instructions on ASCII; measured **82,819**. That is 47 per cent more
than the top of the predicted range, which is material, so it is explained rather than accepted.

The Fermi priced the removed hash loop and nothing else. What the change also did was make `insert`
small enough to inline: with the `source: &[u8]` argument and the hash loop gone, `insert` has no
symbol of its own in the candidate binary. The control's `insert` opens with five `push`
instructions and closes with five `pop`s, plus the `call` and the `ret` and the argument setup that
materializes the `Symbol` for a by-pointer argument — on the order of eighteen instructions per
insert that the candidate does not execute, over **all** 1,545 inserts, not only the 905 that
re-hashed.

Solving the three cohorts for two coefficients — per re-hashed byte, and per insert — closes:

| Cohort | re-hashed bytes | inserts | measured saving |
|---|---:|---:|---:|
| ascii | 7,144 | 1,545 | 82,819 |
| unicode | 14,853 | 1,545 | 144,459 |
| comment-string | 3,119 | 896 | 43,197 |

The two cohorts with identical insert counts give **7.996 instructions per re-hashed byte** — which
is the fitted hash coefficient of 7.90 recovered independently, from a difference of measurements
rather than from the fit — and **16.6 instructions per insert** for the call that is no longer made.
Predicting comment-string from those two coefficients gives 39,840 against 43,197 measured, 8 per
cent low, which is the limit of a two-parameter fit over three points when one cohort has a
different mix of `declare` and `reference` inserts.

**Disposition: kept**, commit `7817627`. The ASCII admission stage falls to **0.9525** of the
control, 4.75 per cent, against a 3.1 to 3.2 per cent Fermi; unicode to 0.9268 and comment-string to
0.9230. Retained as `ergodis-tools-7817627`, measured sha256
`dd09841e345fe6b3cad95a9353dff4c6ef16c63e34c47124a6de3b6f53cf16cb`, rustc 1.95.0, and that binary is
the control for candidate 2.

## Candidate 2 — a first-byte and length gate on the `BUILTINS` walk

### Fermi, written before the change

The decomposition report prices this at 9.1 per cent, from 905 first sights × about 175
instructions. **Reading the compiled walk puts it higher**, and the Fermi is written from the
disassembly rather than from the fitted coefficient, because the fit's `first_sight` unit is joint
with the insert that always follows it.

The walk, as `reference` compiles it in `ergodis-tools-7817627`, is seven instructions per
iteration when the candidate's length does not match:

```text
mov    %rcx,%r8               ; i
shl    $0x4,%r8               ; × 16, the &str stride
cmp    %rdx,0x8(%r8,%r14,1)   ; candidate.len() == length
jne    <next>
inc    %rcx
cmp    $0x20,%rcx             ; all 32 entries
je     <exit>
```

A name that is not a builtin runs all 32 iterations: 224 instructions, plus about four of loop
entry. On top of that, an iteration whose length *does* match costs about ten more — the pointer
load, the byte-loop entry and the first compared byte. The `BUILTINS` lengths are 3 (eight
entries), 4 (five), 5 (six), 6 (seven), 7 (five) and 9 (one), and the ASCII cohort's 905 first
sights have the length histogram {1: 2, 3: 2, 5: 10, 6: 70, 7: 339, 8: 160, 9: 259, 10: 11,
11: 52}, so 2,520 of the 28,928 iterations take the length-match path. The walk is therefore
**905 × 228 + 2,520 × 10 ≈ 231,000 instructions**, and a conservative reading of the same numbers
is 199,000: **12 to 14 per cent of the post-candidate-1 ASCII stage of 1,661,006**, against the
report's 9.1 per cent of the pre-candidate-1 stage.

The replacement is a compile-time table derived from `BUILTINS`: for each possible first byte, a
16-bit mask of the lengths of the builtins beginning with that byte. The gate is one unsigned
compare that rejects a length outside 1..=15, one byte load, one table load, one variable shift and
one test — **about nine instructions**. Evaluating that gate over the cohort's actual first-sight
spellings (the committed census, with `insert` wrapped to collect them) says it rejects **836 of
905 on ASCII, 903 of 905 on unicode and all 384 on comment-string**; the 69 ASCII survivors are
spellings like `age` (against `abs`) and `base14` (against `bottom`), which a per-first-byte range
into a sorted index sends to one or two byte comparisons rather than to 32 length tests.

**Predicted saving on ASCII: 905 × 228 + 25,200 − (836 × 9 + 69 × 30) ≈ 189,000 instructions,
11.4 per cent** of 1,661,006, with a plausible range of 10 to 12 per cent. On unicode, where the
spellings are long enough that the length test alone rejects 903 of 905, the same ≈ 199,000
instructions is 10.9 per cent of 1,827,713; on comment-string ≈ 84,000 is 16.3 per cent of 517,563.

### What was built, commit `de35905`

Three `const` tables, all derived from `BUILTINS` itself so that adding an entry updates the gate
and nothing is hand-maintained:

- `BUILTIN_LENGTHS: [u16; 256]` — for each possible first byte, one bit per length of the entries
  beginning with that byte. A `const` assertion inside the table's own initializer rejects an empty
  entry or one longer than `BUILTIN_MAX_LEN = 15` at compile time, so an entry can never escape the
  gate by being unrepresentable.
- `BUILTIN_ORDER: [u8; 32]` — the entries' indices sorted by first byte and then by length, by an
  insertion sort in the `const` initializer.
- `BUILTIN_RANGE: [(u8, u8); 256]` — the half-open range of `BUILTIN_ORDER` for each first byte.

`is_builtin` rejects a length outside `1..=15` with one unsigned compare on the wrapped length,
then tests the first byte's length mask, then compares only the entries sharing that first byte,
starting at the second byte because the first matched by construction.

**The gate is exact, not a filter with a fallback**, and the argument is structural: the entries
sharing a first byte are contiguous in `BUILTIN_ORDER`, so every entry the 32-entry walk would have
compared is still compared and no other; an entry with a different first byte would have failed the
old byte loop at `j = 0`. `BUILTINS` has no duplicate spelling, so order within a group cannot
change an answer.

The compiled gate in `admit::reference` is what the Fermi assumed:

```text
cmp    $0xfffffffffffffff1,%rcx   ; length − 1 ≥ 15 → not a builtin
movzbl (%r10,%rdi,1),%ecx         ; source[start]
lea    <BUILTIN_LENGTHS>,%rdx
movzwl (%rdx,%rcx,2),%edx         ; the first byte's length mask
bt     %r9d,%edx                  ; the bit for this length
jae    <not a builtin>
```

Six instructions from the byte load to the rejecting branch, seven including the length compare,
against 228 for the walk it replaces. `reference` grows from 407 to 474 instructions and `insert`
stays inlined; no other admission symbol changes.

New test `admission_recognises_every_builtin_and_rejects_near_misses` admits `def probe = <name>`
for every one of the 32 entries and requires the symbol to carry `S_BUILTIN` and the admission to
report no base relation, then requires three near misses of each entry — one byte longer, one byte
shorter, and the same length with a different first byte, 96 sources in all — to be admitted as
external base relations instead. The frontend test target goes from 23 tests to 24.

### A/B, candidate `de35905` over control `7817627`

Same protocol: seven interleaved rounds, five cohorts, both variants, `--stages parse,admit`,
CPU 5, the non-multiplexing event set at 100 per cent enabled, fingerprint gate armed. Load average
3.88 before and 3.32 after. Receipt
`analysis/rel-frontend/performance-v1-admit-builtin-gate-de35905.json`. A/A instruction nulls are
0.999999 to 1.000000 on every cohort; **the parse stage is 1.000000 on every cohort and both
variants**.

| Operation | candidate | control | ratio |
|---|---:|---:|---:|
| ascii/parse/byte | 2,507,814 | 2,507,814 | 1.000000 |
| ascii/admit/byte | 3,948,930 | 4,168,826 | **0.947252** |
| ascii/admit/scalar | 5,309,338 | 5,529,235 | 0.960230 |
| unicode/parse/byte | 8,733,236 | 8,733,232 | 1.000000 |
| unicode/admit/byte | 10,361,879 | 10,560,939 | 0.981151 |
| unicode/admit/scalar | 11,178,642 | 11,377,701 | 0.982504 |
| comment-string/parse/byte | 1,401,976 | 1,401,973 | 1.000002 |
| comment-string/admit/byte | 1,820,663 | 1,919,537 | 0.948490 |
| comment-string/admit/scalar | 2,318,290 | 2,417,161 | 0.959096 |
| malformed-early/admit/byte | 1,098,168 | 1,098,173 | 0.999995 |
| malformed-late/admit/byte | 2,504,008 | 2,504,007 | 1.000001 |
| prepare | 5,753 | 5,757 | 0.999245 |

Admission alone:

| Cohort / variant | candidate | control | ratio | saved |
|---|---:|---:|---:|---:|
| ascii / byte | 1,441,116 | 1,661,012 | **0.8676** | 219,897 |
| ascii / scalar | 1,441,107 | 1,661,005 | 0.8676 | 219,897 |
| unicode / byte | 1,628,643 | 1,827,707 | 0.8911 | 199,064 |
| unicode / scalar | 1,628,645 | 1,827,703 | 0.8911 | 199,057 |
| comment-string / byte | 418,687 | 517,564 | 0.8090 | 98,877 |
| comment-string / scalar | 418,689 | 517,560 | 0.8090 | 98,871 |
| malformed-early / malformed-late | 3 | 3 | — | — |

### The Fermi closes on the unicode cohort to 0.02 per cent

The headline prediction of 189,000 on ASCII was 14 per cent low against the measured 219,897, and
the reason is inside the Fermi's own stated range: it split the difference between a 199,000 and a
231,000 reading of the walk, and the higher reading — 228 instructions of length tests for a
32-entry walk plus ten more for each of the 2,520 iterations that take the length-match path — is
the one the measurement picks.

Per cohort, predicting the saving as (first sights × 228) + (length-matched iterations × 10) −
(gate cost), with the length histograms taken from the census:

| Cohort | first sights | length-matched iterations | predicted saving | measured | residual |
|---|---:|---:|---:|---:|---:|
| ascii | 905 | 2,520 | 223,100 | 219,897 | +1.5 % |
| unicode | 905 | 0 | 199,100 | 199,064 | **+0.02 %** |
| comment-string | 384 | 1,378 | 101,300 | 98,877 | +2.4 % |

The unicode cohort is the clean case: every spelling is long enough that the length compare alone
rejects it, so the prediction is 905 × (228 − 8) with nothing else in it, and it lands within
36 instructions of 199,064. That is the strongest check in this report that the compiled-code
reading, not the fitted `first_sight` coefficient, is what prices this kind of change: the
decomposition report's 9.1 per cent would have been 151,000 instructions, 31 per cent low.

**Disposition: kept**, commit `de35905`. The ASCII admission stage falls to **0.8676** of the
post-candidate-1 control, 13.2 per cent, against an 11.4 per cent Fermi. Retained as
`ergodis-tools-de35905`, measured sha256
`055272bd1fc6d6e2d71ca96b6d0178e63abb69b6dac212b07fa88def74aa2836`, rustc 1.95.0, and that binary is
the control for candidate 3.

## Candidate 3 — drop the second node-pool scan

### Fermi, written before the change

`admit` scans the whole node pool twice: pass one matches every node's kind to declare definitions
and modules, pass two matches every node's kind again to find the definitions whose bodies to check.
The decomposition report reads eight instructions per node off pass two's compiled loop — a counter
test, a second bound test against `nodes.len()`, an increment, a 16-bit kind compare, a pointer
bump and the loop branch — and the ASCII cohort has 12,288 pool nodes, so **pass two is about
98,300 instructions**.

Replacing it means remembering in pass one which nodes were definitions. The symbol table does not
carry the node id: `declare` stores `site: item.start`, the definition's byte offset, which the
arity-mismatch diagnostic uses as its secondary span, so recovering an id from it is not possible
without a second map. A bounded pool of definition ids is therefore the shape, `Limits::symbols`
u32 entries, which is a valid bound because every declared definition also consumes a symbol slot
and exhausting that is `SymbolCapacity`.

Cost of the replacement: one bounds-tested push per definition in pass one, about five instructions
over 576 definitions (2,900), and pass two becomes a walk of 576 ids at about six instructions each
(3,500). **Predicted saving: 98,300 − 6,400 ≈ 92,000 instructions, 6.4 per cent** of the
post-candidate-2 ASCII stage of 1,441,116. On comment-string, 3,584 pool nodes and 512 definitions:
28,700 − 5,600 ≈ 23,000, 5.5 per cent of 418,687. On unicode, 12,416 nodes and 576 definitions:
99,300 − 6,400 ≈ 93,000, 5.7 per cent of 1,628,643.

The costs this change adds outside the loop, to be read in the receipt rather than assumed: one more
`try_reserve_exact` in `Workspace::new`, and 32,768 more retained bytes under the bench limits
(`symbols` 8,192), which is a 0.5 per cent increase on 6,508,544. `prepare` is measured in every A/B
and its ratio is the check on both.

### What was built, commit `49bbb9a`

`Workspace` gains one pool, `definitions: Vec<u32>`, reserved to `Limits::symbols` by
`Workspace::new`, counted in `retained_bytes`, filled by `Workspace::touch` like every other pool,
and cleared at the start of each admission. The declaring scan pushes each `Definition` node's id;
the body checks walk that pool by position.

**Source order is preserved by construction**: ids are pushed in ascending id, which is the order
the second scan visited them in, so the first failure in source order is the same failure. Sources
with modules are unaffected, because a `Definition` node inside a module is still a `Definition`
node in the pool and the one scan still sees it; the bare-expression path is unaffected, because it
triggers on `bodies == 0`, which is now the pool's length.

**The push cannot grow the pool**: `declare` runs first and takes a symbol slot, failing with
`SymbolCapacity` when there is none, so the number of recorded definitions never exceeds
`Limits::symbols`, which is the reserved capacity. The zero-allocation regression is what holds that
in place — the `RawVec::grow_one` call the compiler emits for the push is a cold path that the test
would catch executing.

The compiled scan is unchanged at ten instructions per non-matching node, and the second scan is
gone. Recording a definition is five instructions plus the push's capacity test:

```text
mov    0x98(%r14),%rax         ; definitions base
mov    %r15d,(%rax,%r12,4)     ; the node id
inc    %r12
mov    %r12,0xa0(%r14)         ; length written back
```

and the body walk that replaced the second scan is about eight instructions per definition. One
further compiled change came free: `admit::admit` no longer has a symbol of its own — with one loop
instead of two it is inlined into `Workspace::admit` — so the admission symbols are now `run`,
`reference`, `declare`, `bind_list` and `Workspace::admit`.

### A/B, candidate `49bbb9a` over control `de35905`

Same protocol. Load average 3.82 before and 2.43 after. Receipt
`analysis/rel-frontend/performance-v1-admit-one-scan-49bbb9a.json`. A/A nulls at unity; **parse
1.000000 on every cohort and both variants**.

| Operation | candidate | control | ratio |
|---|---:|---:|---:|
| ascii/parse/byte | 2,507,821 | 2,507,822 | 1.000000 |
| ascii/admit/byte | 3,855,227 | 3,948,927 | **0.976272** |
| ascii/admit/scalar | 5,215,637 | 5,309,341 | 0.982351 |
| unicode/admit/byte | 10,267,166 | 10,361,892 | 0.990858 |
| comment-string/admit/byte | 1,796,073 | 1,820,661 | 0.986495 |
| malformed-early/admit/byte | 1,098,164 | 1,098,167 | 0.999998 |
| malformed-late/admit/byte | 2,504,008 | 2,504,009 | 1.000000 |
| prepare | 6,491 | 5,757 | **1.127443** |

Admission alone, and the Fermi beside it:

| Cohort / variant | candidate | control | ratio | saved | predicted |
|---|---:|---:|---:|---:|---:|
| ascii / byte | 1,347,406 | 1,441,105 | **0.9350** | 93,699 | 92,000 |
| ascii / scalar | 1,347,406 | 1,441,108 | 0.9350 | 93,702 | — |
| unicode / byte | 1,533,928 | 1,628,657 | 0.9418 | 94,729 | 93,000 |
| comment-string / byte | 394,113 | 418,694 | 0.9413 | 24,581 | 23,000 |

**The Fermi closes on all three cohorts to within 2 per cent**, which is the expected accuracy of a
prediction read straight off a compiled loop body times a counted node population. This is the
candidate whose price the decomposition report got right, because pass two's cost is a pure
per-node term with nothing joint in it.

`prepare` rises exactly as predicted: 5,757 to 6,491 instructions, ratio 1.1274 [1.1259, 1.1289],
which is 734 instructions to reserve and release one more pool. Retained bytes go from 6,508,544 to
6,541,312, exactly the 32,768 the pool adds, and peak RSS is unchanged at about 6.0 MiB because the
reservation is never touched.

**Disposition: kept**, commit `49bbb9a`. Retained as `ergodis-tools-49bbb9a`, measured sha256
`06f946d59fc73657a799c4c9e8182aca0c64b82bc2186fd9e86768c739636c7a`, rustc 1.95.0.

## The composed saving, `49bbb9a` against the original control `185015e`

A fourth A/B of the final revision against the control this task started from, same protocol, load
average 1.97 before and 2.57 after. Receipt
`analysis/rel-frontend/performance-v1-admit-composed-49bbb9a.json`.

| Operation | candidate | control | ratio |
|---|---:|---:|---:|
| ascii/parse/byte | 2,507,813 | 2,507,810 | 1.000001 |
| ascii/parse/scalar | 3,868,232 | 3,868,231 | 1.000000 |
| ascii/admit/byte | 3,855,228 | 4,251,647 | **0.906761** |
| ascii/admit/scalar | 5,215,637 | 5,612,056 | 0.929363 |
| unicode/parse/byte | 8,733,237 | 8,733,233 | 1.000001 |
| unicode/admit/byte | 10,267,164 | 10,705,412 | 0.959063 |
| comment-string/parse/byte | 1,401,964 | 1,401,970 | 0.999996 |
| comment-string/admit/byte | 1,796,069 | 1,962,728 | 0.915088 |
| malformed-early/admit/byte | 1,098,165 | 1,098,173 | 0.999993 |
| malformed-late/admit/byte | 2,504,008 | 2,504,007 | 1.000001 |
| prepare | 6,485 | 5,755 | 1.126734 |

Admission alone, with the interval from the round-to-round standard deviations of the two stages:

| Cohort | candidate | control | ratio | interval |
|---|---:|---:|---:|---|
| ascii | 1,347,415 | 1,743,837 | **0.7727** | [0.772671, 0.772675] |
| unicode | 1,533,927 | 1,972,180 | 0.7778 | [0.777780, 0.777786] |
| comment-string | 394,105 | 560,758 | 0.7028 | [0.702781, 0.702834] |

**The three candidates' savings multiply exactly**: 0.9525 × 0.8676 × 0.9350 = 0.772674 against the
0.772673 measured end to end, one part per million apart. Carried to six figures the per-candidate
ratios are 0.952507, 0.867613 and 0.934981 and their product is 0.772675, three parts per million
from the measurement. That is the check that each A/B isolated its own change and that
nothing in one candidate re-priced another. The decomposition report projected 20.2 per cent for
these three; the measured composed saving is **22.7 per cent of the admission stage**, and 9.3 per
cent of the composed parse-plus-admit stage on ASCII.

In absolute terms the ASCII admission stage is 396,422 instructions cheaper per admission of a
43,008-byte source: **31.33 instructions per source byte against 40.55**, 87.0 per token against
112.6, and 383 per resolved name reference against 495.

## Kernel-scoped profile at `49bbb9a`, and every out-of-line call in the stage

`perf record -q -e instructions:u -F 4000`, ASCII cohort, byte scanner, 512 definitions, 20,000
iterations of the `admit` stage, pinned to CPU 7, under the pinned toolchain.
`~/.cache/ergodis/perf-c1170/admit-49bbb9a.data`, 1,051,712 bytes.

| Symbol | Share of the parse + admit stage |
|---|---:|
| `parser::Parser::expression` | 33.74 % |
| `Workspace::scan_variant` | 24.93 % |
| `admit::run` | 12.52 % |
| `admit::reference` | 11.13 % |
| `admit::declare` | 4.41 % |
| `Workspace::admit` | 3.83 % |
| `lexer::keyword` | 3.04 % |
| `admit::bind_list` | 2.83 % |
| `parser::Parser::item` | 1.78 % |
| `parser::Parser::node` | 0.81 % |
| `core::str::converts::from_utf8` | 0.49 % |
| `parser::parse` | 0.40 % |
| libc `__memset_avx512_unaligned_erms` | **0.06 %** |

The five admission symbols sum to 34.72 per cent; the stage difference puts admission at 1,347,415
of 3,855,228, which is 34.95 per cent. The two methods agree to 0.23 of a point.

**Every out-of-line call in the stage, read from the disassembly rather than from the profile's
resolution**, with where each sits:

| Call | Where | On the common path |
|---|---|---|
| `admit::reference` | two sites inside the traversal loop in `admit::run` | yes, once per name reference |
| `admit::bind_list` | one site inside the traversal loop (the relational-abstraction arm), one in `check_definition` | yes |
| `admit::run` | two sites in `Workspace::admit`, outside every loop | once per definition body and once for a bare expression |
| `admit::declare` | two sites in the node-pool scan in `Workspace::admit` | once per definition or module; outside the traversal |
| libc `memset` | two sites in `Workspace::admit`, the index clear and the resize path | yes, once per admission, outside the node loop; 0.06 per cent |
| `core::panicking::panic_bounds_check` | 8 sites in `run`, 12 in `reference`, 6 in `declare`, 8 in `bind_list`, 6 in `Workspace::admit` | no — cold slow paths |
| `alloc::raw_vec::RawVec::grow_one` | 6 sites in `run`, 1 in `reference`, 1 in `declare`, 4 in `bind_list`, 3 in `Workspace::admit` | no — every pool is bounded before the push, and the zero-allocation regression observes none of them executing |
| `RawVecInner::reserve::do_reserve_and_handle` | one site in `Workspace::admit`, the index's first sizing | once per workspace, inside reserved capacity |

`insert`, `hash_of`, `same`, `is_builtin`, `compatible`, `count_arguments`, `bind`, `bind_one`,
`check_definition` and `push` are all inlined and have no symbol of their own. **No libc call is
inside a loop**: the one libc symbol in the stage is the index clear's `memset`, which is a bulk
operation outside the node loop, unchanged by this task and measured at a tenth of the per-cent it
was measured at before.

The new `BUILTINS` tables add 1,280 bytes of read-only data — 512 for `BUILTIN_LENGTHS`, 512 for
`BUILTIN_RANGE`, 32 for `BUILTIN_ORDER`, and the 32 `&str` entries that were already there. Two
cache lines of it are touched per first sight, against the 512 bytes of `&str` headers the linear
walk streamed.

## Gates

Run from `~/src/ergodis-private`, every one under `nix develop ~/src/ergodis` (rustc 1.95.0), and
every one at each of the three candidates unless the row says otherwise.

| Gate | Command | Outcome |
|---|---|---|
| Frontend tests | `cargo test --release -p ergodis-private --test rel_frontend --test rel_frontend_portability -j 4` | 23 + 1 passed at `7817627`; **24 + 1** passed at `de35905` and `49bbb9a`, 0 failed |
| Zero allocation | inside that test run | `admission_is_deterministic_over_the_cohorts_and_does_not_allocate` observes zero allocations and unchanged retained bytes over ten rounds of all five cohorts plus a semantic failure |
| Clippy, library and both test targets | `cargo clippy --release -p ergodis-private --lib --test rel_frontend --test rel_frontend_portability -j 4 -- -D warnings` | no diagnostics |
| Clippy, tools binary | `cargo clippy --release -p ergodis-tools --bins -j 4 -- -D warnings` | no diagnostics |
| Formatting | `rustfmt --check --edition 2021` on `src/rel_frontend/admit.rs`, `src/rel_frontend/mod.rs`, `tests/rel_frontend.rs` | clean on every touched region — see the note below |
| Native/WASM parity replay | `python3 analysis/rel-frontend/portability.py --output analysis/rel-frontend/portability-v1.json` | 159 cases, 345,993 canonical bytes, byte-equal; canonical SHA-256 **`5a350e1f524b26da61186320414785045d9f39a71c4b34b40f9bd78d3516cbfa` unchanged at every candidate**, so no admission outcome moved |
| Driver output gate | armed on every operation of all four A/B runs (no `--representation-change`) | equal tokens, nodes, failure, **admission summary** and representation fingerprint against the control on every cohort and both variants; `bench.py` raises rather than writing a receipt if any differ |
| Event set | `instructions,cycles,branches,branch-misses,page-faults,minor-faults` | 100.00 per cent enabled on all six, measured directly with `perf stat -x,` on the admit stage at `49bbb9a` |
| Parse-stage parity | inside each A/B | 1.000000 on every cohort and both variants in all four runs; no ThinLTO shift of the scanner or parser this time |
| A/A null | inside each A/B | 0.999993 to 1.000004 per cohort, every interval within sixteen parts per million of unity |

**One formatting note, stated rather than glossed.** Run inside the repository, `rustfmt --check`
reports two diffs in `tests/rel_frontend.rs` at lines 702 and 714, which are not lines this task
touched. They are pre-existing: checking out the file at `7817627` to the same path reproduces
exactly the same two diffs, and the same file checked outside the repository reports none, so the
difference is `rustfmt`'s configuration discovery inside the package and not this task's edits.
Nothing in this task's touched regions is unformatted.

## Replay

`$C0`, `$C1`, `$C2` and `$C3` are `ergodis-tools` retained by
`../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at `185015e`, `7817627`,
`de35905` and `49bbb9a` respectively, each with that revision checked out. The script re-executes
itself under `nix develop ~/src/ergodis`, so all four arms share the pinned rustc 1.95.0.

```sh
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
python3 analysis/rel-frontend/bench.py --binary "$C1" --control "$C0" \
    --rounds 7 --cpu 5 --stages parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-hash-once-7817627.json
python3 analysis/rel-frontend/bench.py --binary "$C2" --control "$C1" \
    --rounds 7 --cpu 5 --stages parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-builtin-gate-de35905.json
python3 analysis/rel-frontend/bench.py --binary "$C3" --control "$C2" \
    --rounds 7 --cpu 5 --stages parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-one-scan-49bbb9a.json
python3 analysis/rel-frontend/bench.py --binary "$C3" --control "$C0" \
    --rounds 7 --cpu 5 --stages parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-composed-49bbb9a.json
perf record -q -e instructions:u -F 4000 -o ~/.cache/ergodis/perf-c1170/admit-49bbb9a.data \
    -- taskset -c 7 "$C3" rel-frontend-bench --cohort ascii --stage admit --variant byte \
    --definitions 512 --repeat 20000
perf report -i ~/.cache/ergodis/perf-c1170/admit-49bbb9a.data --stdio -g none --percent-limit 0.0
```

The first-sight spellings and their gate outcomes, which the candidate-2 Fermi rests on, come from
the committed census with `insert` wrapped to record its caller; that wrapper was a read-only
scratch script and is not part of the evidence, because the claim it supports — 836 of 905 rejected
— is checked by the measurement it predicted to 1.5 per cent.

## Foreign tree

The repository carries uncommitted files belonging to other work: the campaign-console mockups and
interface-review material under `analysis/`, `packages/execution-provider/src/lib.rs`,
`packages/hadamard-provider/tests/contracts.rs`,
`packages/parameterization-provider/tests/contracts.rs`, `src/hadamard_execution.rs`,
`src/partitioned_additive_join.rs`, `tests/partitioned_join_profile.rs` and
`tests/quadratic_residual_profile.rs`. Their diff was hashed at the start of this task and again at
the end: `a954fbdceb3a9ea474c3406ec70e7419a7fd02b2026f400f21197fb7b6a2df28` both times, unchanged,
and the same hash the two previous C1170 reports recorded. None was touched, staged or reverted;
every commit here was made with an explicit whole-file pathspec. All four binaries were built from a
tree carrying them, so none is reproducible from its commit alone; both arms of every comparison saw
the same foreign tree, so it cancels in every ratio.

## Mystery ledger

1. **Settled: why hashing once saved half again as much as it should have.** The Fermi priced the
   removed hash loop at 54,500 to 56,400 instructions and the measurement is 82,819. The mechanism
   is not a wrong hash coefficient — the two cohorts with identical insert counts recover
   7.996 instructions per hashed byte against the fit's 7.90 — it is that dropping the `&[u8]`
   argument and the loop made `insert` small enough to inline, so all 1,545 inserts stopped paying
   a call: five `push`es, five `pop`s, the `call`, the `ret` and the argument setup, measured at
   16.6 instructions per insert. The evidence is the disassembly (no `insert` symbol in the
   candidate) plus a two-coefficient solve over three cohorts.
2. **Settled, and it corrects the decomposition report's price: the `BUILTINS` walk cost 228
   instructions per first sight, not 175.** The report's 9.1 per cent would have been 151,000
   instructions; the measurement is 219,897, 31 per cent more. The unicode cohort settles it
   cleanly: every spelling there is longer than any builtin, so the saving is 905 × (walk − gate)
   with no length-match term in it, and the compiled-code prediction of 199,100 lands within
   36 instructions of the measured 199,064.
3. **Settled, and it is the methodological lesson of this task: the fitted model finds candidates,
   the disassembly prices them.** The model predicts the *stage* to −0.32 per cent, and it
   mispriced *one candidate* by 31 per cent, with no contradiction between those two facts. The
   `first_sight` unit is joint with the insert that always follows it and with the hash bytes that
   are counted separately, so the sum is constrained and the split is not — exactly the failure the
   decomposition report named for the binder scan, landing this time on the unit that was being
   optimized. The rule this task can defend from its own three results: a Fermi read off the
   compiled loop body closes to within 2.4 per cent **when the change leaves the surrounding call
   shape alone** (candidates 2 and 3, six cohort predictions, worst residual 2.4 per cent); a Fermi
   taken from a joint fitted coefficient was 31 per cent out (candidate 2's price in the
   decomposition report); and a Fermi that prices the loop correctly but misses that the edit also
   changes what the compiler inlines was 47 per cent out (candidate 1). The third is the one worth
   remembering, because it is the failure mode that cannot be fixed by reading the loop harder:
   check what the *signature* change does to inlining, not only what the body change does to
   instructions.
4. **Settled: the three changes do not interact.** Measured sequentially against freshly retained
   controls, the ASCII admission ratios are 0.952507, 0.867613 and 0.934981; their product is
   0.772675 and the end-to-end measurement against the original control is 0.772673, **three parts
   per million** apart. They touch `insert`'s signature, `reference`'s new-name path and `admit`'s second
   scan, and nothing re-priced anything else.
5. **Not a mystery, recorded so it is not read as one.** The scalar variant's *stage* ratios are
   closer to unity than the byte variant's (0.9294 against 0.9068 composed) while its *admission*
   difference is identical to the byte variant's to ten instructions. The scalar scanner is a
   matched experimental control that admission does not touch: it makes the parse stage larger, so
   the same absolute saving is a smaller fraction of it. The admission difference is the quantity.
6. **Open: `declare` still costs about 198 instructions per definition, and it is now 4.41 per cent
   of the composed stage.** This is ledger item 7 of the decomposition report, untouched by this
   task and more visible than before because the stage around it shrank by 22.7 per cent.
   `declare` is 233 instructions of compiled code and runs 640 times per ASCII admission; the
   header-chain walk and `count_arguments` do not obviously account for that. The evidence gap is
   unchanged: a `perf annotate` of `admit::declare` bucketed into named address ranges, which this
   task did not run because none of its three candidates was inside `declare`.
7. **Open: the definitions pool is sized by `Limits::symbols` and `prepare` pays 12.7 per cent for
   it.** 734 instructions and 32,768 reserved bytes to reserve and release a pool that a realistic
   source fills to 576 of 8,192 entries. `Limits::symbols` is the bound that is *provably* correct,
   since a declared definition also takes a symbol slot; a tighter one would be a new `Limits`
   field, which is a limits-shape decision rather than an optimization, and a workspace is reused
   across many admissions so the cost is per workspace and not per source. The evidence gap is a
   measurement of how often a workspace is created in a real embedding, which this prototype has no
   answer for. Stated rather than decided.
8. **Open, cheap, and left undone deliberately: 69 of the ASCII cohort's 905 first sights still
   pass the gate.** They are spellings like `age` against `abs` and `base14` against `bottom`,
   which cost one or two byte comparisons each — about 1,400 instructions on the whole cohort, a
   tenth of a per cent. A wider gate (a second-byte bit, or a 64-bit fingerprint of the first eight
   bytes like `lexer::keyword`'s packed compare) would remove most of it and add a table. Priced
   here so nobody proposes it as a candidate without the price.

## Remaining next steps

Priced against the **new** ASCII admission stage of 1,347,415 instructions, using the
decomposition's counts and, where possible, a compiled loop body rather than a fitted coefficient.

1. **The traversal cursor, which this task did not start.** `run`'s pop reloads `visits.len()`, the
   visits base pointer, `nodes.len()` and the nodes base pointer on every visited node and writes
   the length back; `push` repeats the pattern. At 8,320 visits it is the largest single remaining
   term — the fitted 39.95 per visit is 332,356 instructions, **24.7 per cent of the stage as it
   now stands**, and the token-store change removed exactly this shape from the scanner for
   5.00 instructions per token. Priced at 5 to 10 per visit that is 42,000 to 83,000, **3.1 to
   6.2 per cent**. The risk named in advance is unchanged: the traversal mutates `w.binders` and
   `w.symbols` through `reference`, so the nodes slice can be hoisted but the visits stack cannot be
   hoisted across that call the way the scanner's token cursor was. Ledger item 3 above says to
   check the 39.95 against `run`'s disassembly before building it, not to trust the coefficient.
2. **Hoist the surviving scan's reloads.** The one remaining node-pool scan still reloads
   `nodes.len()` and the base pointer on every node, because `declare` takes `&mut Workspace` — ten
   instructions per node where the removed second pass managed eight. Restructuring so the scan
   collects ids first and declares afterwards, or holding the pool as a local slice, is worth about
   two instructions per node over 12,288: **24,600 instructions, 1.8 per cent**.
3. **Re-run the decomposition at `49bbb9a`.** Every coefficient in
   `performance-v1-admit-model-185015e.json` is now stale for three units, and the two candidates
   above are priced off it. `admit-decompose.py`, `admit-census.py` and `admit-model.py` are
   committed and the replay is one command each; the census needs no change, because it replays
   `admit.rs` and `admit.rs` changed. **The census must be updated first**: it still hashes inside
   `insert`, walks all 32 `BUILTINS` entries and scans the pool twice, so it would now mis-count the
   kernel it claims to replay, and its validation against the driver's admission summary would not
   catch that, since the summary is unchanged by design.
4. **Not worth doing, priced so it is not proposed.** A wider `BUILTINS` gate (item 8 above, 0.1 per
   cent); the index clear (1,795 instructions, 0.13 per cent of the new stage); the binder scan
   (10,245 instructions, 0.76 per cent, and its coefficient is not identified).

## What this task left under `~/.cache/ergodis/`

For the user's cache decision. Nothing was deleted, nothing large went to `/tmp`, and no `~/.cache`
path is cited as evidence: the receipts carry the hashes and the retain recipe is the thing to run.

| File | Size | Measured sha256 | rustc |
|---|---:|---|---|
| `bin/ergodis-tools-7817627` | 15,117,752 | `dd09841e…53cf16cb` | 1.95.0 |
| `bin/ergodis-tools-de35905` | 15,118,760 | `055272bd…74aa2836` | 1.95.0 |
| `bin/ergodis-tools-49bbb9a` | 15,121,176 | `06f946d5…39636c7a` | 1.95.0 |
| `perf-c1170/admit-49bbb9a.data` | 1,051,712 | — | the profile this report cites |

Each retained executable has a `MANIFEST.tsv` row and a `.sha256` sidecar. The task also inherits
the two retained executables and the profile data the decomposition phase left, and the earlier
C1170 phases' binaries and `perf.data` files; `../ergodis-dev/scripts/cache-gc.sh` has not been run,
since deletion is the user's call.

## Audit corrections (2026-09-15)

An independent verification pass re-derived every ratio here from the committed receipts and
re-measured the sha256 of all four retained binaries, which match. One correction was applied in
three places: the stated product of the three per-candidate ratios was 0.77264, which is a
miscomputation of 0.9525 × 0.8676 × 0.9350 = 0.772674. The agreement with the measured 0.772673 is
therefore one to three parts per million, not three parts in a hundred thousand, so the
non-interaction conclusion is better supported than the report claimed. Details are in
`2026-09-15-c1170-admission-chain-audit.md`.

