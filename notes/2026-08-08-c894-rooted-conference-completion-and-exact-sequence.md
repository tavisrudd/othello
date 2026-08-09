# C894 — rooted conference completion and the golden exact sequence

**Lane:** `clebsch` · **Date:** 2026-08-08 · **Scope:** solution of the
marked \(A_4\)-to-\(D_6\) comparison opened by EJ2; no manuscript or Lean
edits

## Verdict

The open problem has a canonical solution at exactly the marking level
available in the exterior-arc proof: a chosen matching edge is the root.

> **Rooted completion theorem.**  A labelled local Paley tournament on five
> vertices canonically determines a rooted oriented order-six conference
> switching class.  Its augmentation lattice embeds canonically and
> \(\mathcal O_5\)-linearly in the conference even lattice, in an exact
> sequence
> \[
> 0\longrightarrow A_4
>  \stackrel{\iota}{\longrightarrow}D_6
>  \stackrel{q}{\longrightarrow}\mathcal O_5
>  \longrightarrow0,                                    \tag{1}
> \]
> where
> \(\mathcal O_5=\mathbb Z[\phi]\), \(\phi^2=\phi+1\).

The map is not obtained by choosing bases.  After root normalization it is
the coordinate inclusion \(x\mapsto(0,x)\).  The quotient is also explicit:
\[
 q(x_0,x_1,\ldots,x_5)
 =x_0+\frac{x_0+x_1+\cdots+x_5}{2}\phi.                 \tag{2}
\]

The root is necessary.  Without it there is a canonical *family* of six
embeddings, permuted transitively by the conference \(A_5\), but no preferred
one.  This is the exact canonicity boundary.

## 1. Canonically border the local tournament

Let \(B\) be the signed adjacency matrix of the five-vertex local Paley
tournament: \(B^{\mathsf T}=-B\), its off-diagonal entries are \(\pm1\), and
\(B\mathbf1=0\).  Let \(E=\mathbf1\mathbf1^{\mathsf T}\).  Define
\[
 A_B=\frac{B^2+5I-E}{2},
 \qquad
 C_B=
 \begin{pmatrix}
 0&\mathbf1^{\mathsf T}\\
 \mathbf1&A_B
 \end{pmatrix}.                                        \tag{3}
\]

All assertions in (3) are structural.  Every regular tournament on five
vertices has a cyclic ordering in which
\[
 B=R+R^2-R^3-R^4,
\]
where \(R^5=I\).  Put \(P=R+R^4\), the adjacency matrix of the underlying
pentagon.  Direct multiplication in \(\mathbb Z[C_5]\) gives
\[
 B^2=3E-7I-4P,
 \qquad
 A_B=E-I-2P.                                           \tag{4}
\]
Thus \(A_B\) has zero diagonal, entry \(-1\) on the pentagon, entry \(+1\)
on its complement, and zero row sums.  On the augmentation subspace,
\(P^2+P-I=0\); on the constant line, \(A_B\) vanishes.  Hence
\[
 A_B^2=5I-E,
 \qquad C_B^2=5I.                                      \tag{5}
\]
So \(C_B\) is a symmetric conference matrix rooted at its first coordinate.

The construction is functorial under relabelling and satisfies
\[
 C_{-B}=C_B.                                            \tag{6}
\]
Consequently a rooted oriented conference class remembers the local
tournament only up to global reversal.  Conversely, root-normalize any
conference representative by switching every root edge to \(+1\).  Its
five-by-five core has negative graph a pentagon, so choosing either direction
of that pentagon recovers the two matrices \(B\) and \(-B\).  Thus (3) gives
a bijection
\[
 \{\text{labelled regular five-tournaments}\}/(B\sim-B)
 \longleftrightarrow
 \{\text{rooted oriented order-six conference classes}\}.       \tag{7}
\]

Root normalization is independent of the initial switched representative.
Indeed, if \(C\) is replaced by \(SCS\), the normalizing diagonal changes by
\(S\) and an irrelevant global sign.  Hence the rooted matrix and all maps
below belong to the rooted switching class, not to a chosen gauge.

## 2. The canonical maximal-order embedding

Let
\[
 D_6=\{x\in\mathbb Z^6:\textstyle\sum_i x_i\equiv0\pmod2\},
 \qquad
 L=\{y\in\mathbb Z^5:\textstyle\sum_i y_i=0\}=A_4.
\]
For the rooted matrix (3), set
\[
 \Phi_C=\frac{I+C_B}{2}\quad\text{on }D_6,
 \qquad
 \Phi_B=\frac{B^2+7I}{4}\quad\text{on }L.             \tag{8}
\]
Both are integral and satisfy \(X^2-X-I=0\).  Define
\[
 \iota:L\longrightarrow D_6,
 \qquad y\longmapsto(0,y).                             \tag{9}
\]
Since \(E y=0\), equations (3) and (8) give
\[
 \Phi_C\iota(y)
 =\left(0,\frac{I+A_B}{2}y\right)
 =\left(0,\frac{B^2+7I}{4}y\right)
 =\iota(\Phi_B y).                                     \tag{10}
\]
Therefore \(\iota\) is a canonical \(\mathcal O_5\)-linear embedding.
This proves the existence part of the open problem without choosing an
\(\mathcal O_5\)-basis of either lattice.

## 3. The quotient is one golden line

For \(x=(x_0,\ldots,x_5)\in D_6\), write
\(s(x)=\sum_i x_i/2\).  Equation (2) is well-defined because the coordinate
sum is even.  The rooted row sums of \(C_B\) are \(5,1,1,1,1,1\).  Hence, if
\(y=\Phi_Cx\),
\[
 y_0=s(x),
 \qquad
 s(y)=x_0+s(x).                                        \tag{11}
\]
Multiplication by \(\phi\) sends
\(a+b\phi\) to \(b+(a+b)\phi\), so (11) proves
\[
 q(\Phi_Cx)=\phi q(x).                                 \tag{12}
\]
Thus \(q\) is \(\mathcal O_5\)-linear.  It is surjective:
\(q(e_0-e_i)=1\) and \(q(2e_i)=\phi\) for \(i\ne0\).  Its kernel is exactly
\[
 x_0=0,qquad \sum_i x_i=0,
\]
which is the image of (9).  This proves exactness of (1).

The rank jump is therefore canonical: the conference carrier is the local
rank-two golden module extended by one golden line.

## 4. Splitting, gluing, and the integer five

Because \(\mathcal O_5\) is a PID, (1) admits \(\mathcal O_5\)-linear
splittings.  No splitting is selected by (1): the set of splittings is a
torsor under
\[
 \operatorname{Hom}_{\mathcal O_5}(\mathcal O_5,A_4)\cong A_4.  \tag{13}
\]
So the canonical result is the inclusion and quotient, not a preferred
direct-sum decomposition.

There is a canonical orthogonal golden line
\[
 N_0=\mathcal O_5\cdot2e_0
    =\mathbb Z\langle2e_0,\mathbf1_6\rangle,            \tag{14}
\]
because \(\Phi_C(2e_0)=\mathbf1_6\).  It is orthogonal to
\(\iota(A_4)\), but their direct sum is not all of \(D_6\).  The Gram
determinants are
\[
 \det A_4=5,
 \qquad
 \det N_0=\det\begin{pmatrix}4&2\\2&6\end{pmatrix}=20,
 \qquad
 \det D_6=4.
\]
Therefore
\[
 [D_6:\iota(A_4)\perp N_0]=5.                          \tag{15}
\]
The same integer that defines the golden field is the integral gluing index
between the local module and its canonical orthogonal golden line.

## 5. Exact canonicity and symmetry boundary

For each root \(r\) of an unrooted marked conference class, the same
construction gives
\[
 \iota_r(A_4)=
 \{x\in D_6:x_r=0,\ \textstyle\sum_i x_i=0\}.          \tag{16}
\]
The conference \(A_5\) permutes these six submodules transitively.  The
signed six-dimensional rational \(A_5\)-module is irreducible: over
\(\mathbb Q(\sqrt5)\) it splits into the two Galois-conjugate
three-dimensional icosahedral modules.  Any rational invariant subspace would
base-change to a Galois-stable sum of these irreducibles; the only such sums
have dimensions zero and six.  Hence there is no unrooted \(A_5\)-invariant
rational four-space, and therefore no unrooted canonical rank-four
sublattice.  Choosing the matching edge/root is both sufficient and
necessary.

At the rooted level the symmetry ladder is
\[
 C_5=\operatorname{Aut}(B)
 \ <\ D_{10}=\operatorname{Aut}(C_B,0)
 \ <\ A_5=\operatorname{Aut}([C_B]),                  \tag{17}
\]
where the first index-two extension adds the reflections that reverse the
local tournament, and the second lets the root move through the six-point
conference class.

Thus the local tournament does recover a canonical **abstract conference
\(A_5\)-completion**.  It does not by itself recover the original projective
Clebsch hexagon, its conic embedding, or the identification of its six roots
with an independently marked icosahedral six-axis set.

This is precisely a Clebsch-series forgetting/reconstruction phenomenon:
retaining the root but forgetting the projective realization leaves the
five-tournament; formula (3) reconstructs the abstract six-point switching
geometry and its \(A_5\).  Forgetting the tournament direction passes from
\(C_5\) to the rooted \(D_{10}\), and forgetting the root passes to \(A_5\).
What is lost is not the abstract completion but the external comparison map
back to the independently presented projective or harmonic object.

## 6. Implications for C894 and the series

| surface | implication | action |
|---|---|---|
| C894 local theorem | At \(q=11\), the directed local carrier canonically borders to the rooted conference class by (3), and its golden augmentation module is the kernel in (1). | Promote this from an unexplained endpoint comparison to one compact structural proposition after the local automorphism theorem.  Claim no independent novelty pending a targeted conference/tournament attribution check. |
| All-\(k\) programme | This closes the reconstruction step only after an all-\(k\) argument has produced the five-vertex \(q=11\) local carrier.  It does not classify saturated-internal or nonsaturated conic-filling configurations, and it gives no uniform conference completion for general \(k\). | Keep C756's bounded \((R,\gamma)\) classification/monodromy interface and masked Rédei target open.  Use the present theorem as the terminal \(q=11\) payoff, not as evidence that the all-\(k\) problem is solved. |
| Exterior-arc classification | The chosen matching edge is exactly the root needed for (9); the other five matching edges are the local tournament coordinates. | The bridge is intrinsic to the proof's normalization, not an arbitrary post-hoc identification.  The classification proof itself is unchanged. |
| Clebsch Paper I | The local pentagon now recovers an abstract rooted conference completion and hence an abstract \(A_5\) switching geometry. | Strengthens the explanation of why \(C_5\) sits inside the Clebsch \(A_5\).  Do not claim reconstruction of the projective hexagon without identifying the independent markings. |
| Clebsch Paper II | Bordering the unbordered Paley carrier produces the same order-six conference object used by the golden operator stream. | Gives a direct matrix bridge; factorization, Gorenstein, trade, and matching proofs remain independent. |
| Clebsch Paper III | The conference even lattice contains the local \(A_4\) as the rooted kernel of the golden coordinate map (2); the rank-three carrier is an extension of rank two by one golden line. | This is the exact integral connection previously missing.  Existing Paper III proofs need no change; a forward cross-reference can use (1). |
| Golden source-development stream | The unexplained \(\mathcal O_5^2\)/\(\mathcal O_5^3\) rank comparison is resolved by (1), while the orthogonal comparison has the nontrivial index-five gluing (15). | No new C-item is needed merely to seek a map.  Only the separate marking-identification problem remains if one wants the original projective and harmonic six-sets identified functorially. |
| Symmetry interpretation | The ladder \(C_5<D_{10}<A_5\) is forced by forgetting tournament orientation and then forgetting the root. | Use this as the safe group-theoretic explanation; distinguish abstract switching completion from projective-geometric recovery. |
| Series-wide reconstruction theme | A rooted local remnant reconstructs the abstract parent and its larger symmetry, while comparison with a separately marked geometric parent remains extra data. | Cross-post as a conceptual bridge to Papers I--III; do not promote it to a new headline theorem or a fifth numbered paper. |

## EJ + TT closeout

**EJ.**  The quotient map (2) is more informative than an embedding alone:
it explains the rank jump, identifies the missing golden line, and exposes
the index-five gluing.  Formula (3) also shows that no external conference
matrix needs to be imported at the endpoint; it is reconstructed from the
local tournament.

**TT.**  The correct object is a rooted exact sequence, not a chosen
decomposition.  Rooting converts the irreducible six-dimensional rational
\(A_5\)-module into a filtered \(D_{10}\)-module with golden ranks
\(2\) and \(1\).  Forgetting the root destroys the filtration, which proves
the canonicity boundary rather than leaving it as an ambiguity.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Does a canonical marked \(A_4\to D_6\) map exist? | settled positive | coordinate inclusion (9) after canonical root normalization |
| Is the rank \(2\)-versus-\(3\) comparison structural? | settled | exact sequence (1), quotient one golden line |
| Can the rooted conference object be reconstructed from the tournament? | settled | bordering formula (3), invariant under \(B\mapsto-B\) |
| Why does the integer five recur integrally? | settled at lattice level | orthogonal gluing index (15) |
| Is there a canonical direct-sum splitting? | settled negative from available data | splittings form the \(A_4\)-torsor (13) |
| Can the root be omitted? | settled negative | rational signed \(A_5\)-module irreducibility |
| Does this recover the original projective Clebsch hexagon? | still no | requires a functorial identification of the matching-edge six-set with the independently marked harmonic/conference six-set |
| Does this solve all-\(k\)? | no | it is the terminal \(q=11\) reconstruction after the hard classification step, not a replacement for the remaining C756 branches |
| Is the bordering/exact-sequence package new? | deliberately unclaimed | targeted literature attribution before any novelty sentence |

## Propagation checklist

- C894 owning card, live queue row, and Clebsch handoff: updated.
- EJ2 maximal-order report: corrected from “no canonical map” to the rooted
  exact sequence.
- Earlier local-Paley and cyclotomic reports: qualify “does not recover
  \(A_5\)” as “does reconstruct the abstract switching completion, but not
  the original projective marking.”
- C756: remains open on the saturated-internal and nonsaturated all-\(k\)
  branches; no status promotion.
- Papers I--III: implications recorded here for later cross-reference; no
  manuscript edit in this task.

## Next action

Insert the rooted completion theorem as one row in the C894
claim--proof--citation matrix.  The remaining human literature packet should
add `regular tournament order five conference bordering`, `rooted conference
matrix pentagon core`, and `D6 A4 golden exact sequence`; do not make this a
third headline or reopen Paper III prose under C894.
