# C951 — Recovery-paper formal boundary

**Lane**: `complete-ports`

**Status**: COMPLETE; PAPER-LOCAL LEAN PACKAGE ESTABLISHED; ASSOCIATED
NESTED-PAIR EXACT-SEQUENCE DATA KERNEL-CHECKED; CENTRAL CLAIM MAP AND AXIOM
BOUNDARY FROZEN; SHARED LEAN TREE UNCHANGED

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

## Statement-adequacy audit

| Field | Paper statement | Paper-local representation |
| --- | --- | --- |
| target set | coordinates $P$ and coefficient space $\mathbb F_q^P$ | abstract target coefficient module `A` and map `target` |
| helper universe | coordinates $J=E\setminus P$ and $\mathbb F_q^J$ | abstract helper coefficient module `H` and map `helper` |
| represented generator | split generator maps $G_P,G_J$ | `target`, `helper` |
| recoverable message space | $W_P=\operatorname{im}G_P\cap\operatorname{im}G_J$ | exact definition and surjectivity theorem |
| associated nested pair | $K_P=\ker G_J\le D_P=G_J^{-1}(U_P)$ | exact kernel inclusion, image, and restricted-kernel theorems |
| message rank $t$ | $1\le t\le\dim W_P$ | absent; cannot be inferred from the exact-sequence terminals |
| helper union | union of supports of a recovery-equation subspace | absent |
| normalized recovery equations | target restriction equal to the chosen identity/basis presentation | absent |
| RGHW minimum | standard $M_t(D_P,K_P)$ | absent |
| confinement | every bounded rank-$t$ system remains in one inner block | absent paper-locally; earlier rank-one shared mechanism is not promoted |
| positive density | fixed type $1/|E|$, target union $|P|/|E|$ | absent |
| coefficient transfer | literal equality of normalized recovery equations under zero extension | absent |

The exact-sequence terminals are statement-adequate for the associated nested
pair and for no stronger row. C952 must not describe the central theorem as
formally verified.

## Classical source boundary

- Geil--Martin--Matsumoto--Ruano--Luo, arXiv:1403.7985, Definition 4 and
  Section 3 supply the standard RGHW, Singleton, and duality framework.
- San-José, arXiv:2503.17764, Section 2 through Theorem 2.8 supplies a current
  consolidated statement of GHW/RGHW definitions, strict growth, Singleton
  bounds, and duality.
- Abdel-Ghaffar--Weber, DOI `10.1109/ISIT.2017.8006618`, Lemma 2 and Theorem 1
  supply the cooperative-recovery normalization and the generalized-weight
  lower bound used for comparison.
- Stichtenoth, arXiv:math/0506264, Theorem 1.6(ii), is the explicit self-dual
  TVZ-family input if the square-field AG specialization is retained.

These are imported mathematical results in the human proof and bibliography.
They are not Lean axioms in the paper-local package.

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
- Paper-local source/claim partition: passed with seven claim rows and four
  reviewer terminals.
- Paper-local expected-axiom comparison against captured kernel output:
  passed.
- The committed paper-local tree contains no `AGENTS.md` or `CLAUDE.md`; the
  ignored development symlink resolves to the shared norms and cannot enter an
  immutable-source export.
- Shared `complete_ports` scoped trust audit: zero findings.
- Shared portfolio-wide check: reproduced the unowned Stichtenoth axiom plus
  unrelated foreign-area findings; no shared file was changed.
- Manuscript and shared Lean sources: unchanged.

## Closeout decisions

1. The main RGHW and confinement theorems remain explicitly human-only in the
   first paper-local companion release. No conditional wrapper or renamed
   definition is used to inflate coverage.
2. The associated nested-pair exact sequence is the complete paper-local Lean
   contribution at this stage.
3. C952 may cite the older shared rank-one terminals as provenance for the
   predecessor theorem, but they are not part of the rebuilt paper's axiom
   audit or package dependency graph.
4. The standalone mirror should copy the tracked `lean/` package verbatim.
   The ignored development symlink is absent from the committed tree.
5. Any later formalization of RGHWs, support unions, or rank-stratified
   confinement must add exact claim rows and reviewer terminals before the
   manuscript may upgrade its formalization statement.
