# C909 — marked finite-etale Hecke separation and modular-resolvent audit

Date: 2026-08-12  
Status: bounded unity/editorial audit; no manuscript, PDF, mirror, Lean, or
commit change

## Verdict

The strongest honest formulation is a **marked separation-stack theorem**
with a finite graph-packet cover. It is mathematically non-tautological if
the stack is defined by the finite-etale, Rosati/self-adjoint graph data and
the cofactor conclusion is derived from those hypotheses. It is not an
intrinsic theorem about an unspecified Hecke image, and it is not by itself
an Annals-level classification or a source of further cubic components.

The modular-resolvent language is useful only in the following precise sense:
the finite set of admissible graph slopes gives a finite-etale algebra/cover
over a fixed-level modular Hecke stack. At the A5 two-primary packet this
cover has the \(3+2\) rational/exotic decomposition, with the exotic part a
quadratic Frobenius/orientation cover. No explicit scalar polynomial or
global Eisenstein resolvent is presently proved, so “resolvent” should mean
this finite-etale algebra, not a claimed modular equation.

## 1. The clean stack-level theorem

Fix finite graph data \(\tau\): a finite list of primes and depths, a level
type on the source elliptic curve, and a self-adjoint finite-etale graph slope
at each local block (or a finite list of allowed slopes). Over \(\mathbf C\),
where the relevant torsion is etale, define the marked stack
\(\mathscr H_\tau\) to parametrize
\[
 (E,A,\lambda_A,\phi),\qquad
 \phi:(E^5,p^a\lambda_{E^5})\longrightarrow(A,\lambda_A),
\]
with \(\ker\phi\) the marked maximal-isotropic graph specified by \(\tau\).
For one \(p^a\)-block the polarization identity is
\(\phi^*\lambda_A=p^a\lambda_{E^5}\) in the usual similitude notation.
For several coprime local blocks one uses the corresponding iterated
prime-to-prime correspondence, retaining each local condition separately;
no single common-depth equation is intended. Quotienting the universal
elliptic fifth power by the finite graph subgroup constructs the universal
\(A\) and its principal polarization.

Let \(\mathscr C\) be the smooth cubic-threefold stack and
\[
 \mathcal J:\mathscr C\longrightarrow\mathcal A_5
\]
its intermediate-Jacobian period map. Define
\[
 \mathscr S_\tau=\mathscr C\times_{\mathcal A_5}\mathscr H_\tau.
\]
Its points remember a cubic, a marked presentation of \(J(X)\), and the
graph data used in the integral calculation. The honest separation theorem
is:

> For every complex point of \(\mathscr S_\tau\) satisfying the established
> finite-etale cofactor hypotheses, \(\Theta_X^4/4!\) lies in the ordinary
> integral divisor-product image. Hence \(X\) is universally
> \(CH_0\)-trivial by Voisin. Independently, \(X\times\mathbf P^1\) is
> irrational by the universal one-step theorem for smooth cubics.

This is not circular: “finite-etale graph, self-adjoint slope, and marked
polarized quotient” are input conditions; the rank-one/cofactor theorem is
the derived output. Conversely, if the stack is defined by requiring
\(\Theta^4/4!\) to be a divisor product, the resulting theorem is tautology
and should not be advertised.

The existential unmarked corollary is valid only with its quantifier:
if \(J(X)\) admits at least one lift to \(\mathscr H_\tau\), then the cycle
conclusion descends to \(X\). The underlying ppav need not carry a canonical
choice of lift or product lattice.

## 2. Constructibility and component claims

At fixed \(\tau\), \(\mathscr H_\tau\) is an algebraic stack of finite type
over a finite level cover of the modular curve. With full level structure the
graph subgroup is a finite etale subgroup scheme and the quotient abelian
scheme is algebraic. Removing CM fibres and imposing the regular-semisimple
finite-etale slope is an open condition. Thus \(\mathscr H_\tau\) and
\(\mathscr S_\tau\) are constructible finite-type objects after the indicated
open restrictions.

The image in \(\mathcal A_5\) is constructible by Chevalley. It should not be
called a closed Hecke subvariety without taking a compactification/closure
and controlling boundary points. Allowing all primes, depths, and slopes
produces a countable union of such constructible images, not one finite-type
algebraic locus. Every component assertion must therefore carry fixed data
\(\tau\), or explicitly refer to an irreducible component of a chosen
closure.

For fixed graph data the source has modular dimension at most one (the
elliptic modulus; level and graph choices are finite). If the A5 pencil lifts
algebraically and nontrivially to \(\mathscr H_\tau\), its one-dimensional
image is a genuine component of \(\mathscr S_\tau\), provided the fixed-data
stack has no higher-dimensional source. This is the honest meaning of “the
A5 pencil supplies a component.” The current fibrewise geometric packet
supports this lift, but a printed component claim still requires the
universal elliptic quotient, graph subgroup, and map to \(\mathscr H_\tau\)
to be constructed over the base. It does not imply another component exists.

The period map's local embedding and the verified non-isotriviality of the
A5 family support the expected dimension once that lift is printed. They do
not by themselves imply that a generic modular Hecke curve meets the cubic
period image, nor that the countable union of all such curves has any
additional cubic component.

## 3. The finite modular resolvent

For the unmarked presentation data, let
\[
 \pi:\mathscr G_\tau\longrightarrow\mathscr H_\tau^{\mathrm{un}}
\]
be the finite-etale cover parametrizing admissible marked graph slopes. A
marked presentation stack \(\mathscr H_\tau\) is a chosen component or
finite cover of \(\mathscr G_\tau\), and is the object used in the fibre
product \(\mathscr S_\tau\) above.
Equivalently, use the finite locally free algebra
\(\mathscr R_\tau=\pi_*\mathcal O_{\mathscr G_\tau}\). This is the
chart-independent modular-resolvent object. A choice of a graph is a
section after passing to the corresponding cover; forgetting the choice is
the finite quotient.

In the A5 two-primary chart the geometric fibre is
\[
 \mathbf P^1(\mathbf F_4)
   =\mathbf P^1(\mathbf F_2)\sqcup\{\omega,\omega^2\}.
\]
The first part consists of the three rational graph choices and the latter
part is the exotic degree-two Frobenius/orientation packet. The degree-two
piece is the only “resolvent” needed by the cycle proof: it records the
unordered exotic pair, while a marked golden orientation selects one member.
The current evidence does not supply a canonical global polynomial whose
roots are these five choices, nor a global \(\mathbf Z[\zeta_3]\)-resolvent.

This packaging makes the architecture inevitable in a limited but honest
sense. The graph-packet cover is exactly the finite data needed by the cycle
detector; the quantum detector is a separate invariant on all cubic points.
Their common domain is the fibre product \(\mathscr S_\tau\), not a common
packet or common monodromy representation.

## 4. Hecke terminology and editorial strength

Calling \(\mathscr H_\tau\) a “Hecke locus” is defensible only after defining
the polarized similitude/isogeny correspondence. An arbitrary ppav merely
isogenous to \(E^5\), or an unspecified union of standard Hecke
correspondences, does not remember the graph slope, its self-adjoint form, or
the divisor lattice used in the proof. “Marked finite-etale elliptic-power
presentation stack” is safer in a theorem statement; “Hecke” can be a
parenthetical moduli interpretation.

As an editorial package, the stack theorem is a strong organizing corollary:
\[
\text{marked graph presentation}
\Rightarrow \text{integral minimal class}
\Rightarrow \text{universal }CH_0,
\qquad
\text{all smooth cubics}\Rightarrow X\times\mathbf P^1
\text{ irrational}.
\]
It cleanly explains why the A5 cycle family and universal quantum result meet
without claiming they arise from one invariant.

It is not, by itself, a new Annals headline. A top-tier upgrade would require
one of the following additional results: a classification of the fixed-data
intersection with the cubic period locus; a second explicitly constructed
cubic component; or a genuine modular resolvent equation/monodromy theorem
with consequences beyond the already proved A5 family. None is currently in
hand. The current epilogue should retain its existing title and use this as a
structural corollary or future perspective, not replace the headline spine.

## Bottom line

State a fixed-\(\tau\), marked fibre-product theorem and call the finite
graph-choice algebra a modular resolvent. State the A5 pencil as one verified
one-dimensional geometric family, and call it a component of a fixed-\(\tau\)
stack only after the algebraic lift is printed. Keep the all-depth union
constructible/countable, keep further components open, and keep the cycle and
quantum detectors separate. This is the strongest non-tautological unity
statement supported by the present proofs.
