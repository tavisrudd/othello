# C147 — Hexad polarity characterization + durable census verifiers

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-07-14
**Status**: REPORTED. Scripts promoted and re-run; literature verdict settled as ABSENT at
full-text level. One verification gap in the headline claim is open and recorded below — it is new
work, not part of this task.

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

## Open verification gap (new work, not C147)

**The verifier does not close the headline claim.** It builds *one* Steiner system and confirms all
of its hexads sit at `t = 60`. It also shows 132 **non**-hexads at `t = 60` — the second system on
P¹(F₁₁) — but it never checks that those 132 form a Steiner system. The strategy note's assertion
that both systems are Steiner, disjoint, and swapped by `PGL₂(11) ∖ PSL₂(11)` rests on an inline
orbit check that was never part of the script and is lost. So what is machine-checked today is:

- every hexad of the seeded system has `t = 60`;
- exactly 264 of the 924 subsets have `t = 60`, and 61 never occurs.

What is **not** machine-checked: that the remaining 132 are the second system. Until that is
restored, the claim is properly stated as *"`t = 60` iff the subset is a hexad of one of the two
S(5,6,12) systems"*, with the second half resting on an unreproduced computation. Cheapest fix: add
the second-orbit construction and Steiner check to the script — deliberately not done here, because
editing the script would break the hash correspondence to the census artifacts.

## Remaining work before this is claimable

1. Restore the second-system check (above).
2. **A proof.** This is a 924-case verification, and the appeal of the statement is that it is
   synthetic. A referee will ask.
3. **Explain the missing 61.** One accidental concurrence being impossible means concurrences are
   forced to arrive in pairs. That reason is probably the content.
4. **The octad analogue** at q=23 (8-subsets of the conic, S(5,8,24), null `t ≥ 8·C(7,3) = 280`).
   This decides between an elegant note and a real paper: a hit makes the mechanism uniform across
   both Mathieu designs rather than a fact about one. Note M₂₄ does not embed in PGL₂(23) the way
   M₁₂ does in PGL₂(11) — PSL₂(23) is maximal in M₂₄ — so a hit would be more surprising, and a
   structured miss is informative about what the mechanism depends on.
