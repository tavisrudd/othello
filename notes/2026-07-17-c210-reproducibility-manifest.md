# C210 collision-curve pipeline — reproducibility manifest

Lane: `relconic`. Date: 2026-07-17.

The C210 square-root construction program is a pipeline of deterministic checkers under
`papers/arcs_complete_outside_conic/` named `analyze_c210_*.py`, each printing a canonical
`json.dumps(..., sort_keys=True)` summary captured in a paired `analyze_c210_*_output.txt`, with
symbolic factorizations shelled to Singular. This note is the human-facing record; the
machine-checkable hash list is the committed manifest
`papers/arcs_complete_outside_conic/analyze_c210_SHA256SUMS` (standard `sha256sum` format, covering
every tracked `.py`, `.sing`, and `_output.txt` leaf).

## Check command

From `papers/arcs_complete_outside_conic/`:

```bash
sha256sum -c analyze_c210_SHA256SUMS          # verifies every leaf against its pinned hash
python3 analyze_c210_<name>.py                # regenerates one leaf's stdout; compare to its _output.txt
```

Singular is invoked as `nix shell nixpkgs#singular --command Singular -q` (used by
`Singular -q` directly when on `PATH`). Outputs are canonical: sorted JSON, no timestamps, no
host paths — a fresh run is byte-identical to the committed `_output.txt`.

## Reproduced byte-identical this session

Fresh run == committed output (exit 0) for the active two-repair frontier chain, which carries the
`a=b=0` closure and the `a=0`/`a!=0` stratification:
`seed_cross_repair_curve`, `collision_curve_generic_factorization`, `collision_curve_frobenius`,
`collision_curve_degree_drop`, `collision_curve_constant_height`, `collision_curve_constant_height_arc`,
and the new `a_zero_factorization_strata`. Their conclusions were independently re-derived by a
separate verifier pass — see
[`2026-07-17-c210-a-zero-verification.md`](2026-07-17-c210-a-zero-verification.md), which rebuilt the
resultant from the committed modules and reproduced the `a=0` factorizations in Singular. The
remaining leaves are the earlier single-quadratic-graph line, pinned here as their committed
artifacts.

## Load-bearing leaves (sha256, bytes)

| file | sha256 | bytes |
|------|--------|-------|
| `analyze_c210_seed_cross_repair_curve.py` | `2518e3b1366a2e1023c85ea0a75b225d1f3d546e7f6da726996544bc9d04c334` | 12802 |
| `analyze_c210_seed_cross_repair_curve_output.txt` | `5098b20640fd7b53169aafb270facaf42bcbe0fa92cda7279c6f9c263be17332` | 1323 |
| `analyze_c210_collision_curve_generic_factorization.py` | `19fe74ffe3367fefe103a8d2219108fa6ae978298acdf0fc1677a9467879cb53` | 2385 |
| `analyze_c210_collision_curve_generic_factorization_output.txt` | `9a194fecd96300b28749ddae97e98dee15f855acc3e268697a8246f5b0467c29` | 482 |
| `analyze_c210_collision_curve_frobenius.sing` | `106e430bf0186abe5042d6eb3fea2eaeba8f51303c5fa1373f6a82db669dc26a` | 2364 |
| `analyze_c210_collision_curve_frobenius_singular_output.txt` | `3f3ba91f1f8d1ae18f421fb3d2371757b5e38b0f1d395ebb3f3b572c371e6cd4` | 82 |
| `analyze_c210_collision_curve_degree_drop.py` | `a1c3712eb60a9cc1d1701a20c2522b2fb330db06a78ad69e52fafcae4af350ae` | 11233 |
| `analyze_c210_collision_curve_degree_drop_output.txt` | `12db8ef114c8fa29815de5f8fe2e2e833b995b4e5c4fc0f65da5ced974638387` | 1020 |
| `analyze_c210_collision_curve_constant_height.py` | `9a0bcf485312f2c9668210f0f3d79676660b6578ebc94dffab96221f68fccc9d` | 12992 |
| `analyze_c210_collision_curve_constant_height_output.txt` | `3e82aa555c7100fc2f03ce7fdfb32eea3b0bf18951e8affa24ad3338373eecb3` | 1249 |
| `analyze_c210_collision_curve_constant_height_arc.py` | `588e777c6c4d2193c9e1f45ed70cee66c4fc35b2ecf03d9047b74b611c917ec5` | 10040 |
| `analyze_c210_collision_curve_constant_height_arc_output.txt` | `3444b3a6b958bdfd8834c86a3b36c48793ba378c86da4342bfea3de86a8464f7` | 1071 |
| `analyze_c210_a_zero_factorization_strata.py` | `de9013e648927b3c7a5a6df3a948365f7c17e3ad7b35da18dc6a2934f6514ba3` | 10832 |
| `analyze_c210_a_zero_factorization_strata_output.txt` | `893588118bddb76a306ceb5770d2e9d76a707c60402b40aeb935bb8469e6eed8` | 1442 |

Full pipeline hashes: `analyze_c210_SHA256SUMS`
(sha256 `438085fcdb7726f18bc710c73bca1597bf83e6a0c63b3cf994e74651d1678495`).

## Trusted boundary

The checkers trust Singular's `factorize`/`gcd` over `GF(2)(params)` as the CAS oracle, and the
pure-Python sparse GF(2)/GF(8)/GF(64) arithmetic in the `analyze_c210_*` modules (cross-checked
against direct projective incidence over GF(64)/GF(8) inside `seed_cross_repair_curve`). Absolute
(geometric) irreducibility of the generic collision curve is carried by
`analyze_c210_collision_curve_frobenius.sing` (a degree-preserving GF(8) fiber, irreducible over
extension degrees 1/2/4/8); `generic_factorization.py` cites it but does not itself run it.
