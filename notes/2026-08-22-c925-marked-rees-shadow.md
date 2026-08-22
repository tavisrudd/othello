# C925 marked Rees shadow: the signal lost by the generic packet

**Lane:** `cubic-threefolds`

Programme lens: [results summary snapshot](2026-07-31-results-summary-snapshot.md).

## Question

The current \(m=2\) obstruction is visible over the generic Kummer field but
not yet at the center's native large-radius lattice.  The programme-wide
pattern suggests asking a reconstruction question rather than carrying the
entire quantum \(D\)-module:

> What is the smallest enriched shadow of a marked cubic orbit that remembers
> which native large-radius carrier produced it and persists through the
> comparison?

The answer suggested by the present red tests has two layers.  The generic
finite-etale packet forgets the relative position of the native lattice inside
its Kummer normalization.  Fixing that position still forgets the first
connection-compatible extension of the cohomological grading.  The candidate
minimal shadow is therefore a **marked Rees port**:

\[
  (\text{self-dual Kummer coweight},\qquad
    \text{first marked Rees/connection jet}).
\]

This is a proposal and a finite experiment, not a landed geometric theorem.
The reconstruction prediction is that the fibre of the forgetful map

\[
  \{\text{native marked calibrations}\}
    \longrightarrow
  \{\text{generic marked packets}\}
\]

is stratified first by a discrete self-dual coweight and then by a small jet
torsor.  The finite certificate should compute those fibres in rank six.

## Why this is the programme's recurring shape

The same information-loss pattern occurs throughout the results snapshot.

- Repair supports become reconstructive only after their normalized
  coefficients are retained.
- Independent bad polar fibres become inductive only after every removed root
  is kept in one coherent polar flag.
- An unordered Clebsch shadow recovers an orientation torsor, while one marked
  odd datum chooses a sheet.
- The continuation graph can forget a plane that the full continuation complex
  reconstructs.
- A bare exceptional-root carrier becomes reversible only after a residue flag
  is retained.
- The Schur--Sarkisov bridge identifies the missing information with a pointed
  jet quotient and asks for a Rees construction.

For C925, inertia is the support-only shadow.  It sees the cubic orbit but not
the integral Kummer exponent, the lattice order, or the connection jet.  The
full `Calibration` landed in commit `0339032e9` is sufficient but intentionally
large.  The marked Rees port is the candidate compressed source datum from
which that calibration should be reconstructed.

## The discrete signal: relative lattice position

Let \(R=\mathbf C[[r]]\), \(K=\mathbf C((r))\), and compare the two explicit
rank-six orders

\[
 A_d=R[x,e]/(x^3-r^3,e^2),\qquad
 A_s=R[a,b]/(ab-r^2,a^3+b^3-2r^3).
\]

Their generic paired \(C_3\)-algebras and full marked divisors can be matched.
Put

\[
 t=a/r,\qquad s=t^3-1,\qquad u=t(1-s/3),
\]

and use \(x\mapsto ru\), \(e\mapsto-rus\).  In the ordered bases

\[
 (1,x,x^2,e,xe,x^2e),\qquad
 (1,a,a^2,b,b^2,b^3),
\]

the images are

\[
\begin{aligned}
x&=\tfrac23a+\tfrac1{3r}b^2,&
e&=-a+\tfrac1r b^2,\\
x^2&=\tfrac13a^2+\tfrac{2r}3b,&
xe&=-a^2+rb,\\
x^2e&=b^3-r^3.
\end{aligned}
\]

After permuting rows and columns, the comparison is the direct sum of

\[
 \begin{pmatrix}2/3&-1\\1/(3r)&1/r\end{pmatrix},\qquad
 \begin{pmatrix}1/3&-1\\2r/3&r\end{pmatrix},\qquad
 \begin{pmatrix}1&-r^3\\0&1\end{pmatrix}.
\]

The three determinant valuations are \((-1,1,0)\), and the minimum entry
valuations give the relative elementary divisors

\[
  (-1,0,0,0,0,1).
\]

Thus the two orders are identical after generic localization but occupy
distinct self-dual vertices in the Kummer lattice building.
This six-integer coweight is already a much smaller shadow than the whole
order.  It records exactly the integral information erased by the Laurent
comparison.

The Kummer exponent belongs to the same datum.  The packets
\(z^3-r\) and \(z^3-r^2\) have the same exact period three.  Generically they
are related by \(z\mapsto r/z\), but that transformation shifts the native
lattice.  Hence charge modulo three is the support layer; its integral lift is
part of the coweight layer.

## Why the coweight alone is still too coarse

The parabolic shear from the calibration report has coweight zero after it is
made homogeneous:

\[
 R(r)=I+r(E_{1,3}-E_{2,4}).
\]

It is integral, unimodular, pairing-preserving, and the identity on the
associated graded lattice.  At \(r=1\), however, it produces the forbidden
discriminant \(4/9\).  What changed is the first extension of degree two by
degree one.  Equivalently, the native flat frame acquires the regular base term

\[
 B_r=R(r)^{-1}\,r\partial_rR(r).
\]

This is invisible to the coweight and visible in the first Rees jet.  The
corrected conformal calculations reinforce the distinction: a static generic
fibre and several ordinary Frobenius jets can admit the shear, while the pure
transported Kummer flow does not.  The missing datum is therefore
connection-enriched, not merely an order or filtration.

The first jet should be taken modulo integral pairing-preserving gauges acting
trivially on the associated graded.  In that quotient it is a small extension
or Bockstein class between adjacent cohomological degrees.  The selected second
recurrence coefficient is already a return through this extension:

\[
 P\longrightarrow Q\longrightarrow P.
\]

This explains why a rank, an unordered factor, a residue spectrum, or even a
generic paired algebra does not determine the marker.

## First-order predictions

The marked Rees-shadow hypothesis makes six immediate predictions.

1. The genuine model \(\mathbf P^2\times C_g\), \(g\ge2\), has a regular cubic
   orbit but lies in the split coweight-zero, zero-jet stratum; its marker is
   therefore \(0\), as computed.
2. The dual-number order \(A_d\) is the coweight-zero reference stratum and
   reduces to the lower strict recurrence with discriminant \(0\).
3. The distinct-root order \(A_s\) has coweight
   \((-1,0,0,0,0,1)\); its normalized reduced grading does not preserve the
   leading nilpotent line, so the marker's elementary modification is not
   regular.
4. The raw \(4/9\) parabolic shear survives every generic invariant but has a
   nonzero first Rees jet.  It must fail the native Kummer-flow equations or
   land in a different jet orbit.
5. The hostile algebra \(K[z]/(z^3-r)\) remains a mandatory red test: without
   a native lattice and jet it can be decorated by any rank-two marked block.
6. An Iritani comparison over a Laurent field need not preserve this shadow.
   The new source theorem should assert integral transport only for the
   coweight and jet, rather than for a complete global packet or Stokes object.

## Second-order predictions

If the signal is the right one, the next exact calculation should show the
following.

1. Self-duality, Hilbert profile \((1,2,2,1)\), primitive Kummer determinant,
   and hard Lefschetz leave only a bounded list of coweights.  The first list to
   test is \(0\) and \((-1,0,0,0,0,1)\).
2. In each surviving coweight stratum, the effective homogeneous
   pairing-preserving Rees jets form a small affine scheme.  After quotienting
   gauges trivial on the associated graded, conformality should leave only
   harmless jets with discriminant \(0\) or the upper value \(4\), never
   \(4/9\).
3. If a \(4/9\) jet survives, its first failure should occur at one explicitly
   named higher connection or WDVV equation.  That failure is then the next
   coefficient to add to the shadow; one should not retain the full formal
   connection pre-emptively.
4. Under composition, coweights add and first jets compose by a semidirect
   cocycle law.  This should give a pathwise persistence theorem without an
   exhaustive global ledger, provided the actual Kummer trait is primitive at
   every junction.
5. For general \(m\), outer-return holonomy should act on the same Rees port.
   The period calculation and the calibration calculation would then use one
   enriched occurrence, rather than independent outer and inner shadows.

## Certificate-first experiment

The next computation should be finite and deliberately overexplicit.

1. Parameterize every degree-zero effective matrix
   \(R(r)\in\operatorname{GL}_6(\mathbf Q[r])\) with \(R(0)\) graded, fixing
   the unit and preserving the Poincare pairing, in each candidate coweight
   chart.
2. Transport the complete multiplication tensor with its input index:

   \[
     C'_i=\sum_j(R^{-1})_{ji}\,R C_jR^{-1}.
   \]

   The omitted input transport is a mandatory mutation test.
3. Impose the logarithmic Kummer/divisor equation, flat unit, pairing, and the
   exact first recurrence normalization.  Solve the resulting rational
   polynomial or linear systems in Rust, retaining rank, pivots, and explicit
   elimination identities.
4. Emit canonical JSON and Lean data.  Lean should recheck every matrix and
   polynomial identity and expose a typed `ReesCalibration` correspondence to
   `RankSixRecurrenceCertificate.Calibration`.
5. Only after the exhaustive certificate is stable should the proof be
   compressed structurally, by identifying the coweight bound and the jet
   quotient as a self-dual Rees-extension theorem.

The finite domain must remain explicit: rank six, one primitive cubic Kummer
ray, cohomological weights \((0,1,1,2,2,3)\), the two candidate coweight charts,
and exact rational arithmetic.  A successful certificate would close this
finite calibration problem.  It would still not prove that Iritani's actual
codimension-two correction occurrence supplies the marked Rees port; that is
the remaining geometric persistence theorem.

## Edge-case and type boundary

The certificate must reject, rather than normalize away, three mutations.

1. Equal inertia with different coweight: \(z^3-r\) and \(z^3-r^2\).
2. Equal coweight and associated grading with different jet: the homogeneous
   parabolic shear.
3. A multiplication tensor conjugated only in its output matrices:
   \(R C_iR^{-1}\).  The correctly transported tensor is
   \(\sum_j(R^{-1})_{ji}R C_jR^{-1}\); omitting the input index can create a
   false conformal obstruction.

The Lean boundary should therefore be a source-owned structure, schematically
`MarkedReesPort Trait Generator Lattice Pairing Filtration Coweight Jet`.
A generic packet, a Laurent `Calibration`, or an unordered atom multiset must
not coerce to this type.  The geometric theorem constructs the port.  The
certificate theorem consumes a port together with an exact chart witness and
returns the existing recurrence calibration.  This keeps the unresolved
integral persistence statement visible in the type rather than hiding it in a
matrix change of basis.

## Smallest prospective source theorem

For one exact-\(4/9\) marked correction occurrence over the actual product-loop
trait, construct a rank-six self-dual unital Rees lattice whose generic fibre is
the marked cubic primary union, identify its coweight and first connection jet,
and prove that the Iritani occurrence map preserves this pair.  The finite
certificate would then exclude every admissible pair.

This is strictly smaller than transporting every primitive factor, every row,
or a full Stokes object.  It is larger than a bare finite-etale packet for the
precise reason exhibited by the red tests: generic localization forgets the
lattice vertex, and associated grading forgets the extension class.

## Mystery ledger

| status | feature | evidence or test |
| --- | --- | --- |
| settled | Generic paired marked-divisor data forget the native lattice position. | The explicit \(A_d\)-to-\(A_s\) comparison has relative coweight \((-1,0,0,0,0,1)\). |
| settled | The coweight alone forgets the dangerous calibration shear. | The homogeneous parabolic shear is unimodular with trivial associated graded but nonzero first Rees jet. |
| proposed | Coweight plus first marked connection jet is the minimally enriched shadow needed by the strict recurrence. | It exactly separates the two known modes of information loss; the exhaustive Rees-jet certificate is not yet run. |
| open | Primitive determinant, self-duality, and hard Lefschetz bound the admissible coweights to the two displayed cases. | This is the first structural theorem to seek or certify finitely. |
| open | Every admissible Rees jet has discriminant \(0\) or \(4\), never \(4/9\). | This is the finite Rust-to-Lean experiment. |
| open | The actual Iritani correction occurrence carries and preserves the marked Rees port. | Current comparison theorems are Laurent/generic and do not supply integral occurrence transport. |
