# C491 literature audit — deep holes of PRS(q−4) (redundancy five)

**Lane:** `reed-solomon` · **Date:** 2026-07-22 · **Task:** C491 work-package item 1 (entry gate)

This audit discharges the C491 entry gate: it must verify the status of the projective
Reed--Solomon `PRS(q-4)` / redundancy-five case and the "2019 announced next case" boundary before
any novelty, priority, or "first beyond redundancy four" wording. Verdicts are owned here; the
recorded three-graph forward-citation closure is logged in the companion
`2026-07-22-c491-prs-literature-audit-searchlog.md`.

## Opening summary

- Sources read at **full text** by the auditing agent (me): 1 (`arXiv:1901.05445`). Sources read at
  **abstract/metadata only** by me: 1 (`arXiv:2312.07118`). The forward-citation closure and the
  adjacent cached papers are delegated and recorded in the search log; their read depths live there.
- **Decisive question.** The load-bearing seed Zhang--Wan--Kaipa (2019) closes deep-hole
  classification for `PRS(k)` at **redundancy four** (`k = q-3`) and states verbatim that "The case
  `k = q - 4` will be discussed in a forthcoming work." `k = q-4` is exactly C491's redundancy-five
  target. The audit must settle whether that forthcoming work, or any other, has classified
  `PRS(q-4)`.
- **Verdict: NOT PRE-EMPTED.** The three-graph forward-citation closure (below) locates no published
  or preprinted work classifying deep holes / determining the covering radius of `PRS(q-4)`
  (redundancy five) or `PRS(k)` for `k <= q-4`. Two independent 2023--2025 sources restate the
  `PRS(k)` covering-radius / deep-hole problem as **open for `2 <= k <= q-2`**, both citing the 2019
  seed's `k=q-3` result as the frontier. Qualified only by the MathSciNet coverage gap (below), which
  keeps every "to our knowledge" claim it would gate qualified.

## Seed 1 (load-bearing) — Zhang, Wan, Kaipa 2019

- **Citation:** J. Zhang, D. Wan, K. Kaipa, "Deep Holes of Projective Reed-Solomon Codes."
  `arXiv:1901.05445` v2 [cs.IT] 3 Sep 2019. Published: IEEE Trans. Inform. Theory, vol. 66,
  pp. 2392--2401 (published-detail from a SciRP reference record, `abstract/metadata only`, not
  verified against the IEEE version of record).
- **Read depth:** `full text` (arXiv v2). Access: lit cache key `arXiv:1901.05445`,
  sha256 `5c2b9e2508c7200428c441b7a41da1596b1c9b0851f5632e2297cdbed41caf24`, 12 pp. Sections relied
  on: I (Introduction, Thms I.4--I.7, Conjecture I.2), II-A (covering radius, Lemma II.4 restated,
  Conjecture II.5, Thm II.6), II-C (automorphisms, `PGL_2` action, Lemma II.9--II.10), II-D
  (Thms I.5/I.6 proofs), III (complete classification of `PRS(q-3)`), IV (Conclusion).
- **What it establishes (load-bearing for C491):**
  - Covering radius of `PRS(k)` for `2 <= k <= q-2` is conjecturally `q-k` (or `q-k+1` when `q` even
    and `k in {2, q-2}`); Conjecture I.2 = finite-geometry Conjecture II.5 (the `(q+1)` points of the
    degree-`(q-k)` NRC in `P^{q-k}` form a complete arc, exceptions as stated); a special case of the
    MDS conjecture. Known true for `k >= floor((q-1)/2)` (Seroussi--Roth) and `k >= 6 sqrt(q ln q) - 2`
    (Storme).
  - Deep-hole classes ↔ points `S(k) ⊂ P^{q-k}(F_q)` of the projective syndrome space not on the span
    of `q-k-1` columns of the parity-check NRC generator `G_{q+1-k}` (Lemma II.2).
  - `PAut(PRS(k)) ≅ PGL_2(F_q)` acts via `g -> g_{q+1-k}` on syndromes (Lemma II.9); deep-hole
    classification is a `PGL_2`-orbit problem on `P^{q-k}`.
  - Three deep-hole families for `2 <= k <= q-3` under `ρ = q-k`: Thm I.4 (`X^k`-type, `q` classes),
    Thm I.5 (`q^2` tangent-line classes), Thm I.6 (`(q+1)q(q-1)/2` secant-line classes over `F_{q^2}`).
    Geometric reading: tangent lines (I.4/I.5) and `σ`-conjugate secant lines (I.6) of the degree-`(q-k)`
    NRC.
  - Thm I.7 / III.1: for `k = q-3` (redundancy four) these three families are **all** deep holes;
    total `q(q+1)^2/2 = (q^3 + 2q^2 + q)/2` classes. Redundancy-≤3 was Kaipa 2017 (ref [9]).
- **The announced boundary (Conclusion, §IV, verbatim):** "For `k < q-3` it seems increasingly
  difficult to enumerate the deep holes of `PRS(k)`. **The case `k = q - 4` will be discussed in a
  forthcoming work.**" This is the "2019 announced next case." C491 targets exactly `k = q-4`.
- **Auditor inference (marked as mine, not the paper's framing):** the redundancy-five syndrome space
  `P^{q-k} = P^4` for `k=q-4` is `P(Sym^4 F_q^2)` — binary quartic forms — with `PGL_2(q)` the code
  automorphism group. So the `k=q-4` classification is intrinsically a `PGL_2`-orbit problem on binary
  quartic forms, matching C491's proposed apolar/catalecticant approach. The 2019 paper does not carry
  out this Sym^4 case; its I.4--I.6 families are the tangent/secant strata that persist, not a
  redundancy-five completeness theorem.

## Adjacent tool paper — Kaipa, Patanker, Pradhan 2023

- **Citation:** K. Kaipa, N. Patanker, P. Pradhan, "On the `PGL_2(q)`-orbits of lines of `PG(3,q)`
  and binary quartic forms." `arXiv:2312.07118`, submitted 12 Dec 2023; v2 7 Mar 2024; v3 9 Aug 2025.
- **Read depth:** `abstract/metadata only` (arXiv abstract page, via WebFetch).
- **Finding:** develops the `PGL_2(q)`-orbit classification of binary quartic forms and an equivariant
  identification of a self-dual hyperplane of `PG(3,q)` lines with binary quartic forms. **No**
  Reed--Solomon, deep-hole, covering-radius, or `k=q-4` content. It is the binary-quartic invariant
  toolkit C491 would draw on, un-applied to the deep-hole problem. Not a pre-emption; a tool.

## Forward-citation closure

Full record: `2026-07-22-c491-prs-literature-audit-searchlog.md`. Two pinned seeds:
- SEED-A `arXiv:1901.05445` = `10.1109/TIT.2019.2940962`, OpenAlex `W2973880421` (redundancy-four).
- SEED-B `arXiv:1612.05447` = `10.1109/TIT.2017.2706677`, OpenAlex `W2563545890` (Kaipa 2017, ref [9],
  redundancy `<= 3`).

Cited-by counts recorded **separately per service** (disagreement is itself a finding; no service is
authoritative — the union of citer lists was screened):

| Service | SEED-A cited-by | SEED-B cited-by |
|---|---:|---:|
| OpenAlex | 21 | 20 |
| Crossref (`is-referenced-by-count`; no citer list on public API) | 19 | 16 |
| Semantic Scholar | 24 | 28 |

`S2 > OpenAlex > Crossref` throughout (S2 indexes arXiv/ISIT preprints the others miss; Crossref
counts only DOI-registered citers). Largest set (S2 SEED-B, 28) screened, cross-checked against the
other lists; screen discriminator = titles/abstracts mentioning `q-4`/`redundancy five`/`PRS(q-4)`/
PRS covering radius beyond redundancy four / binary-quartic-apolar applied to PRS deep holes. No
citer title contains `q-4` or "redundancy five"; every PRS/GRS/quartic-adjacent citer was promoted
and inspected individually (read depths in the search log).

**Two load-bearing findings:**

1. **Nearest active work by an overlapping author is twisted-RS, not projective RS.**
   `arXiv:2509.08526` (Gu, Wang, **Jun Zhang** — a SEED-A coauthor), "Deep holes of a class of
   twisted Reed-Solomon codes" (read full text), classifies deep holes of *twisted* RS codes
   including a `k=q-4` case. Different code family (different syndrome structure and automorphism
   group); the "`q-4`" is the TRS dimension, not projective RS. Does not touch `PRS(q-4)`.
2. **The binary-quartic invariant machinery exists but is un-applied to deep holes.**
   `arXiv:2312.07118` (Kaipa--Patanker--Pradhan, v3 Aug 2025; read full text) classifies binary
   quartic forms over `F_q` into `PGL_2(q)`-orbits via the apolar invariant — exactly the toolkit
   the redundancy-five syndrome space `P(Sym^4 F^2)` needs — with zero deep-hole / PRS / covering-
   radius content. **Auditor inference (mine):** this reads as groundwork for the announced `k=q-4`
   case by three of the named authors (incl. Kaipa), stopping short of the coding application. A
   C491 write-up must cite it as the binary-quartic orbit-classification input.

Openness corroboration (read full text): `arXiv:2312.05534` §V (Wu--Ding--Chen, "Extended codes and
deep holes of MDS codes") states the `PRS(k)` covering radius is open for `2 <= k <= q-2`; the
even-characteristic WUJNS 2023 paper (`10.1051/wujns/2023281015`) gives only a partial two-class
even-characteristic result at redundancy `<= q-3`. Author-stream checks (S2 endpoints; arXiv native
API was rate-limited — see Coverage) on Kaipa, Jun Zhang, Wan, Patanker, Pradhan surfaced no
`PRS(q-4)` classification.

## Coverage statement

- **MathSciNet:** NOT COVERED (institutional auth generally unreachable from an agent session). Every
  "to our knowledge" claim it would gate stays qualified.
- **arXiv native API author/full-text listings:** NOT COVERED (HTTP 429 all session); Semantic Scholar
  author endpoints + WebFetch/WebSearch substituted over the same author space. Method gap, licenses
  no negative on its own.
- **Crossref citer list:** NOT COVERED on the public API (count only); citer screening ran on OpenAlex
  + S2 lists.
- **"On deep holes of non-Reed-Solomon codes" (2026, `10.1016/j.ffa.2026.102882`) abstract:** could
  not access; screened out on title (non-RS family). Minor open gap.
- Full searched-vs-could-not-access split: search log Coverage section.

## Verdict

**NOT PRE-EMPTED.** As of this audit no work classifies deep holes or determines the covering radius
of `PRS(q-4)` / redundancy five. The 2019 seed's announced `k=q-4` "forthcoming work" has not
appeared; the redundancy-five syndrome space `P(Sym^4 F^2)` is binary quartic forms under `PGL_2(q)`,
and the matching orbit machinery (`arXiv:2312.07118`) exists but is un-applied to the deep-hole
problem. C491's mathematics is clear to proceed. Constraints on downstream wording:

- Cite `arXiv:2312.07118` as the binary-quartic `PGL_2(q)`-orbit / apolar-invariant input; do not
  re-derive its orbit classification as novel.
- Position `arXiv:2509.08526` (Jun Zhang et al., twisted-RS `k=q-4`) as adjacent-family, not a
  predecessor, and be precise that C491 treats *projective* RS.
- Keep "to our knowledge" on any priority sentence the MathSciNet gap would gate.
- The covering-radius premise is inherited-conjectural (Conjecture I.2/II.5, known for
  `k >= floor((q-1)/2)`), so the classification is stated under `ρ(PRS(q-4)) = q-k = 4`, matching the
  seed's convention.
