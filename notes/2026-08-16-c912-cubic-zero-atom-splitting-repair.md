# The cubic zero-atom splitting step: assessment of the proposed repair

**Date:** 2026-08-16 · **Lane:** `cubic-threefolds` · **Task:** C912 · **Purpose:**
adjudicate the proposed repair of the one genuinely conditional input of the rank-two
atomic residue proof, namely the claim that the eigenvalue-`0` packet of the cubic
threefold does not split further near the hyperplane point.

Background: `notes/2026-08-15-c912-atom-residue-proof-verification.md`, Part I Check C
("the Example 6.21 problem"), which found that the parity ranks `(2, 10)` — and with them
the headline `m = 1` theorem in its unconditional form — rest on an assertion inside
Katzarkov–Kontsevich–Pantev–Yu's worked Example 6.21 (arXiv:2508.05105v2), whose cited
support, their Remark 3.14, contains no proof and controls only the restriction of the
multiplication operator to a Witt-orbit germ.

## Verdict

**The repair works, and the objection is now discharged in principle.** The splitting
statement can be proved from scratch; it does not have to be imported from a worked
example. Three changes to the proposed route before it is written up:

1. The cited theorem is **Proposition 14**, not Proposition 15, of David–Hertling.
2. **Do not import it as a complex-analytic theorem.** Its proof reduces to a homogeneous
   linear first-order system with vanishing initial data, and the Cauchy–Kovalevskaya step
   is used only for uniqueness of the zero solution. Over the non-archimedean base that
   step must be replaced by a formal Taylor induction plus the Krull intersection theorem.
   Importing the theorem as stated would reintroduce exactly the archimedean-import defect
   that the pairing-horizontality lemma had to be re-proved to remove
   (`notes/2026-08-15-c912-owed-lemmas.tex`).
3. A **spectrum-transfer lemma** is missing. The proposed discriminant is that of the
   characteristic polynomial on the four-dimensional even/Hodge part, whereas
   `U_X` is defined by the eigenvalue count of `Eu ⋆ (−)` on all of `H^•(X)`. The two
   counts agree, but that needs two lines and is not stated.

In the case actually needed the whole David–Hertling computation collapses to a half-page
argument in dimension two, given below in §4. The finished proposition can therefore avoid
citing their theorem as a black box altogether, and cite it only for attribution.

One consequence to record separately: the Euler-vector-field sign discrepancy that the
verification note logged as "open, but harmless here" (its mystery ledger, row 3) is
**no longer harmless**. The new proposition needs `L_E(∘) = ∘`, which fails for the Euler
field as displayed in the source. See §6.

---

## 1. The source's internal inconsistency: confirmed, and sharper than reported

The claim under test is that Katzarkov–Kontsevich–Pantev–Yu's own displayed cubic-threefold
matrix, their Example 6.6(ii), is incompatible with the spectrum their Example 6.21 asserts.
Recomputed independently:

| matrix | `chi_K(lam)` | spectrum | distinct |
|---|---|---|---|
| Example 6.6(ii) as displayed | `lam^4 − 108 q lam^2 + 576 q^2` | `± sqrt(54q ± 6 sqrt(65) q)`, all nonzero | 4 |
| same, with the corner entry `36 q^2` at slot `(1,4)` (Cai; the manuscript) | `lam^2 (lam^2 − 108 q)` | `± 6 sqrt(3q)`, `0` doubled | 3 |

So the displayed matrix is not merely missing the eigenvalue `0`: it is **regular
semisimple**, with four distinct eigenvalues at every `q ≠ 0`. On their own display the even
part of the cubic would decompose into four rank-one packets and Example 6.21's
"two one-dimensional atoms plus one `0`-atom" would be impossible — not a near miss, a
different F-manifold. The corner slot is the only entry of that matrix carrying a
quantum correction of Novikov degree two, which is consistent with a dropped term rather
than a different convention.

The second row agrees with the manuscript's own block reduction
(`papers/cubic-stabilization-epilogue/sections/04-one-step.tex`, (4.9a)–(4.9e)) and with
the independent recomputation in the verification note §7, both of which give
`{6r, −6r, 0, 0}` with `r = sqrt(3q)`.

**Replay.** `uv run --with sympy python3 notes/scripts/c912_kkpy_cubic_charpoly.py`
(committed with this note; asserts both rows and fails loudly if either changes).

**Consequence.** Example 6.21 should not be cited for anything, in either direction. It is
right about the spectrum and wrong about the matrix it is computed from, and the paper does
not say which of the two displays is the error. Everything the argument needs about the
cubic's small even connection is available from Cai (arXiv:2608.01577v1, §3) and from the
manuscript's own reduction, neither of which depends on it.

## 2. David–Hertling: what the theorem actually says

Liana David and Claus Hertling, *Regular F-manifolds: initial conditions and Frobenius
metrics*, arXiv:1411.4553, published in Annali della Scuola Normale Superiore di Pisa,
Classe di Scienze (5) **17** (2017), 1121–1152. Cached as `arXiv:1411.4553`,
sha256 `7a4a81f95091e19c4eb9aa6b82fb993f61ac365090c1435eed42c9c141a3e818`.

The relevant statement is **Proposition 14** (their §3, pp. 10–13), verbatim:

> Let `(M, ◦, e, E)` be an `F`-manifold of dimension `n ≥ 2`, such that at a point
> `p_0 ∈ M`, the endomorphism `U_{p_0} = (C_E)_{p_0} : T_{p_0}M → T_{p_0}M` is regular,
> with exactly one eigenvalue. Then there is a neighborhood `V` of `p_0`, such that
> `(V, ◦, e, E)` is globally nilpotent (and regular).

Their Corollary 15 is a different statement — the Lie brackets of the canonical frame on a
globally nilpotent regular F-manifold — so the number has to be corrected in any write-up.

Definitions used (their Definition 4): *globally nilpotent* means every multiplication
operator `C_X`, not just `C_E`, has exactly one eigenvalue at every point; *regular* means
`U = C_E` has coinciding characteristic and minimal polynomials, equivalently a cyclic
vector, equivalently distinct Jordan blocks carry distinct eigenvalues.

Three features make this a better citation than the source's Remark 3.14:

- It is a proposition with a proof, and the conclusion is about `U` on the whole tangent
  bundle, not about its restriction to a Witt-orbit germ.
- It needs no metric and no Frobenius structure — the F-manifold axioms and `L_E(∘) = ∘`
  are the entire input.
- It assumes regularity at the one point `p_0` only; regularity nearby is a consequence.

The conclusion is also stronger than the argument needs: not only does `U` keep exactly one
eigenvalue near `p_0`, every `C_X` does.

## 3. Why it must not be imported, and what to do instead

David–Hertling work on a complex manifold, and the last step of their proof invokes the
uniqueness half of Cauchy–Kovalevskaya. The base here is
`B_X^{Hod}`, a connected smooth non-archimedean `k`-analytic space over the Novikov field.
Citing a complex-analytic theorem for a statement about that base is the same defect the
verification note raised against the pairing step, and it would be conspicuous in a proof
whose selling point is that it needs no archimedean input.

The proof is nonetheless importable, because of how it is organized:

1. Regularity gives the canonical frame `X_k := E^{◦k}` (`X_0 = e`), with the Witt relations
   `[X_i, X_j] = (j − i) X_{i+j−1}` — an algebraic consequence of the F-manifold axioms,
   proved by Hertling–Manin, valid over any base.
2. Cayley–Hamilton applied to `U` and evaluated on `e` gives one vector-field relation
   `X_n + Σ λ_k X_k = 0` with `λ_k` the characteristic-polynomial coefficients.
3. Taking Lie derivatives of that relation along each `X_s` and using the Witt relations
   produces closed formulas for `X_s(λ_k)`. These are identities in the structure sheaf,
   obtained by comparing coefficients of a polynomial identity; no analysis enters.
4. The deviation functions `f_k := λ_k − (C(n,k)/n^{n−k}) λ_{n−1}^{n−k}`, `0 ≤ k ≤ n−2`,
   vanish simultaneously at a point exactly when `U` has one eigenvalue there, and satisfy a
   **homogeneous linear** system `X_i(f_k) = Σ_s a^{(i)}_{ks} f_s`. In a chart this reads
   `∂ f / ∂ y^i = B_i f` with `f(p_0) = 0`.
5. Cauchy–Kovalevskaya is invoked only to conclude `f ≡ 0`.

Step 5 does not need Cauchy–Kovalevskaya. A homogeneous linear first-order system in a
coordinate frame with vanishing initial value forces every Taylor coefficient at `p_0` to
vanish, by induction on total order: differentiate the system, apply Leibniz, and every term
on the right carries a lower-order derivative of `f` evaluated at `p_0`. The only arithmetic
required is that `n^{n−k}` and the binomials be invertible, i.e. characteristic zero, which
the Novikov field satisfies.

So over `k`:

- `f_k` lies in `∩_N m_b^N` inside `O_{B,b}`;
- `O_{B,b}` is a Noetherian local ring at the `k`-rational rigid point `b`, so Krull's
  intersection theorem gives `f_k = 0` as a germ;
- hence the discriminant vanishes on a neighborhood of `b`, and the identity principle on
  the connected smooth — therefore irreducible — base propagates it to all of `B_X^{Hod}`.

The identity principle on an irreducible `k`-analytic space is already on the proof's input
list (verification note, external input 5; `owed-lemmas.tex` "still owed" item iv), so this
route adds no new analytic hypothesis at all.

**Architecture recommendation.** Run the entire local part of the argument inside the formal
completion `Ô_{B,b} ≅ k[[y_1, …, y_4]]`, and cross back to the analytic germ exactly once,
by Krull. Everything the argument uses is then formal and characteristic-zero algebraic:
Hensel lifting of the idempotents, the germ decomposition, the canonical frame, the Witt
relations, the deviation system. No non-archimedean analytic subtlety survives, and the only
analytic statement left in the whole splitting proposition is the identity principle used
for globalization.

## 4. In the case needed, the computation is half a page

Only `n = 2` is required, and there the David–Hertling system is a two-line calculation that
can be written out in full rather than cited. Let `(M_0, ◦, e, E)` be the two-dimensional
factor, `U = C_E`, and `z^2 + λ_1 z + λ_0` its characteristic polynomial. Regularity at `b`
makes `X_0 = e`, `X_1 = E` a frame, and Cayley–Hamilton gives
`X_2 + λ_1 X_1 + λ_0 X_0 = 0` with `X_2 = E ◦ E`. Lie differentiation along `X_0` and `X_1`,
using `[X_0, X_1] = X_0`, `[X_0, X_2] = 2X_1`, `[X_1, X_2] = X_2`, yields

    X_0(λ_0) = −λ_1 ,   X_0(λ_1) = −2 ,   X_1(λ_0) = 2λ_0 ,   X_1(λ_1) = λ_1 .

With `Δ := λ_1^2 − 4λ_0` the discriminant, these give directly

    X_0(Δ) = 0 ,        X_1(Δ) = 2Δ .

`Δ(b) = 0` because `U_b` is nilpotent, so the Taylor induction of §3 applies to the single
function `Δ` and gives `Δ = 0` in `Ô_{B,b}`, hence as a germ, hence identically. Verified by
hand against David–Hertling's general formulas (their (19), (20), (26)), which at `n = 2`
read `X_0(f_0) = 0`, `X_1(f_0) = 2 f_0` with `f_0 = λ_0 − λ_1^2/4 = −Δ/4`.

That the two-dimensional factor is regular at `b` is exactly the statement that the nilpotent
part of the packet is a single Jordan block, i.e. `nu = 2 ≠ 0` in the manuscript's block data
`J_0 = [[0, 2], [0, 0]]`. The same non-vanishing drives the rank-two residue lemma, where `nu`
being a unit is what forces `k_δ = 0`. Worth a remark in the write-up: one entry carries both
steps.

## 5. The remaining links of the proposed chain

**Germ decomposition into factors of dimensions 1, 1, 2.** The tangent algebra at `b` is
`k[λ]/(λ^2(λ^2 − 108q)) ≅ k × k × k[x]/(x^2)`, since `U` is cyclic. Hertling's decomposition
theorem then splits the germ accordingly. Over `k`: the idempotents lift by Hensel from the
coprime factorization `λ^2 · (λ^2 − 108q)`, and the integrability of the resulting
distributions is the formal Frobenius theorem in characteristic zero — available in
`Ô_{B,b}` without any convergence question, which is the reason for the architecture
recommendation in §3. **This is an input and must be stated as one.** It is the only place
where the proposition uses more than Cayley–Hamilton and the Witt relations.

**From a local statement to `b ∈ U_X`.** Sound as proposed. The three eigenvalues are
pairwise distinct at `b` (`0 ≠ ± 6 sqrt(3q)` for `q ≠ 0`, and `q` is never `0` on the base),
so they stay distinct nearby and the count is exactly three on a neighborhood; the
discriminant of the quartic therefore vanishes there, hence identically on the connected
base, hence the count never exceeds three anywhere; it equals three at `b`; so the maximum
is attained at `b` and `b ∈ U_X`.

**The missing spectrum-transfer lemma.** The source defines `U_X` by the number of
eigenvalues of `Eu ⋆ (−)` on `H^•(X)`, which is 14-dimensional for the cubic, while the
discriminant above is that of the four-dimensional tangent algebra `A_τ = (H^{even}, ⋆_τ)`.
The counts agree, and the reason is short: `τ` is even, so `⋆_τ` preserves parity and
`H^•(X)` is a unital `A_τ`-module; writing `A_τ = ∏_i A_i` for its local factors with
idempotents `ε_i`, one gets `H^• = ⊕_i ε_i H^•`, and `ε_i H^• ≠ 0` because
`ε_i ∈ A_i ⊆ H^{even} ⊆ H^•`. On `ε_i H^•` the operator `Eu ⋆ (−)` has the single eigenvalue
`λ_i`. Hence the two spectra coincide as sets, at every point of the base. Two lines, but
without them the discriminant argument addresses a different locus than the one `U_X` is
defined by.

**The rank argument.** Correct. The generalized eigenbundle ranks are locally constant on the
unramified reduced cover, so constant on each connected component; at `b` they are `1`, `1`
and `12`, so no monodromy element can carry the rank-twelve sheet to a rank-one sheet, and the
zero branch is a full connected component, i.e. an atom.

**The parity ranks.** `(2, 10)` then follows, with the annihilation of `H^3(X)` by the grading
argument that the verification note already reproduced independently (the Novikov-degree-`d`
term of `c_1 ⋆ α` for `α ∈ H^3` lands in `H^{5−4d}`, and `H^5 = H^1 = 0`). The two downstream
exclusions are unaffected: a genus-`g ≥ 1` curve's unique atom has ranks `(2, 2g)`, forcing
`g = 5`, and a minimal surface with nef canonical class has even rank at least three.

## 6. The Euler-field sign is now load-bearing

The verification note logged, as an incidental source observation, that the source's displayed
Euler vector field (its (3.31), `Eu_γ = c_1(TX) + ((Deg − 2·id)/2)(γ)`) carries the opposite
sign on the non-`c_1` part to the standard `E = c_1 + Σ (1 − deg/2) t_i T_i`, and that with
their sign the flatness identity fails on the genus-`g` curve. It was recorded as harmless
because the target never used (3.31).

The new proposition does use it. David–Hertling's Proposition 14 — and equally the
half-page computation of §4, and the Witt relations both rest on — requires
`L_E(∘) = ∘`, which holds for the standard Euler field and fails for the displayed one. The
write-up must say which field it uses, note that at `b` the two agree because the `H^2`
grading coefficient vanishes there, and note that they differ in the `H^0`, `H^4` and `H^6`
directions, which is precisely where the neighborhood argument lives. The same remark
weakens the source's Remark 3.14 further: its Witt-algebra content is the relation
`[X_i, X_j] = (j − i) X_{i+j−1}`, which is unavailable for the Euler field as they display it.

## 7. Effect on the proof's input list

Replacing input 3 of the verification note ("Example 6.21's atomic composition, including no
further splitting at the hyperplane point — asserted, not proved") with a proved proposition
whose inputs are:

- Cai's small even quantum connection and the manuscript's block reduction (already input 8);
- Hertling's decomposition of an F-manifold germ, in its formal form over `k` (new);
- the Witt relations of Hertling–Manin, and Cayley–Hamilton (new, elementary);
- Krull's intersection theorem in `O_{B,b}` (new, elementary);
- the identity principle on an irreducible `k`-analytic space (already input 5);
- the spectrum-transfer lemma of §5 (new, two lines, ours).

No new analytic hypothesis, no archimedean import, and one fewer unproved assertion. The
statement to prove is, as proposed:

> **Proposition (cubic zero atom).** For every smooth cubic threefold `X` the hyperplane
> point `b` lies in `U_X`. The reduced spectral cover has over it two rank-one components,
> corresponding to the two non-zero eigenvalues of `Eu ⋆ (−)`, and one component whose
> generalized eigenbundle has parity ranks `(2, 10)`; the latter is a Hodge atom `α_X`.

The other owed items are untouched by this: the even part being a sub-F-bundle, the transfer
of horizontality to a single even spectral factor, uniqueness and gluing of the spectral
splitting, and descent of the invariant through the blowup, projective-bundle and
disjoint-union equivalences (`notes/2026-08-15-c912-owed-lemmas.tex`, "still owed").

## 8. What is not yet checked

1. The half-page `n = 2` computation of §4 was verified by hand and against David–Hertling's
   general formulas, but not yet written as a proof with its hypotheses stated, and not yet
   adversarially reviewed.
2. The formal Frobenius/idempotent step of §5 is asserted to be routine over `k[[y]]`. It is,
   but it has not been written out, and it is the one remaining place where a referee could
   ask for a citation that may not exist in the non-archimedean literature.
3. Nothing here has been tested against the possibility that `B_X^{Hod}` fails to be
   irreducible for some cubic. The source states it is connected and smooth, which suffices,
   but that sentence has been read only in the verification pass, not re-checked here.
4. An independent route exists and has not been tried: since `H^{even}(X)` is generated by the
   hyperplane class, the even part of the big quantum product on the Hodge base may be
   reconstructible from three-point invariants, which would let the persistence of the double
   eigenvalue be verified by direct computation rather than by the F-manifold theorem. The
   obstruction is that WDVV applied to even insertions sums over the full basis, including
   `H^3`, so the even sector may not close on itself. Worth a bounded attempt as an
   independent check on the whole proposition, not as a replacement for it.

---

# Part II — the second round: a full proof, and one further simplification

Written the same day, after a second red-team pass produced a complete proof in which the
David–Hertling citation is replaced by a self-contained two-dimensional lemma derived from
the Witt identities. Items are numbered as in that pass.

## 9. The two-dimensional non-splitting lemma: verified, with one missing sentence

The lemma proposed is: on a two-dimensional F-manifold over a field of characteristic zero,
if `C_E` at `p` is a non-scalar single Jordan block then `C_E` has one eigenvalue on a whole
neighbourhood. Re-derived here independently, and it is correct.

`e` and `E` are independent at `p` (otherwise `C_E` is scalar), so they frame the germ; write
`E ∘ E = aE + be`. In that frame `C_E = [[0, b], [1, a]]`, with characteristic polynomial
`T² − aT − b` and discriminant `D = a² + 4b`. The Witt identities `[e, E] = e`,
`[e, E∘E] = 2E`, `[E, E∘E] = E∘E` give

    [e, aE + be] = e(a)E + (a + e(b))e = 2E   ⟹   e(a) = 2 ,  e(b) = −a ,
    [E, aE + be] = E(a)E + (E(b) − b)e = aE + be   ⟹   E(a) = a ,  E(b) = 2b ,

whence `e(D) = 2a·2 + 4(−a) = 0` and `E(D) = 2a·a + 4·2b = 2D`. Since `e, E` frame the germ,
`dD = D·ω` for the analytic one-form dual to `(0, 2)` in that frame. If `D ≠ 0` in the
completed local ring, its lowest nonzero homogeneous part `D_m` has `m ≥ 1` because
`D(p) = 0`, and comparing lowest degrees in `dD = Dω` gives `dD_m = 0`, hence `m·D_m = 0` by
Euler's relation, hence `D_m = 0` in characteristic zero. Contradiction.

**The missing sentence.** That argument gives `D = 0` in the *completed* local ring. The
step to `D = 0` as a germ is Krull's intersection theorem in the Noetherian local ring
`O_{B,b}`, as in §3 above. The proposed write-up says "hence `D ≡ 0` in the germ" without it.
One sentence, but it is the sentence that makes the formal argument bite on the analytic
object.

## 10. The lemma holds in every dimension, which removes the decomposition step

The proposed proof reaches the two-dimensional situation by decomposing the germ of the
rank-four Hodge sector into factors of dimensions `1`, `1`, `2` and applying the lemma to the
last one. That decomposition is the weakest remaining link: the source's spectral theorem
decomposes the *F-bundle* according to separated eigenvalues, whereas what is needed is a
decomposition of the *base germ* into a product of F-manifolds, each with its own unit and
Euler field. That is Hertling's decomposition theorem, proved complex-analytically — so the
route reintroduces, one level down, exactly the category mismatch it was written to avoid.

It is not needed. The discriminant identity holds in every dimension:

> **Lemma.** Let `(M, ∘, e, E)` be an F-manifold with Euler field, regular at `p`, let
> `U = C_E` with characteristic polynomial `P(z) = z^n + Σ λ_k z^k`, and let `Δ` be the
> discriminant of `P`. Then `X_s(Δ) = c_s Δ` for every `s < n`, where `X_s = E^{∘s}` is the
> canonical frame and
>
>     c_0 = 0 ,   c_1 = n(n−1) ,   c_2 = −2(n−1) λ_{n−1} ,
>     c_3 = 2(n−1) λ_{n−1}² − (4n−6) λ_{n−2} .
>
> Consequently `dΔ = Δ·ω` with `ω` analytic, and if `U_p` has a repeated eigenvalue then
> `Δ = 0` on the germ at `p`.

The reason is transparent: David–Hertling's coefficient formulas (their (19), (20), (24),
(25)) say exactly that `X_s` acts on the eigenvalues by `μ_i ↦ μ_i^s`. Since
`Δ = Π_{i<j}(μ_i − μ_j)²`, one gets
`X_s(Δ)/Δ = 2 Σ_{i<j} (μ_i^s − μ_j^s)/(μ_i − μ_j) = 2 Σ_{i<j} h_{s−1}(μ_i, μ_j)`, a symmetric
polynomial, hence a polynomial in the `λ_k`. At `s = 0` it is `0` and at `s = 1` it is
`n(n−1)` by Euler's relation, recovering the two-dimensional case `e(D) = 0`, `E(D) = 2D`.
The endgame is then the same lowest-degree argument, applied to `Δ` rather than to `D`.

**Verified symbolically** for `n = 2, 3, 4`: both that the four published coefficient formulas
coincide with the derivation `μ_i ↦ μ_i^s` (which also confirms the transcription and their
algebra), and that `X_s(Δ) − c_s Δ = 0` identically for every `s < n`.
Replay: `uv run --with sympy python3 notes/scripts/c912_fmanifold_discriminant_identity.py`.

**Why this matters for the cubic.** `n = 4` is the Hodge-invariant sector
`H^0 ⊕ H^2 ⊕ H^4 ⊕ H^6`, and `s ≤ 3` is exactly the range David–Hertling publish, so no
unpublished extension of their computation is needed. The lemma applies directly at `b`,
where `U` is regular because the zero block is a single Jordan block (`ν = 2 ≠ 0`) and the
two nonzero eigenvalues are simple. Nothing is restricted, nothing is decomposed, and the
only hypothesis used is regularity at the single point `b`.

This closes the second of the two items ranked red in the red-team pass — the worry that the
restricted rank-four object might not satisfy the hypotheses a regular-F-manifold theorem
needs. There is no restriction and no imported theorem: the Witt identities, Cayley–Hamilton
and Euler's relation are the whole input.

## 11. Integrality of the base is a citation, not an open problem

The first red item — that the discriminant continuation needs the base to be integral, and
that connectedness alone does not give it — is answered without any explicit description of
the Hodge base:

> **Conrad, *Irreducible components of rigid spaces*, Annales de l'Institut Fourier 49 (1999)
> 473–541, Lemma 2.1.4:** let `X` be a connected normal rigid space and `U` a non-empty
> admissible open. The only analytic subset of `X` containing `U` is `X` itself.

Applied to the zero locus of the discriminant, which is an analytic subset containing a
neighbourhood of `b`, this gives `Δ ≡ 0` on the whole base. The source already states that
the fixed locus is connected and smooth, and smooth implies normal, so both hypotheses are in
hand. The proposed alternative — displaying the Hodge base explicitly as a product of an
annulus, an affine line and two discs — would additionally have to be checked against the
source's actual construction, and buys nothing.

The same lemma settles the third red item, constancy of the residue invariant across a locus
where the nilpotent part vanishes: the reduced spectral cover is unramified over a smooth
base, hence smooth, hence normal, so each connected component is irreducible and the
meromorphic-continuation step is legitimate.

**One choice for the write-up.** Conrad's statement is for rigid spaces. If the source's
spaces are Berkovich `k`-analytic spaces rather than rigid spaces, cite the corresponding
Berkovich result (Ducros) instead; the two theories agree on the good, quasi-separated spaces
in play, but the manuscript should not mix the categories silently.

## 12. Items already discharged on this side

Two of the red-team items are already closed here and need no further work:

- **The pairing in the non-archimedean setting.** Horizontality of the Poincaré pairing over
  the Novikov ring was proved on 2026-08-15 and committed
  (`notes/2026-08-15-c912-owed-lemmas.tex`, §Horizontality, with the Frobenius and
  anti-self-adjointness lemmas; independently checked in
  `notes/2026-08-15-c912-horizontality-check.md`). What remains is not the pairing itself but
  its restriction to a single even spectral factor carrying a `u`-dependent `P(u)`, together
  with spectral orthogonality and non-degeneracy there — item (i′) of that note's "still
  owed" list. The proposed proof by Sylvester invertibility at distinct leading eigenvalues
  is the right argument for exactly that item.
- **The elementary-modification algebra.** It has already had the independent from-scratch
  audit that was asked for: `notes/2026-08-15-c912-atom-residue-proof-verification.md`, §§1–2,
  which re-derived `N^T P_0 = P_0 N`, the isotropy of `im N`, the constant-order identity and
  `A_0 ker N ⊆ ker N`, and §7, which recomputed the block reduction and the residue
  `R_X = [[−19/18, 2], [−8/81, 1/18]]` from Cai's matrix without using the target's
  intermediate numbers, then cross-checked its eigenvalues against the manuscript's indicial
  exponents derived by an unrelated route. No effort should go there.

## 13. The residue discriminant is the right normalization

Replacing the characteristic polynomial of the residue by `δ = (ρ_1 − ρ_2)² = (tr R)² − 4 det R`
is a good trade and costs nothing. The earlier verification found that
`tr R_X = tr R_C = −1` on both sides for structural reasons, so the trace never discriminated
anything; the entire separation was always carried by the determinant. Passing to `δ` discards
exactly the coordinate that was never doing work, and buys invariance under scalar and power
shifts. The values are `δ(α_X) = 1 − 20/36 = 4/9` for the cubic and `δ = 0` for the
genus-five curve, matching `(T + 1/6)(T + 5/6)` against `(T + 1/2)²`.

## 14. One item is greener in the write-up than the evidence supports

The proof's §VI establishes that the invariant descends through the source's Definition 5.21,
both clauses. But Hodge atoms are not the quotient by those two relations: the source's §5.4
defines `HAtoms` as a quotient by the equivalence generated by **disjoint unions, blowups with
smooth centres, and projective bundles**. The comparison the theorem makes — "`α_X` is not an
atom of any curve or surface" — is an identification across two different varieties, so it
lives in that larger quotient, and the invariant must be shown constant on its classes. This
was flagged on 2026-08-15 (`...-atom-residue-proof-verification.md`, §5, "GAP") and is
unaddressed in the new write-up, where it does not appear in the risk ranking at all.

It is fillable and probably short: the source's Proposition 5.22 realizes each elementary
equivalence by an isomorphism of the geometric atomic F-bundles, and isomorphism-invariance is
already proved. But it has to be written, and until it is, the descent claim is about a
different object from the one the theorem quantifies over.

## 15. Status after round two

The two items ranked red both close: local non-splitting by §10, and the global maximality of
the spectrum by §11. Both close using less machinery than proposed, not more. What remains,
in order:

1. **Amber.** Restriction of the horizontal pairing to a single even spectral factor, with
   orthogonality and non-degeneracy there — the standing item (i′).
2. **Amber.** Descent of the invariant through the blowup, projective-bundle and
   disjoint-union equivalences, per §14.
3. **Yellow.** Two source-facing checks not yet done here: that the source's Lemma 5.19 really
   states that the reduced spectrum may be read on the Hodge-invariant sector (if it does not,
   the two-line module argument of §5 above proves it), and that the even part is a
   sub-F-bundle.
4. **Structural, and not removable.** The whole route rests on an unrefereed preprint whose
   projective-bundle theorem itself reduces to Iritani–Koto. "Unconditional" here means
   unconditional relative to that package, and the manuscript must say so in those words.

None of these is a mechanism question. All four are statements to write, cite, or check at
the source.

---

# Part III — the source re-read, and a withdrawal

All three points intended for an erratum were re-checked directly against the cached
arXiv:2508.05105v2 text (sha256 `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64`).

## 16. Equation numbering: both numberings are correct

The paper displays the quantum connection and the Euler vector field **twice**: (3.19) and
(3.20) for the formal logarithmic A-model F-bundle, and (3.30) and (3.31) for the
non-archimedean analytic one, with identical formulas

    nabla_{d_u} = d_u − u^{-2}(Eu * (−)) + u^{-1}(Deg − dim X · id)/2 ,
    Eu_gamma = c_1(TX) + ((Deg − 2·id)/2)(gamma) .

So the earlier note's (3.30)/(3.31) and the second reader's (3.19)/(3.20) are both right and
refer to different displays of the same content. An erratum should cite both pairs; citing
only one invites the reply that the other display is the intended one.

## 17. The cubic matrix: now certain, and provable purely internally

Confirmed at the source that the displayed matrix in Example 6.6(ii) has a zero in the corner
slot `(1,4)`, with `K = 2A`. The correction is forced by the paper's own machinery, and the
argument can be given entirely in their terms:

- Their **Example 6.6(i)** works the quadric threefold by exactly this method: put unknowns in
  the slots the index allows, eliminate to a fourth-order ODE, and compare with Givental's
  quantum differential equation. That example is internally consistent — it yields
  `a_1 + a_2 = 4`, `a_2 = 2`, matching its displayed matrix.
- Their **(6.4)**, specialized to the cubic (`N = 5`, `k = 1`, `d = 3`, `d_tot = 3`), gives
  `delta^4 phi = 3q(3delta + u)(3delta + 2u) phi = q(27 delta^2 + 27 u delta + 6 u^2) phi`,
  with `delta = u q d_q` and **no `q^2` term**.
- Eliminating from their displayed matrix with an unknown corner entry `b q^2` gives
  `delta^4 phi = q(27 delta^2 + 27 u delta + 6 u^2) phi − (36 − b) q^2 phi`.
  Derived here by hand from the entries `6q`, `15q`, `6q` alone, and independently by the
  second reader; the two agree.

The three coefficients `27`, `27`, `6` match between the two computations, which confirms both
the rest of their matrix and the elimination, and isolates the corner as the sole discrepancy.
Hence `b = 36`, their Example 6.21's spectrum `{lambda_+, lambda_-, 0, 0}` is the correct one,
and the display in 6.6(ii) has lost the only entry of Novikov degree two. Cai is not needed to
say any of this, and neither is our block reduction.

## 18. Remark 3.14: the scope objection is withdrawn

The verification note of 2026-08-15 raised two objections to Example 6.21's appeal to
Remark 3.14. The second one — that Remark 3.14 asserts constancy only along the Witt-orbit
germ `W`, whereas `U_X` is a locus in `B_X^G` — **is withdrawn**, for a reason that is correct
and that the earlier pass missed.

Remark 3.14 defines `W` by `span_k{Eu^k_w}_{k>=0} = T_{W,w}`. For the cubic, once the matrix is
corrected, the minimal polynomial of `Eu ⋆ (−)` on the even part has degree four, so the Witt
powers `1, Eu, Eu^{◦2}, Eu^{◦3}` already span the whole four-dimensional even tangent space at
`b`. Any integral germ of that distribution is therefore open in `B^{ev}`, so `W` **is** the
full even germ. For a cubic threefold `B^{ev} = B^{Hod}`, since every even cohomology class is
a Hodge class. The promotion from `W` to the even base is thus not a gap; the remark is
compressed, not wrong.

**What still stands, and how to say it.** Remark 3.14 carries no proof and cites no source for
its constancy statement; the string "Witt algebra", for which Examples 6.19 and 6.21 cite it,
does not occur in it. The right form of this observation is not an error report but a
reference: on `W` the operator `κ|_W` is cyclic by construction, so `W` is a *regular*
F-manifold, and the constancy assertion is exactly David–Hertling's theorem for regular
F-manifolds (arXiv:1411.4553, Proposition 14 with their germ decomposition). Telling them that
is useful and costs nothing; telling them the remark fails to support Example 6.21 would be
wrong.

## 19. Why this does not touch our own proof

The withdrawal changes the framing of our lemma and not its necessity, for a reason that is
easy to lose: **Remark 3.14 is a local statement, and `U_X` is defined by a global maximum.**
Even granting the remark in full, and granting `W = B^{Hod}` for the cubic, what follows is
that the eigenvalue count is constant near `b` — not that three is the maximum attained
anywhere on `B_X^{Hod}`. Atoms are connected components of the reduced cover over the locus
where the count is globally maximal, so `b ∈ U_X` still needs the step that neither the remark
nor Example 6.21 supplies: the discriminant vanishing identically on the whole base, which is
what §10 and §11 above prove.

So the position after the re-read is: their Example 6.21 asserts a conclusion that is true, by
an argument that is unproved in their text but correct and attributable, and whose local form
is in any case insufficient for the conclusion drawn. Our contribution is the global step, and
it is unaffected.

## 20. The sign inconsistency: verified, and it is visible in two independent places

Both confirmed at the source, and they are independent of each other:

1. `κ` is defined twice. In the F-bundle definitions it is
   `κ = nabla_{u^2 d_u}|_{H_{u=0}}`, the residual endomorphism; in the Frobenius-manifold
   discussion it is `κ := Eu ◦ (−)`. With their own connection (3.19)/(3.30), the first gives
   `κ = −(Eu ⋆ (−))`, so the two definitions differ by a sign. The same collision recurs in
   §6.1, where the connection is written with `−u^{-2}K` and `K` is then said to be the action
   of `κ`.
2. Their Witt relation (2.5), `[Eu^k, Eu^l] = (l − k) Eu^{k+l−1}`, gives `[e, Eu] = e` at
   `k = 0`, `l = 1`. But (3.20)/(3.31) contribute `−t_0 d_{t_0}` in the unit coordinate, since
   `deg(1) = 0` makes the coefficient `(0 − 2)/2 = −1`, giving `[d_{t_0}, Eu] = −d_{t_0}`. The
   standard Frobenius coefficient `(2 − Deg)/2` gives the sign their own (2.5) requires. This
   argument involves neither `u` nor `q`, so their Remark 3.21 change of convention `u ↦ −u`
   cannot account for it.

Report it as an inconsistency among the definitions rather than prescribing which sign to
change, since more than one repair is available and the choice interacts with Remark 3.21.

## 21. Consequence for our own record

The 2026-08-15 verification note's Check C should be read with §18 above: its first prong (no
proof, wrong attribution) stands, its second prong (constancy along `W` is weaker than local
constancy on the base) is withdrawn for the cubic. Nothing downstream changes, because §19.
