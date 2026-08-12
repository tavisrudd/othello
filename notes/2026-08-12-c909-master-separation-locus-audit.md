# C909 — hostile audit of a marked Hecke-locus separation theorem

Date: 2026-08-12  
Status: bounded editorial/mathematical audit; no manuscript, PDF, mirror,
Lean, or commit change

## Verdict

**Conditional GO as a corollary; MAJOR if stated as an intrinsic unmarked
Hecke-locus theorem or if non-A5 nonemptiness is claimed.**

The clean statement is: let \(X\) be a smooth complex cubic threefold and
suppose its dimension-five principally polarized intermediate Jacobian
\((J(X),\Theta_X)\) is supplied with a *marked* polarized finite-etale graph
presentation \(E^5\dashrightarrow J(X)\) satisfying the exact local cofactor
saturation hypotheses. Then the marked presentation puts
\(\Theta_X^4/4!\) in the integral divisor-product lattice. Voisin's
Corollary 4.4 then gives universal \(CH_0\)-triviality. Independently, the
one-step quantum theorem already gives irrationality of \(X\times\mathbf P^1\)
for every smooth cubic. Their conjunction is a genuine separation corollary
on the intersection locus, but not a new quantum mechanism.

## 1. Exact hypotheses and the Voisin step

The phrase “\(J(X)\) lies in the finite-etale elliptic-power Hecke locus” is
safe only after fixing what the locus remembers. The hypothesis must include,
at minimum:

* \(g=5\), because \(J(X)\) is five-dimensional and the relevant class is
  the primitive minimal class \(\Theta_X^4/4!\in H^8(J(X),\mathbf Z)\);
* a complex elliptic curve \(E\), a polarized/isogeny presentation from
  \(E^5\), and the actual marked graph/kernel data, not only an unmarked
  assertion that the ppav is isogenous to a fifth power;
* the Rosati/self-adjoint graph conditions, finite-etale slope condition, and
  local cofactor-saturation theorem used to obtain ordinary integral
  divisor-product membership;
* the fact that the ppav is \(J(X)\), rather than an arbitrary point of
  \(\mathcal A_5\). The cubic intermediate-Jacobian/period locus must be
  intersected with the marked Hecke cover.

The existing geometric theorem proves exactly the final implication needed:
ordinary divisor products represent the primitive minimal class. Voisin's
Corollary 4.4, as recorded in the prior source check, says for a smooth
complex cubic threefold that algebraicity of this class is equivalent to
universal \(CH_0\)-triviality. A product of divisor classes is an algebraic
cycle class, so no extra Hodge-conjecture input is needed here. This is a
cubic-specific implication; the finite-etale saturation theorem for a
general elliptic-power ppav does not itself imply any \(CH_0\) statement.

## 2. Marked versus unmarked locus

The natural object is a marked cover/stack whose point records
\((E,\phi:E^5\to J(X),\Theta,\text{graph levels})\). A statement about a
chosen marked point is unambiguous and allows the local coefficient lattice
to be used. An unmarked image in \(\mathcal A_5\) is potentially ambiguous:
different presentations of the same ppav can have different product lattices
and different visible local graph packets.

An existential unmarked formulation can still be true:

> If there exists at least one marked finite-etale presentation over \(J(X)\)
> satisfying the hypotheses, then \(X\) is universally \(CH_0\)-trivial.

But the quantifier “there exists a marked lift” must be printed. Merely being
in an unspecified Hecke correspondence, or becoming such a point after an
uncontrolled field extension, does not state the algebraic divisor classes
used by the proof. The marked cover is therefore structural, even if the
conclusion descends to the underlying cubic.

## 3. What is and is not broadened

The A5 pencil supplies one nonempty marked component: its six elliptic
quotients and exotic two-primary graph give the required presentation for
every smooth member. This proves nonemptiness of the cubic-period/marked
locus, not nonemptiness of any further component.

No current argument supports “likely nonempty beyond A5.” A union of graph
Hecke loci can contain modular curves as \(E\) varies, but the cubic
intermediate-Jacobian locus has to meet those curves in the required marked
way. That intersection is special and is not supplied by dimension count;
the A5 family itself is evidence of special geometry, not a genericity
principle. Other components should be called an open direction unless a
second cubic family is exhibited.

Consequently the proposed theorem is material as a reusable cycle criterion
for any cubic whose *marked* intermediate Jacobian admits the presentation,
but it is not an Annals-level new classification of the Hecke locus. If the
condition is defined to be exactly “the cofactor saturation conclusion
holds,” the theorem becomes tautological. The useful non-tautological version
names the finite-etale graph hypotheses and derives saturation from them.

The product assertion is logically redundant under the current manuscript's
universal theorem:

\[
  \text{every smooth cubic }X\quad\Longrightarrow\quad X\times\mathbf P^1
  \text{ is irrational}.
\]

It should therefore be presented as “on this separation locus, the cycle
detector applies, while the independent universal quantum detector applies to
all cubics,” rather than as though the Hecke condition caused irrationality.
This gives a coherent two-arrow theorem, but not a unified invariant.

## 4. Dimension and editorial recommendation

The dimension-five restriction must occur in the theorem statement or its
setup. A general \(g\)-dimensional finite-etale graph theorem can be quoted
upstream, but \(g=5\) is where the cubic minimal class and Voisin criterion
match. The A5 pencil is one-dimensional in the cubic period image; it is a
verified component/example, not evidence that the full marked locus has a
large cubic subvariety.

Recommended packaging is a conditional “marked finite-etale separation
corollary” after the two independent main theorems. The current title
“Irrationality after One Stabilization” remains accurate for the epilogue;
turning the marked-locus packaging into a headline would require a precise
moduli definition and either a second component or a classification result.

## 5. One-depth defects for the cubic case

For one equal-depth finite-etale level \(p^a\) and \(g=5\), the low-corank
formula gives

\[
 Q^k:=\operatorname{Hdg}^{2k}/
 \operatorname{im}(\operatorname{Sym}^k NS)
 \cong
 \begin{cases}
 (\mathbf Z/p^a)^5,& k=2,3,\\
 0,& k=0,1,4,5.
 \end{cases}
\]

Indeed \(N_2=\binom54\binom1{k-2}\), while \(N_3=0\) for \(g=5\); hence
\(k=2\) gives five four-slot defects and \(k=3\) gives the Poincare-dual
five doubled-slot defects. The phrase “\(k=4\) symmetric” must not be read
as another \((\mathbf Z/p^a)^5\): codimension four is dual to codimension
one, so its quotient is zero. This is an ambient integral Hodge/product-
lattice defect, not a contradiction to the codimension-four minimal-class
theorem; the latter says the distinguished class \(\Theta^4/4!\) lies in the
product lattice even though other Hodge/product quotients occur in
codimensions two and three.

These defect groups require the marked equal-depth graph theorem and faithful
flat descent. They do not by themselves realize a cubic period point or
produce universal \(CH_0\)-triviality.

## Bottom line

Use the theorem conditionally and marked:

\[
  J(X)\text{ has a marked finite-etale graph presentation}
  \Rightarrow \Theta_X^4/4!\text{ is an integral divisor product}
  \Rightarrow X\text{ is universally }CH_0\text{-trivial},
\]

and append \(X\times\mathbf P^1\) irrational by the already universal
one-step theorem. State the A5 pencil as the verified nonempty component;
leave further components open. Any stronger unmarked/classificatory or
causal “Hecke condition implies irrationality” wording is MAJOR overreach.
