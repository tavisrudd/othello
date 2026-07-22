# C487 — characteristic-zero realization row

**Lane:** `crowns`

**Date:** 2026-07-22

**Verdict:**
`POSITIVE — THE OUTER SWAP EXCHANGES C459'S DESCENT COCYCLE PAIR; THE TORSOR LIST GAINS A
CHARACTERISTIC-ZERO REALIZATION ROW (THE S3-RESOLVENT Spec Q(sqrt5))`

ej section 4.1 (C459 item): does the outer swap exchange C459's rational descent cocycle pair under
the certified dictionaries, i.e. does the orientation-torsor list acquire its first non-finite
(characteristic-zero) entry? It does. C459's frozen data is consumed read-only.

## Result

C459 certifies that the intrinsic `S3`-resolvent quotient of the descended golden six-arc is
`Spec Q(sqrt5) = (K x K x K)^{S3}` with `K = Q(sqrt5)` — a characteristic-zero free `C2` object
with **no rational section** (the golden labeling `S` vs `sigma(S)` does not descend; choosing one
is choosing a prime above 11). Its structural swap is the Galois involution `sigma` of `Q(sqrt5)`,
`phi -> 1-phi`, i.e. the two-character machine `Z[1/5,T]/(T^2-T-1)`.

Under reduction at 11 this is exactly the orientation torsor `T_11`:

- `T^2 - T - 1 = (T-4)(T-8) mod 11`; the two roots `{4,8}` are the two golden `phi`-values labeling
  C458's two sheets `M_pi` (`phi=8`) and `M_pibar` (`phi=4`).
- `sigma : T -> 1-T` swaps the roots (their sum is 1), hence swaps `phi=8 <-> phi=4`, hence swaps
  the two sheets `M_pi <-> M_pibar` — the two points of `T_11` (C445).
- By C445 the outer element `Rz` (`(x+10)/(x+1)`, determinant 2, nonsquare mod 11) swaps those two
  sheets; by C473 the sheet swap equals the Galois exchange `alpha -> -1-alpha` of `Q(sqrt(-11))`
  and the outer `PGL_2(11)/PSL_2(11)` coset. So `sigma` corresponds to the outer coset under the
  certified dictionaries.

Therefore the characteristic-zero golden descent is a genuine realization row of `T_q`, exchanged
by the outer swap — the first non-finite entry on the torsor list.

## The exact structural feature (stated, not a defect)

The descended `Q`-form's matching **decoration is rational**: reduced at either prime above 11 it
gives the *same single* perfect matching. So the bit is not visible in the reduced `Q`-form
decoration — it is carried by the Hilbert-90 transport / the `S3`-resolvent, exactly the labeling
that C459 proves does not descend (and C417's section obstruction). Concretely, with
`G = h^T h` (certified), the Hilbert-90 matrix `h` maps the descended conic to the sum-of-squares
conic, and `h` reduces differently at the two primes because `sqrt5 = 2 phi - 1` reduces to
`4` at `phi=8` and to `7 = -4` at `phi=4` (the Galois conjugates of `sqrt5` mod 11). Transporting
the one rational matching by `h_{phi}` recovers **two distinct** golden sheets, which the
computation confirms lie in one `PGL_2(11)` orbit but different `PSL_2(11)` orbits (an explicit
outer, nonsquare-determinant transporter). This is the characteristic-zero face of the same
no-section torsor, not a second obstruction.

## What the checker computes

Exact `Q(phi)` arithmetic reduced mod 11 (pair model `[a,b] = a + b*phi`). It factors
`T^2-T-1` mod 11 and checks the `sigma` root swap; reduces the six descended arc points and the
rational Gram `G` at `phi = 8, 4`, forms the polar-pair matchings, and verifies they are identical
(rational decoration); verifies `h^T h = G mod 11` and `sqrt5 -> {4,7}`; transports by `h_{phi}`
onto the identity conic to obtain the two sheets; parametrises that conic to `P^1(F_11)`; builds
`PGL_2(11)`/`PSL_2(11)`; and checks the two sheets are same-`PGL`-orbit, different-`PSL`-orbit, with
an explicit nonsquare-determinant transporter.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c487-char-zero-realization-row.py --check
python3 notes/2026-07-22-c487-char-zero-realization-row-replay.py
(cd notes && sha256sum -c 2026-07-22-c487-char-zero-realization-row.sha256)
```

Intentional regeneration is the primary command without `--check`.

| artifact | role |
|:--|:--|
| `2026-07-22-c487-char-zero-realization-row.py` | primary generator/checker |
| `2026-07-22-c487-char-zero-realization-row-replay.py` | independent replay (imports no primary code) |
| `2026-07-22-c487-char-zero-realization-row.json` | canonical certificate |
| `2026-07-22-c487-char-zero-realization-row.sha256` | checksum manifest |

**Hash-pinned upstream inputs** (SHA-256, first 16): C459 `.json` `8ca5d238b2024fcb`, C445 `.json`
`0ce94294e6e3e190`, C473 `.json` `0f7c8e94d68640d8`.

**Trusted boundary.** Exact arithmetic in `Q(phi)` reduced mod 11, `F_11` projective/polynomial
arithmetic, explicit `PGL_2/PSL_2(11)` closure, and the hash-pinned C459/C445/C473 certificates.
The checker proves exactly the stated reductions and equivariances; it makes no literature,
novelty, or absolute-`H^1` claim. The characteristic-zero object is C459's certified `S3`-resolvent;
its identification with `T_q` is via the reduction dictionary, not an absolute-Galois statement.

## Extra-juice closeout and mystery ledger

- **Settled — the char-zero row exists and is exchanged by the outer swap.** POSITIVE, with the
  explicit `sigma <-> Rz`-coset correspondence and the explicit nonsquare transporter of the two
  golden sheets. The torsor list gains its first non-finite entry.
- **Settled — where the bit lives.** In the descended `Q`-form the decoration is rational and shows
  no bit; the bit is the Hilbert-90 transport / `S3`-resolvent, matching C459's "labeling does not
  descend" and C417's boundary. This is a feature that sharpens the row, not an obstruction.
- **Free strengthening.** The characteristic-zero swap is `Gal(Q(sqrt5)/Q)` — literally the
  original master-stroke sentence ("the missing bit is `Gal(Q(sqrt5)/Q)`, made finite") realized
  *before* going finite; the finite torsor `T_11` is its reduction at 11. The close's arithmetic and
  finite faces are one object across the reduction.
- **No open C487 mystery.** Both computations pass independent replay; the single subtlety (rational
  decoration vs transported sheets) is exactly characterized above.
