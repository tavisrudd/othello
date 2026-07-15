# C180 — Conceptual Clebsch rigidity

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **INCIDENCE + PROJECTIVE PRISM LEAN COMPLETE; EXTRACTION + SOURCE GATES OPEN** — the
generic incidence spine, `K6` normal form, projective normalization, and division-free odd-field
contradiction pass Lean. The remaining formal seam is extracting the explicit prism points and
directions from the five equality fibers; manuscript integration also waits for Dye 1991.

## Target

Replace the explanatory role of the exhaustive `PG(2,11)` six-arc census in the rigidity theorem
by two short geometric arguments. The exact census remains a valuable independent certificate.

1. **Nonsingular containing conic.** For any six-arc `A` in `PG(2,11)`, let `c(A)` be the number of
   accidental triple concurrences of chords. C174 gives

   ```text
   |U(A)| = 22 - c(A).
   ```

   If `U(A)` lies on a nonsingular conic, then `|U(A)| <= 12`. Dye's Brianchon bound
   `c(A) <= 10` gives the reverse inequality, hence equality. Dye's equality classification should
   then identify `A` as a Clebsch hexagon.
2. **Degenerate containing conic.** Prove directly that the uncovered locus of a six-arc cannot be
   contained in two projective lines. This is currently known only through the exact census.

## Source checkpoint

Dye's open 1997 self-recap was read directly. It states both:

- “a hexagon can have at most 10 Brianchon points,” citing Dye 1991, p. 275; and
- “All hexagons with 10 Brianchon points are projectively equivalent,” again citing Dye 1991.

The 1997 paper works over complex projective space. It is strong author-written triangulation, not
yet a license to apply the theorem in characteristic 11. C180 must read Dye 1991, p. 275 and record
the exact field, characteristic, nondegeneracy, and definition hypotheses. In particular it must
verify that Dye's distinct Brianchon points agree with C174's distinct off-arc perfect-matching
triple concurrences.

Open source: R. H. Dye, *Space sextic curves with six bitangents, and some geometry of the diagonal
cubic surface*, Proc. Edinburgh Math. Soc. 40 (1997), 85--97,
<https://doi.org/10.1017/S0013091500023452>.

## Proof obligations

- obtain or legally inspect Dye 1991 p. 275;
- pin the equality statement to the manuscript's projective-equivalence conclusion;
- prove the line-pair exclusion without enumerating the 1548 normalized arcs;
- keep nonsingular and degenerate arguments separate;
- retain `check_rigidity_degenerate_conic.py` as an independent finite verification and regression
  test rather than deleting it.

## Structural line-pair proof

The needed exclusion reduces to a small affine-direction lemma, with no six-arc census.

**Lemma.** In `PG(2,q)` over a field of odd characteristic, every line contains at most
`q-5` points of `U(A)` for a six-arc `A`; in particular, the bound is six when `q=11`.

- A chord contains none.
- If a non-chord line contains one vertex of `A`, the ten chords among the other five vertices
  induce a proper edge-colouring of `K5` by their intersection points with the line. Since
  `chi'(K5)=5`, those intersections plus the vertex give at least six covered points.
- Suppose a line disjoint from `A` had only five covered points. The fifteen chords would then give
  a five-colour proper edge-colouring of `K6`, hence a 1-factorization. Send the line to infinity
  and select three factor classes whose union is a triangular prism. Relabel them as

  ```text
  M0={12,34,56}, M1={13,25,46}, M2={14,26,35}.
  ```

  Affinely normalize `M0` horizontal and `M1` vertical:

  ```text
  P1=(0,0), P2=(1,0), P3=(0,1),
  P4=(a,1), P5=(1,b), P6=(a,b).
  ```

  Parallelism of `14 || 26` gives `a(b-1)=-1`, while `14 || 35` gives
  `a(b-1)=1`, impossible in odd characteristic. Thus a disjoint line also has at least six
  covered points. Since a projective line has `q+1` points, it therefore has at most `q-5`
  uncovered points, which is six for the application over `F_11`.

If `U(A)` lies in two lines, then at `q=11` the lemma gives `|U(A)|<=12`. C174 and Dye give

```text
12 <= 22-c(A) = |U(A)| <= 12,
```

so `c(A)=10`. Dye's equality classification makes `A` a Clebsch hexagon. Its uncovered locus is
the nonsingular 12-point invariant conic, which cannot lie in two lines because each line meets it
in at most two points. A double line is covered by the same lemma. A rank-two nonsplit singular
conic has only its singular point over the ground field, so it cannot contain `|U(A)|>=12` at all.

## Lean boundary

`lean/RelativeConicArcs/OddSixArcLineBound.lean` now proves, without new axioms or computational
oracles, the total secant-index count, the chord and one-vertex cases, the five-point disjoint-line
bound and its equality structure, the covered/uncovered partition, and a master `q-5` theorem
conditional only on excluding that equality case. It also proves the final scalar contradiction
once the two affine parallelism equations are supplied.

`lean/RelativeConicArcs/SixVertexOneFactorization.lean` closes the first bridge: every
one-factorization relabels to the standard total and contains the required triangular prism. A
tracked `uv` generator independently enumerates 15 perfect matchings and exactly six labelled
one-factorizations with explicit relabelling witnesses. Lean checks the six-witness table and the
semantic completeness claim with ordinary kernel reduction.

`lean/RelativeConicArcs/OddSixArcAffinePrism.lean` also proves that affine lines through a common
point at infinity have parallel direction vectors and, using the certified ordered-triple
normalizer, rules out any projective realization of the prism off its direction line. The final
proof is division-free: its two direction determinants differ by `2*x*y`, while injectivity gives
`x*y != 0`. The sole remaining internal bridge extracts the prism points/directions from the five
equality fibers and feeds them to this theorem. All focused targets
build fresh with `LEAN_NUM_THREADS=1` and `choom -n 500`; their manuscript-facing axiom reports
contain only `propext`, `Classical.choice`, and `Quot.sound`.

The nonsingular case is even shorter: conic containment already gives `|U(A)|<=12`, so the same
equality argument applies. Once Dye's exact field/descent statement is pinned, these two arguments
replace both census branches while leaving the checker as independent confirmation.

An `asg` audit found no earlier session that directly read Dye 1991; every internal assertion of its
field scope ultimately traces to the 1997 self-recap or later summaries. The p.275 source gate is
therefore real, not merely missing from the current handoff.

The proxy chain is nevertheless strong. Dye's own zbMATH review says that the 1991 paper does not
restrict `K` to be finite, defines a Clebsch hexagon by its ten nonvertex triple-edge concurrences,
proves existence exactly when `char(K)!=2` and `5` is a square, and states that `PGL3(K)` is
transitive on them. Thus `F_11` satisfies the advertised hypotheses. Storme--Van Maldeghem
independently define the ten Brianchon points as points on exactly three bisecants in the odd
`q ≡ +/-1 (mod 10)` case. This also matches C174's `c(A)` exactly: three chords concurrent away
from a six-arc have pairwise disjoint endpoints and hence form one perfect matching, and the
matching attached to a concurrence point is unique.

Dye's open 1997 self-recap is even more specific: it attributes both “at most ten” and “all
ten-point hexagons are projectively equivalent” directly to the 1991 paper, p.275. Together with
the signed review's ground-field transitivity statement, this gives very high confidence that the
two inputs are valid over `F_11` and that there is no hidden algebraic-closure descent step. The
adversarial confidence is approximately 0.97, but that is not a substitute for reading the cited
page; the primary-source gate remains open.

No source found a separate concurrency-count gap such as `c>=8 => c=10`. C180 does not need one:
the new line-pair lemma already gives `|U|<=12`, hence `c>=10`, and Dye's bound gives equality.

Access ledger:

- Dye 1991 OUP record: <https://academic.oup.com/jlms/article/s2-44/2/270/847669>;
- Dye's zbMATH review: <https://api.zbmath.org/v1/document/_search?search_string=Dye%20hexagons%20conics>;
- Storme--Van Maldeghem author PDF: <https://cage.ugent.be/~hvm/artikels/41.pdf>.

No legal open full text was found through OUP/Wiley, OpenAlex, Semantic Scholar, or repository
searches. The practical routes are an institutional Wiley/OUP login, ILL for pp.270--286, or an
author-copy request through Newcastle Mathematics (`maths.physics@ncl.ac.uk`).

## Grade impact

Success would turn the paper's central theorem from an exact classification result into a
conceptual equality theorem. That is the clearest remaining route from strong A-minus to A.
