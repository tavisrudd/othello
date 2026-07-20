# C389: universal exact-degree and repair base change

**Date:** 2026-07-19  
**Lane:** `crowns`  
**Verdict:** **THEOREM; EXACT FROBENIUS-DEGREE CAYLEY LAYERS AND TWO-PHASE REPAIR GEOMETRY**  
**Literature-audit depth:** **0 full text; 4 partial; 2 abstract/metadata only.**

## Result

Let `k=F_q`, let `H<=PGL_2(k)` be finite, and let `S` be a finite inverse-closed
coloured generating set of distinct nonidentity elements of `H`.  Let `W` be any finite set of
nonidentity base-defined words in `S`, and delete

\[
D=\bigcup_{w\in W}\operatorname{Fix}(w)
\]

from the projective line.  Edges of colour `s` join `x` to `sx`; loops and edges incident with
deleted vertices are omitted.  This includes the conic residual convention, where `W` contains
the prescribed pair products.

For `d>1`, let `E_d` be the geometric projective points whose least field of definition over `k`
is `F_(q^d)`.  Then

\[
|E_d|=N_d(q):=\sum_{e\mid d}\mu(d/e)q^e.
\tag{1}
\]

For every `d>2`, the set `E_d` is disjoint from `D`, is preserved by `H`, and is a disjoint union
of free `H`-orbits.  Consequently

\[
R(E_d)\cong a_d(H)\operatorname{Cay}(H,S),\qquad
a_d(H)=\frac{N_d(q)}{|H|}.
\tag{2}
\]

The exact-degree set `E_d` is canonical.  The displayed decomposition into individually labelled
Cayley copies requires a choice of one point in each orbit, so (2) asserts the exact coloured
isomorphism type rather than a canonical ordering of the copies.

For `K_n=F_(q^n)`, put `R_n=R(P1(K_n))` and let `R_{<=2,n}` be the induced residual on the base
points together with the exact-degree-two points when `2|n`.  Then the extension residual has the
canonical Frobenius-degree refinement

\[
\boxed{
R_n\cong R_{\le2,n}\sqcup
\coprod_{\substack{d\mid n\\d>2}}
a_d(H)\operatorname{Cay}(H,S).}
\tag{3}
\]

This is functorial under extension: a base-defined fractional-linear transformation commutes with
Frobenius and preserves the least field of definition, so the inclusion for `n|m` adds whole
exact-degree layers.  Formula (3) applies without a separate high-degree argument to cyclic,
dihedral, `A4`, `S4`, `A5`, subfield, `PSL_2`, and `PGL_2` subgroups whenever the stated `S` and
deletion data exist.  All exceptional stabilizers and all deletion remain confined to degree at
most two.

For `H=PGL_2(q)`, whose order is `q(q^2-1)`, (2) gives

\[
a_3=1,\qquad a_4=q,\qquad a_5=q^2+1,\qquad a_6=q^3+q-1.
\tag{4}
\]

Moreover, C370's regular-block coefficient is exactly

\[
c_n=\sum_{\substack{d\mid n\\d>2}}a_d(PGL_2(q)).
\tag{5}
\]

Thus C370's undifferentiated regular part is the sum of exact Möbius layers, not merely a point
count divided by the group order.

## Proof

For `d>1`, the projective point at infinity has degree one, so `E_d` is the set of elements of
`F_(q^d)` lying in no proper subfield.  The usual divisor-lattice identity

\[
q^d=\sum_{e\mid d}|E_e|
\]

and Möbius inversion prove (1).

If a nonidentity element of `PGL_2(k)` represented by
`[[a,b],[c,d]]` fixes an affine point `x`, then

\[
cx^2+(d-a)x-b=0.
\]

The polynomial is nonzero, and the point at infinity is already rational.  Hence every fixed point
of every nonidentity element has degree at most two.  It follows twice over that for `d>2`: no
word in `W` deletes a point of `E_d`, and no nonidentity element of `H` stabilizes such a point.
Thus `H` acts freely on `E_d`, proving that `a_d(H)` is an integer and that every orbit has size
`|H|`.

Choose `x` in one free orbit.  The map

\[
H\longrightarrow Hx,\qquad h\longmapsto hx
\]

takes the left-Cayley colour-`s` edge `h--sh` to `hx--shx`.  It is therefore a colour-preserving
isomorphism.  Finally, a point belongs to `P1(K_n)` exactly when its degree divides `n`; distinct
degree layers cannot be joined by a base-defined generator.  This proves (2) and (3).  Substituting
`|PGL_2(q)|=q(q^2-1)` into (1) proves (4), and summing the exact-degree point counts outside degrees
one and two proves (5).

### Geometric points are not places

The freeness statement is deliberately about **geometric points**, not closed points, degree-`d`
places, or irreducible polynomials.  A projectivity can stabilize a degree-`d` place by sending one
root to a Frobenius conjugate without fixing that root.  Reis counts precisely such invariant
irreducible polynomials, and Howe enumerates `PGL_2(k)`-orbits of places.  Their results therefore
preclude rephrasing `a_d(H)` as a general free-orbit count on irreducible polynomials.  C389 needs
only the geometric point layers because those points are the residual vertices.

## C333/C370 repair consequence

Return to a C333 four-target mirror member and use C370's blocks `B,Q,C` and fractional service
polytopes `P_B,P_Q,P_C` in `R^4`.  These polytopes are convex and contain the origin.  For a convex
set `P`, its `m`-fold Minkowski sum is the ordinary dilation `mP`.  Therefore C370's blockwise
allocation identity sharpens to the support-function law

\[
\boxed{
h_{P_n}(u)=h_{P_B}(u)+[2\mid n]h_{P_Q}(u)+c_nh_{P_C}(u)
\quad(u\in\mathbb R^4).}
\tag{6}
\]

Every linear service objective over every extension field is consequently obtained from the same
three block optimizations.  There is no new extension-sized linear program.

For polytopes, the normal fan of a Minkowski sum is the common refinement of the summands' normal
fans, and positive dilation does not change a normal fan.  Since `c_n>0` for odd `n>=3` and even
`n>=4`, the tower has two parity-stable normal-fan phase formulas:

\[
\mathcal N(P_n)=
\begin{cases}
\mathcal N(P_B)\wedge\mathcal N(P_C),&n\ge3\text{ odd},\\
\mathcal N(P_B)\wedge\mathcal N(P_Q)\wedge\mathcal N(P_C),&n\ge4\text{ even}.
\end{cases}
\tag{7}
\]

Here `wedge` denotes common refinement; the statement remains valid with lineality when a block is
not full-dimensional.  The two displayed fans may coincide for a special member, so this is an
at-most-two-phase theorem rather than a claim that parity must be geometrically distinguishable.
Degrees one and two are the two boundary exceptions because `c_1=c_2=0`.
Equivalently, the set of optimal faces for every objective direction has one stable odd pattern and
one stable even pattern, although the optimal values continue to scale with `c_n`.

Within either parity,

\[
\frac1{c_n}P_n\longrightarrow P_C
\tag{8}
\]

in Hausdorff distance as `n` tends to infinity.  In ambient dimension four, Minkowski's volume
polynomial gives the exact parity-split formulas

\[
\operatorname{Vol}_4(P_n)=
\sum_{j=0}^4\binom4j
V(P_B[4-j],P_C[j])c_n^j
\quad(n\text{ odd}),
\tag{9}
\]

and, with `P_E=P_B+P_Q`,

\[
\operatorname{Vol}_4(P_n)=
\sum_{j=0}^4\binom4j
V(P_E[4-j],P_C[j])c_n^j
\quad(n\text{ even}).
\tag{10}
\]

Equivalently, expanding `P_E` gives the multinomial mixed volumes of `P_B,P_Q,P_C`.  Formulas
(9)--(10) remain true when the four-volume or some coefficients vanish.  In particular, the leading
coefficient in both phases is `Vol_4(P_C)` and (8) also yields normalized-volume convergence.

## What is and is not new

The Möbius count of exact-degree finite-field elements, the quadratic fixed-point bound for a
fractional-linear map, orbit--stabilizer, Cayley coordinates on a free orbit, support-function
additivity, common refinement of normal fans, and mixed-volume polynomiality are classical.  The
surviving C389 synthesis is narrower:

1. arbitrary fixed-point-deleted, base-defined coloured residuals admit the exact functorial
   degree decomposition (3), with deletion proved absent from every high-degree layer;
2. C370's regular multiplicity is refined by the exact Möbius coefficients (2) and (5); and
3. for the C333 repair family, the block decomposition determines every linear objective, the
   exact two normal-fan phases, and the parity-split mixed-volume polynomials (6)--(10).

This report does not claim a new classification of `PGL_2` orbits, free action on irreducible
polynomials, a new theorem of convex geometry, integral IDP/normality, or any value for the
quadratic scar.  It does not resume C294.

## Focused literature audit

**Audit verdict:** **BOUNDED SURVIVAL; NO DIRECT DELETED-COLOURED COMPOSITION LOCATED; PRIORITY NOT
CLOSED.**  The point/placed-orbit literature and convex/service-polytope literature pre-empt all
generic ingredients.  The searches below did not locate the fixed-point-deleted coloured theorem
or its exact repair specialization, but the coverage gaps prohibit “first,” “new,” or an
unqualified “to our knowledge” sentence.

### Sources and read depth

- **Henk D. L. Hollmann,** *Nonstandard linear recurring sequence subgroups in finite fields and
  automorphisms of cyclic codes*. **Read depth: partial**, cached arXiv v1, Section 7 through
  Theorem 7.2 and its orbit argument.  It records the base orbit, quadratic orbit, and regularity
  beyond degree two for embedded `PGL_2`/`PSL_2`; C389 claims none of that orbit structure as new.
  Cache key `arXiv:0807.0595`, SHA-256
  `b807722d0849653d5138dfdb7a71a77dd66c6479a3b7f667fda68092b611363c`.
- **Lucas Reis,** *On the existence and number of invariant polynomials*. **Read depth: partial**,
  cached arXiv v1, Introduction, Definitions 1.1--1.2, Theorems 1.3--1.4, and the opening action
  lemmas of Section 2.  It studies `PGL_2(F_q)` fixed points on irreducible polynomials and shows
  why geometric-point freeness must not be transferred to places.  Cache key `arXiv:1811.02537`,
  SHA-256 `180b0a3682bbf0595823c090509ed6939d3da3d49868ef89848fbc14b64b47cd`.
- **Everett W. Howe,** *Enumerating places of `P1` up to automorphisms of `P1` in quasilinear
  time*. **Read depth: partial**, cached arXiv v2 (2025-10-21), Introduction through Theorem 1.1
  and Corollary 1.2.  It enumerates `PGL_2(F_q)`-orbits on degree-`n` places and uses Frobenius
  functions/divisors; it is adjacent prior art, but its vertices are closed places rather than the
  geometric residual points of (3).  Cache key `arXiv:2407.05534`, SHA-256
  `9b17e1d46ac2758781eb1c48853058fdfcdf1a8e3d3a201fd14215c5ff6d42d9`.
- **Gianira N. Alfarano, Altan B. Kilic, Alberto Ravagnani, and Emina Soljanin,** *The Service Rate
  Region Polytope*. **Read depth: partial**, cached arXiv v2, Sections 1.4 and 2 through Theorem
  2.3.  The allocation polytope and its linear projection pre-empt any claim that the blockwise
  service formalism is new.  Cache key `arXiv:2303.04021`, SHA-256
  `ffc9a8edbd513ad70b3336b27dd5fc475e4b4dad4665c10aed7c2794becffce4`.
- **Rolf Schneider,** *Convex Bodies: The Brunn--Minkowski Theory*, second expanded edition.
  **Read depth: abstract/metadata only**, Cambridge University Press frontmatter and contents for
  Chapters 3 and 5, DOI `10.1017/CBO9781139003858`.  It is recorded only as the standard monograph
  boundary for Minkowski addition and mixed volumes; no detailed attribution rests on unread text.
- **Gunter M. Ziegler,** *Lectures on Polytopes*. **Read depth: abstract/metadata only**, Springer
  book landing page, DOI `10.1007/978-1-4613-8431-1`.  It is recorded only as the standard polytope
  boundary; no section-level claim is attributed to it.

### Search sets and coverage

On 2026-07-19, OpenAlex's works search API was queried with these exact strings:

```text
fixed-point-deleted coloured residual PGL2 Cayley extension field
PGL(2,q) exact degree projective points free action
PGL(2,q) service rate region Minkowski sum
```

The successful responses had `meta.count` respectively `0`, `1961`, and `2`.  The first empty set
was distinguished from an API error.  The first three title/year/DOI rows of the broad second set
were screened and were unrelated algebraic-geometry/group-cohomology results; its poor precision
licenses no negative.  Both title/year/DOI rows of the third set were screened and were unrelated
topology/computer-science records.  The exact web searches for `PGL_2` exact-degree actions,
fixed-point-deleted residuals, and service-region Minkowski sums promoted Howe, Reis, and the
already-recorded service-polytope paper; no direct composition appeared in the returned results.

The same two focused composition searches sent to the Semantic Scholar Graph API failed with HTTP
429, so Semantic Scholar is **NOT COVERED**.  zbMATH and MathSciNet were not covered in this bounded
pass.  No citing-works set was enumerated, so there is no forward-citation closure.  Google Scholar
automation was unavailable.  These are access/coverage gaps, not empty searches.

## Evidence boundary

C389 is a proof-level consequence and creates no new computational artifact.  Equations (1)--(5)
are checked symbolically in the proof; the first four `PGL_2` coefficients provide direct arithmetic
cross-checks.  C332's committed independent checker already exercises representative `PGL_2` and
`PSL_2` base/quadratic/regular decompositions, fixed-point deletion support, and colour closure, but
it is not evidence for every finite subgroup `H`; that generality rests on the stabilizer proof
above.  C370 supplies the exact four-target blockwise allocation identity consumed by (6).

The trusted boundary is finite-field Möbius inversion, the degree-two fixed-point equation for a
nonidentity fractional-linear transformation, elementary group actions, and standard convex-body
identities.  Nothing here checks integral scheduling semigroups, integer decomposition, normality,
or the quadratic-scar game value.
