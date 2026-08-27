# C973 — simultaneous-marker PRS escape and all-level Lucas discriminator

**Lane:** `reed-solomon` · **Status:** active — arbitrary-`r` escape proved;
the first one-carry Lucas block now has an explicit module theorem and the
characteristic-seven R11/R12 carriers are pointedly closed; external review
and a multi-digit module/abundance theorem remain open

**Current checkpoint:**
`c973-2026-08-26-simultaneous-marker-theorem.md` proves direct composite
lifting, a degree-six Vandermonde selector, unconditional arbitrary-`r`
containment at
`6r-16+floor(2 sqrt(6r-18))`, its sharper binary refinement, and a fixed-`r`
witness-abundance lower bound.  The companion
`c973-2026-08-26-first-lucas-boundary.md` computes the exact R11 carriers in
characteristics `2,3,7`, closes the binary block for `q>=128` and the
nonpersistent characteristic-three block for `q>=81`, and closes the
characteristic-seven block for `q>=343` by a pointed R9 slice.  The same
report computes R12: its new characteristic-five block is transverse and
shallow outside the persistent locus for `q>=125`; the `2/3/7` blocks reduce
to one-extra-root versions of the R11 constructions.  The manuscript-frozen
`c973-2026-08-26-paper-successor-map.md` gives exact replacement statements,
the deletion/retention map, frontmatter and trust updates, and a target net
reduction of 2--5 pages for a separately allocated integration successor.
The author-side audit and explicit `ej`/`tt` mystery closeout are
`c973-2026-08-26-hostile-proof-audit.md` and
`c973-2026-08-26-sprint-closeout.md`.
The user-requested second Tao pass and its action gates are recorded in
`c973-2026-08-26-tao-second-pass.md`.  The two load-bearing arguments are
reconstructed in `c973-2026-08-26-two-seam-reconstruction.md`: the elementary
reductions pass, while five inherited geometric/counting inputs are explicitly
left for external reconstruction.  Finally,
`c973-2026-08-26-deterministic-selector.md` proves successive symbolic marker
selection using at most `(r-5)q` partial-specialization tests at fixed
redundancy.  `c973-2026-08-26-software-leverage.md` maps this into a certified
fast negative locator path and a separately gated parameterized R11+
classification route for the Projective Reed--Solomon Toolkit.  The
second-sprint verdict and revised mystery ledger are in
`c973-2026-08-26-second-sprint-closeout.md`.  C974 implemented and typed that
arbitrary-redundancy simultaneous locator.  Its C973 application is recorded
in `c973-2026-08-26-characteristic-seven-closure.md`: seven orbit-normalized
q=49 certificates make the R11 and R12 characteristic-seven carriers
pointedly shallow, while a strengthened R9 selector propagates through R13.
The unifying result is
`c973-2026-08-26-one-carry-module-theorem.md`, which identifies every carrier
with `r-2=p+a`, `0<=a<=p-3`, as the standard projective module
`P(Gamma^(p-a-3) E)`.  Consequently the only possible R11 modular exceptions
are now `q in {16,27,32,64}`; further level-by-level work is intentionally
deprioritized in favor of the multi-digit module theorem.  That theorem is now
proved in `c973-2026-08-26-digit-stripping-exact-sequence.md`: both the Pascal
nucleus and maximal carrier admit coupled least-digit exact sequences with
explicit determinant, divided-power, and Frobenius-twist factors.  The
remaining all-level gate is arithmetic transport of pointed witnesses through
those extensions, not identification of the carrier module.
The 30-minute continuation, structural/computational boundary, software
interface, explicit `ej`/`tt` pass, and revised mystery ledger are summarized
in `c973-2026-08-26-third-sprint-closeout.md`.
Preliminary literature positioning is in
`c973-2026-08-26-module-literature-preaudit.md`; it treats the module
filtration as likely classical pending full-text comparison and reserves the
PRS pointed-abundance application as the substantive open research claim.
The digit theorem's author-side seam review is
`c973-2026-08-26-digit-stripping-hostile-audit.md`; independent specialist
review remains required.
The cofinite-support transfer is proved in
`c973-2026-08-26-cofinite-grs-transfer.md`.  For a GRS support obtained by
deleting `s` projective evaluation points, it gives the pointed threshold
`6r+6s-16+floor(2 sqrt(6r+6s-18))`, an `r-2` locator avoiding every deletion,
and, in large characteristic, the exact distance-`r` and distance-`r-1`
shells and their counts.  The full-affine deep shell is classical in this
high-rate range; the next-to-deep shell and constructive separation require
a claim-specific prior-art audit.  Generic LDPC does not inherit the theorem,
but RS-local Tanner and lifted-code compatibility is recorded as a separate
open direction.

## Objective

Replace the stagewise one-step lower-package hypothesis in the Beyond Four
projective Reed--Solomon theorem by a direct simultaneous-marker argument, prove
the strongest resulting arbitrary-redundancy split-free/deep-hole theorem, and
determine how far the same method reduces the remaining small-characteristic
problem to an explicit classification of the maximal Lucas carrier.

This is a mathematics, proof, and theorem-boundary task.  It does not edit the
manuscript.  If the theorem succeeds, manuscript integration, compression,
verification-map changes, and release review belong to a separately allocated
follow-up C item.

## Primary theorem target

For redundancy `r >= 6`, put `m = r - 5`.  For a degree-`m` marker form `R`,
define the composite contraction

\[
  \kappa_f(R)=\iota_R f\in\Gamma^4E.
\]

Prove directly that, outside the exact reduced carrier

\[
  \mathcal P_r\cup\mathcal M^{\max}_{r,p},
\]

there is a completely split squarefree `R` over `F_q` for which the terminal
redundancy-five system has a split squarefree cubic avoiding every root of `R`.
The direct contraction identity must then lift their product to a split
squarefree degree-`r-2` member of `W_f`, without invoking any intermediate
one-step lower package.

The desired numerical consequence is an unconditional containment

\[
  \operatorname{SplitFree}_r(\mathbb F_q)
  \subseteq
  \mathcal P_r(\mathbb F_q)\cup
  \mathcal M^{\max}_{r,p}(\mathbb F_q)
\]

for an explicit linear-in-`r` field threshold.  First try to retain

\[
  Q_r=6r-15+\lfloor2\sqrt{6r-17}\rfloor;
\]

if the simultaneous rational-selector bound forces a larger constant, prove
the sharpest honest bound and isolate exactly what would be needed to recover
`Q_r`.  When `p > r-1`, combine the containment with the already imported
Seroussi--Roth--Dür radius gate to obtain an unconditional arbitrary-redundancy
tangent/conjugate-secant deep-hole classification.

## Proof programme

### 1. Composite contraction and direct lifting

- Define contraction by an arbitrary binary form `R`, including the infinity
  chart and base change, and prove
  `g in W_(iota_R f)` if and only if `R g in W_f`.
- Treat zero or rank-deficient composite contractions explicitly; do not hide
  them behind a projectivized rational map.
- Prove that squarefreeness of `R g` is exactly squarefreeness of both factors
  plus root avoidance.  Intermediate marker collisions must disappear from the
  logical interface rather than be silently retained.

### 2. Global terminal selector

- Use C820's marker-catalecticant row-space theorem to identify the closure of
  the composite-contraction image with the projectivized row space of
  `Cat_(m,4)(f)`.
- Pull back the complete reduced R5 terminal carrier, characteristic by
  characteristic: the Hankel determinant plus the generic projected Veronese,
  the characteristic-two cyclic plane, or the characteristic-three wild cone.
- Prove the exact converse needed for escape: if every geometric split
  squarefree marker form lands in that terminal carrier, then
  `f in P_r union M^max_(r,p)` (including the rank-one, fixed-gcd, and collision
  boundaries at their correct logical locations).
- Construct an explicit nonzero selector on the split-marker parameter space
  outside that carrier.  Record its total degree, its degree in each ordered
  root, its behavior on diagonals and infinity, and the exact characteristic
  specializations.  No unspecified genericity clause is an exit gate.

### 3. Rational split-marker selection

- Prove a finite-field selection lemma for a nonzero symmetric/multiaffine
  selector on ordered distinct rational roots.  Compare coefficient-space
  counting, ordered-root grids with disjoint value blocks, and a direct count
  of rational split squarefree binary forms.
- Keep the selector bound separate from the terminal curve bound.  Establish
  whether it lies below `Q_r`; if not, identify the precise degree term that
  dominates and attempt to remove it.
- Do not replace this proof by an unstructured field census.  Small exact
  computations are permitted only as falsification tests or as compact
  certificates below a theorem-derived bound.

### 4. Terminal escape and arbitrary-r synthesis

- Apply the exact R5 quadratic-graph and `S_3` fiber-square packages to the
  selected terminal syndrome.
- Charge all retained roots at once.  The target deletion is
  `12 + 6(r-5) = 6r-18`, with every branch, diagonal, singular, marker, and
  fixed-factor contribution accounted for.
- Lift the terminal cubic directly by `R`; prove the unconditional split-free
  containment theorem and then the large-characteristic code theorem through
  the separate radius gate.
- Check R6--R10 as specializations, distinguishing a theorem-generated result
  from the existing sharper fixed-level or finite-certificate rows.

### 5. Quantitative witness abundance

- Count good ordered marker tuples and terminal split cubics rather than merely
  proving one exists.
- Divide by the exact multiplicity with which a degree-`r-2` split locator is
  represented by marker/terminal-root partitions.
- Seek an explicit lower bound for the number of split squarefree members of
  `W_f` outside the carrier, with the R5 exact count as its terminal case.
- State clearly whether the result is an exact identity, a lower bound, or a
  fixed-`r` Chebotarev/Weil asymptotic.  Record any algorithmic consequence for
  sampling or decoding, but do not edit C969/C970-owned code in this task.

### 6. Maximal Lucas-carrier discriminator

Once transverse escape is unconditional, make the sole remaining
small-characteristic problem explicit:

\[
  \mathcal M^{\max}_{r,p}(\mathbb F_q)
  \cap\operatorname{SplitFree}_r(\mathbb F_q).
\]

- Express the carrier by adjacent zero runs in Pascal row `r-2` and organize
  it by the base-`p` digits of `r-2`.
- Determine whether the R6/R7 binary families are the only infinite modular
  split-free exceptions, or exhibit the first genuine higher counterexample.
- Generalize the subspace-polynomial, projective-subline, and final-pair
  Kummer/Artin--Schreier constructions where the equations justify it.
- A positive all-level theorem is the gold exit.  A sharp counterexample or a
  proved obstruction that reduces the problem to an explicit new arithmetic
  cover is an authorized obstruction exit, but it must state the exact first
  unresolved Lucas block and cannot be replaced by a list of tested fields.

## Literature, proof, and evidence gates

- Before a novelty or priority verdict, run the dedicated current literature
  audit required by `notes/literature-audit-conventions.md`.  Wang's splitting
  families, Wang--Wu--Hu's projective-subline endpoint, normal-rational-curve
  nuclei, and the twisted-cubic line-incidence literature remain inputs at
  their already recorded boundaries.
- Before a paper-facing computational claim, follow
  `notes/research-reproducibility-conventions.md` and commit the report,
  generator, compact certificate, hashes, and independent replay together.
- Any Lean edit, generator run, build, or staleness probe requires reading and
  following `lean/AGENTS.md`; no Lean work is required merely to close the
  mathematical theorem.
- Before developing a nontrivial proof, consult only the routed applicable
  named-expert dossiers required by the workspace guide.

## Acceptance and stop rules

The task must produce a dated theorem/proof report with:

1. exact composite-contraction definitions and direct-lifting proof;
2. a complete characteristic-wise terminal-selector theorem;
3. a proved rational split-marker selection bound;
4. an unconditional arbitrary-r split-free containment theorem, or a precise
   proved obstruction showing why simultaneous selection cannot supply it;
5. the strongest justified large-characteristic deep-hole corollary;
6. the quantitative witness-count theorem or a documented exact obstruction;
7. the all-level Lucas verdict at the strongest proved boundary;
8. independent specialist review of the load-bearing geometry, finite-field
   selection, and coding promotion; and
9. an explicit `ej` plus `tt` closeout with a mystery ledger.

No ambient `PG(r-1,q)` census, fixed list of R11/R12/R13 experiments, or
restatement of C820's carrier theorem counts as progress on the primary gate.

## Paper-successor interface — no manuscript edits in C973

If the simultaneous-marker theorem succeeds, the final C973 report must give a
paper-integration map detailed enough for a separately allocated successor to
edit without reconstructing the research:

- the exact replacement statements for the current Theorems 1.1, 5.14, and
  6.4, including hypotheses, thresholds, radius boundary, and proposed stable
  semantic labels;
- which parts of Sections 5--7 become obsolete and which lemmas remain needed;
- which R8/R9 pointed-package proofs and R10 stage-budget arguments can be
  deleted, and which modular-carrier calculations or sharper finite-level
  thresholds must remain;
- how the quantitative witness theorem should replace or extend the current R5
  Chebotarev discussion and connect to the companion classifier without
  broadening its theorem registry prematurely;
- how the fixed R5--R10 results should be recast as corollaries and finite-field
  calibrations of the arbitrary-r theorem;
- the required updates to the abstract, introduction, reading map, scope/open
  problems, theorem map, formalization ledger, evidence registry, and
  verification boundary;
- a deletion/addition page-budget estimate showing how the stronger theorem
  reduces or preserves manuscript length; and
- every new literature, formal, computational, and external-reader gate the
  paper successor must run.

The paper successor must receive a newly reserved C ID.  C973 must not edit
`papers/beyond4_prs/`, its standalone mirror, public release metadata, the
software subtree, or any Version 1 artifact.

## Owned paths

- `notes/reed-solomon-tasks/c973-*`
- task-owned compact proof probes and certificates under a
  `notes/reed-solomon-tasks/c973-*` path, subject to the reproducibility gate
- the `reed-solomon` discovery track only for genuinely incidental findings
- the live queue and handoff only for C973 state transitions

All C915, C969, C970, manuscript, supplement, software, Lean, mirror, and
release paths are foreign unless a later explicit instruction expands scope.
