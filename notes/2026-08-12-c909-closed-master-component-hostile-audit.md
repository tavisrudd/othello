# C909 hostile audit: proposed closed A5 master component

Date: 2026-08-12

## Verdict

The proposed chain

    signed smooth A5 cubic line
      -> relative norm-axis E^5-isogeny, Gram 6I-J
      -> explicit VGY Prym axis isomorphism
      -> actual exotic K[2]-marking r^2=T
      -> fixed finite-etale Hecke stack/component
      -> all-degree divisor divided-power saturation
      -> Voisin universal CH0

is **MAJOR as a source-backed closed-component theorem**.  The first source-level overclaim is the word **isomorphism** in the VGY arrow: VGY Proposition 3.2 says only that the explicit elliptic Prym \(E''_{a,b}\) is *isogenous* to the elliptic factor of \(J(X)\).  A further polarization/primitive-axis argument can upgrade this to a degree-one identification, but that is an internal lemma and is not a clause of VGY.  Even granting that lemma, the first unresolved construction-level arrow is the claimed *actual* \(K[2]\)-marking and hence the map to a fixed finite-etale Hecke component.  Identifying two elliptic 2-torsion local systems does not, by itself, identify the chosen maximal-isotropic kernel subgroup of the six-axis isogeny, its graph orientation, or its global finite-etale descent.

The safe result is conditional: a cubic supplied with an explicitly constructed marked polarized finite-etale graph presentation satisfying the cofactor/saturation hypotheses has algebraic \(\theta^4/4!\) and therefore universal CH0 by Voisin.  The VGY diagram supplies an odd (indeed 5-primary) Prym-to-axis map and a 2-torsion comparison; it does not by itself supply the actual marked kernel or a family-level fixed-stack morphism.  The stabilization irrationality is an independent all-smooth-cubics quantum/birational theorem, not a consequence of the Hecke condition.

## Source clauses and exact deductions

### 1. Roulleau: fibrewise norm axis, not a relative marked stack

Roulleau, arXiv:1002.4467, Theorem 11(D), gives for the D5 configuration five smooth genus-2 curves with the stated incidence and says that their sum is a fibre of an elliptic fibration.  The Albanese-quotient discussion immediately after the theorem explains the connected elliptic quotient; the D5 case is stated to be analogous to the displayed D3 argument.  The printed D5 representation is \(V_5^1\oplus V_5^2\oplus T\), so the C5-fixed line is the D5-fixed/norm line.

These clauses support the following fibrewise conclusions:

* there is a connected elliptic quotient/norm axis;
* the C5-fixed elliptic line is the D5 norm line;
* using the five incidence classes and the principal polarization, one may derive the six-axis map \(f:E^5\to J(X)\) with pullback Gram \(6I-J\), provided the internal intersection/polarization calculation is written out.

They do **not** print a relative family morphism over the whole signed A5 line, a universal choice of the five axis maps, a finite flat kernel group scheme with graph coordinates, or a map to a fixed finite-etale Hecke stack.  Calling the A5 line a closed component therefore requires additional relative descent and component arguments.

### 2. VGY: the Prym comparison is only odd/isogenous in the paper

Van Geemen--Yamauchi, arXiv:1506.05346, provides the following relevant clauses (printed pagination in the cached PDF):

* Proposition 1.5 (p. 4): the connected component of \(\ker(\alpha_5^*-[1])\) is a one-dimensional elliptic factor \(E\).
* Proposition 2.1 (pp. 8--9): \(J(X)\) is isomorphic as a principally polarized abelian variety to the Prym of an etale double cover \(\mathcal H\to H\).
* Section 3.2 and Proposition 3.1 (pp. 10--11): the 5:1 quotient diagram has vertical etale double covers and produces the explicit elliptic Prym \(E''\).
* Proposition 3.2 (p. 11): \(E''\) is *isogenous* to the E-factor.  No degree, kernel, primitive inclusion, or 2-torsion identification is asserted there.

There is nevertheless a clean internal 5-primary deduction.  The quotient map \(\pi\) commutes with the involutions, so pullback and norm restrict to Pryms; on the elliptic Prym, norm\(\circ\)pullback is [5].  The image is a nonzero one-dimensional C5-fixed subvariety, hence the C5-fixed (and, by the D5 representation, D5-fixed/norm) axis.  Thus the induced map \(E''\to E_{\rm axis}\) has kernel killed by 5.  Consequently it induces an isomorphism on 2-torsion, and the explicit twist \(D(T)=(T+27)(T-729/5)\) has the same 2-torsion as its Tate model; this explains the \(r^2=T\) sign cover at the level of elliptic 2-torsion.

If the axis polarizations are separately normalized and one proves \(i^\dagger i=[5]\) for the Prym inclusion and the corresponding degree-5 norm-axis polarization, then the odd map has degree one (the polarization calculation gives the usual \(n d=5\) alternative).  This is a valid extra lemma only after those primitive-polarization hypotheses are stated; it is not justified by citing VGY Proposition 3.2 alone.

### 3. Why the 2-torsion comparison is not an actual \(K[2]\)-marking

The six-axis map with Gram \(6I-J\) has a nontrivial finite kernel whose 2-primary part is the object needed for the finite-etale graph packet.  An isomorphism

\[
E''[2]\simeq E_{\rm axis}[2]
\]

only compares the 2-torsion of the one-dimensional axis.  It does not establish all of the following:

1. that the 2-primary subgroup of \(\ker(f)\) is the claimed graph packet;
2. that the chosen subgroup is maximal isotropic for the product polarization;
3. that its graph orientation agrees with the sign convention \(r^2=T\);
4. that the subgroup and the identifications descend as a finite-etale group scheme over the entire A5 line (rather than after a fibrewise or analytic choice).

The equation \(r^2=T\) is therefore safe as the explicit quadratic cover controlling the relevant elliptic 2-torsion/sign datum.  It is not, without the four missing assertions above, a proof that the *actual kernel marking* of the six-axis isogeny is that cover.

## The fixed-Hecke-stack step

A fixed finite-etale Hecke datum should include, at minimum, the elliptic source \(E\), the five-axis polarized isogeny, its finite kernel group scheme, the graph decomposition/trivialization, and the required Rosati/self-adjoint and level structures.  A fixed datum has a modular/finite-etale parameter space after those choices, but the A5 pencil enters that space only after constructing these objects relatively and checking descent.

The current evidence establishes at most a nonempty geometric marked locus after a finite etale refinement, assuming the relative six-axis and kernel constructions.  It does not prove that the signed smooth A5 line is a **closed component** of a fixed-data Hecke stack, nor that it is the whole component.  A period map or a fibrewise isogeny is insufficient for either claim.

## Saturation and Voisin: correct conditional boundary

The full divided-power statement is an internal cohomological theorem about a *given* finite-etale graph presentation.  It says that the Lefschetz/divisor-generated integral lattice contains every divided power \(\theta^k/k!\) (under the stated local cofactor hypotheses and faithful-flat descent).  It does not identify the full integral Hodge ring, prove Chow descent of the graph blocks, or produce a relative Chow cycle.

Once a single smooth complex cubic has \(\theta^4/4!\) in the ordinary integral divisor-product image, the resulting algebraic minimal class is exactly the input to Voisin's criterion (Corollary 4.4 in the cached source): universal CH0 follows.  This is a fibrewise implication and is source-safe.  It should be stated after an existential marked-presentation hypothesis, not after the unproved assertion that the A5 line is a fixed Hecke component.

The one-step stabilization irrationality/universal-CH0 assertion belongs to the independent quantum/birational theorem for smooth cubic fourfolds.  It applies to the smooth A5 fibres, but it is not generated by the norm-axis, Prym, or Hecke-stack arrows.

## Safe theorem statement

> Let \(X\) be a smooth cubic fourfold.  Assume that its intermediate Jacobian is equipped with an explicitly constructed marked polarized finite-etale graph presentation of the type used in the cofactor theorem, including the actual finite kernel subgroup and all local saturation hypotheses.  Then every required divided power in the Lefschetz/divisor subring, in particular \(\theta^4/4!\), lies in the ordinary integral divisor-product image.  Hence the minimal class is algebraic and Voisin's criterion gives universal CH0(X).  Independently, the all-cubics quantum/birational result gives the stated irrationality after one stabilization.

For the signed A5 pencil, Roulleau plus the VGY quotient diagram prove the fibrewise connected norm axis, the Gram \(6I-J\) calculation once supplied, and an odd/5-primary map from the explicit Prym to the axis, hence the associated elliptic 2-torsion comparison.  To promote this to the stronger “closed master component” statement one must still prove, in a relative algebraic form, the primitive axis identification (if degree one is claimed), the actual six-axis kernel graph and its \(r^2=T\) marking, and the descent/map to the fixed finite-etale Hecke stack.  Until then the A5 family is a source-backed candidate/nonempty locus under these added hypotheses, not a proved closed component.

## Audit grade

* Fibrewise norm-axis and VGY odd Prym comparison: **GO**, with the internal deductions displayed above.
* Source-backed VGY axis **isomorphism**: **MINOR/MAJOR boundary**; safe only as an additional primitive-polarization lemma, not as a VGY citation.
* Actual exotic \(K[2]\) kernel marking and relative fixed-stack/component claim: **MAJOR gap**.
* Conditional saturation \(\to\) algebraic minimal class \(\to\) Voisin universal CH0: **GO**.
* Stabilized irrationality: **GO independently**, not a consequence of the Hecke construction.

## Source ledger

Primary PDFs audited: VGY, arXiv:1506.05346, cached SHA-256 f263d787...baed; Roulleau, arXiv:1002.4467, cached SHA-256 c66706...c7bd.  Voisin's minimal-class/universal-CH0 criterion was checked against the cached Corollary 4.4 source used in the existing C909 notes.  No absence claim is made beyond the printed clauses and the explicit construction gaps listed above.

