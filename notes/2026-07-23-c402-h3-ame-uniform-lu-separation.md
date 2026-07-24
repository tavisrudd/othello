# C402 — uniform `H3` AME separation from every GRS class

**Lane:** `crowns`

**Date:** 2026-07-23

**Verdict:** `THEOREM; ONE UNIFORM MARGINAL-MOMENT INVARIANT SEPARATES EVERY ODD GOOD NON-GRS H3 REDUCTION FROM EVERY SIX-POINT GRS AME CLASS`

## The theorem

Let `k` be the residue field of an odd good reduction of `Z[tau]`, with
`tau^2=tau+1`, and reduce the integral `H3/A5` six-arc

```text
(0,1,1-tau), (0,1,tau-1),
(1,1-tau,0), (1,tau-1,0),
(1,0,-tau),  (1,0,tau).
```

Let `C` be the kernel of this parity-check matrix and let

```text
|Psi_C> = |k|^(-3/2) sum_(c in C) |c>.
```

If the reduction is non-GRS, then `|Psi_C>` is not local-unitary equivalent, even after an
arbitrary party permutation, to the minimal-support AME state of any length-six
dimension-three generalized Reed--Solomon code over the same field.

The separator is C374's single basis-independent marginal-moment invariant. For every four-party
set `T`, put

```text
A_T = rho_T tensor I_(T^c).
```

Record the multiset of `Tr(A_T A_U A_V)` over the 455 unordered triples of four-party sets.
For a stabilizer state this moment is `q^(-r)`, where `r` is the rank of the sum of the three
corresponding shortened stabilizer-label planes. Every odd good non-GRS `H3` reduction has at
least 70 triples with `r=4`. Every six-point GRS class in odd characteristic other than five
has at most 66. C341 proves that characteristic five is exactly the GRS reduction of the
integral `H3` family, so it is absent from the theorem's non-GRS domain.

This proves arbitrary-LU separation without LU=`LC`, a continuous-unitary search, a
Pauli/decoder label, or a growing finite-field census. Nonzero GRS column multipliers are local
computational-basis scalings and hence local Clifford operations, so the bound covers all
generalized RS multipliers.

## Geometric reduction of the moment

Index a four-party marginal by its omitted pair, viewed as an edge of `K_6`. For a six-arc `A`
and its Gale dual `A*`, the two generators of the shortened CSS stabilizer plane are the
four-support words associated to that edge in `A` and `A*`. For three omitted edges, the
stabilizer sum has rank four exactly when the three corresponding chord lines concur in both
arcs.

There are two possible edge shapes:

1. A three-edge star. Its three chords concur at the common arc point in both `A` and `A*`.
   There are exactly

   ```text
   6 * binom(5,3) = 60
   ```

   such triples.
2. A perfect matching. Every other three-edge shape contains two adjacent edges but is not a
   star; their chords meet at the shared arc point, while the third chord misses it because the
   columns form an arc. Thus only perfect matchings can contribute beyond the universal 60.

Consequently

```text
# {q^-4 moments} = 60 + b(A,A*),
```

where `b(A,A*)` is the number of the fifteen perfect matchings whose three chords concur in both
the arc and its Gale dual. This formula is the free portable upgrade from C402: it translates
the quantum marginal moment into the common Brianchon-matching count of an associated pair of
six-arcs.

For the integral `H3` arc, exact arithmetic in `Z[tau]` gives ten common concurrent matchings.
The checker constructs an integral Gale basis

```text
[1-tau, 1-tau, -1, 1, 0, 0]
[-tau,  1,     -1, 0, 1, 0]
[1,    -tau,  -1, 0, 0, 1]
```

and verifies the same ten determinant identities on both sides. Because the basis and identities
are integral, all ten survive every good reduction. The Tao exactness check also evaluates the
five remaining matching determinants: their norms are `-64` on the arc and `-4` on its Gale
dual. They therefore remain nonzero in every odd characteristic. Thus the `H3` count is exactly
70 in every odd good reduction, not merely bounded below by 70.

## Uniform GRS bound

For six points `S` on a nonsingular conic, Gale duality returns the same marked rational-normal
curve configuration. A perfect matching has concurrent chords exactly when it is induced by a
fixed-point-free involution of `S` in

```text
Gamma = Stab_PGL2(k)(S).
```

The number `b(S)` is therefore the number of fixed-point-free involutions in `Gamma`.

The exact six-point permutation lemma is:

> Let `Gamma <= S_6` be induced by projectivities of `P^1`, so every nonidentity element fixes at
> most two of the six points. If `r` is the number of fixed-point-free involutions in `Gamma`,
> then
>
> ```text
> r in {0,1,2,3,4,6,10}.
> ```
>
> The case `r=10` contains an order-120 subgroup acting sharply three-transitively on the six
> points.

Here is a conceptual proof of the bound, independent of the finite certificate. The action of
`Gamma` on ordered triples of distinct points of `S` is free, because a projectivity fixing three
points is the identity. Hence

```text
|Gamma| divides 6*5*4 = 120.
```

In odd characteristic other than three or five, the group is tame. The classical finite-subgroup
classification of `PGL_2` leaves only cyclic, dihedral, `A4`, `S4`, and `A5`. Inspecting their
faithful actions on a six-set gives:

| projective subgroup type | maximum fixed-point-free involutions on six points |
|:---|---:|
| cyclic | 1 |
| dihedral | 6 |
| `A4` | 3 |
| `S4` | 6 |
| `A5` | 0 |

For the last row, the faithful degree-six action is on the six `D5` cosets and every involution
fixes two points; a degree-five orbit plus a fixed point has no fixed-point-free element. In
characteristic three, the order bound leaves only the semi-elementary `C3` and
`C3 semidirect C2` cases, the subfield cases `PSL_2(3)=A4`, `PGL_2(3)=S4`, and the exceptional
`A5`; the next subfield groups already exceed order 120. These again have at most six. This proves
`b(S)<=6` in every odd characteristic other than five without a moduli census.

In characteristic five, the only additional six-point case exceeding six is
`PGL_2(5)` on `P^1(F_5)`, with ten fixed-point-free involutions. Equivalently, if the abstract
permutation lemma reaches ten, its order-120 sharply three-transitive group has point stabilizer
`C5 semidirect C4`; outside characteristic five a semisimple `C5` lies in a torus whose projective
normalizer induces at most inversion, so the faithful `C4` action is impossible.

The certificate independently refines this conceptual proof. Without a group-library dependency,
it enumerates the 203 subgroups generated by the fifteen fixed-point-free involutions of `S_6`,
retains the 162 satisfying the projective fixed-point bound, and obtains exactly

```text
(group order, r) =
(1,0), (2,1), (4,2), (6,3), (12,4), (24,6), (120,10).
```

Therefore in odd characteristic other than five,

```text
b(S) <= 6
```

and every GRS state has at most `60+6=66` occurrences of the `q^-4` moment. The value 65 is
forbidden, not merely absent from the pilot.

The boundary is exact. In characteristic five the normalized exceptional set is
`{0,infinity,+/-1,+/-2}=P^1(F_5)`, and every projective `F_5`-subline has the ten
fixed-point-free involutions. Thus a GRS six-set has 70 rank-four triples if and only if it is a
projective `F_5`-subline. C341's characteristic-five `H3` reduction is precisely this case.

## The prescribed `q=19` full-moduli pilot

The checker also performs the requested first same-field falsifier. It enumerates all
`binom(20,6)=38,760` evaluation sets through their 13 exact `PGL_2(19)` orbits. The direct
stabilizer-shortening replay and the independent conic-chord replay agree orbit by orbit:

| concurrent perfect matchings | evaluation sets | `q^-4` triples |
|---:|---:|---:|
| 0 | 13,680 | 60 |
| 1 | 17,100 | 61 |
| 2 | 5,130 | 62 |
| 3 | 2,280 | 63 |
| 4 | 570 | 64 |

The `H3` state has `70` occurrences and there are zero collisions. This full GRS-moduli pilot is
a replay of the uniform proof, not the basis for extrapolating it. The C400 `C3` and two regular
relation sectors need not be labelled: the marginal construction is already arbitrary-LU
covariant and separates before the proposed fine-orbit operator is needed. The rank-four
orthogonal fusion remains too coarse as a relation classifier, but it is irrelevant to this
stronger one-number gap.

## `ej` and Tao closeout

The cheap upgrade is the associated-arc formula `60+b(A,A*)`, which explains both the success and
the sharp boundary of the invariant. The GRS side can realize only

```text
60, 61, 62, 63, 64, 66
```

outside characteristic five. The `H3` side supplies ten common Brianchon matchings and begins at
70. Thus the separator is not an unexplained fieldwise histogram: it is a four-count gap between
two exact incidence mechanisms.

The characteristic-five exception is forced from both directions. The exceptional GRS
permutation action has ten fixed-point-free involutions only in characteristic five, while C341's
conic determinant says that precisely there the integral `H3` six-arc itself becomes GRS. The
moment's loss of separation therefore coincides exactly with the classical code transition; it
does not signal a defect in the LU argument.

The `ej2` pass extracts a second intrinsic object from the same data. The five H3 matchings that
are **not** concurrent are

```text
01|23|45, 02|15|34, 03|14|25, 04|12|35, 05|13|24.
```

They partition all fifteen edges of `K_6`, so they form a one-factorization pentad. The indexed
marginal moments—not merely their count—therefore recover this pentad equivariantly under party
permutation. Its `S_6` orbit has size six and its party stabilizer has order 120; the induced
faithful action on the five factors identifies it with `S_5`. The even half has order 60 and is
exactly the H3 `A5`, because every degree-six permutation action of `A5` is even. Thus the
arbitrary-LU-readable marginal incidence canonically recovers the classical outer-`S_6` pentad
roof around the H3 symmetry.

This also identifies the invariant's exact information loss. The moment incidence sees `S_5`,
while the marked H3 projective symmetry is its even `A5` half. It retains the pentad but forgets
the index-two orientation bit. That is a structural boundary, not a reason to refine the separator.
The closeout literature audit finds this pentad/S5/A5 combinatorial core classical; the
novel-looking contribution is its canonical recovery from arbitrary-LU-covariant marginal data.

The final Tao pass tests whether a higher-degree word in the same marginal operators recovers the
lost bit. At q=19 the checker evaluates the ranks for all `2^15=32,768` subsets of the fifteen
shortened stabilizer planes. This is complete for trace words in the `A_T`: the stabilizer
marginals commute, and repetitions change only known projector scalars. The exact rank profile is

```text
degree 1: rank 2 on 15 subsets
degree 2: rank 4 on 105 subsets
degree 3: rank 4/6 on 70/385 subsets
degree 4: rank 4/6 on 30/1335 subsets
degree 5: rank 4/6 on 6/2997 subsets
degree 6--15: rank 6 on every subset
```

The cubic rank tensor has 120 party automorphisms, and the complete subset-rank function still has
exactly the same 120, with 60 even. Thus, at q=19, **no trace word of any degree in these commuting
four-party marginals can recover the H3 orientation bit**. A successful orientation detector
would need genuinely different noncommuting LU-covariant data, not a higher-degree marginal word.
This is a sharp bounded operator-family no-go, not an all-field assertion and not needed for the
H3/GRS separation theorem.

### Orientation frontier: what “different data” means

There is one genuine adjacent mystery: is the `A5` orientation LU-intrinsic at all? An odd element
of the recovered pentad `S5` might lift to a party permutation followed by local unitaries. If it
does, no LU invariant can recover the orientation. If it does not, compact-group invariant theory
guarantees that some general tensor-contraction invariant separates the two finite orbits.

The concrete candidate data, in increasing order of breadth, are:

1. **General multi-copy permutation contractions.** Take `m` copies of `Psi` and `m` copies of
   `conj(Psi)` and contract the local indices at party `i` by an independently chosen permutation
   `sigma_i in S_m`. These are honest polynomial LU invariants and strictly extend traces of words
   in reduced density matrices. The cheapest detector would be a contraction whose value changes
   under an odd pentad symmetry.
2. **Partially transposed or realigned marginal projectors.** A fixed partial-transpose pattern
   transforms covariantly with `U`/`conj(U)` on the appropriate legs and need not commute with a
   differently wired operator. Spectra or closed contraction networks are LU invariant when the
   conjugate-leg bookkeeping is consistent. Covariance must be proved for the complete network;
   a raw basis-dependent transpose is not admissible.
3. **Cut-to-cut flattening holonomies.** Every `3|3` flattening of an AME tensor is a scaled
   unitary. Closed products that transport between several cuts can cancel the local basis
   changes and retain an oriented spectrum. This is the arbitrary-LU analogue of C374's useful
   stabilizer holonomy, but it requires a canonical contraction pattern rather than Pauli labels.

The first falsifier is group-theoretic, not a search over these invariants: test whether an odd
pentad symmetry already lifts to a party-permuting local Clifford. C397 owns that exact Clifford
stabilizer gate. A positive lift kills the orientation question immediately. A negative result
does **not** exclude a non-Clifford LU lift; C546 therefore owns the full LU-stabilizer
classification before escalating, if necessary, to general contraction invariants. Thus this is
a real adjacent mystery with a sharp gate and allocated solver, not unfinished work needed by
C402.

The `ej3` pass removes the main continuous-search hazard before C546 starts. For any equal-phase
state of a linear `[6,3,4]_q` code, let `(X_1,...,X_6)` be an infinitesimal local-unitary
stabilizer:

```text
sum_i X_i^(i)|Psi_C> = lambda|Psi_C>.
```

If an off-diagonal entry `X_i[a,b]` were nonzero, evaluate the coefficient of the basis word
obtained from a codeword with coordinate `b` by changing only that coordinate to `a`. Distance
four makes this radius-one neighbor belong to no other codeword/coordinate contribution, so the
entry must vanish. Hence every `X_i` is diagonal. Writing its diagonal as `f_i:k->C` and
parameterizing `C` by six pairwise nonproportional linear forms `ell_i:k^3->k` gives

```text
sum_i f_i(ell_i(v)) = lambda.
```

Fourier expansion on the additive group of `k` places every nonconstant coefficient of `f_i` on
the projective frequency line spanned by `ell_i`. The six lines are distinct by the MDS property,
so no nonzero frequency can cancel across coordinates. Every `f_i` is constant.

Therefore the connected local-unitary stabilizer consists only of local scalar phases, which act
as one global phase. After quotienting that gauge, the H3 local-unitary stabilizer is finite in
every field covered by C402. C546 is consequently a discrete component/lift classification, not a
positive-dimensional unitary search. This Fourier tangent lemma is a task-owned feasibility
reduction; no novelty wording is attached before C546's audit.

There is also a direct hand-back to C396. Its recorded q=13 collision
`((4,66),(6,389))` says geometrically that both non-GRS pencil classes have six common concurrent
matchings with their Gale duals. C396 should compare those six-match configurations before doing
any further moment enumeration; the collision is now an incidence coincidence rather than an
opaque histogram equality.

The Tao stress test checks the possible hidden freedoms:

- party permutations merely permute the fifteen marginal operators;
- arbitrary party-local unitaries conjugate every `A_T` by the same global product unitary;
- GRS multipliers are already absorbed by local Cliffords;
- inert prime reductions and extension fields use the same field-linear rank and conic-involution
  argument;
- modular `H3` coincidences can only add common matching concurrences, while the GRS upper bound
  depends only on characteristic; and
- characteristic five is excluded by the theorem's own non-GRS hypothesis, not by a computational
  convenience.

The final Tao exactness pass removes the last slack in the statement: all five nonconcurrent
matching determinants have norms supported only at two, so no odd modular fibre can acquire an
eleventh common concurrence. No continuous-unitary, moduli, or arithmetic-phase mystery remains
for C402.

## Mystery ledger

| feature | disposition |
|:---|:---|
| Why the q=11 and q=19 `H3` histograms both contain 70 rank-four triples | **Settled:** 60 star triples plus ten integral common Brianchon matchings. |
| Whether an odd modular H3 fibre can have more than 70 | **Settled by the Tao exactness pass:** the other five determinant norms are `-64` and `-4`, so only characteristic two can create an extra concurrence. |
| Why GRS histograms stop below `H3` and skip 65 | **Settled:** the projective six-point permutation lemma allows `b=0,1,2,3,4,6`, but not 5. |
| Why a ten-matching GRS collision appears exactly at the excluded boundary | **Settled:** ten forces a sharply three-transitive six-set and hence characteristic five, exactly C341's GRS prime. |
| What the ten-versus-five H3 matching split intrinsically carries | **Settled by `ej2`:** the five nonconcurrent matchings are a one-factorization pentad with `S5` stabilizer and even `A5` half. |
| Which H3 datum the marginal incidence forgets | **Settled by `ej2`:** it recovers the `S5` pentad roof but not the index-two orientation selecting the marked `A5` half. |
| Whether higher-degree words in the same marginals recover that bit | **Settled negatively at q=19 by the final Tao pass:** all 32,768 subset ranks retain the same 120-element `S5` party symmetry. |
| Whether the orientation is LU-intrinsic at all | **Open adjacent mystery, allocated to C546:** C397 supplies the first party-permuting LC-lift falsifier; C546 then owns the full arbitrary-LU lift classification and, if no lift exists, a finite general contraction/flattening detector. |
| Whether C546 faces a positive-dimensional continuous stabilizer | **Settled negatively by `ej3`:** the radius-one/Fourier tangent lemma leaves only local scalar gauge, so the projective LU stabilizer is finite. |
| What C396's q=13 moment collision is remembering | **Settled at the invariant level:** both classes have six common arc/Gale matching concurrences; identifying the two six-match configurations remains C396-owned. |
| Whether C400's fine scalar-orbit eigenrows admit a separate arbitrary-LU-covariant operator | **Not needed for C402:** the uniform theorem closes before that construction. No successor is required by this task. |

## Evidence, replay, and trusted boundary

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-23-c402-h3-ame-uniform-lu-separation.py --check
sha256sum -c notes/2026-07-23-c402-h3-ame-uniform-lu-separation.sha256
```

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 28,651 | `914fc8b57af5a14035fd5d2cc4cf7902388c7d15bcdd831e834518aecf2b2627` |
| certificate `.json` | 12,677 | `f324ea645f9ac10e8dee150b9d5e5c321547f23d3925dda78d556f31db521320` |

The deterministic standard-library checker uses exact rational arithmetic in
`Q(tau)`, exact permutation closure in `S_6`, integer arithmetic modulo 19, and canonical JSON.
Its independent q=19 replay compares chord-concurrence determinants with direct ranks of sums of
shortened six-dimensional Pauli-label Lagrangians.

The trusted mathematical boundary is the standard MDS--minimal-support-AME dictionary, C374's
derivation and arbitrary-LU covariance of the marginal moment, the six-arc/Gale-shortening
dictionary proved above, and the elementary conic polarity correspondence between concurrent
chord matchings and projective involutions, together with the classical finite-subgroup
classification of `PGL_2` used in the conceptual GRS bound. The certificate supplies an
independent finite permutation replay of that last step. It does not classify arbitrary
non-GRS AME states, claim that the moment multiset is a complete LU invariant, or address
phase-deformed non-stabilizer AME families.

## Claim-specific literature audit

### Read-depth summary and verdict

This closeout audit consulted four sources: **one full text** and three partial texts. In a bounded
claim-specific search, no predecessor was located for either

```text
# {rank-four triple marginal moments} = 60+b(A,A*)
```

or the uniform good-characteristic inequality `H3 =70 > 66 >= GRS`. These are the
novel-looking, publishable claims. Polynomial LU invariants themselves remain standard prior art.

The pentad conclusion must be split sharply. The `K_6` one-factorization, its exotic `S5`
stabilizer, its even `A5` half, and the icosahedral `5+10` split are classical and pre-empted. The
novel-looking statement is instead that the arbitrary-LU-covariant marginal incidence of the
integral H3 AME state canonically recovers that classical Sylvester pentad and exposes the exact
lost orientation bit.

Safe release wording is:

> For this CSS family, the triple four-party-marginal moment admits the exact incidence formula
> `60+b(A,A*)`. Consequently every odd good non-GRS H3 reduction is LU-inequivalent, even after
> party permutation, to every same-field GRS-derived state.

Do not claim novelty for polynomial/marginal invariants generally, the Sylvester pentad, the outer
automorphism of `S_6`, or the abstract `S5/A5` dictionary.

### Consulted sources

| source | read depth and exact access | C402 boundary |
|:---|:---|:---|
| Ben Howard, John Millson, Andrew Snowden, Ravi Vakil, *A description of the outer automorphism of S6, and the invariants of six points in projective space* | **full text:** arXiv `0710.5916v1`, all Sections 1--2 and references; cache `arXiv:0710.5916`, SHA-256 `d2da258cd8513a9b782a8270baa82acc51bc8d552e18db104967c2a08bffebfc`; published DOI metadata `10.1016/j.jcta.2008.01.004` checked through Crossref/OpenAlex | Sections 1.1--1.5 own synthemes, pentads, the exotic `S5`, and parity/color; Sections 2.3--2.4 treat Gale transforms of six points, the conic/self-associated branch, and matching invariants. No quantum marginal formula appears. |
| N. Ramadas, Arul Lakshminarayan, *Local unitary equivalence of absolutely maximally entangled states constructed from orthogonal arrays* | **partial:** arXiv `2411.04096v1`, Sections 3 and 5 including Corollary 2, the `N=6` discussion, and references 27--32; cache `arXiv:2411.04096`, SHA-256 `a73e8c2c48c2d55f07b1e34bc75ba0d18c7115ec4e65d412605f52bf7430c647` | Owns a complete polynomial-LU-invariant framework and infinite families of `AME(6,d)` LU classes; no six-arc/Gale/matching formula or H3-versus-GRS theorem was found in the inspected portions. |
| Grzegorz Rajchel-Mieldzioc, Rafal Bistron, Albert Rico, Arul Lakshminarayan, Karol Zyczkowski, *Absolutely maximally entangled pure states of multipartite quantum systems* | **partial:** arXiv `2508.04777v1`, Section VII pp. 14--16 and exact-text hits for `AME(6,d)`, marginals, GRS/Reed--Solomon, and stabilizers; cache `arXiv:2508.04777`, SHA-256 `bc8ee8fc5648b574dc8e994eb7d27b7ef213e1873a2204e4060cc3613e15760b` | Confirms that LU classification remains difficult/open in general and polynomial invariants are standard; no exact C402 object was found in the inspected passages. |
| John Baez, *Some Thoughts on the Number 6* | **partial:** live author HTML `https://math.ucr.edu/home/baez/six.html`, “The icosahedron and the number six” through Puzzle 10, lines 13--141, plus the `F_5` remarks at lines 269--276; no PDF-cache key because the HTML was read live | Gives the explicit five true/ten skew cross split, the true crosses as a synthematic total, rotational `A5`, and the `PGL_2(5)=S5`, `PSL_2(5)=A5` interpretation. This exposition corroborates the classical boundary established from Howard et al.'s full text. |

### Screened sets

On 2026-07-23 the audit ran these exact queries:

```text
AME(6,q) GRS local unitary
four-party marginal moment stabilizer AME
six-arc Gale dual perfect matching concurrency
K6 one-factorization pentad S5 A5
H3 AME GRS stabilizer
concurrent perfect matchings six points conic
```

OpenAlex returned the top `25,25,25,0,2,25` records, 102 records total, from provider metadata
totals `53,54,53,0,2,108`. The screen ran over title, abstract inverted index,
identifier/DOI, and year. Its verbatim discriminator was:

```text
retain iff ("absolutely maximally entangled" or "AME(6") and
("local unitary" or "Reed-Solomon" or "stabilizer" or "marginal"),
or ("six points"/"six-point") and ("Gale dual"/"Gale transform") and
("matching"/"pentad"/"conic"),
or ("one-factorization"/"syntheme"/"pentad") and
("K6"/"S6"/"A5"/"S5"/"icosahedron")
```

It retained one item for individual inspection, the 2026 AME review above, and zero exact
formula/H3/GRS records. Crossref completed only queries 1 and 3: 50 title/abstract/DOI records were
screened from noisy totals `10,945,358` and `999,273`, with zero exact-object records. The other
four Crossref searches returned HTTP 429 and are **NOT COVERED**. All six Semantic Scholar
searches returned HTTP 429 and are **NOT COVERED**.

Discovery-only exact browser probes located the two classical pentad sources but no exact quantum
predecessor. They included combinations of `AME(6,q)`, GRS, local unitary, six-point Gale
transform, concurrent matchings, synthemes/pentads, H3, marginal polynomial invariants, the counts
60/66/70, and `F_5`-subline.

No forward-citation closure was used, so the three-provider pinned-seed rule was not triggered.
MathSciNet and Google Scholar are **NOT COVERED**; zbMATH Open received exact-term probes but not an
exhaustive MSC screen. The Ramadas paper and 2026 AME review were not read in full. Therefore the
licensed conclusion is “no predecessor was located in this bounded claim-specific search,” never
“first” or an unconditional universal priority claim.
