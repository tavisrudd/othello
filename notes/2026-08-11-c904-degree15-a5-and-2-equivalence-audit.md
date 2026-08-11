# C904: degree-15 packet, \(A_5\) labels, and two-equivalence

Date: 2026-08-11  
Scope: bounded primary-source and theorem-vocabulary audit; no manuscript or Lean edit  
Read depth: zero sources newly read cover-to-cover; four primary sources read at the partial depths recorded below  
Verdict: **no classical \(A_5\)-labelling found; the two-equivalence formulation is valid after compactification, but “same upper motive” is not presently justified**

## 1. The exact positive \(A_5\) fact

Let \(\mathcal H\) be the six normalizers of Sylow-\(5\) subgroups in
\(A_5\).  The following three transitive \(A_5\)-sets are canonically
equivariantly isomorphic:

\[
 \{g\in A_5:g^2=1, g\ne1\},\qquad
 \binom{\mathcal H}{2},\qquad A_5/V_4.
\]

Indeed, every involution lies in exactly two members \(H,H'\in\mathcal H\),
and \(g\mapsto\{H,H'\}\) is an equivariant bijection.  Thus a *transitive*
reduced \(A_5\)-set of length \(15\) is necessarily the involution set, or
equivalently the set of unordered pairs of the six \(D_5\)-axes.

Roulleau supplies the geometric incarnation already known on the Fano
surface: its fifteen smooth genus-two curves \(D_g\) are indexed by the
fifteen involutions, and for each \(D_5\subset A_5\) the sum of the five
curves indexed by its involutions is a fibre of an elliptic fibration.  He
does not discuss elliptic sextics, pairs of twisted cubics, \(D_{3,3}\), or
\(M_9\).

## 2. Why degree \(15\) alone does not identify the packet

For an \(A_5\)-cubic, the factorable-wedge construction is functorial, so
the finite degree-\(15\) cover

\[
                 R_{3,3}\dashrightarrow M_9
\]

is \(A_5\)-equivariant.  This is an action on the **cover over the moving
base**, not an action on the fibre over a general bundle \(E\): an element
\(g\in A_5\) sends \(R_E\) to \(R_{gE}\).  A generic \(E\) has no reason to
be \(A_5\)-fixed.  Consequently the assertion “the fifteen points of
\(R_E\) are the fifteen involutions” is not even intrinsically formulated
for generic \(E\).

There is a second obstruction to a global sheet labelling.  The explicit
characteristic-zero packet is a prime degree-15 field point, not a split
constant cover.  Voisin's intermediate \(Z\) is also irreducible, but
identifying the packet quotient with \(Z\) requires an additional linearity
calculation and is not used here.

An involution/axis theorem remains possible in either of two stronger
forms, neither supplied by the current count:

1. exhibit an \(A_5\)-fixed stable bundle \(E\) and prove that its packet is
   reduced and transitive, with point stabilizer \(V_4\); or
2. compute the geometric monodromy of the connected degree-\(15\) cover
   and prove that it is \(A_5\) in its coset action on \(A_5/V_4\).

The second \(A_5\) would be cover monodromy, not automatically the cubic's
automorphism group.  A comparison theorem would have to identify them.
No source located here supplies either statement.

## 3. Primary-source boundary

- **Roulleau, arXiv:1002.4467**, partial read: Theorem 11, Corollary 16,
  Lemma 19, and the \(A_5,D_5\) paragraphs.  Cache SHA-256
  `c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd`.
  This is the source for the fifteen involution curves and the \(D_5\)
  elliptic fibrations, but not for the new packet.
- **Hartlieb, arXiv:2304.03214**, partial read: Section 5.3, especially
  Lemmas 5.5--5.6, Proposition 5.7, and Remark 5.8.  Cache SHA-256
  `3e6e55c0277b44fadbcbea8cd9f1d4501d307caaab6d6fd5314af36c0b49ab01`.
  It identifies the irreducible \(A_5\)-cubic family and records
  \(J(X)\sim E^5\), but contains no elliptic-sextic or twisted-cubic packet.
- **Voisin, arXiv:1005.5621**, partial read: Section 2, especially Lemmas
  2.4 and 2.9.  Cache SHA-256
  `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.
  It supplies \(D_{3,3}\), \(M_9\), and \(Z\), with no \(A_5\) labelling or
  degree \(15\).
- **Haution, arXiv:1208.2586**, partial read: introduction and Section 2,
  especially Proposition 2.1 and Remark 2.2.  Cache SHA-256
  `4604f33d8a7daf0611ba9b2ad31abc1d05be517588fbd12d641151dc992c0651`.
  This is the theorem-vocabulary source for \(p\)-equivalence, canonical
  \(p\)-dimension, and the extra hypotheses needed for upper motives.

The bounded web screen used the exact queries

```text
"A5" "twisted cubic" "cubic threefold"
"alternating group" "elliptic sextic" "cubic threefold"
"fifteen" "twisted cubics" "cubic threefold"
"15" "D3,3" "cubic threefold"
```

and screened the fifteen returned title/snippet records.  The only
apparently close “fifteen twisted cubics” hit was metadata for the
Cheltsov--Shramov monograph on a different invariant-cubic construction;
its full text was not reached and it supports no conclusion here.  Exact
queries coupling \(D_{3,3}\), \(M_9\), degree \(15\), and canonical
\(2\)-dimension returned no relevant predecessor.  MathSciNet was not
covered; this licenses only “no predecessor located in the stated bounded
search,” not an unconditional priority claim.

## 4. The stronger safe formulation: \(2\)-equivalence

Put \(K=\mathbf C(J)\), and let

\[
 V=(M_9\dashrightarrow J)_\eta,\qquad
 Y=(S^2\Theta\to J)_\eta.
\]

Take smooth projective \(K\)-models \(\overline V,\overline Y\).  The full
type-\((3,3)\) incidence \(D_\eta\) gives a correspondence

\[
                    \overline V\dashrightsquigarrow\overline Y
\]

of multiplicity \(15\): choose the degree-15 zero-cycle on its generic fibre
over \(V\), spread it to a multisection, and push it through
\(D_\eta\dashrightarrow Y\).  No degree claim for Voisin's further quotient
\(Z\dashrightarrow M_9\) is needed.

Conversely, Voisin identifies the generic fibre of
\(D_\eta\dashrightarrow Y\) birationally with
\(\operatorname{Sym}^2(E_3)\).  A hyperplane divisor on the plane cubic
supplies a degree-three zero-cycle; its pair-sums give a degree-three
zero-cycle on the symmetric square.  Closing the resulting multisection
inside \(D_\eta\) gives the reverse correspondence

\[
                    \overline Y\dashrightsquigarrow\overline V
\]

of multiplicity \(3\).

Both multiplicities are odd.  In the terminology recalled by Haution from
Karpenko--Merkurjev, \(\overline V\) and \(\overline Y\) are therefore
**\(2\)-equivalent**.

### What transfers safely

1. \(\operatorname{cdim}_2(\overline V)=
   \operatorname{cdim}_2(\overline Y)\).
2. After every field extension \(L/K\), the two varieties have the same
   two-primary index: the two correspondences base-change, and the usual
   push-pull divisibilities in both directions give
   \[
   v_2(\operatorname{ind}\overline V_L)=
   v_2(\operatorname{ind}\overline Y_L).
   \]
3. Equivalently, each acquires an odd-degree zero-cycle over the function
   field of the other; their odd splitting behaviour is the same.

This is conceptually stronger than the single equality of two-primary
indices over \(K\): it packages the odd correspondences and makes the
equality stable under all field extensions.

### What does not yet transfer

- Do **not** claim that the Chow motives with \(\mathbf F_2\)-coefficients
  are isomorphic.
- Do **not** claim “the same upper \(2\)-motive.”  Haution's Remark 2.2 says
  that the converse from \(p\)-equivalence to a common upper summand needs
  geometric splitting and Rost nilpotence.  Neither is established for
  these models.
- \(2\)-equivalence does not imply birational or stable-birational
  equivalence, rationality, or equality of odd-primary index data.

## 5. Novelty and ceiling

The general language of \(p\)-equivalence is classical.  The likely-new
content is the specific pair of multiplicities \(15\) and \(3\) extracted
from Voisin's \(D_{3,3}\) architecture.  No exact predecessor was located
in the bounded screen.

This is the cleanest current conceptual statement of the index bridge, but
it does not raise the venue ceiling by itself: it is a strong structural
corollary of the degree-\(15\) theorem, not a replacement for the unresolved
odd-cycle gate.  It is valuable in an Annals-scale argument because it
isolates the entire two-primary obstruction on the unordered-theta side.

## Mystery ledger

- **Settled:** \(15=\binom62\) is the correct cardinality of the canonical
  \(A_5\)-set of involutions/axis pairs.
- **Settled:** cardinality and equivariance of the moving cover do not
  identify its sheets with that set.
- **Open:** whether a special \(A_5\)-fixed \(M_9\)-point has a transitive
  packet with stabilizer \(V_4\).
- **Open:** geometric monodromy of \(R_{3,3}\to M_9\), even on the
  \(A_5\)-cubic.
- **Settled:** the \(15\)- and \(3\)-correspondences give \(2\)-equivalence
  and equality of canonical \(2\)-dimension.
- **Open:** geometric splitting and Rost nilpotence; without them the
  upper-motive slogan is unavailable.
