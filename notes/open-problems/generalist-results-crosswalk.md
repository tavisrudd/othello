# Crosswalk: major named problems versus repository results

**Comparison date:** 2026-07-31  
**External index:** `sources-generalist-named-problems.md`  
**Local index:** `local-results-index.md`

This file contains the filtering judgment.  The two source catalogues remain
raw inventories.  A `candidate` here means that a bounded comparison is worth
doing; it never means that the repository solves, nearly solves or necessarily
advances the famous problem.

## The short answer

No current theorem should be advertised as solving a Millennium problem or a
comparably famous generalist conjecture.  There is one direct partial bridge to
a famous specialist conjecture (`BIG-413`, MDS), two structurally adjacent
finite-geometry/design programmes worth precise checking, and several seductive
but presently non-mathematical vocabulary overlaps that should be fenced off.

## Priority comparisons

| External target | Local result family | Relation | Required next evidence | State |
|---|---|---|---|---|
| `BIG-413` MDS conjecture | PRS covering radii/deep-hole classifications at redundancies 3, 5, 6, 7; arbitrary-redundancy polar containment | Directly inside MDS/arc geometry, but the proved results classify deep holes in selected regimes rather than settle maximum MDS length | State exact parameter ranges and determine whether any result changes a known MDS case rather than using MDS hypotheses | **real partial bridge; audit first** |
| `BIG-412` prime-power conjecture for finite projective planes | conic-relative arcs, continuation reconstruction, odd-plane cap game | Same ambient finite planes; no construction or obstruction for a non-prime-power plane | Translate which arguments use Desarguesian coordinates essentially and test whether any invariant survives for abstract planes | **conceptual candidate only** |
| `BIG-401` Hadamard conjecture | exact order-6/order-10 conference and cut factorizations | Strong finite structure at isolated orders, no scaling mechanism to all multiples of four | Produce an order-growing construction/obstruction before mentioning the conjecture in positioning | **no current progress** |
| `BIG-414` maximum equiangular lines | Golden ETF and simplex/conference factorization | Exact small configuration, not a general dimensional bound | Compare parameters and equivalence notions with current exact-max tables | **small-instance context only** |
| `BIG-705` SIC existence | Golden ETF/doily measurement geometry | Shared frame/measurement language without SIC dimension-family construction | Compute SIC defining equations and overlaps explicitly for any claimed instance | **no present bridge** |
| `BIG-706` MUB dimension six | six-point/outer-`S_6` quantum structures | The number six and quantum vocabulary are not a bridge; no seven-MUB construction or impossibility bound | None until an actual MUB Gram system appears | **negative** |
| `BIG-709` transversal-gate frontier | local-Clifford rigidity for stabilizer AME and MDS--CSS codes | Genuine specialist adjacency, but finite rigid families do not yield asymptotically good non-Clifford transversal codes | State length/rate/distance families and gate hierarchy exactly | **specialist candidate, not big-problem progress** |
| `BIG-004` Hodge / `BIG-204` Tate | Clebsch, Segre, Igusa, Fano and cycle-rich geometry | Classical algebraic varieties occur locally, but no new algebraic-cycle class or realization theorem is proved | Identify a precise cycle and nontrivial cohomology/Galois statement | **no present bridge** |
| `BIG-207` cubic-fourfold rationality | cubic-surface and Segre-cubic constructions | Different dimension and birational problem | None absent a fourfold construction | **negative** |
| `BIG-205` abundance | Sarkisov/Rees/K-stability programme | Birational vocabulary overlap only; no minimal-model abundance statement | Finish the pointed degeneration and compute relevant positivity invariants first | **no present bridge** |
| `BIG-201` Jacobian / `BIG-202` Dixmier | exceptional differential-operator and adjugate identities | Operator/Jacobian words overlap, but the conjectures concern polynomial/Weyl algebra endomorphisms | Exhibit an endomorphism in the exact conjectural category | **negative** |
| `BIG-006` Yang--Mills | anomaly-free two-`U(1)` charge geometry | Both live in mathematical physics, but anomaly cancellation is not Yang--Mills existence or mass gap | None from current results | **negative** |
| `BIG-701` cosmic censorship | none | No repository result concerns Einstein evolution or singularities | None | **out of scope** |

## Bucket screen

| Generalist bucket | IDs | Local verdict |
|---|---|---|
| Prize/foundations | `BIG-001`--`BIG-008` | No direct result.  Hodge/Yang--Mills vocabulary overlaps are specifically fenced above. |
| Number theory/arithmetic | `BIG-101`--`BIG-117` | No direct theorem-level bridge.  Finite-field arithmetic and rational parametrizations do not address prime distribution, transcendence or global Galois conjectures. |
| Algebra/AG/representation | `BIG-201`--`BIG-210` | Several shared objects and words, but no famous-conjecture consequence presently identified. |
| Topology/geometry | `BIG-301`--`BIG-309` | No low-dimensional topology or dynamical-systems theorem in the portfolio. |
| Combinatorics/finite geometry | `BIG-401`--`BIG-417` | The only dense overlap.  MDS is direct; Hadamard/equiangular/projective-plane questions are context or candidates, not claimed progress. |
| Analysis/PDE/dynamics | `BIG-501`--`BIG-507` | No current bridge. |
| Algorithms/complexity | `BIG-601`--`BIG-609` | Exact algorithms and finite classifications do not imply complexity-class separations or uniform polynomial-time bounds. |
| Mathematical physics/QI | `BIG-701`--`BIG-709` | Quantum-code/transversal-gate adjacency is real but specialist; the famous physics conjectures remain untouched. |

## Famous-problem positioning rule

Before connecting a local theorem to a `BIG-*` item in a manuscript, require
all four:

1. identical mathematical objects or an explicit functor/reduction;
2. identical quantifiers and parameter regime;
3. a statement of what known case, bound or obstruction changes;
4. a current authoritative status source read at least through the relevant
   theorem/problem discussion.

Failing any one of these, the famous problem may appear only as broad context,
not as a contribution claim.

## Locally important open programmes absent from the big-name catalogue

- square-root-size complete arcs relative to a conic;
- the cap/Nofil winner on `PG(2,q)` for odd `q`;
- complete PRS deep-hole classification beyond the proved redundancies;
- canonical `36 -> 6` Golden marking quotient;
- pointed Rees/K-stability globalization;
- broader two-`U(1)` anomaly geometry beyond the six-charge Segre case.

Their absence is not evidence of weakness.  It says that the paper's strongest
positioning should rest on a sharp new theorem and a coherent cross-field
mechanism, not on forced proximity to a household-name conjecture.
