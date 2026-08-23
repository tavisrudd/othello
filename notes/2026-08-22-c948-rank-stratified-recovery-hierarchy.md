# C948 — Rank-stratified recovery and relative-weight confinement

**Lane**: complete-ports

**Status**: IN PROGRESS; CORE THEOREMS AND EJ2 UPGRADES DERIVED; INDEPENDENT COLD READ PENDING

## Scope

This is a math-only successor to C946 and C947. It does not authorize edits to
the manuscript, bibliography, README, Lean boundary, or public mirror.

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

Thus, under C946's outer-family hypotheses, every radius-(r) recovery system
for every rank-(t) demand is eventually confined to its inner block if and
only if

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
coefficients. This gives the flagship a genuine rank-one extremal property,
not merely a closed formula.

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

## 9. Literature and priority audit

Primary sources checked in the shared cache and by focused searches:

- arXiv:1403.7985 (Geil et al.): definition and hierarchy of relative
  generalized Hamming weights, relative Singleton behavior, MDS equality,
  and nested-code information interpretation. Cached SHA-256:
  `25e31e23e4238ae33a08b4730c558fe071861a87c6e4fc0e1161d4bbcda581e7`.
- arXiv:2503.17764 (San-José): current definitions, strict hierarchy,
  Singleton bounds, and algorithms for generalized and relative weights.
  Cached SHA-256:
  `98bebce176b7f711a90f6a2ba0224dd77e4883eb0939c8aca237d571e9d1654b`.
- arXiv:2309.03676 (Gruica--Jany--Ravagnani): generalized weights and refined
  support distributions in LRC bounds. The audited portions did not use the
  canonical nested recovery pair or the exact confinement sum above. Cached
  SHA-256:
  `1b941cf8445e40039a988ea0124e15fd94f0bbeb278205ec7bf934bf3e9a71a3`.
- The 2026 paper *Considerate ramp secret sharing* was checked for the current
  access-structure/RGHW information interpretation; that bridge is standard.
  DOI: 10.1007/s10623-026-01808-y.

Focused exact-phrase searches included relative generalized weights together
with concatenation, recovery sets, cooperative repair, locality, and
confinement. No source found in this bounded audit states the combination

\[
 \text{canonical recovery pair}
 +\text{exact rank-stratified confinement}
 +\text{coefficient-fiber transfer}
 +\text{positive-density realization}.
\]

This is a bounded-search priority conclusion, not a claim of exhaustive
global novelty.

## 10. TT and EJ verdict

1. **Flagship:** the exact rank-(t) threshold
   (M_t(D_P,K_P)+d(I^\perp)). This is the strongest paper-specific theorem.
2. **Strong corollary:** relative-Singleton/MDS extremality and the rank-one
   rigidity theorem. The inequalities are classical inputs; their exact
   confinement interpretation is new in this package.
3. **Concrete flagship:** the projective-simplex family gives a non-MDS
   nonlinear threshold hierarchy and an exact geometric reliability law.
4. **Structural separation:** the binary two-presentation example proves that
   the helper pair and its entire RGHW hierarchy do not determine the escape
   barrier. Target coefficients matter through (d(I^\perp)).
5. **Demote:** universality of nested pairs is standard quotient/graph algebra.
   Its positive-density exact transport is the worthwhile payoff.
6. **Corrected:** reliability separation requires forced supports and an exact
   total-radius budget; arbitrary direct-sum factorization is false.

Ideally packaged, the combined mathematics is plausibly at the
98th--99th percentile within coding theory and suitable for a strong IEEE
Transactions on Information Theory submission. A cold read of this theorem
packet and verification of the projective reliability inversion remain the
main gates before treating that assessment as locked.

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

### Open

- Independent cold read of the exact-sequence, threshold, rigidity, projective
  reliability, and coefficient-presentation arguments.
- Full literature closure for the combined exact threshold, rather than the
  classical RGHW ingredients separately.
- Decide whether the projective-simplex family or coefficient-presentation
  separation should lead the eventual sequel application section.
- Derive the dual relative-weight failure thresholds in literal recovery
  language, with all index reversals checked.
- Determine whether the projective rank-one equality has a useful uniqueness
  classification under the intended helper-multiset hypotheses.

## Current verdict

The theorem packet has crossed from an attractive generalization to a coherent
paper spine. Its priority does not rest on introducing relative generalized
weights. It rests on proving that those weights are the exact rank-stratified
local costs, that concatenation adds precisely the global dual-distance escape
barrier, and that the complete coefficient systems can be reproduced on
positive-density target classes. The projective-simplex and coefficient-
presentation examples now give the abstract result concrete mathematical
teeth.
