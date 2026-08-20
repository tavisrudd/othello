# C934 initial referee synthesis

**Date:** 2026-08-20

## 1. Frozen review surface

This synthesis concerns only the 11-page frozen paper at authority commit
`53e19feff1f66e7b4b453a38fcc0f239ece007d6`, with PDF SHA-256
`108983c8420086abb85889c4d3eff32e1c40fc281e28d6599feacd03d21ddc6e`.
It does not assess any later manuscript state.

The three independent packet reports are frozen by content as follows:

| Packet | Scope | Report SHA-256 | Verdict |
|---|---|---|---|
| A | modular and perverse-sheaf claims, (19)--(23) | `c26720d36ee0b924932e940c45014889f185d4655d631be67c0811b9075d6ff1` | B |
| E | editorial, priority, abstract, rendering, venue | `e517e49b8d907c5021145e72b12fde36bafbb476d2aee121230cd160d8c9f4d3` | B |
| G | cubic geometry and global attachment, (24)--(26) | `19bee5877ea86e21f3c9857a2de9b294e344f76a372fe41dbcb9f14c834c1397` | A |

## 2. Consensus verdict

**B -- minor revision.** No packet finds a false theorem, failed proof
mechanism, coefficient error, or required change of scope. Packet A reconstructs
the integral outer splitting, central Smith factor three, and characteristic-
three attachment; Packet G reconstructs the degree-four Fano lift, exact
index-three attachment, and ordinary-to-intersection-cohomology comparison;
Packet E finds the title, abstract, two-prime synthesis, and rendering sound.

The B verdict is caused by two local repair packages: one missing
coefficient-change proof bridge and one incomplete attribution boundary. Both
can be repaired without changing a theorem.

## 3. Mandatory repairs

### R1. Make derived reduction and the integral no-point-summand argument explicit

**Location:** Section 7, after the integral stalk/costalk list and around
equations (22)--(23).

State that all displayed stalk and costalk groups of the residual integral
object `P` are free. Consequently derived tensoring with `F_3` preserves their
degrees and hence the two-stratum perverse support/cosupport bounds. The same
freeness rules out a torsion point-supported direct summand integrally; the
Smith-factor-three argument then excludes the remaining free central point
summand.

This closes the only proof-exposition gap identified by Packet A. Derived
reduction is not t-exact for arbitrary integral perverse sheaves, so the
freeness inference must be printed rather than left implicit.

### R2. Complete the general-framework attribution

**Locations:** the introduction's prior-art paragraph, Section 7 near the
intersection-form/indecomposability discussion, and the bibliography.

1. Cite de Cataldo--Migliorini for the rational intersection-form mechanism
   for resolutions, including isolated fourfold singularities. State that
   their checked framework uses rational coefficients and does not compute the
   cubic-theta integral blocks.
2. Cite Cipriani for the general field-coefficient framework of small
   extensions over a closed stratum and the indecomposability criterion via
   the canonical extension-pair map. State that the present paper supplies the
   example-specific matrices, dimensions 11, link/Bockstein data, and Fano
   realization.

Cipriani is independently required by both Packets A and E. Packet E also
requires the de Cataldo--Migliorini boundary. One compact introduction sentence,
one local Section 7 sentence, and the two bibliography entries suffice; the
elementary cubic-theta proof should remain.

## 4. Findings not requiring repair

- The shifts in (19), the blocks `[-1],[-3],[-1]` in (20), the two simultaneous
  outer splittings, and the residual integral perversity are correct.
- The characteristic-three link dimensions are both 11, the middle map in (23)
  is zero, and the residual perverse sheaf is indecomposable and nonsemisimple.
- The degree-four Fano input has multiplicity and degree one on the relevant
  fibre: `e^*u_4=ell` and `b_*u_4=[F]=theta^[3]` with no degree-six or excess
  factor.
- The order-three link class is the boundary of an infinite-order global class;
  (25) is an exact index-three attachment, not a global-torsion assertion.
- The constant-to-IC triangle and integral endpoint surjectivity prove (26)
  also at `k=4`.
- The degree-three mod-two theorem is unchanged; extending Lemma 4.1 to all
  degrees introduces no regression.

Two wording changes are optional only: say “the zero middle map in (23) has
nonzero kernel and cokernel,” and replace “This class has infinite order” after
(24) by “The class `u_4|_U` has infinite order.” Neither affects the verdict.

## 5. Title, abstract, synthesis, and rendering

**Title: pass.** *Integral Cohomology and Modular Decomposition for the Theta
Divisor of a Cubic Threefold* accurately names the rank-130 integral lattice,
the higher-degree index-three comparison, and the modular direct-image theorem.
It does not advertise a general decomposition theorem.

**Abstract: pass.** The conservative PDF-extraction count is **180 tokens**, so
the abstract is below 250 words. It states both the global mod-two fibre-product
defect and the local central map `Z --3--> Z`, distinguishes rational, integral,
and characteristic-three behavior, and does not overstate the result.

**Two-prime synthesis: pass.** The mod-two phenomenon is the global
Gysin/restriction lattice and its dual; the mod-three phenomenon is the local
central intersection block and modular perverse extension. Equations (24)--(26)
show why the local `Z/3` is an index-three attachment rather than global
torsion. The contrast is theorem-backed rather than rhetorical.

**Rendering: pass.** Packet E inspected all 11 pages and reports equations
(1)--(26), references, diagram, disclosure, bibliography, and page breaks clean.
Packet G separately reports the new equations and triangles clean on page 10.

## 6. Priority boundary after repair

The correct division is:

- Krämer owns the complex/rational three-point-summand decomposition;
- de Cataldo--Migliorini own the rational intersection-form mechanism;
- Juteau--Mautner--Williamson own the field-coefficient rank and point-summand
  criterion;
- Cipriani owns the general categorical classification of small and
  indecomposable closed-stratum extensions;
- Faulkner Valiente--Miller Eismeier own the abstract mod-two Smith factors and
  saturation quotient.

The paper retains the simultaneous cubic-theta package: explicit integral
blocks and outer splitting, the central Smith factor three, the concrete
characteristic-three extension, the Fano realization of the order-three link
boundary, and the pre-existing paper's Fano-labelled mod-two lattice glue. No
packet found an unqualified firstness claim.

## 7. Venue consensus

### Mathematische Zeitschrift

**Consensus recommendation after repair; strongest target.** All three packets
are favorable, and A and E independently identify MZ as the best fit. The paper
is a complete specialist result spanning algebraic geometry, resolution
topology, and modular perverse sheaves, with an example-specific scope well
matched to the journal.

### Algebraic Geometry

**Credible stretch, not the consensus first target.** Packet G is favorable on
the geometric contribution; A calls it plausible; E regards it as a credible
but higher-risk stretch. The rational and general categorical mechanisms are
prior, so the editorial question is whether one distinguished integral/modular
example clears the venue's breadth threshold. Correctness is not the issue.

### Proceedings of the American Mathematical Society

**Safe fallback after repair, but no longer the best fit.** A and E recommend
it as a conservative fallback, subject to the final journal-format page count;
G finds it mathematically acceptable but says the expanded theorem package now
belongs more naturally at a specialist venue.

## 8. Focused repair and rerun plan

1. Apply R1 and R2 locally. If desired, include the two optional clarity edits
   in the same pass; do not alter theorem statements or proof mechanisms.
2. Rebuild from source, run the warning/reference gate, recount the abstract,
   visually inspect the changed Section 7 and bibliography pages, and freeze a
   new authority commit and PDF SHA-256.
3. **Packet A rerun:** on the new frozen PDF, verify the printed freeness
   inference, preservation of perverse bounds under derived reduction,
   exclusion of torsion and free point summands, and the exact Cipriani
   boundary. Reconfirm (22)--(23) did not change.
4. **Packet E rerun:** verify the de Cataldo--Migliorini and Cipriani citations
   against the sources, ensure the priority prose remains example-specific,
   rerun the `<250` abstract and full rendering gates, and confirm the venue
   recommendation.
5. **Packet G regression check:** because Section 7 will change near (23)--(24),
   verify that (24)--(26), the identity of the infinite-order class, and the
   page-10 layout are unchanged. A full re-referee is unnecessary unless those
   equations or their proof paragraphs move materially.
6. Synthesize only the reports on the new PDF hash. Submission remains blocked
   until both initial B findings return A on that new authority.

## 9. Closeout and mystery ledger

The `ej`+`tt` closeout leaves no mathematical mystery on the frozen theorem
surface. Packet A identifies the extra characteristic-three class as the
Tor/Bockstein companion of the integral order-three link class; Packet G shows
that the same local class is globally an index-three boundary of an
infinite-order Fano class. The two-prime package is therefore conceptually
coherent.

The only open items are the two explicit minor-revision packages above and the
editorial uncertainty between MZ and the AG stretch. The repair owner is C934;
the venue uncertainty is not an evidence gap and should not prompt theorem
expansion before the focused rerun.

## 10. Submission status

**Not yet submission-ready.** The mathematics receives A-level support, but the
paper must print the coefficient-change bridge and complete the two-source
priority boundary. After those local changes pass the focused A/E reruns and G
regression check on a new PDF hash, the expected final recommendation is A with
Mathematische Zeitschrift as the strongest target.
