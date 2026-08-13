# C907 — peak confluence obstruction

Date: 2026-08-13

Status: exact obstruction to the valley/radial-leg composition proposal.  The
proposal correctly localizes the coherence problem to weak-factorization
peaks, but neither scalar germ-faithfulness nor the standard
coalescing-eigenvalue isomonodromy theorem identifies the primitive-sixth
packets emerging from the two extremal axes.

## 1. The two extremal axes are different branches

Let a smooth projective peak `Y` admit blowdowns

\[
 p:Y\longrightarrow X,\qquad p':Y\longrightarrow X'
\]

with fibre classes `e,e'`, exceptional divisors `E,E'`, and intrinsic peak
Novikov monomials

\[
 x=Q^e,\qquad x'=Q^{e'}.
\]

Iritani's blowup substitution gives, in the `p` chamber,

\[
 x'=B x^{-a},\qquad B=Q^{p_*e'},\qquad a=E\cdot e'.
 \tag{1}
\]

When the rays meet, typically `a>0`, so this is a Laurent transition and not
a map of large-radius power-series completions.  The intrinsic numerical
Novikov completion of `Y` does have a legal corner `x=x'=0`, because an ample
degree is positive on both rays.  That corner is not in the punctured overlap
of the two blowdown charts.

The smallest smooth toric example is

\[
 Y=\operatorname{Bl}_{p_1,p_2}\mathbf P^2.
\]

Contract `e=E_1` on one side and `e'=H-E_1-E_2` on the other.  Since
`E_1\cdot e'=1`, if `B=Q^{H-E_2}` then

\[
 B=xx'.
 \tag{2}
\]

The two extremal specializations are the two branches of `B=0`: one retains
`x` and kills `x'`, the other retains `x'` and kills `x`.  They meet only at
the confluent origin.  Products with a smooth projective threefold give the
same peak-chart obstruction in dimension five.

Thus the two radial legs avoid the old-exceptional infinite-tail regression,
but they do not produce a common punctured parameter fibre.  Any comparison
must cross the confluence at the origin.

## 2. Extending the covector does not extend the selected line

The elementary rank-two quantum connection of `P^1` is a useful exact model
of the logical issue.  In the basis `(1,H)`, put

\[
 A(q)=\begin{pmatrix}0&q\\1&0\end{pmatrix},\qquad
 \mu=\operatorname{diag}(-1/2,1/2),
\]

and

\[
 D_q=q\partial_q+A(q)/z,\qquad
 D_z=z\partial_z+\mu-2A(q)/z.
\]

Then `[D_q,D_z]=0`.  For `q\ne0`, the exponential eigenlines are generated
by

\[
 v_\pm=(\pm\sqrt q,1)^t
\]

and are exchanged by a loop about `q=0`.  Define

\[
 f(u)=\sum_{d\ge0}\frac{u^d}{(d!)^2},\qquad
 h(u)=u f'(u),\qquad u=q/z^2,
\]

and the row

\[
 \ell(q,z)=z^{-1/2}(f(u),z h(u)).
\]

The identity `u f''+f'-f=0` gives exactly

\[
 q\partial_q\ell=\ell A/z,\qquad
 z\partial_z\ell=\ell(\mu-2A/z).
\]

Hence `ell` is a single-valued horizontal covector extending through the
confluence, with `ell(0,z)=z^{-1/2}(1,0)`.  Nevertheless,

\[
 \ell(v_+)-\ell(v_-)=2z^{-1/2}\sqrt q\,f(q/z^2)\ne0.
 \tag{3}
\]

This model is not claimed to satisfy the semisimple-coalescence hypotheses
used below: its leading matrix is not holomorphically diagonalizable at the
origin.  Its purpose is narrower and exact.  Scalar extension and scalar
constancy do not identify a ramified exponential subspace.  A theorem used
to compare the two legs must carry the subspace as part of its input.

## 3. Why the standard coalescence theorem does not close the peak

Cotti--Dubrovin--Guzzetti study an isomonodromic family

\[
 \frac{dY}{dz}=\left(\Lambda(t)+\frac{\widehat A_1(t)}z\right)Y
 \tag{4}
\]

whose leading eigenvalues may coalesce.  Their Theorem 1.1 assumes, among
other hypotheses, a holomorphic diagonalization through the coalescence and

\[
 (\widehat A_1)_{ab}=O(u_a-u_b)
 \tag{5}
\]

for every coalescing pair.  It then extends the formal and canonical
fundamental solutions through the coalescence and forces **both directions**
of the corresponding Stokes entries to vanish.  Conversely, Theorem 1.2 and
Theorem 15.1 require

\[
 (S_i)_{ab}=(S_i)_{ba}=0
 \tag{6}
\]

for every coalescing pair in the two adjacent Stokes matrices in order to
remove branching and preserve the canonical asymptotics.

This theorem does not apply to the C907 corner for two independent reasons.

1. Shen--Shoemaker prove their center/tame asymptotics at fixed `q ne 0`.
   Their sectors are expressed in `arg(z/q)`, and they give no parameterized
   canonical summation at `q=0`.  Iritani's blowup decomposition instead
   lives over a Laurent ring with the exceptional parameter inverted.  The
   primitive-sixth formal packet is present only in that punctured/formal
   regime and does not specialize to the all-formal classical origin.  Thus
   holomorphic extension of the labeled formal normal form—the input of the
   coalescence theorem—is precisely what is missing.
2. The Gamma/Orlov semiorthogonality used by the one-arrow theorem supplies
   one oriented block vanishing.  The coalescence theorem requires both
   Stokes directions for every center--ambient pair.  Choosing a point away
   from the exceptional divisor does make its individual Euler pairings with
   exceptional-supported objects vanish in both directions, but this only
   decouples that point row/column.  General ambient and center objects have
   the nonzero reverse Euler extensions encoded by Orlov's semiorthogonal
   decomposition, so the required full-block hypothesis is false in general.

Even if (6) were supplied for a distinguished row, it would only preserve an
already labeled formal factor through a single coalescence family.  The two
peak axes carry two chamber labels.  Equation (2) shows that neither is the
punctured continuation of the other inside the extremal base.  The desired
statement remains

\[
 \mathfrak r_Y|_{P_6^{(x)}}\ne0
 \quad\Longleftrightarrow\quad
 \mathfrak r_Y|_{P_6^{(x')}}\ne0,
 \tag{7}
\]

and (7) is not a consequence of extension of `mathfrak r_Y` alone.

## 4. Exact surviving theorem and exact missing theorem

The valley/radial proposal has a real gain: it reduces the multi-arrow
coherence problem to peaks, while valleys use the same normalized ambient
receiver on both incident arrows.  At each peak, however, one needs one of:

1. a two-chamber nearby-cycle comparison carrying `P_6^(x)` to `P_6^(x')`
   and intertwining the Gamma rank covector;
2. a proof that the actual Stokes/connection mutation word between the two
   chamber receivers preserves the Boolean in (7);
3. a common enhanced-Riemann--Hilbert or full-Novikov realization in which
   both chamber packets are conservative images of one object.

Scalar germ-faithfulness on the radial legs is useful only after one of these
subspace comparisons is supplied.

### Audit of the two-variable good-formal-structure proposal

A proposed repair passes to a two-variable iterated Laurent ring and invokes
the Kedlaya--Mochizuki good-formal-structure theorem after modifying the
parameter corner.  This does not yet supply any of the three comparisons
above.

First, the proposed coefficient ring is incompatible with the peak
regression (2).  Inverting both `x` and `x'` forces `B=xx'` to be a unit.
Therefore a ring of the schematic form

\[
 \mathbf C((x^{-1/s}))((x'^{-1/s'}))[[B,\ldots]]
 \tag{8}
\]

cannot receive the intrinsic relation while retaining the extremal closed
fibre `B=0`.  The two iterated orders live in different localized chambers;
their simultaneous localization deletes the corner one wanted to use.

Second, Kedlaya's theorem is a theorem about **formal meromorphic
connections**.  After blowing up turning points, it supplies a good formal
decomposition into exponential factors tensored with regular connections.
Kedlaya explicitly states that the paper does not discuss asymptotic analysis
or the Stokes phenomenon.  Consequently goodness controls the formal
exponential labels but not the sectorial Stokes matrices or the
large-radius-to-small-`z` central connection entries which make the Barnes
rank functional nonzero.  A formal decomposition cannot by itself transport
an invariant which is zero on separated exponential symbols before Stokes
realization.

Third, the QDM singularity is not merely a meromorphic connection on the
`(x,x')` parameter surface.  Its irregular direction is `z=0`, with turning
of exponential factors as the parameters approach the axes.  Applying a
good-structure theorem requires a meromorphic connection on a space including
the `z` direction (and a convergent/algebraic or otherwise admissible formal
coefficient object at every Novikov level).  Even if that setup is supplied,
the output remains a formal decomposition.  A pairing-compatible Stokes
local system or enhanced Riemann--Hilbert comparison is an additional input,
not a consequence of goodness.

Thus a parameter-corner modification is a plausible preprocessing step for
the true peak theorem, but it does not give the intertwiner or rank-covector
compatibility.  The proposal's own observation that the Boolean is invisible
purely formally is exactly the obstruction to deriving it from good formal
structure alone.

## 5. AA / EJ / TT

- **AA:** test the peak mutation word rather than another scalar-constancy
  variant.  Standard-flip peaks are the first possible positive class,
  because Shen--Shoemaker provide an actual two-side Fourier--Mukai
  comparison there.  General weak-factorization peaks are not automatically
  standard flips.
- **EJ:** the one-arrow receiver, the exact `nu=1` Shen--Shoemaker repair,
  endpoint product, and valley localization form a publishable conditional
  package: Gold follows from the single peak comparison (7).
- **TT:** `x=x'=0` is a common intrinsic Novikov corner but not a common
  punctured chamber point.  Confusing those two statements recreates the
  original illegal frame transport.

## Source boundary

The Cotti--Dubrovin--Guzzetti paper was read selectively through the
Introduction, Theorems 1.1--1.2, and Theorem 15.1, not cover to cover:

- G. Cotti, B. Dubrovin, D. Guzzetti, *Isomonodromy Deformations at an
  Irregular Singularity with Coalescing Eigenvalues*, arXiv:1706.04808,
  cached SHA-256
  `a1ec0068155ae84e6bb805d485135b07160a986cfec84108f8fd8a6dde3c9110`.
- K. S. Kedlaya, *Good formal structures for flat meromorphic connections,
  I: Surfaces*, arXiv:0811.0190, selectively read through the Introduction and
  Sections 6.0--6.3; cached SHA-256
  `dda5ad402566a794d65a1a5613630db9ac5734296edad58bf1d24cec601b1ba4`.
- H. Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3,
  Theorem 5.18 and Remark 1.5.
- Y. Shen and M. Shoemaker, *Quantum spectrum and Gamma structure for
  standard flips*, arXiv:2502.08762v2, Definition 1.3, Theorem 1.4, and
  Sections 7--9; cached SHA-256
  `2c1d25490d53d1eb04da11e4ad8eec2d9834b25e765462186181292e7f085cce`.
