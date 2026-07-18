# C286 cold read: geometric flagships through conclusion

**Date:** 2026-07-17  
**Scope:** Context-light, paragraph-by-paragraph read of
`papers/complete-repair-ports/complete_repair_ports.tex`, lines 464--697.  The only contextual
document read was the C188 cold-read example.  No manuscript source, task handoff, proof ledger,
or prior review was consulted or edited.

## Sequential read ledger

- **464--471 (end of setup display; cubic-axis identification): PASS.** The assigned range begins
  inside the coordinate display, but the following attribution cleanly separates the classical
  geometric identification from claims derived from the coordinates.
- **473--496 (Theorem, “Cubic--axis port”): PASS.** The parameter, circuit, row, and strict-inequality
  claims are stated in a usable order; the three coordinate types remain distinguishable.
- **498--510 (cubic proof sketch): MINOR.** The final cubic-target sentence does not expose how
  “omitting two suitable helper classes” proves the displayed transversal number `q-2`.  A cold
  reader cannot tell what a helper class is, what is omitted from what, or why the remaining
  `q-2` objects form a hitting set.  Replace lines 505--508 with a sentence that names the two
  helper classes and says explicitly: “the remaining `q-2` [named helpers/classes] meet every
  repair, while the generator pairing supplies a matching of size `(q-1)/2`.”  If “omitting” is
  instead a complement argument, state the ambient set and take the complement explicitly.
- **512--524 (field-nine rows, restored cubic point, transfer cross-reference): PASS.** The ordered
  rows and multiplicities make the specialization easy to audit, and the restored-code paragraph
  reconnects to the earlier weighted-transfer example without overstating it.
- **526--535 (quartic--nucleus setup): PASS.** Coordinates, support, characteristic, and classical
  input are introduced economically.
- **537--552 (Theorem, “Quartic--nucleus port”): PASS.** Parameters, complete small-circuit
  classification, Steiner interpretation, repairs, and the `q=9` counts form a clear statement.
- **554--561 (harmonic proof, completion/Steiner paragraph): PASS.** The finite and infinity cases
  cover the completion rule, and the harmonic identification lands at the right point.
- **563--570 (harmonic proof, independence/distance paragraph): PASS.** Circuit minimality, dual
  distance, primal distance, and the finite enumeration have a logical progression.
- **572--575 (coarse transfer): PASS.** The numerical gate is explicit and the realization claim is
  properly attributed to the earlier theorem.
- **577--602 (reliability/EXIT introduction and field-nine profiles): PASS.** The Bernstein
  convention is visible in the formula, the two target types are kept parallel, and the blocker and
  area claims follow without a narrative jump.
- **604--613 (pointed-Tutte success enumerators): PASS.** The paragraph says exactly what the full
  enumerators add and ties the difference to the promised radius boundary.
- **615--633 (asymptotic reliability contrast): MINOR.** “In any `S(3,4,n)`” is grammatically a
  statement at fixed `n`, whereas the displayed limit requires a sequence of admissible orders.
  Replace the opening with: “Along any sequence of Steiner systems `S(3,4,n)` with
  `n` tending to infinity, retain each point independently with probability `s=cn^{-3/4}`.”  The ensuing
  nucleus/curve comparison then reads as one asymptotic experiment rather than an implicit change
  of quantifiers.
- **635--647 (deterministic nucleus gate): PASS.** The closure rule, two cases, and field-nine
  separation are concrete; the last sentence responsibly bounds the interpretation.
- **649--656 (Verification and provenance, opening paragraph): MODERATE.** The section advertises
  verification but explicitly withholds the public module closure and artifact provenance, so it
  is not publication-ready on its own.  It also uses Markdown-style backticks in TeX.  For the
  draft, replace the module names by `\texttt{RepairCodes}` and
  `\texttt{RepairPorts.FunctionalCost}`.  Before public circulation, replace lines 653--655 with a
  stable repository/release identifier and the exact public checker roots; for example: “At release
  tag [TAG], the paper-facing Lean roots are \texttt{RepairCodes} and
  \texttt{RepairPorts.FunctionalCost}; [MANIFEST PATH] records their exact imported closure and
  artifact hashes.”
- **658--665 (deterministic replays and trust boundary): MODERATE.** Internal task labels C218,
  C219, C226, C227, C243, and C244 are not usable provenance for an external reader, and “private
  evidence bundle” confirms that the advertised replays are unavailable from the paper.  Replace
  the task-ID list with stable public paths/DOIs plus a release tag or archive hash.  Exact editorial
  pattern: “The deterministic replay bundle at [PUBLIC ARCHIVE, VERSION, HASH] contains the scripts,
  JSON certificates, replay commands, conventions, checked counts, and finite boundaries for the
  quartic circuits, reliability, bounded EXIT transforms, pointed-Tutte profiles, nucleus gate,
  pointed distances, EXIT deficits, and Poisson-rate checks.”  Keep the final two sentences; they
  state the finite/symbolic trust boundary well.
- **667--671 (external inputs): MINOR.** “Quarantined asymptotic import” sounds like internal audit
  vocabulary rather than mathematical exposition.  Replace the first sentence’s opening with “The
  only asymptotic theorem used without proof is …”.  The classical-input inventory itself is useful.
- **673--680 (Conclusion, synthesis paragraph): PASS.** The three compatible views and the two
  transfer mechanisms recapitulate the paper’s organizing claim crisply.
- **682--687 (Conclusion, geometric contrast): MODERATE.** “what bounded radius remembers beyond
  it” makes the bounded invariant sound as though it contains information beyond the full-radius
  structure; the pronoun can also point to the Steiner design or pointed-Tutte theory.  Replace the
  last sentence with: “Pointed-Tutte theory explains the full-radius structure, while the explicit
  field-nine profiles isolate what the bounded-radius truncation retains and what the full-radius
  invariant adds.”
- **689--692 (Conclusion, exclusions): MODERATE.** “Optional” and “pending its separate inclusion
  decision” expose an editorial decision process rather than delimit the theorem proved by the
  paper.  Delete the first sentence, or replace it with the publication-facing sentence: “A sharper
  cubic blocker-stability statement is not needed for the present results.”  The second sentence is
  a clean scope boundary and should remain.
- **694--697 (bibliography commands and document end): PASS.** No cold-read issue in the closing
  environment.

## Findings by severity

**BLOCKER:** None in the assigned text as mathematics or exposition.  The MODERATE provenance
placeholders are nevertheless a publication-preparation gate and should be resolved before release.

**MODERATE:**

1. Lines 649--665 promise verification while naming private roots/task IDs rather than a stable,
   public evidence bundle.
2. Lines 682--687 blur the direction of the bounded-radius/full-radius comparison.
3. Lines 689--690 retain internal inclusion-decision language in the conclusion.

**MINOR:**

1. Lines 505--508 compress the cubic-target transversal argument past cold readability.
2. Line 616 should quantify over an asymptotic sequence of admissible Steiner systems.
3. Lines 653--654 use backticks rather than TeX typewriter markup.
4. Line 667 uses internal-sounding “quarantined import” terminology.

## Overall flow and highest-value edits

The back half has a strong large-scale shape: the cubic family supplies an overlapping,
weighted-transfer flagship; the quartic family supplies a sharply contrasting Steiner/series-gate
flagship; reliability, pointed-Tutte enumeration, and deterministic closure then revisit the same
geometry at increasing radii.  The verification section interrupts that momentum mainly because it
switches from mathematical prose to private-project bookkeeping, and the conclusion is otherwise
effective except for its two final wording seams.

The highest-value edit is to make verification genuinely externally replayable by replacing the
private C-label inventory and withheld closure with one versioned public manifest/bundle.  Next,
repair the full-radius/bounded-radius sentence and remove the pending-inclusion remark.  Finally,
expand the one cubic transversal sentence just enough that the theorem’s exact `q-2` value is
visible from the proof sketch.
