# C1133 — optional claims and mathematical boundaries

**Date:** 2026-09-09. **Status:** mathematical checkpoint; literature audit and
author hierarchy review remain open. “Accepted” means this audit accepts the
deduction under the core comparison contract and specified imported results.
It does not mean formal verification or a novelty verdict.

## Dispositions

| Packet location | Disposition | Exact boundary |
|---|---|---|
| §27 exceptional loci | Accepted deduction | Voisin introduction and §1.1 supply algebraic rational-Hodge correspondences; generic Torelli excludes dominant off-diagonal components. |
| §28 countability and families | Accepted deduction | Countably many geometric cubic classes; constant coarse moduli, without claiming a product family over the original base. |
| §30 potential reduction | Accepted deduction with classical imports | Compare after a common extension defining the isogeny and giving semistable reduction. |
| §§30–31 special pencil | Conditional companion import | Local toric ranks, surface upper bound and pencil isogeny theorem are not proved here. |
| §32 odd excess | Conditional source gate | Needs the precise minimal-nef-surface inequality c2≥0 and its source. |
| §33 cylinders | Accepted geometric deduction | A dominated surface of a rationally connected Fano threefold is rational. |
| §33 affine cones | Accepted imported deduction | KPZ Proposition 0.5 and Theorem 0.6(a): an additive action forces a polar cylinder on the normal projective base. |
| §34 dimensional obstruction | Accepted | Blowup additivity plus birational invariance in dimension n+2 kills the invariant on every n-fold. |
| §35 integral boundary | Accepted limitation | Rational projectors and pairing supply neither an integral lattice nor integral cancellation. |
| Appendix I rank three | Accepted local construction | Cyclic whole rank-three even block, pairing, flat bulk family, and original regular comparison and inverse. No arbitrary-rank theorem. |
| Appendix II odd cubics | Accepted formula and additive applications | Uniform formula for odd n≥3; Bittner Theorem 3.1 supplies the extension. No arbitrary-dimensional birational invariance. |
| Appendix III motives | Accepted imported deduction | GG correction preserves the results; the broad motive/L-equivalence distinction already occurs in Efimov and Huybrechts. Novelty of the explicit threefold pair remains unclaimed. |

The finite rank-three values and gauge identities already have committed
packet-checker evidence in the finite audit. The following are symbolic proofs,
not conclusions extrapolated from new numerical experiments.

## Countability and family scope

Fix a complex cubic X and A=J(X). Reverse an isogeny using its quasi-inverse
to express every target as A/H for a finite subgroup H. The torsion group
is a countable union of finite A[m], hence has countably many finite subgroups.
Polarization classes of any target B inject into H²(B,Z), so they are
countable even before quotienting by automorphisms. Cubic Torelli then gives
at most countably many cubic isomorphism classes.

A finite-type irreducible complex family has irreducible constructible
coarse-moduli image. A positive-dimensional constructible image contains an
open subset of its positive-dimensional closure and thus uncountably many
complex points. A countable image must therefore be one point. This proves
constant coarse moduli; no trivialization over the original base is asserted.
Neither Orr nor Narasimhan–Nori is needed for these two deductions.

Countability for each fixed source does not by itself prove the exceptional
locus assertion. Voisin v3 introduction (extraction lines 48–73) explicitly
states that the rational-Hodge isomorphism relation is a countable union of
closed algebraic subsets; §1.1 (lines 352–397) explains the Hodge-locus argument.
Her Remark 0.1 addresses the unpolarized generic formulation. For an irreducible
component not contained in the diagonal, remove its diagonal intersection.
If its source projection were dominant, its constructible image would contain
an open set, meeting the very-general locus where rational generic Torelli
forces the pair to be diagonal, a contradiction. Thus its source image has
proper closure. The resulting countably many proper closed subsets contain
all nontrivial one-stable partners. The source statement is imported; the
underlying Cattani–Deligne–Kaplan theorem has not separately been read here.
For dominant cubic families on an irreducible base, the inverse images of these
proper exceptional loci remain proper. The coarse moduli maps agree at very
general points and hence on a dense set; separatedness makes the equalizer
closed, so they agree everywhere they are both defined.

## Potential reduction

An isogeny over the algebraic closure is defined over some finite extension.
At each finite place pass further to a common extension giving semistable
reduction. For an isogeny u and quasi-inverse v, uv=[m] and vu=[m].
Both extend by the Néron mapping property; their restrictions to maximal tori
of the identity components still have those compositions. These torus maps
are isogenies, so their dimensions agree. Semistable toric rank is unchanged
by further finite extension (the monodromy operator is rescaled by a nonzero
ramification scalar). This gives equality of eventual toric ranks and of
potentially good reduction loci.

This is the mechanism in SGA 7 I, Exposé IX, Proposition 2.2.6 and Corollary
2.2.7. We inspected the reproduced English text and quasi-inverse proof at
https://grothendiecksga.com/read/sga7/en/9-2.html, lines 110–149, and definitions
at lines 4–39. The original French facsimile and full semistable-reduction
theorem have not been read here. This is a classical import with the
isogeny argument checked, not a new reduction theorem. Conductors and
Frobenius polynomials over the original field are excluded.

Conditional on the pencil's displayed local formula, its squarefree application
checks: take a prime dividing exactly one of two distinct squarefree parameters.
One rank is 1 and the other is 0 or 3. The prime-to-six condition gives p≥5.
This verifies the last deduction, not the companion's formula or upper bound.
Ambient generic Torelli cannot replace the special-pencil isogeny theorem.

## Rank-three normalized lattice

Work in the characteristic-zero formal coefficient domain of the core contract
and remove the scalar irregular term. Pairing horizontality for N=E12+E23
gives tr(NA0)=tr(N²A0)=0: multiply the first pairing equation by N or N²
and take trace, killing its commutator. Thus A0_31=0 and A0_32=−A0_21.
The regular gauge I−z A0_21 E31 makes A0 upper triangular. Its inverse
is I+z A0_21 E31; expansion with the gauge derivative gives packet I.1's
coefficient formulas, already checked by the exact finite gauge script.

For S=diag(1,z,z²), the comparison entry G_ij is multiplied by z^(j−i).
Between normalized frames, G0 commutes with N and is an invertible polynomial
in N, hence upper triangular. In the order-z intertwining identity, the A0,
A0' and G0 contributions are upper triangular. The (2,1) entry forces
G1_31=0 because [N,G1]_21=G1_31. These conditions exhaust the possible
negative powers: G0_21, G0_32, G0_31 and G1_31. The same argument applies
to the regular inverse. Therefore the corrected lattice is independent of
normalized frame and the allowed comparison preserves it in both directions.
This proof does not use the refuted general framing proposition.

After shearing, write

    ∂z = f E31/z² + R/z + O(1),
    R = ((a,1,0),(b,c,1),(d,e,h)).

For each bulk direction, constant-N flatness first makes its trace-zero
leading coefficient q1 N+q2 N². The next coefficient has (3,1) entry zero:
the (2,1) entry of its commutator with N vanishes, since the other term is
a commutator of upper-triangular matrices. Shearing leaves at most a simple
bulk pole K/z+B+O(z), with K strictly lower triangular.

Put K=xE21+yE31+wE32. The z⁻² flatness coefficient is

    (∂f)E31 = −K+[K,R]+f[B,E31].

Its diagonal entries give x=w=fB13, and its (2,1) entry gives
y=f((a−c−1)B13+B23). The (3,1) entry then gives exactly packet I.3's
equation ∂f=αf with regular α. Additional coefficient equations do not
invalidate this necessary equation. If f vanishes initially, its lowest
nonzero homogeneous term would have a derivative of lower degree than αf.
Characteristic-zero formal coefficient uniqueness therefore gives f=0 in
every bulk direction. Then K=0 and ∂R=[B,R], proving constancy of the
residue characteristic polynomial, including at resonance.

For surfaces only a minimal nef-canonical surface with b2=1 can supply a whole
even rank-three factor. The transport audit proves q=0 in this case. If c1
is nonzero it is a negative multiple of the ample generator; degree constraints
exclude nonconstant-class Euler corrections. The point-bulk term adds only a
multiple of N². At zero bulk the classical degree grading is (−1,0,1);
the shear subtracts (0,1,2), giving (−1,−1,−1). Persistence gives centered
polynomial t³. If c1 is numerically zero, the Euler point term squares to zero
and cannot be cyclic of rank three. Ruled/rational surfaces and blowups reduce
to the previously audited curve/point factors. This proves surface vanishing
for this selector and completes the packet's local rank-three proof.

## Uniform odd-cubic calculation

Beauville arXiv:alg-geom/9501008v1 Proposition 1 applies for cubic dimension
n≥3: k=n−1>n/2, and the required middle cohomology is nonzero in the
borderline n=3 case. Formula (2.1) gives

    (1/3)(3β)(α+2β)(2α+β)(3α)
      = 6α³β+15α²β²+6αβ³.

These are the coefficients 6,15,6. For n=3 the relation H⁴=27qH² forces
the extra classical-basis coefficient 36q². For n≥5 degree excludes quadratic-q
entries. Smooth deformation invariance is explicit in source (1.1).

The unit is cyclic for H: successive quantum powers have distinct top
classical powers with coefficient one. The relation gives characteristic
polynomial t²(t^k−27q). For n≥5 put u=e_n−6qe_1 and
v=e_(n−1)−21qe_0. Then Hu=0 and Hv=u. On the nilpotent block and its
invertible complement one checks

    P=1−H^k/(27q),       T=H^(k−1)/(27kq).

Applying P to the four support vectors gives packet Appendix II's identities,
hence PDP=diag(−(5n+4)/18,(5n+4)/18) on (u,v). For the trace term:

    H^(n−2) D u = −6kq(e_(n−1)+6qe_0),
    T D u = −(2/9)(e_(n−1)+6qe_0),
    P D T D u = (4k/81)v.

Since N=kH sends v to ku and u to zero, tr(NDTD)=4k²/81.
The grading difference κ=−(5n+4)/9 satisfies κ+1=−5k/9. The audited
finite-jet formula therefore gives

    δsharp=(κ+1)²−4tr(NDTD)=k²/9.

The n=3 case is the already independently audited cubic block. This is a
uniform proof, not numerical extrapolation.

Bittner arXiv:math/0111062v1 Theorem 3.1 (lines 139–164) explicitly permits
smooth projective generators with the blowup relation. If S denotes the
spectrum, its already audited formulas give

    S(Bl_Z Y)−S(P(N_Z/Y))
      = S(Y)+(c−1)S(Z)−cS(Z) = S(Y)−S(Z).

Set S(empty)=0 and add over connected components. This verifies every relation
and defines an additive homomorphism on K0(Var_C). Moreover, for every smooth
projective generator X,

    S((L−1)[X]) = S([X×P¹]−2[X]) = 0.

Because these generators span the whole group, S kills the entire ideal
(L−1). This proves the extension without presuming multiplicativity. For
V_n=Bl_(X_n) P^(n+2), codimension is two and the ambient spectrum vanishes,
so S(V_n)=e_((n−1)²/9). The spectral homomorphism to the subgroup on these
distinct labels has a section sending the basis vector to [V_n]. This proves
the split infinite-rank statement using the now-verified global extension. These rational varieties have different dimensions.
There is no assertion of arbitrary-dimensional birational invariance.

## Rational-motive example

GG arXiv:0806.0173 Theorem 8 gives the rational Chow–Künneth decomposition
with middle summand h¹(J)⊗L and J isogenous to the intermediate Jacobian.
The opening of §6 explicitly applies representability to Fano threefolds
in characteristic zero. Hartlieb's published Remark 23 (arXiv v2 Remark 3.6)
identifies the Fermat intermediate Jacobian up to isogeny with E⁵, where E is
the Fermat elliptic curve. Isogenies induce isomorphisms on rational h¹ motives.
These inputs give the displayed h(X).

Five pairwise disjoint translated plane elliptic curves in P³ exist: for each
new translate the incidence condition with finitely many previously chosen
curves is proper, since 1+1<3. The motivic blowup formula gives six copies
of each L and L² and the five h¹(E)⊗L summands on both sides, as claimed.
Point/curve vanishing gives spectrum difference e_(4/9). The additive
extension sends P(L)([X']−[Y]) to P(1)e_(4/9), proving the
annihilator restriction without multiplicativity of the spectrum.

The two-page GG corrigendum has DOI 10.1090/S1056-3911-2013-00634-7.
The author-uploaded reproduction on ResearchGate is now read completely,
including proof and references (web lines 45–249). It corrects the integral
cycle-class claim to injectivity with finite cokernel and explicitly explains
that this is the property used downstream, leaving the results unaffected.
The proof uses the decomposition-of-diagonal integer N to put N times the
cohomology group in the cycle-class image; the remaining quotient maps into
finite étale cohomology with finite coefficients. This closes the correction
check. The original AMS PDF and the author-upload PDF remained inaccessible;
the exact web response is cached and hashed. No integral isomorphism of the
corrected cycle-class map is being imported.

### Exact prior-work comparison

Huybrechts arXiv:1705.04063v4 Theorem 0.2 gives isomorphic rational Chow motives
for isogenous K3 surfaces. The discussion after Corollary 3.2 explicitly
withdraws the stronger L-equivalence expectation and credits Efimov.
Efimov arXiv:1707.08997v3 Corollary 3.5 supplies isogenous Kummer surfaces
which are not L-equivalent; Corollary 3.6 also supplies twisted-derived
examples. Together these sources already separate rational Chow motives from
L-equivalence. The packet itself acknowledges the broad precedent, so this
confirms its stated boundary rather than refuting a claimed new result.

The task's candidate contribution is the explicit pair of smooth projective
threefolds, one rational and the other irrational after one stabilization,
with the same rational Chow motive and an explicit lattice-spectrum
obstruction. No search-exhaustion or first-example claim is made. The stronger
annihilator statement in the packet follows from its (L−1)-quotient invariant;
it should not be presented as the first failure of rational motives to detect
L-equivalence. The original K3 papers use integral Hodge realizations to study
L-equivalence, not the packet's surface-vanishing spectral selector.

## Cylinder and cone source check

KPZ arXiv:1212.4249v3 Proposition 0.5 identifies nonzero locally nilpotent
derivations with effective additive-group actions and principal cylinders
on an affine variety. Theorem 0.6(a) sends a cylinder on an affine quasicone
to a polar cylinder on its normal projective base. Only this forward direction
is needed. For the packet's projectively normal ample embedding, its graded
coordinate ring is a finitely generated domain and Proj is the smooth Fano
threefold. Thus the hypotheses match, and absence of any cylinder on the
base rules out every nontrivial additive action on that cone. Corollary 3.2
also states the equivalence for an integral ample divisor; no converse or
Veronese-lifting assertion is needed in this application.

Virin arXiv:2605.30875v1 introduction/Theorem 1.1 independently recalls the
Picard-rank-one criterion. Its main Theorem 1.3 proves all-member cylindricity
for genera 9 and 10, which are rational controls, not detected families.
The inspected introduction distinguishes all-member irrationality in genera
2,3,5,8 from general-member results in 4,6. This is useful scope evidence,
not a proof that no newer all-member result exists.

## EJ+TT and Mystery ledger

- **Settled:** rank-three frame correction respects the actual regular comparison
  and inverse. Resonance does not obstruct formal persistence.
- **Settled:** the odd-cubic formula has a uniform proof and checked enumerative
  inputs. The trace cancellation 25−16=9 explains its final square.
- **Cheap strengthening:** countability and constant coarse moduli need neither
  arithmetic degree bounds nor finite polarization classes. Their dependency
  should be kept separate from arithmetic finiteness.
- **Settled boundary:** apply blowup additivity to X×P² along X×{p}.
  Birational invariance in dimension n+2 forces J(X)=0. Adding higher-rank
  selectors cannot evade this while preserving the same additive contract.
- **Settled:** Voisin supplies algebraic correspondence loci; Bittner supplies
  the exact projective-generator presentation. The additive spectrum kills the
  full ideal (L−1), without a multiplicativity assumption.
- **Settled:** the cone implication uses only KPZ’s forward direction. The GG
  correction preserves the rational decomposition; Efimov/Huybrechts already
  establish the broad motive/L-equivalence distinction.
- **Open source gates:** minimal-surface c2≥0 and exact pencil imports. The
  first Miyaoka publisher attempt returned an anti-bot page, not source text.
  Full citation coverage and novelty of the specific threefold construction
  remain separate open obligations. These are
  obligations, not counterexamples or grounds for a novelty claim.

No manuscript or formal-annotation registry has been changed. Inclusion and
placement remain for author review after the mathematical and literature gates.

