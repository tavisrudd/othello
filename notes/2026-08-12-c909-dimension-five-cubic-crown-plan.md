# C909 — dimension-five cubic crown: the finite theorem that closes the epilogue

Date: 2026-08-12

Status: structural synthesis of proved low-width theorems; the actual
six-axis specialization has passed two independent hostile/priority audits.
No manuscript, PDF, mirror, or Lean edit.

## Crown choice

The correct top-level result is not an unbounded-rank Dyck formula.  Cubic
intermediate Jacobians have dimension five, and in dimension five every
cohomological degree has squarefree width at most two:
\[
 \min(k,5-k)\le2\qquad(0\le k\le5).
\]
Consequently the complete integral Hodge-versus-ordinary-divisor-product
quotient is governed by the two- and four-slot contractions.  No six-slot
certificate and no arbitrary-width osculating theorem is needed.

For a one-depth finite-etale rank-five graph of depth \(p^a\), the proved
low-width theorem specializes to
\[
 \operatorname{Hdg}^{2k}(A,\mathbf Z_p)/P_A^k\cong
 \begin{cases}
  (\mathbf Z/p^a)^5,&k=2,3,\\
  0,&k=0,1,4,5.
 \end{cases}
\tag{1}
\]
The proof is human and uniform at \(p=2\).  It decomposes by coefficient
multidegree; supports of size at most two are saturated, and each four-set
contributes the single Pluecker quotient \(\mathbf Z/p^a\).  In degree two
there are \(\binom54=5\) such four-sets.  In degree three, each is copied
primitively by the unique doubled complementary slot.  Degrees four and five
have no four-slot residual support.  This is direct exterior algebra, not
Poincare duality and not a finite census.

## Relation to the finite-etale PD theorem

The same graph presentation has
\[
 \operatorname{PD}\langle\operatorname{NS}(A)\rangle^k=P_A^k
 \quad(0\le k\le5),
\tag{2}
\]
so every divided power of the principal polarization is an ordinary divisor
product.  Equations (1) and (2) show that this conclusion is sharp in a new
sense: the minimal class is product-generated even though the ambient
integral Hodge lattice has an exact nonzero defect in the two middle degrees.

For a cubic threefold \(X\) in the marked finite-etale Hecke locus, the
separate full-PD theorem gives
\[
 \Theta_{J(X)}^{[4]}\in P^4
 \Longrightarrow X\text{ is universally }CH_0\text{-trivial}
\]
by Voisin, while the independent atom theorem gives
\(X\times\mathbf P^1\) irrational.  This is the clean two-certificate
separation theorem. The rank-five quotient (1) is a sharp neighboring
theorem: it explains the integral geometry around the certificate rather
than merely supplying it. It is **not** the numerical quotient of the actual
six-axis packet, whose local source lattice is a unit line plus a depth-one
rank-four block at both bad primes.

## Strongest paper architecture

The epilogue should therefore have three structural layers.

1. **Marked finite-etale PD theorem, arbitrary dimension.**  Rank-one
   generation of the permitted graph divisor lattice gives all divided
   powers as ordinary products.
2. **Complete rank-five ambient theorem.** On the one-depth finite-etale
   rank-five locus, the full Hodge/product Smith quotient is (1); this is the
   dimension selected by cubic intermediate Jacobians and is entirely
   certificate-free.
3. **Two geometric outputs.** Independently, the explicit six-axis pencil lands in the
   marked Hecke condition and hence is universally \(CH_0\)-trivial; every
   smooth cubic has irrational one-step stabilization by the atom theorem.

The higher-rank osculating/conformal-block problem then becomes a genuine
successor theorem rather than a weakness in the paper.  Its complex rank
filtration is standard conformal-block theory, and its integral primitive
Smith form is the next modular question.  Nothing in the epilogue depends on
it.

## Remaining exact work before promotion

1. State the rank-five theorem for the actual allowed block-depth graph
   lattice, not only a single equal-depth irreducible block.
2. Compute the local rank-five quotient of the actual \(6I-J\) six-axis
   packet at two and three, keeping the unit direction and exotic/scalar
   blocks separate.
3. Decide whether the clean one-depth formula (1) should be the theorem and
   the six-axis packet only a corollary, or whether the actual packet admits
   an equally compact closed formula.
4. Red-team priority: the novelty is the exact ordinary divisor-product
   quotient and its coexistence with divided-power saturation, not the
   rational Hodge structure or the algebraicity of the minimal class alone.

## Mystery ledger

* **Settled:** finite-etale graph PD saturation in all degrees and the
  rank-five one-depth quotient (1).
* **Settled:** the cubic implication through Voisin and the independent
  one-step atom obstruction.
* **Two audits passed:** the exact multi-prime quotient for the actual
  six-axis polarization vanishes in every degree at generic non-CM fibres.
* **Successor, not epilogue gate:** arbitrary-rank Dyck-height Smith formula.

## Sharpening for the actual packet

The actual local slopes are less generic than the one-depth rank-five model.
At three the whole rank-four defect block is scalar.  At two, after
unramified splitting, it is the orthogonal sum of two scalar rank-two
eigenspaces, together with the unit line. The direct weighted four-slot
calculation forces the *ambient* Hodge/product quotient to vanish: on the only four-defect support, the cheap
within-eigenspace matching already absorbs the Pluecker cancellation which
creates the \(R/p\) class for four distinct slope roots. Supports containing
the unit line have the same cheap matching. Thus, at every non-CM fibre where
the rational Hodge lattice is the diagonal invariant lattice, the geometric
theorem strengthens from minimal-class saturation to
\[
 \operatorname{Hdg}^{2k}(J_b,\mathbf Z)=P_{J_b}^k
 \quad\text{for every }k
\]
on the six-axis family. Special fibres with extra Hodge tensors retain the
safe minimal-class conclusion, but equality with the enlarged full Hodge
lattice is not asserted there. This result is not a specialization of the
equal-depth formula: the repeated-root matrix-of-ideals calculation is
load-bearing. Two independent audits now pass; manuscript integration remains
a separate authorized task.
