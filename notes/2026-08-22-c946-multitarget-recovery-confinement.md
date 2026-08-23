# C946 — Multi-target recovery and exact confinement

**Lane**: `complete-ports`

**Status**: ACTIVE; INTRINSIC RECOVERY CRITERION AND EVENTUAL THRESHOLD CANDIDATE DERIVED

## Objective

Extend the one-target bounded recovery theory to simultaneous linear recovery
of a nonempty target set (P) contained in one inner block.  Determine the
correct coefficient-aware local object, prove an exact eventual confinement
criterion for concatenation, recover the published threshold when
(|P|=1), and identify honestly what remains of the proposed generalized-weight,
MacWilliams/LP, and bandwidth directions.

This is sequel research.  It does not enlarge the frozen 23-page manuscript
unless a later task explicitly adopts a proved result.

## Scope and terminology

- Use **target set**, **simultaneous recovery**, and **bounded local erasure
  recovery** for the coding-theory objects.
- Reserve Chaiken's established term **ported matroid** for his matroid
  invariant; do not revive “port” as the paper's coding noun.
- Initially place all targets in one distinguished inner block.  Targets spread
  across several concatenation blocks are a different problem.
- Charge the union of helper coordinates, not the sum of row weights.
- Treat bandwidth/subpacketization as a separate model.  For the present scalar
  (mathbb F_q)-codes, bandwidth cost collapses to helper count.

## Intrinsic simultaneous-recovery object

Let (C\leq \mathbb F_q^E), let (arnothing\neq P\subseteq E), and let
(H\subseteq E\setminus P).  Put

\[
 D_C(P,H)=\{w\in C^\perp:\operatorname{supp}(w)\subseteq P\cup H\},
 \qquad
 \rho_{P,H}:D_C(P,H)\longrightarrow \mathbb F_q^P,
 \quad w\longmapsto w|_P.
\]

The following conditions are equivalent:

1. every (c_P) is determined linearly by (c_H) for (c\in C);
2. (ker(\pi_H|_C)\subseteq\ker(\pi_P|_C));
3. (ho_{P,H}) is surjective;
4. there is a linear splitting
   (s:\mathbb F_q^P\to D_C(P,H)) with (ho_{P,H}s=\mathrm{id}).

A splitting is a normalized matrix of simultaneous recovery equations.  The
set of splittings, when nonempty, is an affine space under

\[
 \operatorname{Hom}\!\left(\mathbb F_q^P,
 C^\perp\cap\mathbb F_q^H\right).
\]

Thus a subspace (W\leq C^\perp) with full-rank restriction is an existence
certificate, but it is not by itself the clean coefficient-aware object:
helper-supported dual words create a genuine gauge ambiguity.  The canonical
data are the restricted-dual surjection and its full affine space of
splittings.

Define the minimum internal helper-union cost

\[
 \rho_P(C)=\min\bigl\{|H|:\rho_{P,H}\text{ is surjective}\bigr\}.
\]

## Candidate eventual confinement theorem

Let (I\leq\mathbb F_q^E) be a represented inner code with message alphabet
(L), let (P\subseteq E) be simultaneously recoverable, and concatenate it
with an (L)-linear outer family whose dual distance tends to infinity.  For a
fixed helper budget (r), the candidate sharp eventual statement is

\[
 \boxed{\quad
 \text{every exact simultaneous recovery splitting of cost at most }r
 \text{ is confined to its target block}
 \quad\Longleftrightarrow\quad
 r<\rho_P(I)+d(I^\perp).
 \quad}
\]

### Necessity / attained obstruction

Choose an internal splitting (s_0) with helper union of size
(ho_P(I)), a nonzero minimum word (v\in I^\perp), and a nonzero
functional (ell\in(\mathbb F_q^P)^*).  In any other block, add

\[
 a\longmapsto \ell(a)v
\]

to (s_0).  Embedded inner-dual words belong to the concatenated dual, the
restriction on (P) remains the identity, and the exact helper union has size
(ho_P(I)+d(I^\perp)).  This is a non-confined coefficient scheme.

### Sufficiency after outer growth

For any splitting, apply the inner encoder in each block to every row and
collect the induced block-functional tuples.  If one tuple is nonzero, its
block support is at least the outer dual distance.  Since the splitting uses
at most (r) helper coordinates and (|P|) target coordinates, all such
tuples vanish once (d(O_N^\perp)>r+|P|).

The splitting then decomposes blockwise into inner-dual maps.  Its target-block
part is itself a splitting, so its target-block helper union has size at least
(ho_P(I)).  If the original splitting is not confined, at least one other
block contains a nonzero inner-dual word and hence contributes at least
(d(I^\perp)) disjoint helper coordinates.  Therefore every non-confined
zero-functional splitting costs at least
(ho_P(I)+d(I^\perp)).

### One-target reduction

For (P=\{x\}),

\[
 \rho_{\{x\}}(I)
 =\min\{\operatorname{wt}(u):u\in I^\perp, u_x\neq0\}-1.
\]

Hence

\[
 r<\rho_{\{x\}}(I)+d(I^\perp)
 \quad\Longleftrightarrow\quad
 r+1<z_x(I),
\]

exactly recovering the present theorem.

## Rank hierarchy: refinement, not the confinement gate

One can stratify a non-confined splitting by the rank of its external
inner-dual perturbation.  Generalized or relative generalized Hamming weights
should describe the minimum support of fixed-rank perturbations, with a
subadditive envelope when the image is distributed among several blocks.
However, rank one already creates a distinct non-confined splitting and
therefore controls the yes/no confinement threshold above.  A hierarchy is
potentially useful for enumerators, robustness, or multiple independent
external perturbations, but should not be inserted into the basic theorem
without a different operational requirement.

## MacWilliams/LP boundary

The first proposed normalized enumerator is already contained in the refined
support distribution of Gruica--Jany--Ravagnani:

\[
 A_{x,j}
 =\#\{u\in C^\perp:u_x=1,
       |\operatorname{supp}(u)\setminus\{x\}|=j\}
 =\frac{1}{q-1}W_{j+1}^{\{x\}}(C^\perp).
\]

Their MacWilliams-type identity therefore handles this first-order count.
New constraints would have to retain joint equations, intersection patterns,
projective coefficient data, or minimality.  The Boolean reliability event and
minimal-support antichain are nonlinear and do not automatically admit a
MacWilliams transform.

## Bandwidth boundary

For scalar (mathbb F_q)-symbols, the minimum downloaded
(mathbb F_q)-dimension equals helper support size.  A nontrivial bandwidth
threshold requires a vector-code model with fixed subpacketization, allowed
helper response maps, and centralized/cooperative/access/rack conventions.
Even one-target schemes then correspond to spaces of checks.  This remains a
separate sequel rather than an unproved strengthening of C946.

## Literature state used at start

- Chaiken, *The Tutte polynomial of a ported matroid*, JCTB 46 (1989),
  96--117, DOI `10.1016/0095-8956(89)90010-5`: existence and established
  matroid terminology confirmed; exact specialization still to be read from
  the primary paper.
- Gruica--Jany--Ravagnani, *LRCs: Duality, LP Bounds, and Field Size*, DCC 94
  (2026), article 100, DOI `10.1007/s10623-026-01829-7`: abstract,
  introduction, Definitions 2.9 and 3.2, Proposition 3.5, and Theorem 3.8 read
  from cached SHA-256
  `555c0586dd3017cf5317ef6c73818f3764c1a5d6b8b1ea4b82c1c75d10ec6863`.
- Rawat--Mazumdar--Vishwanath, *Cooperative Local Repair in Distributed
  Storage*, arXiv:1409.3900v2: abstract and introduction read from cached
  SHA-256
  `8e71095933dff7b4c083b47fa52f5ae8bafb85b8fd4e649121dc84ee26975037`.
- Alfarano--Ravagnani--Soljanin, *Dual-Code Bounds on Multiple Concurrent
  (Local) Data Recovery*, arXiv:2201.07503v2: abstract, introduction, and
  recovery-system definitions read from cached SHA-256
  `75dfdc9b233c2f091e987790b6cff029551b59d0289d85f0b9b3d8b30a712bbc`.

No novelty verdict is assigned yet.

## Acceptance gates

1. Prove the four intrinsic recovery criteria equivalent, including the affine
   splitting description.
2. State and prove the exact finite outer-functional cost formula, not only the
   eventual bound.
3. Prove or refute the boxed eventual threshold and its one-target reduction.
4. Determine the correct rank-refined support costs and whether ordinary or
   relative generalized weights suffice.
5. Compare the full-radius target-set invariant directly with Chaiken and with
   the Las Vergnas perspective (M\setminus P\to M/P).
6. Give at least one finite counterexample preventing an overstrong scalar or
   MacWilliams claim.
7. Run independent mathematical and operational cold reads before proposing a
   manuscript or Lean task.

## Immediate next work

- write the finite concatenated-dual map-valued decomposition;
- prove the zero-functional lower bound in helper-union rather than row weight;
- isolate the exact nonzero-functional map cost;
- test the formulas on small binary inner and outer codes by independent
  exhaustive enumeration.
