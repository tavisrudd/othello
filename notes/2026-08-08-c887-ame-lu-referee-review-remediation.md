# C887: AME--LU adversarial referee-review validation and remediation

**Lane:** `ame-lu`

**Status:** active.

## Objective

Independently vet the supplied full-manuscript cold review from the perspective
of the closest specialist referees, then repair every finding that survives.
The review is a lead, not evidence: no mathematical, bibliographic, novelty, or
priority conclusion may be adopted without reconstruction against the current
authoritative paper and the cited primary source.

## Reconstruction in progress

The first proof pass narrows the headline finding.  The printed Appendix B
theorem assumes $m\geq3$, so the call from the $m\geq2$ cleaning theorem is a
real proof-scope gap.  The review's proposed loss of $\sqrt2$ is only what the
coarse displayed estimate gives, however.  At $m=2$, retaining the four exact
minimum-support-family contributions yields
\[
 \varepsilon(U)^2\geq H/2-3P,
 \qquad
 P=\eta_{a_1}\eta_{a_2}+\eta_{b_1}\eta_{b_2}\leq H^2/4.
\]
Hence $H\leq1/4$ gives the stronger bound $5H/16$, so the existing
$\pi\sqrt q$ conclusion and entry radius survive.  The defect is a local
proof omission, not a false headline theorem.

The current source and its pre-split parent already use
$U\otimes\overline U$ in both Bell-pair passages; the supplied Bell correction
does not apply to this revision.  Git history shows that the phrase
“quantitative counterpart” entered during C844's Paper-I sharpening, while
C804/C807 had already proved and audited the exact qubit relationship to the
Van den Nest--Dehaene--De Moor criterion before that positioning was compressed.
C796 is the source of the budget-free theorem with the explicit $m\geq3$
corollary; C833 then invoked it for $m\geq2$, and C835 accepted C833's
mathematical scope while auditing the cleaning precedent.  C887 must therefore
repair the inherited proof bridge and restore the already-established qubit
positioning rather than treat either point as newly discovered.

The target is a locally releasable corrected revision of
`papers/ame_lu/`, with its theorem, proof, bibliography, trust, and release
surfaces coherent.  Synchronize the standalone only after the monorepo
authority passes its gates.  A Zenodo update, push, or submission remains an
explicit author decision.

## Required audit

### 1. Headline quantitative scope

Reconstruct Theorems 1.2 and 5.3 and Appendix B.18 from the current source,
including every entry-radius and spread hypothesis.  Test the review's claim
that B.18 assumes $m\geq3$ while the headline result asserts $m\geq2$, and
independently derive the estimate

\[
  \varepsilon(U)^2
  \geq \left(\frac12(1-H)-\eta^{m-1}\right)H.
\]

For $m=2$, determine sharply what follows at the printed radius: the claimed
`pi sqrt(q)` residual constant, only `pi sqrt(2q)`, or a stronger conclusion
from an argument absent from the review.  Check the proposed $H\leq1/6$
repair and its effect on all advertised thresholds.  Choose the strongest
proved correction with the smallest honest scope change; propagate it through
the abstract, theorem statements, proof, appendices, tables/figures, trust
maps, formalization ledgers, README, and release metadata.  The canonical
four-qutrit case must be an explicit acceptance test.

### 2. Exact mathematical and notation checks

- Verify the Bell-pair boundary convention.  For the paper's chosen maximally
  entangled state and transpose convention, reconcile the prose symmetry with
  the infinitesimal generator and replace `U tensor U` by the exact
  conjugate/inverse-transpose expression wherever required.
- Audit Proposition 5.4's use of bare Weyl operators versus phase-corrected
  stabilizer lifts.  Either restore the lifts or state precisely why phases
  may be suppressed in the commutators.
- Separate a quantitative fixed-state symmetry theorem from a robust
  two-state intertwiner theorem.  Check every use of “quantitative
  counterpart” and expose Appendix B's weaker two-state scale wherever a
  reader could otherwise infer a robust form of Theorem 1.1.
- Verify that the encoder corollary's contribution is factorwise Cliffordness
  for every physical and logical factor in exact conversions, not a new
  qualitative transversal-Clifford obstruction already supplied by cleaning
  or hierarchy results.

### 3. Primary-literature and novelty audit

Follow `notes/literature-audit-conventions.md`, including cache use, exact
queries, read depth, provenance, and negative-search closure.  Read the
primary sources needed to decide, at minimum:

- whether the qubit specialization of Theorem 1.1 follows directly from the
  2005 Van den Nest--Dehaene--De Moor minimum-support criterion once the
  paper's (q=2) support proposition is instantiated;
- how Claudet--Perdrix and Burchardt--de Jong--Vandré change the modern
  description of qubit stabilizer LU equivalence;
- what Englbrecht--Kraus already classify about qubit stabilizer local
  symmetries and continuous components;
- what Tan already proves about AME--QMDS LU orbits, local symmetries,
  transversal gates, and the four-qutrit example;
- which exact transversal restrictions belong to Pastawski--Yoshida and
  Jochym-O'Connor--Kubica--Yoder;
- which support/weight-distribution facts belong to Huber--Grassl or earlier
  QMDS work; and
- how general, possibly continuous AME LU moduli delimit every “atlas” claim
  to stabilizer AME states.

Rewrite the related-work hierarchy and contribution boundary only after these
checks.  Preserve the strongest supported contribution: the arbitrary-prime-
power full-Weyl rigidity mechanism, stabilizer-AME atlas/holonomy/gauge
sequence, and leakage-aware cleaning to Weyl-Fourier local-Clifford rounding,
to the extent each survives the audit.

## Acceptance gates

1. Produce a finding table with `confirmed`, `narrowed`, or `rejected` for
   every supplied criticism, citing exact manuscript and primary-source
   locations and showing all nontrivial constant derivations.
2. Run an adversarial proof pass focused on $m=2$, independently of the
   proposed repairs; no review sentence is accepted by authority.
3. Reconcile every changed theorem and novelty claim across manuscript,
   theorem map, claim/proof/novelty ledger, verification map, formalization
   ledger, extracted facts, release manifest, and public metadata.  If a
   formal theorem overstates the corrected paper scope, either repair it under
   the nested Lean rules or state the exact trust boundary.
4. Read `papers/style-guide.md` before manuscript work and
   `notes/export-and-mirror-conventions.md` before standalone synchronization.
   Read `lean/AGENTS.md` before any Lean operation; never invoke Lean/Lake
   manually.
5. Pass the paper-local warning-free build and release checks, inspect every
   affected rendered page plus the full PDF for propagated inconsistencies,
   and verify that changed paths stay inside the lane allowlist and the C887
   report stem.
6. Forward-synchronize the standalone with its existing history only after
   authoritative validation.  Do not push, upload, create a Zenodo version,
   or submit anywhere without explicit authorization.
7. After the main gates pass, run the required `ej`+`tt` closeout, record the
   mystery ledger, update the queue/handoff/archive under the task-lifecycle
   rules, and commit the coherent result.

## Initial source claims to falsify

The supplied review's central claims are: the printed proof yields at best
`pi sqrt(2q)` for (m=2); two Bell-pair passages use the wrong conjugation;
the qubit exact theorem is already implied by the 2005 minimum-support result;
the qubit LU literature is materially out of date; AME--QMDS and qualitative
transversal-gate positioning are too broad; the quantitative headline can be
misread as a robust two-state theorem; the atlas should be advertised as
stabilizer-specific; and the cleaning/Fourier chain is likely the strongest
genuinely new contribution.  Each is a hypothesis for C887, not a conclusion.
