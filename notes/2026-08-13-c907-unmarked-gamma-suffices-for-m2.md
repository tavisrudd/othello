# C907 the point-class Gamma shear does not obstruct the `m=2` theorem

**Lane:** `clebsch`

**Status:** conditional scope reduction.  The point-class shear is invisible
to the integral `N`-adic Rees object and hence to a deliberately coarsened
Krull--Schmidt telescope built from that object.  It does not preserve the
ordinary directed Stokes flags, so it remains a live marking gate for the full
Stokes/Gamma programme unless a separate flag-invariance theorem fixes it.

## Marked versus unmarked residual object

Let

\[
 \Lambda=K(\mathbf P^3),\qquad
 H=[\mathcal O(1)]otimes-,\qquad N=1-H.
 \tag{1}
\]

Consider first the coarsened residual object carrying the integral lattice,
Euler pairing, hyperplane action, and the consecutive `N`-adic Rees
filtration.  A **marked seed** additionally chooses the vector corresponding
to `O`.  The
hyperplane-orbit theorem proves that any semiorthonormal cyclic orbit has the
Beilinson Gram, while the remaining ambiguity is

\[
 S_r=1+rN^3,\qquad r\in\mathbf Z.
 \tag{2}
\]

For every `r`, `S_r` is an integral automorphism which

- commutes with `H` and hence with `N`;
- preserves the Euler form;
- preserves every step of the `N`-adic Rees filtration; and
- changes only the cyclic seed by a multiple of the point class.

Indeed `S_r` is the identity on every associated graded, since `N^4=0` and
`S_r|_(N^k Lambda)=1` for `k>=1`.  Therefore all values of `r` define the
same coarsened unmarked `N`-adic Rees object.  They are different only in its
torsor of cyclic seed markings.

This statement does not extend automatically to a Stokes-filtered object.  If
`e_i=H^i e_0` and

\[
 \omega=N^3e_0=e_0-3e_1+3e_2-e_3,
 \tag{2a}
\]

then `S_r(e_0)=e_0+r omega`; for `r!=0` this does not preserve the rank-one
directed flag `Z e_0`, nor the usual forward or reverse partial flags.
Preserving the Gram matrix is not the same as preserving a sectorial Stokes
filtration or central-connection basis.

## Length and biproducts descend through the shear

Let `ell` be the largest indecomposable consecutive Rees string.  It depends
only on the filtered object up to isomorphism.  Hence

\[
 \ell(S_r\Lambda)=\ell(\Lambda).
 \tag{3}
\]

More generally, suppose a codimension-two comparison produces a biproduct in
this coarsened `N`-adic Rees category,
biproduct

\[
 \mathscr A(\operatorname{Bl}_ZY)
 \simeq \mathscr A(Y)\oplus T\mathscr A(Z)
 \tag{4}
\]

and its identification of the second summand is unique only up to an
automorphism such as (2).  Equation (4) is still an isomorphism of unmarked
objects.  Its isomorphism class, the indecomposable classes of its summands,
and the maximum-length identity are unchanged.

The positive weak-factorization argument in this coarsened category uses only
such object isomorphisms.
At each common blowup it equates two biproducts and then chains those
isomorphisms to obtain

\[
 \mathscr A(Y_0)\oplus\bigoplus T^j\mathscr A(Z_i^-)
 \simeq
 \mathscr A(Y_N)\oplus\bigoplus T^j\mathscr A(Z_i^+).
 \tag{5}
\]

No chosen generator of a summand appears in (5).  Arbitrary automorphisms of
the center summands conjugate the stepwise isomorphisms but cannot change the
two endpoint objects or their Krull--Schmidt signatures.  Composition
coherence of **marked seeds** is therefore stronger than what this coarsened
telescope requires.  For the full Stokes/Gamma category, however, the
biproducts must be strict in a category in which `S_r` is actually an allowed
automorphism; otherwise the directed flag forces `r=0` or a separate
invariance theorem.

## Exact revised analytic target

For an `m=2` theorem formulated in the coarsened `N`-adic Rees category it is
enough to prove:

1. the value-localized residual four-thimble object is integrally isomorphic,
   with Euler pairing, hyperplane action, and Rees filtration, to the residual Orlov
   `K(P^3)` summand; and
2. this summand occurs as an enriched biproduct in the codimension-two
   comparison.

The hyperplane-orbit theorem forces the Beilinson Gram once the orbit and
semiorthonormality are transported.  An undetermined `S_r` in the resulting
coarsened isomorphism is harmless for both clauses above.  The six-part
monodromy-normalized satellite-to-localized comparison remains valuable for
the stronger labelled Gamma theorem and any paper statement naming
individual `O(i)` classes, but it remains necessary if Silver is stated in
the full directed Stokes/Gamma category.

This reduction does **not** remove the need to transport the hyperplane action,
the integral pairing, or the Rees filtration.  A mere critical-value count or
an unpaired rank-four lattice is still insufficient.

## EJ/TT and mystery ledger

- **EJ:** quotient the analytic target by the genuine automorphism group of
  the residual object.  The sole surviving Gamma ambiguity is gauge for the
  length invariant.
- **TT:** distinguish a theorem about an object from a theorem about a chosen
  basis.  Weak factorization compares biproduct isomorphism classes, not
  central-connection coordinates.
- **Settled:** the integral point-class shear acts trivially on the associated
  graded of the `N`-adic Rees object and is harmless to a telescope deliberately
  defined in that coarsened category.
- **Open:** decide whether that coarsened category is sufficient for the
  birational invariant, or prove `r=0`/flag invariance for the full directed
  Stokes/Gamma object; also transport the integral Euler pairing, hyperplane
  action, and Rees filtration, prove strict biproduct additivity, and exclude
  the endpoint carrier in threefolds.
