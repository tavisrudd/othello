# C239 — FABLE DO NOT READ — restricted-domain material

**Lane:** `rp-next`

**Date:** 2026-07-17

**Handling:** this companion intentionally contains material that triggers Fable safeguards. Fable
must not read, summarize, index, or follow links into this file. Human readers and other permitted
reviewers may use it normally.

**Source documents:**
[C239 audit](2026-07-17-c239-domain-translation-audit.md) and
[C239 scratchpad](2026-07-17-c239-domain-translation-scratchpad.md).

This file preserves the security-, cryptography-, access-control-, and secret-sharing-related
branches removed from the two ordinary C239 documents. Neutral pointers remain where material was
removed.

## 1. Secret sharing, LSSS, MPC, and access structures

The motivating local facts are C217, C228, and C237. Under the checked ideal linear
secret-sharing convention, support-identical matroid representations can have different
Schur-square ranks and different ordinary/strong multiplicativity behavior. C237 gives two
`U(3,8)` representations with the same `3-of-7` access structure but different strong
multiplicativity after adversary deletions.

Consequences considered in C239:

- an access structure is not a complete semantic security specification;
- the Boolean support hypergraph can forget coefficient information needed for multiplication;
- support-level identity need not imply identical MPC capability;
- a representation-aware preflight linter could hash the matrix, check the declared dealer and
  adversary structures, compute square-rank profiles, and emit positive or negative certificates;
- possible users include custom monotone-span-program, threshold, and linear-secret-sharing
  deployments; and
- the tool would be a linter, not a complete cryptographic security proof or a replacement for a
  mature MPC implementation.

The C239 structural prediction was that support-identical but capability-different examples should
also occur in other labelled linear systems. The restricted siblings were authorization policies
backed by different cryptographic realizations and small-threshold schemes with exceptional
field/characteristic behavior.

## 2. Representation-sensitive security and holonomy

Gain graphs and cellular sheaves already formalize locally labelled relationships whose cycle data
controls global consistency. Spectral sheaf theory uses local restriction maps and global sections
for distributed consistency
([Hansen--Ghrist](https://doi.org/10.1007/s41468-019-00038-7)); network-coding sheaves address
global extendability and information flow
([Ghrist--Hiraoka](https://doi.org/10.34385/proc.45.A4L-C3)). The restricted local result is an unusually small
representation-sensitive security separation: the same support matroid/access structure can yield
different Schur-square rank and strong multiplicativity.

The restricted prediction was:

> Whenever a policy is represented by a support hypergraph plus local linear maps, support-level
> policy equivalence may fail to preserve nonlinear or compositional security capability; a
> cycle/cocycle fingerprint may be the cheapest missing deployment identity.

Potential restricted-domain algorithm:

1. build the support/access-structure shadow;
2. quotient local coefficients by gauge changes;
3. compute a cycle/cocycle or sheaf fingerprint;
4. predict the multiplication/capability class; and
5. fall back to complete rank analysis when the fingerprint is inconclusive.

The novelty test is not whether holonomy exists. It is whether the fingerprint detects
coefficient drift or security-relevant capability change materially more cheaply than a full
global computation.

## 3. IAM, authorization, custody, and key rotation

The removed scratchpad lens treated support ports as authorization/quorum witnesses and blocker
families as denial coalitions. Candidate uses included:

- minimal permission sets enabling a capability;
- minimal policy/resource sets blocking legitimate recovery;
- alternative account or key-custody recovery routes;
- migration between share schemes;
- IAM configuration diagnosis; and
- rolling key rotation where every current state has some safe continuation but no single
  transition preserves all future profiles.

These ideas remain speculative and enter crowded access-control and policy-analysis fields.

## 4. Software-supply-chain and trusted-build branch

The removed branch observed that alternative builders, caches, source mirrors, signatures,
attestations, and dependency recipes form a recovery family. A capsule could seek a trusted
reconstruction route after one builder, cache, credential, or upstream source is compromised.

Candidate data carried by that capsule included:

- builder/source/artifact identities;
- signatures and attestations;
- dependency and provenance edges;
- minimal trusted rebuild routes;
- blockers showing that no trusted route remains; and
- proof/checking cost for the resulting artifact.

This was one proposed adjacent commercial wedge, but it requires a precise threat model and strong
comparison with existing software-supply-chain provenance and reproducible-build systems.

## 5. Attack, privacy, and cryptographic-testing branches

Other extracted predictions and examples were:

- factorized obstruction stores for attack graphs and policy explanations;
- algebraically stratified test generation for cryptographic or finite-field implementations;
- legal-continuation APIs leaking a hidden policy or configuration, creating a continuation-privacy
  question;
- authenticated or signed capsule metadata;
- untrusted agents proposing remediation plans checked against a smaller authority; and
- cryptographic validity labels as one instance of the C239 L1 semantic-label layer.

These were examples, not locally proved security results.

## 6. Restricted paper and product candidates

### Representation-aware LSSS/MPC linter

A narrow product that detects coefficient or representation drift invisible at the access-structure
level. It needs a real corpus of custom MSP/LSSS deployments and useful caught misconfigurations.

### Representation-sensitive capability shadows

Proposed specialist paper: support hypergraphs are lossy shadows of labelled linear systems, and
small cocycle/sheaf fingerprints may predict capabilities invisible to support. The existing
C217/C237 examples provide the seed; a second domain and a general invariant are required.

Assessment retained from C239: B/B+ specialist potential, possibly higher only if the fingerprint
avoids an otherwise expensive global computation.

## 7. Keyword disambiguation

One ordinary C239 phrase said “robust MPC” in the reconfiguration baseline. There `MPC` meant
**model-predictive control**, not multiparty computation. The ordinary document now spells this as
“robust control” to avoid a false safeguard trigger.
