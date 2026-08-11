# C904: general ample cuts retain the charge-two obstruction

Date: 2026-08-11

Status: theorem-grade negative result for one relative lifting route;
Paper V research only; no manuscript or Lean change

## Verdict

The proposed general-position replacement works, but it gives a negative
theorem.  The already-relative divisor-product minimal cycle may be
represented by a finite signed sum of smooth surface supports

\[
                    Z_{\min}=\sum_i n_i[S_i]
\]

such that every \(S_i\) is a general complete intersection of four
sufficiently ample relative divisors.  For every term, the boundary curve

\[
                    C_i=S_i\cap D_+,
                    \qquad D_+=F+F,
\]

has connected ordered-pair cover.  Consequently the charge-two Brauer
class remains nonzero over \(k(S_i)\), and the fixed-line/\(H_{5,1}\)
Severi--Brauer conic has exact index two there.

Thus **every componentwise lift of this general ample-cut presentation
through the charge-two/\(H_{5,1}\) carrier has even multiplier**.  Signed
coefficients cannot change that parity.  This rigorously kills that chosen
degree-five lifting route.

It does not prove that the intrinsic charge-three Abel--Jacobi fibre over
\(k(S_i)\) has index two, and it does not obstruct a horizontal universal
cycle using a different carrier or a different, non-componentwise Chow
relation.

## 1. Setup

Let \(B\) be the smooth marked one-parameter base, after shrinking so that
the relative cubic, Fano surface, intermediate Jacobian, theta
rigidification, and common line are all defined.  Use the common line to
translate the charge-two torsor to the relative Jacobian.  Let

\[
  \mathcal J\longrightarrow B,
  \qquad
  \mathcal D_+=\mathcal F+\mathcal F\subset\mathcal J
\]

denote the resulting abelian scheme and charge-two boundary divisor.  The
charge-two stable-moduli gerbe has class

\[
 \alpha\in \operatorname {Br}
       (\mathcal J\setminus\mathcal D_+)[2]
\]

with generic residue

\[
 \partial_{\mathcal D_+}(\alpha)
 =\bigl[k(\mathcal F\times_B\mathcal F)/
        k(\operatorname {Sym}^2_B\mathcal F)\bigr].          \tag{1.1}
\]

The extension in (1.1) orders the two generic Jordan--Holder factors and is
nontrivial.

The relative minimal cycle is already an integral signed divisor-product
cycle

\[
                  Z_{\min}\in CH^4(\mathcal J/B),           \tag{1.2}
\]

whose fibre class is \(\Theta^4/4!\).  Since \(\dim\mathcal J=6\), every
fourfold divisor intersection in (1.2) has a surface as its total support.

## 2. Simultaneously general signed expansion

### Lemma 2.1 (ample-difference expansion)

After a projective compactification and a further shrinking of \(B\), the
cycle (1.2) has a rationally equivalent presentation

\[
                       Z_{\min}=\sum_i n_i[S_i]              \tag{2.1}
\]

in which all \(S_i\) are smooth, horizontal complete intersections of four
general divisors whose line bundles are sufficiently ample.  The choices
may be made so that all boundary curves \(C_i=S_i\cap\mathcal D_+\) are in
the good locus of the ordering cover.

**Proof.**  The fixed certificate for (1.2) is a finite integral linear
combination of monomials

\[
                    c_1(L_1)c_1(L_2)c_1(L_3)c_1(L_4).
\]

Choose one ample line bundle \(H\) on a projective compactification.  For
\(N\gg0\), write every factor as

\[
        c_1(L_j)=c_1(L_j\otimes H^N)-c_1(H^N).              \tag{2.2}
\]

Both terms in (2.2) have basepoint-free sufficiently ample
representatives.  Expand each monomial and choose independent general
sections for every occurrence.  Equality (2.1) is equality in Chow because
only representatives of the same Cartier-divisor classes were changed.

There are finitely many resulting fourfold intersections.  Bertini
smoothness, horizontality, proper intersection with \(\mathcal D_+\), and
avoidance of its codimension-at-least-two bad locus are simultaneous dense
open conditions on the finite product of section spaces.  Their
intersection is nonempty. \(\square\)

The signed nature of \(Z_{\min}\) is harmless here: negative coefficients
are retained in (2.1).  No effectivity of the minimal class is claimed.

## 3. The ordered cover remains connected

The boundary is most cleanly handled through a finite model.  Let

\[
             \widehat{\mathcal D}_+\longrightarrow\mathcal D_+           \tag{3.1}
\]

be the normalization of \(\mathcal D_+\) in the quadratic function-field
extension (1.1).  It is integral and finite of degree two.  Over the good
locus it is exactly the etale ordered-pair cover.  The branch, contraction,
diagonal, and singular loci have codimension at least two there: the
transposition fixes only the diagonal, while the positive-dimensional
fibres of \(\operatorname {Sym}^2F\dashrightarrow F+F\) map to the
codimension-two exceptional Fano locus.

### Proposition 3.2 (ample-cut persistence)

For the simultaneous general choice in Lemma 2.1, the pullback

\[
       \widehat C_i=C_i\times_{\mathcal D_+}
                         \widehat{\mathcal D}_+\longrightarrow C_i        \tag{3.2}
\]

is a connected etale double cover for every \(i\).

**Proof.**  The restriction to \(\mathcal D_+\) of every sufficiently ample
divisor used in Lemma 2.1 is ample.  Its pullback along the finite map (3.1)
is ample on \(\widehat{\mathcal D}_+\).  The latter is normal, hence has
depth at least two at every closed point.  Grothendieck's Lefschetz theorem
for the fundamental group, SGA 2, Expose XII, Corollary 3.5, says that an
ample Cartier hyperplane section induces a surjection on algebraic
fundamental groups under this depth hypothesis.  General Bertini sections
remain normal through dimensions four, three, and two.  Applying the
corollary successively to the four pulled-back divisors shows that their
curve intersection is connected.

Equivalently, the nontrivial connected finite cover (3.1) stays connected
after restriction to the general complete-intersection curve.  Generality
makes \(C_i\) and its pullback avoid the codimension-two bad locus, so the
restricted map is etale.  A connected normal curve is integral; hence (3.2)
is the nontrivial quadratic field extension, not two copies of \(C_i\).
The finitely many conditions are simultaneous by the same finite
intersection-of-open-sets argument as in Lemma 2.1. \(\square\)

The finite normalization in (3.1) is essential.  Pulling an ample divisor
back to \(\operatorname {Sym}^2F\) through its birational contraction need
only be semiample, so a naive application of projective Lefschetz on
\(\operatorname {Sym}^2F\) would have a gap.

## 4. Exact Brauer and index consequence

Let \(K_i=k(S_i)\).  The valuation of \(K_i\) defined by the boundary curve
\(C_i\) has residue

\[
  \partial_{C_i}(\alpha|_{K_i})
   =[k(\widehat C_i)/k(C_i)]\ne0                            \tag{4.1}
\]

by functoriality of Brauer residues and Proposition 3.2.  Therefore
\(\alpha|_{K_i}\ne0\).  Its period divides two, and the fixed-line Hecke
conic representing it supplies a degree-two splitting field.  Hence

\[
     \operatorname {per}(\alpha|_{K_i})
     =\operatorname {ind}(\alpha|_{K_i})=2.                 \tag{4.2}
\]

Pull the line-marked liaison conic in the
\(D'_{5,1}\)/\(H_{5,1}\) carrier back along the marked common-line section.
Its Brauer class is again \(\alpha|_{K_i}\).  Thus every zero-cycle on that
conic over \(K_i\) has even degree.  Lifting the presentation (2.1)
component by component through this carrier consequently produces only an
even multiple of \(Z_{\min}\): each coefficient \(n_i\), positive or
negative, multiplies an even local degree.

This is stronger than saying that a visible conic lacks a rational section:
it proves exact index two on every support surface of a simultaneously
general presentation of the actual relative minimal cycle.

## 5. Exact scope and the surface-field correction

The theorem proves:

1. a sufficiently ample general signed presentation of the existing
   relative divisor cycle cannot be lifted with odd multiplier through the
   charge-two fixed-line, Hecke, or liaison conic;
2. changing the supports into general position does not wash out the
   ordered-pair residue;
3. the obstruction persists separately at the generic point of every
   support surface, so signed cancellation cannot make a componentwise odd
   lift.

It does **not** prove:

1. that the whole charge-three \(M_9\to J\) fibre over \(K_i\) has index
   two;
2. that every possible presentation of \(Z_{\min}\) meets the same
   obstruction;
3. that no non-componentwise correspondence can couple different supports
   and bypass the conics;
4. that no relative universal codimension-two cubic cycle exists.

The correct rational-connectedness assessment is therefore now concrete.
The fields \(K_i=\mathbf C(S_i)\) have transcendence degree two.  Geometric
rational connectedness alone does not imply a \(K_i\)-point: the nonsplit
conics above are explicit counterexamples.  Graber--Harris--Starr applies
to function fields of curves, not surfaces.  Stronger
rational-simple-connectedness theorems require additional hypotheses and
do not erase the explicit Brauer residue.  Thus the earlier statement that
the surface-base lift has an index gate was correct; for the inherited
\(H_{5,1}\) channel, the gate is now exactly two.

## 6. Source boundary

This pass read one new primary-source passage:

- A. Grothendieck, with M. Raynaud, *Cohomologie locale des faisceaux
  coherents et theoremes de Lefschetz locaux et globaux (SGA 2)*,
  arXiv:`math/0511279`, Expose XII, Corollary 3.5 and the following remark.
  The corollary gives connectedness and surjectivity on algebraic
  fundamental groups for an ample regular hyperplane section under the
  depth-at-least-two hypothesis; the remark records normal schemes as the
  basic case.  Cached PDF SHA-256
  `41ad02c57321a8d2200ff32a929bc93adbc3de0d59dcd5a284d28d859fb87a90`.

The charge-two residue, its exact period/index, its marked-base persistence,
and the fixed-line conics are inherited from
`notes/2026-08-10-c904-charge-two-brauer-residue.md`, with its primary-source
ledger.  The identification of the locally free \(D'_{5,1}\) liaison conic
with the same Brauer class is inherited from
`notes/2026-08-10-c904-liaison-conic-brauer-class.md`.  The relative signed
divisor-product cycle is inherited from
`notes/2026-08-10-c904-relative-minimal-cycle-two-primary-gate.md`, as
corrected there by the theta-rigidification theorem.

## Mystery ledger (EJ + TT closeout)

- **Settled:** sufficiently ample signed expansion is valid in Chow and can
  be made simultaneously general across all finitely many support terms.
- **Settled:** the ordered cover remains connected on every general boundary
  curve; finite normalization avoids the semiample-contraction gap.
- **Settled:** the inherited \(H_{5,1}\) fibre has exact index two over every
  general support surface.
- **Open:** whether the intrinsic charge-three fourfold has an odd point
  over any \(K_i\).  The conic theorem does not reach the complement of the
  Hecke/liaison carrier.
- **Open:** whether a deliberately nongeneral Chow presentation or a
  correspondence coupling several support surfaces bypasses the
  componentwise residue.  That would be a genuinely different construction,
  not a repair of the route killed here.
