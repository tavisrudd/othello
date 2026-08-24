# C950 — Primary recovery-paper architecture

**Lane**: `complete-ports`

**Status**: COMPLETE; ARCHITECTURE, RESULT ORDER, SOURCE MAP, PAGE BUDGET, AND
C951/C952 ACCEPTANCE SURFACES FROZEN; MANUSCRIPT UNTOUCHED

## Objective

Define the paper that results from combining the verified single-coordinate
manuscript with C946--C948. This task changes no manuscript, Lean source,
registry, public mirror, or export. It fixes the dependency order and the
decisions that C951 and C952 must implement.

Working title:

> *Exact Transfer of Bounded Linear Recovery and Relative Weight Hierarchies*

The primary audience is coding theorists working on locality, cooperative
recovery, generalized weights, and concatenated codes. Matroid, reliability,
finite-geometry, and formal-verification material supports that route rather
than defining parallel routes through the paper.

## Terminology and notation

Use established terms: **recovery set**, **recovery structure**, **normalized
recovery equation**, **cooperative recovery**, **relative generalized Hamming
weight**, **relative dimension/length profile**, and **service-rate region**.
Use **repair** for the operational process or event.

For a target set $P$ and helper set $J=E\setminus P$, a full-row-rank generator
matrix $G=(G_P\mid G_J)$ determines

\[
 U_P=\operatorname{im}G_P,
 \qquad
 W_P=U_P\cap\operatorname{im}G_J,
\]

and the associated nested code pair

\[
 K_P=\ker G_J
 \subseteq
 D_P=\{x\in\mathbb F_q^J:G_Jx\in U_P\}.
\]

“Associated nested code pair” is descriptive linear algebra, not a proposed
term of art. Do not introduce an abbreviation for it. Say “a $t$-dimensional
subspace of linear combinations of the target coordinates” rather than
“target-message rank” in paper prose. “Nonconfinement threshold” is a literal
description of the displayed minimum cost, not a named invariant.

The paper must not use “port” as a coding-theory noun. Exact Lean declaration
names may retain `RepairPorts` in the verification appendix, where they are
identified as stable API names.

## Result order

The results are ordered by logical role, not by a quality score.

1. **Main theorem:** for $1\le t\le\dim W_P$, the minimum helper union for
   recovering a $t$-dimensional target subspace is
   $M_t(D_P,K_P)$; in sufficiently long concatenations satisfying the inherited
   outer hypotheses, every radius-$r$ system for every such target subspace is
   confined exactly when
   \[
   r<M_t(D_P,K_P)+d(I^\perp).
   \]
   Below the gate, zero-extension copies every normalized equation system and
   exact helper support.
2. **Objectwise mechanism:** for a fixed internally realizable demand subspace
   $A$, the exact eventual gate is
   $r<\rho_{P,A}(I)+d(I^\perp)$. The finite map-valued cost theorem explains the
   nonzero-functional and zero-functional branches from which the eventual
   formula follows.
3. **Global consequences:**
   \[
   d_t(C^\perp)-t=\min_{|P|=t}\kappa_C(P),
   \]
   the cooperative-locality bound is its min--max corollary, and MDS equality
   gives the complete confinement staircase and rank-one rigidity.
4. **Transfer consequences:** outer dual-distance growth gives blockwise exact
   transfer; positive outer rate and distance give positive-density realization
   in an asymptotically good fixed-alphabet family. Minimal-support domination
   then transfers the bounded service-rate region.
5. **Information-loss results:** the RGHW hierarchy does not determine bounded
   stochastic recovery; the associated nested pair does not determine the
   nonconfinement threshold when the target coefficient presentation changes;
   pointed-perspective and the stated conventional local statistics do not
   determine the two represented seed reliability laws.
6. **Principal application:** the $q$-ary simplex helper code gives
   \[
   M_t=\frac{q^m-q^{m-t}}{q-1},
   \qquad
   \Gamma_t=M_t+q^{m-1}+1,
   \]
   its survivor-set reliability is the projective-rank distribution, and the
   projective system is the unique rank-one extremizer at its helper budget.
7. **Supporting material:** MDS reconstruction from minimum-weight recovery
   equations, the sparse-paving pointed-perspective calculation needed for the
   represented seed pair, and the exact verification boundary.

## Section architecture and page budget

The target is 24--28 pages including references. Page counts are budgets, not
claims about the current rendered draft.

| Part | Pages | Contents |
|---|---:|---|
| Abstract and introduction | 2.5--3 | Object, main theorem, mechanism, nearest literature, proof route |
| 1. Recovery sets and equations | 2--2.5 | Exact supports, upward closure, normalized equations, operational reliability; one small example only if it shortens later explanations |
| 2. Relative weights of the associated pair | 3--3.5 | Exact sequence, RGHW identity, RDLP interpretation, MDS reconstruction |
| 3. Exact confinement under concatenation | 4--4.5 | Block-functional decomposition, finite objectwise cost, eventual theorem, singleton reduction |
| 4. Consequences and positive-density realization | 3.5--4 | Best-target GHW identity, cooperative min--max, MDS rigidity, global code bounds, service-rate region |
| 5. Reliability and separation | 3.5--4 | Bounded reliability, forced-padding RGHW separation, coefficient-presentation example, compact pointed-perspective seed theorem |
| 6. Projective simplex code | 2.5--3 | Weight hierarchy, confinement thresholds, reliability inversion and endpoints, uniqueness |
| 7. Verification and evidence boundary | 1.5--2 | Lean statement map, classical inputs, appendix computation and replay boundary |
| Conclusion | 0.5 | Exact transfer statement and proved limits; no programme advertising |
| References | 2--2.5 | Primary sources used in statements and positioning |

## Current-source disposition

| Current source | Decision | Destination |
|---|---|---|
| `complete_repair_ports.tex` abstract and Main Theorem | Rewrite | New abstract and page-1 theorem at the C948 level; keep the scalar result as the $|P|=t=1$ specialization |
| `complete_repair_ports.tex` MDS theorem | Retain, demote | Section 2 corollary/application after the RGHW identity |
| `sections/01-complete-ports.tex` | Rewrite | Section 1; retain support/upward-closure/coefficient/probability distinctions and remove branded phrasing |
| `sections/02-confinement-transfer.tex` | Rewrite and generalize | Section 3; preserve the weighted-functional proof mechanism and incorporate C946's objectwise theorem |
| `sections/03-positive-density.tex` | Rewrite and shorten | Section 4; state dual-distance, primal rate/distance, fixed alphabet, and densities separately |
| `sections/04-reliability-exit.tex` | Split | Retain the reliability definition and identities needed in Section 5; move bounded EXIT and deletion--contraction material out of the main route unless required by the seed separation |
| `sections/05-pointed-tutte.tex` | Compress | Retain only the pointed-perspective definition, sparse-paving calculation, matched-seed theorem, and the warning that matched inner invariants are not asserted for the concatenations |
| `sections/06-geometric-flagships.tex` | Move out of primary paper | Preserve as source for a separate geometry paper or appendix archive; replace the body section by the projective simplex code from C948 |
| `sections/07-verification-provenance.tex` | Rebuild | Section 7 plus appendix; update only after C951 fixes exact theorem correspondence |
| `sections/08-conclusion.tex` | Rewrite | Conclude with the associated-pair/RGHW identity, exact confinement, and the information lost by successive support/weight projections |
| `figures/transfer-spine.tex` | Replace or remove | Keep a figure only if it displays the associated pair, RGHW cost, confinement gate, and transferred consequences more quickly than the theorem statement |

The cubic--axis, quartic--nucleus, harmonic, Clebsch, secondary EXIT, and
extended deletion--contraction results are not deleted by this architecture.
They are moved outside the primary paper's dependency chain. No successor for a
geometry paper is allocated by C950.

## Theorem and label plan

Use semantic labels; preserve an existing label only when it still names the
same statement.

| Label | Statement | Logical source |
|---|---|---|
| `thm:relative-weight-recovery` | $\mu_t=M_t(D_P,K_P)$ and RDLP interpretation | C948, classical RGHW definition |
| `thm:finite-confinement-cost` | exact finite map-valued nonconfinement cost | C946 |
| `thm:ranked-confinement` | eventual dimension-by-dimension iff and exact transfer | C946 + C948 |
| `cor:singleton-confinement` | $r+1<z_x(I)$ | current theorem + C946 |
| `thm:best-target-ghw` | $d_t(C^\perp)-t=\min\kappa_C(P)$ | C948 |
| `cor:mds-confinement` | MDS staircase and rigidity | C948 + classical Singleton bounds |
| `cor:positive-density-recovery` | exact blockwise and asymptotically good realization | current paper + C948 hypotheses |
| `cor:service-rate-transfer` | equality of bounded service-rate regions from minimal supports | C948 |
| `thm:rghw-reliability-separation` | equal RGHWs, unequal bounded reliability via forced padding | C948 + represented seed theorem |
| `prop:coefficient-presentation` | same associated pair, different $d(I^\perp)$ and thresholds | C948 |
| `thm:matched-reliability-separation` | represented $[10,4,6]$ seed and positive-density separation | current `thm:asymptotic-separation` |
| `thm:projective-simplex-recovery` | exact weights, thresholds, reliability, and uniqueness | C948 |

The page-1 Main Theorem may collect the statements of
`thm:relative-weight-recovery` and `thm:ranked-confinement`, followed by the
positive-density corollary. It must not combine the seed separation,
projective example, and formal-verification claims into the same theorem.

## Proof dependency chain

\[
\begin{array}{c}
\text{restricted dual equations}\to
K_P\subseteq D_P\to
M_t(D_P,K_P)\\
\downarrow\\
\text{block-functional decomposition}\to
\rho_{P,A}+d(I^\perp)\to
M_t(D_P,K_P)+d(I^\perp)\\
\downarrow\\
\text{exact transfer}\to
\begin{cases}
\text{positive-density realization},\\
\text{service-rate and reliability transfer},\\
\text{represented-code separations}.
\end{cases}
\end{array}
\]

The best-target GHW theorem branches from the internal recovery-cost
interpretation. The projective simplex theorem instantiates both the relative
weights and reliability branch. The pointed-perspective seed theorem supplies
one separation and does not carry the main confinement proof.

## C951 acceptance surface

C951 must finish before prose reconstruction.

1. Freeze every theorem above with all domains, rank ranges, signs, helper-cost
   conventions, outer hypotheses, and finite/eventual quantifiers explicit.
2. Map each paper statement to an existing Lean declaration, a declaration to
   be added, a cited classical input, or an intentionally human-only theorem.
3. Read and follow `lean/AGENTS.md` before any Lean action; use only guarded
   entry points.
4. Reconcile the paper-facts registry and axiom registry. The current
   Lean/registry mismatch named by the user is a C951 blocker, not a prose issue.
5. Check statement adequacy field by field: target set, helper universe,
   represented generator, rank parameter, support union, normalization,
   confinement, coefficient equations, and positive-density hypotheses.
6. Keep computations and finite certificates out of every main-theorem logical
   dependency.
7. Produce a theorem/definition/import/axiom table that C952 can use without
   interpreting Lean names from scratch.

## C952 acceptance surface

1. Rebuild from the frozen section architecture rather than inserting C948 into
   the existing table of contents.
2. Keep the title, abstract, page-1 theorem, section openings, conclusion, and
   bibliography synchronized with the result order above.
3. Use only the terminology and notation fixed here; do not invent replacement
   nouns to preserve old sentences.
4. Give complete human proofs of the central statements. Imported results must
   be cited at the exact theorem or definition used.
5. Keep the matched-invariant claim attached to the inner seeds. Do not claim
   equality of full pointed-perspective polynomials after concatenation.
6. State positive-density hypotheses and density conventions literally:
   one fixed coordinate type has density $1/|E|$, $P$ has coordinate density
   $|P|/|E|$, and there is one target-set copy per block.
7. Define service-rate regions through inclusion-minimal supports or prove
   minimal-set domination when using upward-closed recovery sets.
8. Retain the projective formulas only with $m\ge2$ for the non-MDS claim and
   $m\ge3$ for a nonconstant-increment staircase.
9. Keep all subjective paper grading out of reviewer packets and reports.
   Reviewers return correctness findings, theorem ordering, evidence gaps, and
   required repairs only.
10. Validate the private manuscript without exporting, pushing, depositing, or
    changing the public repository.

## C953 cold-read neutrality

The aggregate readers receive the frozen PDF, theorem/claim map, and exact
trust boundary. They do not receive prior review verdicts, percentile reports,
venue comparisons, or overall-quality assessments. Their output is limited to:

- mathematical correctness and missing hypotheses;
- proof completeness and dependency failures;
- formal correspondence and axiom use;
- literature/priority evidence at the stated audit depth;
- computation and reproducibility boundaries;
- terminology, notation, and exposition defects; and
- factual ordering of the main theorem, corollaries, applications, and material
  that should move or be cut.

## Validation

- C948 proof-correctness cold read: passed after all findings were repaired.
- C948 priority audit: bounded `NONE-FOUND` for the combined theorem, with
  MathSciNet, Google Scholar, Crossref/arXiv indexing, and arXiv API limits
  stated literally.
- Current manuscript source inventory and theorem labels: inspected read-only.
- Manuscript, Lean sources, registries, mirrors, and exports: unchanged.

## TT and EJ closeout

TT checked the architecture against the proof dependency chain. Definitions of
the target-message space and associated nested code pair precede the RGHW
identity; that identity precedes confinement; exact transfer precedes the
positive-density, reliability, and service-rate corollaries. The finite and
eventual outer-code hypotheses remain distinct. Pointed-Tutte data enter only
the represented-seed comparison, and the formal-boundary task precedes prose
reconstruction.

EJ checked whether one additional result was needed to connect the listed
applications. No additional theorem is required: exact transfer of minimal
helper supports supplies both bounded reliability and the service-rate region,
while the projective family supplies the explicit non-MDS calculation. This
keeps those statements as corollaries and an application rather than adding a
second central object.

## Mystery ledger

### Settled

- The primary paper is a rebuild, not an insertion into the present draft.
- The RGHW/confinement theorem is the main result; MDS reconstruction is a
  supporting consequence.
- The projective simplex code is the sole non-MDS geometric body application.
- Pointed-Tutte material remains only where needed for the represented seed
  separation.
- Service-rate and bounded-rank reliability transfer are corollaries of exact
  support transfer, not new central objects.
- Cubic/quartic geometry and BGS packing lie outside the primary dependency
  chain.
- Cold reads will contain no subjective grading.

### Owned by successors

- C951: exact formal statement map, missing declarations, classical inputs, and
  the axiom-registry mismatch.
- C952: final prose, page count, figure decision, bibliography synchronization,
  and warning-free private build.
- C325: appendix-only executable evidence and independent replay.
- C953: aggregate independent correctness, formal, literature, computation,
  terminology, and rendered-PDF review plus authorized local export validation.
- Unallocated geometry successor: disposition of cubic--axis,
  quartic--nucleus/harmonic, and Clebsch material outside the primary paper.

No unresolved architecture choice remains in C950.

## Verdict

Proceed in the queue order C951, C952, C325, C953. C950 authorizes no
manuscript, Lean, registry, mirror, or public change.
