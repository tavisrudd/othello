# C1099/C1102 literature check: magic of cubic phase states over F_p

**Date**: 2026-09-07 · **Lane**: `clebsch` · **Tasks**: C1099, C1102
**Deliverable this audit serves**: novelty positioning for the research note on stabilizer Rényi
entropy (SRE) of diagonal cubic phase states on `k` qudits of odd prime dimension `p`.

Status: **complete for this pass.** See "Coverage statement" and "Search log" at the end for what was
and was not reached. **No source in this audit was read at full text**; two were read at `partial`
depth from arXiv HTML, the rest at `abstract/metadata only` or `secondary only`. Every verdict below
inherits that limit.

## Claims being checked (not re-derived here)

For `|F> = p^{-k/2} sum_{u in F_p^k} omega^{F(u)} |u>` with `F` a homogeneous cubic form over `F_p`:

- **(i) Pauli spectrum**: `|<F| X(v) Z(w) |F>| = p^{-rank H_F(v)/2}` when `w` is in the image of the
  Hessian `H_F(v)` and `0` otherwise (quadratic Gauss sum evaluation).
- **(ii) SRE from rank distribution**: every `M_alpha` is a function of `N_r = #{v : rank H_F(v) = r}`,
  via `sum_P |<P>|^{2 alpha} = sum_r N_r p^{r(1-alpha)}`.
- **(iii) Trace cubic**: `Tr_{F_{p^k}/F_p}(u^3)` has full Hessian rank at every nonzero `v`, so `M_2`
  is at the pure-state bound `log((p^k+1)/2)` to within 1e-5.
- **(iv) Non-product witness**: `M_2` Clifford-invariance + tensor additivity ⇒ a state whose `M_2`
  exceeds `max_a [ log((p^a+1)/2) + log((p^{k-a}+1)/2) ]` is not Clifford-equivalent to a product.

## Summary of verdicts

| Q | Question | Verdict | Strongest prior art |
|---|-------------------------------------------------|------------------|-------------------------------------------------------------|
| 1 | Hessian-rank / Gauss-sum Pauli spectrum of diagonal cubic phase states | **partially known** — `p = 2` published | Kagamihara-Tsuchiya, arXiv:2602.23687, Thm 1 / Eq. (12); ancestor Chen-Yan-Zhou, Quantum **8**, 1351 (2024) |
| 2 | `M_2 = log(p^2/(2p-1))` for the single-qudit cubic-phase state | **not found** for general `p`, but the value lies on a published curve | Knipfer et al., arXiv:2607.07197, Eq. (2); Liu-Low-Yin, arXiv:2502.17550 |
| 3 | `Tr(u^3)` as an extremal / Pauli-flat state; equality only for flat spectra | **known** as an MUB construction, under another name; the SRE reading was not found | Alltop (1980); Klappenecker-Rötteler, LNCS 2948 (2004); Wang-Li, QIP **22**, 444 (2023) |
| 4 | SRE additivity + per-factor bound as a non-product-under-Clifford witness | **not found** in this form | White-Cao-Swingle, PRB **103**, 075145 (2021), for the adjacent notion of nonlocal magic |
| 5 | Terminology and competing measures | **known / settled** | Leone-Oliviero-Hamma, PRL **128**, 050402 (2022); Wang-Li for the qudit definition |

**The two findings that change what the note should say.**

First, the qubit case of our Pauli-spectrum formula was published seven months ago. Kagamihara and
Tsuchiya's rank matrix `C(x) + C(x)^T` is literally the Hessian of the cubic Boolean form at the
shift `x`, so claims (i) and (ii) at `p = 2` are theirs. Our contribution has to be stated as the
odd-prime, genuine-Gauss-sum, general-cubic version.

Second, the trace cubic is Alltop's mutually-unbiased-bases fiducial, and its `M_2` is not merely
"near" the pure-state bound — it equals `log(D^2/(2D-1))` with `D = p^k` exactly, which is the value
conjectured to be the maximum for two-qudit systems by Knipfer, Roman, Matcheva and Matchev and
found numerically for two ququints (`ln(625/49)`). That is a stronger and cleaner claim than the
`1e-5` framing, and it makes our family an explicit construction of conjectured maximizers in every
dimension `p^k` with `p >= 5` and `k >= 2`. It also carries two corrections: for `k = 1` the state is
strictly sub-maximal (SIC fiducials beat it), and for `p = 3` the trace cubic degenerates to a
stabilizer state.

---

## Q1. Gauss-sum / Hessian-rank description of the Pauli spectrum of diagonal phase states

**Verdict: PARTIALLY KNOWN — the qubit (`p = 2`) case is published and is a direct structural
pre-emption; no qudit / odd-prime version was located.**

### The closest prior art: Kagamihara–Tsuchiya, "Stabilizer Rényi entropy of 3-uniform hypergraph states"

- arXiv:2602.23687 (quant-ph), Daichi Kagamihara and Shunji Tsuchiya; submitted 27 Feb 2026,
  revised 14 May 2026. Read depth: **partial** — abstract page plus the HTML full text at
  `https://arxiv.org/html/2602.23687`, read for the statement of Theorem 1 (Eq. 12), Section III.1
  (proof), and Appendix A (quadratic-form review). Not cached (HTML only; no PDF ingested).
- Their Theorem 1 / Eq. (12): the Pauli–Liouville moment of a 3-uniform hypergraph state is
  `m_alpha = 2^{-N} sum_x 2^{(1-alpha) * 2h(x)}`, where `2h(x)` is the **rank over GF(2) of the
  symmetric matrix `C(x) + C(x)^T`**, with `C_{i,j}(x) = sum_{k : (i,j,k) in E_3} x_k`.
- **That matrix is exactly our Hessian.** For the cubic Boolean form
  `F(a) = sum_{(i,j,k) in E_3} a_i a_j a_k`, the second difference `partial_i partial_j F` evaluated
  at the shift `x` is precisely `sum_{k : (i,j,k) in E_3} x_k`. So `C(x) + C(x)^T = H_F(x)` over
  GF(2), and their Eq. (12) is our claim (ii) specialized to `p = 2` (up to the normalization
  difference between the Pauli–Liouville moment `m_alpha` and our unnormalized
  `sum_P |<P>|^{2 alpha}`).
- Their proof route is also ours in miniature: reduce `Q = a^T C(x) a` to canonical form by a GF(2)
  linear change of variables and count solutions, i.e. the characteristic-2 substitute for a
  quadratic Gauss sum. Appendix A is a quadratic-form-over-GF(2) review.
- What they do **not** do: odd prime `p`, generalized Pauli / Weyl–Heisenberg operators
  `X(v) Z(w)`, the image-of-Hessian support condition on `w` (in characteristic 2 the analogous
  condition is folded into the GF(2) solution count), genuine quadratic Gauss sums, or any
  field-theoretic cubic such as `Tr(u^3)`.

### The prior generation: Chen–Yan–Zhou, "Magic of quantum hypergraph states"

- arXiv:2308.01886, Junjie Chen, Yuxuan Yan, You Zhou; Quantum **8**, 1351 (2024),
  DOI `10.22331/q-2024-05-21-1351`. Read depth: **abstract/metadata only** at time of writing
  (the `v3` HTML URL 404s; see Search log). Reported results: analytic stabilizer Rényi-`alpha`
  entropy formulas for general (not only 3-uniform) qubit hypergraph states; magic cannot be
  maximal when the average hypergraph degree is constant; random hypergraph states reach maximal
  magic; permutation-symmetric hypergraph states have constant or exponentially small magic for
  `alpha >= 2`. Qubits only.
- Relevance: this is the paper that established "diagonal-phase-state SRE has a closed form driven
  by a combinatorial invariant of the phase function" as a known genre. Our note must cite it as
  the ancestor of the whole approach even though the invariant there is not stated as a Hessian
  rank.

### Weyl sums over finite fields already evaluate exactly this object

The characteristic-`p` version of the same computation is standard in the mutually-unbiased-bases
(MUB) literature, where it is done with Weyl sums rather than under a "magic" heading:
W. O. Alltop's cubic-phase sequences (1980) and their finite-field generalization by Klappenecker
and Rötteler (2004) rest on evaluating `sum_u omega^{Tr[(u+b)^3 + v(u+b)]}` over `F_{p^n}`,
`p >= 5`. See Q3 for the details and the pinpoint. Our (i) is the same Weyl-sum evaluation phrased
as a Weyl-operator expectation value; what is not in that literature is the general (non-flat)
statement for an arbitrary cubic `F`, where the answer is governed by the Hessian rank at `v`.

**What our note may still claim after this**: the *odd-prime-`p` qudit* statement — the Weyl
expectation `|<F|X(v)Z(w)|F>| = p^{-rank H_F(v)/2}` supported exactly on `w in im H_F(v)`, obtained
from a genuine quadratic Gauss sum, and the resulting reduction of every `M_alpha` to the Hessian
rank distribution `N_r`. The `p = 2` specialization must be attributed to Kagamihara–Tsuchiya
(Theorem 1) and positioned as the characteristic-2 shadow of the Gauss-sum computation, not as new.

---

## Q2. Is `M_2 = log(p^2/(2p-1))` for the single-qudit cubic-phase state published?

**Verdict: NOT FOUND as a stated closed form for general odd prime `p`; the pattern it belongs to is
published, and the value must be positioned inside that pattern rather than as an isolated
computation.**

What is published is the same expression as a *maximum* over states of a fixed total Hilbert-space
dimension `D`, with the qudit Pauli group of `Z_d^n`:

| System     | `D` | published max `M_2`  | as `D^2/(2D-1)` | source                                       |
|------------|-----|----------------------|-----------------|----------------------------------------------|
| 2 qubits   | 4   | `ln(16/7) ~ 0.827`   | `16/7`          | Liu-Low-Yin, arXiv:2502.17550                |
| 2 qutrits  | 9   | `ln(81/17) ~ 1.561`  | `81/17`         | Knipfer et al., arXiv:2607.07197             |
| 2 ququints | 25  | `ln(625/49) ~ 2.546` | `625/49`        | Knipfer et al., arXiv:2607.07197 (numerical) |

Knipfer, Roman, Matcheva and Matchev state this as a conjecture, their Eq. (2):
`max(M_2) <= ln[d^4 / (2 d^2 - 1)]` for two qudits of prime dimension `d` — i.e. exactly
`ln[D^2/(2D-1)]` with `D = d^2`. Liu, Low and Yin conjecture the analogous statement for `n` qubits
with the exception `n != 1, 3`.

**Our `M_2` values sit exactly on that curve.** With claim (iii)'s full-rank Hessian at every
`v != 0`, the rank distribution is `N_0 = 1`, `N_k = p^k - 1`, so
`sum_P |<P>|^4 = 1 + (D-1)/D = (2D-1)/D` with `D = p^k`, giving `M_2 = log(D^2/(2D-1))` **exactly**,
not merely near the flat bound `log((D+1)/2)`. For `k = 1` that is `log(p^2/(2p-1))`.

Two consequences the note should state, in place of the "within 1e-5 of `log((p^k+1)/2)`" framing:

1. For `k = 1` the cubic-phase state is **strictly sub-maximal**. A single qudit's Pauli group *is*
   the Weyl-Heisenberg group of `Z_p x Z_p`, so a WH-covariant SIC fiducial (Zauner) has a flat
   Pauli spectrum and attains `log((p+1)/2) > log(p^2/(2p-1))`. Calling the single-qudit
   cubic-phase state "maximally magic" would be wrong.
2. For `k >= 2` the flat value is conjecturally unattainable (the relevant group is
   `Z_p^k x Z_p^k`, not `Z_D x Z_D`), and our states hit `log(D^2/(2D-1))` on the nose. For
   `p = 5, k = 2` that is `ln(625/49)`, exactly Knipfer et al.'s numerically located two-ququint
   maximum.

**Caution on `p = 3`.** Over `F_3`, `x |-> x^3` is the Frobenius, so
`Tr_{F_{3^k}/F_3}(u^3) = Tr_{F_{3^k}/F_3}(u)` is `F_3`-linear and the "cubic phase state" is a
stabilizer state with zero magic. The construction needs `p >= 5`, which is exactly Alltop's
hypothesis (Q3). The `ln(81/17)` two-qutrit maximizers of Knipfer et al. are therefore *not* trace
cubics; two ququints is the first case where our family meets theirs.

**What our note may still claim**: the exact closed form for `M_alpha` across the whole family as a
function of the Hessian-rank distribution, and — the sharp claim — an explicit algebraic family
attaining the conjectured maximum `log(D^2/(2D-1))` for every `D = p^k` with `p >= 5`, `k >= 2`,
where the published record has only `d = 3, 5` at `n = 2` and no construction at all.

---

## Q3. Trace cubic `Tr(u^3)` as an extremal / Pauli-flat state; equality in the pure-state bound

**Verdict: KNOWN in the mutually-unbiased-bases literature under a different name — the state is
Alltop's cubic-phase fiducial — but its stabilizer-Rényi-entropy reading was not found. The
"equality only for flat spectra" fact is known.**

### The state is Alltop's

- W. O. Alltop, "Complex sequences with low periodic correlations," IEEE Trans. Inform. Theory
  **26** (1980), 350-354, constructed, for prime `p >= 5`, sequences with phases `omega^{u^3}` whose
  shifts and modulations give a complete set of mutually unbiased bases (MUBs). Read depth:
  **secondary only** — via the MUB review and orbit papers below; the 1980 paper itself was not
  obtained (see Coverage statement).
- A. Klappenecker and M. Rötteler, "Constructions of mutually unbiased bases," in *Finite Fields and
  Applications (Fq7)*, LNCS 2948, Springer (2004), 137-144, DOI `10.1007/978-3-540-24633-6_10`,
  generalized Alltop to `d = p^n`, `p >= 5`, with bases built from
  `omega^{Tr[(u+b)^3 + v(u+b)]}` over `F_{p^n}`; the proof "follows from a result on Weyl sums over
  finite fields," applicable only for odd `p`. Read depth: **secondary only** — this
  characterisation is taken from the MUB review below, not from Klappenecker-Rötteler directly.
- Secondary sources carrying that characterisation: "Mutually Unbiased Bases in Composite
  Dimensions — A Review," arXiv:2410.23997, Quantum **10**, 2051 (2026); and "Orbits of Mutually
  Unbiased Bases," arXiv:1310.4684. Read depths in the Sources table.

**This is our (iii), restated.** "The `D` translates of `|F>` under `X(v)` form `D` mutually unbiased
bases" is equivalent to: the Weyl spectrum of `|F>` vanishes on one maximal isotropic line (the
pure-`Z` line) and has constant modulus `D^{-1/2}` everywhere else — which is exactly "full Hessian
rank at every `v != 0`". So the Weyl-sum evaluation behind Alltop and Klappenecker-Rötteler *is* our
Gauss-sum computation for the special case `F = Tr(u^3)`. The note must cite this and present the
SRE value as a new reading of a known state, not as a new state.

The MUB-fiducial framing also matches the empirical finding in both maximal-magic papers that the
maximizers are "Weyl-Heisenberg-covariant fiducial states for mutually unbiased bases"
(Liu-Low-Yin abstract; Knipfer et al. abstract and Section III.2). Those papers found the class
numerically without connecting it to Alltop's explicit algebraic construction. Making that
connection is available to us.

### Equality in the pure-state bound holds only for flat spectra

- The bound `M_2 <= log((D+1)/2)`, with equality iff `|<P>|^2 = 1/(D+1)` for every non-identity Weyl
  operator, is the SIC-fiducial bound. Y. Wang and Y. Li, "Stabilizer Rényi entropy on qudits,"
  *Quantum Information Processing* **22**, 444 (2023), DOI `10.1007/s11128-023-04186-9`, obtain
  "a tighter upper bound of this measure by using the group covariant symmetric informationally
  complete (SIC) states." Knipfer et al. cite `ln 5` for `D = 9` as the "previous theoretical
  bound," which is `log((D+1)/2)`.
- Flat spectra exist exactly where a Pauli-group-covariant SIC does: for a single qudit (Zauner /
  Hesse fiducials) and, over `Z_2^3`, the Hoggar lines. That is precisely why Liu-Low-Yin's
  conjecture carries the exception `n != 1, 3`.

**What our note may still claim**: not the state, and not the flat-equality criterion. Ours are the
general-`F` statement (arbitrary cubic, arbitrary Hessian-rank distribution), the reading of
Alltop / Klappenecker-Rötteler as the `M_2`-maximizing family in every `D = p^k` with `p >= 5`,
`k >= 2`, and the resulting explicit construction discharging the attainability half of the Knipfer
et al. conjecture in those dimensions.

---

## Q4. "SRE additivity + per-factor bound excludes Clifford-equivalence to a product"

**Verdict: NOT FOUND in this exact form. The neighbouring notion — magic that no *local* Clifford
can remove — is well established, and the ingredients are stated everywhere; the specific witness
argument was not located.**

- The ingredients are standard: `M_alpha` is Clifford-invariant and additive on tensor products, and
  `M_alpha` is a magic monotone for `alpha >= 2` — L. Leone and L. Bittel, "Stabilizer entropies are
  monotones for magic-state resource theory," *Phys. Rev. A* **110**, L040403 (2024),
  arXiv:2404.11652. This settled the monotonicity doubts raised by T. Haug and L. Piroli,
  "Stabilizer entropies and nonstabilizerness monotones," *Quantum* **7**, 1092 (2023),
  arXiv:2303.10152. Our (iv) uses only Clifford invariance and additivity, so it does not depend on
  the monotonicity question either way.
- The established adjacent notion is **nonlocal magic**: magic residing in correlations rather than
  in local bases, introduced by C. D. White, C. Cao and B. Swingle, "Conformal field theories are
  magical," *Phys. Rev. B* **103**, 075145 (2021), arXiv:2007.01303, and quantified since — e.g.
  "Exact quantification of nonlocal magic," arXiv:2608.28563, which minimizes over local bases and
  identifies the nonlocal magic of a pure multiqubit state with the distance of its entanglement
  spectrum from the closest Bell-pair spectrum. That programme minimizes over *local* Cliffords or
  unitaries; our (iv) rules out equivalence under the *full* Clifford group, a different and in that
  respect stronger statement extracted from a single number.
- The closest published argument of our shape is Chen-Yan-Zhou (arXiv:2308.01886, Quantum **8**,
  1351), who prove that hypergraph-state magic "cannot reach the maximal value if the average degree
  of the corresponding hypergraph is constant" — a maximum-versus-structure argument, but about
  degree, not about Clifford-equivalence to products.
- Searches for the argument as such returned nothing on point; see Search log, queries S25 and S30.

**What our note may still claim**: the witness itself, stated plainly — since `M_2` is
Clifford-invariant and additive, and each tensor factor of dimension `p^a` obeys
`M_2 <= log((p^a+1)/2)`, any state exceeding `max_a [log((p^a+1)/2) + log((p^{k-a}+1)/2)]` has no
Clifford image that is a product across any bipartition. Present it as an elementary corollary of
known facts, citing White-Cao-Swingle for the surrounding notion of nonlocal magic, not as a new
measure.

---

## Q5. Terminology and competing measures

**Verdict: KNOWN / settled. "Stabilizer Rényi entropy" is the standard term; "nonstabilizerness" and
"magic" are both acceptable in a title, and current papers routinely use both in the same sentence.**

- The measure and the name come from L. Leone, S. F. E. Oliviero and A. Hamma, "Stabilizer Rényi
  entropy," *Phys. Rev. Lett.* **128**, 050402 (2022), arXiv:2106.12587.
- Usage evidence from 2026 titles and abstracts: "Nonstabilizerness, also known as magic, ..."
  (Kagamihara-Tsuchiya, arXiv:2602.23687, opening line of the abstract); "entanglement and magic
  (nonstabilizerness)" (Knipfer et al., arXiv:2607.07197, opening line of the abstract). Both words
  in one title is current practice.
- Qudit version: Wang-Li, *Quantum Inf. Process.* **22**, 444 (2023) — generalized-Pauli /
  Heisenberg-Weyl displacement operators in place of qubit Paulis. This is the definition our note
  uses and the one to cite for it. A second, independent qudit and continuous-variable route is
  I. Klich, "SWAP and Transpose by displacements, Stabilizer Renyi entropies for continuous
  variables and qudits and other applications," arXiv:2408.15161, which names the qudit object
  "Weyl magic" — worth one sentence so our terminology choice is explicit.

Competing measures worth a short "related quantifiers" paragraph:

| Measure                                | Source                                                                                    | Note for us                                                        |
|----------------------------------------|-------------------------------------------------------------------------------------------|--------------------------------------------------------------------|
| Mana (log negativity of discrete Wigner)| Veitch, Mousavian, Gottesman, Emerson, *New J. Phys.* **16**, 013009 (2014)                | Defined for odd-dimensional qudits, so directly applicable here     |
| Wigner / sum negativity                | Veitch, Ferrie, Gross, Emerson, *New J. Phys.* **14**, 113011 (2012)                       | The classical-simulation-side resource                              |
| Robustness of magic                    | Howard, Campbell, *Phys. Rev. Lett.* **118**, 090501 (2017)                                | Not computable at our dimensions                                    |
| Stabilizer extent, stabilizer fidelity | Bravyi, Browne, Calpin, Campbell, Gosset, Howard, *Quantum* **3**, 181 (2019)               | Simulation-cost measure                                             |
| Stabilizer nullity, dyadic monotone    | Beverland, Campbell, Howard, Kliuchnikov, *Quantum Sci. Technol.* **5**, 035009 (2020), arXiv:1904.01124 | The "lower bounds on non-Clifford resources" paper named in the brief |
| Min-relative entropy of magic / thauma | Wang, Wilde, Su, magic-state distillation bounds                                            | Only needed if we make a distillation claim                         |

Bibliographic details for the Veitch, Howard-Campbell, Bravyi et al. and Wang-Wilde-Su rows were
**not** re-verified against a consulted record in this pass; they carry read depth
`abstract/metadata only` from search-result text and must be checked before entering a manuscript
(see Coverage statement).

Also on the qudit-magic side, named in the brief and confirmed as real and relevant:

- M. Howard and J. Vala, "Qudit versions of the qubit π/8 gate," *Phys. Rev. A* **86**, 022316
  (2012), arXiv:1206.1598 — explicit diagonal non-Clifford gates for every prime `d`; the associated
  magic states are the single-qudit diagonal phase states of our family. The abstract does not
  itself display the cubic phase formula.
- A. Jain and S. Prakash, "Qutrit and Ququint Magic States," *Phys. Rev. A* **102**, 042409 (2020),
  arXiv:2003.07164 — bestiary of non-stabilizer Clifford eigenstates for `d = 3, 5`; establishes the
  qutrit strange state as the most magic qutrit state, and shows no analogue exists for odd prime
  `d > 3`. Directly relevant to the `k = 1` caution in Q2.
- "Clifford equivalence of Howard-Vala T-gates," *Eur. Phys. J. Plus* (2025),
  DOI `10.1140/epjp/s13360-025-06394-x` — connects Clifford equivalence of these gates to cubic
  residues; likely the closest work to Clifford-orbit questions on single-qudit cubic phases.
- M. Erew and M. Goldstein, "Extremizing Measures of Magic on Pure States by Clifford-stabilizer
  States," arXiv:2512.19657 — Clifford-invariant pure states are extremal for stabilizer fidelity,
  mana, and the `alpha`-SREs. A general reason to expect algebraically distinguished states at the
  extrema, which is what our trace cubics are.

---

## Sources consulted

Read depth vocabulary per `notes/literature-audit-conventions.md`. **Zero sources in this audit
were read at full text.** Two were read at `partial` depth (arXiv HTML, named sections); the rest
are `abstract/metadata only` or `secondary only`. Nothing was added to the shared literature cache,
because no PDF was successfully retrieved and verified in this pass — every source below was reached
through the arXiv abstract or HTML renderer, a journal landing page, or search-result text.

| # | Source | Identifier | Read depth | How reached / what was used |
|----|--------------------------------------------------------|---------------------------------|--------------------------|------------------------------------------------------------------|
| 1 | Kagamihara, Tsuchiya, "Stabilizer Rényi entropy of 3-uniform hypergraph states" | arXiv:2602.23687 (v1 27 Feb 2026, rev. 14 May 2026) | partial | arXiv abstract page + `arxiv.org/html/2602.23687`; used Theorem 1 / Eq. (12), Sec. III.1, App. A |
| 2 | Chen, Yan, Zhou, "Magic of quantum hypergraph states" | arXiv:2308.01886; Quantum **8**, 1351 (2024); DOI 10.22331/q-2024-05-21-1351 | abstract/metadata only | arXiv abstract page and Quantum landing page; the `v3` HTML URL 404s and the landing page does not expose equations |
| 3 | Knipfer, Roman, Matcheva, Matchev, "Analytical Landscape of Maximal Magic for Two-Qutrit States and Beyond" | arXiv:2607.07197v1 (8 Jul 2026); DOI 10.48550/arXiv.2607.07197 | partial | arXiv abstract page + `arxiv.org/html/2607.07197`; used the abstract verbatim, Eq. (1), Eq. (2), Sec. III.2, Table 1 |
| 4 | Liu, Low, Yin, "Maximal Magic for Two-qubit States" | arXiv:2502.17550v3; *Quantum Sci. Technol.* **11**, 015035 (2026) | abstract/metadata only | arXiv abstract page; used the `ln(16/7)` value, the 480 maximizers, and the `n != 1, 3` conjecture |
| 5 | Wang, Li, "Stabilizer Rényi entropy on qudits" | *Quantum Inf. Process.* **22**, 444 (2023); DOI 10.1007/s11128-023-04186-9 | abstract/metadata only | Springer landing page redirects to an authentication IdP; ADS abstract endpoint returns HTTP 405; ResearchGate returns HTTP 403. Abstract text taken from search-result summaries. **Could not access full text.** |
| 6 | Alltop, "Complex sequences with low periodic correlations" | IEEE Trans. Inform. Theory **26** (1980), 350-354 | secondary only | Characterised through sources 7-9; the 1980 paper was not retrieved. **Could not access.** |
| 7 | Klappenecker, Rötteler, "Constructions of mutually unbiased bases" | LNCS 2948 (Fq7, 2004), 137-144; DOI 10.1007/978-3-540-24633-6_10 | secondary only | Characterised through the MUB review (source 8) and search-result text quoting the `Tr[(u+b)^3 + v(u+b)]` construction and the `p >= 5` / Weyl-sum hypothesis. **Full text not accessed.** |
| 8 | "Mutually Unbiased Bases in Composite Dimensions — A Review" | arXiv:2410.23997; Quantum **10**, 2051 (2026) | abstract/metadata only | Landing pages plus search-result text; used the Alltop/Klappenecker-Rötteler attribution |
| 9 | "Orbits of Mutually Unbiased Bases" | arXiv:1310.4684v3 (25 Mar 2014) | abstract/metadata only | PDF fetched but text extraction failed (see Search log, S19); used only the search-result statement that Alltop's MUBs are Weyl-Heisenberg orbits |
| 10 | Leone, Oliviero, Hamma, "Stabilizer Rényi entropy" | arXiv:2106.12587; *Phys. Rev. Lett.* **128**, 050402 (2022) | abstract/metadata only | arXiv listing; cited for the definition and the name |
| 11 | Leone, Bittel, "Stabilizer entropies are monotones for magic-state resource theory" | arXiv:2404.11652; *Phys. Rev. A* **110**, L040403 (2024) | abstract/metadata only | Search-result text; used for monotonicity at `alpha >= 2` |
| 12 | Haug, Piroli, "Stabilizer entropies and nonstabilizerness monotones" | arXiv:2303.10152; *Quantum* **7**, 1092 (2023) | abstract/metadata only | Search-result text; cited as the source of the monotonicity doubts |
| 13 | White, Cao, Swingle, "Conformal field theories are magical" | arXiv:2007.01303; *Phys. Rev. B* **103**, 075145 (2021) | abstract/metadata only | Search-result text and listing; cited for the notion of nonlocal magic |
| 14 | "Exact quantification of nonlocal magic" | arXiv:2608.28563 | abstract/metadata only | arXiv abstract page; used the definition ("correlations rather than local bases") and the main result |
| 15 | Klich, "SWAP and Transpose by displacements, Stabilizer Renyi entropies for continuous variables and qudits ..." | arXiv:2408.15161 (27 Aug 2024) | abstract/metadata only | arXiv abstract page; confirmed no Gauss-sum or quadratic-rank content in the abstract |
| 16 | Howard, Vala, "Qudit versions of the qubit π/8 gate" | arXiv:1206.1598; *Phys. Rev. A* **86**, 022316 (2012) | abstract/metadata only | arXiv abstract page; abstract does not display the cubic phase formula |
| 17 | Jain, Prakash, "Qutrit and Ququint Magic States" | arXiv:2003.07164; *Phys. Rev. A* **102**, 042409 (2020) | abstract/metadata only | Search-result text and arXiv listing |
| 18 | "Clifford equivalence of Howard-Vala T-gates" | *Eur. Phys. J. Plus* (2025); DOI 10.1140/epjp/s13360-025-06394-x | abstract/metadata only | Springer listing surfaced in search; not opened |
| 19 | Erew, Goldstein, "Extremizing Measures of Magic on Pure States by Clifford-stabilizer States" | arXiv:2512.19657v2 | partial | `arxiv.org/html/2512.19657v2`; main-results section and the SIC-fiducial discussion |
| 20 | Beverland, Campbell, Howard, Kliuchnikov, "Lower bounds on the non-Clifford resources for quantum computations" | arXiv:1904.01124; *Quantum Sci. Technol.* **5**, 035009 (2020) | abstract/metadata only | Search-result text; cited for stabilizer nullity and the dyadic monotone |
| 21 | Prakash, "Magic State Distillation with the Ternary Golay Code" | arXiv:2003.02717 | abstract/metadata only | Surfaced in search S12/S18; screened out as not bearing on the Pauli-spectrum question |
| 22 | Veitch, Mousavian, Gottesman, Emerson (mana) | *New J. Phys.* **16**, 013009 (2014) | abstract/metadata only | Bibliographic detail from background listings only; **not re-verified in this pass** |
| 23 | Veitch, Ferrie, Gross, Emerson (Wigner negativity) | *New J. Phys.* **14**, 113011 (2012) | abstract/metadata only | As row 22; **not re-verified** |
| 24 | Howard, Campbell (robustness of magic) | *Phys. Rev. Lett.* **118**, 090501 (2017) | abstract/metadata only | As row 22; **not re-verified** |
| 25 | Bravyi, Browne, Calpin, Campbell, Gosset, Howard (stabilizer extent) | *Quantum* **3**, 181 (2019) | abstract/metadata only | As row 22; **not re-verified** |
| 26 | "Group frames via magic states with applications to SIC-POVMs and MUBs" | ResearchGate 385659062 | abstract/metadata only | Surfaced in S23; noted as a possible further connection between magic states, SICs and MUBs, not pursued |

### Screened sets

Search-result pages S1-S34 (see Search log) returned roughly 8-10 links each. The screen ran over
title plus the search engine's abstract snippet, with the discriminator: *does the item concern the
Pauli/Weyl spectrum, stabilizer Rényi entropy, or magic of a diagonal phase state, a hypergraph
state, or a qudit magic state?* Items about SRE in condensed-matter, holographic, field-theoretic,
or random-circuit settings (Sachdev-Ye-Kitaev, conformal field theory, matrix product states,
Schwinger model, random unitary circuits, Rokhsar-Kivelson wavefunctions, topological quantum field
theory, Clifford ergotropy, quantum Monte Carlo estimators) were excluded as not bearing on the
algebraic structure of the spectrum. Promoted items appear individually in the Sources table.

## Coverage statement

**Searched and found nothing** (licenses the negatives in Q2 and Q4):

- No source stating `M_2 = log(p^2/(2p-1))` as the stabilizer Rényi entropy of a single-qudit
  cubic-phase state for general odd prime `p`. Searched: arXiv full-text search via web search
  restricted to arXiv results, Semantic Scholar and OpenAlex records surfaced through the same
  searches, and the two dedicated maximal-magic papers (sources 3 and 4), whose values are for
  `n = 2` only.
- No source using SRE additivity plus per-factor maxima to exclude Clifford-equivalence to a product
  across a bipartition. Searched: S25, S30, plus the reference framing of sources 13 and 14.
- No qudit / odd-prime version of the Hessian-rank Pauli-spectrum formula. Searched: S1, S2, S7,
  S12, S23.

**Could not access** (licenses nothing; carried forward as open gaps):

- Wang and Li, *Quantum Inf. Process.* **22**, 444 (2023) — Springer paywall, ADS HTTP 405,
  ResearchGate HTTP 403, no arXiv version located. The exact form of their SIC-based upper bound and
  their qutrit values are therefore **unverified**; every statement in Q3 attributed to them is from
  abstract text only.
- Alltop (1980) and Klappenecker-Rötteler (2004) primary texts. The `Tr[(u+b)^3 + v(u+b)]` formula
  and the `p >= 5` hypothesis are quoted from secondary sources. **Before this goes in a manuscript,
  both primaries must be obtained and the formula checked against them**, and the resulting PDFs
  added to the shared literature cache with key and SHA-256.
- Chen-Yan-Zhou's explicit Pauli-expectation lemma (source 2) — the Quantum landing page does not
  expose equations and the arXiv HTML URL 404s. Whether their general-hypergraph formula already
  contains the rank-of-quadratic-form structure in the `p = 2` case is **not settled by this audit**;
  it matters for how much of Q1 is attributed to them versus Kagamihara-Tsuchiya.
- MathSciNet: **NOT COVERED** (institutional authentication unavailable from this session). Keep
  "to our knowledge" on every claim it would have gated.
- zbMATH Open: not queried in this pass — an open gap, not a negative.
- Google Scholar: blocks automated access; not attempted.

**Citation-graph width requirement**: this audit did **not** enumerate a citing set for any seed, so
the OpenAlex / Crossref / Semantic Scholar triple-source requirement was not triggered. If the note
is to carry a forward-citation-closure claim on Kagamihara-Tsuchiya (arXiv:2602.23687) or Chen-Yan-
Zhou (DOI 10.22331/q-2024-05-21-1351) — the two most likely to have a qudit follow-up — that
enumeration is still owed.

## Search log

All queries run 2026-09-07. `WS` = WebSearch, `WF` = WebFetch, `LC` = local literature cache.

| # | Tool | Query string / URL (verbatim) | Outcome |
|-----|------|-------------------------------------------------------------------------------------------------------------------------------|---------|
| S0a | LC | `python3 /tmp/persistent/tavis/lit-search/bin/litcache.py list` | 1028 entries; none on SRE/magic |
| S0b | LC | `litcache.py list \| grep -iE "magic\|stabiliz\|nonstabiliz\|hypergraph\|clifford\|wigner\|contextual\|distillation\|T-gate\|qutrit"` | 20 hits, all stabilizer-*codes* or algebraic geometry; no magic/SRE literature cached |
| S1 | WS | `stabilizer Renyi entropy qudits prime dimension generalization` | Found Wang-Li 2023, Klich 2408.15161 |
| S2 | WS | `stabilizer Renyi entropy hypergraph states magic CCZ Pauli spectrum` | Found arXiv:2602.23687 and arXiv:2308.01886 — the key hits |
| S3 | WF | `https://arxiv.org/abs/2602.23687` | Abstract, authors, dates |
| S4 | WF | `https://arxiv.org/abs/2308.01886` | Abstract, Quantum 8, 1351 (2024), DOI |
| S5 | WF | `https://arxiv.org/abs/2308.01886v3` | HTTP 404 |
| S6 | WF | `https://arxiv.org/html/2602.23687` | Theorem 1 / Eq. (12), the `C(x)+C(x)^T` rank formula, App. A |
| S7 | WS | `qudit "cubic phase" state magic stabilizer Renyi entropy qutrit exact value` | Found arXiv:2607.07197 (`ln(81/17)`) |
| S8 | WF | `https://link.springer.com/article/10.1007/s11128-023-04186-9` | HTTP 303 to Springer IdP — paywall |
| S9 | WF | `https://arxiv.org/html/2607.07197` | Eq. (2) conjecture; maximizers are WH-covariant MUB fiducials |
| S10 | WS | `arXiv "stabilizer Renyi entropy" qudits Wang 2023 Heisenberg-Weyl qutrit magic states upper bound log((d+1)/2)` | Confirmed Wang-Li scope and the SIC-based tighter bound |
| S11 | WF | `https://arxiv.org/abs/2607.07197` | Verbatim abstract; `ln 5` named as the previous bound |
| S12 | WS | `"cubic phase state" qudit magic "non-Clifford" prime dimension omega^{u^3} Gauss sum` | Found Howard-Vala, Jain-Prakash, Prakash ternary Golay |
| S13 | WS | `maximal stabilizer Renyi entropy single qudit "d^2/(2d-1)" OR "4/3" qutrit "9/5" magic state` | Found arXiv:2502.17550 (`ln(16/7)`) |
| S14 | WF | `https://ui.adsabs.harvard.edu/abs/2023QuIP...22..444W/abstract` | HTTP 405 |
| S15 | WF | `https://arxiv.org/html/2607.07197v1` | Table 1, Sec. III.2, the 18 maxima; confirmed no Gauss sums / finite fields / cubic phases |
| S16 | WF | `https://arxiv.org/abs/2502.17550` | Liu, Low, Yin; QST 11, 015035 (2026); the `n != 1, 3` conjecture |
| S17 | WS | `fiducial state mutually unbiased bases single Weyl-Heisenberg orbit prime power dimension cubic Gauss sum construction` | **Alltop / Klappenecker-Rötteler identified** |
| S18 | WS | `Howard Vala qudit versions of pi/8 gate cubic phase magic state Gauss sum optimality Jain Prakash` | Howard-Vala PRA 86, 022316; Jain-Prakash; EPJ Plus Clifford-equivalence paper |
| S19 | WF | `https://arxiv.org/pdf/1310.4684` | PDF fetched (201.6 KB) but text extraction failed; no technical content obtained |
| S20 | WS | `Alltop cubic phase sequence mutually unbiased bases "trace" finite field Klappenecker Rotteler prime power omega^{Tr(u^3)}` | Confirmed `Tr[(k+b)^3 + v(k+b)]` over `F_{p^n}`, `p >= 5`, Weyl sums, odd `p` only |
| S21 | WS | `arXiv Wang Li "Stabilizer Renyi entropy on qudits" 2023 qutrit strange state Norrell state values SIC upper bound` | No arXiv version located |
| S22 | WF | `https://www.researchgate.net/publication/376519252_Stabilizer_Renyi_entropy_on_qudits` | HTTP 403 |
| S23 | WS | `"stabilizer Renyi entropy" "mutually unbiased bases" fiducial state maximal magic general dimension formula` | Reconfirmed sources 3, 4; surfaced source 26 |
| S24 | WF | `https://arxiv.org/abs/2408.15161` | Klich; "Weyl magic"; no Gauss sums in abstract |
| S25 | WS | `nonlocal magic genuine multipartite nonstabilizerness stabilizer entropy witness not Clifford equivalent to product state additivity` | Nonlocal-magic literature; **nothing on the additivity-plus-per-factor-bound witness** |
| S26 | WS | `stabilizer entropies monotones magic state resource theory alpha >= 2 Leone Bittel Haug Piroli critique` | Leone-Bittel PRA 110, L040403 (2024); Haug-Piroli Quantum 7, 1092 (2023) |
| S27 | WF | `https://arxiv.org/abs/2608.28563` | Nonlocal-magic definition; no additivity witness |
| S28 | WS | `"nonlocal magic" definition White Cao Swingle "conformal field theories are magical" magic not removable by local Clifford` | White-Cao-Swingle PRB 103, 075145 (2021) as originator |
| S29 | WS | `stabilizer nullity Beverland Campbell Howard Kliuchnikov lower bounds non-Clifford resources mana robustness of magic stabilizer extent qudits` | arXiv:1904.01124; QST 5, 035009 (2020) |
| S30 | WS | `magic exceeds sum of subsystem maxima proves state not Clifford equivalent product state stabilizer Renyi entropy additivity argument` | **Nothing on point**; surfaced arXiv:2512.19657 |
| S31 | WF | `https://quantum-journal.org/papers/q-2024-05-21-1351/` | Landing page only; equations not exposed |
| S32 | WF | `https://arxiv.org/html/2512.19657v2` | Erew-Goldstein main results; SIC-fiducial conjecture |
| S33 | WF | `https://arxiv.org/abs/1206.1598` | Howard-Vala abstract; no cubic formula in abstract |
| S34 | WS | `Jain Prakash "Qutrit and ququint magic states" arXiv 2020 Physical Review A quadratic Gauss sum Howard-Vala optimality` | arXiv:2003.07164; PRA 102, 042409 (2020) |


