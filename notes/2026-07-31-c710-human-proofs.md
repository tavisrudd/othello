# C710 human proofs — McKay, Hamming, and the hyperbolic repair

**Lane:** clebsch

**Date:** 2026-07-31

**Companion to:** notes/2026-07-30-c710-e8-hamming-marking.md

## 1. The bare \(E_8\) identification

For the binary icosahedral group, tensoring irreducibles with its natural
two-dimensional representation gives the affine \(E_8\) McKay graph.
The affine Cartan form is \(2I-\operatorname{Adj}\).  The dimension vector
\[
 \delta=(1,2,3,4,5,6,3,4,2)
\]
lies in its radical because
\(2\dim\rho=\sum_{\sigma\sim\rho}\dim\sigma\).  The affine coefficient is
one, so quotienting by \(\mathbf Z\delta\) leaves the eight nontrivial
vertices as an integral basis with finite \(E_8\) Cartan Gram matrix.

Now let
\[
 E(H_8)=\{x/\sqrt2:x\in\mathbf Z^8,\ x\bmod2\in H_8\},
\]
where \(H_8=\operatorname{RM}(1,3)\).  Every displayed numerator in the
C710 table either is even or reduces to a weight-four Hamming word, so it
belongs to \(E(H_8)\); its norm is two.  Taking pairwise dot products and
dividing by two gives exactly the finite McKay Cartan matrix.  Its
determinant is one, hence these eight roots span the whole unimodular
Hamming lattice, not a proper sublattice.

The affine relation in the McKay quotient forces
\[
 \alpha_0=-\sum_{\rho\ne1}\dim(\rho)\alpha_\rho.
\]
Substitution gives
\((-1,0,0,-1,0,1,1,0)/\sqrt2\), the root printed in the report.  This
proves the complete affine marking and the bare isometry.

## 2. Why no two-coordinate \(R_{10}\) minor is Hamming

Deletion and contraction of a binary matroid are puncturing and
shortening of its code.  Two operations give exactly three types:
puncture--puncture, shorten--puncture, and shorten--shorten.  The
two-transitive node action makes the first and third single orbits of
\(45\) pairs; ordered mixed operations form one orbit of size \(90\).
Thus one representative of each type determines all \(180\) marked
minors.

Row reduction and direct word counting on those representatives give
\[
\begin{array}{c|c|l}
PP&[8,5,2]&2y^2+8y^3+10y^4+8y^5+2y^6+y^8\\
SP&[8,4,3]&4y^3+5y^4+4y^5+2y^6\\
SS&[8,3,4]&5y^4+2y^6.
\end{array}
\]
None has dimension four and enumerator \(1+14y^4+y^8\), so none is
\(H_8\).

There is also a conceptual obstruction.  \(R_{10}\) is regular, and
regularity is minor-closed.  A contraction of the affine geometry behind
\(H_8\) contains the Fano matroid, which is not regular.  Therefore no
\(R_{10}\) minor can be the Hamming matroid.  The table strengthens this
unmarked argument to the exact frozen-coordinate statement.

## 3. Why no equivariant rank-eight carrier exists

On the ten \(3+3\) partitions, \(S_6\) is two-transitive.  Therefore its
permutation endomorphism algebra has dimension two, spanned by \(I\) and
the all-one matrix.  Over \(\mathbf Q\), the augmentation is consequently
irreducible:
\[
 \mathbf Q^{10}=\mathbf1\oplus[4,2]
\]
with dimensions \(1+9\).  Submodules and quotients can only have
dimensions \(0,1,9,10\).

For the conference \(S_5\), the ten nodes are the two-subsets of five
letters.  The Petersen adjacency operator has eigenvalues
\(3,1,-2\) with multiplicities \(1,5,4\), splitting the rational module
as
\[
 \mathbf1\oplus\mathbf5\oplus\mathbf4.
\]
The constituents remain irreducible on the golden \(A_5\).  Possible
invariant dimensions are therefore sums of \(1,4,5\), namely
\[
 0,1,4,5,6,9,10.
\]
Eight never occurs.  Hence no alternative equivariant projection or
quotient can evade the marked code obstruction.

## 4. Why \(Q_{10}\) contains no \(E_8\)

Construction A from \(R_{10}\) has exactly two types of norm-two vector:
\[
 \pm2e_i/\sqrt2
\]
and the half-integral sign vectors supported on a weight-four codeword.
There are \(20+15\cdot16=260\) roots.  Coordinate signs and
\(\operatorname{Aut}(R_{10})\cong S_6\) are transitive on each of the two
types.

Any embedded \(E_8\) root lattice contains a simple system whose Gram
graph is the \(E_8\) Dynkin diagram.  Choose the first root from one of the
two orbits, then add roots in Dynkin-tree order.  At each step, the
required inner products with the already chosen roots are \(0\) or
\(-1\); these conditions give a complete finite candidate list.  Branching
on that list exhausts every simple system up to the two initial orbits and
finds none.  Because every possible embedding supplies such a simple
system, the exhaustive tree proves
\[
 E_8\not\hookrightarrow Q_{10}.
\]
This is an unmarked obstruction, independent of the code-minor and
representation arguments.

The earlier warning is elementary.  \(R_{10}\) contains two words with
odd support intersection.  Their Construction-A lifts have half-integral
inner product.  Thus \(Q_{10}\) is isodual and covolume one but not
integral, whereas the doubly-even self-dual Hamming code gives an even
integral unimodular lattice.

## 5. The prime comparison

Both Cartan Gram matrices have determinant one, so nothing degenerates at
\(3\) or \(5\).  The prime \(3\) in C705 comes from the scalar \(6\) in
the fourth compound, and the prime \(5\) from the golden splitting.
At \(2\), by contrast, code type matters: self-dual doubly-even \(H_8\)
produces positive-definite \(E_8\), while merely isodual \(R_{10}\)
produces the nonintegral \(Q_{10}\).  This proves that the shared prime
labels do not constitute a simultaneous marking.

## 6. Why the correct repair is hyperbolic

Let \(L=L_{R_{10}}\) and identify \(L^*=L_{R_{10}^\perp}\).  On
\[
 \mathbb H(L)=L\oplus L^*
\]
define
\[
 \langle(x,f),(y,g)\rangle=f(y)+g(x).
\]
In dual bases its Gram matrix is
\[
 \begin{pmatrix}0&I\\I&0\end{pmatrix}.
\]
It is integral, even, unimodular, and has signature \((10,10)\);
therefore it is \(II_{10,10}\).  This derivation is more informative than
invoking uniqueness alone: the two code sisters are its two maximal
isotropic halves.

An isoduality \(P:L\to L^*\) defines
\[
 J_P(x,f)=((P^*)^{-1}f,Px).
\]
Applying this twice shows \(J_P^2=1\) exactly when \(P=P^*\).  For
coordinate isodualities, self-adjointness says precisely that the
duad--syntheme exchange permutation is an involution.  Hence it cuts the
\(720\)-element isoduality torsor to C708's \(36\) polarities.

Each such permutation has cycle type \(2^5\).  Its \(+1\) and \(-1\)
eigenspaces on the node space both have dimension five.  The graphs of
\(P\) and \(-P\) in the hyperbolic double inherit signature \((5,5)\).
The conference marking restricts the self-adjoint locus to the six
\(F_{20}\)-stabilized members.  Thus the finite polarity theorem is
recovered intrinsically from adjointness of lattice exchange.

The three negative attacks close different escape routes—marked minors,
equivariant linear projection, and arbitrary root embedding—while the
hyperbolic construction supplies the exact positive replacement.  This
proves every C710 result without conflating the bare McKay--Hamming
isometry with a nonexistent simultaneous Clebsch marking.

## Terry-Tao pass

The right dichotomy is self-duality versus isoduality, not “two ways to
obtain \(E_8\).”  Self-duality puts the form on one positive-definite
Construction-A lattice; isoduality naturally produces a pair of dual
isotropic halves.  Once this is recognized, \(II_{10,10}\) and the
self-adjointness condition on exchanges are forced.

The three negative arguments are logically independent and should remain
so: regular matroid minors obstruct the marked code route, rational
representation theory obstructs every equivariant rank-eight route, and
the root search obstructs even an unmarked lattice embedding.  The TT pass
therefore resists compressing them into one “no \(E_8\)” computation.
The finite root search is complete because any embedding contains a simple
system and the automorphism group reduces its first root to two orbits.
A possible stronger theorem would replace that last search by a conceptual
discriminant or root-configuration obstruction, but no such invariant is
currently sharper than the complete two-orbit backtracking proof.
