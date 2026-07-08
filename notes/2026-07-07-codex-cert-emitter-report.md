# C12 — Per-q escape certificate emitter (`cert`/`certcheck`) — report

Date: 2026-07-07 (opus delegate; Codex out of tokens). Task: queue entry **C12** in
`notes/2026-07-07-codex-task-queue.md`. Route C of `2026-07-07-projcap-open-math-plan.md`,
phase 1: turn the computed escape ladder into per-q formal certificates.

## Deliverable one-liner

Two new **additive** modes in `notes/2026-07-06-grid-cap-solver.rs`: `cert <q>` (emit a
per-size-3-class escape P-certificate) and `certcheck <q> <file>` (independent rules-only
re-verification). Required ladder **q=5,7,9,11,13 DONE + certcheck PASS**; attempted
**q=17 DONE + PASS** and **q=19 DONE + PASS**. Cert files in `notes/certs/`.
All escape histograms reproduce the `escape`/`esc`-mode reference exactly; existing-mode
output byte-identical to the pre-edit binary. **Every witness at every q is ON-conic.**

## What was added (additive only)

`notes/2026-07-06-grid-cap-solver.rs`, new code only (no existing mode/path touched):

- `masks_of`, `avail_cells`, `is_legal_position`, `fit_conic`, `fmt_cells` — rules/geometry
  helpers (legality from the same `rc_mask`/`line_mask` machinery the solver already uses).
- `Solver::value_cells` — game value of an arbitrary legal position (early-break, canon-memoized).
- `CertBook` + `build_book` — build the responder strategy DAG over ACTUAL positions.
- `solve_cert` (mode `cert`) and `verify_class`/`check_cert` (mode `certcheck`), plus the two
  `main` dispatch branches and a header mode-doc block.
- One new `use std::io::{BufWriter, Write};`.

### Certificate shape vs. Lean `FiniteBuildGame`

Node 0 of each class is the witness size-4 P-position `S4 = insert p S3`. Every book node is an
even P-position. For each non-terminal node, EVERY legal mover move `x` gets a reply row `(x, y)`
whose grandchild `P+{x,y}` is again a book node (a P-position); terminal nodes are even maximal
caps with no legal move. This is exactly `isP_of_replyStrategy` with `Good = "node ∈ book"`
(terminals satisfy the reply obligation vacuously; sizes strictly grow ⇒ well-founded), and it
carries the recursive `PairReplyBook`/`PCert` reading directly (per-node rows = a one-position
`PairReplyBook`; the child node supplies the grandchild's `PCert`). The DAG is deduped by actual
sorted cell set (transpositions merge), so it is compact.

## Format spec (exact grammar of `notes/certs/gridcap-q<q>.cert`)

Line-oriented plain text, one record per line, tokens space-separated, `#`-lines are comments.
Cells are `r,c` (0-based, `r`=row in F_q, `c`=col in F_q). Records:

```
# gridcap-escape-certificate v1
q <q>
field prime                              # OR:  field GF<q> base <p> poly <c0 c1 ... 1>   (monic irred over F_p; q=9 -> "1 0 1" = x^2+1 over F_3)
classes <K>
total <q^2-9q+21>
CLASS <ci> s3 <r,c> <r,c> <r,c> escape <e> witness <r,c|none> onconic <0|1|-> book <ok|capped|none> nodes <N> rows <R> terms <T>
N <ci> <nid> <r,c> <r,c> ...             # book node nid of class ci = even P-position (sorted cell list); node 0 = witness position S3+p
R <ci> <nid> <mr,mc> <yr,yc> <cid>       # from node nid: mover move (mr,mc), responder reply (yr,yc) -> child node cid = node + {move,reply}
T <ci> <nid>                             # node nid is terminal: no legal move, even size
# END classes=<..> onconic-witness=<..> offconic-witness=<..> capped-books=<..>
```

Grammar notes: `field`/`total`/comment/`# END` lines are ignored by the checker. `CLASS` fields
are at fixed token positions (parser reads `s3` = 3 cells, then keyword/value pairs). A class with
`book capped` (node cap hit) or `book none` (escape=0, would falsify (ESC)) carries the CLASS line
but no `N`/`R`/`T` body; `certcheck` reports these as SKIP, not FAIL. Node ids are 0-based, dense,
unique within a class; row `cid` references a node defined by an `N` line in the same class.

## certcheck semantics (GAME RULES ONLY — no game values)

Per `book ok` class it verifies, using only the board legality masks (never the value memo):

1. node 0 cells == sorted(S3 ∪ witness), and that position is a legal 4-cap.
2. `onconic` flag agrees with the conic geometry of S3 (Möbius-graph membership; geometry, not values).
3. every node has even size; terminal ⟺ no legal move and no rows; non-terminal has ≥1 legal move.
4. **closure**: a non-terminal node's reply rows' mover-moves equal its legal-move set exactly
   (each covered once, none missing, none extra).
5. per row `(x,y,cid)`: `x` legal from P (closure), `y` legal from P+x, child node `cid` cells ==
   sorted(P+x+y), and `|child| = |P|+2`.
6. declared per-class `(nodes,rows,terms)` == actual parsed counts.

Well-foundedness is automatic (each row grows the size by 2). Soundness of the checker itself was
adversarially tested (below).

## Per-q results

| q  | field   | classes | witnesses on/off-conic | book nodes | rows    | terms  | file size | certcheck |
|---:|:--------|--------:|:-----------------------|-----------:|--------:|-------:|----------:|:----------|
| 5  | prime   | 1       | 1 / 0                  | 1          | 0       | 1      | 809 B     | PASS      |
| 7  | prime   | 3       | 3 / 0                  | 6          | 6       | 3      | 1.2 KB    | PASS      |
| 9  | GF(9)   | 5       | 5 / 0                  | 33         | 66      | 13     | 3.3 KB    | PASS      |
| 11 | prime   | 8       | 8 / 0                  | 204        | 401     | 108    | 16 KB     | PASS      |
| 13 | prime   | 12      | 12 / 0                 | 1 763      | 3 975   | 966    | 158 KB    | PASS      |
| 17 | prime   | 21      | 21 / 0                 | 100 526    | 232 221 | 54 879 | 11 MB     | PASS      |
| 19 | prime   | 27      | 27 / 0                 | 740 799    | 1 497 427 | 570 772 | 85 MB   | PASS      |

- **Every witness is ON-conic** in every class of every completed q — consistent with the (ON)
  refinement (`2026-07-07-conic-localization-onconic-escape.md`: `onP ≥ 1` in all computed data),
  including the q=17 min-escape classes (escape 5) where onP collapses to 1.
- "book nodes/rows/terms" are file totals over all classes (the DAG is deduped by actual position).
- q=5 has the witness S4 already maximal (size q−1=4), so node 0 is a terminal — a one-line book.

## Escape-histogram cross-check (cert vs `escape`/`esc` reference) — all MATCH

`cert` prints the same escape summary + histogram line as `escape`/`esc`; compared directly:

| q  | cert histogram              | reference (`escape`/`esc` / q17,q19 logs) | match |
|---:|:----------------------------|:------------------------------------------|:------|
| 5  | `1:1`                       | `1:1`                                     | ✓     |
| 7  | `7:3`                       | `7:3`                                     | ✓     |
| 9  | `13:3 21:2`                 | `13:3 21:2`                               | ✓     |
| 11 | `13:6 18:2`                 | `13:6 18:2`                               | ✓     |
| 13 | `46:3 47:6 49:3`            | `46:3 47:6 49:3`                          | ✓     |
| 17 | `5:3 10:12 11:6`            | `5:3 10:12 11:6` (esc gate report / q17 log) | ✓  |
| 19 | `211:27`                    | `211:27` (esc gate report / q19 log)      | ✓     |

The full q=17 and q=19 `cert` summary lines also reproduce the reference `escape` summary
verbatim (root=P, min/max escape, parity-proof verdict): q=17 `min-escape=5 max-escape=11
... parity-proof=BREAKS`, q=19 `min-escape=211 max-escape=211 ... parity-proof=HOLDS (all
bad even)`.

The per-class `escape=<e>` metadata on each CLASS line is the same count used to pick the witness,
so witness-existence and the escape count are consistent by construction (witness is a P child ⇒
escape ≥ 1 in every class of every q, matching the `min-escape ≥ 1` root-P verdict).

## certcheck negative tests (the checker is not vacuously passing)

Against `certs/gridcap-q9.cert`:

- **illegal reply** (patched one `R` reply cell to an occupied cell): `certcheck RESULT: FAIL`
  — `class 0 node 0: reply 0 illegal after move 41`.
- **closure violation** (dropped one `R` row): `certcheck RESULT: FAIL`
  — `class 0 node 0: reply-book moves [52, 65, 78] != legal moves [41, 52, 65, 78] (closure)`.
- **wrong q argument** (`certcheck 11` on the q=9 file): `certcheck RESULT: FAIL — header q=9 != requested q=11`.

## certcheck output verbatim (completed q)

```
certcheck q=5 file=certs/gridcap-q5.cert  classes(parsed)=1 declared=1  PASS=1 FAIL=0 SKIP(capped/none)=0  nodes=1 rows=0 terms=1
certcheck RESULT: PASS
certcheck q=7 file=certs/gridcap-q7.cert  classes(parsed)=3 declared=3  PASS=3 FAIL=0 SKIP(capped/none)=0  nodes=6 rows=6 terms=3
certcheck RESULT: PASS
certcheck q=9 file=certs/gridcap-q9.cert  classes(parsed)=5 declared=5  PASS=5 FAIL=0 SKIP(capped/none)=0  nodes=33 rows=66 terms=13
certcheck RESULT: PASS
certcheck q=11 file=certs/gridcap-q11.cert  classes(parsed)=8 declared=8  PASS=8 FAIL=0 SKIP(capped/none)=0  nodes=204 rows=401 terms=108
certcheck RESULT: PASS
certcheck q=13 file=certs/gridcap-q13.cert  classes(parsed)=12 declared=12  PASS=12 FAIL=0 SKIP(capped/none)=0  nodes=1763 rows=3975 terms=966
certcheck RESULT: PASS
certcheck q=17 file=certs/gridcap-q17.cert  classes(parsed)=21 declared=21  PASS=21 FAIL=0 SKIP(capped/none)=0  nodes=100526 rows=232221 terms=54879
certcheck RESULT: PASS
certcheck q=19 file=certs/gridcap-q19.cert  classes(parsed)=27 declared=27  PASS=27 FAIL=0 SKIP(capped/none)=0  nodes=740799 rows=1497427 terms=570772
certcheck RESULT: PASS
```

## Byte-identical existing-mode validation (guardrail)

Pre-edit baseline binary built from a copy of the file BEFORE any edit (`/tmp/gridcap-baseline`),
edited binary is `/tmp/gridcap`:

```
diff <(gridcap-baseline escape 7)  <(gridcap escape 7)   -> IDENTICAL
diff <(gridcap-baseline esc 11 0)  <(gridcap esc 11 0)   -> IDENTICAL
```

Both existing-mode outputs are byte-identical; edits are additive (new modes only).

## Wall / RSS

- Build: `rustc -O -C target-cpu=native 2026-07-06-grid-cap-solver.rs -o /tmp/gridcap` (clean, no warnings).
- q=5,7,9,11,13: sub-second each. Single-core, tiny RSS.
- q=17: 39.6 s, peak RSS 145 MB (single-core; private per-class value memo dropped per class).
- q=19: 564.9 s, peak RSS 846 MB, ~19–24 s/class. Certcheck of the 85 MB q=19 file: ~seconds.

Note the `cert`-mode value memo is EARLY-BREAK (only what's needed to pick the P replies and
count escapes), so it is far lighter than `esc` mode's full expansion (q=19: 846 MB here vs
the 32.3 M-entry full-expansion peak in the C3 gate).

(NB: the box has no `/usr/bin/time`; wall/RSS captured via `/proc/<pid>/status` VmHWM polling +
the solver's own `[..s]` timing.)

## Skips / walls

None. All 7 q completed, zero capped books. `--bookcap` was set (q17: 3 M nodes, q19: 6 M nodes)
as a safety valve; the largest per-class book is ~29.6 K nodes (q=19), far under the cap. The
reply-book DAG stays small because dedup by actual position merges transpositions and the
strategy steers to the conic's even maximal caps (max node size = q−1 at every q, checked).

## Reproduce

```bash
cd notes
rustc -O -C target-cpu=native 2026-07-06-grid-cap-solver.rs -o /tmp/gridcap
for q in 5 7 9 11 13 17 19; do /tmp/gridcap cert $q; /tmp/gridcap certcheck $q certs/gridcap-q$q.cert; done
```
