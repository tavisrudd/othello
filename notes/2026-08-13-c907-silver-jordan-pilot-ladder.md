# C907 Silver Jordan pilot ladder

**Lane:** `clebsch`

**Status:** structural compression of the operation tests.  The previously
advertised first nonzero example is only a normalization test; the first
possible same-spectrum extension occurs one rung later.

## The three rungs

Work over (K=\mathbf Q(\zeta _6)) on one whole generalized
‎(\zeta _6)-sector, and suppose an intrinsic nilpotent (N) has been
defined.

### 1. Toric residual geometry: external calibration only

Both \(\mathbf P^5\) and \(\mathbf P^3\) have zero primitive-sixth packet.
Hence \(\operatorname{Bl}_{\mathbf P^3}\mathbf P^5\) is the zero object in
the minimal Silver category.  Its residual four-thimble calculation probes a
stronger ordinary Stokes/Gamma theory, but no cyclotomic (K[N])-extension.

### 2. Cubic center in \(\mathbf P^5\): nonzero but rigid

Embed a smooth cubic threefold as the \((1,3)\) complete intersection
\(X\subset\mathbf P^4\subset\mathbf P^5\).  The blowup formula has one
nonzero center copy and zero ambient packet:

\[
 \mathscr J_6(\operatorname{Bl}_X\mathbf P^5)
 \cong T\mathscr J_6(X)\cong T J_1.
 \tag{1}
\]

The generalized \(\zeta _6\)-space is one-dimensional.  Every nilpotent
endomorphism of it is zero, so its (K[N])-module is necessarily (J_1).
Once the formal center comparison is a nonzero map onto this whole line, it
is automatically (N)-linear.  Thus (1) is a useful normalization of which
cyclotomic line is retained, but it cannot detect an off-diagonal extension
class.

### 3. Cubic section in the endpoint: first extension test

For the codimension-two center

\[
 X\times\{p\}\subset X\times\mathbf P^2,
\]

the ambient packet is the proposed endpoint (J_3) and the center packet is
‎(J_1).  In the deliberately ungraded minimal Silver category, the ordered
formal filtration can therefore define an exact sequence and class

\[
 0\longrightarrow J_3\longrightarrow A\longrightarrow T J_1
 \longrightarrow0,
 \qquad
 [A]\in\operatorname{Ext}^1_{K[N]}(T J_1,J_3)
 \cong K[N]/(N),
 \tag{2}
\]

or, for the opposite triangular convention, a class in
‎(\operatorname{Ext}^1(J_3,TJ_1)\cong K\).  The zero class is
‎(J_3\oplus J_1\), while a nonzero ungraded class joins them to (J_4).

This obstruction is specific to the ungraded target.  If (N) has degree
‎(+1), (J_3) lies in degrees (0,1,2), and (T J_1) lies in degree
‎(1), the degree-preserving extension is gauge-trivial: the possible map
from the center degree (1) to ambient degree (2) is killed by a change of
splitting into ambient degree (1).  Thus this rung is not a universal
graded/Rees extension obstruction.

The geometric identity

\[
 \operatorname{Bl}_{X\times\{p\}}(X\times\mathbf P^2)
 \cong X\times\mathbb F_1
\]

and the conditional Kronecker-sum calculation
‎(J_2\otimes J_2\cong J_3\oplus T J_1) exhibit an abstract split model.
They do not yet prove that the actual quantum operator obeys that tensor rule
or that the geometric center map is the anti-diagonal (J_1).  Those are
exactly the first nonvacuous strictness tests.

## Next hostile geometry

The product exchange is unusually symmetric.  A proposed next test removing
that symmetry is

\[
 Y=\mathbf P_X(\mathcal O\oplus L_1\oplus L_2),
 \qquad X\hookrightarrow Y
\]

via the quotient to \(\mathcal O\), followed by the codimension-two blowup of
that section.  In the quotient convention its normal bundle is
‎(L_1^{-1}\oplus L_2^{-1}).  Nontrivial (L_i) do not automatically retain
the product's formal QDM or primitive-sixth packet: their Chern twists can
change the quantum connection.  Only after establishing the ambient packet
and endpoint block does this family expose whether the twist changes (2).
The decisive strictness computation would then be the off-diagonal operation
block modulo the Sylvester image

\[
 A\pmod{N_VX-XN_W}.
 \tag{3}
\]

This family is a specification for the next analytic pilot, not a claim that
the needed projective-bundle operator already exists.

## Structural consequence

The Silver strictness programme now has a minimal regression ladder:

1. **support:** the toric residual example is invisible after cyclotomic
   projection;
2. **normalization:** \(\operatorname{Bl}_X\mathbf P^5\) fixes the unique
   one-dimensional center line but has no extension freedom;
3. **splitting:** \(X\times\mathbb F_1\) is the first possible ungraded
   (J_3\)-by-\(J_1\) extension and passes only under the candidate tensor
   rule; and
4. **twist sensitivity:** conditional on first identifying its formal packet,
   the nontrivial relative \(\mathbf P^2\)-bundle section family asks whether
   the actual class (3) vanishes.

This prevents spending the next pass on a geometry whose minimal Jordan
operator is forced before any strictness theorem is used.

## EJ/TT and mystery ledger

- **EJ:** the first nonzero cyclotomic example is not the first informative
  extension example; dimension one kills its entire obstruction space.
- **TT:** test the quotient class (3), not the existence of a vector-space
  decomposition.  Chern twisting is the cheapest way to remove accidental
  product splitting, but its formal packet must be recalibrated first.
- **Settled:** which of the existing pilots tests support, normalization, or
  a genuine (K[N])-extension.
- **Open:** construct (N), identify the product-center component map, and
  compute (3) in the twisted relative section family.
