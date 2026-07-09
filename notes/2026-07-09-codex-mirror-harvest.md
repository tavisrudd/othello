# C48 — Mirror-theorem harvest on classical varieties

**Claimed + worked by Claude/Opus, 2026-07-09.**
Generator: [`../rust/scripts/projcap_mirror_harvest.py`](../rust/scripts/projcap_mirror_harvest.py)
(deterministic, single-core, tiny memory; run `python3 projcap_mirror_harvest.py`).

## Summary

The generic Lean lemma
`Projective.initialPStatement_of_fixedPointFree_collinearity_preserving_involution`
(an fpf, collinearity-preserving projective involution ⇒ empty cap position is P) is not
tied to full projective space. It was instantiated once by C25 for `PG(2m−1,q)`. This task
harvests its reach on classical varieties whose cap/Nofil game runs on **ambient** projective
lines. Every board below is built **honestly from its defining form** over a small finite
field, so the ≥3-point-line (intersection) pattern and the point counts are *verified*, not
trusted; the cap game is then exhaustively solved and the candidate involution is tested with
the **C27 pair-extension obligation** over every σ-invariant reachable cap (which is itself a
stuck-free / total-winning-strategy proof).

The clean picture that emerges is a **dichotomy driven by the isometry group, not by ambient
parity alone**:

| Variety | Board is | Mirror result | Mechanism |
|---|---|---|---|
| **Hyperbolic quadric `Q⁺(2m−1,q)`, odd q** | nontrivial (generators) | **P — NEW family** | C25 elliptic block mirror `(a,b)↦(d·b,a)` is a factor-`d` similarity of `Σaᵢbᵢ`, fpf, collinearity-preserving |
| Elliptic quadric / ovoid `Q⁻(3,q)` | free placement (≤2/line) | P trivially | bare parity `q²+1` even; **flagged trivial, no novelty** |
| Hermitian curve `H(2,4)` | `= AG(2,3)` | P (known) | affine cap theorem; odd point count, **not** a mirror family |
| **Elliptic quadric `Q⁻(2m−1,q)`** | nontrivial (generators) | negative | anisotropic block blocks a factor-`d`-with-square-`d` similarity; `O⁻(2m,q)` has no fpf involution |
| **Parabolic quadric `Q(2m,q)`** | nontrivial (generators) | negative | even #variables `2m+1` ⇒ every linear involution has a rational fixed point; fixed subspace meets `Q` |
| **Hermitian curve `H(2,q²)`, q≥3** | nontrivial (secants) | negative | even ambient dim 2 (odd #vars 3) ⇒ rational fixed point; unital is a blocking set (no external line) |
| **Hermitian surface `H(3,q²)`** | nontrivial (generators) | negative | odd ambient dim, but unitary involutions all have isotropic eigenspaces (Hermitian forms isotropic in dim ≥ 2) |

The headline deliverable is the **new infinite family `Q⁺(2m−1,q) = P` for every odd `q` and
every `m ≥ 2`**, provable at genuine lemma-application cost because the involution is exactly
the C25 elliptic block map (already Lean-proven fpf + collinearity-preserving), only the
sub-board and its preservation are new. The negatives are boundary data for D1: **odd ambient
dimension is necessary but not sufficient** — the isometry group must additionally contain an
fpf involution, which the unitary group never does for Hermitian varieties, and `O⁻`/`O` never
does for elliptic/parabolic quadrics.

## General proposition (the theorem behind the harvest)

The harvest is one proposition plus a classification, and both are now realized:

> **Proposition (Lean-proven, `initialSubCapP_of_fpf_collinearity_preserving`).** Let `X` be a
> finite set of points of a projective space, playing the cap/Nofil game under *ambient*
> collinearity. If `X` admits a fixed-point-free involution that preserves the board and the
> ambient collinearity relation, then the empty position of the game on `X` is a P-position
> (second-player win).

The proof is the C27 mirror step verbatim: the mirror-chord obstruction is killed by ambient
collinearity + σ-invariance alone, so it never uses that the board is the whole space. What
remains — and what this task supplies — is the **classification of which standard classical
varieties satisfy the hypothesis** (the dichotomy table above). Draft framing for a write-up:

> *We show that the fixed-point-free mirror method applies beyond affine space, giving a
> uniform P-position theorem for hyperbolic quadrics `Q⁺(2m−1,q)` over odd fields. We also
> identify several classical varieties (elliptic and parabolic quadrics, Hermitian curves and
> surfaces) where this particular method cannot apply, separating mirror obstructions from
> actual game outcomes* — `H(2,9)` and `H(3,4)` are computed P despite carrying no fpf
> involution, so a mirror obstruction is not an outcome.

Positioning stays conservative per the handoff's novelty guard: the mechanism (fpf projective
involution + whole-board mirror) is the standard ingredient; the contribution is the
*subfamily* outcome theorem and the sharp method-boundary map, not a new class of games.

## Board classification (step 0)

A variety's cap game is nontrivial (not free placement) iff some ambient line carries ≥3
variety points. Machine-verified line spectra (from the honest form construction):

- `Q⁺(3,q)`: `(q+1)²` points, exactly `2(q+1)` generators each of `q+1` points and nothing
  else. So the ≥3-lines are exactly the two rulings = **rows and columns of a `(q+1)×(q+1)`
  grid**; the cap game is the **capacity-2 rook-lines game** (directly in the E1
  line-capacity vocabulary). Verified `q=3`: 16 pts, 8 four-point lines.
- `Q⁻(3,q)` ovoid: `q²+1` points, **0** long lines ⇒ free placement. Verified `q=3`: 10 pts,
  0 long lines.
- `H(2,q²)` unital: `q³+1` points; secants carry `q+1` points, every line of `PG(2,q²)` meets
  it (blocking set). Verified `q=2`: 9 pts / 12 three-point secants (`= AG(2,3)`), 0 missing
  lines. `q=3`: 28 pts / 63 four-point secants, 0 missing lines.
- `Q(4,q)` parabolic (`GQ(q,q)`): `q³+q²+q+1` points, generators of `q+1` points. Verified
  `q=3`: 40 pts, 40 four-point generators.
- `H(3,q²)` surface: `(q³+1)(q²+1)` points, generators. Verified `q=2`: 45 pts.
- `Q⁻(5,q)`: `(q³+1)(q+1)` points. Verified `q=3`: 112 pts.

All point counts match the standard references (`Q⁺(2m−1,q)=(q^{m−1}+1)(q^m−1)/(q−1)`,
`Q⁻(2m−1,q)=(q^m+1)(q^{m−1}−1)/(q−1)`, `|H(k,q²)|`), so the construction is trustworthy.

## The positive family: `Q⁺(2m−1,q)`, odd q (steps 1–3)

**Candidate involution (verified, not trusted).** Take the C25 elliptic block map on
`V=(K²)^m`: on each hyperbolic pair `(aᵢ,bᵢ) ↦ (d·bᵢ, aᵢ)` with `d` a fixed nonsquare. Its
square is `d·I` (projectively the identity), so it is a projective involution; it is fpf on all
of `PG(2m−1,q)` because `λ²=d` has no solution in `K` (C25). The new observation is that it
**preserves the hyperbolic quadric**: with `Q(v)=Σᵢ aᵢbᵢ`,
`Q(σv)=Σᵢ (d·bᵢ)(aᵢ)=d·Q(v)`, a similarity of factor `d`, so `{Q=0}` is invariant.

**C27 pair-extension.** For a σ-invariant cap `S` and a legal move `x`, `S ∪ {x, σx}` is a
valid cap: this is exactly `mirrorStepGood_of_collinearity_preserving` in
`lean/ProjectiveCap/Mirror.lean`, whose proof is **local** (references only `S ∪ {x, σx}` and
ambient collinearity + σ-invariance) and therefore transports verbatim to a sub-board. The
mirror-chord case is killed because if an old `z ∈ S` lies on the ambient line `x·σx`, then
`σz` lies on it too (collinearity-preservation) and the old pair `z, σz` already blocks `x`.

**Machine gates** (verbatim; `n×n` grid model and the elliptic model both checked):

```
### Q+(3,3) hyperbolic  sum a_i b_i=0: 16 points (even)  d(nonsquare)=2
    elliptic mirror (a,b)->(d b,a): {'is_perm': True, 'involutive': True, 'fpf': True, 'collinearity_preserving': True}
    C27 pair-extension over ALL 77 sigma-invariant caps: PASS => total mirror strategy => P  (0.0s)
    exhaustive cross-check outcome: P  (0.00s)
### Q+(3,5) hyperbolic  sum a_i b_i=0: 36 points (even)  d(nonsquare)=2
    C27 pair-extension over ALL 3670 sigma-invariant caps: PASS => total mirror strategy => P
    exhaustive cross-check outcome: P  (1.70s)
### Q+(5,3) hyperbolic  sum a_i b_i=0: 130 points (even)  d(nonsquare)=2
    elliptic mirror (a,b)->(d b,a): {... 'fpf': True, 'collinearity_preserving': True}
    C27 pair-extension SAMPLED 6401 moves: PASS  [proof = collinearity-preservation above + generic lemma]
### Q+(3,3) as 4x4 capacity-2 rook grid (E1 line-capacity model): 16 points (even)
    translation mirror (i,j)->(i+2,j+2): {... 'fpf': True, 'collinearity_preserving': True}
    C27 pair-extension over ALL 95 invariant caps: PASS => P
```

Also confirmed with `--full` at `Q⁺(3,7)` (64 pts): C27 pair-extension over ALL 312373
σ-invariant caps PASS. The exhaustive-solve outcome (`P`) and the pair-extension proof agree at
every reachable q. The grid model gives a second, independent fpf mirror (translation by
`((q+1)/2,(q+1)/2)`), so the family has two proofs.

**Uniform proof (all odd q, all m ≥ 2).** fpf + involution + collinearity-preservation +
quadric-preservation are all q- and m-uniform (the similarity computation and the "no `λ²=d`"
argument have no size dependence), and the C27 lemma is uniform, so the machine gates confirm a
proof that holds for the whole family — no per-q certificate needed.

## Trivial and known rows

- `Q⁻(2m−1,q)` **ovoids are free placement** (`≤2` points per line), so the outcome is bare
  point-count parity: `q²+1` even for odd q ⇒ P. Flagged trivial, **no novelty claimed**
  (this is the row the task warned about).
- `H(2,4)` **is `AG(2,3)`** (9 points, 12 three-point secants), already P by the affine cap
  theorem (`CapGame/Affine.lean`). Odd point count ⇒ not an fpf-mirror family; recorded as a
  coincidence, not a harvest.

## Negatives / boundary data (step 5)

Machine witnesses (verbatim), each a *principled* failure that maps the mirror method's edge:

```
### H(2,9) fixed-point obstruction (even ambient dim 2):
    diag(1,1,-1) unitary involution: preserves=True, fixed pts on curve=4 (fpf needs 0)
    Baer x->x^q: preserves=True, fixed pts on curve=4 (the Baer subconic)
  Q-(5,3) elliptic quadric (112 pts): elliptic block mirror does NOT preserve (anisotropic block factor mismatch); O-(6,q) has no fpf involution.
  Q(4,3) parabolic (40 pts, even ambient dim): diag(1,1,1,-1,-1) involution has 6 fixed pts on Q.
  H(3,4) Hermitian surface (45 pts, odd dim 3): swap-block unitary involution has 5 fixed pts (Hermitian forms isotropic in dim>=2).
```

Arguments behind the witnesses:

- **Even ambient dimension (`H(2,q²)`, `Q(2m,q)`).** A linear involution `[A]` of `PG(d,q')`
  with `d` even has `A` of odd size `d+1`; `A²=cI` with `c` a nonsquare would make the odd-dim
  space an `F_{q'²}`-module (even `F_{q'}`-dimension) — impossible — so `c` is a square, `A` has
  a rational eigenvector, and there is a fixed projective point. The fixed **line/subspace**
  then meets the variety: unitals are blocking sets (every line meets them, verified: 0 missing
  lines at `q=2,3`), and a `≥3`-dimensional eigenspace of `O(2m+1)` is isotropic and meets `Q`.
- **Elliptic quadrics `Q⁻(2m−1,q)` (odd dim, but negative).** The elliptic block similarity
  needs factor `d` *with* `d` a square in the acting field on every block; the anisotropic
  block (norm form on `F_{q²}`) would need `ω²=d` and `N(ω)=d` simultaneously, forcing
  `ω∈F_q` and `d=ω²` a square — contradiction. Equivalently, every `O⁻(2m,q)` involution has a
  `≥3`-dimensional isotropic eigenspace (anisotropic quadrics over `F_q` cap at dim 2), which
  meets `Q⁻`. Machine: the block map's image leaves the board.
- **Hermitian surface `H(3,q²)` (odd dim, but negative).** Every unitary involution splits the
  space into ±1 eigenspaces that are non-degenerate Hermitian subspaces; a Hermitian space of
  dim `≥2` is isotropic, so at least one eigenspace (dims sum to 4, so one is `≥2`) meets the
  surface. This is a **different obstruction than parity**: odd ambient dimension does not save
  Hermitian varieties.

Note `H(2,9)` and `H(3,4)` are computed **P** anyway (28 pts solves to P; the value comes from
some non-mirror mechanism), so these are *method* boundaries, not outcome flips. `Q(4,3)` and
the higher parabolics are the first genuinely open outcome question in this batch (not solved
here; solving `Q(4,3)`'s 40-point game exactly is feasible and a good follow-up).

## Lean (landed, step 4)

New file [`../lean/ProjectiveCap/HyperbolicQuadricMirror.lean`](../lean/ProjectiveCap/HyperbolicQuadricMirror.lean)
(imported from `ProjectiveCap.lean`; builds clean; disjoint from Codex's C41/C50 files). Rather
than a subtype board it keeps the full-space `Point K V` and takes `SubCap Q S := Cap K V S ∧
∀ p ∈ S, Q p`, which lets the cap part reuse `mirrorStepGood_of_collinearity_preserving`
**verbatim** — the only new obligation is `Q x → Q (σ x)`. Theorem names:

- `SubCap` — the sub-board cap game (valid = ambient cap + all points on `Q`).
- `initialSubCapP_of_fpf_collinearity_preserving` — the **general proposition** above:
  fpf + collinearity-preserving involution + `Q`-preservation ⇒ `IsP (SubCap Q) ∅`.
- `initialSubCapP_of_linearEquiv_sq_scalar_nonsquare` — linear-model form (`g∘g = δ•`, `δ`
  nonsquare, `Q`-preservation), reusing the C25 fpf/collinearity derivations.
- `blockForm`, `blockForm_smul` (degree-2 homogeneity), `blockForm_ellipticBlock` (the
  factor-`δ` similarity `blockForm (g v) = δ · blockForm v`), `OnBlockQuadric`,
  `onBlockQuadric_map` (the block map preserves the quadric — the one new lemma).
- `initialSubCapP_blockQuadric_of_nonsquare` / `initialSubCapP_blockQuadric_of_odd_card` —
  **`Q⁺(2m−1,q) = P` for odd `q`** (`ι = Fin m`), the harvested family.

Axiom profile of both `initialSubCapP_blockQuadric_of_odd_card` and
`initialSubCapP_of_fpf_collinearity_preserving`: `[propext, Classical.choice, Quot.sound]`
(no `sorry`, no `native_decide`) — verified via `#print axioms`.

Follow-up Lean options (not needed for the theorem): a bespoke `Fin m → K × K` `Fintype`
instance to drop the `[Fintype (Point ...)]` hypothesis; and stating the negatives' obstruction
(no fpf involution) as a Lean lemma is possible but low-value.

## Follow-ups

- **Boundary theorem + extension scopes:** [`2026-07-09-mirror-method-boundary.md`](2026-07-09-mirror-method-boundary.md)
  — the "mirror-provable ⟺ hyperbolic (split) quadratic form" boundary (#5, parabolic + Hermitian
  rigorously excluded, elliptic strongly evidenced), plus scopes for polar-space Nofil (#3) and
  Segre/product varieties (#4).
- **Mirror unification (landed):** [`2026-07-09-mirror-unification.md`](2026-07-09-mirror-unification.md)
  — one engine, several instances (sum-free negation / projective elliptic / hyperbolic-quadric /
  conflict-graph Cayley). Lean: `CapGame/GraphMirror.lean`, `ProjectiveCap/CapCMirror.lean`.
  **Correction:** the capacity-`c` "free lift" is **false for `c ≥ 3`** — the mirror is NOT
  capacity-blind. The chord discharge secretly uses `c = 2` (a σ-pair fills a line to exactly
  capacity 2); at `c ≥ 3` the opponent plays a third point on a σ-invariant line and the forced
  reply `σx` completes 4 collinear → illegal, so the pairing is genuinely stuck. The general
  capacity-`c` mirror theorem is proven with the chord kept explicit; the lift holds only at `c = 2`.

## Reproduce

```
cd rust && python3 scripts/projcap_mirror_harvest.py          # ~5s
cd rust && python3 scripts/projcap_mirror_harvest.py --full   # + Q+(3,7) full BFS, ~35s
```
