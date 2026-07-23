# C509 literature audit — PRS(q−6) redundancy seven

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Verdict:** NOT PRE-EMPTED, qualified by the
coverage statement below

## Opening summary

This audit asks whether a source already classifies deep holes of projective Reed--Solomon codes
at redundancy seven, proves the pointed split-member theorem for Hankel webs of binary quintics,
or supplies the needed finite-field \(PGL_2\)-orbit classification of binary sextics.

**Full-text count:** no new full text was fetched.  The verdict reuses **four full-text coding
sources** and **three full-text/partial geometric sources** whose cache keys and hashes are recorded
in the C498 audit.  Two newly surfaced works were inspected at abstract/metadata depth.  No cached
bytes were added.

**Verdict.** No located source pre-empts C509.  The coding negative is unusually strong because the
C498 three-graph screen was explicitly for every \(PRS(k)\) with \(k\le q-5\); redundancy seven is
\(k=q-6\), already inside that screened range.  The web-of-quintics, pointed-root, and
binary-sextic searches found standard factorization-count and invariant-theory tools, but no
matching deep-hole or all-\(\mathbf F_q\)-orbit theorem.

## Coding axis

The pinned seeds and their 2026-07-22 three-graph counts are reused without re-resolving titles:

- ZWK, `arXiv:1901.05445`, DOI `10.1109/TIT.2019.2940962`, OpenAlex `W2973880421` — **read depth:
  full text**, reused from C491/C498, cache key and SHA-256 recorded there.
- Kaipa, `arXiv:1612.05447`, DOI `10.1109/TIT.2017.2706677`, OpenAlex `W2563545890` — **read depth:
  full text**, reused from C491/C498.
- Wu--Ding--Chen, `arXiv:2312.05534` — **read depth: full text**, reused from C498, especially
  section V.  Its open range \(2\le k\le q-2\) contains \(k=q-6\).
- Xu, DOI `10.1051/wujns/2023281015` — **read depth: full text**, reused from C498; its
  even-characteristic endpoint results do not reach \(k=q-6\).

C498 recorded OpenAlex/Crossref/Semantic Scholar counts \(21/19/24\) for the ZWK seed and
\(20/16/28\) for the Kaipa seed, and screened the largest citing sets in full.  Its verbatim
discriminator included “deep holes of PRS for \(k\le q-5\)” and found no hit.  C509's
\(k=q-6\) is therefore covered by that exact screen rather than inferred from a title-only search.

Fresh web-index queries on 2026-07-23:

```text
"PRS(q-6)" deep holes OR "redundancy seven" Reed Solomon
Reed Solomon deep holes sextic normal rational curve PG(6,q)
```

returned the redundancy-at-most-four PRS literature and unrelated code families, with no
redundancy-seven resolution.  Astore--Borello--Couvreur--Salizzoni,
`arXiv:2606.13246`, appeared because it constructs a \(q\)-analogue of the rational normal curve
for **linearized** Reed--Solomon codes — **read depth: abstract/metadata only** — and is not a
Hamming-metric PRS deep-hole classification.

The scalar covering-radius value must remain separate from the crown.  Seroussi--Roth covers the
usual high-rate range; C509's novelty claim is only the deep-syndrome/orbit classification.

## Split-member and orbit axes

- Cesaratto--Matera--Pérez, `arXiv:1408.7014` — **read depth: partial**, reused from C498
  (abstract, theorem statements, and the linear-family factorization-count role recorded there).
  It gives positive asymptotic counts for factorization pattern \(1^5\) under its good-family
  hypotheses.  It neither classifies exceptional Hankel webs nor excludes one prescribed root.
- Ishitsuka, `arXiv:2605.04935` — **read depth: full text**, reused from C498.  It concerns
  singular binary quintics and Waring/catalecticant stratification, not binary-sextic
  \(PGL_2(\mathbf F_q)\)-orbits or PRS deep holes.
- Gmainer--Havlicek, `arXiv:1304.0088` — **read depth: partial**, reused from C498 (abstract and
  theorem 1).  It supplies the NRC nucleus criterion but not the pointed split-member theorem.
- Dimca--Sticlaru, `arXiv:2105.12016` — **read depth: abstract/metadata only**.  It classifies
  Waring and border ranks of binary sextics over the complex numbers using GIT invariants; it is
  not an all-characteristic finite-field orbit classification.

Fresh web-index queries:

```text
"binary quintics" web finite field totally split linear system
"binary sextics" PGL2 finite field orbit classification
site:arxiv.org "binary sextic" "finite field" PGL_2 orbit
site:arxiv.org "linear system" "binary quintic" finite field
site:arxiv.org factorization patterns linear families polynomials finite fields degree 5 totally split
site:arxiv.org "orbits of binary sextics" finite fields
```

found the general factorization-pattern paper and characteristic-zero/genus-two invariant theory,
but no theorem matching C509's finite-field web, pointed-root, or orbit deliverables.

## Coverage

- **OpenAlex/Crossref/Semantic Scholar:** covered by the immediately preceding C498 audit with
  pinned identifiers, separate counts, largest-set enumeration, and error-vs-empty handling.  Its
  screened range explicitly contains C509.
- **Fresh web-index object searches:** covered for the six verbatim queries above; these are a
  targeted object screen, not an exhaustive bibliography.
- **Shared full-text cache:** covered for the reused load-bearing sources; no new bytes fetched.
- **MathSciNet:** NOT COVERED (institutional authentication unavailable).  Priority language must
  remain “to our knowledge.”
- **zbMATH Open and author-stream refresh:** not rerun for this one-day successor audit.  This
  weakens the negative on binary-sextic toolkit coverage, not the coding forward-tree negative.

## Downstream wording

State, to our knowledge, that the redundancy-seven **deep-hole/orbit classification**, pointed
Hankel-web theorem, and all-field exceptional-stratum analysis are new.  Do not claim novelty for
the scalar covering radius, general factorization-pattern counting, binary-sextic invariant theory,
or NRC nuclei.  Cite C498 as the immediate mathematical input rather than presenting its
first-polar recursion again as a C509 discovery.

