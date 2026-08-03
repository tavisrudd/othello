# C855 — structural proofs for the classical external transfers of Paper I

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream), structural-mathematics stream of C855.
**Scope:** the classical external transfers listed in Part D of
`notes/2026-08-02-c855-paper-i-assertion-inventory.md` that the corollary
`cor:conic-filling-window`, the lemma `lem:q9-polarity`, and the weight-eight step of
`thm:q13-tangent-code` actually consume. For each: the exact clause the manuscript uses, a
paper-grade proof at that generality, the shape a formalization would take, and a verdict.

**Author policy honored:** human structural proof wherever possible; finite kernels only where
a structural proof is not available, and then with an explicit reduction and a minimal check.
No Lean source was read, edited, or built for this record.

Expert routing consulted: `notes/2026-07-07-named-expert-personas-context.md` selects
`papers/expert-profiles/04-clebsch-rigidity.md` for this paper directory. Its Van de
Voorde–Storme lens governs targets 2, 3 and 5, its De Beule–Lavrauw lens ("a small graph or
orbit invariant replacing the census") governs target 4, and its stated proof standard — the
headline recognition must be conceptual, data may certify a bounded classification but may not
hide which implication is mathematical — is the acceptance criterion used below.

Ambient conventions. `C` is a nonsingular conic in `PG(2,q)`; for `q` odd a point off `C` is
*external* if it lies on two tangents and *internal* if it lies on none, and a line is a
*secant*, *tangent* or *passant* according as it meets `C` in two, one or no points. Standard
incidence counts used repeatedly, all elementary: an external point lies on `(q-1)/2` passants
and `(q+1)/2` secants; an internal point lies on `(q+1)/2` passants and `(q+1)/2` secants; a
passant carries `(q+1)/2` internal and `(q+1)/2` external points; a secant carries `(q-1)/2`
internal and `(q-1)/2` external points besides its two conic points. `A` is a `k`-arc,
`U(A)` its uncovered locus (points off `A` on no chord of `A`), `m = k(k-1)/2` its chord count.

---

## Target 1 — Segre's lemma of tangents, in the form the weight-eight exclusion consumes

### What the manuscript uses

In the proof of `thm:q13-tangent-code` (companion, weight-eight case) the support of a
hypothetical weight-eight word is shown to be an eight-arc of internal points of the conic
`XZ - Y^2 = 0` in `PG(2,13)` all of whose joins are passant and whose passant pencils are
saturated. For an internal point `P` the manuscript sets

    T_P(X) = product over the secant lines through P of their linear forms,

and for a pairwise-passant triple `(P,Q,R)`

    h(P,Q,R) = T_P(Q) T_Q(R) T_R(P) / ( T_P(R) T_R(Q) T_Q(P) ),

then cites Ball–Lavrauw Lemma 27 for `h(P,Q,R) = 1` on every triple of the hypothetical
support. That single value is the whole consumption: the adjacency table, the five four-clique
rows and the local clique number five are all downstream of it. Nothing broader — no oval
theorem, no `q` odd hypothesis, no arcs of other sizes — is used.

### The proof

Two observations connect the manuscript's `T_P` to the classical lemma.

**Saturation identifies secants with arc-tangents.** Let `A` be the hypothetical eight-arc.
Each `P` in `A` lies on `14` lines; the seven joins to the other vertices are distinct
(arc) and passant, and `P` internal lies on exactly seven passants, so those seven joins
*are* the passant pencil at `P`. The remaining seven lines through `P` are exactly the seven
secants through `P`, and each of them meets `A` only in `P`. So the tangent lines of the arc
`A` at `P` are precisely the conic-secants through `P`, and `T_P` is the product of the
tangent forms of `A` at `P`. The tangent count is `t = q + 2 - k = 13 + 2 - 8 = 7`.

**Segre's lemma of tangents.** Let `A` be a `k`-arc in `PG(2,q)` with `k >= 3`, let
`x1,x2,x3` be three of its points, and put `t = q + 2 - k`. Choose coordinates with
`x1 = (1:0:0)`, `x2 = (0:1:0)`, `x3 = (0:0:1)`. The lines through `x1` other than `x1x2`
are `Y = mZ` with `m` in `GF(q)`, the value `m = 0` being `x1x3`; so the `q-1` lines through
`x1` other than `x1x2` and `x1x3` are indexed by `m` in `GF(q)^*`. Since `A` is an arc, the
`k-3` remaining points of `A` give `k-3` distinct such lines, with parameters
`gamma_j = x_{j1}/x_{j2}`, and the other `t = (q-1) - (k-3)` are the tangents at `x1`, with
parameters `m_1,...,m_t`. Wilson's theorem in `GF(q)`, that the product of all units is `-1`,
gives

    prod_i m_i * prod_j gamma_j = -1.

Repeating at `x2` (lines `Z = nX`, secant parameters `nu_j = x_{j2}/x_{j0}`) and at `x3`
(lines `X = rY`, secant parameters `rho_j = x_{j0}/x_{j1}`) and multiplying the three
identities, the secant parameters telescope,

    prod_j gamma_j nu_j rho_j = prod_j (x_{j1}/x_{j2})(x_{j2}/x_{j0})(x_{j0}/x_{j1}) = 1,

so that

    prod_i m_i * prod_i n_i * prod_i r_i = (-1)^3 / 1 = -1.

This is the lemma of tangents, proved from nothing but the arc property and the product of
the units of a finite field.

**From the lemma to `h = 1`.** With the same coordinates, `T_{x1} = prod_i (Y - m_i Z)`,
`T_{x2} = prod_i (Z - n_i X)`, `T_{x3} = prod_i (X - r_i Y)`. Evaluating,
`T_{x1}(x2) = T_{x2}(x3) = T_{x3}(x1) = 1`, while
`T_{x1}(x3) = (-1)^t prod m_i`, `T_{x2}(x1) = (-1)^t prod n_i`,
`T_{x3}(x2) = (-1)^t prod r_i`. Hence

    h(x1,x2,x3) = 1 / ( (-1)^{3t} prod m prod n prod r ) = 1 / ( (-1)^{3t} * (-1) )
               = (-1)^{3t+1}.

For `t = 7` this is `(-1)^{22} = 1`, which is the manuscript's value. (The general statement
is `h = (-1)^{t+1}`, since `(-1)^{3t} = (-1)^t`; the manuscript's `h = 1` is exactly the odd-`t`
case, and `t = 7` at `q = 13`, `k = 8`.)

**Well-definedness.** `h` does not depend on the scaling of the linear forms (each `T_P`
occurs once in the numerator and once in the denominator) nor on the coordinate
representatives chosen for the points (each point occurs once in the numerator and once in
the denominator, and `T_P` is homogeneous of degree `t`). Nor does the identity
`prod m prod n prod r = -1` depend on the residual diagonal-torus freedom in the coordinate
choice, since it is a product of ratios that is invariant under rescaling `X`, `Y`, `Z`.

### Formalization shape

Three separate pieces, none of them heavy:

1. `Finset.prod_univ_units_id_eq_neg_one` — already in the pinned Mathlib at
   `Mathlib/FieldTheory/Finite/Basic.lean:110`. This is the only library input.
2. A pencil-parametrization lemma: for a point `x1` of `PG(2,q)` and a line `L` not through it,
   the lines through `x1` other than one distinguished line are in bijection with `GF(q)`, with
   the `k-3` arc-secant parameters and the `t` tangent parameters partitioning `GF(q)^*`. This
   is where the arc hypothesis enters, and it is a `Finset` partition argument, not geometry.
3. The telescoping product and the evaluation table above, both pure algebra.

The manuscript-facing corollary should be stated as: *if `A` is a `k`-arc in `PG(2,q)` and
`x,y,z` are three of its points, then `h(x,y,z) = (-1)^{q+k+1}`*, with the `q = 13`, `k = 8`
specialization `h = 1` and the saturation lemma identifying `T_P` with the conic-secant
product proved separately. Splitting it this way keeps the geometry (saturation) out of the
algebra (the lemma).

### Verdict

**Proved.** A complete elementary structural proof at exactly the generality the paper uses,
with the only external input already present in Mathlib. This transfer should be removed from
the "must be imported or audited" list and moved to the ordinary formalization backlog. The
proof is also strictly more general than the citation needs, at no extra cost.

---

## Target 2 — the Hirschfeld nucleus theorem, in the form the even-order obstruction consumes

### What the manuscript uses

Inside `cor:conic-filling-window`: assume `|U(A)| = q + 1`, `q` even, and suppose `U(A)` is an
arc. Since it has `q+1` points it has a nucleus `N` not on `U(A)` through which every line is
tangent to `U(A)`; the manuscript cites Hirschfeld p. 177. It then argues that no chord of `A`
contains `N` (chords are disjoint from `U(A)`, but every line through `N` meets `U(A)`), that
`N` is not a vertex, and hence that `N` is uncovered, contradicting `N` not on `U(A)`.

So the consumed clause is exactly: *in `PG(2,q)` with `q` even, every `(q+1)`-arc `O` has a
nucleus, i.e. a point `N` off `O` lying on all `q+1` tangents of `O`.* No characterization of
ovals, no `q` odd Segre theorem, and no hyperoval theory is used.

### The proof

Let `O` be a `(q+1)`-arc in `PG(2,q)`, `q` even.

*Tangents.* For `P` in `O`, the `q` other points of `O` lie on `q` distinct lines through `P`
(no three collinear), so exactly one of the `q+1` lines through `P` misses `O` elsewhere.
`O` has exactly `q+1` tangents, one per point. Two distinct tangents meet off `O`, since a
tangent through a point of `O` is the tangent at that point and hence unique.

*Parity.* Let `N` be off `O` and let `t(N)` be the number of tangents through `N`, `s(N)` the
number of secants. The `q+1` lines through `N` partition `O`, so `2 s(N) + t(N) = q + 1`,
which is odd because `q` is even; hence `t(N)` is odd, in particular positive. Write
`t(N) = 2 a_N + 1` with `a_N >= 0`.

*Two counts.* There are `q^2` points off `O`. Each tangent has `q` points off `O`, so

    sum over N of t(N) = q(q+1),   hence   2 sum a_N + q^2 = q^2 + q,   so  sum a_N = q/2.

Each unordered pair of distinct tangents meets in exactly one point off `O`, so

    sum over N of C(t(N),2) = C(q+1,2) = q(q+1)/2.

Since `C(2a+1,2) = a(2a+1) = 2a^2 + a`, the second count reads
`2 sum a_N^2 + q/2 = q(q+1)/2`, that is `sum a_N^2 = q^2/4`.

*Conclusion.* With `a_N >= 0`, `sum a_N = q/2` and `sum a_N^2 = q^2/4` we get
`q^2/4 = sum a_N^2 <= (max a_N)(sum a_N) = (max a_N) q/2`, so `max a_N >= q/2`; and
`max a_N <= sum a_N = q/2`. Hence some `N_0` has `a_{N_0} = q/2`, i.e. `t(N_0) = q + 1`, and
every other point off `O` has `a_N = 0`, i.e. exactly one tangent. So all `q+1` tangents pass
through the single point `N_0`, which lies off `O`. That is the nucleus.

### Formalization shape

A pure double count over two finite index sets (points off `O`, tangent lines), with three
inputs: the tangent-at-each-point lemma for a `(q+1)`-arc, the line-partition identity
`2s + t = q + 1`, and `Finset.sum` manipulations. `q` even enters only through the parity of
`q+1`. The last step is the discrete Chebyshev/Cauchy step
`sum a^2 <= (max a)(sum a)`, available as a one-line `Finset.sum_le_card_nsmul`-style bound or
directly as `sum a_N^2 <= max * sum a_N` by termwise comparison. No conic theory, no
characteristic-two field lemmas, no polynomial method.

The application inside `cor:conic-filling-window` is then three lines: `N` on no chord because
every line through `N` meets `U(A)` while chords miss `U(A)`; `N` not a vertex because a
vertex lies on `k-1 >= 3` chords; hence `N` is an uncovered point, contradicting `N` off `U(A)`.

### Verdict

**Proved.** Complete, elementary, self-contained, and formalization-ready with no library
input beyond finite sums. Remove from the external-transfer list. Note the proved statement is
the full nucleus theorem for `(q+1)`-arcs in even order, not a weakened form, so the citation
to Hirschfeld can be kept as attribution rather than as a dependency.

---

## Target 3 — the Blokhuis–Brouwer–Szőnyi conic-complement bound and the upper window

### What the manuscript uses

In `cor:conic-filling-window`, after `q` has been forced odd and every chord passant, the
manuscript observes that the `m` chords cover the complement of the conic by passant lines and
invokes Blokhuis–Brouwer–Szőnyi Proposition 1.6 in the displayed form

    m >= 2q - 1 - (q+1)/2 = 3(q-1)/2,

which rearranges to the upper window bound `q <= (k(k-1)+3)/3`.

### First finding: the headline theorem does not need this bound

This is the most consequential observation in this record. For `k = 6` — the case that carries
`thm:why11`, `thm:rigidity` and the whole Paper I headline — the upper bound on `q` follows
without any covering theorem, from the six-point specialization already displayed in the same
corollary:

    c(A) = (q-6)(q-9),   0 <= c(A) <= 15.

The bound `c(A) <= 15` is elementary: `c(A) = n_3` counts off-arc points on three chords, and
three pairwise-disjoint chords of a six-arc form a perfect matching of `K_6`, three
concurrent chords determine that matching, and a matching determines at most one concurrence
point; `K_6` has `15` perfect matchings. Then `(q-6)(q-9) <= 15` already forces `q <= 11`,
since `q = 12` gives `18`. Together with the lower bound `q >= 2k-3 = 9` this leaves
`q` in `{9,10,11}`, and `10` is not a prime power — exactly the input `thm:why11` consumes.

So Blokhuis–Brouwer–Szőnyi is load-bearing only for (i) the *uniform* upper window
`q <= (k(k-1)+3)/3` stated for general `k`, and (ii) the `k = 8` window
`13 <= q <= 59/3` that fixes the search domain `{13,17,19}` in the small-`k` section of the
companion. Recommendation: restate `cor:conic-filling-window` so the general-`k` window and the
`k = 6` specialization have separate proofs, the latter citation-free. That takes the heaviest
remaining classical transfer off the critical path of the main theorem.

### Second finding: a clean structural reduction to Jamison's theorem

The bound as used is not a black box; it decomposes into a polarity translation plus one
classical affine result.

**Step 1 (dualize by the polarity).** The `m` chords are passant lines covering every point off
`C`: indeed the covered off-arc points are `q^2 - k` in number, the `k` vertices lie on chords,
and `|U(A)| = q+1` is the conic, so the union of the chords is exactly the `q^2`-point
complement of `C`. Let `S = { L^perp : L a chord }`. Each `L` is passant so each `L^perp` is
internal, and `|S| = m`. For a point `P` off `C`, `P` lies on some chord `L` if and only if
`L^perp` lies on `P^perp`; and as `P` runs over the points off `C`, `P^perp` runs over exactly
the secants (from external `P`) and the passants (from internal `P`). So:

> `S` is a set of `m` internal points meeting every secant and every passant of `C`.

**Step 2 (block the tangents cheaply).** Fix a point `R` of `C` and its tangent `L_R`. Pair up
the `q` conic points other than `R` into `(q-1)/2` pairs plus one leftover `R'` (possible since
`q` is odd). For each pair `{R_1,R_2}` take the pole of the secant `R_1R_2`, which is the
intersection of the tangents at `R_1` and `R_2` and hence blocks both; it lies off `L_R`
because a secant's pole lies on `L_R` only when the secant passes through `R`. For `R'` take
any point of the tangent `L_{R'}` other than `R'` and other than `L_{R'} ∩ L_R` (there are
`q-1 >= 2` choices). Call this set `E`; then `|E| = (q+1)/2`, `E` misses `L_R`, and `E` meets
every tangent except possibly `L_R`.

**Step 3 (Jamison).** `S` consists of internal points and `L_R` is a tangent, which carries no
internal point, so `S ∪ E` is disjoint from `L_R`. Every line of the affine plane
`AG(2,q) = PG(2,q) \ L_R` is a secant, a passant, or a tangent other than `L_R`, hence is met by
`S` or by `E`. So `S ∪ E` is an affine blocking set, and Jamison's theorem
(Jamison 1977, Brouwer–Schrijver 1978: a blocking set of `AG(2,q)` has at least `2q-1` points)
gives

    m + (q+1)/2 >= |S ∪ E| >= 2q - 1,   hence   m >= 3(q-1)/2.

This reproduces the manuscript's displayed arithmetic `2q - 1 - (q+1)/2` exactly, which is
strong evidence that it is the intended route through the cited proposition.

**Why no counting proof exists.** Naive double counting cannot reach `3(q-1)/2`. Covering the
`q(q+1)/2` external points by passants (each carrying `(q+1)/2` of them) gives only `m >= q`;
covering the internal points gives `m >= q(q-1)/(q+1)`, weaker; and the refined count of the
excess `|S ∩ ℓ| - 1` over all non-tangent lines through all external points collapses to an
identity, carrying no information. Cauchy–Schwarz on the chord-multiplicity distribution
yields an upper bound on `m`, not a lower one. The `3/2` constant is genuinely a
polynomial-method phenomenon, which is why the reduction lands on Jamison and not on a count.

### Formalization shape

`Step 1` is the polarity dictionary — the internal/external/secant/passant translation table
that the `RelativeConicArcs` conic layer needs anyway. `Step 2` is a finite construction with a
pairing argument. `Step 3` reduces to a single named theorem, Jamison's bound, for which the
modern proof is by the polynomial method: the Alon–Füredi theorem (hyperplanes covering all
points of a grid but one) applied to `AG(2,q)`, itself a Combinatorial-Nullstellensatz argument.
The pinned Mathlib **does** carry the Combinatorial Nullstellensatz, in
`Mathlib/Combinatorics/Nullstellensatz.lean`
(`combinatorial_nullstellensatz_exists_linearCombination`,
`combinatorial_nullstellensatz_exists_eval_nonzero`,
`eq_zero_of_eval_zero_at_prod_finset`), so the remaining work is Alon–Füredi plus the
blocking-set dual, not a from-scratch polynomial-method development.

### Verdict

**Promising with a named gap.** The transfer reduces, by a complete and short structural
argument, to exactly one classical theorem — Jamison's `2q-1` bound for affine blocking sets —
and the Mathlib prerequisite for the standard proof of that theorem is present. Plus the
independent and more important finding that the `k = 6` headline route does not need the bound
at all, and the `k = 8` route needs it only to trim the search domain. If Jamison is deferred,
the elementary substitute `m >= q + 1` (every internal point off `S` sees all `q+1` lines
through it blocked by distinct points of `S`) gives the weaker window `q <= k(k-1)/2 - 1`,
which is `q <= 14` at `k = 6` (harmless, since `c(A) <= 15` already gives `q <= 11`) and
`q <= 27` at `k = 8`, which would widen the companion's `k = 8` search domain from
`{13,17,19}` to `{13,17,19,23,25,27}`. That is a certificate-cost consequence, not a
mathematical blocker, and the decision belongs to whoever owns the small-`k` census.

---

## Target 4 — the `q = 9` Sylvester package of `lem:q9-polarity`

### What the manuscript uses

`lem:q9-polarity` asserts four things about the graph `Sigma` on the `36` internal points of a
nonsingular conic in `PG(2,9)` with `P ~ Q` iff `Q` lies on `P^perp`:

(a) the intersection array `{5,4,2;1,1,4}`;
(b) that `Sigma` is *the* Sylvester graph, citing Brouwer–Cohen–Neumaier for the identification
    and Jurišić–Vidali for uniqueness under that array;
(c) that for distinct internal `P,Q` the join `PQ` is passant iff `d(P,Q) = 2`;
(d) that the distance-two graph has clique number five, citing the Abiad–Jabal
    Ameli–Reijnders table value `eq_2 = 5`.

`thm:why11` consumes exactly one consequence: *there is no six-arc of internal points of the
conic in `PG(2,9)` whose fifteen joins are all passant.* Clause (c) converts the geometric
hypothesis into a distance-two condition and clause (d) then kills it.

### The honest split

**Clause (b) is not load-bearing and should be demoted to attribution.** Nothing downstream
uses that `Sigma` is the Sylvester graph, and in particular the Jurišić–Vidali uniqueness
theorem — the single heaviest citation in the lemma — is used only to *name* the graph. Neither
the name nor the uniqueness enters `thm:why11`. Removing it from the transfer ledger costs the
paper nothing and removes one substantial external dependency outright.

**Clause (c) has a complete short structural proof.** For distinct internal `P,Q` set
`R = P^perp ∩ Q^perp`, which is the pole of `PQ`. A common `Sigma`-neighbor of `P` and `Q` is an
internal point conjugate to both, hence lies on `P^perp ∩ Q^perp`, hence equals `R`; so
`P` and `Q` have at most one common neighbor, and they have one exactly when `R` is internal,
i.e. exactly when `PQ` is passant. It remains to know that `P ~ Q` and `d(P,Q) = 2` are
exclusive, i.e. that `Sigma` is triangle-free, which is the following clean fact:

> **No self-polar triangle of a conic in `PG(2,q)`, `q ≡ 1 (mod 4)`, has all three vertices
> internal.** Diagonalize the conic on the self-polar triangle as
> `alpha X^2 + beta Y^2 + gamma Z^2 = 0`. The vertex `(1:0:0)` is internal exactly when the
> restriction of the form to its polar line `X = 0` is anisotropic, i.e. when `-gamma/beta` is a
> nonsquare; similarly for the other two vertices with `-gamma/alpha` and `-beta/alpha`. The
> product of the three quantities is `-(gamma/alpha)^2`, a square when `-1` is a square, that is
> when `q ≡ 1 (mod 4)`. Three nonsquares have a nonsquare product, so all three vertices cannot
> be internal.

Since `9 ≡ 1 (mod 4)`, `Sigma` is triangle-free, `a_1 = 0`, and clause (c) follows. This also
gives, for free, the first half of the intersection array.

**Clause (a) splits.** The parts that follow structurally: `k = b_0 = 5`, because `P^perp` is a
passant and a passant carries `(q+1)/2 = 5` internal points; `c_1 = 1` by definition;
`a_1 = 0` and hence `b_1 = k - 1 - a_1 = 4` from the triangle-free fact above; and `c_2 = 1`
from the pole argument in clause (c). The parts that need a genuine local count at `q = 9` are
`a_2 = 2`, `b_2 = 2`, `c_3 = 4`, together with the diameter being three, i.e. the tail of the
array. So the array is three-quarters structural and one-quarter local.

**Clause (d) is where the real content sits, and it does not follow from spectra.** The array
gives the distance-two graph `Sigma_2` as `20`-regular on `36` vertices with eigenvalues
`20, 4^{(9)}, -1^{(16)}, -4^{(10)}` (from the standard sequence of `{5,4,2;1,1,4}`, whose graph
eigenvalues are `5, 2, -1, -3` with multiplicities `1, 16, 10, 9`). The Delsarte clique bound
for a relation of an association scheme gives `omega <= 1 - k/lambda_min = 1 + 20/4 = 6`, one
too many; the Hoffman ratio bound applied to the complement gives only `9`. So no eigenvalue
argument available to us closes the gap between six and five, and the ordinary Hoffman clique
bound `1 - k/lambda_min` is not valid for general graphs anyway (the complement of a
seven-cycle is a counterexample), so it cannot be strengthened by a softer route.

Nor does counting close it. Assume a six-arc `A` of internal points with all fifteen joins
passant at `q = 9`. Then each vertex's five joins exhaust its five-passant pencil, the
chord-defect identity forces `c(A) = (q-6)(q-9) = 0`, and the covering distribution is fully
determined: every off-conic non-vertex point lies on one or two chords, with `15` internal
points on one chord, `15` internal on two, `15` external on one and `30` external on two, and
no three chords concurrent. Every one of these counts is *consistent*; the incidence structure
between the six vertices, the fifteen chord-poles and the remaining internal points closes
into an identity with no residue. The obstruction is genuinely local, not enumerative.

### The minimal finite kernel, and its proved reduction

Two structural facts compress the search to a few cases. Both are proved, not searched.

1. *Transitivity.* The conic stabilizer in `PGL(3,9)` is the symmetric-square image of
   `PGL(2,9)`, of order `720`, and it is transitive on the `36` internal points with point
   stabilizer of order `20` (dihedral of order `2(q+1)`). So one vertex may be fixed.
2. *Pencil saturation.* An internal point lies on exactly `(q+1)/2 = 5` passants, and a vertex
   of the hypothetical six-arc has five distinct passant joins, so its passant pencil is
   exactly its chord pencil, and each of the five passants through the fixed vertex carries
   exactly one further vertex, chosen among the `4` other internal points on it.

Together these reduce the whole `q = 9` exclusion to `4^5 = 1024` candidate six-tuples, on
which the order-`20` stabilizer acts, leaving on the order of fifty inequivalent cases. The
bounded check `notes/2026-08-03-c855-q9-sylvester-kernel.py` confirms every step of this
reduction and finds that **none of the `1024` candidates is pairwise passant** — the reduction
is not merely small, it is empty at the first test.

For the graph statement `omega(Sigma_2) = 5` in its own right, the same group gives an even
smaller kernel: the point stabilizer has exactly two orbits, both of size ten, on the twenty
distance-two neighbors of a fixed vertex, so a maximum clique may be assumed to contain a fixed
vertex and one of two fixed neighbors; the common distance-two neighborhood of such a pair has
eleven vertices and its maximum clique has three vertices, giving `omega = 1 + 1 + 3 = 5`. Two
eleven-vertex clique computations, both small enough to display in a table in the manuscript,
replace the citation.

### A stronger true statement than the one cited

The bounded check also shows the manuscript is using a weaker fact than the truth: the maximum
**arc** of internal points with pairwise passant joins in `PG(2,9)` has **four** points, not
five. The clique number five of `Sigma_2` is attained only by non-arc configurations — for
instance the five internal points of a single passant line are pairwise passant-joined but
collinear. Since `thm:why11` needs only the arc statement, the cited clique value is two units
weaker than necessary. Stating the exclusion as "no five internal points of the `q = 9` conic
form an arc with all joins passant" makes the step more robust and drops the dependency on the
Abiad–Jabal Ameli–Reijnders table entirely.

### Verdict

**Irreducibly finite, with a minimal kernel specified — but with three of the four cited
clauses removed.** Clause (b), the Sylvester identification and its uniqueness theorem, is
not consumed and should be demoted to a remark. Clause (c) and three-quarters of clause (a)
have complete structural proofs given above. Clause (d), the only genuinely load-bearing part,
resists both spectral and counting arguments and reduces — by the transitivity and
pencil-saturation lemmas, both proved — to a check of `1024` six-tuples (about fifty up to the
stabilizer), or, for the pure graph statement, to two maximum-clique computations on
eleven-vertex graphs. That is the certificates-last-resort shape the policy asks for: a proved
reduction plus a kernel small enough to print.

---

## Target 5 — the Storme–Van Maldeghem and Blokhuis–Seress–Wilbrink citations

Both were cheap to settle, and both settle the same way: **neither citation is consumed as a
mathematical input.**

**Blokhuis–Seress–Wilbrink.** The main paper uses it once, to say that Edge's hexagon "is a
complete exterior set in the terminology of Blokhuis, Seress, and Wilbrink", and then
immediately notes that exteriority alone yields only `C(F_11) ⊆ U(A)`, with the arc hypothesis
doing the selecting and `prop:deep-holes-conic` proving equality. The mention of the Pasch
configuration in their `q = 11` list is an aside, disqualified in the same sentence by the
collinear-triple obstruction, which is the arc hypothesis and not their theorem. The companion
uses it once more, in the `k = 8` section, purely to name "a set whose pairwise joins are
passant" an exterior set; the actual `q = 13` exclusion there runs through the weight-eight
impossibility of `thm:q13-tangent-code`, not through their classification. So the transfer is
**terminological**, and the right remediation is to keep the citation as attribution for the
term "exterior set" and delete the row from the external-transfer ledger.

**Storme–Van Maldeghem.** Two uses. The identification of the displayed hexagon with their arc
`K_2` (Propositions 11–12) is a cross-reference to the classification literature and carries no
inference. The second use, "Storme and Van Maldeghem record that the arc is incomplete at
`q = 11`, so the associated redundancy-three code has covering radius three" (Proposition 13),
*is* an inference — but it is redundant, because `prop:deep-holes-conic` proves covering radius
three independently, and the corresponding Lean terminal
`Q11Coding.witness_code_coveringRadius_three` already exists and is unconditional. So this
transfer is **redundant with an existing formal terminal**; the remediation is to reorder the
prose so the covering-radius claim is sourced from the paper's own proposition and the
Storme–Van Maldeghem sentence becomes a historical remark.

**Verdict for both: not load-bearing.** Two of the eighteen external dependencies counted in
the assertion inventory dissolve on inspection, without any new mathematics.

---

## Net effect on the Part D external-transfer ledger

Of the six classical transfers examined here:

| transfer | before | after |
|---|---|---|
| Segre's lemma of tangents | must import or audit | proved in full, elementary; Mathlib supplies the one input |
| Hirschfeld nucleus theorem | must import or audit | proved in full, elementary; no library input |
| Blokhuis–Brouwer–Szőnyi covering bound | must import or audit | off the `k = 6` critical path entirely; otherwise reduced to Jamison's affine blocking bound, whose standard proof rests on the Combinatorial Nullstellensatz already in Mathlib |
| Brouwer–Cohen–Neumaier / Jurišić–Vidali Sylvester identification | must import or audit | not consumed; demote to attribution |
| Abiad–Jabal Ameli–Reijnders clique value | must import or audit | load-bearing but replaced by a proved reduction to a fifty-case kernel, and the arc form needed is strictly stronger and independently checkable |
| Blokhuis–Seress–Wilbrink exterior sets | must import or audit | terminological only |
| Storme–Van Maldeghem classification entry | must import or audit | redundant with `Q11Coding.witness_code_coveringRadius_three` |

Four dependencies disappear, two become ordinary in-house formalization work of a size
comparable to lemmas the development already carries, and one — Jamison — remains as the single
named classical theorem still to be proved, and only for the general-`k` window and the `k = 8`
search domain, never for the headline theorem.

## Surprises and open points

- The `k = 6` upper window comes from `c(A) = (q-6)(q-9) <= 15` and the fifteen perfect
  matchings of `K_6`, not from any covering theorem. That the manuscript proves the general
  window first and specializes obscures this; it is worth an explicit restructuring of
  `cor:conic-filling-window`.
- The manuscript's `h = 1` in the weight-eight step is the odd-tangent-count case of the
  general value `h = (-1)^{t+1}`, `t = q + 2 - k`. Stating the general value costs nothing and
  makes the `q = 13`, `k = 8` specialization auditable.
- The `q = 9` obstruction has two units of slack: the true maximum pairwise-passant arc among
  internal points is four, while the cited clique value only excludes six. Nothing explains the
  slack structurally yet; it is the one place in this record where a conceptual proof still
  looks reachable and was not found.
- The `q = 9` counting closes into an exact identity with no residue at every level tried
  (chord multiplicities, chord-pole incidences, the induced subdivision of `K_6` inside
  `Sigma`). That is consistent with the obstruction being local, and it is why the finite kernel
  is proposed rather than a count.

## Reproducibility

`notes/2026-08-03-c855-q9-sylvester-kernel.py` is a bounded conjecture test, not a paper-facing
certificate. Replay: `python3 notes/2026-08-03-c855-q9-sylvester-kernel.py`. It constructs
`GF(9)` as `F_3[i]/(i^2+1)`, the conic `XZ = Y^2` in `PG(2,9)`, the polarity and the
internal/external/passant classification, and reports: `Sigma` five-regular and triangle-free
with intersection array `{5,4,2;1,1,4}`; passant join equivalent to distance two;
`omega(Sigma_2) = 5`; maximum pairwise-passant arc of internal points equal to four; conic
stabilizer of order `720` transitive on the `36` internal points with point stabilizer of order
`20` and two orbits of size ten on the twenty distance-two neighbors; and the saturated-pencil
kernel of `1024` candidate six-tuples with none surviving the pairwise-passant test. Any
paper-facing use of these numbers must be re-derived under
`notes/research-reproducibility-conventions.md`.
