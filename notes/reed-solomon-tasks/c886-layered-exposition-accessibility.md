# C886: Layered exposition and accessibility for PRS Version 2

**Lane**: `reed-solomon`

**Status:** queued.

## Goal

Preserve the paper's specialist precision and full proof/audit layer while giving a mathematically
mature reader outside PRS and deep-hole theory a complete conceptual route through the results.
The target is layered exposition, not uniform simplification: a first-pass reader should understand
the problem, mechanism, logical dependencies, exceptional-characteristic phenomena, and scope
without following every component calculation, divisor budget, or certificate replay.

## Cold-read diagnosis

The paper is substantially stronger for PRS and finite-geometry specialists than for general
mathematical researchers.  The sentence-level writing is not the main defect.  The architectural
problem is that the coding problem, geometric mechanism, and verification machinery initially
receive nearly equal visual weight, while the reader must acquire too many specialist languages
before seeing the single conceptual progression

```text
syndrome -> splitting system -> R5 fibre square -> marked contraction
         -> contained/transverse dichotomy -> Lucas carrier.
```

The paper already contains the needed ingredients.  In particular, Example V.3 and Figure 1 show
the recursive proof in miniature, but the manuscript does not yet tell a first-pass reader to use
them that way.

## Required edits

1. Add a compact conceptual overview before the Reading Map.  It must give the complete first-pass
   route from a syndrome `f` to `W_f`, the R5 cubic pencil/map/fibre square, contraction at a marker,
   lifting of lower split witnesses, and the contained-versus-transverse dichotomy.  Explain that
   carrier classification handles the contained branch and point counting handles the transverse
   branch.
2. Present R5 explicitly as the model for the whole paper.  After its exact fibre-square count and
   existence consequences, state that later levels repeat the same pattern after contraction:
   reduce to a lower-degree splitting problem, classify degeneration loci, and count rational
   points away from them.
3. Visually separate the two logical layers of the main recursive result in Theorem I.1 and at the
   opening of Section VI:
   - unconditional geometric theorem: the reduced recursively contained locus;
   - conditional finite-field consequence: containment of every split-free point when the lower
     packages and field-size threshold hold.
4. Add sparse first-pass navigation at the densest load-bearing arguments, especially the
   component decomposition around Proposition VI.1, without moving, abbreviating, or weakening
   the specialist proofs.  A reader who skips a marked calculation must still know its input,
   output, and role in the argument.
5. Add one results-and-mechanisms table for R5--R10.  Each row must expose the new obstruction, main
   geometric object, and structural source of the threshold; it must make clear which levels reuse
   the R5 terminal geometry and where genuinely new modular/Lucas phenomena enter.

## Density constraints

- Do not add textbook explanations of finite fields, projective space, or standard monodromy.
- Do not duplicate theorem statements or proof summaries across the overview, Reading Map, and
  section openings.  Each layer gets one job: conceptual story, navigation/dependencies, or exact
  mathematics.
- Prefer replacing locally repetitive orientation prose over simply increasing page count.
- Keep notation out of the overview unless it persists through the paper or is essential to the
  conceptual route.  Define `Y_f`, `N_f`, `d_2`, and `d_3` where the R5 model makes them meaningful,
  not as an undifferentiated abstract-level list.
- Keep certificate paths, divisor budgets, elimination identities, and characteristic-by-
  characteristic calculations in the specialist layer.

## Acceptance gates

- A fresh general-mathematics cold reader can accurately state: the coding question; why binary
  forms and splitting appear; why R5 is the terminal model; what contraction and witness lifting
  do; what contained/transverse means; why Lucas carriers occur; which recursive statement is
  unconditional; and which finite-field consequences require packages and thresholds.
- A fresh PRS/finite-geometry specialist finds no lost hypothesis, softened scope boundary,
  misleading analogy, or newly obscured proof dependency.
- The conceptual overview, Reading Map, results table, and section signposts contain no material
  repetition under a paragraph-level density audit.
- Example V.3 and Figure 1 are explicitly identified as the recursive mechanism in miniature.
- The specialist manuscript, TIT build, label/evidence verifier, and existing release replay remain
  green after the prose changes.
- Record before/after specialist and generalist exposition assessments separately; success does not
  require equal scores for intrinsically different audiences.

## Non-goals

- No theorem, scope, certificate, Lean boundary, or release-gate change.
- No attempt to make the paper introductory or undergraduate-accessible.
- No deletion of technical material merely because it is expensive on a first pass.
