# Novelty search — (I) polarity via outer coset, (II) chirality = sign of a cubic moment

**Lane:** `crowns` (read-only novelty support for the cocycle/gateway explorations)

**Date:** 2026-07-21

**Scope.** Two linked ideas from
`notes/2026-07-20-cocycle-gateway-explorations.md` (Spikes 2, 3, 5) and
`notes/2026-07-20-c417-affine-cocycle-line-bundle.md`:

- **(I)** the polarity (incidence-reversing self-duality) of a self-dual symmetric design
  (Fano `2-(7,3,1)`, `2-(11,6,3)`, Paley biplane) induced *exactly* by the outer coset
  `PGL_2(q) \ PSL_2(q)`, with the self-duality choice framed as **one cohomology/chirality bit**;
- **(II)** a **chirality one-bit** invariant read off the **sign of a cubic moment**
  `M_3 = sum_M eps(M) D(M)^{⊗3}` over a set of matchings (`+6` vs `-6 = 5 mod 11`).

Each verdict is confirmed on two independent angles (keyword search AND
citation/neighborhood of a named source). All sources carry a re-findable id.

---

## Verdict (I): CONCEPT PRE-EMPTED; the specific composition survives

The general idea "a self-dual object whose self-duality is realized by an **outer**
automorphism (not an inner symmetry)" is an established, named concept.

**Closest prior work — the naming is not novel.**

- **Cunningham & Pellicer, "Internal and external duality in abstract polytopes,"
  arXiv:1610.02672** (Contrib. Discrete Math.; `cdm.ucalgary.ca/article/view/62785`).
  *Found by:* keyword search "self-dual abstract regular polytope duality outer automorphism".
  Verified from the extracted text (Def. 3.1): a regular self-dual polytope is **internally
  self-dual** if the group automorphism induced by its self-duality is **inner**, and
  **externally self-dual otherwise** — i.e. exactly when the dualizing map lies in an **outer
  automorphism coset**. They note the `n`-simplex is internally self-dual because `S_{n+1}` has
  no outer automorphism "unless `n+1 = 6`," and that `S_6` yields externally self-dual polytopes.
  This *is* the audited "polarity induced by the outer coset." The 11-cell (`Aut = PSL_2(11)`,
  outer-of-`PGL_2(11)` dualizing map) is a textbook instance of **external self-duality**.

- **Brouwer, Cameron, Haemers & Preece, "Self-dual, not self-polar,"** preprint 2003
  (`webspace.maths.qmul.ac.uk/l.h.soicher/designtheory.org/library/preprints/sdnsp.pdf`; SHA of
  the fetched bytes recorded in this session's `tool-results/`).
  *Found by:* keyword search "self-dual 2-design polarity". Verified from full extracted text.
  This is the canonical "**one bit**" statement for designs: an incidence structure can be
  self-dual (`P1 N = N^T P2`) yet admit **no polarity** (`P3 N = N^T P3^T`, `P3` an involution).
  The smallest self-dual-not-self-polar structure has 7 points (8 up to iso; 6 in the non-binary
  case). Duality is framed as a bipartite-incidence-graph automorphism interchanging the two
  sides; a polarity is such an automorphism **of order 2**. So "does the self-duality descend to
  an order-2 polarity?" is a genuine binary invariant — but it is framed via **automorphism
  order**, not a cohomology class.

**Second angle (neighborhood of the named sources), all consistent:**

- The 11-cell as self-dual with `Aut = PSL_2(11)`: Grünbaum 1976 / Coxeter 1984, and the
  `L_2(q)`-polytope literature (arXiv:math/0606660 "Groups of type `L_2(q)` acting on polytopes";
  arXiv:2406.13848 medial-layer graphs of self-dual polytopes). The self-duality being **outer**
  (extends `PSL_2(11)` to `PGL_2(11)`) matches the audited Spike 2/3.
- Projective-geometry side: **polarity = duality of order 2; absolute points = self-conjugate
  points** (Fano orthogonal polarity has 3 collinear absolute points, Baer). Standard
  (Fano-plane / duality references). The Fano plane is self-dual with `Aut = PGL_3(2) ≅ PSL_2(7)`.
- Ionin–Shrikhande symmetric-design duality and "polarity design" codes
  (e.g. arXiv:1602.04661 self-dual `[128,64]` polarity design code) treat polarities of symmetric
  designs and their codes — but always as a polarity of the design's **own** point/block set.

**What is NOT pre-empted (surviving composition), bounded:**

1. **The design points are an EXTERNAL labeling set.** No located source realizes the polarity
   of `2-(11,6,3)` / Fano / the Paley biplane as the outer coset acting on an **external** orbit
   structure (the Clebsch matching *sheets*, the C406/C379 secant-matching decoration) rather
   than on the design's own points. The classical external-self-duality of the 11-cell acts on
   the polytope's own flags; the cross-sheet construction (sheet A = vertices, sheet B = facets,
   built from `PGL_2(q)`-orbits of matchings) is the surviving new realization.
2. **The cohomological "one bit."** "Externally self-dual" (Cunningham–Pellicer) is a yes/no
   property; "self-dual not self-polar" (BCH) is a binary invariant read off automorphism order.
   Neither frames the self-duality *choice* as a **class in `H^1`** / an affine 1-cocycle
   (the C417 `[c]`, `2q`-torsion). The identification "self-duality choice = one cohomology bit
   = the base-change cocycle" is the surviving composition and was not located in either
   the polytope-duality or the design-polarity literature.

**KEY-Q answers.** Is the polarity ever identified with a `PGL/PSL` outer coset acting via an
external orbit structure? — the **outer-coset** part is standard (external self-duality); the
**external-orbit / matching-sheet realization** is not located. Is "self-duality = one cohomology
bit" known? — the **binary** self-dual-vs-self-polar fact is classical; the **cohomological**
(cocycle-class) phrasing is not located.

**Bounded negative.** No predecessor located, within keyword + two named-source neighborhoods
(Cunningham–Pellicer external duality; Brouwer–Cameron–Haemers self-polarity; `L_2(q)`-polytope
and polarity-design canon), for (a) realizing the exceptional-design polarity on an external
matching-sheet labeling or (b) the cocycle-class "one bit" phrasing. The generic concepts
(external self-duality, self-dual-not-self-polar, polarity of a symmetric design) are classical
and must be **credited, not claimed**.

---

## Verdict (II): CONCEPT ESTABLISHED IN CONTINUOUS GEOMETRY; the discrete/mod-p realization survives

"Chirality = sign of a **cubic / third-order tensor moment** (a pseudoscalar triple product)"
is an established idea — but in **continuous 3D geometry / physics / chemistry**, not over a
finite combinatorial set of matchings mod `p`.

**Closest prior work.**

- **Hattne & Lamzin, "A moment invariant for evaluating the chirality of three-dimensional
  objects," J. R. Soc. Interface 2011** (PMC3024826; PubMed 20685692).
  *Found by:* keyword search "chirality invariant sign cubic tensor moment". A chirality measure
  built from geometric **moments** that distinguishes the hand of a 3D object and quantifies the
  degree of handedness. Continuous-valued, real Euclidean space.
- **"Chiral moments make chiral measures," arXiv:2603.26793.**
  *Found by:* same keyword thread. Verified from the fetched PDF: chirality is a **pseudoscalar
  built from tensorial moments**, "the simplest such pseudoscalar requiring three tensorial
  moments in the shape of a tensorial triple product" — i.e. a **cubic** moment whose **sign**
  carries handedness. Confirmed setting = **continuous 3D physics/optics**; **no** finite fields,
  matchings, mod-`p`, outer automorphisms, or relative invariants as an organizing principle.
- Also in this neighborhood: "Fast and efficient calculations of structural invariants of
  chirality" (arXiv:1711.05866); "Systematic generation of moment invariant bases for 2D/3D
  tensor fields" (ScienceDirect S0031320321004933). Same continuous-geometry register.

**Second angle — the discrete/combinatorial side (neighborhood of oriented-matroid and
polytope-chirality literature):**

- **Chirotopes / oriented matroids** encode a discrete orientation as a **sign vector**, and the
  chirotope of a rank-3 configuration is exactly a "set of sign factors" (arXiv:1003.2348).
  This is the discrete-orientation analogue — but the sign is a `d`-ary **bracket / determinant
  sign**, not a **cubic moment summed with `eps(M)` over matchings**, and there is no mod-`p`
  readout.
- **Combinatorially chiral polytopes**: a polytope is combinatorially chiral if every
  self-equivalence preserves orientation (search neighborhood, Cunningham self-dual-chiral
  polytopes arXiv:1111.4496). Again a yes/no orientation property, not a cubic-moment sign.
- **Relative invariants / cubic forms** (Fels–Olver `ri.pdf`; ternary-cubic invariants `I, J`):
  cubic *relative invariants* under a group action are classical, and an **outer**-odd relative
  invariant flipping sign under an outer element is the right abstract frame for `mu_3` — but no
  located source **defines a discrete chirality bit as the sign of `sum eps(M) D(M)^{⊗3}` over
  matchings/of a design**.

**KEY-Q answer.** Is a discrete chirality/orientation bit ever defined as the **sign of a cubic
tensor moment over matchings or over a design**? — **Not located.** The two established templates
are (a) continuous 3D chirality = sign of a cubic moment (Hattne–Lamzin; arXiv:2603.26793) and
(b) discrete orientation = chirotope sign / combinatorial chirality; the audited construction is
their **crossing** — a continuous-style cubic-moment sign realized as a mod-`p` invariant of a
finite matching family (`M_3[0,0,0] = 6` vs `5 = -6 mod 11`), tied to the `PGL/PSL` outer coset.
That crossing is the surviving novelty.

**Bounded negative.** No predecessor located, within keyword search plus two named neighborhoods
(continuous moment-chirality: Hattne–Lamzin, arXiv:2603.26793; discrete orientation: oriented-
matroid chirotopes, combinatorial polytope chirality), for a **finite-field / mod-`p` chirality
bit defined as the sign of a signed cubic moment over matchings or over a symmetric design**. The
underlying pieces — chirality-as-cubic-moment-sign, and cubic relative invariants odd under an
outer automorphism — are classical and must be **credited, not claimed**.

---

## Summary table

| angle | general concept | status | surviving composition |
|---|---|---|---|
| (I) | duality via outer automorphism | **pre-empted** — "external self-duality" (Cunningham–Pellicer, arXiv:1610.02672) | polarity on an **external matching-sheet** labeling + **cocycle-class** one-bit framing |
| (I) | self-dual vs self-polar "one bit" | **pre-empted** — Brouwer–Cameron–Haemers (sdnsp) | its identification with the C417 `H^1` cocycle class |
| (II) | chirality = sign of cubic moment | **pre-empted in continuous geometry** — Hattne–Lamzin (PMC3024826); arXiv:2603.26793 | the **discrete mod-`p`** realization over matchings, `±6 mod 11` |

## Sources (re-findable ids, with how found)

- arXiv:1610.02672 — Cunningham & Pellicer, *Internal and external duality in abstract polytopes*
  (also `cdm.ucalgary.ca/article/view/62785`). Keyword: "external self-duality outer automorphism".
  Text extracted and verified this session.
- Brouwer, Cameron, Haemers, Preece, *Self-dual, not self-polar* (2003),
  `webspace.maths.qmul.ac.uk/l.h.soicher/designtheory.org/library/preprints/sdnsp.pdf`.
  Keyword: "self-dual self-polar design". Full text extracted and verified this session.
- arXiv:math/0606660 — *Groups of type `L_2(q)` acting on polytopes* (11-cell / `PSL_2(11)`
  neighborhood). Keyword: "11-cell PSL(2,11) self-dual polytope".
- arXiv:2406.13848 — medial-layer graphs of self-dual regular/chiral polytopes (neighborhood).
- arXiv:1602.04661 — self-dual `[128,64]` **polarity design** code (symmetric-design polarity
  neighborhood, Ionin–Shrikhande register).
- PMC3024826 / PubMed 20685692 — Hattne & Lamzin, *A moment invariant for evaluating the
  chirality of three-dimensional objects* (2011). Keyword: "chirality moment invariant".
- arXiv:2603.26793 — *Chiral moments make chiral measures* (chirality = sign of a tensorial
  triple product). Keyword: "chiral measure cubic tensor moment"; PDF fetched and verified.
- arXiv:1711.05866 — *Structural invariants of chirality* (continuous, neighborhood).
- arXiv:1003.2348 — *Oriented matroids* (chirotope = discrete sign orientation, neighborhood).
- arXiv:1111.4496 — Cunningham, *Constructing self-dual chiral polytopes* (discrete chirality
  neighborhood).
- `ri.pdf` (Fels–Olver, *On relative invariants*) — relative-invariant framing for `mu_3`.

**Trusted boundary.** Web-index coverage (WebSearch) plus text extraction of four PDFs this
session. No MathSciNet/zbMATH consulted. Negatives are "not located within the recorded
coverage," not unrestricted nonexistence.
