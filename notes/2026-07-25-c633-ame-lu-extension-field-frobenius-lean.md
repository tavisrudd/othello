# C633: extension-field pencil sectors in Lean

**Lane:** `ame-lu`

**Status:** complete

## Result

`RelativeConicArcs.AMELU.ExtensionFieldPencil` formalizes the exact scalar
algebra behind C623's extension-field Frobenius sectors.  For a field
automorphism \(\sigma\) and pencil parameter \(t\), it defines and proves the
two jump divisors
\[
  E_\sigma(t)=(\sigma(t)-t)(1-\sigma(t)t)
\]
and
\[
  D_\sigma(t)=((1-\sigma(t))(1-t))^2+\sigma(t)t.
\]
The first is the diagonal-sector divisor.  The second is the
Frobenius--Gale divisor.  At the identity automorphism Lean proves
\(D_{\mathrm{id}}(t)\) equal to the existing GRS quartic.

The module also:

- factors the cross-multiplied frame-ratio difference as
  \((s-t)(1-st)\);
- proves equality of frame ratios equivalent to that factorization away
  from the excluded parameter \(1\);
- defines the explicit six-coordinate Gale multiplier
  \[
    (-(1-s)(1-t),-(1-s)(1-t),1,1,-1,-1);
  \]
- computes all nine parity-check pairings and proves that their simultaneous
  vanishing is equivalent, in odd characteristic, to
  \(((1-s)(1-t))^2+st=0\);
- proves that, on the admitted non-GRS locus, the diagonal and Gale modes for
  one fixed Frobenius exponent are disjoint;
- proves that the GRS quartic and the pencil invariants \(A,B,z\) commute
  with every field automorphism; and
- proves that the admitted non-GRS parameter locus is invariant under every
  field automorphism.

Finally, the module packages the all-extension-field orbit terminal:
extension-field equivalence is equivalent to Galois relatedness of `pencilZ`,
given two explicitly named bridges.  The forward bridge extracts a
projective Frobenius sector from an additive local-Clifford equivalence; the
reverse bridge constructs a local Clifford from a Galois match.  This is an
honest conditional interface, not an axiom and not a claim that the difficult
quantum-action bridge has been kernel-checked.

## Formal declarations

The public declarations are:

- `twistedPencilDiagonalDivisor`;
- `twistedPencilGaleDivisor`;
- `pencilFrameRatio`;
- `pencilFrameRatio_crossDifference`;
- `pencilFrameRatio_eq_iff`;
- `twistedPencilGaleDivisor_refl`;
- `twistedPencilGaleMultiplier`;
- `pencilGalePairing`;
- `pencilGalePairing_multiplier`;
- `pencilGalePairing_multiplier_zero_iff`;
- `twistedPencil_sectors_disjoint`;
- `map_pencilGRSQuartic`;
- `map_pencilA`;
- `map_pencilB`;
- `map_pencilZ`;
- `admitted_nonGRS_map_iff`;
- `PencilZGaloisRelated`;
- `ExtensionFieldPencilOrbitInputs`; and
- `extensionField_pencil_classified_by_galoisZ`.

`RelativeConicArcs.Gates.AMELUExtensionFieldPencil` is the import-only task
gate.  `AMELUExtensionFieldPencilAxioms` audits the algebraic and conditional
terminals in one environment.  A dedicated gate avoids conflicting with
concurrent ownership of the shared AME--LU aggregate.

## Proof architecture

The diagonal divisor comes from the normalized frame ratio
\[
  R(t)=\frac{t}{(1-t)^2}.
\]
Lean checks directly that
\[
  s(1-t)^2-t(1-s)^2=(s-t)(1-st),
\]
then clears the two nonzero denominators.  Substituting \(s=\sigma(t)\)
gives \(E_\sigma(t)\).

For the Gale sector, the explicit multiplier is inserted into the bilinear
pairing of the two pencil parity-check matrices.  Eight entries cancel
identically.  The remaining entry is
\[
  -2\bigl(((1-s)(1-t))^2+st\bigr).
\]
Odd characteristic makes the factor \(-2\) cancellable.  Substituting
\(s=\sigma(t)\) gives \(D_\sigma(t)\); substituting \(s=t\) and normalizing by
ring algebra recovers the GRS quartic.

The orbit proof then uses the existing prime-field pencil-classification
interface only after the forward bridge has supplied a projective
equivalence between the appropriate Frobenius twist and the target.  The
already-formalized equality of `pencilZ` under projective equivalence and the
new automorphism-equivariance theorem give the required Galois relation.
The reverse implication is exactly the separately named construction bridge.

The second-order sector-purity theorem uses both factors of \(E_\sigma(t)\).
If \(\sigma(t)=t\), then \(D_\sigma(t)\) is the GRS quartic.  If
\(\sigma(t)t=1\), then
\[
  t^2D_\sigma(t)=\operatorname{GRSQuartic}(t).
\]
Since admitted non-GRS parameters have \(t\ne0\) and nonzero GRS quartic,
neither diagonal branch can also be a Gale branch for the same exponent.
Different exponents may still coexist, exactly as in the \(q=9\) kernel.

## Trust boundary

The following content is unconditional and kernel checked:

- both divisor definitions and their polynomial identities;
- the frame-ratio factorization and equivalence;
- the explicit Gale multiplier calculation;
- the odd-characteristic zero criterion;
- field-automorphism equivariance of the quartic and \(A,B,z\); and
- Galois stability of the admitted non-GRS locus.

The final orbit terminal is conditional on fields of
`ExtensionFieldPencilOrbitInputs`:

1. `equivalent_implies_projective_sector`, which contains the
   linearized-polynomial decomposition, Frobenius-sector decoupling,
   nonzero-sector propagation, and conversion to projective equivalence;
2. `galois_z_implies_equivalent`, which contains the coordinatewise
   Frobenius/projectivity construction at the local-Clifford level.

Thus Lean checks the complete scalar geometry and the logical composition of
the classification, while C623's exact argument and certificate remain the
authority for the additive-Clifford bridge itself.  No Desarguesian-spread
reconstruction premise is introduced.

## Extra-juice and Tao closeout

The useful reframing is that extension fields do not require reconstruction
of a preferred \(\mathbb F_q\)-linear spread.  The additive map decomposes by
Frobenius exponent, and each nonzero sector has only two geometric modes:
code-to-code, controlled by \(E_\sigma\), or code-to-Gale-dual, controlled by
\(D_\sigma\).  This makes the exceptional nonsemilinear kernels visible
without changing the orbit invariant.

The formal artifact mirrors that split.  The exact polynomial geometry is
proved directly; the one genuinely representation-theoretic conversion is a
named input rather than being concealed in a broad equivalence assumption.
The resulting interface can later receive a full matrix/linearized-polynomial
implementation without changing the terminal theorem.

## Degrees of freedom

| Degree of freedom | Status |
|---|---|
| Field automorphism \(\sigma\) | Arbitrary in the scalar theorems; a supplied family `twist` indexes the orbit terminal. |
| Diagonal-sector branch | Exactly \(\sigma(t)=t\) or \(\sigma(t)t=1\), encoded by \(E_\sigma(t)=0\). |
| Gale-sector branch | Exactly \(D_\sigma(t)=0\), with an explicit multiplier. |
| Scale of the Gale multiplier | Projectively free; the displayed normalization fixes it. |
| Choice of Galois exponent witnessing relatedness | Existential and intentionally not required to be unique. |
| Genuine sums of several Frobenius sectors | Allowed by C623 and responsible for enlarged kernels; they do not enlarge the orbit relation. |
| Diagonal and Gale modes at one exponent | Mutually exclusive on the admitted non-GRS locus. |
| Local-Clifford phases and additive symplectic lifts | Outside the scalar module; owned by the two bridge fields. |
| Party permutations | Absorbed only insofar as the supplied equivalence bridge handles them; not reconstructed by this module. |

## Mystery ledger

| Feature | Closeout status | Exact remaining gap or owner |
|---|---|---|
| Why does the untwisted Gale jump equal the GRS locus? | **Settled unconditionally:** `twistedPencilGaleDivisor_refl`. | none |
| Is the six-coordinate Gale multiplier merely experimental? | **Settled unconditionally:** all nine pairings are computed symbolically. | none |
| Where does the diagonal reciprocal branch come from? | **Settled unconditionally:** it is the second factor of the frame-ratio cross difference. | none |
| Does \(z\) commute with Frobenius? | **Settled unconditionally** for every field automorphism. | none |
| Can a Galois twist leave the admitted non-GRS locus? | **Settled negatively** by `admitted_nonGRS_map_iff`. | none |
| Can one Frobenius exponent carry diagonal and Gale modes simultaneously? | **Settled negatively** on the admitted non-GRS locus by `twistedPencil_sectors_disjoint`. | none |
| Do genuine nonsemilinear maps force extra orbits? | **Settled negatively in C623; composition formalized conditionally here.** | Full kernel-checked additive-sector propagation remains the forward bridge. |
| Is the linearized-polynomial decomposition itself implemented in Lean matrices? | **No.** | Formalize additive endomorphisms over the prime field, uniqueness of their Frobenius expansion, and coordinate propagation. |
| Is the converse Galois-\(z\) Clifford constructed inside Lean? | **No.** | Connect the existing projectivity witnesses and coordinatewise field automorphisms to the additive Clifford action API. |
| Is a spread-reconstruction theorem needed? | **Settled negatively.** | none |

## Validation

- Direct guarded elaboration of
  `RelativeConicArcs/AMELU/ExtensionFieldPencil.lean`: passed with no Lean
  stdout.
- After the second-order sector-purity upgrade, the guarded build queue
  rebuilt the module (17.74 seconds, 1,876,732 KiB peak) and its dedicated
  import gate (4.98 seconds, 1,800,408 KiB peak);
  the gate's exact-target no-build confirmation passed.
- The dedicated axiom audit built in 6.04 seconds and its exact-target
  no-build confirmation passed.  Every audited declaration reports only
  `propext`, `Classical.choice`, and `Quot.sound`.
- `git diff --check` passed on all C633-owned paths.
- No manuscript source was edited.

**Vibe check:** the formalization lands at the right seam.  The divisor and
Galois algebra are now theorem-checked, while the genuinely hard
additive-Clifford transport remains visible as two small bridges instead of
being blurred into a false spread-reconstruction claim.
