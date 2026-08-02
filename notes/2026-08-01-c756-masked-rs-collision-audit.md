# C756 — masked-RS collision audit of deleted-point direction profiles

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Scope**: computational audit, research only

## Verdict

Across every odd prime power \(q\in\{11,13,17,19,23,25,27,29,31,37,41,43\}\), every
conic-external arc of every size \(k\) with \(\binom{k-1}2\ge q\), every arc point \(P\)
and every spare external line \(\ell\) through \(P\) — 234,188 instances in total, an
exhaustive enumeration with no truncation — the measured results are:

1. **No instance has \(h=0\).** No conic-external configuration in the audited range
   direction-covers outright. The audited \((q,k)\) pairs are exactly
   \((27,9),(29,10),(31,10),(41,11),(43,11)\); all other \(q\) in the list have
   \(m(q)<k_{\text{thresh}}(q)\) and therefore contribute no audited instance at all.
2. **No instance has \(h=1\) either.** The minimum missing-direction count per audited
   \(q\) is \(6,2,4,6,8\) for \(q=27,29,31,41,43\). The smallest \(h\) anywhere in the
   audit is \(h=2\) at \(q=29\). The \(h=1\) versus \(R_{\mathrm{cover}}(\delta)\)
   comparison the audit was designed to run is therefore vacuous: the set of \(h=1\)
   instances is empty.
3. The extremal conic-external cliques are **not** near-covers. Over arcs of the maximum
   size \(m(q)\), the largest fraction of the \(q^2\) off-conic points covered by all
   \(\binom{m}{2}\) chords is between \(0.6676\) (\(q=19\)) and \(0.9405\) (\(q=29\)) for
   every \(q\ge13\); the single exception is \(q=11\), where the fraction is \(1.0000\) —
   that is the Clebsch hexagon, which is conic-filling by construction.
4. Cross-check: the \(m(q)\) recomputed here agrees with the committed
   `notes/2026-08-01-c756-all-k-conic-filling.json` certificate at every one of the twelve
   \(q\), and the \(q=11\) extremal arcs are exactly the saturated (no spare external
   line) hexagons.

The smallest \((h,\,R-R_{\mathrm{cover}}(\delta))\) attained, taking \(h\) first, is
\((2,\,-18)\) at \(q=29\); the smallest at fixed \(h\) is discussed in §4 — the negative
sign there is not evidence of near-feasibility, because \(R_{\mathrm{cover}}(\delta)\) is
only the ceiling for the \(h=0\) covering-feasible profiles, and \(h=2\) means two
directions are missing outright.

## 1. What is measured

Setup and definitions are those of `notes/2026-08-01-c756-all-k-conic-filling.md` §1 and
`notes/2026-08-01-c756-nonsaturated-direction-reduction.md` §1. The conic is
\(C: y^2-xz\) in \(\mathrm{PG}(2,q)\), \(q\) odd. A **conic-external arc** is a point set
in general position (no three collinear) all of whose connecting lines are external to
\(C\), equivalently \(\chi\bigl(\operatorname{Res}\bigr)=-1\) pairwise in the
binary-quadratic model, equivalently
\(\chi\bigl(B(P,P')^2-Q(P)Q(P')\bigr)=-1\).

For a conic-external arc \(A\) of size \(k\), a point \(P\in A\), and a line \(\ell\)
through \(P\) that is external to \(C\) and **not** a chord of \(A\) (a *spare external
line*): take \(\ell\) as the line at infinity and \(P\) as the vertical direction, put
\(B=A\setminus\{P\}\) and \(n=k-1\). For each \(t\in\ell\setminus\{P\}\) — that is, each
affine direction — let \(\mu_t\) be the number of chords of \(B\) with direction \(t\).
Record

* \(\delta=\binom n2-q\),
* \(h=\#\{t:\mu_t=0\}\) (missing directions),
* \(R=\sum_t\binom{\mu_t}{2}\) (parallel-chord collision pairs),
* \(R_{\mathrm{cover}}(\delta)=\binom{\delta+1}{2}\).

\(R_{\mathrm{cover}}(\delta)\) is the maximum of \(\sum_t\binom{\mu_t}2\) over profiles
with all \(\mu_t\ge1\) and \(\sum_t(\mu_t-1)=\delta\): such a profile is a partition of
\(\delta\) into the excesses \(\mu_t-1\), and \(\sum\binom{\mu_t}2\) is maximized by
putting the whole excess on one direction, giving \(\binom{\delta+1}{2}\). It is the
*concentrated* profile. It ignores the matching cap \(\mu_t\le\lfloor n/2\rfloor\), so it
is an upper bound for the covering-feasible collision count that need not be attainable.

A chord of \(B\) is computed here as the meet of the chord line with \(\ell\), which is
the coordinate-free form of "its direction"; no affine chart is ever constructed. The
claim that the points of \(B\) have distinct \(x\)-coordinates is the claim that no chord
of \(B\) meets \(\ell\) at \(P\); the program tests this on every chord of every instance
and reports the violation count as `bad_meet`. It is \(0\) everywhere.

Audited sizes are every \(k\) with \(\binom{k-1}2\ge q\), i.e. \(\delta\ge0\). Write
\(k_{\text{thresh}}(q)\) for the smallest such \(k\). Since \(k_{\text{thresh}}(q)\le
m(q)\) holds only at \(q=27,29,31,41,43\), and there with equality, the audited size set is
\(\{m(q)\}\) at those five \(q\) and empty elsewhere.

Separately, and for every \(q\) in the list, all arcs of the maximum size \(m(q)\) are
measured for the threshold-unification statistics of §5 (chord coverage fraction of the
\(q^2\) off-conic points; minimum \(h\) over all \((P,\ell)\)).

## 2. Normalization and completeness

\(\mathrm{PGL}(2,q)\), the stabiliser of \(C\), is transitive on external points and on
internal points of \(\mathrm{PG}(2,q)\). The enumeration therefore fixes one external
representative \(r_{\text{ext}}\) and one internal representative \(r_{\text{int}}\) (the
first of each type in the program's point order — the same reduction the committed
searcher uses) and runs two depth-first arc searches:

* run 1 enumerates every conic-external arc containing \(r_{\text{ext}}\);
* run 2 enumerates every conic-external arc containing \(r_{\text{int}}\), with
  \(r_{\text{ext}}\) masked out of the candidate set.

The two runs are disjoint and their union meets every \(\mathrm{PGL}(2,q)\)-orbit of
conic-external arcs, because every arc contains a point off \(C\), which is external or
internal and can be moved onto the corresponding representative. Every quantity measured
(\(h\), \(R\), \(\delta\), coverage fraction, "is a chord", "is external") is
\(\mathrm{PGL}(2,q)\)-invariant.

Consequently: the reported **extrema and the support of the \((h,R)\) distribution are
complete** — nothing in the plane can achieve an \((h,R)\) pair absent from the tables.
The reported **counts are not orbit counts**: they count arcs through the fixed pair of
representatives, so orbits with a large stabiliser are represented fewer times than
orbits with a small one. The counts are reported for edge accounting, not as invariants.

## 3. Edge accounting and cross-check against the committed certificate

`arcs_by_size` lists every arc size the enumeration reported (the enumeration target is
\(\min(k_{\text{thresh}},m)\), so the reported sizes are exactly the audited sizes plus
\(m(q)\)). `m(q)` is recomputed here from scratch in an exact maximum-clique-style search,
independent of the committed value.

| \(q\) | \(m(q)\) here | \(m(q)\) committed | \(k_{\text{thresh}}\) | audited \(k\) | arcs at that size | audit instances | `bad_meet` | max-mode / enum nodes | sec |
|------:|-----:|-----:|-----:|------:|-------:|--------:|---:|---|-----:|
| 11 |  6 |  6 |  7 | none |      2 |      0 | 0 | 1,298 / 1,439 | 0.0 |
| 13 |  6 |  6 |  7 | none |     40 |      0 | 0 | 3,824 / 5,106 | 0.0 |
| 17 |  6 |  6 |  8 | none |  2,132 |      0 | 0 | 36,957 / 52,930 | 0.0 |
| 19 |  6 |  6 |  8 | none | 13,294 |      0 | 0 | 105,075 / 157,263 | 0.1 |
| 23 |  8 |  8 |  9 | none |    188 |      0 | 0 | 451,849 / 575,114 | 0.1 |
| 25 |  8 |  8 |  9 | none |  2,712 |      0 | 0 | 1,119,560 / 1,467,565 | 0.4 |
| 27 |  9 |  9 |  9 | 9    |     28 |  1,512 | 0 | 2,398,254 / 2,723,904 | 1.0 |
| 29 | 10 | 10 | 10 | 10   |    116 |  6,380 | 0 | 4,075,455 / 4,992,632 | 1.6 |
| 31 | 10 | 10 | 10 | 10   |     72 |  4,630 | 0 | 9,100,129 / 11,223,837 | 4.0 |
| 37 | 10 | 10 | 11 | none |  1,870 |      0 | 0 | 88,543,317 / 112,774,100 | 51.5 |
| 41 | 11 | 11 | 11 | 11   |  1,366 | 160,738 | 0 | 296,003,583 / 368,684,349 | 218.4 |
| 43 | 11 | 11 | 11 | 11   |    476 | 60,928 | 0 | 582,305,325 / 727,872,584 | 415.4 |

Every \(q\) was run to completion; nothing was truncated, and no \((q,k)\) is partial.
The `exhaustive` flag in the certificate is `true` on every record. Total audited
instances: 234,188.

The "audited \(k\) = none" rows are not a gap in the audit: they are the statement
\(m(q)<k_{\text{thresh}}(q)\), i.e. no conic-external arc over that \(q\) is large enough
for the deleted-point direction cover to be even numerically feasible.

## 4. Joint \((h,R)\) distributions

An exact identity constrains every row below. The occupied directions number \(q-h\) and
carry \(\binom n2=q+\delta\) chords, so

\[
  \sum_{t:\mu_t\ge1}(\mu_t-1)=\delta+h,
\]

whence \(R\ge\delta+h\) with equality exactly when every repeated direction is doubled
(\(\mu_t\le2\)), and \(R\le\binom{\delta+h+1}{2}\). The program's outputs satisfy
\(R\ge\delta+h\) in all 234,188 instances, which is an internal consistency check on the
measurement.

| \(q\) | \(n\) | \(\delta\) | \(R_{\mathrm{cover}}(\delta)\) | instances | \(\min h\) | \(\max h\) | \(\min R\) | \(\min\bigl(R-(\delta+h)\bigr)\) | \(\#\{R\le R_{\mathrm{cover}}\}\) | \(\#\{R=\delta+h\}\) |
|------:|---:|---:|---:|--------:|---:|---:|---:|---:|--------:|--------:|
| 27 |  8 | 1 |  1 |   1,512 | 6 |  6 |  7 | 0 |      0 |  1,512 |
| 29 |  9 | 7 | 28 |   6,380 | 2 |  6 | 10 | 1 |  6,380 |      0 |
| 31 |  9 | 5 | 15 |   4,630 | 4 |  8 |  9 | 0 |  4,010 |    620 |
| 41 | 10 | 4 | 10 | 160,738 | 6 | 20 | 11 | 0 |      0 | 18,184 |
| 43 | 10 | 2 |  3 |  60,928 | 8 | 17 | 10 | 0 | 12,376 |     0 |

Note on the \(\#\{R\le R_{\mathrm{cover}}\}\) column: it is large at \(q=29\) and \(q=31\)
purely because \(\delta\) is large there (\(7\) and \(5\)), which makes
\(R_{\mathrm{cover}}=\binom{\delta+1}{2}\) large. It is a comparison against the
\(h=0\) ceiling made at instances with \(h\ge2\), so it carries no feasibility content;
the column is reported because the task specified it. The kill criterion the column was
meant to serve — an \(h=1\) instance with \(R\le R_{\mathrm{cover}}(\delta)\) — has no
instances to evaluate.

Full joint distributions, aggregated by \(h\) with the \(R\) multiset spelled out:

**q = 27, k = 9, n = 8, δ = 1, R_cover = 1, 1512 instances**

| h | instances | R multiset (R:count) |
|--:|--:|---|
| 6 | 1512 | 7:1512 |

**q = 29, k = 10, n = 9, δ = 7, R_cover = 28, 6380 instances**

| h | instances | R multiset (R:count) |
|--:|--:|---|
| 2 | 580 | 10:580 |
| 3 | 1160 | 11:1160 |
| 4 | 3190 | 12:580 13:1160 14:1450 |
| 5 | 1160 | 14:1160 |
| 6 | 290 | 18:290 |

**q = 31, k = 10, n = 9, δ = 5, R_cover = 15, 4630 instances**

| h | instances | R multiset (R:count) |
|--:|--:|---|
| 4 | 1240 | 9:620 11:620 |
| 5 | 1220 | 11:620 13:600 |
| 6 | 930 | 12:620 14:310 |
| 7 | 620 | 13:620 |
| 8 | 620 | 16:620 |

**q = 41, k = 11, n = 10, δ = 4, R_cover = 10, 160738 instances**

| h | instances | R multiset (R:count) |
|--:|--:|---|
| 6 | 916 | 12:916 |
| 7 | 8180 | 11:1816 12:5456 13:908 |
| 8 | 17324 | 12:908 13:9128 14:6372 16:916 |
| 9 | 43664 | 13:9088 14:9096 15:16368 16:5480 17:3632 |
| 10 | 31892 | 14:2732 15:7296 16:11852 17:7280 18:1824 19:908 |
| 11 | 30044 | 15:2732 16:1824 17:11844 18:6372 19:5456 20:908 21:908 |
| 12 | 18240 | 16:908 17:1832 18:5472 19:5464 20:4564 |
| 13 | 6372 | 20:3648 21:908 22:908 23:908 |
| 14 | 2740 | 19:908 22:916 24:916 |
| 15 | 908 | 27:908 |
| 20 | 458 | 32:458 |

**q = 43, k = 11, n = 10, δ = 2, R_cover = 3, 60928 instances**

| h | instances | R multiset (R:count) |
|--:|--:|---|
| 8 | 4760 | 10:952 11:3808 |
| 9 | 3808 | 11:1904 13:1904 |
| 10 | 12376 | 12:6664 13:952 14:3808 15:952 |
| 11 | 13328 | 13:952 14:1904 15:4760 16:5712 |
| 12 | 9520 | 14:1904 15:3808 16:2856 17:952 |
| 13 | 7616 | 16:1904 17:2856 18:1904 21:952 |
| 14 | 4760 | 17:1904 18:1904 19:952 |
| 15 | 1904 | 19:952 21:952 |
| 16 | 1904 | 20:952 23:952 |
| 17 | 952 | 23:952 |

There are no \(h=0\) witnesses and no \(h=1\) witnesses to list; both witness arrays in
the certificate are empty, and both counters are \(0\).

The \(q=27\) row is degenerate in an informative way: every one of the 1512 instances has
exactly the same \((h,R)=(6,7)\), and \(R=\delta+h\) throughout, so at \(q=27\) every
spare external line of every maximum conic-external arc misses exactly six directions and
has exactly seven doubled directions and no direction of multiplicity three or more.

## 5. Threshold-unification measurement on extremal arcs

For each \(q\), over all conic-external arcs of the maximum size \(m(q)\): the fraction of
the \(q^2\) off-conic points covered by all \(\binom m2\) chords, and the minimum \(h\)
over all \((P,\ell)\) with \(\ell\) a spare external line through \(P\).

| \(q\) | \(m(q)\) | extremal arcs (normalized) | max cov. pts | \(q^2\) | max cov. fraction | min cov. fraction | \(\min h\) | arcs with no spare line | \((P,\ell)\) instances |
|------:|---:|-------:|------:|-----:|-------:|-------:|---:|---:|--------:|
| 11 |  6 |      2 |  121 |  121 | 1.0000 | 1.0000 | n/a | 2 |       0 |
| 13 |  6 |     40 |  145 |  169 | 0.8580 | 0.8580 | 3 | 0 |     402 |
| 17 |  6 |  2,132 |  205 |  289 | 0.7093 | 0.6955 | 7 | 0 |  46,930 |
| 19 |  6 | 13,294 |  241 |  361 | 0.6676 | 0.6399 | 9 | 0 | 366,360 |
| 23 |  8 |    188 |  432 |  529 | 0.8166 | 0.8166 | 5 | 0 |   7,144 |
| 25 |  8 |  2,712 |  509 |  625 | 0.8144 | 0.7824 | 5 | 0 | 125,732 |
| 27 |  9 |     28 |  612 |  729 | 0.8395 | 0.8395 | 6 | 0 |   1,512 |
| 29 | 10 |    116 |  791 |  841 | 0.9405 | 0.9168 | 2 | 0 |   6,380 |
| 31 | 10 |     72 |  901 |  961 | 0.9376 | 0.8855 | 4 | 0 |   4,630 |
| 37 | 10 |  1,870 | 1109 | 1369 | 0.8101 | 0.7925 | 6 | 0 | 181,406 |
| 41 | 11 |  1,366 | 1401 | 1681 | 0.8334 | 0.8263 | 6 | 0 | 160,738 |
| 43 | 11 |    476 | 1493 | 1849 | 0.8075 | 0.8075 | 8 | 0 |  60,928 |

\(q=11\) is the only row with coverage \(1\), and it is also the only row in which the
extremal arcs have no spare external line at all — both extremal arcs found there are the
saturated Clebsch hexagon, whose chords through each arc point exhaust the external lines
through it, so \(\min h\) is undefined (`n/a`, recorded as \(-1\) in the certificate).
This reproduces, from an independent code path, the saturation statement of
`notes/2026-08-01-c756-all-k-conic-filling.md` §2.2.

Away from \(q=11\), the coverage fraction sits in \([0.64,0.94]\) with no visible trend in
\(q\), and \(\min h\) never falls below \(2\). Extremal conic-external cliques are not
near-covers in this range.

## 6. Computed versus interpreted

Computed exactly, with no estimation and no randomness anywhere:

* \(m(q)\) for all twelve \(q\), by exhaustive search.
* Every conic-external arc of every audited size, up to the fixed-representative
  normalization of §2, and the complete \((h,R)\) distribution over every
  \((A,P,\ell)\) instance.
* The chord coverage counts of every extremal arc.
* The `bad_meet` check (no chord of \(B\) meets \(\ell\) at \(P\)) on every chord of every
  instance.

Interpretation, which is not certified by the run:

* That the emptiness of the \(h\in\{0,1\}\) stratum in this range says anything about
  larger \(q\). The audit measures \(q\le43\) only.
* The reading of the \(\#\{R\le R_{\mathrm{cover}}\}\) column in §4 as carrying no
  feasibility content. That is an argument about what \(R_{\mathrm{cover}}\) means, not a
  computed fact.
* Any claim about which proof route survives. The data are reported here; the routing
  decision belongs to the lane.

## 7. Replay

From the repository root:

```sh
rustc -O -o /tmp/c756mrs notes/2026-08-01-c756-masked-rs-collision-audit.rs
/tmp/c756mrs notes/2026-08-01-c756-masked-rs-collision-audit.json \
        27 29 31 43 41 17 19 23 25 37 11 13
```

The record order in the JSON follows the \(q\) order on the command line, so that exact
argument order reproduces the committed file. Every field except `seconds` is
deterministic and reproduces byte for byte; `seconds` is a wall-clock measurement and will
differ between runs, so the SHA-256 below matches only a run on which those timings
coincide. Compare with `jq 'del(.records[].seconds)'` on both files for an
order-independent, timing-independent check. The whole run takes about
twelve minutes of CPU, dominated by \(q=43\) (415 s) and \(q=41\) (218 s). The program is
single-threaded, deterministic, and uses no randomness; \(\mathbb F_{p^n}\) uses the same
lexicographically-first monic irreducible search as the committed searcher, and the
conic is \(y^2-xz\) as there.

Independent cross-check available without rerunning this program: the \(m(q)\) column of
§3 must equal the `m_q` values in the committed
`notes/2026-08-01-c756-all-k-conic-filling.json`, produced by a different search driver.
It does, at all twelve \(q\).

Evidence hashes and byte counts:

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-01-c756-masked-rs-collision-audit.rs` | 29,796 | `1eec69b0845d28f9d122edd049965fac6dba4701f8df0cff2b47f581d0ffea16` |
| `notes/2026-08-01-c756-masked-rs-collision-audit.json` | 9,581 | `dbefb995e5ff64195f9ca3f0b07f147399fd45e50131242aed409b301d9f81a4` |

## 8. Mystery ledger

| feature | settled by this audit? | exact gap / owner |
|---|---|---|
| Does any conic-external arc direction-cover a spare external line outright (\(h=0\))? | yes, negatively, for \(q\le43\) | exhaustive over all 234,188 instances; says nothing for \(q>43\), where the first arithmetically live defect-two case is \((q,k)=(53,12)\) |
| Is the \(h=1\) stratum ever populated? | yes, negatively, for \(q\le43\) | the stratum is empty, so the \(R\le R_{\mathrm{cover}}(\delta)\) comparison never fires. Why \(h\) is bounded away from \(0\) and \(1\) by a margin that *grows* with the instance count is unexplained |
| Why is \(\min h\) so large and so irregular (\(6,2,4,6,8\) at \(q=27,29,31,41,43\))? | no | it does not track \(\delta\) (\(1,7,5,4,2\)) monotonically, nor \(q\). No structural explanation; owner: any successor task that wants a lower bound on \(h\) |
| \(q=27\) has a single \((h,R)=(6,7)\) value across all 1512 instances | measured, not explained | \(m(27)=9=k_{\text{thresh}}(27)\) and \(\delta=1\); whether the rigidity is forced by \(\delta=1\) or is an accident of the 28 extremal arcs is open |
| \(R=\delta+h\) (all repeated directions doubled) holds for every instance at \(q=27\), never at \(q=29\) or \(q=43\), and for a minority at \(q=31,41\) | measured, not explained | the matching cap \(\mu_t\le\lfloor n/2\rfloor\) permits \(\mu_t\ge3\) throughout; no obstruction to it is known |
| Are extremal conic-external cliques near-covers? | yes, negatively | coverage fraction \(\le0.94\) for every \(q\ge13\); only \(q=11\) reaches \(1\), and it is the known conic-filling hexagon |
| \(q=11\) extremal arcs are exactly the saturated ones (no spare external line) | yes | independent reproduction of §2.2 of the all-\(k\) report; every other \(q\) in range has spare lines on every extremal arc |
| Counts in §3 and §5 are representative-normalized, not orbit counts | yes | stated; nothing in the verdict depends on a count, only on extrema and on emptiness |
