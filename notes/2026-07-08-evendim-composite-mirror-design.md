# Even-dimensional composite mirror — design analysis (Fable, 2026-07-08)

**Status update (2026-07-10):** this is the pre-probe design record, not current outcome status.
C32 later refuted the primary fixed-`rho` policy on `PG(4,3)`, while the independent C43 exact
orbit-canon solve established **`PG(4,3) = P`**.  The policy failed; the board did not.

Deepening of queue task C32 before Codex builds the probe. Corrects an error in the C32 v1
spec, derives the forced shape of any composite mirror for `PG(2m,q)` (odd q), identifies the
exact obstruction structure and a candidate exception scheme, and shows the scheme transfers
to the PLANE in a form the 2026-07-05 central-symmetry analysis did **not** try. Companion
kernels: `2026-07-08-projective-mirror-proof-kernels.md` (C27 pair-extension lemma is the
soundness tool throughout).

Setup: `PG(2m,q)`, q odd, `m ≥ 1` (m=1 is the plane). Fix a hyperplane `H ≅ PG(2m−1,q)`
(P2's choice, adaptive); complement `A ≅ AG(2m,q)`. Counts: `|A| = q^{2m}` **odd**, `|H|`
even. `ρ` = an elliptic involution of `H` (exists: vector dim `2m` even — C25).

## 1. The affine component's shape is forced (C32 v1 had an error)

The v1 task text proposed "translation `τ_v` on the affine part". **Wrong for odd q:
translations have order p ≠ 2** — they are involutions only in char 2 (where the even-q
theorem already lives). Classify instead: an affine involution `t(z) = Mz + b` needs
`M² = I` and `Mb + b = 0`, so (q odd) `M` splits into `±1` eigenspaces `U₊ ⊕ U₋` and
`b ∈ U₋`. Then `(I−M)z = b` is always solvable: the fixed set is an affine subspace of
dimension `dim U₊`, size `q^{dim U₊} ≥ 1`. So:

- **No fpf affine involution of `A` exists at all** (consistent with `|A|` odd). Every
  composite must specially handle at least one affine point.
- The minimal fixed locus is the **point reflection** `M = −I`: one center `c`, pairing
  `A \ {c}`. The center is protected by the affine theorem's **midpoint trick**: seed it as
  the midpoint of the first affine move-pair `{x₀, y₀}` (P2 chooses `y₀`, hence `c`), so `c`
  lies between two selected points and is dead forever.
- Chord structure: the pair chord `x, σ_c x` is the line through `c` in direction
  `[x − c]`, which meets `H` in exactly that direction point. As `x` ranges over `A`, the
  chord directions cover **all of `H`**.
- Alternative shape: `M` with `U₊ ≠ 0` confines chord directions to `P(U₋) ⊊ H` (a smaller
  poison target) at the price of a `q^{dim U₊}`-point fixed subspace needing its own
  (recursive) pairing — **reflection towers**. Per level the chord-direction set shrinks and
  the level's direction point self-blocks after the level's first pair; the poison moves to
  the lower level's foot points. Worth enumerating in the probe; not obviously better.

## 2. The poison structure, and the ρ-paired double-pencil burn

Soundness is C27's pair-extension condition. For an affine move `x`, the reply `σ_c x` is
illegal exactly when a **selected** point sits on the chord. Selected *affine* points on the
chord come in `σ_c`-pairs (the chord is `σ_c`-invariant), which would have made `x` illegal
already — the affine theorem's argument. The one genuinely new channel is the chord's single
`H`-point: **a selected `h ∈ H` poisons the whole pencil line through `c` with direction
`h`** (`{x, σ_c x, h}` collinear). ρ-invariance cannot rescue this: a projective line meets
`H` once, so `ρh` is never on the same chord.

But P2's own discipline makes the poison symmetric: P2 answers every `H`-move by `ρ`, so
`S ∩ H` is always ρ-invariant — **poisoned pencils come in ρ-pairs** `{h, ρh}`. Candidate
exception rule (**double-pencil burn**): the first time P1 legally enters the `h`-pencil
(playing `x` on the line `c–h`), P2 replies with a legal cell `x'` on the `ρh`-pencil line.
After that, *both* pencil lines carry two selected points (`{h,x}` and `{ρh,x'}`), so both
die entirely: the removed set is even, `σ_c`-invariant, and closed — the bulk mirror resumes
on the rest. The seed pair's own direction `[x₀ − y₀]` is dead from move two (it lies on the
selected line `x₀y₀`), the analog of `[v]`-self-blocking.

## 3. H-side soundness is C25 restricted to H

A chord of an `H`-pair `{h, ρh}` is a line **inside** `H` (two points of a hyperplane span a
line of it), so it never meets `A`: no coupling from the `H` side. Any selected `z` on that
chord has `ρz` on the same chord (`ρ` maps the chord to itself), so `h` was already illegal —
the whole-board mirror argument of C25/C27 verbatim, restricted to `H`. Cross-region triples
are exhausted by: a non-`H` line meets `H` in ≤1 point; a line with two `H`-points lies in
`H` and contains no affine point.

## 4. What remains is a finite list of LOCAL, escape-like obligations

The scheme is sound except at explicitly enumerable moments, each a *local existence*
statement, not a global invariant:

1. **Exception-cell existence:** when P1 enters the `h`-pencil, a legal `x'` exists on the
   `ρh`-pencil line. Naive counting does not settle this at large position sizes (each
   selected pair can kill one candidate via its line's intersection with the target pencil);
   this is the scheme's real open kernel.
2. **H-reply existence:** P2's ρ-reply is legal (settled by §3 within `H`; the cross checks
   are the triple exhaustion above).
3. **Seed legality:** a `y₀` exists making `{x₀, y₀}` a cap with a usable center (large room;
   check smallest q by machine).

This is the same reduction shape route C used: the odd-escape statement turned the plane into
per-q local escape obligations; the composite turns the even-dimensional spaces (and possibly
the plane, §5) into per-q local exception obligations. Machine-check them per q; a counting
or geometric argument closing them uniformly is then the whole theorem.

## 5. The plane transfer — genuinely untried

For `m = 1`: `H` = a line `ℓ` (even count `q+1`, elliptic ρ exists on `PG(1,q)`), `A =
AG(2,q)`. The cap condition caps `|S ∩ ℓ| ≤ 2` automatically, so the ℓ-side degenerates: at
most one move-pair ever lands on `ℓ`, and the poison set is ≤2 pencil lines — handled by the
same double-burn. P2's extra freedoms: `ℓ` is chosen adaptively (not fixed by an opening),
the ℓ-reply `h'` is P2's choice, and `c` is seeded by P2's own reply.

**This is not the strategy that failed on 2026-07-05.** That analysis worked
post-frame-reduction: the opening pair was burned, the residual carried the
partial-permutation (≤1 per row/column) constraint, and σ_c's failures were the center's
row/column *of the burned frame* — reflections were dead there because every mirror pair
shared a row or column. The composite here never burns an opening pair: P2 seeds the
reflection with its own reply (midpoint trick), all constraints are pure collinearity, and
the special structure is the ≤2 selected ℓ-points with ρ/choice-paired pencils. Different
obstruction algebra. It must still be diffed against
`2026-07-05-qodd-central-symmetry-findings.md` explicitly (the probe's job), and one plane
obligation is already provable by counting: the ℓ-reply `h'` exists because selected affine
pairs number ≤ `(q+1)/2` (max plane cap `q+1`), so their killed directions cannot cover the
`q` candidate ℓ-points. The exception-cell obligation (item 1 of §4) is the live question —
the plane ladder is solved through q=19, so a stuck-free run at q=11/13 is meaningful
evidence and a failure is an exact counterexample trace.

## 6. What a stuck-free verdict unlocks

- **PG(4,3) stuck-free** → write the q-uniform, m-uniform kernel (every ingredient above is
  uniform except the §4 obligations) → theorem candidate `PG(2m,q) = P` for all `m ≥ 2`, odd
  q, modulo per-q-checkable local obligations. Combined with C25 (odd dims) and the even-q
  theorem: **every board except the planes**.
- **Plane variant stuck-free at q = 11, 13** → candidate uniform odd-plane mechanism → the
  full conjecture, with the q ≤ 19 certificate ladder as independent backstop.
- **Failure** → the obstruction histogram lands in a new, sharper vocabulary (pencil poison,
  exception scarcity) that feeds C28's `Obs` census and the strategy-level lane; the §4
  obligation that fails becomes the new open kernel — strictly better-posed than "find a
  mechanism".
- **Lean distance is short if the math lands:** C27's pair-extension lemma is the step, C25
  supplies ρ, the midpoint trick is the affine theorem's formalized move, and the C19
  reflection-checker tech certifies exception tables. Nothing new in kind.

## 7. Probe guidance (v2 amendments to C32)

- P2 must be simulated as a **policy** (bulk mirror + seed rule + ℓ/H rule + double-burn
  exceptions + adaptive choices), not a static pairing; obligation failures (§4) are
  first-class recorded outcomes, not just "stuck".
- Candidate family: (i) point-reflection composite + double-burn (primary); (ii) reflection
  towers; (iii) variations in the adaptive choices (`ℓ`/`H`, `c`, `h'`, exception cell
  selection heuristics).
- **Plane first** (q = 9, 11, 13): cheapest, ground truth known, and the diff against the
  2026-07-05 grid findings is mandatory reporting. Then PG(4,3).
