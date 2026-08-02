# C719 — Golden six-mode demonstrator design

**Lane:** `golden`

**Status:** ready; C715 and C718 complete

## Objective

Specify a realistic six-mode experiment that measures the golden
three-fermion amplitudes, their signs, and at least one anomaly or
boson--fermion identity with a complete resource and error budget.

## Gates

1. Choose between native fermions and the established entangled-photon
   emulation of fermionic statistics using explicit feasibility criteria.
2. Decompose the frozen six-mode orthogonal transforms and diagonal filter
   into platform-native beam splitters/gates, phases, and attenuation.
3. Specify preparation, number-resolved detection, postselection, and a
   coherent reference or parity-readout method that recovers
   \(\operatorname{sign}Z_T\), not only \(Z_T^2\).
4. Implement the C715 chiral witness and the C718 bosonic control experiment;
   calculate success rates, shots, loss sensitivity, distinguishability,
   and calibration requirements.
5. Prove which identities survive realistic coherent phase error and
   mode-dependent loss, and identify the first falsifiable signature.
6. Implement the C720 simplex-syndrome decoder.  Compare the minimal
   three-sign sister classifier, the five-cycle protocol whose magnitudes
   certify golden membership and signs identify the projective sister, and
   the full ten-sign distance-six readout correcting two sign errors.  Keep
   the residual \(c\) versus \(-c\) orientation requirement explicit.  Use
   the regular-simplex matched-filter decoder
   \(T=\arg\max_U\langle y,r_U\rangle\), and exploit the transpose
   \(\operatorname{ETF}(5,10)\) for conditioning and noise analysis.
7. Refresh the hardware literature at design time and distinguish a proposed
   circuit from any already demonstrated component or complete device.

## Acceptance

- A platform-specific circuit/netlist and exact ideal predictions.
- A quantitative error and sample-complexity budget sufficient to decide
  feasibility.
- An optimal measurement schedule for certification, sister identification,
  and noisy decoding, with the three-, five-, and ten-cut tradeoffs stated.
- A clean go/no-go verdict and a list of claims the experiment could
  actually establish.

## Boundary

This is a design study, not an assertion that the device has been built or
that it realizes a dynamical gauge theory.

## Dependencies

C715 and C718 are complete.  C717 is optional input if a Majorana platform
is selected.  C718 supplies both the pivot-gauge collision-free ratios and
the basis-free symmetric-cube/exterior-cube spectral discriminator.
