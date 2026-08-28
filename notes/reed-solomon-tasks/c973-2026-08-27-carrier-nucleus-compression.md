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
- The affine-plane quotient identities and fixed-direction matrix-
  nonsingularity lemma are structural, but they stop before root splitting.
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

## 9. Secondary extension

The fixed-direction matrix lemma itself extends beyond GF(27).  Let
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
(16)--(24), and the generalization (26).  The abstract subline/minimum-word
theorem within (16)--(21) is also available in the cited 2023 literature.

Not proved here: nucleus saturation (14), its GF(27) instance (15), or the
split-and-collision assertion for the two-point switch.  No completeness
theorem for an ambient normal rational curve is used as a substitute for
these pointed nucleus-incidence statements.
