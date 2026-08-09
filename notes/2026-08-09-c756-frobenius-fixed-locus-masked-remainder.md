# C756 Frobenius fixed-locus masked remainder

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** nonsaturated
masked-Rédei discriminator; no manuscript edit

## Verdict

The Frobenius fixed-locus formulation makes the mask canonical but does not
produce a bounded-degree carrier.  In coordinates adapted to one arc point,
the chord product has bidegree
\[
 (q+\delta,q+\delta),
\]
and universal division by the fibre Moore polynomial reduces only the fibre
degree.  Its coefficients retain base degree at most \(q+\delta\).  Restriction
to the spare-passant half of the rational base forces one factor of degree
about \(q/2\), leaving a quotient of degree about \(q/2\), not \(O(\delta)\).

The quadratic twist of the pencil packages the passant mask as a rational
point locus on a conic, but finite base change does not alter this degree
wall.  Conic polarity likewise only relabels the base.  Thus the
Frobenius-graph/fixed-locus route, without an additional pair-coupled
functional equation, meets the card's degree-\(\Theta(q)\) stop rule.

## 1. Simultaneous direction coordinates

Let \(A\) be a hypothetical nonsaturated conic-filling \(k\)-arc, fix
\(P\in A\), and put \(B=A\setminus\{P\}\), \(n=k-1\),
\[
 b=\binom n2=q+\delta.
\]
Choose projective coordinates with the original spare line as the line at
infinity and \(P\) its vertical point.
Then
\[
 B=\{(x_i,y_i):1\le i\le n\},
 \qquad x_i\ne x_j,
\]
and the affine fibres of the pencil through \(P\) are the vertical lines
\(x=t\).

The chord through \((x_i,y_i)\) and \((x_j,y_j)\) meets the fibre \(x=t\)
at
\[
 y_{ij}(t)=
 \frac{(x_j-t)y_i+(t-x_i)y_j}{x_j-x_i}, \tag{1}
\]
an affine-linear function of \(t\).  Hence the simultaneous chord product
\[
 F(t,Y)=\prod_{i<j}(Y-y_{ij}(t)) \tag{2}
\]
has degree \(b\) in \(Y\) and degree at most \(b\) in \(t\).  Its compact
form is the sum of the \(b\) chord sections on the blown-up pencil surface.

## 2. Universal Moore division

Divide (2), in \(\mathbb F_q[t][Y]\), by the monic fibre Moore polynomial:
\[
 F(t,Y)=(Y^q-Y)Q(t,Y)+R(t,Y),
 \qquad \deg_YR<q. \tag{3}
\]
Because the divisor is monic and independent of \(t\), division does not
increase base degree:
\[
 \deg_t Q,\ \deg_t R\le b=q+\delta. \tag{4}
\]

For a rational parameter \(t\) whose line is a spare passant through \(P\),
conic filling says that the \(b\) chord intersections cover every one of the
\(q\) affine points of that fibre.  Equivalently,
\[
 R(t,Y)=0. \tag{5}
\]
This is the simultaneous form of the fibrewise factorization
\(D_P=(T^q-T)E_P\).  It is canonical after reducing the base coordinate
modulo \(t^q-t\), but (4) is still the governing degree.

## 3. Exact cost of the mask

Let \(s\) be the total number of spare passants through \(P\).  If \(P\) is
external, the pencil contains \(m-1\) passants;
if \(P\) is internal, it contains \(m\), where \(q=2m-1\).  The \(n\) chord
lines \(PP_i\) occupy \(n\) of them, so
\[
 s=
 \begin{cases}
 m-1-n,&P\text{ external},\\
 m-n,&P\text{ internal}.
 \end{cases} \tag{6}
\]

The line at infinity is one of these spare passants, so the affine parameter
set \(\Omega_P\subset\mathbb F_q\) has size \(s-1\).  Reduce every
coefficient of \(R\) modulo \(t^q-t\), obtaining degree below \(q\).
Equation (5) says that each reduced coefficient is divisible by
\[
 M_{\Omega_P}(t)=\prod_{a\in\Omega_P}(t-a),
 \qquad \deg M_{\Omega_P}=s-1. \tag{7}
\]
The quotient can still have degree as large as
\[
 q-s=
 \begin{cases}
 m+n,&P\text{ external},\\
 m+n-1,&P\text{ internal},
 \end{cases} \tag{8}
\]
which is \(\Theta(q)\).  Before reduction modulo \(t^q-t\), (4) is weaker
still.  Thus fixed-locus divisibility consumes the mask but leaves no
degree-\(O(\delta)\) remainder.

The degree count is intrinsic.  The full rational base
\(\mathbb P^1(\mathbb F_q)\) is the reduced zero divisor of the base Moore
section of degree \(q+1\).  Any identity that holds only on those fibres and
not on the geometric pencil pays that base degree.  Restricting to the
affine part of the passant half pays the degree \(s-1\) in (7), leaving
(8).

## 4. The quadratic twist does not lower the degree

Line type in the pencil is the quadratic character of the restriction of
the dual conic to the base.  Passing to the quadratic twist
\[
 u^2=d\,g_P(t) \tag{9}
\]
turns the passant half (together with any rational branch points) into the
rational-point locus of a genus-zero curve.  This is the correct geometric
way to encode the mask without writing \(g_P(t)^{(q-1)/2}\).

However, pulling (3) to the degree-two cover (9) preserves the order of the
base degree.  The vanishing set becomes a rational-point divisor on the
twist, but interpolation still has degree proportional to \(q\).  No new
relation among the coefficients of \(R\) follows from the cover itself.

Conic polarity identifies the pencil through \(P\) with the polar line
\(P^\perp\) and commutes with Frobenius.  It therefore gives the same fixed
locus and the same degree count in dual coordinates; it does not compare
different residual fibres.

## 5. Stop verdict and surviving opportunity

The Frobenius graph repairs the *canonicity* defect identified in the
coordinate-free audit, but not the *complexity* defect.  Equations (3)--(8)
are a simultaneous masked remainder, yet their live quotient has degree
\(\Theta(q)\).  This is the same fragmentation wall reached by the direct
subresultant and dual-pencil calculations, now expressed on the correct
fixed-locus carrier.

Therefore:

- do not continue by interpolating the coefficients of \(R\);
- do not treat the quadratic twist alone as a low-degree Rédei theorem;
- reopen this carrier only after finding a functional equation that couples
  two or more pencil parameters before Moore division; and
- move next to a genuinely pair-coupled count across all spare passants
  through one arc point.

The natural next scalar is
\[
 \sum_{\ell\in\Omega_P}
 \sum_{X\in\ell\setminus\{P\}}(\mu_X-1)=s\delta, \tag{10}
\]
where \(\mu_X\) is the number of \(B\)-chords through \(X\).  Unlike a
single-fibre resultant, (10) couples the character-selected pencil with the
global diagonal points of four-subsets.  Its usefulness depends on obtaining
a conic-character evaluation stronger than the already closed unweighted
moments.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Can the Moore remainder be defined simultaneously? | settled | universal division (3) |
| What degree survives in the base? | settled | at most \(q+\delta\), and after fixed-locus reduction the quotient bound (8) |
| Does the passant mask itself force a low-degree factor? | settled negative | it removes only \(s\sim q/2\) degrees |
| Does the quadratic twist encode the mask canonically? | settled positive | genus-zero cover (9) |
| Does that twist lower the remainder degree? | settled negative without another identity | finite base change preserves the \(\Theta(q)\) wall |
| Should fixed-locus interpolation continue? | no | it meets the declared degree stop rule |
| What kind of input could reopen it? | open | a pair-parameter functional equation before Moore division |

## Next action

Derive the pair-coupled excess identity (10) in terms of the three diagonal
points of four-subsets of \(B\), split by whether the joining line to \(P\)
is a spare passant.  Continue only if conic externality supplies a character
evaluation not present in the existing global slope moments.
