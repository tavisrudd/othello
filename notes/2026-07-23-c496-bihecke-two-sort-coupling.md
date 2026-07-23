# C496 — is the bi-Hecke bimodule `e_K F[G] e_H` C80's two-sorted coupling?

**Lane:** `cap` (C80 consumer). C434/C411/C495 artifacts are read-only, hashed inputs.

**Date:** 2026-07-23

**Verdict:** `NO as a single bimodule (exact obstruction); YES as a bilinear additive × multiplicative
Gauss/Jacobi pairing (corrected coupling design).`

Last of the three C434→C80 cross-lane transfer probes (fixed order C495 → C497 → C496). C495 refuted
the q=11 identification and C497 refuted the q=17 stratification; both reframed the still-open
two-sorted-coupling item, which C496 now settles on the frozen q=11 packet. This report records the
computational verification; it makes no general-`q`, novelty, or priority claim.

## Question

C80's mystery ledger keeps one open structural item:

> a canonical incidence bimodule carrying both conic-word traces and reply-pencil energy while
> preserving P/N recursion.

The C434 crown supplies a candidate: the bi-Hecke bimodule `e_K F[G] e_H ≅ F[K\G/H]` (C434 clause 3).
C495 ej2 sharpened the two sorts and proved them orthogonal on the frozen packet:

- **sort 1 — additive / incidence:** the double-coset / `D′` label and the determinant-square `C2`,
  moved by the nonsquare cap-frame reflection (the endpoint swap);
- **sort 2 — multiplicative:** the game value P/N `= Legendre(u)`, `u = XZ/Y²`, which is `C2`-invariant.

C496 tests directly whether `e_K F[G] e_H` — an incidence/permutation object realizing sort 1 — can
also carry sort 2 while preserving P/N recursion.

## Frozen test object

The q=11 C447/C460 cloud packet, all four pointed states (both knife-edge classes × both P-edge
endpoints; all four agree, as in C495). Each pointed state's 22 legal opponent moves split into six
`C5`-orbits under the frame-fixed square kernel:

| `C5`-orbit `u` | size | `Legendre(u)` | per-vertex candidate replies | value |
|---|---|---|---|---|
| ∞ | 1 | — | 0 | killed |
| 0 | 1 | 0 | 0 | killed |
| ∞ | 5 | — | 0 | killed |
| 1 | 5 | +1 | 0 | killed |
| **8** | 5 | **−1** | **2** | **P** |
| **9** | 5 | **+1** | **2** | **N** |

Only two orbits are incidence-live (`u=8`, `u=9`), and they carry opposite value.

## Exact obstruction — the incidence bimodule is value-blind where value is decided

The additive-incidence realizations of the two live orbits are **identical**:

- same per-vertex candidate count (2);
- same packet-cell support (all five cells);
- the **same** candidate-pair multiset `{0,1}, {0,2}, {1,3}, {2,4}, {3,4}` — a single 5-cycle
  "pentagon" blossom on the five packet cells.

So the incidence bimodule `e_K F[G] e_H` is constant on the fibre where value splits. It sorts the six
orbits into only **two** incidence classes (empty support = killed, pentagon support = live) while the
value function needs **three** (killed / P / N). The value bit is not a linear coordinate of the
bimodule; it is not any function of it at all. This is not mere rank-dropping — it is a literal
collapse of the P/N distinction, and it is the value-layer face of C411's "set-faithful but
rank-2-on-dimension-6" caveat: the additive realization is faithful on the incidence sort and blind on
the value sort. A single bimodule therefore cannot be C80's two-sorted coupling.

The only difference between the two live orbits is which candidate replies are *winning* — but
"winning" is the output of the value recursion we are trying to predict, not an incidence input. The
incidence input (the pentagon) is shared.

## Corrected coupling design — additive × multiplicative Gauss/Jacobi pairing

The datum that separates the collapsed live fibre is `χ(u) = Legendre(u)`, the quadratic residue
character: `Legendre(8) = −1` (P), `Legendre(9) = +1` (N), so on the incidence-live fibre

```text
value = P  ⇔  χ(u) = −1.
```

`χ` is a multiplicative character orthogonal to the incidence sort: the nonsquare `C2` reflection
preserves `u` pointwise on all 22 moves (hence preserves value) while it moves the incidence/endpoint
label off the state (the endpoint swap, C495). The correct coupling is therefore a **bilinear pairing**
`M_inc ⊗ M_χ` of Gauss/Jacobi-sum shape — the additive-incidence bimodule tensored with the
multiplicative quadratic-character module — **not a single bimodule**. The balanced live Gauss sum

```text
Σ_live χ(u) = 5·χ(8) + 5·χ(9) = 5(−1) + 5(+1) = 0
```

is the knife-edge calibration: the two live orbits are equal-and-opposite, which is exactly the
`C2`-torsor endpoint-swap of C474/C495 (the calibration class restricts to zero on `C5`).

This aligns with C79's character/Jacobi-pencil observations and with C495 ej2's prediction that the
missing coupling "must bridge additive and multiplicative structure — a Gauss/Jacobi-sum-shaped
pairing, not a permutation-module map."

## Bearing on C80's ledger

- The still-open "two-sorted coupling" item is **reshaped, not closed**: the canonical object is not a
  single bimodule but a two-module pairing, and any future descent/abundance argument must carry the
  multiplicative character coordinate explicitly — a permutation/incidence (SDP-on-one-sort) argument
  is provably insufficient at the value layer.
- This is consistent with C497 at q=17 (the additive double-coset label does not refine
  `Y_NK0`-membership) and with C495 layer 3 (C434's `D′` is value-blind): all three are the same
  orthogonality seen from different angles. The general-`q` claim is not made here; q=17 orthogonality
  is C497's separate evidence.
- No change to the (b) descent-measure / minimax-potential gap: the pairing identifies *where* the
  value lives (the multiplicative sort), not a decreasing measure.

## `tt` pass — what Tao would see

- **The pentagon collision is the whole story.** Two group-distinct orbits with byte-identical
  incidence and opposite value is the cleanest possible statement that value is not an incidence
  invariant. The load-bearing object is the pair (incidence realization, multiplicative character),
  and the character is doing all the value work. Recording it as "the incidence bimodule cannot carry
  value" (a structural impossibility on the frozen object) is stronger than "no such coordinate was
  found."
- **Additive/multiplicative orthogonality is the lane's recurring wall.** The dead residue-class laws
  (mod-3 refuted at q=23), C495's fingerprint collision, and C497's non-refinement are all the same
  failure: an additive/incidence statistic mistaken for a value mechanism. C496 makes the reason
  explicit — value is a multiplicative character, and the incidence sort is quadratic-character-blind.
- **The balanced Gauss sum is the knife edge.** `Σ_live χ = 0` is not incidental: it is why q=11 is a
  knife-edge order (equal P and N live orbits) and why the calibration is a `C2`-torsor. A depleted
  order would show an unbalanced sum; the coupling's Gauss-sum value is a candidate depletion
  diagnostic (unallocated).

## Mystery ledger (ej closeout)

- **Settled — the obstruction is a literal collapse, not a rank drop.** The two live orbits share the
  same pentagon incidence realization; value differs. Measured identical at all four pointed states.
- **Settled — the coupling is additive × multiplicative.** `value = [χ(u) = −1]` on the live fibre;
  the separating datum is the quadratic residue character, orthogonal (nonsquare `C2` fixes `u`) to the
  incidence sort. The corrected object is a bilinear Gauss/Jacobi pairing, not a single bimodule.
- **Settled by ej — the balanced live Gauss sum `= 0` is the `C2`-torsor calibration**, unifying with
  C448/C474/C495's governing determinant-square `C2`.
- **Open, with exact gap (unowned):** whether the Gauss-sum value generalizes as a depletion
  diagnostic — unbalanced (`≠ 0`) at a genuinely depleted order past q=17. This needs the gated q=29
  census or a depleted-order object; it is a bounded successor probe, not allocated. No residual
  mystery on the q=11 object.

## Reproduction

Run from `/home/tavis/src/othello`:

```bash
python3 rust/scripts/c496_bihecke_two_sort_coupling.py --check
python3 rust/scripts/c496_bihecke_two_sort_coupling_replay.py
sha256sum -c notes/2026-07-23-c496-bihecke-two-sort-coupling.sha256
```

Intentional regeneration:

```bash
python3 rust/scripts/c496_bihecke_two_sort_coupling.py --write
```

Python 3.13. The primary checker reconstructs the frozen packet via the committed C80 cloud-packet
constructors (`rust/scripts/c80_c447_cloud_packet.py`), decomposes each pointed state's 22 opponent
moves into the six `C5`-orbits, records each orbit's additive-incidence realization (candidate-reply
cell sets), its `Legendre(u)`, and its game value, and asserts the obstruction (identical incidence on
the value-splitting live orbits; 2 incidence classes vs 3 value classes) and the coupling
(`value = [χ(u) = −1]`, balanced live Gauss sum 0, nonsquare `C2` fixes `u`) at all four pointed
states. The independent replay regenerates `PGL_2(11)` by generator closure (order 1320, not the
primary's exhaustive tuple enumeration), reimplements the symmetric-square action, `u`, the
determinant-square test, and `Legendre` from scratch, recomputes the orbit decomposition by union-find
and the incidence-profile identity, and asserts agreement with the committed certificate.

Trust boundary: exact `F_11` integer arithmetic; the residual-grid game engine
(`notes/2026-07-08-intrusion-census.py`) and the frozen C447/C460 geometric constructors are the
shared frozen inputs (the value recursion is the shared engine, as in the C80/C495 bundles). The
bundle makes no general-`q` claim (q=17 orthogonality is C497's separate evidence) and no
novelty/priority claim.

### Artifact hashes

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| primary checker `.py` | 13,886 | `90cb5207cbd5de6204dd308c77c28d7cba460b487d68636075634798c30a8427` |
| independent replay `.py` | 9,641 | `0ce6dc6ae69b25c77a497b2115b4c409af65826bd8eb380e115037d032d8343e` |
| canonical JSON | 18,162 | `e50ca1ee0bccab1edced6af45e8f52933db1d0397bc73061cef70d864a6555d6` |

### Load-bearing inputs (hashed into the certificate `inputs`)

- `rust/scripts/c80_c447_cloud_packet.py`
- `notes/2026-07-21-c447-cap-knife-edge.json`
- `notes/2026-07-08-intrusion-census.py`
