# C973 — carrier nuclei and Frobenius-quadric compression

**Lane:** `reed-solomon`  
**Date:** 2026-08-27  
**Status:** structural theorem proved; GF(27) nucleus saturation open  
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

## 5. Red-team verdict on the landed compression

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
- The coding application, recursive containment, simultaneous escape, and
  pointed secant saturation are separate claims and retain their own
  literature burden.

## 6. Paper-successor compression map

The clean dependency spine is

\[
 \text{recursive carrier}
 \longrightarrow
 \text{penultimate nucleus}
 \longrightarrow
 \text{digit stripping}
 \longrightarrow
 \text{nucleus secant saturation},                                    \tag{16}
\]

with simultaneous-marker escape handling the complement of the nucleus.

Recommended main-text changes for the separately allocated successor:

1. Define the maximal carrier intrinsically by (1), followed by its Pascal
   coordinates as a corollary.
2. Present the maximal-Lucas-union proposition as the statement that all
   coherently lifted lower nuclei land in this single penultimate nucleus.
3. State digit stripping immediately afterward as a filtration theorem for
   those nuclei.
4. Give (2)--(10) as one prime-power endpoint proposition, unifying the first
   binary and ternary carriers and locating the imported subline theorem.
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

## 7. Highest-value continuation

The next mathematical target is not another GF(27) normal-form table.  It is
to exploit the quotient graph (2) for `d=9` to prove (15).  The outer moment
cancellation is a dependence among nine points of

\[
              \{[1:t:t^9:t^{10}]:t\in\mathbf F_{27}\}\subset Q^+(3,27),
\]

while the desired nucleus point records the seven middle moments.  The most
promising routes are:

1. classify the relevant dependencies using the two rulings and semilinear
   fixed-point equation (10);
2. obtain an exchange theorem showing that a dependence can be chosen with
   nine distinct affine support points; or
3. prove the affine-plane two-point switch is saturating by interpreting its
   replacement quadratic as the second ruling of the quotient quadric.

The third route would turn the existing switch algebra into quotient
geometry; the first two could bypass the switch restriction entirely.

## 8. Secondary extension

The fixed-direction matrix lemma itself extends beyond GF(27).  Let
`K/F_3` have degree `m>=3`, let `H` be a trace hyperplane, let `phi` be a
nonzero polynomial of degree at most six, and fix `Z in K`.  On the affine
cosets of `gamma H`, some pair has

\[
 \phi(x)\phi(y)(x-y)+Z\{\phi(y)-\phi(x)\}\ne0.             \tag{17}
\]

For `Z=0`, a coset has at least two nonzero values.  For `Z!=0`, failure of
(17) makes `x+Z/phi(x)` constant on the nonzero values in every coset.  If
`m>3`, the resulting degree-seven polynomial would have too many roots even
after all six possible zeros of `phi` are removed.  For `m=3`, equality in
the root count forces two zeros in each coset and the constant-derivative
argument of the GF(27) proof gives the contradiction.  This generalization
is clean supplemental material, but (1), (2), and (14) have higher paper
value.

## 9. Acceptance boundary

Proved here: (1), the prime-power quotient (2)--(10), the locator/secant
dictionary (13), and the generalization (17).

Not proved here: nucleus saturation (14), its GF(27) instance (15), or the
split-and-collision assertion for the two-point switch.  No completeness
theorem for an ambient normal rational curve is used as a substitute for
these pointed nucleus-incidence statements.

