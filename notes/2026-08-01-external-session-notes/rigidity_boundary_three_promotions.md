# The Diagonal Rigidity Boundary: Certified Plateau, Qudit Sectors, and the Semi-Clifford Reduction

Session date: 2026-07-29. Companion to `diagonal_rigidity_phase_boundary.md` and `approximate_rigidity_of_2uniform_states.md`. This note executes the three promotion routes identified for the AME local-unitary rigidity program: (1) the open strip in the uniformity phase boundary, (2) the qudit extension, (3) beyond the diagonal sector.

**Trust tiers.** [T] = theorem with hand-checkable proof in this note. [C] = exact computer certificate (rational arithmetic, no floats in the certified path). [N] = numerical/search evidence only. [I] = imported from literature (citation verified this session unless flagged). [O] = open.

---

## 1. The strip: a certified plateau for the t = 1 sector

Throughout §1: binary codes, C ⊆ F₂ⁿ linear, triply-even means all weights ≡ 0 mod 8. The coset state |C⟩ = |C|^(−1/2) Σ_{x∈C} |x⟩ is s-uniform iff s < min(d(C), d(C⊥)); write U(C) = min(d(C), d(C⊥)) − 1. Theorem 3 of the companion note: |C⟩ admits the non-Clifford transversal symmetry T^⊗n iff C is triply-even (t = 1 sector; general t handled by the SNF criterion and *not* covered by this section's certificates).

### 1.1 Structural reductions [T]

**Proposition 1.1.** A triply-even code is doubly-even, hence self-orthogonal (C ⊆ C⊥), hence d(C⊥) ≤ d(C) and U(C) = d(C⊥) − 1. Moreover d(C) ≥ 8 automatically (nonzero weights are positive multiples of 8), so U(C) ≥ 4 iff d(C⊥) ≥ 5.

*Proof.* wt(x+y) = wt x + wt y − 2wt(x∧y): weights ≡ 0 mod 8 force wt(x∧y) ≡ 0 mod 4 in particular even, i.e. x·y = 0. Self-orthogonality gives C ⊆ C⊥ so every C-word is a C⊥-word. ∎

**Proposition 1.2 (basis criterion).** A subspace with basis g₁,…,g_k is triply-even iff wt(gᵢ) ≡ 0 (mod 8), wt(gᵢ∧gⱼ) ≡ 0 (mod 4) for i<j, and wt(gᵢ∧gⱼ∧gₖ) ≡ 0 (mod 2) for i<j<k.

*Proof.* wt(⊕_{i∈T₀} xᵢ) = Σ_{∅≠T⊆T₀} (−2)^{|T|−1} wt(∧_{i∈T} xᵢ); terms with |T| ≥ 4 carry a factor 8. Reduce mod 8. ∎

This is the exact-arithmetic shadow of the symmetry cascade (singles mod 8, pairs mod 4, triples mod 2) and is what makes subspace search cheap.

**Proposition 1.3 (finite-geometry reformulation).** Let C have generator matrix with column multiset S ⊆ F₂^k (k = dim C). Then C is triply-even iff every nontrivial Walsh coefficient W(u) = Σ_{v∈S} (−1)^{u·v} satisfies W(u) ≡ n (mod 16); and d(C⊥) equals the minimum size of a dependency in S (zero column = size 1, repeated column = size 2, so d⊥ ≥ 4 ⟺ S is a cap, d⊥ ≥ 5 ⟺ S is a Sidon set in F₂^k). Moment identities: Σ_{u∈F₂^k} W(u)^j = 2^k · #{(v₁,…,v_j) ∈ S^j : Σvᵢ = 0}.

*Proof.* wt of the codeword indexed by u is #{j : u·cⱼ = 1} = (n − W(u))/2; ≡ 0 mod 8 ⟺ W(u) ≡ n mod 16. Dependencies among columns are exactly dual codewords. Moments: expand and sum characters. ∎

The strip problem is therefore a cap/Sidon problem with a mod-16 Walsh rigidity constraint — squarely in the finite-geometry lane of the wider program.

**Proposition 1.4 (Sidon dimension bound; repaired).** If d(C⊥) ≥ 5 then C(n,2) ≤ 2^k − 1, hence |C| = 2^k ≥ 2^⌈log₂(n(n−1)/2 + 1)⌉.

*Proof.* Distinct pairs of (necessarily distinct, nonzero) columns have distinct nonzero sums. Round up to a power of two since |C| is one. ∎

*Correction log.* An earlier run used |C| ≥ n²/2, which is slightly stronger than Sidon justifies. The certificates produced under it remain valid because at every certified length the justified power-of-two bound dominates the bound actually used (checked case by case), and adding a weaker-than-used constraint can only enlarge the feasible set — but all rerun certificates below use only the justified bound.

### 1.2 Exact Delsarte certificates [C]

Feasibility system for a linear triply-even code of length n with d(C⊥) ≥ 5: variables A_w ≥ 0 for w ∈ {8, 16, …} ∩ [8, n], A₀ = 1; Σ_w A_w K_j(w) = 0 for j = 1..4 and ≥ 0 for j = 5..n (Krawtchouk / MacWilliams, B_j = dual weight distribution); plus Proposition 1.4. Infeasibility of this system is a theorem of nonexistence.

**Methodology note (why exact).** A floating-point LP (HiGHS) *failed its sanity battery*: it declared (n, d⊥) = (256, 8) infeasible although RM(2,8) realizes it — Krawtchouk coefficients reach ~10⁷⁵ and the solver returns garbage. All floating LP output was discarded. The certified path uses exact rational arithmetic throughout: eliminate the four equalities by exact Gaussian elimination, then decide the low-dimensional polyhedron by exact Phase-I simplex (Bland's rule; artificials only where needed) and, independently for n ≤ 56, exact Fourier–Motzkin. Sanity battery passed by the exact methods: (16,4) feasible [RM(1,4) exists], (32,4) feasible [RM(1,5) exists], (16,5) infeasible [independent hand proof: B₁=B₂=B₃=0 forces A₈=30, A₁₆=1, whence B₄ = 4480 ≠ 0], and n = 16..56 agree across both exact methods. Two implementation bugs were caught *by the sanity battery, before any claim*: a Phase-I objective that silently dropped artificials, and an unconditional application of the Sidon constraint to d⊥ = 4 instances where it is unjustified.

**Theorem 1.5 [C].** For every length 9 ≤ n ≤ 69 and every 75 ≤ n ≤ 80, no triply-even binary code with d(C⊥) ≥ 5 exists. Consequently every triply-even code at these lengths has U(C) ≤ 3, and the t = 1 diagonal rigidity boundary is flat at uniformity 3 there: any CSS coset state of these lengths carrying transversal T is at most 3-uniform.

**Open window [O].** At n = 70, 71, 72, 73, 74 the LP is feasible and gives no conclusion; at n = 72 this persists even after enumerating the code dimension exactly (|C| = 2^k, k = 12..29, with A_w ≤ C(n,w) upper bounds — every k feasible). The LP's killing power ends beyond the window: n = 88 and 96 are feasible. Whether an actual code with U = 4 exists at 70 ≤ n ≤ 74 is open; randomized construction found nothing, but see the search-status correction below.

**Search status [N; correction].** The earlier randomized "direct search found no d⊥ ≥ 5 code up to n = 48" was structurally vacuous: the incremental strength-4 filter cannot be satisfied at dimension 1 (any small code has zero columns), so the search never grew anything. The valid search data is: (i) all triply-even subcodes of the [24,12,8] Golay found by extensive randomized growth are coordinate-degenerate (d⊥ = 2) — a curiosity worth explaining via the hexacode structure; (ii) triply-even subcodes of RM(2,5) plateau at d⊥ = 4 (dim 6–9). The nonexistence load in Theorem 1.5 is carried entirely by the exact LP certificates, which are search-independent.

### 1.3 The staircase picture

Constructive side: RM(r, 4r) is triply-even with d⊥ = 2^{r+1}, giving U = 2n^{1/4} − 1 at n = 16, 256, 4096, …. Certified side: U = 3 for all 16 ≤ n ≤ 69 and 75–80. So the boundary function U*(n) = max{U(C) : C triply-even, length n} satisfies: U*(n) = 3 on [16, 69] ∪ [75, 80]; U*(n) ∈ {3, 4} on [70, 74]; U*(256) ≥ 7. There is no universal constant bound (RM(2,8) breaks 4 at 256), so the plateau is a genuinely small-n phenomenon and the real question is growth:

**Open question 1.6.** Is limsup log U*(n)/log n = 1/4 (RM staircase optimal), or does U* grow faster along some other family? Sub-question: is U* nondecreasing-in-steps localized near RM lengths (staircase) or does it interpolate?

**Sector caveat.** All of §1 is the t = 1 (transversal-T / triply-even) sector. The full diagonal boundary maximizes over weighted conditions t·x ≡ 0 mod 8 (equivalently: SNF elementary divisor divisible by 8), a strictly wider class; the LP analogue there needs t-weighted enumerators and is untouched [O].

---

## 2. Qudit sectors (p an odd prime) [T]

Setup: C ⊆ F_pⁿ linear, coset state |C⟩ = |C|^(−1/2) Σ_{x∈C}|x⟩ on n qupits. A diagonal product symmetry is ⊗_j D_j with D_j = diag(e^{iθ_j(a)})_{a∈F_p} and (⊗D_j)|C⟩ ∝ |C⟩, i.e. Σ_j θ_j(x_j) ≡ const for all x ∈ C. For finite-order symmetries write θ_j = (2π/N)·t_j with t_j : F_p → Z/N, and split N by CRT into its p-part and prime-to-p part; this section proves rigidity for two sectors of the p-part. Single-qudit diagonal Cliffords for odd p are exactly the quadratic phases ω_p^{αa²+βa} up to global phase [I: Cui–Gottesman–Krishna 2017; standard].

Two distinct enemies exist for qudits: the **degree enemy** (phases of order p but polynomial degree ≥ 3 in a — for p ≥ 5 this includes the Howard–Vala qudit T, a cubic ω_p-phase) and the **level enemy** (phases of order p^ℓ, ℓ ≥ 2, linear in the integer lift — the ω_{p²}-linear gates, non-Clifford by direct conjugation check). For p = 3 the standard T-analogue is an ω₉-*quadratic*, which lies in neither sector below; p = 3 is flagged open.

**Lemma 2.0 (engine).** Let p be an odd prime, f_j : F_p → F_p with Σ_j f_j(x_j) ≡ const for all x ∈ C. If C^{∘m} = F_pⁿ for all 3 ≤ m ≤ p − 1, then every f_j is a polynomial of degree ≤ 2.

*Proof.* Represent each f_j by its interpolating polynomial of degree ≤ p−1; normalize f_j(0) = 0 (absorb constants). Induct downward on d = max_j deg f_j. Suppose d ≥ 3, and let a_{j,d} be the coefficient of x^d in f_j. Finite differences along the subgroup C: for y¹,…,y^d ∈ C the d-fold mixed difference of x ↦ Σ_j f_j(x_j) vanishes on C; each single-coordinate difference operator lowers degree by exactly one, so only the top-degree monomials survive d differences, contributing d!·a_{j,d}·y¹_j⋯y^d_j. Hence Σ_j a_{j,d}·y¹_j⋯y^d_j = 0 for all y^i ∈ C, i.e. the vector (a_{j,d})_j annihilates C^{∘d}. Since d ≤ p−1, d! is invertible; since C^{∘d} = F_pⁿ, a_{·,d} = 0. Degree drops; stop at d = 2. ∎

**Theorem 2.1 (degree sector, p ≥ 5).** If C^{∘m} = F_pⁿ for 3 ≤ m ≤ p−1, then every diagonal product symmetry of |C⟩ whose local phases have order dividing p is a local Clifford (indeed a quadratic-phase gate on each site). In particular transversal Howard–Vala-type cubic gates are excluded.

*Proof.* Order p means θ_j = (2π/p) f_j with f_j : F_p → F_p; the symmetry condition is Σ_j f_j(x_j) ≡ const on C. Lemma 2.0 gives deg f_j ≤ 2, which is the diagonal Clifford condition for odd p. ∎

**Theorem 2.2 (level sector, lift-linear, p ≥ 5).** Assume C^{∘m} = F_pⁿ for 3 ≤ m ≤ p−1 (which supplies C^{∘(p−1)} = F_pⁿ). Then every diagonal product symmetry of lift-linear form — θ_j(a) = (2π/p^ℓ)·t_j·lift(a) with t_j ∈ Z/p^ℓ, lift : F_p → {0,…,p−1} — satisfies t ≡ 0 mod p^{ℓ−1}; i.e. the only lift-linear symmetries are the Z-type Paulis. The ω_{p²}-linear non-Clifford gates are excluded.

*Proof.* The condition is Σ_j t_j lift(x_j) ≡ 0 mod p^ℓ for all x ∈ C (x = 0 fixes the constant). For x, y ∈ C use lift(x_j + y_j) = lift(x_j) + lift(y_j) − p·carry_j(x,y) with carry_j = [lift(x_j) + lift(y_j) ≥ p]; applying the condition to x, y, x+y and subtracting gives Σ_j t_j carry_j(x, y) ≡ 0 mod p^{ℓ−1}. If ℓ ≥ 2, reduce mod p and fix y: with b = lift(y_j), the function g_b(a) = [a ≥ p − b] on F_p satisfies: the coefficient of a^{p−1} in its interpolating polynomial is −Σ_a g_b(a) = −b (standard: f(x) = Σ_a f(a)(1 − (x−a)^{p−1})). So x ↦ Σ_j t̄_j g_{lift(y_j)}(x_j) is a sum of coordinate functions vanishing on C with degree-(p−1) coefficient vector (−t̄_j·lift(y_j))_j. Since p ≥ 5, p−1 ≥ 3 ≥ 3, Lemma 2.0's induction applies at degree p−1 and forces t̄_j·lift(y_j) = 0 for all j and all y ∈ C. Full Schur powers imply no coordinate of C is identically zero, so for each j some y has y_j ≠ 0, whence t̄_j = 0: t ≡ 0 mod p. Write t = p t′ and repeat at level ℓ−1. The residual level-1 gates diag(ω_p^{t_j a}) are Z-Paulis. ∎

**Chain remark [T].** Over F_p the Schur chain C^{∘m} is not automatically increasing; the hypothesis "full for all 3 ≤ m ≤ p−1" holds automatically when 1 ∈ C, and for generalized Reed–Solomon codes it follows from dim C^{∘m} = min(n, m(k−1)+1), which is ≥ n for all m ≥ 3 once k ≥ (n+2)/3.

**Corollary 2.3 (qudit MDS/AME, p ≥ 5).** For a GRS code C over F_p with k ≥ (n+2)/3 — in particular the RS constructions of AME states, k = n/2 — every diagonal product symmetry of |C⟩ in the degree sector (order-p phases) or the lift-linear level sector is local Clifford/Pauli. This rederives, at mechanism level and for these sectors, the diagonal part of the qudit AME rigidity theorem, and pinpoints the two algebraic facts responsible: invertibility of small factorials (degree) and the −b leading coefficient of the carry indicator (level).

**General p-power sector [O with roadmap].** For arbitrary functions t_j : F_p → Z/p^ℓ the two mechanisms interleave: reducing mod p and applying Lemma 2.0 leaves quadratics; dividing the residual by p produces carry-corrected non-separable terms whose analysis repeats the Theorem 2.2 cascade with quadratic lifts in place of linear ones. The bookkeeping is governed by the augmentation filtration:

**Lemma 2.4 (augmentation) [T].** In R[Z/p] with R = Z/p^ℓ, writing I for the augmentation ideal: I^{(p−1)k+1} ⊆ p^k·I for k ≤ ℓ. *Proof.* R[Z/p] ≅ R[T]/((1+T)^p − 1) with I = (T); (1+T)^p − 1 = T^p + p·T·u(T) with u(0) = 1 a unit, so T^p = −pTu, and T^{(p−1)k+1} = ((−pu)^k)T by induction. ∎

This bounds how many finite differences are needed before everything is p^k-divisible and is the backbone of the full (≈10-page) proof, which is scheduled but not written; p = 3 (ω₉-quadratic sector) and the prime-to-p part of the order are also open. Nothing in §2's stated theorems depends on these gaps.

---

## 3. Beyond diagonal: the semi-Clifford reduction

**Fact 3.1 [I — verified this session].** Every single-qudit gate in *any* level of the Clifford hierarchy (prime dimension) is semi-Clifford, i.e. of the form C D C′ with C, C′ Clifford and D diagonal: de Silva–Lautsch, Proc. R. Soc. A 481:20250035 (2025) (arXiv 2501.07939), Theorem 4.16; building on Zeng–Chen–Chuang, PRA 77, 042313 (2008) (all one- and two-qubit hierarchy gates), de Silva 2020 (single-qudit level 3), de Silva–Chen, Commun. Math. Phys. (2024) (two-qudit level 3). The known non-semi-Clifford examples require ≥ 3-qubit gates (level ≥ 4: ZCC; level 3 with n ≥ 7 qubits: Gottesman–Mochon via Beigi–Shor) and are irrelevant to product symmetries with single-site factors. Beigi–Shor's generalized-semi-Clifford theorem for all of C₃ is not needed here.

**Theorem 3.2 (torsor reduction) [T].** Let ψ be a stabilizer state and U = ⊗_j C_j D_j C_j′ a product operator with single-qudit Clifford C_j, C_j′ and diagonal D_j. Then Uψ ∝ ψ iff (⊗D_j)φ ∝ χ, where φ = (⊗C_j′)ψ and χ = (⊗C_j†)ψ are stabilizer states. For fixed dressings, the set 𝒟(φ, χ) = {diagonal product D : Dφ ∝ χ} is either empty or a coset D₀·𝒟(φ, φ) of the diagonal symmetry group of φ. Consequently, the entire sector of product symmetries whose local factors lie in the Clifford hierarchy (any level) is decided by the diagonal classification (lattice/SNF machinery) applied across the finite local-Clifford orbit of ψ.

*Proof.* The equivalence is rearrangement. If D₁, D₂ ∈ 𝒟(φ,χ) then D₂^{-1}D₁ is a diagonal product symmetry of φ, and conversely D₀·𝒟(φ,φ) ⊆ 𝒟(φ,χ): empty-or-coset. Local factors in the hierarchy are semi-Clifford by Fact 3.1, so every such symmetry arises this way; the relevant dressings matter only through the finite local-Clifford orbit (mod diagonal Cliffords). ∎

*Honest scope notes.* (i) The companion note's Theorem 1 classifies 𝒟(φ, φ) for CSS coset states; general stabilizer φ carries an additional quadratic/ω₄ phase prefactor and Theorem 1's lattice argument extends to that affine-twisted setting routinely, but the extension is asserted, not written — flagged. (ii) What Theorem 3.2 does *not* cover: local factors of finite order outside the hierarchy (eigenframes that are not stabilizer bases). That residue is exactly where the hard part of the general LU-LC landscape lives; no claim is made there. (iii) Mandatory novelty audit before anything ships: Gross–Van den Nest, "The LU-LC conjecture, diagonal local operations and quadratic forms over GF(2)", QIC 8, 263 (2008) — the closest prior work to the whole diagonal program (their reduction of the LU-LC *equivalence* problem to diagonal operations must be compared against our *symmetry* classification); Cui–Gottesman–Krishna 2017 (diagonal hierarchy); the CSS-T literature (Rengaswamy et al.).

---

## 4. Scoreboard and next actions

Proved/certified today: Theorem 1.5 (plateau, exact certificates at 68 + 6 lengths), Propositions 1.1–1.4, Lemma 2.0, Theorems 2.1–2.2, Lemma 2.4, Corollary 2.3, Theorem 3.2, plus Fact 3.1's citation verified to the actual theorem number. The certified plateau is the strongest single item: yesterday's conjecture ("boundary flat at small n") is now a theorem on [9, 69] ∪ [75, 80], with the open window [70, 74] sharply localized. The qudit theorems turn the AME diagonal rigidity from a classification into a mechanism (factorials + carry leading coefficients). The semi-Clifford reduction converts the "diagonal-only" caveat into "hierarchy-factor sector," with the genuinely-open residue named precisely.

Corrections logged this session (all caught by sanity batteries before any claim shipped): float-LP discard after RM(2,8) sanity failure; Sidon-bound repair with per-length dominance check; Phase-I artificial-objective bug; unconditional-Sidon bug; vacuity of the earlier direct randomized search.

Next actions, in order of leverage: (1) close [70, 74] — either a code (S-set search in the Prop 1.3 formulation with Walsh-mod-16 filtering, or exhaustive over small k) or stronger certificates (quadratic constraints from Prop 1.2's pair conditions, i.e. semidefinite/Terwilliger refinement of the LP); (2) archive Farkas duals for Theorem 1.5 as standalone rational certificates; (3) write the general p-power proof over Lemma 2.4 and the p = 3 sector; (4) the weighted-t LP (general diagonal sector); (5) the Gross–Van den Nest audit; (6) the affine-twisted extension of Theorem 1 to general stabilizer φ.

Verification scripts: /home/claude/strip_search.py, strip_search2.py (search; see vacuity note), strip_exact2.py + strip_exact2_lib.py (Fourier–Motzkin), strip_simplex.py, strip_sub.py + scan_range.py (certified path), strip_lp.py (discarded float path, retained as a cautionary artifact).
