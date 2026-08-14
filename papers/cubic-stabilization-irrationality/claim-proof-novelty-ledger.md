# Claim--proof--novelty ledger

Date: 2026-08-14

This ledger governs the public claim surface of the manuscript. It is not
exported to the standalone paper repository. The audit is a
source-characterization audit, not an exhaustive priority search. The paper
makes no negative novelty claim.

| Stable id | Public claim | Status | Proof or evidence | Source boundary |
|---|---|---|---|---|
| `def:point-row` | The point in the second Gamma-pairing slot reads ordinary rank. | imported | Iritani Gamma framing and Euler pairing; elementary `chi(E,O_p)=rank(E)` | `IritaniGamma`, Section 1 |
| `thm:simple-wall-point-column` | For a simple wall oriented by `r_+<r_-`, the ambient coordinate of the common-open point is exactly the target point at the Gu--Yu--Yu extremal specialization. | unconditional | Common-point lift from Lemma 3.27; Lemma 5.10 on `a_p` and `lambda a_p`; specialized completed-source injectivity; Fourier covariance; minimal-coefficient recursion | Does not assert that centre coordinates vanish; does not identify the intrinsic large-radius Gamma frame |
| `hyp:one-wall-sectorial` | A common pairing-preserving sectorial realization identifies the formal ambient and wall summands with the stated Gamma spans. | explicit hypothesis | Not proved in the paper | Not a corollary of the formal Gu--Yu--Yu theorem or extremal Shen--Shoemaker asymptotics alone |
| `cor:simple-wall-rank` | In one receiver, the primitive-sixth rank Boolean is preserved across a simple wall. | conditional | Exact ambient point column plus supported Euler orthogonality under `hyp:one-wall-sectorial` | Wall-local only; no adjacent-receiver coherence |
| `thm:ordinary-flop-point-row` | The intrinsic point section is preserved on one fixed ordinary-flop continuation domain. | unconditional | Pure-extremal support vanishing and transverse divisor recursion | One column only; no full descendant or Gamma/Fourier--Mukai theorem |
| `cor:ordinary-flop-packet` | The point-row Boolean is preserved on a graph-gauge transported formal packet. | unconditional and path-local | Flop point-row theorem plus graph-gauge preservation of connection, grading, Chern class, and pairing | No phase-independence statement outside the fixed domain |
| `prop:incomplete-gamma` | Formal monodromy, pairing, integrality, and a length-three nilpotent tag do not determine the point row. | unconditional abstract no-go | Explicit incomplete-Gamma flat columns, continuation shear, hyperbolic double, and tensor tag | Not a smooth-projective quantum counterexample |
| `prop:punctual-corner` | A module killed by either Fourier localization can have full-support inverse transform. | unconditional algebraic no-go | Weyl-algebra Fourier transform exchanges `O_A2` and `delta_00` | Up to conventional signs and cohomological shift |
| `hyp:rank-zero-target` | Every complete ray-ordered correction has point-row-zero output target. | explicit hypothesis | Not proved in the paper | Boundary-supported targets are one sufficient geometric source; bare Fourier support and one global signed coefficient do not imply the condition |
| `thm:rank-zero-target` | The rank-zero-target condition is sufficient for point-row invariance through a finite factorization. | unconditional implication from named hypothesis | One-line covector calculation and induction | No general factorization consequence without the hypothesis |
| `eq:blockwise-boundary-marking` | A blockwise identity between the point row of a ray target and a marked punctual coefficient would reduce the remaining problem to singular data. | open comparison, not a theorem | The semantically labeled displayed identity in Section 7 | The global alternating coefficient can vanish by cancellation and is not sufficient |
| `def:gauged-admissible` | Packages the stability, proper-DM master-stack, perfect-obstruction-theory, numerical-separation, and orbit-cylinder assumptions used by the global gauged argument. | explicit geometric assumptions | Definition only | Włodarczyk supplies the smooth completion and orbit cylinder, not every gauged-theory condition in this package |
| `lem:point-insertion-row` | The normalized cohomological point insertion equals the Gamma point row after the localized graph fundamental solution. | unconditional within the gauged-admissible scope | Gamma framing of the top class and fundamental-solution unitarity | Separates ordinary Kirwan restriction of the point lift from the quantum Kirwan derivative |
| `prop:support-collapse` | Degreewise, the point-marked virtual Kalkman formula has no intermediate contribution; in any common realization the endpoint rows agree. | conditional on gauged-admissibility | Global orbit-cylinder class; commuting graph rotation; full equivariant divisor-character extraction; wall-fixed support vanishing; `lem:point-insertion-row` | Does not construct the common realization required by the conditional theorem |
| `prop:gamma-ratio-reduction` | Every individual neutral fixed-graph coefficient has balanced Gamma-ratio form, while nonneutral homogeneous coefficients are Laurent-finite. | unconditional | Woodward exhaustive fixed loci and virtual-normal splitting; whole-integer Gamma continuation of each moving index; adjacent-ratio bubble factors; exact oriented residues | Does not construct a common contour for the complete nonlinear graph sum |
| `thm:tailwise-derived` | Along each affine clutching tail, degree shifts identify the fixed derived clutching stacks, universal domains, evaluation maps, fixed parts of the relative perfect obstruction theories, virtual classes, stack automorphisms, and inertia gluing. | unconditional within the standing proper-DM/POT scope | Derived intersection of the two attracting strata; invariant Cech complex; fixed ordinary stable-map factors | The universal gauged maps vary with affine degree; their invariant deformation complexes are constant only between thresholds |
| `prop:clutching-tail-holonomicity` | Every complete neutral clutching tail is a finite nilpotent derivative of an affine Gamma recurrence, hence holonomic with tempered growth after exponential rescaling. | unconditional within the standing scope | Woodward clutching factorization and normal-complex splitting; `thm:tailwise-derived`; Gamma recurrence; neutral Stirling cancellation | Does not identify the finite threshold maps |
| `hyp:marked-threshold` | At every Artin level, ordinary degree, neutral direction, and threshold, one marked local Fourier object induces a strict comparison of the cyclic Rees z-modules which intertwines formal monodromy and carries the Gamma point row. Zero-mode thresholds use row-generated reduced nearby cycles, defined by quotienting by the stable variation image, and require strict specialization isomorphisms from the complete adjacent row-generated cyclic modules. All maps respect Stokes/deck, Artin, derivative, and Rees data. | explicit inverse-system one-object comparison assumptions | Not proved in the paper | A Gamma/window construction compatible with all these structures would supply the required one-object comparisons; the available linear abelian GLSM theorem does not prove them for nonlinear virtual fixed graphs |
| `lem:finite-threshold-gluing` | At a finite Artin level, the marked threshold maps glue the finitely many tail germs and preserve every primary Boolean. | formal implication from `hyp:marked-threshold` | Finite ordered composition, strict zero-mode specialization isomorphisms, and polynomial primary projectors | Does not construct a threshold map |
| `lem:cyclic-row-support` | The generalized-eigenvalue support detected by a covector is exactly the primary support of its dual cyclic module. | unconditional linear algebra | Primary decomposition of the cyclic row module | Does not construct the marked continuation |
| `thm:birational-point-primary` | Nonvanishing of the point row on a formal-monodromy primary packet is invariant under smooth projective birational equivalence. | conditional | Gauged-admissible completion; support collapse; `thm:tailwise-derived`; clutching-tail holonomicity; `hyp:marked-threshold`; finite threshold gluing; Rees half-Tate shift; cyclic-row spectral support | A one-row Boolean implication under the stated geometric assumptions and inverse-system marked-threshold family |
| `prop:cubic-endpoint` | The cubic Gamma point row is nonzero on both primitive-sixth lines. | unconditional endpoint lemma | Cai matrices reconstructed through the exact indicial polynomial; direct hypergeometric Barnes coefficients | Cai is used only for the cubic connection and big/small flatness; point coefficient is proved independently |
| `thm:intro-cubic-conditional` | For every smooth complex cubic threefold `X`, `X × P^m` is irrational for every `m ≥ 0` if every relevant birational map admits a gauged-admissible completion satisfying marked threshold compatibility. | conditional application | Cubic endpoint lemma; quantum Künneth; uniform projective-space exponent calculation; conditional birational point-primary invariance | The endpoint contrast is unconditional; `m=2` and higher remain conditional here |

## Novelty language

The manuscript uses direct proof verbs: “we prove,” “we isolate,” and “we
formulate.” It does not use “first,” “new,” “novel,” “previously unknown,” or
“to our knowledge” as priority claims.

The closest source-level relationship is stated positively:

- Gu--Yu--Yu supply the formal pairing-preserving comparison and Fourier maps;
- Shen--Shoemaker supply the extremal Gamma asymptotic blocks;
- Lee--Lin--Qu--Wang supply ordinary-flop continuation;
- Woodward and Gonzalez--Woodward supply the global gauged fixed-locus and
  virtual Kalkman formulas;
- Aleshkin--Liu supply the balanced linear Mellin--Barnes model; nonlinear
  marked threshold compatibility remains an explicit hypothesis;
- Cai supplies the cubic connection matrices and big/small flatness, while
  the point coefficient is recomputed in the manuscript;
- Reichelt--Schulze--Sevenheck--Walther identify the localized
  Fourier--Laplace kernel used in the methodological boundary.

Any later priority sentence requires a new literature audit and a new ledger
row before entering the manuscript, README, metadata, or portfolio summary.
