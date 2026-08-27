# C974 — simultaneous-marker locator software

**Lane:** `reed-solomon` · **Status:** complete — implementation, full fast
validation, and bounded pointed R11 evidence green; theorem extraction returned
to C973

## Objective

Implement the constructive C973 simultaneous-marker method in the Projective
Reed--Solomon Toolkit, preserve exact certificate replay and theorem-domain
fail-closure, and expose a deterministic research-probe interface that can be
used to sharpen the pointed R11 and higher-Lucas results when control returns
to C973.

## Authorized paths

- `papers/beyond4_prs/software/projective-reed-solomon/`
- `notes/reed-solomon-tasks/c974-*`
- C974 state transitions in the live queue and Reed--Solomon handoff

C974 does not edit the manuscript, theorem annotations, release metadata,
public mirrors, Lean, C969/C970 reports, or C973 mathematics records.  C973
receives computational conclusions only after C974's reproducibility and
certificate gates pass.

## Implementation target

1. Generalize the terminal cubic completion engine from its current R5--R7
   exact-decoding role to degree-`r-5` squarefree marker prefixes at every
   `r>=6`, producing a degree-`r-2` locator.
2. Reuse `locator_from_support`, magnitude recovery, and
   `verify_certificate`; no negative verdict may depend on trusting the search
   routine.
3. Integrate the route into `classify`, `distance`, and `decode` only where its
   conclusion is exact.  A found locator proves `NOT_DEEP`; failure or budget
   exhaustion proves nothing and must fall back or fail closed.
4. Preserve the current positive `DEEP` theorem registry until C973's theorem
   and radius inputs pass their independent gates.  Higher-redundancy positive
   classification needs a separately versioned registry/verifier change.
5. Add focused unit/property/CLI tests, including characteristic two,
   infinity, collision avoidance, budget exhaustion, R11+, and corrupted
   certificate replay.
6. Benchmark prefix enumeration against the existing generic locator search.
   Record exact field-operation/search counts and make no uniform
   polynomial-in-`r` claim.

## Research-probe target

Add a deterministic, machine-readable probe that can:

- require a prescribed marker/root set;
- count or find split squarefree locators through one terminal R5 pencil;
- distinguish a found witness from exhausted bounded search;
- emit canonical output with all field, redundancy, syndrome, and search
  parameters; and
- replay every emitted witness through the independent locator verifier.

The first C973 use is one-extra-root abundance on the R11 binary,
characteristic-three, and characteristic-seven coherent constructions.  A
finite run may calibrate or falsify a proposed theorem but cannot by itself
prove an unrestricted statement.

## Acceptance gates

1. Formatting, warning-denying Clippy, fast tests, focused new tests, and
   package build pass under the subtree's pinned toolchain.
2. Existing public schemas and R5--R10 verdicts remain byte/semantically
   compatible unless a schema revision is explicitly justified and versioned.
3. Every new negative result carries a locator certificate accepted by the
   existing independent verifier.
4. Candidate-budget exhaustion and theorem-domain gaps remain nonpositive.
5. The dated C974 report records replay commands, inputs, hashes, counts,
   independent cross-checks, and the exact boundary of any C973-facing probe.
6. All coherent code, tests, docs, and evidence are committed before returning
   to C973.
