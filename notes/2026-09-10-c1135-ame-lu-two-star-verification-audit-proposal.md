# C1135 — proposed manuscript changes

**Status:** reviewable proposal, not applied to the manuscript. Baseline: standalone `55e70c4`, authoritative manuscript `f6f342e24`. This text states mathematical contributions without a publication-priority claim. Literature evidence and read depths belong to the companion literature audit.

## Editorial decision

Keep the title and exact/robust rigidity hierarchy. Add one subsection after `prop:marginal-certification`, before a separately headed stochastic-conversion subsection. It should contain the test model, doubled-star lemma, weighted/setting theorem, a fidelity corollary, and the existing qutrit example's verification interpretation. Add a short observable-rounding corollary after `cor:logical-clifford-rounding`. Put the universal error-space proof in an appendix, preferably replacing optional exposition rather than expanding every section.

Estimated added length: 3–4 main-text pages and 1.5–2 appendix pages, not yet measured by typesetting. A hard shorter version retains the universal full-gap proof but leaves its weighted lower-bound strengthening in the research note. No extra abstract sentence is needed; one introduction paragraph suffices. Full spectrum, LP, sample-count exposition, and instance-specific branch certificate remain in this audit packet unless an explicit application earns their space.

## Motivation and literature text to insert

**Motivation, near the marginal-certification discussion:**

> Exact determination leaves a quantitative question: how reliably do the chosen marginal constraints detect a deviation from the target? Uniformly sampling the minimum family of \(m\) support tests gives gap \(1/m\). We therefore allow a test to act jointly on at most \(m+1\) parties of one copy and ask how many such tests are needed for a prescribed worst-case rejection rate. This is the first informative support size for an AME state, since every smaller marginal is maximally mixed. Two complementary families of marginal supports give an explicit optimal tradeoff. Their rejection probability bounds infidelity for arbitrary inputs and supplies an observable hypothesis for product-unitary rounding when that operation model is promised.

**Related work, immediately following the model and before the new theorem:**

> The verification-operator and spectral-gap framework, including the inverse-infidelity sampling law, is established by Pallister–Linden–Montanaro and Dangniam–Han–Zhu. The latter also prove the \(1/s\) bound for any minimal family of \(s\) tests and formulate stabilizer verification as a linear program in a common eigenbasis. Stabilizer determination from generator-support reductions is due to Wu et al.; generator-expectation fidelity certificates are developed by Kalev–Kyrillidis–Linke, and local ground-state verification for frustration-free Hamiltonians by Zhu–Li–Chen. Here the resource restriction is the number of parties touched on each copy. Joint measurements within the chosen subset are allowed. The result below determines the exact gap under this restriction and, for stabilizer targets, the complete tradeoff with the number of tests.

Use citations `PallisterLindenMontanaro2018`, `DangniamHanZhu2020`, existing `WuYangWangWenQin2015`, proposed `KalevKyrillidisLinke2019`, and `ZhuLiChen2024`. The last two are close sources missing from the supplied packet's proposed additions. Tóth–Gühne remains in the existing witness discussion; do not repeat it as another new discovery. The minimal-test bound is DHZ Proposition 1, not a new AME verification principle. Canonical projectors/eigenbasis LP are DHZ Lemma 5, Theorem 1 and Section V.B. ZLC Theorem 2 already relates a sampled bond verifier to the Hamiltonian gap; our job is to calculate the AME gap and prove its resource-optimality.

**Implementation sentence:**

> Each setting is a binary effect on a specified subset; it may require joint operations or several commuting-observable measurements within that subset. Thus the setting count does not count single-party measurement bases, gates, or marginal-tomography settings.

This model is meaningful as a support-budget optimization; no claim of superior laboratory cost or optimal LOCC verification is warranted. The two measurement classes are incomparable: single-party measurements may touch all parties, while the proposed subset tests may be entangled within their support.

For the universal appendix, add once: “The one-star construction is a virtual-factor parent Hamiltonian: writing the maximally entangled state as a unitary image of \(m\) Bell pairs conjugates the pair projectors to the star projectors. This is consistent with the virtual-subsystem stabilization framework of Johnson–Ticozzi–Viola and the canonical marginal-support parent framework discussed by Karuvade–Johnson–Ticozzi–Viola.” Cite arXiv:1703.06183, Sections IV–V, and arXiv:1711.11142, Sections 2 and 5.1. The identification with this particular Bell-pair construction is our elementary inference; neither citation is offered as the source of the new two-star gap calculation.

## Draft A: complementary marginal verification

Suggested labels: `subsec:optimal-marginal-verification`, `lem:two-star-direct-sum`, `thm:two-star-weighted-gap`, `thm:setting-gap-tradeoff`, `eq:two-star-gap`, `eq:setting-gap-tradeoff`. Use automatic numbering.

Let \(\psi\) be an additive stabilizer \(\operatorname{AME}(2m,q)\), \(q=p^e\), \(m\ge2\). Fix complementary halves \(B,C\), and write
\[
\mathcal S=\{B\cup\{j\}:j\in C\}\cup\{C\cup\{i\}:i\in B\},\qquad
\Pi_S=q^{m-1}\rho_S^\psi\otimes I_{S^c}.
\]
The same formula defines \(\Pi_T\) for every \((m+1)\)-party set \(T\), whether or not it belongs to \(\mathcal S\). A test has accept effect \(E_a=E_{a,S_a}\otimes I_{S_a^c}\), where \(0\le E_{a,S_a}\le I\), \(|S_a|\le m+1\), and \(E_a\psi=\psi\). Each setting has a fixed support; internal randomization over different supports counts as separate settings. For probabilities \(w_a\), put \(\Omega=\sum_a w_aE_a\) and
\[
\nu(\Omega)=\min_{\|v\|=1,\ v\perp\psi}\langle v|(I-\Omega)|v\rangle.
\]
The support projector is the strongest perfectly complete test on a given support: positivity of \(I-E_{a,S_a}\) and zero expectation against \(\rho_{S_a}^\psi\) show that it annihilates the marginal support. Hence \(E_a\ge\Pi_{S_a}\) when \(|S_a|=m+1\). If \(|S_a|\le m\), full rank instead forces \(E_a=I\).

**Lemma (complementary direct sums).** Any \(m\) distinct spaces \(L(S)\), \(S\in\mathcal S\), have direct sum \(L\).

**Proof.** Choose \(I\subset B,J\subset C\) with \(|I|+|J|=m\) and a relation \(\sum_{i\in I}u_i+\sum_{j\in J}v_j=0\), with \(u_i\in L(C\cup\{i\})\), \(v_j\in L(B\cup\{j\})\). The vector \(w=\sum_i u_i=-\sum_jv_j\) has its \(B\)-support in \(I\) and \(C\)-support in \(J\). Its support has size at most \(m\), so the AME support theorem gives \(w=0\). Projection to \(i\in I\) isolates \(u_i\), whose projection is injective; similarly each \(v_j=0\). Each summand has prime-field dimension \(2e\), so their dimensions add to \(\dim_{\mathbb F_p}L=2em\). ∎

**Theorem (weighted gap).** For probabilities on \(\mathcal S\), sorted as \(w_{(1)}\le\cdots\le w_{(2m)}\),
\[
\nu\left(\sum_{S\in\mathcal S}w_S\Pi_S\right)=\sum_{a=1}^{m+1}w_{(a)}.
\]
In particular the unique optimal weights within the full library are uniform, giving \(\nu_*=(m+1)/(2m)\).

**Proof.** Choose stabilizer lifts fixing \(\psi\). Their joint eigenbasis is indexed by characters of \(L\), with \(\psi\) the trivial character. The subgroup average \(\Pi_S\) accepts exactly those characters trivial on \(L(S)\). A nontrivial character cannot pass \(m\) tests, by the lemma, and so fails at least \(m+1\). Conversely, any chosen \(m-1\) test subspaces have a \(2e\)-dimensional annihilator. Every nonzero character there passes exactly those tests. Choosing the \(m-1\) largest weights as the pass set proves equality. The sum of the \(m+1\) smallest weights is at most \((m+1)/(2m)\), with equality only when all weights agree. This includes zero weights and ties. ∎

**Theorem (support and setting optimum).** For every integer \(s\ge1\), among protocols with at most \(s\) perfectly complete tests, each supported on at most \(m+1\) parties,
\[
\nu_{\max}(s)=\begin{cases}
0,&s<m,\\
1-(m-1)/s,&m\le s\le2m,\\
(m+1)/(2m),&s\ge2m.
\end{cases}
\]
Any \(s\) members of \(\mathcal S\), sampled uniformly, attain the middle branch.

**Proof.** A test on \(m+1\) parties contributes at most \(2e\) independent character constraints; a smaller test contributes none. Any fewer than \(m\) settings admit a nontrivial character passing all their support projectors and therefore all their effects. If there are \(t\ge m\) positive weights, a nontrivial character passes the \(m-1\) heaviest settings. Thus \(\nu\le1-(m-1)/t\le1-(m-1)/s\). For a separate locality bound, choose a traceless unitary on any party \(i\). Its error state is orthogonal to \(\psi\); any test omitting \(i\) accepts it. Therefore \(\nu\le\Pr(i\text{ is touched})\). Averaging over parties gives \(\nu\le(m+1)/(2m)\). The weighted theorem attains these bounds by uniform sampling of \(s\) library members, or all \(2m\) when \(s\ge2m\). ∎

The locality argument in fact holds for every one-uniform pure state on \(n\) parties, with cap \(k/n\) for \(k\)-party tests. The full two-star optimum itself holds for every AME state, as proved in Draft C below. The arbitrary-library finite-setting optimum above retains its stabilizer hypothesis.

**Corollary (fidelity and setting loss).** With \(H_*=I-(2m)^{-1}\sum_S\Pi_S\), every density operator \(\sigma\) satisfies
\[
1-\langle\psi|\sigma|\psi\rangle\le\frac{\operatorname{Tr}(H_*\sigma)}{\nu_*}
\le\frac1{m+1}\sum_{S\in\mathcal S}\frac12\|\sigma_S-\rho_S^\psi\|_1.
\]
If an integer \(0\le f\le m\) test settings are unavailable, uniform sampling of the survivors has exact gap \((m+1-f)/(2m-f)\). The systems remain available; only the test library is reduced.

**Proof.** The spectral-gap inequality supplies the first bound. On \(S\), \(q^{m-1}\rho_S^\psi\) is an effect, so each rejection probability is at most the marginal trace distance. Average and divide by \(\nu_*\). For setting loss apply the weighted formula with \(f\) zero weights. ∎

**Example.** For the four-qutrit state in `subsec:four-qutrit-example`, the library consists of all four three-party marginal tests. Any two, three, or four sampled uniformly have gaps \(1/2,2/3,3/4\). The shifted state \(Z_1(1)\psi\) passes only the test omitting party 1. For every support containing party 1, the local projection of its stabilizer subgroup is surjective, so the shift induces a nontrivial character and the subgroup average is zero. Its rejection rate is \(3/4\), attaining the gap. Thus the tests detect the character change invisible to the transition maps. No new example or computational premise is needed.

## Draft B: observable entry into rounding

Place after `cor:logical-clifford-rounding`; suggested label `cor:marginal-certified-rounding`.

**Corollary.** Suppose the target is as above and the input is \(U|\psi\rangle\langle\psi|U^\dagger\) for a promised product unitary \(U\). Let \(\gamma\ge0\) be a valid upper bound on its rejection probability. Define
\[
a=\min\{\gamma/\nu_*,1\},\qquad
\eta(\gamma)=\sqrt{2(1-\sqrt{1-a})},\qquad
\Gamma_\nu(t)=\nu(t^2-t^4/4).
\]
Then \(\varepsilon(U)\le\eta(\gamma)\). A bound \(\gamma<\Gamma_{\nu_*}(t)\) enters the following existing rounding regimes:

| \(t\) | Consequence |
|---|---|
| \(1/24\) | Every factor is within normalized phase-optimized Hilbert–Schmidt distance \(8\eta(\gamma)\) of a Clifford. |
| \(\sqrt2/68\) | Rounded frames satisfy the transition equations; a Pauli correction gives an exact symmetry, and any chosen logical leg has an exactly transversally implementable logical Clifford within \(8\eta(\gamma)\). The correction is not asserted to be locally small. |
| \(R^{\mathrm{clean}}_{2m,q}\) | The nearby exact symmetry and collective-generator estimate of `thm:cleaning-global-rounding` hold, with defect bound \(\eta(\gamma)\). |

**Proof.** For the pure output, \(\varepsilon(U)^2=2(1-\sqrt F)\). Substitute the fidelity lower bound. For \(0<t<\sqrt2\), the inequality \(\gamma<\nu_*(t^2-t^4/4)\) yields \(1-\gamma/\nu_*>(1-t^2/2)^2\), hence \(\eta(\gamma)<t\). Apply the cited local, transition/logical, and global results. ∎

Here \(R^{\mathrm{clean}}_{n,q}=\min\{1/(4\sqrt{2q}),1/(8\pi\sqrt n)\}\). No radius is enlarged. For arbitrary mixed inputs only the fidelity result applies. A statistical upper bound on rejection, rather than a bare observed failure frequency, supplies \(\gamma\). If measurement calibration contributes average operator-norm error \(\bar\kappa\), use \(\gamma=r_{\rm up}+\bar\kappa\).

Optional one-line sampling consequence: for ideal iid copies of a fixed promised output, all-pass testing rejects the hypothesis \(\varepsilon(U)\ge t\) with false-acceptance probability at most \([1-\Gamma_{\nu_*}(t)]^N\). At the global radius this gives a sufficient \(O(\max\{q,n\}\log(1/\alpha))\) sample count. Cite the established statistical law; this is a substitution into the revised radius, not a new sampling theorem.

## Draft C: universal error-space appendix

Suggested label `prop:universal-marginal-verification`. Let \(\psi\) be any \(\operatorname{AME}(2m,q)\), with \(q\ge2\) any integer and \(m\ge2\). Define the same library and support projectors.

**Proposition.** For arbitrary nonnegative library weights summing to one,
\[
I-\sum_Sw_S\Pi_S\ \ge\left(\sum_{a=1}^{m+1}w_{(a)}\right)(I-|\psi\rangle\langle\psi|).
\]
In particular any \(m\) distinct library marginals determine the state among all density operators. Uniform full sampling has gap exactly \((m+1)/(2m)\), optimal among all allowed support-bounded tests. Exact arbitrary-weight equality and the finite-setting upper bound are asserted only for stabilizer targets.

**Proof.** Choose a Hilbert–Schmidt orthogonal unitary basis on each site, with the identity distinguished. Maximal mixing of \(B\) makes the \(q^{2m}\) states \(W_B\psi\) an orthonormal basis. The projector on \(C\cup\{i\}\) has rank \(q^{2m-2}\); its range contains exactly the \(q^{2m-2}\) basis vectors with identity error at \(i\). Thus it tests that error coordinate, and each star is a commuting family. Its full product is the target projector; the one-star rejection sum counts nonidentity error coordinates. This paragraph only needs maximal entanglement across the balanced cut.

Select \(r\) tests from this star and \(t\) from the other, with \(s=r+t\ge m\), and put \(d=s-m\). On \(\psi^\perp\), let \(A,D\) be their rejection sums and \(E_k=\mathbf1_{A\le k}\), \(F_l=\mathbf1_{D\le l}\). The range of \(E_k\) is spanned by nontrivial errors on \(B\) of weight at most \(m-r+k\); similarly the opposite-half weight bound is \(m-t+l\). If \(k+l\le d\), the combined support is at most \(m\). AME maximal mixing makes the corresponding error vectors orthogonal, so \(E_kF_l=0\). In particular \(E_k+F_{d-k}\le I\) for \(0\le k\le d\).

The spectra of \(A,D\) are nonnegative integers. Consequently
\[
\sum_{k=0}^dE_k=(d+1)I-\min\{A,(d+1)I\},
\]
where the minimum is defined by spectral calculus, and likewise for \(D\). Summing the preceding projection inequalities yields \(A+D\ge(d+1)I\). Restoring the target ray proves
\[
\sum_{S\text{ selected}}(I-\Pi_S)\ge(s-m+1)(I-|\psi\rangle\langle\psi|).
\]
This includes endpoints where a spectral projection is zero or the identity.

For sorted weights \(w_1\le\cdots\le w_{2m}\), set \(w_0=0\) and expand the weighted rejection sum as
\[
\sum_{k=1}^{2m}(w_k-w_{k-1})\sum_{i=k}^{2m}(I-\Pi_i).
\]
Apply the selected-set inequality to tails of size at least \(m\), and positivity to the others. The resulting coefficient is \(\sum_{i=1}^{m+1}w_i\), as claimed. Positive gap for any \(m\) selected tests proves determination by their marginals through the common accepting range.

For uniform full weights, a traceless one-site error has weight one in its own-half error basis. It is orthogonal to every opposite-half error of weight at most \(m-1\), hence has weight \(m\) there. It therefore attains rejection eigenvalue \((m+1)/(2m)\). The one-party-error locality upper bound from Draft A proves optimality in the allowed measurement model. ∎

**Optional sharpness remark connecting back to rounding.** For any one-site unitary \(V_i\), write \(V_i=aI+A_i\) with \(a=q^{-1}\operatorname{Tr}V_i\) and \(\operatorname{Tr}A_i=0\). The preceding proof places \(A_i\psi\) in the minimum-gap eigenspace. Thus
\[
\operatorname{Tr}(H_* V_i|\psi\rangle\langle\psi|V_i^\dagger)
=\nu_*(1-|a|^2).
\]
The fidelity conversion is therefore attained within product-unitary outputs. An improved uniform rounding radius cannot come just from improving this scalar rejection-to-defect inequality.

## Deferred modules and integration checks

- MDS spectrum: mathematically correct; standard inclusion–exclusion on an additive code. Retain qutrit illustration, defer full enumerator. It cannot distinguish LU classes with the same \(m,q\).
- Weight LP: correct order-statistic specialization of an established optimization framework. Defer unless costs/unavailable settings are an actual application; a positivity-cardinality constraint is not encoded by the mean-cost LP.
- Instance-specific branch certificate: correct conditional corollary, useful in a computational implementation with known local operations. Defer to a remark or companion note; do not advertise a stronger uniform radius.
- Four-party commutativity caution: correct; include only if discussing a commutator diagnostic. All four projectors commute for arbitrary AME(4,q), so it cannot characterize stabilizer states.
- No new formal coverage. If adopted, add manuscript-only rows to the trust-boundary table, preserve stable labels, check appendix-letter references, and run the ordinary manuscript/release gates and cold/blind rendered comparison. No such build or adoption occurred in C1135.
