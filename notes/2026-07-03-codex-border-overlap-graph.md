# Border overlap-graph pass
Date: 2026-07-03
## Running log



### Wrapper overlap-graph run

Command: `ulimit -v 1000000; timeout 60s time -v python3 scripts/border_overlap_graph_pass.py --csv ../notes/$(date +%F)-border-pair-features.csv --max-exact-n 40`

Resource results:

```text
	Command being timed: "python3 scripts/border_overlap_graph_pass.py --csv ../notes/2026-07-03-border-pair-features.csv --max-exact-n 40"
	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:22.21
	Maximum resident set size (kbytes): 555880
	Exit status: 0
```

## Overlap-graph invariant pass

Status: verified for finite n=8..100 for pairwise signatures; exact incidence checked for n<=40.

Input CSV: `../notes/2026-07-03-border-pair-features.csv`.
Rows read: `159236`.
Asymmetry recomputation mismatches: `0`.

| signature                               | groups | ambiguous score groups | max score spread | ambiguous minimizer groups |
| --------------------------------------- | ------ | ---------------------- | ---------------- | -------------------------- |
| border pairwise overlap graph           | 159157 | 0                      | 0                | 1                          |
| full-used pairwise overlap graph        | 159157 | 0                      | 0                | 1                          |
| exact border incidence hypergraph n<=40 | 9486   | 0                      | 0                | 0                          |

Interpretation:

- The pairwise overlap graph determines `|combined_asym|` for every pair in n<=100 in this representation.
- However, it barely compresses: the number of pairwise signatures is almost the number of pairs, so this is closer to a lossless encoding than a finite symbolic vocabulary.
- The exact oriented incidence hypergraph determines the score on n<=40, as expected: it encodes the active-vs-mate coverage pattern whose xor is the asymmetry.
- Minimizer membership is almost signature-local in the finite data, but this is mostly because signatures are nearly unique.  A theorem still needs row context `(n,x)` or a real compression of the signature space.

Pairwise-signature minimizer purity:

| class                                    | signature count |
| ---------------------------------------- | --------------- |
| pure minimizer signatures                | 34191           |
| mixed minimizer/non-minimizer signatures | 1               |
| pure non-minimizer signatures            | 124965          |

## Candidate invariant update

Status: heuristic.

The pairwise graph is already effectively lossless for the score in this finite range.  The next useful invariant is a compressed quotient of the pairwise or exact oriented incidence graph, plus the row context `(n,x)` score threshold.

## Final summary

### Strong positive findings

- verified for n<=100: pairwise overlap signatures determine `|combined_asym|` with zero score ambiguity in this data set.
- verified for n<=40: exact oriented incidence hypergraph also determines `|combined_asym|`.

### Negative findings

- failed / refuted as compression: pairwise signatures are nearly unique, so score determination is not yet a small finite-state rule.
- heuristic caution: minimizer membership still needs row context or threshold data, not only a local pair signature.

### Recommended next low-memory experiment

Compress pairwise/exact incidence signatures by quotienting symmetries and deleting metric labels, then test how much score ambiguity returns. The goal is a small finite vocabulary, not a lossless fingerprint.

### Recommended solver-side experiment

Log the exact overlap-hypergraph signature or a hash of it in repair telemetry, alongside solver-chosen replies and B6 minimizer rank.

_Script resource footer: elapsed=22.006s, maxrss=555880 KB._


### Wrapper overlap-quotient continuation run

Command: `ulimit -v 1000000; timeout 60s time -v python3 scripts/border_overlap_quotient_pass.py --csv ../notes/$(date +%F)-border-pair-features.csv`

Resource results:

```text
```

Overlap-quotient continuation failed or timed out with status 124.

```text
```


### Wrapper overlap-quotient continuation run

Command: `ulimit -v 1000000; timeout 180s time -v python3 scripts/border_overlap_quotient_pass.py --csv ../notes/$(date +%F)-border-pair-features.csv`

Resource results:

```text
	Command being timed: "python3 scripts/border_overlap_quotient_pass.py --csv ../notes/2026-07-03-border-pair-features.csv"
	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:44.90
	Maximum resident set size (kbytes): 78408
	Exit status: 0
```

## Quotient/compression continuation

Status: verified for finite n=8..100 using the previous border-pair CSV.

Input CSV: `../notes/2026-07-03-border-pair-features.csv`.
Rows read: `159236`.
Asymmetry recomputation mismatches: `0`.

The variants below deliberately quotient the previous rich overlap graph.  `score-exact rows` is the percentage of rows whose quotient class has a single `|combined_asym|` value.  `min-pure rows` is the percentage of rows whose quotient class is not mixed between minimizers and non-minimizers.

Implementation note: quotient classes are grouped by in-process Python hashes of immutable signatures to keep this continuation under the low-memory/time budget.  The collision risk is negligible for this diagnostic pass, but theorem claims should use canonical signatures.

| quotient                                  | groups | compression | ambiguous score groups | score-exact rows | max spread | mixed min groups | min-pure rows |
| ----------------------------------------- | ------ | ----------- | ---------------------- | ---------------- | ---------- | ---------------- | ------------- |
| csv: unpaired orbit counts                | 4      | 39809.00x   | 4                      | 0.00%            | 758        | 3                | 0.06%         |
| csv: counts + cover/overlap               | 1043   | 152.67x     | 498                    | 7.11%            | 6          | 199              | 59.56%        |
| csv: counts + cover/overlap + parity      | 1402   | 113.58x     | 677                    | 7.11%            | 6          | 199              | 59.60%        |
| csv: counts + cover/overlap + side + nmod | 3268   | 48.73x      | 932                    | 52.29%           | 6          | 391              | 75.14%        |
| edge multiset exact family                | 59346  | 2.68x       | 148                    | 99.63%           | 4          | 3477             | 95.47%        |
| edge multiset cap4 family                 | 177    | 899.64x     | 121                    | 0.09%            | 736        | 48               | 34.08%        |
| edge multiset cap2 family                 | 87     | 1830.30x    | 79                     | 0.02%            | 736        | 34               | 29.43%        |
| edge multiset boolean family              | 87     | 1830.30x    | 79                     | 0.02%            | 736        | 34               | 29.43%        |

### Same-parity filter check

| filter      | rows selected | minimizers selected | precision | recall |
| ----------- | ------------- | ------------------- | --------- | ------ |
| same parity | 78444         | 34165               | 0.436     | 0.999  |

### Row-context minimizer purity

Status: heuristic diagnostic.  These quotients are augmented with `(n,x)` because minimizer status is row-relative.

| row-context quotient                      | groups | compression | ambiguous score groups | score-exact rows | max spread | mixed min groups | min-pure rows |
| ----------------------------------------- | ------ | ----------- | ---------------------- | ---------------- | ---------- | ---------------- | ------------- |
| row context + csv: counts + cover/overlap | 19138  | 8.32x       | 8914                   | 14.97%           | 6          | 2069             | 66.03%        |
| row context + edge multiset cap4 family   | 41332  | 3.85x       | 3176                   | 70.82%           | 12         | 1420             | 84.54%        |
| row context + edge multiset cap2 family   | 33476  | 4.76x       | 3347                   | 68.47%           | 12         | 1502             | 83.16%        |

### Largest residual spreads: csv counts + cover/overlap

| spread | rows | min example                           | max example                            |
| ------ | ---- | ------------------------------------- | -------------------------------------- |
| 6      | 368  | n=98, x=1, y=50, score=726, min=False | n=98, x=32, y=65, score=732, min=False |
| 6      | 352  | n=94, x=1, y=48, score=694, min=False | n=94, x=32, y=65, score=700, min=False |
| 6      | 320  | n=86, x=1, y=44, score=630, min=False | n=86, x=28, y=57, score=636, min=False |
| 6      | 320  | n=90, x=1, y=46, score=662, min=False | n=90, x=30, y=61, score=668, min=False |
| 6      | 304  | n=82, x=1, y=42, score=598, min=False | n=82, x=28, y=57, score=604, min=False |

### Largest residual spreads: edge multiset cap4 family

| spread | rows | min example                         | max example                            |
| ------ | ---- | ----------------------------------- | -------------------------------------- |
| 736    | 94   | n=8, x=0, y=6, score=18, min=False  | n=100, x=0, y=98, score=754, min=False |
| 720    | 184  | n=10, x=0, y=1, score=24, min=False | n=100, x=0, y=1, score=744, min=False  |
| 720    | 184  | n=10, x=1, y=8, score=26, min=False | n=100, x=1, y=98, score=746, min=False |
| 720    | 176  | n=10, x=2, y=6, score=34, min=False | n=100, x=2, y=96, score=754, min=False |
| 720    | 92   | n=10, x=1, y=7, score=26, min=False | n=100, x=1, y=97, score=746, min=False |

### Largest residual spreads: edge multiset cap2 family

| spread | rows | min example                        | max example                             |
| ------ | ---- | ---------------------------------- | --------------------------------------- |
| 736    | 2180 | n=8, x=2, y=4, score=18, min=False | n=100, x=2, y=96, score=754, min=False  |
| 736    | 94   | n=8, x=0, y=6, score=18, min=False | n=100, x=0, y=98, score=754, min=False  |
| 732    | 96   | n=8, x=0, y=2, score=10, min=False | n=100, x=0, y=48, score=742, min=False  |
| 732    | 48   | n=8, x=0, y=4, score=8, min=True   | n=100, x=0, y=50, score=740, min=False  |
| 732    | 48   | n=8, x=2, y=6, score=12, min=False | n=100, x=48, y=98, score=744, min=False |

### Interpretation

- Scalar counts plus cover/overlap remain a strong low-dimensional approximation but do not determine the score exactly.
- Exact edge-multiset quotients still determine the score in this finite range while compressing substantially more than the fully indexed pairwise graph.
- Coarser finite-looking quotients lose exactness quickly: cap4/cap2 and family-collapsed variants produce bounded but real score ambiguity.
- Adding row context improves minimizer purity, but even row-context scalar features are not enough to identify the minimizing replies exactly.
- The useful candidate invariant is probably an edge-overlap multiset with a small amount of metric bucketing, not a single coordinate formula `y=f(x)`.

## Updated working hypothesis

Status: heuristic.

For border-pair repair candidates, `|combined_asym|` is controlled by the overlap pattern among unpaired line orbits.  The exact edge multiset is already enough in n<=100, but theorem-useful compression must keep some metric information about line lengths and intersections.  Parity is a high-recall candidate filter; edge-overlap buckets are the better ranking vocabulary.

## Continuation summary

### Strong positive findings

- verified for n<=100: exact edge-multiset quotients determine `|combined_asym|` while compressing the indexed graph.
- verified for n<=100: scalar cover/overlap features give a bounded residual ambiguity but not an exact invariant.

### Negative findings

- failed / refuted as exact compression: deleting too much metric information from the edge overlaps creates real score ambiguity.
- failed / refuted as exact repair rule: row-context scalar features still leave mixed minimizer classes.

### Next low-memory experiment

Use edge-multiset quotients as candidate generators: for each `(n,x)`, rank `y` by bucketed edge signature and measure candidate-set size needed to capture all true asymmetry minimizers.

### Next solver-side experiment

Log both the exact edge-multiset hash and a bucketed edge-multiset hash for solver-chosen repair replies, then compare chosen replies against the asymmetry-minimizer rank.

_Continuation resource footer: elapsed=44.814s, maxrss=78408 KB._


### Wrapper overlap-quotient corrected continuation run

Command: `ulimit -v 1000000; timeout 180s time -v python3 scripts/border_overlap_quotient_pass.py --csv ../notes/$(date +%F)-border-pair-features.csv`

Resource results:

```text
	Command being timed: "python3 scripts/border_overlap_quotient_pass.py --csv ../notes/2026-07-03-border-pair-features.csv"
	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:44.66
	Maximum resident set size (kbytes): 120808
	Exit status: 0
```

## Quotient/compression continuation

Status: verified for finite n=8..100 using the previous border-pair CSV.

Input CSV: `../notes/2026-07-03-border-pair-features.csv`.
Rows read: `159236`.
Asymmetry recomputation mismatches: `0`.

The variants below deliberately quotient the previous rich overlap graph.  `score-exact rows` is the percentage of rows whose quotient class has a single `|combined_asym|` value.  `min-pure rows` is the percentage of rows whose quotient class is not mixed between minimizers and non-minimizers.

Implementation note: quotient classes are grouped by in-process Python hashes of immutable signatures to keep this continuation under the low-memory/time budget.  The collision risk is negligible for this diagnostic pass, but theorem claims should use canonical signatures.

| quotient                                  | groups | compression | ambiguous score groups | score-exact rows | max spread | mixed min groups | min-pure rows |
| ----------------------------------------- | ------ | ----------- | ---------------------- | ---------------- | ---------- | ---------------- | ------------- |
| csv: unpaired orbit counts                | 4      | 39809.00x   | 4                      | 0.00%            | 758        | 3                | 0.06%         |
| csv: counts + cover/overlap               | 1043   | 152.67x     | 498                    | 7.11%            | 6          | 199              | 59.56%        |
| csv: counts + cover/overlap + parity      | 1402   | 113.58x     | 677                    | 7.11%            | 6          | 199              | 59.60%        |
| csv: counts + cover/overlap + side + nmod | 3268   | 48.73x      | 932                    | 52.29%           | 6          | 391              | 75.14%        |
| edge multiset exact full kind             | 159156 | 1.00x       | 0                      | 100.00%          | 0          | 2                | 100.00%       |
| edge multiset exact family                | 59346  | 2.68x       | 148                    | 99.63%           | 4          | 3477             | 95.47%        |
| edge multiset cap4 family                 | 177    | 899.64x     | 121                    | 0.09%            | 736        | 48               | 34.08%        |
| edge multiset cap2 family                 | 87     | 1830.30x    | 79                     | 0.02%            | 736        | 34               | 29.43%        |
| edge multiset boolean family              | 87     | 1830.30x    | 79                     | 0.02%            | 736        | 34               | 29.43%        |

### Same-parity filter check

| filter      | rows selected | minimizers selected | precision | recall |
| ----------- | ------------- | ------------------- | --------- | ------ |
| same parity | 78444         | 34165               | 0.436     | 0.999  |

### Row-context minimizer purity

Status: heuristic diagnostic.  These quotients are augmented with `(n,x)` because minimizer status is row-relative.

| row-context quotient                      | groups | compression | ambiguous score groups | score-exact rows | max spread | mixed min groups | min-pure rows |
| ----------------------------------------- | ------ | ----------- | ---------------------- | ---------------- | ---------- | ---------------- | ------------- |
| row context + csv: counts + cover/overlap | 19138  | 8.32x       | 8914                   | 14.97%           | 6          | 2069             | 66.03%        |
| row context + edge multiset cap4 family   | 41332  | 3.85x       | 3176                   | 70.82%           | 12         | 1420             | 84.54%        |
| row context + edge multiset cap2 family   | 33476  | 4.76x       | 3347                   | 68.47%           | 12         | 1502             | 83.16%        |

### Largest residual spreads: csv counts + cover/overlap

| spread | rows | min example                           | max example                            |
| ------ | ---- | ------------------------------------- | -------------------------------------- |
| 6      | 368  | n=98, x=1, y=50, score=726, min=False | n=98, x=32, y=65, score=732, min=False |
| 6      | 352  | n=94, x=1, y=48, score=694, min=False | n=94, x=32, y=65, score=700, min=False |
| 6      | 320  | n=86, x=1, y=44, score=630, min=False | n=86, x=28, y=57, score=636, min=False |
| 6      | 320  | n=90, x=1, y=46, score=662, min=False | n=90, x=30, y=61, score=668, min=False |
| 6      | 304  | n=82, x=1, y=42, score=598, min=False | n=82, x=28, y=57, score=604, min=False |

### Largest residual spreads: edge multiset cap4 family

| spread | rows | min example                         | max example                            |
| ------ | ---- | ----------------------------------- | -------------------------------------- |
| 736    | 94   | n=8, x=0, y=6, score=18, min=False  | n=100, x=0, y=98, score=754, min=False |
| 720    | 184  | n=10, x=0, y=1, score=24, min=False | n=100, x=0, y=1, score=744, min=False  |
| 720    | 184  | n=10, x=1, y=8, score=26, min=False | n=100, x=1, y=98, score=746, min=False |
| 720    | 176  | n=10, x=2, y=6, score=34, min=False | n=100, x=2, y=96, score=754, min=False |
| 720    | 92   | n=10, x=1, y=7, score=26, min=False | n=100, x=1, y=97, score=746, min=False |

### Largest residual spreads: edge multiset cap2 family

| spread | rows | min example                        | max example                             |
| ------ | ---- | ---------------------------------- | --------------------------------------- |
| 736    | 2180 | n=8, x=2, y=4, score=18, min=False | n=100, x=2, y=96, score=754, min=False  |
| 736    | 94   | n=8, x=0, y=6, score=18, min=False | n=100, x=0, y=98, score=754, min=False  |
| 732    | 96   | n=8, x=0, y=2, score=10, min=False | n=100, x=0, y=48, score=742, min=False  |
| 732    | 48   | n=8, x=0, y=4, score=8, min=True   | n=100, x=0, y=50, score=740, min=False  |
| 732    | 48   | n=8, x=2, y=6, score=12, min=False | n=100, x=48, y=98, score=744, min=False |

### Interpretation

- Scalar counts plus cover/overlap remain a strong low-dimensional approximation but do not determine the score exactly.
- The exact full-kind edge multiset is the key compression test: it preserves line color and exact overlap counts while dropping indexed vertex identities.
- Collapsing row/col and sum/diff into broad families is nearly exact but not theorem-grade exact in this finite range.
- Coarser finite-looking quotients lose exactness quickly: cap4/cap2 family variants throw away too much metric scale.
- Adding row context improves minimizer purity, but even row-context scalar features are not enough to identify the minimizing replies exactly.
- The useful candidate invariant is probably an edge-overlap multiset with a small amount of metric bucketing, not a single coordinate formula `y=f(x)`.

## Updated working hypothesis

Status: heuristic.

For border-pair repair candidates, `|combined_asym|` is controlled by the overlap pattern among unpaired line orbits.  The theorem-useful invariant must preserve enough metric information about line lengths, intersections, and probably the row/col/sum/diff color of each orbit.  Parity is a high-recall candidate filter; edge-overlap buckets are the better ranking vocabulary.

## Continuation summary

### Strong positive findings

- verified for n<=100: exact edge-multiset quotients are the strongest compressed overlap invariant tested; see the table for whether full-kind and family-collapsed versions are exact.
- verified for n<=100: scalar cover/overlap features give bounded residual ambiguity but not an exact invariant.

### Negative findings

- failed / refuted as exact compression: deleting too much metric information from the edge overlaps creates real score ambiguity.
- failed / refuted as exact repair rule: row-context scalar features still leave mixed minimizer classes.

### Next low-memory experiment

Use edge-multiset quotients as candidate generators: for each `(n,x)`, rank `y` by bucketed edge signature and measure candidate-set size needed to capture all true asymmetry minimizers.

### Next solver-side experiment

Log both the exact edge-multiset hash and a bucketed edge-multiset hash for solver-chosen repair replies, then compare chosen replies against the asymmetry-minimizer rank.

_Continuation resource footer: elapsed=44.544s, maxrss=120808 KB._


### Wrapper candidate-generator continuation run

Command: `ulimit -v 1000000; timeout 180s time -v python3 scripts/border_candidate_generator_pass.py --csv ../notes/$(date +%F)-border-pair-features.csv`

Resource results:

```text
	Command being timed: "python3 scripts/border_candidate_generator_pass.py --csv ../notes/2026-07-03-border-pair-features.csv"
	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:27.63
	Maximum resident set size (kbytes): 128680
	Exit status: 0
```

## Candidate-generator continuation

Status: verified for finite n=8..100 using the previous border-pair CSV.

Input CSV: `../notes/2026-07-03-border-pair-features.csv`.
Opponent rows `(n,x)`: `2444`.
Legal border-pair rows: `159236`.

A policy covers a row when its candidate set contains every true B6 asymmetry minimizer for that `(n,x)`.  Bucket-best policies select every reply whose quotient bucket contains at least one exact asymmetry minimizer in the same row; this measures candidate-set inflation caused by quotienting.

| candidate policy                 | rows covering all minimizers | minimizer recall | mean size | median | p90 | max | mean legal % |
| -------------------------------- | ---------------------------- | ---------------- | --------- | ------ | --- | --- | ------------ |
| exact asymmetry minimizers       | 100.00%                      | 1.0000           | 13.99     | 12     | 29  | 44  | 20.77%       |
| exact asymmetry <= min+2         | 100.00%                      | 1.0000           | 21.70     | 16     | 50  | 88  | 32.64%       |
| exact asymmetry <= min+4         | 100.00%                      | 1.0000           | 34.99     | 33     | 62  | 93  | 52.55%       |
| exact asymmetry <= min+6         | 100.00%                      | 1.0000           | 42.71     | 37     | 81  | 96  | 64.48%       |
| same parity only                 | 99.35%                       | 0.9992           | 32.10     | 35     | 45  | 49  | 49.08%       |
| same parity and <= min+4         | 99.35%                       | 0.9992           | 27.27     | 29     | 42  | 48  | 40.53%       |
| scalar cover/overlap bucket-best | 100.00%                      | 1.0000           | 25.06     | 27     | 40  | 47  | 36.54%       |
| edge exact-family bucket-best    | 100.00%                      | 1.0000           | 14.02     | 12     | 29  | 44  | 20.86%       |
| edge cap4-family bucket-best     | 100.00%                      | 1.0000           | 14.81     | 13     | 30  | 45  | 22.19%       |
| edge cap2-family bucket-best     | 100.00%                      | 1.0000           | 14.90     | 13     | 30  | 46  | 22.42%       |

### Worst candidate-set examples

| policy                           | candidate size | n   | x  | legal replies | true minimizers |
| -------------------------------- | -------------- | --- | -- | ------------- | --------------- |
| exact asymmetry minimizers       | 44             | 98  | 96 | 95            | 44              |
| exact asymmetry minimizers       | 44             | 98  | 0  | 95            | 44              |
| exact asymmetry <= min+2         | 88             | 100 | 98 | 97            | 42              |
| exact asymmetry <= min+2         | 88             | 100 | 0  | 97            | 42              |
| exact asymmetry <= min+4         | 93             | 100 | 98 | 97            | 42              |
| exact asymmetry <= min+4         | 92             | 100 | 0  | 97            | 42              |
| exact asymmetry <= min+6         | 96             | 100 | 74 | 97            | 12              |
| exact asymmetry <= min+6         | 96             | 100 | 24 | 97            | 36              |
| same parity only                 | 49             | 100 | 98 | 97            | 42              |
| same parity only                 | 49             | 100 | 96 | 97            | 1               |
| same parity and <= min+4         | 48             | 100 | 74 | 97            | 12              |
| same parity and <= min+4         | 48             | 100 | 24 | 97            | 36              |
| scalar cover/overlap bucket-best | 47             | 100 | 74 | 97            | 12              |
| scalar cover/overlap bucket-best | 47             | 100 | 24 | 97            | 36              |
| edge exact-family bucket-best    | 44             | 98  | 96 | 95            | 44              |
| edge exact-family bucket-best    | 44             | 98  | 0  | 95            | 44              |
| edge cap4-family bucket-best     | 45             | 98  | 96 | 95            | 44              |
| edge cap4-family bucket-best     | 45             | 98  | 0  | 95            | 44              |
| edge cap2-family bucket-best     | 46             | 98  | 96 | 95            | 44              |
| edge cap2-family bucket-best     | 46             | 98  | 0  | 95            | 44              |

### Interpretation

- Exact asymmetry minimizers are already a small arithmetic candidate set; score bands show how much slack a repair oracle would need if it accepts near-minimizers.
- Same parity remains an excellent recall filter but is far too broad on its own.
- Scalar cover/overlap buckets are compact but inflate candidate sets because many different replies share the same scalar summary.
- Exact-family edge buckets are much tighter than scalar buckets, but their prior score ambiguity means they are still a candidate generator rather than a theorem-ready minimizer rule.
- Cap4/cap2 family buckets are useful only as coarse filters; they are too broad to be the final repair vocabulary.

## Candidate-generator summary

### Strong positive findings

- verified for n<=100: exact asymmetry minimizer sets are small enough to be used as B6 candidate seeds.
- verified for n<=100: exact-family edge buckets give a tighter candidate generator than scalar cover/overlap buckets.

### Negative findings

- failed / refuted as sufficient filter: same parity alone keeps almost all minimizers but selects too many replies.
- failed / refuted as final finite vocabulary: cap4/cap2 family edge buckets remain too coarse.

### Next low-memory experiment

For the rows where exact-family buckets inflate beyond the exact minimizer set, classify the collisions by `(n,x)` side/gap class and by which edge overlaps were family-collapsed.

### Next solver-side experiment

When solver telemetry is available, compare solver-chosen repairs first against exact asymmetry minimizers, then against exact-family edge-bucket candidates.

_Candidate-generator resource footer: elapsed=27.472s, maxrss=128680 KB._


### Wrapper exact-family collision continuation run

Command: `ulimit -v 1000000; timeout 180s time -v python3 scripts/border_family_collision_pass.py --csv ../notes/$(date +%F)-border-pair-features.csv`

Resource results:

```text
	Command being timed: "python3 scripts/border_family_collision_pass.py --csv ../notes/2026-07-03-border-pair-features.csv"
	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:19.25
	Maximum resident set size (kbytes): 111012
	Exit status: 0
```

## Exact-family collision continuation

Status: verified for finite n=8..100 using the previous border-pair CSV.

Input CSV: `../notes/2026-07-03-border-pair-features.csv`.
Opponent rows `(n,x)`: `2444`.
Rows where exact-family bucket-best inflates beyond exact minimizers: `78`.
Extra non-minimizer replies admitted by exact-family buckets: `78`.
Mean extras per inflated row: `1.00`.
Max extras in one row: `1`.
Max score delta among extras: `4`.

### Collision distributions

| score delta | extra replies |
| ----------- | ------------- |
| 4           | 78            |

| x class         | extra replies |
| --------------- | ------------- |
| endpoint        | 0             |
| near endpoint   | 3             |
| near center gap | 0             |
| bulk            | 75            |

| y class         | extra replies |
| --------------- | ------------- |
| endpoint        | 0             |
| near endpoint   | 0             |
| near center gap | 78            |
| bulk            | 0             |

| side relation | extra replies |
| ------------- | ------------- |
| same side     | 15            |
| opposite side | 63            |

| parity relation | extra replies |
| --------------- | ------------- |
| same parity     | 78            |
| opposite parity | 0             |

### Collision size by n

| n  | extra replies |
| -- | ------------- |
| 22 | 4             |
| 26 | 3             |
| 14 | 2             |
| 16 | 2             |
| 20 | 2             |
| 28 | 2             |
| 32 | 2             |
| 34 | 2             |
| 38 | 2             |
| 40 | 2             |
| 44 | 2             |
| 46 | 2             |

### Family-group structure

These counts describe selected family buckets that contain both a true minimizer and at least one non-minimizer.

| family bucket size | mixed selected buckets |
| ------------------ | ---------------------- |
| 2                  | 78                     |

| distinct full-kind buckets inside family bucket | mixed selected buckets |
| ----------------------------------------------- | ---------------------- |
| 2                                               | 78                     |

### Largest inflated rows

| extras | n   | x  | legal replies | true minimizers | min score |
| ------ | --- | -- | ------------- | --------------- | --------- |
| 1      | 100 | 46 | 97            | 22              | 734       |
| 1      | 100 | 16 | 97            | 34              | 734       |
| 1      | 98  | 45 | 95            | 21              | 710       |
| 1      | 98  | 15 | 95            | 34              | 710       |
| 1      | 96  | 44 | 93            | 21              | 702       |
| 1      | 94  | 43 | 91            | 20              | 678       |
| 1      | 94  | 15 | 91            | 32              | 678       |
| 1      | 92  | 42 | 89            | 20              | 670       |
| 1      | 92  | 14 | 89            | 31              | 670       |
| 1      | 90  | 41 | 87            | 17              | 646       |
| 1      | 88  | 40 | 85            | 20              | 638       |
| 1      | 88  | 14 | 85            | 31              | 638       |

### Example extra replies

| n  | x  | y  | score delta | x class       | y class         | side     | same parity | offset | mirror offset |
| -- | -- | -- | ----------- | ------------- | --------------- | -------- | ----------- | ------ | ------------- |
| 12 | 2  | 6  | 4           | near endpoint | near center gap | opposite | True        | 4      | -2            |
| 14 | 3  | 7  | 4           | bulk          | near center gap | opposite | True        | 4      | -2            |
| 14 | 9  | 5  | 4           | bulk          | near center gap | opposite | True        | -4     | 2             |
| 16 | 2  | 8  | 4           | near endpoint | near center gap | opposite | True        | 6      | -4            |
| 16 | 4  | 8  | 4           | bulk          | near center gap | opposite | True        | 4      | -2            |
| 18 | 5  | 9  | 4           | bulk          | near center gap | opposite | True        | 4      | -2            |
| 20 | 2  | 8  | 4           | near endpoint | near center gap | same     | True        | 6      | -8            |
| 20 | 6  | 10 | 4           | bulk          | near center gap | opposite | True        | 4      | -2            |
| 22 | 3  | 11 | 4           | bulk          | near center gap | opposite | True        | 8      | -6            |
| 22 | 7  | 11 | 4           | bulk          | near center gap | opposite | True        | 4      | -2            |
| 22 | 13 | 9  | 4           | bulk          | near center gap | opposite | True        | -4     | 2             |
| 22 | 17 | 9  | 4           | bulk          | near center gap | opposite | True        | -8     | 6             |

### Interpretation

- Exact-family bucket inflation is rare relative to all `(n,x)` rows, but it is not zero.
- The collisions are precisely where family collapse loses enough row/col/sum/diff color information to merge a true minimizer with a nearby non-minimizer bucket.
- This supports preserving full line color in theorem-facing invariants, while using family buckets only as a compact heuristic candidate generator.

## Collision summary

### Strong positive findings

- verified for n<=100: exact-family bucket-best differs only slightly from exact asymmetry minimizers.
- verified for n<=100: the residual extras have small score deltas, so family buckets are a good heuristic generator.

### Negative findings

- failed / refuted as exact invariant: collapsing line colors to orth/diag admits non-minimizers.

### Next low-memory experiment

Repeat the collision classification with a color-preserving but coordinate-symmetry-quotiented full-kind edge signature, to see whether exactness can survive a nontrivial quotient.

_Exact-family collision resource footer: elapsed=19.170s, maxrss=111012 KB._


### Wrapper full-kind symmetry quotient continuation run

Command: `ulimit -v 1000000; timeout 180s time -v python3 scripts/border_symmetry_quotient_pass.py --csv ../notes/$(date +%F)-border-pair-features.csv`

Resource results:

```text
	Command being timed: "python3 scripts/border_symmetry_quotient_pass.py --csv ../notes/2026-07-03-border-pair-features.csv"
	Elapsed (wall clock) time (h:mm:ss or m:ss): 1:07.87
	Maximum resident set size (kbytes): 173948
	Exit status: 0
```

## Full-kind symmetry quotient continuation

Status: verified for finite n=8..100 using the previous border-pair CSV.

Input CSV: `../notes/2026-07-03-border-pair-features.csv`.
Rows read: `159236`.

This pass keeps exact row/col/sum/diff line colors and exact overlap counts, then quotients only by simple line-direction symmetries.  It is still grouped by in-process Python hashes for the low-memory diagnostic run.

| quotient                                                | groups | compression | ambiguous score groups | score-exact rows | max spread | mixed min groups | min-pure rows |
| ------------------------------------------------------- | ------ | ----------- | ---------------------- | ---------------- | ---------- | ---------------- | ------------- |
| full-kind exact, no symmetry quotient                   | 159156 | 1.00x       | 0                      | 100.00%          | 0          | 2                | 100.00%       |
| full-kind exact + active/mate global quotient           | 159156 | 1.00x       | 0                      | 100.00%          | 0          | 2                | 100.00%       |
| full-kind exact + row/col kind quotient                 | 79618  | 2.00x       | 0                      | 100.00%          | 0          | 3444             | 95.67%        |
| full-kind exact + sum/diff kind quotient                | 159156 | 1.00x       | 0                      | 100.00%          | 0          | 2                | 100.00%       |
| full-kind exact + row/col + sum/diff quotient           | 79618  | 2.00x       | 0                      | 100.00%          | 0          | 3444             | 95.67%        |
| full-kind exact + line-direction quotient + active/mate | 79618  | 2.00x       | 0                      | 100.00%          | 0          | 3444             | 95.67%        |

### Interpretation

- The no-quotient full-kind edge multiset is essentially the exact overlap fingerprint from the prior continuation.
- Any symmetry quotient that keeps score-exact rows at 100% is a viable theorem-facing compression candidate.
- If row/col, sum/diff, or active/mate quotients introduce score ambiguity, those symmetries cannot be applied blindly without extra orientation context.

## Symmetry quotient summary

### Strong positive findings

- verified for n<=100: color-preserving symmetry quotients can be tested purely arithmetically without solver work.

### Negative findings

- Any nonzero ambiguity in the table marks a symmetry quotient that is not theorem-ready by itself.

### Next low-memory experiment

For the smallest ambiguous symmetry quotient, list concrete colliding pairs and derive the missing orientation bit that separates them.

_Full-kind symmetry quotient resource footer: elapsed=67.743s, maxrss=173948 KB._


### Wrapper full-kind symmetry quotient continuation run

Command: `ulimit -v 1000000; timeout 180s time -v python3 scripts/border_symmetry_quotient_pass.py --csv ../notes/$(date +%F)-border-pair-features.csv`

Resource results:

```text
	Command being timed: "python3 scripts/border_symmetry_quotient_pass.py --csv ../notes/2026-07-03-border-pair-features.csv"
	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:55.59
	Maximum resident set size (kbytes): 173968
	Exit status: 0
```

## Full-kind symmetry quotient continuation

Status: verified for finite n=8..100 using the previous border-pair CSV.

Input CSV: `../notes/2026-07-03-border-pair-features.csv`.
Rows read: `159236`.

This pass keeps exact row/col/sum/diff line colors and exact overlap counts, then quotients only by simple line-direction symmetries.  It is still grouped by in-process Python hashes for the low-memory diagnostic run.

| quotient                                                | groups | compression | ambiguous score groups | score-exact rows | max spread | mixed min groups | min-pure rows |
| ------------------------------------------------------- | ------ | ----------- | ---------------------- | ---------------- | ---------- | ---------------- | ------------- |
| full-kind exact, no symmetry quotient                   | 159156 | 1.00x       | 0                      | 100.00%          | 0          | 2                | 100.00%       |
| full-kind exact + active/mate global quotient           | 159156 | 1.00x       | 0                      | 100.00%          | 0          | 2                | 100.00%       |
| full-kind exact + row/col kind quotient                 | 79618  | 2.00x       | 0                      | 100.00%          | 0          | 3444             | 95.67%        |
| full-kind exact + sum/diff kind quotient                | 159156 | 1.00x       | 0                      | 100.00%          | 0          | 2                | 100.00%       |
| full-kind exact + row/col + sum/diff quotient           | 79618  | 2.00x       | 0                      | 100.00%          | 0          | 3444             | 95.67%        |
| full-kind exact + line-direction quotient + active/mate | 79618  | 2.00x       | 0                      | 100.00%          | 0          | 3444             | 95.67%        |

### Interpretation

- The no-quotient full-kind edge multiset is essentially the exact overlap fingerprint from the prior continuation.
- All tested color-preserving symmetry quotients keep `|combined_asym|` score-exact through n<=100.
- The row/col kind quotient is the useful one in this data: it halves the number of groups with zero score ambiguity.
- Sum/diff and global active/mate quotients add no visible compression here.
- Mixed minimizer groups under row/col quotient are row-context effects, not score ambiguity; they matter for repair choice but not for computing `|combined_asym|`.

## Symmetry quotient summary

### Strong positive findings

- verified for n<=100: full-kind exact edge signatures modulo row/col kind swap still determine `|combined_asym|` exactly.
- verified for n<=100: this row/col quotient gives a clean 2x compression of the exact full-kind signature space.

### Negative findings

- failed / refuted as context-free repair classifier: row/col quotient creates mixed minimizer groups even though the score remains exact.

### Next low-memory experiment

Try to prove the row/col symmetry quotient algebraically for `|combined_asym|`, then separately classify the mixed-minimizer row-context collisions.

_Full-kind symmetry quotient resource footer: elapsed=55.469s, maxrss=173968 KB._


## Literature note: statistical-mechanics N-Queens paper

Status: heuristic / external vocabulary, not a game-theoretic result.

Reference: arXiv:2605.10326, https://arxiv.org/abs/2605.10326

Useful translation into this project:


- The paper's energy formulation is line-label native: rows, columns, and both diagonal families contribute conflicts through line occupancy counts. This is the same additive vocabulary used here as row/col/sum/diff labels.
- The row/column/diagonal constraint hierarchy supports separating reservoir density from diagonal scar damage. That matches the current proof direction: keep a dense core/reservoir while treating border scar lines as structured perturbations.
- The tensor-network encoding is a compact four-signal line-state checker: an occupied square consumes/emits row, column, sum-diagonal, and diff-diagonal signals. This is a useful external model for certificate verification or completion-count diagnostics after fixed scar states.
- The counting method could, in principle, count completions of a residual board with fixed consumed labels or boundary signals. That is mobility/counting evidence, not a P/N or Grundy solver.

What not to import:

- The thermodynamic-integration and asymptotic counting results do not directly address the impartial game, central strike, border repair, or nimbers.
- The tensor network is exact but exponential under naive contraction, so it should be used only for tiny residual checks or as theorem/certificate vocabulary unless a specialized contraction is developed.

Candidate use in future notes:


- Define a four-channel line-signal certificate for a fixed position: consumed row labels, consumed column labels, consumed sum labels, and consumed diff labels.
- Add reservoir diagnostics based on line loads: max row/col load, max diagonal load, and scar-induced line-load imbalance.
- When solver telemetry is available, log line-load energy deltas for chosen repair replies alongside the existing asymmetry and edge-overlap hashes.


### Wrapper row/col mixed-context continuation run

Command: `ulimit -v 1000000; timeout 180s time -v python3 scripts/border_rowcol_mixed_context_pass.py --csv ../notes/$(date +%F)-border-pair-features.csv`

Resource results:

```text
	Command being timed: "python3 scripts/border_rowcol_mixed_context_pass.py --csv ../notes/2026-07-03-border-pair-features.csv"
	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:12.46
	Maximum resident set size (kbytes): 439556
	Exit status: 0
```

## Row/col quotient mixed-context continuation

Status: verified for finite n=8..100 using the previous border-pair CSV.

Input CSV: `../notes/2026-07-03-border-pair-features.csv`.
Rows read: `159236`.
Row/col quotient groups: `79618`.
Mixed minimizer/non-minimizer groups: `3444`.
Rows in mixed groups: `6888`.
Minimizer records in mixed groups: `3444`.
Non-minimizer records in mixed groups: `3444`.

Because the row/col quotient is score-exact, a mixed group means the same local overlap score is a row minimum in one `(n,x)` context and not a row minimum in another. This is context dependence, not score ambiguity.

### Non-minimizer score delta in mixed groups

| score - row_min | records |
| --------------- | ------- |
| 2               | 27      |
| 4               | 3413    |
| 6               | 4       |

### Mixed-group concentration by n

| n   | mixed-group records |
| --- | ------------------- |
| 96  | 370                 |
| 84  | 334                 |
| 100 | 332                 |
| 90  | 300                 |
| 92  | 300                 |
| 88  | 276                 |
| 78  | 258                 |
| 72  | 252                 |
| 98  | 248                 |
| 76  | 236                 |
| 80  | 236                 |
| 94  | 236                 |
| 60  | 214                 |
| 86  | 212                 |
| 66  | 210                 |
| 68  | 204                 |

### Largest mixed groups

| score | records | min records | nonmin records | nonmin deltas | min examples                  | nonmin examples               |
| ----- | ------- | ----------- | -------------- | ------------- | ----------------------------- | ----------------------------- |
| 10    | 2       | 1           | 1              | {2: 1}        | n=8,x=2,y=0,score=10,delta=0  | n=8,x=0,y=2,score=10,delta=2  |
| 12    | 2       | 1           | 1              | {4: 1}        | n=8,x=5,y=0,score=12,delta=0  | n=8,x=0,y=5,score=12,delta=4  |
| 10    | 2       | 1           | 1              | {2: 1}        | n=8,x=1,y=4,score=10,delta=0  | n=8,x=4,y=1,score=10,delta=2  |
| 10    | 2       | 1           | 1              | {2: 1}        | n=8,x=6,y=4,score=10,delta=0  | n=8,x=4,y=6,score=10,delta=2  |
| 22    | 2       | 1           | 1              | {4: 1}        | n=10,x=5,y=0,score=22,delta=0 | n=10,x=0,y=5,score=22,delta=4 |
| 22    | 2       | 1           | 1              | {4: 1}        | n=10,x=1,y=6,score=22,delta=0 | n=10,x=6,y=1,score=22,delta=4 |
| 22    | 2       | 1           | 1              | {4: 1}        | n=10,x=8,y=2,score=22,delta=0 | n=10,x=2,y=8,score=22,delta=4 |
| 22    | 2       | 1           | 1              | {4: 1}        | n=10,x=8,y=6,score=22,delta=0 | n=10,x=6,y=8,score=22,delta=4 |
| 36    | 2       | 1           | 1              | {2: 1}        | n=12,x=3,y=0,score=36,delta=0 | n=12,x=0,y=3,score=36,delta=2 |
| 36    | 2       | 1           | 1              | {2: 1}        | n=12,x=6,y=0,score=36,delta=0 | n=12,x=0,y=6,score=36,delta=2 |
| 36    | 2       | 1           | 1              | {2: 1}        | n=12,x=7,y=0,score=36,delta=0 | n=12,x=0,y=7,score=36,delta=2 |
| 40    | 2       | 1           | 1              | {6: 1}        | n=12,x=9,y=0,score=40,delta=0 | n=12,x=0,y=9,score=40,delta=6 |

### Algebraic reading

Status: heuristic proof sketch.

The row/col quotient preserves `|combined_asym|` because transposition of the embedded S-core swaps row and column label masks while preserving square counts, tau-pair counts, and all pairwise intersections with the diagonal label masks. For a row-arm to column-arm border pair, quotienting row/col color identifies transpose-dual overlap fingerprints; xor-size of active-vs-tau-mate cover is invariant under that transpose.

The quotient does not preserve minimizer status because minimizer status is not a local score property. It depends on the competing scores available in the fixed row context `(n,x)`. The same quotient class and same absolute score can be optimal for one opponent coordinate and suboptimal for another.

## Row/col mixed-context summary

### Strong positive findings

- verified for n<=100: row/col-quotiented full-kind edge signatures preserve `|combined_asym|` exactly.
- verified for n<=100: mixed minimizer groups are explained by row-baseline context rather than local score ambiguity.

### Negative findings

- failed / refuted as local repair oracle: even a score-exact local quotient does not decide whether a reply is an asymmetry minimizer without `(n,x)` context.

### Next low-memory experiment

Write a theorem-ready lemma for transpose invariance of the row/col quotient, then define repair telemetry as `(row_context, local_overlap_signature, score_rank)` rather than local signature alone.

_Row/col mixed-context resource footer: elapsed=12.258s, maxrss=439556 KB._


## Search-structure implications from older handoffs

Status: synthesis / heuristic, with references to measured older data.

References read:

- `../notes/handoffs/2026-06-17-per-ply-distinct-measurement.md`: transpositions are strictly intra-ply; per-ply distinct distribution is the sizing gate for ply-windowing and value-only layers.
- `../notes/handoffs/2026-06-15-queens-memory-roadmap.md`: BuRR/value-only density is only sound under known membership; graph-iso freeze key gives a measured ~3.4x merge at freeze/archive time; staged root clearing without archive loses cross-root reuse.
- `../notes/handoffs/2026-06-17-root-ordering-exploration.md`: root order has weak upside; most positions are root-private and no universal trunk exists.
- `../notes/handoffs/2026-06-19-explicit-stack-frontier.md`: move-ordering scalar features failed; recurse-weighted ranklab showed much apparent ordering loss was cheap getK-leaf work.
- `../notes/handoffs/2026-06-22-push-past-floor-levers.md`: canonical getK value layer, code-key memo, component decomposition, treewidth DP, and canon-skip were all killed by measurement; compression signals usually appeared where work was cheap.
- `../notes/proposal-2026-07-02-tt-reexpansion-law.md`: TT re-expansion should be modeled per band; small-n curves degrade gracefully, while large-n pain comes from high R_infinity / expensive band structure rather than a literal mathematical divergence.
- `../notes/handoffs/2026-06-23-queens-n18-umbrella.md`: skip[18,25] made n=18 converge; band-skipping works when skipped-band recompute is bounded and storing that band would create high eviction pressure.
- `../notes/handoffs/2026-07-01-queens-nimber-a344227.md`: nimber heap-sum engine should inherit the same band/context telemetry; h=0 rounds dominate and bk/dense leaves matter.
- arXiv:2605.10326: line-load/row-column-diagonal energy and four-channel tensor vocabulary support the additive label model, but do not directly imply game strategy.

### Implication for solver implementation

Status: heuristic / engineering recommendation.

The useful runtime unit is not just a canonical position. It is a context-rich record:

```text
(pc or ply band, parent/root context, local overlap signature, score or rank)
```

This combines the old band results with the new border-pair findings:

- Old solver data: storage, re-expansion, getK cost, and skip profitability are strongly popcount-band dependent.
- New border data: exact local overlap signatures compute `|combined_asym|`, but minimizer status needs row context `(n,x)`.
- Killer/refutation data: parent/root-specific context can be decisive where global scalar predictors fail.
- The statistical-mechanics paper gives line-load vocabulary: row, column, sum-diagonal, and diff-diagonal occupancy/energy.

Recommended telemetry fields for future solver-side repair events:

```text
n
ply
pc
root_move
parent_move
opponent_move
candidate_reply
child_pc
is_getK_leaf
is_recurse_child
tau_reply_legal
border_state
combined_asym
asymmetry_rank
exact_full_kind_edge_hash
row_col_quotient_edge_hash
line_load_delta_rows_cols_sums_diffs
TT_hit_or_miss
cut_rank
killer_rank
child_value_or_grundy_if_known
```

Solver policy implication:


- Use asymmetry minimizers and edge-overlap buckets as candidate generators and move-ordering features.
- Do not prune on them yet.
- Index any learned or tabled repair advice by `(pc/ply band, parent/root context, overlap signature, score rank)`, not by local move coordinate alone.
- Keep storage policy band-aware: skip cheap bounded-recompute bands, store bands where misses trigger expensive recursive recomputation.
- Preserve the ply-window/value-only archive idea as the serious compression route, but gate it on per-ply distinct measurements and explicit membership semantics.

### Implication for theory

Status: heuristic proof direction.

The older data argues against generic graph-structure compression as a theorem path:

- component decomposition is essentially absent in the tail;
- treewidth can be low but still not useful because the searched subtree is already tiny per instance;
- canonical/value memoization compresses most where the replaced work is cheap;
- scalar move features are too weak to identify strategic replies.

The theory path should instead be arithmetic and contextual:

```text
mirror core
+ live-border occupancy <= 2
+ exact scar line-label formulas
+ overlap-signature candidate set
+ row/context-dependent repair oracle
+ reservoir / line-load inequalities
```

B6 should be stated as a candidate-generator observation, not as a universal reply theorem:

```text
Border-pair asymmetry minimizers form a small structured arithmetic candidate set.
They are not determined by a simple local coordinate rule; repair selection needs row
context and likely residual-state context.
```

### What to do next

Status: recommended next work.

1. Low-memory theory note: write theorem-ready lemmas for the score-exact overlap facts now observed:
   - row/col transpose quotient preserves `|combined_asym|`;
   - full-kind edge overlap signature determines the border-pair asymmetry score in the finite data;
   - row context is necessary for minimizer status.
2. Low-memory arithmetic experiment: for each `(n,x)`, classify the exact asymmetry minimizer set by size and interval/side structure; output a compact candidate-set table, not a reply formula.
3. Solver telemetry design: add a gated repair-event log schema matching the fields above, but do not run it while the box is busy.
4. Storage/search architecture after the box is free: run or revive `count --by-ply` to size the widest ply and decide whether ply-windowed value-only layers are feasible for the next large run.
5. Solver-side validation after the box is free: compare actual solver/killer repair choices against exact asymmetry minimizers and row/col-quotiented edge buckets.

Near-term choice: do item 1 next. It is pure proof hygiene, costs no RAM, and turns the useful verified arithmetic into reusable lemmas before more tables accumulate.


## Theorem-ready overlap lemmas

Status: proof hygiene / theorem drafting.  Claims below are marked individually.

Notation: even `n=2m`, `q=n-1`, `h=m-1`, central strike `c*=(h,h)`, embedded core `S=[0..q-1]^2=[0..n-2]^2`, and live core

```text
R_n = { (r,c) in S : r != h, c != h, r+c != q-1, r-c != 0 }.
```

The involution is `tau(r,c)=(q-1-r,q-1-c)`.  For a legal row-to-column border pair, write `b=(q,x)`, `r=(y,q)`, where `x,y in [0,q-1]\{h}` and `x != y`.

### Lemma O1: tau action on additive line labels

Statement.  Inside `S`, the involution `tau` maps line labels by

```text
row a  -> row  (q-1-a)
col b  -> col  (q-1-b)
sum s  -> sum  (2q-2-s)
diff d -> diff (-d)
```

Proof.  If `(r',c')=tau(r,c)`, then `r'=q-1-r`, `c'=q-1-c`, `r'+c'=2q-2-(r+c)`, and `r'-c'=-(r-c)`.  Each displayed formula is just the corresponding coordinate identity.

Status: PROVEN by arithmetic.

### Lemma O2: border-pair scar as six line labels

Statement.  The live-core scar of the legal border pair `(q,x),(y,q)` is

```text
scar(x,y) = R_n intersect (
    col x
  union row y
  union sum  (q+x)
  union sum  (q+y)
  union diff (q-x)
  union diff (y-q)
).
```

Proof.  A queen at `(q,x)` attacks, inside `S`, exactly column `x`, difference diagonal `r-c=q-x`, and sum diagonal `r+c=q+x`; its row `q` lies outside `S`.  A queen at `(y,q)` attacks, inside `S`, exactly row `y`, difference diagonal `r-c=y-q`, and sum diagonal `r+c=y+q`; its column `q` lies outside `S`.  Intersect with `R_n` because the central strike has already killed the center row, center column, anti-diagonal `q-1`, and main diagonal `0`.

Status: PROVEN by arithmetic.

### Lemma O3: active/mate union formula for combined asymmetry

Statement.  Let `A(x,y)` be the union of the six active line masks from Lemma O2, restricted to `R_n`.  Let `M(x,y)=tau(A(x,y))`, equivalently the union of the six tau-mate line masks from Lemma O1.  Then

```text
combined_asym(x,y) = |A(x,y) symmetric_difference M(x,y)|.
```

Proof.  By definition, `combined_scar = scar(x,y) = A(x,y)`.  Since `tau` is a bijection on `R_n` and distributes over unions, `tau(combined_scar)=M(x,y)`.  The square-level asymmetry is `combined_scar symmetric_difference tau(combined_scar)`, which is the displayed expression.

Status: PROVEN by arithmetic.

### Lemma O4: incidence hypergraph determines asymmetry exactly

Statement.  For each square `s in R_n`, record two incidence bitmasks:

```text
active_mask(s) = active line-orbits whose active line contains s
mate_mask(s)   = active line-orbits whose tau-mate line contains s
```

Then `combined_asym(x,y)` is determined by the multiset of pairs `(active_mask(s), mate_mask(s))` over `s in R_n`; explicitly,

```text
|combined_asym| = sum_{s in R_n} 1[(active_mask(s) != 0) xor (mate_mask(s) != 0)].
```

Proof.  A square lies in `A(x,y)` iff its active mask is nonzero, and lies in `M(x,y)` iff its mate mask is nonzero.  Membership in the symmetric difference is exactly exclusive-or of these two nonzero tests.  Summing over `R_n` gives the formula.

Status: PROVEN by arithmetic.

Note.  The exact incidence-hypergraph script checked this representation for `n<=40`; the lemma itself is a definition-level proof and does not depend on the finite check.

### Lemma O5: board automorphisms commuting with tau preserve asymmetry

Statement.  Let `pi` be a bijection of `R_n` such that `pi tau = tau pi`.  Then for every scar set `A subseteq R_n`,

```text
|A symmetric_difference tau(A)| = |pi(A) symmetric_difference tau(pi(A))|.
```

In particular, the transpose map `sigma(r,c)=(c,r)` preserves the asymmetry size, because it preserves `R_n` and commutes with `tau`.

Proof.  Since `pi` is a bijection, it preserves cardinality.  Since it commutes with `tau`, `pi(tau(A))=tau(pi(A))`.  Therefore `pi(A symmetric_difference tau(A))=pi(A) symmetric_difference tau(pi(A))`, and the two sets have the same size.  The transpose preserves `R_n` because it swaps the center row/column exclusions, fixes the anti-diagonal exclusion `r+c=q-1`, and maps the main diagonal exclusion `r-c=0` to itself.

Status: PROVEN by arithmetic.

### Lemma O6: row/col quotient is score-exact in finite data

Statement.  For all legal row-to-column border pairs with even `n=8,10,...,100`, the full-kind edge-overlap signature modulo row/column kind swap determines `|combined_asym|`.  The finite table was:

```text
full-kind exact, no symmetry quotient:         159156 groups, 0 ambiguous score groups
full-kind exact + row/col kind quotient:        79618 groups, 0 ambiguous score groups
full-kind exact + row/col + sum/diff quotient:  79618 groups, 0 ambiguous score groups
```

Proof sketch / why plausible.  Lemma O5 proves that actual transposition preserves asymmetry.  The finite row/col quotient appears to identify only transpose-dual local overlap fingerprints as far as the score is concerned; all tested identifications preserve the active-vs-mate xor size.  A theorem proof should show that the quotient does not merge two non-transpose incidence patterns with different counts.

Status: verified for finite n<=100; proof gap remains.

Proof obligation.  Derive the row/col quotient directly from the six line labels in Lemma O2 and the tau-action in Lemma O1, or exhibit the finite set of possible non-transpose collisions and show their xor-counts agree.

### Lemma O7: full-kind pairwise edge signature is empirically score-exact

Statement.  For all legal row-to-column border pairs with even `n=8,10,...,100`, the full-kind pairwise edge-overlap signature determines `|combined_asym|` in the generated data.

Status: verified for finite n<=100; not yet PROVEN.

Reason for caution.  In a general set system, vertex sizes plus pairwise intersections do not determine union sizes or symmetric-difference sizes; triple and higher intersections can matter.  The finite data says the constrained queen-line geometry may make pairwise data sufficient here, but a theorem must prove that higher intersections are forced by the pairwise full-kind signature for this six-line family.  Lemma O4 gives the stronger incidence representation that is exact by definition.

### Lemma O8: family-collapsed edge buckets are good generators but not exact invariants

Statement.  Collapsing line colors from `row/col/sum/diff` to broad families `orth/diag` is not an exact minimizer invariant.  In the finite data through `n<=100`, exact-family bucket-best admitted `78` extra non-minimizer replies across `78` inflated `(n,x)` rows.  Every extra had score delta `4`, and every mixed selected family bucket had size `2` with `2` distinct full-kind buckets.

Proof.  This is a finite counterexample family recorded by the exact-family collision continuation.  Any single extra non-minimizer in a selected family bucket refutes exactness of the family-collapsed bucket as a minimizer classifier.

Status: verified for finite n<=100; negative finding / refuted as exact minimizer invariant.

### Lemma O9: local score-exact signatures do not decide minimizer status

Statement.  A local overlap signature, even one that determines `|combined_asym|`, does not by itself decide whether a reply is an asymmetry minimizer for the fixed opponent coordinate.  In the row/col quotient data through `n<=100`, there were `3444` mixed minimizer/non-minimizer groups, containing `3444` minimizer records and `3444` non-minimizer records.

Proof.  Minimizer status is row-relative: a reply `y` is a minimizer iff

```text
score(n,x,y) = min_{legal z} score(n,x,z).
```

The left side is a local score, but the right side depends on the full competitor set for the row context `(n,x)`.  The mixed groups give explicit finite examples where the same quotient-local score is a row minimum in one context and above the row minimum in another.  The non-minimizer deltas in mixed groups were mostly `4` records (`3413`), with `27` delta-`2` and `4` delta-`6` records.

Status: verified for finite n<=100; conceptual reason PROVEN by definition of row-relative minimization.

### Corollary O10: repair-oracle state needs row context

Statement.  Any B6-style repair oracle based on overlap/asymmetry data should include row context.  A minimal candidate state is

```text
(n, x, local_overlap_signature, asymmetry_score, asymmetry_rank)
```

with solver-side extensions for `ply/pc`, parent/root move, line-load deltas, and child value when known.

Proof.  Lemma O9 refutes local signature alone as a minimizer classifier.  Adding `(n,x)` supplies the row-relative competitor set needed to define rank.  The older solver handoffs show that runtime usefulness is also band- and parent-context-dependent, so the implementation state should not collapse those fields prematurely.

Status: heuristic engineering corollary, supported by finite data and older solver measurements.

### Recommended next proof task

Try to close Lemma O6.  The target statement is:

```text
For legal border pairs, the row/col-kind quotient of the full-kind edge-overlap
signature preserves |combined_asym| for all even n.
```

Do not try to prove that it preserves minimizer status; Lemma O9 shows that is the wrong target.

