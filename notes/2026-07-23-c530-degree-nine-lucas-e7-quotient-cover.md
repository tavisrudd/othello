# C530 — degree-nine Lucas \(e_7\) quotient ordered-root cover

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete at the prescribed
nonconstant Artin--Schreier/extra-monodromy stop

## Result

Work in characteristic two.  At the distinguished degree-nine carrier point,
\[
 W_{e_7}=\langle 1,t,t^2,t^3,t^4,t^5,t^8\rangle,\qquad
 \mathcal U_3=\langle1,t,t^8\rangle .                       \tag{1}
\]
The four quotient directions do not merely perturb C529's
\(\operatorname {AGL}_1(\mathbf F_8)\) constant-field cover.  The two directions \(t^2,t^4\)
already enlarge it to the affine-\(\mathbf F_2^3\) subspace cover
\[
 t^8+A_4t^4+A_2t^2+A_1t+A_0,\qquad A_1\ne0,                \tag{2}
\]
whose generic ordered affine-frame monodromy is
\[
 \operatorname {AGL}_3(\mathbf F_2),\qquad
 |\operatorname {AGL}_3(\mathbf F_2)|=8\cdot168=1344.       \tag{3}
\]
C529's cover is the proper \(A_4=A_2=0\) linear section, with
\(\operatorname {AGL}_1(\mathbf F_8)\) of order \(56\).  It is not a geometric component of the
full quotient-root incidence.

The generic normalized framed incidence has an independent nonconstant Artin--Schreier layer.
After ordering two roots as \(0,1\), write the next four roots as \(a,b,c,d\) and the last two as
\(u,v\).  Put
\[
\begin{aligned}
 S&=a+b+c+d,\\
 E&=ab+ac+ad+bc+bd+cd,\\
 h&=1+S,\\
 p&=1+E+S+S^2.
\end{aligned}
\]
The conditions that the monic degree-eight polynomial have zero \(t^7,t^6\) coefficients are
exactly
\[
 u+v=h,\qquad uv=p.                                        \tag{4}
\]
On the squarefree open \(h\ne0\), putting \(y=u/h\) normalizes the remaining ordered pair:
\[
 y^2+y=\frac p{h^2}.                                       \tag{5}
\]
This cover is geometrically integral with deck/monodromy group \(C_2\), and its
Artin--Schreier class is nonconstant.  For a rational base point over
\(k=\mathbf F_{2^m}\), its two sheets are \(k\)-rational exactly when
\[
 \operatorname {Tr}_{k/\mathbf F_2}(p/h^2)=0;               \tag{6}
\]
when the trace is one, coefficientwise \(k\)-Frobenius swaps them.

Nevertheless, the exact deepness law is simpler than this generic obstruction.  Every
\(\mathbf F_{2^m}\) with \(m\ge3\) contains a three-dimensional \(\mathbf F_2\)-subspace \(V\).
Its subspace polynomial
\[
 L_V(t)=\prod_{v\in V}(t-v)
       =t^8+A_4t^4+A_2t^2+A_1t                         \tag{7}
\]
is linearized, has \(A_1\ne0\), and has exactly the eight distinct roots \(V\).  Thus (7) is a
completely split squarefree member of \(W_{e_7}\).  Consequently
\[
 \boxed{\text{the \(PGL_2\)-orbit of \(e_7\) is shallow for every \(m\ge3\).}} \tag{8}
\]
In particular it is shallow for every \(3\nmid m\) in the admissible redundancy-ten range
\(q=2^m\ge16\).  For \(3\mid m\), C529's smaller witness \(t^8+t\) is recovered.  Hence the
order-three law belongs only to the \(\mathbf F_8\)-linear subcover; it is not a deepness law for
the full kernel.

This proves the first nonconstant Artin--Schreier and extra-monodromy obstruction and fires the
task's stop rule.  No other carrier stratum is opened.

## 1. Exact stabilizer and orbit transport

Use the divided-power basis \(e_0,\ldots,e_9\), dual to the ordinary binary monomials.  Let an
inverse projective change of variables be represented by
\[
 \begin{pmatrix}a&b\\c&d\end{pmatrix}.
\]
Extracting the \(x^2y^7\) coefficient after substitution, and applying Lucas' rule modulo two,
leaves only target coordinates \(2,3,6,7\).  The exact action is
\[
 g e_7=(ad+bc)^2
 \left(b^5e_2+b^4d\,e_3+bd^4e_6+d^5e_7\right).             \tag{9}
\]
Since \(ad+bc\ne0\), the projective stabilizer of \(e_7\) is exactly \(b=0\), a Borel subgroup.
The orbit is therefore \(PGL_2/B\simeq\mathbf P^1\), with the explicit Lucas-embedded
parametrization supplied by the bracket in (9).  No larger stabilizer occurs: if \(b\ne0,d=0\)
the image is \(e_2\), while if \(bd\ne0\) at least the \(e_2,e_3\) coordinates are nonzero.

The Hankel kernel and its root divisor transport contragrediently under the same projective
change of variables.  Hence a split squarefree member at \(e_7\) transports to one at every point
of its orbit.  Formula (9) is defined over \(\mathbf F_2\), so coefficientwise Frobenius commutes
with this transport.

## 2. The normalized framed quotient incidence

Let the ordered roots of a monic member of (1) be
\[
 0,1,a,b,c,d,u,v.
\]
For all eight roots, the \(t^7\) coefficient is the first elementary symmetric function.  Its
vanishing gives \(u+v=1+S=h\).  The \(t^6\) coefficient is the second elementary symmetric
function.  Since the root \(1\) contributes the sum \(S+u+v=1\), its vanishing is equivalent to
\[
 E+S(u+v)+uv=1,
\]
which gives \(uv=p\).  This proves (4) without eliminating any intersection or collision divisor.

The last two roots solve
\[
 z^2+hz+p=0.                                                \tag{10}
\]
If \(h=0\), the two geometric roots coincide; hence this divisor is exactly outside the
squarefree ordered-root open, rather than a missing separable branch.  On \(h\ne0\), (10) becomes
(5), a finite étale double cover of the four-parameter base after the other collision divisors
are removed.

It remains to show that (5) is not a split or constant cover.  Put \(B=b+c+d\), so
\(h=a+1+B\).  Along the prime divisor \(h=0\), the leading coefficient of the order-two pole of
\(p/h^2\) is
\[
 D=1+bc+bd+cd+B+B^2.                                      \tag{11}
\]
In the residue field
\(\overline{\mathbf F}_2(b,c,d)\), this is not a square because
\[
 \frac{\partial D}{\partial b}=1+c+d\ne0.                  \tag{12}
\]
If \(p/h^2=g^2+g\), its order-two pole would force \(g\) to have a simple pole and the leading
coefficient (11) to be a square, contradicting (12).  Thus the Artin--Schreier class remains
nonzero after extending the constant field algebraically.  This proves geometric integrality
and exact geometric monodromy \(C_2\).

Because (5) is defined over \(\mathbf F_2\), the standard finite-field Artin--Schreier criterion
gives (6).  This is the complete rational-lifting law for the surviving generic last-pair cover.
The task's stop rule forbids continuing into a higher fibre-product normalization once this
nonconstant class is proved.

## 3. The additive subcover and the exact deepness law

For a three-dimensional \(\mathbf F_2\)-space \(V\) in a characteristic-two field, the subspace
polynomial is linearized.  One direct induction proves this.  If \(U\) is an
\(\mathbf F_2\)-space and \(w\notin U\), then
\[
\begin{aligned}
 L_{U+\langle w\rangle}(t)
 &=L_U(t)L_U(t+w)\\
 &=L_U(t)^2+L_U(w)L_U(t).
\end{aligned}                                               \tag{13}
\]
Starting with \(L_{\{0\}}(t)=t\), formula (13) produces only \(2\)-power exponents and preserves
additivity.  At dimension three it gives (7).  Its derivative is the nonzero coefficient
\[
 A_1=\prod_{0\ne v\in V}v,
\]
so all eight roots are simple.

The generic roots of (2) form an affine three-space over \(\mathbf F_2\).  Choosing an ordered
affine origin and an ordered linear basis gives a free torsor under
\[
 \mathbf F_2^3\rtimes GL_3(\mathbf F_2)
 =\operatorname {AGL}_3(\mathbf F_2).
\]
Conversely, the root set determines the affine space and every two ordered affine frames differ
by exactly one such transformation.  Therefore the normalization of this ordered affine-frame
subcover has exact geometric deck group (3).  Its equations and deck transformations are all
defined over \(\mathbf F_2\); coefficientwise Frobenius acts by its induced affine permutation
of the eight roots, and a member splits precisely when that permutation is the identity.

The restriction \(A_4=A_2=0\) equips the root space with an \(\mathbf F_8\)-affine-line
structure.  Its frame group is the proper subgroup
\[
 \operatorname {AGL}_1(\mathbf F_8)
 \subset\operatorname {AGL}_3(\mathbf F_2).
\]
This identifies exactly what C529 measured: its order-three component Frobenius is the extra
\(\mathbf F_8\)-linear structure, not an obstruction to an \(\mathbf F_2^3\)-rational root
space.

For \(k=\mathbf F_{2^m}\), a three-dimensional \(\mathbf F_2\)-subspace exists exactly when
\(m\ge3\).  Choosing one inside \(k\) makes every root of (7) \(k\)-rational, so Frobenius is the
identity on this affine frame.  This proves (8) without a point count, a curve bound, or an
ambient syndrome census.

## 4. Boundary and coding semantics

The framed Artin--Schreier chart retains the full squarefree deletion data:

- \(a,b,c,d\) must be pairwise distinct and avoid \(0,1\);
- \(h\ne0\) is exactly \(u\ne v\);
- \(p\ne0\) makes \(u,v\) avoid \(0\);
- \(1+h+p\ne0\) makes \(u,v\) avoid \(1\); and
- \(x^2+hx+p\ne0\) for \(x\in\{a,b,c,d\}\) makes \(u,v\) avoid the first four free roots.

The monic chart has eight finite roots and hence no root at infinity.  The divisor at infinity is
not silently discarded: the reciprocal binary-form chart covers it, and projective transport in
§1 preserves squarefreeness and the number of projective roots.  The witness (7) itself lies in
the finite chart, so no infinity or support-collision issue affects the existence theorem.

A split squarefree degree-eight member of \(W_{e_7}\) is exactly the PRS shallowness witness used
in C491--C529.  Formula (7) has degree exactly eight, zero \(t^7,t^6\) coefficients, and eight
distinct rational roots.  Thus it proves shallowness, not merely Lucas containment.  For
redundancy ten the full-length code is in the admissible range only from \(q=16\), so every
relevant \(m\) is already covered.  The small fields \(m<3\) cannot contain eight distinct affine
roots and are outside that code range.

## Evidence and replay

The atomic evidence bundle is:

- `notes/2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.py`;
- `notes/2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.json`;
- `notes/2026-07-23-c530-degree-nine-lucas-e7-quotient-cover-replay.py`; and
- `notes/2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.sha256`.

From the repository root:

```text
python3 notes/2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.py \
  --check notes/2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.json
python3 notes/2026-07-23-c530-degree-nine-lucas-e7-quotient-cover-replay.py
(cd notes && sha256sum -c 2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.sha256)
```

The generator uses integer Lucas/binomial arithmetic to certify (9), directly counts
\(|GL_3(\mathbf F_2)|=168\), and constructs exact subspace-polynomial controls over
\(\mathbf F_{2^m}\) for every \(3\le m\le12\).  The replay independently expands the divided-power
action, counts invertible \(3\times3\) matrices by determinants, reconstructs every finite-field
polynomial from its eight roots, and checks the forbidden \(t^7,t^6\) coefficients.  These
bounded controls certify the displayed algebra and implementation conventions; the all-\(m\)
subspace-polynomial theorem, geometric Artin--Schreier argument, and monodromy statements are the
hand proofs in §§1--3.

The load-bearing byte counts are `6332` for the generator, `7461` for the JSON certificate, and
`3169` for the independent replay.  The checksum manifest also records the report itself.

## Extra-juice and Tao closeout

The closeout gives three cheap strengthenings that change the interpretation of the C529
obstruction:

- the exact \(e_7\) stabilizer is a Borel and its orbit is an explicit Lucas-embedded
  \(\mathbf P^1\), so one representative witness proves the full orbit statement;
- the known \(\mathbf F_8\)-constant cover is a proper linear section, not a component to be
  removed from the generic incidence; and
- the quotient directions contain both a genuinely nonconstant \(C_2\) Artin--Schreier layer and
  a larger \(\operatorname {AGL}_3(\mathbf F_2)\) additive subcover.  The latter supplies rational
  witnesses over every admissible field, so no Hasse--Weil threshold is needed.

The highest-EV successor remains C531: classify the other intrinsic \(PGL_2\)-strata of the
six-dimensional carrier.  C530 gives no evidence that their kernels contain comparable
three-dimensional additive root spaces.

## Mystery ledger

Settled:

- **What is the four-parameter normalized framed incidence?**  The geometrically integral
  Artin--Schreier cover (5), with exact trace lifting law (6).
- **What happens to the C529 constant-field component?**  It is the
  \(A_4=A_2=0\) \(\mathbf F_8\)-linear section inside the larger additive cover, not a component of
  the generic quotient incidence.
- **What extra monodromy appears?**  Generic additive affine frames have
  \(\operatorname {AGL}_3(\mathbf F_2)\), properly containing
  \(\operatorname {AGL}_1(\mathbf F_8)\).
- **Is the \(e_7\) orbit deep when \(3\nmid m\)?**  No.  It is shallow for every admissible \(m\),
  by the subspace polynomial (7).
- **Are repeated roots, infinity, or support collisions hiding in the witness?**  No.  The
  derivative \(A_1\) is nonzero, all eight roots are finite and distinct, and projective transport
  preserves the split squarefree divisor.

Open, with exact owner:

- **Do other degree-nine Lucas-carrier strata admit additive subspace witnesses or different
  lifting obstructions?**  C530 deliberately studies only the \(e_7\) orbit.  Intrinsic
  \(PGL_2\)-stratification and the remaining quotient covers belong to C531.

No genuine mystery remains inside the authorized \(e_7\)-orbit scope.

## Literature boundary

C530 makes no priority claim.  It uses the frozen C529 kernel and coding dictionary, then proves
the stabilizer, normalization, monodromy, Frobenius, and split witnesses directly.  No manuscript,
ambient syndrome census, or C500 work is opened.
