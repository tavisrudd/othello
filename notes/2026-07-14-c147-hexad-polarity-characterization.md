# C147 — Hexad polarity characterization + durable census verifiers

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-07-14
**Status**: REPORTED. Scripts promoted and re-run; literature verdict settled as ABSENT at
full-text level; the headline claim is fully machine-checked. What remains before it is claimable is
mathematics, not verification: a proof, an explanation of the spectrum gap, and the octad analogue.

## The claim

> A 6-subset of the twelve points of the conic in PG(2,11) is a hexad of S(5,6,12) iff no three of
> its fifteen chords are concurrent off it.

Equivalently, by polarity: the fifteen poles of the chords contain no collinear triple beyond the
sixty forced ones. Each point of the subset forces `C(5,3) = 10` concurrent triples at itself, so
the concurrence count `t` satisfies `t ≥ 60`, with equality exactly when no three chords meet away
from the six points. The null was declared before the census was run.

## Literature verdict: ABSENT

Settled by the sweep (`2026-07-14-gem-lit-hexad.md`) and the adversarial vet
(`2026-07-14-gem-program-vet.md` §1.6), which closed all three named weak points at full-text level:

- **Edge 1956 is a false friend, not a near miss.** His p=11 hexagons are six points drawn from the
  66 *off* the conic (§4 defines e-point = external point; §29 gives 22 such hexagons, each external
  point on 2). Ours are six drawn from the 12 *on* it. His only on-conic Brianchon statement is §19
  at q=5, where the conic has exactly six points and no subset is chosen. He never mentions Mathieu,
  Steiner, or hexads.
- **Lord 1988** obtained: zero conic/concurrency content; PG(5,3)/PG(11,2) only.
- **Edge 1965a** fetched: PG(2,4), where a hexad can never lie on a conic.
- **Edge 1955b** settled by Edge's own reference — it is the q=5 figure.
- **Only one rival geometric characterization exists**: Havlicek/Coxeter/Pellegrino's 12-cap in
  PG(5,3), hexads = hyperplane sections (arXiv:1210.2055) — different ambient space, incidence
  rather than concurrency.

**Why the classical literature could not contain it.** Halbeisen–Hungerbühler (J. Geometry 2024)
study the same fifteen-chord construction over ℝ/ℚ and record that the chords give "in general" 45
intersection points distinct from the six — so no-accidental-concurrency is *generic* in
characteristic zero and extra concurrence is measure-zero. Over F₁₁ it inverts: accidental
concurrences are the norm, and the subsets avoiding them are the Mathieu hexads. With a continuum of
conic points there is no finite family to survey, so the spectrum question is not well-posed until
the conic is finite. The phenomenon is created by finiteness and cannot be a characteristic-zero
specialization.

## Verifiers (promoted from scratchpad, byte-identical to the artifacts that produced the census)

| script                             | sha256                                                             |
|------------------------------------|--------------------------------------------------------------------|
| `2026-07-14-c147-gem-sweep.py`     | `b9886e3ecd305108323373ca289f23ab51754115d8147173c94f0e1e1c6edb2a` |
| `2026-07-14-c147-mathieu-poles.py` | `7a86488679420fa5cafcd644f05f8c0c5aed33b7feb7dbbc2105c27c16629d69` |

Both hashes match the prefixes recorded in `2026-07-14-gem-mining-next-steps-fable.md`, so these are
the artifacts that produced the reported numbers, not reconstructions. They had been living only in
a tmpfs scratchpad and would not have survived a reboot.

```
python3 notes/2026-07-14-c147-gem-sweep.py 3 5 7 11 13 17 19 23 29 31 37 --collect6
python3 notes/2026-07-14-c147-mathieu-poles.py
```

Re-run on promotion (primes 3–19; the full sweep to 37 takes minutes):

- **q=11**: exactly one size-6 arc-clique class, all-external, `|stab| = 60`, uncovered `= 0` ⟹
  `|U| = 12` — healthy. The covering condition is not needed to isolate the Clebsch hexagon among
  six-point configurations.
- **q=19**: 94 size-6 classes; the minimum-uncovered class is all-internal with `|stab| = 60` and
  uncovered `= 120` ⟹ `|U| = 140`, independently reproducing the `clebsch` lane's
  `check_q19_nonexample.py`.
- **q=13**: two size-6 classes (stabilizers 6 and 12), both leaving 24 uncovered.
- E_q degrees and pencil counts match the closed forms at every q tested.
- `mathieu_poles.py`: one S(5,6,12) realized as the PSL(2,11)-orbit of `{0,1,3,4,5,9}`, 132 blocks,
  Steiner property verified; every hexad has `t = 60`; non-hexads split `{60: 132, 62: 330, 63: 220,
  64: 110}`. Total at `t = 60` is 264; `t = 61` never occurs.

## The claim is fully machine-checked

`notes/2026-07-14-c147-hexad-characterization.py` — a standalone verifier of the whole statement,
written rather than patched into `mathieu-poles.py` so the census artifacts keep their hash
correspondence. Every assertion below is an `assert`; the script exits nonzero on any failure.

```
python3 notes/2026-07-14-c147-hexad-characterization.py
```

| check | result |
|-------|--------|
| PSL(2,11) and the PGL∖PSL coset | 660 maps each |
| System 1 = PSL-orbit of `{0,1,3,4,5,9}` | 132 blocks, Steiner **verified** |
| System 2 = image of system 1 under `t ↦ t/2` (det a non-residue) | 132 blocks, Steiner **verified** |
| System 2 is a single PSL-orbit | **checked**, not assumed from normality |
| The two systems are distinct and disjoint | `\|sys1 ∪ sys2\| = 264 = 132 + 132` |
| The outer coset swaps them | **checked** — and all 660 outer maps carry sys1 → sys2 |
| Null `t ≥ 60` | holds, min = 60 |
| Spectrum over all 924 subsets | `{60: 264, 62: 330, 63: 220, 64: 110}` |
| Gap at 61 | holds — 61 never occurs |
| **`t = 60` stratum = sys1 ∪ sys2, exactly** | **verified** |

**The two-system form is forced, not a weakness.** The condition "no three chords concurrent off H"
is defined by conic polarity and so is invariant under the full stabilizer of the conic, `PGL₂(11)`.
Since `PGL₂(11)` swaps the two S(5,6,12) systems (verified above for all 660 outer maps), no
polarity-defined invariant can distinguish them. A characterization that returned only one system
would be evidence of a bug. The correct statement is therefore *"iff H is a hexad of one of the two
S(5,6,12) systems on P¹(F₁₁)"*, and its inability to separate them is a coherence check that passes.

This also re-derives, from a second code path, the chirality motif the vet found in Edge §§29/32
(two systems exchanged exactly by the non-PSL operations) — the same ℤ/2 that the `clebsch` paper's
Prop 5.1 carries on the leader side.

## The octad analogue at q=23 — DEAD, and the mechanism is q=11-only

`notes/2026-07-14-c147-octad-q23.rs` (Rust; `rustc -O`, runs in ~2 s over all C(24,8) = 735471
subsets). Same invariant, next Mathieu design: the 24 conic points of PG(2,23) = P¹(F₂₃), the 759
octads of S(5,8,24) realized via the extended QR(23) Golay code, null `t ≥ 8·C(7,3) = 280`.

**Result: the null is never attained. Minimum `t` = 295.** No 8-subset of the conic at q=23 avoids
accidental concurrences, so there is no stratum for the characterization to select. The prediction
recorded in the script's header — that the outer coset would give `|{t = 280}| = 2 × 759 = 1518`, the
direct analogue of the q=11 result — is refuted.

Verified along the way, because each was a trap:

- **The octads' t-constancy is forced, not a finding.** All 759 octads of both systems sit at
  `t = 304`; but PSL(2,23) is transitive on the octads (orbit of one = all 759, computed) and `t` is
  PSL-invariant, so constancy is automatic. Reporting it as structure would have been an artifact.
- **`t` does not separate the octads.** The `t = 304` stratum holds 65274 subsets, of which 1518 are
  octads.
- **The 759-at-maximum is numerology.** `t = 320` has exactly 759 subsets and `t = 316` exactly 1518
  — octad-sized numbers at the top of the spectrum. Neither is a Steiner system, and both are
  **disjoint from the Golay octads**. `759 = |PGL₂(23)|/16` is a PGL-orbit with stabilizer of order
  16; the coincidence is two index-divisors of one group order — the same `|config| = |space|`
  pattern the fill-signature detector was retired for.

**The failure is geometric, not arithmetic — the third instance of this program's signature
pattern.** Counting permits `t = 280` at q=23. Pairs of chords number C(28,2) = 378, of which
8·C(7,2) = 168 share an endpoint in H, leaving 210 disjoint pairs that must meet off the conic; with
every `m_P ≤ 2` that needs 210 points at `m_P = 2` and 196 at `m_P = 1`, using 406 of the 529
available off-conic points. Feasible, and not realized. The identical computation at q=11 needs 105
of 121 points — also feasible, and there it *is* realized, by exactly the hexads. So capacity does
not explain either outcome. This is the same shape as the healthy census (arc-cliques of
covering-capable size exist for every q ≥ 13, yet none covers) and as "why 11" itself: the counting
permits, the geometry decides, and no structural cause is known.

**Consequence for the write-up.** The mechanism does not generalize to S(5,8,24); the q=11 hexad
characterization is singular, not rung one of a tower. This removes the upside that would have made
it a paper rather than a note — and it fits the program's established character (an anti-robust,
sharp isolated point at q=11 rather than a robust basin), which is itself the reason to state it
plainly rather than hunt for a family that is not there.

## Proof structure — found, and verified at every step

Script: `notes/2026-07-14-c147-proof-structure.py`. This replaces the 924-case check with a
statement about four group orbits, and it explains the whole spectrum including the gap at 61.

**Step 1. `m_P ≤ 3` for every point `P` off the conic.** Two chords meeting at an off-conic point are
disjoint as pairs (chords sharing an endpoint meet at that endpoint, which is on the conic). Four
pairwise-disjoint chords would need eight points of `H`, and `|H| = 6`. Verified: the maximum `m_P`
over all 924 subsets is exactly 3.

**Step 2. Concurrent triples are of exactly two kinds.** Either all three chords pass through a
common point of `H` — forced, and contributing `6·C(5,3) = 60` — or the three chords are pairwise
disjoint, i.e. a perfect matching of `H`. Mixed cases are impossible: if two chords share an
endpoint they meet only there, so a third concurrent chord must contain that point too. Hence
`t(H) = 60 + #{concurrent perfect matchings}`, and a 6-set has only 15 matchings, so `t ≤ 75`.

**Step 3. Concurrence = an involution.** The chords through an off-conic point `P` cut out the
involution `σ_P` on the conic. A matching is concurrent at `P` exactly when its three pairs are pairs
of `σ_P`, i.e. `σ_P(H) = H` with no fixed point of `σ_P` inside `H`. This is the repo's own
point↔involution correspondence, confirmed here independently: PGL₂(11) has **121 involutions, 66
with two fixed points on the conic and 55 with none**, matching the **66 external and 55 internal**
off-conic points exactly.

**Step 4. The identity.** Combining,

> `t(H) = 60 + #{ involutions τ ∈ PGL₂(11) : τ(H) = H and τ has no fixed point in H }`

**Verified for all 924 subsets, no exceptions.**

**Step 5. Four orbits.** PGL₂(11) has exactly four orbits on the 6-subsets, and `t` is constant on
each because the identity in step 4 is manifestly PGL-invariant:

| orbit size | \|Stab\| | Stab type | involutions in Stab | fpf on H | `t` |
|-----------|---------|-----------|---------------------|----------|-----|
| 264       | 5       | C₅        | 0                   | 0        | 60  |
| 330       | 4       | V₄        | 3                   | 2        | 62  |
| 220       | 6       | S₃        | 3                   | 3        | 63  |
| 110       | 12      | D₁₂       | 7                   | 4        | 64  |

`264 + 330 + 220 + 110 = 924`, and each orbit size is `1320/|Stab|`.

**Step 6. The theorem.** The hexads are the 264-orbit, and it is *the orbit whose stabilizer has odd
order*. A group of odd order contains no involutions, so `t = 60` there by step 4 — and every other
orbit has an fpf involution, so `t > 60`. Hence

> **H is a hexad of one of the two S(5,6,12) systems ⟺ Stab_{PGL₂(11)}(H) has odd order ⟺ t(H) = 60.**

**The gap at 61 is explained.** `t − 60` counts fpf involutions in the stabilizer, and the four
stabilizers supply 0, 2, 3, 4. Nothing supplies exactly one. The spectrum is not a curiosity — it is
the orbit decomposition.

**The hexads, explicitly.** An order-5 element of PGL₂(11) fixes two points of P¹(F₁₁) and splits the
remaining ten into two 5-orbits, so an invariant 6-set must be **{a fixed point} ∪ {one 5-orbit}**.
Counting: 66 split tori × 2 fixed points × 2 orbits = **264** — exactly the hexad count. This derives
the classical `{0} ∪ QR(11)` seed rather than assuming it.

**Independent counting check.** Summing `t − 60` over all subsets two ways: by involution, each of
the 66 two-fixed-point involutions has 5 pairs and admits `C(5,3) = 10` invariant fpf 6-sets, each of
the 55 fixed-point-free ones has 6 pairs and admits `C(6,3) = 20`, giving `66·10 + 55·20 = 1760`; by
orbit, `2·330 + 3·220 + 4·110 = 1760`. Agree.

### What is still missing

Steps 1–4 are a complete synthetic proof of the identity and need no computer. Step 6's forward
direction (hexad ⟹ t = 60) needs only that PGL₂(11) is transitive on the 264 hexads with stabilizer
C₅ — classical, and re-derived above from the `{fixed point} ∪ {5-orbit}` description.

**The converse still rests on the orbit classification** — that there are exactly four orbits and the
other three all contain an fpf involution. That is a finite check over four orbits rather than 924
subsets, which is a real improvement, but it is not yet an argument. Two ways to close it: find the
PGL₂(q)-orbit classification on 6-subsets of the projective line in the literature (it is the kind of
thing that should be known, and was not searched), or prove directly that any 6-set with even-order
stabilizer admits an fpf involution.

### Why q=23 fails: the reduction does not transfer, and that is the reason

The identity in step 4 is **not** a general fact about conics — it depends on `|H| = 6 = 2 × 3`. A
concurrent triple is three pairwise-disjoint chords, covering `3 × 2 = 6` points. When `|H| = 6` those
six points are *all* of `H`, so a concurrent triple is a **perfect** matching, hence an involution
stabilising `H` fixed-point-freely. That is the whole mechanism.

At `|H| = 8` it breaks in both directions:

- Three disjoint chords cover only 6 of the 8 points, leaving two over. The triple is a *partial*
  matching and determines no involution of `H`. There are `C(8,6) × 15 = 420` such triples to avoid
  rather than 15.
- `m_P` can reach 4 (four disjoint chords fit in 8 points), so `C(m_P,3) = 4` is possible and the
  contributions are no longer 0/1.

So `t(H) = 280 + #{fpf involutions}` is **false** at q=23, and the group-theoretic characterization has
no analogue there. The octad negative is not bad luck: 28 chords must avoid 420 concurrences with no
involution-theoretic reason to, and the computation confirms none manages it (minimum `t` = 295).

This also settles what the q=11 result *is*. It is not the first rung of a Mathieu tower. It is a
coincidence of small numbers — concurrence is a relation among **three** lines, and three pairs make
**six** points — and the hexads are the 6-sets whose stabiliser has odd order. Nothing about
S(5,8,24) is implicated, and no amount of searching at larger q will produce a sibling.

Venue, given the octad negative: a short note (*Discrete Math.* / *J. Combinatorial Designs* /
*Designs, Codes and Cryptography*), or a *Monthly*-style piece if written for elegance — not a
Mathieu-designs-from-conic-polarity paper, which is what a hit at q=23 would have supported.
