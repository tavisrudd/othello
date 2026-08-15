# Cold read: the "why counting fails" paragraph and abstract (C913)

Date: 2026-08-14
Reviewer role: independent referee, cold read, no assumption that the claims are correct.

Targets:

- `papers/cubic-stabilization-irrationality/sections/01-introduction.tex`, lines 48–69,
  the paragraph beginning "Why it is not covered is concrete".
- `papers/cubic-stabilization-irrationality/cubic_stabilization_irrationality.tex`,
  abstract, lines 79–84 and 107–110.

Companion checked: `papers/cubic-stabilization-epilogue/sections/04-one-step.tex`
(and `01-introduction.tex`, `05-synthesis.tex`).

Summary of verdicts:

| Item | Verdict |
|------|---------|
| 1 codimension / dimension arithmetic          | CONFIRMED |
| 2 centre carries no primitive-sixth packet    | CONFIRMED (understates the work, does not overstate the claim) |
| 3 `P^{m+3}` contains `P^4` for `m >= 1`       | WRONG (off-by-one quantifier); the `Bl_X P^5` clause is correct |
| 4 rational side acquires packets; counting cannot separate | OVERSTATED |
| 5 additivity does not repair the argument     | OVERSTATED (conclusion right, "only mechanism" is not exact) |
| 6 Euler orthogonality with the point skyscraper | CONFIRMED |
| 7 same orthogonality recurs in three places   | CONFIRMED (same mechanism; unequal proof status, not flagged) |
| T2a "Detection, rather than multiplicity"     | CONFIRMED / one clause OVERSTATED (see item 4) |
| T2b "Given those maps the transport is linear algebra" | CONFIRMED (marginally generous) |

---

## TARGET 1

### Item 1 — codimension of a blowing-up centre. CONFIRMED

Text judged:

> "A blowing-up centre has codimension at least two, so in a fourfold it has dimension at
> most two"

Weak factorization (AKMW) decomposes a birational map between smooth complete varieties
into blowups and blowdowns along smooth centres of codimension at least two; the companion
states exactly this in the proof of `thm:nu6-birational-invariance`
(`sections/04-one-step.tex`, "blowups and blowdowns with smooth centers of codimension at
least two"). The codimension-at-least-two convention is also forced, not merely
conventional: blowing up a smooth Cartier divisor is an isomorphism, so a codimension-one
centre is not a nontrivial step. Arithmetic: `4 - 2 = 2`. Both halves check.

### Item 2 — "such a centre carries no primitive-sixth packet". CONFIRMED

Text judged:

> "such a centre carries no primitive-sixth packet, which is what makes the multiplicity of
> the packet birationally invariant through dimension four"

What the companion actually proves:

- `def:framed-sixth-multiplicity` sets `nu_6(T)` = sum of the algebraic multiplicities of
  `e^{i pi/3}` and `e^{-i pi/3}` in the framed formal monodromy of the small even quantum
  connection.
- `prop:low-dimensional-vanishing`: for `T` a point, a smooth projective curve, or a smooth
  projective surface, and for **every strictly Novikov-admissible specialization** `chi`,
  `nu_6(T; chi) = 0`.
- The paragraph after `def:strict-novikov-admissible` verifies that the centre
  specializations occurring in the blowup formula `(4.3)` are strictly admissible.
- `thm:nu6-birational-invariance`: `nu_6` is a birational invariant for smooth projective
  varieties of the same dimension at most four.

So the manuscript's clause is a correct paraphrase, and the attributed consequence
(birational invariance through dimension four) is verbatim the companion's theorem.

One thing the phrasing hides rather than exaggerates. "Carries no primitive-sixth packet"
reads as an intrinsic statement about the centre, but the load-bearing statement is about
the *specialized* centre summands: the centre Novikov map in `(4.3)` need not be injective
(the companion says so explicitly, citing `[IritaniBlowup, (5.15)]`), so intrinsic vanishing
alone would not give vanishing of the summand terms. That gap is closed by
`lem:divisor-tagging`, which propagates vanishing (and only vanishing) along a strictly
admissible specialization. The introduction does not need to say this, but note that the
one-directional character of `lem:divisor-tagging` is exactly what breaks items 4 and 5
below.

Not an overstatement. Verdict CONFIRMED.

### Item 3 — `P^{m+3}` contains `P^4` as soon as `m >= 1`. WRONG (off-by-one)

Text judged:

> "In dimension five, centres of dimension three appear, and \(\mathbf P^{m+3}\) contains
> \(\mathbf P^4\) as soon as \(m\geq1\), so a cubic threefold is itself an admissible centre
> inside projective space: \(\mathrm{Bl}_X\mathbf P^5\) is a blowing-up of a rational
> fivefold along a cubic threefold."

Three separate assertions, and the middle inference fails.

1. "In dimension five, centres of dimension three appear": correct. Codimension at least two
   in a fivefold gives dimension at most three, and dimension three is attained.
2. "`P^{m+3}` contains `P^4` as soon as `m >= 1`, so a cubic threefold is itself an
   admissible centre": the containment is correct (`m + 3 >= 4`), but the "so" does not
   follow at `m = 1`. In `P^4` a cubic threefold is a hypersurface — codimension one — hence
   not an admissible blowing-up centre; `Bl_X P^4` is isomorphic to `P^4`. Admissibility
   needs `codim(X, P^{m+3}) = (m+3) - 3 = m >= 2`. The correct threshold is `m >= 2`, which
   is also the threshold the manuscript itself uses two sentences earlier ("The case `m=2`
   is the first one not covered") and which the companion uses
   (`sections/05-synthesis.tex`: "For `X x P^m` with `m >= 2`, weak-factorization centers may
   have dimension at least three").
3. "`Bl_X P^5` is a blowing-up of a rational fivefold along a cubic threefold": correct.
   `X` sits in `P^4` inside `P^5` with codimension two, is smooth, and `P^5` is rational.

So the paragraph asserts a true statement (`m >= 1` gives the containment) and a true
conclusion (the `P^5` example), joined by a "so" that is false at the smallest value of the
quantifier it states. A cold reader who takes the sentence at face value concludes that a
cubic threefold is an admissible centre in `P^4`, which contradicts the previous sentence's
own dimension-four vanishing story. The fix is to write `m >= 2` (equivalently: `P^{m+3}`
contains `P^4` with `X` of codimension `m`, so `X` is an admissible centre as soon as
`m >= 2`).

### Item 4 — the rational side acquires packets; counting cannot separate. OVERSTATED

Text judged:

> "Over a common resolution of \(X\times\mathbf P^m\dashrightarrow\mathbf P^{m+3}\), the
> rational side can therefore acquire packets of the same type as the irrational side, and
> counting packets cannot separate the two endpoints."

Structure of the underlying computation. By the blowup formula `(4.3)`,

    nu_6(Bl_X P^5) = nu_6(P^5) + sum_{j=0}^{c-2} nu_6(X; chi_j)
                   = 0 + nu_6(X; chi_0)        (c = 2, so a single summand),

and `nu_6(X) = 2` by `prop:cubic-packet`. If `nu_6(X; chi_0)` is nonzero, then a variety
birational to `P^5` has a nonzero primitive-sixth packet, `nu_6` is not a birational
invariant in dimension five, and no count of packets at a single model can separate the
endpoints.

The gap: `nu_6(X; chi_0) != 0` is not established anywhere. `lem:divisor-tagging` is
explicitly one-directional — "If the intrinsic small even quantum connection of `T` has no
primitive-sixth framed monodromy, neither does its specialization along `chi`" — and the
converse is not proved; the companion notes that the centre Novikov map need not be
injective, which is precisely the reason a nonzero intrinsic invariant could in principle
die under specialization. So the state of the art is: the *input* that made the
dimension-four proof work is unavailable in dimension five, not that the count demonstrably
changes.

The first clause is hedged correctly ("can therefore acquire"). The second clause is not:
"counting packets cannot separate the two endpoints" is an unhedged assertion of definite
failure, and it requires the centre contribution to be nonzero. The paragraph never says
that the contribution is nonzero, so it does not assert a falsehood — but the reader is
handed a definite negative conclusion resting on a possibility. The companion is careful
here in a way the manuscript is not: `sections/05-synthesis.tex` says only "centers ... can
carry primitive-sixth quantum packets. The low-dimensional vanishing in
Proposition~\ref{prop:low-dimensional-vanishing} no longer *proves* noncancellation."

Suggested repair, which costs nothing: "counting packets is no longer known to separate the
two endpoints", or "the vanishing input that made the count birationally invariant is
unavailable". Verdict OVERSTATED.

Secondary observation, not a defect. "Over a common resolution of `X x P^m --> P^{m+3}`" is
counterfactual — such a resolution exists only if `X x P^m` is rational, which is what is
being disproved. That is the correct reading in a proof by contradiction, and the sentence
does not claim otherwise. Note also that `Bl_X P^5` is an *illustration* that an admissible
centre carrying the packet exists inside `P^5`; it is not shown to occur in any particular
factorization of `X x P^2 --> P^5`. The paragraph's "therefore" is doing slightly more work
than the example licenses, but the conclusion drawn (the vanishing input is unavailable) is
supported.

### Item 5 — additivity does not repair the argument. OVERSTATED

Text judged:

> "Requiring the centre contributions to add rather than to cancel does not repair this; it
> removes the only mechanism by which such contributions could have left a count unchanged."

The conclusion is right; the word "only" is not exact, and the framing is a little odd.

Why the conclusion is right. In `(4.3)` the centre terms are algebraic multiplicities, hence
nonnegative integers, and they add. Within a single blowup, therefore,
`nu_6(Bl_C T) = nu_6(T)` holds if and only if every centre term is zero. Additivity plus
nonnegativity makes any nonzero centre contribution *strictly* increase the count, so it
makes invariance harder, not easier. "Does not repair this" is correct.

Why "the only mechanism" is not exact. A birational map is compared through a zigzag of
blowups and blowdowns, or equivalently through a common resolution `W` dominating both
endpoints:

    nu_6(W) = nu_6(Y_-) + A = nu_6(Y_+) + B,    A, B >= 0.

Hence `nu_6(Y_-) - nu_6(Y_+) = B - A`. Additivity and nonnegativity do not prevent `A = B`
with both nonzero, so the two endpoint counts can still coincide while individual centre
contributions are nonzero. That is a second, surviving way in which "such contributions
could have left a count unchanged" — cancellation between the ascending and descending legs
rather than inside a single sum. It is not a *mechanism* in the sense of a theorem one could
invoke, so the sentence's practical force survives; but as written the claim of uniqueness
is too strong.

Is there any way additivity could rescue an invariance argument? Not for these endpoints,
and the report should say so plainly. Nonnegativity plus additivity does buy one real thing
that pure cancellation would not: a monotonicity relation, `nu_6(W) >= nu_6(Y_-)` and
`nu_6(W) >= nu_6(Y_+)` over any common resolution, and hence a well-defined
minimum-over-smooth-models invariant. But the inequalities point the same way on both sides
and give no contradiction (`nu_6(W) >= 2(m+1)` and `nu_6(W) >= 0` are jointly satisfiable),
and computing the minimum over models for `X x P^m` is the original problem restated. So
additivity supplies an inequality, not a separation. The manuscript's conclusion stands.

A wording note for a cold reader. "Requiring the centre contributions to add rather than to
cancel" reads as proposing a hypothetical extra assumption, but additivity with nonnegative
terms is already a theorem in the companion — `(4.3)` with `nu_6` defined as a sum of
algebraic multiplicities. The sentence appears to be answering the companion's phrase "no
longer proves noncancellation"; a reader who has not read the companion will not see what is
being rejected. Verdict OVERSTATED, on the uniqueness claim only.

### Item 6 — Euler orthogonality. CONFIRMED

Text judged:

> "a class supported on an exceptional locus pairs to zero with the skyscraper of a point of
> the common birational open"

Two independent reasons, both valid.

Direct: if `E` is (the class of) a complex supported on a closed subscheme `Z`, and `p` is a
point not in `Z`, then `RHom(E, O_p) = 0` because the supports are disjoint, so
`chi(E, O_p) = 0`. "A point of the common birational open" is exactly the hypothesis
`p not in Z` needed, and the manuscript states it.

Via the paper's own equation `(1)`, `[s_Y(E), s_Y(O_p)) = chi(E, O_p) = rk(E)`: a class
supported on a locus of positive codimension has rank zero, so the pairing vanishes. This
also confirms that the flat pairing in the manuscript is the Euler pairing, which is what
licenses the name "Euler orthogonality".

Verdict CONFIRMED. The statement is exactly right, including the placement of `p` in the
common open.

### Item 7 — the same orthogonality in three places. CONFIRMED

Text judged:

> "That single orthogonality recurs at the wall functors of
> Corollary~\ref{cor:simple-wall-rank}, in the residual summands of the toric calibration of
> Remark~\ref{rem:verification-status}, and in the mutation cone of
> Conjecture~\ref{conj:gamma-window}."

All three checked against the source.

`cor:simple-wall-rank` (`sections/03-simple-wall.tex`, proof): "A wall functor has image
supported on the exceptional locus. Pairing its Gamma class with the point class in the
common open gives zero Euler characteristic." Identical mechanism.

`rem:verification-status` (`sections/08-global-transport.tex`): "For a point in the common
open set, its skyscraper class lies in the ambient summand and its Euler row annihilates
every residual summand." Identical mechanism, applied to the residual `K`-groups of
Iritani's toric global Landau–Ginzburg decomposition. The citation is precise: the same
remark also contains a *different* argument, the Coates–Iritani–Jiang crepant-wall
calibration, which works by pairing-preservation of the continuation gauge plus the
Fourier–Mukai transform sending `O_p` to `O_{p'}` — not by orthogonality. The introduction
points only at "the residual summands", so it does not sweep that second argument in.

`conj:gamma-window` (`sections/08-global-transport.tex`): the conjecture asserts that "the
two boundary identifications of the window differ by a mutation whose cone is generated by
classes supported on the wall", and the sketch of implication reads "the skyscraper of a
point in the common open is unchanged by the mutation and Euler-orthogonal to
wall-supported objects", plus, at a zero mode, "wall-supported generation makes
`V_t(M_j)` Euler-orthogonal to the row-generated module". Identical mechanism.

So the sentence does not conflate distinct arguments: in all three places the content is
"pair a wall- or exceptional-supported class against the skyscraper of a common-open point
and get zero". Verdict CONFIRMED.

One reservation worth passing on, since it concerns how the sentence lands rather than
whether it is true. The three occurrences have sharply different proof status: the first is
a corollary conditional on `hyp:one-wall-sectorial`, the second is a verified calibration in
a linear toric model that the remark itself says does *not* verify marked threshold
compatibility for the projective cobordism used in the paper, and the third is a conjecture
new to the manuscript. "That single orthogonality recurs at ..." is a claim about the
mechanism and is accurate, but a cold reader can read the flat three-item list as putting
all three on the same footing. Consider a half-clause distinguishing them.

---

## TARGET 2 — the abstract

### T2a — "Detection, rather than multiplicity". CONFIRMED, with one clause OVERSTATED

Text judged:

> "Detection, rather than multiplicity, is what has to be transported. Through dimension four
> every blowing-up centre has dimension at most two and carries no primitive-sixth packet of
> its own, so weak factorization makes the number of copies birationally invariant; a
> companion paper settles \(m=1\) that way. From \(m=2\) a centre can be a threefold which
> carries the packet itself and the count can change, so the packet is marked here by
> ordinary rank instead."

Sentence by sentence.

"Detection, rather than multiplicity, is what has to be transported." Accurate as a
description of this manuscript's own strategy. `thm:birational-point-primary` transports a
Boolean — `rrow|_{P_lambda} != 0` on one side if and only if on the other — not a
multiplicity, and the endpoint contrast `(eq:intro-endpoint-contrast)` is stated in terms of
`b`, a zero-or-nonzero record. CONFIRMED.

"Through dimension four ... so weak factorization makes the number of copies birationally
invariant; a companion paper settles `m=1` that way." Matches the companion exactly:
`prop:low-dimensional-vanishing` plus `thm:nu6-birational-invariance`, with `nu_6(X) = 2`
(`prop:cubic-packet`) and `nu_6(X x P^1) = 2 nu_6(X) = 4` by the projective-bundle formula
`(4.2)`, against `nu_6(P^4) = 5 nu_6(pt) = 0`. CONFIRMED. Two small looseness notes: the
invariant is the multiplicity `nu_6`, which counts two per copy for a cubic threefold, so
"the number of copies" is a paraphrase rather than the quantity; and "every blowing-up centre
has dimension at most two" is true for the nontrivial (codimension at least two) centres that
weak factorization produces, which is the intended reading.

"From `m=2` a centre can be a threefold which carries the packet itself and the count can
change." First half CONFIRMED (a threefold centre is admissible in a fivefold, and
`nu_6(X) = 2` intrinsically). Second half OVERSTATED, for the reason given in item 4 above:
the change of count requires the *specialized* centre summand `nu_6(X; chi_0)` to be nonzero,
and `lem:divisor-tagging` propagates only vanishing, so no instance of a changed count is
established. The companion's own wording in `sections/05-synthesis.tex` stops at "the
low-dimensional vanishing ... no longer proves noncancellation", which is the safe form. The
abstract's "can change" is milder than the introduction's "counting packets cannot separate
the two endpoints", so if only one is fixed, fix the introduction.

"so the packet is marked here by ordinary rank instead" — accurate: the marking is the Gamma
point row, which by `(eq:intro-gamma-rank)` reads ordinary rank.

### T2b — "Given those maps the transport is linear algebra". CONFIRMED (marginally generous)

Text judged:

> "Given those maps the transport is linear algebra: polynomial functional calculus preserves
> primary projections, and Rees homogenization makes point-row nonvanishing on a
> formal-monodromy primary packet birationally invariant."

What the two cited results actually do, once the threshold maps are granted.

`lem:finite-threshold-gluing` assumes the adjacent tail modules carry the maps of
`hyp:marked-threshold-wall` and `hyp:marked-threshold-zero`, and concludes that the marked
boundary germs glue. Its proof is: glue by the strict horizontal isomorphism `Phi_j`;
"polynomial functional calculus in `(eq:marked-threshold-map)` identifies every primary
projection"; at a zero-mode threshold pass to reduced nearby cycles by the assumed strict
specialization isomorphism, apply `Phi_j`, and come back; finitely many thresholds give a
finite ordered composite; compatibility with Artin reduction makes the composites an inverse
system.

`thm:birational-point-primary` then adds: the displayed identity
`Phi_j(r_j^- e_lambda(T_j^-)) = r_j^+ e_lambda(T_j^+)`, `lem:cyclic-row-support` at the
endpoints (which is pure finite-dimensional linear algebra — a Bézout projector argument on a
Krylov span), and separatedness of the Artin inverse system so that a projected row is
nonzero exactly when it survives at some finite level.

That is a fair description of "linear algebra". Every step downstream of the assumed maps is
conjugation-invariance of a polynomial spectral projector, a Krylov-span argument, and a
finite composite. Not too strong.

Where it is marginally generous, in decreasing order of significance:

1. Separatedness of the Artin inverse system is a completeness argument, not linear algebra;
   the theorem's proof invokes it explicitly to move from "nonzero at some finite level" to
   "nonzero".
2. The finite-cyclic-packet setup that produces the finite coordinate space in the first
   place is not free: it uses formal quantum Kirwan surjectivity (proved by a Neumann-series
   right inverse), the Rees homogeneity identity `(eq:rees-homogeneity)`, and the observation
   that the target bulk point is formally parallel to the large-radius point so that the
   transport preserves the point row. The abstract does name "Rees homogenization" as the
   second half of the sentence, which covers this.
3. The zero-mode route runs through reduced nearby cycles and the strict specialization
   isomorphisms, which is more than linear algebra in content — but those are exactly the
   assumed maps, so "given those maps" absorbs it.

None of these is a misstatement; the sentence is scoped to the transport across thresholds,
and that transport really is elementary once the maps are handed over. Not too weak either:
the sentence does not claim the whole global argument is linear algebra, and the surrounding
abstract is explicit that the equivariant cobordism, rotation localization, and Woodward
clutching are where the work is. Verdict CONFIRMED.

---

## Recommended edits, in priority order

1. Item 3, `sections/01-introduction.tex` line 53: change `m\geq1` to `m\geq2`, or restate as
   "`X` has codimension `m` in `P^{m+3}`, so it is an admissible centre as soon as `m\geq2`".
   This is a definite off-by-one and contradicts the sentence before it.
2. Item 4, `sections/01-introduction.tex` lines 58–59: soften "counting packets cannot
   separate the two endpoints" to a statement about the missing input, since a definite
   failure needs the specialized centre contribution to be nonzero and `lem:divisor-tagging`
   gives only the vanishing direction.
3. Item 5, `sections/01-introduction.tex` lines 61–62: drop or qualify "the only mechanism";
   cancellation between the ascending and descending legs of a factorization survives
   additivity.
4. Item 7, `sections/01-introduction.tex` lines 66–69: optionally distinguish the proof
   status of the three occurrences (conditional corollary, toric calibration, conjecture).
5. Abstract line 84: "the count can change" carries the same defect as item 4, in milder
   form.
