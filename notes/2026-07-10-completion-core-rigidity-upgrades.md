# Completion-core rigidity: robustness, transversals, and new settings

**Date:** 2026-07-10

## Executive conclusion

Completion-core rigidity becomes substantially stronger when recast as a
robustness theory for maximal feasible configurations.

For a maximal configuration \(C\), the central invariant is not merely

\[
\operatorname{core}(K)
=
\bigcap\{F:K\subseteq F,\ F\text{ maximal feasible}\},
\]

but the minimum number of elements of \(C\) that must be deleted before a
different maximal completion becomes possible. This completion distance has:

1. an exact theorem in every finite hereditary independence system;
2. an exact secant interpretation for complete caps;
3. sharp values for conics, hyperovals, maximal arcs, elliptic quadrics,
   ovoids, and spreads;
4. a coding-theoretic interpretation as puncturing-resistant extension; and
5. a higher-rank formulation by transversal numbers of syndrome-
   representation hypergraphs.

The abstract closure and robustness facts are useful infrastructure, not a
publication headline: they overlap defining sets, trades, strong defining
sets, and positive teaching dimension. Conic defining subsets are precisely
the established almost-complete subsets, and classical NRC-intersection
theorems already compute the global NRC completion distance in a broad
range. The strongest surviving candidates are therefore finer:

1. the orbitwise insertion-cost spectrum of an NRC/GRS configuration,
   including the exact cap-set identity in Proposition 6.2;
2. robust almost-complete subsets, or relative multiple saturation of a
   conic, from Proposition 5.3;
3. asymptotics of the unrestricted first-core invariant `gamma(q)`; and
4. a nontrivial spread or field-reduction family not already covered by
   unique-extension theory.

## 1. The completion core as a closure operator

Let \((E,\mathcal I)\) be a finite hereditary independence system. Thus
\(\mathcal I\subseteq 2^E\), and every subset of a member of \(\mathcal I\)
also belongs to \(\mathcal I\). Call the maximal members of \(\mathcal I\)
facets. Every \(K\in\mathcal I\) lies in at least one facet.

Define

\[
\operatorname{core}(K)
=
\bigcap\{F:K\subseteq F,\ F\text{ a facet}\}.
\]

### Proposition 1.1 [PROVED]

The map \(\operatorname{core}\) is:

- extensive: \(K\subseteq\operatorname{core}(K)\);
- monotone: \(K\subseteq L\Rightarrow
  \operatorname{core}(K)\subseteq\operatorname{core}(L)\);
- idempotent:
  \(\operatorname{core}(\operatorname{core}(K))
  =\operatorname{core}(K)\); and
- equivariant under every automorphism of the independence system.

Moreover, \(\operatorname{core}(K)\in\mathcal I\).

### Proof

Extensivity is immediate. If \(K\subseteq L\), every facet containing \(L\)
also contains \(K\), so the intersection defining the core can only grow.
Every facet containing \(K\) contains \(\operatorname{core}(K)\), and every
facet containing \(\operatorname{core}(K)\) contains \(K\). The two families
of facets are therefore identical, proving idempotence. Equivariance follows
because automorphisms permute facets. Finally, the core is a subset of any
one facet containing \(K\), so heredity makes it independent. \(\square\)

These closure properties are not themselves a novelty claim. Abstract
closures for independence systems were studied by Laurence Matthews,
[Closure in Independence Systems](https://doi.org/10.1287/moor.7.2.159),
Math. Oper. Res. 7 (1982), 159–171.

## 2. Completion distance and the sharp deletion theorem

For a facet \(C\), define the directed completion distance

\[
\delta(C)
=
\min_{F\ne C}|C\setminus F|,
\]

with \(\delta(C)=\infty\) if \(C\) is the only facet.

This is the minimum number of elements of \(C\) erased by a different
maximal completion. Equivalently, it is the unique-decoding distance when
facets are regarded as generally nonconstant-weight codewords under
one-sided erasures.

### Theorem 2.1 — sharp deletion radius [PROVED]

Let \(C\) be a facet and \(D\subseteq C\).

1. If \(|D|<\delta(C)\), then \(C\) is the unique facet containing
   \(C\setminus D\), and

   \[
   \operatorname{core}(C\setminus D)=C.
   \]

2. If \(F\ne C\) realizes \(\delta(C)\) and
   \(D=C\setminus F\), then

   \[
   \operatorname{core}(C\setminus D)=C\setminus D.
   \]

Consequently, \(\delta(C)-1\) is the exact adversarial-deletion radius for
which every puncture of \(C\) still forces \(C\) as its unique completion.

### Proof

If a facet \(F\ne C\) contains \(C\setminus D\), then
\(C\setminus F\subseteq D\), so
\(\delta(C)\le |C\setminus F|\le |D|\). This contradicts
\(|D|<\delta(C)\), proving the first assertion.

For the second, put \(K=C\setminus D=C\cap F\). Both \(C\) and \(F\) are
facets containing \(K\), so

\[
K\subseteq\operatorname{core}(K)\subseteq C\cap F=K.
\]

Hence \(\operatorname{core}(K)=K\). \(\square\)

### Proposition 2.2 — insertion and circuit-transversal forms [PROVED]

The completion distance also satisfies

\[
\delta(C)
=
\min_{x\notin C}\;
\min\{|D|:D\subseteq C,\ (C\setminus D)\cup\{x\}\in\mathcal I\}.
\]

For \(x\notin C\), form the circuit-trace hypergraph

\[
\mathcal H_C(x)
=
\{A\subseteq C:A\cup\{x\}\text{ is a circuit}\}.
\]

Then the deletion cost for inserting \(x\) is exactly

\[
\delta_x(C)=\tau(\mathcal H_C(x)),
\qquad
\delta(C)=\min_{x\notin C}\delta_x(C),
\]

where \(\tau\) denotes transversal number.

### Proof

If \((C\setminus D)\cup\{x\}\) is independent, extend it to a facet \(F\).
Then \(C\setminus F\subseteq D\). Conversely, for any facet \(F\ne C\),
choose \(x\in F\setminus C\); then
\((C\cap F)\cup\{x\}\) is independent. This proves the insertion formula.

The set \((C\setminus D)\cup\{x\}\) is independent exactly when it contains
no circuit. Since \(C\) is independent, every relevant circuit contains
\(x\). Thus \(D\) must meet every trace in \(\mathcal H_C(x)\), and this
condition is also sufficient. \(\square\)

### Proposition 2.3 — defining sets and the alternative-completion hypergraph [PROVED]

For a facet `C`, define

\[
\mathcal T_C=\{C\setminus F:F\ne C,\ F\text{ a facet}\}.
\]

For `K subseteq C`, the following are equivalent:

1. `C` is the unique facet containing `K`;
2. `core(K)=C`; and
3. `K` is a transversal of `mathcal T_C`.

Consequently the minimum size of a certificate forcing `C`,

\[
d(C)=\min\{|K|:K\subseteq C,\ \operatorname{core}(K)=C\},
\]

satisfies

\[
d(C)=\tau(\mathcal T_C),
\qquad
\delta(C)=\min\{|T|:T\in\mathcal T_C\}.             \tag{2.1}
\]

Thus completion distance and minimum defining-set size are, respectively,
the minimum edge size and transversal number of the same hypergraph of
alternative completions.

#### Proof

If `core(K)=C`, then every facet containing `K` contains `C`; maximality of
`C` forces every such facet to equal `C`. The converse is immediate. A facet
`F ne C` contains `K` exactly when

\[
K\cap(C\setminus F)=\varnothing.
\]

Therefore `C` is the unique completion exactly when `K` meets every member
of `mathcal T_C`. The two identities follow. `square`

This is the established language of **defining sets**. In constant-size
design families, the differences `C minus F` are positive parts of trades,
so (2.1) places completion-core rigidity in the defining-set/trade
framework used for block designs and Latin squares. The abstract identity is
infrastructure; novelty must come from computing either parameter, their
spectra, or equality configurations in a new family.

More generally, a defining set `K subseteq C` survives every deletion of
fewer than `h` of its elements exactly when

\[
|K\cap(C\setminus F)|\ge h
\quad\text{for every facet }F\ne C.                \tag{2.2}
\]

Its exact robustness is therefore

\[
\operatorname{str}_C(K)=\min_{F\ne C}|K\setminus F|,
\qquad
\operatorname{str}_C(C)=\delta(C).                \tag{2.3}
\]

This is the recent notion of a **strong defining set**: in Latin-square
language it is equivalent to meeting every trade at least `h` times; see
Bean and Cavenagh,
[Defining sets which intersect each Latin trade at least twice](https://arxiv.org/abs/2605.28027).
Thus the robust-defining-set abstraction itself is not a safe novelty claim.
The finite-geometric contribution must be an exact strength computation,
an extremal bound, or a classification unavailable in the trade setting.

### Proposition 2.4 — completion distance is an intersection number [PROVED]

For a complete configuration `C` that is not the unique facet, put

\[
I(C)=\max\{|A\cap C|:A\in\mathcal I,\ A\setminus C\ne\varnothing\}.
\]

Then

\[
\delta(C)=|C|-I(C).                                \tag{2.4}
\]

#### Proof

Every competing facet is an admissible `A` in the maximum, so the right
side is at most `delta(C)`. Conversely, extend any admissible `A` to a facet
`F`. Then `F ne C` and `|F intersect C|>=|A intersect C|`. Maximizing gives
the reverse inequality. `square`

Thus the extensive literature on how strongly an arc, cap, design, or code
can intersect a fixed classical configuration is already literature on its
completion distance, after translation. This is especially important for
normal rational curves below.

This transversal formulation is the main portal to new geometries. In
plane-cap geometry the traces are disjoint pairs; in higher-rank MDS
geometry they overlap, and representation counts no longer determine
transversal numbers.

## 3. Complete caps and multiple saturation

Let \(C\) be a complete cap in a finite partial linear space. For
\(x\notin C\), let

\[
s_C(x)
=
\#\{\text{\(C\)-secants through }x\}.
\]

### Theorem 3.1 — secant resilience [PROVED]

\[
\boxed{\delta(C)=\min_{x\notin C}s_C(x).}
\]

### Proof

For fixed \(x\), the endpoint pairs of distinct \(C\)-secants through \(x\)
are disjoint. To insert \(x\), at least one endpoint of every such secant
must be deleted, so at least \(s_C(x)\) deletions are necessary. Choosing
one endpoint from every secant is sufficient. The chosen puncture together
with \(x\) remains a cap, and Proposition 2.2 completes the proof.
\(\square\)

Thus the completion distance of a complete cap is exactly the largest
\(\mu\) for which it is a \((1,\mu)\)-saturating set. Multiple saturating
sets and their coding interpretation are established subjects; see
Bartoli, Davydov, Giulietti, Marcugini, and Pambianco,
[On upper bounds on the smallest size of a saturating set in a projective plane](https://arxiv.org/abs/1505.01426).
The new prospective contribution is the exact interpretation of this
multiplicity as a puncturing/forced-completion threshold.

The same proof works for the capacity-\(d\) independence system in which
at most \(d\) selected points may lie on a line. In that setting,
\(\delta(C)\) is the minimum number of saturated \(d\)-secants through an
outside point.

## 4. Exact geometric families

### 4.1 Odd conics [PROVED]

Let \(O\) be a nonsingular conic in \(PG(2,q)\), \(q\) odd. An external
point lies on \((q-1)/2\) conic secants and an internal point on
\((q+1)/2\). Therefore

\[
\delta(O)=\frac{q-1}{2}.
\]

Consequently:

\[
|D|<\frac{q-1}{2}
\quad\Longrightarrow\quad
\operatorname{core}(O\setminus D)=O.
\]

At equality, choose an external point \(x\) and one endpoint from every
\(x\)-secant as \(D\). Then
\(\operatorname{core}(O\setminus D)=O\setminus D\).

More generally, for \(K=O\setminus D\),

\[
\operatorname{core}(K)=O
\]

if and only if \(D\) is not a transversal of the secant matching of any
point \(x\notin O\).

### 4.2 Even hyperovals [PROVED]

Let \(H\) be a hyperoval in a plane of even order \(q\). Every outside point
lies on exactly \((q+2)/2\) hyperoval secants, since the \(q+2\) hyperoval
points are paired by the lines through that point. Hence

\[
\delta(H)=\frac{q+2}{2}.
\]

Deleting at most \(q/2\) points always forces \(H\) back; the threshold
\((q+2)/2\) is sharp.

### 4.3 Maximal degree-\(d\) arcs [PROVED]

Let \(M\) be a maximal degree-\(d\) arc in a projective plane of order
\(q\). Thus every line meets \(M\) in zero or \(d\) points and

\[
|M|=q(d-1)+d.
\]

Every outside point lies on

\[
\frac{|M|}{d}=q-\frac qd+1
\]

saturated \(d\)-secants. In the capacity-\(d\) independence system,

\[
\delta(M)=q-\frac qd+1.
\]

This contains the hyperoval result as \(d=2\).

### 4.4 Classical elliptic quadrics [PROVED]

Let \(Q=Q^-(3,q)\), a classical elliptic quadric in \(PG(3,q)\). It is an
ovoid and hence a cap of size \(q^2+1\). For an outside point \(x\), the
standard polar-space count gives \(q+1\) tangent lines from \(x\) to
\(Q\). The remaining

\[
q^2+1-(q+1)=q(q-1)
\]

quadric points pair on secants through \(x\). Therefore

\[
\delta(Q)=\frac{q(q-1)}2.
\]

The assertion is for the classical quadric. A nonclassical ovoid requires
its own tangent/secant audit.

### 4.5 Ovoids in generalized quadrangles [PROVED]

Regard a partial ovoid as an independent set in the point-collinearity
graph. Let \(O\) be an ovoid of a generalized quadrangle of order
\((s,t)\). Every point outside \(O\) is collinear with exactly one ovoid
point on each of its \(t+1\) lines. Thus

\[
\delta(O)=t+1.
\]

Deleting at most \(t\) ovoid points forces the original ovoid; deleting the
\(t+1\) ovoid neighbors of an outside point attains the sharp threshold.

### 4.6 Spreads [PROVED]

Regard a partial spread as an independent set in the intersection graph of
its subspaces. A line outside a line spread of \(PG(3,q)\) has \(q+1\)
points, each lying on a different spread line. Hence

\[
\delta(S)=q+1.
\]

The same graph argument applies to spreads in generalized quadrangles,
with the corresponding line size.

## 5. A new extremal invariant for projective planes

For odd \(q\ge5\), define

\[
\gamma(q)
=
\min\{|K|:K\text{ is an arc in }PG(2,q),
\ \operatorname{core}(K)\ne K\}.
\]

For a nonsingular conic `O`, call `S subseteq O` almost complete if no point
outside `O` can be adjoined to `S` while retaining an arc. Let `t(q)` be the
smallest size of such a subset. This is standard terminology, and it is
exactly the conic-restricted defining-set parameter above.

### Proposition 5.1 — almost-complete subsets are conic defining sets [PROVED]

For odd `q` and `S subseteq O`,

\[
S\text{ is almost complete}
\quad\Longleftrightarrow\quad
\operatorname{core}(S)=O.
\]

#### Proof

If `S` is almost complete, every facet containing it is obtained using only
points of `O`. A maximal such arc must contain every remaining point of `O`,
so its unique completion is `O`. Conversely, if an off-conic point could be
adjoined to `S`, extending that arc to a facet would produce a facet other
than `O`, contradicting `core(S)=O`. `square`

### Corollary 5.2 — corrected bounds for the first nontrivial core [PROVED + LITERATURE-IMPORTED]

\[
\left\lceil\frac{3+\sqrt{8q-7}}2\right\rceil
\le
\gamma(q)
\le
t(q)
<1.835\sqrt{q\ln q}.
\]

### Proof

The anti-Frattini theorem says that a \(k\)-arc has trivial core whenever

\[
q>\binom{k-1}{2}+1.
\]

Thus nontrivial core requires
\(\binom{k-1}{2}\ge q-1\), which gives the lower bound.

For the upper bound, take a smallest almost-complete subset of a conic and
apply Proposition 5.1. The displayed estimate for `t(q)` is due to Bartoli,
Davydov, Marcugini, and Pambianco,
[On the Smallest Size of an Almost Complete Subset of a Conic and
Extendability of Reed--Solomon Codes](https://doi.org/10.1134/S0032946018020011).
`square`

The previous elementary bound `(q+5)/2`, obtained by adversarially deleting
fewer than the conic completion distance, remains a useful *uniform deletion*
statement but is not competitive for the existential invariant `gamma(q)`.
The corrected window is within a logarithmic factor:

\[
\sqrt{2q}+O(1)\ \le\ \gamma(q)\ <\ 1.835\sqrt{q\ln q}.
\]

The sharp new questions are whether a nonconic forced core can beat `t(q)`,
whether the logarithm can be removed, and whether near-extremizers must have
a large conical subset.

### Proposition 5.3 — robust completion is relative multiple saturation [PROVED]

Let `C` be any complete cap in a finite partial linear space, let
`S subseteq C`, and let `h>=1`. The following are equivalent:

1. after deleting any fewer than `h` points from `S`, the remainder still
   has unique complete-cap completion `C`;
2. every point outside `C` lies on at least `h` secants of `S`.

#### Proof

For `x` outside `C`, its `S`-secants have pairwise disjoint endpoint pairs:
two secants through `x` sharing an endpoint would coincide by the partial-
linear-space axiom and contain three points of the cap. Hence the minimum
number of points that must be deleted from `S` to make `x` legal is exactly
the number of those secants.

If every count is at least `h`, deletion of fewer than `h` points leaves
every point outside `C` blocked. Any complete cap extending the remainder
therefore lies in `C`, and a proper subset of the cap `C` is not complete,
so the unique completion is `C`. Conversely, if `x` lies on fewer than `h`
secants, delete one endpoint from each. Then `x` is legal, and a maximal
extension containing `x` is a complete cap different from `C`. `square`

Specializing `C=O` to a conic, the minimum size `t_h(q)` of an `h`-strong
conic defining set is a
**relative multiple-saturation** number: points of `PG(2,q) minus O` require
`h` secants, while the intended holes `O minus S` are exempt. It is not a
standard `(1,h)`-saturating set, since a missing conic point lies on no
`S`-secant. One has `t_1(q)=t(q)`. This relative version is a more credible
new program than renaming ordinary almost-completeness: obtain sharp or
asymptotically sharp bounds for `t_h(q)`, classify equality sets, and compare
it with unrestricted multiple saturation. It connects strong defining sets,
conic matchings, and covering codes in one exact parameter.

The novelty boundary is nevertheless close: ordinary multiple saturating
sets are equivalent to multiple coverings of the corresponding syndrome
stratum.  Here the syndromes outside `O` require `h` weight-two
representations while `O minus S` is an explicitly exempt stratum.  Thus
the definition alone is not a paper result; new bounds, sharpness, or
equality classifications must distinguish this relative problem from the
mature multiple-covering literature.  See
[Bartoli--Davydov--Giulietti--Marcugini--Pambianco](https://arxiv.org/abs/1505.01426).

Determining the order of growth of \(\gamma(q)\) is a concrete new
extremal problem. A richer version is

\[
F_q(k)
=
\max_{\substack{K\text{ a }k\text{-arc}}}
|\operatorname{core}(K)\setminus K|.
\]

Useful targets are:

- determine \(\gamma(q)\) for small \(q\) using existing arc-orbit data;
- improve either asymptotic bound;
- determine \(F_q(k)\) in the large-arc range;
- classify extremizers; and
- prove a stability theorem saying that a sufficiently large forced core
  must lie on a conic or another classical variety.

Unique extension of large arcs is an active and crowded subject. Relevant
benchmarks include Alderson,
[Extending Arcs: An Elementary Proof](https://doi.org/10.37236/1973),
and the recent
[When Arcs Extend Uniquely: A Higher-Dimensional Generalization of Barlotti's Result](https://arxiv.org/abs/2511.06193).
The new claim must therefore concern robust deletion distance, core
spectrum, or equality transversals—not unique extension by itself.

## 6. Higher-rank MDS extension resilience

Let \(C\subset PG(r-1,q)\) be a projective arc, so every \(r\) columns are
independent. For \(x\notin C\), define

\[
\mathcal B_x
=
\left\{
B\in\binom C{r-1}:x\in\langle B\rangle
\right\}.
\]

### Proposition 6.1 [PROVED DICTIONARY]

The minimum number of columns that must be deleted from \(C\) before \(x\)
can be appended is

\[
\delta_x(C)=\tau(\mathcal B_x),
\qquad
\delta(C)=\min_{x\notin C}\tau(\mathcal B_x).
\]

This is Proposition 2.2 specialized to projective arcs. In coding
language, \(\mathcal B_x\) is the family of minimum-size parity-check
column representations of the external projective syndrome \(x\).

For a plane cap, \(\mathcal B_x\) is a matching and its transversal number
is just its number of edges. In higher rank the representation supports
overlap. Representation count, multiple-covering density, and transversal
number can therefore differ sharply.

### Proposition 6.2 — a zero-sum insertion orbit on the normal rational curve [PROVED]

Let

\[
C=\{(1,t,\ldots,t^d):t\in\mathbb F_q\}\cup\{e_d\}
   \subset PG(d,q)
\]

be the degree-`d` normal rational curve, and take the external point
`x=e_(d-1)`. Let

\[
Z_d(\mathbb F_q)
=\max\{|S|:S\subseteq(\mathbb F_q,+),\
              \text{ no }d\text{ distinct elements of }S\text{ sum to }0\}.
\]

Then the exact deletion cost for inserting `x` is

\[
\boxed{\delta_x(C)=q-Z_d(\mathbb F_q).}             \tag{6.1}
\]

#### Proof

The hyperplane through the `d` finite curve points with parameter set `B`
has normal vector equal, up to scale, to the coefficient vector of

\[
\prod_{b\in B}(T-b).
\]

It contains `e_(d-1)` exactly when the coefficient of `T^(d-1)` vanishes,
equivalently when `sum_(b in B)b=0`. A hyperplane through the point at
infinity and `d-1` finite curve points has coefficient of `T^(d-1)` equal
to one, so it never contains `x`. Thus the circuit-trace hypergraph at `x`
is exactly the hypergraph of distinct zero-sum `d`-subsets of `F_q`.
Deleting a transversal is equivalent to leaving a largest edge-free set,
which proves (6.1). `square`

**Prior-art boundary.** The determinant/zero-sum criterion is part of the
established Reed--Solomon deep-hole/MDS-extension dictionary.  Kaipa proves
the general equivalence between projective-syndrome extension and RS deep
holes, while Xu--Hong--Xu state the corresponding degree-`k` nonzero-subset-
sum criterion; see [Kaipa](https://arxiv.org/abs/1612.05447) and
[Xu--Hong--Xu](https://arxiv.org/abs/1705.07823).  The possible new content
of (6.1) is only its **robust deletion/transversal refinement**--the exact
number of evaluation positions that must be removed--not the underlying
all-or-nothing extension criterion.  It is a companion proposition unless
the resulting resilience spectrum is computed for a nontrivial family.

For `d=3` and `q=3^h`, three distinct elements sum to zero exactly when they
form an affine line in `F_3^h`. Hence

\[
\delta_{e_2}(C)=3^h-\operatorname{cap}_3(h),        \tag{6.2}
\]

where `cap_3(h)` is the cap-set extremal function. This is an exact bridge
to additive combinatorics, not merely an analogy. It also shows why the
full insertion-cost **spectrum** can be more interesting than its minimum:
this particular point is expensive to insert even when another external
orbit determines a much smaller global completion distance.

For `q=p` prime, the Dias da Silva--Hamidoune restricted-sumset theorem
gives

\[
Z_d(\mathbb F_p)
\le\left\lfloor\frac{p+d^2-2}{d}\right\rfloor,
\]

and hence the explicit imported bound

\[
\delta_{e_{d-1}}(C)
\ge p-\left\lfloor\frac{p+d^2-2}{d}\right\rfloor.  \tag{6.3}
\]

See Dias da Silva and Hamidoune,
[Cyclic Spaces for Grassmann Derivatives and Additive
Theory](https://doi.org/10.1112/blms/26.2.140). In characteristic three,
the
[Ellenberg--Gijswijt cap-set bound](https://doi.org/10.4007/annals.2017.185.1.8)
similarly yields
`delta_(e_2)=3^h-O(2.756^h)`.

Other coordinate functionals select elementary-symmetric coefficients of
the root polynomial and lead to symmetric-polynomial avoidance
hypergraphs. The bounded research program is to classify the external
`PGL(2,q)` orbits, identify the corresponding additive or multiplicative
extremal problem, and compute the orbitwise values `delta_x`.

### 6.3 The NRC minimum is already an intersection problem [LITERATURE-IMPORTED]

Proposition 2.4 shows that computing `delta(C)` for a normal rational curve
is equivalent to finding the largest intersection of that curve with an arc
not contained in it. Storme and Szőnyi studied exactly this problem in
[Intersection of arcs and normal rational curves in spaces of odd
characteristic](https://doi.org/10.1017/CBO9780511526336.034). Their
published statement gives, for odd `q` sufficiently large and

\[
3\le d\le0.09q+2.09,
\]

maximum intersection `(q+1)/2`, with cyclic structure at equality. In that
range their theorem translates immediately to

\[
\delta(C)=\frac{q+1}{2}.                            \tag{6.4}
\]

The exact small-order threshold and equality hypotheses still require a
full-text audit before (6.4) is quoted as a formal imported theorem in a
manuscript. Conceptually, however, the proposed NRC headline is partly
landed already in classical intersection language. New work should target
the uncovered parameter ranges, even characteristic, the orbitwise spectrum
from Proposition 6.2, or a genuinely stronger GRS robustness invariant.

### Primary high-novelty target — twisted-cubic transversal spectrum [OPEN]

For the twisted cubic `C_3(q) subset PG(3,q)`, define

\[
\rho(x)=\tau\left\{B\in\binom{C_3(q)}3:
                         x\in\langle B\rangle\right\}. \tag{6.5}
\]

The stabilizer `PGL(2,q)` has finitely many external point orbits. Existing
work classifies those orbits and computes their point--plane representation
counts; see Bartoli, Davydov, Marcugini, and Pambianco,
[On planes through points off the twisted cubic and multiple covering
codes](https://arxiv.org/abs/1909.00207). Counts do not determine the
transversal numbers in (6.5).

The strongest defensible target is to determine `rho(x)` on every external
orbit, and classify minimum transversals under the point stabilizer. This is
the full robust-syndrome spectrum of the codimension-four doubly extended
GRS code; Proposition 6.2 identifies one characteristic-three orbit with
the cap-set problem.

Predeclared gates:

1. enumerate the determinant hypergraphs for `q=5,7,11`, holding out
   `q=13,17,19`;
2. verify edge counts against the published incidence matrices;
3. verify that the minimum orbit agrees with the imported global value
   `(q+1)/2` wherever its hypotheses apply;
4. separate characteristic three and `q mod 3` before fitting formulas; and
5. require at least one infinite orbit formula plus equality-transversal
   classification.

This is distinct from ordinary deep-hole weight or covering radius: it asks
how many evaluation columns must be adversarially erased to destroy every
minimal representation of one syndrome. The geometry/MDS background is
surveyed by Ball and Lavrauw,
[Arcs in finite projective spaces](https://arxiv.org/abs/1908.10772).

## 7. Other promising extensions

### 7.1 Field reduction and linear sets [PROMISING]

Write `V=F_(q^n)` as an `n`-dimensional `F_q`-space. In
`PG(V direct_sum V)=PG(2n-1,q)`, use the standard Desarguesian spread

\[
S_a=\{\langle(x,ax)\rangle_q:x\ne0\},\quad a\in V,
\qquad
S_\infty=\{\langle(0,y)\rangle_q:y\ne0\}.
\]

For an `F_q`-linear map `f:V -> V`, let `X_f` be the projectivized graph of
`f`. If `f` is not scalar, `X_f` is an external candidate `(n-1)`-space.

### Proposition 7.1 — spread insertion, directions, and a rank-metric list [PROVED DICTIONARY]

The cost of inserting `X_f` into the Desarguesian spread is

\[
\begin{aligned}
\delta_{X_f}(\mathcal S)
 &=\#\{a\in V:\ker(f-aI)\ne0\}\\
 &=\left|\left\{\frac{f(x)}x:x\in V^*\right\}\right|\\
 &=|L_f|,                                             \tag{7.1}
\end{aligned}
\]

where `L_f` is the associated `F_q`-linear set on `PG(1,q^n)`.
Equivalently, if

\[
\mathcal C_{\rm sc}=\{aI:a\in V\}\subset\operatorname{End}_{F_q}(V),
\]

then (7.1) is the number of scalar codewords at rank distance at most
`n-1` from `f`.

#### Proof

The graph `X_f` meets `S_a` precisely when some `x ne 0` satisfies
`f(x)=ax`. It is disjoint from `S_infinity`. This proves the first two
identities, while field reduction identifies the same slopes with the
points of `L_f`. Finally,

\[
\ker(f-aI)\ne0
\quad\Longleftrightarrow\quad
\operatorname{rank}_{F_q}(f-aI)\le n-1,
\]

which is the rank-metric statement. `square`

The set `{f(x)/x}` is precisely the classical direction set of the graph of
the `q`-polynomial `f`, and precisely the associated rank-`n` linear set.
The numerical minimum is therefore already tightly connected to the
established minimum-size theory of linear sets and direction sets; see De Beule and Van
de Voorde,
[The minimum size of a linear set](https://arxiv.org/abs/1804.07388).
The rank-metric equivalence is elementary, and the broader
linearized-polynomial/linear-set/rank-metric correspondence is mature; see
[Longobardi--Zanella](https://arxiv.org/abs/2009.11537). Consequently, a bare minimum-size formula has high prior-art risk. The
surviving targets are the equality/switching classes of nearest alternative
spreads, the full insertion-cost distribution, or the analogous local-list
problem for a nontrivial Gabidulin/MRD spread set rather than the scalar
code.

### 7.2 Equivariant completion cores [PROMISING, MEDIUM RISK]

For a group \(G\), work in the independence system whose elements are
\(G\)-orbits and whose feasible sets are \(G\)-invariant independent
configurations. Define the equivariant core using maximal feasible orbit
sets.

This can force an entire orbit even when the ordinary core is trivial.
Candidate groups include:

- Frobenius/Baer involutions;
- cyclic Singer subgroups;
- translation groups; and
- automorphism groups of cyclic or quasi-cyclic codes.

The definition must distinguish maximality among \(G\)-invariant
configurations from ordinary geometric completeness.

### 7.3 List completion and completion enumerators [PROMISING]

For a facet \(C\) and deletion set \(D\), define the completion list

\[
\mathcal L_C(D)
=
\{F:C\setminus D\subseteq F,\ F\text{ a facet}\}.
\]

Theorem 2.1 is the unique-completion radius. Further invariants include:

- worst-case list size after \(r\) deletions;
- the distribution of distances \(|C\setminus F|\);
- the number of equality transversals;
- automorphism orbits of nearest alternative completions; and
- generalized radii at which at least \(L\) completions appear.

This is the natural list-decoding extension of completion-core rigidity.

### 7.4 Additive configurations [PROMISING, NOVELTY UNCERTAIN]

For maximal sum-free, Sidon, or \(B_h\) sets, alternative insertions are
controlled by additive-representation hypergraphs. Completion distance is
again the minimum transversal number of those representations.

Binary caps already have a strong sum-free/saturating-set literature; see
Grynkiewicz and Lev,
[1-Saturating Sets, Caps, and Doubling-Critical Sets in Binary Spaces](https://arxiv.org/abs/0811.1322).
A new result must compute a deletion threshold or equality structure not
already implicit in critical-pair theory.

### 7.5 Simplicial topology [SECONDARY TOOL]

Let \(\Delta\) be the independence complex. Then

\[
\operatorname{core}(K)\setminus K
\]

is precisely the set of cone vertices of
\(\operatorname{link}_\Delta(K)\). Consequently:

- a nontrivial core makes the link a cone;
- nonzero reduced homology certifies
  \(\operatorname{core}(K)=K\); and
- the Stanley–Reisner ring of the link splits off one polynomial variable
  for every forced point.

This is useful infrastructure, but homology alone is too coarse to be the
headline.

### 7.6 Positive teaching dimension [EXACT DICTIONARY]

Regard the family of facets as a Boolean concept class on ground set `E`.
If only positive examples may be shown, then a teaching set for the target
concept `C` is exactly a subset `K subseteq C` contained in no other facet.
Therefore

\[
d(C)=\text{the positive teaching dimension of the concept }C,
\]

while

\[
\delta(C)=\min_{F\ne C}|C\setminus F|
\]

is its nearest-rival distance under one-sided Hamming loss. Formula (2.2)
is the corresponding erasure-robust teaching condition. The general theory
of teaching dimension begins with Goldman and Kearns,
[On the Complexity of Teaching](https://doi.org/10.1006/jcss.1995.1003).

This translation gives finite-geometric completion parameters an audience
in exact learning and machine teaching, but it also removes another possible
novelty claim: defining-set size is already a teaching parameter in abstract
set systems. A worthwhile cross-field result would compute the positive or
robust teaching dimension of a symmetric geometric concept class, or use its
incidence structure to separate teaching dimension from VC-type parameters.

### 7.7 Ordinary matroids collapse [PROVED OBSTRUCTION]

If the independence system is a matroid `M`, then for every independent
`K`,

\[
\operatorname{core}(K)
=K\cup\{e:e\text{ is a coloop of }M/K\}.            \tag{7.2}
\]

Moreover, if a base `C` is not the unique base, basis exchange gives

\[
\delta(C)=1.
\]

Indeed, bases containing `K` correspond to bases of the contraction `M/K`,
whose common elements are exactly its coloops. If `C` is not unique, some
`e in C` is not a coloop; basis exchange supplies `f notin C` such that
`C-e+f` is a base.

Thus ordinary matroid independence is not a promising new setting: exchange
destroys nontrivial completion distance. Interesting examples arise from
packing, girth, arc, or code constraints that are hereditary but are not the
independent sets of the represented vector matroid.

### 7.8 Repair, reliability, and secret-sharing cuts [EXACT DICTIONARIES]

For a fixed external element `x`, the circuit traces `mathcal H_C(x)` may be
read in three other standard ways:

- as the minimal qualified coalitions in the matroid port with dealer `x`;
- as the minimal repair groups for a virtual code coordinate `x`; or
- as the minimal path sets of a coherent reliability system.

Then `delta_x(C)=tau(mathcal H_C(x))` is respectively the minimum participant
revocation set, simultaneous repair-set failure tolerance, or system
min-cut. These translations explain why representation count alone is
insufficient when the supports overlap. They broaden the audience, but the
min-cut identity is classical; a useful result must compute it for a
recognized geometric code or access structure.

## 8. Publication assessment

### What is already strong enough for a companion section

- the closure-operator proposition;
- the sharp deletion-radius theorem;
- the circuit-transversal dictionary;
- conic and hyperoval phase transitions; and
- the anti-Frattini lower bound for \(\gamma(q)\).

### What could support a short standalone note

A unified robust-completion theorem with exact values for:

- conics and hyperovals;
- maximal degree-\(d\) arcs;
- elliptic quadrics;
- generalized-quadrangle ovoids; and
- spreads,

provided equality deletion sets are classified under their automorphism
groups and a targeted novelty search finds no prior robust-completion
formulation.

### What could support a more substantial paper

At least one of:

1. an exact external-orbit spectrum for an NRC/GRS system, beyond the
   already-known global minimum;
2. sharp bounds or an equality theory for the robust conic parameters
   `t_h(q)`;
3. a nontrivial field-reduction/linear-set computation;
4. asymptotically sharp bounds for \(\gamma(q)\) or \(F_q(k)\);
5. an equivariant-core theorem with a genuine orbit-forcing phenomenon; or
6. a list-completion theorem beyond unique extendability.

## 9. Recommended research sequence

### Stage A — low-cost theorem package

1. Finish the exact Storme--Szőnyi hypothesis/equality audit and import
   the NRC value only in its verified range.
2. Audit the six exact families in Section 4 against the defining-set,
   trade, and multiple-saturation literature.
3. Formulate `t_h(q)` in standard relative-cover language and derive the
   first probabilistic lower and upper bounds.
4. Compute \(\gamma(q)\) and the NRC orbitwise `delta_x` spectrum for the
   smallest available fields from existing arc-orbit data.

**Success gate:** at least one equality classification or core-spectrum
result not already contained in unique-extension literature.

### Stage B — one headline computation

Fund one of:

- the twisted-cubic/NRC external-orbit spectrum, beginning with the exact
  zero-sum/cap-set orbit from Proposition 6.2;
- robust almost-complete subsets `t_h(q)`; or
- Desarguesian spreads and linear-set weights.

**Success gate:** an exact new orbit-family formula, or an asymptotically
sharp two-sided bound for `t_h(q)` or another genuinely new resilience
parameter.

### Stage C — manuscript decision

If Stage B succeeds, package the work as robust completion of
finite-geometric packings and codes. If it fails, retain the sharp deletion
theorem and classical applications as a companion section of the
equivariant-extension paper.

## 10. Scope audit

- No novelty is claimed for closure operators in abstract independence
  systems.
- No novelty is claimed for defining sets, strong defining sets, or teaching
  dimension in abstract set systems.
- No novelty is claimed for ordinary unique extendability of large arcs.
- Almost-complete conic subsets and multiple saturation are prior
  terminology; the prospective contribution must concern the relative
  robust parameter, orbitwise spectrum, or a new extremal theorem.
- The elliptic-quadric formula is stated only for the classical quadric.
- The maximal degree-\(d\) result concerns the capacity-\(d\) game, not
  ordinary no-three-collinear caps unless \(d=2\).
- The global NRC minimum is classical in a substantial range; Proposition
  6.2 concerns one external orbit and does not prove that it minimizes
  `delta_x`.
- None of these statements proves the odd-plane cap-game theorem or a
  P-valued extension.
