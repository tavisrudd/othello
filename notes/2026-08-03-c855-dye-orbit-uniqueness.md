# C855 — orbit uniqueness in the equality case of Dye's Brianchon bound

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Task:** C855 — Paper I Lean referee-artifact remediation; the remaining clause of the two
declared Dye axioms in `lean/RelativeConicArcs/Q11DyeAxioms.lean`.
**Scope:** mathematics only. No Lean file was edited, no Lean build, generator, gate, or manifest
was run, and no manuscript was changed. The Lean sources were read read-only.

**Verdict: proved, for every field of odd characteristic, and strictly stronger than the axiom.**
The equality configurations form one projective orbit; they exist exactly when five is a square;
the normal form is a golden-ratio hexagon; and the projective stabilizer is the alternating group
of degree five, which was a separately cited Dye result.

## What was still open

The companion note `notes/2026-08-03-c855-structural-exclusions.md` proved Dye's Brianchon bound
`n₃ ≤ 10` structurally for every odd order, together with the equality structure: the concurrence
graph on the six one-factorizations of the complete graph on the six arc vertices is an equivalence
relation with at least one odd class, and `n₃ = 10` forces the class partition `5+1`, so the five
non-concurrent one-factors are exactly the members of one one-factorization. What that note did not
give — and what the second declared axiom `dye1991_equality_classification` asserts — is that the
equality configurations form a single projective orbit.

Note that the equality clause needs only the transitivity lemma, not Fano's axiom: among partitions
of six, `Σ C(aᵢ,2) = 10` has the unique solution `5+1` (the partition `6` gives fifteen and `4+2`
gives seven), so once the concurrence relation is known to be transitive, `n₃ = 10` forces the
`5+1` shape outright. Fano's axiom is needed for the bound, not for the classification.

## The system in triple-perspective coordinates

Fix the labelling of the arc so that the non-concurrent one-factorization is a chosen one, and pick
a hexagonal ordering `P₁,…,P₆` whose synthetic triangle lies inside the five-element concurrent
class. Concretely, taking the standard dictionary between the fifteen one-factors and the fifteen
pairs of one-factorizations, one such labelling makes the concurrent set

```
{12,34,56} {12,35,46} {13,25,46} {13,26,45} {14,23,56}
{14,25,36} {15,24,36} {15,26,34} {16,23,45} {16,24,35}
```

and the five non-concurrent one-factors

```
{12,36,45} {13,24,56} {14,26,35} {15,23,46} {16,25,34}
```

which is a one-factorization, as the equality structure requires.

Now normalize exactly as in the double-perspective lemma of the companion note. The one-factor
`{12,34,56}` is concurrent at a point `P` lying off the arc and off every side of the triangle
`P₁P₃P₅`, so we may take

```
P₁ = (1:0:0),  P₃ = (0:1:0),  P₅ = (0:0:1),  P = (1:1:1),
P₂ = (x:1:1),  P₄ = (1:y:1),  P₆ = (1:1:z).
```

Writing each remaining concurrence as the vanishing of the three-by-three determinant of the three
chord lines, the ten concurrence conditions are, in this order,

```
{12,34,56}  0                    (built into the normalization)
{12,35,46}  2 − y − z
{13,25,46}  xyz − x − z + 1
{13,26,45}  xyz − y − z + 1
{14,23,56}  x − y
{14,25,36}  xyz − 1
{15,24,36}  −(xyz − y − z + 1)
{15,26,34}  2 − x − z
{16,23,45}  −(xyz − 1)
{16,24,35}  −(xyz − x − z + 1)
```

and the five non-concurrence conditions are the non-vanishing of

```
{12,36,45}  y − z        {13,24,56}  2 − x − y     {14,26,35}  xyz − x − y + 1
{15,23,46}  −(xyz − x − y + 1)                     {16,25,34}  x − z
```

Only three of the ten equations are independent. Taking `xyz = 1` from `{14,25,36}`, the pair
`{13,25,46}` and `{16,24,35}` both collapse to `x + z = 2`, the pair `{13,26,45}` and `{15,24,36}`
both collapse to `y + z = 2`, and `{12,35,46}` repeats the latter. So the entire system is

```
x = y,      x + z = 2,      xyz = 1.
```

Substituting gives `x²(2 − x) = 1`, that is

```
x³ − 2x² + 1 = (x − 1)(x² − x − 1) = 0.
```

## The golden normal form

The root `x = 1` is degenerate: it puts `P₂` at the perspectivity centre `P`, hence on the chord
`P₃P₄`, so `P₂, P₃, P₄` would be collinear and the six points would not be an arc. It is also
excluded automatically by the surviving factor, since `x = 1` in `x² − x − 1 = 0` forces `−1 = 0`.
So

```
x = y = φ  with  φ² = φ + 1,      z = 2 − φ,
```

and the equality configuration is projectively

```
X_φ = { (1:0:0), (φ:1:1), (0:1:0), (1:φ:1), (0:0:1), (1:1:2−φ) },   φ² = φ + 1.
```

**Existence.** A root of `t² = t + 1` exists in `K` exactly when `5` is a square in `K`, since the
discriminant is five and the characteristic is odd. This reproduces, as a consequence rather than a
citation, Dye's existence condition that the characteristic is not two and five is a square, and it
explains the census in the companion note exactly: the partition `5+1` is realized at orders eleven
and nineteen, where five is a square, and not at seven, thirteen, seventeen, or twenty-three, where
it is not.

**The normal form is automatically an arc.** Reducing all twenty three-by-three determinants of
triples from `X_φ` modulo `x² − x − 1` leaves only the values `±1`, `±(x − 1)`, `±(x − 2)`, and `x`.
Each vanishing is impossible in the quotient: `x = 0` forces `−1 = 0`, `x = 1` forces `−1 = 0`, and
`x = 2` forces `1 = 0`. So no three of the six points are collinear over any field in which the
golden relation has a root, with no side condition on the order. The same reduction makes all five
non-concurrence determinants equal to `±2(x − 1)`, nonzero because the characteristic is odd and
`x ≠ 1`. Hence `X_φ` is a six-arc whose Brianchon count is exactly ten.

**Uniqueness up to the choice of root.** When five is a nonzero square there are two roots, `φ` and
`φ̄ = 1 − φ = −1/φ`. The two normal forms `X_φ` and `X_φ̄` are the *same* configuration relabelled.
Relabelling the arc by a permutation that preserves the concurrence pattern leaves the point set
untouched and only changes which hexagonal ordering is used for the normalization, so it carries a
solution to a solution. The four-cycle `(3 4 6 5)` on the arc labels preserves the pattern above and
sends the parameter `φ` to `φ̄`; renormalizing after that relabelling exhibits the explicit
projectivity

```
        ⎡ −1   1   0 ⎤
   G =  ⎢  0   φ̄   φ ⎥,        G · X_φ = X_φ̄  as point sets,
        ⎣  0   1   0 ⎦
```

whose entries lie in the prime field extended by `φ`. (`det G = φ − φ̄ = ±√5 ≠ 0` whenever five is a
nonzero square; in characteristic five the two roots coincide and there is only one normal form.)

**Theorem (equality classification, all odd characteristics).** Let `K` be a field of odd
characteristic and let `A` be a six-arc in the projective plane over `K` whose off-vertex
triple-chord concurrence count is ten. Then five is a square in `K` and `A` is projectively
equivalent to `X_φ`. Conversely `X_φ` is a six-arc of concurrence count ten whenever five is a
square. In particular the equality configurations form a single orbit of the projective linear
group, which is the second declared Dye axiom, specialized at order eleven to
`dye1991_equality_classification`.

## By-product: the stabilizer is the alternating group of degree five

Let `M` be the concurrence pattern above and `Stab(M) ≤ S₆` its setwise stabilizer, of order one
hundred twenty; under the outer automorphism it is the transitive copy of `S₅`, that is
`PGL₂(5)` acting on the six one-factorizations. For `σ ∈ Stab(M)`, relabelling `A` by `σ` and
renormalizing returns a parameter `p(σ) ∈ {φ, φ̄}`. Two relabellings return the same parameter
exactly when they differ by a permutation induced by a projectivity of `A`, so the fibres of `p` are
the cosets of the induced projective stabilizer `P ≤ Stab(M)`, and `P = p⁻¹(φ)`. The matrix `G`
above shows `p` is onto, so `P` has index two in `S₅` and is therefore the alternating group of
degree five. Under the outer automorphism `P` is `PSL₂(5)` acting on the six arc points as
`PSL₂(5)` acts on the projective line over the field of five elements. This is Dye's polarity and
stabilizer statement — item "Dye's results give projective uniqueness, the unique associated
polarity, and the alternating stabilizer" in the assertion inventory, previously carried as a full
external-transfer gap — obtained here as a corollary rather than a citation. The index-two count was
also confirmed directly: of the one hundred twenty pattern-preserving relabellings, exactly sixty
return each root.

## Verdict per clause

| clause | status |
|--------------------------------------------------------------|--------------------------------------------|
| `dye1991_brianchon_bound` (count at most ten)                  | proved, companion note, every odd order    |
| `dye1991_equality_classification` (one projective orbit)       | **proved here, every odd characteristic**  |
| existence condition (characteristic not two, five a square)    | proved here as a corollary, not cited      |
| the equality arc is an arc at all (no three collinear)         | proved here, unconditionally               |
| Dye's alternating-group stabilizer, previously cited only      | proved here as a corollary                 |
| Dye's unique associated polarity                               | proved below, every odd characteristic     |

With the polarity section below, every clause of the cited Dye package that Paper I actually
consumes is now proved rather than transferred.

## Formalization note

The proof is Lean-shaped. After the normalization, the whole argument is: ten explicit
three-by-three determinants in three variables, an algebraic reduction to `x = y`, `x + z = 2`,
`xyz = 1`, the factorization `(x − 1)(x² − x − 1)`, twenty determinant non-vanishings modulo
`x² − x − 1`, and one explicit three-by-three matrix `G`. Specialized to order eleven, where
`φ ∈ {4, 8}`, every one of these is a `decide`-scale computation over `ZMod 11`, so
`dye1991_equality_classification` is replaceable by a proof rather than by an audited import. The
normal form at order eleven was checked to be projectively equivalent to the development's own
`Examples.q11Witness` hexagon, so the replacement lands on exactly the object `IsClebschHexagon`
names.

## Computational corroboration (not the deliverable)

Two scripts, both `notes/`-tracked with the task prefix.

`notes/2026-08-03-c855-dye-orbit-solve.py` rebuilds the one-factor / one-factorization dictionary,
selects the `5+1` pattern, prints the ten concurrence determinants and the five non-concurrence
determinants displayed above, and then, over the field of eleven elements, computes the parameter
returned by each of the one hundred twenty pattern-preserving relabellings, reporting the sixty–sixty
split between the two golden roots.

```
uv run --with sympy python3 notes/2026-08-03-c855-dye-orbit-solve.py
```

`notes/2026-08-03-c855-dye-orbit-verify.py` builds `X_φ` for each root over a list of odd orders,
checks the arc property, recomputes the Brianchon count, tests projective equivalence of the two
roots' arcs, and at order eleven tests equivalence with the development's displayed witness.

```
python3 notes/2026-08-03-c855-dye-orbit-verify.py 5 7 11 13 17 19 23 29 31 41 59 61
```

Results: at orders seven, thirteen, seventeen, and twenty-three the script reports that five is a
non-square and no configuration exists; at orders eleven, nineteen, twenty-nine, thirty-one,
forty-one, fifty-nine, and sixty-one both roots give six-arcs of Brianchon count ten and the two are
projectively equivalent; at order five the two roots coincide at `x = 3` and give a single six-arc
of Brianchon count ten. Both order-eleven arcs are projectively equivalent to `Examples.q11Witness`.

## Mystery ledger

- *Why does the golden ratio appear at all?* Settled. The three surviving equations are
  `x = y`, `x + z = 2`, `xyz = 1`; eliminating gives `x²(2 − x) = 1`. The `2` is the trace of the
  double-perspective normalization and the `1` is the triple-perspective identity `xyz = 1` of the
  companion note, so the golden relation is exactly the collision of the perspectivity identity with
  the two collinearity coincidences. The five in "five is a square" is the discriminant of that
  collision, and it is the same five as in the alternating group of degree five, via
  `PSL₂(5)` acting on the six points — the configuration is the projective line over the field of
  five elements. Cross-lane note: the same golden relation `φ² = φ + 1` is the object of the
  `golden` lane; this is an independent geometric occurrence of it inside Paper I, worth a
  discovery-track line rather than scope expansion here.
- *Characteristic five.* Settled as a boundary case. There `5 = 0` is a square, the quadratic has the
  double root `x = 3`, and `X₃` is still a six-arc of concurrence count ten; at order five it is
  necessarily a conic, since a six-arc in a plane of order five has `q + 1` points. The cited form of
  Dye's theorem does not obviously cover this case, and the argument here does, so the Lean
  replacement is not narrower than the axiom it removes. Not a gap, but worth a manuscript remark.
- *Why is the projective stabilizer the alternating rather than the symmetric group of degree five?*
  Settled: precisely because the two golden roots are distinct, so the parameter map onto
  `{φ, φ̄}` is onto and the stabilizer is its index-two kernel. In characteristic five the two roots
  merge; whether the stabilizer there is correspondingly larger was not checked. Evidence gap: one
  short computation over the field of five elements; owning successor: none allocated, recorded as a
  descriptive question.
- *The associated polarity.* Settled: unique, explicit, nondegenerate in every odd characteristic,
  and pinned down by any two of the five triangles.
- *Why does the associated conic swallow the whole configuration at characteristics five and three?*
  Partly settled. The quadratic form takes values of norm `−5` at the six vertices and of norm `−9`
  at the ten Brianchon points, so the two degeneracies are forced by those two norms and nothing
  else. What is not explained is why the norms are exactly `−5` and `−9`, that is, why the vertex
  values are `√5` times units and the Brianchon values `3` times units. The `−5` is plainly the
  discriminant that already runs through the whole argument; the `3` is not accounted for. Evidence
  gap: no invariant-theoretic derivation attempted. Recorded as a descriptive question with no
  owning successor.
- *Why is the external/internal type of the vertices order-dependent while their being a single
  common type is not?* Open. The six vertex values are pairwise ratios of units of `ℤ[φ]`, which
  explains why the six always agree, and the same for the ten Brianchon points; but which of the two
  types occurs varies with the order in a pattern not identified here (external at orders eleven,
  thirty-one, forty-one, seventy-one; internal at nineteen, twenty-nine, fifty-nine, seventy-nine).
  Actionable consequence already taken: Paper I must tag Edge's reading to order eleven.

## The associated polarity

### What Paper I actually consumes

Two passages use the clause, and neither needs Dye's broadest synthetic form.

- The introduction, on the reconstruction chain: "The reconstructed conic then determines its
  polarity, and Dye's theorem identifies the stabilizer as `A₅`." The first half is the tautology
  that a nonsingular conic determines a polarity; the second half is the stabilizer corollary
  already proved above.
- The self-polar structure section and the surrounding hexagon discussion: "Edge's finite-plane
  construction and Dye's general-field synthetic theory exhibit five triangles on the six vertices,
  self-polar for `𝒞`. Their vertex-pair matchings partition the fifteen pairs into five perfect
  matchings of the complete graph on six vertices," together with the sentence "in the displayed
  coordinates the associated conic is `𝒞`."

So the operative content is: the five triangles cut out by the five *non-concurrent* one-factors are
self-polar for one and the same polarity, that polarity is unique, and at order eleven its conic is
the uncovered-locus conic `𝒞`. That is exactly the statement proved below. Note that the
"vertex-pair matchings partition the fifteen pairs" sentence is the equality structure already
proved above: the five non-concurrent one-factors are a one-factorization.

The triangle attached to a non-concurrent one-factor `{ab, cd, ef}` is the triangle whose three
*sides* are the chords `ab`, `cd`, `ef` and whose three vertices are their pairwise intersections;
the vertex opposite the side `ab` carries the label `{a,b}`, which is the vertex-pair labelling the
manuscript refers to. It is a genuine triangle precisely because the one-factor is non-concurrent.

### The polarity, explicitly

Work in the golden normal form and take the labelling used above, so the five non-concurrent
one-factors are `{12,36,45}`, `{13,24,56}`, `{14,26,35}`, `{15,23,46}`, `{16,25,34}`. A symmetric
matrix `S` makes the triangle with vertices `V₁,V₂,V₃` self-polar exactly when `Vᵢᵀ S Vⱼ = 0` for
`i ≠ j`, since then the polar `S Vᵢ` of each vertex is the line through the other two. The five
triangles therefore impose fifteen linear conditions on the six-dimensional space of symmetric
matrices.

**Theorem (unique associated polarity).** Over any field of odd characteristic containing a golden
root `φ`, the fifteen conditions have a one-dimensional solution space, spanned by

```
        ⎡ 2φ−1   −1     −φ   ⎤
   S =  ⎢  −1   2φ−1    −φ   ⎥,        det S = 4φ.
        ⎣  −φ    −φ    3φ+1  ⎦
```

Since `2` is invertible and `φ = 0` is impossible (it would force `0 = 1` in `φ² = φ + 1`), the
determinant is nonzero, so `S` is a nondegenerate polarity in every odd characteristic. Hence the
arc has exactly one associated polarity, and it is canonical: the five non-concurrent one-factors
are determined by the arc alone, so `S` is a projective invariant of the arc.

*Verification.* Both halves are identities in the ring `ℤ[x]/(x² − x − 1)`, computed exactly, so
they hold in every characteristic without a case split.

- *Existence.* All fifteen conditions `Vᵢᵀ S Vⱼ` reduce to zero in `ℤ[x]/(x² − x − 1)`.
- *Uniqueness.* The fifteen-by-six coefficient matrix has a five-by-five minor equal to
  `8·(13 − 8φ)`. The factor `13 − 8φ` has norm `13² + 13·(−8) − 8² = 1`, so it is a unit of `ℤ[φ]`,
  and `8` is a unit in odd characteristic. So the rank is at least five in every odd characteristic;
  since `S` is a nonzero solution the rank is exactly five and the solution space is the line
  through `S`. The minor already lives in the rows coming from the first two triangles alone, so
  **any two of the five triangles determine the polarity**, and the other three are then forced —
  which is the geometric content of the classical fact that two triangles in general position have a
  unique common self-polar conic.

### Consequences, and where Edge's reading is order-specific

Evaluating the quadratic form `Q(v) = vᵀ S v` on the configuration, again exactly in
`ℤ[x]/(x² − x − 1)`:

- The six vertices give the values `2φ−1` (four times), `3φ+1`, and `3φ−4`. Each has norm `−5`, so
  each is `√5` times a unit of `ℤ[φ]`. **The vertices lie off the associated conic exactly when the
  characteristic is not five.** This proves, uniformly, the assertion Paper I currently attributes
  to Dye's calculation for characteristic eleven ("the six vertices lie on no conic in
  characteristic eleven" is the stronger statement that no conic at all passes through them, which
  the development checks separately in the code section; what is proved here is the weaker and
  differently-used fact that they miss the *associated* conic). In characteristic five all six
  vertices lie on the conic — consistent with the earlier boundary observation that there the
  equality configuration degenerates to a conic.
- The ten Brianchon points give the values `3φ−3`, `6φ−9`, and `3φ`, each of norm `−9`, so each is
  `3` times a unit. **The Brianchon points lie off the associated conic exactly when the
  characteristic is not three.** Characteristic three is not vacuous here: `5 = 2 = −1` is a square
  in the field of nine elements, so the equality configuration exists in the plane of order nine,
  and there all ten Brianchon points lie on its associated conic.
- At order eleven the conic of `S` has twelve points and coincides, as a point set, with the
  uncovered locus `𝒰(A)`. This is the manuscript's "in the displayed coordinates the associated
  conic is `𝒞`". It is genuinely an order-eleven identification: the Brianchon-count identity gives
  `|𝒰(A)| = 22 − 10 = 12 = q + 1` only at `q = 11`, and at orders nineteen, twenty-nine, and
  thirty-one the uncovered locus has one hundred forty, four hundred eighty, and five hundred
  seventy-two points against a conic of twenty, thirty, and thirty-two.
- **Edge's external/internal reading does not generalize.** At every order the six vertices share a
  single conic type and the ten Brianchon points share a single conic type, but which type it is
  depends on the order. At order eleven the vertices are external and the Brianchon points internal,
  which is Edge's statement and the one Paper I quotes; at order nineteen it inverts, the vertices
  being internal and the Brianchon points external; at orders twenty-nine and fifty-nine both are
  internal; at orders thirty-one and sixty-one both are external. Paper I should therefore keep
  Edge's reading explicitly tagged to order eleven, which is how it is used, rather than as a
  property of the hexagon.

### Verdict on the polarity clause

**Proved, for every odd characteristic, in the form Paper I consumes.** The arc has exactly one
associated polarity, given by the displayed `S`; two of the five triangles already pin it down; the
polarity is nondegenerate with `det S = 4φ`; the vertices avoid its conic outside characteristic
five; and at order eleven its conic is exactly the uncovered locus `𝒞`. All of it is a
`decide`-scale computation over `ZMod 11` after specialization, so like the orbit clause it is
replaceable in Lean by proof rather than by an audited import.

### Replay

```
python3 notes/2026-08-03-c855-dye-polarity.py
```

`notes/2026-08-03-c855-dye-polarity.py` does all of the above in exact arithmetic in
`ℤ[x]/(x² − x − 1)`: it prints `S`, checks that all fifteen self-polarity conditions vanish
identically, prints `det S = 4x`, exhibits the unit-times-power-of-two five-by-five minor from the
first two triangles, evaluates the quadratic form at the vertices and Brianchon points, and at order
eleven checks that the conic of `S` equals the uncovered locus and recovers Edge's external and
internal readings by counting how often each polar line meets the conic.

## What this record does not establish

No Lean file was edited, no build, generator, gate, or manifest was run, and no manuscript text was
changed. The theorem is a paper-grade human proof and has not been formalized; the manuscript and
the Lean development still carry the two Dye axioms in their declared form.
