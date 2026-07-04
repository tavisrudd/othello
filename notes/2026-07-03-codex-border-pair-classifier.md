# Border-pair classifier pass
Date: 2026-07-03
## Running log



### Wrapper classifier run

Command: `ulimit -v 1000000; timeout 60s time -v python3 scripts/border_pair_classifier.py --csv ../notes/$(date +%F)-border-pair-features.csv --max-n 100`

Resource results:

```text
	Command being timed: "python3 scripts/border_pair_classifier.py --csv ../notes/2026-07-03-border-pair-features.csv --max-n 100"
	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:39.66
	Maximum resident set size (kbytes): 586868
	Exit status: 0
```

## Reconstructed formulas / script structure

Status: PROVEN by arithmetic for reconstructed B1-B5 formulas; verified for finite n in this pass.

Script path: `scripts/border_pair_classifier.py`.

Wrapper path: `scripts/run-border-pair-classifier-pass.sh`.

Run method: the wrapper invokes `python3 scripts/border_pair_classifier.py --csv ../notes/$(date +%F)-border-pair-features.csv` under `ulimit -v 1000000`, `timeout 60s`, and `time -v`.

CSV path from this run: `../notes/2026-07-03-border-pair-features.csv`.

Implemented functions include `attacks`, `central_strike`, `tau`, `live_after_position`, `scar_R_for_border_square`, `combined_scar_for_pair`, `combined_asym_for_pair`, `additive_labels`, and `line_label_orbits_under_tau`.

Record count generated in memory: `159236` legal row-to-column border pairs.

## Full border-pair feature table

Status: verified for finite n=8..100.

| n   | legal rows | expected | primary minimizer rows | secondary minimizer rows | score range | size range |
| --- | ---------- | -------- | ---------------------- | ------------------------ | ----------- | ---------- |
| 8   | 30         | 30       | 6                      | 6                        | 8..24       | 10..15     |
| 10  | 56         | 56       | 12                     | 10                       | 18..34      | 16..23     |
| 12  | 90         | 90       | 18                     | 15                       | 34..64      | 25..32     |
| 14  | 132        | 132      | 21                     | 18                       | 44..66      | 31..39     |
| 16  | 182        | 182      | 26                     | 21                       | 62..88      | 39..47     |
| 18  | 240        | 240      | 33                     | 32                       | 74..104     | 47..55     |
| 20  | 306        | 306      | 33                     | 32                       | 90..128     | 55..64     |
| 22  | 380        | 380      | 57                     | 54                       | 102..130    | 63..71     |
| 24  | 462        | 462      | 70                     | 68                       | 122..152    | 71..79     |
| 26  | 552        | 552      | 94                     | 92                       | 134..162    | 79..87     |
| 28  | 650        | 650      | 84                     | 82                       | 150..192    | 87..96     |
| 30  | 756        | 756      | 137                    | 137                      | 166..200    | 95..103    |
| 32  | 870        | 870      | 130                    | 130                      | 182..216    | 103..111   |
| 34  | 992        | 992      | 188                    | 188                      | 198..226    | 111..119   |
| 36  | 1122       | 1122     | 171                    | 171                      | 214..256    | 119..128   |
| 38  | 1260       | 1260     | 250                    | 250                      | 230..258    | 127..135   |
| 40  | 1406       | 1406     | 242                    | 242                      | 246..280    | 135..143   |
| 42  | 1560       | 1560     | 315                    | 315                      | 262..296    | 143..151   |
| 44  | 1722       | 1722     | 294                    | 294                      | 278..320    | 151..160   |
| 46  | 1892       | 1892     | 398                    | 398                      | 294..322    | 159..167   |
| 48  | 2070       | 2070     | 378                    | 378                      | 310..344    | 167..175   |
| 50  | 2256       | 2256     | 492                    | 492                      | 326..354    | 175..183   |
| 52  | 2450       | 2450     | 454                    | 454                      | 342..384    | 183..192   |
| 54  | 2652       | 2652     | 564                    | 564                      | 358..392    | 191..199   |
| 56  | 2862       | 2862     | 560                    | 560                      | 374..408    | 199..207   |
| 58  | 3080       | 3080     | 680                    | 680                      | 390..418    | 207..215   |
| 60  | 3306       | 3306     | 643                    | 643                      | 406..448    | 215..224   |
| 62  | 3540       | 3540     | 790                    | 790                      | 422..450    | 223..231   |
| 64  | 3782       | 3782     | 766                    | 766                      | 438..472    | 231..239   |
| 66  | 4032       | 4032     | 885                    | 885                      | 454..488    | 239..247   |
| 68  | 4290       | 4290     | 870                    | 870                      | 470..512    | 247..256   |
| 70  | 4556       | 4556     | 1048                   | 1048                     | 486..514    | 255..263   |
| 72  | 4830       | 4830     | 988                    | 988                      | 502..536    | 263..271   |
| 74  | 5112       | 5112     | 1168                   | 1168                     | 518..546    | 271..279   |
| 76  | 5402       | 5402     | 1126                   | 1126                     | 534..576    | 279..288   |
| 78  | 5700       | 5700     | 1281                   | 1281                     | 550..584    | 287..295   |
| 80  | 6006       | 6006     | 1286                   | 1286                     | 566..600    | 295..303   |
| 82  | 6320       | 6320     | 1460                   | 1460                     | 582..610    | 303..311   |
| 84  | 6642       | 6642     | 1397                   | 1397                     | 598..640    | 311..320   |
| 86  | 6972       | 6972     | 1618                   | 1618                     | 614..642    | 319..327   |
| 88  | 7310       | 7310     | 1578                   | 1578                     | 630..664    | 327..335   |
| 90  | 7656       | 7656     | 1760                   | 1760                     | 646..680    | 335..343   |
| 92  | 8010       | 8010     | 1734                   | 1734                     | 662..704    | 343..352   |
| 94  | 8372       | 8372     | 1958                   | 1958                     | 678..706    | 351..359   |
| 96  | 8742       | 8742     | 1889                   | 1889                     | 694..728    | 359..367   |
| 98  | 9120       | 9120     | 2146                   | 2146                     | 710..738    | 367..375   |
| 100 | 9506       | 9506     | 2094                   | 2094                     | 726..768    | 375..384   |

CSV written to `../notes/2026-07-03-border-pair-features.csv`. Sanity check: every n has `(n-2)(n-3)` legal pairs, excluding the center-gap coordinate and the illegal same-coordinate cross-arm reply.

## Minimizer-pattern compression

Status: verified for finite n=8..100; symbolic compression remains heuristic.

| bucket              | cases | avg |M| | same/opposite/mixed                       | common offsets                              | common abs offsets                     |
| ------------------- | ----- | ------- | ----------------------------------------- | ------------------------------------------- | -------------------------------------- |
| bulk left parity0   | 484   | 22.22   | {'same': 24, 'mixed': 460}                | 2:464, -4:463, -2:462, 6:425, 4:422         | 2:926, 4:885, 6:809, 8:768, 10:664     |
| bulk left parity1   | 506   | 18.53   | {'same': 33, 'opposite': 2, 'mixed': 471} | 2:444, -2:403, 6:371, 4:364, -6:339         | 2:847, 6:710, 4:693, 10:617, 8:573     |
| bulk right parity0  | 484   | 7.77    | {'opposite': 484}                         | -36:160, -40:160, -44:155, -32:153, -38:151 | 36:160, 40:160, 44:155, 32:153, 38:151 |
| bulk right parity1  | 506   | 7.62    | {'mixed': 45, 'opposite': 460, 'same': 1} | -38:165, -42:165, -34:162, -46:157, -30:155 | 38:165, 42:165, 34:162, 46:157, 30:155 |
| endpoint<=2 parity0 | 188   | 15.90   | {'opposite': 50, 'same': 7, 'mixed': 131} | 4:85, 8:78, 10:76, 12:74, 14:71             | 4:130, 8:119, 10:116, 12:113, 14:108   |
| endpoint<=2 parity1 | 94    | 17.54   | {'opposite': 5, 'mixed': 86, 'same': 3}   | 6:40, -6:40, 8:37, -8:37, 10:35             | 6:80, 8:74, 10:70, 12:66, 14:66        |
| gap<=2 parity0      | 90    | 11.24   | {'same': 45, 'opposite': 44, 'mixed': 1}  | -6:82, -10:73, -12:73, -14:65, -16:65       | 6:82, 10:73, 12:73, 14:65, 16:65       |
| gap<=2 parity1      | 92    | 8.67    | {'same': 44, 'mixed': 4, 'opposite': 44}  | -6:73, -10:60, -12:51, -14:51, -8:48        | 6:74, 10:60, 12:51, 14:51, 8:48        |

Best simple compression found: minimizers split meaningfully by endpoint/gap/bulk, parity, and side, but these features do not determine the set. Bulk cases often have nonlocal minimizers and many ties; endpoint and near-gap cases are more structured but still have exceptions depending on n mod 4/8 and dead-intersection tags.

Exceptions are not rare enough to state a clean B6 formula from these features alone.

## Simple predicate rule search

Status: verified for finite n=8..100; heuristic as a case-discovery tool.

Best one-predicate rules:

| rule                           | TP    | FP     | FN    | precision | recall | F1    |
| ------------------------------ | ----- | ------ | ----- | --------- | ------ | ----- |
| same_parity                    | 34165 | 44279  | 27    | 0.436     | 0.999  | 0.607 |
| unpaired_row_orbits_count==1   | 34192 | 125044 | 0     | 0.215     | 1.000  | 0.354 |
| unpaired_col_orbits_count==1   | 34192 | 125044 | 0     | 0.215     | 1.000  | 0.354 |
| unpaired_sum_orbits_count==2   | 33182 | 121260 | 1010  | 0.215     | 0.970  | 0.352 |
| unpaired_diff_orbits_count==2  | 32143 | 122299 | 2049  | 0.208     | 0.940  | 0.341 |
| total_unpaired_label_orbits==6 | 31133 | 118609 | 3059  | 0.208     | 0.911  | 0.339 |
| y_parity==0                    | 18533 | 62309  | 15659 | 0.229     | 0.542  | 0.322 |
| x_parity==0                    | 18516 | 62326  | 15676 | 0.229     | 0.542  | 0.322 |
| n_mod4==2                      | 17355 | 59833  | 16837 | 0.225     | 0.508  | 0.312 |
| same_side                      | 17430 | 60966  | 16762 | 0.222     | 0.510  | 0.310 |
| opposite_side                  | 16762 | 64078  | 17430 | 0.207     | 0.490  | 0.291 |
| n_mod4==0                      | 16837 | 65211  | 17355 | 0.205     | 0.492  | 0.290 |

Best two-predicate conjunctions:

| rule                                           | TP    | FP    | FN    | precision | recall | F1    |
| ---------------------------------------------- | ----- | ----- | ----- | --------- | ------ | ----- |
| same_parity AND unpaired_row_orbits_count==1   | 34165 | 44279 | 27    | 0.436     | 0.999  | 0.607 |
| same_parity AND unpaired_col_orbits_count==1   | 34165 | 44279 | 27    | 0.436     | 0.999  | 0.607 |
| same_parity AND unpaired_sum_orbits_count==2   | 33155 | 42891 | 1037  | 0.436     | 0.970  | 0.602 |
| same_parity AND unpaired_diff_orbits_count==2  | 32124 | 43922 | 2068  | 0.422     | 0.940  | 0.583 |
| same_parity AND total_unpaired_label_orbits==6 | 31114 | 42628 | 3078  | 0.422     | 0.910  | 0.577 |
| same_parity AND y_parity==0                    | 18511 | 21935 | 15681 | 0.458     | 0.541  | 0.496 |
| same_parity AND x_parity==0                    | 18511 | 21935 | 15681 | 0.458     | 0.541  | 0.496 |
| y_parity==0 AND x_parity==0                    | 18511 | 21935 | 15681 | 0.458     | 0.541  | 0.496 |
| same_parity AND same_side                      | 17422 | 20578 | 16770 | 0.458     | 0.510  | 0.483 |
| same_parity AND n_mod4==2                      | 17352 | 20644 | 16840 | 0.457     | 0.507  | 0.481 |
| same_parity AND n_mod4==0                      | 16813 | 23635 | 17379 | 0.416     | 0.492  | 0.451 |
| same_parity AND opposite_side                  | 16743 | 23701 | 17449 | 0.414     | 0.490  | 0.449 |

Greedy disjunctive rules selected for high-precision coverage:

| rule                    | new TP      | FP in full table | precision |
| ----------------------- | ----------- | ---------------- | --------- |
| mirror_offset==-2       | 1830        | 426              | 0.811     |
| mirror_offset==-4       | 1762        | 402              | 0.814     |
| mirror_offset==-6       | 1690        | 384              | 0.815     |
| mirror_offset==-8       | 1611        | 375              | 0.811     |
| mirror_offset==-12      | 1485        | 331              | 0.818     |
| mirror_offset==-10      | 1541        | 359              | 0.811     |
| same_parity             | 24246       | 44279            | 0.354     |
| mirror_offset==-1       | 10          | 2340             | 0.004     |
| covered target fraction | 34175/34192 |                  |           |

Interpretation: the rules expose useful case splits, but even the best small predicates have many false positives or low recall. This supports Outcome C rather than a clean finite table from the tested features.

## Asymptotic stabilization check

Status: verified for finite n=8..100; stabilization claims are heuristic.

| class              | n=40                                                                                                       | n=60                                                                                                        | n=80                                                                                                        | n=100                                                                                                       | stable last 4? |
| ------------------ | ---------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | -------------- |
| left endpoint k=0  | x=0 |M|=14 y=[4, 6, 8, 10, 12, 14]+ off=[4, 6, 8, 10, 12, 14]+ parity=[0] side=['left', 'right']           | x=0 |M|=23 y=[4, 6, 8, 10, 12, 16]+ off=[4, 6, 8, 10, 12, 16]+ parity=[0] side=['left', 'right']            | x=0 |M|=34 y=[4, 6, 8, 10, 12, 14]+ off=[4, 6, 8, 10, 12, 14]+ parity=[0] side=['left', 'right']            | x=0 |M|=42 y=[4, 6, 8, 10, 12, 14]+ off=[4, 6, 8, 10, 12, 14]+ parity=[0] side=['left', 'right']            | False          |
| right endpoint k=0 | x=38 |M|=14 y=[2, 4, 6, 8, 10, 14]+ off=[-36, -34, -32, -30, -28, -24]+ parity=[0] side=['left', 'right']  | x=58 |M|=23 y=[2, 4, 6, 8, 10, 12]+ off=[-56, -54, -52, -50, -48, -46]+ parity=[0] side=['left', 'right']   | x=78 |M|=34 y=[2, 4, 6, 8, 10, 12]+ off=[-76, -74, -72, -70, -68, -66]+ parity=[0] side=['left', 'right']   | x=98 |M|=42 y=[2, 4, 6, 8, 10, 12]+ off=[-96, -94, -92, -90, -88, -86]+ parity=[0] side=['left', 'right']   | False          |
| left endpoint k=1  | x=1 |M|=8 y=[7, 11, 13, 15, 23, 27]+ off=[6, 10, 12, 14, 22, 26]+ parity=[1] side=['left', 'right']        | x=1 |M|=19 y=[7, 9, 11, 13, 15, 17]+ off=[6, 8, 10, 12, 14, 16]+ parity=[1] side=['left', 'right']          | x=1 |M|=28 y=[7, 9, 11, 13, 15, 17]+ off=[6, 8, 10, 12, 14, 16]+ parity=[1] side=['left', 'right']          | x=1 |M|=40 y=[7, 9, 11, 13, 15, 17]+ off=[6, 8, 10, 12, 14, 16]+ parity=[1] side=['left', 'right']          | False          |
| right endpoint k=1 | x=37 |M|=8 y=[5, 7, 11, 15, 23, 25]+ off=[-32, -30, -26, -22, -14, -12]+ parity=[1] side=['left', 'right'] | x=57 |M|=19 y=[5, 7, 9, 11, 13, 15]+ off=[-52, -50, -48, -46, -44, -42]+ parity=[1] side=['left', 'right']  | x=77 |M|=28 y=[5, 7, 9, 11, 13, 15]+ off=[-72, -70, -68, -66, -64, -62]+ parity=[1] side=['left', 'right']  | x=97 |M|=40 y=[5, 7, 9, 11, 13, 15]+ off=[-92, -90, -88, -86, -84, -82]+ parity=[1] side=['left', 'right']  | False          |
| left endpoint k=2  | x=2 |M|=13 y=[4, 6, 10, 12, 14, 18]+ off=[2, 4, 8, 10, 12, 16]+ parity=[0] side=['left', 'right']          | x=2 |M|=19 y=[4, 6, 10, 12, 16, 18]+ off=[2, 4, 8, 10, 14, 16]+ parity=[0] side=['left', 'right']           | x=2 |M|=33 y=[4, 6, 10, 12, 14, 16]+ off=[2, 4, 8, 10, 12, 14]+ parity=[0] side=['left', 'right']           | x=2 |M|=41 y=[4, 6, 10, 12, 14, 16]+ off=[2, 4, 8, 10, 12, 14]+ parity=[0] side=['left', 'right']           | False          |
| right endpoint k=2 | x=36 |M|=1 y=[0] off=[-36] parity=[0] side=['left']                                                        | x=56 |M|=1 y=[0] off=[-56] parity=[0] side=['left']                                                         | x=76 |M|=1 y=[0] off=[-76] parity=[0] side=['left']                                                         | x=96 |M|=1 y=[0] off=[-96] parity=[0] side=['left']                                                         | False          |
| left endpoint k=3  | x=3 |M|=4 y=[5, 13, 25, 33] off=[2, 10, 22, 30] parity=[1] side=['left', 'right']                          | x=3 |M|=15 y=[5, 9, 13, 15, 17, 21]+ off=[2, 6, 10, 12, 14, 18]+ parity=[1] side=['left', 'right']          | x=3 |M|=24 y=[5, 9, 13, 15, 17, 21]+ off=[2, 6, 10, 12, 14, 18]+ parity=[1] side=['left', 'right']          | x=3 |M|=36 y=[5, 9, 13, 15, 17, 19]+ off=[2, 6, 10, 12, 14, 16]+ parity=[1] side=['left', 'right']          | False          |
| right endpoint k=3 | x=35 |M|=4 y=[5, 13, 25, 33] off=[-30, -22, -10, -2] parity=[1] side=['left', 'right']                     | x=55 |M|=15 y=[5, 9, 11, 13, 15, 17]+ off=[-50, -46, -44, -42, -40, -38]+ parity=[1] side=['left', 'right'] | x=75 |M|=24 y=[5, 9, 11, 13, 15, 17]+ off=[-70, -66, -64, -62, -60, -58]+ parity=[1] side=['left', 'right'] | x=95 |M|=36 y=[5, 9, 11, 13, 15, 17]+ off=[-90, -86, -84, -82, -80, -78]+ parity=[1] side=['left', 'right'] | False          |
| left endpoint k=4  | x=4 |M|=14 y=[0, 2, 6, 8, 10, 12]+ off=[-4, -2, 2, 4, 6, 8]+ parity=[0] side=['left', 'right']             | x=4 |M|=22 y=[0, 2, 6, 8, 10, 12]+ off=[-4, -2, 2, 4, 6, 8]+ parity=[0] side=['left', 'right']              | x=4 |M|=32 y=[0, 2, 6, 8, 10, 12]+ off=[-4, -2, 2, 4, 6, 8]+ parity=[0] side=['left', 'right']              | x=4 |M|=40 y=[0, 2, 6, 8, 10, 12]+ off=[-4, -2, 2, 4, 6, 8]+ parity=[0] side=['left', 'right']              | False          |
| right endpoint k=4 | x=34 |M|=2 y=[0, 2] off=[-34, -32] parity=[0] side=['left']                                                | x=54 |M|=2 y=[0, 2] off=[-54, -52] parity=[0] side=['left']                                                 | x=74 |M|=2 y=[0, 2] off=[-74, -72] parity=[0] side=['left']                                                 | x=94 |M|=2 y=[0, 2] off=[-94, -92] parity=[0] side=['left']                                                 | False          |
| left endpoint k=5  | x=5 |M|=6 y=[3, 7, 15, 21, 23, 31] off=[-2, 2, 10, 16, 18, 26] parity=[1] side=['left', 'right']           | x=5 |M|=14 y=[3, 7, 9, 13, 15, 21]+ off=[-2, 2, 4, 8, 10, 16]+ parity=[1] side=['left', 'right']            | x=5 |M|=26 y=[3, 7, 9, 13, 15, 21]+ off=[-2, 2, 4, 8, 10, 16]+ parity=[1] side=['left', 'right']            | x=5 |M|=38 y=[3, 7, 9, 13, 15, 19]+ off=[-2, 2, 4, 8, 10, 14]+ parity=[1] side=['left', 'right']            | False          |
| right endpoint k=5 | x=33 |M|=2 y=[1, 3] off=[-32, -30] parity=[1] side=['left']                                                | x=53 |M|=2 y=[1, 3] off=[-52, -50] parity=[1] side=['left']                                                 | x=73 |M|=2 y=[1, 3] off=[-72, -70] parity=[1] side=['left']                                                 | x=93 |M|=2 y=[1, 3] off=[-92, -90] parity=[1] side=['left']                                                 | False          |
| left gap k=1       | x=18 |M|=8 y=[2, 4, 6, 8, 10, 12]+ off=[-16, -14, -12, -10, -8, -6]+ parity=[0] side=['left']              | x=28 |M|=12 y=[2, 4, 6, 8, 10, 12]+ off=[-26, -24, -22, -20, -18, -16]+ parity=[0] side=['left']            | x=38 |M|=17 y=[2, 4, 6, 8, 10, 14]+ off=[-36, -34, -32, -30, -28, -24]+ parity=[0] side=['left']            | x=48 |M|=22 y=[2, 4, 6, 8, 10, 12]+ off=[-46, -44, -42, -40, -38, -36]+ parity=[0] side=['left']            | False          |
| right gap k=1      | x=20 |M|=6 y=[2, 4, 8, 10, 12, 14] off=[-18, -16, -12, -10, -8, -6] parity=[0] side=['left']               | x=30 |M|=11 y=[2, 4, 6, 8, 10, 12]+ off=[-28, -26, -24, -22, -20, -18]+ parity=[0] side=['left']            | x=40 |M|=17 y=[2, 4, 6, 8, 10, 12]+ off=[-38, -36, -34, -32, -30, -28]+ parity=[0] side=['left']            | x=50 |M|=20 y=[2, 4, 6, 8, 10, 12]+ off=[-48, -46, -44, -42, -40, -38]+ parity=[0] side=['left']            | False          |
| left gap k=2       | x=17 |M|=4 y=[7, 11, 13, 15] off=[-10, -6, -4, -2] parity=[1] side=['left']                                | x=27 |M|=8 y=[5, 7, 9, 11, 17, 21]+ off=[-22, -20, -18, -16, -10, -6]+ parity=[1] side=['left']             | x=37 |M|=15 y=[5, 7, 9, 11, 13, 15]+ off=[-32, -30, -28, -26, -24, -22]+ parity=[1] side=['left']           | x=47 |M|=18 y=[5, 7, 9, 11, 13, 17]+ off=[-42, -40, -38, -36, -34, -30]+ parity=[1] side=['left']           | False          |
| right gap k=2      | x=21 |M|=4 y=[5, 7, 11, 15] off=[-16, -14, -10, -6] parity=[1] side=['left']                               | x=31 |M|=7 y=[5, 7, 9, 11, 17, 21]+ off=[-26, -24, -22, -20, -14, -10]+ parity=[1] side=['left']            | x=41 |M|=13 y=[5, 7, 9, 11, 15, 17]+ off=[-36, -34, -32, -30, -26, -24]+ parity=[1] side=['left']           | x=51 |M|=18 y=[5, 7, 9, 11, 13, 15]+ off=[-46, -44, -42, -40, -38, -36]+ parity=[1] side=['left']           | False          |
| left gap k=3       | x=16 |M|=8 y=[0, 4, 6, 8, 10, 12]+ off=[-16, -12, -10, -8, -6, -4]+ parity=[0] side=['left']               | x=26 |M|=11 y=[0, 4, 6, 10, 12, 16]+ off=[-26, -22, -20, -16, -14, -10]+ parity=[0] side=['left']           | x=36 |M|=18 y=[0, 4, 6, 8, 10, 12]+ off=[-36, -32, -30, -28, -26, -24]+ parity=[0] side=['left']            | x=46 |M|=22 y=[0, 4, 6, 8, 10, 12]+ off=[-46, -42, -40, -38, -36, -34]+ parity=[0] side=['left']            | False          |
| right gap k=3      | x=22 |M|=6 y=[0, 4, 6, 8, 12, 14] off=[-22, -18, -16, -14, -10, -8] parity=[0] side=['left']               | x=32 |M|=9 y=[0, 4, 6, 8, 12, 16]+ off=[-32, -28, -26, -24, -20, -16]+ parity=[0] side=['left']             | x=42 |M|=16 y=[0, 4, 6, 8, 10, 12]+ off=[-42, -38, -36, -34, -32, -30]+ parity=[0] side=['left']            | x=52 |M|=20 y=[0, 4, 6, 8, 10, 12]+ off=[-52, -48, -46, -44, -42, -40]+ parity=[0] side=['left']            | False          |
| left gap k=4       | x=15 |M|=5 y=[1, 5, 13, 17, 21] off=[-14, -10, -2, 2, 6] parity=[1] side=['left', 'right']                 | x=25 |M|=11 y=[1, 5, 9, 11, 13, 15]+ off=[-24, -20, -16, -14, -12, -10]+ parity=[1] side=['left', 'right']  | x=35 |M|=13 y=[1, 5, 9, 13, 15, 23]+ off=[-34, -30, -26, -22, -20, -12]+ parity=[1] side=['left', 'right']  | x=45 |M|=22 y=[1, 5, 9, 11, 13, 15]+ off=[-44, -40, -36, -34, -32, -30]+ parity=[1] side=['left', 'right']  | False          |
| right gap k=4      | x=23 |M|=3 y=[1, 5, 13] off=[-22, -18, -10] parity=[1] side=['left']                                       | x=33 |M|=8 y=[1, 5, 9, 11, 13, 15]+ off=[-32, -28, -24, -22, -20, -18]+ parity=[1] side=['left']            | x=43 |M|=11 y=[1, 5, 9, 11, 13, 15]+ off=[-42, -38, -34, -32, -30, -28]+ parity=[1] side=['left']           | x=53 |M|=18 y=[1, 5, 9, 11, 13, 15]+ off=[-52, -48, -44, -42, -40, -38]+ parity=[1] side=['left']           | False          |
| left gap k=5       | x=14 |M|=10 y=[0, 2, 6, 8, 10, 12]+ off=[-14, -12, -8, -6, -4, -2]+ parity=[0] side=['left', 'right']      | x=24 |M|=14 y=[0, 2, 6, 8, 10, 12]+ off=[-24, -22, -18, -16, -14, -12]+ parity=[0] side=['left', 'right']   | x=34 |M|=20 y=[0, 2, 6, 8, 10, 12]+ off=[-34, -32, -28, -26, -24, -22]+ parity=[0] side=['left', 'right']   | x=44 |M|=23 y=[0, 2, 6, 8, 10, 12]+ off=[-44, -42, -38, -36, -34, -32]+ parity=[0] side=['left', 'right']   | False          |
| right gap k=5      | x=24 |M|=6 y=[0, 2, 6, 8, 10, 12] off=[-24, -22, -18, -16, -14, -12] parity=[0] side=['left']              | x=34 |M|=10 y=[0, 2, 6, 8, 10, 12]+ off=[-34, -32, -28, -26, -24, -22]+ parity=[0] side=['left']            | x=44 |M|=14 y=[0, 2, 6, 8, 10, 12]+ off=[-44, -42, -38, -36, -34, -32]+ parity=[0] side=['left']            | x=54 |M|=19 y=[0, 2, 6, 8, 10, 12]+ off=[-54, -52, -48, -46, -44, -42]+ parity=[0] side=['left']            | False          |
| left gap k=6       | x=13 |M|=6 y=[1, 3, 7, 15, 17, 23] off=[-12, -10, -6, 2, 4, 10] parity=[1] side=['left', 'right']          | x=23 |M|=9 y=[1, 3, 9, 13, 15, 21]+ off=[-22, -20, -14, -10, -8, -2]+ parity=[1] side=['left', 'right']     | x=33 |M|=16 y=[1, 3, 7, 9, 13, 15]+ off=[-32, -30, -26, -24, -20, -18]+ parity=[1] side=['left', 'right']   | x=43 |M|=20 y=[1, 3, 7, 9, 13, 15]+ off=[-42, -40, -36, -34, -30, -28]+ parity=[1] side=['left', 'right']   | False          |
| right gap k=6      | x=25 |M|=2 y=[3, 7] off=[-22, -18] parity=[1] side=['left']                                                | x=35 |M|=7 y=[1, 3, 7, 9, 13, 15]+ off=[-34, -32, -28, -26, -22, -20]+ parity=[1] side=['left']             | x=45 |M|=12 y=[1, 3, 7, 9, 13, 15]+ off=[-44, -42, -38, -36, -32, -30]+ parity=[1] side=['left']            | x=55 |M|=16 y=[1, 3, 7, 9, 13, 15]+ off=[-54, -52, -48, -46, -42, -40]+ parity=[1] side=['left']            | False          |
| alpha=0.250        | x=10 |M|=11 y=[0, 2, 4, 6, 12, 14]+ off=[-10, -8, -6, -4, 2, 4]+ parity=[0] side=['left', 'right']         | x=15 |M|=11 y=[1, 3, 5, 9, 11, 17]+ off=[-14, -12, -10, -6, -4, 2]+ parity=[1] side=['left', 'right']       | x=20 |M|=26 y=[0, 2, 4, 8, 10, 12]+ off=[-20, -18, -16, -12, -10, -8]+ parity=[0] side=['left', 'right']    | x=25 |M|=30 y=[1, 3, 5, 7, 9, 11]+ off=[-24, -22, -20, -18, -16, -14]+ parity=[1] side=['left', 'right']    | False          |
| alpha=0.333        | x=13 |M|=6 y=[1, 3, 7, 15, 17, 23] off=[-12, -10, -6, 2, 4, 10] parity=[1] side=['left', 'right']          | x=20 |M|=14 y=[0, 2, 4, 10, 12, 16]+ off=[-20, -18, -16, -10, -8, -4]+ parity=[0] side=['left', 'right']    | x=26 |M|=23 y=[0, 2, 4, 6, 10, 14]+ off=[-26, -24, -22, -20, -16, -12]+ parity=[0] side=['left', 'right']   | x=33 |M|=28 y=[1, 3, 5, 7, 9, 11]+ off=[-32, -30, -28, -26, -24, -22]+ parity=[1] side=['left', 'right']    | False          |
| alpha=0.450        | x=18 |M|=8 y=[2, 4, 6, 8, 10, 12]+ off=[-16, -14, -12, -10, -8, -6]+ parity=[0] side=['left']              | x=27 |M|=8 y=[5, 7, 9, 11, 17, 21]+ off=[-22, -20, -18, -16, -10, -6]+ parity=[1] side=['left']             | x=36 |M|=18 y=[0, 4, 6, 8, 10, 12]+ off=[-36, -32, -30, -28, -26, -24]+ parity=[0] side=['left']            | x=45 |M|=22 y=[1, 5, 9, 11, 13, 15]+ off=[-44, -40, -36, -34, -32, -30]+ parity=[1] side=['left', 'right']  | False          |
| alpha=0.550        | x=22 |M|=6 y=[0, 4, 6, 8, 12, 14] off=[-22, -18, -16, -14, -10, -8] parity=[0] side=['left']               | x=33 |M|=8 y=[1, 5, 9, 11, 13, 15]+ off=[-32, -28, -24, -22, -20, -18]+ parity=[1] side=['left']            | x=44 |M|=14 y=[0, 2, 6, 8, 10, 12]+ off=[-44, -42, -38, -36, -34, -32]+ parity=[0] side=['left']            | x=55 |M|=16 y=[1, 3, 7, 9, 13, 15]+ off=[-54, -52, -48, -46, -42, -40]+ parity=[1] side=['left']            | False          |
| alpha=0.667        | x=26 |M|=3 y=[2, 4, 10] off=[-24, -22, -16] parity=[0] side=['left']                                       | x=40 |M|=6 y=[0, 4, 6, 8, 12, 16] off=[-40, -36, -34, -32, -28, -24] parity=[0] side=['left']               | x=53 |M|=8 y=[3, 5, 7, 9, 11, 15]+ off=[-50, -48, -46, -44, -42, -38]+ parity=[1] side=['left']             | x=66 |M|=13 y=[2, 4, 6, 8, 10, 12]+ off=[-64, -62, -60, -58, -56, -54]+ parity=[0] side=['left']            | False          |
| alpha=0.750        | x=30 |M|=4 y=[0, 2, 4, 6] off=[-30, -28, -26, -24] parity=[0] side=['left']                                | x=45 |M|=6 y=[1, 3, 5, 7, 9, 11] off=[-44, -42, -40, -38, -36, -34] parity=[1] side=['left']                | x=60 |M|=9 y=[0, 2, 4, 6, 8, 10]+ off=[-60, -58, -56, -54, -52, -50]+ parity=[0] side=['left']              | x=75 |M|=10 y=[1, 3, 5, 7, 9, 13]+ off=[-74, -72, -70, -68, -66, -62]+ parity=[1] side=['left']             | False          |

Reading: fixed endpoint-distance and fixed center-gap classes sometimes repeat qualitative parity/side behavior, but exact minimizer offsets usually grow with n or branch into more ties. Bulk proportional x is plainly non-stabilized through n=100 under absolute-offset signatures.

## Label-orbit explanation of minimizers

Status: verified for finite n=8..100; formula candidates are heuristic.

| features                           | groups | ambiguous groups | records in ambiguous groups | max score spread within group |
| ---------------------------------- | ------ | ---------------- | --------------------------- | ----------------------------- |
| orbit counts                       | 4      | 4                | 159236                      | 758                           |
| orbit counts + cover/overlap       | 1043   | 498              | 147916                      | 6                             |
| counts + cover/overlap + dead tags | 1816   | 800              | 147656                      | 6                             |
| above + parity/side                | 3516   | 1263             | 143124                      | 6                             |

Simple label-orbit ranking tests for each `(n,x)` row:

| ranking key                   | exact minimizer-set cases | mean precision | mean recall |
| ----------------------------- | ------------------------- | -------------- | ----------- |
| min orbit cover               | 172/2444                  | 0.418          | 0.996       |
| min orbit cover, max overlap  | 267/2444                  | 0.555          | 0.995       |
| min total orbits, min cover   | 45/2444                   | 0.229          | 0.072       |
| min total orbits, max overlap | 45/2444                   | 0.229          | 0.072       |
| min cover, min secondary scar | 172/2444                  | 0.075          | 0.073       |

The label-orbit features strongly constrain the support of asymmetry, but counts plus overlap corrections still do not uniquely determine `|combined_asym|` across all n<=100. Simple orbit-cover rankings are useful hints, not exact minimizer characterizations.

## B6 compression attempt

Status: failed / refuted for the tested small symbolic feature families; verified through n<=100.

Outcome C is the plain result of this pass.

### Negative finding

Through n<=100, no rule using the tested features predicts primary minimizers without many exceptions.  Endpoint/gap/bulk, parity, side, n mod 4/8, small offsets, mirror offsets, and label-orbit counts all expose structure, but none yields a compact exact finite table.

B6 should remain an empirical minimization table for now, or be replaced by a different invariant.  The more promising theorem shape is: arithmetic minimizers define candidate repairs; actual winning repairs require residual-state context from the solver.

## Recommended solver telemetry

Status: actionable proposal; needs solver run.

Log one record per tau-failure / border-scar repair event with fields:

- `n`
- `ply`
- `position_hash_or_canonical_id`
- `opponent_square`
- `opponent_class`
- `tau_reply_legal`
- `border_state`
- `x_y_border_coordinate_if_applicable`
- `candidate_replies_count`
- `best_asym_score`
- `best_secondary_scar_size`
- `solver_chosen_reply`
- `solver_chosen_reply_rank_by_asym`
- `is_solver_reply_primary_minimizer`
- `is_solver_reply_secondary_minimizer`
- `child_value_if_known`
- `unpaired_label_orbit_counts`
- `orbit_cover_size`
- `orbit_overlap_count`
- `combined_scar_size`
- `combined_asym_size`

Primary question: do solver-winning repair replies correlate with B6 asymmetry minimizers, or do they frequently choose higher-asymmetry replies because of residual-state tactics?

## Final summary

### Strong positive findings

- verified for finite n=8..100: the feature table covers every legal row-to-column border pair and passes the `(n-2)(n-3)` row-count sanity check.
- verified for finite n=8..100: minimizer sets have real structure by endpoint/gap/bulk, parity, and side, but they are tie-heavy and nonlocal in bulk.
- heuristic: label-orbit cover, overlap count, dead-intersection tags, and coordinate class are useful repair vocabulary fields.

### Negative findings / failed simplifications

- failed / refuted for tested features: no small predicate family gives an exact symbolic B6 minimizer rule through n<=100.
- failed / refuted: local offset rules such as `y=x+-k`, endpoint preference, center-gap preference, or mirror-coordinate preference are not sufficient.
- heuristic caution: asymmetry minimization remains only a candidate-repair generator, not a winning-strategy certificate.

### Best symbolic minimizer rule found

No exact rule. Best usable compression is a finite-state vocabulary: endpoint/gap/bulk class, side, parity, n mod 4/8, dead-intersection tags, unpaired label-orbit counts, orbit cover size, and orbit overlap count.

### Remaining exceptions

Bulk proportional coordinates do not stabilize by absolute offset through n=100, and many endpoint/gap classes branch into multiple tied minimizers depending on n and parity.

### Files created

- `scripts/border_pair_classifier.py`
- `scripts/run-border-pair-classifier-pass.sh`
- `../notes/2026-07-03-border-pair-features.csv`
- `../notes/2026-07-03-codex-border-pair-classifier.md`

### Recommended next low-memory experiment

Search for a different invariant: compare minimizers by exact overlap graph of unpaired label-orbit line sets, not just counts and scalar overlap totals.

### Recommended next solver-side experiment

Add the telemetry record above to repair events and compare solver-winning replies against primary/secondary asymmetry minimizers on n=10/12/14/16/18 when the box is free.

_Script resource footer: elapsed=39.297s, maxrss=586868 KB._

