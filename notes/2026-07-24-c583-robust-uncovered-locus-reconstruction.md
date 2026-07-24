# C583 robust uncovered-locus reconstruction

**Lane:** `relconic`

**Status:** queued after C582.

## Goal

Turn the exact inverse theorem in
`papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex` into a
quantitative statement.  For fixed-size arcs \(A,B\subseteq\operatorname{PG}(2,q)\),
test whether small symmetric difference \(U(A)\mathbin{\triangle}U(B)\) forces
agreement of most secant lines and then structural proximity of the parent
arcs.  A second formulation may couple this inverse problem to the
prescribed-hole defect and C558's bad-edge stability.

## First discriminator

Prove the sharpest deterministic line-threshold lemma available from the
identity
\[
 \operatorname{PG}(2,q)\setminus U(A)
   =\bigcup_{\ell\in\operatorname{Sec}(A)}\ell .
\]
The lemma must quantify how many secant lines can be lost or gained when the
two unions differ in \(t\) points.  Test it against adversarial arrangements
with many concurrent lines before using arc structure.

## Acceptance gates

1. State all scale assumptions in \(q,k,t\); do not hide a requirement stronger
   than the exact threshold \(q+1>\binom{k}{2}\).
2. Separate recovery of secant lines from recovery of vertices.
3. Prove a field-uniform theorem, or close the proposed robust inverse
   negatively with an explicit family showing why no useful uniform bound can
   hold.
4. Treat C558's bad-edge estimate as combinatorial input only.  Any claimed
   projective stability must use a genuinely rank-three compatibility step.
5. Do not substitute a table of finite-field reconstructions for a structural
   discriminator.

## Paper TODO

The manuscript contains a source TODO adjacent to the exact reconstruction
theorem and an open problem in the conclusion.  Replace them only after this
task proves a theorem with an honest quantitative range; otherwise revise the
problem to record the exact obstruction.

## Evidence boundary

No robust theorem is claimed at allocation.  C582 contributes only the exact
reconstruction theorem, its sharp threshold, and the already proved C558
bad-edge bound.
