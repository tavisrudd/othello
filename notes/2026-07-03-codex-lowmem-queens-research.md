# Low-memory queens research notes

Date: 2026-07-03

## Running log

### Initial repo inspection

Command: `rg --files`, `find . -maxdepth 3 -type f -perm -111`, `find .. -maxdepth 3 -type d ...`

Result: existing `target/release/queens` binary is present; repo has `src/queens/*` and existing Python probes under `scripts/`. No Rust compile commands run.

Impact: supports using pure Python plus optional small existing-binary diagnostics under timeout.

### Context notes read

Command: read uncommitted July 3 Markdown notes (`almost-mirror-method`, `defective-involutions`, `connections-deep-dive`, `queens-explorable` handoff) plus README/NOTES excerpts.

Result: key context confirms D1/small-defect value bounds are refuted at n=10; surviving direction is explicit repair/certificate structure. Existing notes also frame Dai--Kelly/Slater as additive sum-difference cousin, not a direct game reduction.

Impact: weakens any attempt to prove bounded Grundy from scar/defect counts alone; supports focusing this session on arithmetic line-label formulas, border scar geometry, and finite repair-oracle features.

### Dai--Kelly source check

Command: opened user-provided arXiv HTML/PDF for Dai--Kelly, `On the existence of reflecting n-queens configurations`, arXiv:2407.12742v1.

Result: confirmed Slater formulation: pair `1..n` with `n+1..2n` with all sums/differences distinct; reflecting queens become a rainbow matching on rows/columns with two diagonal colors per edge. Key import for reservoirs is Lemma 3.2: a 3x3 box weighting with weights `43/48,17/24,43/48 / 41/48,19/24,41/48 / 3/4,1,3/4`, giving row/column mass about `5n/6` and diagonal/reflection-diagonal mass `<59n/72`.

Impact: supports testing a Dai--Kelly fractional/threshold reservoir inside the S-core rather than only ad hoc periodic residues. Source: https://arxiv.org/html/2407.12742v1 and PDF lines around Lemma 3.2.

### Arithmetic experiment runs

Commands:
- `timeout 60s /run/current-system/sw/bin/time -v python3 scripts/codex_lowmem_queens_research.py additive`
- `timeout 60s /run/current-system/sw/bin/time -v python3 scripts/codex_lowmem_queens_research.py border`
- `timeout 60s /run/current-system/sw/bin/time -v python3 scripts/codex_lowmem_queens_research.py reservoir`

Resource results:

```text
/tmp/queens_additive.time:	Command being timed: "python3 scripts/codex_lowmem_queens_research.py additive"
/tmp/queens_additive.time:	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:00.18
/tmp/queens_additive.time:	Maximum resident set size (kbytes): 17536
/tmp/queens_additive.time:	Exit status: 0
/tmp/queens_border.time:	Command being timed: "python3 scripts/codex_lowmem_queens_research.py border"
/tmp/queens_border.time:	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:00.23
/tmp/queens_border.time:	Maximum resident set size (kbytes): 17680
/tmp/queens_border.time:	Exit status: 0
/tmp/queens_reservoir.time:	Command being timed: "python3 scripts/codex_lowmem_queens_research.py reservoir"
/tmp/queens_reservoir.time:	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:44.24
/tmp/queens_reservoir.time:	Maximum resident set size (kbytes): 19868
/tmp/queens_reservoir.time:	Exit status: 0
```

## Additive line-label model

Square `(r,c)` is represented by four consumed labels: row `r`, column `c`, sum `r+c`, and difference `r-c`.  A move is legal exactly when all four labels are unused.

| n  | |R_n ∩ S| | |live L-border| | |R_n| | labels killed by c*          | reply classes after c*                                              |
| -- | --------- | --------------- | ----- | ---------------------------- | ------------------------------------------------------------------- |
| 8  | 24        | 12              | 36    | row 3, col 3, sum 6, diff 0  | S tau-live: 24, live border: 12; flags {'long-diagonal legal': 6}   |
| 10 | 48        | 16              | 64    | row 4, col 4, sum 8, diff 0  | S tau-live: 48, live border: 16; flags {'long-diagonal legal': 8}   |
| 12 | 80        | 20              | 100   | row 5, col 5, sum 10, diff 0 | S tau-live: 80, live border: 20; flags {'long-diagonal legal': 10}  |
| 14 | 120       | 24              | 144   | row 6, col 6, sum 12, diff 0 | S tau-live: 120, live border: 24; flags {'long-diagonal legal': 12} |
| 16 | 168       | 28              | 196   | row 7, col 7, sum 14, diff 0 | S tau-live: 168, live border: 28; flags {'long-diagonal legal': 14} |
| 18 | 224       | 32              | 256   | row 8, col 8, sum 16, diff 0 | S tau-live: 224, live border: 32; flags {'long-diagonal legal': 16} |

Line-label action of `tau(r,c)=(n-2-r,n-2-c)` inside `S=[0..n-2]^2`:

- row label `r` maps to row `n-2-r`; column label `c` maps to column `n-2-c`.
- sum label `s` maps to `2n-4-s`; difference label `d` maps to `-d`.
- The central strike labels `row=m-1`, `col=m-1`, `sum=n-2`, `diff=0` are fixed by this label action.
- Therefore `R_n ∩ S` is exactly tau-symmetric after `c*`; the asymmetric context is entirely in the live L-border and in later border scars.

The additive labels make the first asymmetry sharper than board geometry: a row-arm border move consumes one outside row label plus one live column/sum/difference label in the core; the missing tau-partner of the outside row is the phantom row `-1`.  A column-arm move has the transposed phantom column.  This explains why cross-arm repair is label-balancing rather than a literal tau mirror.

_Script resource footer: elapsed=0.002s, maxrss=17344 KB._
## Border intrusion algebra

| n  | |border| | 2(n-2) | row clique | col clique | no independent triple | cross-arm rule  |
| -- | -------- | ------ | ---------- | ---------- | --------------------- | --------------- |
| 8  | 12       | 12     | True       | True       | True                  | attacks iff x=y |
| 10 | 16       | 16     | True       | True       | True                  | attacks iff x=y |
| 12 | 20       | 20     | True       | True       | True                  | attacks iff x=y |
| 14 | 24       | 24     | True       | True       | True                  | attacks iff x=y |
| 16 | 28       | 28     | True       | True       | True                  | attacks iff x=y |
| 18 | 32       | 32     | True       | True       | True                  | attacks iff x=y |
| 20 | 36       | 36     | True       | True       | True                  | attacks iff x=y |

Arithmetic formulas for `n=2m` after `c*=(m-1,m-1)`:

- Live row arm: `(n-1,x)` for `0 <= x <= n-2`, `x != m-1`.
- Live column arm: `(y,n-1)` for `0 <= y <= n-2`, `y != m-1`.
- Each arm is a clique, so a border play can use at most one square per arm.
- Cross-arm attack is exactly `(n-1,x) ~ (y,n-1) <=> x=y`, via the shared sum label `n-1+x`.
- Thus no independent triple can exist in the live border.

Verification status for n=8..20 even: PROVEN by arithmetic and verified by Python.

### Border scar table, n=8
| row-arm x | |scar(b)| | |Delta_b| | best cross-arm y | min combined asym | all y:asym               |
| --------- | --------- | --------- | ---------------- | ----------------- | ------------------------ |
| 0         | 8         | 12        | 4                | 8                 | 1:12 2:10 4:8 5:12 6:18  |
| 1         | 6         | 12        | 4                | 10                | 0:12 2:12 4:10 5:24 6:14 |
| 2         | 8         | 12        | 0                | 10                | 0:10 1:12 4:18 5:16 6:12 |
| 4         | 8         | 12        | 0                | 8                 | 0:8 1:10 2:18 5:14 6:10  |
| 5         | 6         | 12        | 0                | 12                | 0:12 1:24 2:16 4:14 6:14 |
| 6         | 8         | 12        | 4                | 10                | 0:18 1:14 2:12 4:10 5:14 |

### Border scar table, n=10
| row-arm x | |scar(b)| | |Delta_b| | best cross-arm y | min combined asym | all y:asym                         |
| --------- | --------- | --------- | ---------------- | ----------------- | ---------------------------------- |
| 0         | 12        | 20        | 2,6              | 18                | 1:24 2:18 3:24 5:22 6:18 7:24 8:34 |
| 1         | 10        | 16        | 3,6              | 22                | 0:24 2:24 3:22 5:24 6:22 7:26 8:26 |
| 2         | 12        | 20        | 0                | 18                | 0:18 1:24 3:24 5:24 6:34 7:26 8:22 |
| 3         | 10        | 16        | 1                | 22                | 0:24 1:22 2:24 5:26 6:26 7:28 8:26 |
| 5         | 10        | 16        | 0,7              | 22                | 0:22 1:24 2:24 3:26 6:26 7:22 8:24 |
| 6         | 12        | 20        | 0                | 18                | 0:18 1:22 2:34 3:26 5:26 7:24 8:22 |
| 7         | 10        | 16        | 5                | 22                | 0:24 1:26 2:26 3:28 5:22 6:24 8:26 |
| 8         | 12        | 20        | 2,6              | 22                | 0:34 1:26 2:22 3:26 5:24 6:22 7:26 |

### Border scar table, n=12
| row-arm x | |scar(b)| | |Delta_b| | best cross-arm y | min combined asym | all y:asym                                    |
| --------- | --------- | --------- | ---------------- | ----------------- | --------------------------------------------- |
| 0         | 16        | 28        | 8                | 34                | 1:40 2:38 3:36 4:38 6:36 7:36 8:34 9:40 10:50 |
| 1         | 14        | 24        | 2,8              | 36                | 0:40 2:36 3:42 4:40 6:38 7:40 8:36 9:42 10:42 |
| 2         | 16        | 32        | 4                | 34                | 0:38 1:36 3:40 4:34 6:38 7:40 8:64 9:40 10:38 |
| 3         | 14        | 28        | 0,4,6            | 36                | 0:36 1:42 2:40 4:36 6:36 7:56 8:44 9:42 10:40 |
| 4         | 16        | 28        | 2                | 34                | 0:38 1:40 2:34 3:36 6:50 7:40 8:42 9:44 10:40 |
| 6         | 16        | 28        | 0,3              | 36                | 0:36 1:38 2:38 3:36 4:50 7:40 8:38 9:42 10:38 |
| 7         | 14        | 28        | 0                | 36                | 0:36 1:40 2:40 3:56 4:40 6:40 8:44 9:40 10:40 |
| 8         | 16        | 32        | 0                | 34                | 0:34 1:36 2:64 3:44 4:42 6:38 7:44 9:40 10:42 |
| 9         | 14        | 24        | 0,2,7,8          | 40                | 0:40 1:42 2:40 3:42 4:44 6:42 7:40 8:40 10:42 |
| 10        | 16        | 28        | 2,6              | 38                | 0:50 1:42 2:38 3:40 4:40 6:38 7:40 8:42 9:42  |

### Border scar table, n=18
| row-arm x | |scar(b)| | |Delta_b| | best cross-arm y | min combined asym | all y:asym                                                            |
| --------- | --------- | --------- | ---------------- | ----------------- | --------------------------------------------------------------------- |
| 0         | 28        | 52        | 4,6,10,12,14     | 78                | 1:88 2:82 3:80 4:78 5:84 6:78 7:88 9:86 10:78 11:84 12:78 13:80 ...   |
| 1         | 26        | 48        | 11               | 74                | 0:88 2:80 3:78 4:80 5:78 6:88 7:78 9:76 10:86 11:74 12:80 13:78 ...   |
| 2         | 28        | 52        | 4,6              | 78                | 0:82 1:80 3:80 4:78 5:100 6:78 7:80 9:80 10:82 11:98 12:82 13:80 ...  |
| 3         | 26        | 48        | 5                | 74                | 0:80 1:78 2:80 4:88 5:74 6:88 7:78 9:78 10:86 11:78 12:86 13:90 ...   |
| 4         | 28        | 52        | 0,2,6,10         | 78                | 0:78 1:80 2:78 3:88 5:84 6:78 7:88 9:88 10:78 11:84 12:98 13:90 ...   |
| 5         | 26        | 52        | 3,7              | 74                | 0:84 1:78 2:100 3:74 4:84 6:84 7:74 9:78 10:84 11:104 12:88 13:82 ... |
| 6         | 28        | 52        | 0,2,4            | 78                | 0:78 1:88 2:78 3:88 4:78 5:84 7:80 9:80 10:98 11:88 12:82 13:92 ...   |
| 7         | 26        | 48        | 5                | 74                | 0:88 1:78 2:80 3:78 4:88 5:74 6:80 9:90 10:84 11:82 12:90 13:80 ...   |
| 9         | 26        | 48        | 1                | 76                | 0:86 1:76 2:80 3:78 4:88 5:78 6:80 7:90 10:84 11:78 12:90 13:80 ...   |
| 10        | 28        | 52        | 0,4              | 78                | 0:78 1:86 2:82 3:86 4:78 5:84 6:98 7:84 9:84 11:88 12:82 13:90 ...    |
| 11        | 26        | 52        | 1                | 74                | 0:84 1:74 2:98 3:78 4:84 5:104 6:88 7:82 9:78 10:88 12:88 13:78 ...   |
| 12        | 28        | 52        | 0                | 78                | 0:78 1:80 2:82 3:86 4:98 5:88 6:82 7:90 9:90 10:82 11:88 13:88 ...    |
| 13        | 26        | 48        | 1,11             | 78                | 0:80 1:78 2:80 3:90 4:90 5:82 6:92 7:80 9:80 10:90 11:78 12:88 ...    |
| 14        | 28        | 52        | 0                | 78                | 0:78 1:80 2:98 3:84 4:86 5:100 6:86 7:84 9:84 10:82 11:98 12:82 ...   |
| 15        | 26        | 48        | 5                | 78                | 0:88 1:90 2:84 3:80 4:84 5:78 6:90 7:82 9:80 10:88 11:82 12:84 ...    |
| 16        | 28        | 52        | 2,4,6,10,12      | 82                | 0:98 1:90 2:82 3:84 4:82 5:88 6:82 7:90 9:88 10:82 11:88 12:82 ...    |

Closed-form readings from the tables:

- For a row-arm intrusion `(n-1,x)`, the scar is the disjoint union inside `S` of column `c=x`, sum line `r+c=n-1+x`, and difference line `r-c=n-1-x`, after deleting labels already killed by `c*`.
- The column-arm formula is the transpose: row `r=y`, sum `r+c=n-1+y`, and difference `r-c=y-(n-1)`.
- The unique illegal cross-arm coordinate is `y=x`; it would consume the same sum label and would have been the most symmetric label repair in several cases.  The best legal repairs therefore sit adjacent to, or reflected around, this forbidden coordinate rather than at a universal tau partner.
- `|Delta_b|` is not monotone in the border coordinate; the center-side missing coordinate `x=m-1` creates two asymmetric regimes.  This supports treating repair choices as a finite oracle over border coordinate classes, not as a one-line monotone rule.

_Script resource footer: elapsed=0.076s, maxrss=17680 KB._
## Static reservoir experiment

| n  | reservoir                             | size | max row | max col | max sum | max diff | min row | min col | max 1-scar damage | min after 2 border scars |
| -- | ------------------------------------- | ---- | ------- | ------- | ------- | -------- | ------- | ------- | ----------------- | ------------------------ |
| 18 | central box margin 2                  | 120  | 10      | 10      | 10      | 10       | 10      | 10      | 18                | 85                       |
| 18 | central box margin 4                  | 48   | 6       | 6       | 6       | 6        | 6       | 6       | 10                | 29                       |
| 18 | central box margin 2                  | 120  | 10      | 10      | 10      | 10       | 10      | 10      | 18                | 85                       |
| 18 | checker even                          | 96   | 6       | 6       | 12      | 12       | 6       | 6       | 18                | 60                       |
| 18 | 3x3 cyclic residues tau-closed        | 156  | 12      | 12      | 10      | 14       | 9       | 9       | 23                | 114                      |
| 18 | 3x3 five-cell residues tau-closed     | 164  | 14      | 14      | 14      | 12       | 9       | 9       | 26                | 117                      |
| 18 | Dai-Kelly weights >= 41/48 tau-closed | 198  | 13      | 14      | 10      | 11       | 10      | 9       | 27                | 147                      |
| 18 | Dai-Kelly weights >= 43/48 tau-closed | 150  | 13      | 10      | 9       | 10       | 10      | 5       | 23                | 108                      |
| 20 | central box margin 2                  | 168  | 12      | 12      | 12      | 12       | 12      | 12      | 22                | 124                      |
| 20 | central box margin 4                  | 80   | 8       | 8       | 8       | 8        | 8       | 8       | 12                | 56                       |
| 20 | central box margin 2                  | 168  | 12      | 12      | 12      | 12       | 12      | 12      | 22                | 124                      |
| 20 | checker even                          | 128  | 8       | 8       | 14      | 14       | 6       | 6       | 20                | 89                       |
| 20 | 3x3 cyclic residues tau-closed        | 204  | 12      | 12      | 10      | 16       | 11      | 11      | 28                | 153                      |
| 20 | 3x3 five-cell residues tau-closed     | 228  | 16      | 16      | 16      | 14       | 11      | 11      | 32                | 168                      |
| 20 | Dai-Kelly weights >= 41/48 tau-closed | 260  | 15      | 16      | 12      | 13       | 12      | 10      | 31                | 200                      |
| 20 | Dai-Kelly weights >= 43/48 tau-closed | 204  | 15      | 12      | 11      | 12       | 12      | 6       | 27                | 155                      |
| 30 | central box margin 2                  | 528  | 22      | 22      | 22      | 22       | 22      | 22      | 42                | 445                      |
| 30 | central box margin 4                  | 360  | 18      | 18      | 18      | 18       | 18      | 18      | 32                | 297                      |
| 30 | central box margin 3                  | 440  | 20      | 20      | 20      | 20       | 20      | 20      | 36                | 369                      |
| 30 | checker even                          | 336  | 12      | 12      | 24      | 24       | 12      | 12      | 36                | 264                      |
| 30 | 3x3 cyclic residues tau-closed        | 500  | 20      | 20      | 18      | 26       | 17      | 17      | 43                | 419                      |
| 30 | 3x3 five-cell residues tau-closed     | 548  | 26      | 26      | 26      | 24       | 17      | 17      | 50                | 455                      |
| 30 | Dai-Kelly weights >= 41/48 tau-closed | 646  | 25      | 26      | 18      | 19       | 18      | 17      | 51                | 547                      |
| 30 | Dai-Kelly weights >= 43/48 tau-closed | 486  | 25      | 18      | 17      | 18       | 18      | 9       | 43                | 408                      |
| 50 | central box margin 2                  | 1848 | 42      | 42      | 42      | 42       | 42      | 42      | 82                | 1685                     |
| 50 | central box margin 4                  | 1520 | 38      | 38      | 38      | 38       | 38      | 38      | 72                | 1377                     |
| 50 | central box margin 5                  | 1368 | 36      | 36      | 36      | 36       | 36      | 36      | 66                | 1237                     |
| 50 | checker even                          | 1056 | 22      | 22      | 44      | 44       | 22      | 22      | 66                | 925                      |
| 50 | 3x3 cyclic residues tau-closed        | 1504 | 32      | 32      | 30      | 46       | 31      | 31      | 78                | 1353                     |
| 50 | 3x3 five-cell residues tau-closed     | 1728 | 46      | 46      | 46      | 44       | 31      | 31      | 92                | 1548                     |
| 50 | Dai-Kelly weights >= 41/48 tau-closed | 1980 | 45      | 46      | 32      | 33       | 32      | 30      | 91                | 1801                     |
| 50 | Dai-Kelly weights >= 43/48 tau-closed | 1504 | 45      | 32      | 31      | 32       | 32      | 16      | 77                | 1365                     |

Dai--Kelly fractional 3x3 weights applied to the live S-core:

| n  | DK fractional mass | max row | max col | max sum | max diff | min row | min col |
| -- | ------------------ | ------- | ------- | ------- | -------- | ------- | ------- |
| 18 | 187.35             | 11.79   | 11.75   | 11.40   | 11.71    | 11.60   | 11.62   |
| 20 | 240.79             | 13.58   | 13.42   | 13.04   | 13.35    | 13.25   | 13.29   |
| 30 | 607.85             | 21.79   | 21.75   | 21.15   | 21.46    | 21.60   | 21.62   |
| 50 | 1842.04            | 38.58   | 38.42   | 37.42   | 37.73    | 38.25   | 38.29   |

Reading:

- Central boxes keep row/column degrees dense but border scar lines are heavy, especially on columns/rows near the box.
- Periodic reservoirs spread line load better; the 3x3 cyclic residue set is the closest Dai--Kelly-flavored candidate here, with lower max line load but thinner row/column degree.
- Tau-closure is cheap for all tested reservoirs.  The useful design target is not minimizing total size loss, but keeping many rows and columns alive after the worst one or two border scars.

_Script resource footer: elapsed=44.094s, maxrss=19868 KB._


### Small solver / toy experiment runs

Commands:
- `timeout 60s /run/current-system/sw/bin/time -v python3 scripts/codex_lowmem_queens_research.py shell`
- `timeout 60s /run/current-system/sw/bin/time -v python3 scripts/codex_lowmem_queens_research.py openings`
- `timeout 60s /run/current-system/sw/bin/time -v python3 scripts/codex_lowmem_queens_research.py repair`
- initial Slater run at 60s timed out before useful output; after user instruction, reran narrowed Slater section with `timeout 180s`.
- `timeout 180s /run/current-system/sw/bin/time -v python3 scripts/codex_lowmem_queens_research.py slater`

Resource results:

```text
/tmp/queens_shell.time:	Command being timed: "python3 scripts/codex_lowmem_queens_research.py shell"
/tmp/queens_shell.time:	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:00.12
/tmp/queens_shell.time:	Maximum resident set size (kbytes): 17612
/tmp/queens_shell.time:	Exit status: 0
/tmp/queens_openings.time:	Command being timed: "python3 scripts/codex_lowmem_queens_research.py openings"
/tmp/queens_openings.time:	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:00.20
/tmp/queens_openings.time:	Maximum resident set size (kbytes): 17788
/tmp/queens_openings.time:	Exit status: 0
/tmp/queens_repair.time:	Command being timed: "python3 scripts/codex_lowmem_queens_research.py repair"
/tmp/queens_repair.time:	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:00.18
/tmp/queens_repair.time:	Maximum resident set size (kbytes): 17780
/tmp/queens_repair.time:	Exit status: 0
/tmp/queens_slater.time:	Command being timed: "python3 scripts/codex_lowmem_queens_research.py slater"
/tmp/queens_slater.time:	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:10.81
/tmp/queens_slater.time:	Maximum resident set size (kbytes): 124576
/tmp/queens_slater.time:	Exit status: 0
```

## Shell-peeling experiment

Test: after `c*`, one border intrusion `b`, and one legal cross-arm reply `r`, compare natural windows with `R_{n-2}` and with an odd-center residual.

| n  | pairs checked | exact R_{n-2} windows | contains R_{n-2} | inside subset of R_{n-2} | exact odd (n-1) windows |
| -- | ------------- | --------------------- | ---------------- | ------------------------ | ----------------------- |
| 8  | 6             | 0                     | 0                | 6                        | 0                       |
| 10 | 12            | 0                     | 0                | 12                       | 0                       |
| 12 | 17            | 0                     | 0                | 17                       | 0                       |

No exact `R_{n-2}` windows were found in these best-reply samples.

Reading: simple shell peeling is not a generic exact decomposition.  The common outcome is a damaged inner window (`inside subset of R_{n-2}`) plus debris, not an untouched `R_{n-2}` kernel.  Any peeling theorem needs extra hypotheses on the border coordinate and reply choice, or a weaker paired-debris certificate rather than graph equality.

_Script resource footer: elapsed=0.036s, maxrss=17612 KB._
## Slater Pairing Game

| variant                 | n  | G       | outcome           | memo states         | elapsed s |
| ----------------------- | -- | ------- | ----------------- | ------------------- | --------- |
| ordinary rows+cols      | 1  | 1       | N                 | 1                   | 0.000     |
| separated rows+cols     | 1  | 1       | N                 | same by translation | 0.000     |
| ordinary rows+cols      | 2  | 1       | N                 | 1                   | 0.000     |
| separated rows+cols     | 2  | 1       | N                 | same by translation | 0.000     |
| ordinary rows+cols      | 3  | 2       | N                 | 3                   | 0.000     |
| separated rows+cols     | 3  | 2       | N                 | same by translation | 0.000     |
| ordinary rows+cols      | 4  | 1       | N                 | 9                   | 0.000     |
| separated rows+cols     | 4  | 1       | N                 | same by translation | 0.000     |
| ordinary rows+cols      | 5  | 3       | N                 | 46                  | 0.001     |
| separated rows+cols     | 5  | 3       | N                 | same by translation | 0.000     |
| ordinary rows+cols      | 6  | 1       | N                 | 207                 | 0.008     |
| separated rows+cols     | 6  | 1       | N                 | same by translation | 0.000     |
| ordinary rows+cols      | 7  | 2       | N                 | 1335                | 0.066     |
| separated rows+cols     | 7  | 2       | N                 | same by translation | 0.000     |
| ordinary rows+cols      | 8  | 3       | N                 | 8853                | 0.625     |
| separated rows+cols     | 8  | 3       | N                 | same by translation | 0.000     |
| ordinary sum/diff only  | 1  | 1       | N                 | 2                   | 0.000     |
| ordinary sum/diff only  | 2  | 0       | P                 | 9                   | 0.000     |
| ordinary sum/diff only  | 3  | 2       | N                 | 60                  | 0.000     |
| ordinary sum/diff only  | 4  | 0       | P                 | 484                 | 0.001     |
| ordinary sum/diff only  | 5  | 1       | N                 | 4452                | 0.018     |
| ordinary sum/diff only  | 6  | 0       | P                 | 44521               | 0.292     |
| ordinary sum/diff only  | 7  | 1       | N                 | 475332              | 4.729     |
| ordinary sum/diff only  | >7 | stopped | runtime explosion |                     |           |
| separated sum/diff only | 1  | 1       | N                 | 2                   | 0.020     |
| separated sum/diff only | 2  | 0       | P                 | 9                   | 0.000     |
| separated sum/diff only | 3  | 2       | N                 | 60                  | 0.000     |
| separated sum/diff only | 4  | 0       | P                 | 484                 | 0.001     |
| separated sum/diff only | 5  | 1       | N                 | 4452                | 0.018     |
| separated sum/diff only | 6  | 0       | P                 | 44521               | 0.280     |
| separated sum/diff only | 7  | 1       | N                 | 475332              | 4.680     |
| separated sum/diff only | >7 | stopped | runtime explosion |                     |           |

Findings:

- With row/column uniqueness included, the separated Slater interval game is isomorphic to the ordinary label game by translating every `B` label.  The computed Grundy rows match exactly.
- The rows+cols variant is just the ordinary queens label game in additive language; it reproduces the small queen values.
- Omitting row/column uniqueness isolates the two diagonal pencils.  That toy game has a different pattern and does not show the even-board mirror obstruction by itself; the row/column labels are part of the obstruction algebra, not removable decoration.

_Script resource footer: elapsed=10.760s, maxrss=124576 KB._
## S2 repair-oracle probe

| n | P-nodes visited | decisions | mirror replies | repair replies | feature keys | conflict keys | max repair depth |
| - | --------------- | --------- | -------------- | -------------- | ------------ | ------------- | ---------------- |
| 6 | 10              | 47        | 16             | 31             | 20           | 8             | 2                |
| 8 | 155             | 738       | 120            | 618            | 60           | 49            | 3                |

n=6 repair examples:
- opp (1, 5) feat=('col-border', 'no-S-tau', 'non-diagonal', False, False, -4, 6) -> repair (3, 0)
- opp (3, 5) feat=('col-border', 'no-S-tau', 'non-diagonal', False, False, -2, 8) -> repair (1, 4)
- opp (5, 0) feat=('row-border', 'no-S-tau', 'outer diagonal', False, True, 5, 5) -> repair (1, 5)
- opp (1, 5) feat=('col-border', 'no-S-tau', 'non-diagonal', False, False, -4, 6) -> repair (3, 4)
- opp (3, 5) feat=('col-border', 'no-S-tau', 'non-diagonal', False, False, -2, 8) -> repair (1, 0)
- opp (5, 4) feat=('row-border', 'no-S-tau', 'non-diagonal', False, False, 1, 9) -> repair (1, 5)
- opp (0, 5) feat=('col-border', 'no-S-tau', 'outer diagonal', False, True, -5, 5) -> repair (1, 0)
- opp (3, 4) feat=('S-core', 'tau-dead', 'non-diagonal', False, False, -1, 7) -> repair (5, 1)
n=8 repair examples:
- opp (2, 7) feat=('col-border', 'no-S-tau', 'non-diagonal', False, False, -5, 9) -> repair (4, 0)
- opp (1, 7) feat=('col-border', 'no-S-tau', 'non-diagonal', False, False, -6, 8) -> repair (2, 0)
- opp (4, 6) feat=('S-core', 'tau-dead', 'non-diagonal', False, False, -2, 10) -> repair (5, 2)
- opp (5, 2) feat=('S-core', 'tau-dead', 'outer diagonal', False, True, 3, 7) -> repair (4, 6)
- opp (7, 2) feat=('row-border', 'no-S-tau', 'non-diagonal', False, False, 5, 9) -> repair (4, 6)
- opp (1, 7) feat=('col-border', 'no-S-tau', 'non-diagonal', False, False, -6, 8) -> repair (5, 2)
- opp (7, 2) feat=('row-border', 'no-S-tau', 'non-diagonal', False, False, 5, 9) -> repair (1, 4)
- opp (2, 6) feat=('S-core', 'tau-live', 'non-diagonal', False, False, -4, 8) -> repair (5, 0)

Reading: repairs are heavily context-dependent even on tiny boards.  The coarse feature key `(opponent class, tau status, diagonal flags, diff, sum)` still has conflicts, so a theorem-level certificate likely needs either residual-state data or a richer finite oracle than local line labels alone.

_Script resource footer: elapsed=0.110s, maxrss=17780 KB._
## Small-even opening diagnostics

| n | winning openings | D4 classes | class summary                                                                                                                  | solver states |
| - | ---------------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------ | ------------- |
| 6 | 28               | 5          | (0, 0) outer diagonal x4; (0, 2) non-diagonal x8; (1, 1) outer diagonal x4; (1, 2) non-diagonal x8; (2, 2) central diagonal x4 | 142           |
| 8 | 4                | 1          | (3, 3) central diagonal x4                                                                                                     | 3898          |

n=10/12 were not solved here: the existing binary can solve roots, but the brief asks to avoid large solves while the box is busy.  A later safe command would be `timeout 60s /usr/bin/time -v ./target/release/queens solve 10 symmetry` with a 1 GB virtual-memory guard if root diagnostics are needed.

_Script resource footer: elapsed=0.109s, maxrss=17788 KB._


### Theorem hygiene search

Commands:
- `rg -n -i "non-diagonal opening loses|non-diagonal roots are losing|small defect implies|bounded interaction implies|G <= 1|G ≤ 1|reflection queens" . ../notes --glob "*.md" --glob "*.rs"`
- `rg -n -i "defect.*bound|bounded.*defect|small.*defect|non-diagonal.*los|opening.*diagonal|reflection.*queen|reflecting.*queen" . ../notes --glob "*.md" --glob "*.rs"`
- targeted `rg` around D1 / boundedness / long diagonal wording in paper notes and Rust comments.

Result: no Rust code changes needed.  No exact hits for `non-diagonal opening loses` or `non-diagonal roots are losing`.  Current `queens-n18-paper.md` already has the important correction that the theorem constrains winning *lines*, not first moves, and explicitly notes n=6 non-diagonal winning openings.

## Theorem hygiene

### Stale or dangerous claims

1. `../notes/2026-07-03-cgt-laws-and-tricks.md` still treats D1 as an active tested-consistent theorem candidate and describes an engine leaf based on `d=1 => G <= 1`.

Suggested replacement wording:

> Historical note: D1 (`rho`-symmetric even-board position with exactly one live diagonal pair has `G <= 1`) was tested-consistent through n<=8 but is now **refuted** by exhaustive n=10 data.  Do not use it as an engine leaf.  The surviving theorem-level statement is only `d=0 => G=0` by mirror pairing; `d=1` can have `G=3`, even with empty scar/twin diagonal pair.  Any boundedness or pruning statement must include an explicit repair/certificate object.

Impact: refutes the proposed conditional heap-sum leaf; supports repair-oracle direction.

2. `../notes/queens-n18-paper.md` Section 6.5 still presents D1 as tested-consistent and says it survives all data.  This is stale relative to the July 3 almost-mirror note.

Suggested replacement wording:

> The earlier D1 conjecture (`d=1 => G <= 1`) is false: exhaustive n=10 reachable symmetric positions include `d=1` examples with `G=2` and `G=3`, including empty-scar/twin cases.  Thus live diagonal-pair count measures mirror obstruction, not Grundy magnitude.  The boundedness question remains open, but any proof must use queen-specific strategy/certificate structure rather than a small-defect value bound.

Impact: weakens any boundedness paragraph that cites D1; preserves the line theorem and n=18 outcome claims.

3. `../notes/2026-07-03-external-review-and-backlog.md` item 3 recommends attacking D1 as the next theorem.

Suggested replacement wording:

> D1 is refuted.  Next low-memory target: classify the n=10 counterexample anatomy and extract a finite repair-oracle vocabulary.  Next engine-scale target: search whether central-strike residuals on even boards admit small mirror-plus-exception certificates despite the failure of value bounds.

Impact: redirects the backlog from proving a false statement to certificate extraction.

4. `../notes/2026-07-03-nonCGT-connections-scout.md` frames reflecting/symmetric n-queens as “a rigorous form of our mirror-obstruction theory.”  The later deep-dive and the Dai--Kelly source check show this is too strong.

Suggested replacement wording:

> Reflecting queens / Slater pairings are a static additive-line-label cousin of the queens game, not a strategy-theoretic mirror-obstruction theorem.  The real shared substrate is row/column matching plus distinct sum/difference labels, and Dai--Kelly's useful import is the rainbow-matching and 3x3 reservoir-weighting technique.

Impact: avoids overclaiming a reduction; supports the additive-label and reservoir experiments.

5. Mentions of "bounded interaction" are mostly already corrected in `defective-involutions.md`: the sound claim is state-space/product-factorization, not a value formula.  Keep that distinction when importing into paper prose.

### Non-issues / already corrected

- `../notes/queens-n18-paper.md` lines around the abstract and Section 6 correctly say every first-player winning line must eventually hit a long diagonal, not that the winning root is diagonal.
- `../notes/2026-07-02-theory-implications.md` already retracts the "every non-diagonal opening" clause.
- `src/bin/queens.rs` `G <= 15` is only a heap-size CLI cap, not a theorem claim.

## Summary

All experiments were low-memory Python/shell work.  No Rust compile/check/test command was run, and no production solve or large TT job was launched.  The largest measured RSS was the Slater toy run at 124,576 KB; all other runs were below 20 MB RSS.  The Slater run was first attempted with a 60s timeout and then, after user instruction, rerun with a 180s timeout and a 1 GB virtual-memory guard.

## Strong findings

- PROVEN by arithmetic: after central strike on even `n=2m`, the live border is exactly the row arm `(n-1,x)` and column arm `(y,n-1)` with `x,y != m-1`, so its size is `2(n-2)`.
- PROVEN by arithmetic: each border arm is a clique; cross-arm attack is exactly equality of the arm coordinates (`x=y`); hence no independent triple exists inside the live border.
- verified for small n: the S-core after `c*` is tau-symmetric for n=8,10,12,14,16,18; all asymmetry is introduced by the L-border and later scars.
- verified for small n: shell peeling does not produce a clean exact `R_{n-2}` kernel after best sampled border replies for n=8,10,12; the natural inner windows are damaged subsets.
- verified for small n: n=6 has 28 winning openings in 5 D4 classes, including non-diagonal classes; n=8 has only the central diagonal class.
- verified for tiny boards: mirror-plus-repair policies have many context-dependent exceptions; coarse local additive keys have conflicts at n=6 and n=8.
- heuristic: Dai--Kelly 3x3 fractional weights give balanced row/column and diagonal loads inside the S-core; thresholded versions preserve density but still take nontrivial border-scar damage.

## Negative findings / killed ideas

- failed / refuted: do not use `d=1 => G<=1` or any small-defect value bound; existing July 3 exhaustive n=10 context refutes it, and hygiene search found stale claims needing replacement.
- verified for small n: row/column labels are not removable decoration in the Slater toy.  Sum/diff-only has a different P/N pattern and does not reproduce the queen mirror obstruction.
- verified for small n: a simple exact shell-peeling theorem (`border intrusion + good reply leaves R_{n-2}`) is false in the sampled natural windows.
- heuristic: best border replies are not governed by a single monotone coordinate rule; the forbidden cross-arm equality coordinate distorts the most symmetric repair.

## Suggested next experiments

- Low-memory: derive closed-form scar-size and tau-asymmetry formulas from the row-arm coordinate `x`, separating the regimes around the missing coordinate `m-1`.
- Low-memory: enrich the repair-oracle feature key with residual-state invariants, e.g. live tau-pair counts by line-label class, to reduce conflicts seen at n=6/8.
- Low-memory: implement Dai--Kelly weighted reservoirs as fractional LP-style diagnostics after one and two border scars, not only thresholded sets.
- Later engine-scale: evaluate central-strike residual certificates for n=10/12/14/16 with existing solver instrumentation once the main box is free.
- Later Rust/high-memory: root-child diagnostics for n=10/12 under controlled TT settings, plus n=18/n=20 certificate extraction if the production solver can export repair decisions.

## Files/scripts created

- `scripts/codex_lowmem_queens_research.py`: self-contained Python script for additive labels, border algebra, shell peeling, Slater toy game, tiny repair probe, small openings, and reservoir arithmetic.
- `../notes/2026-07-03-codex-lowmem-queens-research.md`: this dated running log and final summary.

Note: the initial reservoir output contains duplicate `central box margin 2` rows for n=18 and n=20 because the margin list duplicated `max(2,n//10)`.  The script was fixed after the run to deduplicate future reservoir specs; the duplicate rows do not affect the conclusions.

## Final summary

### Most useful positive findings

- PROVEN by arithmetic: border live set, clique structure, cross-arm attack condition, and no-independent-triple property are now exact theorem fodder.
- verified for small n: additive labels cleanly isolate the post-`c*` symmetry: `R_n ∩ S` is tau-symmetric and border moves introduce phantom row/column label imbalance.
- heuristic: Dai--Kelly's actual 3x3 weights are a plausible reservoir diagnostic, especially as a fractional line-load balancing tool.

### Most useful negative findings

- verified for small n: exact shell peeling to `R_{n-2}` fails in the sampled natural kernels.
- verified for tiny boards: repair replies are context-dependent; local move labels alone are too coarse for an S2 certificate oracle.
- failed / refuted: stale D1/small-defect value-bound language should be removed from theorem-facing notes and paper prose.

### New conjectures or revised conjectures

- heuristic: border repair is a finite coordinate-class oracle problem, with special cases caused by the missing central coordinate and by the illegal equality cross-arm reply.
- heuristic: a useful reservoir should optimize fractional line-load balance after scar events, not just maximize surviving square count.
- needs solver run: central-strike residuals may still admit small mirror-plus-exception certificates even though generic `d=1` value bounds fail.

### Recommended next low-memory experiment

- PROVEN/verified target: turn the border scar tables into symbolic formulas for `|scar(b)|`, `|Delta_b|`, and minimal combined asymmetry under legal cross-arm replies, then compare formulas against n=8..50 by pure arithmetic.

### Recommended next high-memory / Rust experiment after box is free

- needs solver run: export winning-repair decisions after central strike for n=10/12/14/16, keyed by the additive/border features from this script, to see whether a compact S2 repair oracle exists for P-boards and for the n=18 winning residual.
