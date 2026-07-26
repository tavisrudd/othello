# Clebsch top-three execution report

## Exact \(W_6\) identification, an atomistic falsification pilot, and the arithmetic Hitchin cover

**Date:** 25 July 2026  
**Status:** two exact theorem packages, one controlled pilot, one precisely isolated missing input

---

## Executive conclusions

### 1. The Clebsch cubic is exactly a restricted \(W_6\) observable

Let \(u_e\), \(e=1,\ldots,10\), be the ten unoriented axes through opposite
faces of an icosahedron, and put

\[
Z_e(\omega)=P_6(u_e\cdot\omega).
\]

The zonal map

\[
L:\mathbf R^{10}\longrightarrow\mathcal H_6,
\qquad
L(a)=\sum_ea_eZ_e
\]

is injective. Under \(A_5\),

\[
\mathbf R^{10}=1\oplus4\oplus5,
\qquad
\mathcal H_6=1\oplus3\oplus4\oplus5.
\]

On the four-dimensional summand

\[
a_{ij}=y_i+y_j,\qquad \sum_{i=1}^5y_i=0,
\]

the spherical Gaunt cubic, equivalently the Steinhardt \(W_6\) contraction,
is exactly

\[
\boxed{
\frac1{4\pi}\int_{S^2}L(a(y))^3\,d\omega
=-\frac{784000}{1247103}\sigma_3(y),
}
\qquad
\sigma_3(y)=\frac13\sum_i y_i^3.
\]

The normalization constant is inessential but exact. This proves a literal
identity of invariant cubics, not an analogy.

The final comparison with the *banked* signed tensor cannot be executed from
the available files: its ten coordinates or action matrices are absent. A
complete exact comparison program is supplied. Once the \(10^3\) tensor table
is provided, the test is one contraction and either returns the scalar or an
explicit mismatching coefficient.

### 2. The first atomistic pilot is negative

A reproducible three-seed, 500-particle, equimolar Wahnström-type binary
Lennard-Jones quench was run. Each local 12-neighbour cage was converted into:

- 20 triangular hull faces;
- ten approximately opposite face pairs;
- the associated Petersen graph;
- its exact four-projector;
- an area-based geometric cubic;
- a three-site chemical-product cubic.

The forward target was cage-relative mobility. Baseline features were species,
\(Q_6\), ordinary \(W_6\), and radial disorder. The chronological held-out
comparison found no stable improvement from the Clebsch features.

At the principal lag, held-out mobility AUC changed by

\[
-0.0002,\qquad-0.0170,\qquad-0.0185
\]

in the three seeds. The result is a useful null, not evidence of a
commercially predictive descriptor.

The run also exposed a rigorous representation-theoretic obstruction:
additive vertex weights and rank-two local stress cannot enter the Clebsch
four-channel. Any valid physical observable must contain irreducible
face-level three-body information.

### 3. The rational arithmetic cover is proved

With Hitchin's normalization \(J_0\), the generic incidence cover of harmonic
cubics by compatible icosahedral axis sets is

\[
\boxed{w^2=5J_0}
\]

over \(\mathbf Q\), up to rescaling \(w\) by a rational unit.

For every odd finite field on which an integral normalization of \(J_0\) is
defined, the explicit cover has fibre count

\[
\boxed{
\#X_f(\mathbf F_q)=1+\chi_q(5J_0(f))
}
\]

whenever \(J_0(f)\ne0\).

The identification with the *geometric incidence model* holds outside a finite
set of primes by spreading out. Determining the minimal bad set requires
integral equations for the Mukai-Umemura incidence model; those equations are
not present in the available sources. Claims that the geometric
identification holds at every \(p\ne2,5\) would therefore be premature.

---

## Part I. Exact Clebsch-\(W_6\) theorem

### 1. The ten-axis module

Use the twenty dodecahedral vertices

\[
(\pm1,\pm1,\pm1),
\quad
(0,\pm\phi^{-1},\pm\phi),
\quad
(\pm\phi^{-1},\pm\phi,0),
\quad
(\pm\phi,0,\pm\phi^{-1}),
\]

where

\[
\phi^2-\phi-1=0.
\]

After identifying antipodal points, these give ten unit axes \(u_e\). Their
degree-six zonal harmonics are

\[
Z_e(\omega)=P_6(u_e\cdot\omega),
\]

where

\[
P_6(s)=\frac{231s^6-315s^4+105s^2-5}{16}.
\]

The addition theorem gives

\[
\frac1{4\pi}\int_{S^2}Z_eZ_f\,d\omega
=\frac1{13}P_6(u_e\cdot u_f).
\]

Thus injectivity of \(L(a)=\sum_ea_eZ_e\) is equivalent to nonsingularity of

\[
K_{ef}=P_6(u_e\cdot u_f).
\]

### 2. Petersen calculation

The ten axes carry a Petersen graph \(A\). Direct exact evaluation gives

\[
K=\frac{196I+47J-112A}{243}.
\]

The Petersen spectrum is

\[
3^{(1)},\qquad1^{(5)},\qquad(-2)^{(4)}.
\]

It follows that

\[
\operatorname{Spec}(K)=
\left(\frac{110}{81}\right)^{(1)}
\cup
\left(\frac{28}{81}\right)^{(5)}
\cup
\left(\frac{140}{81}\right)^{(4)}.
\]

All eigenvalues are positive, proving:

> **Theorem 2.1.**  
> The ten zonal \(\ell=6\) harmonics \(Z_e\) are linearly independent. Their
> span is the \(1\oplus4\oplus5\) submodule of
> \(\mathcal H_6\downarrow_{A_5}=1\oplus3\oplus4\oplus5\).

### 3. Identification of the four-space

Label the Petersen vertices by two-subsets \(\{i,j\}\) of a five-set, with
disjoint pairs adjacent. For

\[
y_1+\cdots+y_5=0,
\qquad
a_{ij}=y_i+y_j,
\]

one has

\[
(Aa)_{ij}
=\sum_{\{k,l\}\cap\{i,j\}=\varnothing}(y_k+y_l)
=-2(y_i+y_j).
\]

Hence the Clebsch module is exactly the \(-2\) Petersen eigenspace. Its
projector is

\[
\boxed{
P_4=\frac{(A-3I)(A-I)}{15}.
}
\]

### 4. Gaunt cubic

Define

\[
G(y)=
\frac1{4\pi}\int_{S^2}
\left(
\sum_{i<j}(y_i+y_j)P_6(u_{ij}\cdot\omega)
\right)^3d\omega.
\]

The integral is an \(A_5\)-invariant cubic on the irreducible four-module.
That invariant space is one-dimensional, generated by

\[
\sigma_3(y)=e_3(y)=\frac13\sum_i y_i^3.
\]

Therefore \(G=c\sigma_3\) or \(G=0\). To determine \(c\), take

\[
y=(4,-1,-1,-1,-1).
\]

Then four axes have weight \(3\) and six have weight \(-2\). Exact monomial
integration on \(S^2\) gives

\[
\frac1{4\pi}\int F^2=\frac{2800}{351},
\]

\[
\frac1{4\pi}\int F^3=-\frac{15680000}{1247103},
\]

while

\[
\sigma_3(y)=20.
\]

Consequently:

> **Theorem 4.1.**
> \[
> \boxed{
> G(y)=-\frac{784000}{1247103}\sigma_3(y).
> }
> \]
> In particular, the Clebsch cubic is the ordinary \(\ell=6\) Gaunt or
> \(W_6\) cubic restricted to the ten-axis four-channel.

The exact certificate is implemented in `clebsch_w6_exact.py` using only
rational arithmetic in \(\mathbf Q(\sqrt5)\).

### 5. Status of the banked tensor

Let

\[
T_{\mathrm{sgn}}\in\operatorname{Sym}^3(W^*),
\qquad
W\cong1\oplus4\oplus5,
\]

be the signed tensor described in the factorization-memory inventory. If

\[
T_{\mathrm{sgn}}|_{V_4}\ne0,
\]

then uniqueness forces

\[
T_{\mathrm{sgn}}|_{V_4}=c_{\mathrm{bank}}\sigma_3
=-\frac{1247103c_{\mathrm{bank}}}{784000}G.
\]

The supplied `compare_rank10_tensor.py` performs this test exactly. It expects
the tensor convention

\[
T(a)=\sum_{i,j,k=1}^{10}T_{ijk}a_ia_ja_k
\]

in two-subset lexicographic order

\[
01,02,03,04,12,13,14,23,24,34.
\]

No available attachment or report contains \(T_{ijk}\). That is the sole
remaining input.

---

## Part II. Atomistic pilot

### 6. Simulation

The supplied C++ program runs:

- \(N=500\);
- equimolar binary Lennard-Jones particles;
- \(\sigma_{AA}=1\), \(\sigma_{AB}=11/12\), \(\sigma_{BB}=5/6\);
- equal well depths;
- masses \(2\) and \(1\);
- density \(1.296\);
- shifted-force cutoff \(2.5\sigma_{ij}\);
- velocity-Verlet integration with \(dt=0.003\);
- cooling from \(T=1.2\) to \(T=0.58\);
- a final low-temperature trajectory;
- three independent initialization seeds.

This is a short Wahnström-type pilot, not a production-quality equilibrated
glass study. The original Wahnström model and its crystallization behaviour
are established simulation benchmarks; the present trajectory is deliberately
small enough to reproduce quickly.

### 7. Local reconstruction

For each atom and frame:

1. take the twelve nearest neighbours;
2. normalize their directions;
3. compute the convex hull and its twenty triangular faces;
4. pair approximately opposite faces;
5. require the induced ten-vertex graph to be Petersen;
6. compute \(P_4\);
7. calculate ordinary \(Q_6\) and normalized \(W_6\);
8. construct geometric and chemical four-channel weights.

The geometric face observable is triangular area. The chemical observable is
the product of the three binary species signs on a face. Opposite faces are
then paired and projected with \(P_4\).

### 8. A no-go theorem for simpler observables

The first implementation used additive vertex weights, such as mean face
radius and species count. Every resulting four-projection vanished to machine
precision. This is structural.

The permutation representation on the twelve icosahedral vertices is

\[
\mathbf R^{12}\cong1\oplus3\oplus3'\oplus5.
\]

The face-pair space is

\[
\mathbf R^{10}\cong1\oplus4\oplus5.
\]

Any \(A_5\)-equivariant linear map from additive vertex weights to face-pair
weights has no image in the four-summand because

\[
\operatorname{Hom}_{A_5}
\left(1\oplus3\oplus3'\oplus5,4\right)=0.
\]

Similarly,

\[
\operatorname{Sym}^2(3)=1\oplus5.
\]

Therefore evaluating an ordinary symmetric stress tensor along the ten axes
also has zero four-projection.

> **Theorem 8.1.**  
> Additive one-vertex decorations and rank-two tensor observables cannot
> detect the Clebsch four-channel. A physical detector must use irreducible
> face-level or higher-body information.

This materially lowers the plausibility of simple experimental readout but
makes the observable genuinely independent of ordinary density and stress.

### 9. Prediction protocol

The target was the logarithm of future cage-relative squared displacement:

\[
\log_{10}
\left\|
\Delta r_i-
\frac1{12}\sum_{j\in N_i}\Delta r_j
\right\|^2.
\]

Baseline features:

\[
\text{species},\quad Q_6,\quad W_6,\quad
\text{radial standard deviation}.
\]

Extended features added:

\[
C_4^{\mathrm{area}},
\quad\|P_4a^{\mathrm{area}}\|,
\quad
C_4^{\mathrm{chem}},
\quad\|P_4a^{\mathrm{chem}}\|.
\]

Training used the first \(70\%\) of eligible times and testing the final
\(30\%\), preventing random time leakage.

### 10. Main three-seed results

| Seed | Rows | Icosahedral rows | Baseline \(R^2\) | Extended \(R^2\) | Baseline AUC | Extended AUC |
|---:|---:|---:|---:|---:|---:|---:|
| 20260725 | 3782 | 2947 | 0.0318 | 0.0213 | 0.6563 | 0.6561 |
| 20260726 | 3121 | 2371 | -0.0509 | -0.0220 | 0.5372 | 0.5202 |
| 20260727 | 3598 | 2847 | 0.0201 | 0.0023 | 0.6521 | 0.6336 |

The second seed's regression became less bad but remained negative, while its
classification worsened. There is no consistent positive result.

### 11. Timescale check

For the first seed:

| Lag in stored frames | Rows | Baseline \(R^2\) | Extended \(R^2\) | Baseline AUC | Extended AUC |
|---:|---:|---:|---:|---:|---:|
| 2 | 4484 | 0.0035 | 0.0271 | 0.6251 | 0.6209 |
| 5 | 4241 | 0.0263 | 0.0050 | 0.6494 | 0.6520 |
| 10 | 3782 | 0.0318 | 0.0213 | 0.6563 | 0.6561 |
| 15 | 3350 | 0.0520 | 0.0316 | 0.6486 | 0.6475 |
| 20 | 2886 | 0.0390 | 0.0337 | 0.6551 | 0.6499 |

The short-lag \(R^2\) improvement is not corroborated by AUC or other lags.

### 12. Interpretation

The pilot rejects the immediate claim:

> The area/chemical Clebsch sign is a robust local-mobility predictor in a
> short Wahnström-type quench.

It does **not** reject:

- a stress-history or force-flux three-body observable;
- prediction in realistic Cu-Zr potentials;
- medium-range domains rather than single cages;
- nucleation rather than mobility;
- a deliberately engineered device.

The next physical experiment is justified only if it changes the observable or
system substantially. Merely enlarging this same short simulation has low
expected value.

Recommended next physical target:

\[
\text{three-face energy/force flux}
\longrightarrow
P_4
\longrightarrow
\text{nucleation or local yield},
\]

in an equilibrated Cu-Zr or Wahnström trajectory with established dynamical
labels.

---

## Part III. Arithmetic Hitchin cover

### 13. Geometric input

Let \(H_3\) be the seven-dimensional rational space of harmonic cubics and let

\[
P=\mathbf P(H_3)\cong\mathbf P^6.
\]

Hitchin constructs a generically degree-two incidence map whose generic fibre
is the pair of icosahedral axis sets on the nodal cubic. Its branch divisor is
the invariant sextic

\[
B=(J_0=0).
\]

On a marked Clebsch four-space,

\[
J_0=16\sigma_3^2.
\]

### 14. Rational double-cover lemma

> **Lemma 14.1.**  
> Let \(k\) have characteristic different from two. A geometrically integral
> degree-two cover of \(\mathbf P^n_k\), branched exactly along a geometrically
> integral sextic \(J=0\), has function field
> \[
> k(\mathbf P^n)(\sqrt{cJ})
> \]
> for a unique square class \(c\in k^\times/k^{\times2}\).

**Proof.** A quadratic extension is \(k(P)(\sqrt d)\) for
\(d\in k(P)^\times/k(P)^{\times2}\). Its codimension-one ramification is the
odd part of \(\operatorname{div}(d)\). Since the only branch component is
\(J=0\), one may multiply \(d\) by a square to obtain \(d=cJ\).
Projectively, a sextic branch divisor has half-line bundle
\(\mathcal O_P(3)\), unique because

\[
\operatorname{Pic}(P)=\mathbf Z
\]

has no two-torsion. The remaining ambiguity is multiplication by a constant
square class. \(\square\)

### 15. Determination of the constant

For

\[
f_0=xyz,
\]

the two compatible icosahedral configurations are

\[
I_t,\qquad t^2-t-1=0.
\]

Thus the incidence fibre is

\[
\operatorname{Spec}\mathbf Q(\sqrt5).
\]

In Hitchin's marked coordinates,

\[
J_0(f_0)=\left(\frac{16}{25}\right)^2
\]

is a rational square. Therefore the constant square class in Lemma 14.1 is
\(5\).

> **Theorem 15.1 — rational arithmetic Hitchin cover.**  
> The normalization of \(\mathbf P(H_3)\) in the generic ordered-icosahedron
> incidence extension is
> \[
> \boxed{w^2=5J_0}
> \]
> over \(\mathbf Q\), up to \(w\mapsto rw\) with \(r\in\mathbf Q^\times\).

### 16. Explicit integral cover

Choose a full lattice \(\Lambda\subset H_3\) and choose
\(r\in\mathbf Q^\times\) so that

\[
J_{\mathbf Z}=r^2J_0\in
H^0\!\left(\mathbf P(\Lambda),\mathcal O(6)\right)
\]

is integral. Define the rank-two algebra

\[
\mathcal A=
\mathcal O_P\oplus\mathcal O_P(-3),
\]

where multiplication on the second summand is given by

\[
\mathcal O_P(-3)^{\otimes2}
\xrightarrow{\,5J_{\mathbf Z}\,}
\mathcal O_P.
\]

Then

\[
X_{\mathbf Z}=\operatorname{Spec}_P\mathcal A
\]

is finite locally free of degree two over \(P\). Its generic fibre is the
rational Hitchin cover.

This supplies an unconditional arithmetic model of the quadratic extension.
It does not by itself prove that a chosen integral closure of the geometric
Mukai-Umemura incidence variety is isomorphic to \(X_{\mathbf Z}\) at every
prime.

### 17. Finite-field theorem

Let \(q\) be odd, and reduce an integral normalization at a prime where
\(J_{\mathbf Z}\) remains defined. For

\[
[f]\in\mathbf P(\Lambda)(\mathbf F_q),
\qquad J_{\mathbf Z}(f)\ne0,
\]

the number

\[
\chi_q(5J_{\mathbf Z}(f))
\]

is independent of the projective representative because replacing \(f\) by
\(\lambda f\) multiplies \(J(f)\) by \(\lambda^6\), a square.

The fibre equation is

\[
w^2=5J_{\mathbf Z}(f).
\]

Therefore:

> **Theorem 17.1 — finite-field fibre formula.**
> \[
> \boxed{
> \#X_f(\mathbf F_q)
> =
> 1+\chi_q(5J_{\mathbf Z}(f)).
> }
> \]
> Thus the fibre has two rational points when \(5J(f)\) is a square and none
> when it is a nonsquare.

On the branch \(J(f)=0\), the geometric fibre has one rational point, counted
with multiplicity two when the branch is simple.

At characteristic five, the displayed integral model becomes generically
nonreduced:

\[
w^2=0.
\]

At characteristic two it is inseparable. Neither characteristic supports the
ordinary étale two-sheet interpretation.

### 18. Reduction modulo eleven

Modulo eleven,

\[
t^2-t-1=(t-4)(t-8).
\]

Hence the \(xyz\) fibre splits into the two golden configurations. The explicit
rotation calculated in the Hitchin-Clebsch report exchanges them and has
nonsquare spinor norm. It represents the nontrivial class of

\[
SO_3(11)/\Omega_3(11)
\cong
PGL_2(11)/PSL_2(11).
\]

Thus the finite fibre orientation is exactly \(T_{11}\).

### 19. Incidence interpretation and the remaining integral gap

Let \(Y_{\mathbf Q}\) be the normalization supplied by the geometric
icosahedron incidence construction. Theorem 15.1 gives

\[
Y_{\mathbf Q}\cong X_{\mathbf Q}.
\]

Take any finite-type integral model \(Y_R\) over a localization
\(R=\mathbf Z[1/M]\). An isomorphism and its inverse over \(\mathbf Q\) are
defined by finitely many rational functions. Clearing their denominators and
the finitely many relations proves:

> **Theorem 19.1 — spread-out incidence comparison.**  
> There is a nonzero integer \(N\) such that
> \[
> Y_{\mathbf Z[1/N]}
> \cong
> X_{\mathbf Z[1/N]}.
> \]
> Consequently, for every prime \(p\nmid N\), Theorem 17.1 counts rational
> icosahedral incidence points, not merely points of an abstract quadratic
> cover.

What is not presently proved is the minimal value of \(N\), or even the claim
that its prime divisors are only \(2,3,5\). Settling that requires:

1. explicit integral equations for the incidence compactification;
2. normalization or Stein factorization over the chosen base;
3. comparison of the resulting quadratic algebra with
   \(\mathcal O\oplus\mathcal O(-3)\);
4. resultant checks at the candidate good primes.

The literature search found no ready-made integral Mukai-Umemura model carrying
this incidence comparison. Existing sources work predominantly over
\(\mathbf C\), \(\mathbf R\), or characteristic zero.

---

## Recommendations

### Immediate mathematical action

Supply the rank-ten signed tensor table from the factorization-memory project.
The exact contraction will then decide the strongest identity in seconds.

### Physical action

Do not market the present area/chemical descriptor as predictive. If the
materials direction continues, switch to a genuinely dynamical three-body
face observable and a production trajectory with accepted labels for local
yield or nucleation.

### Arithmetic action

The rational theorem and finite-field cover formula are ready to write.
Publication should phrase the incidence reduction as holding outside a finite
bad set until the integral Mukai-Umemura equations are checked.

---

## Reproduction

Exact theorem:

```bash
python3 research/clebsch_w6_exact.py
```

Build and run one atomistic seed:

```bash
g++ -O3 -std=c++20 research/wahnstrom_md.cpp -o research/wahnstrom_md
./research/wahnstrom_md research/wahnstrom_trajectory.csv 30000 20260725
python3 research/clebsch_glass_benchmark.py \
  research/wahnstrom_trajectory.csv \
  --lag-frames 10 \
  --rows-output research/wahnstrom_descriptor_rows.csv \
  --results-output research/wahnstrom_results.json
```

Banked tensor comparison, once the table is available:

```bash
python3 research/compare_rank10_tensor.py rank10_tensor.json
```

---

## Principal literature

- Nigel Hitchin, [*Spherical harmonics and the icosahedron*](https://arxiv.org/abs/0706.0088).
- Nigel Hitchin, *Vector bundles and the icosahedron*, in *A Celebration of the Mathematical Legacy of Raoul Bott*, 2010.
- P. J. Steinhardt, D. R. Nelson and M. Ronchetti,
  [*Icosahedral Bond Orientational Order in Supercooled Liquids*](https://link.aps.org/doi/10.1103/PhysRevLett.47.1297).
- P. J. Steinhardt, D. R. Nelson and M. Ronchetti,
  [*Bond-orientational order in liquids and glasses*](https://link.aps.org/doi/10.1103/PhysRevB.28.784).
- G. Wahnström, *Molecular-dynamics study of a supercooled two-component
  Lennard-Jones system*, Physical Review A **44** (1991), 3752.
- U. R. Pedersen, N. P. Bailey, J. C. Dyre and T. B. Schrøder,
  [*Crystallization of the Wahnström Binary Lennard-Jones Liquid*](https://arxiv.org/abs/0706.0813).
- A. P. Thompson et al.,
  [*A Spectral Analysis Method for Automated Generation of Quantum-Accurate Interatomic Potentials*](https://arxiv.org/abs/1409.3880).
- R. Drautz,
  [*Atomic cluster expansion for accurate and transferable interatomic potentials*](https://link.aps.org/doi/10.1103/PhysRevB.99.014104).
