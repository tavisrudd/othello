# C969 -- structural PRS deep-hole classifier

**Lane:** `reed-solomon`

**Status:** active; the Version 2 R5--R10 theorem/correction surface,
machine-readable domain registry, normalized request/action/certificate schema,
hand-classified branch representatives, and absorbed C607/C608 interface gates
are frozen in `c969-freeze-and-schema.md`.  The independent Rust core now has
exact extension-field arithmetic, projective normalization, both locator
charts, increasing-degree Hankel search, magnitude recovery, and certificate
replay, including the frozen R10 q=16 Lucas witness.  It also detects the
persistent tangent/sigma gcd branches and returns an exact semilinear
transporter through an explicit `m(q^3-q)` canonicalization fallback.  A
deterministically regenerated 338-row semilinear exception registry now
compresses the frozen R5--R7 certificates; classifier tests cover an R5 wild
deep orbit and the R7 small-field radius-gap verdict.  The R5--R7 terminal gate
is now proved and implemented by a streaming 12-point bilinear selector with
exact
`O(q)`, `O(q^2)`, and `O(q^3)` prefix counts, both infinity charts, and a
bounded small-field fallback.  Further R8--R10 nonpersistent formula adapters
and formula-speed canonicalizers remain open, but the R5 tame osculating and
characteristic-three nucleus/wild adapters and R6 recurring odd-binary nucleus
plus R7 central odd-binary nucleus now replay intrinsically above the finite
registry.  This closes the recurring nonpersistent R5--R7 formula inventory;
the remaining complexity work is
C607's general fixed-parameter theorem and the nonterminal classifier
branches.  Positive `DEEP` results now include an independently replayed
certificate binding the theorem-domain row, canonical transporter, intrinsic
formula or frozen family evidence, split-free route, and radius promotion.  Exact
decoding remains complete within an explicit candidate budget.  Code and
mathematics only; no manuscript edits.

The first reproducible release benchmark now separates the 12-point terminal
selector from the projective-locator oracle and reports canonicalization,
end-to-end classification, and positive replay independently; see
`c969-benchmark-v1.md`.  The same harness now includes a GF(8) selector,
canonicalization, classification, and replay matrix; external-software
comparison remains open.

Persistent tangent canonicalization now uses the repeated quadratic-gcd root
to restrict exact lexicographic minimization to `m q(q-1)` affine transports;
`c969-tangent-canonicalizer.md` proves equivalence to the full orbit minimum.
Rootless-form sigma inputs now canonicalize exactly in `m(q^2-1)` transports,
and the simple-root stratum in `O(m r q)`. Trace-pairing nondegeneracy proves
these strata exhaust persistent sigma; nonpersistent inputs retain the explicit
group fallback. A
frozen R5 counterexample proves that centering an irreducible sigma gcd and
enumerating its torus normalizer does not preserve the full-orbit minimum. The
sigma canonicalization is therefore phrased in intrinsic lex-coordinate
strata rather than a guessed target quadratic. The fixed-pair class is
extracted intrinsically in
`F_q[X]/Q`: its inversion orbit is encoded by a trace, fused under base-field
Frobenius, attached to positive sigma certificates, and independently replayed.

## Goal

Replace brute-force search over closer projective Reed--Solomon codewords by an
exact structural classifier for redundancies `5` through `10`. Given a finite
field, redundancy, and nonzero projective syndrome, return:

1. whether the syndrome is a code deep hole on the proved coding domain;
2. its geometric family and full projective-semilinear orbit;
3. a canonical representative and an explicit transporter to it; and
4. a replayable obstruction to a closer codeword.

For arbitrary syndromes, not just deep holes, the same engine must compute the
exact syndrome distance and an explicit nearest codeword/error pattern. C969
fully absorbs C607's general fixed-parameter split-locator decision/recovery
programme and C608's explicit R5--R7 maximum-likelihood decoders; those are
requirements of this task, not optional predecessors or parallel projects.

The absorbed specifications remain authoritative detail:

- [C607 fixed-parameter exact PRS decoding](c607-exact-prs-decoding-fpt.md),
  including its governing
  [split-locator proposal](../2026-07-26-prs-fpt-split-locator-ej-report.md); and
- [C608 explicit R5--R7 decoders](c608-explicit-prs-decoders-r5-r7.md).

C969 may strengthen or reconcile them, but it may not silently drop an exit
gate merely because the originating C-ID has been retired.

The structural vocabulary is the one proved in the lane: divided-power Hankel
kernels, split-free pencils and nets, iterated polar contractions, persistent
tangent/sigma strata, modular/Lucas carriers, residual covers, torus classes,
and Frobenius data. The classifier must select only the invariants needed by the
given level and must never scan all projective syndromes as its query algorithm.

## Truth boundary

Before implementing, freeze a theorem-domain table for every `(r,q,char)` at
redundancies `r=5,...,10`. For each row distinguish:

- classification of a syndrome direction as split-free;
- the covering-radius or code theorem that promotes it to a deep hole;
- persistent, modular, sporadic, and residual families known to be exhaustive;
- finite certificate ranges and theorem-derived large-field ranges; and
- any genuine unresolved residue or unsupported parameter range.

The public result type must therefore include at least `DEEP`, `NOT_DEEP`,
`UNRESOLVED`, and `UNSUPPORTED`. In particular, do not promote the `q=7,8,9`
redundancy-seven split-free tables to code deep holes without a covering-radius
premise, and do not turn a containment theorem at redundancy ten into an exact
classification unless the frozen C821/C532/C578 surface closes the complementary
residue. Unknown is an exact answer about the current theorem boundary; guessing
yes or no is not.

## Inputs and normalization

1. Accept an explicitly represented finite field `F_q`, redundancy
   `5 <= r <= 10`, the declared PRS evaluation convention, and a nonzero
   syndrome in projective divided-power coordinates.
2. Canonicalize projective scaling, infinity, field representation, and the
   `PGammaL(2,q)` action. Return the exact semilinear transporter, including its
   Frobenius exponent, rather than only an orbit identifier.
3. Reject malformed dimensions, zero syndromes, incompatible field/evaluation
   conventions, and parameters outside the versioned theorem-domain table.
4. Give every classifier rule a stable source locator into the frozen C491,
   C498, C509, C512, C513, C516, C620, C660, C820, C821, C532, and C578
   theorem or certificate surface as applicable. Superseded claims and the
   withdrawn MDS-extension/quantum consequence are not inputs.

## Deliverables

1. Define a versioned machine-readable theorem-domain and family registry for
   R5--R10, with characteristic, field-size, covering-radius, exhaustiveness,
   and evidence-route predicates that fail closed.
2. Implement the level-independent front end: projective normalization, Hankel
   kernel/rank extraction, gcd and squarefree factor data, semilinear action,
   and exact finite-field polynomial factorization.
3. Prove and implement the complete split-Hankel locator/Vieta dictionary in
   both projective charts, including lower-weight padding, repeated roots,
   squarefreeness, small characteristic, locator factorization, and recovery of
   nonzero error magnitudes. Preserve the exact equivalence among PRS support
   weight, atomic moment rank, rational NRC/divided-power rank, and a split
   locator in the syndrome Hankel system.
4. Retain C607's general complexity targets: prove deterministic exact syndrome
   distance in `F(r) poly(log q)` with an exponent independent of `r`, and
   unconditional nearest-word recovery in `F(r) q poly(log q)`, or replace
   either proposed bound by the strongest rigorously justified boundary. Prove
   the redundancy-four square-root reduction and settle the proposed general
   reduction from completely split squarefree factorization; separate
   deterministic, randomized, conditional, locator, factored-support, and
   explicit-codeword outputs.
5. Retain C608's concrete R5--R7 decoder gates: locator degrees in increasing
   order, one-dimensional kernels in the unique range, exact intermediate
   pencil/plane/three-space dimensions, the two infinity charts and collision
   locus of the terminal-hyperplane solver, the bounded small-field branch, and
   the proof that terminal failure yields a full-support basis solution. Prove
   or correct the proposed `O(q)`, `O(q^2)`, and `O(q^3)` field-operation bounds.
6. Implement level adapters that follow the proved structural ladder: pencil
   or net classification at R5/R6, pointed and coherent polar contraction at
   higher levels, persistent torus classes, modular/Lucas tests, residual-cover
   invariants, and bounded exceptional registries only where the theorem surface
   authorizes them.
7. For every classified input, return a stable family identifier, complete
   discrete invariants, orbit/stabilizer data, a canonical representative, and
   a verified projective-semilinear transporter. Frobenius-fused classes must
   canonicalize together and distinct proved classes must never collide.
8. Emit a proof-carrying verdict. A positive certificate must show both
   structural split-freeness and its coding promotion. A negative certificate
   must include an explicit closer-codeword witness or split squarefree member.
   A classification-based nonexistence certificate must name and replay the
   exhaustive theorem branch that excludes all closer words.
9. Write an independent verifier that reconstructs the syndrome action,
   validates family invariants and witnesses, and rejects corrupted domain,
   orbit, transporter, covering-radius, and obstruction fields.
10. Cross-check against the frozen exhaustive R5--R10 records and independently
   generated small-field brute-force samples. Compare query cost against a
   named brute-force syndrome/codeword baseline at each redundancy.
11. Prove honest complexity bounds in field operations and bit operations for
   each structural branch. Separate finite-registry lookup, polynomial
   factorization, semilinear canonicalization, and certificate verification;
   do not advertise a uniform polylogarithmic bound if a branch enumerates
   `PGL(2,q)`, factors over `F_q`, or invokes a field-size-dependent search.
12. Provide a stable library and CLI/API surface with commands equivalent to
   `distance`, `decode`, `classify`, `canonicalize`, and
   `verify-certificate`. Select the implementation stack only after the
   field/action and certificate schemas are frozen.
13. Run C607/C608's full claim-specific audit across parameterized and explicit
    RS decoding, Prony/sparse interpolation, LFSR/error-locator synthesis,
    binary Waring/rational secant rank, deterministic finite-field
    factorization, and existing decoder software before any novelty or
    state-of-the-art claim. Keep all changes out of Versions 1 and 2; a later
    task must authorize any paper or standalone release integration.

## Acceptance gate

- Every frozen R5--R10 theorem/certificate fixture receives the expected
  verdict, family, semilinear orbit, canonical representative, and transporter.
- Exact distance and decoded nearest words agree with an independent
  maximum-likelihood oracle on exhaustive feasible fields; decoded errors
  reproduce the input syndrome and have certified minimum support.
- On exhaustive feasible fields, `DEEP` and `NOT_DEEP` agree with an independent
  distance computation; `UNRESOLVED` and `UNSUPPORTED` agree exactly with the
  versioned theorem-domain table.
- Applying the returned transporter yields the canonical representative, and
  independently equivalent inputs yield byte-identical canonical artifacts.
- Positive, negative, and classification-based obstruction certificates replay
  without trusting the classifier; deliberate corruption is rejected.
- No query path enumerates the full projective syndrome space. Any remaining
  `q`-scale or group-scale loop is explicit in both the implementation and its
  complexity statement.
- Benchmarks are reproducible, identify field implementation and hardware, and
  compare like-for-like end-to-end decisions rather than only isolated kernels.
- The tool never conflates syndrome split-freeness, covering radius, one-column
  MDS extension, or code deepness, and makes no manuscript or novelty claim.

## First action

Freeze the R5--R10 theorem-domain matrix and a common normalized syndrome/action
schema, then reconcile every C607 and C608 proof gate into the unified
decision/decode/classify interface. Hand-classify one representative from every
persistent, modular, sporadic, and unresolved branch before choosing the
implementation language or optimizing the orbit canonicalizer.
