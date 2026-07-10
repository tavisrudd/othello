# C45 report: game-valued defect-spectrum theorem

Date: 2026-07-09.

## Result

C45 is complete as a boundary-setting theorem package.  The finite-geometry spectrum of large
conical subsets is not new here; the new content is the game-valued layer on top of that spectrum.

The safe theorem statement is:

```text
After an on-conic S4 root and one legal intruder x, conic-restricted play is
Node-Kayles on a live induced subgraph of the involution matching sigma_x.

After a legal second intruder y, conic-restricted play is Node-Kayles on a live induced
subgraph of sigma_x union sigma_y.  In every C20 row, this graph is a disjoint union of
paths and even cycles; each surviving cycle has length 2*ord(sigma_x sigma_y) and
Sprague-Grundy value 0.  Therefore the conic-restricted value is exactly the XOR of
Dawson path values over the path defects.
```

The second sentence is a theorem conditional on the usual two-involution dihedral normal form, with
the C20/C31 rows validating that the game-history live subsets satisfy the required path/cycle
conditions in all existing data.  It should not be sold as a new classification of arcs with large
conical subsets.

## 1. Prior-art overlap table

| Source result | Source notation | What our NK note rediscovered | What remains game-specific |
|---|---|---|---|
| Points off a conic correspond to trace-zero involutions of the conic stabilizer `PGL(2,q)`. | Coolsaet-Sticker `sigma_Q`; Tranchida center map `P -> alpha_P`. | Intruder `x` induces a Mobius involution `sigma_x` on conic parameters. | Which involutions arise along legal play after a fixed S4 root, and how the selected/dead conic set changes the game value. |
| The graph `Gamma(C,U)` has conic indices as vertices and joins two indices when their secant contains a supplementary point. Its degree is at most `|U|`, and the selected conical subset is independent. | Coolsaet-Sticker `Gamma(C,U)`, `T`, `U`, excess `e=|U|`. | The C20 defect graph is the same union of involution matchings before restricting to live cells. | Node-Kayles uses the live induced graph after closed-neighborhood deletions, not an arbitrary independent set in the static graph. |
| Excess-two large-conical-subset arcs are classified by cyclic/dihedral normal forms; type I gives equal even cycles, type E gives cycles plus two equal odd-order paths, type M gives cycles plus one even-order path. | Coolsaet-Sticker types I/E/M and orbital indices. | The two-intruder spectrum law: products of two involutions control path/cycle shapes. | Sprague-Grundy cancellation of even cycles, Dawson path XOR, and which spectra can be erased without changing residual value. |
| Pure-internal type I has excess at most 4; excess 4 requires `q == -1 mod 24` and the `S4/A4` construction. | Coolsaet-Sticker `Delta_T`, Theorems 11-12. | A warning against claiming broad new excess bounds. | A game state usually has a small ordered history, not just a large complete arc with a conical subset. The bound is useful only as a geometry constraint. |
| Triples of involutions in `PGL(2,q)` are governed by the geometry of their centers; rank-3 hypertopes correspond to strongly non-self-polar triangles, with special tangent-triangle cases. | Tranchida `alpha_P, alpha_Q, alpha_R`, strongly non-self-polar triangle. | The `k >= 3` skeleton is not unconstrained graph theory; triple centers carry incidence restrictions. | No Dawson path-cycle invariant survives once three matchings are present. The game-specific object is the ordered sequence of legal intruders and live-set deletions. |

Primary references checked:

- K. Coolsaet and H. Sticker, *Arcs with large conical subsets*, Electronic Journal of
  Combinatorics 17 (2010), #R112,
  https://www.combinatorics.org/ojs/index.php/eljc/article/download/v17i1r112/pdf/
- P. Tranchida, *Triples of involutions in PGL(2,q) and their incidence geometries*,
  Innov. Incidence Geom. 22 (2025), 25-46; arXiv:2411.10299,
  https://arxiv.org/abs/2411.10299

## 2. k=2 game theorem

Let `X={x,y}` be two legal intruders above the same conic, and let `L` be the live conic
parameters after the current played set.  Put an edge `s--sigma_z(s)` for each `z in X` whenever
both endpoints are live and distinct.

Classical input:

```text
rho = sigma_x sigma_y
d = ord(rho)
```

On the full conic, the two involutions generate a dihedral action.  Away from fixed/tangent defects,
orbits alternate `sigma_x` and `sigma_y` and give cycles controlled by `d`.  The split/elliptic
distinction changes which fixed-point defects exist:

- split orders (`d | q-1`) may contribute a surviving secant-pair `K2`, hence a path-2 Dawson
  component with Grundy value 1;
- elliptic orders (`d | q+1`) have no conic fixed points for `rho`, so the free-orbit contribution
  is only even cycles unless the live-set cuts it into paths;
- parabolic orders (`d=q` in the prime-field data) are defect-heavy and are not a zero-bulk law by
  themselves.

Game-valued consequence:

```text
G_conic(L, x, y) =
  XOR over path components P_n of DawsonPathGrundy(n)
  XOR over cycle components C_n of CycleGrundy(n).
```

For every even cycle `C_n` with `n >= 4`, Node-Kayles has the single option `P_{n-3}`.  Since
`n-3` is odd and Dawson path Grundy is nonzero on odd lengths, `CycleGrundy(n)=0`.  Thus any
even-cycle component can be dropped from a live spectrum without changing the conic-restricted
nimber.  The value lives in the Dawson path defects and small fixed/tangent cuts.

This is the publishable game layer: the classical spectrum says what components can occur; the
game theorem says which components carry Sprague-Grundy value.

## 3. Dynamic reply closure

The history constraint is stricter than "choose an arbitrary supplementary set `U`."

After one intruder `x`, a conic reply:

```text
matching sigma_x -> induced submatching after deleting the closed neighborhood of the move
```

So the spectrum must be only path-1 and path-2 fragments.  It preserves the one-matching
decomposition and changes only the live subset.

After one intruder `x`, an intruder reply `y`:

```text
matching sigma_x -> sigma_x union sigma_y, restricted to the new live subset
```

So the spectrum must be paths and cycles, product order must satisfy
`d | q-1`, `d | q+1`, or `d=q` in the parabolic prime-field case, and every live free cycle in the
current C20 data must have length `2d`.

For later play, the invariant becomes:

```text
live sets decrease monotonically,
old matching edges may disappear when endpoints die,
each new intruder adds one new involution matching on the remaining live conic cells.
```

That is the dynamic closure condition worth carrying forward.  It is not a fixed Dawson octal game
once `k >= 3`; it is a history-constrained sequence of matching-union graphs.

## 4. k >= 3 partial

For three intruders the conic graph has maximum degree at most 3, so the path/cycle XOR theorem no
longer applies.  Tranchida is the right prior-art boundary: triples of involutions are controlled by
the incidence geometry of the three centers, with strongly non-self-polar triangles, tangent-triangle
cases, and subgroup constraints.

C45 should therefore state only this partial:

```text
The k>=3 game skeleton is a live induced subgraph of a union of k involution matchings.
For k=3, the three centers are subject to Tranchida-style triangle/subgroup restrictions.
However, no completed theorem in this report reduces its Node-Kayles value to Dawson
paths/cycles or to the classical excess-two conical-subset classifications.
```

This is still useful: it prevents overclaiming and gives the correct next target, namely a
history-aware triple-intruder transition theorem rather than another static spectrum table.

## 5. Machine gate

I added a parser-only validator:

```text
rust/scripts/defect_spectrum_check.py
```

Command:

```bash
python3 scripts/defect_spectrum_check.py
```

Output:

```text
ROWS total=220065 files=2
Q q=13 rows=2670 conic=440 intruder=2230 winning_conic=36 winning_intruder=914
Q q=17 rows=53827 conic=5814 intruder=48013 winning_conic=449 winning_intruder=4502
Q q=19 rows=163568 conic=14744 intruder=148824 winning_conic=11074 winning_intruder=108492
CHECK defxor_mismatch failures=0
CHECK one_intruder_matching failures=0
CHECK two_intruder_path_cycle failures=0
CHECK product_order_law failures=0
CHECK even_cycle_zero failures=0
ORDERS q=13 2:202 3:66 4:12 6:56 7:910 12:52 13:82 14:850
ORDERS q=17 2:2891 3:4398 4:1221 6:4191 8:2427 9:13165 16:4622 17:2312 18:12786
ORDERS q=19 2:7974 3:3972 4:11360 5:22966 6:3828 9:11848 10:22842 18:11774 19:6824 20:45436
CYCLES q=17 order=2,len=4:594 order=3,len=6:162
CYCLES q=19 order=2,len=4:3120 order=3,len=6:90 order=4,len=8:20 order=5,len=10:8
FAILURES total=0
```

The check uses only existing tracked data:

```text
notes/data/c20-q13-q17-states.jsonl.gz
notes/data/c20-q19-states.jsonl.gz
```

No solver, certificate generator, Lean build, or memo traversal was run.

## 6. Publishability verdict

Prior-art overlap:

```text
High.  The two-involution/conical-subset spectrum itself belongs to Coolsaet-Sticker, and the
three-involution geometry belongs to Tranchida and related PGL(2,q) subgroup literature.
```

New game-valued content:

```text
Real but narrower: the Node-Kayles interpretation on live conic cells, the zero-Grundy deletion
of even-cycle bulk, the Dawson path-defect XOR, and the ordered-history transition constraints.
```

Remaining risk:

```text
The k=2 game theorem is publishable as a lemma inside the conic-localization paper.  It is not
independently publishable as a finite-geometry spectrum paper.  A standalone C45-style paper would
need the k>=3 dynamic reply theorem or a stronger strategy-level result tying these spectra to full
cap-game P/N outcomes.
```
