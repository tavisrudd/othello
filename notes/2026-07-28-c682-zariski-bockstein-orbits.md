# C682 Zariski Bockstein globalization and four-orbit quotient

## Outcome

The formal \(\mathbf Z_{11}\) pencil algebraizes.  More precisely, let
\(\mathscr R\) be the marked binary-icosahedral presentation scheme over
\(\mathbf Z_{(11)}\), and let \(x\) be the selected Dickson special point.
There is an actual \(2.A_5\)-stable affine open neighborhood
\[
 x\in U\subset\mathscr R
\]
on which the invariant dodecic, the divided Bockstein section, and the
invariant pencil are algebraic.  After shrinking \(U\), their relative
intersection
\[
 \mathscr Z=
 U_{22,U}\cap
 \mathbf P(\ker c_\omega\cap\ker Q_I)
\longrightarrow U
\]
is finite etale of degree \(22\), and
\[
 r=\frac{8\epsilon}{7\eta_I}
\]
is regular on all of \(\mathscr Z\).  Its pullback to the completion at
\(x\) is the previously certified formal pencil.  The generic fibre
\(U_{\mathbf Q}\) is therefore the requested characteristic-zero Zariski
neighborhood, not merely a formal or pointwise \(11\)-adic lift.

The \(A_5\)-quotient
\[
 \mathscr Y=\mathscr Z/A_5\longrightarrow U
\]
is finite etale of degree four.  Its four geometric points have stabilizers
\[
 A_5,\qquad A_4,\qquad D_5,\qquad S_3
\]
and orbit sizes
\[
 1,\qquad5,\qquad6,\qquad10.
\]
After inverting \(11\), the normalized pencil \(r\) separates these four
branches on a nonempty Zariski open of \(U_{\mathbf Q}\).  Thus the four
values are the four points of the stabilizer-labelled quotient, not four
unrelated coordinate accidents.

## Why the formal division algebraizes

Let \(V\) be the universal rank-two bundle on the selected presentation
neighborhood and put \(E=\operatorname{Sym}^6V\).  The five presentation
constraints have Jacobian rank five at \(x\), so \(\mathscr R\) is smooth
over \(\mathbf Z_{(11)}\) there.  The conjugation orbit has the same
three-dimensional tangent space: the marked binary representation is
irreducible, so its projective centralizer is finite.  Hence, after
shrinking, the special fibre of \(U\) is the conjugation orbit of the
marked Dickson point.

Because \(11\nmid120\), the Reynolds projector is defined over
\(\mathcal O_U\).  Its rank-one image in
\(\operatorname{Sym}^{12}V\) is the invariant dodecic line
\(\mathscr L\).  On the open where the frozen coefficient is a unit, choose
its normalized generator \(I\).  Its reduction is a coordinate conjugate of
\[
 \bar F=X^{11}Y-XY^{11}.
\]

The primitive covariants
\[
\begin{aligned}
 C_{11}(I)&=B_{11}(\pi_{12}(-),I),\\
 C_{12}(I)&=B_{12}(\pi_{12}(-),I)
\end{aligned}
\]
vanish on the entire special fibre: they vanish at \(\bar F\), and
Clebsch--Gordan covariance carries that vanishing along its conjugation
orbit.  Smoothness makes \(\mathcal O_U\) flat over
\(\mathbf Z_{(11)}\), so coefficientwise special-fibre vanishing is exactly
membership in \(11\mathcal O_U\).  Division is therefore unique and
algebraic:
\[
 Q_I=C_{11}(I)/11,\qquad
 \eta_I=C_{12}(I)/11.
\]
This elementary flat-division step is what the formal calculation alone did
not supply.  It also proves base-change compatibility.

## Why the \(22\)-section is Zariski local

Define \(\mathscr Z\) in the relative Grassmannian by the nine
fifth-transvectant isotropy equations and the three rows of \(Q_I\).
At every one of the \(22\) special points their Grassmann-chart Jacobian has
rank \(12\).  The complete special fibre is the already certified reduced
length-\(22\) section.  Consequently \(\mathscr Z\to U\) is etale at every
point of that fibre.  Projectivity and upper semicontinuity allow \(U\) to
be shrunk so that the whole morphism is finite etale of degree \(22\).

The denominator \(7\eta_I\) is a unit at all \(22\) special points.  Removing
its closed vanishing image makes \(r\) regular on the complete relative
section.  Since \(60\) is a unit, taking \(A_5\)-invariants is an exact
direct summand of the finite-etale algebra.  The quotient \(\mathscr Y\) is
therefore finite etale of degree four.  The ranks of the subgroup-fixed
summands are locally constant, so its four orbit types remain
\(A_5,A_4,D_5,S_3\) throughout the neighborhood.

This is a Zariski globalization of the family and quotient.  It does not
claim that the four individual branches split as four global sections
without passing to an etale neighborhood.

## The four values

In the split completion let
\[
 e_1,e_5,e_6,e_{10}
\]
be the four primitive orbit idempotents, indexed by orbit size.  The
special sheet coordinate and the first Bockstein digit are
\[
\begin{aligned}
 s&=e_1+e_{10}-e_5-e_6,\\
 a&=\frac{r-s}{11}
   =9e_1+4e_5+5e_6+4e_{10}\\
  &=4+5e_1+e_6
  \qquad\pmod {11}.
\end{aligned}
\]
Equivalently, with \(b=a-4\),
\[
 b=5e_1+e_6.
\]
The Bockstein-rescaled four-point quotient therefore has the compact
presentation
\[
 \boxed{\quad
 \mathbf F_{11}[s,b]/
 \bigl(s^2-1,\ b(b-(3+2s))\bigr).
 \quad}
\]
Indeed, over \(s=1\) the two \(b\)-values are \(0,5\), while over \(s=-1\)
they are \(0,1\).  The stabilizer-labelled points are
\[
\begin{array}{c|c|c|c|c}
\text{stabilizer}&\text{orbit}&s&b&r=s+11(4+b)\pmod {121}\\ \hline
A_5&1& 1&5&100\\
A_4&5&-1&0&43\\
D_5&6&-1&1&54\\
S_3&10&1&0&45.
\end{array}
\]
This explains both the values and their multiplicities:

- the quadratic \(s\) produces the two \(11+11\) sheets;
- the Bockstein digit splits the positive sheet at relative speed \(5\)
  between the pair and radial orbits;
- it splits the negative sheet at relative speed \(1\) between the
  \(A_4\) and \(D_5\) orbits; and
- the common digit \(4\) is the normalization drift of the chosen
  \((8\epsilon,7\eta_I)\) coordinate.

The equality of the \(A_4\) and \(S_3\) baseline digits is why the four
points admit the particularly small equation above.  Group theory alone
forces the four stabilizers and multiplicities, but not the displayed
numbers: \(100,43,54,45\) use the frozen pencil normalization.

## Cheap invariant consequences

The quotient characteristic polynomial is
\[
\begin{aligned}
 \prod_{\lvert\mathcal O\rvert=1,5,6,10}(T-r_{\mathcal O})
 &\equiv T^4+75T^2+45\\
 &\equiv (T^2-23)^2\pmod {121}.
\end{aligned}
\]
Its discriminant has \(11\)-adic valuation four and unit part \(9\) modulo
\(11\).  This is exactly two first-order double collisions.  It also shows
why the symmetric quartic hides the new information: the orbit labels and
the divided digit \(b\), not the characteristic polynomial modulo
\(121\), resolve the four branches.

The absolute golden-pair midpoint \(11\bmod121\) is not intrinsic to the
unbased pencil.  The permitted basis change
\(\widetilde u\mapsto\widetilde u+11\widetilde v\) preserves the special
coordinate \(u/v\) but translates every first digit.  What survives every
congruent-to-identity pencil change is the pair of within-sheet
separations, hence their marked ratio
\[
 \frac{5}{1}=5.
\]
The recurrence of \(5\) is an exact tangent-level compatibility with the
golden square class.  A geometric theorem identifying that ratio with the
incidence discriminant, rather than merely observing the same normalized
scalar, still requires the global kernel--incidence morphism.

## Scope and trust boundary

The Zariski theorem uses:

- the rank-five smooth presentation gate and prime-to-\(120\) Reynolds
  projector from the corrected bridge;
- the integral Clebsch--Gordan covariance and Dickson-fibre vanishing;
- the \(22\) full-rank Grassmann Jacobians, complete special fibre, and unit
  pencil denominators from the Bockstein-pencil bundle; and
- standard openness of the finite-etale locus and exactness of tame
  invariants.

The adjacent certificate checks the four-idempotent normal form, quotient
polynomial, discriminant valuation, and every imported numerical gate.  It
does not certify the scheme-theoretic openness argument; that is the human
proof above.  No new independent numerical replay is needed because the
certificate only recombines three committed bundles, each of whose
load-bearing finite calculation already has an independent replay.  This
report makes no novelty claim and does not reopen Paper III.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-28-c682-zariski-bockstein-orbits.py --check
```

The JSON records the byte counts and SHA-256 hashes of all three imported
certificates.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-28-c682-zariski-bockstein-orbits.py` | 9106 | `935012ca4548d8ab4fa714db71eb4fc6a868789f31cda304cdb9b7fe97caa504` |
| `2026-07-28-c682-zariski-bockstein-orbits.json` | 3963 | `f61967f09be488d120b89133631c4ec6384ccf81748ff958e8163932f6f04b14` |

## `ej` + `tt` closeout and mystery ledger

- **Closed:** the Bockstein section and invariant pencil algebraize on an
  actual marked-presentation Zariski neighborhood over
  \(\mathbf Z_{(11)}\); its generic fibre is characteristic zero.
- **Closed:** the relative section is finite etale of degree \(22\), and
  its tame \(A_5\)-quotient is finite etale of degree four.
- **Explained:** the four values are the
  \(A_5,A_4,D_5,S_3\) quotient branches.  Their complete first-order normal
  form is
  \(s^2=1,\ b(b-(3+2s))=0,\ r=s+11(4+b)\).
- **Closed by `ej`:** the quotient polynomial is the unexpected square
  \((T^2-23)^2\bmod121\); orbit idempotents are genuinely necessary to see
  the four-way split.
- **Settled by `tt`:** the midpoint \(11\) is basis-normalization data, not
  an invariant extension class.  The within-sheet splitting speeds \(5\)
  and \(1\), and hence their marked ratio \(5\), survive
  congruent-to-identity pencil changes.
- **Still open:** give a coordinate-free geometric proof that the tangent
  splitting ratio \(5\) is the same discriminant character as the global
  \(5J_0\) incidence torsor.  The numerical equality and local
  kernel--incidence comparison are proved; the characteristic-zero global
  morphism remains the exact missing object.
- **Still open:** decide whether the characteristic-zero four-orbit quotient
  has a classical moduli interpretation beyond its stabilizer labels.

C682 remains open; completion is the user's decision.
