# Complete bounded repair ports: trust manifest

This manifest covers the Lean declarations supporting *Complete Bounded Repair Ports: Local
Memory, Transfer, and Reliability*.  The paper-facing boundary is the import closure of
`RepairPorts.Gates.CompletePorts`.

## Terminal claims

The gate exports the exact support/coefficient bridge, reconstruction radius, MDS reconstruction,
pointed functional strata and transfer, positive-density fingerprints, finite reliability and
bounded-EXIT calculus, and the pointed rank-sum specialization with its radius-filtration
boundary.  It also exports the characteristic-three quartic--nucleus determinant and harmonic
completion laws, uniform exclusion of circuits below five, dual distance five, normalized
radius-four harmonic ports, and the abstract nucleus-gate closure identities.  The complete
terminal list and each declared axiom set live in
`trust/areas/complete_ports.toml`.

The completed projective twisted-cubic terminals give the exact `[2q+2,4,q]_q` parameters, prove
that radius four exhausts every full minimal port, and establish the uniform cubic and axis
matching/transversal rows at radius four and at full radius.

The reliability terminals prove deletion--contraction, pivotal derivatives, the homogeneous
Russo--Margulis identity, erasure-sign conditioning, the no-repair convention, radius truncation,
cheapest-repair-radius transforms, and the minimum-blocker expansion by finite sums and polynomial
algebra.  Exact finite profiles and Poisson approximations are not in these dependency closures.

The pointed-Tutte terminals identify the distinguished-element rank-jump subset sum with the
rank-one deletion--contraction perspective, identify the evaluated derivative difference with the
successful-set enumerator, and prove the two-repair inclusion--exclusion formula that separates
disjoint and overlapping radius-three repairs.  Matroid deletion, contraction, and duality enter
the manuscript as the displayed classical rank identities, not as project axioms.

The harmonic terminals use only coordinate algebra and finite linear algebra.  The exact primal
distance terminal exposes the sharp five-point hyperplane-section statement as a theorem
hypothesis; the manuscript proves that statement by the displayed degree-four root count.  The
classical normal-rational-curve nucleus attribution is explanatory and does not enter the Lean
dependency closure.

## Trust boundary

Every declared terminal is expected to depend only on `Classical.choice`, `Quot.sound`, and
`propext`.  The gate imports no generated certificate, native evaluation, executable enumerator, or
mathematical axiom.  The strict completed cubic--axis transfer terminal takes Singer regularity as
an explicit theorem hypothesis rather than a project axiom.

Existence of asymptotically good outer families is outside the gate's conclusions.  The manuscript
supplies random-GV or AG/TVZ existence as a named classical input after the kernel-checked
conditional transfer theorem.

## Validation

From `lean/`, the paper-facing gate is:

```text
lean/scripts/lean-build-queue.py run RepairPorts.Gates.CompletePorts \
  --profile single --threads 1 --cores 20-23
```

The portfolio registry checks this manifest with:

```text
python3 scripts/lean-trust-spine.py check --area complete_ports
```
