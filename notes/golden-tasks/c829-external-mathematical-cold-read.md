# C829: External mathematical cold read

**Lane:** `golden`

**Status:** complete — frozen `MINOR` report at commit `9f3e1639`

## Objective

Obtain an independent mathematical cold read of the authoritative Golden
quantum-statistics paper, concentrated on the continuous-control theorem and
the squared-spectrum rigidity/stability theorem. This is a review task; it
does not authorize manuscript edits before author triage.

## Reviewer brief

- Reconstruct the continuous-control proof without consulting task reports or
  certificates: cube reduction, endpoint spectra, equality cases, and the
  mixed-sector three-variable lemma.
- Check the Hermitian supporting inequalities and completeness of the
  displayed componentwise-maximal frontier.
- Reconstruct squared-spectrum rigidity from constant absolute triangle
  holonomy, pentagon parity, and the Pfaffian-square endpoint obstruction.
- Verify the Frobenius normalization, triangle-counting factor, global lower
  bound, rounding estimate, exact local threshold, and parity conclusion in
  the reverse stability bound.
- Identify every hidden hypothesis, ambiguous convention, unjustified
  equality case, or place where the prose outruns the proof.

## Deliverable and gate

Produce a self-contained referee report with a `PASS`, `MINOR`, or `MAJOR`
verdict; numbered comments tied to theorem/equation locations; an explicit
reconstruction of the causal proof spine; and a separate list of optional
expository improvements. Freeze the report before author triage. Do not
inspect private research reports or exact certificates until after the
independent verdict.

## Outcome

The frozen independent report is
`notes/2026-08-02-c829-golden-external-mathematical-cold-read.md` at commit
`9f3e1639`.  Its verdict is `MINOR`: all audited theorem statements,
normalizations, constants, equality sets, and thresholds survive; two
elementary completeness bridges and one citation locator are deferred to
author triage.  C829 made no manuscript edit.

Lifecycle validation and the post-freeze `ej` + `tt` mystery ledger are in
`notes/2026-08-02-c829-golden-cold-read-closeout.md`.
