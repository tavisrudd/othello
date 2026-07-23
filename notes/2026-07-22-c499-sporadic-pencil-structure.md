# C499 — structure of the C491 sporadic PRS(q−4) deep-hole orbits

**Lane:** `reed-solomon` · **Date:** 2026-07-22

Promotes the C491 discovery-track leads "stab-12 sporadic pattern" and "q=8 sporadic torsor"
(`notes/2026-07-22-reed-solomon-discovery-track.md`). No census regeneration: every result below is
reconstructed from the stored representatives in the frozen certificate
`2026-07-22-c491-prs-deep-hole-census.json`, reusing the frozen generator's field/pencil/factor
machinery `2026-07-22-c491-prs-deep-hole-census.py` (imported, never re-run).

## Summary

Recall (C491, Lemma 6(3)/Lemma 7): every sporadic deep hole has pencil gcd 0 and lies in the S₃
stratum — its Hankel pencil defines a degree-3 rational cover φ_f: P¹ → P¹ with geometric monodromy
S₃, deep because the fiber-square curve Y_f has no rational split-member witness below q = 23. This
task gives the intrinsic structure of every sporadic orbit at q ∈ {7,8,9,11,13,17,19}.

1. **One invariant classifies all sporadics: the Frobenius orbit type of the degree-4 branch
   divisor** of φ_f (equivalently the F_q-factorization type of the discriminant quartic Δ(λ) of the
   pencil), refined for the fully-split case by the branch tetrad's j-invariant. Every sporadic orbit
   is exactly one of five normal forms (§3). The PGL₂(q) point-stabilizer is determined by the type
   and equals the group of branch-divisor symmetries that preserve the cover.

2. **The equianharmonic/A₄ hypothesis is confirmed (Theorem C499.1).** The three stabilizer-order-12
   sporadic orbits — q = 7 (size 28), 13 (182), 19 (570), exactly the sporadic fields q ≡ 1 mod 3 —
   are precisely the pencils whose branch tetrad is **equianharmonic** (cross-ratio a primitive sixth
   root of unity; independently, the binary-quartic invariant I(Δ) = 0). Their stabilizer is the
   tetrahedral group **A₄** (proved via the projective-order fingerprint {1:1, 2:3, 3:8}), and the
   "constant 4 double-root + 4 irreducible members" pattern holds. The A₄ enhancement is the exact
   redundancy-five analogue of C491's O⁺/O⁻ mechanism: the order-3 tetrad symmetry is rational iff
   q ≡ 1 mod 3.

3. **The "4 double-root + 4 irreducible" profile is explained (§4).** For every fully-split-branch
   sporadic — the A₄ ones and the V₄ ones alike — the four double-root members and the four
   irreducible-cubic members are each a **single orbit of the syndrome stabilizer** acting on the
   pencil line (A₄'s two size-4 tetrahedral orbits; V₄'s free size-4 orbits).

4. **The q = 8 three-orbit Frobenius torsor is derived (§5).** The three size-252 sporadic orbits form
   one **free Gal(F₈/F₂) ≅ C₃ torsor**: coordinatewise Frobenius 3-cycles them (they fuse to one
   PΓL₂ orbit), and their a₄ labels are a single Galois orbit {t, t², t⁴} = the roots of the field
   cubic. This is the redundancy-five shadow of C484's q = 8 colour C₃ = (0 4 1)(2 5 3): the same
   Galois group acting freely with information-lossy quotient, and — as in C484 — not a Gale/Hilbert-90
   obstruction.

5. **Verdict (§6): uniform structure, but sporadicity is a bounded-q arithmetic accident.** These
   configurations are not new all-q deep-hole families. The equianharmonic orbit persists as a
   PGL₂-orbit for **every** q ≡ 1 mod 3 (constructed at q = 25, 31, 37, 43, 49), but there it carries
   totally-split members and is **not deep**; it is deep only at q ∈ {7, 13, 19}. Every sporadic is the
   small-q tail of the generic S₃ stratum where Aubry–Perret's point count is too weak to force a
   split member (C491 Lemma 7). The structure is uniform; the deepness is the accident.

## 1. The cover and its branch divisor

For a syndrome f off C, L(f) = ker H(f) is a pencil of binary cubics (C491 Lemma 2). The incidence
curve X = {(s,t): C_s(t) = 0} ≅ P¹ carries the degree-3 morphism φ_f: X → P¹_λ to the pencil
parameter (C491 §4). Its branch divisor B ⊂ P¹_λ has degree 4 (Riemann–Hurwitz for a genus-0 degree-3
cover): it is exactly the zero divisor of the discriminant quartic Δ(λ) = disc_T C_λ, a binary quartic
in λ. Over F_q, a pencil member C_λ has factorization type equal to the Frobenius cycle type on the
fiber φ_f⁻¹(λ):

| member type | cycle type | meaning |
|---|---|---|
| `111` | id | totally split — a split squarefree member ⟹ **not deep** |
| `1.2` | transposition | one rational root + conjugate pair |
| `3` | 3-cycle | irreducible (inert) fiber |
| `1^2.1` | simple branch | a rational branch point (double root) |
| `1^3` | total ramification | a rational cusp of φ_f (f ∈ Osc(t)) |

Deepness ⟺ no `111` member (C491 Lemma 3). The **branch-divisor Frobenius type** — the partition of
B into Frobenius orbits, read off as the multiset of rational branch points (`1^2.1`), rational
cusps (`1^3`), and the degrees of the irreducible factors of Δ carrying the rest — is a PΓL₂ invariant
and is the organizing invariant for the whole sporadic list.

## 2. The equianharmonic/A₄ theorem

**Theorem C499.1.** The three sporadic orbits with |Stab| = 12 — at q = 7, 13, 19 (sizes 28, 182,
570) — are exactly the S₃-stratum pencils whose branch tetrad B is equianharmonic (j = 0). For each:

- B consists of four rational simple branch points whose cross-ratio μ satisfies μ² − μ + 1 = 0
  (μ = 5, 10, 12 at q = 7, 13, 19); equivalently the binary-quartic invariant I(Δ) = 0 (independent
  computation, agrees on all three);
- the PGL₂(q) point-stabilizer is A₄, certified by its projective-order multiset {1:1, 2:3, 3:8}
  (the unique order-12 subgroup of PGL₂ with 8 elements of order 3 and none of order 4 or 6);
- the pencil has exactly 4 double-root members (`1^2.1`) and exactly 4 irreducible members (`3`),
  the remaining q − 7 members being type `1.2`.

The order-3 element of A₄ is the tetrahedral rotation of the equianharmonic B; it is F_q-rational iff
a primitive cube root of unity is (iff q ≡ 1 mod 3), which is why the enhancement A₄ ⊃ V₄ occurs at
exactly the sporadic fields q ≡ 1 mod 3. This is structurally the same rational-order-3 dichotomy that
gives C491's O⁺ (q ≡ 2 mod 3) vs O⁻ (q ≡ 1 mod 3) families, one octave down in the cover degree.

## 3. Full classification of sporadic normal forms

Every sporadic orbit at q ∈ {7,8,9,11,13,17,19} is one of five branch-type normal forms
(certified for all orbits; "dbl/irr" = number of `1^2.1`/`3` members; stabilizer under PGL₂):

| # | branch-divisor Frobenius type | dbl | irr | stab | j / refinement | orbits |
|---|---|---|---|---|---|---|
| I  | `1+1+1+1`, equianharmonic (I(Δ)=0) | 4 | 4 | **A₄** | j = 0, q ≡ 1 mod 3 | q=7(28), 13(182), 19(570) |
| II | `1+1+1+1`, non-equianharmonic       | 4 | 4 | **V₄** | j ≠ 0 (q=11: harmonic j=1728) | q=9(180), 11(330), 13(546), 17(1224) |
| III| `1+1+2` (2 rational + conjugate pair)| 2 | 2 | **C₂** | — | q=7(168×2), 8(252×3), 9(360×2), 11(660) |
| IV | `2+1+1` (2 rational + total-ram cusp)| 2 | 2 | **C₂** | one `1^3` member | q=7(168, one orbit) |
| V  | `1+3` (1 rational + conjugate triple)| 1 | 1 | **C₃** | — | q=7(112) |

Reading: types I–II are the "4+4" pencils (four rational branch points), split by j-invariant into the
A₄ (equianharmonic) and V₄ (generic/harmonic) cases. Types III–IV–V are the pencils whose branch
tetrad is only partially rational — the stabilizer drops to the residual branch symmetry (C₂ for a
pair, C₃ for a Frobenius-triple). Type IV is the degenerate limit of III where one branch pair
collides into a total-ramification cusp (`1^3`). The member profile is forced by the type together
with deepness (`111` = 0): dbl = #rational branch, irr fixed by the type, `1.2` = the remainder.

## 4. The member profile is the stabilizer-orbit decomposition of the pencil line

The syndrome stabilizer acts on the pencil line P¹_λ preserving member factorization type, and this
action is the whole story of the "4+4" profile.

**Theorem C499.2 (certified for every type-I/II orbit).** Member factorization type is **constant on
each stabilizer-orbit of P¹_λ**, and the q+1 members decompose accordingly:

- the four double-root (branch) members are exactly **one** distinguished size-4 stabilizer-orbit;
- the four irreducible members are exactly **another** size-4 stabilizer-orbit;
- every remaining member has type `1.2`, filling out the other stabilizer-orbits.

For A₄ (types at q ≡ 1 mod 3) the two size-4 orbits are the **two dual equianharmonic tetrahedra**
of A₄ ⊂ PGL₂ (each has point-stabilizer C₃, so each is automatically equianharmonic — certified j = 0
for both the branch and the inert tetrad); the cover φ_f ramifies over one and is inert over the
other. The rest of P¹ is then dictated by pure q mod 12 arithmetic — which exceptional A₄-orbits are
F_q-rational:

| q | q+1 | stabilizer-orbit decomposition of P¹_λ (size, type) |
|---|---|---|
| 7  | 8  | (4,`1^2.1`) + (4,`3`) — P¹ is exactly the two tetrahedra |
| 13 | 14 | (4,`1^2.1`) + (4,`3`) + (6,`1.2`) — the octahedral 6-orbit becomes rational |
| 19 | 20 | (4,`1^2.1`) + (4,`3`) + (12,`1.2`) — one free A₄-orbit |

For V₄ the branch and inert tetrads are two of its orbits and the `1.2` members are its remaining
size-4 (free) and size-2 (involution fixed-point) orbits. Hence the constancy of the counts (4 and 4,
independent of q) is forced — they are the two special small stabilizer-orbits — and n_{1.2} = q − 7
is just the remainder of P¹; nothing here is a field coincidence.

## 5. The q = 8 Frobenius torsor and C484

The three size-252 sporadic orbits at q = 8 (reps [0,1,1,0,a₄], a₄ ∈ {t, t², t⁴}) satisfy:

- coordinatewise Frobenius maps them in a single 3-cycle (rep-index cycle 578 → 580 → 582 → 578),
  so PΓL₂ fuses the three into one orbit;
- their a₄ labels {t, t², t⁴} are one Galois orbit — the roots of the field cubic x³ + x + 1
  (modulus t³ = t + 1) — with Frobenius t ↦ t² ↦ t² + t ↦ t.

Hence the three orbits are a **free (regular) Gal(F₈/F₂) ≅ C₃ torsor** on the cubic-twist parameter
a₄, with trivial stabilizer and information-lossy quotient (PΓL fusion forgets which of the three).
This is the redundancy-five counterpart of C484's redundancy-three q = 8 colour Frobenius
C₃ = (0 4 1)(2 5 3): the same Galois group Gal(F₈/F₂), the same free C₃ acting through coordinatewise
Frobenius, the same information-loss on the quotient, and — as C484 proved for the colour C₃ — this is
**not** a Gale/Hilbert-90 sheet obstruction. The parallel is structural (same torsor shape across two
different codes and dimensions), not an identification of the two objects; the modular/descent
machinery stays behind C478's Gram and Sylow gates.

## 6. Sporadicity verdict

There is a uniform description (branch-divisor Frobenius type + j-invariant + determined stabilizer,
§§2–5), but the sporadics are **not** new all-q deep-hole families. Continuation check
(`f = (0,1,0,0,c)`, c ∈ F_q; certified):

| q | q mod 3 | equianharmonic reps exist | deep | non-deep (carry split members) |
|---|---|---|---|---|
| 23 | 2 | no  | 0 | 0 |
| 25 | 1 | yes | 0 | 8  |
| 29 | 2 | no  | 0 | 0 |
| 31 | 1 | yes | 0 | 10 |
| 37 | 1 | yes | 0 | 12 |
| 43 | 1 | yes | 0 | 14 |
| 49 | 1 | yes | 0 | 16 |

(The non-deep equianharmonic count in the `(0,1,0,0,c)` scan is exactly (q−1)/3.)

The equianharmonic configuration persists as a PGL₂-orbit for every q ≡ 1 mod 3, but at q ≥ 25 every
such point already has totally-split members and is not a deep hole; it is deep only at q ∈ {7,13,19}.
(For q ≡ 2 mod 3 no rational equianharmonic tetrad exists at all: μ² − μ + 1 = 0 has no F_q root.)
The continuation above constructs the persistence explicitly only for the type-I (equianharmonic)
family. Types II–V are ordinary partially-rational-branch S₃ covers that exist at all q and lose
deepness once Y_f gains a rational split-member witness; their bounded-q deepness is not
independently re-constructed here but is exactly what C491 Lemma 7 proves (no S₃-stratum deep hole for
q ≥ 23). So each sporadic is the small-q tail of the generic S₃ stratum. The structure is uniform;
the deepness is a bounded-q arithmetic accident, not a perpetual family like O±/W. Both C491
discovery-track leads are hereby settled.

Framing (for the C500 write-up, not task-owned here): the branch/ramification j-invariant of the
Hankel pencil is a rational modulus on syndrome space that organizes the entire classification — T/S
are its degenerate boundary, O± are j = 0 realized in the cyclic (C₃-monodromy) stratum, and the
type-I sporadics are j = 0 realized in the S₃-monodromy stratum (same modulus, different deck group,
different stabilizer). Logged to the discovery track as a paper-structure lead.

## 7. Evidence

- `2026-07-22-c499-sporadic-pencil-structure.py` — reconstructs each sporadic pencil from its frozen
  representative; re-derives and asserts equality with the frozen member statistics; computes branch
  type, cross-ratio, and (odd char ≠ 3) the binary-quartic invariants I, J as an independent
  equianharmonic/harmonic cross-check; computes the PGL₂ stabilizer as an abstract group via
  projective Möbius orders; verifies the 4+4 single-orbit structure via the substitution action;
  derives the q = 8 torsor; and runs the equianharmonic persistence continuation. All 20+ assertions
  pass (`ALL C499 STRUCTURE CHECKS PASS`).
  Run: `python3 notes/2026-07-22-c499-sporadic-pencil-structure.py` (repo root; reads the JSON;
  writes the certificate; exit 0 iff all pass).
- `2026-07-22-c499-sporadic-pencil-structure.json` — certificate: per sporadic orbit the stabilizer
  group and order-multiset, branch type, member statistics, cross-ratio, invariants, and the three
  claim blocks (A₄, q = 8 torsor, persistence).
- Load-bearing frozen inputs (unchanged, hash-pinned by the C491 bundle):
  `2026-07-22-c491-prs-deep-hole-census.json` and `…-census.py`.
- Hashes: `2026-07-22-c499-sporadic-pencil-structure.sha256`.

Independence: the classification's structural invariants (branch type, cross-ratio, quartic I/J,
Möbius stabilizer, substitution action) are computed by methods disjoint from the census generator's
plane-marking/orbit-BFS, and every re-derived member statistic is checked against the frozen C491
certificate; the equianharmonic verdict is obtained two independent ways (cross-ratio and I(Δ)) which
agree on every rational-branch orbit. No new field census is performed.

## 8. Mystery ledger

Settled here:
- *Stab-12 pattern / "no linear×irreducible member" at q = 7,13,19* — Theorem C499.1: equianharmonic
  branch tetrad, stabilizer A₄. The "no `1.2` member" at q = 7 is now fully explained by Theorem
  C499.2: at q = 7, P¹ = the two tetrahedra exactly (q + 1 = 8), so there is no room for any `1.2`
  orbit; the `1.2` members appear at q = 13, 19 precisely as the octahedral 6-orbit and a free
  12-orbit become rational (q mod 12).
- *Constant "4 double + 4 irreducible"* — Theorem C499.2: member type is constant on each
  stabilizer-orbit of P¹, and the branch and inert members are the two distinguished size-4 orbits
  (for A₄, the two dual equianharmonic tetrahedra — both certified j = 0). The counts are forced, not
  a field coincidence.
- *q = 8 three-orbit fusion* — a free Gal(F₈/F₂) torsor on the a₄ cubic-twist parameter (§5).
- *Why sporadic and not a family* — bounded-q accident; the configurations persist but lose deepness
  for q ≥ 25 (§6).
- *q = 11 type-II orbit is harmonic (j = 1728, μ = −1), not generic* — the harmonic tetrad's full
  symmetry is D₄, but only its V₄ preserves the cover, so the stabilizer stays V₄ (no C₄/D₄
  enhancement); noted, no open gap.

No open mystery remains: every census number for the sporadic orbits is now either derived from the
branch-type normal form or is the equianharmonic/torsor structure certified above.

## Lifecycle

Acceptance vs the C499 queue row: equianharmonic/A₄-pencil hypothesis for the stab-12 orbits tested
and confirmed with an independent invariant cross-check; the q = 8 three-orbit Frobenius torsor
derived and related to C484's colour C₃; the remaining sporadics' pencil normal forms classified
(five types, §3); and the uniform-vs-accident question resolved as a hybrid — uniform structure,
bounded-q deepness — with a certified persistence continuation. Atomic evidence bundle with the frozen
inputs hash-pinned.
