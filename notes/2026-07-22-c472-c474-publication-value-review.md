# C472--C474 publication-value review and unification gaps

**Lanes:** `clebsch` paper planning with read-only results from `crowns`

**Date:** 2026-07-22

**Scope:** rank every result landed after the C440--C471 ledger
(`2026-07-21-clebsch-weil-roof-results-ledger.md`) by publication value for Paper 1, Paper 2, a
new paper, or a note; measure the battery against the motivating "six shadows" dossier
(`2026-07-21-clebsch-weil-roof-conversation-report.md`); and record the unifying-theory gaps the
current evidence points at.  Inputs: the C472/C473 reports, all three C474 reports, the
C471--C474 downstream-implications memo, and the crowns archive through 2026-07-22.  This is a
planning review, not a novelty audit; every "if novel" clause below still requires its bounded
literature audit per `literature-audit-conventions.md` before external wording.

## What landed since the ledger

| ID / report | One-line result | Sign |
|:---|:---|:---|
| C472 (`c472-signed-weil-lift`) | Frozen signed preimage is split `C2 x PSL_2(11)`; carrier is `1_- + 5_epsilon,-`, not a genuine Weil six-space.  Positive replacement: full signed Mathieu action on the six-space is irreducible; both `M11` parents split and agree on the hinge yet glue to the globally nonsplit signed group, with an explicit length-eight central word | sharp negative + green structure theorem |
| C473 (`c473-arithmetic-orientation`) | Pointed sheet canonically selects one split prime of `Q(sqrt(-q))` via `alpha -> tr(T\|C)`; sheets = unipotent classes = period factors = split primes = lower Weil constituents as one free `C2` torsor; unpointed output is a canonical torsor isomorphism, provably no section | green |
| C474 main (`c474-uniform-ext-carrier`) | `Ext^1(S_q^*,S_q)` is one-dimensional in both frozen cases; the augmentation is the unique nonsplit carrier up to isomorphism; both simple cores are endotrivial with proved Sylow normal forms; one-scalar splitting detector; q=7 class invisible on involutions, bi-essential on both `V4`s; unpointed carrier moduli is the gerbe `B G_m`, so no scalar orientation descends | green, closed two-case theorem |
| C474 companion (`c474-modular-gateway-theory`) | Abstract seven-gate Modular Gateway Theorem: cross-code identities force a Lagrangian extension; Sylow-projective trace-zero endomorphisms force stable invertibility; fusion descent forces the one-line Ext; the carrier is a brick and the moduli gerbe forgets orientation.  Both frozen rows pass all gates | green, abstract criterion |
| C474 companion (`c474-reed-solomon-decorated-deep-holes`) | Over the four C398 classes: deletion-trace signatures recover exactly the `(9,6)` and `(11,12)` fixed-child fibres; the q=9 recovering fibre is two one-factorizations with cube relation graph `Q3` but fails the gateway (projective Sylow core); complete projective deep-hole orbit profiles for all four codes | green + decisive negative control |
| memo (`c471-c474-downstream-implications`) | Consequence map only; no independent claims | infrastructure |

## Ranked publication value

### Paper 2 (mechanism sequel) — the battery re-ranks its top

1. **New flagship spine: C465 + C471 + C474 + Modular Gateway Theorem.**  Before this battery,
   Paper 2's top rank was the C465/C471 sandwich-and-complex pair — an exceptional example with an
   operator mechanism.  C474 and the gateway companion convert it into a theorem-with-criterion:
   pointed matching sheet -> cross-incidence pair -> perfect code `D = <1> + S` -> simple
   endotrivial Lagrangian core -> unique nonsplit self-dual carrier, with seven checkable gates and
   cheap falsifiers.  That is the difference between "remarkable coincidence at q=11" and
   "mechanism that recognizes its own instances."  The perfect-code-as-intermediate-object reading
   (Hamming/Golay as `<1> + S` with `S` a stable Picard unit, the sheet augmentation as the unique
   cone on the doubled Picard class) is the single most publishable new idea of the day.
2. **C472's global-gluing theorem, grouped with the C465/C472 negative pair.**  The headline
   same-space/two-action genuine-Weil branch is dead, but the replacement is arguably the better
   theorem: every local piece of the `M11 <- PSL_2(11) -> M11` diagram splits compatibly, and
   nonsplitting is exclusively a global parent-gluing phenomenon whose central witness is an
   explicit short word.  This is a certified finite model of "the metaplectic phase lives in the
   change of polarization, not on a polarization stabilizer."  The open Maslov-holonomy comparison
   is now the sharpest surviving roof question; if it lands, it becomes the sequel's closing
   theorem rather than a pointer.
3. **C473 arithmetic orientation.**  Compact and load-bearing: chirality becomes the choice of a
   split prime, read from one modular character value, and the five-realization torsor identity is
   the certified lower-Weil form of the dossier's "sheet reciprocity law" (register items 9/18).
   It also supplies the exact structure-versus-property boundary (pointed input orients; unpointed
   output is a torsor) that Paper 2's descent chapter needs, and C474 proves the determinant
   cannot leak the orientation back.  Ranks with C459/C466 in the descent/mechanism block.
4. **C474's p-local gems as section-level material:** the bi-essential characterization of the
   global line at q=7 (nonzero on both `V4`s, zero on every involution), the depth split
   (inflation from `C4/C2` at q=7 versus Sylow `C3` detection at q=11), the nonsplit-but-metabolic
   Witt observation, and the one-element Jordan-rank recognition test.  These are the kind of
   exact small phenomena referees remember.

### Paper 1 — deliberately unchanged

Nothing in C472--C474 enlarges Paper 1's proof body, and that is the correct outcome of the
two-paper protection rule.  Three wording upgrades are available at drafting time:

- the Hadamard-degeneration ledger row may add half a sentence: the recovered carrier is the
  *unique* nonsplit self-dual extension of the lower-Weil core (C474);
- the cliffhanger's arithmetic beat may cite C473's trace rule as the certified form of
  "orientation is a residue-prime choice," replacing softer phrasing;
- the quantum/erasure boundary row may cite C472: even the full signed Hadamard symmetry supplies
  no genuine metaplectic action, strengthening C456/C467's erasure statement.

### New paper: decorated Reed--Solomon deep holes

The C474 RS companion is the strongest candidate for a separate manuscript and has already seeded
the `reed-solomon` lane (C475 sharpened, C476--C478 reserved).  Its assets: a complete four-class
theorem over a frozen domain, one genuinely new-looking positive (the q=9 cube fibre — decorated
recovery is *not* a q=11 monopoly), one decisive negative control (recovery without a Picard
carrier, so the modular gateway is not implied by combinatorial reversibility), and a concrete
program aimed at a named open problem (coefficient-atlas invariants for standard RS deep holes,
adjacent to Cheng--Murray and the co-NP-completeness boundary).  Audience is coding theory /
finite geometry; realistic venue tier is DCC/JCTA.  Its exportable slogan — classify the
decorated fibre, not the syndrome set — is independent of the Clebsch narrative and should not be
folded into Paper 2.

### Notes / retained infrastructure

The downstream-implications memo and the success-ladder table stay internal.  The type-theoretic
and categorical sections of the C474 main report (residual gerbe, groupoid cardinalities, linear
HoTT reading) are exposition-grade material for Paper 2's appendix at most; the finite
formalization target they identify (small-witness certificate compression) is a real Lean
candidate but owns no manuscript space.

## Scorecard against the motivating dossier

Of the conversation report's speculation register, this battery settles or transforms the
following (register numbers in parentheses):

- **Proved in transformed form:** sheet = prime above q with exact covariation (9), the sheet
  reciprocity law's lower-Weil case (18) — both delivered by C473, in `Q(sqrt(-q))` rather than
  the spin fields, which the mod-40 character separation (C466) explains.
- **Killed and replaced by something better:** the Weil roof as a literal module identification
  (28) — C450/C465/C472 close every linear route; the surviving object is the global signed
  gluing phase plus the Picard-graded carrier, i.e., the roof question is now metaplectic
  cocycle-level, exactly where the dossier's "changing ambient category" meta-observation pointed.
- **Upgraded beyond the register's ask:** the perfect-code rows (22 and the tri-prime frame 15)
  — the codes are no longer parallel decorations but literal sources of the stable core.
- **Still open, sharpened:** theta/Arf versus the bit (4) — reframed as the secondary
  formation/Maslov invariant on the nonsplit metabolic carrier; the H4/q=31 prophecy (8/11)
  untouched by this battery.

## Missing bigger connections — where a unifying theory would live

These are the review's candidate answers to "what are we not seeing," ordered by how much of the
existing evidence each would compress.  None is allocated work; promotion goes through the queue.

1. **One descent theorem behind all the local-split/global-nonsplit phenomena.**  The same shape
   now recurs at least four times: C472's parents split and agree yet glue nonsplit; C474's q=7
   class vanishes on every rank-one subgroup yet is bi-essential at rank two and survives fusion;
   C462's companion torsor is the nonsplit `C2 -> C4 -> C2`; C466's three characters coexist with
   no common carrier.  The natural common object is a class in the first higher limit over the
   orbit/fusion category (equivalently a gerbe on the gluing site), of which each incarnation is a
   restriction.  C474 has already computed the complete finite input (the full `D8` restriction
   profile) for the first orbit-category equalizer theorem.  This is the cheapest genuinely
   unifying target on the board.
2. **A quadratic/Maslov refinement as the actual Weil roof.**  Three independent doors now demand
   the same missing datum: C472's Schur cocycle needs a phase refinement of the Bockstein--Tor
   pairing; the nonsplit-but-metabolic carrier needs a formation/Maslov invariant to be seen by
   any duality theory; C473's orientation needs a secondary invariant to survive the unpointed
   quotient.  One construction supplying all three — a quadratic refinement on the C471 complex
   whose automorphism extension is nonsplit — would *be* the roof in its only surviving sense.
   Conversely, a proof that no such refinement exists would close the metaplectic program with a
   theorem instead of an erosion.
3. **A conductor-40 carrier for the three characters.**  C466 separates existence, fusion, and
   Weil phase into `(5/q)`, `(2/q)`, `(-1/q)` and proves no common carrier among the tested
   objects.  Nothing yet attempts the object one level up: a torsor or Galois module over the
   compositum `Q(sqrt5, sqrt2, i)` (conductor 40) whose three quadratic quotients specialize to
   the three laws.  The mod-40 law's density pattern `1/4, 1/4, 1/2` is exactly what such a
   module's Chebotarev statistics would produce; that is currently an unexplained fit.
4. **Geometric hypotheses forcing the Sylow normal forms.**  C474's stated Phase-3 boundary is
   the right question in the right generality: which self-dual permutation geometries have cores
   restricting to `Omega(F_p) + free` (cyclic Sylow) or a reflection-relative syzygy (dihedral
   Sylow)?  The reduced-orbit-fibre formulation makes this a classifiable finite-group question
   rather than a Gram numerology question, and gate (D) of the gateway report (a bounded scan for
   a third realization) is its first experiment.  A third hit makes Paper 2 a family paper; a
   proved exhaustion makes q=7/q=11 a two-object classification theorem — either is stronger than
   the current two examples.
5. **The recovery-versus-carrier logical square.**  The RS companion fills three cells: q=11 has
   decorated recovery and the carrier; q=9 has recovery without the carrier; generic classes have
   neither.  The fourth cell — a carrier without decorated recovery — is untested, and its status
   decides whether the modular gateway is strictly finer than combinatorial reversibility or the
   two properties are entangled.  One bounded search over the C398-adjacent domains would fill it.

## Reception estimate for the top items

- **Perfect-code-to-endotrivial-core theorem (if novel):** simple endotrivial modules for
  quasi-simple groups are rare and actively catalogued (the C474 report's own comparison points:
  Lassueur--Malle--Schulte; Carlson--Thevenaz school).  A construction that manufactures them
  from matching sheets and perfect codes, with a recognition criterion, would draw genuine
  attention in modular representation theory *and* give the design/code community a new invariant
  package.  The modules themselves are small and likely known as modules; the risk-adjusted claim
  is the construction path and criterion, not the objects.  This is the result most likely to
  raise Paper 2 above its current specialist tier.
- **Global signed gluing / metaplectic phase (C472):** as it stands, a strong section, not a
  headline; it becomes a headline only if the Maslov-holonomy comparison identifies the recorded
  central word with the standard cocycle.
- **C473 trace-prime orientation:** elegant, compact, certain to survive review; value is
  structural (it is the load-bearing pointing for everything downstream), not attention-drawing.
- **RS four-class theorem:** solid, self-contained coding-theory paper; modest but reliable
  reception, with upside concentrated in the coefficient-atlas program (C475--C478) rather than
  the classification itself.

## Addendum (ej pass): the gateway's own gates select the QR-code ladder

Reasoned from model memory during the closeout pass; every classical fact below needs
verification before allocation acts on it.  Not a claim of a third realization.

The Modular Gateway Theorem's numerical gates — odd degree `n = 2d+1`, `dim D = (n+1)/2`,
`D = <1> + S`, `S = D^perp` — are exactly the classical self-orthogonality flag of
quadratic-residue codes: augmented QR code over expurgated QR code.  The two proved rows are the
QR codes at `q=7` (binary) and `q=11` (ternary), with `S` the `(q-1)/2`-dimensional lower-Weil
constituent.  If the classical flag is as remembered, the QR ladder supplies an infinite stream of
candidates passing gates 1--2 for free, and the genuinely selective gates become 4--7 (Sylow
projectivity of trace-zero endomorphisms, simplicity, fusion).  The first two candidates are
striking:

- **`q=23` binary:** the binary Golay `[23,12,7]` over `PSL_2(23)`, with `dim S = 11` and Sylow
  2-subgroup dihedral of order 8 — the same `D8` mechanism class as the q=7 row.  The endotrivial
  dimension congruence `dim(S)^2 = 121 = 1 mod 8` passes.
- **`q=31` binary:** the `[31,16]` QR code, `dim S = 15`, Sylow 2-subgroup dihedral of order 32,
  `225 = 1 mod 32` passes — and 31 is the H4 prophecy prime, which would tie the gateway scan to
  the continuation program through a completely independent route.

This reframes gate (D) from "search for another self-dual design" to "walk the QR ladder and find
where the Sylow gate cuts."  A bounded scan (binary q=23 first) is the natural next allocation.

One structural observation falls out of the odd-degree constraint itself: the twelve-point
extended objects (order-12 Hadamard, `S(5,6,12)`, the signed `2.M12` geometry) are *outside* the
gateway, which lives entirely on the odd, punctured side.  The battery therefore splits cleanly
into an odd/unextended layer that owns the carrier theory (C465/C473/C474) and an even/extended
layer that owns the global phase (C470/C471/C472).  Paper 2's architecture can use that
separation literally.

## Successor gates already visible

- Phase-3 weil-roof synthesis is **not yet allocated**; the crowns handoff requires allocation
  before starting, and its go/no-go now has a materially stronger input than when the gate was
  written.
- The reed-solomon lane owns C475--C478.
- The unification candidates above are unallocated; items 1 and 5 are bounded, item 2 is the
  open-ended one the roof verdict depends on.
