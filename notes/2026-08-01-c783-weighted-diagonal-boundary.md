# C783 — weighted diagonal boundary

**Lane:** `ame-lu`

**Status:** active; the original weighted-enumerator route is substantially
pre-empted, while the mixed-residue equal-phase CSS boundary remains open.

## 2026-08-02 scope correction

The transversal-`T` plateau does not automatically answer the full diagonal
question.  For a binary code `C ≤ F₂ⁿ`, an order-eight diagonal symmetry of
the equal-phase state `|C⟩` is exactly a vector

```text
t ∈ (Z/8Z)ⁿ,   t · x = 0 (mod 8) for every x ∈ C,
```

with at least one odd coordinate.  The all-ones choice is the triply-even
sector treated by C778--C780; C783 allows all eight coordinate residues.

For a rank-`k` generator matrix with nonzero column types `v ∈ F₂ᵏ`, the exact
fixed-dimension formulation has binary selection variables `y_v`, residue
variables `t_v ∈ {0,…,7}` with `t_v = 0` when `y_v = 0`, and the congruences

```text
Σ_{v : u·v=1} t_v = 0 (mod 8)       for every u ∈ F₂ᵏ.
```

Dual distance at least five says that the selected columns have no zero,
repeat, three-term dependence, or four-term dependence; equivalently, they
form a Sidon set in the additive group of `F₂ᵏ`.  Exact order eight is
`t_v` odd for at least one selected `v`.  This column-type system is the right
finite object.  An ordinary one-variable weight enumerator loses the residue
placement and cannot decide it.

Reducing the displayed congruences modulo two gives a useful structural
compression.  If `p_v = t_v mod 2`, then

```text
p ∈ (C^{∘3})⊥.
```

Thus the odd-support columns carry an even triorthogonal restriction.  This is
necessary, not sufficient: the even residues on the complementary columns
still participate in the mod-four and mod-eight lifting equations.  In
particular, neither “triorthogonal” nor “triply even on the odd support” may be
substituted for the original mixed-residue equation.

## Prior work read before implementation

Three sources were consulted: one at full-text depth and two partially at the
exact sections used.

| source | read depth | result used |
|---|---|---|
| Rengaswamy, Calderbank, Newman, Pfister, *On Optimality of CSS Codes for Transversal T*, arXiv:1910.09333 | **partial** — arXiv v1, cached as `arXiv:1910.09333`, SHA-256 `2b5be8ac15b7efde1bb7579518d387fd6c1c460f834e3b72489ad431cd1820f3`; read the introduction, QFD setup, Section III-A, Corollary 5, Theorem 6, and the adjacent CSS discussion | arbitrary `T^j` patterns are derived at operator level, but the paper explicitly leaves the general structural conditions open; its code-subspace problem is broader than the equal-phase scalar equation here |
| Nezami and Haah, *Classification of Small Triorthogonal Codes*, arXiv:2107.09684 | **partial** — arXiv preprint, cached as `arXiv:2107.09684`, SHA-256 `b511847558fd583ec422ef6e2a330457b00dd833996676e06c746da044c2765d`; read the main classification statement, Section V, conclusion, and the cited table descriptions | Section V already gives the efficient mod-eight test for level-three divisibility with all coordinate weights odd and proves that triorthogonality alone is not sufficient |
| Baldelli, Mostad, Lin, Rosnes, Battaglioni, *On Constructing and Decoding Quantum Triorthogonal Codes*, arXiv:2605.24519v1 | **full text** — cached as `arXiv:2605.24519`, SHA-256 `cde4400b1a41229b5d2aa1cc1ae2c93897fad27f3716d2c8a93eff5c0e359a70` | Theorem 2 already combines column multiplicities, even triorthogonality, MacWilliams identities, Krawtchouk constraints, and prescribed classical dual distance into an exact fixed-dimension ILP |

The bounded primary-source searches were:

```text
site:arxiv.org triorthogonal codes dual distance 5
site:arxiv.org "even-weight triorthogonal" "dual distance"
site:arxiv.org "triorthogonal" "dual distance" code
```

They located the May 2026 paper above.  This was a prerequisite and
pre-emption check, not a claim that the mixed-residue literature has been
exhausted; no absence or priority verdict is licensed.

## Current verdict

Do not implement the queued “weighted analogue of the Delsarte system” as if
it were new.  Its triorthogonal/MacWilliams core is already Theorem 2 of the
May 2026 paper, and the all-odd mod-eight lift test is already Section V of
Nezami--Haah.  The surviving C783 problem is narrower and sharper:

1. extend those fixed-dimension systems to mixed residues `0,…,7` for the
   equal-phase symmetry equation;
2. eliminate the residue variables structurally, if possible, by proving the
   level-three Smith--Schur lifting statement owned separately by C790; or
3. produce an exact mixed-residue witness with dual distance at least five.

The existing triply-even plateau is therefore **not yet known to survive or
fail** in the full weighted sector.  The C778 certificates cannot be cited for
that statement.  Exploratory exact searches found no compressed
triorthogonal--Sidon shadow in generator dimensions six through eight; the
dimension-nine run did not terminate with a verdict.  These runs are
diagnostic only and are not a certificate or a mathematical claim.

## Next gate

The highest-EV next move is the C790 level-three Smith--Schur equivalence.  If
its converse holds, the mixed-residue variables disappear and C783 becomes
the single finite question whether a dual-distance-five code can have
`C^{∘3} ≠ F₂ⁿ`.  Without that theorem, a fresh C783 implementation must retain
all eight residue classes and must emit independently checkable witnesses or
infeasibility certificates; solver status alone is not evidence.

