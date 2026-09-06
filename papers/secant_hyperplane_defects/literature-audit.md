# Literature audit

## Scope and bounded finding

This audit supports the literature positioning of *Secant–hyperplane
defects of complete caps*.  It consolidates two recorded audits: the
C1075 literature check of the three `PG(4,q)` exclusions and the
hyperplane-excess constraint (`notes/2026-09-06-c1075-cap-exclusion-literature.md`,
fifteen ledger entries, five at full text) and the C1078 citation
verification (`notes/2026-09-06-c1078-citation-verification.md`, two
further sources at full text, one preprint at full text, four at partial
depth).  Across both, seven sources were read at full text, and every
source named below carries its read depth.

The global counting bound, the complete-cap/quasi-perfect-code dictionary,
the hyperplane character equations, the Pless power moments, and counting
over hyperplanes through a fixed subspace are classical.  No inspected
source states the two-sided hyperplane loss constraint `0 ≤ Q(s) ≤ Λ_0`,
the resulting admissible set of section sizes, or an exclusion of a
counting-bound cap size in `PG(d,q)`, `d ≥ 4`.  The one-sided inequality
`Q(s) ≥ 0` was not located as a stated inequality either, but it is a
one-line consequence of completeness and is treated as expected folklore.
This is a bounded finding about the searches and texts recorded below,
not an exhaustive priority claim.

## Claim boundaries

| Manuscript claim | Classical material credited | Search outcome |
|---|---|---|
| Hyperplane loss identity, two-sided | The global covering count; the character equations | `Q(s) ≥ 0` not located as stated; `Q(s) ≤ Λ_0` and the admissible set not located. Nearest relative: Wehlau's classification of complete caps of `PG(n,2)` missing a codimension-two subspace by hyperplane intersection sizes (different mechanism). |
| Secant–hyperplane moments | Pless (1963) power moments; Thas (arXiv:1710.02512) counting over hyperplanes through a plane | No source states the moments through a secant with `T_ℓ` isolated; not claimed as new in content. |
| Exclusions at the counting bound, `d ≥ 4` | The trivial bound `√2 q^{(d−1)/2}` quoted as current by Bartoli–Davydov–Kreshchuk–Marcugini–Pambianco (arXiv:1610.09656), Davydov–Faina–Marcugini–Pambianco (arXiv:1706.01941), Bartoli–Faina–Marcugini–Pambianco (J. Geom. 108) | No lower-bound improvement or nonexistence result for complete caps in `PG(d,q)`, `d ≥ 3`, located in OpenAlex, Crossref, arXiv, zbMATH Open (C1075 §Q3, four indexes, screen discriminator recorded). |
| Perfect-code caps | Pavese, Proposition 3.1 (equality cases of the 4-general counting bound) | Read at full text (preprint v1); published version not read. Pavese's Tables 1–2 list complete 4-general sets that are not complete caps; the manuscript distinguishes the two. |
| Free pairs | Farr–Lisoněk, J. Geom. 85 (2006) and Innov. Incidence Geom. 4 (2006) | Definition verified verbatim against the published Innov. Incidence Geom. text: every plane through the pair contains at most one further cap point, equivalent to `T_ℓ = 0`. |

## Sources cited in the manuscript, with read depth

| Source | Read depth | Access |
|---|---|---|
| Bartoli, Davydov, Kreshchuk, Marcugini, Pambianco, arXiv:1610.09656v1 | full text (§1, §3, Tables 3–4, bibliography) | cache `arXiv:1610.09656`, sha256 `729ade7f…` (C1075 ledger 1) |
| Davydov, Faina, Marcugini, Pambianco, arXiv:1706.01941v1 | partial (§1 in full; rest grepped) | cache `arXiv:1706.01941`, sha256 `c44c40dc…` (C1075 ledger 2; authorship corrected in C1078 §4) |
| Bartoli, Faina, Marcugini, Pambianco, J. Geom. 108 (2017) 215–246 | partial (arXiv:1406.5060v1 abstract and §1; journal version not read; link to arXiv id via zbMATH) | cache `arXiv:1406.5060`, sha256 `0bda9ede…` (C1075 ledger 3; C1078 §4) |
| Farr, Lisoněk, Innov. Incidence Geom. 4 (2006) 69–88 | full text (published version) | C1078 §1; DOI 10.2140/iig.2006.4.69 |
| Farr, Lisoněk, J. Geom. 85 (2006) 35–41 | abstract/metadata only (Crossref) | C1078 §1; cited only as the origin of the term |
| Kurz, Divisible codes, arXiv:2112.11763 | abstract/metadata only (OpenAlex record) | C1078 §5; cited as the adjacent general framework, not for any theorem |
| Pavese, J. Algebraic Combin. 61 (2025); arXiv:2305.13838 | full text of preprint v1 (abstract, §1, §3, §5, Tables 1–2); published version not read | C1078 §2; DOI confirmed by Crossref |
| Pless, Inform. Control 6 (1963) 147–152 | abstract/metadata only (Crossref) | C1078 §6; cited for the standard statement of the power moment identities |
| Polverino, Discrete Math. 208/209 (1999) 469–476 | secondary only, via arXiv:1011.3347 §1 (full text of §1); metadata confirmed by Crossref | C1075 ledger 4; C1078 §4 |
| Segre, Ann. Mat. Pura Appl. (4) 48 (1959) 1–96 | secondary only, via arXiv:1011.3347 §1; metadata confirmed (pages 1–96 by two services) | C1075 ledger 4; C1078 §4 |
| Thas, arXiv:1710.02512v1 | partial (abstract, §1, hyperplane-counting passages of §§2–3) | cache `arXiv:1710.02512`, sha256 `5994772a…` (C1078 §3) |
| Wehlau, arXiv:math/0403031v1 | full text of abstract and §1 (Equation 1.3, Lemma 2.1); §§3–8 not read | cache `arXiv:math/0403031`, sha256 `c9697c6d…` (C1075 ledger 5) |
| Rudd, Secant defects with prescribed holes (Zenodo 21682567) | full text (author) | companion paper |
| Rudd, Integral Secant Distributions (Zenodo 22087679) | full text (author) | companion paper |

## Negatives and coverage

- **No better-than-trivial lower bound on `t_2(d,q)`, `d ≥ 4`.** Domain and
  stop condition in C1075 §N1; four independent indexes, every member a
  construction, upper bound, table, or survey.
- **`Q(s) ≥ 0` not located as a stated inequality.** C1075 §N2; weaker
  negative, and the manuscript treats the inequality as expected folklore.
- **No prior divisibility or integer-feasibility exclusion of a
  counting-bound cap size.** C1075 §N3, plus C1078 §5 (four further
  queries recorded verbatim, nothing on point).
- **Character equations for caps: no confirmed textbook locus.** The 2025
  Hirschfeld–Thas survey does not contain them (C1078 §3, negative with
  domain); *General Galois Geometries* Ch. 27 was reachable only at table
  of contents. The manuscript proves the equations in two lines and cites
  no source for them.
- **Could not access:** Davydov–Faina–Marcugini–Pambianco, J. Geom. 94
  (2009); Davydov–Marcugini–Pambianco, J. Geom. 80 (2004);
  Hirschfeld–Storme 1998 and 2001; Giulietti 2013; Hirschfeld–Thas
  *General Galois Geometries*. These license nothing and are the open
  gaps behind every “to our knowledge” sentence.
- **Not covered:** MathSciNet (institutional), Google Scholar (blocks
  automation), Semantic Scholar (rate-limited during C1075).
