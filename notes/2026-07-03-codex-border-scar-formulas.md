# Border/scar formula pass
Date: 2026-07-03
## Running log
### Context and definitions

Command: read previous low-memory note and script; checked D1 counterexample note.

Result: previous pass used `scar` for live S-core squares after `c*`, not all geometric squares in `S`. This pass will distinguish raw `scar_S(b)` from game-relevant `scar_R(b)=scar_S(b) ∩ R_n ∩ S`.

Impact: prevents formula mismatch. Raw scar size is simpler; repair/asymmetry sections use `scar_R` because it is the residual actually affected after the central strike.



### Wrapper formula run

Command: `ulimit -v 1000000; timeout 60s time -v python3 scripts/codex_border_scar_formulas.py`

Resource results:

```text
	Command being timed: "python3 scripts/codex_border_scar_formulas.py"
	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:01.83
	Maximum resident set size (kbytes): 14124
	Exit status: 0
```

## Closed-form live-border formulas

Status: PROVEN by arithmetic; verified for n=8..24 by Python.

Let `n=2m`, `q=n-1`, and `h=m-1`.  After `c*=(h,h)`, a border square can only lie on row `q` or column `q`.

- Row arm: `B_row = {(q,x): 0 <= x <= q-1, x != h}`; hence `|B_row| = q-1 = n-2`.
- Column arm: `B_col = {(y,q): 0 <= y <= q-1, y != h}`; hence `|B_col| = n-2`.
- Total live border size is `2(n-2)`.
- Two row-arm squares share row `q`; two column-arm squares share column `q`, so each arm is a clique.
- `(q,x)` and `(y,q)` share the anti-diagonal exactly when `q+x = y+q`, i.e. `x=y`; they never share row/column, and their differences `q-x` and `y-q` are equal only at the excluded impossible equation `x+y=2q`.
- Therefore cross-arm attack occurs exactly when `x=y`.  Since each arm is a clique, any three border squares contain two in one arm and are not independent; at most two live-border queens can ever be placed.

| n  | |B_row| | |B_col| | |B| | formula ok | cross iff x=y | no independent triple |
| -- | ------- | ------- | --- | ---------- | ------------- | --------------------- |
| 8  | 6       | 6       | 12  | True       | True          | True                  |
| 10 | 8       | 8       | 16  | True       | True          | True                  |
| 12 | 10      | 10      | 20  | True       | True          | True                  |
| 14 | 12      | 12      | 24  | True       | True          | True                  |
| 16 | 14      | 14      | 28  | True       | True          | True                  |
| 18 | 16      | 16      | 32  | True       | True          | True                  |
| 20 | 18      | 18      | 36  | True       | True          | True                  |
| 22 | 20      | 20      | 40  | True       | True          | True                  |
| 24 | 22      | 22      | 44  | True       | True          | True                  |

## Single-border scar formulas

Status: PROVEN by arithmetic for the displayed formulas; verified for n=8..24 by Python.

For a row-arm border move `b=(q,x)`, raw geometric `scar_S(b)` is the disjoint union inside `S` of:

- column `c=x`, length `q`;
- high difference line `r-c=q-x`, length `x`;
- high sum line `r+c=q+x`, length `q-1-x`.

The three raw lines meet only at row `q`, outside `S`, so `|scar_S(q,x)| = q+x+q-1-x = 2q-1 = 2n-3`.

For the game-relevant live scar `scar_R = scar_S ∩ R_n ∩ S`, remove the central-strike labels `row h`, `col h`, `sum q-1`, and `diff 0`.  With `[P]` denoting 1 if `P` holds:

- live column contribution: `q-3 = n-4`.
- live high-difference contribution: `x - 2[x>=m] - [x odd]`.
- live high-sum contribution: `q-1-x - 2[x<=h-1] - [x odd]`.
- since `x != h`, exactly one side indicator is active, so `|scar_R(q,x)| = 2n-8 - 2[x odd]`.

The column-arm formula is the transpose: replace `x` by `y`, column by row, and high-difference/high-sum by `r-c=y-q`, `r+c=y+q`.

| n  | coords checked | raw mismatches | live total mismatches | component mismatches | even |scar_R| | odd |scar_R| |
| -- | -------------- | -------------- | --------------------- | -------------------- | ------------- | ------------ |
| 8  | 6              | 0              | 0                     | 0                    | 8             | 6            |
| 10 | 8              | 0              | 0                     | 0                    | 12            | 10           |
| 12 | 10             | 0              | 0                     | 0                    | 16            | 14           |
| 14 | 12             | 0              | 0                     | 0                    | 20            | 18           |
| 16 | 14             | 0              | 0                     | 0                    | 24            | 22           |
| 18 | 16             | 0              | 0                     | 0                    | 28            | 26           |
| 20 | 18             | 0              | 0                     | 0                    | 32            | 30           |
| 22 | 20             | 0              | 0                     | 0                    | 36            | 34           |
| 24 | 22             | 0              | 0                     | 0                    | 40            | 38           |

## Single-border tau-asymmetry

Status: PROVEN by arithmetic for the indicator formula; verified for n=8..24 by Python.

Inside `S`, tau sends line labels as follows: rows/columns `ell -> q-1-ell`, sums `a -> 2q-2-a`, and differences `d -> -d`.

For a row scar at coordinate `x`, the only possible intersections between `scar_R(q,x)` and its tau-image are two symmetric candidate points.  Both survive, or both are killed by a central-strike label.  Thus

`|scar_R ∩ tau(scar_R)| = J_n(x)`, where `J_n(x)=2` except at these dead-intersection coordinates:

- left side `x <= h-1`: `2x=m-2` or `3x=2m-3`;
- right side `x >= m`: `2x=3m-2` or `3x=4m-3`.

Then `|Delta_b| = |scar_R Δ tau(scar_R)| = 2|scar_R| - 2J_n(x)`.

| n  | m  | dead-intersection x                                     | formula mismatches | min |Delta| | minimizing x             |
| -- | -- | ------------------------------------------------------- | ------------------ | ----------- | ------------------------ |
| 8  | 4  | 1:left-row-h 5:right-row-h                              | 0                  | 12          | 0,1,2,4,5,6              |
| 10 | 5  | none                                                    | 0                  | 16          | 1,3,5,7                  |
| 12 | 6  | 2:left-row-h 3:left-diff0 7:right-sum-h 8:right-row-h   | 0                  | 24          | 1,9                      |
| 14 | 7  | none                                                    | 0                  | 32          | 1,3,5,7,9,11             |
| 16 | 8  | 3:left-row-h 11:right-row-h                             | 0                  | 40          | 1,5,9,13                 |
| 18 | 9  | 5:left-diff0 11:right-sum-h                             | 0                  | 48          | 1,3,7,9,13,15            |
| 20 | 10 | 4:left-row-h 14:right-row-h                             | 0                  | 56          | 1,3,5,7,11,13,15,17      |
| 22 | 11 | none                                                    | 0                  | 64          | 1,3,5,7,9,11,13,15,17,19 |
| 24 | 12 | 5:left-row-h 7:left-diff0 15:right-sum-h 17:right-row-h | 0                  | 72          | 1,3,9,13,19,21           |

Pattern: the minimum is usually at odd coordinates whose two tau-intersections survive (`J=2`).  Endpoint status alone is not decisive; the exceptional coordinates are where the candidate intersections land on the central killed row, killed sum, or killed difference.

## Best cross-arm repair candidates

Status: verified for n=8..24 by exhaustive arithmetic enumeration of all legal cross-arm replies; symbolic minimizer rule remains heuristic / open.

For opponent `(q,x)`, every cross-arm reply `(y,q)` with `y=x` is illegal, because the two border squares share sum `q+x`.  The script enumerated all other `y != h,x` and minimized lexicographically by `|combined_asym|`, then `|combined_scar|`, then label-imbalance score.

| n  | row coords | legal pairs | unique primary | ties | adjacent-best | min asym range | lex-best size range |
| -- | ---------- | ----------- | -------------- | ---- | ------------- | -------------- | ------------------- |
| 8  | 6          | 30          | 6              | 0    | 0             | 8..12          | 12..14              |
| 10 | 8          | 56          | 4              | 4    | 0             | 18..22         | 17..21              |
| 12 | 10         | 90          | 5              | 5    | 3             | 34..40         | 26..29              |
| 14 | 12         | 132         | 6              | 6    | 0             | 44..50         | 32..37              |
| 16 | 14         | 182         | 7              | 7    | 2             | 62..66         | 41..45              |
| 18 | 16         | 240         | 8              | 8    | 0             | 74..82         | 47..53              |
| 20 | 18         | 306         | 8              | 10   | 0             | 90..98         | 55..61              |
| 22 | 20         | 380         | 4              | 16   | 0             | 102..114       | 63..69              |
| 24 | 22         | 462         | 4              | 18   | 0             | 122..130       | 71..77              |

Primary minimizer maps are shown as `x->best_y@asym/combined_size`; `+` means more ties omitted.

| n  | primary minimizers by x                                                                                                                                                                                                                                                                                                                                                                                                     |
| -- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 8  | 0->4@8/14 ; 1->4@10/13 ; 2->0@10/13 ; 4->0@8/14 ; 5->0@12/12 ; 6->4@10/13                                                                                                                                                                                                                                                                                                                                                   |
| 10 | 0->2,6@18/21 ; 1->3,6@22/17 ; 2->0@18/21 ; 3->1@22/17 ; 5->0,7@22/17 ; 6->0@18/21 ; 7->5@22/17 ; 8->2,6@22/19                                                                                                                                                                                                                                                                                                               |
| 12 | 0->8@34/29 ; 1->2,8@36/28 ; 2->4@34/29 ; 3->0,4,6@36/28 ; 4->2@34/29 ; 6->0,3@36/28 ; 7->0@36/28 ; 8->0@34/29 ; 9->0,2,7,8@40/26 ; 10->2,6@38/27                                                                                                                                                                                                                                                                            |
| 14 | 0->4,10@46/37 ; 1->7@44/34 ; 2->4@46/37 ; 3->1,5@46/33 ; 4->0,2@46/37 ; 5->3@46/33 ; 7->1@44/34 ; 8->0,2,10,12@50/35 ; 9->0,7,11@48/32 ; 10->0@46/37 ; 11->9@48/32 ; 12->2,8@50/35                                                                                                                                                                                                                                          |
| 16 | 0->4,12@62/45 ; 1->2,4,9,10+@64/42 ; 2->6@62/45 ; 3->9@64/42 ; 4->0,6@62/45 ; 5->0,6,8@64/44 ; 6->2,4@62/45 ; 8->5@64/44 ; 9->0,1,3@64/42 ; 10->1@64/44 ; 11->1@66/41 ; 12->0@62/45 ; 13->9@66/41 ; 14->2,10@66/43                                                                                                                                                                                                          |
| 18 | 0->4,6,10,12+@78/53 ; 1->11@74/49 ; 2->4,6@78/53 ; 3->5@74/49 ; 4->0,2,6,10@78/53 ; 5->3,7@74/49 ; 6->0,2,4@78/53 ; 7->5@74/49 ; 9->1@76/50 ; 10->0,4@78/53 ; 11->1@74/49 ; 12->0@78/53 ; 13->1,11@78/47 ; 14->0@78/53 ; 15->5@78/47 ; 16->2,4,6,10+@82/51                                                                                                                                                                  |
| 20 | 0->6,16@94/61 ; 1->5,13@90/57 ; 2->10@94/61 ; 3->13@92/58 ; 4->0,2,6,8+@98/61 ; 5->1@90/57 ; 6->0,8@94/61 ; 7->1,5@94/57 ; 8->6@94/61 ; 10->2@94/61 ; 11->1@92/58 ; 12->1,3@96/60 ; 13->1@90/57 ; 14->0,2@98/61 ; 15->1,13@94/57 ; 16->0@94/61 ; 17->5,11,13@94/55 ; 18->2,12@98/59                                                                                                                                         |
| 22 | 0->4,6,8,12+@110/69 ; 1->7,15@102/65 ; 2->4,6,12,14+@110/69 ; 3->5,9@102/65 ; 4->0,2,6,8@110/69 ; 5->3@102/65 ; 6->0,2,4,8+@110/69 ; 7->1,9@102/65 ; 8->0,4,6@110/69 ; 9->3,7@102/65 ; 11->3,7,13,17@106/63 ; 12->0,2,6@110/69 ; 13->1,11,19@106/63 ; 14->2@110/69 ; 15->1@102/65 ; 16->0,2@110/69 ; 17->11,15@106/63 ; 18->0@110/69 ; 19->5,13@106/63 ; 20->2,4,8,12+@114/67                                               |
| 24 | 0->4,6,8,14+@126/77 ; 1->7,15,17@122/73 ; 2->4,6,10,12+@126/77 ; 3->5,17@122/73 ; 4->0,2,8,10+@126/77 ; 5->3,9@122/73 ; 6->0,2,8,10+@126/77 ; 7->1,9,13@122/73 ; 8->0,4,6,10@126/77 ; 9->5,7@122/73 ; 10->2,4,6,8@126/77 ; 12->2,4,6@126/77 ; 13->7@122/73 ; 14->0,6@126/77 ; 15->1@122/73 ; 16->0@126/77 ; 17->1,3@122/73 ; 18->0,2@126/77 ; 19->1,5,17@126/71 ; 20->0@126/77 ; 21->5,7,13,15@126/71 ; 22->2,4,6,8+@130/75 |

Findings:

- The natural same-coordinate reply is always illegal: it is exactly the cross-arm attack case `x=y`.
- No single rule such as `y=x+1`, `y=x-1`, endpoint, or center-gap reply explains all minimizers.
- Ties are common, especially as n grows; this supports an oracle table keyed by coordinate class and label imbalance rather than a context-free formula.

## Additive line-label state after border exchange

Status: verified for n=8..24 by arithmetic enumeration; proposed descriptor is heuristic.

For a border pair `(q,x),(y,q)`, the active line labels inside `S` are:

- rows `{h,y}`, columns `{h,x}`;
- sums `{q-1}` plus any of `q+x`, `q+y` lying in `[0,2q-2]`;
- differences `{0}` plus any of `q-x`, `y-q` lying in `[-(q-1),q-1]`.

Tau acts on labels by row/column reflection, sum complement, and diff negation.  A label is unpaired if its tau-label is not also active.

| n  | legal pairs | asym subset of unpaired-label orbit cover | exact equality | unpaired orbit label count range | square asym range |
| -- | ----------- | ----------------------------------------- | -------------- | -------------------------------- | ----------------- |
| 8  | 30          | 30/30                                     | 2/30           | 8..12                            | 8..24             |
| 10 | 56          | 56/56                                     | 0/56           | 8..12                            | 18..34            |
| 12 | 90          | 90/90                                     | 4/90           | 8..12                            | 34..64            |
| 14 | 132         | 132/132                                   | 0/132          | 8..12                            | 44..66            |
| 16 | 182         | 182/182                                   | 2/182          | 8..12                            | 62..88            |
| 18 | 240         | 240/240                                   | 2/240          | 8..12                            | 74..104           |
| 20 | 306         | 306/306                                   | 2/306          | 8..12                            | 90..128           |
| 22 | 380         | 380/380                                   | 0/380          | 8..12                            | 102..130          |
| 24 | 462         | 462/462                                   | 4/462          | 8..12                            | 122..152          |

Examples for lexicographic best replies:

| n  | x | lex-best y | raw used labels                                                                  | unpaired label orbits                                                         | |asym| |
| -- | - | ---------- | -------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- | ------ |
| 10 | 0 | 2          | {'row': {9, 2, 4}, 'col': {0, 9, 4}, 'sum': {8, 9, 11}, 'diff': {0, 9, -7}}      | {'row': {2, 6}, 'col': {0, 8}, 'sum': {9, 11, 5, 7}, 'diff': {-7, 7}}         | 18     |
| 10 | 1 | 3          | {'row': {9, 3, 4}, 'col': {1, 4, 9}, 'sum': {8, 10, 12}, 'diff': {0, 8, -6}}     | {'row': {3, 5}, 'col': {1, 7}, 'sum': {10, 12, 4, 6}, 'diff': {8, -8, -6, 6}} | 22     |
| 10 | 2 | 0          | {'row': {0, 9, 4}, 'col': {9, 2, 4}, 'sum': {8, 9, 11}, 'diff': {0, -9, 7}}      | {'row': {0, 8}, 'col': {2, 6}, 'sum': {9, 11, 5, 7}, 'diff': {-7, 7}}         | 18     |
| 10 | 3 | 1          | {'row': {9, 4, 1}, 'col': {9, 3, 4}, 'sum': {8, 10, 12}, 'diff': {0, -8, 6}}     | {'row': {1, 7}, 'col': {3, 5}, 'sum': {10, 12, 4, 6}, 'diff': {-8, 8, -6, 6}} | 22     |
| 10 | 5 | 7          | {'row': {9, 4, 7}, 'col': {9, 4, 5}, 'sum': {8, 16, 14}, 'diff': {0, 4, -2}}     | {'row': {1, 7}, 'col': {3, 5}, 'sum': {16, 0, 2, 14}, 'diff': {2, 4, -4, -2}} | 22     |
| 10 | 6 | 0          | {'row': {0, 9, 4}, 'col': {9, 4, 6}, 'sum': {8, 9, 15}, 'diff': {0, 3, -9}}      | {'row': {0, 8}, 'col': {2, 6}, 'sum': {9, 15, 1, 7}, 'diff': {3, -3}}         | 18     |
| 10 | 7 | 5          | {'row': {9, 4, 5}, 'col': {9, 4, 7}, 'sum': {8, 16, 14}, 'diff': {0, 2, -4}}     | {'row': {3, 5}, 'col': {1, 7}, 'sum': {16, 0, 2, 14}, 'diff': {2, -4, 4, -2}} | 22     |
| 10 | 8 | 2          | {'row': {9, 2, 4}, 'col': {8, 9, 4}, 'sum': {8, 17, 11}, 'diff': {0, 1, -7}}     | {'row': {2, 6}, 'col': {8, 0}, 'sum': {11, 5}, 'diff': {1, -7, -1, 7}}        | 22     |
| 14 | 0 | 4          | {'row': {4, 13, 6}, 'col': {0, 13, 6}, 'sum': {17, 12, 13}, 'diff': {0, 13, -9}} | {'row': {8, 4}, 'col': {0, 12}, 'sum': {17, 11, 13, 7}, 'diff': {9, -9}}      | 46     |

Conclusion: square-level asymmetry is always covered by the squares incident to tau-unpaired label orbits, but equality is rare.  The additive labels explain where asymmetry can live; they do not by themselves determine its exact square count because line overlaps and central-strike holes matter.

## n=10 D1 counterexample anatomy

Status: verified statically from existing notes; no large rediscovery search run.

Placement witness from `2026-07-03-almost-mirror-method.md`: `[(0, 4), (2, 1), (4, 7), (5, 2), (7, 8), (9, 5)]`.
Available live set has 6 squares and induced Grundy value `3`.

| live square | rho partner | long diagonal? | labels (row,col,sum,diff) | child G |
| ----------- | ----------- | -------------- | ------------------------- | ------- |
| (1, 9)      | (8, 0)      | False          | (1, 9, 10, -8)            | 2       |
| (3, 3)      | (6, 6)      | True           | (3, 3, 6, 0)              | 0       |
| (3, 9)      | (6, 0)      | False          | (3, 9, 12, -6)            | 1       |
| (6, 0)      | (3, 9)      | False          | (6, 0, 6, 6)              | 1       |
| (6, 6)      | (3, 3)      | True           | (6, 6, 12, 0)             | 0       |
| (8, 0)      | (1, 9)      | False          | (8, 0, 8, 8)              | 2       |

Diagonal defect pair: `(3, 3)` and `(6, 6)`.  Strike child after `(3, 3)` is `[(1, 9), (8, 0)]`; its scar against `(6, 6)` is `[]`.

Child-value histogram: `{0: 2, 1: 2, 2: 2}`.  The parent reaches Grundy 3 because non-diagonal children supply values needed for mex, even though the diagonal-pair scar is empty.

Interpretation: the one live diagonal pair measures failure of the mirror pairing, not value.  The high value is manufactured by the small residual graph on the non-diagonal rho-pairs, so any repair theorem needs strategy/certificate state rather than a defect count.

## Candidate finite-state repair vocabulary

Status: heuristic proposal based on verified arithmetic tables and tiny-board repair conflicts.

Definitely needed fields:

- `border_state`: none / row-used / col-used / both-used, plus the occupied border coordinates.
- `unpaired_label_state`: active tau-unpaired rows, columns, sums, and differences inside `S`.
- `coordinate_class`: endpoint, near center gap `h`, left/right side, parity, and dead-intersection tags from the tau-asymmetry formula.
- `scar_class`: single-border, legal border-pair, diagonal-defect strike, or deep repair.

Speculative but likely useful fields:

- `pairing_health`: live tau-pair count and broken tau-pair count after the move.
- `line_overlap_health`: maximum number of active unpaired labels incident to one live square.
- `repair_rank`: whether a candidate minimizes square asymmetry, combined scar size, or label imbalance.

Why opponent-square -> reply is too weak: the previous repair probe found many conflicts for the same coarse opponent features at n=6/8.  This pass adds a reason: the same coordinate class can have different dead-intersection tags and different unpaired-label overlaps, changing the best repair set.

Telemetry to log later when the solver box is free: for every repair decision, log residual hash, border state, opponent square, candidate replies, tau-reply legality, active unpaired labels, square asymmetry, child win/loss or Grundy target, and the chosen proof reply.

## Theorem-ready lemmas

### Lemma B1: live-border occupancy
Statement. For even `n=2m`, after `c*=(m-1,m-1)`, the live border outside `S=[0..n-2]^2` is exactly `B_row ∪ B_col` with `B_row={(n-1,x): x != m-1}` and `B_col={(y,n-1): y != m-1}`.  Its size is `2(n-2)`, and at most two border queens can be placed in any legal continuation.
Proof. The central strike kills border row/column coordinate `m-1`, and kills the corner `(n-1,n-1)` by the main diagonal; all other border squares in row `n-1` or column `n-1` survive.  Each arm is a clique, so at most one square can be selected from each arm.
Status: PROVEN by arithmetic.

### Lemma B2: row-arm / column-arm clique structure
Statement. Any two distinct row-arm squares attack each other, and any two distinct column-arm squares attack each other.
Proof. Distinct row-arm squares share row `n-1`; distinct column-arm squares share column `n-1`.
Status: PROVEN by arithmetic.

### Lemma B3: cross-arm attack condition
Statement. A row-arm square `(n-1,x)` and a column-arm square `(y,n-1)` attack if and only if `x=y`.
Proof. They do not share row or column.  Their sums are `n-1+x` and `n-1+y`, equal iff `x=y`.  Their differences are `n-1-x` and `y-(n-1)`, which cannot be equal for allowed coordinates.
Status: PROVEN by arithmetic.

### Lemma B4: single-border scar line-label formula
Statement. Let `q=n-1`, `h=m-1`, and `b=(q,x)` with `x != h`.  The raw scar in `S` is the disjoint union of `c=x`, `r-c=q-x`, and `r+c=q+x`, with size `2n-3`.  The live scar after `c*` has component counts `q-3`, `x-2[x>=m]-[x odd]`, and `q-1-x-2[x<=h-1]-[x odd]`, hence total `2n-8-2[x odd]`.
Proof. Direct line-length count in the `q×q` square; raw intersections lie on row `q` outside `S`.  The central strike removes one row, one column, the central sum, and diff zero; solving each line's intersection with those four labels gives the stated subtractions.
Status: PROVEN by arithmetic.

### Lemma B5: tau-action on border scar labels
Statement. Under `tau(r,c)=(q-1-r,q-1-c)`, row/column labels map by `ell -> q-1-ell`, sum labels by `a -> 2q-2-a`, and difference labels by `d -> -d`.  For a row scar coordinate `x`, `|scar_R ∩ tau(scar_R)|` is 2 except at the four indicator dead-intersection equations listed in the tau-asymmetry section, where it is 0.
Proof. Apply tau to the three scar line labels and solve the four possible original/tau line intersections that can fall in `S`; the two candidates are killed together precisely when they lie on central row/sum/diff labels.
Status: PROVEN by arithmetic, verified for n=8..24.

### Lemma B6: cross-arm repair minimizer table
Statement. For n=8..24, the best legal cross-arm replies under primary objective `|combined_asym|` are exactly the minimizer maps in the `Best cross-arm repair candidates` table.
Proof. Exhaustive arithmetic enumeration over all legal `x,y` border-coordinate pairs with `y != x,h`.
Status: verified for n=8..24; no closed symbolic minimizer rule proven.

## Final summary

### Strong positive findings

- PROVEN by arithmetic: live-border size, clique arms, cross-arm attack iff coordinate equality, and occupancy at most two.
- PROVEN by arithmetic: raw single-border scar size is constant `2n-3`; live-core scar size is `2n-8` for even border coordinate and `2n-10` for odd coordinate.
- PROVEN by arithmetic / verified n=8..24: tau-asymmetry of a single border scar has a compact indicator formula using two candidate tau-intersections.
- verified for n=8..24: square-level border-pair asymmetry is always covered by tau-unpaired active line labels.

### Negative findings / failed simplifications

- failed / refuted: same-coordinate cross-arm repair is the natural label-balancing move but is always illegal, exactly because it is the cross-arm attack condition.
- heuristic failure: no single offset, endpoint, or center-gap rule explains all best cross-arm minimizers.
- failed / refuted by existing data: the n=10 D1 witness shows one diagonal defect and empty scar can still have Grundy value 3.

### Clean formulas obtained

- `|B_row|=|B_col|=n-2`, `|B|=2(n-2)`.
- `(n-1,x)` attacks `(y,n-1)` iff `x=y`.
- raw row scar component lengths: `n-1`, `x`, `n-2-x`; raw total `2n-3`.
- live row scar component lengths: `n-4`, `x-2[x>=m]-[x odd]`, `n-2-x-2[x<=m-2]-[x odd]`; live total `2n-8-2[x odd]`.
- single-scar tau asymmetry: `2(2n-8-2[x odd])-2J_n(x)` with `J_n(x) in {0,2}` from the dead-intersection indicators.

### Formula gaps remaining

- Need a symbolic closed form for best cross-arm repair minimizers, or proof that a finite table by coordinate/parity/dead-intersection class is the right abstraction.
- Need tighter formulas connecting unpaired label sets to exact square-level asymmetry; current cover relation is exact as a superset but not usually equality.
- Need solver telemetry to know which arithmetic minimizers are actually winning repairs in game states beyond the immediate border exchange.

### Suggested next low-memory experiment

- Build a finite classifier over `(side, parity, endpoint distance, center-gap distance, dead-intersection tag, unpaired-label counts)` and test whether it predicts the best-repair minimizer set for n=8..100 by pure arithmetic.

### Suggested next high-memory / solver experiment after box is free

- Instrument the solver to log repair decisions after central strikes for n=10/12/14/16/18, including border coordinates, unpaired labels, square asymmetry, and chosen winning replies; compare solver-winning repairs with the arithmetic minimizer table.

_Script resource footer: elapsed=1.812s, maxrss=14124 KB._

