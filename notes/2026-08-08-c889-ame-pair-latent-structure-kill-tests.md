# C889: AME--LU / MDS--CSS latent-structure kill tests and theorem extraction

**Lane:** `ame-lu`

**Status:** queued; not started.

## Provenance and governing rule

This item records the user-supplied ChatGPT report to EJ, *Unified
research-development report: latent structure in the AME-LU / MDS-CSS pair*.
Its proposed theorems, impact scores, venue forecasts, and literature claims
are hypotheses, not findings.  C889 must independently reconstruct every
mathematical implication and novelty boundary from the current manuscripts,
the owning C-item reports, exact computation where justified, and primary
literature before recommending adoption or a successor project.

The first operation is a corpus reconciliation against at least C622, C623,
C631, C642, C649, C774--C777, C786, C795, C833, C837, C838, and C888.  Several
claims in the supplied report overlap results or negative boundaries already
recorded there.  C889 must classify each proposal as already proved, genuinely
stronger, equivalent under changed language, false, or still open before doing
new proof work.

## Objective

Produce an evidence-backed answer to EJ that identifies the highest-value
surviving theorem chain, proves or kills its inexpensive first steps, and
separates bounded upgrades to the two published papers from work that would
require a new research programme.  Do not change either manuscript merely
because a proposed theorem sounds plausible.

## Phase 0: cheap, non-diluting current-paper additions

Before pursuing a larger theorem, identify additions that are already proved
or require only a short local lemma and that sharpen an existing paper's stated
mechanism without adding a new narrative branch.  Candidate examples include a
clean high-distance form of the multiplier-line lemma, a concise logical-gate
rounding corollary if the stabilizer cancellation is immediate, or a short
conceptual promotion of an already-adopted 2-uniform/2-unitary consequence.

Each candidate must pass four filters:

1. correctness follows from the current proof spine with no unadvertised new
   hypothesis or computational premise;
2. novelty/attribution has been checked to the depth required for its wording;
3. it strengthens the paper's existing headline or explanatory arc rather than
   opening a competing programme; and
4. the complete insertion, including proof and trust-map consequences, is
   genuinely small.

C889 reports these candidates first, with exact insertion sites, proof cost,
and a `adopt now` / `bank` / `drop` recommendation.  Current-paper edits are
made only for candidates explicitly judged `adopt now` after those filters and
after checking the papers still read as the same two papers.  Larger results
that check out are **banked as proved mathematics for follow-up versions**:
record the theorem, proof, evidence, literature boundary, and ownership in the
C889 report, but do not edit either current manuscript for them.

## Phase 1: immediate extraction gates

1. **MDS--CSS LU equivalence up to duality.**  Prove or refute, for odd-prime
   linear `[2m,m,m+1]` MDS codes, that LU equivalence of the associated
   equal-phase CSS AME states is exactly diagonal code equivalence or diagonal
   equivalence to the dual, with coordinate permutations added only when party
   relabelling is allowed.  Audit the four transporter lines and determinant
   constraints, including simultaneous nonzero orientation spaces.  Compare
   the result explicitly with the target already isolated in C642.
2. **Party-permutation image.**  Conditional on the preceding theorem, compare
   the classical code/dual criterion with every exhaustive Appendix-C row from
   C624.  Distinguish determination of the permutation image from splitting of
   the resulting nonabelian extension.
3. **Logical, rather than physical, robust rounding.**  Audit the exact Choi
   inverse-transpose convention, surjectivity of the *state stabilizer* onto the
   input Weyl plane, and cancellation of the input Pauli by a stabilizer.  Decide
   whether C838's dimension-only symplectic-atlas radius yields an `8 epsilon`
   distance from the intended logical unitary to an exactly transversally
   realizable logical Clifford even though the full affine physical correction
   remains uncontrolled.  Reconcile this carefully with C774, C786, C795, and
   the open two-state item C787.
4. **High-distance multiplier lemma.**  Prove or refute the claimed extension
   `d(E)+d(F)>n => dim D(E,F)<=1` for equal-dimensional full-support codes,
   locate prior art before claiming novelty, and test sharpness at equality.
5. **Already-present consequences.**  Determine whether the 2-uniform
   infinitesimal rigidity and 2-unitary gauge statements need only exposition,
   have already received their full C774--C777 disposition, or support a
   genuinely new theorem after the existing literature concessions.

Phase 1 is a hard gate.  A counterexample or missing implication is recorded,
not repaired by silently narrowing the proposal.  Except for Phase-0 additions
that independently pass the non-dilution filters, no manuscript adoption is
authorized by this item: surviving larger results are banked for a separately
authorized follow-up version.

## Phase 2: prime-field holonomy classification

Only after Phase 1 is disposed:

1. Formalize the atlas as a Weyl-frame groupoid/local system and prove or
   refute that gauge equivalence of its representations is exactly the existing
   atlas equivalence, without reintroducing the full stabilizer as an ad hoc
   relation.
2. Prove the surjectivity and phase-correction steps needed for
   `T_psi = F_p^2 semidirect C_SL2(p)(H_psi)` for arbitrary prime-field
   stabilizer QMDS encoders.  Compare against Tan's known state/code symmetry
   dictionary and every available small exact example.
3. Prove the proposed five-type `SL_2(p)` common-centralizer lemma, treating
   `p=2,3` separately, and run an exact falsifier over matrix tuples for
   `p=3,5,7`.  The computation is corroboration, not a substitute for the
   `2 x 2` algebra proof.
4. State precisely why the MDS--CSS theorem occupies only the full `SL_2` and
   split-torus phases, if that conclusion survives.

Any paper-facing finite computation must follow the research reproducibility
conventions: committed generator, compact certificate, independent replay,
manifest, and explicit trust boundary.

## Phase 3: gated research directions

These directions receive a go/no-go recommendation, not automatic execution:

- **Genericity and jump loci:** search non-CSS stabilizer AME/QMDS examples for
  the center-only phase before claiming it generic; separate geometric
  centralizer-dimension jumps from arithmetic split/nonsplit torus type.
- **Extension fields:** reconcile the proposed
  `Sp(Omega_0) intersect C(Alg(H,J_i))` formula with C623's exact
  `q=9,25,27` enlarged-kernel census and C633/C640's conditional bridges.
  Test `q=4,8,9` before proposing an algebra-with-involution classification;
  radicals and nonsemilinear sectors may not be discarded.
- **Affine stability:** formalize the actual chart nerve/groupoid, test for a
  wrong-character `n^(-1/2)` barrier, and identify a constant-signal observable
  for local character restrictions.  Failure of any one test stops the proposed
  cocycle/agreement programme.
- **Holonomy invariants:** test bounded trace/determinant word data against
  simultaneous-conjugacy classes over small prime fields, with separate
  treatment of nonclosed and nonsemisimple positive-characteristic orbits.

## Literature boundary

Before novelty wording, inspect the primary results of Rains; Dasu--Burton;
Ian Tan's AME/QMDS and special-symmetry papers; Tansuwannont--Takada--Fujii;
Sayginel and collaborators; Prakash--Singhal; Albert; Huber--Grassl; the modern
stabilizer LU literature already catalogued in C887/C888; and the exact
invariant/stability sources actually needed for any promoted Phase-3 claim.
Reuse C887/C888 cached sources where their hashes and read depths cover the
claim, but do not treat a bibliography entry or search snippet as inspection.

## Deliverables and acceptance

1. A proposal-by-proposal disposition table keyed to the supplied report and
   to existing C-item ownership.
2. Complete proofs or explicit counterexamples for every Phase-1 mathematical
   claim, plus the promised finite falsifiers where they add independent value.
3. A dependency graph separating theorem, literature, computation, Lean, and
   manuscript gates; no venue score is an acceptance criterion.
4. A recommendation for each survivor: Paper I revision, Paper II revision,
   separate future paper, or stop.
5. A banked-results ledger containing complete statements, dependencies,
   evidence identities, literature boundaries, and the intended follow-up
   owner for every validated result not adopted as a Phase-0 addition.
6. Cross-check any proposed formal statement against existing Lean declarations
   and comments.  New Lean work, if warranted, requires its own allocated item
   and the nested Lean instructions; C889 does not authorize manual Lean/Lake
   execution.
7. Close with an EJ answer that distinguishes proved facts, one-lemma-away
   claims, falsified routes, and genuine programmes without inheriting the
   source report's confidence or impact ratings.

No push, deposit, tag, submission, or manuscript release is authorized.
