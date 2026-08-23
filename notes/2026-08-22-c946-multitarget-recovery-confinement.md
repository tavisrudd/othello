# C946 — Multi-target recovery and exact confinement

**Lane**: complete-ports

**Status**: ACTIVE; HUMAN PROOF PACKET, TT PASS, AND BOUNDED LITERATURE AUDIT COMPLETE; COLD READS PENDING

## Objective

Extend the one-target bounded recovery theory to simultaneous linear recovery
of a nonempty target set \(P\) contained in one inner block. Determine the
correct coefficient-aware local object, prove an exact eventual confinement
criterion for concatenation, recover the published threshold when
\(\lvert P\rvert=1\), and identify honestly what remains of the proposed
generalized-weight, MacWilliams/LP, and bandwidth directions.

This is sequel research. It does not enlarge the frozen 23-page manuscript
unless a later task explicitly adopts a proved result.

## Scope and terminology

- Use **target set**, **simultaneous recovery**, and **bounded local erasure
  recovery** for the coding-theory objects.
- Reserve Chaiken's established term **ported matroid** for his matroid
  invariant; do not revive “port” as the paper's coding noun.
- Initially place all targets in one distinguished inner block. Targets spread
  across several concatenation blocks are a different problem.
- Charge the union of helper coordinates, not the sum of row weights.
- Treat bandwidth/subpacketization as a separate model. For the present scalar
  \(\mathbb F_q\)-codes, bandwidth cost collapses to helper count.

## Intrinsic simultaneous-recovery object

Let \(C\leq\mathbb F_q^E\), let
\(\varnothing\neq P\subseteq E\), and let \(H\subseteq E\setminus P\). Put

\[
 D_C(P,H)=\{w\in C^\perp:\operatorname{supp}(w)\subseteq P\cup H\},
 \qquad
 \rho_{P,H}:D_C(P,H)\longrightarrow\mathbb F_q^P,
 \quad w\longmapsto w|_P.
\]

The following conditions are equivalent:

1. every \(c_P\) is determined linearly by \(c_H\) for \(c\in C\);
2. \(\ker(\pi_H|_C)\subseteq\ker(\pi_P|_C)\);
3. \(\rho_{P,H}\) is surjective;
4. there is a linear splitting
   \(s:\mathbb F_q^P\to D_C(P,H)\) with
   \(\rho_{P,H}s=\operatorname{id}\).

Indeed, the first two conditions are the definition of factorization of
\(\pi_P|_C\) through \(\pi_H|_C\). Under the kernel inclusion, the rule
\(\pi_H(c)\mapsto\pi_P(c)\) is a well-defined linear map on \(\pi_H(C)\);
extend it linearly to \(\mathbb F_q^H\). Transposing its coordinate equations
gives, for every \(a\in\mathbb F_q^P\), a dual word supported on \(P\cup H\)
whose restriction to \(P\) is \(a\). This is surjectivity of \(\rho_{P,H}\).
Conversely, the preimage of each standard basis vector gives one recovery
equation, hence a linear recovery map. Finally, every surjection of
finite-dimensional vector spaces splits, proving the equivalence with the
fourth condition.

A splitting is a normalized matrix of simultaneous recovery equations. If
\(s_0\) is one splitting, every other splitting is uniquely \(s_0+t\), where
\(\rho_{P,H}t=0\). Since
\(\ker(\rho_{P,H})=C^\perp\cap\mathbb F_q^H\), the set of splittings is an
affine space under

\[
 \operatorname{Hom}\!\left(
   \mathbb F_q^P,\ C^\perp\cap\mathbb F_q^H
 \right).
\]

Thus a subspace \(W\leq C^\perp\) with full-rank restriction is an existence
certificate, but it is not by itself the clean coefficient-aware object:
helper-supported dual words create a genuine gauge ambiguity. The canonical
data are the restricted-dual surjection and its full affine space of
splittings.

Define the minimum internal helper-union cost

\[
 \rho_P(C)=
 \min\bigl\{|H|:\rho_{P,H}\text{ is surjective}\bigr\}.
\]

## Exact finite map-valued cost

Write \(A=\mathbb F_q^P\), and let

\[
 \Phi:\mathbb F_q^E\longrightarrow L^*,
 \qquad
 \Phi(y)(a)=\langle y,\iota(a)\rangle
\]

be the block-functional map of the represented inner encoder
\(\iota:L\to I\). For a linear map \(Y:A\to\mathbb F_q^E\), let
\(\operatorname{usupp}(Y)\) be the union of the supports of its image. For
\(B:A\to L^*\), define

\[
 \lambda_A(B)=
 \min_{\Phi Y=B}|\operatorname{usupp}(Y)|
\]

and the pointed target-block cost

\[
 \mu_P(B)=
 \min_{\substack{\Phi Y=B\\Y|_P=\operatorname{id}_A}}
 |\operatorname{usupp}(Y)\setminus P|.
\]

Here \(Y|_P=\operatorname{id}_A\) means that the coordinate functionals of
\(Y\) on \(P\) are the standard coordinate functionals of \(A\). In
particular, \(\mu_P(0)=\rho_P(I)\), while the least union support of a nonzero
map \(A\to I^\perp\) is \(d(I^\perp)\): a rank-one map attains it.

For an outer code \(O\leq L^J\) with \(\lvert J\rvert\geq2\), let

\[
 \operatorname{FD}_A(O)
 =
 \left\{
 B=(B_j)_{j\in J}:A\to(L^*)^J:
 B(a)\in\operatorname{FD}(O)\text{ for every }a\in A
 \right\}.
\]

Equivalently,
\(\operatorname{FD}_A(O)=
  \operatorname{Hom}(A,\operatorname{FD}(O))\).
At target block \(j\), the exact least helper-union cost of a non-confined
simultaneous recovery splitting is

\[
 \Theta_{P,j}(I,O)=
 \min_{B\in\operatorname{FD}_A(O)}
 \left(
  \mu_P(B_j)+
  \begin{cases}
   \displaystyle\sum_{\ell\neq j}\lambda_A(B_\ell),
      &\text{if some }B_\ell\neq0\text{ for }\ell\neq j,\\[6pt]
   d(I^\perp),
      &\text{if }B_\ell=0\text{ for every }\ell\neq j.
  \end{cases}
 \right).
\]

The second branch deliberately includes nonzero singleton functionals at the
target block: a confined realization can always be made non-confined by adding
a minimum inner-dual word in another block. For the first branch, every
nonzero external \(B_\ell\) forces a nonzero realization, while zero external
blocks are optimally realized by zero. Disjoint blocks make union-support cost
additive. This proves the formula directly from the block-functional
decomposition; it is the multi-target analogue of the finite
zero/singleton/multisupport stratification.

Consequently every cost-\(\leq r\) exact splitting is confined if and only if
\(r<\Theta_{P,j}(I,O)\).

## Eventual confinement theorem: human proof packet

Let \(I\leq\mathbb F_q^E\) be a represented inner code with message alphabet
\(L\), let \(P\subseteq E\) be simultaneously recoverable, and concatenate it
with an \(L\)-linear outer family whose dual distance tends to infinity. For a
fixed helper budget \(r\), the sharp eventual statement is

\[
 \boxed{\quad
 \text{every exact simultaneous recovery splitting of cost at most }r
 \text{ is confined to its target block}
 \quad\Longleftrightarrow\quad
 r<\rho_P(I)+d(I^\perp).
 \quad}
\]

### Necessity / attained obstruction

Choose an internal splitting \(s_0\) with helper union of size
\(\rho_P(I)\), a nonzero minimum word \(v\in I^\perp\), and a nonzero
functional \(\ell\in(\mathbb F_q^P)^*\). In any other block, add

\[
 a\longmapsto\ell(a)v
\]

to \(s_0\). Embedded inner-dual words belong to the concatenated dual, the
restriction on \(P\) remains the identity, and the exact helper union has size
\(\rho_P(I)+d(I^\perp)\). This is a non-confined coefficient scheme.

### Sufficiency after outer growth

For any splitting, apply the inner encoder in each block to every row and
collect the induced block-functional tuples. If one tuple is nonzero, its
block support is at least the outer dual distance. A splitting using at most
\(r\) helper coordinates meets at most \(r\) external blocks and its one target
block. Thus all such tuples vanish once \(d(O_N^\perp)>r+1\), independently
of \(\lvert P\rvert\).

The splitting then decomposes blockwise into inner-dual maps. Its target-block
part is itself a splitting, so its target-block helper union has size at least
\(\rho_P(I)\). If the original splitting is not confined, at least one other
block contains a nonzero inner-dual word and hence contributes at least
\(d(I^\perp)\) disjoint helper coordinates. Therefore every non-confined
zero-functional splitting costs at least
\(\rho_P(I)+d(I^\perp)\).

### One-target reduction

For \(P=\{x\}\),

\[
 \rho_{\{x\}}(I)
 =
 \min\{\operatorname{wt}(u):u\in I^\perp,\ u_x\neq0\}-1.
\]

Hence

\[
 r<\rho_{\{x\}}(I)+d(I^\perp)
 \quad\Longleftrightarrow\quad
 r+1<z_x(I),
\]

exactly recovering the present theorem.

## Rank hierarchy: refinement, not the confinement gate

Let \(D=I^\perp\), let \(s=\lvert J\rvert-1\) be the number of external
blocks, and stratify a zero-functional non-confined splitting by the rank
\(t\) of its external perturbation

\[
 T:\mathbb F_q^P\longrightarrow D^{\oplus s}.
\]

For \(0\leq a\leq\dim D\), write \(d_a(D)\) for the \(a\)-th generalized
Hamming weight, with \(d_0(D)=0\). The exact external union-support cost is

\[
 \delta_t^{(s)}(D)
 =
 d_t(D^{\oplus s})
 =
 \min_{\substack{t_1+\cdots+t_s=t\\
                  0\leq t_i\leq\dim D}}
 \sum_{i=1}^s d_{t_i}(D).
\]

The first equality is the definition applied to the image of \(T\). For the
second, intersect any \(t\)-dimensional subcode of \(D^{\oplus s}\) with the
successive coordinate-block filtration to obtain dimensions \(t_i\); its
support in block \(i\) is at least \(d_{t_i}(D)\). Conversely, direct sums of
subcodes attaining the \(d_{t_i}(D)\) attain the displayed sum.

Therefore the exact rank-\(t\) zero-functional obstruction is

\[
 \rho_P(I)+\delta_t^{(s)}(I^\perp).
\]

For fixed \(t\) this stabilizes once \(s\geq t\) to the subadditive envelope

\[
 \delta_t^{(\infty)}(D)
 =
 \min_{\substack{t_1+\cdots+t_a=t\\t_i\geq1}}
 \sum_{i=1}^a d_{t_i}(D).
\]

Ordinary generalized weights suffice for this pure external stratum; relative
weights may enter only after imposing an additional target/external coupling.
Rank one gives \(\delta_1^{(s)}(D)=d(D)\), so it already creates a distinct
non-confined splitting and controls the yes/no confinement threshold. The
hierarchy is useful for enumerators or requirements on several independent
external perturbations, not for the basic gate.

## MacWilliams/LP boundary

The first proposed normalized enumerator is already contained in the refined
support distribution of Gruica--Jany--Ravagnani:

\[
 A_{x,j}
 =
 \#\{u\in C^\perp:u_x=1,\
 |\operatorname{supp}(u)\setminus\{x\}|=j\}
 =
 \frac{1}{q-1}W_{j+1}^{\{x\}}(C^\perp).
\]

Their MacWilliams-type identity therefore handles this first-order count.
New constraints would have to retain joint equations, intersection patterns,
projective coefficient data, or minimality. The Boolean reliability event and
minimal-support antichain are nonlinear and do not automatically admit a
MacWilliams transform.

## Bandwidth boundary

For scalar \(\mathbb F_q\)-symbols, the minimum downloaded
\(\mathbb F_q\)-dimension equals helper support size. A nontrivial bandwidth
threshold requires a vector-code model with fixed subpacketization, allowed
helper response maps, and centralized/cooperative/access/rack conventions.
Even one-target schemes then correspond to spaces of checks. This remains a
separate sequel rather than an unproved strengthening of C946.

## Literature verdict

The durable source-by-source audit is
`notes/2026-08-22-c946-multitarget-recovery-literature-audit.md`.

The intrinsic existence criterion is prior art more exactly than the initial
scout recorded.  Abdel-Ghaffar--Weber, Definition 1 and Lemmas 1--2, use the
same kernel condition, generator-column span condition, and existence of
\(|P|\) normalized dual rows supported on the targets and one common helper
set.  C946's restricted-dual surjection is a basis-free restatement.  The new
structural refinement is the *complete affine family* of splittings and its
helper-supported gauge ambiguity, not simultaneous recovery itself.

Chaiken's primary 1989 text was read at the relevant sections.  His
\(P\)-ported Tutte polynomial is the established arbitrary-distinguished-set
carrier, and he explicitly relates its set-pointed specialization to Las
Vergnas perspectives.  The \(Z^0\) recovery slice below is therefore an
author-derived specialization of prior machinery, not a new invariant.

Generalized weights in cooperative locality are prior by Abdel-Ghaffar--Weber,
including the bound \(r\ge d_{|P|}(C^\perp)-|P|\).  The first-order enumerator
below is contained in Gruica--Jany--Ravagnani.  The bounded audit located no
predecessor for the combined exact finite map-valued cost and sharp eventual
coefficient-aware concatenation threshold.  That result is `NONE-FOUND`
candidate novelty, never a categorical priority claim.

### Literature state used at start

- Chaiken, *The Tutte polynomial of a ported matroid*, JCTB 46 (1989),
  96--117, DOI 10.1016/0095-8956(89)90010-5: abstract, Sections 1 and 3,
  Theorem 2, definition (3.4), and Section 4 Example 3 read from the
  author-uploaded browser full text.
- Gruica--Jany--Ravagnani, *LRCs: Duality, LP Bounds, and Field Size*, DCC 94
  (2026), article 100, DOI 10.1007/s10623-026-01829-7: abstract,
  introduction, Definitions 2.9 and 3.2, Proposition 3.5, and Theorem 3.8 read
  from cached SHA-256
  555c0586dd3017cf5317ef6c73818f3764c1a5d6b8b1ea4b82c1c75d10ec6863.
- Rawat--Mazumdar--Vishwanath, *Cooperative Local Repair in Distributed
  Storage*, arXiv:1409.3900v2: abstract and introduction read from cached
  SHA-256
  8e71095933dff7b4c083b47fa52f5ae8bafb85b8fd4e649121dc84ee26975037.
- Alfarano--Ravagnani--Soljanin, *Dual-Code Bounds on Multiple Concurrent
  (Local) Data Recovery*, arXiv:2201.07503v2: abstract, introduction, and
  recovery-system definitions read from cached SHA-256
  75dfdc9b233c2f091e987790b6cff029551b59d0289d85f0b9b3d8b30a712bbc.

## Acceptance gates

1. Prove the four intrinsic recovery criteria equivalent, including the affine
   splitting description.
2. Prove the exact finite map-valued cost formula, not only the eventual bound.
3. Prove or refute the boxed eventual threshold and its one-target reduction.
4. Determine the correct rank-refined support costs and whether ordinary or
   relative generalized weights suffice.
5. Compare the full-radius target-set invariant directly with Chaiken and with
   the Las Vergnas perspective \(M\setminus P\to M/P\). **Complete.**
6. Give at least one finite counterexample preventing an overstrong scalar or
   MacWilliams claim.
7. Run independent mathematical and operational cold reads before proposing a
   manuscript or Lean task.

## Immediate next work

- run independent mathematical and storage-operational cold reads of the human
  proof packet;
- sharpen the all-singleton-marginals counterexample search only if the cold
  readers judge it material;
- after those gates, decide whether to queue a separate manuscript and Lean
  theorem task.

## First exhaustive check

The deterministic script notes/scripts/c946_multitarget_check.py exhausts all
67 binary subspaces of \(\mathbb F_2^4\), every nonempty target set, and every
disjoint helper set. Across 4,355 triples \((C,P,H)\), of which 1,489 are
recoverable, it verifies:

- the kernel criterion is equivalent to surjectivity of the restricted dual;
- every standard-basis fiber has the kernel cardinality, so the number of
  splittings is the predicted affine-space cardinality; and
- for every recoverable singleton target, \(\rho_{\{x\}}\) is the least dual
  weight through \(x\), minus one.

It also checks the concatenation of the binary length-three repetition inner
code with outer single-parity-check codes of lengths \(N=2,3,4,5\), using the
two-coordinate target \(P=\{0,1\}\) in the first block. Here

\[
 \rho_P(I)=1,\qquad d(I^\perp)=2,
\]

so the eventual zero-functional threshold is \(3\). Exhaustive enumeration of
all normalized two-row splittings gives

\[
 (\text{minimum confined cost},\text{minimum non-confined cost})
 =
 (1,1),(1,2),(1,3),(1,3)
\]

for \(N=2,3,4,5\), respectively. Thus the finite obstruction is
\(\min(N-1,3)\): the nonzero outer-functional branch costs \(N-1\) before the
zero-functional branch takes over, exactly as the map-valued formula predicts.

The same script finds a nondegenerate first-order MacWilliams counterexample
in length five. Let

\[
 C_1=\langle(1,1,0,1,0),(0,0,1,0,1)\rangle,\qquad
 C_2=\langle(0,1,0,1,0),(1,0,1,0,1)\rangle.
\]

Both are binary dimension-two codes. At \(x=0\), their normalized dual-word
counts by helper weight \(j=0,\ldots,4\) are identically

\[
 (A_{x,0},\ldots,A_{x,4})=(0,2,0,2,0).
\]

For the two-coordinate target \(P=\{0,1\}\), however,

\[
 \rho_P(C_1)=1,\qquad \rho_P(C_2)=2.
\]

Thus even equal dimension plus the complete first-order normalized weight
enumerator at \(x\) does not determine the simultaneous recovery cost for a
target set containing \(x\). This is the required finite obstruction to
promoting the existing first-order MacWilliams transform directly to the
multi-target structure.

The script also searches all nondegenerate binary length-five codes for the
stronger phenomenon in which the normalized weight enumerators agree at every
labeled singleton coordinate while \(\rho_{\{0,1\}}\) differs. No such pair
occurs at this size. This bounded negative result prevents the present
counterexample from being overstated; the all-singleton-marginals question
remains open beyond the tested range.

## TT pass: structural compression and opportunities

### The support layer is matroid closure

Let \(M=M(C)\) be the column matroid of a generator matrix of \(C\). The
intrinsic criterion has the basis-free support form

\[
 H\text{ recovers }P
 \quad\Longleftrightarrow\quad
 P\subseteq\operatorname{cl}_M(H)
 \quad\Longleftrightarrow\quad
 r_M(H\cup P)=r_M(H).
\]

Thus \(\rho_P(C)\) is the minimum size of a set disjoint from \(P\) that spans
\(P\). The complete support-only target-set structure is already matroidal;
the represented information resides in the actual affine space of splittings.

If \(H\) recovers \(P\), then

\[
 \dim(C^\perp\cap\mathbb F_q^H)=|H|-r_M(H),
\]

and therefore the number of normalized recovery-equation splittings supported
in \(P\cup H\) is

\[
 q^{\,|P|(|H|-r_M(H))}.
\]

The cardinality is matroidal once \(q\) is fixed, even though the represented
coefficient maps themselves need not be.

### Full-radius reliability already has a Las Vergnas carrier

Assume \(P\) is recoverable from \(E\setminus P\), set
\(D=M\setminus P\), \(Q=M/P\), and for
\(A\subseteq E\setminus P\) put

\[
 \epsilon_P(A)=r_M(A\cup P)-r_M(A).
\]

Then \(A\) recovers \(P\) exactly when \(\epsilon_P(A)=0\). In the Las Vergnas
perspective polynomial of \(D\to Q\), the \(Z\)-exponent is
\(\epsilon_P(A)\); hence the \(Z^0\) slice is precisely the full-radius
simultaneous-recovery enumerator. Chaiken's ported-matroid polynomial may
retain a richer labeled boundary algebra, but it is not needed merely to
obtain target-set reliability. Its exact added information must be checked
from the primary paper rather than inferred from its title.

### MDS specialization

For an \([m,k]\) MDS inner code and a nonempty target set \(P\) with
\(m-|P|\geq k\), the column matroid is uniform, so

\[
 \rho_P(I)=k,\qquad d(I^\perp)=k+1.
\]

Consequently every such target set has the same eventual coefficient-
confinement threshold

\[
 r<2k+1.
\]

The number of erased target coordinates affects the number \(m-|P|\) of
available helpers but not the first non-confined coefficient cost. Full-radius
success is simply the event that at least \(k\) helpers survive. This is a
clean multi-erasure extension of the paper's one-target MDS calculation.

### Relation to established locality notions

The framework does not place locality, availability, \((r,\delta)\)-locality,
and cooperative locality in a literal inclusion chain. Instead it supplies
the fixed-demand predicate \(P\subseteq\operatorname{cl}(H)\):

- ordinary locality fixes \(|P|=1\);
- cooperative locality quantifies over all target sets of a prescribed size;
- \((r,\delta)\)-locality requires the predicate for every erased subset of
  size at most \(\delta-1\) inside one local group; and
- availability asks for several suitably disjoint witnesses \(H\).

This quantifier view is the precise unification.

### Further abstraction exposed but not adopted

Nothing in the splitting or transfer proof requires \(A\) to be the full
coordinate space \(\mathbb F_q^P\). The same argument applies to a finite
linear demand space of coordinate functionals. This would unify recovery of
target coordinates, partial linear queries, and rank-restricted demands.
It is a genuine sequel opportunity, but adopting it now would obscure the
operational multi-erasure theorem.

## Mystery ledger

- **Settled by TT:** a hierarchy is not needed for the basic confinement gate.
  Rank one gives the sharp scalar threshold; generalized weights stratify
  stronger rank demands.
- **Settled by TT:** the support layer is exactly the closure predicate
  \(P\subseteq\operatorname{cl}(H)\), and full-radius reliability is the
  \(Z^0\) slice of \(M\setminus P\to M/P\).
- **Settled by TT:** for MDS inner codes the threshold is \(2k+1\), independent
  of \(|P|\) whenever at least \(k\) helper coordinates remain.
- **Settled negatively:** the proposed \(A_{x,j}\) transform is already
  contained in the 2026 refined-support MacWilliams identity; the finite pair
  above shows that one fixed-coordinate marginal does not determine
  simultaneous recovery.
- **Settled by literature audit:** Chaiken's arbitrary distinguished-set
  invariant and its Las Vergnas specialization are prior carriers; the exact
  coefficient splittings and concatenation gate are not attributed to them.
- **Open, bounded evidence gap:** no length-five binary pair was found with all
  labeled singleton marginals equal and different two-target cost. Existence
  over larger fields or lengths is untested.
- **Open gate:** the exact finite map-cost theorem, direct-sum generalized-
  weight lemma, and Las Vergnas target-set specialization need independent
  mathematical and operational cold reads before manuscript or Lean adoption.
- **Owned elsewhere:** bandwidth-aware transfer needs a separately specified
  vector/subpacketized repair model; it is not an ambiguity in C946.
