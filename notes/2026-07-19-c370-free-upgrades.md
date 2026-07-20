# C370 adjacent free upgrades

**Date:** 2026-07-19
**Lane:** `crowns`
**Status:** two positive proof-level gates; allocated as C388 and C389

## Purpose

Record the strongest consequences missed by C370's deliberately value-free packaging, separate
what is genuinely free from what still needs research, and route at most two successors.  This is
the bounded adjacent-upgrade pass requested after the C370 literature audit; it does not resume
C294 or authorize a quadratic-scar value experiment.

## C388: cubic mirror isolator

### Positive proof gate

Fix a C333 member over `k=F_q`, `q>=5` odd, with mirror `tau(t)=delta/t`, four projection
involutions `S`, base residual `B`, quadratic block `Q`, and regular four-coloured Cayley block

\[
C=\operatorname{Cay}(\operatorname{PGL}_2(q),S).
\]

For `K_n=F_(q^n)` and every `a in k^*`,

\[
\chi_{K_n}(a)=\chi_k(a)^n.
\]

Hence, when `n` is odd, all three character inputs in C333's mirror proof remain nonsquare:
`delta`, `delta(delta-4)`, and `(1+delta b)^2-4delta`.  The six-arc determinants remain nonzero,
`tau` still swaps the two generator pairs, and the deleted set remains `tau`-stable.  Therefore
`tau` is a fixed-point-free graph involution on the full extension residual `R_n`, and no live
vertex is adjacent to its mirror.  The standard Node--Kayles mirror induction gives

\[
\mathcal G(R_n)=0\qquad(n\text{ odd}).
\tag{1}
\]

C370 has `c_3=1` and no quadratic block in cubic degree, so

\[
R_3\cong B\sqcup C.
\]

C333 gives `G(B)=0`, while (1) gives `G(R_3)=0`.  Disjoint-union xor therefore isolates the
previously unevaluated regular scar:

\[
\boxed{\mathcal G(C)=0}.
\tag{2}
\]

Substituting (2) into C370's all-extension decomposition yields the exact tower reduction

\[
\boxed{
\mathcal G(R_n)=
\begin{cases}
0,&n\text{ odd},\\
\mathcal G(Q),&n\text{ even}.
\end{cases}}
\tag{3}
\]

Thus C370's mod-four regular-component phase disappears at game-value level.  Every unresolved
extension value is the same single quadratic-block value.

### Scope and stop rule

The generic fixed-point-free/nonadjacent graph-involution lemma is prior art and already consumed
by C333.  The candidate contribution is the cubic-orbit isolator (2) and exact tower reduction
(3), not a new mirror strategy.  C388 must package the compatibility proof against C333's exact
deleted-set conventions and C370's four-colour Cayley convention.  It may add a bounded independent
symbolic/finite replay, but it must not compute `G(Q)`, enlarge a state cap, or resume any C294
experiment.  Failure of any extension-field character or deletion compatibility closes C388.

**Owned report:** `notes/2026-07-19-c388-cubic-mirror-isolator.md`.

## C389: universal exact-degree and repair base change

### Positive proof gate

Let `S` be any finite inverse-closed set of distinct base-defined projective transformations (in
particular, any finite set of projection involutions) that generates a finite subgroup
`H<=PGL_2(q)`.  Form a coloured residual by deleting fixed points of a prescribed finite set of
nonidentity words in `S`—in particular, all pair products used by the conic residual.
Every such fixed point has degree at most two.  For `d>2`, let `E_d` be the projective points of
exact degree `d` over `F_q`.  Then

\[
|E_d|=\sum_{e\mid d}\mu(d/e)q^e.
\]

Every nonidentity element of `H` fixes only degree-at-most-two points, so `H` acts freely on `E_d`.
Consequently the exact-degree layer is

\[
R(E_d)\cong a_d(H)\operatorname{Cay}(H,S),\qquad
a_d(H)=\frac{1}{|H|}\sum_{e\mid d}\mu(d/e)q^e.
\tag{4}
\]

For every extension degree `n`, the residual therefore refines canonically by Frobenius degree:

\[
R_n\cong R_{\le2,n}\sqcup
\coprod_{\substack{d\mid n\\d>2}}a_d(H)\operatorname{Cay}(H,S).
\tag{5}
\]

The low-degree term contains the base and whatever quadratic `H`-orbits survive deletion.  Formula
(5) applies beyond the `PSL2/PGL2` sheets to cyclic, dihedral, `A4`, `S4`, `A5`, and subfield
subgroups without changing the higher-degree proof.  For `H=PGL_2(q)`,

\[
a_3=1,\quad a_4=q,\quad a_5=q^2+1,\quad a_6=q^3+q-1,
\]

and C370's `c_n` is exactly `sum_(d|n,d>2) a_d`.

For C333's four-target repair regions, convexity and `0 in P_C` turn repeated Minkowski sum into
ordinary dilation.  Thus every support function satisfies

\[
h_{P_n}(u)=h_{P_B}(u)+[2\mid n]h_{P_Q}(u)+c_nh_{P_C}(u).
\tag{6}
\]

Every linear service objective over every extension degree is therefore determined by three fixed
block optimizations.  The normal fan is independent of `n` across all odd degrees `n>=3`, and
separately across all even degrees `n>=4`; normalized regions converge to the regular-block shape,
and their four-dimensional volumes are mixed-volume polynomials in `c_n`, with coefficients split
only by extension parity.

### Scope and stop rule

The finite-field Möbius count, free high-degree `PGL_2` action, generic Cayley identification,
support-function additivity, and mixed-volume formalism are classical ingredients.  C389 may claim
only the fixed-point-deleted coloured residual theorem (5), its exact-degree functoriality, and the
family-specific repair consequences (6).  It begins with a focused audit of `PGL_2` actions on
irreducible polynomials and service-region direct-sum/product constructions.  Stop or narrow if a
source already states the deleted coloured theorem, or if the repair consequence gives no result
stronger than restating Minkowski additivity.  Integral IDP/normality and quadratic-scar values are
separate, non-free gates.

**Owned report:** `notes/2026-07-19-c389-universal-exact-degree-base-change.md`.

## Unqueued doors retained from the requested extraction

These were named parts of the free-upgrade/open-door search, so the discovery-track discriminator
puts them here rather than in the incidental discovery companion.  None receives a C-ID now.

### The quadratic block is the sole game obstruction, but is not free

C388 reduces every even extension to the same `G(Q)`.  Two obvious semilinear mirror attempts do
not remove that obstruction.  Frobenius `F:t->t^q` is fixed-point-free on quadratic non-base
points and commutes with every base-defined generator, but `F(t)=s_i(t)` has a Baer-subline-sized
solution set for the semilinear involution `s_i F`, so generator-nonadjacency does not hold before
deletion and would require a separate live-set analysis.
The twisted map `tau F` is also an involution, but its fixed equation is

\[
t^{q+1}=\delta,
\]

which has `q+1` quadratic solutions before deletion because the norm map onto `F_q^*` is
surjective.  Thus neither canonical semilinear pairing gives a free proof that `G(Q)=0`.
Evaluating `Q` remains unallocated and forbidden while C294 is paused.

### Integral normality and holes

The fractional regions stabilize by support functions, but the integral scheduling semigroups need
not inherit integer decomposition or normality.  A future gate could test the single regular block
`S_C` for IDP/normality and determine how base/quadratic holes behave under repeated semigroup sum.
This is potentially useful for C355-style scheduling, but it is not a theorem-level free corollary
and is not queued.

### Multiplicative graph invariants

Any disjoint-union multiplicative invariant factors immediately through C370/C389.  Examples are
the independence polynomial and hard-core partition function, adjacency characteristic polynomial,
and Ihara zeta function; additive spectra repeat with the exact-degree multiplicities.  These are
valid exact corollaries and may give representation-theoretic access to the Cayley block, but no
consumer or novelty gate presently raises them above exposition-level value.

### Cubic isolation is specific to the full `PGL2` sheet

For `H=PGL_2(q)`, exact degree three is one regular orbit, which makes C388's isolator work.  For
`H=PSL_2(q)`, the same layer is two isomorphic regular blocks, whose xor cancels without determining
the individual block nimber.  This determinant-sheet asymmetry is retained as a limitation of the
method, not allocated as a separate task.

## Prior-art and ownership boundary

The C370 audit remains the source-level record for Hollmann's base/quadratic/regular orbit theorem,
Tranchida's conic point--involution dictionary, and the service-allocation polytope definitions.
The broader literature on `PGL_2(q)` actions on irreducible polynomials makes exact-degree orbit
counts prior-art territory.  Neither successor may use “first,” “new,” or unqualified “to our
knowledge” wording without closing the recorded Semantic Scholar, zbMATH, MathSciNet, and
three-source forward-citation gaps.

C388 and C389 are crowns-owned theorem-packaging tasks.  Source-lane papers and other handoffs stay
read-only.  C388's reduction exposes `Q` as the only game obstruction but does not transfer ownership
of that obstruction or lift the explicit C294 pause.
