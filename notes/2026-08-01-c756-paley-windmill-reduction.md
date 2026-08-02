# C756 — Paley windmill and signed-matching reduction

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Scope**: research only

## Verdict

The first-subconstituent rigidity theorem is not yet proved. This pass gives a
substantially more rigid necessary matrix problem and a stronger sufficient classification
target.

Let (q\equiv3\pmod4), let (S=(\mathbb F_q^*)^2), and suppose the normalized
saturated-external matching has edges

\[
 \{0,\infty\},\qquad \{s,-f(s)\}\quad(s\in S),
\]

where (f:S\to S) is the tournament automorphism obtained in the preceding Segre pass.
The cross-resultant signs and the arc condition produce a signed perfect matching
on the (q-1) nonzero field elements whose matrix (M) satisfies

\[
 M^2=-I,\qquad M\mathbf1=r,\qquad Mr=-\mathbf1,\qquad AM+MA=-2I. \tag{1}
\]

Here (A=(\chi(y-x))_{x,y\in\mathbb F_q^*}) is the skew adjacency matrix of the
vertex-deleted Paley tournament and (r=(\chi(x))_{x\in\mathbb F_q^*}). Thus the remaining
gate can be strengthened from an unconstrained automorphism problem to the classification
of monomial complex structures solving one linear anticommutator equation. The converse is
not asserted: an abstract signed matching satisfying (1) need not a priori reconstruct the
Paley relabeling from which (1) was derived.

The known (q=7,11) scalar matchings satisfy (1). The desired theorem would follow from:

> Every signed perfect-matching matrix satisfying (1) is induced by a
> multiplication--Frobenius map on (S).

The earlier coset Weil bound and genus-one argument would then leave only the Clebsch
hexagon after covering is imposed.

## 1. A mixed sign matrix has forced diagonal

Put

\[
 C_{s,t}=\chi(s+f(t))\qquad(s,t\in S).
\]

The second cross-resultant condition from the Segre pass is

\[
 C_{s,t}C_{t,s}=-1\qquad(s\ne t). \tag{2}
\]

Both the row and column sums of (C) are independent of their index. Indeed (f) is a
permutation of (S), so after scaling by the square (s),

\[
 \sum_{t\in S}C_{s,t}=\sum_{u\in S}\chi(1+u)=-1,
\]

and the same calculation applies to columns. If
(D=\operatorname{diag}(C_{s,s})), equation (2) says
(C^T=-C+2D). Applying both sides to (\mathbf1) gives

\[
 -\mathbf1=C^T\mathbf1=-C\mathbf1+2D\mathbf1
 =\mathbf1+2D\mathbf1,
\]

so (D=-I). Consequently

\[
 K:=C+I,\qquad K^T=-K. \tag{3}
\]

This removes a previously free diagonal sign at no cost.

## 2. The windmill disagreement form

Define a permutation (H) of (\mathbb F_q) by (H(0)=0) and, for (s\in S),

\[
 H(s)=-f(s)^{-1},\qquad H(-f(s))=s^{-1}. \tag{4}
\]

The two halves in (4) are disjoint and exhaustive. For distinct nonzero (x,y), the
Paley orientation is preserved by (H), except when
(\{x,y\}=\{s,-f(s)\}) is one of the matching edges; all edges incident with (0)
are reversed. To see the nonmatching cross case, write
(x=s), (y=-f(t)), (s\ne t). The ratio of the new and old difference characters is
exactly the product

\[
 \chi\bigl((s+f(t))(f(s)+t)\bigr)=-1,
\]

and the two reciprocal factors in (4) contribute the second sign reversal. The same-half
cases use that (f) preserves the induced Paley tournament. On a matching edge the two
sign reversals coalesce and the orientation is reversed.

Thus the disagreement graph between the Paley tournament and its relabeling by (H) is
the union of the star at (0) and the perfect matching
(s\leftrightarrow-f(s)). Its orientation is a windmill of ((q-1)/2) directed
triangles sharing (0).

## 3. The anticommutator identity

Index the nonzero elements of the field and let

\[
 A_{x,y}=\chi(y-x),\qquad r_x=\chi(x).
\]

Let (M) be the signed matching matrix supported on
(x\leftrightarrow H)'s matching partner, with its nonzero entry equal to the Paley sign
on that matching edge. The directed-triangle orientation gives

\[
 M^T=-M,\qquad M^2=-I,\qquad M\mathbf1=r,\qquad Mr=-\mathbf1. \tag{5}
\]

The full Paley skew matrix, with (0) first, is

\[
 Q=\begin{pmatrix}0&r^T\\-r&A\end{pmatrix},
 \qquad Q^2=J-qI.
\]

Relabeling by (H) reverses precisely the star and matching entries. Hence its skew
matrix is

\[
 Q'=\begin{pmatrix}0&-r^T\\r&A-2M\end{pmatrix}.
\]

Since (Q') is permutation-conjugate to (Q), it has the same square. Comparing the
lower-right blocks of (Q'^2=Q^2), and using (M^2=-I), gives

\[
 (A-2M)^2=A^2
 \quad\Longleftrightarrow\quad AM+MA=-2I.
\]

This proves (1).

There is also a useful spectral form. The plane
(U=\langle\mathbf1,r\rangle) is invariant under both (A) and (M), and both act on
it by the same complex structure. On
(W=U^\perp), one has (A^2=-qI), while (1) says that

\[
 N:=M-q^{-1}A
\]

anticommutes with (A) and satisfies

\[
 N^2=-(q-1)q^{-1}I.
\]

The continuous solutions are therefore plentiful; the remaining arithmetic content is
exactly that (M) is a signed permutation matrix supported on a perfect matching.

## 4. Routes closed and opened

The matrix identity rules out two tempting shortcuts.

* Ordinary spectral interlacing cannot distinguish the candidate: (1) forces the same
  two spectral planes for every solution.
* The Paley (4)-graph shortcut would first require a proof that the windmill permutation
  preserves that hypergraph. The matching identities above do not supply the switching
  relation used in that construction, so its (\mathrm{PGL}(2,q)) action cannot presently
  classify the solutions.

The live approaches are now:

1. classify the signed monomial solutions of (1), using the two forced vectors to remove
   the continuous (W)-freedom;
2. take entrywise moments of (1) against the matching permutation, converting the first
   nontrivial moment into a character sum over matching cycles; or
3. prove a stability form of Carlitz--McConnel: a permutation of the Paley tournament
   whose disagreement graph is this windmill must be semilinear.

Route 1 is the highest-EV next move because it retains the complete-mapping data and turns
the unknown into a sparse linear-algebra classification.

## 5. Literature boundary

This report makes no novelty claim. Zero sources were read in full; the following sources
were read partially and are used only to delimit attempted shortcuts.

* Xiong--Yip, *Extensions of the Carlitz--McConnel and Blokhuis--Sziklai theorems for
  unions of cyclotomic classes*, arXiv:2604.04126v1 — **partial**, HTML §§1--2. Its
  direction theorems require a full-field graph and do not apply to the half-domain map.
* Gunderson--Semeraro, *Tournaments, 4-uniform hypergraphs, and an exact extremal result*,
  arXiv:1509.03268 — **partial**, cached text §§1--2 and 5, cache SHA-256
  `e0f5afb711ffd5a11c4f7116545d5914341c482f57cfb6de9abf684cd4981c82`.
  Its Paley (4)-graph is switching-invariant, while the windmill disagreement pattern is
  not a switching cut; the paper therefore supplies no extension theorem for the map here.
* Meslem--Sopena, *On the Distinguishing Number of Cyclic Tournaments*, arXiv:1608.04866v4
  — **partial**, abstract and the Paley-routing portions. Its distinguishing-label result
  concerns automorphisms of the full cyclic tournament, not automorphisms of the first
  subconstituent.

## 6. EJ + TT closeout

The cheap extra value is the forced diagonal (C_{s,s}=-1): every surviving matching has

\[
 \chi(s+f(s))=-1\qquad(s\in S),
\]

a constraint absent from the prior statement of the local rigidity lemma. Tao's useful
reframing is to stop asking first for the full automorphism group of the induced tournament.
The matching itself supplies a sparse complex structure, and the Paley conference identity
turns all remaining signs into the single linear equation (1). Any proof should now attack
the incompatibility between that linear solution space and monomial support, rather than
separate Jacobi-sum eigenvalues of the entire circulant tournament.

No manuscript files were edited.

## 7. Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| The mixed sign diagonal is uniformly (-1) | settled | row and column sums; no gap |
| Every candidate yields (AM+MA=-2I) plus two forced vectors | settled | classify signed monomial solutions; no converse is claimed |
| The continuous solution space on (W) is large despite the sparse solutions being rare | explained linearly, not arithmetically | exploit monomial support in the anticommutator |
| Whether the windmill permutation has a useful higher-order invariant | open | the Paley (4)-graph switching theorem does not apply directly |
| Whether a nonsemilinear signed matching solution exists | open | exact owner: the next C756 pass |
