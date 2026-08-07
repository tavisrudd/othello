# C834 — a structural proof that admissible sets are passant rows

**Date:** 2026-08-07 · **Lane:** `clebsch` · **Task:** C834 (Paper IV full Lean release closure)

## What this settles

The two halves left open by the mystery ledger of
`notes/2026-08-06-c834-row-uniqueness-kernel-closure.md` are proved, and by one theorem rather than
two arguments. Of the 4186 index triples that are pairwise passant-joined with zero triple
concurrence, the 2730 collinear ones extend by exactly the four remaining internal points of their
passant and the other 1456 do not extend at all, because:

> **Quadruple theorem.** Four internal points of the conic plane that are pairwise passant-joined
> and all four of whose triples have zero concurrence are collinear.

Everything else follows. A collinear admissible triple can only be extended inside its own passant,
and a non-collinear one cannot be extended at all; an admissible seven-set is a passant row; and the
converse half — that the four remaining points of a passant really are admissible — is the statement
that no minimum support contains three collinear points, proved below.

The proof replaces the layer's passant-clique search by two rational invariants of a triple of
internal points and one exhaustion over six field elements. It is structural in the sense the ledger
asked for: no step ranges over the 78 internal points, the 364 supports, or subsets of either.

## The dictionary

Work with the conic \(C : y^2 - xz = 0\) over \(\mathbf F_{13}\), its polar form
\(B(P,R) = (2 y_P y_R - x_P z_R - z_P x_R)/2\), and \(\Delta(P) = B(P,P) = y_P^2 - x_P z_P\). A point
is internal exactly when \(\Delta(P)\) is a nonsquare, and the coordinate 3-space carries the
nondegenerate quadratic form \(\Delta\).

The identification that drives everything is the classical one between points off the conic and
involutions of \(\operatorname{PGL}(2,13)\): the point \(P = (x:y:z)\) corresponds to the trace-zero
matrix \(A_P = \begin{pmatrix} y & -x\\ z & -y\end{pmatrix}\), whose determinant is \(-\Delta(P)\),
and \(P\) is internal exactly when the corresponding involution is fixed-point-free, that is when it
lies outside \(\operatorname{PSL}(2,13)\). Trace-zero matrices form a three-dimensional quadratic
space under the determinant, whose Clifford algebra is the full matrix algebra; that is why the
Gram matrix of a family of internal points is at the same time a matrix of traces of products of
involutions and a matrix of values of the conic's polar form.

Scaling each lift to a common determinant \(\nu\) — possible over \(\mathbf F_{13}\) because any two
nonsquares differ by a square, and unique up to sign — gives normalized traces
\(g_{ij} = \operatorname{tr}(A_iA_j)/\nu\). Two invariants of the unnormalized coordinates express
them without square roots:

\[
 \rho(P,R) \;=\; \frac{4\,B(P,R)^2}{\Delta(P)\,\Delta(R)} \;=\; g_{PR}^2,
 \qquad
 \pi(P,R,S) \;=\; \frac{-8\,B(P,R)\,B(P,S)\,B(R,S)}{\Delta(P)\,\Delta(R)\,\Delta(S)}
 \;=\; g_{PR}\,g_{PS}\,g_{RS}.
\]

The per-point sign ambiguity cancels in \(\rho\) because it is a square and in \(\pi\) because each
point occurs in exactly two of the three factors. \(\rho\) is the invariant the manuscript already
uses to index the elliptic association scheme; the identity \(\rho(P,R) = \operatorname{tr}(A_PA_R)^2
/ (\det A_P \det A_R)\) says that it is nothing but the conjugacy class of the product of the two
involutions, and reads off the scheme:

| \(\rho\) | 0 | 1 | 3 | 9 | 10 | 12 |
|---|---|---|---|---|---|---|
| order of \(A_PA_R\) | 2 | 3 | 6 | 7 | 7 | 7 |
| pairs | 273 | 546 | 546 | 546 | 546 | 546 |
| join | secant | secant | secant | passant | passant | passant |

So two internal points are joined by a passant exactly when the product of their involutions has
order seven, the three classes \(\rho \in \{9,10,12\}\) being the three conjugacy classes of
order-seven elements. The seven internal points of a passant are the seven fixed-point-free
reflections of a dihedral group of order fourteen, which is why the row through a joined pair is
unique.

\(\pi\) is the missing triple invariant. Writing \(G\) for the Gram matrix of three internal points
under \(B\), a direct expansion gives

\[
 \frac{4\det G}{\Delta_1\Delta_2\Delta_3} \;=\; 4 - \bigl(\rho_{12}+\rho_{13}+\rho_{23}\bigr) - \pi ,
\]

so three pairwise-joined internal points are **collinear exactly when \(\sum\rho + \pi = 4\)**, the
Gram determinant vanishing precisely when the three coordinate vectors are dependent.

## Minimum supports contain no three collinear points

Three collinear internal points that are pairwise joined lie on a passant, so the statement needed
below is that no minimum support meets a passant in more than two points. For the three toric
families this is free of any computation, and in a sharper form.

Let \(L\) be a linear form cutting a secant of \(C\) and let \(\nu\) be a nonsquare. The conic
\(\Gamma = C - \nu L^2\) is bitangent to \(C\) at the two endpoints of the chord, and meets \(C\)
nowhere else, since \(\Delta = \nu L^2\) and \(\Delta = 0\) force \(L = 0\). Every point of
\(\Gamma\) off the chord therefore has \(\Delta = \nu L^2\) a nonsquare and is internal, so
\(\Gamma\) carries exactly twelve internal points. A line meets \(\Gamma\) in at most two points, and
a passant of \(C\) misses the chord, so a passant meets those twelve points evenly unless it is
tangent to \(\Gamma\). Expanding the adjugate of \(\Gamma\) shows that a tangent \(m\) of \(\Gamma\)
satisfies \(C^*(m)\,\bigl(\det C - \nu\,C^*(L)\bigr) \in -\nu\cdot(\text{squares})\), so no tangent
of \(\Gamma\) is a passant of \(C\) exactly when \(\det\Gamma = \det C - \nu C^*(L)\) is a nonsquare.
In the normalization \(L = [A:B:C]\) with \(\operatorname{disc}(L) = B^2-4AC\) this is
\(\chi(\nu\operatorname{disc}(L)-1) = -1\), which holds for exactly three of the six nonsquares
\(\nu\), one for each of the manuscript's parameters \(r \in \{2,5,11\}\). The 91 secants and those
three values reproduce all 273 conic supports, and each of them lies on a nondegenerate conic, hence
meets every line at most twice.

The remaining 91 supports form the octahedral orbit. They are twelve-arcs as well; this is the one
place where a finite check survives, and under the group action it is a check on a single orbit
representative — 220 collinearity determinants — rather than on 364 supports.

Consequently every pairwise-joined collinear triple has zero concurrence, which is the converse half
of the extension statement and accounts for all 2730 collinear admissible triples.

## The invariant classification of triples

\(\rho\) and \(\pi\) are invariant under the symmetric-square action of \(\operatorname{PGL}(2,13)\)
— the polar form and the discriminant acquire the same determinant factor, and both expressions are
bi-homogeneous of degree zero — and the minimum-support family is invariant as well. The pair
\((\{\rho_{12},\rho_{13},\rho_{23}\},\pi)\) therefore determines the number of supports containing a
pairwise-joined triple, and the complete table is:

| \(\rho\) profile | \(\pi\) | collinear | concurrence | triples |
|---|---|---|---|---|
| \(9,9,10\) | 2 | yes | 0 | 546 |
| \(9,10,12\) | 12 | yes | 0 | 1092 |
| \(9,12,12\) | 10 | yes | 0 | 546 |
| \(10,10,12\) | 11 | yes | 0 | 546 |
| \(9,9,9\) | 1 | no | 2 | 364 |
| \(9,9,12\) | 6 | no | 2 | 1092 |
| \(9,9,12\) | 7 | no | 5 | 1092 |
| \(9,10,10\) | 9 | no | 2 | 1092 |
| \(9,10,12\) | 1 | no | 2 | 2184 |
| \(9,12,12\) | 3 | no | 1 | 1092 |
| \(10,10,10\) | 5 | no | 4 | 364 |
| \(10,10,10\) | 8 | no | 0 | 364 |
| \(10,12,12\) | 7 | no | 0 | 1092 |
| \(12,12,12\) | 5 | no | 2 | 364 |

The four collinear rows are exactly the four shapes a triple of the seven reflections of a dihedral
group of order fourteen can take, distances \(\{1,1,2\}, \{1,2,3\}, \{2,2,3\}, \{1,3,3\}\) in
\(\mathbf Z/7\) under \(1 \mapsto \rho{=}10\), \(2 \mapsto \rho{=}12\), \(3 \mapsto \rho{=}9\); every
one of them satisfies \(\sum\rho+\pi = 4\).

Reading off the zeros: **a pairwise-joined triple is admissible exactly when it is collinear, or has
profile \((10,10,10)\) with \(\pi = 8\), or has profile \((10,12,12)\)** — the last profile forcing
\(\pi = 7\).

## The quadruple theorem

Let \(P_1,\dots,P_4\) be internal points, pairwise joined, all four of whose triples are admissible.
Normalize the four lifts to a common determinant and let \(g_{ij}\) be the six normalized traces.
Three facts constrain them.

1. \(g_{ij}^2 = \rho_{ij} \in \{9,10,12\}\), so each \(g_{ij}\) lies in \(\{3,5,6,7,8,10\}\).
2. Each triple is admissible, so each of the four triples \((g_{ij},g_{ik},g_{jk})\) satisfies the
   criterion above, written in the normalized traces as: the three-by-three Gram determinant
   \(8 - 2\sum g^2 - 2\,g_{ij}g_{ik}g_{jk}\) vanishes, or the squares are \((10,10,10)\) with product
   \(8\), or \((10,12,12)\) with product \(7\).
3. The four lifts are four vectors in a three-dimensional space, so the four-by-four Gram matrix with
   diagonal \(2\) and off-diagonal \(-g_{ij}\) is singular.

Exhausting the \(6^6 = 46656\) sign-and-value patterns leaves 480 solutions, and in every one of them
all four three-by-three Gram determinants vanish and the four-by-four Gram has rank two. Every triple
is therefore collinear; two triples sharing two points lie on the same line, so the four points are
collinear. Since two of them are passant-joined that line is a passant. \(\square\)

The exhaustion is the whole finite content of the theorem, and it is arithmetic in
\(\mathbf F_{13}\): no point, line, or support of the plane occurs in it.

## Corollaries

*Row uniqueness.* Let \(S\) be a set of at least four internal points, pairwise joined, with zero
triple concurrence. Every four-subset is collinear by the theorem, and two four-subsets sharing three
points lie on the same line, so \(S\) lies on a single passant. A passant carries exactly seven
internal points, so an admissible seven-set is a passant row, and conversely every passant row is
admissible because supports carry no three collinear points.

*The extension halves.* A collinear admissible triple on a passant \(\ell\) admits as fourth point
exactly the four remaining internal points of \(\ell\): any admissible fourth point makes an
admissible quadruple, hence lies on \(\ell\); and each of the four does extend, because triples
inside \(\ell\) have zero concurrence. A non-collinear admissible triple admits no fourth point at
all, since a fourth point would make the quadruple collinear. This is precisely the \(2730/1456\)
split, now with reasons rather than counts.

## What this leaves finite, and the Lean shrink

The current layer decides row uniqueness by a passant-clique search over increasing index lists
below 78, about 8500 extension nodes, split across seven residue modules and one declaration per
first index. The proof above replaces it with three pieces, none of which ranges over the plane:

1. **The invariant criterion.** \(\rho\) and \(\pi\) are rational in the displayed coordinates, and
   both are invariant under the group action, which the package already proves for the polar
   invariant and the support family. Transitivity on ordered joined pairs — the pair transporter
   generated for stage 2 — reduces the criterion to three representative pairs and their common
   joined neighbours, at most 126 triples, each resolved by a lookup in the 364 displayed supports.
   This replaces the whole clique search.
2. **The quadruple exhaustion.** A decidable statement over `ZMod 13` with 46656 patterns and no
   geometric data; with the first triple's admissibility used as a filter, and the per-point sign
   normalization fixing three of the six traces, a few hundred cases remain. This is the one new
   finite check and it is far below the package's measured per-module ceiling.
3. **The arc statement.** No support meets a passant in more than two points: structural for the 273
   conic supports, one orbit representative for the 91 octahedral ones.

The equivariance transport the previous ledger asked for — that the group carries passant rows to
passant rows — is still the enabling input for item 1, and it is now worth more than the 78-fold
reduction it was scoped for: it is what removes the search rather than shrinking it.

## Evidence

Regenerate or check from the repository root:

```sh
python3 notes/2026-08-07-c834-admissible-quadruple-gram.py          # writes the certificate
python3 notes/2026-08-07-c834-admissible-quadruple-gram.py --check  # verifies the tracked bytes
```

| artifact | bytes | sha256 |
|---|---:|---|
| `notes/2026-08-07-c834-admissible-quadruple-gram.py` | 16429 | `dce969c363d92654315dca6c291443e2d59a8aa6b93dba340b28b181de390796` |
| `notes/2026-08-07-c834-admissible-quadruple-gram.json` | 3513 | `7e6211bd466617f13d9eb2debcba4a7c03b51cc16e8d66c8318a45ad1a931c3c` |

The script builds the plane from the conic \(y^2 - xz\) with no input beyond the field, enumerates
the 364 minimum supports by a parity-driven search that never forms twelve-subsets, and independently
rebuilds the 273 conic supports from the bitangent-pencil construction of this report and asserts
that they are among them. It then certifies: the incidence numbers; that no support contains three
collinear points; that \(\rho\) separates the six scheme classes and that the passant-join relation
is \(\rho \in \{9,10,12\}\); that collinearity of a joined triple is equivalent to
\(\sum\rho+\pi = 4\), asserted for every one of the 11830 joined triples; the fourteen-row invariant
table above with zero criterion failures; the \(2730/1456\) extension split with the collinear pools
equal to the rest of the line; and the quadruple exhaustion.

What it does not certify: the Lean statements, which are unchanged by this round; and the
octahedral supports' arc property beyond the direct check over the displayed family, which is a
finite verification rather than an argument. The trusted boundary is CPython integer arithmetic and
the parity search's own correctness, the latter cross-checked by the independent bitangent
construction of three quarters of the family.

## Mystery ledger

* **Settled: why collinear admissible triples extend only inside their line, and why non-collinear
  ones do not extend.** Both are the quadruple theorem. The mechanism is that four internal points
  live in a three-dimensional quadratic space, so their six normalized traces satisfy one Gram
  relation, and admissibility pins each trace to six values and each triple to a short list of
  invariant classes; the relation then has no non-collinear solution.
* **Settled: why the 2730 collinear triples have zero concurrence.** Minimum supports carry no three
  collinear points, which for three quarters of them is because they lie on conics bitangent to
  \(C\).
* **Open: a structural reason for the octahedral family's arc property.** The 273 conic supports are
  arcs because a line meets a conic twice; the 91 octahedral supports are arcs by verification only.
  A uniform argument would most plausibly come from proving directly that a minimum support meets
  every passant in zero or two points, which the paper currently obtains from the fixed-point
  exhaustion's three empty domains. Owner: C834 stage 5 item 13, which owns that exhaustion.
* **Settled in passing: why \(\rho\) omits 4.** \(\rho\) is always a square, and the six scheme
  classes are the squares with \(4\) removed. \(\rho(P,R) = 4\) says exactly that the two-by-two Gram
  determinant \(\Delta_P\Delta_R - B(P,R)^2\) vanishes, that is, that the join of \(P\) and \(R\) is
  tangent to \(C\); and a tangent carries no internal point. In the involution reading the same
  statement is that the product is parabolic, of order thirteen, which cannot happen because every
  involution normalizing a Sylow-13 subgroup lies in \(\operatorname{PSL}(2,13)\) and so is external.
  This is not recorded anywhere in the package and is cheap to add alongside the criterion.
* **Open: the profile \((10,12,12)\) forces \(\pi = 7\), never \(\pi = 6\).** Both values are square
  roots of \(\rho_{12}\rho_{13}\rho_{23}\), and only one is realized. The same one-sidedness does not
  happen for \((10,10,10)\) or \((9,9,12)\), where both roots occur and separate the concurrence.
  This is a genuine gap in the invariant story: it says the pair \((\text{profile},\pi)\) is not a
  free parameter, and the constraint that cuts it down is not identified. It does not affect any
  statement above, which uses only the necessary direction.
