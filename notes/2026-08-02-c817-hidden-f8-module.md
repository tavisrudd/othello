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

- `notes/2026-08-02-c817-hidden-f8-module.py` — 7421 bytes,
  SHA-256 `aae8367bc3f0cdf9837fa3f533f6ae7dd699603234e01f0543dbfc05f401a09c`;
- `notes/2026-08-02-c817-hidden-f8-module.json` — 1035 bytes,
  SHA-256 `23b29f270520983c7ba877615756e22923f5e1a87ad82492bf3946449f1489ee`.

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
modular Bose--Mesner algebra on the code.  This is the cleanest structural
origin available from the current identities.

`aa` was not triggered because the primary route passed its falsifier and
success gate.

## Mystery ledger and novelty gate

- **Settled:** the possible \((t+1)\)-primary component is absent; exact
  evidence gives fixed dimension zero.
- **Settled by `ej`:** the complementary \(42\)-space is exactly the zero
  primary part of \(B\), and \(e_K\) cuts out the code canonically.
- **Settled by `ej2`:** the whole modular scheme-algebra image, not merely
  \(\mathbf F_2[B]\), is \(\mathbf F_8\).
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
