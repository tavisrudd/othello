# C909 — A5 period normalization and relative graph-lift: hostile audit

Date: 2026-08-12  
Status: corrective note; no manuscript edit

## Verdict

`2026-08-12-c909-a5-period-normalization-closure.md` is **not valid as
written**.  Its parameter-normalization conclusion has a clean conditional
repair.  Its claimed algebraic relative graph lift is presently an open
integral-lattice/kernel theorem, not a consequence of relative Albanese plus
finite level.  The same gap prevents an unconditional horizontal Chow-cycle
claim for the cubic pencil.

There are three logically separate statements:

1. the coarse *parameter curve* is the \(T\)-line \(X_0(3)\), through the
   rank-two elliptic multiplicity system;
2. strong Torelli identifies the normalization of the cubic period image
   once the cubic parameter is known generically injective; and
3. a lift of the family of ppav's to a fixed finite-etale graph stack needs
   an actual integral relative isogeny and its actual finite kernel.

Only (3) is missing, but it is exactly the ingredient needed to call the
period curve a fixed-data Hecke/graph component.

## 1. Correct parameter and period normalization statement

Put \(s=t^2\) and \(T=81s\).  The exact elliptic-factor calculation gives

\[
j(E_T)=\frac{(T+27)(T+3)^3}{T}.
\]

Thus \(\mathbf P^1_s\simeq X_0(3)\) as a *coarse parameter curve for the
elliptic multiplicity system*.  It does not by itself identify the integral
polarized intermediate-Jacobian variation with the universal ppav graph
family.

The smooth cubic base is not all of this modular curve.  The four cubic
boundary values are

\[
 T=0,\ \infty,\ -27,\ 729/5.
\]

Consequently the appropriate smooth-base statement is

\[
 U_{\rm cub}=X_0(3)\setminus\{0,\infty,-27,729/5\},
\]

or its inverse image after level.  The last two are *interior* points of the
modular curve, not cusps.  In particular, “the open modular curve
\(X_0(3)\)” must not be used without this qualification.

### Lemma (the exact generic-injectivity repair)

Assume the generic cubic in the signed pencil has
\(\operatorname{Aut}(X_t)=A_5\), and that its projective normalizer has
\[
 N_{\operatorname{PGL}_5}(A_5)/A_5\simeq\operatorname{Out}(A_5)\simeq C_2,
\]
with its nontrivial element sending \(t\mapsto-t\).  Then the map from the
unmarked \(s\)-line to cubic moduli is generically injective.

**Proof.**  A generic isomorphism \(X_t\simeq X_u\) is projective (the cubic
has Picard rank one), hence conjugates the two generic automorphism groups.
It lies in the normalizer.  The centralizer is scalar by irreducibility, and
is therefore trivial in \(\operatorname{PGL}_5\).  The displayed normalizer
quotient leaves exactly the two possibilities \(u=t\) and \(u=-t\).  Passing
to \(s=t^2\) removes them. \(\square\)

This is the proof needed in place of “generically injective by construction.”
It is conditional only on the recorded generic-automorphism/normalizer
calculation; it is not supplied by the \(j\)-formula alone.

Under this lemma, strong Torelli makes the map
\(U_{\rm cub}\to\mathcal A_5\) generically injective.  Since (U_{\rm cub})
is normal, it is the normalization of its *reduced period-image curve* after
the usual removal of finitely many points needed to make the map finite onto
its image.  This proves an abstract normalization assertion.  It neither
proves that the ppav variation is the universal (X_0(3)) graph family nor
constructs a graph presentation.

## 2. What the quadratic equality does and does not prove

The two-division discriminant cover of the elliptic Tate system is

\[
r^2=T.
\]

After \(T=81t^2\), it becomes \(r=\pm9t\).  Hence the signed \(t\)-cover and
the exotic discriminant cover are isomorphic as degree-two covers of the
\(T\)-line (up to the deck involution).  This is a theorem-grade equality of
the *elliptic multiplicity-system marking torsor*.

It is not yet an equality of a cubic kernel-marking torsor: to make that
sentence one must first construct the cubic's relative integral kernel and
identify its two-primary choice with this elliptic two-division packet.

## 3. The first precise obstruction to an algebraic graph lift

Let \(\mathcal J/U_{\rm cub}\) be the relative intermediate Jacobian.  The
claimed lift requires, after a finite etale cover, a homomorphism of abelian
schemes

\[
 f:\mathcal E^5\longrightarrow\mathcal J
\]

with all of the following *integral* data:

\[
 f^*\Theta_{\mathcal J}=6I_5-J_5,\qquad
 K=\ker f\subset\mathcal E^5[6],
\]

where \(K\) is the specified self-dual graph, including its selected exotic
two-primary slope and its three-primary slope.  The kernel must be a finite
etale subgroup scheme (over this complex open base) and not merely a
fibrewise maximal isotropic subgroup of the polarization discriminant.

The present evidence gives rational isotypic/multiplicity information,
fibrewise D5 quotient maps, and the Gram/degree prediction.  It does not
give this map of integral polarized variations, nor the maximal isotropic
half \(K\).  In particular:

* a relative \(D_5\)-quotient, even when constructed, is an elliptic quotient
  only up to the integral normalization required above;
* the six fibrewise axes do not by themselves coherently identify with one
  elliptic scheme and five axes do not produce a primitive family isogeny;
* the Smith type and \(\deg f=6^4\) do not select its kernel; and
* full level trivializes torsion of an already constructed abelian scheme and
  subgroup.  It cannot create \(f\), its integral lattice, or identify a
  fibrewise kernel with the desired graph.

Equivalently, the first missing lemma is an integral polarized
(A_5)-multiplicity comparison of the relative (H^3) lattice with the
elliptic rank-two system, including one primitive lattice/polarization test.
Only after it supplies (f) can one compute and globalize (K).  This is
the exact C904 integral-lattice gate, rather than a routine relative
Albanese lemma.

Deleting “the CM locus” does not repair this: CM points are not a finite
algebraic subset of a complex modular curve.  One may remove the finite
degeneration set and pass to a fine finite-level cover; an optional
non-CM restriction is a pointwise generic condition, not an open family
over which the asserted algebraic lift is automatically defined.

## 4. Consequence for relative divisor cycles

There is a correct conditional horizontal-cycle theorem.  Suppose the
previous paragraph has produced (f) and (K), and suppose moreover that
each finite list of rank-one coefficient divisor forms used in the C909
divided-power identity is represented by a **(K)-linearized rigidified
line bundle** on (\mathcal E^5).  Then those bundles descend to
\(\mathcal J\); the fixed integral rank-one identity gives a relative cycle

\[
 Z_k\in\mathrm{CH}^k(\mathcal J/U')
\quad\text{with}\quad
 [Z_k|_{\mathcal J_u}]=\Theta_u^k/k!
\]

on every geometric fibre.  This follows by ordinary finite-flat descent and
the fibrewise cohomological identity.  It still does not assert unmarked
descent or a Chow divided-power equality.

The stronger sentence “after finite etale base change every required
relative Neron--Severi section has a line-bundle lift” is not formal.  The
inverse image of an NS section in the relative Picard scheme is an
\(\mathcal J^\vee\)-torsor.  Such a torsor need not become trivial on a
finite etale cover; finite theta-group ambiguity controls linearizations
*after a lift exists*, not the possibly non-torsion Picard-torsor class.
Thus a theta-group computation for these explicit coefficient forms is
required.  The fibrewise C909 PD-saturation theorem is unaffected.

## 5. Corrected closure

The publishable current statement is therefore:

> The unmarked A5 cubic parameter curve has coarse coordinate
> (T=81t^2) and is, at the elliptic multiplicity-system level, (X_0(3)).
> Assuming the generic normalizer calculation, strong Torelli identifies
> the normalization of its reduced period image with the corresponding
> smooth open (U_{\rm cub}).  Its signed cover is the elliptic exotic
> discriminant torsor (r^2=T).  A lift to the fixed-data finite-etale graph
> stack, and hence a relative horizontal minimal-class cycle, is conditional
> on the integral polarized relative isogeny/kernel and the requisite
> theta-group linearizations.

This repairs the normalization language while preserving the genuinely
useful modular resolvent calculation.  It rejects the claimed relative lift
until those two explicit constructions are printed.

## Pointers

* `notes/2026-08-12-c904-a5-period-and-exotic-cover-audit.md` separates the
  elliptic (X_0(3)) calculation from the full ppav assertion and records
  the four cubic boundary values.
* `notes/2026-08-10-c904-integral-multiplicity-lattice-ceiling.md` isolates
  the rational comparison, primitive integral test, and polarization scalar
  as the required gates.
* `notes/2026-08-10-c904-annals-ceiling-dossier.md` explicitly records that
  degree/Smith data do not determine the finite kernel group scheme.
