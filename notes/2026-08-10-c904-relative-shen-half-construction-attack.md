# C904: relative Shen-half construction attack

**Date:** 2026-08-10

**Status:** exact negative closure for ambient Fano-sum constructions;
the intrinsic relative half remains open

**Scope:** the relative 16-term minimal cycle, the common-line

\[
 D_+=F+F\subset J,
\]

and attempts to construct an odd-degree complete half over
\(K=\mathbf C(B)\).  No manuscript, Lean, handoff, or task-card change.

## Executive verdict

No honest odd relative half was constructed.  The search nevertheless closes
the largest explicit class of proposed constructions by an exact integral
theorem.

Let

\[
 c=\frac{\Theta^4}{4!}\in H^8(J,\mathbf Z)
\]

be the primitive minimal curve class and let \(L^3_{\rm Hdg}\) be the full
integral codimension-three Hodge lattice of the generic exotic marked
intermediate Jacobian.  The common-line Fano-sum divisor has

\[
                         [D_+]=3\Theta.
\]

Exact Hermite-normal-form computation on the certified saturated rank-50
lattice gives

\[
\begin{aligned}
 \operatorname {ord}_{\,H^8/\Theta L^3_{\rm Hdg}}(c)&=2,\\
 \operatorname {ord}_{\,H^8/3\Theta L^3_{\rm Hdg}}(c)&=6.       \tag{E.1}
\end{aligned}
\]

Equivalently,

\[
 \min\{m>0:m c\in [D_+]\smile L^3_{\rm Hdg}\}=6.              \tag{E.2}
\]

Therefore no odd multiple of the 16-term minimal class can be moved onto
\(D_+\) by an **ambient integral codimension-three construction**.  This
rules out, in one calculation:

- replacing a factor in the sixteen divisor monomials by \(D_+\);
- twisting the indefinite factors by ample line bundles, choosing relative
  divisors, and cancelling the residual complete intersections;
- averaging those constructions over \(A_5\); and
- any proper family of ambient complete-intersection moves whose output
  factors cohomologically as \([D_+]\smile Q\) with integral Hodge
  \(Q\).

The index is exactly six, not merely even: \(6c\) is ambient-supported in
cohomology and no proper positive divisor of six is.

This is deliberately not an impossibility theorem for an **intrinsic** curve
on \(D_+\).  Shen's fixed-complex-fibre cycle is precisely such an escape:
its Gysin class need not be the restriction of an ambient integral
codimension-three class.  Thus the surviving target is sharply identified:

> Construct a horizontal intrinsic
> \(\eta_K\in CH_1(D_{+,K})\) of minimal class, or construct the relative
> Shen cycle \(z_K\) together with an integral half
> \(2\eta_K=z_K\).  Any proof assembled only from the fifteen ambient
> divisor classes cannot do this.

Once \(\eta_K\) exists, common-line normalization has already removed the
unordered-lift obstruction: \(\operatorname {Sym}^2F\to D_+\) is proper
birational, and the degree-two Shen lift plus the degree-five exceptional
plane-quintic cut gives a degree-one signed lift by \(3\cdot2-5=1\).  The
missing object is \(\eta_K\), not its later lift to
\(\operatorname {Sym}^2\Theta\).

## 1. Input: what the 16-term cycle actually supplies

The exotic marked family carries fifteen rigidified relative symmetric line
bundles \(D_0,\ldots,D_{14}\).  The exact sparse relation in
`2026-08-10-c904-minimal-class-sparse-cycle.md` is a signed relative Chow
cycle

\[
 Z_{\min}=\sum_{r=1}^{16}a_rD_{i_r}D_{j_r}D_{k_r}D_{\ell_r}
       \in CH_1(J/B)
\]

with \([Z_{\min}]=c\).  Ten terms contain the effective rank-one axis class
\(D_0\); the remaining six, including the unique odd intersection with
\(D_+\), use only indefinite divisor classes.

This is enough to make the minimal cohomology class algebraic over the marked
base.  It is not a relative decomposition of the diagonal and it does not
choose, for every point of its support, a codimension-two cycle on the cubic.
Those are precisely the universal-cycle data still at issue.

The natural attempted improvement was to move the sixteen complete
intersections uniformly onto the geometrically controlled divisor
\(D_+=F+F\).  If this is done by replacing or deforming ambient divisors, the
resulting cohomology class necessarily has the form

\[
                       [D_+]\smile Q,
              \qquad Q\in L^3_{\rm Hdg}.                     \tag{1.1}
\]

Equation (E.2) shows that such a construction cannot have odd multiplier.
The lone odd numerical intersection

\[
 D_+D_1D_2D_{12}D_{13}=21

\]

does not contradict this: it is a degree pairing, not an integral solution
of the vector equation \([D_+]Q=c\).

## 2. Exact ambient-support theorem

### Theorem 2.1

For the generic exotic marked principally polarized fivefold,

\[
 \{m\in\mathbf Z:m c\in3\Theta L^3_{\rm Hdg}\}=6\mathbf Z.   \tag{2.1}
\]

For comparison,

\[
 \{m\in\mathbf Z:m c\in\Theta L^3_{\rm Hdg}\}=2\mathbf Z.   \tag{2.2}
\]

### Proof certificate

The certified integral Neron--Severi basis has rank fifteen.  Its 680
unordered triple products span a rank-50 lattice in \(\bigwedge^6H^1\).
The earlier saturation certificate proves that this lattice is saturated.
The generic non-CM Hodge group is \(\mathrm {SL}_2\), and skew Howe duality
identifies the rational codimension-three Hodge space with
\(\mathbf S_{(2,2,2)}\mathbf Q^5\), of dimension fifty.  Hence this is the
full integral Hodge lattice.

Cup every basis vector with the integral polarization form and express the
result in the 45-coordinate basis of \(\bigwedge^8H^1\).  The image has rank
fifteen.  Hermite normal form gives denominator two for the coordinates of
\(c\) in the \(\Theta\)-image and denominator six in the
\(3\Theta\)-image.  Membership is checked at the resulting multiples and
failure is checked at every proper positive divisor.  This proves (2.1) and
(2.2).

An independent SymPy replay reconstructs all 680 divisor triples from the
hard-coded principal and Neron--Severi constants, cups all of them directly
with \(3\Theta\), computes a separate 45-by-680 column HNF, and again obtains
orders two and six.  It does not import Sage's image basis.

This proof uses the full integral Hodge lattice, not just the sixteen sparse
monomials.  Changing the divisor basis or lengthening the sparse identity
cannot evade it.

## 3. Why the relative Shen construction does not yet start

Shen's Theorem 5.1 does not construct its symmetric cycle on \(F\times F\)
from an algebraic minimal curve on \(J\).  It assumes a Chow-theoretic
decomposition of the cubic diagonal, chooses auxiliary curves
\(Z_i\), correspondences \(\Gamma_i\), and lifts \(T_i\) through the
universal family of lines, and sets

\[
                         \theta=\sum_i n_iT_i\circ{}^tT_i.
\]

Proposition 5.7 centers this chosen cycle and obtains, over a fixed complex
fibre,

\[
                  (\phi_+)_*\widetilde\theta=2\eta.          \tag{3.1}
\]

Neither theorem makes \(\theta\) canonical or proves that it spreads over
the present \(K=\mathbf C(B)\).  More importantly, feeding the relative
16-term minimal cycle into Theorem 5.1 would require first turning that
cycle into a relative Chow decomposition or universal codimension-two cubic
cycle.  That is the conclusion this route is supposed to prove, so the use
would be circular.

The relative Poincare/divided-power construction from the minimal class is
not a replacement for (3.1): after pullback through the two Fano incidence
correspondences its integral scalar is four.  It supplies an even identity,
not the odd or primitive diagonal needed here.

## 4. Proper rationally connected parameter spaces

No proper rationally connected half-parameter space emerges from the
sixteen monomials.

The visible projective parameter spaces are linear systems used to replace
an indefinite line bundle by a signed difference of ample effective
divisors.  Every resulting curve remains in the ambient image (1.1), so
Theorem 2.1 forces multiplier divisible by six.  Rational connectedness of
the choices cannot change their integral cohomology class.

The other visible parameters occur only after an intrinsic curve on \(D_+\)
has been supplied:

- the birational strict transform through \(\operatorname {Sym}^2F\), and
- hyperplanes cutting the exceptional plane quintic in degree five.

They solve lifting, not construction of the missing horizontal curve.

Conditionally on a relative Shen cycle \(z_K\), its geometric halves form a
torsor under the discrete group
\(CH_1(D_{+,\overline K})[2]\), not a known finite-type rationally connected
variety.  The odd-degree halving theorem from
`2026-08-10-c904-relative-chow-halving-descent-obstruction.md` is therefore
the exact current replacement:

\[
 \exists L/K\text{ of odd degree with }z_L\in2CH_1(D_{+,L})
 \quad\Longleftrightarrow\quad
 z_K\in2CH_1(D_{+,K}).                                      \tag{4.1}
\]

Thus an odd multisection would be a complete solution, not a weaker one;
but none is produced by the present geometry.  If the obstruction is
nonzero, every halving field has even degree.

## 5. Exact surviving obstruction

There are now two cleanly separated gates.

1. **Intrinsic-carrier gate.**  Construct a horizontal curve on \(D_+\) of
   minimal class by a method not factoring through
   \([D_+]L^3_{\rm Hdg}\).  Fixed-fibre existence does not supply relative
   Chow descent.
2. **Half gate.**  If a relative \(z_K\) as in (3.1) is constructed, kill
   its class
   \([z_K]\in CH_1(D_{+,K})/2\).  An odd-degree solution descends
   by restriction--corestriction; a purely geometric invariant half is not
   enough.

The common-line theorem closes every subsequent unordered-lift issue.  The
remaining missing datum is therefore not a choice of ordering and not an
ambient divisor identity.  It is a new intrinsic relative cycle or an
equivalent universal-cycle construction.

## 6. Dead-route ledger

| proposed route | verdict | exact reason |
|---|---|---|
| replace one factor in each sparse monomial by \(D_+\) | dead | ambient image has exact minimal multiplier six |
| make indefinite factors effective by ample twists and cancel | dead for odd output | all terms remain in \([D_+]L^3_{\rm Hdg}\) |
| \(A_5\)-average an ambient move | dead | averaging stays in the same integral image |
| use the unique odd degree-21 monomial | dead as a vector identity | a scalar pairing does not solve \([D_+]Q=c\) |
| invoke Shen Theorem 5.1 directly from \(Z_{\min}\) | circular | theorem assumes a diagonal decomposition, not merely algebraicity of \(c\) |
| use common-line birationality to create \(\eta\) | wrong direction | it lifts an existing \(\eta\); it does not create one |
| apply GHS to the abstract half-set | unsupported | no proper rationally connected finite-type parameter space is constructed |
| use the Poincare divided-power cycle | even only | Fano pullback acts by scalar four |

## 7. Reproduction

Primary exact computation:

```sh
nix shell nixpkgs#sage -c sage -c \
  'exec(preparse(open("notes/2026-08-10-c904-fano-sum-support-index.sage").read()))'
```

Independent replay:

```sh
nix shell nixpkgs#sage -c sage -python \
  notes/2026-08-10-c904-fano-sum-support-index-replay.py
```

Both print `PASS` and the orders \(2,6\).

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-08-10-c904-fano-sum-support-index.sage` | 3,768 | `9e8b0614bb889972ced253f09256e96a18e8ff32095db89baa20b6de77fe15fe` |
| `2026-08-10-c904-fano-sum-support-index-replay.py` | 2,562 | `e215186b4559f139a9a22ab43c64e04262b9d9cf57df6ebca03f4934665fa611` |
| `2026-08-10-c904-fano-sum-support-index.out` | 285 | `d1476f0d69e69f57bda307ced617dfca3e340d5278f7a5ed8f369fa45fad0e68` |

## 8. Source ledger

This report newly consulted **zero sources at full-text depth** and one at
partial depth.  Its lattice and descent inputs are exact task-local
certificates cited above, not literature-negatives.  It makes no novelty or
priority claim.

1. **Mingmin Shen, _Rationality, universal generation and the integral
   Hodge conjecture_, arXiv:1602.07331.**  Read depth: **partial**, preprint
   PDF, Section 5.1, Theorem 5.1 and proof, Lemma 5.6, and Proposition 5.7;
   cache key `arXiv:1602.07331`, SHA-256
   `2e0f3a438379830b85e0e63fce9b6d85e621c3e3d1fbbe84a4a6117773c1007c`.
   Load-bearing pages: PDF pp. 17--22.  The source proves the fixed-complex-
   fibre construction under a Chow decomposition; the relative/circularity
   conclusion above is this audit's inference.

## 9. Mystery ledger

- **Settled:** every ambient Fano-sum complete-intersection construction has
  multiplier in \(6\mathbf Z\); there is no odd basis change or sparse-cycle
  rearrangement to find.
- **Settled:** common-line geometry removes the unordered-lift gate only
  after an intrinsic \(\eta\) exists.
- **Open:** whether the marked family carries a horizontal intrinsic minimal
  curve on \(D_+\).  Exact gap: no relative Chow construction or proper-RC
  moduli space for such curves.
- **Open:** conditional on relative \(z_K\), whether its halving obstruction
  in \(CH_1(D_{+,K})/2\) vanishes.  Exact gap: no odd-degree half and no
  Chow-descent theorem for the geometric half torsor.
- **Open but now isolated:** an algebraic correspondence not factoring
  through ambient divisor multiplication could still work.  Producing it
  would be the new mathematics, not a repackaging of the sixteen monomials.

## Bottom line

The 16-term cycle cannot be pushed into the common-line Fano sum by any
ambient integral construction with odd multiplier: the exact multiplier
ideal is \(6\mathbf Z\).  The only surviving route is intrinsically
supported on \(D_+\), and Shen's source does not make that route relative
without first assuming essentially the universal-cycle conclusion under
study.
