# C904 — Paper II's chordal cubic and the six-axis recovery

**Date:** 2026-08-09  
**Lane:** `clebsch`  
**Status:** exact research result; independently replayed; literature closure pending  
**Manuscript effect:** the proposed literal cubic equality is false

## Result

Fix the `H_3` matching

\[
 M=\{01,25,37,49,68,10\,11\}
\]

in Paper II.  Its stabilizer is `A_5`, acting transitively on the six pairs
of `M`.  Let `A_M` be the five-dimensional augmentation module of that
six-set over `F_11`.  Paper II's ten-dimensional factorization-difference
space restricts as

\[
 W_{H_3}\!\downarrow_{A_5}\cong \mathbf1\oplus\mathbf4\oplus\mathbf5.
\]

Since `11` does not divide `60`, the central character idempotent gives a
canonical rank-five projection

\[
 \pi_5:W_{H_3}\longrightarrow W_5.
\]

The intertwiner space from `A_M` to `W_5` is one-dimensional.  Thus the
projective cubic obtained from the Paper-II signed tensor

\[
 \mu_3=\sum_N\epsilon(N)x_N^{\odot3}
\]

by applying `Sym^3(pi_5)` and the invariant self-duality of `A_M` is
intrinsic to the marked matching.

That cubic is **not** the conference triangle cubic.  The two coefficient
vectors span a two-dimensional space over `F_11`; since every equivariant
intertwiner differs only by a scalar, no `A_5`-equivariant linear change of
carrier can repair the mismatch.

Instead, after the unique outer-twisted identification

\[
 A_M\cong\operatorname{Sym}^4(\mathbf F_{11}^2),
\]

the projected Paper-II cubic is the chordal cubic

\[
 \boxed{
 \det\begin{pmatrix}
 z_0&z_1&z_2\\
 z_1&z_2&z_3\\
 z_2&z_3&z_4
 \end{pmatrix}=0.}
\]

Its singular locus is the rational normal quartic

\[
 [s:t]\longmapsto[s^4:s^3t:s^2t^2:st^3:t^4].
\]

The twelve `F_11`-points of that curve form the homogeneous `A_5/C_5`
orbit.  Two points have the same stabilizer precisely when they are the two
fixed points of one Sylow `5`-subgroup.  Pairing them therefore gives

\[
 A_5/C_5\longrightarrow A_5/D_5,
\]

the canonical six-axis carrier of Paper I.  Thus Paper II does recover the
six axes, but through the singular curve of a *companion chordal cubic*, not
by equality with the six-node conference cubic.

There are two different involutions here, and they must not be conflated.
In the pencil basis `(C,H)` consisting of the conference member and the
Paper-II chordal member, an odd element of the six-axis normalizer acts by

\[
 [a:b]\longmapsto[-a+8b:b].
\]

It negates the chosen generator of the conference line, fixes the ten-point
member `[1:3]`, and exchanges the two chordal members `[0:1]` and `[1:7]`.
Changing Paper II's matching sheet, on the other hand, negates the generator
of the *same* chordal line.  A shared two-element character therefore does not
yet identify the two orientation torsors.

## Human proof spine

1. Apply the central idempotent
   `(5/60) sum_g chi_5(g)g` to the Paper-II quotient.  Its rank is five;
   Paper II's existing constituent calculation gives the same conclusion.
2. The degree-six permutation character is `1+chi_5`, so its augmentation
   is the same irreducible module.  Schur's lemma makes the projective
   intertwiner unique.
3. The outer automorphism of `A_5` is forced here: without it, the natural
   `P^1(F_11)` Veronese orbit is the other `A_5/C_5` orbit in the same
   projective representation.  The normalizer of the six-axis `A_5` in
   `S_6` has order `120`; conjugation by its outer coset gives the required
   twist.
4. In the resulting basis the stored cubic becomes eight times the Hankel
   determinant above.  This is one finite coefficient identity, displayed
   by the exact projectivity in the certificate.
5. The gradient of the Hankel determinant vanishes exactly on the rank-one
   Hankel locus, the rational normal quartic.  Its `F_11`-points are
   `P^1(F_11)`, hence twelve points with stabilizer `C_5`.
6. Each Sylow `5`-subgroup fixes exactly two points of `P^1(F_11)` and its
   normalizer is `D_5`.  Equal-stabilizer pairing therefore recovers the six
   axes intrinsically.
7. The conference cubic has six isolated ordinary nodes, whereas the
   projected Paper-II cubic is singular along a curve.  This independently
   proves that the two projective cubic lines differ.

Steps 4 and the exact Paper-II projection currently rely on the finite
certificate.  A manuscript proof should print the intertwiner and the five
nonzero Hankel coefficients, then let the determinant identity replace a
large tensor table.

## The invariant pencil

The five-dimensional `A_5` module has a two-dimensional invariant cubic
space.  In the certificate's basis, the conference cubic and the projected
Paper-II chordal cubic span it.  Over `F_11`, the twelve rational pencil
parameters have the following visible singular-point counts:

| parameter | `F_11` singular points | orbit |
|---|---:|---|
| `[1:0]` | 6 | `A_5/D_5` |
| `[1:3]` | 10 | `A_5/S_3` |
| `[1:7]` | 12 | `A_5/C_5` on the second chordal curve |
| `[0:1]` | 12 | `A_5/C_5` on the Paper-II chordal curve |
| the other eight rational parameters | 0 | — |

The counts in this table refer only to rational points.  The two 12-point
rows are chordal cubics whose full singular schemes are rational normal
quartics; they are not twelve-node cubic threefolds.

This pencil is not itself a novelty candidate.  Pinardin--Zhang explicitly
write the two-dimensional invariant cubic pencil for the nonstandard
five-dimensional `A_5` action and identify its two chordal members.  The
surviving Paper-V question is the exact marked placement of the Paper-II
tensor and the reconstruction maps among the distinguished members.

## Consequence for Paper V

The earlier headline “the Paper-I, Paper-II, and Paper-III cubics are the
same marked cubic” must be retired.  A viable stronger replacement is:

> the Paper-I conference cubic and the five-isotypic shadow of Paper II are
> distinguished members of one marked icosahedral cubic pencil; the former
> recovers the six axes from six nodes, while the latter recovers the same
> axes from the twelve rational points of its singular quartic.

That is not yet a round-trip theorem.  The remaining kill gate is to show
that the declared Paper-II marking canonically chooses the correct chordal
member and orientation, and that the six-axis conference package reconstructs
exactly the retained Paper-II chordal output rather than only its abstract
`A_5` carrier.  The two chordal members are exchanged by the outer normalizer,
so this is precisely where the marking and orientation conventions must be
printed.

The exact outer action sharpens this gate: a six-axis outer relabelling
exchanges the two chordal lines rather than acting as Paper II's scalar sheet
sign on one fixed line.  Any oriented theorem needs an additional marked
construction relating these operations.  Without it, the honest theorem is
projective and unoriented.

## Evidence and trust boundary

Primary certificate:

- `papers/clebsch-round-trip/verification/evidence/paper_ii_chordal_axis.py`;
- `papers/clebsch-round-trip/verification/evidence/paper_ii_chordal_axis.json`.

Replay:

```text
python3 papers/clebsch-round-trip/verification/evidence/paper_ii_chordal_axis.py --check
```

The script uses only the standard library and Paper II's frozen matching
arithmetic.  It reconstructs the `H_3` quotient, sheet tensor, central
projection, six-pair action, outer normalizer, and `Sym^4` intertwiner.  It
then compares all cubic coefficients, verifies the Hankel determinant, and
censuses every rational member of the invariant pencil.  It does not prove
the remaining orientation round trip.  The independent replay below checks
the finite result through a separately written computation; neither
calculation proves the remaining naturality or orientation theorem.

An independent cold replay reconstructed the quotient, central projector,
intertwiner, signed tensor, singular locus, stabilizer fibres, normalizers,
direct and outer-twisted `Sym^4` comparisons, and conference gauges from the
two frozen Paper-II inputs.  It did not import this certificate.  It reproduced
the normalized 35-coefficient vector with raw-byte SHA-256
`c854b0500d67bc25c486a01b1be5ad9e82cf5cf71bac04c06f5f4eb9cf5acaed`,
the `12/6` singular counts, six size-two `C_5` fibres, rank-two cubic span,
failure of the direct Hankel comparison, and success of the outer-twisted
comparison.  A second independent check also reproduced the full pencil
action `[a:b] -> [-a+8b:b]` and all four distinguished rational parameters.
No discrepancy was found.

## Literature boundary

Pinardin--Zhang, *A5-equivariant geometry of quadric threefolds*, arXiv
`2508.11496`, was read at **partial** depth: §3.2 and §§6.1--6.2, including
equations (6.3)--(6.5).  Cached arXiv PDF SHA-256:
`c0279ed450210aaba183f45eabae9b56a716032b2d7e7323879f1e4c9cb1b976`.
It owns the nonstandard five-dimensional action, the invariant cubic pencil,
and the two chordal members with singular rational normal quartics.  It does
not discuss Paper II's matching quotient or signed tensor.

The exact older-source chain and the characteristic-11 specialization remain
under audit.  No novelty sentence is licensed yet.  MathSciNet is not covered.
