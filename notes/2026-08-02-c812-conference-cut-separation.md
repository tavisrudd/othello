# C812 — Higher cut moments separate the first conference classes

**Lane:** `clebsch`  
**Date:** 2026-08-02  
**Verdict:** complete; the scalar third centred aligned-block cut moment
separates all four conference switching classes at the first multi-class
order

## Result

Symmetric conference matrices are unique up to equivalence at orders
\(6,10,14,18\); order \(22\) is impossible; and order \(26\) has exactly
four conference switching classes. For each order-26 class let
\(\mathcal B\) be its aligned \(3\text{-}(26,4,5)\) design and, for a uniform
thirteen-set \(T\), put
\[
 c_T=\#\{B\in\mathcal B:B\subseteq T\}.
\]
Then the third centred moments of \(c_T\) on the four classes are
\[
\boxed{
 \frac{5824547586}{687739675},\quad
 \frac{504439650}{27509587},\quad
 -\frac{489762702}{137547935},\quad
 -\frac{699456186}{137547935}.}
\]
They are pairwise distinct. Thus the cheapest design-unforced scalar already
distinguishes every switching class at the first order where separation is
possible. The triple-union profile certifies the calculation, but no full cut
histogram is needed.

The public catalogue contains all fifteen strongly regular descendants with
parameters \((25,12,5,6)\). Numbering its graph6 records from one, the exact
clusters are:

| descendant indices | count | third centred moment |
|---|---:|---:|
| \(1,3,6,11\) | 4 | \(5824547586/687739675\) |
| \(2\) | 1 | \(504439650/27509587\) |
| \(4,5,7,9,10,12,13,15\) | 8 | \(-489762702/137547935\) |
| \(8,14\) | 2 | \(-699456186/137547935\) |

The statistic is switching invariant, so every descendant of one conference
two-graph has one value. The classification has four classes and the catalogue
contains descendants from all of them. Four distinct values across the fifteen
records therefore prove completeness on order \(26\), not merely separation
of one selected pair.

## Why the third moment is the first available separator

For any \(3\text{-}(26,4,5)\) design, the block count, mean, variance, and
pair-union profile are fixed by the design parameters. For a pair of blocks
with union \(U\), let \(N_j(U)\) count blocks meeting \(U\) in \(j\) points.
Writing \(c_U=N_4(U)\), the design equations give
\[
 \sum_{j=0}^4\binom jtN_j(U)=\lambda_t\binom{|U|}{t},
 \qquad 0\le t\le3,
\]
with
\[
 (\lambda_0,\lambda_1,\lambda_2,\lambda_3)=(3250,500,60,5).
\]
Hence \(N_0,\ldots,N_3\) are determined by \(|U|\) and \(c_U\). Summing these
values over all block pairs gives the complete unordered triple-union profile.
The distribution of \(c_U\) is not fixed by the \(3\)-design equations; its
four realized projections above show this directly. This is the structural
reason the first two moments agree while the third can separate.

For completeness, the four triple-union profiles differ already in several
coordinates. Their union-size-five counts are respectively
\[
 7640,\qquad 7800,\qquad 9160,\qquad 9360,
\]
in the class order induced by representatives \(1,2,4,8\). The scalar moment
retains enough of this difference to separate all four, so the task's
increasing-cost hierarchy stops there.

The C810 distance addendum suggested attaching Hamming distances to these
representatives. Exact quotient distance would require maximizing block
agreement over independent vertex relabellings, a different canonical
alignment problem. A fixed graph6-labelling distance is not an invariant and
is therefore not reported. C812 settles the promised separator before that
more expensive branch; the conference-only adversarial distance remains a
separate question.

## Exact computation

The generator embeds the fifteen graph6 records from Brendan McKay's
combinatorial-data catalogue, whose fetched bytes have SHA-256
`f55f86eb48cd61c3315c62341cc3a8c59289c58504edb3ab859d7ef2068b9aa4`.
For every record it:

1. decodes the graph and checks all \((25,12,5,6)\) strongly regular
   equations;
2. adjoins the isolated conference root and constructs aligned four-sets by
   equality of all four triangle parities;
3. checks all 3,250 blocks and degree five on each of the 2,600 triples;
4. computes pair unions and the exact \(N_j(U)\) recurrence above; and
5. checks that the resulting triple profile has mass \(\binom{3250}{3}\).

The independent Python replay reads only the canonical profile certificate,
recomputes factorial and centred moments with `Fraction`, checks the
universal pair profile, recovers the four clusters, and verifies all four
displayed rational values. It does not independently decode graph6 or
regenerate the union profiles. Those stages are protected instead by the
defining SRG, design-degree, recurrence-integrality, and total-mass checks;
a fully independent direct cut-histogram replay would cross the task's
explicit stop-at-first-separation boundary.

Replay from the repository root:

```sh
g++ -O3 -std=c++20 -Wall -Wextra -pedantic \
  notes/2026-08-02-c812-conference-cut-separation.cpp \
  -o /tmp/c812-conference-cut-separation
/tmp/c812-conference-cut-separation \
  --output /tmp/c812-conference-cut-separation.json
cmp /tmp/c812-conference-cut-separation.json \
  notes/2026-08-02-c812-conference-cut-separation.json
python3 notes/2026-08-02-c812-conference-cut-separation-replay.py
sha256sum -c notes/2026-08-02-c812-conference-cut-separation.sha256
```

The evidence sizes and SHA-256 hashes are:

| artifact | bytes | SHA-256 |
|---|---:|---|
| C++ generator | 8,667 | `7c7258e6cc242b1bdab874a3bab30d4c628d26b31e5ce80871938aeb9bd4bac6` |
| Python replay | 2,152 | `f5eb1db82d62c335add4ce8aa42eaf83d8d423d86ff48bf9243ca0d7c1e136b8` |
| JSON certificate | 4,628 | `7641228492325d24f0d8190a8053357ef1a9507e8e1741a15c306d10099316aa` |

## Bounded source and literature check

Zero sources were read at full-text depth. This is a bounded classification
and terminology check, and no novelty or priority claim is made.

- **Bussemaker--Mathon--Seidel, _Tables of two-graphs_**, DOI
  `10.1007/BFb0092256\). **Read depth: partial**, cached published PDF,
  Chapter 5 and Table 7; cache SHA-256
  `ac9d300a4a0e5f46d4d4b36b66d5f620f616ffad3197ae93fad50b8ff224748a`.
  It supplies uniqueness at order ten, exactly four order-26 conference
  two-graphs, and their \(1+4+2+8\) regular descendants.
- **Haemers--Parsaei Majd, _Spectral symmetry in conference matrices_**, DOI
  `10.1007/s10623-021-00858-8\). **Read depth: partial**, published web
  version, Section 2. It states that orders \(6,10,14,18\) are Paley-unique,
  order \(22\) is impossible, and order \(26\) has exactly four equivalence
  classes.
- **McKay, Combinatorial Data: strongly regular graphs.** **Read depth:
  partial**, catalogue page's strongly regular graph section and the complete
  fifteen-record `sr251256.g6` data file. It supplies the exact descendant
  representatives used here.

The bounded web queries were `\"conference matrix\" \"third moment\" balanced
cuts aligned design`, `\"conference matrix\" cut distribution principal four
subsets determinant -3`, `\"conference two-graph\" invariants order 26
aligned blocks`, and `\"Seidel switching\" submatrix spectra cut histogram
conference`. They located general Seidel-spectrum, switching, and minor
literature but no aligned-block third-cut-moment calculation. MathSciNet,
zbMATH, Google Scholar, and forward-citation graphs were not covered. This
licenses no absence statement; it only records that the bounded check found no
reason to change the mathematical attribution.

## EJ + Tao closeout and mystery ledger

The cheap extra pass converts a nominal pair-separation into a complete
first-order classification fingerprint: one scalar distinguishes all four
classes, including signs on both sides of zero. The recurrence also avoids the
\(\binom{3250}{3}\) raw triple census by reducing every pair union to one
contained-block count.

- **Settled — first multi-class order.** Orders through eighteen are unique,
  order twenty-two is impossible, and order twenty-six has exactly four
  classes.
- **Settled — scalar versus full profile.** The scalar third centred moment is
  already injective on the four classes; the full triple profile is supporting
  evidence, and the cut histogram is unnecessary.
- **Settled — why design strength three does not force the answer.** The
  \(3\)-design equations leave the contained-block value \(c_U\) free on
  pair unions; the four classes realize distinct distributions.
- **Open — conference certificate distance.** The four representatives now
  exist canonically, but quotient Hamming distance is a maximum-agreement
  problem over relabellings. Fixed database labels do not answer it. A
  successor would need an exact canonical-alignment or branch-and-bound
  certificate.
- **Open — uniform formula.** The four rational moments do not yet have a
  group- or character-theoretic formula in terms of the Latin-square and
  Steiner constructions. The present theorem is exact at order twenty-six,
  not an all-order classification.

## Scope

This is a mathematics-only result. No manuscript source or public package is
changed. The first design-unforced moment is a complete invariant on the exact
first multi-class conference order; no general completeness or novelty claim
is made.
