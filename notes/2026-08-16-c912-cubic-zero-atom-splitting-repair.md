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
