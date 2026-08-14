# C907 — hostile audit of the Gamma point-row theorem package

Date: 2026-08-13

Status: theorem hierarchy frozen for manuscript construction.  This audit was
performed before any paper source was created.  It separates the exact
point-column and ordinary-flop theorems from the additional sectorial and
two-wall statements that remain conditional.

## Verdict

The package survives as a paper, but not with every result at the strength of
the source notes.

The exact algebraic heart is the common-open point column in the
Gu--Yu--Yu simple-wall comparison.  The path-local ordinary-flop point row is
also exact.  The incomplete-Gamma connection and the localized
Fourier--Laplace kernel give rigorous no-go results.  By contrast, a
primitive-sixth rank statement for a discrepant wall requires a sectorial
realization in addition to the formal quantum-D-module decomposition, and a
two-wall globalization requires a coherent directed boundary comparison.
Neither extra comparison is supplied by the cited formal theorems.

The manuscript may therefore have three unconditional headline results and
one conditional assembly theorem:

1. exact common-point column for a smooth projective simple VGIT wall;
2. exact point-row preservation for a projective ordinary flop, on a fixed
   Lee--Lin--Qu--Wang continuation domain;
3. an abstract no-go theorem showing that formal monodromy, pairing,
   integrality, and the length-three projective-space tag do not determine the
   point row, together with the precise loss under localized partial
   Fourier--Laplace;
4. a factorization criterion conditional on a two-wall rank-zero-target
   statement.

The paper must not claim an unconditional stabilization theorem for cubic
threefolds.

## Claim audit

### A. Exact simple-wall point column — accepted

Let `X_- -> X_+` be a simple VGIT wall satisfying Gu--Yu--Yu's smooth
projective hypotheses, with wall fixed component `F_0`.  For a point in the
common open set, their Lemma 3.27 gives the distinguished master lift `a_p`.
The last paragraph of its proof identifies

```text
a_p|F_0 = f(lambda),
```

where `f(h_+)` is the restriction of the chosen point class to the positive
exceptional locus.  Since the point is disjoint from that locus, `f=0`.
This is stronger than the bare degree bound in the lemma and must be quoted
from the proof, not from its statement.

Lemma 5.10 applies both to `a_p` and to `lambda a_p`.  The latter has zero
negative-chamber Kirwan image because a degree-two class times the top point
class vanishes.  Proposition 5.9 is an isomorphism over the completed source
ring; base change to `Q_W=theta=0` preserves that isomorphism.  Hence
`lambda a_p` is zero in the specialized completed source and every one of its
Fourier images vanishes.  The positive Fourier covariance equation then
makes the positive point image horizontal.  Its constant term is the point
class by Lemma 5.8, and the first-coefficient recursion

```text
(k id + z^{-1} D cup -) v_k = 0
```

has only the zero solution because `D cup -` is nilpotent.  Thus the whole
positive tail vanishes.

The exact conclusion is the ambient coordinate identity

```text
pr_{X_+} Phi([p_-]) = [p_+]
```

at the extremal specialization.  It does **not** say that all wall
coordinates of `Phi([p_-])` vanish.  Positive master-Novikov terms in the
stationary-phase transform can survive even when the classical wall
restriction is zero.

### B. Wall-local primitive-sixth rank statement — conditional

Gu--Yu--Yu prove a formal, pairing-preserving decomposition over an
exceptional Laurent/ambient-Novikov completion.  Shen--Shoemaker identify
Gamma asymptotic classes after an extremal specialization.  Neither theorem
constructs the common sectorial fibre functor which contains the intrinsic
large-radius point section and the full ambient primitive-sixth packet with
all ambient Novikov variables retained.

The Artin-level sectorial construction in the source notes is a plausible
new theorem, but it is not a source-level corollary.  The manuscript may state
the primitive-sixth rank identity only after assuming, or separately proving,
a pairing-preserving sectorial realization of the formal summands.  The exact
point-column theorem remains unconditional and should appear first.

### C. Ordinary-flop point row — accepted with narrower scope

Lee--Lin--Qu--Wang identify the big quantum products and pairings after
analytic continuation in the extremal variable, while retaining all
transverse Novikov variables formally.  For a point off the exceptional
locus, every positive pure-extremal map misses the point, so the transverse
degree-zero point column is classical for every nonsingular extremal
parameter.  If `D` is pulled back from an ample divisor on the common
contraction, then `D.ell=0`.  At the first nonzero transverse coefficient of
the difference of the two point sections, `D`-horizontality gives

```text
((D.beta) id + z^{-1} D cup -) delta_beta = 0.
```

The scalar is positive and cup product is nilpotent, so the coefficient
vanishes.  Induction gives equality of the point sections, and the preserved
formal type gives the path-local primitive-sixth rank-row identity.

The manuscript will state this for the projective ordinary flops covered by
the published theorem.  It will not add disconnected-center or simultaneous
flop variants unless a source or a separate proof supplies that extension.
It will also distinguish this one-column descendant conclusion from full
descendant invariance.

### D. K-positive carrier face — criterion, not headline theorem

Strict `c_1`-positivity on a rational-polyhedral retained face makes every
fixed-cohomological-degree coefficient of the small quantum product a finite
sum.  This removes the illegal evaluation of a formal Novikov series at a
nonzero point.  It does not by itself prove convergence and compatibility of
every Gamma-normalized sectorial frame needed at both ends of a peak.

The usable statement is therefore a receiver criterion: if the retained face
is packet-faithful, its connection has an analytic realization, and the two
endpoint sectors lie in one nonturning component with a common normalized
point section, then flatness preserves the rank row.  Positivity supplies the
coefficientwise finiteness part; the analytic and oriented-path clauses remain
explicit hypotheses.  The paper must not advertise positivity alone as a
general peak theorem.

## Negative and methodological claims

### E. Incomplete-Gamma countermodel — accepted

For `alpha=1/6`, the rank-two connection

```text
dY/dz = [[0,z^{-2}],[0,z^{-2}+alpha z^{-1}]]Y
```

has flat columns `f_0=(1,0)^t` and

```text
f_alpha=(Gamma(1-alpha,1/z), z^alpha exp(-1/z))^t.
```

Direct differentiation checks the equation.  The continuation formula for
the incomplete Gamma function produces a nonzero Stokes shear from the
primitive-sixth formal line into the ambient line.  Doubling by the dual
connection gives a flat nondegenerate symmetric pairing and an integral
unipotent Stokes matrix.  Tensoring with `Q[N]/(N^3)` preserves the shear and
makes it `N`-linear.  Thus the listed abstract shadows cannot force the
rank-zero-target conclusion.

The covector in this model is an abstract flat point-row datum, not the Gamma
row of a known smooth projective variety.  The correct conclusion is a no-go
for deductions from the listed shadows alone, not a geometric counterexample.

### F. The toric `dP_7` braid — accepted as a necessity falsifier

The critical-point computation for

```text
W=x+y+a/x+B/(xy)+a/y
```

is exact.  The diagonal branch satisfies `x^3-a x-B=0` with discriminant
`4a^3-27B^2`; at the positive discriminant point the wall root and an ambient
root have a simple `A_1` collision and a transposition braid.  The relevant
toric wall is nevertheless rank-safe under the established toric
Gamma/window comparison.

This rules out **absence** of turning or braid as a necessary condition for
rank safety.  It does not rule out a one-way theorem saying that a particular
braid-free corridor is sufficient.  The manuscript must use the logically
weaker conclusion.

### G. Localized Fourier--Laplace loss — accepted

Reichelt--Schulze--Sevenheck--Walther define localized partial
Fourier--Laplace as ordinary Fourier--Laplace followed by localization in the
dual coordinate.  Under ordinary Fourier transform,
`C[t]=D_t/D_t partial_t` becomes a module supported at the dual origin and is
killed by localization.  Their four-term comparison uses exactly this
kernel.

For `g(x)=Gamma(1-alpha,x)`, direct differentiation gives

```text
(partial_x+1+alpha/x) partial_x g=0.
```

The derivative map forgets the one-dimensional constant solution, and that
constant is precisely the additive datum in the incomplete-Gamma
continuation formula.  Therefore a localized GKZ system cannot determine the
point-row extension without the boundary object at the deleted Fourier
coordinate.

### H. Boundary triangle minimality — necessity only

The unlocalized map

```text
FL(M) -> j_* j^* FL(M)
```

and its `! -> *`, `can/var`, duality, orientation, and path-order data retain
what localization forgets.  The countermodel proves that some such boundary
datum is necessary.  It does not prove that the boundary triangle alone is
sufficient for a geometric two-wall comparison.  Sufficiency is the proposed
two-wall numerical Fourier--window theorem and must be labeled as a
conjecture or hypothesis.

Steiner's Corollary 5.9 supplies only the variance warning: for a normal GKZ
semigroup and a face, at least one of coordinate restriction and projection
is zero.  It does not, by itself, identify the ordinary and compactly
supported primitive-sixth objects with a particular dual parameter pair.
That stronger identification is omitted unless proved separately.

### I. Proper-support toric pilot — excluded from the theorem spine

The current proper-support localization statement depends on an explicit
local `j_!` Morse identification and on a finite mask calculation whose public
reproducibility bundle has not been assembled for this paper.  It may be
mentioned as motivation or future evidence, but it will not be a premise or
headline theorem of the first manuscript version.

## Corrected manuscript hierarchy

1. Define the Gamma point row and distinguish a formal block, a sectorial
   lift, and an intrinsic large-radius section.
2. Prove the exact simple-wall ambient point-column theorem.
3. Prove the path-local ordinary-flop point-row theorem.
4. State the discrepant primitive-sixth consequence under a named sectorial
   realization hypothesis.
5. Prove the incomplete-Gamma and localized-Fourier no-go theorems.
6. Formulate the two-wall rank-zero-target statement and prove that it is
   sufficient for factorization-level rank-row invariance.
7. End with the exact open problem: establish that statement for the first
   noncrepant carrier-dressed unit circuits.

No paper surface may use the project shorthand for the desired stabilization
result.

## Source-depth boundary

This audit is a source-characterization audit, not a novelty search.  It uses
partial reads of Gu--Yu--Yu (Lemma 3.27; Sections 5.2--5.3 and Theorem 6.2),
Lee--Lin--Qu--Wang (Theorem 0.1.1 and Sections 1.2--1.3), Han (Theorems 1.2,
4.5 and Proposition 4.1), Reichelt--Schulze--Sevenheck--Walther
(Definition 5.6 and the four-term comparison), and Steiner (Corollary 5.9).
The paper-local literature ledger will carry exact versions, cache keys,
SHA-256 values, and all other source loci.

## Mystery ledger

- Settled: the Gu--Yu--Yu point column is exact, but only its ambient
  coordinate is asserted.
- Settled: ordinary-flop preservation is a one-column flatness theorem and
  does not require full descendant invariance.
- Settled: formal labels, pairing, integrality, a length-three nilpotent tag,
  and unmarked braid data do not determine the point row.
- Open: construct the common sectorial realization needed to turn the formal
  simple-wall decomposition into an intrinsic primitive-sixth statement.
- Open: prove the directed two-wall boundary comparison, or exhibit a
  smooth-projective residue block with nonzero common-open rank.
