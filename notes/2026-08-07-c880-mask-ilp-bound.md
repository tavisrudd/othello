# C880 — the exact mask bound at eight points: 30 ≤ minimum(8) ≤ 44

**Task:** C880 (`clebsch`), work items 2 and 3. Research and computation only; no
manuscript edit.
**Predecessor:** `notes/2026-08-07-c880-alignment-separation.md`, section 4, which
left the eight-point lower bound at the entropy bound 25 because the mask-free
search there was capped and incomplete.

## Result

The minimum hitting set of the eight-point difference masks is exactly **30**,
proved optimal, so

\[
  30 \;\le\; \mathrm{minimum}(8) \;\le\; 44 \;<\; 53 = 3n^2-23n+45 .
\]

The lower end rises from 25 to 30 and is now combinatorial rather than
information-theoretic; the entropy bound of the predecessor report is superseded
at \(n=8\), though it remains the only bound that grows with \(n\). The upper end
is unchanged, so the remaining eight-point gap is 30 to 44.

The predecessor's uncertified observation that a mask-free set of size 40 exists
is confirmed as *maximum*: the largest mask-free set is exactly 40 of the 70
tests, and \(70-40=30\).

## Why the bound is what it is, without a search

The mask bound is not a computation that happens to come out at 30. The
constraint family has a closed form, and so does its hitting number.

Write a **split** for an unordered partition of the eight points into two
four-sets; there are 35. Two splits either **cross evenly**, \(|A\cap B| = 2\),
or **cross unevenly**, \(|A\cap B|\in\{1,3\}\).

1. **The masks are the evenly crossing pairs of splits.** Every weight-four
   difference mask at eight points consists of the four four-sets of two evenly
   crossing splits, and every such pair occurs. The even-crossing graph on the
   35 splits is 18-regular, so there are \(35\cdot18/2 = 315\) masks — the
   measured count.
2. **A hitting set is a set of touched splits.** A family hits the mask of
   \(\{\sigma,\rho\}\) exactly when it contains a four-set of \(\sigma\) or one
   of \(\rho\). So the splits neither of whose halves is chosen must be pairwise
   *unevenly* crossing, and every other split costs at least one test.
3. **At most five splits are pairwise unevenly crossing.** On the even subsets
   of the eight points modulo complement — a six-dimensional \(\mathbf F_2\)
   space — the form \(q(X) = |X|/2 \bmod 2\) is quadratic with polarization
   \(b(A,B) = |A\cap B| \bmod 2\), its 35 singular points are the splits, and
   even crossing is perpendicularity. That is the hyperbolic quadric of
   \(\mathrm{PG}(5,2)\), whose singular points the Klein correspondence
   identifies with the 35 lines of \(\mathrm{PG}(3,2)\), perpendicular going to
   intersecting. A pairwise unevenly crossing family is therefore a set of
   pairwise skew lines; five of them already exhaust the 15 points of
   \(\mathrm{PG}(3,2)\), so there are at most five, and a spread attains five.

Hence at least \(35-5=30\) splits are touched, each costing a test, and 30
suffice: **the minimum hitting set is 30.** A maximum unevenly crossing family
is the five splits through a fixed triple, and the corresponding maximum
mask-free set has \(5\cdot 2 + 30 = 40\) tests, which is the 40 above.

**The 56 optimal seven-point families are the 56 spreads.** The predecessor
report found exactly 56 optimal separating families at seven points, in two
orbits of 21 and 35, and had no reason for either number. There are exactly 56
maximum unevenly crossing families here, and under the stabilizer of the eighth
point — the seven-point symmetry group — they fall into orbits of 21 and 35. So
the optimal seven-point families are the spreads of \(\mathrm{PG}(3,2)\), of
which there are 56; the two orbits are what one \(S_8\)-orbit looks like after a
point is fixed, one of them the five splits through a fixed triple and the other
the five four-sets inside a fixed five-point subset.

**Seven and eight points carry one and the same constraint family.** Adjoining
an eighth point to the complement identifies the 35 four-subsets of a seven-set
with the 35 splits, and under that identification the 315 weight-two masks of
seven points are exactly the 315 evenly crossing pairs above. That is why both
sizes return 30, why 315 appears at both, and why the optimal eight-point
hitting set the solver returns lies entirely inside the four-subsets of a
seven-point subset.

**What this says about closing the eight-point gap.** The difference-mask route
is now exhausted, not merely uncomputed: its bound is 30 at seven points, where
it is tight, and 30 again at eight points, where the true minimum is somewhere in
30 to 44. Since the weight scan is complete through weight four and no lighter
difference exists, any improvement at eight points must use pairs of two-graphs
at alignment distance five or more — constraints that no single test is forced by
— or abandon the hitting-set formulation. The bound also cannot follow the
points: it is a seven-point statement wearing eight-point clothes.

## Method, and what is trusted

The lower bound is the linear-programming-free statement above; the computation
exists to confirm it and to certify the constraint family.

- `c880 masks --n N --weight W` writes every pair-difference mask of weight at
  most \(W\), each with a **witness pair** of graphs whose alignment vectors
  differ exactly on that mask. The witnesses carry their edge lists, so each
  constraint is checkable on its own.
- `2026-08-07-c880-mask-ilp.py` re-expands every witness, recomputes both
  alignment vectors from the definition of the alignment predicate — not from the
  generator's switching-class encoding — requires their difference to be the mask
  that claims it, regenerates the four-subset indexing and requires it to agree,
  and only then solves the minimum-hitting-set integer program to proved
  optimality.
- Completeness of the mask scan is **not** trusted by the bound. Dropping
  constraints can only lower a hitting number, so the value 30 stands whatever
  else the scan missed; completeness through weight four matters only for the
  separate claim that no lighter difference exists, which the predecessor report
  established.

Three independent routes agree at both sizes: HiGHS through
`scipy.optimize.milp`, CBC through PuLP re-solving the same program from a
separate model build, and the structural argument above, whose own finite
inputs — that the masks are the evenly crossing split pairs, that the seven-point
family lifts to the same one, and that the maximum unevenly crossing family has
five members — are verified exhaustively by
`2026-08-07-c880-mask-spread-structure.py`.

The seven-point control returns 30 with a maximum mask-free set of 5, reproducing
the established exact value there by a route the earlier report did not use.

The linear relaxation of the same program is 17.5 at eight points — the uniform
fractional packing \(z_M = 1/18\) — so the integrality gap here is a factor
1.71, and no dual certificate proves 30. The structural argument is what replaces
it.

## Mystery ledger

- **Settled: why 315 appears at both sizes, and why both bounds are 30.** They
  are the same 315 constraints; the eight-point weight-four masks are the
  seven-point weight-two masks lifted along the split correspondence. Before
  this the coincidence of the counts was unremarked.
- **Settled: the 56 optimal seven-point families and their orbit sizes 21 and
  35.** They are the spreads of \(\mathrm{PG}(3,2)\), counted and split by the
  point stabilizer; the predecessor reported the three numbers as measurements
  with no structure attached.
- **Settled: whether the predecessor's 40 was optimal.** It was; the search that
  found it was incomplete, and the exact value is 40.
- **Open: the eight-point gap between 30 and 44.** The mask route cannot close
  it, by the paragraph above. Closing it needs either an exact minimum at eight
  points — \(2^{20}\) complement pairs against \(\binom{70}{k}\) families, which
  is out of reach by the seven-point method — or a lower-bound argument that
  reads several tests at once.
- **Open: whether the split description of the masks persists at nine points and
  beyond.** The description above is a statement about eight points that happens
  to have a seven-point shadow. If the minimum-weight differences at general
  \(n\) have a comparable description, the hitting number of that family is the
  most direct route to a proved lower bound growing faster than the entropy
  bound; if they do not, the entropy bound remains the only general one. A third
  possibility, untested, is that minimum-weight differences are always inherited
  from a seven-point subconfiguration, in which case the hitting-set route is
  capped at 30 for every \(n\) and the polynomial method — an alignment
  indicator is a product of two \(\mathbf F_2\)-linear conditions, hence a
  degree-two function of the two-graph — is the alternative worth trying. The
  nine-point enumeration the question needs — \(2^{28}\) two-graphs, 126
  tests — is beyond the current program's representation, which caps a test
  vector at 128 bits and a class index at 32.
- **Not a mystery.** The integrality gap of 1.71 is ordinary for a covering
  program on a self-complementary constraint family and carries no information
  about the alignment problem.

## Reproduction

From `notes/`, with a scratch directory `$S`:

```sh
rustc -O -o $S/c880 2026-08-07-c880-alignment-separation.rs
$S/c880 masks --n 7 --weight 2 --out 2026-08-07-c880-mask-certificate7.json
$S/c880 masks --n 8 --weight 4 --out 2026-08-07-c880-mask-certificate8.json
uv run --with numpy --with scipy --with pulp python3 2026-08-07-c880-mask-ilp.py \
    --masks 2026-08-07-c880-mask-certificate7.json \
    --out 2026-08-07-c880-mask-ilp7.json --cbc
uv run --with numpy --with scipy --with pulp python3 2026-08-07-c880-mask-ilp.py \
    --masks 2026-08-07-c880-mask-certificate8.json \
    --out 2026-08-07-c880-mask-ilp8.json --cbc
uv run --with numpy python3 2026-08-07-c880-mask-spread-structure.py \
    --masks7 2026-08-07-c880-mask-certificate7.json \
    --masks8 2026-08-07-c880-mask-certificate8.json \
    --out 2026-08-07-c880-mask-structure.json
```

The eight-point mask scan takes about 25 seconds; everything else is immediate.
Both integer programs solve in under a second. All of it is deterministic.

### Artifacts

| file | bytes | sha256 |
|------|-------|--------|
| `2026-08-07-c880-alignment-separation.rs` | 62332 | 946583c8841e54985a5d57d6c632bedc885c6e0d57e0fa734d0b78ad9f38906d |
| `2026-08-07-c880-mask-ilp.py` | 7142 | 9ace010109cba3d15d9cee1968ae4e7805cee807ece161d3cfb5fe14630efd3d |
| `2026-08-07-c880-mask-spread-structure.py` | 7132 | 8845762d6641fde6e4d7356247fcf56f2b9f42562feb14570c36edb7da4fdf40 |
| `2026-08-07-c880-mask-certificate7.json` | 45579 | ff2532a54111c82ae164817c008d87e00f0cb9fea0d261effa4c8c76f6003f2d |
| `2026-08-07-c880-mask-certificate8.json` | 59395 | a53f28799f4d57278f1766acb4b30c143c4998242cb69edee1f1c768068a65d1 |
| `2026-08-07-c880-mask-ilp7.json` | 528 | 4940035b943f69b74eda757868648145dddedbde897eeb7def646be69e61e3f8 |
| `2026-08-07-c880-mask-ilp8.json` | 538 | 35ae4f65604dd056c0360db03d191b4ab8e6a0693cb289c942d9d2aed1177b33 |
| `2026-08-07-c880-mask-structure.json` | 516 | 7d794ae1727084efc916ac5e7ca698f33b4f99337c8506b0cc56a1e76e9d77f9 |

The Rust generator gained the `masks` mode for this report; no earlier mode
changed, so every claim of the predecessor report replays against these bytes,
whose hash supersedes the one recorded there.
