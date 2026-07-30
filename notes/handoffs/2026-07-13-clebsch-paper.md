# Clebsch three-paper program

**Lane:** `clebsch`

**Date:** 2026-07-30

> **LIVE MAP ONLY.** This is the routing and state surface for the active
> three-paper program. Detailed live task internals belong in C-task cards;
> completed and superseded detail belongs in the archives linked below.
>
> **ROUTING AUTHORITY.** No dated planning note, fallback-paper verdict, task
> report, or archive overrides the order and boundaries stated here.

## Program state

| surface | root | current state | owning task |
|---|---|---|---|
| Paper I — *Reconstructing the Clebsch code and its golden orientation from its deep-hole syndrome locus* | `papers/clebsch-rigidity/` | six-nodal attribution repaired; v2 referee cold read requires bounded revision before release; approved v1 baseline frozen | [C182](../clebsch-tasks/c182-paper-i-release.md) |
| Paper II — *Quadratic trade rigidity and cubic orientation in conic matching quotients* | `papers/clebsch-factorization/` | v2 theorem arc, cold read, standalone sync, and thirteen-bundle replay green; frozen v1 unchanged; public packaging remains | [C577](../clebsch-tasks/c577-factorization-paper.md) |
| Paper III — *The Clebsch orientation cubic: arithmetic covers and icosahedral harmonics* | `papers/clebsch-covers/` | pre-release `GO`; immutable locator and author metadata remain | [C680](../clebsch-tasks/c680-paper-iii-release.md) |
| 37-page mega-paper | `papers/clebsch-code/` | preserved unchanged as fallback only | C552 if explicitly reactivated |

C703 is complete: all three split papers now share the title-page identity
*The Clebsch cubic: recovering, orienting, and realizing* and a restrained
opening image, while their canonical titles, logical independence, and
paper-owned proof surfaces remain unchanged.  The conclusions continue the
same progression without administrative cross-promotion.  Full report:
[`../2026-07-30-c703-clebsch-trilogy-identity.md`](../2026-07-30-c703-clebsch-trilogy-identity.md).

## Active and queued task cards

| task | state | next gate |
|---|---|---|
| [C182 — Paper I release](../clebsch-tasks/c182-paper-i-release.md) | queued on bounded cold-read revision, then external publication authority | correct the rational module sentence, trust boundary, closest literature, and opening hierarchy; rerun gates |
| [C577 — Paper II](../clebsch-tasks/c577-factorization-paper.md) | active under the C182 external-wait exception | obtain immutable locator, isolate replay, run release pass |
| [C680 — Paper III release](../clebsch-tasks/c680-paper-iii-release.md) | pre-release `GO` | add immutable locator and author metadata, rebuild, replay |
| [C682 — Hitchin--Clebsch exploration](../clebsch-tasks/c682-hitchin-structural-exploration.md) | active; McKay-corner and golden/\(E_8\) descent classifications complete | user decision: close exploration or select an optional successor |

C321 remains conditional and is not triggered: the final Paper I review found
no missing proof obligation. C552 remains fallback-only and must not displace
the split-paper route without an explicit user decision.

## Paper I

Paper I and its companion *Computational strengthenings of Clebsch syndrome
rigidity* form one warning-free, nineteen-row release surface with eighteen
checks. C320 is complete with final `GO`; C693 completed the accepted v2
integration without changing the frozen v1 baseline. C182 owns every
remaining release action.

The 2026-07-30 v2 referee cold read supersedes the earlier release verdict
for the revised paper.  The Cheltsov--Tschinkel--Zhang attribution and exact
six-nodal coordinate boundary are now integrated.  Before release, correct
the field-of-definition wording for the rational \(A_5\)-module, state the
orientation theorem's computer/formal boundary accurately, add the closest
q13 and standard two-graph sources, and integrate the orientation result
into the novelty paragraph and conclusion.  Report:
[`../2026-07-30-paper-i-v2-referee-cold-read.md`](../2026-07-30-paper-i-v2-referee-cold-read.md).

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
conductor-two degeneration.  More strongly,
\[
 \det(B+\operatorname{diag}x)=e_6-e_4+5e_2-125-2C_B,
\]
so the cubic is the sole nonsymmetric layer of the golden diagonal
determinant pencil, and complementary minors derive support complementation
from \(B^2=5I\).  Its homogenized conjugation-odd part is
\(F_B(x,z)-F_B(x,-z)=-4z^3C_B(x)\), while the off-diagonal equations in
\(B^2=5I\) force all signed moments below degree three to vanish and make
the cubic descend to the augmentation five-space.  Conversely, the
two-graph identities reconstruct \(B\), pair balance is equivalent to
\(B^2=5I\), and a gauge-fixed balance argument makes the positive graph on
the other five vertices a pentagon.  Hence the cubic alone forces the
unique golden conference switching class.
As a final intrinsic upgrade, the cubic threefold on the augmentation
projective four-space has exactly six singular points
\([\mathbf1-6e_a]\), all ordinary nodes.  They form a projective frame, so
the cubic itself reconstructs the six-axis carrier and its full projective
automorphism group is the computed outer \(S_5\) of order \(120\).
C693 integrates this complete package in the human paper and integrates
C611's \(q=13\) tangent-code theorem in the computational companion.  The
nineteen-row, eighteen-check Paper I trust surface is paper-owned and has no
Paper III dependency; the approved v1 baseline remains frozen.
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

Paper II is standalone: no proof dependency on Papers I or III.  Its frozen
v1 baseline remains unchanged, while C694 has integrated the accepted v2
arc.  A two-valued one-dimensional strength-two trade now derives the
balanced \(q+q\) one-factorization sheets; the uniform Frobenius-digit
criterion and local first-wall spill close the extension-field cases.  The
canonical replay constructs only \(S,T,R,Y\), with q=121 and q=169 retained
as corroboration.  One edge-selected alternating cycle and Dickson
recurrence prove radial nonvanishing for both \(B_3\) and \(H_3\).  The
Paley carrier explains the cross-sheet orientation but is not used as the
Gorenstein pairing: it misses the radial/common-sum pair by one dimension.
Maximal-isotropic quotient duality gives that pairing directly.

The paper-owned trust surface has twenty-six statements and thirteen
evidence bundles, including independent generic-wall, shared-radial, and
q=9 small-field replays.  The aggregate gate and warning-free thirty-page
PDF are green in the authoritative and standalone repositories.  C577
owns the remaining public packaging and release work.
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
drops.  Exact global falling-factorial Weyl operators in the invariant
exponents \((F,h)\) now realize the third- and ninth-transvectants on the
complete \(2,3,3'\) free modules, eliminating phase-specific operator
construction.  Four further all-\(q\) Wronskians give one certified
representative of every plateau type modulo \(20\); an exact audit shows
that Hilbert translation by degree \(20\) is not transvectant linearity.
The sixteen resulting modulo-\(60\) phase quotients are now all
boundary-surjective for every integer \(q\ge1\).  Together with the prior
eight rays, they anchor every periodic plateau-entry phase.  Exact
global-Weyl two-step compositions are coefficientwise one-signed
degree-four polynomials on all twenty-one eventual strict peak families;
  combined with the all-weight defect and supported-two-subspace theorems,
  this propagates the full graded path corner through every peak.  The
  one-sided operator is now maximal-rank on every McKay block in every
  weight.  The order-three ODE bound, central parity, \(C_5\)-weights, and
  triangular \(d_1/d_{11}\) chain minors prove the exact kernel series.
  Consequently all off-peak full graded path corners in \(1,2,3,3'\) now
  propagate.  The subsequent monotone analysis closes all sixty-three
  modulo-\(60\) plateau entrances in \(2',4,4_s,5,6\).
The four exceptional modulo-\(20\) block Schur recurrences are now explicit.
The global level \(\lfloor b/3\rfloor\) makes all twelve phases block
tridiagonal, their backward blocks factor only at
\(0,\pm1/3,\pm2/3\), and exact elimination leaves complements of sizes
\(5|6|7\), \(5|6|7\), \(6|7|9\), and \(7|9|11\).  The selected endpoint
determinants are nonzero on the exact finite audit \(6\le r\le35\).
The all-\(r\) gate is now closed by scalar \(C_5\)-chain boundary
obstructions.  On chain residues \(4,2,2,0\), exact two-coordinate minors
show that \(D_n^\dagger D_n\) never preserves the incoming hyperplane in
\(4_6,4_{s,3},5_4,6_5\).  Their rational obstructions are strictly negative
on the full real ray \(r\ge6\), and the canonical Fischer endpoint has
positive Schur contraction.  Hence all sixty-three monotone entrance phases
and every graded path corner now propagate.  The local-return gate is also
closed, in a stronger form: the nearest lower and upper Gram returns already
generate every McKay block corner except the exact
\((\mathbf3,22)\) failure.  The two-step upward return is redundant.  The
signed Wronskian and complete boundary quotients give the cyclic-kernel
proof, while the rectangular endpoint system separates distinct blocks.
Thus the requested three-return algebra is the full graded path corner in
every nonexceptional degree.  On every nontrivial block this two-return
presentation is generator-minimal, and both generators are canonical
positive Fischer energy forms.
The previously unexplained virtual levels
\(0,\pm1/3,\pm2/3\) are the order-three \(h=0\) indicial roots in the
degree-\(60\) \(h^3/F^5\) level of
\(t^2=1728F^5-h^3\).  Source-chain residue counts give the exact formula
\[
\det K_-(j)=C\prod_{s=0}^2((3j+s)_3)^{c_s}.
\]
It explains every factor multiplicity, the identical normalized
\(3,3'\) determinants, and the phase-independent \(6\)-profile.
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
or the outer automorphism exchanging \(27\) and \(27^\vee\).  C697 now
constructs the abstract graded Cartan carrier with its exact \(6|15|6\)
cocharacter and signed mixed-plus-Pfaffian cubic.  The row permutation
requires an order-four linear Weyl lift.  The raw Cartan tensor descends
exactly to the six-axis orientation field \(\mathbf Q(\sqrt5)\); rational
descent needs a determinant twist on one row.  KLM Hodge conjugation instead
relates \(V_L\) to \(V_{L^\vee}\), hence belongs to the outer
\(27\leftrightarrow27^\vee\) side.  With no cohomological or Higgs
realization, the operator construction is a graded Cartan model but not a
model of the KLM variation.
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
