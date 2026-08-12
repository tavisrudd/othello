# C907 moonshot attack plan

**Lane:** `clebsch`

**Scope:** research plan for proving, first,

\[
X\times\mathbf P^2\text{ irrational}
\]

for every smooth cubic threefold `X`.  No manuscript or Lean work is
authorized.

## Decision

Run two proof tracks in parallel after one shared definition gate:

- **A — analytic:** construct a codimension-two Stokes/Gamma/Rees blow-up
  comparison strong enough to forbid extension-joining;
- **C — carriers:** prove or refute the enriched cubic-packet length bound for
  arbitrary smooth projective threefolds.

Assemble the weak-factorization proof only after both pass.  Do not generalize
to all `m` before the `m=2` theorem closes.

## The exact theorem package

Fix the cubic residue pair `alpha={+/-1/6}`.  The candidate object

\[
\mathscr A_\alpha(Y)
\]

is the local zero-exponential Stokes graded packet of the full quantum module,
equipped with its irregular-Hodge/Rees filtration, Gamma lattice, pairing,
root-monodromy action, unipotent Serre operator `U`, and phase-mutation data.
Cai's rank-two block is not a global submodule.

Define `ell_alpha(Y)` as the largest indecomposable consecutive Rees/Tate
string, equivalently the largest enriched `U`-block where that equivalence is
proved.  Common Tate shift does not change `ell`.

The `m=2` proof needs four results.

### D — definition and calibration

Construct a phase/mutation-invariant cubic packet and prove:

- strict biproducts take maximum length;
- Tate shift preserves length;
- `ell_alpha(X)=1` and `ell_alpha(X x P^2)=3`;
- dimensions at most two have empty cubic packet; and
- the endpoint length-three block is indecomposable in the enriched category.

### A — analytic blow-up theorem

For a smooth codimension-two center `Z subset Y`, prove either an enriched
biproduct

\[
\mathscr A_\alpha(Bl_ZY)
\simeq \mathscr A_\alpha(Y)\oplus T\mathscr A_\alpha(Z),
\tag{A}
\]

or an associated-graded signature with the same identity and on which every
off-diagonal Stokes/Serre extension has nonzero Rees degree.  The comparison
must preserve the Stokes filtration, Gamma lattice, pairing, `U`, and
composition.

A merely strict exact sequence is insufficient: extensions of three
length-one blocks can form a length-three block.

### C — carrier theorem

For every smooth projective threefold `Z`, prove

\[
\ell_\alpha(Z)\leq1.
\tag{C}
\]

The first structural subtheorem is stronger: a smooth nef-canonical
threefold has no cubic packet.  KKPYY Claim 6.15 makes its parity-gauged
connection regular singular with nilpotent residue, leaving only fractional
classes `0` and `1/2`.  The proof must audit the basepoint and analytic
realization hypotheses; the formal statement alone does not construct `D`.

### W — positive weak-factorization telescope

Place the enriched objects in a finite idempotent-complete Krull--Schmidt
category and let `Sig` be the free monoid of indecomposable signatures.  For a
weak factorization between `Y_0` and `Y_N`, repeated use of the blow-up formula
must give a positive biproduct identity

\[
\mathscr A_\alpha(Y_0)\oplus
\bigoplus_{i,j}T^j\mathscr A_\alpha(Z_i^-)
\simeq
\mathscr A_\alpha(Y_N)\oplus
\bigoplus_{i,j}T^j\mathscr A_\alpha(Z_i^+).
\tag{W}
\]

Here the common model at step `i` is the blow-up of `Y_(i-1)` along
`Z_i^-` and of `Y_i` along `Z_i^+`.  The signs in `(W)` follow by equating
those two blow-up decompositions.

No subtraction in `K_0` is allowed.  For `Y_0=X x P^2` and `Y_N=P^5`, every
nonzero center term comes from a codimension-two threefold and has length at
most one, while the endpoint contains a length-three indecomposable.  Unique
decomposition contradicts `(W)`.

## Dependency order

| Wave | Work | Depends on | Exit gate |
| --- | --- | --- | --- |
| 0 | Freeze the enriched category, cubic packet, phase action, and `ell_alpha` | closed C907 computations | `D` is a literal definition with endpoint and mutation tests |
| 1A | Formal codimension-two normalization and order-zero residual-center cocycle | Wave 0 | normalized Stokes cocycle is defined and computed |
| 1C | Nef-canonical exclusion | Wave 0 | formal exclusion theorem; closed dimension-free by KKPYY Claim 6.15 |
| 2A | Toric then non-toric residual-center identification | 1A | Stokes/Gamma/Rees comparison or exact counter-obstruction |
| 2C | Universal threefold bound or counterexample | 1C | theorem `(C)` or certified length-two carrier |
| 3 | Composition and weak-factorization telescope | 2A and 2C | `(A)` and `(W)` pass hostile review |
| 4 | Self-contained `m=2` theorem | Wave 3 | independent analytic, categorical, and birational reviews pass |
| 5 | All-codimension/all-`m` programme | completed `m=2` | strict general blow-up theory plus `width <= dim-3` |

Tracks A and C run concurrently after Wave 0.  Within C, the direct
dimension-three grading attack and counterexample search run before an MMP
transport programme.

Wave-1 status: the exact toric pilot has been built and independently
replayed; its residual critical values converge after affine rescaling to the
`P^3` spectrum.  The surviving task is the framed four-thimble
Picard--Lefschetz/Stokes comparison, not another critical-value calculation.
See `2026-08-11-c907-toric-r2-pilot.md`.

Wave-2 status: a second exact rescaling gives `W_(P^3)+ZU` and proves an
open-torus bounded-value logarithmic gradient gap.  Direct endpoint transport
is false.  Principal ratio charts cover all bounded pole weights with `y` in
the residual core, but a cold referee found that neither those charts nor a
multi-Rees principalization of the individual derivatives proves boundary
submersivity after cancellations.  The next finite problem is the joint
saturated graph and **tangent logarithmic Jacobian** on every mixed
`y,B,C` cone.  Each initial system must be certified as `L`-free, residual,
or empty; only then may one form a common product-pair collar cover and glue
the exterior ratio charts to, rather than through, the `c=1` residual core.
The correct rank-four object is localized over a bounded value disk; the
global rapid-decay group has six additional ambient critical contributions.
Iritani identifies the residual Gamma lattice with the Orlov subgroup, not the
individual Beilinson thimbles.  See
`2026-08-11-c907-wave-two-double-suspension-and-pole-escape.md`,
`2026-08-11-c907-pole-channel-normal-crossing-excision.md`, and
`2026-08-11-c907-toric-order-zero-stokes-assembly.md`.  The exact finite
proof object is specified in
`2026-08-12-c907-tangent-jacobian-fan-certificate-spec.md`.
The first two cone certificates are explicit: the compact residual chart has
exactly four Morse points, while the balanced mixed ray
`y_i~delta^-2, B,C~delta^4` is tangent-free because `L` becomes a genuine
coordinate on the saturated central graph.  See
`2026-08-12-c907-first-tangent-jacobian-cone-certificates.md`.
The compact-`y` continuum `B~delta^alpha`, `0<=alpha<=2`, is now compressed by
the single semistable incidence model `ef=delta^2`; all `0/0`, `0/1`, and
symmetric central strata are `L`-submersive.  See
`2026-08-12-c907-finite-pole-continuum-certificate.md`.
The next analytic move is no longer another ray chart: compute the relative
comprehensive Gröbner fan of the saturated graph, residual Rees marking, and
tangent-critical module.  This produces a finite cone list whose only allowed
outcomes are empty, exterior, or the marked residual Morse scheme.  See
`2026-08-12-c907-tropical-critical-fan-pivot.md`.

Wave-2C status: ordinary cohomological grading and duality do not bound the
length—an explicit self-dual formal length-two model survives.  The first
geometric regression sweep is nevertheless decisive for ordinary smooth Fano
complete intersections: their small-even framed formal monodromy always has
`nu_6<=2`, with equality only for the cubic and `(2,3)` cases.  Hence none can
realize the required length-two carrier, which needs `nu_6>=4`.  The search now
starts at weighted or non-complete-intersection Fanos and Mori-fibre spaces;
the theorem must still cover arbitrary threefold centers.

Wave-2C status: the direct dimension-three grading route is closed negatively.
An explicit self-dual formal model satisfies hard Lefschetz, Poincare duality,
and the primitive-sixth HLT support conditions while carrying length two.  The
carrier theorem must kill one geometric sectorial Rees extension class; it is
not a consequence of ordinary grading.  See
`2026-08-11-c907-threefold-grading-boundary.md`.

## Wave 0 — freeze the invariant

1. Define a fixed-phase object
   \[
   (L,F^{St}_\phi,F^{Rees},\Lambda^\Gamma,\langle-,-\rangle,U)
   \]
   and its transition under Stokes mutation.
2. Define the cubic packet by the zero-exponential Stokes grade and primitive
   sixth-root formal monodromy, not by global monodromy alone.
3. Prove its width is unchanged by admissible phase mutation, up to common
   Rees shift.
4. Prove that the enriched length-three endpoint differs from three
   length-one summands.
5. Enhance the whole atomic composition together with its operation frame.
   Proposition 5.22 permits pullback of a bare geometric-atom statistic, but
   such an atomwise statistic cannot distinguish `J_r` from `J_1^r`.
6. Use mutation on `D^b(P^1)` as the compulsory rejection test: Euler and
   Serre data alone must fail the definition.

**Stop D:** if phase-independent width cannot be defined, retain all later
claims only as conditional and pivot to constructing the missing
mutation-system datum.

## Track A — codimension-two analytic gate

### A1. Formal normalization

Specialize Iritani (5.28) at `Q=theta=0`.  For codimension two the exceptional
Fourier block is one-dimensional.  Prove without machine dependence that the
`t`-adic then exceptional-first associated graded is

\[
(F\otimes I_Z)\oplus I_Y.
\]

This fixes conventions; it is not the analytic theorem.

The ordinary carrier-height branch is closed: for `X x P^2`, the cubic
abstract atom is already carried by the allowed threefold `X`.  No refinement
of its ordinary multiplicity can prove the endpoint.  The bridge above and
the enriched Tate/Stokes placement are essential, not optional packaging.

### A2. First-order obstruction

This step is gated by the order-zero residual-center identification.  Iritani's
toric theorem supplies residual sectorial pieces but explicitly leaves their
Stokes identification with the center open.  First compute that mismatch as a
Stokes cocycle in the toric pilot.  Only if it is trivial proceed below.

Work over

\[
B_1=\mathbf C[[t,Q,\theta]]/(Q,\theta)^2.
\]

Define and compute:

\[
e_\pi^{(1)}\in
Ext^1_{St^{\Gamma,Rees}_\phi}
(\mathscr A_\alpha(Y),T\mathscr A_\alpha(Z))
\otimes (Q,\theta)/(Q,\theta)^2,
\]

the non-splitting class, and `d_pi^(1)`, the residual-versus-center Stokes
mismatch modulo block-diagonal gauge and Stokes coboundaries.  Test Rees
strictness by saturation and record any torsion in the cokernel.

### A3. Pilot ladder

1. `Bl_(P^3) P^5`: toric codimension-two normalization, Gamma/Orlov embedding,
   and sectorial splitting.
2. The same example to first Novikov order using its exact toric `I/J` data.
3. `Bl_X P^5` for a smooth cubic `X`: first non-toric test carrying the actual
   cubic packet.
4. `Bl_(V_5)P^5` and `Bl_(V_6)P^5`: Calabi--Yau and general-type scope tests.
5. Transverse and nested toric centers: require equality of enriched maps up
   to the specified block-diagonal gauge, not only the closed polynomial
   identities.

### A4. Analytic acceptance

- residual mutation-system summand equals the center Stokes object;
- Gamma embedding is the Orlov map
  `i_(E*) p^*(-) tensor O_E(-1)` in codimension two;
- `e_pi^(1)=d_pi^(1)=0` and no Rees torsion in the pilots;
- phase mutation preserves cubic width;
- the composition 2-cocycle vanishes; and
- the theorem extends from pilots to every smooth codimension-two center.

**Pivot A:** a nonzero obstruction or torsion class kills the strict-direct-sum
candidate.  Replace it by an explicitly non-split extension invariant; do not
weaken the acceptance gate while retaining the claimed telescope.

## Track C — arbitrary-threefold carriers

### C1. Nef-canonical exclusion

1. Restate KKPYY Claim 6.15 with exact basepoint, convergence, grading, and
   parity conventions.
2. Prove that undoing its integral parity gauge permits only residues `0` and
   `1/2`, hence no cubic packet.
3. Prove that the Wave-0 realization detects this formal absence.
4. State separately what is formal and what uses the analytic enhancement.

The formal exclusion theorem is now closed in every dimension: the parity
gauge leaves only residue classes `0` and `1/2`.  Promotion from empty formal
support to `ell_alpha=0` remains conditional on the Wave-0 realization.  See
`2026-08-11-c907-wave-zero-nef-exclusion-and-r2-audit.md`.  Quintic and sextic
hypersurfaces are immediate cases; computations are convention regressions
only.

### C2. Hostile exact regressions

Use symbolic `u`-connection calculations only to falsify the structural
lemma, never to prove it by a finite cutoff.

| Example | Purpose | Failure signal |
| --- | --- | --- |
| Quintic `V_5 subset P^4` | Calabi--Yau center | primitive-sixth residue or a forbidden parity-gauged degree block |
| Sextic `V_6 subset P^4` | general-type center | same |
| `K3 x C_(g>1)` | `kappa=1`, odd-cohomology/product test | failure of exclusion under tensor realization |
| `S_gt x E` | `kappa=2` test | same |

For hypersurfaces, derive exact jets through quantum Lefschetz/twisted
`I`-functions and retain primitive cohomology.  Do not substitute the
`q`-Picard--Fuchs equation for the `u`-formal type.

### C3. Universal bound

Try these routes in order.

1. **Direct grading theorem:** closed negatively at the stated inputs.  Hard
   Lefschetz, duality, and formal HLT exponents admit a self-dual length-two
   model.  Any repair must use the sectorial Rees extension, not ordinary
   cohomological grading.
2. **Smooth birational transport:** prove point/curve blow-ups cannot increase
   cubic length; calibrate on blow-ups of a cubic threefold.
3. **Pseudo-effective case:** only if needed, extend the object to terminal
   `Q`-factorial models and prove nonincrease across divisorial contractions
   and flips before invoking the threefold MMP.
4. **Uniruled case:** prove a relative result for conic bundles and del Pezzo
   fibrations that controls discriminant/gluing contributions.
5. Use Fano tables only to hunt a counterexample or test a structural lemma.

The likely counterexample locus is non-nef gluing through a fibration or flip,
not the nef-canonical hypersurfaces.  The exact candidate is the nonzero
self-dual extension in `2026-08-11-c907-threefold-grading-boundary.md`.  One
smooth realization kills `(C)`; uniform geometric vanishing proves it.

### C4. Carrier acceptance

- **Nef gate:** no cubic packet for every smooth nef-canonical threefold,
  with quintic and sextic regressions.
- **Universal gate:** `ell_alpha<=1` for every smooth projective threefold,
  with no unproved Fano/MMP exhaustion.
- **Negative gate:** a fully specified smooth length-two carrier and a proof
  of its enriched Stokes/Rees structure.

## Track W — assembly and review

1. Prove Krull--Schmidt and locality of the enriched indecomposable endomorphism
   rings; plain free `C[[t]]` modules are disallowed.
2. Prove the positive telescope `(W)` from actual biproducts or invariant
   associated-graded signatures.
3. Check every fivefold weak-factorization center: dimension at most three;
   nonzero cubic centers have dimension three and codimension two.
4. Prove that a length-three endpoint signature cannot match any multiset of
   shifted length-zero/one center signatures.
5. Obtain independent reviews from:
   - a Stokes/irregular-Hodge reader;
   - a derived-category reader focused on extension-joining;
   - a birational/MMP reader focused on center scope; and
   - a formal proof reader focused on positive telescoping versus `K_0`.

## Evidence bundle per stage

Every computational stage owns:

- a theorem/obstruction note with exact conventions and source loci;
- the exact generator;
- a compact certificate;
- an independent replay using a genuinely different normalization;
- hashes, dependency versions, and the precise finite stop condition; and
- a hostile audit stating what the computation does not prove.

The final `m=2` package adds the definition note, analytic and carrier theorem
reports, the positive telescoping proof, and independent referee reports.

## Immediate kill criteria

- cubic width changes under admissible phase mutation;
- a toric first-order non-splitting, residual mismatch, or Rees-torsion class
  cannot be incorporated canonically;
- the transverse/nested enriched comparison has a nontrivial 2-cocycle;
- a smooth threefold has cubic length at least two;
- the analytic comparison exists only in `K_0`, only after Laurent base
  change, or only after discarding Gamma/Stokes data; or
- the carrier proof requires an unavailable restriction on weak-factorization
  centers.

Any one of these ends the stated invariant.  The deliverable then becomes the
exact obstruction and the minimum corrected datum, not another finite search.

## Sources already controlling the plan

- Iritani, arXiv:2307.13555: Theorem 5.18, (5.28), Remark 1.5.
- Iritani, arXiv:1906.00801: Theorem 1.3, Remark 1.4(3), Conjecture 8.3,
  Proposition 8.5.
- Iritani, arXiv:2307.15938: Gamma lattice and mutation-system boundary.
- Hinault--Yu--Zhang--Zhang, arXiv:2411.02266: formal decomposition and
  uniqueness only.
- Sabbah, arXiv:1511.00176: strictness, canonical irregular filtration, and
  Thom--Sebastiani.
- Yu--Zhang, arXiv:2405.19549: topological Laplace target; read the precise
  theorem before making it load-bearing.
- KKPYY, arXiv:2508.05105: Claim 6.15 and enhanced-atom boundary.
- Full existing evidence and source hashes:
  `2026-08-10-c907-quantum-monodromy-stabilization.md`.
