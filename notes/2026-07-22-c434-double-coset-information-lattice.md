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

Third-order (ej2) sharpenings, from the certificate's exhaustive outer-involution sweep
(`K_size_c_distribution_over_outer_involutions`: q=7 has 28 outer involutions, 16 with `|K|=6`
and 12 with `|K|=8`; q=11 has 66, 36 with `|K|=10` and 30 with `|K|=12`; every one gives `c=6`):

- **The `|K|` values are explained.** By orbit–stabilizer, `|K| = |Stab_H(JM0)| = |H|/n` with `n`
  the size of the `H`-suborbit containing `JM0`. The two J-classes select the suborbits of sizes
  `5` and `6` at q=11 (`60/5=12`, `60/6=10`) — the edge stabilizers of C379's valency-5 and
  valency-6 orbitals from its `1,5,6,10` marked quotient — and sizes `3` and `4` at q=7
  (`24/3=8`, `24/4=6`). `K` is an orbital edge stabilizer, not a generic-position intersection.
- **New measured constraint, unexplained:** no outer involution places `JM0` in the remaining
  suborbit mass (size 10 at q=11, which would give `|K|=6`; size 6 at q=7, which would give
  `|K|=4`); those `|K|` values never occur in the exhaustive sweep. A self-pairedness /
  outer-swap-admissibility mechanism is REASONED but unproved.
- **The `c=6` invariance refines to a rank-3 statement:** in all four `(q, J-class)` cases `K`
  has exactly three orbits per sheet, sizes `{1, a, q−1−a}` (`A4: 1,4,6`; `D10: 1,5,5`;
  `D8: 1,2,4`; `S3: 1,3,3`, the last forced arithmetically given `c=6` and the fixed point).
  The theorem constant is `6 = 2 × 3`; the open question is why every golden-pair edge
  stabilizer acts with exactly three orbits on each `q`-point sheet.

Fourth-order (ej3/tt) pass — both remaining residues dissolve (REASONED, hand-checked against
every frozen orbit size; certification owned by C492):

- **Largest-suborbit avoidance is sheet bookkeeping, not a mechanism.** `H` acts on `M0`'s own
  sheet as `{M0} + transitive(q−1)` and on the opposite sheet with two orbits (`10 | 5,6` at
  q=11 splits as own `1,10`, opposite `5,6`; q=7 as own `1,6`, opposite `3,4`). `J` is outer, so
  `JM0` is on the opposite sheet; the size-`(q−1)` suborbit is on the own sheet and can never be
  selected.
- **`c = 6` derives from double-coset counts inside `H` alone.** The two `K` types are exactly
  the opposite-sheet point stabilizers (`A4`, `D10` in `A5`; `D8`, `S3` in `S4`). Per sheet:
  own count `= 1 + #K\H/S_own`, opposite count `= #K\H/S_a + #K\H/S_b`. Three-per-sheet follows
  from `H` 2-transitive on each opposite-sheet orbit, the exact factorizations `A5 = A4·D10` and
  `S4 = D8·S3` (giving the `#K\H/S_other = 1` legs), and `#K\H/S_own = 2`; the predicted orbit
  sizes (`{1,4,6}`, `{1,5,5}`, `{1,2,4}`, `{1,3,3}`) all match the certificate. The invariance
  is thus a statement about the tables of marks of `A5` and `S4` — classical and tiny.
- **tt framing defect to fix in the abstract version:** `22 → 2 → 1` are canonical
  `G`-equivariant collapses, but `22 → 6` is based at the choice of golden pair `(M0, JM0)`;
  the invariant object is the groupoid over that choice. "Portable" should mean the Ω-level
  axiom class (two sheets, 2-transitive opposite orbits, exact factorization), of which B3/H3
  are the complete finite-geometry realizations. Owned by C492.

Fifth-order (ej4) pass — the ej3 ingredients assemble into Bruhat theory (REASONED, hand-checked;
certification folded into C492):

- **`K` is a Borel subgroup of `H` under the exceptional isomorphisms.** The opposite-sheet
  point stabilizers are the Borels of the small projective actions: `A4 = B(PSL_2(4))` on
  `P¹(F_4)`, `D10 = B(PSL_2(5))` on `P¹(F_5)`, `S3 = B(PGL_2(3))` on `P¹(F_3)`, `D8` = pullback
  Borel of `PGL_2(2)` on `P¹(F_2)`. As an `H`-set the golden pair's opposite sheet is
  `P¹(F_4) ⊔ P¹(F_5)` at q=11 and `P¹(F_2) ⊔ P¹(F_3)` at q=7, with `q = (q_1+1) + (q_2+1)`.
- **The double-coset legs are Bruhat cells and Borel transversality.** Same-type counts
  `#K\H/S = 2` are rank-1 Bruhat decompositions `#B\G/B = 2`; cross-type counts `= 1` are the
  exact factorizations (`A5 = A4·D10`, `S4 = D8·S3`) read as transversality of the two Borel
  structures. Opposite sheet = `2 Bruhat + 1 transversal`. Caveat: the own-sheet leg
  `#K\H/S_own = 2` is derived but not yet Bruhat-named — `S_own` (order 6 at q=11, order 4 at
  q=7) is not a Borel of either small structure; naming that leg is part of C492's seam.
- **Structural twin of the Dickson exhaustion:** the construction requires `H` to carry two
  small-projective-line structures at once, which only the exceptional isomorphisms supply; the
  next consecutive pair `(7,8)` fails on order (`|PGL_2(7)| = 336 ≠ 504 = |PSL_2(8)|`). The
  ladder has no third rung.
- **Paper-facing door (one line, owned by the clebsch manuscript owners):** the q=11 conic
  configuration contains `P¹(F_4)` and `P¹(F_5)` as the golden pair's cross-sheet strata — a
  "one object, many languages" sentence with exact provenance here.
- **The middle count is `6` at both verified `q` — and the two cases are the whole domain
  (second ej pass, REASONED, not machine-checked).** The hypotheses force
  `|H| = |G|/2q = (q²−1)/2`. By Dickson's subgroup classification for `PSL_2(q)`, cyclic and
  dihedral subgroups have order at most `q+1 < (q²−1)/2` for `q ≥ 5`, and subfield types
  `PSL_2(q')`/`PGL_2(q')` with `q = q'^k` cannot satisfy the order equation (no integer
  solutions), so `H` is exceptional with `|H| ∈ {12, 24, 60}`, forcing `q² ∈ {25, 49, 121}`.
  The three candidates are `(q=5, A4)`, `(q=7, S4)`, `(q=11, A5)`; the first satisfies
  `H ≤ G⁺` and `|G/H| = 10 = 2q` but fails exactly the normalizer hypothesis
  (`N_{PGL_2(5)}(A4) = S4 ≠ A4`). Hence the hypothesis class is exhaustively `{B3, H3}` and the
  computational verification covers the theorem's entire domain; the "forced vs coincidence"
  question dissolves. The `q=5`/`A4` near-miss (which rung breaks without `N_G(H) = H`, and
  whether any 10-point decorated avatar exists) is a bounded successor probe, unallocated.

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
