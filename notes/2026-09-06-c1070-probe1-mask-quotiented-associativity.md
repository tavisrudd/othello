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

*(filled in after the run; see §6.1 for the replay command and hashes)*

---

## 7. What this means for the product interface

*(see §7 after the run)*

---

## 8. Prior art noticed while working

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
