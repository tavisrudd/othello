# Source-exactness audit of the imported claims underpinning Hypothesis 4.7H

**Date:** 2026-08-15 · **Lane:** `cubic-threefolds` · **Task:** C912 · **Purpose:**
source-exactness audit of imported claims underpinning Hypothesis 4.7H.

This is a hostile-referee pass. Every claim below was checked against the pinned
source text, not against our own paraphrases. Where our documents and a source
disagree, both are quoted. A separate first-class section (§8) audits silent jumps
between frames, units, gradings, and conventions at every junction where the
evidence chain composes an imported statement with our own argument, or two
imported statements with each other.

Our-side files audited: `notes/2026-08-15-c912-frame-transport-memo.tex` (the memo;
its `\section` "The coalesced block is rigid", which carries equations (8.1)–(8.5),
is what the task calls "our Section 8"),
`papers/cubic-stabilization-m1/sections/04-one-step.tex` (the manuscript),
and, where a claim is repeated, `notes/2026-08-15-c912-kkpy-imports-source-check.md`
and `notes/2026-08-15-c912-det-r-pairing-and-serre-lattice.md`.

## Read depth and access (per `notes/literature-audit-conventions.md`)

**Six of the eight sources named in this report were read at full text or at
substantial partial depth from the actual bytes.** One (van der Put–Singer) was
reachable only through a secondary work; one bibliographic entry was verified from
a consulted source rather than recall.

| Source | Version read | Depth | Cache key | SHA-256 |
|---|---|---|---|---|
| Iritani, *Quantum cohomology of blowups* | arXiv:2307.13555**v3**, 4 Feb 2025 | full text (§1, §5.5, §5.6, §5.7, §5.8, §5.8.1, §5.8.2) | `arXiv:2307.13555` | `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b` |
| Iritani, *Notes on the decomposition theorem for blowups* | arXiv:2604.10028**v2**, 19 Apr 2026 | full text (§1, §2) | `arXiv:2604.10028` | `0114923576b2ec3a78fc346fd9f61eb65cfe63f8cc7087881d11626cdb9883c3` |
| Iritani–Koto, *Quantum cohomology of projective bundles* | arXiv:2307.03696**v4**, 31 Jan 2026 | full text (§1, §2.2, §4.1, §5.1, §5.6, §5.7, §5.8) | `arXiv:2307.03696` | `5139f8e0c9d46f8ccb8cb415396a0fb1fb357719b7dcfbca46234a9735b57624` |
| Cai, *The cubic threefold is symplectically irrational* | arXiv:2608.01577**v1**, 3 Aug 2026 | full text (all 8 pp., re-extracted with `pdftotext -layout` to recover the matrices) | `arXiv:2608.01577` | `06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e` |
| Katzarkov–Kontsevich–Pantev–Yu | arXiv:2508.05105**v2**, 6 Mar 2026 | partial (§3.2 Rem. 3.14, §5.4–§5.6, §6.4–§6.5 incl. Claim 6.15, Ex. 6.17–6.21, Thm 4.11) | `arXiv:2508.05105` | `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64` |
| Hinault–Yu–Zhang–Zhang, *Decomposition and framing of F-bundles…* | arXiv:2411.02266**v2**, 28 Mar 2025 | partial (§2.2.4, §4.4, §5.1–§5.3, Prop. 4.31) | `arXiv:2411.02266` | `a11a093f790890804c7d4f7559b30ed2a6da87811de46f2aa0d29026e343e6bd` |
| Sabbah, *Introduction to Stokes Structures* | arXiv:0912.2762**v5**, 3 Apr 2012 (NOT the published LNM 2060, 2013) | partial (Lecture 5, §5.c, Def. 5.7, Thm 5.8 and its proof, Prop. 5.10; table of contents) | `arXiv:0912.2762` (newly cached by this audit) | `1bc0b14b82757bd41bc6342077b263c08be8a6d97f2697ba1483eea3d3b7e078` |
| van der Put–Singer, *Galois Theory of Linear Differential Equations* | — | **secondary only** (via Cai arXiv:2608.01577v1, read at full text, Remark 5 and reference [17]) | not cached | n/a |

**Version check.** Every pinned version the task named is the version in cache and
the version read: 2307.13555v3, 2604.10028v2, 2307.03696v4, 2608.01577v1,
2508.05105v2. Hinault–Yu–Zhang–Zhang had no pinned version in the task; the cache
holds **v2** and every verdict about it below is a verdict about v2 only. Sabbah was
fetched fresh as **arXiv v5**; the manuscript's bibliography names the published
Lecture Notes in Mathematics 2060 (2013) edition, which was **not** read, so §7's
verdict is about the arXiv version and the section/theorem numbers may differ in the
book.

## Summary table of verdicts

Every finding is keyed to the section that quotes both sides.

| # | Claim (ours) | Verdict |
|---|---|---|
| 1.1 | Iritani Thm 5.18: Ψ an isomorphism of `C[z]((q^{-1/s}))[[Q,τ̃]]`-modules, commuting with the quantum connection, intertwining the pairings | EXACT MATCH (§1.1) |
| 1.2 | Cor. 1.2 preserves Euler vector fields; Ψ transports summand by summand | EXACT MATCH (§1.2) |
| 1.3 | "Iritani's Lemma 5.15 is the formal inverse function theorem at `Q=ϑ=0`, an isomorphism of germs" | **MISMATCH** (§1.3) |
| 1.4 | "Iritani states that the pullback of functions along the change of variables is ill-defined" | **MISMATCH — the source says the opposite, three times** (§1.4) |
| 1.5 | The decomposition is a formal-germ identity, not a family of pointwise statements | EXACT MATCH (§1.5) |
| 1.6 | (5.15) is the centre Novikov specialization `Q_Z^d ↦ Q^{ı_*d} q^{-ρ_Z·d/(r-1)}`, not necessarily injective | EXACT MATCH (§1.6) |
| 1.7 | Rem. 1.3–1.5, Prop. 5.4 with (5.13)–(5.14), Rem. 5.6, §5.8, §5.8.1, §5.8.2 exist and carry the claimed content | EXACT MATCH (§1.7) |
| 1.8 | The change of variables lands in `C((q^{-1/(r-1)}))[[Q]]`; `t` and `s_j` are "of the same shape" | minor MISMATCH of rings (§1.8) |
| 2.1 | Iritani–Koto Thm 5.1(4), (5): the displacement and the invertible Jacobian `λ_j^k(φ_i + O(q^{-1/r}))` | EXACT MATCH (§2.1) |
| 2.2 | (5.13): invertibility in the **displaced** coordinates `s_j` as independent formal variables | EXACT MATCH (§2.2) |
| 2.3 | §5.8's `M`: fundamental solution, `M = id + O(z^{-1})`, polynomial in `z^{-1}` per bulk degree, handled by Birkhoff factorization | EXACT MATCH (§2.3) |
| 2.4 | "Φ is an isomorphism over `C[z]((q^{-1/r}))[[Q,τ̂]]`" | **MISMATCH** — the ring is `q^{-1/r'}`, `r' ∈ {r, 2r}` (§2.4) |
| 2.5 | Coefficient ring of (5.3) is a power series ring with finitely generated exponent monoid | EXACT MATCH, with the `0 ≤ k ≤ r-1` clause reassigned (§2.5) |
| 2.6 | Cor. 1.8, (1.1), Rem. 1.2, Rem. 5.2, (5.11)–(5.12) | EXACT MATCH (§2.6) |
| 2.7 | "For a trivial rank-two bundle `ς_j° = rλ_j = ±2q^{1/2}` **exactly**, with no tail" | OUR THEOREM, not a source statement — and it **contradicts an uncorrected paragraph of the same memo** (§2.7) |
| 3.1 | Cai Prop. 6: `±1/6` exponents for the **big** quantum connection, by a bulk gauge `M = I + Σ M_n t^n`, `∂_{t_i}M = -z^{-1}P_iM` | EXACT MATCH (§3.1) |
| 3.2 | The small even connection matrices `K_X`, `G_X` in the basis `1,P,P²,P³` | EXACT MATCH; one factor-of-2 slip is **in Cai's prose**, not ours (§3.2) |
| 3.3 | Nothing in Cai licenses evaluation at a specialized bulk parameter with Novikov coefficients | EXACT MATCH (§3.3) |
| 4.1 | KKPY Claim 6.15: nef `K_X` ⟹ regular singularity, pointwise/structural at a rigid even point | EXACT MATCH (§4.1) |
| 4.2 | "their Example 6.20 gives `S³=[4]` for the **cubic fourfold**" | **MISMATCH — no Example 6.20 exists; `S³=[4]` is Example 6.19, a very general QUARTIC in P⁵** (§4.2) |
| 4.3 | Example 6.21 (cubic threefold, `S⁵=[3]`) | EXACT MATCH (§4.3) |
| 4.4 | Lem. 5.24, Prop. 5.23, Prop. 5.17, Prop. 5.30, Rem. 3.14 | EXACT MATCH, with Rem. 3.14 strengthened in our favour (§4.4) |
| 4.5 | Serre automorphism defined as `u`-direction monodromy with `χ(a,b)=χ(b,S(a))` | EXACT MATCH (§4.5) |
| 4.6 | "the authors defer only the **integral-structure** enhancement to forthcoming work, calling Euler-pairing and Serre-automorphism enhancement a straightforward repeat" | **MISMATCH by omission — both the Euler pairing and the Serre automorphism are deferred in the non-archimedean case** (§4.6) |
| 4.7 | "Lemma 2.24" listed under KKPY | mis-assigned: KKPY has no Lemma 2.24; it cites `[38, Lemma 2.24]` = Hinault–Yu–Zhang–Zhang (§4.7) |
| 5.1 | HYZZ Thm 4.34 governs framed F-bundles **over a point**, with an equal-dimension hypothesis | EXACT MATCH (§5.1) |
| 5.2 | "the leading operator `K_split` … is a cup-product operator and hence **nilpotent**" | MISMATCH of wording; it is scalar-plus-nilpotent per block (§5.2) |
| 5.3 | Thm 5.22 (blowup) asserts existence and is **not derived** from Thm 4.34; existence referred elsewhere | EXACT MATCH — confirmed verbatim (§5.3) |
| 5.4 | Thms 5.20(2)/5.24(2): base map determined up to a multiplicative constant "in each logarithmic direction" | minor MISMATCH of locator: "in the `q` direction" there; "logarithmic directions" is Prop. 4.31(2) (§5.4) |
| 5.5 | Lem. 2.24, Assumption 2.22, (2.21), Prop. 4.31, Lem. 5.8(2), (5.17), (5.18), (5.21), (5.23) | EXACT MATCH (§5.5) |
| 6.1 | Levelt–Turrittin over an abstract algebraically closed characteristic-zero field, cited to van der Put–Singer Ch. 3 | **NOT ACCESSIBLE at full text**; supported `secondary only` via Cai (§6) |
| 6.2 | Sabbah cited for the complex-analytic account: Lecture 5, §5.c, proofs of Thm 5.8 and Prop. 5.10 | EXACT MATCH in the arXiv v5 numbering (§7) |
| 7.1 | Flatness identities `[U,C_a]=0`, `∂_aU = C_a + [C_a,μ]` | EXACT MATCH, derivation re-checked line by line (§8.8) |
| 7.2 | Frobenius property: `E⋆` self-adjoint, `μ` anti-self-adjoint, for the Poincaré pairing | EXACT MATCH, cited to Iritani–Koto (2.8)–(2.9) (§8.7) |
| 7.3 | `[μ, U] = U` ("grading operator, `E⋆` raises degree by two") | **MISMATCH — false over the Novikov ring; refuted on the cubic's own matrices** (§8.4) |
| **0.1** | **Manuscript l. 523–527: after removing `-(c-1)λ_j` and `h_{C,j}`, the target bulk coordinate lies in `J_j H*(C)`** | **EXACT MATCH — and the source is strictly stronger than the claim** (§0.1) |
| **0.2** | **Iritani's graded completion is a DIRECT SUM over degrees, so an infinite series in `q^{-1/s}` is not an element of his ring** | **CONFIRMED, verbatim, and independently corroborated by Iritani–Koto Remark 5.3** (§0.2) |
| 0.3 | `h_{Z,j} = (2πi/(r-1))(j + r/2)ρ_Z` from (5.19) | **MISMATCH — the source has `(j + 1/2)`; the `r/2` belongs to `λ_j`'s exponent** (§0.3) |

---

## 0. PRIORITY: the membership claim at manuscript lines 523–527, and the completion category

Both items below were checked against arXiv:2307.13555**v3** (cache key
`arXiv:2307.13555`, SHA-256 `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`),
with the matrices and displayed formulas re-extracted using `pdftotext -layout`, since the
default extraction scrambles them.

### 0.1 The membership claim — EXACT MATCH, and the source proves more than the manuscript claims

**OURS** (manuscript `sections/04-one-step.tex` l. 523–527):

> "Formula (4.4), together with `\cite[(5.45), (5.47), and the initial asymptotics
> (5.27)--(5.30)]{IritaniBlowup}`, shows that after the unit term `-(c-1)λ_j` and fixed
> divisor `h_{C,j}` are removed, its target bulk coordinate lies in `J_j H*(C)`."

with (manuscript l. 484–494) `u = q^{-1/(c-1)}`, `R_j` the image of
`Q_C^d ↦ Q^{i_*d}u^{ρ_C·d}` together with `u` and `s_j`, and
`J_j = (u, {Q^{i_*d}u^{ρ_C·d} : d ≠ 0}, components of s_j) ⊂ R_j`.

**Existence check on each cited item in v3.** All six exist. Verbatim:

- **(5.19)** (needed to interpret `h_{Z,j}`), p. 47: "The quantities `q_{Z,j}`, `h_{Z,j}`
  are given by (see (4.11)) `q_{Z,j} = (1/√(r-1)) e^{(πi/(r-1))(jr + 1/2)} q^{-r/(2(r-1))}`,
  **`h_{Z,j} = (2πi/(r-1))(j + 1/2) ρ_Z`**." So `h_{Z,j}` is a fixed class in `H²(Z)` — a
  rational multiple of `ρ_Z = c_1(N_{Z/X})` — carrying **no `q`-dependence at all**.
- **(5.27)**, p. 51: "`FT̂_{Z,j}(c)|_{Q=θ=0} = q_{Z,j} λ_j^n (b + O(q^{-1/(r-1)}))`", where
  `i_Z^* c = λ^n b + O(λ^{n-1})` with `b ∈ H*(Z)`.
- **(5.28)**, p. 52: the resulting asymptotics of `Φ(c_i)|_{Q=θ=0}` and `Φ(c_{l,m})|_{Q=θ=0}`,
  each of the shape `(… + O(q^{-1}), q_{Z,j}(… + O(q^{-1/(r-1)})))`.
- **(5.29)**, p. 55: "`τ̃(ϑ) ∈ H*(X̃)[[C^∨_{X̃,N}, ϑ]]`, `τ̃(0)|_{Q=0} ∈ q H*(X̃)[q]`;
  `τ(ϑ) ∈ H*(X)[[C^∨_{X,N}, ϑ]]`, `τ(0)|_{Q=0} ∈ q^{-1}H*(X)[q^{-1}]`, where we take the
  restriction to `Q = 0` as power series in `q^±`, `Q`."
- **(5.30)**, p. 55 — **this is the linchpin**, verbatim:

  > `ς_j(ϑ) ∈ H*(Z)((q^{-1/(r-1)}))[[Q, ϑ]]`
  > **`ς_j(0)|_{Q=0} ∈ -(r-1)λ_j + h_{Z,j} + q^{-1/(r-1)} H*(Z)[q^{-1/(r-1)}]`**

  with, on the next line, `λ_j = e^{-(2πi/(r-1))(j + r/2)} q^{1/(r-1)}`. (The source adds,
  after Lemma 5.15's (5.31), "Note that these conditions **refine** (5.29), (5.30)".)
- **(5.45)**, p. 60: "`τ° := τ(τ̃)|_{Q=τ̃=0} = [z^{-1}] log(1 + Σ_{k>0} …)`,
  **`ς_j° := ς_j(τ̃)|_{Q=τ̃=0} = -(r-1)λ_j + [z^{-1}] log(q^{ρ_Z/((r-1)z)} F_{Z,j}(1))`**,
  where `[z^{-1}](···)` means the coefficient of `z^{-1}`."
- **(5.47)**, p. 61: "`τ = τ° + t`, `ς_j = ς_j° + s_j`. This shift of coordinates is
  well-defined as the structures of `QDM(X)^la`, `QDM(Z)^la` can be reduced to smaller
  rings, as we discussed after (5.36)."

**VERDICT: EXACT MATCH.** The membership conclusion is not merely supported; (5.30)
gives it in a **strictly stronger form** than the manuscript states, and the chain closes
without a gap.

The residual coordinate is exactly what the manuscript needs, in two pieces:

1. **The `Q = ϑ = 0` piece.** (5.30) says that after subtracting the `H^0` unit term
   `-(r-1)λ_j` and the `H²` fixed divisor `h_{Z,j}`, what is left lies in
   `q^{-1/(r-1)} H*(Z)[q^{-1/(r-1)}]`. Under `u = q^{-1/(c-1)}` and `c = r` that is
   `u · H*(C)[u]`. **Every term therefore carries a strictly negative power of `q`**: the
   explicit factor `q^{-1/(r-1)}` in front of the polynomial ring forbids a degree-zero
   remainder, and the ring is `H*(Z)[q^{-1/(r-1)}]` — only **non-positive** powers of
   `q^{1/(r-1)}` occur, so there is no positive-power remainder either. And it is a
   **polynomial**, not a series, so the residual is a *finite* sum. Since `u ∈ J_j`,
   `u·H*(C)[u] ⊆ J_j H*(C)`. **This answers the task's exact question affirmatively: only
   negative powers of `q`, no degree-zero and no positive-power remainder.**
2. **The `(Q, τ̃)`-dependent piece.** (5.47) writes `ς_j(τ̃) = ς_j° + s_j(τ̃)`, and the
   components of `s_j` are generators of `J_j` by the manuscript's own definition, so
   `s_j ∈ J_j H*(C)` by construction. `s_j(τ̃)` also vanishes at `Q = τ̃ = 0`, being
   `ς_j(τ̃) - ς_j°`.

Adding the two, the full residual after removing `-(c-1)λ_j` and `h_{C,j}` lies in
`J_j H*(C)`. **EXACT MATCH — not an over-read. No term is unaccounted for.**

**One identification the chain needs, and the source supplies it.** (5.30) is stated at
`ϑ = 0, Q = 0` in the `ϑ`-slice coordinates, whereas `ς_j°` is defined at `Q = τ̃ = 0`.
These are the same point, and Iritani says so explicitly in §5.8.1: "The initial value
`Ψ|_{Q=τ̃=0}` equals `Ψ|_{Q=ϑ=0}`, as **the point `ϑ = 0` in `H` corresponds to the point
`τ̃ = 0`** in `H*(X̃)` under the invertible change of variables `τ̃ = τ̃(ϑ)` in (5.29) (see
(5.31))"; and (5.33) defines `ς_j(τ̃) := ς_j(ϑ(τ̃))` with `ϑ(0) = 0`. So
`ς_j° = ς_j(0)|_{Q=0}` and the membership statement transfers without a base-point jump.
See §8.6.

**Three independent corroborations of the same shape**, so the linchpin does not rest on
a single displayed line:

- Theorem 5.18(6): `ς_j(τ̃)|_{Q=τ̃=0} = -(r-1)λ_j + h_{Z,j} + O(q^{-1/(r-1)})` — the same
  decomposition, with the residual bounded by a strictly negative power of `q`. Weaker
  than (5.30) only in that big-O does not say "polynomial".
- Lemma 5.15's (5.31), whose third line refines (5.29)–(5.30) at the level of
  `∂_{ϑ^α}ς_j(ϑ)|_{Q=ϑ=0}`, again with residuals in `q^{-1/(r-1)}H*(Z)[q^{-1/(r-1)}]`.
- Iritani's own later notes, arXiv:2604.10028v2 §2(b):
  `ς_j(τ̃)|_{Q=τ̃=0} = -(r-1)λ_j + h_{Z,j} + O(q^{-1/(r-1)}) ∈ H*(Z) ⊗ C[q^{±1/(r-1)}]` — the
  membership in a **Laurent polynomial** ring is stated outright.

**Locator note.** The manuscript's citation reads "(5.45), (5.47), and the initial
asymptotics (5.27)--(5.30)". Of those, the work is done almost entirely by **(5.30)** and
**(5.47)**; (5.45) supplies the closed form of `ς_j°` from which (5.30)'s shape is
derived, and (5.27)–(5.29) are the upstream asymptotics feeding it. The range
"(5.27)--(5.30)" is accurate but diffuse; a referee will find the argument faster if
(5.30) is called out by itself. Not a defect.

### 0.2 The completion category — the direct-sum reading is CONFIRMED, verbatim

**Iritani §2.2, verbatim** (p. 8, "Formal power series rings"):

> "We introduce our conventions on power series ring. In this paper, we mostly work with
> `Z`-graded rings or modules and consider their completions **in the category of graded
> rings or modules**. If `M = ⊕_{n∈Z} M_n` is a graded module whose topology is given by a
> descending chain of graded submodules `N_k = ⊕_{n∈Z} N_{k,n} ⊂ M`, then the graded
> completion of `M` is defined to be **`M̂ = ⊕_{n∈Z} M̂_n` with `M̂_n = lim←_k M_n / N_{k,n}`**."

**CONFIRMED — the direct-sum reading is right, character for character.** The completion
is a **direct sum over degrees** of the degreewise inverse limits, not the inverse limit
of the whole module. An element of `M̂` therefore has only **finitely many nonzero graded
components**.

**Iritani Remark 1.3, verbatim** (p. 4):

> "Throughout the paper, we work with completions in the category of graded rings or
> modules. The power series rings such as `C[[Q]]`, `C[z]((q^{-1/s}))[[Q]]` should be
> understood in the graded sense. For example, **`C((q^{-1/(r-1)}))[[Q]]` is the same as
> `C[q^{±1/(r-1)}][[Q]]` since `q` has positive degree.** See §2.2."

**EXACT MATCH** with the quoted form. And §2.2 explains *why* Remark 1.3 is true: since
`deg q = 2(r-1) > 0` (Remark 1.5), each fixed total degree admits only finitely many
powers of `q^{1/(r-1)}`, so the degreewise inverse limit in the `q`-direction is already
finite-dimensional and the direct sum over degrees collapses to the **Laurent polynomial**
ring `C[q^{±1/(r-1)}]`.

**Iritani–Koto Remark 5.3, verbatim** (p. 28) — an independent corroboration, in their own
words:

> "We considered the quantum D-module `QDM(P(V))` and its decomposition over
> `C[z]((q^{-1/r'}))`. More precisely, these can be defined over the 'homogeneous'
> completion `C[z]((q^{-1/r'}))_hom`, which **consists of finite sums of homogeneous
> elements** in `C[z]((q^{-1/r'}))`. Because `z` and `q` both have positive degrees,
> `C[z]((q^{-1/r'}))_hom` is contained in the ring `C[q^{-1/r'}, q^{1/r'}][[z]]` of formal
> power series in `z`. This is relevant to Remark 1.11."

**EXACT MATCH** — "consists of finite sums of homogeneous elements" is verbatim, and it is
the same fact stated for the projective-bundle paper.

**The consequence the reconciliation turns on: CONFIRMED.** An infinite series
`Σ_{n≥1} a_n q^{-n/(r-1)}` with infinitely many `a_n ≠ 0` of bounded cohomological degree
occupies infinitely many distinct total degrees, hence has infinitely many nonzero graded
components, hence **is not an element of Iritani's ring** — exactly as the reconciliation
requires. Iritani's `C((q^{-1/s}))` is *notation for a Laurent polynomial ring*, not a
Laurent series field; the double-parenthesis notation is misleading if read
unconditionally, and Remark 1.3 exists precisely to warn the reader.

**Therefore the manuscript's `B_j = lim←_N R_j/J_j^N` is a different completion of a shared
subring, not a contradictory one.** The two completions take the same `R_j` — which
contains `u`, the monomials `Q^{i_*d}u^{ρ_C·d}`, and the components of `s_j` — and complete
it in different directions: Iritani's graded completion is finite in the `q`-direction and
infinite in the `Q`- and `τ̃`-directions; the manuscript's `J_j`-adic inverse limit treats
`u` as a *filtration* direction and so admits infinite series in `u`. They agree on `R_j`
and disagree only about which limits are adjoined. That is a strictly larger completion of
a shared subring, not an inconsistency — and the manuscript already proves the one thing
this requires, namely that `R_j` injects into `B_j`: its weight argument (l. 499–517)
assigns `w(u) = 1`, `w(s_{j,ℓ}) = 1` and `w(Q^{i_*d}u^{ρ_C·d}) = L(H·i_*d) + ρ_C·d ≥ 1` for
`d ≠ 0`, gives every generator of `J_j` weight at least one, and concludes `∩_N J_j^N = 0`.

**One caveat to state in the manuscript, not a defect.** Because Iritani's ring is
`C[q^{±1/s}][[Q, τ̃]]` in the graded sense, **his `ς_j°` is a Laurent polynomial in
`q^{1/(c-1)}`, with finitely many terms** — which is why (5.30) can say
`q^{-1/(r-1)}H*(Z)[q^{-1/(r-1)}]` rather than a power series ring. The manuscript's tail
`O(u)` at (4.4) is therefore a *finite* tail, and nothing in the argument needs the
infinite completion for `ς_j°` itself. The infinite completion `B_j` is needed only for the
gauge `G` of Lemma 4.5, whose Laurent lower bound decreases with `N` (manuscript
l. 338–347). Saying this explicitly removes the appearance of a clash between the two
rings, which is exactly what a referee comparing them would otherwise allege.

### 0.3 `h_{Z,j}` — MISMATCH in the form as posed

The form to be confirmed was stated as `h_{Z,j} = (2πi/(r-1))(j + r/2) ρ_Z` "from (5.19)".

**Theirs** (v3, (5.19), layout-verified): **`h_{Z,j} = (2πi/(r-1))(j + 1/2) ρ_Z`**.

**MISMATCH: `j + 1/2`, not `j + r/2`.** The `r/2` occurs elsewhere on the same page and in
Theorem 5.18's closing line, but in `λ_j`'s exponent:
`λ_j = e^{-(2πi/(r-1))(j + r/2)} q^{1/(r-1)}`. Independently corroborated by
arXiv:2604.10028v2 §2(b), which writes `h_{Z,j} = (2πi/(r-1))(j + 1/2)ρ_Z` with
`ρ_Z = c_1(N_{Z/X})`.

This does not disturb §0.1 — the membership argument needs only that `h_{Z,j}` is a fixed
`H²` class independent of `q`, which holds under either form — but the coefficient should
be corrected wherever it is written down, since it is the fixed-divisor shift the
manuscript separates off by name.

**Theorem 5.18(6) itself, re-confirmed verbatim** (already in §1.1):
`τ(τ̃)|_{Q=τ̃=0} = q^{-1}[Z] + O(q^{-2})` and
`ς_j(τ̃)|_{Q=τ̃=0} = -(r-1)λ_j + h_{Z,j} + O(q^{-1/(r-1)})`, with
`λ_j = e^{-(2πi/(r-1))(j + r/2)} q^{1/(r-1)}` and `q_{Z,j}`, `h_{Z,j}` "given in (5.19)".
**EXACT MATCH** apart from the `h_{Z,j}` coefficient just corrected.

---

## 1. Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3

Throughout, `r` is Iritani's **codimension of the blowup centre**; the manuscript
renames it `c`. See §8.2 for the symbol collision this creates.

### 1.1 Theorem 5.18 — EXACT MATCH

Theirs, verbatim (p. 58):

> **Theorem 5.18.** There exist maps `H*(X̃) → H*(X)`, `τ̃ ↦ τ(τ̃) ∈ H*(X)((q^{-1}))[[Q,τ̃]]`
> and `H*(X̃) → H*(Z)`, `τ̃ ↦ ς_j(τ̃) ∈ H*(Z)((q^{-1/(r-1)}))[[Q,τ̃]]`, `0 ≤ j ≤ r-2`, and an
> isomorphism Ψ of `C[z]((q^{-1/s}))[[Q,τ̃]]`-modules
> `Ψ : QDM(X̃)^la → τ*QDM(X)^la ⊕ ⊕_{j=0}^{r-2} ς_j*QDM(Z)^la`
> satisfying the following properties:
> (1) Ψ commutes with the quantum connection;
> (2) Ψ intertwines the pairing `P_X̃` with `P_X ⊕ P_Z^{⊕(r-1)}`;
> (3) the first component of Ψ … is homogeneous of degree zero and the second … is homogeneous of degree `-r`;
> (4) Ψ has the following asymptotics …;
> (5) the maps `τ(τ̃)`, `ς_j(τ̃)` are homogeneous of degree 2;
> (6) `τ(τ̃)|_{Q=τ̃=0} = q^{-1}[Z]+O(q^{-2})` and `ς_j(τ̃)|_{Q=τ̃=0} = -(r-1)λ_j + h_{Z,j} + O(q^{-1/(r-1)})`;
> (7) the Jacobian matrix of `(τ(τ̃), ς_j(τ̃))` at `Q = τ̃ = 0` is given in (5.35) and is invertible …

with `λ_j = e^{-2πi(j+r/2)/(r-1)} q^{1/(r-1)}` (a **scalar** multiple of `q^{1/(r-1)}`).

Ours (memo l. 589–591): "Iritani's Theorem 5.18 states Ψ as an isomorphism of
`C[z]((q^{-1/s}))[[Q,τ̃]]`-modules". Ours (manuscript l. 459–467): "Iritani's
Theorem 5.18 gives a formal coordinate isomorphism and a quantum-D-module
isomorphism `QDM(T̃) ≅ QDM(T) ⊕ QDM(C)^{⊕(c-1)}` over a Laurent extension in the
exceptional Novikov variable." **EXACT MATCH** — `r-1 = c-1` summands, the ring is
right, and (1) and (2) are exactly "commutes with the quantum connection" and
"intertwines the pairings".

Ours (memo l. 632–634): "Theorem 5.18(5) states that `τ(τ̃)` and `ς_j(τ̃)` are
homogeneous of degree 2, and his conventions are `deg Q^d = 2c_1(X)·d` and
`deg τ_i = 2 - deg φ_i`." **EXACT MATCH** for (5); the degree conventions are
Iritani's (2.3) and Remark 1.5 (`deg q = 2(r-1)`, `deg z = 2`).

Ours (memo l. 772–774): "`ς_j° = -(c-1)λ_j + h_{Z,j} + O(q^{-1/(c-1)})` with `λ_j` a
**scalar** multiple of `q^{1/(c-1)}`". **EXACT MATCH** with (6) and the displayed `λ_j`.

**On "does formal monodromy transport summand by summand as a consequence?"** — Not
as a stated consequence. What Theorem 5.18 gives is (1), a connection-commuting
module isomorphism over `C[z]((q^{-1/s}))[[Q,τ̃]]`. Our transport step is the memo's
own Theorem (Frame transport), which needs the additional observation that Ψ and
`Ψ^{-1}` use only integral powers of `z` — established in our documents from the
polynomiality in `z` of the module (`C[z]…`, so `Ψ` is `z`-polynomial) and from
Iritani–Koto's proof of their Theorem 5.1(6) for the bundle case. Iritani states no
monodromy transport. This is correctly flagged as ours in the memo (l. 834–843) and
in the manuscript (l. 449–457).

### 1.2 Corollary 1.2 — EXACT MATCH

Theirs, verbatim (p. 4):

> **Corollary 1.2.** The map `τ̃ ↦ (τ(τ̃), {ς_j(τ̃)}_{0≤j≤r-2})` defines an isomorphism of
> quantum cohomology F-manifolds over `C((q^{-1/(r-1)}))[[Q]]`, i.e. the differential of
> this map defines a ring isomorphism `(H*(X̃), ⋆_τ̃) ≅ (H*(X), ⋆_{τ(τ̃)}) ⊕ ⊕_{j=0}^{r-2}(H*(Z), ⋆_{ς_j(τ̃)})`.
> **It also preserves the Euler vector fields.**

So Euler-vector-field preservation is stated, in Corollary 1.2, not in Theorem 5.18.
Our memo (l. 1641–1643) says "the blowup input can now be taken from Iritani's
Theorem 5.18 directly, an isomorphism of quantum D-modules commuting with the
connection **and preserving the Euler vector fields**". Strictly, the Euler clause is
Corollary 1.2's; Theorem 5.18 encodes it only through `∇_{z∂z} = z∂_z - z^{-1}(E_X⋆) + μ_X`
in (5.42)/(5.43) plus clause (1). **Substantively EXACT MATCH; the locator should be
"Theorem 5.18 with Corollary 1.2".**

### 1.3 Lemma 5.15 — MISMATCH

Ours (memo l. 2244–2246): "Iritani's **Lemma 5.15 is the formal inverse function
theorem at `Q = ϑ = 0`, an isomorphism of the germ at the origin onto the germ at its
image**."

Theirs. Lemma 5.15 states nothing of the kind. It is a statement about **initial
terms**:

> **Lemma 5.15.** We write `f|_{Q=0}` for the restriction of `f ∈ C((q^{-1/s}))[[Q]]` to `Q = 0` as
> power series in `q^{±1/s}` and `Q`. We have
> (5.31) `τ̃(ϑ)|_{Q=0} ∈ κ_X̃(ϑ) + (ϑ)² H*(X̃)[q][[ϑ]]`, `τ(ϑ)|_{Q=0} ∈ κ_X(ϑ) + q^{-1}[Z] + (q^{-1}ϑ, q^{-2})H*(X)[q^{-1}][[ϑ]]`, …

The inverse-function conclusion is the **unnumbered sentence that follows** it:

> Lemma 5.15 implies that the change of variables `H → H*(X̃)`, `ϑ ↦ τ̃(ϑ)` is
> **(formally) invertible over `C((q^{-1}))[[Q]]`**. We can also see that the map
> `H → H*(X) ⊕ H*(Z)^{⊕(r-1)}`, `ϑ ↦ (τ(ϑ), {ς_j(ϑ)})` is invertible over
> `C((q^{-1/(r-1)}))[[Q]]` as its Jacobian matrix at `Q = ϑ = 0` is invertible …

**Difference, precisely.** (i) Lemma 5.15 is a normalization lemma, not an inverse
function theorem; the inverse-function statement is a corollary drawn in running
text and is unnumbered. (ii) Iritani writes "**(formally) invertible over
`C((q^{-1}))[[Q]]`**" — invertibility of a formal power series map over a specified
coefficient ring. He never uses the word "germ", and Remark 1.5 explicitly says the
authors do **not** expect Ψ to be analytic in all the variables. Our phrase
"isomorphism of the germ at the origin onto the germ at its image" reads as an
analytic-germ statement and is not what is proved. **Repair:** cite
"Iritani, the discussion following Lemma 5.15" and say "formally invertible over
`C((q^{-1/(r-1)}))[[Q]]`", dropping "germ".

### 1.4 "Iritani states that the pullback of functions along the change of variables is ill-defined" — MISMATCH

This is the most serious misattribution found. Ours (memo l. 2246–2247):

> "… and **Iritani states that the pullback of functions along the change of variables
> is ill-defined**."

Theirs. Iritani states the **opposite**, in three places:

1. Discussion after (5.36): "These pullbacks **are well-defined due to the String and
   Divisor equations**. The well-definedness can also be explained by the fact that
   the structures of `QDM(X)^La` and `QDM(Z)^La` are reduced to `C[z][[Q,τ]]` and the
   ring `R` in Remark 5.6, respectively, and that the pullbacks
   `τ*: C[z][[Q,τ]] → C[z]((q^{-1/s}))[[Q,τ̃]]`, `ς_j*: R → C[z]((q^{-1/s}))[[Q,τ̃]]`
   **are well-defined**."
2. Immediately before Theorem 5.18: "The pullbacks of the quantum connection by
   `τ(τ̃)`, `ς_j(τ̃)` **are well-defined**, as explained previously (see the discussion
   after (5.36))."
3. §5.8.2: "This shift of coordinates **is well-defined** as the structures of
   `QDM(X)^la`, `QDM(Z)^la` can be reduced to smaller rings, as we discussed after
   (5.36)."

**Difference, precisely.** There is a real subtlety in the neighbourhood — the
pullback is well-defined *because* of the String and Divisor equations and the
reduction to the smaller rings, so it is not automatic — but Iritani asserts
well-definedness, never ill-definedness. Our sentence attributes to the source a
claim it three times contradicts.

**Load-bearing?** The memo uses this sentence as one of three grounds for refuting an
earlier "invert the change of variables" argument. The refutation survives on the
other two grounds (the identity is over a formal germ; the invertibility is in
displaced coordinates treated as independent formal variables — both verified below).
So the *conclusion* is not endangered; the *citation* is indefensible and a referee
who checks it will find the source saying the opposite three times. **Repair:**
delete the clause, or replace it with "and Iritani's well-definedness of these
pullbacks is argued from the String and Divisor equations and the reduction to the
smaller rings, not from a general substitution principle."

### 1.5 Formal germ vs pointwise — EXACT MATCH

Ours (memo l. 2248–2251): "Every version of the decomposition identity in the sources
is an isomorphism of modules over a formal germ, not a family of pointwise
statements. So a parameter at which a prescribed displaced coordinate vanishes need
not exist, and 'read the identity in either direction' is false."

Theirs. Three independent confirmations:

- Theorem 5.18 is over `C[z]((q^{-1/s}))[[Q,τ̃]]` — formal in `Q` and `τ̃`.
- Remark 1.5: "Although quantum cohomology is expected to have convergent structure
  constants in general, **we do not expect that the decomposition Ψ is analytic in all
  the variables `q, Q, τ̃, z`.** Instead, we expect that Ψ can be analytified to an
  isomorphism over the ring `O^an[[z]]` …"
- Iritani–Koto Remark 1.9: "**We do not discuss the convergence of quantum
  cohomology.** In this paper, 'generic semisimplicity' means formal semisimplicity."

**EXACT MATCH.** Pointwise evaluation at an arbitrary parameter is not licensed by
either source. This is the correct and sufficient ground for the refutation in §1.4.

### 1.6 (5.15) — EXACT MATCH

Theirs, verbatim:

> (5.15) `C[z][[Q_Z, σ]] → C[z]((q^{-1/s}))[[Q, σ]]`, `Q_Z^d ↦ Q^{ı_*d} q^{-ρ_Z·d/(r-1)} = Q^{i_{Z*}d} S_Z^{-ρ_Z·d/c_Z}`,
> where `ı : Z → X`, `i_Z : Z → W` are the inclusions and `ρ_Z = c_1(N_{Z/W}) = c_1(N_{Z/X})`

introduced as "the (**not necessarily injective** but degree-preserving) extension of
rings".

Task's asserted form `Q^{i_*d} q^{-ρ_C·d/(c-1)}` — **EXACT MATCH** under `r = c` and
`ρ_Z = ρ_C = c_1(N_{C/T})`. The non-injectivity is stated in the source and is exactly
what our memo (l. 654–656) calls "its Novikov map is the noninjective one, which is
why divisor tagging exists". **EXACT MATCH.**

### 1.7 Remarks 1.3–1.5, Proposition 5.4 with (5.13)–(5.14), Remark 5.6, §5.8, §5.8.1, §5.8.2 — all EXACT MATCH

All exist and carry the claimed content.

- **Remark 1.3** (graded completions): "`C((q^{-1/(r-1)}))[[Q]]` is the same as
  `C[q^{±1/(r-1)}][[Q]]` since `q` has positive degree." Note for §8: in the graded
  convention the `q`-direction is a **Laurent polynomial** ring, not a Laurent series
  field — this is what makes `q^{1/(r-1)}` a *unit of positive degree*, not a
  topologically nilpotent element.
- **Remark 1.4**: the pullbacks `τ*QDM(X)^la`, `ς_j*QDM(Z)^la` are *defined* to be
  `H*(X) ⊗ C[z]((q^{-1/s}))[[Q,τ̃]]` etc. with the pulled-back connections.
- **Remark 1.5**: the decomposition is defined over `C[z]((q^{-1/s}))[[Q,τ̃]]`;
  `deg q = 2(r-1)`, `deg z = 2`; non-analyticity expected (quoted in §1.5).
- **Proposition 5.4**: "The map `FT_X|_{QDM_T(W)_X̃}` in Proposition 5.1 extends to a
  homomorphism of `C[z][[C_{X,N}^∨, θ]]`-modules (5.12) `FT̂_X : QDM_T(W)_X̃ → τ*QDM(X)^La`
  on the completion. The map `FT̂_X` satisfies parts (2)–(5) of Proposition 5.1."
  Its proof turns on "The point of the proof is that `q = yS^{-1}` has positive degree",
  and displays (5.13) `FT_X(I_N·C[q^±]·QDM_T(W) + F_N(QDM_T(W))) ⊂ F_N(τ*QDM(X)^La)`
  and (5.14). Both exist and are the continuity/completion statements our documents
  use.
- **Remark 5.6**: "the structure of `QDM(Z)^La` can be reduced to a smaller ring,
  namely, the image `R` of `C[z][[Q_Z e^σ, σ']][σ^0]` under (5.15)."
- **§5.8** "Initial conditions for the decomposition"; **§5.8.1** "Initial
  conditions"; **§5.8.2** "Reconstruction". §5.8's opening explicitly says
  "Borrowing the idea of Katzarkov-Kontsevich-Pantev-Yu [52,53] and
  Hinault-Yu-Zhang-Zhang [36], we show that Ψ, `τ(τ̃)`, `ς_j(τ̃)` can be uniquely
  reconstructed from these initial conditions" — i.e. the reconstruction is
  **uniqueness given initial data**, not an independent existence proof. §5.8.1 fixes
  `Ψ|_{Q=ϑ=0}` from Lemma 5.13 and (5.44), which is exactly what our memo (l. 799–800)
  says it does.
- **§5.8.2** verbatim: "Using the initial condition (5.45), we write
  `τ(τ̃) = τ° + t(τ̃)`, `ς_j(τ̃) = ς_j° + s_j(τ̃)` with `t(τ̃) ∈ H*(X)((q^{-1}))[[Q,τ̃]]`,
  `s_j(τ̃) ∈ H*(Z)((q^{-1/(r-1)}))[[Q,τ̃]]`. The map `τ̃ ↦ (t(τ̃), s_0(τ̃), …, s_{r-2}(τ̃))`
  gives a **formal** invertible change of variables over `C((q^{-1/(r-1)}))[[Q]]`."
  **EXACT MATCH** with memo l. 604–611 and with manuscript l. 474–479, which cites
  `[Section 5.8.2]{IritaniBlowup}` and writes `ς_j = ς_j° + s_j`.

### 1.8 The ring of the change of variables — minor MISMATCH

Ours (memo l. 590–591): "…with the change of variables defined over
`C((q^{-1/(r-1)}))[[Q]]`." Ours (memo l. 605–607): "`t(τ̃) ∈ H*(X)((q^{-1}))[[Q,τ̃]]`
and `s_j` **of the same shape** over `H*(Z)`."

Theirs: `t(τ̃) ∈ H*(X)((q^{-1}))[[Q,τ̃]]` but `s_j(τ̃) ∈ H*(Z)((q^{-1/(r-1)}))[[Q,τ̃]]`.

**Difference.** The two are *not* the same shape: the ambient side is Laurent in
`q^{-1}`, the centre side in `q^{-1/(r-1)}`. And the change-of-variables ring in the
first quote drops `τ̃` (`[[Q]]` vs `[[Q,τ̃]]`) — Corollary 1.2's ring is `C((q^{-1/(r-1)}))[[Q]]`,
but the coordinates themselves live in `[[Q,τ̃]]`. Both are precision slips rather
than errors of substance: the exceptional root `q^{-1/(r-1)}` refines `q^{-1}` and the
memo's own downstream grading argument (l. 631–646) is carried out correctly in the
finer ring. **Repair:** say "with `τ` over `((q^{-1}))` and the `ς_j` over
`((q^{-1/(c-1)}))`, both formal in `(Q, τ̃)`."

### 1.9 Iritani, *Notes on the decomposition theorem for blowups*, arXiv:2604.10028v2, §2 — EXACT MATCH

Ours (manuscript l. 375–377): "Iritani's subsequent notes record explicitly that the
blowup change of variables and decomposition preserve cohomological parity
`\cite[Section~2]{IritaniNotes}`."

Theirs, §2 "Arithmetic properties", verbatim:

> (a) The formal power series `τ^i(τ̃)`, `ς_j^i(τ̃)` have the same degrees and **the
> parities** as the variables `τ^i`, `σ^i`. … The statement about the parity in Part (a)
> **was omitted in [4]**, but it is obvious from the construction.
> (d) The endomorphism `Ψ_X` is homogeneous of degree zero and each `Ψ_{Z,j}` is
> homogeneous of degree `-r`. **They also preserve the parity.** … The statement about
> parity in Part (d) was again omitted in [4], but it is obvious from the construction.

**EXACT MATCH**, and the notes even confirm the manuscript's implicit premise that
this is *not* in the blowup paper itself.

**One caveat a referee will raise.** The notes' Remark 2 warns: "**the parity is not
always congruent modulo 2 to the degree**: we have `deg q^{1/s} = 1` when `r` is odd,
but the parity of `q^{1/s}` remains even." The manuscript's phrase "cohomological
parity" is right if it means the `Z/2Z`-parity the notes define, and wrong if a reader
takes it to mean degree mod 2 — which is exactly the reading the source singles out as
false in odd codimension. See §8.3. **Repair:** write "the `Z/2Z`-parity of
`[IritaniNotes, §1]`" rather than "cohomological parity".

---

## 2. Iritani–Koto, *Quantum cohomology of projective bundles*, arXiv:2307.03696v4

Here `r` is the **rank of `V`**, a different `r` from §1. See §8.2.

### 2.1 Theorem 5.1(4) and 5.1(5) — EXACT MATCH

Theirs, verbatim (p. 27–28), with `λ_j = e^{2π√-1 j/r} q^{1/r}`:

> (4) `ς_j(τ̂)|_{Q=τ̂=0} = rλ_j - 2π√-1 j c_1(V) + O(q^{-1/r})`;
> (5) the Jacobian matrix of `ς(τ̂) = ⊕_{j=0}^{r-1} ς_j(τ̂)` along `Q = τ̂ = 0` is of the form
> `(∂_{τ̂^{i,k}} ς_j)|_{Q=τ̂=0} = λ_j^k (φ_i + O(q^{-1/r}))` and **is invertible over `C((q^{-1/r}))`**;

The task's asserted form of 5.1(5) is **EXACT MATCH**, character for character.
Clauses (1)–(3) and (6) also match what our documents use: (1) Φ intertwines `∇` with
`⊕ς_j*∇`; (2) Φ intertwines `P_{P(V)}` with `⊕P_B`; (3) `ς_j(τ̂)` homogeneous of
degree 2, Φ homogeneous of degree `-(r-1)`, with `deg τ̂^{i,k} = 2 - deg φ_i - 2k`,
`deg Q^d = 2(c_1(TB)+c_1(V))·d`, `deg q = 2r`, `deg z = 2`.

### 2.2 (5.13) — EXACT MATCH

Theirs, verbatim (p. 38):

> (5.13) `s_j(τ̂) = ς_j(τ̂) - ς_j°`.
> The formal change of variables `τ̂ ↦ (s_0(τ̂), …, s_{r-1}(τ̂))` between `H*(P(V))` and
> `H*(B)^{⊕r}` **is invertible over `C((q^{-1/r}))[[Q]]`. Thus, we may treat
> `s_j = s_j(τ̂)`, `j = 0,…,r-1` as independent variables instead of `τ̂`.**

Ours (memo l. 2242–2244): "Iritani–Koto's (5.13) sets `s_j = ς_j - ς_j°` and states
that the invertible change of variables is the one in those **displaced** coordinates,
treated as independent formal variables". **EXACT MATCH**, and the source's own phrase
"as independent variables" is decisive.

**Does this license substitution of a non-nilpotent element?** No. The invertibility
is over `C((q^{-1/r}))[[Q]]`: the `q`-direction is inverted (so `q^{±1/r}` is a unit),
but the `Q` and `s` directions are **formal**, i.e. topologically nilpotent. A
substitution of a specific non-nilpotent value into `s_j` is outside the ring in which
the invertibility is asserted. Our documents' refusal to make that substitution
(memo l. 2249–2251) is correct.

### 2.3 §5.8's fundamental solution `M`, and Birkhoff factorization — EXACT MATCH

Theirs, verbatim (p. 38, with footnote 11):

> Introduce the block-diagonal endomorphism¹¹
> `M ∈ End(H*(B)^{⊕r})[z^{-1}]((q^{-1/r'}))[[Q, s_0, …, s_{r-1}]]` as
> `M = ⊕_{j=0}^{r-1} e^{-ς_j°/z} M_B(ς_j° + s_j; Q q^{-c_1(V)/r})`.
> This satisfies `M|_{Q=s_0=…=s_{r-1}=0} = id` and `M = id + O(z^{-1})`.
> Then the composition `(Φ°)^{-1} ∘ M` admits a **unique Birkhoff factorization** of the
> form `(Φ°)^{-1} ∘ M = M' ∘ Φ^{-1}` where `M' = id + O(z^{-1})` is a power series in
> `z^{-1}` and `Φ^{-1}` is a power series in `z` …
> ¹¹ This serves as a fundamental solution for `QDM(B)^{⊞r}_{ext,loc}` with respect to
> the variables `(Q, s_0, …, s_{r-1})` (but not for `q` and `z`).

Ours (memo l. 847–859): every element matches — the displayed `M`, the footnote's
"fundamental solution for the summands with respect to `(Q, s_0, …, s_{r-1})` but not
for `q` and `z`", `M = id + O(z^{-1})`, the ambient ring, and "the sources meet this
object and handle it not by an ordered receiver but by Birkhoff factorization,
splitting the `z`-regular factor Φ from the `id + O(z^{-1})` factor `M'` in
`(Φ°)^{-1}∘M = M'∘Φ^{-1}`". **EXACT MATCH.**

**"Polynomial in `z^{-1}` per bulk degree?"** — Yes, and the source's bracket ordering
proves it: `End(…)[z^{-1}]((q^{-1/r'}))[[Q, s]]` means that for each monomial in
`(Q, s)`, the coefficient is a **polynomial** in `z^{-1}` (the `[z^{-1}]` is a
polynomial ring). Ours (memo l. 853–855): "Per bulk degree it is a *polynomial* in
`z^{-1}` — which is the draft's own bound (4.1a), that `G_α` has no power of `z` below
`-|α|` — and it is unbounded only after summing over bulk degrees." **EXACT MATCH**,
and this is the correct diagnosis of the manuscript's (4.1a) (manuscript l. 334–335:
"`G_α` contains no power of `z` below `-|α|`").

### 2.4 The ring of Φ — MISMATCH (`r` vs `r'`)

Ours (memo l. 836–838): "Iritani–Koto's Φ is induced by a `C[z,q][[Q,τ̂]]`-module map
and is an isomorphism over **`C[z]((q^{-1/r}))[[Q,τ̂]]`** (proof of their Theorem 5.1(6))."
Same slip at memo l. 853 for `M`'s ring.

Theirs. The ring is `C[z]((q^{-1/r'}))[[Q,τ̂]]`, where (from the introduction, just
after (1.1)): "**where `r'` is `r` or `2r` depending on the parity of `r`** (see (5.1))."
Theorem 5.1's target module is `H*(B) ⊗ C[z]((q^{-1/r'}))[[Q,τ̂]]`; Remark 5.3 repeats
`C[z]((q^{-1/r'}))`; `M` lives in `…((q^{-1/r'}))…`.

**Difference, precisely.** For odd `r`, `C((q^{-1/2r})) ⊋ C((q^{-1/r}))` — the source's
ring is strictly larger, i.e. the ramification of the Novikov direction is deeper than
our sentence records. This exactly mirrors Iritani's `s = r-1` or `2(r-1)`, which the
manuscript *does* carry correctly as `s_c` (manuscript l. 469–470). **In the
application it is harmless** — the only bundle used is `X × P^1 = P(O⊕O)`, `r = 2`
even, so `r' = r = 2` — but the memo's sentence as written is false for odd rank, and
a referee reading it against the source will see the discrepancy. Note that
Theorem 5.1(5)'s invertibility clause genuinely does say `C((q^{-1/r}))`, so the two
rings both occur in the source and must be kept apart. **Repair:** write `q^{-1/r'}`
with `r'` defined, and keep 5.1(5)'s `q^{-1/r}` as the source states it.

### 2.5 The coefficient ring of (5.3) — EXACT MATCH, with one clause reassigned

Theirs, verbatim:

> (5.3) `QDM(B)^{ext} := QDM(B) ⊗_{C[z][[Q_B,σ]]} C[z][[q^{-1/r'}, q^{-c_1(V)/r}Q, σ]]`,
> `QDM(B)^{ext,loc} := QDM(B) ⊗_{C[z][[Q_B,σ]]} C[z]((q^{-1/r'}))[[Q, σ]]`.

So the `ext` coefficient ring **is** a power series ring, and its exponent monoid is
generated by the two monomials `q^{-1/r'}` and `q^{-c_1(V)/r}Q` (together with the `σ`
variables) — **finitely generated. EXACT MATCH.**

The task's "`0 ≤ k ≤ r-1`" clause belongs to a different object: it is the range of the
second index of the coordinates `τ̂^{i,k}` dual to the basis `{φ_i p^k}`, recorded in
the source as "the ring generated by `τ̂^{i,k}` with `0 ≤ i ≤ s`, `0 ≤ k ≤ r-1`" (§5.6).
It is not a statement about (5.3)'s exponent monoid. Reassigned, both clauses check
out.

### 2.6 Corollary 1.8, (1.1), Remark 1.2, Remark 5.2, (5.11)–(5.12) — all EXACT MATCH

- **(1.1)**: `C[[Q_B]] ↪ C((q^{-1/r'}))[[Q]]`, `Q_B^d ↦ q^{-c_1(V)·d/r}Q^d`, "where `r'`
  is `r` or `2r` depending on the parity of `r`".
- **Remark 1.2**: "By tensoring `V` with a sufficiently negative line bundle, we can
  always assume that `V^∨` is generated by global sections, without changing `P(V)`.
  This assumption ensures that `J_V^λ` does not contain negative powers of `λ` and that
  the substitution `λ = p + kz` in the theorem is well-defined."
- **Remark 5.2**: "The identification (5.2) corresponds to a splitting of
  `π_*: H_2(P(V),Z) ↠ H_2(B,Z)` over `Q` defined by the kernel of
  `c_1(T_vert P(V)) = rp + π*c_1(V)`. … it is intrinsic to the geometry of the
  projective bundle `P(V) → B` and is independent of the choice of the vector bundle
  `V` (up to tensoring with a line bundle)."
- **Corollary 1.8**: "The derivative of the map `ς` induces an isomorphism of the
  quantum cohomology rings `(H*(P(V)),⋆_τ̂) ≅ ⊕_{i=0}^{r-1}(H*(B),⋆_{ς_i(τ̂)})` over the
  localized base `C((q^{-1/r}))[[Q]]`. In particular, the quantum cohomology of `P(V)`
  is generically semisimple if and only if the same holds for the base `B`."
- **(5.11)**: `ς_j° = rλ_j + [z^{-1}] log(q^{c_1(V)/(rz)} F_j(1))` — **EXACT MATCH** with
  memo l. 797–799. **(5.12)**: `Φ_j°(φ_i p^k) = e^{-(ς_j° - rλ_j)/z} q^{c_1(V)/(rz)} F_j(φ_i λ^k)`
  — exists and is the initial condition for `Φ_j` as our memo says.
- **Remark 1.9** (not in the task list but decisive for §1.5 and §8.6): "We do not
  discuss the convergence of quantum cohomology. In this paper, 'generic
  semisimplicity' means **formal** semisimplicity."

### 2.7 "`ς_j° = rλ_j = ±2q^{1/2}` exactly, with no tail" — our theorem, and an uncorrected internal contradiction

Ours (memo Theorem `thm:trivial-displacement`, l. 2258–2262): "Let `V = O_X^{⊕2}`.
Then the Iritani–Koto initial displacement is `ς_j° = rλ_j = ±2q^{1/2}` **exactly**, a
class in `H^0`, with no tail."

Theirs. Theorem 5.1(4) reads `ς_j(τ̂)|_{Q=τ̂=0} = rλ_j - 2π√-1 j c_1(V) + O(q^{-1/r})` —
the source **retains** the `O(q^{-1/r})` tail and never asserts it vanishes. The
arithmetic checks: `r = 2`, `c_1(V) = 0`, `λ_j = e^{2π√-1 j/2}q^{1/2} = ±q^{1/2}`, so
`rλ_j = ±2q^{1/2}`. **The vanishing of the tail is our own theorem, not an imported
claim**, and the memo says so ("Two independent proofs"). Its two arguments — the
power count on `F_j(1)` in (5.11), and the product/spectral argument on
`P(O^{⊕2}) = X×P^1` — are ours to defend. The memo's reading that "the `O(q^{-1/r})`
that appears in the sources is a bound on `F_j(1)`, not a nonvanishing statement about
`ς_j°`" is **correct**: big-O in Theorem 5.1(4) asserts an upper bound only.

**But the same memo still asserts the opposite, uncorrected.** Memo l. 778–780, in
the framing-route section, reads:

> "for a trivial rank-two bundle all `c_i(V)` vanish and their `Δ(a)` is purely
> `H^0 ⊕ H^2`, yet **Iritani–Koto's `ς_j°` still carries its `O(q^{-1/r})` tail**, so even
> `X × P^1` does not escape the bulk gauge."

That is the direct negation of Theorem `thm:trivial-displacement`. The corrections
section ("From the fifth version to this one") states "Nothing in the fifth version is
retracted" and does not list this reversal, so a cold reader meets both claims with no
signpost. **This is our-side, not a source problem, and it is the single most
referee-visible inconsistency in the memo.** Repair: delete or amend memo l. 778–780
and record the reversal in §"Corrections".

---

## 3. Cai, *The cubic threefold is symplectically irrational*, arXiv:2608.01577v1

### 3.1 Proposition 6 — EXACT MATCH

Theirs, verbatim (p. 7):

> **Proposition 6.** Let `∇` be the big quantum connection of the cubic threefold. Then
> the operator `∇_z` has solutions `S` which contain a factor `z^ρ` with `ρ ≡ ±1/6 mod Z`.
> Moreover, if `A^{-1}∇_z A` is in Jordan canonical form, then `A^{-1}S` belongs to the
> Jordan block of rank 2.

Yes: **big** quantum connection, `±1/6` **mod Z**. Its proof is verbatim the bulk
gauge our memo describes:

> Consider the system `∂_{t_i} M = -z^{-1} P_i M` for `M = I + Σ M_n t^n ∈ End(H*(X)) ⊗ K`,
> where `t^n` is multi-index notation for `Π t_i^{n_i}`. Such `M` can be found by solving
> for the coefficients `M_n` recursively. Note that `M^{-1}∇_{t_i}M = ∂_{t_i}`.

Ours (memo l. 1518–1521): "Cai states the `±1/6` exponents for the *big* quantum
connection and proves it by constructing `M = I + Σ M_n t^n` with
`∂_{t_i}M = -z^{-1}P_iM`, so that `M^{-1}∇_{t_i}M = ∂_{t_i}` and `M^{-1}∇_zM` is bulk
independent." **EXACT MATCH**, including the operator convention
`∇_z = ∂_z - z^{-2}(E_X⋆) + z^{-1}μ_X` and `∇_{t_i} = ∂_{t_i} + z^{-1}P_i`.

### 3.2 The small even quantum connection matrix — EXACT MATCH

Theirs, verbatim (p. 4; recovered with `pdftotext -layout`, since the default
extraction scrambles the matrix):

> Let `X` be the cubic threefold. … Let `P ∈ H²(X)` be the hyperplane class. Then
> `c_1(X) = 2P`. In the basis `{1, P, P², P³}`, where `P^k` denotes `k`th power of `P` under
> the classical cup product, the horizontality equation becomes `z²∂_z S = (K + zG)S`
> where
> `K = 2 [[0,6q,0,36q²],[1,0,15q,0],[0,1,0,6q],[0,0,1,0]]`,
> `G = (1/2) diag(3, 1, -1, -3)`.

Ours (manuscript (4.9a), l. 1067–1090) reproduces both matrices **character for
character**, and correctly attributes them: "Equation (4.9a) is the displayed system
in Cai, Section 3, p. 4." **EXACT MATCH.** `G = -μ_X` under `μ_X = diag(-3/2,-1/2,1/2,3/2)`,
consistent with Iritani–Koto (2.4).

**A slip in Cai's own prose, which we did not inherit.** Cai writes "The matrix `K`
has eigenvalues `3√3 q^{1/2}`, `-3√3 q^{1/2}`, `0`" — but `K` carries the outer factor `2`,
so its eigenvalues are `±6√3 q^{1/2} = ±6(3q)^{1/2}`, and Cai's own decoupled system
two pages later correctly reads `z²∂_z S̃_1 = (6√3 q^{1/2} + O(z²))S̃_1`. Our manuscript
(4.9c) records `K_0 = diag(6r, -6r, [[0,2],[0,0]])` with `r = (3q)^{1/2}`, i.e. **the
correct eigenvalues including the factor 2**, and our memo l. 1180 records "the other
eigenvalues `±6r`". So the factor is right on our side. Worth recording only because a
referee comparing the two documents will meet Cai's sentence.

All the downstream numbers are exact. Cai's Jordan-basis `M_1` block is
`diag(-19/18, 19/18)` and his `M_2` block is `[[0, -14/(243q)], [-8/81, 0]]`; the
manuscript's `D_0 = diag(-19/18, 19/18)` and `E_0 = [[0, -14/(81r²)], [-8/81, 0]]` agree
because `81r² = 81·3q = 243q`. The manuscript's indicial elimination
`(1/2)(ρ + 19/18)(ρ - 1/18) = -8/81 ⟹ ρ² + ρ + 5/36 = 0 ⟹ ρ = -1/6, -5/6` was
re-derived from (4.9e) independently for this audit and is correct at every step.

### 3.3 Does Cai license evaluation at a specialized bulk parameter with Novikov coefficients? — No, and our memo says so

Theirs (§2, p. 3): Cai's solution ring is built on `k` = the algebraic closure of
`Frac(C[[q]][[t_0,…,t_n]])` and `K` = that of `C((z))[[q]][[t_0,…,t_n]]`, then
`R = K[{z^ρ}, {e^Q}, log z]/(relations)`. The bulk variables `t_i` are **formal
throughout**; `M = I + Σ M_n t^n` is a formal power series in them with `M|_{t=0} = I`,
and Cai's conclusion is a statement in that formal ring. Nowhere does he evaluate at a
specific bulk parameter.

Ours (memo l. 1524–1532): "Over `Λ((z))[[t]]`, with the bulk kept formal, that argument
is sound … **What it does not do by itself is license evaluation at a *specialized*
bulk parameter with Novikov coefficients**, which is where the receiver discussion …
came from." **EXACT MATCH** with what the source does and does not do. This is a
correctly drawn negative.

Cai's Remark 5 is also worth quoting because it is our best available handle on
van der Put–Singer (see §6): "This ring `R` is slightly different from the universal
Picard–Vessiot ring of `k((z))`. The latter is the smallest ring containing the
solutions produced by Turrittin's method for all possible ODE systems over `k((z))`;
see e.g. [17, Section 3.2]. Our choice of `R` is for purely technical reasons."

---

## 4. Katzarkov–Kontsevich–Pantev–Yu, arXiv:2508.05105v2

### 4.1 Claim 6.15 — EXACT MATCH, and it is pointwise/structural

Theirs, verbatim (p. 72), after fixing `Gr = (Deg - d·id)/2`, `T` = the identity on
each `H^a(X)` with `a - d` odd and zero on each with `a - d` even, and
`g = Gr + (1/2)T` "semisimple with **integral eigenvalues**":

> **Claim 6.15.** Suppose `K_X` is nef. Then the connection
> `∇_{∂u} = ∂_u - u^{-2}E_u⋆(-) + u^{-1}Gr : H^•(X)[[u]] → H^•(X)((u))`
> has a regular singularity at `u = 0`. More precisely, the gauge transformed connection
> `u^g ∘ (∇ + (1/2)u^{-1}T du) ∘ u^{-g}` has a first order pole and a nilpotent residue at `u = 0`.
>
> *Proof.* … Since `K_X ≥ 0`, and `b ∈ B_X^{ev}` has a vanishing `H^0(X)`-coordinate, the
> operator `E_u⋆(-)` will move the eigenspace of `Gr` corresponding to an eigenvalue
> `m ∈ (1/2)Z` to the sum of eigenspaces for eigenvalues `≥ m + 1`. …

**Pointwise or germ-wise?** Pointwise-structural: the hypotheses are `K_X` nef and a
*fixed* rigid even base point `b` with vanishing `H^0`-coordinate, and the proof is a
filtration/degree count valid at that `b`. Ours (memo l. 98–99): "the low-dimensional
side needs no such invariance, because the sources' nef-canonical claim is **pointwise
structural**". **EXACT MATCH.** Note that the "regular singularity" conclusion is about
the connection **after** the gauge and twist — see §8.3.

### 4.2 "Example 6.20 gives `S³ = [4]` for the cubic fourfold" — MISMATCH, twice over

Ours (memo l. 1570–1572, repeated in `notes/2026-08-15-c912-kkpy-imports-source-check.md`
verdict 2):

> "The offset is systematic rather than a slip: their **Example 6.20** gives `S³ = [4]`
> for the **cubic fourfold**, whose Kuznetsov component is a K3 category with `S = [2]`
> categorically."

Theirs. **arXiv:2508.05105v2 contains no Example 6.20.** The numbered examples in §6
are 6.6, 6.17, 6.18, 6.19 and 6.21. `(6.20)` is a *displayed equation number*, not an
example number, and it sits **inside Example 6.19**. Example 6.19 opens:

> **Example 6.19.** Let `X ⊂ P⁵` be a very general smooth **quartic hypersurface**. Its
> non-rationality is known by the works of Kollár, Schreieder, and Totaro. We outline
> an atom theory argument also proving that very general `X` is not rational.

and the `S³ = [4]` sentence, four paragraphs later, is about that quartic:

> … in the cohomological grading the Serre automorphism `S` associated with the `α(X)`
> has a graded minimal polynomial `S³ = [4]`. This contradicts the unipotency of the
> monodromy on the even part of an atom of a surface of general type.

The cubic fourfold appears instead in **Example 6.17** ("Let `X` be a very general cubic
fourfold containing a plane `P ⊂ X`"), which contains **no** `S³ = [4]` statement at all
— it argues through Kuznetsov's twisted K3 category and the numerical `K`-lattice.

**Difference, precisely, and why it matters.** Our sentence gets the locator wrong
(there is no Example 6.20; it is Example 6.19) *and* the variety wrong (a quartic
fourfold in `P⁵`, not a cubic fourfold). The two are not interchangeable for the
inference actually drawn: the memo's next clause — "whose Kuznetsov component is a K3
category with `S = [2]` categorically" — is a fact about the **cubic** fourfold, and it
is being used to calibrate a relation quoted from the **quartic** example. That is a
conflation of two different varieties inside one sentence of a convention-offset
argument, which is exactly the kind of step a hostile referee will pull on.

The downstream conclusion the memo draws ("the two are different objects — the Serre
automorphism of a Hodge atom in the cohomological `Z`-grading, and the categorical
Serre functor on a `K`-group — so a citation should follow the object it is about")
may well survive; but its stated *evidence* does not, and it must be re-derived from
Example 6.19's quartic or from another source.

Memo l. 1604–1607 repeats the bad locator: "Their **Example 6.20** needs it only for
surfaces of general type, the atom there being shaped like one". The *content* of that
sentence is right for Example 6.19 (its `α(X)` "looks like the Hodge atom of a surface
of a general type"), only the number is wrong. Both occurrences, and the copy in
`2026-08-15-c912-kkpy-imports-source-check.md`, need the same repair.

### 4.3 Example 6.21 — EXACT MATCH

Theirs, verbatim (p. 78):

> **Example 6.21.** Consider a smooth three dimensional cubic `X ⊂ P⁴`. Again for the
> point `b ∈ B_X` corresponding to the hyperplane class, the atomic composition of `X`
> consists of three atoms — two one dimensional atoms corresponding to non-zero
> eigenvalues of `E_u⋆(-)`, and one atom `α(X)` corresponding to the eigenvalue 0. The
> Witt algebra argument from Remark 3.14 shows that there is no further splitting in a
> neighborhood of `b`. …
> The atom `α(X)` looks like the atom of a smooth projective curve of genus 5 but when
> viewed as a Hodge atom enhanced with a Serre automorphism, the corresponding Serre
> automorphism `S` in the cohomological `Z`-grading satisfies the graded minimal
> polynomial **`S⁵ = [3]`**. Thus `S` can not have an eigenvalue `-1` and so `S` cannot be a
> Serre automorphism for a smooth genus 5 curve. So we get that all smooth three
> dimensional cubics are not rational. Similar approach applies to other three
> dimensional Fanos.

Ours (memo l. 1543–1563) matches on every point: three atoms, two one-dimensional at
the nonzero eigenvalues and one `α(X)` at eigenvalue zero; the quoted Witt-algebra
sentence; the genus-five shape; `S⁵ = [3]`; the eigenvalue `-1` exclusion; and the
closing remark about other Fano threefolds. **EXACT MATCH.** The memo's own note that
"Their `S⁵ = [3]` is quoted correctly above — it is what Example 6.21 says" is correct,
and its corrections entry recording that an earlier version wrongly accused itself of
transposing Kuznetsov's `S³ = [5]` is also correct.

### 4.4 Lemma 5.24, Proposition 5.23, Proposition 5.17, Proposition 5.30, Remark 3.14 — EXACT MATCH

- **Lemma 5.24**, verbatim: "Let `X` be a connected complex smooth projective variety
  with a numerically effective canonical class. Then `HAtoms(X)` consists of a single
  atom `η(X)`. *Proof.* This is a special case of Lemma 5.18." — matches memo l. 1617
  ("with nef canonical class their Lemma 5.24 gives a single atom").
- **Proposition 5.23**, verbatim: "For a `G`-atom of `K`-varieties represented by a
  `G`-atomic F-bundle `(A,∇)` over a germ `(B,b)`, the isomorphism class of the
  `G_k`-representation `A|_{b,u=0}` is well-defined and independent of the choice of the
  representative. *Proof.* … Since `G` is a proreductive group, **its finite dimensional
  representations are rigid**…" — matches memo l. 100–102 ("whose well-definedness on
  atoms follows from rigidity of representations of a proreductive group rather than
  from any constancy of monodromy").
- **Proposition 5.17**, verbatim: "(Non-rationality criterion) Let `X` be a smooth
  projective `K`-variety of dimension `d ≥ 2`. Suppose we have a `G`-atom
  `α ∈ Atoms^K_G` which appears in the atomic composition of `X` and is such that
  `α ∉ Atoms^K_{G,dim≤d-2}`. Then `X` can not be birationally equivalent to `P^d_K`."
- **Proposition 5.30**, verbatim: "(Non-rationality criterion) Let `X` be a smooth
  complex projective variety of dimension `d ≥ 2`. Suppose we have a Hodge atom `α`
  which appears in the atomic decomposition of `X` and is such that
  `α ∉ HAtoms_{dim≤d-2}`. Then `X` can not be a rational variety. *Proof.* **This is a
  special case of Proposition 5.17.**"
  and the **unnumbered enhanced form** our memo says is the one actually applied:
  "Here we just note that with the enhancements in place, we get a stronger version of
  the non-rationality criterion Proposition 5.30. In this version we conclude that if a
  smooth projective variety `X` has an enhanced atomic composition containing an
  enhanced atom that does not come from a smooth projective variety of dimension
  `≤ dim X - 2`, then `X` can not be rational."
  Ours (memo l. 1691–1703): "The criterion applied at the end is *not* their numbered
  Proposition 5.30 … It is the enhanced form, which the same section states as
  **unnumbered prose** … The numbered proposition is proved there as a special case of
  their Proposition 5.17; the enhanced version is asserted, on the ground that
  enhancement by Euler pairings and Serre automorphisms repeats the undecorated
  theory. So the load-bearing citation of this route is **an assertion**." **EXACT
  MATCH**, verified against "The theory of Hodge atoms enhanced with Euler pairings and
  Serre automorphisms is completely straightforward and is just a repeat of the theory
  of undecorated Hodge atoms."
- **Remark 3.14**, verbatim: "let `(H,∇)/B` be a maximal F-bundle, and let
  `b ∈ B^ev ⊂ B` be a rigid even point of `B`. Then there exists a unique germ
  `W ⊂ B^ev` at `b` of a purely even closed analytic submanifold in `B` s.t.
  `span_k{E_u^k w}_{k≥0} = T_{W,w}` for all `w ∈ W` close to `b`. The number of distinct
  eigenvalues of `κ|_W : T_W → T_W` and the list of their multiplicities are constant on
  a neighborhood of `b ∈ W`. **Moreover, more fine results can be proved**, like, e.g., if
  `(H,∇)/B` is of exponential type … at some point of `W`, then it is of exponential type
  at all points of `W`. This implies that the isomorphism classes of formal meromorphic
  connections with regular singularities over `Spf k[[u]]` corresponding to the
  eigenvalues of `κ|_W` via Hukuhara-Levelt-Turrittin decomposition are constant along
  `W`."
  Ours (memo l. 1549–1552): "…which is Theorem `thm:no-splitting`, **asserted rather
  than proved**, and their Remark 3.14 introduces its finer clauses with 'more fine
  results can be proved'." **EXACT MATCH**, and **stronger in our favour than the memo
  claims**: the phrase "Witt algebra" occurs in arXiv:2508.05105v2 only twice, in
  Examples 6.19 and 6.21, and **never in Remark 3.14 itself**. Remark 3.14 carries no
  proof and no Witt-algebra argument. So the Examples cite a "Witt algebra argument
  from Remark 3.14" that Remark 3.14 does not contain, which is a fair thing for our
  documents to record.

### 4.5 The Serre automorphism as `u`-direction monodromy — EXACT MATCH

Theirs, verbatim (p. 76):

> (d) Finally, we have the duality automorphism `S : H^•_B(X,C) → H^•_B(X,C)` given by the
> cup product with `(-1)^d exp(-c_1(x))`, which by Serre duality satisfies
> **`χ(a,b) = χ(b, S(a))`** for all `a, b`. In particular `S = (G^∨)^{-1} ∘ G`, i.e. `S` equals
> the monodromy operator on `H_1` for the loop in the `u` plane going once in the
> counterclockwise direction around the origin. … Therefore, if `(H,∇)/B` is a
> **complex analytic** F-bundle of exponential type with a non-degenerate pairing `ψ` we
> can define the F-bundle duality automorphism `S : H|_{B×{u=1}} → H|_{B×{u=1}}` to be
> **the monodromy in the `u`-direction**. Its compatibility with the pairing is expressed
> by the property `χ(a,b) = χ(b,S(a))` …

Ours (memo l. 1633–1636): "Katzarkov–Kontsevich–Pantev–Yu *define* the Serre
automorphism as the monodromy in the `u`-direction, with `χ(a,b) = χ(b,S(a))`, so an
atom's Serre eigenvalues are its formal monodromy eigenvalues". **EXACT MATCH** on the
definition. The inference "so an atom's Serre eigenvalues are its formal monodromy
eigenvalues" is ours, and it is a fair reading of "S … to be the monodromy in the
`u`-direction" — with the caveat in §4.6.

### 4.6 The decoration is complex-analytic only — MISMATCH by omission

Ours (memo l. 1709–1714):

> "It buys the Hodge-atom, motive and Serre-enhancement machinery that the earlier
> blueprint deliberately avoided … — **though not the integral-structure enhancement,
> which its authors call difficult and defer to forthcoming work, while calling the
> Euler-pairing and Serre-automorphism enhancement a straightforward repeat of the
> undecorated theory.**"

Theirs. The source defers the **non-archimedean case of all three**, and says so
explicitly for the Euler pairing and the Serre automorphism separately:

- On the Euler pairing (§6.4(c)): "**Extra work is required to carry out this
  comparison for the non-archimedean A-model F-bundles**, and this will be discussed in
  more detail in [49]."
- On the Serre automorphism (§6.4(d)), immediately after the "complex analytic"
  definition quoted in §4.5: "**Again, the definition in the case of non-archimedean
  analytic F-bundle requires extra work, and will be discussed in [49].**"
- On integral structures: "The theory of Hodge atoms enhanced with an integral
  structure is much more difficult and requires substantial work and new ideas. Already
  the definition of an integral structure on a `k`-analytic F-bundle is non-trivial due
  to the limited understanding of the Riemann-Hilbert correspondence we have in the
  equal characteristic non-archimedean analytic setting. … We deal with all these
  issues in forthcoming work [49]."

**Difference, precisely.** The sentence "The theory of Hodge atoms enhanced with Euler
pairings and Serre automorphisms is completely straightforward and is just a repeat of
the theory of undecorated Hodge atoms" is about the **atom theory built on top of** the
decorations, and it sits *after* the two deferrals. It is not a claim that the
decorations are **defined** in the setting the atoms live in. KKPY's atoms are
`k`-analytic F-bundles over `k = Q((y^Q))`, a non-archimedean field; the Serre
automorphism is defined only for **complex analytic** F-bundles of exponential type,
with the non-archimedean definition explicitly deferred to [49].

**Why this matters here.** The memo's "shorter route to the endpoint" (its
`sec:kkpy-serre`) rests on identifying an atom's Serre eigenvalues with its formal
monodromy eigenvalues, using exactly this definition, and on the *enhanced*
non-rationality criterion, which is itself unnumbered and asserted (§4.4). If the
decoration is not defined non-archimedean, then the route imports two unproved
statements, not one. The memo's own companion note
`2026-08-15-c912-kkpy-imports-source-check.md` does record this (its verdict 5 begins
"But the decoration is undefined in the category our atoms live in"), so the finding
exists on our side — but the memo's paragraph, which is the surface a referee reads,
states the narrower and more favourable version. **Repair:** amend memo l. 1709–1714 to
record both deferrals, and cross-reference verdict 5 of the companion note.

### 4.7 "Lemma 2.24" under KKPY — mis-assigned locator

There is no Lemma 2.24 in arXiv:2508.05105v2; the string "Lemma 2.24" occurs once, as
the citation "see [38, Lemma 2.24]". Reference [38] is Hinault–Yu–Zhang–Zhang, whose
Lemma 2.24 is verified in §5.5. Our memo already attributes it correctly ("**Their**
Lemma 2.24", in the Hinault–Yu–Zhang–Zhang subsection, memo l. 819). No defect on our
side; recorded so the audit trail is unambiguous.

### 4.8 Theorem 4.11 — EXACT MATCH, with one omitted restriction

Theirs, verbatim: "**Theorem 4.11.** There is a canonical isomorphism of the maximal
F-bundles between `(H,∇)` and `(H',∇')`, **over an analytic domain `U` in `B_{P(E)}` and
an analytic domain `U'` in `B_{X'}`**. The union of the different choices of `U` is
connected and nonempty, as is the union of the different choices of `U'`. *Proof.* As in
the proof of Eq. (4.5), Eq. (4.6) reduces the non-archimedean statement to the formal
version, **which is shown by Iritani-Koto in [45, Theorem 5.1]**."

Ours (memo l. 1684–1686): "Theorem 4.11 with `r = 2`, applied to
`X × P^1 = P(O ⊕ O)`, puts two copies of `α(X)` in the atomic decomposition of
`X × P^1`." Substantively right, but it omits that the isomorphism is over *analytic
domains*, and it does not record that KKPY's Theorem 4.11 **rests on Iritani–Koto's
Theorem 5.1**, i.e. it is not an independent import. Worth stating, since the memo
elsewhere presents the KKPY route as avoiding the Iritani–Koto machinery.

---

## 5. Hinault–Yu–Zhang–Zhang, arXiv:2411.02266v2

**arXiv id.** `arXiv:2411.02266`, *Decomposition and framing of F-bundles and
applications to quantum cohomology*, Thorgal Hinault, Tony Yue Yu, Chi Zhang, Shaowu
Zhang. The memo (l. 675) already names it. **Version caveat: only v2 (28 Mar 2025) is
cached and read.** A later version may renumber.

### 5.1 Theorem 4.34 — EXACT MATCH, including the equal-dimension hypothesis

Theirs, §4.4 "**Equivalence of F-bundles over a point**", verbatim setup: for a framed
F-bundle over a point with `∇_{u∂u} = u∂_u + u^{-1}K + G`,

> We assume that the endomorphism `K` induces a `k`-vector space decomposition
> `H = ⊕_{1≤k≤m} H_k` into generalized eigenspaces, **and all `H_k` have same
> dimensions.** Then we have a `k`-vector space `H_0` and a splitting of the fiber
> (4.32) `iso : H_0^{⊕m} ≅ H`. … By construction `K_{ij} = 0` if `i ≠ j` and
> `K_{ii} = ξ_i id_{H_0} + N_i` with `ξ_i ∈ k` and `N_i` a nilpotent endomorphism.

and the theorem:

> **Theorem 4.34.** … Then `∇` is gauge-equivalent to `∇'` under `Φ(u) ∈ GL(H[[u]])` with
> `Φ_{ij}(u) ∈ k[c_1,…,c_r][[u]]` if and only if the following three conditions are
> satisfied: (1) there exists `ϕ ∈ GL(H)` with `ϕ_{ij} ∈ k[c_1,…,c_r]` such that
> `K = ϕ^{-1} ∘ K' ∘ ϕ`, (2) `µ = µ'`, and (3) for all `1 ≤ i ≤ m`,
> `H_{ii} = (ϕ^{-1} ∘ H' ∘ ϕ)_{ii} mod (c_1,…,c_r)`. Furthermore, `Φ` is then uniquely
> determined by the initial condition `Φ|_{u=0} = ϕ mod (c_1,…,c_r)`.

Ours (memo l. 685–700 and 739–742) matches on every clause: the normal form
`∇_{u∂u} = u∂_u + u^{-1}K + (µD + H)`, the gauge class, the three conditions, the
uniqueness given `Φ|_{u=0}`, and "**Section 4.4 assumes the generalized eigenspaces of
`K` all have the same dimension**, and the matrix calculus of Definition 4.33 and
Theorem 4.34 rests on the resulting splitting `H_0^{⊕m} ≅ H`". **EXACT MATCH.**

**"Over the large-radius limit point `q = t = 0` with nilpotent `K`?"** Two separate
questions. The theorem itself is over a **point**, with no nilpotency hypothesis on `K`
(`K_{ii} = ξ_i id + N_i`, and the *distinctness* of the `ξ_i` is what makes the
generalized-eigenspace decomposition nontrivial). Its **applications** are at
`q = t = 0`: Theorem 5.16's proof says "To compute `K'_split`, note that the class `ω`
is ample. In particular, the restriction to `q = t = 0` of the quantum product
associated to `Φ'_ω` is the classical cup-product." **EXACT MATCH** with memo
l. 725–729 on the domain. Definition 4.33 also carries one hypothesis our memo omits:
`µ' ∉ Q_{<0} ⊂ k`. Minor, but a referee checking clause-by-clause will notice.

### 5.2 "hence nilpotent" — MISMATCH of wording

Ours (memo l. 727–729): "the proof of their Theorem 5.16 opens by observing that there
the quantum product reduces to the classical cup product, so that the leading operator
`K_split` of their (5.18) is a cup-product operator and **hence nilpotent**."

Theirs. (5.18) reads
`(K'_split)_{ii} = (c_1 T_X + Σ_{j : deg T_j ≠ 2} ((deg T_j - 2)/2) a_{i,j} T_j) ∪`.
The sum **includes** `j` with `deg T_j = 0`, contributing `-a_{i,0}·1`, an `H^0` term;
and (5.17) pins that `H^0` part to the `H^0` part of `c_1 V + mλ_i`, which Lemma 5.8(2)
computes as `m e^{2πi(i-1)/m}` modulo `(c_1², c_2,…,c_m)` — nonzero. So `(K'_split)_{ii}`
is a cup-product operator whose class has a **nonzero scalar part**: it is
scalar-plus-nilpotent, exactly matching Theorem 4.34's `K_{ii} = ξ_i id_{H_0} + N_i`,
and the `m` distinct `ξ_i` are the whole point of the block decomposition.

**Difference, and whether it damages the argument.** The word "nilpotent" is wrong as
a description of `K'_split`. Two further points: (i) the operator in (5.18) is
`K'_split` (the *target*, disjoint-union side), not `K_split`; (ii) the proof of
Theorem 5.16 does **not** open with that observation — it opens with the triviality of
the bundles — and the "classical cup-product at `q = t = 0`" sentence recurs in
Theorem 5.20's proof, which is where our memo's phrasing most closely matches.

The **substantive point our memo is making survives**, and should be restated in the
correct form: at `q = t = 0` the quantum product degenerates to the cup product, so
*within each summand* the operator is a scalar plus a nilpotent — there is no further
eigenvalue separation inside a block, and the exponential factors that the cubic's
framed operator is built from (arising from `E⋆`'s split eigenvalues `±6(3q)^{1/2}`)
do not exist there. **Repair:** "…is a cup-product operator, hence a scalar plus a
nilpotent on each block, so no eigenvalue separation survives inside a summand at that
point."

### 5.3 Theorem 5.22 asserted, not derived — EXACT MATCH, confirmed verbatim

Ours (memo l. 747–753):

> "Their blowup statement, **Theorem 5.22, does assert existence** of the isomorphism,
> and Theorem 5.24 gives the corresponding uniqueness; the point is not that it is
> unproved but that it is **not derived from Theorem 4.34**, whose hypotheses do not
> cover the unequal block sizes, and that **its existence is referred to the earlier
> decomposition work**."

Theirs. Theorem 5.22 is stated and **no proof follows it**. The remark closing the
section, immediately after Theorem 5.24, reads verbatim:

> **We refer to [18] regarding the existence of the isomorphism.**

**EXACT MATCH** — the source itself refers existence out. And the unequal-block-size
point is explicit in the source's own notation: "Using the splitting (5.21), we can
view an element `Φ ∈ End_C(H*(X̃,C))` as a matrix `(Φ_{i,j})_{1≤i,j≤m}`, with
`Φ_{1,1} ∈ End_C(H*(X,C))`, and `Φ_{i,i} ∈ End_C(H*(Z,C))` for `2 ≤ i ≤ m`", which cannot
satisfy Theorem 4.34's `H_0^{⊕m} ≅ H`. **The "asserted but not derived" characterisation
is verified.**

### 5.4 "up to a multiplicative constant in each logarithmic direction" — minor MISMATCH of locator

Ours (memo l. 784–786): "Their **Theorems 5.20(2) and 5.24(2)** determine the base map
from its restriction to the base point up to a multiplicative constant **in each
logarithmic direction**."

Theirs. Theorem 5.20(2) and Theorem 5.24(2) both read: "The base map `f` is uniquely
and explicitly determined by its restriction to `b ∈ B`, **up to a multiplicative
constant in the `q` direction**." The plural "logarithmic directions" is Proposition
4.31(2)'s wording: "the map on the bases `f` is also uniquely determined by its
restriction to `b_1`, up to some multiplicative constants in the logarithmic
directions."

**Difference.** In the maximal A-model setting there is only one `q`, so the two agree
in the application; the memo has attached 4.31(2)'s generality to 5.20/5.24's
statement. Harmless, but the locator should follow the wording. The memo's identification
of the ambiguity as a Novikov character (`q ↦ cq` ⟹ `Q^d ↦ c^{E·d}Q^d`) is our own
inference, correctly marked as such, and the mechanism it cites — "the proof of their
Proposition 4.31 shows why, since `Ψ(d log p_i) = d log f_i` and integrating a
logarithmic form leaves one constant" — is verbatim in the source (`Ψ(d log p_i) = d log f_i`).

### 5.5 Lemma 2.24, Assumption 2.22, (2.21), Lemma 5.8(2), (5.17), (5.18), (5.23) — all EXACT MATCH

- **(2.21)**: "Fix a nef class `ω ∈ N¹(X)`. It induces a projection
  `k[NE(X,Z)] → k[q]`, `q^β ↦ q^{β·ω}`." — matches memo l. 808–809 ("the one-variable
  Novikov projection `q^β ↦ q^{β·ω}` of their (2.21)"), including *nef*, not ample.
- **Assumption 2.22**: "for any `i_1,…,i_n` and `d`, there are finitely many `β` such that
  `β·ω = d` and `⟨T_{i_1}···T_{i_n}⟩^β_{0,n} ≠ 0`."
- **Lemma 2.24**: "Under Assumption 2.22, the Gromov-Witten potential
  `Φ ∈ Q[[NE(X,Z)]][[t_0,…,t_N]]` as in (2.12) induces an element
  `Φ_ω ∈ Q[[q]][[t_0,…,t_N]]`, via the projection (2.21). Conversely, **`Φ` is uniquely
  determined by `Φ_ω`**." Its proof expands over `T_1,…,T_k` a basis of `H²(X,Q)` and uses
  the divisor axiom.
  Ours (memo l. 819–822): "Their Lemma 2.24 proves that the collapsed potential
  determines the full genus-zero potential, by expanding in the `H²` bulk directions
  and separating curve classes by their intersection numbers with an `H²` basis, under
  the finiteness of their Assumption 2.22." **EXACT MATCH**, mechanism and all.
- **Lemma 5.8(2)**: "the characteristic polynomial of `M` modulo `(c_1², c_2,…,c_m)` is
  `λ^m + c_1λ^{m-1} - 1 = (λ + c_1/m)^m - 1`. We deduce that
  `mλ_i = m e^{2πi(i-1)/m} - c_1` modulo those classes." — matches memo l. 768–770
  ("`mλ_i ≡ mξ^{i-1} - c_1V`, cancelling the `c_1V` on the right of (5.17)"), with
  `ξ = e^{2πi/m}`. The source's congruence is modulo classes of degree `≥ 4`, so the
  memo's "the `H²` components cancel identically" is exact in `H²`. **EXACT MATCH.**
- **(5.17)**: `Σ_{j : deg T_j ≠ 2} ((deg T_j - 2)/2) a_{i,j} T_j = c_1V + mλ_i`, in
  Theorem 5.16, whose conclusion holds "if and only if the coordinates of the base point
  `Δ(a)` satisfy (5.17)", with `Δ(a)` "uniquely determined by (5.17), **up to a shift in
  `⊕_{i=1}^m H²(X,C)`**". **(5.23)**: the blowup analogue,
  `Σ_{j : deg S_j ≠ 2} ((deg_Z S_j - 2)/2) a_{i,j} S_j = c_1 N_{Z/X} + (m-1)λ_i`, with
  Theorem 5.22 additionally requiring `Δ_1(a) ∈ H²(X,C)` and pinning `Δ(a)` up to a shift
  in `H²(X,C) ⊕ ⊕_{i=1}^{m-1} H²(Z,C)`. Ours (memo l. 758–762, 766–780): "its conclusion
  compares the source at its base point with the target based at a shifted class `Δ(a)`,
  pinned by their (5.17) for projective bundles and (5.23) for blowups. That shift is
  exactly what the pro-Laurent gauge of Lemma 4.5 exists to undo." **EXACT MATCH**, and
  the memo's cross-normalization reading (`H^0` and `H^{≥4}` pinned, `H²` free) is
  exactly what (5.17)/(5.23) say.

---

## 6. van der Put–Singer, *Galois Theory of Linear Differential Equations*, Chapter 3 — NOT ACCESSIBLE

**This is the one source in the chain that could not be reached, and it is
load-bearing.**

Ours (manuscript l. 89–93):

> "We use here the functoriality and uniqueness of the ramified formal decomposition.
> That statement holds over **any algebraically closed coefficient field of
> characteristic zero**, which is the algebraic form we need, and in that generality it
> is the formal classification of differential modules over `K((z))`
> `\cite[Chapter~3]{PutSinger}`."

**Access.** The book is not in the shared literature cache and is not freely
obtainable; no full text or partial text was reached. Depth: **`secondary only`**.

**Bibliographic detail, verified from a consulted source rather than recall.** Cai's
reference list, entry [17], read at full text: "Marius van der Put and Michael F.
Singer, *Galois theory of linear differential equations*, Grundlehren der
mathematischen Wissenschaften [Fundamental Principles of Mathematical Sciences],
vol. 328, Springer-Verlag, Berlin, 2003. MR 1960772." The manuscript's bibliography
entry (`cubic_stabilization_m1.tex` l. 188–191) reads "M. van der Put and
M. F. Singer, *Galois Theory of Linear Differential Equations*, Grundlehren der
mathematischen Wissenschaften 328, Springer, 2003." **EXACT MATCH on every field.**

**The content claim, standing in for the source.** The best available secondary
support is Cai's Remark 5, read at full text: "This ring `R` is slightly different from
the universal Picard–Vessiot ring of `k((z))`. The latter is the smallest ring
containing the solutions produced by Turrittin's method for all possible ODE systems
over `k((z))`; see e.g. **[17, Section 3.2]**." Crucially, Cai's `k` is *not* `C`: it is
"the algebraic closure of the field of fractions of `C[[q]][[t_0,…,t_n]]`", an abstract
algebraically closed field of characteristic zero. So a paper read at full text uses
van der Put–Singer §3.2 for exactly the abstract-coefficient-field generality our
manuscript claims for Chapter 3.

**What this licenses and what it does not.** It licenses "a peer-reviewed source uses
van der Put–Singer Chapter 3 in the abstract-`k` generality"; it does **not** license
our own assertion of what Chapter 3 proves, and it says nothing about the
**functoriality and uniqueness** clauses the manuscript specifically invokes ("We use
here the functoriality and uniqueness of the ramified formal decomposition"). Those two
clauses remain **NOT COVERED**. Carry this forward as an open gap: either obtain the
book and pin the numbered statement, or weaken the manuscript sentence to what a
reachable source supports.

Note that our own lane already flagged this: `notes/2026-08-14-c912-quantum-referee-a.md`
l. 113 and l. 383 record "this is Turrittin's theorem in its algebraic form, and it is
what van der Put–Singer prove" and "Fix: add van der Put–Singer Chapter 3 (or
Turrittin) as the load-bearing" citation. The citation was added; the *verification* of
its content was not, and this audit does not supply it.

---

## 7. Sabbah, *Introduction to Stokes Structures*, arXiv:0912.2762v5 — EXACT MATCH (arXiv numbering)

Ours (manuscript l. 93–97): "Sabbah gives the complex-analytic account, where the same
decomposition appears alongside the Riemann–Hilbert correspondence
`\cite[Lecture~5, Section~5.c, proofs of Theorem~5.8 and Proposition~5.10]{SabbahStokes}`."

Theirs, in arXiv v5:

- §5.c exists and is titled "**The Riemann-Hilbert correspondence for germs**" (table
  of contents, p. 72 of the book pagination).
- **Definition 5.7** introduces the Riemann-Hilbert functor `RH`; **Theorem 5.8**
  (Deligne, Malgrange): "The Riemann-Hilbert functor `M ↦ (H^0 DR M̃, H^0 DR^{≤} M)` is
  an equivalence of categories."
- The **proof of Theorem 5.8** invokes the decomposition explicitly: "To show that this
  morphism is an isomorphism, it is enough to argue locally near `θ_o ∈ S¹` and **after a
  ramification**, so that one can use the **Hukuhara-Turrittin decomposition** for
  `Hom_{O_X}(M, M')` coming from that of `M` (indexed by `Φ`) and of `M'` (indexed by `Φ'`)."
- **Proposition 5.10** exists in §5.c: a commuting diagram of functors relating `M` to
  `M_reg` and `(L_{<0}, L_{≤0})` to `gr_0`.

**EXACT MATCH** for the claim as made: §5.c is the Riemann–Hilbert correspondence for
germs, and the ramified Hukuhara–Turrittin decomposition appears inside the proof of
Theorem 5.8, exactly "alongside" the correspondence.

**Two caveats.** (i) The version read is the **arXiv v5**, not the published Lecture
Notes in Mathematics 2060 (2013) that the manuscript's bibliography names; the
numbering may differ in the book, and the manuscript's locators should be checked
against the printed edition before submission or the bibliography should carry the
arXiv version as the one cited. (ii) Sabbah's account is **complex analytic** — his
`Hukuhara-Turrittin` is the asymptotic lifting of a formal decomposition over `C` — so
it does **not** support the abstract-coefficient-field version. The manuscript is
correct to route that claim to van der Put–Singer instead, and correct to describe
Sabbah as "the complex-analytic account". The division of labour between the two
citations is sound; only the van der Put–Singer half is unverified (§6).

**Cache.** The bytes fetched for this audit are recorded in §9.

---

## 8. Silent jumps between frames, units, gradings, and conventions

Every junction below is a place where the chain composes an imported statement with our
own argument, or two imported statements with each other.

### 8.1 Loop coordinate — ALIGNED at every junction

**OURS.** Memo l. 895–899 and l. 1163: `∇_a = ∂_a + z^{-1}C_a`,
`∇_{z∂z} = z∂_z - z^{-1}U + µ`, so horizontal `Y` satisfies `z∂_zY = (z^{-1}U - µ)Y`,
equivalently `z²∂_zY = (U - zµ)Y`. Manuscript (4.9a) l. 1069: `z²∂_zS = (K_X + zG_X)S`.

**THEIRS.**
- Iritani–Koto Theorem 5.1: `ς_j*∇_{z∂z} = z∂_z - z^{-1}(E_B⋆_{ς_j(τ̂)}) + µ_B`.
- Iritani (5.42)/(5.43): `∇_{z∂z} = z∂_z - z^{-1}(E_X⋆_{τ(τ̃)}) + µ_X`.
- Cai §2: `∇_z = ∂_z - z^{-2}(E_X⋆) + z^{-1}µ_X`, i.e. `z∇_z = z∂_z - z^{-1}E⋆ + µ`.
- KKPY §6.5: `∇_{∂u} = ∂_u - u^{-2}E_u⋆(-) + u^{-1}Gr` — **identical in form to Cai with
  `u = z` and `Gr = µ`**, same orientation, not a reciprocal.
- HYZZ §4.4: `∇_{u∂u} = u∂_u + u^{-1}K + G`, and in the application (proof of Theorem
  5.16) they set `K = -K_split`, `D = G_split`, so `K = -(E⋆)` and `G = µ`. Sign
  bookkeeping is explicit in the source.

**VERDICT: ALIGNED.** All five sources use the same loop coordinate with the same
orientation; nothing in the chain uses `1/z` where another uses `z`. The one sign
convention that differs (HYZZ's `K = -U`) is stated in the source and correctly carried
in memo l. 685–688.

**Poincaré rank.** Every connection in the chain is `z∂_z` with a simple pole in
`z^{-1}` before decoupling, i.e. Poincaré rank one. Memo l. 1202 relies on this ("the
splitting lemma at Poincaré rank one"). Consistent with all sources.

**Does an integral `z`-power shift change the framed multiplicity?** No, and every
place we claim it was checked:
- Manuscript l. 74–76: "An integral change of residue representative multiplies the
  formal solution by an integral power of `w`, so it conjugates this lifted action
  rather than changing it." Correct: `Exp_V(n) = e^{2πin} = 1` by (4.0a),
  `ker(Exp_V) = Z`.
- Manuscript l. 1192–1198: "The constant matrix `C` adjoins only the algebraic Novikov
  coefficient `r`, and (4.9d) and its inverse use only integral powers of `z`. Hence
  they preserve each exponent class in `Q/Z`." Correct.
- Memo l. 1485–1486: "shearing changed the exponents by integers only, which `ν_6` does
  not see." Correct for `S = diag(1,z)`: conjugation by `S` shifts the residue by
  `-diag(0,1)`, an integral diagonal.
- Memo Theorem `thm:transport` and manuscript Lemma 4.1A: `G ∈ GL_n(H)` with `H` the
  unramified Hahn/Laurent field is fixed by the turn `σ`, hence `σ(GY) = G σ(Y) = GYM`.
  Correct, and the manuscript's Remark ("The hypothesis on `G` is the whole content")
  correctly identifies that `G ∈ H` rather than `G ∈ U_e` is what is being used.

### 8.2 Novikov and coefficient variables — one genuine symbol collision, repairable by renaming

**The symbol `r` carries three incompatible meanings across the chain**, and two of
them appear in the same memo section:

| Where | Meaning of `r` | Type |
|---|---|---|
| Iritani, arXiv:2307.13555v3 | codimension of the blowup centre `Z ⊂ X` | positive integer |
| Iritani–Koto, arXiv:2307.03696v4 | **rank of the vector bundle `V`** | positive integer |
| Our memo l. 1159, l. 731; manuscript l. 1092 | `r = (3q)^{1/2}` | **a unit of the Novikov coefficient field, of degree 2** |
| Manuscript (4.0c) l. 108 | `r = e/d` (ramification order over orbit length) | positive integer |

The manuscript already renames Iritani's `r` to `c` (codimension) — so `s_c = c-1` or
`2(c-1)`, and `ς_j° = -(c-1)λ_j + …` — which is a good repair for that source. But
Iritani–Koto's rank-`r` is kept as `r` at memo l. 838, l. 849, l. 853, l. 1685 ("Theorem
4.11 with `r = 2`"), while the *same memo* uses `r = (3q)^{1/2}` at l. 731, l. 1159 and
l. 1180, and the manuscript uses `r = e/d` at (4.0c) and `r = (3q)^{1/2}` at l. 1092.

**VERDICT: JUMP, repairable by a stated renaming, not a mathematical defect.** No
argument was found that actually *substitutes* one `r` for another — the arithmetic
checks out everywhere it was tested (§3.2, §5.5) — but memo l. 731 puts the two most
confusable readings in a single sentence: "It is read where the eigenvalues of `c_1⋆`
separate — at the cubic, where the block carries `r = (3q)^{1/2}` and the indicial roots
`±1/6`, `±5/6`", inside a section whose surrounding paragraphs use `r` for the bundle
rank. **Repair:** rename the scalar to something like `ϱ` or `w` throughout the memo's
Section 8 and its cross-references, and keep `r` for the two integers with an explicit
"Iritani's `r` = our `c`; Iritani–Koto's `r` is the rank" note.

Two lesser notes in the same family. (i) `r'` vs `r` in Iritani–Koto (§2.4) — our
documents drop the prime. (ii) `u` is our manuscript's reconstruction coordinate
`u = q^{-1/(c-1)}` (manuscript l. 473, l. 475) **and** the loop coordinate in KKPY, HYZZ
and the memo's framing-route section (memo l. 686, l. 703–713). These are different
documents, but the memo is the analysis document for the manuscript, and a reader moving
between them meets `u` as a Novikov root in one and as the loop coordinate in the other.
**Repair:** rename one of them.

**Which variable is formal and which is a unit, at each step.** This is uniform across
the chain and was checked at each junction:

| Direction | Status in Iritani | in Iritani–Koto | in ours |
|---|---|---|---|
| `q` (exceptional / fibre Novikov) | inverted: `C((q^{-1/s}))`, and by Remark 1.3 equal to `C[q^{±1/s}]` — **a unit of positive degree** | inverted: `C((q^{-1/r'}))` — **unit** | `r = (3q)^{1/2} ∈ Λ^×` — **unit**; manuscript l. 1088 "an algebraic Novikov-coefficient extension inside `K_X`" |
| `Q` (base Novikov) | `[[Q]]` — **formal, topologically nilpotent** | `[[Q]]` — **formal** | formal |
| `τ̃`, `τ`, `ς_j`, `s_j`, `t` (bulk) | `[[τ̃]]` — **formal** | `[[τ̂]]`, `[[s]]` — **formal** | `B = Λ[[τ]]`, memo l. 1159 — **formal** |
| `z` (loop) | polynomial `C[z]`; by Remark 1.5 also `[[z]]` in the graded convention | `C[z]`; `[z^{-1}]` for `M` | `Λ((z))` |

**VERDICT: ALIGNED.** In particular the memo's insistence (l. 1169–1170) that "Everything
below is formal in `τ` and needs no completion of the loop coordinate" is consistent
with the sources' own placement of the formal directions, and Corollary
`cor:cubic-closed`'s "evaluation at a topologically nilpotent `τ^•` is legitimate" uses
the bulk direction, which is formal in both sources. **One caution:** Corollary
`cor:endpoint-value` (memo l. 2299–2305) evaluates an `H^0` shift of size `±2q^{1/2}`,
which the memo itself calls "of unit order" — that is a shift by a **unit**, not a
nilpotent, and the corollary's justification is that an `H^0` shift is exact
(`(τ^0/z)·id`, uniform on all exponential factors, no effect on any regular part). That
justification is correct and does not need smallness, so it is **ALIGNED**; but it is the
one place in the chain where a non-nilpotent substitution is made, and the manuscript
should say so as explicitly as the memo does.

### 8.3 Parity and half-twists — one MISATTRIBUTED object, saved by an explicit clause

**Junction A: `s_c` vs Iritani's `s`.** OURS (manuscript l. 469–470): "The comparison
field adjoins `q^{-1/s_c}`, where `s_c = c-1` for even `c` and `s_c = 2(c-1)` for odd `c`."
THEIRS (Iritani (5.11)): "`s = r-1` if `r` is even; `2(r-1)` if `r` is odd."
**VERDICT: ALIGNED**, exactly, under `c = r`.

**Junction B: Iritani–Koto's `r'`.** Their `r'` is `r` or `2r` by the parity of the
**rank**, a structurally parallel but numerically different quantity from `s`. Our
documents record `s_c` but not `r'` (§2.4). **VERDICT: JUMP in bookkeeping** — the two
parity-doubling constants are not the same and must not be conflated; harmless at
`r = 2` but wrong in general.

**Junction C: parity vs degree mod 2.** THEIRS (arXiv:2604.10028v2, Remark 2): "**the
parity is not always congruent modulo 2 to the degree**: we have `deg q^{1/s} = 1` when `r`
is odd, but the parity of `q^{1/s}` remains even." OURS (manuscript l. 375–377):
"preserve cohomological parity". **VERDICT: JUMP in wording, ALIGNED in substance** — the
source's `Z/2Z`-parity is what is preserved, and it is not degree mod 2 in odd
codimension. Repair as in §1.9.

**Junction D: the half-parity gauge `u^g`.** OURS (memo l. 1578–1586):

> "Their statements are made after **the half-parity gauge `u^g` of Claim 6.15**, this
> memo's count before it. **That gauge shifts exponents by half the cohomological degree,
> multiplying monodromy eigenvalues by a parity-dependent sign**: primitive sixth roots
> become primitive cube roots and `±1` swap. It is the `λ ↦ -λ` substitution between the
> prime-Fano classification's polynomial `R` and the Serre side. Every separation used
> below distinguishes roots of unity of order at most two from roots of order three or
> six, **which the gauge preserves**."

THEIRS. Claim 6.15 applies **two** operations, not one: it gauges by `u^g` **and** twists
the connection by `(1/2)u^{-1}T du`. And the source is explicit that
"the operator `g = Gr + (1/2)T` is semisimple **with integral eigenvalues**. Therefore, we
have a **meromorphic** gauge transformation `u^g`."

**VERDICT: JUMP — the parity-dependent sign is attributed to the wrong operation.**
Because `g` has *integral* eigenvalues, `u^g` is single-valued and changes **no**
monodromy eigenvalue at all; its role, as Theorem 6.16's proof states, is that "`u^g`
moves the lattice `H^int` to `H^can`". What multiplies monodromy eigenvalues by a
parity-dependent sign is the **`(1/2)u^{-1}T du` twist**, which shifts the residue by
`(1/2)T`, i.e. by `1/2` on classes with `a - d` odd and `0` otherwise, giving a factor
`e^{πi} = -1` on exactly those classes.

**Is it repairable, and does the conclusion survive?** Yes, and yes, with one further
dimension-parity subtlety our documents do not state:

- `T` is the identity on `H^a` with `a - d` **odd**. For a **threefold** (`d = 3`) that is
  `a` **even** — so on the cubic threefold the sign hits precisely the *even*
  cohomology, where `ν_6 = 2` lives. For a **fourfold** (`d = 4`, e.g. `X × P¹`) it is
  `a` **odd** — so the even cohomology is *untouched*. The sign is therefore
  dimension-parity dependent, and the memo's blanket "primitive sixth roots become
  primitive cube roots and `±1` swap" is right only in odd dimension.
- **The memo's saving clause is nevertheless correct.** Multiplication by `-1` maps
  `{order ≤ 2}` to itself (`±1 ↦ ∓1`) and maps `{order 3}` and `{order 6}` into each
  other (`e^{±πi/3} ↦ e^{∓2πi/3}`). So the discriminator actually used — "order at most
  two versus order three or six" — is preserved in both directions, in every dimension.
  Verified by direct computation.

**Repair:** rename the object ("the half-parity twist `(1/2)u^{-1}Tdu` of Claim 6.15,
composed with the integral gauge `u^g`"), and state that the sign acts on `H^a` with
`a - d` odd, so its cohomological location depends on `dim X` mod 2.

### 8.4 Grading and sign conventions — one genuine MISMATCH: `[µ, U] = U`

**OURS** (memo l. 1846–1850, in the arbitrary-Jordan-size subsection):

> "The natural input is the grading rather than the pairing … Since `µ` is the grading
> operator and `E⋆` raises degree by two, **`[µ, U] = U`; this makes `H_0` for the
> eigenvalue zero `µ`-invariant**, and on it `[µ, N] = N`, so `N` raises the `µ`-weight by
> one."

**THEIRS.** Iritani–Koto (2.4): `µ_X(φ_i) = (deg φ_i/2 - dim_C X/2)φ_i`; Iritani (2.3):
`E_X = c_1(X) + Σ(1 - deg φ_i/2)τ^i φ_i`. The homogeneity that makes `E⋆` "raise degree
by two" is with respect to the **total** grading, which includes `deg Q^d = 2c_1(X)·d`
(Iritani Remark 1.5, Iritani–Koto Theorem 5.1(3)). `µ` implements only the
**cohomological** half of that grading.

**VERDICT: JUMP, and a genuine defect in the stated route — the identity is false over
a Novikov ring, and it fails on the cubic's own matrices.**

Refuted directly, using the manuscript's own (4.9a). With `µ = -G_X = diag(-3/2,-1/2,1/2,3/2)`
and `U = K_X = 2[[0,6q,0,36q²],[1,0,15q,0],[0,1,0,6q],[0,0,1,0]]`, the commutator is
entrywise `[µ,U]_{ij} = (µ_i - µ_j)U_{ij}`:

- entry `(2,1)`: `µ_2 - µ_1 = 1`, `U_{21} = 2`, so `[µ,U]_{21} = 2 = U_{21}` ✔ (Novikov
  degree 0);
- entry `(1,2)`: `µ_1 - µ_2 = -1`, `U_{12} = 12q`, so `[µ,U]_{12} = -12q ≠ U_{12}` ✘.

The general rule is `[µ,U]_{ij} = (1 - c_1·d) U_{ij}` on the `Q^d`-part, so `[µ,U] = U`
holds **only on the Novikov-degree-zero part**.

The consequence the memo draws also fails on the cubic. The zero generalized eigenspace
of `K_X` over `Λ` is `H_0 = span_Λ{P³ - 6qP, P² - 21q·1}` (computed for this audit from
`K_X` and `K_X²`). Applying `µ` to the first generator gives `3qP + (3/2)P³`, which is
**not** in `H_0`: matching the `P²`-coefficient forces the second generator's coefficient
to be `0`, then the `P³`-coefficient forces the first to be `3/2`, and the `P`-coefficient
would then have to be `-9q`, not `3q`. **So `H_0` is not `µ`-invariant for the cubic**,
the very example the memo cites two lines later ("The cubic is the rank-two instance of
it").

**Damage assessment.**
- **Section 8 (`sec:rigid`) Steps 1–7 do not use this identity anywhere**, and remain
  unaffected. Steps 1–7 use only `[U,C_a] = 0`, `∂_aU = C_a + [C_a,µ]`, the commutant of
  a regular `2×2` matrix, and the Frobenius/pairing input. Corollary `cor:cubic-closed`
  is untouched.
- The identity is used **only** in the "Arbitrary Jordan size" subsection, in a passage
  the memo itself labels incomplete: "What must be supplied to turn this into a proof
  is that the decoupling gauge of Step 1 respects the grading on the zero block … that
  triangular structure is a computation this memo has not done." So no proved statement
  depends on it.
- **But the route as written is broken at its stated starting point**, not merely
  incomplete. The repair is not a renaming: the correct operator is the total grading
  `Gr = µ + (1/2)(deg_q)·q∂_q + …`, which is a **derivation, not a `Λ`-linear
  endomorphism**, so the "`µ`-homogeneous cyclic frame" and "`µ`-weight `p` ⟹ supported on
  the `p`-th sub-diagonal" bookkeeping must be redone in a graded module rather than in
  `End(H_0)` over `Λ`. **Repair:** state `[Gr, U] = U` with `Gr` the total grading, or
  restrict to the Novikov-degree-zero part and say so.

**Junction: the `λ ↦ -λ` offset between the census's `R` and the Serre side.** OURS
(memo l. 1583–1584): "It is the `λ ↦ -λ` substitution between the prime-Fano
classification's polynomial `R` and the Serre side." **NOT VERIFIED here.** The memo
routes the locators and the full comparison to
`notes/2026-08-15-c912-kkpy-imports-source-check.md`, whose verdict 2 restates the
offset but rests on the Example 6.20/6.19 misattribution corrected in §4.2. The
"prime-Fano classification's polynomial `R`" is not identified in the memo, in the
manuscript, or in the four sources read here, so the offset could not be checked "in
every genus where it is checked" as the task asks. **Carry forward as an open gap**: the
claim needs the census source pinned by identifier and the `R`-vs-Serre comparison
recomputed after the Example 6.19 correction. What *is* verified is that the offset's
*mechanism* is the parity twist of §8.3, that the twist multiplies by `-1` on `a - d`
odd, and that the separation used downstream survives it.

**Junction: cohomological grading vs `K`-group.** OURS (memo l. 1573–1575): "The two are
different objects — the Serre automorphism of a Hodge atom in the cohomological
`Z`-grading, and the categorical Serre functor on a `K`-group — so a citation should
follow the object it is about." THEIRS: KKPY state `S⁵ = [3]` explicitly "in the
cohomological `Z`-grading" (Example 6.21) — the qualifier is in the source. **VERDICT:
ALIGNED**, and the memo's separation of the two objects is exactly what the source's own
qualifier invites. No argument was found that uses one convention in a hypothesis and
the other in a conclusion; the memo keeps them apart deliberately.

### 8.5 Exponent normalizations — ALIGNED, verified by recomputation

**OURS.** Memo l. 1326–1331 (Section 8, Step 4): with `ν = 2`,
`A_0' = D_0 = diag(-19/18, 19/18)` and `(A_1')_{21} = -8/81`, the sheared residue is
`R = [[-19/18, 2], [-8/81, 1/18]]`, `tr R = -1`, `det R = 5/36`, characteristic
polynomial `ρ² + ρ + 5/36`, roots `-1/6` and `-5/6`. Manuscript (4.9f)–(4.9i) reaches
the same polynomial by the indicial ansatz.

**THEIRS.** Cai, p. 6: "`ρ` must satisfy `ρ² + ρ + 5/36 = 0`, and hence `ρ = -1/6, -5/6`.
… we conclude that the original system `∇_z^{t=0}S = 0` has solutions with fractional
powers **congruent to `±1/6 mod Z`**."

**VERDICT: ALIGNED — the same statement, not two.** `{-1/6, -5/6} ≡ {-1/6, +1/6} = ±1/6`
in `Q/Z`, and Cai's own sentence says "mod Z", so there is no integer-shift discrepancy
to reconcile. The framed eigenvalues are `Exp_V(ρ) = e^{2πiρ} = e^{∓πi/3}`, the two
primitive sixth roots, in both readings; integer shifts are invisible to `Exp_V` because
`ker(Exp_V) = Z` (manuscript (4.0a)).

**Which object carries the exponent.** Cai's `ρ` is the exponent of `z^ρ` in a solution
of the *unsheared* rank-two system, with the shear built into his ansatz
(`S̃_3 = z^ρ(1+…)`, `S̃_4 = c z^{ρ+1}(1+…)`). The memo's `ρ` is an eigenvalue of the
residue `R` of the *sheared* connection under `S = diag(1,z)`. These are the same
normalization: the ansatz's relative power `z^{+1}` on the second coordinate **is** the
shear. Verified numerically — the memo's `R = νE_{12} + diag((A_0')_{11}, (A_0')_{22} - 1)
+ (A_1')_{21}E_{21}` with Cai's numbers gives exactly `ρ² + ρ + 5/36`, and the
manuscript's independent elimination `(1/2)(ρ + 19/18)(ρ - 1/18) = -8/81` gives the same
polynomial. **ALIGNED.**

**The failure-mode exponents `±1/18`.** OURS (memo l. 1512–1513, and the corrections
entry l. 2615–2616): "deleting `-8/81` and moving the exponents to `±1/18`". Deleting
`(A_1')_{21}` makes `R = [[-19/18, 2], [0, 1/18]]`, eigenvalues `-19/18` and `1/18`. In
`Q/Z` those are `-1/18` and `+1/18`, so "`±1/18`" is **correct mod `Z`** — the same
convention as everywhere else in the chain — and neither is a sixth root
(`e^{2πi/18} = e^{πi/9}` has order 18). **ALIGNED**, with the note that the literal
eigenvalues are `-19/18` and `1/18`, and that the statement is a `Q/Z` statement.

### 8.6 Base point and parameter origin — ALIGNED, with one origin that is genuinely different and is treated as such

Every "at the origin" in the chain was checked to be the same origin, or explicitly
distinguished:

| Origin | Where | Is it our `τ = 0`? |
|---|---|---|
| `Q = τ̃ = 0` | Iritani Thm 5.18(4),(6),(7), §5.8.1 | Yes — the large-radius, zero-bulk point of the **blown-up** variety |
| `Q = ϑ = 0` | Iritani Lem. 5.15, (5.31) | Yes, in the `ϑ`-slice coordinates; the source notes `τ̃(ϑ)\|_{Q=ϑ=0} = 0`, so the two origins **correspond**, and says so explicitly in §5.8.1 ("The initial value `Ψ\|_{Q=τ̃=0}` equals `Ψ\|_{Q=ϑ=0}`, as the point `ϑ = 0` in `H` corresponds to the point `τ̃ = 0`") |
| `Q = τ̂ = 0` | Iritani–Koto Thm 5.1(4),(5), (5.11)–(5.13) | Yes, for the projective bundle |
| `s_j = 0`, i.e. `ς_j = ς_j°` | Iritani–Koto (5.13); Iritani (5.47) | **No — this is the displaced origin.** The whole point of Hypothesis 4.7H is that `ς_j° ≠ 0` |
| `q = t = 0`, the large-radius limit | HYZZ §5, Thm 5.16/5.20 proofs | **No — the eigenvalues of `E⋆` are unseparated there** |
| `b ∈ B_X` = the hyperplane class | KKPY Ex. 6.21, Claim 6.15 (`b ∈ B_X^{ev}`, vanishing `H^0`-coordinate) | Yes for the cubic's own count; the vanishing-`H^0` condition matters for Claim 6.15's proof |
| `τ = 0` for the small even connection over `K_X` | our manuscript (4.9a), memo `sec:rigid` | the reference origin |

**VERDICT: ALIGNED.** The memo does **not** silently identify HYZZ's `q = t = 0` with our
`τ = 0` — its "Check one: Domain" (l. 724–737) is precisely the argument that they are
different, and it is correct (see §5.2 for the one wording repair). Nor does it identify
the displaced `s_j = 0` origin with `τ = 0`: that non-identification **is** Hypothesis
4.7H. Iritani's `ϑ`-origin and `τ̃`-origin are identified by the source itself.

The one place where two origins are composed is memo `sec:unconditional`, which
descends a weak-factorization roof so that "every substitution is a forward one".
Verified as consistent: each forward substitution moves from a variety's own origin to a
displaced parameter of the next, and no inverse map is evaluated at a point where the
formal ring does not reach. **ALIGNED**, and this is the correct structural response to
§1.5.

### 8.7 Units and dimensions of the pairing — ALIGNED, with a sharpened source attribution

**OURS.** Memo l. 1348–1356: "Let `G` be the Poincaré pairing on the even part,
symmetric and nondegenerate. Quantum multiplication is Frobenius, so `U = E⋆` is
`G`-self-adjoint, and `µ` is `G`-anti-self-adjoint. Writing `A(z) = z^{-1}U - µ`, those
two facts are exactly (8.4) `A(-z)^T G + G A(z) = 0`."

**THEIRS.** Iritani–Koto §2.2: "Let `P_X` denote the **z-sesquilinear** pairing on
`H*(X) ⊗ C[z,z^{-1}][[Q,τ]]` induced by the Poincaré pairing, (2.8)
`P_X(f,g) = (f(-z), g(z))_X`. Then the pairing `P_X` is **flat** for `∇` and `M_X` is
isometric with respect to `P_X`: (2.9) `dP_X(f,g) = P_X(∇f,g) + P_X(f,∇g)`."
Iritani §1: "The quantum D-module is also equipped with the pairing
`P_X(f,g) = ∫_X f(-z) ∪ g(z)` which is compatible with the quantum connection `∇`."

**VERDICT: ALIGNED**, and this is the citation the memo's (8.4) needs. Expanding (2.9) in
the `z∂_z` direction with `G` constant gives exactly `A(-z)^TG + GA(z) = 0`, and
unwinding that gives `U^TG = GU` and `µ^TG = -Gµ`. Verified by direct expansion.

**Which pairing each source's intertwining statement preserves.** Both Iritani Thm
5.18(2) ("Ψ intertwines the pairing `P_X̃` with `P_X ⊕ P_Z^{⊕(r-1)}`") and Iritani–Koto
Thm 5.1(2) ("Φ intertwines `P_{P(V)}` with `⊕_{j} P_B`") are about the **z-sesquilinear**
`P`, not the bare Poincaré pairing. Our `G` is the bare pairing restricted to `H^ev`.
**These are the same datum** — `P` is built from `G` by (2.8) — so the composition is
legitimate; the restriction to `H^ev` is also legitimate because even and odd cohomology
are Poincaré-orthogonal (`H^a` pairs with `H^{2n-a}`, and `2n - a` has the parity of `a`).
**ALIGNED.** Worth stating in the manuscript, since a referee will ask which pairing is
meant.

**"After the shearing the pairing is `z` times a symplectic form."** OURS
(`notes/2026-08-15-c912-det-r-pairing-and-serre-lattice.md`, Proposition 3, and its row
C912-M24): "After the shearing `S = diag(1,z)` the pairing becomes
`G^(z) = S(-z)^T G_0 S(z) = z c J + O(z²)` with `J` the standard antisymmetric matrix and
`c = (e_1,e_2) ≠ 0`. The duality relation at leading order reads `R^T J + J R = -J`, that
is, `R + I/2` lies in `sp(2)`. Since `sp(2) = sl(2)`, this is exactly `tr R = -1` and
imposes no condition on `det R`."

**Verified by direct computation for this audit.** With `G_0 = [[0,c],[c,b]]` (the `(1,1)`
entry vanishes because `im N` is isotropic, which is Theorem `thm:h2-automatic`'s input),
`diag(1,-z)G_0 diag(1,z) = [[0, cz],[-cz, -bz²]] = zcJ + O(z²)` ✔. And with the memo's
`R = [[-19/18,2],[-8/81,1/18]]` and `J = [[0,1],[-1,0]]`, one computes
`R^TJ + JR = [[0,-1],[1,0]] = -J` ✔, so `tr R = -1` is forced and `det R = 5/36` is not.
**ALIGNED**, and the "`z` times a symplectic form" phrasing is exact at leading order, as
the note states. The shear therefore changes the *type* of the pairing (symmetric →
antisymmetric) and its `z`-weight (0 → 1); both are recorded on our side, and no
argument was found that uses the unsheared symmetric form on a sheared object.

### 8.8 Flatness identities — ALIGNED, derivation re-checked

**OURS** (memo Lemma `lem:flatness-ids`): `[U, C_a] = 0` and `∂_aU = C_a + [C_a, µ]`.

**THEIRS.** Flatness itself is stated in Iritani §1: "We view `∇` as a **flat**
connection on the trivial `H*(X)`-bundle over the `(z, Q, τ)`-space"; commutativity and
associativity of `⋆` are standard and give the first identity.

**Re-derived independently for this audit.** With `∇_a = ∂_a + z^{-1}C_a` and
`∇_{z∂z} = z∂_z - z^{-1}U + µ`, `∂_aµ = 0`, one gets
`[∇_a, ∇_{z∂z}] = -z^{-2}[C_a, U] + z^{-1}(-∂_aU + C_a + [C_a, µ])`, so flatness is
exactly the two identities, with no `z^0` term. This matches the memo's proof step for
step, including its observation that `z∂_z(z^{-1}C_a s) = -z^{-1}C_a s + z^{-1}C_a z∂_z s`
supplies the `+C_a`. **EXACT MATCH.** Both identities are genuinely standard and are
correctly stated.

---

## 9. Cache additions

One source was newly fetched for this audit and added to the shared literature cache.

| Key | Title | Version | SHA-256 |
|---|---|---|---|
| `arXiv:0912.2762` | Sabbah, *Introduction to Stokes Structures* | v5, 3 Apr 2012 | `1bc0b14b82757bd41bc6342077b263c08be8a6d97f2697ba1483eea3d3b7e078` |

Added with `python3 bin/litcache.py add … --key arXiv:0912.2762`; the manifest records 250
pages and the extraction under `text/arXiv_0912.2762.txt`.

All other sources were already cached and were re-verified by key and hash against the
manifest; the manifest hashes for those five entries are reproduced in the read-depth
table above. Cai's PDF was additionally re-extracted with `pdftotext -layout` because the
default extraction scrambles the matrices `K` and `G` beyond recovery — anyone
re-checking §3.2 must use `-layout`.

---

## 10. What a referee should be handed, and what remains open

**Confirmed and safe to rely on.** The membership claim at manuscript l. 523–527 is an
**exact match** and the source proves more than the manuscript claims (§0.1); and
Iritani's graded completion **is** a direct sum over degrees, so the manuscript's `B_j`
is a different completion of a shared subring rather than a contradictory one (§0.2).
Neither needed repair. The one adjacent correction is the `h_{Z,j}` coefficient (§0.3).

**Must fix before the manuscript or the memo is shown.**

0. `h_{Z,j} = (2πi/(c-1))(j + 1/2)ρ_C`, not `(j + r/2)` (§0.3). Correct it wherever the
   fixed-divisor shift is written out.
1. Memo l. 2246–2247: delete or rewrite "Iritani states that the pullback of functions
   along the change of variables is ill-defined" (§1.4). The source says the opposite
   three times.
2. Memo l. 1570–1572 and l. 1604–1607, and verdict 2 of
   `notes/2026-08-15-c912-kkpy-imports-source-check.md`: "Example 6.20 … for the cubic
   fourfold" is wrong twice (§4.2). It is Example 6.19, a very general quartic in `P⁵`.
3. Memo l. 778–780 versus Theorem `thm:trivial-displacement`: the memo asserts and
   denies the same tail (§2.7), with no correction entry.
4. Memo l. 1846–1850: `[µ, U] = U` is false over a Novikov ring and fails on the cubic
   (§8.4). The arbitrary-Jordan-size route needs the total grading operator, not `µ`.
5. Memo l. 1709–1714: the source defers the non-archimedean definition of **both** the
   Euler pairing and the Serre automorphism, not only integral structures (§4.6).

**Should fix, lower stakes.** Memo l. 2244–2246 (Lemma 5.15 is not the inverse function
theorem, §1.3); memo l. 838/853 (`q^{-1/r'}`, not `q^{-1/r}`, §2.4); memo l. 727–729
("hence nilpotent" → "scalar plus nilpotent per block", §5.2); memo l. 784–786 (locator
for "logarithmic directions", §5.4); memo l. 590–591 and 605–607 (the two rings differ,
§1.8); manuscript l. 375–377 ("`Z/2Z`-parity", not "cohomological parity", §1.9); memo
l. 1578–1586 (the parity sign comes from the `(1/2)u^{-1}Tdu` twist, not from `u^g`, and
its cohomological location depends on `dim X` mod 2, §8.3); the `r` collision (§8.2).

**Open gaps that this audit could not close.**

- **van der Put–Singer Chapter 3 was not reached** (§6). The functoriality and
  uniqueness clauses the manuscript invokes are **NOT COVERED**; only the abstract-`k`
  generality is supported, and only `secondary only` through Cai.
- **The `λ ↦ -λ` offset against "the prime-Fano classification's polynomial `R`"** could
  not be checked (§8.4), because the census source is not identified by a pinned
  identifier in the memo, the manuscript, or any of the sources read. It also inherits
  the Example 6.19 correction.
- **Sabbah was read as arXiv v5, not the published LNM 2060 (2013)** that the
  manuscript's bibliography names (§7); the locators should be re-checked against the
  printed edition.
- **Hinault–Yu–Zhang–Zhang was read at v2 only**; the task pinned no version and a later
  one may renumber (§5).

---

# 11. Shape data for the base-change lemma (Obligation A): what descends to `R_j` and `B_j`

Added 2026-08-15, on request, to support the base-change lemma owed by
`notes/2026-08-15-c912-normalization-statement.md` (Obligation A). The two manuscript
sentences to be turned into a proof are `sections/04-one-step.tex` **l. 520–522** ("Our
`R_j` adjoins `u` and the components of `s_j`, both of which lie in `B_j`, so the center
connection is defined over `R_j` after the same reduction") and **l. 532** ("The
normalized connection descends to `B_j`").

Notation as in the manuscript: `u = q^{-1/(c-1)}`, `c` = codimension = Iritani's `r`;
`R_j` = subring generated by the image of `Q_C^d ↦ Q^{i_*d}u^{ρ_C·d}` together with `u`
and the components of `s_j`; `J_j = (u, {Q^{i_*d}u^{ρ_C·d} : d ≠ 0}, components of s_j)`;
`B_j = lim←_N R_j/J_j^N`.

**Headline.** The lemma stands. There is **exactly one** term in the whole center
structure that requires `u^{-1}`, it is the `H^0` coordinate `-(c-1)λ_j`, and Iritani's
own Remark 2.3 says in one sentence why it enters only through the Euler vector field —
which is precisely the piece the manuscript strips first. Details in §11.3.

## 11.1 The isomorphism's shape

**VERBATIM, Iritani Theorem 5.18** (v3, p. 58): "… and an isomorphism `Ψ` of
**`C[z]((q^{-1/s}))[[Q,τ̃]]`-modules**
`Ψ : QDM(X̃)^la → τ*QDM(X)^la ⊕ ⊕_{j=0}^{r-2} ς_j*QDM(Z)^la`", where by (5.37)
`QDM(X̃)^la := H*(X̃)[z]((q^{-1/s}))[[Q,τ̃]]`, `τ*QDM(X)^la := H*(X)[z]((q^{-1/s}))[[Q,τ̃]]`,
`ς_j*QDM(Z)^la := H*(Z)[z]((q^{-1/s}))[[Q,τ̃]]`.

**VERBATIM, Iritani Remark 1.5** (v3, p. 4): "The decomposition `Ψ` in Theorem 1.1 is
defined over `C[z]((q^{-1/s}))[[Q,τ̃]]`. **The base ring can also be written as
`C[q^{±1/s}][[Q,τ̃]][[z]]`** because of our convention on the graded completion (where
`deg q = 2(r-1)`, `deg z = 2`)."

**VERBATIM, Iritani Corollary 1.2** (v3, p. 4): "The map `τ̃ ↦ (τ(τ̃), {ς_j(τ̃)}_{0≤j≤r-2})`
defines an isomorphism of quantum cohomology F-manifolds **over `C((q^{-1/(r-1)}))[[Q]]`**,
i.e. the differential of this map defines a ring isomorphism … It also preserves the Euler
vector fields."

**VERBATIM, Iritani–Koto, proof of Theorem 5.1(6)** (v4, p. 33): "The above map induces a
**`C[z,q][[Q,τ̂]]`-module map** `Φ = ⊕_{j=0}^{r-1} Φ_j : QDM(P(V)) → ⊕_{j=0}^{r-1}
ς_j*QDM(B)^{ext,loc}` compatible with the connection and homogeneous of degree `-(r-1)`. …
`Φ_j(φ_i p^k)|_{Q=τ̂=0} ∈ (1/√r) λ_j^{k-(r-1)/2} φ_i + q^{-1/r}H*(B)[z][[q^{-1/r}]]` for
`0 ≤ k ≤ r-1` and therefore **`Φ` induces an isomorphism over `C[z]((q^{-1/r'}))[[Q,τ̂]]`**.
This is part (6) of Theorem 5.1. Inverting `Φ|_{Q=τ̂=0}`, we obtain (5.10)
`Φ^{-1}(φ_i e_k)|_{Q=τ̂=0} ∈ (1/√r)Σ_{j=0}^{r-1} λ_k^{(r-1)/2-j} p^j φ_i +
q^{-1/r}H*(B)[z][[q^{-1/r}]]`."

**VERBATIM, Iritani–Koto Remark 5.3** (v4, p. 28): "these can be defined over the
'homogeneous' completion `C[z]((q^{-1/r'}))_hom`, which **consists of finite sums of
homogeneous elements** … Because `z` and `q` both have positive degrees,
`C[z]((q^{-1/r'}))_hom` is contained in the ring `C[q^{-1/r'}, q^{1/r'}][[z]]` **of formal
power series in `z`**."

**VERDICT: SUPPORTS DESCENT, with one wording correction to the memo.**
Since `Ψ` is an isomorphism of `C[z]((q^{-1/s}))[[Q,τ̃]]`-modules, its inverse is a module
map over the *same* ring, so **the entries of `Ψ` and of `Ψ^{-1}` both lie in
`C[z]((q^{-1/s}))[[Q,τ̃]]`**, with no separate argument needed for the inverse. By Remark
1.5 that ring is `C[q^{±1/s}][[Q,τ̃]][[z]]`: **formal power series in `z`, not polynomials,
but with only non-negative integral powers of `z` — no negative powers and no fractional
powers.** The same holds for `Φ`, with the refinement that `Φ` *before* localization is a
`C[z,q][[Q,τ̂]]`-module map (polynomial in both `z` and `q`), while only the *inverse*
needs the localized ring. So the strongest true statement, and the one the manuscript
already makes at l. 467–468 ("The isomorphism and its inverse use only **integral powers
of `z`**"), is correct as written and is exactly what Lemma 4.1A needs (the turn `σ` fixes
`H = Ω_V((z))`, and `Ω_V[[z]] ⊂ Ω_V((z))`). **The memo's l. 839 phrase "Both are
polynomial in `z`" is too strong** — Remark 1.5 and Iritani–Koto Remark 5.3 both say
power series in `z` — and should be changed to "both use only non-negative integral powers
of `z`". Nothing downstream depends on polynomiality.

## 11.2 (5.15) and the center reduction

**VERBATIM, Iritani (5.15)** (v3, p. 46): "we consider the (not necessarily injective but
degree-preserving) extension of rings:
(5.15) `C[z][[Q_Z, σ]] → C[z]((q^{-1/s}))[[Q, σ]]`,
`Q_Z^d ↦ Q^{ı_*d} q^{-ρ_Z·d/(r-1)} = Q^{i_{Z*}d} S_Z^{-ρ_Z·d/c_Z}`,
where `ı : Z → X`, `i_Z : Z → W` are the inclusions and `ρ_Z = c_1(N_{Z/W}) = c_1(N_{Z/X})`."

**VERBATIM, Iritani Remark 5.6** (v3, p. 47): "As in Remark 2.3, the structure of
`QDM(Z)^La` can be reduced to a smaller ring, namely, **the image `R` of
`C[z][[Q_Z e^{σ^{(2)}}, σ']][σ^0]` under (5.15)**. Here we used notation analogous to
Remark 2.3. In other words, **the connection (5.16) multiplied by `z` preserves the
submodule `H*(Z) ⊗ R`**."

**VERBATIM, Iritani Remark 2.3** (v3, p. 11) — the notation Remark 5.6 defers to, and the
single most useful sentence in this whole audit: "We defined the quantum D-module over the
ring `C[z][[Q,τ]]`. **Using the Divisor and String Equations, we can reduce the structure
of the quantum D-module to a smaller ring.** We write `τ^{(2)} = Σ_{deg φ_i = 2} τ^i φ_i`
for the `H²`-part of `τ` and decompose `τ = τ^0 φ_0 + τ^{(2)} + τ'`, where `τ^0` is the
coordinate dual to `φ_0 = 1`. Then the quantum connection (2.2) multiplied by `z` preserves
the submodule `H*(X)[z][[Q e^{τ^{(2)}}, τ']][τ^0] ⊂ QDM(X)`, where we interpret
`(Q e^{τ^{(2)}})^d = Q^d e^{τ^{(2)}·d}` for `d ∈ NE_N(X)`. **Note that the quantum product
`⋆_τ` does not depend on `τ^0`, but `τ^0` appears in the Euler vector field `E_X` (while
`τ^{(2)}` does not appear in `E_X`).** This fact is relevant when considering pullbacks of
quantum D-modules."

**VERBATIM, Iritani, p. 49** (immediately before Corollary 5.8): "The well-definedness can
also be explained by the fact that **the pullback `ς_j* : R → C[z]((q^{-1/s}))[[Q,θ]]` is
well-defined for the ring `R` in Remark 5.6.**"

**VERDICT: SUPPORTS DESCENT. The manuscript's reading is CONFIRMED, with one notational
correction.** Manuscript l. 518–520 says Remark 5.6 "reduces the center structure to the
image of `C[z][[Q_C e^σ, σ']][σ^0]` under its (5.15), with `z∇` preserving `H*(C)` tensored
with that image" — that is Remark 5.6 verbatim except that **the manuscript writes
`Q_C e^σ` where the source writes `Q_Z e^{σ^{(2)}}`**, dropping the `(2)` that marks the
`H²`-part. The distinction is not cosmetic: it is the entire divisor-equation content of
Remark 2.3, and the manuscript's own Lemma 4.5 depends on the `H²`-part being separated.
Fix the superscript.

And **yes, the map `Q^{i_*d}u^{ρ_C·d}` is exactly (5.15)**: with `u = q^{-1/(c-1)}` and
`c = r`, `u^{ρ_C·d} = q^{-ρ_C·d/(c-1)}`, so `Q^{i_*d}u^{ρ_C·d} = Q^{ı_*d}q^{-ρ_Z·d/(r-1)}`,
character for character. **`R_j`'s Novikov generators are precisely the image monomials of
(5.15).** Note `ρ_C·d` may be negative, so an individual factor `u^{ρ_C·d}` can carry a
positive power of `q`; this is **not** an obstruction, because `R_j` is generated by the
*combined* monomial `Q^{i_*d}u^{ρ_C·d}`, exactly as (5.15) produces it, and the
manuscript's weight argument (l. 499–517, `w = L(H·i_*d) + ρ_C·d ≥ 1`) puts every such
combined monomial in `J_j`. And the center connection genuinely does have entries in the
image: that is the second sentence of Remark 5.6 ("the connection (5.16) multiplied by `z`
preserves the submodule `H*(Z) ⊗ R`"), and Iritani separately asserts that `ς_j*` is
well-defined *on `R`*.

Two shape facts fall out that the lemma can use for free: `R` is **polynomial in `z`**
(`C[z][…]`), and `R` is **polynomial in `σ^0`** (`[σ^0]`, not `[[σ^0]]`) — the latter is
what bounds the `u^{-1}` order in §11.3.

## 11.3 The two strippings — THE CRUX

**VERBATIM, Iritani (5.30)** (v3, p. 55): "`ς_j(ϑ) ∈ H*(Z)((q^{-1/(r-1)}))[[Q,ϑ]]`;
`ς_j(0)|_{Q=0} ∈ -(r-1)λ_j + h_{Z,j} + q^{-1/(r-1)} H*(Z)[q^{-1/(r-1)}]`", with
`λ_j = e^{-(2πi/(r-1))(j+r/2)} q^{1/(r-1)}` and (5.19)
`h_{Z,j} = (2πi/(r-1))(j + 1/2)ρ_Z`.

**VERBATIM, Iritani (5.43)** (v3, p. 57), the center connection: `∇_{τ̃^α} = ∂_{τ̃^α} +
z^{-1}(∂_{τ̃^α}ς_j(τ̃))⋆_{ς_j(τ̃)}`; `∇_{z∂z} = z∂_z - z^{-1}(E_Z ⋆_{ς_j(τ̃)}) + µ_Z`;
`∇_{ξQ∂Q} = ξQ∂_Q + z^{-1}(ı^*ξ ⋆_{ς_j(τ̃)}) + z^{-1}(ξQ∂_Q ς_j(τ̃))⋆_{ς_j(τ̃)}`;
`∇_{q∂q} = q∂_q - z^{-1}(r-1)^{-1}(ρ_Z ⋆_{ς_j(τ̃)}) + z^{-1}(q∂_q ς_j(τ̃))⋆_{ς_j(τ̃)}`.

**VERBATIM, Iritani §5.8.1** (v3, p. 60): "`M_W(ϑ)|_{Q=ϑ=0} = id`, **`M_X(τ)|_{Q=0} =
e^{τ/z}`, `M_Z(σ)|_{Q=0} = e^{σ/z}`** (see also Remark 5.10)".

**VERDICT: SUPPORTS DESCENT. No residual coefficient needs a positive power of `q`. The
unique `u^{-1}` is the `H^0` coordinate, it enters only through the Euler vector field and
through `q∂_q ς_j`, and both strippings are exactly the two the manuscript performs.**

Decompose `ς_j` in Remark 2.3's own three-way split `σ = σ^0 φ_0 + σ^{(2)} + σ'`, using
(5.30) and (5.47) `ς_j = ς_j° + s_j`:

| Part | Content | Where it lives |
|---|---|---|
| `ς_j^0` (`H^0`) | `-(c-1)λ_j` **+** `(tail)^0` + `s_j^0` | `-(c-1)λ_j = -(c-1)ζ_j u^{-1}` with `ζ_j ∈ C^×` — **the only `u^{-1}` anywhere**; `(tail)^0 ∈ u·C[u]`, `s_j^0` a generator: both in `J_j` |
| `ς_j^{(2)}` (`H²`) | `h_{C,j}` **+** `(tail)^{(2)}` + `s_j^{(2)}` | `h_{C,j}` a fixed class, no `q`; the rest in `J_j H²(C)` |
| `ς_j'` (`H^{≥4}`) | `(tail)'` + `s_j'` | in `J_j H*(C)` by §0.1 |

Now feed this through Remark 2.3 / Remark 5.6, clause by clause.

- **`σ^0` (the `H^0` direction).** Remark 2.3 states outright: "**the quantum product `⋆_τ`
  does not depend on `τ^0`, but `τ^0` appears in the Euler vector field `E_X`**". So the
  `u^{-1}` cannot reach `⋆_{ς_j}` at all, and therefore cannot reach `∇_{τ̃^α}`,
  `∇_{ξQ∂Q}`'s `ı^*ξ⋆` term, or `∇_{q∂q}`'s `ρ_Z⋆` term. It reaches exactly two places:
  (i) `∇_{z∂z}`, through `E_Z ⋆_{ς_j}`, in which `E_Z = c_1(Z) + Σ_i(1 - deg φ_i/2)ς_j^i φ_i`
  contributes the term `ς_j^0 · id` **linearly** (the coefficient at `φ_0 = 1` is `1 - 0 = 1`);
  and (ii) `∇_{q∂q}`, through `z^{-1}(q∂_q ς_j)⋆`, in which
  `q∂_q(-(c-1)λ_j) = -λ_j = -ζ_j u^{-1}`, again a scalar. Both are scalar multiples of the
  identity carrying `u^{-1}` to the **first power only** — consistent with `R` being
  *polynomial* in `σ^0`, and in fact linear here. **This is precisely the "single-valued
  rank-one exponential twist associated with `-(c-1)λ_j`" of manuscript l. 530–531**, and
  the source confirms the mechanism independently: `M_Z(σ)|_{Q=0} = e^{σ/z}`, so an `H^0`
  bulk shift by a scalar `a` is realized by the scalar exponential factor `e^{a/z}`.
  Conjugating by that factor removes both occurrences simultaneously, because `a` is
  `z`-independent and the connection is flat. After the twist, **no `u^{-1}` remains**.
- **`σ^{(2)}` (the `H²` direction).** Remark 2.3: `τ^{(2)}` enters only through the combined
  generator `(Qe^{τ^{(2)}})^d = Q^d e^{τ^{(2)}·d}`, and "`τ^{(2)}` does not appear in `E_X`".
  Under (5.15) and `σ = ς_j` this generator becomes
  `Q^{i_*d} u^{ρ_C·d} · e^{h_{C,j}·d} · e^{((tail)^{(2)} + s_j^{(2)})·d}`. The first factor is
  an `R_j` generator; the second is `e^{2πi(j+1/2)(ρ_C·d)/(c-1)}`, a **root of unity in
  `C^× ⊂ R_j^×`**, and `d ↦ e^{⟨h_{C,j},d⟩}` is manifestly a multiplicative character —
  which is exactly the hypothesis Lemma 4.5 imposes at manuscript l. 283–287 and applies as
  the divisor substitution (4.1); the third factor lies in `1 + J_j` and is therefore
  `J_j`-adically convergent, i.e. an element of `B_j` and not of `R_j`. **No positive power
  of `q` is created**, and nothing here needs `u^{-1}`.
- **`σ'` (the `H^{≥4}` directions).** `R` is formal in `σ'` (`[[σ']]`); the substituted value
  `(tail)' + s_j'` lies in `J_j H*(C)` by §0.1, so the formal series converge `J_j`-adically
  in `B_j`.

**Conclusion.** After removing exactly the two pieces the manuscript removes — the `H^0`
exponential twist attached to `-(c-1)λ_j`, and the fixed-divisor shift `h_{C,j}` — every
remaining connection coefficient is built from: the (5.15) image monomials
`Q^{i_*d}u^{ρ_C·d}`, positive powers of `u`, the components of `s_j`, complex constants, and
non-negative powers of `z`. **All of these lie in `R_j`, and the completions required
(exponentials of `H²`-parts, formal series in `σ'`) converge in `B_j`. No coefficient
requires `u^{-1}`, so nothing is fatal.**

**Two corrections to the manuscript's phrasing, both in the direction of what it already
does elsewhere.** (i) l. 520–522 says "the center connection **is defined over `R_j`**".
Strictly, the connection *before* the strippings is defined over `Frac(R_j)` — which is what
manuscript l. 276 already says ("defined over `Frac(A)`") — because `λ_j = ζ_j u^{-1}` is not
in `R_j`; and *after* the strippings it is defined over `R_j` with its bulk-direction
completions in `B_j`. The sentence should carry the "after the two strippings" qualifier
that its own surrounding argument supplies four lines later. (ii) `R_j` as literally defined
does not contain `e^{s_j^{(2)}·d}`; it does not need to, because that factor is part of the
positive-filtration term `η` that Lemma 4.5's gauge `G` removes, and `G` lives in the
pro-Laurent group over `B_j` — but the lemma should say so rather than leave the reader to
check that the exponentiated divisor generator is not silently required in `R_j`.

**The manuscript's Lemma 4.5 is already the exact mirror of Remark 2.3**, which is the
cleanest way to write the owed proof: its bulk coordinate `a_0·1 + a_2° + η` with
`a_2° ∈ H²(T)⊗F^0B`, `η ∈ F^1B ⊗̂ H^ev(T)` is Remark 2.3's `τ^0φ_0 + τ^{(2)} + τ'`, and its
proof opens "The string equation separates the rank-one exponential twist `exp(-a_0/z)`. …
The divisor equation gives (4.1). It remains to remove `η`" — the same two equations Remark
2.3 names. Lemma 4.5 even anticipates the `u^{-1}`: "**When `a_0` is not filtration-nilpotent
this twist need not belong to the pro-Laurent gauge group, but a full turn on the original
`z`-disc fixes it, so its framed monodromy is trivial.**" That is exactly the
`a_0 = -(c-1)ζ_j u^{-1}` case, already correctly hypothesized and correctly handled.

## 11.4 What (5.45) and (5.47) contribute

**VERBATIM, Iritani (5.45)** (v3, p. 60): "`τ° := τ(τ̃)|_{Q=τ̃=0} = [z^{-1}] log(1 + Σ_{k>0}
q^{-k} ı_*(Π_{ν=1}^{k-1} e^{-νz}(N_{Z/X}) …)/(k! z^k))`,
**`ς_j° := ς_j(τ̃)|_{Q=τ̃=0} = -(r-1)λ_j + [z^{-1}] log(q^{ρ_Z/((r-1)z)} F_{Z,j}(1))`**, where
`[z^{-1}](···)` means the coefficient of `z^{-1}`."

**VERBATIM, Iritani §5.8.2 and (5.47)** (v3, pp. 60–61): "Using the initial condition (5.45),
we write `τ(τ̃) = τ° + t(τ̃)`, `ς_j(τ̃) = ς_j° + s_j(τ̃)` with `t(τ̃) ∈ H*(X)((q^{-1}))[[Q,τ̃]]`,
`s_j(τ̃) ∈ H*(Z)((q^{-1/(r-1)}))[[Q,τ̃]]`. **The map `τ̃ ↦ (t(τ̃), s_0(τ̃), …, s_{r-2}(τ̃))` gives
a formal invertible change of variables over `C((q^{-1/(r-1)}))[[Q]]`.** … (5.47)
`τ = τ° + t`, `ς_j = ς_j° + s_j`. **This shift of coordinates is well-defined as the
structures of `QDM(X)^la`, `QDM(Z)^la` can be reduced to smaller rings, as we discussed after
(5.36).**"

**VERDICT: (5.47) SUPPORTS DESCENT; (5.45) is the wrong thing to lean on for shape.**

(5.47) contributes three things, and only the first two are about `J_j`. First, it is the
source-level licence for treating `s_j` as an *independent formal variable* rather than a
function — which is what lets the manuscript name the components of `s_j` as generators of
`J_j` at all. Second, it fixes the bound: `s_j(τ̃) = ς_j(τ̃) - ς_j°` **vanishes identically at
`Q = τ̃ = 0`**, so as a function it lies in the `(Q,τ̃)`-adic ideal, and as a variable each
component sits in `J_j^1` by construction — order exactly one, no better and no worse.
Third, and this is the part that matters for the owed lemma, (5.47)'s own justification is
**the reduction to the smaller rings**, i.e. Remark 5.6 again; so the coordinate shift and
the ring reduction are the same fact in the source, not two independent imports.

(5.45), by contrast, should **not** be cited for the shape of `ς_j°`. Its right-hand side
contains `q^{ρ_Z/((r-1)z)}`, whose logarithm contributes `ρ_Z log q/(r-1)` — a `log q` term
that is not in `R_j`, `B_j`, or any Novikov ring. Those `log q` contributions cancel against
`F_{Z,j}(1)`, and the clean statement is (5.30), corroborated by Theorem 5.18(6) and by
arXiv:2604.10028v2 §2(b) (`ς_j(τ̃)|_{Q=τ̃=0} ∈ H*(Z) ⊗ C[q^{±1/(r-1)}]` — a Laurent
polynomial, no logarithms). **(5.45)'s contribution to the lemma is the identification of
`h_{C,j}` as the branch constant, nothing more; the membership statement must come from
(5.30).** Manuscript l. 523–524 cites "(5.45), (5.47), and the initial asymptotics
(5.27)--(5.30)"; that citation is accurate but leads a referee to the one display with
uncancelled logarithms in it. Lead with (5.30).

## 11.5 Graded vs `J`-adic: is there an obstruction to applying `R_j → B_j`?

**VERBATIM, Iritani §2.2** (v3, p. 8): "we mostly work with `Z`-graded rings or modules and
consider their completions **in the category of graded rings or modules**. If
`M = ⊕_{n∈Z} M_n` … then the graded completion of `M` is defined to be **`M̂ = ⊕_{n∈Z} M̂_n`
with `M̂_n = lim←_k M_n/N_{k,n}`**."

**VERDICT: NO OBSTRUCTION. The identities transport; no limit has to be retaken.**

The distinction the question draws is the right one, and it resolves cleanly in our favour
for a reason specific to the graded setting. An element of Iritani's completion has **only
finitely many nonzero graded components** (§0.2), hence is a **finite** sum of homogeneous
pieces. So membership in `R_j` is decidable monomial by monomial, and a statement "this
matrix entry lies in `R_j`" is a statement about finitely many monomials — not a limit.

More precisely, three different kinds of imported statement are involved and they behave
differently, so the owed lemma should keep them apart:

1. **Ring maps.** (5.15) is a homomorphism of rings, stated as such. Composition with
   `R_j ↪ B_j` is again a ring map. Nothing to check.
2. **Identities.** The two inverse identities `Ψ∘Ψ^{-1} = id`, `Ψ^{-1}∘Ψ = id` and the
   intertwining `Ψ∘∇ = ∇'∘Ψ` (Theorem 5.18(1)) are identities between matrices with entries
   in `C[z]((q^{-1/s}))[[Q,τ̃]]`. **An identity between elements of a ring transports along
   any ring homomorphism out of it**, so once the entries are known to lie in a subring, the
   identity restricts to that subring and then pushes forward to `B_j`. Iritani's *proofs*
   do use limits in the graded topology — the completion arguments of Proposition 5.4 with
   (5.13)–(5.14) are exactly that — but **we import the conclusions, not the proofs**, and
   the conclusions are equalities.
3. **Preservation statements.** Remark 5.6's "the connection (5.16) multiplied by `z`
   preserves the submodule `H*(Z) ⊗ R`" is a statement about an operator's image. It too is
   an identity (of submodule membership) and transports along `R → R ⊗_{R_j} B_j`.

The one hypothesis that genuinely has to be checked, and which the manuscript already
proves, is that `R_j` **injects** into `B_j` — otherwise the pushforward could kill a
nonzero entry. That is manuscript l. 499–517: the additive weight `w(u) = 1`,
`w(s_{j,ℓ}) = 1`, `w(Q^{i_*d}u^{ρ_C·d}) = L(H·i_*d) + ρ_C·d ≥ 1` gives every generator of
`J_j` weight at least one, the Novikov finite-below support condition gives every nonzero
element of `R_j` a finite lowest weight, hence `∩_N J_j^N = 0`. Also needed and immediate:
`R_j` really is a subring of Iritani's ring — its generators are `u = q^{-1/(c-1)}` (present,
since `s ∈ {c-1, 2(c-1)}` so `q^{1/(c-1)}` is a power of `q^{1/s}`), the (5.15) image
monomials, and the `s_j` components, and `R_j` consists of *finite* sums of products of
these.

So the two completions are two different completions of a shared subring, taken in different
directions — Iritani's is finite in the `q`-direction and infinite in `(Q, τ̃)`; the
manuscript's is `J_j`-adic and admits infinite series in `u` — and they agree on `R_j`.
**The base-change lemma is a restriction-then-pushforward, not a re-completion.**

## 11.6 The projective-bundle analogue, for site (1c)

**VERBATIM, Iritani–Koto Theorem 5.1(4)** (v4, p. 28): "`ς_j(τ̂)|_{Q=τ̂=0} = rλ_j -
2π√-1 j c_1(V) + O(q^{-1/r})`", with `λ_j = e^{2π√-1 j/r} q^{1/r}`.

**VERBATIM, Iritani–Koto (1.1)** (v4, p. 3): "`C[[Q_B]] ↪ C((q^{-1/r'}))[[Q]]`,
`Q_B^d ↦ q^{-c_1(V)·d/r} Q^d`, where `r'` is `r` or `2r` depending on the parity of `r`."

**VERBATIM, Iritani–Koto (5.3)** (v4, p. 27): "`QDM(B)^{ext} := QDM(B) ⊗_{C[z][[Q_B,σ]]}
C[z][[q^{-1/r'}, q^{-c_1(V)/r}Q, σ]]`, `QDM(B)^{ext,loc} := QDM(B) ⊗_{C[z][[Q_B,σ]]}
C[z]((q^{-1/r'}))[[Q,σ]]`."

**VERBATIM, Iritani–Koto (5.13)** (v4, p. 38): "`s_j(τ̂) = ς_j(τ̂) - ς_j°`. The formal change
of variables `τ̂ ↦ (s_0(τ̂), …, s_{r-1}(τ̂))` between `H*(P(V))` and `H*(B)^{⊕r}` **is
invertible over `C((q^{-1/r}))[[Q]]`. Thus, we may treat `s_j = s_j(τ̂)`, `j = 0,…,r-1` as
independent variables instead of `τ̂`.**"

**VERDICT: SUPPORTS DESCENT, structurally identically — but with two gaps the manuscript
must close by hand, because Iritani–Koto state no analogue of Remark 5.6.**

The shape is the same at every point. The `H^0` term `rλ_j = r e^{2π√-1 j/r} q^{1/r}` is the
unique inverse-`u` object (with the site's own `u = q^{-1/r}`); the `H²` term
`-2π√-1 j c_1(V)` is the fixed divisor, `q`-independent, and `d ↦ e^{⟨-2π√-1 j c_1(V), d⟩}`
is a multiplicative character of the required kind; the remainder is `O(q^{-1/r})`, strictly
negative powers only. (1.1) is the exact analogue of (5.15), with `c_1(V)·d` in place of
`ρ_C·d` and the same possibility of either sign, handled the same way by taking the combined
monomial `q^{-c_1(V)·d/r}Q^d` as the generator. (5.13) is the exact analogue of (5.47),
including the "treat as independent variables" licence, with the same order-one bound.
(5.3)'s `ext` ring is a power series ring on a finitely generated exponent monoid (generated
by `q^{-1/r'}` and `q^{-c_1(V)/r}Q`), which is what `R_j`'s analogue is modelled on.

**Gap one, and it is real: Iritani–Koto contain no Remark 5.6 and no Remark 2.3.** A search
of arXiv:2307.03696v4 for a "smaller ring"/"preserves the submodule"/Divisor-and-String
reduction returns nothing. So at site (1c) the manuscript cannot cite the source for the
`σ^0`/`σ^{(2)}`/`σ'` reduction it needs. **Repair, and it is easy: Iritani's Remark 2.3 is
stated for `QDM(X)` with `X` an arbitrary smooth projective variety, so it applies verbatim
to `QDM(B)`.** Cite Iritani Remark 2.3 for the projective-bundle site rather than looking
for an Iritani–Koto analogue that does not exist. The remaining site-specific step — that
the reduction survives the base change (5.3)/(1.1) — is the same argument Iritani gives
after his (5.15), and has to be written out once.

**Gap two, minor: (4) gives only `O(q^{-1/r})`, not the polynomial membership that (5.30)
gives on the blowup site.** Big-O does deliver "strictly negative powers of `q` only", which
is what §11.3's argument needs; polynomiality (finitely many terms) then follows from
Iritani–Koto Remark 5.3's "finite sums of homogeneous elements" rather than from (4) itself.
The lemma should route through Remark 5.3 for this site instead of asserting the stronger
shape by analogy with (5.30).

One free normalization the manuscript may want: **Iritani–Koto Remark 1.2** — "By tensoring
`V` with a sufficiently negative line bundle, we can always assume that `V^∨` is generated by
global sections, without changing `P(V)`" — lets `c_1(V)` be moved without changing the
variety, which controls the sign of `c_1(V)·d` if that is ever convenient. Not needed for the
lemma as stated, since the combined-monomial device already handles both signs.

## 11.7 Checklist for the owed lemma

What the source supplies, and what must be written by hand:

| Step | Status |
|---|---|
| `Q^{i_*d}u^{ρ_C·d}` is exactly (5.15)'s image | **source**, verbatim |
| Center connection has entries in the reduced ring `R`, `z∇` preserving `H*(C)⊗R` | **source**, Remark 5.6 |
| `σ^0` enters only via `E_Z`, never via `⋆` | **source**, Remark 2.3, one sentence |
| `σ^{(2)}` enters only via `Q^d e^{σ^{(2)}·d}`, never via `E_Z` | **source**, Remark 2.3 |
| `ς_j°` residual after `-(c-1)λ_j` and `h_{C,j}` lies in `u H*(C)[u]` | **source**, (5.30) |
| `s_j` are independent formal variables vanishing at `Q=τ̃=0` | **source**, (5.47) / §5.8.2 |
| `ς_j*` well-defined on `R` | **source**, p. 49 |
| `H^0` shift is realized by the scalar factor `e^{σ/z}` | **source**, §5.8.1 |
| `R_j ↪ B_j` (separation) | **manuscript**, l. 499–517, already proved |
| The `H^0` twist removes both the `E_Z` and the `q∂_q ς_j` occurrences of `u^{-1}` | **by hand**, two lines, from flatness and `z`-independence of `a_0` |
| The reduction survives base change along (5.15) / (1.1) | **by hand**, once, following Iritani's own argument after (5.15) |
| Projective-bundle site: cite Iritani Remark 2.3, not an Iritani–Koto analogue | **by hand**, the analogue does not exist |
