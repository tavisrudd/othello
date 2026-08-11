# C904 golden maximal-order to exotic \(\mathbf F_4\)-heart bridge

**Lane:** `clebsch`

**Date:** 2026-08-11

**Status:** exact theorem proved and independently replayed. This closes the
finite representation-theoretic golden-orientation/exotic-sheet calibration.
It does not by itself prove the cubic period-realization theorem.

## Theorem

Let \(B\) be the oriented symmetric conference matrix of Paper I,

\[
B^2=5I_6,
\qquad
L=\mathbf Z^6,
\qquad
h=\frac12(1,1,1,1,1,1),
\]

and put

\[
L^{\max}=L+\mathbf Zh,
\qquad
\varphi=\frac{I+B}{2}.
\]

Equivalently, if
\(D_6=\{x\in\mathbf Z^6:\sum x_i\equiv0\pmod2\}\), then
\(L^{\max}=D_6^\vee\), the \(D_6\) weight lattice.

Then:

1. \(L^{\max}=D_6^\vee\) is the minimal over-lattice of \(L\) preserved by
   \(\varphi\); it has \([L^{\max}:L]=2\), and
   \(\varphi^2-\varphi-1=0\). Thus \(L^{\max}\) carries the maximal golden
   order \(\mathbf Z[\varphi]\), even though
   \(\operatorname{End}_{\mathbf ZA_5}(L)=\mathbf Z[B]\simeq
   \mathbf Z[\sqrt5]\) is the index-two nonmaximal order.
2. The reduction
   \[
   M=L^{\max}/2L^{\max}
   \]
   is a three-dimensional vector space over
   \(\mathbf F_4=\mathbf F_2[\bar\varphi]\).
3. Its commutator submodule
   \[
   H=[A_5,M]
   \]
   is the unique nonzero proper \(\mathbf F_4A_5\)-submodule. It has
   \(\dim_{\mathbf F_4}H=2\), and \(M/H\) is the trivial
   \(\mathbf F_4\)-line. The extension is nonsplit: \(M\) has no invariant
   \(\mathbf F_4\)-line.
4. As an \(\mathbf F_2A_5\)-module, \(H\) is canonically isomorphic up to its
   scalar commutant to the four-dimensional six-point heart
   \[
   \operatorname{Aug}(\mathbf F_2^6)/\langle\mathbf1\rangle.
   \]
   Under any such isomorphism, \(\bar\varphi|_H\) becomes one of the two
   primitive endomorphisms
   \(\omega,\omega^2\in\operatorname{End}_{A_5}(H)=\mathbf F_4\).
   The result is independent of the chosen isomorphism because any two
   differ by an \(\mathbf F_4^\times\)-scalar, which commutes with
   \(\bar\varphi\).
5. Reversing the golden orientation sends
   \[
   B\longmapsto-B,
   \qquad
   \varphi\longmapsto1-\varphi,
   \qquad
   \omega\longmapsto\omega^2.
   \]
   The outer coset of \(N_{S_6}(A_5)/A_5\) acts by the same Frobenius
   involution.

Consequently the golden-orientation torsor reconstructed by Paper V is
canonically isomorphic to the exotic-gluing torsor
\(\{\omega,\omega^2\}\). This is the optional marked strengthening left open
in the publication plan.

## Structural proof

### 1. The maximal-order saturation is forced

For the displayed gauge, every column of \((I+B)/2\) has the same class
\(h\) modulo \(L\). Hence \(\varphi L\subset L+\mathbf Zh\), and any
\(\varphi\)-stable over-lattice containing \(L\) must contain \(h\). Directly,
\(\varphi h=h+e_0\), so \(L^{\max}\) is stable. The equation for \(\varphi\)
follows from \(B^2=5I\).

Switching does not alter the construction: for a diagonal sign matrix \(D\),
\(Dh-h\in L\), so \(D L^{\max}=L^{\max}\). Thus the saturation depends only
on the oriented switching class, not the displayed gauge.

This explains precisely why the earlier direct-reduction objection was both
correct and incomplete. One cannot reduce \(\mathbf Z[B]\) to
\(\mathbf F_4\); one first passes to the canonical index-two maximal-order
saturation. Identifying that saturation with the \(D_6\) weight lattice makes
its switching invariance intrinsic rather than a feature of the displayed
matrix.

### 2. The heart is the canonical commutator submodule

Use the integral basis \(h,e_1,\ldots,e_5\) of \(L^{\max}\). Modulo two, the
commutator submodule is

\[
H=\left\{
(0,x_1,\ldots,x_5):\sum_{i=1}^5x_i=0
\right\}.
\]

It is stable under \(\bar\varphi\), hence is a two-dimensional
\(\mathbf F_4\)-space. The quotient is a one-dimensional
\(\mathbf F_4\)-representation of the perfect group \(A_5\), hence is
trivial. In the displayed two-generator gauge, four commutators already span
\(H\); the primary certificate prints such a basis. The same row reduction
shows there is no invariant \(\mathbf F_4\)-line, so the extension does not
split and \(H\) is the unique proper \(\mathbf F_4A_5\)-submodule.

The five-letter augmentation module above and the six-point heart are the two
standard presentations of the same four-dimensional simple
\(\mathbf F_2A_5\)-module. Multiplicity one gives a two-dimensional
\(\mathbf F_2\)-Hom space, containing an isomorphism; the certificate prints
one \(4\)-by-\(4\) intertwiner. Transporting \(\bar\varphi\) gives a primitive
root of \(x^2+x+1\) in the heart commutant.

### 3. Conjugation is Frobenius

Golden reversal replaces \(B\) by \(-B\), so

\[
\frac{I-B}{2}=1-\varphi.
\]

Modulo two, if \(\bar\varphi=\omega\), then
\(1-\bar\varphi=1+\omega=\omega^2\). Independently, the outer normalizer
exchanges the two primitive elements of the heart commutant. The two
involutions therefore agree on the exotic gluing pair.

## What this closes

- The finite golden orientation now selects a literal exotic gluing, not only
  an unordered conjugacy class.
- The selection is functorial under switching and relabelling.
- The bridge uses the maximal-order saturation and its canonical commutator
  submodule; it is not an arbitrary identification of two two-element sets.
- The full golden orientation is now genuinely causal: the bare six-set does
  not choose \(B\), whereas the oriented continuation operator chooses
  \(\varphi\) and hence one primitive element of the exotic \(\mathbf F_4\).
- Paper V can remain structural: it outputs the orientation torsor. The
  epilogue proves the saturation theorem and consumes the resulting
  \(\mathbf F_4\)-sheet.

## What remains open

- The cubic axes must still be identified with the same six-set and their
  integral homology lattice with the selected graph gluing.
- The period-map image-normalization and generic-degree theorem remain
  separate family-level geometry.
- This calculation does not prove that every piece of the period family is
  deck-equivariant; deck-equivariance remains useful for the unmarked fallback.
- Priority for this exact saturation/heart bridge has not yet been audited.

## Second-order corollaries

### The exotic field is the normalized golden residue field

Let

\[
R=\mathbf Z[B]\simeq\mathbf Z[\sqrt5],
\qquad
\mathcal O=\mathbf Z[\varphi]
=\mathbf Z\!\left[\frac{1+\sqrt5}{2}\right].
\]

Then \(\mathcal O\) is the normalization of \(R\), with conductor two. Their
special fibres are qualitatively different:

\[
R/2R\simeq\mathbf F_2[\epsilon]/(\epsilon^2),
\qquad
\mathcal O/2\mathcal O\simeq
\mathbf F_2[t]/(t^2+t+1)=\mathbf F_4.
\]

Thus the exotic field is not an unrelated modular commutant. It is the
separable residue field obtained by normalizing the golden order before
reducing at the inert prime two. The lattice passage
\(L\subset D_6^\vee\) is the corresponding module normalization. Golden
Galois conjugation specializes to Frobenius:

\[
\varphi\longmapsto1-\varphi
\quad\rightsquigarrow\quad
\omega\longmapsto\omega^2.
\]

This gives the cleanest conceptual statement of the Paper V-to-epilogue
bridge.

### General symmetric-conference saturation law

Let \(B\) be a symmetric conference matrix of even order \(n\), normalized so
its first row is all ones off the diagonal, and assume \(n\equiv2\pmod4\).
Then

\[
B^2=(n-1)I,
\qquad
\varphi_B=\frac{I+B}{2},
\qquad
(D_n^\vee,\varphi_B)
\]

is the minimal \(\varphi_B\)-stable over-lattice of \(\mathbf Z^n\), and

\[
\varphi_B^2-\varphi_B=\frac{n-2}{4}I.
\]

Indeed \(\varphi_Be_0=(1/2)\mathbf1\), while orthogonality with the normalized
first row makes every other row sum equal to one; hence
\(\varphi_B(D_n^\vee)\subset D_n^\vee\). Modulo two, the coefficient algebra
is

\[
\mathbf F_2[t]/
\left(t^2+t+\frac{n-2}{4}\right).
\]

Consequently it is \(\mathbf F_4\) when \(n\equiv6\pmod8\), and split when
\(n\equiv2\pmod8\). The order-six bridge is the first irreducible case. What
is special to \(A_5\) is not the maximal-order saturation but the canonical
four-dimensional commutator heart inside the resulting \(\mathbf F_4^3\).

This general lemma is cheap and structural, but its priority in the
conference-matrix literature has not been audited.

## Reproducibility

Primary exact replay from `/home/tavis/src/othello/rust`:

```text
nix shell nixpkgs#python3 --command python ../notes/2026-08-11-c904-golden-maximal-order-f4-bridge.py --check
```

Independent Sage replay, using a different submodule-generation algorithm:

```text
C904_MODE=check nix shell nixpkgs#sage --command sage -c "exec(preparse(open('../notes/2026-08-11-c904-golden-maximal-order-f4-bridge-replay.sage').read()))"
```

The primary replay enumerates all \(720\) axis permutations, recovers the
oriented stabilizer of order \(60\), enumerates all \(21\) \(\mathbf F_4\)-lines
and planes, and solves the exact intertwining equations. The Sage replay
instead generates all \(\mathbf F_4[A_5]\)-submodules from vectors and verifies
the same unique four-dimensional submodule and transported endomorphisms.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-08-11-c904-golden-maximal-order-f4-bridge.py` | 14549 | `f2d9b0b55114f353b1cb1076ee1228cab7579825aac4b0466c1f2269813b7c75` |
| `2026-08-11-c904-golden-maximal-order-f4-bridge.out` | 1021 | `9381e97ef56e031da2f9b66d26a62d85a2218c9e1be64f04669aec61fcd3446d` |
| `2026-08-11-c904-golden-maximal-order-f4-bridge-replay.sage` | 6503 | `d858312452b6d2f04a5e7a57ba4a3bbad573b4a8bb3327a45db55541673046b2` |
| `2026-08-11-c904-golden-maximal-order-f4-bridge-replay.out` | 482 | `e748edd39bee62f5f6b723d09dd74fc6d213a6538f52931047f27122cb748fd4` |

Trusted boundary: the scripts certify the exact lattice, module, and
normalizer statements for the printed Paper I conference matrix and all its
switching/permutation gauges. The structural proof promotes that gauge check
using switching invariance and the intrinsic commutator construction. They do
not certify any period map, cubic family, or Chow-theoretic statement.

## EJ + TT closeout

The cheap upgrade is the recognition
\(L^{\max}=D_6^\vee\). It replaces an ad hoc half-vector enlargement by a
root--weight construction and explains why switching preserves the lattice.
The associated reduction is not the exotic heart itself but the canonical
nonsplit extension

\[
0\longrightarrow H_2\longrightarrow
D_6^\vee/2D_6^\vee\longrightarrow\mathbf F_4\longrightarrow0.
\]

This is stronger than the originally requested test: it identifies the exact
carrier of the missing factor two and proves that the full golden orientation
is used. A Tao-style compression is therefore available: the published proof
needs only the \(D_6\) root--weight lemma, the commutator-submodule lemma, and
multiplicity one for the four-dimensional heart. The exhaustive finite
enumeration remains a replay, not proof architecture.

One publication choice remains: the result is purely structural enough to be
the last theorem of Paper V, but leaving it in the epilogue preserves V's
finite-only boundary. The current plan leaves it in the epilogue; moving it is
an architecture decision rather than a mathematical gate.

## Mystery ledger

1. **Settled:** the missing factor two is exactly maximal-order saturation,
   not a contradiction between the golden and exotic fields.
2. **Settled:** the dimension mismatch \(3\) versus \(2\) over \(\mathbf F_4\)
   is resolved by the canonical nonsplit sequence
   \[
   0\to H\to M\to\mathbf F_4\to0.
   \]
3. **Settled:** the saturation is the classical \(D_6\) root--weight passage,
   and it proves that Paper V's orientation, rather than merely its abstract
   six-set, selects the exotic scalar.
4. **Open:** identify the nonsplit extension class intrinsically---for example
   as the unique nonzero class in an appropriate
   \(\operatorname{Ext}^1_{\mathbf F_4A_5}(\mathbf F_4,H)\). This is
   explanatory, not needed for the calibration theorem.
5. **Open:** audit whether the exact maximal-order/commutator bridge is already
   implicit in the modular representation literature or in the classical
   conference-matrix construction.
