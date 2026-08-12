# C909 audit: fixed-data normalization, fine level, and ordered axes

Date: 2026-08-12

## Opening source/coverage statement

This is a normalization and marking audit, not a forward-citation or
novelty-absence search. No negative priority claim is made. Four primary
source records were consulted at partial depth: van Geemen--Yamauchi,
arXiv:1506.05346 (cached full preprint, sections 1--3 and Propositions 1.5,
2.1, 3.1, 3.2); Roulleau, arXiv:0804.1861 (cached full preprint, sections
3--4 and Theorem 27); Roulleau, arXiv:1002.4467 (cached full preprint,
Theorems 11 and 13--15); and Carocca--Lange--Rodriguez--Rojas,
arXiv:0805.4563 (cached full preprint, sections 1--3 and the
Hecke-algebra construction). The load-bearing level and function-field
calculations below are elementary subgroup calculations recorded in the
companion C909 congruence audit, not claims quoted from those papers.

## Verdict

The equality

    C(T,r)=C(t),       T=81t^2,   r=9t

is correct for the **minimal coarse exotic marking**: the X_0(3) parameter
together with a choice of one member of the unordered exotic two-primary
pair. It is not correct for an arbitrary fixed-data stack that also
remembers a full symplectic basis of E[2], full level at 3, or an
independently ordered five-axis frame. Such a fine presentation is a finite
cover of the sign-marked curve, and its function field is generally a proper
finite extension of C(t).

Thus the safe normalization statement has two layers:

1. the unmarked coarse parameter curve is
   X_0(3) minus {T=0,infinity,-27,729/5};
2. the minimal exotic selector is the index-two congruence cover
   Gamma_ex=rho_2^{-1}(A_3) inside Gamma_0(3), with
   C(Gamma_ex)=C(T,r), r^2=T, whose signed cubic pullback is
   T=81t^2, r=9t.

A theorem claiming a map from the signed t-line to a full-level,
ordered-axis stack must either (a) explicitly construct the corresponding
finite base change of the cubic line, or (b) define the target after
forgetting those labels. “After a harmless finite level refinement” does not
preserve the equality C(M_tau)=C(t) without this qualification.

## Exact modular field tower at 2

The reduction map is surjective:

    rho_2:Gamma_0(3) -> SL_2(F_2)=PGL_2(F_2) ~= S_3.

Let

    K_2=ker(rho_2)=Gamma_0(3) intersect Gamma(2),
    Gamma_ex=rho_2^{-1}(A_3).

Then

    [Gamma_0(3):Gamma_ex]=2,
    [Gamma_0(3):K_2]=6,
    [Gamma_ex:K_2]=3.

Consequently the fields form

    C(T) subset C(T,r)=C(t) subset C(X(K_2)),

with degrees 2 and 3, respectively. Here X(K_2) is the full projective
mod-2 level/splitting cover: it labels the complete set of nonzero
2-torsion points (equivalently a symplectic basis in characteristic two).
The degree-two sign cover labels the exotic pair, not all individual
nonzero 2-torsion points.

The other intermediate quotient is

    Gamma_0(6)=Gamma_0(3) intersect Gamma_0(2),

of degree 3 over X_0(3), and labels the three rational roots. The normalized
fibre product of this degree-three cover with the degree-two exotic cover is
X(K_2). This is the precise reason that a full E[2] level structure cannot
have function field C(t): generically it has degree 6 over C(T), whereas
C(t)/C(T) has degree 2.

The exact congruence subgroup calculation also gives level 6, genus 0, and
the two-cusp widths 2,6 for Gamma_ex. The equation r^2=T is the compactified
coarse equation; the two order-three points are orbifold points, not
additional branch points of the coarse quadratic map.

## What the minimum marking actually is

For the cycle/saturation theorem, the minimum fixed datum can be stated
coarsely as:

* the elliptic source with its cyclic order-three datum (the X_0(3)
  structure), if that datum is part of the chosen scalar 3-primary graph;
* the coefficient polarization 6I_5-J_5;
* the actual finite graph kernel, including the scalar 3-primary block;
* the unordered exotic two-primary pair, or, for a selected graph, its
  degree-two orientation r^2=T; and
* the six-axis augmentation frame as an unordered A_5-orbit.

No full E[2] basis is needed merely to state the unordered exotic packet.
The two exotic graph coordinates are the two points {omega,omega^2} in
P^1(F_4), and the degree-two sign cover selects one of them. Likewise, if
the 3-primary graph is literally scalar and its scalar value is fixed, a
full E[3] basis is not needed. Adding full E[3]-level is an optional further
finite cover, not part of the coarse normalization.

The phrase “level needed to label its nonzero two-torsion” is therefore
ambiguous and should be split:

* “label the exotic pair” means the index-two sign cover Gamma_ex, with
  field C(t);
* “label all three nonzero points” or “choose a symplectic basis” means K_2,
  with a degree-three extension beyond C(t).

## Ordered axes

Roulleau's primary source gives the D_5 elliptic configurations and the
one-dimensional A_5 family; the finite group action canonically gives a
six-element A_5-orbit of D_5 axes once the A_5-marking is fixed. It does
not, by itself, select an ordered list of five axes or identify that list
with the five coordinate factors of E^5.

There are two safe choices:

1. **Coarse choice.** Keep the six-axis frame unordered and define the
   presentation stack modulo the finite permutation action. A fixed choice
   of five factors may then be made after a finite discrete refinement, with
   no change to the coarse parameter field.
2. **Fine choice.** Put an ordered five-axis frame into the datum. Then one
   must pass to the corresponding finite cover (a quotient of the relevant
   finite permutation torsor; a raw 6*5! count should not be asserted
   without specifying which permutations preserve the graph and the A_5
   marking). The resulting function field can be strictly larger than
   C(t).

If the A_5 representation, the omitted axis, and the ordering are fixed
once and for all in the definition of the cubic pencil, the ordering is a
constant discrete choice and no new geometric parameter is introduced.
That is different from claiming that the unmarked modular curve itself
already carries the ordered labels.

## Corrected normalization theorem

The theorem-grade form is:

> Let U_cub be the smooth signed A_5 cubic line and let T=81t^2. At the
> minimal coarse graph datum, the unmarked normalized parameter is the open
> X_0(3) curve with the four cubic boundary values removed. Selecting the
> actual exotic two-primary graph gives the degree-two cover r^2=T, and on
> the signed cubic line r=9t, so its function field is C(t). Any full-level
> or independently ordered-axis presentation is a finite cover of this
> sign-marked curve; its normalization need not have function field C(t).

For a fine stack M_tau, the safe assertion is

    M_tau -> M_tau0

finite after the level and ordering labels are specified, where M_tau0 is
the minimal coarse/sign-marked presentation. The cubic family lifts to
M_tau only after the matching finite base change unless the required labels
have been constructed as constant data on the chosen A_5-marked pencil.

This is a presentation-curve statement, not a claim that the curve is a
connected component of the full Hecke union. It also does not create the
relative integral isogeny or kernel: those must already be constructed
before level structures can be pulled back.

## Audit grade

* X_0(3) coarse parameter and four-point smooth open: **GO**, conditional
  only on the previously recorded generic Torelli/normalizer identification
  of the cubic period image.
* Exotic cover Gamma_ex, r^2=T, and C(T,r)=C(t): **GO** for the minimal
  sign-marked datum.
* Equality C(M_tau)=C(t) after arbitrary “full level” refinement:
  **MAJOR false/under-specified**; full E[2] level is generically a
  degree-six cover over X_0(3).
* Ordered-axis refinement: **MINOR if explicitly treated as a finite
  constant/permutation cover; MAJOR if silently absorbed while retaining the
  field equality**.

## Source ledger

* van Geemen--Yamauchi, *On intermediate Jacobians of cubic threefolds
  admitting an automorphism of order five*, arXiv:1506.05346v1. Read depth:
  **partial**, cached preprint SHA-256
  f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed;
  sections 1--3 and Propositions 1.5, 2.1, 3.1, 3.2. These establish the
  order-five quotient/Prym geometry, not the full modular level cover.
* Xavier Roulleau, *Elliptic curve configurations on Fano surfaces*,
  arXiv:0804.1861v2. Read depth: **partial**, cached preprint SHA-256
  afc1e45e608aaad153251dd22f4f19f7d23aa082f0afb35a592d28a8ba2803b3;
  sections 3--4, Theorem 27. These establish the A_5 family and elliptic-
  power Albanese conclusion, not an ordered-axis level structure.
* Xavier Roulleau, *Genus 2 curve configurations on Fano surfaces*,
  arXiv:1002.4467v1. Read depth: **partial**, cached preprint SHA-256
  c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd;
  Theorems 11 and 13--15. These establish the D_5 configurations and
  elliptic fibrations.
* Carocca--Lange--Rodriguez--Rojas, *Prym-Tyurin varieties via Hecke
  algebras*, arXiv:0805.4563v2. Read depth: **partial**, cached preprint
  SHA-256 974a8ea6ce7d2849c8085f2a4d1a7ba96968e0d268c786d703bdae849ad1bc8d;
  sections 1--3. This supports the standard marked Hecke/Prym presentation
  language, not the special T=81t^2 normalization.

