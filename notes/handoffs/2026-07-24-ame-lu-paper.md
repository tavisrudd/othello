# AME local-unitary paper

**Lane:** `ame-lu`

**Purpose:** complete the paper titled *Local-Unitary Rigidity of
Stabilizer AME States and Transversal Clifford Groups of MDS--CSS Codes*.

Discovery companion:
[`2026-07-24-ame-lu-discovery-track.md`](../2026-07-24-ame-lu-discovery-track.md).

## Current status

**C830 queued (2026-08-02): post-Version-2 global rounding enhancement.**
Prove or refute that small global defect forces coherent nearby local Clifford
frames without reading one exponentially faint half-plus-one marginal.  The
primary routes are simultaneous balanced-cut constraints and rigidity of the
half-splitting equality/near-equality cases.  Quantify the threshold actually
proved; do not promise a constant threshold or describe the present
`q^{-(n+4)/4}/n` scale as a limit.  See the live queue and the future report
`2026-08-02-c830-global-ame-rounding.md`.

**C828 closed (2026-08-02): the four bounded C805 corrections are complete.**
The false arbitrary-additive minimal-codeword claim and the unsourced
Gross--Van den Nest specialization sentence are removed; the recognition proof
is unchanged and independent of both.  Every framing and trust surface now
separates the generator-coordinate `ell^1` radius from the exponentially small
defect-only decomposition threshold.  The overgrown Section 3 is split into
four numbered conceptual units, with all downstream sections, equation tags,
roadmaps, maps, ledgers, figure references, and release identities synchronized.
The adversarial proof/scope pass, warning-free 51-page build, affected-page and
whole-paper visual sweeps, complete evidence replay, and public/formal release
checks pass.  See `2026-08-02-c828-ame-lu-manuscript-tightening.md`.

**C805 closed (2026-08-02): all six explanatory figures won blinded
comprehension comparisons.**  The adopted vector figures cover axis recovery,
minimum-support holonomy, the symmetry-group extensions, the defect/threshold
mechanism, the uniformity-order radius, and the pencil quotient.  Two invalid
controls were discarded and rebuilt before scoring: one diagram had visually
concatenated distinct exact sequences, and one no-figure control retained an
unresolved reference.  Fresh readers preferred both corrected figures; all six
falsehood probes passed.  The warning-free 51-page build, affected-page sweep,
release profiles, and standalone synchronization pass.  A concurrent cold read
passed the C804 recognition theorem but found four follow-ups: delete or prove a
false blanket minimal-codeword claim for additive codes, separate generator
radius from the exponentially small defect-only threshold in the framing, add
an exact Gross--Van den Nest locator or cut that sentence, and split the
overgrown Section 3.  See `2026-08-02-c805-figures-and-ab.md`.
Standalone forward commit `4f64e7e` is synchronized and unpushed.

**C804 closed (2026-08-02): the central concession is inverted, and the
recognition criterion is coherent.**  Section 3 now proves the
partial-Weyl marginal criterion, recognition subgroup, generation
criterion, minimal-support realization, prime-field CSS corollary, and
integer-modulus extension.  At local dimension two the package unifies the
full Van den Nest--Dehaene--De Moor theorem; above it, intermediate label
subgroups give the new scope.  The introduction adopts that positioning
after the adversarial pass, blind A/B, C807 audit, and Fable red team.  The
final exposition review repaired two surviving mathematical sentences
(exact order versus exponent at composite dimension, and the false qubit
subset claim), made the second-state purity transfer and two-party
obstruction explicit, corrected the stale propagation reference from
\((3.8)\) to \((3.16)\), and synchronized every claim and trust map.  The
warning-free 49-page build and affected-page visual sweep pass.  The
package is manuscript proved, with no certificate or Lean coverage.  Tan's
four-qutrit concession remains unchanged pending the separately gated atlas
reproduction.  Standalone forward commit `7b7968c` is synchronized and
unpushed.  See
`2026-08-02-c804-specialization-inversion.md`.

**C775 closed (2026-08-02): the 2-uniform claims survive, with conceded
prior art.**  Discreteness is not pre-empted, but Wirthmuller settles the
binary stabilizer case and Tan computes the four-qutrit symmetry group, so
the adopted theorem needs a concession paragraph and a firstness sentence
scoped to arbitrary local dimension and non-stabilizer states.  The audit
also supplies the contrast that makes 2-uniformity rather than
1-uniformity the load-bearing hypothesis.  Stability is clear; Fisher
isotropy becomes an explanatory remark with citations; the gauge corollary
is retained.  Two framing corrections to the source material are mandatory,
and the approximate-representation stability literature remains unsearched.
See `2026-08-01-c775-two-uniform-rigidity-literature-audit.md`.

**C774 closed (2026-08-02): the claims hold, the selling point does not.**
All four results survive step-by-step checking, with named repairs.  The
advertised party-count independence is narrower than stated: the ratio
constant is independent of the party count, but the certified neighbourhood
shrinks like its inverse square root, and an explicit Reed--Muller family
attains that rate, so no uniform version exists and the manuscript must not
claim party-count-independent certification.  The cross-programme falsifier
did not falsify; it produced a sharper theorem, that a binary code's lift
lattice has full rank exactly when its dual distance is at least three.
See `2026-08-01-c774-two-uniform-rigidity-red-team.md`.

**Round-two cold read: brief additions (2026-08-02).**  When C795 lands,
the round-two cold read goes to a *fresh* reviewer — the one that reviewed
the integration wrote the split being implemented and has read the
manuscript twice, so it is no longer cold.  Beyond the usual referee pass,
that reviewer must answer explicitly whether any diagram would help the
exposition.  The paper currently contains no figure at all, while carrying
the minimum-support atlas, operator-pushing loops and their holonomies, a
four-step rigidity mechanism, exact sequences for the symmetry groups, and
now a region picture parameterized by uniformity order.  The style guide
admits a figure when it explains an incidence structure, correspondence,
orbit relationship, or proof mechanism faster than prose can, and requires
each figure to have a job in the argument, stay legible at publication
size, be interpretable without colour, and carry a caption stating its
mathematical point.  **Lean generous: as many figures as genuinely help, not
a minimal set.**  If five each earn their place, propose five; the bar is
whether a figure does work prose cannot do as quickly, not scarcity.  Each
proposal must name its job in the argument, the object depicted, the visual
encoding, and a draft caption, in enough detail that an implementer can build
it without re-deriving the idea.

**Then test that they help, rather than asserting it.**  Figures are adopted
on evidence: implement them, then run a blind comparative read of the affected
passages with and without, by a reader who did not propose them and is not told
which version is which, judging comprehension rather than aesthetics.  This is
the method the `golden` lane used for its editorial A/B, so the precedent and
its reporting shape already exist in the portfolio.  A figure that does not win
its comparison is cut.  Figure implementation and its A/B are their own
allocated C-item, not part of the cold read.

**C780 closed (2026-08-02): the diagonal programme's coding half is
pre-empted; its dictionary is the asset.**  The plateau is a corollary of
published classification below length 48 and survives only above it; the
staircase family and the transversal-T correspondence are pre-empted; the
classification and our two own findings are clear but must cite
Gross--Van den Nest.  The claim that symmetry of one state and equivalence
of two are different problems is too strong — symmetry is a specialization,
and the surviving distinction is whole-solution-group versus
some-solution-is-Clifford.  Disposition: a section of this manuscript, not a
standalone paper, led by the dictionary that finiteness of the diagonal
symmetry group is exactly projectivity of the code.  **The eight queued
diagonal rows now need re-scoping, which is a scope pivot and awaits the
user's decision.**  See `2026-08-01-c780-diagonal-rigidity-novelty-audit.md`.

**Re-scoping template for the pre-empted diagonal material (2026-08-02):
the `golden` lane's C794 manoeuvre.**  The move is to **prove something
broader, of which the classical result is a consequence** — the prior work
stops being a competitor because it becomes a corollary, a specialization of
our theorem at their parameters.  C794 proves faithfulness for *every*
two-graph on at least seven vertices, strictly broader than conference
two-graphs, and the Greaves--Suda reconstruction then falls out as the
specialization; that is why its citation reads as composition rather than
concession.  The supporting moves, in order:  (1) identify the published object with ours, showing the
determinant-minus-three principal four-sets *are* the aligned four-sets, so
the prior work is our object in other language;  (2) prove the direction
nobody had — they go matrix to design, C794 goes design back to two-graph up
to complement — so the prior theorem is the input and the new one gives it a
faithfulness property it lacked;  (3) compose rather than compete, stating
the consequence as "hence their design reconstructs at every order at least
ten";  (4) replace the computer census by a human proof and demote the
census to an independent falsifier;  (5) locate the first question the
published invariants do not settle, and answer it — their first
design-unforced cut moment.  Wording discipline throughout: "we prove",
"to our knowledge", never "first", and no novelty claim on the elementary
parts.

**And red-team the move before the A/B, in a separate pass.**  The blind
read measures how the reframing lands; it does not establish that the
specialization holds, and a cold reader given two polished drafts will not
reliably catch a hypothesis that fails at the predecessor's parameters.  So
run an adversarial pass first, by an agent whose brief is to break the claim:
take the predecessor's exact hypotheses and conclusion, instantiate our
theorem at their parameters, and check the implication in both directions —
does our statement really imply theirs, and does theirs assume anything ours
does not supply.  Look specifically for a hypothesis that is free at our
generality but binding at theirs, and for a conclusion of theirs that is
strictly stronger on their domain.  Only a claim that survives that pass goes
to the A/B; a broken one is dropped and the honest concession stays.  This
ordering is deliberate — the lane has twice adopted a conclusion that a later
pass narrowed, and a priority claim is far more costly to retract than a
scope sentence.

**Adoption gate for any judo reframing: blind A/B against the frozen
baseline.**  A reframing is adopted on evidence, not on the proposer's
enthusiasm.  Freeze the current committed framing as the anonymous baseline,
build the reframed version to the same finish — equal polish, or the test
measures polish rather than framing — and give both to a cold reader who has
seen neither and is not told which is which or which is ours.  This is the
method the `golden` lane used for its editorial A/B, so the precedent and
reporting shape exist.

The reader answers two questions, and the second is the one that matters
here: which version presents the stronger contribution, **and is the
reframed version's specialization claim actually correct?**  A framing that
reads better while overclaiming is the failure mode this whole technique
invites — the predecessor must genuinely be a corollary, with its hypotheses
implied by ours at its parameters, not merely adjacent to one.  Ask the
reader to attack that implication as a referee would.  A reframing that wins
on preference and loses on correctness is discarded, not softened.

Ask of every conceded result: what broader statement would have it as a
special case, and can we prove that statement?  Not what adjacent territory
is free, but what theorem swallows theirs.

Applied to our case:  the published classification of projective triply-even
codes owns the plateau; our dual-distance dictionary says full lattice rank
is exactly projectivity, hence exactly finiteness of the diagonal symmetry
group, so their length set *is* the classification of which CSS coset states
have a finite diagonal symmetry group carrying a non-Clifford order-eight
element.  Cite their classification, do not reprove it; keep the recovered
simplex certificates as an independent falsifier that now also validates our
tooling against a published result; and identify the first quantum question
their coding classification does not answer — the weighted sector and the
non-diagonal residue are the candidates — as our analogue of the
design-unforced moment.  This is a recommendation; the re-scope itself is a
scope pivot and awaits the user.

**C777 closed (2026-08-02): the formal layer matches the manuscript, with
its boundary stated.**  A new multipartite namespace, general in site set
and local dimension, proves the generator splitting, the single-exponential
identity, the polarized second-moment identity, discreteness, and two-sided
defect invariance; the decomposition corollary is a hypothesis-explicit
interface.  Gate and axiom audit passed with only the three standard axioms
and no certificates.  The stability estimate and the intertwiner bound are
reported unformalized rather than weakened, and the formalization ledger now
says what may be cited as kernel checked.  See
`2026-08-01-c777-two-uniform-rigidity-lean.md`.

**C796 closed (2026-08-02): cross-lane analogy refuted; two theorems
recovered from the refutation.**  The golden lane's balanced-cut sign
recovery does not transfer and the lead is closed — nothing should be
imported from it.  Refuting it produced a stability estimate with no global
generator-budget hypothesis, complementary to C786's moment route, and a
proof that C786's one named blocking example for its central open problem
does not exist.  The obstruction there is not phase-blindness.  See
`2026-08-02-c796-phase-blindness-transfer.md`.

**C786 closed (2026-08-02): the threshold is explicit and the region
question was mis-parameterized.**  The certified radius grows with the
uniformity order, so for an absolutely maximally entangled state it grows
linearly in the party count rather than shrinking.  The family behind the
earlier shrinkage finding holds uniformity at three for every length, so it
measured uniformity order and not party count.  The global threshold is now
closed form, obtained from quantized stabilizer overlaps with no compactness,
though exponentially small in the party count.  C795 carries the manuscript
correction and must red-team it first, since it reverses an adopted
conclusion.  See `2026-08-01-c786-explicit-stability-threshold.md`.

**C776, C777 open (2026-08-01): 2-uniform rigidity upgrade.**  An external
Fable session produced a discreteness theorem requiring only 2-uniformity (no
stabilizer hypothesis), an explicit stability constant independent of the party
count, an exact quantum-Fisher isotropy proposition, and a finiteness statement
for local gauge groups of 2-unitary gates.  None of it exists locally; it
executes frontier item 6 of
`2026-07-25-ame-lu-two-cold-read-frontier.md`.  C774 red-teams and
regenerates the numerics, C775 audits the literature, C776 integrates on a
double pass, C777 updates the Lean aggregate.  Source catalogue:
`2026-08-01-external-chat-artifact-gap-review.md`.  The same
external material also carries a diagonal-symmetry classification and
rigidity phase boundary for binary CSS coset states, queued as C778--C780.

**C778--C780 queued (2026-08-01): diagonal rigidity boundary.**  Pegged here
as the nearest owner of quantum rigidity results, not because the paper
belongs to this manuscript.  C778 turns the recovered exact-simplex decision
procedure into a replayable certificate bundle for the triply-even plateau;
C779 attempts the Walsh-moment structural proof that would replace the finite
sweep and settle the open window; C780 is the novelty audit that gates any
manuscript work.  The load-bearing script was recovered and spot-validated
against the source note's plateau boundary on 2026-08-01; see
`2026-08-01-c778-strip-certificates/PROVENANCE.md`.  If this
becomes its own manuscript it needs its own lane, which requires approval.

**C782--C785 open tails of the same external material.**  C783 is now active.
Its originally proposed weighted-enumerator core is pre-empted by
Nezami--Haah's level-three divisibility test and the May 2026
triorthogonal/MacWilliams dual-distance ILP.  The surviving question is the
mixed-residue equal-phase CSS boundary, preferably after C790's level-three
Smith--Schur reduction; the existing triply-even plateau does not answer it.
C782 writes the general p-power qudit sector airtight and covers p=3; C784
repairs a scope gap, since the lattice classification is
proved for equal-phase CSS coset states but the semi-Clifford reduction
applies it to general stabilizer states; C785 searches the 16-qubit
Reed--Muller state for non-diagonal non-Clifford product symmetries.

**C734 closed (2026-07-31): Clebsch syndrome bridge formalized and proof
spine made structural.**  `SyndromeGeometry` now proves generically that
translated equal-phase states are classified by code cosets, distinct cosets
are orthogonal, dual-code phase stabilizers read the translation character,
and every syndrome has one unique representative on each three-party support;
minimum weight three forces full support.  Section 5 isolates this as the
two-paragraph structural lemma `lem:coset-syndrome-charts`, then obtains the
Clebsch result by composing the companion conic/count/orbit theorem with the
nonconic logical-phase theorem.  The adjacent prose now separates the twenty
syndrome charts from the ten fixed-input operator-pushing fibres.  All formal,
axiom, manuscript, visual, evidence, release, and ledger gates passed.  The
paper-only standalone mirror passed its build, evidence replay, and public
manifest gate with the formal companion recorded and correctly absent.  A
post-closeout cold read found no correctness blocker; its two local trust-map
and group-layer clarifications were adopted and revalidated.  See
`2026-07-31-c734-clebsch-syndrome-lean-structural-proof.md`.

**C581 closed (2026-07-31): quantitative ambient-Clifford rigidity is
positive, semilinear reconstruction is false.**  Phase-optimized global
vector error `\(\varepsilon\)` between product-unitarily related
equal-phase `[6,3,4]_q` MDS--CSS states forces every local factor within
normalized Hilbert--Schmidt distance `\(2\sqrt2q^2\varepsilon\)` of an
additive Clifford below an explicit prime-field commutator threshold.  The
four-party marginal form is `\(\sqrt2q^2\eta\)`.  Weyl products,
commutators, and character averaging close the gap from approximate axes to
an implementing Clifford.  The result is uniform across C623's enlarged
kernels only for the full prime-field Clifford target: exact q=9
nonsemilinear and q=25 GRS symplectic elements rule out every uniform
semilinear, split-torus, or Desarguesian-spread upgrade at zero error.  No
manuscript wording was adopted.  See
`2026-07-24-c581-phase-space-robust-rigidity.md`.

**C731--C732 closed (2026-07-31): Clebsch extremal-\(X\)-syndrome bridge
red-teamed and adopted.**  Section 5 now proves the coset-state and
\(Z(C^\perp)\)-syndrome dictionary for the Clebsch \([6,3,4]_{11}\) state,
imports the twelve conic rays, 120 syndromes, and transitive
\(C_{10}\times A_5\) orbit with exact source credit, and strengthens the
twentyfold count to one minimum \(X\)-representative on every three-party
support.  Hence either side of every balanced \(3\mid3\) cut can create the
same extremal translate.  The defining arc remains nonconic, so the
fixed-party logical image is \(T\), not \(\mathrm{SL}_2(11)\); the adjacent
remark separates this from the computed \(S_5\) party image, arbitrary
weight-three correction, and every Hamiltonian or Golden-operator claim.
All theorem, novelty, verification, formal, evidence, PDF, release, visual,
and standalone-mirror gates passed.  Authoritative commit `68ee4664`;
standalone forward commit `c1be0c8`, unpushed.  See
`2026-07-31-c731-clebsch-ame-syndrome-bridge-red-team.md` and
`2026-07-31-c732-clebsch-ame-bridge-adoption.md`.

**C649 adopted pending its final Lean composition and aggregate gate
(2026-07-25): general stabilizer-AME full-Weyl rigidity.**  For every stabilizer
\(\operatorname{AME}(2m,q)\) state with \(m\ge2\), the stabilizer labels
supported on any \(m+1\) parties form a \(q^2\)-element subgroup and
project bijectively onto the full local Pauli-label group at every retained
party.  The reduced stabilizer projector is therefore full-Weyl diagonal
up to arbitrary nonzero phase coefficients, so the existing axis theorem
forces every factor of an LU intertwiner to be Clifford.  This works for
arbitrary additive prime-power stabilizers; CSS, equal-phase, classical
linearity, and MDS are unnecessary for rigidity.  The \(m=1\) Bell-pair
boundary is sharp.  The dimension squeeze is kernel checked in
`StabilizerAMESupport.lean`; minimum-support generation and the abstract
holonomy-centralizer theorem are also kernel checked.  The claim-specific
audit located the known qubit and canonical four-qutrit subcases, the
standard QMDS enumerator, and standard operator pushing, but no exact
all-prime-power/all-\(m\)/arbitrary-additive predecessor.  The manuscript
now leads with the general theorem, credits those sources at point of use,
and interprets its 450 pencil holonomies as transition-atlas data.  The
end-to-end additive stabilizer-projector/reduced-density Lean composition
and the already queued aggregate remain open.  See
`2026-07-25-c649-stabilizer-ame-full-weyl-rigidity.md` and
`2026-07-25-c649-stabilizer-ame-literature-audit.md`.

**C647 closed (2026-07-25): post-C562 literature and novelty audit.**
Every theorem family incorporated after C562 was compared against the
closest located prior art.  The exact all-prime-power MDS/CSS LU rigidity
and odd-prime diagonal-isodual group dichotomy remain the paper's strongest
family-specific contribution, but no firstness claim is added.  The
introduction now credits Wirthmüller for connected binary stabilizer
automorphisms and projective finiteness, Anderson--Jochym-O'Connor for
qubit diagonal/inter-code transversal restrictions, and Sayginel et al.
for automorphism-derived logical Cliffords with phase correction and
logical-action recovery.  The audit records 17 individually discussed
sources, exact search queries, read depths, cache hashes, authorized
wording, and MathSciNet/Google Scholar/zbMATH gaps.  See
`2026-07-25-c647-ame-lu-post-c562-novelty-audit.md`.

**C645 closed (2026-07-25): artifact-aware minor revision and literature
positioning.**  The abstract now ranks the arbitrary-length LU-to-LC
theorem, factorwise transversal no-go, and exact diagonal-isodual group
dichotomy ahead of the \(m=3\) applications.  The introduction compares
the exact scope of Dasu--Burton's qubit multiblock matrix-algebra
classification and adds the classical GIT double-cover/Igusa-quartic/
Segre-cubic interpretation of the six-point phase theorem.  The trust
section now distinguishes internal independent checks from external
reproduction, stale Section 6 theorem numbers are corrected, and the two
foreign Lean workflow reverse references are removed.  No new theorem
branch was added.  Public deposit remains an author gate.  See
`2026-07-25-c645-ame-lu-minor-revision-literature-positioning.md`.

**C642 closed (2026-07-25): referee proof repair and post-repair cold reads.**
The false linear identity \(N(T)=T\rtimes C_2\) was replaced by the exact
odd-characteristic relation \(J^2=-I\), \(N(T)/T\cong C_2\); the separate
projective party extensions in the twelve C624 examples still split.  The
stabilizer-character phase correction and the exact Weyl-block relations
are now kernel checked.  The conic matching/involution six-bound is a
standalone case lemma, the trust presentation has exact replay commands and
a compact table, the current 2026 transversal-Clifford comparison is in the
introduction, and the generic-constancy statement now distinguishes its
geometric open from finite rational points.  Full Lean, TeX, evidence, and
release gates passed.  Two fresh readers independently identified
stabilizer-AME rigidity, a global prime-field MDS--CSS orbit theorem modulo
duality, and higher-dimensional Veronese phase geometry as the best new
targets; none was silently added to this version.  See
`2026-07-25-c642-ame-lu-referee-repair.md`.

The paper-preparation scaffold is under `papers/ame_lu/`.  It follows the
`beyond4_prs` preparation system: the manuscript is subordinate to a theorem
adoption map, a claim/proof/novelty ledger, a verification map, an adversarial
audit, a formalization ledger, and an explicit draft-fix plan.

The source results are complete crowns reports C374, C396, C397, C402, C546,
C548, and C550.  They establish:

- the six-arc/MDS/CSS/AME dictionary and exact H3 separation from GRS states;
- classification of local-Clifford classes in the admitted non-GRS pencil by
  the scalar `z`;
- the split-torus versus `SL_2(q)` logical-Clifford phase;
- uniform marginal-moment separation of good H3 reductions from the GRS locus;
- a four-copy arbitrary-LU separator at `q=13`; and
- the transport-sheaf derivation of the rank-drop divisor and its orbit
  multiplicities.

The paper does **not** yet claim uniform `LU=LC`.  Its highest-value theorem
gate is restricted orbit coincidence inside the admitted pencil:

```text
Psi_t ~LU Psi_u  iff  Psi_t ~LC Psi_u  iff  z(t)=z(u).
```

This means equality of equivalence relations on the family, not that every
local-unitary intertwiner is Clifford.

**C559 closed negatively (2026-07-24): fixed-copy contraction invariants
cannot recover the pencil coordinate generically.**  For an equal-phase
linear-code state every permutation contraction has the exact value
`q^(km-rank M_sigma(G))`.  Hence every fixed-copy party-orbit invariant is
constant on the common generic-rank stratum; at four copies its generated
subfield of `Q(t)` is the constant field, not `Q(z)`.  C548/C550's
`(z-2)(9z-4)` remains an exact rank-jump divisor, not a rational coordinate.
This closes only the proposed proof route.  See
`2026-07-24-c559-ame-lu-invariant-field-gate.md`.

**C560 closed positively (2026-07-24): every LU intertwiner is LC.**  On any
four parties, MDS shortening gives a `q^2` stabilizer subgroup whose
nonidentity correlation tensor is diagonal on the full `q^2-1` local Weyl
basis.  The rank-one contraction axes of this four-way tensor are intrinsic,
so a product-unitary equivalence forces every local adjoint action to permute
Weyl axes and hence be Clifford. This holds for equal-phase CSS states of
all linear `[6,3,4]_q` MDS codes over every prime power. Combined with C396
and C571's full-Clifford correction, the admitted odd-prime-field pencil
satisfies `LU iff LC iff z equality`; over extension fields Frobenius is
already an additional local Clifford and the scalar classification is not
claimed. Two four-party marginals covering all six parties suffice. See
`2026-07-24-c560-ame-lu-orbit-rigidity.md` and
`2026-07-24-c571-ame-lu-adversarial-second-draft.md`.

**C561 closed (2026-07-24): theorem package and architecture frozen.**  The
title is *Local-Unitary Rigidity and Clifford Geometry of Six-Qudit AME
Stabilizer Tensors*.  C560 is the headline theorem; C396's `LU iff LC iff z`
is its admitted-pencil corollary.  Logical operations, explicit LU
certificates, fixed-copy generic constancy, and the transport divisor are
subordinate results. The synchronized boundary table now distinguishes the
all-prime-power rigidity theorem, the odd-prime-field quantum pencil
classification, the all-odd-field classical quotient, and detector-only
exceptional characteristics. See
`2026-07-24-c561-ame-lu-theorem-freeze.md`.

**C562 closed (2026-07-24): qualified LU-rigidity novelty boundary.**
Rains's qubit `[[2m,2m-2,2]]` theorem already uses rank-one recovery of a
diagonal three-Pauli tensor, and Van den Nest--Dehaene--De Moor turn it into
a minimal-support LU-to-LC criterion.  No screened source states C560's
full `q^2-1` Weyl-axis extension or its all-prime-power linear
`[6,3,4]_q` MDS/CSS theorem.  The manuscript may claim this exact scope
only with “to our knowledge,” must credit the Rains--Van den Nest mechanism,
and must retain “equal-phase CSS”; arbitrary phased `AME(6,d)` states have
infinitely many LU classes.  See
`2026-07-24-c562-ame-lu-literature-audit.md`.

**C563 closed (2026-07-24): paper-local computational evidence complete.**
The seven adopted computational bundles C374, C396, C397, C402, C546, C548,
and C550 now have byte-identical generators and canonical JSON certificates
under `papers/ame_lu/supplement/evidence/`.  The manifest checks fifteen
load-bearing files, including C396's previously hidden hash-pinned C395 input.
`verify.py --replay` checks all hashes and regenerates all seven certificates
in memory; the complete standard-library replay passed under Python 3.13.12.
The claim-level report records every domain, independent path, negative scope,
and trust boundary.  See `2026-07-24-c563-ame-lu-evidence-package.md`.

**C564 closed (2026-07-24): complete first manuscript draft.**  All eight
sections now carry the frozen theorem spine: the title-page LU-intertwiner
theorem, arc/MDS/CSS/AME dictionary, full-Weyl axis proof, exact
`z`-classification, logical phase, H3 and q=13 LU certificates, fixed-copy
generic constancy, transport divisor, and verification boundary.  Every stable
label is synchronized with the ledgers.  `make check` produced a warning-free
11-page PDF (132,775 bytes; SHA-256
`a23aa69c7e55ccaf12135d517f35b98092f26d300f81c40e376de897bb187da3`);
pages 1, 6, and 11 passed visual inspection.  The remaining proof-
reconciliation and exposition risks are assigned to C565--C571 in the
second-draft plan.  See `2026-07-24-c564-ame-lu-first-draft.md`.

**C565 closed (2026-07-24): shared Lean convention interface complete.**
`RelativeConicArcs.AMELU.Definitions` now fixes ordered six-arcs, exact
`[6,3,4]` kernels, normalized equal-phase states, subsystem marginals and
AME, all projective/monomial/party/LU/LC action directions, the
`X(a)Z(b)` Weyl convention, and the exact finite-field trace phase.  Its
import-only gate passed guarded elaboration and the trace-only aggregate
check.  No manuscript theorem is assumed by the data structure.  See
`2026-07-24-c565-ame-lu-lean-foundation.md`.

**C590 closed (2026-07-24): CSS support and dictionary bridges complete.**
`RelativeConicArcs.AMELU.CSS` fixes `L_C=C×C^\perp`, Pauli support, and
`L_C(S)`.  `RelativeConicArcs.AMELU.Dictionary` proves six-arc to exact
`[6,3,4]`, `[6,3,4]` to AME, projective to monomial, and monomial to
local-Clifford coherence with explicit multiplier matrices.  The final
import gate and standard-axiom audit passed.  The full manuscript dictionary
still needs the stabilizer-action, Lagrangian, minimum-support, and AME
converse clauses before formal adoption; these are now queued as C591.  See
`2026-07-24-c590-ame-lu-lean-dictionary-bridges.md`.

**C591 closed (2026-07-24): shared Lean stabilizer dictionary complete.**
`RelativeConicArcs.AMELU.StabilizerDictionary` identifies the six-fold
tensor Weyl action, proves the full `C×C^\perp` stabilizer equation and its
separate `X(C)` and `Z(C^\perp)` cases, proves the CSS space is a
six-dimensional symplectic Lagrangian, and closes the exact `L_C(S)` support
criterion.  It also proves the universal `q^3` computational-support lower
bound for six-party AME states, minimality of exact-code equal-phase states,
and the converse
`IsAME (equalPhaseState C) ↔ IsMDSCode634 C`.  The measured import gate,
trace-only aggregate gate, exact no-build checks, and standard-axiom audit
passed.  The complete manuscript dictionary is now formalized; C570 owns
aggregate adoption and reconciliation.  See
`2026-07-24-c591-ame-lu-lean-stabilizer-closure.md`.

**C566 closed (2026-07-24): admitted-pencil classification interface
complete.**  `RelativeConicArcs.AMELU.PencilClassification` defines the
ordered pencil, its five-factor admitted non-GRS locus, `A`, `B`, `y`, and
`z`; proves the exact four-branch algebraic quotient
`z(t)=z(u) iff y(u) in {±y(t),±y(t)⁻¹}`; and derives the
projective/monomial/LC classification from a structure that names the
six-arc, explicit-projectivity, bracket-invariance, and LC-holonomy inputs
separately.  Its import gate, trace-only aggregate check, no-build probes,
and standard-axiom audit passed.  See
`2026-07-24-c566-ame-lu-lean-lc-classification.md`.

**C567 closed (2026-07-24): marginal-moment separator interface
complete.**  `RelativeConicArcs.AMELU.MarginalMoment` defines the concrete
sum of three CSS supported-label spaces and its rank; checks the exact
455/60/15 six-party graph counts; and proves the `60+b` concurrency
reduction, rank-four trace specialization, and exact `70>66`
LU-separation implication.  The density-matrix trace expansion,
incidence/rank bridge, H3 ten-count, GRS six-bound, and LU covariance are
named hypotheses rather than hidden axioms.  The warning-free import gate,
trace-only aggregate gate, no-build probes, and native-aware axiom audit
passed.  See `2026-07-24-c567-ame-lu-lean-marginal-moment.md`.

**C568 closed (2026-07-24): logical phase and exact four-copy separator
interface complete.**  `RelativeConicArcs.AMELU.LogicalPhase` proves the
fixed-party kernel is `SL_2` on the conic locus and the diagonal split torus
off it from four explicit propagation hypotheses; the party-moving
isoduality/normalizer clause remains a manuscript proof input.
`RelativeConicArcs.AMELU.FourCopyContraction` defines the concrete matching
linear map and rank, exact q=13 generators and four-copy pattern, and the
party-orbit rank formula; it also proves the orbit sum is independent of
party relabelling of the seed pattern and proves that common bra-copy
relabelling normalizes the first copy permutation to the identity without
changing rank.  Its terminal derives arbitrary-LU inequivalence from explicit
`720/13^9` and `3024/13^9` certificate inputs.  The import gate, exact
no-build checks, and standard-axiom audit passed.  See
`2026-07-24-c568-ame-lu-lean-logical-phase.md`.

**C569 closed (2026-07-24): transport divisor interface complete.**
`RelativeConicArcs.AMELU.TransportDivisor` defines the parametric reduced
`9 × 9` block operator; proves all three cycle-polynomial factorizations,
the exact `(B^2-2A^2)(9B^2-4A^2)` and `(z-2)(9z-4)` divisor identities,
the rank-excess arithmetic, and the characteristic-seven doubled scheme and
zero-set merger; and derives the `96+192=288` merged support count from
explicit orbit-geometry inputs.  The determinant expansions, systematic
rank bridge, generic kernel dimension, and double-coset recognition remain
named hypotheses.  The import gate, exact no-build checks, and standard-axiom
audit passed.  See
`2026-07-24-c569-ame-lu-lean-transport-divisor.md`.

**C570 closed (2026-07-24): aggregate formal audit and statement
adequacy complete.**  `RelativeConicArcs.Gates.AMELUAggregate` imports all
seven adopted AME formal packages in one environment, and
`AMELUAggregateAxioms` audits 33 paper-facing declarations.  Outside the
three native marginal graph counts, the audit reports only `propext`,
`Classical.choice`, and `Quot.sound`; the native declarations expose their
three exact toolchain-local axioms.  The new
`formal-statement-adequacy.md` maps every manuscript label to exact Lean
declarations and distinguishes unconditional coverage, conditional
interfaces, and unformalized paper proofs.  Section 8 and all formal trust
ledgers now use the same boundary.  The measured aggregate/no-build gates
and warning-free `make check` passed.  See
`2026-07-24-c570-ame-lu-lean-aggregate-audit.md`.

**C571 closed (2026-07-24): adversarial second draft and independent cold
read complete.** The proof/evidence audit repaired the LC-holonomy,
logical-phase, marginal-incidence, generic-constancy, and party-dependent
transport arguments; mapped every conditional formal input field to exact
prose/evidence; replayed all seven evidence bundles; and produced a
warning-free, visually inspected 15-page PDF. The independent reader found
the release-blocking extension-field Frobenius counterexample: Theorem 1.1
remains all-prime-power, while `LC iff LU iff z` and the full logical-phase
theorem are now restricted to odd prime fields. A final cold read returned
GO. A localized Milnor/Serre-style sweep then tightened the abstract and
logical-phase transition without changing theorem scope. See
`2026-07-24-c571-ame-lu-adversarial-second-draft.md`.

**C580 closed (2026-07-24): bounded scalar blindness versus marginal
covariant rigidity.**  For every fixed copy bound `M`, outside finitely many
`M`-dependent characteristics and for all sufficiently large `q`, at least
`ceil((q-d_M)/8)` admitted LU classes agree on every scalar LU invariant
through bidegree `(M,M)`, and hence on every outcome distribution of an
`M`-copy LU-invariant measurement.  C559's common generic-rank open and
C396's degree-eight quotient give the growing packet, while C560 shows that
the algebraic-degree-one four-party marginal covariants nevertheless
separate its classes by retaining the local Weyl axes.  This is not a
single-specimen tomography claim.  Haar-randomizing an unknown local frame
also makes the class label independent of every arbitrary `M`-copy
measurement transcript, by twirling its POVM into the blind invariant
sector.  Equivalently, the packet is a linearly growing family of
pairwise monomially inequivalent MDS codes with identical complete
contraction-rank profiles through copy degree `M`; a uniform class label has
zero mutual information with every `M`-copy LU-invariant scalar transcript.
This remains an optional synthesis corollary, not a change to C561's
headline.  See
`2026-07-24-c580-scalar-covariant-separation.md`.

**C572 closed (2026-07-24): reproducible local release candidate.** The
paper-only public tree and formal Lean companion have separate immutable
SHA-256 identities. A deterministic exporter produces a complete scholarly
bundle and a minimal arXiv source bundle; clean source rebuilds the tracked
15-page PDF byte for byte, and the complete evidence replay passes from the
extracted public bundle. Quantum and arXiv policy checks leave only author
decisions: public identifier, name/affiliation/ORCID, funding and
contribution/AI disclosure, license/category, rights, account readiness, and
explicit upload or submission authorization. No external action was taken.
See `2026-07-24-c572-ame-lu-release-candidate.md`.

**C594 closed (2026-07-24): external major revision adopted.**  The C572
candidate is superseded pending a second independent review.  Theorem 4.1 now
handles the \(A^2=B^2\), \(z=1\) collapsed bracket multiset explicitly.
Theorem 5.1 replaces its asserted propagation step by a proved
distance-four diagonal-multiplier lemma and explicit elementary-unipotent
generation.  Section 7 now distinguishes the exact \(Q_p\) from its
\(2(t-1)\)-scaled polynomial representative and uses the correct \(p=\pi\)
index convention.  The logical phase is promoted to the title and abstract,
the transport material is compressed, and the literature now includes
Coble/Dolgachev--Ortland, Segre/Hirschfeld/Ball--Lavrauw, and
polynomial/quantum Reed--Solomon and transversal-gate context.  The
warning-free 15-page build and all seven evidence replays pass.  See
`2026-07-24-c594-ame-lu-major-revision.md`.

**C598 closed (2026-07-24): scope and self-containedness revision.**  The
promoted logical-phase claim now carries its odd-prime-field restriction in
both the abstract and introduction, while the LU-to-LC theorem remains
all-prime-power.  Theorem 6.1 now proves its characteristic-\(3,5\) clauses by
explicit subgroup and polynomial arguments.  The redundant transport
calculation has moved to Appendix A; its orbit--stabilizer quotients,
support-disjointness argument, and characteristic-\(3,5,7\) identities are
restored.  The novelty-search sentence is narrowed to its actual coverage,
and the Aharonov--Ben-Or and Ball--Lavrauw records are corrected.  The
warning-free 16-page build, rendered-page inspection, and seven-bundle replay
pass.  See `2026-07-24-c598-ame-lu-scope-self-containedness.md`.

**C599 closed (2026-07-24): local re-review closure.**  Section 5 now
restricts the displayed \(\mathcal K_C\subseteq\mathrm{SL}_2(q)^6\) kernel at
first use and contrasts the full extension-field
\(\mathrm{Sp}_{2e}(\mathbb F_p)\) action.  Theorem 6.1 uses only the proved
sharp bound \(b\leq6\) and records its octahedral equality case.  The
introduction credits established quantum Reed--Solomon, polynomial-code, and
general stabilizer gate constructions while identifying the paper's
contribution as the fixed-party self-association iff classification.  Dickson
and Faber now receive their exact finite-field/general-field roles, and
Section 2 proves that six-arcs exist exactly for \(q\geq4\) without adding an
inert theorem hypothesis.  The warning-free 16-page build, five-page visual
sweep, seven-bundle replay, and public/formal release checks pass.  See
`2026-07-24-c599-ame-lu-local-review-closure.md`.

**C600 closed (2026-07-24): final local referee corrections.**  Theorem 6.1
now exposes characteristic-five vacuity in its statement and conditions the
octahedral equality example on the required \(S_4\) subgroup.  Proposition
6.3 separates the parameter field, its cardinality, and local dimension.
The introduction links the redundant appendix witness to Corollary 1.2 and
states the bounded literature-search scope for the logical-phase comparison.
The Aharonov--Ben-Or Section 5 and Dickson §§239--261 locators remain
confirmed.  The warning-free 16-page build, all seven evidence replays, and
public/formal release checks pass.  See
`2026-07-24-c600-ame-lu-local-referee-corrections.md`.

**C609 closed (2026-07-25): uniform version-1 headline adopted.**
The LU-to-LC theorem now holds for every prime power, every \(m\geq2\), and
every existing linear `[2m,m,m+1]_q` MDS/CSS equal-phase state.  Its Choi
corollary proves that the associated `[[2m-1,1,m]]_q` quantum MDS code has
only Clifford product logical implementations, with every physical factor
Clifford.  The proof uses the same rank-one axis mechanism after the general
dual shortening `[2m,m,m+1] -> [m+1,1,m+1]`; the six-party pencil and
logical-phase scopes are unchanged.  The warning-free 17-page build and
release gates pass.  The formalization is split into C601's generic
foundations, C612's rigidity terminal, C613's Choi/transversal terminal, and
C615's projective automorphism group packaging
before C602's aggregate audit.  See
`2026-07-25-c609-ame-lu-uniform-rigidity-v1.md`.

**C614 closed (2026-07-25): higher-\(m\) applications adopted.**
The transversal corollary now covers conversions between two associated
encoders, and product-unitary state symmetries are projectively finite.  For
odd prime \(q\) and \(2m\le q+1\), the GRS/extended-GRS quantum-MDS tower has
exact projective transversal logical group
\(\mathbb F_q^2\rtimes\mathrm{SL}_2(q)\); the extended
`[8,4,5]_7` code gives the explicit `AME(8,7)` / `[[7,1,4]]_7` order-16464
case.  The manuscript has the operational title *Local-Unitary Rigidity
and Transversal Clifford Groups for MDS--CSS AME States*.  The
warning-free 18-page build, visual copy edit, seven-bundle
replay, and public/formal release checks pass.  C612 and C613 have since
closed the rigidity, encoder, exact-group-interface, and explicit-example
formalization.  See
`2026-07-25-c614-ame-lu-higher-m-applications.md`.

**C612 closed (2026-07-25): general rigidity and discrete symmetry formalized.**
The length-generic Lean development now proves the exact shortened marginal
expansion, local-unitary marginal covariance, arbitrary-arity tensor-axis
rigidity, the retained-coordinate cover, and the unconditional LU-to-LC
terminal for every prime power and every \(m\geq2\).  The six-party and
admitted-pencil terminals are recovered from the generic theorem.  The
projective one-site Clifford quotient is finite; consequently the product
automorphism quotient is finite, and its identity component before quotient
is exactly the torus of one-site scalar phases.  Both statements remain true
after adjoining party permutations.  The warning-free aggregate build and
axiom audit pass.  See
`2026-07-25-c612-ame-lu-lean-general-rigidity-terminal.md`.

**C615 closed (2026-07-25): projective automorphism groups packaged.**
The fixed-party and party-permuted product-unitary automorphism carriers are
now explicit topological groups, with the latter using the proved
semidirect-product law.  Independent scalar phases form a central subgroup
in the fixed-party group and a normal subgroup after party permutations.
Both scalar quotients are explicit quotient groups, their projectivizations
are continuous group homomorphisms, their exact finite signature detectors
are continuous maps, and C612's finiteness and identity-component terminals
transfer without changing scope.  The aggregate gate and axiom audit pass
with only `propext`, `Classical.choice`, and `Quot.sound`.  See
`2026-07-25-c615-ame-lu-projective-automorphism-group-packaging.md`.

**C613 closed (2026-07-25): encoder and transversal Clifford bridge formalized.**
`RelativeConicArcs.AMELU.EncoderTransversal` proves the one-leg
`[[2m-1,1,m]]` parameter bridge, exact `((Lᵀ)⁻¹⊗U_phys)` Choi orientation,
canonical inverse transpose from logical unitarity, Clifford
adjoint/conjugation/transpose closure, and factorwise logical/physical
Cliffordness.  It also checks the diagonal-duality CSS shears, arbitrary
upper/lower unipotent coefficients, conditional exact
`𝔽² ⋊ SL₂(𝔽)` carrier equality, and order-16464 specialization.  The exact
GRS terminal retains the concrete code construction, phase-corrected lifts,
Pauli representatives, elementary generation, and converse as named inputs.
The warning-free aggregate build, axiom audit, and 18-page manuscript build
pass.  See `2026-07-25-c613-ame-lu-lean-transversal-clifford.md`.

**C617 closed (2026-07-25): scalar-torus exact sequences and discrete
quotients formalized.**
`RelativeConicArcs.AMELU.AutomorphismExactSequence` proves the fixed-party
and party-permuted scalar tori closed and normal; packages their injective
inclusions, surjective projectivizations, exact pairs, and finite discrete
quotients; replaces the detector maps by continuous homomorphisms into
intrinsic Clifford adjoint-signature groups with exact scalar kernels and
canonical realized-image identifications; and proves that the fixed-party
projective group is exactly the kernel of the realized party-permutation
quotient.  The splitting boundary is exact: it requires a homomorphic right
inverse, while C613's phase-corrected generator representatives do not supply
that coherence.  The aggregate gate, axiom audit, and warning-free visually
inspected 19-page manuscript pass.  See
`2026-07-25-c617-ame-lu-automorphism-exact-sequence.md`.

**C602 closed (2026-07-25): full Lean/trust/style audit complete.**
Both scalar inclusions are now continuous homomorphisms; the intrinsic
Clifford adjoint quotient has a closed scalar kernel and formal
Hausdorff/discrete topology; and both automorphism groups have explicit
finite covers by scalar-torus connected components.  The paper and formal
sources distinguish the homomorphic-right-inverse splitting criterion from
an extension-class obstruction.  The release manifest recursively pins all
72 project-owned files in the formal verification graph.  The AME--LU owned
layer is referee-prose clean, but two exact foreign-owned blockers remain:
`RelativeConicArcs/Plane.lean:7` reverse-references another paper directory,
and `FiniteGeom/Code.lean:16` cites an internal handoff/work phase.  The
aggregate gate, 100-declaration axiom audit, warning-free 19-page manuscript,
seven evidence replays, visual inspection, and 35-public/72-formal release
checks pass.  See
`2026-07-25-c602-ame-lu-full-lean-trust-audit.md`.

**C618 closed (2026-07-25): nonabelian extension invariant formalized.**
The realized party-permutation exact sequence now has a canonical
section-free outer action on the fixed-party projective group.  A normalized
choice of lifts has an explicit nonabelian factor set; Lean proves its
normalization, associativity identity, ordered change-of-section law, and
choice-independent trivializability.  Trivializability is equivalent to a
homomorphic section and hence to splitting, with no abelian-kernel shortcut.
The aggregate axiom audit and warning-free 19-page manuscript/release gates
pass.  See
`2026-07-25-c618-ame-lu-nonabelian-extension-class.md`.

**C619 closed (2026-07-25): GRS split-versus-obstruction boundary exact.**
For generalized and extended GRS codes, propagation from any chosen input
block is coordinatewise conjugation by
`\(\operatorname{diag}(1,s_i/s_j)\)`, so all `SL_2(q)` relations hold
exactly.  In odd characteristic the finite Heisenberg representation has a
genuine Weil extension, and the scalar extension therefore splits over the
linear `SL_2(q)` factor.  It does not split over the full affine one-qudit
group: the nontrivial Weyl commutator obstructs a homomorphic lift of
`\(\mathbb F_q^2\)`.  This is a Heisenberg obstruction, not a residual
metaplectic or Schur-multiplier obstruction.  C618's party-permutation
extension is independent and remains governed by its code-specific
nonabelian factor set.  No finite computation was needed.  The warning-free
20-page manuscript, seven evidence replays, 35-public/73-formal release
checks, and trust ledgers are synchronized.  The manuscript now also isolates
the reusable full-Weyl marginal-cover criterion and states the exact
fixed-party projective six-arc groups:
`\(\mathbb F_q^2\rtimes\mathrm{SL}_2(q)\)` on the GRS locus and
`\(\mathbb F_q^2\rtimes T\)` off it; no uniform party-moving equality is
claimed.  `all_isClifford_of_fullWeylDiagonal_intertwining` now formalizes
the reusable local criterion, while
`fixedPartyProjectiveTransversal_eq_affineSpecialLinear_or_splitTorus`
formalizes the exact affine carrier from the explicit complete-translation
fiber hypothesis.  Both are included in the aggregate axiom audit, which
passes with only `propext`, `Classical.choice`, and `Quot.sound`.  See
`2026-07-25-c619-ame-lu-grs-splitting-obstruction.md`.

**C622 closed (2026-07-25): diagonal isoduality is the intrinsic
all-length logical phase.**  For every odd-prime linear
`[2m,m,m+1]_q` MDS code, the exact fixed-party projective transversal
logical group is `F_q^2 ⋊ SL_2(q)` precisely when `SC=C^perp` for a
nonsingular diagonal `S`, and `F_q^2 ⋊ T` otherwise.  The proof extends
the diagonal-multiplier lemma to arbitrary `m`, proves the off-diagonal
converse and complete translation fiber, and moves the coherent Weil lift
from the GRS presentation to the entire diagonally isodual branch.
The diagonal-duality witness space has dimension zero or one, giving a
linear nullity test, projective uniqueness of the propagation ratios, and
the hyperbolic-form obstruction
`\(\det S\in(-1)^m(\mathbb F_q^\times)^2\)`.
The manuscript and trust ledgers now use this intrinsic boundary.
`EncoderTransversal` packages the exact conditional carrier terminal with
no GRS evaluation hypothesis, and the aggregate axiom audit passes with
only `propext`, `Classical.choice`, and `Quot.sound`.  See
`2026-07-25-c622-ame-lu-diagonal-isoduality-dichotomy.md`.

**C631 closed (2026-07-25): diagonal-isodual multiplier space formalized.**
`DiagonalIsoduality` proves that every nonzero diagonal multiplier between
exact `[2m,m,m+1]` MDS codes has full support and induces a code
isomorphism.  The multiplier space has dimension at most one; its self-code
specialization is exactly the scalar line, and its code-to-dual
specialization has nullity zero or one.  Diagonal isoduality is exactly the
nullity-one case.  A nonzero multiplier reconstructs the duality witness,
the scalar relating two witnesses is unique, all coordinate ratios are
canonical, and one realized nondiagonal block forces the full affine
special-linear carrier through the existing action interface.  The aggregate
gate and axiom audit report only `propext`, `Classical.choice`, and
`Quot.sound`.  See
`2026-07-25-c631-diagonal-isoduality-corollaries-lean.md`.

**C624 closed (2026-07-25): concrete party-permutation extensions split.**
The exact fixed and party-moving projective groups, normalized nonabelian
factor sets, outer actions, trivializing cochains, and complements are now
computed for both q=11 pencil classes, all four representative q=11 GRS
evaluation-set orbits, the q=17 and q=31 enhanced-symmetry rows, and four
split-prime integral H3 representatives.  The q=11 party groups are
`S5`, `S4`, `V4`, `C5`, `S3`, and `D12`; every listed extension splits.
On every non-GRS/H3 row, odd party motion inverts the fixed split torus and
enlarges the logical linear group exactly from `T` to `N(T)`.  The complete
factor tables and complement witnesses are reproducible and remain separate
from the Weil and Heisenberg scalar extensions.  No manuscript source was
edited.  See `2026-07-25-c624-ame-lu-party-extension-examples.md`.

**C629 closed (2026-07-25): split party-extension consequences formalized.**
`PartyExtensionSplitting` constructs the explicit normalized cochain that
trivializes a chosen factor set from any homomorphic complement, proves the
semidirect-product equivalence, unique kernel--quotient coordinates, exact
cardinality product, and the inverting-involution witness behind
`T`-to-`N(T)`.  The realized AME--LU specialization is imported through both
the dedicated and main aggregate gates; the axiom audit reports only
`propext`, `Classical.choice`, and `Quot.sound`.  The twelve concrete C624
complements remain honestly external exact computations until a generated
finite-table checker supplies the formal splitting witnesses.  No manuscript
source was edited.  See
`2026-07-25-c629-ame-lu-party-extension-formalization.md`.

**C623 closed negatively at its reconstruction gate (2026-07-25):
extension-field Clifford census complete.**
Frobenius-sector decoupling proves for every odd prime power that admitted
non-GRS LC orbits are exactly Galois orbits of `z`; the exhaustive
`q=9,25,27` census is the falsifier and witness package.  This equality of
partitions hides genuine nonsemilinear maps.  Every `q=9` non-GRS pair has
such a witness; the fixed-party kernel
has order 96 with only 16 semilinear elements.  At `q=25` the GRS kernel is
the full `Sp_4(5)` of order 9,360,000, while non-GRS kernels have order 24;
at `q=27` they have order 26.  The shortened planes therefore do not
reconstruct the Desarguesian spread, so no positive reconstruction theorem
was attempted.  The extra-juice pass identifies the order-96 kernel as a
central `C4`-extension of `S4` with commutator `SL_2(3)`, and promotes the
shortened-transport commutant dimension as the replacement exact invariant:
generic dimension `2e`, dimension 8 at the `q=9` non-GRS exception, and the
full dimension 16 at the `q=25` GRS boundary.  The mystery investigation
decomposes this commutant by Frobenius exponent and proves that the
off-diagonal `k`-twist appears exactly on
`((1-t^(p^k))(1-t))^2+t^(p^k+1)=0`; at `k=0` this is the GRS quartic, while
the `q=9,k=1` divisor gives the extra Frobenius--Gale sector.  The diagonal
`k`-twist appears exactly on
`(t^(p^k)-t)(1-t^(p^k+1))=0`; together the two divisors account for every
fixed-party additive intertwiner degree of freedom.  C581 treats these
enlarged-kernel strata separately.  The exact standard-library replay,
witnesses, kernel invariants, and mystery ledger are in
`2026-07-25-c623-ame-lu-extension-field-clifford.md`.  No manuscript source
was edited.

**C633 closed (2026-07-25): extension-field pencil-sector algebra
formalized.**
`RelativeConicArcs.AMELU.ExtensionFieldPencil` proves the diagonal
Frobenius-sector divisor, the Frobenius--Gale divisor, its explicit
six-coordinate multiplier and odd-characteristic zero criterion, and field-
automorphism equivariance of the GRS quartic and pencil invariant `z`.  It
also proves that diagonal and Gale modes are disjoint at each individual
Frobenius exponent on the admitted non-GRS locus, while allowing the
different-exponent coexistence responsible for the exceptional kernels.  It
packages the all-odd-prime-power Galois-`z` orbit theorem through two
explicitly named bridges: extraction of a projective Frobenius sector from an
additive Clifford equivalence, and construction of a Clifford from a Galois
match.  Those representation-theoretic bridges remain conditional; the
scalar geometry and theorem composition are kernel checked.  A dedicated
import gate and axiom audit passed without modifying the manuscript.  See
`2026-07-25-c633-ame-lu-extension-field-frobenius-lean.md`.

**C640 closed (2026-07-25): extension-field sector algebra adopted under a
strict Lean-completeness rule.**
Section 4 now states the exact diagonal and Frobenius--Gale divisors, explicit
six-coordinate Gale multiplier, same-exponent sector disjointness, and
automorphism equivariance of the pencil data.  All adopted clauses are
unconditional in `ExtensionFieldPencil` and are imported through the main
aggregate and axiom audit.  The full Galois-`z` Clifford-orbit theorem remains
outside the manuscript because its sector-extraction and Clifford-construction
bridges are conditional.  The unformalized C631 generator-matrix/Veronese
remark and its \(m=2,3\) consequences were removed, while the kernel-checked
intrinsic multiplier-line theorem remains.  The warning-free 23-page build,
eight evidence replays, visual inspection, and 37-public/80-formal release
checks pass.  See
`2026-07-25-c640-ame-lu-extension-field-adoption.md`.

**Post-C619 two-reader frontier (2026-07-25): exact and quantitative
frontiers closed.**
Two independent manuscript-only cold reads converged on the same research
frontiers.  C622 has proved the length-generic diagonal-isoduality
dichotomy, C624 has computed the first party-moving extensions, and C623 has
closed the extension-field reconstruction route negatively.  C581 has now
proved quantitative ambient-Clifford rigidity while ruling out the failed
exact spread-reconstruction target even at zero error.  The complete
synthesis, secondary questions, underdeveloped
connections, and EV rationale are in
`2026-07-25-ame-lu-two-cold-read-frontier.md`.

## Completion program

The complete preparation, audit, formalization, and release program through
C619 is closed.  Dependency order is authoritative:

1. C559--C560: fixed-copy obstruction and uniform LU/LC rigidity theorem
   (complete).
2. C561: theorem, title, exception-table, and architecture freeze.
3. C562--C563: claim-specific literature audit and paper-local evidence import.
4. C564: first complete manuscript draft and warning-free PDF.
5. C565, C590, and C591: shared Lean foundation and complete dictionary;
   C566: pencil classification interface; C567--C569: remaining theorem
   packages (complete).
6. C570: aggregate import, axiom audit, and manuscript reconciliation
   (complete).
7. C571: adversarial audit, second draft, PDF inspection, and cold read
   (complete).
8. C572: clean replay, immutable manifest, public export, and release gates
   (complete, superseded by C594).
9. C594: external major-revision proof, convention, positioning, and
   literature sweep (complete; independent re-review pending).
10. C598: front-matter scope, self-contained exceptional arithmetic, and
    appendix disposition (complete).
11. C599: final local field-scope, involution-bound, attribution, existence,
    and transversal-gate positioning closure (complete).
12. C600: final theorem-local scope, referent, parameter-setting, sharpness,
    and bounded search-scope corrections (complete).
13. C601: length-generic code/state/action API, exact MDS dual shortening,
    full-basis diagonal-axis theorem, and six-party compatibility foundation
    (complete).
14. C614: higher-\(m\) encoder conversion, discrete-symmetry, exact GRS-group,
    and explicit `[[7,1,4]]_7` applications (complete).
15. C612: shortened marginal expansion and covariance, general LU-to-LC
    terminal, six-party specialization, projective-finiteness, and
    scalar-phase identity-component corollary (complete).
16. C613: AME-to-`[[2m-1,1,m]]` encoder parameters, exact Choi orientation,
    Clifford transpose closure, transversal no-go, exact GRS group, and
    explicit `[[7,1,4]]_7` terminal (complete).
17. C615: explicit product-unitary and party-permuted topological groups,
    normal scalar-phase torus, quotient groups, and projectivization/signature
    maps preserving the C612 finiteness and identity-component terminals
    (complete).
18. C617: closed scalar-torus exact sequence, finite discrete quotient,
    intrinsic continuous signature homomorphisms, realized party-permutation
    extension, and splitting obstruction, using C613's GRS split where
    available (complete; the available GRS interface does not supply a
    coherent split).
19. C602: full AME-LU Lean/trust/style/standards audit and repair pass, after
    C617 (complete; two exact foreign-owned prose blockers recorded).
20. C618: canonical outer action, normalized factor set, nonabelian
    change-of-section law, and genuine splitting obstruction for the realized
    party-permutation extension, after C602 (complete).
21. C619: GRS/extended-GRS relation audit and exact
    split-versus-metaplectic/Schur-multiplier boundary, after C618 (complete).
22. C624: exact code-specific party-permutation groups, outer actions,
    normalized factor sets, splitting witnesses, and `T`-normalizer
    enlargements (complete).
23. C622: intrinsic all-length diagonal-isoduality dichotomy, arbitrary-length
    multiplier converse, complete translation fiber, manuscript adoption, and
    conditional evaluation-free Lean terminal (complete).
24. C623: extension-field `q=9,25,27` full additive-symplectic falsifier and
    nonsemilinear-kernel census (complete; spread reconstruction false).
25. C629: explicit cochain trivialization, semidirect decomposition,
    cardinality product, and torus-normalizer inversion witness in Lean
    (complete; concrete complements remain externally certified).
26. C633: extension-field pencil divisor algebra, Galois equivariance, and
    conditional additive-Clifford orbit interface in Lean (complete).
27. C640: adopt only the unconditional extension-field sector algebra,
    aggregate its Lean audit, and remove the unformalized C631 Veronese add-on
    (complete).

The revision has cleared the independent re-review findings and is complete
locally.  Public release waits on the author gates listed above. C581 has
closed the optional quantitative gate without manuscript adoption: ambient
additive-Clifford rigidity is stable, while C623's exact witnesses disprove
semilinear spread reconstruction.

C601--C615 close the paper's principal formalization gap in four acceptance
gates.  The full \(m=3\) prototype and pencil composition are already
unconditional in `RelativeConicArcs.AMELU.LURigidity` and
`RelativeConicArcs.AMELU.LUPencilClassification`.  C601 is complete:
`GenericDefinitions`, `GenericMDS`, and `GenericDiagonalTensor` provide the
length-generic code/state/action layer, exact dual `[2m,m,m+1]` shortening,
full-basis diagonal-axis theorem, and six-party compatibility.  C612 is
complete: the marginal expansion including the identity axis, covariance,
general Clifford terminal, compatible six-party/pencil specializations,
projective finiteness, and scalar-phase identity component are formalized.
C613 is complete: the one-leg quantum-MDS parameters, exact
Choi/transposition bridge, Clifford closure operations, transversal terminal,
GRS shear algebra, conditional exact carrier equality, and order-seven
specialization are formalized.  C615 upgraded C612's quotient carriers and identity-component
statements to explicit group/topological-group structures, normal scalar
phases, quotient groups, and structured projectivization/signature maps.  C617
has now packaged the closed exact sequences, discrete quotients, intrinsic
signature homomorphisms, realized party-permutation extension, and splitting
boundary.  C602 has completed the referee-facing audit of the AME-LU Lean
aggregate, trust ledgers, verification prose, scholarly closure, and release
claims.  C618 packages the section-free nonabelian party-permutation
invariant.  C619 separates it from the scalar lift problem: the GRS linear
symplectic factor splits by the odd-field Weil representation, while the full
affine one-qudit extension is non-split by the Heisenberg commutator.

**Token-constrained completion route:** the principal `ame-lu` Version-1
completion program is closed through C619.  The post-Version-1 diagonal
isoduality, party-extension, and extension-field frontiers C622/C624/C623
are complete, and C629 formalizes the reusable split-extension consequences.
C581 is complete as a separate quantitative-rigidity result, without an
exact spread-reconstruction assumption.  The next
cross-lane route remains C553 and then the coordinated build-system
extraction.  The authoritative three-session protocol is
`notes/2026-07-25-c287-token-efficient-execution.md`.

## Completion gates

1. Freeze the adopted theorem package and honest exceptional set.
2. Complete a claim-specific literature audit before novelty or priority
   wording.
3. Import every paper-facing computational claim as a committed report,
   generator, compact certificate, independent replay, and SHA-256 manifest.
4. Draft the manuscript with theorem labels synchronized to `theorem-map.md`.
5. Close the claim/proof/novelty and adversarial-evidence ledgers.
6. Run `make check`, inspect the PDF, and close the second-draft fix plan.
7. Complete a clean public replay/export plan and obtain a cold expert read.

## Allowed paths

- `papers/ame_lu/**`
- `lean/RelativeConicArcs/AMELU/**`
- `lean/RelativeConicArcs/Gates/AMELU*.lean`
- `notes/handoffs/2026-07-24-ame-lu-paper.md`
- `notes/2026-07-24-ame-lu-discovery-track.md`
- the exact report/output stem of an allocated `ame-lu` task

The completed crowns reports and their reproducibility bundles are read-only
inputs until deliberately imported into the paper evidence package.  Other
papers, handoffs, and Lean sources remain read-only unless the user expands
scope.

## Cross-lane relationships

- `crowns` retains the completed source reports as provenance.
- `ame-lu` owns the H3 AME/LU/LC results, including theorem adoption,
  manuscript exposition, verification, and every future quantum-equivalence
  refinement; it also owns the remaining paper synthesis and release
  preparation.
- Any future Lean work requires its own allocated `ame-lu` task and the nested
  Lean guide before action.
