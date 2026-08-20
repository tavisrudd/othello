# C925 — modular direct-QDM proof packet

**Lane:** `cubic-threefolds`

**Status:** active 2026-08-20

**Objective:** write a self-contained alternative proof packet for cubic
one-stabilization irrationality in which the QDM block information retained by
the argument is a parameter, analogous to a Haskell type class or a software
interface.

## Required architecture

1. Define an abstract generic even-QDM block and a parameterized marker datum:
   observation payload, acceptance predicate, and value in a commutative
   monoid.
2. Separate reusable modules for coefficient fields, regular block transport,
   direct-sum separation, blowups, projective bundles, and weak factorization.
3. Prove that forgetful/coarsening maps between marker data commute with every
   ledger operation.
4. Instantiate the framework with a compact marker sufficient for a cubic
   threefold: even rank two, nonzero centered nilpotent, and nonzero modified
   residue discriminant.
5. Include the corrected common-coefficient-spine argument from C924; never
   map a full `q`-adic completion into an opposite `q^{-1}`-Laurent completion.
6. Prove the cubic endpoint, low-dimensional vanishing, projective-bundle
   doubling, fourfold birational invariance, and contradiction with
   `P^4`.

## Acceptance gate

- The packet is mathematically self-contained modulo its explicitly listed
  primary inputs.
- The interface genuinely supports alternative retained payloads rather than
  merely renaming the cubic marker.
- Every generic-base and scalar-extension operation is typed explicitly.
- The concrete cubic instance does not retain unused odd-rank or exact-value
  data.
- A hostile final pass checks variance, additivity, coefficient topology,
  parity, and all low-dimensional cases.
- No manuscript or Lean file is edited.

## Current draft

The active packet is
[`2026-08-19-c925-modular-direct-qdm-proof-packet.md`](../2026-08-19-c925-modular-direct-qdm-proof-packet.md).
It currently contains:

- a lawful observer/selector/emitter interface with commutative-monoid values;
- a probe-indexed, marked-block extension whose singleton-generic instance is
  the direct-QDM proof;
- a free symmetric-monoidal 2-monad of blocks, indexed scalar-extension
  pseudofunctor, Beck--Chevalley law, and universal center localization;
- a monoidal center quotient through which center-vanishing markers factor;
- optional Bittner/group-completion, finite-Kan-coarsening, and
  endomorphism-category retention backends, with explicit information-loss
  cautions;
- corrected coefficient-spine, blowup, projective-bundle, and divisor-character
  adapters;
- counting, Boolean, exact-profile, parity-enriched, monodromy, and universal
  configuration examples;
- the minimal cubic instance and a category-theoretic summary diagram; and
- exact specialization audits for Guéré's evaluated
  \(\clubsuit/\heartsuit\) properties, the marked BFGMP coarse-atom criterion,
  and the KKPYY chemical-formula/dimension-filtration layer; and
- a bicategory of theory morphisms, an additive \(m\ge2\) no-go theorem, an
  ideal-quotient composition theorem, and a monadic
  \(\operatorname{Rep}(\mathbf G_a)\) specialization whose Clebsch--Gordan
  law forces the higher exceptional strings; and
- a sparse-shadow descent criterion, four-way reconstruction-fibre audit,
  kernel-profile and cyclic-Krylov reconstruction theorems, and a typed
  Reader/indexed-State/Writer/optic interface with pseudofunctorial path
  translation; and
- a concrete \(m=2\) specialization through the pointed formal-monodromy
  cyclic shadow, its common-threshold/reduced-nearby-cycle parallel
  projections, and the augmented operator-row category whose output kernel
  repairs the false naked row-null quotient; and
- direct augmented-row and conditional Orlov/Gamma rank-bridge criteria,
  dual cyclic-row descent with its exact strict-saturation hypotheses, and
  formal multi-sector, holonomic-growth, and exposed-face specializations
  which reduce but do not discharge the relative-cap provider; and
- a comma-bridge theorem for reading the point row from a higher retained
  projection, an exact torsor-holonomy theorem explaining why path state
  transports a chosen lift but cannot identify it with a canonical endpoint
  without a bridge/Beck--Chevalley certificate, and a simple-character
  criterion under which a genuinely separating retained action forces the row
  line, together with the Laurent-grading collision which rules out retaining
  only \(z\partial_z+\mu\), and the orthogonal common-open point theorem for
  wall-supported mutations, plus the generic-point localization theorem
  making rank the universal support-null additive character and the canonical
  boundary-to-rank leakage covector measuring the entire comparison defect;
  and
- a complete-source audit of Iritani's 2026 Hodge/cyclotomic blowup note,
  including the proved exceptional-cusp point symbol and the remaining
  large-radius Gamma frame gap; and
- a framed-small specialization which retypes the conditional Section 6
  \(m=1\) proof with the original \(z\)-disc and small point retained,
  Hypothesis 5.7R as a reconstruction-tail certificate, the consumed part of
  Hypothesis 5.7T as a residual-tagging certificate, and center nullity indexed
  by every actual comparison specialization \(\chi_j\); and
- a universal sufficient-shadow module proving that the indexed center-null
  ledger represents and detects all center-null markers, that every small
  marker family has a canonical minimal operation-stable shadow, and that
  parallel sparse shadows descend a marker exactly when their joint fibres
  do; and
- an updated \(m=2\) roadmap which replaces the raw irregular triangle and
  bare deck orbit by the exact Gamma/rank-row leakage gate or the strict
  operation-framed carrier gate, proves that any unbounded stabilization
  subsequence suffices, recodes \(\mathbf P^m\) birationally as
  \((\mathbf P^1)^m\), and derives the unique top \(J_{m+1}\) together with a
  conditional all-\(m\) dimension-versus-length criterion whose minimal
  consumer is the Boolean high-length shadow and whose providers need only
  exist on one cofinal fixed-factor family; and
- an explicit exploration frontier.

The finite categorical law model is
`notes/cubic-threefolds-tasks/c925-categorical-law-check.py`, with exact
checked output
`notes/cubic-threefolds-tasks/c925-categorical-law-check.json`.  It passes
forty-six tests, including a negative collision test showing why Guéré's
unit-shift separation contract is mandatory, the \(m\ge2\) constituent
no-go, \(\mathbf G_a\) Clebsch--Gordan through size five, and composition of
row-preserving shears, plus exact coordinate-pseudonaturality,
pairing/Hodge/operator and two-sided-row-kernel countermodels, the lawful
augmented-row output-kernel repair, positive and negative zero-mode
dual-row quotient tests, kernel-profile, Krylov, effect-stack,
optic/path-functor, the affine row-stabilizer group law, Orlov/Gamma rank-row
forcing, nonreversible provider
implications, positive and Stokes-sheared negative multi-sector
reconstruction tests, pointed \(m=2\) endpoint checks, exposed
exponential-face filtration and comma-bridge laws, the torsor-holonomy and
prescribed-endpoint obstruction, simple retained-character row forcing, the
Laurent grading-character collision, common-open mutation fixedness, and
universal generic-rank support-nullity.  A
rank-leakage test identifies the sole codimension-one quotient obstruction.
The framed-\(m=1\) additions check the conditional telescope with specialized
center nullity and give separate countermodels to both illicit replacements:
intrinsic center zero for specialized center zero, and ordinary coordinate
naturality for Hypothesis 5.7R.  In the finite
\((\mathbf Z/2)^3\) model, the universal-shadow additions exhaustively check
center-quotient factorization and detection, exhibit the factor from one
richer sufficient shadow to the joint marker image, and verify a case where
two projections jointly retain a marker although neither retains it alone
and the rich object is still forgotten.  The proof, not the example,
establishes terminality among all sufficient shadows.
The stabilization additions check the exact arithmetic-progression ceiling
logic, the unique top \(J_{kr+1}\) in bounded tensor powers of the fixed
\(J_{k+1}\) projective operation, and the one-step gap after the
codimension-dependent exceptional string, together with the heterogeneous
fixed-factor highest-string law.
A separate executable
Haskell toy at
`notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy.hs` verifies the
typed path translator, payload naturality, indexed bind laws, lens laws, and
the necessity of an optic residual.  The original exact cubic residue replay
also remains green.

Replay the categorical test with:

```bash
nix shell nixpkgs#python3 --command \
  python3 notes/cubic-threefolds-tasks/c925-categorical-law-check.py \
  | diff -u notes/cubic-threefolds-tasks/c925-categorical-law-check.json -
```

Replay the typed Haskell toy with:

```bash
nix shell nixpkgs#ghc --command \
  runghc notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy.hs \
  | diff -u \
      notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy-output.txt -
```

Keep C925 active: the user has asked to continue exploring the categorical and
software-interface design before closeout.

The framed-\(m=1\) specialization audit is
`notes/2026-08-20-c925-framed-m1-specialization.md`.

The broader non-\(m=2\) categorical dividend and Theorems 23.1--23.3 are
audited in `notes/2026-08-20-c925-non-m2-categorical-dividends.md`.

The reconciled \(m=2\) roadmap and unbounded-stabilization/all-\(m\) criterion
are in `notes/2026-08-20-c925-m2-roadmap-and-unbounded-stabilizations.md`.
