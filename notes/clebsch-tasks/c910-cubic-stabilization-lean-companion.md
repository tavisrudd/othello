# C910 — Lean companion for cubic stabilization

**Lane:** `clebsch`

**Status:** active

## Objective

Build a referee-facing, Mathlib-only Lean companion for
`papers/cubic-stabilization-epilogue/`.  The authoritative package lives at
`papers/cubic-stabilization-epilogue/lean/` and is exported as part of the
paper repository.  Nothing is duplicated under `lean/TavisRuddFiniteGeom/` or
in a second standalone Lean repository.

The public library and namespace follow the C879 paper-facing convention:

```text
CubicStabilizationEpilogue
TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
```

## Formal standard

The companion is held to the same referee and trust standards as the existing
Lean artifacts in this repository:

- no `sorry`, `admit`, project axiom, opaque oracle, `native_decide`, unsafe
  declaration, or compiled-evaluation axiom in a paper-facing terminal closure;
- every public declaration and non-obvious definition has a self-contained
  mathematical docstring, with no workflow IDs, private paths, review history,
  or mutable manuscript numbering in the artifact;
- every manuscript claim in formal scope maps to an exact fully qualified Lean
  declaration, and every exported terminal is listed in the trust registry;
- the semantic gate imports the complete claimed closure and the axiom audit
  records the kernel-reported dependencies of every terminal;
- external literature is either proved in the exact weaker form used or stated
  as an explicit hypothesis of a conditional theorem.  Conditional scaffolding
  must never be reported as unconditional formal coverage of the manuscript;
- generated data, if any, must have a tracked generator, schema, semantic
  checker, coverage proof, replay command, and independent replay or an explicit
  reason none exists.

## Proof architecture

### Integral cycle spine

Formalize the algebraic mechanisms independently of abelian-variety machinery:

1. symmetric matrix-of-ideals lattices over a discrete valuation ring;
2. the exact midpoint criterion for rank-one generation, without division by
   two;
3. square-zero rank-one divisor calculus and integral divided-power expansion;
4. faithful-flat membership descent in the finitely generated quotient lattice;
5. local-to-global membership from the finite set of bad primes;
6. the six-axis Smith and finite-field packet calculations needed to instantiate
   the abstract theorem.

The Roulleau intersection theorem, relative intermediate-Jacobian construction,
Voisin criterion, and Torelli statement require either exact formal proofs or
explicitly typed external-premise interfaces.  Their deductive consequences are
formalized separately from those inputs.

### Quantum and birational spine

Formalize the paper's deduction at the natural abstract level:

1. an additive nonnegative packet multiplicity on smooth projective objects;
2. blow-up and projective-bundle operation formulas;
3. the low-dimensional vanishing implication for weak-factorization centers;
4. birational invariance through dimension four;
5. one-projective-line stabilization obstruction for threefolds;
6. transport across the genus-eight projective-bundle flop;
7. logical independence of universal `CH_0`-triviality and the packet invariant.

The existence and properties of framed quantum monodromy, divisor tagging,
Iritani comparison maps, Cai's cubic packet, weak factorization, and Kuznetsov's
geometric correspondence remain separately named external mathematical inputs
until formalized from foundations.  The artifact must make this boundary
visible in theorem types and in the claim map.

## Current state

The package has a pinned standalone Nix and Mathlib environment.  Its 17 Lean
sources build in dependency order through the guarded queue.  The reviewer
interface currently exports 28 audited terminals.  The rejecting manuscript
inventory covers all 23 labelled theorem-like environments: 7 absent, 13
fragmentary, 3 conditional deductions, and 0 complete.

The integral algebra now includes constructive two-coordinate midpoint
assembly, square-zero divided powers, the `6I-J` eigenspaces, an explicit
integral Smith reduction, and exact local depths at two and three.  The quantum
algebra includes framed-sixth multiplicity for supplied monodromy matrices,
pro-Laurent inverse-system types, coefficient-extension and conjugacy,
formal-base-shift and block-formula deductions, numerical coefficient
pushforward, strict-Novikov data, divisor-tag separation, typed
weak-factorization telescoping, and the arithmetic core of Cai's rank-two
indicial polynomial.

All geometric identifications and comparison theorems remain honestly outside
those fragments unless present as explicit typed premises.  The next integral
gates are the DVR necessity and arbitrary-size matrix-of-ideals theorem,
graph-lattice descent, and geometric six-axis instantiation.  The next quantum
gates are the differential-module base-change proofs, completed divisor
tagging, operation comparisons, low-dimensional vanishing, and Cai's actual
integral-`z` block diagonalization.

## Package shape

```text
papers/cubic-stabilization-epilogue/lean/
  lakefile.toml
  lean-toolchain
  README.md
  TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/
    GraphLattices/RankOneGeneration.lean
    GraphLattices/DividedPowers.lean
    GraphLattices/SixAxisGram.lean
    Quantum/FramedMultiplicity.lean
    Quantum/ProLaurent.lean
    Quantum/MonodromyBaseChange.lean
    Quantum/NumericalNovikov.lean
    Quantum/FormalBaseShift.lean
    Quantum/NovikovAdmissibility.lean
    Quantum/WeakFactorization.lean
    Quantum/CubicPacket.lean
    Quantum/PacketInvariant.lean
    Quantum/BirationalDeduction.lean
    Applications/CubicThreefold.lean
    Applications/GenusEightThreefold.lean
    PaperInterface.lean
    Verification/AxiomAudit.lean
  verification/
    claims.json
    check_formal_artifact.py
    expected_axioms.txt
```

The exact split may be compressed if a smaller module graph improves review and
build cost, but the semantic separation between proved algebra, external input,
and paper applications is fixed.  `PaperInterface` is the reviewer-facing
mathematical entry point; `Gate` is reserved for operational manifests and is
not used as a public module name.

## Verification and release gates

The aggregate paper check must:

1. lint Lean source and scholarly prose for forbidden workflow/status tokens;
2. reject `sorry`, `admit`, project axioms, unsafe declarations,
   `native_decide`, and undeclared non-kernel execution;
3. build exact targets through the guarded Lean queue;
4. run the semantic gate and capture `#print axioms` for every terminal;
5. compare the terminal set, claim map, and expected axiom output exactly;
6. reject orphaned manuscript claims and unregistered public terminals;
7. rebuild the manuscript deterministically and reject a stale tracked PDF;
8. record source/toolchain hashes and the canonical release-surface identity;
9. pass exporter audit and standalone-repository verification from the committed
   monorepo source.

## Completion gate

C910 is complete only when the package builds from a clean checkout, the
semantic and axiom gates pass, the manuscript claim map states exact coverage
without upgrading conditional results, the tracked PDF and verification output
are current, and the committed paper export verifies byte-for-byte in
`~/src/math-papers/cubic-stabilization-epilogue`.

## Mystery ledger

- **External-input closure:** unsettled.  The chief question is how much of the
  recent quantum comparison package can be reduced to algebraic formalism rather
  than retained as explicit premises.
- **Relative geometry:** unsettled.  The six-axis local-system argument and
  Voisin implication are mathematically human proofs but sit beyond Mathlib's
  present abelian-scheme and decomposition-of-diagonal APIs.
- **Reusable extraction:** deferred.  The matrix-of-ideals theorem may later
  deserve a separate general library, but the first authority remains the
  paper-bundled package.
