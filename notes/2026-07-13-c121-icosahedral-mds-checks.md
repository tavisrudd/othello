[REPORTED 2026-07-13]

# C121 — icosahedral MDS structural checks (R1a / R1b / R2)

**Object**: q=11 non-GRS `[6,3,4]₁₁` MDS code, 6-arc columns from
`lean/RelativeConicArcs/Examples.lean:46` (`q11Witness`), conic `X*Z=Y²` parametrized by
`lean/RelativeConicArcs/Q11Residual.lean`'s `conicVec` (`t -> (1:t:t²)`, `t=∞ -> (0:0:1)`).

**Method**: PGL(2,11) (order 1320) acts on PG(2,11) preserving the conic via the symmetric-square
representation of `t -> (at+b)/(ct+d)`. Enumerated all 1320 elements (deduped from the 13200
`GL(2,11)` tuples by their induced permutation of the 12 conic-point indices), found the subgroup
stabilizing the witness 6-arc as a set, and checked its induced actions. Cross-validated the setup
by recomputing each witness point's polar line ∩ conic and confirming it reproduces
`witnessMissingEdge` from `Examples.lean` exactly: `(0,9),(3,4),(1,7),(6,10),(2,11),(5,8)` for
witness columns `0..5`.

Script: `/tmp/claude-1000/-home-tavis-src-othello-rust/32d73511-d33d-463f-906c-3d5b62f92839/scratchpad/c121_check.py`
(plain `python3`, stdlib only, modular arithmetic over `GF(11)`; no external deps needed).

## Commands + key output

```
$ python3 c121_check.py
PGL(2,11) enumerated: 1320 elements (expect 1320)
R1a: |Stab(6-arc)| in PGL(2,11) = 60 (expect 60)
R1a: |Stab(column 0)| = 10 (expect 10, D10)
R1b: orbit of ordered pair (0,1) under Stab(6-arc) has size 30 (expect 30 = 6*5 for 2-transitivity)
R1b: 2-transitive = True
R2: weight-3 leaders of conicVec(0) coset: count = 20 (expect 20 = C(6,3))
R2: leader supports = all 3-subsets? True
R2: orbit of one 3-subset under Stab(6-arc) has size 10 (expect 20)
R2: Stab(6-arc) transitive on 3-subsets of columns = False
R2 (extra): |{g in Stab(6-arc): g fixes conic point 0}| = 5
R2 (extra): |{g in Stab(6-arc): g fixes axis {0,9} setwise}| = 10 (cross-check vs column-0 stabilizer order 10)
R2 (extra): orbit of one 3-subset under Stab(conic pt 0) (order 5) has size 5
```

Follow-up (cycle-type census of the 60-element group acting on the 6 columns):

```
Counter({(1, 5): 24, (3, 3): 20, (1, 1, 2, 2): 15, (1, 1, 1, 1, 1, 1): 1})
```
i.e. `1` identity + `15` double-transpositions (order 2) + `20` 3-cycles (order 3) + `24` 5-cycles
(order 5) = 60. This is exactly the class structure of **A₅ in its exotic 2-transitive action on
6 points** (`PSL(2,5)` on `P¹(F₅)`), independently confirming the group identification, not just
its order.

Follow-up (orbit split of the 20 three-subsets, to characterize the R2 failure):

```
number of orbits: 2
orbit A (10): (0,1,2)(0,1,3)(0,2,4)(0,3,5)(0,4,5)(1,2,5)(1,3,4)(1,4,5)(2,3,4)(2,3,5)
orbit B (10): (0,1,4)(0,1,5)(0,2,3)(0,2,5)(0,3,4)(1,2,3)(1,2,4)(1,3,5)(2,4,5)(3,4,5)
is complement(orbit A) == orbit A? False
is complement(orbit A) == orbit B? True
```
Also checked the smaller point-stabilizer (order 10, the axis/column-0 stabilizer): its orbits on
the 20 subsets are 4 orbits of size 5, not fewer/larger.

## Verdicts

- **R1a — PASS.** `|Stab(6-arc)|` in `PGL(2,11)` = 60 exactly. Column-0 (equivalently the polar
  axis `{0,9}`) point-stabilizer = 10 = D₁₀. Cycle-type census independently confirms `A₅`
  (not just an order-60 coincidence).
- **R1b — PASS.** The induced action on the 6 arc columns is 2-transitive: the orbit of the
  ordered pair `(0,1)` under the 60-element group has size 30 = 6·5, i.e. every ordered pair of
  distinct columns is reachable from every other.
- **R2 — FAIL as stated.** The literal claim ("the 20 weight-3 leaders of the `conicVec(0)`
  deep-hole coset form a single orbit under the 60-element group") does not hold. The 20 leaders
  are confirmed to be exactly all `C(6,3)=20` column 3-subsets (matches Lean's
  `conicZero_weightThree_leader_count = 20`), but the 60-element arc stabilizer's induced action
  on those 20 subsets has **exactly two orbits of size 10**, and the two orbits are precisely
  **complementary pairs** (`S` and its complement `{0..5}∖S` always land in different orbits).
  Neither the order-10 axis-point-stabilizer (4 orbits of size 5) nor the order-5 stabilizer of
  the specific conic point 0 (orbit size 5) does better — no subgroup of the arc-stabilizer chain
  produces a single orbit of 20. This is a real structural fact (A₅ acting 2-transitively on 6
  points is not 3-homogeneous on 3-subsets; it splits 3-subsets into two size-10 orbits, a known
  feature of this exotic action), not a computational glitch — reproduced from two independent
  angles (direct subset-orbit enumeration, and the A₅ cycle-type census which is consistent with
  a non-3-homogeneous action).

**Action for the live docs**: the `R2` row in
`notes/handoffs/2026-07-13-clebsch-paper.md` should be corrected from "single orbit"
to "two complementary orbits of size 10 under the 60-element group" — the symmetry-reduction is
still real (store 2 reps instead of 20, not 1), just weaker than originally conjectured.

## What's cheap `decide`-grade Lean

All three checks are small finite-search facts over `GL(2,11)` / the existing witness data, in the
same style as `Examples.lean`'s existing `decide`-closed theorems (e.g.
`extension_independence_spectrum`, which already `decide`s over `Finset.powersetCard` on `Fin 12`
— a comparable or larger search space):

- **R1a.** Define `stabGL : Finset (Fin 11 × Fin 11 × Fin 11 × Fin 11)` filtering
  `{(a,b,c,d) : a*d - b*c ≠ 0}` by "the induced `sym2Matrix a b c d` maps `pointSet witnessVec` to
  itself as a `Finset`" (using `Matrix.mulVec` / the six witness rays, `rayEq`-normalized as
  already done elsewhere in `Q11Residual.lean`). Prove `stabGL.card = 60 * 10` (13200/1320 ratio
  from the scalar center) or dedupe first; either way this is a `decide` over `11^4 = 14641`
  tuples of tiny arithmetic — comparable cost to what's already discharged in this file.
- **R1b.** Once the induced permutation of `Fin 6` is extracted for each stabilizing tuple, `decide`
  that the image-orbit of `(0,1)` under that `Finset` has card 30. Cheap — the group is already
  small (60 elements) once R1a's Finset exists.
- **R2 (corrected).** `decide` that the arc-stabilizer's action on `(Finset.univ.powersetCard 3 :
  Finset (Finset (Fin 6)))` (20 elements) splits into exactly two orbits of size 10, and that they
  are related by `Finset.compl` — again cheap once the 60-element permutation group is a `Finset`.

The main one-time cost is plumbing the `sym2Matrix`/PGL(2,11) action into Lean as a computable
`Finset`-valued definition (mirroring `conicVec`/`witnessChordEdges`'s existing style); once that
exists, all three statements are `decide`-closed at the same scale as the file's current lemmas.
