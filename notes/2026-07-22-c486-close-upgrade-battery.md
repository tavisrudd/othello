# C486 — close upgrade battery (three legs)

**Lane:** `crowns`

**Date:** 2026-07-22

**Verdict:**
`L1 TORSOR-ISOMORPHIC · L2 ONE TORSOR CLASS (THREE CERTIFICATES) · L3 RANK-THREE COMPLETION HOLDS (+ forced-outer M12 clause)`

Three ej-closeout upgrades to the certified Paper-1 close ("one torsor, one swap", banked in
`2026-07-22-alt-master-strokes.md`, gap-closed in `2026-07-22-c480-close-gap-certificates.md`).
Each leg is exact integer / finite-field arithmetic over hash-pinned upstream certificates; no
new mathematics beyond pushing certified objects through certified dictionaries.

## Verdict line per leg

- **L1 — the T_11 bridge: TORSOR-ISOMORPHIC.** The C474 q=11 22-parent fixed-child fibre carries a
  canonical two-element quotient — its two sheets of 11 — on which the one-bit decorated-recovery
  loss lives. That quotient is torsor-isomorphic to the orientation torsor `T_11`: the child locus
  `U(A)` is the full 12-point conic `= P^1(F_11)`, and transporting the 22 deletion-trace
  signatures through the conic parametrisation reproduces **exactly** the C445 golden matching
  orbit (one 22-element `PGL_2(11)` orbit = two `PSL_2(11)` sheets of 11). The reduction of `Rz`
  (`(x+10)/(x+1)`, determinant `2`, nonsquare mod 11 — the outer coset) exchanges the two points.
  The map and the swap are compatible with C473's sheet/prime dictionary (the two sheets are the
  two split primes `(3,alpha)`, `(3,alpha+1)` of `Q(sqrt(-11))`, and the outer coset realises the
  Galois exchange `alpha -> -1-alpha`).

- **L2 — one class or three: ONE TORSOR CLASS, THREE CERTIFICATES.** The sheet-swap character
  `sgn : PGL_2(q) -> C2` (square class of the determinant) has kernel exactly `PSL_2(q)` and is
  surjective at both `q = 7, 11`; its torsor is `[T_q]` by definition. Square (a): C417's
  base-point section obstruction has no `PGL`-equivariant point-section (the matching orbit is
  transitive, size `22`/`14`), and its `C2`-shadow is `sgn = [T_q]`. Square (b): C448's selector
  lemma gives cost `= log2|C2| = 1` bit attained through the stabiliser character `sgn`, with cost
  `0` iff `sgn` is trivial iff `[T_q]` is trivial. Hence C417 (Čech cocycle), C448 (one-bit
  selector) and C473 (free `C2` torsor) are three functors of the **single** class `[T_q]`.

- **L3 — rank-three completion + M12 clause: HOLDS.** Over `F_25 = F_5[u]/(u^2-2)` the two A3 spin
  lifts `R_+` and `R_- = Frob(R_+) = -R_+` form a single Frobenius orbit (`u -> -u`); `x^2-2` is
  irreducible mod 5 (2 is a nonsquare), so the orientation object is the **connected** étale
  `C2`-algebra `F_25` — one closed point, the fused `F_5` marker fibre, no bit. The working prime's
  splitting in the frame field drives the trichotomy uniformly: **split => free `C2` torsor** (B3
  at 7 in `Z[sqrt2]`, H3 at 11 in `Z[phi]`), **inert => fused connected point** (A3 at 5 in
  `Z[sqrt2]`). The forced-outer M12 clause is recorded from C480-F (no new computation): the swap
  is invisible to every inner symmetry because `N_{M12}(PSL_2(11)) = PSL_2(11)` is
  self-normalising, `PGL_2(11)` is not a subgroup of `M12`, and the two `M11` parents are
  non-conjugate — so the bit is *forced* outer one layer up.

## What each leg computes

**L1.** Independent `PGL_2(11)` / `PSL_2(11)` on `P^1(F_11)` (orders `1320`, `660`); the C445
`base`/`jmate` matchings generate one `PGL` orbit of 22 that is the disjoint union of two size-11
`PSL` orbits; `Rz` is nonsquare-determinant and swaps them. From the pinned C474 certificate: the
q=11 case has fibre size 22, block profile `(2,2,2,2,2,2)`, two parts of 11 with part-preserving
action order 660. The 12 locus points solve a unique conic; stereographic parametrisation to
`P^1(F_11)` sends the 22 signatures to matchings that, after one `PGL_2(11)` alignment, equal the
C445 orbit set — an explicit `PGL_2(11)`-equivariant torsor isomorphism carrying the two C474 parts
onto the two C445 sheets.

**L2.** For `q = 7, 11`: `|PSL_2(q)| = q(q^2-1)/2`, `sgn` kernel `= PSL`, index 2. The two
comparison squares are assembled over this data as described above.

**L3.** `F_25` split-quaternion arithmetic (`u^2 = 2`, Frobenius `u -> -u`); Legendre symbols
`(2/5) = -1`, `(2/7) = +1`, `(5/11) = +1`; root checks `x^2-2 mod 5` empty (inert), `= (x-3)(x-4)`
mod 7 and `T^2-T-1 = (T-4)(T-8)` mod 11 (split). The M12 clause text is emitted verbatim with
C480-F as the sole source.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c486-close-upgrade-battery.py --check
python3 notes/2026-07-22-c486-close-upgrade-battery-replay.py
(cd notes && sha256sum -c 2026-07-22-c486-close-upgrade-battery.sha256)
```

Intentional regeneration is the primary command without `--check`.

| artifact | role |
|:--|:--|
| `2026-07-22-c486-close-upgrade-battery.py` | primary generator/checker |
| `2026-07-22-c486-close-upgrade-battery-replay.py` | independent replay (imports no primary code) |
| `2026-07-22-c486-close-upgrade-battery.json` | canonical certificate |
| `2026-07-22-c486-close-upgrade-battery.sha256` | checksum manifest |

**Hash-pinned upstream inputs** (SHA-256, first 16): C474 `.json` `02cb69e2d26deb9f`, C445 `.json`
`0ce94294e6e3e190`, C473 `.json` `0f7c8e94d68640d8`, C444 `.json` `311dd3eba6ad7b29`, C480 `.json`
`08a89e884b1b1a6b`, C417 `.json` `ca8b009710da9893`, C448 `.json` `02f8d75f49727321`.

**Trusted boundary.** Exact arithmetic in `F_5/F_7/F_11` and `F_25`; explicit finite closure of
`PGL_2/PSL_2(q)` on `P^1(F_q)`; exact projective conic fitting and stereographic parametrisation;
and the hash-pinned upstream certificates. The battery proves exactly the stated finite
equivalences; it makes no literature, integral-tensor, or Ext claim. The M12 clause is a citation
of C480-F, not a new computation.

## Extra-juice closeout

- **L1 free strengthening.** The bridge is not merely an abstract isomorphism of `PGL_2(11)`-sets:
  the conic-parametrised C474 signatures are *literally the same 22 matchings* as the C445 golden
  orbit after one alignment. So the Reed–Solomon extremal fibre and Paper 1's torsor are one object
  on the nose, not up to an unnamed equivalence.
- **L2 free strengthening.** The single class is the *sign character itself*, the simplest possible
  invariant; the three certificates differ only in the functor applied (cohomological, information
  -theoretic, torsor-theoretic). The "three obstructions" wording in the close can be replaced by
  "one class, three readouts".
- **L3 free strengthening.** A3 (q=5) and B3 (q=7) share the *same* frame field `Q(sqrt2)`; the
  entire trichotomy is the splitting behaviour of the working prime in the rank's frame field, so
  the boundary A3/B3 is not two mechanisms but one reciprocity law evaluated at two primes.

## Mystery ledger

- **Settled — C474's q=11 lost bit IS `T_11`.** L1 exhibits the explicit torsor isomorphism and the
  outer-coset swap; the RS extremal fibre and Paper 1's torsor are the same object. (Resolves the
  ej section-5.4a / mystery-ledger open item in the identity direction.)
- **Settled — the three no-section obstructions are one class.** L2 certifies both comparison
  squares; C417/C448/C473 are three functors of `[T_q] = sgn`. (Resolves the ej section-2 open
  item.)
- **Settled — the q=5 degenerate form.** L3 certifies the fused marker fibre is the Frobenius orbit
  of the two spin lifts and the connected étale `C2`-algebra; the close is a rank-three
  trichotomy-free statement (split => free torsor, inert => fused point) across A3/B3/H3.
- **Settled — the M12 layer is forced outer.** Recorded from C480-F as a theorem-ready sentence; no
  element of `M12` induces the swap.
- **No new mystery.** All three legs pass independent replay; no surprising or unexplained value
  surfaced in this pass beyond the free strengthenings above.
