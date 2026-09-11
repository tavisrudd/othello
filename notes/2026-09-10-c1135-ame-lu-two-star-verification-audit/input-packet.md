# Revision packet: Robust Local-Unitary Rigidity of Stabilizer AME States

Updated against manuscript commit `55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82`.

**Read the [revision delta](#module-8) first.** It identifies the obsolete quantitative constants, supplies a three-level observable certificate, and connects verification to the new four-qutrit example. The two-star verification theorems themselves are still proposed additions, not results already merged into the pinned manuscript.

## Recommendation

Add a short **optimal marginal verification** subsection, connect its observable rejection probability to the existing robust-rounding theorem, and put the universal-AME proof and detailed spectrum in an optional appendix. Keep the title and the paper's exact/robust LU-rigidity focus. Do not fold the six-arc phase-classification programme or the Ergodis benchmarks into this revision.

The most useful new statement is stronger than the earlier two-star gap claim. For a stabilizer AME state on `2m` parties, the optimal gap achievable with **at most `s` perfectly complete tests, each touching at most `m+1` parties per copy**, is

$$
\boxed{
\nu_{\max}(s)=
\begin{cases}
0,&1\le s<m,\\
1-\dfrac{m-1}{s},&m\le s\le2m,\\
\dfrac{m+1}{2m},&s\ge2m.
\end{cases}}
$$

Any `s` tests from two complementary marginal stars, sampled uniformly, attain the middle branch. The full two-star construction attains the last branch. The unrestricted-in-setting-count gap `(m+1)/(2m)` also holds, with a separate proof, for **every** AME state, without a stabilizer assumption.

This is a bound for the explicitly stated measurement model, not an LOCC or individual-Pauli-setting optimum. A setting is a binary effect on a chosen subset, and joint operations within that subset are allowed.

## Packet map

| File | Purpose | Recommended destination |
|---|---|---|
| [`01_main_text_insertions.md`](#module-1) | Complete stabilizer proofs: two-star independence, weighted gap, exact setting/gap tradeoff, setting erasures | Main text, after marginal certification |
| [`02_universal_extension_and_spectrum.md`](#module-2) | Stabilizer-independent star construction and sharp gap; additive MDS spectrum; four-party commutativity caution | Optional appendix |
| [`03_observable_robustness_bridge.md`](#module-3) | Fidelity, trace-distance and calibrated-test bounds; observable entry criterion for current rounding theorem; character boundary | Short corollary in main text, details in appendix |
| [`04_algorithmic_verifier_design.md`](#module-4) | Linear-size LP for constrained two-star weights; finite-field worst-character witnesses; optional general Ergodis oracle | Algorithmic remark or companion note |
| [`05_patch_plan_and_claim_audit.md`](#module-5) | Exact insertion anchors, draft framing, theorem dependencies, prior-claim audit, formalization boundary | Revision instructions |
| [`06_sources_and_bibliography.md`](#module-6) | Source snapshot, primary literature, citation placement and two new BibTeX entries | Bibliography/reviewer preparation |
| [`07_audit_record.md`](#module-7) | What was checked, finite arithmetic sanity checks, what remains unverified | Author-facing only |
| [`08_revision_delta.md`](#module-8) | Changes against the new commit, threshold table, qutrit example, sample-cost and a posteriori corollaries | Read first; optional insertions clearly marked |

## Source and proof status

This rebase supersedes the original packet keyed to `f5eb6b2`. The source target is the public export at commit

`55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82` (pinned revised source),

not an unseen local working revision. The source was inspected as TeX and Markdown, including the marginal-certification proposition, quantitative theorem, bibliography, and trust-boundary appendix. No PDF analysis or source build was performed. The packet does not modify the repository.

The additions below are **proposed manuscript results with complete arguments supplied**, not claims of established publication priority or Lean verification. The original packet supplied re-derived universal-verification and finite-setting proofs. This rebase checked their dependencies and numerical wrappers against the revised source; it is not a full independent re-audit of every manuscript theorem. Small exact stabilizer checks support the examples; they are not dependencies of the general theorems. The earlier general six-arc torsion/classification argument was not independently re-audited here and is not used anywhere in the recommended insertion.

## Keep these distinctions visible

**Certification is not rigidity.** A verification operator controls distance to a known state. It does not recover a product-unitary factorization or imply LU=LC for arbitrary AME states.

**A constant verification gap is not a larger rounding radius.** The observable corollary enters the existing radius; it does not remove its dependence on `n` or `q`; the revision has already removed the separate characteristic penalty.

**Test erasures are not party erasures.** The exact failure formula concerns unavailable measurement settings while copies of the full state remain available.

**Additive does not mean extension-field linear.** All stabilizer label and syndrome spaces are over the prime field. The alphabet size `q^2` in the spectrum calculation does not introduce an assumption of linearity over `F_(q^2)`.

**Operational counts are not implementation costs.** Two-star verification has `2m` compound binary tests. This is not a claim of `2m` one-party measurement bases or a constant-size circuit for each marginal projector.


---

<a id="module-1"></a>

## 1. Proposed main-text insertion: optimal marginal verification

**Insertion point:** in `sections/03-exact-rigidity-atlas.tex`, after the proof and related-work discussion of `prop:marginal-certification`, before `cor:stochastic-conversion`. A separate subsection entitled “Optimal verification from complementary marginal stars” will keep certification separate from stochastic conversion.

**Dependencies:** only the existing stabilizer-AME support theorem, the dimension of the additive label space, and the standard joint stabilizer eigenbasis. No quantitative-rounding argument, endomorphism classification, computer calculation, or phase-family theorem is needed.

### 1.1 Definitions and measurement model

Let `q=p^e`, let `m>=2`, and let `|psi>` be a stabilizer `AME(2m,q)` state with additive label space `L`. Fix a bipartition

$$
B\sqcup C=[2m],\qquad |B|=|C|=m.
$$

Use the two complementary stars

$$
\mathcal S=
\{A_j=B\cup\{j\}:j\in C\}
\cup
\{D_i=C\cup\{i\}:i\in B\}.
$$

For each `S` in this family, define the support projector

$$
\Pi_S=q^{m-1}\rho^\psi_S\otimes I_{S^c}.
$$

The factor `q^(m-1)` is the reciprocal of each nonzero marginal eigenvalue; thus `Pi_S` is a projector, not a rescaled density operator used without a norm bound.

A verification protocol is a finite collection of effects `0<=E_a<=I` with probabilities `w_a`, each supported on at most `m+1` parties and satisfying `E_a|psi>=|psi>`. Its average acceptance and rejection operators are

$$
\Omega=\sum_a w_aE_a,\qquad \mathcal H=I-\Omega.
$$

Define its gap as

$$
\nu(\Omega)=
\min_{\substack{\|v\|=1\\v\perp\psi}}
\langle v|\mathcal H|v\rangle.
$$

A setting is one such binary test on a selected subset. Joint measurements within the subset are permitted. The restriction concerns the total set touched on a single copy, not the locality of each gate in a longer all-party protocol.

This is the usual verification-operator normalization [V1, V2 in Module 6]. In particular, the existing one-star parent Hamiltonian has unnormalized gap `1`, but uniform one-star sampling has normalized gap `1/m`.

### 1.2 Lemma: every half of the doubled atlas is a basis

Suggested label: `lem:two-star-direct-sum`.

**Lemma.** Every collection of `m` distinct subspaces from

$$
\{L(A_j):j\in C\}\cup\{L(D_i):i\in B\}
$$

has direct sum equal to `L`.

**Proof.** Each subspace has dimension `2e` over `F_p`, and `dim L=2em`. Let `I` be a subset of `B` and `J` a subset of `C`, with `|I|+|J|=m`. Consider a relation

$$
\sum_{i\in I}u_i+\sum_{j\in J}v_j=0,
\qquad
u_i\in L(D_i),\quad v_j\in L(A_j),
$$

and set

$$
w=\sum_{i\in I}u_i=-\sum_{j\in J}v_j.
$$

The first expression shows that the `B`-support of `w` lies in `I`; the second shows that its `C`-support lies in `J`. Thus `w` has support at most `m`. The AME support condition forces `w=0`.

Projection onto a coordinate `i in I` now gives `u_i=0`: within the `D_i` star, only that summand can have a nonzero `i`-coordinate, and projection at `i` is injective on `L(D_i)`. Similarly every `v_j=0`. The sum is direct. Its dimension is `m(2e)=dim L`, so it equals `L`. ∎

All vector spaces here are over `F_p`; there is no `F_q`-linearity assumption.

### 1.3 Theorem: weighted gap and the optimal full two-star protocol

Suggested label: `thm:two-star-weighted-gap`.

**Theorem.** Assign nonnegative probabilities `(w_S)_(S in mathcal S)` summing to one, and sort them as

$$
w_{(1)}\le\cdots\le w_{(2m)}.
$$

For

$$
\Omega_w=\sum_{S\in\mathcal S}w_S\Pi_S
$$

the exact gap is

$$
\boxed{\nu(\Omega_w)=\sum_{a=1}^{m+1}w_{(a)}.}
\tag{1.1}
$$

In particular, uniform weights give

$$
\boxed{
\mathcal H_*:=\frac1{2m}\sum_{S\in\mathcal S}(I-\Pi_S)
\ \ge\ \frac{m+1}{2m}(I-|\psi\rangle\langle\psi|),
\qquad
\nu(\Omega_*)=\frac{m+1}{2m}.
}
\tag{1.2}
$$

Uniform weights are the unique maximizing weights within this full library.

**Proof.** Use the actual stabilizer group, with its lifts chosen to fix `psi`. It is an elementary abelian group with label space `L`. Its joint eigenvectors form a basis indexed by additive characters `chi` of `L`; the trivial character labels `psi`. Each joint eigenspace is one-dimensional. For example, its character projector has trace one by Weyl orthogonality.

On the eigenvector for `chi`, the projector `Pi_S`, which averages the subgroup with labels in `L(S)`, has eigenvalue

$$
\begin{cases}
1,&\chi|_{L(S)}=1,\\
0,&\chi|_{L(S)}\ne1.
\end{cases}
$$

A nontrivial character cannot pass `m` tests: their subgroups span `L` by the lemma. Hence it fails at least `m+1` tests, and its rejection eigenvalue is at least the right side of (1.1).

Conversely, choose any `m-1` of the test subgroups. Their direct sum has codimension `2e`, so it has a nontrivial annihilating character. That character cannot annihilate any additional test subgroup. It therefore fails **exactly** the complementary `m+1` tests. Choosing the `m-1` largest-weight tests as its pass set attains the right side of (1.1).

The sum of the `m+1` smallest probabilities is at most `(m+1)/(2m)`. Equality forces all probabilities to be equal, since `m+1<2m` for `m>=2`. This proves the final statements. ∎

A useful feature of the proof is that it constructs an exact worst-case character. The bound is not obtained by counting tests alone.

### 1.4 Proposition: the locality upper bound

Suggested label: `prop:verification-locality-bound`.

**Proposition.** For any `AME(2m,q)` state, whether stabilizer or not, every perfectly complete verification protocol with tests supported on at most `m+1` parties has

$$
\boxed{\nu(\Omega)\le\frac{m+1}{2m}.}
\tag{1.3}
$$

**Proof.** For each party `i`, choose a traceless unitary `W_i` on that party. Its error state `W_i|psi>` is normalized and orthogonal to `psi`, because the one-party marginal is maximally mixed.

Every test whose support omits `i` accepts this error state with certainty: its local density operator is unchanged. A test touching `i` rejects with probability at most one. Consequently

$$
\nu(\Omega)\le\Pr(i\text{ is touched})
$$

for every `i`. Averaging these inclusion probabilities gives

$$
\min_i\Pr(i\text{ is touched})
\le\frac{\mathbb E|S|}{2m}
\le\frac{m+1}{2m}.
$$

This proves (1.3). ∎

The proof permits arbitrary positive binary effects and arbitrary joint operations within a chosen support. It does not assert optimality among all-party separable measurements or protocols that sequentially touch more than `m+1` parties on one copy.

### 1.5 Theorem: the complete setting-count/gap tradeoff

Suggested label: `thm:setting-gap-tradeoff`.

**Theorem.** For a stabilizer `AME(2m,q)` state, let `nu_max(s)` be the supremum gap over protocols with at most `s` perfectly complete binary tests, each supported on at most `m+1` parties. For every integer `s>=1`,

$$
\boxed{
\nu_{\max}(s)=
\begin{cases}
0,&s<m,\\[2mm]
1-\dfrac{m-1}{s},&m\le s\le2m,\\[2mm]
\dfrac{m+1}{2m},&s\ge2m.
\end{cases}}
\tag{1.4}
$$

For `m<=s<=2m`, **every** choice of `s` tests from `mathcal S`, sampled uniformly, is optimal in this measurement model.

**Proof: the upper bound.** First, perfect completeness of an effect on a support `S` forces it to act as the identity on the support of `rho_S^psi`. To see this, `I-E_S` is positive and has zero expectation against `rho_S^psi`; it therefore annihilates the support of that state. Positivity also removes off-diagonal blocks relative to the support/kernel decomposition. Hence

$$
E_S\ge P_{\operatorname{supp}\rho_S^\psi}.
$$

If `|S|<=m`, the marginal is full rank, so `E_S=I` and the test is uninformative. If `|S|=m+1`, the support projector is the subgroup projector for a `2e`-dimensional subspace of `L`.

Any fewer than `m` such subspaces have total span dimension less than `2em`. A nontrivial character annihilates them all. Its joint stabilizer eigenvector passes their support projectors, and therefore their perfectly complete effects, with certainty.

Suppose a protocol has `t>=m` positive-probability settings. Choose its `m-1` largest probabilities. Some nontrivial character passes all those tests; it is rejected by the remaining tests with probability at most their total weight. Thus

$$
\nu(\Omega)\le
1-\sum_{a=1}^{m-1}w_{[a]}
\le1-\frac{m-1}{t},
$$

where square brackets denote decreasing order. If `t<m`, its gap is zero. Since `t<=s`, and by (1.3), these inequalities give the claimed upper bound.

**Proof: attainment.** For `m<=s<=2m`, put weight `1/s` on any `s` members of `mathcal S` and zero on the others. Equation (1.1) gives

$$
\nu=\frac{s-m+1}{s}.
$$

For `s>=2m`, use the full uniform protocol. For `s<m`, every allowed protocol has gap zero. ∎

This packages three optimality statements together: `m` settings are necessary for positive gap; a minimal `m`-setting protocol has optimal gap `1/m`; and `2m` settings are necessary and sufficient for the locality-optimal gap `(m+1)/(2m)`.

### 1.6 Corollary: exact resilience to missing test settings

If any `f<=m` of the two-star settings become unavailable, sampling the remaining settings uniformly gives

$$
\boxed{\nu_f=\frac{m+1-f}{2m-f}.}
\tag{1.5}
$$

This is optimal among all allowed protocols with that many settings. Any `m` survivors still identify the target. With fewer than `m` survivors, no perfectly complete protocol using only those settings has positive gap.

These are **measurement-setting erasures**. The state still occupies all `2m` parties; this is not a claim about verifying it after losing quantum subsystems.

### 1.7 Recommended short prose following the theorem

> A dimensionally minimal atlas and an optimal verifier are different objects. One star gives the minimum number of marginal constraints needed to determine a stabilizer AME state. The complementary star supplies redundancy that improves the normalized verification gap from `1/m` to `(m+1)/(2m)`. More generally, the exact tradeoff (1.4) quantifies how each additional setting improves worst-case verification. The optimum concerns subset-local perfectly complete tests; it does not assume that each projector is a single tensor-product measurement basis.

**Optional one-sentence extension:** “The full two-star gap is stabilizer-independent: it holds for every AME state, as shown in Appendix [universal verification].” Use Module 2 for the proof; do not extend the weighted formula or the setting-count theorem to non-stabilizer states without another argument.


### 1.8 Connect to the revised four-qutrit example

The current manuscript already includes `subsec:four-qutrit-example`. Reuse its state and the shift `phi=Z_1(1)psi`. The four three-party supports are a full two-star library. Two, three, and four uniform tests have sharp gaps `1/2`, `2/3`, and `3/4`. The shifted state passes precisely the test omitting party 1 and is rejected by the other three, attaining the last gap while retaining the same transition maps.

The proof and optional spectrum `(0:1, 3/4:32, 1:48)` are given in Section 3 of `08_revision_delta.md`. This provides a coherent worked example across support geometry, character correction, and verification without adding another state construction.


---

<a id="module-2"></a>

## 2. Optional appendix: universal AME verification and the stabilizer spectrum

This appendix separates the part of the certification geometry that needs only maximal mixing from the part that uses additive stabilizer labels. Its first two results are complete analytic proofs, not consequences of the six-arc phase calculations.

### 2.1 One star works without a stabilizer assumption

**Lemma.** Let `|psi>` be a pure state on `B union C`, where both halves contain `m` parties of dimension `q`, and suppose only that

$$
\rho_B=I/q^m.
$$

For `i in B`, define

$$
\Pi_i=q^{m-1}\rho^\psi_{C\cup\{i\}}\otimes I_{B\setminus\{i\}}.
$$

Then the `Pi_i` are commuting orthogonal projectors,

$$
\prod_{i\in B}\Pi_i=|\psi\rangle\langle\psi|,
$$

and

$$
H_B=\sum_{i\in B}(I-\Pi_i)
$$

has eigenvalues `k=0,...,m` with multiplicities

$$
\boxed{\binom mk(q^2-1)^k.}
\tag{2.1}
$$

Consequently these `m` marginals determine `psi` among all density operators, and the unnormalized parent gap is exactly one.

**Proof.** On each party choose a Hilbert–Schmidt orthogonal unitary basis containing the identity. Such a basis exists for every integer `q>=2`, for example the cyclic shift-and-clock basis; no finite-field structure is needed.

For tensor products `W,W'` of these operators on `B`,

$$
\langle\psi|W^\dagger W'|\psi\rangle
=q^{-m}\operatorname{Tr}(W^\dagger W').
$$

Thus the `q^(2m)` states `W|psi>` form an orthonormal basis of the full Hilbert space.

Across the split `(B minus {i}) | (C union {i})`, the state has `q^(m-1)` equal Schmidt coefficients. Hence `Pi_i` is a projector of full-space rank `q^(2m-2)`. Its range contains all states `W|psi>` whose error on party `i` is the identity: those errors act only on the traced-out subsystem `B minus {i}`. There are exactly `q^(2m-2)` such orthonormal states, so they form its range.

Each `Pi_i` is therefore diagonal in the same error basis, testing whether the `i`th error factor is the identity. Their product selects only the all-identity error, namely `psi`. The rejection sum counts nonidentity error factors; counting them gives (2.1).

If an arbitrary density operator has the same selected marginals, it is accepted by every `Pi_i`. Positivity places its support in their common one-dimensional range, so it equals the target projector. ∎

This lemma generalizes the star-specific existence and gap assertions of `prop:marginal-certification`. It does **not** generalize its arbitrary-family stabilizer-span criterion. Keeping the current proposition and adding this lemma as a remark/appendix avoids blurring those hypotheses.

### 2.2 The sharp full two-star gap for every AME state

**Theorem.** Let `|psi>` be any `AME(2m,q)` state, with `m>=2` and integer `q>=2`. For the two stars defined in Module 1,

$$
\boxed{
\frac1{2m}\sum_{S\in\mathcal S}(I-\Pi_S)
\ge\frac{m+1}{2m}(I-|\psi\rangle\langle\psi|).
}
\tag{2.2}
$$

The gap is exactly `(m+1)/(2m)`, and this is optimal among all perfectly complete binary tests touching at most `m+1` parties per copy.

**Proof.** Let `H_B` be the rejection sum for supports `C union {i}`, and let `H_C` be the rejection sum for supports `B union {j}`. By the preceding lemma, `H_B` is diagonal in the `B`-error basis with eigenvalue equal to error weight. The analogous statement holds for `H_C` in the `C`-error basis.

On `psi`-orthogonal space let `E_a^B` be the orthogonal projector onto `B`-errors of weights `1,...,a`; define `E_b^C` analogously. The AME condition gives

$$
E_a^B E_b^C=0\qquad(a+b\le m).
\tag{2.3}
$$

Indeed, a basis vector in one range and one in the other have inner product

$$
\langle\psi|W_B^\dagger V_C|\psi\rangle.
$$

Their supports are disjoint and have combined size at most `m`. The corresponding reduced state is maximally mixed, and the tensor-product operator has trace zero. The inner product vanishes.

On the orthogonal complement of `psi`, the integer error-weight spectrum gives

$$
H_B=mI-\sum_{a=1}^{m-1}E_a^B,
\qquad
H_C=mI-\sum_{b=1}^{m-1}E_b^C.
$$

Since (2.3) makes the two summands in each pair orthogonal,

$$
E_a^B+E_{m-a}^C\le I.
$$

Summing over `a=1,...,m-1` yields

$$
H_B+H_C\ge(m+1)I
$$

on `psi`-orthogonal space. Both sides vanish on `psi`, proving (2.2).

A nonidentity one-party error on `B` has `H_B`-eigenvalue one. It is orthogonal to every `C`-error of weight at most `m-1`, so it belongs to the `H_C` weight-`m` eigenspace. Its eigenvalue for the averaged sum is exactly `(m+1)/(2m)`. The general locality bound from Module 1 proves optimality. ∎

#### Which properties are universal?

| Property | Arbitrary AME state | Additive stabilizer AME state |
|---|---|---|
| One star is a commuting family with product equal to the target projector | Yes | Yes |
| Full two-star normalized gap `(m+1)/(2m)` | Yes | Yes |
| All minimum-support marginal projectors commute | Not required or asserted by the universal theorem | Yes |
| Every `m` tests of the doubled star suffice | Not asserted here | Yes |
| Weighted gap is the sum of `m+1` smallest weights | Not asserted here | Yes |
| Full finite-setting tradeoff of Module 1 | Not asserted here | Yes |
| Exact LU-to-LC rigidity | Not implied by verification | The paper's main theorem |

The two-star proof uses orthogonality of low-weight **error subspaces**, not commutativity of the two stars with each other. The conclusion must not be strengthened to global commutativity by analogy with the stabilizer proof.

### 2.3 The syndrome map is an additive MDS code

Return to an additive stabilizer AME state. Let `L^*` denote its `F_p`-linear dual. Choose bases in each `2e`-dimensional test subgroup and form

$$
\Phi:L^*\longrightarrow
\bigoplus_{S\in\mathcal S}L(S)^*,
\qquad
\lambda\longmapsto(\lambda|_{L(S)})_S.
$$

Each alphabet block has `Q=q^2` elements. Projection of `Phi(L^*)` onto any `m` blocks is bijective, since the corresponding test subgroups form a direct sum equal to `L`. Thus this is an **additive** length-`2m`, size-`Q^m`, minimum-distance-`m+1` MDS code.

No multiplication by elements of `F_(q^2)` has been constructed or assumed. “Additive MDS” here records a prime-field linear code with equal-size coordinate blocks.

The Hamming weight of `Phi(lambda)` is exactly the number of failed tests on the corresponding joint stabilizer eigenstate. Consequently, its weight enumerator is the spectrum of the uniform verification Hamiltonian. The coding and counting mechanism should be presented as standard MDS structure, not as a new general weight-distribution theorem; the paper already cites the quantum-MDS distribution literature [C1].

### 2.4 Exact spectrum, with a self-contained count

Let `N_w` be the multiplicity of the eigenvalue `w/(2m)` of the full normalized two-star rejection operator. Then

$$
N_0=1,\qquad N_w=0\quad(1\le w\le m),
$$

and, for `m+1<=w<=2m`,

$$
\boxed{
N_w=\binom{2m}{w}
\sum_{j=0}^{w-m-1}
(-1)^j\binom wj
\bigl(Q^{w-m-j}-1\bigr),\qquad Q=q^2.
}
\tag{2.4}
$$

**Proof.** Fix a possible failure support `T` of size `t`. Characters with failure support contained in `T` annihilate all `2m-t` complementary test subgroups. If `2m-t>=m`, those subgroups span `L` and only the zero functional remains. Otherwise they are independent, so their annihilator has dimension `2e(t-m)`. The number is therefore

$$
Q^{\max(t-m,0)}.
$$

Apply inclusion–exclusion over the subsets of a fixed `w`-set to count characters with exactly that support. For `w>0`, the constant-one contribution cancels. Substituting `j=w-t` leaves the sum in (2.4). Finally multiply by the number `binom(2m,w)` of supports. ∎

Checks on admissible parameters:

| Target | Spectrum of normalized rejection operator |
|---|---|
| Stabilizer `AME(4,3)` | `0` once; `3/4` 32 times; `1` 48 times |
| Stabilizer `AME(6,2)` | `0` once; `2/3` 45 times; `1` 18 times |

In each case the multiplicities sum to `q^(2m)`. The second example has no eigenvalue `5/6`; a formal zero multiplicity should not be read as an existence problem.

The full stabilizer spectrum depends only on `m,q`. It therefore cannot replace the marked transition/holonomy data used for LU classification.

### 2.5 A useful caution at four parties

For **every** `AME(4,q)` state, all four three-party marginal-support projectors commute, independently of stabilizer structure.

**Proof.** The projector omitting party `i` has range

$$
\operatorname{span}\{W_i|\psi\rangle:W_i\text{ ranges over a unitary basis}\}.
$$

This range is the direct sum of `C psi` and the one-party traceless-error subspace at `i`. Two-uniformity makes these traceless-error subspaces orthogonal for distinct parties. Thus any two projectors multiply to `|psi><psi|` and commute. ∎

Accordingly, a defect based only on pairwise commutators of minimum-support marginals is identically zero at four parties. It is not, by itself, a general stabilizer-characterization criterion. This observation is especially relevant to keeping the separate six-party phase-deformation research from being read as a universal converse to LU rigidity.


---

<a id="module-3"></a>

## 3. Proposed corollary: observable marginal error enters robust rounding

**Recommended placement:** state the fidelity estimate beside the new verification theorem. Place the three-level product-unitary corollary after `cor:logical-clifford-rounding`, where the local, transition-compatible, and global inputs have all been proved.

The purpose is to turn marginal data into an entry certificate for the theorem already proved in the manuscript. This is not a larger robustness radius and not a replacement proof of cleaning or Fourier rounding.

### 3.1 State certification with the optimal normalization

Let

$$
P_\psi=|\psi\rangle\langle\psi|,
\qquad
\nu_* = \frac{m+1}{2m},
\qquad
r_*(\sigma)=\operatorname{Tr}(\mathcal H_*\sigma).
$$

For every density operator `sigma`, the gap theorem gives

$$
\boxed{
1-\langle\psi|\sigma|\psi\rangle
\le\frac{r_*(\sigma)}{\nu_*}.
}
\tag{3.1}
$$

For each two-star support define the marginal trace distance

$$
d_S=\frac12\|\sigma_S-\rho^\psi_S\|_1,
\qquad
\bar d=\frac1{2m}\sum_{S\in\mathcal S}d_S.
$$

Then

$$
\boxed{
1-\langle\psi|\sigma|\psi\rangle
\le\frac{r_*(\sigma)}{\nu_*}
\le\frac{\bar d}{\nu_*}
=\frac1{m+1}\sum_{S\in\mathcal S}d_S.
}
\tag{3.2}
$$

**Proof.** The first inequality is the expectation of the operator inequality in (1.2) or (2.2). Put `P_S=q^(m-1) rho_S^psi`, a projector on the selected subsystem. Perfect completeness gives

$$
\operatorname{Tr}[(I-\Pi_S)\sigma]
=\operatorname{Tr}[P_S(\rho_S^\psi-\sigma_S)]
\le\frac12\|\rho_S^\psi-\sigma_S\|_1.
$$

The last step is the variational trace-distance bound for the effect `0<=P_S<=I`. Average over the settings and apply the gap. ∎

No extra factor `q^(m-1)` occurs in the trace-distance estimate: the rescaled marginal is itself an effect of operator norm one. This does not assert that estimating the full local trace distances, or implementing an arbitrary non-stabilizer marginal projector, is inexpensive.

For comparison, one-star certification yields the sum of `m` marginal errors, or `m` times their mean. The two-star certificate is at most `2m/(m+1)<2` times the mean of its `2m` errors. These are different collections of observations; the claim is improved conditioning, not a free reduction using unchanged data.

### 3.2 The exact conversion to the paper's state-vector defect

Suppose now that

$$
\sigma=U P_\psi U^\dagger,
\qquad U=\bigotimes_{i=1}^{2m}U_i,
$$

as required by the robust product-symmetry theorem. Let `gamma>=0` be any valid upper bound on `r_*(sigma)`, such as `bar d`.

Define

$$
a=\min\{\gamma/\nu_*,1\},
\qquad
\eta(\gamma)=\sqrt{2\bigl(1-\sqrt{1-a}\bigr)}.
$$

Then the manuscript's phase-optimized defect satisfies

$$
\boxed{
\varepsilon(U)=\min_{|z|=1}\|U\psi-z\psi\|
\le\eta(\gamma)
\le\sqrt{\frac{2\gamma}{\nu_*}}.
}
\tag{3.3}
$$

**Proof.** For a pure output, writing `F=|<psi|U|psi>|^2`,

$$
\varepsilon(U)^2=2(1-\sqrt F).
$$

Equation (3.1) gives `F>=max(0,1-gamma/nu_*)`. Substitution proves the first bound. The second follows from `1-sqrt(1-a)<=a`. ∎

The square root in (3.3) is essential. A bound on infidelity or trace-distance data must not be substituted directly as the state-vector defect.

### 3.3 Corollary: three observable entry levels for the revised theorem

Suggested label: `cor:marginal-certified-rounding`.

Let the target be a stabilizer `AME(2m,q)`, let `n=2m`, and use the defect bound `eta(gamma)` from (3.3). The obsolete characteristic threshold `tau_p` is not used. The revised quantitative section has

$$
R^{\rm loc}=\frac1{24},\qquad
R^{\rm trans}=\frac{\sqrt2}{68},\qquad
R^{\rm clean}_{n,q}
=\min\left\{\frac1{4\sqrt{2q}},\frac1{8\pi\sqrt n}\right\}.
$$

For `0<t<sqrt(2)`, define

$$
\Gamma_{\nu}(t)=\nu\left(t^2-\frac{t^4}{4}\right).
$$

A rejection upper bound `gamma<Gamma_(nu_*)(t)` implies `eta(gamma)<t`. Consequently:

| Observable hypothesis | Guaranteed conclusion |
|---|---|
| `gamma<Gamma_(nu_*)(1/24)` | Additive one-party Cliffords `K_i` satisfy `q^(-1/2) min_(|z|=1) ||U_i-zK_i||_HS <= 8 eta(gamma)`. |
| `gamma<Gamma_(nu_*)(sqrt(2)/68)` | The rounded symplectic frames satisfy all transition equations exactly. A Pauli correction yields an exact symmetry, and a chosen encoder's logical unitary is within `8 eta(gamma)` of an exactly transversally realizable logical Clifford. No local smallness of the Pauli correction follows. |
| `gamma<Gamma_(nu_*)(R_clean_(n,q))` | The nearby exact-symmetry decomposition and collective residual bounds of the global theorem apply. |

At the global level, writing `R=R_clean_(n,q)`, the observable condition is

$$
\boxed{\gamma<\nu_*\left(R^2-\frac{R^4}{4}\right).}
\tag{3.4}
$$

Up to a global phase,

$$
U=g\bigotimes_i e^{ih_i},\qquad g\in G(\psi),
$$

with the same tracelessness and spectral-spread conditions as in the manuscript, and

$$
\boxed{\left(\sum_i\|h_i\|_F^2\right)^{1/2}
\le\pi\sqrt q\,\eta(\gamma).}
\tag{3.5}
$$

After exact branch selection,

$$
\boxed{\sum_i\left(q^{-1/2}\min_{|z|=1}
\|U_i-zg_i\|_{\rm HS}\right)^2
\le\pi^2\eta(\gamma)^2.}
\tag{3.6}
$$

**Proof.** Equation (3.3) gives the state-vector defect bound. If `gamma<Gamma_(nu_*)(t)`, then

$$
1-\gamma/\nu_*>1-t^2+t^4/4=(1-t^2/2)^2,
$$

so `eta(gamma)<t`. Apply the revised cleaning/Fourier lemmas at `t=1/24`; apply `prop:robust-linear-atlas` and `cor:logical-clifford-rounding` at `t=sqrt(2)/68`; and apply `thm:cleaning-global-rounding` and its collective chord bound at `t=R_clean_(n,q)`. ∎

A simpler, slightly stronger sufficient condition for the global branch is `gamma<nu_* R^2/2`.

The same conversion works for a nonuniform or reduced two-star library with its exact positive gap `nu` replacing `nu_*`. A zero-gap library cannot supply a fidelity certificate this way.

For intertwiners between two targets, use the current relative-intertwiner corollary **with its existing hypothesis that an exact intertwiner is supplied or known to exist**. Construct the verifier for the target state and apply the exact-base reduction. The wrapper does not establish new LU equivalence from approximate proximity.

#### Scope that must remain in the text

The first two thresholds above are independent of party count and local dimension. The required accuracy for the final global branch still depends on `R_clean^2`, with

$$
R^{\rm clean}_{n,q}
=\Theta\!\left(\min\{q^{-1/2},n^{-1/2}\}\right).
$$

The separate `p^-1` penalty belongs to the old revision and must not be restored. Conversely, a universal transition-compatibility threshold is not a universal nearby-symmetry radius. It does not control the stabilizer-character correction.

For arbitrary mixed `sigma`, only the state bounds (3.1)–(3.2) apply. Product-unitary factor estimates require the stated promise on the physical operation.

### 3.4 Calibration and statistical uncertainty

Suppose an implemented local accept effect `hat P_S` obeys

$$
\|\widehat P_S-P_S\|_{\rm op}\le\kappa_S.
$$

For a fixed input state let `hat r` be the true rejection probability of the implemented uniformly sampled tests, and define

$$
\bar\kappa=\frac1{2m}\sum_S\kappa_S.
$$

Then

$$
\boxed{r_*(\sigma)\le\widehat r+\bar\kappa.}
\tag{3.7}
$$

This follows from `|Tr[(hat P_S-P_S)sigma_S]|<=kappa_S` and averaging. A statistically valid upper confidence bound `r_up` on `hat r` therefore supplies `gamma=r_up+bar kappa` in the previous corollary, with that confidence level. A bare empirical failure frequency is not itself a certified upper bound.

For ideal tests on independent identically prepared copies, a state with infidelity at least `epsilon_0` passes all `N` sampled tests with probability at most

$$
(1-\nu_*\epsilon_0)^N.
$$

Thus the usual all-pass verification guarantee is obtained with

$$
N\ge
\left\lceil
\frac{\log\alpha}{\log(1-\nu_*\epsilon_0)}
\right\rceil,
\qquad0<\alpha<1.
\tag{3.8}
$$

This is the established verification-framework consequence [V1, V2], not a new sample-complexity exponent. It is not asserted here for arbitrary correlated/adversarial copies, and imperfect tests require their own acceptance analysis rather than simply reusing (3.8).

### 3.5 A finite branch check, not a cure for the phase-correction radius

Let `K` be a proposed product Clifford, described by full phase-aware tableaux.

If it preserves the label space `L`, then `K|psi>` is a single joint eigenstate of the original stabilizer group. Hence

$$
\boxed{
K P_\psi K^\dagger\ne P_\psi
\quad\Longrightarrow\quad
r_*(K P_\psi K^\dagger)\ge\nu_*.
}
\tag{3.9}
$$

This is the minimum nonzero syndrome-weight statement of Module 1. It provides an exact character-branch check after linear compatibility is known.

Even without label compatibility, the existing quantized stabilizer-overlap lemma gives `F<=1/p` for a distinct stabilizer state. Therefore

$$
\boxed{
r_*(K P_\psi K^\dagger)<\nu_*(1-1/p)
\quad\Longrightarrow\quad
K P_\psi K^\dagger=P_\psi.
}
\tag{3.10}
$$

These checks concern the **candidate Clifford output**, not automatically the original approximate output. Transferring an error bound from `U` to `K` still requires control of their difference.

The paper already gives a canonical Pauli character correction on a prescribed half-set by one linear solve. Retain that result; do not present it as a new addition. A nontrivial single-party Weyl has normalized phase-optimized Hilbert–Schmidt distance `sqrt(2)` from the identity. Consequently the availability of a character correction does not imply that each correction factor is small. The current distinction between label compatibility and a nearby exact symmetry remains necessary.


### 3.6 Optional extensions in the revision delta

The companion `08_revision_delta.md` supplies two complete additional arguments:

**Sample-cost consequence (Section 4).** For ideal independent tests on identically prepared promised outputs, an all-pass test that rules out defect at least the current global radius has sufficient sample count `O(max(q,n) log(1/alpha))`, up to integer ceiling. This is a corollary of the improved radius and established verification statistics, not a new sample exponent or a sample-optimality theorem.

**A posteriori branch certificate (Section 5).** Given an actual candidate product Clifford and certified centered residual generators, the test `e+D/sqrt(q)<d_p` forces the candidate to be exact. With `D^2<=q/4`, the usual collective residual estimate follows. This can certify favourable instances without replacing all local errors by their common worst-case bound. It does not improve the uniform radius and requires additional information about the local operations.

The first is a possible short paper remark. The second is optional: include it only if instance-dependent certification is part of the paper's intended algorithmic scope.


---

<a id="module-4"></a>

## 4. Optional algorithmic enhancement: constrained verifier design

The fixed two-star library admits a much smaller exact optimization problem than a general stabilizer verification instance. This belongs as a short algorithmic remark or a companion note, not as a solver benchmark in the rigidity paper.

### 4.1 Evaluate the weighted gap and construct an attaining state

Once the `2m` test subgroups are prepared, Module 1 gives

$$
\nu(w)=\sum_{a=1}^{m+1}w_{(a)}.
$$

Sorting costs `O(m log m)` rational comparisons. For an explicit worst-character witness, take the `m-1` largest-weight subgroups and solve for a nonzero functional annihilating their direct sum. Its annihilator has dimension `2e`, and every nonzero choice fails precisely the other tests.

With `D=dim_(F_p)L=2em`, ordinary elimination gives the witness in `O(D^3)` field operations after the subgroup bases are available. It uses no `q^(2m)`-dimensional Hilbert-space matrices. The existing half-carrier Pauli solve converts this abstract character into a physical product-Pauli error witness when one is needed.

These are arithmetic bounds for the specified input representation, not hardware measurement costs or bit-complexity bounds independent of `p`.

### 4.2 A linear-size LP for costs and unavailable settings

Suppose test `a` has nonnegative cost `c_a`, and the allowed mean cost is `C`. Some tests may be forbidden. The task is

$$
\max_w\nu(w),\qquad
w_a\ge0,\quad\sum_aw_a=1,\quad\sum_ac_aw_a\le C,
$$

with `w_a=0` for forbidden tests.

Let `k=m+1`. The order-statistic identity

$$
\boxed{
\sum_{a=1}^k w_{(a)}
=\max_{\tau\in\mathbb R}
\left[k\tau-\sum_a\max(\tau-w_a,0)\right]
}
\tag{4.1}
$$

turns the entire problem into the LP

$$
\begin{array}{ll}
\text{maximize}& k\tau-\sum_a z_a,\\
\text{subject to}&z_a\ge\tau-w_a,\quad z_a\ge0,\\
&w_a\ge0,\quad\sum_aw_a=1,\\
&\sum_ac_aw_a\le C,\\
&w_a=0\quad\text{for forbidden tests}.
\end{array}
\tag{4.2}
$$

It has `O(m)` variables and inequalities. It is exact even when some allowed weights become zero.

**Proof of (4.1).** Let `I` index `k` smallest weights. For every `tau`,

$$
k\tau-\sum_a\max(\tau-w_a,0)
\le k\tau-\sum_{a\in I}(\tau-w_a)
=\sum_{a\in I}w_a.
$$

For `tau` between `w_(k)` and `w_(k+1)`, with ties permitted, the expression equals this sum. Since `m>=2`, `k<2m`, so such an interval is defined. Replacing the positive-part terms by auxiliary variables gives (4.2). ∎

This is the recommended computational route for the fixed library: **do not call a general Ergodis character-search oracle where the exact weighted-gap formula already removes the search.**

The LP models mean per-copy cost. A cardinality limit on the number of positive weights is an additional constraint and is not encoded by this LP. Likewise, changing the allowed physical measurement model can change the correct cost function.

### 4.3 General test libraries: the precise finite-algebra oracle

For a wider library of stabilizer subgroup tests, write `L_a<=L` for the test subgroups and set

$$
b_a(\lambda)=
\mathbf1\{\lambda|_{L_a}\ne0\},
\qquad\lambda\in L^*\setminus\{0\}.
$$

Then

$$
\boxed{\nu(w)=\min_{\lambda\ne0}\sum_aw_a b_a(\lambda).}
\tag{4.3}
$$

This follows from simultaneous diagonalization in the stabilizer-character basis. It is an exact finite-field optimization problem with zero/nonzero block costs.

Choose coordinates `lambda_1,...,lambda_D` over `F_p`. Rescaling a nonzero functional does not change which restrictions vanish. Therefore

$$
\min_{\lambda\ne0}(\cdots)
=\min_{1\le j\le D}\ \min_{\lambda_j=1}(\cdots).
\tag{4.4}
$$

If bases of `L_a` are represented by matrices `B_a` in an ambient basis of `L`, the block labels are `B_a^T lambda`. The inner problems in (4.4) are affine finite-domain problems with prescribed labels and support-like costs. This is the specific possible connection to Ergodis.

Equation (4.4) does not prove efficient optimization. Unstructured enumeration still has `p^D=q^(2m)` possibilities; a useful native decomposition or other structure must be exhibited separately.

### 4.4 Optional cutting-plane design and certificate

For the unconstrained library, consider

$$
\max_{w\in\Delta}\min_{\lambda\ne0} w\cdot b(\lambda).
$$

A restricted master LP uses only the characters discovered so far. Its optimum is an **upper** bound on the full design optimum. An exact oracle call (4.3) at its proposed weights gives an attainable **lower** bound. A violating character is a new master constraint; equality of the bounds certifies optimality.

An independently checkable dual witness is a probability distribution `mu` on a finite list of characters. If

$$
\sum_\lambda\mu_\lambda b_a(\lambda)\le t
\quad\text{for every test }a,
$$

then every test distribution has gap at most `t`. Indeed, its worst-character rejection is no larger than its average under `mu`, which is at most `t`. A proposed primal distribution with certified gap `t` is therefore optimal.

With a mean-cost constraint `c dot w<=C`, one may instead certify

$$
\sum_\lambda\mu_\lambda b_a(\lambda)\le t+\beta c_a,
\qquad\beta\ge0.
$$

The resulting upper bound is `t+beta C`. Every support restriction and every rational inequality can be checked against the native subspace matrices.

The general LP/minimax verification framework is established [V1]. The proposed addition is a specialized algebraic interface and the closed form (4.1) for the two-star library, not a new general quantum-verification algorithm or a demonstrated SOTA solver improvement.

### 4.5 Physical implementation boundary

For an additive stabilizer target, `L(S)` has `2e` independent prime-field generators. Its support projector can be implemented as the joint acceptance test for the corresponding commuting stabilizer observables, using operations confined to `S`.

This is a compound binary test. The generator measurements need not correspond to one common tensor-product basis on the individual parties: local Weyl components of globally commuting stabilizers can fail to commute. Their synthesis, ancillas, connectivity, noise, and gate counts are separate resources. For an arbitrary non-stabilizer target, the abstract support projector need not have an efficient implementation at all.

Accordingly, describe the optimization as **subset-local verifier design with specified compound tests**, not “an optimal LOCC verifier with only `2m` local Pauli settings.”


---

<a id="module-5"></a>

## 5. Patch plan, framing, and claim audit

### 5.1 Recommended size of the revision

**Main-text package:** include the two-star direct-sum lemma, the exact weighted gap, the setting/gap tradeoff, and the observable-rounding corollary. These are closely connected to the existing marginal atlas and robustness theorem. Preserve the current title and the headline exact/robust LU-rigidity results.

**Expanded package:** add the universal-AME argument and additive-MDS spectrum as an appendix. Include the constrained-weight LP as a short remark or companion note, not a separate algorithmic headline. Neither a numerical experiment nor an Ergodis dependency is necessary for these results.

**Separate project:** keep the six-arc commuting-phase classification, Smith/lifting calculations, and certificate minimization outside this paper. They concern a different classification quotient, require their own proof review, and would substantially enlarge the trust boundary. The present packet does not use them as premises.

### 5.2 File-by-file insertion plan

The anchors refer to the public source snapshot [S0–S7 in Module 6]. Reconcile them with the local working manuscript before editing; theorem numbering is intentionally not assumed.

| File | Existing anchor | Recommended change |
|---|---|---|
| `main.tex` | Abstract | Add one compact sentence about the doubled marginal atlas and its sharp verification tradeoff. Do not add phase classification or claim a larger rounding radius. |
| `sections/01-introduction.tex` | Discussion of marginal certification and finite recognition | Add a shortened version of the framing paragraph below. Explain the measurement model before comparing with published verification protocols. |
| `sections/03-exact-rigidity-atlas.tex` | `prop:marginal-certification`, before `cor:stochastic-conversion` | Insert Module 1 under `subsec:optimal-marginal-verification`; append (3.1)–(3.2) as the operational corollary. |
| `sections/03-exact-rigidity-atlas.tex` | Existing star proof | Optionally add a forward reference noting that the star-specific assertion only needs maximal entanglement across the balanced cut. Keep the arbitrary-family label-span criterion stabilizer-specific. |
| `sections/05-quantitative-rounding.tex` | After `cor:logical-clifford-rounding` | Add the three-level `cor:marginal-certified-rounding`, with current thresholds `1/24`, `sqrt(2)/68`, and `R_clean`. Preserve the exact-intertwiner premise. |
| `sections/03-exact-rigidity-atlas.tex` | New verifier subsection, referring to `subsec:four-qutrit-example` | Add the short qutrit verification illustration from Module 8. Do not repeat the existing state, systematic-map, and character computations. |
| `sections/07-conclusion.tex` | Summary of marginal atlas and robustness | Add the concise synthesis below. Retain the character/nearby-symmetry distinction and existing limitations. |
| New optional appendix, e.g. `sections/C-marginal-verification.tex` | Before the proof/trust-boundary appendix | Put Module 2 and optional details from Modules 3–4 here. Add its `\input` in `main.tex` only when this appendix is accepted. |
| `sections/08-verification-boundary.tex` | Existing trust table | Add a manuscript-proof-only row for the new verification and observable-conversion results. No new Lean coverage is asserted. |
| `refs.bib` | Verification literature | Add the two entries in Module 6 after checking key duplication. Reuse existing marginal and MDS citations. |

The existing label `sec:verification` names the **proof/formalization boundary**. Do not reuse it for experimental state verification. A heading such as “Proof and formalization boundary” could reduce the ambiguity without changing its label or role.

### 5.3 Optional abstract addition

The revised abstract is already focused. Do not add the original packet's longer paragraph. At most use:

> The marginal atlas also gives a sharp subset-local verification tradeoff and observable criteria for the rounding regimes.

Omitting an abstract change is also reasonable when verification is a short corollary. Do not describe the global result as dimension-independent robustness: only local rounding and linear transition compatibility have universal entry thresholds in the revised manuscript.

### 5.4 Draft introduction paragraph

> A minimal marginal description and a robust verifier need not use the same amount of data. One marginal star already specifies the state with the minimum number of half-plus-one-party constraints. We show that adjoining the complementary star improves the normalized verification gap from $1/m$ to $(m+1)/(2m)$, which is optimal when each perfectly complete test touches at most $m+1$ of the $2m$ parties. More generally, any $s$ members of the doubled star, sampled uniformly, attain the optimal gap $1-(m-1)/s$ for $m\le s\le2m$. The resulting marginal rejection bound supplies a direct observable hypothesis for our robust product-unitary theorem. The full two-star gap uses only the AME condition; the weighted tradeoff and finite syndrome description use additive stabilizer structure.

Follow this with the literature paragraph from Module 6. In particular, a compound measurement on a subset is not the same resource as a product of single-party measurement bases.

### 5.5 Draft conclusion paragraph

> The doubled marginal atlas separates exact specification from robust verification. Its additive syndrome code quantifies the benefit of redundant settings, including an exact gap after setting erasures. The corresponding rejection probability controls state infidelity and hence provides an observable entrance test for the established local-unitary rounding radius. These operational consequences do not replace the marked transition data needed for classification, nor do they remove the distinction between compatible stabilizer labels and the character of a nearby exact symmetry.

### 5.6 Suggested formalization-boundary addition

| Added result | Dependencies | Status in this revision packet |
|---|---|---|
| Two-star direct-sum lemma and weighted gap | Existing support theorem; finite character theory | Complete manuscript proof supplied; no new Lean theorem claimed |
| Sharp setting/gap and locality bounds | Support ranks; positivity of binary effects | Complete manuscript proof supplied; no computational premise |
| Universal AME gap | Schmidt decomposition; tensor-product error basis; marginal orthogonality | Complete manuscript proof supplied; not a consequence of the existing stabilizer formalization |
| Observable-rounding corollary | New verification gap; current quantitative theorem | Algebraic/analytic corollary; current radius and trust boundary retained |
| Additive MDS spectrum | Direct-sum lemma; inclusion–exclusion | Complete counting proof; finite checks are author-facing only |
| Constrained verification weights | Weighted formula; elementary LP identity | Exact finite formulation, not a benchmark or a formal solver-correctness claim |

The current manuscript says that its theorems do not depend on a computational supplement. This remains true with these additions. The sanity checks recorded in Module 7 should not become proof dependencies merely because they were convenient during drafting.

### 5.7 Audit of claims from the earlier discussion

| Earlier claim or possible reading | Recommended treatment |
|---|---|
| A full two-star protocol has gap `(m+1)/(2m)` | Include with the proofs supplied here. Normalize the Hamiltonian explicitly. |
| The same full gap holds for arbitrary AME states | Include as an appendix theorem; its proof was re-derived without stabilizer commutativity. Do not extend the LU=LC theorem along with it. |
| Every `m` two-star tests suffice; arbitrary weights give the sum of the smallest `m+1` weights | Include for **stabilizer** AME states. The argument uses the joint additive-character eigenbasis. |
| The two-star construction has a minimum-setting optimality statement | Strengthen to the full exact curve in Module 1 rather than stating only that `2m` settings are necessary at the optimum. |
| The verification spectrum gives another LU-classification invariant | It is universal in `m,q` for stabilizer AME states and therefore cannot recover their marked holonomy. Explain the distinction instead. |
| A marginal-commutator defect characterizes all stabilizer AME states | Do not claim this. At four parties it vanishes for every AME state. Restricted six-party phase classifications require separate hypotheses and proof review. |
| The continuous non-stabilizer phase example establishes a new infinitude theorem | Do not frame it that way: infinitely many inequivalent minimal-support AME states on six or more parties already appear in Burchardt–Raissi [P1]. |
| The general nonconic/conic torsion classification from the conversation is ready for this paper | Not audited here; do not import it into the proposed revision. Its fixed-carrier/local-diagonal quotient is not unrestricted LU equivalence. |
| A constant verification gap improves the cleaning radius or removes `sqrt(n)` losses | Unsupported. Module 3 converts observations into the existing radius; it does not improve it. |
| A half-supported character correction is a new algorithmic addition | It is already in the current `cor:finite-recognition`. Retain and cite it; do not duplicate the claim. |
| Character correction necessarily preserves the local approximation bound | False without an additional argument. A nontrivial Weyl can be a finite distance from identity. |
| Generic verification LPs or verification sample scaling are new | They are established [V1,V2]. The proposed contribution is the sharp AME subset-local structure and its closed-form/small-LP specialization. |
| Ergodis prototype speedups support this AME theorem | They are unrelated evidence. Keep them in the recovery work. |
| Existing Lean statements cover these new analytic theorems | No such coverage was established. Update the trust table instead of silently inheriting a formalization claim. |

### 5.8 Proof dependency map

```text
Existing stabilizer-AME support and dimension theorem
    -> any m of the two-star subgroups form a direct sum
        -> exact character failure sets
            -> weighted gap and all setting-erasure formulas
            -> additive MDS spectrum
            -> constrained-weight LP and finite witness extraction

AME marginal mixing, without stabilizers
    -> one-star error-basis decomposition
        -> two-star low-weight error orthogonality
            -> universal full two-star gap

Perfect completeness + one-party traceless errors
    -> locality upper bound

New gap + marginal trace-distance inequality
    -> state-fidelity certificate
        -> pure-state vector-defect conversion
            + existing robust-rounding theorem
                -> observable entry criterion, with unchanged radius
```

No path in this graph goes through the earlier six-arc phase computations.

### 5.9 Release checklist

| Check | Required outcome |
|---|---|
| Measurement model | At most `m+1` parties touched per copy; joint operations within the subset allowed; one setting is one binary effect |
| Normalization | Distinguish unnormalized one-star gap `1` from sampled one-star gap `1/m` |
| Hypotheses | Keep `m>=2`; state where `q=p^e` is needed and where any integer `q>=2` is permitted |
| Character conventions | Use stabilizer lifts that fix the target; distinguish the trivial character from the zero linear functional |
| Additivity | No unproved `F_(q^2)`-linearity assumption in the syndrome MDS code |
| Robustness | Use the pure-state square-root conversion; preserve the existing radius and exact-intertwiner premise |
| Statistical language | A valid confidence bound is required; an empirical rejection rate alone is not a deterministic certificate |
| Calibration | State whether effects are ideal or use the operator-norm correction |
| Complexity | Do not identify number of compound tests with gate count, tomography cost, or single-party basis count |
| Priority and verification | Reconcile with the cited verification literature; no claim of exhaustive priority search or new formal proof coverage |
| Source integration | Build and cross-reference the actual local manuscript after merging; this packet has not performed that build |


### 5.10 Rebased editorial details

The original combined heading is “Marginal certification and stochastic conversion.” If the proposed verifier is made a separate subsection before the stochastic-conversion corollary, give stochastic conversion its own heading and retain existing labels for cross-references.

Do not duplicate the revision's promised-input recognition statement, corrected reference-to-logical Clifford label transformation, or logical-rounding corollary. Follow the current `F_logical=tau F tau` convention, not a generic inverse-transpose rule for symplectic label matrices.

The optional verifier appendix would shift the existing trust-boundary appendix from C to D. Update the README's hard-coded letter, or use wording independent of appendix letters. Keep the manuscript-only status of the new arguments explicit. No earlier toolchain-specific formalization claim should be restored from historical material.

See Module 8 for the exact old/new status table, proof-bearing optional additions, and this rebase's audit scope.


---

<a id="module-6"></a>

## 6. Source snapshot, literature, and bibliography

### 6.1 Source snapshot

Inspected public export: commit `55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82`, dated 7 September 2026. The source manuscript is dated August 2026. These links pin the revision used for insertion anchors; they are not a claim to have inspected an unseen local branch.

- **[S0] Repository commit:** <https://github.com/tavisrudd/ame-lu/commit/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82>.
- **[S1] Main source and abstract:** <https://raw.githubusercontent.com/tavisrudd/ame-lu/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82/main.tex>.
- **[S2] Exact rigidity, marginal atlas, recognition, stochastic conversion:** <https://raw.githubusercontent.com/tavisrudd/ame-lu/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82/sections/03-exact-rigidity-atlas.tex>.
- **[S3] Quantitative rounding and current radius:** <https://raw.githubusercontent.com/tavisrudd/ame-lu/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82/sections/05-quantitative-rounding.tex>.
- **[S4] Introduction:** <https://raw.githubusercontent.com/tavisrudd/ame-lu/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82/sections/01-introduction.tex>.
- **[S5] Conclusion:** <https://raw.githubusercontent.com/tavisrudd/ame-lu/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82/sections/07-conclusion.tex>.
- **[S6] Proof/formalization boundary:** <https://raw.githubusercontent.com/tavisrudd/ame-lu/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82/sections/08-verification-boundary.tex>.
- **[S7] Existing bibliography:** <https://raw.githubusercontent.com/tavisrudd/ame-lu/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82/refs.bib>.

The paper's own definitions and theorem labels take precedence over the packet's provisional notation. In particular, the source already includes the general stabilizer spanning criterion and the prescribed-half-set character correction.

### 6.2 Primary literature and its role

#### [V1] Verification framework and stabilizer protocols

Ninnat Dangniam, Yun-Guang Han, and Huangjun Zhu, **“Optimal verification of stabilizer states.”** *Physical Review Research* **2**, 043323 (2020). DOI: `10.1103/PhysRevResearch.2.043323`. arXiv: `2007.09713`.

Source: <https://arxiv.org/abs/2007.09713>. Full HTML: <https://arxiv.org/html/2007.09713>.

Use for verification operators, gap/sample conversion, stabilizer verification via finite optimization, and comparison with minimal-setting protocols. Its separable-measurement bound and explicit optimal Pauli constructions through seven qubits must not be described as a proof of Pauli attainability for all stabilizer states. Its measurement class is different from the subset-local class here, which permits joint operations inside the selected subsystem.

#### [V2] Optimal local quantum-state verification

Sam Pallister, Noah Linden, and Ashley Montanaro, **“Optimal verification of entangled states with local measurements.”** *Physical Review Letters* **120**, 170502 (2018). DOI: `10.1103/PhysRevLett.120.170502`. arXiv: `1709.03353`.

Source: <https://arxiv.org/abs/1709.03353>.

Use for the established statistical verification setting and efficient stabilizer protocols. The present sample bound has the same familiar inverse-infidelity/log-confidence scaling; no new scaling exponent is claimed.

#### [M1] Stabilizer determination by reduced states

Xia Wu, Ying-hui Yang, Yu-kun Wang, Qiao-yan Wen, Su-juan Qin, and Fei Gao, **“Determination of stabilizer states.”** *Physical Review A* **92**, 012305 (2015). DOI: `10.1103/PhysRevA.92.012305`. arXiv: `1503.05421`.

Source: <https://arxiv.org/abs/1503.05421>.

The current bibliography already has the key `WuYangWangWenQin2015`. Reuse it when explaining why generator-support reductions determine stabilizer states. The proposed new emphasis is the AME-specific doubled-star geometry and exact tradeoff, not a first general stabilizer determination theorem.

#### [M2] Stabilizer witnesses

Géza Tóth and Otfried Gühne, **“Entanglement Detection in the Stabilizer Formalism.”** *Physical Review A* **72**, 022340 (2005). DOI: `10.1103/PhysRevA.72.022340`. arXiv: `quant-ph/0501020`.

Source: <https://arxiv.org/abs/quant-ph/0501020>.

The current bibliography already has the key `TothGuhne2005`. Reuse it for the stabilizer-projector/witness background already acknowledged in the marginal-certification discussion.

#### [C1] Quantum MDS structure and distributions

Felix Huber and Markus Grassl, **“Quantum Codes of Maximal Distance and Highly Entangled Subspaces.”** *Quantum* **4**, 284 (2020). DOI: `10.22331/q-2020-06-18-284`. arXiv: `1907.07733`.

Source: <https://arxiv.org/abs/1907.07733>.

The current bibliography already has `HuberGrassl2020` and the classical coding reference `HuffmanPless2003`. The spectrum calculation in Module 2 is proved by inclusion–exclusion; its MDS weight-enumerator mechanism should not be presented as a new general coding theorem.

#### [P1] Previously known continuous inequivalence of AME states

Adam Burchardt and Zahra Raissi, **“Stochastic Local Operations with Classical Communication of Absolutely Maximally Entangled States.”** *Physical Review A* **102**, 022413 (2020). DOI: `10.1103/PhysRevA.102.022413`. arXiv: `2003.13639`.

Source: <https://arxiv.org/abs/2003.13639>.

The existing key is `BurchardtRaissi2020`. This is relevant to the claim audit, not a new dependency of the two-star theorem: the existence of infinitely many inequivalent minimal-support AME states on six or more parties is already addressed there. Do not market the previous phase example as a new infinitude theorem.

### 6.3 Suggested related-work insertion

> The use of averaged accept projectors and their spectral gap follows the quantum-state verification framework of Pallister–Linden–Montanaro and Dangniam–Han–Zhu. Stabilizer determination from suitable reductions and stabilizer witness constructions are also established. Our assertion concerns a different, explicitly constrained resource: every test may act jointly, but on at most $m+1$ parties of an $\operatorname{AME}(2m,q)$ state. In this model the doubled marginal atlas gives a closed-form weighted gap and a sharp setting-count tradeoff. These results neither improve the general inverse-infidelity sample exponent nor identify a compound marginal projector with a single product-Pauli measurement setting.

Suggested citation commands in the final TeX: `\cite{PallisterLindenMontanaro2018,DangniamHanZhu2020}` after the first sentence and `\cite{WuYangWangWenQin2015,TothGuhne2005}` after the second.

This was a focused primary-source check, not an exhaustive priority search. “We prove the following sharp bound in this measurement model” is supportable from the supplied argument; “first optimal AME verification protocol” or “improves the best known general verification bound” is not established here.

### 6.4 New BibTeX entries

The two keys below are still absent from `refs.bib` at `55e70c4`. Recheck any newer local branch before adding them.

```bibtex
@article{DangniamHanZhu2020,
  author        = {Dangniam, Ninnat and Han, Yun-Guang and Zhu, Huangjun},
  title         = {Optimal verification of stabilizer states},
  journal       = {Physical Review Research},
  volume        = {2},
  number        = {4},
  pages         = {043323},
  year          = {2020},
  doi           = {10.1103/PhysRevResearch.2.043323},
  eprint        = {2007.09713},
  archivePrefix = {arXiv},
  primaryClass  = {quant-ph}
}

@article{PallisterLindenMontanaro2018,
  author        = {Pallister, Sam and Linden, Noah and Montanaro, Ashley},
  title         = {Optimal verification of entangled states with local measurements},
  journal       = {Physical Review Letters},
  volume        = {120},
  number        = {17},
  pages         = {170502},
  year          = {2018},
  doi           = {10.1103/PhysRevLett.120.170502},
  eprint        = {1709.03353},
  archivePrefix = {arXiv},
  primaryClass  = {quant-ph}
}
```

Do not add duplicates for [M1], [M2], [C1], or [P1]. No citation to an unpublished conversational theorem is needed for the new proof: the accepted result would be proved in the revised manuscript itself, with its standard ingredients cited in the surrounding discussion.


### 6.5 Revision comparison

The public [old-to-new diff](https://github.com/tavisrudd/ame-lu/compare/f5eb6b2febc06461f0cfaf8ac7533e4356bef1e7...55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82.diff) was used to distinguish new manuscript results from still-unincorporated packet proposals. Module 8 records the comparison.


---

<a id="module-7"></a>

## 7. Author-facing audit record

### 7.1 Original proof audit, with current rebase scope

**Audit-history distinction.** The general proof checks listed below originated with the first packet. This update inspected the old-to-new source diff and the revised source dependencies, corrected the numerical wrappers, checked the new example and optional corollaries, and reran the six-qubit script. It does not claim a fresh independent verification of every theorem in the revised manuscript. No build, PDF review, or Lean verification was performed.

The current public TeX and Markdown source was inspected, including the exact marginal theorem, half-set character correction, quantitative radius and collective estimate, introduction, conclusion, bibliography, and formalization boundary. The packet is keyed to the pinned public export in Module 6. It does not incorporate or presume access to changes in a private/local revision.

The recommended arguments were re-derived as follows:

| Argument | Check performed |
|---|---|
| Any `m` two-star label groups span independently | Support-intersection argument, then dimension count |
| Arbitrary weights and setting erasures | Exact character pass/fail sets; zero-weight cases included |
| Setting-count upper bound for general effects | Positivity implies identity on marginal support; annihilate the heaviest `m-1` subgroups |
| Locality cap without stabilizers | One-party traceless error states and mean inclusion probability |
| Universal one-star spectrum | Full orthonormal error basis and exact projector-rank comparison |
| Universal two-star gap | Orthogonality for complementary low-weight error spaces; one-party errors attain the bound |
| MDS spectrum | Counts of annihilators and inclusion–exclusion; no extension-field linearity assumption |
| Marginal-to-rounding conversion | Trace-distance variational bound, exact pure-state vector-defect formula, algebraic inversion of the existing radius |
| Constrained-weight LP | Order-statistic variational identity, including tied and zero weights |
| General-library optimization | Character minimization, rescaling to affine slices, primal/dual bound direction |

These are mathematical derivations, not claims of proof-assistant verification. In particular, the comparison between arbitrary subset effects and support projectors was checked explicitly; without it, the setting-count upper bound would only cover the chosen projector library rather than the claimed measurement model.

### 7.2 Exact finite sanity check

Use the following six binary Pauli generators on six parties:

```text
XZZXII
IXZZXI
XIXZZI
ZXIXZI
XXXXXX
ZZZZZZ
```

The test enumerates their additive label space and verifies pairwise symplectic commutation, independence, and minimum nonzero support four. Thus one can choose commuting lifts defining a pure six-qubit stabilizer AME state. The subsequent gap check is performed directly on characters; it does not construct floating-point Hilbert-space matrices.

With halves `{0,1,2}` and `{3,4,5}`, the exact checks gave:

| Check | Result |
|---|---|
| Distinct labels | 64 |
| Pairwise generator commutation | Passed |
| Minimum nonzero stabilizer support | 4 |
| Labels in each of the six minimum-support groups | 4 |
| Every three of the six groups span all labels | All 20 choices passed |
| Nontrivial characters failing four tests | 45 |
| Nontrivial characters failing five tests | 0 |
| Nontrivial characters failing six tests | 18 |
| Uniform gap for every nonempty selected test subset | All 63 subsets passed the formula |
| Weighted gap at weights `(0,1,2,3,4,5)/15` | Exactly the sum of the four smallest weights |

The inclusion–exclusion formula was also evaluated with exact integers:

- `m=2,q=3`: multiplicities `N_0=1,N_3=32,N_4=48`, summing to `81`.
- `m=3,q=2`: multiplicities `N_0=1,N_4=45,N_5=0,N_6=18`, summing to `64`.

The first was originally an arithmetic check of the formula. This rebase additionally enumerated the revised manuscript's four-qutrit stabilizer independently; see Section 7.5 and the supplied script. The six-qubit check directly enumerates the subgroups and characters. Neither finite check proves the universal theorem; the proofs in Modules 1–2 do.

### 7.3 What this packet does not validate

No manuscript PDF was analyzed, and the local LaTeX source was not built or modified. The packet does not certify equation numbering, bibliography-key resolution in the local branch, or the exported PDF after a merge.

No new Lean statements were written or checked. Existing algebraic formalizations do not automatically cover the new error-subspace or verification-operator arguments.

The earlier six-arc phase-classification arguments, general nonconic torsion theorem, finite lifting certificates, and Ergodis benchmark claims were not re-audited for this revision. They are not premises of any proposed insertion.

No experiment, gate decomposition, tomography protocol, or noisy-copy model was benchmarked. The statistical discussion states ideal/iid or explicitly calibrated-effect hypotheses rather than silently assuming device independence.

The literature check was targeted. The new restricted-model optimality proofs are supplied, but publication priority for their exact statements remains to be settled during ordinary author/reviewer scrutiny.

### 7.4 Reproducible arithmetic check

The following Python uses only the standard library. It is an optional author-side sanity check and need not be shipped as a computational supplement with the paper. All assertions below were executed successfully while preparing this packet.

```python
import itertools
import json
from collections import Counter
from fractions import Fraction
from math import comb


def stabilizer_six_qubits():
    words = ('XZZXII','IXZZXI','XIXZZI','ZXIXZI','XXXXXX','ZZZZZZ')
    def label(word):
        return tuple((int(c in 'XY'), int(c in 'ZY')) for c in word)
    generators = tuple(map(label, words))
    assert all(sum(a[0]*b[1] + a[1]*b[0] for a,b in zip(u,v)) % 2 == 0
               for u,v in itertools.combinations(generators,2))
    labels = []
    for bits in itertools.product(range(2), repeat=6):
        labels.append(tuple(tuple(sum(bits[k]*generators[k][j][a] for k in range(6)) % 2 for a in range(2)) for j in range(6)))
    assert len(set(labels)) == 64
    assert min(sum(v != (0,0) for v in row) for row in labels[1:]) == 4
    coefficients = list(itertools.product(range(2), repeat=6))
    B, C = {0,1,2}, {3,4,5}
    supports = [B | {j} for j in sorted(C)] + [C | {i} for i in sorted(B)]
    subgroup_coeffs = [tuple(bits for bits,row in zip(coefficients,labels) if all(row[j] == (0,0) for j in range(6) if j not in S)) for S in supports]
    assert all(len(group) == 4 for group in subgroup_coeffs)
    for chosen in itertools.combinations(subgroup_coeffs,3):
        span = {tuple(sum(v[j] for v in vectors) % 2 for j in range(6))
                for vectors in itertools.product(*chosen)}
        assert len(span) == 64
    failures = []
    for chi in coefficients[1:]:
        failures.append(tuple(any(sum(x*y for x,y in zip(chi,bits))%2 for bits in group) for group in subgroup_coeffs))
    histogram = Counter(map(sum, failures))
    assert histogram == {4:45, 6:18}
    for s in range(1,7):
        for chosen in itertools.combinations(range(6),s):
            gap = min(Fraction(sum(row[i] for i in chosen),s) for row in failures)
            expected = Fraction(max(0,s-2),s)
            assert gap == expected
    weights = (Fraction(0),Fraction(1,15),Fraction(2,15),Fraction(3,15),Fraction(4,15),Fraction(5,15))
    assert min(sum(w*b for w,b in zip(weights,row)) for row in failures) == sum(sorted(weights)[:4])
    return {'generators_symplectically_commute':True,'minimum_label_support':4, 'all_20_half_libraries_span':True, 'character_failure_histogram':dict(histogram), 'all_63_nonempty_two_star_subsets_checked':True,'weighted_gap_checked':True}


def spectra():
    output = {}
    for m,q in ((2,3),(3,2)):
        Q=q*q
        A={0:1}
        for w in range(m+1,2*m+1):
            A[w]=comb(2*m,w)*sum((-1)**j*comb(w,j)*(Q**(w-m-j)-1) for j in range(w-m))
        assert sum(A.values()) == q**(2*m)
        assert all(n>=0 for n in A.values())
        output[f'm={m},q={q}']=A
    return output


if __name__ == '__main__':
    result={'exact_six_qubit_checks':stabilizer_six_qubits(),'weight_enumerator_arithmetic':spectra()}
    print(json.dumps(result,indent=2))
```


### 7.5 New four-qutrit enumeration

`check_four_qutrits.py` uses the manuscript's coordinate formula for its 81 stabilizer labels. It checks symplectic commutation, minimum support three, subgroup size nine, all pairwise spanning statements, all nontrivial characters, all fifteen nonempty selected test libraries, one nonuniform weighted instance, and the `Z_1(1)` failure pattern. All assertions passed.

Results are in `four_qutrit_check.json`; the rerun of the original script is in `six_qubit_check.json`. Both scripts use only the Python standard library. They remain author-side sanity checks, not premises of the analytic proof or a new manuscript supplement requirement.


---

<a id="module-8"></a>

## Packet changes for AME-LU revision `55e70c4`

### Decision

Keep the proposed two-star verification results. The pinned revision does **not** yet contain the two-star weighted gap, the sharp setting-count tradeoff, or their observable-rounding corollary. Its existing marginal-certification proposition remains a one-star result.

Replace the quantitative wrapper in the old packet. The revised paper has already removed the characteristic-dependent local threshold and the separate `p^-1` contribution to the global radius. It has also made the transition-compatibility threshold independent of both local dimension and party count. Reintroducing the old constants would weaken and misdescribe the revised theorem.

Use the new four-qutrit example to illustrate verification rather than introducing another unrelated example. Keep the proposed main-text addition short; the full spectrum, universal non-stabilizer proof, general optimisation oracle, and optional a posteriori certificate need not all enter the main paper.

**Source reviewed:** `55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82`.

**Original packet baseline:** `f5eb6b2febc06461f0cfaf8ac7533e4356bef1e7`.

This update compares the public TeX and commit diff with the supplied Markdown packet. It does not presume access to an unexported working tree. No PDF was analysed, no TeX build was performed, and no repository files were modified. Sources are listed at the end.

### 1. What to remove, retain, and relocate

| Original packet item | Action at `55e70c4` |
|---|---|
| Module 3.3: retain `tau_p` and require `eta(gamma)<tau_p/8` | Replace by `eta(gamma)<1/24`. The current nested-Weyl lemma has threshold `eta<1/3`, and cleaning contributes the factor eight. |
| Module 3.3: global radius has order `min(p^-1,q^-1/2,n^-1/2)` | Remove. The current radius is exactly `min(1/(4 sqrt(2q)),1/(8 pi sqrt(n)))`. |
| Any reading that transition compatibility needs a dimension-dependent threshold | Replace by the current universal threshold `sqrt(2)/68`. Do not remove the character-correction limitation. |
| Modules 1–2: two-star direct sum, weighted gap, setting/gap tradeoff, and universal full gap | Retain as proposed additions. They have not been incorporated by this revision. |
| Module 3.1: state certification and trace-distance conversion | Retain. These inequalities do not change. |
| Module 3.5: distinguish label compatibility from the character of the Clifford output | Retain and connect to the new four-qutrit example. |
| Module 4: general verifier-design oracle | Keep out of the main proof development. A short closed-form weighted-gap remark is enough for this paper. |
| Module 5: long abstract addition | Replace by at most one short sentence, or omit it. The current abstract already separates exact rigidity, robust rounding, and finite recognition. |
| Module 6: verification references | Still needed if the verification additions are adopted. The inspected `refs.bib` does not contain the Dangniam–Han–Zhu or Pallister–Linden–Montanaro keys. |
| Old source commit and insertion metadata | Rebase to the supplied commit. Use theorem labels, not absolute theorem numbers or line numbers. |
| Six-arc phase classification, Ergodis experiments, new formalization claims | Continue to exclude them. None is a premise of the verification additions. |

The `tau` in the order-statistic LP of Module 4 is an optimisation variable and remains valid; only the obsolete characteristic threshold `tau_p` is removed.

The existing half-supported Pauli correction, logical Clifford rounding, promised-input recognition contract, and corrected Choi label convention are already manuscript results. They should be cited, not reintroduced as new contributions.

### 2. Replace the observable corollary by three certification levels

Let the target be a stabilizer `AME(2m,q)`, put `n=2m`, and let

$$
\nu_* = \frac{m+1}{2m}.
$$

Use the uniform doubled-star verification operator from Module 1. For an input density operator `sigma`, let

$$
r_*(\sigma)=\operatorname{Tr}(H_*\sigma).
$$

If `gamma` is a valid upper bound on this rejection probability, define

$$
a_\gamma=\min\{\gamma/\nu_*,1\},
\qquad
\eta(\gamma)=\sqrt{2\left(1-\sqrt{1-a_\gamma}\right)}.
$$

For `sigma=U|psi><psi|U^dagger`, with `U` promised to be a product unitary,

$$
\varepsilon(U)\le\eta(\gamma).
$$

For `0<t<sqrt(2)`, put

$$
\Gamma_{\nu}(t)=\nu\left(t^2-\frac{t^4}{4}\right).
$$

Then `gamma<Gamma_(nu_*)(t)` implies `eta(gamma)<t`. The proof is the exact identity `epsilon(U)^2=2(1-sqrt(F))`, combined with `F>=1-gamma/nu_*`.

#### Replacement corollary

The following conditions are sufficient for the corresponding conclusions:

| Upper bound on rejection | Conclusion |
|---|---|
| `gamma < Gamma_(nu_*)(1/24)` | Every local factor is within normalized phase-optimised Hilbert–Schmidt distance `8 eta(gamma)` of an additive Clifford. |
| `gamma < Gamma_(nu_*)(sqrt(2)/68)` | The rounded symplectic frames obey every exact transition equation. A Pauli correction gives an exact symmetry, and each chosen encoder has an exactly transversally realizable logical Clifford within `8 eta(gamma)`. The correction need not be locally small. |
| `gamma < Gamma_(nu_*)(R_clean_(n,q))` | A nearby exact symmetry and the collective residual-generator estimate are certified, with the same hypotheses and constants as the revised global-rounding theorem. |

Here the current radius is

$$
\boxed{
R^{\mathrm{clean}}_{n,q}
=\min\left\{\frac1{4\sqrt{2q}},\frac1{8\pi\sqrt n}\right\}.
}
$$

At the final level,

$$
U=g\bigotimes_i e^{ih_i},\qquad g\in G(\psi),
$$

up to phase, with traceless Hermitian `h_i` of spectral spread at most `pi`, and

$$
\boxed{
\left(\sum_i\|h_i\|_F^2\right)^{1/2}
\le\pi\sqrt q\,\eta(\gamma),
\qquad
\sum_i\left(q^{-1/2}\min_{|z|=1}\|U_i-zg_i\|_{\rm HS}\right)^2
\le\pi^2\eta(\gamma)^2.
}
$$

**Proof.** Convert rejection to state-vector defect as above and apply, respectively, the cleaning/Fourier lemmas, `prop:robust-linear-atlas` and `cor:logical-clifford-rounding`, or `thm:cleaning-global-rounding` and its collective chord estimate. These are applications of the revised manuscript theorems, not new rounding arguments. ∎

For a nonuniform or incomplete two-star library, the same wrapper works with its exact positive gap `nu` in place of `nu_*`. If its gap is zero, there is no such fidelity certificate.

For approximate intertwiners, keep the existing hypothesis of `cor:relative-intertwiner-rounding`: an exact product-unitary intertwiner is supplied or known to exist. Use the target state's verifier and apply the stated exact-base reduction. Do not infer new LU equivalence from these observations alone.

#### Placement

The two-star verification theorem belongs after `prop:marginal-certification`. This three-level corollary should instead appear **after `cor:logical-clifford-rounding`**, where all three quantitative inputs have been proved. It should not be inserted before the transition result and silently depend on a later statement.

#### Distinctions to preserve

The first two observable thresholds are universal. The final global threshold remains dimension- and party-count-dependent through `R_clean`. No constant-radius nearby-symmetry theorem follows from this wrapper.

For arbitrary mixed inputs, only the state-fidelity conclusion holds. Factorwise unitary conclusions require the product-unitary promise. The zero rejection of an empirical run is not itself a deterministic bound on the true rejection probability.

### 3. Extend the manuscript's four-qutrit example

The new `subsec:four-qutrit-example` already uses

$$
|\psi\rangle=\frac13\sum_{x,y\in\mathbb F_3}|x,y,x+y,x+2y\rangle,
\qquad |\phi\rangle=Z_1(1)|\psi\rangle.
$$

Use these same states in a short example after the proposed verification theorem. With halves `{1,2}` and `{3,4}`, the doubled star is exactly the four three-party marginals. Write

$$
\Pi_{\widehat j}=3\rho^\psi_{[4]\setminus\{j\}}\otimes I_j,
\qquad
H_* = \frac14\sum_{j=1}^4(I-\Pi_{\widehat j}).
$$

#### Suggested insertion

> For the four-qutrit state of Section [four-qutrit example], two, three, and four distinct three-party tests sampled uniformly have optimal gaps `1/2`, `2/3`, and `3/4`, respectively. The phase-shifted state `phi=Z_1(1)psi` passes the test omitting party 1 and fails every test containing it. Hence `Tr(H_*|phi><phi|)=3/4`, attaining the gap. The transition maps are unchanged by this shift, whereas the marginal tests detect the changed stabilizer character.

**Proof of the pass/fail assertion.** The test omitting party 1 has the same reduced input state and therefore accepts. On any support containing party 1, projection of its minimum-support stabilizer subgroup onto party 1 is onto the Weyl-label plane. The `Z_1(1)` shift is a nontrivial character of that subgroup. Averaging that character gives zero acceptance. ∎

An optional extra line records the entire spectrum:

$$
\operatorname{spec}(H_*)=
\{0\text{ with multiplicity }1,
\quad 3/4\text{ with multiplicity }32,
\quad 1\text{ with multiplicity }48\}.
$$

Indeed, every two test subgroups span `L`. The annihilator of one test subgroup has nine characters, eight nontrivial; no nontrivial character passes two tests. Thus `4*8=32` characters fail three tests, and the other `81-1-32=48` fail four.

This is an analytic illustration of the existing character distinction, not a computational premise. The new packet also directly enumerates the 81 labels and all characters as an author-side check. It confirms all fifteen nonempty test subsets, the weighted formula, and the displayed `Z_1` failure pattern.

### 4. A sample-cost consequence of the revised radius

This is an optional paragraph, not a new quantum-verification sample-complexity theorem.

Suppose ideal tests are applied independently to identically prepared copies of the same promised output `U psi`. A state-vector defect at least `t` implies infidelity at least `t^2-t^4/4`, and hence rejection probability at least `Gamma_(nu_*)(t)`. Such an output passes all `N` tests with probability at most

$$
\left(1-\Gamma_{\nu_*}(t)\right)^N.
$$

Thus a sufficient all-pass test at false-acceptance level `alpha` uses

$$
\boxed{
N\ge\left\lceil
\frac{\log\alpha}{\log(1-\Gamma_{\nu_*}(t))}
\right\rceil.
}
$$

Taking `t=R_clean_(n,q)` gives a sufficient count

$$
\boxed{N=O(\max\{q,n\}\log(1/\alpha))}
$$

(up to the integer ceiling), uniformly over the stated AME states. On the paper's generalized/extended Reed–Solomon families with `n<=q+1`, this is `O(q log(1/alpha))`, including prime fields. The old characteristic-dependent radius would have given the weaker `O(p^2 log(1/alpha))` sufficient bound on the corresponding prime-field family.

This is an improvement in the accuracy required to invoke the **revised rigidity theorem**, not a new inverse-infidelity sampling exponent, a lower bound, or a proof of optimal sampling under the product-unitary promise. It is a frequentist false-acceptance statement, not a posterior probability about an unknown state. It does not cover arbitrary correlated/adversarial copies or implementation errors.

With calibrated effects satisfying the old Module 3.4 bounds, retain `gamma=r_up+bar_kappa`. A nonzero calibration floor must itself lie below the chosen `Gamma` threshold. None of the improved asymptotics removes that requirement.

### 5. Optional addition: a posteriori branch selection

The revised global proof first bounds actual residual errors, then substitutes the worst-case estimate at all `n` sites. Expose the first step as a reusable certificate. This is an immediate corollary of the manuscript's second-moment identity and overlap-gap lemma, not an improved uniform radius.

#### Proposition

Let `psi` be a stabilizer `AME(2m,q)` state. Suppose a proposed product Clifford `K=bigotimes_i K_i` and a product unitary `U` satisfy, up to scalar phase,

$$
K^\dagger U=\bigotimes_i e^{ih_i},
$$

where the `h_i` are traceless Hermitian with spectral spread at most `pi`. Set

$$
D^2=\sum_i\|h_i\|_F^2,
\qquad d_p=\sqrt{2-2p^{-1/2}},
$$

and let `epsilon(U)<=e` be a valid bound, for example `e=eta(gamma)` from marginal verification.

If

$$
\boxed{e+D/\sqrt q<d_p,}
$$

then `K` is an exact symmetry of `psi`. If also `D^2<=q/4`, then

$$
\boxed{D\le\pi\sqrt q\,e.}
$$

When label preservation by `K` has already been checked, the branch test may use `sqrt(2)` in place of `d_p`: a wrong character on the same full stabilizer label space gives an orthogonal state.

#### Proof

Put `M=sum_i h_i^(i)`. Two-uniformity and tracelessness imply

$$
\|M\psi\|^2=\langle\psi|M^2|\psi\rangle=D^2/q.
$$

The integral identity for `e^(iM)-I` gives

$$
\|(e^{iM}-I)\psi\|\le D/\sqrt q.
$$

Therefore

$$
\varepsilon(K)\le\varepsilon(U)+D/\sqrt q\le e+D/\sqrt q.
$$

The strict gap test and `lem:stabilizer-overlap-gap` force `K psi` to have the target ray. Its residual has defect `epsilon(U)`, so `prop:main-residual-stability` applies when `D^2<=q/4`, proving the final estimate. In the label-preserving case, distinct character eigenstates are orthogonal, replacing the separation gap by `sqrt(2)`. ∎

#### Chord-only sufficient conditions

One need not form all logarithms just to certify eligibility. Compute

$$
\delta_i=q^{-1/2}\min_{|z|=1}\|U_i-zK_i\|_{\mathrm{HS}},
\qquad
\delta_i^2=2-2\left|q^{-1}\operatorname{Tr}(K_i^\dagger U_i)\right|.
$$

If

$$
\max_i\delta_i<\sqrt{2/q},
\qquad
\sum_i\delta_i^2\le\frac1{\pi^2},
\qquad
 e+\frac\pi2\sqrt{\sum_i\delta_i^2}<d_p,
$$

the manuscript's centered-logarithm lemma gives all hypotheses of the proposition. With `e<1/24`, the last inequality follows automatically from the middle one, since `1/24+1/2<d_2`.

Substituting only `delta_i<=8e` recovers the current worst-case radius. Smaller **actual** accumulated residuals can certify instances outside that sufficient radius. No theorem here says that these residuals are always small there. The certificate requires access to, or certified information about, the local operations; state-verification outcomes alone do not provide these chord distances. It also does not assert an efficient search for the proposed `K`.

Suggested label: `cor:posteriori-branch-certificate`. Place after the collective chord estimate and before the relative-intertwiner corollary, or leave as an author-side/algorithmic remark if the paper is already at its desired length.

### 6. Integration details that now matter

**Do not expand the main narrative unnecessarily.** Keep the weighted-gap theorem and setting tradeoff beside marginal certification. Put the general AME proof, complete MDS enumerator, and generic verification LP/oracle in an optional appendix or a separate note. The four-qutrit paragraph often makes the full spectrum appendix unnecessary.

**Do not claim the revision incorporated the new verifier.** It incorporated a worked state, corrected thresholds, stronger scope contracts, and proof clarifications. The two-star proposal is still a proposal.

**Preserve the new encoder convention.** If the reference Clifford has label map `F`, its logical unitary is `(C^T)^(-1)=conjugate(C)` and its logical label map is `tau F tau`, where `tau(a,b)=(a,-b)`. This is generally not `F^(-T)`. The old packet did not need an explicit formula, but any new algorithmic expansion must use the corrected manuscript convention.

**Preserve promised inputs.** The equivalence-recognition algorithm assumes AME stabilizer check matrices; it is not a polynomial-time AME-property test. A compact symplectic witness is not automatically a synthesized hardware circuit.

**Avoid appendix-letter drift.** `sec:verification` currently labels “Verification and trust boundary.” If an experimental-verification appendix is inserted before it, the README's hard-coded “Appendix C” will become stale. Prefer “Proof and formalization boundary” for the existing heading and reference it by label in TeX; make the README wording independent of appendix letters.

**Keep conditional author records out of proof dependencies.** The two finite checks in this update are independent implementation sanity checks, not mathematical premises. The proposed analytic additions have no new Lean coverage. Do not restore the specific old toolchain/gate claims that the revised public trust statement removed.

**Choose only one abstract sentence.** A suitable optional sentence is: “The marginal atlas also gives a sharp subset-local verification tradeoff and observable criteria for the rounding regimes.” The proof and measurement-model explanation belong in the body.

### 7. Review record

The old-to-new public diff and the current main source, introduction, exact-atlas section, quantitative section, conclusion, bibliography, and trust-boundary appendix were inspected. The numerical-threshold replacements, three-level rejection conversion, example pass/fail calculation, sample-count deduction, and optional a posteriori argument were checked against those statements.

The original six-qubit check was rerun successfully. A new independent enumeration for the revised four-qutrit example also passed. The archive includes the standard-library scripts and their JSON outputs. These are optional author tools.

No full re-audit of the entire revised rigidity proof, publication-priority search, TeX build, PDF review, or proof-assistant verification is claimed. The earlier six-arc torsion claims and Ergodis benchmarks were not re-audited here.

### Sources

- [Pinned revised repository](https://github.com/tavisrudd/ame-lu/tree/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82).
- [Old-to-new source diff](https://github.com/tavisrudd/ame-lu/compare/f5eb6b2febc06461f0cfaf8ac7533e4356bef1e7...55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82.diff).
- [Current exact atlas and four-qutrit example](https://raw.githubusercontent.com/tavisrudd/ame-lu/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82/sections/03-exact-rigidity-atlas.tex).
- [Current quantitative proofs and constants](https://raw.githubusercontent.com/tavisrudd/ame-lu/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82/sections/05-quantitative-rounding.tex).
- [Current introduction](https://raw.githubusercontent.com/tavisrudd/ame-lu/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82/sections/01-introduction.tex).
- [Current main source](https://raw.githubusercontent.com/tavisrudd/ame-lu/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82/main.tex).
- [Current conclusion](https://raw.githubusercontent.com/tavisrudd/ame-lu/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82/sections/07-conclusion.tex).
- [Current trust boundary](https://raw.githubusercontent.com/tavisrudd/ame-lu/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82/sections/08-verification-boundary.tex).
- [Current bibliography](https://raw.githubusercontent.com/tavisrudd/ame-lu/55e70c4a1b46f6c0e5de24751ff1e5b1dc80ad82/refs.bib).
- Dangniam, Han, and Zhu, [Optimal verification of stabilizer states](https://arxiv.org/abs/2007.09713), *Physical Review Research* **2**, 043323 (2020).
- Pallister, Linden, and Montanaro, [Optimal verification of entangled states with local measurements](https://arxiv.org/abs/1709.03353), *Physical Review Letters* **120**, 170502 (2018).

