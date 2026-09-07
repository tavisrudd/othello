# C1090 literature audit — cubic-phase transversal gates on 2p-point evaluation CSS codes

**Date**: 2026-09-07. **Lane**: quantum-codes (spinoff of the finite-geometry secant/sheet-sign work).
**Purpose**: priority/novelty search for a possible quantum-information spinoff. Verdicts are per
question Q1–Q5 as posed in the task brief.

## Object under audit (given, not re-derived here)

For p = 7, 11: CSS codes [[14,6,2]]_7 and [[22,10,2]]_11 over F_p; X-stabilizer = all-ones vector
<1>; Z-stabilizer L^⊥ = D L where L (dim p) is an affine evaluation space on 2p points
x_i ∈ F_p^{p−1} carrying sheet signs ε_i = ±1 with Σε_i = 0, Σε_i x_i = 0, Σε_i x_i⊗x_i = 0,
Σε_i x_i^{⊗3} ≠ 0. Signed transversal cubic phase ⊗_i M^{ε_i}, M|z> = ω^{z^3}|z>, preserves the code
and induces logical F(u) = Σ ε_i (x_i·u)^3 on p−1 logical qudits. F is PSL_2(p)-invariant:
4sI + 3J in the binary quartic invariants for p = 7; 4sI_2 + 2I_3 in binary octavic invariants for
p = 11. |F> not Clifford-equivalent to any tensor product containing a single-qudit cubic-phase
state (Pauli-spectrum argument). Native synthillation-style factory with exact acceptance and
block-infidelity formulas derived.

## Evidence conventions

Each entry is marked **[source text]** (statement confirmed by reading the paper's own words, via
abstract page or full text as noted) or **[abstract only]** (inferred from abstract/listing metadata
without opening full text). Searched domains and stop conditions are recorded per question.

---

(Findings appended below as the search proceeds.)
## Q1 — the general mechanism: weighted transversal degree-r diagonal phase on an evaluation CSS code

**Claim under test.** A CSS code with X-space <1> and Z-space L^⊥ (L an evaluation space containing
1) admits the weighted transversal phase ⊗_i M_i, M_i|z> = ω^{w_i z^r}|z>, acting as a logical
degree-r phase polynomial, iff w annihilates the Schur power L^{∘(r−1)} (equivalently, iff all
mixed r-th moments Σ_i w_i f_1(i)···f_{r}(i) vanish for f_j ∈ L up to the r-th one).

### Strongest prior art

1. **Jeongwan Haah, "Towers of generalized divisible quantum codes", Phys. Rev. A 97, 042327 (2018),
   arXiv:1709.08658.** [source text — Definition III.1 and Lemma V.3 read via ar5iv HTML]
   Haah's generalization of divisibility is *exactly weighted*: he fixes "an odd integer vector" t
   and defines the ν-norm of v ∈ F_2^n as ‖v‖_ν = Σ_i v_i t_i mod 2^ν, with v, w "ν-orthogonal if
   Σ_i v_i w_i t_i = 0 mod 2^{ν−1}". Lemma V.3: "On the code space of Q[G,t], a transversal T_ν gate
   is the product of T̃_ν over all logical qubits, i.e., ⊗_i T_ν^{t_i} = ∏_{j=1}^k T̃_ν."  So the
   physical gate carries a *per-qubit weight* t_i and the enabling condition is that the weight
   vector annihilate the relevant Schur/moment products of the X-space. This is the qubit form of
   the mechanism, at every Clifford-hierarchy level, not just r = 3.
   **Crucially, Haah states the qudit case is open**: the discussion asks "whether one can construct
   towers of codes for qudits."

2. **Mark A. Webster, Armanda O. Quintavalle, Stephen D. Bartlett, "Transversal Diagonal Logical
   Operators for Stabiliser Codes", New J. Phys. 25 (2023), arXiv:2303.15615.** [source text — cached
   PDF text, abstract + overview read] Gives algorithms that "identify all transversal diagonal
   logical operators on a CSS code", where the physical operator is a product of *single-qubit phase
   gates with independently chosen phases* (represented as diagonal XP operators), plus a synthesis
   direction (build a CSS code with a prescribed diagonal logical operator from single-qubit phase
   gates). This is the qubit "iff" statement in algorithmic form. **Qubits only** — no occurrence of
   "qudit"/"prime dimension"/"non-binary" in the text.

3. **Anirudh Krishna, Jean-Pierre Tillich, "Towards low overhead magic state distillation", PRL 123,
   070507 (2019), arXiv:1811.08461** and **Shiroman Prakash, Tanay Saha, "Low overhead qutrit magic
   state distillation", Quantum 9, 1768 (2025), arXiv:2403.06228.** [abstract only + Error Correction
   Zoo entry `qudit_triorthogonal`, read as source] These define the **prime-qudit triorthogonal
   code**: rows r_1,…,r_m over F_p with |r_i · r_j| = 0 (mod p) and |r_i · r_j · r_k| = 0 (mod p),
   giving "a transversal gate from the third level of the qudit Clifford hierarchy". This is the
   **unweighted** (w = 1) qudit special case of the mechanism: it is exactly "1 annihilates
   L^{∘2}", with no per-qudit weight vector.

4. **Earl T. Campbell, Hussain Anwar, Dan E. Browne, "Magic state distillation in all prime
   dimensions using quantum Reed-Muller codes", PRX 2, 041021 (2012), arXiv:1205.3104.**
   [abstract only + Error Correction Zoo `qudit_reed_muller`] Prime-qudit quantum RM codes from
   first-order punctured GRM codes "transversally implement a diagonal gate at any level of the qudit
   Clifford hierarchy". Again an evaluation-code (GRM) X-space with an *unweighted* transversal
   diagonal gate.

5. **Tanay Saha, Shiroman Prakash, "Sublogarithmic distillation in all prime dimensions using
   punctured Reed-Muller codes", arXiv:2510.10852 (12 Oct 2025).** [source text — abstract]
   Generalizes Hastings–Haah punctured-RM distillation to arbitrary prime p; asymptotic yield
   γ → 1/ln p; computational puncture search yielding "several interesting triorthogonal codes,
   including a [[519,106,5]]_5 code with γ = 0.99". Prime-qudit triorthogonal (unweighted) again;
   the codes are punctured RM, not signed two-sheet configurations.

6. **Narayanan Rengaswamy, Robert Calderbank, Michael Newman, Henry D. Pfister, "On optimality of CSS
   codes for transversal T", IEEE JSAIT 1 (2020), arXiv:1910.09333, and "Classical coding problem
   from transversal T gates", arXiv:2001.04887.** [source text — cached PDF text grepped] Both are
   **qubit-only**: no occurrence of "qudit", "non-binary", or "prime dimension" in either extraction.
   They characterize CSS codes supporting (quasi-)transversal Z-rotations in terms of divisibility
   of C_2 codeword Hamming weights — the unweighted binary condition.

7. **Jingzhen Hu, Qingzhong Liang, Robert Calderbank, "Climbing the diagonal Clifford hierarchy",
   arXiv:2110.11923.** [abstract only] Synthesis of CSS codes realizing a target diagonal logical
   gate at level ℓ; **qubits only, uniform physical gate** (no per-qubit weights).

8. **K. Sai Mineesh Reddy, Navin Kashyap, "Realizing logical diagonal gates via transversal physical
   Z-rotations in CSS codes", arXiv:2608.19094 (Aug 2026).** [abstract only] Characterizes nested
   classical code pairs whose CSS codes realize target logical diagonal gates by transversal physical
   Z-rotations, plus an "appending construction". Qubit CSS codes; abstract does not commit to
   per-qubit varying angles.

### Q1 verdict: **PARTIALLY KNOWN**

The *weighted* mechanism with per-site phase exponents is established prior art **for qubits**
(Haah 2018, explicit coefficient vector t and ⊗_i T_ν^{t_i}; Webster–Quintavalle–Bartlett 2023, full
algorithmic "find all such operators"). The published *qudit* statements are the **unweighted**
specialization: prime-qudit triorthogonality (Krishna–Tillich 2019; Prakash–Saha 2025;
Saha–Prakash 2025) and prime-qudit RM (Campbell–Anwar–Browne 2012). No source found stating the
weighted-qudit "iff w ⊥ L^{∘(r−1)}" criterion; Haah explicitly flags the qudit direction as open.
So the general mechanism is not novel in spirit, but the odd-prime-qudit weighted formulation with
the Schur-power characterization appears **unclaimed as a stated theorem**. Present it as the
qudit analogue of Haah's generalized divisibility, cite Haah and Webster et al. explicitly, and do
not claim first discovery of the weighted idea itself.

---

## Q2 — the specific codes [[2p, p−1, 2]]_p, and PGL_2(p)-orbit / conic-secant geometry

### What exists nearby

- **Prime-qudit triorthogonal family, [[9m−k, k, 2]]_3** (Prakash–Saha, *Quantum* 9, 1768 (2025),
  arXiv:2403.06228; family recorded on the Error Correction Zoo `qudit_triorthogonal` page).
  [source text — zoo entry] Same *shape* as our object (distance 2, k logical qudits, transversal
  third-level gate) but qutrits only, length 9m−k, and unweighted triorthogonality. For p = 3 our
  family would read [[6,2,2]]_3, which is not in this family.
- **Bravyi–Haah [[3k+8, k, 2]] qubit triorthogonal codes** — the qubit archetype of a distance-2
  block code with k logical T's per block. Our [[2p, p−1, 2]]_p is the natural qudit analogue in
  shape (length linear in k, distance 2), not a case of it.
- **Krishna–Tillich (PRL 123, 070507 (2019), arXiv:1811.08461)** [abstract only]: constant-rate,
  linear-distance qudit family with transversal non-Clifford gate, but (per secondary summaries in
  Golowich–Lin arXiv:2408.09254 and Saha–Prakash arXiv:2510.10852) **the qudit dimension grows with
  the code size** — the opposite regime from a fixed small p with n = 2p.
- **Prime-qudit RM / RS codes** (Campbell–Anwar–Browne, PRX 2, 041021 (2012), arXiv:1205.3104;
  Sarvepalli–Klappenecker 2005). Length q^m (RM) or q (RS) evaluation codes; the transversal gate is
  unweighted; the point set is a full affine/projective space or a punctured line, never a
  **two-sheeted signed configuration of 2p points**.
- **Transversal-AND / [[6,2,2]]_3 qutrit code** (arXiv:2603.04548, "Transversal AND in quantum
  codes"). [abstract only, via search snippet] A [[6,2,2]] qutrit code with a transversal AND gate
  obtained from a symmetric T-depth-one circuit decomposition. **This is a genuine near-collision on
  parameters at p = 3** and must be checked in full text before any p = 3 statement is made; it is a
  circuit-derived construction, not a PGL_2(3)-orbit / conic-secant one, and the gate is AND
  (multi-qudit), not a single-site cubic phase.
- **Qudit CCZ / C^{r−1}Z transversal families** (Golowich–Lin, arXiv:2408.09254 and 2410.14631;
  arXiv:2606.27211 "Quantum group codes for non-Clifford logic"; arXiv:2606.22472). Asymptotic-rate
  constructions from classical codes with a multiplication property — the same Schur-product
  mechanism, but aimed at asymptotically good families, not small exceptional configurations.

### What does not exist

No source found for **[[14,6,2]]_7**, **[[22,10,2]]_11**, a general **[[2p, p−1, 2]]_p** family, or
any qudit code whose transversal non-Clifford gate is built from a **PGL_2(p) / PSL_2(p) orbit of
perfect matchings, conic secants, or a two-sheeted point configuration with ±1 sheet signs**. The
Error Correction Zoo's qudit-transversal and magic-yield lists contain only: prime-qudit RM,
prime-qudit RS, prime-qudit triorthogonal, modular-qudit lattice color codes, quantum AG codes,
Galois-qudit expander codes, the [[11,1,5]]_3 qutrit Golay code, and the [[9m−k,k,2]]_3 family. None
is length 2p, and none uses finite-geometric orbit data of this kind.

### Q2 verdict: **UNCLAIMED**

Three independent negative checks: (i) Error Correction Zoo lists `quantum_transversal`,
`quantum_magic`, `qudit_triorthogonal`, `qudit_reed_muller` — no length-2p entry; (ii) WebSearch on
the literal parameter strings "[[14,6,2]]" and "[[22,10,2]]" plus qudit/transversal keywords — no
hit; (iii) arXiv API metadata query `abs:"cubic phase" AND abs:"qudit" AND abs:"code"` — **zero
results**. Stop condition: exhausted the zoo's qudit-transversal taxonomy plus parameter-literal and
mechanism-keyword search. Residual risk is a paper that states the code only inside its text
(arXiv full text is not indexed by these searches) and the [[6,2,2]]_3 transversal-AND paper above.

---

## Q3 — phase polynomials that are invariants of binary forms

### Strongest prior art

- **Gabriele Nebe, E. M. Rains, N. J. A. Sloane, "The invariants of the Clifford groups", Des. Codes
  Cryptogr. 24 (2001) 99–121, arXiv:math/0001038**, and Nebe, "Codes and invariant theory", Math.
  Nachr. 274–275 (2004), arXiv:math/0311046. [abstract only] Invariant theory does appear in quantum
  coding, but in the opposite direction: the invariants of the **complex Clifford group** of degree
  2k are spanned by complete weight enumerators of self-dual codes (Runge's theorem). The invariant
  ring is the object being computed; it is not used as a *phase polynomial defining a gate*.
- **Akalank Jain, Shiroman Prakash, "Qutrit and ququint magic states", PRA 102, 042409 (2020),
  arXiv:2003.07164.** [source text — abstract fetched] Classifies non-stabilizer **Clifford
  eigenstates** for p = 3, 5, including states that are simultaneous eigenvectors of all Clifford
  symplectic rotations. This is the closest published "symmetry-defined magic state" idea: magic
  states singled out by invariance under a subgroup of the Clifford group. **Single-qudit only**,
  and the symmetry group is inside the Clifford group, not PSL_2(p) acting on a geometric point
  configuration, and the defining data is an eigenvector condition, not a classical-invariant-theory
  polynomial.
- **Mark Howard, Jiri Vala, "Qudit versions of the qubit π/8 gate", PRA 86, 022316 (2012),
  arXiv:1206.1598.** [abstract only — the arXiv abstract page does not print the phase polynomial]
  Derives all prime-dimension qudit third-level diagonal gates; the single-qudit cubic-phase gate
  M|z> = ω^{z^3} is the Howard–Vala gate (up to the quadratic/linear Clifford freedom). Relevant as
  the *name* for our single-site building block, not as prior art for an invariant-theoretic F.
  Follow-up literature notes that when p ≡ 1 mod 3 the cubic character of the leading coefficient
  splits the T gates into three Clifford-inequivalent types — directly relevant to how F's
  coefficient should be normalized at p = 7 (7 ≡ 1 mod 3) versus p = 11 (11 ≡ 2 mod 3).

### Q3 verdict: **UNCLAIMED**

No source found in which the phase polynomial of a Clifford-hierarchy gate or magic state is a
**classical invariant of a binary form** (quartic I, J; octavic I_2, I_3), nor any "invariant-
theoretic magic state" in that sense. Searched: "invariant theory" × binary forms × quantum gate /
phase polynomial / magic state / SL(2,p); octavic-invariant × non-Clifford × PSL(2,7). Stop
condition: search returns pure classical-invariant-theory references (Sage docs, Olver's text,
Wikipedia) on one side and pure magic-state references on the other, with no bridging work. This is
the most clearly novel of the five items and is the right thing to lead with.

---

## Q4 — coupled multi-qudit cubic-phase resources and non-equivalence certificates

### What exists

- **Coupled multi-qudit magic resources for prime qudits are established**: CCZ and Toffoli states
  are third-level for every odd prime p and admit magic-state injection; qudit-CCZ and C^{r−1}Z
  transversal code families are the current asymptotic frontier (Golowich–Lin arXiv:2408.09254,
  2410.14631; arXiv:2606.27211; arXiv:2512.21874 "Magic state distillation using asymptotically good
  codes on qudits"). [abstract only] So "a magic resource that is a genuinely coupled multi-qudit
  state rather than a product of single-qudit magic states" is **not novel per se** — CCZ is the
  standard example.
- **Clifford-equivalence certificates via Pauli data are established technique.** The symplectic
  criterion — Clifford conjugacy induces a symplectic bijection between Pauli supports — and the
  conjugacy-class enumeration of the single-qudit Clifford group are used by Jain–Prakash
  (arXiv:2003.07164) to classify Clifford-inequivalent qudit magic states. [inferred from abstract
  plus secondary summary; the symplectic-support sentence was returned by search summary, **not**
  read in source text — verify before citing that sentence verbatim.]
- **Pauli-spectrum magic monotones for qudits**: stabilizer Rényi entropy (Leone–Oliviero–Hamma,
  PRL 128, 050402 (2022)) with a qudit generalization (Y. Wang, Y. Li, *Quantum Inf. Process.* 22
  (2023), "Stabilizer Rényi entropy on qudits"); Clifford-invariant, additive on tensor products.
  [abstract only] Additivity on tensor products is precisely the lever a "not Clifford-equivalent to
  any product containing a single-qudit cubic state" argument uses, and this is standard.
- **Characteristic-function / Gauss-sum arguments**: the L^1 norm of the characteristic function
  (Fourier/Weyl transform) is an established qudit magic measure, and quadratic Gauss sums are the
  standard tool for evaluating Pauli expectations of Howard–Vala T states — used e.g. to argue
  optimality of the Howard–Vala gate among diagonal gates. [abstract/secondary only]
  Also relevant: Veitch–Mousavian–Gottesman–Emerson mana / discrete Wigner negativity for odd prime
  qudits.

### Q4 verdict: **PARTIALLY KNOWN**

Every *ingredient* is prior art: coupled multi-qudit magic states (CCZ), Clifford-equivalence
classification by Pauli support/symplectic action, Pauli-spectrum monotones and their tensor
additivity, Gauss-sum evaluation of qudit T-state Pauli expectations. What is not found is the
*instance*: a coupled (p−1)-qudit cubic-phase resource |F> defined by a PSL_2(p)-invariant cubic
form, together with a certificate that it is Clifford-inequivalent to any tensor product containing
a single-qudit cubic-phase state. Write the argument as a standard Pauli-spectrum computation and
cite the monotone/technique literature; the novelty claim belongs on the state, not the method.

---

## Q5 — synthillation for prime qudits

- **Earl T. Campbell, Mark Howard, "A unified framework for magic state distillation and multi-qubit
  gate synthesis with reduced resource cost", PRA 95, 022316 (2017), arXiv:1606.01904**, and the
  companion PRL 118, 060501 (2017), arXiv:1606.01906. [source text — arXiv HTML v5 read] **Qubit
  only**; no mention of qudits or d > 2 anywhere in the text. The framework defines
  **F-quasitransversality** ("a quantum code is F-quasitransversal if there exists a Clifford g such
  that g T^{⊗n} acting on the physical qubits realizes the logical gate U_F"), generalizing
  Bravyi–Haah triorthogonality. Theorem 1 gives success probability 1 − nε + O(ε²) and output error
  O(ε²) with n = τ[U] + 2μ[U] + Δ ≤ 3τ[U] + Δ noisy T states. **Equations (37)–(39) give exact
  acceptance and output-error expressions as sums over error patterns, reduced by MacWilliams
  identities to sums over span(S) — i.e. exact weight-enumerator formulas.** So "exact acceptance and
  block-infidelity formulas from weight enumerators" is squarely prior art *for qubits*.
- **No qudit synthillation found.** Searches over qudit/qutrit × gate synthesis × combined
  distillation returned only (a) qutrit circuit-synthesis papers with no distillation coupling
  (arXiv:1803.03228 normal form for single-qutrit Clifford+T; arXiv:2503.20203 Clifford+R;
  arXiv:1902.05634 qudit compiler), and (b) prime-qudit distillation papers with no synthesis
  coupling (Campbell–Anwar–Browne 2012; Prakash–Saha 2025; Saha–Prakash 2025). The one paper that
  couples them is Campbell–Howard, and it is qubit-only.

### Q5 verdict: **PARTIALLY KNOWN**

The synthillation *concept*, the quasitransversality definition, and the exact weight-enumerator
acceptance/infidelity machinery are Campbell–Howard's, and must be cited as such. The **prime-qudit
generalization is unclaimed**: no qudit synthillation protocol, and no qudit-side exact
weight-enumerator error analysis, was found. Frame our factory as "the odd-prime-qudit analogue of
Campbell–Howard synthillation", specialized to a weighted rather than uniform transversal gate.

---

## Searched domains and stop conditions (audit trail)

- **Local cache** `/tmp/persistent/tavis/lit-search` (1028 entries): keyword scan on
  campbell|haah|krishna|prakash|triorthogonal|magic|transversal|clifford|qudit|divisib|synthil|schur.
  Hits used as source text: arXiv:2303.15615 (Webster–Quintavalle–Bartlett), arXiv:1910.09333 and
  arXiv:2001.04887 (Rengaswamy et al., both confirmed qubit-only by grep for
  qudit/non-binary/prime dimension → no matches). Not cached: 1709.08658, 1205.3104, 1811.08461,
  2510.10852, 1606.01904 — all fetched live.
- **Error Correction Zoo**: `list/quantum_transversal`, `list/quantum_magic`, `c/qudit_triorthogonal`,
  `c/qudit_reed_muller` (`c/galois_triorthogonal` and `list/qudits_galois` are 404). Full qudit
  transversal-non-Clifford taxonomy enumerated; no length-2p or geometry-derived entry.
- **arXiv API metadata query**: `abs:"cubic phase" AND abs:"qudit" AND abs:"code"` → 0 results.
- **WebSearch**: parameter literals, weighted-triorthogonality phrasings, Schur/star-product
  transversal phrasings, invariant-theory × magic phrasings, Pauli-spectrum-equivalence phrasings,
  qudit synthillation phrasings. Stop condition per question recorded above.
- **Not done** (declare as a gap if a "to our knowledge" sentence goes into a manuscript): arXiv
  full-text search, Google Scholar, OpenAlex/Crossref/Semantic Scholar forward-citation closure on
  Haah 2018, Krishna–Tillich 2019, and Campbell–Howard 2017. Per the three-source rule for citation
  negatives, run those before any published novelty claim.

## Near-collision resolved: the [[6,2,2]]_3 qutrit code

**Christine Li, Lia Yeh, "Transversal AND in quantum codes", arXiv:2603.04548 (4 Mar 2026, rev. 17
Mar 2026).** [source text — abstract fetched] Constructs "a novel qutrit [[6,2,2]] quantum
error-correcting code with a transversal implementation of the AND gate", from two-qutrit Clifford+T
unitaries realizing AND with T-count 3 (3n−3 for n qubits), the code obtained by adding stabilizers
to a T-depth-one circuit. **Different object**: the transversal gate is a *two-qutrit* AND, not a
weighted single-site cubic phase; no PGL(2,p), conic, or signed two-sheeted configuration appears.
Parameters coincide with what our family would give at p = 3, so cite it and state the distinction
explicitly if p = 3 is ever mentioned; it does not pre-empt anything at p = 7 or 11.

