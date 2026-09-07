# C1116: Bounded v2 review for friendly feedback

**Lane:** `cubic-threefolds`
**Status:** bounded source-review chunk complete; C1116 foundation audit remains open

## Scope and decision

The author asked for errors or potential upgrades in Tschinkel--Zhang v2
worth mentioning in a friendly email, then requested acknowledgment that
Zhang's comment helped prompt a more accessible m1 exposition. This review
targets the new example, the nonisomorphism remark, and the revised
tangent-projection source. It is not a full proof audit of their paper.

Send-worthy material: one definite cross-reference correction, one qualified
proof-clarification question, and a conditional application of our surface
upper bound. The adjacent draft is unsent. No email tool was used.

## 1. Example 5.2: correction and explicit coordinate bridge

Item (2) identifies a quartic del Pezzo surface with equation (5.1), which
defines the cubic surface before contraction. The intended target is the
unnumbered pair of quadrics immediately after that display.

The identification itself has a short verification. On the generic fiber
`x3=a*x5`, write the two quadratic forms as

    q1 = 2*x1^2 - 6*x2^2 + (3*a^2+1)*x5^2 - 3*a*x5*x4 - x4*x6,
    q2 = x1^2 + 3*x2^2 - x4^2 - a*x5*x6.

Set beta=-3*a^3-a and

    Y1=x1, Y2=x2, Y3=x5, Y4=x4, Y5=-a*x6-3*a^2*x5.

The first quadratic of their del Pezzo model becomes

    (-3*a^3-a)*x5^2 + 2*a*(3*x2^2-x1^2)
      + a*x4*x6 + 3*a^2*x4*x5 = -a*q1,

and the second becomes

    x1^2+3*x2^2+3*a^2*x5^2-x4^2-a*x5*x6-3*a^2*x5^2 = q2.

The transformation is invertible over Q(a):
`x6=-(Y5+3*a^2*Y3)/a`. These displayed algebraic identities verify the
bridge directly; no numerical experiment or unavailable checker is invoked.
They do not independently verify the example's smoothness or its full Galois
calculation. The intended quartic surface, rather than the cubic display,
is therefore the correct isomorphism target.

## 2. Nonisomorphism remark: request the missing intrinsic argument

Remark 5.4 distinguishes the cubics by Eckardt counts on the chosen sections
`x5=w1=...=wr=0`. Different selected sections need not imply different
ambient varieties. The text should explain why an ambient isomorphism must
preserve or recover this section/structure, or use an invariant of the whole
cubic. This is a gap in the stated justification, not a counterexample to
the nonisomorphism claim. Ask whether there is an intrinsic characterization
being used; do not assert that the cubics are isomorphic.

## 3. Useful extension: the new example inherits an upper bound

Assuming their asserted type-I1 generic fiber and our two-variable surface
theorem, for the new intersection X of two quadrics one gets

    Q(X)(u,v) = Q(a)(S)(u,v) ~= Q(a)(z1,z2,z3,z4).

Thus X x A2 is Q-rational and remains rational over R. Their nonrationality
argument gives `1 <= ell_Q(X), ell_R(X) <= 2`. This does not give exact level
two: the companion m1 lower bound concerns cubic threefolds, not intersections
of two quadrics. No priority or independent correctness claim is made for
this conditional extension.

## 4. Revised tangent-projection source: no error identified

Ciliberto--Russo, *Varieties with minimal secant degree and linear systems
of maximal dimension on surfaces*, Theorem 2.7(ii), bounds tangential
projection degree by the apparent-secant count when ambient dimension is
`(k+1)n+k`. For k=1, OADP gives degree at most one, hence birationality.
The statement permits an irreducible nondegenerate projective variety and
does not impose smoothness. This supports the singular-compatible input
in their revised Theorem 2.4. Corollary 4.5(iii) also states the resulting
birationality explicitly. No error here is recommended for the email.

This checks the relevant original theorem statement and its short proof
reduction, not all preceding degeneration arguments. C1116 still owns the
full local application and coefficient/descent audit of our papers.

## Sources and trust boundary

- Tschinkel--Zhang v2, Example 5.2, Remark 5.4, and Theorem 2.4:
  https://arxiv.org/html/2608.20029v2 . Exact source archive hashes and the
  inspected source paths are in `notes/2026-09-07-tz-v1-v2-comparison.md`.
- Ciliberto--Russo, Theorem 2.7 on printed p.20 and Corollary 4.5 on p.26,
  DOI `10.1016/j.aim.2004.10.008`, author institutional PDF:
  https://www.iris.unict.it/retrieve/dfe4d227-0ee7-bb0a-e053-d805fe0a78d9/Advances.pdf .
  The cache lookup missed; consulted the institutional PDF via web on
  2026-09-07. No full-text-read or complete primary-proof-verification claim.
- The email acknowledgment accurately reflects the user's supplied August 26
  response. It does not convert the plausibility comment into proof approval.

## EJ + TT closeout / Mystery ledger

After each candidate had a confidence level and a clear email formulation,
the EJ + TT pass supplied the explicit coordinate change instead of sending
only a typo report. It also identified the useful upper-bound application
while preventing an unjustified exact-level claim.

- **Settled:** the model pointer is wrong, but the intended linear
  identification is explicit and invertible over Q(a).
- **Open:** an intrinsic argument distinguishing the ambient cubic families
  is not supplied by different selected-section Eckardt counts alone. Ask
  the authors; no counterexample or new classification is claimed.
- **Open:** the intersection-of-two-quadrics example's exact level is not
  determined by these observations. No new task is allocated for it.
- **Closed as an email objection:** the revised projection source supplies
  the needed singular-compatible theorem statement.

No incidental discovery-log item: all observations were sought for this review.
