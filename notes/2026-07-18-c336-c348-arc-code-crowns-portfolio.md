# Arc, code, and deep-hole crowns: EV-ranked research portfolio

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** C336--C348 allocated; C294 paused by user; every item is gated by the
literature and theorem criteria below

## Portfolio rule

This portfolio promotes consequences of the committed `relconic`, Clebsch, and C294 work only when
they yield a new theorem, exact code family, reconstruction algorithm, or operational bound. It does
not reopen source-lane tasks, edit their papers, or treat a familiar interpretation as a result.
The recent-paper leverage and collision inputs come from
`notes/2026-07-18-external-advances-leverage-scan.md`; in particular, its C330 warning is promoted
to the mandatory C345 gate rather than left as a positioning note.

Every task begins with a source-level literature matrix containing:

1. the closest construction and theorem;
2. the exact overlap in objects, hypotheses, parameters, and claimed application;
3. forward-citation and recent-paper checks, including MathSciNet/zbMATH when a paper-facing
   novelty claim is contemplated;
4. a `SURVIVES`, `NARROW`, or `STOP` decision for each proposed headline; and
5. claim language that credits classical ingredients separately from the new synthesis.

Search-engine absence alone never clears a novelty gate. A task that fails its gate records a sharp
negative and stops before a large computation.

## Expected-value order

| EV | Task | Primary reward | First hard gate |
|---:|:---|:---|:---|
| 0 | C345 | C329/C330 collision audit and sharpness theorem decision | reconcile Bastioni--Micheli completeness with C330's infinity obstruction before dependent claims |
| 1 | C336 | exact five-code evaluation/LRC hierarchy on C329 arcs | continue the active internal proof, but C345 must survive before reporting C329-dependent headlines |
| 2 | C337 | expected-linear recognition and recovery of a new non-GRS orbit-union MDS family | C345 survives and the heavy conics/C314 invariants are recoverable from an unlabelled matrix |
| 3 | C338 | full `q=64` quadratic weight enumerator and complete 26-arc/quasi-perfect-code family | close the five moment equations and verify every two-direction completion |
| 4 | C339 | exact Clebsch deep-hole-complement code and parent-code reconstruction | prove the stable line spectrum and an inverse theorem beyond existing C208/C212 results |
| 5 | C346 | arithmetic good reduction of the `H3`/Clebsch configuration | certify the intersection lattice and group action, not just point counts or split-field rationality |
| 6 | C341 | all-field nonabelian `A5/D5` orbit-MDS theorem and compressed decoder | certify the characteristic boundary and separate it from classical icosahedral geometry |
| 7 | C340 | bounded-carrier impossibility theorem and near-focused direction spectrum | C345 survives, then prove the general `m`-carrier direction bound before spectra |
| 8 | C347 | lower-genus replacement for the C327/C329 counting cover | identify the actual threshold term and beat its degree/genus with an absolutely irreducible model |
| 9 | C348 | all-field C329 coset-leader/deep-hole enumerator and MDS-extension interface | C345 survives and the seven direction maps yield exact syndrome multiplicities |
| 10 | C342 | non-Desarguesian pseudo-arc/additive-MDS switch | exhibit a spread-breaking switch in a bounded gate or stop |
| 11 | C343 | Clebsch-cubic/`E6` crown consumer | C213 must first supply an exact equivariant incidence map |
| 12 | C344 | rank-four hypertope/maniplex from four involutions | pass recent-literature closure and exact small-field intersection-property tests |

The lane handoff interleaves these with older C332--C335 work by current EV. C296 remains gated and
C294 remains paused; neither is silently displaced or closed.

## C345: C329/C330 collision audit and sharpness decision

**Why this is first.** Bastioni--Micheli derive complete `m`-arcs from curves, including
Artin--Schreier curves, under explicit generic hypotheses and for sufficiently large fields.
C329 uses the same broad mechanism while C330 proves that its four-layer arc misses almost all
directions on the line at infinity. Until the hypotheses are compared, the current package may be
a sharp counterexample to the scope of the generic theorem, a special case already covered by it,
or internally inconsistent. No dependent C329/C330 crown is paper-ready before this audit.

**Mandatory full-text matrix.** Read condition by condition:

- L. Bastioni and G. Micheli, [*On complete m-arcs*](https://arxiv.org/abs/2303.13670);
- D. Bartoli and G. Micheli,
  [*Algebraic constructions of complete m-arcs*](https://arxiv.org/abs/2007.00911);
- G. Korchmaros, G. P. Nagy, and T. Szonyi,
  [*Algebraic approach to the completeness problem for (k,n)-arcs in planes over finite fields*](https://arxiv.org/abs/2302.10162);
- the forward citations and corrections to all three, with MathSciNet/zbMATH closure before a
  paper-facing novelty statement.

For every genericity, irreducibility, projection, splitting, and field-size hypothesis actually
used in those papers, record the exact C329 analogue, the proof or counterexample, and the theorem
consequence. Do not infer a paper's hypotheses from its abstract.

**Consistency gate.** Independently replay the C329 no-three-collinear assertion and C330's seven
reciprocal direction images, exact `<=7Q-2` infinity-direction bound, and explicit uncovered point
for symbolic parameters plus representative admitted fields. If an external theorem predicts
completeness, identify a proved failed hypothesis. If none fails, mark `STOP-CONTRADICTION`, freeze
all C329/C330-dependent crowns, and return the minimal conflict to `relconic` without editing that
lane.

**Novelty gate.** Compare C330's line-at-infinity obstruction with the Korchmaros--Nagy--Szonyi
localization of uncovered points in a subplane. If the phenomenon is already generic, narrow the
claim to the exact locus, `<=7Q-2` count, explicit threshold, and failure mode of the
Bastioni--Micheli hypotheses. If the C329 family lies outside their conditions, formulate a precise
sharpness/limitation theorem for the complete-arc programme; do not call the obstruction type new
without the comparison.

**Exit.** One of three signed verdicts: `SURVIVES-SHARPNESS`, `NARROW-EXACT-COUNT`, or
`STOP-CONTRADICTION`, with a quotable hypothesis table and independent replay. C336's already
active internal parameter work may continue in parallel, but only the first two verdicts release
C329/C330-dependent headlines or the final reporting of C336, C337, C340, C347, and C348.

**Owned report stem:** `notes/2026-07-18-c345-c329-c330-complete-arc-collision-audit.*`

## C336: exact low-degree evaluation and availability tower

**Input boundary.** Consume C329's `4Q`-arc and C330's exact constant-height carrier equations
read-only. Work over `E=GF(Q^2)` on the C329 coincidence stratum, where one carrier conic contains
`2Q` selected repair points and two distinct carrier conics contain `Q` seed points each.

**Theorem target.** For homogeneous-degree evaluation codes `C_d(A)`, prove injectivity and the
candidate exact parameters

| `d` | dimension | maximum zero positions | minimum distance |
|---:|---:|---:|---:|
| 1 | 3 | `2` | `4Q-2` |
| 2 | 6 | `2Q` | `2Q` |
| 3 | 10 | `2Q+2` | `2Q-2` |
| 4 | 15 | `3Q` | `Q` |
| 5 | 21 | `3Q+2` | `Q-2` |

Classify every extremal curve by carrier components and residual secants. Then prove all-symbol
locality at most `2d+1` by restriction to a conic and disjoint-recovery availability at least
`floor((Q-1)/(2d+1))` on seed layers, with the correct larger repair-carrier value.

**Proof gate.** Audit selected carrier intersections and all reducible-curve cases; a generic
Bézout bound without equality classification does not pass. The code dimension must be proved from
evaluation injectivity, not inferred from the polynomial-space dimension.

**Application gate.** Compare exact rate, distance, locality, and availability with projective
Reed--Muller local correction, algebraic-curve/projective-bundle LRCs, and conic evaluation codes.
State honestly if the reward is a high-redundancy structural/storage regime rather than an
asymptotically optimal LRC tradeoff.

**Literature boundary.** Start with:

- B. Gatti, G. Korchmaros, and G. Schulte,
  [*Evaluation codes from linear systems of conics*](https://arxiv.org/abs/2605.11187);
- K. Aguilar et al.,
  [*Locally recoverable algebro-geometric codes with multiple recovery sets from projective bundles*](https://arxiv.org/abs/2409.04201);
- A. Barg, I. Tamo, and S. Vladuts,
  [*Locally recoverable codes on algebraic curves*](https://arxiv.org/abs/1603.08876);
- S.-J. Lin,
  [*On the Local Correctabilities of Projective Reed--Muller Codes*](https://arxiv.org/abs/1702.02671).

The familiar evaluation and interpolation mechanisms are not the claim. The defensible new core is
the exact five-code tower, its extremal-word geometry, and the recoverable `2Q+Q+Q` carrier
partition on the new C329 family.

**Exit.** An exact theorem with proof and parameter table, a source-level novelty report, and a
small independent finite-field replay of each equality type. Otherwise record which row or locality
claim fails and stop.

**Owned report stem:** `notes/2026-07-18-c336-c329-evaluation-lrc-tower.*`

## C337: non-GRS orbit-union recognition and recovery

**Input boundary.** Consume C314's six-stratum atlas, C329's existence theorem, and C336 if it
passes. Do not edit `relconic` reports or promote the prescribed-conic marking when the unmarked code
does not recover it.

**Theorem target.** Given an unlabelled `3 x 4Q` generator or parity-check matrix known only up to
monomial equivalence:

1. recognize the C329/C314 family by finding the unique heavy conics with selected supports
   `2Q,Q,Q`;
2. recover the unmarked layer partition and gauge-free C314 invariants;
3. decide projective/monomial and, separately, semilinear equivalence inside the admitted stratum;
4. prove the family non-GRS; and
5. expose the common additive `F^+` action as four full projective orbits, formulating the result as
   an orbit-union analogue of cyclic/Krylov MDS codes.

**Algorithm gate.** Prove correctness and field-operation complexity. The randomized heavy-conic
sampler should have expected complexity linear in the code length because five points from a seed
carrier occur with probability asymptotic to `4^-5`; provide a deterministic fallback or state its
absence. A coordinate normal form that assumes the carriers are labelled is not a recognition
algorithm.

**Literature boundary.** Start with:

- G. Wang, H. Liu, and J. Luo,
  [*New Constructions of Non-GRS MDS Codes, Recovery and Determination Algorithms for GRS Codes*](https://arxiv.org/abs/2512.02325);
- Y. Li and P. Yuan,
  [*Cyclic Projective Orbits on Rational Normal Curves and MDS Codes*](https://arxiv.org/abs/2607.12761);
- current non-GRS/twisted-GRS recognition, Schur-square distinguishers, code-equivalence, and
  structured-code cryptanalysis literature.

The novelty claim is not that non-GRS MDS codes or GRS distinguishers exist. It is the exact
recognition/recovery/equivalence theorem for this new layered orbit-union family and the intrinsic
low-degree fingerprint that makes it possible.

**Exit.** A proved algorithm with exact admitted inputs, success probability or deterministic
bound, complexity, reconstruction output, and baseline comparison. Stop if the C314 invariants do
not descend to an unmarked code invariant or if recovery is only exhaustive enumeration.

**Owned report stem:** `notes/2026-07-18-c337-layered-mds-recognition-recovery.*`

## C338: the `PG(2,64)` quadratic and completion package

**Input boundary.** Consume C300's three projective 24-arc classes, conic-intersection counts,
order-four stabilizers, affine completeness, and 19 missing directions read-only.

**Stage A: quadratic code.** Prove that quadratic evaluation is `[24,6,14]_64`. Solve the five
remaining nonsingular-conic intersection counts from incidence moments, independently verify the
known `10,8,7,6,5` counts, enumerate degenerate line-pair quadrics from the external/tangent/secant
line distribution, and derive the complete weight enumerator and minimum-support geometry.

**Stage B: complete arcs.** Prove that adjoining any two of the 19 missing infinity points yields a
complete 26-arc. Classify all 171 pairs under the projective and semilinear stabilizers, determine
automorphism groups and conic signatures, and translate them into non-GRS, nonextendable
`[26,3,24]_64` MDS codes and dual `[26,23,4]_64` radius-two quasi-perfect codes.

**Literature gate.** Search complete-arc tables and classifications at `q=64`, complete/projective
MDS and covering-code databases, quadratic evaluation-code weight enumerators, and forward
citations to the closest `PG(2,64)` constructions. Do not claim a size record without a direct
table comparison. Distinguish novelty of the specific structured completion/classification from
existence of some 26-arc.

**Exit.** Exact distributions and orbit certificates with independent replay, plus a literature
verdict for each code/arc claim. Stage A and Stage B may survive independently.

**Owned report stem:** `notes/2026-07-18-c338-q64-quadratic-complete-arcs.*`

## C339: Clebsch deep-hole transform and `H3` inverse code

**Ownership boundary.** `clebsch` and `clebsch-next` remain the owners of their papers and C206--C213.
C339 consumes committed results read-only and owns only the cross-lane code-to-code transform and
inverse theorem. If the result is merely a restatement of C208 or C212, hand it back and stop.

**Stage A: bounded transform.** For a redundancy-three projective code `C`, define the projective
deep-hole set `D(C)` and the linear code generated by those syndrome directions. Recast the q=11
rigidity theorem precisely as:

```text
the deep-hole transform of a six-arc code is the [12,3,10]_11 extended GRS code
if and only if the source is the Clebsch class.
```

Determine what marking, if any, is needed to recover the source from the otherwise highly
symmetric conic code. State the Wu--Ding--Chen one-coordinate MDS-extension corollary explicitly:
the 12 deep-hole directions are exactly the admissible one-column extensions. Then classify the
simultaneous-extension complex on those 12 directions: its faces are the subsets that remain MDS,
equivalently the clique complex of the continuation graph. Coordinate this bounded classification
with C295 rather than duplicating its reconstruction objective.

**Stage B: all-field inverse theorem.** On good reductions of the `H3` arrangement, let `B_q` be
the complement of the 15 mirrors, equivalently the deepest-syndrome locus of the six-column
`A5`-orbit code. Prove `|B_q|=(q-5)(q-9)` and, for `q>14`, recover the 15 mirrors as exactly the
lines disjoint from `B_q`; recover their six fivefold points and hence the parent code. Compute the
line-intersection spectrum of `B_q` and the weight enumerator of its degree-one evaluation code.
The fresh finite-field conjecture to prove, not quote as established, is that for stable good
reductions the nonmirror intersection sizes and line counts are

| `|B_q cap L|` | number of lines |
|---:|---:|
| `q-14` | `(q-11)(q-19)` |
| `q-13` | `15(q-11)` |
| `q-12` | `10(q-11)` |
| `q-11` | `40` |
| `q-10` | `6(q-9)` |
| `q-9` | `66` |

with 15 mirror lines meeting `B_q` in zero points. This would give the exact code parameters
`[(q-5)(q-9),3,(q-6)(q-9)]_q` and its complete weight distribution, followed by the inverse
reconstruction theorem. A tracked symbolic/incidence proof and exceptional-field ledger are
mandatory; probes at `q=19,29,31,41,59,61` are evidence, not a theorem.

**Literature boundary.** Start with:

- Y. Wu, C. Ding, and T. Chen,
  [*Extended codes and deep holes of MDS codes*](https://arxiv.org/abs/2312.05534);
- Y. Li, Z. Lu, S. Ling, and K.-Y. Lam,
  [*A framework for constructing non-GRS MDS-NMDS codes from deep holes and its application*](https://arxiv.org/abs/2605.12133);
- K. V. Kaipa,
  [*Deep holes and MDS extensions of Reed--Solomon codes*](https://arxiv.org/abs/1612.05447);
- H. Gu, N. Wang, and J. Zhang,
  [*Deep holes of a class of twisted Reed--Solomon codes*](https://arxiv.org/abs/2509.08526);
- R. Raja,
  [*Numerical semigroups, hyperplane arrangements, and linear codes over finite fields*](https://doi.org/10.3934/amc.2026042);
- the Jurrius--Pellikaan derived-arrangement decoder baseline already recorded by C211;
- deep-hole recognition, arrangement-complement evaluation codes, and code reconstruction from
  projective systems.

Neither the one-point deep-hole/MDS-extension equivalence, redundancy-three RS deep holes, the
classical `H3` arrangement, nor evaluation on an arrangement complement is new. The q=11 novelty
rests on the source code being non-GRS and must be stated next to Kaipa's boundary. C339 passes only
with the multi-extension classification, a genuine transform/inverse theorem, or the exact
deep-hole-origin weight enumerator not already owned by C208/C212.

**Exit.** One theorem valid beyond a rephrasing of the q=11 census, with a source-level priority
audit and an explicit source-lane hand-back boundary.

**Owned report stem:** `notes/2026-07-18-c339-clebsch-deep-hole-transform.*`

## C340: carrier lower bound and algebraic near-one-factorizations

**Input boundary.** Consume C330's exact seven reciprocal direction images. Generalize only the
stated constant-height, translation-covariant `F`-carrier architecture; do not claim a lower bound
for arbitrary arcs or relative-conic constructions.

**Stage A: architecture theorem.** For a union of `m` full constant-height `F`-carrier layers in
`PG(2,Q^2)`, prove the sharp applicable direction bound, expected in the form

```text
|D_fin| <= (binom(m,2)+1) Q + O(m^2),
```

with exact endpoint corrections. Deduce that covering `Q^2` required infinity directions forces
`m=Omega(sqrt(Q))` and total size `Omega(Q^(3/2))=Omega(q^(3/4))` inside this architecture.

**Stage B: spectrum.** Treat directions as a proper edge-colouring of `K_(4Q)`. Determine exact or
asymptotic image intersections and fibre/matching-size distributions for the seven maps `p+a/p`,
thereby producing an algebraic near-one-factorization with at most `7Q-2` colours.

**Literature gate.** Audit hyperfocused/generalized-hyperfocused arcs, direction sets of graphs of
finite-field functions, Redei-type sets and blocking sets, geometric one-factorizations, perfect
hash families, and geometry-based secret sharing. Begin with Giulietti--Montanucci,
[*On Hyperfocused Arcs in PG(2,q)*](https://arxiv.org/abs/math/0601488), and its forward citations.

**Application gate.** A scheduling, hashing, blocking, or secret-sharing statement must have an
explicit operational parameter. The Stage A impossibility theorem may pass independently without
an application claim.

**Exit.** A general architecture theorem with exact hypotheses; continue to the fibre spectrum
only if the novelty audit leaves a defensible edge-colouring or applied result.

**Owned report stem:** `notes/2026-07-18-c340-carrier-direction-spectrum.*`

## C347: compress the C327/C329 cover and field threshold

**Dependency.** Begin only after C345 identifies a consistent surviving theorem and the precise
external genericity boundary. This task changes the quantitative threshold, not the C345 verdict.

**Theorem target.** Re-express the splitting/specialization condition on an absolutely irreducible
curve or lower-degree cover to replace the current degree-64, genus-at-most-1,838,101 count. Prove
an explicit smaller field threshold for C327/C329 using direct Hasse--Weil counting when possible,
and state exactly which construction hypotheses are retained.

**First falsifier.** Re-derive the `2^41` and `2^45` inequalities term by term. Stop immediately if
the dominant term is not the cover degree/genus. Then test whether the Hasse--Weil method for
`(k,n)`-arcs in Korchmaros--Nagy--Szonyi actually transfers to the rigid `n=2` setting; thematic
similarity does not pass.

**Literature gate.** Compare the full proof architecture of
[*Algebraic approach to the completeness problem for (k,n)-arcs in planes over finite fields*](https://arxiv.org/abs/2302.10162),
Bary-Soroker--Entin's explicit Hilbert irreducibility, and the function-field effective-Chebotarev
baseline. Recent number-field Chebotarev constants are irrelevant unless a valid transfer is
proved. The reward is an explicit improved threshold or a sharp proof that the current cover is
degree/genus-minimal within the chosen construction.

**Exit.** A mechanically checked threshold improvement with the new curve/cover equations and
absolute-irreducibility certificate, or a bounded negative naming the irreducible bottleneck.

**Owned report stem:** `notes/2026-07-18-c347-c329-low-genus-threshold.*`

## C348: C329 coset leaders, deep holes, and MDS extensions over the family

**Dependency.** C345 must leave the C329/C330 geometry consistent. C336 may supply evaluation-code
data, but C348 studies the dual redundancy-three syndrome geometry and does not duplicate it.

**Theorem target.** For the C329 `[4Q,4Q-3,4]` non-GRS MDS family, classify projective syndromes by
minimum leader weight, compute the extended coset-leader weight enumerator, and describe the exact
deep-hole locus. Use C330's seven reciprocal direction images to turn the uncovered
line-at-infinity directions into an exact weight-three stratum, not merely a covering-radius-three
witness. Determine the automorphism or carrier-orbit decomposition and the resulting one- and
simultaneous-column MDS extensions.

**Method gate.** Import the double-point-scheme and Hasse--Weil method of Blokhuis--Pellikaan--Szonyi,
[*The extended coset leader weight enumerator of a twisted cubic code*](https://arxiv.org/abs/2103.16904),
only after proving it applies to the reducible carrier geometry. Exact moment identities without a
geometric classification do not pass. First freeze small admitted fields and independently match
the enumerator against exhaustive syndrome counts.

**Application and novelty gate.** Position the exact deep-hole data as input to Wu--Ding--Chen MDS
extension and the 2026 Li--Lu--Ling--Lam non-GRS MDS/NMDS framework. Check their full hypotheses,
Kaipa's redundancy-three RS boundary, twisted/GRS coset-leader enumerators, and forward citations.
The generic deep-hole/extension dictionary is prior art; the defensible result is the exact
all-field distribution and extension complex of this new non-GRS family.

**Exit.** Exact formulas with an exceptional-field ledger, replay on bounded fields, and either a
new extension family/application theorem or an honest statement that the enumerator is the sole
surviving result.

**Owned report stem:** `notes/2026-07-18-c348-c329-coset-leader-enumerator.*`

## C341: `A5` subgroup-lattice decoder and nonabelian orbit codes

**Input boundary.** Consume the Clebsch `A3/H3` identification, decoder strata, and automorphism
checks read-only. Coordinate with C207/C208/C212 rather than duplicating their chirality, orbit, or
arrangement objectives.

**Theorem target.** Construct and prove an equivariant dictionary among the six columns, ten
Brianchon/triple-ambiguity objects, fifteen secants/reflections, twelve deep-hole directions, and
the appropriate `A5` Sylow/normalizer/coset objects. Determine whether the marked subgroup-incidence
geometry reconstructs the decoder ambiguity poset and intrinsic support chirality. Formulate the
six-column code as a nonabelian group-orbit MDS code and identify the on-conic versus off-conic
orbit criterion for GRS versus non-GRS behaviour. Prove the candidate all-field theorem over every
admitted odd split field: the six fivefold axes form an `[6,3,4]` `A5/D5` orbit-MDS code, while the
quadratic evaluation determinant

```text
16(3*tau-4),     Norm = -1280 = -2^8*5
```

gives an exact characteristic-5 GRS boundary and non-GRS behaviour at every other good odd
characteristic. Validate the determinant in the task's canonical normalization, handle nonsplit
descent separately, and do not call characteristic 5 good reduction without C346's lattice check.

**Decoder/application target.** Upgrade the affine syndrome orbit sizes
`1,60,100,120,150,300,300,300` from a census to a coherent configuration. Compute stabilizer
orbitals and their transition/intersection algebra so one representative soft/list decoder serves
each orbit. Ask whether the configuration is separable, hence intrinsically reconstructible from
its intersection numbers. Fixed-length speedups or the projective orbit sizes alone do not pass.

**Initial falsifier.** The displayed q=11 columns admit zero length-six Krylov orderings in the
fresh 720-ordering test. Before using that fact, land a deterministic checker and explain why it
distinguishes this task from the cyclic-orbit setting rather than proving a broader negative.

**Literature boundary.** Start with the 2026 cyclic/Krylov orbit-MDS classification, recent
automorphism-orbit and symmetry-compressed decoding papers, the Chen--Ponomarenko coherent-
configuration/separability programme, Lu--Zhou's 2025 stabilizer-orbit NMDS equivalence method,
and P. Tranchida,
[*Triples of involutions in `PGL(2,q)` and their incidence geometries*](https://arxiv.org/abs/2411.10299),
the C211 Edge/Calvo priority record, classical `A5/H3` subgroup geometry, nonabelian group-orbit
codes, and Li--Yuan's cyclic/Krylov theorem. The point--involution dictionary, the icosahedral
arrangement, and elementary Sylow counts are prior art.

**Exit.** A code/decoder reconstruction or orbit-MDS theorem that uses the subgroup dictionary.
An attractive relabelling of `6,10,15,12` is a negative and stops the task.

**Owned report stem:** `notes/2026-07-18-c341-a5-subgroup-decoder.*`

## C346: arithmetic good reduction of the `H3`/Clebsch configuration

**Input boundary.** Consume C211's characteristic-zero coordinates and its q=11/q=5 observations
read-only. C346 owns the arithmetic reduction theorem, not the classical icosahedral arrangement
or a rewrite of the Clebsch paper.

**Theorem target.** Put the 15 `H3` mirrors over `Z[tau]`, `tau^2-tau-1=0`, and determine exactly
which prime ideals preserve the intersection lattice and the six/ten/fifteen orbit geometry.
Separate three notions that can diverge: rationality over `F_p` versus `F_(p^2)`, intersection-
lattice good reduction, and preservation of the projective `A5` action. Explain q=11 and the q=5
collapse by theorem, with every other exceptional prime explicit.

**Mechanical gate.** Adapt the minimal-strong-Grobner-basis criterion of Palezzato--Torielli,
[*Combinatorially equivalent hyperplane arrangements*](https://arxiv.org/abs/1906.05463),
from `Z` to `Z[tau]`, and independently verify the resulting lattice multiplicities. The elementary
fact that `5` splits exactly when `p = +/-1 mod 5` explains `F_p`-rationality but is not itself a
good-reduction theorem. Use Monson--Schulte's finite-field reflection-group work for the group side
only after checking its noncrystallographic hypotheses.

**Novelty and application gate.** Calvo and the Wiman--Edge literature own the characteristic-zero
`H3/A5` configuration. Search MathSciNet/zbMATH and forward citations for finite reductions of the
icosahedral arrangement before claiming priority. The surviving reward is an exact arithmetic
good/bad-prime theorem that certifies the field range of C339/C341 and predicts the arithmetic
strata relevant to C333; arrangement counts alone do not pass.

**Exit.** A proof and replayable Grobner certificate for the good-prime classification, including
the q=11 instance and q=5 degeneration, or a narrowed report identifying which of the lattice,
group, and code structures fail to descend uniformly.

**Owned report stem:** `notes/2026-07-18-c346-h3-clebsch-good-reduction.*`

## C342: non-Desarguesian pseudo-arc switching gate

**Input boundary.** Ordinary field reduction of C329 is known to produce a Desarguesian pseudo-arc
and is not a task deliverable.

**First gate.** Audit switching, spread replacement, field-reduction, pseudo-arc, and additive-MDS
literature. Then test a frozen finite list of switches that preserve the any-three-span property
while moving at least one element outside the original Desarguesian spread.

**Literature boundary.** Begin with F. Pavese and P. Santonastaso,
[*On pseudo-arcs from normal rational curve and additive MDS codes*](https://arxiv.org/abs/2602.23130),
including its distinction between Desarguesian field reductions and genuinely non-Desarguesian
pseudo-arcs.

**Exit.** Proceed only with an infinite switch or a structural switching theorem yielding additive
MDS codes provably inequivalent to linear MDS codes. If the bounded switch list stays inside the
spread or breaks the pseudo-arc property, report the negative and stop. No mere field-reduction
construction is publishable here.

**Owned report stem:** `notes/2026-07-18-c342-relconic-pseudoarc-switch.*`

## C343: gated Clebsch-cubic/`E6` crown consumer

**Dependency gate.** C213 in `clebsch-next` owns the `12+15 -> 27`, Brianchon/Eckardt, and
Sylvester-pentahedron falsification. C343 does no duplicate search or incidence construction. If
C213 does not produce an exact equivariant incidence map, close C343 immediately.

**Conditional target.** If C213 passes, determine whether its map yields a new code, deep-hole,
decoder, Schlaefli-graph, or `E6` reconstruction theorem rather than a classical cubic-surface
identification. Audit recent cubic-surface/Eckardt/configuration literature and the full classical
Clebsch priority chain before formulating a claim.

**Exit.** A theorem in which the cubic incidence explains or reconstructs coding data. A
cardinality match, group-isomorphism observation, or unmarked classical configuration does not
pass.

**Owned report stem:** `notes/2026-07-18-c343-clebsch-e6-code-bridge.*`

## C344: rank-four hypertope/maniplex gate

**Input boundary.** Consume C294's explicit four-involution bronze configurations or C333's larger
mirror locus if available. C294 remains paused; C344 may read its committed bronze artifacts but
does not resume B3 or the value search.

**First gate.** Complete a source-level audit of rank-four regular polytopes, C-groups, hypertopes,
and maniplexes with `PSL2/PGL2` automorphism groups. Preserve the known obstruction/classification
boundary for regular polytopes; target a non-polytopal hypertope or maniplex only if not already
covered.

**Finite falsifier.** Freeze generator ordering and coset-geometry conventions, then test the
intersection and residual-connectivity properties at a small representative set such as
`q=7,11,23`. No all-field algebra begins unless at least one intended rank-four structure passes
and the result is not an existing example under isomorphism.

**Literature boundary.** Tranchida's rank-three classification is input, not novelty. Audit recent
rank-four `PSL2` maniplex work and the established `PGL2` polytope classifications before claiming
an extension.

**Exit.** An infinite rank-four non-polytopal family with a proved mirror correlation or a sharp
impossibility theorem for this four-involution architecture. Finite examples alone do not pass.

**Owned report stem:** `notes/2026-07-18-c344-rank4-involution-hypertope.*`

## Portfolio-level stop and hand-back rules

- C345 is the mandatory novelty/consistency audit before C329/C330-dependent headlines; it does not
  interrupt C336's already active internal parameter calculations.
- C336--C338 and C347--C348 may consume `relconic` theorems but do not alter that lane's Paper II or completeness
  claims.
- C339, C341, C343, and C346 edit no Clebsch manuscript, checker, or handoff. Any paper import returns to
  the owning Clebsch lane after a crowns report proves the bridge.
- C340 never upgrades an architecture-specific obstruction to a global arc lower bound.
- C342 cannot claim novelty for Desarguesian field reduction.
- C343 is mechanically closed if C213 fails.
- C344 is mechanically closed if the small-field intersection-property gate fails or recent
  literature already contains the same family.
- C294 is paused, not failed or superseded. Its router, evidence, and frozen E3 experiment remain
  intact and are resumed only on explicit user direction.
