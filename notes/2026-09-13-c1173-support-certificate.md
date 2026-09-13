# C1173 — support-witness certificates: checking without replay

**Lane**: `ergodis`
**Date**: 2026-09-13
**Status**: COMPLETE. Closes E1, E7 and R5 of
`2026-09-12-c1171-rule-programme-review.md` and lands property P3.

## Verdict

1. **Checking cost is now independent of the round count.** A support
   certificate carries, per coordinate, the value, a derivation rank and a
   rule witness (0 = base fact or infinity, `k + 1` = grounded product `k`).
   `WeightedRules.Support` proves, for every admitted scalar algebra with
   decidable equality, that a valuation is the least fixed point in the
   information order exactly when it is locally fixed and every coordinate is
   justified with both factors of strictly smaller rank. The checker
   `checkSupportCertificate` is one pass over the coordinates plus one over
   the rules; it never computes an iterate. `SupportedSolution P` has the
   same `.least` theorem as the replay-checked form, denotes the same
   scalar-count iterate, and converts to a `CheckedSolution` by proof
   (`checkCertificate_complete`), not by replay.
2. **Measured on identical producer output** (single-file elaboration,
   `decide +kernel`, deps prebuilt):

   | Module pair | Replay checker | Support checker |
   |---|---|---|
   | Domain six, ten cases | 43.6 s | 8.4 s |
   | Domain five, ten cases | 18.1 s | 5.4 s |

   The replay module carries eight statements per case (sharp from-zero pair,
   sharp incremental pair, bound, three rejections), the support module five
   (base, improved, three rejections); per statement the support checker is
   about three times faster on these small programs, and the gap widens with
   the round count since the replay cost is `rounds × (n + rules)`.
3. **Warm and cold witnesses are interchangeable (E7).** The improved chain
   is checked from zero by support in `SupportExample`, and its values are
   proved equal to the warm-replay witness's; `SupportConvention.*` check the
   improved program of every fixture case the same way. No incremental
   machinery is needed when a support certificate is available.
4. **Resource policy (R5).** The oracle now spawns the producer with piped
   output read only up to the byte limit plus one, kills a producer still
   running at `ERGODIS_RULE_ORACLE_TIMEOUT_MS` (default 60 s), and refuses an
   explicit `via` path that is absolute or contains `..`. Controls: a
   flooding producer is rejected with "certificate exceeds byte limit"
   (`SupportChecks`, guarded), a parent-segment path is refused (guarded),
   and a hanging producer with a 500 ms deadline fails with "exceeded its
   deadline" (manual probe, 2 s wall). Soundness never depended on any of
   this; it bounds resources only.
5. **Raw scalar entry point and P3.** `Prepared::from_scalars` admits a raw
   scalar program (unit last) by expressing it as a source over one unary
   relation with constant-only rules, and requires the grounded products to
   equal the requested triples in order. Ten seeded raw programs with 6–24
   coordinates, cyclic rules, self products and reused outputs are checked in
   `SupportConvention.Raw`: sharp from-zero round count by replay, support
   certificate, and six rejections each; from-zero rounds reach 8 and ranks 7.
6. **Native side.** `ergodis_verify::support` holds the cold derivation and
   the one-pass native checker; ABI selectors 3 and 4 emit and verify support
   certificates; the adapter takes a `support` argument. The core tests cover
   the distance fixture (every value flip and every finite-coordinate witness
   flip rejected; ranks `[0, 2, 1, 3]` on the distance coordinates), the raw
   entry point with an unsupported all-zero cycle rejected, and 512 generated
   raw programs. The native ABI gate replays its 128 cases.

## Why the support argument is complete for min-plus

A least solution always has a well-founded support: rank each coordinate by
the first round at which it reached its final value. A finite value first
produced at round `k` by product `(l, r)` used the round-`k−1` values of `l`
and `r`; if either later decreased, the sum would decrease strictly (finite
sums are strictly monotone; saturated sums are infinite and need no
justification), contradicting fixedness. So both factors were already final
at round `k−1` and have smaller rank. The Rust derivation
(`support::derive`) finds such a support by relaxation over the products and
fails only on a valuation that is not least; the generated tests exercise it
on 512 random raw programs and the fixture family.

## Reproducibility bundle

| File | SHA-256 |
|---|---|
| `ergodis/crates/verify/src/support.rs` | `72056416a1456095633023b3d0d118bb61c27291b192eb0f3a576435d072ace6` |
| `ergodis/crates/rules/examples/lean_boundary_fixtures.rs` | `1279017c1500476a979cf267ebabf4d8efb18096f148c2388f7c1a11803397f3` |
| `lean/WeightedRules/generate_round_convention.py` | `e163d7e5f7b4abe7db40f92d8aaedfe1b1b79d5c87b7e224cbb42d660df28f73` |
| `lean/WeightedRules/oracle.py` | `b2e56299518ea3652399b0cee97d6bf4a13a710e116002aa4f06c93f2b5069c6` |
| `lean/WeightedRules/fixtures/rejection_oracle.py` | `d4d677aa3b6c7c569a868f1b602d425da5d4e9b55c5f79b30a2f98477c25f843` |
| `lean/WeightedRules/fixtures/round-convention/domain-3.json` | `0f74b176c35dbcb0d3473e8a3a4be7eb8dd9148a768a914fc4851dedbc790ce7` |
| `lean/WeightedRules/fixtures/round-convention/domain-4.json` | `4fdc5e5a8d4b960ec31b7b8fe0881e999d0041acb5b0ebb91e835fe2020de1c1` |
| `lean/WeightedRules/fixtures/round-convention/domain-5.json` | `2060586a75471326c27848551049d416f98e87bb04b22b1a04533a7799e01124` |
| `lean/WeightedRules/fixtures/round-convention/domain-6.json` | `9af4abcfe3ceea8964b9f19c4a0fd30c849b043732ffe8d21426280a11b07dc5` |
| `lean/WeightedRules/fixtures/round-convention/raw.json` | `34e7aa3a05de2150aba741218d3372d318d99b44676022e55265d4a2a12d8372` |

The domain fixtures supersede the C1172 versions (same seeds and cases, with
support data added; the round-convention statements are unchanged). Replay is
the C1172 command sequence followed by the `WeightedRules` root build; the
timing rows are `lean/scripts/guarded-lean` on the four named modules. The
independent replay of every certificate is the Lean kernel.

## Validation

| Gate | Result |
|---|---|
| `cargo test -p ergodis-verify -p ergodis-rules` | pass (incl. 512-case raw property, new support tests) |
| `cargo test -p ergodis-runtime` | 58 passed, 1 ignored |
| `cargo clippy --all-targets -p ergodis-verify -p ergodis-rules -- -D warnings`, `cargo fmt --check` | clean |
| `scripts/public-lint.sh crates`, `docs` | clean |
| Native ABI gate `native_abi.py` | 128 cases pass |
| Queue build `Support`, `Oracle`, `SupportChecks`, `SupportExample`, `SupportConvention.Raw`, `.DomainThree` | pass (Raw 23.3 s) |
| Hanging-producer probe, 500 ms deadline | rejected in 2 s wall |
| Queue build of root `WeightedRules` with the support family and guarded `SupportAxiomAudit` | pass, 0:45 wall incremental (run `20260913-155827`-series, gate passed) |

## Not done, and why

- The WASM ABI gate (`wasm_abi.mjs`) was not rerun; the change is additive
  (two new selectors, descriptor rows) and the native gate passes. C1175's
  release hygiene owns the WASM rerun.
- `checkSupportCertificate` still addresses values through `listState`,
  which is `List` indexing; on very large `n` that is a quadratic term shared
  with the replay checker. An array-backed state is a separate change.
- The catch-all in `elaborateCertificate` remains; timeout, byte-limit and
  path errors are raised before it and surface with their own messages.

## Mystery ledger

- **Checking cost equals solving cost in the Lean oracle.** Closed: the
  support route checks in one pass; measured 3–5× on ten-case modules whose
  round counts are only 1–8, with the gap growing with rounds. Open
  boundary now: kernel reduction over `List`-indexed states.
- **Why replay was ever needed.** Settled: it was the cheapest complete
  route with no producer cooperation; the support certificate needs the
  producer to emit two more lists, which it derives cold in a pass bounded
  by rounds × products.
- **Rank equals round.** The derived ranks on the distance fixture are the
  first-final rounds `[0, 2, 1, 3]`, one less than the producer's changing
  sweep for each coordinate; expected from the convention pinned in C1172.
  Nothing open.
