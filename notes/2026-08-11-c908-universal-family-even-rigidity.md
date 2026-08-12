# C908: full-monodromy rigidity — the universal-family source is even in (1,5)

Date: 2026-08-11

Status: **pass-5 primary theorem proved (human proof, literature-gated at two
classical loci); the reposed construction target is reduced to a single bit
`λ ∈ {0,1}` with an explicit computation plan.** C908 mathematics only; no
manuscript, PDF, mirror, Lean, or C904-surface edit.

Notation as in the pass-2 note (`m-cross-m-exceptional-residue`) and pass-4
note (`unmarked-closure-and-w-twist`): `X` a smooth cubic threefold,
`J = J(X)`, `Θ ⊂ J` the canonical theta divisor with unique singular point at
`0`, `M = Bl_0 Θ`, `b : M → J`, `h = b^*Θ`, `Λ = H^1(J,Z)`,
`φ : H^3(X,Z) ≅ Λ` the Clemens–Griffiths isometry, `S` the (unimodular) Gram
matrix of the polarization form in the exotic principal basis,
`Q_15 = coker(L : ∧^5Λ → ∧^7Λ) = (Z/2)^10`, `P` the perfect mod-two readout
pairing, and `φ(W) ∈ End_{F_2}(Λ_2)` the `(1,5)` residue with degree readout
`tr_{F_2}` (pass-3 ruling).

## 1. Frozen target and verdict up front

Frozen target of this pass: decide whether the third geometric source of
codimension-three classes on `M × M` — the **moduli structure** of `M`, i.e.
Chern classes of a universal family and its relative-Ext convolutions — can
populate the escape quotient `H^5(M,Z)/(b^*H^5(J,Z)+tors) = (Z/2)^10` with an
odd `(1,5)` residue. Pullbacks from `J × J` (pass-1 Theorem B) and
exceptional-divisor cycles (pass-2 Theorem 3) are already dead; pass-4 §6.3
recorded that the channel had *no candidate class at all*.

Verdict:

1. **`M` is a fine moduli space and the universal family exists untwisted**
   (Bayer–Beentjes–Feyzbakhsh–Hein–Martinelli–Rezaee–Schmidt give
   `M = M_X(v)`, `v = (3, −H, −H²/2, H³/6)`; Li–Lin–Pertusi–Zhao Corollary 3.9
   gives fineness; the needed `χ(w,v) = 1` witness exists: `χ(nα+mβ, α+β) =
   −n−2m`, so `w = −α` works). §2.
2. **Twist lemma.** The `(1,5)` residue of every Chern/convolution class of
   the universal family is independent of the twist ambiguity `ℰ ↦ ℰ ⊗ p_M^*N`.
   §3.
3. **Rigidity theorem.** The residue of every *deformation-canonical* class —
   one defined uniformly over the parameter space of all smooth cubic
   threefolds, which includes every polynomial in universal-family Chern
   classes and their Ext convolutions — lies in `{0, I_10}`. The inputs are
   Beauville's full symplectic monodromy for the universal cubic-threefold
   family and the absolute irreducibility of the standard `Sp_10(F_2)`-module.
   §4.
4. **Theorem E (evenness; the universal source is closed for odd degree).**
   `tr_{F_2}(0) = tr_{F_2}(I_10) = 0`, so every deformation-canonical class —
   in particular every universal-family class — has **even** `(1,5)`
   unordered-degree contribution, unconditionally on the remaining bit. §4.
5. **The reposed target sharpens twice over.** By Theorem C (pass 4) an odd
   `(1,5)` witness must be deck-asymmetric (genuinely marked-base); by Theorem
   E it must moreover be **non-deformation-canonical**: it has to use algebraic
   cycles special to the exotic `E^5` member (extra correspondences, `A_5`-orbit
   cycles, CM structure), not any construction that makes sense for a general
   cubic threefold. §5.
6. **The remaining bit `λ`** — whether the universal family populates the
   escape lattice at all (`φ_univ = λ·I`) — is still open and is exactly the
   `(1,5)` channel-population question. `λ = N(x,a) mod 2` for a single pair;
   §6 gives the computation plan through the degree-six
   `Bl_Δ(F(X)×F(X))`-model of Li–Lin–Pertusi–Zhao Example 5.7.

## 2. The moduli input, with loci

All loci verified against the sources this pass (arXiv:2011.12240v2,
arXiv:2406.09124v1); the detailed extraction with quoted formulas is the
committed working record of this pass (see §8).

- `M̄_X(v) ≅ Bl_0 Θ` for `v = (3, −H, −H²/2, H³/6)`: 2011.12240 Theorem 7.1.
  The Abel–Jacobi morphism is `Ψ(E) = c̃_2(E) − H²`, an isomorphism from the
  bundle locus onto `Θ \ {0}` (Lemma 7.4); the exceptional divisor is `X`
  itself, parametrizing the non-locally-free reflexive sheaves `K_P`
  (Corollary 5.2), with normal bundle `O_X(−H)` (Lemma 7.3).
- Generic objects: rank-three bundles `E_D = ker(O_X^{⊕3} ↠ O_Y(D))`, `D` a
  twisted-cubic class on a hyperplane section `Y ⊂ X` (Theorem 6.1, §5).
- `Ext^i(E,E) = (C, C^4, 0, 0)`: Corollary 6.9. Obstruction-free, `dim M = 4`.
- In the Kuznetsov lattice `v = [I_ℓ] + [S(I_ℓ)] = α + β` (2011.12240 Lemma
  8.4; 2406.09124 Notation 5.2), `χ(v,v) = −3`.
- Fineness: 2406.09124 Corollary 3.9. Its Brauer argument needs a class `w`
  with `χ(w,v) = 1`, asserted there by "elementary calculation"; for our `v`
  it is verified directly: `χ(nα+mβ, α+β) = −n − 2m`, so `w = −α` (object
  `E_ℓ[1]`) or `w = −γ` (object `F_ℓ[1]`) works. The universal family `ℰ` on
  `X × M` exists as an honest (untwisted) object.
- Neither paper states uniqueness of `ℰ`; the standard simple-object argument
  gives uniqueness up to `ℰ ⊗ p_M^*N`, `N ∈ Pic(M)`, and §3 makes every
  readout below independent of that ambiguity. Neither paper contains any
  integral cohomology statement about `M` or about Künneth components of
  `ch(ℰ)`; everything relevant there is rational. The integral content below
  is therefore new to this pass.

## 3. The readout matrix and the twist lemma

### 3.1 The matrix `N`

For `x ∈ H^3(X,Z)` and `a ∈ Λ` set

\[ N(x,a) \;=\; \int_{X×M} p_X^*x \cdot p_M^*(h\,b^*a) \cdot c_4(ℰ) \;\in\; \mathbf Z . \]

Total degree `3 + 3 + 8 = 14 = dim_R(X×M)`, and only the `(3,5)` Künneth
component of `c_4(ℰ)` contributes, since odd `M`-legs of an even-degree class
must couple to `H^3(X)` (`H^1(X) = H^5(X) = 0`). Writing that component as
`Σ_m x_m ⊗ β_m` and using the projection formula and the perfect pairing `P`:

\[ N(φ^{-1}(u_k), u_l) \;=\; \sum_m S_{km}\,\int_J Θ\,u_l\,b_*β_m , \]

so, `S` being unimodular and `P` killing `im L`,

> **`N ≡ 0 mod 2` iff every `(3,5)`-leg `β_m` of `c_4(ℰ)` lies in
> `b^*H^5(J,Z) + tors`.**

`c_4` is the only relevant Chern class for this direct readout on `X × M`:
lower `c_j` have no `(3,5)` component for degree reasons.

### 3.2 Twist lemma

*Statement.* The class of the `(3,5)`-leg of `c_4(ℰ)` in `Q_15` (hence
`N mod 2`) is unchanged under `ℰ ↦ ℰ ⊗ p_M^*N`. Likewise for the `(1,5)`-leg
residue of any polynomial in Chern classes of the relative Ext object
`E = RHom_{π_{12}}(π_{13}^*ℰ, π_{23}^*ℰ)[1]` on `M × M` under its induced
ambiguity `E ↦ pr_1^*N^∨ ⊗ pr_2^*N ⊗ E`.

*Proof.* `c_4(ℰ⊗p_M^*N) − c_4(ℰ)` is a `Z`-polynomial in `c_j(ℰ)` and
`n := c_1(N)` in which every term carries `n^k`, `k ≥ 1`. A `(3,5)`-term is
`(3,r)`-leg times a degree-`(5−r)` product of `n`-powers and `(0,even)`-legs;
by degree count `r ∈ {1,3}` and the even factors are degree-two classes only.
By the integral splitting `H^2(M,Z) = b^*H^2(J,Z) ⊕ Z[X]` every such
correction leg is a product of `b^*(odd)` with classes `b^*t` and `[X]`.
Then `b_*` of the correction is either `Θ∧(…) ∈ L∧^5Λ` (no `[X]` factor) or
zero: `b_*(b^*α·[X]^k) = α·b_*[X]^k`, and `b_*[X]^k = (b∘e_X)_*((-H)^{k-1})`
vanishes because `b∘e_X` is constant and the classes pushed live below
`H^6(X)`. Both kinds die in the readout. The `E`-statement is identical on
the second leg, and first-leg corrections cannot stay in degree one. ∎

This is the pass-2 Theorem 3 mechanism again: the readout is blind to the
exceptional divisor and to `L∧^5Λ`, and every normalization ambiguity lands
in exactly those two graves.

### 3.3 From `X × M` legs to actual cycles on `M × M`

Two canonical productions, both integral and both twist-robust by §3.2:

- **Convolution**: for integral correspondences `A ∈ CH^2(M × X)` (transpose
  of a `c_2(ℰ)`-combination, carrying the `(1,3)`-coupling) and
  `B = c_4(ℰ) ∈ CH^4(X × M)`, the composite `B ∘ A ∈ CH^{2+4-3}(M×M) =
  CH^3(M×M)` has `(1,5)` component the `X`-contraction of the two odd legs.
- **Ext convolution**: `c_3(E) ∈ CH^3(M × M)` and the products
  `c_1(E)c_2(E)`, `c_1(E)^3`. Since `ch` components have even total degree,
  `ch(E)_{(1,5)}` receives only `H^3(X)`-contractions of
  `ch(ℰ)^∨_{(3,1)} ⊗ ch(ℰ)_{(3,5)}`-type terms.

In either shape, the resulting `(1,5)` residue is an integer matrix built
from `N` and the integral `(3,1)`-coupling; §4 constrains them all at once,
so no case-by-case bookkeeping is needed for the theorems below.

## 4. Rigidity and Theorem E

### 4.1 Deformation-canonical classes

Let `U ⊂ P(H^0(P^4, O(3)))` be the parameter space of smooth cubic forms,
`𝒳 → U` the universal smooth cubic threefold. Call a cohomology class
`W_t ∈ H^{2c}((M×M)_t, Z)` (or on `(X×M)_t`) **deformation-canonical** if it
is defined for every `t ∈ U` by a construction commuting with base change on
germs, up to the twist ambiguity of §3.2. Examples: all `c_j(ℰ_t)`,
`c_j(E_t)`, their `Z`-polynomials and convolutions. The data needed to make
sense of this over `U`:

- The family `ℳ → U`: the relative Gieseker moduli space of semistable
  sheaves with the fibrewise class `v` exists projectively over `U`
  (Simpson/Langer, relative Gieseker theory over a Noetherian base; the
  polarization `O(1)` is canonical). Its fibres are the `M_t` by 2011.12240
  Theorem 7.1, whose hypotheses hold for every smooth cubic threefold.
- The canonical theta family: `Ψ_t(E) = c̃_2(E) − H²` is defined fibrewise
  with no choice — no theta characteristic, no marking, no `E^5`-gluing
  datum. So `h_t = b_t^*Θ_t` is a flat family of classes.
- The universal object: fibrewise fine by §2; over germs of `U` the universal
  families glue up to twist (the gluing obstruction is the Brauer/gerbe class
  of the relative moduli problem, which is fibrewise trivial by the
  `χ(w,v) = 1` argument and locally constant); §3.2 makes the residue
  readouts independent of all of it. Hence for every deformation-canonical
  `W` the matrix `N_t(x,a)` is a **locally constant** function of flat
  sections `x, a` of the local systems `R^3π_*Z` and `R^1_{𝒥}Z ≅ R^3π_*Z`.

### 4.2 Rigidity theorem

> **Theorem (rigidity).** Let `W` be deformation-canonical of codimension
> three on `M × M` (or the `c_4(ℰ)`-readout of §3.1 on `X × M`). Then its
> `(1,5)` residue satisfies `φ(W) = λ·I_10` for some `λ ∈ {0,1}`, uniformly
> over `U`.

*Proof.* By §4.1 the mod-two matrix `N` defines a monodromy-invariant
bilinear form on the fibre `H^3(X_t, F_2) × Λ_{2,t}`, where monodromy acts on
both factors through the same representation via the Clemens–Griffiths
isometry (`Λ = H^3(X,Z)(1)` as local systems). By Beauville's theorem the
monodromy image of `π_1(U, t)` on `H^3(X_t, Z)` is the full symplectic group
of the unimodular intersection form; its reduction is all of `Sp_10(F_2)`.
The standard ten-dimensional `Sp_10(F_2)`-module is absolutely irreducible,
so the space of invariant bilinear forms is one-dimensional, spanned by the
symplectic form `S mod 2`. Hence `N ≡ λ·S`, i.e. `φ(W) = λ·I` under the
identifications of §3.1. ∎

Two remarks. First, restricting the same argument to the Roulleau pencil
`U_0 ⊂ U` recovers exactly Theorem A + Lemma B of pass 4 for these classes,
with `S_3` replaced by the much larger full symplectic group; the two are
consistent, and neither implies the other's scope (Theorem C covers
*arbitrary* unmarked-base cycles; rigidity covers *canonical* constructions
but pins the residue to a bit). Second, the `A_5`-only version of this
argument is **insufficient**, and the certified structure is sharper than the
representation-theoretic guess an earlier draft made: on the actual corpus
matrices (an honest integral `A_5`, order 60, complex character `5 ⊕ 5`,
traces `10, 2, −2, 0` on orders `1, 2, 3, 5`), the commutant
`End_{F_2[A_5]}(Λ_2)` has `F_2`-dimension **4** — the local noncommutative
algebra `F_4⟨e⟩` with `e² = 0` and `e·λ = λ²·e`, residue field `F_4`,
square-zero radical of dimension two — and `Λ_2` has **zero** `A_5`-fixed
vectors, so it has composition series `4,1,4,1` with a unique minimal
submodule rather than splitting as `1 ⊕ 4`. Deck conjugation fixes the
four-element subalgebra `F_2[e']/(e'^2)`; adding the residual `C_3`
(conjugation by `w`, whose centralizer in the noncommutative commutant is
exactly `F_4`) cuts the joint `A_5`-and-`S_3` invariants to `{0, 1}` — the
last intersection is an inference from the two measured centralizers, flagged
as such in the certificate report, not a separately run computation. All
these candidate residues have vanishing `F_2`-trace, so pencil-only rigidity
already gives evenness, and (modulo that flagged inference plus an
`Aut`-equivariance argument at the symmetric member that this note does not
develop) even the `{0, I}` pinning; the full-monodromy proof needs neither.

### 4.3 Theorem E — evenness of the universal source

> **Theorem E.** Every deformation-canonical codimension-three class on
> `M × M` — in particular every integral polynomial in Chern classes of the
> universal family `ℰ` and of its relative Ext convolution `E`, and every
> convolution of such classes through `X` — has **even** `(1,5)` contribution
> to the unordered degree.

*Proof.* By rigidity `φ(W) ∈ {0, I_10}`; `tr_{F_2}(I_10) = 10 ≡ 0`. Under
the pass-3 ruling the `(1,5)` degree contribution is `tr_{F_2}(φ(W))`. ∎

This closes the third geometric source for the odd-degree crown. It is the
constructive realization, for this source, of what Theorem C predicted
abstractly — with a bigger group doing the work and the residue pinned to a
single bit instead of a 25-dimensional Hermitian space.

## 5. What an odd witness must now look like

Combining pass-1 Theorem B, pass-2 Theorems 1–3, Theorem C, and Theorem E:
an algebraic codimension-three class on `M × M` with odd `(1,5)` degree must

1. have second `(1,5)`-leg outside `b^*H^5(J,Z) + e_{X*}H^3(X,Z) + tors`;
2. be defined over the **marked** base and be deck-asymmetric
   (`tr_{F_4}(φ) ∉ F_2` forces non-`S_3`-invariance — Theorem C);
3. be **non-deformation-canonical**: no construction available uniformly for
   general cubic threefolds can produce it (Theorem E). It must consume
   algebraic structure special to the exotic locus — the `E^5` gluing
   correspondences, `A_5`-orbit cycles, or CM classes — and in a
   deck-asymmetric way.

This is a genuine narrowing: the search space is now "special cycles of the
exotic member, used asymmetrically in the two `F_4`-gluings", not "any cycle
on `M × M`".

## 6. The remaining bit `λ`, and the computation plan

`λ = 1` iff the `(3,5)`-legs of `c_4(ℰ)` escape `b^*H^5(J,Z)+tors` — iff the
escape lattice `(Z/2)^10` is populated by legs of algebraic classes at all
(the §6.3 channel-population question, now for the last standing source).
By rigidity, `λ = N(x,a) mod 2` for any single pair with `S_{kl}` odd,
computed on any single smooth cubic threefold. Plan, in order:

1. **Change model.** The Serre-functor isomorphism
   `M_{σ}(β+γ) ≅ M_{σ}(α+β) = M` (2011.12240 (10)–(12)) replaces `ℰ` by the
   rank-zero family `𝒢` with `ch(𝒢_m) = (0, H, −H²/2, −H³/6)`: sheaves
   supported on hyperplane sections. The mutation kernels act on the
   `H^3(X)`-legs by `±1` (their `(3,3)` Künneth parts are `±` the diagonal's),
   so the two residues agree mod 2. To be re-derived carefully, including the
   `b`-compatibility via the additivity `Φ_v + Φ_w = Φ_{v+w}` (2406.09124
   §5.2).
2. **Explicit family.** On the bundle locus, `𝒢 = ι_{𝒮*}ℒ` where
   `𝒮 ⊂ X × M°` is the universal-hyperplane-section divisor (class
   `H + σ`, `σ` the support-map pullback of `O_{(P^4)^∨}(1)`) and
   `ℒ ∈ Pic(𝒮)` restricts fibrewise to `O_{S_m}(D_m)`. Modifications over the
   exceptional divisor cannot change the readout (Gysin kernel =
   `(1×e_X)_*`-classes, dead by pass-2 Theorem 3), so the open-locus family
   plus any closure suffices.
3. **Where the odd legs live.** Fibres `S_m` are cubic surfaces with
   `H^1 = 0`, so `c_1(ℒ)` has no odd-leg Leray graded piece; the odd
   `M`-legs of `ch(𝒢) = ι_*(e^{c_1(ℒ)}·td^{-1}(O(𝒮))|_𝒮)` arise from `ι_*` of
   powers of `c_1(ℒ)` through the nontrivial monodromy of the 27-lines /
   Picard local system of `𝒮 → M°`. Alternatively, compute upstairs on the
   degree-six model `q : Bl_Δ(F×F) → M_{β+γ}` (2406.09124 Example 5.7,
   objects `ι_*O_{S_{ℓ,ℓ'}}(ℓ'−ℓ)`), where everything is classical
   Clemens–Griffiths/Fano-surface geometry — noting that pulled-back test
   classes die mod 2 (degree six is even), so the detection must pair against
   non-pullback classes `T' ∈ H^3(Bl_Δ(F×F), Z)` and push with `q_*`; this
   works iff `q_* mod 2 ≠ 0` on the relevant part of `H^3`, which is itself a
   computable Fano-surface statement.
4. **Certificate.** Once the leg matrix is expressed in the exotic basis,
   the mod-two evaluation and the `N ≡ λS` consistency check are a bounded
   Sage computation on the existing lattice infrastructure.

## 7. Hostile-audit ledger for this pass

- **The rigidity proof does not use fineness over `U` globally** — only
  germ-local gluing up to twist, plus the twist lemma. The Brauer-class
  subtlety is confined and disarmed.
- **`Θ` is canonical over `U`**: `Ψ(E) = c̃_2(E) − H²` needs no marking. The
  marked/unmarked distinction of passes 4–5 concerns the `E^5`-gluing, which
  never enters the definition of `N`.
- **The `A_5`-rigidity trap**: recorded in §4.2; an earlier draft of this
  pass relied on `End_{A_5}(Λ_2) = F_4`, which is false in characteristic
  two. The commutant computation on the actual corpus matrices is delegated
  to the auxiliary certificate (§8) as a cross-check.
- **Literature gates, both classical**: (i) Beauville, full symplectic
  monodromy for the universal family of smooth cubic threefolds (odd-dim
  hypersurface case); (ii) Simpson/Langer, relative Gieseker moduli over a
  base. Exact loci to be recorded in the source ledger before this theorem is
  promoted anywhere; until then Theorem E is research-note-grade, not
  manuscript-grade.
- The evenness conclusion for universal-family classes over the *pencil*
  already follows from Theorem C alone (they are unmarked-base classes), so
  Theorem E's headline is robust even if a families-technical gap surfaced in
  §4.1; only the `{0, I}` pinning would weaken.

## 8. Records

- Source-extraction working record (loci, quoted formulas, read depths, gaps)
  for arXiv:2011.12240v2 and arXiv:2406.09124v1:
  `notes/2026-08-11-c908-universal-family-source-extraction.md`. Both PDFs
  were absent from the shared literature cache at fetch time; inserting them
  per the cache README is still owed.
- Auxiliary lattice certificate, output and JSON committed:
  `notes/2026-08-11-c908-a5-commutant-lefschetz-smith.{out,json}`. Results:
  (a) `dim_{F_2} End_{F_2[A_5]}(Λ_2) = 4`, local `F_4⟨e⟩/(e², eλ−λ²e)`,
  zero `A_5`-fixed vectors; (b) deck-fixed part of the commutant has
  `F_2`-dimension 2 with `F_4`-part `{0,1}`; (c) `L_3 : ∧^3Λ → ∧^5Λ` has
  Smith form `1^110 2^10`, confirming the adjointness prediction; (d) the
  `L_5` cross-check reproduces `1^110 2^10`, and the `L_1` control is fully
  saturated, matching pass-2. Generator and narrative report:
  `notes/2026-08-11-c908-a5-commutant-lefschetz-smith.sage` and
  `notes/2026-08-11-c908-a5-commutant-certificate-report.md`. The `A_5` used
  is genuine (order 60, complex character `5 ⊕ 5`, integral and symplectic on
  `Λ`, built from the corpus's `mobius_generators()`); the outer `x ↦ 2x` is
  not integral on `Λ`. **Replay caveat, still owed**: the committed
  `.out`/`.json` were produced by the script revision immediately before a
  final edit that appended the (unrun) joint-invariant lines, so the script
  hash does not match its output; one reconciling re-run is required before
  any claim leaning on (a)/(b) is promoted beyond this note. Nothing in
  Theorems D/E depends on (a)/(b); they are cross-checks. (c) has an
  independent human proof by adjointness to the certified `L_5`.

## 9. Mystery ledger (EJ + TT closeout, interim)

- **Settled:** the third source (moduli/universal-family) cannot give odd
  `(1,5)` degree — Theorem E, unconditional on `λ`.
- **Settled:** the residue of every deformation-canonical class is `0` or
  `I`; the 25-dimensional Hermitian freedom of Theorem C collapses to one bit
  for canonical constructions.
- **Settled negatively (method):** `A_5`-equivariance alone proves nothing
  here — no 5-dimensional 2-modular `A_5`-irreducible exists; full monodromy
  is the right group.
- **Open, the single bit:** `λ` — does the universal family populate the
  escape lattice at all? Plan in §6; this is the natural next pass.
- **Open, inherited:** the deck-asymmetric special-cycle construction (§5),
  now with a much sharper profile.
- **EJ upgrade logged, not executed:** the same full-monodromy rigidity
  applies to the `(2,4)` channel: `Sp_10(F_2)`-invariants of the relevant
  44-dimensional dyadic quotient would pin universal-source `(2,4)` residues
  the same way, and might close for canonical sources the channel that
  Theorem C's `S_3` cannot (its fixed space there is 396-dimensional). A
  bounded invariant computation; queued as a follow-on target.
