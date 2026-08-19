# C876 follow-up — in-book search of Seidel's *Selected Works* for a two-graph reconstruction theorem

**Date:** 2026-08-19
**Lane:** `clebsch`
**Owning record:** `2026-08-05-c876-two-graph-literature-audit.md`, access-gap item
"Seidel (1976) and Seidel–Taylor (1981)"
**Status:** partial closure of the access gap; negative upgraded but still bounded, now by OCR
quality rather than by non-acquisition

## Why this was run

C876 carried both two-graph surveys as *could not access*, and named them the principal limitation
on its negative that no two-graph reconstruction-from-local-data theorem predates Paper III's
`thm:aligned-faithfulness`. Neither conference volume is online and both are paid-download only.
Both are reprinted in *Geometry and Combinatorics: Selected Works of J. J. Seidel* (Corneliss,
Seidel and Wilf, eds., Academic Press, 1991), which is searchable on Google Books in snippet view.
The user ran the query set below against that volume.

## Queries and results

Searched by the user, 2026-08-19, in-book search on Google Books, volume as above.

```
determined by its        -> 1 substantive hit (quoted below)
reconstruction           -> 0
descendant               -> 0
hypomorphic              -> 0
Ulam                     -> citation only, no statement
even number of triples   -> 0
quadruple                -> 0
4-subset                 -> hits only inside a Steiner-system definition
coherent                 -> 1 hit, "coherent configuration" in Higman's sense (false friend)
switching                -> hits, definitional (switching with respect to a vertex)
Bolyai                   -> hits
second survey            -> hits
```

The last two are the coverage calibration: both the 1976 survey and the 1981 Seidel--Taylor second
survey are inside the indexed portion of the volume, so the zero-hit results above bear on both
surveys and not merely on the first.

Second round, OCR-robust re-queries, same session:

```
recon                    -> 0
is determined by         -> hits; the one outside the p. 299 statement is quoted below
```

The `recon` miss adds little on its own: Google Books matches words and prefixes rather than
arbitrary substrings, so it is not a reliable way to reach "reconstruction" past a garbled ending.
The direct `reconstruction` miss above remains the load-bearing one.

The second `is determined by` hit, transcribed with its OCR errors:

> ... Γ, which has 9, 15, 27 vertices, respectively, is a uniquely determined ...
> Remark 2.11. Similar methods may be used to prove the characterization ...

This is a uniqueness-of-a-strongly-regular-graph characterization on fixed parameter sets, not a
reconstruction from local data. It does not bear on `thm:aligned-faithfulness`.

The `determined by its` hit, transcribed from the snippet with its OCR errors left in place:

> For any w ∈ Ω, the triple set Δ of any two-graph (Ω,Δ) is determined by its triples containing ω.
> Indeed, {ω,ω₁,ω₂,ω₃} ∈ Δ whenever an odd number of the other 3-subsets of {ω,ω₁,ω₂,ω₃} belong
> to Δ.

The hit is on **page 299** of the reprint volume. Which reprinted paper that is has not been
confirmed. The volume's table of contents, read from the publisher's listing, places the two
surveys in Part II, *Lines with Few Angles*, as items 10 and 14; secondary listings give their
reprint ranges as roughly 146--176 and 231--254, which are unverified search-summary numbers rather
than a checked source. On those numbers page 299 falls in Part III, *Matrices and Forms*, whose
two-graph-bearing items are *Quadratic Forms over GF(2)* and *On Two-Graphs and Shult's
Characterization of Symplectic and Orthogonal Geometries Over GF(2)*. Confirming this needs only
the running head or nearest chapter opening at page 299.

## Verdict

**No pre-emption located.** The single substantive hit is the rooted determination of a two-graph
by its descendant at a point — the two-graph parity axiom read as a recovery rule. It is not the
paper's theorem and does not reduce to it in either direction:

- Its data is the full value of every triple through a fixed point ω, that is \(\binom{n-1}2\)
  triple values. Paper III's data is one derived bit per four-set, and no triple value is ever
  supplied to the decoder.
- Its conclusion is exact given the star. Paper III's conclusion is determination up to complement,
  which is forced because the alignment observable is invariant under complementation.

This is the mechanism Paper III already cites as standard: the two-graph parity equation and the
descendant correspondence, credited to Higman, Taylor and Seidel via Brouwer and Van Maldeghem
§1.1.12 at `sections/05-golden-operator.tex:516-521`. The hit confirms that attribution against the
primary source rather than disturbing it. No manuscript change follows.

`coherent` is a false friend and must not be adopted as vocabulary for the alignment condition:
in this volume it means a coherent configuration in Higman's sense, an association-scheme notion
unrelated to four-set alignment.

## Bound on the negative

The negative is stronger than it was, but it is not clean, and the reason is OCR rather than
coverage. The volume is a degraded scan: the snippet returned for `switching` renders the word as
"Snitohing" and "arltching" in running text, and "complementation" as "complesentation". A
zero-hit result on a term like `reconstruction` therefore cannot be read as absence from the page
image — the index may simply never have seen the word. The queries that returned hits prove the
volume is indexed and searchable; they do not prove the misses are real.

Carried forward as the remaining gap: OCR-robust re-queries — a `recon` substring for the whole
reconstruct family, `is determined by` as a calibrated phrase already known to be indexed here, and
a size-naming query pairing `subsets of` with a numeral. A clean library copy of either original
volume, or of this reprint, would close it outright.

## Downstream consequence, not yet applied

Once the OCR-robust re-queries are run, C876's access-gap entry for the two surveys moves from
*could not access* to *searched, with a stated OCR caveat*, and the corresponding scope sentence in
`papers/clebsch-passages/literature-boundaries.md` — which currently names both surveys as the
bound on the negative — should be revised to match. That file is a released-paper surface owned by
C816 and C824, so the edit is theirs to make, not this record's.
