# Arcs: square-root construction program

## Objective

Construct conic-complete arcs of size `O(sqrt(q))`, or prove that no such bound
can hold for an infinite family of prime powers. This is the principal
post-submission theorem target for the prescribed-conic lane; it is not a gate
for the current manuscript.

## Why this is the right next theorem

The present paper proves a lower bound on the `sqrt(2q)` scale but transfers
only the general `O(sqrt(q) polylog(q))` complete-arc upper bound. Closing the
polylogarithmic gap would connect the new parameter to the established scale of
small complete arcs and directly answer the strongest significance objection.

## Initial gates

1. Audit known `O(sqrt(q))` affine and projective complete-arc constructions for
   whether a projective image can avoid a prescribed conic while retaining
   off-conic coverage.
2. Determine whether the averaging argument can be strengthened from mere
   avoidance to simultaneous avoidance and coverage at the sharp scale.
3. Test structured candidates over a sequence of even and odd fields, recording
   ordinary-uncovered loci and quadratic evaluation rank rather than only
   `rho_C(q)`.
4. If construction repeatedly fails, isolate a family-level obstruction strong
   enough to rule out `O(sqrt(q))` on an infinite sequence.

Additional isolated exact values are evidence, not completion of this program.
