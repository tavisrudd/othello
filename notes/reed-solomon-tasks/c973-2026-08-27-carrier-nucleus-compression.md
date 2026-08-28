# C973 — carrier nuclei and Frobenius-quadric compression

**Lane:** `reed-solomon`  
**Date:** 2026-08-27  
**Status:** structural theorem and quotient-circuit classification proved;
GF(27) nucleus saturation open
**Scope:** mathematics and paper-successor map only; no manuscript, software,
Lean, or certificate edit

## 1. Executive compression

The maximal adjacent-zero Lucas carrier is not merely analogous to a normal-
rational-curve nucleus.  It is exactly the penultimate osculating nucleus of
the next normal rational curve.  If

\[
 C_d=\left\langle e_j\in\Gamma^{d+1}E:
       {d\choose j}={d\choose {j-1}}=0\pmod p\right\rangle,
\]

then, over every field large enough for the standard coordinate description
of nuclei,

\[
                         \mathbf P(C_d)=N^{(d-1)}\Gamma_{d+1}.       \tag{1}
\]

Thus the recursive-carrier theorem leaves two geometric objects: the
persistent catalecticant locus and one penultimate osculating nucleus.  The
remaining modular arithmetic is a rational secant-saturation question inside
that nucleus.

When `d=p^s`, projection from (1) has the uniform model

\[
 [1:t:t^2:\cdots:t^{d+1}]
       \longmapsto [1:t:t^d:t^{d+1}]
       = [1:t]\otimes[1:t^d]                             \tag{2}
\]

on the split quadric `Q^+(3)`.  It is the graph of the `p^s`-power
Frobenius.  The binary `d=8` and ternary `d=9` carriers are two arithmetic
instances of this same quotient geometry.

## 2. Universal carrier--nucleus theorem

Let

\[
 \Gamma_n=\{[1:t:\cdots:t^n]:t\in K\}\cup\{e_n\}
            \subset\mathbf P(\Gamma^nE)
\]

be the degree-`n` normal rational curve in divided-power coordinates.  If
`|K|>=a+1`, the order-`a` nucleus has coordinate support

\[
 N^{(a)}\Gamma_n
 =\mathbf P\left\langle e_j:
       {\ell\choose j}=0\pmod p
       \text{ for every }\ell=a+1,\ldots,n\right\rangle.             \tag{3}
\]

This is the standard Hasse-osculation criterion used in the manuscript as
`GmainerHavlicek2013`.

### Theorem 2.1

For every `d>=1` and every field `K` of characteristic `p` with `|K|>=d`,
the maximal adjacent-zero carrier satisfies (1).

### Proof

Apply (3) with `n=d+1` and `a=d-1`.  A coordinate `e_j` belongs to the
nucleus exactly when

\[
                         {d\choose j}={d+1\choose j}=0.                \tag{4}
\]

Pascal's identity gives

\[
                         {d+1\choose j}
                          ={d\choose j}+{d\choose {j-1}}.              \tag{5}
\]

Under the first equality in (4), the second equality in (4) is therefore
equivalent to `{d\choose j-1}=0`.  Conditions (4) are exactly the two
adjacent-zero conditions defining `C_d`.  This proves (1).  In the coding
range `q>=r=d+2`, the field-size hypothesis is automatic.  \(\square\)

### Consequences

1. `C_d` is intrinsic and `PGL_2`-stable because it is an intersection of
   osculating spaces.
2. The maximal-carrier coordinate formula is the Pascal-coordinate form of
   a classical nucleus, not a separate geometric object.
3. The digit-stripping exact sequences are exact sequences for penultimate
   nuclei, coupled to the already-defined Pascal nucleus modules `Z_d`.
4. Classical nucleus geometry may be imported for the object itself.  The
   paper-owned claims are its appearance as the terminal PRS carrier, the
   coherent contraction theorem, and the split-secant arithmetic on its
   rational points.

The last distinction is important for novelty language.  The adjacent-zero
coordinate recognition should not be sold as a new variety after (1); its
PRS role and arithmetic remain the substantive content.

## 3. Prime-power Frobenius-quadric quotient

Assume `d=p^s`.  Lucas' theorem says that the only nonzero entries in Pascal
row `d` occur at indices `0` and `d`.  The adjacent-zero condition therefore
gives

\[
                         C_d=\langle e_2,e_3,\ldots,e_{d-1}\rangle.    \tag{6}
\]

The quotient by this nucleus retains the four coordinate classes
`e_0,e_1,e_d,e_{d+1}`.  Hence the projected curve is (2).  In Segre
coordinates `(X_0,X_1,X_2,X_3)`, it lies on

\[
                              X_0X_3=X_1X_2.                            \tag{7}
\]

Equivariantly, the quotient module is the tensor product of the standard
two-dimensional module with its `s`th Frobenius twist, up to the common
divided-power convention:

\[
                    \Gamma^{d+1}E/C_d\simeq E\otimes E^{(s)}.          \tag{8}
\]

A hyperplane section of the quotient graph has equation

\[
                     A+Bt+Ct^d+Dt^{d+1}=0.                            \tag{9}
\]

Away from `C+Dt=0`, equation (9) is the semilinear fixed-point equation

\[
                         t^d=-\frac{A+Bt}{C+Dt}.                        \tag{10}
\]

This is the common geometry behind linearized root covers, projective
subline endpoints, and the Wang--Wu--Hu boundary criterion.  The imported
projective-subline theorem and the paper's carrier arithmetic should be
presented as arithmetic of (10), rather than as an unrelated Lucas-block
exception.

Two first higher carriers are now visibly parallel:

\[
\begin{array}{c|c|c|c}
 p&d&\mathbf P(C_d)&\text{quotient graph}\\ \hline
 2&8&\mathbf P\langle e_2,\ldots,e_7\rangle&[1:t:t^8:t^9]\\
 3&9&\mathbf P\langle e_2,\ldots,e_8\rangle&[1:t:t^9:t^{10}].
\end{array}                                                               \tag{11}
\]

The GF(64) cubic-resolvent/isogeny proof and the GF(27) affine-plane switch
are different arithmetic attacks on the two rows of the same geometric
table.

## 4. Secant-saturation formulation

Let `z=(z_0,\ldots,z_{d+1})` be a rational point of `C_d`, and let

\[
                              g(T)=\prod_{x\in S}(T-x)
                                  =\sum_{i=0}^d g_iT^i                 \tag{12}
\]

for a `d`-element subset `S` of `K`.  The Vandermonde recurrence gives

\[
 z\in\langle\Gamma_{d+1}(x):x\in S\rangle
 \quad\Longleftrightarrow\quad
 \sum_{i=0}^d g_i z_i=0,
 \quad
 \sum_{i=0}^d g_i z_{i+1}=0.                            \tag{13}
\]

Indeed, a representation by the `d` distinct moment columns implies (13) by
`g(x)=0`.  Conversely, the first `d` moments determine the coefficients of
the representation through the nonsingular Vandermonde matrix, and the two
recurrences force the remaining two moments.

This yields the intrinsic modular closure property

\[
 \mathrm{NS}(d,K):\quad
 N^{(d-1)}\Gamma_{d+1}(K)
 \subseteq
 \bigcup_{\substack{S\subset K\\|S|=d}}
       \langle\Gamma_{d+1}(S)\rangle.                                  \tag{14}
\]

The use of affine `S subset K` encodes avoidance of the normalized forbidden
point at infinity.  In the PRS language, (14) says that every point of the
maximal carrier has a pointed shallow locator of degree `d`.

For GF(27)/R11, (14) is exactly

\[
 N^{(8)}\Gamma_{10}(\mathbf F_{27})
 \subseteq
 \bigcup_{|S|=9,\ S\subset\mathbf F_{27}}
       \langle\Gamma_{10}(S)\rangle.                                  \tag{15}
\]

The two-point affine-plane switch proves a more structured sufficient
statement: it seeks `S` differing in exactly two points from an affine
trace-plane.  Its matrix nonsingularity does not prove (15), because the
replacement quadratic must still split without colliding.  Conversely, (15)
need not imply that a witness occurs in that switch family.  These statements
must remain distinct.

## 5. Frobenius-graph circuits and the relative-code form

Let `K=F_{p^e}`, put `d=p^s`, and let

\[
 \mathcal G_\sigma
 =\{([u:v],[u^d:v^d]):[u:v]\in\mathbf P^1(K)\}
 \subset \mathbf P(E)\times\mathbf P(E^{(s)})\subset\mathbf P^3(K),       \tag{16}
\]

where the last inclusion is the Segre embedding.  Write
`k=F_{p^g}` with `g=gcd(s,e)`, the fixed field of `x\mapsto x^d` on `K`.

### Theorem 5.1 (subline circuit theorem)

Four distinct points of `mathcal G_sigma` are coplanar if and only if their
parameters lie on a projective `k`-subline of `P^1(K)`.  No three graph
points are dependent.  Consequently the four-column circuits of the quotient
graph are exactly the quadruples lying on projective `k`-sublines.  When
`k=F_3`, the circuits are the sublines themselves.

### Proof

For four ordered points of a Segre quadric with distinct first and second
coordinates, coplanarity is equivalent to equality of the cross-ratios in
the two factors.  Indeed, apply independent projectivities in the factors
which send the first three pairs to

\[
                    (\infty,\infty),\quad(0,0),\quad(1,1).
\]

If the fourth pair is `(lambda,mu)`, the determinant of the four tensor
columns is, up to a nonzero factor, `mu-lambda`.  On (16), the second
cross-ratio is the `d`th power of the first.  Coplanarity is therefore

\[
                             \lambda^d=\lambda,                        \tag{17}
\]

or `lambda in k`.  The cross-ratio criterion for a projective subline now
gives the first assertion.  A line meets a smooth quadric in at most two
points unless it is a ruling line, while the graph has at most one point on
each line of either ruling.  Hence no three graph points are collinear, so
each coplanar quadruple is a circuit.  \(\square\)

This theorem is the two-factor, projective-line specialization of
Durante--Longobardi--Pepe, *`(d,sigma)`-Veronese variety and some
applications* (2023), Theorems 2.11 and 3.4
(<https://doi.org/10.1007/s10623-023-01186-9>).  The cross-ratio proof above
is useful here because it identifies the exact Frobenius-quadric coordinates,
but the subline characterization and minimum-word theorem are prior art.

For GF(27), `d=9` and `k=F_3`.  Thus the quotient matroid has a particularly
rigid first layer: every circuit has size four and is an `F_3`-subline.  The
number of such sublines is

\[
       \frac{|\operatorname {PGL}_2(27)|}
              {|\operatorname {PGL}_2(3)|}
       =\frac{19656}{24}=819.                                          \tag{18}
\]

Exactly `819*4/28=117` contain a prescribed point, so 702 avoid the forbidden
point at infinity.

This has an exact code interpretation.  Let `H_out` be the four-row matrix
with columns `[1:t:t^9:t^10]` on `P^1(F_27)`, and let `H_full` be the eleven-
row normal-rational-curve matrix of degree ten.  Then

\[
 C_{\rm full}=\ker H_{\rm full}\subset C_{\rm out}=\ker H_{\rm out},
 \qquad [28,17,12]\subset[28,24,4],                                   \tag{19}
\]

and `C_out/C_full` is the seven-dimensional carrier syndrome space.  The
GF(27) nucleus-saturation statement (15) is equivalent to:

> every class of `C_out/C_full` has a representative of weight at most nine
> whose coordinate at the forbidden point is zero.                    \(\tag{20}\)

Thus the last lemma is a pointed relative covering-radius statement, not an
unstructured search through degree-nine split polynomials.  The 819
weight-four circuit classes inject projectively into the carrier: two of
them cannot give the same carrier point, since their difference would be a
nonzero word of `C_full` of weight at most eight.  They form the
`PGL_2(27)`-orbit of

\[
                           [e_2+e_4+e_6+e_8].                           \tag{21}
\]

Shortening both codes at infinity and then deleting that zero coordinate
removes even the pointed qualifier.  Denote the resulting affine codes by
`D_full subset D_out`.  Their parameters and quotient are

\[
 [27,16,12]=D_{\rm full}\subset D_{\rm out}=[27,23,4],
 \qquad D_{\rm out}/D_{\rm full}\simeq C_d.                            \tag{22}
\]

Here the quotient isomorphism is the middle-moment syndrome map.  Therefore
(15) is exactly the relative covering-radius bound

\[
 \max_{c\in D_{\rm out}}
      \min_{w\in D_{\rm full}}\operatorname {wt}(c-w)\leq9.            \tag{23}
\]

The minimum words of `D_out` are precisely the 702 `F_3`-subline circuits
which avoid infinity.  Formula (23), rather than a collection of locator
charts, is the cleanest coding-theoretic statement of the unresolved lemma.

There is also a canonical polynomial model for this shortening.  Represent
every function on `F_27` uniquely by a polynomial of degree at most 26.  The
power-sum identity

\[
 \sum_{t\in F_{27}}t^m=0\quad(0\leq m<26),
 \qquad \sum_{t\in F_{27}}t^{26}=-1                         \tag{23a}
\]

shows that

\[
\begin{aligned}
D_{\rm full}&=\{(h(t))_t:\deg h\leq15\},\\
D_{\rm out}&=\{(f(t))_t:[t^{16}]f=[t^{17}]f
                         =[t^{25}]f=[t^{26}]f=0\}.          \tag{23b}
\end{aligned}
\]

Every relative coset therefore has the unique consecutive-tail
representative

\[
                         f(t)=\sum_{j=18}^{24}a_jt^j.       \tag{23c}
\]

The radius bound (23) says that every such seven-term tail agrees with a
degree-at-most-15 polynomial at 18 field points.  Equivalently, there must be
a squarefree split degree-18 polynomial `A` and a polynomial `ell` of degree
at most six such that the coefficients of `A ell` in degrees 18 through 24
are the prescribed `a_j`, while its degree-16 and degree-17 coefficients
vanish.  This is the complementary agreement-locator form of the original
degree-nine error locator.  It exposes the two missing coefficients directly
and may be preferable for polynomial-approximation or interpolation attacks.
Gao's prescribed-leading-coefficient framework
(<https://arxiv.org/abs/2105.12845>) is the relevant general counting
language for this formulation.  Its readily simplified one- and two-
coefficient cases do not imply positivity here: (23c) prescribes seven
leading coefficients and then imposes the two lower vanishings.  The large
average number of degree-18 root sets per tail is therefore heuristic only,
not a substitute for uniform nucleus saturation.

### Theorem 5.2 (universal prime-power tail)

The polynomial model extends verbatim.  Let `K=F_q`, let `d=p^s`, and assume
`q>=d+2`.  Shorten at infinity both the degree-`d+1` NRC code and its
four-row Frobenius-graph quotient.  Then

\[
\begin{aligned}
D_{\rm full}
 &=\{(h(t))_{t\in K}:\deg h\leq q-d-3\},\\
D_{\rm out}
 &=\{(f(t))_{t\in K}:
 [t^{q-1}]f=[t^{q-2}]f
 =[t^{q-d-1}]f=[t^{q-d-2}]f=0\},                     \tag{23d}
\end{aligned}
\]

and every quotient class has the unique representative

\[
                \sum_{j=q-d}^{q-3}a_jt^j.              \tag{23e}
\]

In particular,

\[
 \dim(D_{\rm out}/D_{\rm full})=d-2=\dim C_d,          \tag{23f}
\]

and the middle-moment syndrome identifies this quotient with the
penultimate nucleus `C_d`.  Nucleus saturation `NS(d,K)` is exactly

\[
 \max_{c\in D_{\rm out}}
      \min_{w\in D_{\rm full}}\operatorname {wt}(c-w)\leq d.           \tag{23g}
\]

The proof is the power-sum calculation (23a): the four outer moment rows
select the four missing coefficients in (23d), while all `d+2` NRC rows
leave precisely the degree bound for `D_full`.  An affine support of size at
most `d` is the same as agreement at at least `q-d` evaluation points.

Equivalently, every tail (23e) must differ from a low-degree polynomial by
`A ell`, where `A` is a squarefree split polynomial of degree `q-d` and
`deg ell<=d-3`; the top `d-2` coefficients are prescribed and the next two
coefficients vanish.  Thus the error-locator and complementary agreement-
locator pictures are a uniform dual pair for every prime-power carrier.

No uniform minimum-distance claim for `D_out` is added here.  Its first
circuits depend on the fixed field of the `d`-Frobenius as in Theorem 5.1;
the GF(27) parameters in (22) are the `Fix(sigma)=F_3` specialization.

One apparent shortcut is invalid.  For GF(27), the vector-space quotient
`D_full^perp/D_out^perp` has representatives in the seven middle monomials
`t^2,...,t^8`, and a nonzero polynomial of degree at most eight has only nine
possible root counts.  This does **not** let one apply Delsarte's external-
distance bound with value nine.  The relative Hamming metric is the minimum
weight of representatives inside `D_out`; its Fourier characters are cosets
modulo `D_out^perp`, whose weight spectra change after adding the four outer
rows.  Applying the ordinary external-distance theorem to `D_full` sees the
eleven nonzero dual weights of its MDS dual and recovers only the standard
radius bound 11.  A relative nine-weight theorem would itself require proof
of the missing quotient association scheme; it cannot be assumed.

The affine-plane locator now also has a circuit explanation.  Write
`v(t)=(1,t,t^9,t^10)` and `v(infinity)=(0,0,0,1)`.  For an affine
`F_3`-line `L=a+uF_3`, direct summation gives the quotient relation

\[
                  \sum_{t\in L}v(t)+u^{10}v(\infty)=0.                \tag{24}
\]

An affine plane is the disjoint union of three parallel such lines.  Adding
their relations cancels the three equal infinity coefficients in
characteristic three and leaves the nine finite columns, each with
coefficient one.  Hence the plane at the start of the two-point switch is
exactly a three-circuit cancellation in the quotient matroid.  This is the
structural reason its outer four moments vanish.

The compression is sharp but not yet closure.  Theorem 5.1 classifies the
elementary moves, while (20) asks for a uniformly short affine representative
in every quotient class.  A proof that the weight-four subline circuits
generate `C_out` would still not by itself control representative weight or
cancel the forbidden coordinate; moreover, Theorem 5.1 does not classify the
larger minimal dependencies.  The remaining useful target is therefore a
bounded circuit-decomposition theorem: three suitably incident subline
circuits, or a controlled circuit exchange from the plane relation (24),
must realize every carrier class with at most nine finite support points.

There is a sharp counting obstruction to the most obvious version.  The 117
subline circuits through infinity correspond to the affine `F_3`-lines of
`F_27`.  Normalize their infinity coefficients to one.  A sum of three such
circuits cancels infinity only when its three coefficients sum to zero,
leaving one projective coefficient parameter.  Hence all such triples produce
at most

\[
                   {117\choose3}(27+1)=7,283,640         \tag{24a}
\]

projective carrier directions, before accounting for repetitions, whereas
`PG(6,27)` has 402,321,277 points.  This family cannot prove (23).
Geometrically, a fixed nine-point support meets the carrier in a `P^4`, but
the canonical sum of its three line circuits explores only a `P^2` slice.
Any viable circuit proof must retain the full five-dimensional outer-
dependence space rather than only the distinguished circuit sum.

## 6. Red-team verdict on the landed compression

### Main-spine material

- The simultaneous-marker theorem replaces stagewise packages and is the
  correct off-carrier mechanism.
- The digit-stripping exact sequences, dimension formula, and empty-carrier
  criterion are the correct all-level carrier structure.
- The universal identity (1) is the intrinsic front door to that structure.
- The GF(64) étale cyclic-cubic/3-isogeny lemma is reusable arithmetic; it is
  stronger than the individual semilinear cases it replaces.

### Correct but proof-route-specific material

- The GF(27) three-line tower is an exact audit, not the preferred proof.
- The upper-Borel slice `z_3=z_6=0` is a boundary of that chosen chart and is
  only upper-Borel stable; it is not an intrinsic boundary of the carrier.
- The affine-plane quotient identities are structural.  The GF(27) fixed-
  direction matrix lemma is now superseded by the four-plane pencil through
  the removed affine line, which proves universal nonsingularity and stops
  only at root splitting and collision.
- The denominator-free discriminant and its norm form sharpen the remaining
  switch gate but do not supply abundance.

### Finite-evidence boundary

- The four torus-endpoint products, two `z_7` products, eleven Frobenius-orbit
  products in the `z_5` chart, and three `z_8` endpoint products are explicit
  finite witness bundles.  Their orbit reductions are structural; locator
  existence is still a finite table.
- They are smaller and more transparent than a census, but should not be
  described collectively as a certificate-free proof architecture.
- If (15) is proved uniformly, all of these products become independent
  audits and should stay out of the main text.

### Literature and novelty boundary

- Formula (1) is an immediate consequence of the classical osculating-
  nucleus criterion and Pascal's identity.
- The dimension formula for `C_d`, now recognized as a nucleus dimension,
  requires full-text comparison with the classical nucleus literature before
  any standalone novelty claim.
- The four-point Frobenius-graph circuit classification and associated
  minimum-word statement are special cases of Durante--Longobardi--Pepe
  (2023), not paper-owned results.  The C973 contribution is their emergence
  from the PRS nucleus quotient, the pointed shortening (22)--(23), and the
  affine-plane three-circuit cancellation (24).
- The coding application, recursive containment, simultaneous escape, and
  pointed secant saturation are separate claims and retain their own
  literature burden.

The same paper's Borel-normalized arc argument does not supply the missing
certificate-free GF(27) step.  Its Theorem 3.6 proves the twisted-cubic-track
statement structurally only in the stated `et>4` range; the text immediately
after the proof says that the orders 27 and 81 were checked with MAGMA.
Moreover that theorem concerns the six-coordinate
`(1,1,sigma)`-Veronese track, not the hyperplane-blocking family (25b).
Thus it is useful precedent for the normalization strategy, but importing its
GF(27) endpoint would restore a finite computation rather than prove (15).

## 7. Paper-successor compression map

The clean dependency spine is

\[
 \text{recursive carrier}
 \longrightarrow
 \text{penultimate nucleus}
 \longrightarrow
 \text{digit stripping}
 \longrightarrow
 \text{nucleus secant saturation},                                    \tag{25}
\]

with simultaneous-marker escape handling the complement of the nucleus.

Recommended main-text changes for the separately allocated successor:

1. Define the maximal carrier intrinsically by (1), followed by its Pascal
   coordinates as a corollary.
2. Present the maximal-Lucas-union proposition as the statement that all
   coherently lifted lower nuclei land in this single penultimate nucleus.
3. State digit stripping immediately afterward as a filtration theorem for
   those nuclei.
4. Give (2)--(10) as one prime-power endpoint proposition, followed by the
   subline circuit theorem (16)--(24); this unifies the first binary and
   ternary carriers and locates the imported subline theorem.
5. State the unresolved arithmetic uniformly as (14), rather than as an
   indefinite list of future R11+ orbit problems.
6. Keep the characteristic-seven one-carry corollary and the GF(64) isogeny
   corollary as examples of two ways nucleus saturation can be proved.
7. Do not add GF(27) to the paper until (15) is proved and independently
   reviewed.

If GF(27) closes through (15), the three-line tower, Borel chart inventory,
and finite locator tables should be supplemental audits, not a second main
proof.  If it closes only by the two-point switch, retain the quotient
identity and final splitting lemma but still omit the abandoned three-line
tower.

## 8. Highest-value continuation

The next mathematical target is not another GF(27) normal-form table.  It is
to strengthen Theorem 5.1 into a bounded circuit-exchange theorem proving
(15).  The outer moment cancellation is a dependence among nine points of

\[
              \{[1:t:t^9:t^{10}]:t\in\mathbf F_{27}\}\subset Q^+(3,27),
\]

while the desired nucleus point records the seven middle moments.  The most
promising routes are:

1. show every class of `C_out/C_full` is a sum of at most three subline
   circuit classes with union of affine supports of size at most nine and
   zero forbidden coordinate;
2. prove a circuit exchange from (24) that replaces two plane points while
   preserving a nine-point affine support; or
3. interpret the replacement quadratic in the existing switch as the
   incidence condition for three projective `F_3`-sublines.

The third route would turn the existing switch algebra into quotient
geometry; the first two could bypass the switch restriction entirely.

### 8.1 Exact dual blocking-line formulation

There is a sharper syndrome-independent form of the target.  For a monic
degree-nine locator

\[
                        g(t)=\sum_{i=0}^9g_it^i
\]

put

\[
 a_g=(g_1,g_2,\ldots,g_7),\qquad
 b_g=(g_2,g_3,\ldots,g_8)\in C_9^*,                   \tag{25a}
\]

and let \(\ell_g=\mathbf P\langle a_g,b_g\rangle\), with the evident
point interpretation if the rank drops.  The two equations (13) say exactly

\[
             z\in\langle\Gamma_{10}(S)\rangle
       \quad\Longleftrightarrow\quad
             \ell_g\subset z^\perp,                  \tag{25b}
\]

where \(g=\prod_{x\in S}(t-x)\).  Consequently (15) is equivalent to the
following finite-geometric statement:

> The lines \(\ell_g\) belonging to split squarefree affine nonics form a
> hyperplane-blocking family in \(\mathbf P(C_9^*)=\mathrm{PG}(6,27)\):
> every hyperplane contains at least one of them.

This duality removes the syndrome and all switch coordinates from the
statement.  It also gives a particularly economical sufficient lemma.  If
the split-locator lines contain a line spread of some
\(\Sigma\cong\mathrm{PG}(3,27)\subset\mathrm{PG}(6,27)\), then (15) holds.
A line spread of \(\Sigma\) has only

\[
                              27^2+1=730               \tag{25c}
\]

lines.  Every hyperplane of \(\mathrm{PG}(6,27)\) meets \(\Sigma\) in at
least a plane.  Every plane of \(\Sigma\) contains exactly one spread line:
if it contained none, the \(27^2+1\) spread lines would contribute only
\(27^2+1\) intersection points, fewer than the \(27^2+27+1\) points of the
plane; and two contained spread lines cannot be disjoint inside a plane.
Thus (25b) proves the claim.

The number in (25c) is optimal for any blocking-line package, without a
spread hypothesis.  In \(\mathrm{PG}(6,q)\) there are

\[
 H_6=q^6+q^5+q^4+q^3+q^2+q+1
\]

hyperplanes, and one line is contained in

\[
 H_4=q^4+q^3+q^2+q+1
\]

of them.  Hence an incidence count gives

\[
 |\mathcal L|\ge \left\lceil\frac{H_6}{H_4}\right\rceil
 =\left\lceil q^2+\frac{q+1}{H_4}\right\rceil=q^2+1.   \tag{25c'}
\]

An embedded line spread therefore realizes the smallest possible
syndrome-independent proof package of this type.

The spread package is not yet constructed.  It is nevertheless a strict
compression of the desired certificate-free endpoint: instead of selecting
a locator separately for 402,321,277 projective syndromes, it is enough to
realize one structured set of 730 Hankel lines by split affine nonics.  The
overlap in (25a) is load-bearing; an arbitrary abstract spread cannot be
imported without proving that its lines have consecutive-window form and
split locators.

The most obvious coordinate realization is impossible for a structural
reason.  If both windows (25a) lie in the coordinate four-space supported in
their first four positions, then

\[
             g=t^9+at^4+bt^3+ct^2+dt+e.               \tag{25d}
\]

If this monic polynomial is split and squarefree over \(K=\mathbf F_{27}\),
then \(g\mid t^{27}-t\).  Write the lower part of (25d) as \(h\).  Modulo
\(g=t^9+h\), the divisibility condition is

\[
                         h^3+t\equiv0\pmod g.          \tag{25e}
\]

Reducing the terms \(t^{12}=t^3t^9\) and \(t^9\), the remainder is

\[
 -a^3t^3h-b^3h+c^3t^6+d^3t^3+e^3+t.                  \tag{25f}
\]

Its \(t^7\)-coefficient is \(-a^4\), so \(a=0\); its resulting
\(t^6\)-coefficient is \(c^3\), so \(c=0\).  The three remaining
coefficients give

\[
             d^3=b^4,\qquad b^3d=1,
             \qquad e^3=b^3e.                          \tag{25g}
\]

Thus \(b\ne0\), \(b^{13}=1\), \(d=b^{-3}\), and
\(e(e^2-b^3)=0\).  Conversely these conditions make (25e) vanish; the
derivative \(d\) is nonzero, so the polynomial is squarefree and all nine
roots lie in \(K\).  The 13 choices of \(b\) and three choices of \(e\) are
exactly the 39 affine-plane locators.  Their Hankel lines depend only on
\(b,d\), hence give only 13 lines in a coordinate plane, not a 730-line
spread.  Any spread proof must therefore use a genuinely non-coordinate
four-space (or a different blocking-line family); a low-coefficient
perturbation of the affine planes cannot work.

There is a second exact obstruction to making the affine planes global by
projective transport.  For a fixed affine-plane direction, all 27
translations of the parameter and the two scalars in \(\mathbf F_3^*\)
preserving the direction fix its Hankel line.  Its stabilizer in
\(\mathrm{PGL}_2(27)\) therefore has order at least 54, so its complete
projective orbit has at most

\[
             \frac{|\mathrm{PGL}_2(27)|}{54}
             =\frac{27(27^2-1)}{54}=364               \tag{25h}
\]

distinct Hankel lines.  This is below the unconditional lower bound 730 in
(25c').  Hence even all Möbius transforms of the affine-plane Hankel line
cannot be hyperplane-blocking.  Pointedness can only shrink the usable part
of this orbit.

The corresponding positive orbit target must start from a genuinely
non-plane split nine-set with small stabilizer.  For such a locator line
\(\ell\), the incidence condition

\[
                         h\ell\subset z^\perp,
             \qquad h\in\mathrm{PGL}_2(27),            \tag{25i}
\]

is two matrix-coefficient equations on the three-dimensional group and is
therefore generically a curve.  A free orbit has 19,656 group elements, so
its heuristic incidence count is about
\(|\mathrm{PGL}_2(27)|/27^2\approx27\), before deleting transforms whose
support contains infinity.  A union of three nonparallel affine
\(\mathbf F_3\)-lines is a natural split seed because its transformed
locator retains characteristic-three cubic factorization.  The next
structural calculation is the genus and boundary divisor of (25i), not
another four-point pencil character table.  No abundance claim is made here:
irreducibility, rational points, and the nine pole exclusions all remain to
be proved.

The digit-stripping filtration gives an even sharper obstruction to the
most natural spread.  Since \(9=3\cdot3+0\), sequence (1) specializes to the
nonsplit exact sequence

\[
 0\longrightarrow
   \det^2\otimes(\Gamma^2E)^{(1)}
 \longrightarrow C_9
 \longrightarrow E\otimes(Z_3)^{(1)}
 \longrightarrow0,                                      \tag{25j}
\]

whose dimensions are \(3,7,4\).  The left submodule has coordinate support
\(e_2,e_5,e_8\).  After dualizing, the annihilator of that submodule is a
canonical four-dimensional submodule

\[
 \Sigma_0=\langle e_3^*,e_4^*,e_6^*,e_7^*\rangle
                              \subset C_9^*.             \tag{25k}
\]

This is the representation-theoretically preferred \(\mathrm{PG}(3)\), but
it contains no split-locator Hankel line.  Indeed, (25a) gives

\[
 \ell_g\subset\mathbf P(\Sigma_0)
 \quad\Longrightarrow\quad
 g_1=g_2=g_4=g_5=g_7=g_8=0,
\]

and hence

\[
                    g=t^9+g_6t^6+g_3t^3+g_0.           \tag{25l}
\]

Its derivative is identically zero, so it cannot be squarefree.  Thus the
canonical four-space suggested by the four-dimensional quotient is entirely
evacuated by the split locus.  This is the locator-line shadow of the
nonsplitting in (25j): a successful spread must be non-invariant, while an
inductive proof must transport pointed abundance through the extension
rather than choose an equivariant complement.

This inseparability obstruction is uniform.  Let \(p\) be odd and
\(d=pD\).  In the zero-terminal-digit instance of sequence (1), its left
submodule has coordinate support

\[
             j=ph+b,\qquad 0\le h\le D-1,\quad2\le b\le p-1.         \tag{25m}
\]

Let \(Q^*\subset C_d^*\) be the annihilator of that submodule.  The two
locator windows evaluate on coordinate \(e_j\) as \(g_{j-1}\) and \(g_j\).
Therefore

\[
 \ell_g\subset\mathbf P(Q^*)
 \quad\Longrightarrow\quad
 g_{ph+b-1}=g_{ph+b}=0
 \quad(2\le b\le p-1).                                  \tag{25n}
\]

As \(b\) varies, (25n) kills every coefficient \(g_i\) with
\(i\not\equiv0\pmod p\).  Thus \(g\in K[t^p]\), so \(g'=0\) and no
positive-degree such locator is squarefree.  The binary case is excluded
because the left term is empty when \(p=2,a=0=p-2\).

Hence, in every odd-characteristic zero-terminal-digit carrier, pointed
split abundance is invisible on the quotient side of the associated graded.
It necessarily uses the leakage across the nonsplit extension.  This is a
general obstruction to proving the carrier theorem by independent abundance
statements on the digit-stripping factors.

### 8.2 The three-dimensional digit submodule is saturated

The same filtration nevertheless closes one intrinsic GF(27) stratum.  Put

\[
                         A=\langle e_2,e_5,e_8\rangle\subset C_9.     \tag{25o}
\]

Restriction gives an equivariant map \(C_9^*\to A^*\).  For a locator line
its two projected vectors are

\[
              \bar a_g=(g_1,g_4,g_7),\qquad
              \bar b_g=(g_2,g_5,g_8).                 \tag{25p}
\]

If \(z\in\mathbf P(A)\), condition (25b) depends only on these vectors:

\[
              \ell_g\subset z^\perp
       \quad\Longleftrightarrow\quad
              \langle\bar a_g,\bar b_g\rangle
                         \subset z^\perp\subset A^*.   \tag{25q}
\]

As an \(\mathrm{SL}_2\)-module, \(A\) is a determinant twist of the
Frobenius twist of \(\Gamma^2E\).  Thus \(\mathbf P(A^*)\) has its usual
conic, which in the coordinates (25p) may be written

\[
                               Y^2=XZ.                 \tag{25r}
\]

The projected Hankel point of an affine-plane locator
\(t^9+Bt^3+Dt+C\) lies on this conic, and projective transport supplies all
its rational points.  Consequently every \(z\in\mathbf P(A)\) whose polar
line meets (25r) is covered by a projective transform of an affine plane.
The transform can be chosen affine.  Indeed, its remaining freedom contains
the Borel stabilizer of the chosen conic point.  That stabilizer fixes one
parameter point, omitted by the starting affine plane, and is transitive on
the other 27; hence some transform keeps infinity out of the nine-point
support.

It remains only the anisotropic quadratic orbit, whose polar lines are the
external lines to (25r).  This orbit has a uniform split seed.  Write

\[
                         L_p(t)=t^3+pt.
\]

The direction parameters \(p=-\alpha^2\) are nonsquares because
\(-1\) is a nonsquare in \(K\).  Choose a square \(c\ne1\) for which
\(c-1\) is also a square, and put \(r=cp\).  Such choices exist: the standard
quadratic-character sum gives exactly

\[
 \#\{c:\chi(c)=\chi(c-1)=1\}=\frac{27-3}{4}=6.         \tag{25s}
\]

Let \(W_p=\operatorname {im}L_p\).  The image under \(L_p\) of the
one-dimensional line \(\ker L_r\) is a nonzero one-dimensional subspace of
\(W_p\).  Choose \(\eta\in W_p\) outside it and set

\[
                    g=(L_p+\eta)(L_p-\eta)L_r.         \tag{25t}
\]

The three affine \(\mathbf F_3\)-lines in (25t) are pairwise disjoint, so
\(g\) is a split squarefree affine nonic.  In the three-line coefficient
formulas its parameters are \(u=s=0\) and \(v=-\eta^2\).  Therefore (25p)
is the line spanned by

\[
                 (rv,0,r-p),\qquad(0,p(p-r),0).        \tag{25u}
\]

A point obtained by adding \(\lambda\) times the second vector to the first
lies on (25r) exactly when

\[
                    \lambda^2=\frac{rv}{p^2(r-p)}.     \tag{25v}
\]

Here \(r\) and \(v=-\eta^2\) are both nonsquares, while
\(r-p=p(c-1)\) is a nonsquare.  The right side of (25v) is consequently a
nonsquare.  The line (25u) is external to the conic.

By transitivity, projective transforms of (25t) cover the entire anisotropic
orbit in \(\mathbf P(A)\).  Pointedness costs nothing: a nonsplit torus in
the stabilizer of an anisotropic quadratic acts regularly on the 28 points
of \(\mathbf P^1(K)\).  Among the 28 transforms in this torus fibre, exactly
the nine whose pole lies in the support of (25t) are forbidden, leaving 19
affine transforms.  Combining this with the isotropic case proves

\[
 \boxed{\quad
   \mathbf P(A)(K)\subseteq
   \bigcup_{|S|=9,\ S\subset K}\langle\Gamma_{10}(S)\rangle .
 \quad}                                                \tag{25w}
\]

Thus the full three-dimensional digit submodule is certificate-free
saturated.  The unresolved GF(27) theorem is now confined to points with
nonzero image in the four-dimensional quotient of (25j), where the
nonsplit leakage remains essential.

### 8.3 The four-dimensional quotient has seven intrinsic orbits

Since \(Z_3\simeq\det\otimes E\), the quotient in (25j) is, up to a
determinant character,

\[
                         Q\simeq E\otimes E^{(1)},      \tag{25x}
\]

where \((1)\) denotes the cube Frobenius \(\sigma:x\mapsto x^3\).
This gives a short intrinsic orbit inventory for the remaining lifting
problem.

Rank-one tensors form the Segre quadric
\(\mathbf P(E)\times\mathbf P(E^{(1)})\).  After untwisting the second
factor, the diagonal action is the ordinary diagonal action on ordered pairs
of projective-line points.  It therefore has exactly two orbits:

\[
 \begin{array}{c|c|c}
 \text{rank-one type}&\text{size}&\text{stabilizer size}\\ \hline
 \text{Frobenius graph}&28&702,\\
 \text{off graph}&28\cdot27=756&26.
 \end{array}                                                       \tag{25y}
\]

For an invertible tensor, use the alternating form on \(E\) to identify its
projective class with an element of \(G=\mathrm{PGL}_2(27)\).  The tensor
action becomes, up to the discarded determinant scalar,

\[
                         M\longmapsto gM\sigma(g)^{-1}. \tag{25z}
\]

Thus its orbits are the \(\sigma\)-twisted conjugacy classes of \(G\).
Shintani descent identifies these with the ordinary conjugacy classes of the
fixed group

\[
                         G^\sigma=\mathrm{PGL}_2(3)\cong S_4.        \tag{25aa}
\]

There are exactly five.  Labelled by the cycle types in \(S_4\), their
twisted centralizer and orbit sizes are

\[
\begin{array}{c|c|c}
1&24&819\\
(12)&4&4914\\
(12)(34)&8&2457\\
(123)&3&6552\\
(1234)&4&4914.
\end{array}                                                         \tag{25ab}
\]

The checksum

\[
 28+756+819+4914+2457+6552+4914
   =20440=|\mathrm{PG}(3,27)|                                      \tag{25ac}
\]

accounts for every quotient point.  Hence the open part of the GF(27)
theorem is a lifting problem over seven quotient types: two rank-one types
and five Shintani types.  This is substantially smaller and more intrinsic
than a Borel coordinate inventory, but it is not seven carrier orbits.  The
fibre over a normalized quotient point is an affine copy of the
three-dimensional kernel \(A\), and its stabilizer acts through the
nonsplit cocycle in (25j).  Controlling those affine fibres while retaining
nine-point support is precisely the remaining leakage problem.

In the digit coordinates the quotient tensor may be arranged as

\[
                       M_z=\begin{pmatrix}
                              z_3&z_6\\ z_4&z_7
                            \end{pmatrix},
 \qquad             \det M_z=z_3z_7-z_4z_6.            \tag{25ad}
\]

This gives the intrinsic meaning of the earlier Borel inventory.  The true
quotient boundary is the rank-one quadric \(\det M_z=0\).  The condition
\(z_3=z_6=0\) used in the three-line reduction is only a Borel gauge slice
through that quadric, not an intrinsic carrier boundary.  Its projective
rank-one points belong to the two orbits in (25y), while the complement of
the quadric decomposes into the five Shintani types in (25ab).  Future
normal-form work should therefore be indexed by these seven quotient types
and the affine kernel cocycle, not by the accidental vanishing of one tensor
row.

That cocycle is already explicit.  Use the coordinate section
\(Q=\langle e_3,e_4,e_6,e_7\rangle\) of (25j).  Upper translation by
\(u\) sends a divided-power coordinate by

\[
                  e_j\longmapsto
                  \sum_{k\ge j}{k\choose j}u^{k-j}e_k.
\]

For \(q=q_3e_3+q_4e_4+q_6e_6+q_7e_7\), its component in the kernel
\(A\) is therefore

\[
 \kappa_u(q)=
   (q_3u^2-q_4u)e_5
  +(-q_3u^5+q_4u^4+q_6u^2-q_7u)e_8.                  \tag{25ae}
\]

The missing \(e_2\)-motion is supplied by the opposite unipotent, obtained
by conjugating (25ae) with inversion.  Thus the remaining leakage is a
concrete Frobenius-weighted polynomial cocycle of degrees \(1,2,4,5\), not
an unspecified extension class.  On the rank-one quotient stabilizers this
is the intrinsic source of the earlier Borel normal forms.  The five
full-rank Shintani stabilizers are finite, so group normalization alone
cannot sweep their three-dimensional affine fibres; an additional split
support family is still required there.

There is one final cohomological reduction.  The seven stabilizer orders in
(25y) and (25ab) are

\[
                         702, 26, 24, 4, 8, 3, 4.  \tag{25af}
\]

Whenever the stabilizer order is prime to three, Maschke averaging splits
the restriction of (25j), equivalently the restricted affine cocycle is a
coboundary.  Thus four quotient types are immediately tame:

\[
 \text{off-graph rank one},\quad(12),\quad(12)(34),\quad(1234).      \tag{25ag}
\]

Three types remain after Maschke alone:

\[
 \text{Frobenius graph},\quad1,\quad(123).             \tag{25ah}
\]

Their stabilizers have orders \(702,24,3\), respectively.  The last two also
split after a cohomology calculation.  For \(C_3=\langle U\rangle\), the
module \(A\), up to determinant, is one unipotent Jordan block of size three.
Writing \(U=1+N\) gives

\[
 1+U+U^2=N^2,\qquad \ker N^2=\operatorname {im}N,
\]

so the cyclic cohomology formula yields

\[
 H^1(C_3,A)=\ker(1+U+U^2)/(U-1)A=0.                  \tag{25ai}
\]

For the identity Shintani type, restriction from \(S_4\) to a Sylow
\(C_3\) is injective on first cohomology: restriction followed by
corestriction is multiplication by the index eight, which is invertible in
characteristic three.  Hence

\[
                              H^1(S_4,A)=0.             \tag{25aj}
\]

Consequently six of the seven quotient stabilizers admit a linear section of
(25j).  The only genuinely wild affine fibre is the Frobenius-graph
rank-one type, whose Borel stabilizer contains the full 27-element translation
group.  This does not prove split-support abundance on the six tame fibres:
it linearizes their kernel action but does not manufacture locators.  It does
identify the old Borel residue as the unique cohomological obstruction.

## 9. Secondary extension

Although it is no longer the preferred GF(27) proof, the fixed-direction
matrix lemma itself extends beyond GF(27).  Let
`K/F_3` have degree `m>=3`, let `H` be a trace hyperplane, let `phi` be a
nonzero polynomial of degree at most six, and fix `Z in K`.  On the affine
cosets of `gamma H`, some pair has

\[
 \phi(x)\phi(y)(x-y)+Z\{\phi(y)-\phi(x)\}\ne0.             \tag{26}
\]

For `Z=0`, a coset has at least two nonzero values.  For `Z!=0`, failure of
(26) makes `x+Z/phi(x)` constant on the nonzero values in every coset.  If
`m>3`, the resulting degree-seven polynomial would have too many roots even
after all six possible zeros of `phi` are removed.  For `m=3`, equality in
the root count forces two zeros in each coset and the constant-derivative
argument of the GF(27) proof gives the contradiction.  This generalization
is clean supplemental material, but (1), (2), and (14) have higher paper
value.

## 10. Acceptance boundary

Proved here: (1), the prime-power quotient (2)--(10), the locator/secant
dictionary (13), the direct specialization proof and relative-code reduction
(16)--(24), the dual blocking-line equivalence and optimal lower bound
(25a)--(25c'), the inseparable associated-graded obstruction
(25j)--(25n), saturation of the full digit kernel (25w), the seven-type
quotient orbit inventory (25x)--(25ad), and the generalization (26).  The
abstract subline/minimum-word theorem within (16)--(21) is also available in
the cited 2023 literature.

Not proved here: full nucleus saturation (14), the points of its GF(27)
instance (15) with nonzero four-dimensional quotient, the seven corresponding
affine-kernel lifting statements, or the split-and-collision assertion for
the two-point switch.  No completeness theorem for an ambient normal
rational curve is used as a substitute for these pointed nucleus-incidence
statements.
