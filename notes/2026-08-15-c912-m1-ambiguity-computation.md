# C912 — the one-stabilization ambiguity is finite, and it is not a Stokes torsor

**Date:** 2026-08-15
**Lane:** `clebsch`
**Task:** C912 (analysis only; no manuscript edit, no change to Hypothesis 4.7H)
**Answers:** the first computation asked for in `2026-08-15-c912-successor-are-the-holes-one-hole.md`

The framing memo ends with one instruction: compute the one-stabilization
ambiguity before running any of its other tests, and decide whether it is finite
— plausibly of order two, hence killable by an orientation or parity argument of
the kind the numbered series already uses — or continuous, which would kill that
route. This report carries out that computation for `X x P^1`, `X` a smooth
cubic threefold.

## Verdicts

1. **Sheet layer: finite, of order exactly two, acting trivially.** The
   primitive-sixth count of `X x P^1` is carried by a single connected component
   of its spectral cover, whose two geometric points are exchanged by a Galois
   group of order two, and the count is invariant under that exchange. The
   memo's prediction is confirmed, and the group is not merely of order two by
   coincidence: it is `Gal(L_0(sqrt q_2)/L_0)`, and what kills it is rationality
   of the exponents, which is a parity argument in the memo's sense.
2. **Germ layer: no ambiguity at all.** Inside the formal bulk germ over the
   Novikov field the carrier eigenvalue cannot collide with any other, for a
   filtration reason rather than a genericity one, so the rigidity theorem of
   the frame-transport memo applies at every point of the germ and the count is
   constant there.
3. **Global layer: one explicit caustic, empty over the Novikov field.** The
   only place the carrier block can meet another sheet is `4 q_2 = 27 q_1`.
   That is not a point of the Novikov germ — it equates two distinct Novikov
   monomials — so it exists only after the Novikov parameters are specialized to
   numbers.
4. **The sharpened conjecture is falsified for this hole.** The memo conjectures
   that the invariant between the holes is the Stokes torsor. For the
   one-stabilization hole it is not, and cannot be: the primitive-sixth count is
   a formal invariant, so by Malgrange--Sibuya the Stokes torsor — here
   52-dimensional — acts on it trivially. The object that measures this
   ambiguity is the discriminant of the spectral cover and the fundamental
   groupoid of its complement.
5. **Consequently the one-stabilization case is not a localization of the
   Gamma-rank route.** That route's hypothesis is a statement about an integral
   local system surviving analytic comparison, which is Stokes-level; the
   one-stabilization obligation is Stokes-blind. Restricting the former to
   `X x P^1` therefore yields something strictly stronger than the four owed
   lemmas, which is the stated falsifier of prediction P2. The one-stabilization
   statement should be proved on its own terms and kept unconditional, not
   derived as a special case.

Nothing here removes Hypothesis 4.7H from the manuscript. What it does is
discharge one half of the base-point gap in Section 9 of the frame-transport
memo, for the atom that carries the count, and relocate the rest.

## 1. Spectral data of `X x P^1`

Two inputs, both external. First, the small even quantum cohomology of a smooth
degree-`d` hypersurface in `P^{n+1}` in Beauville's presentation,
`QH_even = L[x]/(x^{n+1} - d^d q_1 x^{d-1})` with `x = H star`; for `(n,d) =
(3,3)` this is `L[x]/(x^4 - 27 q_1 x^2)`. Its eigenvalue list `0, 0, +-3r` with
`r = (3q_1)^{1/2}` reproduces the manuscript's own `K_0` spectrum `0, 0, +-6r`
for `E star = 2H star`, which is the consistency check that pins the
normalization. Second, `QH_even(P^1) = L[y]/(y^2 - q_2)` with `y = h star`.

Small quantum cohomology of a product is the tensor product, the Euler field
adds, and the grading operator adds, so the small even quantum connection of
`X x P^1` is the external tensor product of the two factors' connections and
`U = E star = 2(x + y) star` on the eight-dimensional tensor product.

**Proposition 1 (sheets and blocks).** The characteristic polynomial of `U` is
`(4q_2 - lam^2)^2` times an irreducible quartic, so the sheets are `+-2s` with
multiplicity two each, `s = q_2^{1/2}`, together with the four simple sheets
`+-6r +- 2s`. At each of `+-2s` the block is a single Jordan block of rank two
with nonzero nilpotent part.

Verified in `2026-08-15-c912-xp1-spectral-check.py`, items 1 and 2. This is what
the standing hypothesis (H1) of the frame-transport memo requires, and it also
identifies the two doubled blocks structurally: the block at `+-2s` is the
cubic's zero block tensored with a one-dimensional eigenline of `P^1`.

**Proposition 2 (components of the spectral cover).** Over
`L_0 = C((q_1, q_2))` the algebra splits as exactly two connected components,

* `A_nilp = K_2[x]/(x^2)` with `K_2 = L_0(sqrt q_2)`, of rank four, whose
  reduced part is the single closed point `u^2 = 4 q_2` with residue field
  `K_2`, geometrically the two sheets `+-2s`;
* `A_reg = L_0(sqrt q_1, sqrt q_2)`, of rank four, the four simple sheets.

Both `x^2 - 27 q_1` and `y^2 - q_2` are irreducible over `L_0`, which is item 3
of the script. So the two rank-two Jordan blocks — the entire carrier of the
count — lie in **one** connected component, and the four simple sheets, which
carry nothing by the simple-block theorem, lie in the other.

## 2. The sheet layer: a Galois group of order two, acting trivially

An atom is an F-bundle modulo isomorphism *and* modulo change of base point
within a connected component of the spectral cover. By Proposition 2 the
component carrying the count has exactly two geometric points, so the sheet part
of that second equivalence is the deck group `Gal(K_2/L_0)`, of order two,
exchanging `+2s` and `-2s`.

**Proposition 3.** The primitive-sixth count of the block is `2` at both
geometric points, so the deck group acts trivially and the value set of this
atom over its component's geometric points is `{2}` per block, `4` in total.

Two independent proofs.

*Galois.* The connection is defined over the Novikov ring, hence over `L_0`, and
`L_0` contains `C`. The nontrivial element of `Gal(K_2/L_0)` therefore fixes `C`
pointwise, carries the block at `+2s` to the block at `-2s`, and carries the
exponents of the one to the exponents of the other. The exponents are `-1/6` and
`-5/6`, which are rational, hence fixed. So the two blocks have the same framed
formal monodromy eigenvalues and the same count.

*Künneth.* The block at `+-2s` is the cubic's zero block tensored with a
one-dimensional `P^1` eigenline. By the simple-block theorem of the
frame-transport memo a multiplicity-one block has trivial framed monodromy, with
no logarithm and no fractional power, so the tensor product's framed monodromy
is the cubic's. The cubic's zero block has count `2`, so each of the two blocks
has count `2`.

This is exactly the "killable by an orientation or parity argument" outcome the
memo predicted, and it settles the worry that the memo stated as the reason
comparing value sets does not rescue the argument: the class to be excluded was
one whose value set contains both `2` and `0`, and this atom's value set over
its component's geometric points does not.

## 3. The germ layer: the germ is caustic-free, for a filtration reason

The other half of base-point change is motion of the bulk parameter. Write
`B = L[[tau]]` for the formal even bulk germ at the large-radius point, as in the
frame-transport memo's rigidity section.

**Proposition 4.** At every point of `B` the carrier eigenvalue `2s` differs
from every other eigenvalue by a unit, so hypothesis (H1) holds throughout the
germ, the rigidity theorem applies, and the count is constantly `4` on `B`.

*Proof.* The differences at `tau = 0` are `4s`, `6r`, `6r - 4s` and `6r + 4s`,
all nonzero elements of the coefficient field, hence units. Under the divisor
equation a bulk divisor direction rescales `q_i` by `e^{t_i}` with `t_i` in the
positive filtration, so a collision at some point of the germ would force
`27 q_1 e^{t_1} = 4 q_2 e^{t_2}`, and comparing leading terms in the `tau`-adic
filtration gives `27 q_1 = 4 q_2`, an equality between two distinct monomials of
the Novikov ring. The non-divisor directions only add positive-filtration terms
to each eigenvalue and cannot cancel a unit. So no collision occurs, and the
rigidity theorem gives a `tau`-constant characteristic polynomial for the sheared
residue. ∎

The point worth keeping is that this is not a genericity argument. The collision
is excluded by the filtration, so it is excluded at *every* point of the germ at
once, including specialized bulk parameters, exactly as the rigidity corollary
needs.

## 4. The global layer: the caustic, computed

Outside the germ, base points of the carrier component can in principle be
joined only through loci where the hypotheses fail. There are two such loci and
the script computes both exactly (item 4).

* **`4 q_2 = 27 q_1`.** Here `+2s` collides with `6r - 2s`, and symmetrically
  `-2s` with `-6r + 2s`. This is the only place the carrier block meets another
  sheet. Crossing it, the carrier becomes a rank-three block and the rigidity
  theorem's hypotheses lapse.
* **`q_2 = 27 q_1`.** Here the two *simple* sheets `6r - 2s` and `-6r + 2s`
  collide, both at the value zero. This does not touch the carrier, but it
  creates a new coalesced block out of two blocks that carried nothing, so it is
  a place where the count could **rise** rather than fall. For the
  one-stabilization argument, which needs a lower bound, that is harmless; for
  the equality form of birational invariance of the count it is not, and it is
  logged as a new ledger item below.

Neither locus is a point of the Novikov germ, by the argument of Proposition 4.
They become genuine hypersurfaces only after the Novikov parameters are
specialized to numbers, and in the two-parameter divisor slice they are two
countable families of parallel lines, of complex codimension one, whose
complement is connected. So the global ambiguity is a crossing question at an
explicitly named divisor, not an unlocated obstruction.

## 5. Why this hole is not the Stokes torsor

The framing memo's sharpened conjecture is that the invariant between the holes
is the Stokes torsor: a formal decoration sees only the quotient, an integral or
Gamma decoration sees the total space, and each hole asserts that a marked
structure descends through the torsor or admits a section of it.

For this hole that is not the mechanism. The primitive-sixth count is read off
the framed *formal* monodromy, that is, off the Levelt--Turrittin formal type.
By Malgrange--Sibuya the analytic germs with a given formal type form a torsor
under the first cohomology of the Stokes sheaf, and every member of that torsor
has, by construction, the same formal type. So the Stokes torsor acts trivially
on the count, and no section of it is needed or useful.

The size of what is being discarded is worth recording. For `X x P^1` the
exponential factors are the six sheets with multiplicities `2, 2, 1, 1, 1, 1`,
all differences having a simple pole, so the irregularity of the endomorphism
bundle is `8^2 - (4 + 4 + 1 + 1 + 1 + 1) = 52`. A 52-dimensional torsor acts
trivially on the invariant. What does not act trivially is motion of the base
point across the discriminant of the spectral cover, and that is the object the
conjecture should have named for this route.

This is a genuine falsification of the conjecture in its sharpened form, not a
technicality: the Gamma-rank route's hole is Stokes-level because that
decoration is read from an integral local system, and the one-stabilization
route's hole is caustic-level because its decoration is formal. Two different
objects, so the holes are not one hole. The three-axis trade in the framing memo
survives — the formal decoration is cheap and blind, the integral one is
expensive and sighted — but its proposed common invariant does not.

## 6. What is closed and what is not

**Closed.** The sheet half of the atom base-point equivalence, for the atom of
`X x P^1` that carries the count, unconditionally and by a finite argument; and
the bulk half at every point of the formal germ, by the rigidity theorem plus
Proposition 4.

**Not closed.** Base points of the carrier component that are not germ-adjacent,
where the crossing question at `4 q_2 = 27 q_1` lives; and, independently, the
other side of the atom ledger, where what is needed is pointwise vanishing of
the count over the components of the atoms of varieties of dimension at most
two. The second is unaffected by anything here and remains the larger of the
two.

## 7. Effect on the framing memo's questions and predictions

* **Question 1, must the one-stabilization case be a localization of the general
  one?** The evidence now says no, for the Gamma-rank version of "general". The
  two holes are of different kinds, so the restriction is strictly stronger than
  the obligation, which is P2's falsifier. Note the scope: the manuscript's own
  Hypothesis 4.7H is a formal statement about a displaced parameter, so *it* is
  of the same kind as the one-stabilization obligation; the verdict separates the
  Gamma-rank and Serre routes from the manuscript's route, not the manuscript's
  route from itself.
* **P1, semisimple coalescence is not formally rigid.** Untested here, but now
  localized: for `X x P^1` the only venues for a coalescence outside the germ
  are the two divisors of Section 4, so P1's test has an address.
* **P3 and P4** are untouched.

## 8. Next, in order

1. Decide the crossing question at `4 q_2 = 27 q_1`. At that locus the carrier
   is a rank-three block with a known degeneration, and the finite computation
   is of the same shape as the rigidity section's: shear, check that no
   irregularity appears, and read the residue. This is the last piece of the
   one-stabilization base-point statement.
2. Pointwise vanishing over the components of atoms of surfaces, curves and
   points. This is where the ledger's other side is, and it is not helped by
   anything above.
3. Only then revisit the Serre decoration, which buys the base-point problem
   away by rigidity of representations of a proreductive group but imports the
   integral-structure definition the sources defer.

## Addendum: what the series' own toolkit suggests for the blocker

Read against `papers/summary/README.md`, the collection uses a small number of
mechanisms repeatedly, and four of them transfer directly to what is blocking
this task. They are listed in the order I would spend effort on them.

**1. Replace the equality by an exact identity with a pointwise nonnegative
remainder.** This is the collection's most reusable tool: the secant-defect
identity of *Arcs Complete Outside a Conic*, and the chord-defect identity of
Clebsch I, combine low moments into an identity whose remainder is pointwise
nonnegative, so that vanishing gives rigidity and the remainder itself gives
stability. Hypothesis 4.7H is stated as an equality, but the one-stabilization
theorem consumes only a lower bound, and the conservation accounting of the
framing memo already reads like a defect ledger with slack three. Making that
accounting an exact identity with a nonnegative defect term would change what
has to be proved from invariance to one-sidedness, and would deliver a
stability statement as a by-product. This is the highest-value reframing
available, because it attacks the hypothesis rather than the route to it.

**2. Find the low-order statistic that is the whole invariant.** Paper IV's
weighted pair concurrences and Paper III's aligned four-sets both replace a
complicated object by a low-order statistic that is nevertheless a complete
invariant. The same compression is already available here and has not been
exploited: self-adjointness of the Euler operator and anti-self-adjointness of
the grading operator force the block residue's trace to `-1` unconditionally,
so the entire obstruction is the single scalar `det R`, and the count is
nonzero exactly when `det R = 5/36`. The target is therefore a
pairing-theoretic formula for `det R` in Frobenius and Poincaré data, which are
parameter-independent structures. If such a formula exists, invariance is
automatic and no transport statement is needed at all.

**3. State the theorem relative to a marked datum and publish the ambiguity
ledger.** Papers I, III and V all reach their strongest form this way: Paper III
is explicitly relative to a marked bridge datum, Paper I recovers an unordered
orientation torsor, and Paper V computes the residual `C_2`-torsor between the
two cubics rather than making the passage canonical. The analogue here is to
state transport relative to a marked datum — a chosen sheet of the spectral
cover, equivalently a chosen square root of the Novikov variable — and to record
the residual ambiguity explicitly. Section 2 above supplies the first entry of
that ledger, and it is trivial. This is the fallback that would make the
one-stabilization statement unconditional at a marked level if the rest stalls.

**4. Compute the sharpness boundary, do not only prove the positive statement.**
Paper II pairs its classification with the `q - 2` nonmatching orbits that share
the same trade, and Clebsch I's companion pairs recognition with the proof that
`q = 11` is the only field order. The analogue is the caustic `4 q_2 = 27 q_1`
of Section 4: compute what happens there rather than only proving invariance
away from it. Either outcome is a result in the series' idiom — a sharpness
statement if the count moves, and the removal of the last crossing worry if it
does not.

**A recorded negative, so it is not re-entered.** The obvious way to get
discreteness of the exponent, and hence local constancy for free, is to argue
that the monodromy preserves an integral lattice, so its eigenvalues are
algebraic integers and, with a polarization, roots of unity. The naive form of
this fails: the eigenvalues of the topological monodromy are not those of the
formal monodromy once the Stokes matrices are nontrivial. In rank two with
exponential factors `e^{+-1/z}` and trivial formal monodromy, the Stokes
matrices `[[1,a],[0,1]]` and `[[1,0],[b,1]]` give topological monodromy of trace
`2 + ab`, not `2`. Discreteness therefore needs an integral structure on the
Stokes-graded block itself, which is exactly what the sources defer to
forthcoming work. That outcome is evidence *for* the framing memo's three-axis
trade at the level of decorations, even though Section 5 above refutes its
identification of this route's hole with the Stokes torsor.

**One lesson about the framing rather than the mathematics.** Paper V's
contribution was to retract a tempting literal identification of two cubics and
replace it with the exact relation between them. The framing memo's "the holes
are one hole" is the same kind of tempting identification, and Section 5 shows
it is false for this route. The Paper V template says what to do instead: state
the precise relation between the two holes — one is a discriminant-crossing
problem for a formal invariant, the other a section problem for an integral
one — and keep them separate in the ledger.

## Mystery ledger additions

| ID | Status | Discovery | Owner |
|---|---|---|---|
| C912-M19 | confirmed | The count of `X x P^1` is carried by one connected component of the spectral cover with two geometric points, exchanged by a Galois group of order two that fixes the exponents; the sheet-level base-point ambiguity is therefore finite and acts trivially. | This report, Propositions 2 and 3 |
| C912-M20 | confirmed | The carrier block can meet another sheet only at `4 q_2 = 27 q_1`, which equates two distinct Novikov monomials and so is absent from the formal germ; the germ is caustic-free for a filtration reason, not a genericity one. | This report, Propositions 4 and Section 4 |
| C912-M21 | open | At `q_2 = 27 q_1` two simple sheets coalesce at the value zero, so the count can *rise* there. Harmless for the lower bound the one-stabilization theorem needs; a genuine gap in the equality form of birational invariance of the count. | Section 4; owner is whichever successor states the invariance as an equality |
| C912-M22 | confirmed | The Stokes torsor of `X x P^1`'s small even connection is 52-dimensional and acts trivially on the count, because the count is a formal invariant. The one-stabilization hole is a discriminant-crossing problem, not a Stokes-section problem. | Section 5; falsifies the sharpened conjecture of the framing memo for this route |

## Replay

```sh
uv run --with sympy python notes/2026-08-15-c912-xp1-spectral-check.py
```

Script SHA-256
`20b937ccc9fdc20df3d3b4c2f47ee8895071420ea6c5acbf31f3f940e04e31a7`; recorded
output `2026-08-15-c912-xp1-spectral-check.out`, SHA-256
`58d347697b0f0610e32b6ef651f572535e900acd7d5cb3abfde8662f44f68c11`. The script
takes the Beauville presentation and the product formula as inputs and derives
the sheets, the Jordan types, the component decomposition and the caustic locus;
the eigenvalue list it produces agrees with the manuscript's independently
derived `K_0` spectrum, which is the cross-check on the normalization. No
independent replay of the two external inputs was run in this pass.
