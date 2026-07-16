# Arcs: square-root construction program

## Objective

Construct conic-complete arcs of size `O(sqrt(q))`, or prove that no such bound
can hold for an infinite family of prime powers. This is C210, the
highest-ceiling long-horizon target for the prescribed-conic lane.  The bounded
C201 even-field quadratic-rank probe runs first and should supply structural
data for this program.  Neither task is a release gate for the current
manuscript.

## Why this is the right next theorem

The present paper proves a lower bound on the `sqrt(2q)` scale but transfers
only the general `O(sqrt(q) polylog(q))` complete-arc upper bound. Closing the
polylogarithmic gap would connect the new parameter to the established scale of
small complete arcs and directly answer the strongest significance objection.

## Initial gates

1. Import C201's rank/forced-hit features and its precise success or failure at
   the q=64 gate; do not begin with an unrelated blind census.
2. Audit known `O(sqrt(q))` affine and projective complete-arc constructions for
   whether a projective image can avoid a prescribed conic while retaining
   off-conic coverage.
3. Determine whether the averaging argument can be strengthened from mere
   avoidance to simultaneous avoidance and coverage at the sharp scale.
4. Test structured candidates over a sequence of even and odd fields, recording
   ordinary-uncovered loci and quadratic evaluation rank rather than only
   `rho_C(q)`.
5. If construction repeatedly fails, isolate a family-level obstruction strong
   enough to rule out `O(sqrt(q))` on an infinite sequence.

Additional isolated exact values are evidence, not completion of this program.

## C201 input

C201 closed its bounded q=64 gate without an infinite theorem.  Its usable
design lesson is **coverage first, rank second**: the tested Baer,
transitive-torus, and split-`Z3` size-thirteen mechanisms leave hundreds of
ordinary points uncovered, so quadratic rank is not yet discriminating.  C210
may use those exact failures as cheap rejection tests for analogous
constructions, but they are not a global q=64 exclusion and provide no
infinite-family lower bound.
