# C1170 — decomposing the semantic admission stage by input class

**Lane**: `ergodis`
**Date**: 2026-09-14
**Repository**: `~/src/ergodis-private` (private, no public remote), branch `main`
**Control**: `ergodis-tools` built at revision `32a18c6` and retained as `ergodis-tools-32a18c6`
(retain recipe: `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at that revision).
Measured sha256 `f5a24b89554c9a652e5739fb4db34396579538bf9cbb74705356334788b3513c`,
rustc 1.95.0 (59807616e 2026-04-14) read from the binary's `.comment` section, release profile,
no features. The toolchain is now pinned through the core flake, so every build, test, Clippy run
and measurement in this report is that compiler.

**Measurement binary**: `ergodis-tools` at revision `185015e`, retained as
`ergodis-tools-185015e`, measured sha256
`59d8b1e622b912077d92f5b2eae159ea170942c642ddfa15ac36ea857783e249`, same recipe, same rustc. It
differs from the control only in the measurement driver. An intermediate binary,
`ergodis-tools-52d48eb`, measured sha256
`c47db36c68490aaa70900be5579874787b1d4a389f1191f888a94d8b49f60156`, appears in the parity section
below because it is the one that isolates which driver commit moved the parse stage.

This is a measurement task. **No kernel code was changed**: `src/rel_frontend/admit.rs` and every
other file under `src/` is byte-identical to `32a18c6`.

**Commits** (all on `main`, in order):

| Commit | Contents |
|---|---|
| `52d48eb` | the bench driver takes `--source-file` and `--symbols`; no kernel path changed |
| `185015e` | the bench driver dumps the parsed node pool; no kernel path changed |
| `32cd207` | the parity receipts for both driver commits |
| `a7ae5b2` | `admit-decompose.py`, `admit-census.py` and `admit-model.py` |
| `70e6390` | the class-decomposition and solved-model receipts |
| `45df44c` | the frontend README's admission-decomposition section |

`git diff --stat 32a18c6 HEAD -- src/ tests/` is empty: no kernel path and no test changed across
the whole task.

## Status

Complete. The admission stage is decomposed into twenty per-unit costs measured on thirty
single-class synthetic sources, and **the model predicts the ASCII cohort's admission cost to
−0.32 per cent** of its measured 1,743,823 instructions — out of sample, since no cohort
contributes a row to the fit. Out of sample on the other two cohorts it is **−0.09 per cent**
(comment-string) and **+0.81 per cent** (unicode). The previous report's 83 per cent unattributed
is now attributed.

**What carries the cost, in instructions per unit and units on the ASCII cohort**, in order:

1. **The traversal, 39.95 per visited node over 8,320 nodes — 19.1 per cent.** One pop, one 32-byte
   node load, the kind dispatch and one push, with four workspace fields reloaded per pop.
2. **The fixed part of resolving a name, 70.99 per reference over 3,520 — 14.4 per cent.**
3. **First sight of a name, 265.88 over 905 — 13.8 per cent.** The 32-entry `BUILTINS` linear walk
   plus the insert that always follows it. 28,899 of the walk's 28,928 iterations exist to prove a
   name is *not* in a 32-entry list.
4. **The two node-kind scan passes, 16.88 per pool node over 12,288 — 11.9 per cent.** The pool is
   scanned end to end twice, once to find definitions and modules and once to find definitions
   again.
5. **Name hashing, 7.90 per byte over 25,477 bytes — 11.6 per cent**, of which 1,545 names are
   hashed twice because `reference` computes the hash and then hands `insert` only the span.

**The index clear is not where the cost is**, which answers the first suspect the previous report
named: 0.1096 instructions per slot, 1,795 per admission, **0.10 per cent**, linear across a
64-fold `--symbols` sweep. That closes ledger item 8's worry for admission's instruction count.

Three coefficients check against the compiled code and agree: the hash at 7.90 per byte against a
seven-instruction FNV loop, the pool scan at 16.88 per node against ten and eight instructions in
the two loops, and the index clear at 0.1096 per slot against a libc `memset` that measures
0.05 per cent in an 88,000-sample profile.

**Two gates did not pass and are reported as failures, not as passes.** The driver's second commit
(`185015e`, the node dump) moved the **parse** stage by 1.7 per cent on the ASCII cohort through a
ThinLTO import decision, so its stage-level instruction-ratio parity against the control failed;
the admission stage it measures is bit-stable across all three binaries (1,743,825 / 1,743,832 /
1,743,826) and its compiled code is byte-identical, so the measurement stands, but the gate as
stated did not hold. And the model's **leave-one-family-out residuals run to ±30 per cent** on a
withheld pure shape, against ±0.8 per cent on the three cohorts: the model interpolates a mixture
and does not extrapolate to a shape it has not seen. Both are in the ledger.

Ranked candidates for the next change, priced but not implemented: the `BUILTINS` walk
(9.1 per cent), hashing each name once instead of twice (5.6), the redundant second pool scan
(5.6) and the traversal's stack bookkeeping (2.4 to 4.8). The `BUILTINS` walk, the duplicate hash
and the second pool scan touch three different places and their savings add, to **20.2 per cent of
the admission stage**.

Vibe check: good. The stage is fully attributed, the biggest single win is the same table-lookup
change this lane already made once for the scanner, and the two things that did not go to plan —
a ThinLTO-induced parse shift and a model that interpolates but does not extrapolate — are both
understood and neither touches the headline.

## Fermi, written before any measurement

Read off `src/rel_frontend/admit.rs` at `32a18c6`, counting the work each construct does rather
than guessing a share. The stage's cost on the ASCII cohort as the previous report left it is
1,749,589 instructions per admission of a 43,008-byte source with 12,288 nodes, 3,520 name
references, 1,024 applications, 896 binders, 576 definitions, 64 modules and 1,545 symbols.

The shape of the work, in the order `admit` performs it:

1. **The index clear.** `slots = index_slots(8192)` is 16,384 `u32` slots, 65,536 bytes, zeroed on
   every admission. It is proportional to `Limits::symbols` and not to the source. If it vectorizes
   to 32-byte stores that is about 2,048 stores, so **0.15 to 0.3 instructions per slot, 2,500 to
   5,000 per admission** — under half a per cent of the stage. This is the term `--symbols` exists
   to separate; a large coefficient here would be a surprise and would change what to optimize.
2. **Two full scans of the node pool.** Pass 1 matches every node's kind to find definitions and
   modules; pass 2 matches every node's kind again to find definitions. Each iteration is a bounds
   test, a 16-bit load at offset 24 of a 32-byte record, and two compares: about **6 instructions
   per node per pass, 12 per node, 147,000 per admission**.
3. **The traversal `run`.** One pop per visited node, a 32-byte node load, a jump-table dispatch on
   the kind, and a push per child. A tree of *n* nodes has *n*−1 edges, so about one push per pop.
   A `Vec` pop and a `Vec` push with a capacity test are roughly 10 to 12 instructions each here —
   the token-store phase of the previous task measured exactly that shape at 16 instructions before
   it was hoisted, and nothing has hoisted this one. Estimate **35 to 40 instructions per visited
   node**, over roughly 11,000 body nodes: **400,000 per admission**.
4. **`reference`, per name reference.** A counter bump; `hash_of` over the name's bytes at about
   5.5 instructions per byte plus 5 of setup; a linear scan over the binders the definition being
   checked has accumulated, about 7 instructions per binder examined plus an `same()` byte loop on a
   16-bit-hash hit; and, if no binder matched, an open-addressed probe of the index — a load from a
   64 KiB table, a 16-byte symbol load, a hash compare, `same()` over the name bytes, and
   `compatible`. At a 9.4 per cent load factor that is about 1.1 probes. Estimate **55 + 11 × (name
   bytes) instructions for a reference that reaches the index**, and much less for one a binder
   answers, because a binder hit returns before the probe.
5. **`is_builtin`, on every name seen for the first time.** It walks all 32 entries of `BUILTINS`
   comparing lengths before any byte compare, so a name that is not a builtin pays all 32
   iterations: about **200 instructions per new name**. With 905 new names reached from references
   that is **181,000 per admission, 10 per cent of the stage**, spent proving that a name is not in
   a 32-entry allowlist. This is the single term the reading of the source makes me most suspicious
   of.
6. **`insert`, per symbol.** A capacity test, `hash_of` **again** over the same name the caller just
   hashed, a 16-byte push, and a probe for an empty slot: **30 + 5.5 × (name bytes)**, over 1,545
   symbols. The duplicated hash is worth naming now: `reference` computes the full 32-bit hash and
   passes only the name span to `insert`, which recomputes it.
7. **`declare` and `check_definition`, per definition or module.** A short header-chain walk,
   `count_arguments`, three `Vec` clears and a push: **50 to 60 each**, over 640 and 576 calls,
   **73,000**.
8. **`bind_list` and `bind`, per binder.** `bind_list` measures the comma chain and then re-descends
   it once per element, which is quadratic in the parameter count of one definition; the cohort's
   lists are one to three long, so that is a handful of node loads. `bind` hashes the binder's
   spelling (one byte for `x`, `y`, `z`) and pushes a 16-byte symbol: **about 35 per binder**, over
   896, **31,000**.

| Term | Predicted per unit | Units on the ASCII cohort | Predicted instructions |
|---|---:|---:|---:|
| index clear | 0.15–0.3 per slot | 16,384 slots | 2,500–5,000 |
| node-kind scans, two passes | 12 per node | 12,288 | 147,000 |
| traversal `run` | 35–40 per visited node | ~11,000 | 400,000 |
| `reference`, excluding `is_builtin` | ~100 per reference | 3,520 | 352,000 |
| `is_builtin` on first sight | ~200 per new name | 905 | 181,000 |
| `insert` | ~60 per symbol | 1,545 | 93,000 |
| `declare` + `check_definition` | ~55 per item | 1,216 | 67,000 |
| `bind_list` + `bind` | ~35 per binder | 896 | 31,000 |
| **predicted total** | | | **~1,280,000** |
| **measured** | | | **1,749,589** |

The Fermi is **27 per cent under the measurement**, and that gap is recorded here as it stood
before any measurement: the per-node and per-reference costs are the two I expect to be under-counted,
because every `Vec` push and pop in this stage still reloads the pool's length and base pointer the
way the token store did before the previous task hoisted it. If the measurement puts the per-node
cost above 50, that reload is the mechanism and the same cursor treatment applies.

**Predicted ranking of what carries the cost**, so the measurement can contradict it: the traversal
first (about 23 per cent), the per-reference work second (20 per cent), `is_builtin` third
(10 per cent), the two node-kind scans fourth (8 per cent), and the index clear last and negligible
(0.2 per cent).

## Method

Three committed scripts, each with one job, so that the counting and the fitting can be checked
separately from the measuring.

**`analysis/rel-frontend/admit-decompose.py`** builds the single-class synthetic sources, writes
each to a file, and measures the admission stage on it. Admission alone is the `admit` stage minus
the `parse` stage on the same source, paired by round, both by two-point differencing under
`perf stat` pinned to CPU 5 with the non-multiplexing event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults`. Iterations are calibrated
per operation against the driver's own timed-loop total, because a fixed count cannot serve both a
43,008-byte source and the eleven-byte intercept source. Every source carries the admission summary
its builder declares — definitions, modules, base relations, binders, references, applications and
symbols — and the driver's own summary is asserted against it before any counter is read.

**`analysis/rel-frontend/admit-census.py`** counts what a source makes the stage do. It does not
re-implement the grammar: the driver's new `--dump-nodes` writes the parser's own node pool, and
the census replays `src/rel_frontend/admit.rs` over it statement for statement, counting nodes
scanned, nodes visited, references and how each one resolved, binder entries examined, index slots
probed, name bytes hashed, name bytes compared, `BUILTINS` walks, inserts, applications and
argument nodes. The census is validated before it is trusted: on every synthetic source it must
reproduce the counts the builder declared, and on every cohort it must reproduce the driver's
admission summary.

**`analysis/rel-frontend/admit-model.py`** joins the two, solves one instruction cost per unit over
the synthetic rows, and predicts each cohort from its census alone.

Two things about the solver are worth stating, because a naive least-squares fit gives a model that
fits the synthetic rows and predicts nothing.

1. **Rows are weighted by the reciprocal of their own measurement.** The measured values span
   662 instructions (the intercept source at the smallest symbol limit) to 2.6 million. An
   unweighted fit ignores the small rows, which are the only evidence for the index-clear slope.
2. **Coefficients are constrained to be non-negative.** No unit costs a negative number of
   instructions. Without the constraint, collinear columns trade large positive and negative
   coefficients: the unconstrained fit priced the traversal at −43 instructions per visited node
   and the node-kind scan at +100, which fits and means nothing.

Two confounds were found by reading the design matrix rather than by trusting the solver, and both
are named here because they are properties of the kernel and not of this run.

- **The `BUILTINS` walk and the insert that follows it cannot be separated.** `is_builtin` runs if
  and only if a reference reaches the new-name path, and a reference that reaches that path always
  inserts. No source can split them, so they are one unit — `first_sight` — and the model does not
  pretend otherwise. The inserts `declare` makes are charged to the definition and module units,
  which are `insert`'s only other callers.
- **The two node-kind scan passes and the traversal were confounded** in every class first built,
  because each of them leaves exactly two nodes in the pool that the traversal never visits: the
  `Definition` node and its name. Two classes exist only to break that. `header-k`
  (`def f(_, ..., _) = 1`) puts a whole parameter list, 2k + 3 nodes, in the pool against one visit;
  it separates the scan passes from the traversal but trades against `bind_list`, because a binder
  list is what it adds. `qualified-k` (`def f = a:q:q:...`) is the clean lever: the `Qualified` arm
  of the traversal pushes only its left side, so each tag is scanned twice and never visited, and a
  tag is not a reference, a binder or an argument. Per qualifier the row gains exactly two pool
  nodes and one visit, against the numeric-chain class's one and one, and nothing else changes.

Cohorts are predicted out of sample in the sense that matters: no cohort contributes a row to the
fit. The synthetic sources decompose and say nothing about real Rel input; the cohort residual is
the claim. Because the model has twenty units and thirty synthetic rows, and a model with that much
freedom can interpolate its own rows, `admit-model.py` also withholds each class family in turn,
refits without it, and predicts the withheld rows; those figures are reported below beside the
cohort residuals.

## The driver change, and the parity gate

`52d48eb` adds `--source-file` and `--symbols`; `185015e` adds `--dump-nodes`. Both are driver-only.
Each was measured against the retained control `ergodis-tools-32a18c6` with
`analysis/rel-frontend/bench.py --rounds 4 --cpu 5 --stages parse,admit`, all five cohorts, both
scanner variants, fingerprint gate armed (no `--representation-change`). The gate on token counts,
node counts, failures, admission outcomes and representation fingerprints passed on every operation
of both runs.

**The instruction-ratio gate passed at `52d48eb` and failed at `185015e`, and this is worth
recording rather than papering over.**

| Operation | `52d48eb` over control | `185015e` over control |
|---|---:|---:|
| ascii/parse/byte | 1.000001 | **0.983430** |
| ascii/admit/byte | 1.000002 | **0.990161** |
| malformed-early/parse/byte | 0.999991 | **0.963015** |
| unicode/parse/byte | — | 0.994916 |
| comment-string/parse/byte | — | 0.989957 |

Adding an untimed node-dump path to the driver made the **scanner and parser** 1.7 per cent cheaper
on the ASCII cohort and 3.7 per cent cheaper on malformed-early. The mechanism is ThinLTO: the
workspace builds with `lto = "thin"` and `codegen-units = 1`, and cross-module import decisions are
budget-based and depend on the module summary, so adding unrelated code to the crate changes which
functions get imported and inlined into `lexer::scan` and the Pratt loop. The intervals are a few
parts per million wide; this is not noise.

**The quantity this task measures is unaffected, and that is checked rather than asserted.** The
same two stages are shifted by the same amount, so their difference is stable:

| Cohort | admission at control `32a18c6` | at `52d48eb` | at `185015e` |
|---|---:|---:|---:|
| ascii | 1,743,825 | 1,743,832 | 1,743,826 |
| unicode | 1,972,172 | 1,972,170 | 1,972,174 |
| comment-string | 560,751 | 560,759 | 560,754 |

One instruction per admission across three binaries on the ASCII cohort — a ratio of 1.0000006. The
admission stage's own code is byte-identical and its cost is bit-stable; only the parse stage moved.
Every measurement in this report is taken at `185015e` and compared against the cohort admission
cost measured at `185015e`, so the model's closure is internally consistent, and the table above is
what carries it back to the control.

Receipts: `analysis/rel-frontend/performance-v1-admit-driver-52d48eb.json` and
`performance-v1-admit-driver-185015e.json`.

A third check, from the compiled code rather than from counters: the six out-of-line admission
symbols disassemble to identical instruction sequences in the control and in the measurement
binary, modulo addresses.

| Symbol | Instructions | Control against measurement binary |
|---|---:|---|
| `admit::run` | 416 | identical |
| `admit::admit` | 277 | identical |
| `admit::insert` | 79 | identical |
| `admit::declare` | 158 | identical |
| `admit::bind_list` | 326 | identical |
| `admit::reference` | 347 | identical |

All 1,603 instructions of admission code are the same in both, which is what one expects from an
unchanged kernel and is the reason the ThinLTO shift lands entirely on the scanner and the parser.
`is_builtin`, `hash_of`, `same`, `compatible`, `count_arguments` and `bind` are inlined and have no
symbol of their own; `reference` at 347 instructions is where the `BUILTINS` walk lives.

The previous report's ASCII admission figure was 1,749,589 instructions at `49493a3` under
rustc 1.93.1. This report measures 1,743,826 at rustc 1.95.0 — a 0.33 per cent compiler difference
on identical source, which is the same order as the compiler differences this lane has recorded
before. The two figures are not comparable and nothing in this report rests on the older one.

## What the compiled stage does, read off its own disassembly

Read from `ergodis-tools-185015e` before the coefficients came back, so that the measurement has
something to agree or disagree with.

**The index clear is a libc `memset` call.** `admit::admit+0x99` and `+0xd4` are
`call *…<memset@GLIBC_2.2.5>`. It is outside the node loop, which is what the contract requires of
a bulk operation, and it costs about 1,800 instructions per admission — a tenth of a per cent — so
it never rose above the previous report's profile threshold. That report's sentence "no libc symbol
appears inside the stage at any threshold" is about what the profile showed; the compiled code has
one, and it is this.

**The first node-kind scan pass reloads the node pool's length and base pointer on every node.**

```text
mov    0x28(%r14),%rsi        ; nodes.len(), reloaded every node
cmp    %rsi,%r15
jae    <panic>
mov    0x20(%r14),%rax        ; nodes base pointer, reloaded every node
movzwl (%rax,%rbp,1),%eax     ; the kind, at offset 24 of a 32-byte record
cmp    $0x9,%eax
je     <Definition>
cmp    $0xa,%eax
jne    <next>
inc    %r15
add    $0x20,%rbp
cmp    %r15,%rbx
jne    <loop>
```

Ten instructions per node, two of them reloads the compiler cannot hoist because `declare` takes
`&mut Workspace`. **The second pass hoists them and costs eight**, but carries two bound tests per
node instead of one — the loop's own counter and a second test against `nodes.len()`:

```text
cmp    %rbx,%r15              ; against the count the loop was entered with
jae    <exit>
cmp    %rsi,%r15              ; against nodes.len() again
jae    <panic>
inc    %r15
cmpw   $0x9,(%rcx)
lea    0x20(%rcx),%rcx
jne    <loop>
```

So the two passes together are about 18 instructions per node before anything is admitted, and
12,288 nodes is roughly 220,000 instructions — the same two-redundant-tests and reloaded-pool-fields
shape the previous task removed from the scanner's token store, in a different loop.

**The traversal's pop does it four times over.**

```text
mov    0xd0(%r14),%r12        ; visits.len()
test   %r12,%r12
je     <done>
lea    -0x1(%r12),%rbp
mov    %rbp,0xd0(%r14)        ; visits.len() written back
mov    0xc8(%r14),%rdx        ; visits base pointer
mov    -0x8(%rdx,%r12,8),%edi ; the Visit
cmp    %r11,%rdi              ; is it a scope-close sentinel
je     <close>
mov    0x28(%r14),%rsi        ; nodes.len()
cmp    %rdi,%rsi
jbe    <panic>
mov    0x20(%r14),%rcx        ; nodes base pointer
```

Four workspace field loads and one store per pop, before the node is even read, and `push` repeats
the pattern on the way in.

## Results: the per-unit costs

Thirty single-class synthetic sources, five interleaved rounds, CPU 5, event set at 100 per cent
enabled (no multiplexing), one-minute load average 1.69 at the start and 1.71 at the end. Receipt
`analysis/rel-frontend/performance-v1-admit-classes-185015e.json`; the solved model is
`performance-v1-admit-model-185015e.json`.

| Unit | Instructions per unit | What it is |
|---|---:|---|
| a name byte through `hash_of` | **7.90** | the FNV loop, one byte at a time, with a bounds test |
| a name seen for the first time | **265.88** | the 32-entry `BUILTINS` walk plus the insert that always follows it |
| a node visited by the traversal | **39.95** | one pop, one 32-byte node load, the kind dispatch, one push |
| a name reference, fixed part | **70.99** | entry, the counter, the hash setup, the probe setup |
| a node in the pool | **16.88** | the two node-kind scan passes together |
| a definition declared | **198.17** | `declare`, its header walk, its insert, and `check_definition` |
| a module declared | **180.54** | `declare` and its insert; a module has no body walk |
| a binder list walked | **111.26** | `bind_list` entry, its measuring loop and its dispatch |
| a byte compared by `same()` | **12.73** | the explicit two-span byte loop |
| a node walked by `count_arguments` | **26.21** | one element of an application's comma chain |
| a binder recorded by `bind` | **43.06** | the capacity test, the hash and the 16-byte push |
| an `Apply` node | **27.55** | the application arm on top of the generic visit |
| an index slot read by a probe | **38.83** | one open-addressed step |
| a node load inside `bind_list` | **9.11** | the re-descent's `nodes[current].a` |
| a byte compared against a `BUILTINS` entry | **45.65** | only on a length match; 77 of them on the ASCII cohort |
| a binder examined by the binder scan | **2.08** | see the ledger: this one is not identified |
| an index slot cleared | **0.1096** | the libc `memset`, proportional to `Limits::symbols` |
| one admission, whatever the source | **131.76** | entry, the four pool clears, the two loop setups |

Three of these can be checked against the compiled code rather than against another fit, and they
agree:

- **The name hash at 7.90 per byte** against a seven-instruction loop body in `reference`
  (`cmp`, `jae`, `movzbl`, `xor`, `imul`, `inc`, `cmp`/`jne`), plus loop entry and exit amortized
  over an average name of 4.3 bytes.
- **The two node-kind scan passes at 16.88 per node** against ten instructions per node in pass one
  and eight in pass two, read off `admit::admit` above.
- **The index clear at 0.1096 per slot**, which is 1,795 instructions for the bench limits — and
  `__memset_avx512_unaligned_erms` measures 0.05 per cent of the composed stage in an
  88,000-sample profile against the 0.042 per cent the coefficient predicts.

The index clear is settled and it is **not** where the cost is: a tenth of a per cent. Raising
`Limits::symbols` eightfold, from 8,192 to 65,536, takes it from 1,795 to 14,366 instructions per
admission, which on this cohort is 0.82 per cent — still under one. The `--symbols` sweep is linear
across a 64-fold range with a
slope of 0.1087 to 0.1135 per slot between every adjacent pair, so the term is a clean straight
line with no threshold in it.

### Where the fit fails, stated plainly

The design matrix has twenty units and thirty rows, and its condition number is 2.2 × 10^17 — it is
numerically singular. Several coefficients are therefore joint, not individual:

- **`binder_scan` at 2.08 is too low and is absorbed by `references`.** The disassembly's binder
  scan is seven instructions per entry (`test`, `je`, `dec`, `mov`, `shl`, `cmp`, `jne`). Every
  class that scans binders also makes references, in a nearly fixed ratio, so the solver can move
  cost between the two. The sum is right; the split is not.
- **`probe_symbol_loads` and `colon_nodes` are driven to zero.** The first is collinear with
  `probe_slot_reads` in every class; the second with `binds` and `bind_list_calls` in the one class
  that has abstractions.
- **`count_arg_nodes` at 26.21 is high** for a loop whose body is about seven instructions; it is
  absorbing part of the `Apply` arm.

The leave-one-family-out test says the same thing quantitatively. Withholding a whole class family,
refitting and predicting the withheld rows:

| Withheld family | Rows | Worst residual |
|---|---:|---:|
| `ref-repeat` | 2 | −0.58 % |
| `ref-definition` | 2 | −0.54 % |
| `ref-distinct` | 2 | +5.18 % |
| `apply` | 2 | +6.35 % |
| `header` | 2 | +11.26 % |
| `module` | 1 | −11.73 % |
| `abstraction` | 1 | +11.96 % |
| `binders` | 3 | −12.05 % |
| `qualified` | 2 | +23.40 % |
| `ref-binder` | 2 | −22.92 % |
| `node` | 2 | −26.62 % |
| `definition` | 2 | +31.64 % |
| `intercept` | 7 | +1481 % |

**The model does not extrapolate to a pure shape it has never seen**, and the intercept row shows
that at its most extreme: drop the seven eleven-byte sources and nothing constrains the fixed term
or the index-clear slope, so a 660-instruction row is predicted at fifteen times its value. What
the model does do is interpolate a mixture, and a cohort is a mixture: the ASCII cohort's ratio of
pool nodes to visits is 1.48, against 1.01 for the numeric-chain class and 27 for the widest header
class, and its reference mix spans all four resolution paths. That is why the cohort residuals are
what they are and the holdout residuals are what they are, and it is the limit of the claim.

## The census

`admit-census.py` replays `admit.rs` over the dumped node pool. On every one of the thirty
synthetic sources it reproduces the counts the builder declared; on all three cohorts it reproduces
the driver's admission summary exactly. For the ASCII cohort:

| Unit | ASCII cohort | Instructions | Share |
|---|---:|---:|---:|
| nodes visited by the traversal | 8,320 | 332,356 | 19.1 % |
| name references | 3,520 | 249,891 | 14.4 % |
| names seen for the first time | 905 | 240,623 | 13.8 % |
| nodes in the pool, scanned twice | 12,288 | 207,389 | 11.9 % |
| name bytes hashed | 25,477 | 201,393 | 11.6 % |
| definitions declared | 576 | 114,146 | 6.6 % |
| binder lists walked | 704 | 78,327 | 4.5 % |
| argument nodes counted | 2,688 | 70,463 | 4.1 % |
| index slots probed | 1,694 | 65,784 | 3.8 % |
| name bytes compared | 5,117 | 65,131 | 3.7 % |
| binders recorded | 896 | 38,584 | 2.2 % |
| `Apply` nodes | 1,024 | 28,209 | 1.6 % |
| node loads inside `bind_list` | 2,048 | 18,656 | 1.1 % |
| modules declared | 64 | 11,554 | 0.7 % |
| binder entries examined | 4,928 | 10,245 | 0.6 % |
| `BUILTINS` byte compares | 77 | 3,515 | 0.2 % |
| index slots cleared | 16,384 | 1,795 | 0.1 % |
| one admission | 1 | 132 | 0.0 % |

The reference census — the split the previous report's ledger asked for — is:

| How a reference resolves | Count | Share of references |
|---|---:|---:|
| a binder in scope, which returns before the index probe | 1,920 | 54.5 % |
| a first sight: probe miss, `BUILTINS` walk, insert | 905 | 25.7 % |
| a base relation already in the table | 505 | 14.3 % |
| a builtin already in the table | 126 | 3.6 % |
| a definition in this source | 64 | 1.8 % |

More than half of all references are answered by a binder and never touch the symbol table at all.
Of the 905 first sights, 903 are external base relations and two are builtins (`sum` and `count`),
so the `BUILTINS` walk runs 905 times and succeeds twice; 28,899 of its 28,928 iterations exist to
prove a name is not in a 32-entry list.

The name-byte totals are 25,477 bytes hashed over 5,961 `hash_of` calls — 3,520 from references,
1,545 from inserts and 896 from binders — and 5,117 bytes compared over 2,615 `same()` calls.
**1,545 of those hash calls, 12,320 of those bytes, are recomputations**: `reference` computes the
full 32-bit hash, then hands `insert` only the name span, and `insert` hashes it again. Nearly half
the stage's hashing is done twice.

## Prediction against measurement

| Cohort | Measured admission | Predicted from the census | Residual |
|---|---:|---:|---:|
| **ascii** | **1,743,823** | **1,738,193** | **−0.32 %** |
| comment-string | 560,759 | 560,239 | −0.09 % |
| unicode | 1,972,176 | 1,988,136 | +0.81 % |

No cohort contributes a row to the fit, so all three are out of sample. The measurement's own noise
is far below the residual: the ASCII admission figure has a standard deviation of 3.4 instructions
across five rounds on a mean of 1,743,823, about two parts per million; the unicode figure's is 4.5
and the comment-string figure's 9.4.

A second, model-free check on the two name-byte coefficients, from the two cohorts alone. The
Unicode cohort has *identical* structure to the ASCII one — same 12,288-node pool shape, same 3,520
references, same 896 binders, same 1,545 symbols — and differs only in that Greek and CJK spellings
make its names roughly twice as long. It costs 228,353 instructions more, for 25,117 more bytes
hashed and 4,131 more bytes compared. Solving those two numbers against the fitted hash coefficient
of 7.90 gives 6.8 instructions per compared byte, against the fitted 12.73. The two name-byte
coefficients together are right to within the cohort difference; their split carries the same
caveat as the binder scan.

## Kernel-scoped profile

`perf record -e instructions:u -F 20000`, ASCII cohort, byte scanner, 512 definitions, 20,000
iterations of the `admit` stage, pinned to CPU 7, 88,000 samples.
`~/.cache/ergodis/perf-c1170/admit-185015e-dense.data`.

| Symbol | Share of the parse + admit stage |
|---|---:|
| `parser::Parser::expression` | 30.12 % |
| `Workspace::scan_variant` | 22.83 % |
| `admit::reference` | 11.34 % |
| `admit::run` | 10.83 % |
| `admit::insert` | 9.72 % |
| `admit::admit` | 4.53 % |
| `admit::bind_list` | 2.85 % |
| `lexer::keyword` | 2.68 % |
| `admit::declare` | 1.76 % |
| `parser::Parser::item` | 1.72 % |
| `parser::Parser::node` | 0.86 % |
| `core::str::converts::from_utf8` | 0.41 % |
| `parser::parse` | 0.26 % |
| `libc __memset_avx512_unaligned_erms` | **0.05 %** |

The six admission symbols sum to 41.03 per cent; the stage difference puts admission at
1,743,823 of 4,251,655, which is 41.01 per cent. The two methods agree to two hundredths of a
point.

**Every out-of-line call inside the admission traversal**, as the contract requires:
`admit::reference`, `admit::insert`, `admit::bind_list` and `admit::declare`, all of them this
stage's own code — and **one libc call, `memset`, from the index clear in `admit::admit`**. That
call is outside the node loop, which is what the contract asks of a bulk operation, and it costs
0.05 per cent. The previous report said no libc symbol appeared at any threshold; at 88,000 samples
one does, and the disassembly shows it directly. `is_builtin`, `hash_of`, `same`, `compatible`,
`count_arguments` and `bind` are inlined and have no symbol of their own.

`admit::insert`'s share is 9.72 per cent here against 15.98 per cent in the previous report's
profile of the same code — the skid-onto-a-store effect that report flagged, moving by six points
between two profiles. The model does not use it, and this is the fourth time in this lane that a
profile share has moved more than the effect being chased.

## Mystery ledger

1. **Settled: what carries the admission stage's cost.** Not the index clear, which was the first
   named suspect and is one tenth of one per cent. The five terms that carry it are the traversal's
   per-node bookkeeping (19.1 per cent), the fixed part of resolving a reference (14.4), the
   first-sight path with its 32-entry `BUILTINS` walk (13.8), the two node-kind scan passes (11.9)
   and name hashing (11.6). Those five are 71 per cent of the stage. The evidence is thirty
   synthetic sources, a census validated against the kernel's own summary on every one of them, and
   a prediction that closes on the ASCII cohort at −0.32 per cent.
2. **Settled, and it contradicts the previous report's ledger item 6.** That item priced name
   hashing and comparison at "about 12 instructions per name byte, so roughly 300,000 of the
   1,749,589, or 17 per cent", from the ASCII/Unicode difference, and called the other 83 per cent
   unattributed. The decomposition puts hashing at 7.90 per byte and comparison at 12.73, and the
   two together at 266,524 instructions, 15.3 per cent — so that estimate was close. What is new is
   the other 84.7 per cent, which is now attributed.
3. **Settled: the index clear is not a workspace-sizing problem for admission.** Ledger item 8 of
   the previous report worried that admission clears an index proportional to `Limits::symbols`
   rather than to the source. It does, at 0.1096 instructions per slot, linear across a 64-fold
   sweep; at the bench limit that is 1,795 instructions, and even at `symbols = 65536` it is 14,366,
   0.82 per cent. The workspace-sizing question remains open for `prepare` and first-touch
   page faults, which is a different cost read from faults and wall time; it is closed for
   admission's instruction count.
4. **Settled, and it corrects a claim: there is a libc call in this stage.** The index clear
   compiles to `call memset@GLIBC_2.2.5`, twice — once for the re-clear path and once for the
   resize path. It is outside the node loop and costs 0.05 per cent, which is why the previous
   report's profile did not resolve it. The contract's rule is about calls *inside* hot loops, and
   this is not one, but "no libc symbol appears inside the stage at any threshold" was a statement
   about a profile, not about the compiled code, and it should not be repeated.
5. **Open: the split between the binder scan and the fixed per-reference cost is not identified.**
   The fit gives 2.08 instructions per binder examined where the disassembly shows a
   seven-instruction loop body, and 70.99 for the fixed part of a reference. Every class that scans
   binders also makes references in a nearly fixed ratio, so the solver moves cost freely between
   them; the sum is constrained and the split is not. The evidence gap is one synthetic class that
   varies the number of binders *in scope* at a reference without varying the number of references —
   a definition with k binders and a fixed reference count, at several k — which `binders-k` does
   not do because its reference count is tied to k. Nothing in the candidate ranking below depends
   on this split: the whole binder-scan term is 0.6 per cent.
6. **Open: the model interpolates and does not extrapolate.** Leave-one-family-out residuals run to
   ±30 per cent on a withheld pure shape, against ±0.8 per cent on the three cohorts. The design
   matrix is numerically singular (condition 2.2 × 10^17) with twenty units against thirty rows.
   This is a real limit on how the model may be used: it prices a change to a cohort-like mixture,
   and it does not price a change measured on a synthetic shape the fit has not seen. The evidence
   gap is more rows — one more length per class would roughly double them — and a smaller unit set
   built from the identified sums rather than the individual terms.
7. **Open, and it is the one measurement result that surprised me.** `declares_definition` costs
   198 instructions and `bind_list_calls` 111, which together are 11.1 per cent of the stage for
   576 definitions and 704 binder lists — more per definition than the ASCII cohort's whole
   traversal costs per node, seventeen times over. `declare` is 158 instructions of compiled code
   and `bind_list` 326, so the coefficients are not impossible, but they are large enough that
   something in the header walk is doing more than the source suggests. The evidence gap is a
   `perf annotate` of `admit::declare` and `admit::bind_list` bucketed by address range, which this
   task did not run because the model closed without it.
8. **Not a mystery, but it is why this report has two parity tables.** Adding an untimed
   node-dump path to the driver made the scanner and parser 1.7 per cent cheaper through a ThinLTO
   import decision, while leaving the admission stage bit-identical. The lesson for the lane is
   that on this workspace, with `lto = "thin"` and `codegen-units = 1`, **any** code added to a
   crate can move an unrelated hot loop by more than the effects this project chases, so a
   driver-only change still needs its parity A/B, and a stage difference is a more robust
   measurement than either stage alone.

## Ranked candidates for the next change

Priced as units × (current cost − predicted new cost) against the ASCII cohort's measured 1,743,823
instructions. The one guess in each is the new cost; nothing here is implemented, and each would be
a separate A/B against a control retained at the revision the tree then carries.

1. **Replace the linear `BUILTINS` walk with a first-byte and length gate.** 905 first sights on the
   ASCII cohort each walk all 32 entries, 28,899 iterations to find two matches. This is exactly the
   change the lane already made to `lexer::keyword`, where a first-byte/length table rejected most
   names before any compare. The `first_sight` unit is 265.88 instructions, of which the insert
   itself is most plausibly 60 to 80 (the compiled `insert` is 79 instructions); a gate that
   rejects in about 6 would leave roughly 90. **Priced: 905 × 175 = 158,000 instructions, 9.1 per
   cent of the stage.** The disassembly check on the guess is the keyword table's own compiled form,
   which already exists in this tree.
2. **Give the traversal a cursor over its stack, as the token store got.** `run`'s pop reloads
   `visits.len()`, the visits base pointer, `nodes.len()` and the nodes base pointer on every node,
   and writes the length back; `push` repeats the pattern. The per-visit unit is 39.95 over 8,320
   visits. The token-store change removed exactly this shape from the scanner for 5.00 instructions
   per token. **Priced at the same 5 to 10 per visit: 42,000 to 83,000 instructions, 2.4 to 4.8 per
   cent.** The risk named in advance: the traversal mutates `w.binders` and `w.symbols` through
   `reference`, so the nodes slice can be hoisted but the visits stack cannot be hoisted across a
   call the way the scanner's token cursor was.
3. **Do not scan the node pool twice.** Pass one already visits every `Definition` node; it could
   record their ids and pass two could walk that list instead of rescanning 12,288 nodes. The pool
   scan is 16.88 per node of which pass two is about eight, so **priced: 12,288 × 8 = 98,000
   instructions, 5.6 per cent**, against 576 definition ids to store. That storage is the design
   question: it is bounded by the definition count, not by `Limits::symbols`, and the symbol table
   already holds one entry per definition with its node — so the list may already exist and the
   second pass may be removable with no new pool at all.
4. **Hash each name once.** `reference` computes the 32-bit hash and passes `insert` only the span,
   which hashes it again. The 1,545 inserted spellings are 12,320 bytes, and at 7.90 per byte that
   re-hash is **97,000 instructions, 5.6 per cent** — for a signature change and no new state. It
   is worth the same as candidate 3 and is much the cheapest of the four to build and to get
   exactly right, so it is the one to do first if only one is done.
5. **Remove the second bound test from pass two of the node scan.** The loop tests its own counter
   against the entered count and then against `nodes.len()` again. One `cmp`/`jae` pair per node
   over 12,288 nodes is **about 25,000 instructions, 1.4 per cent** — the same redundant-capacity-
   test shape the token store removed, in a second place.
6. **Not worth doing, and priced so nobody proposes it again.** Shrinking or skipping the index
   clear: 1,795 instructions, 0.10 per cent. Making the binder scan cheaper: the whole term is
   10,245 instructions, 0.59 per cent, and its coefficient is not even identified. Caching
   `is_builtin` results: only two names in the cohort are builtins.

Candidates 1, 3 and 4 do not interact — they touch `reference`'s new-name path, `admit`'s second
pass and `insert`'s signature respectively — so their savings add: **353,000 instructions, 20.2 per
cent of the admission stage**, or 8.3 per cent of the composed parse-plus-admit stage. Candidate 2
overlaps candidate 3 only in that both reduce pool bookkeeping, and the playbook's own lesson
applies: re-measure each after the one before it lands, because a per-node win can flip the sizing
of the next.

## Gates and replay

Run from `~/src/ergodis-private`. Every gate was run at `HEAD` under `nix develop ~/src/ergodis`
(rustc 1.95.0).

| Gate | Command | Outcome |
|---|---|---|
| Clippy, tools binary | `cargo clippy --release -p ergodis-tools --bins -j 8 -- -D warnings` | no diagnostics |
| Frontend tests | `cargo test --release -p ergodis-private --test rel_frontend --test rel_frontend_portability -j 8` | 23 passed and 1 passed, 0 failed |
| Driver parity, `52d48eb` | `bench.py --control ergodis-tools-32a18c6 --rounds 4 --cpu 5 --stages parse,admit` | fingerprint gate passed; instruction ratios 1.000001 |
| Driver parity, `185015e` | same | fingerprint gate passed; **parse-stage instruction ratios failed** (0.9834 on ASCII); admission difference stable to one instruction |
| Admission code unchanged | `objdump` of the six `admit::` symbols in both binaries | 1,603 instructions, identical |
| Census against the kernel | inside `admit-model.py` | all thirty synthetic sources and all three cohorts reproduce the driver's admission summary |
| Event set | `instructions,cycles,branches,branch-misses,page-faults,minor-faults` | 100 per cent enabled, no multiplexing |

One receipt field is missing and is recorded here instead. `admit-decompose.py` writes the enabled
fraction and the load average before and after the run; the pre-existing `bench.py`, which produced
the two parity receipts, writes neither. The parity runs used the same event set on the same host,
which the class receipt measures at 100 per cent enabled; **the load average during those two runs
was not recorded and cannot be reconstructed**, which is a gap in the evidence and is stated as one.
It bears only on the cycle figures, which decide nothing here; the parity verdict rests on
instruction ratios whose intervals are a few parts per million wide. Adding both fields to
`bench.py` is a small harness change this task did not make, because doing so would have meant
re-running the parity A/B for a receipt field rather than for a number.

Replay, in order. `$BIN` is `ergodis-tools` retained at `185015e` by
`../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at that revision.

```sh
E=instructions,cycles,branches,branch-misses,page-faults,minor-faults
python3 analysis/rel-frontend/bench.py --binary "$BIN" \
    --control ~/.cache/ergodis/bin/ergodis-tools-32a18c6 --rounds 4 --cpu 5 \
    --stages parse,admit --events $E \
    --out analysis/rel-frontend/performance-v1-admit-driver-185015e.json
python3 analysis/rel-frontend/admit-decompose.py --binary "$BIN" --rounds 5 --cpu 5 \
    --sources ~/.cache/ergodis/perf-c1170/sources \
    --out analysis/rel-frontend/performance-v1-admit-classes-185015e.json
python3 analysis/rel-frontend/admit-model.py \
    --classes analysis/rel-frontend/performance-v1-admit-classes-185015e.json \
    --binary "$BIN" --work ~/.cache/ergodis/perf-c1170/census \
    --out analysis/rel-frontend/performance-v1-admit-model-185015e.json
perf record -q -e instructions:u -F 20000 -o ~/.cache/ergodis/perf-c1170/admit-185015e-dense.data \
    -- taskset -c 7 "$BIN" rel-frontend-bench --cohort ascii --stage admit --variant byte \
    --definitions 512 --repeat 20000
```

`admit-model.py` needs `numpy` and `scipy`; it was run as
`uv run --with numpy --with scipy python3 …`.

## Foreign tree

The repository carries uncommitted files belonging to other work: the campaign-console mockups and
interface-review material under `analysis/`, `packages/execution-provider/src/lib.rs`,
`packages/hadamard-provider/tests/contracts.rs`,
`packages/parameterization-provider/tests/contracts.rs`, `src/hadamard_execution.rs`,
`src/partitioned_additive_join.rs`, `tests/partitioned_join_profile.rs` and
`tests/quadratic_residual_profile.rs`. Their diff was hashed at the start of this task and again at
the end: `a954fbdceb3a9ea474c3406ec70e7419a7fd02b2026f400f21197fb7b6a2df28` both times, unchanged,
and the same hash the previous report recorded. None of them was touched, staged or reverted. Every
binary in this report was built from a tree carrying them, so none is reproducible from its commit
alone; both arms of every comparison saw the same foreign tree, so it cancels in every ratio.

## What this task left under `~/.cache/ergodis/`

For the user's cache decision. Nothing was deleted and nothing is cited as evidence; the receipts
carry the hashes, and nothing large was written to `/tmp`.

Retained executables in `~/.cache/ergodis/bin/`, both with a `MANIFEST.tsv` row and a `.sha256`
sidecar:

| File | Size | Measured sha256 | rustc |
|---|---:|---|---|
| `ergodis-tools-52d48eb` | 15,135,216 | `c47db36c…b49f60156` | 1.95.0 |
| `ergodis-tools-185015e` | 15,117,608 | `59d8b1e6…857783e249` | 1.95.0 |

Under `~/.cache/ergodis/perf-c1170/`, 5.8 MB in total:

| File | Size | What it is |
|---|---:|---|
| `admit-185015e-dense.data` | 3,579,112 | the 88,000-sample profile this report cites |
| `admit-185015e.data` | 103,088 | a first, 1,000-sample profile of the same stage |
| `sources/` | 30 files | the generated single-class synthetic sources; regenerated by `admit-decompose.py` |
| `census/` | 68 files | the dumped sources and node pools the census reads; regenerated by `admit-model.py` |
| `ascii.txt`, `ascii.nodes` | 43,008 + 781,067 | the ASCII cohort's source and node pool |
| `unicode.txt`, `unicode.nodes`, `comment-string.txt`, `comment-string.nodes` | — | the same for the other two cohorts |
| `classes-28src-backup.json` | 89,536 | a superseded class receipt, kept only while the final run was in flight |
| `parity.log`, `parity-185015e.log`, `classes*.log`, `tests.log` | small | run logs |

Everything under `sources/`, `census/` and the `*.nodes` dumps is regenerated by the committed
scripts from the committed generators, so none of it is evidence and all of it is disposable. The
two `perf.data` files and the two retained executables are the ones worth a decision. The task also
inherits the eleven `perf.data` files and five retained `ergodis-tools` executables the previous
C1170 phases left; `../ergodis-dev/scripts/cache-gc.sh` has not been run, since deletion is the
user's call.

