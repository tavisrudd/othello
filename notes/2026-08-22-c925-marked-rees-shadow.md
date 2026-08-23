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

The exact coweight-zero certificate now isolates that failure.  Starting from
all thirteen entries allowed by the effective weight filtration, Poincare
self-duality leaves five parameters \(a,b,c,d,f\).  After the multiplication
tensor is transported in both its output and input indices, the logarithmic
divisor equation is equivalent to

\[
 a=c=0,\qquad f=b,\qquad 2d+b^2=0.
\]

The surviving calibration is a one-parameter family \(R_p\).  Its inverse
moves the Euler input by the scalar unit term \(3p\); omitting this input
transport is exactly the mutation that makes the raw shear look obstructed.
The full normalized gauge recurrence on \(R_p\) has selected exponents
\((-1/2,1/2)\), zero return entry, and modified-residue discriminant zero for
every \(p\).  Thus the first jet is necessary to state the ambiguity, but the
effective conformal equation removes the dangerous jet throughout this chart.

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
   nonzero first Rees jet.  In the effective coweight-zero dual-number chart,
   correct input-index transport proves that it fails the native Kummer-flow
   equations; the only conformal replacement has discriminant zero.
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
   pairing-preserving Rees jets form a small affine scheme.  This prediction is
   proved for the coweight-zero dual-number chart: conformality leaves one
   affine parameter and every member has discriminant zero.  It is also proved
   for the complete five-parameter distinct-root chart: conformality is
   automatic, but every member has the same forbidden leading-line leakage
   \(1/6\).  Other nonzero-coweight charts remain.
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

The first boundary certificate is now implemented.  The Rust generator
`scripts/marked_rees_shadow_cert.rs` emits the full explicit (6\times6)
Laurent basis-change matrix, extracts its three (2\times2) blocks, computes
their valuations, and emits the relative coweight and parabolic first jet.
Lean's `MarkedReesShadowCertificate` checks the same block extraction and
off-block vanishing directly from the full matrix, then independently recomputes the
elementary divisors \((-1,0)\), \((0,1)\), and \((0,0)\), checks the coweight
\((-1,0,0,0,0,1)\) and its self-duality, and verifies that the zero-coweight
shear jet is nonzero, pairing-tangent, filtration-compatible, and fixes the
first three columns.  It also links the jet to the previously checked
parabolic shear and records the displayed \(0\)-versus-\(4/9\) residue
ambiguity.

The second certificate solves the first complete jet chart.  The exact Rust
generator `scripts/effective_rees_calibration_cert.rs` constructs the full
effective \(r\)-weighted calibration, its pairing inverse, the transported
multiplication tensor with the input index included, the logarithmic defect,
and the normal-family recurrence.  Its canonical JSON records the five free
parameters, every nonzero defect entry, the four pivot entries, and the
selected recurrence values.  Lean's
`EffectiveReesCalibrationCertificate` independently proves:

- pairing preservation cuts the thirteen raw coefficients to the displayed
  five-parameter normal form;
- the generated Euler and divisor matrices are the correctly transported
  multiplication tensors;
- defect zero is equivalent to
  \(a=c=0,\ f=b,\ 2d+b^2=0\);
- the generated basis is invertible and intertwines multiplication and the
  connection grading;
- the first gauge separates the \(2+4\) blocks, and the complete second
  recurrence has zero selected return entry; and
- the resulting modified residue has discriminant zero, never \(4/9\).

The terminal theorem is
`EffectiveReesCalibrationCertificate.conformalCalibration_normalFamily_and_discriminant`.
The separate mutation theorem
`normalCalibrationInverse_mulVec_eulerVector_ne` proves that for \(p\ne0\)
the inverse calibration changes the Euler input, so an output-only conjugation
cannot pass as tensor transport.

The third certificate closes the second known native order chart.  In the
self-dual basis
\[
  (1,a,b,b^2,-a^2,b^3)
\]
of
\[
  \mathbf Q[r][a,b]/(ab-r^2,a^3+b^3-2r^3),
\]
the same complete effective support has five parameters.  Correct tensor
transport makes the logarithmic divisor defect identically zero.  Exact
Sylvester elimination nevertheless gives
\[
  \bigl(D_{\mathrm{selected}}\bigr)_{21}=\frac16
\]
for every parameter value.  Hence the selected leading nilpotent line is
never preserved, so the marked elementary modification is not regular on
this chart.  This is stronger than a discriminant mismatch: the marked
residue is not defined with the required lattice.

Together the second and third certificates close the two normalized
rank-six native orders currently supplied by the Elias--Rossi dichotomy:
the dual-number order has discriminant \(0\), and the distinct-root order has
unavoidable line leakage \(1/6\).  They do not bound every possible coweight
or construct the geometric occurrence-to-port map.

Reproducibility status on 2026-08-22:

- Rust replay: `nix run .#verify-marked-rees-shadow`, green;
- guarded Lean checker: run `20260822-172809-...`, green;
- aggregate paper interface and axiom audit: run
  `20260823-003721-8859e9e9`, green;
- artifact hashes: Rust
  `52bb3f548aee064ca6572c8f44ccf7b3153f6cfa4ff8c6be526cd79cc384585a`,
  JSON
  `592736b901e513758068c16986de204f85e9b31c4ec2152bf3d3be90fd3eb889`,
  generated Lean
  `2600650607f95dbf788af718d49ee0b3eb75dff05d9c1723abeb2340e7c73e7c`.

The coweight-zero effective-calibration bundle replays with
`nix run .#verify-effective-rees-calibration`.  The generated checker
elaborated without diagnostics in guarded run `20260822-182651`; the checker,
`PaperInterface`, and `Verification.AxiomAudit` passed final queued run
`20260823-014544-5b6db71a`.  The axiom audit reports only `propext`,
`Classical.choice`, and `Quot.sound`.  The exact artifact sizes and hashes are:

- Rust: 50410 bytes,
  `e7c686f151e371b4ddbc7cdfd24e14ca9ee113db0fd980ab5d20edfb2d90686b`;
- JSON: 1839 bytes,
  `f1fb3def00165b21a52de2a4eaf4da83efb3555fd7b5339591e127bf46353d`;
- generated Lean: 8649 bytes,
  `65faebff2c3252cbd999b2673422c271e8003f5ba9c9181ce026f1960b2d1ee0`.

The distinct-root effective-order bundle replays with
`nix run .#verify-effective-distinct-order`.  Its Rust engine is shared with
the dual-number certificate; `--distinct-json` and `--distinct-lean` select
the second chart.  Lean's terminal theorem is
`EffectiveDistinctOrderCertificate.conformalDistinctOrder_forces_lineFailure`.
It uses no `native_decide`.
The new artifact sizes and hashes are:

- JSON: 3645 bytes,
  `11e003ddbf9a2260e8ca83e6886e14547f5ecc32714b43a60dffefd07f11382e`;
- generated Lean: 9221 bytes,
  `de98fd76f7c38d64f6b28b27443573b184b40cd4bfe5a7282ef821295991a43e`.

The finite domain must remain explicit: rank six, one primitive cubic Kummer
ray, cohomological weights \((0,1,1,2,2,3)\), the displayed effective
unipotent support, the two normalized native orders, and exact rational
arithmetic.  The certificates close these charts, not the whole finite
calibration problem or arbitrary coweight.  They do not prove that Iritani's actual
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
| settled | Generic paired marked-divisor data forget the native lattice position. | Rust emits the full comparison matrix; Lean checks its block decomposition and recomputes relative coweight \((-1,0,0,0,0,1)\). |
| settled | The coweight alone forgets the dangerous calibration shear. | Lean checks a nonzero pairing-tangent, filtration-compatible first jet at coweight zero and the displayed \(0\)-versus-\(4/9\) residue ambiguity. |
| settled | Correct input-index transport removes the dangerous shear in the effective coweight-zero dual-number chart. | Exact Rust elimination gives one conformal parameter; Lean checks the complete recurrence and discriminant zero for every parameter, and separately rejects output-only transport. |
| settled | The complete effective distinct-root chart cannot carry the marked elementary modification. | Rust emits the exact first gauge; Lean proves conformality and the parameter-independent lower-left leakage \(1/6\). |
| proposed | Coweight plus first marked connection jet is the minimally enriched shadow needed by the strict recurrence. | It separates the two known modes of information loss and closes both normalized native-order charts; the coweight bound is not proved. |
| open | Primitive determinant, self-duality, and hard Lefschetz bound the admissible coweights to the two displayed cases. | This is the first structural theorem to seek or certify finitely. |
| partial | Every admissible marked Rees port excludes \(4/9\). | The dual-number chart gives discriminant \(0\); the distinct-root chart fails leading-line regularity. Other coweight charts remain. |
| open | The actual Iritani correction occurrence carries and preserves the marked Rees port. | Current comparison theorems are Laurent/generic and do not supply integral occurrence transport. |
