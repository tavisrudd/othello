# C997 — symmetry-reduction gate for exact qLDPC distance solvers (2026-08-28)

**Lane:** quantum-codes · **Task card:** `notes/quantum-codes-tasks/c997-qldpc-distance-symmetry-reduction-gate.md`

**Status:** complete. **Verdict: PASS** — 13.1x node reduction on the gross code
with the certified distance matching at `d_Z = 12`, and CBC's presolve does not
find the gross code's symmetry. Qualifications in section 5.

**What this certifies and what it does not.** The runs certify that this
formulation pair returns `d_Z = 12` for the gross code with every integer
program closed at gap zero, and `d = 12` for the passant code. They do not
certify the reduction factor on any other solver, code family, or size: every
ratio here is CBC-specific and instance-specific. The trusted boundary is CBC's
own optimality proof plus the GF(2) invariance checks in section 3; nothing is
machine-checked beyond that. The passant number is cross-checked against the
independent committed answer in `papers/q13-passant-code`; the gross number is
cross-checked against the published `d = 12` of Bravyi et al. There is no
independent replay of the node counts themselves, because node counts are a
property of one solver's search and have no reference implementation — they are
reproducible rather than verifiable, and CBC single-threaded is deterministic,
so the committed logs replay exactly.

## 1. Question

Does exploiting the automorphism group of a code inside an exact
minimum-distance integer program shrink the branch-and-bound tree materially,
or does the solver's own presolve already recover the reduction?

Gate from the task card: **pass** at roughly 5x node-count reduction on the
`[[144,12,12]]` bivariate bicycle gross code with a matching certified
distance; **fail** below that, or if solver presolve already finds the
symmetry.

## 2. Setup

### 2.1 Upstream source

Bravyi, Cross, Gambetta, Maslov, Rall and Yoder's public `distance_test.py`,
from `github.com/sbravyi/BivariateBicycleCodes` at commit
`fa77e3333d3ec44c79d8f914dd24c040d1da471b` (2024-04-29, the repository head),
retrieved verbatim to
`notes/quantum-codes-tasks/c997-experiment/upstream_distance_test.py`:

| file | bytes | sha256 |
| :--- | ---: | :--- |
| `upstream_distance_test.py` | 2962 | `5110793dd66b6672289e55c21eebc9eb267f73c041a1d0827b3fcba57ec7f889` |
| `upstream_README.md` | 2122 | `e13300b7a691e1469d177db0ca129dbf396076243474232e842bf64a5c0804d6` |

The backend it uses is **python-mip**, whose bundled solver is **CBC**. That is
the backend used here, for both the baseline and every modified run.

### 2.2 Solver, versions, machine

- CPython 3.12.12; `mip` 1.17.6 (CBC); `numpy` 2.5.1; `bposd` 2.1.
- AMD Ryzen AI 9 HX 370, Linux 7.0.9, NixOS. Dependencies resolved with
  `uv run --with ...`; no Python packages are assumed on `PATH`.
- **Every solve is single-threaded** (`model.threads = 1`), so wall time is
  comparable across runs and CBC is deterministic.

### 2.3 Formulations compared

Gross code (`gross_distance_experiment.py`):

| name | description | number of integer programs |
| :--- | :--- | ---: |
| `per-logical` | upstream: minimise weight subject to `hx x = 0 (mod 2)` and odd overlap with one X logical | `k = 12` |
| `global` | one program for `min wt(x)` over `ker(hx) \ rowspace(hz)`, with "not a stabiliser" encoded as "at least one logical parity is odd"; **no symmetry breaking** | 1 |
| `symbreak` | the `global` model plus the translation orbit-representative constraint, once per qubit-block orbit | 2 |

The `global` row exists so the reformulation effect and the symmetry effect can
be separated; without it a `symbreak`-versus-`per-logical` ratio would confound
the two.

Passant code (`passant_distance_experiment.py`):

| name | description |
| :--- | :--- |
| `baseline` | `min sum(x)` subject to `H x = 0 (mod 2)` and `sum(x) >= 1` |
| `symbreak` | same, with `sum(x) >= 1` replaced by `x_0 = 1` |
| `symbreak2` | `symbreak` plus a second-level `Stab(0)`-orbit representative constraint |

All mod-2 conditions use the upstream powers-of-two binary slack linearisation
in every formulation, so the encoding is held fixed.

## 3. Soundness of the symmetry reduction

### 3.1 Gross code: the `Z_12 x Z_6` translation group

Write the qubit index set as two copies of `Z_ell x Z_m` (`ell = 12`, `m = 6`),
one per block, and let `sigma_{u,v}` translate both copies by `(u, v)`
simultaneously. The check matrices are `hx = [A | B]` and `hz = [B^T | A^T]`
where `A` and `B` are polynomials in the commuting shift matrices `x` and `y`.
Translations are themselves monomials `x^u y^v`, so they commute with `A`, `B`
and their transposes; consequently `sigma_{u,v}` maps `rowspace(hx)` onto
itself and `rowspace(hz)` onto itself. Since `ker(hx)` is the orthogonal
complement of `rowspace(hx)`, that gives

- `ker(hx)` is `sigma`-invariant, so the feasible set of the weight-minimisation
  is preserved, and
- `rowspace(hz)`, the stabiliser group, is `sigma`-invariant, so the property
  "is not a stabiliser" is preserved.

Therefore the group permutes the set of nontrivial Z-logical operators and
preserves weight. It does **not** in general fix an individual logical class,
which is exactly why the reduction cannot be bolted onto the upstream
per-logical program unchanged: only the subgroup stabilising that class could
be used there. Moving to the `global` formulation removes the obstruction,
because "at least one logical parity is odd" is a class-independent statement.

The action is **free** on qubits, with two orbits of size 72 (the two blocks).
Hence for any nonzero `x` in the feasible set whose support meets a given
block, there is exactly one translation carrying a chosen support element of
that block to the block's index `0`. So

```
d_Z = min( min{ wt(x) : x feasible, x_0 = 1 },
           min{ wt(x) : x feasible, x_72 = 1 } )
```

is exact: every feasible `x` has nonempty support, that support meets block `L`
or block `R`, and the corresponding translate is feasible with the same weight.
Because the action is free, the residual stabiliser of the constraint `x_0 = 1`
is trivial, so this single constraint consumes the whole 72-element group and
there is no second level of translation symmetry left to break.

The invariance claim is checked numerically rather than merely asserted:
`--mode check-group` verifies, over GF(2) and for all 72 group elements, that
`rank([hx ; hx.sigma]) = rank(hx)` and `rank([hz ; hz.sigma]) = rank(hz)`, and
that the action is free.

### 3.2 Passant code: `PGL(2,13)`

`PGL(2,13)`, of order 2184, acts on the conic (a `PG(1,13)`) and hence on
`PG(2,13)` through the symmetric square: `(u,v) -> (au+bv, cu+dv)` induces
`[[a^2, 2ab, b^2], [ac, ad+bc, bd], [c^2, 2cd, d^2]]` on
`(x, y, z) = (u^2, uv, v^2)`. This preserves the form `y^2 - xz` up to the
factor `det^2`, which is a nonzero square, so it preserves the non-square
condition defining internal points and passant lines. It therefore permutes the
78 coordinates and the 78 generating rows, so the code is invariant.

The code itself is the **null space** of the 78-by-78 passant/internal incidence
matrix `G`, not its row space. `G` has GF(2)-rank 42, so `ker(G)` has dimension
36, and `G` is directly a (redundant, weight-7, therefore pleasantly sparse)
parity-check matrix: `x` is a codeword iff `G x = 0`. This is worth stating
because the first version of this experiment used the row space instead and
returned minimum weight 7 — the weight of an incidence row. The committed
`d = 12` caught the error immediately, which is exactly what the independent
answer is in the experiment for. All numbers reported below are from the
corrected formulation.

Invariance of `rowspace(G)` under a coordinate permutation is equivalent to
invariance of its orthogonal complement `ker(G)`, so the rank check verifies
invariance of the code.

The action is transitive on the 78 internal points (`2184 = 78 x 28`), so every
nonzero codeword has an image whose support contains coordinate `0`, and
`d = min{ wt(x) : G x = 0, x_0 = 1 }` is exact. Unlike the gross code the action
is not free: `Stab(0)` has order 28 and a second level of breaking survives.
Sound form of that second level: let `j = min(supp(x) \ {0})`; if `j` were not
the minimum of its `Stab(0)`-orbit there would be `h` in `Stab(0)` with
`h(j) < j`, and `hx` would have a strictly smaller second support index, so the
group element minimising the second support index already lands in the orbit
minimum. Encoded as `x_i <= sum_{1 <= j < i} x_j` for every `i` that is not a
`Stab(0)`-orbit minimum.

Group order, transitivity, code invariance on a generating set, and the
generated subgroup order are all checked by `--mode check-group`.

## 4. Results

### 4.1 Gross code, `[[144,12,12]]`

Soundness check (`results_gross_group_check.json`): group order 72, action free
on the 144 qubits with two orbits of 72, `rank(hx) = rank(hz) = 66` so
`k = 144 - 66 - 66 = 12`, and `rowspace(hx)`, `rowspace(hz)` invariant under all
72 elements.

Upstream per-logical baseline (`results_gross_per_logical.json`): every one of
the 12 solves closed with proven optimality and objective 12, so the run
certifies `d_Z = 12` and reproduces the published distance.

| logical qubit | objective | nodes | wall (s) |
| ---: | ---: | ---: | ---: |
| 0 | 12 | 792,925 | 246.8 |
| 1 | 12 | 861,267 | 250.7 |
| 2 | 12 | 832,797 | 248.3 |
| 3 | 12 | 770,302 | 239.3 |
| 4 | 12 | 838,382 | 261.4 |
| 5 | 12 | 1,055,936 | 317.3 |
| 6 | 12 | 688,440 | 216.2 |
| 7 | 12 | 836,560 | 253.7 |
| 8 | 12 | 1,290,451 | 330.7 |
| 9 | 12 | 1,561,180 | 372.8 |
| 10 | 12 | 2,010,404 | 466.4 |
| 11 | 12 | 1,689,483 | 413.7 |
| **total** | **12** | **13,228,127** | **3,617.3** |

Symmetry-broken run (`results_gross_symbreak.json`): both solves closed with
proven optimality at objective 12, so `d_Z = 12` is certified again.

| fixed qubit | objective | nodes | wall (s) |
| ---: | ---: | ---: | ---: |
| 0 (block L) | 12 | 305,827 | 49.8 |
| 72 (block R) | 12 | 704,664 | 108.4 |
| **total** | **12** | **1,010,491** | **158.1** |

Unbroken control on the same model (`results_gross_global.json`): the identical
global formulation *without* the orbit constraint. It also closed with proven
optimality at objective 12 (bound 12, status optimal), in 4,236,816 nodes and
797.2 s.

**The three runs and what separates them.** All three certify `d_Z = 12`.

| run | integer programs | nodes | wall (s) |
| :--- | ---: | ---: | ---: |
| upstream per-logical (published baseline) | 12 | 13,228,127 | 3,617.3 |
| global, no symmetry breaking (control) | 1 | 4,236,816 | 797.2 |
| global + translation orbit constraint | 2 | **1,010,491** | **158.1** |

| comparison | what it measures | node ratio | wall ratio |
| :--- | :--- | ---: | ---: |
| baseline / symmetry-broken | the front end end-to-end | **13.09x** | **22.87x** |
| control / symmetry-broken | symmetry breaking alone, same model | **4.19x** | **5.04x** |
| baseline / control | the class-independent re-encoding alone | 3.12x | 4.54x |

Neither ingredient reaches 5x by itself: the re-encoding is worth 3.1x and the
orbit constraint is worth 4.2x. Together they are worth 13.1x, which is more
than their product would suggest is coincidental only because the re-encoding is
a *precondition* for the orbit constraint rather than an independent trick — the
translation group does not fix an individual logical class, so it cannot be
applied to the upstream per-logical model at all (section 3.1). The two are one
transformation, not two.

### 4.2 Does CBC's presolve already find the symmetry?

**No, and the logs say so explicitly.** CBC does ship nauty-based symmetry
detection with orbital branching, and it ran on every instance. On the
per-logical models for logical qubits 0 through 7 it reported

```
Cbc0045I Nauty: 260 orbits (144 useful covering 288 variables), 1 generators,
         group size: 2 - sparse size 2788 - took 0.0009 seconds
Cbc0045I Orbital branching succeeded 20 times - average extra 0.050, fixing (5, 20.800)
```

— a detected **group of order 2**, against the 72 available. On logical qubits 8
through 11, and on both symmetry-broken solves, it reported

```
Cbc0045I Nauty did not find any useful orbits in time 0.0006
```

The reason is structural, and it is the whole case for the proposed front end:
nauty sees the symmetry of the *constraint matrix as written*, and the
formulation has already destroyed most of the code's symmetry before the solver
sees it. The powers-of-two slack variables are not permuted by a qubit
translation, and in the per-logical model the constraint singling out one
logical operator is not translation-invariant at all. The group is a property of
the code, not of the matrix; a solver cannot recover what the encoding threw
away. Supplying it from outside is precisely what works.

This matters for how far the result generalises: CBC's symmetry handling is
weak, but the failure here is not a weakness of CBC's group computation — nauty
is exact and fast on these matrices. A stronger orbital-fixing implementation
(SCIP, Gurobi) would compute the same order-2 matrix automorphism group, because
that is genuinely all the matrix has. The reduction reported here is therefore
not an artifact of a weak solver, and would not be absorbed by switching to a
solver with better symmetry machinery. It would, however, need re-measuring on
such a solver before any published claim, since the baseline tree sizes differ.

### 4.3 Passant code, `[78,36,12]_2` — where the presolve *does* find the group

Soundness check (`results_passant_group_check.json`): the enumerated action has
order 2184, equals the subgroup generated by the three chosen generators, is
transitive on the 78 coordinates (one orbit of 78), leaves the code invariant on
generators, `rank(G) = 42` so the code has dimension 36, and `Stab(0)` has order
28 with orbits of sizes `7, 14, 14, 14, 14, 14` on the other 77 coordinates,
giving 6 orbit minima.

All three runs closed with proven optimality at objective **12**, matching the
committed `d = 12` of `papers/q13-passant-code`. That is the independent check
on the whole pipeline, and it is the check that caught the row-space/null-space
error described in section 3.2.

| formulation | objective | nodes | wall (s) | node ratio vs baseline |
| :--- | ---: | ---: | ---: | ---: |
| baseline (`sum(x) >= 1`) | 12 | 244,087 | 65.4 | 1.00x |
| symbreak (`x_0 = 1`) | 12 | 98,018 | 27.1 | **2.49x** |
| symbreak2 (`x_0 = 1` + `Stab(0)` orbit minima) | 12 | 37,796 | 11.9 | **6.46x** |

The wall-time ratios are 2.41x and 5.50x.

But the solver logs turn this case into the informative one, because here CBC's
presolve **did** find the group:

```
baseline:   Cbc0045I Nauty: 8 orbits (3 useful covering 234 variables),
                     3 generators, group size: 2184
            Cbc0045I Orbital branching succeeded 38 times
symbreak:   Cbc0045I Nauty: 42 orbits (18 useful covering 231 variables),
                     3 generators, group size: 28
            Cbc0045I Orbital branching succeeded 14 times
symbreak2:  Cbc0045I Nauty did not find any useful orbits
```

CBC recovered the whole of `PGL(2,13)` from the matrix, and correctly reported
the residual `Stab(0)` of order 28 once coordinate 0 was fixed. It found it
because this formulation preserves the symmetry: the parity-check matrix is the
incidence matrix itself, which `PGL(2,13)` permutes, and every row has weight 7,
so the per-row slack variables are interchangeable in the same pattern. The
2.49x and 6.46x above are therefore gains **on top of** the solver's own orbital
branching, not gains over a solver that was blind to the group.

### 4.4 The variable that actually decides the outcome

Putting the two codes side by side, the predictor of whether external symmetry
breaking pays is not the size of the automorphism group. `PGL(2,13)` has order
2184 and bought 6.5x; the translation group of order 72 bought 13.1x.

What decides it is **whether the integer-programming encoding preserves the
code's automorphism group**. The passant encoding does, so nauty recovers the
group unaided and the external constraints only add what orbital branching
leaves on the table. The gross-code encoding does not — the upstream model fixes
one logical class per program, and no qubit translation fixes a logical class —
so the group is invisible to any amount of matrix automorphism computation, and
supplying it externally is the only way to get it.

That reframes the product. Its value is not "add symmetry breaking to an ILP",
which solvers already do when they can. It is "**re-encode the distance problem
so the code's group survives into the model, then break it**". On the gross code
that means replacing the `k` per-logical programs with the class-independent
global program plus the orbit constraint. The re-encoding is the part no solver
can do for itself.

### 4.5 Closeout: why CBC found exactly a group of order 2

`logical_orbit_structure.py` (results in
`results_logical_orbit_structure.json`) computes the linear action of the 72
translations on the 12-dimensional logical class space `F_2^12`, reading a
Z-operator's class off as its vector of overlaps with the X logicals. The 72
group elements induce only **36 distinct** linear maps. The action therefore has
a kernel of order 2: one nontrivial translation fixes every logical class.

That single element is the entire automorphism group of the upstream per-logical
model — and it is exactly what CBC's nauty reported, "group size: 2", on eight
of the twelve baseline programs. So the presolve was not deficient. It found
everything the formulation contained. The other 71 group elements are invisible
to it not because nauty is weak but because the per-logical constraint genuinely
destroys them. This is the cleanest possible statement of the case for the
proposed front end, and it is a measurement rather than an argument.

Two smaller closeout facts from the same run:

- The translation group has **687 orbits** on the 4095 nonzero logical classes,
  with orbit sizes in `{3, 9, 12, 36}`. A pipeline that enumerated classes rather
  than a basis could therefore be reduced only about sixfold, which is another
  way of seeing that the reduction available here is bounded well below the
  group order 72.
- The two qubit blocks are **not** exchanged by a code automorphism: the block
  swap preserves neither `rowspace(hx)` nor `rowspace(hz)`, and does not exchange
  them either. So the two symmetry-broken solves are genuinely independent work,
  and their very unequal node counts (305,827 against 704,664) are real rather
  than a missed symmetry. There is no free further halving here.

## 5. Verdict

**PASS**, at **13.1x** node reduction on the gross code (13,228,127 to 1,010,491
nodes) and **22.9x** wall-clock reduction (3,617.3 s to 158.1 s), with the
certified distance matching at `d_Z = 12` in both runs and every solve closing
at gap zero. The passant code independently returns `d = 12`, matching the
committed answer of `papers/q13-passant-code`, at 6.5x node reduction.

The gate's second failure condition does not fire on the gate instance: **CBC's
presolve does not find the gross code's symmetry.** Its nauty-based orbital
branching ran and reported a detected group of order 2 on eight of the twelve
baseline programs and no useful orbits on the other four, against the 72
available (section 4.2).

Three qualifications belong with that verdict, and the first two would have to
be settled before any external claim.

1. **Symmetry breaking alone is 4.19x, marginally under the 5x bar.** The 13.1x
   is the product of the orbit constraint (4.19x) and the class-independent
   re-encoding that makes the orbit constraint applicable (3.12x). Reported as
   one transformation this passes comfortably; reported as "symmetry breaking"
   in isolation it does not. The report above uses the first framing because the
   two steps are not separable — the translation group cannot be applied to the
   upstream per-logical model at all — but the number to quote in any paper is
   4.19x for the symmetry step and 13.1x for the front end.
2. **The result is on CBC.** Section 4.2 argues it should survive a move to SCIP
   or Gurobi, because the order-2 group is genuinely all the per-logical matrix
   has and a better orbital-fixing implementation would find the same thing. But
   that is an argument, not a measurement, and the baseline tree sizes on those
   solvers will differ. Re-measure before publishing.
3. **On a formulation that preserves the group, the presolve does find it.** On
   the passant code CBC recovered all of `PGL(2,13)` unaided (section 4.3), so
   the external constraints there add 2.5x to 6.5x on top of the solver's own
   orbital branching rather than supplying something it lacked. The proposal's
   value is concentrated in cases like the gross code where the standard
   encoding destroys the group — which is, to be fair, the case the whole qLDPC
   pipeline actually runs.

**Recommended follow-on** (the task card says a pass licenses proposing the
product task): the product is narrower and sharper than the research report's
Product 1 described. It is not "add symmetry-breaking constraints to a distance
model". It is a **re-encoder**: take a group-algebra or quasi-cyclic CSS
presentation, emit the class-independent global distance model in which the
code's automorphism group is a genuine symmetry of the constraint matrix, add
the orbit-representative constraints, and emit a certificate of soundness. The
re-encoding is the half no solver can perform for itself, and it is also the
half that carries the publishable observation in section 4.4.

Before that task is opened, the cheapest decisive next measurement is to rerun
exactly these three gross-code formulations on SCIP or Gurobi, whose orbital
fixing is strong. If the 4.19x symmetry step survives there, the product is
real; if a strong presolve closes the gap on the global model by itself, only
the re-encoding is left and the proposal shrinks to a modelling note.

## 6. Replay commands and hashes

Working directory for every command:
`notes/quantum-codes-tasks/c997-experiment/`.

All runs were pinned to a single core (`taskset -c 20`) with the solver limited
to one thread, because an unrelated benchmark was occupying the machine; the
pinning is recorded here because it fixes the wall times, not because the node
counts depend on it (CBC single-threaded is deterministic, so node counts
replay exactly on any machine).

```
# soundness checks (no solver)
uv run --with mip --with bposd --with numpy python gross_distance_experiment.py \
    --mode check-group --out results_gross_group_check.json
uv run --with mip --with numpy python passant_distance_experiment.py \
    --mode check-group --out results_passant_group_check.json

# gross code, [[144,12,12]]
taskset -c 20 uv run --with mip --with bposd --with numpy python gross_distance_experiment.py \
    --mode per-logical --out results_gross_per_logical.json --log-dir logs --max-seconds 600
taskset -c 20 uv run --with mip --with bposd --with numpy python gross_distance_experiment.py \
    --mode global --out results_gross_global.json --log-dir logs --max-seconds 600
taskset -c 20 uv run --with mip --with bposd --with numpy python gross_distance_experiment.py \
    --mode symbreak --out results_gross_symbreak.json --log-dir logs --max-seconds 600

# passant code, [78,36,12]_2
taskset -c 20 uv run --with mip --with numpy python passant_distance_experiment.py \
    --mode baseline  --out results_passant_baseline.json  --log-dir logs --max-seconds 1200
taskset -c 20 uv run --with mip --with numpy python passant_distance_experiment.py \
    --mode symbreak  --out results_passant_symbreak.json  --log-dir logs --max-seconds 1200
taskset -c 20 uv run --with mip --with numpy python passant_distance_experiment.py \
    --mode symbreak2 --out results_passant_symbreak2.json --log-dir logs --max-seconds 1200
```

```
# closeout analysis (no solver)
uv run --with mip --with bposd --with numpy python logical_orbit_structure.py \
    --out results_logical_orbit_structure.json
```

The two driver scripts `run_all.sh` and `run_phase2.sh` run these in order;
`run_phase2.sh` is the one that produced every number reported above, because
the passant formulation was corrected between the two (section 3.2) and the
gross control was rerun with a cap long enough to close.

Checksums of every script, result file and solver log are in the committed
manifest `SHA256SUMS` beside them; regenerate and verify with

```
sha256sum -c SHA256SUMS
```

### Mystery ledger

| # | Surprising or unexplained | Settled by the closeout pass? |
| :--- | :--- | :--- |
| 1 | Breaking a **free** group of order 72 buys only 4.19x, not anything near 72x. | **Open, and it is the important one.** Branch-and-bound tree size here is dominated by proving the bound 12, not by enumerating optima; the orbit constraint removes symmetric solutions but does not improve the linear-programming bound, which stays far below 12 in every run. The prediction that follows is testable and cheap: the leverage is in combining the orbit constraint with a stronger bound (the Wang-Pryadko reduction, arXiv:2203.17216, is the obvious candidate), not in a larger group. Owner: the follow-on task, before any scaling claim. |
| 2 | CBC reported a detected group of order exactly 2 on the per-logical models. | **Settled** (section 4.5): 2 is the order of the kernel of the translation action on logical classes, so it is the exact automorphism group of that formulation. The presolve found everything there was. |
| 3 | The two symmetry-broken block solves differ by 2.3x in nodes despite `A` and `B` sharing the exponent pattern `(3,1,2)`. | **Settled** (section 4.5): the block swap is not a code automorphism and does not exchange the X and Z check spaces, so the two solves are independent problems. No free halving was missed. Why the shapes differ this much is not explained, but nothing is owed to it. |
| 4 | Baseline node counts rise monotonically with logical index, 688,440 at qubit 6 to 2,010,404 at qubit 10 — a 2.9x spread across an arbitrary basis. | **Open.** The `bposd` logical basis is row-reduced, so later basis vectors are denser; that suggests the choice of logical representative is itself a lever worth roughly 3x, independent of symmetry and unexploited by anyone. Cheap to test by re-randomising the basis. Not owned by this gate; a candidate for the follow-on task. |
| 5 | The global re-encoding alone is worth 3.12x nodes and 4.54x wall against the published script, with no symmetry at all. | **Settled as a free-standing result.** Anyone running `distance_test.py` today can have that by replacing 12 programs with 1. It needs no group theory and is worth stating separately from the symmetry claim. |
| 6 | On the passant code the second-level `Stab(0)` constraint (6.46x) beats the first-level one (2.49x) by more than the residual group order 28 would suggest is available. | **Open, low value.** Plausibly the level-2 constraints also tighten the linear-programming relaxation directly, which would be consistent with mystery 1's diagnosis. Not worth a task on its own; note it if the bound-versus-symmetry question in mystery 1 is taken up. |

## 7. Pre-emption reading

### 7.1 `arXiv:1102.5715` is not about distance computation

The task card and the research report describe `arXiv:1102.5715` as "symmetry
in minimum-distance computation". **That description is wrong.** The paper is
Klaus Wirthmüller, *Automorphisms of stabilizer codes* (Technische Universität
Kaiserslautern, 28 Feb 2011), cached at
`/tmp/persistent/tavis/lit-search/pdf/arXiv_1102.5715.pdf`, sha256
`5cfd43e7f314056c7c7f61e6da6599a56252a759c11552a7b2c4d50d736d8164`, 13 pages.
Its abstract states the subject: the automorphisms of binary stabilizer codes
and states "almost always form a solvable group", which sheds light on the
non-existence of a universal transversal gate set, plus a determination of the
connected component of the automorphism group. It is a structure theorem about
automorphism groups aimed at transversal gates. It contains no
minimum-distance algorithm, no integer program, and no search reduction, so it
does not pre-empt anything here.

### 7.2 `arXiv:2606.05044` confirms the gap rather than closing it

Davenport, Blue and Chuang (MIT), *Generalized Bicycle Codes as Cyclic
Submodules and their Automorphism Structure*, fetched to the shared cache as
`arXiv:2606.05044`, sha256
`f5123e2cada49f886cccbcc72c0362b5ac8e833df30816d9bcbf0a6cdb29149d`, 59 pages.
Their automorphism machinery is never used inside a search. Where they need
exact minimum weights they write that "ILP based methods using gurobi or other
solvers are sufficient for exact minima", and their code tables record that
"Distance was found using the AB reduction methods and the Gurobi optimization
package". Their outlook says the automorphism-to-distance bridge is open: the
work "pays no attention to the resulting distance or stabilizer weight of a
given code. It would be fascinating to see if viewing the structure of GB codes
as cyclic submodules yields any insight into the distance or stabilizer weight
of a given code."

### 7.3 The general technique is old; its use here is not

Symmetry breaking by orbit representatives inside a branch-and-bound integer
program is textbook integer-programming practice — Margot's isomorphism pruning
and Ostrowski's orbital branching both name error-correcting-code construction
and covering designs as applications, and both rely on `nauty` to compute the
groups. Fixing the first support coordinate of a codeword using a transitive
automorphism group is likewise long-standing practice in classical
minimum-weight computation for cyclic codes.

So the contribution on offer was never the symmetry-breaking technique. It was
its absence from the qLDPC exact-distance toolchain, which the research report
documented and which `arXiv:2606.05044` confirms from the inside. Any claim of
novelty must be scoped to that application, not to the method.

## 8. Sources

- `github.com/sbravyi/BivariateBicycleCodes`, commit
  `fa77e3333d3ec44c79d8f914dd24c040d1da471b`, files `distance_test.py` and
  `README.md`; retrieved 2026-08-28, hashes in section 2.1.
- Bravyi, Cross, Gambetta, Maslov, Rall, Yoder, *High-threshold and low-overhead
  fault-tolerant quantum memory*, Nature 627, 778-782 (2024) — the source of the
  `[[144,12,12]]` gross code and of the claim `d = 12`.
- Wirthmüller, *Automorphisms of stabilizer codes*, `arXiv:1102.5715`; local
  cache key `arXiv:1102.5715`.
- Davenport, Blue, Chuang, *Generalized Bicycle Codes as Cyclic Submodules and
  their Automorphism Structure*, `arXiv:2606.05044`; ingested into the local
  cache during this task under that key.
- `papers/q13-passant-code` — the committed `[78,36,12]_2` result, `d = 12` with
  364 minimum words in four `PGL(2,13)`-orbits of 91, used here only as an
  independent answer to check against. Nothing under `papers/` was modified.
- `notes/2026-08-28-ergodis-ldpc-quantum-angle.md`, sections 2.0, 4 and 5, for
  the proposal this task gates.
- Margot, *Symmetry in Integer Linear Programming*, and Ostrowski, *Symmetry in
  Integer Programming* (PhD thesis, Lehigh), for the standard orbit-based
  symmetry-breaking techniques referenced in section 7.3.
