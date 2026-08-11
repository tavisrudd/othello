# C904 Paper V inevitability/intrinsic A--D structural audit

**Lane:** `clebsch`

**Date:** 2026-08-11

**Status:** independent conceptual red-team; no manuscript or Lean edits

## Verdict

**MINOR.** The finite-field invariant count, subgroup recovery, normalized
outer action, simplex reconstruction, and general conference root--weight
theorem are correct.

The proposed construction of \(q\) through the recovered literal
augmentation module removes the apparent sign ambiguity: scalar choices in
the intertwiner cancel under conjugation, and \(-q\) is not a permutation
lift. The genuine remaining issue is full faithfulness after arbitrary
scalar extension. An actual cubic generator kills scalar automorphisms only
up to \(\mu_3\). Over extensions containing nontrivial cube roots of unity,
\(\lambda I\) preserves a cubic when \(\lambda^3=1\). Adding the canonical
augmentation quadratic form and requiring isometries kills this residue,
since then \(\lambda^2=\lambda^3=1\) forces \(\lambda=1\).

## 1. The field and invariant pencil

Since \(11\nmid60\), Maschke applies. The ordinary character fields of
\(A_5\) lie in \(\mathbf Q(\sqrt5)\), and \(5=4^2\) in
\(\mathbf F_{11}\). Finite-field Schur indices are trivial, so
\(\mathbf F_{11}\) is a splitting field for \(A_5\). The irreducible degrees
are

\[
                         1,3,3,4,5,
\]

whose squared sum is \(60\). Thus the relevant five-dimensional module
remains absolutely irreducible over every extension \(K/\mathbf F_{11}\).

For its character

\[
 \chi_5=(5,1,-1,0,0)
\]

on \(1,2A,3A,5A,5B\), the symmetric-cube formula gives

\[
 \chi_{\operatorname {Sym}^3}=(35,3,2,0,0).
\]

Therefore

\[
 \dim\operatorname {Sym}^3(A^*)^{A_5}
 =\frac{35+15\cdot3+20\cdot2}{60}=2.
\]

The same calculation holds in characteristic eleven: the group algebra is
split semisimple and the Reynolds idempotent commutes with scalar extension.
Hence the pencil statement is uniform for all \(K/\mathbf F_{11}\).

### The normalized outer action really is canonical

Recover first

\[
                        \Omega=A_5/D_{10}
\]

from \(R_h\), and form the literal augmentation module
\(A_\Omega=\operatorname {Aug}(K^\Omega)\). Let
\(T:A\to A_\Omega\) be a nonzero intertwiner. Absolute irreducibility makes
\(T\) unique up to scalar. For a literal permutation
\(\tau\in N_{S_\Omega}(A_5)\setminus A_5\), put

\[
                        q=T^{-1}P_\tau T.
\]

Replacing \(T\) by \(\lambda T\) does not change \(q\). Replacing \(\tau\)
by another representative multiplies \(P_\tau\) by an \(A_5\)-operator,
which acts trivially on
\(\Pi=\operatorname {Sym}^3(A^*)^{A_5}\). Hence the induced **linear**
action on \(\Pi\) is representative-independent. The abstract alternative
extension \(-q\) is irrelevant: it is not induced by a permutation of the
recovered six-set.

Thus the normalized matrix

\[
                 [q]=\begin{pmatrix}-1&8\\0&1\end{pmatrix}
\]

and \(q(h)-h=8c\) are legitimate once the augmentation construction is
printed. This validates the causal order

\[
 h\to R_h\to\Omega\to A_\Omega,\ q\to c.
\]

### The actual scalar issue: a hidden \(\mu_3\)

If carrier morphisms are defined as all \(A_5\)-equivariant linear maps
preserving the actual cubic \(h\), then

\[
                  \lambda I\in\operatorname {Aut}(A,h)
                  \quad\Longleftrightarrow\quad \lambda^3=1.
\]

There is no nontrivial cube root in \(\mathbf F_{11}\), but the theorem is
claimed after every extension \(K/\mathbf F_{11}\), and such roots occur
already over \(\mathbf F_{11^2}\). Therefore “the actual generator kills
hidden scalar automorphisms” is not uniformly true.

The clean intrinsic fix is to use the literal quadratic augmentation module

\[
 \left(\operatorname {Aug}(K^\Omega),
 Q_\Omega(x)=\sum_{\omega\in\Omega}x_\omega^2\right)
\]

and isometries, or to retain a normalized actual invariant quadratic form
\(Q\) on \(A\). A scalar preserving \(Q\) and \(h\) satisfies
\(\lambda^2=\lambda^3=1\), hence is the identity.

The word “canonical” needs this exact scope. The line of invariant quadratic
forms on an abstract \(A\) is canonical, but an actual form is not determined
by \(h\): the surviving \(\mu_3\) fixes \(h\) and rescales \(Q\) by
\(\lambda^2\). Thus either define the minimal carrier literally on
\(\operatorname {Aug}(K^\Omega)\), or add \(Q\) to the minimal datum.
Merely declaring arbitrary scalar intertwiners inadmissible is a valid
restricted category, but it is not an intrinsic linear-isomorphism category.

## 2. The \(C_5\)-to-\(D_5\) orbit recovery

On the singular rational normal quartic \(R_h\simeq\mathbf P^1\), each of
the six Sylow-five subgroups fixes two points. These points are defined over
\(\mathbf F_{11}\): an order-five element is split in
\(\operatorname {PGL}_2(\mathbf F_{11})\), since
\(\mu_5\subset\mathbf F_{11}^{\times}\).

For a Sylow subgroup \(C_5\),

\[
                         N_{A_5}(C_5)=D_{10}
\]

(called \(D_5\) in the Paper V notes). The normalizing involution exchanges
the two eigenlines because it sends a fifth-root eigenvalue to its inverse.
Consequently all twelve points have exact stabilizer \(C_5\), the divisor is
the constant reduced orbit \(A_5/C_5\), and equal-stabilizer pairing is the
canonical finite étale quotient

\[
                 A_5/C_5\longrightarrow A_5/D_{10}.
\]

This survives every scalar extension \(K/\mathbf F_{11}\), even if \(K\)
is imperfect. The six-set is canonical: \(D_{10}\) is self-normalizing, so
\(A_5/D_{10}\) has no nontrivial \(A_5\)-equivariant automorphism. Once the
six nodes of \(c\) have the same stabilizers, their identification with this
quotient is unique.

## 3. Triangle cocycles and pair balance

Let \(c_{ijk}\in\{\pm1\}\). If

\[
 c_{ijk}c_{ij\ell}c_{ik\ell}c_{jk\ell}=1
\]

on every tetrahedron, then \(c\) is a multiplicative two-cocycle on the full
five-simplex. Its positive-degree cohomology with coefficients \(\mu_2\)
vanishes, so there are edge signs \(b_{ij}=b_{ji}\) with

\[
                         c_{ijk}=b_{ij}b_{ik}b_{jk}.
\]

Two lifts differ by \(b_{ij}\mapsto a_i a_jb_{ij}\), exactly diagonal
switching. No additional gauge survives.

For the zero-diagonal symmetric sign matrix \(B=(b_{ij})\),

\[
 b_{ij}\sum_{k\notin\{i,j\}}c_{ijk}
       =\sum_{k\notin\{i,j\}}b_{ik}b_{kj}=(B^2)_{ij}.
\]

Thus pair balance is precisely the off-diagonal equation in \(B^2=5I\),
while \((B^2)_{ii}=5\) counts the five unit edge signs. Over
\(\mathbf F_{11}\) there is no modular alias: the sum contains four signs
and lies between \(-4\) and \(4\), so vanishing modulo eleven is ordinary
two-plus/two-minus balance.

## 4. General symmetric-conference saturation

Let \(B\) be a normalized symmetric conference matrix of order
\(n\equiv2\pmod4\), let \(L=\mathbf Z^n\), \(h=\mathbf1/2\), and
\(\varphi=(I+B)/2\). Every column of \(I+B\) is odd, hence

\[
                         \varphi L\subset L+\mathbf Zh.
\]

The normalized row sums of \(B\) are \(n-1,1,\ldots,1\), so, with
\(m=(n-2)/4\),

\[
                         \varphi h=h+me_0.
\]

Therefore \(D_n^\vee=L+\mathbf Zh\) is stable. It is minimal among stable
overlattices containing \(L\), because \(\varphi e_0=h\). Switching does
not change it: a diagonal sign matrix sends \(h\) to \(h\) modulo \(L\).

The polynomial identity is exact:

\[
                 \varphi^2-\varphi=\frac{n-2}{4}I=mI.
\]

Modulo two the generated coefficient algebra is

\[
                 \mathbf F_2[t]/(t^2+t+\bar m).
\]

For \(n\equiv6\pmod8\) this is \(\mathbf F_4\). For
\(n\equiv2\pmod8\) it is \(\mathbf F_2\times\mathbf F_2\), not merely a
quotient: in the basis \(h,e_1,\ldots,e_{n-1}\),

\[
 \bar e_0=\sum_{i>0}\bar e_i,
 \qquad \bar\varphi(\bar e_0)=\bar h,
\]

so \(\bar\varphi\) is neither zero nor the identity. This is the one line
missing from the current split-case proof sketch.

The order-six assertions agree with this theorem. Normalizing
\(\mathbf Z[\sqrt5]\) to \(\mathbf Z[(1+\sqrt5)/2]\) changes the special
fibre from the dual numbers to \(\mathbf F_4\). The committed exact
certificate separately verifies the unique nonsplit sequence

\[
 0\to H\to D_6^\vee/2D_6^\vee\to\mathbf F_4\to0
\]

and Frobenius on the four-dimensional six-point heart.

## Required blueprint repairs

1. Print the literal augmentation/intertwiner construction of \(q\); this
   proves that scalar choices cancel and that outer representatives act
   identically on the invariant pencil.
2. Replace the claim that actual cubic generators kill all scalar
   automorphisms by either the literal quadratic augmentation model or a
   normalized invariant \(Q\) with isometric morphisms.
3. In the arbitrary-\(K\) statement, say that the exact-\(C_5\) divisor and
   node six-set are constant finite étale \(A_5\)-schemes, not merely
   geometric point sets.
4. In the split conference case, add the non-scalar check above before
   identifying the coefficient algebra with
   \(\mathbf F_2\times\mathbf F_2\).

No other counterexample was found in the audited representation, subgroup,
simplex, or root--weight claims.

## Vibe

The structural spine is sound. The normalized outer operator survives the
red-team. The only real defect is the \(\mu_3\) scalar stabilizer created by
the claimed arbitrary scalar extension; the quadratic augmentation form
removes it cleanly.
