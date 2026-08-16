# C909 — Minimal graded measure for the \(\mathbf P^2\) obstruction

**Date:** 2026-08-11  
**Lane:** `clebsch`  
**Status:** bounded algebraic extraction; no manuscript, PDF, mirror, Lean edit, or commit.

## Verdict

Among graded polynomial targets that retain distinct position degrees, the
weakest useful target is a truncated graded atom module

\[
 \mathsf T_2[\mathcal A],
 \qquad \mathsf T_2:=\mathbf Z\oplus\mathbf ZL\oplus\mathbf ZL^2,
 \qquad \mathcal A=\operatorname{Atoms}^{K}_G,
 \tag{C909.13}
\]

viewed as the degree-at-most-two quotient of a `Z[L]`-module, with one new
shift \(L\) recording an integral/Rees position. It need not
retain all Tate degrees, Euler branches, or a full Serre operator.  For the
\(m=2\) endpoint it must retain only the first three positions and preserve
the nonzero extreme class

\[
 (1+L+L^2)e_{\alpha}\notin L\mathbf Z e_{\alpha}.
 \tag{C909.14}
\]

Here \(e_\alpha\) denotes the cubic-isotypic generator.  The minimal formulas
are

\[
\begin{aligned}
 \widetilde{\operatorname{CF}}(\mathbf P_Y(E))
   &= (1+L+\cdots+L^{R-1})
      \widetilde{\operatorname{CF}}(Y),\\
 \widetilde{\operatorname{CF}}(\operatorname{Bl}_Z Y)
   &= \widetilde{\operatorname{CF}}(Y)
      +(L+\cdots+L^{c-1})
       \widetilde{\operatorname{CF}}(Z),
\end{aligned}
\tag{C909.15}
\]

in \(\mathsf T_2[\mathcal A]\), where \(R\) is the projective-bundle rank and \(c\)
is the blowup codimension. Terms of degree at least three vanish only because
we project a full graded object to its first three coefficient groups. There
is no ring augmentation `L -> 1` on this truncated target; ordinary chemical
formula is recovered only from the untruncated object before projection.

Condition (C909.15) plus one precise threefold carrier bound gives a formal
weak-factorization contradiction, with no analytic realization needed in that
last deduction.  The missing analytic work is exactly the construction of a
presentation-independent enriched \(\widetilde{\operatorname{CF}}\) satisfying
these formulas and the carrier bound; ordinary KKPYY atoms do not supply it.

## Minimal axioms

Fix a smooth cubic threefold \(X\) and its primitive-sixth-root atom
\(\alpha=\alpha_X\).  A **\(P^2\)-graded measure for \(\alpha\)** consists of
an assignment

\[
 \widetilde{\operatorname{CF}}(Y)
   \in \mathsf T_2[\mathcal A]
\]

for every smooth projective \(K\)-variety \(Y\), together with the following
axioms.

**(G1) Strict graded formulas.**  The two identities (C909.15) hold for every
smooth projective \(Y\), every smooth center \(Z\subset Y\) of codimension
\(c\ge2\), and every rank-\(R\ge2\) vector bundle \(E\to Y\).  The identities
are equalities in the graded target, not just after setting \(L=1\).

**(G2) Endpoint normalization.**  The \(\alpha\)-isotypic component of the
carrier is \(e_\alpha\) in degree zero:

\[
 [\alpha]\widetilde{\operatorname{CF}}(X)=e_\alpha,
 \qquad \pi_0(e_\alpha)\ne0,
 \qquad (1+L+L^2)e_\alpha\notin L\mathbf Z e_\alpha.
 \tag{C909.16}
\]

The notation \([\alpha]\) means projection to the \(\alpha\)-summand of the
free atom module; it is not a new abstract atom class.

**(G3) Low-carrier exclusion.**  For every smooth projective variety \(W\) of
dimension at most two,

\[
 [\alpha]\widetilde{\operatorname{CF}}(W)=0.
 \tag{C909.17}
\]

For the cubic primitive-sixth-root atom this is the already established
point/curve/surface exclusion.  A weaker statement involving support bounds
would be possible, but (C909.17) is the clean hypothesis available from C907.

**(G4) Threefold carrier width.**  For every smooth projective threefold \(W\),

\[
 [\alpha]\widetilde{\operatorname{CF}}(W)\in\mathbf Z e_\alpha
 \subset \mathsf T_2e_\alpha.
 \tag{C909.18}
\]

Thus a threefold can carry the cubic atom, but only in the normalized
degree-zero level. This is stronger than the length bound
\(\ell_{1/6}(W)\le1\), since a length-one block could still be shifted. It
does not assert that \(W\) is Fano or that its
quantum module is a rank-two global subobject.

No positivity of coefficients is needed in (G4): weak factorization reverses
some blowups, so the formal ledger is a signed sum.  Torsion-freeness of the
degree-zero coefficient in \(\mathsf T_2\) is enough.

## Formal obstruction theorem

**Theorem (conditional graded-measure obstruction).**  Assume (G1)--(G4).
Then \(X\times\mathbf P^2\) is not birational to \(\mathbf P^5_K\).

**Proof.**  Apply the projective-bundle formula to the trivial rank-three
bundle over \(X\).  By (G2), the cubic-isotypic endpoint is

\[
 [\alpha]\widetilde{\operatorname{CF}}(X\times\mathbf P^2)
   =(1+L+L^2)e_\alpha.
 \tag{C909.19}
\]

Suppose instead that \(X\times\mathbf P^2\) is rational.  Weak factorization
of a birational map from \(\mathbf P^5_K\) to \(X\times\mathbf P^2\) uses smooth
centers of dimension at most three.  The projective-space starting term has no
\(\alpha\)-component: it is built from the point atom, which is excluded by
(G3).

For a center of dimension at most two, (G3) makes its contribution zero.  A
threefold center has codimension exactly two in the fivefold ambient variety,
so (C909.15) and (G4) make its contribution

\[
 L\,[\alpha]\widetilde{\operatorname{CF}}(W)
   \in L\mathbf Z e_\alpha.
 \tag{C909.20}
\]

The same support statement holds with a minus sign when the factorization
step is read as a blowdown.  Telescoping the factorization therefore forces
the final cubic component to lie in \(L\mathbf Z e_\alpha\).  But (C909.19)
has nonzero constant and \(L^2\) coefficients, and (C909.14) says it is not in
that subgroup.  This contradiction proves the theorem. \(\square\)

The proof is entirely algebraic after (G1)--(G4) are granted.  It uses only
weak factorization, the strict graded identities, and the support gap.  It
does not use a Stokes decomposition, a Gamma integral structure, or an
analytic continuation argument.

## Why \(\mathsf T_2\) is the minimal universal graded test target

In the untruncated graded object, forgetting degree via `L -> 1` makes the
endpoint polynomial and a center contribution ordinary copy counts. At
\(\mathsf T_2\), the endpoint is \(1+L+L^2\), while every
threefold codimension-two center contribution is in \(L\mathbf Z\).  Thus the
first three graded positions are exactly what the P2 contradiction tests.

More formally, let \(M\) be any \(\mathbf Z[L]\)-module receiving an enriched
measure and let \(v=e_\alpha\).  If

\[
 (1+L+L^2)v\notin L\mathbf Z v,
 \tag{C909.21}
\]

then the same proof works after mapping \(\mathsf T_2e_\alpha\) to \(Mv\), provided
the image of the degree-one subgroup remains the designated center subgroup.
If this subgroup separation fails, no \(\mathbf P^2\) extreme-term
contradiction can be read from that target. Therefore \(\mathsf T_2\) is the
universal free finite support truncation for this
particular obstruction among degree-faithful graded targets; a full Rees or
Stokes target is stronger but not algebraically necessary once (G1)--(G4) are
known.

If one permits arbitrary non-graded quotients, smaller targets can collapse
the shift (for example, a module on which \(L\) acts by zero).  Such a target
does not retain a carrier position and would make the analytic realization
strictly stronger: it would kill every exceptional shift while still having
to satisfy all blowup identities.  It is therefore not an enriched graded
carrier invariant in the sense needed here.

The target need not be a free module on every atom if only the cubic summand is
being tested.  The one-dimensional \(\mathsf T_2e_\alpha\) quotient is enough.  A
global invariant should nevertheless retain all atom summands until the
projection to the cubic component is proved functorial.

## What analytic realization C907 must supply

The conditional theorem isolates the exact analytic obligations.  They are
not additional algebraic steps in the proof above.

1. **Construction.**  Produce a presentation-independent cubic-isotypic
   graded/Rees object whose associated graded gives
   \(\widetilde{\operatorname{CF}}(Y)\).  A local \(q\)-adic lattice at one
   blowup boundary is evidence for this object but is not yet an invariant of
   \(Y\).
2. **Strict formulas.**  Lift Iritani/KKPYY's formal direct-sum formulas to
   the graded object, with the exceptional powers \(L,\ldots,L^{c-1}\), and
   prove compatibility under composed weak-factorization moves.  Equality only
   after forgetting \(L\) gives the old atom formula and cannot prove the
   theorem.
3. **Carrier bound.** Prove the arbitrary smooth threefold statement (G4),
   including both the cubic-isotypic width bound and its common degree-zero
   placement. This includes Calabi--Yau and general-type centers;
   a Fano-only census is insufficient.
4. **Strictness against extensions.**  Ensure that semiorthogonal/Stokes
   extensions cannot join several degree-one center pieces into the endpoint
   block of length three.  Preserving only Euler or Serre data does not imply
   this associated-graded support statement.
5. **Comparison and gluing.**  Identify the residual center mutation system
   with the center's enriched quantum/Stokes object and make the comparison
   strict through weak factorization.  This is the analytic Gamma/Stokes gate
   in C907, not a consequence of the formal KKPYY atom equivalences.

The algebraic theorem therefore lowers the target: C907 does not need a full
classification of all enriched atoms to obtain the P2 contradiction.  It needs
only the three-level quotient \(\mathsf T_2e_\alpha\), strict formulas on that quotient,
and the normalized threefold carrier bound. Constructing even this quotient
canonically is the unresolved analytic task.

## `ej` + `tt` closeout / mystery ledger

The cheap upgrade is the explicit finite support target
\(\mathsf T_2=\mathbf Z\oplus\mathbf ZL\oplus\mathbf ZL^2\), which
separates the endpoint extremes without committing to a full Stokes
category.  The hostile checks were:

* codimension-two threefold centers contribute exactly \(L\) times their
  intrinsic degree-zero class;
* centers of dimension at most two vanish in the cubic component, so no hidden
  \(L^0\) or \(L^2\) contribution enters the weak-factorization ledger;
* signed blowdown terms remain in \(L\mathbf Z e_\alpha\); positivity is not
  being assumed;
* \(\mathsf T_2\) is only a universal test quotient.  The existence and strictness of
  the measure remain analytic questions.

Settled: a minimal conditional algebraic obstruction and the exact four
analytic inputs it requires.  Remaining mystery: whether C907's Gamma/Stokes
construction supplies (G1)--(G4) presentation-independently.  No further C909
source search is justified by this pass.

## Source pinpoints

The KKPYY source boundary is recorded in
`notes/2026-08-11-c909-enriched-carrier-no-go.md`.  The C907 analytic target
and its exclusions are in
`notes/2026-08-10-c907-quantum-monodromy-stabilization.md` and
`notes/cubic-threefolds-tasks/c907-solver-dossier.md`.
