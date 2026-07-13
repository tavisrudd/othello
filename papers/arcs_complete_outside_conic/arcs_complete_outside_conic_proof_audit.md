# Proof and claim audit

## Analytic claims proved in the paper

1. The first and second secant-index equations are proved by direct double counting and identified as classical.
2. The prescribed-hole defect formula is an exact identity, not an estimate:
   \[
   m\Delta_H(A)=
   \sum_{x\in X_H(A)}(r(x)-1)(m-r(x))+
   \sum_{y\in H}r(y)(m-r(y)).
   \]
3. Coverage, uncovered-locus, equality, and quantitative stability statements are immediate corollaries of the exact identity.
4. For an arbitrary prescribed hole set of size \(h\), completeness gives the corrected capacity
   inequality with required-locus size \(q^2+q+1-k-h\). The conic specialization uses only
   \(|C|=q+1\).
5. The additive lower bound is obtained from the parity-free necessary inequality
   \[
   q^2-k\le \frac{k-1}{2}\bigl(k(q-1)-(k-2)(k-3)\bigr),
   \]
   giving the explicit finite statement
   \(k\ge\sqrt{2q}+3/2-8/\sqrt{2q}\) and hence the asymptotic result.
6. The upper-bound transfer is an averaging argument over \(\operatorname{PGL}(3,q)\): an ordinary
   complete \(b\)-arc can be moved off any prescribed \(H\) when \(b|H|<q^2+q+1\).
7. The even-characteristic statements use only the standard nucleus/tangent facts for a
   nonsingular conic; combining the nucleus-in/out cases gives \(I_C(A)\ge1\) universally.

## Computer-assisted claims

The supplementary verifier checks explicit upper-bound witnesses for
\(q=8,9,11,16\). It enumerates the whole projective plane, checks the conic,
arc condition, relative coverage, and both classical moment equations.

The lower bounds for \(q=8,9,11\), and the preliminary lower bound eight at
\(q=16\), are analytic. The exact value \(\rho_C(16)=9\) additionally uses an
exhaustive projective classification of eight-arcs.  The source
`search_rhoc16.cpp` reports 2633 frame-normalized classes.  Its Lean output
does not trust canonical labels: each augmentation is checked by an explicit
invertible projective matrix and pointwise scalar equalities.  At every leaf,
kernel-checked ordinary-uncovered points either give a full-rank six-row
quadratic evaluation matrix (2630 leaves), or force the unique rank-five
quadratic to hit the arc (three leaves).  The semantic proof transports this
rejection to arbitrary eight-arcs and arbitrary nonsingular conics.

The total of 2633 projective eight-arc classes is not a new classification
claim: it independently reproduces Theorem 3.8.1 of Al-Seraji--Al-Ogali
(2018). The additional computation partitions those known ordinary classes
by a different invariant: 2630 full-rank ordinary-uncovered quadratic
evaluation systems and three rank-five systems forced to meet the arc.

The classification proves a statement strictly stronger than the conic application: for every
eight-arc in `PG(2,16)`, no nonzero homogeneous quadratic, singular or nonsingular, contains its
entire ordinary-uncovered locus while avoiding the arc. Projective invariance is explicit:
normalizing by `g` replaces a form `Q` by `Q ∘ g⁻¹`, preserves nonzeroness, transports zero sets,
and carries the ordinary-uncovered locus bijectively. Lean checks the stronger alternative for
every canonical leaf; the already formalized global reduction checks the full conic corollary.

The manuscript now isolates the underlying linear-algebra argument as the
general uncovered-evaluation obstruction: injective evaluation on the
uncovered locus, or a selected evaluation functional in the span of the
uncovered evaluations, excludes a zero locus that contains the former and
avoids the latter. The quadratic certificate is its degree-two instance.
The displayed factorizations of the two singular exceptional forms and the
seven-point incidence of the nonsingular exception are direct `GF(16)`
arithmetic descriptions; classification completeness does not depend on
them.

For the (q=11) witness, the verified value (I_C=0) implies that all 15
secants are exterior to the conic. Completeness, the maximum index three, and
the two moment equations then force the required-point index counts
((N_1,N_2,N_3)=(90,15,10)).

The auxiliary q=11 residual-game remark is separately machine checked in
`RelativeConicArcs/Q11Residual.lean`: kernel reduction verifies that all twelve conic parameters
are initially live and that their determinant-defined conflict graph is the 30-edge, degree-five
icosahedral graph. The P-value conclusion uses the generic proved antipodal conflict-graph mirror
theorem, not an exhaustive game-tree evaluator. This result is not used by the paper's bounds.

Verifier SHA-256:

`e9508958d604e68c6c3d09fd3afadfaa8a3126508a51f1dfa993e7a7aed5d36a`

The exact-search report is frozen separately as `search_rhoc16_output.txt`;
the source and report hashes are recorded in `lean/RelativeConicArcs/TRUST.md`.

## Lean formalization

The standalone `lean/RelativeConicArcs/` package formalizes the theorem chain and the four finite
certificates. In particular, it proves the arbitrary-hole capacity theorem, the generic
projective-averaging transfer, the explicit additive lower bound, and the universal
even-characteristic incidence loss. Its generic Boolean checker verifies conic disjointness, the arc
condition, and coverage on the (q^2+q+1) canonical projective representatives; `check_sound`
proves that acceptance implies semantic relative completeness. The accepted coordinate list need
not be normalized or duplicate-free.

The aggregate builds successfully. No proof uses `sorry`, `admit`, a custom axiom, or
`native_decide`. The load-bearing certificate, arithmetic, and final numerical theorems report
exactly `[propext, Classical.choice, Quot.sound]`; see `lean/RelativeConicArcs/TRUST.md` for the
theorem map, provenance, and trust boundary. The Kim--Vu input remains an explicit named theorem
hypothesis and is not used by the finite results.

Three adversarial controls exercise distinct trust layers: changing a leaf member breaks its local
rejection proof, changing a projective transition scalar breaks the row proof, and omitting the
last parent book breaks the aggregate `StepBooksValid` coverage equality. Each mutation was
rejected by Lean and the restored sources rebuilt through the final result registry.

## Claims intentionally omitted

- No claim that the classical first two index equations are new.
- No claimed association-scheme or spectral theorem.
- No claim that a lower bound on the conic-incidence term alone settles the
exact \(q=16\) value; the paper proves that this route is too weak and uses
  the independent uncovered-quadratic-rank obstruction instead.
- No exact values for orders whose witnesses were not independently included
  and checked in the supplementary verifier.
- No unconditional novelty certification for the parameter itself.
- No claim that the 2633-class ordinary eight-arc enumeration is new.
- No claim that the general evaluation lemma, or the use of quadrics and
  evaluation conditions in arc theory, is new.
- No unconditional priority claim for the uncovered-locus quadratic
  obstruction, its `2630+3` profile, or the exact relative value. A targeted
  comparison found no predecessor, but it is not an exhaustive priority
  certificate; see `notes/2026-07-13-rhoc16-novelty-check.md`.
