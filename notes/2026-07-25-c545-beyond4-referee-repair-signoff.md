# C545 — local repair, proof repair, Lean closure, and blind referee signoff

**Lane:** `reed-solomon`  
**Date:** 2026-07-25  
**Status:** mathematical signoff complete; final aggregate rebuild and commit recorded in the handoff

## Request and review protocol

The requested order was:

1. repair local manuscript defects;
2. repair the all-level proof issues and their Lean boundary; and
3. give the resulting manuscript to a fresh agent with the prompt
   “Referee this.”

The referee received only the canonical manuscript and was told not to read
internal notes, ledgers, handoffs, earlier reviews, git history, or companion
papers.

## Local repairs

- The all-level status table now records that the covering-radius gate is
  automatic for \(q\geq Q_r\); exact modular membership, rather than radius,
  remains open there.
- The first common-factor dimension argument now separates the rank-one case
  \(\dim W_f=r-2\) from the rank-two case \(\dim W_f=r-3\).
- The introduction no longer calls the all-level induction conditional.
- “Irreducible-component exclusion” is qualified as a statement about reduced
  irreducible components, with no claim about embedded primary structure.

## Proof repairs

The first blind-referee pass returned **major revision**.  It accepted the
threshold arithmetic and Lean trust boundary, but found that fixed-factor and
collision strata were conflated with the recursively contained terminal
carrier.

The revision made the following distinctions explicit.

1. The reduced terminal carrier excludes the exact-linear-gcd stratum and
   ordinary collision points.  Exact linear gcd has its own quadratic-deck
   graph package; ordinary collision is a finite deletion divisor.
2. Proposition `prop:exact-bottom-ledger` gives the exact reduced bottom
   carrier ledger and ties it to the integral bridge, saturation, and vertical
   calculations.
3. Lemma `lem:old-marker-fixed-factor` proves that each old-marker
   fixed-factor scheme is proper and has degree at most three.
4. Lemma `lem:identically-colliding` reduces whole-line collision to the two
   explicit inseparable R5/R6 components.
5. Lemma `lem:exact-linear-gcd-transport` proves that an exact rational fixed
   factor persists through contractions away from that factor until the R5
   graph package is reached.
6. Proposition `prop:uniform-iterated-packages` now has separate branches and
   budgets:
   \[
   d_6\leq3r-5,\qquad d_j\leq3r-j-2,\qquad
   e_j\leq r-j+4,
   \]
   together with bottom deletions \(6r-17\) for the genus-one trivial-gcd
   package and \(2r-2\) for the exact-linear-gcd graph.
7. The proof explicitly maintains current-stage avoidance of
   \(\mathcal P_j\cup\mathcal M_j\); it does not lift membership of one chosen
   contraction backwards.

The R6 contained-component proposition was synchronized with the revised
terminal-carrier definition.

## Lean boundary

`RelativeConicArcs.PRSPolarInduction` now checks the finite recursive logical
descent through
`RecursiveContainedInput.bad_implies_persistent_or_modular`.

`RelativeConicArcs.PRSUniformCoveringRadius` now checks:

- the bottom genus-one deletion formula;
- the exact-linear-gcd graph deletion formula;
- the intermediate trivial-gcd and exact-linear-gcd flag budgets;
- domination of all parameter and deletion budgets by the uniform threshold;
  and
- simultaneous composition through
  `UniformIteratedPackageInput.packages_fit_uniform_threshold`.

Irreducible-component selection, catalecticant-rowspace closure, concrete
scheme properness and integrality, the exact geometric component
identifications, and the cited coding theorems remain explicit manuscript or
structure-field inputs.  The paper states this boundary.

## Final referee result

After the full repair, the same referee re-read the rebuilt candidate and
returned:

> **Final verdict: Accept.**
>
> Both last objections are closed.  
> Remaining release-blocking proof defects: none identified.

The signed-off canonical PDF has SHA-256
`35c2d30762be4fd25ccd35e410471bbec9e2d5746b4af82ed8f1a4e093a165ed`.

## Consensus discussion queue

The earlier two-reader consensus remains intentionally separate from these
correctness repairs.  The items to discuss next are:

1. exact split-free membership and orbit arithmetic inside higher Lucas
   carriers;
2. sharpening \(Q_r\), including quotient-cover, intersection-theoretic, or
   effective-Chebotarev approaches;
3. the unresolved R7 covering radii at \(q=7,8,9\);
4. a conceptual explanation of the decreasing last sporadic fields;
5. explicit Burnside formulas for \(T/T^{r-1}\) modulo inversion and
   Frobenius;
6. a proved recognition/decoding algorithm and complexity bound;
7. the modular-\(\mathrm{SL}_2\), rational apolar-rank, Prony, and Hurwitz-space
   connections; and
8. whether to elevate the stable count \(q(q+1)^2/2\), the marked-contraction
   coherence principle, and the R5 genus-one fiber square in the paper’s
   rhetoric.

