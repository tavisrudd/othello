# C951 — Recovery-paper formal boundary

**Lane**: `complete-ports`

**Status**: IN PROGRESS; PAPER-LOCAL LEAN PACKAGE ESTABLISHED; ASSOCIATED
NESTED-PAIR EXACT-SEQUENCE DATA KERNEL-CHECKED; CENTRAL CLAIM MAP FROZEN;
SHARED LEAN TREE UNCHANGED

## Scope and ownership

The new formal companion lives at
`papers/complete-repair-ports/lean/`, following the paper-owned pattern used by
`papers/cubic-stabilization-m1/lean/`. It is a Mathlib-only package. The shared
`lean/RepairPorts` and `lean/RepairCodes` libraries are imported evidence for
the previous manuscript and are not dependencies of the new package.

The paper-local `lean/AGENTS.md` is a repository-local symlink to
`../../../lean/AGENTS.md`. `papers/repositories.toml` excludes that symlink
from standalone export. The norms themselves are not copied into or exported
with the scholarly artifact.

No manuscript source has been edited.

## Native terminology and symbols

Let

\[
 G=(G_P\mid G_J),\qquad
 U_P=\operatorname{im}G_P,\qquad
 W_P=U_P\cap\operatorname{im}G_J.
\]

The helper-side submodules are

\[
 K_P=\ker G_J,
 \qquad
 D_P=G_J^{-1}(U_P).
\]

The paper calls $K_P\subseteq D_P$ the **associated nested code pair**. This
is a descriptive phrase, not a proposed term of art. Use **relative
generalized Hamming weight**, **relative dimension/length profile**,
**recovery set**, **recovery equation**, **helper union**, **cooperative
recovery**, and **service-rate region** in their standard senses. Do not use
“port” or “fiber” as paper terminology.

The Lean API uses literal names:

- `targetMessageSpace` for $U_P$;
- `recoverableTargetMessageSpace` for $W_P$;
- `helperCodeForTargetSpace` for $D_P$;
- `LinearMap.ker helper` for $K_P$; and
- `recoverableTargetMap` for $G_J|_{D_P}:D_P\to W_P$.

No new branded invariant is introduced.

## Frozen statement packet

Assume throughout that $q$ is a prime power, $I\le\mathbb F_q^E$ is a
nontrivial represented inner code with full-row-rank generator matrix $G$,
$P\subseteq E$ is a target set, $J=E\setminus P$ is the helper set, and
$\ell=\dim W_P\ge1$.

### Associated nested code pair

There is an exact sequence

\[
 0\longrightarrow K_P\longrightarrow D_P
 \xrightarrow{G_J}W_P\longrightarrow0.
\]

The paper-local companion proves the four constituent statements:

1. $K_P\le D_P$;
2. $G_J(D_P)=W_P$;
3. $G_J|_{D_P}$ is surjective onto $W_P$; and
4. its kernel consists exactly of the elements of $K_P$ viewed in $D_P$.

### Relative generalized Hamming weights

For $1\le t\le\ell$, let $M_t(D_P,K_P)$ be the standard relative generalized
Hamming weight. The minimum helper-union size among internally realizable
message-rank-$t$ recovery systems is

\[
 \mu_t=M_t(D_P,K_P).
\]

Equivalently,

\[
 M_t(D_P,K_P)=
 \min\{\lvert\operatorname{supp}L\rvert:
 L\le D_P,\ \dim L=t,\ L\cap K_P=0\}.
\]

The equivalence with the standard definition follows by taking a complement
to $L'\cap K_P$ inside each feasible $L'\le D_P$. The complement has no larger
support.

### Rank-stratified confinement

Under the outer-family hypotheses inherited from the exact objectwise
confinement theorem, the least helper-union size of a nonconfined
message-rank-$t$ recovery system is

\[
 \Gamma_t=M_t(D_P,K_P)+d(I^\perp).
\]

Thus every internally realizable message-rank-$t$ recovery system using at
most $r$ helpers is eventually confined to its target inner block if and only
if

\[
 r<M_t(D_P,K_P)+d(I^\perp).
\]

The rank parameter is recovered-message rank. It is not the dimension of an
arbitrary target coefficient presentation. For a singleton target $\{x\}$,
$z_x(I)=\Gamma_1+1$, since $z_x$ counts the target coordinate and $\Gamma_1$
counts helpers.

### Consequences retained in the primary paper

- Relative Singleton gives
  \[
  \Gamma_t\le b-\ell+t+d(I^\perp)\le2k-\ell+t+1,
  \]
  where $b=\operatorname{rank}G_J$ and $k=\dim I$.
- In the stated MDS range $p=|P|\le k$ and $|J|\ge k$,
  \[
  M_t(D_P,K_P)=k-p+t,
  \qquad
  \Gamma_t=2k-p+t+1.
  \]
- The best-target identity is
  \[
  \min_{|P|=t}\mu_t(P)=d_t(I^\perp)-t.
  \]
- Exact transfer of inclusion-minimal helper supports preserves bounded
  reliability and the bounded service-rate region. Upward-closed cross-block
  supersets are removed by minimal-set domination.
- For an outer family with dual distance tending to infinity, every inner
  coordinate type occurs with density $1/|E|$; the union of the $p$ target
  types has density $p/|E|$. Positive outer rate and relative distance are
  additional hypotheses when asymptotic goodness is claimed.

## Formal coverage table

| Paper statement | Paper-local status | Exact terminal or boundary |
| --- | --- | --- |
| $K_P\le D_P$ | complete | `helper_ker_le_helperCodeForTargetSpace` |
| $G_J(D_P)=W_P$ | complete | `map_helperCodeForTargetSpace_eq_recoverableTargetMessageSpace` |
| $G_J|_{D_P}$ surjective | complete | `recoverableTargetMap_surjective` |
| restricted kernel equals $K_P$ | complete | `mem_ker_recoverableTargetMap_iff` |
| $\mu_t=M_t(D_P,K_P)$ | absent | complete human complement/support proof; no paper-local RGHW API yet |
| $\Gamma_t=M_t+d(I^\perp)$ | absent | complete human proof from the objectwise theorem; old shared Lean formalizes only the rank-one transfer mechanism |
| best-target GHW identity | absent | complete human information-set proof |
| relative-Singleton and MDS formulas | classical input plus human specialization | cite the standard relative Singleton theorem and prove the uniform-matroid calculation in prose |
| positive-density exact transfer | absent paper-locally | previous shared declarations cover the rank-one mechanism; rebuilt statement is human-only until represented here |
| reliability/service-rate transfer | absent | finite support-family argument; no computation needed |
| projective-simplex formulas | absent | human finite-geometry and subspace-lattice calculation |

This table is also encoded in
`papers/complete-repair-ports/lean/verification/claims.json`. An absent row is
not evidence for or against the mathematical statement; it records that the
paper-local kernel does not establish it.

## Axiom boundary

The paper-local reviewer terminals report only

\[
 \{\texttt{Classical.choice},\texttt{Quot.sound},\texttt{propext}\}.
\]

No literature theorem is declared as a paper-local Lean axiom. Stichtenoth's
self-dual TVZ-family theorem is cited and used as an ordinary mathematical
input only if the explicit AG specialization is retained. A generic
positive-density theorem instead takes the outer-family properties as
hypotheses.

The reported shared-registry defect was reproduced by the portfolio-wide
checker: `RepairCodes.Imported.stichtenoth_selfDual_TVZ_6561` is classified as
an axiom in an unaudited shared library and is owned by no shared trust area.
The existing `complete_ports` area itself passes its scoped audit. By author
direction, C951 does not modify the shared registry. The rebuilt paper's trust
boundary is resolved by the independent paper-local package, which imports no
`RepairCodes` module and contains no project axiom. The shared portfolio
classification debt remains outside the paper-local artifact.

## Validation so far

- `RecoveryStructures`: guarded build passed.
- `RecoveryStructuresVerification`: guarded build passed.
- Four reviewer terminals: each reports exactly the three standard logical
  axioms listed above.
- Shared `complete_ports` scoped trust audit: zero findings.
- Shared portfolio-wide check: reproduced the unowned Stichtenoth axiom plus
  unrelated foreign-area findings; no shared file was changed.
- Manuscript and shared Lean sources: unchanged.

## Remaining C951 work

1. Add the paper-local source/axiom checker and verify the tracked claim
   partition.
2. Decide whether to formalize the complement/support lemma defining the RGHW
   identity now or retain it as an explicitly human-only main theorem.
3. Record exact classical source pinpoints for relative generalized weights,
   relative Singleton, and Wei duality.
4. Run the paper export plan from an immutable source commit and verify that
   `lean/AGENTS.md` is excluded.
5. Close the statement-adequacy table against every C950 theorem and
   corollary.
