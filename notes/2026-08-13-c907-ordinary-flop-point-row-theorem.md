# C907 — ordinary-flop point-row theorem

Date: 2026-08-13

Status: exact C907 theorem.  Every projective ordinary flop preserves the
primitive-sixth Gamma rank Boolean.  LLW's quantum-connection continuation is
enough for this distinguished row even though it does not prove the full
Gamma/Fourier--Mukai square: at transverse Novikov degree zero the
off-exceptional point column is exactly classical for all values of the
extremal variable, and a divisor recursion kills every positive transverse
coefficient.

This closes the surface-family `P^1` flop row in the Gold fivefold portfolio.
Chen--Tseng's advertised full ordinary-flop Gamma theorem remains a valuable
publishable strengthening, but is no longer required for the rank Boolean.

## 1. Setup and common coefficient ring

Let `f:Y dashrightarrow Y'` be a projective ordinary flop with graph
correspondence `F:H^*(Y)->H^*(Y')`.  Let `ell,ell'` be the effective extremal
fibre classes, so `F(ell)=-ell'`.  LLW prove that, after analytic continuation

\[
 q'=q^{-1},                                           \tag{1}
\]

the graph correspondence identifies the big quantum products, Poincare
pairings, and therefore quantum connections.  It is analytic in `q` and
formal in every other Novikov variable.

Let `B` be the common contraction.  Choose an ample divisor `A` on `B` and
write `D=f_Y^*A`, `D'=f_{Y'}^*A`.  Then `D.ell=D'.ell'=0`, and `D` is positive
on every effective class not on the extremal ray.  Grade the transverse
Novikov completion by `D.beta`; its degree-zero part consists exactly of the
extremal series in `q`.

## 2. Exact point column at transverse degree zero

Choose `y` in the common open complement of the exceptional loci and let
`y'` be the corresponding point.  Every nonconstant stable map of pure
extremal class is contained in the exceptional locus.  Hence every genus-zero
descendant invariant in a nonzero extremal class with insertion `[y]`
vanishes.  Consequently the intrinsic large-radius Gamma point flat section,
restricted to transverse Novikov degree zero, is exactly its classical
column for every nonsingular `q`:

\[
 s^{Y}_{y}|_{Q_\perp=0}=z^{-\mu}[y],
 \qquad
 s^{Y'}_{y'}|_{Q_\perp=0}=z^{-\mu}[y'].             \tag{2}
\]

The Gamma and `z^rho` factors act trivially on top degree apart from the
common scalar normalization.  The graph correspondence is the identity on
the common open, so `F[y]=[y']`.  Thus the analytically continued source
point section and target large-radius point section agree in transverse
degree zero.  No two-point descendant invariance theorem is inferred from
LLW; the column is computed directly by support.

## 3. Divisor recursion kills the transverse tail

Put

\[
 \delta=F(s_y^Y)-s_{y'}^{Y'}
\]

in the common analytically continued connection.  Both terms are jointly
flat and Section 2 gives `delta|_{Q_perp=0}=0`.

Suppose `beta` has minimal positive `D`-degree with nonzero coefficient
`delta_beta`.  Horizontality for the Novikov derivation defined by `D` gives

\[
 \left((D.\beta)\operatorname{id}
       +z^{-1}(D\star_q-)\right)\delta_\beta=0.     \tag{3}
\]

At transverse degree zero, the only quantum corrections to `D star_q` have
pure extremal degree.  The divisor axiom multiplies them by `D.ell=0`; hence
`D star_q=D cup`.  Cup product by a positive-degree divisor is nilpotent.
Since `D.beta>0`, the operator in (3) is invertible over `C((z))`.  Thus
`delta_beta=0`, a contradiction.  Induction gives

\[
 \boxed{F(s_y^Y)=s_{y'}^{Y'}}.                      \tag{4}
\]

The recursion is coefficientwise in the transverse completion and assumes
no convergence there.

## 4. Primitive-sixth rank consequence

LLW's graph gauge is independent of `z`, preserves grading and first Chern
class under K-equivalence, and intertwines the quantum connections.  It
therefore transports the full `z=0` formal type and total generalized
primitive-sixth packet.  It also preserves the Poincare pairing.  Equation
(4) identifies the Gamma point row, whose Euler pairing is ordinary rank
with the standard dimension sign.  Hence

\[
 \boxed{
 \mathfrak r_Y|_{P_6(Y)}\ne0
 \quad\Longleftrightarrow\quad
 \mathfrak r_{Y'}|_{P_6(Y')}\ne0.}                 \tag{5}
\]

This is path-local on any LLW continuation domain avoiding its poles.  The
endpoint point columns select the same branch by (2), so no independent
phase-invariance assertion is used.

## 5. Scope

The proof applies to every projective ordinary flop in LLW's theorem,
including `P^1`-bundle flops over surfaces, `P^2` flops over points, finite
disconnected ordinary flops sharing one extremal ray, and the Geiser middle
flop after product with `P^2`.

It does not prove the full identity
`U Psi(E)=Psi(FM(E))` for arbitrary K-classes.  For those columns pure
extremal maps need not miss the support, so Section 2 fails.  Chen--Tseng's
full Gamma/FM extension remains genuinely stronger.  It also does not treat
discrepant flips, where center summands enter.

## EJ / TT / AA

- **EJ:** the point column is exceptional because pure flop curves cannot
  meet an off-exceptional point; this supplies the boundary value for a
  one-line divisor recursion.
- **TT:** LLW ancestor invariance still does not imply descendant invariance.
  Equation (4) is a support-plus-flatness theorem for one column only.
- **AA:** with ordinary flops closed, attack the nonprimitive weighted
  `(1,2)` curve flip; no further crepant peak analysis is needed for Gold.

## Sources

- Lee--Lin--Qu--Wang, arXiv:1401.7097, Theorem 0.1.1 and Sections 1.2--1.3;
  cached SHA-256
  `eeb1d87ae279a04c0ce5e9df66ce820aa87443fa6494f21d24269891a905b19c`.
- The support vanishing and divisor recursion are the derivation of this
  note.
