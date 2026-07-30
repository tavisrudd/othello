# Clebsch three-paper program

**Lane:** `clebsch`

**Date:** 2026-07-29

> **LIVE MAP ONLY.** This is the routing and state surface for the active
> three-paper program. Detailed live task internals belong in C-task cards;
> completed and superseded detail belongs in the archives linked below.
>
> **ROUTING AUTHORITY.** No dated planning note, fallback-paper verdict, task
> report, or archive overrides the order and boundaries stated here.

## Program state

| surface | root | current state | owning task |
|---|---|---|---|
| Paper I — *Reconstructing the Clebsch code from its deep-hole syndrome locus* | `papers/clebsch-rigidity/` | final independent `GO`; local release surface green | [C182](../clebsch-tasks/c182-paper-i-release.md) |
| Paper II — *Quadratic recovery and cubic orientation in conic matching quotients* | `papers/clebsch-factorization/` | v1 theorem, editorial, cold-read, and replay gates green; public packaging remains; C665 uniform C1 is closed for v2 | [C577](../clebsch-tasks/c577-factorization-paper.md) |
| Paper III — *The Clebsch orientation cubic: arithmetic covers and icosahedral harmonics* | `papers/clebsch-covers/` | pre-release `GO`; immutable locator and author metadata remain | [C680](../clebsch-tasks/c680-paper-iii-release.md) |
| 37-page mega-paper | `papers/clebsch-code/` | preserved unchanged as fallback only | C552 if explicitly reactivated |

## Active and queued task cards

| task | state | next gate |
|---|---|---|
| [C182 — Paper I release](../clebsch-tasks/c182-paper-i-release.md) | queued on external publication authority | publish and independently replay one immutable approved package |
| [C577 — Paper II](../clebsch-tasks/c577-factorization-paper.md) | active under the C182 external-wait exception | obtain immutable locator, isolate replay, run release pass |
| [C692 — cross-sheet pairing](../clebsch-tasks/c692-paper-ii-cross-sheet-pairing.md) | queued; bounded Paper II v2 test | replace the Gorenstein pairing proof or identify the exact mismatch |
| [C693 — Paper I v2 integration](../clebsch-tasks/c693-paper-i-v2-integration.md) | ready after C691 | integrate C611/C690/C691 without importing Paper III's reveal |
| [C694 — Paper II v2 integration](../clebsch-tasks/c694-paper-ii-v2-integration.md) | queued after C692 | synthesize C665/C688/C689 and cold-read against v1 |
| [C697 — Schläfli--Hodge \(E_6\) model](../clebsch-tasks/c697-schlafli-hodge-e6-variation.md) | queued and unblocked; bounded extension kill test | recover the signed Cartan tensor and match the graded \(6|15|6\) carrier, or close on the first invariant mismatch |
| [C680 — Paper III release](../clebsch-tasks/c680-paper-iii-release.md) | pre-release `GO` | add immutable locator and author metadata, rebuild, replay |
| [C682 — Hitchin--Clebsch exploration](../clebsch-tasks/c682-hitchin-structural-exploration.md) | active; all first plateau families controlled | propagate boundary anchors and close off-peak mixing |

C321 remains conditional and is not triggered: the final Paper I review found
no missing proof obligation. C552 remains fallback-only and must not displace
the split-paper route without an explicit user decision.

## Paper I

Paper I and its companion *Computational strengthenings of Clebsch syndrome
rigidity* form one warning-free, nineteen-row release surface with sixteen
checks. C320 is complete with final `GO`. C182 owns every remaining release
action; C611 cannot reopen or delay v1.

The load-bearing theorem package reconstructs the Clebsch code from the
weight-six deep-hole syndrome locus and closes the terminal fields
q=13,17,19 by exact passant-edge-orbit searches. The shared
`deep_holes = conic` fact remains pinned to the standalone Lean repository;
the paper does not inherit trust from the fallback mega-paper gate.

C690 is complete as v2 exploration. The syndrome locus reconstructs the
unordered support-orientation torsor; on the frozen common marking its
exchange is support complementation, Gale duality, and golden conjugation,
and its first signed moment is cubic. C611 now closes the q=13 binary
minimum-distance gate by proving the exact value \(d=12\). Segre tangent
triples exclude weight eight: after one point is fixed, a cyclic 42-vertex
compatibility graph has clique number five,
while a weight-eight word would require a seven-clique. The proof is a
six-difference-set, five-row unique-closure lemma, not a support search. It
then excludes the two forced weight-ten pencil profiles and constructs a
dihedral weight-twelve word. All \(364\) minimum words split into one
\(S_4\) and three \(D_{24}\) projective orbits, and their pair concurrence
reconstructs passant versus secant join type. Triple-concurrence profiles
recover all six elliptic orbitals, and the \(78\) all-zero-triple
seven-cliques are exactly the passant incidence rows. Hence the minimum
layer self-reconstructs \(M\). Every minimum-word orbit independently spans
the full code, and the common code/hypergraph/scheme automorphism group is
exactly \(\operatorname{PGL}(2,13)\). The mod-two association algebra
identifies the four orbit Grams with \(A_9,A_9,A_{12},A_{10}\) and
conceptually forces their rank \(36\). It
does not prove the unsaturated \((7,13)\) case or the stronger maximum-six
claim, and it is not reached by C665's defining-characteristic trade
machinery. The
twelve-point Schläfli identification fails equivariantly, but both objects
map to the same six-axis \(A_5/D_5\) carrier: Paper I is its twisted
transitive two-cover and the double-six is its split two-cover. On the
twisted cover, the fibre-odd module is \(3\oplus3'\), and the difference
of the two five-orbital operators squares to \(5\) after normalization.
Thus the continuation locus intrinsically reconstructs the golden quadratic
algebra and its conjugation. Its natural fibre-odd integral commutant is
the conductor-two order \(\mathbf Z[\sqrt5]\), whose mod-\(2\) fibre is a
dual-number point and whose normalization has fibre \(\mathbf F_4\).
The signed continuation operator is exactly C682's golden Gram conference
matrix up to a signed permutation. Hence this is the same conductor defect
on the golden six-axis algebra. It is not the whole reason \(2\) is bad for
C682: the boundary operator, apolar form, and Mukai--Umemura geometry remain
bad after normalization. Locally, the \(2\)-defect and the cross-Gram
defects at \(11,23\) are the same order
\(\mathbf Z_p+p\mathcal O_p\), with inert, split, and inert normalized
fibres respectively.
The first open all-size full-conic gate is \(k=9\) over \(q=23,25\).
C691 is complete with a positive bridge.  If \(B\) is either signed
continuation orbital on the fibre-odd six-axis lattice, then
\[
 c_{ijk}=B_{ij}B_{jk}B_{ki}
\]
is exactly the support-orientation cubic.  Switching axis representatives
does not change the triangle products, orbital exchange negates them, and
the four-point two-graph identity reconstructs \(B\) up to switching.
Thus the cubic line and the golden operator \(B^2=5I\) are two
presentations of one integral orientation torsor.  Modulo \(2\), all signs
coalesce and \(B-I\) becomes rank-one square-zero, matching the
conductor-two degeneration.  C693 owns integration.
C611 is complete.  At q=17 and q=19 the maximal passant six-arcs form
respectively 22 and 94 projective orbits, all with empty extension sets.
Pair inner distributions distinguish every q=17 orbit and 92 of 94 q=19
orbits; triple distributions separate the remaining two pairs.  This is a
finite coherent compression, not a uniform theorem.  Pair-only coherence
cannot see the ternary arc condition, and the natural root-edge rational LP
has exact feasible objectives 7--8 and 8--9 against the required bound 4.
Its uniform failure is the residual-pencil product: after fixing a passant
edge, the candidate set is the Cartesian product of the two endpoints'
remaining passant-line pencils.  The resulting feasible objective is at
least \((q-3)/2\), so this first-order dual route fails for every odd
\(q\ge13\).  Summing the line constraints in the smaller pencil gives the
matching dual bound, so the LP optimum is exactly the smaller pencil size.

Local aggregate replay:

```sh
cd papers/clebsch-rigidity
./scripts/verify-all.sh
```

## Paper II

Paper II is standalone: no proof dependency on Papers I or III. Its frozen
v1 spine is the matching-secant quotient, the A3/B3/H3 configurations,
quadratic balanced-sheet recovery, cubic-first orientation,
self-association/Schur/Gorenstein structure, and the paper-owned trust
surface. C577 owns packaging and release.

C665 is complete as a strictly v2 theorem.  The q=121
`L(6) in Sym^59 L(2)` rank-\(1\)-to-\(2\) witness is the first instance of
the uniform first-wall spill
\[
L(p-2-s,1)\otimes L(p-2,1)
\longrightarrow L(0,2)\otimes L(p-2-s,1).
\]
The affine-socle criterion
\(e(p-1)/2\equiv1+s/2\pmod2\), together with the spill scalar
\(p-2-s\ne0\), closes every extension-field exceptional C1 row.  It also
shows that the \(A_4\) occurrence and the \(S_4/A_5\) occurrences occupy
opposite values of one parity bit and never coexist.  The result is
recorded in
`notes/2026-07-29-c665-frobenius-digit-spill.md`; the retired
non-equivariant Hasse pairing remains non-evidence.  This does not change
or hold frozen v1.  C688 has replaced its q=169 field-sized replay by a
generic local \(S,T,R,Y\) checker with an independent closed-form replay;
the historical q=169 certificate remains corroboration only.  C689 has
also unified the residual \(B_3/H_3\) radial witnesses: the unique
cross-sheet pair through an edge is one alternating-cycle
\(c\leftrightarrow c^{-1}\) exchange, and a single Dickson recurrence
forces its deepest radial trace to be nonzero.  Its cross-incidence design
is the circulant Paley complement, with \(4\) generating the nonzero
quadratic-residue orbit; its bordered sign matrix is the Paley Hadamard
carrier of order \(q+1\), and its skew core squares to \(-q\) on the
characteristic-zero augmentation module.  In defining characteristic the
same core is a maximal square-zero differential on augmentation, with
image equal to kernel and full Jordan type
\((3,2^{(q-3)/2})\).  In the translation group algebra it is a unit times
\((T-1)^{(q-1)/2}\), so its image and kernel are exactly the two middle
augmentation powers; nonsquare dilations negate the induced middle-layer
isomorphism.  The old q=7/q=11 scalars remain corroboration only.
C682 characteristic-zero work is inventory unless
explicitly promoted.

Local aggregate replay:

```sh
cd papers/clebsch-factorization
./scripts/verify-all.sh
```

## Paper III

Paper III's corrected arithmetic statement has global square class `5J_0`;
the fixed Clebsch chart lives over `Q(sqrt(5))`, and the displayed golden
configurations are the complete reduced local fibre. The degree-six
Gaunt/Steinhardt comparison and paper-owned trust surface are integrated.
C680 owns the frozen release surface.

C682 is independent exploration. Its current crown includes the
third-transvectant inverse descriptions, the corrected mod-11 operator and
1+5+6+10 kernel section, the characteristic-zero maximal-subgroup mates and
Schlaefli double-six, and the golden D5--S3 complementary incidence fibres.
The frozen common marking identifies the stored mod-11 matrix with the
lambda-plus fibre.
The cross-Gram separator extends over both Mukai--Umemura boundary orbits
on the normalized saturated graph, but provably not as a scalar on the
coarse kernel-pair boundary.
The normalized-graph deck exchange is exactly the global extension of the
Schläfli apolar-polar row swap: inside each \(D_5\), the two five-cycle
classes give complementary pentagon-side and pentagram-diagonal relations
on the ten \(S_3\) labels.
The combined normalized operator/polar/incidence package has minimal base
\(\mathbf Z[1/30]\) and structural bad primes exactly \(2,3,5\).
An \(11\)-elementary dodecic lattice removes the apparent operator failures
at \(7,11\); the cross-Gram scalar image, but not the normalized golden
cover, has collision primes \(11,23\).
At \(23\) that scalar image is the conductor-\(23\) suborder of the inert
golden algebra: its special fibre is a dual-number point, and the divided
separator is the Frobenius-odd normalization generator over
\(\mathbf F_{529}\), not a new rational incidence sheet.  Globally the
scalar image is the conductor-\(253\) order over \(\mathbf Z[1/30]\), whose
only normalization defects are the split prime \(11\) and inert prime \(23\).
Independently, the Klein \(E_8\) cubic is now intrinsic: it is the radial
third-transvectant symbol, and on every McKay covariant block the full
principal symbol is \(10p\) times multiplication by the odd invariant
\(t\), uniformly selecting the classical \(E_8\) matrix factorizations.
Through degree \(72\), every later apparent short-return deficit is repaired
by the nearest downward return; degree \(22\) is the sole certified
full-corner failure in that bounded range.  The all-weight gate remains
open.  The fourteen strict peaks through degree \(112\) also saturate,
completing one base representative of every eventual \(60\)-periodic peak
family; only the \(1,2,3,3'\) free modules remain in the symbolic
nonvanishing gate.  The global two-sided defect is now classified in all
weights: it vanishes for every \(n>52\), and its thirteen exact exceptional
degrees are
\(0,1,2,6,10,11,12,20,21,22,32,40,52\).  Degree \(22\) is uniquely
compatible with a repeated isotypic summand.  Five exact local
four-by-four determinants prove unique continuation on the five
coefficient chains.  A noncircular lower-hyperplane propagation lemma
reduces the remaining full-corner proof to upper-support mixing at
codimension-two peaks plus off-peak propagation.
The attempted maximal-rank/multiplicity induction is now sharply audited.
Every McKay block is maximal-rank through degree \(300\) at two primary and
one replay prime, and full supported algebras on spanning nonorthogonal
subspaces generate the full matrix corner.  However the trivial module has
a recurring unanchored plateau \(1\to2^6\to3\), first in degrees
\(118,\ldots,160\); equal-rank edges only transport the unknown corner, so
bare induction is circular.  That first obstruction is now repaired:
for every \(q\ge1\), the first upward return at the trivial-module entrance
\(n=64+60q\) mixes the incoming hyperplane with its missing direction.
The fixed-width boundary witness reduces the family to one exact rational
function with a coefficientwise sign proof.  The remaining controllability
gate belongs to the \(2,3,3'\) Kostant modules.  The scalar boundary
function now has a canonical signed Bezout pencil: its boundary metric has
inertia \((8,7,0)\), while separate positive Hermite pencils derive the
numerator and pole chamber counts \(1|13|0|1\) and \(2|1|0|0\) by exact
spectral flow.  The next structural target is the block version of this
two-form package for the three remaining modules.
That block input is now complete on the first \(2,3,3'\) periodic plateau
families.  Their block three-term recurrences have sizes \(2,3,3\), with
degree-three coefficients in \((q,j)\), and their backward determinants have
no integral interior zero.  The signed block Wronskian satisfies the exact
Green identity.  Fixed endpoint-return tuples surject onto local boundary
quotients of dimensions \(3,4,4\); degree-\(83,121,120\) determinant
certificates prove stable-ray surjectivity, and direct exact boundary
determinants prove surjectivity on every shorter initial chain.  Thus full
boundary-quotient surjectivity holds for every \(q\ge1\), and all first
plateau-entry families in \(1,2,3,3'\) are controlled.  Smith-at-infinity
profiles account exactly for the apparent \(13,17,18\) determinant-degree
drops.  The remaining
full-corner gate is propagation through all eventual peaks plus the off-peak
step.
Its detailed, reorganizable lookup surface is the
[C682 working archive](2026-07-13-clebsch-c682-archive.md); none of it reopens
Paper III automatically.

C696 is complete as a Paper III v2 outreach audit. Its strongest connection
is the \(A_1\times A_5\) minuscule branching \(27=12+15\): C682 supplies the
double-six, and C695 now canonically recovers the complementary fifteen
lines from the unique cubic through those twelve embedded lines.  The full
operator-derived configuration has the exact minuscule
\((2\otimes6^\vee)\oplus\bigwedge^2 6\) weight dictionary, all \(45\)
tritangent planes, and the Cartan cubic's mixed-plus-Pfaffian monomial
support.  Row exchange is the \(A_1\) Weyl reflection, not Galois conjugation
or the outer automorphism exchanging \(27\) and \(27^\vee\).  C697 owns the
remaining signed-tensor and Hodge-grading gate.
Krämer--Litt--Maculan's generic-monodromy theorem
is context rather than an imported result; the golden field is not their
invariant trace field.  The exact full-\(27\) Galois action preserves both
rows and realizes the definition-field tower
\(\mathbf Q(\sqrt5)\subset\mathbf Q(\zeta_5)\); it is not a monodromy
trace-field statement. A bounded invitation is drafted but remains unsent.

Local aggregate replay:

```sh
cd papers/clebsch-covers
./scripts/verify-all.sh
```

## Release and verification policy

Each split paper owns its statement identity, claim manifest, aggregate gate,
replay entry point, toolchain pins, adequacy appendix, and AI/provenance
disclosure. Shared Lean sources stay in the pinned standalone Lean
repository. An immutable public locator and fresh isolated replay are release
requirements, not substitutes for the paper's local gates.

Paper I ships only as the C320-approved C182 surface. Paper II requires its
own release pass. Paper III's local pass is complete; C680's two metadata
items are the only remaining planned edits.

## Lane boundaries

This lane owns the three Clebsch paper roots, the preserved mega-paper
fallback, Clebsch checkers/reports, and exact Clebsch queue rows. It does not
own Baer, alternate-orbit, gem-mining, or crowns work. Cross-lane results are
read-only until an owning split-paper task explicitly admits them.

The companion discovery log is
`notes/2026-07-14-clebsch-discovery-track.md`. Logging an observation neither
allocates work nor adds it to a paper.

## Working and historical indexes

- Live task detail: `notes/clebsch-tasks/`.
- C682 thematic lookup and chronology:
  `notes/handoffs/2026-07-13-clebsch-c682-archive.md`.
- Full accumulated handoff history:
  `notes/handoffs/done/2026-07-13-clebsch-paper-archive.md`.
- Retired mega-paper planning redirect:
  `notes/2026-07-20-clebsch-paper-planning.md`; full superseded record:
  `notes/2026-07-20-clebsch-paper-planning-archive.md`.
- Mega-paper independent cold read:
  `notes/2026-07-23-c320-independent-cold-read.md` — fallback only.
