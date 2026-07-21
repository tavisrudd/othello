# Six shadows of one bit — conversation report and Weil-roof synthesis

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Status:** speculative conversation dossier. Nothing here is a certified result unless it cites an
existing committed certificate by C-ID. No task allocation, no manuscript change, no novelty claim.
All literature citations introduced in this document (beyond those already audited in the cited
notes) are **from model memory and unverified**; the companion program requires verifying each
before any use. Companion execution plan:
[`2026-07-21-clebsch-weil-roof-program.md`](2026-07-21-clebsch-weil-roof-program.md).

## Epistemic key

- **PROVED** — backed by an existing committed certificate bundle (C-ID cited).
- **CHECKED (notebook)** — exact finite check in the cocycle-gateway exploration notebook
  (`2026-07-20-cocycle-gateway-explorations.md`), not yet promoted to evidence-bundle standard.
- **REASONED** — argued in conversation with a proof sketch; needs a certificate.
- **SPECULATIVE** — conjecture; needs a test or could fail outright.
- **DECORATION** — numerological observation with no mechanism; carry with a caution flag only.

## 1. Inputs reviewed

The conversation started from the cocycle/gateway exploration notebook
(`2026-07-20-cocycle-gateway-explorations.md`, Spikes 1–6 plus its nine-angle novelty audit), the
paper-planning report (`2026-07-20-clebsch-paper-planning.md`), and full reads of the three spine
result notes: C406 (`2026-07-20-c406-matching-module.md`), C411
(`2026-07-20-c411-double-coset-hecke.md`), C412 (`2026-07-20-c412-relative-cubic-depth-plane.md`).

## 2. The gateway spikes as the "singular exception" rebuttal

Assessment: used as the answer to "interesting object, but a singular exception," the gateway
material is a substantial upgrade — the difference between a strong paper about one exceptional
configuration and a paper about a complete, finished phenomenon whose apex is the Clebsch hexagon.

- The paper's own theorems manufacture the objection (`thm-clebsch-why11`,
  `thm-clebsch-family-uncovered` prove isolation). The spikes invert it: A3/B3/H3 is the complete
  irreducible rank-3 Coxeter list; each conic phase `q = h+1 = 5,7,11` lands on a named exceptional
  object (doily / Fano / 11-cell design); the splitting cases carry the two nontrivial exceptional
  perfect codes (Hamming `[7,4,3]`, ternary Golay `[11,6,5]`), minimum distances confirmed.
- q=11 sits at the confluence of three independent classifications: rank-3 Coxeter groups, perfect
  codes, self-dual `PSL_2(q)` geometries. The isolation the paper proves is the shadow of isolations
  the literature already owns.
- The central bit gets a concrete face: bare Aut C2 (C413) = golden sheet-swap (C379) = design
  polarity (Spikes 2–3) = cocycle chirality (C417), measured by the sign of `mu_3` (`±6 mod 11`,
  Spike 5, matching C411's independent value).
- Near-zero marginal cost: only genuinely new computation for the paper is the cross-sheet
  shared-edge incidence.

Staging ladder proposed: punchline = complete family; "but wait, there's more" = the perfect codes;
"one more thing" = the measurable bit (±6 readout closing back to the decoder narrative);
after-credits = H4/q=31. Ending on Golay was rejected (invites "new construction of a known code, so
what" and walks toward the M_12 overclaim, which the spikes' audit refutes:
`PGL_2(11) not-subset M_11` since `PSL_2(11)` is maximal in `M_11`).

## 3. Red team of that staging

- **Two data points in a three-point costume.** The full phenomenon (design + code + chirality)
  occurs only at q=7,11; A3 is a degenerate control whose doily reading is the notebook's own
  non-standard construction.
- **Paley deflation.** Given the `PSL_2(q)` action, the cross-sheet design being Paley is close to
  forced, and the C406 audit already credits Pan–Wu–Yin with the `PGL_2(11)/A5` Hadamard orbital
  action including cross-sheet valencies `5,6` and stabilizers `A4,D10`. Fano→Hamming and
  biplane→ternary-Golay are textbook. What survives is the first arrow: the conic-factorization
  geometry produces these sheets at all.
- **"Measure the forgotten bit" near-contradiction.** The ±6 readout needs the parent-side
  configuration and a frozen frame; it is a relative invariant, canonical only up to the outer
  coset. Must be staged as measurable-given-decoration, never determinable-from-child.
- **"Four threads are one bit" is partly tautological.** Sheet choice = choice between the two
  fused conjugacy classes of `A5` in `PSL_2(11)` (classical); external self-duality is a named
  classical notion (Cunningham–Pellicer); the content is the equivalence of incarnations. Nit: all
  660 outer elements are dualities; only involutory ones are strictly polarities.
- **11-cell overreach.** Only the vertex-facet design level is checked; edge/face flag gates open.
  Say "the vertex-facet design of the 11-cell." The q=7 "polytope tower" term (Fano-as-polytope)
  needs a citation or a downgrade to "self-dual incidence geometry."
- **q=19 tower-divergence category error.** No rank-3 Coxeter group has h+1=19; the polytope tower
  "continues" only in the ambient Leemans–Schulte classification, not in the construction. As
  originally stated the falsifier quantifies over the wrong level.
- **600-cell is not self-dual** (dual is the 120-cell), so the H4 tease can promise only
  "cocycle + cubic bit," not the full package.
- Terminology: "chirality" clashes with chiral-polytope usage; must rename or disambiguate.

Survives untouched: the uniform C399/C403/C406 theorems, C430 rigidity, C412 parity theorem, C417
cocycle nontriviality, C379 sufficiency. The punchline must be load-bearing on those.

## 4. First level-up: Galois's last letter

- **REASONED.** The B3 sheet is `PSL_2(7)/S4` (7 points) and the H3 sheet is `PSL_2(11)/A5`
  (11 points): the sheets are Galois's exceptional degree-q actions; the two sheets are the two
  conjugacy classes of the index-q subgroup, fused by `PGL_2(q)`; the golden exchange is the
  fusion; C406's splitting criterion (parent in PSL) is Galois's subgroup condition. Family
  completeness is doubly forced: Coxeter classification on the input side, Galois's theorem on the
  output side. Upgrades the Arnold/Kostant trinity from observed correspondence to constructed
  transport (heavy credit due: Edge already owns the q=11 degree-11 action on hexagon systems;
  Kostant owns the H3/PSL_2(11) link).
- **Complete characterization of the bit** (each clause certified): present (genuine self-duality,
  `Aut = PSL != PGL`); minimal (cubic-first forced and sharp — C406/C412/C430); sufficient (C379);
  non-gaugeable (C417). Necessary, sufficient, minimal, non-canonical: a closed ledger
  `22 -> 6 -> 2 -> 1` with every arrow's fibre named and every rank drop explained.
- Post-credits repair: state rank-3 completeness on both sides; pose H4/q=31 with its cheap first
  gate (splitting criterion) explicitly computable now.

## 5. Baseline grades and venue (v1)

Assuming prose polish equal to proof polish and Lean-formalized structural theorems:

| Dimension                  | Grade | Basis (compressed)                                             |
|:---------------------------|:-----:|:---------------------------------------------------------------|
| Correctness / verification | A+    | Lean + dual replays + certificates; outlier for the field       |
| Novelty                    | B+    | New compositions; objects classical; crowded adjacent territory |
| Technical depth            | B     | Textbook tools; value is exactness and synthesis                |
| Significance               | B     | Definitive but self-terminating; no exported machinery          |
| Story / memorability       | A−    | With the punchline staged, top of its genre                     |
| Audience breadth           | B−    | Finite geometry, designs, some coding, QI sliver                |

Overall A− as a specialist paper. Venue: JCTA primary; Journal of Algebraic Combinatorics and
Designs, Codes and Cryptography alternates; EJC/FFA fallbacks; Trans. AMS stretch not recommended;
Mathematical Intelligencer companion for the narrative; ITP/CPP for a formalization note.

## 6. Generative pass A — arithmetic geometry and mechanism

1. **Roquette curve / Lagrangian reading (REASONED core, SPECULATIVE refinement).** The conic
   points at the conic phase are all of `P^1(F_q)`, so the branched double cover is
   `y^2 = x^q − x` — the Roquette curve (exceptional automorphism group containing `PGL_2(q)`;
   supersingularity of its Jacobian asserted from memory, needs verification). In the standard
   model of `J[2]` (even subsets of branch points mod complement, Weil pairing = intersection
   parity): each perfect matching spans a **Lagrangian** (pairs disjoint ⇒ orthogonal; six classes
   sum to zero; no proper sub-sum vanishes ⇒ dimension g), a sheet is a partition of the 66
   Weierstrass 2-torsion points into 11 Lagrangian hexads, and the two sheets are two
   `PSL_2(11)`-orbits of Lagrangians. Matchings of branch points are kernels of generalized
   Richelot isogenies (Donagi–Livné), placing the sheets at a superspecial point of an isogeny
   graph. The A3 case grounds Spike 6's doily reading classically (Sp(4,2), genus-2 Richelot).
   **Open question: is the chirality bit a theta/Arf parity** of the sheet packings against the
   canonical hyperelliptic theta structure?
2. **Split Coxeter torus (REASONED).** `q − 1 = h`: the rotation part of the Coxeter element has
   exactly the order of the split maximal torus of `PSL_2(q)` (2, 3, 5 at q = 5, 7, 11); split
   torus elements fix two conic points and rotate the rest in one `(q−1)`-cycle — the finite
   avatar of the Coxeter plane. Conjecture: the marker embedding sends the Coxeter rotation to a
   split-torus generator. Would upgrade C399 from law to mechanism (Springer regular elements).
3. **Klein invariants (SPECULATIVE).** Confront `mu_3` with Adler's Klein cubic threefold (unique
   `PSL_2(11)`-invariant cubic on the 5-dimensional representation; Adler–Ramanan) and the Klein
   quartic at q=7. Sub-questions: geometry of the hypersurface `mu_3 = 0` in `P^9`; why the
   relative-invariant dimension is 3 in both B3 and H3.
4. **Shephard–Todd continuation (SPECULATIVE).** Rank-3 complex reflection groups with `h+1` a
   prime power: ST25 (Hessian, h=12 → q=13), ST26 (h=18 → **q=19**), ST27 (Valentiner, h=30 →
   q=31, same h as H4); ST24 (Klein, h=14 → 15, not a prime power, dead). A candidate repair of
   the q=19 category error.
5. **Method packaging (design decision).** "Signed-moment detection of orbit fission" as a
   free-standing mini-theory (C406+C409+C412+C430), with a characterization theorem as the target
   that would move the novelty grade: the B3/H3 sheet pairs as the only [bounded class] with
   strength exactly two and cubic separation. C410 is the first brick.
6. **Uses:** `mu_3` as a computable invariant separating AME classes; canonical structures at
   superspecial vertices of isogeny graphs; tri-prime question (p = 2, 3, 11 shadows of one global
   object).

Meta-observation: previous passes found new incarnations of the bit inside one ambient category;
the next tier requires changing ambient category (combinatorics → arithmetic) or supplying
mechanism.

## 7. Generative pass B — number theory

1. **Spin-field splitting law (REASONED; afternoon test).** Dickson: `S4 ⊂ PSL_2(q)` iff
   `q ≡ ±1 mod 8` iff q splits in `Q(sqrt 2)` (character field of binary octahedral `2.S4`);
   `A5 ⊂ PSL_2(q)` iff `q ≡ ±1 mod 5` iff q splits in `Q(sqrt 5)` (field of `2.A5`). Cases:
   A3/q=5 inert in `Q(sqrt 2)` (one sheet); B3/q=7 = `(3−√2)(3+√2)` split; H3/q=11 = `N(3+φ)`
   split. **Conjectured identification: sheet = choice of prime above q in the spin ring; golden
   exchange = Galois conjugation; C417 nontriviality = no canonical square root of 5 mod 11.**
   Quaternionic version: reducing the icosian (resp. binary octahedral) maximal order at the two
   primes above q gives the two embeddings, i.e., the two sheets. Revives C377 (golden descent)
   and reframes C382's icosian negative (reduction, not a marked-lattice functor, is the right
   category). Side door (SPECULATIVE): icosahedral mod-11 level structures / `X_{A5}(11)`.
2. **Serre–Kostant p = h+1 (SPECULATIVE frame, classical anchors).** Serre's embeddings
   `PSL_2(h+1) ⊂ G(C)` via the principal SL2: G2→7, F4/E6→13, **E7→19**, E8→31. Foldings sharing
   h: D4→G2, E6→F4, A4→H2, **D6→H3 (h=10)**, **E8→H4 (h=30)**. Consequences: the 57-cell's q=19
   gets a Lie-theoretic home (E7); C381's marked-E8 result reads as the E8→H4 folding trace; a
   research program on transporting factorization memory along Serre's embeddings.
3. **Lattice–theta chain (SPECULATIVE).** Construction A: extended Hamming `[8,4,4]` → E8;
   extended ternary Golay `[12,6,6]` → K12 (Coxeter–Todd, Eisenstein = p=3 arithmetic). Question:
   a marked-K12 recovery theorem parallel to C381, with the 12 conic points as the 12 Golay
   coordinates. Gives the tri-prime story its global objects (E8 at 2, K12 at 3, modular socle
   at 11) and modular-form theta series as carriers.
4. **CM lift (REASONED sketch).** Over Q, `y^2 = x^11 − x` has a `mu_20` action ⇒ CM abelian
   fivefold, Jacobi-sum point counts; reduction at 11 = automorphism jump to `PGL_2(11)`;
   Ibukiyama–Katsura–Oort superspecial context. Depth coordinates `D(M)` are already character
   sums; a Weil-style packaging of the ±6 readout is available.
5. **DECORATIONS.** 7, 11, 19 are consecutive Heegner numbers (5 is not); 11 is the first prime
   with two supersingular j-invariants (j = 0 and 1728 both supersingular; single supersingular j
   at p = 5, 7). No mechanism; do not write without one.
6. **Sheet reciprocity law (SPECULATIVE, the pass's closer).** Conjecture: the Frobenius identity
   (which spin prime), the theta identity (Arf parity), and the statistical identity (sign of
   `mu_3`) agree canonically. The *equality* is the mathematical content.

## 8. Generative pass C — information theory

1. **Exactly solved low-degree threshold (framing of PROVED results).** Sheet-uniform measures are
   indistinguishable by all degree-≤2 statistics and separated at degree 3; C430 makes the blind
   direction unique; C412 makes the threshold a parity theorem; the Brauer tree explains the gap.
   A finite, deterministic, certified instance of the low-degree framework
   (Hopkins–Steurer; Kunisky–Wein–Bandeira). Lattice `22 -> 6 -> 2 -> 1` = exact
   sufficient-statistic composition series (Diaconis sufficiency-and-symmetry).
2. **Equivariant advice complexity (cheap theorem; PROVED modulo definitions).** No equivariant
   deterministic decoder outputs a parent (C413 transitivity); one advice bit suffices (C379);
   the cocycle blocks natural choice across the family (C417). Advice complexity exactly one;
   leader-election analogy. Companions: unconditional 1-bit hiding with a proven two-level access
   structure; Gács–Körner reading (no extractable agreement on the label).
3. **Barker tower (CHECKED-classical identifications + SPECULATIVE prediction).** The disjointness
   designs are QR difference sets; the Legendre/QR sequences at lengths 7 and 11 are Barker
   sequences; Turyn–Storer stops odd Barker at 13. Towers each end at an impossibility theorem:
   perfect codes at 11 (van Lint–Tietäväinen), odd Barker at 13, polytopes at 19 (Leemans–
   Schulte). Prediction: a q=13 phase (if it exists) has Barker-13 as its operational endpoint.
4. **AME LU question (SPECULATIVE with a trap).** Are the chirality-conjugate AME(6,11) states
   LU-inequivalent, and at what invariant degree? Trap: the sheet swap is induced by party
   permutations (local), so the pair may be LU-equivalent — in which case the correct statement is
   the labeled/advice one. Either resolution is publishable.
5. **Positioning remarks:** deep holes = covering-radius attainers (RS deep-hole literature);
   decoder ambiguity = list decoding at covering radius with the list graded by the lattice
   ("equivariant list structure"); C403 as quantified isospectrality ("one cannot hear the sheet",
   deficiency exactly one bit, cubic-first); C369/C391/C392 service results unified under the
   advice statement.

## 9. Generative pass D — information geometry and statistics

1. **Chentsov two-tensor dichotomy (framing of PROVED results; the community pitch).** The Fisher
   metric (degree 2) is exactly blind along the chirality direction; the Amari–Chentsov cubic
   tensor (degree 3) carries exactly one bit. Amari hierarchy: the sheet measures share their
   m-projection onto the degree-≤2 exponential family; the divergence is a pure third-order
   interaction; the KL from either sheet to the projection is a computable scalar ("the bit in
   nats").
2. **Tensor-method identifiability (framing).** Exactly solved extremal instance of
   "second moments fail, third moments identify" (Anandkumar et al. vocabulary), with certified
   flattening ranks and a modular explanation of the rank drop — which that literature lacks.
3. **Singular-model asymptotics (SPECULATIVE, needs an observation model).** Label Fisher
   information vanishes to second order ⇒ Watanabe-style singular geometry, cube-root-family
   anomalous rates for the chirality parameter. Naive i.i.d. model trivializes (disjoint
   supports); a noisy-feature observation model must be chosen first.
4. **Design-of-experiments translation (cheap).** The sheets are complementary fold-over
   half-fractions with defining word of length 3 — resolution III with the word-length pattern
   proven extremal (minimum-aberration vocabulary); strength-exactly-2 = orthogonal-array/Delsarte
   condition (connects the Bamberg–Klawuhn frame already in the audit).
5. **Equivariant symmetry-breaking (bridge remark).** The geometric-deep-learning pathology
   (equivariant models cannot break symmetry) is exactly the advice-complexity theorem with a
   cohomology class attached.
6. **Stated non-connections:** e-values/anytime-valid inference, conformal prediction, causal
   inference; Petz monotone metrics only if the AME question resolves in the interesting
   direction.

## 10. Final synthesis — the Weil roof

The passes converged instead of diverging: every strand factors through components of the **Weil
(oscillator) representation of SL_2(F_q)** (SPECULATIVE as an identification; individually the
anchors are classical):

- Paley designs and both perfect codes are quadratic-residue objects; the codes are the QR codes
  QR(7)/F_2 and QR(11)/F_3, and their alphabets are reciprocity-selected (2 ∈ QR(7), 3 ∈ QR(11)) —
  the small primes of the tri-prime structure are chosen by reciprocity.
- The spin fields `Q(sqrt 2)`, `Q(sqrt 5)` are metaplectic (binary polyhedral) character fields.
- The Roquette reading is theta; the AME/stabilizer side lives in the finite Heisenberg–Weil
  formalism; C372's `P = Q` Fourier self-duality is a fixed-point statement for a Weil operator
  already proved by the program.
- Dimensional coincidence: the Weil representation of SL_2(11) splits into components of
  dimensions `(q−1)/2 = 5` and `(q+1)/2 = 6` — the cross-sheet valencies and Paley block sizes —
  swapped in the same outer orbit, with 5-dimensional character field `Q(sqrt −11)` (the Gauss-sum
  field) and, by Adler, a unique invariant cubic (the Klein cubic threefold) on the 5-dimensional
  component. The outer swap conjugates `sqrt 5` and `sqrt −11` simultaneously.
- Gauss's sign problem is the archetype: a sign invisible to low-order data.

**Roof conjecture.** The Clebsch factorization geometry is a module over the Weil representation of
the metaplectic `SL_2(F_q)`; the chirality bit is the exchange of the two Weil components; every
incarnation of the bit (Frobenius choice, theta parity, design polarity, cubic sign, Fourier
self-duality) is a functorial shadow of that exchange. Three bounded tests aim at it: (a) decompose
the cross-sheet incidence module and match the 5/6 components; (b) seek a Weil-equivariant map
relating `mu_3` to the Klein cubic; (c) reread C378/C372's Fourier fusion as a Weil fixed-point
statement.

Discipline conclusion reached in conversation: the generative phase ended itself (convergence
signal); next step is a verification battery and a program note, not more brainstorming.

## 11. Paper architecture — six-shadow ending and cliffhanger

**Form:** one closing section (not six) — "one more thing that turns out to be six": a Rosetta
table, one row per incarnation, each row = object, involution, certificate, credit, epistemic
status. Six is the paper's own number (six-arc, six totals, six depth profiles, six double
cosets). Gating: rows require certificates; the number bends to the evidence (five rows is fine;
a forced soft sixth row poisons the table).

Candidate rows and status: (1) design polarity — CHECKED, needs promotion; (2) QR perfect-code
outer symmetry — CHECKED + classical; (3) `mu_3` sign / low-degree threshold — PROVED;
(4) cocycle / advice complexity one — PROVED modulo definitions; (5) Frobenius / spin prime —
pending covariation test; (6) theta parity on the Roquette curve — pending test, genuinely open.

**Cliffhanger, three beats** (craft rules: withhold nothing cheap; never hang from an unclimbed
cliff — run the battery first, then calibrate):

1. *Mystery* — the verified, uninterpreted 5/6 coincidence and the Weil door (three sentences of
   data, no claim).
2. *Prophecy* — the proved splitting law applied blindly at rank 4: `31 ≡ 1 mod 5` splits in
   `Z[φ]`, predicting a chirality bit at the 600-cell phase that no current machinery can
   construct.
3. *Stakes* — the wall of impossibility theorems (codes stop at 11, odd Barker at 13, polytopes
   at 19); a q=13 phase must collect the last odd Barker sequence or the tower ends at 11.

Draft closing paragraph (journal register) recorded in conversation:

> Six involutions, one bit; six exact equalities, no common cause. The dimensions 5 and 6 that
> organize every incidence in this paper are also the dimensions of the two components of the Weil
> representation of SL_2(11), exchanged by the same involution, and the splitting law proved in
> Section N predicts — blindly, at q = 31 — a chirality this paper has no machinery to construct.
> We conjecture that the common cause is metaplectic, and that the six shadows above are the
> finite images of one theta-object. Proving this, and finding out what waits at 13, 19, and 31,
> is the subject of the sequel.

Mechanics: no "Part I" in the title (dangling-sequel risk); sequel promise lives in prose where it
can be softened; the Intelligencer companion may use the Galois's-last-letter echo the journal
version should not.

**Two-paper division.** Paper 1: the bit exists, is minimal, is measurable, wears six faces —
every claim certified — plus the conjecture. Paper 2: who owns the faces (metaplectic canonicity),
the mechanism (split torus / Serre–Kostant), the continuation (13/19/31, Barker falsifier).
Mutual protection: paper 1's referee cannot demand the roof; paper 2 inherits a certified
foundation and a pre-registered prediction; if the roof collapses, paper 1 stands and the sequel
becomes a refutation note.

## 12. Grades (v2, conditional on the battery landing) and venue strategy

| Dimension                  | v1  | v2  | Mover                                                            |
|:---------------------------|:---:|:---:|:------------------------------------------------------------------|
| Correctness / verification | A+  | A+  | Same standard; held by row gating                                  |
| Novelty                    | B+  | A−  | Verified six-fold agreement; spin-ring law; Weil module identity   |
| Technical depth            | B   | B+  | Real cross-field content; hard proof deferred to paper 2           |
| Significance               | B   | A−  | Program launch: precise conjecture, falsifiable predictions        |
| Story / memorability       | A−  | A   | Complete arc; ceiling for the dimension                            |
| Audience breadth           | B−  | B+  | Six communities with native entry points                           |

Overall: A as a specialist paper. Venue: one bounded shot a tier up (Advances in Mathematics or
IMRN, ~1/3 odds, choose by which landed theorem leads), JCTA as the reliable floor; do not spend
more than one round chasing the tier — the conjecture starts working only once public. Sensitivity:
theta-parity failure costs a row (story A→A−); Weil-decomposition failure costs the sharpest
conjecture clause (novelty→B+, venue→JCTA); covariation failure is the only serious wound (two
beats of the ending are load-bearing on it), and it is also the test the classical group theory
most strongly guarantees. Overclaim sensitivity is now maximal: one soft row discredits the table,
and the table is the paper.

## 13. Complete speculation register

| # | Item                                                            | Status      | Test cost  |
|:--|:----------------------------------------------------------------|:------------|:-----------|
| 1 | Matchings = Lagrangians in `J[2]` of `y^2 = x^q − x`             | REASONED    | hours      |
| 2 | Sheets = two `PSL` Lagrangian packings; Richelot kernels         | REASONED    | hours      |
| 3 | Roquette Jacobian supersingular                                  | SPECULATIVE | afternoon  |
| 4 | Chirality = theta/Arf parity of sheet packings                   | SPECULATIVE | a day      |
| 5 | Coxeter rotation ↦ split-torus generator (mechanism for q=h+1)   | REASONED    | hours      |
| 6 | `mu_3` vs Klein cubic threefold / Klein quartic                  | SPECULATIVE | days       |
| 7 | Relative-invariant dimension 3 uniformity has a reason           | SPECULATIVE | hours      |
| 8 | Shephard–Todd conic phases (ST25/26/27 → 13/19/31)               | SPECULATIVE | weeks      |
| 9 | Sheet = prime above q in spin ring; `mu_3`-sign covariation      | REASONED    | hours      |
| 10 | Quaternion-order reduction at the two primes = the two sheets   | REASONED    | a day      |
| 11 | Serre–Kostant p = h+1 frame; foldings D6→H3, E8→H4              | SPECULATIVE | weeks      |
| 12 | 57-cell's q=19 = E7's h+1 (Lie home for the polytope tower)     | SPECULATIVE | —          |
| 13 | C381 marked-E8 = folding trace of E8→H4                         | SPECULATIVE | days       |
| 14 | Marked-K12 (Coxeter–Todd) recovery theorem                      | SPECULATIVE | days       |
| 15 | Tri-prime (2,3,11) shadows of one global/integral object        | SPECULATIVE | open       |
| 16 | CM lift, Jacobi-sum counts, IKO superspecial context            | REASONED    | days       |
| 17 | Heegner 7/11/19; two supersingular j's first at 11              | DECORATION  | an hour    |
| 18 | Sheet reciprocity law (Frobenius = theta = `mu_3`)              | SPECULATIVE | after 4,9  |
| 19 | Exactly solved low-degree threshold framing                     | PROVED*     | writing    |
| 20 | Equivariant advice complexity exactly one                       | PROVED*     | writing    |
| 21 | 1-bit perfect hiding / access structure; Gács–Körner remark     | PROVED*     | writing    |
| 22 | Barker: QR designs at 7,11; Turyn–Storer wall; q=13 prediction  | CHECKED-cl. | hours      |
| 23 | AME chirality pair: LU separation degree or labeling collapse   | SPECULATIVE | days       |
| 24 | Covering-radius/list-decoding/isospectrality positioning        | framing     | writing    |
| 25 | Chentsov/Amari–Chentsov framing; KL of the bit                  | PROVED*     | hours      |
| 26 | Fold-over / resolution-III / minimum-aberration translation     | framing     | writing    |
| 27 | Singular-model cube-root rates for the label                    | SPECULATIVE | weeks      |
| 28 | Weil roof: cross-sheet module = 5/6 Weil components             | SPECULATIVE | a day      |
| 29 | C372 Fourier self-duality = Weil-operator fixed point           | SPECULATIVE | rereading  |
| 30 | Outer swap conjugates `sqrt 5` and `sqrt −11` simultaneously    | REASONED    | hours      |
| 31 | Dual-code involution (`comp-clebsch-dual`) as a seventh shadow: does the code's self-duality swap the sheets? | SPECULATIVE | hours      |
| 32 | Char-0 form of the sheets: two conjugate `A5`-invariant one-factorizations of the icosahedron over `Q(sqrt 5)` (strengthens M2) | SPECULATIVE | hours      |
| 33 | M1's reduction statement is likely Edge/Klein-classical; the integral model's novelty rests on the memory-spine identification | calibration | lit check  |
| 34 | Rank-2 floor: `I2(m)` conic phases (`H2` pentagon at q=11 inside the H3 story) | DECORATION  | hours      |

PROVED* = follows from committed certificates plus definitions/framing; still needs its bounded
literature audit before any "no prior instance" wording.

## 14. Discipline notes and known traps

- Every citation introduced above is from model memory; verify before use (the notebook already
  records one fast-model hallucination against Bamberg–Klawuhn). Citation negatives need three
  independent graphs.
- The manuscript decision belongs to the `clebsch` lane; nothing in this dossier edits or
  authorizes edits to the paper. Promotion of any item goes through C-ID allocation.
- The gateway spikes remain unpromoted notebook material with an exploratory script; paper-bound
  rows need evidence-bundle promotion.
- Terminology to fix at promotion: "chirality" disambiguation; dualities vs polarities;
  design-level 11-cell claims only.
