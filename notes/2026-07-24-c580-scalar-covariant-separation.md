# C580 — bounded scalar blindness versus marginal-covariant rigidity

**Lane:** `ame-lu`

**Date:** 2026-07-24

**Status:** complete; theorem proved, optional manuscript corollary only

## Result

Fix a positive integer \(M\).  Outside a finite set of rational
characteristics depending on \(M\), every sufficiently large prime power
\(q\) has a packet of at least

\[
 \left\lceil\frac{q-d_M}{8}\right\rceil
\]

pairwise LU-inequivalent admitted states, where \(d_M\) is the degree of
one \(M\)-dependent generic-rank exclusion polynomial, such that every
scalar local-unitary invariant of bidegree \((m,m)\), \(m\leq M\), takes
the same value on the entire packet.

The states are inequivalent even after party permutation.  Their
algebraic-degree-one four-party marginal covariants force every
hypothetical LU intertwiner to be LC by C560, while C396's scalar \(z\)
distinguishes their LC classes.

Equivalently, no copy bound independent of \(q\) makes scalar polynomial
LU invariants complete on the admitted pencil.  By contrast, the
operator-valued four-party marginal has fixed copy complexity and already
recovers the local Weyl axes needed for orbit rigidity.

This is a synthesis theorem: C559 supplies bounded-degree blindness,
C560 supplies fixed-complexity covariant rigidity, and C396 supplies the
degree-eight LC quotient.  It adds no hypothesis to those results.

## Proof

Choose the displayed generator \(G(t)\) for the admitted linear
\([6,3,4]\) pencil.  For a copy number \(m\) and a local permutation
diagram

\[
 \boldsymbol{\sigma}\in S_m^6,
\]

C559 associates a homogeneous linear system
\(M_{\boldsymbol{\sigma}}(G(t))\).  Its contraction value after
specialization to \(\mathbb F_q\) is

\[
 I_{\boldsymbol{\sigma}}(\Psi_t)
   =q^{\,3m-\operatorname{rank}
          M_{\boldsymbol{\sigma}}(G(t))}.                 \tag{1}
\]

For each of the finitely many diagrams with \(m\leq M\), take its generic
rank over \(\mathbb Q(t)\) and choose one nonzero maximal minor witnessing
that rank.  Multiply these witnesses, the admitted-locus polynomial, the
denominators used by the displayed pencil, and a polynomial witnessing
that \(z\) is nonconstant.  Call the resulting nonzero polynomial
\(D_M(t)\).

Only finitely many rational primes make the reduction of \(D_M\)
identically zero.  In every other characteristic, all diagram ranks with
\(m\leq M\) are simultaneously generic on

\[
 U_M(\mathbb F_q)
   =\{t\in\mathbb F_q:D_M(t)\ne0\}.
\]

Equation (1) is therefore independent of \(t\) on \(U_M(\mathbb F_q)\)
for every such diagram.

The first fundamental theorem for the product local-unitary action says
that the degree-\((m,m)\) scalar invariants are spanned by these
permutation contractions; \(q\geq m\) is the stable range in which the
usual diagram description has no dimension-induced ambiguity.  Hence
every scalar invariant through copy degree \(M\) is constant on
\(U_M(\mathbb F_q)\).

If \(d_M=\deg D_M\), then

\[
 |U_M(\mathbb F_q)|\geq q-d_M.
\]

The rational map \(t\mapsto z(t)\) has degree eight by C396, and its
specialization remains nonconstant outside the already excluded finite
set of characteristics.  Every \(z\)-fiber has at most eight parameters,
so \(U_M(\mathbb F_q)\) meets at least

\[
 \left\lceil |U_M(\mathbb F_q)|/8\right\rceil
 \geq
 \left\lceil(q-d_M)/8\right\rceil
\]

distinct \(z\)-fibers.  Choose one parameter from each.  All scalar
invariants through degree \(M\) agree across the resulting packet, while
C396 gives pairwise LC-inequivalence and C560 upgrades it to pairwise
LU-inequivalence.

This proves the theorem.

## Operational corollary and its boundary

Let \(E\) be an outcome operator of an \(m\)-copy measurement invariant
under the diagonal action of the local-unitary group.  Its outcome
probability

\[
 \operatorname{Tr}\!\left(
   E\bigl(|\Psi_t\rangle\langle\Psi_t|\bigr)^{\otimes m}
 \right)
\]

is a scalar LU invariant of bidegree \((m,m)\).  Therefore no
LU-invariant measurement using at most \(M\) copies can distinguish any
two members of the packet above; every outcome distribution agrees.
Equivalently, the copy complexity of a uniformly complete
invariant scalar protocol is unbounded as \(q\) varies.

This is not a lower bound for unrestricted tomography or for a protocol
allowed to retain basis-dependent, operator-valued output.  The
four-party marginal is precisely such a covariant output: it transforms
rather than remaining fixed under local basis changes.  C560 exploits
that retained frame information, so there is no contradiction between
the scalar measurement lower bound and algebraic-degree-one covariant
rigidity.  “Degree one” here describes dependence on one ket and one bra;
estimating the marginal experimentally may require many physical
specimens, and C580 supplies no tomography sample bound.

If the supplied state is chosen uniformly from the packet, every such
\(M\)-copy invariant measurement has the same conditional outcome
distribution for every class.  Its transcript therefore has exactly zero
mutual information with the class label.  The residual ambiguity contains
at least
\(\log_2\lceil(q-d_M)/8\rceil\) bits.  This is a zero-information
statement for the stated invariant protocol class, not a quantitative
lower bound for frame-sensitive tomography.

There is a stronger nuisance-frame formulation.  Let the class label \(J\)
be uniform on the packet, choose an independent Haar-random local unitary
\(g\in U(q)^6\), and give an arbitrary measurement \(M\) copies of
\(g|\Psi_J\rangle\).  For any outcome operator \(E\), averaging its
probability over \(g\) replaces \(E\) by its local-unitary twirl

\[
 \overline E
  =\int_{U(q)^6}
    (g^\dagger)^{\otimes M} E g^{\otimes M}\,dg.
\]

The twirled operator is invariant, so its expectation is one of the blind
degree-\((M,M)\) scalar invariants.  Hence the outcome distribution of
**every** \(M\)-copy measurement, not only an invariant measurement, is
independent of \(J\) under the Haar-random unknown-frame model.  In
particular no protocol can classify the packet uniformly over all local
frames with success better than prior guessing: such a protocol would
retain the same advantage after averaging, contradicting the twirled
calculation.

## Classical coding corollary

The same packet consists of pairwise monomially inequivalent linear
\([6,3,4]_q\) codes.  For every diagram
\(\boldsymbol{\sigma}\in S_m^6\), \(m\leq M\), its complete contraction
system rank

\[
 \operatorname{rank}
 M_{\boldsymbol{\sigma}}(G(t))
\]

is identical across the packet.  Thus, outside the same finite
characteristic set and for sufficiently large \(q\), there are at least

\[
 \left\lceil\frac{q-d_M}{8}\right\rceil
\]

pairwise monomially inequivalent MDS codes having the same entire
bounded-copy contraction-rank profile.

This classical corollary is stronger than equality of selected quantum
invariants: it identifies the exact finite-field data discarded by every
scalar contraction through \(M\) copies.  No claim is made that these
profiles coincide with a standard coding-theoretic equivalence notion or
with all bounded-size code statistics.

## What is and is not new in the mechanism

The rank-one diagonal-axis argument itself remains the
Rains--Van den Nest mechanism, extended in C560 to the full finite-field
Weyl basis.  C580's additional mechanism is the categorical contrast

```text
bounded-copy scalar invariants:           retain only finite-field solution ranks
algebraic-degree-one marginal covariants: retain the intrinsic local operator axes
```

Scalarization discards the moving basis information before orbit
comparison.  The four-party reduced operator keeps that information and
forces a continuous product-unitary problem into the finite Clifford
normalizer.  Thus C559's failed route and C560's successful route are two
sides of one separation theorem, rather than unrelated negative and
positive results.

This does not contradict finite-generation or degree-bound theorems for a
fixed Hilbert-space dimension.  Here the local dimension \(q\) varies, and
the conclusion is precisely that a separating degree bound cannot remain
constant across this family.

## Bounded precedence screen

The screen was designed to distinguish C580 from three adjacent bodies of
work: diagrammatic descriptions of LU invariants, dimension-dependent
upper bounds for complete invariant sets, and polynomial-method lower
bounds for black-box unitary property testing.

No screened source states the displayed six-party MDS/CSS lower-bound
family or combines bounded-degree scalar blindness with a fixed-copy
operator-covariant rigidity certificate.  This is only a bounded
precedence screen, not a priority proof.  The manuscript may present C580
as a consequence of C559+C560, but no “first” or independent novelty claim
is authorized.

The screen discussed four individual sources: **zero at `full text`, two
at `partial`, and two at `abstract/metadata only`**.

1. **Jacob Turner and Jason Morton, _A Complete Set of Invariants for
   LU-Equivalence of Density Operators_.**  **Read depth: `partial`.**
   Cached published-version arXiv text
   `arXiv:1507.03350v9`, SHA-256
   `a16a4fbd74788b9b35282c117cdc0330221f52c112a11e398ce59e37de90de02`;
   read the abstract, Introduction, Theorem 4.7, Corollaries 4.8--4.11,
   and their surrounding proofs.  It proves completeness and
   dimension-dependent upper bounds for polynomial invariants of density
   operators.  It supplies the correct fixed-dimension contrast but no
   lower-bound family of the form proved here.

2. **Adrian She and Henry Yuen, _Unitary Property Testing Lower Bounds by
   Polynomials_.**  **Read depth: `partial`.**  Published ITCS metadata,
   cached preprint `arXiv:2210.05885v2`, SHA-256
   `d601cb167e633254b09857564ea3b1a30ba0c8bdd9890ffcea60ab54e33d3f9e`;
   read the abstract, Sections 1.1--1.2.1, and Section 5.1.  The paper
   converts bounded-query tests of black-box unitary properties into
   bounded-degree invariant polynomials and uses this for query lower
   bounds.  That is a methodological analogue, but its object is an
   unknown unitary and its local-unitary section treats matrix invariants,
   not pairwise orbit separation of the present state family.

3. **Péter Vrana, _On the algebra of local unitary invariants of pure and
   mixed quantum states_.**  **Read depth: `abstract/metadata only`.**
   The arXiv abstract and identifier `arXiv:1101.2514` were retrieved.
   It studies the stable graded invariant algebra and its Hilbert series;
   the abstract does not state an orbit-separation degree lower bound.

4. **Szilárd Szalay, _All degree 6 local unitary invariants of \(k\)
   qudits_.**  **Read depth: `abstract/metadata only`.**  Title, year,
   zbMATH identifier `6012406`, and abstract-level search metadata were
   retrieved.  It explicitly enumerates low-degree invariants rather than
   proving a dimension-growing separation requirement.

### Screened sets

OpenAlex was queried on 2026-07-24 in relevance order, requesting 25
records and the fields
`id,doi,title,publication_year,abstract_inverted_index`.
The mechanical discriminator was:

> Promote a record when its title or abstract concerns (a) degree lower
> bounds for local-unitary invariant orbit separation, (b) dimension
> dependence of complete LU invariant sets, or (c) scalar invariants
> versus operator-valued covariants for quantum-state equivalence.

| Verbatim `search` value | Raw count | Screened | Outcome |
|---|---:|---:|---|
| `"local unitary invariants" degree lower bound` | 33 | first 25 | No exact lower-bound family; promoted the general degree-bound literature for individual inspection. |
| `"local unitary invariants" degree bound` | 47 | first 25 | Promoted Turner--Morton and the withdrawn Turner upper-bound preprint; no matching lower bound. |
| `"local unitary" covariant rigidity quantum states` | 14 | all 14 | No matching scalar/covariant separation theorem. |

zbMATH Open was queried with `results_per_page=100`.  The exact search
`"local unitary invariants" degree` returned five records and all five
titles were screened: Szalay, a mixed-two-qutrit paper, Vrana,
Turner--Morton, and a withdrawn Turner preprint.  The exact search
`local unitary covariant` returned 85 records; all 85 titles were screened
with the discriminator above and none was promoted.  The exact search
`local unitary rigidity quantum states` returned one record, whose title
did not match the discriminator.  Each successful response reported
`execution_bool=true`.

Broad web discovery used the exact queries

```text
"local unitary invariants" degree bound quantum states polynomial
"local unitary invariants" unbounded degree qudit
"local unitary" covariants reduced density matrices stabilizer rigidity
"Schur-Weyl" "local unitary invariants" quantum states
"scalar invariants" covariants "local unitary" quantum
"local unitary" "covariant" "degree bound" quantum state
"local unitary invariants" "unbounded" qudits
"local unitary invariants" "lower bound" qudits
```

The results were dominated by fixed-dimension completeness,
low-degree enumeration, and upper-bound papers.  She--Yuen was the closest
lower-bound methodology but addresses a different input model.

### Coverage gaps

- MathSciNet and Google Scholar were **NOT COVERED**.
- No forward-citation graph was enumerated because C580 authorizes no
  novelty or priority claim.
- Vrana and Szalay were not read beyond abstract/metadata level.
- The withdrawn Turner preprint was not used as evidence; the
  Turner--Morton published result supplies the needed upper-bound context.

The safe posture is therefore “a new consequence of our preceding
theorems” without a claim that polynomial invariant-degree lower bounds
are new in general.

## Adoption and follow-up boundary

C580 is cheap enough to include as a corollary or conceptual discussion
after C559 and C560.  It does not alter C561's headline, title, theorem
dependency, or exceptional-characteristic table.

C581 owns the two non-cheap upgrades:

1. basis-free reconstruction of the local Heisenberg/symplectic phase
   space from the rank-one contraction locus; and
2. a quantitative perturbation theorem turning exact axis recovery into
   approximate LU-to-LC rigidity.

Neither is assumed here.

## `ej` and Tao closeout

The main cheap upgrade is the quantifier order.  C559 says that each fixed
degree is generically constant; C580 turns this into an orbit-separation
lower bound by intersecting all degrees through \(M\), counting rational
points, and using the degree-eight \(z\)-map.  The same count gives a
linearly growing packet of at least
\(\lceil(q-d_M)/8\rceil\) pairwise inequivalent states, not merely one
hard pair.  No computation or explicit bound on \(\deg D_M\) is required.

The second upgrade is expository: the contrast is not “invariants fail,
marginals succeed.”  A marginal is itself a low-degree **covariant**.
The exact lesson is that scalarization destroys the local frame while the
covariant retains it.  This gives the paper a clean conceptual bridge from
C559 to C560 without competing with the Rains attribution.

The third free corollary is operational.  Every outcome probability of an
\(M\)-copy LU-invariant measurement lies in the blind scalar sector, so
the packet is indistinguishable by any such measurement.  This licenses a
precise invariant-protocol copy-complexity statement, but not an
unrestricted tomography or query-complexity claim.

The `ej2` pass adds two consequences without another proof.  Uniformly
sampling the packet makes every allowed scalar transcript statistically
independent of the class label, leaving logarithmically growing class
ambiguity.  Forgetting the quantum interpretation entirely gives
\(\Omega(q)\) pairwise monomially inequivalent MDS codes with identical
full contraction-rank profiles through copy degree \(M\).  This is the
cleanest indication that the phenomenon belongs to the finite-field
solution-count geometry, not only to quantum invariant terminology.

The Tao stress test found the exact operational strengthening and the
needed caveat.  Haar-randomizing the unknown local frame twirls any
measurement into the invariant sector, so arbitrary \(M\)-copy
measurements have zero class information in that nuisance-frame model.
Conversely, calling the marginal “one-copy” could be misread as a
single-specimen tomography claim; the correct phrase is
**algebraic-degree-one covariant rigidity**.

## Mystery ledger

| Feature | Closeout status | Remaining gap or owner |
|---|---|---|
| Whether bounded scalar copy degree can classify the pencil uniformly in \(q\) | **Settled negatively** by the theorem above; one invariant vector contains at least \(\lceil(q-d_M)/8\rceil\) LU classes | No remaining proof gap |
| Whether the failure has an operational copy interpretation | **Settled for LU-invariant scalar measurements:** all outcome distributions agree through \(M\) copies | Unrestricted tomography is explicitly outside the claim |
| How much class information such a protocol retains on the packet | **Settled:** zero mutual information under the uniform prior, with at least \(\log_2\lceil(q-d_M)/8\rceil\) bits of residual ambiguity | No claim for covariant or frame-sensitive protocols |
| Whether restricting the POVM itself to be invariant is necessary | **Settled negatively under a Haar-random unknown local frame:** twirling reduces every POVM to the blind invariant sector | A known external frame remains outside the lower bound |
| Whether “one-copy covariant” is an experimental sample-complexity claim | **Settled negatively:** it means algebraic bidegree \((1,1)\) only | C580 gives no marginal-estimation sample bound |
| Whether the blindness has a purely classical shadow | **Settled:** the packet gives pairwise monomially inequivalent MDS codes with identical complete contraction-rank profiles through \(M\) copies | Relation to standard code-statistic hierarchies is not claimed |
| Why an algebraic-degree-one marginal can outperform every fixed scalar degree | **Settled conceptually:** it retains the moving operator axes as covariant data | C581 may sharpen this to intrinsic phase-space reconstruction |
| Whether the minimum separating degree has a quantitative growth rate in \(q\) | Open; C580 proves only unboundedness | Not queued; would require effective degree control on the common generic-rank polynomial |
| Whether C580 has an exact literature predecessor | Open beyond the bounded screen | C571/C572 manual literature gates if novelty wording is ever proposed |
| Whether exact rigidity is stable under perturbation | Open | C581 |

**Vibe check:** excellent cheap synthesis.  The prior-art correction remains
intact, while the negative and positive results now combine into a
different, sharper theorem that is not merely a qudit restatement of
Rains.
