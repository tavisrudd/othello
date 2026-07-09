# On-conic child type-alignment test (the C36-style size-3 -> size-4 layer)

Date: 2026-07-09.

Purpose: test the explanation proposed for the on-conic point-mass finding
([`2026-07-09-witness-count-heuristic.md`](2026-07-09-witness-count-heuristic.md) §7;
[`2026-07-09-odd-plane-falsification-map.md`](2026-07-09-odd-plane-falsification-map.md) §6;
[`2026-07-09-falsification-map-review.md`](2026-07-09-falsification-map-review.md) "highest-value
next action"). The hypothesis: the P/N value of an on-conic size-4 child is a **function of the
stabilizer-orbit type of its 6-point conic-parameter configuration**, and that type is
**q-independent**. If true, the on-conic witness count becomes a computable invariant and the
uniform (ON) lower bound collapses to a finite-type problem.

**Verdict: FALSE.** The value is *not* a q-independent function of the type — for the stabilizer
refinement *or* the full-PGL grouping. The obstruction set is large (119 shared
rational configurations whose value is not q-constant) and perfectly systematic: a fixed rational
6-point configuration is **P except at the arc-depleted orders q ∈ {11, 17}, where it flips to N**.
The concentration (point mass) is real but is **q-driven (arc abundance), not type-driven**. The
finite-type collapse the reviewer hoped for does not exist.

**Correction after review (same day):** this report's original "UNPROVEN B3" framing for the
full-PGL grouping was too conservative.  Lemma I in
[`2026-07-07-onconic-intrusion-calculus.md`](2026-07-07-onconic-intrusion-calculus.md) already gives
the bridge: an on-conic state is determined by the unordered six played conic points, including the
two burned/pre-played points, and any conic-stabilizing projectivity transports the follower game.
The burned-pair stabilizer remains a useful finer diagnostic, but it is not the soundness boundary.
The Lean formalization is now queued as C53.  The negative cross-q conclusion below is unchanged.

## 1. The object and the two group choices

An on-conic escape of a size-3 residual class is a size-4 position with all four cells on the unique
conic through the projective 5-arc. Parametrize the conic by P¹(F_q) in the normalized hyperbola
gauge `(r−ρ)(c−A) = B` (recipe:
[`2026-07-07-conic-localization-onconic-escape.md`](2026-07-07-conic-localization-onconic-escape.md)
§1; `t = r − ρ`). The six points are

```text
{ inf, 0, t1, t2, t3, t4 }  ⊂  P¹(F_q)
```

`{0, inf}` = the two burned directions (asymptotes); `t1,t2,t3` = the selected S3 cells (all in
F_q^*); `t4` = the on-conic child (also in F_q^*). The child's value is the `X … val=P/N pos=on`
label in the feat census.

Two groups act on the parameter line:

- **Full PGL(2,q)** — order `q(q²−1)`. This is the correct fixed-q transport grouping by Lemma I:
  roles are *not* distinguished, and the value is a function of the abstract 6-set PGL orbit.
- **Burned-pair stabilizer** — the subgroup fixing `{0, inf}` setwise: `t ↦ a·t` and `t ↦ a/t`,
  order `2(q−1)`. This is a finer diagnostic/refinement: `{0,inf}` interchangeable,
  `{t1,t2,t3}` interchangeable, `t4` (child) distinguished.  It is no longer the required
  soundness fallback.

## 2. Method and the three type notions

Script: [`rust/scripts/onconic_child_type_alignment.py`](../rust/scripts/onconic_child_type_alignment.py)
(reuses the conic reconstruction / PGL machinery from
[`2026-07-07-pgl2-orbit-census.py`](2026-07-07-pgl2-orbit-census.py) and
[`2026-07-08-intrusion-census.py`](2026-07-08-intrusion-census.py)). Data: the on-disk feat full
censuses `notes/data/codex-feat{5,7,11,13,17,19}.out` (852 on-conic children over the six prime
q). Values are read directly from the `X … pos=on` lines — no re-solve.

Three ways to type a configuration were tried:

1. **Exact orbit** (per-q canonical form): lex-min image of the 6-set under all group maps —
   full-PGL and stabilizer. This is the *actual* orbit; used for the mandatory within-q gate.
2. **Character signatures** (q-independent, finite alphabet): the quadratic-character (Legendre)
   pattern of the burned-pair-anchored ratios `chi(t4/ti)`, `chi(ti/tj)` (stabilizer-invariant), and
   the cross-ratio quadratic-character multiset over the 15 four-subsets (PGL-invariant), role-tagged
   for the stabilizer. These are the "cross-ratio profile / quadratic-character pattern" candidates.
3. **Integral type** (q-independent, exact, collision-free): the 6-point config as a subset of
   P¹(Z∪∞). Because the S3 cells are the same across q and the hyperbola gauge is deterministic, the
   S3 parameters come out as the **same signed integers** at every q (e.g. cls0 = `{−4,−3,−2}` at all
   q); the child is the signed integer `t4`. Two children match iff their integer parameter data is
   identical — a q-independent identification needing **no rational reconstruction** (rational
   reconstruction is unreliable at these small q: distinct rationals of moderate height collide mod
   q, e.g. `8/5 ≡ 1/2 (mod 11)`). The integral type is a refinement of the stabilizer orbit whose
   canonical rational cross-ratios are literally identical across q, so any cross-q value split it
   exhibits is a true value split of *the same rational configuration* under **any** q-independent
   type notion (PGL or stabilizer).

## 3. Anchors and cross-checks (all pass)

- **On-conic P-count histogram matches the heuristic report byte-for-byte** (`ON P` column of
  [`2026-07-09-witness-count-heuristic.md`](2026-07-09-witness-count-heuristic.md) §4):

  ```text
  q= 5 {1:1}   q= 7 {3:3}   q=11 {2:2, 5:6}   q=13 {9:12}   q=17 {1:3, 3:18}   q=19 {15:27}
  ```

  (q=17 `onP` min 1; q=11 `onP` dips to 2 — both reproduced.)
- **Full-PGL exact-orbit bucket counts match C5/C15 exactly**
  ([`2026-07-07-codex-pgl2-orbit-check.md`](2026-07-07-codex-pgl2-orbit-check.md),
  [`2026-07-07-codex-pgl2-orbit-census-q11-19.md`](2026-07-07-codex-pgl2-orbit-census-q11-19.md)):
  `q11→4, q13→5, q17→10, q19→13`, zero mixed buckets.

## 4. Self-consistency gate (mandatory — run first, both groups)

Within a single q, every on-conic child of a given type must share its P/N value.

```text
EXACT-ORBIT self-consistency within q (game-symmetry gate)
  PGL  orbit : PASS   q5:1  q7:1  q11:4   q13:5   q17:10  q19:13   (matches C5/C15)
  STAB orbit : PASS   q5:1  q7:3  q11:16  q13:29  q17:72  q19:104
```

Both group choices PASS with **zero violations** — no within-q collision. (As expected the
stabilizer orbits are finer than the PGL orbits; both are value-constant.) No C5/C15-contradicting
within-q split was found.

The finite-alphabet **character signatures FAIL the within-q gate** — they are too coarse to be
valid types (a single character pattern carries both P and N children within one q, e.g. at q=17 the
stabilizer ratio pattern `SC=(−1,1,1), SS=(−1,−1,1)` holds 14 P and 82 N). So the "quadratic-character
pattern" / "cross-ratio character profile" candidates are **not** the type; the value is not a
function of any pure character invariant. This is consistent with session-8's dead end #3
(no quadratic-character law separates the on-conic value). The **integral type** is injective within
each q, so it is trivially within-q consistent and is a legitimate refinement of the passing orbits.

## 5. Cross-q alignment (the deliverable)

Grouping the 852 children by integral type: 614 distinct types, **169 appear at ≥2 q**. Of those:

```text
  aligned (value q-constant) :  50
  OBSTRUCTIONS (value NOT q-constant) : 119
```

**The obstruction set is systematic.** Every one of the 119 obstructions takes value **N at an
arc-depleted order and P at every non-depleted order**:

```text
  obstructions with the N at q=11 : 16
  obstructions with the N at q=17 : 105
  obstructions with an N at q=13 or q=19 : 0
```

Minimal witness (verified against the raw feat lines):

```text
  config { inf, 0, −4, −3, −2, 1 }   (S3=[(0,0),(1,1),(2,3)] = cls0, child param t4 = 1)
    q=11  cell (5,7)  : N        q=13  cell (5,11) : P
    q=17  cell (5,2)  : N        q=19  cell (5,4)  : P
```

Same rational configuration (identical integer parameter set, hence identical cross-ratios over Q,
hence the same PGL *and* stabilizer type under any q-independent identification), yet **N at q∈{11,17}
and P at q∈{13,19}**. A second witness in the same class: child `t4 = 2` is `P,P,N,P` across
`11,13,17,19`. The 50 "aligned" types are configs that happen to occur only at same-behaviour q
(e.g. `{3,4,5}` child 1 is N at both depleted q=11,17 and absent elsewhere — an aligned-N, not a
counterexample to the pattern).

## 6. Payoff / class-stability verdict

- **P/N is not a q-constant function of the type** — neither the sound stabilizer type nor the
  full-PGL bridge type. 298 of 852 on-conic children sit in an integral type whose value is
  inconsistent across q.
- **The concentration is real but is not explained by a q-independent type→value function.** The
  point-mass finding (dispersion ≤ 0.4) says the on-conic P-count is nearly a function of q; this
  test shows *why it is a function of `q` and not of type*: the value at a fixed rational
  configuration is `P` except at the arithmetically-unlucky arc-depleted orders (here q = 11, 17),
  where a macroscopic block of configurations flips to N simultaneously. That simultaneous flip is
  the concentration — all configs of a class share the same q-driven depletion — but it is the
  opposite of a q-independent invariant. There is **no finite type→value table** that reproduces the
  onP counts across q.
- **Consequence for the (ON) route.** The uniform (ON) lower bound does **not** reduce to a
  finite-type problem via this layer. The class-stability lemma the heuristic report points to
  ("on-conic P-count varies by ≤ C across classes at fixed q") may still hold *at fixed q* (it is a
  within-q statement and is untouched here), but it cannot be discharged by exhibiting a
  q-independent type dictionary — the dictionary does not exist. The correct object remains the
  q-dependent arc-depletion (which orders deplete, and by how much), exactly the number-theoretically
  irregular quantity the erratic-margin and witness-count notes already isolate.

## 7. Stabilizer-vs-PGL contrast

- **Within q**, both the full-PGL and the stabilizer grouping are value-constant on exact orbits
  (§4; PGL matches C5/C15).  After the review correction, this is expected for full PGL by the
  conic-projectivity bridge; it is still a useful regression test for the orbit reconstruction code.
- **Across q**, *neither* grouping yields value-constancy. The same PGL-rational-type and the same
  stabilizer-rational-type both flip N↔P between depleted and non-depleted q.  Thus the full-PGL
  bridge is a fixed-q compression only: it certifies one representative per orbit at a given q, but
  it does not let a solved q=17 bucket predict q=19 or q=23.  The stronger q-uniform finite-type
  reframing is closed **negative**.

## 8. Scope / gaps

- Covered: the six prime orders q ∈ {5, 7, 11, 13, 17, 19} (852 on-conic children, the full on-disk
  feat census). The value-splitting orders are 11 and 17; the rest are all-P on the conic.
- **q = 9 is a documented gap.** GF(9) is not a prime field: its conic parameters are GF(9) elements
  (the S3 "cells" are GF(9) indices, not integers), so the integer-based cross-q identification does
  not extend to it without a separate GF(9) reconstruction. q=9 is all-P on the conic, so it can only
  add aligned-P or new obstructions; it cannot overturn the negative verdict, which already stands on
  the q=11 vs q=13 and q=17 vs q=13/19 splits. q=23 is not part of this feat-layer cross-q corpus;
  C29 separately solved all 22 full-PGL q=23 buckets P.

## 9. Reproduce

```bash
python3 rust/scripts/onconic_child_type_alignment.py            # q = 5,7,11,13,17,19
python3 rust/scripts/onconic_child_type_alignment.py 11 13 17   # any subset
```

Prints: the anchor onP histogram, exact-orbit self-consistency (both groups, with the C5/C15 bucket
counts), the character-signature coarseness check, the integral-type within-q gate, and the full
cross-q obstruction/aligned tables.
