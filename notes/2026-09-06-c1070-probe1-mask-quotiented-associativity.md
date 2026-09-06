# C1070 probe 1 — mask-quotiented associativity of the labelled recovery cost

**Lane**: `ergodis`
**Task**: C1070 probe 1 (brief: `notes/2026-09-06-c1070-ergodis-compositional-leakage-brief.md`)
**Manuscript read, not edited**: `papers/complete-repair-ports/compositional_recovery.tex` and its
`sections/03-positive-density.tex`, `sections/03a-exact-recovery-optimization.tex`.
**Code**: `~/src/ergodis-private` (tier-1 module plus one `tasks/tools` subcommand); no change to
the `~/src/ergodis` core.
**Scope**: the linear-uniform model only. Non-uniform priors, noisy observations, and computational
(as opposed to information-theoretic) privacy are out of scope and are not addressed anywhere below.

---

## 0. Verdict

| Question | Verdict |
|---|---|
| (a) associative min–sum survives modulo masks | **Yes**, verbatim, under one hypothesis: the mask spaces of distinct blocks at the same level are independent. That hypothesis is not decorative — a two-block, one-mask counterexample makes the fresh-mask min–sum return $\infty$ where the true cost is $2$. |
| (b) target normalization survives | **Yes** — but only because the correct masked target is *pointed*, not a quotient class. Quotienting a target by the mask subspace does compose, and it computes exactly the mask-free cost, so it is an erasure of the masks rather than a coarsening of the state. |
| (c) contextual quotient still exact and a congruence | **Yes**, with the witness-context length bound $\max\{2,r+1\}$ and functional-dual dimension bound $\min\{t,r\}$ **unchanged**. What changes is the per-level state count, by a factor $q^{t\dim R_{\mathrm{sh}}}$ for whatever randomness is shared across blocks, and one hypothesis in the rank-one *projective* description, which needs the promoted mask space to be $L$-linear. |

The single sentence that carries the whole probe is the brief's own §7 remark, now proved: **leakage
spaces do not compose, observation spaces do.** The object that composes associatively is the induced
functional on the *full* message-and-mask space. Every failure below is an attempt to drop the mask
coordinates from the intermediate state.

---

## 1. Model

Everything is $\F_q$-linear. Where the manuscript uses a field tower $\F_q\subseteq L\subseteq M$ and
the trace pairing, the composition statements themselves are $\F_q$-linear algebra; the tower is
needed only for the rank-one projective probe of the contextual quotient, and §5 says exactly where.

### 1.1 Masked represented code

A **masked represented code** is a pair $(\iota, R)$ consisting of an $\F_q$-linear map
$$\iota : \Msg \oplus R \longrightarrow \F_q^{E},$$
where $\Msg$ is the *exposed* message space (the alphabet the next level up encodes into) and $R$ is
the **mask space**, carrying fresh uniform randomness that is generated locally and is *not* a
message coordinate of the next level. Write $I = \operatorname{im}\iota$.

The label (dual restriction) map is
$$\Phi : \F_q^{E}\longrightarrow(\Msg\oplus R)^{*},\qquad \Phi(y)(m,r)=\langle y,\iota(m,r)\rangle,$$
with $\ker\Phi = I^{\perp}$, and it splits as $\Phi=(\Phi^{\Msg},\Phi^{R})$ along
$(\Msg\oplus R)^{*}=\Msg^{*}\oplus R^{*}$. The mask-free theory of the manuscript is the case $R=0$.

### 1.2 What a coalition recovers

Let $Z$ be uniform on the full message-and-mask space and let a coalition observe the coordinates in
$H\subseteq E$. By the rank identity of the brief's §2, a coalition learns a secret functional
$s\in\Msg^{*}$ *exactly* iff there is $y$ supported on $H$ with
$$\Phi^{\Msg}(y)=s\qquad\text{and}\qquad \Phi^{R}(y)=0 .$$
The second condition is not optional: with $r$ uniform and independent, an observation
$s(m)+\rho(r)$ with $\rho\ne0$ is independent of $m$ and reveals nothing. This is exactly the brief's
leakage space $L_H=\{u^{\mathsf T}A: u^{\mathsf T}B=0\}$.

So the masked problem is **annihilation**, not quotient. This distinction is the whole of (b) and is
worth stating as a slogan: *masks are not modded out, they are killed.*

### 1.3 Masked costs

For an $\F_q$-space $T$ of target parameters and $b:T\to\Msg^{*}$, define

$$\lambda^{\mathrm{msk}}_{T}(b)=\min\bigl\{|\operatorname{supp}Y(T)| \;:\; Y:T\to\F_q^{E},\ \Phi^{\Msg}Y=b,\ \Phi^{R}Y=0\bigr\},$$

and, for a target block with target coordinates $P$ and helper coordinates $J=E\setminus P$,

$$\mu^{\mathrm{msk}}_{P,T}(b)=\min\bigl\{|\operatorname{supp}\beta(T)| \;:\; \alpha:T\to\F_q^{P},\ \beta:T\to\F_q^{J},\ G_P\alpha=\iota_T,\ \Phi^{\Msg}(\alpha,\beta)=b,\ \Phi^{R}(\alpha,\beta)=0\bigr\}.$$

An empty minimum is $\infty$. Unlike the mask-free case these can genuinely be $\infty$ even for a
surjective $\Phi$, because the constraint set is a proper affine subspace of the label fibre; §4's
counterexample exhibits it.

### 1.4 Masked tower

A two-level masked tower is:

* an outer masked code $\iota_A:\Msg_A\oplus R_A\to L^{E_A}$ with intermediate alphabet $L$;
* for each $e\in E_A$ a block masked code $\iota_{B,e}:L\oplus R_e\to\F_q^{E_B}$;
* composite $\iota:\Msg_A\oplus R_A\oplus\bigoplus_{e}R_e\to\F_q^{E_A\times E_B}$,
  $$\iota(m,r_A,(r_e))_e=\iota_{B,e}\bigl(\iota_A(m,r_A)_e,\;r_e\bigr).$$

**Freshness hypothesis (F).** The mask spaces $R_A$ and $R_e$ ($e\in E_A$) are mutually independent;
equivalently the total mask space is the *direct sum* $R_A\oplus\bigoplus_e R_e$.

Hypothesis (F) is exactly what "fresh uniform randomness, projected out at the next level" means when
made precise, and §4 shows it is the load-bearing hypothesis.

---

## 2. (a) The min–sum composes, and why the proof is one line

### Proposition 1 (mask elimination is label pinning)

Let $(\iota,R)$ be a masked represented code. Then
$$\lambda^{\mathrm{msk}}_{T}(b)=\lambda_{T}\bigl((b,0)\bigr),\qquad
\mu^{\mathrm{msk}}_{P,T}(b)=\mu_{P,T}\bigl((b,0)\bigr),$$
where $\lambda_T,\mu_{P,T}$ on the right are the manuscript's *mask-free* prescribed-coset and
target-normalized costs for the same map $\iota$ regarded as a represented code with full message
space $\Msg\oplus R$, and $(b,0):T\to(\Msg\oplus R)^{*}$ is $b$ on $\Msg$ and $0$ on $R$.

*Proof.* Both sides minimize the same support functional over the same set: $\Phi Y=(b,0)$ is the
conjunction of $\Phi^{\Msg}Y=b$ and $\Phi^{R}Y=0$. The target-normalization constraint
$G_P\alpha=\iota_T$ is untouched by the decomposition. $\square$

Proposition 1 is trivial and is the point. **The masked theory is the mask-free theory of the enlarged
message space, restricted to the labels that vanish on the mask coordinates.** Every mask-free
statement therefore transfers by restriction, provided the restriction is compatible with the
composition — which is what (F) buys.

### Theorem 2 (masked min–sum closure)

Assume (F). For every $\F_q$-linear $c:T\to\Msg_A^{*}$,
$$\Lambda^{\mathrm{msk}}_{A\circ B,T}(c)=
\min_{\substack{X:T\to (L^{*})^{E_A}\\ \phi_A^{\Msg}X=c,\ \phi_A^{R_A}X=0}}
\ \sum_{e\in E_A}\Lambda^{\mathrm{msk}}_{B_e,T}(X_e),$$
and, for a target split meeting block $e$ in $P_e$ with $J_e=E_B\setminus P_e$,
$$\mu^{\mathrm{msk}}_{A\circ B,P,T}(c)=
\min_{\substack{U,X:T\to (L^{*})^{E_A},\ U_e(T)\subseteq U_{P_e}\\ \phi_A^{\Msg}U=\iota_T,\ \phi_A^{R_A}U=0\\ \phi_A^{\Msg}X=c,\ \phi_A^{R_A}X=0}}
\ \sum_{e\in E_A}\Lambda^{\mathrm{msk}}_{B_e,J_e,T}(X_e-U_e).$$
Both iterate associatively through a finite tower: either parenthesization minimizes over the same
intermediate labels and target contributions and sums the same leaf costs. Minimizing lifts propagate
a coefficient-level witness exactly as in the mask-free case.

*Proof.* The dual of the total mask space splits, by (F), as
$(R_A\oplus\bigoplus_eR_e)^{*}=R_A^{*}\oplus\bigoplus_eR_e^{*}$. Hence the single constraint "the
induced functional kills every mask" splits into
1. $\phi_A^{R_A}X=0$, a constraint on the intermediate label array $X$ alone, and
2. for each $e$ separately, $\Phi_{B_e}^{R_e}Y_e=0$, a constraint on that block's leaf lift alone.

Constraint (2) is block-local, so at a fixed intermediate array $X$ the block lifts remain independent
and their supports remain disjoint; each attains its minimum $\Lambda^{\mathrm{msk}}_{B_e,T}(X_e)$
separately. Constraint (1) is a linear condition on $X$ and simply shrinks the outer feasible set of
the manuscript's Theorem *Min–sum closure of prescribed-coset support costs*
(`prop:prescribed-coset-composition`). The manuscript's proof applies unchanged to the shrunken
feasible set. The target-normalized statement is the same argument applied to the paired
$(U,X)$ labels; the normalization $\phi_A^{\Msg}U=\iota_T$ concerns the *secret* component and the
added $\phi_A^{R_A}U=0$ is the outer instance of Proposition 1. Associativity follows because either
parenthesization eliminates the same intermediate arrays under the same split constraint. $\square$

### Corollary 3 (uniform form)

Under (F), a masked tower of any finite depth is the mask-free tower over the enlarged message space
$\Msg_A\oplus R_A\oplus\bigoplus_e R_e\oplus\cdots$, with the requested label pinned to $0$ on every
mask coordinate at every level. Everything the manuscript proves about the mask-free tower — the
min–sum closure, associativity, the coefficient witness semantics, the sharp scalar envelopes, the
dual-distance recursion, the exact hierarchical optimizer — applies verbatim.

So (a) is **yes**, and the answer is not merely "the same proof goes through": the masked theory *is*
the old theory on a bigger message space. That is a stronger and more useful statement, because it
means the compiler needs no new algorithm, only a bigger label alphabet and a pinned request.

---

## 3. (b) Target normalization, and the exact sense in which "modulo masks" breaks

The brief's worry was that "normalizing a target defined only modulo masks may break the closed but
redundant state property." The resolution is that the worry names a real hazard but misidentifies it:
the hazard is not in the normalization step, it is in the phrase *modulo masks*.

### 3.1 The pointed target normalizes fine

Under §1.2 the masked target is the *pointed* functional $(s,0)$, not a class in
$\Msg^{*}/{\sim}$. Normalization $G_P\alpha=\iota_T$ is a condition on the secret component only, and
the mask condition $\Phi^{R}(\alpha,\beta)=0$ is a condition on the pair $(\alpha,\beta)$ jointly. The
manuscript's $\mu$ is *already* a joint minimum over $(\alpha,\beta)$, so no structure is lost: the
state remains a function on the same index set $\operatorname{Hom}(T,L^{*})$, only the values change.
Closedness under composition is Theorem 2; redundancy is preserved and in fact increases, since masks
turn more labels into $\infty$ without removing them from the index set (a later context may probe a
label whose masked cost is $\infty$, and the state must record that).

### 3.2 The quotiented target composes, and computes the wrong thing

Define the mask-quotient cost, which is what "recover $s$ only up to an unknown mask offset" means:
$$\bar\lambda_T(b)=\min_{\rho:T\to R^{*}}\lambda_T\bigl((b,\rho)\bigr).$$

**Proposition 4.** $\bar\lambda_T$ is exactly the prescribed-coset cost of the same code with $R$
*deleted* from the message space, i.e. of the represented code $\iota|_{\Msg}$ composed with the
projection. The same holds for $\bar\mu$.

*Proof.* Minimizing over all $\rho$ removes the constraint on $\Phi^{R}Y$ entirely, which is the
definition of the cost in the code whose label map is $\Phi^{\Msg}$. $\square$

Two consequences, and they point in opposite directions, which is why both must be stated:

* **The quotient state does compose.** Under (F), $\min_{\rho}\sum_e = \sum_e\min_{\rho_e}$ because
  the mask lifts are per-block independent. So associativity is *not* what fails.
* **The quotient state is the mask-free state.** By Proposition 4 it forgets that any masking
  happened. As a security summary it is a *lower bound* on the adversary's cost
  ($\bar\lambda\le\lambda^{\mathrm{msk}}$ always), hence a conservative privacy bound, but it is
  never the exact recovery cost and it carries no valid witness: its minimizing lift generally
  recovers $s(m)+\rho(r)$, which for $\rho\ne0$ is independent of $m$ and recovers nothing.

So target normalization survives; what does not survive is the idea that masks should be quotiented.
The right operation on the state is to *enlarge* the label alphabet and pin, not to coarsen it.

### 3.3 The two failure directions, for the product

Naming both directions matters because only one of them is dangerous.

| Wrong state | Direction of error | Consequence |
|---|---|---|
| mask-quotiented labels (drop $R^{*}$, minimize over it) | cost too **small**, leakage too **large** | conservative for a privacy claim, useless for exact answers, no valid witness |
| fresh-mask min–sum applied when masks are in fact shared | cost too **large**, leakage too **small** | **unsound privacy claim**: certifies a coalition cannot recover a secret it can recover |

The second row's direction is not an empirical observation but a theorem, which is worth stating
because it tells a deployer exactly which way an unverified freshness assumption can fail.

**Lemma 5 (the fresh-mask formula never under-reports).** Let a tower have a mask space
$R_{\mathrm{sh}}$ shared between blocks, and let $\widetilde\Lambda(c)$ be the value returned by
Theorem 2's formula applied as if every block's copy of $R_{\mathrm{sh}}$ were private to it. Then
$$\widetilde\Lambda(c)\ \ge\ \Lambda^{\mathrm{msk}}_{A\circ B,T}(c)\qquad\text{for every }c,$$
with equality not guaranteed.

*Proof.* The fresh reading imposes $\Phi^{R_{\mathrm{sh}}}_{B_e}Y_e=0$ for every block $e$
separately; the true condition is the single equation $\sum_e\Phi^{R_{\mathrm{sh}}}_{B_e}Y_e=0$. The
first implies the second, so the fresh reading minimizes the same support functional over a *subset*
of the true feasible set. A minimum over a subset is at least the minimum over the whole set.
$\square$

So a missed sharing always produces a claim of *more* privacy than is real, never less; and §6.3
finds zero under-reports in 1,239,350 exact comparisons, as Lemma 5 requires. The failure is silent
in the worst way: §6.3 also finds 48,296 cases where the over-report is a plausible finite number
rather than an obvious $\infty$.

The second row is the composition failure mode of the unlabelled side-channel composition notions
(non-interference, strong non-interference, probe-isolating non-interference) that the brief cites,
and §4 is exactly that failure in one line of algebra.

---

## 4. The counterexample: mask reuse across blocks

This is Astra's `s₁+r, s₂+r` example expressed as a two-block tower, and it is what shows hypothesis
(F) is load-bearing rather than cosmetic.

Take any $q$, $L=\F_q$, $E_A=\{1,2\}$, $E_B=\{1\}$ (one leaf coordinate per block), secrets
$\Msg=\F_q^{2}$ with coordinates $s_1,s_2$, and a **single shared** mask space $R=\F_q$ used by both
blocks:
$$\iota_A(s_1,s_2)=(s_1,s_2),\qquad \iota_{B,e}(\ell,r)=\ell+r\quad(e=1,2).$$
Leaf observations are $y_1=s_1+r$, $y_2=s_2+r$. Target: the named secret functional $c=s_1-s_2$
($T$ one-dimensional, $t=1$).

* **Truth.** $Y=(1,-1)$ gives $y_1-y_2=s_1-s_2$ with zero mask coefficient, so
  $\Lambda^{\mathrm{msk}}(c)=2$. (And $\Lambda^{\mathrm{msk}}(s_1)=\infty$: $u_1+u_2=0$ with
  $u_1=1,u_2=0$ is inconsistent.)
* **Fresh-mask min–sum, i.e. Theorem 2 applied outside its hypothesis.** Each block must kill *its
  own* copy of $r$: a block lift $u\in\F_q$ has $L$-label $u$ and mask label $u$, so the masked block
  table is $\Lambda^{\mathrm{msk}}_{B_e}(0)=0$ and $\Lambda^{\mathrm{msk}}_{B_e}(X)=\infty$ for
  $X\ne0$. The outer constraint needs $X_1=1$, $X_2=-1$, so the formula returns $\infty$.
* **Disagreement.** $\infty$ predicted against a true cost of $2$: the unsound direction of §3.3.

**Repair, and it is the product rule.** Enlarge the intermediate state from $X_e\in
\operatorname{Hom}(T,L^{*})$ to the pair $(X_e,\sigma_e)\in\operatorname{Hom}(T,L^{*})\oplus
\operatorname{Hom}(T,R_{\mathrm{sh}}^{*})$, where $\sigma_e$ is the block's *accumulated mask
covector*, and impose $\sum_e\sigma_e=0$ at the level where the sharing closes. Equivalently and more
usefully: **promote every shared mask to a message coordinate of the lowest level at which it is
common, pinned to zero in the request.** Then (F) holds for the promoted tower and Theorem 2 applies
verbatim. In the example the block cost of the state $(X_e,\sigma_e)$ is $|u|$ with $u=X_e=\sigma_e$,
so $(1,1)$ costs $1$ and $(-1,-1)$ costs $1$, $\sum_e\sigma_e=0$ holds, and the formula returns $2$.

This makes the brief's §7 slogan operational. The state that composes is the observation space in
$(s,r)$-coordinates; the leakage space is a function of it and not conversely; mask reuse is visible
in the compiled object as a rank drop in the mask block, and promoting the shared part is the
mechanical fix.

---

## 5. (c) The contextual quotient under masks

By Corollary 3, under (F) the masked theory is the mask-free theory over the enlarged message space,
so the quotient theorems apply by substitution. The substitutions and the one genuine change:

### 5.1 What is unchanged

* **The zero-functional sector cost.** $z_{I,T}=\rho_T(I)+d(I^{\perp})$ becomes
  $z^{\mathrm{msk}}_{I,T}=\mu^{\mathrm{msk}}_{P,T}(0)+d(I^{\perp})$, and the dual distance
  $d(I^{\perp})$ is **unchanged**: the zero-sector perturbation must have zero label on the whole of
  $(\Msg\oplus R)^{*}$, i.e. lie in $\ker\Phi=I^{\perp}$, which is the same subspace as before. Only
  the normalized term changes.
* **Rank- and radius-bounded outer tests.** The proof of the manuscript's
  `prop:rank-bounded-outer-tests` uses only that $\dim_{\F_q}T=t$ (giving
  $\dim_L\operatorname{span}_LB(T)\le t$) and that a cost-$\le r$ system has at most $r$ nonzero
  external labels. Masks add neither target dimensions nor external labels. Hence:
  * **witness context length bound $\max\{2,r+1\}$ — unchanged;**
  * **functional-dual dimension bound $\min\{t,r\}$ — unchanged;**
  * the untruncated bounds of `cor:bounded-contextual-state`, length $\le\max\{2,z\}$ and
    functional-dual dimension $\le\min\{t,z-1\}$, hold with $z=z^{\mathrm{msk}}_{I,T}$.
* **Exactness and the congruence property.** The finite response vector $\mathcal R_{r,T}$ is indexed
  by the same context family and remains the coarsest numerical equivalence determining exact
  responses through helper radius $r$. It is a congruence under compatible further concatenation, for
  the same reason as in the mask-free case, with one added hypothesis (§5.3).

### 5.2 What changes: state count, not bounds

The cost is paid in the size of the compiled object, not in the theorems:

* Under (F), the per-block label alphabet is still $\operatorname{Hom}(T,L^{*})$ and the state count
  per level is unchanged at $q^{t\dim L}$; masks are eliminated *inside* the leaf tables
  $\lambda^{\mathrm{msk}},\mu^{\mathrm{msk}}$ and cost nothing at the composition layer. This is a
  genuinely good outcome: fresh per-block randomness is free for the compiler.
* When randomness of dimension $\dim R_{\mathrm{sh}}$ is shared across blocks and must be promoted
  (§4), the intermediate state grows from $q^{t\dim L}$ to $q^{t(\dim L+\dim R_{\mathrm{sh}})}$ per
  level. That factor $q^{t\dim R_{\mathrm{sh}}}$ is the exact price of mask reuse, and it is the
  right price: it is the dimension of the coupling that reuse actually creates.

### 5.3 The one hypothesis that is not free

The rank-one *projective* description (`thm:rank-one-contextual-state`) minimizes over $L$-lines
$Lb\le D=O^{\perp}$ and uses the $L$-linearity of the outer code and the trace pairing. Promoting a
shared mask enlarges the outer message space from $\Msg$ to $\Msg\oplus R_{\mathrm{sh}}$; the
projective form survives only if $R_{\mathrm{sh}}$ is an $L$-space and the mask injection is
$L$-linear, so that the promoted outer code is still $L$-linear. When the shared randomness is only
$\F_q$-linear — the common case, since fresh scalars need not respect the outer alphabet — the
rank-one projective probe does not apply and one must use the general
`prop:rank-bounded-outer-tests` and `cor:bounded-contextual-state`, which are $\F_q$-linear and
unaffected. Stating this hypothesis explicitly is the only correction the masked setting forces on
the manuscript's quotient section.

Additionally, the congruence is only for further concatenations that **do not reuse a promoted mask
below the level at which it was promoted**. A later layer that re-injects the same randomness into a
leaf breaks (F) again for the composite, and the promotion must be redone at the new common level.

---

## 6. Computational check

### 6.1 What is checked, and what the checker trusts

For every tower in a canonical enumerated family, three numbers are computed for **every** named
secret functional at once:

* **brute** — the exact masked cost, by exhaustive search over all leaf coefficient vectors of the
  composite generator, keeping those whose induced label is the named functional on the secret space
  and zero on every mask coordinate (outer, shared, and fresh alike);
* **naive** — the min–sum prediction of Theorem 2 built from the per-block masked cost tables, with
  every block mask treated as fresh, i.e. the formula applied *as if* (F) held;
* **promoted** — the same prediction after the shared randomness has been moved into the
  intermediate alphabet by `TowerSpec::promote_shared`, so that (F) genuinely holds.

The min–sum itself is **not reimplemented**: `naive` and `promoted` are computed by
`ergodis::composition::CompositionTable`, the public core's composition kernel, driven by the masked
tables. A disagreement is therefore a statement about the mathematics and about the core's kernel,
not a comparison of two private implementations of the same formula. Two further internal invariants
are enforced and would abort the run: the promoted tower must brute-force to the *same* cost vector
as the original (promotion changes where randomness is eliminated, never the leaf code), and every
block-table computation is an independent exhaustive search.

**Trusted boundary.** The checker trusts the composite-generator construction, prime-field arithmetic
mod `p`, and the core's composition kernel. It does *not* trust any of the proofs of §2–§5: brute
force is computed from the composite generator directly, with no reference to the min–sum. The
enumeration is deterministic and canonical throughout; **no randomness is used anywhere**, so there
are no seeds to record.

**Scope of the check.** Rank-one targets (`t = 1`), two-level towers, prime fields `q ∈ {2,3,5}`,
uniform blocks or one distinguished block, uniform linear model. It does *not* check `t ≥ 2` targets,
non-prime fields, towers of depth three or more, or the target-normalized formula in the manuscript's
own erased-node convention — §6.4 says what that leaves open.

### 6.2 Inputs

Named cases:

* `astra-shared-mask-pair` — Astra's transcript `y₁ = s₁ + r`, `y₂ = s₂ + r` as a two-block tower
  with one shared mask coordinate; target `s₁ − s₂`.
* `share-triple-c1` / `share-triple-c2` — the manuscript's labelled-versus-unlabelled witness, shares
  `(x, y, x + y)` and `(x, y, x + 2y)`, target `x + y`; each run twice, once with no inner mask and
  once with a fresh two-coordinate additive re-sharing of every outer symbol (hierarchical
  re-randomized secret sharing).

Sweeps. Each fixes a shape and a small canonical list of outer codes, and then enumerates **every**
block encoder of that shape over `F_q` in odometer order, for `shared_mask ∈ {0, 1}`:

| sweep | blocks | intermediate `dim L` | block coordinates | block masks | outer codes | fields |
|---|---|---|---|---|---|---|
| `two-block-dl1` | 2 | 1 | 2 | 1 | identity, sum column, transposed sum column | 2, 3, 5 |
| `three-block-dl1` | 3 | 1 | 2 | 1 | `(x, y, x+y)` and `(x, y, x+2y)` | 2, 3, 5 |
| `two-block-dl2` | 2 | 2 | 3 | 1 | repetition, repetition after a coordinate swap, repetition after a shear | 2, 3 |

### 6.3 Results

Totals over the whole sweep: **128,390 towers** and **1,239,350 target queries**, of which
**619,675** satisfy the freshness hypothesis (F).

| claim | measured |
|---|---|
| fresh masks: `naive == brute` | **619,675 / 619,675**, no exception |
| promotion: `promoted == brute` | **1,239,350 / 1,239,350**, no exception, shared and fresh alike |
| shared masks break the fresh formula | **62,569** disagreements out of 619,675 shared-mask queries |
| direction of every disagreement | **over-report in all 62,569**; **zero** under-reports |
| over-reports that return a wrong *finite* cost rather than declaring the request infeasible | **48,296** |

The direction result is the one to carry forward: across 1.24 million exact comparisons, applying the
fresh-mask min–sum to a tower with shared randomness *never once* returned a cost below the truth. It
always returned a cost above it, which is the unsound direction for a privacy claim — it certifies
that a coalition cannot recover a secret that it can in fact recover. And in 48,296 of those cases it
returned a plausible-looking finite number rather than an obvious $\infty$, so the failure is not
self-announcing.

Named-case values, all three fields agreeing:

| case | field | brute | naive | promoted |
|---|---|---|---|---|
| `astra-shared-mask-pair`, target $s_1-s_2$ | 2, 3, 5 | **2** | **infinite** | **2** |
| `share-triple-c1-unmasked`, target $x+y$ | 3, 5 | 1 | 1 | 1 |
| `share-triple-c2-unmasked`, target $x+y$ | 3, 5 | 2 | 2 | 2 |
| `share-triple-c1-fresh-inner-mask` | 3, 5 | 2 | 2 | 2 |
| `share-triple-c2-fresh-inner-mask` | 3, 5 | 4 | 4 | 4 |

The Astra row is §4's counterexample, confirmed independently of the algebra. The `share-triple` rows
confirm both that the labelled cost separates the two schemes exactly as the manuscript's abstract
says ($1$ against $2$), and that wrapping each share in a fresh mask preserves the separation while
doubling both costs ($2$ against $4$) — fresh masking scales the labelled cost, it does not blur the
distinction that the unlabelled summary loses.

Smallest finite over-report found, in canonical order, over $\F_2$ in `two-block-dl1`: outer code
$\begin{pmatrix}1&0\\0&1\end{pmatrix}$, block encoder rows $(1,0)$ and $(1,1)$, target $(1,1)$ —
true cost $2$, fresh-formula prediction $4$, promoted prediction $2$.

### 6.4 Replay, hashes, and independent cross-check

Working directory `~/src/ergodis-private`; toolchain `rustc 1.93.1 (01f6ddf75 2026-02-11)`; core
checkout `~/src/ergodis` at `6cc9668`; private checkout at `0fe17e4`. Regenerate:

```
cd ~/src/ergodis-private
cargo build --release -p ergodis-tools
~/.cache/ergodis/target/ergodis-private/release/ergodis-tools masked-leakage-report \
  --out ~/src/othello/notes/2026-09-06-c1070-probe1-mask-quotiented-associativity.json
```

Verify the tracked certificate without writing to the worktree by appending `--check` to the same
command; it regenerates in memory and fails loudly on any difference. Runtime is about 14 seconds.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `ergodis-private/src/masked_leakage.rs` | 23043 | `c1303c1381a8a5a7faa53c1c87bce0ab15f7f8fd4bb3146ef9285e18c8ab9dbb` |
| `ergodis-private/tasks/tools/src/masked_leakage_report.rs` | 13550 | `a01ce80b7554940d60b58eb2672860618b2fc0d000d191d86f43df560ece6ed6` |
| `notes/2026-09-06-c1070-probe1-mask-quotiented-associativity.json` | 15517 | `8c0c2c25734f043cb90c4de1d17f0e92fdbad41448a14403b5f36c9b93932ec4` |

**Independent cross-check.** Two are available and both are used. First, the brute-force search and
the min–sum prediction share no code: the former reads the composite generator directly, the latter
runs the public core's composition kernel over per-block tables, so agreement across 1.24 million
queries is a genuine differential check rather than a self-consistency check. Second, the
`astra-shared-mask-pair` and `share-triple` values are computed independently by hand in §4 and in
the manuscript's own worked example, and they match. What is *not* independently cross-checked is the
composite-generator construction itself; the `promote_shared` invariant (both spellings of the tower
must brute-force to the same cost vector) is the check standing in for it.

**Negatives, stated with their domain.** No under-report was found in any of the 1,239,350 queries;
no disagreement of any kind was found in any of the 619,675 fresh-mask queries. The search domain is
exactly the family tabulated in §6.2 and the stop condition is exhaustion of that family. Nothing
here bounds behaviour at `t ≥ 2`, at depth three or more, or over non-prime fields.

---

## 7. What this means for the product interface

Five things follow directly, and they are all cheap to build because none of them needs a new
algorithm.

1. **Masks need no new engine.** By Corollary 3, the privacy interface can accept a mask declaration
   and lower it to the existing compiler by enlarging the message space and pinning the request to
   zero on the mask coordinates. `transfer-subspace` and the existing prescribed-coset cost code take
   the enlarged instance unchanged; this probe's checker uses exactly that path.

2. **Freshness is a compile-time obligation the tool must discharge, not assume.** §4 and §6.3 show
   that assuming independence when randomness is shared silently produces a wrong finite number in
   the direction that overstates security. The input format therefore has to name each randomness
   source and its scope, and the compiler has to *verify* independence rather than trust a
   per-gadget "this block is fresh" annotation. This is precisely where the unlabelled
   non-interference / strong non-interference style of composition goes wrong, and it is the concrete
   thing the product does better.

3. **The repair is mechanical and its price is known.** Promote every shared randomness source to a
   message coordinate of the lowest level at which it is common, pinned to zero. The state cost is a
   factor $q^{t\dim R_{\mathrm{sh}}}$ at the levels below the promotion point — nothing at all if the
   randomness is genuinely local. Since promotion is a pure reinterpretation of the same leaf code
   (checked in §6.1), it can be applied automatically and reported to the user as the reason the
   compiled state grew.

4. **Mask reuse is detectable, not just a hazard to be declared.** Sharing shows up as a rank drop in
   the mask block of the induced-label matrix. The interface can therefore *report* unexpected reuse
   from the encoding alone, which is a diagnostic the probing-model tools do not offer.

5. **The compiled object and its bounds are unchanged.** By §5 the finite contextual quotient, the
   witness-context length bound $\max\{2,r+1\}$ and the functional-dual dimension bound $\min\{t,r\}$
   all carry over. So the probe-2 deliverable — a compiled leakage profile rather than one query per
   subspace — is not blocked by masks and can be designed against the masked model from the start.
   The one hypothesis to carry into the interface's documentation is §5.3: with only $\F_q$-linear
   shared randomness, use the general rank- and radius-bounded tests, not the rank-one projective
   probe.

What this does **not** deliver: nothing about `t ≥ 2` targets under masks beyond the unchanged
bounds, nothing about adaptive observers, nothing outside the uniform linear model.

---

## 8. Mystery ledger

Written after an explicit extra-juice and Tao-style closeout pass over the finished result.

| observation | status |
|---|---|
| Zero under-reports across 1,239,350 comparisons, while over-reports are common. Looked like a suspiciously clean empirical asymmetry. | **Settled during closeout**, and it produced a free upgrade: Lemma 5 in §3.3 proves the fresh-mask feasible set is a subset of the true one, so the direction is forced. The measurement is now a confirmation of a theorem rather than the evidence for a pattern. |
| The `share-triple` masked costs are exactly double their unmasked values ($1\to2$, $2\to4$) in both fields and both schemes. | **Settled.** The fresh two-coordinate additive re-sharing makes the block cost function constant at $2$ on every nonzero intermediate label, so the manuscript's sharp scalar envelope $\delta_{B,T}\Lambda_{A,T}\le\Lambda_{A\circ B,T}\le R_{B,T}\Lambda_{A,T}$ has $\delta_{B,T}=R_{B,T}=2$ and pins the composite exactly. Fresh masking scales the labelled cost; it does not blur the labelled separation. |
| The min–sum is shortest path in a graph labelled by the abelian group $\operatorname{Hom}(T,L^{*}\oplus R^{*})$. | **Settled as a reframing**, and it is the useful one: promotion is exactly "enlarge the labelling group", and the complexity $q^{t(\dim L+\dim R_{\mathrm{sh}})}$ is the group's order. It also says what probe 3 needs — replacing the min–plus semiring by a partially ordered one leaves the group structure untouched, so only the dominance layer changes. |
| The share of shared-mask queries that disagree grows with the field: roughly $8\%$ at $q=2$, $18\%$ at $q=3$, $35\%$ at $q=5$ in `two-block-dl1`. | **Open, low value.** Plausibly because cross-block cancellation reaches more targets as $q$ grows, but no formula was derived and none is needed for any downstream claim. No owner allocated. |
| Whether the map from coalition to leakage space, $H\mapsto L_H$, has matroid or submodularity structure that would let the outer minimization over $t$-dimensional secret subspaces be done greedily. | **Open, and it is a real lead for probe 2**, which owns the minimization over $T$. Noticed while proving §5, not sought. Not pursued here; probe 2 is the owner. |

No other genuine mystery remains in this probe: (a), (b) and (c) are each settled with a proof, and
the computational check agrees with every one of them.

---

## 9. Prior art noticed while working

Recorded, not gating, per the brief's standing constraint.

* The annihilation condition $\{u^{\mathsf T}A:u^{\mathsf T}B=0\}$ and its rank test are the standard
  decision procedure of the $t$-probing model (Ishai–Sahai–Wagner 2003) as implemented by maskVerif,
  IronMask, SILVER and VRAPS. Those tools decide the same linear-algebra question; what they compose
  through is an *unlabelled* sufficient condition (non-interference, strong non-interference,
  probe-isolating non-interference). Theorem 2 plus §4 is the exact labelled statement those
  conditions approximate, together with the precise hypothesis (F) under which the approximation is
  sound and the exact repair when it is not.
* Massey's coding-theoretic view of secret sharing is the identification in §1.2; relative
  generalized Hamming weights as the parameter of linear secret sharing is
  Luo–Mitrpant–Vinck–Chen 2005, Kurihara–Uyematsu–Matsumoto 2012, Geil–Martín–Matsumoto–Ruano–Luo
  2014. Probe 0 owns pinning these.
