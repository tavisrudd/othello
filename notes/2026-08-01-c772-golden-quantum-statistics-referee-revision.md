# C772 — Golden quantum-statistics PRA referee revision

**Lane:** `golden`

**Date:** 2026-08-01

**Verdict:** technically ready for the user's live posting and subsequent
Clebsch forward reference.

## Result

C772 implements the C771 major-revision report without changing the paper's
bounded theory/design-limit identity.  The final local artifact is
`golden-quantum-statistics-c772-final` at commit
`dfaae2bb`.  The earlier `golden-quantum-statistics-c772-r1` tag is a
pre-final checkpoint and must not be used as the submission locator.

The user owns live posting, the public locator, and the Clebsch forward
reference.  C772 adds no gate around those actions.

## Referee-response check

| C771 request | response | status |
|---|---|---|
| Make the Golden theorem checkable | The opening now says explicitly that the note builds on live Clebsch Papers I and III.  Section 2 gives the base conference matrix, synthematic-total model, canonical protocol representatives, transported orientations, and pivot frames.  Theorem 3.5 now derives the trace invariants and characteristic polynomial locally, with Paper III cited for the operator/Joubert identity. | resolved |
| Separate amplitude orientation from observable probability | The abstract, introduction, theorem transition, apparatus section, and discussion now say that the determinant amplitude is orientation-covariant, its filled-fermion probability is sign-blind, and the proposed sign is inferred by coherent one-particle tomography rather than measured as a direct many-fermion phase. | resolved |
| Expose artifacts and APS data status | A Data Availability Statement distinguishes exact supplemental artifacts from absent empirical data.  The submission record identifies the exact local artifact; the user will supply its live locator. | resolved at package level; posting user-owned |
| Derive quantitative design limits | The paper now proves the determinant Lipschitz bound, prints the Bonferroni/normal-approximation trial formula and rounding rule, and derives both adversarial fidelity inequalities. | resolved |
| Explain the PRA significance | The opening identifies protocol-independent calibration, the sharp 20/44 Boolean boundary, and reduced simplex readout as the operational gains.  The anomaly instance is removed from the abstract and demoted to a bounded corollary. | resolved |

All ten minor comments are also closed: terminology is local, the determinant
normalization comma is repaired, live Clebsch dependencies are credited,
`B_sym` is separated from its uniform-input average, dagger notation is
explained, the three- and five-cut schedules are printed, the figure labels
selected/postselected ports, PRA handling is recorded as a Regular Article,
and the Tichy, Shchesnovich, and Piccolini published records are normalized.

## Package and validation

The warning-free PDF is twelve pages.  The final source and PDF are:

| file | bytes | SHA-256 |
|---|---:|---|
| `golden_quantum_statistics.tex` | 38,581 | `8ee5873b69cb817dab2c8d051e512bddb08257a0c866efde596ad21e5644e832` |
| `golden_quantum_statistics.pdf` | 116,416 | `6337d5526aa5ab7bd5b2c10f9d83880885ea626cb97c27ce28a56e6761021919` |

From `papers/golden-quantum-statistics`:

```text
make check
make verify-sources
```

both pass.  The first covers spacing lint, the paper-local exact checker,
isolated XeLaTeX, references, citations, box warnings, and package warnings.
The second regenerates/checks all three frozen C715/C718/C719 source bundles
and runs their independent replays.  Pages 1--5 and 8--11 were visually
inspected after revision; the new matrix/interface, proof, figure,
quantitative derivations, data statement, and bibliography are legible.

## Source updates

- Clebsch Paper I, *Reconstructing the Clebsch code and its golden orientation
  from its deep-hole syndrome locus*, and Paper III, *Golden descent and
  operator realizations of the Clebsch cubic*, are cited as 2026 preprints;
  the user will add their live identifiers.
- Tichy's published metadata was read at **abstract/metadata only** from the
  Crossref record for DOI `10.1088/0953-4075/47/10/103001`.
- Shchesnovich's published metadata was read at **abstract/metadata only**
  from the official Physical Review A issue/article record for DOI
  `10.1103/PhysRevA.91.013844`.
- Piccolini et al.'s published DOI was already verified in C768; C772 adds it
  to the bibliography without changing C768's preprint-based read depth.

These metadata updates support bibliography normalization only, not new
source characterizations or priority claims.

## `ej` + `tt` closeout and mystery ledger

The closeout pressed the strongest remaining referee questions.  The full
Clebsch dependency is now a positive architectural statement rather than a
defensive citation; the local spectrum calculation is short enough to audit;
and every physical use of the sign identifies tomography as its readout.  No
cheap direct many-fermion phase protocol is implicit in the current design, so
none was invented for the revision.

| feature | status | evidence gap or owner |
|---|---|---|
| Can the present emulator directly measure determinant phase? | **Open, outside this paper** | It measures `|det K|^2`; a coherent exterior-sector reference would be a new protocol. |
| Are the Clebsch dependencies visible enough for the full package? | **Settled** | The abstract/introduction give explicit build-on credit; Section 2 cites and locally instantiates the source theorem. |
| Is the PRA package technically ready? | **Settled** | Referee matrix closed, both validation commands pass, final artifact tagged. |
| Who supplies live identifiers and the forward reference? | **Settled** | User-owned; no agent-side gate. |

No incidental discovery-track entry was created.  The direct-phase question
was an explicit C771/C772 referee issue, not an incidental lead.

**Vibe check:** this is now a materially better paper and a cleaner multi-paper
package.  It credits the source mathematics, earns the quantum-statistics note
through a distinct operational question, and no longer lets amplitude language
outrun the observable.

