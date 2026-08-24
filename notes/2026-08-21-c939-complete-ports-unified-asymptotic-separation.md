# C939 — Unified asymptotic separation revision for complete ports

**Lane**: `complete-ports`

**Status**: COMPLETE — FINAL REFEREE GO; LOCAL PUBLIC EXPORT VERIFIED
**Allocated**: 2026-08-21

## Intent

Organize the complete-ports paper around one theorem chain:

> a represented seed port is produced geometrically or explicitly; weighted
> transfer embeds it on a positive-density coordinate class; its bounded
> reliability, EXIT, and pointed-Tutte consequences survive in an
> asymptotically good family.

This is a theorem-strengthening item, not a general polishing pass. Do not
restructure the paper until the primary new theorem passes its mathematical
and formal gates.

## Primary crown

Lift the represented pair in Proposition 6.3 through the positive-density
transfer theorem. Target a theorem producing two asymptotically good
fixed-alphabet code families with designated positive-density coordinate
classes such that:

1. the two local seeds have the same full pointed subset profile and hence the
   same full pointed-Tutte specialization;
2. their conventional local data are matched as far as the current seeds
   permit;
3. their radius-three reliability functions remain distinct,
   `2s^3-s^6` versus `2s^3-s^5`;
4. the same outer family is used when possible, so global rate and distance
   bounds are matched rather than merely comparable; and
5. every transfer hypothesis, especially the exact `z_x(I)` gate, is proved
   rather than inferred from the finite profile.

If the exact target theorem fails, determine the sharp obstruction and retain
only the strongest honest matched-family separation. Do not weaken silently.

## Phase gates

### A. Seed and transfer audit

- Reconstruct the two represented seeds and their pointed full/bounded data
  from the existing proof and replay bundle.
- Compute or prove the exact pointed zero-functional costs needed at radius
  three.
- Check whether one common outer family gives identical global parameter
  formulas.
- State the sharp theorem before manuscript restructuring.

### B. Human proof and Lean boundary

- Give a complete human proof exposing why the full pointed invariant agrees
  while the bounded reliability differs after transfer.
- Add statement-adequate Lean declarations for the transfer/separation claim,
  with the outer-family existence input explicit rather than axiomatized
  invisibly.
- Extend the complete-ports gate, terminal ledger, axiom audit, and immutable
  formal-boundary manifest only after the declarations build through the
  guarded Lean workflow.

### C. Unifying paper revision

After A and B pass:

- add one synthesis corollary stating that exact complete-port transfer carries
  all smaller support filtrations, normalized decoders, matching/transversal
  data, blocker leading terms, multivariate reliability, and bounded-EXIT
  differences; include the pointed-Tutte specialization at full radius;
- rebuild the narrative around
  `seed -> transfer -> positive-density family -> stochastic consequence`;
- make the new asymptotic separation the payoff joining the transfer,
  reliability, EXIT, and pointed-Tutte sections;
- compress or move classical calculus that is not used downstream; and
- retain the existing trust boundary while moving certificate-like bulk out
  of the main argument when possible.

### D. Geometric consequence gate

If it follows without a second research program, state the transferred
reliability contrast for the cubic and quartic flagships on positive-density
coordinate classes. Verify the exact blocker/failure exponents before using
the proposed `p^(q-1)` versus `p` language. Matching global parameters is a
bonus, not permission to broaden C939 indefinitely.

## Explicit non-goals

- More finite tables or formalization without a new unifying consequence.
- A general service-region, sequential-composition, coefficient-optimization,
  or log-concavity program.
- Reopening excluded C220 blocker strengthening unless the primary theorem
  genuinely requires it.
- Priority or novelty claims without the required literature audit.
- Public push, tag, DOI creation, or repository-history mutation.

## Acceptance gates

1. The asymptotic separation has an exact stable statement and complete human
   proof.
2. The two families' matched and unmatched invariants are listed field by
   field, with no ambiguity between designated-class density and total
   occurrence density.
3. The Lean statement matches the paper theorem and passes the guarded build
   and axiom audit.
4. The synthesis corollary is proved rather than presented as rhetoric.
5. The revised paper is warning-free, its control ledgers agree, and an
   independent cold referee finds no correctness blocker.
6. Only the reviewed commit is synchronized to the standalone export.
7. All commits stage and commit explicit paths; unrelated dirty work is left
   untouched.

## Deliverables

- Main report:
  `notes/2026-08-21-c939-complete-ports-unified-asymptotic-separation.md`
  updated with results, proof status, validation, and the required mystery
  ledger at closeout.
- Authoritative paper and control surfaces under
  `papers/complete-repair-ports/`.
- Task-owned Lean declarations and complete-ports trust-boundary updates only
  if Phase B is reached.
- Any computational evidence as a committed script/certificate/report bundle
  under the research-reproducibility conventions.

## First move on `go C939`

Read the complete-ports expert dossier and the applicable Lean/reproducibility
instructions, then audit the Proposition 6.3 seed pair for exact `z_x(I)`,
common-outer compatibility, and the strongest matched asymptotic statement.
Do not begin by moving sections.

## Phase A result — seed and transfer audit

Phase A passes.  Let \(I_{\mathrm{dis}}\) and \(I_{\mathrm{ov}}\) be the two
row-span codes over \(\mathbb F_7\) displayed in Proposition 6.3, with
distinguished coordinate \(x=0\).  The proof is structural once the two
finite representations are checked.  Direct elimination gives rank \(4\),
no dependent triples, and the circuit-hyperplane lists
\[
 \{0145,0236,2345\},\qquad \{0123,0256,3456\}.
\]
The committed C676 replay bundle independently verifies this finite input
and the following derived data:

- both matrices have rank \(4\), every three columns are independent, and
  each represented matroid has exactly three circuit-hyperplanes;
- the two complete pointed subset profiles agree;
- the radius-three minimal repair clutters are
  \(\{145,236\}\) and \(\{123,256\}\), respectively; and
- the homogeneous success counts give
  \(2s^3-s^6\) and \(2s^3-s^5\).

Replay:

```text
python3 notes/2026-07-26-c676-pointed-tutte-filtration.py \
  --check notes/2026-07-26-c676-pointed-tutte-filtration.json
```

The replay reports certificate SHA-256
`8096230e66f634c820ae7ec4bacd9b2493006782ff02b8be3a8c7e1caf80de07`.

The certificate is not the mathematical explanation.  Structurally, a
rank-four sparse paving matroid has uniform rank on every subset except its
four-element circuit-hyperplanes.  Its pointed subset profile is therefore
determined by the ground-set size and the numbers of circuit-hyperplanes
through and away from the target.  Both seeds have the same data
\((n,r,h_x,h_{\bar x})=(7,4,2,1)\), so their full pointed profiles agree.
Deleting the target from the two incident circuit-hyperplanes instead gives
two three-helper repairs.  Their intersection size is zero in the first seed
and one in the second, so inclusion--exclusion gives, without enumeration,
\(2s^3-s^6\) and \(2s^3-s^5\).  Thus computation checks the displayed
representations; sparse-paving structure proves every conceptual claim.

### Exact parameter and pointed-cost proof

Both seeds are \([7,4,3]_7\) codes.  Rank \(4\) gives dimension \(4\).
A circuit-hyperplane is a rank-three four-set, so a nonzero primal linear
functional vanishes on four columns and the primal distance is at most
three.  If five columns lay in a hyperplane, all five of their four-subsets
would be dependent; the exhaustive circuit-hyperplane list rules this out.
Thus the distance is exactly three.

Every three columns are independent and a dependent four-set exists, hence
the dual distance is exactly four.  In each seed a circuit-hyperplane through
\(x\) supplies a weight-four dual word through \(x\); after normalization this
shows \(\mu_x(0)\leq4\).  The dual-distance bound gives the reverse inequality,
so
\[
 d(I_{\mathrm{dis}}^\perp)=d(I_{\mathrm{ov}}^\perp)=4,
 \qquad
 \mu_x(0)=4,
 \qquad
 z_x(I)=\mu_x(0)+d(I^\perp)=8.
\]
At radius \(r=3\), the exact transfer gate is \(r+1<z_x(I)\), namely
\(4<8\), and therefore passes for both seeds.

### Sharp matched-family theorem

Use either seed as an inner code and use the same asymptotically good
\(\mathbb F_{7^4}\)-linear outer family \(O_N\leq\mathbb F_{7^4}^N\), chosen
with both primal and dual relative distances bounded away from zero.  The two
concatenated families have, for every \(N\), the same length \(7N\), the same
dimension \(4K_N\), and the same lower bound \(3D_N\) on minimum distance.
They are therefore asymptotically good over the same fixed alphabet
\(\mathbb F_7\), with matched rate and distance bounds.

Since \(d(O_N^\perp)\to\infty\), for all sufficiently large \(N\) the exact
prescribed-port theorem applies simultaneously to both seeds.  At every one
of the \(N\) coordinates \((j,x)\), a designated class of density exactly
\(1/7\), the radius-three repair clutter is a literal block embedding of the
corresponding seed clutter.  Consequently the two families have:

- radius-three ports copied from seeds with identical full pointed subset
  profiles and pointed-Tutte specializations (no equality of the large codes'
  full pointed invariants is claimed);
- identical alphabet, block length, dimension, distance lower bound,
  designated-class density, locality \(3\), and number \(2\) of minimum
  repairs at every designated target; but
- distinct radius-three homogeneous reliability functions
  \(2s^3-s^6\) and \(2s^3-s^5\), hence distinct bounded-EXIT curves.

The current seeds do **not** match availability: the disjoint seed has
matching number \(2\), while the overlapping seed has matching number \(1\).
The theorem therefore does not claim that all conventional local data agree.
This is the strongest honest common-outer lift of Proposition 6.3 without a
new seed-search program.

## Phase B result — human proof and Lean boundary

Phase B passes. The paper proof reduces the finite comparison to the
sparse-paving pointed-profile lemma and proves both exact pointed costs
\(z_0=8\) directly. Lean theorem
`RepairPorts.eventually_radiusThree_prescribedPortPair` proves that one
outer family eventually transfers both radius-three support and coefficient
ports simultaneously whenever the two inner dual distances are at least four.
The complete-ports gate rebuilt successfully and the declaration reports only
`propext`, `Classical.choice`, and `Quot.sound`.

## Phase C draft

The manuscript now contains `thm:asymptotic-separation` and
`cor:transfer-synthesis`. The determinant ledger has moved from the body to
the verification appendix, while a public exact replay bundle lives at
`papers/complete-repair-ports/verification/f7-seed.py` and
`papers/complete-repair-ports/verification/f7-seed.json`. The current
22-page build passes `make check` without TeX warnings. Formal ledgers are
being reconciled before the immutable boundary refresh and cold referee gate.

## Matched-availability upgrade

The first Phase C draft exposed availability as the remaining conventional
local mismatch.  A second structural construction closes that gap.  Over all
but finitely many prime fields, two represented rank-four sparse-paving
matroids on ten elements have five target circuit-hyperplanes and none away
from the target.  Their repair clutters have the same locality, repair count,
matching number (2), transversal number (2), unique minimum-blocker count,
and helper-degree multiset
((1,1,1,1,2,2,2,2,3)), while their higher intersections differ.  Their
homogeneous reliability polynomials are

\[
  5s^3-7s^5-s^6+5s^7-s^9
  \quad\text{and}\quad
  5s^3-7s^5-2s^6+8s^7-3s^8.
\]

Both seeds give \([10,4,6]_q\) codes with dual distance four and
(z_x(I)=8).  Applying the same outer family therefore gives matched length,
dimension, and distance lower bounds and transfers the distinct laws to
coordinate classes of density (1/10).  The original field-seven pair is
retained as the smallest explicit precursor, not as the main asymptotic
separation.

The human proof realizes the two clutters as five-line incidence patterns in
a quotient projective plane, lifts them generically to rank four, and excludes
all unintended four-circuits by avoiding a finite union of proper
hyperplanes.  Rational data can then be reduced modulo any prime outside one
finite exceptional set.  This is the structural proof; the concrete
\(\mathbb F_{29}\) matrices below are an independent cross-check, not a premise.

Exact replay from `papers/complete-repair-ports/`:

```text
python3 verification/matched-seed.py \
  --check verification/matched-seed.json
```

The replay checks all three- and four-column ranks, the exact
circuit-hyperplane lists, \([10,4,6]_{29}\) parameters, dual distance four,
pointed rank-triple histograms, matching/transversal/blocker/degree data,
union profiles, and both reliability polynomials.  It does not prove the
generic construction or the outer-family existence theorem.  Certificate
SHA-256 is
`16a378edc882a6dda7f5642c7d21bfa49913b45ef5409398de117897b19dd2b8`;
script SHA-256 is
`c77734a532f2b7152b97595fca66ffec4de9ea436711f0ffe94901aae67ac5b8`.

## Public formal release

The dirty `finitegeom` checkout was a coherent but partial Paper IV semantic
export, not complete-ports work.  Its guarded single-profile semantic gate and
axiom audit passed, and it was committed separately as
`e69fbe7ac9e2dd6fb193f6f3c914d3831cbe806e`.  The complete-ports closure was
then exported on that base and committed publicly as
`36c83268ddaeec9ee22824cad44d6222a9e67081`: 36 modules, 61 paper-facing
terminals, 888036 closure bytes, and observed axiom union exactly
`Classical.choice`, `Quot.sound`, and `propext`.  The public manuscript points
only to `https://github.com/tavisrudd/finitegeom` and the latter release
commit.  Paper IV remains partial: C834 owns theorem completeness, and C857
owns its subsequent formalization-audit/standards closure.

The formal boundary is deliberately narrower than the human theorem.  Lean
certifies the simultaneous exact transfer of the two prescribed radius-three
ports.  It does not formalize the quotient-plane seed construction, the
finite seed invariants, \([10,4,6]\) parameters, outer-family existence, or the
final human synthesis.

## Referee state

The matched-availability cold review found only one stale conclusion paragraph,
and the formal review found the formal-correspondence boundary honest. The
conclusion is now synchronized, and the explicit field-29 instance supplies
the requested exact cross-check. A final review must assess the new frozen PDF
rather than the earlier worktree-mutating build.

The final cold review is GO with no issue.  The formal referee first caught a
stale rendered source/base-pin paragraph; commit
`4cd32e1a78b009f76f44dbf130eb4ebbaa19675a` synchronizes the printed source,
base, and public release pins with `formal-boundary.json` and makes the release
verifier enforce all three equalities. The formal rereview is GO.

The final tracked PDF has 23 warning-free pages and SHA-256
`c2611c12114492b47b1af5a8ac77f5550fb11ec9eba81c54acbf6c3523f6ccc9`.
The full public-formal release verifier passes against finitegeom release
`36c83268ddaeec9ee22824cad44d6222a9e67081`.  Page 20 was inspected at full
resolution after the provenance repair and is clean.  The immutable export
audit reports no private-reference finding.  The standalone mirror was
forward-committed at `581357f` and verifies as 29 tracked files sourced from
`4cd32e1a78b009f76f44dbf130eb4ebbaa19675a`; nothing was pushed or deposited.

## `ej` + `tt` closeout and mystery ledger

The closeout identified two cheap, high-value upgrades and both are settled:

- availability, transversal number, minimum-blocker count, and helper degrees
  are now matched in the main pair, so the separation is genuinely driven by
  higher overlap structure;
- the generic existence proof now has a concrete field-29 replay, so readers
  can independently test every finite invariant without mistaking computation
  for the proof.

Open mysteries:

- The smallest field supporting the matched pair is not determined.  The paper
  needs only all but finitely many primes; a minimal-field classification would
  require a separate exhaustive or moduli analysis and is not an acceptance
  gate.
- A conceptual classification of which higher intersection data determine the
  full reliability polynomial remains open.  The present theorem isolates the
  failure of the matched coarse statistics but does not claim a minimal
  complete invariant; that is successor work, not a gap in this result.
- The paired transfer theorem is only partially formalized, exactly as stated
  in the appendix.  Formalizing the geometric seed construction and classical
  outer-family existence would be a substantial successor formalization, not
  required for the present paper's declared trust boundary.
