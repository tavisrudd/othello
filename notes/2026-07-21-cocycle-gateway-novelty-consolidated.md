# Consolidated novelty audit — cocycle/gateway cross-sheet construction and the Clebsch headline spine

**Lane:** `crowns` (read-only audit of `clebsch` inputs)

**Date:** 2026-07-21

**Status:** Literature audit only. No task allocation, no manuscript edit, no novelty *claim* — this
records what a bounded multi-field search did and did not find, so the owning lane can word its
priority sentences. Every verdict below is a bounded negative over the stated services and date, not
an unrestricted nonexistence statement. Two un-checked angles persist across the whole audit
(MathSciNet/zbMATH, and a handful of paywalled full texts / servers that were down at fetch time);
they are named per report.

## Scope and method

Nine independent audits, each attacking a different field, vocabulary, or sibling case. Started from
the most surprising *field-neutral* framings (Galois exceptional primes; Arnold trinities;
association schemes on matchings; external self-duality; discrete cubic-moment chirality), then
checked each specific claim, then checked whether the Clebsch paper's own headline spine has already
been proved for a **sibling** member of the family (q=5 frame, q=7/B3, q=19, or general q).

Every consulted source carries a re-findable id (DOI/arXiv/URL) in its report; every "not found" was
confirmed on at least two independent angles (keyword search **and** citation/neighborhood of a named
source). The papers cited across all reports are mirrored in
[`2026-07-21-novelty-audit-cache-manifest.md`](2026-07-21-novelty-audit-cache-manifest.md) and, where
obtainable, cached under `/tmp/persistent/tavis/lit-search/`.

The verbatim reports (each is the source of record for its angle):

| # | Angle / field | Report |
|---|---|---|
| 0 | First-pass audit (design theory) | [`2026-07-21-cocycle-gateway-novelty-check.md`](2026-07-21-cocycle-gateway-novelty-check.md) |
| 1 | Galois exceptional primes / small `PSL_2` actions | [`2026-07-21-novelty-galois-exceptional-primes.md`](2026-07-21-novelty-galois-exceptional-primes.md) |
| 2 | Arnold trinities / sporadic-coincidence catalogues | [`2026-07-21-novelty-arnold-trinities.md`](2026-07-21-novelty-arnold-trinities.md) |
| 3 | One-factorization designs / association schemes | [`2026-07-21-novelty-onefactorization-designs.md`](2026-07-21-novelty-onefactorization-designs.md) |
| 4 | External self-duality (polarity) + cubic-moment chirality | [`2026-07-21-novelty-polarity-chirality.md`](2026-07-21-novelty-polarity-chirality.md) |
| 5 | Conic-secant factorizations + two-tower divergence | [`2026-07-21-novelty-conic-twotower.md`](2026-07-21-novelty-conic-twotower.md) |
| 6 | Sibling: rigidity + low-degree curve headline | [`2026-07-21-sibling-novelty-rigidity-lowdegree.md`](2026-07-21-sibling-novelty-rigidity-lowdegree.md) |
| 7 | Sibling: decoding oracle + support chirality | [`2026-07-21-sibling-novelty-decoding-chirality.md`](2026-07-21-sibling-novelty-decoding-chirality.md) |
| 8 | Sibling: C399 uniform complement-code law | [`2026-07-21-sibling-novelty-c399-complement-code.md`](2026-07-21-sibling-novelty-c399-complement-code.md) |

## Headline verdict

The uniform pattern across all nine audits: **every concept the work names is classical and already
has a home name in some literature; what survives is the specific *composition* of those concepts.**
Nothing was found that pre-empts the composition as a whole, but several individual pieces are more
pre-empted than the exploration notebook stated — and one Clebsch headline (rigidity) is
substantially pre-empted for the whole family and must be credited, which the lane already anticipates.

### Cocycle/gateway exploration claims

| Claim | Concept status | What survives (bounded) | Must cite |
|---|---|---|---|
| Cross-sheet shared-edge incidence → Fano / biplane / 11-cell | mechanism not located | the shared-edge cross-orbit design construction | assoc. scheme of matchings (Rands; Godsil–Meagher); **Bamberg–Klawuhn arXiv:2507.00813**, same actors, different (Delsarte λ) design notion |
| Sheet-swap (`PGL\PSL`) = design polarity / "chirality" | **concept pre-empted** | realizing it on an *external* matching-sheet labeling; the one bit as a cohomology (C417) class | **external self-duality** (Cunningham–Pellicer arXiv:1610.02672); self-dual-not-self-polar (Brouwer–Cameron–Haemers) |
| "one bit = self-duality choice" | **classical** as a binary | tying the bit to the C417 cocycle | Brouwer–Cameron–Haemers self-dual/self-polar theory |
| Chirality = sign of a cubic moment (`±6 mod 11`) | **concept pre-empted** (continuous) | the discrete mod-`p` realization over a finite matching family | cubic/triple-product moment chirality (Hattne–Lamzin and the "chiral moments" line) |
| A3/B3/H3-at-`q=h+1` → doily/Fano/11-cell as one trinity | not located as a trinity | the bridge between the two parent trinities | Arnold Coxeter trinity (Arnold 1997; **Dechant** Proc. R. Soc. A 474:20180034); Galois/Kostant `L_2(5,7,11)` trinity (Kostant 1995; Baez TWF week79) |
| Code-tower (7,11) vs polytope-tower (7,11,19) divergence | facts classical | the *juxtaposition* as a falsifier — new as framing, not theorem | perfect-code classification; Leemans–Schulte polytopes (arXiv:math/0606660) |
| Conic-secant one-factorizations, PSL sheet split | active literature | the two-sheet cross-incidence composition | Korchmáros–Nagy–Pace (JCTA 160, 2018); Pace–Sonnino |

Two framing corrections the notebook needs regardless:
- **A3/q=5 = doily is non-standard.** The textbook Galois/Coxeter trio pairs q=5 with the
  **icosahedron (A₅)**, not the doily `GQ(2,2)`. The doily slot is the work's own reading and must be
  argued, not asserted as classical (reports 1, 2).
- **"Chirality" is an overloaded term.** In the chiral-polytope literature it means
  orientation-preserving-vs-reflexible, a *different* construct from the `PGL\PSL` self-duality bit.
  Rename or disambiguate in any manuscript (report 1).

### Clebsch paper headline spine, checked against siblings

| Headline | Sibling/general-q status | Surviving residue |
|---|---|---|
| **R1** conic-containment rigidity recovers A₅ | **substantially pre-empted for all q** — Dye 1991 (JLMS, DOI 10.1112/jlms/s2-44.2.270, Thms 2/5/6) gives the unique self-polar conic recovering A₅ for all admissible K (q=5,11,19); Storme–Van Maldeghem (DOI 10.1016/0097-3165(95)90051-9) proves projective uniqueness for all q≡±1 mod 10, naming PG(2,11) and PG(2,19) | only the **coding recoding**: max-distance *syndrome* locus ⇒ conic. Already inside the lane's "credit Edge/Dye" boundary |
| **R2** unique 6-arc on a curve of degree ≤ 3 | **no sibling/general predecessor** — candidate-novel | the whole ladder; but pin the exact locus/uniqueness or it is vacuous (6 general points lie on many cubics) |
| **D1** syndrome-conic distance oracle | **known instance** — Jurrius–Pellikaan Ex. 5.10 for `[n,n-3,4]` arc codes; conic case credited via arXiv:2103.16904 ref [16] and arXiv:2101.12722 §6 | only the arc-specific rigidity (this 6-arc's max-weight syndrome locus = the A₅ conic) |
| **D2** 10+10 support chirality | **no sibling/general predecessor** — the split itself is classical Out(S₆) six-points invariant (arXiv:0710.5916); no Golay/GRS coset-leader chirality attested | naming it the coset-leader-support chirality of the [6,3,4] code |
| **C399** uniform `[(q-h/2)(q-h+1),3,…]` complement-code law, q=h+1→GRS | **not pre-empted** — no source states the three-case law or nonmirror maximum `q-h+1` | the h-parametrized assembly is the new object (only the isolated q=h+1 = conic = doubly-extended RS step is classical) |

## What this means for the two manuscripts

- **Clebsch paper.** No new blocker beyond what the lane already tracks. R1 must credit Dye 1991 /
  Storme–Van Maldeghem (it does) and claim only the syndrome-locus recoding. D1 must credit
  Jurrius–Pellikaan and claim only the arc-specific rigidity. R2, D2, and C399 survive as the
  genuinely-new headlines — R2 needs its uniqueness notion pinned, D2 and C399 are clean compositions.
- **Crowns/gateway exploration.** The mechanism survives, but the writeup must now (a) cite
  Bamberg–Klawuhn arXiv:2507.00813 and the matching-association-scheme literature as the ambient
  frame, (b) credit external-self-duality (Cunningham–Pellicer) and self-dual/self-polar theory for
  the "one bit," (c) credit continuous cubic-moment chirality and claim only the discrete mod-p
  crossing, (d) lead with *both* parent trinities (Arnold Coxeter; Galois/Kostant), (e) drop the
  "chirality" term or disambiguate it, and (f) defend the non-standard A3=doily slot.
- **Do not propagate a hallucination.** A fast-model WebFetch summary invented a "Fano/biplane from
  `PSL(2,q)` shared-edge counts" claim into Bamberg–Klawuhn arXiv:2507.00813; that claim is **not** in
  the paper (report 3 verified against the actual PDF text). Cite the paper for the scheme/λ-design
  frame only.

## Evidence boundary

Web index + local lit-cache + extracted PDFs, 2026-07-21. No MathSciNet/zbMATH pass. Several
ScienceDirect/Wiley full texts returned 403 and were read via abstract plus open exposition;
`neverendingbooks` and the Singerman–Martin biplane PDF host were down at fetch time and recovered
via snippets. Any manuscript-bound "to our knowledge" sentence should close the specific paywalled
full text named in the relevant report before release. The computations underlying the exploration
(the six spikes) were independently replayed and are not in scope here — see
[`2026-07-20-cocycle-gateway-explorations.md`](2026-07-20-cocycle-gateway-explorations.md).
