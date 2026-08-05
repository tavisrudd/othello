# Clebsch four-paper program

**Lane:** `clebsch`

**Date:** 2026-08-02

> **LIVE MAP ONLY.** This is the routing and state surface for the active
> four-paper program. Detailed live task internals belong in C-task cards;
> completed and superseded detail belongs in the archives linked below.
>
> **ROUTING AUTHORITY.** No dated planning note, fallback-paper verdict, task
> report, or archive overrides the order and boundaries stated here.

## Numbered series decision

The public series has exactly four numbered papers:

1. Paper I — `clebsch-rigidity`;
2. Paper II — `clebsch-factorization`;
3. Paper III — alias `passages`, rooted at `clebsch-passages`;
4. Paper IV — alias `q13-passant-code`, rooted at `q13-passant-code`.

Papers I--III have GitHub and DOI releases at versions 1 and 2. Those public
versions are immutable predecessors; later strengthening is by forward
version. Paper IV is the active new-paper build under C761.

`golden` is a source-development lane feeding a future forward version of
Paper III, not a fifth numbered paper. The Paper-I computational companion is
unnumbered and becomes a forward-pointing evidence companion once Paper IV is
public. The mega-paper remains an unpublished fallback only.

The numbered-paper streams are concurrent.  An explicit selector such as
`go clebsch paper I`, `go clebsch paper III`, or `go clebsch paper IV`
selects only that paper's stream; it does not pause, reorder, or absorb work
in the other papers.  An unqualified `go clebsch` with no carried task or
paper selection must ask which paper stream the user wants rather than
silently choosing among concurrent work.

### Deterministic Paper III route

`go clebsch paper III` means: take the first unfinished task in this exact
conflict-safe sequence:

1. C799 — freeze the shared aligned-design Lean API;
2. C815 — add four-shadow recognition Lean declarations without duplicating
   the aligned-design API;
3. C823 — add robustness, distance, moment, and C822 compression declarations
   on those two frozen APIs;
4. C800 — formalize the remaining operator identities and perform the single
   shared-source/manifest reconciliation after C799/C815/C823;
5. C816 — integrate the four-shadow characterization into the manuscript;
6. C824 — integrate robustness and the order-26 separator, then perform the
   final coordinated Paper III trust/release/synchronization pass.

Skip completed tasks, but do not bypass an unfinished predecessor.  This is
an execution serialization for shared Lean/manuscript/manifest ownership;
the underlying mathematics remains the two branches
`C809 -> C815 -> C816` and `C810/C812/C822 -> C823 -> C824`, both rooted in
C792/C799 and merged through C800.  No C832 router task is required: the live
handoff resolves the selector directly.  Paper I and Paper IV continue
concurrently under their own explicit selectors and task cards.

### Active C815 repair handoff

C815 is reopened under
`notes/2026-08-02-paper-iii-lean-audit-checklist.md`.  The Paper III replay
programs and their exact transitive-closure inventories are hardened and
committed: they no longer invoke Lean or Lake, require an explicit
`--source-only` or `--axiom-log` mode, pin their own bytes, and validate
main-versus-supplemental declaration ownership.

The proof authority `lean/RelativeConicArcs/FourShadowRecognition.lean` is
committed and green.  Its mixed-difference argument uses one monomial theorem,
a reducible twenty-term coefficient table, and a small label bridge; the
heartbeat and recursion overrides are gone, the twelve labelled cubic
identities are separate declarations, and the three native orientation checks
are replaced by one closed decidable classifier with symbolic projections.
The pentagon converse is now a genuine symbolic proof: three signs summing to
a sign have product the negative of that sum, and only six derived signs are
split, never the ten free edge signs.  The module elaborates without errors or
warnings, the focused gate builds and its `#print axioms` output matches the
tracked report, and the paper-local replay passes in both source-only and
axiom-log modes.  The single finite trust boundary is the declaration-local
axiom that compiled evaluation introduces for the classifier; the weighted
converse, pentagon gauge, and conference square do not depend on it.

Validation found and corrected a sign error: `shadowCoefficient012` computed
the determinant of the lower-left three-by-three block rather than the
`x₀x₁x₂` coefficient of the commutator-Pfaffian cubic it is documented to be,
so both orientation predicates named the opposite six-code fibre.  The
corrected classification agrees with an exact independent recomputation
committed as
`notes/2026-08-02-c815-normalized-signing-classification.py` and its output.

The 2026-08-04 gate-hardening round is reported in
`notes/2026-08-04-c815-paper-iii-gate-hardening-report.md`, which is the
current state map for Paper III's formal surface.  The three gates now audit
fifty, twenty-eight and nineteen terminals and none of them carries a
compiled-evaluation axiom: every terminal depends only on `propext`,
`Classical.choice` and `Quot.sound`, `native_decide` occurs nowhere in the
pinned closures, and all three replays refuse it;
the axiom reports and closure inventories are generated by committed tools from
a tracked build log rather than maintained by hand; and the source policy now
refuses every escape two cold referees could construct, including
`set_option debug.skipKernelTC`.  All six paper-local replays and the release
gate pass, the latter now replaying all three Lean gates.

The three manuscript corrections requested of the TeX owner are discharged:
`papers/clebsch-passages/sections/08-verification.tex` now records both Ramsey
bounds as kernel-checked while keeping distinctness, the seven-set extension
and label normalization as human steps, names three gates rather than one, and
needs no compiled-evaluation disclosure because no terminal carries such an
axiom.  The audit checklist
`notes/2026-08-02-paper-iii-lean-audit-checklist.md` is refreshed to that state
and carries a dated summary of what is still open.

What remains for C815 is therefore purely mathematical: gap classes B and C of
`notes/2026-08-03-c815-paper-iii-formalization-gap-inventory.md` — nine
manuscript clauses with no formal counterpart, and the six claims recorded as
strengths without matching statements.  The current work order is four-shadow
root normalization by switching for arbitrary scalar sign matrices together
with uniqueness of the conference switching class, since C815 owns those and
C823 inherits them; then the aligned-design strengths (general faithfulness
transport, the finite-set extension to a common seven-set, the explicit query
family, and the anchor step's distinctness obligation); then the rank-14
weighted Jacobian and gap class B.

The C815 working tree is clean.  `AlignedTwoGraph.lean`,
`PetersenHarmonicKernel.lean` and `Gates/ClebschPassages.lean` remain shared
paths; `ClebschGoldenConference.lean` and `ClebschTwoGraph.lean` are shared
with Paper I and the golden-operator lane and need explicit permission plus
widened validation before any edit.

C756 remains the independent high-upside research task for the all-\(k\)
conic-filling theorem. Paper IV's general passant-code definitions and
weight-eight method are reusable inputs to C756, but C761 does not own or
block that theorem.

## Program state

| surface | root | current state | owning task |
|---|---|---|---|
| Paper I — *Reconstructing the Clebsch code and its golden orientation from its deep-hole syndrome locus* | `papers/clebsch-rigidity/` | GitHub/DOI v1 and v2 released; existing gates are green, but C855 is required to formalize every paper/companion mathematical assertion in Lean and close the full referee-artifact standards debt before the next release is called theorem-complete | [C855](../clebsch-tasks/c855-paper-i-lean-referee-artifact-remediation.md) |
| Paper II — *Quadratic trade rigidity and cubic orientation in conic matching quotients* | `papers/clebsch-factorization/` | GitHub/DOI v1 and v2 released; the general Gorenstein mechanism is prior work, while the exact matching-orbit classification, sharp fixed-line carrier boundary, unique Chow point, and sheet-sign cubic survive; C856 closed the fixed-line inheritance, public-docstring, and verification-expectation gaps on every project-owned file, an independent 2026-08-03 review confirmed every C856 claim, and C860 has cleared the shared projective-cap closure — the game modules are out of the paper closures and the five residual geometry modules are documented — so the full transitive closure is at the referee standard | [C577](../clebsch-tasks/c577-factorization-paper.md) |
| Paper III (`passages`) — *Golden descent and operator realizations of the Clebsch cubic* | `papers/clebsch-passages/` | GitHub/DOI v1 and v2 released unchanged; C792's B-plus integration and C799's normalized aligned-design API are complete; C815's three gates are green with no compiled-evaluation axiom at any terminal and its remaining work is the unformalized manuscript mathematics of gap classes B and C before C823 | [C815](../clebsch-tasks/c815-four-shadow-lean-formalization.md) |
| Paper IV — *Minimum-word reconstruction of \(\operatorname{PG}(2,13)\) from a binary conic code* | `papers/q13-passant-code/` | C831/C832 structural version complete; a manuscript-only standalone pre-release was published 2026-08-03 at DOI `10.5281/zenodo.21783971`, with the Lean companion excluded and due as a forward version; C834 must still complete the proof-producing formal closure and then C857 the exhaustive Lean standards checklist before the full release | [C834](../clebsch-tasks/c834-paper-iv-full-lean-release-closure.md), then [C857](../clebsch-tasks/c857-paper-iv-lean-standards-closure.md) |
| 37-page mega-paper | `papers/clebsch-code/` | preserved unchanged as fallback only | C552 if explicitly reactivated |

C703 records the title-page identity of the released I--III trilogy stage:
*The Clebsch cubic: recovering, orienting, and realizing* and a restrained
opening image, while their canonical titles, logical independence, and
paper-owned proof surfaces remain unchanged. It is historical release context,
not the current series count: Paper IV is now the fourth numbered paper. Full report:
[`../2026-07-30-c703-clebsch-trilogy-identity.md`](../2026-07-30-c703-clebsch-trilogy-identity.md).

C704 is complete with a positive functorial bridge.  The six outer
conjugates of C682's degree-ten middle-exterior operator are the signed
Joubert coordinates; they land on the Segre cubic and centered squaring is
the Segre--Igusa polar map.  The five-syntheme/Clebsch formula completes
the intrinsic commuting diagram.  The same conference operator gives the
literal Cartan restriction
\(\operatorname{Pf}[D_x,C]=4Z_T(x)\), whose square gives
\(\det[D_x,C]=16Z_T(x)^2\); hence the Segre coordinate, restricted branch
sextic, and Igusa polar coordinate are Pfaffian, determinant, and
centered-determinant shadows of one return.  The cross-golden block and
its adjugate further give a \(3\times3\) linear--quadratic matrix
factorization whose two kernel incidences are the golden-conjugate small
resolutions of the six-node cubic.  Its two conjugate rank-one Ulrich/MCM
sheaves descend to a rational rank-two MCM object carrying \(J^2=5\), so
the paired-tower descent persists in the cubic's singularity category.
Each small resolution is a \(\mathbf P^1\)-bundle over \(\mathbf P^2\);
smooth hyperplane sections are six-point blow-ups, and the two conjugate
blowdowns give the determinantal double-six.  Only its marked comparison
with C695 remains.  Later balanced slices stop at the
missing-support-lattice obstruction in the bounded census through degree
\(50\), while binary tetrahedral and octahedral sisters pass only their
first exact feasibility gates.  No split paper is reopened.  Full report:
[`../2026-07-30-c704-functorial-operator-shadows.md`](../2026-07-30-c704-functorial-operator-shadows.md).
An exhaustive, dependency-gated follow-up portfolio is staged at
[`../2026-07-30-c704-follow-up-mining-plan.md`](../2026-07-30-c704-follow-up-mining-plan.md).
No successor C-IDs are allocated; the recommended first tranche is the
adjugate-polar and marked-double-six packages as two separate future
Clebsch items.  Each promoted package is a no-early-bail exploration with
distinct `ej1`, `tt1`, `ej2`, and `tt2` passes before closeout.  Negative
outcomes are first-class mining objects and require a structural
obstruction theorem plus their nearest positive locus and adjacent crown.
C705 has completed the first tranche's adjugate-polar package under those
rules.  Its Coble conormal scalar is lifted exactly to characteristic zero:
in determinant-valued normalization the inverse-polar scalar is the source
Hessian determinant.  Its common affine-\(E_8\) parent is also exact.
A genuine Lie-\(E_8\) ambient Coble route is feasible.  The frozen
Burkhardt branch sextic has exact Galois group \(S_6\), so its one-point
Vinberg marking first exists over degree \(6\), while the ordered Joubert
marking lives on the degree-\(720\) splitting torsor.  Over the one-point
field the remaining five points have full \(S_5\) monodromy, which closes
intrinsic ordered recovery negatively; full level-\(2\) marking is the
exact repair.  That repair is now computed on all \(720\) sheets, and the
Vinberg principal-Pfaffian cubic is identified with the frozen Jacobian
Coble orbit by the Rains--Sam inverse theorem and its kernel-reconstruction
mechanism.  Exact reports:
`notes/2026-07-30-c705-burkhardt-e8-marking.md` and
`notes/2026-07-30-c705-lie-e8-completion.md`.  The
marked-double-six package remains unallocated pending an explicit
promotion decision.

C707 is complete with a positive operational verdict.  The two golden
eigenspaces are Naimark-complementary \((6,3)\) real ETFs and minimally
informationally complete real-qutrit POVMs, but are neither complex-qutrit
informationally complete nor SICs.  In the common six-path dilation the
cross-golden block is a postselected transfer Kraus operator, and its
antisymmetric three-copy success probability is exactly \(Z_T^2/500\).
Thus \(A=dZ\) is amplitude response, \(W\) is centered success-probability
contrast, and inverse polarity recovers the projective signed amplitudes
off \(e_5=0\).  Signed-moment cancellation from \(C^2=5I\) gives the sharp
physical bound \(|Z_T|\le8\), with maximum success \(16/125\) exactly on
the twenty balanced \(3+3\) phase vertices.  At every optimum the squared
singular spectrum is \(\{4/5,4/5,1/5\}\), and the three-filter protocol is
query-optimal in the coherent black-box model.  The twenty controls are
the oriented lifts of the ten Segre nodes and maximize all six protocols
simultaneously, but all optimal probability contrasts vanish: \(W=e_5=0\).
On this optimal middle layer the signed cubic map is the exceptional outer
transform: it preserves complements, exchanges intersection sizes one and
two, and realizes the two orthogonal five-dimensional Johnson constituents.
It is cubic in both directions and correlation-immune through order two.
At balanced controls it is also a lossless three-fermion interferometer and
a signed \(K_{3,3}\) Majorana family with energies \(\{2,4,4\}\) and
Pfaffian \(\pm32\).  A follow-up physics novelty audit identifies the Segre
identities as the six-Weyl \(U(1)\) anomaly equations.  The 44 nonbalanced
real phase masks have zero amplitude and the 20 balanced masks give
vectorlike nodes, whereas the admissible filter
\((-3,-2,-1,0,1,3)/3\) produces the primitive chiral anomaly-free vector
\((11,-10,-8,5,4,-2)\) projectively.  The ambient Segre/outer geometry and
anomaly variety are prior art; the exact real-golden
Slater/Majorana/outer-transform synthesis was not located in the bounded
sweep.
Full report:
`notes/2026-07-31-c707-golden-etf-quantum-measurements.md`.
Novelty and directions audit:
`notes/2026-07-31-c707-physics-novelty-and-directions-audit.md`.

By explicit paper-ownership decision on 2026-07-31, the complete C704--C710
post-700 development is assigned to the new `golden` lane and its standalone
*Golden conference operator and its shadow sisters* paper.  Review-facing
Paper III remains unchanged and ends before this material; the Golden lane
may cite it but may not edit, extract from, or reorganize it.  Golden entry
handoff: `notes/handoffs/2026-07-31-golden-operator-paper.md`.

C708 is complete.  The Segre--Igusa mixed differential realizes the
exceptional outer exchange between C706's synthematic-total Clifford-chart
action and the ordinary conference-axis action: it transports the two
classes of \(S_5\) in \(S_6\), rather than directly identifying their
elements.  Its frozen finite \(W_{10}\) exchange has order \(8\), so the
operator alone selects no involutory polarity; all \(36\) inner
normalizations remain, and the conference marking cuts them to the known
axis-indexed six-pack.  They form one twisted-conjugacy orbit with
stabilizer \(F_{20}\), explaining both \(36=720/20\) and \(6=120/20\);
the golden polarity and its indexed axis have the same stabilizer, so the
two golden six-sets are canonically \(S_5/F_{20}\).
The internal \(D_{10}\subset F_{20}\) orbit fusion
\((5+5+5,5+5)\to(5+10,10)\) is the finite-incidence form of C706's
\(A_5\subset S_5\) orientation-phase boundary.
Complete \(\mathbf F_2,\mathbf F_3,\mathbf F_5\)
incidence-code tables show that the doily ranks do not explain C705's bad
primes: \(2\) has only an incidence overlap, \(3\) is the
scalar-\(6\)/compound boundary, and \(5\) belongs to the golden sign lift.
The sole CSS output is the standard binary \([[15,5,3]]_2\) code.  Full
report: `notes/2026-07-30-c708-doily-codes-and-outer-exchange.md`.

C709 is complete with a split verdict.  The conference signing survives
diagonal Majorana gauge as nontrivial \(\mathbf Z/2\) cycle flux on \(K_6\),
but it is none of the sixteen Pauli quadratic refinements and supplies no
spin structure without extra surface-embedding data.  Total-order
antisymmetrization is noncanonical and gives three spectral classes.  The
canonical positive replacement is the chiral free-fermion family
\(A_C(x)=[D_x,C]\): it anticommutes with \(C\), exchanges the two golden
three-spaces, and satisfies
\(\operatorname{Pf}A_C(x)=4Z_C(x)\) and
\(\det A_C(x)=16Z_C(x)^2\).  Hence the Joubert cubic is exactly its
zero-mode and fermion-parity wall; its six nodes are precisely the rank-two
cross-golden dimers, each leaving four Majorana zero modes.  Full report:
`notes/2026-07-30-c709-majorana-k6-lift.md`; complete human proof companion:
`notes/2026-07-31-c709-majorana-k6-human-proofs.md`.

C710 is complete with a split verdict.  The McKay affine-Cartan quotient
and Hamming Construction-A \(E_8\) are explicitly isometric, including the
affine root determined by the \(2.A_5\) dimension vector.  No simultaneous
Clebsch marking exists: all \(180\) two-coordinate \(R_{10}\) minors miss
\(H_8\), the ten-node module has no equivariant rank-eight carrier under
\(S_6,S_5\), or \(A_5\), and \(Q_{10}\) contains no unmarked \(E_8\) root
subsystem.  The exact positive replacement is
\(L_{R_{10}}\oplus L_{R_{10}}^*\cong II_{10,10}\), where the exceptional
isodualities exchange maximal isotropic halves; self-adjointness recovers
exactly the \(36\) involutory polarities with \((5,5)\) graph eigenspaces.
Full report:
`notes/2026-07-30-c710-e8-hamming-marking.md`.

C711 is complete.  Seven manuscript-ready arguments remove certificate
dependence from the sub-700 Paper III inputs.  The golden Gram tight-frame
identity proves the conference square; triangle holonomy and pair balance
give the normalized augmentation cubic and its enumeration-free converse;
the middle-exterior square and exact diagonal follow from the two Hodge signs,
two dihedral minors, and complementation; parity reconstructs the distinguished
Johnson support lattice; and one Fischer eigenvector norm derives the exact
degree-ten return scalar.  Restriction of scalars gives the rational paired-
tower descent and its index-four integral comparison.  The C680 normalization,
bad-prime boundary, claim map, and formalization-ready C712 interface are
frozen.  The closeout further shows that, after the expected duality and
orientation choices, the full middle-exterior return reconstructs the
conference operator through the faithful rational exterior cube; consequently
its family-preserving projective stabilizer and line stabilizer are exactly
\(A_5\) and \(S_5\).  Hodge complementation closes the dual-family half: the
full line normalizer is \(S_5\times C_2\), and the exact stabilizer is the
diagonal \(S_5\) coupling outer orientation with complement duality.  Finally,
\((*,K/5)\) generates the split quaternion algebra
\((-1,5)\cong M_2(\mathbf Q)\), so the \(10+10\) golden split is Morita
multiplicity and Hodge complementation makes golden conjugation inner.  Its
normalized and primitive-return orders have exact indices \(20\) and \(500\)
in \(M_2(\mathbf Z)\); adjoining the integral golden coordinate leaves index
\(5\).  The staircase \(500\to20\to5\to1\) separates raw-return scaling,
conductor two, golden ramification, and maximal saturation, and excludes prime
\(3\) from the middle-exterior quaternion layer.  The residual index-\(5\)
order is exactly the Iwahori preserving the unique ramified golden eigenline,
with quotient the opposite-root direction.  The rational Morita factor is
\(\mathbf1\oplus\mathbf4\oplus\mathbf5\), exactly the module on the ten
complementary support pairs; only its three irreducible scalars and the two
Iwahori endpoints remain optional integral choices.  The latter form an
index-five lattice edge: the explicit normalizer \(w\), satisfying \(w^2=5I\),
exchanges its endpoints, so choosing one is precisely an orientation choice.
Point--pair incidence further gives canonical projectors onto the
\(1,4,5\) Morita channels; their denominators locate prime \(3\) in the
icosahedral integral splitting rather than the quaternion order.
Projective incidence proves that the exterior-cube kernel over every field is
exactly \(\mu_3(F)\); over \(\mathbf Q\) it is trivial, while characteristic
\(3\) requires distinguishing field points from the nonreduced group scheme.
Under the classical normalized transvectant and Bombieri--Fischer form, the
raw degree-ten scalar reduces from \(211625906798592000\) to \(64/1575\);
the intrinsic golden factor \(st^6\) is unchanged.
Full report:
`notes/2026-07-31-c711-paper-iii-sub700-human-proofs.md`.

C712 is complete.  The paper-oriented conference, triangle, two-graph,
augmentation, middle-exterior, support-recovery, and golden-descent interfaces
are formalized in Lean.  The serialized gate, exact twenty-five-declaration
axiom report, twelve-file hash manifest, paper-local replay, and complete Paper
III evidence/PDF gate are green.  Abstract classification, atom recovery,
exterior-cube faithfulness, binary transvectants, and optional quaternion-order
refinements remain explicit human-proof boundaries retained by C680.
Full report: `notes/2026-07-31-c712-paper-iii-sub700-lean.md`.

## Active and queued task cards

| task | state | next gate |
|---|---|---|
| [C855 — Paper I Lean referee-artifact standards remediation](../clebsch-tasks/c855-paper-i-lean-referee-artifact-remediation.md) | active; the six-node Hassett--Tschinkel closure is landed end to end and published downstream — base library, resealed q11 package, semantic verification filenames at zero exporter findings, rebuilt PDFs, and a standalone mirror reproducing the authority's exact release identity | continue the remaining remediation sections: semantic Lean API renames, docstring adjudication across the full closure, generated-source provenance, the distribution-boundary decision, and the independent closeout |
| [C792 — Paper III exchange-rigidity integration](../clebsch-tasks/c792-paper-iii-exchange-rigidity-integration.md) | complete; repaired B-plus manuscript, final independent acceptance 96/100, aggregate gates, and standalone synchronization closed | none; C815 is the current Paper III route task |
| [C799 — Paper III aligned-design Lean closure](../clebsch-tasks/c799-paper-iii-aligned-design-lean-closure.md) | complete at the normalized-core boundary; normalized cut classifier, symbolic third-point elimination, conditional overlap consistency, query-polynomial identity, determinant/switching transport, formal audits, and paper gate green | Ramsey existence, arbitrary finite-set normalization, and query-family cardinality remain human inputs; shared `AlignedTwoGraph` API is available to C815 and C823 |
| [C800 — Paper III operator and formal-release closure](../clebsch-tasks/c800-paper-iii-operator-formal-release-closure.md) | fourth Paper III route task; wait for C799/C815/C823 source freezes | formalize retained exchange and determinant identities, reconcile all Paper III formal maps onto one source closure, regenerate audits, and replay both gates |
| [C809 — four-shadow characterization](../clebsch-tasks/c809-four-shadow-characterization.md) | complete; positive math-only freeze; no paper promotion | none; nonzero triangle--Pfaffian proportionality characterizes the sign conference class, the two orientations are projectively isolated, and any manuscript/novelty integration requires a separately allocated follow-up |
| [C815 — four-shadow Lean formalization](../clebsch-tasks/c815-four-shadow-lean-formalization.md) | reopened; all three gates, their axiom reports, manifests, and every paper-local replay are green with no compiled-evaluation axiom at any terminal, and the documentation, gate-replay, and manuscript-correction obligations are closed | formalize four-shadow root normalization by switching and uniqueness of the conference switching class, then the aligned-design strengths, the rank-14 weighted Jacobian, and gap class B, then run the closeout before handing the API to C823 |
| [C816 — Paper III four-shadow integration](../clebsch-tasks/c816-paper-iii-four-shadow-integration.md) | fifth Paper III route task; begin after C800 reconciliation; manuscript promotion authorized | complete the full precedence audit, integrate the characterization and exact weighted boundary, refresh trust/release surfaces, then run Milnor--Serre, red-team, PDF inspection, and a fresh context-free cold-read regrade |
| [C810 — aligned-certificate distance](../clebsch-tasks/c810-aligned-certificate-distance.md) | complete; exact seven-point distance two and correction radius zero; no paper promotion | none; the all-even spectrum follows from edge-toggle parity, and the conference-only multi-class question is outside the triggered cheap-stop boundary |
| [C811 — quadratic-twist specialization](../clebsch-tasks/c811-quadratic-twist-specialization.md) | queued; math only; paper promotion excluded | stress-test the fibre-recovery claim and quickly delimit standard Kummer precedence before seeking a sharper geometric lemma |
| [C812 — conference cut separation](../clebsch-tasks/c812-conference-cut-separation.md) | complete; the scalar third cut moment separates all four order-26 classes; no paper promotion | none; the triple profile certifies the four values, the full histogram is unnecessary, and quotient certificate distance remains a separate alignment problem |
| [C822 — conference moment human compression](../clebsch-tasks/c822-conference-moment-human-compression.md) | complete; conference contraction forces the two-pivot plane and four direct construction counts recover the separator; math only | none; coherent pentads and spanning aligned hexads reduce further to intercalates in the Latin classes and Pasches in the Steiner classes |
| [C823 — aligned-certificate robustness Lean](../clebsch-tasks/c823-aligned-certificate-robustness-lean.md) | next Paper III route task; C799/C815 APIs and C822 human compression frozen | formalize distance polarization, parity, bowtie equality, conference balance, moment recurrence, and C822's final compression in the shared C799/C815 API |
| [C824 — Paper III aligned-certificate upgrades](../clebsch-tasks/c824-paper-iii-aligned-certificate-upgrades.md) | sixth and final current Paper III route task; begin after C816; manuscript promotion authorized | select the smallest A/B architecture, integrate the robustness/order-26 results, perform final C800/C816 trust reconciliation, then run exposition, red-team, PDF, release, synchronization, and fresh cold-read gates |
| [C813 — harmonic restriction generalization](../clebsch-tasks/c813-harmonic-restriction-generalization.md) | queued; math only; paper promotion excluded | compute bounded $A_5$-branching, Petersen-channel eigenvalues, and exact restriction scalars before pursuing a family or isolation theorem |
| [C862 — Paper III ceiling and theorem-upgrade research](../clebsch-tasks/c862-paper-iii-ceiling-upgrade-research.md) | active advisory research; report and spectral-descent/recognition theorem packet delivered; no manuscript edit and no change to the deterministic Paper III route | test characteristic three as the cheap gate for comparison with the split Mukai--Umemura model over $\mathbf Z[1/10]$; keep the theorem packet available to C816 and keep C862 open |
| [C863 — Series significance exposition](../clebsch-tasks/c863-series-significance-exposition.md) | complete 2026-08-03; genre-appropriate significance is explicit in Papers I, II, and IV, and Paper-III candidate language is routed into the still-open C862 report without editing that manuscript | none; Paper IV's pre-existing evidence-manifest drift remains with its formal-release owners |
| [C802 — Paper I series-framing memo review](../clebsch-tasks/c802-paper-i-series-framing-memo-review.md) | complete; red-team and second cold-read `GO` delivered to C762 | none |
| [C713 — Paper I proof architecture](../clebsch-tasks/c713-paper-i-proof-architecture.md) | complete; causal proof order, structural determinantal six-node proof, and synchronized authoritative/standalone gates green | none |
| [C714 — Paper I companion structuralization](../clebsch-tasks/c714-paper-i-companion-structuralization.md) | complete; C721--C726 integrated and synchronized release gates green | none |
| [C751 — Paper I proof-spine tightening](../clebsch-tasks/c751-paper-i-proof-spine-tightening.md) | complete; pentagon-first hybrid won the blind A/B 96--91, final referee GO, both release roots green | none |
| [C752 — Paper I Lean spine audit](../clebsch-tasks/c752-paper-i-lean-spine-audit.md) | complete; transitive prose/definition audit and exact C753 packet interfaces frozen | none |
| [C753 — Paper I Lean spine closure](../clebsch-tasks/c753-paper-i-lean-spine-closure.md) | complete; R1--R4, O1--O8, manifests, and all release replays green | none |
| [C761 — Paper IV q13 passant code](../clebsch-tasks/c761-paper-iv-q13-passant-code.md) | active; structural manuscript and local release surfaces green, but public release is blocked on C834 full-Lean closure | after C834, pin the public package, run isolated replays, insert immutable locators, and seek explicit publication authority |
| [C817 — Paper IV structural mathematics upgrade](../clebsch-tasks/c817-paper-iv-structural-math-upgrade.md) | complete 2026-08-02; all six subitems positive and frozen; bounded novelty boundary and ranked integration memo complete; no manuscript change made | none; any manuscript selection, claim-specific novelty closure, formalization, or integration requires later user discussion and authorization |
| [C831 — Paper IV structural version](../clebsch-tasks/c831-paper-iv-structural-version.md) | complete 2026-08-02; longer title, full structural integration, evidence/trust refresh, Milnor--Serre tightening, eleven-page visual gate, and adversarial read green | none; green version returned to C761 |
| [C832 — Paper IV structural theorem Lean](../clebsch-tasks/c832-paper-iv-structural-lean.md) | complete 2026-08-02 at the declared partial-formal boundary; shared mechanisms, concrete q13 gates, aggregate terminals, and axiom audit green | none; frozen formal surface returned to C831/C761 |
| [C834 — Paper IV full Lean release closure](../clebsch-tasks/c834-paper-iv-full-lean-release-closure.md) | active; the shared library and the paper package's minimum-word layer are closed; the association-transport packet, the hidden-field cubic, and now the shared equivariance layer are rewritten for kernel reduction and independently confirmed, but not yet elaborated, because another lane still holds the build-owner lock; the ambient-plane route is confirmed symbolic | in the next build window elaborate the association-transport rewrite, run the two cost probes, then elaborate the equivariance layer and rerun the axiom audit; afterwards close the remaining native decisions of the paper package and reverse the pre-release accommodations listed in the task card |
| [C857 — Paper IV Lean standards closure](../clebsch-tasks/c857-paper-iv-lean-standards-closure.md) | queued after C834; exhaustive audit checklist allocated before C761 release | consume C834's formal API, close every trust, statement, transcript, allowlist, documentation, citation, provenance, and clean-checkout gap, then run the rejecting release verifier |
| [C577 — Paper II](../clebsch-tasks/c577-factorization-paper.md) | active; the human proof, Milnor--Serre copy edit, and C856's project-owned standards closure are complete, and the authoritative aggregate is green | repackage and synchronize the standalone release under the Paper-II workflow; the shared projective-cap cleanup (C860) is complete, so no closure debt gates publication |
| [C856 — Paper II Lean standards closure](../clebsch-tasks/c856-paper-ii-lean-standards-closure.md) | complete 2026-08-02; the fixed-line premises are derived rather than assumed, every scholarly-public declaration in the fifty-six-file project-owned closure is documented, a stale expected statement count now fails verification, and the four gates and full release aggregate are green | none; the C860 shared-cap debt is cleared and C577 owns repackaging |
| [C860 — shared projective-cap closure remediation](../clebsch-tasks/c860-projective-base-dependency-inversion.md) | complete 2026-08-03; cap-game modules out of the paper closures, five residual geometry modules documented, four Paper II gates green; full base-module inversion explicitly not performed | none; the stale AME/LU release manifest predating this work awaits an `ame-lu` lane decision |
| [C746 — Paper II projective--trade reduction](../clebsch-tasks/c746-paper-ii-projective-trade-reduction.md) | complete; human proof 1/4 | sheet-sign kernel reduced invariantly to the quadratic pullback obstruction |
| [C747 — Paper II socle and first wall](../clebsch-tasks/c747-paper-ii-socle-wall-proof.md) | complete; human proof 2/4 and independent modular read green under C748 | none |
| [C748 — Paper II Serre proof integration](../clebsch-tasks/c748-paper-ii-serre-proof-integration.md) | complete; parity-specific proof has independent modular and context-free `GO` verdicts; human proof 3/4 | none; C749 owns final adversarial freeze |
| [C749 — Paper II adversarial human closure](../clebsch-tasks/c749-paper-ii-adversarial-human-proof.md) | complete; human proof 4/4, adversarial MAJOR repaired through MINOR to a fresh final **GO**, theorem surface frozen | none; C577 owns repackaging |
| [C750 — Paper II structural Lean](../clebsch-tasks/c750-paper-ii-structural-lean.md) | complete; 22-terminal structural gate, axiom audit, trust map, evidence fingerprint, and authoritative aggregate green | none |
| [C797 — Paper II trade-only carrier reconstruction](../clebsch-tasks/c797-trade-only-carrier-reconstruction.md) | complete; carrier-free theorem fails sharply at \(q=7\) | none; seven \(S_4\)-fixed affine placements share the trade and only one is a matching orbit |
| [C798 — Paper II fixed-line Chow rigidity](../clebsch-tasks/c798-fixed-line-chow-rigidity.md) | complete; structural priority-judo theorem integrated and authoritative gate green | none; \(q-2\) nonmatching exact-trade orbits and the unique matching Chow point are proved without an orbit table |
| [C801 — Paper II fixed-line Lean update](../clebsch-tasks/c801-paper-ii-fixed-line-lean.md) | complete; table-free radial inheritance, sheet-sign annihilator, and \(q-2\) count are kernel-checked | none; the unique Chow point remains the human finite-group/factorization boundary |
| [C803 — Paper II fixed-line literature audit](../clebsch-tasks/c803-paper-ii-fixed-line-literature-audit.md) | complete; exceptional one-factorizations attributed, C494 boundary recorded, exposition and release gates green | none; C801 owns the Lean update |
| [C762 — Paper I forward exposition](../clebsch-tasks/c762-paper-i-forward-exposition.md) | complete; structural q11 boundary, O1--O8 alignment, 22+12-page PDFs, manifests, and standalone release green | none |
| [C763 — Paper III Golden consolidation](../clebsch-tasks/c763-paper-iii-golden-consolidation.md) | complete; selective source--operator--cubics--harmonic chain, formal bridge, cold reads, and synchronized release gates green | none |
| [C764 — Paper III “why determinant” boundary](../clebsch-tasks/c764-paper-iii-why-determinant.md) | complete; determinant-line explanation and explicit permanent gauge counterexample integrated; isolated authoritative and synchronized standalone release aggregates green | none; keep the physical companion outside Paper III until it has a stable public locator |
| [C744 — Paper III proof-spine structuralization](../clebsch-tasks/c744-paper-iii-proof-spine-structuralization.md) | complete; pinching, Gram, torsor, harmonic-scalar, A/B 96/100, EJ/EJ2, and synchronized release gates green | none |
| [C745 — Paper III current-theorem Lean formalization](../clebsch-tasks/c745-paper-iii-current-lean-formalization.md) | complete; Paper-III-only structural gate, 34-declaration audit, five-row honest boundary, clean replay, and standalone synchronization green | none; C287 owns later reviewed extraction/tagging only |
| [C733 — Paper III canonical orientation bridge](../clebsch-tasks/c733-paper-iii-canonical-orientation-bridge.md) | complete; strongest theorem is explicitly relative to the full marked datum, with ambiguity ledger and final `GO` | none; C763 owns any forward integration |
| [C730 — Paper III orientation source](../clebsch-tasks/c730-paper-iii-orientation-source-theorem.md) | complete; normalized-cover theorem, involution ledger, harmonic comparison, and integral boundary frozen | none; C763 owns forward manuscript integration |
| [C682 — Hitchin--Clebsch exploration](../clebsch-tasks/c682-hitchin-structural-exploration.md) | active; McKay corner plus degree-ten and all-degree golden/\(E_8\) Weyl descents complete | user decision: close exploration or select the optional preprojective successor |
| [C705 — adjugate Segre--Igusa polar](../clebsch-tasks/c705-adjugate-segre-igusa-polar.md) | complete; adjugate factorization, global \(E_6\) first-normal jet, characteristic-zero Coble Hessian normalization, affine-\(E_8\) mixed potential, Lie-\(E_8\) Pfaffian parent, frozen orbit mechanism, and all \(720\) ordered sheets proved/computed | none; the residual \(S_5\)-torsor records unavoidable noncanonicity, not unfinished work |
| [C706 — equivariant Clebsch--Clifford lift](../clebsch-tasks/c706-equivariant-clebsch-clifford-lift.md) | complete; full \(S_6\) Clifford extension nonsplit, conference \(S_5\) split with two classes, golden \(A_5\) split with four classes, distinguished conference twist nonzero and nonextendable \(A_5\to S_5\), scalar multiplier trivial; six conjugate local \(S_5\) charts meet pairwise in \(S_4\) but do not glue | C708 tests the outer exchange between the chart \(1+5\) action and the transitive axis/polarity six-action; no direct bijection exists |
| [C707 — golden ETF measurements](../clebsch-tasks/c707-golden-etf-quantum-measurements.md) | complete; cubic outer phase code, lossless three-fermion scattering, signed \(K_{3,3}\) Majorana optimum, and anomaly-charge transducer proved; physics novelty audit recorded | none |
| [C708 — doily incidence codes](../clebsch-tasks/c708-doily-incidence-codes-and-bad-primes.md) | complete; outer exchange positive at representation level, no canonical involutory polarity, exact code tables closed | none |
| [C709 — six-Majorana lift](../clebsch-tasks/c709-clebsch-majorana-k6-lift.md) | complete; two-graph flux and chiral commutator family survive, quadratic refinement and intrinsic spin structure do not | none |
| [C710 — \(E_8\)--Hamming marking](../clebsch-tasks/c710-e8-hamming-code-marking.md) | complete; bare \(E_8\) isometry positive, simultaneous Clebsch marking obstructed, hyperbolic \(II_{10,10}\) repair exact | none |
| [C711 — Paper III sub-700 human proofs](../clebsch-tasks/c711-paper-iii-sub700-human-proofs.md) | complete; seven certificate-independent proofs, per-proof Tao checks, and frozen interfaces | none |
| [C756 — all-\(k\) conic-filling classification](../clebsch-tasks/c756-all-k-conic-filling.md) | active; full-theorem odds 10--15%, the complete saturated classification a separate publishable crown; coherent systems are exactly induced crown graphs in the Paley graph of order \(q^2\), the branch is unconditionally empty for every odd prime power \(q\le151\) in both residue classes, and the twenty-sixth pass closes Baer-subline containment outright — no coherent system lies in any Baer subline unless \(q=5\), for every odd prime power, by an exact coboundary identity using only the independence half of the crown | the two remaining ranked gates are (a) the Baer-subline stability statement, which now suffices **alone** to close the saturated-internal branch, and (b) a joint two-coordinate invariant for the direction matchings, since the twenty-sixth pass computed them algebraically and proved the one-parameter route bottoms out at the direction count \((q+1)/2\).  Also open: a Rédei-type direction theorem serving both branches, and Blokhuis' Rédei polynomial at half size.  Density arguments cannot work, since Paley sits at edge density exactly \(1/2\).  The twenty-seventh pass found the object coupling both halves — the cross-ratio of the two conjugate point-pairs, which makes (B) invariant relative to (A) and localizes the branch's non-invariance entirely in (A) — but its exact count runs one short and forces collisions rather than a contradiction, so that route is closed as a finisher.  The twenty-eighth pass splits the branch by residue class: discarding (A) and keeping only chord externality makes a coherent system a clique of size \((q+3)/2\) in the external-join graph on the internal points of the conic, whose clique number is \((q+3)/2\) for \(q\equiv3\pmod4\) but \((q+1)/2\) for \(q\equiv1\pmod4\) with \(q>5\), checked for every odd prime power \(q\le49\).  So the invariant half alone empties the branch for \(q\equiv1\pmod4\), using neither (A) nor any conjecture, and provably cannot decide \(q\equiv3\pmod4\); Theorem 10 proves the mechanism unconditionally — the pole of an external line is the unique candidate extension of that line's internal points, and it works exactly when \(q\equiv3\pmod4\).  The highest-EV next move is the invariant clique bound \(\omega\le(q+1)/2\) for \(q\equiv1\pmod4\), already proved for line-anchored cliques, with a cheap successor for the other class: test condition (A) against the pole configuration |

C756 optional stuck-state/review reading:
[`c756-proof-expert-dossier.md`](../clebsch-tasks/c756-proof-expert-dossier.md).

C321 remains conditional and is not triggered: the final Paper I review found
no missing proof obligation. C552 remains fallback-only and must not displace
the split-paper route without an explicit user decision.

## Paper I

Paper I and its companion *Computational strengthenings of Clebsch syndrome
rigidity* form one warning-free, nineteen-row release surface with twenty-six
checks and page counts \(22+12\). C714 is complete: the companion currently
records five modes—human structural proof, published theorem, Lean theorem,
finite certificate, and trusted execution. C855 is now the live Paper I gate:
it must replace every mathematical boundary in that five-mode ledger by a
kernel-checked Lean theorem and close the complete scholarly-artifact audit
before the next release is called theorem-complete.

The first of the two declared Dye inputs is closed: the ten-point bound on
triple-concurrence points is a proved theorem over any field in which two is
invertible, the rigidity gate is green, and its permitted-axiom entry is
deleted. The equality classification remains the single non-standard axiom of
that gate, reached by three terminals. Two of its inputs are now proved over an
arbitrary field: two triangles in double perspective are in triple perspective,
and a hexagon whose four named chord triples are concurrent has the golden
normal form `(1:0:0), (φ:1:1), (0:1:0), (1:φ:1), (0:0:1), (1:1:2−φ)` with
`φ² = φ + 1`, so the ground field contains a golden root. The shared
frame-coordinate helpers are promoted into `FrameCoordinates`, and the
perspectivity module now compiles against that compiled dependency rather than
a scratch copy. The chord-pairing dictionary is also closed: counting
triple-concurrence points of a six-arc is counting its concurrent chord
matchings, by a bijection proved in `SixArcChordMatchings` over an arbitrary
finite projective plane. What remains for the axiom is transitivity of
concurrence on the six one-factorizations with the `5 + 1` partition at count
ten, the hexagonal labelling that supplies the four concurrences, and the
order-eleven projectivity onto the displayed witness. None of the four new
modules is reached by a gate yet. Records:
[`../2026-08-04-c855-dye-bound-formalization.md`](../2026-08-04-c855-dye-bound-formalization.md)
and
[`../2026-08-04-c855-dye-axiom-elimination-plan.md`](../2026-08-04-c855-dye-axiom-elimination-plan.md),
with the two new proofs reported in
[`../2026-08-04-c855-triple-perspective.md`](../2026-08-04-c855-triple-perspective.md)
and
[`../2026-08-04-c855-golden-normal-form.md`](../2026-08-04-c855-golden-normal-form.md),
and the chord-pairing bijection in
[`../2026-08-04-c855-chord-pairing-bijection.md`](../2026-08-04-c855-chord-pairing-bijection.md).

The 2026-07-30 v2 referee cold-read revisions are complete.  The rational
\(A_5\)-module wording, theorem hierarchy, computational/formal boundary,
q13 and two-graph literature, opening, conclusion, and minor editorial
points are repaired.  The extracted q11 package now ships the aggregate
orientation axiom audit, and both authoritative and standalone trees pass
all eighteen release checks.  Full closeout:
[`../2026-07-30-c182-paper-i-bounded-revision.md`](../2026-07-30-c182-paper-i-bounded-revision.md).

The load-bearing theorem package reconstructs the Clebsch code from the
weight-six deep-hole syndrome locus and closes the terminal fields
q=13,17,19 by exact passant-edge-orbit searches. The shared
`deep_holes = conic` fact remains pinned to the standalone Lean repository;
the paper does not inherit trust from the fallback mega-paper gate.

C690 is complete as v2 exploration. The syndrome locus reconstructs the
unordered support-orientation torsor; on the frozen common marking its
exchange is support complementation, Gale duality, and golden conjugation,
and its first signed moment is cubic. C611 now closes the q=13 binary
minimum-distance gate by proving the exact value \(d=12\). Segre tangent
triples exclude weight eight: after one point is fixed, a cyclic 42-vertex
compatibility graph has clique number five,
while a weight-eight word would require a seven-clique. The proof is a
six-difference-set, five-row unique-closure lemma, not a support search. It
then excludes the two forced weight-ten pencil profiles and constructs a
dihedral weight-twelve word. All \(364\) minimum words split into one
\(S_4\) and three \(D_{24}\) projective orbits, and their pair concurrence
reconstructs passant versus secant join type. Triple-concurrence profiles
recover all six elliptic orbitals, and the \(78\) all-zero-triple
seven-cliques are exactly the passant incidence rows. Hence the minimum
layer self-reconstructs \(M\). Every minimum-word orbit independently spans
the full code, and the common code/hypergraph/scheme automorphism group is
exactly \(\operatorname{PGL}(2,13)\). The mod-two association algebra
identifies the four orbit Grams with \(A_9,A_9,A_{12},A_{10}\) and
conceptually forces their rank \(36\). It
does not prove the unsaturated \((7,13)\) case or the stronger maximum-six
claim, and it is not reached by C665's defining-characteristic trade
machinery. The
twelve-point Schläfli identification fails equivariantly, but both objects
map to the same six-axis \(A_5/D_5\) carrier: Paper I is its twisted
transitive two-cover and the double-six is its split two-cover. On the
twisted cover, the fibre-odd module is \(3\oplus3'\), and the difference
of the two five-orbital operators squares to \(5\) after normalization.
Thus the continuation locus intrinsically reconstructs the golden quadratic
algebra and its conjugation. Its natural fibre-odd integral commutant is
the conductor-two order \(\mathbf Z[\sqrt5]\), whose mod-\(2\) fibre is a
dual-number point and whose normalization has fibre \(\mathbf F_4\).
The signed continuation operator is exactly C682's golden Gram conference
matrix up to a signed permutation. Hence this is the same conductor defect
on the golden six-axis algebra. It is not the whole reason \(2\) is bad for
C682: the boundary operator, apolar form, and Mukai--Umemura geometry remain
bad after normalization. Locally, the \(2\)-defect and the cross-Gram
defects at \(11,23\) are the same order
\(\mathbf Z_p+p\mathcal O_p\), with inert, split, and inert normalized
fibres respectively.
The first open all-size full-conic gate is \(k=9\) over \(q=23,25\).
C691 is complete with a positive bridge.  If \(B\) is either signed
continuation orbital on the fibre-odd six-axis lattice, then
\[
 c_{ijk}=B_{ij}B_{jk}B_{ki}
\]
is exactly the support-orientation cubic.  Switching axis representatives
does not change the triangle products, orbital exchange negates them, and
the four-point two-graph identity reconstructs \(B\) up to switching.
Thus the cubic line and the golden operator \(B^2=5I\) are two
presentations of one integral orientation torsor.  Modulo \(2\), all signs
coalesce and \(B-I\) becomes rank-one square-zero, matching the
conductor-two degeneration.  More strongly,
\[
 \det(B+\operatorname{diag}x)=e_6-e_4+5e_2-125-2C_B,
\]
so the cubic is the sole nonsymmetric layer of the golden diagonal
determinant pencil, and complementary minors derive support complementation
from \(B^2=5I\).  Its homogenized conjugation-odd part is
\(F_B(x,z)-F_B(x,-z)=-4z^3C_B(x)\), while the off-diagonal equations in
\(B^2=5I\) force all signed moments below degree three to vanish and make
the cubic descend to the augmentation five-space.  Conversely, the
two-graph identities reconstruct \(B\), pair balance is equivalent to
\(B^2=5I\), and a gauge-fixed balance argument makes the positive graph on
the other five vertices a pentagon.  Hence the cubic alone forces the
unique golden conference switching class.
As a final intrinsic upgrade, the cubic threefold on the augmentation
projective four-space has exactly six singular points
\([\mathbf1-6e_a]\), all ordinary nodes.  They form a projective frame, so
the cubic itself reconstructs the six-axis carrier and its full projective
automorphism group is the computed outer \(S_5\) of order \(120\).
C693 integrates this complete package in the human paper and integrates
C611's \(q=13\) tangent-code theorem in the computational companion.  The
nineteen-row, eighteen-check Paper I trust surface is paper-owned and has no
Paper III dependency; the approved v1 baseline remains frozen.
C713 is complete.  Chord defect, the line bound, rigidity, and the
across-fields consequence now form one uninterrupted proof before the decoder
and orbit ledger.  The orientation proof exposes its six causal stages and
derives the orbital square from the exact (10,-10,0,0) common-neighbor
count.  Singular-locus completeness is no longer a Gröbner dependency: the
cross-golden determinant is ( -C), its trace dual is the smooth Clebsch
diagonal cubic surface, and Hassett--Tschinkel's determinantal converse gives
exactly six ordinary nodes.  CTZ remains exact model identification only.  The
old five-chart exhaustion is an independent replay, all q11 terminals and the
two Dye axioms are unchanged, and both authoritative and standalone
twenty-one-page release surfaces pass all eighteen checks.  Full report:
`notes/2026-07-31-c713-paper-i-proof-architecture.md`.
C751 is complete.  Its first blind comparison rejected an overcompressed
trace-dual revision 91--88; the resulting pentagon-first hybrid restored the
full trace complement, proved orbital self-pairing and fibre incidence,
expanded both golden-square cancellations, qualified Dye locally, and then
won the second blind comparison 96--91.  The same referee returned final GO,
and both authoritative and standalone twenty-six-check releases are green.
C752 is complete.  It confirms exact same-mechanism correspondence for the q11
chord-moment/equality trap, isolates the affine equality-case and degenerate-
conic seams, distinguishes displayed-witness code checks from arbitrary-arc
reconstruction, and shows that Paper I's orientation spine remains human proof
plus exact replay rather than a paper-specific Lean theorem.  Its completed
transitive prose census freezes four rigidity interfaces and eight bounded
orientation packets for active C753.  Full reports:
`notes/2026-07-31-c751-paper-i-proof-spine-tightening.md` and
`notes/2026-07-31-c752-paper-i-lean-spine-audit.md`.
C722 is complete with neither bounded clique branch promoted.  For q9 the
Sylvester distance-two graph has spectrum
(20^1,4^9,(-1)^{16},(-4)^{10}); Delsarte gives six, while equality forces
(A_3\chi=2(1-\chi)) and remains feasible in the intersection algebra.  For
q13 all fourteen character blocks of the three-orbit circulant graph are
diagonalized exactly; adjacency/complement inertias are ((19,23,0)) and
((22,20,0)), and the strongest exact dual found is a six-coloring.  The
published q9 value and q13 five-row unique-closure proof remain load-bearing.
The exact Fourier bundle passes to C723.  Full report:
`notes/2026-07-31-c722-q9-q13-clique-structure.md`.
C723 is complete with a precise finite boundary.  Pencil parity forces only
the profiles (3,1^6) with no secant neighbor or (1^7) with two secant
neighbors; globally the induced secant graph has degrees zero or two.  This
first association layer is feasible, while the two profiles respectively
lose the arc and local-clique hypotheses needed for the Segre tangent route;
binary parity also supplies no characteristic-(13) root-multiplicity bridge.
The raw (6{,}531{,}840)- and (166{,}561{,}920)-support domains are now two
canonical XOR-disjointness certificates with a separate full-fibre dynamic-
programming replay.  C725 inherits these as the frozen q13 weight-ten proof
objects; C726 alone owns trust integration.  Full report:
`notes/2026-07-31-c723-q13-weight-ten-profiles.md`.
C724 is complete.  The q11 fifteen-class census is now an orbit ledger with
canonical representatives, stabilizers, masses summing to 1548, concurrence
counts, chord-defect uncovered sizes, and conic-intersection histograms.
Fourteen nonsingular cubic minors replace the non-Clebsch row reductions, while
the Clebsch kernels are generated by (Q) and (QX,QY,QZ).  The q11/q13
size-(q+1) seven-arc leaves collapse to one and two projective orbits, with
three nonsingular quadratic minors and masses (140) and (840+840).  The
full normalized enumerations remain byte-identical audits, and the failed
first-order LP is frozen at the exact smaller-pencil optimum.  C725 inherits
these finite proof objects.  Full report:
`notes/2026-07-31-c724-paper-i-finite-census-compression.md`.
C725 is complete.  All q13/q17/q19 passant edges split into 10/13/15
projective root orbits, and their complete root-stabilizer extension DAGs have
604/4,442/11,260 nodes.  Every transition orbit, rooted/global mass identity,
and per-point terminal blocker assignment is directly checked.  The maximum
six-arcs form 2/22/94 projective orbits with 546/50,184/395,124 labelled
representatives and explicit witnesses.  A separately specified
increasing-index backtracker reproduces every labelled level without group
actions or canonical keys, while the older C++/discriminant replay remains a
third check.  The final C723/C724/C611 claim-to-proof-mode manifest is frozen
for C726; no all-field theorem is claimed.  Full report:
`notes/2026-07-31-c725-terminal-passant-orbit-dag.md`.
C726 is complete and closes C714.  The C721--C725 structural proofs and finite
leaves are integrated into the companion with a thirteen-claim five-mode
ledger.  The q11 orbit ledger, local determinant witnesses, q13 XOR
certificates, and q13/q17/q19 root-edge DAG are public paper-relative proof
objects; exhaustive normalized, conic, minimum-layer, labelled, and legacy
replays retain the trusted-execution boundary.  The q11 formal package is
pinned at `42ab1a2db30178cf23aa8393d886c63ded24bfbd` with a tracked exact axiom
audit; no finite classification or orientation theorem is mislabeled as Lean.
Both authoritative and standalone roots pass all twenty-six checks with
release-surface hash
`1ce03fc22f0a9857f3b62fd070ea3e42ad64350c6d2c01b57eeaa17c1714b04f`.
Full report: `notes/2026-07-31-c726-paper-i-companion-integration.md`.
C611 is complete.  At q=17 and q=19 the maximal passant six-arcs form
respectively 22 and 94 projective orbits, all with empty extension sets.
Pair inner distributions distinguish every q=17 orbit and 92 of 94 q=19
orbits; triple distributions separate the remaining two pairs.  This is a
finite coherent compression, not a uniform theorem.  Pair-only coherence
cannot see the ternary arc condition, and the natural root-edge rational LP
has exact feasible objectives 7--8 and 8--9 against the required bound 4.
Its uniform failure is the residual-pencil product: after fixing a passant
edge, the candidate set is the Cartesian product of the two endpoints'
remaining passant-line pencils.  The resulting feasible objective is at
least \((q-3)/2\), so this first-order dual route fails for every odd
\(q\ge13\).  Summing the line constraints in the smaller pencil gives the
matching dual bound, so the LP optimum is exactly the smaller pencil size.

Local aggregate replay:

```sh
cd papers/clebsch-rigidity
nix develop --command python3 verification/verify_release.py \
  --lean-root /absolute/path/to/finitegeom-clebsch-q11-certificates
```

## Paper II

Paper II is standalone: no proof dependency on Papers I or III.  Its frozen
v1 baseline remains unchanged, while C694 has integrated the accepted v2
arc.  A two-valued one-dimensional strength-two trade now derives the
balanced \(q+q\) one-factorization sheets; the uniform Frobenius-digit
criterion and local first-wall spill close the extension-field cases.  The
resulting exact \(B_3/\F_7\), \(H_3/\F_{11}\) classification uses only the
two-valued quadratic-trade condition.  Rodr\'iguez-Pajares--Ruano--Salizzoni
(2025) pre-empt the general self-associated/Schur-square/Gorenstein mechanism;
Paper II turns that blocker into a reverse rigidity theorem, classifying the
matching orbit and recovering the sheet-sign cubic from the two-valued trade,
with Gorensteinness stated as a credited consequence rather than a priority
claim.  The bounded extraction and source audit are recorded in
`notes/2026-08-02-c577-paper-ii-priority-extraction.md`.  The canonical replay
constructs only \(S,T,R,Y\), with q=121 and q=169 retained
as corroboration.  One edge-selected alternating cycle and Dickson
recurrence prove radial nonvanishing for both \(B_3\) and \(H_3\).  The
Paley carrier explains the cross-sheet orientation but is not used as the
Gorenstein pairing: it misses the radial/common-sum pair by one dimension.
Maximal-isotropic quotient duality gives that pairing directly.

C797 closes the stronger reverse-reconstruction question negatively.  In the
\(q=7\) affine module, the \(S_4\)-fixed locus is a line of seven points whose
seven size-\(14\) orbits all have the unique two-valued trade, while only one
lies in the matching image.  The trade recovers the homogeneous sheet module
but not its matching embedding.  Complete reducibility of one lift is the
nearest exact repair.  Full report:
`notes/2026-08-02-c797-trade-only-carrier-obstruction.md`.

C798 turns that failure into the sharp positive boundary theorem.  For both
\((q,K)=(7,S_4),(11,A_5)\), the stabilizer-fixed locus in the ambient conic
fiber is an affine line, its rational points give distinct \(G/K\)
placements, and the secant-product Chow locus meets it only at the matching
point.  Radial translation leaves the top sheet data unchanged and changes
only the outer radial constant, so Radical--Hadamard proves that all but one
parameter have the exact sheet-sign trade.  This gives \(q-2\) nonmatching
counterexamples structurally, with no seven- or eleven-orbit table in the
paper spine.  The single coalescence point is non-load-bearing.  The exact
eleven-orbit census is retained only in the C798 research bundle.  C801 is
queued for the reusable Lean abstraction after statement freeze.  Full
report: `notes/2026-08-02-c798-fixed-line-chow-rigidity.md`.

C801 is complete.  The reusable two-sheet radial interface, affine outer
constant and unique coalescence parameter, noncoalescent Radical--Hadamard
inheritance, exact sheet-sign annihilator, and \(q-2\) finite-line count are
kernel-checked without an orbit table.  The Paper II structural gate now has
twenty-nine terminals, the four-gate axiom audit has fifty-five terminals,
and the complete warning-free release aggregate is green.  The fixed-space,
stabilizer, block-system, and unique Chow-intersection arguments remain
explicitly human and classical.  Full report:
`notes/2026-08-02-c801-paper-ii-fixed-line-lean.md`.

C856 is complete.  The fixed-line family no longer assumes the three
parameterwise Radical--Hadamard premises: each evaluation space is presented as
a parameter-independent top space together with the constant function and the
radial level, the space is proved unchanged between parameters with nonzero
outer constant, and the premises are imposed at the reference parameter alone
and derived elsewhere.  Identifying the geometric evaluation spaces with that
presentation is now stated as a human input in the module header, gate header,
manuscript, and trust manifest.  Every scholarly-public declaration in the
fifty-six-file project-owned four-gate closure has a self-contained docstring,
and the release runner derives its expected metadata line and rejects a stale
statement count.  The structural gate has twenty-nine terminals and the
four-gate axiom audit fifty-five, all on the foundational allowlist; the
complete authoritative aggregate is green.  The shared-module defect recorded there is now closed: C860 (2026-08-03)
removed the cap-game modules from the paper closures and documented the five
residual `ProjectiveCap` geometry modules, so the artifact is referee-ready on
its full transitive closure.  An independent review confirmed every C856
claim: `notes/2026-08-03-c856-review-verification.md`.  Full reports:
`notes/2026-08-02-c856-paper-ii-lean-standards-closure.md` and
`notes/2026-08-03-c860-cap-closure-remediation.md`.

The paper-owned trust surface has twenty-nine statements and fourteen
evidence bundles, including independent generic-wall, shared-radial, and
q=9 small-field replays.  C749 closed the reopened human-proof gate after an
adversarial cold **MAJOR**, localized repairs, a fresh **MINOR** transparency
pass, and a final context-free **GO**.  The complete divided-power seam,
finite-torus alias elimination, affine polynomial/point-vector bridge,
transitive-dihedral and endpoint actions, exact \(p'\)-subgroup exhaustion,
and exceptional fusion locator are now explicit.  C750 and C801 already
close the corresponding structural and table-free radial Lean surfaces.
The warning-free authoritative PDF and full release aggregate are green.
The standalone repository remains at the previous frozen release because
C577 owns repackaging and synchronized publication after authority is
available.  The opening, proof roadmap, conclusion, README, and appendix
transition have also passed a statement-preserving Milnor--Serre copy edit.
Audit and closure reports:
`notes/2026-07-31-c577-paper-ii-new-math-audit.md`,
`notes/2026-07-31-c747-paper-ii-socle-wall-proof.md`,
`notes/2026-07-31-c748-paper-ii-serre-integration.md`, and
`notes/2026-08-02-c749-paper-ii-adversarial-human-proof.md`, and
`notes/2026-08-02-c577-paper-ii-milnor-serre-copy-edit.md`.
C682 characteristic-zero work is inventory unless
explicitly promoted.

Local aggregate replay:

```sh
cd papers/clebsch-factorization
python3 verification/verify_release.py
```

## Paper III

Paper III's forward version is *Golden descent and operator realizations of
the Clebsch cubic*.  C763 inserts the selective conference,
middle-exterior, commutator-Pfaffian, cross-golden determinant,
Joubert--Segre, and Segre--Igusa chain between the square-class source and
the degree-six harmonic return.  Its exact trust surface has seven rows and
a new ring-general fixed-conference Pfaffian bridge; the broader Golden
application inventory remains excluded.  C764 adds only the local reason for
the determinant: it acts on determinant lines, while a permanent varies under
the internal orthonormal-frame gauge.  The physical companion remains a
separate Golden package and should be cited here only after it has a stable
public locator.  Full reports:
`notes/2026-08-01-c763-paper-iii-golden-consolidation.md`.
`notes/2026-08-01-c764-paper-iii-why-determinant.md`.

Paper III's corrected arithmetic statement has global square class `5J_0`;
the fixed Clebsch chart lives over `Q(sqrt(5))`, and the displayed golden
configurations are the complete reduced local fibre.  C733 proves the global
Stein algebra `O + O(-3)` with multiplication `z^2=5J_0`, so the chart
factorization is scheme-theoretic.  Its strongest orientation theorem is
explicitly relative to the ordered golden representatives, plane-triple and
Petersen labels, and normalized chart lift.  The full ambiguity ledger is
integrated, and the sheet alone is not claimed to recover those inputs.
Ordinary, isolated, visual, and fresh context-free gates are green.  The full
geometric integral localization remains unspecified; immutable artifact and
versions 1 and 2 are released.  C680 is retired; C763 owns the selective
Golden-core forward version, while the broader applications remain outside
the numbered series.  Full repair report:
`notes/2026-07-31-c733-paper-iii-relative-orientation-bridge.md`.

C682 is independent exploration. Its current crown includes the
third-transvectant inverse descriptions, the corrected mod-11 operator and
1+5+6+10 kernel section, the characteristic-zero maximal-subgroup mates and
Schlaefli double-six, and the golden D5--S3 complementary incidence fibres.
The frozen common marking identifies the stored mod-11 matrix with the
lambda-plus fibre.
The cross-Gram separator extends over both Mukai--Umemura boundary orbits
on the normalized saturated graph, but provably not as a scalar on the
coarse kernel-pair boundary.
The normalized-graph deck exchange is exactly the global extension of the
Schläfli apolar-polar row swap: inside each \(D_5\), the two five-cycle
classes give complementary pentagon-side and pentagram-diagonal relations
on the ten \(S_3\) labels.
The combined normalized operator/polar/incidence package has minimal base
\(\mathbf Z[1/30]\) and structural bad primes exactly \(2,3,5\).
An \(11\)-elementary dodecic lattice removes the apparent operator failures
at \(7,11\); the cross-Gram scalar image, but not the normalized golden
cover, has collision primes \(11,23\).
At \(23\) that scalar image is the conductor-\(23\) suborder of the inert
golden algebra: its special fibre is a dual-number point, and the divided
separator is the Frobenius-odd normalization generator over
\(\mathbf F_{529}\), not a new rational incidence sheet.  Globally the
scalar image is the conductor-\(253\) order over \(\mathbf Z[1/30]\), whose
only normalization defects are the split prime \(11\) and inert prime \(23\).
Independently, the Klein \(E_8\) cubic is now intrinsic: it is the radial
third-transvectant symbol, and on every McKay covariant block the full
principal symbol is \(10p\) times multiplication by the odd invariant
\(t\), uniformly selecting the classical \(E_8\) matrix factorizations.
Through degree \(72\), every later apparent short-return deficit is repaired
by the nearest downward return; degree \(22\) is the sole certified
full-corner failure in that bounded range.  The all-weight gate remains
open.  The fourteen strict peaks through degree \(112\) also saturate,
completing one base representative of every eventual \(60\)-periodic peak
family; only the \(1,2,3,3'\) free modules remain in the symbolic
nonvanishing gate.  The global two-sided defect is now classified in all
weights: it vanishes for every \(n>52\), and its thirteen exact exceptional
degrees are
\(0,1,2,6,10,11,12,20,21,22,32,40,52\).  Degree \(22\) is uniquely
compatible with a repeated isotypic summand.  Five exact local
four-by-four determinants prove unique continuation on the five
coefficient chains.  A noncircular lower-hyperplane propagation lemma
reduces the remaining full-corner proof to upper-support mixing at
codimension-two peaks plus off-peak propagation.
The attempted maximal-rank/multiplicity induction is now sharply audited.
Every McKay block is maximal-rank through degree \(300\) at two primary and
one replay prime, and full supported algebras on spanning nonorthogonal
subspaces generate the full matrix corner.  However the trivial module has
a recurring unanchored plateau \(1\to2^6\to3\), first in degrees
\(118,\ldots,160\); equal-rank edges only transport the unknown corner, so
bare induction is circular.  That first obstruction is now repaired:
for every \(q\ge1\), the first upward return at the trivial-module entrance
\(n=64+60q\) mixes the incoming hyperplane with its missing direction.
The fixed-width boundary witness reduces the family to one exact rational
function with a coefficientwise sign proof.  The remaining controllability
gate belongs to the \(2,3,3'\) Kostant modules.  The scalar boundary
function now has a canonical signed Bezout pencil: its boundary metric has
inertia \((8,7,0)\), while separate positive Hermite pencils derive the
numerator and pole chamber counts \(1|13|0|1\) and \(2|1|0|0\) by exact
spectral flow.  The next structural target is the block version of this
two-form package for the three remaining modules.
That block input is now complete on the first \(2,3,3'\) periodic plateau
families.  Their block three-term recurrences have sizes \(2,3,3\), with
degree-three coefficients in \((q,j)\), and their backward determinants have
no integral interior zero.  The signed block Wronskian satisfies the exact
Green identity.  Fixed endpoint-return tuples surject onto local boundary
quotients of dimensions \(3,4,4\); degree-\(83,121,120\) determinant
certificates prove stable-ray surjectivity, and direct exact boundary
determinants prove surjectivity on every shorter initial chain.  Thus full
boundary-quotient surjectivity holds for every \(q\ge1\), and all first
plateau-entry families in \(1,2,3,3'\) are controlled.  Smith-at-infinity
profiles account exactly for the apparent \(13,17,18\) determinant-degree
drops.  Exact global falling-factorial Weyl operators in the invariant
exponents \((F,h)\) now realize the third- and ninth-transvectants on the
complete \(2,3,3'\) free modules, eliminating phase-specific operator
construction.  Four further all-\(q\) Wronskians give one certified
representative of every plateau type modulo \(20\); an exact audit shows
that Hilbert translation by degree \(20\) is not transvectant linearity.
The sixteen resulting modulo-\(60\) phase quotients are now all
boundary-surjective for every integer \(q\ge1\).  Together with the prior
eight rays, they anchor every periodic plateau-entry phase.  Exact
global-Weyl two-step compositions are coefficientwise one-signed
degree-four polynomials on all twenty-one eventual strict peak families;
  combined with the all-weight defect and supported-two-subspace theorems,
  this propagates the full graded path corner through every peak.  The
  one-sided operator is now maximal-rank on every McKay block in every
  weight.  The order-three ODE bound, central parity, \(C_5\)-weights, and
  triangular \(d_1/d_{11}\) chain minors prove the exact kernel series.
  Consequently all off-peak full graded path corners in \(1,2,3,3'\) now
  propagate.  The subsequent monotone analysis closes all sixty-three
  modulo-\(60\) plateau entrances in \(2',4,4_s,5,6\).
The four exceptional modulo-\(20\) block Schur recurrences are now explicit.
The global level \(\lfloor b/3\rfloor\) makes all twelve phases block
tridiagonal, their backward blocks factor only at
\(0,\pm1/3,\pm2/3\), and exact elimination leaves complements of sizes
\(5|6|7\), \(5|6|7\), \(6|7|9\), and \(7|9|11\).  The selected endpoint
determinants are nonzero on the exact finite audit \(6\le r\le35\).
The all-\(r\) gate is now closed by scalar \(C_5\)-chain boundary
obstructions.  On chain residues \(4,2,2,0\), exact two-coordinate minors
show that \(D_n^\dagger D_n\) never preserves the incoming hyperplane in
\(4_6,4_{s,3},5_4,6_5\).  Their rational obstructions are strictly negative
on the full real ray \(r\ge6\), and the canonical Fischer endpoint has
positive Schur contraction.  Hence all sixty-three monotone entrance phases
and every graded path corner now propagate.  The local-return gate is also
closed, in a stronger form: the nearest lower and upper Gram returns already
generate every McKay block corner except the exact
\((\mathbf3,22)\) failure.  The two-step upward return is redundant.  The
signed Wronskian and complete boundary quotients give the cyclic-kernel
proof, while the rectangular endpoint system separates distinct blocks.
Thus the requested three-return algebra is the full graded path corner in
every nonexceptional degree.  On every nontrivial block this two-return
presentation is generator-minimal, and both generators are canonical
positive Fischer energy forms.
The previously unexplained virtual levels
\(0,\pm1/3,\pm2/3\) are the order-three \(h=0\) indicial roots in the
degree-\(60\) \(h^3/F^5\) level of
\(t^2=1728F^5-h^3\).  Source-chain residue counts give the exact formula
\[
\det K_-(j)=C\prod_{s=0}^2((3j+s)_3)^{c_s}.
\]
It explains every factor multiplicity, the identical normalized
\(3,3'\) determinants, and the phase-independent \(6\)-profile.
Its detailed, reorganizable lookup surface is the
[C682 working archive](2026-07-13-clebsch-c682-archive.md); none of it reopens
Paper III automatically.

C696 is complete as a Paper III v2 outreach audit. Its strongest connection
is the \(A_1\times A_5\) minuscule branching \(27=12+15\): C682 supplies the
double-six, and C695 now canonically recovers the complementary fifteen
lines from the unique cubic through those twelve embedded lines.  The full
operator-derived configuration has the exact minuscule
\((2\otimes6^\vee)\oplus\bigwedge^2 6\) weight dictionary, all \(45\)
tritangent planes, and the Cartan cubic's mixed-plus-Pfaffian monomial
support.  Row exchange is the \(A_1\) Weyl reflection, not Galois conjugation
or the outer automorphism exchanging \(27\) and \(27^\vee\).  C697 now
constructs the abstract graded Cartan carrier with its exact \(6|15|6\)
cocharacter and signed mixed-plus-Pfaffian cubic.  The row permutation
requires an order-four linear Weyl lift.  The raw Cartan tensor descends
exactly to the six-axis orientation field \(\mathbf Q(\sqrt5)\); rational
descent needs a determinant twist on one row.  KLM Hodge conjugation instead
relates \(V_L\) to \(V_{L^\vee}\), hence belongs to the outer
\(27\leftrightarrow27^\vee\) side.  With no cohomological or Higgs
realization, the operator construction is a graded Cartan model but not a
model of the KLM variation.
Krämer--Litt--Maculan's generic-monodromy theorem
is context rather than an imported result; the golden field is not their
invariant trace field.  The exact full-\(27\) Galois action preserves both
rows and realizes the definition-field tower
\(\mathbf Q(\sqrt5)\subset\mathbf Q(\zeta_5)\); it is not a monodromy
trace-field statement. A bounded invitation is drafted but remains unsent.

Local aggregate replay:

```sh
cd papers/clebsch-covers
./scripts/verify-all.sh
```

## Companion-export chain

Paper III's formal companion is back on the guarded chain. Its gate
`RelativeConicArcs.Gates.ClebschPassages` is declared in
`lean/trust/areas/relconic.toml` with all fifty terminals and their expected
axioms, its extracted fact is committed, and
`lean/trust/export/clebsch_passages.toml` supplies the destination names and
release prose. The exporter's `plan` resolves the fifteen-module closure and the
full destination file set.

Running the export is blocked by drift in the canonical base rather than by
anything Paper III owns: `TARGET_MANIFEST.json` in `~/src/lean/finitegeom`
disagrees with its own tree at four paths — `ProjectiveCap/Sym2ConicBridge.lean`
changed, and the three `Q16` modules were moved to a certificate package —
because three base commits landed without resealing that manifest. Every
companion export refuses until the base is resealed, so the reseal is the
blocker to raise before the next export of any area.

## Release and verification policy

Each split paper owns its statement identity, claim manifest, aggregate gate,
replay entry point, toolchain pins, adequacy appendix, and AI/provenance
disclosure. Shared Lean sources stay in the pinned standalone Lean
repository. An immutable public locator and fresh isolated replay are release
requirements, not substitutes for the paper's local gates.

Paper I's current local export is the sealed C753/C762 surface. Paper II requires its
own release pass. Paper III's relative marked bridge, global Stein algebra,
mechanical artifact, isolated, visual, source-pinned Lean-boundary, and
fresh-referee gates are green.  Its locator and author metadata must still be
inserted before submission readiness.

## Lane boundaries

This lane owns the three Clebsch paper roots, the preserved mega-paper
fallback, Clebsch checkers/reports, and exact Clebsch queue rows. It does not
own Baer, alternate-orbit, gem-mining, or crowns work. Cross-lane results are
read-only until an owning split-paper task explicitly admits them.

The companion discovery log is
`notes/2026-07-14-clebsch-discovery-track.md`. Logging an observation neither
allocates work nor adds it to a paper.

## Working and historical indexes

- Trilogy venue strategy:
  [`../2026-07-30-clebsch-trilogy-venue-strategy.md`](../2026-07-30-clebsch-trilogy-venue-strategy.md).
- Live task detail: `notes/clebsch-tasks/`.
- C682 thematic lookup and chronology:
  `notes/handoffs/2026-07-13-clebsch-c682-archive.md`.
- Full accumulated handoff history:
  `notes/handoffs/done/2026-07-13-clebsch-paper-archive.md`.
- Retired mega-paper planning redirect:
  `notes/2026-07-20-clebsch-paper-planning.md`; full superseded record:
  `notes/2026-07-20-clebsch-paper-planning-archive.md`.
- Mega-paper independent cold read:
  `notes/2026-07-23-c320-independent-cold-read.md` — fallback only.
