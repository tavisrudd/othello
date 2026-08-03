# C855 — Paper I formalization progress (checklist section 2)

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Task:** C855 — Paper I Lean referee-artifact standards remediation
**Scope:** new self-contained modules in the human-spine base package
`~/src/lean/finitegeom` under `RelativeConicArcs/`, closing gaps recorded in Part D of
`2026-08-02-c855-paper-i-assertion-inventory.md`. No gate rewiring, manifest edit, rename,
or generated-leaf change; those are batched for a later window.

Every module is elaborated through the guarded single-file entry point with
`--root /home/tavis/src/lean/finitegeom`. Axiom audits are recorded from the module's own
`#print axioms` lines.

## Author policy in force

Human structural proof wherever possible: the mechanism a referee reads, not decidable
enumeration. Finite checking is a last resort and must first be compressed by a proved
structural reduction. Anything irreducibly certificate-shaped is scoped out to the
certificate package and recorded here rather than built.

## Modules landed

### `RelativeConicArcs/ConicFillingOrderElimination.lean`

Commit `e13eba2`. Closes the arithmetic half of the companion's cross-field uniqueness
theorem (`thm:why11`), inventory row "the arithmetic elimination of candidate orders needs
an explicit terminal".

Terminals: `order_le_eleven_of_window`, `not_isPrimePow_ten`, `candidate_orders`,
`not_six_pairwise_adjacent`, `order_eq_eleven`.

Mechanism. The conic-filling window gives `c = (q - 6) * (q - 9)` with `c ≤ 15`; both factors
grow, so `q ≥ 12` already forces `c ≥ 18` and the order is at most eleven. Ten is removed by a
two-line primality argument: two and five both divide it, and a prime power has one prime
divisor. The order-nine exclusion is isolated as a graph statement — six pairwise adjacent
vertices cannot exist in a graph whose cliques have at most five vertices — with the
identification of the passant-join relation with the Sylvester graph's distance-two relation,
and its clique value five, left as hypotheses. The final terminal combines the two.

Axiom audit: `candidate_orders`, `not_six_pairwise_adjacent`, and `order_eq_eleven` each
depend only on `propext`, `Classical.choice`, `Quot.sound`. No `sorry`, native execution, or
project axiom.

Remaining for this row: the Sylvester identification and the clique value five are external
transfers (Brouwer–Cohen–Neumaier / Jurišić–Vidali, Abiad–Jabal Ameli–Reijnders) and stay
open as hypotheses of `order_eq_eleven`.

### `RelativeConicArcs/GoldenOrderConductorTwo.lean` (audit lines added)

Commit `6b0aa57`. No mathematical change: the module's eleven public declarations now each
carry a `#print axioms` line, matching its sibling. All eleven depend only on some subset of
`propext`, `Classical.choice`, `Quot.sound`; three depend on `propext` alone.

### `RelativeConicArcs/ClebschFamilyRegimes.lean` (input discharge added)

Commit `f315ffc`. The module's counting layer was parameterized by four numerical
hypotheses. Two of them are now discharged structurally and the third is recorded in the form
the conic supplies it:

- `card_threeElementSupports` — a length-six code has exactly twenty three-element coordinate
  supports, so the leader count per coset is not an assumed number;
- `card_dimensionThree` — a dimension-three code over the field of `q` elements has `q ^ 3`
  words;
- `conicPoints_at_order_eleven` — the twelve maximum-distance directions are the rational
  points of the conic at order eleven;
- `witness_deepHole_counts_of_structure` — the same counts `120 / 2400 / 159720` from those
  structural inputs instead of the bare numerals.

Status wording for the inventory: the deep-hole count corollary (`cor:named-variety`) is
**counting layer closed, bridge open**. What remains is the geometric bridge — that the
uncovered locus is the conic and that minimum-weight leaders of a maximum-distance coset
biject with three-element supports — which lives in the arc-to-coset dictionary, still an
external transfer. The uncovered-formula hypothesis of the order-regime terminals is likewise
still supplied by `ClebschChordDefect` rather than discharged inside this module.

All terminals depend only on `propext`, `Classical.choice`, `Quot.sound`;
`conicPoints_at_order_eleven` depends on no axioms.

## Targets attempted and their status

Filled in as work proceeds; see the closing section for the final per-target line.
