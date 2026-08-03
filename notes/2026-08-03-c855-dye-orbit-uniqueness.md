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
| Dye's associated polarity as a separate object                 | **not addressed**; see below               |

The one piece of the cited Dye package not settled here is the *unique associated polarity* as an
object in its own right — the statement that the hexagon is self-polar for exactly one polarity, and
that the five non-concurrent one-factors are its five self-polar triangles. The stabilizer corollary
above makes this plausible and supplies the group, but the polarity itself was not constructed. It
is a short additional computation in the normal form `X_φ` and is the natural next step; nothing in
the present argument depends on it.

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
- *The associated polarity.* Open, and now the only unproved item of the cited Dye package. Stated
  as a clause above with its exact content; no argument attempted.

## What this record does not establish

No Lean file was edited, no build, generator, gate, or manifest was run, and no manuscript text was
changed. The theorem is a paper-grade human proof and has not been formalized; the manuscript and
the Lean development still carry the two Dye axioms in their declared form.
