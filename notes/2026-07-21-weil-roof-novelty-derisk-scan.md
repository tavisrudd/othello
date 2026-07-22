# Weil-roof novelty de-risk scan (pre-audit risk scan)

Date: 2026-07-21. Scope: pre-audit closest-prior-art scan for three headline results (H1/H2/H3).
This is a **risk scan, not a formal novelty audit** — it locates the nearest exposed prior art and
flags what a formal audit must still verify. Sources marked "(unverified from primary)" were read
only via search-engine summary or an abstract, not the full primary text.

Tooling: lit-search cache at `/tmp/persistent/tavis/lit-search/` (queried by key) plus WebSearch /
WebFetch. Cache texts read in full are cited by key.

---

## H1 — Matching-sheet origin of the biplane and Fano plane

**Claim under test.** For q=7,11 the perfect matchings of K on P^1(F_q) that form two size-q
PSL_2(q) orbits ("sheets", swapped by PGL) have a cross-sheet *disjointness* relation that is
exactly the Fano plane 2-(7,3,1) and the Paley biplane 2-(11,5,2), with sheets as points/blocks and
an outer PGL element as point-block duality.

### (a) Closest prior art

- **Bertram Kostant, "The Graph of the Truncated Icosahedron and the Last Letter of Galois,"
  Notices AMS / Mitt. DMV 1995** (cache key `10.1515/dmvm-1995-0405`, read in full). Kostant builds
  the (11,5,2) biplane from PSL(2,11): the eleven blocks are the additive translates of the
  quadratic-residue set {1,3,4,5,9} in F_11 (the **classical Paley/QR development**), tied to the
  icosahedron, the buckyball, Galois' last letter, and 12×12 Hadamard matrices ("The eleven
  5-element subsets obtained in this way must make a biplane geometry in order that the columns of R
  be orthogonal"). This is the Paley development, **not** a perfect-matching/one-factor construction
  and **not** a two-orbit cross-sheet disjointness relation.
- **P. Martin & D. Singerman, "The geometry behind Galois' final theorem," European J. Combin. 34
  (2013)** (cache key `10.1016/j.ejc.2012.03.005`, not-a-pdf in cache; abstract/expository mirror
  "From Biplanes to the Klein Quartic and the Buckyball" — unverified from primary). Continues the
  Kostant thread: biplane ↔ PSL(2,11) ↔ Klein quartic ↔ buckyball. Same icosahedral/Galois circle;
  no matching-sheet disjointness statement surfaced.
- **Ezra Brown, "The Fabulous (11,5,2) Biplane," Math. Magazine 77 (2004)**
  (`https://personal.math.vt.edu/brown/doc/1152.pdf`, extracted and read). Surveys the biplane's
  connections to the ternary/binary Golay codes G_11,G_12,G_23,G_24 and Steiner systems S(4,5,11),
  S(5,6,12); Aut = PSL(2,11). The full-text extraction contains **no** "one-factor," "matching," or
  icosahedral points/blocks construction — the survey does not derive the biplane from perfect
  matchings.
- **One-factorization-of-complete-graphs-with-PSL_2(q)-automorphism literature** — the structurally
  nearest neighbor to the "sheet" object: Cameron & Korchmáros, "One-factorizations of complete
  graphs with a doubly transitive automorphism group," Bull. LMS 25 (1993) (`10.1112/blms/25.1.1`);
  Korchmáros, Nagy & Pace, JCTA 157 (2018) (`10.1016/j.jcta.2018.06.008`); Pace & Sonnino, Electron.
  J. Combin. 27 (2020) (`eljc:v27i1p37`, read); Chen & Lu, "Symmetric factorizations of the complete
  uniform hypergraph," J. Alg. Combin. (2017) (`10.1007/s10801-017-0760-8`, read — classifies
  PSL/PGL-symmetric 1-factorizations via fractional-linear maps and Steiner systems). These study
  1-factorizations of K_{q+1}/K_n *invariant under* PSL_2(q); the first two are cached but
  not-a-pdf (unread), so their exact orbit structure is **not** verified here.
- Also in the biplane-automorphism literature: flag-transitive biplanes with almost-simple classical
  socle (Springer, `10.1007/s10801-007-0070-7`) confirm PSL(2,11) as the (11,5,2) automorphism
  group but give no matching origin.

### (b) Pre-emption verdict: **PARTIALLY ANTICIPATED**

Covered by prior art: (i) the *objects* (Fano 2-(7,3,1), Paley biplane 2-(11,5,2)) and their
PSL_2(q) automorphism groups; (ii) the icosahedral/Galois/PSL(2,11) provenance of the biplane
(Kostant; Martin–Singerman); (iii) the point/block self-duality of a biplane and PGL as the outer
symmetry (classical). **Not** located in any read source: the specific construction realizing the
design as the **cross-sheet disjointness relation between two size-q PSL_2(q) orbits of perfect
matchings**, with sheets serving as both point set and block set and a PGL element as the
point-block polarity. That mechanism appears to be the genuinely new packaging.

### (c) Searched domains / queries / stop conditions

- Cache scan (keys grepped: `biplane|Fano|matching|one-factor|orbit|icosah|Kostant|PSL`): surfaced
  Kostant 1995, Martin–Singerman, Cameron–Korchmáros, Korchmáros–Nagy–Pace, Pace–Sonnino, Chen–Lu.
  Read in full: Kostant, Pace–Sonnino, Chen–Lu, Brown.
- WebSearch: `"biplane 2-(11,5,2) construction from perfect matchings one-factorization K12
  PSL(2,11)"`; `"perfect matchings projective line PSL(2,q) two orbits sheets design Fano biplane
  disjointness"`; `"two orbits of one-factors PSL(2,q) projective line block design points blocks
  polarity duality PGL"`; `"Ezra Brown fabulous (11,5,2) biplane constructions one-factorization K12
  Petersen icosahedron"`.
- Stop condition: three distinct search framings (by object, by construction, by group-orbit) plus
  the two canonical survey/priority sources (Brown, Kostant) all return the Paley/QR development,
  Golay/Steiner links, or invariant 1-factorizations — none the cross-sheet-disjointness design.

### (d) Residual risk for a formal audit

Must read the two cached-but-unread one-factorization papers (`10.1112/blms/25.1.1`,
`10.1016/j.jcta.2018.06.008`) at full text: if their PSL_2(q)-invariant 1-factorizations of K_{q+1}
already decompose into the two size-q orbits and someone computed the disjointness incidence, H1's
core could be anticipated there. Also verify the q=7 Fano instance is not folded into the "biplane
of order 2 = complement of Fano" folklore.

---

## H2 — Lagrangian matching packings and theta parity on y^2 = x^q - x

**Claim under test.** For y^2 = x^q - x over F_q (q=5,7,11): each perfect matching of the branch set
P^1(F_q) spans a Lagrangian (maximal isotropic) subspace of J[2] in the even-subset model; the
PSL_2(q) sheets give Lagrangian packings; all Cartier–Manin matrices vanish (superspecial); and in
Mumford's theta-characteristic subset model the invariant origin has Arf 0 (q=7) / Arf 1 (q=11),
identical sheet signatures.

### (a) Closest prior art

- **Superspecial part (classical).** The Weil pairing / symplectic structure on J[2] of a
  hyperelliptic curve in the even-subset-of-branch-points model, and the identification of maximal
  isotropic subspaces, is textbook: **Mumford, Tata Lectures on Theta II** (cache
  `10.1007/978-0-8176-4578-6`) develops the theta-characteristic subset model and Arf invariant on
  branch-point subsets. y^2 = x^q - x is the standard **superspecial / Hermitian-adjacent**
  Artin–Schreier–reducible curve: van der Geer & van der Vlugt, "Reed–Muller codes and supersingular
  curves I," Compositio Math. 84 (1992) 333–367, and "On the existence of supersingular curves of
  given genus," J. Reine Angew. Math. 458 (1995) (unverified from primary — abstracts only); the
  Hermitian curve y^p+y = x^{p+1} superspecial statement and Cartier-operator-vanishing criterion
  are standard (multiple hits, e.g. Ekedahl-Oort / Hasse–Witt literature). The vanishing of all
  Cartier–Manin matrices for this family is therefore **classical, not novel** — cite van der
  Geer–van der Vlugt and the Hermitian/superspecial references.
- **Theta characteristics with group action.** "Orbits of Theta Characteristics" (cache
  `arXiv:2404.09890`, present) treats group actions on theta characteristics — a conceptual neighbor
  but not this curve family. 2-torsion of hyperelliptic Jacobians over finite fields as
  Weierstrass-point combinatorics: several general references (e.g. arXiv:2205.13017, 43794984 —
  unverified) describe J[2] via even subsets of branch points and note maximal isotropic subgroups
  as isogeny kernels.
- **Matching → Lagrangian statement.** No read source states that a *perfect matching of branch
  points* spans a Lagrangian subspace of J[2], nor a "Lagrangian packing" / "spread of Lagrangians"
  in J[2] organized by a group action. The isotropic-subgroup-as-isogeny-kernel language exists
  generically but is not tied to matchings/one-factors of the Weierstrass set.

### (b) Pre-emption verdict: **PARTIALLY ANTICIPATED**

Covered: superspeciality/Cartier–Manin vanishing of y^2 = x^q - x (classical); the
even-subset/theta-characteristic model of J[2] with its symplectic form and Arf invariant (Mumford,
classical); maximal isotropic subgroups of J[2] as a standard object. **Not** located: the specific
reading of a perfect **matching** as a Lagrangian subspace, the "Lagrangian packing" statement from
the PSL_2(q) sheets, and the q=7 vs q=11 Arf-parity (0 vs 1) computation for the invariant theta
origin with identical sheet signatures. The novelty is the matching↔Lagrangian dictionary and the
sheet-organized packing, not the underlying superspecial/theta facts.

### (c) Searched domains / queries / stop conditions

- WebSearch: `"one-factors Weierstrass points Lagrangian isotropic subspace 2-torsion Jacobian
  hyperelliptic theta characteristic"`; `"Lagrangian subspace J[2] two-torsion hyperelliptic even
  subset model one-factor branch points Arf invariant"`; `"van der Geer van der Vlugt curve
  y^2 = x^p - x superspecial Artin-Schreier Hermitian Jacobian references"`; `"superspecial Jacobian
  y^2 = x^q - x Cartier-Manin matrix vanishes maximal curve"`.
- Cache: Mumford Tata Theta II, Orbits of Theta Characteristics, plus superspecial/Cartier–Manin
  keys.
- Stop condition: the superspecial/Cartier and even-subset/Arf angles converge on classical
  references from four framings; the matching↔Lagrangian angle returns only generic
  isotropic-subgroup language across three framings.

### (d) Residual risk for a formal audit

Confirm the exact standard citation for superspeciality of y^2 = x^q - x over F_q (pin van der
Geer–van der Vlugt vs a genus-specific source) at primary text — the negative on the
matching→Lagrangian statement rests on unread abstracts, so verify against Mumford Tata II §III and
the 2-torsion-over-finite-fields literature before claiming the dictionary is new.

---

## H3 — The (2/q) fusion law (team's most-novel headline)

**Claim under test.** For primes q where Q(√5) splits, the two PSL_2(q) A5-marked matching sheets
are "visible" (distinct) exactly when (2/q) = -1 and fuse into one PGL_2(q) orbit when (2/q) = +1
(split residues 11,19,21,29 mod 40; fused 1,9,31,39 mod 40). The same (2/q) governs whether a
det-2 rational rotation is an outer sheet swap and the Arf parity of the theta origin.

### (a) Closest prior art

- **Classical A5-embedding condition (Dickson) — governs *existence*, and does NOT involve (2/q).**
  Confirmed at full text: the maximal-subgroup determination (cache `arXiv:math/0703685`, read):
  A5 ≤ PSL(2,q) iff q ≡ ±1 (mod 10) with q = p or q = p^2, p ≡ ±3 (mod 10); there are **two
  conjugacy classes of A5**, and **these two classes are fused in PGL(2,q)** (stated
  unconditionally, for the prime case). So the *subgroup-conjugacy* fusion is classical and, as
  written there, **not** gated by (2/q) — the classical criterion is purely q mod 5/10.
- **The (2/q) = q≡±1 mod 8 criterion is classical, but for S4, not A5.** Dickson: S4 ≤ PSL(2,q) iff
  q ≡ ±1 (mod 8) (i.e. (2/q) = +1), with two conjugacy classes (`arXiv:math/0703685`, read;
  corroborated by WebSearch). This is a genuine classical instance of "(2/q) controls an
  icosahedral-adjacent subgroup phenomenon in PSL(2,q)" — the nearest classical fact to H3's flavor,
  but attached to S4-existence, not A5-sheet fusion.
- **Galois-fusion-of-orbits machinery.** Lansdown & Martin, "Rational Delsarte designs and Galois
  fusions of association schemes," Canad. Math. Bull. 2025 (cache `10.4153/S000843952510146X`, read):
  develops when Galois orbits over the splitting field (here Q(√5)) fuse relations/orbits of an
  association scheme — the right conceptual language for "sheets fuse under a Galois/PGL action," but
  it is generic scheme theory and makes **no** (2/q) statement about A5 orbits in PSL_2(q).
- **Spinor-norm / icosian angle.** The binary icosahedral group is realizable over Q(√5); reduction
  mod p and spinor-norm criteria for icosahedral reductions appear (grokipedia binary-icosahedral,
  spinor-norm literature — unverified from primary), but no read source ties (2/q) or q mod 40 to
  A5-orbit visibility or a det-2 rotation acting as an outer swap.
- Note: one WebSearch summary *asserted* "(2/q) determines how A5 conjugacy classes split between
  PSL and PGL," but this is an **engine synthesis with no cited source** and contradicts the
  full-text Dickson statement (classes always fuse in PGL). Treat it as **unverified and likely
  wrong** as phrased.

### (b) Pre-emption verdict: **NO CLOSE PRIOR FOUND** (for the specific (2/q)↔A5-sheet-visibility law)

The specific statement — that the two PSL_2(q) *matching sheets carrying A5 markers* are visible
exactly when (2/q) = -1 and fuse under PGL when (2/q) = +1, with the residue partition 11,19,21,29
vs 1,9,31,39 mod 40, and the same symbol governing a det-2 rotation swap and the theta Arf parity —
was not located in any read source. The classical literature supplies two *near-misses*, not a
pre-emption: (i) (2/q) classically governs **S4** existence in PSL(2,q); (ii) the **A5 conjugacy
classes** fuse in PGL **unconditionally**. Neither is H3's object (matching-sheet orbits), and
neither uses q mod 40.

### (c) Searched domains / queries / stop conditions

- WebSearch: `"Legendre symbol (2/q) fusion splitting A5 icosahedral conjugacy classes PSL(2,q)
  PGL(2,q)"`; `"S4 subgroup PSL(2,q) exists iff q ±1 mod 8 quadratic character of 2"`; `"spinor norm
  determinant 2 rotation icosahedral group reduction mod p quadratic residue splitting field SO3"`;
  plus the two-orbit and Galois-fusion queries above.
- Cache full-text: maximal subgroups with socle PSL(2,q) (`arXiv:math/0703685`); Lansdown–Martin
  Galois fusions (`10.4153/S000843952510146X`).
- Stop condition: three independent framings (classical maximal-subgroup / Dickson, Galois-fusion of
  schemes, spinor-norm icosian reduction) each return either the q-mod-5 A5 condition, the q-mod-8
  S4 condition, or generic fusion theory — none couples (2/q) to A5-orbit visibility or q mod 40.

### (d) Residual risk for a formal audit

Two exposures remain. **First, an object-collision risk:** a referee who reads "A5 classes always
fuse in PGL(2,q)" (classical) may believe H3 is either wrong or trivial; the write-up must make
airtight that the fused/visible object is the **matching-sheet orbit**, distinct from A5 subgroup
conjugacy, and reconcile why one is (2/q)-gated while the other is unconditional. **Second,** the
q-mod-8 ⟺ (2/q) equivalence and the S4 classical result mean the "(2/q) controls
icosahedral-adjacent structure" idea is not itself new — the audit must isolate precisely what about
the A5 *sheet* mechanism is not a repackaging of the S4/spinor-norm folklore, and must read the
van-der-Geer–van-der-Vlugt / icosian-reduction primaries (unread here) to close the spinor-norm
angle at source.

---

## Ranked exposure summary

| Rank | Headline | Verdict | Closest prior art | Exposure |
|------|----------|---------|-------------------|----------|
| 1 (most exposed) | H2 — Lagrangian matching packings / theta parity | PARTIALLY ANTICIPATED | Mumford Tata Theta II (Arf/subset model); van der Geer–van der Vlugt + Hermitian (superspecial, Cartier–Manin vanish) | Superspecial + Arf machinery is classical; only the matching↔Lagrangian packing dictionary is new. Frame as a repackaging over a classical base. |
| 2 | H1 — Matching-sheet biplane/Fano | PARTIALLY ANTICIPATED | Kostant 1995 (Paley/QR biplane from PSL(2,11)/icosahedron); Martin–Singerman 2013; Cameron–Korchmáros / Korchmáros–Nagy–Pace / Pace–Sonnino (PSL_2(q)-invariant 1-factorizations) | Objects + icosahedral provenance well-trodden; the cross-sheet-disjointness realization looks new but the two unread 1-factorization papers are the live risk. |
| 3 (least exposed / most novel) | H3 — the (2/q) fusion law | NO CLOSE PRIOR FOUND | Dickson S4 iff (2/q)=+1 (near-miss); A5 classes fuse in PGL unconditionally (near-miss); Lansdown–Martin Galois-fusion machinery | No source couples (2/q) / q mod 40 to A5-sheet visibility. Main risk is object-collision with the classical "A5 fuses in PGL," not pre-emption. |

**Provenance flags.** Read at full text: Kostant 1995 (`10.1515/dmvm-1995-0405`), Brown 2004,
Pace–Sonnino (`eljc:v27i1p37`), Chen–Lu (`10.1007/s10801-017-0760-8`), maximal subgroups
(`arXiv:math/0703685`), Lansdown–Martin (`10.4153/S000843952510146X`). **Unverified from primary
(abstract/search-summary only):** Martin–Singerman 2013, Cameron–Korchmáros 1993 and
Korchmáros–Nagy–Pace 2018 (cached but not-a-pdf, unread), van der Geer–van der Vlugt 1992/1995,
all 2-torsion/theta and spinor-norm hits. The one search summary asserting "(2/q) splits A5 classes"
is uncited engine synthesis and is treated as unverified/likely wrong.
