# C769 — Photonic presentation and design-limit gate

**Lane:** golden

**Date:** 2026-08-01

**Status:** complete

## Result

The photonic section of
papers/golden-quantum-statistics/golden_quantum_statistics.tex is now a
complete, falsifiable design-limit presentation rather than a prose sketch.
It keeps three claims separate:

1. coherent transfer tomography infers a calibrated determinant sign from the
   reconstructed one-particle matrix;
2. ordinary photons measure calibrated bosonic controls;
3. direct three-fermion emulation requires three matched logical copies and an
   external totally antisymmetric three-photon qutrit source.

The section does not claim a built device or source.

## Circuit and figure

The paper fixes
\[
 U_T(x)=O_T^{\mathsf T}D_xO_T,\qquad
 O_T=[Q_{T,+}\ Q_{T,-}],
\]
with input ports \(0,1,2\), output ports \(3,4,5\), and \(K_T\) the
row-\(3{:}5\), column-\(0{:}2\) subblock.  It states the adjacent-mode
Givens convention and prints the complete fifteen-cell base-\(O_T\) netlist,
including the input phase signs and certified reconstruction tolerance.

The hardware ledger is explicit:

- a balanced \(U_T\) has a direct compilation using at most 15 cells per
  copy;
- a general real filter uses two 15-cell meshes and six variable attenuators
  per copy;
- three spatial emulator copies use 18 modes and at most 45 balanced or
  90 filtered cells, with 18 attenuators in the filtered case;
- amplitude transmission \(x_i\) means intensity transmission \(x_i^2\),
  and a \(0/\pi\) phase carries its sign.

The new grayscale TikZ figure displays the six-mode sandwich above three
non-overlapping readout branches.  Solid encodings mark the feasible coherent
and bosonic precursor; a dashed source and arrow mark the unmet dependency
for direct fermionic emulation.  A 150-dpi rendering of the publication PDF
was inspected after the final layout repair.  The figure is legible without
color and at the paper's text width.

## Nulls and quantitative gates

The primary structural tests are
\[
 r_1=\sum_T\widehat Z_T,\qquad
 r_3=\sum_T\widehat Z_T^3.
\]
The paper now also gives the scale-free reporting scores
\[
 \rho_1=\frac{|r_1|}{\sum_T|\widehat Z_T|},\qquad
 \rho_3=\frac{|r_3|}{\sum_T|\widehat Z_T|^3}.
\]
These make the null-test report invariant under uniform transmission while
retaining \(r_1\) as the first falsification test and \(r_3\) as the nonlinear
confirmation.

The determinant perturbation gate is stated as an operator-norm requirement
on the reconstructed transfer:

- balanced sign: \(\lVert E\rVert_2<0.1193\);
- weakest chiral sign: \(\lVert E\rVert_2<0.00472\);
- ten-percent weakest-chiral amplitude precision:
  \(\lVert E\rVert_2<4.72\times10^{-4}\).

The shot table records the assumptions—independent Bernoulli accepted trials,
normal approximation, ten-percent relative precision, and simultaneous
95-percent coverage over six probabilities.  The accepted-trial counts are
4,742 for each balanced fermionic protocol and 3,473,883 for the smallest
chiral branch; the calibrated weak bosonic and largest chiral controls are
also shown.  The table explicitly excludes source, coupling, propagation, and
detector losses from its accepted-trial rate.

The external-resource paragraph retains both preparation proposals and the
C768-licensed sentence: “To our knowledge, no experiment has prepared and
characterized this three-photon qutrit singlet.”  It does not turn that
bounded audit into a nonexistence theorem or extrapolate source engineering
from the adjacent GHZ experiment.  The arbitrary-mixture and fidelity-only
worst-case quality thresholds are stated as model-dependent design gates.

## Trust boundary and validation

No new finite census or empirical claim was introduced.  The netlist,
probabilities, robustness bounds, shot counts, and source-quality thresholds
are imported from C719's committed generator/certificate/replay bundle; the
literature-dependent source sentence is imported from C768's recorded audit.
The only new formulas, \(\rho_1\) and \(\rho_3\), are direct normalizations of
the displayed polynomial residuals.

From papers/golden-quantum-statistics:

    make check

passes the paper-local exact import checker, TeX spacing lint, XeLaTeX build,
reference/citation resolution, and zero-warning gate.  The resulting paper is
ten pages.  The final figure was rendered independently with Poppler and
inspected at 150 dpi.

## EJ + Tao closeout

The extra-juice pass asked what cheap addition would make the physical nulls
portable across transmission levels.  Raw \(r_1\) and \(r_3\) have different
homogeneous scaling, so the paper now supplies \(\rho_1\) and \(\rho_3\).
This closes the reporting ambiguity without changing the exact null
identities.

The Tao-style pass asked which statement can actually falsify the shared
Golden carrier before a low-probability comparison is attempted.  The answer
is the linear residual.  The revised hierarchy therefore puts \(r_1\) first,
\(r_3\) second, calibrated probabilities after both, and the direct
many-fermion interpretation behind the antisymmetric-source gate.

## Mystery ledger

| Feature | Status | Evidence gap, gate, or owner |
|---|---|---|
| Raw linear and cubic residuals scale differently under uniform loss | **Settled** | The scale-free scores \(\rho_1,\rho_3\) are now defined in the paper. |
| Two preparation proposals exist, but no characterized three-photon qutrit singlet experiment was located | **Open external dependency** | C770 must rerun C768's pinned graphs at submission; Google Scholar, MathSciNet, and a subject-expert check remain uncovered. |
| Worst-case weakest-chiral fidelity is far more severe than its shot count | **Settled as a model boundary** | The paper labels the arbitrary-mixture and trace-distance gates as adversarial; a future source prototype with a characterized noise model would own any relaxation. |

No other genuine mystery remains within C769's circuit, readout, robustness,
budget, and presentation scope.  Review against the discovery-track
discriminator found no incidental observation to append.

**Vibe check:** the physical story is now unusually crisp: the circuit and
precursor are modest, the null tests are strong, and the exact point at which
the experiment stops is visible rather than buried in feasibility prose.
