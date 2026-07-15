# C191 — Instrument calibration: Edge 1956's citers, three indexes, non-circular

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-07-15
**Status**: **REPORTED, PROVISIONAL** — measurement complete and reproducible; the reasoning over it
is a mining session's and is not load-bearing until vetted. The vet is the user's to launch.

Closes item 1 of [C191](2026-07-15-c191-gap-mining-backfill.md) § Next and item 2 of
[the method](2026-07-15-gems-theory-gaps-method.md) § First steps: calibrate object-level citation
closure by a route that does not pass through OpenAlex, then diff.

Reproduce: `python3 notes/2026-07-15-c191-instrument-calibration.py` (stdlib only, queries live).

## Verdict

**The instrument is not a census, and the founding cell's headline number was both
instrument-specific and inflated by self-citation. The substantive claim survives anyway — and the
cause it supports comes out stronger than the backfill had it, for a reason the backfill missed.**

Three things, kept separate because they point different ways:

1. **No index is a superset of the others.** OpenAlex 7, zbMATH 3, Semantic Scholar 7-real; the union
   is 8. zbMATH sees fewer than half the union. Object-level closure on a mid-century seed is
   therefore **a lead, not a reading** — the method's § Instruments caution is now measured rather
   than hypothesized, and it should stay in force.
2. **Three of the seven are W. L. Edge citing himself.** The independent citer count is **4**
   (OpenAlex, Semantic Scholar) or **1** (zbMATH), not 7. The method doc and C191 both lean on
   "seven indexed citers"; that figure is raw, and raw is the wrong statistic for a fame-asymmetry
   cause.
3. **Zero coding-venue citers in any index, self-cites excluded or not.** The Clebsch row's claim
   holds, now against three independent instruments instead of one.

## The union

Union of the three indexes, Beebe bibliography compilations excluded as extraction artifacts
(see § Artifacts). `✓` = present, `—` = absent.

| Year | Venue                | Citing work                                    | Author          | OA | zbM | S2 |
|------|----------------------|------------------------------------------------|-----------------|----|-----|----|
| 1959 | Arch. Math.          | Separation, betweenness, and congruence …      | T. G. Ostrom    | ✓  | ✓   | ✓  |
| 1962 | Amer. Math. Monthly  | "Mathematical Notes" — section bundle          | Ostrom, et al.  | ✓  | —   | —  |
| 1963 | Camb. Phil. Soc.     | A second note on the simple group of order 6048| **W. L. Edge**  | ✓  | —   | ✓  |
| 1975 | Geom. Dedicata       | A geometric approach to counting squares …     | N. C. Raber     | ✓  | —   | ✓  |
| 1975 | Camb. Phil. Soc.     | A footnote on the mystic hexagram              | **W. L. Edge**  | ✓  | ✓   | ✓  |
| 1985 | J. Algebra           | PGL(2,11) and PSL(2,11)                        | **W. L. Edge**  | ✓  | ✓   | ✓  |
| 1988 | Ann. Discrete Math.  | Midpoints and Midlines in a Finite Hyperbolic  | C. W. L. Garner | ✓  | —   | ✓  |
| ?    | — (stub record)      | On Galois Geometries — **unverified lead**     | B. Segre        | —  | —   | ✓  |
| 1991 | J. London Math. Soc. | Hexagons, conics, A₅ and PSL₂(K) — **VERIFIED, ALL THREE MISS** | R. H. Dye | — | — | — |

Bold = self-citation. **Nothing in this table is a coding venue.**

**The last row is a ground-truth counterexample to the instrument, added 2026-07-15 after the paper
was obtained.** Dye 1991 cites Edge 1956 — verified from Dye's own reference list, which reads
`6. W. L. EDGE, 'Conics and orthogonal projectivities in a finite plane', Canad. J. Math. 8 (1956)
362-382`, and cites it in §1.4 (*"If K is GF(11) then Edge [6, p. 380] has presented a hexagon whose
vertices are external points…"*). **No index has it.** Two claims in the original version of this
report are therefore false and are corrected here rather than deleted:

- ~~"nothing postdates 1988"~~ — Dye 1991 does.
- ~~"the union is 8"~~ — the union is **at least 9**, and 9 was reached not by a better query but by
  someone physically obtaining the paper.

This is no longer an argument that the instrument undercounts. **It is a measurement of the
undercount against a known-correct answer**, and the missed citer is the one the lane most cares
about: Dye 1991 is the paper the `clebsch` priority footnote is about. Every index reports the
citation record of a 1956 paper as ending in 1988; a 1991 paper citing it sat outside all three.

**The independent citers are at most four people in thirty-two years**: Ostrom (1959, and among the
eight authors of the 1962 bundle), Raber (1975), Garner (1988), and Segre if the lead holds. Everything
else is Edge citing Edge.

## What each index gets wrong

- **zbMATH sees 3 of 8, and 2 of its 3 are self-citations** — one independent citer total. As a
  calibrator it is *weaker* than the instrument under test, which is the opposite of what § First
  steps assumed when it named zbMATH as the non-circular route. It still does the job: it is
  independent, and it fails to overturn the claim.
- **OpenAlex misses the Segre lead** and indexes the 1962 *Monthly* at section granularity — one DOI,
  eight authors, pages 889–909, a bundle of unrelated short notes. The citing note is inside it
  (Ostrom is among the authors, and Ostrom is a finite geometer). Not an artifact; a granularity
  mismatch that inflates the count by attributing one note's citation to a whole section.
- **Semantic Scholar misses the *Monthly* bundle** and contributes three Beebe BibTeX bibliographies
  as citers.

### The Segre lead — not scored

S2 asserts a citation edge from **B. Segre, "On Galois Geometries"** to Edge 1956. It is the one
potentially load-bearing item either of the other indexes could have caught and did not: Segre founded
the Italian school of finite geometry, and his survey is exactly the document a "does the far field
know this object" question turns on.

**It is not scored, because the S2 record is a stub** — no year, no venue, no DOI, no indexed
references (`CorpusId 2043513`). The edge cannot be verified from the record, and this lane does not
promote plausible to confirmed. It would not change the coding verdict in any case: Segre's survey is
geometry. **Next step to close it**: identify the intended paper (likely B. Segre, *On Galois
geometries*, Proc. ICM 1958, or *Le geometrie di Galois*, Ann. Mat. Pura Appl. 48 (1959) 1–96) and
check its reference list at full text.

### Artifacts

Excluded from all counts: `Title word cross-reference` (×2, duplicate record) and
`mathématiques for the decade 1950–1959`, all by N. H. F. Beebe — BibTeX bibliography files, not
documents that cite Edge mathematically.

### Instrument trap, recorded

zbMATH's `rf:` reference search keys on the **internal document id** (`rf:3121304`), not the Zbl code
(`rf:0072.38102`), which returns `404 Entry not found`. That 404 is an unsupported-field error and
reads exactly like a genuine empty result. Controlled before use: `rf:` 404s for every Zbl-code id
tried while `an:` returns 200. **An uncontrolled `rf:<Zbl code>` query reports every paper in
mathematics as uncited** — precisely the confabulated-absence failure this lane fences, arriving from
the tooling rather than the model.

## What this does to C191's Clebsch row

The row reads:

> **Out-of-sample prediction of the cause**: a social two-community cause predicts near-zero
> cross-citation at the object level. **Confirmed**: Edge 1956's indexed citers are geometry and group
> theory throughout, not one coding venue.

**The prediction is not falsified, and the cause is strengthened — but "Confirmed" is the wrong
label, for a reason worth stating precisely.**

**The strengthening.** The backfill argued fame asymmetry: classical in geometry, invisible in coding.
The citation record says something sharper. Edge 1956 was cited by **four people who were not Edge, in
thirty-two years, and by nobody at all after 1988**. The object was not merely unnamed in coding — it
was close to orphaned in its *own* field, with its author the primary custodian of its citation record.
That is a stronger and more specific fact than "no coding venue cited it", and it is *more* consistent
with the fame-asymmetry cause than the evidence originally offered.

**The weakening.** The instrument's failure mode is **missing citers**, which biases readings toward
*emptier*. That is the same direction as the hypothesis. A fame-asymmetry cause predicts near-zero
cross-citation; an under-indexing instrument manufactures near-zero cross-citation whether or not the
cause is real. **The confirmation was produced by an instrument whose known error mode fabricates
exactly this confirmation** — so the reading is consistent-with, not confirming. Three independent
indexes agreeing raises the floor, because three instruments failing in the same direction on the same
seed is less likely than one; it does not reach "confirmed", because they share a common cause
(sparse mid-century reference capture from digitized sources) and are therefore not independent in
their *failure*, only in their construction.

**Required change to C191** (MUST, and not a change a mining session should make to a report awaiting
its vet — flagged here for the vet to rule on):

1. Downgrade **Confirmed** to **consistent across three independent indexes; not confirmed** — with
   the bias direction named, since a reader who sees "confirmed" will not reconstruct that the
   instrument tilts toward the answer it gave.
2. Replace "seven indexed citers" with **"four independent citers in thirty-two years, three
   self-citations, none in coding, none after 1988"** — in C191 and at
   `2026-07-15-gems-theory-gaps-method.md` § Instruments, which carries the same raw figure.
3. Record that the *strengthened* version of the cause (near-orphaned in its own field) is available
   and better, but is **new reasoning from this pass and unvetted** — it must not be promoted into the
   Clebsch row on my say-so.

## What I could not check

- **MathSciNet** — the method's other named route; subscription-gated, not queried. It is the one
  remaining index with plausibly better mid-century reference capture than any of the three here, and
  it is the natural way to settle the Segre lead and test whether the union is still an undercount.
  **Whether the user has access is unresolved.**
- **The true citer set.** All three indexes derive substantially from digitized reference lists, which
  are sparse before ~2000. The union of 8 is a lower bound and no route here can turn it into a census.
  A book-level check (Hirschfeld's *Projective Geometries over Finite Fields*, Segre's surveys, Dye
  1991) would probe the ceiling; books are the known blind spot of all three indexes.
- **Whether the 1962 *Monthly* citing note is Ostrom's.** Inferred from his presence among the eight
  authors and his field, not verified against the page.
