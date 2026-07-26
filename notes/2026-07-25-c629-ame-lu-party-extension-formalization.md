# C629: formalization of split party-permutation extension consequences

**Lane:** `ame-lu`

**Status:** complete

## Result

`RelativeConicArcs.AMELU.PartyExtensionSplitting` formalizes the reusable
mathematics behind the concrete split extensions computed previously.
For an arbitrary group extension
\[
  1\longrightarrow N\longrightarrow E\longrightarrow G\longrightarrow1
\]
with a homomorphic splitting \(s\), Lean now constructs, relative to any
normalized section \(\sigma\), the explicit normalized kernel cochain
\[
  b(g)=\operatorname{sectionChange}(\sigma,s)(g)
\]
and proves the ordered nonabelian identity
\[
 b(g)\,\alpha_g(b(h))\,f_\sigma(g,h)\,b(gh)^{-1}=1.
\]
It also proves:

- multiplication by \(b(g)\) changes \(\sigma(g)\) into the homomorphic
  lift \(s(g)\);
- \(E\) is multiplicatively equivalent to
  \(N\rtimes_{\operatorname{conj}(s)}G\);
- every \(e\in E\) has unique coordinates
  \(e=\iota(n)s(g)\);
- \(\operatorname{Nat.card}(E)=
  \operatorname{Nat.card}(N)\operatorname{Nat.card}(G)\); and
- for a commutative kernel, a lifted quotient involution acting by
  inversion is itself an involution and conjugates every kernel element
  to its inverse.  This is the exact abstract witness behind the
  split-torus enlargement \(T\subseteq T\rtimes C_2=N(T)\).

The AME--LU specialization converts a
`GenericPartyPermutationExtensionSplitting` into the abstract splitting
structure and exposes the exact correction cochain, coboundary identity,
semidirect-product equivalence, and cardinality formula for the realized
projective party-permutation extension.

## Formal terminals

The general terminals are:

- `GroupExtension.Splitting.trivializingCochain`;
- `GroupExtension.Splitting.trivializingCochain_one`;
- `GroupExtension.Splitting.inl_trivializingCochain_mul`;
- `GroupExtension.Splitting.trivializingCochain_coboundary`;
- `GroupExtension.Splitting.semidirectProductEquiv`;
- `GroupExtension.Splitting.existsUnique_inl_mul_splitting`;
- `GroupExtension.Splitting.natCard_middle`;
- `GroupExtension.Splitting.InvertsKernel`;
- `GroupExtension.Splitting.inl_conj_eq_inv`; and
- `GroupExtension.Splitting.invertingInvolutionWitness`.

The realized AME--LU terminals are:

- `genericPartyPermutationGroupExtensionSplitting`;
- `genericPartyPermutationTrivializingCochain`;
- `genericPartyPermutationTrivializingCochain_one`;
- `genericPartyPermutation_correctedSection_eq_lift`;
- `genericPartyPermutationTrivializingCochain_coboundary`;
- `genericPartyPermutationSemidirectProductEquiv`; and
- `genericPartyPermutation_natCard`.

The dedicated import and axiom gates are
`RelativeConicArcs.Gates.AMELUPartyExtensionSplitting` and
`RelativeConicArcs.Gates.AMELUPartyExtensionSplittingAxioms`.
The main `AMELUAggregate` and `AMELUAggregateAxioms` gates import and audit
the same terminals.

## Tao and extra-juice design pass

The direct formalization candidate was a generated transcription of twelve
finite lookup tables.  That would have frozen presentation-dependent
sections and factor-set indices while obscuring the theorem common to all
rows.

The higher-value target is the implication actually used by every example:
a verified complement supplies a homomorphic section; that section gives
the exact cochain trivialization and semidirect decomposition.  Mathlib
already contains the underlying semidirect-product equivalence for a split
`GroupExtension`; the new layer extracts the normalized cochain, unique
coordinates, cardinality consequence, and AME--LU specialization.

The extra-juice pass added the inversion witness.  It isolates the entire
\(T\)-to-\(N(T)\) mechanism in two hypotheses: an order-two quotient
element and inversion on the commutative kernel.  This makes the logical
normalizer jump reusable independently of the six-party presentations.

## Exact trust boundary

The Lean module is symbolic and kernel checked.  It contains no generated
data, native evaluation, axiom, or admitted declaration.  The audited
terminals use only `propext`, `Classical.choice`, and `Quot.sound`.

The concrete finite rows remain certified by
`2026-07-25-c624-ame-lu-party-extension-examples.py` and its canonical JSON.
Lean does **not** presently check that those local symplectic tables define
the claimed twelve complements.  Instead, the formal interface takes the
mathematically exact object that a future imported finite certificate must
produce:
`GenericPartyPermutationExtensionSplitting ψ`.  Once such a witness is
supplied, every cochain, splitting, decomposition, order, and inversion
consequence above is kernel checked.

Thus the abstract splitting consequences are formalized unconditionally,
while the code-specific existence witnesses remain externally computed.
No manuscript source was edited.

## Validation

- Warning-free guarded elaboration of
  `RelativeConicArcs.AMELU.PartyExtensionSplitting`.
- Exact queued build of the new module:
  `/home/tavis/.cache/othello-lean-build/run-20260726-014004-e1123ba8`.
- Exact queued build of the dedicated import gate:
  `/home/tavis/.cache/othello-lean-build/run-20260726-014048-2a61e4fd`.
- Exact queued build of the dedicated axiom gate:
  `/home/tavis/.cache/othello-lean-build/run-20260726-014343-130e95cc`.
- Exact queued build of the main AME--LU aggregate:
  `/home/tavis/.cache/othello-lean-build/run-20260726-014614-e06e03ac`.
- Exact queued build of the main AME--LU aggregate axiom audit:
  `/home/tavis/.cache/othello-lean-build/run-20260726-014703-09a216e6`.
- A terminal exact-target probe skipped the aggregate axiom target as
  trace-current:
  `/home/tavis/.cache/othello-lean-build/run-20260726-014721-55f0ccc7`.

The main aggregate axiom output reports only `propext`,
`Classical.choice`, and `Quot.sound` for all newly audited declarations.

## Mystery ledger

| feature | closeout status | exact remaining boundary |
|:--|:--|:--|
| Why does a nonidentity canonical factor set coexist with splitting? | **Settled formally:** the explicit section-change cochain satisfies the ordered nonabelian coboundary identity. | none |
| Does a complement give more than an existence proposition? | **Settled formally:** it gives a semidirect equivalence, unique coordinates, and the exact cardinality product. | none |
| What is the reusable content of the \(T\)-to-\(N(T)\) jump? | **Settled formally:** an inverting lifted involution supplies the dihedral-normalizer witness. | none |
| Are the twelve finite C624 complements kernel checked by Lean? | **No:** their existence remains an external exact computation. | a generated finite-table semantics and checker producing `GenericPartyPermutationExtensionSplitting` witnesses |
| Should the twelve presentation-dependent factor tables be copied verbatim into Lean? | **Settled negatively for this task:** the reusable theorem is now formal, while copying indices alone would not check their code-theoretic semantics. | any future import must verify preservation of the CSS Lagrangian and completeness of the party image |

**Vibe check:** strong.  The formalization captures the theorem that explains
all twelve computations and adds the exact normalizer witness, without
mislabeling externally generated complements as kernel-checked facts.
