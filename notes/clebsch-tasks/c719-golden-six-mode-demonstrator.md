# C719 — Golden six-mode demonstrator design

**Lane:** `clebsch`

**Status:** queued after C715 and C718

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
6. Refresh the hardware literature at design time and distinguish a proposed
   circuit from any already demonstrated component or complete device.

## Acceptance

- A platform-specific circuit/netlist and exact ideal predictions.
- A quantitative error and sample-complexity budget sufficient to decide
  feasibility.
- A clean go/no-go verdict and a list of claims the experiment could
  actually establish.

## Boundary

This is a design study, not an assertion that the device has been built or
that it realizes a dynamical gauge theory.

## Dependencies

C715 and C718.  C717 is optional input if a Majorana platform is selected.

