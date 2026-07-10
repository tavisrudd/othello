# C62: selector-library scoring

Date: 2026-07-10.

## Importance summary

C62 does **not** produce the missing geometric selector theorem. It does produce two useful route
decisions.

1. Random-play `rho` is by far the strongest tested selector, but its former 100% small-board law
   is false: it misses 651 of 1,052,204 exact q=17 obligations and 11,345 of 2,622,214 obligations
   in the exact q=19 `[1,2,3,4]` root. The failures are highly localized and are now a compact C61
   refinement corpus.
2. C63's potential survives a stronger, selector-independent test. Every exact obligation in all
   five q=13 roots, all ten q=17 roots, and the q=19 `[1,2,3,4]` root has at least one exact P
   reply with `Delta Psi < 0`. This is new q=19 support for existence of a decreasing reply, but
   still not a q-uniform proof or a geometric way to choose it.

The polar and quadratic-character families do not isolate the witnesses, and none of the
rho/geometric hybrids improves on pure rho beyond q=13. There is therefore no near-perfect
definable regime to hand to the exact-character-sum lane.

## Exact corpus and scoring semantics

The native `s4selectors` traversal uses complete raw Grundy dumps. It reconstructs every reachable
record and computes the random-play value bottom-up:

```text
rho(S) = average over legal moves m of (1-rho(S+m)),
rho(terminal) = 0.
```

It then visits every obligation `(exact P parent S, legal opponent move x)`. Every legal reply `y`
is looked up in the exact Grundy table. Thus no new game solve is performed and `g(y)=0` is an
exact P label within the declared root.

| q | full-PGL S4 roots | raw records | obligations |
|---:|---:|---:|---:|
| 13 | 5/5 | 4,258 | 3,144 |
| 17 | 10/10 | 1,537,648 | 1,052,204 |
| 19 | `[1,2,3,4]` only | 2,691,979 | 2,622,214 |

For a selector family, `P hit` means its selected tie set contains at least one exact Grundy-zero
reply. `Psi hit` additionally requires that reply to have C63's `Delta Psi < 0`. This deliberately
generous tie-set scoring is complemented by `all_p` in the machine output, which requires every
selected tie to be P. An undefined predicate is a global miss; conditional coverage is reported
separately where relevant.

The root-relative conic geometry is recomputed in the local orientation for every transition.
Only exact outcome and rho are cached by `Board::canon`: that broader canonicalizer does not
preserve the distinguished root conic, so caching conic-relative features by that key would be
invalid.

## Selector library

- `rho_greedy`: minimum child rho, including exact rho ties.
- `psi_min`, `live_min`, `defect_components_min`: minimize the named child feature.
- `zero_xor_live_min`: require conic xor zero, then minimize live conic cells.
- `internal_live_min`: require an internal reply, then minimize live cells.
- `guard_killer`: require an internal reply, then lexicographically minimize live cells and defect
  components. This generalizes the q=17 score-9 guard shape, but is not the special 28-transition
  score-9 stratum itself.
- `polar_internal`: internal `y` on the polar of `x` for normalized `XY=Z^2`, namely
  `x_c y_r + x_r y_c - 2 = 0`.
- `rect_char_pos/neg_live_min`: require the indicated quadratic character of
  `(x_r-y_r)(x_c-y_c)`, then minimize live cells.
- `rhoK_feature`: retain the first K distinct rho levels, then minimize the indicated feature.

## Full P-hit table

Percentages use all obligations as the denominator. The q=19 column is one exact root, not a
full-PGL q=19 census.

| family | q=13 | q=17 | q=19 `[1,2,3,4]` |
|---|---:|---:|---:|
| `rho_greedy` | 100.000% | 99.938% | 99.567% |
| `psi_min` | 96.756% | 95.425% | 91.983% |
| `live_min` | 98.823% | 99.122% | 98.303% |
| `defect_components_min` | 98.823% | 99.134% | 98.318% |
| `zero_xor_live_min` | 98.823% | 99.154% | 98.300% |
| `internal_live_min` | 36.959% | 50.505% | 58.558% |
| `guard_killer` | 36.959% | 50.503% | 58.554% |
| `polar_internal` | 4.548% | 4.122% | 5.124% |
| `rect_char_pos_live_min` | 67.780% | 64.473% | 69.144% |
| `rect_char_neg_live_min` | 73.187% | 66.378% | 67.281% |
| `rho2_psi` | 99.491% | 98.747% | 97.502% |
| `rho3_psi` | 99.396% | 97.587% | 95.892% |
| `rho4_psi` | 98.696% | 96.818% | 95.130% |
| `rho2_live` | 100.000% | 99.678% | 98.928% |
| `rho3_live` | 99.491% | 99.433% | 98.698% |
| `rho2_defect` | 100.000% | 99.682% | 99.021% |
| `rho2_zero_live` | 99.841% | 99.399% | 97.971% |

Pure rho is perfect at q=13 and strongest thereafter. The q=13 perfection of `rho2_live` and
`rho2_defect` is only existential within a tied selected family: `all_p` is 3,095 and 3,087,
respectively, rather than 3,144. All top-K hybrids get worse as q grows.

The geometry-restricted predicates have high conditional hit rates but poor or broad coverage:

| family | q=13 conditional | q=17 conditional | q=19 conditional |
|---|---:|---:|---:|
| `internal_live_min` | 94.242% | 88.285% | 86.837% |
| `guard_killer` | 94.242% | 88.282% | 86.832% |
| `polar_internal` | 84.615% | 71.823% | 59.378% |
| `rect_char_pos_live_min` | 96.556% | 91.458% | 89.850% |
| `rect_char_neg_live_min` | 97.459% | 91.951% | 89.345% |

The character signs cover many obligations, but neither sign is distinguished and their
conditional accuracy falls with q. The polar family is sparse and also deteriorates. These are
controls, not candidate existence lemmas.

## Rho failures and rank anatomy

| q | P hits | P misses | Psi hits | all selected ties P |
|---:|---:|---:|---:|---:|
| 13 | 3,144 | 0 | 3,144 | 3,144 |
| 17 | 1,051,553 | 651 | 1,051,553 | 1,051,553 |
| 19 root | 2,610,869 | 11,345 | 2,610,857 | 2,610,713 |

At q=17 the 651 misses occur only at parent plies 4/5/6 with counts `134/282/235`; opponent
geometry is `external/internal/on-conic = 351/236/64`. The best P reply has rho rank 2 in 325
cases, rank 3 in 146, rank 4 in 60, and ranks 5--17 in the remaining 120.

At q=19, 11,337 of the 11,345 P misses occur at ply 6; four occur at ply 4 and four at ply 7.
The best P rank distribution starts `2:4255, 3:2865, 4:1754, 5:874`, with a maximum rank of 19.
This refutes the exact rho-greedy law while leaving a narrow early-reply failure surface for C61.

There are also 12 q=19 ply-4 obligations, all on-conic opponent moves from the same canonical
parent, where the minimum-rho reply is P but raises Psi from 96 to 110. Hence rho success and
potential descent are genuinely different targets. q=17 has no such split.

## New C63 validation

Before applying any selector, the traversal asks whether *some* exact P reply decreases Psi. The
answer is yes for every exact obligation:

```text
q=13: 3,144 / 3,144
q=17: 1,052,204 / 1,052,204
q=19 [1,2,3,4]: 2,622,214 / 2,622,214
```

The q=13/q=17 rows reproduce C63 under a broader reply-existence quantifier; the q=19 root is a
new exact transfer test. It supports Psi as C61's state charge. It does not prove the uniform claim
because q=19 has only one root here and the decreasing reply is still located by the exact table.

## q=23 samples from existing witnesses

No q=23 solve was launched. The 22 existing `s4xormine` zero-xor logs contain 5,734 verified P
replies. Candidate order is zero-xor followed by `live_on`; this is an ordering profile, not the
complete exact selector traversal used above.

```text
successful try rank: 1:5146, 2:490, 3:81, 4:17
rank-1 fraction:     89.745%
reply geometry:      internal 3948, external 1786, on-conic 0
polar internal:      true 78, false 5656
rectangle character -1:2981, +1:2753
live_on:             4:1049, 5:2613, 6:1637, 7:39, 10:396
defect components:   1:136, 2:734, 3:603, 4:3772, 6:489
```

Scoring the same verified P replies against their root parent's C63 potential gives:

```text
Delta Psi < 0: 5,487 / 5,734 = 95.692%
Delta Psi = 0:    65 / 5,734
Delta Psi > 0:   182 / 5,734
Delta Psi range: -39 .. +7
```

Thus the existing q=23 selector usually decreases Psi, but not always. This does not refute
existence of a different decreasing P reply because these logs do not value every alternative.
Exact rho cannot be evaluated at q=23 from the available early-break P/N dumps: it requires a
full-expansion Grundy traversal. A rollout estimator could provide an approximate rho sample, but
would not have the exact semantics of the q=13--19 table.

## Reproduction and artifacts

```bash
rustc -O -C target-cpu=native notes/2026-07-06-grid-cap-solver.rs \
  -o rust/target/gridcap-c62
cd rust
python3 scripts/c62-selector-scoring.py --binary target/gridcap-c62
```

- `notes/2026-07-06-grid-cap-solver.rs`: exact `s4selectors` traversal and rho calculation.
- `rust/scripts/c62-selector-scoring.py`: corpus driver, aggregation, and q=23 log profiler.
- `rust/s4-dumps/2026-07-10/c62/selector-results.json`: generated machine-readable aggregate.
- `rust/s4-dumps/2026-07-10/c62/*.rho-fail.tsv`: exact rho counterexample rows.

The q=19 traversal used about 190 MB RSS and 107 seconds on one core.

## Route verdict

No family merits an exact-character-sum handoff: the algebraic families are either sparse or
imperfect, and rho is tree-defined and now explicitly refuted as an exact law. Promote the rho
failure TSVs to C61's reply-automaton corpus and retain pure rho as the strongest mining order.

Promote C63's Psi one step more cautiously: exact decreasing-P-reply existence now holds through
one q=19 root, but the proof bottleneck remains the selector. The most useful next related task is
C61: characterize the localized rho failures and the 12 rho/Delta-Psi split cases by a finite
geometric reply state, using Psi as the charge rather than adding more global scalar features.
