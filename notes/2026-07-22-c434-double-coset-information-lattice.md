# C434 — portable K\G/H recovery theorem and the 2q → c → 2 → 1 information lattice

**Lane:** `crowns`

**Date:** 2026-07-22

**Verdict:** `THEOREM VERIFIED AT q=7 (B3) AND q=11 (H3); MIDDLE STRATUM REALIZED BY INTRINSIC EDGE
DATA; C430 RADICAL→SHEETS→EQUAL-SUM→SIGN-LINE CHAIN FUNCTORIALLY EMBEDDED; DECORATED INVERSION AS
RECONSTRUCTION CONSEQUENCE`

This report records the computational verification; it makes no novelty or priority claim.

## Theorem (as tested)

Let `q` be an odd prime power. Inside the conic-stabilizer chain `G = PGL_2(q) ⊃ G⁺ = PSL_2(q)`
let `H = Stab_G(M0)` be the reflection parent of the base matching `M0` (H3: `A5` at `q=11`; B3:
`S4` at `q=7`; C406 base matchings B3 `(0,2)(1,4)(3,7)(5,6)`, H3 `(0,1)(2,5)(3,7)(4,9)(6,8)(10,11)`),
with `N_G(H) = H`. Let `Ω` be the `G`-orbit of `M0`; then `|Ω| = 2q`, split by `G⁺` into two
`q`-sheets exchanged by any outer element `J`. Define

```text
K := Stab_G(M0) ∩ Stab_G(J M0).
```

**Canonical choice of J (measured, see §measured-vs-asserted).** For every outer *involution* `J`,
`J` swaps `M0 ↔ J M0` and therefore normalizes `K` automatically. Among outer involutions the value
`|K|` takes two values; we fix `J` as the involution of **maximal `|K|`** (deterministic tie-break:
least permutation tuple). At `q=11` this reproduces C411's golden `K = A4` of order 12; the
double-coset count `c = 6` is the same for *both* involution classes at each `q` (a measured
invariance).

The verified clauses, at both `q=7` and `q=11`:

1. **Strata.** `|Ω| = 2q`; two `G⁺`-sheets of size `q`; `J` normalizes `K`; `K` has `c` orbits on
   `Ω` whose sizes form two equal `J`-paired lists across the sheets.
2. **Intrinsic middle realization.** With `D'(M) = (|M ∩ M0|, |M ∩ J M0|)` (shared unordered
   edges), `D'` is constant on `K`-orbits and the fibres of `M ↦ (sheet(M), D'(M))` are *exactly*
   the `K`-orbits. (The sheet coordinate is load-bearing: `D'` alone merges the two `(0,0)` orbits.)
3. **Bi-Hecke dimension.** `dim e_K Q[G] e_H = c` by Mackey (= number of `K\G/H` double cosets =
   number of `K`-orbits on `G/H`, since `Stab_G(M0) = H`), cross-checked by direct double-coset
   enumeration in `G`.
4. **Algebra-chain functoriality.** On `F(Ω) = F_q^Ω` the invariant subalgebra chain
   `F(G\G/H) ⊂ F(G⁺\G/H) ⊂ F(K\G/H) ⊂ F(Ω)` has dimensions `1 ⊂ 2 ⊂ c ⊂ 2q`; C430's chain
   `affine radical → sheet indicators → equal-sum product algebra → sign line` sits inside it: the
   sheet indicators `e₊, e₋` (recovered by C430's second-moment radical algorithm) span the level-2
   algebra, the sign line `k(e₊ − e₋)` is `J`-negated, `K`-invariant, and lies in the `J`-odd part
   of `F(K\G/H)`, and `J` fixes constants pointwise, swaps `e₊/e₋`, and permutes the `c`
   orbit-indicators in `J`-pairs.
5. **Sign law and moments.** `q=11`: reuse of the C411 machinery — `D(JM) = −D(M)`, weights
   `(1,4,6)`, `v1 + 4v2 + 6v3 = 0`, even signed moments vanish, cubic witness `6 mod 11`
   (consumed from the C411 certificate). `q=7`: the portable part — signed moments `μ₁ = μ₂ = 0`,
   `μ₃ ≠ 0` (consumed from the C406 certificate).
6. **Reconstruction (decorated inversion through the lattice).** Each `(sheet, D')`-fibre is a
   single `K`-orbit `≅ K/K_M` with the measured stabilizer orders; hence profile label + a
   `K`-coset decoration determines `M` uniquely. The two singleton fibres are exactly `M0` and its
   `J`-mate. At `q=11` composition with C379's frozen decorated injection (matching → parent,
   stabilizer exactly the order-60 `A5`) yields parent recovery.

## Per-clause results

| clause | B3 (q=7) | H3 (q=11) |
|:--|:--|:--|
| 1 strata | PASS · `\|Ω\|=14`, sheets `7/7`, `c=6`, sizes `[1,1,2,2,4,4]`, `J`-paired | PASS · `\|Ω\|=22`, sheets `11/11`, `c=6`, sizes `[1,1,4,4,6,6]`, `J`-paired |
| 2 middle | PASS · fibres = `K`-orbits; `D'`-alone merges the two `(0,0)` orbits | PASS · fibres = `K`-orbits; `D'`-alone merges the two `(0,0)` orbits |
| 3 bi-Hecke | PASS · Mackey `6` = direct double cosets `6` | PASS · Mackey `6` = direct double cosets `6` |
| 4 algebra chain | PASS · dims `[1,2,6,14]`; sign line `J`-odd, `K`-inv | PASS · dims `[1,2,6,22]`; sign line `J`-odd, `K`-inv |
| 5 moments | PASS · `μ₁=μ₂=0`, `μ₃≠0` (C406) | PASS · weights `(1,4,6)`, `v1+4v2+6v3=0`, cubic `6` (C411) |
| 6 reconstruction | PASS · stab orders `{8,4,2}`; singletons = base + `J`-mate | PASS · stab orders `{12,3,2}`; C379 injection ⇒ parent recovery |

All six clauses PASS at both `q`. Information lattice realized: `2q → c → 2 → 1` =
`14 → 6 → 2 → 1` (B3) and `22 → 6 → 2 → 1` (H3).

## Measured vs asserted

The prompt's expected values were confirmed where asserted, and the `q=7` values it asked to
*measure* came out as follows.

| quantity | prompt expectation | measured |
|:--|:--|:--|
| `q=11` `c`, sizes | `c=6`, `[1,1,4,4,6,6]` | `c=6`, `[1,1,4,4,6,6]` (confirmed) |
| `q=11` `\|K\|` | `A4`, order 12 | 12 (max-`\|K\|` involution; the golden `A4`) |
| `q=11` stabilizer orders | `12,3,2` | `12,3,2` (confirmed) |
| `q=7` `\|K\|` | measurement | **8** (`D8`, a Sylow-2 of `S4`) for the canonical max-`\|K\|` `J` |
| `q=7` `c` | measurement, "do not force 6" | **6** |
| `q=7` orbit sizes | measurement | **`[1,1,2,2,4,4]`** |
| `q=7` stabilizer orders | measurement | **`{8,4,2}`** |
| `q=7` fibre identity | measurement | **yes** — `(sheet, D')` fibres = `K`-orbits exactly |

Surprises worth flagging:

- **`c=6` is `J`-class-independent even though `|K|` is not.** At each `q` there are two outer
  involution classes: `q=7` gives `|K| ∈ {6 (S3), 8 (D8)}`, `q=11` gives `|K| ∈ {10 (D10),
  12 (A4)}`. In every case the number of `K`-orbits (= double cosets) is `6`. The order-10 `D10`
  case at `q=11` is the incident-stabilizer of the Pan–Wu–Yin orbital picture; `A4` (order 12) is
  the C411 golden choice. The count `c=6` is stable across the choice; the *sizes* are not
  (`[1,1,5,5,5,5]` for `D10`, `[1,1,4,4,6,6]` for `A4`).
- **The middle level is `c=6` at `q=7` as well**, so the lattice is `14 → 6 → 2 → 1` — a genuine
  six-stratum middle, not inherited from C379 (whose only transitive levels are `22, 2, 1`). C434
  constructs the size-`c` stratum intrinsically via `(sheet, D')`.
- **`D'` alone is not injective on strata**: the two "disjoint-from-both" orbits (the size-2 orbits
  at B3, the size-4 orbits at H3) both carry `D'=(0,0)` and are separated only by the sheet
  coordinate. The joint map `(sheet, D')` is therefore the minimal intrinsic realization of the
  `K\G/H` strata.

## Mystery ledger (ej closeout)

Settled by the closeout pass:

- **The `D'=(0,0)` degeneracy is explained, not anomalous.** Both sheets carry a
  disjoint-from-both class, so `D'` alone must merge them; the sheet coordinate is exactly the
  missing bit, and `(sheet, D')` is the minimal intrinsic realization of the strata. No finer
  edge statistic is needed at either `q`.
- **The canonical max-`|K|` tie-break reproduces C411's golden `A4` at `q=11`**, so the C411
  choice is canonical rather than ad hoc.

Still open, with exact gaps:

- **`c = 6` is invariant across the two outer-involution classes at each `q`, while `|K|` and the
  orbit sizes are not** (`q=11`: `D10` gives `[1,1,5,5,5,5]`, `A4` gives `[1,1,4,4,6,6]`; `q=7`:
  `S3` vs `D8`). Measured at both `q`; unexplained. The evidence gap is a character identity —
  whether `⟨Ind_K^G 1, Ind_H^G 1⟩` is forced to be equal for the two classes of `K = H ∩ H^J` —
  and it has no owner; promotion goes through the normal C-ID process.
- **The middle count is `6` at both verified `q`.** Whether `c = 6` is forced by the hypotheses
  (`H ≤ G⁺`, `N_G(H) = H`, `|G/H| = 2q`) or a coincidence of the two Coxeter cases is untested:
  no third configuration satisfying the hypotheses has been checked (A3 at `q=5` is excluded
  since its `S4` is not inside `PSL_2(5)`). Stated domain: exactly the two configurations B3, H3.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c434-double-coset-information-lattice.py --check
python3 notes/2026-07-22-c434-double-coset-information-lattice-replay.py
sha256sum -c notes/2026-07-22-c434-double-coset-information-lattice.sha256
```

Intentional regeneration:

```bash
python3 notes/2026-07-22-c434-double-coset-information-lattice.py --write
```

Python 3.13.12. The primary checker reconstructs `G, G⁺, H, Ω`, the two sheets, the canonical outer
involution `J`, `K`, its orbits/stabilizers, the `(sheet, D')` fibres, the direct `K\G/H`
double-coset sweep, and the invariant-subalgebra dimension chain, then consumes the heavy
C378-depth / relative-cubic pieces from the frozen C411 and C406 certificates (weights, cubic
witness, signed-moment degrees) rather than recomputing them. The independent replay re-derives `K`,
the orbits (union-find), the double-coset count (opposite extremal sweep), the chain dimensions, the
sign-line equivariance, the stabilizer orders, and the singleton fibres with its own permutation
code, sharing only the frozen geometric constructors, and asserts equality with the tracked
certificate.

Trusted boundary: exact `F_q` integer arithmetic; the frozen C406 base matchings and PGL/PSL/parent
constructors; the C411/C406/C430/C379 committed certificates (consumed by path + SHA-256). The
bundle does not prove a general-`q` theorem beyond the two verified cases, nor any novelty/priority
claim.

### Artifact hashes

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| primary checker `.py` | 22,544 | `b1ba013747d9fa1d9c9b4f6055a26a7dc53a953babca366057c7094f46549d27` |
| independent replay `.py` | 7,745 | `1285cf4d23878b3798834dae2eb4d16777651ab5395b0477c93e0e644dc7ccaf` |
| canonical JSON | 12,477 | `6d0e0106aa04dfcfe694f74494eaf86743a3254c62c6c1e878000301ec2f0899` |

### Frozen-input hashes (hashed into the certificate `inputs`)

| input | SHA-256 |
|:--|:--|
| `2026-07-20-c406-matching-module.py` | `a1fef3680a7d12d64a1c483e7032cbaa3a1f575883b2bd8b964d58aa8ac38d51` |
| `2026-07-20-c406-matching-module.json` | `e39bf131f3d818dfbcbeb1f2d4dfa9a6ba7645c41cdd6fe9600957c0fe1dc4b2` |
| `2026-07-20-c406-matching-orbit-scout.json` | `fec533bb91f864100ebf5875952244d9d9e03ed69a0abda767360907a55bb246` |
| `2026-07-20-c430-conceptual-balanced-half-rigidity.json` | `eebfd0525c94ac0bcb7965ab33b6d11a698242e608d9d1a40cebaa0a2b451098` |
| `2026-07-20-c411-double-coset-hecke.json` | `23f0a100356f0a369f00d81011e8d8d6b9d867b9de45a7b0625fc2889323b014` |
| `2026-07-19-c379-clebsch-deep-hole-extension.json` | `3cc3a7008d91a06f95504cbced7adc2eef9b304355a3a56bb64bdd0bea19ad8d` |
| `2026-07-20-c399-coxeter-number-conic-phase.py` | `f90f8bf9ef85667ffeb937c4b3f07c54407edcfc965fb4cf9b45f7f854097275` |
| `2026-07-19-c378-clebsch-common-duality.py` | `e45e71c5e87ccc334fab3b926e5189373e24485adf11ed1cbaacfc6771610bdc` |
| `2026-07-19-c378-clebsch-common-duality.json` | `3b311e5ee8ba5d09510fe18e4c5f3e30223c804d49b7c5b206e125ce1ad879dc` |
