# F3 soundness audit — the referee-probe chain (2026-07-07)

Adversarial pass over the four links a referee (or a wrong q=23 verdict) would probe:
the frame-chain hypotheses, the resym exhaustiveness claim, the canon min-image invariance
argument in `2026-07-06-grid-cap-solver.rs`, and the escape/esc/feat memo reuse. Every argument
was re-derived from scratch, not pattern-matched against the notes.

**Verdict: the chain is sound.** No hole invalidates any recorded result. One latent code bug
found (GF(49) irreducible entry is reducible — unreachable today), plus three documentation
gaps a referee would flag, ranked below with dispositions.

## 1. Frame chain (sizes 0–4 single-orbit argument) — SOUND

Audited `2026-07-06-frame-reduction.md` line by line.

- Transitivity inputs (points / pairs / triangles / frames each one PGL(3,q)-orbit) are the
  standard fundamental-theorem facts; PGL ⊆ PΓL preserves caps, hence game values. ✓
- The alternating ∀/∃ chain is quantifier-correct **given non-terminality at each level**, and
  non-terminality holds: a triangle extends (≥ q²+q+1−3q > 0 points off its sides for q ≥ 3;
  Fano centre at q=2), pairs and points trivially. ✓
- Terminal edge case at the crux level: a *maximal* size-3 grid position would have escape = 0
  and be P, flipping the frame to N — the equivalence `escape ≥ 1 for every S3 ⟺ PG(2,q)=P`
  remains correct in that case (both sides false), so the escape-mode falsification signal is
  exact, not merely sufficient. ✓ (q=3 is the realized instance one level up: the frame itself
  is maximal, and the reduction handles it as vacuous.)
- **Quantifier gap worth one paper sentence (D3 below):** the crux quantifies over *all* 3-cell
  grid positions, but the frame-P condition only needs the frame's *children* (3-cell positions
  containing `{(0,0),(1,1)}`). These coincide up to symmetry because G is transitive on legal
  2-cell grid positions (translate u→(0,0), scale v→(1,1); scalings exist since a legal pair
  shares no row/col ⇒ nonzero coordinate differences), so every 3-cell class contains a frame
  child. Verified; the argument is nowhere written down.

## 2. Resym exhaustiveness claim — SOUND, one lemma missing from the record

The NO verdicts at q=11,13,17 (`2026-07-07-resym-symmetric-family-dead.md`) are exhaustions
*relative to the enumerated symmetry set*. Two layers audited:

**(a) The enumeration is exhaustive within the semilinear monomial affine family.** ✓
`all_involutions`/`all_autos` iterate every (field automorphism σ, swap, α, β, s, t) with
α,β ≠ 0, dedupe on the full cell permutation, and filter id (and non-involutions for v0–v2).
`field_autos` generates exactly ⟨Frobenius⟩ (identity only for prime q — verified by trace).
The q=11 count in the note (24,199 = 2(q−1)²q² − 1) matches the group order, a good cross-check.

**(b) "These are ALL automorphisms of the game hypergraph"** — true, but the proof is a
two-step argument that exists nowhere in the notes (D1 below):
  1. A legality-preserving cell bijection preserves the illegal *pairs* (= shares row or col),
     i.e. is an automorphism of the rook's graph K_q□K_q, hence (row perm × col perm) ⋊ swap
     for q ≠ 4 (and q=4 is only a positive-control case, not load-bearing).
  2. It also preserves the illegal-but-row/col-legal *triples* = collinear triples with
     distinct rows and cols; every non-axis affine line (q ≥ 3 points) is a maximal such set,
     so the map is a collineation of AG(2,q). A collineation of monomial shape is semilinear
     with a **single** field automorphism on both coordinates — the twisted form
     (aσ(r)+s, bτ(c)+t), σ ≠ τ, does *not* preserve collinearity (τ∘σ⁻¹ applied inside an
     affine expression is not affine), so nothing outside the enumerated family exists.
  The load-bearing q = 11, 13, 17 are prime (no Frobenius, no rook exception), so the NO
  verdicts stand on step-1/step-2 alone. → machine check queued (C7).

**(c) Reply reconstruction and memoization inside `resym_safe`.** ✓ Re-derived the D = φ(T)\T
case analysis: |D| ≥ 2 unrestorable (g(U)=U forces g(T) ⊆ U); |D|=1 forces y = the D element,
and for involutions g(y)=t0 is automatic (the counting argument checks out), while general g
correctly gets the extra `g(y) ∈ U` test; |D|=0 forces y ∈ Fix(g) (g(T)=T + injectivity ⇒
g(y)=y). No candidate (y, g) is missed. Memoizing SAFE on `canon` is exact: the canon group G
is a subgroup of the full automorphism group A, conjugation by G maps A to itself, deadness and
the fixed/problem sets are G-equivariant, and SAFE is only ever keyed at even sizes. The note's
v3 ⟹ v4 subfamily argument (a restricted-game win is an unrestricted win, so SAFE positions
are true P) is also correct.

## 3. Canon min-image invariance (Rust `canon`) — SOUND as a fingerprint scheme

- **Well-definedness:** for each ordered occupied pair (u,v) and swap bit there is a *unique*
  g ∈ G with g(u)=(0,0), g(v)=(1,1); the needed scalings exist because a legal position never
  repeats a row/col, so v−u has nonzero coordinates and `gf.inv` is never hit at 0. ✓
- **Invariance:** for h ∈ G, the anchor maps of h(S) are exactly {g′ : g′∘h ranges over the
  anchor maps of S} (uniqueness + group closure, swap parities compose), so the *collection of
  image sets* is G-invariant and its min hash is a G-invariant. ✓ Sizes 0/1 sentinels are
  valid (translations act transitively on cells). ✓
- **Forbidden-set derivability** (needed for keying on `chosen` alone): forbidden(S) =
  rows/cols of S ∪ pairwise lines of S; the incremental `line_mask` accumulation reproduces
  exactly this union along every path. ✓ G maps lines to lines and the row/col classes to
  themselves. ✓
- **CAVEAT (D2 below):** the key is a **128-bit additive fingerprint** (sum of fixed per-cell
  splitmix hashes, min over images), *not* an exact canonical form. A collision silently merges
  two distinct classes. Birthday risk at the realized scales is negligible (≪ 10⁻²⁰ even at
  10⁹ classes) and class counts were validated against the exact Python canon at small q — but
  any paper-grade claim resting on a big run (e.g. a q=23 escape verdict) should state the
  fingerprint + validation, and the min-escape witness classes should be re-checked with an
  exact canon (C8). The parallel arena truncates further to 126 bits; same character.

## 4. Escape / esc / feat memo reuse — SOUND

- **`escape`/`feat` phase-2 lookups:** phase 1 is a *full* expansion from the empty root, and
  legality is hereditary (any subset of a legal position is legal, built one cell at a time),
  so every size-4 child of every size-3 class is already memoized; the `None ⇒ recompute`
  fallback is dead code kept as belt-and-braces. ✓
- **`enumerate` orbit-BFS completeness:** pruning at intermediate canonical classes is safe
  because extension sets are G-equivariant, so "child classes of a class" is well defined and
  induction over levels reaches every size-3 class regardless of which representative was
  expanded. ✓
- **`esc` private memo:** sound for a simpler reason than the note's "merges more, never fewer"
  phrasing — the game value is a G-invariant function of the chosen set alone (forbidden
  derivable, §3), so a canon-keyed memo is exact in *any* scope, private or global. Cap-abort
  is conservative (skip + report, propagates up; never a wrong value). Per-extension (not
  per-class) escape counting matches `escape` mode's semantics. Filtered/aborted runs print
  PARTIAL and make no root claim. ✓
- **`feat` conic math:** the 3×3 GF solve's determinant is the collinearity determinant
  (nonzero by the cap property, guarded); the polar form B(P,V), the two infinite-point
  tangent tests (v_c+ε, v_r+ζ), and the 0/2 external/internal dichotomy (q odd) are all
  correct; sanity checks (q−1 affine cells, per-row/col functionality, anomalous tangent
  counts) run per class. ✓

## Bug found (latent, no result affected)

**`irred(49)` in the Rust solver is wrong:** `x²+3` over F₇ is *reducible* — the comment tests
"3 nonsquare mod 7" but irreducibility of x²+c needs **−c** nonsquare, and −3 ≡ 4 = 2² (mod 7),
so x²+3 = (x−2)(x+2) and the "GF(49)" tables would be F₇×F₇, a ring with zero divisors.
Unreachable today: MAXW bounds q ≤ 32, and a q=49 run panics loudly on mask width before any
arithmetic. The Python `gf.py` has **no** 49 entry and nothing in notes/ uses q=49. All other
entries re-verified irreducible (4, 8, 9, 16, 25, 27, 32). Fix (queued as C6, after Codex's C3
finishes with the file): use `x²+1` (−1 nonsquare mod 7 since 7 ≡ 3 mod 4), plus a startup
field self-check so a bad entry can never fail silently.

## Ranked holes and dispositions

| # | severity | item | disposition |
|---|----------|------|-------------|
| B1 | latent bug | GF(49) reducible polynomial | C6: fix + field self-check + width assert |
| D1 | referee-probe | automorphism-exhaustiveness lemma unwritten (two-step: rook graph → collineation → single-σ monomial) | C7: prose lemma + brute-force machine check at small q; cite in the resym note |
| D2 | paper caveat | canon is a probabilistic fingerprint, not an exact canonical form | C8: exact-canon cross-validation q=11/13 + exact recheck of min-escape witness classes; state the caveat wherever computed verdicts are claimed |
| D3 | one sentence | crux quantifier ("all S3" vs "frame children") justified only implicitly | add the G-transitivity sentence (§1) to the kernel/paper text |

Nothing else survived the pass: the reply-reconstruction case analysis, the SAFE memoization,
the v3/v4 relation, the escape terminal edge case, the enumerate pruning, and the feat polar
computations were all probed and held.
