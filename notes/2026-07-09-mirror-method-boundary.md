# Mirror method: boundary theorem (#5) and extension scopes (#3, #4)

Follow-on to the C48 harvest ([`2026-07-09-codex-mirror-harvest.md`](2026-07-09-codex-mirror-harvest.md)).
Written by Claude/Opus 2026-07-09.  The C48 general proposition is Lean-proven
(`ProjectiveCap.Projective.initialSubCapP_of_fpf_collinearity_preserving`): a fixed-point-free
collinearity-preserving involution that fixes a sub-board `X ⊂ PG(V)` ⇒ the cap/Nofil game on `X`
is P.  This note (a) packages *where that method stops* into one boundary statement, and (b) scopes
two further positive extensions.

**Active formalization tracking:** C85–C88 in the dedicated
[`mirror-boundary handoff`](handoffs/2026-07-12-mirror-boundary-formalization.md). This note is the
detailed mathematical specification; the handoff is the live current-state map.

---

## #5 — Boundary classification program: which classical varieties admit an fpf mirror

**Setup.** `q` odd.  `X` a nondegenerate classical polar-space variety that is a *nontrivial* cap
board (some ambient line meets `X` in ≥ 3 points — this excludes ovoids/ovals/conics, which are
free-placement parity games).  The mirror method applies to `X` iff its projective stabilizer
`PΓO(V)` / `PΓU(V)` contains a **fixed-point-free involution** (an order-2 collineation fixing `X`
and no point of `X`) — because any such element preserves ambient collinearity (it is a
collineation) and the board, so it feeds the C48 proposition.

**Status (strict trust gate, audited 2026-07-12).** Among the nontrivial classical polar-space
cap games over odd `q`:

1. **Hyperbolic quadrics `Q⁺(2m−1,q)` admit an fpf mirror** (for every `m ≥ 2`).  → P.  *(C48,
   fully proven: the elliptic block similitude `(aᵢ,bᵢ)↦(δ·bᵢ,aᵢ)`, `δ` nonsquare.)*
2. **Parabolic quadrics `Q(2m,q)` (`m ≥ 2`) admit NO fpf involution.**
   *[FORMAL REDUCTION + PROVEN-PROSE]* The nonsplit linear odd-dimension obstruction is Lean-proved
   in `ProjectiveCap.MirrorBoundary`; the split-isotropy and semilinear Baer branches remain.
3. **Hermitian varieties `H(k,q²)` (`k ≥ 2`) admit NO fpf involution.**
   *[PROVEN-PROSE]* The eigenline-to-board-fixed-point reduction is Lean-proved; finite Hermitian
   isotropy, the nonsplit adjoint/multiplier lemma, and the semilinear branch remain.
4. **Conjecture:** elliptic quadrics `Q⁻(2m−1,q)` (`m ≥ 3`) admit no fpf mirror. The
   split route is excluded rigorously and the natural nonsplit similitude fails — one Witt-transfer
   classification remains; see the open item.

The established positive theorem proves P for the split (hyperbolic) quadratic forms. The other
types are candidate boundaries, with the trust status above; an exact/coextensive classification
is not claimed until the remaining form-theoretic lemmas are proved. Crucially this is a boundary of the
*method*, not of the *outcome* — `H(2,9)` and `H(3,4)` are computed **P** despite carrying no fpf
involution (C48).  A mirror obstruction is not an N verdict.

### Proof structure

Any variety-stabilizing collineation of order 2 is (i) *linear*, `A² = c·I` for a scalar `c`
(a `PGL` element), or (ii) *semilinear* of Baer type (twisted by an order-2 field automorphism,
only when `q` is a square).

**Baer case (ii).** A Baer involution fixes a Baer subgeometry `PG(n,√q)` pointwise; subvarieties
over the subfield are nonempty and lie on `X` (e.g. the `F_q`-points of a Hermitian curve form a
conic), so it always has fixed points on `X`.  Never fpf.  Excluded for all these varieties.

**Linear case (i)** splits on whether `c` is a square:

- **Split (`c` a square).**  Rescale `A²=I`; eigenvalues `±1` give an orthogonal decomposition
  `V = V₊ ⟂ V₋` into nondegenerate eigenspaces (a form-preserving involution has orthogonal
  eigenspaces).  Fixed points on `X` are `P(V₊) ∪ P(V₋) ∩ X`, so **fpf ⟺ both `V₊`, `V₋` are
  anisotropic** (contain no variety point).  Over a finite field:
  - *Quadratic, `q` odd:* an anisotropic quadratic subspace has dimension ≤ 2 (every form of
    dim ≥ 3 is isotropic).  Both eigenspaces ≤ 2 ⇒ `n ≤ 4`.  For a nontrivial board this forces
    `n = 4` and, since two anisotropic planes sum to the **hyperbolic** 4-space, `X = Q⁺(3,q)`.
    So the split route yields *only* `Q⁺(3,q)`; no `n ≥ 6` quadric and no elliptic/parabolic form
    gets a split fpf involution.
  - *Hermitian over `F_{q²}`:* an anisotropic Hermitian subspace has dimension ≤ 1.  Both ≤ 1 ⇒
    `n ≤ 2` ⇒ `k ≤ 1`, a trivial board.  **No nontrivial Hermitian variety has a split fpf
    involution.**
- **Nonsplit (`c` a nonsquare).**  `x²−c` is irreducible, so `A` makes `V` an `F_{q²}`-space
  (`A = √c`, forcing `dim_{F_q} V` even) and `[A]` is automatically fpf on *all* of `P(V)`.  For
  `[A]` to fix `X` it must be a **similitude** (`Q∘A = μ·Q`, forcing `μ = ±c`).
  - *Parabolic `Q(2m,q)`:* `n = 2m+1` odd ⇒ no nonsplit involution exists at all.  Combined with
    the split exclusion above (`m ≥ 2` ⇒ no split fpf either): **parabolic quadrics have no fpf
    involution.**  ∎ (2)
  - *Hermitian:* a unitary similitude with `A²=cI` is self-adjoint (`B(Au,v)=B(u,Av)`), and the
    unitary-similitude condition forces the factor `c ∈ F_q`; but every element of `F_q` is a
    square in `F_{q²}`, contradicting `c` nonsquare in `F_{q²}`.  So no nonsplit unitary
    similitude of order 2 exists.  Combined with the split exclusion: **Hermitian varieties
    (`k ≥ 2`) have no fpf involution.**  ∎ (3)
  - *Hyperbolic `Q⁺(2m−1,q)`:* the elliptic block similitude realizes exactly this nonsplit case
    for every `m` (each `K²` block is a hyperbolic plane `Q=ab` on which `A` is a factor-`δ`
    swap-similitude).  ∎ (1)
  - *Elliptic `Q⁻(2m−1,q)`:* the split route is excluded for `n = 2m ≥ 6` (above), and the
    elliptic block similitude fails (its anisotropic tail is not a hyperbolic plane, so the map
    leaves the quadric — machine-verified on `Q⁻(5,3)`).  A full exclusion needs the
    Scharlau-transfer computation (see open item). This is conjectural in the general case.

### Machine anchors

The Witt facts the split argument rests on, verified over `F₃,F₅,F₇` / `F₄,F₉`
(`rust/scripts` idiom; run inline in this session):

```
F3: anisotropic plane exists=True; every dim-3 quadratic form isotropic=True; aniso⊕aniso -> 16 proj pts = hyperbolic Q+(3,q)
F5: ... 36 proj pts = hyperbolic Q+(3,q)
F7: ... 64 proj pts = hyperbolic Q+(3,q)
F9 (q=3): Hermitian plane diag(1,1) isotropic (has curve point) = True   (anisotropic Hermitian dim<=1)
F4 (q=2): Hermitian plane diag(1,1) isotropic = True                     (anisotropic Hermitian dim<=1)
```

Plus the C48 witnesses: natural involutions on `H(2,9)`/`H(3,4)`/`Q(4,3)` each fix variety points;
the elliptic block map leaves `Q⁻(5,3)`.

### Remaining real-math obligations

The Lean reductions now certify: square scalar implies a square-scalar linear projectivization has
a fixed point; an isotropic eigenvector gives a board fixed point; and an odd-dimensional matrix
cannot square to a nonsquare scalar. Completing rows 2–4 still requires:

1. finite quadratic isotropy in dimension at least three, with the required eigenspace restriction;
2. finite Hermitian isotropy in dimension at least two;
3. the unitary nonsplit adjoint/multiplier classification;
4. the semilinear/Baer involution classification and a theorem that its fixed subgeometry meets
   each board in scope;
5. for `Q⁻`, the Witt/Scharlau-transfer classification below.

Prove: **an elliptic quadric `Q⁻(2m−1,q)` (`m ≥ 3`) admits no nonsplit fpf similitude of order 2.**
Route: a nonsplit order-2 similitude corresponds (self-adjoint `√c`, Scharlau transfer) to an
`F_{q²}/F_q`-Hermitian form `h` on the `m`-dim `F_{q²}`-space with `Q = Tr_{F_{q²}/F_q}(h)`; the
transfer of an `m`-dim Hermitian form is hyperbolic for `m` even and elliptic for `m` odd — but the
*order-2* constraint pins which `m` is available, and needs to be worked out.  (An exhaustive cap
solve of `Q⁻(5,3)` would settle the smallest case decisively — an N verdict proves no mirror — but
its 112-point game is out of reach for the pure-Python solver; a private-memo Rust solve or the
transfer lemma is the way.)  This is a clean, bounded lemma; it does not gate anything downstream.

### Publishable framing

This is the candidate "separating mirror obstructions from outcomes" classification of the
harvest. The proved positive family is hyperbolic; parabolic and Hermitian exclusions remain
proved prose with partial formal reductions, and the elliptic exclusion is conjectural. Its
silence on these boards concerns the method, not the game values. Positioning stays conservative: the mechanism is the
standard pairing/copycat ingredient; the contribution is the exact incidence-geometric boundary.

---

## #3 — Scope: polar-space Nofil (board = full `PG`, constraint = isotropic lines of a form)

**Idea.**  Invert the figure–ground of the harvest.  Instead of the variety being the *board* and
ambient lines the *constraints*, take the whole space `PG(2n−1,q)` as the board and let the
*constraint lines* be the totally-isotropic lines of a polar space.  A position is legal iff it
contains no 3 points on a common isotropic line.  This is a genuinely different (weaker-constrained)
game than the full cap game — fewer forbidden triples.

**Why symplectic `W(2n−1,q)` is the cleanest first target.**  For a symplectic form *every* point
is isotropic, so the board is *all* of `PG(2n−1,q)` — odd projective dimension — and the C25
elliptic fpf involution already lives there.  It applies verbatim **iff it is a symplectic
similitude** of the chosen alternating form.  Concretely: choose the alternating form and the
elliptic block map compatibly (the block `(a,b)↦(δb,a)` on a hyperbolic pair is a symplectic
similitude of `a b' − a' b` up to factor — verify), then the C48 proposition (in its
`FiniteBuildGame` conflict-hypergraph form) gives P.

**Deliverables to scope.**
1. Machine gate: build `W(3,q)` (= `PG(3,q)` with the 40-ish isotropic lines) for `q = 3, 5`,
   confirm the isotropic-line hypergraph, exhaustively solve, and test the elliptic involution's
   fpf + isotropic-line-preservation + C27 pair-extension.  Then `W(5,3)` (mirror-only proof).
2. Extend to unitary/orthogonal polar spaces' isotropic-line games as a second family; watch for
   the same anisotropic-core obstructions as #5 (the *board* is now the whole space, but the
   involution must preserve the isotropic-line set, i.e. be an isometry/similitude — so the #5
   dichotomy likely recurs at the group level).
3. Lean: this is a `FiniteBuildGame` over `Point K V` with `Valid := no 3 on a common isotropic
   line`.  If the isotropic-line predicate is awkward in mathlib, model the constraint as the
   symplectic-collinearity relation and reuse the conflict-hypergraph mirror lemma the #1 sub-agent
   is building.

**Confidence:** medium-high for symplectic (needs the "elliptic map is a symplectic similitude"
check — the same similarity trick as C48); the polar-space families likely inherit the #5 boundary.

## #4 — Scope: Segre / product varieties

**Idea.**  `Q⁺(3,q)` *is* the Segre variety `PG(1,q) × PG(1,q) ↪ PG(3,q)` (the `(q+1)×(q+1)` grid).
Generalize the board to `PG(a,q) × PG(b,q) ↪ PG(N,q)` (Segre embedding): its ≥3-point ambient
lines are exactly the two rulings — a *grid of subspaces* — so the cap game is a capacity-2
"rook-lines on a subspace-grid" game.

**Mirror.**  Take `σ = σ_a × σ_b` where one factor carries a fixed-point-free involution.  The
cleanest instance: `PG(a,q) × PG(2m−1,q)` with `σ = id × (elliptic fpf involution on the odd
factor)`.  `σ` is fpf on the product (fpf in the second coordinate ⇒ fpf overall), preserves the
ruling structure (product of collineations), and the C27 pair-extension should reduce to the
single-factor argument.  → a **Segre-variety Nofil family** at lemma-application cost.

**Next step up — Grassmannians via Plücker.**  `Gr(2,4)` under Plücker *is* the Klein quadric
`Q⁺(5,q)` — already covered by #5.  Higher `Gr(k,n)`: points = `k`-subspaces, ≥3-point lines =
pencils; an fpf map on `F^n` (e.g. the elliptic involution when `n` even) induces an involution on
`Gr(k,n)` — fpf when it fixes no `k`-subspace, which needs a genuine check (a `√c`-eigenspace-free
condition).  A "Grassmannian Nofil" family is plausible but the fpf condition is the crux.

**Deliverables to scope.**
1. Machine gate: build `PG(1,3) × PG(1,3)` (= `Q⁺(3,3)`, sanity) then `PG(1,3) × PG(3,3)` and
   `PG(2,3) × PG(1,3)`; confirm the ruling hypergraph, solve small, test `id × elliptic`.
2. Lean: the product board is a `SubCap`-style game on `Point K (V ⊗ W)` or on the explicit grid
   model; reuse the C48 proposition once the product involution's collinearity-preservation +
   quadric/ruling-preservation is shown.
3. Watch: which factor parities give fpf (need the odd factor); products of two even-dim factors
   may fail exactly as the #5 boundary predicts.

**Confidence:** medium; `PG(a,q) × PG(2m−1,q)` should go through cleanly (it is the C48 argument
one factor at a time), Grassmannians need the fpf-on-`k`-subspaces check.
