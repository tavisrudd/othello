# C357: oval service extremizers, PIR availability, and majority-logic obstruction

**Date:** 2026-07-19
**Lane:** `crowns`
**Verdict:** **THEOREM; EXACT SERVICE--PIR CONVERSE WITH SHARP MAJORITY-LOGIC EXCEPTIONS**

## Result

Let \(A\) be an \(m\)-point subarc, \(m\ge4\), of a conic in \(PG(2,q)\), and let \(P\) be a
point off the conic, regarded as a requested linear object for the `[m,3,m-2]` MDS matrix whose
columns are the points of \(A\).  Projection from \(P\) induces an involution \(\iota_P\) on the
conic.  Write

\[
r_P(A)=\#\{\{x,\iota_P(x)\}\subseteq A:x\ne\iota_P(x)\}.
\]

Then:

1. The one-object service capacity is at most \(m/2\), and it equals \(m/2\) if and only if
   \(r_P(A)=m/2\).
2. The maximum number of pairwise disjoint recovery groups is exactly

   \[
   \kappa_P(A)=r_P(A)+\left\lfloor\frac{m-2r_P(A)}3\right\rfloor.
   \]

   Consequently \(P\) has the maximum possible \(m/2\)-PIR availability if and only if its
   service capacity is \(m/2\).
3. The disjoint-recovery one-step majority-logic decoder has exact guaranteed radius

   \[
   \tau_P(A)=\left\lfloor\frac{\kappa_P(A)-1}{2}\right\rfloor.
   \]

   This radius is strictly coarser than the first two invariants: equality in the
   Di Giusto--Ravagnani--Soljanin bound can occur without maximal service or maximal PIR
   availability.

This is the missing converse across service and PIR, together with a sharp obstruction to the
five-way equivalence proposed in C357.  The obstruction is structural, not just a small-field
counterexample.

## Proof

The two-point recovery sets for \(P\) are exactly the secants through \(P\).  Two such secants
cannot share a conic point, so these recovery pairs form a matching of size \(r=r_P(A)\).  Every
other recovery group has at least three members; conversely every three arc points span the whole
projective plane and hence recover \(P\).

The total-capacity bound gives service at most \(m/2\).  Equality consumes exactly \(m\) units of
server work, so every positively weighted recovery group must have size two and every server must
be saturated.  Since the two-point groups form a matching, this is possible exactly when they
partition \(A\), i.e. when \(r=m/2\).  The converse allocation gives unit weight to every pair.

For disjoint recovery, use all \(r\) pairs and partition the remaining \(m-2r\) points into
triples, giving \(r+\lfloor(m-2r)/3\rfloor\) votes.  Conversely, if a packing uses \(p\le r\)
pairs and \(J-p\) larger groups, then

\[
2p+3(J-p)\le m.
\]

The resulting upper bound is nondecreasing in \(p\), so it is maximized at \(p=r\) and equals the
displayed formula.  A worst-case error corrupts at most one of these disjoint votes, giving the
stated strict-majority radius.

This proof also explains why fractional service and integral availability have the same
extremizers here even though they do not coincide in general: the size-two recovery hypergraph is
already a matching.

## Full ovals and the exact exceptions

For an odd-field conic, \(m=q+1\).

- If \(P\) is internal, \(r=(q+1)/2\), so service is \((q+1)/2\), PIR availability is
  \((q+1)/2\), and \(\tau=\lfloor(q-1)/4\rfloor\).
- If \(P\) is external, \(r=(q-1)/2\), so service and PIR are not maximal, while
  \(\tau=\lfloor(q-3)/4\rfloor\).

Thus the decoder radius distinguishes internal from external targets when \(q\equiv1\pmod4\),
but ties them when \(q\equiv3\pmod4\).  In particular, majority-logic equality cannot be included
in an all-odd-field extremizer equivalence.

For an even-field maximum oval (a hyperoval), every off-oval point is internal and its secants
partition all \(q+2\) points.  All three metrics are therefore maximal, and the disjoint decoder
attains radius \(\lfloor q/4\rfloor\).

For a shortened conic, service and PIR remain maximal exactly when \(A\) is a union of nonfixed
\(\iota_P\)-orbits.  If \(P\) is external, this additionally says that the two tangent fixed
points are omitted.  Hence deleting the tangent contacts creates the precise external-target
exception: an external point for the parent conic becomes an extremizer for the shortened arc.
Deleting arbitrary points does not.

The majority-logic statement here is deliberately the disjoint-recovery decoder analyzed in
*The Oval Strikes Back*.  It is not a universal optimum over overlapping vote systems.  Ly and
Soljanin's Reed--Muller construction shows that controlled overlaps can materially change
one-step majority-logic performance.

## Exact q=5,7,9 falsifier

The certificate enumerates the full projective plane, the standard conic, every off-conic target,
and every even subarc of size at least four.  It independently computes secant pairs by determinant
and replays the vote formula with an exact set-packing dynamic program on every realized `(m,r)`
signature.

| \(q\) | targets | shortened cases | cases with a pair | pair partitions | decoder-bound equalities | equalities without partition |
|---:|---:|---:|---:|---:|---:|---:|
| 5 | 25 | 400 | 340 | 55 | 325 | 270 |
| 7 | 49 | 4,851 | 3,731 | 343 | 2,471 | 2,128 |
| 9 | 81 | 37,746 | 29,466 | 1,431 | 13,671 | 12,240 |

The full-conic signatures are respectively

- \(q=5\): internal `(r,votes,radius)=(3,3,1)`, external `(2,2,0)`;
- \(q=7\): internal `(4,4,1)`, external `(3,3,1)`;
- \(q=9\): internal `(5,5,2)`, external `(4,4,1)`.

The q=7 row is the smallest full-conic witness to decoder-radius collapse.  The shortened counts
show that this is not an isolated congruence accident.

## Evidence and replay

The evidence bundle is:

- `notes/2026-07-18-c357-oval-service-extremizer-equivalence.py` — deterministic finite-field,
  incidence, and exact-packing checker;
- `notes/2026-07-18-c357-oval-service-extremizer-equivalence.json` — canonical certificate;
- `notes/2026-07-18-c357-oval-service-extremizer-equivalence.sha256` — hashes and byte counts.

From `/home/tavis/src/othello`, check the tracked artifact without modifying the worktree:

```bash
python3 notes/2026-07-18-c357-oval-service-extremizer-equivalence.py \
  --check notes/2026-07-18-c357-oval-service-extremizer-equivalence.json
```

To regenerate it, replace `--check` by `--write`.  The output is canonical sorted JSON with no
randomness or host-dependent fields.  The trusted boundary is the short prime/`F_9` arithmetic,
projective normalization, determinant test, Python integer arithmetic, and the set-packing DP.
The computation checks all stated finite cases; the all-field claims rest on the symbolic proof.

## Literature and novelty audit

Four of the seven individually named external sources below were read at full text.  Three were
read partially at the sections stated.  No consulted source states the service--PIR extremizer
converse, the exact shortening classification, or the congruence obstruction to adding decoder
radius to that equivalence.

- Di Giusto--Ravagnani--Soljanin, *The Oval Strikes Back*, arXiv v1 — **full text**, all sections;
  cache `arXiv:2601.16628`, SHA-256
  `ab80a873ecf39ca7c130252d78eb07f2e2aa8b966f465e7f44dbdb3c9bf6871b`.  It proves the
  all-internal forward construction, PIR consequence, disjoint-vote decoder, and its bound, but
  gives no converse or shortening classification.
- Ly--Soljanin, *Maximal Achievable Service Rates of Codes and Connections to Combinatorial
  Designs*, arXiv v3 — **full text**, all sections; cache `arXiv:2506.16983`, SHA-256
  `37b975a07ec877e73c63aa111aaf4286e644697254b965c4a11345e41d00ac2a`.  Its design conditions
  are sufficient and its bounds are not an oval-extremizer classification.
- Boruchovsky--Gruica--Niemann--Yaakobi, *Serving Every Symbol: All-Symbol PIR and Batch Codes*,
  arXiv v2 — **full text**, all sections; cache `arXiv:2601.04041`, SHA-256
  `64d12f7e49d474c8db407ff341cc2e8cab800a88ad8cbf078244579068933062`.  It identifies the
  codeword-symbol all-symbol-PIR/orthogonal-repair correspondence, not off-carrier message targets
  or conic involutions.
- Ly--Soljanin, *Optimum 1-Step Majority-Logic Decoding of Binary Reed--Muller Codes*, arXiv v3 —
  **full text**, all sections; cache `arXiv:2508.08736`, SHA-256
  `66f5c5236f56c3cf141e8204bd3d9e03af48e8ea7cb26e00cd8cce8d044ced45`.  It is the reason the
  theorem is scoped to disjoint votes: its overlapping design achieves a different optimum.
- Alfarano--Ravagnani--Soljanin, *Dual-Code Bounds on Multiple Concurrent (Local) Data Recovery*,
  arXiv v2 — **partial**, abstract, Sections 1, 4.1, and 4.2; cache `arXiv:2201.07503`, SHA-256
  `75dfdc9b233c2f091e987790b6cff029551b59d0289d85f0b9b3d8b30a712bbc`.  It supplies the
  total-capacity and dual-distance boundary, not equality classification here.
- Kazemi--Karimi--Soljanin--Sprintson, *A Combinatorial View of the Service Rates of Codes
  Problem*, arXiv v1 — **partial**, abstract, Section I, and the matching definitions and
  equivalence setup in Section III; cache `arXiv:2001.09146`, SHA-256
  `a52f36467c4aba2deffaa0df820e98f7d43d6c82b1ca96a7c90db890000571b9`.  It gives the general
  fractional/integral matching bridge, not this matching-forced extremizer theorem.
- Ly--Soljanin--Whiting, *Majority-Logic Decoding of Binary Locally Recoverable Codes: A
  Probabilistic Analysis*, arXiv v2 — **partial**, abstract, Sections I--II, and Section V; cache
  `arXiv:2601.08765`, SHA-256
  `37105cf9b8d073e4da1f346e861e8ddd418255692f6d732ba6ef27762cd664e9`.  It concerns binary
  all-symbol LRCs and stochastic channels, not q-ary MDS message targets or worst-case converses.

The load-bearing arXiv metadata searches on 2026-07-19 were, verbatim:

- `all:"service rate" AND all:"majority logic" AND all:PIR` — one result, the oval paper;
- `all:oval AND all:"majority logic"` — one result, the oval paper;
- `all:conic AND all:PIR AND all:"service rate"` — zero results;
- `all:"all-symbol PIR" AND all:MDS` — one result, the all-symbol paper;
- `all:"orthogonal parity checks" AND all:"service rate"` — zero results.

Forward-citation checks used pinned arXiv/DataCite identifiers.  For `arXiv:2601.16628`, OpenAlex
reported zero, Crossref returned HTTP 404 (not indexed), and Semantic Scholar reported one.  The
single Semantic Scholar item was screened over title, abstract, year, and identifiers: the 2026
published MDS-SRR paper, **abstract/metadata only**, does not address the converse.  For
`arXiv:2601.04041`, OpenAlex and Semantic Scholar each reported zero and Crossref returned 404.  For
`arXiv:2508.08736`, OpenAlex reported zero, Crossref returned 404, and Semantic Scholar reported
seven; the full seven-item set was screened over title, abstract, year, and identifiers.  Four are
already individually discussed above; the remaining service/RM and universal-ML-decoding items do
not concern the conic extremizer classification.  The count disagreements are retained rather than
collapsed.

MathSciNet was not accessible and is **NOT COVERED**.  Google Scholar was not used because automated
access is blocked.  This supports a focused “no predecessor located” verdict, not an unrestricted
priority claim; manuscript wording should retain “to our knowledge.”

## Scope

This closes C357 with a new uniqueness/converse theorem spanning projective internality, secant
partitions, maximum fractional service, maximum PIR availability, and the precise failure of
decoder-radius classification.  It does not determine the full multi-object SRR, optimize
overlapping-vote majority logic for conic MDS codes, give stochastic q-ary decoding bounds, or
classify arbitrary nonconic arcs.
