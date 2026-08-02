# C817 hidden-\(\mathbf F_8\) module diagnostic

**Lane:** `clebsch`
**Scope:** C817 subitem 1 only; mathematics freeze, with Paper IV read-only

## Verdict

The hidden-field proposal is positive.  If

\[
 V=\mathbf F_2^{78},\qquad K=\ker A_0,\qquad B=A_9,
\]

then

\[
 \ker A_0\cap\ker(B+I)=0
\]

and the modular Bose--Mesner action on \(K\) has image exactly
\(\mathbf F_8\).  More precisely, for a root \(\alpha\) of
\(t^3+t^2+1\),

\[
 K\cong \mathbf F_8^{12},\qquad
 (A_9,A_{10},A_{12})=(\alpha,\alpha^2,\alpha^4)
\]

as scalar operators.  This is an operator-field structure on the binary
code, not a coordinatewise assertion that the code has length \(26\) over
\(\mathbf F_8\).

The result passes the subitem success gate: it explains the dimension
\(36=3\cdot12\), the squaring cycle, all three dihedral Gram operators, their
rank \(36\), and the consequent orbit-spanning theorem.

## Canonical module theorem

Let \(\mathcal A_2\) be the mod-two Bose--Mesner algebra with adjacency basis
\(I,A_0,A_1,A_3,A_9,A_{10},A_{12}\).  Its representation on \(K\) induces

\[
 \mathcal A_2\big/
 \left\langle A_0,A_1,A_3,I+A_9+A_{10}+A_{12}\right\rangle
 \;\cong\;\mathbf F_2[t]/(t^3+t^2+1)\cong\mathbf F_8,
\]

where \(t\) maps to \(A_9|_K\).  Thus the field is intrinsic to the labeled
elliptic relation scheme.  If the triple
\(\{A_9,A_{10},A_{12}\}\) is retained without a preferred member, the
identification with a named \(\alpha\) is canonical only up to Frobenius.

There is also a canonical ambient primary splitting.  Put

\[
 e_K=I+A_0^2=B+B^2+B^4.
\]

Then \(e_K^2=e_K\), \(\operatorname{im}e_K=K\),
\(\ker e_K=\ker B\), and

\[
 V=\ker B\oplus K,
 \qquad \dim_{\mathbf F_2}\ker B=42,
 \qquad B^7=e_K.
\]

Consequently the complete \(\mathbf F_2[t]\)-primary decomposition for
\(B\) is

\[
 V\cong \bigl(\mathbf F_2[t]/(t)\bigr)^{42}
 \oplus
 \bigl(\mathbf F_2[t]/(t^3+t^2+1)\bigr)^{12}.
\]

The requested decomposition on \(K\) is its second summand; there is no
\((t+1)\)-primary component.

## Human proof packet

The already established parity identities give

\[
 A_0B=0,quad B^2=A_{10},\quad B^4=A_{12},\quad
 A_0^2=I+B+B^2+B^4.
\]

The exact finite leaf gives
\(\operatorname{rank}A_0=42\), \(\operatorname{rank}B=36\), and
\(\operatorname{rank}(B+I)=78\).  Hence \(\dim K=36\),
\(\operatorname{im}B=K\), and \(B+I\) is invertible.  Since

\[
 1+t+t^2+t^4=(t+1)(t^3+t^2+1),
\]

the quartic identity restricted to \(K\) gives
\(B^3+B^2+I=0\).  The cubic has no root in \(\mathbf F_2\), so it is
irreducible.  The resulting unital map from the field
\(\mathbf F_2[t]/(t^3+t^2+1)\) into \(\operatorname{End}_{\mathbf F_2}(K)\)
is injective, and \(K\) has field dimension \(36/3=12\).

For the ambient projector, write \(q(B)=I+B^2+B^3\).  The factorization says
\((I+B)q(B)=A_0^2\).  Since \(A_0^2B=0\), multiplication by \(I+B\) fixes
\(A_0^2\); invertibility of \(I+B\) therefore gives \(q(B)=A_0^2\).
It follows that \(e_K=I+A_0^2\) is the complementary projector, and
\(B^7=e_K\) follows from the cubic relation on \(K\) and the zero action on
\(\ker B\).

The remaining Bose--Mesner assertion uses only the mod-two intersection
table: \(A_1e_K=A_3e_K=0\), while
\(A_9e_K=B\), \(A_{10}e_K=B^2\), and \(A_{12}e_K=B^4\).
The seven adjacency matrices are linearly independent by their disjoint
supports, while \(1,B,B^2\) are linearly independent on \(K\).  This proves
the displayed quotient and shows that its image is exactly, rather than only
contains, \(\mathbf F_8\).

## Gram and spanning reinterpretation

The octahedral orbit Gram is \(A_9\).  In their existing order, the three
dihedral orbit Grams are

\[
 A_9,A_{12},A_{10}=\alpha,\alpha^4,\alpha^2,
\]

the full Frobenius orbit of one nonzero scalar.  Each is therefore an
automorphism of the \(12\)-dimensional \(\mathbf F_8\)-space \(K\), and its
image in \(V\) is exactly \(K\).  If \(N\) is any corresponding orbit-support
matrix, then
\(\operatorname{im}(N^{\mathsf T}N)=K\subseteq\operatorname{row}(N)\).
All rows of \(N\) already lie in \(K\), so \(\operatorname{row}(N)=K\).
Thus the field action supplies the conceptual rank and spanning step after
the orbit Gram has been identified.

It does not yet explain why the three dihedral families receive the three
conjugates in that particular order, or why the octahedral family duplicates
\(A_9\); those identifications still use the existing representative pair
count.

## Second-order trace, norm, and symplectic upgrade

Let \(G_9,G_{10},G_{12}\) denote the three dihedral Gram operators.  Since
they are the Frobenius packet \(\alpha,\alpha^2,\alpha^4\), the elementary
symmetric functions of the roots of \(t^3+t^2+1\) give the exact global
matrix identities

\[
 G_9+G_{10}+G_{12}=e_K,
\]
\[
 G_9G_{10}+G_9G_{12}+G_{10}G_{12}=0,
 \qquad
 G_9G_{10}G_{12}=e_K.
\]

Thus the packet has field trace and norm equal to the identity on \(K\).
If \(N_9,N_{10},N_{12}\) are the corresponding three orbit-support matrices,
then every \(x\in K\) has the characteristic-two reconstruction formula

\[
 x=N_9^{\mathsf T}N_9x+N_{10}^{\mathsf T}N_{10}x
   +N_{12}^{\mathsf T}N_{12}x.
\]

This is an exact three-frame resolution of the identity, not a positivity or
Euclidean tight-frame assertion.

There is a further canonical structure.  The ordinary binary dot product
\(\beta\) restricts nondegenerately to \(K\): the symmetric idempotent \(e_K\)
is its orthogonal projector.  The restriction is alternating, because
\(A_0\mathbf1=\mathbf1\) implies every vector in \(\ker A_0\) has even
weight.  Every element of the \(\mathbf F_8\)-operator field is self-adjoint
for \(\beta\).

These facts determine a unique \(\mathbf F_8\)-valued form \(h\) by

\[
 \operatorname{Tr}_{\mathbf F_8/\mathbf F_2}(a h(x,y))=\beta(ax,y)
 \qquad(a\in\mathbf F_8).
\]

The nondegenerate field-trace pairing makes \(h\) unique.  Self-adjointness
makes it \(\mathbf F_8\)-bilinear and symmetric.  For any \(a=b^2\) in the
perfect field \(\mathbf F_8\),

\[
 \beta(ax,x)=\beta(bx,bx)=0,
\]

so trace nondegeneracy gives \(h(x,x)=0\).  Therefore \(h\) is a canonical
nondegenerate alternating form and

\[
 (K,h)\quad\text{is a 12-dimensional symplectic space over }\mathbf F_8.
\]

The labeled \(\PGL(2,13)\)-action commutes with the scheme algebra and
preserves the binary dot product, hence its action on \(K\) lands canonically
in \(\operatorname{Sp}(12,8)\).

Finally, the seven scheme relations are the seven orbitals of \(G\) on
ordered pairs, so
\(\operatorname{End}_{\mathbf F_2G}(V)=\mathcal A_2\).  Since \(e_K\) is a
\(G\)-equivariant direct-summand projector,

\[
 \operatorname{End}_{\mathbf F_2G}(K)
 =e_K\mathcal A_2e_K\cong\mathbf F_8.
\]

Thus the hidden field is the complete Schur endomorphism field of the binary
code module.  In particular, \(K\) is indecomposable as an
\(\mathbf F_2G\)-module.  This does not by itself assert modular irreducibility.

## Exact evidence and trust boundary

Replay from `rust/`:

```sh
python3 ../notes/2026-08-02-c817-hidden-f8-module.py \
  --check ../notes/2026-08-02-c817-hidden-f8-module.json
```

The deterministic script constructs all \(78\) internal points of the
standard conic over \(\mathbf F_{13}\), constructs the six relation matrices
from \(\rho\), and checks every displayed matrix identity over \(\mathbf F_2\).
It computes ranks twice, by bitset echelon reduction and by an independently
implemented dense RREF.  The exact domain is the complete set of \(78^2\)
ordered point pairs and all rows of every resulting \(78\)-square matrix;
there is no random sampling or early stop.

The trusted boundary is ordinary Python integer arithmetic and the two local
elimination implementations.  This is an independent algorithmic replay of
the ranks inside one source file, not an independent reconstruction of the
elliptic scheme from a second coordinate model.  The existing Paper-IV
verification is a separate construction that already checks the relation
matrices, parity identities, and orbit Grams.  It was independently replayed
green in the same checkout with

```sh
python3 papers/q13-passant-code/verification/check_q13_tangent_code.py
```

and returned the exact Paper-IV summary
`omega = 5, d = 12, 364 minimum words, 78 rows recovered,
Aut = PGL(2,13)`.

Evidence files:

- `notes/2026-08-02-c817-hidden-f8-module.py` — 8186 bytes,
  SHA-256 `03fb4fe19482aa20e2e537e7769599adefd6a8f74a18a5a88028010b5681dca0`;
- `notes/2026-08-02-c817-hidden-f8-module.json` — 1336 bytes,
  SHA-256 `c152377219b2d93968321a2d7d53a854073e6a1c202714e5c880a2227109dffc`.

The adjacent checksum manifest records the same frozen hashes.

## Required closeout passes

### `ej`

The free upgrade is the ambient idempotent \(e_K=I+A_0^2\), which upgrades a
fixed-space calculation to the complete \(42+36\) primary decomposition of
\(B\).  It also identifies the code as a direct summand cut out inside the
modular Bose--Mesner algebra rather than merely a kernel of the incidence
operator.

### `tt`

The main overclaim risk is the word “natural.”  What is canonical is the
field quotient of the labeled scheme algebra and its action on \(K\).  A
chosen isomorphism with a named \(\mathbf F_8\), or a chosen primitive element,
retains the expected Frobenius ambiguity.  The result gives no coordinatewise
\(\mathbf F_8\)-linear code and no new weight metric.  Separating these three
levels makes the theorem both stronger and safer.

### `ej2`

The second-order gain is that the full scheme-algebra kernel is explicit:
three relation operators vanish individually and the fourth kernel direction
is the quartic sum.  Hence the \(\mathbf F_8\) is not an accidental subfield
generated by one rank-36 matrix; it is the entire semisimple image of the
modular Bose--Mesner algebra on the code.  Pushing this once more gives the
trace/norm three-Gram resolution, the canonical \(\mathbf F_8\)-symplectic
form, and the exact Schur endomorphism field
\(\operatorname{End}_{\mathbf F_2G}(K)=\mathbf F_8\).  These consequences
show that the field controls both the orbit-Gram packet and the intrinsic
module geometry; it is not only a convenient scalar notation.

`aa` was not triggered because the primary route passed its falsifier and
success gate.

## Mystery ledger and novelty gate

- **Settled:** the possible \((t+1)\)-primary component is absent; exact
  evidence gives fixed dimension zero.
- **Settled by `ej`:** the complementary \(42\)-space is exactly the zero
  primary part of \(B\), and \(e_K\) cuts out the code canonically.
- **Settled by `ej2`:** the whole modular scheme-algebra image, not merely
  \(\mathbf F_2[B]\), is \(\mathbf F_8\); its three Frobenius Grams resolve
  the identity, and it is the complete Schur field of a canonical
  \(12\)-dimensional symplectic \(\mathbf F_8\)-module.
- **New exact boundary:** the Schur-field computation proves
  indecomposability but not modular irreducibility.  Determining the latter
  would require a separate submodule or Brauer-character argument and is not
  needed for the hidden-field theorem.
- **Open evidence gap:** a representation-theoretic derivation of the quotient
  from the modular \(\PGL(2,13)\)-permutation module, avoiding the finite
  intersection-table leaf.  This is optional strengthening, not a gap in the
  theorem above.
- **Open owning successor:** explain equivariantly why the three dihedral
  orbit Grams occupy the three Frobenius conjugates and why the octahedral Gram
  repeats one of them.  C817 subitem 3 is the natural owner.
- **Novelty:** no publication novelty claim is made in this math freeze.  A
  targeted original-source and forward-citation audit is required before any
  later manuscript positioning.

Preliminary integration value is high mathematical gain, short proof, one
already-owned finite intersection-table leaf, and low dilution risk.  No
Paper-IV source or release surface was changed.
