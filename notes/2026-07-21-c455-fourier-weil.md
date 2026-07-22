# C455 — the C372/C378 Fourier operator as a Weil Weyl operator

**Lane:** `crowns`

**Date:** 2026-07-21

**Verdict:** `PROVED WITH RESTRICTION/PROJECTIVE WORDING; NO STANDALONE WEIL MODULE`

## Exact statement

Put `V=F_11^3`, fix

```text
psi(t)=exp(2 pi i t/11),
hat(f)(y)=sum_{x in V} psi(y dot x) f(x),
F=11^(-3/2) hat.
```

There is only one Fourier operator in the two frozen certificates: the normalized discrete Fourier
transform `F` on the ambient Schrödinger space `C[V]`, of dimension `1331`.  C372's rank-eight
matrix, C378's rank-sixteen matrix, and C378's signed rank-four matrix are restrictions of this same
operator to, respectively,

```text
U_8  = C[V]^(F_11^* x A5_plus),
U_16 = C[V]^(F_11^* x A4),
U_4^- = the J-odd subspace of U_16.
```

The dot product identifies `V` with `V*`.  The frozen scalar orbit closures make all three spaces
stable under Fourier transform; they also make every function even under `x -> -x`.  Hence the
ambient identity `F^2=R`, where `Rf(x)=f(-x)`, restricts to `F^2=I` on all three spaces.  This is the
precise meaning of the certificates' Fourier self-duality.

Let `w=[[0,I_3],[-I_3,0]]` in `Sp(V+V*)`, with the Schrödinger convention in which its projective
intertwiner has the displayed plus-sign kernel.  Then

```text
[rho_psi(w)] = [F].
```

Thus the certified Fourier transform is projectively the restriction of the ambient finite Weil
operator for the Weyl element.  It is stronger than an analogy and does not require a speculative
conjugacy.

The scalar qualification is essential.  For the canonical complex embedding,

```text
gamma_psi = 11^(-1/2) sum_t psi(t^2) = i.
```

In the Gauss-sum linearization fixed by
`rho(n_B)f(x)=psi(-x^T B x/2)f(x)`, the scalar is

```text
rho_psi(w)=gamma_psi^(-3) F=iF,
rho_psi(-I_6)=-R.
```

On each certified even subspace the genuine operator therefore squares to `-I`, while the
certificate's normalized Fourier operator squares to `+I`.  They are scalar multiples and define
the same projective operator, but they are not literally conjugate as complex linear operators:
their eigenvalues are `+/-1` and `+/-i`.  The frozen data do not make `U_8`, `U_16`, or `U_4^-` a
module for the whole Weil representation; only stability under this Weyl operator is proved.

Accordingly roof substatement (c) is **PROVED** only in the following wording:

> The C372 and C378 self-dual matrices are normalized orbit-basis restrictions of the single
> ambient `Sp_6(F_11)` Weil Weyl operator, projectively and with an explicit Gauss phase; they do
> not constitute standalone rank-eight, rank-sixteen, or rank-four Weil modules.

The stronger literal claim that a frozen matrix is conjugate to the genuinely normalized Weil
operator is dead.

## Bases and conjugacies

For C372 let `P_8` be the displayed eigenmatrix, let `k_j=|R_j|`, and put
`D_8=diag(k_j)`.  In the raw indicator basis `1_Rj`, the unnormalized transform has matrix `P_8`.
In the orthonormal basis `1_Rj/sqrt(k_j)`, the unitary restriction has matrix

```text
B_8 = 11^(-3/2) D_8^(1/2) P_8 D_8^(-1/2).
```

The checker verifies `D_8 P_8=P_8^T D_8`, `P_8^2=1331 I_8`, and a `4+4` split of the normalized
`+1/-1` eigenspaces.

For C378 the identical formula with the sixteen common-refinement valencies gives `B_16`; the
split is `8+8`.  On the ordered signed basis

```text
1_S1-1_S10, 1_S3-1_S13, 1_S6-1_S14, 1_S9-1_S11,
```

the raw matrix is exactly

```text
M_odd =
  -11    0   44  -22
    0  -11   22   44
   22   11   11    0
  -11   22    0   11.
```

Its basis-vector squared norms are `120,120,240,240`.  Conjugating by the square roots of these
norms and multiplying by `11^(-3/2)` gives the unitary Weil restriction `B_odd`; it is a symmetric
involution with a `2+2` eigenspace split.  The raw identity is `M_odd^2=1331 I_4`.

As a free joint-spectrum upgrade, `J` commutes with Fourier transform and the four simultaneous
`(J,F)` multiplicities on `U_16` are

```text
(+,+)=6, (+,-)=6, (-,+)=2, (-,-)=2.
```

Reversing the named chirality negates the signed basis but changes none of these multiplicities.
Consequently no C456 chirality separator can factor only through this Fourier spectrum; it must use
finer tensor/party-labeled data.

## Post-close field and central-character upgrade

The raw involutions have eigenvalues `+/-11 sqrt(11)`.  Multiplication by the genuine Gauss phase
`i` changes these to

```text
+/-11 sqrt(-11).
```

Thus the genuine signed Fourier operator has exact eigenvalue field `Q(sqrt(-11))`, the same field
as C450's exchanged degree-five Weil pair.  Its nontrivial Galois automorphism exchanges the two
eigenspaces.  This is a real mechanism-level field coincidence, not merely matching dimensions.

The central character prevents overreading it.  In the diagonal `SL_2(F_11)` oscillator action,
the central element acts on these even functions by

```text
chi_11(-1)^3 R = -I.
```

Therefore any extension of the certified Weyl action to that full diagonal `SL_2` action would lie
in the nontrivial-central-character sector and could not descend to `PSL_2(11)`.  C450's field match
does not produce a degree-five `PSL_2(11)` constituent, a stable restricted module, or an Adler
repair.  It instead explains why `Q(sqrt(-11))` is the correct field to test whenever a future
central-character-compatible bridge is proposed.

## C454 compatibility discriminator

C454's controller-level relative-cubic split is `3=1+0+1+1`.  The Fourier eigenspace splits are
`4+4` on `U_8` and `2+2` on `U_4^-`; neither produces a canonical three-space or the three named
relative-cubic lines.  Therefore the Weil identification does not repair the failed Adler bridge,
does not identify a Fourier fixed space with C454's cubic module, and supplies no map to its pure
heart lines.  This is a strict incompatibility with that stronger roof reading, not missing
evidence.

## Exact evidence and boundary

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-21-c455-fourier-weil.py --check
sha256sum -c notes/2026-07-21-c455-fourier-weil.sha256
```

The checker pins the C372 and C378 JSON certificates, independently reconstructs all three raw
matrix restrictions, checks their squares and weighted self-adjointness, checks the C372
hyperplane-count formula, derives the signed block from the rank-sixteen matrix, and records the
normalization, Gauss phase, central action, and eigenspace multiplicities in canonical JSON.

The independent cross-check is the agreement of two frozen constructions: C372's hyperplane
character sums and C378's independently generated common-refinement Fourier matrix.  No numerical
cyclotomic approximation is used.  The trusted boundary is exact Python integer arithmetic, the
two pinned certificates, the elementary finite Fourier identity, and the standard Schrödinger
model/Gauss-sum linearization stated above.  No literature or novelty claim is made, and no action
of the remaining symplectic generators on any restricted space is asserted.
