# C649 — Full-Weyl rigidity for general stabilizer AME states

**Lane:** `ame-lu`

**Date:** 2026-07-25

**Status:** mathematical test positive; dimension core kernel checked;
manuscript promotion and claim-specific literature audit pending

## Result

The MDS/CSS hypothesis is not needed for the LU-to-LC rigidity mechanism.
The correct general statement is:

> Let \(q=p^e\), let \(m\geq2\), and let
> \(\lvert\psi\rangle,\lvert\phi\rangle\) be stabilizer
> \(\operatorname{AME}(2m,q)\) states for the same \(q\)-dimensional
> Pauli/Weyl error basis.  If, after a party permutation,
> \[
>   (U_1\otimes\cdots\otimes U_{2m})\lvert\psi\rangle
>      =e^{i\theta}\lvert\phi\rangle ,
> \]
> then every \(U_i\) normalizes the local projective Pauli/Weyl group.
> Hence every such LU equivalence is LC.

This includes arbitrary additive prime-power stabilizers.  The stabilizer
label space need not be \(\mathbb F_q\)-linear, the stabilizer phases need
not be equal, and the state need not arise from a CSS or classical MDS
construction.

The boundary \(m\geq2\) is sharp for this proof and conclusion about every
intertwiner factor.  At \(m=1\), a Bell pair has continuous non-Clifford
product-unitary automorphisms \(U\otimes\overline U\), and a two-factor
diagonal tensor does not intrinsically determine its axes.

## The support theorem

Let \(\mathcal S_\psi\) be the stabilizer group of a pure
\(\operatorname{AME}(2m,q)\) stabilizer state, and pass to its projective
Pauli-label group \(L\).  Then
\[
  |L|=q^{2m}.
\]
For a party set \(A\) of size \(m+1\), let
\[
  L(A)=\{\ell\in L:\operatorname{supp}(\ell)\subseteq A\}.
\]
Then:

1. \(|L(A)|=q^2\);
2. every nonidentity element of \(L(A)\) has support exactly \(A\); and
3. for every \(i\in A\), coordinate projection
   \[
      \operatorname{pr}_i:L(A)\longrightarrow P_i
   \]
   is a bijection onto the \(q^2\)-element local projective Pauli-label
   group \(P_i\).

### Proof by cardinality squeeze

Project \(L\) to the Pauli labels on the omitted \(m-1\) parties.  The
image has at most \(q^{2(m-1)}\) elements, so its kernel \(L(A)\) has
at least
\[
  q^{2m}/q^{2(m-1)}=q^2
\]
elements.

Fix \(i\in A\).  The kernel of
\(\operatorname{pr}_i:L(A)\to P_i\) consists of stabilizer labels
supported on \(A\setminus\{i\}\), a set of \(m\) parties.  The AME
condition makes every \(m\)-party reduction maximally mixed.  Orthogonality
of the Pauli basis therefore forbids any nonidentity stabilizer on at most
\(m\) parties.  Thus \(\operatorname{pr}_i\) is injective.  Since
\(|P_i|=q^2\), this gives \(|L(A)|\leq q^2\), proving equality and
bijectivity.

Equivalently, over the prime field the label Lagrangian has dimension
\(2me\).  Restriction to the omitted parties has a kernel of dimension at
least \(2e\), while injection to one retained \(2e\)-dimensional local
label space gives the reverse inequality.  This is the dimension squeeze
formalized in `StabilizerAMESupport.lean`.

## Full-Weyl marginal

The stabilizer projector expansion and partial trace give
\[
 \rho_A
   =q^{-|A|}
      \sum_{\ell\in L(A)}\widetilde W_\ell ,
\]
where \(\widetilde W_\ell\) is the chosen stabilizer lift of the projective
Weyl label \(\ell\).  Relative to a fixed Weyl convention it is a nonzero
scalar multiple of the corresponding product Weyl operator.  Stabilizer
phases therefore change only the nonzero diagonal coefficients.

Index \(L(A)\) by the local labels at one retained party.  The projection
bijections above turn the marginal into
\[
 \rho_A
   =\sum_{v\in P_i}\lambda_v
       W_v\otimes W_{f_2(v)}\otimes\cdots\otimes W_{f_{m+1}(v)},
 \qquad \lambda_v\ne0,
\]
where every \(f_j:P_i\to P_j\) is a bijection fixing the identity.
The maps \(f_j\) need not be \(\mathbb F_q\)-linear.  Axis recovery uses
only that they are bijections between full local Weyl bases.

Because \(m+1\geq3\), the rank-one contraction locus of this tensor is
exactly the union of its displayed coordinate axes.  A product-unitary
equivalence of two such marginals must therefore permute every local Weyl
axis.  Conjugation fixes the identity axis, so every local factor
normalizes the projective Weyl group and is Clifford.

Every party lies in an \((m+1)\)-set, completing the global LU-to-LC
argument.

## What the test removed

None of the following hypotheses is needed for rigidity:

- equal computational-basis phases;
- CSS form \(C\times C^\perp\);
- a linear classical code;
- the MDS shortening theorem;
- \(\mathbb F_q\)-linearity of the stabilizer label group; or
- odd characteristic.

Their role in the current paper is instead to supply explicit
classification coordinates, diagonal-isoduality, and exact logical
groups.  The general stabilizer-AME theorem broadens the LU-to-LC
headline, not the later code-geometric group dichotomy.

## Lean support

`RelativeConicArcs.AMELU.StabilizerAMESupport` proves the reusable
finite-dimensional kernel squeeze:

- `stabilizerAME_kernelToLocal_bijective`;
- `stabilizerAME_finrank_ker_eq_local`.

The input is an outside-coordinate restriction map and a one-site
projection from its kernel.  If the source dimension is the sum of the
outside and one-site dimensions, injectivity of the one-site projection
forces bijectivity and exact kernel dimension.  This applies over
\(\mathbb F_p\) to arbitrary additive \(q=p^e\) stabilizers.

The existing generic diagonal-tensor files already prove the independent
axis-recovery step for arbitrary finite index sets and nonzero
coefficients.  What is not yet formalized is the physics bridge from an
abstract additive stabilizer AME state to the supported-label kernel and
its reduced-density Weyl expansion.

## Literature reconnaissance

This was a mathematical test, not yet a claim-specific novelty audit.
Targeted arXiv/web searches on 2026-07-25 located the known qubit
LU--LC line and no exact qudit stabilizer-AME theorem.

For qubits, the result is already a consequence of the
Van den Nest--Dehaene--De Moor minimal-support criterion: the support
theorem above gives all three nonidentity Pauli labels at every party of
each minimum support.  Thus the qubit theorem and its axis mechanism are
not new.

The potentially new scope is the arbitrary prime-power qudit and additive
stabilizer extension.  The searches

```text
site:arxiv.org stabilizer absolutely maximally entangled local unitary local Clifford equivalence
site:arxiv.org stabilizer AME state automorphism local Clifford full Pauli support marginal
site:arxiv.org "AME stabilizer" "local unitary" Clifford
site:arxiv.org qudit stabilizer state local unitary local Clifford equivalence prime dimension
site:arxiv.org nonbinary stabilizer state "local unitary" "local Clifford"
site:arxiv.org additive quantum MDS stabilizer AME local equivalence Clifford
```

did not locate that statement.  This licenses no priority claim:
OpenAlex/zbMATH exhaustion, read-depth reconciliation, and the existing
C562 forward-citation closure have not yet been rerun for the enlarged
claim.

## Manuscript consequence

If the literature gate stays open, Theorem 1.1 can be promoted from
equal-phase MDS/CSS states to all stabilizer \(\operatorname{AME}(2m,q)\)
states for \(m\geq2\).  The present MDS/CSS theorem then becomes an
immediate corollary feeding the exact code and logical-group results.

The abstract and title would need only a hierarchy change, but Section 2
would need a general stabilizer-projector convention and Section 3 would
need the support theorem and arbitrary-bijection form of “full-Weyl
diagonal.”  The diagonal-isodual, pencil, and verification sections retain
their current scopes.

## Mystery ledger

| Mystery | Status | Evidence / next gate |
|---|---|---|
| Does the supported subgroup have exactly \(q^2\) elements? | resolved positively | cardinality squeeze above; Lean dimension core |
| Does every retained local projection cover the full Weyl basis? | resolved positively | AME excludes the projection kernel; equal finite cardinalities |
| Do arbitrary stabilizer phases spoil diagonality? | resolved negatively | they only multiply Weyl-basis coefficients by nonzero phases |
| Is \(\mathbb F_q\)-linearity required? | resolved negatively | prime-field/additive dimension argument and group-cardinality proof |
| Is \(m=1\) included? | resolved negatively and sharply | Bell-pair \(U\otimes\overline U\) automorphisms |
| Is the prime-power qudit theorem already in the literature? | open | claim-specific audit required before manuscript novelty wording |
| Is the full stabilizer-to-marginal bridge kernel checked? | open | build an additive stabilizer-state interface; current Lean checks the dimension and axis cores |
