# C490 — small-field complete-child base-size closure

**Lane:** `reed-solomon`

## Result

Let `A` be an unlabelled six-arc in `PG(2,q)`, let `L=U(A)` be its literal complete child, and
let `Sigma_T` be the diagonally coherent projected-sextic signature on `T subset L`, with one
global `S6` transporter and the finite-field colours retained equivariantly.  The residual clause
in C485 has the following exact closure.

> **Small-field complete-child theorem.**  For every prime power `q<=13`, every nonempty
> fixed-child fibre is either one of the rows in the table below or is already a singleton.
> Every recoverable fibre has base size at most three.  There are two and only two obstruction
> mechanisms: an empty child, for which no centre can be selected, and at `q=7` the two-point
> conic-complement child, on which all 294 literal parents have the same coherent signature even
> after both centres are used.

Together with C485's secant-union rigidity for `q>=16`, this is the all-field statement: outside
those classified empty/two-point exceptions, three complete-child centres always recover the
parent; for `q>=16` and for every q=13 fibre the child alone already does so.  The fields q=2,3
are vacuous because `PG(2,q)` has no six-arc.

The complete nontrivial table is:

| q | `|L|` | literal parents | arc-orbit composition | exact base | recovering subsets |
|---:|---:|---:|---|---:|---:|
| 7 | 2 | 294 | 294 conic | impossible | `0/1`, even for all of `L` |
| 8 | 4 | 10 | `6` non-GRS + `4` conic | 3 | every triple (`4/4`) |
| 9 | 6 | 8 | one orbit | 3 | `12/20` triples |
| 9 | 7 | 2 | one orbit | 2 | `15/21` pairs |
| 9 | 8 | 4 | one orbit | 2 | `16/28` pairs |
| 9 | 8 | 2 | one orbit | 2 | `16/28` pairs |
| 11 | 12 | 22 | one orbit | 3 | every triple (`220/220`) |

All other nonempty fibres are singleton fibres: one at q=9 with child size four, fourteen at
q=11 with child sizes `16,18,19,20,21,22`, and all twenty-six q=13 fibres with child sizes
`36,38,39,40,41,42`.  Their base size is zero.

The empty-child exceptions contain exactly `168, 3100, 625632, 2060352, 707616` literal parents
at q=`4,5,7,8,9`, respectively.  Their normalized-presentation counts are `1,3,40,45,6`; the
literal counts follow by multiplying by `|PGL_3(q)|/360`, because a six-arc has 360 ordered
projective frames.  At q=7 the empty fibre contains two semilinear arc types; the other four
empty fibres contain one type, but the literal parent is still not recoverable from an empty
signature.

## 1. Structural reduction before enumeration

For a nonempty literal child `L`, put `Z=PG(2,q)-L`.  A line can be a parent secant exactly when
it is disjoint from `L`.  The primary classifier therefore does not enumerate arbitrary
six-subsets.  It first forms this intrinsic candidate-line set, then recursively constructs only
six-arcs all of whose fifteen secants lie in it, and retains exactly those whose uncovered locus
is `L`.  Equivalently these are the admissible fifteen-line decompositions of `Z` from C485.

Projective normalization fixes the standard four-frame and quotients by coefficientwise
Frobenius before this bounded pass.  The resulting semilinear orbit counts are

```text
q:                       4  5  7  8  9  11  13
six-arc orbit count:     1  1  3  3  6  15  26.
```

The exact-cover pass joins the two q=8 four-point orbit types into one literal child fibre and
finds no q=13 alternative decomposition at all.  Thus C485's four q=13 common-secant skeletons
are an exhaustive analytic prefilter whose putative nontrivial strata are empty: every q=13
candidate child has one admissible fifteen-secant decomposition.

The child-size identity

```text
|U(A)| = q^2 - 14q + 55 - tau(A)
```

is checked in every row.  Candidate-line counts, the complete parent lists for nonempty fibres,
and orbit compositions are stored in the certificate.

## 2. Exact coherent collision hypergraph

For distinct literal parents `A,B` over the same child and each of the 720 diagonal label
transporters `pi`, define

```text
D_(A,B,pi)={u in L : atlas_A(u) != pi.atlas_B(u)}.
```

The computation uses all thirty balanced four-cycle coordinates.  A subset `T` recovers exactly
when it meets every `D_(A,B,pi)`.  The certificate stores every distinct disagreement bit mask
with its exact multiplicity, not merely a successful subset.  Exhaustive hitting gives:

| fibre | distinct masks | possible `|D|` | decisive consequence |
|---|---:|---|---|
| q=7, `|L|=2` | 2 | `0,2` | the empty hyperedge proves impossibility |
| q=8, `|L|=4` | 11 | `2,3,4` | every triple hits; no pair does |
| q=9, `|L|=6` | 18 | `3,4,5,6` | exactly 12 triples hit |
| q=9, `|L|=7` | 10 | `4,6,7` | exactly 15 pairs hit |
| q=9, both `|L|=8` fibres | 11 each | `4,7,8` | exactly 16 pairs hit in each |
| q=11, `|L|=12` | 79 | `10,11,12` | every triple hits; no pair does |

This supplies both halves of each exact minimum: a hitting witness at the claimed size and all
lower failures.  It also replays the frozen `3/3/2/3` thresholds.  The q=8 row is stronger than
the frozen six-parent control: the same triple simultaneously separates its four conic parents,
so the full fixed-child fibre is `6+4` and still has base three.

For each disagreement-cardinality stratum the certificate retains a representative balanced-
quartic ideal.  It divides all common rational line factors and gives two residual generators
whose restrictions to an explicit affine line are coprime with full degree.  Such a witness proves
that no residual common curve component exists: a common homogeneous factor would retain positive
degree on that line and divide both univariate restrictions.  The recorded line factors are the
complete positive-dimensional components of those representative ideals; all remaining collision
loci are zero-dimensional.  This is a representative component audit, not a claim that
disagreement cardinality alone classifies transporter-orbits of ideals.  The finite theorem does
not need that stronger statement: every transporter instance is evaluated directly in the exact
collision hypergraph, so no Bezout or component-extrapolation assumption enters the base sizes.

## 3. The q=7 collapse and the q=8 mixed fibre

The extra-juice pass exposes the geometry behind the two new features.

At q=7 the nonempty case is necessarily a conic `C` with eight rational points, with
`A=C(F_7)-L` and `|L|=2`.  Projection from either point of `L` turns the other six retained conic
points into the unique six-point complement in `P1(F_7)`.  Across the two centres the same global
six-label correspondence remains available.  The exact certificate consequently has an empty
disagreement hyperedge, and all 294 parents lie in one coherent signature fibre.  This is not a
failure of the hitting search: the whole available child carries no more information.

At q=8 the child has four points and admits ten parents.  Canonical conic testing splits them as
four conic parents and six non-GRS parents; the latter are exactly the frozen C478 fibre.  No pair
of centres separates all ten, while every triple does.  Thus the conic branch and exceptional
non-GRS branch meet over one child without creating a new base-size obstruction.

## 4. Evidence and replay

The atomic evidence bundle is:

```text
notes/2026-07-22-c490-small-field-base-size-closure.py
notes/2026-07-22-c490-small-field-base-size-closure.json
notes/2026-07-22-c490-small-field-base-size-closure-replay.py
notes/2026-07-22-c490-small-field-base-size-closure.sha256
```

From `/home/tavis/src/othello` run:

```bash
python3 notes/2026-07-22-c490-small-field-base-size-closure.py --check
python3 notes/2026-07-22-c490-small-field-base-size-closure-replay.py
python3 notes/2026-07-22-c478-exceptional-family-controls.py --check
python3 notes/2026-07-22-c478-exceptional-family-controls-replay.py
sha256sum -c notes/2026-07-22-c490-small-field-base-size-closure.sha256
```

The primary generator uses deterministic polynomial-basis models for every prime power
`4,5,7,8,9,11,13`, canonical four-frame normalization, exact child-derived candidate lines, and
the complete 720-element diagonal transporter set.  The independent replay has separate field,
projective, determinant, atlas, uncovered-locus, collision-mask, and hitting-set implementations.
It checks every one of the 383 stored nonempty-child parents and every transporter comparison.
The exact comparison count is `31,235,760`.
The inherited C478 replay separately pins the four frozen controls.

The trusted boundary is explicit: completeness of the parent lists rests on the primary
candidate-line clique enumeration plus exact child equality and orbit accounting.  The replay
independently checks every emitted parent and recomputes the full collision hypergraph, but does
not implement a second missing-parent enumeration.  Thus arithmetic/signature drift has an
independent detector; the short exhaustive enumeration argument remains part of the primary proof.

The checker proves the stated bounded classification only.  It does not turn finite exhaustion
into a claim about arbitrary normal rational curves, higher redundancy, or the general
Reed--Solomon deep-hole conjecture.

## NRC bridge ledger

| device | survives for `nu_(r-1)(P1) subset PG(r-1)` | six-point / plane dependence |
|---|---|---|
| union rigidity | comparing two finite unions of rational flats by restricting to one component and bounding intersections is dimension-independent | C485 uses fifteen **lines** and the five-fold vertex incidence special to six points in `PG(2)` |
| arrangement characteristic count | inclusion data of the forbidden-flat arrangement determines the complete-child cardinality and supplies free strata | `tau` as concurrent perfect matchings and `q^2-14q+55-tau` use `K6` secants in a plane |
| child-derived exact cover | enumerate only flats wholly contained in the child complement, then validate admissible decompositions | reconstruction as six five-fold points from fifteen lines is plane-specific |
| coherent collision ideal | determinant brackets are linear in the centre, so equality of balanced ratios gives transporter-coherent quartics in any ambient dimension | thirty four-cycle coordinates completely model a projected labelled sextic only in the present `M_0,6` package |
| orbitwise hitting | recovery is exactly a transversal problem for disagreement sets under one global label transporter in every dimension | the bound three and the mask tables are strictly small-field/six-point facts |
| distinct-point interpolation | restriction of collision polynomials to a chosen line gives exact coprimality witnesses and finite root bounds | the q=7 collapse uses the accident `|P1(F_7)|=8=6+2` |

The next higher-NRC lemma is therefore not “repeat the six-arc census.”  It is a theorem identifying
a finite generating atlas for projected punctured normal rational curves and proving that its
balanced collision ideal has controlled common components.  Only after that lemma is available do
the union-rigidity and hitting tools above transfer without changing the output functor.

## Extra-juice closeout

Three free upgrades were obtained after the acceptance gate.

1. The q=8 frozen fibre is not isolated: it is the non-GRS `6` inside an exact mixed `6+4`
   fixed-child fibre, and its base-three witness separates both branches simultaneously.
2. The q=7 failure is conceptual rather than merely enumerative: the two omitted rational conic
   points leave the unique six-point complement after either projection, forcing complete coherent
   blindness.
3. The hitting counts are design-like, not just minima: every q=8 and q=11 triple works, while the
   two new q=9 eight-point fibres have the same `16/28` recovering-pair count despite different
   parent multiplicities.

## Mystery ledger

- **Settled — the q=13 frontier.**  All twenty-six semilinear arc types have unique child-derived
  fifteen-line decompositions; none of C485's four allowable common-secant skeletons occurs in an
  equal-child pair.
- **Settled — the q=7 two-centre anomaly.**  It is the rational conic-complement accident above,
  and the empty disagreement hyperedge certifies that no subset can repair it.
- **Settled — the missing q=8 parents.**  Four conic parents join the six frozen non-GRS parents;
  every triple still recovers all ten.
- **Partly settled — repeated q=9 `16/28` pair counts.**  The exact masks and component witnesses
  are certified, but no intrinsic child-stabilizer design theorem yet explains why the four-parent
  and two-parent eight-point fibres have the same number of recovering pairs.  This is an NRC-ledger
  observation, not a successor allocation.
- **Protected by the Tao stress test — component scope.**  The factor certificates classify one
  ideal in each disagreement-cardinality stratum.  They do not prove that equal cardinality means
  one stabilizer orbit.  Full orbitwise factor classification remains an NRC-ledger lead; it is not
  used by the exhaustive finite hitting theorem or advertised as a C490 acceptance claim.
- **No remaining C490 acceptance mystery.**  Every field and every fixed-child fibre in scope is
  either assigned its exact base size or placed in the explicit impossible table.

## Terence Tao stress test

The closeout was re-audited against four tempting shortcuts.

1. **Literal parents are not semilinear orbit types.**  Empty signatures fail on the millions of
   literal parents even when those parents occupy one semilinear orbit; the report gives both
   counts and never substitutes the smaller orbit count for injectivity of `Sigma_T`.
2. **Frobenius colours are retained.**  Parent grouping uses semilinear normalization, but atlas
   comparison uses the C478 Galois-equivariant convention: one diagonal `S6`, with field colours
   retained rather than independently Frobenius-quotiented.  This is why the q=8 triple separates
   all ten parents.
3. **The all-field endpoints are explicit.**  The certificate directly checks all `7` and `13`
   projective points at q=2,3 and finds no six-arc; q=16 is already covered by C485's `q>=16`
   rigidity, so there is no prime-power gap between 13 and 16.
4. **Factor representatives are not silently called orbits.**  An earlier draft over-promoted one
   ideal per disagreement size to an exhaustive component classification.  That sentence was
   removed.  Exact base sizes rest on all 31,235,760 transporter comparisons, while the recorded
   factor witnesses serve only as geometric explanations and NRC-bridge data.

## Vibe check

This closes better than a uniform three-centre theorem would have: the only failures are exact,
geometrically intelligible information-theoretic exceptions, while q=13 collapses all the way to
base zero and the new q=9 fibres improve to base two.
