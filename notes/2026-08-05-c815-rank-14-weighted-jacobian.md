# C815 — structural proof of the rank-14 weighted Jacobian

**Date:** 2026-08-05
**Lane:** `clebsch` (Paper III, `passages`)
**Closes:** gap class C item 6 of `notes/2026-08-03-c815-paper-iii-formalization-gap-inventory.md`

## Verdict

The rank-14 statement behind C809's Theorem D is no longer an external rational
certificate. It has a structural proof: the Jacobian is equivariant for the
order-60 automorphism group of the oriented golden conference matrix, its kernel
is therefore a submodule, and every irreducible constituent of an
alternating-group-of-degree-five representation has a vector fixed by an element
of order three. That reduces the whole 20-by-15 rational rank to a computation on
a five-dimensional fixed space whose Jacobian has eight distinct rows in five
integer columns, small enough to display and to check by hand. The rank at both
oriented representatives, and hence local rigidity, follows.

Only one external ingredient survives, and it is not a certificate: the passage
from "the Jacobian has rank fourteen" to "the real equality locus is locally the
scaling line" is the ordinary constant-rank theorem, applied exactly as any
manuscript applies it.

## Setup

Write \(A\) for a symmetric order-six matrix with zero diagonal, and let its
fifteen off-diagonal entries \(a_{ij}\) be the coordinates. For a triple
\(S=\{i,j,k\}\) put

- \(\tau_S(A)=a_{ij}a_{jk}a_{ki}\), the triangle coefficient, and
- \(h_S(A)=-\operatorname{sgn}(S^{c},S)\det A[S^{c},S]\), the third-compound
  (Hodge) coefficient in the C704 orientation, which is exactly minus the
  coefficient of \(x_ix_jx_k\) in \(\operatorname{Pf}[D_x,A]\).

The oriented equality locus is the common zero set of the twenty equations
\(F_S=h_S-4\varepsilon\tau_S\) for \(\varepsilon=\pm1\). The golden
representative \(A_0\) of C809 lies on the locus for \(\varepsilon=+1\), and the
opposite oriented representative for \(\varepsilon=-1\).

Every \(F_S\) is multilinear in the fifteen entries: \(\tau_S\) uses each of the
three edges inside \(S\) once, and \(h_S\) is a determinant with one entry per
row and column of the cross block. So the exact partial derivative of \(F_S\) in
the direction of a single edge is the difference of its values at
\(a_{ij}=1\) and \(a_{ij}=0\). No symbolic differentiation and no floating point
enter anywhere.

Let \(J\) be the resulting 20-by-15 integer Jacobian at \(A_0\), and let \(W\) be
the fifteen-dimensional space of symmetric zero-diagonal perturbations.

## Theorem

\(\ker J=\mathbf R\cdot A_0\); equivalently \(J\) has rank fourteen. The same
holds at the opposite oriented representative.

### Step 1 — the scaling direction is in the kernel

Both \(h_S\) and \(\tau_S\) are homogeneous cubics in the entries of \(A\), so
Euler's relation gives \(\mathrm dF_S(A_0)[A_0]=3F_S(A_0)=0\). This is the whole
reason the rank cannot exceed fourteen; it needs no computation.

### Step 2 — the symmetry group

Let a signed permutation \((\sigma,\epsilon)\) act by
\(A\mapsto D_\epsilon P_\sigma AP_\sigma^{\mathsf T}D_\epsilon\). Under it
\(\tau_S\) is invariant up to relabelling — each vertex of a triangle carries two
of its edges, so the signs cancel — while \(h_S\) picks up
\(\operatorname{sgn}(\sigma)\det D_\epsilon\), since permuting multiplies the
cross determinant by the permutation sign and switching multiplies it by the
product of all six signs.

The stabilizer \(G\) of \(A_0\), taken modulo the global sign that acts trivially
on edge weights, has order sixty; every one of its elements has
\(\operatorname{sgn}(\sigma)=+1\) and \(\det D_\epsilon=+1\). Hence \(G\)
preserves each \(F_S\) up to the permutation of triples, and \(J\) is
\(G\)-equivariant from \(W\) to the permutation module on the twenty triples.
\(G\) has element orders \(1,2,3,5\) with multiplicities \(1,15,20,24\) and no
nontrivial proper normal subgroup, so \(G\) is the alternating group of degree
five. This is the orientation-preserving half of the two-graph automorphism
group already used in C809's pentagon classification.

### Step 3 — the kernel is a submodule, so one order-three element sees it

\(\ker J\) is \(G\)-stable. Every irreducible representation of the alternating
group of degree five has a nonzero vector fixed by a subgroup of order three: the
fixed-space dimensions are \((\chi(1)+2\chi(c_3))/3=1,1,1,2,1\) for the
irreducibles of dimensions \(1,3,3,4,5\).

Fix an element \(h\in G\) of order three. If \(\ker J\) were larger than
\(\mathbf R A_0\), complete reducibility would split off a nonzero submodule
complementary to \(\mathbf R A_0\) inside it; that submodule contains an
irreducible, which contributes a fixed vector, and therefore

\[
\dim\bigl(\ker J\cap W^{\langle h\rangle}\bigr)\ge 2 .
\]

So it suffices to compute that intersection, and the ambient space for the
computation is \(W^{\langle h\rangle}\), not \(W\).

### Step 4 — the five-dimensional computation

Take \(h\) with permutation \((0\,1\,2)(3\,5\,4)\) and signs
\((+,+,+,-,+,-)\). It splits the fifteen edges into five orbits of length three,
each with trivial sign holonomy, so \(W^{\langle h\rangle}\) is five-dimensional
with the orbit-sum basis

\[
\begin{aligned}
u_1&=e_{01}+e_{02}+e_{12}, &
u_2&=e_{03}-e_{15}+e_{24}, &
u_3&=e_{04}+e_{13}-e_{25},\\
u_4&=e_{05}-e_{14}-e_{23}, &
u_5&=e_{34}-e_{35}-e_{45}. &&
\end{aligned}
\]

In these coordinates \(A_0=u_1+u_2+u_3+u_4-u_5\), and the twenty rows of \(J\)
collapse to eight distinct rows. Dividing each by its content:

| rows from triples | \(u_1\) | \(u_2\) | \(u_3\) | \(u_4\) | \(u_5\) |
|---|---:|---:|---:|---:|---:|
| \(012\)                | \(-2\) | \(1\)  | \(1\)  | \(0\)  | \(0\)  |
| \(034,135,245\)        | \(-1\) | \(1\)  | \(1\)  | \(-1\) | \(0\)  |
| \(013,024,125\)        | \(0\)  | \(-1\) | \(-1\) | \(1\)  | \(-1\) |
| \(014,025,123\)        | \(1\)  | \(-3\) | \(2\)  | \(1\)  | \(1\)  |
| \(035,145,234\)        | \(1\)  | \(-2\) | \(3\)  | \(-1\) | \(1\)  |
| \(015,023,124\)        | \(1\)  | \(2\)  | \(-3\) | \(1\)  | \(1\)  |
| \(045,134,235\)        | \(1\)  | \(3\)  | \(-2\) | \(-1\) | \(1\)  |
| \(345\)                | \(0\)  | \(-1\) | \(-1\) | \(0\)  | \(-2\) |

Every row annihilates \((1,1,1,1,-1)\), as Step 1 requires. The first four rows,
in the first four columns, have determinant \(-5\), so they are independent and
the rank on \(W^{\langle h\rangle}\) is four. Hence
\(\ker J\cap W^{\langle h\rangle}\) is exactly the line through \(A_0\), which
contradicts the inequality of Step 3 unless \(\ker J=\mathbf R A_0\).

### Step 5 — both orientations

The opposite oriented representative is carried to the same situation by any odd
signed permutation, which exchanges the two loci because it negates \(h_S\) and
fixes \(\tau_S\). The certificate runs the entire argument independently at both
representatives and obtains the identical group order, character, orbit
structure, reduced table shape, and rank.

## What Theorem D now says

With rank fourteen proved, the constant-rank theorem gives the local statement as
before: fourteen of the equations have independent differentials at \(A_0\), so
near \(A_0\) the locus lies in a one-dimensional manifold, and the scaling line is
a one-dimensional submanifold of the locus, so the two agree near \(A_0\). Both
golden points are isolated and reduced projectively.

The equivariant view also sharpens the comparison C809 draws with the
generalized conference locus. As a \(G\)-module,

\[
W\;\cong\;\mathbf 1\oplus\mathbf 4\oplus\mathbf 5\oplus\mathbf 5,
\]

from the character \((15,3,0,0,0)\) on the classes of orders \(1,2,3,5\). The
tangent space to \(\{A^2=\lambda I\}\) at \(A_0\), which is five-dimensional, is
exactly \(\mathbf 1\oplus\mathbf 4\) — not merely of the same dimension. The
cubic equality is injective on \(\mathbf 4\) and on the ten-dimensional
\(\mathbf 5\)-isotypic part, so C809's sentence that "the cubic equality cuts the
four non-scaling tight-frame deformation directions" is the statement that it
kills no vector of the irreducible four-dimensional constituent. That
identification is new here and is what makes the two ranks, fourteen and eleven,
a single structural fact rather than two coincident computations.

## Evidence bundle

- `notes/2026-08-05-c815-rank-14-weighted-jacobian.py` — 27,140 bytes, SHA-256
  `b98377f45242c3226cc206f940718d2e1164e43d76a69ea5f7feccdf851149e0`;
- `notes/2026-08-05-c815-rank-14-weighted-jacobian.json` — 6,395 bytes, SHA-256
  `f5cbc42ab8df4756cd86edd836eb8617d3336988801304f5d03a660c889f7ed7`.

Replay from the repository root:

```sh
python3 notes/2026-08-05-c815-rank-14-weighted-jacobian.py \
  --check notes/2026-08-05-c815-rank-14-weighted-jacobian.json
```

The script uses the standard library only and exact integer and rational
arithmetic throughout; enumeration is canonical, there is no randomness, and the
certificate is sorted and stable. It rebuilds every object from scratch rather
than importing the C809 bundle, and it verifies, at both oriented
representatives:

- that the third-compound cubic agrees with the commutator Pfaffian, checked on a
  nonspecial integer matrix as well as at the two representatives;
- that the representatives lie on their oriented loci;
- the Jacobian rank fourteen, kernel dimension one, and that the kernel is the
  scaling line, directly in the full fifteen-dimensional space;
- the Euler relation as a row-by-row identity;
- the stabilizer: order sixty, all permutation signs and switching determinants
  \(+1\), simplicity, and the element-order profile;
- equivariance of the Jacobian on every basis vector for all sixty elements;
- the character of the edge module and the isotypic dimensions \(1,4,10\);
- the order-three reduction for all twenty order-three elements, not only the
  displayed one, each giving fixed dimension five, eight distinct rows, rank
  four, and kernel the scaling line;
- the conference tangent space: rank eleven, dimension five, and equality with
  the trivial-plus-four isotypic subspace.

What it does not certify: the constant-rank step, which is ordinary real
analysis; any statement about remote real or complex solutions of the equality
equations, which C809 already excludes; and anything about the manuscript's
promotion of Theorem D, which belongs to C816.

The independent cross-check is the C809 bundle
`notes/2026-08-02-c809-four-shadow-characterization.py`, whose separate code path
reports the same two ranks fourteen and the conference tangent rank eleven. The
structural proof above is itself the second, computation-free check on the rank:
the displayed eight-by-five table is small enough to verify by hand, and the rest
of the argument is representation theory.

## Mystery ledger

- **The minor \(-5\).** The four displayed rows have leading minor \(-5\), the
  same scalar as the conference square \(A_0^2=5I\). Settled as far as it needs to
  be: the value depends on the chosen rows and on the orbit basis normalization,
  so it is not an invariant, and nothing in the proof rests on it. Whether the
  determinant of the reduced map has an invariant golden meaning is open and
  owned by nobody.
- **Bad primes of the integral Jacobian.** Every Jacobian entry is even; the
  primitive Jacobian \(J/2\) has entries in \(\{0,\pm1,\pm2\}\) and invariant
  factors \(1^4,2^6,4,20^3\), so its cokernel torsion involves only the primes
  two and five. Its rank stays fourteen in every characteristic other than two
  and five, drops to eleven in characteristic five — exactly the conference
  tangent rank — and to four in characteristic two. This is not a gap in the
  theorem, which is a real statement, and it is not needed for it. It is logged
  to the discovery track because it lines up with the program's known golden bad
  primes and pointedly excludes three, matching C711's placement of three outside
  the quaternion layer. No successor is allocated.
- **No genuine mystery remains in the rank statement itself.** The rank, the
  kernel, the equivariance, and the module decomposition are all accounted for.

## Boundary for C816

The manuscript may now cite Theorem D as proved rather than certified, provided
it also carries the constant-rank step and the displayed reduced table, or a
reference to this report for it. Nothing in this report edits the manuscript or
any Lean source.
