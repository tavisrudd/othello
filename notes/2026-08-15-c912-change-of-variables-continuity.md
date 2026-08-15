# C912: Evaluating Iritani's blowup change of variables (and inverse) at displaced parameters — verdict on (CONT), plus debt-location ledger

Sources (cached text, line numbers refer to these files):
- B = `/tmp/persistent/tavis/lit-search/text/arXiv_2307.13555.txt` (Iritani, blowups)
- P = `/tmp/persistent/tavis/lit-search/text/arXiv_2307.03696.txt` (Iritani–Koto, projective bundles)
- M = `/home/tavis/src/othello/notes/2026-08-15-c912-frame-transport-memo.tex` (sec:unconditional B1812–1959 of that file; two-rates M457–495)

## VERDICT ON (CONT): FAILS

(CONT) asked: given a target parameter of V's base of shape (a) degree-zero part
= scalar times a positive power of q, (b) scalar degree-two divisor part, (c)
tail in negative powers of q, does there exist a parameter tt of Bl_Z V's base
of the same shape with tau(tt) = target, uniquely — equivalently, are the change
of variables and its inverse well defined as maps of the completions in which
such parameters live?

**They are not.** The substitution of such a parameter into the formal series —
in either direction — is ill-defined in the rings the theorems are stated over,
and the graded structure does not rescue it. Iritani says the function-level
ill-definedness himself, verbatim, for the divisor part alone:

> B4335–4340: "Due to the constant term hZ,j in the change of variables
> σ = σj(θ), the pullback of functions σj\*: C[z]((q^{-1/s}))[[Q, σ]] →
> C[z]((q^{-1/s}))[[Q, θ]] is ill-defined. However, the pullback of connections
> is well-defined due to the Divisor Equation."

Note h_{Z,j} = (j+1/2)ρ_Z/(r-1) (B4319, eq. (5.19)) is a *q-free scalar
multiple of a divisor class* — the mildest displacement in the whole shape —
and already function substitution fails. The change of variables and its
inverse are functions of exactly this kind; hence "tau(tt) = target" has no
meaning at a displaced point in these completions, and existence/uniqueness of
tt cannot even be posed there, let alone hold. What Theorem 5.18 / IK Theorem
5.1 provide is an isomorphism of formal germs in *displaced* variables: IK
(5.13) sets s_j(tau-hat) = varsigma_j(tau-hat) − varsigma_j° and says the s_j
"may be treated as independent variables instead of tau-hat" (P3268–3272);
Lemma 5.15 is the inverse function theorem at Q = theta = 0 only (B5248–5344).

### Why the grading does not rescue it (the "most likely resolution" tested)

Degrees, from the sources: deg q = 2(r−1), deg z = 2 (B116–121, Remark 1.5);
deg Q^d = 2 c_1·d and the graded-completion formalism (B636–676, section 2.2);
deg tau^i = 2 − deg phi_i (B705–708); the maps tau(tt), varsigma_j(tt) are
homogeneous of degree 2 (B5680, Theorem 5.18(5)).

1. Because H^*(X) is finite-dimensional and deg q ≠ 0, a homogeneous element
   of C((q^{-1/s}))[[Q]] has, at each fixed (total degree, Q^d), its q-power
   pinned to at most dim+1 values (one per H-degree slot). The only completion
   direction is Q — exactly Remark 1.3 (B108–113). There is no q^{-1}-adic
   room: an infinite sum of distinct q-powers in one degree at one Q-order is
   not an element of the ring.
2. A parameter of the shape (a)+(b)+(c) that is homogeneous of degree 2 —
   which is what the theorems produce, e.g. varsigma_j(0)|_{Q=0} =
   −(r−1)λ_j + h_{Z,j} + O(q^{-1/(r−1)}) with λ_j ∝ q^{1/(r−1)} of degree 2
   (B5240–5242, B5301–5310, eq. (5.34)) — has **degree defect zero in every
   coordinate**: the substituted value has the same degree as the coordinate
   it replaces. Hence *every* monomial tt^alpha lands in the same output
   degree. The grading pins the slot; it cannot bound the number of monomials
   mapping into the slot.
3. Per-slot finiteness therefore holds iff the series' coefficients have
   q-powers bounded above at each Q-order. This is true where Iritani needs
   it — the V-side and Z-side structure rings C[z][[Q, tau]] and R are q-free
   (B5395–5404, after (5.36); B4275–4279, Remark 5.6) — and **false** for the
   blowup-side series: exceptional multiple covers contribute q^{+k} for all
   k > 0 at Q = 0 (Lemma 5.11, B4649–4660: the F_Xtilde line has sum over
   k > 0 of q^k terms; Lemma 5.15 first line, B5246: tt(theta)|_{Q=0} ∈
   kappa(theta) + (theta)^2 H^*(Xtilde)[q][[theta]]; Remark 5.19, B5703–5710).
   By homogeneity these positive q-powers grow linearly with the tt-monomial
   order and exactly cancel the tail's negative q-powers, so infinitely many
   scalar contributions pile into one pinned slot.

### Explicit divergence

Divisor direction (source-certified): let v be a divisor coordinate
(deg tau^v = 0). F = sum_{n≥0} (tau^v)^n is a legitimate degree-0 element of
the graded completion C[[Q, tau]]. Substituting tau^v = c ≠ 0 (the scalar
divisor displacement, e.g. the coefficient of rho_Z in h_{Z,j}) puts
sum_n c^n — an infinite scalar sum — into the single slot (degree 0, Q^0).
This is exactly the phenomenon behind Iritani's "ill-defined" (B4335–4337).

Tail direction (inverse map): take a single coordinate theta^a dual to a class
of degree ≥ 4 and a tail value t^a = c q^{-k/s}(class), degree defect zero.
The coefficient of (theta^a)^n in tt(theta)|_{Q=0} lies in H^*(Xtilde)[q]
with q-power forced by homogeneity to grow linearly in n (B5246), while
(t^a)^n has q-power decreasing linearly in n; the products all land in the
same degree-2, Q^0, bounded-q-power slots. Convergence would require all but
finitely many of these exceptional-curve Gromov–Witten coefficients to
vanish; nothing in the sources asserts that, and the exceptional I-function
(Lemma 5.11, B4649–4660) has nonvanishing q^k-terms to all orders.

### What survives (and is enough for a repaired route — see ledger)

- **Forward pullback of connections/structures at displaced parameters is
  well defined and exact.** Iritani states it: "These pullbacks are
  well-defined due to the String and Divisor equations" and equivalently by
  reduction to the q-free rings C[z][[Q, tau]] and R (B5391–5404). Mechanism,
  provable from the degree bookkeeping above: (a) the quantum product does
  not depend on the H^0-coordinate at all (string), and an H^0-shift changes
  only the z-part of the connection by (tau^0/z)·id — exact, no smallness;
  (b) a q-free scalar divisor shift acts as the Novikov rescaling
  Q^d ↦ e^{⟨δ,d⟩}Q^d — an automorphism, exact; (c) a tail with *strictly
  negative* q-powers substituted into a series with *q-free* coefficients is
  per-slot finite: each tail factor strictly lowers the q-exponent, the slot
  q-power is pinned, so at most finitely many monomials contribute per
  (degree, Q^d, q-power). Note the per-slot count is finite, in fact bounded:
  at Q^0 the monomial order is at most dim X − 1.
- So: the *connection of V at a displaced parameter of shape (a)+(b)+(c) is a
  well-defined object*, and the germ isomorphism restricted to s = Q = 0
  (setting the *formal* displaced variables to zero — always legal) compares
  canonical points. What fails is only the pretense that the change of
  variables is an invertible *point map* between spaces of such parameters.

### Secondary question (string/divisor exactness)

Confirmed at connection level, refuted at function level. (a) and (b) are
disposable *exactly*, with no smallness, for connections: B4336–4339 ("the
pullback of connections is well-defined due to the Divisor Equation"),
B5395–5399. They are NOT disposable for function/parameter substitution:
B4335–4337. So "only part (c) is at issue" is wrong in both directions: at
connection level (c)-forward is also fine (q-free coefficients), while at
function level even (b) already fails.

---

## DEBT-LOCATION LEDGER (alt-attack pass)

The one obligation: make the primitive-sixth multiplicity nu_6 computed at one
parameter meet the decomposition identities, which live at other parameters.
Targets: (T1) nu_6 of the cubic threefold's zero block equals 2 at the
displaced parameter varsigma°; (T2) X × P^1 irrational without T1.

### The decisive new fact (found while assessing location 5)

**For the trivial bundle V = O ⊕ O, the Iritani–Koto displacement is a pure
H^0 (string-direction) shift: varsigma_j° = 2 λ_j = ±2 q^{1/2} exactly — the
O(q^{-1/2}) tail vanishes identically.** Derivation from the pinned sources:

- IK (5.11) (P3240–3253): varsigma_j° = r λ_j + [z^{-1}] log (q^{c1(V)/(rz)}
  F_j(1)); for V = O^{⊕2}, c_1(V) = 0 and r = 2.
- F_j(1) is the stationary-phase transform of section 5.3 (P2451–2537). For
  trivial V the Chern roots are 0, 0, so K(λ) = (Δ̃^λ_V)^{-1}·1 =
  λ^{-1} exp(−2 Σ_{n≥2} B_n/(n(n−1)) (z/λ)^{n−1}) by (3.4) (P1269–1290):
  a *pure scalar* series — no H^*(B)-classes enter at Q = tau-hat = 0.
- z-power count in F_0(1) = (1/√2) λ_0^{-1/2}[e^{z∂_s²/4} L(s,λ_0)]_{s=0}:
  a factor from e^{−φ≥3/z} contributes z^{−a} with s-degree ≥ 3a (φ≥3 has
  only s^{≥3}-terms, P2460–2466); the K-tail contributes z^{+b}, b ≥ 0; the
  Gaussian pairing of total s-degree m contributes z^{+m/2}. Net z-power
  = m/2 − a + b ≥ (3a)/2 − a + b ≥ a/2 + b ≥ 0. Hence log F_j(1) has **no
  z^{-1}-coefficient at all**, so [z^{-1}] log(...) = 0 and varsigma_j° =
  2λ_j. (This sharpens the referee's "−+2q^{1/2} + O(q^{-1/2})": the
  O(q^{-1/2}) is exactly zero for the trivial bundle. The generic
  O(q^{-1/r})-statement in the sources is a bound, not a nonvanishing claim;
  seed 3's suspicion was right.)
- An H^0-shift is string-exact: the quantum product is unchanged, the
  connection changes by (τ^0/z)·id = (±2q^{1/2}/z)·id, which shifts the
  exponential factors uniformly and changes no block's regular part. So
  **nu_6(cubic at varsigma_j°) = nu_6(cubic at 0) = 2, by the draft's
  existing block computation (trace −1, det 5/36, exponents −1/6, −5/6).
  T1 discharges.**

### The ledger

| # | Location and obligation as a precise assertion | What discharge requires | Verdict |
|---|---|---|---|
| 1 | Transport at the canonical parameter: restrict the germ isomorphism to Q = s = 0 (legal: s are formal variables, IK P3268–3272); then framed formal monodromy over C((q^{-1/s'})) is preserved by a gauge Φ with Φ, Φ^{-1} both z-power series with invertible constant term (IK P3297–3308). | Write out the standard fact that a z-regular gauge with z-regular inverse preserves the Levelt–Turrittin framed-monodromy multiset. Representation-theoretic, no analysis. | DISCHARGEABLE NOW. But it compares canonical points only; alone it does not bridge chain steps. |
| 2 | Constancy of nu_6 along displacements. Split by shape: (i) H^0-part — string-exact (above); (ii) q-free scalar divisor part — Novikov rescaling automorphism Q^d ↦ e^{⟨δ,d⟩}Q^d, exact; (iii) pure q-negative tail t·τ°, t ∈ [0,1]: by the per-slot finiteness lemma (verdict section, "what survives" (c)), the connection of V at t·τ° is defined for all t with matrix entries *polynomial in t per slot* (at Q^0 the monomial order is ≤ dim V − 1); the pencil is flat in the t-direction (Dubrovin flatness), so Cai's gauge argument applies on a domain that now genuinely contains t = 0 and t = 1. | For (iii): one lemma (per-slot finiteness + polynomiality in t, essentially written above) plus Cai's existing argument re-run over C[t]. No new theory; the previous weakness was domain, and the domain gap is exactly what the finiteness lemma closes. Caveat to verify: Cai's argument uses only flatness and the ring structure, not analyticity. | DISCHARGEABLE NOW (modulo writing the lemma; the only genuinely new ingredient is this session's finiteness bookkeeping). This is the debt's best home for the chain. |
| 3 | Substitution legality (this session's question): tau(tt) = target solvable at displaced points as a map of completions. | — | KNOWN FALSE (verdict above; Iritani B4335–4340). Do not route anything through it. |
| 4 | Atom equivalence well-definedness (KKPY): the invariant respects identification of base points across a connected spectral component. | A constancy statement equivalent to location 2 plus a globalization the sources do not contain. | Renames only (into 2), with extra globalization debt on top. NEEDS NEW THEORY if taken on its own terms. |
| 5 | Direct computation at the displaced parameter for O ⊕ O over the cubic. | Done: varsigma° = 2λ_j exactly (computation above, from IK (3.4), (5.5), (5.11)); string-exactness; the draft's block numbers. An independent finite check: expand F_j(1) for r = 2 to the first two orders in q^{-1/2} and confirm no z^{-1}-terms — a half-page Bernoulli/Gaussian bookkeeping anyone can verify. | DISCHARGEABLE NOW; the residual verification is DISCHARGEABLE BY FINITE COMPUTATION as described. **T1 is paid.** |
| 6 | Centres: nu_6(T, τ) = 0 for all τ, dim T ≤ 2. | The memo's induction (M1853–1877) applies operation identities at arbitrary parameters — illegal as stated (location 3). Repair: run the induction only at the parameters that actually arise, each of shape (a)+(b)+(c), using locations 1 + 2(i–iii) at every step. The KKPY nef-canonical base case is pointwise already. | DISCHARGEABLE NOW conditional on location 2(iii); no new content beyond it. |
| 7 | One-directional chain: traverse weak factorization so no inverse map is ever evaluated. | Use each blowup comparison only at its own canonical point (location 1) and bridge parameters with location 2. The zigzag W ← Bl → W' never needs the point-level inverse; "invertible change of variables" is needed only as germ data, which the sources give. | DISCHARGEABLE NOW as an architecture, conditional on 2(iii). This *is* the repaired route; it renames nothing — it relocates the debt into 2(iii) where it can be paid. |
| 8 | Different invariant with topological/representation-theoretic invariance. | Would need a summand invariant insensitive to the base parameter altogether; nothing in the pinned sources supplies one, and the Stokes/semiorthogonal warning (B121–133, Remark 1.5) suggests genuine parameter dependence of finer invariants. | NEEDS NEW THEORY. Not needed if 2(iii) pays. |
| 9 | Künneth at the endpoint: QDM(X × P^1) = QDM(X) ⊗ QDM(P^1) with no mirror map. | A quantum Künneth of that strength is not in the pinned sources and is false in general (genus-0 invariants of a product do not factor; the moduli space is a fibre product over M_{0,n}, not a product). | NEEDS NEW THEORY, and now unnecessary: location 5 already discharges the endpoint. |
| 10 | Birkhoff factorization factor (seed 4): show the z^{-1}-factor M' is harmless at displaced points. | M' = id + O(z^{-1}) is germ data in the s-variables (P3283–3308); evaluating it at unit-order s is location 3 again. | Renames only (into 3). |

### Target and why

Run **location 5 + location 2(iii)**, in that order.

- Location 5 is finished mathematics ending in an integer: varsigma° = 2λ_j,
  string-exact, nu_6 = 2. It converts the standing hypothesis T1 into a
  half-page verifiable computation. It beats everything else because its debt
  is already paid, not merely relocated.
- Location 2(iii) is the one remaining live debt for the chain (T2 via
  locations 1 + 6 + 7), and it is the unique location where the obligation is
  stated over a domain this session's finiteness lemma actually establishes:
  the pencil t·(pure q-negative tail) is a polynomial-per-slot family inside
  the sources' own rings, so Cai's constancy argument — whose weakness was
  domain, not validity — applies without extension of the coefficient ring,
  Hahn fields, or the e·w(Δλ) < ε criterion (M457–495 becomes moot for this
  route). Every displacement the chain produces decomposes as
  H^0-part + q-free divisor part + pure q-negative tail (B5301–5310 (5.34),
  B4312–4320 (5.19)), so 2(i)+(ii)+(iii) cover it with nothing left over.

If 2(iii) fails on inspection of Cai's argument (e.g. it secretly uses more
than flatness), the fallback is not 3, 4, 8, 9, or 10 — all either false,
renames, or new theory — but a direct finite computation of the specific
tails along the chain, which the per-slot boundedness (monomial order at most
dim − 1 at Q^0) makes finite in principle, though not small.

### Mystery ledger

- Settled this pass: the endpoint tail vanishes for the trivial bundle
  (varsigma° = 2λ_j exactly) — the surprise that pays T1; the grading's
  failure to rescue (CONT) is structural (defect-zero substitution), not an
  artifact of Iritani's ring choice.
- Open: whether Cai's gauge argument uses only flatness + ring structure
  (owner: location 2(iii) write-up); whether the exceptional-curve
  coefficients blocking the inverse are ever all-but-finitely zero for
  special centres (idle curiosity — no route needs it).
