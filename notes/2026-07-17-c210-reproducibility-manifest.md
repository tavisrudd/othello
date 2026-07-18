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

`a_zero_artin_schreier_divisor` (the `a=0,b!=0` closure — see
[`2026-07-17-c210-a-zero-artin-schreier-divisor.md`](2026-07-17-c210-a-zero-artin-schreier-divisor.md))
was added later the same session; its fresh run is byte-identical to the committed output
(`diff` exit 0), and its Singular certificate re-derives the residue reduction independently of
the Python set arithmetic.

The nine `a_nonzero_*` bundles now carry the active t-degree-four line through
the exact GF(8)/GF(512) residue census, exact original-cover splits, and the
`b=0,a!=0` closure, then classify both second-layer components on the three
known `b!=0` branches. Their fresh runs are byte-identical to the committed
outputs. The residue census directly evaluates every gcd-enumerated GF(512)
root; the split and boundary checkers compare their displayed factors and
reconstruction identities directly with the universal resultant. The
second-layer checker adds exact pole/normal-form identities and exhausts all
`19,208` allowed GF(8) geometries and all `153,664` geometry/constant-class
pairs. The genuineness checker then identifies the exact repeated-point
components, removes their intersections uniformly, classifies the `336`
small-field exception geometries, and independently replays projective
incidence over `GF(64)`.

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
| `analyze_c210_a_zero_artin_schreier_divisor.py` | `9ec4f200ce84bbe2254db309e1f842d335bd7e477c21d0ecaff1e7744f4ebe89` | 28625 |
| `analyze_c210_a_zero_artin_schreier_divisor_output.txt` | `a5e4ee96eb2bf87d36adad45a9a6a4bd2ad8f6685c236665db948d34c71b2f1f` | 2955 |
| `analyze_c210_a_nonzero_artin_schreier_form.py` | `74654129056588e8e400fd17ee041e6c82be9d53607013b1ef9061f3b33d6248` | 15123 |
| `analyze_c210_a_nonzero_artin_schreier_form_output.txt` | `ef431d5e49faed11e46d84072a57912c6375ace480e4d71b4fe61ad118a32f2b` | 2590 |
| `analyze_c210_a_nonzero_preflight_resultants.py` | `7edd9fb021eb1d753bad7c1efe6403d10afe704f7ccb3ec266d3e41579a02176` | 10998 |
| `analyze_c210_a_nonzero_preflight_resultants_output.txt` | `6b0ba16d81c6d53058181315414b27ada1b6d0a6d6581ee9a830f23902511f83` | 2082 |
| `analyze_c210_a_nonzero_residue_conditions.py` | `461ae7dede79419567202b8a1e2e509ecf1c4cb4f63de0d091bcb5e1b62d1327` | 8514 |
| `analyze_c210_a_nonzero_residue_conditions_output.txt` | `d291e11dec4ade16ffc302befbc609a5f63fd7b583f22fb9a15a8222d5311760` | 1770 |
| `analyze_c210_a_nonzero_dAS_branches.py` | `b6339bfb8c1270b76fa5d93b8394409b9090e90f45414ecf2ef481585242114c` | 8995 |
| `analyze_c210_a_nonzero_dAS_branches_output.txt` | `76c33187d6468785f3d122fb62b93ca84e4212cbfa593739a707a3316df3a99d` | 1835 |
| `analyze_c210_a_nonzero_dAS_census.py` | `39889891bf98ee335ba77d131b669c03fe5ec78938ac61dece4c0dc94f89e166` | 23263 |
| `analyze_c210_a_nonzero_dAS_census_output.txt` | `f5525fcbf2cd38b0a64a5443ba0ed875e90294889b53731e0b354d58c635c69b` | 1983 |
| `analyze_c210_a_nonzero_exact_splits.py` | `45159c3c20732989da9798fdf4caee58a402e2b9403b1f4fdb166c8cf8b6fea3` | 7977 |
| `analyze_c210_a_nonzero_exact_splits_output.txt` | `7616801d5b3979d925280f5f2aa2bd4520ff7fee1336eee8d0a6dcb2caa0d02f` | 1461 |
| `analyze_c210_a_nonzero_b_zero.py` | `191a5257624cbea15953e76597eda367e0f3687f5522b94d712a9d49495d9894` | 8978 |
| `analyze_c210_a_nonzero_b_zero_output.txt` | `ae8e898e35d5eb841568b6e520f1fe76fcdaa73fd7754bccac3589cbc8267ddd` | 1252 |
| `analyze_c210_a_nonzero_second_layer.py` | `a80f2a80cde89f401f168c05bfa0ec14ee0c12e5bcdf569c37e23be216a72b9d` | 12378 |
| `analyze_c210_a_nonzero_second_layer_output.txt` | `237e8d6fd9902e6f464556794cd65fe3a4b14356f02166f023c01ad84102b9e2` | 2383 |
| `analyze_c210_a_nonzero_genuineness.py` | `ca6775520d579f2e6b61a3410de9782750c5f0aa2282b8d1e92f15b6b3c353b6` | 15715 |
| `analyze_c210_a_nonzero_genuineness_output.txt` | `fb04dff45b4148b342bc0b618026f0c3efa595ccc7b3c0e566dfafef35b3243e` | 2797 |

Full pipeline hashes: `analyze_c210_SHA256SUMS`
(sha256 `d94a32d8d2cfa335af27ab9f35530658dcf742c3d2aa2d74b751d20d67b7966c`).

## Trusted boundary

The checkers trust Singular's `factorize`/`gcd` over `GF(2)(params)` as the CAS oracle, and the
pure-Python sparse GF(2)/GF(8)/GF(64)/GF(512) arithmetic in the `analyze_c210_*` modules (cross-checked
against direct projective incidence over GF(64)/GF(8) inside `seed_cross_repair_curve`). Absolute
(geometric) irreducibility of the generic collision curve is carried by
`analyze_c210_collision_curve_frobenius.sing` (a degree-preserving GF(8) fiber, irreducible over
extension degrees 1/2/4/8); `generic_factorization.py` cites it but does not itself run it.
