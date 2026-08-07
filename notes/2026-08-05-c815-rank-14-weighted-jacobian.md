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

## The characteristic-five theorem

Added 2026-08-06. The rank statement above is a statement over the rationals,
and nothing below is needed for it. What follows explains the one modular
feature the first version of this report logged without an owner, and it does so
by the same equivariant reduction, on the same displayed table.

### Statement

Let \(T\subset W\) be the tangent space at \(A_0\) to the generalized conference
locus \(\{A^2=\lambda I\}\), and for \(X\in T\) let \(\mu(X)\) be the scalar with
\(A_0X+XA_0=\mu(X)I\). Then

\[
 \ker\bigl(J\otimes\mathbf F_5\bigr)
 \;=\;\{X\in T:\mu(X)\equiv0\ (\mathrm{mod}\ 5)\},
\]

a four-dimensional space, so the rank of \(J\) modulo five is eleven.

The modular kernel is therefore not merely of the same size as something
conference-shaped: it lies inside the conference tangent space and is cut out of
it by one explicit linear functional.

### Gauge coordinates

Every off-diagonal entry of \(A_0\) is \(\pm1\). For \(X\in W\) put
\(y_e=(A_0)_eX_e\), so that \(X_e=(A_0)_ey_e\). Write \(Y(S)=\sum_{e\subset S}y_e\)
for the internal sum of a triple, \(c(S)\) for the sum of \(y\) over the nine
edges joining \(S\) to \(S^c\), and \(d_i(y)=\sum_{k\ne i}y_{ik}\) for the degree
at a vertex. The representative itself has \(y\equiv1\) and every degree five.

**Lemma A.** \(\mathrm d\tau_S(X)=\tau_S(A_0)\,Y(S)\).

Differentiating \(\tau_S=a_{ij}a_{jk}a_{ki}\) gives three terms; substituting
\(X_e=(A_0)_ey_e\) and using \((A_0)_e^2=1\) turns each into \(\tau_S\) times one
of \(y_{ij},y_{jk},y_{ki}\).

**Lemma B.** \(X\in T\) if and only if all six degrees \(d_i(y)\) are equal and
\(\sum_{k\ne i,j}\tau_{ijk}(y_{ik}+y_{jk})=0\) for every edge \((i,j)\); and then
\(\mu(X)=2d_i(y)\). In particular \(\mu(A_0)=10\).

The diagonal entry \((A_0X+XA_0)_{ii}\) is \(2\sum_{k\ne i}y_{ik}\). For \(i\ne j\)
the zero diagonals kill the two extreme terms, leaving
\(\sum_{k\ne i,j}(a_{ik}X_{kj}+X_{ik}a_{kj})
=a_{ij}\sum_{k\ne i,j}\tau_{ijk}(y_{ik}+y_{jk})\), using
\(a_{ik}a_{kj}=\tau_{ijk}a_{ij}\).

**Lemma C.** \(h_{S^c}=-h_S\) for every symmetric zero-diagonal matrix, and
consequently \(\tau_{S^c}(A_0)=-\tau_S(A_0)\).

Symmetry gives \(A[S,S^c]=A[S^c,S]^{\mathsf T}\), so the two determinants agree,
while interchanging two blocks of three costs nine transpositions, so
\(\operatorname{sgn}(S,S^c)=-\operatorname{sgn}(S^c,S)\). Evaluating at \(A_0\),
where \(h_S=4\varepsilon\tau_S\), gives the second claim — this is the
ten-plus-ten two-graph split, recovered rather than assumed.

**Lemma D.** For \(X\in T\), \(Y(S)=Y(S^c)\) and hence
\(\mathrm dF_{S^c}(X)=-\mathrm dF_S(X)\): the equality Jacobian is
complementation-antisymmetric along the conference tangent space.

Summing degrees over the three vertices of \(S\) gives \(2Y(S)+c(S)=3\mu/2\), and
the same count over \(S^c\) gives \(2Y(S^c)+c(S)=3\mu/2\). Subtracting gives
\(Y(S)=Y(S^c)\). The Hodge half is antisymmetric by Lemma C; by Lemma A and
\(\tau_{S^c}=-\tau_S\) the triangle half contributes
\(\tau_S(Y(S)-Y(S^c))=0\) to the symmetric part. Only the equal-degree half of
tangency is used.

**Lemma E.** Fix \(S\) and let \(M=A_0[S^c,S]\). There is a perfect matching
\(P_S\) between \(S^c\) and \(S\) with

\[
 \mathrm dh_S(X)=2\varepsilon\tau_S\bigl(c(S)-Y_{P_S}\bigr),
\]

where \(Y_{P_S}\) is the sum of \(y\) over the three matched cross edges.

Writing \(\mathrm dh_S(X)=\sum_{p,q}\gamma_{pq}y_{pq}\) with
\(\gamma_{pq}=-\operatorname{sgn}(S^c,S)\operatorname{cof}_{pq}(M)a_{pq}\), each
cofactor is a two-by-two determinant of signs and so lies in \(\{0,\pm2\}\).
Expanding along any row or column gives \(\sum_q\gamma_{pq}=\sum_p\gamma_{pq}
=-\operatorname{sgn}(S^c,S)\det M=h_S=4\varepsilon\tau_S\). An array with entries
in \(\{0,\pm2\}\) whose every row and column sums to \(\pm4\) must carry exactly
one zero in each row and column, all other entries equal to
\(2\varepsilon\tau_S\); those zeros form a permutation matrix. Hence
\(\gamma=2\varepsilon\tau_S(\mathbf J_3-P_S)\).

**Proposition F.** For \(X\in T\) with \(\mu(X)=0\),

\[
 \mathrm dF_S(X)=-2\varepsilon\tau_S\bigl(4Y(S)+Y_{P_S}\bigr).
\]

Vanishing \(\mu\) makes every degree zero, so \(c(S)=-2Y(S)\). Combining that
with Lemmas A and E gives the displayed form. The modular claim is therefore
exactly \(Y_{P_S}\equiv Y(S)\pmod 5\) on \(\ker\mu\), and the factor two in front
is the uniform evenness already recorded above.

### The equivariant finish

**Lemma G.** Let \(h\in G\) have order three. Because three is invertible in
\(\mathbf F_5\), the fixed-point functor \(N\mapsto N^{\langle h\rangle}\) is exact
on \(\mathbf F_5[G]\)-modules. The irreducible \(\mathbf F_5[G]\)-modules have
dimensions \(1,3,5\) with Brauer characters \((1,1,1)\), \((3,-1,0)\), \((5,1,-1)\)
on the classes of order \(1,2,3\), so each has fixed-space dimension
\((\varphi(1)+2\varphi(h))/3=1\). Hence \(\dim N^{\langle h\rangle}\) is the
composition length of \(N\); in particular a nonzero module has a nonzero fixed
vector.

This is the modular counterpart of Step 3, and the choice of order three is
again forced: an element of order five has zero fixed space on the
four-dimensional constituent, so it would not detect the kernel at all.

**Corollary H.** If \(M\subseteq N\) are \(\mathbf F_5[G]\)-modules with
\(M^{\langle h\rangle}=N^{\langle h\rangle}\), then \(M=N\). Exactness gives
\((N/M)^{\langle h\rangle}=0\), and Lemma G then forces \(N/M=0\).

**Proof of the theorem.** Let \(K\) be the reduction modulo five of the saturated
lattice \(\ker\mu\), and let \(M=\ker(J\otimes\mathbf F_5)\); both are submodules
of \(W\otimes\mathbf F_5\), since \(J\) is equivariant. Take the same \(h\) as in
Step 4, with fixed space spanned by \(u_1,\dots,u_5\). Exactness of fixed points
makes \(M^{\langle h\rangle}\) the kernel of the displayed eight-by-five table
over \(\mathbf F_5\).

Two hand checks finish it.

First, the table modulo five. The raw reduced rows, before the content division
displayed above, have contents \(6,4,2,2,4,2,2,6\); none is divisible by five, so
the displayed table has the same rank modulo five as the raw one. That rank is
three — the leading four-by-four minor is \(-5\) and vanishes — and the kernel is
spanned by

\[
 v_1=u_2-u_3,
 \qquad
 v_2=-u_1+3u_2-u_4+u_5 .
\]

Second, both lie in \(\ker\mu\): each has all six gauge degrees zero and
satisfies the fifteen edge equations of Lemma B, which is a direct evaluation.
So \(M^{\langle h\rangle}\subseteq K^{\langle h\rangle}\).

Now \(\ker\mu\) is the four-dimensional irreducible, whose reduction has
composition factors the trivial and the three-dimensional module — the classical
statement that the all-ones vector lies in the sum-zero subspace of
\(\mathbf F_5^5\) — so its length is two and, by Lemma G,
\(\dim K^{\langle h\rangle}=2\). Hence \(K^{\langle h\rangle}=M^{\langle h\rangle}\).
Applying Corollary H to \(K\cap M\subseteq K\) gives \(K\subseteq M\), and applying
it again to \(K\subseteq M\) gives \(K=M\). Therefore the modular kernel is
four-dimensional and the rank is eleven. \(\square\)

### What the eigenvalue picture adds

One line explains why the functional \(\mu\) is the right one. Multiplying
\(A_0X+XA_0=\mu I\) by \(A_0\) and using \(A_0^2=5I\) gives

\[
 A_0XA_0=\mu(X)A_0-5X .
\]

So \(\sigma(X)=\tfrac15A_0XA_0\) is an involution on \(T\), equal to \(+1\) on the
scaling line, where \(\mu(A_0)=10\), and to \(-1\) on \(\ker\mu\). The splitting
\(T\cong\mathbf1\oplus\mathbf4\) obtained above by a character computation is
therefore an eigenspace decomposition of conjugation by the representative, and
the modular kernel is the reduction of the \(-1\) eigenspace. Modulo five the
two eigenspaces cease to be transverse, because \(\mu(A_0)=10\) vanishes, and
that is the whole degeneracy.

The same identity gives the reason no prime other than two and five can be bad.
Let \(C=\bigwedge^3A_0\); multiplicativity of compounds gives \(C^2=125I\), and
pushing \(A_0XA_0=-5X\) through the mixed-compound product rule gives
\(C\,\mathrm D(X)=-\mathrm D(X)\,C\) on \(\ker\mu\), while \(\mathrm D(A_0)\)
commutes with \(C\). Since \(C^2=125I\), the operator \(C/(5\sqrt5)\) is an
involution and \(C\) carries half-integral five-adic valuation. Five is the
ramified prime of \(\mathbf Z[\varphi]\), and the anticommutation places the
derivative in the odd part of that ramified grading. Away from five the grading
is trivial and away from two the primitive normalization does nothing, so two
and five are not merely the observed bad primes but the only possible ones —
three in particular is excluded structurally.

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

- **The minor \(-5\) — partly rehabilitated.** The first version of this report
  deflated the leading minor entirely, on the ground that its value depends on
  the chosen rows and on the orbit basis normalization. That remains true of the
  value. It is not true of the divisibility: the reduced table has rank three
  rather than four modulo five, so five divides that minor for every choice of
  four rows and every orbit basis. The vanishing of the minor modulo five is the
  characteristic-five theorem above, and only the cofactor \(-1\) is an artifact
  of the normalization. Whether the reduced determinant carries a further golden
  meaning beyond that divisibility is still open and owned by nobody.
- **Bad primes of the integral Jacobian — settled.** Every Jacobian entry is
  even; the primitive Jacobian \(J/2\) has entries in \(\{0,\pm1,\pm2\}\) and
  invariant factors \(1^4,2^6,4,20^3\). Its rank stays fourteen in every
  characteristic other than two and five, drops to eleven in characteristic five,
  and to four in characteristic two. The characteristic-five drop is now proved:
  the modular kernel is exactly the \(\mu\equiv0\) hyperplane of the conference
  tangent space, and the ramification of five in \(\mathbf Z[\varphi]\) is why no
  prime other than two and five can be bad. This also retracts the suggestive
  reading the first version offered. The modular rank eleven and the conference
  rank eleven agree by a cancellation of offsets — sixteen variables against a
  five-dimensional kernel on one side, fifteen against four on the other — and
  nothing follows from the two numbers matching. The containment is the real
  fact, and it is stronger than the coincidence it was mistaken for.
- **Characteristic two — open.** The rank-four collapse of the primitive
  Jacobian has no explanation here. The engine identity has no analogue, since
  \(A_0^2=5I\) becomes \(A_0^2=I\), so conjugation by the representative is an
  involution on all of \(W\) rather than a grading of the tangent space. No
  successor is allocated.
- **No genuine mystery remains in the rank statement itself.** The rank, the
  kernel, the equivariance, the module decomposition, and now the modular
  degeneracy are all accounted for.

## Boundary for C816

The manuscript may now cite Theorem D as proved rather than certified, provided
it also carries the constant-rank step and the displayed reduced table, or a
reference to this report for it. Nothing in this report edits the manuscript or
any Lean source.

### Proposed manuscript changes

These are proposals for C816 to accept or decline, not edits. They are listed in
descending order of how much they buy.

1. **Replace the numerical comparison sentence.** Theorem D currently ends with
   "the cubic equality cuts the four non-scaling tight-frame deformation
   directions," which reads as an observation about two dimensions agreeing.
   Replace it with the module statement: the conference tangent space at the
   representative is the trivial-plus-four isotypic subspace of the edge module,
   the cubic Jacobian is injective on the four-dimensional irreducible, and the
   two ranks fourteen and eleven are therefore one structural fact rather than
   two coincident computations. This is the single highest-value change, because
   it converts the paper's weakest-sounding remark into a theorem.

2. **State the eigenspace description of the splitting.** One displayed line,
   \(A_0XA_0=\mu(X)A_0-5X\), earns the whole of Lemma B and makes the
   trivial-plus-four splitting an eigenspace decomposition of conjugation by the
   representative rather than the output of a character table. It costs two
   sentences and removes the paper's only appeal to a character computation in
   this theorem.

3. **Carry the reduced table with its proof, not as a display.** The
   eight-by-five table is the one place a reader must still do arithmetic. Give
   the multilinear difference rule, one worked row, and the statement that the
   remaining seven follow identically; then the table is a verifiable object
   rather than an assertion. Keeping it as an unexplained display is what makes
   Theorem D still feel certified even though it is not.

4. **Add the complementation antisymmetry as a remark.** Lemma C —
   \(h_{S^c}=-h_S\) for every symmetric zero-diagonal matrix, hence
   \(\tau_{S^c}=-\tau_S\) on the locus — recovers the ten-plus-ten two-graph split
   that the series elsewhere assumes. It is three lines and it connects Theorem D
   to the orientation torsor material rather than leaving it isolated.

5. **Leave the characteristic-five theorem out of the manuscript.** It is a real
   theorem and it belongs in this report, but Theorem D is a statement over the
   reals and the modular material would be a digression. The one exception worth
   a footnote is the divisibility of the reduced minor by five, since a reader
   who computes the table will notice the \(-5\) and wonder.

### Proposed Lean work

The existing Lean surface for Paper III does not reach this theorem, and it
should not try to reach all of it. Recommended scope, smallest first:

1. **Lemma C, unconditionally.** For a symmetric zero-diagonal matrix over any
   commutative ring, the complementary third-compound coefficients are negatives.
   This is a pure `Matrix.det` and permutation-sign statement with no golden
   hypothesis, it is reusable by the orientation-torsor material, and it is the
   natural first target.

2. **Lemmas A and B in gauge coordinates.** The triangle derivative
   \(\mathrm d\tau_S=\tau_S\,Y(S)\) and the tangency characterization, over a
   commutative ring in which the entries are units. Both are finite index
   manipulations of the kind the existing shared modules already handle, and
   together they make \(\mu\) a defined object rather than an ad hoc scalar.

3. **The engine identity.** \(A_0XA_0=\mu(X)A_0-5X\) from \(A_0^2=5I\), and the
   consequence that \(\sigma\) is an involution with the stated eigenspaces. Two
   lines of `Matrix` algebra; high value per line, since it carries proposal two
   above.

4. **Lemma E.** The cofactor array is \(2\varepsilon\tau_S(\mathbf J_3-P_S)\).
   This is the only combinatorially awkward step — it needs the classification of
   three-by-three sign matrices with all row and column sums \(\pm4\) — and it is
   a bounded finite case analysis, so it is a reasonable sharded target rather
   than a semantic one.

5. **Not recommended for Lean.** The representation-theoretic finish, Lemmas G
   and H. Mathlib's modular representation theory does not currently carry Brauer
   characters or the composition-length statement for
   \(\mathbf F_5[\mathrm A_5]\), so formalizing it would mean building that layer
   first. The cost is out of proportion to a theorem that will not appear in the
   manuscript. If the equivariant reduction is ever wanted in Lean, the
   characteristic-zero Step 3 is the one to do, since complete reducibility over
   a field of characteristic zero is available.

To be clear about the boundary: items one through four would give Lean coverage of
the algebraic identities and leave the rank statement itself unformalized. That
is the right trade: the rank statement is a five-dimensional integer computation
a reader can do, and the identities are what a reader cannot check by inspection.
