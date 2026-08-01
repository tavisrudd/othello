# C744 — Paper III proof-spine structuralization

**Lane:** `clebsch`

**Status:** complete; structural rewrite, independent A/B, EJ/EJ2, release,
and standalone synchronization green

## Result so far

The five paper claims now have a human-first causal spine.  Four previously
coordinate-shaped passages have structural replacements:

1. The descended two-branch singularity is the universal pinching ring
   (k+\mathfrak m\subset E[[x_1,\ldots,x_n]]).  Its normalization,
   conductor, and defect (E/k) follow functorially; the six-variable
   presentation is gone.
2. The normalized chart pullback is the elementary split pinching algebra
   (S[z]/(z^2-a^2)\subset S\times S).  Its normalization, conductor, etale
   locus, and branch meeting are read directly from congruence modulo (a).
3. The twenty six-arc determinants collapse to the determinant of a signed
   three-by-three equiangular Gram matrix.  The stored minors are regression
   data, not proof obligations.
4. The harmonic Gram matrix is forced by the two (A_5)-orbits on pairs of
   Petersen vertices and the Petersen spectrum.  The cubic uses one marked primitive
   point-stabilizer-fixed vector, and its large coefficient is split into the
   universal Wigner coupling and the marked Petersen restriction scalar.

The unused volume orientation and the choice of axis representatives have
been removed from the marked datum.  Representatives now occur only to write
a conference matrix; their switching class and triangle cubic are intrinsic.

The harmonic comparison also has a sharp structural boundary.  No
rotation-equivariant polynomial map (H_{\mathbb R}\to\mathcal H_6) can restrict to the nonzero
linear Petersen bridge: homogeneous scaling would force a degree-one
component, while
(operatorname{Hom}_{SO_3}(H_3,H_6)=0).  The marked (A_5)-intertwiner is
therefore the first level at which the required linear comparison can exist.

## A/B proof-spine gate

A blind subreview compared the committed pre-C744 proof spine with the
working structural rewrite on a 100-point rubric: rigor 30, structural
mechanism 25, degree-of-freedom closure 15, causal architecture 15, and
economy 15.  It selected the rewrite by (88) to (73).  The reviewer
identified nine bounded defects rather than a conceptual regression: missing
nonzero and finiteness hypotheses in the two pinching arguments; overbroad
polynomial-covariant and canonical-normalization wording; one notation
mismatch; one incomplete sentence; and three normalization sentences needing
sharper referents.  All nine were repaired.  Its two suggested upgrades were
also integrated: the quarter-turn conjugacy class now explains why the spinor
value is forced, and multiplicity one explicitly explains why (1960/27) is
a normalization scalar rather than an experimental coincidence.

The same reviewer then reran the blind comparison from scratch against the
repaired manuscript.  It again chose B, 96 to 73: rigor 29/30, structural
mechanism 24/25, degree-of-freedom closure 14/15, causal architecture 15/15,
and elegance/economy 14/15.  It found no mathematical gap or unexplained
constant in the rational proof spine.  Its last three editorial requests---to
name the actual line-bundle isomorphism, shorten the marked-representative
sentence, and call the six-arc calculation a Gram-determinant formula indexed
by triangle sign---have also been incorporated.

## Claim-to-proof ledger

| claim | human mechanism | computation disposition |
|---|---|---|
| `ARITH-1` | branch divisor plus (operatorname{Pic}(\mathbf P^6)=\mathbf Z) gives (cJ_0); the golden etale fibre fixes ([c]=[5]); trace splitting and the sextic branch force (mathcal O\oplus\mathcal O(-3)) | Hitchin's displayed normalization fixes the single chart scalar (16); no paper-local computation carries the scheme proof |
| `ARITH-2` | quadratic residue-field pinching gives the local normalization and conductor; one signed Gram determinant proves the six-arc; two reflections give spinor character ([2]) | the twenty minors, six-set transport, and mod-(11) calculation remain independent regression witnesses |
| `ORIENT-1` | split-quadratic pinching normalizes the chart pullback; tight-frame irreducibility gives (C^2=5I); pair balance gives augmentation descent; the marked ambiguity action isolates the genuine choices | scalar factorization and the golden exchanger remain minimal fibre normalizations; enumerated conference and pair-sum checks are audits |
| `HARM-1` | two pair orbits force the kernel matrix; the Petersen spectrum gives injectivity; two-transitivity and Schur's lemma give the unique marked (A_5)-intertwiner | the ten-axis matrix is retained only as an exact regression surface |
| `HARM-2` | the invariant cubic line reduces the proof to the point-stabilizer-fixed vector; the coefficient separates into the universal ((6,6,6)) Wigner coupling and one marked restriction scalar | one exact moment evaluation is the irreducible normalization leaf; the dense replay remains independent |

## Computation and certificate pressure ledger

| artifact output | former role | structural disposition |
|---|---|---|
| twenty golden three-point determinants | six-arc proof | superseded by the signed Gram determinant (4t^4) or (4t^2) |
| six golden-axis images under (R) | global sign comparison | retained as the smallest exact witness at the distinguished fibre; no global marking is inferred |
| conference square | finite matrix check | superseded by the irreducible tight-frame operator and its trace |
| twenty triangle signs and pair sums | augmentation and switching | superseded by triangle holonomy and pair balance; retained as regression data |
| ten-axis dot-product and kernel matrices | Petersen geometry and injectivity | reduced to one representative of each of the two pair orbits plus the Petersen spectrum |
| dense degree-eighteen spherical expansion | cubic restriction | reduced in the proof to one invariant-line normalization; retained as an independent exact replay |
| mod-(11) roots and nonsquare test | headline arithmetic mechanism | demoted to the explicit specialization of the uniform ([5])/([2]) character statement |

No generated certificate is load-bearing for a conceptual or scheme-theoretic
step.

## Degrees of freedom

| apparent choice | disposition |
|---|---|
| rational trivialization of (mathcal O(3)) | changes (J_0/s^2) by a square; the quadratic field is unchanged |
| square-class scalar (c) | fixed to ([5]) by the complete etale fibre at ([xyz]) |
| isomorphism (mathcal M\simeq\mathcal O(-3)) | absorbs the residual rational square; only (z\mapsto-z) remains |
| root (t) of (t^2-t-1) | choosing it selects one of the two Galois-conjugate charts |
| volume orientation | deleted; it affected no construction |
| projective-axis representatives | deleted from the datum; changing them is conference switching and fixes the triangle cubic |
| ordering of the six axes | genuine marking; coordinated relabelling is equivariant |
| five plane-triple and Petersen labels | genuine cross-marking; one-sided relabelling changes the datum |
| chart scale | fixed by (q_1=xyz) and (sum q_i=0) |
| odd-generator sign | exactly the normalized sheet/deck choice |
| pair-sum scalar | fixed by the primitive integral map and preservation of (sigma_3) |
| zonal and spherical scales | fixed by (P_6(1)=1) and probability-normalized spherical measure |
| harmonic cubic scalar | fixed on the unique point-stabilizer line |

## Magic-number ledger

| number | origin |
|---:|---|
| (5) | discriminant of (t^2-t-1), residue field of the nonsplit golden fibre, and square class of the two chart branches |
| (2) | spinor norm (Q(e_2)Q(e_2-e_3)) of the rational deck exchanger |
| (16) | ratio (J_0(xyz)/\sigma_3(y^\circ)^2) after the lift (q_1=xyz) is fixed |
| (25) | denominator introduced by the sum-zero representative (y^\circ=(4,-1,-1,-1,-1)/5) |
| (80) | the chart product (5\cdot16), before taking the square root |
| (4\sqrt5) | square root of the forced chart product (5\cdot16); its sign is the sheet choice |
| (3) | the general pair-incidence index (n-2) at (n=5), hence (|\beta(y)|^2=3|y|^2) |
| (13) | (dim\mathcal H_6=2\cdot6+1), the addition-theorem Gram divisor |
| (243=3^5) | common denominator of the two values of (P_6) at the normalized Petersen angles |
| (110,140,28) | the three Petersen spectral eigenvalues obtained from the two orbit values after clearing their common Gram denominator |
| (140/351) | pair-incidence factor (3) times the (V_4) spherical-Gram eigenvalue (140/1053) |
| (400/46189) | universal Wigner square (\bigl(\begin{smallmatrix}6&6&6\\0&0&0\end{smallmatrix}\bigr)^2), with (46189=11\cdot13\cdot17\cdot19) |
| (1960/27) | the marked Petersen restriction scalar fixed by the primitive point-stabilizer one-vector normalization |
| (3553,4563) | the reduced factors (46189/13) and (27\cdot13^2) appearing when the standard Gaunt normalization is converted to the paper's spherical normalization |
| (-784000/1247103) | product (-(400/46189)(1960/27)); no new arithmetic prime occurs |

The characteristic boundaries are likewise separated: (2) controls
quadratic splitting and the six-arc determinant, (5) is the discriminant
and isotropic degeneration of the golden metric, and (3) is needed for the
primitive Petersen inverse and for the available integral binary-sextic
presentation.  Prime (11) in the Gaunt denominator is angular-momentum
normalization, not bad reduction of the golden cover.

## Exact remaining boundary

The abstract double-cover algebra has exact bad primes (2,5), but the
geometric incidence comparison is still known only over an unspecified
(mathbf Z[1/N]).  This is no longer an undifferentiated mystery.  The
missing theorem must:

1. choose an integral harmonic lattice and integral three-skew-form
   Grassmannian zero locus;
2. identify it with an integral Mukai--Umemura model;
3. prove flatness and normality; and
4. prove that Stein formation and the chart sections commute with the needed
   base changes.

The available (mathbf Z[1/30]) operator/polar result from C682 does not by
itself prove these four Paper III statements.  Extra divisors of (N) are
therefore an exact evidence gap, not unexplained primes predicted by
(z^2=5J_0).  This boundary will remain explicit unless the integral
comparison is proved during the closeout pass.

## Frozen C745 interface so far

C745 should formalize the two pinching lemmas, branch-to-line-bundle argument,
golden quadratic torsor, tight-frame conference identity, signed Gram
determinant, marked ambiguity action, Petersen two-orbit kernel calculation,
and invariant-line/one-vector harmonic normalization.  The integral incidence
comparison is a separate foundational interface and must not be represented by
the scalar equation alone.

## Extra-juice and Tao closeout

The extra-juice pass separated the characteristic-five metric degeneration
from the characteristic-two six-arc argument, removed unused volume and
representative choices, isolated the Wigner denominator from the arithmetic
cover, and replaced both local coordinate presentations by quadratic
pinching.  The Tao pass then compressed the remaining computations to their
invariants: the ambient polynomial covariant is ruled out by representation
theory, the classes [5] and [2] are the two characters of one equivariant
quadratic datum, every displayed scalar is forced by a stated normalization,
and the surviving certificates are regression audits rather than proof steps.

## Mystery ledger

| former mystery | disposition |
|---|---|
| descended normalization and conductor | the universal ring (k+\mathfrak m\subset E[[x_1,\ldots,x_n]]) |
| normalization of the chart pullback | split quadratic pinching and congruence modulo the branch parameter |
| twenty six-arc minors | one Gram-determinant formula indexed by triangle sign |
| conference square and triangle sums | irreducible tight frame, triangle holonomy, and pair balance |
| the two square classes [5] and [2] | discriminant/deck and spinor characters of the same marked quadratic datum |
| existence of an ambient polynomial bridge | impossible: its degree-one part would lie in (\operatorname{Hom}_{SO_3}(H_3,H_6)=0) |
| harmonic cubic coefficient | multiplicity one, one marked fixed vector, universal Wigner coupling, and one restriction scalar |
| exact geometric bad primes | open only at the explicit four-step integral-model comparison above |

There is no remaining unexplained numerical coincidence or loose degree of
freedom in the claimed rational proof spine.  The sole open item is a
geometric integral-model theorem, not a hidden computation in the present
argument.

## Validation and synchronization

- Fresh blind A/B rerun: B chosen 96 to 73; no rational mathematical gap or
  unexplained constant.
- Authoritative aggregate: `clebsch-passages release: ALL CHECKS PASS`, with
  warning-free manuscript build.
- Deterministic export planner/auditor/materializer: green after refreshing
  the stale standalone README rewrite count from 8 to 11.
- Standalone aggregate: `clebsch-passages release: ALL CHECKS PASS`, with
  warning-free manuscript build.
- Authoritative proof commit: `1975ed42`.
- Export-guard refresh commit: `1634301a`.
- Standalone forward synchronization commit: `b85e20d`.
