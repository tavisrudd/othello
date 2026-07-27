# The trust model for this Lean tree

Start here if you are reviewing what these proofs establish. This file states the model every
paper-facing closure in the tree follows, indexes the per-paper trust manifests, and says plainly
what the generated certificate trees are and are not.

Two documents in this directory have narrower scope than their names suggest: [`TRUST.md`](TRUST.md)
and [`README.md`](README.md) cover the NodeKayles/queens `getK` evaluator only. They are not
portfolio documents.

## The contract

A paper-facing claim is admitted through six layers. Only the first three are intellectual proof
structure; the last three are reproducibility infrastructure, and a reader should never have to
reason about them.

| Layer | What it is | Where it lives |
|---|---|---|
| Semantic claim | The theorem as a mathematician would state it | The paper; the terminal Lean theorem |
| Reduction | Proved normalization cutting the claim to a finite classification | Handwritten Lean |
| Checker | One small generic predicate plus its soundness theorem | Handwritten Lean |
| Certificate data | Untrusted literal witnesses the checker consumes | Generated `*Data/` trees |
| Aggregate | One import-only target whose build kernel-checks the whole closure | [`RelativeConicArcs/Gates/`](RelativeConicArcs/Gates/) |
| Replay | An independent implementation reproducing the finite result | Committed scripts beside the report |

The size of a generated tree is not the size of the trusted surface. A reviewer counting files
learns nothing; the question is what each `decide` discharges. Where a leaf instantiates one
generic predicate against witness data, the trusted surface is the predicate and its soundness
theorem, however many leaves there are. Where leaves carry bespoke per-row reasoning, the trusted
surface grows with the tree — that is the real distinction, and each manifest should say which
shape its data has.

## Per-paper manifests

| Area | Manifest | Gate target |
|---|---|---|
| Arcs complete outside a conic | [`RelativeConicArcs/TRUST.md`](RelativeConicArcs/TRUST.md) | `RelativeConicArcs.Gates.Relconic` |
| Clebsch reflection-arrangement decoding slice | [`RelativeConicArcs/CLEBSCH_TRUST.md`](RelativeConicArcs/CLEBSCH_TRUST.md) | `RelativeConicArcs.Gates.ClebschReflectionArrangementDecoding` |
| Equivariant robust completion (Q25) | [`RelativeConicArcs/TRUST.md`](RelativeConicArcs/TRUST.md) | `RelativeConicArcs.Gates.AlternateOrbitRepair*` |
| Baer completion | [`FiniteGeom/BaerCompletion/TRUST.md`](FiniteGeom/BaerCompletion/TRUST.md) | `RelativeConicArcs.Gates.Baer` |
| Repair codes / ports | [`RepairCodes/TRUST.md`](RepairCodes/TRUST.md) | see manifest |
| Complete bounded repair ports | [`RepairPorts/TRUST.md`](RepairPorts/TRUST.md) | `RepairPorts.Gates.CompletePorts` |
| Dihedral Schreier | [`DihedralSchreier/README.md`](DihedralSchreier/README.md) | see README |
| NodeKayles / queens `getK` | [`TRUST.md`](TRUST.md) | see `README.md` |

Areas without a manifest do not yet have a stated trust boundary. Crowns is in that state. The
Clebsch manifest currently covers only the reflection-arrangement decoding slice, not the complete
manuscript.

## Named classical inputs

Results cited rather than reproved are first-class trust items, not implementation details. Each
must record the statement used, where it enters, and what remains unconditional without it.

| Input | Enters as | Recorded in |
|---|---|---|
| Kim–Vu complete-arc bound | named hypothesis in theorem signatures, never a global axiom | [`RelativeConicArcs/TRUST.md`](RelativeConicArcs/TRUST.md) |
| NRC/GRS dictionary | cited classical input; Lean owns the implication after it | [`RelativeConicArcs/TRUST.md`](RelativeConicArcs/TRUST.md) |
| Al-Seraji–Al-Ogali class count | external consistency check only, never a proof input | [`RelativeConicArcs/TRUST.md`](RelativeConicArcs/TRUST.md) |
| Stichtenoth self-dual TVZ family | global project axiom, stated once | [`RepairCodes/TRUST.md`](RepairCodes/TRUST.md) |
| Singer regular action / disjoint multipliers | explicit theorem argument | [`RepairCodes/TRUST.md`](RepairCodes/TRUST.md) |
| Completion radii for classical sets | cited, not formalized | [`FiniteGeom/BaerCompletion/TRUST.md`](FiniteGeom/BaerCompletion/TRUST.md) |

A named hypothesis in a signature is stronger than a global axiom, because it makes every theorem
that avoids the import visibly unconditional. The Kim–Vu row is the pattern to copy; the
Stichtenoth row is a global axiom and is the weaker shape.

## What the hashes do and do not establish

Every generated tree records its generator and a payload hash. A hash proves that two files are
identical. It does not prove that either is mathematically correct, and it does not prove that the
generator still reproduces the artifact on the current toolchain — an artifact frozen months ago
has an identity, not a demonstrated regeneration. Correctness comes from the checker soundness
theorem and the kernel; reproducibility comes from an actual regeneration pass.

## Kernel feasibility

Set-level `decide`s over `Finset`/`Multiset` are quadratic in kernel work and fail late — after a
generator has already been written and run. Deciding an opaque arithmetic operation fails the same
way. The convention that survives at scale is to keep decided statements pointwise, replace any
kernel-opaque operation with a reducible evaluator plus a symbolic bridge, and push set-level facts
into handwritten lemmas. Before committing to any new certificate architecture, benchmark one real
shard; a projected tree that cannot be kernel-checked is not an architecture.

## Design reviews

Two reviews record the reasoning behind this model and are worth reading before changing it:

- [`../notes/2026-07-18-c151-orbit-completeness-fable-review.md`](../notes/2026-07-18-c151-orbit-completeness-fable-review.md)
  — kernel-cost analysis of set-level decides, and the evaluator/bridge convention applied to a
  concrete failure.
- [`../notes/2026-07-18-c151-certificate-portfolio-fable-review.md`](../notes/2026-07-18-c151-certificate-portfolio-fable-review.md)
  — portfolio-wide certificate dependencies, the limits of the contract above, and the conditions
  under which independent solvers or a second computer-algebra run count as evidence.
