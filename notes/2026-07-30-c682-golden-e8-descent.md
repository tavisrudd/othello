# C682 — golden descent of the degree-ten affine-\(E_8\) return

**Lane:** `clebsch`

**Status:** exact positive bridge at the first balanced harmonic slice; exact
same-tower obstruction and bi-McKay repair for the graded lift.

## Result

The Clebsch six-axis conference algebra occurs literally inside the Klein
affine-\(E_8\) return algebra.  This is an equality of exact operators, not
only a character or dimension match.

Put \(K=\mathbf Q(t,i)\), with
\[
t^2=t+1,\qquad i^2=-1,\qquad \sqrt5=2t-1.
\]
Use C682's six oriented icosahedral axes
\[
\begin{aligned}
 &(0,t,1),\ (0,t,-1),\ (1,0,t),\\
 &(-1,0,t),\ (t,-1,0),\ (-t,-1,0).
\end{aligned}
\]
For an axis \(a=(a,b,c)\), define the binary quadratic and decimic
\[
q_a(u,v)=a(u^2-v^2)+bi(u^2+v^2)+2cuv,
\qquad z_a=q_a^5.
\]
The six \(z_a\) are linearly independent in \(\operatorname{Sym}^{10}\).
Their span is the fibre-odd six-axis representation
\[
W^-=\mathbf3\oplus\mathbf3'.
\]
Indeed, the Cartan null-cone map used in \(q_a\) intertwines the \(SO_3\)
action on axes with the binary-form action on
\(\operatorname{Sym}^{10}\).  Hence the map from the signed-axis module to
the six decimics is \(A_5\)-equivariant; the exact rank-six calculation makes
it an isomorphism rather than an abstract character match.

The product
\[
F_{\rm ax}=\prod_a q_a
\]
is a Klein invariant dodecic for this icosahedral marking.  Its only nonzero
coefficients, indexed by the exponent of \(v\), are
\[
\begin{array}{c|rrrrrrr}
j&0&2&4&6&8&10&12\\ \hline
[u^{12-j}v^j]F_{\rm ax}
&-3-4t&22+44t&99+132t&-44-88t&
99+132t&22+44t&-3-4t.
\end{array}
\]

Let
\[
\Delta=(\,\cdot\,,F_{\rm ax})_3,\qquad T_{10}=\Delta^\dagger\Delta,
\]
where the adjoint is the exact Fischer adjoint.  In the ordered basis
\((z_a)\), direct transvectant calculation gives
\[
\boxed{
T_{10}
=211625906798592000(11+18t)(\sqrt5\,I-C),
}
\]
where
\[
C=
\begin{pmatrix}
0&1&1&1&-1&-1\\
1&0&-1&-1&-1&-1\\
1&-1&0&1&1&-1\\
1&-1&1&0&-1&1\\
-1&-1&1&-1&0&-1\\
-1&-1&-1&1&-1&0
\end{pmatrix},
\qquad C^2=5I.
\]
Here
\[
11+18t=\sqrt5\,t^6,\qquad
N_{\mathbf Q(t)/\mathbf Q}(11+18t)=-5.
\]
Thus even the apparently irregular scalar is a rational
Fischer/transvectant factor times the sixth power of the fundamental golden
unit and the discriminant generator.

This is exactly the golden Gram conference matrix already compared with
Paper I's continuation operator in C690.  No permutation, switching search,
or floating-point recognition is used here: the natural oriented-axis
marking gives the identity directly.

Consequently
\[
P_+=\frac12\left(I+\frac C{\sqrt5}\right),\qquad
P_-=\frac12\left(I-\frac C{\sqrt5}\right)
\]
are the two McKay projectors, \(T_{10}P_+=0\), and \(T_{10}\) is nonzero
scalar multiplication on \(P_-W^-\).  Conversely the return reconstructs
the integral golden operator:
\[
\boxed{\quad C=\frac{T_{10}-\alpha I}{\beta}\quad}
\]
for its exact diagonal and off-diagonal coefficients
\[
\alpha=5290647669964800000+8465036271943680000t,
\]
\[
\beta=-2327884974784512000-3809266322374656000t.
\]
The nonzero \(\mathbf3'\)-eigenvalue divided by the
\(\mathbf5\)-eigenvalue is \(143/108\).  An independent replay obtains the
same ratio from the earlier rational Klein marking, where
\(\operatorname{Sym}^{10}=\mathbf3\oplus\mathbf5\oplus\mathbf3'\) and
\(\operatorname{Sym}^{16}\) contains no \(\mathbf3\).  The missing target
summand therefore explains the kernel representation-theoretically.

Combining this with C691 gives the direct chain
\[
\text{Klein affine-}E_8\text{ return}
\longrightarrow C
\longrightarrow
c_{ijk}=C_{ij}C_{jk}C_{ki}
\longrightarrow
\text{Clebsch orientation cubic}.
\]

## Golden conjugation

The nontrivial golden automorphism sends
\[
t\longmapsto1-t,\qquad \sqrt5\longmapsto-\sqrt5.
\]
Applying it to the marked Klein form and return exchanges the two kernels:
the original return kills the \(C=+\sqrt5\) summand, while its conjugate
kills the \(C=-\sqrt5\) summand.  Thus the two local returns recover both
halves of the rational signed-axis representation and their common
\(\mathbf Q(\sqrt5)\) commutant.

This identifies the missing operation from the earlier local-return result.
The three returns within one fixed Klein realization control McKay
multiplicity spaces.  Golden conjugation relates the two inequivalent
three-dimensional representation factors.  They are complementary pieces
of the commutant, not additional powers of the same return.

## The graded-lift boundary

A tempting stronger claim would descend
\(M_{\mathbf3}\oplus M_{\mathbf3'}\) inside one fixed natural-\(\mathbf2\)
McKay tower.  That claim is false as a degree-preserving statement.  The
Kostant generator degrees are
\[
\deg M_{\mathbf3}^{(\mathbf2)}
=\{2,10,12,18,20,28\},
\]
\[
\deg M_{\mathbf3'}^{(\mathbf2)}
=\{6,10,14,16,20,24\}.
\]
They already have different graded dimensions in degree \(2\).  Therefore
an operator with eigenvalues \(+\sqrt5\) and \(-\sqrt5\) cannot descend
degree by degree over \(\mathbf Q\) inside that single tower.  The
degree-ten bridge exists precisely because degree \(10\) is the first
balanced slice containing one copy of each summand.

The correct categorical closure pairs the two Galois-conjugate McKay
towers, whose natural binary representations are \(\mathbf2\) and
\(\mathbf2'\).  Golden conjugation acts on the nodes by
\[
\mathbf2\leftrightarrow\mathbf2',\qquad
\mathbf3\leftrightarrow\mathbf3',\qquad
\mathbf4_s\leftrightarrow\mathbf4,
\]
and fixes \(\mathbf1,\mathbf5,\mathbf6\).  The McKay recurrence then gives
\[
\deg M_{\mathbf3}^{(\mathbf2)}
=\deg M_{\mathbf3'}^{(\mathbf2')},
\qquad
\deg M_{\mathbf3'}^{(\mathbf2)}
=\deg M_{\mathbf3}^{(\mathbf2')}.
\]
The certificate checks the conjugate recurrences through degree \(180\);
the equality itself follows for all degrees from conjugating the recurrence.

More explicitly, let \(N=M_{\mathbf3}^{(\mathbf2)}\) and let
\(\sigma N=M_{\mathbf3'}^{(\mathbf2')}\).  On
\(N\oplus\sigma N\), the semilinear involution exchanges the two factors.
The operator
\[
b(x,y)=(\sqrt5\,x,-\sqrt5\,y)
\]
commutes with that involution and satisfies \(b^2=5\).  It therefore
descends to the rational paired module.  In its first balanced degree, the
six-axis calculation identifies this descended \(b\) with the integral
matrix \(C\).

Hence the full statement is:

> **Golden/\(E_8\) descent theorem.** The Clebsch golden algebra is the
> rational descent algebra of the paired natural-\(\mathbf2\) and
> natural-\(\mathbf2'\) affine-\(E_8\) McKay towers.  Its first internal
> appearance in either tower is the balanced degree-ten harmonic slice,
> where the Klein return is exactly an affine generator of the integral
> conference operator.

This also explains why the affine-\(E_8\) diagram itself supplies no
visible golden symmetry: the exchange is Galois conjugation between the two
McKay realizations, not a diagram automorphism of one fixed realization.

## Mystery ledger

- **Why does the degree-ten return land in the golden conference algebra?**
  Settled.  The Cartan axis-decimic map is an explicit equivariant
  identification of the same multiplicity-free
  \(\mathbf3\oplus\mathbf3'\) module.  Schur's lemma forces every return to
  be \(\alpha I+\beta C\), and the exact calculation fixes the normalization.
- **Why is one three-dimensional summand killed?** Settled.  The return maps
  degree \(10\) to degree \(16\), whose McKay decomposition lacks
  \(\mathbf3\); equivariance forces that kernel.
- **Is the large golden scalar arbitrary?** Settled up to the rational
  differential normalization.  Its nonrational factor is
  \(11+18t=\sqrt5t^6\), of norm \(-5\).  The remaining rational integer is
  the raw third-transvectant/Fischer scale.
- **Can the conference operator lift inside one fixed affine-\(E_8\)
  tower?** Settled negatively.  The unequal Kostant degrees give an exact
  degree-two obstruction.
- **What replaces that failed lift?** Settled structurally.  Pair the
  Galois-conjugate natural-\(\mathbf2\) and natural-\(\mathbf2'\) towers;
  the semilinear two-factor construction descends \(b^2=5\), and degree
  \(10\) identifies \(b\) with \(C\).
- **Is there an explicit all-degree Weyl presentation of the descended
  bi-McKay operator, rather than the formal semilinear construction?**
  Open.  The present certificate proves the recurrence-level and
  degree-ten operator statements but does not print a finite all-degree
  matrix coupling the two conjugate Weyl packages.  That is the exact next
  gate if a paper needs an operator presentation rather than the descent
  theorem.
- **Are the two local returns themselves the canonical spherical or
  preprojective affine-\(E_8\) corner generators?** Open and logically
  separate.  C682 proves their full-block generation and the unique
  \((\mathbf3,22)\) failure, but a categorical identification with a
  standard preprojective corner remains a successor problem.

## Replay

From `/home/tavis/src/othello`, run

```bash
python notes/2026-07-30-c682-golden-e8-descent.py --write
python notes/2026-07-30-c682-golden-e8-descent-replay.py
```

The recorded run used Python 3.13.12.  The primary script uses only the
Python standard library and has no external data input: the six frozen axes,
golden-field presentation, McKay graph, and all checked bounds are explicit
in the script.  It rebuilds the
golden field arithmetic, six harmonic decimics, axis Klein form,
third-transvectant matrix, Fischer adjoint, restricted return, conference
identity, spectral projectors, Galois kernel exchange, and both McKay
recurrences exactly.

The replay also uses the older rational Klein form as a different marking
and independently reconstructs the degree-ten \(\mathbf5\) and
\(\mathbf3'\) eigenvalues.  Their ratio \(143/108\) agrees with the
golden-axis computation.  This cross-check does not independently duplicate
every entry of the \(11\times11\) golden-field transvectant matrix; that
matrix is trusted to the primary exact-arithmetic implementation, while its
conference square, projector identities, selection rule, spectral ratio,
and McKay recurrences are checked separately.

`2026-07-30-c682-golden-e8-descent.sha256` records the SHA-256 hash and byte
count of the report, primary checker, replay, and canonical JSON certificate.
