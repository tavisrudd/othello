# Cold-read adversarial referee report — Clebsch rigidity (Paper I + computational companion)

Date: 2026-08-03
Referee: independent cold read, no prior project context
Artifacts: `papers/clebsch-rigidity/clebsch_rigidity.pdf` (25 pp) and
`papers/clebsch-rigidity/clebsch_rigidity_computational_companion.pdf` (13 pp), plus the
formal side under `lean/` and `papers/clebsch-rigidity/verification/`.

---

## VERDICT

**MINOR REVISIONS** (main manuscript alone would be close to ACCEPT; the companion carries
the defects that pull the pair down).

Decisive reasons.

The mathematics is, on the evidence I could check, correct and unusually tightly wired. I
re-derived by hand or by exact computation essentially every displayed number and identity
in the main manuscript — the chord-defect identity and its defect bound, the field window
and both of its sharpness cases, the concurrence-spectrum partition arithmetic, the whole
`A_5` point-orbit table, the coset-leader and weight-enumerator distributions, the golden
normal form's polarity values over `Z[phi]`, and every identity in the orientation section
including `B^2 = 5I`, `det B = -125`, the eigenblock relations `B U(t_pm) = pm sqrt5 U(t_pm)`,
`det(Phi_x) = -C(x)`, and the diagonal determinant pencil. All of them hold exactly. The
q = 23 sharpness configuration also verifies exactly. This is a paper whose numerical spine
is sound.

Three things stop it from being an accept as-is.

First, the computational companion restates the main paper's conic-filling window as
"[9, Theorem 3.2]", but in the manuscript in the same directory that result is Theorem 4.3;
Theorem/Proposition 3.2 is a completely different statement (the concurrence spectrum).
The companion's proofs of its Theorem 3.2 and Theorem 5.1 both lean on that pointer, and
the companion's whole design premise is that "every dependency in the finite arguments" is
made explicit. A wrong dependency pointer in exactly that role is the single most damaging
scholarly defect in the pair.

Second, the companion advertises a genuinely new result — that `ker M` at q = 13 is
irreducible over `F_2` with endomorphism field `F_8`, presented as "what is added here" over
Madison and Wu — and then supplies no proof of it, deferring to a forthcoming Paper IV that
is not part of the artifact. Its own trust table nonetheless tags the row "human structural
proof". Inside this artifact that claim is unsupported.

Third, Remark 5.2 of the companion contains a rhetorical passage ("A bound proved by
counting, character sums, or clique arguments, with the order entering only as a parameter,
is monotone or eventually increasing in q; no such bound can return six at q = 19 and allow
eight at q = 23") that reads as an impossibility theorem but is neither stated nor provable
as one. In a paper this careful about proof modes, an unfalsifiable meta-claim sitting
un-tagged next to a five-mode trust ledger is a real inconsistency of standard.

Fourth, and separately from the mathematics: the manuscript's Section 9 pin block resolves
to a formal artifact that predates two of the theorems it names, in which the axiom the
paper says was retired is still live. The paper's own trust-manifest checker reports this,
and the manuscript contains no acknowledgment of it. I understand this to be a known
residual awaiting a re-export; my judgment is on its handling, which is currently
inadequate, because the printed evidence pointer contradicts rather than supports the
Section 9 claim it is attached to. This is a re-pin, not a footnote.

Everything else I found is genuinely minor: a numbering artefact where Theorem 4.3 quotes a
`c(A) <= 15` bound that the immediately preceding Proposition 3.2 supersedes, a classical
result (double perspective implies triple perspective) used without credit, a couple of
proof steps folded into theorem statements, and ordinary copy-editing.

---

Finding counts: **4 MAJOR** (items 1, 2, 3, 15), **7 MINOR** (items 4-10), **3 TRIVIAL**
(items 11-13), plus one free-strengthening opportunity (item 14).

## PRIORITIZED REVISION LIST

Ordered by section; items 1, 2, 3 and 15 are the MAJOR ones and item 15 is the one that
blocks circulation.

### 1. Companion Theorem 1.2 cites the wrong theorem number in Paper I — MAJOR

**Location.** Companion, Theorem 1.2 ("Conic-filling window"), `\cite[Theorem 3.2]{RuddRigidity2026}`
(companion `.tex` line 93). Used again implicitly wherever Theorem 1.2 is invoked
(companion Theorem 3.2 proof; Theorem 5.1 proof, k = 4, 7, 8 cases).

**Issue.** In the manuscript under review the conic-filling window is **Theorem 4.3**.
Proposition 3.2 of the manuscript is the *concurrence spectrum*, an unrelated statement. A
reader following the pointer lands on the wrong result. This is not cosmetic: the
companion's stated purpose for restating Theorems 1.1-1.3 is "to make every dependency in
the finite arguments explicit", so a mis-aimed dependency arrow defeats the design. (The
pointer was already stale against the previous revision, where the window was Theorem 4.2 —
so this is a persistent, not a one-off, slip.)

**Fix.** Change to `[9, Theorem 4.3]`. More durably: generate the companion's restated-input
numbers from the same label set as the manuscript, or drop the numbers and cite by name
("the conic-filling window theorem of [9]"), so the pair cannot drift again. Also re-check
`[9, Theorem 3.1]` and `[9, Theorem 1.1]` after any renumbering — both are currently correct.

### 2. The q = 13 descent claim is asserted, not proved, inside this artifact — MAJOR

**Location.** Companion, Section 4, paragraph beginning "What is added here is the descent";
Table 2 row "q = 13 orbit spans and automorphism group".

**Issue.** The claim is that over `F_2`, for the full `PGL(2,13)` action, `K = ker M` is
irreducible with endomorphism field `F_8`, equivalently carries a canonical 12-dimensional
`F_8`-structure whose Galois conjugates recover Madison and Wu's three summands. This is
flagged as the paper's own contribution over the cited literature. No proof is given. The
text says it "is a human structural proof, adversarially refereed", and then that its
"paper-level development belongs to forthcoming Paper IV [10]". Table 2 nonetheless assigns
it proof mode "human structural proof" with exact boundary "Irreducibility of ker M over F2
with endomorphism field F8, ...". A referee cannot check a proof that is not present, and
"adversarially refereed" is an unverifiable appeal that does not belong in a manuscript.

**Mitigating fact I confirmed by reading the proof.** The descent is *not* load-bearing for
Theorem 4.2. The spanning conclusion is proved independently and correctly via `B = A_9`,
`A_0 B = 0`, and `(I + B + B^2 + B^4)x = x` on `K`, plus `N_i^T N_i in {A_9, A_10, A_12}`.
So the theorem survives; only the novelty paragraph is unsupported.

**Fix.** Either include the descent proof (it is short if the endomorphism ring is computed
from the `F_2`-algebra generated by `A_9`), or demote the paragraph to a clearly labelled
forward reference: state it as a result of [10], not as something "added here", and either
delete its Table 2 row or retag it as an external/forthcoming dependency. Delete
"adversarially refereed".

### 3. Companion Remark 5.2's monotonicity meta-argument overclaims — MAJOR (as written)

**Location.** Companion, Remark 5.2, second paragraph.

**Issue.** "A bound proved by counting, character sums, or clique arguments, with the order
entering only as a parameter, is monotone or eventually increasing in q; no such bound can
return six at q = 19 and allow eight at q = 23." There is no definition of the quantified
class of arguments, no notion of "the order entering only as a parameter", and no proof.
Counting and character-sum bounds are routinely non-monotone in q (any bound involving
q mod 4, quadratic-residue conditions, or `floor` terms is a counterexample in spirit —
indeed the paper's own `c(A) = (q-6)(q-9)` window analysis is non-monotone in its
consequences). The passage will read to a referee as rhetoric dressed as a theorem, which is
jarring in a paper that otherwise partitions every claim into five explicit proof modes.

**Fix.** Rewrite as an explicitly heuristic observation: the q = 23 example shows the bound
six is an order-specific phenomenon, so any uniform-in-q counting argument is unlikely to
reproduce it, and Lemma 4.1's saturation identity `k - 1 = (q+1)/2` is precisely the kind of
order-specific coincidence available at q = 13 but not at q = 17, 19. Keep the concrete,
verified content (which is excellent) and drop the impossibility framing.

### 4. Theorem 4.3 quotes `0 <= c(A) <= 15`, superseded one page earlier — MINOR

**Location.** Manuscript, Theorem 4.3, k = 6 display; mirrored in companion Theorem 1.2.

**Issue.** Proposition 3.2 (new in this revision) proves `c(A) in {0,1,2,3,4,6,10}`, so
`c(A) <= 15` is both weaker and, at the values 5, 7, 8, 9, 11-15, now known to be
unattainable. Stating the weaker bound immediately after proving the sharper one reads as an
un-integrated insertion.

**Fix.** In Theorem 4.3 write `c(A) in {0,1,2,3,4,6,10}` by Proposition 3.2 (keeping the
`t(A) <= 3 binom(k,4) (r-2)/r` bound where the general-k argument needs it), and note the
immediate corollary: combining with `c(A) = (q-6)(q-9)` under `|U(A)| = q+1` leaves only
q = 5, 9, 11 among odd orders for k = 6 (q = 7 gives a negative value, q >= 13 exceeds 10),
which is strictly sharper than the window's `9 <= q <= 11` and makes the companion's q = 9
Sylvester exclusion the only remaining step. Propagate the same change to the companion's
Theorem 1.2 and to the first line of its Theorem 3.2 proof.

### 5. The transitivity step in Proposition 3.2 is a classical theorem, uncredited — MINOR

**Location.** Manuscript, proof of Proposition 3.2, "Second, adjacency in G is transitive"
through "Only commutativity of the field is used"; and Remark 3.3's novelty sentence.

**Issue.** The computation shown (normalize the triangle and the first centre of
perspective, observe that the second and third perspectivity determinants are `xyz - 1` and
`1 - xyz`) is the classical statement that two triangles in double perspective in a Pappian
plane are in triple perspective. Remark 3.3 scopes the novelty claim to "the exclusion of
the values five, seven, eight, and nine through the transitivity step", which is defensible,
but a referee who recognizes the ingredient will want it named and credited rather than
presented as an unattributed field computation.

**Fix.** Add one sentence: the determinant identity is the classical double-implies-triple
perspective theorem over a commutative field; the new content is its use as a transitivity
relation on the six one-factorizations of `K_6`. Keep the proof (it is self-contained and
short) but state the credit.

### 6. Proposition 3.2's proof does not justify the `K_{3,3}` normalization — MINOR

**Location.** Manuscript, proof of Proposition 3.2, "Take the common triangle
A_1 = (1:0:0), ...".

**Issue.** Three pairwise-disjoint perfect matchings of `K_6` span either `K_{3,3}` or the
triangular prism, and only the `K_{3,3}` case admits the two-triangles-in-perspective
normalization the proof uses. The proof does not say why the relevant triple — the one
coming from a *triangle* `{F_iF_j, F_jF_k, F_iF_k}` in the pair dictionary, as opposed to a
star `{F_iF_j, F_iF_k, F_iF_l}` — is the `K_{3,3}` type.

**Verification I did.** The counts match exactly and confirm the claim: there are
`binom(6,3) = 20` triangle-type triples and 20 `K_{3,3}` sub-configurations of `K_6` each
with a unique pair of 1-factorizations into three matchings, versus `6 * binom(5,3) = 60`
star-type triples and 60 prisms each with a unique such 1-factorization. So the intended
statement is true.

**Fix.** Add the one-line justification: under the pair dictionary a triangle of pairs
corresponds to a bipartite `K_{3,3}` triple (the star type gives the prism, where no
transitivity claim is made), so the two-triangle normalization is available.

### 7. The `Stab(C)`-orbit refinement is proved inside a theorem statement — MINOR

**Location.** Manuscript, Theorem 1.1, "More precisely, fix a nonsingular conic C. ... This
is the exact geometric sense in which the syndrome locus reconstructs the six-column
realization."

**Issue.** Three sentences of proof (the Bezout argument) sit inside the statement
environment. The argument itself is correct — a projectivity carrying `A` to `A'` carries
`C(F_11)` to `C(F_11)`, so its image of `C` shares twelve rational points with `C` and Bezout
forces equality — but statement and proof should not be interleaved.

**Fix.** Move to a Corollary (or into the proof of Theorem 1.1, which already ends with the
monomial-equivalence paragraph and would take this naturally).

### 8. Section 4 opens with a forward reference to Proposition 6.1 — MINOR

**Location.** Manuscript, first sentence of Section 4.

**Issue.** "Proposition 6.1 concerns a specific arc" is the first thing the reader of
Section 4 sees, two sections before Proposition 6.1 exists. I checked there is no
circularity — Theorem 1.1's proof uses only Theorem 3.1, Lemma 4.1 and Dye, and Proposition
6.1's proof uses Theorem 4.3 — but the ordering is confusing.

**Fix.** Rephrase to name the content rather than the number: "The conic identification for
the displayed arc, proved in Section 6, concerns one specific arc; we now prove the
symmetry-free characterization." Add an explicit no-circularity sentence, since the paper
elsewhere invests heavily in dependency transparency.

### 9. The nucleus argument in Theorem 4.3 is compressed to the point of looking backwards — MINOR

**Location.** Manuscript, Theorem 4.3 proof, "Every chord of A is disjoint from U(A), so no
chord contains N".

**Issue.** As written the implication looks like a non sequitur. The actual (correct)
reasoning is that every line through the nucleus meets the oval `U(A)` in exactly one point,
whereas a chord of `A` meets `U(A)` in none, so no chord passes through `N`; likewise no
vertex can be `N`, since each vertex lies on chords.

**Fix.** Insert the intermediate clause.

### 10. Definition 2.1 gives two definitions whose equivalence is cited, not proved — MINOR

**Location.** Manuscript, Definition 2.1.

**Issue.** The first clause (poles of the six Sylow-fixed chords of an icosahedral subgroup
at q = 11) and the second (a six-arc with exactly ten Brianchon points, over any field) are
both called "the Clebsch hexagon". Their agreement at q = 11 is what Theorem 1.1's final
step and Proposition 6.1 implicitly use, and it is supported only by the Edge citation.

**Fix.** State explicitly that the two agree at q = 11 by Edge / by Proposition 2.2 applied
over `F_11`, or make the second clause the definition and record the first as a construction.

### 11. Companion table/row names drift — TRIVIAL

**Location.** Companion, Section 2 ("the 'Fifteen classes and numerical gap' row of
Table 3"), Table 1 caption ("the global-gap replay", "the low-degree replay"), Remark 2.3
("the low-degree replay in Table 3").

**Issue.** Table 3's actual row is "Fifteen classes, gap, low-degree rigidity, and seven-arc
leaves", and it names two scripts; there is no separately named "global-gap replay" or
"low-degree replay" row. Three different names for one row.

**Fix.** Use one name consistently, or cite the script filenames directly.

### 12. Bibliography ordering slip — TRIVIAL

**Location.** Manuscript references [14] Hirschfeld, [15] Hassett-Tschinkel.

**Issue.** The list is otherwise alphabetical by first author; Hassett should precede
Hirschfeld.

**Fix.** Reorder.

### 13. Abstract wording — TRIVIAL

**Location.** Manuscript abstract, "any k-arc whose uncovered locus is a nonsingular conic
has q odd and lies in the field window 2k-3 <= q <= ...".

**Issue.** The arc does not lie in a field window; `q` does.

**Fix.** "... has q odd, with 2k-3 <= q <= (k(k-1)+3)/3."

### 14. Free strengthening the revision should take (opportunity, not defect)

The companion's own census independently confirms Proposition 3.2 and the papers do not say
so. From Table 1, `c(A) = 22 - |U(A)|` across the fifteen q = 11 classes gives exactly
`{0, 1, 2, 3, 4, 6, 10}` — every value of the predicted spectrum occurs, and none of the
excluded values 5, 7, 8, 9 does. That is a clean, already-computed, zero-cost corroboration
of the paper's newest proposition and belongs in Remark 3.3 or in the companion's Section 2.

### 15. The manuscript's pin block resolves to a formal artifact that predates two of the theorems it names — MAJOR

**Location.** Manuscript, Section 9, pin block (certificate-package commit, gate digest) and
the two named node declarations.

**Issue.** Section 9 prints the SHA-256 digest
`c5d532dbd79dcb2eef602ced85105b72943a0a1af05de11c3c008c1ed9a1d747` for the aggregate gate
and pins certificate-package commit `09d8e174…`. I recomputed the digests. The
`checker_outputs.json` digest matches exactly and is current. The **gate digest does not
match**: the authority tree's gate hashes to `4bc2adb5…`. The printed digest corresponds to
an earlier gate carrying 51 terminal declarations; the current one carries 52. The single
substantive difference is that the earlier gate lists the axiom
`PaperIOrientationTraceDual.hassettTschinkel_six_nodes_of_traceDual`, which the current gate
replaces with the two proved theorems
`PaperIOrientationNodes.derivative_crossGoldenDeterminantLine_eval` and
`PaperIOrientationNodes.singularPoints_crossGoldenDeterminant_eq_axisClasses`.

Those are precisely the two declarations Section 9 names, and the prose built around them is
the paper's central trust claim: that singular-locus completeness is kernel-checked and is
*not* transferred from Hassett-Tschinkel, whose Proposition 10 "is recorded as context and
is not load-bearing". A referee who resolves the printed pin fetches a formal artifact in
which neither named theorem exists and in which the Hassett-Tschinkel statement is still an
axiom. The pin therefore inverts, rather than supports, the claim it is attached to.

Nothing in the `.tex` acknowledges the lag — no "stale", "re-pin", "pending", or equivalent
qualifier appears anywhere in the manuscript. The paper's own manifest checker detects the
problem: `verify_trust_manifest.py` exits 1 with the single message "manuscript displays a
stale digest for RelativeConicArcs/Gates/ClebschRigidityTrust.lean". The base-library commit
`570086982b…` is a further candidate for staleness, since the two new theorems live in the
reusable base library; I could not check it (no `finitegeom` checkout on this machine).

**Fix.** Re-export and re-pin. A footnote is not an adequate substitute here, because the
defect is not a missing caveat but a pointer to evidence that contradicts the text. Until
the re-pin, the paper should not be circulated with Section 9 as written. After re-pinning,
re-run `verify_release.py` against a real certificate-package checkout: the last recorded
pass (`verify-release-output.json`, 2026-08-02) predates the manuscript revision.

---

## CLAIM / PROOF / FORMALIZATION CORRESPONDENCE

**Overall: the internal discipline is excellent; the external pointer is broken.** Detail,
from a read-only audit of the Lean tree, the axiom audit, and the JSON trust artifacts.

**Axiom surface: verified as disclosed.** The gate's tracked axiom audit has one entry per
gate line and the two name sets are identical. The only non-foundational axioms anywhere are
exactly the two disclosed Dye assumptions,
`ClebschDye.dye1991_brianchon_bound` (a six-arc in PG(2,11) has at most ten Brianchon points)
and `ClebschDye.dye1991_equality_classification` (ten forces `IsClebschHexagon`). They occur
on five declarations. There is no `sorry`, `sorryAx`, `native_decide`, `Lean.ofReduceBool`,
`admit`, or admitted declaration. The manuscript's statement that the gate "uses neither
admitted declarations nor native execution" is accurate.

**Terminal correspondence: exact.** The union of Lean terminals named across the 19 manifest
claims is exactly the 52 gate declarations — no claim names a nonexistent terminal, and no
gate terminal is unclaimed. The seven claims with no Lean terminal all declare non-Lean
routes, so nothing labelled formalized fails to name a real terminal. Every claim I sampled
(the `A_5` point orbits, the deep-hole/conic identification, the 960/150/100/120 ambiguity
strata, the rigidity theorem, the monomial characterization, the q = 11 field-order
boundary) has a Lean statement that faithfully matches, and every narrowing is explicitly
recorded in a `subclaim` or `trust_boundary` field rather than glossed over.

**The 3+3' interface is correctly recorded as an assumption, and it is a large one.** The
two commutant terminals take `PaperIOrientationCommutant.ClassicalOddA5ThreePlusThreeSplitting`
as an explicit `Prop`-valued argument; its content is the containment
`rationalCommutant oddA5ActionMatrix ⊆ adjoinGoldenOperator`. Lean proves the reverse
containment and the integral coefficient test (the third commutant terminal is
unconditional). The manuscript's phrasing — "the commutant theorems instead take an explicit
proposition-valued interface for the classical conjugate 3 + 3' decomposition, Schur's
lemma, and Galois descent" — is technically exact, and the manifest repeats it in
`conditional_interfaces` and `trust_boundary`. My one remark as referee: the assumed
direction is the *hard* half of the commutant equality, and a reader skimming Section 9
could take "interface" to mean routine plumbing. One clarifying clause would help.

**Two labelling nits on the Lean side.** (a) Two of the 52 gate entries
(`supportCubic_projectiveStabilizer_equiv_S5`, `orientedSupportCubic_stabilizer_equiv_A5`)
are `noncomputable def`s producing `MulEquiv`s rather than `theorem`s; the construction is
the proof, so this is nomenclature only. (b) The terminal
`PaperIOrientationCover.antipodalQuotient_fiber_card_two` reduces to
`(univ.filter fun x : Fin 6 × Bool => x.1 = axis).card = 2`, discharged by `decide`, which
given `OrientedSupport := Fin 6 × Bool` is definitional bookkeeping. The gate header's
"constructs the antipodal cover" oversells that one terminal.

**Prose-versus-type gaps in the two named node theorems (both minor).**
`derivative_crossGoldenDeterminantLine_eval` holds over any `CommRing` with `t^2 = t + 1`,
with no extra hypotheses, exactly as claimed — but it gives the derivative as the
*negative* of the gradient quadric, a sign the prose's "up to sign" already covers.
`singularPoints_crossGoldenDeterminant_eq_axisClasses` holds over any `CharZero` field with
such a root, with no smoothness or transversality hypothesis, confirming the paper's explicit
assertion; its only unstated hypothesis is `x ≠ 0`, the standard projective-cone condition.
Both formalize the "partial derivatives" as derivatives of restrictions to centered
coordinate lines rather than as a multivariate Jacobian (equivalent for polynomials, but a
different object than the prose implies), and the projective reading lives in the docstring
rather than in the type.

**Companion trust ledger.** `verify_computational_companion.py` exits 0
(`companion_claims=12 modes=5 checks=10 artifacts=4 finite_boundary_claims=7 status=ok`).
The five declared proof modes are cleanly defined and the mode assignments in Table 2 look
right to me with one exception, already recorded as revision item 2: the q = 13 descent is
tagged "human structural proof" while its proof is deferred to a forthcoming paper. Note
also a vocabulary mismatch between the companion README's fifth mode ("trusted exact
executions") and the manifest's route strings, where it is folded into `exact-replay`.

**What the paper says about the formal side that I judge fair.** "This formalization is an
independent cross-check, not a proof dependency of the manuscript"; "None of the preceding
manuscript conclusions is imported from the formal development"; "No exhaustive
classification in this paper is certified by Lean". All three are supported by what I read.
The paper does not claim more formalization than exists.

---

## GRADES

**1. Mathematical correctness — 92/100.** Every displayed identity, count, and normal-form
value I checked holds exactly, including nine independent symbolic and finite computations
that all confirmed the text; the two sharpness cases of the field window are attained
exactly, and the companion's fifteen-class census is internally consistent with orbit masses,
the chord-defect identity, and the new concurrence spectrum simultaneously. Deductions are
for two compressed proof steps (the unargued `K_{3,3}` normalization in Proposition 3.2, the
backwards-looking nucleus sentence in Theorem 4.3) and, in the companion, one asserted-but-
unproved theorem and one impossibility-flavoured passage that is not a theorem.

**2. Claim-proof-Lean correspondence and trust-surface accuracy — 74/100.** The internal
discipline is among the best I have seen: exactly two disclosed non-foundational axioms and
no others, no `sorry` or native execution, a manifest whose Lean terminals coincide exactly
with the gate's, every narrowing recorded explicitly, and a genuinely assumed interface
correctly flagged as assumed rather than hidden. The grade is held down almost entirely by
one defect with outsized consequences: the printed gate digest and certificate-package
commit resolve to an artifact in which the two theorems Section 9 names do not exist and in
which the axiom Section 9 says was retired is still live, with no in-paper acknowledgment.

**3. Exposition and organization — 84/100.** The architecture is clear and the "what is new
and what is not" paragraph, the per-section attribution remarks, and the explicit proof-mode
table are exactly what a reader of a mixed human/computational/formal artifact needs. Points
come off for a forward reference in the first sentence of Section 4, proof material inside
the statement of Theorem 1.1, an un-integrated `c(A) <= 15` bound one page after a sharper
one is proved, and three different names for one companion table row.

**4. Citation and priority hygiene — 86/100.** Credit is drawn unusually precisely — Dye by
theorem and page for the bound, equality classification, polarity, stabilizer and associated
conic; Edge's exterior-set reading correctly tagged as order-specific to q = 11 with q = 19
given as the counter-instance; Blokhuis-Seress-Wilbrink cited with the Pasch configuration
excluded for the right reason; Hassett-Tschinkel explicitly declared context and not
load-bearing; Madison-Wu's dimension and closure-field decomposition credited before the
descent is claimed. Deductions for the wrong theorem number when the companion cites Paper I,
for using the classical double-implies-triple perspective theorem without naming it, and for
"adversarially refereed" as a substitute for a citation.

**5. Referee-readiness of the artifact as a whole — 78/100.** Build is clean (no undefined
or multiply-defined references in either log), the verification tooling runs read-only and
the companion validator passes, and the reproducibility surface is unusually complete. But
the release verifier does not currently pass, the trust-manifest checker itself reports the
stale digest, and a referee resolving the paper's own pins would reach evidence contradicting
Section 9 — which is the one thing a formalization-backed submission cannot afford.

**Overall — 82/100.**

---

## INDEPENDENTLY VERIFIED

All computations below were run by me from scratch, not read out of the paper's own
artifacts.

1. **The displayed q = 11 arc.** Direct enumeration over PG(2,11) of
   `A = {(1,10,0),(1,9,1),(1,4,7),(1,8,5),(0,1,4),(1,1,7)}`: it is a six-arc; `|U(A)| = 12`;
   every uncovered point satisfies `XZ = Y^2`; `c(A) = 10` with no point on more than three
   chords; and the secant-index histogram is `(n_0,n_1,n_2,n_3) = (12,90,15,10)`, exactly the
   values Proposition 6.5's proof asserts and the values feeding the 960/150/100/120 ambiguity
   counts. (`scratchpad/chk.py`, plain Python.)

2. **The q = 23 sharpness configuration of companion Remark 5.2.** All eight listed points lie
   off `XZ = Y^2`; all 56 triples are non-collinear; all 28 joins are passant by the
   `B(P,R)^2 - 4Q(P)Q(R)` non-square test; and the point types split 6 non-square / 2 square,
   matching "six internal and two external". (`scratchpad/chk2.py`.)

3. **The golden operator identities of Theorem 8.1**, symbolically over `Q(sqrt 5)` with the
   displayed matrix `B`: `B` symmetric with `B^2 = 5I`; `det B = -125`;
   `B U(t_+) = sqrt5 U(t_+)` and `B U(t_-) = -sqrt5 U(t_-)`; `U(t_-)^T U(t_+) = 0`;
   `det(U(t_-)^T diag(x) U(t_+)) = -C(x)` where `C` is built from `c_ijk = B_ij B_jk B_ki`;
   the full pencil identity
   `det(B + diag(x)) = e_6 - e_4 + 5e_2 - 125 - 2C(x)`; and all principal minors of size four
   equal to 5, all of size five equal to 0. (`scratchpad/chk3.py`, sympy.)

4. **Chord-defect algebra, by hand.** The two moment identities, the identity
   `binom(i,2) = (i-1) + binom(i-1,2)`, the resulting formula, the defect bound via
   `binom(i-1,2)/binom(i,2) = (i-2)/i`, the `k = 6` specialization `q^2 - 14q + 55 - c(A)`,
   the `|U| = q+1` consequence `c(A) = (q-6)(q-9)`, the `q < m` argument, the passant count
   giving `q >= 2k-3`, and the rearrangement of the Blokhuis-Brouwer-Szonyi bound
   `m >= 3(q-1)/2` into `q <= (k(k-1)+3)/3`. All correct; both sharpness cases (k=4,q=5 and
   k=6,q=11) meet the upper bound with equality.

5. **Concurrence-spectrum arithmetic.** Enumerating partitions of six with an odd part and
   evaluating `sum binom(a_i,2)` gives exactly `{0,1,2,3,4,6,10}`, with the excluded all-even
   partitions 6 and 4+2 giving 15 and 7, as stated. The `K_{3,3}`-versus-prism count
   (20 triangle-type triples matching 20 `K_{3,3}`s with two 1-factorizations each,
   60 star-type triples matching 60 prisms with one each) confirms the normalization the proof
   uses without stating.

6. **The companion census is self-consistent, three ways at once.** From Table 1, orbit masses
   `360/|G|` reproduce Theorem 2.4's multiplicity vector `(6,30,150,300,630,360,72)` summing to
   1548; `c(A) = 22 - |U(A)|` lands in the new spectrum `{0,1,2,3,4,6,10}` for all fifteen
   classes and realizes every one of its seven values; and the conic-inscribed subcensus
   (30+60+90+72 = 252) decomposes into whole class masses as projective invariance requires.

7. **Golden normal-form polarity values.** Evaluating `v -> v^T S v` on all six vertices of
   `X_phi` in `Z[x]/(x^2-x-1)` gives `2phi-1` four times, `3phi+1`, and `3phi-4`, exactly as
   Proposition 2.2 states; their norms are all `-5`, the three Brianchon values have norm `-9`,
   `det S = 4phi`, and the minor factor `13 - 8phi` has norm 1 and so is a unit. The arc
   determinants `pm 1, pm(x-1), pm(x-2), x` all have unit or `-1` norm, hence are nonzero in
   every odd characteristic.

8. **`A_5` orbit bookkeeping of Proposition 6.3.** The character inner product
   `(9 + 15 + 12(phi^2 + phibar^2))/60 = 1`; fixed-point counts 13, 1, 3 for elements of order
   2, 3, 5; subgroup-conjugacy counts and the incidence tallies (each involution in two `D_5`,
   two `S_3`, one `V_4`, contributing 2+2+3 of its 13 fixed points) leaving six points with
   exact stabilizer `C_2`, hence `15 x 6 = 90` points in three orbits of 30; total
   `6+10+12+15+90 = 133 = 11^2+11+1`.

9. **Code-side counts.** `[6,3,4]_11` MDS weight enumerator `(1,0,0,0,150,420,760)` recomputed
   from the standard MDS formula; coset-leader weight distribution `(1,60,1150,120)` summing to
   1331; `120 x 20 = 2400` leaders; `120 x 1331 = 159720` received-word deep holes;
   `1331 x 600 = 798600` and `798600/159720 = 5`. The worked example `s = (1,0,0)`,
   `e = (7,4,1,0,0,0)` satisfies `He^T = s` mod 11.

10. **Cross-reference and build hygiene.** Both LaTeX logs are free of undefined and
    multiply-defined references. The companion `.tex` line 93 does cite
    `\cite[Theorem 3.2]{RuddRigidity2026}` for the conic-filling window; the manuscript's
    theorem environments number that result 4.3, and the previous revision numbered it 4.2, so
    the pointer has never matched.

11. **Formal-side items** (read-only audit, no builds): the gate's 52 terminals all exist; the
    axiom audit's only non-foundational entries are the two Dye axioms; the two Section 9 node
    theorems exist with the hypotheses claimed; the manifest's Lean terminals coincide exactly
    with the gate's; `checker_outputs.json` hashes to the printed digest; the gate file does
    **not** (authority `4bc2adb5…` versus printed `c5d532db…`, the latter being a 51-terminal
    gate that still lists the Hassett-Tschinkel axiom);
    `verify_computational_companion.py` exits 0; `verify_trust_manifest.py` exits 1 solely on
    the stale digest.

**Not verified (no access):** the exact statements of Dye's Theorems 1, 2, 3, 6 and their page
numbers; Blokhuis-Brouwer-Szonyi Proposition 1.6; Blokhuis-Seress-Wilbrink pp. 143, 146;
Edge §§29-32; Cheltsov-Tschinkel-Zhang equations (7.4)-(7.5); Hassett-Tschinkel Proposition
10; Madison-Wu Theorem 6.1 and Corollary 6.3; Abiad-Jabal Ameli-Reijnders Table 1;
Jurisic-Vidali Theorem 6. The base-library commit `570086982b…` could not be checked against
a `finitegeom` checkout.
