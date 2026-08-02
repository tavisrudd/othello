# Approximate Rigidity of 2-Uniform States

## Discreteness and explicit stability of product-unitary symmetries from entanglement alone

**Status:** new results, proved below, numerically verified on AME(4,3).
**Relation to the corpus:** strengthens and quantifies the stabilizer AME local-unitary rigidity theorem (C562/C649 lineage). Theorem A shows the *discreteness* half of that theorem needs no stabilizer hypothesis — 2-uniformity alone forces it, for arbitrary (including non-stabilizer) states. Theorem B is the local stability estimate needed for self-testing/certification (Direction 1 of the physics program), with an explicit constant that is **independent of the number of parties**. Proposition C identifies the mechanism as exact isotropy of the quantum Fisher metric and yields a rigidity–metrology complementarity with GHZ at the opposite extreme.

---

## 1. Setup

Let ψ be a pure state of n qudits, each of local dimension q, i.e. a unit vector in
(C^q)^{⊗n}. Call ψ **2-uniform** if every two-site reduced density matrix is maximally
mixed:

```
rho_{jk}(psi) = I / q^2         for all j ≠ k .
```

(Then every one-site marginal is I/q as well. 2-uniform states require n ≥ 4; every
AME(2m,q) state with m ≥ 2 is 2-uniform, stabilizer or not; so is every k-uniform state
with k ≥ 2.)

A **product unitary** is U = U_1 ⊗ ··· ⊗ U_n with each U_j ∈ U(q). Define the
**symmetry group**

```
G(psi) = { U product unitary :  U psi = e^{i theta} psi  for some theta } ,
```

a compact subgroup of U(q^n) containing the global phases U(1)·I, and the **defect**

```
eps(U) = min_theta || U psi − e^{i theta} psi ||  =  sqrt( 2 − 2 |<psi| U |psi>| ) .
```

Throughout, ||·||_F is the Frobenius norm, ||·||_op the operator norm, and for
Hermitian h, ||h||_F^2 = tr(h^2).

**The one identity everything uses.** Because operators on distinct factors commute,
any product unitary can be written with a *single* exponential:

```
U = ⊗_j exp(i H_j) = exp( i L ),        L = Σ_j H_j^{(j)} ,
```

where H_j^{(j)} denotes H_j acting on site j. Split each H_j = h_j + tau_j I with
h_j traceless; then L = M + c I with c = Σ_j tau_j and

```
M = Σ_j h_j^{(j)} ,     h_j traceless Hermitian.
```

**Second-moment computation.** If ψ is 2-uniform then

```
<psi| M |psi>   =  Σ_j tr(h_j)/q                            =  0 ,
<psi| M^2 |psi> =  Σ_j tr(h_j^2)/q  +  Σ_{j≠k} tr(h_j)tr(h_k)/q^2
                =  (1/q) Σ_j ||h_j||_F^2 .                                   (★)
```

The cross terms vanish because rho_{jk} = I/q^2 and the h_j are traceless. Identity (★)
is the entire mechanism: the sum-of-local-generators map (h_1,…,h_n) ↦ M ψ is, up to
the factor 1/√q, an **isometry** from the Euclidean space of traceless local generators
into the Hilbert space.

---

## 2. Theorem A — no continuous product symmetries

> **Theorem A.** Let ψ be any 2-uniform pure state of n qudits of dimension q. Then the
> Lie algebra of G(ψ) consists exactly of the global phases, i.e.
>
> ```
> G(psi) / U(1)   is a finite group.
> ```
>
> In particular every AME(2m,q) state with m ≥ 2 — stabilizer or not — has a finite
> product-symmetry group modulo global phase.

**Proof.** Let t ↦ U(t) be a one-parameter subgroup of G(ψ) with generator
(iH_1,…,iH_n), so exp(itL) ψ = e^{i theta(t)} ψ with L = Σ_j H_j^{(j)}.
Differentiating at t = 0: L ψ = theta′(0) ψ. Decompose L = M + cI as above; taking the
inner product with ψ and using ⟨M⟩_ψ = 0 gives theta′(0) = c, hence M ψ = 0. By (★),

```
0 = || M psi ||^2 = (1/q) Σ_j ||h_j||_F^2 ,
```

so every h_j = 0 and each H_j is a scalar. Thus Lie(G) is the phase line; G/U(1) is a
compact zero-dimensional group, hence finite. ∎

**Remarks.**
1. The stabilizer hypothesis in the exact rigidity theorem is therefore doing only one
   job: identifying *which* finite group appears (local Clifford). Discreteness itself
   is a theorem about entanglement, not about stabilizer structure. This cleanly
   separates the two halves of the rigidity phenomenon and extends the "no continuous
   symmetry" statement to non-stabilizer AME states (e.g. all AME(4,q), q ≥ 3, whether
   or not a stabilizer construction exists).
2. The m = 1 boundary is exactly the failure of 2-uniformity. For a Bell state,
   rho_{12} = |Φ⟩⟨Φ| ≠ I/q², the cross term in (★) survives, and indeed
   M = h ⊗ I − I ⊗ h^T annihilates Φ for every h — the U ⊗ Ū gauge freedom. The sharp
   Bell boundary of the exact theorem is thus re-derived as a two-line marginal
   computation.
3. GHZ states are the complementary failure: rho_{jk} is maximally *correlated*, and
   e^{iθN}⊗e^{iθN}⊗e^{iθN}⊗e^{−3iθN} is an exact continuous product symmetry (verified
   numerically below).

---

## 3. Theorem B — explicit local stability

> **Theorem B.** Let ψ be 2-uniform, and let U = ⊗_j e^{i h_j} with h_j traceless
> Hermitian and
>
> ```
> t := || Σ_j h_j^{(j)} ||_op  ≤  Σ_j ||h_j||_op  ≤  1/2 .
> ```
>
> Put D = ( Σ_j ||h_j||_F^2 )^{1/2}. Then
>
> ```
> eps(U)  ≥  sqrt(5/(6q)) · D ,        i.e.        D  ≤  sqrt(6q/5) · eps(U)  <  1.096 √q · eps(U) .
> ```
>
> Moreover the constant is asymptotically sharp: eps(U)^2 = D^2/q · (1 + O(t)), so
> D/(√q · eps) → 1 as the generators shrink.

**Proof.** With M = Σ_j h_j^{(j)} we have U = e^{iM} up to the scalar already absorbed,
and eps² = 2 − 2|⟨e^{iM}⟩| where ⟨·⟩ = ⟨ψ|·|ψ⟩. Taylor with integral remainder,
e^{ix} = 1 + ix − x²/2 + r(x), |r(x)| ≤ |x|³/6, gives

```
<e^{iM}> = 1 − <M^2>/2 + <r(M)> ,        |<r(M)>| ≤ <|M|^3>/6 ≤ t <M^2> / 6 ,
```

using ⟨M⟩ = 0. Hence, since ⟨M²⟩ ≤ t² ≤ 1/4,

```
|<e^{iM}>|  ≤  1 − <M^2>( 1/2 − t/6 )  ≤  1 − (5/12) <M^2>        (t ≤ 1/2),
```

so eps² ≥ (5/6)⟨M²⟩ = (5/6q) D² by (★). Sharpness: eps² = ⟨M²⟩ + O(t·⟨M²⟩). ∎

> **Corollary B′ (approximate rigidity of stabilizer AME states).** Let ψ be a
> stabilizer AME(2m,q) state, m ≥ 2, and let G(ψ) be its (local-Clifford, by the exact
> rigidity theorem) product-symmetry group. There is an ε₀(ψ) > 0 such that every
> product unitary U with eps(U) < ε₀ decomposes as
>
> ```
> U = g · ⊗_j e^{i h_j},     g ∈ G(psi),   ( Σ_j ||h_j||_F^2 )^{1/2} ≤ sqrt(6q/5) · eps(U) :
> ```
>
> every approximate product symmetry is within ~1.1 √q · eps of an **exact local-Clifford
> symmetry**, in the natural product Frobenius metric.

**Proof.** The defect function f(U) = eps(U)² is continuous on the compact manifold
(U(q)^n modulo the phase identifications) and, by the exact theorem plus Theorem A, its
zero set is the finite (mod phase) group G(ψ). Theorem B applied at the identity — and,
by exact right-G-invariance f(Vg) = f(V) for g ∈ G(ψ), at every g — shows each zero is
nondegenerate with Hessian bounded below by (5/6q)·(product Frobenius metric). Hence
zeros are isolated with uniform quadratic growth on a ball of fixed radius; off the
union of those balls f attains a positive minimum by compactness, defining ε₀. ∎

**Two features worth emphasizing.**
1. **The constant is independent of n.** Self-testing-type stability bounds typically
   degrade with system size; here the 2-uniform marginal structure makes the Hessian
   *exactly* isotropic, so the stability constant is √(6q/5) regardless of the number
   of parties. This is the strongest selling point for certification applications:
   verifying an AME resource state with local Clifford measurements inherits an
   n-uniform robustness constant.
2. ε₀ is non-explicit here (compactness), but for stabilizer ψ it is in principle
   computable from the Weyl expansion of f — a well-defined follow-up item (see §6).

---

## 4. Proposition C — Fisher isotropy and the rigidity–metrology complementarity

> **Proposition C.** Let ψ be 2-uniform. For the local-generator family
> U(s) = ⊗_j e^{i s h_j} (h_j traceless), the quantum Fisher information is
>
> ```
> F_Q  =  4 Var_psi(M)  =  (4/q) Σ_j ||h_j||_F^2 .
> ```
>
> The QFI form on the space of traceless local generators is therefore an exactly
> isotropic multiple of the Euclidean form — no direction is enhanced and none is
> degenerate.

**Proof.** Immediate from (★) and ⟨M⟩ = 0. ∎

**Interpretation.** Rigidity and metrological enhancement are *complementary*:

- Degenerate QFI directions (kernel vectors) are exactly continuous product symmetries
  — the Bell state's U ⊗ Ū line.
- Enhanced QFI directions (eigenvalues growing like n², Heisenberg scaling) require
  large positive cross-correlations ⟨h_j h_k⟩ — the GHZ state, which correspondingly
  possesses exact continuous product symmetries and is as far from 2-uniform as
  possible on pairs.
- 2-uniform states sit at the isotropic point: **every** local signal is estimable at
  exactly the standard quantum limit, and **no** local drift is invisible. Maximal
  multipartite entanglement buys certifiability, not sensitivity, and the two are
  traded through the same Hessian.

This gives the exact-rigidity theorem its cleanest physics framing: the inverse of the
stability constant *is* the (flat) Fisher metric of the local-unitary orbit.

---

## 5. Corollary D — local gauge groups of 2-unitary gates

Vectorizing an AME(4,q) state across the (12|34) cut yields a 2-unitary
("dual-unitary in both directions", maximally scrambling) two-qudit gate W, and
conversely. Product symmetries of ψ correspond to local gauge equivalences
(u_1 ⊗ u_2) W (v_1 ⊗ v_2) = e^{iφ} W.

> **Corollary D.** The local gauge group of any 2-unitary gate is finite modulo global
> phase, and Theorem B holds verbatim: any approximate local self-gauge of W with
> defect eps (in the normalized Frobenius metric on states, i.e. q^{-1}·||·||_F on
> gates) lies within √(6q/5)·eps of an exact one. For gates arising from stabilizer
> AME(4,q) states the exact gauge group is local Clifford.

This ports the rigidity package into the dual-unitary circuit literature, where local
gauge freedom is the standing nuisance parameter in classifying solvable models; for
2-unitary bricks it is now finite, explicit in the stabilizer case, and stable.

---

## 6. Numerical verification

AME(4,3) stabilizer state |ψ⟩ ∝ Σ_{i,j} |i, j, i+j, i+2j⟩ (mod 3); random traceless
Hermitian generators, defect vs. distance at shrinking scale s:

```
2-uniformity:  max_jk || rho_jk − I/9 ||  =  0.0   (exact)

   s        eps            D              D / (sqrt(q)·eps)
 0.300   7.3795e-01    1.3414e+00        1.049464
 0.100   2.5677e-01    4.4713e-01        1.005385
 0.030   7.7408e-02    1.3414e-01        1.000484
 0.010   2.5814e-02    4.4713e-02        1.000054
 0.003   7.7445e-03    1.3414e-02        1.000005      → 1, bound 1.096 holds throughout

GHZ_3 (not 2-uniform):  defect of e^{iθN}⊗e^{iθN}⊗e^{iθN}⊗e^{−3iθN}  =  0.00e+00  (exact
continuous product symmetry;  || rho_12 − I/9 || = 0.471)

QFI isotropy:  4 Var(M) = 26.6568042391   vs   (4/q) Σ ||h_j||_F^2 = 26.6568042391
```

All three claims land at machine precision, and the D/(√q·eps) → 1 column confirms the
Hessian constant is exactly 1/q (the √(6q/5) of Theorem B is within 10% of optimal).

---

## 7. Honest sizing

**What this is.** (i) A separation of the exact rigidity theorem into an
entanglement-theoretic half (discreteness, Theorem A — two lines, no stabilizer input,
covers non-stabilizer AME) and an algebraic half (Clifford identification, which is
the corpus theorem and remains the hard part). (ii) The first quantitative stability
statement for these symmetry groups, with an explicit, n-independent constant
(Theorem B/B′) — the technical prerequisite for self-testing and certification
applications. (iii) An exact Fisher-geometric mechanism (Proposition C) tying the
rigidity constant to the QFI and placing Bell/GHZ as the two complementary
degeneracies. (iv) A finiteness-and-stability statement for local gauge groups of
2-unitary gates (Corollary D).

**What this is not.** Theorem A's method — second moments against maximally mixed
marginals — is elementary, and discreteness statements for special cases exist in the
stabilizer literature by other means; a referee may locate partial precedents in the
k-uniform / LU-equivalence literature (Rather–Burchardt–Życzkowski line), and a
literature pass is mandatory before any firstness claim. The compactness constant ε₀
in B′ is not explicit. Nothing here touches the genuinely hard converse questions
(which finite groups arise; sharp uniformity threshold for rigidity below k = 2).

**Where it goes.** Either a section of the AME rigidity paper (upgrading it from a
classification to a classification-with-stability, strengthening the PRX Quantum
case), or a short standalone letter if the certification protocol is worked out
end-to-end.

---

## 8. Follow-up items (proposed, C-ID pending)

1. **Explicit ε₀ for stabilizer ψ.** Expand f(U) in the local Weyl basis; the exact
   theorem's Weyl machinery should give a computable spectral gap, replacing the
   compactness step in B′ — target: fully explicit self-testing statement.
2. **Intertwiner version.** Extend B′ to approximate intertwiners between two
   stabilizer AME states (the exact theorem already covers exact intertwiners; the
   Hessian argument relativizes over any exact base intertwiner).
3. **Uniformity threshold.** Theorem A uses only k = 2. Determine whether the *Clifford
   identification* also descends to 2-uniform stabilizer states that are not AME —
   kill-battery: search small-q 2-uniform non-AME stabilizer states for non-Clifford
   product symmetries.
4. **Network corollary.** Propagate Theorem B through one honest perfect-tensor tiling
   to bound the product-symmetry group of the network state — the bottom-up
   no-global-symmetry instance.
