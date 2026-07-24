# Public certificate schema

The public labels below are stable paper identifiers.  Internal dated
filenames remain immutable provenance, but are not mathematical identifiers.

| Public label | Paper claim | Internal provenance |
|---|---|---|
| Certificate R5 | redundancy-five finite classification | C491 |
| Certificate R6 | redundancy-six census and radius bridge | C498 |
| Certificate R6-NF | small exceptional normal forms | C498 small-normal-form bundle |
| Certificate R7 | redundancy-seven split-free finite bridge | C509 |
| Certificate R8 | redundancy-eight algebra, nuclei, and bounds | C513 |
| Certificate R9 | redundancy-nine residual and slice algebra | C516 |
| Certificate R9-49 | characteristic-seven carrier at \(q=49\) | C516 q49 bundle |
| Certificate Hessian | ordered-Hessian bounded algebra | C525 |
| Certificate Lucas | Lucas-carrier arithmetic | C529 |
| Certificate e7 | degree-nine \(e_7\) quotient cover | C530 |

## Classification record

A finite classification record is complete only when it contains all of:

1. the field and ambient projective syndrome domain;
2. a canonical normalized representative for every orbit;
3. the normalization algorithm and its deterministic tie-breaking rule;
4. an intrinsic invariant or member histogram used to reject unequal orbits;
5. the projective stabilizer and the orbit-stabilizer size check;
6. the coefficient-Frobenius image and resulting semilinear fusion;
7. persistent, modular, split-free, and radius flags as separate fields;
8. a domain cardinality identity showing that the represented orbits exhaust
   the searched domain;
9. hashes and byte counts for the generator, certificate, and replay.

Repeated orbit sizes never identify an orbit.  They are distinguished by the
canonical representative, stabilizer, histogram/invariant, and Frobenius link.

## Algebra record

An algebra record contains:

1. the symbolic input ring and characteristic restrictions;
2. every normalized polynomial or matrix used by the paper;
3. the exact identity, factorization, resultant, gcd, rank, or discriminant
   being checked;
4. the searched parameter domain and every excluded divisor;
5. a canonical serialized result;
6. an independent replay classification:
   - **rederive**: rebuilds the result from definitions;
   - **reconstruct**: rebuilds orbit invariants or normal forms from the
     primary certificate;
   - **compare**: checks serialization, counts, or hashes only.

The paper's geometric integrality, component exhaustion, and point-existence
proofs are not discharged by an algebra record unless the record includes a
separately stated completeness theorem connecting the finite calculation to
that claim.

## Radius record

Split-free status and code deep-hole status are separate fields.  A radius
record names either the imported covering-radius theorem or the complete
definition-level scan that proves the conversion for the specified field.
No certificate may infer a code classification from split-free data alone.
