# C1170 — the admission census brought up to the kernel, and the decomposition re-fitted at `db47ee1`

**Lane**: `ergodis`
**Date**: 2026-09-14
**Repository**: `~/src/ergodis-private` (private, no public remote), branch `main`, from `11fc4d0`

**Measurement binary**: `ergodis-tools` retained at revision `db47ee1` as `ergodis-tools-db47ee1`
(retain recipe: `../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at that
revision), measured sha256 `6e41d1d608ea72d9c998a5b9d4ff7788e9f303a44398ebd95b1eaae3fd7920ba`,
rustc 1.95.0 (59807616e 2026-04-14) read from the binary's `.comment` section, release profile,
no features. It is the kept candidate of the traversal-cursor report
(`2026-09-14-c1170-traversal-cursor.md`) and the control the handoff names for the next A/B.
Every measurement here ran under `nix develop ~/src/ergodis` (the pinned toolchain).

This is a measurement task. **No kernel code was changed**: `src/` and `tests/` are
byte-identical to `db47ee1`. What changed is the census script, which replayed the kernel as it
stood at `32a18c6` — hashing inside `insert`, walking all 32 `BUILTINS` entries, scanning the
node pool twice — and now replays the kernel as it stands; the unit list, which gained two
columns and lost one; and the synthetic source set, which gained one family.

**Commits** (all on `main`, in order):

| Commit | Contents |
|---|---|
| `1210f29` | `admit-census.py` replays the kernel at `db47ee1`; `admit-decompose.py` gains the `mixed-k` family; `builtin_iters` and `bind_one_nodes` columns, `probe_slot_reads` dropped |
| `63d6fca` | the class receipt and the re-fitted model at `db47ee1`, and the frontend README's census section |

`git diff --stat 11fc4d0 HEAD -- src/ tests/` is empty.

## Fermi, written before any coefficient was read

The stage's ASCII cost is already known from the three A/Bs since the last decomposition:
1,246,010 instructions per admission of the 43,008-byte cohort, 0.7145 of the 1,743,823 the
previous model was fitted to. So the question this run answers is not the total but the split:
which coefficients moved, by how much, and whether the re-fitted model still closes on the
cohorts out of sample.

Predicted per-unit costs, read from the three kernel changes and the compiled loops the two
optimization reports recorded, against the `185015e` coefficients:

| Unit | At `185015e` | Predicted at `db47ee1` | Why |
|---|---:|---:|---|
| a name byte through `hash_of` | 7.90 | 7.9 (unchanged) | the FNV loop is untouched; only the number of bytes hashed changes |
| a name seen for the first time | 265.88 | 40–70 | the 32-entry walk (about 200) is replaced by a length compare and a bitmap test, and `insert` is inlined into `reference` since the hash-once change |
| a node in the pool | 16.88 | 8.5–9.5 | one nine-instruction loop over a local slice instead of two passes at ten and eight |
| a node visited by the traversal | 39.95 | 33–35 | the cursor A/B measured 6.26 saved per visit |
| a definition declared | 198.17 | 180–205 | `declare` lost a field load and gained the definitions-pool push; the insert it makes is inlined or not, which the fit will say |
| a name reference, fixed part | 70.99 | 60–71 | unchanged code on the binder and probe paths; the inlined insert may move the fixed part |
| everything else | — | unchanged | no change touched `bind_list`, `bind`, `count_arguments`, the probe, `same()` or the index clear |

The census counts that change on the ASCII cohort, computed before the run: name bytes hashed
fall from 25,477 to 18,333 (7,144 fewer, the 905 first-sight re-hashes — **not** the 12,320 the
previous report claimed; see the ledger); `BUILTINS` iterations fall from 28,899 to 181 (836 of
905 first sights are rejected by the gate before any entry is read, 69 walk a range); bytes
compared against a builtin fall from 77 to 7. Visits, pushes, pool nodes, references, probes and
binders are unchanged, as the previous report predicted.

Source-level total from those coefficients: 1,290,000 to 1,350,000, against the measured
1,246,010 — a source-level Fermi has been 6 to 27 per cent high three times in this lane,
because the compiler both adds register moves to hold new invariants and removes call overhead
when a signature change inlines a callee, and the fitted coefficients are what settle where the
inlining saving landed. The coefficients above are the prediction to be contradicted.

## Status

Complete. The census replays the kernel at `db47ee1`; the decomposition was re-measured on
thirty-three synthetic sources against `ergodis-tools-db47ee1`; the model was re-fitted with a
unit list corrected by an independent check. **The ASCII cohort predicts at +0.91 per cent of its
measured 1,246,011 instructions**, unicode at +0.81 per cent and comment-string at +1.98 per
cent, all out of sample; every synthetic row is inside 1.1 per cent, and the leave-one-family-out
residuals for the definition, node, ref-binder and mixed families are 1 to 3 per cent where the
first fit of this run had 16 to 23. The closure on the cohorts is wider than the `185015e`
model's −0.32 / −0.09 / +0.81, and the ledger says why; the coefficients are better identified
than that model's were, which is what pricing needs.

**What carries the ASCII admission stage now, in instructions per unit and share:**

1. **The traversal, 31.98 per visited node over 8,320 — 21.2 per cent.** Down from 39.95; the
   cursor A/B measured 6.26 of the drop directly, the rest is the split with the pool scan.
2. **The fixed part of a reference, 71.49 over 3,520 — 20.0 per cent.** Unchanged (70.99 before).
3. **Name hashing, 7.89 per byte over 18,333 bytes — 11.5 per cent.** The same FNV loop (7.90);
   the bytes fell by 7,144, the 905 first-sight re-hashes.
4. **A definition declared, 194.23 over 576 — 8.9 per cent.** 198.17 before.
5. **The one pool scan, 5.53 per node over 12,288 — 5.4 per cent**, down from 16.88 for two
   passes; then `same()` at 12.59 per byte (5.1), first sight at 64.08 (4.6, down from 13.8),
   binder lists at 80.41 (4.5), the `Apply` arm at 42.33 (3.4), a `bind_one` element at 40.19
   (3.3), an occupied probe slot at 45.73 (2.9) and `count_arguments` at 12.88 per node (2.8).
6. **A name seen for the first time is 64.08 instructions, 4.6 per cent of the stage**, down from
   265.88. The `BUILTINS` walk behind the gate runs for 69 of the 905 ASCII first sights (181
   entries examined at 20.67 each, 0.3 per cent); the other 836 are rejected by the length-bitmap
   test before any entry is read.

Vibe check: good, after a detour. The first fit of the run missed by 3.7 per cent on ASCII and
9.5 on comment-string because the gate had turned a constant into a unit; the second closed the
synthetic rows and left comment-string at 3.5; the independent check found the confound and the
redundant column, and one new synthetic family plus two column changes brought every family's
holdout under 4 per cent except the pool-heavy ones. The ranking for the next change is clear and
unchanged in shape: traversal, reference fixed cost, hashing.

## Method

Thirty-three single-class synthetic sources — the thirty of the decomposition report plus a
`mixed-k` family described below — regenerated by `admit-decompose.py`, five interleaved rounds
pinned to CPU 5 under the non-multiplexing event set
`instructions,cycles,branches,branch-misses,page-faults,minor-faults`, two-point differencing,
admission = `admit` − `parse` on the same source paired by round, and the driver's admission
summary asserted against every builder's declared summary before any counter was read. One-minute
load average 2.31 at the start and 2.25 at the end; every operation's enabled fraction 100 per
cent; 3 minutes 27 seconds of rounds after calibration. Receipt
`analysis/rel-frontend/performance-v1-admit-classes-db47ee1.json`; solved model
`performance-v1-admit-model-db47ee1.json`. A first run of the same protocol on the original thirty
sources (00:26–00:29 UTC) produced the two intermediate fits described under "How the unit list
changed"; its receipt is superseded by the final one and is not committed, and its rows agree with
the final run's to within the round-to-round standard deviations.

### The census changes, each a statement of `admit.rs` at `db47ee1`

- `insert` takes the caller's full hash; `declare` hashes the definition name once and passes it.
  The re-hash count is gone from the census rather than modelled.
- `is_builtin` is the gated check: a length compare (`length − 1 ≥ 15` rejects, with the
  zero-length wraparound spelled out in Python), a per-first-byte length bitmap, then a walk over
  the entries sharing the first byte, each compared from its second byte on a length match. The
  census derives the bitmap, the ordering and the ranges from the same 32-entry table the way the
  kernel's `const` blocks do, and counts length rejects, gate rejects, range walks, entries
  examined and byte compares (executed compares, including the one that ends a loop on a
  mismatch) separately.
- One scan of the node pool; each definition's id is pushed to the definitions pool, and the body
  checks iterate that pool. The traversal stack is never cleared, because the kernel's is a fixed
  slice with a length carried by value that starts at zero for every body.

The census summary gate held on all thirty-three synthetic sources and all three cohorts. The
counts that could change on the ASCII cohort did so by exactly the amounts the kernel changes imply
(hash calls 5,961 → 5,056, bytes 25,477 → 18,333; `BUILTINS` iterations 28,899 → 181), and every
other count — visits 8,320, pushes 8,576, pool nodes 12,288, references 3,520, binders 896 — is
unchanged, as the traversal-cursor report predicted.

### How the unit list changed, and why

1. **`builtin_iters` added** (from the first fit). Under the old kernel every first sight walked
   all 32 entries, so the walk was a constant inside `first_sight`. Behind the gate the walk runs
   only for a name whose first byte and length match an entry, and how many entries it examines
   varies by source: the six-byte `ref-distinct` names begin with `a`, four builtins begin with
   `a` (lengths 3, 6, 6, 7), so each of those 3,840 first sights walks four entries, while the
   fourteen-byte names walk none. Fitted without the column, the model closed nowhere: hash 3.94
   per byte instead of 7.9, `definition-6`/`-16` at +5.5 / −6.5 per cent, `ref-distinct-6`/`-14`
   at −7.7 / +7.3, ASCII +3.7, comment-string +9.5. With it, hash returned to 7.91 and both pairs
   closed to a quarter of a per cent, leaving the cohorts at +0.68 / +0.67 / +3.48.
2. **`probe_slot_reads` dropped** (from the independent check). A probe reads one slot per
   occupied slot and then the empty one, and reaching the empty one is exactly a first sight, so
   `probe_slot_reads = probe_symbol_loads + first_sight` on every source (ASCII 789 + 905 = 1,694).
   The column was a null direction of the design, and the solver had resolved it arbitrarily at
   44.24 per slot read with `probe_symbol_loads` at zero. `probe_symbol_loads` now carries the
   per-occupied-slot cost and reads as a physical number.
3. **`bind_one_nodes` added** (from the check). It differs from `binds` on every `_` or `x in d`
   element (`header-4` has 6,368 of them and no binds; the cohorts 1,024 against 896) and was the
   largest counted unit with no column.
4. **The `mixed-k` family added** (from the check's diagnosis). The comment-string residual was a
   confound, not a unit: the four families that pin the per-definition cost (`definition-*`,
   `header-*`) have bodies that are one inert literal, `node-*` are half inert, and every other
   family has no inert visit, so the per-definition cost and the inert part of the per-visit cost
   were sampled at 0, 50 and 100 per cent and nowhere between, while the comment-string cohort is a
   third inert (640 of its 1,920 visits are literals that the traversal pops, tests and drops).
   `mixed-k` is `def f(x) = x and … and 1 and …` with k of eight body terms literal, k = 1, 3, 5,
   at a nearly fixed definition count: rows at 1/15, 3/15 and 5/15 inert. Its three rows fit to
   −0.5 / −0.5 / −0.6 per cent and its own holdout is −1.04.

## Results

### Every synthetic row, measured at `185015e` and at `db47ee1`

The ratio is what the three kernel changes did to each pure shape; the standard deviation is over
five rounds; the residual is the final model's.

| Source | `185015e` | `db47ee1` | ratio | sd | first sights | residual |
|---|---:|---:|---:|---:|---:|---:|
| intercept-1024 | 658 | 638 | 0.9691 | 6 | 0 | +0.31 % |
| intercept-2048 | 890 | 868 | 0.9749 | 3 | 0 | −0.42 % |
| intercept-4096 | 1,335 | 1,313 | 0.9835 | 3 | 0 | +0.03 % |
| intercept-8192 | 2,226 | 2,214 | 0.9947 | 4 | 0 | −0.07 % |
| intercept-16384 | 4,021 | 4,013 | 0.9979 | 7 | 0 | −0.07 % |
| intercept-32768 | 7,629 | 7,603 | 0.9966 | 4 | 0 | +0.03 % |
| intercept-65536 | 14,782 | 14,769 | 0.9991 | 28 | 0 | +0.18 % |
| definition-6 | 965,161 | 833,307 | 0.8634 | 11 | 0 | +0.27 % |
| definition-16 | 717,529 | 638,445 | 0.8898 | 22 | 0 | +0.00 % |
| node-1 | 1,216,578 | 806,690 | 0.6631 | 2 | 0 | +0.03 % |
| node-4 | 698,126 | 463,207 | 0.6635 | 3 | 0 | +0.03 % |
| ref-binder-1 | 1,504,955 | 1,236,092 | 0.8213 | 3 | 0 | +0.02 % |
| ref-binder-8 | 1,134,526 | 1,012,335 | 0.8923 | 11 | 0 | +1.07 % |
| ref-repeat-4 | 1,465,753 | 1,301,698 | 0.8881 | 8 | 37 | +0.42 % |
| ref-repeat-12 | 1,160,402 | 1,076,005 | 0.9273 | 8 | 19 | −0.68 % |
| ref-definition-4 | 1,426,792 | 1,277,472 | 0.8953 | 2 | 0 | +0.42 % |
| ref-definition-12 | 1,163,746 | 1,084,951 | 0.9323 | 10 | 0 | −0.67 % |
| ref-distinct-6 | 2,635,498 | 1,344,327 | **0.5101** | 11 | 3,840 | −0.05 % |
| ref-distinct-14 | 1,613,748 | 741,889 | **0.4597** | 9 | 2,240 | +0.00 % |
| binders-2 | 1,513,912 | 1,332,243 | 0.8800 | 3 | 0 | −0.09 % |
| binders-4 | 1,575,261 | 1,358,756 | 0.8626 | 2 | 0 | +0.39 % |
| binders-8 | 1,688,865 | 1,450,116 | 0.8586 | 2 | 0 | −0.31 % |
| apply-1 | 1,718,972 | 1,529,838 | 0.8900 | 10 | 44 | −0.15 % |
| apply-3 | 2,066,436 | 1,804,637 | 0.8733 | 3 | 28 | +0.28 % |
| header-4 | 1,455,774 | 1,204,272 | 0.8272 | 7 | 0 | −0.06 % |
| header-12 | 1,902,138 | 1,559,907 | 0.8201 | 4 | 0 | +0.05 % |
| qualified-8 | 1,776,836 | 1,080,533 | 0.6081 | 7 | 1,194 | +0.14 % |
| qualified-32 | 1,658,742 | 991,637 | 0.5978 | 6 | 512 | −0.01 % |
| mixed-1 | — | 1,220,579 | — | 5 | 0 | −0.47 % |
| mixed-3 | — | 1,081,673 | — | 4 | 0 | −0.54 % |
| mixed-5 | — | 942,765 | — | 1 | 0 | −0.63 % |
| module | 1,437,514 | 973,176 | 0.6770 | 5 | 934 | −0.00 % |
| abstraction | 1,435,753 | 1,165,943 | 0.8121 | 4 | 0 | +0.51 % |
| **cohort-ascii** | 1,743,823 | **1,246,011** | **0.7145** | 4 | 905 | **+0.91 %** |
| cohort-unicode | 1,972,176 | 1,431,947 | 0.7261 | 4 | 905 | +0.81 % |
| cohort-comment-string | 560,759 | 371,997 | 0.6634 | 11 | 384 | +1.98 % |

The ASCII cohort reproduces the composed A/B (1,246,010.29 with interval [1,246,007.46,
1,246,013.12] there; 1,246,011 here and 1,246,008 in the first run), which is the check that the
class runs measured the same binary the A/B did.

### The per-unit costs, both revisions

| Unit | `185015e` | `db47ee1` | Fermi | What moved |
|---|---:|---:|---:|---|
| a name byte through `hash_of` | 7.90 | **7.89** | 7.9 | nothing; 7,144 fewer bytes on ASCII |
| a name seen for the first time | 265.88 | **64.08** | 40–70 | the 32-entry walk is gone and `insert` is inlined; inside the Fermi's range |
| a `BUILTINS` entry examined behind the gate | — | 20.67 | — | new unit; 181 on ASCII |
| a node in the pool | 16.88 | **5.53** | 8.5–9.5 | one hoisted pass instead of two; below the loop reading, joint with visits |
| a node visited by the traversal | 39.95 | **31.98** | 33–35 | the cursor (6.26 measured) plus the split with the scan |
| a definition declared | 198.17 | 194.23 | 180–205 | inside the range; the `declare` and `check_definition` header chains are charged here |
| a module declared | 180.54 | 103.02 | — | one row pins it; joint with the first-sight unit in that row |
| a name reference, fixed part | 70.99 | 71.49 | 60–71 | unchanged |
| a binder list walked | 111.26 | 80.41 | unchanged | part moved to the new `bind_one` column |
| a `bind_one` element | — | 40.19 | — | new column; was inside `binds` and `bind_list_calls` |
| a node load inside `bind_list` | 9.11 | 6.28 | unchanged | |
| a binder recorded | 43.06 | 34.17 | unchanged | part moved to `bind_one` |
| a binder examined by the scan | 2.08 | 5.12 | unchanged | closer to the seven-instruction loop; still joint with `references` |
| an occupied index slot read by a probe | (0.00, with `probe_slot_reads` at 38.83) | 45.73 | — | the identified per-slot cost after the redundant column was dropped |
| a byte compared by `same()` | 12.73 | 12.59 | unchanged | carries the per-call cost of `same()` at a source-dependent rate |
| an `Apply` node | 27.55 | 42.33 | unchanged | joint with `count_arg_nodes` |
| a node walked by `count_arguments` | 26.21 | 12.88 | unchanged | closer to the seven-instruction body |
| an index slot cleared | 0.1096 | 0.1097 | unchanged | |
| one admission | 131.76 | 156.37 | unchanged | |
| `builtin_bytes`, `colon_nodes` | 45.65, 0 | 0, 0 | — | driven to zero by non-negativity: `builtin_bytes` is zero on every synthetic row, and `colon_nodes` equals `stale_marks` on every row that has either |

Three coefficients check against the compiled code and agree: the hash at 7.89 against the
seven-instruction FNV loop; the index clear at 0.1097 per slot against the libc `memset`; and the
pool scan plus traversal sum, 5.53 × 12,288 + 31.98 × 8,320 = 334,000, against the `185015e` sum
of 539,745 less the three measured savings (98,000 for the removed pass at eight per node, 49,343
for the hoist, 52,062 for the cursor), 340,340 — within two per cent. The split between the two
is what the fit does not pin, and the header and qualified holdouts (44 and 31 per cent) say so.

### Where the ASCII stage goes now

| Unit | Count | Instructions | Share | at `185015e` |
|---|---:|---:|---:|---:|
| nodes visited by the traversal | 8,320 | 266,044 | 21.2 % | 19.1 % |
| name references, fixed part | 3,520 | 251,662 | 20.0 % | 14.4 % |
| name bytes hashed | 18,333 | 144,619 | 11.5 % | 11.6 % |
| definitions declared | 576 | 111,878 | 8.9 % | 6.6 % |
| nodes in the pool, scanned once | 12,288 | 67,938 | 5.4 % | 11.9 % |
| name bytes compared | 5,117 | 64,430 | 5.1 % | 3.7 % |
| names seen for the first time | 905 | 57,996 | 4.6 % | 13.8 % |
| binder lists walked | 704 | 56,609 | 4.5 % | 4.5 % |
| `Apply` nodes | 1,024 | 43,348 | 3.4 % | 1.6 % |
| `bind_one` elements | 1,024 | 41,150 | 3.3 % | — |
| occupied index slots probed | 789 | 36,079 | 2.9 % | (3.8 % as slot reads) |
| argument nodes counted | 2,688 | 34,631 | 2.8 % | 4.1 % |
| binders recorded | 896 | 30,621 | 2.4 % | 2.2 % |
| binder entries examined | 4,928 | 25,244 | 2.0 % | 0.6 % |
| node loads inside `bind_list` | 2,048 | 12,861 | 1.0 % | 1.1 % |
| modules declared | 64 | 6,593 | 0.5 % | 0.7 % |
| `BUILTINS` entries examined | 181 | 3,741 | 0.3 % | — |
| index slots cleared | 16,384 | 1,798 | 0.1 % | 0.1 % |
| one admission | 1 | 156 | 0.0 % | 0.0 % |

The reference census is unchanged (1,920 binder hits, 905 first sights, 505 base hits, 126
builtin hits, 64 definition hits). The `BUILTINS` gate outcome on the ASCII cohort: 836 of 905 first
sights rejected by the length bitmap, 69 walk a range (181 entries examined, 75 byte compares
executed, two matches: `sum` and `count`); no name is longer than fifteen bytes. On unicode the
same 905 first sights are 448 length rejects (Greek and CJK spellings run past fifteen bytes),
455 bitmap rejects and two walks, `sum` and `count` themselves. On comment-string all 384 are
bitmap rejects.

### Leave-one-family-out, final model

Worst residual on the withheld rows: ref-distinct −0.89, ref-definition −0.92, ref-repeat −0.93,
mixed −1.04, node +1.47, ref-binder +3.05, definition +3.26, abstraction +3.73, apply −5.03,
module −9.89, binders −13.71, qualified +30.77, header +43.69, intercept +610 (the intercept rows
are the only evidence for the fixed term and the index slope). The first fit of this run had
definition +16.42, node −23.20 and ref-binder −22.73; the mixed family is what moved them. The
header and qualified families are the two pool-heavy shapes, and withholding either leaves the
pool-scan/traversal split unpinned. Condition number 2.2 × 10^18; the design remains numerically
singular, now for the all-zero `builtin_bytes` column and the `colon_nodes`/`stale_marks` identity.

## The independent check

An Opus sub-agent read `admit.rs` at `db47ee1` beside the census line by line, re-ran the model
script from the receipt into a scratch directory (byte-identical console output; coefficients and
all vectors equal to the committed JSON), confirmed both census gates and the enabled fraction on
all 66 operations, and confirmed the ASCII agreement with the composed A/B (2.66 instructions,
2.1 parts per million). Its verdict on the replay: control flow, evaluation order and every
resolution outcome match the kernel, including `compatible`, the arity-fixing write-back, the
stale-binder escape path, the bare-expression fallback and `bind_list`'s quadratic re-descent.
It found one counting defect — `builtin_bytes` counted matching bytes rather than executed
compares, immaterial since the column fits to zero — now fixed; the redundant `probe_slot_reads`
column and the missing `bind_one_nodes` column, both now applied; and the definition/inert-visit
confound behind the comment-string residual, with the `literal`-fraction family as the test that
would settle it, now built as `mixed-k`. It also listed counted units that still have no column
and are collinear with existing ones on this source set (`insert_slot_reads`, `stale_marks`,
`same()`'s per-call cost, the per-arm traversal costs other than `Apply` and `Colon`, and the
`declare`/`check_definition` header chains, which are exactly in the span of the definition,
module, binder-list and colon columns on every row but unicode). Its report is not committed; its
findings are recorded here and in the ledger.

## Gates and replay

| Gate | Command | Outcome |
|---|---|---|
| Kernel unchanged | `git diff --stat 11fc4d0 HEAD -- src/ tests/` | empty |
| Census against the kernel | inside `admit-model.py` | all thirty-three synthetic sources reproduce their builders' declared summaries; all three cohorts reproduce the driver's |
| New family admits as declared | the driver at `--repeat 1` on each `mixed-k` source before the run | `mixed-1/3/5` summaries equal the builder's |
| Event set | `instructions,cycles,branches,branch-misses,page-faults,minor-faults` | 100.00 per cent enabled on every operation |
| ASCII agreement with the A/B | class receipt against `performance-v1-admit-composed-db47ee1.json` | inside the A/B's interval |
| Independent reproduction of the fit | the model script re-run from the receipt by the checker | coefficients and vectors equal |

Replay, from `~/src/ergodis-private`; `$BIN` is `ergodis-tools` retained at `db47ee1` by
`../ergodis-dev/scripts/retain-bin.sh tasks/tools ergodis-tools` at that revision. The scripts
re-execute under the pinned toolchain when run inside `nix develop ~/src/ergodis`.

```sh
nix develop ~/src/ergodis -c python3 analysis/rel-frontend/admit-decompose.py --binary "$BIN" \
    --rounds 5 --cpu 5 --sources ~/.cache/ergodis/perf-c1170/sources \
    --out analysis/rel-frontend/performance-v1-admit-classes-db47ee1.json
nix develop ~/src/ergodis -c uv run --with numpy --with scipy python3 \
    analysis/rel-frontend/admit-model.py \
    --classes analysis/rel-frontend/performance-v1-admit-classes-db47ee1.json \
    --binary "$BIN" --work ~/.cache/ergodis/perf-c1170/census \
    --out analysis/rel-frontend/performance-v1-admit-model-db47ee1.json
```

## Foreign tree

The repository carries the same uncommitted foreign files the previous C1170 reports name: the
campaign-console mockups and interface-review material under `analysis/`,
`packages/execution-provider/src/lib.rs`, `packages/hadamard-provider/tests/contracts.rs`,
`packages/parameterization-provider/tests/contracts.rs`, `src/hadamard_execution.rs`,
`src/partitioned_additive_join.rs`, `tests/partitioned_join_profile.rs` and
`tests/quadratic_residual_profile.rs`. Their diff hashed
`a954fbdceb3a9ea474c3406ec70e7419a7fd02b2026f400f21197fb7b6a2df28` at the start of this task,
the same hash the four previous reports recorded. None was touched, staged or reverted; every
commit here was made with an explicit whole-file pathspec. No binary was built by this task.

## Mystery ledger

1. **Settled: the previous report overstated the duplicate hashing.** It said 1,545 of 5,961
   hash calls, 12,320 bytes, were recomputations. The census at `32a18c6` counted 3,520 reference
   hashes, 1,545 insert hashes and 896 binder hashes, but only the 905 inserts made from
   `reference` re-hashed a name already hashed; the 640 made from `declare` hashed their name
   once, inside `insert`. The true duplicate count was 905 calls and 7,144 bytes, 56,400
   instructions at 7.9 per byte, 3.2 per cent of the stage — not 97,000 and 5.6. The hash-once A/B
   nonetheless measured 0.9525 (82,800 saved), because the signature change made `insert`
   inlinable; so that candidate's price was right for the wrong reason, and the optimizations
   report's lesson stands more strongly: the re-hash was worth 56,000 and the inlining 27,000.
2. **Settled: the gate turned a constant into a unit.** With every first sight walking 32 entries
   the walk was inside `first_sight`; behind the gate it varies by source, needs a column, and
   without one the solver moved its cost into the hash coefficient (3.94 instead of 7.9). The
   general form of the lesson: a kernel change that makes formerly constant work conditional
   changes the model's unit list, not only its coefficients, and the census must be re-read for
   new degrees of freedom every time the kernel moves.
3. **Settled: what the first sight costs now.** 64.08 instructions: the gate (a length compare and
   a bitmap test), the empty-slot read that ends the probe, and the inlined insert (capacity
   test, 16-byte push, a probe for an empty slot, the index store). The first fit of this run
   put it at 18.97 by giving the empty-slot read to the redundant `probe_slot_reads` column at
   44; the two numbers are the same total, and the final one is the readable split.
4. **Settled: the comment-string residual was a confound, and where it stands.** Per-definition
   cost against inert visits, sampled at 0, 50 and 100 per cent by the original families, with
   the cohort at a third. The `mixed-k` family samples 7, 20 and 33 per cent; the residual fell
   from +3.48 to +1.98, the definition, node and ref-binder holdouts from 16–23 to 1–3 per cent.
   The remaining +2 per cent on comment-string, and the +0.9 on ASCII, are of one sign and of the
   order of a constant 8,000 to 11,000 per admission or 15 to 20 per definition; the `mixed`
   rows are under-predicted by the same order (−0.5 per cent, 5,700 to 6,000 each). The
   evidence gap is a per-arm traversal split — the checker found that an explicit inert-atom
   column improves both the cohort and the synthetic residuals, but on the original set the
   solver then zeroed `visits`; with `mixed-k` in the set that column may now be identifiable.
   Not tried here, because the ranking does not depend on it.
5. **Open, unchanged from the decomposition report: the split between the binder scan and the
   fixed per-reference cost is not identified.** 5.12 per binder examined against a
   seven-instruction loop, 71.49 fixed. The whole binder-scan term is 2.0 per cent.
6. **Open: the pool-scan/traversal split.** 5.53 per pool node against a nine-instruction loop
   reading, 31.98 per visit; their sum checks to two per cent against the measured savings, the
   header and qualified holdouts (44 and 31 per cent) say the split does not. Every family but
   those two leaves exactly two unvisited nodes per definition. The evidence gap is a family that
   varies pool nodes per visit continuously, which `header-k` does at k = 4 and 12 only.
7. **Open, from the check: five counted units have no column and are collinear on this set** —
   `insert_slot_reads`, `stale_marks` (equal to `colon_nodes` wherever either is non-zero, so a
   multi-binder abstraction would be mispriced), `same()`'s per-call cost (the bytes-per-call
   ratio differs two-fold between cohorts, so the per-byte coefficient carries it at a
   source-dependent rate), the per-arm traversal costs, and the header chains. Each needs a
   family that varies it independently; none affects the ranking below.
8. **Not a mystery: `colon_nodes` fits to zero although the `Colon` arm does work.** It equals
   `stale_marks` on every row, and the abstraction family is one row; the arm's cost is inside
   `binds`, `bind_list_calls` and `visits` for that row. A change to the relational-abstraction
   arm must be priced from the compiled loop, not from this model.

## Ranked candidates, priced against the new ASCII stage of 1,246,011 instructions

The model ranks; the compiled loop prices, as the last two reports did. The checker's caution
binds: a predicted saving under about five per cent of the stage is inside the model's
out-of-sample error and needs its own A/B to be believed.

1. **The traversal's remaining per-visit cost, 31.98 × 8,320 = 266,000, 21.2 per cent.** The
   pop's six field loads of a 32-byte node when most arms use two or three (traversal-cursor
   report, ledger item 7): a kind-first load priced there at two to four per visit, 17,000 to
   33,000, with the second dependent load before the dispatch as the cycle risk. Second: the
   register moves the cursor added (about two per visit). Both are below the five-per-cent
   line and need the A/B, not the model.
2. **The fixed part of a reference, 71.49 × 3,520 = 252,000, 20.0 per cent.** Not yet annotated.
   Entry, the counter, the hash setup, the binder-scan setup and the probe setup; the 1,920
   binder hits return before the probe and still pay the whole fixed part. The evidence gap is
   the `perf annotate` of `admit::reference` bucketed by address range that neither this task nor
   the last two ran.
3. **`declare` at 194 per definition, 8.9 per cent** (previous ledger item 6): annotate first.
   The check adds that the `declare` and `check_definition` header chains (1,088 node loads on
   ASCII) are charged to this coefficient and to `bind_list_calls`, which is why both read high.
4. **Name hashing, 7.89 × 18,333 = 145,000, 11.5 per cent.** A byte-at-a-time FNV loop with a
   bounds test per byte. The bounds test is removable by slicing once; a wider hash changes the
   symbol's 16-bit filter and is a representation change. Priced only after the annotate of
   `reference`, since the hash is inlined there.
5. **Not worth doing, priced so it is not proposed.** The index clear (1,798, 0.14 per cent);
   the `BUILTINS` range walk (3,741, 0.3 per cent); the `take`/restore of the two pools; the dead
   `scopes` pool's three clears (inside `const` at 156 per admission).

## What this task left under `~/.cache/ergodis/`

For the user's cache decision. Nothing was deleted, nothing large went to `/tmp`, and no
`~/.cache` path is cited as evidence.

| Path | What it is |
|---|---|
| `perf-c1170/sources/` | 33 synthetic sources, three new; regenerated by `admit-decompose.py` |
| `perf-c1170/census/` | the dumped sources and node pools the census reads, regenerated by `admit-model.py` |
| `perf-c1170/census-check/` | the checker's scratch reproduction of the fit and its dumps |
| `perf-c1170/classes-db47ee1-run1.json`, `model-db47ee1-run1.json` | the superseded first run's receipt and the two intermediate fits' inputs |
| `perf-c1170/classes-db47ee1*.log`, `model-db47ee1*.log` | run logs |

No retained executable and no profile was added. `../ergodis-dev/scripts/cache-gc.sh` has not
been run, since deletion is the user's call.
