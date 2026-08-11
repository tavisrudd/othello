# C904 Paper V intrinsic V.A/V.D classification blueprint

**Lane:** `clebsch`

**Date:** 2026-08-11

**Status:** proof architecture. The existing exact marked round trip supplies
the maps; this note specifies what must be added for V.A and V.D to become
intrinsic classification theorems rather than image-restricted equivalences.

## 1. The classification object must not mention the source papers

Work over an extension \(K/\mathbf F_{11}\). Define an intrinsic marked
carrier from:

- a five-dimensional absolutely irreducible \(K A_5\)-module;
- its two-dimensional invariant cubic pencil \(\Pi\);
- an involution \(q\) normalizing \(A_5\) through its nontrivial outer class;
- an actual oriented nodal generator \(z\in\Pi\);
- a selected chordal line \(L\subset\Pi\) and actual generator \(h\in L\).

Do not include a conference matrix, Paper-II tensor, Paper-III chart lift, or
a phrase such as "arises from Paper I" in the definition.

The intrinsic axioms are scheme-theoretic and polynomial:

1. \(Z(z)\) has exactly six reduced ordinary nodes in projective-frame
   position.
2. The two chordal pencil members are exactly those singular along rational
   normal quartics, and \(q\) exchanges their lines.
3. The exact-\(C_5\) divisor on the selected quartic is \(A_5/C_5\), and
   equal-stabilizer pairing has quotient \(A_5/D_5\), canonically identified
   with the nodal six-set.
4. Intrinsic singular-frame and pivot normalization make \(q-1\) send \(h\)
   to \(z\), with the printed scalar in the chosen normalized basis.
5. The normalized triangle coefficients obey, for distinct indices,
   \[
   c_{ijk}^2=1,
   \qquad
   c_{ijk}c_{ij\ell}c_{ik\ell}c_{jk\ell}=1,
   \qquad
   \sum_{k\notin\{i,j\}}c_{ijk}=0.
   \]

The first two coefficient identities are the sign and tetrahedral cocycle
conditions. They reconstruct the edge signs uniquely up to switching. The
last is pair balance and gives the off-diagonal equations in \(B^2=5I\);
the diagonal equation follows from the five off-diagonal signs in each row.
The Pfaffian/norm identity is then a corollary, not a recognition hypothesis.

Morphisms come only from equivariant six-axis bijections and their induced
linear maps. They preserve \(z,L,h\) and every declared label. Arbitrary
scalar intertwiners are excluded.

## 2. Exact statement of V.A

Define independently:

- \(\mathscr C_{\mathrm{conf}}\): oriented golden conference packages modulo
  switching and coordinated relabelling;
- \(\mathscr C_{\mathrm{ch}}\): signed chordal packages with selected line,
  actual generator, and transported pivot convention;
- \(\mathscr C_{\mathrm{inc}}\): the retained Paper-III incidence output with
  ordered axes, scale, outer/Petersen labels, and carried bridge datum;
- \(\mathscr G\): the intrinsic carriers above.

Then V.A should assert, for every \(K/\mathbf F_{11}\), equivalences

\[
\mathscr C_{\mathrm{conf}}(K)
\simeq
\mathscr G(K)
\simeq
\mathscr C_{\mathrm{ch}}(K),
\]

and the corresponding equivalence with the declared retained-output
subgroupoid of \(\mathscr C_{\mathrm{inc}}(K)\).

The Paper-III qualification is load-bearing: the inverse returns the retained
incidence output, not a chart lift or global cover that was supplied as an
input.

### Fully faithful

Prove that a morphism of intrinsic carriers is determined by its permutation
of the six nodes. Carrier rigidity and preservation of actual generators kill
hidden scalar automorphisms. The induced permutation preserves triangle
coefficients and therefore the recovered switching class. The same map
preserves the selected chordal line, pivot, and exact-\(C_5\) pairing, so it
lifts uniquely to each source presentation.

### Essentially surjective

Starting from an intrinsic carrier:

1. recover the normalized node frame;
2. reconstruct edge signs from the tetrahedral cocycle;
3. use pair balance to prove \(B^2=5I\);
4. use \(q-1\) to recover the signed conference orientation from \(h\);
5. use the exact inverse tensor formula, including the pivot factor, to recover
   the retained chordal package;
6. use the carried bridge datum to recover exactly the retained incidence
   package.

None of these steps may start with the phrase "because the carrier is in the
image."

### Uniformity

The theorem should commute with scalar extension \(K/\mathbf F_{11}\). This
uses the already proved Reynolds-idempotent, Jacobian-scheme, constant
finite étale \(A_5/C_5\to A_5/D_5\), and exact tensor base-change statements.
It is not an integral spread-out or an arbitrary-characteristic theorem.

## 3. Exact statement of V.D

V.D should classify the marking-forgetful maps, not merely say that markings
are "load-bearing."

Construct the finite marking poset whose vertices remember specified subsets
of:

- the six-set embedding;
- outer/Petersen labels;
- the selected chordal line \(L\);
- the actual chordal generator \(h\);
- its sign or sheet;
- the oriented nodal generator \(z\).

For each edge \(\mathscr G^{m}\to\mathscr G^{m'}\), print:

| datum | required calculation |
|---|---|
| automorphisms | stabilizer subgroup before and after forgetting |
| fibre | explicit transitive action groupoid, not just its cardinality |
| dependence | whether another retained marking canonically selects a point |
| sharpness | an automorphism moving the forgotten datum |
| compatibility | action on every other retained datum |

Use the exact normalized pencil matrix

\[
[q]=\begin{pmatrix}-1&8\\0&1\end{pmatrix}.
\]

The outer involution exchanges the two chordal lines. Sheet reversal instead
negates the generator on one fixed chordal line. The table must compute their
combined action; it must not infer a product \(C_2\times C_2\) merely from two
binary choices.

After a chordal line is fixed, normalized \(q-1\) gives an equivariant
isomorphism

\[
\{\text{sheet signs on }L\}
\simeq
\{\text{conference orientations}\}.
\]

This is a dependence relation in the marking poset: the two torsors are not
independent pieces of missing information once the bridge is retained.

Sharpness requires an actual automorphism of the less marked object that
moves the forgotten datum and cannot occur as a morphism of the more marked
object. A count of two possible values is insufficient.

## 4. Proof compression

V.A and V.D need only four structural inputs:

1. tetrahedral cocycle reconstruction of a switching class;
2. pair balance for \(B^2=5I\);
3. carrier rigidity/full faithfulness;
4. the explicit normalizer and sheet action on the pencil.

The existing tensor inverses prove source return. They should appear once in
an inverse-formula lemma rather than be repeated in every categorical
composite.

## 5. Red-team gates

The classification is not intrinsic if:

1. an axiom says that an object is produced by one of the papers;
2. the conference matrix is inserted into \(\mathscr G\) instead of
   reconstructed;
3. the essential image is defined as the image;
4. ordinary-node or rational-normal-quartic claims are set-theoretic rather
   than scheme-theoretic;
5. full faithfulness allows arbitrary scalar intertwiners;
6. Paper III is claimed to recover an input chart lift;
7. a fibre is described only by its number of points;
8. two binary markings are declared independent without the combined action
   table;
9. scalar-extension functoriality is inflated into an integral model;
10. the Pfaffian identity is made an extra axiom although the triangle
    equations already reconstruct the conference package.

## 6. Payoff

With these statements, V.A is a recognition/classification theorem for an
intrinsically defined moduli groupoid, not a summary of three constructions.
V.D computes its exact information-loss lattice. Together they justify the
broader slogan:

> A sparse invariant is classified not only by what it reconstructs, but by
> the automorphism torsor that measures precisely what it forgets.

This is the part of Paper V most capable of moving the venue from a specialist
series finale toward Advances or Compositio. The lattice and Ext theorems
strengthen the output, but intrinsic V.A/V.D determine whether the paper has a
general reconstruction theorem.
