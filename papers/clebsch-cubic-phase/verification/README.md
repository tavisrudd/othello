# Verification and trust boundary

Run from the artifact root:

```sh
nix develop .#manuscript --command make check
nix develop .#manuscript-pdf --command make pdf-check
```

Every theorem-like statement has formal coverage `absent`: no Lean declaration
or kernel-checked proof is claimed. `check.py` verifies ten statement digests,
annotation/claim agreement, proof identities, citation and label references,
dependency-graph freshness, package-local hashes, and exact rational spectrum,
product and factory inequalities. The source map records conventions and
read depths; it does not certify novelty or unexamined literature.

`finite_check.py --check` derives the cubic tensor from the evaluation matrices,
re-expands both normal forms, checks signed moments and Schur ranks, enumerates
all `19608` projective points for the six-variable `p=7` Hessian census, and
tests seven primes in the translation family. The resulting vector census is
`(1,48,2940,26502,88158)` at ranks `0,3,4,5,6`.

`shadow_check.py --check` checks the actual/projective scalar `2`, the
involutory exchange, and every one of `1320` geometric actions. Exactly `60`
preserve the five-dimensional space, and their determinant-one restrictions
exclude the specified determinant-minus-one involution. It reads three pinned
serialized intermediates and reuses the included finite-field substitution
utilities. It does not independently derive the geometric representation.
[`../supplement/replay_shadow.py`](../supplement/replay_shadow.py) regenerates
that representation and the Hankel identification in an isolated copy.

`../supplement/factory/benchmark.py --check` regenerates exact enumerators and
rational interval constants. It compares direct enumeration with MacWilliams
transforms and synthesis-kernel enumeration with the Fourier formula. There
is no floating-point decision or random seed in this certificate.

`check_pdf.py` copies TeX sources to a fresh directory, builds twice using the
pinned epoch and toolchain, rejects layout/reference warnings, and requires
byte equality with `clebsch-cubic-phase.pdf`. It writes no manuscript source.

## Evidence identity

`input-hashes.json` pins the public supplementary scripts, data and compact
records. `local-hashes.json` pins lightweight checker sources and certificates.
The original large `p=11` census and distance-three subspace search remain
recorded exhaustive executions rather than independently repeated full searches.
Their commands, finite domains, sampled branches and costs are described in
[`../supplement/REPRODUCING.md`](../supplement/REPRODUCING.md).

`dependency_graph.py` records authored conceptual statement dependencies and
logical proof dependencies. The graph is not inferred from cross-references.
The statement digest strips annotation macros and normalizes layout, so a
mathematical edit requires explicit review before its digest is refreshed:

```sh
python3 verification/refresh_claim_digests.py semantic-label
python3 verification/dependency_graph.py verification/dependency-graph.dot
```

The finite and shadow certificates can be regenerated using each script's
`--write` mode; the factory certificate uses the same option. Regenerate a
whole affected certificate, then update its checksum record. A checksum match
establishes file identity, not an independent mathematical proof.
