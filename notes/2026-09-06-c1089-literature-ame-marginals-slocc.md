# Prior-art check: AME/k-uniform marginals, parent Hamiltonians, SLOCC vs LU

Date: 2026-09-06. Scope: stabilizer AME(2m,q) = [[2m,0,m+1]]_q = perfect tensors.

Evidence key:
- **[T]** = confirmed in source text (cached PDF text or fetched page body).
- **[A]** = read only the abstract / listing metadata.
- **[M]** = my inference or recollection, not verified against a source in this pass.

## Cache preflight

`litcache.py list` (1028 entries). Relevant hits already cached:

| key | authors | title |
|---|---|---|
| `arXiv:1503.06237v2` | Pastawski, Yoshida, Harlow, Preskill | Holographic quantum error-correcting codes (HaPPY) |
| `arXiv:2011.04078`   | Slowik, Sawicki, Maciazek | Designing locally maximally entangled quantum states |
| `arXiv:2212.06737`   | Rather, Ramadas, Kodiyalam, Lakshminarayan | AME state equivalence (2-unitary) |
| `arXiv:2001.07106`   | Englbrecht, Kraus | Symmetries and entanglement of stabilizer states |
| `arXiv:2508.04777`   | Rajchel-Mieldzioc, Bistron, Rico, Lakshminarayan, Zyczkowski | AME pure states |
| `arXiv:2212.12870`   | Chang, Jing, Zhang | Criteria for SLOCC and LU equivalence |
| `arXiv:1306.2879`    | Helwig | AME qudit graph states |

Not cached, fetched fresh below: Bryan–Leutheusser–Reichstein–Van Raamsdonk (1801.03508),
Gour–Wallach, Raissi et al., Wyderka–Huber–Gühne, Huber–Gühne–Siewert.

(sections appended as work proceeds)

---

## Q1(a). Parent Hamiltonians of AME / k-uniform states

### Searched
- WebSearch: "parent Hamiltonian absolutely maximally entangled state unique ground state local Hamiltonian k-uniform"
- WebSearch: `"perfect tensor" OR "absolutely maximally entangled" "parent Hamiltonian" frustration-free commuting projector ground state`
- WebSearch: "uniquely determined among all states by reduced density matrices equivalent unique ground state of local Hamiltonian Chen Ji Zeng"
- grep of cached HaPPY full text.

### HaPPY (Pastawski–Yoshida–Harlow–Preskill 2015), arXiv:1503.06237v2, JHEP 06 (2015) 149
**[T]** grep of the cached full text (`text/arXiv_1503.06237v2.txt`, 25731 words) for
`parent Hamiltonian|unique ground state|ground state` returns only three hits, all incidental:
a remark that holographic states resemble "ground states of local scale-invariant Hamiltonians",
and two bibliography lines (kagome DMRG; Schuch–Cirac–Perez-Garcia "PEPS as ground states").
**HaPPY does not state, prove, or even pose a parent-Hamiltonian claim for perfect tensors.**
This is a clean negative: the perfect-tensor/holographic-code literature's use of perfect tensors
is as isometries in a tensor network, not as ground states of a local Hamiltonian.

### The generic machinery that *does* exist
The relevant general framework is the "ground state <-> marginals" duality, not anything
AME-specific:

- **Chen, Ji, Zeng, Zhou, "From ground states to local Hamiltonians", PRA 86, 022339 (2012),
  arXiv:1110.6583.** **[A]** A necessary condition for a subspace to be the ground-state space of
  a local Hamiltonian with a given interaction pattern is that the maximally mixed state supported
  on it be uniquely determined by its reduced density matrices for that pattern (maximum-entropy
  principle). The standard corollary, stated in this literature: a nondegenerate ground state of a
  k-local Hamiltonian is completely determined by its k-body RDMs.
- **Karuvade et al., "Uniquely determined pure quantum states need not be unique ground states of
  quasi-local Hamiltonians", PRA 99, 062104 (2019).** **[A]** The converse direction fails in
  general: UDA-by-marginals does not automatically give you a unique ground state of a
  quasi-local Hamiltonian with the same locality. Relevant caveat if a manuscript wants to move
  freely between the two formulations.

**Status of Q1(a):** I found **no** paper that states "a stabilizer AME(2m,q) state is the unique
ground state of an (m+1)-local commuting-projector Hamiltonian, and no nontrivial m-local
Hamiltonian has it as a ground state." The ingredients are all folklore-adjacent:
(i) any stabilizer state is the unique ground state of `H = -sum_g g` over stabilizer generators
    (commuting-projector, frustration-free), locality = max generator weight; **[M]**
(ii) for AME(2m,q), every (m+1)-party marginal has flat spectrum with rank q^{m-1}, so
    `I - (q^{m-1}/q^{m+1})^{-1} rho_A` is a genuine projector and the marginal-projector
    Hamiltonian is (m+1)-local and frustration-free; **[M]**
(iii) the m-local impossibility is immediate from m-uniformity (all m-party marginals maximally
    mixed => every m-local Hamiltonian has the same energy on the AME state as on the maximally
    mixed state, so it cannot single it out). **[M]**
I did not find (iii) written down as a stated theorem for AME states, though it is a one-line
argument and it is *implicit* in the standard remark that k-uniform states "carry no information
in their k-body marginals".

Adjacent negatives worth recording:
- **[A]** Searches for `"k-uniform" state cannot be ground state of "k-local" Hamiltonian locality
  threshold` return only circuit-lower-bound and code-Hamiltonian literature (e.g. Anshu–Breuckmann
  arXiv:2011.02044). No stated locality-threshold theorem for k-uniform states.
- The only nearby framing found is the standard code fact "any logical state of a stabilizer code
  with pure distance d_p is a (d_p-1)-uniform state", which is the *input* to the argument, not
  the parent-Hamiltonian conclusion.

---

## Q1(b). UDA determination of a stabilizer AME state by (m+1)-party marginals

### Searched
- WebSearch: "k-uniform states uniquely determined by reduced density matrices UDA stabilizer marginals"
- WebSearch: `"absolutely maximally entangled" state determined by its "reduced density matrices" number of marginals sufficient`
- WebSearch: `"AME" ... "uniquely determined" by "(m+1)"-body marginals half plus one parties sharp`
- WebSearch: `"Determination of stabilizer states" ... UDA`
- WebFetch: ar5iv full text of arXiv:1503.05421; abs page of arXiv:2401.07499; html of arXiv:2604.05508.

### STRONGEST PRIOR ART: Wu, Zhu, ... "Determination of stabilizer states", PRA 92, 012305 (2015), arXiv:1503.05421
**[T]** (ar5iv full text). Two numbered theorems, verbatim:

> **Theorem 1.** "Let |G_n> be a graph state and an arbitrary generating set of its stabilizer
> formalism is denoted as {M_1,...,M_n}. Then among pure states, the graph state is uniquely
> determined by its reduced density matrices set of R = {rho^{supp(M_s)} | s = 1,...,n}"
>
> **Theorem 2.** "Let |G_n> be an n-qubit graph state and an arbitrary generating set of its
> stabilizer formalism is denoted as {M_1,...,M_n}. Then among arbitrary states, the graph state
> is determined by its reduced density matrices set of R = {rho^{supp(M_s)} | s = 1,...,n}"

Minimality remark in that paper, verbatim: *"It is easy to see that reduced density matrices for
systems which are smaller than the supports of n independent generators ... cannot determine
stabilizer states."* They give a 4-qubit graph-state counterexample where
{rho^123, rho^14, rho^24, rho^34} is insufficient.

**What this does and does not settle for AME(2m,q):**
- It DOES give UDA (Theorem 2 is "among arbitrary states") for any stabilizer state from
  **n = 2m marginals**, one per generator, each supported on that generator's support. For a
  [[2m,0,m+1]]_q code the generator supports have size >= m+1 and generically size up to 2m.
- It does **NOT** give the claimed **m** marginals, does not control the marginal size at m+1,
  does not use the B∪{j} structure, and does not prove a lower bound on the *number* of marginals
  (its minimality remark is about shrinking each marginal's *support*, not about the count).
- It is stated for qubit graph states / stabilizer states; the q-ary and AME cases are not treated.
- **[T]** The paper does not mention AME states, k-uniform states, or [[n,0,d]] self-dual codes.

So a claim of the exact shape "m marginals of size m+1, of the form B∪{j}, suffice for UDA, and
fewer than m do not" is a **strict sharpening** of the published stabilizer result and I found no
paper stating it.

### Other marginal-determination anchors
- **Linden, Popescu, Wootters, "Almost every pure state of three qubits is completely determined by
  its two-particle reduced density matrices", PRL 89, 207901 (2002).** **[M]** Origin of the
  generic-UDP program.
- **Diósi, "Three-party pure quantum states are determined by two two-party reduced states",
  PRA 70, 010302(R) (2004); Jones & Linden, PRA 71, 012324 (2005).** **[M]** Generic pure states
  of n parties are determined among pure states by marginals of ~n/2 parties.
- **Wyderka, Huber, Gühne, "Almost all four-particle pure states are determined by their two-body
  marginals", PRA 96, 010102(R) (2017), arXiv:1703.10950.** **[A]** Generic (Haar) four-party pure
  states of equal local dimension are UDP by their two-body marginals; **certain subsets of three
  of the two-body marginals suffice**. Counterexamples given: four-qubit Dicke states superposed
  with generalized GHZ states share two-body marginals. Note the shape: this is the closest
  published statement of the form "a *specific small subset* of marginals suffices", but it is
  UDP (among pure states), generic, and for n=4/k=2 only. AME(4,q) is *not* generic in their sense
  — k-uniform states are precisely the degenerate case where all k-body marginals are identical
  and carry no information.
- **"Almost all even-particle pure states are determined by their half-body marginals",
  arXiv:2401.07499.** **[T]** (abstract, verbatim): "almost all generic pure states of even
  N-particle with equal local dimension are uniquely determined among all other pure states (UDP)
  by four of their half-body marginals ... we present a construction of N-qudit states obtained
  from certain combinatorial structures that cannot be UDP by its k-body marginals for some
  k > N/2 - 1." Again UDP, generic, half-body (N/2) not N/2+1, and the constructed
  counterexamples move in the opposite direction.
- **[A]** Widely repeated in this literature: "k-uniform states are clearly not UDP by their
  k-body marginals, and some k-uniform states are not even UDP by their (N-k)-body marginals."
  That is the standard statement of the *negative* side; the positive (m+1)-marginal side for AME
  is what appears to be missing.
- **Huber, Eltschka, Siewert, Gühne, "Bounds on absolutely maximally entangled states from shadow
  inequalities, and the quantum MacWilliams identity", J. Phys. A 51, 175301 (2018),
  arXiv:1708.06298**, and **Huber, Gühne, Siewert, "AME states of seven qubits do not exist",
  PRL 118, 200502 (2017), arXiv:1608.06228.** **[A]** These are *existence/nonexistence* results
  via weight enumerators and shadow inequalities. They do not address determination by marginals.
- **Raissi, Teixidó, Gogolin, Acín, "Constructions of k-uniform and AME states beyond maximum
  distance codes", Phys. Rev. Research 2, 033411 (2020), arXiv:1910.12789.** **[A]** Purely
  constructive (k-uniform states inequivalent to MDS-code ones). No marginal-determination content.

### Verdict on Q1(b)
Not known in the claimed form. The published stabilizer UDA theorem (arXiv:1503.05421) needs one
marginal per generator (2m of them for AME(2m,q)) with uncontrolled supports; nothing in the
AME/k-uniform literature I found gives an m-marginal, (m+1)-party, B∪{j}-structured UDA
certificate, and nothing proves the matching "fewer than m fail" lower bound.

---

## Q1(c). Fidelity certificate from marginal trace distances

- **Tóth & Gühne, "Entanglement detection in the stabilizer formalism", PRA 72, 022340 (2005),
  arXiv:quant-ph/0501020**, and **"Detecting genuine multipartite entanglement with two local
  measurements", PRL 94, 060501 (2005).** **[M]** Standard source for stabilizer witnesses of the
  form W = c I - sum_j (stabilizer projectors); the fidelity-from-local-measurement idea is
  routine there.
- **[M]** The bound `1 - <psi|sigma|psi> <= sum_j (1/2) ||sigma_{A_j} - rho_{A_j}||_1` is a
  two-line consequence of a *frustration-free* parent Hamiltonian: write
  `I - |psi><psi| <= sum_j (I - Pi_{A_j})`, take Tr against sigma, and use
  `|Tr(X P)| <= (1/2)||X||_1` for traceless Hermitian X and a projector P. I found no paper
  stating it in this exact form for AME states, and I would call it standard rather than novel.
- **Yu, Shi, Chiribella, Zhao, "Quantum state determinability from local marginals is universally
  robust", arXiv:2604.05508 (Apr 2026).** **[T]** (HTML). Abstract, verbatim: "for every uniquely
  determined state, we show that deviations of local marginals propagate to global states strictly
  bounded by a power law with exponent alpha in (0,1]." Their **Proposition 1** gives stabilizer
  states only **square-root** robustness (alpha = 1/2) with respect to the generators' supports,
  robustness coefficient 2*sqrt(2). Their Proposition 2 classifies Dicke states.
  **[T]** They do NOT treat AME or k-uniform states, and no fidelity-form bound of the requested
  shape appears.
  Reconciliation **[M]**: their alpha is measured in *global trace distance*; square-root in trace
  distance is the same content as linear in infidelity for a pure target, so this is consistent
  with the elementary parent-Hamiltonian bound rather than in tension with it. Cite it as the
  general robustness framework; it does not pre-empt an AME-specific linear-in-infidelity
  certificate, but it does mean "robustness of marginal determination" is now a named, active
  topic with a 2026 general theorem.

---

## Q2(a). SLOCC = LU for critical / LME states — CONFIRMED, WELL ESTABLISHED

This one is unambiguously prior art; do not claim it.

### Burchardt & Raissi, "Stochastic local operations with classical communication of absolutely maximally entangled states", PRA 102, 022413 (2020), arXiv:2003.13639
**[T]** (own `pdftotext` of the fetched PDF, saved at
`<scratchpad>/burchardt-raissi-2003.13639.txt`). Verbatim, Sec. II:

> "The state rho is called a critical state if its all reduced density matrices rho_i are
> proportional to the identity. In particular, the class of critical states contains stabilizer
> states, cluster states, and all k-uniform states among many others [52]."
>
> "Kempf-Ness theorem has one more significant consequence for multipartite quantum states.
> It follows that within one SLOCC class, the critical states are unique up to LU-equivalences.
> Therefore, such classes posses the canonical representative."
>
> "each SLOCC class is topologically closed (equivalently closed with respect to Zariski topology)
> if and only if it contains a critical state [54]."
>
> **"Corollary 1. Two critical states are in the same SLOCC class if and only if they are LU
> equivalent. Notice, that all k-uniform states are critical states."**

and in Appendix A, verbatim: *"Notice that LU- and SLOCC-equivalences coincides on the class of
AME states, which is an immediate conclusion from Corollary 1."*

Their citation chain, verified from the bibliography **[T]**:
- [51] **G. Kempf and L. Ness, "The length of vectors in representation spaces", Algebraic Geometry
  (Springer LNM 732, 1979), p. 233.**
- [52] **G. Gour and N. R. Wallach, "Necessary and sufficient conditions for local manipulation of
  multipartite pure quantum states", New J. Phys. 13, 073013 (2011), arXiv:1103.5096.**
- [53] **G. Gour and N. R. Wallach, J. Math. Phys. 51, 112201 (2010)** — for "states are critical
  iff they are maximally entangled".
- [54] **Słowik, Hebenstreit, Kraus, Sawicki, "A link between symmetries of critical states and the
  structure of SLOCC classes in multipartite systems", Quantum 4, 300 (2020), arXiv:1912.00099.**
- [55] N. R. Wallach, Venice CIME lectures (2004).

### Independent confirmation in the 2025 AME review
**Rajchel-Mieldzioc, Bistroń, Rico, Lakshminarayan, Życzkowski, "Absolutely maximally entangled
pure states of multipartite quantum systems", arXiv:2508.04777** (cached).
**[T]** verbatim: *"Although, in the general case, for a given state |psi> its orbit of
SLOCC-equivalent states is strictly larger than its LU orbit, these sets are equal when we restrict
the orbit to AME states [128]. This results from the application of Kempf-Ness theorem [129, 130]
for 1-uniform states. Consequently, since LU/LOCC/SLOCC sets coincide for AME states, for the
remainder of this section, we shall mention the LU class alone."*
([128] = Burchardt–Raissi; [129] = Kempf–Ness 1979; [130] = Gour–Wallach NJP 13, 073013 (2011).)

### Bryan, Leutheusser, Reichstein, Van Raamsdonk, "Locally maximally entangled states of multipart quantum systems", Quantum 3, 115 (2019), arXiv:1801.03508
**[A]** (fetched ar5iv rendering; the extractor reported paraphrase, so treat theorem numbering as
unverified). Reported content: Sec. 4.3 states "A single G-orbit contains at most one K-orbit of
LME states" and "the space of LME states up to local unitary transformations is equivalent to the
space of polystable G-orbits"; polystable orbits are exactly the topologically closed ones and
contain the minimum-norm (= LME) vectors. **Theorem 1.2** concerns the *dimension* of the
stabilizer subgroup of a generic vector; Appendix C: "The stabilizer of a generic vector in
Hilbert space will be trivial if and only if Delta(d) > 3."
**[T-negative]** No numbered theorem in that paper declares the stabilizer of an LME state finite
or compact. Its companion is **Bryan, Reichstein, Van Raamsdonk, "Existence of locally maximally
entangled quantum states via geometric invariant theory", Ann. Henri Poincaré (2018),
arXiv:1708.01645** **[M]**.

**Verdict Q2(a):** fully known and repeatedly stated. Cite Burchardt–Raissi Corollary 1 (or
Gour–Wallach NJP 13, 073013 (2011) + Kempf–Ness 1979) for "critical/1-uniform => SLOCC class = LU
class". Nothing here is new.

## Q2(b). "Every A_i is proportional to a unitary" / finiteness of the SL-stabilizer of a 2-uniform state

This is where the literature is **thinner than Q2(a) suggests**, and the gap is real.

### Why Q2(a) does not already give it
**[M]** Kempf–Ness says: if psi is polystable and (⊗A_i)psi is also critical, then
(⊗A_i)psi = (⊗U_i)psi for some local unitaries U_i. It does **not** follow that each A_i is
proportional to a unitary — that needs the SL-stabilizer G_psi to be contained in the compact
subgroup, i.e. G_psi finite/compact. For polystable psi, Matsushima gives only that G_psi is
*reductive*, which permits a noncompact torus. Explicit counterexample at the 1-uniform level:
GHZ_n is 1-uniform (critical) and its stabilizer in SL(2)^n contains the continuous torus
diag(t_1, 1/t_1) ⊗ ... ⊗ diag(t_n, 1/t_n) with prod t_i = 1. So **1-uniformity is provably not
enough**, and the step from 1-uniform to 2-uniform is exactly the content of the claim.

### Closest published result: Englbrecht & Kraus, "Symmetries and entanglement of stabilizer states", PRA 101, 062302 (2020), arXiv:2001.07106 (cached)
**[T]** (grep + read of cached full text). Verbatim from the outline and conclusions:

> "We will first show that a stabilizer state possessing infinitely many symmetries has to
> correspond to a graph which possesses a leaf (see also [23, 24]). This refers to a particular
> structure of the underlying graph, which can be easily identified by considering the two-qubit
> reduced states. All other states only possess finitely many local symmetries."
>
> "To this end we have used that stabilizer states are critical states and thus local, non-unitary
> symmetries are determined by the local unitary ones."
>
> "Graph states of the second type have a continuous unitary symmetry if and only if the
> corresponding graph has a leaf (up to local complementation). **Note that this is the only case
> in which a graph state also has a symmetry in GL.**"

Here "symmetry" = invertible local operator g_1 ⊗ ... ⊗ g_n fixing the state.
**[M]** Combining: a graph state with a leaf j (unique neighbour k) has the weight-2 stabilizer
element X_j Z_k, so its code distance is 2 and it is at most 1-uniform. Hence **a 2-uniform qubit
stabilizer state has no leaf, therefore has only finitely many local symmetries and no invertible
non-unitary local symmetry at all.** That is exactly the Q2(b) claim, for qubit stabilizer states,
obtainable in two lines from a published theorem — so for qubits the claim is *derivable* from
prior art even though nobody states it in AME language.
**Caveat:** Englbrecht–Kraus is qubit-only (graph states, local complementation, local Clifford
group over F_2). The q-ary case for prime-power q is not covered.

### Burchardt & Raissi, Proposition 2 / Proposition 11 (arXiv:2003.13639)
**[T]** verbatim:
> "**Proposition 2.** For 2k < N, each LU- or SLOCC-equivalency between two k-uniform states of
> minimal support is in fact LM-equivalency." (LM = local monomial: permutation times diagonal.)
>
> "**Corollary 2.** For 2k < N, two k-uniform states of minimal support are LU- or SLOCC-equivalent
> if and only if they are LM-equivalent."
>
> "**Proposition 11.** Consider two k-uniform states |psi> and |phi> with minimal support. For any
> subsystem S consisting of s > k parties, the reduced density matrices rho_S(psi) and rho_S(phi)
> are LU-equivalent if and only if they are LM-equivalent."

Two limits that matter for AME(2m,q): (i) the hypothesis is **2k < N**, which *excludes* the AME
case on an even number of parties (there k = m, N = 2m, so 2k = N); (ii) it assumes **minimal
support** (d^k terms); (iii) it constrains the *form* of the local unitary, not the SL-stabilizer.
Note the structural echo though: their proof reduces everything to subsystems of exactly **k+1
parties**, and they remark verbatim that "the size s > k of the subsystem S ... is the largest
possible. Indeed, after taking the partial trace over larger subsystem, both states ... become
proportional to the identity" — i.e. the k+1 threshold appears in their argument for the *same*
reason it would appear in a marginal-determination theorem.

### Genericity results (adjacent, not the claim)
- **Sauerwein, Wallach, Gour, Kraus, "Transformations among pure multipartite entangled states via
  local operations are almost never possible", PRX 8, 031020 (2018), arXiv:1711.11056.** **[T]**
  abstract verbatim: "In order to derive this result, we prove a more general statement, namely,
  that, generically, a state possesses no nontrivial local symmetry." Generic, not AME-specific;
  AME states are non-generic.
- **Gour, Kraus, Wallach, "Almost all multipartite qubit quantum states have trivial stabilizer",
  J. Math. Phys. 58, 092204 (2017), arXiv:1609.01327.** **[A]** Same genericity flavour.

**Verdict Q2(b):** Not stated anywhere in the AME/k-uniform literature I found. For **qubit
stabilizer** states it follows in two lines from Englbrecht–Kraus (leaf <=> continuous/GL symmetry;
2-uniform => no leaf) — so cite them and present it as a corollary rather than a new theorem in
that case. For general q-ary stabilizer AME states, and for non-stabilizer 2-uniform states, I
found no published statement, and the Kempf–Ness/Gour–Wallach machinery alone does not deliver it
(GHZ counterexample above).

## Q2(c). Optimal SLOCC conversion probability 0 or 1

- **[M]/[T]** Immediate corollary of Q2(a) as already *written down* in the 2025 review
  (arXiv:2508.04777) **[T]**: after noting SLOCC orbit = LU orbit for AME states, the review's
  preceding sentences state the LU conversion has "The probability of success in both directions is
  thus 1", and then "since LU/LOCC/SLOCC sets coincide for AME states ...". So the 0-or-1 dichotomy
  for *AME-to-AME exact conversion* is already in print, at review level, in this form: either the
  two AME states are LU-equivalent (probability 1) or they are in different SLOCC classes
  (probability 0).
- **Gour & Wallach, NJP 13, 073013 (2011), arXiv:1103.5096.** **[T]** (IOP page) The paper gives
  "necessary and sufficient conditions for the existence of a local separable transformation between
  multipartite states within the same SLOCC class" and "determines maximum conversion probabilities
  when deterministic transformation is impossible". This is the general machinery behind any
  optimal-probability statement.
- **[T-negative]** Searching `optimal probability SLOCC conversion between AME states zero or one
  postselected conversion perfect tensors` surfaced only W-class optimal-conversion work
  (arXiv:1009.2467, arXiv:1110.4597) and the PRX genericity paper — nothing AME-specific beyond the
  above.

**Verdict Q2(c):** The 0-or-1 dichotomy for exact AME-to-AME SLOCC conversion is a stated
consequence of known results (Burchardt–Raissi Cor. 1, restated in the 2025 review). Present it as
a remark with those citations, not as new.

---

## Q3. "m marginals" / "half plus one" sharpness, and a locality threshold for parent Hamiltonians

**Nothing found.** Specifically:

- **[T]** The 2025 AME review arXiv:2508.04777 (27,677 words, cached full text) contains the word
  "Hamiltonian" **zero times**. Its marginal section (Sec. VIII) discusses the quantum marginal
  problem only in the *existence* direction ("determining whether there exists a global state rho
  compatible with certain prescribed marginals"), citing Klyachko and the Yu–Guo–Huber–et al.
  SDP hierarchy (Nat. Commun. 12, 1012 (2021)). It never asks whether an AME state is *determined*
  by a subfamily of its marginals.
- **[T]** HaPPY (arXiv:1503.06237v2) has no parent-Hamiltonian content for perfect tensors.
- **[T]** The Error Correction Zoo perfect-tensor/AME code page has no parent-Hamiltonian, ground
  state, marginal-determination or UDA content.
- **[A]** Searches for `"locality threshold" / "minimal locality" parent Hamiltonian "k-uniform"
  "k+1"-local` return only generic local-Hamiltonian-complexity material and
  **Giudici, Cirac, Schuch, "Locality optimization for parent Hamiltonians of tensor networks",
  PRB 106, 035109 (2022)** — which optimizes parent-Hamiltonian locality for PEPS, not for
  k-uniform states; worth citing as the nearest methodological neighbour.
- The only place the "k+1" threshold shows up structurally is Burchardt–Raissi's Proposition 11
  and their remark that k+1 is the smallest and k the largest useless subsystem size — for LU
  classification of minimal-support k-uniform states, not for parent Hamiltonians or UDA.

**Verdict Q3:** No prior claim of "m marginals suffice / fewer than m fail" for AME, and no exact
locality threshold for parent Hamiltonians of k-uniform states. The half-plus-one sharpness appears
to be unclaimed territory.

---

## Bottom line, per sub-question

| Sub-question | Status |
|---|---|
| Q1(a) parent Hamiltonian, (m+1)-local, m-local impossible | **Not found in the literature.** Ingredients standard; HaPPY and the 2025 AME review both silent. Cite Chen–Ji–Zeng–Zhou (PRA 86, 022339) for the UDA<->ground-state framework and Karuvade et al. (PRA 99, 062104) for the converse caveat. |
| Q1(b) UDA by m marginals of size m+1, B∪{j} shape, sharp | **Not found.** Strongest prior art is Wu et al., PRA 92, 012305 (2015), arXiv:1503.05421, Theorem 2: any stabilizer/graph state is UDA by the n marginals on the supports of n independent generators. That gives 2m marginals with uncontrolled supports; the m-marginal, (m+1)-party version and the "fewer than m fail" lower bound are new. |
| Q1(c) fidelity certificate from marginal trace distances | **Standard.** Cite Tóth–Gühne PRA 72, 022340 (2005) for stabilizer witnesses; the bound itself is a two-line frustration-free parent-Hamiltonian argument. Note Yu–Shi–Chiribella–Zhao arXiv:2604.05508 (2026) as the general robustness framework (their Prop. 1 gives stabilizer states square-root robustness in trace distance). |
| Q2(a) SLOCC = LU for critical/LME states | **Fully known.** Burchardt–Raissi PRA 102, 022413 (2020) Corollary 1; Gour–Wallach NJP 13, 073013 (2011); Kempf–Ness 1979; restated in the 2025 AME review. Do not claim. |
| Q2(b) 2-uniform => each A_i proportional to a unitary / finite SL-stabilizer | **Not stated.** Derivable for qubit stabilizer states from Englbrecht–Kraus PRA 101, 062302 (2020) (continuous/GL symmetry <=> graph has a leaf; 2-uniform excludes leaves). Open in print for general q and for non-stabilizer 2-uniform states. 1-uniform is provably insufficient (GHZ torus). |
| Q2(c) SLOCC conversion probability 0 or 1 between AME states | **Known as a corollary**, and stated at review level in arXiv:2508.04777. Cite, do not claim. |
| Q3 "m marginals"/half-plus-one sharpness, locality threshold | **Unclaimed.** No source found. |
