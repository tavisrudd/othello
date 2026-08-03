# Public certificate schema

The public labels below are stable paper identifiers.  Internal dated
filenames remain immutable provenance, but are not mathematical identifiers.
The complete R5--R7 electronic tables are
`CLASSIFICATION-RECORDS.json`.  They are deterministically extracted from
the frozen certificates by `build_classification_records.py`; the public
JSON records the hash and byte count of every input generator, certificate,
and replay.

| Public label | Paper claim | Internal provenance |
|---|---|---|
| Certificate R5 | redundancy-five finite classification | redundancy-five census and replay |
| Certificate R6 | redundancy-six census and radius bridge | redundancy-six census and replay |
| Certificate R6-NF | small exceptional normal forms | small-normal-form bundle |
| Certificate R7 | redundancy-seven split-free finite bridge | redundancy-seven calibration and replay |
| Certificate R7 direct locus | fourteen-field direct-locus completeness reconstruction | compact candidate/orbit certificate and checker |
| Certificate SC | stable-component identities, saturation, and vertical fibres | stable-component bundle |
| Certificate R8 | redundancy-eight thresholds, nuclei, and witnesses | R8 generator and replay |
| Certificate R9 | residual-quadratic and characteristic-seven bridge | R9 generator, replay, and q=49 record |
| Certificate R10 | redundancy-ten threshold and orbit arithmetic | R10 generator and replay |
| Certificate Lucas M9 | first higher-Lucas-carrier arithmetic | rank-two and complete-carrier generators, certificates, and replays |

Certificate R7 has two replay routes.  The original replay checks every
recorded representative directly by the five-secant criterion and rebuilds
its projective orbit, stabilizer, and Frobenius link.  The independent arithmetic
replay imports no stored orbit partition: it reruns the quotient enumerator
after replacing the original calibration's field implementation by the independently written R5
replay field, and compares the reconstructed pointed complements, sextic
split-free set, projective orbits, stabilizers, flags, and Frobenius links.
The direct-locus replay is independent of the quotient enumerator.  It
imports only the separately written R5 replay's finite-field implementation.
For \(q<16\) it constructs the literal complement of all four-finite-secant
spans in \(\operatorname{PG}(5,q)\); for \(q\geq16\) it constructs the
classified R6 pointed locus directly from its persistent, marked-secant, and
binary-nucleus pieces, together with the transient 19-point marked orbit at
\(q=19\).  It then intersects every contraction condition,
rebuilds the complete \(\operatorname{PGL}_2(q)\) orbit and Frobenius
partition, and compares exact sets and records in all fourteen bridge fields.
Certificate R7 direct locus freezes this route before comparison and adds the
two exact mass identities, compact orbit tuples, and one partition digest per
field.  It shares the published direct-locus engine, its R5 field layer, and
the proved R6 pointed-locus classification from \(q\geq16\).  Its checker
validates the frozen schema and comparison but is not a second finite-field
implementation.

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

For R5--R7, projective vectors are normalized by scaling the first nonzero
coordinate to one.  Their point index is the base-\(q\) radix index with
coordinate zero most significant, and the canonical projective-orbit
representative is the minimum such index in the orbit.  Rows are sorted by
orbit size and then canonical index.  The R6 semilinear normal form is the
lexicographically first frozen representative in its coefficient-Frobenius
cycle.  These rules are repeated in machine-readable form in the electronic
record.

Each field row states the actual searched domain, the classified split-free
count, the sum of the listed orbit sizes, and whether the resulting exhaustion
identity holds.  Persistent, modular, split-free, and code-deep flags are
separate.  In particular, the R7 code-deep flag is `null`, not `true`, at
\(q=7,8,9\), where the certificate supplies no covering-radius premise.

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
