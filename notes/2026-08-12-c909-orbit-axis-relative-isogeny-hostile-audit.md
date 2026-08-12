# C909 — hostile audit of the relative orbit-axis/norm theorem

Date: 2026-08-12  
Status: urgent bounded audit; no manuscript, PDF, mirror, Lean, or commit
change

## Preliminary verdict

**MINOR for the abstract norm-image mechanism; MAJOR gate for the claimed
relative \(6I-J\) realization until the primitive inclusion is identified.**

The group-algebra norm does construct coherent relative elliptic *images*
under the stated isotypic and constant-rank hypotheses. It also gives
canonical orbit transports and, after choosing five fixed-line axes, an
integral relative isogeny. Those parts are sound modulo the standard
abelian-scheme image theorem.

The load-bearing scalar is not proved by the norm argument. The norm only
determines the rational fixed line and its connected image. To obtain the
exact Gram matrix \(6I-J\), one must identify that image with the elliptic
quotient used by Roulleau and prove that the map from the chosen source
elliptic scheme is the primitive Rosati-dual inclusion, not a nontrivial
isogeny onto the same image. Until that comparison is printed, the actual
relative kernel and its \(2,3\)-graph type are not certified.

## 1. What the norm argument really proves

Let \(A/B\) be the relative intermediate Jacobian with integral polarized
\(A_5\)-action, and let
\[
 n_H=\sum_{h\in H}h
\]
for a \(D_5\)-subgroup \(H\). Since \(H=H^{-1}\), \(n_H\) is Rosati
self-adjoint. On the \(W_5\)-isotypic rational homology,
\[
 n_H=|H|\,P_H=10P_H,
\]
where \(P_H\) is projection to the one-dimensional coefficient fixed line
tensored with the rank-two multiplicity variation. Thus the connected image
\[
 E_H^{\mathrm{norm}}=(\operatorname{im}n_H)^0
\]
has relative dimension one if the full homology is the asserted
\(W_5\)-isotypic piece.

For a homomorphism of abelian schemes with constant generic rank, the
identity component of the image is an abelian subscheme after the usual
flatness/smoothness hypotheses; over the characteristic-zero smooth base it
commutes with base change. This standard input still needs a citation or a
short lemma with the exact hypotheses. It is not the scalar obstruction.

Conjugation gives
\[
 g n_H g^{-1}=n_{gHg^{-1}}.
\]
If \(g'=gh\) with \(h\in H\), then \(h n_H=n_H\), so \(h\) acts as the
identity on the norm image. The transports of the connected norm images are
therefore independent of coset representatives. This part is genuinely
canonical at the subgroup-image level.

Five fixed axes form a rational basis of \(W_5\); the sum of the transported
inclusions from a chosen common source has an invertible rational map on
homology. Once the source elliptic scheme and those inclusions are actually
fixed, the resulting relative map is a fibrewise isogeny and hence has
finite flat kernel. No period choices are needed for this step.

## 2. Exact scalar comparison with Roulleau

The paper's elliptic quotient data are
\[
 q_H:J\to E_H,\qquad i_H:E_H\to J
\]
with \(i_H\) the Rosati dual. Its calculation uses
\[
 q_Hi_H=[5],\qquad q_Hi_{H'}=[-1]\ (H\ne H'),
\]
and hence the Gram matrix \(6I-J\).

On the rational \(W_5\)-piece the Rosati endomorphism
\(N_H=i_Hq_H\) acts as \(5P_H\), whereas the raw norm acts as \(10P_H\).
Consequently
\[
 n_H=2N_H
\]
on that rational isotypic component, so the norm image and the image of
\(i_H\) agree as connected rational subtori. This is enough to identify the
*subvariety* generically, but not enough to identify the source map
\(E_H\to J\) integrally.

If \(i_H\) is a primitive embedding of the elliptic quotient onto its image,
then replacing the norm by \(i_H\) is harmless and the Roulleau matrix is the
actual inclusion Gram. If instead \(i_H=j_H\circ u_H\), where \(j_H\) is the
primitive inclusion of the norm image and \(u_H\) is a nontrivial isogeny,
then the Gram of the maps from the chosen source is conjugated/scaled by the
degrees of the \(u_H\). A uniform multiplication \(m\) would replace the
matrix by \(m^2(6I-J)\); unequal identifications replace it by
\(D(6I-J)D\). The Smith type, kernel order, and graph packet can then change.

Thus “same rational fixed line” and “same connected image” do **not** by
themselves justify the integral equality \(f^*\Theta=6I-J\).

The likely repair is to prove one of the following equivalent-strength
statements over the generic fibre and then extend:

1. the quotient \(q_H\) has connected kernel, so its dual \(i_H\) is an
   embedding and identifies \(E_H\) with the norm image; or
2. the Roulleau source \(E_H\) is explicitly identified with
   \(E_H^{\mathrm{norm}}\) and the identification has degree one; or
3. the primitive inclusion of the norm image has induced polarization degree
   \(5\), while all six transported inclusions have off-diagonal degree
   \(-1\).

A mere isogeny comparison is insufficient.

## 3. Relative globalization gap

The fibrewise Roulleau fibration calculation does not automatically produce
the relative maps \(q_H\) and \(i_H\) over the entire smooth pencil. The
remaining exact steps are:

* construct the relative elliptic quotient or norm-image abelian scheme;
* show the relative Fano curves \(F_H\) define the same quotient, not merely
  fibrewise quotients up to translation/isogeny;
* prove the six maps are compatible under the \(A_5\)-transports after a
  finite etale base change;
* check the generic integral Rosati identities \(q_Hi_H=[5]\) and
  \(q_Hi_{H'}=[-1]\), then extend them as homomorphism identities over the
  normal smooth base.

The last extension is standard once the generic maps exist: homomorphisms of
abelian schemes over a normal curve are determined by the generic fibre. The
first three are not supplied by rational VHS alone. A relative
Albanese/Fano construction or a generic-fibre construction followed by
abelian-scheme extension is required.

## 4. Six-axis consequences after the gate

If the primitive comparison is proved, then the rest of the relative theorem
follows cleanly:
\[
 f:E^5\longrightarrow J,\qquad f^*\Theta=6I_5-J_5.
\]
The Smith type is \((1,6,6,6,6)\), so \(\deg f=6^4\). The kernel has order
\(6^4\), lies in the kernel of the source polarization, and is a maximal
isotropic subgroup of the discriminant group. Over the complex base it is
finite etale, and the established local \(2\)- and \(3\)-graph classification
can then be applied to this **actual** kernel.

Before the primitive comparison, one has only a relative family of elliptic
axis images and an isogeny of unspecified integral Gram. It is not yet
legitimate to assert the exotic \(2\)-packet, scalar \(3\)-packet, or the
signed \(X_0(3)\) modular lift for that norm construction.

## Bottom line

Return **MINOR/conditional GO** for the abstract orbit-norm theorem and
**MAJOR unresolved** for its use as the geometric six-axis certificate. The
earliest exact failure is the inference
\[
\text{norm image / rational fixed line}
\Longrightarrow
\text{Roulleau's primitive inclusion with Gram }6I-J.
\]
Prove the connected-kernel/degree-one comparison and relative globalization;
then the norm route closes the kernel-identity gap. Without it, it produces
only coherent elliptic images and an unspecified integral isogeny.

