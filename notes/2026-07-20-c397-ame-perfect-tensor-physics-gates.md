# C397 — AME-pencil perfect-tensor and Clifford physics gates

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** queued; C395 dependency complete, Stage B still gated on a positive Stage-A invariant

## Purpose

Determine whether the Clebsch/C384--C395 AME pencil yields a physics-facing theorem stronger than
the already proved existence and local-unitary inequivalence of its stabilizer `AME(6,q)` states.
The task succeeds only with an exact Clifford, logical-gate, or operator-pushing statement.  A
larger automorphism table or the word "holographic" is not a positive outcome.

The inputs are deliberately separated:

- C374 proves that the fixed `q=11` Clebsch state is LU-inequivalent, even after party
  permutation, to every six-point GRS AME class.
- C375 gives exact three-gate preparation, all six `[[5,1,3]]_11` encoder views, and all twenty
  permutation-multiunitary flattenings.
- C384 gives the two non-GRS monomial/LU classes in the `q=11` pencil.
- C395 proves the all-odd-field admissibility/GRS counts and the extension-stable `t=-1` towers:
  GRS/`S4` in characteristic 17 and non-GRS/`A5` in characteristic 31.
- C396 owns pencil-internal holonomy completeness or its first exact failure; C397 does not absorb
  that classification problem.

## Stage A — exact Clifford and encoder pilot

For the two `q=11` non-GRS classes and one representative from each GRS orbit, compute and
independently certify:

1. the full party-permuting local-Clifford stabilizer of the six-party state, with its projection
   to the party permutation group and its kernel;
2. for each of the six choices of input leg, the induced logical Clifford subgroup of the
   `[[5,1,3]]_11` encoder;
3. the minimum-output-support operator-pushing relation for single-leg Pauli operators and its
   orbit decomposition under the exact tensor automorphism group; and
4. whether any one of these data separates the two non-GRS classes from every GRS tensor by an
   operationally stated invariant.

Use exact finite symplectic linear algebra.  Quotient global phase and distinguish carefully among
projective/monomial code automorphisms, local Clifford equivalence, arbitrary LU equivalence, and
party permutation.  A code automorphism is not automatically a transversal logical gate; the map
to the selected encoder and its logical action must be exhibited.

**First stop rule.**  If the Clifford and operator-pushing data are determined entirely by the
known projective stabilizer and AME parameters, record the exact factorization and close Stage A as
a bounded negative.  Do not build tensor networks or launch an all-field census.

## Stage B — arithmetic symmetry phase

Stage B now requires only a positive Stage-A invariant.  Evaluate it symbolically where possible.
Equivalence comparisons must stay within a fixed local dimension: over `F_(17^n)`, compare the
GRS/`S4` member with non-GRS members over that same field; over `F_(31^n)`, compare the non-GRS/`A5`
member with GRS classes over that same field.  Over `F_31` the pencil has no GRS parameter because
`chi(-1)=-1`, so the latter controls are external GRS classes.  Do not compare the 17- and 31-
dimensional states directly, and do not rerun the projective stabilizer census.  The target is an
exact arithmetic classification of the resulting Clifford/logical/operator-pushing symmetry
phase, not a claim of a thermodynamic phase transition.

Stop at the first additional enhancement characteristic, prime-power exception, or need for an
unbounded field census.  A corrected finite exception table is a valid bounded negative; it does
not prove an all-field classification.

## Evidence and literature boundary

Any finite claim requires a deterministic script, canonical JSON, checksum manifest, replay
command, and an independent direct-symplectic or direct-stabilizer check under the repository's
evidence rules.  Every paper-facing mathematical claim, including the finite conclusions consumed
by the theorem, is a Lean target under the Clebsch trust policy; the external certificate bundle
remains a reproducible discovery and independent-replay layer rather than the final trust boundary.

Before novelty wording, audit primary and forward literature on stabilizer AME states, perfect
tensors and multiunitary matrices, local-Clifford automorphism groups, quantum MDS encoders,
transversal Clifford gates, and operator pushing in stabilizer tensor networks.  The following are
prior art and receive no novelty wording by themselves:

- the MDS--AME/perfect-tensor dictionary;
- the `AME(6,q)` quantum-secret-sharing and erasure-correction consequences;
- multiunitarity of an AME tensor;
- using a perfect tensor as a holographic-code building block; and
- the existence of infinitely many LU classes of `AME(6,11)` states.

## Adjacent physics doors — documented, unallocated

These candidates remain behind explicit promotion gates.  C397 allocates none of them.

1. **Tensor-network A/B test.**  Build the smallest identical stabilizer networks from a GRS and a
   Clebsch tensor and compare exact distance, logical Clifford group, and operator-pushing spectra.
   Promote only if Stage A supplies a local invariant likely to survive contraction; stop if the
   networks are Clifford-equivalent or differ only by relabelling.
2. **Fourier-self-dual noise or spin model.**  Use C372's rank-eight translation scheme to define
   an explicit Pauli-diagonal channel family or interaction model whose parameters and observables
   are preserved by the scheme Fourier transform.  Promote only after writing the channel or
   partition function and deriving one nontrivial dual observable.  `P=Q` alone is not a physical
   duality.
3. **Bring `J[2]` as four-qubit phase space.**  Test whether C390's eight-dimensional quadratic
   module and centralizing `S3` admit an explicit Pauli/Clifford realization with a meaningful
   action on stabilizer states or contexts.  Stop if the comparison is only an abstract
   `O_8^+(2)` isomorphism.  No string-theory, lattice-CFT, or physical `E8` conclusion is implicit.
4. **Protocol-level secret-sharing distinction.**  All six-party AME tensors already give the
   standard threshold secret-sharing and erasure tasks.  Promote a Clebsch-versus-GRS comparison
   only if it changes an exact implementation metric such as transversal symmetry, authorized-set
   circuit cost, or fault propagation; LU inequivalence alone is not an operational advantage.
5. **Arithmetic multiunitary census.**  C395 may give exact existence and GRS/non-GRS counts across
   odd local dimensions.  This belongs first to C395/C397; promote a separate classification only
   if the quotient by the relevant physical equivalence is proved rather than inferred from raw
   parameter counts.

## Closed overclaim doors

- Arithmetic changes in `q` are not thermodynamic phases.
- A six-party AME state encodes no logical qudit until a leg split, puncture, or encoder view is
  specified; its symmetries are not automatically logical gates.
- The rank-eight translation scheme lives on a three-dimensional additive configuration group,
  not by itself a full even-dimensional discrete-Wigner phase space.
- Bring/`E8`/triality terminology alone has no established particle, string, or condensed-matter
  implication.
- Equal AME entropy data and LU inequivalence do not imply improved holographic distance or bulk
  reconstruction.

## Exit condition

C397 closes positively only with an exact, literature-audited operational theorem and its evidence
bundle.  Otherwise it records the sharpest factorization/collision and leaves the five adjacent
doors unallocated.
