# C864 — Dye external-input audit and prepared trust-anchor review

**Lane:** `build-sys` · **Task:** C864 · **Date:** 2026-08-04

Build-independent portion of the Arcs/Clebsch-rigidity trust disposition, performed while the
official order-16 certificate cold fill owns the host. No Lean elaboration, generator run, or
registry edit was performed.

## Dye input audit: both declarations are genuine, used literature inputs

`RelativeConicArcs.ClebschDye.dye1991_brianchon_bound` and
`RelativeConicArcs.ClebschDye.dye1991_equality_classification` are declared in
`lean/RelativeConicArcs/Q11DyeAxioms.lean` and consumed by

- `lean/RelativeConicArcs/Q11DyeConsequences.lean` (both axioms), and
- `lean/RelativeConicArcs/Q11RigiditySpine.lean` (the equality classification).

Both modules are direct imports of `RelativeConicArcs.Gates.ClebschRigidityTrust`. Neither
declaration is an orphan, so the disposition is to keep them and give each an exact theorem-level
entry declaration, not to delete them.

### Fidelity check against the source

Source: R. H. Dye, "Hexagons, conics, \(A_5\) and \(\mathrm{PSL}_2(K)\)", *Journal of the London
Mathematical Society* (2) **44** (1991), 270--286, doi:10.1112/jlms/s2-44.2.270. Every quotation
below was verified against the authoritative page images in the shared scan set, not only the OCR
reconstruction.

| Lean declaration | Cited pinpoint | Source text | Verdict |
|---|---|---|---|
| `dye1991_brianchon_bound` | Section 2.2, p. 275 | "Each Brianchon point is on three of the 15 edges. Hence a hexagon can have at most 15 x 2/3 = 10 Brianchon points." | faithful specialization |
| `dye1991_equality_classification` | Theorem 1(ii), p. 275 | "PGL_3(K) is transitive on the Clebsch hexagons of PG(2,K) when they occur." | faithful, with one added commitment (below) |

Definitional agreement also checks out. Dye, p. 270: "For us, a hexagon is a set of six points, no
three collinear, in PG(2,K)" — matching the Lean hypotheses `Arc A` and `A.card = 6`. Dye, p. 271:
"A non-vertex point through which pass three edges of a hexagon has been called a *Brianchon
point* ... we shall call a hexagon with (exactly) 10 Brianchon points a *Clebsch hexagon*" —
matching the Lean definition of `brianchonPoints` as the off-arc points meeting exactly three
secants. The existence hypotheses of Theorem 1(i) hold at \(q = 11\): the characteristic is not 2
and 5 is a square modulo 11.

Neither Lean statement is stronger than the cited result in its hypotheses or its conclusion, so no
re-proof of a Dye theorem is required.

### One residual commitment beyond Theorem 1(ii)

`dye1991_equality_classification` concludes `IsClebschHexagon A`, which is projective equivalence to
the displayed witness `clebschWitness`. Dye's Theorem 1(ii) gives transitivity on the class of
Clebsch hexagons; concluding equivalence to that particular representative additionally asserts that
the displayed witness is itself a Clebsch hexagon, i.e. that it has exactly ten Brianchon points. No
Lean declaration establishes that. It is a decidable finite fact about a concrete six-point set in
PG(2,11), so proving `(brianchonPoints clebschWitness).card = 10` and rewriting the axiom's
conclusion in terms of the abstract Clebsch-hexagon property would reduce the trusted boundary to
exactly the definition plus Theorem 1(ii). This is the cheapest available strengthening of the
rigidity trust boundary and is owned by C864's Dye bullet; it needs the build window.

## Review of the prepared external-input anchors

The detached repair worktree at `/home/tavis/.cache/c855-grs-proof` (based on `f4aba33e`) carries an
uncommitted registry edit to `lean/trust/areas/relconic.toml` that

- anchors the Kim--Vu complete-arc bound to `RelativeConicArcs.Averaging.rhoC_le_of_kimVuBound`,
- anchors the Al-Seraji--Al-Ogali class count to
  `RelativeConicArcs.Q16Classification.rejection_profile`,
- deletes the NRC/GRS dictionary entry outright, and
- registers a new gate `RelativeConicArcs.Gates.Q11ProjectiveGRS` with terminal
  `RelativeConicArcs.Examples.Q11Coding.witness_not_projectivelyGRS`.

Two findings.

**The Kim--Vu anchor resolves.** `rhoC_le_of_kimVuBound` is present in
`lean/RelativeConicArcs/Averaging.lean`.

**The Al-Seraji--Al-Ogali anchor no longer resolves locally and cannot be applied verbatim.**
`rejection_profile` is absent from the monorepo. It now lives in the official order-16 certificate
package as `RelativeConicArcs.Q16Classification.rejection_profile` in
`lean/RelativeConicArcs/Q16Profile.lean`, under the package's owned module prefix
`RelativeConicArcs.Q16Profile`. The registry edit was prepared before the order-16 externalization,
so it is stale with respect to it. Applying it as written would make the trust checker report
`external-input-entry-missing`: `check_external_inputs` in `lean/scripts/lean-trust-spine.py`
requires every entry declaration to appear among the project declarations of some extraction unit,
and an external package's declarations are not extraction units of this repository.

**Open design question, not decided here.** `lean/trust/certificate-packages.toml` currently pins a
package's repository, commit, manifest hash, gate module, and single terminal. It carries no
extracted axiom fact and no declaration inventory, so there is at present no way for an
`[[external_input]]` entry declaration to name a declaration owned by an external package. Closing
the Al-Seraji--Al-Ogali anchor therefore depends on the pinned-external-fact mechanism that C864's
order-16 sealing step must produce, and on a decision about how the area registry references it —
either a package-qualified entry declaration or a separate external-anchor field. This is a
validation-gate shape change and needs an explicit decision before implementation.

## Order-16 build state at the time of this audit

The official cold fill at `/home/tavis/.cache/othello-lean-build/run-20260804-151540-87eb8c71` is
running with a live heartbeat. It skipped the three trace-current sentinels — the certificate
levels, the step kernel, and the reduction — restored the Mathlib cache once, and is source-building
the certificate-rows tree toward `RelativeConicArcs.Gates.Q16CertificateTrust`. No second heavy
build was submitted.

## Unrelated dirty file left untouched

`lean/trust/facts/RepairPorts.Gates.CompletePorts.json` is modified in the working tree, adding the
`RepairPorts.PointedTutte` module and its declarations. It predates this session and belongs to the
complete-ports work; C864 did not stage, revert, or regenerate it.
