# Complete repair ports: response to the applications brainstorm

**Lane**: `rp-next`

**Date:** 2026-07-16
**Status:** BRAINSTORM RESPONSE. Advisory only: this note allocates no task, reopens no completed
item, and changes no gate. It responds to
[the applications brainstorm](2026-07-16-repairports-applications-open-doors-brainstorm.md) after
reading C215--C220, C226--C228, and the active `rp-next` handoff.
**Conventions:** confidence labels follow the brainstorm (proved / theorem-ready /
medium / exploratory). Items marked *immediate calculation* were derived by hand from the
committed reports; every such item must be replayed against the cited verifier artifacts before a
report, handoff, or paper uses it. Brainstorm sections are cited as items 1--28; new material is
labeled R1--R11.

## Where the brainstorm already landed

Three of its strongest proposals were executed the same day and shape this response:

- items 1--2 and 8, and paper-ready additions 1--2, are
  [C226](2026-07-16-c226-repair-port-exit-transforms.md) (exact transforms, EXIT conventions,
  cheapest-radius distribution, stopping-certificate boundary);
- probe 1 and item 9 are [C227](2026-07-16-c227-pointed-tutte-repair-polynomial.md): strong GO,
  Las Vergnas perspective `M\x -> M/x`, pointed duality, and the exact boundary that the
  unfiltered polynomial does not see the radius cutoff;
- probe 2 and item 4 are [C228](2026-07-16-c228-holonomy-lsss-mpc.md): decisive negative for the
  `U(2,4)` pair, with the Veronese factoring explaining why;
- probe 4 and items 15/28 are the active C229.

So the response concentrates on: exact consequences the completed layer has not yet extracted
(R1--R3), direct inputs to C229 (R4), the redesigned holonomy/MPC probe (R5), the two gated
options (R6--R8), and positioning corrections (Part II).

## Part I: additional brainstorm items

### R1. Pointed primal distance: the coding form of C227's blocker duality

**Confidence: proved (elementary given C227 and Greene); the uniform-q rows are immediate
calculations pending replay.**

C227 proves that minimal blockers of `(M,x)` are the circuits of `(M*,x)`, i.e. cocircuits of `M`
through `x` with `x` removed. Add the standard coding reading: cocircuits of the column matroid
are exactly the inclusion-minimal supports of row-code codewords. Define the **pointed primal
distance**

```text
d_x(C) = min { wt(c) : c in C, c_x != 0 }.
```

Then for the complete (unbounded-radius) port:

- minimum blockers at `x` are exactly the minimal-weight codeword supports through `x`, minus `x`;
- `tau_full(x) = d_x(C) - 1`, and the blocker count is the number of such supports;
- equivalently, `tau_full(x)` is the locality of `x` in the dual code.

For the cubic--axis seed this turns C219's radius-four rows into plane-section bookkeeping. A
plane of `PG(3,q)` meets the axis line in exactly one point unless it contains it, and meets the
twisted cubic in at most three points. So the hyperplane sections of the 2q+2 points have sizes
in `{1,2,3,4} union {q+2}`, the nonzero weights lie in `{q, 2q-2, 2q-1, 2q, 2q+1}`, the minimum
weight-q supports are `curve minus one point` (the banked D-PC9 classes), and the four-point
sections are `three curve points plus their sigma-axis point` (R4 below). Counting sections gives,
uniformly over `q=3^h`:

| target class        | `d_x` | `tau_full` | minimum blockers |
|---------------------|-------|------------|------------------|
| any curve coordinate | `q`     | `q-1`  | `q`              |
| any axis coordinate  | `2q-2`  | `2q-3` | `q^2(q-1)/6`     |

The axis count uses the uniformity fact that exactly `q(q-1)/6` four-point sections sit at each
axis point (total `(q+1)*q(q-1)/6 = binom(q,3)+binom(q,2)`). At q=9 this gives `9` and
`108`, matching C219's radius-four leading terms `9p^8` and `108p^15` exactly, and it extends the
C220 radius-three story: at a curve target the truncation profile is
`(tau, count) = (q-1, q(q+1)/2)` at radius three collapsing to `(q-1, q)` at full radius, because
the pair-survivor blockers are rescued by five-element circuits while the singleton-survivor
blockers are genuine weight-q codewords.

Value: (i) C219's tables and their all-q generalizations become one-line consequences of a
pointed weight enumerator; (ii) the reliability tail near `p=1` is exactly low-weight primal data
while the tail near `p=0` is low-weight dual data, which is the cleanest statement of the
"two-way bridge"; (iii) Massey's minimal-codeword secret-sharing dictionary plugs into item 3
verbatim. First step: replay the two q=9 rows and one q=27 spot value against the committed
C219/C227 certificates.

### R2. Split weight enumerators for the perspective polynomial

**Confidence: theorem-ready; audit may downgrade it to a citation.**

Item 9's bullet "relations with split or pointed code weight enumerators" is now concrete: prove
a Greene-type theorem identifying the coordinate-split weight enumerator of `(C,x)` (weight at
`x` tracked separately) as a specialization of C227's `T_(M;x)`, and derive its MacWilliams
transform from Las Vergnas duality `T_(M*;x)(X,Y,Z) = Z T_(M;x)(Y,X,1/Z)`. Combined with R1 this
computes `S_x(u)` for few-weight families directly from weight data, with no subset enumeration.
Audit first: Ashikhmin--Kramer--ten Brink already develop split support weights on the BEC side
(cited in C226), and Britz's Greene-theorem extensions to coordinate partitions are the likely
prior art. If the identity exists there, import it; the repair-port application is still the new
content.

### R3. One master additive enumerator behind both transforms, and the exact two-target law

**Confidence: proved by the same conditioning as C226 (1)/(3); immediate calculation.**

Define, for `G = F_3^h`,

```text
A_h(u,y,w) = sum_(S subset G) u^|S| y^|R(S)| w^|R(S) intersect (-S)|.
```

A char-3 lemma makes the third statistic geometric: `S` contains an affine line iff
`R(S) intersect (-S)` is nonempty (if `s+t=-u` with `s != t` and `u in {s,t}`, say `u=s`, then
`t = -2s = s`, a contradiction; so witnesses are automatically zero-sum triples). Hence:

- C226's cubic transform is `Q_cubic = p_C^q A_h(u, p_A, 1)` with `u=(1-p_C)/p_C`;
- C226's axis cubic factor is `p_C^q A_h(u, 1, 0)` (the `w=0` slice is exactly the cap/zero-sum-free
  sector);
- the joint radius-three failure of the cubic-infinity and axis-infinity targets is exactly

```text
Pr(both fail)
  = p_C^q [ (p_A^q + q(1-p_A)p_A^(q-1)) A_h(u,1,0)
            - (1-p_A) p_A^(q-1) dA_h/dy (u,1,0) ],
```

by conditioning on `S` line-free, all of `R(S)` erased, and at most one axis survivor outside
`R(S)`.

Both failure events are decreasing in the survival indicators, so Harris/FKG gives
`Pr(both fail) >= Q_cubic * Q_axis` automatically; the enumerator computes the correlation gap
exactly. Value: one carrier object for item 17's program (the `w=1` fiber holds the
subgroup-lattice defect sectors, the `w=0` fiber holds the cap sector), plus the first exact
joint-target law, which is C229-adjacent but one-shot, so it does not preempt C229's sequential
questions.

### R4. Direct inputs to C229: rule algebra, two separations, one equality theorem

**Confidence: (a) proved; (b) immediate calculation; (c),(e) proved given (b) and C218's
independence facts; (d) theorem-ready.**

(a) *Full-span joint ports are conjunctions.* If `x in cl(A)` then `cl(A union {x}) = cl(A)`.
So at full radius, sequential recovery adds nothing and a joint target set is recoverable iff
each target is individually: C229's level-one question closes positively but trivially, and all
genuine joint structure lives at bounded radius.

(b) *Complete rule algebra of the cubic seed.* The plane through curve points with parameters
`s,t,u` has coefficient vector `(sigma_3, -sigma_2, sigma_1, -1)`, so its axis point is
`A(sigma_2/sigma_1)` when `sigma_1 != 0` and `A(infinity)` when `sigma_1 = 0`; triples through
`C(infinity)` complete to `A(s+t)` as the degenerate case. The size-at-most-five circuits are:
the axis-line triples; `{C(u),C(s),C(t),A(v)}` with `v` the sigma-completion; any five curve
points; four curve points plus one axis point avoiding all four sigma-completions; three curve
points plus two axis points avoiding the sigma-completion. Every C229 forward-chaining question
for this family reduces to this table.

(c) *One-shot is strictly weaker than sequential at radius three.* Target `C(u)`; survivors
`{A(a), A(b), C(s), C(t)}` with the sigma-completion `v` of `(u,s,t)` outside `{a,b}`. No
radius-three circuit through `C(u)` has all helpers alive, so one-shot fails; but
`A(v) <- {A(a),A(b)}` fires (axis-line circuit), then `C(u) <- {C(s),C(t),A(v)}`. Four survivors,
inside the flagship family.

(d) *For the cubic seed, sequential radius-three closure equals full span closure on every
survivor set, for all `q=3^h`.* Case sketch: two axis survivors regenerate the axis line; four
curve survivors always yield at least two distinct axis completions (two triples sharing a pair
with equal finite completion `v` force `v` to be the pair sum, and two shared pairs then force
two of the four points equal), after which everything cascades; the small mixed cases match the
span computation pointwise, e.g. three curve points plus their own sigma-point stall exactly at
their closure. So the seed separates one-shot from sequential but cannot separate sequential from
span.

(e) *The harmonic family separates sequential from span.* Take survivors
`{V(infinity)} union {V(a),V(b),V(c),V(d)}` where `{a,b,c,d}` is a four-point zero-sum-free set
with `e_2(a,b,c,d) != 0`. Such sets exist at q=9: there are 54 maximum zero-sum-free sets and
only 18 finite harmonic blocks, so counting leaves at least 36 candidates. The five survivors
contain no block, so no radius-four rule fires at all (every curve rule needs `N`, every `N` rule
needs a whole block): sequential radius-four closure is the survivor set itself. But any five
curve points are independent (C218), so the survivors span and full closure recovers all eleven
coordinates. Together with (d): the two flagships separate the two levels in complementary
directions, with in-family, q=9-verifiable witnesses. Both should be added to C229's certificate
as unit tests rather than found by search.

### R5. The post-C228 holonomy probe: tensor-square matroids at fixed support

**Confidence: medium; one bounded script.**

C228's closing sentence names the mechanism: coefficient geometry can change the represented
matroid of the tensor squares. The smallest natural candidate is `[8,3]` over a field with at
least nine elements: eight points on a conic (generalized Reed--Solomon) versus eight generic
points of `PG(2,q)`. Both have support matroid `U(3,8)` and identical ports at every coordinate;
their Schur squares have dimensions `2k-1 = 5` versus `min(n, binom(k+1,2)) = 6` (the standard
square distinguisher used against Reed--Solomon-structured McEliece variants), so the square
matroids differ within one support class. The bounded question: run C228's criterion with `t=2`
adversaries. The GRS instance is Shamir at `n = 3t+1`, hence strongly multiplicative; check
whether a generic instance fails strong multiplicativity after deleting some two participants.
A yes gives the first pair of support-identical ideal LSSSs separated by an MPC capability, which
is exactly what item 4 wanted and what C228 proved impossible at `U(2,4)` scale. A no is still a
clean boundary one rank up. Either way the Veronese-image matroid becomes the operational
holonomy invariant, and the Schur-power dimension sequence is the cheap fingerprint for item 18
audits.

### R6. Support-level characteristic certificates are already available

**Confidence: proved modulo the classical AG(2,3) citation and a replay of the two contraction
claims; narrows the gated audit.**

Both flagships contain the nine-point affine plane after one or two contractions:

- Cubic seed: in `M / A(infinity)`, the three-element circuits among the finite cubic
  coordinates are exactly the zero-sum triples (from the port's `{A(infinity),C,C,C}` circuits;
  no smaller circuits exist). At h=2 that restriction *is* `AG(2,3)`; for h>2 every 2-flat gives
  an `AG(2,3)` restriction.
- Harmonic family: contracting `{N, V(infinity)}` turns the blocks through infinity into
  three-element circuits on the finite parameters, again the zero-sum triples, again `AG(2,3)`.

`AG(2,3)` is representable over a field iff the characteristic is three or the field contains a
primitive cube root of unity (Hesse configuration; never over the rationals or reals). Hence
**no representation of either support matroid exists over any `F_q` with `q = 2 mod 3`, nor over
any ordered field**. This is the first proved instance of item 13, at support level, with no
holonomy input. The gated C218 audit therefore reduces to the remaining sliver: characteristic
different from three *with* cube roots of unity (F_4, F_7, F_13, the complex numbers). That
residual case is a bounded coordinatization-ideal computation over `Z[omega]` for the q=9
instance: fix a projective frame on five of the eleven points, impose the thirty block
coplanarities and the independence conditions, and read the characteristic content of the
elimination ideal. Output is either an explicit exotic representation (surprising, publishable)
or a characteristic-three-only certificate completing item 26's fingerprint story.

### R7. Exact locality-deficit integrals, and the area ledger for item 21

**Confidence: the two deficits are immediate calculations from C227 (11)--(12); the ledger
identity is proved given the cited area theorem; the inequality half is a theorem-ready
question.**

Item 21's invariant (4) is computable today. In C226's conventions, with `n` helpers and
homogeneous erasure,

```text
L_r(x) = integral_0^1 [h_x^(<=r)(p) - h_x^MAP(p)] dp
       = sum_k Delta a_k / ((n+1) binom(n,k)),
```

where `Delta a_k` are the successful-set coefficients the full port adds beyond radius `r`.
C227's harmonic differences give the first exact values, at q=9 with `n=10`:

```text
L_4(nucleus target) = 72/(11*252)                  = 2/77,
L_4(curve target)   = (9/14 + 2/5 + 3/10 + 1/5 + 1/10)/11 = 23/154.
```

The ledger: the BEC area theorem fixes `sum_x integral h_x^MAP = n - k` for symbol-MAP decoding,
so

```text
sum_x integral_0^1 h_x^(<=r)(p) dp = (n - k) + sum_x L_r(x):
```

total truncated-EXIT area = redundancy + total locality deficit. This is bookkeeping, not a
capacity claim, and it respects C226's extrinsic conventions. The open half that would make item
21 a theorem: lower-bound `h_x^(<=r)` purely from the port profile (Harris: the per-circuit
blocking events are increasing, so failure probability is at least the product of per-circuit
blocking probabilities), integrate, and obtain a rate-plus-deficit tradeoff testable on
Tamo--Barg instances and on C218. Measson--Montanari--Urbanke's Maxwell-gap area is the right
analogy for what `sum_x L_r` should mean.

### R8. Design-exact Bernstein layers, harmonic arcs, and quantitative Poisson

**Confidence: the `a_5` identity is proved; the arc program is medium; the Stein--Chen and
Janson strengthenings are theorem-ready and nearly free.**

For the nucleus target of any `S(3,4,q+1)` port: `a_4 = b = (q+1)q(q-1)/24` and
`a_5 = b(q-3)` exactly, because two blocks meet in at most two points, so no five-set contains
two blocks (q=9: 30 and 180, matching C219's row). Higher layers satisfy
`a_k = binom(q+1,k) - (number of block-free k-sets)`, so the whole nucleus reliability table is
equivalent to the block-free ("harmonic arc") enumerator, with C218's independence number five
the q=9 boundary (`a_6 = binom(10,6)` there). The general harmonic arc number `alpha_4(q)` is a
bounded additive-geometry question exactly parallel to the axis zero-sum-free problem C220
deliberately left unopened; it should get the same treatment (separate allocation, sharp entry
conjecture) rather than opportunistic growth.

Separately, C219's Poisson windows can be upgraded to quantitative statements with zero new
combinatorics: the same two overlap counts feed the Arratia--Goldstein--Gordon /
Barbour--Holst--Janson bounds, giving explicit total-variation rates `O(n^(-1/4))` at the window,
and Janson's inequality gives the sharp lower-tail exponent below it. Worth one paragraph in any
paper section that states the windows.

### R9. Item 6 is batch/PIR service theory, plus one LP

**Confidence: medium; framing plus a bounded computation.**

The invariant item 6 wants mostly exists: serving several targets under per-helper capacity is
the regime of batch codes (Ishai--Kushilevitz--Ostrovsky--Sahai), PIR codes
(Fazeli--Vardy--Yaakobi), and switch codes, and the proposed scheduling polytope is the
fractional batch LP. What the port framework adds is exact computability on structured examples,
plus the clean separation instance: at every curve target of C218 the single-target row is
`(nu,tau)=(1,1)` with zero integrality gap, yet the common nucleus caps simultaneous service at
one, so availability-style invariants are gap-free while batch throughput collapses. Bounded
probe: collapse the harmonic port's service LP by the `PGL(2,q)` symmetry (variables per block
orbit) and compute the exact multi-target capacity region; positive association (FKG) already
gives the probabilistic side for free, so the genuinely new content is capacity, not
correlation.

### R10. Where the partition-function program should stop

**Confidence: proved remark plus program advice.**

C226's expansion (8) contains the Gaussian-binomial sector: the coefficient of `p^q` grows like
`3^(h^2/4)`, quasi-polynomially in `q`. Consequences: no fixed-degree polynomial-in-q closed
form exists beyond the first layers; the reliability curve genuinely encodes the subgroup
lattice (it would distinguish elementary-abelian parameter groups from cyclic ones, sharpening
the "two-way bridge" claim of item 1); and the defect-two classification will mix near-coset
perturbation classes, so exact classification should stop at `delta <= 2` and switch to
container/Green--Ruzsa structure for `delta <= eps*q`. Contrast worth stating: the axis factor's
cap sector has no subgroup degeneracies, so the two transforms have qualitatively different
coefficient growth.

### R11. The configuration engine's organizing invariant is the anharmonic orbit

**Confidence: exploratory, sharply bounded.**

Item 20's "coincidence" is a theorem-shaped fact: the cross-ratio orbit
`{lambda, 1/lambda, 1-lambda, ...}` of the harmonic value collapses to a singleton exactly in
characteristic three (where harmonic and equianharmonic merge). Unique triple-completion, i.e.
Steiner behavior for a PGL-invariant quadruple rule on `P^1`, therefore exists only in
characteristic three: C218 is not one instance of a family of Steiner outputs, it is the only
one. Elsewhere the same loci give multi-fold systems (three-fold harmonic quadruple systems in
characteristic at least five, two-fold equianharmonic systems when `q = 1 mod 3`), which are
availability-style design candidates, but Gmainer--Havlicek's digit criterion kills the quartic
nucleus for `p >= 5`, so those systems currently lack a represented carrier. The one remaining
in-range engine target is characteristic two, degree four, where the nucleus is a full line: a
different port shape (plural nucleus) and the natural bounded second scout if the engine is ever
opened. Running the engine as "pick a lambda-locus, then consult the nucleus classification for
a carrier" replaces isolated searches, which is what item 20 asked for.

## Part II: critiques

**Item 7 (complexity transfer).** As stated it is vacuous: C216 fixes the inner code, so every
transferred port has constant size and all its invariants are O(1). The universality reading
(global goodness does not constrain bounded-radius local behavior) stands and is the right
headline. A real complexity transfer needs a scaled C216 with inner length growing (say
polylogarithmically) under a uniform confinement bound; that is the actual open reduction and
should be stated as such. Family-level hardness needs no transfer at all: graphic instances of
the complete port are exactly two-terminal reliability, so pointed reliability is #P-hard
(Provan--Ball), and via R1's duality, minimum-blocker computation contains
minimum-weight-codeword-through-a-coordinate, NP-hard by Vardy. Those two sentences give item 22
its hardness half for free.

**Item 19 (network/index gadgets).** The standard reductions consume the abstract matroid, so
two representations of the same matroid produce identical instances: holonomy cannot affect
solvability through them. C228's Veronese lesson generalizes this: any criterion that factors
through a matroid functor is holonomy-blind unless a derived matroid (tensor square, higher
Schur powers) varies within the support class, which is R5's probe. Characteristic fingerprints
do survive the reductions, but that half must be positioned against Dougherty--Freiling--Zeger,
who already built characteristic-dependent networks; the repair-semantics packaging is the new
part. To make holonomy itself matter, the instance must pin coefficients (receivers holding
fixed linear combinations), which is a new gadget class, not the cited reductions.

**Item 3 (secret sharing).** C228 settles the dealer convention; add two sentences when this
becomes a paper section. First, Brickell--Davenport ideality means a random coalition is either
qualified or learns nothing, so the reliability polynomial is the entire random-coalition story:
reconstruction probability `R_x(s)`, perfect privacy probability `1 - R_x(s)`, no middle ground.
Second, by R1 the unqualified-side structure is Massey's minimal-codeword description. The C216
corollary (prescribed ideal access structures at positive density inside asymptotically good
codes) is worth a theorem box, but audit against Cascudo--Cramer--Xing's asymptotically good
multiplicative LSSS program and Agarwal--Mazumdar's locally repairable secret sharing before any
novelty wording.

**Item 6 (congestion).** "A new invariant is required" is half right: the invariant class exists
(batch/PIR service), R9; the new content is exact port-level computability and the
availability-versus-throughput separation, not the polytope concept.

**Items 10 and 23 (reconstruction).** Lehman's determination needs `M` connected; state the
hypothesis wherever the full-port determination is used. For query complexity, keep the port
(all circuits through `x`) sharply distinct from one basis's fundamental circuits: wheel versus
whirl have identical fundamental-circuit data at a basis yet differ as matroids, so
reconstruction procedures must consume port data or coefficient data, and the coefficient side
is C217's cycle-rank worth of holonomies. Item 23's question list should say which oracle it
means in each bullet.

**Items 13 and 26 (fingerprints).** No longer hypothetical: R6 is a proved support-level
certificate excluding all `q = 2 mod 3` alphabets for both flagships. Reframe the strong version:
"minimal field of definition" is not well ordered across characteristics; the right target is a
characteristic set plus a minimal degree per characteristic, decided by the R6 ideal
computation.

**Item 14 (cost--reliability surfaces).** Already delivered in substance by C226's equation (7)
plus its closing remark that any C215 cost cutoff can replace cardinality; the surface's
breakpoints are the distinct circuit costs. What remains is examples, not theory; fold into the
C219 zeta-transform script rather than allocating anything.

**Item 16 (GLDPC).** The brainstorm undersells how checkable step 5 is: for scalar admissible DE
systems, threshold saturation under spatial coupling is a potential-function verification
(Yedla--Jian--Nguyen--Pfister), not an open art. The genuinely open part is whether geometric
components beat SPC/Hamming mixtures at equal rate; with C226's exact component curves that is a
finite comparison. Also keep C226's boundary: component-EXIT ensembles use the full local MAP
curve; the radius-truncated hierarchy is a separate decoder model and should not be blended into
DE without saying so.

**Item 17.** See R10: classify to defect two, then switch to container-type asymptotics; the
subgroup sector already forbids closed forms.

**Item 21.** Split it: the deficit functional is computable now (R7 gives 2/77 and 23/154); the
rate-versus-locality inequality is the open half. Presenting both as one conjecture would
undersell the computable part.

**Item 22 (composition algebra).** C227 already cites Chaiken's ported Tutte framework, which
carries sum/cosum composition; audit it before proving 2-sum formulas from scratch. The hardness
direction is closed by the two sentences in the item-7 critique above.

**Item 28 (antimatroids).** At full radius the closure is matroidal (exchange, not
anti-exchange), so antimatroid structure can only live in truncated closure; and R4(d) shows the
cubic seed's truncated closure is still the matroid closure. So the antimatroid hunt needs ports
where truncation strictly loses closure; R4(e)'s harmonic witness is the first such habitat and
the right place to test the conjecture before any general theory.

**Editorial.** The brainstorm's breadth warning is now easy to act on, because the spine exists:
one object (the complete pointed port), three exact calculi (C215 cost, C226
reliability/partition functions, C227 polynomial), two geometric flagships (cubic and harmonic),
one replication theorem (C216), and a delimitation of what coefficients add beyond supports
(C217 positive, C228 negative). Everything else in the brainstorm should appear once, in a
closing programs section, carrying the nonclaims list verbatim.

## Part III: landing tips

### Paper-ready additions, revised

Brainstorm additions 1--2 are executed (C226, C227). The strongest remaining bounded additions,
in order:

1. **Pointed-distance table (R1).** One lemma (blockers = minimal primal codewords through the
   coordinate), one section-counting proposition, and C219's q=9 tables become corollaries with
   all-q generalizations. Cheapest compression available to the manuscript.
2. **Access-structure section (item 3) done right.** C228's convention box + the
   Brickell--Davenport dichotomy sentence + Massey via R1 + the C216 theorem box with the
   audited novelty wording.
3. **Deficit numbers and the area ledger (R7).** State `2/77` and `23/154`, the ledger identity,
   and the open inequality as separate claims.
4. **Joint-law box (R3).** The master enumerator, the char-3 line lemma, and the exact two-target
   law with the FKG comparison; three displays, no new machinery.
5. **Concatenated floor corollary (items 11/24).** Under C216 embedding the N inner blocks are
   genuinely independent, so the local-decoder failure floor is exactly
   `1 - (1 - Q_inner(p))^N = N b_tau p^tau (1+o(1))`: a free, exact finite-length statement
   combining C219 blocker counts with C216 replication.

### Probe plans

- **C229 (active).** Import R4 wholesale: the conjunction one-liner for level one; the sigma-rule
  circuit table as the forward-chaining rule set; witness (c) for one-shot < sequential; theorem
  sketch (d) for sequential = span on the cubic seed; witness (e) for sequential < span on the
  harmonic family. Suggested verification: one BFS-closure script over the committed C202/C218
  geometries with (c) and (e) as unit tests; (d)'s case analysis is the compact general
  proposition the gate asks for.
- **Characteristic audit (gated).** Do R6's citation-level step first; it may satisfy "field
  dependence becomes load-bearing" on its own. The residual `Z[omega]` Groebner computation is
  the only open-ended part; cap it by point count (eleven) and frame (five points fixed).
- **GLDPC (gated).** Order of operations: exact multitype component curves from C226's
  transforms; density evolution against SPC/Hamming mixtures at equal rate; only then the
  potential-function saturation check. Stop if the equal-rate comparison already loses.
- **Holonomy/MPC follow-on (R5).** One script: `[8,3]` GRS versus generic eight points, support
  `U(3,8)`, run C228's criterion with two-party adversary sets. Report either the first
  MPC-visible holonomy separation or the boundary one rank up.
- **Harmonic arcs (R8).** Only with a sharp entry conjecture on `alpha_4(q)`, mirroring C220's
  stop rule; the q=9 value is five and the design gives `a_4, a_5` for free.

### Literature anchors not yet in the reports

| Anchor                               | Feeds        | Why it is load-bearing                                   |
|--------------------------------------|--------------|----------------------------------------------------------|
| Massey, minimal codewords            | item 3, R1   | blocker clutter = minimal codewords through a coordinate |
| Provan--Ball; Vardy                  | items 7/22   | #P/NP baselines once ports subsume s-t reliability       |
| Britz (Greene extensions)            | R2           | split weight enumerator likely already proved            |
| Mirandola--Zemor; Couvreur et al.    | R5, item 18  | square-dimension separations at fixed support            |
| Cascudo--Cramer--Xing                | item 3       | novelty boundary for good + multiplicative LSSS          |
| IKOS batch codes; Fazeli--Vardy--Yaakobi | item 6, R9 | existing home of multi-target service invariants        |
| Barlow--Proschan / Birnbaum          | items 5/27   | pivotal influence = Birnbaum importance; hardening theory |
| Dougherty--Freiling--Zeger           | item 19      | characteristic-dependent networks already exist          |
| Yedla--Jian--Nguyen--Pfister         | item 16      | saturation via potential functions is a verification     |
| Arratia--Goldstein--Gordon; Janson   | R8           | quantitative Poisson windows and lower tails             |
| Oxley on AG(2,3); Hesse              | R6           | the support-level characteristic exclusion               |

### Verification discipline for this note

Every numbered claim above that touches the committed geometries (R1's table, R3's joint law,
R4's rule table and witnesses, R7's two fractions, R8's `a_5`) is an immediate calculation that
must be replayed against the existing C202/C218/C219/C226/C227 artifacts, plus one q=27 spot
check for the R1 rows, before promotion into any report or the paper. None of them requires a
new census.

## Explicit nonclaims

This response does not establish:

- the split-enumerator Greene theorem for perspectives (R2 may reduce to citation);
- the written-out sequential-equals-span theorem for the cubic seed (R4(d) is a sketch);
- the rate-plus-deficit inequality (R7's open half);
- any strong-multiplicativity separation at `U(3,8)` (R5 is a probe, with both outcomes useful);
- representability conclusions beyond the AG(2,3) exclusion (R6's residual cases are open);
- any batch/PIR construction, GLDPC threshold, or antimatroid theorem;
- priority for any observation here; the none-found convention of the reports applies.

Disposition is the user's: nothing here allocates a task, and C229's active gate remains the
lane's next step.
