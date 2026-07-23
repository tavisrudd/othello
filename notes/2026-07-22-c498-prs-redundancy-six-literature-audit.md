# C498 literature audit — deep holes of PRS(q−5) (redundancy six) via the quintic NRC in PG(5,q)

**Lane:** `reed-solomon` · **Date:** 2026-07-22 · **Task:** C498 entry gate (claim-specific audit)

This audit discharges the C498 entry gate before any novelty, priority, or "first beyond redundancy
five" wording. It is the redundancy-six successor to the C491 audit
(`2026-07-22-c491-prs-redundancy-five-literature-audit.md` + its search log), which it reuses rather
than redoes on the shared coding forward-tree. Verdicts are owned here; the three axis reports are
the evidence:

- Axis A (coding pre-emption): `2026-07-22-c498-audit-axisA-coding-forward-citation.md`
- Axis B (split-member lemma): `2026-07-22-c498-audit-axisB-split-member-linear-systems.md`
- Axis C (orbit toolkit): `2026-07-22-c498-audit-axisC-quintic-orbits-nets.md`

## Opening summary

- **Sources read at full text by this audit: 5** — `arXiv:2312.05534` (Wu–Ding–Chen), `10.1051/wujns/2023281015`
  (Xu, even char), `arXiv:1006.0873` (Oyono–Ritzenthaler), `arXiv:2605.04935` (Ishitsuka). **Reused at
  full text from C491: 2** — `arXiv:1901.05445` (ZWK), `arXiv:1612.05447` (Kaipa 2017).  The fifth new
  full-text source is `arXiv:1511.02598` (Fukasawa), added during the corrected projection-cover
  analysis. `arXiv:2312.07118`
  (KPP quartic orbits) read at **partial** here (full text in C491). All other named sources are
  `abstract/metadata only`, `partial`, `review only`, or `secondary only` as marked in the axis reports.
- **Decisive question.** Does any work classify deep holes / determine the covering-radius orbit
  structure of `PRS(q−5)` / redundancy six, *or* already prove the C491 NRC-ledger entry lemma
  (totally-split member of a net of binary quartics), *or* supply a finished `PGL₂(q)`-orbit
  classification of binary quintics over `F_q`?
- **Verdict: NOT PRE-EMPTED.** No source classifies deep holes or the covering-radius orbit structure
  of `PRS(k)` for any `k ≤ q−4` beyond C491's own redundancy-five result; the general problem is stated
  open for `2 ≤ k ≤ q−2` (a range containing `k=q−5`). The entry lemma is proved nowhere as stated. No
  `PGL₂(q)`-orbit classification of binary quintics over `F_q`, and no classification of nets of binary
  quartics, exists. Qualified only by the MathSciNet coverage gap (below), which keeps every "to our
  knowledge" claim it would gate qualified.

## Axis A — coding-theoretic pre-emption (redundancy six)

**NOT PRE-EMPTED.** Refreshed three-graph forward-citation closure on the two pinned seeds
(SEED-A `arXiv:1901.05445` = `10.1109/TIT.2019.2940962`, OpenAlex `W2973880421`; SEED-B `arXiv:1612.05447`
= `10.1109/TIT.2017.2706677`, OpenAlex `W2563545890`), counts recorded separately per service (OpenAlex
21/20, Crossref 19/16, Semantic Scholar 24/28; disagreement is expected graph-coverage variance). The
largest retrievable citing sets (S2, 24/28) were enumerated and screened with a verbatim `q−5` /
redundancy-six discriminator: **no hit**. The four 2026 citers new since C491's audit are
weight-distribution / TGRS-construction / design papers — none reaches redundancy six. Wu–Ding–Chen
`arXiv:2312.05534` §V (full text) states verbatim that the `PRS(k)` covering radius is open for
`2 ≤ k ≤ q−2`; that range contains `k=q−5`.

**Covering-radius-VALUE caveat (kept separate from the classification verdict).** The scalar covering
radius `ρ(PRS(q−5))` is *already known* to equal `q−k=5` in the Seroussi–Roth range — this is not a
C498 novelty. Wu–Ding–Chen cite the threshold as `k ≥ ⌈(q−1)/2⌉`; the C491 report and the C498 queue
row use `k ≥ ⌊(q−1)/2⌋`. These give different entry points (`q ≥ 11` vs `q ≥ 9`), differing only at
`q` where `(q−1)/2` is non-integral. **This floor/ceil convention is an open math detail for the C498
write-up** — pin it against the Seroussi–Roth 1986 original rather than a secondary restatement. Either
way the *orbit classification* (which syndromes achieve the radius and their `PGL₂(q)`-orbit structure)
is the C498 crown and is untouched — exactly the ZWK-redundancy-four / C491-redundancy-five situation.

## Axis B — the split-member entry lemma

**NOVEL AS STATED; STANDARD TOOLS EXIST.** The lemma — "for `q ≥ q₁` every non-exceptional net of
binary quartics with trivial gcd contains a totally-split squarefree member, exceptional nets
classified separately" — is proved nowhere located. Two items a C498 write-up must engage directly:

- **Oyono–Ritzenthaler**, "On rationality of the intersection points of a line with a plane quartic"
  (WAIFI 2010, LNCS 6087, 224–237; `arXiv:1006.0873`, full text). Proves the split-member statement for
  the *specific* net of line-sections of a smooth plane quartic, `q ≥ 127`, by the **curve/Hasse–Weil**
  route (not a Lang–Weil surface). This is the same phenomenon with an explicit bound for the special
  case; C498's generality (arbitrary trivial-gcd net, exceptional strata classified, **surface** rather
  than curve argument) is what is new.
- **Cesaratto–Matera–Pérez**, "The distribution of factorization patterns on linear families of
  polynomials over a finite field" (Combinatorica 37(5) 2017, 805–836; `arXiv:1408.7014`, partial). The
  totally-split pattern `λ=1⁴` has strictly positive main term `𝒯(1⁴)·q^{n−m}`, so a totally-split
  member exists past an explicit bound — the counting core of the lemma for a *linear* (net-shaped)
  family, char > 2.
- **Fukasawa**, "Rational curves of degree four with two inner Galois points"
  (`arXiv:1511.02598v1`, full text, all sections; cache key `arXiv:1511.02598`, SHA-256
  `d02e65bc33bee2ffb05572760a88322e698ce211b05f2f04f916cb21bae438c8`) classifies the
  multi-Galois-point rational quartics in characteristic different from \(2,3\), and Remark 4
  identifies the characteristic-two model with infinitely many inner Galois points.  C498 uses it
  only as geometric context for the independently proved Frobenius-trinomial family, not as a
  split-member theorem or a pre-emption.

Surface-argument tool chain, all published with explicit constants: **Aubry–Perret** (singular-curve
Weil bound, the r=5 tool; Manuscr. Math. 88(4) 1995), **Cafure–Matera** (explicit Lang–Weil / effective
Bertini, FFA 12(2) 2006), **Ghorpade–Lachaud** (singular complete-intersection point counts, Mosc.
Math. J. 2(3) 2002 + 2009 corr. — the surface generalization of Aubry–Perret), **Charles–Poonen**
(Bertini irreducibility over finite fields, J. AMS 2016) and **Poonen** (Bertini smoothness, Ann. Math.
160(3) 2005). *Auditor inference (Axis B's, carried forward as ours):* these assemble into a proof of
the C498 lemma with explicit `q₁`; no source assembles them for this claim.

**Load-bearing caveat for the mathematics (ours):** the only explicit split-member bound located is
`q ≥ 127` (Oyono–Ritzenthaler, special case). The C498 census is `q ≤ 16`. Unless the surface argument
yields a bound near the census range, the census cannot verify the asymptotic lemma, and a band above
`q=16` up to the provable threshold would rest on the proof alone. This mirrors C491, where
Aubry–Perret gave `q ≥ 23` and the census (through `q=49`) happened to bracket the sporadic boundary;
C498 has no such guarantee that the two ranges meet. Flag in the report; do not claim census coverage
of the asymptotic regime.

## Axis C — orbit-classification toolkit

**NO PRE-EMPTION; TOOLKIT PARTIAL, MUST BE BUILT.** There is no `PGL₂(q)`-orbit classification of binary
quintics over `F_q` (the redundancy-six syndrome space `P⁵ = P(Sym⁵)`), and no classification of nets of
binary quartics (the Hankel kernel). Citable inputs:

- **KPP** `arXiv:2312.07118` (partial here; full text in C491) + char-3 companion `arXiv:2508.11229`
  (abstract only) — the binary-*quartic* `F_q`-orbit method to imitate; the source of the O±/nucleus
  strata C491 named.
- **Ishitsuka**, "Exponential sums over singular binary quintics" (`arXiv:2605.04935`, full text) — a
  **characteristic-free** (explicit char-2 appendix) catalecticant-rank + Waring-type stratification of
  binary quintics, and the apolar/Hankel machinery. Its application is number-theoretic (2-Selmer), not
  coding — a tool, not a pre-emption. It flags the quintic space as **not coregular**, the structural
  reason the two-invariant quartic method does not transfer verbatim: a genuine obstruction C498
  inherits, not a gap to fill by copying C491.
- Classical quintic invariant theory — Hermite/Clebsch/Grace–Young/Kung–Rota/Iarrobino–Kanev/Geyer
  (char 0 / K̄ / large char; secondary or abstract only).
- **Net/web classification method:** Wall, "Singularities of nets of quadrics" (Compositio 42, 1980)
  for nets of quadrics; Lavrauw–Popiel–Sheekey and companions for nets/webs of *conics* over `F_q`
  (`arXiv:2010.00177`, `2003.06275`, `2405.10710`, `2509.03840`) — analogues, not the quartic-net object.
- **NRC nucleus:** Gmainer–Havlicek, "Nuclei of Normal Rational Curves"
  (`arXiv:1304.0088`, partial: abstract and Theorem 1 in §4; cache key `arXiv:1304.0088`, SHA-256
  `da688c01e3953319ef93f17e1676fedf0470c590a0a348a853dabb11209526d0`): the number of
  distinct nuclei of the degree-`n` NRC equals the number of nonzero base-`p` digits of `n+1`, and
  Theorem 1 gives their coordinate spans by vanishing binomial coefficients. *Axis C computations
  (ours):* for `n=5`, `n+1=6=(20)₃`, giving **one** nucleus in char 3; in characteristic two,
  Theorem 1 identifies the `3`-nucleus as the line spanned by coordinate points \(P_2,P_3\).
  The latter is exactly C498's recurring Frobenius-trinomial orbit.

So the exceptional-net classification ("higher analogues of O±/nucleus/wild") and the binary-quintic
`F_q`-orbit census are **both new work C498 must produce**, built by analogy to the quartic program and
the conic-net method; neither the classification nor its application to PRS exists.

## Constraints on downstream C498 wording

1. Cite **Oyono–Ritzenthaler** (`arXiv:1006.0873`) and **Cesaratto–Matera–Pérez** (`arXiv:1408.7014`)
   as the split-member precedents; do not present the totally-split-member phenomenon or the
   linear-family counting as new. C498's contribution is the general trivial-gcd-net lemma, the
   exceptional-net classification, and the surface (vs curve) argument.
2. Cite **KPP** (`arXiv:2312.07118`, + char-3 `arXiv:2508.11229`), **Ishitsuka** (`arXiv:2605.04935`),
   and the classical quintic invariant-theory spine as the orbit toolkit; state that no `F_q`-orbit
   classification of binary quintics is imported ready-made, and note non-coregularity as the reason.
3. Cite **Aubry–Perret / Cafure–Matera / Ghorpade–Lachaud / Charles–Poonen / Poonen** for the
   Lang–Weil-surface / Bertini machinery; do not re-derive it.
4. Scope any novelty sentence to the **deep-hole / orbit classification**, not the scalar covering
   radius (Seroussi–Roth-known). Resolve the floor/ceil threshold against the Seroussi–Roth original.
5. Keep "to our knowledge" on any priority sentence the MathSciNet gap would gate.
6. State plainly that the `q ≤ 16` census does not verify the asymptotic split-member lemma; give the
   provable-threshold band explicitly once the surface bound is computed.

## Coverage statement

- **OpenAlex, Crossref, Semantic Scholar:** COVERED (both seeds; counts + largest-set enumeration;
  empty-vs-error distinguished, including a transient S2 429 handled by re-query).
- **zbMATH Open:** PARTIALLY COVERED — the JSON API `api.zbmath.org` was reachable in Axis B (source of
  the Zbl numbers and bibliographic detail for Oyono–Ritzenthaler, Aubry–Perret, Cafure–Matera,
  Ghorpade–Lachaud, Poonen, Cesaratto–Matera–Pérez) but returned HTTP 403/400/404 to Axis C. A
  per-attempt reachability difference, not a contradiction; Axis C's bibliographic detail therefore
  rests on arXiv/abstract records, not zbMATH.
- **arXiv native API author/full-text listings:** NOT COVERED where rate-limited (as in C491);
  substituted by Semantic Scholar author endpoints + WebFetch/WebSearch. Method gap, licenses no
  negative on its own.
- **Crossref citer list:** NOT COVERED on the public API (count only); citer screening ran on
  OpenAlex + S2.
- **MathSciNet:** NOT COVERED (institutional auth unreachable). Every "to our knowledge" claim it would
  gate stays qualified.
- `arXiv:2508.11229` (char-3 quartics) read at abstract only — a minor open gap; low pre-emption risk
  (quartics, not quintics/PRS).

## Verdict

**NOT PRE-EMPTED.** As of this audit no work classifies deep holes or the covering-radius orbit
structure of `PRS(q−5)` / redundancy six or of any `PRS(k)` with `k ≤ q−5`; the entry lemma
(totally-split member of a trivial-gcd net of binary quartics) is proved nowhere as stated; and neither
the `PGL₂(q)`-orbit classification of binary quintics over `F_q` nor the classification of nets of
binary quartics exists. C498's mathematics is clear to proceed under the six wording constraints above.
The standard analytic toolkit (Lang–Weil surface, Bertini over finite fields, Cesaratto–Matera–Pérez
counting) and the quartic-orbit template are available and must be cited, not re-derived; the crown —
the exceptional-net classification, the binary-quintic `F_q`-orbit census, and the surface split-member
argument — is open.
