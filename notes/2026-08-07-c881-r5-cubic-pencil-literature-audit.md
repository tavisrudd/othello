# C881 — redundancy-five cubic-pencil literature audit and pre-emption verdict

**Lane:** `reed-solomon`
**Date:** 2026-08-07
**Task card:** `notes/reed-solomon-tasks/c881-kaipa-persona-review-followup.md`
**Trigger:** first-round Krishna Kaipa persona review of the beyond-redundancy-four PRS
paper, supplied by the user 2026-08-07, item 5 ("the full cubic-pencil literature — which
is more relevant than the manuscript currently admits").

## Opening summary

Nine sources are named below.  **Two were read at full text at the load-bearing
statements** (Blokhuis--Pellikaan--Szőnyi; Kaipa--Pradhan incidence), **three at partial
depth** (Günay--Lavrauw; Davydov--Marcugini--Pambianco plane-line; Kaipa--Patanker--Pradhan,
carried from the earlier audit and re-read at the incidence statement), and **four at
abstract/metadata only** (Ceria--Pavese; Kaipa--Pradhan characteristic three;
Davydov--Marcugini--Pambianco orbits-of-lines; Ferraguti--Micheli).

**Verdict: the redundancy-five split-free criterion is, at the level of pencils of binary
cubics, prior art.**  Section `sec:r5` reproves — in different coordinates, uniformly in
characteristic — a classification that the twisted-cubic line-orbit literature already
carries, including the exact \(q\ge 23\) threshold and the genus-one double-point-scheme
argument that produces it.  What survives as ours is the redundancy-five *syndrome* layer:
the divided-power Hankel dictionary carrying a quartic syndrome \(f\) to a pencil \(W_f\),
the exclusion of line classes that no syndrome realizes, the syndrome-orbit inventory
(representatives, sizes, stabilizers, Frobenius fusion), and the covering-radius promotion
to deep holes.  None of the nine sources contains a projective Reed--Solomon deep-hole or
covering-radius statement.

**The manuscript must therefore cite rather than claim the pencil-level geometry.**  It
currently cites none of these works.

## The dictionary that makes the overlap exact

Three identifications, each stated in the sources rather than inferred by us:

1. A line of \(PG(3,q)\) **is** a pencil of binary cubic forms.  Günay--Lavrauw state it
   as an equivalence ("The classification of \(G\)-orbits of lines in \(PG(3,q)\) is
   equivalent to the classification of pencils of cubics in \(PG(1,q)\)", §1);
   Kaipa--Pradhan state it as an identification ("A line \(L\) of \(PG(3,q)\) is a pencil
   of cubic forms", §1).
2. A plane meeting the twisted cubic in three distinct rational points — Blokhuis--
   Pellikaan--Szőnyi's **3-plane**, orbit \(N_3\) of Proposition 3.1, their Remark 3.2
   spelling it out as \(f=(x-\alpha)(x-\beta)(x-\gamma)\) with \(\alpha,\beta,\gamma\)
   distinct in \(\F_q\) — **is** a completely split squarefree cubic.  In the
   Kaipa--Pradhan point picture the same set is the point orbit
   \(O_3=G\cdot XY(X-Y)\) of size \((q^3-q)/6\) (their Lemma 4.1(3)).
3. Consequently **\(f\) is split-free exactly when the line \(W_f\) meets no such plane
   or point**, which is Blokhuis--Pellikaan--Szőnyi's question "is a line of a given class
   contained in a 3-plane?" and Kaipa--Pradhan's Problem 1.1 restricted to \(O_3\).

The reviewer's proposed reformulation \(f\ \text{split-free}\iff W_f\cap O_3=\varnothing\)
is therefore correct, and it is the literature's own formulation, not a new one.

## Per-stratum pre-emption verdict

Our case split is `prop:r5-gcd2`, `prop:r5-gcd1`, the inseparable characteristic-three
case, `lem:cyclic`, `lem:s3`, and the finite bridge `prop:r5-bridge`.  Against
Blokhuis--Pellikaan--Szőnyi Proposition 7.4 (their line classes \(O_1,\dots,O_8\), all
characteristics, \(q\ge 23\)):

| Our statement | Their class | Their verdict | Status |
|---|---|---|---|
| `prop:r5-gcd2`, \(Q\) split | \(O_1\) real chords | in a 3-plane | pre-empted |
| `prop:r5-gcd2`, \(Q=\lambda^2\) (tangent family) | \(O_2\) tangents | not in a 3-plane | pre-empted |
| `prop:r5-gcd2`, \(Q\) irreducible (conjugate-secant family) | \(O_3\) imaginary chords | not in a 3-plane | pre-empted |
| `prop:r5-gcd1` (unisecants, separable) | \(O_4,O_5\) | in a 3-plane, with no \(q\) threshold | pre-empted, and their argument is cleaner than ours |
| `prop:r5-gcd1`, characteristic-two inseparable | \(O_4^-(2)\) | not in a 3-plane | **not** pre-empted — we show no syndrome realizes this line |
| `lem:cyclic`(i), rational ramification | \(O_1'\) real axes | 3-plane iff \(q\equiv1\pmod 3\) | pre-empted |
| `lem:cyclic`(i), conjugate ramification | \(O_3'\) imaginary axes | 3-plane iff \(q\equiv2\pmod 3\) | pre-empted |
| `lem:cyclic`(ii), characteristic-three nucleus | \(O_7(3)\) axis of \(\Gamma_3\) | not in a 3-plane | pre-empted |
| `lem:cyclic`(iii), wild characteristic three | \(O_{8.1}(3)^\pm\), \(O_{8.2}(3)\) | \(O_{8.1}(3)^-\) not in a 3-plane; the others are | pre-empted |
| `lem:s3` | \(O_6\) true passants not in an osculating plane | in a 3-plane for \(q\ge 23\) | pre-empted, same threshold, same argument |

Their Remark 6.12 is our `lem:s3` in their coordinates: the double point scheme is a
genus-one curve, at most twelve points must be excluded (four on the diagonal plus their
partners), the Hasse--Weil bound gives \(|E_\varphi|\ge q+1-2\sqrt q\), and \(q\ge 23\)
forces a triple \(x,y,z\) of distinct rational points with
\(\varphi(x)=\varphi(y)=\varphi(z)\).  Our version replaces Hasse--Weil by the
Aubry--Perret singular-curve bound so that the "simple morphism" hypothesis can be
dropped, and counts the deletions as four on the diagonal plus at most eight branch points
plus one singular point.  The arithmetic lands on the same inequality and the same
\(q\ge 23\).

The finite range is also weaker ground than the manuscript assumes.  Our certificate
closes \(q\in\{7,8,9,11,13,16,17,19\}\), which is exactly the prime powers below the
\(q\ge 23\) threshold.  For the non-generic classes, Davydov--Marcugini--Pambianco
Theorem 3.3 gives the **exact** number of planes of each orbit through each line for
\(q\ge 5\), so the entire non-generic part of our certificate range is decided in the
literature.  For the generic class, Kaipa--Pradhan Theorem 1.3 gives, for
\(\mathrm{char}\,\F_q\neq2,3\) and \(q>4\),
\[
 |S\cap O_3|=\frac{\#E_L(\F_q)-3\eta_L}{3},
\]
with \(\eta_L\in\{0,1,2,4\}\) recording the rational factorization type of the associated
binary quartic \(\varphi_L\).  So a generic line is split-free exactly when
\(\#E_L(\F_q)=3\eta_L\le 12\); with the Hasse bound \(\#E_L\ge q+1-2\sqrt q\), that is
impossible once \(q\ge 23\), and admissible only for \(q\le 19\).  That reproduces our
generic threshold and, unlike our proof, *explains* it.  Note the reviewer quoted this
formula with denominator 6; the published denominator is 3.

Characteristic coverage of the generic class is complete in the literature: Kaipa--Pradhan
for \(\mathrm{char}\neq2,3\), their characteristic-three companion, and Ceria--Pavese for
characteristic two.

## What is not pre-empted

- The reduction itself.  No source treats redundancy-five projective Reed--Solomon
  syndromes, the divided-power Hankel kernel \(f\mapsto W_f\), or which lines of
  \(PG(3,q)\) arise as \(W_f\).  The characteristic-two inseparable case is the visible
  payoff: the line class \(O_4^-(2)\) exists and is split-free, but no rank-two syndrome
  realizes it, which is a syndrome-level fact invisible in the pencil literature.
- The syndrome-orbit inventory of Table `tab:r5sporadic` — canonical representatives in
  divided-power syndrome coordinates, orbit sizes, stabilizer orders, Frobenius fusion.
  The incidence tables count points of a line by orbit; they do not produce syndrome
  representatives.
- Extracting an explicit split-free list from Kaipa--Pradhan Theorem 1.3 still requires
  evaluating \(\#E_L\) and \(\eta_L\) across the \(2q-3+\mu\) generic line orbits.  Their
  theorem is a criterion; our certificate is an enumeration at syndrome level.
- The covering-radius promotion (`prop:r5-radius`) and the deep-hole conclusion.
- Everything at redundancy six and above: coherent polar induction, the recursive carrier
  theorem, the Lucas carriers, and the fixed-level classifications.  This audit found no
  contact between that material and the twisted-cubic line literature.

## Why the earlier audits missed it

Recorded so the same gap is not reopened, not as a correction trail.

The C491 audit (`notes/2026-07-22-c491-prs-literature-audit-searchlog.md`) ran a
three-graph forward-citation screen seeded on the coding papers — Kaipa 2017
(`arXiv:1612.05447`) and Zhang--Wan--Kaipa (`arXiv:1901.05445`) — with the discriminator
"does this state a `PRS(q-4)` / redundancy-five deep-hole or covering-radius
classification?".  The twisted-cubic line-orbit literature does not cite those coding
seeds and contains no coding-theory content, so it could not enter that screen and would
have failed the discriminator if it had.

The gap is visible in the log's own text.  It records the Semantic Scholar author listing
for Kaipa, naming both `2509.15332` ("Incidence of lines, points, and planes in
\(PG(3,q)\)") and the characteristic-three orbit paper, and screens them out with "No
paper titled/abstracted as a `PRS(q-4)` or redundancy-five deep-hole / covering-radius
classification."  It also promotes `arXiv:2312.07118` for individual discussion, calls it
"the strongest caveat in the whole audit", and concludes "Reads as foundational/adjacent,
not pre-emptive."  Every one of those statements is true about *deep holes* and wrong
about the *pencil criterion the manuscript actually proves*.

The missing step was a geometry-side discriminator applied to the object in the proof
rather than to the theorem's coding wrapper: **does any work decide whether a pencil of
binary cubics contains a totally split squarefree member, equivalently whether a line of
\(PG(3,q)\) lies in a plane meeting the twisted cubic in three rational points?**  Run
now, that question resolves in one search.

Two record defects, carried forward for repair:

- `papers/beyond4_prs/literature-audit.md` lists `KPP2025` as **partial**, cache key
  `arXiv:2312.07118`, SHA-256 `2ea8efc0…`; the C491 log lists the same key at **full
  text** with SHA-256 `d88edd66…6702d494`.  Two hashes and two depths for one key.  The
  cache currently holds `2ea8efc04bbf42be0919288e5e3777a4010ae30940bf8fec3a5c32feef789752`,
  fetched 2026-07-19.  The `d88edd66…` bytes are not in the cache and cannot be checked.
- `arXiv:2103.16904` has been in the shared cache since 2026-07-19 and is characterised in
  four other lanes' notes, including `notes/2026-07-20-c405-twisted-cubic-deep-hole-pilot.md`
  (partial, pages 1--5) and `notes/handoffs/2026-07-13-twisted-cubic-transversal-spectrum.md`.
  It never reached this paper's bibliography or audit.  Cross-lane cache presence is not a
  substitute for a lane's own screen, and this is the failure it produces.

## Sources

Read depth is recorded for every source, including those named only to place them.

- **Blokhuis, Pellikaan, Szőnyi**, *The extended coset leader weight enumerator of a
  twisted cubic code*, Des. Codes Cryptogr. **90** (2022), no. 9, 2223--2247;
  `arXiv:2103.16904`.  **Full text at the load-bearing statements** — §1 introduction,
  §3 (Propositions 3.1 and 3.3, Remark 3.2: the plane and point orbits), §5.2
  (Proposition 5.5: lines of \(P^d\) versus rational functions of degree \(d\)), §6
  (Definitions 6.1--6.8, Propositions 6.9--6.10, Corollary 6.11, Remark 6.12: the double
  point scheme, genus one, and the \(q\ge 23\) bound), §7.1 (Theorem 7.1: the partition of
  lines), §7.2 (Proposition 7.4 with its full proof, Remarks 7.5--7.6, Theorem 7.7).
  Version read: arXiv preprint text as cached; the published DCC version was **not**
  consulted, and the bibliographic detail above comes from the Kaipa--Pradhan reference
  list, a consulted source.  Cache key `arXiv:2103.16904`, SHA-256
  `b406b2170b883eaa427649f93b92965dcac1cfbbaa537bef201bcd7a7bca8297`, fetched 2026-07-19.
- **Kaipa, Pradhan**, *Incidence of lines, points and planes in \(PG(3,q)\) with respect to
  the twisted cubic*, `arXiv:2509.15332v1` (18 Sep 2025).  **Full text at the load-bearing
  statements** — abstract, §1 including the literature map and Problems 1.1--1.2, §1.1
  (the binary-quartic invariants \(I,J\), the discriminant, \(\eta_L\), the elliptic curve
  \(E_L\), and Theorem 1.3), §2 geometric setup, Lemma 4.1 (the five point orbits).  Cache
  key `arXiv:2509.15332`, SHA-256
  `f11b17aeebe9c4fca18c1486853664cb1fd075e24ceb2e0156023e1d529ee726`, fetched 2026-08-07.
- **Günay, Lavrauw**, *On pencils of cubics on the projective line over finite fields of
  characteristic \(>3\)*, Finite Fields Appl. **78** (2022), Paper No. 101960;
  `arXiv:2104.04756v1`.  **Partial** — abstract and §1 introduction, for the
  lines-equal-pencils equivalence and the scope of their point-orbit and plane-orbit
  distributions (ten non-generic orbits, \(q\) odd and not divisible by 3).  Their tables
  were not read line by line.  Cache key `arXiv:2104.04756`, SHA-256
  `8aa3eb759c0d904cef7d5ef515bf57bd09306c3e11cd1392d415f54c95c198fd`, fetched 2026-08-07.
- **Davydov, Marcugini, Pambianco**, *Twisted cubic and plane-line incidence matrix in
  \(PG(3,q)\)*, J. Geom. **113** (2022), no. 2, Paper No. 29; `arXiv:2103.11248v3`.
  **Partial** — abstract, introduction, and the statement of Theorem 3.3 (exact numbers of
  planes of each orbit through each line of each orbit, \(q\ge 5\), averages only for the
  special class).  The tables were not read.  Cache key `arXiv:2103.11248`, SHA-256
  `65c1f5733ea39690e380c703402172da31211e870bd446f240e452fe7a2ce9fd`, fetched 2026-08-07.
- **Davydov, Marcugini, Pambianco**, *Twisted cubic and orbits of lines in \(PG(3,q)\)*,
  `arXiv:2103.12655`; published as *Orbits of lines for a twisted cubic in \(PG(3,q)\)*,
  Mediterr. J. Math. **20** (2023), no. 3, Paper No. 132.  **Abstract/metadata only** —
  retrieved as the source of the line-orbit partition that Blokhuis--Pellikaan--Szőnyi
  Remark 7.3 credits (their Theorem 3.1) and that Kaipa--Pradhan credit for the ten
  non-generic orbits.  Cache key `arXiv:2103.12655`, SHA-256
  `dac803660c5a0302c92f5cdc589bda29014299c8c1acff37e246fa474809ecc8`, fetched 2026-08-07.
- **Kaipa, Pradhan**, *On the \(PGL_2(q)\)-orbits of lines of \(PG(3,q)\) and binary quartic
  forms in characteristic three*, Finite Fields Appl.; `arXiv:2508.11229`.
  **Abstract/metadata only** — retrieved and cached; relied on only for the statement,
  made in Kaipa--Pradhan `arXiv:2509.15332` §1, that it settles Problems 1.1 and 1.2 for
  all generic-line orbits in characteristic three.  That characterisation is
  `secondary only` through a source read at full text.  Cache key `arXiv:2508.11229`,
  SHA-256 `df3c5785a0da7ed877a060d73663cfffdd53eabb13e7a57128bdbb7341804aaf`, fetched
  2026-08-07.
- **Ceria, Pavese**, *On the geometry of a \((q+1)\)-arc of \(PG(3,q)\), \(q\) even*,
  Discrete Math. **346** (2023), no. 12, Paper No. 113594; `arXiv:2208.00503`.
  **Abstract/metadata only**, via web search result listing; not fetched or cached.  Its
  role — solving Problem 1.1 for all lines in characteristic two — is taken from
  Kaipa--Pradhan `arXiv:2509.15332` §1, so that role is `secondary only` through a
  full-text source.  The reviewer's assertion that Ceria--Pavese settled the
  characteristic-two case is thereby confirmed at secondary depth, **not** verified
  against the paper.
- **Kaipa, Patanker, Pradhan**, *On the \(PGL_2(q)\)-orbits of lines of \(PG(3,q)\) and
  binary quartic forms*, `arXiv:2312.07118`.  **Partial** — the earlier audit's read
  (abstract, introduction, orbit-classification statements) plus, this session, the
  role assigned to it in Kaipa--Pradhan `arXiv:2509.15332` §1 as the source of the
  generic-line orbit decomposition for \(\mathrm{char}\neq2\).  Cache key
  `arXiv:2312.07118`, SHA-256
  `2ea8efc04bbf42be0919288e5e3777a4010ae30940bf8fec3a5c32feef789752`; see the hash
  discrepancy recorded above.
- **Ferraguti, Micheli**, *Full classification of permutation rational functions and
  complete rational functions of degree three over finite fields*, Des. Codes Cryptogr.
  **88** (2020), no. 5, 867--886.  **Abstract/metadata only** — not fetched.  Named
  because Blokhuis--Pellikaan--Szőnyi Remark 7.6 reports that its six degree-three
  permutation rational functions match the split-free entries of their Proposition 7.4
  table, which makes it an independent third route to the same classification.  The
  bibliographic detail comes from the Blokhuis--Pellikaan--Szőnyi reference list, a
  consulted source; the match is their claim and is **unverified against Ferraguti--Micheli**.

## Screened set

**Set:** works citing Blokhuis--Pellikaan--Szőnyi, resolved by DOI
`10.1007/s10623-022-01060-0`.  Counts obtained independently and recorded separately:
**OpenAlex 13** (`W3148163570`), **Crossref 10**, **Semantic Scholar 21**
(`18da046b2cacc19312cdb85421ffc59dbdc11b8f`).  The three disagree; that disagreement is
itself the finding the convention anticipates.  The largest set (Semantic Scholar, 21) was
screened over title, year, and external identifiers.

**Discriminator, applied verbatim:** does the citing work state a projective Reed--Solomon
deep-hole, covering-radius, or syndrome classification at redundancy five or higher?

**Result:** none.  The set is the twisted-cubic orbit and incidence school
(Davydov--Marcugini--Pambianco and successors, Günay--Lavrauw, Kaipa--Pradhan,
Ceria--Pavese, the class-\(O_6\) incidence papers) plus two MDS coset weight-distribution
papers, `arXiv:2101.12722` (*On the weight distribution of the cosets of MDS codes*) and
`arXiv:2605.10594` (*Weight distributions of cosets of weight 2 of the generalized doubly
extended Reed--Solomon code*).  Neither of the latter two was read beyond its title, and
neither is a redundancy-five classification; they are logged as the nearest coding-side
neighbours of the geometry school and as candidates for the error-distribution direction,
not screened out on a claim about their contents.

Each source promoted out of this set for individual discussion carries its own read depth
in the Sources section above.

## Coverage statement

- **Searched and found nothing** — the citing set above, under the stated discriminator,
  contains no redundancy-five projective Reed--Solomon result.  This licenses the narrowed
  novelty claim.
- **Could not access, licenses nothing:** MathSciNet (institutional authentication, not
  reachable from this session) — the "to our knowledge" qualification it would have gated
  remains in force.  The published Designs, Codes and Cryptography version of
  Blokhuis--Pellikaan--Szőnyi (preprint read instead), the Ceria--Pavese paper, the
  Ferraguti--Micheli paper, and the Finite Fields and Their Applications version of the
  Kaipa--Pradhan characteristic-three paper were not obtained at full text.  None of the
  verdicts above rests on the unread portion of those four: the pre-emption finding rests
  on Blokhuis--Pellikaan--Szőnyi and Kaipa--Pradhan `arXiv:2509.15332`, both read at full
  text at their load-bearing statements.
- No backward screen was run on the pre-1985 twisted-cubic literature beyond what
  Hirschfeld's *Finite projective spaces of three dimensions* supplies through the four
  sources that cite it.  Recorded as an open gap; it bears on attribution priority within
  the geometry school, not on our delta.

## Required repairs

1. `papers/beyond4_prs/refs.bib` — add all nine works.
2. `papers/beyond4_prs/sections/01-introduction.tex` — rewrite the related-work paragraph;
   the current sentence dismissing `KPP2025` as "adjacent normal-form geometry for the
   redundancy-six problem" is false and must go.
3. `papers/beyond4_prs/sections/04-redundancy-five.tex` — state the
   \(W_f\cap O_3=\varnothing\) formulation, and attribute each stratum to its line class.
4. `papers/beyond4_prs/claim-proof-novelty-ledger.md` — narrow the R5 row to the syndrome
   layer; the novelty text has one home and this is it.
5. `papers/beyond4_prs/literature-audit.md` — add the sources with their read depths, the
   screened set, and the coverage statement, and repair the `KPP2025` hash/depth
   discrepancy.

Surfaces that repeat the R5 novelty claim and must be checked when the ledger row changes:
the manuscript introduction, the claim--proof--novelty ledger, the literature audit, the
handoff, and the published Version 1 release artifacts.  Version 1 is immutable and its
copies are **not** updated by this task; that is a user decision recorded as open.
