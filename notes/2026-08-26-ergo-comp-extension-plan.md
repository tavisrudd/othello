# ERGO-comp theorem-native extension plan

## Objective

Make the public executable coincide with the paper's mathematical ontology.
The primary deliverable is an exact, replayable path from a represented inner
and outer code to the finite transfer quantities in the paper. Performance
measurements remain supporting evidence, not the product definition.

The work is ordered by dependency and scientific value:

1. extension-field arithmetic and a canonical public representation;
2. a paper-native `transfer` command with complete numerical and witness output;
3. exact bounded support families and reliability on the second branch of the
   information hierarchy.

## Stage 1: extension fields and the executable GF(4) separation

Status: the canonical GF(4) field substrate, public composition dispatch, and
the rank-one theorem-native separation are implemented locally. The
`transfer` command now derives the labelled tables from the two represented
binary encoders, evaluates both functional sectors against the fixed outer
dual, and expands the winning block labels to coefficient witnesses. General
target subspaces now have a separately budgeted exact compiler and
`transfer-subspace` front end with matrix-valued labels and witnesses.
Target-aware ordinary and normalized tables now compose through successive
levels, sequentially or in parallel, with retained per-level minimizing
labels. The `transfer-tower` front end expands them to a budgeted recursive
tree whose leaves contain coefficient witnesses for the original inner
encoder. Support for arbitrary extension fields remains Stage 2 work.

### Field boundary

Introduce a monomorphized small-field trait behind the existing byte-valued
matrix representation. Prime fields remain const-generic. The first extension
field is

\[
  \mathbf F_4=\mathbf F_2[a]/(a^2+a+1),
\]

with elements serialized as integers `0,1,2,3`, whose bits are the polynomial
basis coefficients `(1,a)`. Public JSON must declare the field rather than
making the encoding implicit. The initial accepted extension descriptor is:

```json
{"kind":"binary-extension","degree":2,"modulus":[1,1,1]}
```

This representation is stable and replayable. Unsupported extension fields
fail closed. Arithmetic dispatch occurs once at the CLI boundary; matrix and
composition loops remain monomorphized and contain no runtime field branch.

### First vertical slice

- generalize matrix validation and row reduction to the field trait while
  preserving the existing prime-field API;
- generalize labelled cost-table composition and witness replay;
- extend `compose` JSON to accept the field descriptor, retaining the old
  `prime` key for compatibility;
- add exhaustive GF(4) field-law tests, matrix-elimination tests, serial versus
  parallel composition parity, and an end-to-end CLI test;
- add a theorem-native fixture for the paper's scalar-separation example once
  the `transfer` front end can derive its labelled tables rather than receiving
  them precompiled.

## Stage 2: paper-native `transfer`

### Input

One command accepts:

- the base and extension fields and their declared embedding;
- an inner represented code, target coordinates `P`, helper coordinates `J`,
  and recovered subspace `T`;
- an outer represented code with target block, or an ordered outer tower;
- explicit search budgets where exact enumeration can grow exponentially.

The first public schema will use generator matrices plus coordinate sets. A
later parity-check form can compile to the same internal problem without
duplicating the solver.

### Output

The deterministic result records:

- bases for `K_P`, `D_P`, and `W_P`, with dimensions;
- all requested relative-weight values `M_t`;
- labelled prescribed-coset tables `mu(B)` and `lambda(B)`;
- zero-functional and best nonzero-functional costs;
- `Gamma_{j,T}`, a minimizing outer functional, confinement radius, and the
  rank-one simultaneous-confinement test;
- minimizing lifts at every concatenation level and the expanded
  coefficient-level recovery equation with exact helper support;
- counters and declared completeness budgets separately from elapsed time.

The witness verifier will replay the emitted coefficient equation against the
original matrices and recompute its support and cost. Numerical tables do not
claim to contain witnesses; argmin links are a distinct retained layer.

### Scientific demonstration

`ergo-comp transfer --input f4-scalar-separation.json` should exhibit two
inner realizations with the same scalar recovery cost and the same inner-dual
distance, print their different labelled tables, identify the outer functional
that observes the difference, return different nonzero-sector minima, and
replay both coefficient witnesses.

## Stage 3: bounded support families and reliability

Add `recovery-supports` and `reliability` commands over the same compiled inner
problem.

- enumerate exact or inclusion-minimal helper-support families under a
  declared radius;
- preserve coefficient witnesses separately from the support antichain;
- compute exact rank-`t` reliability polynomials for bounded instances and
  evaluate them under supplied independent helper-survival probabilities;
- return overlap statistics and completeness certificates;
- include a fixture with equal complete relative-weight hierarchies but
  different bounded reliability.

Start with a compact antichain representation and explicit exponential output
budgets. Introduce a decision diagram only after profiling shows that it reduces
the live support frontier on representative paper instances.

## Architecture constraints

- No runtime field tests in arithmetic loops: dispatch once, monomorphize the
  selected field implementation.
- Keep matrices and labels contiguous; hot records contain fixed-size IDs and
  scalars, never owned dynamic containers.
- Preserve deterministic tie-breaking across sequential and parallel paths.
- Separate numerical compositional state from stored argmin/witness state in
  APIs, schemas, documentation, and tests.
- Every reduction has a replay path to the original represented code.
- Generic CP-SAT remains an optional residual backend for extra constraints;
  no additional benchmark row is a milestone for these stages.

## Acceptance gates

Each stage requires formatting, Clippy with all targets/features and warnings
denied, the complete Rust test suite, deterministic CLI snapshots, and an
independent oracle or exhaustive small-instance check. The GF(4) stage also
exhausts all field laws and checks every small matrix rank against a direct
enumerator. Performance work begins only after exact parity, using interleaved
release measurements with transition counts and canonical witnesses held fixed.
