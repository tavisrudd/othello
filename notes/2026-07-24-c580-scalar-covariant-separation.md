# C580 — bounded scalar blindness versus marginal-covariant rigidity

**Lane:** `ame-lu`

**Date:** 2026-07-24

**Status:** complete; theorem proved, optional manuscript corollary only

## Result

Fix a positive integer \(M\).  Outside a finite set of rational
characteristics depending on \(M\), every sufficiently large prime power
\(q\) has two admitted parameters \(t,u\in\mathbb F_q\) such that

\[
 z(t)\ne z(u),
\]

but every scalar local-unitary invariant of the associated equal-phase
six-qudit CSS states of bidegree \((m,m)\), \(m\leq M\), takes the same
value on \(\Psi_t\) and \(\Psi_u\).

Nevertheless \(\Psi_t\) and \(\Psi_u\) are not LU-equivalent, even after
party permutation.  Their one-copy four-party marginal covariants force
every hypothetical LU intertwiner to be LC by C560, while C396's scalar
\(z\) distinguishes their LC classes.

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

For all sufficiently large \(q\), this set has more than eight elements.
The rational map \(t\mapsto z(t)\) has degree eight by C396, and its
specialization remains nonconstant outside the already excluded finite
set of characteristics.  No \(z\)-fiber can therefore contain all of
\(U_M(\mathbb F_q)\).  Choose \(t,u\in U_M(\mathbb F_q)\) with
\(z(t)\ne z(u)\).  All scalar invariants through degree \(M\) agree, but
C396 gives LC-inequivalence and C560 upgrades it to LU-inequivalence.

This proves the theorem.

## What is and is not new in the mechanism

The rank-one diagonal-axis argument itself remains the
Rains--Van den Nest mechanism, extended in C560 to the full finite-field
Weyl basis.  C580's additional mechanism is the categorical contrast

```text
bounded-copy scalar invariants:  retain only finite-field solution ranks
one-copy marginal covariants:    retain the intrinsic local operator axes
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
points, and using the degree-eight \(z\)-map.  No computation or explicit
bound on \(\deg D_M\) is required.

The second upgrade is expository: the contrast is not “invariants fail,
marginals succeed.”  A marginal is itself a low-degree **covariant**.
The exact lesson is that scalarization destroys the local frame while the
covariant retains it.  This gives the paper a clean conceptual bridge from
C559 to C560 without competing with the Rains attribution.

## Mystery ledger

| Feature | Closeout status | Remaining gap or owner |
|---|---|---|
| Whether bounded scalar copy degree can classify the pencil uniformly in \(q\) | **Settled negatively** by the theorem above | No remaining proof gap |
| Why a one-copy marginal can outperform every fixed scalar degree | **Settled conceptually:** it retains the moving operator axes as covariant data | C581 may sharpen this to intrinsic phase-space reconstruction |
| Whether the minimum separating degree has a quantitative growth rate in \(q\) | Open; C580 proves only unboundedness | Not queued; would require effective degree control on the common generic-rank polynomial |
| Whether C580 has an exact literature predecessor | Open beyond the bounded screen | C571/C572 manual literature gates if novelty wording is ever proposed |
| Whether exact rigidity is stable under perturbation | Open | C581 |

**Vibe check:** excellent cheap synthesis.  The prior-art correction remains
intact, while the negative and positive results now combine into a
different, sharper theorem that is not merely a qudit restatement of
Rains.
