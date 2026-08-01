# Golden operator discovery track

**Lane:** `golden`

This append-only companion records only incidental observations and musings
encountered while carrying out planned Golden paper tasks.  Paper claims,
proof obligations, novelty findings, and successor gates belong in their
task reports and the live handoff, not here.

### 2026-08-01 — a classical golden conjugation already sits inside the outer automorphism of \(S_6\)

**Provenance:** C755 literature audit; Howard–Millson–Snowden–Vakil, *A description of the outer
automorphism of \(S_6\), and the invariants of six points in projective space*, J. Combin. Theory
Ser. A 115 (2008), 1296–1303, § 1.3 "Another description: labeled icosahedra", read at full text
(cache key `10.1016/j.jcta.2008.01.004`).

**Was I looking for this?:** no — the audit question was whether that paper pre-empts the
manuscript's Joubert-cubic and centered-square claims (it does; see the C755 report).

**Observed / musing:** HMSV construct the outer six-set from twelve labellings of an icosahedron by
\(\{1,\dots,6\}\) with antipodal vertices equally labelled, paired into six by "oppositeness," and
remark in passing that if the icosahedron is embedded in \(\mathbb Q(\varphi)^3\) with vertices at
\((\pm1,\pm\varphi,0)\) and its cyclic shifts, then conjugation in
\(\mathrm{Gal}(\mathbb Q(\varphi)/\mathbb Q)\) sends the icosahedron to its opposite. So the
\(\sqrt5\)-conjugation that the Golden manuscript introduces as the bit exchanging the two
cross-golden resolutions already acts, classically and in the same \(S_6\)-set, as the involution
exchanging the two halves of the support split.

**Why it may matter / strongest question:** the manuscript treats "choose a support half" and
"choose \(\sqrt5\)" as two independent bits (Theorem 3.2(c)). HMSV's remark exhibits one classical
realization in which the second bit *implements* the first. Are they independent in general, or does
the icosahedral model give a canonical identification that would collapse Theorem 3.2(c)'s two bits
into one under a specific marking? A cheap discriminator: compute whether the Galois action on the
icosahedral labelling agrees with common reversal \(C\mapsto-C\) on the switching class, or only up
to an inner permutation.

**Evidence:** REASONED, from a source read at full text; not computed.

**Status:** open lead

### 2026-08-01 — Crossref undercounts both audit seeds by a factor of two to three

**Provenance:** C755 literature audit, three-service citation-count step
(`notes/2026-08-01-c755-golden-operator-literature-audit.json`).

**Was I looking for this?:** no — the counts were collected only to satisfy the width requirement in
`notes/literature-audit-conventions.md` before screening the largest set.

**Observed / musing:** for Goethals–Seidel (1967) the counts were OpenAlex 213, Crossref 117,
Semantic Scholar 146; for HMSV (JCTA 2008) they were 28, 9, 40. Crossref is lowest in both cases and
the other two services disagree in *opposite directions* on the two seeds, so no service dominates.
A single-graph zero on an older mathematics record would be badly misleading here.

**Why it may matter / strongest question:** future lane audits that use a citing-set zero as evidence
should treat Crossref alone as unusable for pre-1990 mathematics and for arXiv-heavy areas. Is the
OpenAlex/Semantic Scholar crossover systematic (arXiv-only citing works versus book chapters), and if
so can a lane-standard union query be scripted once rather than rebuilt per audit?

**Evidence:** CHECKED — the counts are in the C755 evidence bundle and the replay command re-queries
them.

**Status:** open lead
