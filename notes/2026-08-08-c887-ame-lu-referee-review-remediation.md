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

## Finding disposition

| Supplied criticism | Verdict | Evidence and disposition |
|---|---|---|
| Theorem 1.2/5.3 is unproved at $m=2$ | **narrowed** | The call to B.18 was outside its printed hypothesis, but the exact four-family estimate above proves $5H/16$ at $m=2$.  B.18 now assumes $m\geq2$ with no radius or headline-constant loss. |
| The current paper says $U\otimes U$ for a Bell pair | **rejected** | Both current occurrences and the pre-split parent already say $U\otimes\overline U$, consistently with $h\otimes I-I\otimes h^T$. |
| Proposition 5.4 suppresses stabilizer phases incorrectly | **confirmed, local** | The commutator is phase-independent, but the intermediate stabilizer equations require the lifts.  The proof now defines the commutator with $\widetilde W_\ell,\widetilde W_r$, records equality with the bare-Weyl commutator, and uses the lifts on the state. |
| The qubit specialization is already covered by the 2005 minimum-support criterion | **confirmed** | C804 had proved this reduction from Proposition 3.4 and C807 had audited it; C844 later compressed the concession.  The introduction and owning ledger now state the direct consequence explicitly. |
| Modern qubit LU literature is missing | **confirmed** | Claudet--Perdrix's complete graphical characterization and Burchardt--de Jong--Vandré's verification algorithm were absent.  Both are now cited beside Englbrecht--Kraus's complete qubit symmetry classification. |
| Tan's AME--QMDS and symmetry/transversal dictionary is undercredited | **confirmed** | The old sentence used Tan's Theorems 3.5/3.6 as if they belonged only to the four-qutrit computation.  The introduction now credits their general statements separately from Theorem 5.3. |
| The encoder result is framed too broadly as a new no-go | **confirmed** | The corollary is renamed “Factorwise transversal rigidity” and positioned as Cliffordness of every physical and logical factor in conversions between two class members; no new qualitative hierarchy obstruction is claimed. |
| “Quantitative counterpart” suggests a robust form of Theorem 1.1 | **confirmed** | The abstract now says “quantitative symmetry counterpart for one fixed state”; the introduction contrasts Proposition B.21's weaker two-state scale $q^{-(m+1)/2}$. |
| The atlas needs a stabilizer-specific contrast | **confirmed** | The theorem already had the correct hypothesis.  A new adjacent sentence cites Ramadas--Lakshminarayan's orthogonal-array criterion for infinitely many general AME LU classes. |
| The QMDS support distribution is presented as new | **rejected as a current defect** | Section 4 already calls it the Huber--Grassl Shor--Laflamme distribution and cites their Theorems 8 and 9; the atlas, holonomy, and gauge sequence remain the paper's structured use of that data. |
| The cleaning/Fourier chain is the strongest new part | **narrowed to an attribution boundary** | C835 already concedes the exact three-region obstruction and identifies the leakage estimate, Fourier rounding, and AME composition as paper-local.  C887 found no direct robust predecessor in a bounded primary-source search, but makes no exhaustive firstness claim and replaced “the new step” by neutral contribution wording. |

## Literature record

Ten primary sources support the dispositions above.  Two were already read at
`full text` depth in the owning audits; eight are `partial` at the exact
sections listed below.  Cache presence is not treated as read depth.

| Source | Cache key and SHA-256 | Read depth used here | Load-bearing locator |
|---|---|---|---|
| Van den Nest--Dehaene--De Moor | `arXiv:quant-ph/0411115`, `c0f8e192552369d5af9304ebf08995f59b6917e243a570f37ff1b29f3b4cb735` | `full text`, inherited and rechecked through C804 | Theorem 1, Lemmas 1--2, Corollary 1(iv) |
| Claudet--Perdrix | `arXiv:2409.20183`, `48bd8f73a887a8ef3c36f5310184169a9c2ce630c85b45d3774bfe03644a9475` | `partial`, arXiv v4; abstract, Theorems 32--33, conclusion | generalized local complementation completely characterizes graph/stabilizer LU equivalence |
| Burchardt--de Jong--Vandré | `arXiv:2410.03961`, `107a3548b8ed622181c7ee81dd1f19051d0e67bd6a72c6c9c59a36911a2cc984` | `partial`, arXiv v2; abstract, Theorem 10, Sections VI and concluding remarks | constructive LU-equivalence verification by modular linear systems |
| Englbrecht--Kraus | `arXiv:2001.07106`, `fecef9717dbf5807c3d6d7890c16c7bc2c89ac60c85003c14355929b1ffc1cac` | `partial`, inherited from C807; abstract, introduction, Theorems 2--3 and Corollaries 3.1--3.3 | complete qubit stabilizer local-symmetry characterization |
| Tan | `arXiv:2601.19677`, `460f398f1fe63aa347f2457e44c0fe12d1164bdc33a25ee3f44ce3805d4f48e6` | `partial`; Sections 3.1--3.3 and 5.2 | Theorems 3.5, 3.6, and 5.3 |
| Huber--Grassl | `arXiv:1907.07733`, `c4e5dfba9f8ccbb3f496c956c96cc83cc9bb2c117f23e0a05be639153d444e94` | `partial`, arXiv v2; Proposition 7 and Theorems 8--9 | AME--QMDS reversal and QMDS weight distributions |
| Ramadas--Lakshminarayan | `arXiv:2411.04096`, `a73e8c2c48c2d55f07b1e34bc75ba0d18c7115ec4e65d412605f52bf7430c647` | `partial`, arXiv v1; abstract, introduction, Theorem 1 and Corollary 1 | criterion for infinitely many LU classes of uniform/AME states |
| Pastawski--Yoshida | `arXiv:1408.1720`, `6eba050d7f767067ff16d7f4b22e9868bb91c6dc49844b1fec935c6dc24052bb` | `partial`, inherited from C835; introduction, Sections II.D--II.E, Lemmas 3--5 | exact cleanable-region Clifford obstruction |
| Bravyi--König | `arXiv:1206.1609`, `027fe684e2fa254e25dc11771e3a9064225e69989442ab54c58e3aa266ed9d93` | `full text`, inherited from C835 | nested-commutator localization and hierarchy mechanism |
| Jochym-O'Connor--Kubica--Yoder | `arXiv:1710.07256`, `a4adba8c4e92f8369bbb67a3134add9ff3418d7f3bd0839d2ed2fbdf73002933` | `partial`, inherited from C835; cleaning/scrubbing lemmas, Theorem 5 and discussion | disjointness hierarchy restrictions |

The current-source searches that promoted the two missing qubit papers were
`Claudet Perdrix generalized local complementation LU equivalence graph states
arXiv` and `Burchardt de Jong Vandré algorithm local unitary equivalence
stabilizer states arXiv`.  The bounded robust-predecessor screen used
`approximate transversal gates stabilizer code Clifford rounding Weyl Fourier`,
`robust transversal logical gates stabilizer codes approximate Clifford`,
`approximate local symmetries stabilizer states local Clifford robustness`, and
`quantitative Eastin Knill transversal gates approximate quantum codes`.
It promoted no direct analogue of the leakage--Fourier--AME chain, but was not
an exhaustive screened set and licenses no absence claim.  MathSciNet and
Google Scholar remain NOT COVERED; the prior C807 audit reached zbMATH Open.

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
