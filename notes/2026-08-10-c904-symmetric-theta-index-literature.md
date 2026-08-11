# C904 symmetric-theta index and descent audit

Date: 2026-08-10
Status: read-only Annals-gate literature/red-team note; no manuscript or Lean edits
Scope: the generic fibre of
\(\operatorname{Sym}^2\Theta\to J\), the ordered theta intersection,
integral descent through the factor-swap involution, and Voisin's
\(D_{3,3}\)

## Executive verdict

The quotient gate is real, but the diagonal is not part of it.

Let \(X=\Theta\), \(\dim X=4\), let
\[
 m:X\times X\longrightarrow J,
 \qquad (x,y)\longmapsto x+y,
\]
and let \(f:\operatorname{Sym}^2X\to J\) be the induced map.  Over the
generic point \(a\) of \(J\), the ordered fibre is
\[
 Y_a=X\cap(a-X),
\]
and the factor swap becomes \(x\mapsto a-x\).  The fixed locus occurs only
over \([2](X)\subset J\), a divisor.  Thus the generic involution is free and
the generic unordered fibre is
\[
 T_a=Y_a/\langle x\mapsto a-x\rangle .
\]

If the ordered index is two, then push-pull gives only
\[
             \operatorname{ind}(T_a)\mid 2,
             \qquad
             2\mid 2\operatorname{ind}(T_a),
\]
so the exact dichotomy is still \(1\) versus \(2\).  Neither the branch
diagonal nor integral singular cohomology forces the second answer.

The strongest exact conclusions of this audit are:

1. the diagonal has codimension four and therefore does **not** change
   \(CH^3\), either on the product or on the symmetric quotient;
2. on the free locus, integral Chow descent is equivariant Chow descent, not
   the same thing as taking invariant ordinary Chow classes;
3. in cohomological degree six, Nakaoka--Gugnin's integral symmetric-product
   lattice has no extra factorial-two diagonal generator.  Modulo torsion it
   is the saturated swap-invariant lattice;
4. consequently a genuine descended class of upstairs degree two may have
   downstairs degree one.  A proposed degree-halving construction cannot be
   rejected on formal quotient grounds;
5. Voisin's \(D_{3,3}\) contributes a three-primary *vertical relay* over
   \(\operatorname{Sym}^2\Theta\), but it does not itself construct an odd
   multisection of \(T_a\).

No primary source located here computes the generic index of \(T_a\), its
integral Chow descent lattice, or a rational section of
\(\operatorname{Sym}^2\Theta\to J\).  That is the unpreempted gate.

## 1. Exact generic quotient geometry

Kraemer--Weissauer start from the same addition map
\(\Theta\times\Theta\to X\).  Their Section 1.2 identifies the fibre over
\(2x\), after projection and translation, with
\(\Theta_x\cap\Theta_{-x}\); factor exchange becomes \(-1\) on this
intersection.  Their lemma gives a dense open over which the family is
smooth and the involution is etale.  They then write
\(Y^+=Y/\langle\sigma\rangle\).  Their theta divisor is smooth and their
principal application is genus four, but the quotient geometry is exactly
the model needed here.

For the cubic-threefold intermediate Jacobian, \(\Theta\) has isolated
singular locus.  Voisin's proof of Lemma 2.10 explicitly observes that
\(\dim\operatorname{Sing}\Theta=0\), hence a general
\(\Theta\cap\Theta_a\) is smooth.  Also, a fixed point of
\(x\mapsto a-x\) satisfies \(2x=a\), so generic \(a\) avoids every fixed
point.  Thus singularities of the total theta divisor do not contaminate the
geometric generic fibre.

This geometry is prior art.  Any theorem here should credit Voisin for the
map \(\operatorname{Sym}^2\Theta\to J\) in the cubic-threefold argument and
Kraemer--Weissauer for the smooth family of theta self-intersections with
its etale involution.  Neither source studies zero-cycle index.

## 2. The diagonal is invisible in codimension three

Let
\[
 \Delta\subset X\times X,
 \qquad
 U=(X\times X)\setminus\Delta,
 \qquad
 V=U/(\mathbf Z/2).
\]
The diagonal has dimension four in an eight-dimensional product, hence
codimension four.  Its image in \(\operatorname{Sym}^2X\) also has
codimension four.  The ordinary Chow localization sequence gives
\[
 CH^3(X\times X)\xrightarrow{\sim}CH^3(U),
 \qquad
 CH^3(\operatorname{Sym}^2X)\xrightarrow{\sim}CH^3(V),
\]
because the possible source term is \(CH^{-1}(\Delta)=0\).  This argument
uses dimension-indexed Chow groups and does not require smoothness.

Edidin--Graham, Proposition 8, gives integrally for a principal
\(G\)-bundle
\[
                       CH^*_G(U)=CH^*(V).
\]
Their equivariant localization sequence gives the same codimension-four
removal statement equivariantly.  Therefore:

> There is no diagonal correction to \(CH^3\).  Any claimed factor of two
> caused by meeting, resolving, or descending across the branch diagonal is
> spurious in the degree relevant to a three-dimensional generic fibre.

This does **not** identify \(CH^3(V)\) with
\(CH^3(U)^{\mathbf Z/2}\) integrally.  The former is equivariant Chow.  For
the finite etale quotient,
\[
 q_*q^*=2,
 \qquad
 q^*q_*=1+\sigma,
\]
and rationally the invariant description is valid, but integrally the
failure of an invariant class to admit equivariant descent is two-primary.
A cycle stable under the involution as an actual cycle descends.  A class
which is invariant only modulo rational equivalence need not.

## 3. Picard descent is easier than Chow descent

On the free locus, Edidin--Graham identify line bundles downstairs with
\(\mathbf Z/2\)-linearized line bundles upstairs.  For a connected normal
projective variety over \(\mathbf C\), removal of a codimension-at-least-two
set leaves only constant units.  Hence, if \(\sigma^*L\simeq L\), the square
of a chosen comparison is a scalar and can be normalized to one by taking a
square root in \(\mathbf C^*\).  Thus invariant line bundles linearize and
descend.  The two possible linearizations differ by the sign character; the
associated two-torsion line downstairs is killed by pullback and is
numerically invisible.

This useful Picard fact must not be promoted to codimension-three Chow.  It
justifies descending symmetric divisor cuts, not arbitrary invariant
five-cycles.

## 4. The exact integral cohomology lattice

Gugnin's Theorem 1 gives an explicit integral basis for
\(H^*(\operatorname{Sym}^nX,\mathbf Z)/\operatorname{Tor}\) inside
\(H^*(X^n,\mathbf Q)^{S_n}\), building on Nakaoka's integrality lemma.
For \(n=2\), pullback is generated by

- \(a\otimes1+1\otimes a\);
- \(a\otimes b+(-1)^{|a||b|}b\otimes a\) for unequal tensor positions;
- \(2b\otimes b\), rather than \(b\otimes b\), for a repeated primitive
  even-degree class \(b\).

The last factorial-two phenomenon does not occur in total degree six.  An
equal split would be \(3+3\), and degree-three classes are odd, so the
swap-invariant piece is instead generated by
\(\alpha\otimes\beta-\beta\otimes\alpha\) with distinct degree-three
classes.  Consequently, modulo torsion,
\[
 q^*\bigl(H^6(\operatorname{Sym}^2X,\mathbf Z)/\operatorname{Tor}\bigr)
   =\bigl(H^6(X\times X,\mathbf Z)/\operatorname{Tor}\bigr)^{\sigma}
\]
as a saturated lattice.  More explicitly its free generators have Kunneth
types
\[
 (0,6)+(6,0),\quad (1,5)-(5,1),\quad (2,4)+(4,2),
 \quad\text{and}\quad \bigwedge
 ^2H^3(X).
\]

This is the decisive normalization check:

> Integral cohomological descent in codimension three supplies no automatic
> second factor of two.  Odd degree downstairs is compatible with every
> formal topological constraint.

The theorem is topological and modulo torsion.  It is a no-go tool for a
claimed parity obstruction, not an algebraicity theorem for a desired
class.

## 5. Exact degree formula and the remaining algebraic gate

Let \(i:X=\Theta\hookrightarrow J\).  For algebraic classes
\(c\in CH^r(X)\) and \(d\in CH^{3-r}(X)\), take the image downstairs of
\(c\times d\) together with its swapped partner.  Its degree over the
generic point of \(J\) is
\[
 \deg_f\,q(c\times d)
    =\int_J i_*c\cdot(-1)^*i_*d.
\]
Indeed, the fibre of addition over zero is the graph of \(-1\).  Pulling the
quotient cycle upstairs doubles this number, and the degree-two quotient
then divides it by two again.  Therefore symmetrizing a product cycle is a
valid descent, but it does not magically improve the degree of the one
ordered product.

The most dangerous even Kunneth term is
\[
 c\in CH^2(\Theta),\qquad d\in\operatorname{Pic}(\Theta),
 \qquad
 \deg=\int_J i_*c\,\Theta D.
\]
The primal cohomology
\[
 K=\ker\bigl(i_*:H^4(\Theta,\mathbf Z)\to H^6(J,\mathbf Z)\bigr)
\]
is numerically invisible in this formula.  But this does not reduce the
problem to the previously computed divisor-triple lattice without an
additional integral argument: one must determine the Gysin image of the
**algebraic Hodge lattice** in \(H^4(\Theta)\), not merely classes obtained
by restricting divisors from \(J\).  Izadi--Wang show that, for a smooth
general abelian fivefold, the invariant primal part already has dimension
six and consists of algebraic Hodge classes.  These particular primal
classes push to zero, but they demonstrate that the middle algebraic lattice
of \(\Theta\) is genuinely larger than the ambient restriction lattice.

There are also possible \(H^3(\Theta)\otimes H^3(\Theta)\) correspondence
classes.  Weak Lefschetz makes the individual degree-three groups ambient,
but algebraic Hodge correspondences between them still require a separate
audit, especially on the marked \(A_5\) locus.

Thus the old saturated calculation
\[
 z\longmapsto\int_J\Theta^2z\in2\mathbf Z,
 \qquad z\in\operatorname{Hdg}^6(J,\mathbf Z),
\]
closes the stated ambient theta-cut construction.  By itself it does not
prove that every class in
\(CH^3(\operatorname{Sym}^2\Theta)\) has even generic degree.

### Exact computation still needed

Compute the degree ideal through one of the following equivalent algebraic
formulations:

1. \(CH^3_{\mathbf Z/2}(\Theta\times\Theta)\), followed by the addition
   degree;
2. the algebraic Hodge part of the Nakaoka--Gugnin degree-six descent
   lattice;
3. concretely, all Gysin pairings
   \(\int_J i_*c\,(-1)^*i_*d\), including middle-theta surfaces and
   degree-three correspondences.

A proof that this ideal is \(2\mathbf Z\) closes the quotient index as two.
One actual quotient cycle of degree one closes it as one.  A cohomological
degree-one class without an algebraicity theorem does neither.

## 6. What Voisin's \(D_{3,3}\) does and does not give

Voisin's Section 2 gives the exact prior art:

- \(D_{3,3}\) parametrizes reducible elliptic sextics
  \(C_3\cup C'_3\);
- the Abel--Jacobi values of the two components define a surjective map
  \(\chi:D_{3,3}\to\operatorname{Sym}^2\Theta\);
- the fibre through a general pair is birational to
  \(\operatorname{Sym}^2E_3\), where \(E_3\) is the plane cubic cut by the
  two hyperplane sections;
- composition with the sum map is the sextic Abel--Jacobi map, and Voisin
  later uses this to prove domination of \(M_9\) and identify its MRC base.

Over the function field of the pair of theta values, the plane cubic carries
its degree-three hyperplane divisor.  After an extension of degree dividing
three it has a point, hence \(\operatorname{Sym}^2E_3\) has a point.  The
vertical fibre of \(\chi\) therefore has index dividing three.  If the
generic plane cubic has index three, its symmetric square also has no
rational point: such a point would be an effective degree-two zero-cycle on
the cubic, forcing the cubic index to divide both two and three.

This is an odd relay, not the missing horizontal carrier.  It multiplies any
degree on the generic theta-sum fibre by a three-primary number and therefore
preserves its two-primary parity.  In particular:

- if \(T_a\) has index one, \(D_{3,3}\) can transmit an odd degree (at worst
  three);
- if \(T_a\) has index two, the \(D_{3,3}\) route remains even;
- Voisin does not supply a section or odd multisection of \(T_a\).

Any new theorem using this route should present the novelty as the integral
index/descent calculation, not as the existence of the
\(D_{3,3}\to\operatorname{Sym}^2\Theta\) architecture.

## 7. Prior-art and preemption verdict

The following items are preempted:

- the theta-pair addition map and its cubic-threefold role: Voisin;
- the description of the ordered fibre as an intersection of two theta
  translates and the free quotient on a dense open: Kraemer--Weissauer
  (smooth theta) together with Voisin's generic-smoothness observation for
  the cubic theta;
- the \(D_{3,3}\) map, its \(\operatorname{Sym}^2E_3\) fibre, and its
  domination role: Voisin;
- the formal integral free-quotient Chow and Picard tools:
  Edidin--Graham;
- the torsion-free integral cohomology lattice of a symmetric square:
  Nakaoka--Gugnin.

The following claim was not found in the sources or their bounded citation
neighbourhood:

> The generic fibre of
> \(\operatorname{Sym}^2\Theta\to J\) for a cubic-threefold intermediate
> Jacobian, or for the marked \(A_5\) family, has index one or index two.

Nor was a computation found of its integral Chow descent lattice, an odd
zero-cycle, or a parity theorem for all horizontal codimension-three cycles.

The strongest honest unpreempted theorem target is therefore:

> **Symmetric-theta index theorem.**  Compute the exact degree ideal of the
> geometric generic fibre of
> \(\operatorname{Sym}^2\Theta\to J\), uniformly on the marked family, by
> identifying the algebraic part of the integral degree-six descent lattice.

An index-one answer would unlock the relative cubic identity through
Voisin's three-primary relay.  An index-two answer is still a useful
impossibility theorem: it proves that the entire \(D_{3,3}\) architecture
inherits the same two-primary boundary as the quintic/Hecke routes, for a
mathematically different reason.

## 8. Search boundary and read depths

### Primary sources

- **Partial, load-bearing:** Claire Voisin, *Abel--Jacobi map, integral
  Hodge classes and decomposition of the diagonal*, arXiv:`1005.5621`,
  Section 2, especially Lemmas 2.4, 2.9, 2.10 and the paragraphs defining
  \(D_{3,3}\), \(\chi\), and \(E_3\).  Cache SHA-256
  `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.

- **Partial, load-bearing:** T. Kraemer and R. Weissauer, *The symmetric
  Square of the Theta Divisor in Genus 4*, arXiv:`1109.2249`, Sections
  1.1--1.3.  Cache SHA-256
  `c19601d1244b7e4a25f23ddd54d087880f018ce6fbd1fb62f63d2b8e98f9f550`.

- **Partial, load-bearing:** Dan Edidin and William Graham, *Equivariant
  intersection theory*, arXiv:`alg-geom/9609018`, Sections 2.2, 2.7, 4.1;
  Theorem 1 and Proposition 8.  Cache SHA-256
  `9a7b60f5b4584c3dc44d759bc10d3a0915280edc5f3cc5377477d9a4baed3df8`.

- **Partial, load-bearing:** Dmitry V. Gugnin, *On Integral Cohomology Ring
  of Symmetric Products*, arXiv:`1502.01862`, Introduction, Theorem 1, and
  Lemma 2.  Cache SHA-256
  `74c1d9704d7ddd24f76f314162a44c05727db9770648f6d285679e23b67b4107`.

- **Partial, boundary warning:** Elham Izadi and Jie Wang, *The irreducible
  components of the primal cohomology of the theta divisor of an abelian
  fivefold*, arXiv:`1510.00046`, Introduction and Theorem 0.1.  Cache
  SHA-256
  `971af3bc589eff1b4885140e98edd890ceff199644ecf6a5e11b1244cd1523de`.

- **Partial, boundary warning:** E. Izadi, Cs. Tamas, and J. Wang, *The
  primitive cohomology of the theta divisor of an abelian fivefold*,
  arXiv:`1311.6212`, Introduction.  Cache SHA-256
  `99effa34bef740a605145a590ad93cc18aa33b19cc02fb871a083a2cccea987d`.

No source was treated as read end to end.

### Search and forward closure

Bounded web/arXiv searches combined the discriminators
`Sym^2 Theta`, `symmetric square theta divisor`, `theta addition generic
fiber`, `index`, `zero-cycle`, `Chow`, `Theta cap Theta_a`, and `rational
point`.  They repeatedly returned Kraemer--Weissauer, Voisin-adjacent theta
papers, or unrelated symmetric powers of curves; none stated an index or
Chow-descent theorem for this map.

For arXiv:`1109.2249`, OpenAlex reports four citing works.  All four were
screened by title/discriminator: two concern constructible sheaves/Tannaka
groups and two concern primal cohomology of theta divisors; none advertises
Chow, zero-cycles, generic-fibre index, or rational sections.  Semantic
Scholar returned zero citing records.  Crossref did not return an exact work
record for this arXiv-only title, so it cannot supply an independent exact
count.  This is a bounded negative search, not a proof of global absence.
