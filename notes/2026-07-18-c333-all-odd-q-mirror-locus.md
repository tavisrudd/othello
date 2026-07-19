# C333: an all-odd-field mirror-locus P-family

**Date:** 2026-07-19  
**Lane:** `crowns`  
**Status:** sharp theorem; uniform family for every odd `q>=5`, with explicit character tests and count

## Result

Let `q=p^e>3` be odd.  Use

\[
P_\infty=(1,0,0),\qquad P_0=(0,1,0),\qquad
P_t=(t,t^{-1},1)
\]

on the conic `XY=Z^2`.  Choose `delta in F_q` with

\[
\chi(\delta)=-1,\qquad \chi(\delta-4)=1,
\]

and put `tau(t)=delta/t`.  There are exactly

\[
|D_q|=\frac{q-\chi(-1)}4
\]

such `delta`, so a choice exists in every odd field.  For `b in F_q`, define

\[
S_{\delta,b}=\{(0,1,1),(\delta,0,1),(1,b,1),
                 (\delta b,\delta^{-1},1)\}.
\]

The following tests are sufficient and require only field arithmetic and quadratic characters:

1. for every odd prime `r|e`, the two elements `b` and `(2-delta)^2` are not both in
   `F_(p^(e/r))`;
2. `b` is not `0`, `1`, or `delta^(-1)`;
3. `1+delta(b-1)` and `1-delta+delta^2 b(1-b)` are nonzero;
4. `chi((1+delta b)^2-4delta)=-1`; and
5. if `chi(-1)=1`, then `chi(b-1)=-1`.

For every passing pair, `{P_infinity,P_0} union S_(delta,b)` is a six-arc, the four projection
involutions generate `PGL_2(q)`, and the fixed-point-deleted conic residual has a fixed-point-free,
nonadjacent `tau` pairing.  Consequently it is a Node--Kayles P-position and has Sprague--Grundy
value zero.

This removes all congruence restrictions from C294's frozen `S_b` family.  The restrictions
`p mod 40` and odd extension degree were artifacts of fixing `delta=-1` and forcing both `-1` and
`5` to be nonsquares.  They are not obstructions to a mirror-stable full-`PGL_2` P-family.

## Size and the explicit all-field threshold

Fix any `delta in D_q`.  The polynomial

\[
f_\delta(b)=(1+\delta b)^2-4\delta
\]

has nonsquare discriminant `16 delta^3`, hence no root in `F_q`, and

\[
\sum_b\chi(f_\delta(b))=-1.
\]

If `chi(-1)=-1`, exactly `(q+1)/2` parameters pass the mirror test before the six displayed
algebraic exclusions and the odd-index subfield test.  If `chi(-1)=1`, the outer-sheet condition adds
`chi(b-1)=-1`; its raw count is

\[
N_\delta=\frac{q+1+S_\delta}{4},\qquad
S_\delta=\sum_b\chi((b-1)f_\delta(b)),\qquad |S_\delta|\le 2\sqrt q.
\]

The last inequality is the quadratic-character Weil bound for a square-free cubic.  If `E_q^odd`
denotes the size of the union of maximal subfields of odd prime index, the number of passing `b` is
therefore at least

\[
\frac{q+1}{2}-6-E_q^{\rm odd}
\]

when `chi(-1)=-1`, and at least

\[
\frac{q+1-2\sqrt q}{4}-6-E_q^{\rm odd}
\]

when `chi(-1)=1`.  The union bound gives

\[
E_q^{\rm odd}\le\sum_{\substack{r\mid e\\r\text{ odd prime}}}q^{1/r}.
\]

If `e` is a power of two then `E_q^odd=0`.  Otherwise the smallest square-`-1` boundary case is
`q=5^3=125`, where the lower bound is already greater than `14`; the `q/4` main term dominates
each `q^(1/r)` thereafter, while the nonsquare-`-1` sheet has the stronger `q/2` main term.  Thus
the inequalities prove existence for every odd `q>=125`.  The only boundary cases not already positive from
the displayed inequalities are the prime fields `5,7,11,13,17,29` and the quadratic fields `9,25`,
all of which pass the exact finite replay.  The fields `49` and all larger quadratic fields pass the
bound; `27` passes both the bound and the replay; and `81` has no odd-index maximal-subfield row and
passes the bound.  Therefore the construction exists for **every odd prime power `q>=5`**.  For
`q=3`, a six-arc in `PG(2,3)` is impossible, so this is the sharp field boundary for any theorem of
the displayed six-arc form, not merely a failure of the parametrization.

For each fixed suitable mirror the family has size `q/2+O(q^(1/3) log e)` on the nonsquare `-1`
sheet and `q/4+O(sqrt(q)+q^(1/3) log e)` on the square `-1` sheet.  The finite replay finds passing
full-group examples in `q=5,7,9,11,13,17,25,27,29,49`.

The parametrization is injective as a family of normalized centre sets: `(delta,0,1)` is the unique
centre with column zero and `(1,b,1)` is the unique centre with row one, under the displayed
exclusions.  Hence the parameter counts are counts of distinct normalized sets, not only marked
formula instances.

## Geometry of the normalized mirror locus

After fixing the burned orbit `{P_infinity,P_0}` and one canonical fixed-point-free mirror
`tau(t)=delta/t`, an ordered pair of centre-orbit representatives `(r,c)` and `(s,d)` gives

\[
\{(r,c),(\delta c,r/\delta),(s,d),(\delta d,s/\delta)\}.
\]

The distinctness, off-conic, and six-arc requirements remove finitely many hypersurfaces from
`A^4`.  The resulting ordered normalized mirror locus is therefore an irreducible four-dimensional
open set whenever nonempty.  Passing to unordered orbits and unlabelled representatives is a
finite quotient by a subgroup of `C_2 wr S_2`; it remains irreducible and four-dimensional.  The
determinant sheets and mirror-nonadjacency signs split its finite-field points arithmetically, not
its geometric irreducible components.

The displayed `S_(delta,b)` construction is an explicit irreducible one-dimensional slice after
`delta` is fixed.  It is deliberately smaller than the full four-dimensional locus: its role is to
give a uniform theorem and a construction interface, not to claim a complete orbit classification
of every legal mirror-stable four-centre set.

## Proof

For an affine centre `(r,c,1)`, projection through the centre induces

\[
\sigma_{r,c}(t)=\frac{t-r}{ct-1},\qquad
A_{r,c}=\begin{pmatrix}1&-r\\c&-1\end{pmatrix}.
\]

Conjugation by `tau` sends `(r,c)` to `(delta c,r/delta)`, so it swaps the first two and last two
centres.  Rows and columns are pairwise distinct under test 2.  The two independent determinants
of triples of affine centres, up to the harmless factor `delta`, are

\[
1+\delta(b-1),\qquad 1-\delta+\delta^2b(1-b).
\]

Together with `b != 1`, these and the row/column tests check all twenty triples in the six-set.

Let the generators in displayed centre order be `A_0,...,A_3`.  Direct multiplication gives a
projectively nontrivial unipotent

\[
W=A_2A_0A_2A_0A_1A_0,
\]

whose trace is `2b-2`, determinant is `(b-1)^2`, and whose scalar exceptional equation is exactly
`1+delta(b-1)=0`.  The fixed-point sets of `A_0` and `A_1` are `{0,2}` and
`{infinity,delta/2}`, so the generated group has no global fixed point.  It also contains `W`, an
element of order `p`.  Finally

\[
\kappa(A_2A_0)=\frac{\operatorname{tr}(A_2A_0)^2}{\det(A_2A_0)}=\frac1{1-b}.
\]

The paired first-orbit product supplies the independent invariant

\[
\kappa(A_1A_0)=(2-\delta)^2.
\]

At least one generator is outside `PSL_2(q)`: `det(A_0)=-1` suffices when `chi(-1)=-1`, while
`det(A_2)=b-1` suffices under test 5.  The maximal-subgroup list for `PGL_2(q)` outside
`PSL_2(q)` now closes the generation proof.  The disjoint fixed-point test excludes a Borel; the
`p`-element excludes both torus normalizers and the prime-field `S_4` exception; and a proper
maximal subfield `PGL_2(q_0)`, where `[F_q:F_(q_0)]=r` is an odd prime, would force both displayed
invariants into `F_(q_0)`.  The first puts `b` there.  The second makes `delta` quadratic over
`F_(q_0)`; because `delta` also lies in the odd-degree extension `F_q/F_(q_0)`, it must already lie
in `F_(q_0)`.  Test 1 excludes exactly this simultaneous containment for every possible `r`.
Thus the generated group is all of `PGL_2(q)`.  In particular, the earlier full-degree condition
`F_p(b)=F_q` was sufficient but unnecessarily strong.

The equality `tau(t)=sigma_(r,c)(t)` has discriminant

\[
(r+\delta c)^2-4\delta.
\]

For the first centre orbit this is `delta(delta-4)`, a nonsquare by the choice of `delta`; for the
second it is `f_delta(b)`, a nonsquare by test 4.  Thus no live vertex is adjacent to its mirror.
The centre set and its secant-deleted conic set are `tau`-stable.  After a move at `v`, the response
at `tau(v)` is legal, and deleting both closed neighborhoods restores the invariant.  Induction
gives a second-player win and Grundy value zero.

## Applied construction interface

No group enumeration is needed:

1. find any nonsquare `delta` for which `delta-4` is square;
2. scan `b` through the five explicit tests;
3. emit the four centres above; and
4. use `tau(t)=delta/t` as the pairing/repair-scheduling certificate.

The tests are constant-size field arithmetic plus at most one Frobenius-membership test for each
odd prime divisor of `e`.  They export the four projection matchings, their mirror pairing, the
exact exceptional locus, and a full-group certificate suitable for the C334 repair/service
consumer.

## Open questions, unlocks, and allocated level-ups

### Landed immediately in C333

The first two obvious upgrades do not need follow-up tasks.  The full-degree hypothesis on `b` has
been replaced by the exact odd-index maximal-subfield test using the two trace invariants
`1/(1-b)` and `(2-delta)^2`.  The counting argument plus the finite boundary replay now sharpens
the existence range from `q>=3^12` to every odd `q>=5`; `q=3` is excluded by the six-arc bound.

### What the theorem unlocks

- **C334/C353, operational boundary:** C334 has since closed the homogeneous fractional-service
  metric negatively against the stronger 2026 oval result.  C333 does not reopen that claim.  Its
  all-odd-field construction and fixed-point-free helper pairing instead supply a controlled input
  for the still-unsettled mixed-facet, integral coloured-scheduling, and heterogeneous/failure
  metrics isolated below as C353.
- **C332, base change:** two explicit trace invariants and the exact odd-index subfield test give a
  concrete family on which to formulate restriction/base-change behavior without requiring `b`
  itself to have full degree.
- **C295/C337-style reconstruction:** the distinguished mirror and two paired centre orbits make
  intrinsic recovery from an unmarked graph, code, or repair hypergraph a sharply stated problem.
  This does not bypass C295's external C272 gate or duplicate C337's completed layered-code result.
- **C294, positive stratum only:** Crown I now has a full-group P-stratum in every odd field `q>=5`.
  It still lacks a forced move from a general three-centre state, and the user pause remains in
  force; C333 does not authorize E3 or any C294 experiment.

### C350 — full mirror-locus quotient and exact count

Classify the full irreducible four-dimensional normalized locus modulo the finite
`C_2 wr S_2` relabelling and the residual projective stabilizer.  Determine its determinant-sheet,
full-group, subfield, and enhanced-automorphism strata; count projective equivalence classes; and
identify the genus-one character-sum family controlling the exact square-`-1` count.  A passing
result needs a structural orbit/stabilizer theorem and an exact or power-saving count, not merely a
larger coordinate census.

**Novelty gate:** build a source-level matrix covering Fregier point--involution correspondence,
finite `PGL_2` involution orbits, moduli of point configurations on/around a conic, classical
character-sum/elliptic-curve evaluations, and recent generating-triple/hypertope work.  Run
MathSciNet/zbMATH-style database and forward-citation closure before any priority claim.  Stop or
narrow if the quotient/count is a direct instance of a known orbit formula or standard elliptic
family with no new four-centre consequence.

**Owned report:** `notes/2026-07-19-c350-full-mirror-locus-quotient-count.md`.

### C351 — intrinsic recognition of the mirror family

Given only the uncoloured residual graph, associated code, or four-matching repair hypergraph,
recover when possible the mirror `tau`, the two centre orbits, and the projective parameters
`[delta,b]` up to their exact equivalence group.  State exceptional automorphism strata and give a
polynomial-time recognition/reconstruction algorithm with independently generated negative
instances.  A supplied colouring, supplied centre partition, or finite lookup table does not pass.

**Novelty gate:** compare against graph reconstruction and canonical-labelling results, code
equivalence/arc recognition, association schemes and commuting-involution graphs, and the exact
reconstruction mechanisms already used by C295 and C337.  Close forward citations for the recent
involution-graph and generating-triple papers.  Stop if the proposed invariant merely restates a
known colouring or if recovery fails generically on the first two nontrivial fields.

**Owned report:** `notes/2026-07-19-c351-mirror-locus-intrinsic-recognition.md`.

### C352 — multi-orbit mirror families

Replace two centre orbits by `k>=3` orbits of one fixed-point-free involution.  Determine the
dimension, legality and nonadjacency character conditions, full-group generation, and abundance of
the resulting `2k`-centre P-families.  The entry gate is a symbolic `k=3` construction with a
positive-density parameter set and a full-group proof; a mirror-pairing restatement or isolated
finite example stops the task.

**Novelty gate:** close the boundary against generating sets of involutions, rank-four and higher
hypertopes/maniplexes, arcs and MDS configurations with involutory symmetry, multiple-repair
alternatives, and symmetric Node--Kayles pairing families.  Require primary-source and
forward-citation coverage before scaling a census or claiming a new infinite family.

**Owned report:** `notes/2026-07-19-c352-multiorbit-mirror-families.md`.

### C353 — mixed and failure-aware repair scheduling

Consume C333 only beyond C334's homogeneous fractional-service negative: compute exact mixed
internal/external facets, integral coloured schedules, or heterogeneous/failure-capacity regions
for the mirror-paired four-matching carrier.  The entry gate is one metric on which two C333
parameters with the same `E/E/I/I` type have provably different operational behavior, or a strict
advantage over the oval baseline.  If the answer depends only on the type counts or reproduces the
oval simplex, close negatively before a family census.

**Novelty gate:** begin with the 2025--2026 MDS service-rate-region/fractional-matching literature,
*The Oval Strikes Back*, integral/batch scheduling, heterogeneous-server capacity, and
failure-aware repair papers; close their forward citations before selecting the metric.  Compare
scalar with scalar and fractional with fractional, and claim no repair novelty from mirror pairing
alone.

**Owned report:** `notes/2026-07-19-c353-mirror-mixed-failure-scheduling.md`.

The remaining outer-game transfer is not allocated here: it is already owned by paused C294.
The general base-change question remains C332 rather than being duplicated under a new ID.

## Novelty and trusted boundary

Tranchida's 2025 paper supplies the classical off-conic-point/projective-involution dictionary,
quotes the needed `PGL_2(q)` maximal-subgroup list, and proves existence of suitable full-group
generating triples.  C333 does not claim any of those facts.  Its bounded new core is the explicit
four-centre `tau`-stable locus, the two quadratic-character nonadjacency conditions, the all-odd-q
count, and the resulting uniform mirror P-strategy.  A paper-facing priority claim still requires a
database and forward-citation closure.

A targeted current search on 2026-07-19 used the exact Tranchida title and the combinations
`four involutions`, `four-centre`, `tau-stable`, `PGL(2,q)`, conic, and finite field.  It recovered
Tranchida's updated/published triple work and the adjacent 2026 commuting-involution-graph paper,
whose object is the pairwise commuting graph on a conjugacy class in `PSL_2(q)`, not a
four-centre conic residual or mirror P-strategy.  It found no direct overlap with the bounded C333
core.  Search-result absence is not proof of priority: MathSciNet/zbMATH coverage and a systematic
forward-citation closure remain explicitly open before any unqualified first/novel claim.

The proof trusts finite-field character sums, the Weil bound, the maximal-subgroup classification,
and the standard mirror induction.  The checker does not prove those general results.  It verifies
the coordinate identities and finite instances independently and exhaustively.

Literature artifacts read for the boundary:

- Philippe Tranchida, *Triples of involutions in PGL(2,q) and their incidence geometries*,
  arXiv:2411.10299, cached PDF SHA-256
  `3cf7c453735ab0c6be28e074a4be85d4a3ae4e03d0fc408e7e7d77966aa62656`.
- Michael Giudici, *Maximal subgroups of almost simple groups with socle PSL(2,q)*,
  arXiv:math/0703685, cached PDF SHA-256
  `2c829b573dadf9ee2c71a9f85f92e1fb2d7443f64242dbe4a829c6246d9ae8e9`.

## Evidence and replay

From `/home/tavis/src/othello` run:

```sh
python3 notes/2026-07-18-c333-all-odd-q-mirror-locus.py --check
sha256sum -c notes/2026-07-18-c333-all-odd-q-mirror-locus.sha256
```

The standard-library checker deterministically exhausts all `(delta,b)` in the ten fields
`F_5`, `F_7`, `F_9`, `F_11`, `F_13`, `F_17`, `F_25`, `F_27`, `F_29`, and `F_49`.  It checks the exact
`delta` count, injectivity of the normalized parametrization, all twenty six-arc determinants,
mirror conjugation, deleted-set invariance, mirror nonadjacency, the unipotent word, and both
odd-index subfield trace invariants.  For one canonical member of every field it independently enumerates
the generated projective matrix group, reaching `q(q^2-1)` in all ten cases.  There is no random
seed.  The JSON is canonical, sorted, timestamp-free, and schema-tagged.

| Load-bearing artifact | Bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-18-c333-all-odd-q-mirror-locus.py` | 15,338 | `698a5c02762c7a13ba18b422449c2fea514f7335d25bf0a90b40431c21665a4a` |
| `notes/2026-07-18-c333-all-odd-q-mirror-locus.json` | 7,604 | `e31aa246c2a573d359d489917702b5db960fd90d0100de87cfd6371cdf5b009a` |
