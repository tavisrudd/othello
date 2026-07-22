# C480 — gap-closing certificates for the banked Paper-1 close

**Lane:** `crowns`

**Date:** 2026-07-22

**Verdict:**
`A1 PASS · A2 PASS · F OUTER (F MERGES INTO A) · B FALSIFIER FIRES (B DEGRADES TO A PER-CASE DICTIONARY)`

The banked close is **A merged with F** ("one torsor, one swap"); this task runs the four allocated
bounded finite computations. Three legs confirm the close (A's two equivariance legs and F's outer
hinge); B's uniform-rule falsifier fires, so B does **not** upgrade to a master stroke and folds into
A only as the marking. Each leg is exact integer / finite-field arithmetic and consumes hash-pinned
upstream certificates.

## Verdict line per leg

- **A1 — design polarity: PASS.** The reduction of `Rz` (`q=11`) and the silver outer element
  (`q=7`) each swap the two frozen C452 matching sheets and intertwine the cross-disjointness design
  with its transpose, which is the negation `D <-> -D` (the QR/QNR Barker polarity). The map is a
  `C2` torsor map whose determinant (`2` at `q=11`, `-1` at `q=7`) is nonsquare, landing in the
  outer coset exactly as C473's normalization-change table requires. Both legs certified.
- **A2 — signed Fourier sector: PASS.** On C378's rank-16 scalar-`A4` scheme over `F_11^3`, the
  reduction of `Rz` permutes the 16 relations **identically** to C378's involution `J`, exchanging
  the four signed-sector pairs `(1,10),(3,13),(6,14),(9,11)`; `Rz o J^-1` fixes all 16 relations.
  So `Rz` and `J` act the same on the signed Fourier-sector torsor in the frozen normalization.
- **F — outer hinge: OUTER, F merges into A.** In C470's frozen model the normalizer
  `N_{M12}(PSL2(11)) = PSL2(11)` (self-normalizing), no element of `M12` induces a non-inner
  automorphism of the frozen `PSL2(11)`, and the two `M11` parents are non-conjugate in `M12`.
  The reduction of `Rz` induces the diagonal (non-inner) automorphism of `PSL2(11)`; since that
  automorphism cannot be realized inside `M12`, the sheet swap is realized only by the outer,
  row/column-exchanging class of `M12`. Hence the extended Hadamard/`M12` layer is the same
  involution, and F merges into A.
- **B — modular-derived cubic falsifier: FIRES.** No convention-free rule reads the cubic sign from
  the trace residue uniformly at both primes. The residue **value** `0` is the *opposite* sheet at
  `q=7` (`F_2`) but the *marked* sheet at `q=11` (`F_3`), so any fixed function of the residue /
  period `-c_{d-1}` needs a per-case sign; the character of the trace difference `2r+1` gives
  opposite marked-sheet signs (`-1` at `q=7`, `+1` at `q=11`). The only uniform rule is the
  quadratic character of the unipotent parameter, which is `+1` on the marked square-class sheet —
  i.e. the Coxeter marking itself, not an arithmetic origin for the `+/-6`. B therefore degrades to
  "compatible after conventions" and folds into A as the marking.

## What each leg computes

**A1.** For `q in {7,11}` the two C452 sheets are labeled by the translation `x -> x+1`. The outer
element is the reduction of `Rz = (x+10)/(x+1)` at `q=11` (determinant `2`, nonsquare mod 11) and
the silver `J = (x -> -x)` at `q=7` (determinant `-1`, nonsquare mod 7). Each swaps the two sheets
as sets of matchings. The cross-disjointness matrix `M[i][j] = [sheet0_i disjoint sheet1_j]`
reproduces C452's certificate; its row-0 design is C452's difference set `D_q` and its column-0
design is `-D_q`. The sheet relabelings `sigma, tau` induced by the outer element satisfy
`M[i][j] = M[tau(j)][sigma(i)]`, the exact transpose-intertwining that carries `D_q` to `-D_q`.

**A2.** The rank-16 scalar-`A4` relations are the orbits of `<A4, F_11^*>` where `A4 = G_+ cap G_-`
(the ordered-golden-pair stabilizer). Both scripts rebuild the 16 relations and confirm their sizes
and representatives equal C378's certified metadata. `Rz` and `J` are then applied to each relation
representative; both produce C378's `J_relation_permutation`.

**F.** From C470's frozen generators the scripts build `L = PSL2(11)` (order 660), the pure and
puncture `M11` parents `P, K` (order 7920, `P cap K = L`, `<P,K> = M12`, order 95040). The decisive
discriminator is `N_{M12}(L) = L`: the only elements of `M12` normalizing `L` are `L` itself, and
each induces an inner automorphism of `L`. Independently on `P^1(F_11)`, `Rz` normalizes
`PSL2(11)` and induces the diagonal (non-inner) automorphism. A diagonal automorphism therefore has
no inner-to-`M12` realization; with `P, K` non-conjugate in `M12`, the realization is the outer
class exchanging the two parents (Hadamard row/column duality).

**B.** From C473 the marked (Coxeter, square unipotent class) sheet has trace residue `1` at `q=7`
(in `F_2`) and `0` at `q=11` (in `F_3`); the opposite sheets have residues `0` and `2`. The cubic
sign is outer-odd (C444/C406). The candidate space of convention-free rules is exhausted: the
unipotent-parameter character is uniform but is the marking; every function of the residue/period
value needs a per-case sign because residue value `0` changes sheet role between the primes.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c480-close-gap-certificates.py --check
python3 notes/2026-07-22-c480-close-gap-certificates-replay.py
(cd notes && sha256sum -c 2026-07-22-c480-close-gap-certificates.sha256)
```

Intentional regeneration is the primary command without `--check`.

| artifact | role |
|:--|:--|
| `2026-07-22-c480-close-gap-certificates.py` | primary generator/checker |
| `2026-07-22-c480-close-gap-certificates-replay.py` | independent replay (imports no primary code, no C341) |
| `2026-07-22-c480-close-gap-certificates.json` | canonical certificate |
| `2026-07-22-c480-close-gap-certificates.sha256` | checksum manifest |

**Hash-pinned upstream inputs** (SHA-256): C452 `.json` `6f5829b2...`, C445 `.json` `0ce94294...`,
C378 `.json` `3b311e5e...`, C470 `.json` `694ddb70...`, C473 `.json` `0f7c8e94...`, C444 `.json`
`311dd3eb...`, C341 `.py` `4419cf39...`.

**Trusted boundary.** Exact integer, finite-field, permutation, matching, and polynomial
arithmetic; explicit finite closure of the groups `A4`(12), `PSL2(11)`(660), `M11`(7920),
`M12`(95040), `PSL2(11)`/`PGL2(11)` on `P^1(F_11)`; and the hash-pinned upstream certificates.
The primary imports C341 (hash-pinned, as C378 does) to rebuild `G_+/G_-/A4`; the replay instead
supplies `A4` as 12 monomial matrices and verifies them against C378's certified scheme (order,
`Q`-invariance, valencies, representatives). No literature priority, integral tensor, or Ext claim
is made; the four legs prove exactly the stated finite equivariances and the one stated negative.

## Assembly consequence

A1, A2, and F extend the certified realization list of the single free `C2` orientation torsor: the
two sheets, unipotent classes, period factors, split primes, `Z[phi]` primes, lower Weil
constituents, and cubic signs (already certified) now also carry the **two QR/Barker design
polarities** (A1) and the **two signed Fourier sectors** (A2) as canonical torsor legs, and the
**`M12` outer hinge** (F) is the same involution acting through Hadamard duality. The banked
close "one torsor, one swap" (A merged with F) stands with all its legs certified. B does not
supply a seventh, independent, arithmetic readout of the `+/-6`; the co-variation is intrinsic but
the readout is the marking, so B contributes one sentence inside A's close rather than a stroke.

## Extra-juice closeout

- **A1 free strengthening — uniform over both primes and identified with QR/QNR polarity.** The
  falsifier only demanded the `q=11` `Rz` check; the same statement holds at `q=7` with the silver
  outer element. Because both `q = 7, 11` are `= 3 mod 4`, each QR difference set is skew-Hadamard,
  so its negation is the QNR set; the outer swap is exactly the QR `<->` QNR Barker-polarity flip.
  This is the design-theoretic face of the sheet swap.
- **A2 stronger-than-needed.** `Rz` and `J` are not merely cofinal on the four odd pairs; they induce
  the identical permutation on **all** 16 relations (`Rz o J^-1 = id`). The sector swap is a
  restriction of a total agreement, so no orientation ambiguity survives on the even part either.
- **F crisp mechanism.** The whole hinge rests on one clean fact: `PSL2(11)` is **self-normalizing**
  in `M12` (`N_{M12}(L) = L`). This is the exact reason the diagonal (sheet-swap) automorphism must
  leave `M12` to be realized, forcing the outer class; the associated `PGL2(11)` (order 1320) is not
  a subgroup of `M12`.
- **B sharp obstruction.** The marked sheet's square-class label is uniform (`+1`), but its period
  value is field-dependent (`1` in `F_2`, `0` in `F_3`); the period therefore **forgets** the one
  datum that is uniform. That is why a residue/period readout of the `+/-6` cannot be
  convention-free.

## Mystery ledger

- **Settled — the design and Fourier legs are canonical torsor maps.** A1 and A2 pass; both are
  induced by the certified outer element (`Rz`'s reduction) as `C2`-equivariant maps.
- **Settled — the extended layer is the same involution.** F is outer: `N_{M12}(PSL2(11)) = PSL2(11)`
  forces the sheet swap into the row/column-exchanging class; F merges into A.
- **Settled (negatively) — B is not a master stroke.** No convention-free uniform residue rule for
  the `+/-6`; the only uniform rule is the marking. The residue-`0` role reversal between the primes
  is the exact obstruction and is fully explained (field-dependent period vs uniform square class).
- **Surprising but explained.** `Rz` equals `J` on the *entire* rank-16 relation set, not only the
  signed sector; and the two outer determinants differ (`2` at `q=11`, `-1` at `q=7`) yet both are
  nonsquare — each is a genuine outer-coset representative, so the extra agreement and the differing
  nonsquare values are expected, not anomalous.
- **No open C480 mystery remains.** Every leg passes independent replay; the one negative (B) is
  stated with its exact searched candidate space (unipotent-parameter character, residue/period
  value, trace-difference character) and its exact stop condition (residue-value role reversal).
