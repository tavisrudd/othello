# C181 — Classification-free isolation of q=11

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED; MANUSCRIPT INTEGRATED** — the universal elementary bound
`c(A)<=15` replaces Dye and reduces every characteristic to `q=4,5,9,11`; the first two exclusions
are geometric, and the internal-point conjugacy graph at `q=9` is the Sylvester graph, whose
published exact-distance-two clique number is five. A tracked exact checker independently verifies
the entire q=9 bridge. The census remains as independent verification rather than the explanatory
spine.

## Target

Suppose a six-arc `A` in `PG(2,q)` has uncovered locus equal to all `q+1` rational points of a
nonsingular conic. C174's universal chord identity gives

```text
|U(A)| = q^2 - 14q + 55 - c(A),
c(A) = (q-6)(q-9).
```

Every accidental triple concurrence uses three pairwise endpoint-disjoint chords and hence one of
the 15 perfect matchings of six vertices. A perfect matching contributes at most one concurrence,
so the field-independent elementary bound is `0<=c(A)<=15`. Combining this with the displayed
identity and the prime-power condition reduces the candidates to `q=4,5,9,11`: `q=7,8` give a
negative value, while `q>=12` gives `c>=18`. This avoids Dye entirely, including its
characteristic-two scope. A conceptual proof then only has to exclude `q=4,5,9` geometrically.

## Exit conditions

- the universal `c<=15` matching bound is stated before any odd-characteristic polarity argument;
- characteristic two is handled by that bound plus the direct `q=4` hyperoval exclusion;
- `q=4,5,9` are excluded by stated lemmas, not hidden searches;
- the exact checker remains as independent verification;
- the manuscript replaces its census-first proof only if the new argument covers every prime-power
  case in the existing theorem.

Failure to close any one of these conditions leaves C170's unconditional census theorem in place.
Partial reductions belong in the discovery track or a follow-on, not in the paper's proof spine.

## Free structural exclusions already available

- **`q=4`:** every six-arc is a hyperoval. Its 15 secants contain three off-arc points each, giving
  45 secant/off-arc incidences. An off-arc point lies on at most three secants because the
  corresponding pairs of hyperoval points are disjoint. There are 15 off-arc points, so every one
  lies on exactly three secants and `U(A)` is empty.
- **`q=5`:** every six-arc is an oval and hence a nonsingular conic. Every off-conic point lies on
  either two or three secants of that conic, so again `U(A)` is empty.

## The q=9 Sylvester reduction

At `q=9`, the equation forces `c(A)=0`. Relative to the hypothetical uncovered conic `C`, every
chord of `A` is passant to `C`. An internal point has exactly five passant lines through it, while
an external point has only four. The five chords through each vertex of `A` are distinct passants,
so all six vertices are internal and those five chords exhaust the passant pencil at the vertex.

Let `H` be the graph on the 36 internal points of `C`, with

```text
P ~ Q  iff  Q lies on P^perp.
```

The conic polarity makes this symmetric. The standard internal-point conjugacy graph at order nine
is the 36-vertex Sylvester graph, with intersection array

```text
{5,4,2;1,1,4}.
```

Moreover two internal points have passant join exactly when they are at distance two in `H`: their
unique possible common conjugate is `P^perp intersect Q^perp = (PQ)^perp`, and polarity sends
passant lines to internal points. Consequently the hypothetical `A` would be a six-clique in the
exact-distance-two graph `H^[#2]`.

Abiad, Jabal Ameli and Reijnders define `eq_2(H)=omega(H^[#2])` and give the exact value
`eq_2(Sylvester)=5` in Table 1 of their published open-access paper. Hence no such six-set exists.
The five-point equality examples have an immediate geometric model: the five internal points on a
passant line have pairwise passant joins.

The identification can be recorded without a hidden census. The graph is loopless and 5-regular
because an internal point is nonabsolute and its polar is a passant containing five internal
points. For distinct internal `P,Q`, their only possible common neighbor is
`P^perp intersect Q^perp=(PQ)^perp`; it is internal exactly when `PQ` is passant. If `P~Q`, then
`PQ` is secant: after scaling the two nonsquare quadratic values, orthogonality diagonalizes the
restricted binary form, and `-1` is a square in `F_9`. Hence passant join is exactly graph distance
two. The standard conic counts and one orbit representative give distance layers
`(1,5,20,10)` and intersection array `{5,4,2;1,1,4}`. Brouwer--Cohen--Neumaier identify the unique
distance-regular graph with this array as the Sylvester graph; Jurišić--Vidali give a later
combinatorial uniqueness proof. Abiad--Jabal Ameli--Reijnders then supply `eq_2=5`.

C181 is logically independent of C180: Dye is useful for the q=11 Clebsch rigidity
classification, but unnecessary for isolating the field size.

## Independent exact certificate

Tracked source: `notes/2026-07-15-c181-sylvester-q9.py`.

```text
$ python3 notes/2026-07-15-c181-sylvester-q9.py
field=F3[i]/(i^2+1) projective_points=91 conic_points=10
internal_points=36 H_degree=5 distance_layers=(1,5,20,10)
intersection_array={5,4,2;1,1,4}
passant_joins=360 passant_iff_H_distance_2=PASS
distance_2_clique_number=5 search_calls=1670 witness=[...]
C181_SYLVESTER_Q9_PASS
```

SHA-256: `88a5e989aedc8adcefee21804b60264bc2c980102cca64adf6349eafdac1d9c5`.
The checker is dependency-free, constructs `F_9`, `PG(2,9)`, the conic and polarity from scratch,
verifies the full intersection array at every base vertex and the passant/distance-two equivalence
for all 630 internal pairs, and uses an exhaustive bitset clique search rather than a graph-library
answer.

Source:

- Aida Abiad, Afrouz Jabal Ameli and Luuk Reijnders, “The clique number of the exact distance
  t-power graph: complexity and eigenvalue bounds,” *Discrete Applied Mathematics* 363 (2025),
  55–70, <https://doi.org/10.1016/j.dam.2024.11.032>. The Eindhoven repository carries the
  publisher's CC-BY version of record at
  <https://pure.tue.nl/ws/portalfiles/portal/350328313/1-s2.0-S0166218X24005018-main.pdf>;
  pp. 66–67, Table 1 gives `eq_2(Sylvester)=5`.
- A. E. Brouwer, A. M. Cohen and A. Neumaier, *Distance-Regular Graphs*, Springer, 1989,
  §13.1.2, for the Sylvester intersection array and uniqueness.
- A. Jurišić and J. Vidali, “The Sylvester graph and Moore graphs,” *European Journal of
  Combinatorics* 80 (2019), 184–193, Theorem 6, gives a combinatorial uniqueness proof for the same
  intersection array; <https://doi.org/10.1016/j.ejc.2018.02.018>.
