# Paper III current-theorem Lean formalization

## Result

The Paper III companion now has a paper-specific structural surface.  Its
public gate is `RelativeConicArcs.Gates.ClebschPassages`; it imports no
middle-exterior or later Golden-paper module.  The surface formalizes the
algebraic mechanisms used by the polished proof spine and keeps the
geometric identifications that are not yet in Lean outside the trust claim.

## Five-row correspondence

| Paper row | Formal structural content | Exact remaining boundary | Coverage |
|---|---|---|---|
| `ARITH-1` | Residue-field pinching, conductor equals residue kernel, rank-two presentation, involutive even/odd splitting, and odd-square multiplication law | Hitchin incidence variety, global Stein algebra on projective space, branch divisor and the geometric Clebsch-chart identification | partial mechanism; no full row claim |
| `ARITH-2` | Golden discriminant `[5]`, conjugation, signed-Gram determinant formula, reflection factorization of the exchanger with derived norm product `[2]`, and the nonsquare check in `F_11` | Identification of the complete Hitchin fibre with the displayed golden realization and a general quadratic-space spinor-norm API | partial mechanism; no full row claim |
| `ORIENT-1` | Split quadratic pinching, its integral product normalization interface, exact conductor, split étale-open behavior, tight-frame conference mechanism, switching invariance, marked relative deck signs, and explicit chart scaling | Scheme normalization of the pulled-back incidence cover, extension across the branch, and the geometric theorem connecting the marked datum to Hitchin's chart | partial mechanism; no full row claim |
| `HARM-1` | General Petersen pair-sum eigenspace, dimension four, two-orbit Legendre kernel, normalized Gram scalar, and forced norm factor three | Face-axis geometry, addition theorem realizing the kernel in `H_6`, and the abstract `A_5` uniqueness comparison | partial mechanism; no full row claim |
| `HARM-2` | Marked fixed line, normalized `sigma_3` values, one-value coefficient uniqueness, exact Gaunt factorization, and denominator reductions | Invariant theory placing the spherical cubic on that line and the raw spherical/Wigner moment itself | partial mechanism; no full row claim |

The correspondence module deliberately phrases each result as “once the
paper's geometric datum is identified with this model, the downstream
coefficient is forced.”  It does not turn that identification into an
implicit axiom or a misleading theorem name.

## Structural modules

- `QuadraticPinching`: inverse-image definition, intrinsic conductor,
  conductor/kernel equality, quotient-residue relation, and the
  presentation-free identity `A = R + R alpha`.
- `SplitQuadraticPinching`: congruence definition, split evaluation,
  conductor `(a) x (a)`, integral ambient product, diagonal special fibre,
  and full splitting when `a` is a unit.
- `InvolutiveOddUnit`: invariant/anti-invariant projections, odd-square
  branch law, unique `a + c b` decomposition, and the localized interface.
- `TightFrameConference`: the conference square follows from the scalar
  frame operator and the Gram equation.
- `SignedEquiangularGram`: one triangle-sign determinant formula replaces
  twenty separate minors.
- `GoldenQuadraticCharacters`: the golden root is a square root of five;
  the exchanger is proved to be a product of standard reflections with
  norms one and two, before the finite-field nonsquare leaf is checked.
- `MarkedClebschBridge`: all labelings and the normalized lift are explicit
  fields; switching, deck sign, pair-sum sign, and chart scale are relative
  covariance statements.  No sheet is said to reconstruct a marking.
- `PetersenHarmonicKernel`: the ten-by-ten kernel is replaced by its two
  pair orbits and the symbolic `-2` Petersen eigenspace.
- `ClebschInvariantCubic`: the stabilizer-fixed line and a single marked
  value determine the coefficient; universal Wigner and Petersen factors
  remain separately named.
- `ClebschPassagesCorrespondence`: the branch coefficient `80`, the chart
  value `(16/25)^2`, Petersen pullback scalar, and Gaunt coefficient are
  derived joints rather than free literals.

## Degrees of freedom and mystery ledger

Every item in the following table is settled on the formal surface.  The
remaining geometric evidence gaps are listed separately below; they are not
unexplained constants or hidden degrees of freedom.

| Item | Disposition |
|---|---|
| quadratic sheet | Boolean/odd-generator choice; deck action proved |
| square root of five | golden root equivalence; conjugation negates it |
| axis representatives | conference switching; cubic invariant |
| axis, plane, and face labels | explicit equivalences in `MarkedBridgeDatum` |
| normalized chart lift | explicit injective linear map; scaling theorem |
| conference matrix | derived structurally from a tight-frame Gram equation; displayed matrix retained as a finite witness |
| `5` | discriminant `(2t-1)^2` of `t^2-t-1` |
| `2` | product of the derived reflection norms `1*2` |
| `80` | `(4 sqrt(5) sigma_3)^2 = 4^2*5*sigma_3^2` |
| `196,47,112,243` | diagonal and two Petersen-orbit values of `P_6` |
| `13` | explicitly the dimension/addition-theorem normalization input; the geometric addition theorem remains outside Lean |
| `3` | norm multiplier of the pair-sum map on the sum-zero module |
| `25` | normalization of `(4,-1,-1,-1,-1)` by one fifth |
| `1247103` | `46189*27`, retained through the separately named Wigner and Petersen factors |
| `3553,4563` | reductions `46189/13` and `27*13^2` |
| prime `11` | only the declared specialization where the derived class `2` is checked nonsquare |

No genuine numerical or sign mystery remains.  The EJ/Tao pass additionally
showed that the Petersen norm factor `3` is the specialization `n-2` at
`n=5`; the general `K(n,2)` theorem is now in the gate.

### Open formal-strength gates

| Manuscript row | Exact evidence gap before full formal coverage | Gate |
|---|---|---|
| `ARITH-1` | global Hitchin incidence variety, trace-split Stein algebra as a sheaf, branch divisor, and chart correspondence | retain “partial mechanism” until these geometric declarations exist |
| `ARITH-2` | complete-fibre identification and a general spinor-norm theorem connecting the reflection witness to the geometric exchanger | retain “partial mechanism” |
| `ORIENT-1` | normalization of the pulled-back incidence scheme and extension across the branch divisor | retain “partial mechanism” |
| `HARM-1` | face-axis realization in `H_6`, spherical addition theorem, and abstract `A_5` uniqueness | retain “partial mechanism” |
| `HARM-2` | invariant-line theorem for the geometric spherical cubic and the raw degree-six moment | retain “partial mechanism” |

No successor is allocated to prove these geometric inputs.  They remain
explicit declaration gates rather than being silently assigned to the
packaging successor.  The integral Mukai--Umemura comparison is likewise
outside this current-paper gate.  C287 owns only reviewed extraction and
content-addressed tagging of the closure proved here.

## Trust boundary

Symbolic Lean proofs handle pinching, conductors, involutions, tight frames,
Gram determinants, switching, Petersen eigenspaces, fixed-line uniqueness,
and rational scalar identities.  Native decision is restricted to displayed
finite matrices, explicit finite vectors, finite conference signs, and the
`F_11` nonsquare leaf.  There are no `sorry` declarations, user axioms, or
unsafe declarations in the paper gate closure.

The integral Mukai--Umemura comparison is not in this gate.  Neither are the
global incidence normalization, the Hitchin-to-chart correspondence,
face-axis geometry, the spherical addition theorem, or the raw degree-six
moment.  Consequently the paper manifest records useful partial mechanism
coverage but does not mark any of its five manuscript rows as formally
proved at full strength.

## Validation

The exact-target build queue ended with
`RelativeConicArcs.Gates.ClebschPassages` gate-passed.  A direct guarded gate
replay produced the pinned 34-declaration axiom report.  Source-policy scans
found no `sorry`, user axiom, unsafe declaration, or workflow identifier in
the closure.  The paper-local formal replay passed both pinned-source and
gate/axiom checks; the complete paper release gate passed all exact arithmetic
replays and a warning-free manuscript build.  A detached clean worktree at
the committed source snapshot rebuilt the gate from source and passed both
the formal replay and the full paper release gate.  The deterministic export
planner and audit reported no private-reference finding; the standalone
paper release and formal replay passed.  Its forward-sync commits are
`76fe622` for the structural surface and `8aed2bb` for the final generalized
norm refresh.  A second clean worktree at authoritative commit `27ac009e`
then rebuilt the refreshed gate and repeated both full replays successfully.

## EJ pass

The cheap structural gains were taken, not merely noted:

1. the exchanger matrices were replaced as proof input by the standard
   reflection formula and derived norms one and two;
2. marked chart scaling became an explicit covariance theorem;
3. `sigmaThree_normalizedMarkedVector` now follows from cubic homogeneity and
   the primitive value instead of a second finite-vector evaluation; and
4. the Petersen norm factor three was generalized to `n-2` on the sum-zero
   pair-sum module for `K(n,2)`.

The last item is the only unexpected reusable theorem exposed at closeout.
No discovery-track item is needed beyond advertising this general lemma in
future Kneser users.

## Tao-style pass

The pass asked whether the formal statements merely renamed computations,
whether any geometric identification had been hidden as an axiom, whether a
literal matrix was standing in for a character theorem, and whether the
special constants survived outside their mechanisms.  The resulting audit
forced the reflection-formula upgrade, the general `n-2` norm theorem, and
the five-row partial-coverage boundary.  The final surface is strongest where
the present Lean library is genuinely structural and deliberately conditional
at the exact geometric interfaces it does not yet represent.
