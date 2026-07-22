# C429 literature audit — main theorem and ej passes

**Lane:** `crowns`

**Date:** 2026-07-22

**Deliverable:** novelty/priority verdict on every C429 finding in
`2026-07-22-c429-attack-vector-scan.md` (the main intrinsic outer-phase theorem plus the four
user-requested extra-juice passes). Because the deliverable rests on the absence of prior work for
the task-owned content, this audit follows `notes/literature-audit-conventions.md`, including the
three-graph rule and per-source read depth.

## Opening summary

**Load-bearing sources read at full text: three.** Keith Conrad, "The Different Ideal"
(the different/discriminant fence, full text); D.J. Benson, "Matrices for finite group
representations that respect Galois automorphisms," arXiv:2306.06280 (the Benson intertwiner fence,
full text from the shared cache); and the Groupprops A5 linear-representation page (the golden
character fence, full text). Everything else — the standard number-theory and modular-representation
treatises, and the entire Clebsch-surface arithmetic neighbourhood searched for the novelty core —
was reached only at `abstract/metadata only`, `review only`, or is `could-not-access` and carried as
an open gap.

**Verdict in one line.** Every prior-art *disclaimer* C429 makes is accurate: the arithmetic and
the golden A5 representation theory it declines to claim are genuinely classical, and the Benson
fence is real and precisely located. Every task-owned *novel* claim — the "one carrier, four
readouts" naturality package (MAIN), the faithful-vs-shadow taxonomy (EJ3), and the coprime
content-ideal-vs-different two-ideal law for the integral Clebsch code (EJ4) — returned
**no located predecessor**, subject to the could-not-access gaps in Coverage. The closest genuine
neighbour is the Elsenhans–Jahnel arithmetic-of-the-27-lines program, which is adjacent in subject
but defines a different discriminant and attaches no code to the configuration.

One correctness flag surfaced incidentally and is **not** a C429 claim: the `P(1) = 1|9|1`
socle/Loewy description (owned by C430, cited by C429's q=11 refinement) has an unresolved
dimension-count tension. It is recorded below and on the crowns discovery track for the owning task,
not repaired here.

---

## Part A — prior-art disclaimers (confirmed accurate; citation hygiene only)

C429's report is unusually explicit about what it declines to claim. The audit confirms each fence.

### A1. Quadratic-arithmetic fence (main theorem + EJ2 orientation line)

Source cluster read at full text: **Keith Conrad, "The Different Ideal"** (expository note, UConn;
fetched PDF, `pdftotext`, read verbatim — `full text`), which settles the two load-bearing items
outright:

- **δ = f'(τ) generates the different; different = (f'(θ)) for a monogenic ring.** Conrad Thm 4.3
  (`O_K = Z[α] ⟹ D_K = (f'(α))`), Thm 4.8 (`N(D_K) = |disc K|`), Thm 4.13 (Dedekind: different
  primes = ramified primes). This is Dedekind's theorem applied to `f = T²−T−1`, `f'(τ) = 2τ−1 = δ`.
  Standard. Supporting canonical treatises named at `not accessed / secondary only`: Serre,
  *Local Fields* Ch. III; Neukirch, *ANT* Ch. III §2; Cassels–Fröhlich.
- **Different/discriminant of Q(√5) is (√5), field discriminant 5, ramified only at 5.** Conrad
  Ex. 4.4 (`D_{Q(√d)} = (√d)` for `d ≡ 1 mod 4`). `R = Z[τ]` is the maximal order, so `disc R = 5`
  with no index correction.
- **Phase trichotomy split/inert/ramified at p, governed by (5/p).** Standard Kummer–Dedekind
  factorization + quadratic splitting law (Neukirch I §8, `review only`); σ = Frobenius at inert p
  is finite-field Galois theory; the σ=−1 anti-invariant descent is Hilbert 90. These are **three
  distinct classical facts** and should be attributed separately, not bundled as one "quadratic
  descent" citation.
- **EJ2 determinant/orientation line and its discriminant form.** `R^{σ=−1} = Zδ ≅ det_Z R = ∧²R`
  as rank-1 Z-modules, carrying the discriminant quadratic form of value `δ² = 5`, is the classical
  discriminant module / Z/2-torsor of a rank-2 étale algebra: Knus–Merkurjev–Rost–Tignol,
  *The Book of Involutions* (`review/secondary only`, public PDF exists, not opened to a section);
  Knus, *Quadratic and Hermitian Forms over Rings* (`not accessed`); Biesel–Gioia, arXiv:1503.05318
  (`abstract only`). The specific normalization (`[x]↦x−σ(x)` vs the index-two `[x]↦1∧x`) and the
  resulting value 5 (vs 4·5, vs a sign) is convention-dependent — the manuscript should fix and cite
  the normalization rather than assert one un-normalized "canonical" identification.
- **EJ2 conormal line at 5.** `(ε) = I/I²` of the reduced point in `Spec F_5[ε]/(ε²)` is the
  conormal/cotangent line by definition (Hartshorne II.8, Stacks, nLab — all `review only`).

Manuscript-hygiene flags for the owning lane (`clebsch`, manuscript owner): the sign/norm bookkeeping
between `disc = +5` and `N(δ) = −5`; the three-way attribution split in the trichotomy; and the
determinant-line normalization choice. All are presentational; none affects correctness. Full detail:
`scratchpad`/sub1 cluster report (reproduced content folded into this file).

### A2. Golden A5 character fence (main theorem; EJ3 faithful side)

Read at full text: **Groupprops, "Linear representation theory of alternating group:A5."** Confirms
the two 3-dim irreps take golden values `(1±√5)/2` on the two 5-cycle classes; the unordered pair are
the roots of `X²−X−1` (disc 5); character field `Q(√5)`, value ring `Z[(1+√5)/2]`; both the Galois
map `√5 ↦ −√5` and the outer automorphism (odd permutation) swap 3 and 3′, and `3 ⊕ 3′` is the
restriction of the 6-dim S5 irrep. Fully classical (Fulton–Harris; James–Liebeck; ATLAS — all
`metadata/secondary only`). C429's disclaimer is accurate. EJ3's "the two A5 characters recover
`X²−X−1`" is therefore a *correct* use of classical data, not a novel arithmetic claim; what is novel
in EJ3 is the *taxonomy* (below).

### A3. Benson intertwiner fence (main theorem)

Read at full text from the shared cache: **D.J. Benson, "Matrices for finite group representations
that respect Galois automorphisms,"** Archiv der Mathematik, DOI 10.1007/s00013-023-01963-x,
arXiv:2306.06280 (cache key `arXiv:2306.06280`, PDF SHA-256
`ff4e87f6f718a16c3f757a5add525f8ce0a131419089382e9c8c09491ab17f85`; extraction read verbatim —
`full text`). All four fence clauses C429 attributes to Benson are literally in this paper: the
golden A5 intertwiner between the two 3-dim reps over Q(√5) swapped by the outer automorphism (§5
example); the trivial relative-Brauer obstruction `λ(ρ) = 1` (Thm 1.1 and the explicit A5 statement);
Hilbert-90 normalization of the outer-compatible model; and cyclic crossed-product / Galois descent
(Prop 4.2). C429's disclaimer is accurate.

**Correction to a natural guess:** the locus is *not* Benson's *Representations and Cohomology* — a
search there for the golden/Q(√5)/relative-Brauer material returned nothing. Cite the 2024 Archiv
der Mathematik paper. Forward-citation closure on this seed (from the C377 audit, re-verified as
cache entries): OpenAlex W4392348291, Crossref, and Semantic Scholar all reported a single citation
as of 2026-07-19 — Nebe et al., "Unitary discriminants of characters," arXiv:2411.06235 (`partial`;
uses Benson Prop 4.2 as a black box, no Clebsch/finite-field specialization). The Benson mechanism is
prior art and is being consumed in the literature as such.

---

## Part B — task-owned novel claims (novelty core)

Seeds and searches recorded per the three-graph rule; verdicts carry the could-not-access residuals
in Coverage.

### B1. MAIN — "one carrier, four readouts" naturality package

**Verdict: no-predecessor-located.** No source treats the golden discriminant √5 (as the ring carrier
`Zδ`) as one integral object controlling ≥2 of {the two A5 representations, a code, a scheme/torsor}
of the Clebsch configuration simultaneously. The Clebsch/A5 literature partitions cleanly into three
disjoint kinds, none uniting them:

1. **Classical geometry of the Clebsch surface** (`abstract/metadata only`): S5 automorphisms,
   27 lines, golden-ratio double-six coordinates, Eckardt points. This is the *input* to C429's
   construction (φ in the line coordinates), not the naturality claim.
2. **Arithmetic of the 27 lines / Galois action — the Elsenhans–Jahnel program** (math/0612383;
   arXiv:1006.0721 = DOI 10.1007/s10711-011-9643-7 "The discriminant of a cubic surface";
   arXiv:2509.06785; arXiv:2607.01878 — all `abstract/metadata only`, front matter of the last read
   via WebFetch). Studies field of definition of the lines, reduction mod p, the surface discriminant
   (a high-degree invariant of the cubic-surface family — **not** the ring discriminant `⟨5⟩` of
   `Z[τ]`), and monodromy `= W(E6)`. Adjacent in subject; attaches **no code** and states no
   naturality package. This is the closest genuine neighbour.
3. **A5 golden-ratio flavour-physics models** (arXiv:1101.0393, 1410.2057, 1110.1688, 2206.14869 —
   `abstract/metadata only`): reuse the same two golden 3-dim A5 reps for lepton mixing; no cubic
   surface, no code, no torsor.

Verbatim load-bearing queries and stop condition are in Coverage. Three independent query families
(code-side, representation/torsor-side, arithmetic-side) each returned only these disjoint clusters.

### B2. EJ3 — faithful vs shadow readouts; q=11 no-go

**Verdict: no-predecessor-located.** The faithful/shadow taxonomy (paired A5 characters and the S3
resolvent recover the discriminant algebra `X²−X−1`; bare chirality and code-obstruction torsors
retain only the C2 shadow) is a refinement *internal* to the MAIN package, so no external source
states it because none states the package. The finite-fibre obstruction `⟨5⟩ ≅ ⟨1⟩` at q=11
(`4² = 5 mod 11`) is elementary square-class arithmetic used to a novel end. The cached PSL(2,11)
geometry item (10.1023/A:1005204612043) is `could-not-access` (paywalled) and its subject does not,
on metadata, concern a golden-carrier readout taxonomy — carried as an open gap, not a full-text
negative.

### B3. EJ4 — coprime two-ideal law (content = (2), different = (5))

**Verdict: no-predecessor-located.** The two ingredients exist separately — determinantal/content
ideals (arXiv:1208.2930, arXiv:1503.05799, `abstract/metadata only`) and different-vs-discriminant
machinery (standard) — but no source combines them into a content-ideal-vs-different **coprimality**
statement for a specific symmetric-configuration MDS code, and none concerns a golden/Clebsch code.
The only "codes from cubic surfaces" thread is Goppa/evaluation AG codes (arXiv:1803.00486, abstract
read in full), which evaluate functions at rational points and are unrelated to a 6-column
Plücker/monomial code over `Z[τ]`; they carry no MDS-at-ramified-prime content law. The classical
**hexacode** `[6,3,4]` over F4 is tied to M24/Golay, not to the 27 lines or to `Z[τ]`; no bridge
located.

### Three-graph citation counts (novelty-core seed)

Seed = closest arithmetic predecessor, screened for any downstream code connection: Elsenhans–Jahnel,
"The discriminant of a cubic surface." Pinned: DOI 10.1007/s10711-011-9643-7, arXiv:1006.0721,
OpenAlex W2143830889, S2 CorpusID 119132393.

| Graph            | Query (pinned)                                  | Citing count | Empty-vs-error                                   |
|------------------|-------------------------------------------------|:------------:|--------------------------------------------------|
| OpenAlex         | `doi:10.1007/s10711-011-9643-7`, `cites:W2143830889` | 10       | Live JSON; `cited_by_count`=10, 10 rows enumerated |
| Crossref         | `works/10.1007/s10711-011-9643-7`               | 6            | Live JSON; `is-referenced-by-count`=6 (200 OK)     |
| Semantic Scholar | `paper/arXiv:1006.0721`                          | 17           | 200 OK; by-DOI form returned 0 (indexing miss)     |

Disagreement is reportable: **10 / 6 / 17**. The S2 by-DOI `0` is a DOI-form indexing miss (the same
paper by arXiv id returns 17), recorded so it is not mistaken for absence. The largest enumerable set
(OpenAlex, n=10) was screened by title (discriminator: "does the title indicate any error-correcting
code, golden/√5 arithmetic, or naturality/torsor tie to the 27 lines?"). None of the 10 is a
code-theory work; none carries golden/√5 or naturality language. Residual: 7 S2-only citing works
beyond the OpenAlex 10 were not individually enumerable through the public endpoint and are carried
as a gap.

---

## Part C — incidental correctness flag (owning task: C430, not C429)

The Benson-fence cluster flagged a dimension-count tension in the `P(1) = 1|9|1` socle/Loewy claim
that C429's q=11 refinement cites from C430. Standard defining-characteristic theory
(Andersen–Jørgensen–Landrock, *Proc. LMS* 1983, `abstract/metadata only`; Alperin, *Local
Representation Theory*, `secondary only`) gives: every PIM of SL(2,p) has Loewy length 3, is
self-dual, with semisimple heart — the mechanism behind a `top | heart | socle` statement. But the
standard trivial-block PIM `P(L(0))` for SL(2,11) has dimension `2p = 22`, whereas a `1|9|1` object
has total dimension 11 (a uniserial module with 9-dim heart `L(8)`), which is **not** the full
group-algebra projective cover. So `P(1) = 1|9|1` is either a specifically-defined C430 object
(a principal-block uniserial submodule, or a Borel/restricted-cover) or shorthand needing its own
definition; the exact `1|9|1` numerics are a C430-owned computation, not standard SL(2,q) PIM theory.
This is written up for the owning lane per the audit conventions and logged on the crowns discovery
track; it is not repaired here.

---

## Coverage statement (searched-nothing vs could-not-access kept apart)

**Searched and found nothing (licenses the negatives above):**

- General web + arXiv title/abstract across code-side, representation/torsor-side, arithmetic-side,
  and determinantal-ideal query families. Verbatim load-bearing queries:
  `A5 icosahedral 27 lines Clebsch surface [6,3,4] code monomial equivalence`;
  `Clebsch codes A5 two golden three-dimensional representations chirality torsor resolvent naturality`;
  `"six arcs" Clebsch surface golden A5 representation Plucker code Z[golden ratio]`;
  `27 lines cubic surface reduction mod p discriminant sqrt(5) golden splitting Galois arithmetic`;
  `determinantal ideal content ideal MDS code preserved ramified prime coprime different discriminant Plucker`;
  `code MDS ramified prime 5 remains MDS reduction different discriminant coprime content ideal Plucker minors`.
  Each query family returned only keyword-disjoint clusters (classical geometry, Elsenhans–Jahnel
  arithmetic with no code, physics A5 golden models).
- OpenAlex and Crossref live APIs for the seed and its citing set (enumerated, screened by title).
- Two cached AG papers read at full text of front matter (arXiv:2209.01499, arXiv:2411.15334):
  confirmed off-topic for codes and for the naturality package.

**Could not access (licenses nothing — open gaps carried forward):**

- Full texts of arXiv:1006.0721 / DOI 10.1007/s10711-011-9643-7 (Springer wall), arXiv:math/0612383,
  arXiv:2509.06785, arXiv:2607.01878 — read `abstract/metadata only`; the discriminant/Galois details
  most directly neighbouring MAIN/EJ3 were not verified in full.
- **zbMATH Open** — both `api.zbmath.org` (HTTP 404) and `zbmath.org/?q=…` (HTTP 403) unreachable
  this session, despite the conventions listing it as freely reachable. Recorded as could-not-access,
  not as a negative.
- **MathSciNet** — NOT COVERED (institutional auth). "To our knowledge" must remain on every claim it
  would have gated (novelty of MAIN/EJ3/EJ4; the AJL 1983 and Benson reviews).
- **Semantic Scholar** — count obtained (17) but the citing set was not individually enumerable via
  the public endpoint; 7 works beyond the OpenAlex 10 unscreened.
- **Paywalled cache items** in the icosahedral/A5/PSL(2,11) neighbourhood, cache-status `not-a-pdf`
  (paywall/Cloudflare captures, bytes never obtained — could-not-access, NOT absence): Dye,
  "The Plane Sextic Curve Fixed by A6" (10.1007/BF02942548); Martin & Singerman, "The geometry behind
  Galois' final theorem" (10.1016/j.ejc.2012.03.005); "Geometries of the Group PSL(2,11)"
  (10.1023/A:1005204612043). Their metadata does not state a golden-carrier code/naturality result,
  but no full-text negative can be asserted.
- **Google Scholar** — blocked to automated access (not attempted).
- Primary-source page-level pins inside Serre, Neukirch, Knus, Book of Involutions, Deligne, and
  Hartshorne were not opened (standard textbook facts; canonical reference identified for each).

## Bottom line for the owning lanes

- **C429 novelty holds** as stated for MAIN, EJ3, EJ4, subject to the could-not-access gaps above.
  The task-owned content is the naturality package, its faithful/shadow refinement, and the two-ideal
  law — none pre-empted by any located source. Retain "to our knowledge" wording (MathSciNet and
  zbMATH uncovered).
- **All C429 prior-art disclaimers are accurate.** Cite Conrad/Serre/Neukirch (different), the A5
  character table (golden values), and specifically **Benson arXiv:2306.06280 / Archiv der Math.**
  (intertwiner + λ=1 + Hilbert 90 + crossed-product descent) — not *Representations and Cohomology*.
- **For `clebsch` (manuscript owner):** the three A1 hygiene flags (sign/norm bookkeeping;
  trichotomy attribution split; determinant-line normalization) and the "closest neighbour is
  Elsenhans–Jahnel, different discriminant, no code" positioning line.
- **For C430:** resolve or define the `P(1) = 1|9|1` object; the `1|9|1` dims are not standard
  SL(2,q) PIM theory and carry a dim-11-vs-22 tension.
