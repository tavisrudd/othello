# C709 — Clebsch conference signs in the six-Majorana \(K_6\) model

**Date:** 2026-07-30

**Lane:** `clebsch`

**Status:** complete

## Outcome

The answer is split and sharp.

The conference switching class survives legitimate diagonal Majorana gauge
as a nontrivial \(\mathbf Z/2\)-flux on \(K_6\), and its middle-exterior
operator survives after the orientation of the Majorana frame is transported.
It is not a quadratic refinement of the two-qubit symplectic space and does
not define a spin structure without additional surface/embedding data.

There is also no canonical *constant* free-fermion Hamiltonian obtained by
simply making \(C\) skew: that operation requires an arbitrary total order.
The canonical positive replacement is the five-parameter chiral family
\[
 A_C(x)=[D_x,C],\qquad
 (A_C(x))_{ij}=(x_i-x_j)C_{ij}.
\]
With
\[
 \widehat H_C(x)=\frac{i}{4}
 \sum_{i,j}(A_C(x))_{ij}\gamma_i\gamma_j,
\]
this is a real six-Majorana quadratic Hamiltonian, invariant under
\(x\mapsto x+c\mathbf1\), and
\[
 \{C,A_C(x)\}=0,\qquad
 \operatorname{Pf}A_C(x)=4Z_C(x),\qquad
 \det A_C(x)=16Z_C(x)^2.
\]
Thus the Clebsch/Joubert cubic is exactly the zero-energy wall of a canonical
chiral free-fermion family.  After an orientation of Majorana space is fixed,
the sign of \(Z_C\) is the zero-dimensional class-D ground-state-parity
invariant; it changes only across the cubic gap-closing locus.

## Exact Pauli--Majorana dictionary

Fix Hermitian Majoranas
\[
 \{\gamma_i,\gamma_j\}=2\delta_{ij},\qquad
 M_{ij}=i\gamma_i\gamma_j,\quad M_{ji}=-M_{ij},
\]
and fermion parity
\[
 \Pi=i\gamma_0\gamma_1\gamma_2\gamma_3\gamma_4\gamma_5.
\]
Work on the four-dimensional \(\Pi=+1\) sector.  For
\(v=(x,z)\in\mathbf F_2^4\), use the Hermitian Pauli convention
\[
 P(v)=i^{x\cdot z}X^xZ^z.
\]
The six odd characteristics, in order, are
\[
 (1,1),(1,3),(2,2),(2,3),(3,1),(3,2),
\]
with the two-bit entries interpreted in \(\mathbf F_2^2\).  The duad
\(\{i,j\}\) maps to
\[
 v_{ij}=(b_i+b_j,\ a_i+a_j).
\]
The fully phased dictionary \(M_{ij}=\epsilon_{ij}P(v_{ij})\), for \(i<j\),
is
\[
\begin{array}{c|ccccc}
ij&01&02&03&04&05\\ \hline
v_{ij}&0010&1111&1110&1000&1011\\
\epsilon_{ij}&+&+&+&+&+
\end{array}
\]
\[
\begin{array}{c|cccccccccc}
ij&12&13&14&15&23&24&25&34&35&45\\ \hline
v_{ij}&1101&1100&1010&1001&0001&0111&0100&0110&0101&0011\\
\epsilon_{ij}&-&-&+&-&-&-&+&-&-&+
\end{array}.
\]
The certificate checks all \(120\) ordered identities
\[
 M_{ab}M_{bc}=iM_{ac}
\]
and all fifteen perfect matchings.  For a matching whose ordered edge list
has permutation sign \(\eta\),
\[
 \prod_{\{a,b\}\in M}M_{ab}=-\eta\,\Pi,
\]
and the displayed Pauli phases realize \(\Pi=+1\) in every case.  The
dictionary also verifies that two duads have symplectic pairing one exactly
when their edges share one vertex, matching Majorana anticommutation.

## What survives fermionic gauge

For diagonal Majorana rephasing
\[
 \gamma_i\longmapsto s_i\gamma_i,\qquad s_i\in\{\pm1\},
\]
edge coefficients transform by
\[
 C_{ij}\longmapsto s_is_jC_{ij}.
\]
The kernel is the common sign, so the \(64\) vertex sign choices give only
\(32\) edge gauges.  There are \(2^{15}\) arbitrary edge signings, hence
\[
 2^{15}/2^5=2^{10}
\]
physical diagonal-gauge classes.  Their complete invariants are the cycle
holonomies; it is enough to use the triangle signs
\[
 t_{ijk}=C_{ij}C_{jk}C_{ki}.
\]
The conference class has ten positive and ten negative triangle signs, with
the four-point relations of the Clebsch two-graph.

An arbitrary rephasing of all fifteen bilinears is therefore not a
fermionic gauge transformation.  It preserves the commutation graph but
changes the Clifford multiplication constants.  Quotienting by that larger
edge gauge makes every signing trivial only because it discards the
Majorana algebra.  Under the legitimate vertex gauge, the two-graph flux is
genuine.

For
\[
 K=*\bigwedge\nolimits^3C,
\]
the exact certificate gives
\[
 K^2=125I,\qquad K_{SS}=4t_S.
\]
If a vertex rephasing is treated as a change of Majorana frame and the
orientation/Hodge star is transported with it, \(K\) is conjugated on
\(\bigwedge^3\) and its diagonal two-graph data survive.  If the Hodge star
is artificially held fixed under an orientation-reversing rephasing, \(K\)
acquires the expected factor \(\det D\).  This is the same global sign as
the change of the fermion-parity convention; the projective operator and
its square survive full \(O(6)\) gauge, while the signed Pfaffian survives
an oriented \(SO(6)\) frame.

## No quadratic refinement or intrinsic spin structure

Under the fixed duad--Pauli dictionary, the conference edge sign is a
Boolean function \(c\) on the fifteen nonzero vectors of
\(\mathbf F_2^4\), with \(c(0)=0\).  All quadratic refinements of the
symplectic form are
\[
 q_a(x,z)=x\cdot z+\langle a,(x,z)\rangle,\qquad a\in\mathbf F_2^4.
\]
Exact exhaustion of all sixteen gives Hamming distances
\[
 \underbrace{5,\ldots,5}_{6},
 \qquad
 \underbrace{9,\ldots,9}_{10}
\]
from \(c\).  In particular, none equals \(c\).  This strengthens the
distinction from C706: the conference cochain selects a nonzero equivariant
\(H^1(A_5,\mathbf F_2^4)\) class, but it is not itself a Pauli quadratic
refinement.

The surviving object on \(K_6\) is a flat \(\mathbf Z/2\) edge connection
with nontrivial cycle holonomy.  A spin structure would require a
nondegenerate intersection pairing, normally supplied by an oriented
surface embedding and a Kasteleyn convention.  The abstract duad graph and
conference two-graph supply neither.  Therefore no intrinsic spin structure
survives; one could only ask a new, embedding-dependent question.

## The canonical free-fermion family

The symmetric matrix \(C\) cannot itself be the coefficient matrix of a
Majorana quadratic Hamiltonian.  Choosing a total order and setting
\(A_{ij}=C_{ij}\) above the diagonal is not intrinsic.  Across all \(720\)
orders, the characteristic polynomial
\[
 \lambda^6+15\lambda^4+Q_4\lambda^2+\operatorname{Pf}(A)^2
\]
falls into three classes:
\[
\begin{array}{c|c|c|c}
\text{orders}&Q_4&\operatorname{Pf}(A)^2&
 \{\text{squared singular values}\}\\ \hline
120&63&81&\{3,3,9\}\\
240&63&49&\{1,7,7\}\\
360&47&1&\text{roots of }y^3-15y^2+47y-1.
\end{array}
\]
The spectrum therefore depends on the arbitrary order.

By contrast,
\[
 A_C(x)=[D_x,C]
\]
is alternating without any order choice.  It is gauge covariant because
\(D_x\) commutes with every diagonal vertex gauge.  Its exact characteristic
polynomial is
\[
 \chi_{A_C(x)}(\lambda)
 =\lambda^6+Q_2(x)\lambda^4+Q_4(x)\lambda^2+16Z_C(x)^2,
\]
where
\[
 Q_2(x)=\sum_{i<j}(x_i-x_j)^2,\qquad
 Q_4(x)=\sum_{|S|=4}\operatorname{Pf}(A_C(x)_S)^2.
\]
The \(120\)-element signed two-graph stabilizer preserves this spectrum;
its \(A_5\) subgroup preserves \(Z_C\), and the other coset reverses its
sign.

The golden compatibility is structural:
\[
\begin{aligned}
 CA_C(x)+A_C(x)C
 &=C(D_xC-CD_x)+(D_xC-CD_x)C\\
 &=CD_xC-5D_x+5D_x-CD_xC=0.
\end{aligned}
\]
Writing \(J=C/\sqrt5\), the golden eigenspaces are the two chiral
three-spaces of \(J\).  In an oriented orthonormal golden basis,
\[
 A_C(x)=
 \begin{pmatrix}
 0&L_x\\
 -L_x^{\mathsf T}&0
 \end{pmatrix},
\qquad
\operatorname{Pf}A_C(x)=-\det L_x
\]
up to the one fixed block-orientation convention.  Thus the one-particle
energies are the singular values of the cross-golden block, and its
determinant is \(\pm4Z_C\).  This is the fermionic form of C704's
linear--quadratic cross-golden factorization.

## `ej` + `tt` closeout

The cheap extra consequence is physical rather than another combinatorial
labeling: the Joubert cubic is a fermion-parity wall.  For an oriented
Majorana frame and a gapped real skew matrix, the ground-state parity is
the sign of its Pfaffian.  Hence the two signs of \(Z_C\) label the parity
chambers of the commutator family, and \(Z_C=0\) is precisely its
zero-mode locus.

The naturality audit also explains why the commutator is forced.  An
edge-local alternating coupling linear in \(x\), translation-invariant in
\(x\), and using \(C_{ij}\) has the form
\[
 \alpha(x_i-x_j)C_{ij}.
\]
Thus, within the exact local ansatz suggested by the six-axis model,
\([D_x,C]\) is unique up to scale.

The negative result is equally structural.  The conference signing is a
cycle-flux character, not a quadratic function on Pauli space; converting
it to a spin structure needs new embedding data.  The positive Hamiltonian
does not repair that missing datum—it uses the diagonal parameter \(x\) to
create a canonical alternating matrix instead.

## Reproducibility

From `/home/tavis/src/othello`:

```sh
python3 notes/2026-07-30-c709-majorana-k6-lift.py --check
python3 notes/2026-07-30-c709-majorana-k6-lift-replay.py
```

The generator reads the frozen C690 conference matrix, constructs the
phase-complete Pauli--Majorana dictionary, verifies the Clifford products,
enumerates all \(16\) quadratic refinements and all \(720\) total orders,
constructs \(K=*\Lambda^3C\), and checks the symbolic Pfaffian identity.
The replay hard-codes only the conference and odd-characteristic
conventions and independently checks the commutation dictionary, all
quadratic refinements, and \(15{,}625\) direct integer evaluations of the
Pfaffian and golden anticommutator identities.  It does not assert a
surface-dependent Kasteleyn classification.

Hashes and byte counts are recorded in
`notes/2026-07-30-c709-majorana-k6-lift.sha256`.

## Mystery ledger

- **Settled positively:** the conference two-graph survives diagonal
  Majorana gauge as one of \(2^{10}\) cycle-flux classes.
- **Settled positively:** \(K=*\Lambda^3C\) survives with its signed data
  after transporting the Majorana orientation, and projectively under full
  orthogonal gauge.
- **Settled negatively:** the conference sign function is none of the
  sixteen Pauli quadratic refinements.
- **Settled negatively:** no intrinsic spin structure exists without an
  added surface embedding and intersection pairing.
- **Settled negatively:** total-order antisymmetrization gives three
  different spectra and hence no canonical constant Hamiltonian.
- **Settled positively:** the canonical replacement
  \(A_C(x)=[D_x,C]\) exchanges the two golden eigenspaces and has
  Pfaffian \(4Z_C\).
- **Settled by the `ej`+`tt` pass:** the Clebsch/Joubert cubic is exactly
  the gap-closing and fermion-parity wall of that family, and the family is
  unique up to scale in the edge-local linear ansatz.
- **No genuine C709 mystery remains.**  A Kasteleyn/spin question after
  choosing a torus embedding would be a different, embedding-owned task,
  not unfinished C709 work.
