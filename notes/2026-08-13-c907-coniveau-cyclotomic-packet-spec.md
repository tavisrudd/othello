# C907 coniveau cyclotomic packet specification

**Lane:** `clebsch`

**Status:** candidate construction target extracted from the divisorial
support-square theorem.  Ordinary coniveau provides every required support
operation; the single nonformal datum is a quantum \(\Phi _6\) coefficient
system compatible with that coniveau module.

## Required object

Seek a functor \(Y\mapsto\mathcal C_6(Y)\) from smooth projective varieties
and supported perfect kernels to finite filtered
\(K=\mathbf Q(\zeta _6)\)-complexes, with filtration

\[
 F^c\mathcal C_6(Y)
 =\langle\text{classes supported in codimension at least }c\rangle.
 \tag{1}
\]

It should be a module over rational \(K_0(Y)\), exact for localization, and
carry proper Gysin and perfect pullback maps.  Tensor by a line bundle \(L\)
then defines \(N_L=1-\tau_L\), and the gamma filtration gives

\[
 N_LF^c\subset F^{c+1},\qquad
 N_L^2=(-)\otimes\mathbb Lf^*\mathcal O_q
 \tag{2}
\]

for \(L=f^*\mathcal O_{\mathbf P^2}(1)\).  Formula (2), localization, and
dimension vanishing are exactly the point-kernel axioms consumed by the
divisorial support-square theorem.

The quantum datum is a natural identification

\[
 H^*(\mathcal C_6(Y))
 \cong E_{\zeta _6}(Y),
 \tag{3}
\]

with the whole generalized \(\zeta _6\)-primary formal solution packet,
commuting with tensor, Orlov maps, projective bundles, and Tate shifts.
Defining the filtration directly on the formal eigenspace by summing images
from supported \(\zeta _6\)-packets is circular: those supported packets,
their localization/Gysin maps, and kernel compatibility are precisely the
unknown construction.  Coniveau packages the answer; it does not extract it
from a global QDM eigenspace.

## Endpoint normalization

For a cubic threefold \(X\), require

\[
 \mathcal C_6(X)\cong K
 \tag{4}
\]

in coniveau zero.  Projective compatibility then gives

\[
 \mathcal C_6(X\times\mathbf P^2)
 \cong K\otimes K_0(\mathbf P^2)_{\mathbf Q},
 \tag{5}
\]

and \(1-\tau_{\mathcal O(1)}\) is the endpoint \(J_3\).  For any support of
dimension at most two, require \(\mathcal C_6=0\), matching the closed formal
vanishing theorem.

## Why ordinary candidates do not yet work

1. **Rational \(K_0\)** has localization and kernel action, but no canonical
   \(\zeta _6\) quantum projector; linear projection even contains a raw
   \(J_3\) which the desired cyclotomic functor must remove.
2. **The formal QDM eigenspace** has the correct \(\zeta _6\) packet, but no
   supported-category localization, perfect-kernel action, or Gysin
   devissage.
3. **The cubic Kuznetsov component** detects the correct residual geometry,
   but its Serre/cyclotomic projector is mutation-dependent and is not known
   to commute with arbitrary Orlov component maps or supported localization.
4. **A birational motive alone** kills lower support, but forgetting the
   coniveau filtration makes tensor by a line bundle trivial at the generic
   point and loses the endpoint \(J_3\).
5. **The relative support quotient**
   \(\operatorname{Perf}(Y)/\operatorname{Perf}_{\dim\le2}(Y)\) is the
   closest honest categorical host: it is localizing, kernel-linear, and
   kills low support by definition.  But on \(\mathbf P^5\) its rational
   \(K_0\) is \(K_0/F^3\cong\mathbf Q[x]/(x^3)\),
   \(x=1-[\mathcal O(1)]\).  It retains a raw \(J_3\) instead of vanishing
   and has no formal-monodromy \(\Phi _6\) operator.

There is also a clean spectrum no-go for ordinary categorical Serre data.  On
a smooth \(Y\), the full Serre action on rational numerical \(K\)-theory is

\[
 (-1)^{\dim Y}\tau_{\omega_Y}.
\]

Tensor by any line bundle is unipotent under the Chern character, so this
operator has spectrum only \(\{1,-1\}\).  Its \(\Phi _6\)-projector is zero,
including at the endpoint.  Extending scalars to \(\mathbf Q(\zeta _6)\) or
adding an external character remains nonzero on projective spaces and
surfaces, violating low-dimensional vanishing.  The cubic residual Serre
spectrum arises only after mutation through a chosen Lefschetz frame; that
choice is precisely what lacks support-local functoriality on graph
resolutions.  It also fails low-support vanishing concretely: on a cubic, a
point class cannot lie in the span of \(\mathcal O\) and \(\mathcal O(H)\),
since rank and first Chern class force both coefficients to vanish.  Its
projection to the residual component is therefore nonzero despite its
zero-dimensional support.

Thus the desired object is not one of these ingredients separately.  It is a
new **framed localizing quantum motive**: a quantum coefficient system on a
full coniveau/localization module.

The word *relative* is essential.  A global tensor-ideal quotient of
localizing noncommutative motives killing all categories of dimension at
most two kills \(\operatorname{Perf}(\mathrm{pt})\), the monoidal unit, and
therefore collapses the entire tensor theory.  The support quotient must be
formed relative to each ambient \(Y\), as in item 5, before the framed quantum
coefficient is extracted.

## Minimum construction theorem

A construction of \(\mathcal C_6\) satisfying:

1. localization and \(K_0\)-kernel linearity;
2. zero on all supports of dimension at most two;
3. Orlov additivity with actual component maps;
4. projective formula (5); and
5. the formal comparison (3)

would, by the divisorial support-square theorem and relative positive
Krull--Schmidt telescope, prove \(X\times\mathbf P^2\) irrational.

No directed Stokes marking or integral pairing is required at this stage.
The difficult step is (3): promoting the numerical formal-monodromy sector
to a support-local coefficient system rather than merely an eigenspace.

## EJ/TT and mystery ledger

- **EJ:** all geometric operations needed by Silver already exist in
  coniveau-filtered \(K\)-theory; only the \(\Phi _6\) coefficient extraction
  is absent.
- **TT:** neither a generic-point birational motive nor a finite-dimensional
  QDM projector is enough.  The endpoint uses three coniveau levels and the
  proof uses localization between them.
- **Settled:** the exact axioms, endpoint normalization, and failure mode of
  each obvious candidate.
- **Open:** construct the quantum coefficient system (3), most plausibly via
  a support-compatible Stokes/Gamma realization or a functorial
  noncommutative-motive refinement.
