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

**Correction (2026-09-06, probe 10).** The uniform-cost measurement in this report — zero
optimal-chain failures in 1,434,264 instances — is a parameter artefact: those families priced a
coordinate at 2 and a block at 3, not `c ≡ 1`, and never exceeded ambient dimension 3. Probe 10
(`2026-09-06-c1070-probe10-uniform-cost-chain.md`) refutes the chain conjecture at `c ≡ 1` in both
versions, already with single-coordinate units, and identifies it with Wei's chain condition.
Theorem A, Proposition C, and the `t`-factor bound are unaffected.

| question | verdict |
|---|---|
| (1a) is $H\mapsto\dim L_H$ submodular? | **No** — and not supermodular either. Two-unit counterexamples in dimension at most two exist over every field (Theorem B). So no submodular-minimization or matroid machinery applies on the coalition side. |
| (1b) does greedy extension of a minimum-cost $(t-1)$-subspace reach a minimum-cost $t$-subspace? | **No in general** (Proposition C, a three-dimensional secret with two units, over every field), **but the counterexample needs heterogeneous unit costs**: an exhaustive search found zero failures in 1,434,264 uniform-cost instances and 504 failures only under graded costs (§4.1). What holds regardless: the greedy chain is a $t$-approximation, $\Gamma_t\le g_t\le\sum_{j\le t}\Gamma_j\le t\,\Gamma_t$ (Proposition D, tight at $t=2$), and it is exact when every observation is itself a secret functional and units are single coordinates (Proposition E). |
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

### 4.1 What the exhaustive search adds: greedy failure needs heterogeneous costs

Proposition C uses two units of *different* cost, and that turns out to be essential. The sweep of
§6 tested whether a chain of optimal subspaces $T_1<T_2<\dots<T_k$ exists, exhaustively, across
2,106,768 instances. It found:

* **Zero failures** in every family with uniform unit costs — 1,434,264 instances, covering single
  coordinate units alone and single units together with cheaper whole-block units. In that regime a
  "grow the subspace" strategy was always able to reach an optimum at every $t$.
* **504 failures**, all in the graded-cost family over $\F_2$ where coordinate $j$ costs $1+j$ and a
  whole block costs $3$. This is Proposition C's mechanism, and it needs a cheap coordinate lying
  outside a cheap block — which needs at least four leaves, which is why the graded families with
  three leaves show none.

So the refined answer to (1b) is: **an optimal subspace chain always existed when every unit of the
same kind costs the same, and failed only once unit costs are heterogeneous.** That is worth knowing,
because uniform per-node cost is the common auditing model. It is a measured statement over the exact
domain in §6.2, not a theorem; Proposition C shows the uniform-cost regularity cannot extend to
graded costs, and nothing here proves it for larger instances.

### 4.2 Chaining subspaces is safe more often than chaining coalitions

The two greedy notions are not the same and the measurements separate them. Committing to a
*coalition* and only extending it is strictly worse than committing to a *subspace*: the sweep found
the coalition-greedy chain reaching $4/3$ of the exact cost even in uniform-cost families where an
optimal subspace chain always existed, and reaching exactly $2\times$ in the graded family — which
attains Proposition D's bound $g_2\le\Gamma_1+\Gamma_2\le2\Gamma_2$ at $t=2$, so that bound is tight.
An incremental interface should therefore carry the leaked *subspace* forward, never the coalition.

---

## 5. (2) What the contextual quotient does and does not collapse

The answer has two halves and they point in different directions. Saying only the favourable half
would misrepresent the result.

### 5.1 Query time: the enumeration disappears, without needing the quotient

Theorem A already removes it. The compiled object that answers "minimum cost to leak $t$ symbols"
for all $t\le r$ is:

> the coalition frontier up to cost $r$, each coalition annotated with $\dim(S\cap V_H)$,
> reduced to the running minima $\Gamma_1,\dots,\Gamma_{\min(k,\ldots)}$.

Nothing in it is indexed by a secret subspace. It is produced by one sweep, it serves every $t$ at
once, and a query is a table lookup. The contextual quotient is not required for this and does not
improve it.

### 5.2 Compile time for the tower min–sum: the rank index survives

If instead the profile is to be computed compositionally through a tower — the manuscript's route,
rather than a flat sweep — then the state is the label-indexed cost function
$B\mapsto\mu_{I,P,T}(B)$ with $B\in\operatorname{Hom}(T,L^{*})$ and $\dim_{\F_q}T=t$. That index set
has $q^{t\dim L}$ elements per block, and it **grows with $t$**. So a compositional profile for all
$t\le r$ needs tables at every rank $1,\dots,r$:
$$\sum_{t\le r}q^{t\dim L}\;=\;\Theta\!\left(q^{r\dim L}\right)\ \text{labels per block.}$$

What the quotient contributes is real but narrower than "the enumeration disappears". The
manuscript's rank- and radius-bounded outer tests bound the witnessing context by length
$\max\{2,r+1\}$ and functional-dual dimension $\min\{t,r\}$. Since $\min\{t,r\}\le r$ for every
$t\le r$, **one compiled response vector at functional-dual dimension $\le r$ and context length
$\le\max\{2,r+1\}$ serves every $t\le r$ simultaneously** — there is no need to recompile the
contextual quotient once per $t$. That is the collapse the quotient gives, and it is on the *context*
axis, not the label-array axis.

So, stated plainly as the coordinator asked: **for the compositional route the enumeration moves to
compile time rather than disappearing.** The compiled tables are still indexed by rank-$t$ label
arrays.

### 5.3 Quantifying the trade

Comparing the two indexed families, for $r\le k/2$:

| object | size |
|---|---|
| secret subspaces enumerated at query time (direct method) | $\sum_{t\le r}\binom{k}{t}_q=\Theta(q^{r(k-r)})$ |
| compiled tower label arrays (compositional route) | $\Theta(q^{r\dim L})$ per block |
| coalition frontier (Theorem A route) | one sweep, no subspace index |

The compositional route beats the direct method's enumeration exactly when $\dim L<k-r$: a small
intermediate alphabet with a large secret space. On probe 5's own two-level $\F_3$ tower the
inequality goes the *other* way, and it is worth stating concretely because it is the case at hand:
the secret has $k=3$ over $q=3$ with a one-dimensional intermediate alphabet, so the direct method
enumerates $13+13+1=27$ subspaces while the compositional tables would carry
$3+9+27=39$ labels per block. The compiled tower state is larger than the enumeration it would
replace. Across all six of probe 5's committed inputs the direct method performs 37 subspace
searches in total; Theorem A's sweep performs none, on any of them.

The practical reading: **use Theorem A's coalition sweep for the profile.** The compositional route
earns its keep for the *named-subspace* query and for towers too large to flatten, not for the
profile.

---

## 6. Computational check

### 6.1 What is checked, and what the checker trusts

Two independent bodies of evidence, both deterministic; **no randomness is used anywhere**, so there
are no seeds to record.

**Cross-check against probe 5.** Each of probe 5's six committed `*.report.json` files under
`notes/data/2026-09-06-c1070-probe5/` is reloaded. Its compiled encoding (columns are leaf
functionals), secret basis, and unit list are rebuilt as a flat instance, and the profile is
recomputed by Theorem A's single coalition sweep. It must reproduce probe 5's committed
direct-method profile entry for entry. Probe 5's numbers were produced by a different module, by a
different method, and were themselves cross-checked there against a separate brute force — so this
is a three-way agreement, not a self-check.

**Exhaustive structure sweep.** Over a canonical enumerated family, each instance is measured for:
sweep against direct-method agreement; existence of a chain of optimal subspaces; submodularity and
supermodularity violations of $H\mapsto\dim L_H$ over all pairs of coalitions; and the coalition-greedy
ratio.

**Trusted boundary.** The checker trusts Gaussian elimination over `SmallField` (the core's finite
field type, so extension fields including $\mathrm{GF}(4)$ are handled) and probe 5's
`subspaces_of_dimension`, whose Gaussian-binomial counts probe 5 asserts in its own tests. It does
not trust Theorem A: `profile_direct` is a literal transcription of the definition
$\min_T\min\{c(H):T\le V_H\}$ and shares no code path with `profile_sweep` beyond the rank primitive.

**Scope.** Mask-free, uniform linear model, flat instances, small dimensions. It does not check
masked instances (probe 1's object), towers too large to flatten, or the compile-time claims of §5.2,
which are counting arguments rather than measurements.

### 6.2 Inputs

Named cases, over $q\in\{2,3,5\}$: Theorem B's non-submodular instance, and Proposition C's
greedy-extension counterexample.

Sweep families. Each fixes an ambient dimension and leaf count, then enumerates **every** assignment
of leaf functionals over $\F_q$ in odometer order, crossed with **every** subspace of the ambient
space as the secret, crossed with three observation shapes:

| family | field | ambient $n$ | leaves | secrets |
|---|---|---|---|---|
| `f2-amb3-leaf4` | $\F_2$ | 3 | 4 | all 15 subspaces of $\F_2^3$ |
| `f3-amb3-leaf3` | $\F_3$ | 3 | 3 | all 27 subspaces of $\F_3^3$ |
| `f5-amb2-leaf3` | $\F_5$ | 2 | 3 | all 7 subspaces of $\F_5^2$ |

Observation shapes: `single-coordinate-units` (one unit per coordinate, cost 2);
`single-and-whole-block-units` (the same, plus disjoint consecutive coordinate pairs as units at
cost 3, so a block is cheaper than its coordinates); `graded-single-and-whole-block-units`
(coordinate $j$ costs $1+j$, blocks cost 3).

### 6.3 Results

| claim | measured |
|---|---|
| Theorem A: sweep profile equals direct-method profile | **2,106,768 / 2,106,768** sweep instances, and **6 / 6** of probe 5's committed reports, including the $\mathrm{GF}(4)$ tower. No exception. |
| subspace searches the sweep replaces on probe 5's inputs | **37**, reduced to **0** |
| $\dim L_H$ submodular? | **no** — 1,245,510 instances contain a violating pair |
| $\dim L_H$ supermodular? | **no** — 1,397,653 instances contain a violating pair |
| both fail in the same instance | 992,994 instances, about 47% of the family |
| optimal subspace chain exists? | **504 failures out of 1,478,553** chain-testable instances; **all 504** in the graded-cost $\F_2$ family, **zero** in every uniform-cost family |
| worst coalition-greedy ratio | **200%** (graded costs), **133%** (uniform costs with whole-block units), **100%** (single-coordinate units only) |

Named-case values, identical across $q\in\{2,3,5\}$:

| case | profile $(\Gamma_t)$ | coalition-greedy chain | optimal subspace chain | submodularity violations |
|---|---|---|---|---|
| Theorem B, non-submodular | $(2)$ | $(2)$ | exists | 1 |
| Proposition C, greedy extension | $(1,2,3)$ | $(1,3,3)$ | **does not exist** | 0 |

Proposition C's row is the counterexample in machine-checked form: the exact two-symbol cost is $2$
and greedy extension of the unique one-symbol optimum costs $3$.

The `100%` entry for single-coordinate uniform-cost units says the coalition-greedy chain was exact
throughout that sub-family. That is a measurement over the domain in §6.2, not a theorem, and
Proposition E covers only the special case where every leaf functional lies in the secret space.

### 6.4 Replay, hashes, and independent cross-check

Working directory `~/src/ergodis-private`; toolchain `rustc 1.93.1 (01f6ddf75 2026-02-11)`; core
checkout `~/src/ergodis` at `6cc9668`; private checkout at `b26e0d0`. Regenerate:

```
cd ~/src/ergodis-private
cargo build --release -p ergodis-tools
~/.cache/ergodis/target/ergodis-private/release/ergodis-tools leakage-structure-report \
  --probe5 ~/src/othello/notes/data/2026-09-06-c1070-probe5 \
  --out ~/src/othello/notes/2026-09-06-c1070-probe2-leakage-profile-from-quotient.json
```

Append `--check` to the same command to verify the tracked certificate without writing to the
worktree. Runtime is about 40 seconds. The `--probe5` directory is a load-bearing input: the
cross-check reads the six committed `*.report.json` files there, whose hashes are recorded in that
directory's own `SHA256SUMS`.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `ergodis-private/src/leakage_structure.rs` | 13271 | `b55d9ab4248f1902b71644731d19318d360c9a7c8b836083cce5efd49372cf2c` |
| `ergodis-private/tasks/tools/src/leakage_structure_report.rs` | 18310 | `62df5f37fda2cd23644fde20808eeef2604f51101b2b2d6b50b089d9f05f75cd` |
| `notes/2026-09-06-c1070-probe2-leakage-profile-from-quotient.json` | 8669 | `0984301550364fdf840a27a5db87f6448c35c72f2129e24e3551d0f6b1aa0060` |

**Independent cross-check.** Probe 5's committed reports are the independent reference
implementation: a different module, a different algorithm (per-subspace best-first coalition search),
already validated there against its own separate brute force. Agreement on all six, including a
non-prime field, is therefore genuinely independent. Within this probe, `profile_direct` and
`profile_sweep` are separate transcriptions of separate definitions.

**Negatives, with their domain.** No sweep-against-direct disagreement was found in any of the
2,106,768 instances; no optimal-chain failure was found in any of the 1,434,264 uniform-cost
instances. The search domain is exactly the family tabulated in §6.2 and the stop condition is
exhaustion of that family. Nothing here bounds behaviour at larger ambient dimensions, more leaves,
other cost structures, or masked instances.

---

## 7. Unification with the masked module, deferred

`hierarchical_leakage` (probe 5, mask-free, full interface), `leakage_structure` (this probe,
mask-free, flat, structural) and `masked_leakage` (probe 1, masked, tower composition) are three
views of one object and are deliberately left separate for now. A unification would look like this,
and it is a small piece of work once someone owns it.

1. **One instance type.** Probe 1's Proposition 1 says the masked theory is the mask-free theory over
   the enlarged message space with the request pinned to zero on the mask coordinates. So a single
   `FlatInstance` gains one field — the number of trailing ambient coordinates that are masks — and
   every mask-free routine works unchanged by pinning those coordinates to zero in the target. No
   separate masked code path is needed at the flat level.
2. **Leakage under masks is still $S\cap V_H$, computed in the enlarged space.** The brief's §7
   leakage space $\{u^{\mathsf T}A:u^{\mathsf T}B=0\}$ is exactly $S\cap V_H$ once the mask
   coordinates are adjoined to the ambient space and the secret space is taken to be the functionals
   vanishing on them. Theorem A therefore transfers verbatim to the masked profile: **the masked
   $t$-symbol profile is also computable by one coalition sweep.** That is a free corollary and the
   most valuable single thing a unification would buy.
3. **Freshness stays a compile-time obligation.** Probe 1's Lemma 5 shows that assuming independent
   masks when randomness is shared overstates privacy. A unified instance type must therefore carry
   randomness *scopes*, not a per-block "fresh" flag, and promote shared scopes as probe 1 describes.
4. **What must not be merged.** Probe 1's `masked_leakage` also drives the core's composition kernel
   for the *tower* min–sum, which is a different computation from the flat sweep and is the thing §5.2
   is about. That should stay its own module; only the instance type and the flat leakage primitives
   should be shared.

This is recorded, not done: merging now would rewrite two modules that are each independently
validated against committed evidence, and neither probe 1's nor probe 5's results depend on it.

---

## 8. Mystery ledger

Written after an explicit extra-juice and Tao-style closeout pass.

| observation | status |
|---|---|
| Theorem A is three lines, yet probe 5 — and the brief's own probe plan — assumed the profile needed a Gaussian-binomial enumeration. | **Settled, and it is the probe's main result.** The confusion is between two queries that look alike: the cost of a *named* subspace, which genuinely needs the subspace, and the *profile*, which is a coalition-side rank threshold. Only the first needs enumeration. |
| An optimal subspace chain always existed under uniform unit costs (1,434,264 instances, no exception), even though $\dim L_H$ is not submodular and Proposition C shows chains can fail. | **Open, and it is the sharpest remaining question.** The measured regularity is strong enough to be worth a proof attempt: is a chain of optimal subspaces guaranteed when all units of a given kind share a cost? A proof would give an exact incremental algorithm for the common auditing model. Domain of the evidence is §6.2; no owner allocated, and it is a candidate successor task rather than something this probe can close. |
| The coalition-greedy chain hits exactly $200\%$, matching Proposition D's bound $g_2\le\Gamma_1+\Gamma_2\le2\Gamma_2$. | **Settled**: the factor-2 bound at $t=2$ is tight, so Proposition D cannot be improved at that rank without further hypotheses. |
| On probe 5's own $\F_3$ tower the compiled tower state (39 labels per block) is *larger* than the subspace enumeration it would replace (27 subspaces). | **Settled and reported in §5.3.** The compositional route is not a universal win for the profile; it wins when $\dim L<k-r$. This is why §5 gives the split answer rather than a favourable one. |
| $\dim L_H$ fails submodularity and supermodularity in about 47% of instances — a very high rate for a "generic" failure. | **Settled as expected**, not a mystery: $\dim L_H=r-r'$ is a difference of two polymatroid ranks, and differences of submodular functions fail both inequalities generically. The measurement confirms the algebra rather than revealing anything new. |

No other genuine mystery remains. The one open item — whether uniform costs force an optimal chain —
is stated above with its exact evidence gap.
