# C61/C63 follow-up: q=19 Psi-selector hard surface

Date: 2026-07-10 (Codex).

## Verdict

**POSITIVE localization, but not yet a uniform deterministic selector.**  The 12 held-out q=19
failures of the fixed C31 selector all occur at the same ply-4 root parent and have one common
repair signature.  C31 chooses an on-conic P reply that raises `Psi` by 14.  In every case there is
an internal P reply with `live_on=6`, `defect_components=3`, nonzero conic xor, and
`Delta Psi in {-42,-41}`.

Seven existing geometric families contain a descending P reply in all 12 obligations:
`live_min`, `defect_components_min`, `zero_xor_live_min`, `internal_live_min`, `guard_killer`, and
both rectangle-character/live families.  Thus the q=19 exception is not an existence failure and
does not require a new candidate-cell family.

The deterministic tie gate remains open: **no one family is safe on all 12**, where safe means
every tied minimizer is both P and `Psi`-decreasing.  `psi_min` is safe on 8/12 and
`zero_xor_live_min` on the complementary 4/12.  The four-way rho refinements are safe only on a
four-row subset.  A proof selector therefore needs one more tie coordinate; merely replacing C31
by live-min or defect-min would hide losing/nondescending ties.

This sharpens the C61 successor target.  The hard surface is now a single parent, 12 on-conic
opponent moves, one common internal repair signature, and a two-regime tie problem—not a broad
failure of `Psi` or of the candidate geometry.

## Instrument change

The `s4selectors --fail-out` TSV now includes:

- `best_psi_p`: the lexicographically chosen minimum-`Psi`, minimum-live descending P reply;
- `covering_families`: families with at least one tied descending P reply;
- `safe_families`: families whose entire tied selection is descending and P-valued.

The first field exposes the target cells; the last two keep existential coverage separate from a
deterministic selector law.

## Reproduction

```bash
rustc -O -C target-cpu=native notes/2026-07-06-grid-cap-solver.rs \
  -o rust/target/gridcap-c70
cd rust
./target/gridcap-c70 s4selectors 19 1,2,3,4 \
  --grundy s4-dumps/2026-07-09/c35/q19-root-1234.grundy.raw \
  --fail-out s4-dumps/2026-07-10/c70-q19-selector-detail.tsv
python3 scripts/c61_q19_hard_surface.py \
  s4-dumps/2026-07-10/c70-q19-selector-detail.tsv
```

Verbatim summary:

```text
C61-Q19-HARD parent=0b7a91f6b96e82780d0fe4202f22b126 rows=12
  cover_all=defect_components_min,guard_killer,internal_live_min,live_min,rect_char_neg_live_min,rect_char_pos_live_min,zero_xor_live_min
  safe_all=
  safe_counts=psi_min:8,rho2_defect:4,rho2_live:4,rho2_psi:4,rho2_zero_live:4,rho3_live:4,rho3_psi:4,rho4_psi:4,zero_xor_live_min:4
```

The full 12-row listing (opponent, override cell, `Delta Psi`, feature signature, safe families) is
emitted by `rust/scripts/c61_q19_hard_surface.py`.  The 3.3 MB detail TSV is ignored bulk data and
is reproducible from the existing exact q=19 Grundy dump in about 102 seconds on the development
machine.

## Next falsification test

Score one additional tie coordinate only on these 12 obligations, starting with the embedded
zone-conflict orbit of the candidate reply.  The gate is exact and small: it must make either
`psi_min` or `zero_xor_live_min` safe without consulting Grundy value.  If no such coordinate
separates the tied candidates, retain the result as a localized impossibility surface rather than
expanding the global selector library.

## Addendum — the conflict-ray tie coordinate closes q=19 locally, but fails uniformly

The requested one-coordinate test is complete.  For a candidate reply `z`, form its rooted local
profile in the live off-conic zone-conflict graph after the opponent move:

```text
R(z) = sorted numbers of live off-conic cells on
       z's row, z's column, and the line from z through each selected point.
```

Legality makes these rays disjoint away from `z`.  Sorting removes the arbitrary order of the
selected points while retaining the candidate's exact local incidence profile.  The coordinate is
geometric and is computed before consulting the Grundy table.

Refine `zero_xor_live_min` lexicographically by **maximizing `R(z)`** after its existing
`(xor_zero, live_on)` gate.  In the solver this family is `zero_live_ray_lex_max`.

### Local result: PASS on all twelve q=19 obligations

```text
C61-Q19-HARD parent=0b7a91f6b96e82780d0fe4202f22b126 rows=12
  safe_all=zero_live_ray_lex_max
  safe_counts=... zero_live_ray_lex_max:12 ...
```

Every candidate remaining after the refined tie rule is P and Psi-decreasing.  This is the first
deterministic geometric selector tested here that is safe on all twelve hard rows.  The opposite
orientation (`zero_live_ray_lex_min`) is safe on only 8/12, so the orientation is substantive.

### Full cross-order replay: NEGATIVE as a uniform winning selector

The same fixed rule was replayed on all five q=13 roots, all ten q=17 full-PGL roots, and the exact
q=19 `[1,2,3,4]` DAG.  `p_hit` means at least one tied selected reply is P; `all_psi` means every
selected reply is P and Psi-decreasing.

| q / corpus | obligations | family | `p_hit` | `all_psi` | tied |
|---|---:|---|---:|---:|---:|
| q=13, five roots | 3,144 | `zero_xor_live_min` | 3,107 | 2,968 | 1,854 |
| | | `zero_live_ray_lex_max` | 3,017 | 3,003 | 1,542 |
| q=17, ten roots | 1,052,204 | `zero_xor_live_min` | 1,043,299 | 846,108 | 617,380 |
| | | `zero_live_ray_lex_max` | 1,006,912 | 983,912 | 379,698 |
| q=19, root `1,2,3,4` | 2,622,214 | `zero_xor_live_min` | 2,577,643 | 1,922,618 | 1,851,909 |
| | | `zero_live_ray_lex_max` | 2,408,348 | 2,347,278 | 1,052,862 |

The refinement greatly improves deterministic purity (`all_psi`) and removes many ties, but it
reduces existential coverage (`p_hit`).  It is therefore a useful local discriminator, not a
winning selector or a `Good`-closure.

The failure is already present at the q=13 root, so no deeper-state explanation can rescue the
uniform rule.  For root key `05f7f1b9445d65074a4fd95e5f4e3462` and opponent `(5,8)`, the coarse
minimum contains both

```text
(7,3):  g=1, R=[0,0,1,1,2,2,2]
(11,3): g=0, R=[0,0,0,0,2,2,2].
```

Lexicographic maximization uniquely chooses the N reply `(7,3)`.  This is a minimal ply-4
counterexample to promoting the q=19 repair into a q-blind selector.

### Consequence

Close this exact successor as **local positive / uniform negative**.  The zone-conflict embedding
was the missing coordinate on the twelve-row q=19 surface, but one fixed monotone orientation of it
does not extend across orders.  A further global feature search is not licensed by this result;
the next proof attempt needs an order-sensitive realization rule or a different invariant, as the
six strict C61 q=17/q=19 collisions already suggested.

Reproduce the local and minimal-regression summaries:

```bash
python3 rust/scripts/c61_q19_hard_surface.py \
  /tmp/c61-q19-rays.tsv --regression-tsv /tmp/c61-q13-ray-regress.tsv
```
