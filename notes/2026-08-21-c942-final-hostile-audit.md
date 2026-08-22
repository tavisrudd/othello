# C942 final hostile audit of `d35683e81`

## Verdict

**PASS WITH ONE MINOR WORDING REPAIR.**  The reviewer guide is materially accurate, scoped to the primary one-stabilization manuscript, and unusually clear about the formal and computational trust boundary.  I found no fatal or major defect, no dead link, no false coverage count, no claim that the companion is part of Mathlib, and no false assertion that `make check` builds Lean or replays an axiom audit.

The one remaining defect is a local overstatement in check 1: “any additive block marker” suppresses hypotheses that are essential in `thm:marker-ledger`.  Check 2 later asks the reader to verify the operation formulas, so the route as a whole is not logically misleading, but the sentence is false if read on its own and should be tightened.

## Confidence

**High (0.96).**  I compared the guide at `d35683e81` directly with the primary manuscript (`cubic_stabilization_m1.tex` and Sections 1--3), the primary-paper rows of `lean/verification/claims.json`, the relevant entries of `verification/imported-sources.json`, `lean/verification/expected_axioms.txt`, the linked Lean entry module, both linked README files, the checker implementation, and the Makefile.  I did not consult any earlier C942 audit report or either companion manuscript.

## Fatal findings

None.

## Major findings

None.

## Minor findings

### M1. “Any additive block marker” omits the ledger theorem's operation and invariance hypotheses

Guide text:

> `thm:marker-ledger` turns any additive block marker into a birational invariant once every actual center occurrence has value zero.

The manuscript theorem is conditional on more than additivity and center nullity.  The fold must be unchanged by the allowed regular scalar extensions and formal coordinate changes, and it must satisfy the projective-bundle and occurrence-indexed blowup formulas.  The following check discusses the formulas, which limits the damage, but “any” still overstates the theorem's scope and hides conditionality at the first point where the theorem is summarized.

**Exact repair text:**

> For a marker fold invariant under the allowed regular scalar extensions and formal coordinate changes, `thm:marker-ledger` turns the projective-bundle and occurrence-indexed blowup formulas into a birational invariant once every actual center occurrence has value zero.

## Optional findings

### O1. Name `expected_axioms.txt` as an expected list, not an expected transcript

The guide already says that the file is not evidence of a fresh run, and its `make check` description is correct.  Still, “expected dependency transcript” is slightly awkward because the actual captured stdout is the transcript that `--axiom-log` checks against this file.

**Optional exact repair text:**

> [`expected_axioms.txt`](lean/verification/expected_axioms.txt) is the expected axiom list against which captured kernel output is checked; it is not a record of a fresh kernel run.

## Adversarial checks

- **Theorem scope:** The guide consistently limits the headline result to one stabilization and explicitly separates the conditional all-stabilization manuscript.  Section 3 of the manuscript independently confirms that no second or arbitrary stabilization is implicit.
- **Hidden conditionality:** The formal-coverage paragraph correctly says that Lean's final implications are from typed premises and enumerates the main unformalized inputs.  M1 is the only suppressed mathematical hypothesis I found in the prose route.
- **Overstatement:** “The primary paper contains the whole proof” is defensible in ordinary mathematical usage because the next boundary paragraph names the external theorems it imports and the manuscript writes the intervening argument.  It does not imply self-contained proofs of the cited outside results.
- **Links:** Every relative link in the guide resolves at `d35683e81`.  The section links, import registry, primary Lean entry module, claims registry, expected-axiom file, and both README files are live and semantically relevant.
- **Label attribution:** All labels named in the six checks exist in the primary manuscript and point to the described step.  In particular, `prop:residue-discriminant-exponents` has only fragmentary Lean coverage, and the guide accurately says that Lean does not formalize its regular-singular exponent identification.
- **Mathlib relationship:** “Built against Mathlib; it is not part of Mathlib” matches the package README's description of a Mathlib-only companion and does not imply upstream inclusion.
- **Coverage inventory:** Restricting `claims.json` to the fifteen theorem-like environments in the primary paper yields exactly five `fragment`, nine `conditional_deduction`, and one `absent` (`lem:faithful-center-base-change`), with zero `complete` rows.
- **Check and replay claims:** The Makefile's `check` target runs linting, `check_formal_artifact.py --source-only`, PDF construction in the pinned manuscript environment, and warning rejection.  It does not build Lean and does not compare captured axiom stdout.  The guide says exactly this and explicitly declines to provide a standalone formal replay command.
- **Computational boundary:** No evidence annotation or evidence bundle is used by `thm:every-cubic`; the guide's statement is accurate.
- **AI-template prose:** No actionable template residue remains.  The interrogative six-check structure serves the referee's task, the prose avoids canned significance claims and generic chatbot transitions, and the short final trust paragraphs are concrete rather than ceremonial.

## Strongest passage

The strongest passage is the Lean-boundary paragraph beginning “The repository also contains a Lean 4 companion.”  It gives exact primary-paper coverage counts, distinguishes fragments from conditional deductions and absence, names what Lean actually proves, and lists the principal gaps without treating typed premises as formalizations.  This is the guide's most audit-useful paragraph.

## First friction

The first friction is check 1's phrase “any additive block marker.”  A skeptical reader reaches it before check 2 restores the missing operation-formula context, so it briefly makes `thm:marker-ledger` sound stronger and less conditional than its statement.

## Acceptance after repair

Apply M1's one-sentence replacement.  O1 is a precision improvement, not an acceptance blocker.  With M1 repaired, I would return an unqualified **PASS**.
