# C1135 — independent adversarial mathematical audit

Date: 2026-09-10. Lane: `ame-lu`.

## Summary and contribution

The packet's central mathematics survives independent attack. In the stated model of perfectly complete binary effects touching at most `m+1` parties per copy, the stabilizer setting/gap tradeoff, arbitrary-weight formula, and universal full two-star gap have correct proofs. The positivity reduction genuinely handles arbitrary effects, not merely projectors. The quantitative wrapper and optional a posteriori certificate agree with the inspected manuscript statements.

A useful strengthening emerged: **every `m` selected doubled-star tests also determine an arbitrary nonstabilizer AME state**. More generally the stabilizer weighted formula is a universal lower bound, and every surviving `s>=m` tests have gap at least `(s-m+1)/s`. Exact attainment for arbitrary weights and a universal finite-setting upper bound are not established by this audit. The distinction matters: the packet's universal-property table is deliberately conservative, but its any-half entry can now be upgraded with the proof below.

## Significance and scope

The useful contribution is exact resource accounting for this particular measurement model, followed by an observable entrance criterion for existing rigidity estimates. A setting can involve joint operations and sequential internal generator measurements, provided the union of touched parties stays within the prescribed subset. It is not necessarily one product basis measurement. Perfect completeness and the per-copy locality budget are load-bearing.

The universal verification statements neither characterize stabilizer states nor imply universal LU-to-LC rigidity. The exact finite-setting optimum in the packet remains stabilizer-specific. No claim concerning priority or the absence of predecessors is made here; the root audit owns literature comparison.

## Correctness: core packet

### Arbitrary effects and the upper bounds

If `0<=E_S<=I` is perfectly complete, positivity of `I-E_S` and `Tr((I-E_S)rho_S)=0` force `(I-E_S)P_S=0`, where `P_S` is the marginal support projector. Thus `E_S=P_S + Q_S E_S Q_S >=P_S`; this also proves that a vector passing `P_S` passes `E_S` exactly. For `|S|<=m`, full rank forces `E_S=I`. This is the indispensable bridge from subgroup counting to the advertised arbitrary-effect model.

For stabilizer AME, an `(m+1)`-support contributes only `2e` independent prime-field constraints. The `m-1` largest-weight settings admit a nontrivial annihilating character even if their supports repeat or their subgroup spans overlap. Its state passes all those effects. This proves `nu<=1-(m-1)/t` for `t` positive weights; for `t<m` the same argument gives zero gap. Since `t<=s`, the upper bound for at most `s` settings follows with the correct monotonicity.

The locality upper bound uses only one-uniformity: for any one-uniform pure state on `n` equal-dimensional parties, tests touching at most `k` parties have `nu<=k/n`. Choose a traceless one-party unitary and note that omitted-site tests accept its orthogonal error state exactly. Averaging inclusion probabilities proves the assertion. This supplies the AME cap with `k=m+1,n=2m` without stabilizers or projectivity.

### Any-half spanning and weighted sharpness

For a mixed selection of `m` label subspaces, the two expressions for the sum of one star's terms constrain its support to the selected coordinates, whose total size is `m`. The minimum stabilizer support makes the sum zero. Coordinate projection then kills each summand, because that coordinate appears in only its own summand and projection on a minimum-support subgroup is injective. Dimensions complete the argument. No extension-field linearity is used.

A nontrivial character passes at most `m-1` doubled-star tests. Conversely the annihilator of any prescribed `m-1` groups has dimension `2e`, and its nonzero characters pass exactly those tests. Hence the sum of the `m+1` smallest weights is attained, including ties and zero weights. Uniformity is uniquely optimal in the full library for `m>=2`. The setting-erasure and setting-count formulas follow directly. The exclusion of `m=1` is appropriate: the nominal doubled library then repeats the all-party support and the uniqueness assertion fails.

### Universal full gap

Maximal entanglement across one balanced cut makes all tensor-unitary errors on that half a complete orthonormal basis. Each star projector tests whether a single error factor is the identity. Thus the one-star projectors commute, have product `Ppsi`, and have the stated binomial spectrum even without full AME.

For full AME, nontrivial error spaces on opposite halves with total weight at most `m` are orthogonal. Pairing their cumulative low-weight projections gives the inequality `H_B+H_C >=(m+1)(I-Ppsi)`. A one-site error attains equality. This proof never multiplies arbitrary cross-star projectors as though they commuted. The four-party commutativity statement is also correct: each three-party projector is `Ppsi` plus its omitted-party traceless-error space, and these latter spaces are pairwise orthogonal.

The additive MDS interpretation and inclusion–exclusion spectrum check analytically. Their arithmetic does not require the supplied finite scripts. In particular `m=2,q=3` gives multiplicities `1,32,48`, and `m=3,q=2` gives `1,45,0,18` in the listed weight sectors. These are hand substitutions into the proved formula, not a new computational evidence claim.

## Correctness: stronger universal result from the closeout pass

The following argument settles the additional any-half and weighted-lower-bound claims without cross-star commutativity.

Select `r` tests `C union {i}` with `i in I subset B`, and `t` tests `B union {j}` with `j in J subset C`. Put `s=r+t>=m` and `d=s-m`. Let `A` and `D` be their two rejection sums, restricted to `psi`-orthogonal space. Within each star the error basis shows that `A` counts nonidentity factors among the `r` selected B coordinates; `D` does the same among the `t` selected C coordinates.

For integer `k>=0`, write `E_k=1_{A<=k}` on this orthogonal complement and `F_k=1_{D<=k}`. A vector in `E_k` is spanned by nontrivial B errors of total weight at most `m-r+k`; a vector in `F_l` is spanned by nontrivial C errors of total weight at most `m-t+l`. Consequently

`E_k F_l=0` whenever `k+l<=d`,

by AME maximal mixing, since the total possible support is at most `m`. This includes endpoints where one projector vanishes or becomes the full orthogonal complement.

For each `k=0,...,d`, orthogonality gives `E_k+F_{d-k}<=I`. Integer spectral calculus gives

`sum_{k=0}^d E_k=(d+1)I-min(A,(d+1)I)`

and the analogous identity for `D`. Summing the orthogonality inequalities yields

`min(A,(d+1)I)+min(D,(d+1)I)>=(d+1)I`.

Therefore, on the full Hilbert space,

`sum_selected (I-Pi_S)>=(s-m+1)(I-Ppsi)`.

At `s=m`, the common accepting range is precisely the target ray, so the selected marginals determine the target among all density operators. For arbitrary nonnegative weights sorted as `w_1<=...<=w_{2m}`, put `w_0=0` and expand

`sum_i w_i(I-Pi_i)=sum_{k=1}^{2m}(w_k-w_{k-1}) sum_{i=k}^{2m}(I-Pi_i)`.

Applying the selected-subset bound to each tail with at least `m` members and positivity to smaller tails gives

`sum_i w_i(I-Pi_i)>=(sum_{i=1}^{m+1}w_i)(I-Ppsi)`.

This is valid at every integer local dimension admitting the AME state. Uniform full weights recover the exact universal optimum; nonuniform weights give a guaranteed gap. It proves universal resilience `nu_f>=(m+1-f)/(2m-f)` for `f<=m` missing settings, while the stabilizer theorem proves equality and setting-count optimality.

The missing step for arbitrary-weight equality is concrete. Let `T` be the `m-1` largest-weight settings. A vector orthogonal to `psi` passing every test in `T` would attain the bound, because any additional test together with `T` is an `m`-test family with rejection sum at least `I-Ppsi`, forcing that extra test to reject this vector completely. The stabilizer annihilator supplies such a vector. For a nonstabilizer target, a mixed `T` instead asks whether two operator-error ranges on opposite halves have a nontrivial intersection; their permitted support sizes sum to `m+1`. AME orthogonality only controls the threshold `m`, and ordinary rank counting does not force this intersection. This audit supplies neither a counterexample nor a proof of that stronger equality. Do not turn the proven lower bound into an equality by analogy.

## Correctness: observable and a posteriori certificates

The projector trace-distance bound has no dimension prefactor: `P_S` is an effect. Thus `1-F<=r/nu<=bar_d/nu`. For promised pure product-unitary outputs the exact conversion is `epsilon^2=2(1-sqrt(F))`; the packet's clipping at one and its inversion `Gamma_nu(t)=nu(t^2-t^4/4)` are correct.

The inspected quantitative source confirms the local threshold `1/24`, transition threshold `sqrt(2)/68`, and global radius `min(1/(4sqrt(2q)),1/(8pi sqrt(n)))`. The three conclusions have the right scopes. Logical rounding fixes a chosen logical leg using an exact stabilizer multiplication; it does not bound all factors of the character correction simultaneously. The conditional exact-base intertwiner reduction must remain conditional.

The a posteriori test `e+D/sqrt(q)<d_p` is valid: two-uniformity gives `||Mpsi||^2=D^2/q`, the integral formula bounds residual vector error by `D/sqrt(q)`, and the quantized overlap gap forces the candidate Clifford to preserve the target ray. Label preservation upgrades the separation to `sqrt(2)`. With `D^2<=q/4`, the residual stability proposition gives `D<=pi sqrt(q)e`.

The chord-only version has correct constants. `delta_i<sqrt(2/q)` gives centered logarithms with spread at most pi and `D^2<=(pi^2 q/4)sum delta_i^2`; the sum bound `1/pi^2` supplies the residual budget. The branch inequality is automatic under `e<1/24` because `1/24+1/2<sqrt(2-2/sqrt(2))`. These conditions need actual local-operation information; marginal outcome data alone does not supply it.

The ideal iid all-pass formula and `O(max(q,n)log(1/alpha))` substitution are algebraically correct with an integer-ceiling qualification. Calibration requires a true upper confidence bound plus the operator-norm error floor. No conclusion for arbitrary correlated inputs or unconditional factor recovery follows.

## Exposition and organization

The packet is much longer than the manuscript addition it motivates. The main text should retain the measurement model, direct-sum lemma, weighted/setting theorem, and one short rejection-to-rounding corollary. The qutrit example efficiently links character blindness and observable detection. The universal proof is short and valuable; if retained, use the stronger selected-subset version above rather than an additional parallel proof. The complete spectrum, optimization oracle, and a posteriori certificate are optional mathematical notes unless they support an explicit application.

## Major and minor comments

Major: no correctness blocker was found in the assigned packet. Preserve the measurement model beside every optimality claim. Preserve the stabilizer restriction on exact weighted attainment and arbitrary-library setting optimality. If the new universal strengthening is adopted, present it as a lower-bound theorem and prove its shifted filtrations explicitly.

Minor: use distinct symbols for the extension degree and a defect upper bound in the a posteriori proposition. Keep empirical frequency distinct from rejection confidence bounds. Keep normalized gaps distinct from parent-Hamiltonian gaps. At four parties, universal commutativity cannot be used as a stabilizer diagnostic. No new Lean coverage is implied by analytic correctness.

## Sources, read depth, and limits

Read the supplied `AME_LU_REVISION_PACKET_55e70c4.md` in full, with proof-level attention to Modules 1, 2, 3 and 8; Modules 4–7 were checked for consistency and dependency boundaries. Read the applicable expert route and complete AME dossier. Consulted the local quantitative TeX at lines 145–260, 349–485, and 527–690: full relevant overlap/chord/global/transition/logical statements and their displayed proofs; residual-stability theorem statement, without an independent re-audit of its complete earlier proof. These are explicit imported manuscript inputs for the wrapper audit. No external literature source was read for this subreport; named papers appearing inside the packet are not independent source verification here. No PDF/build/formal replay or finite-script execution was performed.

Workflow note: the initial live-handoff read exceeded the output bound and was truncated. It was replaced by bounded range reads; no mathematical evidence relies on that truncated output. This report is the sole task-owned file written by this subagent and is left uncommitted for the root's atomic audit commit, as instructed.

## Mystery ledger and recommendation

The explicit `ej` + `tt` closeout settled the apparent stabilizer dependence of any-half sufficiency and of the weighted lower bound: both follow from universal AME error-space orthogonality. The remaining exact-attainment question is the mixed `m-1`-test common-range intersection described above; it is an optional successor gate, not a defect in the packet's stated theorems. No other genuine mathematical mystery remains within this bounded audit.

Recommendation: accept the assigned mathematical core with minor scope/editorial revision, subject to the root's independent literature/adoption gate. The stronger universal lower-bound theorem is a low-cost optional upgrade; full universal weighted equality should remain unclaimed.
