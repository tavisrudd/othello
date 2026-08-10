# C904 Annals gate VII: the common-line Hecke quadric

Date: 2026-08-10
Status: quarantined Paper V research; no manuscript or Lean edits
Scope: the charge-two/charge-three boundary over the intermediate Jacobian

## Executive verdict

The common-line Hecke question has an exact local model. That model reduces
its odd-degree issue to the already isolated charge-two Brauer class and
adds an unconditional determinant-line parity theorem on the charge-three
target. It does not yet settle whether the Brauer class vanishes over the
generic point of the marked intermediate Jacobian.

Fix a charge-two instanton \(E_2\) and a general line \(L\subset X\). Put
\(F_2=E_2(1)\). Over a splitting field,

\[
 H^0(F_2)=V,\quad \dim V=6,\qquad
 F_2|_L\cong \mathcal O_L(1)\otimes W,\quad \dim W=2,
\]

and the restriction kernel \(A=H^0(F_2\otimes I_L)\) has dimension two.
After writing \(U=H^0(\mathcal O_L(1))\), the restriction map is

\[
                    V\longrightarrow U\otimes W,
       \qquad V\cong A\oplus(U\otimes W).
\]

Voisin's fixed-\((E_2,L)\) type-\((5,1)\) fibre is exactly

\[
 Q_{E_2,L}
 =\bigcup_{x\in L}\mathbf P H^0(F_2\otimes I_x)
 =\{[a,M]\in\mathbf P(A\oplus U\otimes W):\det M=0\}.
\]

Thus \(Q_{E_2,L}\subset\mathbf P^5\) is a rank-four quadric with vertex
\(\mathbf P(A)\cong\mathbf P^1\). The vertex is precisely the
Iliev--Markushevich pencil of quintics containing \(L\). Away from the
vertex, a rank-one matrix \(M\) has both a unique kernel point \(x\in L\)
and a unique quotient \(q:W\twoheadrightarrow k\). The two choices give
the two \(\mathbf P^3\)-bundle resolutions of the quadric.

The quotient ruling is Faenzi's compactified Hecke boundary. The elementary
transform

\[
             0\longrightarrow E_3\longrightarrow E_2
               \longrightarrow \mathcal O_L\longrightarrow0
\]

has

\[
 c_1(E_3)=0,\qquad c_2(E_3)=3[L],\qquad c_3(E_3)=0.
\]

After twisting, \(E_3(1)\) has
\((c_1,c_2,c_3)=(2h,6[L],0)\), the same numerical class as Voisin's
\(M_9\). The kernel \(E_3\) is nevertheless non-locally-free along \(L\):
it is a point of a Gieseker/instanton sheaf compactification, not a point of
Voisin's locally free \(M_9\) locus. For a fixed quotient \(q\), the
sections killed by

\[
 H^0(F_2)\longrightarrow H^0(\mathcal O_L(1))
\]

form one of the linear \(\mathbf P^3\)'s in the quotient ruling. At the
level of sections of torsion-free sheaves, their zero schemes are the
quintic zero curves with the common line added.

The intersection verdict is sharp:

\[
       \int_{Q_{E_2,L}}H^4=2,\qquad
       \int_{\mathbf P^3_q}H^3=1
\]

over a splitting field. Hence an odd top intersection exists
geometrically, but it requires a degree-one choice in the quotient ruling.

Let \(\alpha\in\operatorname{Br}K[2]\) be the charge-two moduli class at
the generic point \(K=\mathbf C(J)\). The spaces \(V,A,W\) above are
\(\alpha\)-twisted. Consequently

\[
 \mathbf P(V),\quad \mathbf P(A),\quad\text{and}\quad
 B_L:=\mathbf P(W^\vee)
\]

have the same Brauer class. The Hecke resolution is a
projective-three-space bundle over the Severi--Brauer conic \(B_L\).
Therefore

\[
             \operatorname{ind}(\mathcal H_L)
             =\operatorname{ind}(B_L)
             =\operatorname{ind}(\alpha)\in\{1,2\}.
\]

It follows that:

- if \(\alpha=0\), a rational quotient \(q\in B_L(K)\), followed by three
  hyperplane cuts in its \(\mathbf P^3\), gives an explicit odd top cycle;
- if \(\alpha\ne0\), the degree map on the Hecke carrier has image
  \(2\mathbf Z\), so the geometric class \(H^3[q]\) does not descend and
  every descended zero-cycle is even.

This is the exact answer for the one-common-line *compactified* Hecke
architecture. It is not a construction inside the locally free \(M_9\)
open. Voisin explicitly says that her bundle construction fails on
\(D_{5,1}\), where \(L\) is a base component. Her distinct linked divisor
\(D'_{5,1}\) parametrizes smooth sextics with a trisecant line and associated
locally free bundles restricting as
\(\mathcal O_L(3)\oplus\mathcal O_L(-1)\); it is not the Faenzi boundary.

The minimal unresolved gates are therefore the value of \(\alpha\), the
identification of Faenzi's smoothed charge-three component with the
component containing Voisin's \(M_9\), and the extension of its Abel--Jacobi
map to a proper model. An odd carrier intrinsic to the interior of \(M_9\)
is not ruled out.

There is also an unconditional, universal-twist-independent parity statement
for the standard determinant polarizations on \(M_9\). Numerically the
normalized charge-three class is

\[
                    v_3=2[\mathcal O_X]-3[\mathcal O_L].
\]

If \(a\in K(X)\) is orthogonal to \(v_3\), then

\[
 0=\chi(v_3,a)
  =2\chi(\mathcal O_X,a)-3\chi(\mathcal O_L,a),
\]

so \(\chi(\mathcal O_L,a)\) is even. The corresponding determinant line
has degree \(\pm\chi(\mathcal O_L,a)\) on the geometric Hecke conic. Thus
every twist-independent determinant polarization cuts that conic in even
degree, whether or not \(\alpha\) vanishes. If \(\alpha=0\), the geometric
odd ruling point exists, but it is not obtained from this determinant-line
sublattice.

## 1. Exact determinant-quadric model

Choose bases of \(U,W\) and write

\[
 M=\begin{pmatrix}a&b\\c&d\end{pmatrix}.
\]

A section of \(F_2\) has a zero on \(L\) precisely when its two restricted
linear forms have a common zero, equivalently

\[
                         ad-bc=0.
\]

The two \(A\)-coordinates do not occur. The polar matrix of \(ad-bc\) has
rank four, hence the vertex is \(\mathbf P(A)\). Fixing a kernel line in
\(U^\vee\), or fixing a quotient line of \(W\), leaves four vector
coordinates: in either case one gets a linear \(\mathbf P^3\subset Q\).

The dimensions are not inferred from the quadric. On the dense open of
generic pairs used by Iliev--Markushevich and Faenzi,

\[
 h^0(F_2)=6,\qquad F_2|_L\cong2\mathcal O_L(1),
\]

and Iliev--Markushevich's restriction-sequence calculation proves that

\[
 0\longrightarrow H^0(F_2\otimes I_L)
 \longrightarrow H^0(F_2)
 \longrightarrow H^0(F_2|_L)\longrightarrow0
\]

is exact. Hence the dimensions are \(2,6,4\). Evaluation at any point of
this generic line is surjective, so
\(h^0(F_2\otimes I_x)=6-2=4\). For a fixed quotient
\(q:E_2|_L\twoheadrightarrow\mathcal O_L\), the induced map

\[
 H^0(F_2)\longrightarrow H^0(\mathcal O_L(1))
\]

is also surjective, so \(h^0(E_{3,q}(1))=6-2=4\). Thus both rulings really
are projectivizations of four-dimensional kernels, not merely
dimension-count candidates.

This identifies three section-level pieces without an analogy gap:

1. the vertex consists of sections vanishing identically on \(L\), hence
   the unique Iliev--Markushevich pencil of reducible quintics containing
   \(L\);
2. the first ruling records the point \(x\in L\) at which a quintic meets
   the added line, exactly Voisin's displayed union over \(x\);
3. the second ruling records the quotient
   \(E_2|_L\twoheadrightarrow\mathcal O_L\), exactly Faenzi's elementary
   transform from charge two to a non-locally-free charge-three sheaf.

The third item compares section-incidence spaces. It does not identify
Voisin's divisors \(D_{5,1}\) or \(D'_{5,1}\) with a divisor in locally
free \(M_9\).

The zero-scheme comparison is exact.  For a section
\(s\in H^0(E_{3,q}(1))\) off the vertex, let \(C\) be the quintic zero
curve of its image in \(E_2(1)\).  Then \(C\cap L=\{x\}\) and

\[
 0\to I_{C\cup L}(2)\to I_C(2)
    \to I_{x,L}(2)=\mathcal O_L(1)\to0.
\]

Comparing this with
\(0\to E_{3,q}(1)\to E_2(1)\to\mathcal O_L(1)\to0\) and the Serre
sequence gives, by the snake lemma,

\[
       0\to\mathcal O_X\to E_{3,q}(1)
          \to I_{C\cup L}(2)\to0.
\]

Thus the second ruling gives the reducible \((5,1)\) zero scheme exactly at
the torsion-free-sheaf level, while Voisin's locally free construction
remains undefined there.

For a general point of the quadric away from its vertex, this comparison
also identifies the zero scheme exactly. Let \(s\in H^0(E_{3,q}(1))\) and
let \(C=Z_{F_2}(s)\) be its elliptic-quintic zero curve as a section of
\(F_2\). Then \(C\) meets \(L\) transversely in the unique zero of the
remaining \(\mathcal O_L(1)\)-component. The Serre sequence and the Hecke
sequence fit into a quotient diagram whose right column is
\[
 0\longrightarrow I_{C\cup L}(2)\longrightarrow I_C(2)
   \longrightarrow \mathcal O_L(1)\longrightarrow0.
\]
The snake lemma gives
\[
 0\longrightarrow\mathcal O_X\stackrel{s}\longrightarrow E_{3,q}(1)
   \longrightarrow I_{C\cup L}(2)\longrightarrow0.
\]
Thus the torsion-free section really has zero scheme \(C\cup L\), the
reducible type-\((5,1)\) sextic. At the vertex the restriction vanishes
identically and one reaches a deeper reducible stratum; this is why the
resolved incidence, rather than the singular quadric alone, is the correct
carrier.

## 2. Chow calculation and the uniform resultant theorem

There is a charge-independent calculation behind the quadric. Let \(C\) be
a smooth projective curve, let \(F\) be a generated rank-\(r\) bundle on
\(C\), and let \(V\twoheadrightarrow F\) be a generating space of dimension
\(N\). Put

\[
 K=\ker(V\otimes\mathcal O_C\to F),\qquad
 I=\mathbf P_C(K)\longrightarrow\mathbf P(V).
\]

Then the common-zero incidence has codimension \(r-1\), and in the Chow
group of \(\mathbf P(V)\), with its scheme-theoretic multiplicity,

\[
              q_*[I]=(\deg\det F)H^{r-1}.
\]

Indeed \(\operatorname{rk}K=N-r\), \(\deg K=-\deg F\), and

\[
 \int_I \xi^{N-r}
   =\int_C s_1(K)
   =-\deg K
   =\deg F.
\]

For every elliptic Serre zero locus on a cubic threefold, adjunction forces

\[
       \det F\cong\omega_X^{-1}\cong\mathcal O_X(2).
\]

Thus every rank-two, one-common-line section carrier has class \(2H\),
independently of its instanton charge. This is why passing from charge two
to the fine charge-three moduli problem does not make the whole common-line
carrier odd.

For the two possible generated splitting types on a line this statement is
also completely concrete:

- if \(F|_L\cong\mathcal O(1)\oplus\mathcal O(1)\), the image is the
  determinant quadric and the incidence map is generically one-to-one;
- if \(F|_L\cong\mathcal O\oplus\mathcal O(2)\), the reduced image is a
  hyperplane but the incidence map has generic degree two.

In both cases the pushed cycle is \(2H\). Hence degeneration of the
splitting type cannot manufacture an odd transfer.

## 3. The Chern-character check

On a cubic threefold use \(h^2=3[L]\), \(h[L]=[\mathrm{pt}]\). A normalized
charge-two bundle has

\[
             \operatorname{ch}(E_2)=2-2[L].
\]

Since \(\chi(\mathcal O_L(t))=t+1\) and
\(\operatorname{td}_1(X)=h\), Grothendieck--Riemann--Roch gives

\[
             \operatorname{ch}(\mathcal O_L)=[L]
\]

with zero point term. Therefore the elementary-transform kernel has

\[
             \operatorname{ch}(E_3)=2-3[L].
\]

Multiplication by \(e^h\) gives

\[
             \operatorname{ch}(E_3(1))=2+2h-2[\mathrm{pt}],
\]

which is equivalent to

\[
             (c_1,c_2,c_3)(E_3(1))=(2h,6[L],0).
\]

This is an exact numerical identification with the \(M_9\) class, not an
identification with the locally free \(M_9\) locus. Faenzi proves that this
non-reflexive kernel is stable, unobstructed, and deforms to locally free
charge-three instantons. A printed theorem identifying that smoothed
component with Voisin's component has not been located.

## 4. Twist-independent determinant-line parity

Let \(\overline B_L\cong\mathbf P^1\) be the compactified Hecke conic after
passing to a splitting field. The universal elementary transform has the
form

\[
 0\longrightarrow\mathcal E_3\longrightarrow
 E_2\boxtimes\mathcal O_{\mathbf P^1}\longrightarrow
 \mathcal O_L\boxtimes\mathcal O_{\mathbf P^1}(1)
 \longrightarrow0.
\]

For a numerical test class \(a\), determinant of cohomology gives

\[
 \deg\lambda_a|_{\overline B_L}
       =-\chi(\mathcal O_L,a),
\]

up to the harmless convention reversing all determinant lines. A universal
family can be replaced by
\(\mathcal E_3\otimes p_{M_9}^*N\). This changes \(\lambda_a\) by
\(N^{\chi(v_3,a)}\). Hence \(\chi(v_3,a)=0\) is exactly the condition that
the determinant line be independent of that choice.

Now

\[
 2\chi(\mathcal O_X,a)=3\chi(\mathcal O_L,a)
\]

forces \(\chi(\mathcal O_L,a)\) to be even. This proves:

> **Odd-charge Hecke determinant theorem.** For the normalized class
> \(v_n=2[\mathcal O_X]-n[\mathcal O_L]\) with \(n\) odd, every
> universal-twist-independent determinant line has even degree on a
> one-line elementary-Hecke curve.

This exposes an alternating two-primary trap. At even charge, the
determinant-weight ideal can retain the order-two moduli gerbe. At odd
charge the gerbe disappears, but all orthogonal determinant polarizations
have even Hecke degree. The theorem does not say that the entire Picard
group of a compactified \(M_n\) is determinant-generated; that is an
additional global input and is not assumed here.

## 5. Boundary normal and the apparent three-primary bypass

The literal boundary self-intersection is even too.  On a split Hecke fibre,
write the tautological sequence as

\[
 0\to S=\mathcal O(-1)\to W\otimes\mathcal O
     \to Q=\mathcal O(1)\to0.
\]

Locally along an ordinary line, the two graded pieces of the elementary
transform are \(S\boxtimes\mathcal O_X\) and \(Q\boxtimes I_L\).  A general
cubic line has \(N_{L/X}\cong\mathcal O_L^{\oplus2}\), so the unique
transverse smoothing direction is

\[
 \operatorname{Ext}^1_X(Q\otimes I_L,S\otimes\mathcal O_X)
  \cong\operatorname{Hom}(Q,S)\otimes H^0(L,\det N_{L/X})
  \cong\mathcal O_{\mathbf P^1}(-2).
\]

Faenzi's dimension count makes the elementary-transform locus a divisor in
the smooth nine-dimensional component.  Its normal line on the Hecke fibre
therefore has degree \(-2\).

The marked five-axis isogeny offers an apparently different odd route.  If

\[
 f:E^5\to J,
 \qquad \ker f=K_2\oplus K_3,
 \qquad |K_2|=2^4,\quad |K_3|=3^4,
\]

then the exotic marking defines

\[
 E^5\to B:=E^5/K_2\stackrel g\longrightarrow J,
 \qquad \deg g=3^4.
\]

This odd abelian-scheme factor does not automatically descend the integral
axis cycle.  Norm descent through \(K_2\) produces a cycle inducing \(16g\).
A primitive cycle on \(B\times X\) inducing \(g\) would, after composition
with the polarized dual \(h:J\to B\), produce \([3]_J\).  Combining that
with the known Fano-incidence \([2]\) cycle gives the identity by Bezout.
Conversely, an identity cycle pulls back along \(g\) to a primitive cycle
inducing \(g\).  Thus primitive two-primary descent of the odd isogeny is
another formulation of the universal-cycle gate, not a bypass.

## 6. What is proved and what remains

### Proved

- Voisin's fixed-line \((5,1)\) fibre is a rank-four determinant quadric.
- Its vertex is the known charge-two common-line pencil.
- Its quotient ruling is Faenzi's non-locally-free charge-three
  elementary-transform boundary.
- The whole carrier has top degree two.
- Over a splitting field, one quotient ruling fibre has odd top degree one.
- Over the generic field, the Hecke carrier has the same index as the
  charge-two Brauer class.
- The same factor two holds for every elliptic one-line Serre carrier,
  regardless of charge.
- Every universal-twist-independent determinant line on the odd-charge
  target has even degree on the Hecke conic.
- The boundary normal has geometric degree \(-2\).
- Factoring off the axis kernel's two-primary part gives an odd isogeny, but
  primitive integral cycle descent through that part is equivalent at the
  Abel--Jacobi level to the universal-cycle problem.

### Minimal unproved gates

1. Determine whether the special marked charge-two class
   \(\alpha\in\operatorname{Br}\mathbf C(J)\) vanishes.
2. Prove that Faenzi's smoothed charge-three component is the component
   containing Voisin's \(M_9\), and construct a proper model of its
   Abel--Jacobi/MRC map over \(J\).
3. Determine whether the relevant compactified \(M_9\) Picard group is
   generated by determinant lines. If so, the determinant parity becomes a
   full divisor-cut obstruction on the Hecke conic.
4. If \(\alpha\ne0\), an odd \(M_9\)-intrinsic carrier must avoid the
   one-common-line elementary-transform boundary.
5. To promote the boundary calculation to a global divisor-class statement
   on a compactification of \(M_9\to J\), one still needs a chosen stable
   compactification and control of indeterminacy along the deeper vertex
   stratum. This does not affect the generic index theorem above.

## 7. Replay certificate

Run:

    python3 notes/2026-08-10-c904-m9-common-line-hecke-parity.py

The script checks:

- exact rank four of the determinant quadric;
- both linear \(\mathbf P^3\) rulings;
- the two incidence-resolution point counts over
  \(\mathbf F_3,\mathbf F_5,\mathbf F_7\);
- top degrees two and one;
- the elementary-transform and twist Chern characters.

| artifact | SHA-256 |
|---|---|
| `2026-08-10-c904-m9-common-line-hecke-parity.py` | `b584e58f6202489de757c9b248e3bb128184d26ad7271792e84e53c7a8c8b91d` |
| `2026-08-10-c904-m9-common-line-hecke-parity.out` | `31d76175d204ea1a830823d55c906f4c3daf78094a3b1278d05cb3f8d013dca6` |

## 8. Literature audit

### Primary sources read for this gate

- D. Markushevich and A. Tikhomirov, *The Abel--Jacobi map of a moduli
  component of vector bundles on the cubic threefold*,
  arXiv:math/9809140. Exact locations: equation (7) and its Chern-class
  consequence on printed page 7; Lemma 2.1(c) on printed page 7;
  Corollary 2.4 on printed page 8; Lemma 2.7 and equation (14) on printed
  pages 11--12; and Lemma 5.1 / the projective-fibre construction in
  Section 5. These give \(c_1(E_2)=0,c_2(E_2)=2\),
  \(h^0(E_2(1))=6\), and the quintic \(\mathbf P^5\).

- A. Iliev and D. Markushevich, *The Abel--Jacobi map for a cubic
  threefold and periods of Fano threefolds of degree 14*,
  arXiv:math/9910058. Exact locations: Theorem 2.1(i) on printed page 9;
  Lemma 3.4 and its proof on printed pages 14--15; and Corollary 4.4 and
  the restriction-sequence calculation immediately following it on printed
  page 19. Lemma 3.4 identifies the unique linear pencil of quintics
  containing a fixed line. The calculation on page 19 records
  \(h^0(E_2(1)\otimes I_L)=2\), surjectivity of restriction, and
  \(E_2(1)|_L\cong2\mathcal O_L(1)\) for the generic pair used here.

- C. Voisin, *Abel--Jacobi map, integral Hodge classes and decomposition
  of the diagonal*, arXiv:1005.5621. Exact locations: the construction of
  \(M_9\), its Chern class, dimension, and \(\mathbf P^3\) section fibre on
  printed pages 10--11; the definitions of \(D_{5,1},D'_{5,1}\) and
  Remark 2.8 on printed pages 12--13; and the liaison plus displayed
  fixed-\((E,L)\) union on printed page 13. The union is
  \(\bigcup_{x\in L}\mathbf P H^0(Y,E\otimes I_x)\). These identify the
  exact boundary being modeled and the \(M_9\) Chern class.

- D. Faenzi, *Even and odd instanton bundles on Fano threefolds of Picard
  number 1*, arXiv:1109.3858. Exact locations: Theorem 3.1, Step 1 at the
  end of printed page 16 for the general-line triviality
  \(E_2|_L\cong\mathcal O_L^2\); and Steps 2--3 beginning on printed page
  17, especially equation (3.4), for
  \(0\to E_3\to E_2\to\mathcal O_L\to0\), stability, Chern classes,
  unobstructedness, and smoothing to locally free charge-three instantons.

### Exact derivation boundary

The sources do not print the rank-four \(\mathbf P^5\) determinant quadric
in this form. The identification is derived by combining:

1. Voisin's exact fixed-\((E,L)\) union;
2. Iliev--Markushevich's exact generic restriction
   \(E_2(1)|_L\cong2\mathcal O_L(1)\) and two-dimensional restriction
   kernel;
3. Faenzi's general-line triviality and elementary transform;
4. the elementary resultant identity for two binary linear forms,
   \(\operatorname{Res}(a_0x+a_1y,b_0x+b_1y)=a_0b_1-a_1b_0\).

The section-level identification of the second ruling with
\(0\to E_3\to E_2\to\mathcal O_L\to0\), its Chern calculation, and the
orthogonal determinant parity are likewise derivations in this note.
They concern the torsion-free compactification boundary. They do not
identify Voisin's \(D_{5,1}\), \(D'_{5,1}\), and locally free \(M_9\) as
moduli divisors.

### Novelty boundary

The source ingredients are classical and are not novelty claims. The new
research observation in this note is their compression into one determinant
quadric whose vertex, two resolutions, Hecke transform, Chow degree,
determinant parity, and Brauer descent give a single exact parity diagram.
A literature search specific to that compressed statement is still required
before any novelty claim.

The bounded forward-citation closure and the exact pre-emption boundary are
recorded separately in
`2026-08-10-c904-charge-three-instanton-literature-closure.md`.
