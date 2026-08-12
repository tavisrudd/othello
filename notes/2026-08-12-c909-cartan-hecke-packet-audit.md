# C909 hostile audit: Cartan--Hecke packet theorem

## Verdict

The finite-group part of `cartan-hecke-packet-theorem.md` is correct after
one important qualification: it must be stated projectively, or the scalar
center must be retained explicitly.  The Borel/nonsplit-Cartan orbit sizes,
the $p=2$ degrees $3$ and $2$, and the common full level cover are sound.

The Lefschetz-saturation paragraph is not yet a theorem from the group
calculation alone.  An irreducible slope modulo $p$ gives a finite etale
residue algebra, but an integral self-adjoint lift and all hypotheses of the
finite-etale graph theorem still have to be supplied.  Likewise, Cartan
membership alone does not imply factorial activity, polarized
indecomposability, or saturation of blocks not included in the packet.

## Group-theoretic checks

For $G=PGL_2(\mathbf F_p)$,

$$
|G|=p(p^2-1).
$$

The rational orbit has size $p+1$ and stabilizer a Borel $B$ of order
$p(p-1)$.  The nonrational orbit has size $p(p-1)$ and stabilizer a nonsplit
Cartan $C_{\rm ns}\simeq\mathbf F_{p^2}^{\,*}/\mathbf F_p^{\,*}$ of order
$p+1$.  The stabilizer description is exact: an $\mathbf F_p$-projective
transformation fixing $\alpha\notin\mathbf F_p$ also fixes $\alpha^p$, hence
is multiplication by an element of $\mathbf F_{p^2}^{\,*}$ modulo scalars.

Thus the Borel and Cartan quotient covers have degrees

$$
[G:B]=p+1,
\qquad [G:C_{\rm ns}]=p(p-1).
$$

For compatible choices of a rational and nonrational point,

$$
B\cap C_{\rm ns}=1 \quad\text{in }PGL_2(\mathbf F_p).
$$

Indeed an element in the intersection fixes the rational point and both
$\alpha,\alpha^p$, three distinct points of $\mathbf P^1(\overline{\mathbf F}_p)$,
so it is the identity.  Moreover

$$
|B|\,|C_{\rm ns}|=|G|,
$$

so $BC_{\rm ns}=G$.  Hence the normalized fiber product of the two quotient
covers is connected and is the full projective level cover, not merely one
unspecified component.  In general the fiber product is described by double
cosets; the equality $BC_{\rm ns}=G$ is the missing justification for the
single-component assertion.

For $GL_2(\mathbf F_p)$ the corresponding intersection is the scalar center
$\mathbf F_p^{\,*}$, not the identity.  For $SL_2(\mathbf F_p)$ it is the
center (usually $\{\pm I\}$).  Passing to $PGL_2$ removes this harmless
central inertia.  The draft's “projectively” qualifier is therefore
essential, and any linear-level statement should say “quotient by the
center” rather than “full level cover” literally.

At $p=2$, $PGL_2(\mathbf F_2)=S_3$, $B$ has order $2$, and
$C_{\rm ns}$ has order $3$ and equals $A_3$.  The degrees are $3$ and $2$;
$B\cap A_3=1$ and $BA_3=S_3$.  This agrees with the $X_0(6)$ root cover,
the exotic quadratic cover, and their connected degree-six full splitting
cover.

## Modular specialization

For $Y=X_0(3)$ with full projective mod-$2$ monodromy, the subgroup attached
to the exotic branch is

$$
\rho_2^{-1}(C_{\rm ns})
 =\rho_2^{-1}(A_3),
$$

which is the subgroup denoted $\Gamma_{\rm ex}$ in the companion modular
audit.  The Borel preimage is $\Gamma_0(6)$, and the kernel is

$$
\ker\rho_2=\Gamma_0(3)\cap\Gamma(2).
$$

The phrase “full projective level-$p$ cover” should be retained: a base with
only $GL_2$ or $SL_2$ monodromy needs a separate central/stack discussion.

## Earliest gap in the saturation claim

The implication in Section 3

> irreducible minimal polynomial over $\mathbf F_p$ $\Rightarrow$ the
> self-adjoint slope algebra is finite etale $\Rightarrow$ all divided powers
> equal ordinary divisor products

has two missing inputs.

First, irreducibility of the reduction gives the etale residue algebra
$\mathbf F_{p^2}$, but the graph construction needs an integral order or
algebra over the actual base ring.  One must exhibit a self-adjoint integral
lift whose discriminant is a unit (or cite the unramified quadratic order
realizing it).  A residue-field element called $\alpha$ is not by itself an
integral endomorphism or a divisor class.

Second, the finite-etale graph theorem must be applied block by block to a
divisor-saturated NS lattice, including the other primes/blocks and the
chosen polarization.  One exotic Cartan block does not imply full graded
PD(NS) saturation, factorial activity, or a cofactor conclusion for omitted
blocks.  Polarized indecomposability likewise still requires the separate
self-adjoint-idempotent/endomorphism argument already noted in the draft's
limitations.

Accordingly, rename the displayed “Cartan--Hecke saturation theorem” as a
conditional theorem (or proposition) with explicit hypotheses: full projective
packet realization, integral self-adjoint unramified lift, divisor saturation,
and the finite-etale graph hypotheses on every relevant block.  The orbit
calculation then supplies the packet and its two resolvents, but not those
arithmetic and Chow/cohomological conclusions by itself.

## Recommended corrections

1. In the fiber-product paragraph, add “the normalized fiber product is the
   full projective cover because $B\cap C_{\rm ns}=1$ and
   $BC_{\rm ns}=G$; in general quotient fiber products are indexed by double
   cosets.”
2. Add a parenthetical after every linear-group version: “modulo scalar
   center; the assertion is literally projective.”
3. Replace “irreducible and hence its self-adjoint slope algebra is finite
   etale” by “irreducible separable reduction, together with an exhibited
   self-adjoint unramified integral lift, gives a finite-etale slope algebra.”
4. Make the saturation statement conditional on the full divisor-lattice and
   block hypotheses, and remove “factories for factorial-active and
   indecomposable examples” unless those two properties are separately proved.

