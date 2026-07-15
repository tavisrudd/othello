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

## Remaining work before this is claimable

1. **A proof.** This is a 924-case verification, and the appeal of the statement is that it is
   synthetic. A referee will ask.
3. **Explain the missing 61.** One accidental concurrence being impossible means concurrences are
   forced to arrive in pairs. That reason is probably the content.
4. **The octad analogue** at q=23 (8-subsets of the conic, S(5,8,24), null `t ≥ 8·C(7,3) = 280`).
   This decides between an elegant note and a real paper: a hit makes the mechanism uniform across
   both Mathieu designs rather than a fact about one. Note M₂₄ does not embed in PGL₂(23) the way
   M₁₂ does in PGL₂(11) — PSL₂(23) is maximal in M₂₄ — so a hit would be more surprising, and a
   structured miss is informative about what the mechanism depends on.
