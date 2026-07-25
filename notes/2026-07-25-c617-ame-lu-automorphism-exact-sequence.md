# C617: scalar-torus exact sequences and discrete automorphism quotients

**Lane:** `ame-lu`

**Status:** complete

## Result

`RelativeConicArcs.AMELU.AutomorphismExactSequence` upgrades the
product-unitary symmetry package from quotient carriers to exact group
structure.

- The fixed-party and party-permuted scalar-phase tori are closed normal
  subgroups.  Their inclusions are injective, their projectivizations are
  surjective, and each inclusion/projectivization pair is
  `Function.MulExact`.
- Both projective automorphism quotient groups are finite and have the
  discrete quotient topology.
- One-site Clifford matrices form a group, scalar matrices form its central
  subgroup, and their quotient is the intrinsic Clifford adjoint-signature
  group.
- The fixed-party and party-permuted signature detectors are genuine
  continuous group homomorphisms.  Their kernels are exactly the relevant
  scalar-phase tori, and the first isomorphism theorem identifies each
  projective automorphism quotient with its realized intrinsic signature
  subgroup.
- Forgetting local factors gives the realized party-permutation quotient.
  The fixed-party projective group embeds as its exact kernel, so
  \[
    1\longrightarrow \Gamma\longrightarrow\widetilde\Gamma
      \longrightarrow\Pi_{\mathrm{real}}\longrightarrow1
  \]
  is exact.
- `GenericPartyPermutationExtensionSplitting` states the precise splitting
  datum: a group-homomorphic right inverse to the realized permutation
  projection.  The equivalence
  `genericPartyPermutationExtension_splits_iff` exposes that obstruction
  without assuming a section.

Section 3 now states the two closed scalar-torus short exact sequences, the
finite discrete quotients, the realized party-permutation extension, and
the split criterion.  The theorem map, formal-statement adequacy table,
formalization ledger, verification map, and claim/proof/novelty ledger use
the same boundary.

## GRS splitting boundary

C613's `GRSTransversalInputs` supplies phase-corrected representatives of
the upper and lower unipotent generating families, logical Pauli
representatives, generation, and a carrier equality.  Those fields do not
give a multiplication-preserving choice of representatives, and they do
not mention realized party permutations.  Consequently they do not
construct a canonical section of either extension.  The manuscript and
formal ledgers now say this explicitly instead of inferring a split from
generator-by-generator lifts.

## Validation

- Warning-free guarded elaboration of
  `RelativeConicArcs.AMELU.AutomorphismExactSequence`.
- Measured single-thread builds of the new module,
  `RelativeConicArcs.Gates.AMELUAggregate`, and
  `RelativeConicArcs.Gates.AMELUAggregateAxioms`, followed by the exact
  trace-only aggregate gate.  The terminal successful run is
  `/home/tavis/.cache/othello-lean-build/run-20260725-223044-6661d2c8`.
- The fifteen new audited terminals depend only on `propext`,
  `Classical.choice`, and `Quot.sound`.
- Warning-free 19-page manuscript build.  The revised corollary page passed
  visual inspection.
- PDF SHA-256:
  `d8ae91e1cdb6954ca92f110e225304e6300e7eddc7761c35cf220b9bef234ccb`.

Implementation commit: `12267205`.

## `ej` and Tao closeout

The closeout tested three possible free strengthenings.

First, the finite detector should not depend on chosen matrix
representatives.  Replacing the old continuous maps by homomorphisms into
the quotient of the Clifford matrix group by its scalar center makes the
signature intrinsic and gives a canonical first-isomorphism identification
with the realized image.

Second, adjoining party permutations should expose a second exact
extension, not merely another finite quotient.  The fixed-party projective
group is now proved to be exactly the kernel of the realized permutation
projection.

Third, phase-corrected GRS generators were stress-tested as possible split
data.  They do not satisfy the required coherence: membership and
generation do not define a homomorphic section.  The strongest honest
statement is therefore the exact right-inverse criterion now formalized.

## Mystery ledger

| Feature | Closeout status | Evidence gap or owner |
|---|---|---|
| Are the continuous signature detectors multiplicative? | **Settled:** quotienting actual Clifford matrices by their scalar center gives intrinsic continuous group homomorphisms with exact scalar kernel. | none |
| What is the party-moving discrete group? | **Settled:** it is the realized subgroup of the intrinsic permutation semidirect product; its permutation quotient has the fixed-party projective group as exact kernel. | none |
| Does C613 canonically split the extension? | **Settled negatively at the available interface:** its phase-corrected generator representatives give no multiplication-preserving section and do not encode realized party permutations. | a split theorem requires an explicit `GenericPartyPermutationExtensionSplitting` witness |
| Is there a hidden topological component beyond scalar phases? | **Settled:** the scalar tori are the closed connected identity components and the quotients are finite discrete. | none |

No unexplained feature remains inside the unconditional exact-sequence
package.  The existence of a code-specific split is an explicit additional
datum, not a missing step in C617.

**Vibe check:** the automorphism story is now structurally complete and
cleaner than the earlier detector-only formulation.  The only restraint is
the right one: the available GRS interface proves an exact carrier, but not
a coherent split extension.
