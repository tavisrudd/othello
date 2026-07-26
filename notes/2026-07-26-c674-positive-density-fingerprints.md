# C674 positive-density coefficient fingerprints

**Lane:** `complete-ports`

**Status:** COMPLETE — exact coefficient-port transfer, trace duality,
eventual necessity and sufficiency, target density, concatenated parameters,
and the general MDS fingerprint theorem have complete human proofs and
paper-facing Lean terminals.  The formal closure contains no random-code,
AG-code, certificate, or enumerator input; random-GV or AG/TVZ existence of
the outer family is exposed separately as classical mathematics.

## Main theorem

Let \(L/\mathbf F_q\) be a finite separable extension, let
\(e:L\to I\leq\mathbf F_q^m\) be an inner encoder, and let
\(O_N\leq L^N\) be \(L\)-linear outer codes with
\(d(O_N^\perp)\to\infty\).  For a fixed inner coordinate \(x\) and radius
\(r\), put
\[
 z_x(I)=
 \begin{cases}
 \mu_x(0)+d(I^\perp),&I^\perp\ne0,\\
 \infty,&I^\perp=0.
 \end{cases}
\]
For all sufficiently large \(N\), every pointed dual witness through
\((j,x)\) of weight at most \(r+1\) is confined to block \(j\) if and only if
\[
 r+1<z_x(I).
\]
Under this condition, zero-extension gives exact copies of both the inner
support port and the normalized coefficient port in every outer block.  The
\(N\) copies among the \(mN\) concatenated coordinates have density \(1/m\).

If the inner code has parameters \([m,k,d]_q\) and the outer code has
\(L\)-dimension \(K_N\) and symbol distance \(D_N\), the concatenation has
\(\mathbf F_q\)-dimension \(kK_N\) and distance at least \(dD_N\).  Thus
positive outer rate and relative distance give concatenated rate \(kR/m\)
and relative distance at least \(d\delta/m\).

## Human proof

Every base-field functional on \(L\) is uniquely
\(a\mapsto\operatorname{Tr}_{L/\mathbf F_q}(ba)\).  If a functional tuple
\((\beta_j)\) annihilates the restricted outer code, apply it to every
scalar multiple \(ca\) of every outer word.  Trace nondegeneracy forces the
coefficient tuple \((b_j)\) into \(O_N^\perp\).  The trace representation is
coordinatewise injective, so it preserves support.  Hence the functional-dual
support distance equals the ordinary extension-field dual distance.

For fixed \(r\), every nonzero functional sector eventually has cost at least
\(r+2\).  The exact pointed cost formula then leaves only the zero-functional
sector in the bounded range.  Once \(N\ge2\), that sector has the fixed cost
\(z_x(I)\).  If \(r+1<z_x(I)\), every bounded witness is the zero-extension
of an inner word.  If \(r+1\ge z_x(I)\), the attained pointed minimum in the
target block plus a minimum nonzero inner-dual word in a second block gives a
bounded nonembedded witness.  This proves the iff.

Confinement identifies a normalized concatenated witness with its unique
nonzero block, proving coefficient-port equality rather than only equality
of support hypergraphs.  Conversely, zero-extension preserves dual
orthogonality, target normalization, helper count, and coefficients.  The
dimension and distance formulas follow from injectivity of the block encoder
and the fact that every nonzero outer symbol encodes to an inner word of
weight at least \(d\).

## Formal correspondence

`RepairPorts.PointedTransfer` now includes:

- `singleBlockWord_mem_coefficientPort`;
- `coefficientPort_concatenatedCode_eq_image_pointed`;
- `pointedZeroFunctionalCost`;
- `dualDist_le_pointedFunctionalFiberCost_zero`; and
- `two_mul_dualDist_le_pointedZeroFunctionalCost`.

The new module `RepairPorts.PositiveDensity` supplies:

- `representedTargets_density`, the cross-multiplied density \(1/m\);
- `concatenatedRestrictedCode_parameters`;
- `pointedConfinement_iff_zeroCost_of_outerDualDistance`;
- `prescribedPorts_of_outerDualDistance`;
- `OuterDualDistanceTendsToInfinity`;
- `eventually_pointedConfinement_iff_zeroCost`;
- `eventually_prescribedPorts`;
- `HasMDSDualParameters.pointedZeroFunctionalCost_eq`; and
- `eventually_mdsMinimumCoefficientFingerprints`.

For a positive-dimensional \([m,k]\) MDS inner code, the minimum normalized
coefficient port reconstructs the represented code, its support projection is
the complete \(k\)-uniform helper clutter, and
\[
 z_x(I)=2(k+1).
\]
The minimum support and coefficient ports therefore occur at density \(1/m\)
in every sufficiently long outer family covered by the theorem.

The Clebsch \([6,3,4]_{11}\) corollary is the \(m=6,k=3\) specialization:
already its radius-three coefficient port reconstructs the code,
\(z_x=8\), and both the minimum and full radius-five ports occur with density
\(1/6\).  Arc, projective Reed--Solomon, and classical AME code presentations
require no separate transfer theorem: whenever their represented inner code
meets the displayed MDS interface, the same formal corollary applies.  No
paper-local named identity is asserted for a presentation not defined in this
Lean closure.

## Classical input boundary

The formal theorem assumes the outer family and its dual-distance growth.
It does not postulate or prove its existence.

- The random-linear route is proved in the manuscript by the simultaneous
  first-moment bounds with exponential rates
  \(R+H_Q(\delta)-1\) and \(H_Q(\delta^\perp)-R\); the standard GV source is
  MacWilliams--Sloane, Chapter 17.
- The optional AG route uses evaluation/differential code duality and the TVZ
  tower bound from Stichtenoth, Chapters 2 and 7.
- The concrete completed field-nine family uses Stichtenoth,
  *Transitive and Self-dual Codes Attaining the Tsfasman--Vladut--Zink
  Bound*, Theorem 1.6(ii), over \(\mathbf F_{6561}\).

These are named literature inputs to existence only.  Trace duality, exact
port transfer, density, and parameter scaling are kernel checked.

## Validation

The final validation commands were:

```text
lean/scripts/guarded-lean RepairPorts/PointedTransfer.lean
lean/scripts/guarded-lean RepairPorts/PositiveDensity.lean
lean/scripts/lean-build-queue.py run RepairPorts.Gates.CompletePorts \
  --profile single --threads 1 --cores 20-23
lean/scripts/lean-build-queue.py run RepairPorts.Gates.CompletePorts \
  --profile single --threads 1 --cores 20-23
nix shell nixpkgs#tectonic -c tectonic complete_repair_ports.tex
```

The gate built successfully, its trace-only aggregate check passed, and the
second run confirmed the exact target current.  Every new terminal reports
only `propext`, `Classical.choice`, and `Quot.sound`.  The manuscript builds
without warnings.

## Closeout: extra value and expert-pressure pass

The expert-pressure pass exposed and closed the one real seam left by C673:
support-hypergraph equality did not by itself state equality of normalized
coefficient data.  The new witness-level zero-extension theorem now transfers
both layers from one confinement hypothesis, so later “fingerprint” language
cannot drift back to support-only semantics.

Two further free upgrades closed.  First, the asymptotic theorem is now an
eventual iff: growing outer dual distance removes the nonzero functional
sectors but cannot remove the fixed zero-sector obstruction.  Second, the MDS
specialization computes the obstruction exactly as \(2(k+1)\), so minimum-port
positive density is automatic and the Clebsch value \(8\) is no longer an
isolated calculation.

## Mystery ledger

| Mystery | Closeout verdict | Evidence or boundary |
|---|---|---|
| Did “complete-port transfer” prove coefficient data or only support data? | Settled: zero-extension is an exact image equality of normalized coefficient ports | `coefficientPort_concatenatedCode_eq_image_pointed` |
| Is \(r+1<z_x(I)\) only sufficient after concatenation? | Settled: it is eventually necessary and sufficient once outer dual distance clears the bounded range | `eventually_pointedConfinement_iff_zeroCost` |
| Does positive density depend on an asymptotic counting approximation? | Settled: there is exactly one selected coordinate per block, giving the finite cross-multiplied identity \(N m = m N\) | `representedTargets_density` |
| What remains external? | Exactly existence of an asymptotically good outer family with growing dual distance | Random-GV or AG/TVZ named input |
| Do arc, PRS, and AME examples require new transfer proofs? | No; they are instances of the represented MDS terminal when their source presentation supplies its hypotheses | `eventually_mdsMinimumCoefficientFingerprints`; source-paper identity boundary |

No genuine C674 mystery remains.  No incidental observation outside the
planned coefficient-transfer and positive-density work warranted a
discovery-track entry.
