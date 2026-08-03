# C855 — structural proofs for the conic-orbit clause, the code/geometry dictionary, the syndrome-weight trichotomy, one-factorization uniqueness, and the covering-radius layer

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Task:** C855 — Paper I Lean referee-artifact remediation, structural-mathematics stream.
**Scope:** mathematics only. No Lean file was edited, no Lean build, generator, gate, or manifest was
run, and no manuscript text was changed. Lean sources and the manuscript were read read-only.

Targets are the remaining abstract-level human proofs and the small classical external transfers
carried in `notes/2026-08-02-c855-paper-i-assertion-inventory.md`, Part A "Abstract and
introduction" and the code-section rows, and grouped in Part D.

| target | manuscript location | verdict |
|--------|--------------------------------------------------|--------------------------------------------------|
| 1 | orbit clause after `thm:rigidity`, and the abstract | **proved**, with the Bézout input replaced by five-point interpolation |
| 2 | the paragraph after the proof of `thm:rigidity`     | **proved**, both directions, no MDS hypothesis needed |
| 3 | the arc–coset dictionary in the introduction        | **proved**, for every field and every redundancy-three MDS code |
| 4 | inside the proof of `lem:six-arc-line-bound`        | **proved**, self-contained, and it also supplies the count six |
| 5 | the abstract's coding layer                         | **proved**, as a corollary of Target 3 plus one definitional identity |
| 6 | the non-GRS clause in Section "The code"            | **proved**, and upgraded to a two-way criterion |

Companion inputs used as established: `notes/2026-08-03-c855-dye-orbit-uniqueness.md` (golden normal
form, polarity matrix `S`, `A₅` stabilizer), `notes/2026-08-03-c855-support-bipartition-proofs.md`
(concurrence machinery, the five triangles, `MAut(C) ≅ C₁₀ × A₅`),
`notes/2026-08-03-c855-orbit-classification-proofs.md` (the `A₅` orbit results).

Standing notation. `K` is a field, `PG(2,K)` its projective plane. A *conic* is the projective zero
set of a nonzero ternary quadratic form; it is *nonsingular* when the form is. For a set `A` of
points, a *chord* (secant) is a line through two distinct points of `A`, and
```
𝒰(A) = { [x] ∈ PG(2,K) : [x] ∉ A and [x] lies on no chord of A }
```
is the uncovered (extension) locus. `H` is a full-rank `r × n` parity-check matrix with columns
`h₁,…,hₙ`, `C = ker H`, and `w(s) = min{ wt(e) : H eᵀ = s }`.

---

## Target 1 — the arcs with a prescribed uncovered conic form one orbit under the conic stabilizer

### What the manuscript asserts and what it uses

After `thm:rigidity`: *"fix a nonsingular conic `𝒞`. The six-arcs satisfying `𝒰(A) = 𝒞(F₁₁)` form
one orbit under `Stab_{PGL(3,11)}(𝒞)`. Indeed, a projectivity between two such arcs carries one
uncovered locus to the other. Its image of `𝒞` therefore shares all twelve rational points with
`𝒞`, so Bézout's theorem makes the two conics equal."*

The only external input is "two distinct conics share at most four points". For conics this is not
plane-curve Bézout: it is five-point interpolation, and the proof below is three lines of linear
algebra over an arbitrary field. That removes Bézout from the transfer ledger for this clause. (The
proof of `thm:rigidity` itself uses the same bound once more, to exclude a degenerate `Q`; the same
lemma covers it, see 1.5.)

### 1.1 Five points in general position lie on exactly one conic

**Lemma 1.1.** Let `K` be any field and let `P₁,…,P₅ ∈ PG(2,K)` be five distinct points, no three
collinear. Then the space of ternary quadratic forms over `K` vanishing at all five is
one-dimensional. Hence there is exactly one conic through `P₁,…,P₅`.

*Proof.* Quadratic forms in three variables form a six-dimensional `K`-space `W`, and evaluation at a
point is a well-defined linear condition once a representative vector is chosen. Let
`ev : W → K⁵` be the evaluation map at the five chosen representatives. For each `i`, write
`{j,k,l,m} = {1,…,5} \ {i}` and let `ℓ_{jk}`, `ℓ_{lm}` be linear forms cutting the lines `PⱼPₖ` and
`P_lP_m`; these are defined over `K` because the points are. The product `ℓ_{jk}·ℓ_{lm}` is a nonzero
quadratic form vanishing at `Pⱼ, Pₖ, P_l, P_m`, and it does **not** vanish at `Pᵢ`, since `Pᵢ` on
`ℓ_{jk}` would make `Pᵢ, Pⱼ, Pₖ` collinear and likewise for the other factor. So `ev` hits every
standard basis vector of `K⁵` up to a nonzero scalar, hence is surjective, and
`dim ker ev = 6 − 5 = 1`. ∎

**Lemma 1.2 (no three collinear on a nonsingular conic).** A line meets a nonsingular conic in at
most two points.

*Proof.* Restricting the quadratic form to a line gives a binary quadratic form. It is nonzero:
otherwise the line lies in the conic, and a conic containing a line has its form divisible by the
line's linear form, hence is a product of two linear forms and is singular. A nonzero binary
quadratic form has at most two projective zeros. ∎

**Corollary 1.3 (the Bézout input, proved).** Two nonsingular conics over `K` sharing at least five
`K`-rational points are equal. Equivalently, two distinct nonsingular conics share at most four
rational points.

*Proof.* By Lemma 1.2 no three of the five shared points are collinear, so Lemma 1.1 makes the two
defining forms proportional. ∎

The same statement holds with one conic merely required to have no linear factor over `K`; only
Lemma 1.2 needs adjusting, and it is not needed below.

### 1.2 Naturality of the uncovered locus

**Lemma 1.4.** For `g ∈ PGL(3,K)` and any point set `A`, `𝒰(gA) = g·𝒰(A)`.

*Proof.* `g` is a bijection of points carrying lines to lines and preserving incidence, so it carries
the chords of `A` onto the chords of `gA` and `A` onto `gA`; the defining condition of `𝒰` is
therefore transported. ∎

### 1.3 The orbit theorem

**Theorem 1.5.** Let `K` be a field, `𝒞 ⊂ PG(2,K)` a nonsingular conic with at least five rational
points, and let
```
𝔄(𝒞) = { six-arcs A : 𝒰(A) = 𝒞(K) }.
```
Then `Stab_{PGL(3,K)}(𝒞)` acts on `𝔄(𝒞)`, and any two members of `𝔄(𝒞)` that are
`PGL(3,K)`-equivalent are equivalent under `Stab(𝒞)`. In particular, if `𝔄(𝒞)` is contained in a
single `PGL(3,K)`-orbit — which for `K = F₁₁` is `thm:rigidity` — then `𝔄(𝒞)` is a single
`Stab(𝒞)`-orbit.

*Proof.* Stability: for `h ∈ Stab(𝒞)`, Lemma 1.4 gives `𝒰(hA) = h𝒰(A) = h(𝒞(K)) = 𝒞(K)`.
Transitivity: let `A, A' ∈ 𝔄(𝒞)` and `g ∈ PGL(3,K)` with `gA = A'`. By Lemma 1.4,
`g(𝒞(K)) = g𝒰(A) = 𝒰(A') = 𝒞(K)`. The image `g(𝒞)` is again a nonsingular conic, and its rational
points are `g(𝒞(K)) = 𝒞(K)`, so `g(𝒞)` and `𝒞` are two nonsingular conics sharing at least five
rational points; Corollary 1.3 gives `g(𝒞) = 𝒞`, that is `g ∈ Stab(𝒞)`. ∎

At `K = F₁₁` the hypothesis holds with room to spare: `|𝒞(F₁₁)| = 12 ≥ 5`. Combined with
`thm:rigidity` this is exactly the manuscript's clause, and it is now Bézout-free.

### 1.4 The same lemma repairs the degenerate-`Q` step of `thm:rigidity`

The proof of `thm:rigidity` ends: *"the original `Q` cannot be degenerate, since Bézout bounds its
intersection with `𝒞` by four."* Here `Q` is a possibly degenerate conic containing the twelve points
of `𝒰(A) = 𝒞(F₁₁)`, and one wants `Q = 𝒞`. The clean replacement does not even need `Q` to be
compared with `𝒞` through an intersection bound: the twelve points of a nonsingular conic contain
five with no three collinear (Lemma 1.2), so by Lemma 1.1 the conic through them is unique, and both
`Q` and `𝒞` are such conics. Hence `Q = 𝒞` outright, and in particular `Q` is nonsingular. This is
shorter than the manuscript's argument and removes the second Bézout appeal.

### 1.5 Formalization shape

Quantification: Lemmas 1.1, 1.2, 1.4 and Corollary 1.3 should be stated for an arbitrary field and
the development's own `PG(2,K)`, conic, and line layer; they are reusable and characteristic-free.
Theorem 1.5 is likewise field-generic, with the `q = 11` instance obtained by supplying
`thm:rigidity` and `|𝒞(F₁₁)| = 12`.

| remaining finite piece | size |
|---|---|
| existence of five points of `𝒞(F₁₁)` with no three collinear | immediate from Lemma 1.2; no search |
| `|𝒞(F₁₁)| = 12` | already available in the development's conic layer |
| nothing else | — |

Mathlib/library inputs: none beyond the project's own projective-plane and quadratic-form layer.
Lemma 1.1 is a rank statement about a `5 × 6` matrix whose surjectivity is witnessed by five explicit
products of linear forms, so the Lean proof is constructive and needs no determinant computation.

**Verdict: proved**, for every field, with Bézout replaced by five-point interpolation, and with a
by-product repair of the degenerate-conic step inside `thm:rigidity`.

---

## Target 2 — projective equivalence of column sets equals monomial equivalence of codes

### Statement

Let `K` be a field. Call `H, H' ∈ K^{r×n}` *admissible* when each has rank `r` and all columns are
nonzero and pairwise non-proportional. (For a redundancy-`r` MDS code with `n ≥ r ≥ 2` the columns
form an arc, so every `r` of them are independent, hence in particular every two are: admissibility
is automatic.) Write `C = ker H`, `C' = ker H'`, and
```
𝒫(H) = { [h₁], …, [hₙ] } ⊂ PG(r−1, K),
```
a set of exactly `n` distinct points.

**Theorem 2.1.** For admissible `H, H'` the following are equivalent.

1. `C` and `C'` are monomially equivalent: there are a permutation `π ∈ Sₙ` and scalars
   `λ ∈ (K^×)ⁿ` with `C' = { (λ₁c_{π⁻¹(1)}, …) }`, i.e. `c ∈ C ⟺ c' ∈ C'` where
   `c'_{π(j)} = λⱼcⱼ`.
2. There are `π ∈ Sₙ`, `g ∈ GL_r(K)` and `μ ∈ (K^×)ⁿ` with `g hⱼ = μⱼ h'_{π(j)}` for all `j`.
3. There is `g ∈ PGL_r(K)` with `g(𝒫(H)) = 𝒫(H')` as unordered point sets.

### Proof

**(2) ⟹ (1)** — the direction the manuscript gives. Assume `g hⱼ = μⱼ h'_{π(j)}`. Let `c ∈ C` and
define `c'_{π(j)} = μⱼcⱼ`. Then
```
Σᵢ c'ᵢ h'ᵢ = Σⱼ c'_{π(j)} h'_{π(j)} = Σⱼ μⱼcⱼ · μⱼ⁻¹ g hⱼ = g( Σⱼ cⱼhⱼ ) = 0,
```
so `c' ∈ C'`. The map `c ↦ c'` is monomial, hence injective, and `dim C = dim C' = n − r`, so it is
an isomorphism onto `C'`. Note that `g` disappears from the monomial map itself; it only certifies
the column relation.

**(1) ⟹ (2)** — the direction the manuscript omits, and the one that carries the coding-to-geometry
half of the abstract. Two observations.

*Duals of monomially equivalent codes are monomially equivalent, with inverted scalars.* If
`c'_{π(j)} = λⱼcⱼ` defines a bijection `C → C'`, then `u'_{π(j)} = λⱼ⁻¹uⱼ` maps `C^⊥` into `C'^⊥`,
since `Σᵢ u'ᵢc'ᵢ = Σⱼ λⱼ⁻¹uⱼ · λⱼcⱼ = Σⱼ uⱼcⱼ = 0`; it is injective and the dimensions agree, so it
is onto.

*Equal row spaces means a left `GL_r` factor.* `C^⊥` is the row space of `H`, of dimension `r`
because `H` has rank `r`; likewise for `H'`. If `M, M' ∈ K^{r×n}` have rank `r` and the same row
space, then `M' = gM` for a unique `g ∈ GL_r(K)`: each row of `M'` is a combination of rows of `M`,
giving `M' = gM` with `g ∈ K^{r×r}`, and `g` is invertible because `M'` has rank `r`.

Now apply both. From (1), `C'^⊥` is the image of `C^⊥ = rowspace(H)` under the monomial map
`(π, λ⁻¹)`, which is the row space of the matrix `H̃` with columns `h̃_{π(j)} = λⱼ⁻¹hⱼ`. Also
`C'^⊥ = rowspace(H')`. Both `H̃` and `H'` have rank `r`, so `H' = g⁻¹H̃` for some `g ∈ GL_r(K)`,
i.e. `h'_{π(j)} = g⁻¹(λⱼ⁻¹hⱼ)`, i.e. `g hⱼ = λⱼ h'_{π(j)}`. That is (2) with `μ = λ`. ∎

**(2) ⟹ (3)** is immediate: the projectivity of `g` carries `[hⱼ]` to `[h'_{π(j)}]`, so it maps
`𝒫(H)` onto `𝒫(H')`.

**(3) ⟹ (2)** is where admissibility is used. Given `g` with `g(𝒫(H)) = 𝒫(H')`, both sets have
exactly `n` elements — this is where pairwise non-proportionality of the columns enters — so `g`
induces a bijection between them, hence a permutation `π ∈ Sₙ` with `g([hⱼ]) = [h'_{π(j)}]`, hence
scalars `μⱼ ∈ K^×` with `ghⱼ = μⱼh'_{π(j)}` once matrix representatives are chosen. ∎

### 2.2 Where the hypotheses are really needed

- **Nothing in Theorem 2.1 uses MDS, redundancy three, or an arc.** It holds for any two full-rank
  parity-check matrices with pairwise non-proportional columns, over any field. The manuscript can
  therefore state it once, in that generality, and apply it at `r = 3`, `n = 6`.
- **Pairwise non-proportionality is not decorative.** If two columns were proportional, `𝒫(H)` would
  lose a point and (3) would compare sets of different sizes from the underlying multisets;
  (3) ⟹ (2) fails. The correct general statement replaces `𝒫(H)` by the multiset of column points.
  For an arc this distinction is empty, which is why the manuscript may keep the set formulation —
  but the arc hypothesis should be cited at that spot rather than left implicit.
- **The permutation is not free.** In (1) ⟹ (2) the permutation and the scalars produced are exactly
  those of the monomial equivalence, so the correspondence is functorial: it sends the monomial
  automorphism group `MAut(C)` onto the setwise projective stabilizer of `𝒫(H)`, with kernel the
  global scalars. That is Proposition 8 of `notes/2026-08-03-c855-support-bipartition-proofs.md`,
  which is thus a corollary of Theorem 2.1 rather than a separate argument.

### 2.3 Formalization shape

Statement over an arbitrary field, arbitrary `r ≤ n`, with `Matrix (Fin r) (Fin n) K`. Suggested
shape:

```
theorem monomialEquiv_iff_projectiveEquiv
    (H H' : Matrix (Fin r) (Fin n) K)
    (hH : H.rank = r) (hH' : H'.rank = r)
    (hcol : PairwiseNonProportional H) (hcol' : PairwiseNonProportional H') :
    MonomialEquiv (ker H) (ker H') ↔
      ∃ g : GL (Fin r) K, ∃ π : Equiv.Perm (Fin n), ∃ μ : Fin n → Kˣ,
        ∀ j, g.1.mulVec (H.col j) = μ j • H'.col (π j)
```

Remaining finite pieces: **none**; the whole target is linear algebra. Library inputs: row space of a
matrix and its dimension, `rank`, and the lemma "two rank-`r` matrices with the same row space differ
by a left invertible factor", which may need to be proved locally (it is four lines from
`Submodule.span` equality and injectivity of `Matrix.vecMul` on a basis). Dual codes and monomial
maps must be defined in the development if they are not already present; both are one-liners.

**Verdict: proved**, both directions, in strictly greater generality than the paper needs. The
converse direction — that monomially equivalent codes have projectively equivalent column point sets
— is new relative to the manuscript, and it is the direction the abstract's coding formulation
actually requires.

---

## Target 3 — the Davydov–Marcugini–Pambianco syndrome-weight dictionary, as a theorem

### Statement

**Theorem 3.1.** Let `K` be a field, `n ≥ 3`, and let `H ∈ K^{3×n}` have columns `h₁,…,hₙ` such that
every three of them are linearly independent — that is, `A = {[h₁],…,[hₙ]}` is an arc of `n` points
in `PG(2,K)`. Let `C = ker H` and let `s ∈ K³`. Then

```
w(s) = 0   ⟺ s = 0,
w(s) = 1   ⟺ [s] ∈ A,
w(s) = 2   ⟺ [s] lies on a chord of A but [s] ∉ A,
w(s) = 3   ⟺ [s] ∈ 𝒰(A),
```
and `w(s) ≤ 3` for every `s`. Consequently `w` is finite and takes only the values `0,1,2,3`.

*Proof.* The basic reformulation is that `w(s)` is the least `m` such that `s` lies in the span of
some `m` columns: an error vector `e` with `Heᵀ = s` and `wt(e) = m` is precisely a way of writing
`s = Σ_{j ∈ S} eⱼhⱼ` with `|S| = m` and all `eⱼ ≠ 0`, and any expression of `s` in the span of `m`
columns yields such an `e` after discarding zero coefficients. So

```
w(s) = min { |S| : s ∈ span{ hⱼ : j ∈ S } }.
```

Every two columns are independent: a dependent pair extends, using `n ≥ 3`, to a dependent triple,
contradicting the arc hypothesis. Hence for `i ≠ j` the span of `hᵢ, hⱼ` is two-dimensional, i.e. the
chord `[hᵢ][hⱼ]`, and for each `j` the span of `hⱼ` is the point `[hⱼ]`.

- `w(s) = 0` iff `s = 0` by definition (empty span).
- `w(s) ≤ 1` iff `s ∈ K hⱼ` for some `j`, i.e. `s = 0` or `[s] ∈ A`.
- `w(s) ≤ 2` iff `s` lies in the span of two columns, i.e. `s = 0` or `[s]` lies on a chord of `A`
  (points of `A` lie on chords, since `n ≥ 3`).
- `w(s) ≤ 3` always: some three columns are independent, hence a basis of `K³`.

Subtracting the successive statements gives the four displayed equivalences, and the last line is
`𝒰(A)` by definition. ∎

**Remark 3.2 (general redundancy).** The same proof gives the redundancy-`r` statement verbatim: for
an MDS code of redundancy `r`, `w(s)` is the least number of parity-check columns whose span contains
`s`, so `w(s) = m` for `m < r` exactly when `[s]` lies on an `(m−1)`-flat spanned by `m` columns and
on no smaller one, and `w(s) = r` exactly when `[s]` lies on no hyperplane spanned by `r−1` columns.
This is the form in which the manuscript's introduction states the dictionary, and the `r = 3` case
is the trichotomy above. Nothing in the proof is specific to finite fields.

**Remark 3.3 (extension reading).** `[s] ∈ 𝒰(A)` says exactly that `A ∪ {[s]}` is again an arc — a
new point is arc-compatible iff it lies on no chord and is not already a vertex — which is the
manuscript's "adjoining `x` as a seventh column preserves the MDS property". So the extension locus
and the weight-three locus are the same object for a trivial reason, and the sentence needs no
citation.

### 3.4 Formalization shape

```
theorem syndromeWeight_trichotomy (H : Matrix (Fin 3) (Fin n) K) (harc : IsArcColumns H)
    (s : K³) :
    (w H s = 1 ↔ s ≠ 0 ∧ ∃ j, ∃ c ≠ 0, s = c • H.col j) ∧ …
```
Quantification: arbitrary field, arbitrary `n ≥ 3`. Remaining finite pieces: none. The only
nontrivial ingredient is the reformulation `w(s) = min{|S| : s ∈ span}`, which is a `Finset.min'`
manipulation, plus "every two columns independent" from the arc hypothesis. Library inputs:
`Submodule.span`, `Finset.min'`, and the development's arc predicate.

**Verdict: proved**, for every field and every redundancy-three MDS code, with the general-redundancy
version obtained by the same argument. The Davydov–Marcugini–Pambianco citation can be demoted to an
attribution remark; the leader count (Theorem 6.3 in that paper) was already discharged as
Proposition 6 of `notes/2026-08-03-c855-support-bipartition-proofs.md`, so with Theorem 3.1 the whole
dictionary transfer is closed.

---

## Target 4 — uniqueness of the one-factorization of `K₆`

The manuscript uses this inside `lem:six-arc-line-bound` to normalize three factors to
`01|23|45`, `02|14|35`, `03|15|24`, and cites Mendelsohn–Rosa. The proof below is self-contained,
elementary, and produces the normalization explicitly together with the count of one-factorizations.

### 4.1 Two lemmas

**Lemma 4.1 (hexagon).** Two disjoint perfect matchings of `K₆` have union a six-cycle.

*Proof.* The union is two-regular on six vertices, so a disjoint union of cycles of even length at
least four (length two would be a repeated edge). The only such partition of six is a single
six-cycle. ∎

**Lemma 4.2 (contracted triangle).** Fix a perfect matching `F = {A, B, C}` of `K₆`, viewed as three
disjoint pairs `A = {a₀,a₁}`, `B = {b₀,b₁}`, `C = {c₀,c₁}`. A perfect matching `F'` is disjoint from
`F` if and only if it has exactly one edge in each of `A×B`, `B×C`, `A×C`; there are exactly eight
such `F'`, and they are parametrized bijectively by triples `(i,j,k) ∈ (Z/2)³` through
```
F'(i,j,k) = { aᵢbⱼ, a_{i+1}c_k, b_{j+1}c_{k+1} }.
```

*Proof.* A matching disjoint from `F` uses no edge inside a pair, so all three of its edges cross,
and by Lemma 4.1 its union with `F` is a hexagon; contracting each pair of `F` to a node turns `F'`
into a two-regular graph on three nodes, that is a triangle, so `F'` has one edge between each two
pairs. Conversely such an `F'` is a perfect matching disjoint from `F`. For the parametrization:
choose the `A–B` edge as `aᵢbⱼ` (four ways); the `A–C` edge must use the unused `A`-vertex
`a_{i+1}` and some `c_k` (two ways); the `B–C` edge is then forced to be `b_{j+1}c_{k+1}`. Hence
eight matchings. (Cross-check by inclusion–exclusion: of the fifteen perfect matchings of `K₆`,
those meeting `F` number `3+3+3−3+1 = 7`, leaving eight.) ∎

**Lemma 4.3 (disjointness is Hamming distance).** `F'(i,j,k)` and `F'(i',j',k')` are disjoint if and
only if `(i,j,k)` and `(i',j',k')` differ in at least two coordinates.

*Proof.* The two matchings share their `A–B` edge iff `(i,j) = (i',j')`, share their `A–C` edge iff
`(i,k) = (i',k')`, and share their `B–C` edge iff `(j,k) = (j',k')`; these are the only possible
coincidences, since edges in different cross-classes are distinct. So the matchings meet iff some
two of the three coordinates agree simultaneously with the other triple, i.e. iff the triples agree
in at least two coordinates, i.e. iff their Hamming distance is at most one. ∎

### 4.2 The theorem

**Theorem 4.4.** `S₆` acts transitively on the one-factorizations of `K₆`. There are exactly six of
them, the stabilizer of one has order `120`, and every one-factorization can be relabelled to
```
01|23|45,   02|14|35,   03|15|24,   04|13|25,   05|12|34.
```

*Proof.* Let `𝒯 = {F₁,…,F₅}` be a one-factorization. `S₆` is transitive on the fifteen perfect
matchings — a matching is a partition of the six vertices into three pairs, and `S₆` is transitive on
such partitions — so after relabelling we may assume `F₁ = {A,B,C}` with `A = \{0,1\}`,
`B = \{2,3\}`, `C = \{4,5\}`, that is `F₁ = 01|23|45`.

The remaining four factors are pairwise disjoint and disjoint from `F₁`, so by Lemma 4.2 they are
`F'(t)` for four triples `t ∈ (Z/2)³`, and by Lemma 4.3 those four triples have pairwise Hamming
distance at least two. A subset `S ⊂ (Z/2)³` with `|S| = 4` and minimum distance two must be a parity
class: puncturing the last coordinate is injective on `S` (two triples agreeing in the first two
coordinates are at distance at most one), hence bijective onto `(Z/2)²` by cardinality, so
`S = {(u₁,u₂,f(u₁,u₂))}` for a function `f`; and `f` must differ at any two arguments differing in
one coordinate, i.e. `f` is a proper two-colouring of the four-cycle `Q₂`, so
`f(u₁,u₂) = u₁ + u₂ + ε` for one of the two constants `ε ∈ Z/2`. Conversely each parity class
consists of four pairwise-disjoint matchings whose twelve edges are all twelve cross edges (each of
the three cross-classes receives one edge per factor and has four edges), so together with `F₁` it is
a one-factorization.

So exactly two one-factorizations contain `F₁`, distinguished by `ε`, and the transposition `(0 1)`
fixes `F₁` and flips `i`, hence flips `ε` and exchanges them. Therefore `S₆` is transitive on
one-factorizations. Counting incidences `(F, 𝒯)` with `F ∈ 𝒯`: there are `15 · 2 = 30` such pairs and
each `𝒯` contributes five, so there are `30/5 = 6` one-factorizations, and the stabilizer of one has
order `720/6 = 120`. Finally the class `ε = 0` is, in the labelling above, the list displayed in the
statement: `F'(0,0,0) = 02|14|35`, `F'(0,1,1) = 03|15|24`, `F'(1,1,0) = 04|13|25`,
`F'(1,0,1) = 05|12|34`. ∎

### 4.3 Relation to the concurrence machinery, and what else this closes

- The proof is deliberately not routed through the outer automorphism, because it *produces* the
  six-element `S₆`-set on which the outer automorphism is defined. Given Theorem 4.4, the action of
  `S₆` on the six one-factorizations is transitive with point stabilizer of order `120` and is
  faithful (the kernel is a normal subgroup of `S₆` inside the stabilizer of every one-factorization;
  it is contained in the pointwise stabilizer of `F₁`'s parity classes, hence trivial by direct
  check), which is the exotic degree-six action underlying the outer automorphism. The concurrence
  equivalence of `notes/2026-08-03-c855-dye-orbit-uniqueness.md` is stated on exactly this six-element
  set, so Theorem 4.4 is a prerequisite of that machinery rather than a consequence, and using the
  machinery to prove it would be circular.
- Theorem 4.4 also supplies, retroactively, the input asserted without proof in Proposition 7 of
  `notes/2026-08-03-c855-support-bipartition-proofs.md` ("the full symmetric group of degree six acts
  transitively on the six one-factorizations of `K₆`, so the stabilizer of `𝒯` has order `720/6 =
  120`"). That step is now proved rather than assumed.
- The `Q₂`-colouring step is the same two-valued parity phenomenon that appears in the
  pentagon/pentagram dichotomy of Target 2 in the orbit-classification note and in the golden-root
  dichotomy of the Dye note: an index-two choice with the two options exchanged by an odd
  permutation. Here the odd permutation is the transposition `(0 1)`.

### 4.4 Formalization shape

```
theorem oneFactorization_unique
    (𝒯 𝒯' : Finset (Finset (Sym2 (Fin 6)))) (h : IsOneFactorization 𝒯)
    (h' : IsOneFactorization 𝒯') :
    ∃ σ : Equiv.Perm (Fin 6), 𝒯' = 𝒯.image (relabel σ)
theorem oneFactorization_card : (allOneFactorizations).card = 6
```

Two viable routes.

| route | remaining finite piece | size |
|---|---|---|
| structural (above) | the eight matchings of Lemma 4.2 and the parity-class classification | `2³` cases twice; trivial |
| brute force | enumerate the fifteen matchings, form all one-factorizations, check `S₆`-transitivity | `720 × 6` incidences, `decide`-scale |

The brute-force route is entirely feasible and is the cheaper Lean path; the structural proof is what
the manuscript should carry, because it yields the explicit normalization used in
`lem:six-arc-line-bound` and the count six without a search. Recommended: prove Lemma 4.2 and
Lemma 4.3 by hand, then discharge the parity-class classification either by the `Q₂`-colouring
argument or by `decide` over the seventy subsets of size four.

**Verdict: proved**, self-contained, with the normalization and the count six as by-products; the
Mendelsohn–Rosa citation can become an attribution.

---

## Target 5 — the coset-leader and covering-radius layer

### 5.1 Coset distance equals syndrome weight

**Lemma 5.1.** For any linear code `C = ker H` over `K` and any `v ∈ Kⁿ`,
`d(v, C) = w(σ(v))` where `σ(v) = Hvᵀ`.

*Proof.* `d(v,C) = min_{c ∈ C} wt(v − c)`. As `c` runs over `C`, `e = v − c` runs over exactly the
set `{ e : Heᵀ = Hvᵀ }`, because `H(v−c)ᵀ = Hvᵀ` for `c ∈ C` and conversely `Heᵀ = Hvᵀ` gives
`v − e ∈ ker H = C`. So the two minima are over the same set of weights. ∎

Consequently `ρ(C) = max_v d(v,C) = max_s w(s)`, the maximum over syndromes; the coset of `v` is
determined by `σ(v)`; its *leaders* are the weight-`w(σ(v))` members; and `w(λs) = w(s)` for
`λ ∈ K^×` because scaling an error scales its syndrome and preserves weight. Hence the deep-hole
locus is well defined projectively:
```
𝒟_proj(C) = { [s] ∈ PG(n−k−1, K) : w(s) = ρ(C) }.
```
Nothing here needs MDS, arcs, or finiteness of the field beyond `max` existing, which holds because
`w` takes values in `{0,…,n}`.

### 5.2 The general implication the abstract needs

**Theorem 5.2.** Let `A = {[h₁],…,[hₙ]}` be an arc of `n ≥ 3` points in `PG(2,K)` and `C = ker H` the
associated redundancy-three code. If `𝒰(A) ≠ ∅` then
```
ρ(C) = 3   and   𝒟_proj(C) = 𝒰(A).
```
If `𝒰(A) = ∅` then `ρ(C) = 2` provided some point of the plane lies on a chord but off `A`, and
`𝒟_proj(C)` is that set.

*Proof.* By Theorem 3.1, `w` takes the value `3` exactly on `𝒰(A)` and never exceeds `3`. If
`𝒰(A) ≠ ∅` then the maximum value `3` is attained, so `ρ(C) = 3` by Lemma 5.1, and
`𝒟_proj(C) = {[s] : w(s) = 3} = 𝒰(A)`. If `𝒰(A) = ∅` then `w ≤ 2` everywhere and the same reading
applies one level down. ∎

This is exactly the manuscript's introduction sentence "*if `𝒰(A) ≠ ∅`, then the associated code has
covering radius three and `𝒰(A) = 𝒟_proj(C)`*", which the inventory records as formalized only for
the displayed witness (`Q11Coding.witness_code_coveringRadius_three`,
`Q11Coding.projective_distanceThreeDirections_eq_standardConic`). It now holds for every arc over
every field, and `prop:deep-holes-conic` becomes the specialization at the Clebsch hexagon: the
exteriority of the fifteen chords gives `𝒞(F₁₁) ⊆ 𝒰(A)`, the chord-defect count gives
`|𝒰(A)| = 12 = |𝒞(F₁₁)|`, hence equality, and Theorem 5.2 converts that into the covering-radius and
deep-hole statements with no further input.

### 5.3 Formalization shape

Lemma 5.1 is a two-line `Finset` bijection and should be stated for an arbitrary linear code over an
arbitrary field; it is the missing formal definition layer that the inventory row "the coset-leader
definition of a deep hole, the syndrome weight function, and the identity between coset distance and
syndrome weight" asks for. Theorem 5.2 is then a corollary of Theorem 3.1 with no finite content.
Remaining finite pieces: none. The existing `q = 11` terminals become instances.

**Verdict: proved**, in full generality; the abstract's coding layer is self-contained once
Lemma 5.1, Theorem 3.1 and Theorem 5.2 are in the development.

---

## Target 6 — the dual-GRS / normal-rational-curve clause

### What is needed

The manuscript argues: the six columns lie on no conic, the dual of a GRS code is GRS, and the
parity-check column system of a `[6,3]` GRS code lies on a normal rational curve — a conic in the
plane — so `C` is not monomially equivalent to a GRS code. The transfer is Storme–Thas. The clause
needed is much smaller than the general normal-rational-curve dictionary, and it can be proved
outright by one Lagrange identity.

### 6.1 Parity-check columns of a `[6,3]` GRS code lie on a conic

Fix distinct `a₁,…,a₆ ∈ K` and nonzero `v₁,…,v₆`, and let
```
GRS₃(a,v) = { ( v₁f(a₁), …, v₆f(a₆) ) : f ∈ K[X], deg f < 3 },
```
a `[6,3]` MDS code with generator matrix `G` whose `j`-th column is `vⱼ(1, aⱼ, aⱼ²)ᵀ`.

**Lemma 6.1 (Lagrange vanishing).** With `wⱼ = ∏_{i ≠ j}(aⱼ − aᵢ)⁻¹`, one has
`Σⱼ wⱼ aⱼᵗ = 0` for `0 ≤ t ≤ 4` and `Σⱼ wⱼ aⱼ⁵ = 1`.

*Proof.* For `deg p ≤ 5`, Lagrange interpolation at the six nodes gives
`p(X) = Σⱼ p(aⱼ) ∏_{i≠j}(X − aᵢ)/(aⱼ − aᵢ)`, and comparing the coefficient of `X⁵` gives
`[X⁵]p = Σⱼ wⱼ p(aⱼ)`. Taking `p = Xᵗ` gives `0` for `t ≤ 4` and `1` for `t = 5`. ∎

**Proposition 6.2.** The matrix `H` with columns `hⱼ = (wⱼ/vⱼ)(1, aⱼ, aⱼ²)ᵀ` is a parity-check matrix
for `GRS₃(a,v)`, and its six column points lie on the nonsingular conic `Y² = XZ`.

*Proof.* `H Gᵀ` has `(m,l)` entry `Σⱼ (wⱼ/vⱼ)aⱼᵐ · vⱼaⱼˡ = Σⱼ wⱼ aⱼ^{m+l}` with `m,l ∈ {0,1,2}`, so
`m + l ≤ 4` and every entry vanishes by Lemma 6.1. `H` has rank three, its rows being a Vandermonde
system in the distinct `aⱼ` scaled by nonzero factors, so its row space is exactly the dual of the row
space of `G`. Each column point is `[1 : aⱼ : aⱼ²]`, which satisfies `Y² = XZ`. ∎

The doubly extended case, where one evaluation point is `∞` and the corresponding generator column is
`vⱼ(0,0,1)ᵀ`, is covered by the same computation with the convention that the `∞`-column of `H` is
`(1,0,0)ᵀ` up to scalar; both `[0:0:1]` and `[1:0:0]` lie on `Y² = XZ`, which is the full normal
rational curve of the plane. So in all cases the parity-check column points of a `[6,3]` GRS or
extended GRS code lie on a nonsingular conic.

### 6.2 The clause

**Theorem 6.3.** Let `C = ker H` be a `[6,3]` MDS code over `K` whose six parity-check column points
lie on no conic. Then `C` is not monomially equivalent to any GRS or extended GRS code.

*Proof.* Suppose `C` is monomially equivalent to `GRS₃(a,v)`. By Theorem 2.1 ((1) ⟹ (3)) their
parity-check column point sets are projectively equivalent, so `𝒫(H) = g(𝒫(H_GRS))` for some
`g ∈ PGL₃(K)`. By Proposition 6.2 `𝒫(H_GRS)` lies on the conic `Y² = XZ`, so `𝒫(H)` lies on the conic
`g(Y² = XZ)`, contradicting the hypothesis. ∎

For the displayed code the hypothesis is the manuscript's own nonsingular-minor computation: the
`6 × 6` evaluation matrix of the six columns against the six quadratic monomials
`X², XY, XZ, Y², YZ, Z²` is nonsingular, which says exactly that no nonzero quadratic form vanishes
on all six columns.

### 6.3 The converse, for free

**Theorem 6.4.** Conversely, if the six parity-check column points of a `[6,3]` MDS code lie on a
nonsingular conic with a rational point, then `C` is monomially equivalent to an extended GRS code.

*Proof.* A nonsingular conic with a rational point is projectively equivalent to `Y² = XZ` (project
from the rational point), so after a projectivity the columns are `uⱼ(1,aⱼ,aⱼ²)ᵀ` with distinct `aⱼ`,
allowing one `aⱼ = ∞`. Running Proposition 6.2 backwards — solve `wⱼ/vⱼ = uⱼ`, which determines
`vⱼ ≠ 0` since `wⱼ ≠ 0` — exhibits `C` as `GRS₃(a,v)` up to the projectivity, hence up to monomial
equivalence by Theorem 2.1 ((3) ⟹ (1)). ∎

So the paper's clause is one half of a clean two-way criterion: **for a `[6,3]` MDS code, being
GRS up to monomial equivalence is exactly the condition that the six parity-check column points lie
on a conic.** That is the normal-rational-curve dictionary in the only instance the paper uses, and
it is now proved rather than transferred.

### 6.4 Formalization shape

Quantification: arbitrary field with at least six elements (for six distinct evaluation points);
`n = 6`, `k = 3`. Statements:

```
theorem grs_parityCheck_on_conic : ∀ j, (H_GRS.col j) ∈ conicYsqXZ
theorem not_monomialEquiv_grs_of_no_conic (h : ∀ Q ≠ 0, ∃ j, Q (H.col j) ≠ 0) : ¬ ∃ a v, MonomialEquiv (ker H) (GRS 3 a v)
```

| remaining finite piece | size |
|---|---|
| Lemma 6.1 | Lagrange interpolation at six nodes; Mathlib has `Lagrange.interpolate` and `Matrix.det_vandermonde` |
| `H Gᵀ = 0` | nine sums, each an instance of Lemma 6.1 |
| the displayed code's nonsingular `6 × 6` minor | one determinant over `ZMod 11`, `decide`-scale |
| the extended case | one extra column, handled by the same identity |

**Verdict: proved**, and upgraded: the clause is one direction of a two-way criterion whose converse
costs only the standard normalization of a conic with a rational point. The Storme–Thas transfer is
no longer needed for Paper I.

---

## What the six targets remove from the gap ledger

Against `notes/2026-08-02-c855-paper-i-assertion-inventory.md`:

- Part A, "Abstract and introduction": the orbit-under-the-conic-stabilizer row (Target 1), the
  projective-equivalence-equals-monomial-equivalence row (Target 2), the
  Davydov–Marcugini–Pambianco syndrome-weight row (Target 3), the coset-leader/syndrome-weight
  definitional row and the general covering-radius implication row (Target 5) are all closed by
  paper-grade proofs valid over arbitrary fields.
- Part A, "The rigidity theorem and the field window": the `K₆` one-factorization uniqueness transfer
  (Target 4) is closed.
- Part A, "The code and its projective syndrome locus": the normal-rational-curve/GRS dictionary
  transfer (Target 6) is closed, and its converse is obtained.
- Part D: five of the eighteen listed external dependencies — Bézout's bound on two conics, the
  Davydov–Marcugini–Pambianco dictionary (its leader half was already closed in
  `notes/2026-08-03-c855-support-bipartition-proofs.md`), the uniqueness of the one-factorization of
  `K₆`, and the Storme–Thas normal-rational-curve dictionary — no longer need an import or an audit.

Not removed here: the Hirschfeld nucleus theorem, the Blokhuis–Brouwer–Szőnyi covering bound, the
Blokhuis–Seress–Wilbrink exterior-set characterization, the Storme–Van Maldeghem classification
entry, the Hassett–Tschinkel determinantal equivalence, Segre's lemma of tangents, and the
companion's Sylvester/association-scheme transfers.

## Closeout pass (`ej` + `tt`)

Free upgrades taken in the text above rather than deferred:

- The five-point interpolation lemma repairs a **second** Bézout appeal, inside the proof of
  `thm:rigidity` itself, and in a shorter form than the manuscript's (Section 1.4).
- Theorem 2.1's omitted direction turns out to imply the monomial-automorphism extension sequence of
  the support-bipartition note, so that proposition can be restated as a corollary (Section 2.2).
- Theorem 3.1 makes the "extension point equals weight-three direction" sentence a tautology rather
  than a citation (Remark 3.3), and its redundancy-`r` form covers the manuscript's general
  introduction sentence, not only the plane case.
- Theorem 4.4 supplies an input that the support-bipartition note had used without proof, and it
  produces the exotic degree-six `S₆`-set on which the whole concurrence machinery is indexed.
- Target 6 was requested only "if cheap"; it turned out to be cheap **and** two-way, so the
  criterion is stated as an equivalence.

What a Tao-style reading asks that the manuscript does not: *which of these statements are really
about `q = 11`, and which are about arcs?* The answer, now visible, is that Targets 2, 3, 5 and 6 are
field-generic and arc-generic; Target 1 is field-generic once transitivity is supplied; Target 4 is
pure combinatorics. Only the transitivity input to Target 1 (`thm:rigidity`) is genuinely
order-eleven. The manuscript would read better with the generic statements stated generically and the
order-eleven specialization isolated, which is also exactly the shape the Lean development wants.

## Mystery ledger

- *Why does the manuscript's clause need Bézout at all?* Settled: it does not. The only intersection
  fact used is that five points of a nonsingular conic are in general position and determine the
  conic, which is a rank statement about a `5 × 6` evaluation matrix. Bézout is the right tool for
  two curves of arbitrary degree; for conics it is overkill and, in a formal artifact, an expensive
  import that would have to be built from scratch.
- *Is the set-versus-multiset issue in Target 2 ever real for this paper?* Settled: no, because the
  columns of an MDS code of redundancy at least two are pairwise non-proportional. But the manuscript
  states the dictionary for "unordered parity-check column sets" without saying where distinctness
  comes from, and the statement is false for a general code, so the arc hypothesis must be named at
  that spot. Actionable and cheap; it is a one-clause manuscript repair.
- *Why is there exactly a two-fold choice in Theorem 4.4, and is it the same two-fold choice as
  elsewhere in Paper I?* Partly settled. Given `F₁`, the extensions to a one-factorization are the two
  parity classes of `(Z/2)³`, exchanged by an odd permutation of the six vertices. This is formally
  the same index-two pattern as the golden-root dichotomy `{φ, φ̄}` in
  `notes/2026-08-03-c855-dye-orbit-uniqueness.md` and the pentagon/pentagram dichotomy in
  `notes/2026-08-03-c855-orbit-classification-proofs.md`, and in all three the index-two subgroup is
  the even part. Whether the three parameter maps are literally the same map, transported, was not
  checked here and is the same evidence gap already recorded in the orbit-classification note. No
  owning successor; recorded as a descriptive question.
- *Does the syndrome-weight trichotomy have any content beyond the span reformulation?* Settled: no.
  Once `w(s)` is rewritten as the least number of columns whose span contains `s`, the trichotomy is
  the definition of arc, chord, and uncovered locus. The reason it reads as a theorem in the
  literature is that it is usually stated together with the leader counts, which are genuinely
  arithmetic; those were closed separately.
- *Why does the GRS criterion come out as an exact equivalence at `[6,3]` and not merely an
  implication?* Settled up to one normalization: because `n = 2k` makes the parity-check column
  system of a GRS code again a normal rational curve of the same degree, so the conic condition is
  self-dual. At `n ≠ 2k` the dual normal rational curve lives in a different-dimensional space and
  the criterion is no longer a plane-conic condition. The remaining input is that a nonsingular conic
  with a rational point is projectively standard, which is classical and elementary but was not
  written out here. Evidence gap: that normalization lemma; it is needed only for the converse
  (Theorem 6.4), not for the clause Paper I uses.
- *Open:* whether Theorem 1.5 can be upgraded from "`PGL`-equivalent implies `Stab(𝒞)`-equivalent" to
  an unconditional orbit statement over general odd `q`. That would require the analogue of
  `thm:rigidity` at other orders, which the companion note shows fails already at `q = 19` (the
  uncovered locus there has one hundred forty points against a conic of twenty). So the conditional
  form is the right general statement, and the unconditional one is genuinely order-eleven.

## Computational corroboration (not the deliverable)

`notes/2026-08-03-c855-coding-dictionary-checks.py` checks every finite clause above.

```
python3 notes/2026-08-03-c855-coding-dictionary-checks.py
```

It verifies, over `F₁₁` and the manuscript's displayed parity-check matrix unless stated otherwise:
the five-point interpolation lemma (for every five points of the standard conic with no three
collinear, the space of quadratic forms vanishing on them is one-dimensional, and that all one
hundred sixty thousand nine hundred thirty nonsingular conics up to scalar have pairwise distinct
rational point sets, which is the sharp form of Corollary 1.3 at this order); that the uncovered
locus of the displayed arc is the twelve-point conic and that every one of the sixty projectivities
carrying the arc to itself stabilizes that conic; the syndrome-weight trichotomy for all one hundred
thirty-three projective directions, with the split `6` of weight one, `115` of weight two and `12` of
weight three, together with the coset-distance identity on a sample of received words against all one
thousand three hundred thirty-one codewords; the covering radius three and the equality of the
deep-hole locus with the uncovered locus; that there are exactly six one-factorizations of `K₆`, that `S₆` is transitive on
them with stabilizer of order one hundred twenty, that exactly two extend the matching `01|23|45`,
that they are the two parity classes of the `(Z/2)³` parametrization and are exchanged by the
transposition `(0 1)`, and that the even class is the manuscript's displayed list; the Lagrange
vanishing identity and the fact that the parity-check columns of a `[6,3]` GRS code over `F₁₁` lie on
`Y² = XZ` for random evaluation points and multipliers; and that the displayed code's six columns lie
on no conic, the `6 × 6` quadratic-monomial evaluation matrix being nonsingular.

## What this record does not establish

No Lean file was edited, no Lean build, generator, gate, or manifest was run, and no manuscript text
was changed. The six results are paper-grade human proofs and have not been formalized; the
manuscript still carries the Bézout appeal, the one-directional monomial-equivalence sentence, the
Davydov–Marcugini–Pambianco and Mendelsohn–Rosa and Storme–Thas citations, and the covering-radius
implication in its introduction-prose form.
