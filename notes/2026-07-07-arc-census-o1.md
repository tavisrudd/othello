# Complete-arc census — PG(2,q), q ∈ {23,25,27,29,31,32}  (task O1, 2026-07-07)

Pure tabulation of complete-arc size spectra and per-size counts from the complete-arc
classification literature. No interpretation, no synthesis. Each row carries a per-claim
citation (paper + table/section). Wording of the source ("proven" vs "computed" vs
"partial") is preserved. A GAPS section at the end lists exactly which (q, cell) values
could NOT be sourced and which papers still need reading.

## Sources actually read (this session)

- **[MMP-min]** S. Marcugini, A. Milani, F. Pambianco, *"Minimal complete arcs in PG(2,q),
  q ≤ 32"* — **arXiv:1005.3412** (full text extracted from the arXiv PDF). Determines
  t₂(2,31), t₂(2,32); gives a t(2,q)-table for q ≤ 29 and partial 14-arc classifications.
- **[CS-2729]** K. Coolsaet, H. Sticker, *"The complete k-arcs of PG(2,27) and PG(2,29)"*,
  J. Combin. Des. **19(2) (2011) 111–130** (DOI 10.1002/jcd.20261). Full text extracted from
  the Ghent open-access PDF (backoffice.biblio.ugent.be/download/1247338/1247417). Contains
  the full per-size classification (Tables 1–5).
- **[BDFKMP-tab]** D. Bartoli, A. A. Davydov, G. Faina, A. A. Kreshchuk, S. Marcugini,
  F. Pambianco, *"Tables, bounds and graphics … PG(2,q) for all q ≤ 160001 …"* —
  **arXiv:1312.2155** (abstract + Table 1 rows via ar5iv). Cross-check of minimum sizes only.
- **[BDFMP-sizes]** D. Bartoli, A. A. Davydov, G. Faina, S. Marcugini, F. Pambianco,
  *"On sizes of complete arcs in PG(2,q)"* — **arXiv:1011.3347** (Table 1 via ar5iv).
  Cross-check of minimum sizes only; covers larger q for bounds (not per-size counts here).

## Companion classification papers CITED by the above but NOT reachable this session

(All access attempts logged in GAPS. Wiley paywalled 402/403; academia.edu 403;
twizz.ugent.be down; biblio.ugent.be search endpoint HTTP 500; caagt.ugent.be preprints
discontinued.)

- **[CS-2325]** K. Coolsaet, H. Sticker, *"A full classification of the complete k-arcs of
  PG(2,23) and PG(2,25)"*, J. Combin. Des. **17(6) (2009) 459–477** (DOI 10.1002/jcd.20211).
  = full per-size counts + automorphism-group breakdown for **q = 23 and q = 25**. [not read]
- **[Cool-31]** K. Coolsaet, *"The complete arcs of PG(2,31)"*, J. Combin. Des. **23(12)
  (2015) 522–533** (DOI 10.1002/jcd.21410). = full per-size classification for **q = 31**. [not read]
- **[MMP-25spec]** S. Marcugini, A. Milani, F. Pambianco, *"Complete arcs in PG(2,25): the
  spectrum of the sizes and the classification of the smallest complete arcs"*, Discrete Math.
  **307 (2007) 739–747**. = spectrum of sizes for **q = 25**. [not read — ScienceDirect/CORE blocked]
- **[FMMP-23spec]** G. Faina, S. Marcugini, A. Milani, F. Pambianco, *"The spectrum of the
  values k for which there exists a complete k-arc in PG(2,q) for q ≤ 23"*, Ars Combinatoria
  **47 (1997) 3–11**. = spectrum of sizes for **q = 23** (and below). [not read]
- **[Keri]** G. Kéri, *"Types of superregular matrices and the number of n-arcs and complete
  n-arcs in PG(r,q)"*, J. Combin. Des. **14 (2006) 363–390**. Per [CS-2729] intro: classifies
  all arcs of size **k ≥ q − 8 for q ≤ 32** (MDS-code context) — i.e. holds the LARGE-size
  counts for all six q. [not read — Wiley]

---

## Minimum complete-arc size t₂(2,q) — cross-sourced, all six q

| q  | t₂(2,q) | source(s)                                                                 |
|----|---------|---------------------------------------------------------------------------|
| 23 | 10      | [MMP-min] "Value of t(2,q), q≤29" table; [BDFKMP-tab] Table 1 (marked exact) |
| 25 | 12      | [MMP-min] "Value of t(2,q), q≤29" table; [BDFKMP-tab] Table 1 (marked exact) |
| 27 | 12      | [MMP-min] table; [BDFKMP-tab] Table 1; [CS-2729] §4.2 ("12 is the smallest") |
| 29 | 13      | [MMP-min] table; [BDFKMP-tab] Table 1; [CS-2729] §5.2 ("smallest … is 13")   |
| 31 | 14      | [MMP-min] §2 ("t₂(2,31)=14", exhaustive computer proof); [BDFKMP-tab] Table 1 |
| 32 | 14      | [MMP-min] §2 ("t₂(2,32)=14", exhaustive computer proof); [BDFKMP-tab] Table 1 |

Both arXiv sources agree on all six; [BDFKMP-tab] marks each with a "exact value" dot marker.

---

## q = 23

- **t₂(2,23) = 10** — sourced (table above).
- **Full spectrum (which sizes exist): GAP.** Lives in [FMMP-23spec] (spectrum) and
  [CS-2325] (spectrum + counts). Not accessed.
- **Per-size counts: GAP.** Live in [CS-2325] (number of inequivalent complete k-arcs by
  size and automorphism-group type). Not accessed.
- **Large-size counts (k ≥ 15 = q−8): GAP.** Also in [Keri]. Not accessed.

## q = 25

- **t₂(2,25) = 12** — sourced (table above).
- **Full spectrum: GAP.** Lives in [MMP-25spec] (title = "the spectrum of the sizes") and
  [CS-2325]. Not accessed.
- **Per-size counts: GAP.** Live in [CS-2325]. Not accessed.
- **Large-size counts (k ≥ 17): GAP.** Also in [Keri]. Not accessed.

## q = 27 — FULLY SOURCED

Source: **[CS-2729] Table 1** ("Numbers of complete k-arcs in PG(2,27) listed according to
size and automorphism group types"), counts up to **PΓL(3,27)**-equivalence. Nₖ = number of
projectively inequivalent complete k-arcs of size k.

Spectrum statement (verbatim, [CS-2729] §4): *"There are no complete k-arcs when k < 12,
k = 20, k = 21, 23 ≤ k ≤ 27 or k > 28."* ⇒ spectrum = {12, 13, 14, 15, 16, 17, 18, 19, 22, 28}.

| k   | Nₖ (PΓL-ineq.) | parity | note                                              |
|-----|----------------|--------|---------------------------------------------------|
| 12  | 7              | even   | smallest; one has group S₄ ([CS-2729] §4.2)       |
| 13  | 221,429        | **ODD**|                                                   |
| 14  | 106,320,273    | even   | two have group D₁₄ ([CS-2729] §4.3)               |
| 15  | 198,631,499    | **ODD**|                                                   |
| 16  | 20,335,114     | even   | incl. unique D₂₆/13:6 and unique Q₈/SL(2,3) arcs  |
| 17  | 276,112        | **ODD**|                                                   |
| 18  | 950            | even   | incl. unique 3²:2 arc; 25 with S₃                 |
| 19  | 5              | **ODD**| one on an irreducible cubic ([CS-2729] §4.8)      |
| 22  | 1              | even   | unique; D₁₄/7:6 (Chao–Kaneta arc)                 |
| 28  | 1              | even   | the conic (q+1); group PΓL(2,27)                  |

- **Odd sizes present: 13, 15, 17, 19** (all four have Nₖ as listed).
- No complete arcs of any odd size ≥ 21 (spectrum has no odd k above 19).
- Additional in [CS-2729]: **Table 2** = algebraic-curve cross-classification of the same arcs
  (columns: conic / irr. cubic / conic+1 / conic+2 / conic+3 / cubic+1 / conic+4 / cubic+2 /
  2 conics / irr. quartic / other). **Table 5** = numbers of PΓL-inequivalent k-arcs (NOT
  necessarily complete), k = 4..28.

## q = 29 — FULLY SOURCED

Source: **[CS-2729] Table 3** ("Numbers of complete k-arcs in PG(2,29) …"), counts up to
**PGL(3,29) = PΓL(3,29)**-equivalence.

Spectrum statement (verbatim, [CS-2729] §5): *"There are no complete k-arcs when k < 13,
k = 22, k = 23, 25 ≤ k ≤ 29 or k > 30."* ⇒ spectrum = {13, 14, 15, 16, 17, 18, 19, 20, 21, 24, 30}.

| k   | Nₖ (proj. distinct) | parity | note                                              |
|-----|---------------------|--------|---------------------------------------------------|
| 13  | 708                 | **ODD**| smallest; unique arc w/ group 13:3 ([CS-2729] §5.2)|
| 14  | 171,139,332         | even   | two have group D₁₄ ([CS-2729] §5.3)               |
| 15  | 7,402,140,892       | **ODD**|                                                   |
| 16  | 4,776,509,549       | even   | incl. unique D₃₀ arc ([CS-2729] §5.1)             |
| 17  | 271,929,757         | **ODD**|                                                   |
| 18  | 2,457,679           | even   | four have group S₄ ([CS-2729] §5.4)               |
| 19  | 4,190               | **ODD**|                                                   |
| 20  | 57                  | even   | incl. unique D₂₀ arc ([CS-2729] §5.5)             |
| 21  | 2                   | **ODD**| both with group S₃ ([CS-2729] §5.6)               |
| 24  | 1                   | even   | unique; Klein quartic, group PSL(2,7) (§5.7)      |
| 30  | 1                   | even   | the conic (q+1); group PGL(2,29)                  |

- **Odd sizes present: 13, 15, 17, 19, 21** (all five have Nₖ as listed).
- Additional in [CS-2729]: **Table 4** = algebraic-curve cross-classification; **Table 5** =
  numbers of (not-necessarily-complete) k-arcs, k = 4..29.

## q = 31 — PARTIAL (minimum proven; full spectrum/counts = GAP)

Source: **[MMP-min]** (arXiv:1005.3412).

- **t₂(2,31) = 14**, proven by exhaustive computer search up to PGL(3,31) (§2). Verbatim
  support: during the classification of arcs of size ≤ 8 up to PGL(3,31): "11 non-equivalent
  arcs of size five, 905 … size six, 66,272 … size seven and 3,768,298 … size eight"; each
  8-arc extended, "No examples have been found, so t₂(2,31) = 14."
- **14-arcs — PARTIAL classification only** (§3, wording preserved: "we performed a **partial**
  search for examples of 14-arcs … We stopped the search … after having found 500,000 examples
  … partial classification … using MAGMA"). Result, up to PGL(3,31):
  **3391 non-equivalent examples** = 3286 (trivial stab.) + 97 (order 2) + 3 (≅ Z₄) +
  4 (≅ Z₂×Z₂) + 1 (≅ S₃).  ← this is a lower-bound sample of the 14-arcs, **NOT a proven full
  count**; preserve as "partial".
- **Full spectrum (all sizes) and per-size counts: GAP.** Live in **[Cool-31]** (JCD 23, 2015).
  Not accessed.
- **Large-size counts (k ≥ 23): GAP.** Also in [Keri]. Not accessed.

## q = 32 — PARTIAL (minimum proven; full spectrum/counts = GAP)

Source: **[MMP-min]** (arXiv:1005.3412).

- **t₂(2,32) = 14**, proven by exhaustive computer search up to PΓL(3,32) (§2). Support:
  classification of arcs of size ≤ 8 up to PΓL(3,32) gave "3 … size five, 213 … size six,
  16,593 … size seven and 1,031,750 … size eight"; extended, none complete of size ≤ 13 ⇒
  "t₂(2,32) = 14."
- **14-arcs — PARTIAL classification only** (§3, "We have stopped the search for 14-arcs …
  after having found 20,000 examples"), up to PΓL(3,32). **DISCREPANCY (verbatim, internal to
  the paper):** the Introduction states **"9300 non-equivalent examples"**, while the §3
  breakdown reads "8759 … trivial stabilizer group and 541 … order two, one … Z₄ and one … Z₅"
  = **8759 + 541 + 1 + 1 = 9302**. Reported as-is; not resolved.  ← again a partial sample,
  NOT a proven full count.
- **Full spectrum (all sizes) and per-size counts: GAP.** No published full classification of
  the complete arcs of PG(2,32) was located this session (see GAPS). [Keri] would hold only the
  large-size k ≥ 24 counts.

---

## Data / code availability statements (verbatim, where found)

- **[CS-2729]** (q=27,29): programs "written in Java"; generation of all complete arcs of
  PG(2,27) "takes approximately 33 days of CPU time", PG(2,29) "approximately 1870 days (five
  years)"; "To store the results (in compressed form) we need about 130GByte of disk space."
  **No download URL / website / online-appendix link is given in the paper text.** The full
  data is presented in-paper as Tables 1–5. (Estimate for q=31 with same algorithm: "about
  110 000 days (three centuries) and 9000 GByte of storage.")
- **[MMP-min]** (q=31,32): "partial classification … using MAGMA." Explicit 14-arc
  representatives are printed in §3 (one S₃ 14-arc for q=31; one Z₄ and one Z₅ 14-arc for q=32).
  No data website stated.
- **[BDFKMP-tab]** (arXiv:1312.2155): abstract states accompanying CSV data files
  "dataTable1-6.csv" (smallest-known-size tables for the full q ≤ 160001 range) — these are
  smallest-size tables, NOT per-size spectra for the six small q here.
- **[CS-2325]/[Cool-31]/[MMP-25spec]/[FMMP-23spec]/[Keri]**: data/code availability NOT
  checked (papers not accessed).

---

## GAPS — (q, cell) values NOT sourced this session, and where they live

Access failures logged (all this session, 2026-07-07):
Wiley Online Library → HTTP 402/403; academia.edu → HTTP 403; twizz.ugent.be (Coolsaet
homepage) → connection refused / timeout; biblio.ugent.be search + WebFetch → HTTP 500;
core.ac.uk / fileserver-az.core.ac.uk (Marcugini q=25 PDF) → HTTP 403 / 404 / empty;
ScienceDirect → HTTP 403; caagt.ugent.be/preprints → discontinued ("we do no longer provide
preprints on this server"). The Ghent q=27,29 PDF *was* reachable (used above); the analogous
q=23/25 and q=31 Ghent download IDs were not indexed and the biblio browse endpoint was down.

Unsourced cells (nothing filled from memory):

| q  | missing                                                    | source that holds it (needs reading)          |
|----|-----------------------------------------------------------|-----------------------------------------------|
| 23 | full spectrum (which sizes exist)                         | [FMMP-23spec] Ars Comb. 47 (1997); [CS-2325]  |
| 23 | per-size counts Nₖ (incl. odd sizes)                      | [CS-2325] JCD 17 (2009) tables                |
| 23 | large-size counts k ≥ 15 (=q−8)                           | [Keri] JCD 14 (2006)                          |
| 25 | full spectrum (which sizes exist)                         | [MMP-25spec] Discrete Math. 307 (2007); [CS-2325] |
| 25 | per-size counts Nₖ (incl. odd sizes)                      | [CS-2325] JCD 17 (2009) tables                |
| 25 | large-size counts k ≥ 17                                  | [Keri] JCD 14 (2006)                          |
| 31 | full spectrum (which sizes exist)                         | [Cool-31] JCD 23 (2015) 522–533               |
| 31 | per-size counts Nₖ (incl. odd sizes)                      | [Cool-31] JCD 23 (2015) tables                |
| 31 | proven full count of 14-arcs (have only a 3391 partial)   | [Cool-31] JCD 23 (2015)                        |
| 31 | large-size counts k ≥ 23                                  | [Keri] JCD 14 (2006)                          |
| 32 | full spectrum (which sizes exist)                         | none located (no full PG(2,32) classification found) |
| 32 | per-size counts Nₖ (incl. odd sizes)                      | none located                                  |
| 32 | proven full count of 14-arcs (have only a 9300/9302 partial) | none located                              |
| 32 | large-size counts k ≥ 24                                  | [Keri] JCD 14 (2006)                          |

Also unresolved (not from memory — flagged for a reader with journal access):
- The [MMP-min] "Value of t(2,q), q ≤ 29" table lists a "Number of classes up to PGL(2,q)" and
  "up to PΓL(2,q)" column (= count of the *smallest* complete arcs per q). The PDF text
  extraction scrambled the two-column alignment, so only the two values cross-validated against
  [CS-2729] are reported: q=27 smallest-count = 7, q=29 smallest-count = 708 (both PΓL). The
  q=23 and q=25 smallest-arc counts from that same [MMP-min] table were **not reliably
  transcribable** from the text dump — re-read the arXiv:1005.3412 PDF table directly.

## Fully sourced vs gapped — at a glance

| q  | min size | full spectrum | per-size counts | odd-size counts |
|----|----------|---------------|-----------------|-----------------|
| 23 | ✓        | GAP           | GAP             | GAP             |
| 25 | ✓        | GAP           | GAP             | GAP             |
| 27 | ✓        | ✓ [CS-2729]   | ✓ [CS-2729] T1  | ✓ 13,15,17,19   |
| 29 | ✓        | ✓ [CS-2729]   | ✓ [CS-2729] T3  | ✓ 13,15,17,19,21|
| 31 | ✓        | GAP           | GAP (3391 partial only) | GAP     |
| 32 | ✓        | GAP           | GAP (9300/9302 partial only) | GAP  |
