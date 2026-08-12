# C909 — exact threefold detector separation

Date: 2026-08-12

Status: **GO.** This is a formal synthesis consequence, not a new
rationality, stable-rationality, Chow, or priority statement. No manuscript,
PDF, mirror, or Lean file is edited.

## Theorem

For a smooth complex projective threefold \(Y\), let \(U(Y)\) be one or zero
according as \(Y\) is or is not universally \(CH_0\)-trivial. Let
\(\nu _6(Y)\) be the framed small-even primitive-sixth formal-monodromy
multiplicity used in Section 4 of the epilogue. Then neither invariant factors
through the other: there is no \(f\) with \(\nu _6=f\circ U\), nor \(g\) with
\(U=g\circ\nu _6\).

Choose a smooth special member \(X_s\) of the nonstandard \(A_5\)-pencil and
a very general smooth cubic threefold \(X_v\). The exact values are

| threefold | \(U\) | \(\nu _6\) |
|---|---:|---:|
| \(\mathbf P^3\) | 1 | 0 |
| \(X_s\) | 1 | 2 |
| \(X_v\) | 0 | 2 |

The first two rows rule out \(\nu _6=f\circ U\); the last two rule out
\(U=g\circ\nu _6\).

For \(\mathbf P^3\), rationality gives \(U=1\), and the projective-bundle
formula from a point gives \(\nu _6(\mathbf P^3)=0\). For \(X_s\), the
six-axis divided-power theorem makes \(\Theta^4/4!\) algebraic, and Voisin's
Corollary 4.4 gives \(U=1\); the cubic packet calculation gives \(\nu _6=2\).
For \(X_v\), Engel--de Gaay Fortman--Schreieder Theorem 1.3 says every
algebraic curve class on its intermediate Jacobian is an even multiple of
\(c=\Theta^4/4!\). Since \(\Theta\cdot c=5\), \(c\) is primitive and hence is
not algebraic. Voisin's criterion gives \(U=0\), while the same cubic packet
calculation gives \(\nu _6=2\).

This uses no comparison map between the two constructions and does not say
that nonzero \(\nu _6\), by itself, is a stable-rationality obstruction.

## Products and stabilization

For every \(m\geq0\), the projective-bundle formula gives

\[
 U(Y\times\mathbf P^m)=U(Y),\qquad
 \nu _6(Y\times\mathbf P^m)=(m+1)\nu _6(Y).
\]

Thus the same three examples repeat the non-factorization on smooth
\((3+m)\)-folds. This is only a formal replication. When \(m=1\), the
printed one-step theorem additionally makes every cubic product irrational;
when \(m\geq2\), the current weak-factorization proof yields no further
stable-irrationality conclusion.

## Exact scope and placement

The very-general E--dGF--S result cannot be specialized to the special
\(A_5\) pencil: the latter is a proper locus with additional endomorphisms,
and the source's multivariable matroidal monodromy hypothesis is not retained.
The special row requires a smooth pencil member. The use of Voisin is only
the individual-fibre equivalence between universal \(CH_0\)-triviality and
algebraicity of \(\Theta^4/4!\); no relative cycle is asserted.

Do **not** add a numbered proposition or corollary. A compact paragraph in
the final synthesis may say that the two invariants “do not factor through
one another.” The \(m=1\) instance is already the headline theorem, and the
general product statement does not add mathematical content to the paper.

## Source register

This is not a novelty or literature-negative audit. One primary source was
read at full text and two at partial depth.

| source | read depth / exact use / version and cache |
|---|---|
| Jiaji Cai, *The cubic threefold is symplectically irrational* | **full text**; Section 3 and Proposition 6 give the cubic sixth-root block; arXiv:2608.01577v1; cache key arXiv:2608.01577, SHA-256 06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e |
| Claire Voisin, *On the universal \(CH_0\) group of cubic hypersurfaces* | **partial**; criterion setup and Corollary 4.4; arXiv:1407.7261; cache key arXiv:1407.7261, SHA-256 514e5634d920f4b8e9c6797f3de5ad34afea65624ba23cc764d329ebcdd2c4e4 |
| Philip Engel, Olivier de Gaay Fortman, Stefan Schreieder, *Matroids and the integral Hodge conjecture for abelian varieties* | **partial**; Introduction, §§1.1--1.3, and Theorem 1.3 give the even-multiple statement on a very general cubic intermediate Jacobian; arXiv:2507.15704v3; cache key arXiv:2507.15704, SHA-256 f0284c8249c07ab5e3d9e5e49504662fad26de205563ab5a48aea27e742741ee |

## EJ + TT closeout and mystery ledger

The free upgrade is the factorization formulation: it separates the two
invariants without presenting either as a binary rationality detector.

* **Settled:** projective-space factors preserve the separation formally but
  add no new implication.
* **Settled:** E--dGF--S is a valid very-general contrast, not evidence
  against the special \(A_5\) construction.
* **No genuine mathematical mystery remains for this bounded theorem.**
