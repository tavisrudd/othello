# C710 — McKay \(E_8\), Hamming \(E_8\), and the \(Q_{10}\) boundary

**Date:** 2026-07-30

**Lane:** `clebsch`

**Status:** complete; the bare \(E_8\) lattices are explicitly isometric,
but no simultaneous Clebsch marking exists.  The natural positive repair is
the hyperbolic \(Q_{10}\)-dual double, not positive-definite \(E_8\).

## Outcome

There is a canonical integral \(E_8\) lattice on the C682 side.  Take the
free lattice on the nine irreducible representations
\[
 1,2,3,4_s,5,6,3',4,2'
\]
of \(2.A_5\), with the affine McKay Cartan form
\[
 2I-\operatorname{Adj}(\widetilde E_8).
\]
Its radical is the dimension vector
\[
 (1,2,3,4,5,6,3,4,2).
\]
Because the affine coefficient is \(1\), quotienting by this radical leaves
the eight nontrivial vertices as an integral basis with the finite
\(E_8\) Cartan Gram matrix.

This McKay lattice is explicitly isometric to the Hamming Construction-A
model
\[
 E_8=\{x/\sqrt2:x\in\mathbf Z^8,\ x\bmod2\in H_8\},
\]
where \(H_8=\operatorname{RM}(1,3)\) is the doubly-even self-dual
\([8,4,4]\) code.  In numerator coordinates, the isometry is:

| McKay vertex | Hamming root numerator |
|---|---|
| \(2\) | \((2,0,0,0,0,0,0,0)\) |
| \(3\) | \((-1,-1,0,0,0,0,-1,-1)\) |
| \(4_s\) | \((0,2,0,0,0,0,0,0)\) |
| \(5\) | \((0,-1,-1,0,0,-1,1,0)\) |
| \(6\) | \((0,0,2,0,0,0,0,0)\) |
| \(3'\) | \((0,0,-1,-1,0,0,-1,1)\) |
| \(4\) | \((0,0,-1,1,-1,1,0,0)\) |
| \(2'\) | \((0,0,0,0,2,0,0,0)\) |

Their pairwise inner products are exactly the finite McKay Cartan matrix,
and its determinant is \(1\), so these roots form a full \(E_8\) basis.
The omitted affine root is also explicit:
\[
 \alpha_0=(-1,0,0,-1,0,1,1,0)/\sqrt2
 =-\sum_{\rho\ne1}\dim(\rho)\alpha_\rho.
\]
Thus the bare McKay--Hamming lattice gate is fully positive.

The stronger simultaneous-marking gate is negative by three independent
obstructions.

## First obstruction: no Hamming minor of \(R_{10}\)

Use the frozen \(R_{10}\) presentation of the C705
\([10,5,4]\) parity code.  Every two-coordinate code minor falls into one
of only three parameter classes:

| operation | count | parameters | nonzero weight enumerator |
|---|---:|---:|---|
| puncture twice | \(45\) | \([8,5,2]\) | \(2y^2+8y^3+10y^4+8y^5+2y^6+y^8\) |
| shorten once, puncture once | \(90\) | \([8,4,3]\) | \(4y^3+5y^4+4y^5+2y^6\) |
| shorten twice | \(45\) | \([8,3,4]\) | \(5y^4+2y^6\) |

None is the extended Hamming code, whose enumerator is
\[
 1+14y^4+y^8.
\]
Structurally, this was forced: \(R_{10}\) is regular and every deletion or
contraction minor remains regular, whereas contracting one affine point
of the extended-Hamming matroid produces the Fano matroid.  The exhaustive
table supplies the exact marked version of that obstruction.

## Second obstruction: no equivariant rank-eight carrier

The ten-node rational permutation module for the full outer \(S_6\) action
is
\[
 \mathbf Q^{10}\cong\mathbf1\oplus[4,2],
\]
with irreducible augmentation dimension \(9\); exact two-transitivity
checks this decomposition.  Its invariant subspace and quotient dimensions
are therefore only
\[
 0,1,9,10.
\]

Restriction to the conference \(S_5\) gives the Petersen permutation
module
\[
 \mathbf Q^{10}\cong\mathbf1\oplus\mathbf4\oplus\mathbf5.
\]
The exact orbital adjacency has eigenvalues \(3,1,-2\) with multiplicities
\(1,5,4\), so its possible invariant dimensions are
\[
 0,1,4,5,6,9,10.
\]
The same irreducible dimensions remain on the golden \(A_5\).  Hence there
is no \(S_6\)-, conference-\(S_5\)-, or golden-\(A_5\)-equivariant
rank-eight subspace or quotient of the node carrier.  A simultaneous
lattice marking cannot evade the code-minor obstruction by using a
different rational projection.

## Third obstruction: \(Q_{10}\) contains no \(E_8\) root subsystem

Dropping equivariance does not repair the bridge.  The Construction-A
\(Q_{10}\) lattice has \(260\) norm-two roots:

- \(20\) coordinate roots \(\pm2e_i/\sqrt2\);
- \(240\) roots obtained from the fifteen weight-four words and their
  sign choices.

These are the two root orbits under coordinate signs and the
\(S_6\)-automorphism group of \(R_{10}\).  Exhaustive backtracking from one
representative of each orbit finds no eight roots with the \(E_8\) simple
Gram matrix.  Any embedded \(E_8\) would contain such a simple system, so
\[
 E_8\not\hookrightarrow Q_{10}
\]
even as an unmarked root sublattice.

There is an earlier integrality warning as well.  Although \(R_{10}\) is
isodual, it is not self-orthogonal.  Two certified codewords have odd
support intersection, giving a half-integral inner product between their
Construction-A lifts.  Thus \(Q_{10}\) is covolume-one and isodual but not
integral.  This is categorically different from the doubly-even self-dual
Hamming construction.

## Bad-prime comparison

The lattice calculation separates the primes cleanly.

- At \(2\), the distinction is real: Hamming self-duality produces one
  even integral unimodular lattice, while \(R_{10}\) is only isodual and
  produces the nonintegral \(Q_{10}\).
- At \(3\), both \(E_8\) Cartan Gram models remain unimodular.  C705's
  characteristic-\(3\) failure belongs to the scalar-\(6\) compound
  extraction, not the lattice.
- At \(5\), both \(E_8\) Gram models again remain unimodular.  The bad prime
  belongs to the golden eigenspace/sign lift, not an \(E_8\) discriminant.

Thus no \(2,3,5\) coincidence upgrades the bare isometry to a simultaneous
operator marking.

## `aa`: three independent attacks

The negative does not rest on one chosen presentation.

1. **Code/minor attack:** every marked two-coordinate reduction of
   \(R_{10}\) misses \(H_8\).
2. **Representation attack:** the ten-node module has no rank-eight
   equivariant section or quotient under \(S_6\), \(S_5\), or \(A_5\).
3. **Root-lattice attack:** even without marking or equivariance,
   \(Q_{10}\) has no \(E_8\) root subsystem.

The three attacks have different inputs and close respectively the
coordinate, equivariant-linear, and arbitrary-lattice escape routes.

## `tt`: the correct stable lattice

The failure points to a natural replacement.  Put
\[
 L=\operatorname{ConstructionA}(R_{10}),\qquad L^*=L_{R_{10}^\perp}.
\]
On \(L\oplus L^*\), define
\[
 \langle(x,f),(y,g)\rangle=f(y)+g(x).
\]
In dual bases its Gram matrix is
\[
 \begin{pmatrix}0&I_{10}\\I_{10}&0\end{pmatrix}.
\]
Hence it is even unimodular of signature \((10,10)\), and therefore is the
hyperbolic lattice \(II_{10,10}\).

An isoduality \(P:L\to L^*\) gives the exchange isometry
\[
 J_P(x,f)=((P^*)^{-1}f,Px).
\]
It is involutive exactly when \(P=P^*\).  For the coordinate isodualities,
these are precisely C705's \(36\) fixed-point-free \(W_{10}\) polarities,
not all \(720\) members of the exchange torsor.  Their cycle type \(2^5\)
gives five \(+1\) and five \(-1\) directions, so the fixed and anti-fixed
graph lattices both have signature \((5,5)\).  The golden six are exactly
the \(F_{20}\)-marked members of this self-adjoint locus.

This explains the exact self-dual/isodual distinction:

- \(H_8=H_8^\perp\) puts the integral unimodular form on one
  positive-definite Construction-A lattice \(E_8\);
- \(R_{10}\simeq R_{10}^\perp\), but \(R_{10}\ne R_{10}^\perp\), supplies
  a torsor of exchanges between two dual halves;
- self-adjoint members of that torsor, rather than arbitrary
  isodualities, give the \(36\) involutory polarities;
- the canonical integral carrier is consequently their hyperbolic double,
  not either half alone.

Thus \(Q_{10}\), its dual, and \(II_{10,10}\) are the nearer lattice
parents of the \(W_{10}\) sister exchange.  The McKay--Hamming \(E_8\)
isometry remains a genuine but unmarked parallel.

## `ej` closeout

The first extra-juice pass completed the finite McKay diagram by recovering
the affine Hamming root from the \(2.A_5\) dimension vector.  It also
separated an abstract lattice isometry from transport of C682's operator
data: the group acts inside covariant multiplicity spaces, whereas the
McKay root lattice records irreducible classes.

The alternative attacks then closed all natural \(Q_{10}\to E_8\) escape
routes.  The final extra-juice pass identified why the tempting analogy
fails and what replaces it: self-duality gives positive \(E_8\), while
mere isoduality gives a dual-pair torsor whose canonical integral
realization is hyperbolic.

The second-order extra-juice pass sharpens the repair: hyperbolic doubling
does not make all \(720\) isodualities involutions.  The adjoint condition
\(P=P^*\) cuts out exactly the \(36\) polarity class, and their
fixed/anti-fixed graph lattices have signature \((5,5)\).  Thus the
finite polarity selection reappears intrinsically as self-adjointness of
the lattice exchange.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| Are the McKay and Hamming \(E_8\) lattices explicitly isometric? | settled positively by the displayed simple roots and determinant-one Gram equality | none |
| Does the affine McKay vertex survive the marking? | settled: its dimension-vector relation gives the displayed Hamming root | none |
| Can \(R_{10}\) reduce to \(H_8\) by two marked coordinates? | settled negatively for all \(180\) deletion/contraction choices | none |
| Can another equivariant rank-eight projection carry the node geometry? | settled negatively under \(S_6\), conference \(S_5\), and golden \(A_5\) | none |
| Can an unmarked \(E_8\) embed in \(Q_{10}\)? | settled negatively by exhaustive search over both root orbits | none |
| Why does \(Q_{10}\) fail while \(H_8\) succeeds? | settled: isoduality versus doubly-even self-duality, hence nonintegral versus even integral Construction A | none |
| What lattice does carry the sister exchange? | settled: the canonical hyperbolic double \(L\oplus L^*\cong II_{10,10}\) | none |
| Which isodualities become involutions on the hyperbolic double? | settled: exactly the \(36\) self-adjoint polarities; their two graph eigenspaces have signature \((5,5)\) | none |

No genuine C710 mystery remains.

## Literature boundary

No novelty or priority claim is made.  The McKay affine-Cartan
construction, Hamming Construction A of \(E_8\), regularity of \(R_{10}\),
and uniqueness of the even unimodular lattice of signature \((10,10)\) are
used as standard background.  The task-owned content is the explicit
marking, exhaustive minor and root-subsystem tests, equivariant obstruction,
and their application to the frozen Clebsch data.

## Reproducibility

Primary exact generator:

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c710-e8-hamming-marking.py --check
```

Independent hard-coded root/minor replay:

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c710-e8-hamming-marking-replay.py
```

The generator checks the affine and finite Cartan lattices, the complete
Hamming code and its \(240\) roots, the displayed determinant-one
isometry, the affine-root relation, all \(180\) marked \(R_{10}\) minors,
the exact \(S_6/S_5/A_5\) representation obstruction, both \(Q_{10}\) root
orbits, and exhaustive nonexistence of an \(E_8\) simple system.  The replay
hard-codes the eight roots and independently re-enumerates every minor.

The generator, replay, and JSON certificate contain respectively
\(18284\), \(2557\), and \(6672\) bytes.  Their SHA-256 hashes are recorded
in `notes/2026-07-30-c710-e8-hamming-marking.sha256`.
