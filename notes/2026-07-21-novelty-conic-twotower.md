# Novelty audit — conic-secant one-factorizations & the two-tower divergence

**Date:** 2026-07-21
**Scope requested:** two novelty questions about the cocycle-gateway explorations
(`notes/2026-07-20-cocycle-gateway-explorations.md`, Spikes 1–6):
(A) is the *splitting* of the conic-secant one-factorization PGL-orbit into two PSL sheets, and the
resulting cross-sheet design, in the conic/oval one-factorization literature?
(B) has anyone *paired* the perfect-code tower (stops at q=11) with the L₂(q) self-dual-polytope
tower (continues to q=19) and used the q=19 divergence as a falsifier?

Method: every "no prior work" statement below is checked across two independent angles — keyword
search AND the citation/neighborhood of a named source. Cache checked first
(`/tmp/persistent/tavis/lit-search`). Sources carry re-findable ids and how they were found.

---

## Verdict (A): PARTIAL NOVELTY — ingredients classical, the cross-sheet composition not located

**The construction source is a real, active literature — the individual designs and their PSL
symmetry are textbook — but the specific "two PSL sheets → cross-sheet incidence → the exact
biplane/design, with the PGL-outer coset as its polarity" pipeline was not found in it.**

### What IS prior art (both angles confirm)

1. **Conic/oval one-factorizations of K_{q+1} are an established construction family.**
   - Korchmáros, Nagy, Pace (et al.), *One-factorisations of complete graphs arising from ovals in
     finite planes*, J. Combin. Theory Ser. A **160** (2018) 62–83.
     URL `https://www.sciencedirect.com/science/article/pii/S0097316518300803` (found: WebSearch
     "Korchmaros … one-factorization conic PG(2,q) … 2018"). Constructs one-factorizations of K_{q+1}
     with the q+1 conic/oval points as vertices, chords as edges — exactly the note's vertex/edge
     model.
   - Pace & Sonnino, *One-factorisations of complete graphs constructed in Desarguesian planes of
     certain odd square orders*, Electron. J. Combin. **27**(1) (2020) #P1.37.
     `https://www.combinatorics.org/ojs/index.php/eljc/article/download/v27i1p37/pdf/` (fetched,
     text extracted). A *different* target (K_{q(q-1)} from ovals in PG(2,q²) via AGL(1,q)); it does
     use "the action of PGL(2,q) on Ω yields two orbits" but those are Ω₀ vs Ω\Ω₀ on the conic
     points, **not** two orbits of one-factorizations, and it builds no cross-sheet design.
   - Companion: *…arising from hyperbolae in the Desarguesian affine plane*, J. Geom. (2019),
     doi `10.1007/s00022-019-0470-6`.
   - Cache neighbors in the same PGL(2,q)-orbit-design vein: `10.37236/1076` "3-Designs from
     PGL(2,q)" (orbit sizes / isomorphism classes of PGL(2,q) on k-subsets of PG(1,q));
     `10.1007/s10801-017-0760-8` "Symmetric factorizations of the complete uniform hypergraph"
     (classifies symmetric factorizations with PSL(2,q) ≤ G ≤ PΓL(2,q)); `arXiv:2507.00813` "On the
     association scheme of perfect matchings". None builds the cross-sheet design.

2. **The target designs and their PSL(2,q) symmetry are entirely classical (Galois' exceptional
   actions).** From the SFU notes *Galois' Exceptional Actions* (M. DeVos,
   `https://www.sfu.ca/~mdevos/notes/comb_struct/galois-ex.pdf`, extracted text) verbatim:
   PSL(2,7) is Aut(Fano plane) = GL(3,2); PSL(2,11) is Aut(the **unique 2-(11,5,2) design**). These
   are exactly the note's cross-sheet designs (Fano at q=7, 2-(11,5,2) biplane at q=11). Elaborated
   in Martin & Singerman, *The geometry behind Galois' final theorem*, Eur. J. Combin. **33** (2013),
   `https://www.sciencedirect.com/science/article/pii/S0195669812000613`, and their expository *From
   Biplanes to the Klein quartic and the Buckyball*
   (`https://www.neverendingbooks.org/DATA/biplanesingerman.pdf`); and Kostant, *The Graph of the
   Truncated Icosahedron and the Last Letter of Galois*, Notices AMS **42** (1995),
   `https://www.ams.org/notices/199509/kostant.pdf` (German version cached `10.1515/dmvm-1995-0405`).
   The perfect codes carried by these designs (Hamming from Fano, ternary Golay from the 2-(11,5,2)
   biplane) are textbook.

### What was NOT located (the note's actual composition)

The specific move — take the **two PSL(2,q) sheets** of conic one-factorizations, form their
**cross-sheet shared-edge incidence**, and obtain the exceptional self-dual symmetric design, with
the outer PGL\PSL coset realized as the design's **polarity/chirality** and the disjoint-relation
code equal to the exceptional perfect code — was not found in the conic one-factorization literature
(which studies isomorphism/automorphism of the one-factorizations themselves, not a design built
between two orbit-sheets), nor in the Galois-exceptional literature (which produces the same designs
by direct/geometric constructions, never from paired conic one-factorization sheets).

**Bounded negative, two independent angles.** (i) Keyword: searches pairing "one-factorization" +
"conic/oval PG(2,q)" + {"PSL orbit", "two sheets", "biplane", "cross-incidence", "Fano", "perfect
code"} returned only the construction papers above, none with a cross-sheet design. (ii) Citation
neighborhood: the Korchmáros-oval construction side and the Galois/Kostant/Martin–Singerman design
side do not cite or reproduce each other's bridge. Negative is bounded to accessible
search/citation surfaces (ScienceDirect full texts 403; read via abstracts + open expositions).

---

## Verdict (B): the paired-tower divergence appears novel *as a framed falsifier* — assembled from
wholly classical facts, so it is a re-observation, not a theorem

**Each tower is classical and both endpoints are known; I found no source that pairs them as two
sequences, notes the q=19 divergence, and uses "no q=19 perfect code" as a falsifier for a single
convergence object.**

- **Code tower** (Hamming q=7, ternary Golay q=11; classification: a nontrivial perfect linear code
  is Hamming or binary/ternary Golay only): textbook, e.g. `https://errorcorrectionzoo.org/c/perfect`.
- **Polytope tower** (rank-3 Fano; rank-4 11-cell at q=11, 57-cell at q=19; both self-dual):
  Leemans & Schulte, *Groups of type L₂(q) acting on polytopes*, `arXiv:math/0606660` (cached). Its
  Theorem 4: the only rank-4 regular polytopes with L₂(q) automorphism group occur at **q=11 and
  q=19**. Grep of the cached text confirms it **never mentions codes, Golay, Hamming, or perfect
  codes** — the polytope side makes no code connection at all.
- The **exceptional coincidence at 5,7,11** is heavily trodden (Galois' theorem: PSL(2,q) acts
  faithfully/transitively on q points only for q=5,7,11 — SFU notes, Martin–Singerman, Kostant).
  Crucially, **that classical list stops at 11**; q=19 (the 57-cell, L₂(19)) belongs to a *separate*
  classification (Leemans–Schulte rank-4, list {11,19}). So the note's "polytope tower continues to
  19" splices two different exceptional lists — a legitimate but non-standard juxtaposition.

**Bounded negative, two independent angles.** (i) Keyword: searches combining "perfect code" +
{"57-cell", "regular polytope", "L2(19)", "diverge/coincidence/stops"} surfaced only the code
classification and the polytope literature separately, never paired. (ii) Citation neighborhood:
Leemans–Schulte cites no coding theory; the Galois-exceptional expositions (Kostant,
Martin–Singerman, SFU) stop at 11 and invoke neither q=19 nor a codes-vs-polytopes divergence. No
source uses the absence of a q=19 perfect code as a falsifier.

**Assessment.** The divergence is real and correctly stated, but every fact in it is classical
(perfect-code classification + Leemans–Schulte). Its novelty is the *framing* — pairing the two
towers and turning the q=19 gap into a cheap falsifier ("a single convergence object must not
manufacture a spurious q=19 perfect code"). That framing is a useful heuristic/rhetorical device for
the lane, not a new mathematical result, and should be presented as an observation with all
ingredients credited, never as a discovery.

---

## Closest prior work, ranked

1. Korchmáros–Nagy–Pace (et al.), JCTA 160 (2018) — the conic/oval one-factorization construction
   itself (angle A construction source). URL above.
2. Martin & Singerman, Eur. J. Combin. 33 (2013), + SFU "Galois' Exceptional Actions" — Fano and
   2-(11,5,2) biplane as the PSL(2,7)/PSL(2,11) exceptional designs (angle A targets; angle B
   {5,7,11} tower). URLs above.
3. Leemans & Schulte, arXiv:math/0606660 — the 11-cell/57-cell polytope tower {11,19} (angle B).
4. Kostant, Notices AMS 42 (1995) — the PSL(2,11)/icosahedron/Golay coincidence narrative closest in
   spirit to a "convergence" claim; still stops at 11, no code-vs-polytope divergence.

## Trusted boundary
Verdicts rest on abstracts, open expository PDFs, and cached full texts; several primary full texts
(ScienceDirect) returned HTTP 403 and were read via abstract + secondary exposition. "Not found"
means not surfaced on the searched keyword and citation-neighborhood surfaces as of 2026-07-21, not
proven absent from all literature. Recommend one confirmatory full-text read of the Korchmáros-oval
JCTA paper (§ on isomorphism classes / automorphism group PGL vs PSL) before any manuscript-bound
"to our knowledge the cross-sheet design is new" sentence.
