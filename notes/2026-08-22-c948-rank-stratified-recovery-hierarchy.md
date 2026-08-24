# C948 — Rank-stratified recovery and relative-weight confinement

**Lane**: complete-ports

**Status**: IN PROGRESS; CORE THEOREMS, EJ UPGRADES, BOUNDED LITERATURE AUDIT WITH 24 JULY--24 AUGUST 2026 DELTA SCREEN, PRELIMINARY BGS PACKING-BRIDGE VET, AND POST-CLOSURE PUBLICATION PLAN RECORDED; INDEPENDENT COLD READ AND FULL-TEXT NOVELTY CLOSURE PENDING

## Scope

This is a math-only successor to C946 and C947. It does not authorize edits to
the manuscript, bibliography, README, Lean boundary, or public mirror.

## Post-closure publication and research plan

No successor task IDs are allocated by this report. Allocation occurs only
after the C948 closure verdict fixes which claims survive and which paper shape
they support.

### Phase A — close C948 before restructuring anything

1. Run the claim-specific priority closure for the canonical helper pair,
   exact RGHW cost identity, additive confinement threshold, best-target GHW
   identity, rigidity statement, projective-simplex application, and
   coefficient-presentation separation. Promote the nearest partial reads to
   full-text reads where possible and record the remaining database and
   forward-citation limits literally.
2. Obtain independent referee-style reads of the complete human theorem
   packet. The audit must separately check definitions and quantifiers,
   off-by-one conventions, C946 dependence, MDS equality hypotheses,
   projective reliability inversion, and the forced-padding reliability
   separation.
3. Reconcile every surviving theorem with C946 and the current paper's scalar
   rank-one theorem. Produce one frozen claim ledger distinguishing classical
   input, new theorem, corollary, example, computational evidence, and open
   conjecture.
4. Run the required final EJ and TT pass, settle or assign every mystery below,
   and issue a binary packaging verdict:
   **flagship rebuild**, **separate sequel**, or **retain the current paper and
   defer C948**.

The preferred verdict, conditional on clean closure, is **flagship rebuild**.
The fallback is deliberately conservative: if priority or proof audit weakens
the rank-stratified spine, preserve the already verified single-coordinate
paper and package C948 as a sequel rather than forcing a merger.

### Phase B — primary paper if C948 closes cleanly

Working title:

> *Exact Transfer of Bounded Linear Recovery and Relative Weight Hierarchies*

The paper should be rebuilt around one dependency chain rather than enlarged
by insertion:

1. normalized recovery equations, exact helper supports, recovery-set upward
   closure, and stochastic repair as distinct forgetful layers;
2. the canonical nested helper pair and its exact sequence;
3. the identification of rank-\(t\) helper cost with relative generalized
   Hamming weight;
4. the sharp eventual confinement threshold and exact coefficient-aware
   transfer;
5. the best-target GHW identity, cooperative-locality min--max corollary, and
   MDS rigidity;
6. positive-density realization, with the bounded service-rate polytope as a
   short exact-transfer corollary;
7. stochastic and coefficient-presentation separations beyond the complete
   RGHW hierarchy;
8. the projective-simplex family as the main non-MDS geometric application;
9. a compact formal-verification and provenance appendix.

The current paper supplies reusable proofs and examples, but its table of
contents is not binding. Retain the exact transfer theorem, positive-density
realization, the represented \([10,4,6]\) separation, only the pointed-Tutte
material needed by that separation, compact MDS reconstruction, and one
geometric flagship. Compress or move extended EXIT, deletion--contraction,
secondary geometric inventories, and competing examples unless a referee read
shows that they are necessary to the main chain. Aim for one coherent
approximately 24--28 page paper, not a survey of every consequence.

This phase requires newly allocated tasks after C948 closes: manuscript
architecture, theorem/formal-boundary closure, manuscript reconstruction,
and aggregate referee/export review. Their exact IDs and order belong in the
queue at that time.

### Phase C — disjoint-recovery successor, separately gated

The BGS material is connected but is not part of the primary paper. It studies
capacity-one packing of many exact recovery witnesses, whereas C948 studies
minimum helper unions for recovery systems whose witnesses may share helpers.
The exact recovery fibers supplied by the primary paper are the correct input
object; adding a disjointness constraint produces the packing fibers relevant
to the additive matching problem.

Only after the four-hole proof is rebuilt with fixed global conventions should
a second paper be queued, provisionally titled

> *Prescribed Differences in Additive 1-Factorizations: Profile Saturation and
> Four Holes*.

Its minimal spine is:

1. the additive 1-factorization and exact coding convention;
2. the proved profile-lattice theorem;
3. the correctly restricted semigroup slice and hafnian support formulation;
4. complementary Walsh minors and deleted-character coefficient lemmas;
5. the fully signed unrestricted four-hole theorem;
6. the disjoint-recovery corollary.

Do not queue a six-hole paper until the compressed-pairing multiplicities,
six-boundary transforms, and global signs are independently proved. If those
close, a third paper may develop the deleted-Walsh-minor/exterior-degree
hierarchy. Fixed-hole progress must not be advertised as a route to full BGS
without an additional growing-hole, recursive, or global saturation theorem.

### Allocation rule after C948

When C948 closes, allocate successors in this order:

1. the primary-paper architecture/rebuild task, if the flagship verdict wins;
2. its formalization and independent referee gates;
3. the fixed-convention four-hole proof audit;
4. the BGS paper task only if that audit proves the theorem;
5. six-hole work only after Paper II is stable.

This order protects the nearly mature coding-theory result from being delayed
by the substantially higher-risk BGS program, while preserving the precise
conceptual bridge between them.

## Executive result

For an inner code (I) with target set (P) and helper set
(J=E\setminus P), write its generator matrix as
(G=(G_P\mid G_J)), and define

\[
 U_P=\operatorname{im}G_P,
 \qquad
 W_P=U_P\cap\operatorname{im}G_J,
 \qquad
 \ell=\dim W_P.
\]

The canonical nested helper pair is

\[
 K_P=\ker G_J,
 \qquad
 D_P=\{x\in\mathbb F_q^J:G_Jx\in U_P\}.
\]

It lies in the exact sequence

\[
 0\longrightarrow K_P\longrightarrow D_P
 \xrightarrow{\;G_J\;}W_P\longrightarrow0.
\]

The minimum union of helpers required to recover (t) independent
target-message dimensions is exactly the (t)-th relative generalized
Hamming weight

\[
 \boxed{\mu_t=M_t(D_P,K_P)}.
\]

Combining this identity with C946's objectwise exact confinement theorem gives
the eventual rank-(t) escape threshold

\[
 \boxed{\Gamma_t=M_t(D_P,K_P)+d(I^\perp)}.
\]

Thus, under C946's outer-family hypotheses, every radius-\\(r\\) recovery system
for every internally realizable rank-\\(t\\) demand is eventually confined to
its inner block if and only if

\[
 r<M_t(D_P,K_P)+d(I^\perp).
\]

Here (t) is **message rank**, not the dimension of an arbitrary target
coefficient presentation. Target-only dual relations have message rank zero
and helper cost zero.

## 1. Relative generalized weight identity

For a rank-(t) recovery system, discard target-kernel directions and
redundant equations. Its helper coefficient space becomes a (t)-dimensional
subspace (L\le D_P) satisfying (L\cap K_P=0). Its helper union is exactly
(\operatorname{supp}L). Conversely, every such (L) maps isomorphically to
a (t)-subspace of (W_P); choosing a target lift through (G_P) produces a
normalized recovery-equation system on the same helper union. Therefore

\[
 \mu_t
 =\min\{|\operatorname{supp}L|:
          L\le D_P,\ \dim L=t,\ L\cap K_P=0\}
 =M_t(D_P,K_P).
\]

In particular,

\[
 1\le M_1(D_P,K_P)<\cdots<M_\ell(D_P,K_P).
\]

The relative dimension/length profile has the direct recovery meaning

\[
 K_s(D_P,K_P)
 =\max_{|H|=s}
   \dim\bigl(W_P\cap\operatorname{span}G_H\bigr).
\]

It is the maximum number of independent target-message dimensions recoverable
from (s) helpers, and

\[
 M_t=\min\{s:K_s\ge t\}.
\]

## 2. Exact rank-stratified confinement

C946 proves objectwise that a presented demand of internal helper cost
(\rho) is eventually confined at radius (r) exactly when

\[
 r<\rho+d(I^\perp).
\]

Every rank-(t) demand has cost at least (M_t(D_P,K_P)), and some such
demand attains it. Applying the objectwise equivalence to all rank-(t)
demands therefore gives

\[
 \Gamma_t=M_t(D_P,K_P)+d(I^\perp).
\]

There is no hidden shift in this formula. The original paper's scalar
(z_x) counts total dual weight, including its target coordinate. For a
nondegenerate singleton target,

\[
 z_x=\Gamma_1+1.
\]

The positive-density transport corollary remains conditional on the final
closure of C946: at radius (M_t), all minimum rank-(t) systems are confined
because (M_t<M_t+d(I^\perp)), so their complete normalized coefficient
systems are copied on the positive-density inner-block coordinate classes.

## 3. Singleton bounds, MDS equality, and rigidity

Let (b=\operatorname{rank}G_J). Since

\[
 \dim D_P=|J|-b+\ell,
\]

the relative Singleton bound and the ordinary Singleton bound give

\[
 M_t(D_P,K_P)\le b-\ell+t,
 \qquad
 d(I^\perp)\le k+1.
\]

Consequently

\[
 \boxed{\Gamma_t
 \le b-\ell+t+d(I^\perp)
 \le2k-\ell+t+1.}
\]

If (I) is MDS, (P) consists of (p\le k) independent targets, and
(|J|\ge k), then (b=k), (\ell=p), the canonical pair is relative-MDS,
and

\[
 M_t=k-p+t,
 \qquad
 d(I^\perp)=k+1,
 \qquad
 \Gamma_t=2k-p+t+1.
\]

There is a useful rigidity upgrade. Because (M_{t+1}\ge M_t+1), equality at
rank one,

\[
 M_1=b-\ell+1,
\]

forces equality at every rank:

\[
 M_t=b-\ell+t\qquad(1\le t\le\ell).
\]

Hence equality in the global first threshold,

\[
 \Gamma_1=2k-\ell+2,
\]

forces (b=k), (d(I^\perp)=k+1), and relative-Singleton equality at every
rank. Thus (I) is MDS and the entire confinement staircase is determined:

\[
 \Gamma_t=2k-\ell+t+1.
\]

Optimal scalar confinement therefore locks the full simultaneous-recovery
hierarchy.

## 4. Universality and its priority boundary

Every nested pair (K\subsetneq D\subseteq\mathbb F_q^J) occurs as a
canonical recovery pair. Put (V=\mathbb F_q^J/K), let
(\pi:\mathbb F_q^J\to V) be the quotient map, and choose an isomorphism

\[
 \alpha:\mathbb F_q^\ell\longrightarrow D/K\subseteq V.
\]

The generator map

\[
 G(a,x)=\alpha(a)+\pi(x)
\]

has canonical pair (D_P=D), (K_P=K). Its dual is the graph code

\[
 I^\perp
 =\{(-\alpha^{-1}(x+K),x):x\in D\}.
\]

Thus every relative-weight hierarchy occurs as a recovery-rank hierarchy.
The quotient/graph realization and the information interpretation of relative
weights are standard nested-code and ramp-secret-sharing algebra; they are
not the priority claim. The paper-specific advance is the exact additive
escape threshold, complete coefficient-fiber transport, and positive-density
realization.

## 5. Same hierarchy, different reliability

Direct-sum reliability does not factor under an arbitrary total-radius bound.
The corrected construction uses forced padding. Start from two quotient-rank
one pairs with the same minimum recovery cost but different bounded
reliability at radius (r_0). Add identical one-dimensional padding pairs

\[
 0\subset\langle\mathbf 1_{L_i}\rangle
\]

having unique forced helper supports of sizes (L_i), and set

\[
 R=r_0+\sum_iL_i.
\]

Full-rank recovery must consume every padding support, leaving exactly the
base budget (r_0). Under uniform independent helper survival,

\[
 R_{\mathrm{full},R}(s)
 =s^{\sum_iL_i}R_{\mathrm{base},r_0}(s).
\]

The two systems retain identical complete relative-weight hierarchies but
different full-demand bounded reliability laws.

## 6. Projective-simplex non-MDS flagship

Let (A) contain one representative of every point of
(\mathrm{PG}(m-1,q)), so

\[
 N=\frac{q^m-1}{q-1},
\]

and define

\[
 I_m^\perp=\{(a,aA):a\in\mathbb F_q^m\}.
\]

The first (m) coordinates are targets and the (N) projective coordinates
are helpers. The helper code is the (q)-ary simplex code, so

\[
 M_t=\frac{q^m-q^{m-t}}{q-1}.
\]

Every nonzero simplex word has weight (q^{m-1}), while a nonzero target
vector has weight at least one. Therefore

\[
 d(I_m^\perp)=q^{m-1}+1
\]

and the exact nonconfinement thresholds are

\[
 \boxed{\Gamma_t
 =\frac{q^m-q^{m-t}}{q-1}+q^{m-1}+1.}
\]

This is an explicit infinite non-MDS family with a nonlinear confinement
staircase.

If (F\subseteq\mathrm{PG}(m-1,q)) is the failed helper set, then the
available recovery-equation space is the annihilator of
(\operatorname{span}F). Its dimension is

\[
 m-\operatorname{rank}(F).
\]

Consequently the probability of retaining at least (t) independent target
equations is

\[
 R_t(s)=
 \sum_{\substack{F\subseteq\mathrm{PG}(m-1,q)\\
                  \operatorname{rank}(F)\le m-t}}
 (1-s)^{|F|}s^{N-|F|}.
\]

This is a projective-geometry rank-distribution, hence a Tutte specialization.
Möbius inversion on the subspace lattice gives the closed expression

\[
 R_t(s)=
 \sum_{u=0}^{m-t}{m\brack u}_q
 \sum_{v=0}^{u}{u\brack v}_q
 (-1)^{u-v}q^{\binom{u-v}{2}}
 s^{N-N_v},
 \qquad
 N_v=\frac{q^v-1}{q-1}.
\]

The two reliability endpoints expose different parts of the geometry:

\[
 R_t(s)
 ={m\brack t}_q s^{M_t}+O(s^{M_t+1})
 \qquad(s\to0),
\]

because the minimum survivor sets are complements of codimension-(t)
projective subspaces, whereas

\[
 1-R_t(s)
 =B_{m,m-t+1}(1-s)^{m-t+1}
  +O((1-s)^{m-t+2})
 \qquad(s\to1),
\]

where

\[
 B_{m,r}
 ={m\brack r}_q
   \frac{|\mathrm{GL}(r,q)|}{r!(q-1)^r}
\]

is the number of unordered projective (r)-frames. Thus rare-survival
behavior is governed by (M_t), while rare-failure behavior is governed by
the complementary projective rank (m-t+1).

For fixed (N=(q^m-1)/(q-1)), averaging over nonzero linear functionals gives

\[
 M_1\le q^{m-1}.
\]

The projective-simplex helper system attains equality because every nonzero
functional misses a hyperplane and has exactly (q^{m-1}) nonzero helper
coefficients.

### Projective-simplex uniqueness theorem

Let (A) be any full-row-rank (m\times N) helper matrix over
(\mathbb F_q), where

\[
 N=\frac{q^m-1}{q-1}.
\]

Then

\[
 \min_{0\ne a\in\mathbb F_q^m}\operatorname{wt}(aA)
 \le q^{m-1}.
\]

Equality holds if and only if, up to column scaling and permutation, the
columns of (A) contain every point of (\mathrm{PG}(m-1,q)) exactly once.
Thus the projective-simplex helper system is the unique rank-one extremizer at
this helper budget.

For each nonzero helper column, the fraction of nonzero functionals not
vanishing on it is

\[
 \frac{q^{m-1}(q-1)}{q^m-1}.
\]

Averaging the weights of (aA) over (a\ne0) therefore gives at most
(q^{m-1}), with strict inequality if any helper column is zero. If the
minimum attains the average, every nonzero functional has weight exactly
(q^{m-1}). Projectivize the columns and let their multiplicities form a
vector (c). Every projective hyperplane then contains the same total
multiplicity

\[
 N-q^{m-1}=\frac{q^{m-1}-1}{q-1}.
\]

The point--hyperplane incidence matrix of projective space is square and its
Gram matrix has the form

\[
 (r-\lambda)I+\lambda J
\]

with (r>\lambda), hence is nonsingular over (\mathbb R). The constant
hyperplane-sum equations have the unique solution (c=\mathbf1), proving the
classification.

## 7. Coefficient presentation changes the escape barrier

The relative-weight hierarchy alone does not determine (d(I^\perp)), hence
does not determine the confinement thresholds. A smallest binary example uses

\[
 K=0,
 \qquad
 D=\langle u,v\rangle\le\mathbb F_2^3,
 \qquad
 u=100,
 \quad
 v=011.
\]

The three nonzero helper words have weights (1,2,3), so in both
presentations

\[
 (M_1,M_2)=(1,3).
\]

With the target identification

\[
 10\mapsto u,
 \qquad
 01\mapsto v,
 \qquad
 11\mapsto u+v,
\]

the three graph-code dual weights are (2,3,5), and
(d(I^\perp)=2). With

\[
 11\mapsto u,
 \qquad
 10\mapsto v,
 \qquad
 01\mapsto u+v,
\]

they are (3,3,4), and (d(I^\perp)=3). Thus the same nested helper pair,
the same helper supports, and the same complete RGHW hierarchy give different
threshold staircases:

\[
 (\Gamma_1,\Gamma_2)=(3,5)
 \quad\text{versus}\quad
 (4,6).
\]

This is a sharp coefficient-aware separation: internal rank recoverability is
unchanged, but the target coefficient presentation changes the cheapest
cross-block escape.

## 8. Relative duality

Relative Wei duality for ((D_P,K_P)) and
((K_P^\perp,D_P^\perp)) supplies the complementary failure hierarchy. The
primal weights give the minimum helpers needed to reveal (t) target-message
dimensions; the dual weights give the complementary support thresholds for
remaining target ambiguity. The resulting object is naturally a two-sided
recoverability/ambiguity profile and provides the clean bridge to erasure
resilience, ramp secret sharing, and the two endpoint regimes of the EXIT
curve.

No new relative-duality theorem is claimed here. The new content is its exact
translation through the recovery pair and the additive concatenation escape
barrier.

## 9. Best-target dual-weight identity and cooperative-locality corollary

For a linear code (C\le\mathbb F_q^E), a target set (P\subseteq E) of
size (t), and (J=E\setminus P), define the full-coordinate recovery cost

\[
 \kappa_C(P)=\min |H|,
\]

where the minimum ranges over (H\subseteq J) for which there is a
(t)-dimensional subspace (L\le C^\perp), supported on (P\cup H), whose
restriction (L\to\mathbb F_q^P) is an isomorphism. Equivalently,
(\kappa_C(P)) is the minimum helper-union cost of a normalized identity
equation system recovering every coordinate in (P). Set it to infinity when
no such system exists.

### Theorem — generalized dual weights are exact best-target costs

For (1\le t\le\dim C^\perp),

\[
 \boxed{
 d_t(C^\perp)-t
 =\min_{\substack{P\subseteq E\\|P|=t}}\kappa_C(P).
 }
\]

For the lower bound, any normalized identity system spans a (t)-dimensional
dual subcode whose support is (P) together with its helper union. Hence

\[
 d_t(C^\perp)\le t+\kappa_C(P).
\]

Conversely, choose a (t)-dimensional subcode (L\le C^\perp) of support
size (d_t(C^\perp)). A generator matrix of (L) has an information set
(P\subseteq\operatorname{supp}L) of size (t). Projection onto (P) is an
isomorphism, and row normalization gives identity recovery equations using
exactly (operatorname{supp}L\setminus P). Thus

\[
 \kappa_C(P)\le d_t(C^\perp)-t.
\]

This theorem separates two quantifiers that the classical GHW suppresses:

- (d_t(C^\perp)-t) is the best target set's simultaneous helper cost;
- fixed-(P) recovery is measured by (kappa_C(P)), and, when the (t)
  target message dimensions are independent, by the canonical relative weight
  (M_t(D_P,K_P));
- worst-target cooperative locality is
  [
  r_t^{\mathrm{coop}}(C)
  =\max_{|P|=t}\kappa_C(P)
  ]
  whenever every (t)-set is recoverable.

In particular, if (C) has ((r,t))-cooperative locality and (t<d(C)), then

\[
 r\ge r_t^{\mathrm{coop}}(C)
 \ge \min_{|P|=t}\kappa_C(P)
 =d_t(C^\perp)-t.
\]

This recovers Abdel-Ghaffar--Weber's 2017 generalized-weight bound as an
immediate min--max corollary. Their proof supplies the first inequality for an
arbitrary erased set; the information-set converse above upgrades the global
lower bound to an exact best-target identity.

C946 then adds a new concatenation consequence. If
(\Gamma_C(P)) is the eventual first nonconfined helper-union cost for the
identity demand on (P), its objectwise theorem gives

\[
 \Gamma_C(P)=\kappa_C(P)+d(C^\perp).
\]

Minimizing over all (t)-targets yields the global escape envelope

\[
 \boxed{
 \min_{|P|=t}\Gamma_C(P)
 =d_t(C^\perp)-t+d(C^\perp).
 }
\]

Thus the ordinary dual weight hierarchy governs the earliest possible escape
somewhere, the fixed-target relative hierarchy governs escape at a prescribed
target set, and the complete coefficient systems govern what is actually
transported.

### EJ consequences — target heterogeneity and MDS collapse

For (t<d(C)), define the target-cost distribution

\[
 B_{t,h}(C)
 =\#\{P\subseteq E:|P|=t,\ \kappa_C(P)=h\}.
\]

Its two endpoints are familiar invariants:

\[
 \min\{h:B_{t,h}\ne0\}=d_t(C^\perp)-t,
 \qquad
 \max\{h:B_{t,h}\ne0\}=r_t^{\mathrm{coop}}(C).
\]

Thus the dual GHW is the best-target endpoint, cooperative locality is the
worst-target endpoint, and the distribution between them measures recovery
heterogeneity discarded by both. The nonnegative gap

\[
 \mathfrak a_t(C)
 =r_t^{\mathrm{coop}}(C)-d_t(C^\perp)+t
\]

is zero exactly when every (t)-target set has the globally minimum helper
cost. This is useful diagnostic notation for the report, not yet proposed as a
new branded invariant.

For an ([n,k]) MDS code and (1\le t<d(C)=n-k+1), every (t)-target set has

\[
 \kappa_C(P)=k.
\]

Indeed, any (k) surviving coordinates reconstruct the codeword, while fewer
than (k) helper columns cannot span even one omitted target column because
every set of at most (k) generator columns is independent. Equivalently,

\[
 d_t(C^\perp)-t=(k+t)-t=k
\]

and the best and worst endpoints coincide. Consequently every full-(t)-target
identity demand has the same eventual escape threshold

\[
 \boxed{\Gamma_C(P)=2k+1,}
\]

independent of (t). Within a fixed (p)-target set, the partial-rank
thresholds still form the staircase (2k-p+t+1); only the top-rank full-(p)
demand collapses to the constant (2k+1). This cleanly separates partial
linear-demand recovery from complete coordinate-erasure recovery.

## 10. Computational sanity checks

Two exploratory checks were run while deriving the theorem packet:

- An explicit $[6,3]$ Reed--Solomon/Vandermonde inner example over
  $\\mathbb F_7$, with two targets, produced
  $$
  (M_1,M_2)=(2,3),
  \\qquad
  (\\Gamma_1,\\Gamma_2)=(6,7),
  $$
  exactly as predicted by the MDS formula.
- An exhaustive enumeration inside 1,244 sampled small binary canonical-pair
  cases verified strict growth of the computed relative-weight profiles and
  the relative-Singleton ceiling in every checked case.
- Direct subset enumeration for the binary projective systems with
  $m=2,3$, at survivor probability $s=0.37$, agreed with the subspace-lattice
  Möbius formula for every $1\le t\le m$. The five checked probabilities were
  $0.309394$, $0.050653$, $0.102865650445$, $0.012264172235$, and
  $0.000949318771$ in lexicographic $(m,t)$ order.
- The two binary coefficient presentations in Section 7 were checked directly:
  their nonzero dual-weight multisets are respectively $\{2,3,5\}$ and
  $\{3,3,4\}$.

These were derivation-time sanity checks, not paper-facing computational
evidence. Their ephemeral scripts and outputs are not a reproducibility bundle
and must not be cited as such. Any manuscript use requires the separate
research-reproducibility gate.

## 11. Literature and priority audit

**Read-depth summary:** Two sources were read at full text, ten primary sources
were read partially at the theorem/definition/positioning sections stated
below, and six additional recent primary records were read at
abstract/metadata depth. The priority verdict therefore remains a bounded,
targeted audit and supports only "to our knowledge" language.

### Sources and read depth

- **Partial:** Abdel-Ghaffar and Weber, *Bounds for Cooperative Locality Using
  Generalized Hamming Weights*, accepted-author manuscript of the 2017 ISIT
  paper. Read: introduction; Section II, Lemma 2 and Definition 2; Section III,
  GHW definition and Theorem 1 with proof; conclusion. It proves
  (r\ge d_e(C^\perp)-e) for ((r,e))-cooperative locality, but neither an
  exact fixed-target relative-weight identity nor concatenation confinement.
  Cache key `10.1109/ISIT.2017.8006618`; SHA-256
  `acae6904b1b9865754a15c44d7572965b6a313fc9a6d78510c196ca022fe4433`.
- **Partial:** Geil--Martin--Matsumoto--Ruano--Luo, *Relative generalized
  Hamming weights of one-point algebraic geometric codes*, cached arXiv
  preprint. Read: the information-threshold discussion preceding Definition 4,
  Definition 4, and Section 3's MDS/Singleton/duality discussion. These establish
  the classical RGHW and ramp-secret-sharing inputs, not the recovery-pair or
  transfer theorem. Cache key `arXiv:1403.7985`; SHA-256
  `25e31e23e4238ae33a08b4730c558fe071861a87c6e4fc0e1161d4bbcda581e7`.
- **Partial:** San-José, *An algorithm for computing generalized Hamming weights
  and the Sage package GHWs*, cached arXiv preprint. Read: introduction and
  Section 2 through Theorem 2.8, covering GHW/RGHW definitions, strict
  hierarchy, Singleton bounds, duality, and the package's problem boundary.
  Cache key `arXiv:2503.17764`; SHA-256
  `98bebce176b7f711a90f6a2ba0224dd77e4883eb0939c8aca237d571e9d1654b`.
- **Partial:** Prakash--Lalitha--Kumar, *Codes with Locality for Two Erasures*,
  cached arXiv preprint. Read: abstract, introduction, Section II's GHW setup,
  and Section III's definition and result outline. It treats sequential two-
  erasure repair and uses GHWs of a local dual subcode for global distance
  bounds; it does not give the simultaneous fixed-target RGHW or confinement
  theorem. Cache key `arXiv:1401.2422`; SHA-256
  `8596f44adaa5891b774835700717cf8873701e53c15194b70d14724ddeac6d0d`.
- **Partial:** Márquez-Corbella--Martínez-Moro--Munuera, *Computing sharp
  recovery structures for Locally Recoverable codes*, cached arXiv preprint.
  Read: introduction and Section 2 through Proposition 1. It establishes the
  standard single-coordinate recovery-set/recovery-structure language and its
  dual-support characterization, but retains neither multi-target ranks nor
  normalized coefficient fibers. Cache key `arXiv:1907.05316`; SHA-256
  `a9060ca8f7901885f1e077076c73dd7d03f8ae995a2232e891ce74c39e4ea927`.
- **Partial:** Jin--Fu, *Constructions of Locally Repairable Codes via
  Concatenated Codes*, arXiv v1 of 6 May 2026. Read: abstract/introduction,
  Section 2's concatenation/locality definitions, Section 3's scope and
  Construction 3.2. It fixes the binary ([3,2,2]) inner code and chooses
  outer (mathbb F_4)-codes for parameter-optimal binary LRCs; it does not
  study exact dual-equation confinement for a general represented inner code.
  Cache key `arXiv:2605.04618`; SHA-256
  `69847fc4ed1ada75f615ab8d2b2c08484da31253d278f9485cd03f5ab9587d93`.
- **Partial:** Gruica--Jany--Ravagnani, *LRCs: Duality, LP Bounds, and Field
  Size*, cached arXiv preprint. Read: abstract/introduction, Section 2's locality
  definitions, and Section 3 through Definition 3.2 and the MacWilliams-type
  framing. Its coordinate-refined weight counts and LP do not use the canonical
  nested recovery pair or exact concatenation sum. Cache key
  `arXiv:2309.03676`; SHA-256
  `1b941cf8445e40039a988ea0124e15fd94f0bbeb278205ec7bf934bf3e9a71a3`.
- **Partial:** Li--Wei--Xiong, *Moment-based linear programming bounds for
  locally recoverable codes*, arXiv v1 of 6 August 2026. Read: abstract and
  introduction through the paper organization and LP comparison. It confirms
  that generic LRC LP bounds are a crowded lane and does not state an RGHW
  confinement theorem. Cache key `arXiv:2608.05758`; SHA-256
  `0d85f3fc514ccda6b001e639960cc22212cdfe1e8b164930229fde9c1e63d713`.
- **Partial:** Geil, *Considerate ramp secret sharing*, Springer version of
  record, published 16 February 2026. Read on the official HTML page: abstract,
  introduction, Section 2's Theorem 1, Definition 6, and conclusion. It confirms
  that nested-pair information recovery and RGHW access thresholds are standard;
  it does not discuss local recovery equations or concatenation confinement.
  DOI `10.1007/s10623-026-01808-y`; no PDF was cached.
- **Partial:** Choudhary--Yadav--Bhaintwal, *Maximal achievable service rates
  of some classes of linear codes*, arXiv v1 of 6 August 2026. Read: abstract,
  introduction, Section II through Definitions 1--3 and Proposition 1, and
  Section III through Theorem 4. It defines the service-rate region as the
  fractional capacity polytope of a chosen recovery-set system, reduces to
  minimal recovery sets, and derives design-based service-rate bounds from
  dual supports. It neither retains normalized recovery coefficients nor
  transports a recovery system through concatenation. Cache key
  `arXiv:2608.05657`; SHA-256
  `924083acbe565988992ce323ce81d56a4d9099906de6b5df029fc2b88690e1c1`.
- **Full text:** Stylianou--Ramkumar--Boche--Bitar, *CSS Quantum LRCs with
  Intersecting Recovery Sets: Constructions and Bounds*, arXiv v1 of 11 August
  2026. Read in full from the cached six-page preprint. It studies quantum
  ((r,t,x))-locality, common classical recovery sets, subset-inclusion
  constructions, and parameter bounds. Its recovery-set overlap statistics do
  not contain the fixed-target RGHW hierarchy, normalized coefficient fibers,
  or concatenation confinement. Cache key `arXiv:2608.10912`; SHA-256
  `87346f1756fc21cc69c420701e8daf9ad27343343ed0722922e55d35538b594d`.
- **Full text:** Stylianou--Boche, *Bounds for Pure Disjoint
  ((r,delta))-Quantum Locally Recoverable Codes*, arXiv v1 of 11 August 2026.
  Read in full from the cached six-page preprint. It introduces blockwise
  quantum weight enumerators and LP/Singleton-like bounds for a partition into
  disjoint recovery blocks. Here "disjoint" describes blocks that are equal or
  disjoint, not capacity-one packing of classical recovery witnesses, and the
  paper does not touch C948's exact relative-weight/confinement theorem. Cache
  key `arXiv:2608.10922`; SHA-256
  `170052f4c33c89b32fae3b77019236deaf7c9c13ceeaa7984d2b5d430f4bbdbb`.
- **Abstract/metadata only:** Garnier--Lavauzelle--Nardi--Zappatore, *New
  perspectives for code locality in the rank metric*, arXiv v1 of 27 July
  2026, official arXiv abstract record `arXiv:2607.24295`. It develops a
  basis-free rank-metric locality notion and Singleton-like bounds, not the
  Hamming-metric exact recovery-equation transfer considered here.
- **Abstract/metadata only:** the official arXiv records for Matsumoto,
  *Information locality of a quantum locally recoverable code*
  (`arXiv:2608.04403`, 5 August); Li--Ling--Lu--Luo--Zhu,
  *Entanglement-Assisted Quantum Locally Recoverable Codes:
  Characterizations, Bounds, and Constructions* (`arXiv:2607.27091`, 29 July);
  Kumar--Bandi, *Entanglement-Assisted Quantum Locally Recoverable Codes:
  Bounds, Optimal Constructions, and Achievability* (`arXiv:2608.06854`,
  7 August); and Kshirsagar--Matthews--Shapiro,
  *Entanglement-assisted quantum locally recoverable codes: bounds and
  constructions with availability* (`arXiv:2608.09886` v2, 11 August); and
  Galindo--Hernando--Martín-Cruz--Matsumoto, *Entanglement assisted quantum
  ((r,delta))-locally recoverable codes* (`arXiv:2608.17118`, 17 August).
  These records concern quantum information locality, stabilizer/entanglement-
  assisted constructions, and parameter bounds. None states the classical
  canonical helper pair or exact concatenation threshold. Their full texts
  were not read, so this is only a scope screen, not a theorem-level dismissal.

### Search coverage

Load-bearing web queries were:

- `"relative generalized Hamming weights" "cooperative locality"`
- `"relative generalized Hamming weights" "recovery sets" code`
- `"relative generalized Hamming weight" "repair set" linear code`
- `"relative generalized Hamming weights" concatenated codes recovery`
- `"relative generalized Hamming weights" "concatenation" locality`
- `"generalized Hamming weights of concatenated codes"`
- `"weight hierarchy" concatenated codes linear`
- `concatenated codes "cooperative repair" inner code outer code`
- `concatenated locally recoverable codes "generalized Hamming weights"`
- `linear code concatenation "repair equations" inner block`
- `"recovery structure" concatenated codes locality`
- `"relative dimension/length profile" erasure recovery`

The web-search front end displayed respectively
(7,21,19,20,17,22,14,21) hits in the eight audit batches, or 141 displayed
records with duplicates retained. The screen covered displayed title, snippet,
URL/domain, and date. Its mechanical discriminator was: **promote a result if
its displayed record combines at least two of GHW/RGHW, cooperative or multiple-
erasure recovery, concatenation, recovery structures, or exact dual supports;
also promote every exact-title hit for a named near predecessor.** The result
pages were relevance screens, not exhaustively enumerated citing sets, and no
negative verdict rests on their reported total-result counts. Accordingly the
three-graph forward-citation rule was not triggered. Promoted exact-title and
exact-phrase hits received the source-level reads above.

### One-month delta screen: 24 July--24 August 2026

Because the current literature is moving unusually quickly, a separate dated
screen was run on 24 August 2026. Eight web-search batches displayed 81 records
with duplicates retained. The screen covered title, abstract/snippet,
identifier/URL, and displayed submission date. The literal queries were:

- `site:arxiv.org linear codes recovery structure generalized Hamming weights locality cooperative repair July 2026 August 2026`
- `site:arxiv.org locally recoverable codes concatenated recovery equations dual code July 2026 August 2026`
- `site:arxiv.org relative generalized Hamming weights locally recoverable codes July 2026 August 2026`
- `site:arxiv.org functional batch codes disjoint recovery simplex Hadamard July 2026 August 2026`
- `site:arxiv.org/abs/2607 locally repairable code`
- `site:arxiv.org/abs/2608 locally repairable code`
- `site:arxiv.org/abs/2607 generalized Hamming weights code recovery`
- `site:arxiv.org/abs/2608 generalized Hamming weights code recovery`
- `arXiv "locally recoverable codes" "2026" "Aug"`
- `arXiv "locally repairable codes" "August 2026"`
- `arXiv "cooperative locality" code "2026"`
- `arXiv "functional batch codes" "2026"`
- `arXiv Balister Gyori Schelp conjecture prescribed differences perfect matching 2026`
- `arXiv additive 1-factorization prescribed differences F_2 2026`
- `arXiv Walsh minors deleted characters perfect matching 2026`
- `arXiv Hadamard functional batch code simplex disjoint recovery August 2026`
- `site:arxiv.org/abs/2608 "recovery sets" codes`
- `site:arxiv.org/abs/2608 "recovery equations" codes`
- `site:arxiv.org/abs/2608 "generalized Hamming weight"`
- `site:arxiv.org/abs/2608 "relative generalized Hamming"`
- `site:arxiv.org/abs/2607 "recovery sets" code after July 23 2026`
- `site:arxiv.org/abs/2607 "locally recoverable codes" after July 23 2026`
- `site:arxiv.org/abs/2607 "functional batch" code`
- `site:arxiv.org/abs/2607 "generalized Hamming weights"`
- `site:arxiv.org/abs/2608 coding theory "repair" "recovery" linear code`
- `site:arxiv.org/abs/2608 coding theory "locality" "availability"`
- `site:arxiv.org/abs/2608 coding theory "batch codes" OR "PIR codes"`
- `site:arxiv.org/abs/2608 coding theory "weight hierarchy" OR "support distribution"`
- `site:arxiv.org/abs/2608 "nested linear codes"`
- `site:arxiv.org/abs/2608 "relative weights" coding`
- `site:arxiv.org/abs/2608 "ramp secret sharing" generalized Hamming`
- `site:arxiv.org/abs/2608 "support weights" linear codes locality`

The discriminator was: **promote every record in the date window whose title or
abstract combined coding theory with recovery sets, locality, service rate,
GHW/RGHW, batch/PIR recovery, prescribed differences, or exact dual-support
data.** A broad OpenAlex query for `locally recoverable codes` in the same date
window reported 2,866 fuzzy matches; its first 100 records were title/date/DOI
screened and promoted the service-rate and rank-metric papers above in addition
to the quantum-LRC cluster. Because the OpenAlex match count was visibly
dominated by lexical false positives, it is recorded as a discovery screen and
does not license a negative by itself.

The official arXiv API query returned HTTP 429 during this pass, so the dated
screen is not an exhaustive ingestion of every arXiv category entry. No new
BGS/prescribed-difference, RGHW-locality, or classical exact-recovery-transfer
paper dated inside the window was located. This is a bounded negative with the
stated indexing gap, not a closure result. The 9 July 2026 two-hole BGS
preprint is outside the one-month window and remains part of the earlier
frontier, not a new delta hit.

### Cheap corollary exposed by the service-rate literature

For a finite family $A$ of target demands and server radius $r$, let
$\mathcal R_a^{(\le r)}$ be the complete recovery-set family in the transported
server universe for demand $a\in A$. A permitted direct systematic singleton
may be adjoined identically on both sides. With a nonnegative server-capacity
vector $c$, define the bounded
service-rate polytope by

$$
 \Lambda_A^{(\le r)}(c)
 =\left\{\lambda\ge0:
 \begin{array}{l}
 \lambda_a=\sum_{R\in\mathcal R_a^{(\le r)}}\lambda_{a,R},\\
 \sum_a\sum_{R\ni j}\lambda_{a,R}\le c_j
 \quad\text{for every helper }j,
 \end{array}
 \quad \lambda_{a,R}\ge0\right\}.
$$

This polytope is a functor of the labelled bounded recovery-set families. Hence
any exact bounded recovery-structure isomorphism induces, after relabelling
helpers,

$$
 \boxed{\Lambda_{A,\mathrm{concat}}^{(\le r)}(c)
       =\Lambda_{A,\mathrm{inner}}^{(\le r)}(c).}
$$

For all nonzero demands in $W_P$, the uniform sharp eventual gate is

$$
 r<M_1(D_P,K_P)+d(I^\perp),
$$

with the larger objectwise gate available when $A$ omits the minimum-cost
demands. Under positive-density realization, the entire bounded service-rate
polytope—and therefore every coordinatewise maximum service rate and every
linear load-balancing objective—is reproduced on each prescribed block; the
polytopes of disjoint blocks combine by the corresponding product/capacity
constraints.

This corollary uses only the support layer once the recovery sets are known;
the coefficient-aware transfer is stronger. It is also distinct from BGS:
service-rate regions are fractional capacity polytopes, while BGS asks for one
integral capacity-one packing that serves a full multiset of demands. The new
August paper therefore strengthens the motivation and provides a timely
application, but does not challenge C948's priority claim.

MathSciNet was **NOT COVERED** because institutional authentication was not
available. Google Scholar was **NOT COVERED** because automated access was not
used. No claim is made about sources indexed only there. zbMATH and a complete
forward-citation closure were also not covered in this pass. These gaps require
"to our knowledge" wording.

### Priority verdict

No source found in this bounded audit states the combination

\[
 \text{canonical recovery pair}
 +\text{exact rank-stratified confinement}
 +\text{coefficient-fiber transfer}
 +\text{positive-density realization}.
\]

This is a bounded-search priority conclusion, not a claim of exhaustive
global novelty.

The nearest classical theorem is Abdel-Ghaffar--Weber's cooperative-locality
bound. The exact best-target identity above makes it a corollary and clarifies
the strict refinement:

\[
 \text{global dual GHW}
 \;<\;\text{fixed-target relative recovery hierarchy}
 \;<\;\text{normalized coefficient systems}
 \;<\;\text{exact concatenation transfer}.
\]

The inequalities here denote increasing information, not numerical strictness
for every code. The universality of nested pairs remains classical in substance;
the defensible priority claim begins with their exact fixed-target role in the
confinement theorem.

No manuscript, bibliography, public summary, or novelty ledger was updated.
The existing C948 report is the sole home of this provisional verdict, so there
are no repeated novelty surfaces to synchronize at this stage.

## 12. TT and EJ verdict

1. **Flagship:** the exact rank-(t) threshold
   (M_t(D_P,K_P)+d(I^\perp)). This is the strongest paper-specific theorem.
2. **Priority judo:** the identity
   (d_t(C^\perp)-t=\min_{|P|=t}\kappa_C(P)) makes the classical cooperative-
   locality GHW bound a min--max corollary and yields the global concatenation
   escape envelope (d_t(C^\perp)-t+d(C^\perp)).
3. **Strong corollary:** relative-Singleton/MDS extremality and the rank-one
   rigidity theorem. The inequalities are classical inputs; their exact
   confinement interpretation is new in this package.
4. **Concrete flagship:** the projective-simplex family gives a non-MDS
   nonlinear threshold hierarchy and an exact geometric reliability law.
5. **Structural separation:** the binary two-presentation example proves that
   the helper pair and its entire RGHW hierarchy do not determine the escape
   barrier. Target coefficients matter through (d(I^\perp)).
6. **Demote:** universality of nested pairs is standard quotient/graph algebra.
   Its positive-density exact transport is the worthwhile payoff.
7. **Corrected:** reliability separation requires forced supports and an exact
   total-radius budget; arbitrary direct-sum factorization is false.
8. **Delta-audit corollary:** exact recovery-family transfer preserves the
   entire bounded service-rate polytope, not only locality, availability, or
   one coordinatewise service maximum.

## 13. BGS disjoint-packing bridge — preliminary mathematical vet

This section vets the proposed additive 1-factorization/hole-hierarchy report.
It is not a literature-priority closure and makes no manuscript claim.

### Calibrated verdict

1. The additive matching model, profile simplex, hafnian support formula, and
   translation-fiber divisibility statement are correct for $s\ge2$.
2. The proposed profile lattice is not merely plausible: the stated local
   moves give a complete proof. Novelty remains unaudited.
3. The four-hole coefficient arithmetic is a strong candidate and survived
   targeted exact checks. The unrestricted four-hole theorem is **not yet
   proved** because the global complementary-minor sign, boundary-transform
   isolation, and translate noncancellation have not been rebuilt from fixed
   conventions.
4. The six-hole arithmetic lemmas remain plausible and survived targeted
   checks, but the six-hole theorem statements remain provisional for the
   reasons already identified in the supplied report.
5. The claimed equivalence with normality, integer decomposition, and generic
   affine-semigroup saturation is too strong. Those properties can furnish
   sufficient global mechanisms; BGS itself is only a specific degree-one
   integer-point lifting slice unless a bespoke semigroup equivalence is
   defined and proved.
6. The coding interpretation uses the Hadamard evaluation system indexed by
   all of $\mathbb F_2^s$, or equivalently the simplex code augmented by one
   dummy zero server. The edge through zero represents a singleton recovery.
   Any equivalence with a functional-batch formulation must state this
   convention explicitly.

### Profile-lattice theorem

Let $D=\mathbb F_2^s\setminus\{0\}$, let

$$
A_{|D|-1}=\{z\in\mathbb Z^D:\sum_dz_d=0\},
$$

and let $L_s$ be generated by differences of perfect-matching profiles. For
$s\ge2$,

$$
\boxed{
L_s=\left\{z\in A_{|D|-1}:
\sum_d(z_d\bmod2)d=0\right\},
\qquad
A_{|D|-1}/L_s\cong\mathbb F_2^s.
}
$$

The affine $2$-flat switch gives $2(e_a-e_b)\in L_s$. For independent
$a,b,c$, put $d=a+b+c$. On their affine cube, the four edges

$$
\{0,a\},\quad
\{b,a+c\},\quad
\{a+b,a+b+c\},\quad
\{c,b+c\}
$$

have differences $a,d,c,b$, respectively. Comparison with the pure
$a$-matching supplies the required weight-four parity relation.

Every even-cardinality zero-sum subset $S\subseteq D$ is generated by these
four-point circuits. For $|S|\ge6$, choose distinct $a,b,c\in S$ with
$a+b+c\ne0$ and take the symmetric difference with
$\{a,b,c,a+b+c\}$; its size falls by two or four and its parity sum remains
zero. The cases of size zero and four close the induction, while size two is
impossible. Subtracting the corresponding cube moves from a candidate lattice
vector leaves an even total-zero vector, generated by the $2$-flat moves.

### Correct semigroup formulation

For each graph edge $e=\{x,y\}$, use the column

$$
(\mathbf e_x+\mathbf e_y,\mathbf e_{x+y})
\in\mathbb Z^{V\sqcup D}.
$$

A BGS solution is a nonnegative integer representation of
$(\mathbf1_V,m)$. Vertex degree one then forces the representation to be a
perfect matching. The uniform convex combination of the monochromatic
matchings shows that every admissible $(\mathbf1_V,m)$ lies in the real cone,
and the profile-lattice theorem identifies its congruence obstruction.
Normality of the entire edge-color semigroup would imply BGS, but BGS does not
by itself imply full normality; higher vertex-degree slices need not decompose
into perfect matchings.

### Targeted exact checks

The following derivation-time checks were run without creating a paper-facing
reproducibility bundle:

- all 1,260 affine-plane coefficient cases satisfying the stated condition for
  $r=3$ obeyed the claimed valuation;
- all 8,960 tetrahedral cases satisfying $\gamma(S)=1$ for $r=3$ obeyed the
  claimed one-level valuation drop;
- random $r=4$ checks passed in 16 affine and 46 tetrahedral applicable cases;
- all 24,010 $r=3$ affine boundary-filter cases matched the asserted support
  and magnitude $8n^2$;
- the tetrahedral filter at $r=3$ had magnitude $4n^2$ exactly when
  $u(p)=1$ and $(\gamma+u)(q)=1$; exhaustive frequency-existence searches
  found no obstruction among 2,100 nonzero-sum quadruples for $r=3$ or 47,460
  for $r=4$;
- 2,800 random three-deleted quotient tests, 448 random invariant six-deletion
  tests, and 120 applicable random cubic-certificate tests all matched the
  proposed parity or valuation formula.

These checks materially increase confidence in the arithmetic lemmas but do
not validate the complete four- or six-hole Fourier argument.

### Remaining mathematical defects and gates

- State $s\ge2$ globally; the vertex-sum identity fails in the displayed form
  for $s=1$.
- Give the tetrahedral boundary constraints and prove their simultaneous
  solvability; the supplied report currently refers to them without stating
  the lemma. Small exhaustive checks are positive but are not a proof.
- Rebuild the entire four-hole complementary-minor/Fourier identity with one
  row order, column order, Jacobi sign, and algebraically signed boundary
  function. Nonzero local factors do not by themselves preclude global
  cancellation.
- Track repeated-column factorials and compatible-pairing multiplicities in
  the compression arguments before promoting six-hole claims.
- Replace the strict displayed hierarchy between RGHWs, recovery fibers, and
  packing fibers by explicit forgetful maps; numerical strictness need not
  occur for every code.
- Treat all low-dimensional verification and frontier statements as unverified
  until scripts/certificates and the promised claim-specific literature audit
  are complete.

### EJ consequence — stabilizer divisibility hierarchy

The translation observation has a stronger form. If a matching is stabilized
by a nontrivial translation subgroup $U\le V$ of dimension $j\ge1$, then

$$
2^{j-1}\mid m_d\quad(d\in U\setminus\{0\}),
\qquad
2^j\mid m_d\quad(d\notin U).
$$

Indeed, an edge of difference $d\in U$ has a two-element stabilizer inside
$U$, while an edge of difference outside $U$ has trivial stabilizer. This
stratifies profile fibers by possible translation stabilizers and may be useful
for Burnside counts or recursive reductions. It does not by itself approach
generic BGS instances.

Ideally packaged, the combined mathematics is now a plausible 99-level coding-
theory package and suitable for a strong IEEE Transactions on Information
Theory submission. The uniqueness theorem upgrades the projective family from
an illustrative example to an extremal classification. An independent cold
read of the full theorem packet and proof-level audit of the projective
reliability inversion remain the main gates before treating that assessment as
locked.

The current best sequel title is *Exact Transfer of Bounded Linear Recovery
and Relative Weight Hierarchies*. The single-coordinate theorem should appear
as the rank-one specialization, the rank hierarchy should carry the
quantitative spine, and geometry should serve as the principal application
rather than as a competing theme.

## Mystery ledger

### Settled

- The correct rank parameter is message rank, not presentation dimension.
- The uniform rank-(t) cost is exactly a relative generalized Hamming weight.
- The nonconfinement threshold is the relative weight plus (d(I^\perp)).
- The singleton-target shift relative to (z_x) is accounted for.
- Relative-Singleton equality at rank one forces the entire relative hierarchy.
- Arbitrary nested pairs are realizable, but that construction is classical in
  substance.
- Direct-sum reliability has been repaired using uniquely forced padding.
- A concrete non-MDS family now realizes a nonlinear hierarchy.
- Its exact reliability is a projective-rank/Tutte specialization with closed
  subspace-lattice inversion.
- The coefficient presentation can change all confinement thresholds while
  leaving the canonical helper pair and complete RGHW hierarchy fixed.
- At the projective helper budget, the simplex configuration is the unique
  rank-one extremizer up to projective column equivalence.
- The dual GHW minus target size is exactly the best-target simultaneous
  recovery cost, not merely a lower bound.
- Abdel-Ghaffar--Weber's cooperative-locality inequality is the corresponding
  min--max corollary.
- The earliest rank-(t) identity-demand escape over all target sets is
  (d_t(C^\perp)-t+d(C^\perp)).
- The proposed BGS profile lattice follows completely from the affine $2$-flat
  and $3$-cube moves; only its literature priority remains open.
- Full semigroup normality is stronger than BGS and is not an equivalent
  reformulation without an explicitly restricted slice construction.
- Targeted finite checks found no defect in the proposed four-hole coefficient
  valuations or the sampled six-deletion arithmetic.
- The August 2026 service-rate literature yields an immediate exact-transfer
  corollary for bounded fractional service polytopes; it is support-level and
  does not pre-empt the coefficient-aware confinement theorem.

### Open

- Independent cold read of the exact-sequence, threshold, rigidity, projective
  reliability, and coefficient-presentation arguments.
- Full literature closure for the combined exact threshold, rather than the
  classical RGHW ingredients separately.
- Full-text promotion of the nearest partial reads and zbMATH/forward-citation
  closure if a manuscript-bound priority sentence is proposed.
- Repeat the dated delta screen at C948 closure; the present 24 July--24 August
  screen was index-based and the official arXiv API was rate-limited.
- Decide whether the projective-simplex family or coefficient-presentation
  separation should lead the eventual sequel application section.
- Derive the dual relative-weight failure thresholds in literal recovery
  language, with all index reversals checked.
- Complete the four-hole global boundary-transform/sign audit; local
  coefficient nonvanishing is not enough.
- Prove the omitted tetrahedral boundary-frequency existence lemma.
- Audit the BGS frontier and profile-lattice precedence before any priority
  claim, and keep six-hole conclusions provisional meanwhile.

## Current verdict

The theorem packet has crossed from an attractive generalization to a coherent
paper spine. Its priority does not rest on introducing relative generalized
weights. It rests on proving that those weights are the exact rank-stratified
local costs, that concatenation adds precisely the global dual-distance escape
barrier, and that the complete coefficient systems can be reproduced on
positive-density target classes. The projective-simplex and coefficient-
presentation examples now give the abstract result concrete mathematical
teeth.
