# C143 — Q25 two-witness alternate-orbit repair

**Lane**: `alt-orbit-repair`

**Date:** 2026-07-14
**Status:** REPORTED — full target, trace, source trust, backup, and manuscript gates passed

## Result under validation

Every Frobenius-invariant eight-arc in `PG(2,25)` has at least two distinct legal nonfixed
conjugate-pair extensions.  Consequently, deleting any selected nonfixed orbit from a
Frobenius-invariant ten-arc leaves at least one different legal orbit that repairs the arc.

The result is uniform over all five fixed/nonfixed profiles.  The only certificate-gated profile
is `(f,e)=(2,3)`; the other four profiles use the existing semantic counting theorems.

## Certificate census

The normalized exceptional slice has exactly 46,056 ordered rows `5 < b < c < 310`:

- 39,012 rows carry an explicit collinear-triple obstruction and hence are not arcs;
- 7,044 valid arc rows carry two explicit, distinct legal orbit witnesses;
- 303 row aggregators compose 1,639 leaf modules; and
- 1,262 leaf modules containing valid rows changed when the second witness was added.

The external generator proposes only small data: one bad triple, or two orbit codes.  Lean checks
each determinant obstruction, each witness's freshness and determinant conditions, and witness
inequality.  The transport layer then carries both legal pairs through the stabilizer and
base-field normalizations, preserving distinctness by injectivity.

Generator:
`notes/2026-07-14-c143-generate-two-witness-rows.py`

Generator SHA-256:
`d51cb8887bdc2b1566e97de36e0b84735d5fd0d0002209d5ba9b0c102c644d50`

Enumerator source SHA-256:
`c6f134ff1f6544ca8612ad1e7959c936f82da56f6ab2f64cd39bb722eb3def90`

Sorted SHA-256 manifest digest for all 1,942 files under `Q25PairRows/`:
`364fb6608f8f0703c6b78c179b4c6694c50914f5d68859cbe5c9758ef8bf8065`.

Handwritten/composition source hashes:

| Source | SHA-256 |
|---|---|
| `Q25PairCertificate.lean` | `2621eae530277544bac2b1c45e44d5f84164ce921ced588a24e8c2ca87d652c3` |
| `Q25PairData/L_005.lean` | `fcd7c743a80394fa0b5976ebd0c918505be457dece41de4eab50603c8bdabfc4` |
| `Q25PairReduction.lean` | `c00fcf0a7d3087182703a386fa37fb01771ef8cf7178a77fa5c58a616b4286aa` |
| `Q25PairResult.lean` | `60b57e22900dc4d1d12cebcb3f76020dac083e429a452af6efcc07b977594f6f` |
| `Q25AlternateOrbitRepair.lean` | `c13fa4442561f2bc7774785cc3778da777f44b0090caf4a184969234cf4c6135` |

The two proposals use the same deterministic enumerator with ascending and descending orbit-code
scan orders.  Agreement of those runs is only proposal-generation evidence; Lean's independent
checking of both concrete `LegalPair` terms and their inequality is the trusted gate.

## Trust audit

A source scan of the certificate, generated rows, reduction, projective transport, and final repair
module finds no `sorry`, `admit`, `axiom`, `unsafe`, unlimited-heartbeat setting, or unlimited-depth
setting.  The handwritten files use large but finite heartbeat and recursion-depth caps.

The proof boundary is:

1. `RowResult` classifies each normalized row as a checked obstruction or two checked legal pairs.
2. `allRows` composes all 46,056 row results.
3. `first_slice_two_005` discharges the only normalized slice needed after stabilizer reduction.
4. `normalized_two_extension` transports both witnesses back through the stabilizer map.
5. `indexed_f2_two_pair_extension` and `f2_two_pair_extension` transport them through base
   normalization to arbitrary projective eight-arcs.
6. `two_le_card_globalLegalPairs_q25` combines the exceptional profile with the four counting
   profiles.
7. `one_le_alternateLegalPairs_q25` removes the erased orbit from the legal-pair finset.

## Resource validation

Representative measurements before the aggregate run:

- shared checker, warm: 9.32 GB peak RSS;
- shared checker, earlier cold run: 10.83 GB peak RSS;
- representative generated leaf: 5.86 GB peak RSS, 122 seconds.

### Restart/scheduler finding

A controlled `LEAN_NUM_THREADS=2→3→2→3` restart established that worker-count changes do not pollute
completed artifacts: each resumed run accepted leaves produced by the other worker count and
continued with newly-ready dependencies.  The apparent counterexample was scheduler order.  A
high-numbered `R_307` olean present in the backup dated 01:21, before
`Q25PairCertificate.lean` changed at 17:42, so it was an old one-witness artifact even though the
first run was visibly building low-numbered `R_065` rows.  The three-worker run correctly rebuilt
it at 22:03.

Fresh Lake runs also displayed different progress denominators (`9,584` versus `10,604`) as replay
and dependency tasks were rediscovered.  Therefore neither the denominator nor monotone-looking row
numbers prove that an output was previously landed.  Use content traces or `lake build --no-build`,
not filename order, existing oleans, or progress counters, to diagnose genuine rebuilds.  This can
explain earlier reports of mysterious rebuilding without implicating `LEAN_NUM_THREADS`.

The full target passed with exactly three Lean workers:

```text
LEAN_NUM_THREADS=3 choom -n 1000 -- taskset -c 20-22 \
  nix develop --command bash -lc \
  'export LEAN_NUM_THREADS=3; exec /usr/bin/time -v lake build \
    RelativeConicArcs.Q25AlternateOrbitRepair'
```

The build completed all 10,604 jobs successfully on 2026-07-15. `/usr/bin/time -v` recorded
9:32:18 elapsed wall time, 92,742.25 user seconds, 8,904.42 system seconds, 296% CPU, 6,404,292 kB
maximum resident set size, zero swaps, and exit status 0. The only diagnostics were unused-variable
linter warnings for `hC` in `Q25PairReduction.lean` and `hS` in `Q25PairResult.lean`.

The forbidden-token scan over the certificate, generated rows, reduction, result, and repair
modules is clean. The final target artifacts have SHA-256 hashes:

| Artifact | SHA-256 |
|---|---|
| `Q25AlternateOrbitRepair.olean` | `79f6be046ce7c2975e24640f6e4588976c36df5ec91d82c7c3b7598c7bfde8fc` |
| `Q25AlternateOrbitRepair.olean.hash` | `509e3372c45f507d603719be322f74dddc5fc90819a83b77cf7cee3bdb9e3f2e` |
| `Q25AlternateOrbitRepair.ilean.hash` | `73841cdf5e8ad3d2395881c80776df8aa06cecbefaa60d8ee0515fbd27e39cd3` |
| `Q25AlternateOrbitRepair.trace` | `8d5b9068a288b0468d0dd0ecf689ea4557eb6ddeddda9aae07804f153777ffae` |

A disk-backed recovery snapshot of all project artifacts under `.lake/build/lib/lean` is at
`/home/tavis/.cache/othello-project-oleans-c143-passed-20260715-081730`. It contains 18,300 files
and is 628 MB; its verified `SHA256SUMS` digest is
`cc437c77f10443f7d3ee5651b6bd788c6ffa2399bd42572ed5fa68c8d4b7798e`. It excludes
`.lake/packages` and is labeled as potentially overlapping unrelated concurrent Lean activity.

The manuscript and PDF were synchronized after the kernel build. Tectonic and BibTeX completed
without document warnings or unresolved references. The final manuscript hashes are:

| Artifact | SHA-256 |
|---|---|
| `frobenius_pair_extension.tex` | `28017d78c455fa6e10d3bb6a239d7555b4ebe1bb601d6e4501df240fa8e2f4be` |
| `frobenius_pair_extension.pdf` | `147a7dc04a90b4484430d0b107f8f76e9203ea9370d8a3871f9ca34ff3601fd7` |

The final trace gate passed after the shared Lean window cleared:

```text
lake build --no-build RelativeConicArcs.Q25AlternateOrbitRepair
All targets up-to-date (10604 jobs).
```

The trace-only replay took 8.83 seconds wall time, used 573,960 kB peak RSS, performed zero
filesystem writes and zero swaps, and exited with status 0. C143 therefore passes every acceptance
gate: full kernel closure, forbidden-token trust scan, trace validation, reproducibility hashes,
disk-backed recovery snapshot, and synchronized manuscript/PDF.
