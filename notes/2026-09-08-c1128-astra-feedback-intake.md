# C1128 intake: Astra feedback and extensions

Date: 2026-09-08. Lane: `cubic-threefolds`.

## Status and provenance

The author requested a new C ID for the supplied feedback and research
extensions. C1128 owns their audit and disposition. The author then clarified:
the follow-on work is a mathematics/literature audit first, before deciding
what, if anything, goes into the manuscripts. All implementation suggestions
below are therefore proposals for disposition, not authorized manuscript edits.
This note is a structured
capture of the pasted conversation, not a verbatim transcript or a mathematical
review. All assertions below attributed to Astra remain supplied claims until
the task audits them. Intake has not replayed either mathematical checker,
run repository verification suites, read the cited external sources, or run Lean.

The review names standalone revisions `3d200fc` (one stabilization) and
`b9876e6` (sharpness). Astra reports reading both complete primary manuscripts
and their appendices/certificates, independently checking selected algebra,
and finding no definite mathematical error. It explicitly disclaims complete
repository or Lean verification. It identifies the first paper's faithful
coefficient/connection comparison as the largest specialist review burden,
and the second paper's descent and uniform tangent-open argument as its main
geometric burden. The second paper's exactness imports the first's lower bound;
the claimed upper-bound proof is independent of it.

Five attachments are preserved byte-for-byte in
`notes/cubic-threefolds-tasks/c1128-astra-feedback-inputs/`:

- `stabilization_extension_checks.py` and `.json`;
- `followon_family_checks.py` and `.json`;
- `followon_family_proof.md`.

`manifest.json` records original Download paths, sizes, SHA-256 hashes and
unverified-input status. Both JSON files parse and both scripts compile as
Python syntax. These checks do not validate their mathematical output.

## Review findings to retain

Astra reports checking the cubic residue
`[[-19/18,2],[-8/81,1/18]]`, eigenvalues `-1/6,-5/6`, and discriminant
`4/9`, including the basis change and first gauge correction. It emphasizes
whole generic primary summands, rather than selected Jordan blocks; the
divisor-equation-reduced source and independent target exponential characters;
connection/pairing rather than algebra-only comparisons; persistence before
small-to-big transport; and separation modulo integers rather than merely
nonzero discriminant. It treats the motivic extension as an additive group
invariant on `K0(Var_C)/(L-1)`, not a ring map or stable-birational invariant.

For sharpness it reports checking saturation of the index-two sign lattice,
unique orbit correction for descent, singular-compatible tangent projection,
all four Jacobian minors and tangent determinants, and all eight localized
cases covering `ab(a-1)(b-1)(a-b) != 0`. Reported rank-four arithmetic:
stacked ranks `(5,4,5,5)`, character `(-1,-1,-3,-3,3)`, sixteen restricted
weights, and 1,992 unimodular five-subsets out of 4,368. Galois stability
remains a separate condition. Finite-index parametrization degree divides
the index; it need not equal it.

Record for later source verification: Astra flags Cai p.4 as omitting a
factor of two in prose; it claims the matrix gives `±6 sqrt(3) q^(1/2)`,
while Cai prints `±3 sqrt(3) q^(1/2)`. Do not announce an external erratum
without checking the cited version. The review's formal-coverage numbers
(first: 5 absent, 6 fragments, 9 conditional, none complete; second: no Lean
formalization of new results) describe those snapshots, not future coverage.

Editorial percentile bands supplied by Astra, first/second paper respectively:
significance 98–99+/97–99; originality 90–96/93–98; depth 93–98/90–96;
completeness/auditability 83–92/90–96; clarity 75–85/80–90;
economy 65–78/70–83; reproducibility 88–95/97–99; attribution 95–99/95–99.
These are subjective comparisons with serious contemporary research preprints,
not correctness probabilities or acceptance forecasts.

## Editorial requests A–H

A. In `sections/01-introduction.tex` and the start of `02-qdm-marker.tex`,
lead with intrinsic scalar operations and the fourfold contradiction. Display
`I(Bl_Z Y)=I(Y)+(c-1)I(Z)` and `I(P_Y(V))=rk(V)I(Y)`; explain cubic value
one, product value two, projective-space value zero, and surface-center
vanishing. Move the free block monoid and formal diagrams to a short
generalization subsection after the core proof route.

B. Immediately before `lem:faithful-center-base-change`, consolidate reduced
graded source coefficients, independent target divisor variables per occurrence,
common comparison ring/fraction-field maps, inverted/ramified Novikov and
exceptional variables, derivations, z-regularity of comparison and inverse,
and permitted common scalar grading shifts. Explain the toy distinction
`x,y -> q` versus `x -> q exp(s), y -> q exp(t)`, with source coefficients
independent of target `s,t`. Audit completion and Vandermonde requirements.

C. Split `prop:rank2-rigidity` into named cyclic double-primary persistence
and regularity/conjugacy of the modified residue, `partial R=[G_partial,R]`.
Do not make constancy conditional on an unproved persistent block.

D. Replace the main radical cubic reduction in `prop:cubic-block-data` with
the rational universal calculation below, grouping `im(U^2) + ker(U^2)`.
Retain the radical calculation as an independent appendix check if useful.

E. After `eq:atomic-fold`, distinguish `delta != 0` (distinct canonical
residue representatives) from `delta notin {n^2:n in Z}` (distinct exponent
classes). The former requires canonical-lattice preservation.

F. In sharpness Section 3, explain the selected unimodular simplex through
its étale algebra, then print the splitting-field correction
`(t1,t2,t3)=(kappa3/kappa0,kappa3/kappa1,kappa3/kappa2)` and descent by
uniqueness. Verify the basis and ratio conventions first.

G. In `prop:tangent-section`, distinguish geometric existence over every
smooth parameter, meeting the relative tangent-projection isomorphism locus,
and arithmetic descent using density. Move the existing dimension calculation
`7-3=4=2+2` immediately after the surface theorem, without duplication.

H. In the inverse-graph discussion and verification guide, distinguish
effective existence from executable number-field maps: descended pair `p,x`,
slice equations, generic torsor trivialization, residual coordinates, and
forward/inverse maps with open conditions. Retain `residual_actions` in
`derive_slice_cover.py`'s returned certificate and print its basis convention.
Deduplicate this request against the much more advanced C958 map work.

## Proposed stronger invariant and unified calculation

Define `I_lat` by counting whole generic rank-two primary summands with
nonzero square-zero centered leading term and `delta^sharp != 0`; allow
integer exponent differences. Proposed stronger spectrum:
`S_lat(Y)=sum_E e_(delta^sharp(E))` over these blocks. Proposed transport
uses z-regular comparisons preserving the original lattice and its canonical
modification, plus low-dimensional discriminant zero. An arbitrary meromorphic
gauge is insufficient. Check all operations, including inverse comparisons,
grading changes, persistence, and surface vanishing in the resonant case.

For `s=2a+b`, `sq != 0`, the supplied connection is

```text
z^2 d_z y=(U+zD)y,
U=[[0,aq,0,a^2q^2],[1,0,bq,0],[0,1,0,aq],[0,0,1,0]],
D=diag(3,1,-1,-3)/2,
det(T-U)=T^2(T^2-sq).
v1=(0,-aq,0,1), v2=(-(a+b)q,0,1,0), Uv2=v1.
R=[[-(2a+3b)/(2s),1],[-4a^2/s^2,(b-2a)/(2s)]].
delta^sharp=4(b-2a)/(b+2a).
```

The first off-diagonal Sylvester equation is
`J_j X_ji-X_ji J_i=-D_ji`; for `U+zD+z^2F+...`, the proposed next
diagonal coefficient is `F_ii+sum_(j!=i) D_ij X_ji` in the specified gauge.
Audit the derivative term and the convention for this coefficient.

| Family | (a,b) | Residue eigenvalues | delta | I_exp / I_lat |
|---|---|---|---|---|
| Degree-one del Pezzo threefold | (240,1248) | 1/6, -7/6 | 16/9 | 1 / 1 |
| Quartic double solid | (48,160) | 0, -1 | 1 | 0 / 1 |
| Cubic threefold | (24,60) | -1/6, -5/6 | 4/9 | 1 / 1 |

Proposed quantum source: Przyjalkowski Theorem 2.6.6 in the anticanonical-power
basis; exact bibliographic identification and normalization still required.
Degree one is the smooth sextic in `P(1,1,1,2,3)`; degree two is the quartic
double solid. Proposed conclusion: every smooth complex Picard-rank-one
del Pezzo threefold of degree 1, 2, or 3 stays irrational after `P1`.
The degree-one route uses the old count; degree two needs the stronger count.
With classical rationality in degrees 4 and 5, the proposed index-two
classification is `V x P1 rational iff V rational iff H^3 in {4,5}`.
Verify the classification source and restrict this headline to complex fields;
do not extend rationality of all forms in degrees 4 and 5 by descent.

Other proposed consequences: characteristic-zero forms inherit the lower
bound by finitely generated descent; the three stabilized degrees have
spectra `2e_(delta_d)` and are mutually nonbirational if stronger transport
holds. Degree one and cubic have equal unordered exponent classes but different
canonical discriminants, illustrating what the lattice would retain.

Arithmetic refinement: build a rational coefficient model, prove the
discriminants algebraic and the counted multiset Galois stable, and obtain
`P_Y(T)=prod_E(T-delta_E) in Q[T]`, with blowup multiplication and projective
bundle powers. Proposed bound:
`[Q(delta):Q] <= number of counted blocks <= dim H^ev(Y,Q)/2`.
Rational GW numbers alone do not replace the constant-field/model audit.

## Structural torus and stabilization consequences

For a Galois-stable projective weight simplex `Omega` of size `r+1`, the
augmentation lattice maps to `X*(T)` by weight differences. Unimodularity
would identify `T=Res_(E/k) Gm / Gm` for the corresponding étale algebra.
Its variety is the norm-nonzero open in `P(E)`. Finite index instead gives
an isogeny to that torus with kernel of the lattice index. Verify character
versus cocharacter direction, including common projective translations.

Supplied residual character matrices, acting on column coordinates:
`A=[[-1,0],[1,1]]`, `B=[[0,1],[-1,-1]]`. They permute
`(0,1),(1,-1),(-1,0)` with sum zero, suggesting
`T0/T3=Res^1_(E3/k) Gm` and an exact sequence with the degree-four étale
quotient torus as kernel. Audit against the actual integral action, and reuse
C958's existing cubic norm-torus coordinates before developing another chart.

For exact-level-two cubics, scaling `u,v` in
`k(X)(u,v)=k(t1,...,t5)` gives rational rank-two torus actions requiring
exactly two trivially acted-on variables to become birationally linear.
Every primitive rank-one restriction has invariant field `k(X)(u^b/v^a)`
and proposed threshold one; over C every finite subgroup quotient has field
`k(X)(r1,r2)` and is rational. These are rational actions, not regular
polynomial actions on affine space. General proposal: an exact-level-s
variety gives rank-r subtorus restrictions with exact threshold r. Check
Popov's prior invariant-field criterion and distinguish these thresholds
from his already known nonlinearizable rank-two examples in Cr_5.

Additional candidates for proof/disposition:

- Additive ceiling: birational invariance in dimension n+2 plus the global
  blowup formula forces `J(X)=0` for every n-fold, by blowing up
  `X x P2` at `X x {p}`. The projective-bundle formula is unnecessary for
  this cancellation argument. This limits that architecture, not every method.
- If `Q ~ Y x R`, `dim R=d`, `ell(R)=a`, `ell(Q)=b`, proposed bound
  `ell(Y)<=d+max(a,b)`. Optimize over residual tori with certified finite levels.
- Finite-index slice gcd D and universal A0 annihilation may yield
  `D Delta_Q=D(Q x q)+Z`, with Z supported on a proper first-factor subset.
  Audit smooth proper model, rational point and function-field hypotheses.
- Product bound for finite levels:
  `ell(X x Y)<=min(max(sX,sY-dim X),max(sY,sX-dim Y))`;
  powers cannot amplify finite stabilization depth.
- Higher-ceiling problems: cubic levels in `{2,infinity}` versus a higher
  finite-level example; universally CH0-trivial but stably irrational cubics;
  explicit weak-factorization centers contributing the required spectrum.
- Spread fixed rationalizations and inverses over `Z[1/N]` for almost-all-prime
  upper bounds. Do not claim the quantum lower bound or exactness spreads.
- Computational directions: certified symmetry reduction through saturated
  weights/slices/descent and explicit maps; exact finite-jet quantum-residue
  library. Compare against Duff–Korotynskiy–Pajdla–Regan symmetry/SNF work
  and quantum-period data with proper input limitations. Expression size,
  elimination degree, branches, runtime, checking cost and conditioning need
  measured benchmarks before commercial claims. No cryptographic or quantum
  computing application follows from the irrationality statements.

## Proposed moduli follow-on

The verbatim attached proof note supplies the full proposed argument and all
formulas. Its central family is

```text
X_B: (z-x)u^2+6yuv+3(z+x)v^2-z^3
     +(3/4)(x^2+3y^2)z+B(x,y)=0.
B=lambda x^3+mu x^2 y+nu y^3 for the three-parameter subfamily.
C_B: eta^2=16 B(x,y)^2-(x^2+3y^2)^3.
```

Proposed result: every smooth X_B has exact level two over any
characteristic-zero field and after every field extension. Projection to
`[x:y]` gives the supplied two-quadric surface with a rational point and pencil
determinant `(3/4)(t^2-A)(t^3-(3/4)At-beta)`. Audit squarefree determinant,
the birational presentation, and signed Galois containment in type I3, including
reducible specializations and splitting-field intersections. Stable permutation
must be transferred for the actual Picard action, not inferred from group order.

Supplied finite checks at B=y^3: all coordinate sixth powers lie in the
homogeneous Jacobian ideal; GL5 orbit tangent rank 25 increases to 28 under
the three cubic deformations. Binary sextic GL2 orbit rank 4 increases to 7
under the three derivatives. These support, subject to audit, a
three-dimensional unirational cubic locus and a dominant generically finite
map to genus-two moduli. Verify the moduli interpretation, not only ranks.

The identity `(eta-4B)(eta+4B)=-q^3`, `q=x^2+3y^2`, proposes nonzero
`tau=[D-H] in Jac(C_B)[3](k)` with `div((eta-4B)/y^3)=3D-3H`.
Audit the divisor at infinity, squarefree/open conditions, rationality of the
divisor class and nonzero argument. Neither intrinsic recovery from an unmarked
cubic, degrees/birationality of the moduli maps, nor a specified intermediate
Jacobian factor is established by the supplied note.

Further gates: specialization of rationality along smooth proper families
before claiming smooth points in the locus closure still have level two;
primary-source justification of birational versus isomorphism classes of cubic
threefolds before claiming a three-dimensional family of nonconjugate tori;
descent/markings of the selected 3-torsion structure; compatibility with the
non-Eckardt involution `[u:v:x:z:y] -> [-u:-v:x:z:y]` and existing Prym
period-map work. Proposed working title: “Sharp stable rationality in cubic
moduli and genus-two level structures.” It is a proposal, not an allocated
new manuscript. Highest-EV recommendation from Astra: intrinsic locus/period
geometry; highest ceiling: determine whether higher finite cubic levels exist.

## Publication advice retained as opinion

Astra favors Inventiones first, JAMS as a serious alternative, Annals as an
ambitious defensible target, Duke/JEMS as strong alternatives and JAG as a
natural separate constructive-paper venue. It argues the original uniform lower
bound plus sharp construction already makes a major case if correct; the
resonant invariant and full index-two application broaden it substantially.
The proposed improvements do not establish acceptance likelihood. It recommends
coordinated papers if that improves refereeability, with torus consequences
secondary and commercial speculation outside the publication pitch.

## Source pointers supplied in the conversation

These are provenance pointers for the future audit, not consulted citations.

- Reviewed m1 tree: `https://raw.githubusercontent.com/tavisrudd/cubic-stabilization-m1/3d200fc/`;
  `REVIEWER_GUIDE.md`, `sections/01-introduction.tex`, `02-qdm-marker.tex`, `04-motivic.tex`.
- Reviewed sharpness tree: `https://raw.githubusercontent.com/tavisrudd/cubic-stabilization-irrationality/b9876e6/`;
  manuscript, `REVIEWER_GUIDE.md`, `verification/slice-cover-values.tex`.
- Iritani: arXiv `2307.13555v3`; Voisin: `1407.7261v2`;
  Cai: `2608.01577v1`; Tschinkel–Zhang: `2608.20029v2`, especially
  Proposition 4.1, Lemma 4.2 and Proposition 5.3 per the attached note.
- Popov: `1110.2410v4`; index-two classification/rationality: `1911.08949v3`;
  Engel–de Gaay Fortman–Schreieder: `2507.15704v3`.
- Nicaise–Ottem: `2004.08161v3`, Theorem 4.1.1 per the attached note;
  Casalaina-Martin–Marquand–Zhang: `2210.14397`;
  Kuznetsov: `math/0303037v1`, Remark 2.19 per the attached note.
- Venue precedent: Voisin, DOI `10.1007/s00222-014-0551-y`; Totaro,
  “Hypersurfaces that are not stably rational” (JAMS), as supplied.
- Przyjalkowski Theorem 2.6.6, the SL3 Cayley construction, and the
  Duff–Korotynskiy–Pajdla–Regan benchmark source need exact source identification.

## Intake closeout and continuation

Next: audit the canonical-lattice comparison, informed by the prior
2026-08-21 narrowing to exponent classes recorded in the lane handoff.
This is a task dependency to investigate, not a new objection asserted here.
Existing C958 work already identifies the residual cubic norm torus, so reuse
its accepted evidence when disposing of that proposed extension.

Process record: the first full handoff read exceeded the output bound and was
truncated. It was replaced with explicit line-range reads; an aggregate batch
also truncated, and the missing middle was recovered in a smaller read.
Future handoff access should remain chunked. No mathematical claim was accepted
from truncated output. This intake is administrative; the substantive ej+tt
pass and Mystery ledger belong to the research acceptance gate, not this allocation.
