# C907 prime-Fano primitive-sixth classification

**Lane:** `clebsch`

**Status:** theorem-grade classification of the closed framed multiplicity.
It does not classify enriched Stokes/Rees extensions or Gamma markings.

## Theorem

Let $X$ be a smooth complex prime Fano threefold of genus $g$.  Then

\[
\nu_6(X)=
\begin{cases}
2,&g=4\text{ or }g=8,\\
0,&g=2,3,5,6,7,9,10,12.
\end{cases}
\tag{1}
\]

In particular,

\[
\nu_6(X)\le2
\tag{2}
\]

for every smooth complex prime Fano threefold.  Thus no prime Fano
threefold passes the formal admission test $\nu_6\ge4$ for a length-two
primitive-sixth carrier.  The bound is sharp, and its two positive
deformation types arise by different mechanisms: quantum Lefschetz in genus
four and one-step stable-birational transport from the cubic in genus eight.

## Proof by structural compression

The prime genera are

\[
2,3,4,5,6,7,8,9,10,12.
\tag{3}
\]

They divide into four mechanisms rather than ten unrelated differential
operators.

### 1. Cyclotomic complete intersections: genera two through five

The four models and their reduced factorial cyclotomic polynomials are

\[
\begin{array}{c|c|c}
g&X&R(t)\\ \hline
2&X_6\subset\mathbf P(1,1,1,1,3)&\Phi_2\Phi_6\\
3&X_4\subset\mathbf P^4&\Phi_2\Phi_4\\
4&X_{2,3}\subset\mathbf P^5&\Phi_2\Phi_3\\
5&X_{2,2,2}\subset\mathbf P^6&\Phi_2^3.
\end{array}
\tag{4}
\]

All have index one.  The inertia--cyclotomic theorem identifies these
factorial equations with the full ordinary small-even QDM and says that a
primitive-sixth pair occurs exactly for $R=\Phi_2\Phi_3$.  Hence

\[
(\nu_6(g=2),\nu_6(g=3),\nu_6(g=4),\nu_6(g=5))
=(0,0,2,0).
\tag{5}
\]

The weighted genus-two model satisfies the theorem's smooth-coarse and
strong-well-formedness hypotheses: the sextic avoids the isolated stacky
coordinate point.  Thus no twisted-sector term is being silently discarded.

### 2. The sole direct non-WCI operator: genus six

For $V_{10}$, Przyjalkowski's exact counting matrix and Golyshev's rank-four
right determinant give the full ordinary small-even scalar operator

\[
\begin{aligned}
\widehat L_{10}={}&D^4-10tD(D+1)(2D+1)
-16t^2(37D^2+74D+39)\\
&-2040t^3(2D+3)-8784t^4.
\end{aligned}
\tag{6}
\]

Its infinity exponential polynomial is

\[
(\lambda+6)^2(\lambda^2-32\lambda-244).
\tag{7}
\]

The framed residues are integral, including the resonant double block, so

\[
\nu_6(V_{10})=0.
\tag{8}
\]

The all-degree source bridge and exact noncommutative determinant replay are
in `2026-08-12-c907-v10-full-qdm-certificate.md`.

### 3. Stable-birational compression: genera seven through twelve

Every smooth complex prime Fano of genus seven, nine, or ten is rational.
The genus-twelve $V_{22}$ is birational to $V_5$ (and independently to a
quadric through the conic link).  Since $\nu_6$ is birationally invariant for
smooth projective varieties of dimension at most four and
$\nu_6(\mathbf P^3)=\nu_6(V_5)=0$, all four genera contribute zero.

For genus eight, Kuznetsov's flop relates honest rank-two projective bundles
over $V_{14}$ and its associated smooth cubic threefold $C$.  Birational
invariance in dimension four and the projective-bundle formula give

\[
2\nu_6(V_{14})=2\nu_6(C)=4,
\tag{9}
\]

so $\nu_6(V_{14})=2$.  This proves every remaining row of (1).

## Why this is not the universal carrier theorem

Equation (2) removes every prime Fano from the search for two independent
primitive-sixth packets.  It does not remove arbitrary threefold centers in
fivefold weak factorizations.  Such centers can be non-Fano or non-nef, and
Mori fibre spaces also include conic bundles and del Pezzo fibrations.

Nor does $\nu_6=2$ prove enriched length one: it records formal-monodromy
multiplicity but not a Stokes filtration, Rees extension, polarization, or
Gamma/Orlov marking.  The genus-eight row is therefore a sharp formal
regression for the future carrier theorem, not a completed enriched example.

## Source and proof ledger

1. Coates--Corti--Galkin--Kasprzyk, *Quantum Periods for 3-Dimensional Fano
   Manifolds*, arXiv:1303.3288v3, rank-one Sections 8--17 and Appendix B:
   the prime-genus list and models.  Cached PDF SHA-256
   `a01ad88951e72c9b6ef16e8be2e08408bc6e6cf20e9133befe009d62782d9686`;
   source-tarball SHA-256
   `fe01aedde30aec17ad6da442b82d9c15ff2c2fc5cdef0c7a6d15e87fa0573143`.
2. `2026-08-12-c907-inertia-cyclotomic-compression.md`: full ordinary-QDM
   identification and exact cyclotomic test for (4).
3. `2026-08-12-c907-v10-full-qdm-certificate.md`: primary counting-matrix,
   scalarization, and formal replay for (6)--(8).
4. `2026-08-12-c907-prime-fano-rationality-compression.md`: full theorem-locus
   audit for genera seven, nine, and ten.
5. `2026-08-12-c907-low-dimensional-stable-birational-compression.md` and the
   printed C907 v1 theorem: genus eight, genus twelve, and the operation
   formulas.  The Kuznetsov genus-eight theorem locus has been read in full
   in the epilogue source audit.

No novelty or absence-of-literature claim is made here.

## EJ/TT and mystery ledger

- **EJ:** ten deformation rows collapse to three reusable mechanisms:
  cyclotomic cancellation, one rank-four counting matrix, and
  stable-birational transport.  Only genus six requires a new direct
  operator.
- **TT:** a complete Fano classification is not a classification of
  weak-factorization centers.  The prime-Fano theorem closes the sharp finite
  leaf while leaving the non-nef and relative Mori-fibre carrier gate fully
  visible.
- **Settled:** the exact prime-Fano values (1); the sharp universal bound
  (2); exclusion of every prime Fano from length-two formal admission.
- **Open:** enriched length for the positive genus-four and genus-eight
  packets; birational/MMP reduction for arbitrary threefold centers; conic
  bundles and del Pezzo fibrations.
