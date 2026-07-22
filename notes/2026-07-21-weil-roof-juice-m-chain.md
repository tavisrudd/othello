# Weil-roof M-chain juice-mining — latent Galois/torsor structure

**Lane:** `crowns` (exploratory memo, not an evidence bundle; nothing committed on my authority)

**Date:** 2026-07-21

**Executor:** exploratory juice-mining sub-agent, Opus

Motivating example: [`2026-07-21-c443-torsor-hunch-check.md`](2026-07-21-c443-torsor-hunch-check.md)
(the four H3 companions carry a `Z/4` Galois-torsor structure; a "blocker" was unrecognized Galois
structure). This memo hunts the same species of latent structure across the M-chain reports
C440/C441/C442/C458/C444.

Legend for provenance: **[COMPUTED]** = my exact `F_q`/rational computation this session;
**[REPORT]** = prose/data already in the cited M-chain report; **[SPEC]** = my speculation.

Scratch (throwaway, exact `F_5`/`F_7` only, reuses C444's group construction verbatim):
`…/scratchpad/companion_bda.py`. Runs in <1 s under `uv run python3`.

---

## Candidates, ranked by (leverage × cheapness)

1. **Uniform companion-torsor law across H3/B3/A3 — TESTED, CONFIRMED, surfaces a new A3 obstruction.**
2. **First-surviving-moment scalar = reduced spin Kummer coordinate (uniform across H3/B3).**
3. **Two-sheet stabilizers meet in the point-stabilizer of the natural permutation action.**
4. **The pi/pibar degree-1 asymmetry is H3-only at the moment level; its B3/A3 analogue lives in the A3 companion torsor (candidate 1), not in the moments.**

---

## Candidate 1 — uniform companion-torsor law (TESTED)

### Hypothesis
C443 found: on the frozen golden `A5`, the unique `A5`-invariant polar matching has **four** size-10
companion orbits completing it to a one-factorization of `K_12`, and `Gal(Q(zeta5)/Q) = Z/4` acts on
them as a nontrivial torsor (`sigma` a 4-cycle, `kappa = sigma^2` two 2-cycles, no fixed companion) —
this *is* the M3 blocker [REPORT: C443, torsor memo]. **Hypothesis:** the same "companion family =
Galois torsor" structure is present in B3 and A3, was never enumerated (M4/C444 only reduced the
*antipodal matching*, never its companions), and its triviality/nontriviality is the case-by-case
descent obstruction.

### Test data (all frozen, reused verbatim)
Projective A-group and invariant antipodal matching for each case exactly as built by the C444
checker: `b3_spin_group(3)` → order-24 projective `S4` on `P^1(F_7)`; `a3_spin_model`'s
`f25_closure(...)` → order-24 projective `S4` on `P^1(F_5)`; antipodal matchings
`cube_antipodal_matching(rows, 3)` and `{0,inf}{1,4}{2,3}`. Companion = a group-orbit of perfect
matchings whose union with the fixed antipodal matching is a one-factorization of `K_{q+1}` (needs
`q` matchings total, so companion-orbit size `= q-1`). The count is a purely combinatorial invariant
of the permutation group, hence identical at char 0 and at the good-reduction prime (`q ∤ |A|`).
Galois generator applied as the coordinate relabelling it induces on the reduced points:
B3 `omega→omega^2` = point perm `(0)(4)(5)(inf)(3 6)(1 2)`; A3 `i→−i` = point perm `(0)(1)(4)(inf)(2 3)`.

### Verdict [COMPUTED]

| case | `K_{q+1}` | companion-orbit size | **# companions (one group)** | Galois gen action on companions | torsor | descends to Q? |
|:-----|:---------:|:--------------------:|:----------------------------:|:--------------------------------|:-------|:---------------|
| H3   | `K_12`    | 10 | **4** | `sigma` 4-cycle, `kappa` `(2,2)` [REPORT C443] | nontrivial `Z/4` | **NO** (= M3 blocker) |
| B3   | `K_8`     | 6  | **1** | fixed (`[0]`) | trivial | **YES** |
| A3   | `K_6`     | 4  | **2** | `i→−i` **swaps** them (`[1,0]`, no fixed) | nontrivial `Z/2` | **NO** |

Matching-orbit censuses (independent cross-check of the group action): B3 `{1:1, 3:4, 4:2, 6:4,
12:5}`; A3 `{1:1, 4:2, 6:1}`; each has exactly one fixed matching = the antipodal one, as required.

### What it means (sharp)
- **The M3 blocker is case H3 of a uniform law, and its severity varies by Coxeter case.** The
  companion family is a `Gal(K_vert/Q)`-set in every case; the "blocker" is exactly *nontrivial
  torsor / no rational companion*.
- **B3 has NO companion obstruction: its unique companion is forced-rational (descends).** [COMPUTED]
  B3's `Z/2` obstruction lives *only* in the antipodal matching's silver sheet split (`sqrt2=3` vs
  `sqrt2=4`, opposite `PSL_2(7)` fibres) [REPORT C444] — the group/form level — while the companion
  is single hence Galois-fixed. So an H3-style "which companion descends" question is vacuous for B3.
- **A3 carries a genuine, previously-unrecorded companion `Z/2`-torsor over `Z[i]`.** [COMPUTED]
  C444 reports A3 as "inert fusion, no sheet sign" — but that is a statement about the *antipodal
  matching* (its marker `{0,inf}{1,4}{2,3}` is `i→−i`-blind, both primes give it) [REPORT C444]. The
  *companions* are not blind: `i→−i` swaps the two with no fixed member, so each companion prefers one
  of the two `Z[i]`-primes above 5 (`i→2` vs `i→3`) — exactly the H3 "each companion hits one prime"
  pattern, one dimension down. The obstruction did **not** vanish in A3; it **moved** from the matching
  (which fuses) to the companion family (which splits over `Q(i)`).
- **This is the "bit-carrier dualizes" theme (C442 finding 3) made into a matching↔companion duality.**
  [REPORT C442 finding 3 flagged group-vs-form dualization for B3.] Extended: B3 puts the bit in the
  antipodal-matching sheet (companion trivial); A3 puts it in the companion (antipodal-matching
  trivial). H3 puts it in the companion at full `Z/4` strength.

### Suggestive (not a proven law) [SPEC]
The companion counts `4/1/2` are **not** `# primes above q in K_vert` (that would be `4/4/2`: 11
splits completely in `Q(zeta5)`, 7 splits completely in `Q(sqrt2,omega)`, 5 splits in `Q(i)`
[COMPUTED arithmetic]). B3 breaks any "count = #primes" reading — its companion is unique despite the
degree-4 field. The Galois **action** is the invariant that transfers cleanly, not the count.

### What it buys / where it feeds
- **C445 (M5 gluing):** the per-case companion torsor (H3 `Z/4` nontrivial, B3 trivial, A3 `Z/2`
  nontrivial) is exactly the data an integral gluing statement must reconcile; the matching↔companion
  duality tells M5 the bit-carrier is not uniform across cases.
- **New allocation candidate:** "A3 companion `Z/2`-torsor" is a bounded, exact, currently-unrecorded
  obstruction parallel to C443's H3 blocker; C444's M4 certificate does not cover it (M4 stopped at the
  antipodal matching). Worth a `C<id>` if the program wants the A3 descent boundary pinned the way
  C443 pinned H3. Cheap to promote (the test above is the certificate skeleton).
- **C459 (Q-forms descent):** B3's companion descending to `Q` is a positive descent datum in the
  silver case, adjacent to C459's six-arc `Q`-forms question.

---

## Candidate 2 — first-surviving-moment scalar is the reduced spin Kummer coordinate

### Hypothesis [SPEC → partially checkable]
C444 proved for B3: `mu_3(s) = 2s·mu_3(4)` in `F_7`, `s^2=2` — "the cubic sign is literally the
silver Kummer coordinate" [REPORT C444]. C458 records for H3: `mu_3` `D`-profiles
`base=[-6,0,12,-12]`, `jmate=[6,0,-12,12]=-base` [REPORT C458]. **Hypothesis:** both are one law —
the first surviving (cubic) moment's sheet dependence is multiplication by the reduced spin square
root (Kummer coordinate `sqrt(disc)`: `sqrt2` for B3, `sqrt5` for H3).

### Test data / verdict [COMPUTED, light]
H3: with `sqrt5_base=4`, `sqrt5_jmate=7=−4 (mod 11)`, ratio `−1`; profile ratio `jmate/base = −1`.
So `mu_3(jmate) = (sqrt5_jmate/sqrt5_base)·mu_3(base)` holds. This is consistent with "first moment ∝
reduced `sqrt(disc)`" but is only a **sign** check (`sqrt(disc)` and its conjugate differ by `−1`, and
`mu_3` flips sign), so it does not distinguish this law from the weaker "`mu_3` is golden-odd."
B3's `2s` is the sharper statement (a full scalar, `2·4=1`, `2·3=−1`), and it is already proven in
C444. **Verdict: consistent, low marginal content** — the unified phrasing is a presentational gem, not
a new fact. UNTESTABLE-WITHOUT-CONVENTION for A3 (A3 has no surviving sheet sign: its marker fuses, so
there is no second `mu_3` to compare — see candidate 1, where A3's bit is in the companion instead).

### What it buys
A one-sentence uniform statement for the Phase-3 paper ("the first surviving moment is the spin
Kummer coordinate") spanning H3 and B3. Feeds C444/C445 wording only; no new allocation.

---

## Candidate 3 — two sheet-stabilizers meet in the natural point-stabilizer

### Hypothesis [SPEC, readable from reports]
H3: `a5(8) ∩ a5(4) = A4` (order 12) [REPORT C458]. B3: `H_3 ∩ H_4 = S3` (order 6, "same subgroup type
as C414's B3 S3 seams") [REPORT C444]. A3: `S4 ∩ PSL_2(5) = A4` (order 12) [REPORT C444]. **Hypothesis:**
the two sheets' stabilizers always intersect in the stabilizer of one point of the group's natural
permutation action — `A4 ⊂ A5` on 5 letters, `S3 ⊂ S4` on 4 letters.

### Verdict [REPORT only, no new computation]
Holds for H3 (`A4`) and B3 (`S3`) as literal point-stabilizers of the natural degree-5 / degree-4
actions. A3's `A4` is `S4 ∩ PSL_2(5)` — the `PSL`-kernel of the determinant character, not a
two-sheet intersection (A3 has one sheet), so A3 fits the *subgroup* pattern (`A4 ⊂ S4`) but not the
*two-sheet* mechanism. **Medium confidence; needs the exact intersection recomputed to promote.** No
test run (report data suffices for the statement; a certificate would recompute the three
intersections). Feeds M5/C445 seam bookkeeping.

---

## Candidate 4 — the pi/pibar degree-1 asymmetry, and its true B3/A3 analogue

### Hypothesis (prompt item 3)
The torsor memo logged: the A5-fixed polar matching's degree-1 moment is **zero at pi** but
**support-9 at pibar** [REPORT C443 torsor H4] — a prime-preferring object. Do the M4 certificates
contain analogous objects preferring one prime?

### Verdict [REPORT + COMPUTED cross-read]
**At the moment level: NO.** C444's B3 lower moments `mu_1, mu_2` have support 0 at *both* sheets, and
A3's marker is `i→−i`-blind — the M4 certificates show no degree-1 prime asymmetry [REPORT C444]. The
H3 asymmetry is special to the four-companion structure.
**But the analogue exists one level up, and I found it (candidate 1):** the A3 *companions*
prime-prefer — companion `c_j` reduces at `i→2` vs `i→3` to swapped objects, so each prefers one
`Z[i]`-prime, the exact A3 image of "the H3 polar matching's degree-1 moment prefers pibar." The
prime-preferring object in A3 is the companion, not a moment. This folds into candidate 1 and needs no
separate allocation.

---

## Boundary
- All [COMPUTED] verdicts are exact `F_5`/`F_7` (and `F_25` via C444's field code) finite enumeration;
  no floating point, no new coordinates or conventions — the groups, antipodal matchings, and
  reductions are C444's frozen objects, reused verbatim through `import`.
- Companion **counts** are combinatorial invariants (char-independent under good reduction); the
  **torsor triviality** verdicts depend on the induced Galois relabelling, which I derived from the
  frozen C444 label tables (`omega→omega^2`, `i→−i`), not from a new convention.
- This memo proves no negative-nonexistence beyond the stated finite enumerations, and makes no
  novelty/priority claim (golden/silver reduction of Coxeter polytopes is classical; C377 audit
  boundary applies).
- Nothing here is committed or added to any queue/handoff. Promotion of the A3 companion torsor (the
  one genuinely new obstruction) to a `C<id>` is left to normal lane routing.
