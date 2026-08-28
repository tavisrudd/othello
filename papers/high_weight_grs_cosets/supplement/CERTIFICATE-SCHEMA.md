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
| Certificate R11 binary quotients | none; companion record of the GF(16) and GF(32) pointed Borel quotients | GF(16)/GF(32) generators, certificates, and independent replays |
| Certificate R11 GF(27) sweep | none; companion record of the complete GF(27) carrier sweep | Rust sweep generator, frozen outputs, and an independent witness replay |
| Certificate R11 characteristic seven | none; companion record of the characteristic-seven pointed orbits | generator, certificate, and an independently written replay |

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

## Redundancy-eleven companion records

The three redundancy-eleven bundles are companion records only.  The
manuscript claims nothing at redundancy eleven, and no adopted statement
depends on them.  They are registered here, like the redundancy-eight,
redundancy-nine, redundancy-ten, and Lucas M9 companions, so that their
provenance, replay boundary, and hashes are fixed.

All three verify the same criterion.  For a redundancy-\(r\) syndrome \(z\),
read as a divided-power form of degree \(n=r-1\), and an ascending locator
coefficient list \(g\) of formal degree \(d\), the \(r-d\) consecutive-window
contractions \(\sum_{k=0}^{d} z_{i+k}g_k=0\) must vanish.  At \(d=r-2\) these
are the two consecutive Hankel equations.  Locator coefficient lists are
ascending and normalized projectively by scaling the lowest nonzero
coefficient to one, so a stored locator is a scalar multiple of the monic root
polynomial; a root at infinity is recorded as such and shows up as a zero top
coefficient.  Field elements use the toolkit encoding
`polynomial-basis-base-p-integer-v1`: the base-\(p\) radix encoding of the
polynomial-basis coordinates, least significant digit first, against an
ascending monic modulus.

**Certificate R11 binary quotients** records the 317 (GF(16)) and 1,129
(GF(32)) orbits of the redundancy-eleven maximal Lucas carrier
\(P\langle e_3,\dots,e_7\rangle\) under the **degree-ten divided-power upper
Borel action**: translation \(e_j\mapsto\sum_{i\ge j}\binom{i}{j}a^{i-j}e_i\)
and scaling \(e_j\mapsto s^je_j\), the stabilizer of infinity acting on a
degree-\((r-1)\) divided-power form.  Every orbit carries a verified finite
locator.  Naming that group is part of the record, not decoration.  An earlier
2026-08-27 version of these artifacts used the degree-**nine** redundancy-ten
action truncated to the slice \(e_3,\dots,e_7\), which is not invariant under
it; those artifacts are superseded and must not be cited.  The superseded group
produces **the same orbit counts**, 317 and 1,129, so an orbit count can never
validate this action.  Both the generators and the replays therefore run a
fail-closed seeded 1,000-pair equivariance gate asserting
\(\mathrm{is\_locator}(z,S)=\mathrm{is\_locator}(z\cdot M,\varphi(S))\) on a
syndrome drawn from the kernel of \(S\) and on an independent uniform syndrome;
that gate, not the count, is the check.  The two replays call no toolkit and
share no code with the generators.  The generators reproduce their certificates
only against the pinned toolkit build whose SHA-256 each certificate records in
`binary_sha256`; the GF(32) certificate additionally pins the GF(16) generator
source in `base_source_sha256`, which is why that generator is bundled
byte-for-byte and is invoked with explicit `--binary` and `--output`.

**Certificate R11 GF(27) sweep** records a complete sweep over
\(K=\mathrm{GF}(27)=\mathbf F_3[x]/(x^3-x-1)\): every one of the
\(402{,}321{,}277=(27^7-1)/26\) projective classes of \(\mathrm{PG}(6,27)\),
that is the whole redundancy-eleven carrier
\(P\langle e_2,\dots,e_8\rangle\) over GF(27) with no carrier-membership
condition imposed, admits a degree-nine locator with nine distinct roots in
\(K\) satisfying both Hankel equations.  Every witness arises from a two-point
affine-plane switch, and every class admits at least 78 of them; the exhaustive
\(\binom{27}{9}\) fallback was wired in and invoked zero times.  All nine roots
are finite, and the carrier is \(\mathrm{PGL}_2(27)\)-stable while the Hankel
system is \(\mathrm{PGL}_2\)-equivariant, so the sweep is pointed for free.
This is a certificate closure of the carrier \(\mathrm{PG}(6,27)\), **not** of
the ambient \(\mathrm{PG}(10,27)\), and the certificate-free switch lemma
remains open.  The Rust sweep is a **rederive** artifact taking about 26
minutes on eight threads and is not part of `verify.py --replay`; the
independent Python witness replay, which rebuilds GF(27) from scratch and
shares no code with the sweep, is.

**Certificate R11 characteristic seven** records exact pointed locator
certificates over \(\mathbf F_{49}=\mathbf F_7[x]/(x^2+1)\) for the seven orbit
representatives of the characteristic-seven Lucas carriers: five at redundancy
eleven, where \(M_{11,7}=P\langle e_4,e_5,e_6\rangle\) is
\(\mathrm{PGL}_2\)-equivariantly the divided quadratic module and a carrier
point with a marked projective root has exactly five orbits, and two at
redundancy twelve, where \(M_{12,7}=P\langle e_5,e_6\rangle\) gives the equal
and distinct pairs.  Its replay is implementation-independent: it shares no
code with the toolkit or the generator, rebuilds \(\mathbf F_{49}\) from the
certificate's own field block and proves the field property by exhaustive
inverse search, rebuilds every locator from its recorded root set, recomputes
each zero set by exhaustive evaluation over the field, checks that the recorded
forbidden projective root is avoided and that the syndrome is supported exactly
on the recorded translation-stable carrier, and re-derives both Hankel
equations and the magnitude reconstruction.  It does not certify the `distance`
field, which is the toolkit's exact minimum-distance claim resting on its
increasing-degree search order; the replay re-establishes the displayed witness,
that is the upper bound.

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
separate.  In particular, the certificate-local R7 code-deep flag is `null`, not
`true`, at \(q=7,8,9\).  At \(q=8\) the external radius theorem and companion
classifier separately extract exact distances: the diagonal tangent and
central nucleus are deep and every remaining row is shallow. The immutable
certificate flags record the split-free certificate boundary.  The manuscript
separately promotes the \(q=7,9\) rows using the parity-check extension
identity and the corresponding MDS length bounds.

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
