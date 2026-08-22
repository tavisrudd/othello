# C942 hostile cold audit of the frozen reviewer guide

**Frozen commit:** `6412a6c92`  
**Artifact reviewed:** `papers/cubic-stabilization-m1/REVIEWER_GUIDE.md` and its
README link  
**Verdict:** **Reject pending repair.**  The six-step mathematical route is
substantially correct and the primary theorem is kept separate from both
companions and the conditional all-stabilization paper.  Three required
boundary/provenance/replay repairs remain.  None changes the theorem.  
**Confidence:** `0.97`

## Audit basis

I read the frozen guide without consulting another C942 report, then checked it
against the primary README, all three primary manuscript sections, the paper
Makefile, `verification/README.md`, `verification/imported-sources.json`,
`verification/evidence.json`, the primary `PaperInterface.Main`, the relevant
rows of `lean/verification/claims.json`, `lean/verification/expected_axioms.txt`,
and `lean/README.md`.  Every repository-relative link in the guide and its
README invitation resolves to a tracked object at `6412a6c92`.  The archival DOI
also resolved successfully.  The failure below is therefore not a dead file
link; it is that the linked formal-replay page does not supply the replay the
guide says it supplies.

## Fatal findings

None.

## Major findings

### M1. The claimed guarded formal replay is not documented

Guide lines 80--82 say that `lean/README.md` documents a “separate guarded
formal replay.”  It does not.  That README gives the bare command
`lake build CubicStabilizationM1` at lines 689--693, later refers to “the
guarded build of the axiom audit” without giving a guarded build command, and
only shows how to check an already captured `AXIOM_AUDIT_STDOUT`.  Thus a cold
reviewer cannot follow the guide's advertised path from clean source to a
captured kernel axiom transcript.  This also conflicts with the repository's
mandatory guarded Lean entry point; the local README cannot override that
rule.

**Concrete repair text for the guide (replace lines 80--82):**

> It does not build Lean or replay the captured axiom audit.  The formal build,
> axiom-transcript capture, and transcript check require the guarded commands
> documented in `lean/README.md`.

That replacement is valid only after `lean/README.md` actually gives the exact
guarded build-and-capture command usable from a clean checkout and removes the
bare `lake build` instruction.  If C942 cannot repair that owning document,
replace the last sentence instead with:

> It does not build Lean or replay the captured axiom audit.  The claim-map and
> axiom-registry semantics are documented in `lean/README.md`, but this guide
> does not currently provide a standalone formal replay command.

### M2. “Checks the ... rank-two marker” overstates formal coverage

Guide lines 69--71 compress materially different coverage grades into “checks
the algebraic ledger, rank-two marker, and final deductions.”  The registry is
more limited: `prop:residue-discriminant-exponents` is only a fragment, and its
caution says Lean does **not** formalize the identification of residue
eigenvalue classes modulo the integers with formal exponent classes.
`lem:faithful-center-base-change` is absent.  The headline theorem is a
conditional deduction whose QDM construction, comparison theorems, weak
factorization, cubic-QDM identification, and geometric center-nullity witnesses
remain typed premises.  Since “formal-exponent marker” is the defining marker
in step 3, the current summary can make a referee believe that its complete
semantic construction is kernel checked when it is not.

**Concrete repair text (replace lines 69--71):**

> The Mathlib companion checks the effective ledger and occurrence-indexed
> telescope, parts of the rank-two residue matrix algebra, and the final
> implications from explicit typed premises.  It does not formalize the
> regular-singular identification of residue eigenvalues with formal exponent
> classes, the faithful center base change, the geometric QDM comparisons,
> weak factorization, or low-dimensional geometric nullity; the claim registry
> records the exact fragmentary, conditional, and absent boundaries.

### M3. “Theorem-level pinpoints” is false for two named imported inputs

Guide lines 61--66 say that all listed imported inputs are recorded with
“theorem-level pinpoints.”  The registry gives `PutSinger:ch-3` only as
“Chapter 3” and `BeauvilleSurfaces:minimal-surface-classification` only as
“Chapter VI.”  The other named inputs do have theorem/equation-level pointers,
and every listed row records convention matches, but the blanket description is
stronger than the record.

**Concrete repair text (replace “theorem-level pinpoints and convention
checks”):**

> source pinpoints and recorded convention matches

Alternatively, sharpen those two registry rows to an exact theorem/proposition
and retain the current guide wording only after verifying the primary sources.

## Minor findings

### m1. Step 1 attributes too much to the spectral-splitting proposition

The guide says `prop:generic-spectral-connection-splitting` “splits the generic
even QDM.”  The proposition starts with a separated block-diagonal leading
operator and upgrades that leading decomposition to a block-diagonal formal
connection.  The generalized-eigenspace split and its geometric QDM
interpretation are setup outside the proposition; the formal registry calls
this row a fragment.

**Concrete repair text:**

> Starting from the generalized eigenspaces of Euler multiplication,
> `prop:generic-spectral-connection-splitting` upgrades the separated leading
> decomposition to formal connection blocks.

### m2. Step 3 blurs the lemma with its immediate consequence

`lem:A0preserve` proves that the regular coefficient preserves the nilpotent
line; the paragraph following the lemma uses that fact to show that the
elementary modification is regular.  “Makes ... regular” is causally fair but
not an exact semantic-label description.

**Concrete repair text:**

> By `lem:A0preserve`, the only possible new pole in the elementary
> modification vanishes, so the modified rank-two square-zero block is regular.

### m3. Mathematical notation is not rendered as mathematics

The numbered route writes `(z)`, `(mathbb Z)`, `(-1/6)`, `(2/3)`,
`(X\times\mathbb P^1)`, and `(mathbb P^4)` as plain Markdown text.  Two of
these have already lost their backslashes, while the others expose TeX
commands literally in ordinary Markdown rendering.  This is the first visible
polish defect in an otherwise compact referee surface.

**Concrete repair text:** use the repository's supported Markdown math syntax
consistently, producing `$z$`, `$\mathbb Z$`, `$-1/6$`, `$-5/6$`, `$2/3$`,
`$X\times\mathbb P^1$`, and `$\mathbb P^4$`.

## Optional findings

### O1. Make the semantic labels directly locatable

The six steps give exact stable labels, which is good, but a cold reviewer must
search a 679-line TeX file for each one.  Linking each step heading to the
owning source file, or adding one source-file pointer per step, would improve
navigation without turning the guide into a second registry.  This is optional:
the labels themselves are accurate after the two attribution repairs above.

**Suggested text pattern:**

> `prop:qdm-operation-ledgers` (`sections/02-qdm-marker.tex`) ...

## Strongest passage

Lines 78--80 are the strongest passage: they state exactly what `make check`
does and, crucially, what it does **not** do.  The Makefile confirms all three
positive claims—source-only manuscript/claim correspondence, pinned PDF build,
and warning rejection—and confirms that Lean build and axiom-log replay are
outside that target.  This is the right trust-boundary style; M1 repairs only
the sentence that follows it.

## First point of friction

The first substantive friction is step 1, not the opening.  A referee is told
that one proposition “splits the generic even QDM,” but the proposition assumes
the separated leading blocks and proves the formal gauge upgrade.  The intended
mechanism becomes exact after the one-sentence m1 repair.

## Disposition

The theorem scope and conditionality pass: the route is strictly the
unconditional `m=1` theorem, the companions are declared unnecessary, the
all-stabilization manuscript is excluded, and the headline route uses no
computational evidence bundle.  Internal links pass at the frozen commit, and
the `make check` description is accurate.  Repair M1--M3 and m1--m3, then rerun
the clean-checkout link/replay audit; O1 may be accepted or declined explicitly.
