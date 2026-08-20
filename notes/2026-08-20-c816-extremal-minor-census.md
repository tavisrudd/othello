# 2026-08-20 — C816: the recognition theorem's equal-modulus half is a nondegeneracy statement, and the constant four is forced

**Task:** C816 (lane `clebsch`), closeout `ej` pass on work item 1.
**Bundle:** this report, `2026-08-20-c816-extremal-minor-census.py`, and
`2026-08-20-c816-extremal-minor-census.json`, committed together.
**Relation to the audit:** `notes/2026-08-20-c816-recognition-theorem-literature-audit.md`
owns the priority verdict. This report owns the reformulation that pass turned up and the sixth
literature domain it forced the audit to cover. Nothing here is applied to the manuscript.

## The finding

Over all \(2^{15}=32768\) hollow symmetric sign matrices of order six, three conditions hold on
exactly the same 384 matrices, with no exceptions in either direction:

1. \(A^2=5I\) — \(A\) is a symmetric conference matrix;
2. every one of the twenty complementary minors \(\det A[S^c,S]\) is nonzero;
3. \(\operatorname{Pf}[D_x,A]=\mu\mathcal T_A(x)\) for some \(\mu\ne0\).

Those 384 matrices are exactly the switching-and-relabelling orbit of the pentagon representative,
computed independently by acting with the group rather than by the three tests, and the
proportionality constants that occur are exactly \(-4\) and \(+4\), the two orientations.

Condition 2 is the interesting one, because it is a bare nondegeneracy hypothesis: no cubic identity,
no proportionality, no sign matching. On the evidence of the census, the equal-modulus half of
`thm:triangle-pfaffian-recognition` can be stated with condition 2 as its hypothesis, which is
visibly weaker than the cubic proportionality the theorem currently assumes.

## Why the constant is four

The manuscript's proof says only that "its complementary-minor calculation gives the factor \(4\)",
which reads as an arithmetic accident. It is not one. **A \(3\times3\) sign matrix has absolute
determinant \(0\) or \(4\), and no other value** — verified over all \(2^9\) of them in the same
bundle. So on the conference locus every complementary minor is a \(3\times3\) sign determinant that
has been forced away from zero, and \(4\) is the only value left. The constant is not a computation
whose output happens to be four; it is the unique nonzero value the ambient arithmetic permits.

This also collapses two readings of condition 2 into one: "every complementary minor is nonzero" and
"every complementary minor attains the maximum absolute determinant of a \(3\times3\) sign matrix"
are the same condition, which is why the census reports zero matrices where they differ.

A second reduction, verified over all \(2^9\) sign matrices but not carried in the certificate
because nothing here rests on it: a \(3\times3\) sign matrix is nonsingular exactly when the product
of the three pairwise inner products of its rows equals \(-1\). That turns condition 2 into a parity
condition on triples of rows, which is the shape a two-graph condition takes, and is the most
promising route to a structural proof of the census's content.

## Status of the claim — proved, later the same day

**Superseded: condition 2 now has a structural proof, and the statement is in the manuscript.** When
this report was first written the equivalence of conditions 1 and 2 rested on the census alone. The
parity reduction below was the route, and it worked. The proposition is now
`prop:nonsingular-complementary-minors` in
`papers/clebsch-passages/sections/05-golden-operator.tex`, proved in the text, with the argument
recorded in `notes/2026-08-20-c816-theorem-d-table.md`.

The proof turns on the identity \(\sum_{m\in S}a_{pm}a_{qm}=(A^2)_{pq}-a_{pr}a_{qr}\) for
\(S^c=\{p,q,r\}\), which holds because the sum defining \((A^2)_{pq}\) runs over \(S\cup\{r\}\).
Nonsingularity of the complementary block keeps the left side away from \(\pm3\) for each of the four
admissible \(r\); writing \(t_r=a_{pr}a_{qr}\) and letting \(k\) count the \(r\) with \(t_r=1\), the
four conditions force \(k=2\) and hence \((A^2)_{pq}=0\).

The census keeps two jobs. It is the independent check on the proposition at order six, and it
certifies the two facts the proof and the manuscript quote: that a \(3\times3\) sign matrix has
absolute determinant \(0\) or \(4\) and nothing else, and that the 384 matrices satisfying the three
conditions are exactly the pentagon's switching-and-relabelling orbit. It still says nothing at any
other order and nothing about weighted matrices.

## Replay

From the repository root, with CPython 3.13.12 and no third-party dependencies:

```sh
python3 notes/2026-08-20-c816-extremal-minor-census.py --check
```

`--check` regenerates the certificate in memory, compares it against the tracked JSON byte for byte,
leaves the worktree unchanged, and exits nonzero on any difference. `--write` regenerates the tracked
file. The run takes about one second.

**Inputs and conventions.** Order six throughout. Matrices are enumerated in one deterministic
order — the lexicographic product over the fifteen upper-triangular entries in
`itertools.combinations(range(6), 2)` order — with no randomness and no seed. All arithmetic is exact
CPython integer arithmetic; there is no floating point anywhere in the generator. The pentagon
representative is pinned in the script as `PENTAGON` and is the only distinguished matrix; it is used
to fix the universal Hodge sign relating a Pfaffian coefficient to its complementary minor, and as
the seed of the orbit computation.

**Hashes and byte counts.**

| File | Bytes | SHA-256 |
|---|---|---|
| `notes/2026-08-20-c816-extremal-minor-census.py` | 9540 | `c29970766acd6c8d6bfd8483e28c4e69765b4179080b75bccd0256344717bc4d` |
| `notes/2026-08-20-c816-extremal-minor-census.json` | 588 | `2ddf8ebfffeb69f97d0ab677c1b8c8f7a157985da1514b1be37d38ed014e983e` |

**What the certificate certifies, and what it does not.** It certifies the three counts and their
exact coincidence, the absence of any matrix on which the three conditions disagree, the absence of
any matrix on which nonsingularity and extremality of the complementary minors differ, the multiset
of proportionality constants, the value set of absolute determinants of \(3\times3\) sign matrices,
and the size of the pentagon's switching-and-relabelling orbit. It certifies nothing about weighted
matrices, nothing at any other order, and no structural mechanism — it is an enumeration, not a
proof. The trusted boundary is CPython's integer arithmetic and `itertools`.

**Independent cross-checks.** Three, all inside the run. The cubic's coefficients are computed twice
by different routes — the matching expansion of the Pfaffian, and the complementary \(3\times3\)
minors with a fixed sign table — and every disagreement is counted; the count is zero. The orbit size
384 is computed by acting with the switching and relabelling group on the pentagon, which never
consults the three tests, and it agrees with all three counts. The nonsingular-versus-extremal
dichotomy is checked per matrix rather than assumed. A separate throwaway floating-point calculation
during the `ej` pass agreed with all of these; it is not tracked and is not evidence.

## Literature: a sixth domain, searched

The reformulation points at a body the audit's five named domains did not cover — maximal
determinants of sign matrices and D-optimal designs — so that domain was searched before this report
was written. zbMATH Open, with the same empty-versus-error calibration used in the audit:

| Query | Total | Outcome |
|---|---|---|
| `ab:maximal determinant & ab:conference matrix` | 7 | No hit relates the two; heads are topology, number theory, and discrepancy |
| `ab:maximal determinant & ab:submatrices & ab:sign matrix` | empty (404) | — |
| `ab:D-optimal design & ab:conference matrix & ab:minors` | empty (404) | — |
| `ab:Hadamard maximal determinant & ab:three by three minors` | empty (404) | — |
| `ab:two-graph & ab:maximal determinant` | empty (404) | — |

No predecessor located for the nondegeneracy or extremality reformulation either. The same access
gaps bind as in the audit: MathSciNet is unauthenticated and Google Scholar blocks automated access,
so no article-body index was searched, and the negative is bounded accordingly. The closest published
relative remains Greaves and Suda, who own the two-valued fourth-order spectrum \(\{-3,5\}\) of a
symmetric Seidel matrix and the determinant-\((-3)\) design — a statement about *principal*
\(4\times4\) minors, where this one is about *complementary* \(3\times3\) minors. Row `OPER-5` records
the boundary.

## Recommendations for the C816 owner

None applied here.

All three were taken the same day; see `notes/2026-08-20-c816-theorem-d-table.md`.

1. **Done.** The factor \(4\) is now explained where it appears: a \(3\times3\) sign matrix has
   absolute determinant \(0\) or \(4\), so once the complementary minors are forced away from zero
   the constant has no freedom.
2. **Done, with the proof.** The nondegeneracy statement is
   `prop:nonsingular-complementary-minors` in the manuscript. The parity reduction was the route.
3. Moot: the proposition supersedes the remark.
