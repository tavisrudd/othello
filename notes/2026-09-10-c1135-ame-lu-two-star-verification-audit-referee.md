# C1135: independent referee report on two-star AME verification

Date: 2026-09-10. Lane: `ame-lu`.

**Recommendation: accept the mathematical core for a bounded manuscript revision, subject to minor exposition/integration corrections and the separate literature gate.** No counterexample or substantive proof gap was found in the proposed weighted gap, setting-count optimum, or universal AME gap. This is a report on additions to the current paper, not an unconditional publication recommendation for the entire manuscript or a publication-priority verdict.

## Scope and read depth

The review was requested as an independent adversarial journal-style read. I read the supplied `AME_LU_REVISION_PACKET_55e70c4.md`, Modules 1–8, including all proposed proofs, optional analytic corollaries, and the displayed six-qubit script. I reconstructed the principal arguments independently before accepting their conclusions. The input was `/home/tavis/Downloads/AME_LU_REVISION_PACKET_55e70c4.md`; the manuscript authority was `/home/tavis/src/othello/papers/ame_lu`.

Read-depth markers for manuscript sources:

- `sections/03-exact-rigidity-atlas.tex`: **proof-level targeted read**, half-set decomposition/support count (lines 164–284), four-qutrit example, and marginal certification including its proof and related-work discussion (lines 518–768). This is not a fresh audit of the entire exact-rigidity theorem.
- `sections/05-quantitative-rounding.tex`: **full proof-level read**, all 708 lines, checking the proposed wrapper against local cleaning, Fourier rounding, global branch selection, residual stability, relative intertwining, transition compatibility, and logical rounding.
- `sections/01-introduction.tex`: **targeted exposition read**, first 180 lines, including both headline theorems and their mechanisms.
- `main.tex`: **targeted exposition/source read**, abstract and manuscript order; `sections/07-conclusion.tex` and `sections/08-verification-boundary.tex`: **full text read**.
- External literature named by the packet: **not independently read in this referee pass**. Packet bibliographic descriptions were read, but do not count as primary-source verification. The parent audit owns that work. No external priority or pre-emption conclusion is made here.

No numerical experiment, script replay, PDF build, rendered-page review, Lean operation, or manuscript edit was performed. The finite examples below are checked by analytic counting, not by endorsing the packet's reported executions. This report is the only file written; it is deliberately left for the parent task's scoped validation and commit.

Process note: an initial combined source display exceeded the aggregate display budget and the handoff command exceeded the command-output threshold. I replaced it with bounded source ranges and completed the necessary reading. No truncated proof was treated as read evidence.

## Summary and contribution

The manuscript already obtains a dimensionally minimal family of `m` marginals, each on `m+1` parties, that determines a stabilizer `AME(2m,q)` state. The proposed addition asks a different operational question: how efficiently can randomized tests of those marginal supports reject an orthogonal state? It adds the star associated with the complementary half of the parties and proves that every `m` of the resulting `2m` additive subgroups span the stabilizer label space independently.

This gives an exact weighted rejection gap: the sum of the `m+1` smallest probabilities. More substantially, the packet proves that the chosen library attains the optimum over *all* perfectly complete binary effects on at most `m+1` parties, at every permitted setting count. The optimum is zero below `m` settings, `1-(m-1)/s` for `m≤s≤2m`, and `(m+1)/(2m)` thereafter. The comparison with arbitrary effects is proved, not assumed.

A separate argument proves the last, full-library gap for every AME state in every integer local dimension. It uses orthogonality between low-weight error spaces on complementary halves. It requires no stabilizer eigenbasis or mutual commutativity between the two stars. Finally the gap turns observed rejection, or marginal trace-distance bounds, into an input certificate for the existing local-unitary rounding theorems.

## Significance and scope

The strongest structural gain is the exact resource tradeoff in a sharply specified measurement class. Merely identifying a parent Hamiltonian would add little after the current marginal-certification proposition. Identifying every attainable gap as the number of tests increases, and matching that curve against arbitrary effects on arbitrary allowed supports, is a coherent additional theorem. Its proof is short because the AME support geometry supplies an MDS-like incidence structure.

The universal theorem has independent conceptual value. Maximal entanglement across one balanced cut makes one star a commuting family even for a non-stabilizer state. Maximal mixing across the other small subsets then makes the two stars complementary enough to force a constant rejection gap. This tells an adjacent quantum-information reader which part of certification is entanglement geometry and which part needs additive stabilizer structure.

The operational importance must remain proportional to the model. A setting is a compound binary effect implemented jointly on a selected subset. Neither an implementation of a marginal projector using one-party measurement bases nor a circuit-resource optimum has been proved. The observable corollary is useful as an experimentally interpretable entrance condition, but it still requires a product-unitary promise to infer factorwise Clifford structure. It does not identify unknown LU orbits, certify arbitrary channels, or enlarge the global rounding radius.

The material belongs as a subordinate application of the existing atlas. It does not justify changing the title or making verification a third equally extensive paper theme. Whether the exact theorem is a publishable new result rather than a previously known specialization remains a literature question outside this report.

## Correctness: independent reconstruction

### 1. The doubled atlas and weighted optimum

Take `I⊆B`, `J⊆C`, with `|I|+|J|=m`. In a dependence among the selected subgroups, write the sum from the `C∪{i}` star as the negative of the sum from the `B∪{j}` star. The common label is supported on `I∪J`, a set of size `m`, so the AME support condition kills it. Coordinate projection within either star then kills each summand. The dimensions add to `2em`, proving the required direct sum. This remains valid over the prime field for additive, non-field-linear stabilizers.

A nontrivial character can annihilate at most `m-1` test subgroups. Conversely, every chosen set of `m-1` subgroups has a `2e`-dimensional annihilator; any nonzero character in it annihilates no additional subgroup. Thus every complementary set of `m+1` failures is realized. Taking the least total failure weight proves the claimed formula exactly. No union bound replaces attainment. Zero weights and ties cause no failure: an attaining character still exists, and the sorted-weight expression may correctly vanish.

The target-fixing lifts matter, especially at characteristic two. They form the actual stabilizer group, isomorphic to the additive label group. Its full joint character basis has one-dimensional eigenspaces by Weyl orthogonality. The packet uses this convention explicitly and does not incorrectly average unadjusted Weyl representatives.

Uniform weights uniquely maximize the gap in the fixed full library when `m≥2`. This follows from equality in the mean bound for the `m+1` smallest entries, since `m+1<2m`. It is not a uniqueness theorem for all physically allowed optimal protocols, and should not be phrased as one.

### 2. The upper bounds really cover arbitrary allowed effects

For `0≤E≤I`, perfect completeness gives zero expectation of `I-E` against the marginal. Positivity implies that `E` is the identity on the marginal support and has no coupling from it to the orthogonal complement. Thus `E≥P_supp`, and the support projector is the most rejecting possible complete test on that subset. A test on at most `m` parties is the identity because its marginal is full rank.

For `m+1` parties the relevant stabilizer subgroup has prime-field dimension `2e`. The span of any `m-1` such subgroups, whether from the doubled library or not, is proper. A nontrivial character annihilating it passes the corresponding arbitrary effects with certainty. Applying this to the `m-1` heaviest settings bounds rejection by the remaining total weight, at most `1-(m-1)/t` for `t` positive-probability settings. The same argument gives zero gap if `t<m`. Since `t≤s`, the claimed setting-count upper bound follows. Duplicate effects and zero weights do not evade it.

Independently, a normalized one-party traceless unitary error is orthogonal to the AME target. All tests omitting that party accept it. Its rejection is therefore at most the probability that this party is touched. The smallest inclusion probability is at most the mean, bounded by `(m+1)/(2m)`. This proof requires only one-uniformity for the upper bound and genuinely permits arbitrary joint effects inside each chosen support.

Uniformly sampling any `s` doubled-star tests attains the finite-setting bound by the weighted formula. The endpoint statements, necessity of `2m` settings for the locality cap, and setting-erasure formula all follow without additional assumptions.

### 3. Universal two-star theorem

The one-star lemma assumes a pure state maximally entangled across the balanced cut. An orthonormal tensor-product unitary error basis on `B` sends the state to an orthonormal basis of the full Hilbert space. The support of the marginal on `C∪{i}`, lifted to the full space, has rank `q^(2m-2)`. It contains exactly the `q^(2m-2)` basis vectors whose error at `i` is the identity. Hence its projector selects that coordinate condition. The commuting-star statement and binomial weight spectrum follow by counting, with no stabilizer hypothesis.

On the target-orthogonal space, write the two integer-valued rejection operators as

`H_B=mI−Σ_(a=1)^(m−1) E_a^B`, `H_C=mI−Σ_(b=1)^(m−1) E_b^C`,

where `E_a` selects nonzero error weights at most `a`. AME mixing makes the ranges of `E_a^B` and `E_(m−a)^C` orthogonal: the relevant matrix element is the expectation of a traceless tensor-product operator supported on at most `m` parties. Consequently each paired sum is at most `I`, so `H_B+H_C≥(m+1)I`. This inference does not assume that the unpaired projectors commute.

A one-party error in `B` has `H_B` eigenvalue one and is orthogonal to all `C` errors of weight below `m`; hence it has `H_C` eigenvalue `m`. It attains the bound. All dimensions, normalization factors, and the separate `m=2` case check. At four parties the stronger pairwise-commutativity observation is also correct: each three-party projector is the target ray plus one party's traceless-error space, and these four error spaces are orthogonal.

### 4. Secondary formulas and current quantitative wrapper

The syndrome restriction map has bijective projection to every `m` blocks, each of size `Q=q²`. This proves the stated additive MDS parameters without constructing multiplication by `F_(q²)`. Inclusion–exclusion on the annihilator counts gives the spectrum formula. For `m=2,q=3`, the four disjoint sets of eight nontrivial characters passing a test give multiplicities `32` at `3/4` and `48` at `1`; for `m=3,q=2`, the displayed formula gives `45` at `2/3`, zero at `5/6`, and `18` at `1`. These are analytic checks of the expressions, not finite-code replays.

The fidelity and trace-distance inequalities have the correct normalization. The rescaled marginal is a norm-one effect, so no extra factor `q^(m−1)` belongs in the trace-distance bound. For a pure output, `ε²=2(1−√F)`, giving the exact stated function `η(γ)` and inverse threshold `Γ_ν(t)=ν(t²−t⁴/4)` for `0<t<√2`.

The authoritative quantitative section has precisely the three thresholds used by the packet: `1/24`, `√2/68`, and `min{1/(4√(2q)),1/(8π√n)}`. Its local estimate is `8ε`; the post-branch bounds are `D≤π√q ε` and the corresponding squared chord sum `≤π²ε²`. The packet preserves the exact-base hypothesis for relative intertwiners and the distinction between label compatibility and a nearby exact symmetry. The logical Clifford statement is valid for the separately chosen encoder; it does not require one correction to vanish simultaneously on every logical leg.

The operator-norm calibration estimate is correct for a fixed input state and valid implemented effects. The iid all-pass bound and its `O(max{q,n} log(1/α))` consequence follow with the stated ideal-test hypotheses. The optional a posteriori criterion follows from the two-uniform second moment, the integral chord estimate, and the stabilizer-overlap gap; its chord-only eligibility conditions imply all stated logarithm and residual hypotheses. None of these deductions establishes better sampling exponents or a larger uniform rounding radius.

The order-statistic LP identity and primal/dual directions in the general-library discussion also check. This material is not needed for the recommended manuscript core.

## Exposition and organization

The proof sequence in Modules 1–3 is unusually clean for a packet of this size: geometry, exact failure sets, arbitrary-effect upper bounds, then observable conversion. Preserve that causal order. The largest risk is importing the entire packet, whose repeated boundaries and optional modules would outweigh the theorem.

For the current manuscript I recommend:

1. After `prop:marginal-certification`, add the measurement model, one doubled-atlas lemma, and one theorem with the weighted formula and optimal setting curve. Give the arbitrary-effect and locality upper bounds as proof paragraphs rather than several separately promoted headlines.
2. Immediately add the infidelity certificate and the existing four-qutrit illustration. The example's changed stabilizer character makes the detection mechanism concrete.
3. State the universal full-gap extension prominently enough that readers see its stronger scope, but put its compact proof in an appendix. The complete spectrum and LP need not be included; the qutrit count is sufficient illustration.
4. After `cor:logical-clifford-rounding`, add one observable corollary using `η` and `Γ`. A compact three-row table is appropriate; do not repeat the three quantitative proofs or their full conclusions several times.
5. Preserve the current title. Prefer no abstract expansion unless the new subsection becomes a substantial adopted contribution. One introduction sentence and one conclusion sentence can carry its relevance.

The current title-page abstract already has three dense paragraphs and the body already separates multiple exact and quantitative mechanisms. Keeping every optional packet module would undermine that hierarchy. No additional figure is required: the setting curve and the four-qutrit example explain the tradeoff more directly than another atlas diagram. A figure would earn its place only if a later reader cannot follow the two complementary error filtrations.

## Major comments

1. **Make the measurement resource part of the theorem, not a footnote.** “Setting” must mean one binary effect on a fixed chosen subset per copy. Joint operations on that subset are allowed. An implementation that internally randomizes among different supports must count the resulting subset tests when invoking the setting-count optimum. Otherwise a laboratory reader could incorrectly count the whole randomized library as one setting. The packet's definitions are sufficient mathematically; the adopted theorem must retain them.
2. **Keep novelty, mathematical validity, and experimental practicality separate.** The sharp restricted-model optimum is proved. Priority against the closest verification and marginal-determination literature remains to be independently checked. This report cannot authorize “first” or “best known” language. Nor does the test count establish low implementation cost.
3. **Protect the rigidity hierarchy.** The universal theorem certifies a known AME state; the weighted and finite-setting assertions use stabilizer structure. The factorwise conclusions additionally require the product-unitary promise. No inference from universal verification to universal LU=LC is available. The packet states these distinctions correctly; they are acceptance conditions for integration.
4. **Limit adoption.** The optional spectrum, generic oracle, sampling discussion, and a posteriori branch certificate are all mathematically compatible, but together would turn a short consequence into another research programme. Adopt the minimal package above and bank the rest.

These are substantive presentation and scope conditions, not failures of the supplied proofs.

## Minor comments

- Define the integer range `s≥1`, `m≥2`, `q=p^e` in the stabilizer theorem and `q≥2` integer in the universal theorem. Existence is conditional on the supplied AME target.
- State that unique maximizing weights concern the fixed doubled-star library only.
- When using the all-pass expression, explicitly give `0<ε₀≤1`, `0<α<1`, and the iid/ideal-effect hypotheses next to it.
- The uniform gap's exact eigenvectors can be described as any traceless one-party operator applied to the target, not only a selected Weyl basis vector. This gives the useful sharpness observation below.
- Replace the packet's manually tagged formulas with semantic labels during integration. Preserve existing theorem labels and split off a stochastic-conversion heading if verification is inserted between that heading and its corollary.
- Rename the existing “Verification and trust boundary” heading to distinguish proof verification from state verification, and avoid hard-coded appendix letters in accompanying prose.
- If retained, the optional sample-cost paragraph should report the current bound directly, without the historical old-radius comparison.

## Extra-juice / Terence-Tao closeout and mystery ledger

The core acceptance gate passed. I then asked whether the verifier-to-rounding bridge hides a free improvement, and whether the global-symmetry difficulty has merely moved into notation.

**Settled: the gap-to-defect conversion is sharp even for promised product-unitary outputs.** Let `V_i` be any one-party unitary and write `V_i=cI+A_i`, where `c=Tr(V_i)/q` and `Tr A_i=0`. One-uniformity makes `A_iψ` orthogonal to `ψ`. The universal proof places the entire traceless one-party error space in the minimum-gap eigenspace. Therefore

`r_*(V_i Pψ V_i†)=ν_* (1−|Tr(V_i)/q|²)`.

Consequently the packet's exact `η(γ)` bound is attained when `γ` is the actual rejection probability, for this family. Continuous unitaries near the identity already give arbitrarily small examples. The product-unitary promise alone cannot improve this generic rejection-to-vector-defect conversion. This is a short optional sharpness remark, not another theorem requiring a computational package.

**Settled: universality does not depend on unnoticed cross-star commutativity.** The low-weight spectral-projector pairing proves exactly the needed operator inequality. No repair is required.

**Open but not an adoption blocker: universal weighted/setting refinements.** The packet proves only the uniform full-star optimum without stabilizers. Its proof does not supply the arbitrary-effect finite-setting annihilator argument in that generality. No claim in that direction should be added without a separate argument. This is not a counterexample or evidence that the extension is false.

**Existing manuscript frontier, unchanged:** global character/branch control beyond the current radius. The sharpness calculation above explains why improving the elementary fidelity wrapper cannot by itself close it. The missing input remains a collective structural estimate or another branch-selection principle.

**External evidence gap:** exact literature positioning and practical projector implementation cost. The former belongs to the parent audit's acceptance gate; the latter is outside the adopted theorem's model. No other genuine correctness mystery remains in the reviewed core.

## Editorial recommendation

The principal proposed results are correct under their printed hypotheses and add a meaningful operational consequence to the atlas. I recommend a **minor, bounded integration revision**, followed by a source/PDF check and independent verification of any literature-positioning sentences. I would not request additional finite experiments or Lean development as mathematical acceptance conditions: the analytic proofs are self-contained given the existing support theorem. I would request substantial shortening if the whole packet were submitted as additions to this paper.

Vibe check: mathematically green; the remaining risk is overexpansion or a measurement/priority claim broader than the proved model.

Next action remains the parent C1135 synthesis and its literature gate; no new task ID is allocated by this report.

`go ame-lu`

## Separately requested follow-up: universal selected subsets and weights

After completing the independent report above, the parent task requested a check of the stronger argument in `2026-09-10-c1135-ame-lu-two-star-verification-audit-adversarial.md`, section “Correctness: stronger universal result from the closeout pass.” **Read depth: complete proof-level read of that section only.** This follow-up is not part of the original fresh assessment and does not make the two reviews independent of one another on this additional result.

**Verdict: the strengthening is correct.** It partially settles the universal-refinement item in the original mystery ledger. Every `m` selected doubled-star tests determine an arbitrary AME target, and the stabilizer weighted formula is a universal lower bound. Exact weighted equality and the optimum among arbitrary protocols at intermediate setting counts remain unproved in this generality.

For clarity, here is my reconstruction. Select `r` tests associated with coordinates in `B` and `t` associated with coordinates in `C`, with `s=r+t≥m` and `d=s−m`. Let `A,D` be their unnormalized rejection sums on the target-orthogonal space. The one-star error basis shows that `A` counts nonidentity factors only among the `r` selected coordinates. Thus the spectral projector `E_k=1_(A≤k)` is spanned by nontrivial `B` errors of total weight at most `m−r+k`. Similarly `F_l=1_(D≤l)` is spanned by nontrivial `C` errors of total weight at most `m−t+l`. When `k+l≤d`, the sum of these weight bounds is at most `m`. AME maximal mixing then makes these two spaces orthogonal.

Pair `E_k` with `F_(d−k)` for `0≤k≤d`. Each pair sums to at most the identity on the target-orthogonal space. For every nonnegative integer eigenvalue `a` of `A`, the number of indices in this range with `a≤k` is `(d+1)−min(a,d+1)`. Consequently summing the paired inequalities gives

`min(A,d+1)+min(D,d+1)≥(d+1)I`.

Since `A≥min(A,d+1)` and likewise for `D`, their sum is at least `(s−m+1)I`. The target is killed by both rejection sums, so on the full Hilbert space the result is

`Σ_selected (I−Π_S) ≥ (s−m+1)(I−Pψ)`.

This argument includes `s=m`, `r=0` or `t=0` when allowed, and `s=2m`. It uses spectral calculus separately inside each commuting star; it never interchanges noncommuting operators from different stars. The minimum symbols mean spectral truncation of one operator, not an operator-lattice minimum. At `s=m`, a density operator accepted by all tests must therefore be supported on the target ray. Matching the selected marginals implies acceptance, proving determination among all density operators.

For sorted nonnegative weights, set `w_0=0`. The layer expansion

`Σ_i w_i(I−Π_i)=Σ_k(w_k−w_(k−1)) Σ_(i≥k)(I−Π_i)`

is an exact identity. A tail with at least `m` members has the just-proved lower bound; shorter tails are positive. The resulting coefficient telescopes:

`Σ_(k=1)^(m+1)(w_k−w_(k−1))(m+2−k)=Σ_(i=1)^(m+1)w_i`.

This proves the claimed universal weighted inequality, including zero weights and ties. Uniform surviving settings give the stated universal erasure lower bound. The stabilizer proof still supplies equality by exhibiting characters that pass the `m−1` heaviest tests. Without stabilizers such a common orthogonal accepting vector is not supplied by the low-weight orthogonality argument; the prospective two error supports have total size `m+1`, beyond its guaranteed threshold. The stronger note correctly leaves that step open.

The single-party product-unitary sharpness proof in the original closeout remains valid and useful. It makes the uniform full-library gap and its fidelity-to-defect conversion exact even for the promised output class, but does not manufacture a worst vector for arbitrary mixed-star weights.

**Integration consequence:** update the packet's universal/stabilizer comparison table if this strengthening is adopted. “Every `m` doubled-star tests suffice” becomes universal, while the weighted row must distinguish a universal lower bound from stabilizer equality, and the finite-setting row must distinguish universal attainability guarantees from the stabilizer optimality theorem. A compact appendix proposition can include the selected-subset inequality and weighted consequence. Do not silently strengthen the original finite-setting optimum to arbitrary AME states.

## Final bounded check of the concrete proposal

I subsequently read Drafts A, B, and C of `2026-09-10-c1135-ame-lu-two-star-verification-audit-proposal.md` in full, together with its preceding measurement-model and implementation sentences. **Read depth: complete proof-level check of the three drafts; no fresh verification of the surrounding literature claims.**

**Acceptance:** all three drafts agree with the reviewed proofs. Draft A correctly optimizes over arbitrary fixed-support effects and retains additive stabilizer hypotheses for the exact setting curve. Draft B uses the current thresholds, the pure product-unitary promise, and the correct square-root conversion. Draft C correctly proves only a universal weighted lower bound, with exact full-uniform attainment; its spectral truncation is explicitly defined and its positive-gap implication gives determination among all density operators. The product-unitary sharpness remark is valid. No new substantive mathematical correction is required.

Two small definition repairs should be made when adopting Draft A: explicitly state `s` is an integer at least one (and `f` an integer in `[0,m]`), and define `Π_T=q^(m−1)ρ_T^ψ⊗I_(T^c)` for **every** `(m+1)`-party set `T`, since the arbitrary-effect comparison uses `Π_(S_a)` outside the initially defined library. These changes do not alter any proof.

Retain the implementation sentence beside the test definition. A classical mixture across different supports is a protocol with those separate subset choices for the setting-count claim; it cannot be relabeled as one allowed setting unless its effective effect itself has one permitted fixed support. This is already enforced by the displayed `E_a=E_(a,S_a)⊗I` definition, but a short explicit sentence would prevent resource-count ambiguity. Preserve the drafts' stated separation between stabilizer equality and universal lower bounds in any later abstract or table.
