# Literature audit — rigidity + gap theorems (Clebsch hexagon / PG(2,11) deep holes)

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Scope**: audit of the headline rigidity theorem (Claim 1) and gap theorem (Claim 2) of the
Clebsch hexagon manuscript, against the finite-geometry / coding-theory literature.

No sub-agents were used. Every source below was fetched and read by me directly. Nothing in this
document is reconstructed from memory: each claim carries a URL and, where it matters, a verbatim
quote.

## Tiering convention

- **VERIFIED** — I opened the source myself; URL + quoted text given.
- **INFERRED** — abstract / review / snippet only, source itself not opened. Flagged per item.
- **NOT FOUND** — searched, nothing located.
- **NOT SEARCHED / NOT OBTAINED** — not attempted, or attempted and unavailable.

---

## VERDICT — Q1 (the one that matters)

**On the evidence I could reach: NO COLLISION FOUND. The rigidity theorem survives as a novel
claim.** I found no source that characterizes the Clebsch hexagon by a property of its extension
points, and none that observes U(A) lies on — or is — a conic.

**But this verdict has a hole in it, and the hole is exactly where the prompt predicted.** The
single most dangerous source, **Sadeh's 1984 Sussex thesis, is unobtainable online and I have read
zero pages of it** (user-confirmed during this sweep: not available online). The second-most
dangerous, **Hirschfeld PGOFF Ch. 14 "Small planes", I also could not open** (archive.org returns
403 — in-copyright lending item; Google Books API quota exhausted). So the correct statement is:

> **No collision found in any source I could open, and the surrounding evidence argues against a
> collision existing — but the two sources most likely to contain one were not read.**

Do not upgrade this to "verified novel" until the ILL copy lands. The claim is **not** currently
safe to describe in the manuscript as "not previously observed" without the hedge that the primary
1984 sources were unavailable.

**Why the surrounding evidence argues against a collision** (this is the substantive part, and it
is stronger than a bare NOT FOUND):

1. The **direct modern continuation of the Sadeh line** — Karaoglu's 2018 Sussex thesis, same
   school, same problem, same method, explicitly picking up where Sadeh left off — tabulates
   6-arcs **with no extension-point column at all**, and contains no occurrence of any
   extension/deep-hole concept. (F3, VERIFIED.)
2. The **coding-side source the manuscript itself cites for the dictionary** (Davydov–Marcugini–
   Pambianco) contains **no q=11 6-arc data**, and states that cᵢ values beyond a few sporadic
   *complete* arcs are undescribed in the literature. (F4, VERIFIED.)
3. The **authoritative modern arc surveys** (Ball–Lavrauw ×2) contain **zero** occurrences of
   Sadeh, Clebsch, hexagon, or A₅. (F7, VERIFIED.)
4. There is a **structural reason** the tradition would not have noticed: the classification of
   6-arcs in PG(2,11) exists *in order to build cubic surfaces*, and the Clebsch map consumes only
   the property "**the arc** is not on a conic". Nobody in that program had a reason to compute
   U(A) at all. The invariants the tradition records are Eckardt-point counts and group orders.
   (F2, F3.)

### ⚠️ Two flags that require action

**FLAG 1 — a likely mis-aimed concession (rewrite, in the manuscript's favour).** The manuscript
concedes the census and histogram to "Sadeh … **and Hirschfeld–Sadeh**, Mitt. Math. Sem. Giessen
164 (1984)". Per its zbMATH review, **the Hirschfeld–Sadeh paper is not a 6-arc paper** — it is
about Singer-cycle orbits, complete 7-arcs, and (n;3)/(n;4)-arcs. It appears to contain no 6-arc
classification and no extension data. The manuscript may be conceding priority to a paper that
does not contain the conceded result. See F5. **This does not force a retraction; it forces a
citation fix, and it makes the novelty claim stronger.**

**FLAG 2 — a conflation hazard that will cost a referee's goodwill if unaddressed.** The standing
condition throughout this literature is "**a 6-arc not on a conic**" (the Clebsch-map hypothesis).
The manuscript's condition is "**U(A) lies on a conic**". These are different conditions about
different point sets, and they sit one word apart. A referee from the Hirschfeld school will read
"conic" and reach for the familiar meaning. **Pre-empt this explicitly**, early, in one sentence.
See F2.

### Verdicts on the other questions

| Q | Verdict | Confidence |
|---|---------|------------|
| **Q1** rigidity theorem already stated? | **NOT FOUND** — no collision in any source opened | Medium — two key sources unread |
| **Q2** gap theorem / gap phenomena known? | **PARTIAL / NOT FOUND** — searched shallowly; see F8 | Low — thin coverage, do not rely |
| **Q3** group recovery from deep-hole condition? | **PARTIAL** — only the *converse* direction found | Low |
| **Q4** is the histogram concession correctly aimed? | **NO — mis-aimed at Hirschfeld–Sadeh** (F5) | Medium-high on HS84; **unknown** for the thesis |

---

## PROVENANCE LEDGER — what I actually read

Recorded precisely, because the strength of the verdict depends on it.

**Full text obtained and grepped exhaustively end-to-end:**

| Source | Extent | How closely read |
|--------|--------|------------------|
| Karaoglu 2018 thesis | full text, 16,357 lines | grepped all; **closely read** intro pp. 7–8, Table 5.1, §5.2.1, Table 5.2. Not read line-by-line. |
| DMP arXiv:2101.12722 | full text, 1,952 lines | grepped all; **closely read** Def. 6.1/6.2, Thm 6.3, eq. (6.1), bibliography. |
| Ball–Lavrauw, *Arcs in finite projective spaces* (1908.10772) | full text, 2,143 lines | grepped all; read abstract + the q=11 hit passages only. |
| Ball–Lavrauw, *Planar arcs* (1705.10940) | full text, 1,521 lines | grepped all; read abstract + the q=11 hit passages only. |
| Cook, *Arcs in a finite projective plane* (Sussex thesis, PG(2,11)) | full text, 8,162 lines | grepped all; read grep output + abstract only. |

**Read in full, but it is a review, not the source:**
- zbMATH review **Zbl 0538.51010** of Hirschfeld–Sadeh 1984 (~90 words). Quoted complete in F5.
  **F5 rests entirely on this 90-word third-party review.**

**NOT OBTAINED — zero pages read:**
- **Hirschfeld–Sadeh 1984**, Mitt. Math. Sem. Giessen 164, 245–257. Not digitized anywhere I could
  reach. ILL pending.
- **Sadeh 1984 Sussex thesis.** Not online (user-confirmed). I have only its title (quoted from
  Karaoglu's bibliography) and one citing sentence. **This is the highest-risk gap in the audit.**
- **Hirschfeld, PGOFF 2nd ed., Ch. 14 "Small planes".** archive.org 403; Google Books quota out.

**NOT SEARCHED by me:** Edge 1956; Dye 1991; Storme–Van Maldeghem 1995 (prior sweep covered Edge
and Van de Voorde — I did not re-do these, per instructions).

---

## Findings

### F1. The two 1984 Sadeh sources — reference confirmed, contents not opened

**Tier: VERIFIED (existence/title) / NOT OBTAINED (contents)**

- J. W. P. Hirschfeld, A. Sadeh, "The projective plane over the field of eleven elements",
  *Coxeter Festschrift II*, Mitt. Math. Semin. Gießen **164** (1984), 245–257.
  Confirmed via zbMATH (Zbl 0538.51010) and multiple citing bibliographies.
- A. R. Sadeh, *The classification of k-arcs and cubic surfaces with twenty-seven lines over the
  field of eleven elements*, Ph.D. thesis, University of Sussex, 1984. **VERIFIED** as a verbatim
  quote of ref [26], p. 170 of Karaoglu's thesis bibliography.

Note the thesis title's shape: **k-arcs *and cubic surfaces with 27 lines***. The 6-arc work is
instrumental to the cubic-surface classification, via the Clebsch map. That framing drives F2/F3.

### F2. Why the 6-arc classification exists — the cubic-surface program

**Tier: VERIFIED.** Fatma Karaoglu, *The cubic surfaces with twenty-seven lines over finite
fields*, Ph.D. thesis, University of Sussex, 2018, 172 pp.
PDF: https://ndownloader.figshare.com/files/41169383 ·
record: https://sussex.figshare.com/articles/thesis/The_cubic_surfaces_with_twenty-seven_lines_over_finite_fields/23461382

Quoted:

> "We use the Clebsch map to construct cubic surfaces with twenty-seven lines [in PG(3,q)] from
> **6-arcs not on a conic** in PG(2, q)."

> "In [19] and [21], the smallest cases, namely, F4, F7, F8, F9, are resolved. **Sadeh [26]
> classified the cubic surfaces with 27 lines in PG(3, 11).**"

**Table 5.1, "Cubic Surfaces for q ≤ 11"** — read directly. For q = 11 there are exactly **two**
projectively distinct 27-line cubic surfaces, both "Classified by Sadeh":

| q  | surface | e₃ (Eckardt pts) | \|G(F)\| | Common name    | Classified by |
|----|---------|------------------|----------|----------------|---------------|
| 4  | F4      | 45               | 25920    | —              | Hirschfeld    |
| 7  | F7      | 18               | 648      | Equianharmonic | Hirschfeld    |
| 8  | F8      | 13               | 192      | —              | Hirschfeld    |
| 9  | F9⁰     | 10               | 120      | Diagonal       | Hirschfeld    |
| 9  | F9¹     | 9                | 216      | —              | Hirschfeld    |
| 11 | F11⁰    | 6                | 24       | —              | Sadeh         |
| 11 | F11¹    | 10               | 120      | Diagonal       | Sadeh         |

**Reading.** The q=11 "Diagonal" surface with |G| = 120 is the Clebsch diagonal cubic surface
(Aut ≅ S₅ ⊃ A₅). This is consistent with — and is plausibly the classical origin of — naming the
A₅-stabilized 6-arc the "Clebsch hexagon". It is **not** a collision with the rigidity theorem: it
is a statement about a surface's automorphism group in PG(3,11), with no reference to U(A). It
does confirm that the A₅/S₅ symmetry of this arc is thoroughly classical — exactly as the
manuscript already concedes (Edge 1956, Dye 1991).

**This is the source of FLAG 2.** The tradition's standing hypothesis is "6-arc **not on a
conic**" — a condition on *the arc*. The manuscript's condition is "**U(A)** on a conic" — a
condition on the *complement-side* locus. Superficially near-identical, logically unrelated.
Pre-empt the conflation in the manuscript.

**Corollary for the TFAE.** The equivalence (iv) ⟺ (v) — "PGL-equivalent to the Clebsch hexagon"
⟺ "stabilizer contains A₅" — is very likely classical (Edge/Dye territory). The manuscript's
novelty is therefore concentrated in **(i)/(ii)/(iii) ⟺ (iv)/(v)**: the deep-hole side of the
biconditional. The manuscript should claim priority precisely there and not appear to claim the
(iv)⟺(v) half.

### F3. Karaoglu's thesis contains NO extension-point / deep-hole data — a meaningful negative

**Tier: VERIFIED** (exhaustive grep of the full extracted text of all 172 pp.)

- Grep for `extend|extension point|uncovered|deep hole` over the whole thesis returns **only**
  irrelevant hits (a field automorphism being "extended"; stabiliser groups "extended" in an
  algorithm step). There is **no** treatment of the points extending a 6-arc to a 7-arc.
- The 6-arc classification tables (Table 5.2 q=13, 5.3 q=17, 5.4 q=19 — sourced from Ali,
  Al-Seraji, Al-Zangana and re-verified with Orbiter) list arcs **only** as
  `sᵢ = A₁ ∪ {P(x,y,1)}` — a frame-normalized representative, nothing more. **No column records
  extension points; no conic property of any extension set is mentioned anywhere.** Verified by
  reading §5.2.1 and the tables directly.

**Why this matters.** This is the direct modern continuation of the Sadeh line — same school, same
problem, same method, explicitly resuming Sadeh's work. It tabulates 6-arcs without ever computing
U(A). That is real evidence (not proof) that the tradition's tables are indexed by cubic-surface
invariants, not extension counts — and hence that Sadeh's thesis likely did not compute U(A)
either. It is the strongest indirect argument available while the thesis is unobtainable.

### F4. The DMP dictionary citation is VERIFIED correct — and DMP has no q=11 6-arc data

**Tier: VERIFIED** — full text of arXiv:2101.12722 (Davydov, Marcugini, Pambianco, "On the weight
distribution of the cosets of MDS codes"). PDF: https://arxiv.org/pdf/2101.12722

Definition 6.2, quoted:

> "For an arc in PG(2, q), let cᵢ be the number of the points off the arc lying on i its bisecants.
> A complete (resp. incomplete) arc has c₀ = 0 (resp. c₀ > 0)."

So **c₀ = |U(A)|** exactly. Theorem 6.3(iii), quoted:

> "For c₀ = 0, the arc A is complete, C is an [n, n−3, 4]_q 2 code, we have no weight 3 cosets.
> For c₀ ≠ 0, the arc A is incomplete, C is an [n, n−3, 4]_q 3 code having (q−1)c₀ cosets of
> weight 3 …"

**The manuscript's dictionary citation (DMP Thm 6.3: U(A) ↔ coset leaders of the
covering-radius-3 cosets of the [6,3,4]₁₁ MDS code) is correct as cited.** No issue found.

**But DMP contains no q=11 6-arc data.** Exhaustive grep: zero hits for Sadeh, Clebsch, hexagon,
A₅, or 6-arcs in PG(2,11). The only sporadic small-arc c-values they list (eq. (6.1), sourced from
Hirschfeld's book §9) are for **complete** arcs — c₀ = 0 by definition, so they carry no U(A) data:

> "n = 6, q = 7, (c₁, c₂, c₃) = (18, 27, 6); n = 6, q = 8, (c₁, c₂, c₃) = (36, 24, 7);
> n = 6, q = 9, (c₁, c₂, c₃) = (60, 15, 10); n = 7, q = 11, (c₁, c₂, c₃) = (63, 42, 21)."

For q = 11 they list the complete **7**-arc, not any 6-arc. (Consistent with the manuscript: the
smallest complete arc in PG(2,11) has 7 points, so every 6-arc there is incomplete with
c₀ = |U| > 0 — which is why the histogram has no zero bin.) DMP also state that cᵢ values beyond
these sporadic cases "are not described" in the literature to their knowledge — mild corroboration
that no published |U(A)| table for 6-arcs of PG(2,11) exists on the coding side.

### F5. ⚠️ THE CONCESSION TO HIRSCHFELD–SADEH 1984 LOOKS MIS-AIMED

**Tier: VERIFIED (the review text) / INFERRED (the conclusion about the paper's contents).**
**This conclusion rests on a ~90-word third-party review and nothing else.**

zbMATH Open, **Zbl 0538.51010** — review of Hirschfeld–Sadeh, "The projective plane over the field
of eleven elements", *Coxeter Festschrift II*, Mitt. Math. Semin. Gießen **164**, 245–257 (1984).
Retrieved via the zbMATH API; record https://zbmath.org/3855866. Reviewer: **Th. Grundhöfer**.
Full review text, quoted verbatim and complete:

> "Ein Singerzyklus der projektiven Ebene PG(2,11) über GF(11) hat die Ordnung 7·19. Die Verff.
> betrachten die Bahnen der Untergruppen der Ordnung 19 bzw. 7 eines Singerzyklus und zeigen u.a.,
> daß diese Bahnen vollständige (19;3)-Bögen bzw. vollständige 7-Bögen bilden; dabei stützen sie
> sich auf eine Liste aller Geraden von PG(2,11). Ferner werden ein vollständiger (21;3)-Bogen und
> zwei Typen von (21;4)-Bögen konstruiert. Die Maximalzahl von Punkten von PG(2,11), von welchen
> höchstens 3 auf einer Geraden liegen, ist demnach eine der Zahlen 21, 22 oder 23."

My translation:

> "A Singer cycle of the projective plane PG(2,11) over GF(11) has order 7·19. The authors consider
> the orbits of the subgroups of order 19 resp. 7 of a Singer cycle and show among other things
> that these orbits form complete (19;3)-arcs resp. complete 7-arcs; they rely on a list of all the
> lines of PG(2,11). Furthermore, a complete (21;3)-arc and two types of (21;4)-arcs are
> constructed. The maximum number of points of PG(2,11) of which at most 3 lie on a line is
> therefore one of the numbers 21, 22, or 23."

**Hirschfeld–Sadeh 1984 is not a 6-arc paper.** Its subject is Singer-cycle orbits, complete
7-arcs, and (n;3)/(n;4)-arcs (arcs of higher degree: at most r points per line). Per this review
it contains no 6-arc classification, no extension-point data, no |U(A)| histogram, and nothing
about a conic through extension points.

**Consequence.** The manuscript concedes the census and the histogram to "Sadeh (Sussex thesis
~1984) **and Hirschfeld–Sadeh**, Mitt. Math. Sem. Giessen 164 (1984) 245–257". The
Hirschfeld–Sadeh half of that concession appears aimed at a paper that does not contain the
conceded result. The 6-arc classification lives in **Sadeh's thesis** — whose title is the right
target — and not, on this evidence, in the 13-page Festschrift contribution.

**Caveats, stated plainly.** (a) The review says "u.a." (*unter anderem*, "among other things") —
it is a summary, not an exhaustive contents list. A 6-arc table could in principle sit in the paper
unmentioned. (b) **I have not opened the paper.** So "HS84 does not contain the histogram" is
INFERRED from a review, not verified against text. Do not act on it as certain without the ILL
copy. (c) Corroborating but circumstantial: the *Coxeter Festschrift* framing fits the review — a
short themed contribution is not the venue for a full k-arc census; that is the thesis's job.

**Recommended action (citation fix, not retraction):** do not drop the citation — re-aim it. Cite
**Sadeh's thesis** for the census; cite Hirschfeld–Sadeh 1984 only for what it does (Singer orbits,
complete 7-arcs, (n;3)-arcs in PG(2,11)), or drop it from the concession sentence. Conceding
priority to a paper that lacks the result is its own small scholarly error, and a referee from this
school would catch it.

### F6. Availability of the primary sources

**Tier: NOT OBTAINED — this is a hard negative, recorded so nobody re-runs it.**

- **Hirschfeld–Sadeh 1984.** Mitt. Math. Sem. Giessen vol. 164 is the *Coxeter Festschrift II*
  issue. No digitized full text located anywhere. **The open ILL request remains the only route.**
- **Sadeh's 1984 thesis.** **Not available online** (user-confirmed this sweep). Corroborated:
  the figshare/Sussex Research Online repository has no Sadeh item (the API search returns
  nothing — Sussex has digitized later maths theses, e.g. Karaoglu 2018 and Cook, but a 1984
  thesis predates digital deposit); zbMATH does not index it (normal for theses); EThOS has been
  offline since the 2023 British Library cyberattack. **Routes remaining: ILL / Sussex library
  direct / ProQuest via an institution.**
- **Hirschfeld PGOFF 2nd ed. Ch. 14 "Small planes"** (chapter title VERIFIED via publisher/search
  metadata; covers planes of order ≤ 13, so the natural home of q=11 tables). archive.org holds
  both editions (`projectivegeomet0000hirs_k2s0_2nded`, `projectivegeomet0000hirs`) but all text
  routes return **HTTP 403** (in-copyright lending item: `djvu.txt`, `fulltext/inside.php`, and the
  FTS endpoints are all blocked). Google Books API quota exhausted. **Not read.**
  - Incidental, possibly useful: Ball–Lavrauw cite **"[14, Table 9.4]"** (= Hirschfeld PGOFF) as
    the table classifying arcs of size q−1 and q−2 for q ≤ 23. So the book's arc-classification
    tables sit in **Ch. 9**, not only Ch. 14 — worth checking both when a copy is in hand.

### F7. The modern arc surveys are silent — no collision

**Tier: VERIFIED** (full text of both, grepped exhaustively).

- S. Ball, M. Lavrauw, *Arcs in finite projective spaces* (expository), arXiv:1908.10772 —
  2,143 lines. **Zero** hits for Sadeh, Clebsch, hexagon, "eleven elements", A₅.
- S. Ball, M. Lavrauw, *Planar arcs*, arXiv:1705.10940 — 1,521 lines. Same: **zero** hits.
- G. R. Cook, *Arcs in a finite projective plane* (Sussex thesis; PG(2,11) is its "dominant
  focus"), https://ndownloader.figshare.com/files/41104496 — 8,162 lines. **Zero** hits for Sadeh;
  no 6-arc/conic/deep-hole content. It classifies complete **(n,3)**-arcs of PG(2,11) by stabilizer
  group — adjacent, but a different object (degree-3 arcs), not our 6-arcs.

**A near-miss, checked and cleared.** Both Ball–Lavrauw surveys contain the phrase "projectively
distinct arcs of **size 6**" for q = 11-adjacent statements. Read in context, these are Corollaries
57/58 (resp. 8/9) on complete arcs of size q−1 and q−2: the size-6 cases are **q = 7 and q = 8**
(where 6 = q−1 or q−2). The q=11 entries there are the unique complete **10**-arc and the three
complete **9**-arcs. **Nothing about 6-arcs in PG(2,11). Not a collision.**

### F8. Q2 — gap / stability phenomena. PARTIAL, thin.

**Tier: PARTIAL / NOT FOUND — one search only. Low confidence; do not rely on this section.**

- The general notion is standard and well-populated: a *stability theorem* says a nearly-extremal
  object is a small perturbation of an extremal one. Blokhuis and co-authors have stability results
  bounding the size of the **second largest** complete arc; Blokhuis–Bruen have a stability theorem
  for hyperovals. So "gap/stability results for arcs" **is an established genre** — the manuscript
  should position Claim 2 inside it rather than as a novel species of statement.
- **NOT FOUND:** any gap/stability result about the *extension-point count* |U(A)| of a small arc,
  or any second-smallest-value theory for that invariant.
- **Not searched properly:** the Segre / Korchmáros / Hirschfeld / Storme / Szőnyi / Bartoli /
  Giulietti / Marcugini / Pambianco lines individually; "almost complete arcs"; per-author sweeps.
  **Q2 needs its own pass.** I deliberately spent the budget on Q1 per instructions.

### F9. Q3 — group recovery from a deep-hole condition. PARTIAL.

**Tier: PARTIAL.** Searched once; read no source in full.

- What the literature clearly has is the **converse/forward** direction: the automorphism group of
  a code **acts on** its set of deep holes, and this is used *as a tool to determine the deep
  holes* (e.g. PGL₂(F_q) acting on deep-hole classes of projective Reed–Solomon codes — Wan et al.,
  arXiv:1605.02423, arXiv:1901.05445; https://www.math.uci.edu/~dwan/deepproj.pdf).
  That is the opposite of the manuscript's logical direction.
- **NOT FOUND:** any result *recovering* an automorphism group from a covering-radius / deep-hole
  condition, for any code. The manuscript's Corollary direction ("deep holes lie on a conic ⟹
  stabilizer ⊇ A₅") appears unlocated.
- **Caution recorded:** a search engine offered a summary asserting this relationship "can in turn
  be used to understand the structure of the automorphism group". **That was the engine's own
  gloss, not a citation, and I did not find a source behind it. It must not be cited.**
- A clean NOT FOUND here is the expected outcome and is fine, per the task framing. Treat as
  **suggestive of novelty, not established** — the search was shallow.

---

## Recommended actions for the manuscript

1. **Re-aim the Hirschfeld–Sadeh citation** (F5). Cite the **thesis** for the census; cite HS84
   only for Singer orbits / complete 7-arcs / (n;3)-arcs, or drop it from the concession sentence.
   **Gate on the ILL copy before finalizing** — the finding is INFERRED from a review.
2. **Consider softening the concession itself** (Q4, F5 + F3). The manuscript concedes that the
   histogram "belongs to" Sadeh/Hirschfeld–Sadeh. On this evidence, HS84 does not contain it, and
   whether the *thesis* tabulates |U(A)| is **unknown and currently unknowable** — with F3 arguing
   the tradition had no reason to compute it. Safest form: concede the **classification** (which
   the thesis certainly does contain, per its title and Karaoglu's citing sentence) while noting
   the **histogram is entailed by, but not necessarily stated in**, that work. That is defensible
   without having read the thesis, and it stops conceding something the paper may not need to.
3. **Pre-empt the "conic" conflation** (F2, FLAG 2). One early sentence distinguishing "the arc is
   not on a conic" (the classical Clebsch-map hypothesis) from "U(A) lies on a conic" (this paper's
   condition).
4. **Sharpen where priority is claimed** (F2). (iv) ⟺ (v) is very likely classical (Edge/Dye). Claim
   priority on **(i)/(ii)/(iii) ⟺ (iv)/(v)** — the deep-hole side. Presenting the whole TFAE as new
   invites a referee to point at the classical half.
5. **Position Claim 2 inside the existing stability genre** (F8), rather than as a new species of
   theorem — after Q2 gets a proper pass.

## Residual risk — what could still overturn this

| Risk | Severity if realized | Mitigation |
|------|---------------------|------------|
| Sadeh's thesis tabulates extension points and notes the conic | **Would take the rigidity theorem's (ii)** | ILL / Sussex library / ProQuest. **Unresolved — the one real hole.** |
| PGOFF Ch. 9 / Ch. 14 tables carry a q=11 6-arc extension column | Would take (iii), maybe (ii) | Get a physical/borrowed copy; check **both** Ch. 9 (Table 9.4) and Ch. 14 |
| HS84 contains an unreviewed 6-arc section | Would restore the original concession (no novelty loss) | ILL — already open |
| Q2/Q3 collisions in unsearched author lines | Would weaken Claim 2 / the corollary framing | Dedicated Q2 pass |

---

## Search log (chronological)

1. Confirmed Hirschfeld–Sadeh 1984 title/pagination — multiple citing bibliographies.
2. Confirmed Sadeh 1984 thesis title — VERIFIED via Karaoglu's bibliography.
3. Downloaded + read Karaoglu 2018 Sussex thesis (full text). → F2, F3.
4. Downloaded + read DMP arXiv:2101.12722 (full text). → F4.
5. zbMATH API — retrieved the Grundhöfer review of Hirschfeld–Sadeh 1984. → F5. Also enumerated
   **all** zbMATH items by any author "Sadeh": the 1984 Festschrift paper is the only
   finite-geometry item by A. R. Sadeh in the database.
6. Attempted Hirschfeld PGOFF Ch. 14 via archive.org (3 endpoints, all 403) and Google Books API
   (quota exhausted). → F6, NOT OBTAINED.
7. Attempted Sadeh thesis via figshare/SRO API + EThOS/ProQuest search. Not online (user-confirmed).
   → F6.
8. Downloaded + grepped Ball–Lavrauw ×2 and Cook's Sussex PG(2,11) thesis. → F7.
9. Single searches on Q2 (stability/gap for arcs) and Q3 (group recovery from deep holes). → F8, F9.
