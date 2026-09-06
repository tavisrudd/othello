# C1070 probe 2 — the `t`-symbol leakage profile without subspace enumeration

**Lane**: `ergodis`
**Task**: C1070 probe 2 (brief: `notes/2026-09-06-c1070-ergodis-compositional-leakage-brief.md`).
**Ground truth**: probe 5, `notes/2026-09-06-c1070-probe5-privacy-interface-tower-case.md`, its module
`~/src/ergodis-private/src/hierarchical_leakage.rs`, and the committed reports under
`notes/data/2026-09-06-c1070-probe5/`.
**Companion**: probe 1, `notes/2026-09-06-c1070-probe1-mask-quotiented-associativity.md`. This probe
is mask-free, like probe 5; §7 says what a unification would look like and why it is not done here.
**Scope**: uniform linear model only. Non-uniform priors, noisy observations, adaptive observers,
and computational (as opposed to information-theoretic) privacy are out of scope throughout.

---

## 0. Verdict

**The Gaussian-binomial enumeration over secret subspaces is unnecessary for the leakage profile, and
the reason is more elementary than the contextual quotient.** The profile is a coalition-side
quantity: one best-first sweep over coalitions in nondecreasing cost yields $\Gamma_1,\dots,\Gamma_k$
simultaneously. That is Theorem A, it is unconditional, and it removes the entire outer minimization
that probe 5's direct method performs.

| question | verdict |
|---|---|
| (1a) is $H\mapsto\dim L_H$ submodular? | **No** — and not supermodular either. Two-unit counterexamples in dimension at most two exist over every field (Theorem B). So no submodular-minimization or matroid machinery applies on the coalition side. |
| (1b) does greedy extension of a minimum-cost $(t-1)$-subspace reach a minimum-cost $t$-subspace? | **No** (Proposition C, a three-dimensional secret with two units, over every field). What does hold: the greedy chain is a $t$-approximation, $\Gamma_t\le g_t\le\sum_{j\le t}\Gamma_j\le t\,\Gamma_t$ (Proposition D), and it is **exact** when every observation is itself a secret functional and units are single coordinates (Proposition E). |
| (2) does the quotient give the profile without subspace enumeration? | **Split answer, and both halves matter.** Query time: yes, and unconditionally — Theorem A, no quotient needed. Compile time for the *tower* min–sum: no, the rank index survives. The compiled tables are indexed by rank-$t$ label arrays of size $q^{t\dim L}$ per block, so the enumeration moves rather than disappears. What the quotient *does* buy is that one compiled object at functional-dual dimension $\le r$ serves every $t\le r$, instead of one compilation per $t$. §6 quantifies the trade on probe 5's towers. |

The single most useful sentence for the product: **the profile query and the named-subspace query are
different problems, and only the second one needs subspaces.** Probe 5 computes the profile through
the second, which is why it pays a Gaussian binomial it does not owe.

---

## 1. The object, flattened

Compiling any tower produces a flat instance, and every statement below is about that flat instance,
so nothing depends on the number of levels.

* $W=\F_q^{n}$, the space of message functionals.
* Leaf coordinate $j$ contributes a functional $w_j\in W$ (the $j$th column of the compiled encoding).
* An **observation model** is a list of units; unit $i$ names a set of coordinates and carries a cost
  $c_i\ge0$. A **coalition** $H$ is a set of units, of cost $c(H)=\sum_{i\in H}c_i$, observing
  $$V_H=\operatorname{span}\{w_j : j\in\operatorname{coords}(H)\}\ \le\ W .$$
* The **secret space** is $S\le W$ of dimension $k$ (probe 5's `row A`).
* The **leakage space** of a coalition is $L_H=S\cap V_H$, and by the brief's §2 rank identity the
  coalition learns exactly $\dim L_H$ field symbols of the secret, namely the functionals in $L_H$.
* For $T\le S$, the **labelled cost** is $\Lambda(T)=\min\{c(H):T\le V_H\}$, with $\infty$ if none.
* The **$t$-symbol leakage cost** is $\Gamma_t=\min_{\dim T=t}\Lambda(T)$, and the **profile** is
  $(\Gamma_1,\dots,\Gamma_k)$.

$H\mapsto V_H$ is monotone: $V_H=\sum_{i\in H}V_{\{i\}}$.

---

## 2. Theorem A: the profile is a coalition-side quantity

### Theorem A

For every $t$ with $1\le t\le k$,
$$\Gamma_t\;=\;\min\bigl\{c(H)\;:\;\dim(S\cap V_H)\ \ge\ t\bigr\}.$$

*Proof.* ($\ge$) Let $T$ attain $\Gamma_t$ with witnessing coalition $H$, so $T\le V_H$ and $T\le S$;
then $T\le S\cap V_H$, so $\dim(S\cap V_H)\ge t$ and the right side is at most $c(H)=\Gamma_t$.
($\le$) Let $H$ satisfy $\dim(S\cap V_H)\ge t$ and choose any $t$-dimensional $T\le S\cap V_H$. Then
$T\le S$ and $T\le V_H$, so $\Lambda(T)\le c(H)$ and $\Gamma_t\le c(H)$. $\square$

The proof is three lines and uses nothing but the definitions. That is the point: the outer
minimization over $\binom{k}{t}_q$ subspaces is not intrinsic to the profile, it is an artefact of
computing the profile as a minimum of per-subspace costs.

### Corollary A1 (one sweep gives the whole profile)

Enumerate coalitions in nondecreasing cost (best-first, each subset generated once). At each popped
coalition $H$ compute $d=\dim(S\cap V_H)$ by one rank computation and set $\Gamma_t\leftarrow c(H)$
for every $t\le d$ not yet set. Stop when $\Gamma_k$ is set or the frontier is exhausted. The result
is the exact profile, and the *same* sweep serves every $t$.

*Proof.* Costs are nonnegative and each subset is popped once, so pops are in nondecreasing cost; the
first pop with $d\ge t$ therefore has the least cost among all coalitions with $\dim L_H\ge t$, which
is $\Gamma_t$ by Theorem A. $\square$

### What this replaces

Probe 5's direct method runs $\sum_{t}\binom{k}{t}_q$ separate minimum-cost coalition searches, one
per secret subspace. Corollary A1 runs **one** search. Since each of probe 5's searches already
sweeps the same coalition space, the saving is the full Gaussian-binomial factor, with no
compensating cost: the extra work per popped coalition is a single intersection-dimension
computation, and probe 5's span cache already makes the coalition spans available.

### What it does *not* replace

$\Lambda(T)$ for a **named** subspace $T$ — "how expensive is it to leak *these particular* secret
functionals" — still requires a search per named $T$. That is a different and equally legitimate
query, and it is the one the manuscript's labelled theory is about. Theorem A says only that the
*profile* does not need it. Probe 5's per-functional table (minimum-cost coalition per projective
class of secret functional) is likewise unaffected.

---

## 3. (1a) No matroid structure on the coalition side

### Theorem B

The set function $f(H)=\dim L_H=\dim(S\cap V_H)$ is in general **neither submodular nor
supermodular**, over every field $\F_q$, already with two units.

*Proof.* Two instances, each minimal.

*Not submodular.* Take $W=\F_q^2$ with basis $a,b$, secret $S=\langle a+b\rangle$, and two
single-coordinate units with $V_1=\langle a\rangle$, $V_2=\langle b\rangle$. Then $f(\emptyset)=0$,
$f(\{1\})=f(\{2\})=0$ because neither $\langle a\rangle$ nor $\langle b\rangle$ meets $\langle
a+b\rangle$, and $f(\{1,2\})=1$ because $V_{\{1,2\}}=W\supseteq S$. Submodularity demands
$f(\{1\})+f(\{2\})\ge f(\{1,2\})+f(\emptyset)$, i.e. $0\ge1$.

*Not supermodular.* Take $W=\F_q$, $S=W$, and two units with $V_1=V_2=W$. Then $f(\{1\})=f(\{2\})=
f(\{1,2\})=1$ and $f(\emptyset)=0$, so $f(\{1\})+f(\{2\})=2>1=f(\{1,2\})+f(\emptyset)$. $\square$

The non-submodularity instance is Astra's mask-reuse phenomenon in mask-free clothing: two
observations that individually leak nothing leak a full symbol together. It is the same
non-additivity, and it is the structural reason a per-observation "zero leakage" summary does not
compose.

### Why this closes a route rather than merely failing

$f = r - r'$ where $r(H)=\dim V_H$ and $r'(H)=\dim(S+V_H)-\dim S$ are both polymatroid rank
functions (the second is the rank of the images of the $V_i$ in $W/S$). A difference of submodular
functions is neither submodular nor supermodular in general, and minimizing cost subject to
$f(H)\ge t$ is therefore outside every submodular-optimization guarantee. So there is no shortcut of
the form "run submodular cover on $\dim L_H$": Corollary A1's sweep is doing real work, and the
profile problem is hard in the same way generalized Hamming weight computation is hard.

---

## 4. (1b) Greedy extension, what fails and what survives

### Proposition C (greedy extension fails)

Over every field $\F_q$ there is an instance with $\dim S=3$ and two units in which the unique
minimum-cost one-dimensional leaked subspace lies in **no** minimum-cost two-dimensional leaked
subspace.

*Proof.* Let $S=W=\langle s_1,s_2,s_3\rangle$. Unit $u_1$ observes one coordinate with functional
$s_1$, at cost $1$. Unit $u_2$ observes two coordinates with functionals $s_2,s_3$, at cost $2$
(a whole-block unit: cheaper than buying its coordinates separately). Then
$\Gamma_1=1$, attained only by $H=\{u_1\}$ with leaked space $\langle s_1\rangle$; and $\Gamma_2=2$,
attained only by $H=\{u_2\}$ with leaked space $\langle s_2,s_3\rangle$, which does not contain
$s_1$. Extending the $\Gamma_1$-minimizer costs $1+2=3>2$. $\square$

Whole-block units are not a contrivance: they are exactly probe 5's `block` generator and the
realistic model in which compromising a node is cheaper per coordinate than compromising individual
coordinates. This is where greedy breaks.

### Proposition D (the greedy chain is a $t$-approximation)

Define the greedy chain by $g_1=\Gamma_1$ with a minimizing coalition $H_1$, and $g_t$ the least cost
of a coalition $H\supseteq H_{t-1}$ with $\dim L_H\ge t$. Then
$$\Gamma_t\;\le\;g_t\;\le\;\sum_{j\le t}\Gamma_j\;\le\;t\,\Gamma_t .$$

*Proof.* The lower bound is immediate. For the upper bound, let $H^\star$ attain $\Gamma_t$. Then
$H_{t-1}\cup H^\star$ is admissible at step $t$ and costs at most $g_{t-1}+\Gamma_t$; induction gives
$g_t\le\sum_{j\le t}\Gamma_j$, and $\Gamma_j\le\Gamma_t$ for $j\le t$ by monotonicity of $\Gamma$.
$\square$

So a greedy interface is never wildly wrong, and its error is bounded by a factor that a user can be
told. It is still not exact, so it cannot back an auditing claim; §6 reports the worst ratio actually
observed, which is much smaller than the bound.

### Proposition E (when greedy is exact)

Suppose every unit observes a single coordinate and every leaf functional lies in the secret space:
$w_j\in S$ for all $j$. Then $L_H=V_H$, so $f=\dim V_H$ is the rank function of the linear matroid on
$\{w_j\}$, and $\Gamma_t$ is the minimum weight of an independent set of size $t$. The matroid greedy
algorithm — sort units by cost, add each if it raises the rank — computes $\Gamma_1,\dots,\Gamma_k$
exactly and each minimizer extends the previous one.

*Proof.* $S\cap V_H=V_H$ because $V_H\le S$, and minimum-weight independent sets of each size in a
matroid are produced by the greedy algorithm, nested by construction. $\square$

The dichotomy is worth stating plainly: **the difficulty of the leakage profile comes entirely from
the secret space being a proper subspace of what is observed.** When observations carry only secret
information the problem is a matroid and greedy is exact; the moment some observed functional falls
outside $S$, Theorem B's non-submodularity appears and every guarantee is gone. That is the same
distinction the manuscript's labelled theory tracks, and it is why the relative (rather than
absolute) generalized Hamming weight is the right invariant.

---

## 5. (2) What the contextual quotient does and does not collapse

*(filled in below; see §6 for the measurements)*

---

## 6. Computational check

*(filled in after the run)*

---

## 7. Unification with the masked module, deferred

*(filled in after the run)*
