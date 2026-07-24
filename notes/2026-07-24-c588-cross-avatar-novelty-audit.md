# C588 — Literature/novelty audit: the cross-avatar field-dependence dichotomy

**Lane:** `gateway`

**Date:** 2026-07-24

**Status:** Literature audit only — no task allocation, no manuscript edit, no novelty *claim*. This
records what a bounded multi-graph search did and did not find for one specific question, so the
`gateway` lane (C589) can word any priority sentence. Every verdict is a bounded negative over the
stated services and date, not an unrestricted nonexistence statement.

This audit does **not** re-run the two prior gateway/crowns audits it builds on
(`2026-07-21-cocycle-gateway-novelty-consolidated.md`, `2026-07-21-novelty-arnold-trinities.md`); it
takes their full-text attributions as given and positions a *new* question against them.

## Opening summary (read-depth accounting)

- **Full-text sources read for this audit:** the project's own prior audit notes and lane handoffs
  (internal), read in full. No *external* would-be pre-emptor was read at full text, because the
  search located none to read — the deliverable is an absence verdict, and its strength rests on
  search coverage, not on full texts of a predecessor.
- **Constituent-piece attributions** (Dye 1991; Storme–Van Maldeghem 1995; Jurrius–Pellikaan;
  Rains / Van den Nest–Dehaene–De Moor; Godsil–Meagher / Bamberg–Klawuhn; Kostant; Dechant; the PRS
  deep-hole line) were established **at full text by the prior audits and the source lanes'** own
  novelty passes (crowns consolidated audit; trinity audit; `ame-lu` C562). This audit inherits and
  cites those depths; it does not re-verify them. Where a depth is inherited it is marked
  `secondary only (prior audit, full text)`.
- **External corpus for the new question** was screened at `abstract/metadata only` via web search
  and three citation/indexing graphs (OpenAlex, Crossref, zbMATH Open). Semantic Scholar was
  **NOT COVERED** (rate-limited, see Coverage).

## The precise question

Is the **cross-avatar field-dependence dichotomy** of the icosahedral six-arc already named or
published? Concretely: is it known/folklore that, for one exceptional projective MDS code /
finite-geometry configuration, its

- covering-radius / deep-hole / incidence invariants are **arithmetic and field-sporadic** (pinned to
  exceptional `q` by a factorization), while its
- modular-representation and entanglement (local-unitary / local-Clifford) invariants can be
  **field-uniform** (hold for all prime powers)?

With the subtlety that must be addressed head-on: the **modular-carrier avatar** (perfect-code /
endotrivial Lagrangian, the C474 Modular Gateway Theorem) is representation-theoretic **yet itself
sporadic** (`q = 7, 11` only). So the split is **not** the naive "incidence = sporadic,
representation = uniform." The question is whether this *finer, mechanism-based* dichotomy — or any
general "one exceptional object, avatar-dependent field-dependence of rigidity" statement — has a
home in the literature.

## Headline verdict

**NOT pre-empted as a synthesis.** No source states, for one object, the avatar-dependent
field-dependence dichotomy — in either its naive or its finer (non-category-aligned) form. What is
pre-empted, and must be credited, is **every constituent field-dependence fact taken singly**: each
avatar's field-behaviour is owned by an existing literature. The survivor is the *composition* —
the observation that these three field-behaviours are attached to one exceptional object and split by
**mechanism, not by category** (arithmetic factorization / perfect-code-plus-subgroup availability →
sporadic; MDS-shortening diagonal-Weyl argument → uniform).

This matches the uniform pattern of the two prior gateway audits: every named concept is classical
and has a home; only the specific composition survives. This audit's added value is that it isolates
and clears the one framing those audits did not test — the field-dependence *contrast itself*.

## Claim-boundary table

| Piece of the dichotomy | Owner in the literature (must credit) | Read depth | What survives as candidate-novel |
|---|---|---|---|
| Deep-hole / covering-radius of PRS/MDS codes is **arithmetic and pinned to exceptional `q`** by a factorization | Deep-hole-of-PRS line: Kaipa (arXiv:1612.05447); Zhang–Wan / Zhuang (arXiv:1901.05445); extended-code deep holes (arXiv:2312.05534); Wuhan even-char (10.1051/wujns/2023281015). Conic case: Dye 1991 (JLMS s2-44.2.270), Storme–Van Maldeghem 1995 (10.1016/0097-3165(95)90051-9) | abstract/metadata (this audit); conic case `secondary only (prior audit, full text)` | that **this** six-arc's chord-defect factorization `(q−6)(q−9)` / `(q−4)(q−11)` isolates `q=11` — owned by `clebsch`/`arcs`, not by this lane |
| **Modular carrier** (perfect code → endotrivial Lagrangian) exists **only at sporadic `q`** (`7`, `11`; `23` boundary) | Perfect-code classification (van Lint; Tietäväinen, 10.1137/0124010); endotrivial-module theory; `PSL_2(q)` subgroup-index availability | `secondary only (prior audit / C474, full text)` | the seven-gate recognition theorem and the two-case-plus-boundary packaging — owned by `crowns` (C474) |
| **LU = LC entanglement rigidity** holds **uniformly for all prime powers** | LU-vs-LC mechanism: Van den Nest–Dehaene–De Moor (quant-ph/0411115, quant-ph/0610267); Rains polynomial-invariant line; LU≠LC in general (arXiv:0709.1266). AME↔QMDS↔MDS dictionary: Goyeneche et al. (arXiv:1708.05946) | abstract/metadata (this audit); mechanism `secondary only (ame-lu C562, full text)` | the `[6,3,4]_q`-family MDS-shortening argument giving LU=LC for **every** `q` — owned by `ame-lu` (C560/C561) |
| **The dichotomy as a stated principle** — one object, avatar-dependent field-dependence, split by mechanism not category | **not located in any source** | — (absence) | **the whole synthesis** — candidate-novel framing, gated to C589 |
| General "exceptional object rigidity is field-uniform in some avatars, exceptional-`q`-pinned in others" meta-statement | **not located** (nearest neighbours are orthogonal — see below) | abstract/metadata | the meta-statement, if C587 turns it into a theorem |

### Nearest neighbours that are NOT the claim (positioned, dismissed)

| Candidate frame | Pinned id / read depth | Why it is not the dichotomy |
|---|---|---|
| Arnold Coxeter trinity `(A3,B3,H3)` | Dechant, Proc R Soc A 474:20180034 = arXiv:1812.02804; `secondary only (trinity audit, full text)` | Goes `A3/B3/H3 → 4D root systems → ADE`; never evaluates at `q=h+1`, never touches field-dependence of an invariant. Orthogonal direction (already established by the trinity audit). |
| Galois/Kostant `L2(5,7,11)` exceptional primes | Kostant 1995 (10.1515/dmvm-1995-0405, cached); Baez TWF week79; Martin–Singerman; `secondary only (trinity audit, full text)` | Names *which* primes are exceptional and the biplane self-duality; says nothing about the **same object's** invariants being uniform in one avatar and sporadic in another. |
| Arithmetic "exceptional primes" (Galois representations) | web abstract/metadata (MIT/arXiv surface hits, 2026-07-24) | A different notion: finitely-many primes where a mod-`p` Galois image is small. No object-fixed avatar-dependence statement. Distinct term collision. |
| AME/quantum-combinatorial-design field-dependence | Goyeneche et al. arXiv:1708.05946; arXiv:1506.08857; abstract/metadata | Discusses field-dependence of AME **existence** (dimension `d` prime-power factorization), never a per-avatar rigidity split of one fixed object. |
| Matching association schemes | Bamberg–Klawuhn arXiv:2507.00813 (10.5802/alco.490); Godsil–Meagher; `secondary only (crowns audit, verified-against-PDF)` | Supplies the ambient scheme/λ-design frame; states no field-dependence dichotomy. (Do not propagate the fast-model hallucination the crowns audit flagged.) |
| Representation stability | web abstract/metadata | Stabilizes in **rank `n`**, not in **field `q`**. Wrong axis; not applicable. |
| Baez "exceptional objects" philosophy | Wikipedia/TWF surface; abstract/metadata | Observes exceptional objects recur across contexts; does not state that rigidity's field-dependence varies by avatar. |

## Search record

All queries run 2026-07-24. "Empty vs error" is distinguished per service below.

**Shared lit cache** (`/tmp/persistent/tavis/lit-search/`, ZFS): consulted before any fetch. Holds
most named anchors already — Storme–Van Maldeghem (`10.1016/0097-3165(95)90051-9`, ok), Kostant
(`10.1515/dmvm-1995-0405`, ok), Dechant (`arXiv:1812.02804`, ok), the VdN LU-LC papers
(`quant-ph/0411115`, `quant-ph/0610267`, `arXiv:0709.1266`, ok), the deep-hole PRS papers
(`arXiv:1901.05445`, `arXiv:1612.05447`, `arXiv:2312.05534`, `10.1051/wujns/2023281015`, ok),
Bamberg–Klawuhn (`arXiv:2507.00813` / `10.5802/alco.490`, ok), Goyeneche-family AME/design papers,
and Jurrius–Pellikaan-adjacent (`10.1142/9789814335768_0006`, `arXiv:2103.16904`, ok). Dye 1991 JLMS
and the Martin–Singerman EJC printing are present only as `not-a-pdf` captures — their attributions
are inherited from the prior full-text audits, not re-verified here.

**Web (WebSearch, US index):** seven queries spanning (a) the abstract "avatar-dependent
field-dependence of rigidity" framing; (b) covering-radius/deep-hole arithmetic sporadicity; (c)
LU=LC uniformity for all prime powers; (d) exceptional-object uniform-vs-sporadic invariant contrast;
(e) representation-uniform-vs-incidence-sporadic; (f) AME(6,q)/A5/local-Clifford rigidity; (g)
Galois exceptional-prime property-persistence. **Stop condition:** first 8–10 results per query
screened by title + snippet. **Result:** no source states the dichotomy. The abstract-framing query
returned only literal-3D-avatar CS papers (the word "avatar" is not a math term here); the concrete
queries returned single-avatar coding/QI papers that treat one side only.

**Citation/indexing graphs — bounded conjunction negatives** (the negative is a *framing-coverage*
negative over loose-OR engines that would surface any co-occurrence, not a pinned forward-citation
zero; three graphs are used to guard against a single-index gap):

- **OpenAlex** (works `search`, `mailto` set): exact conjunction `deep holes local Clifford MDS
  icosahedral` → **count 0**. Broader conjunctions (`field-dependence rigidity exceptional object
  avatars`; `covering radius sporadic entanglement field-uniform`) → 106 / 73 loose-OR hits whose
  top-5 are entirely unrelated (avatars/graphene/astronomy). **Empty-vs-error:** count field present,
  200 responses. **Stop:** top-5 relevance-screened per query; the discriminating conjunction is a
  true zero.
- **Crossref** (works `query`, `mailto` set): `deep holes covering radius local Clifford entanglement
  MDS code` → 1.95M loose-OR hits; top-6 are all single-concept covering-radius papers, none
  co-treating an entanglement/LU avatar. Crossref OR-matching cannot produce a clean zero, so it is
  used only to confirm the top-ranked co-matches do not bridge the avatars. **Stop:** top-6 screened.
- **zbMATH Open** (`/v1/document/_search`): exact conjunctions `covering radius deep holes
  entanglement local unitary MDS`, `Clebsch arc icosahedral PG(2,11)`, `sporadic field uniform
  covering radius entanglement` → **HTTP 404 "successful access. No results found"** (a
  *distinguishable* empty, not an error). Calibration: `deep holes projective Reed-Solomon` → 3,
  `local unitary local Clifford stabilizer` → 10, `deep holes entanglement` → 9 (all 9 screened and
  found to be **black-hole** physics — spurious OR-match on "holes"; none bridges the avatars). API
  confirmed live by the nonzero calibration counts.

**Distinct empty vs error, per service:** OpenAlex — `meta.count` field, 200; Crossref —
`total-results` field, 200; zbMATH — `status_code` 200 with `nr_total_results` vs 404 "No results
found"; Semantic Scholar — HTTP 429 body `"Too Many Requests"` (error, not empty).

## Coverage statement

- **Semantic Scholar: NOT COVERED.** All attempts returned HTTP 429 (rate-limited; no API key,
  three backoff retries at 20 s). This is a *could-not-access*, not a *searched-and-found-nothing*.
  Any C589 manuscript-bound "to our knowledge" sentence must either close S2 (with a key) or retain
  the qualifier for the third-graph slot. The other two graphs (OpenAlex, Crossref) plus zbMATH Open
  give three independent indices, so the conjunction negative does not rest on a single graph.
- **MathSciNet: NOT COVERED** (institutional auth, unreachable from an agent session).
- **Full-text of external would-be pre-emptors:** none was located to read; the constituent-piece
  full texts were read by the prior audits/lanes and are inherited here, not re-opened.
- **Google Scholar:** not attempted (blocks automated access).

## Collision found

**None** that pre-empts the dichotomy. The only "hits" that co-mention deep holes/covering radius and
entanglement (zbMATH `deep holes entanglement` = 9) are black-hole physics, a lexical false positive.
Every genuine neighbour (trinities, Galois primes, matching schemes, AME existence, representation
stability, exceptional-objects philosophy) owns a *piece* or an *orthogonal direction*, never the
per-avatar field-dependence contrast of one object.

## Bottom line for C589

The synthesis clears novelty as a *framing*: no predecessor states, for one exceptional object, that
rigidity's field-dependence is avatar-dependent and mechanism-split. The three constituent
field-behaviours must each be credited to their owning literature and lane (table above). Whether the
framing is a **theorem** (a general uniform-vs-sporadic characterization, C587) or a **program
identity** is a separate gate — this audit only clears the "has anyone said this" question, and
confirms the naive "incidence = sporadic, representation = uniform" reading is the wrong one to
publish, since the representation-theoretic modular carrier is itself sporadic. Carry "to our
knowledge" until Semantic Scholar (or MathSciNet) is closed.
