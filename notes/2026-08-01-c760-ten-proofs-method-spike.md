# C760 — *Ten Advances* reusable-method spike

**Lane:** `gem-mining`

**Status:** COMPLETE FIND-PASS — provisional until the lane's user-launched independent vet

## Verdict

Neither named transplant reaches a current frontier in its present form.

1. **KILL for passant arcs:** the moving-projection certificate is intrinsically scalar and
   two-point.  Every passant line is a pairwise-passant set of size `q+1`, so no certificate whose
   only code hypothesis is pairwise admissibility can prove the exact arc bound six.  The smallest
   certified control, `q=13`, already has a 14-point pairwise-passant line versus maximum arc size
   six.  The same obstruction applies at `q=17,19` with line cliques of sizes 18 and 20.
2. **KILL for the current data:** the reconstruction lemma requires a whole evaluation-indexed
   family of bounded sets and *every* power sum through at least `2K-1`, with one polynomial of
   degree at most `dj` for the `j`th moment and a strong evaluation-set inequality.  The
   Reed--Solomon determinant atlases are fixed-support syndrome/edge-label fibres, while the conic
   matching quotient is an exact factorization fibre; neither supplies those hypotheses.
3. **HOLD-LOW, do not promote:** proof #2 has a literal input dictionary for C737's spherical-code
   relaxation of equiangular lines in dimension 18, but it forgets the signed/equiangular equality
   constraints and bounds the much larger one-sided class `A(18,1/5)`.  No evidence here puts that
   relaxation in the required `57--59` window.

The spike used no new computation.  Its finite controls are the already certified C725 orbit-DAG
theorem and C611's exact root-edge rational relaxation.  Consequently no new replay artifact or
certificate is needed.

## Source and read boundary

The source is OpenAI, *Ten Advances in Mathematics and Theoretical Computer Science* (2026),
official PDF `https://cdn.openai.com/pdf/ten-proofs-oai.pdf`.  The cached full text is keyed as
`openai:ten-proofs-oai`; the PDF has 249 pages and SHA-256
`64b900d5fae6fe22f2ae1b8e3b712d20055194a6c81cf343a2455e5898ac7dd6`.

- **Proof #2:** read Chapter 2's introduction, Proposition 4.1 and its proof, Theorem 4.2 and its
  construction, and the transition/overlap discussion in Sections 4--6.  The load-bearing source
  statement is Proposition 4.1, not the asymptotic optimization.
- **Proof #7:** read Chapter 7's reduction overview and Section 4 through Definition 9, Lemma 10,
  and the reconstruction proof.  The load-bearing source statement is Lemma 10.
- **Other proofs:** screened at abstract, contents, main-theorem, and proof-overview depth; the
  plausible interfaces in proofs #1, #5, #9, and #10 were read through their mechanism summaries.
  No novelty or absence-of-prior-work claim is made.

## Test 1 — moving projections

### Exact source object

Proposition 4.1 starts with a set `X`, unit vectors `ell_x` with scalar coordinate
`t(x,y)=<ell_x,ell_y>`, rank-`d` orthogonal projections `P_x` on a `D`-dimensional Hilbert space,
and an isometry

```text
B : V -> W tensor V
```

such that, for every `u` in the image of `P_x`,

```text
B*(ell_x tensor u) = sqrt(Lambda) u.
```

The overlap is the nonnegative scalar kernel

```text
K(x,y) = tr(P_x P_y) = ||P_x P_y||_HS^2.
```

The residual Gram identity is

```text
(t(x,y)-s)K(x,y)
  = (Lambda-s)K(x,y) + <Theta_x,Theta_y>_HS.
```

If every distinct pair in a code satisfies `t(x,y) <= s` and `Lambda>s`, summing this identity and
using trace Cauchy--Schwarz yields

```text
|C| <= ((1-s)/(Lambda-s)) (D/d).
```

Theorem 4.2 obtains the projections from a transitive group `G`, point stabilizer `H`, an
irreducible `H`-module `E` occurring with multiplicity one in each selected `G`-module, and a
connected nonnegative coordinate-transition graph.  Its Perron eigenvalue is `Lambda`.  These are
all proof objects needed for a finite analogue; the large formal development is not needed.

### Finite dictionary

| Source | Conic model |
|---|---|
| `G` acting transitively on `X` | `PGL(2,q)` acting on one internal/external off-conic orbit |
| `H=Stab_G(x)` | off-conic point stabilizer |
| scalar `t(x,y)` | a zonal/orbital coordinate intended to put every passant pair below `s` |
| moving `H`-subspace `E` | an `H`-type inside selected real permutation constituents |
| transition graph and Perron root | multiplication by the chosen orbital coordinate between constituents |
| code | a pairwise-passant point set |

This dictionary is exact only for the **passant clique** relaxation.  It is not a dictionary for an
arc, because an arc additionally forbids collinear triples.

### Smallest control and obstruction

On any passant projective line all `q+1` points are off the conic, and the join of every two is that
same passant line.  Thus the entire line satisfies every pairwise-passancy hypothesis.  Any valid
scalar two-point certificate must therefore allow

```text
q=13: 14 points,   q=17: 18 points,   q=19: 20 points.
```

C725 independently certifies that the largest *arcs* in all three fields have size six and gives
complete obstruction assignments for every terminal rooted arc.  Hence the failure precedes every
choice of representation, projection rank, or transition weights: the source input category has
forgotten the target predicate.

The comparison with C611 is quantitative.  After fixing a passant root edge, the natural rational
LP remembers forbidden pairs and line capacities.  Its exact optimum is

```text
min(r(a),r(b)),
r(external)=(q-3)/2,   r(internal)=(q-1)/2.
```

It therefore returns `5 or 6` at `q=13`, `7 or 8` at `q=17`, and `8 or 9` at `q=19`, while an
extension certificate needs at most four further points.  The moving-projection method is weaker
at the semantic level: its scalar pair sum does not even contain the capacity-two constraint on a
line away from the root.

### Precise missing identity

There is no missing scalar transition coefficient to compute.  Equation (51) sums only functions
of ordered pairs, whereas the first unrepresented target event is

```text
u,v,w pairwise passant but collinear.
```

The needed object is a projection/kernel indexed by a rooted pair or flag whose overlap depends on
a **triple orbit**, together with transitions that preserve extension compatibility and coverage.
That is a basepoint-fixed matrix-valued three-point certificate (or a pair-state lift), the class
the source introduction explicitly distinguishes from its moving scalar two-point construction.
C725's root-edge orbit DAG supplies exactly the finite compatibility/coverage data such a lift
would have to compress.  Building that lift is a different method and belongs to the owning
manuscript lane only after the independent vet.

### Adjacent C737 check

Orienting equiangular lines of common angle `1/5` gives a spherical code input at `(n,s)=(18,1/5)`,
so Theorem 4.2 is formally applicable.  However C737 needs the two-sided condition
`|<x,y>|=1/5` and exact Seidel-spectrum arithmetic.  The source retains only `<x,y><=1/5`.
Without a finite transition evaluation that reaches at most 59, this is a semantic match but not a
promotable lead.

## Test 2 — bounded polynomial-moment reconstruction

### Exact source object

Write the finite base field as `F` and the integer fibre cap as `K0`.  Definition 9 gives evaluation
points `P subset F`, unordered sets `S(p) subset F`, and moments

```text
m_j(p) = sum_{w in S(p)} w^j,        0 <= j <= T.
```

The hypotheses are:

- `|S(p)| <= K0` for every `p`;
- for every `0<=j<=T`, one polynomial `mu_j(X)` satisfies
  `mu_j(p)=m_j(p)` for all `p` and `deg(mu_j)<=d*j`;
- `d*T < |P|`, `T >= 2*K0-1`, and
  `|P|-d*K0*(K0-1) > 2*d*K0^2*T`.

Lemma 10 sets `h=max_p |S(p)|`, proves the size-`h` Hankel determinant nonzero, solves one Hankel
system over `F(X)`, and obtains a monic separable polynomial `G(Y)` of degree `h`.  In a finite
separable splitting field its distinct roots reproduce **all** moment polynomials through `T`; at
every maximum-size fibre, specialization recovers exactly `prod_{w in S(p)}(Y-w)`.

The proof uses the complete consecutive moment range twice: moments through `2h-2` make the
Vandermonde/Hankel determinant, and the recurrence plus the quantitative abundance of maximum
fibres propagates the identities through `T`.  A few aggregate moments are not a weakened form of
the lemma's input.

### Reed--Solomon atlas dictionary test

The closest-looking objects are syndrome power sums and C475/C476's determinant-atlas fibres.
They fail before the numerical inequalities:

- a C475 atlas fixes one support and one projective syndrome, with edge labels
  `beta_u(v_i,v_j)` and four-cycle ratios;
- its fibres are fibres of a quotient on syndrome orbits, not sets `S(p)` indexed by a common
  evaluation variable `p`;
- no current atlas supplies one unordered field-valued fibre for every `p`, nor the complete
  moment sequence `0..T` with degree bounds `d*j`.

The standard Reed--Solomon parity checks do use low power sums, but that is only vocabulary-level
agreement.  Their fixed finite syndrome coordinates do not provide the polynomial-family
coherence on which Lemma 10's specialization argument depends.  Verdict: **KILL for the current
deep-hole atlases**.

### Matching-quotient dictionary test

C403's conic quotient sends all perfect matchings of a fixed `2r`-endpoint set to the same binary
form

```text
F_S = product_{i in S}(t_i s-s_i t).
```

Its fibre has size `(2r-1)!!` and its kernel is the augmentation hyperplane generated by local
four-endpoint switches.  This is already an exact factorization theorem, not an inverse problem
from fibrewise power sums.  C403's separate first/second/third line-depth moments are aggregate
statistics of one arrangement; they are not evaluations of a common family of unordered sets.
For the actual matching fibre, Lemma 10 would moreover demand moments through at least
`2(2r-1)!!-1`, plus the degree and evaluation-set inequalities.  None is present.  Verdict:
**KILL for the current matching quotient**.

## Screen of the other eight proofs

| Proof | Source mechanism screened | Named-frontier test | Verdict |
|---:|---|---|---|
| 1 | Mellin-strip/Fourier sign-uncertainty obstruction for the Cohn--Elkies LP | The passant problem has no Fourier-eigenfunction, radial mass, or growing Euclidean dimension input; its natural zonal LP already fails on line cliques. | kill |
| 3 | Property-(T) expander decomposition, expander matching, and a Leavitt-algebra centralizer obstruction | No current gem frontier supplies approximate finite group actions plus the required centralizer configuration. | kill |
| 4 | Binary-carry compact-group structures with the same Haar action and mutually commensurable property-(T) groups | No current frontier compares group von Neumann factors or has the probability-space/group-law ambiguity used by the construction. | kill |
| 5 | Permanent lower bounds from critical loci and algebraically independent coefficients indexed by entry-disjoint short matchings | C403 is the opposite hypothesis: every perfect matching on one endpoint set collapses to one section and the matching fibre has rank one. | kill |
| 6 | Conditioning/dependency breaking plus a postselection-stable quantum sampleability estimate | No current frontier has repeated entangled games, tensor acceptance, or conditional quantum states. | kill |
| 8 | Bergman convexity for a convex body with barycenter equal to its unique interior lattice point | Neither the CVP/deep-hole atlases nor C737 provide this convex-body/interior-lattice-point input. | kill |
| 9 | Saturated random matrices, two-sided coordinate covers, separated palettes, and recursive triangle-free colorings | This constructs large multicolor Ramsey witnesses; it does not exploit the fixed `PGL(2,q)` orbitals or certify the ternary passant-arc exclusion. | kill |
| 10 | Admissible graph quotients with generalized-quadrangle witnesses, and a separate Hamming-distance/entropy construction | Generalized-quadrangle incidence is thematic finite geometry, but no theorem hypothesis maps to C159, C737, or the passant-root compatibility data. | kill |

No item survives as a promotion candidate.  C737 is the only hold, and it comes from proof #2
rather than the other eight.

## `ej` + `tt` closeout

The cheap upgrade is a representation-independent no-go statement: **every scalar two-point
certificate for pairwise passancy is bounded below by the `q+1`-point passant-line control**.  This
is stronger and cleaner than reporting a failed finite transition calculation.  The Tao-style
question is then not “which representation was missed?” but “what is the smallest change of state
that exposes the collinear-triple orbit?”  Rooted pairs or flags are plausible state lifts, but they
do not automatically make every cross-state triple pairwise; a valid construction still needs a
three-point or matrix-valued kernel and exact compatibility/coverage transitions.  C725 already
identifies the finite data that any such analytic compression must reproduce.

For moments, the cheap upgrade is the explicit anti-checklist: a future proposal is not a Lemma 10
transplant unless it names `P`, the fibres `S(p)`, `K0,d,T`, all moment polynomials through `T`, and
verifies all three inequalities.  This prevents another low-moment vocabulary match from being
mistaken for reconstruction.

### `ej2` — adjacent C756 payoff

C756 names an association-scheme or clique bound as one of two candidate routes to the all-`k`
conic-filling classification.  If that route remains a scalar pairwise scheme, C760 now kills it
uniformly: a passant/external line supplies `q+1` mutually admissible points, while the target is an
arc and therefore uses general position.  Reweighting orbitals, adding more scalar constituents, or
optimizing the Perron vector cannot repair a predicate that the pairwise relation omits.  The route
survives only if “association scheme” is upgraded to a triple/flag coherent configuration that
detects collinearity; that is a different proof object and should be costed against C756's live
type-aware spare-line and character-sum routes.  This conclusion is provisional C760 output and is
not routed into the `clebsch` lane before the independent vet.

Lemma 10 also does not repair C756's chord-moment stall.  C756 records free concurrence parameters
for `r>=4`; that is a truncated aggregate moment system, not a family of field-valued fibres with
all moments through `2K0-1` and degree-controlled interpolation across `P`.  The reconstruction
lemma consumes the missing coherent moments—it does not extrapolate them from the low moments that
leave concurrence free.

## Mystery ledger

- **Open, not promoted:** can C725's rooted-pair/flag orbit DAG be compressed into a genuine
  matrix-valued three-point projection identity?  Evidence gap: no candidate kernel, transition
  graph, or Perron/PSD certificate has been constructed.  Gate: the user-launched independent vet,
  then a separately allocated task in `clebsch` if the vet finds the route substantive.
- **Settled provisionally for C756:** its scalar association-scheme/clique route cannot prove the
  arc bound, and Lemma 10 cannot close its truncated chord moments.  The only unresolved version is
  an explicitly triple/flag-valued scheme, which is the preceding open item rather than a repair of
  the scalar route.
- **Open, low priority:** can the finite Chapter 2 transition construction at `(18,1/5)` enter
  C737's `57--59` window?  Evidence gap: no finite bound was evaluated, and the one-sided spherical
  relaxation discards the signed Seidel constraints.  Gate: independent vet before any promotion.
- **Settled for present data:** neither Reed--Solomon atlas nor matching quotient satisfies Lemma
  10.  No genuine mystery remains about this transplant; applicability would require a new
  evaluation-indexed data product, not a reinterpretation of the current certificates.

## Trust and routing boundary

This report is method-mining output and remains provisional under the lane rule.  It makes no
cross-lane source or manuscript change, launches no vet, and promotes no result.  Its finite target
facts come from `notes/2026-07-31-c725-terminal-passant-orbit-dag.md`,
`notes/2026-07-29-c611-q17-q19-coherent-certificates.md`,
`notes/2026-07-22-c475-reed-solomon-determinant-atlas.md`, and
`notes/2026-07-20-c403-arrangement-complement-distance.md`.
