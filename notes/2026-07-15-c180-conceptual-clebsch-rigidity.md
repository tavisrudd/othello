# C180 — Conceptual Clebsch rigidity

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED** — the
generic incidence spine, proper five-edge-colouring, `K6` prism extraction, projective
normalization, and division-free odd-field contradiction pass Lean. Dye 1991 pp.270--276 has now
been read directly and supplies the exact ground-field bound and equality classification needed at
`K=F_11`.

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

Dye 1991 has now been inspected directly. The exact chain is:

- p.270: a hexagon is a set of six points, no three collinear, and its edges are their fifteen
  pairwise joins;
- p.271: a Brianchon point is a nonvertex point through which three edges pass, and a Clebsch
  hexagon is a hexagon with exactly ten Brianchon points;
- pp.274--275 (§2.2): in characteristic different from two, no edge can contain three Brianchon
  points, because these would be the three collinear diagonal points of the quadrangle on the four
  remaining vertices; hence double counting edge--Brianchon incidence gives at most
  `15*2/3=10` distinct Brianchon points;
- p.275, Theorem 1(i): Clebsch hexagons exist in `PG(2,K)` exactly when `char(K)!=2` and `5` is a
  square in `K`;
- p.275, Theorem 1(ii), proved through p.276: `PGL_3(K)` is transitive on the Clebsch hexagons when
  they occur. This is a ground-field statement and removes the suspected descent issue.

For `K=F_11`, the hypotheses hold because `char(K)=11` and `4^2=5`. Dye's definition agrees with
C174's `c(A)`: at a nonvertex point, concurrent chords have disjoint endpoint pairs, so three such
chords are exactly one perfect matching of the six vertices; conversely every counted accidental
perfect-matching concurrence is a Dye Brianchon point. Thus Dye proves both `c(A)<=10` and that
`c(A)=10` places `A` in the unique `PGL_3(11)` Clebsch orbit.

## Proof obligations

- integrate the direct Dye theorem chain and conceptual line-pair proof into the manuscript;
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

`lean/RelativeConicArcs/SixVertexOneFactorization.lean` closes the finite bridge. It proves
semantically that every proper five-edge-colouring of `K6` is a one-factorization, relabels every
one-factorization to the standard total, and returns three distinct named colours on the nine
required triangular-prism edges. A
tracked `uv` generator independently enumerates 15 perfect matchings and exactly six labelled
one-factorizations with explicit relabelling witnesses. Lean checks the six-witness table and the
semantic completeness claim with ordinary kernel reduction.

`lean/RelativeConicArcs/OddSixArcAffinePrism.lean` also proves that affine lines through a common
point at infinity have parallel direction vectors and, using the certified ordered-triple
normalizer, rules out any projective realization of the prism off its direction line. The final
proof is division-free: its two direction determinants differ by `2*x*y`, while injectivity gives
`x*y != 0`.

`lean/RelativeConicArcs/OddSixArcPrismExtraction.lean` closes the remaining internal bridge. It
canonically labels the six arc vertices, maps every chord to its intersection with the disjoint
line, proves that the resulting five-colouring is proper, extracts the three prism colour classes,
and transports their nine edges to three distinct covered points. The resulting theorem
`incidencePrismWitness_of_five` feeds the projective prism obstruction, and
`card_coveredOnLine_ne_five` rules out the equality case directly in every finite odd
Desarguesian plane. All focused targets
build fresh with `LEAN_NUM_THREADS=1` and `choom -n 500`; their manuscript-facing axiom reports
contain only `propext`, `Classical.choice`, and `Quot.sound`.

The nonsingular case is even shorter: conic containment already gives `|U(A)|<=12`, so the same
equality argument applies. Dye's directly checked bound supplies `|U(A)|>=12`, and his
ground-field transitivity theorem classifies equality. These two arguments can therefore replace
both census branches while leaving the checker as independent confirmation.

The primary text confirms the earlier proxy chain and removes its residual uncertainty.
Storme--Van Maldeghem independently define the ten Brianchon points as points on exactly three
bisecants in the odd `q ≡ +/-1 (mod 10)` case, while Dye's own 1997 self-recap attributes both the
upper bound and projective uniqueness to the same 1991 page. These are now corroborating sources,
not substitutes for the primary theorem.

No source found a separate concurrency-count gap such as `c>=8 => c=10`. C180 does not need one:
the new line-pair lemma already gives `|U|<=12`, hence `c>=10`, and Dye's bound gives equality.

Access ledger:

- Dye 1991 OUP record: <https://academic.oup.com/jlms/article/s2-44/2/270/847669>;
- Dye's zbMATH review: <https://api.zbmath.org/v1/document/_search?search_string=Dye%20hexagons%20conics>;
- Storme--Van Maldeghem author PDF: <https://cage.ugent.be/~hvm/artikels/41.pdf>.

## Manuscript disposition

The conceptual proof is integrated. The six-arc line bound handles both split and nonsplit
degenerate conics, while the chord-defect identity and Dye's sharp ten-Brianchon bound force
equality and his ground-field classification identifies the Clebsch orbit. The 1,548-representative
census remains only for the independent size-gap clause and finite regression check; it no longer
carries the conic-containment implication.

Primary OCR inspected locally from the user's authorized copy: `dye-1991.txt`. Because equations
(4)--(12) are badly OCR-corrupted, manuscript use should quote the theorem statements and
combinatorial proof only; any displayed coordinates must be checked against page images.

## Grade impact

Success would turn the paper's central theorem from an exact classification result into a
conceptual equality theorem. That is the clearest remaining route from strong A-minus to A.
