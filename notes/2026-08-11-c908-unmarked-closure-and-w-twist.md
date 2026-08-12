# C908: the unmarked-base (1,5) closure theorem, and w-twist scoping

Date: 2026-08-11

Status: **primary item proved — the closure theorem binds.** Secondary item
scoped, with a decisive no-go for the natural shape of the `w`-twist. C908
mathematics only; no manuscript, PDF, mirror, Lean, or C904-surface edit.

Notation as in the pass-2 and pass-3 notes: `J` the intermediate Jacobian
(dimension five), `Θ ⊂ J` the symmetric theta divisor with its unique singular
point at the origin, `b : M = Bl_0 Θ → J`, `Λ = H^1(J,Z)` of rank ten,
`Λ_2 = Λ ⊗ F_2`, `L = Θ ∧ (−)`, `Q_15 = coker(L : ∧^5Λ → ∧^7Λ) = (Z/2)^10`,
`P(a,[B]) = ∫_J Θ·a·B mod 2` the perfect readout pairing, and `φ(W)` the `(1,5)`
residue of a codimension-three class `W`, an element of
`Λ_2 ⊗ Q_15 ≅ End_{F_2}(Λ_2)`. Pass 3 ruled that the unordered degree in this
channel is `tr_{F_2}(φ)`.

## 1. Verdict up front

1. **The spread question — the one place the theorem could die — settles
   positively.** The relative symmetric theta divisor, and hence the relative
   theta resolution `ℳ` and the family `ℳ ×_{U_0} ℳ`, are defined over the
   **unmarked** Roulleau base. The marking is not needed for `Θ` or `M`; what it
   supplies is the `E^5`-gluing identification, i.e. the `F_4` coefficient
   structure. See §2.
2. **Theorem C (§5) holds:** no algebraic codimension-three cycle on
   `ℳ ×_{U_0} ℳ` defined over the unmarked function field contributes odd `(1,5)`
   degree.
3. **It is a channel theorem, not an index theorem.** The `(2,4)` and `(0,6)`
   channels remain open under full `S_3`. Stated precisely in §5.2.
4. **`w`-twist: the natural shape is dead.** No algebraic self-correspondence can
   act on `H^1` as the `F_4`-scalar `w`, because every Hodge endomorphism of
   `H^1(J)` is coefficient-linear and so has even integral trace — certified on
   the actual integral order. See §6.

## 2. Does the family spread over the unmarked base?

### 2.1 The two bases, and what the marking marks

Let `B_0 ≅ P^1` be Roulleau's pencil of `A_5`-invariant cubic threefolds. The
marked base is the degree-two cover `B → B_0` distinguishing the two exotic
`F_4` gluings of the six-axis source: per
`notes/2026-08-10-c904-exotic-f4-gluing.md`, the three classical gluings preserve
`S_6` while each exotic `F_4` gluing has stabilizer exactly `A_5`, so strong
Torelli forces the family onto the exotic pair, which the deck involution
exchanges. Correspondingly (fifth pass,
`notes/2026-08-10-c904-theta-rigidification-on-marked-base.md`) the mod-two
monodromy is the full `S_3` over `B_0` and is cut to `C_3` over `B`, with
`[S_3 : C_3] = 2` matching the degree of the cover.

So the marking is a choice of `E^5`-gluing identification — equivalently of the
`F_4 = End_{C_3}(W)` coefficient structure on `Λ_2`. **It is a priori a separate
question whether the theta rigidification also needs it.** That is the question
the theorem lives or dies on, and it is Lemma 2.2.

### 2.2 Lemma (the symmetric theta divisor descends to the unmarked base)

*Statement.* After shrinking `B_0` to a dense open `U_0` over which the cubic
family is smooth and the relative principally polarized intermediate Jacobian
`𝒥 → U_0` exists, there is a relative symmetric theta divisor `𝒯 ⊂ 𝒥` defined
over `U_0`, and it is unique.

*Proof.* Symmetric line bundles in the given polarization class form a torsor
under `𝒥[2]`, compatibly with the monodromy action of `π_1(U_0)`. The fifth pass
proves that the residual order-three generator `g` satisfies `g^2+g+1 = 0`
modulo two on the principal homology lattice, hence has **no fixed vector** on
`J[2]`; so `(J[2])^{C_3} = 0`. Since `|C_3| = 3` is odd and `J[2]` is a
2-group, `H^i(C_3, J[2]) = 0` for `i > 0` as well. A torsor under a module with
vanishing `H^0` and `H^1` has exactly one fixed point: call it `θ_0`, the unique
`C_3`-invariant symmetric theta divisor. This is the fifth pass's result.

Now the deck involution `s` **normalizes** `C_3` — the corpus's exotic-deck
relations are `g^3 = s^2 = 1`, `sgs = g^{-1}` — and acts on the same torsor.
Hence `s(θ_0)` is again `C_3`-invariant: for any `h ∈ C_3`,
`h·s(θ_0) = s·(s^{-1}hs)(θ_0) = s(θ_0)` because `s^{-1}hs ∈ C_3` fixes `θ_0`. By
uniqueness `s(θ_0) = θ_0`. So `θ_0` is fixed by the whole `S_3`, hence descends
to `U_0`. Uniqueness over `U_0` follows from uniqueness already over the marked
base. ∎

This **extends** the fifth pass rather than contradicting it: that pass showed the
marked base suffices; Lemma 2.2 shows the marking was not needed for this
particular datum. Flagged for the C904 owner in §7.

### 2.3 Lemma (the resolution spreads)

The theta divisor of the intermediate Jacobian of a smooth cubic threefold has a
**unique** singular point, the origin, an ordinary triple point whose
projectivized tangent cone is the cubic itself (Beauville; recorded and used
throughout the C904 corpus, e.g.
`notes/2026-08-11-c904-theta-resolution-topology-integral-projector-audit.md`
§1 with `E|_M = X` and `N_{X/M} = O_X(-H)`). Hence the singular locus of `𝒯` is
exactly the zero section of `𝒥 → U_0`, which is a section; blowing it up gives

\[ \mathcal M \;=\; \mathrm{Bl}_{\,0\text{-section}}\,\mathcal T \;\longrightarrow\; U_0, \]

smooth and proper over `U_0` with fibres `M_t = Bl_0 Θ_t`. **The family version of
`M × M` is `ℳ ×_{U_0} ℳ`**, smooth and proper over `U_0` of relative dimension
eight. All the readout data — `b : ℳ → 𝒥`, `h = b^*Θ`, the inversion lift `ι`,
`b_*` on `H^5`, and the pairing `P` — are defined relatively over `U_0`.

**So the spread hypothesis binds.** This was the live risk and it is now closed.

## 3. Theorem A (monodromy invariance of the residue)

*Hypotheses.* `U_0` as in §2, shrunk further as needed; `K_0 = C(U_0)`; the
mod-two monodromy image `Im(π_1(U_0,t) → Aut(H^1(J_t,F_2)))` contains the `S_3`
generated by the residual `C_3` and the exotic deck.

*Statement.* Let `W` be a codimension-three cycle on `(ℳ ×_{U_0} ℳ)_{K_0}`.
Then its `(1,5)` residue `φ(W) ∈ Λ_2 ⊗ Q_15` is `S_3`-invariant, i.e. lies in
`End_{S_3}(Λ_2)`.

*Proof.* Take the closure of `W` and shrink `U_0` so that it spreads to a cycle
`𝒲` on `ℳ ×_{U_0} ℳ` restricting to `W` on the generic fibre. By the valid
integral direction of the invariant-cycle argument — recorded at
`notes/2026-08-11-c904-relative-invariant-cycle-franchetta-audit.md` §1, and using
only functoriality of the cycle class map and topological local triviality, with
**no** appeal to Deligne's (rational) global invariant-cycle theorem — the class
`cl(𝒲|_t) ∈ H^6((ℳ×_{U_0}ℳ)_t, Z)` is the value of a global section of
`R^6 f_* Z` and is therefore fixed by `π_1(U_0,t)`.

Four points of care.

1. *Shrinking does not shrink the monodromy.* For `U' ⊆ U_0` dense open in a
   smooth curve, `π_1(U') → π_1(U_0)` is surjective, so the monodromy image is
   unchanged by the shrinking used to spread `W`.
2. *A larger image only helps.* The hypothesis is that the image **contains**
   `S_3`; if it is larger the invariant space is smaller and the conclusion is
   stronger. So `S_3` is the worst case.
3. *Generic point versus special fibre.* The unordered degree is defined by
   `s_*Z = d[J]` and is locally constant over `U_0`, so it agrees on the generic
   fibre and on every `t` in the dense open. Invariance is a statement about the
   flat section, hence holds at each such `t`. Vertical corrections introduced by
   spreading restrict to zero on the generic fibre, and homologically trivial
   corrections have zero value under the top-degree contraction that records the
   degree — again §1 of the Franchetta audit.
4. *Singular relative symmetric square.* `Sym^2_{U_0} ℳ` is singular along its
   diagonal, so all of this is done on the smooth ordered cover
   `ℳ ×_{U_0} ℳ`, which is the audit's own device; the Kunneth bigrading, `b_*`,
   and the pairing `P` are relative and hence `π_1`-equivariant, so the residue
   construction commutes with monodromy. ∎

*Torsion caveat, harmless.* `H^*(M,Z)` may have torsion, so the integral Kunneth
bigrading is a statement modulo torsion. This cannot affect the conclusion: the
degree is `∫_J Θ·α'·b_*β ∈ Z`, `b_*` kills the torsion of `H^5(M,Z)` (pass-2
Theorem 2), and `∧^7Λ` is torsion-free.

## 4. Lemma B (the parity vanishing, robustly)

*Statement.* If `φ ∈ End_{C_3}(Λ_2) = M_5(F_4)` has `F_4`-coefficient trace fixed
by Frobenius — in particular if `φ` is `S_3`-equivariant — then
`tr_{F_2}(φ) = 0`.

*Proof.* `tr_{F_2}(φ) = Tr_{F_4/F_2}(tr_{F_4}(φ))` and `Tr_{F_4/F_2}(x) = x+x^2`
kills `F_2` and sends `w, w^2` to `1`. If `s` is the deck acting `F_4`-semilinearly
then `φ = sφs^{-1}` forces `tr_{F_4}(φ) = \overline{tr_{F_4}(φ)}`, i.e.
`tr_{F_4}(φ) ∈ F_2`. **The conclusion is independent of whether the deck is plain
semilinear or semilinear composed with transpose**: in the second case
`End_{S_3}(Λ_2)` is the Frobenius-Hermitian matrices `\overline A = A^t`, whose
trace satisfies `\overline{tr(A)} = tr(A^t) = tr(A)`, again in `F_2`. ∎

*Certified.* All **61** canonical samples with Frobenius-fixed coefficient trace —
the 25 elementary `F_2`-rational matrices, the identity, and the Hermitian
diagonal and off-diagonal families — have `F_2`-linear trace `0`, the only value
observed. The control is sharp: `w·I_5` and `diag(w,0,0,0,0)` both have
coefficient trace `w ∉ F_2` and `F_2`-linear trace `1`. So the test detects
oddness when it is present.

## 5. Theorem C — the unmarked-base (1,5) closure

> **Theorem C.** Assume (H1) `U_0 ⊆ B_0` is a dense open of the unmarked Roulleau
> pencil over which the cubic family is smooth, the relative principally polarized
> intermediate Jacobian `𝒥 → U_0` exists as an abelian scheme, and the mod-two
> monodromy image contains the `S_3` generated by the residual `C_3` and the
> exotic deck; (H2) `𝒯 ⊂ 𝒥` is the relative symmetric theta divisor of Lemma 2.2
> and `ℳ = Bl_{0\text{-section}} 𝒯` the relative resolution of Lemma 2.3; (H3)
> `W` is an algebraic codimension-three cycle on `ℳ ×_{U_0} ℳ` defined over
> `K_0 = C(U_0)`. Then the `(1,5)` contribution to the unordered degree of `W` is
> **even**.

*Proof.* By Theorem A, `φ(W) ∈ End_{S_3}(Λ_2)`. By Lemma B, `tr_{F_2}(φ(W)) = 0`.
By the pass-3 ruling the `(1,5)` contribution to the degree is `tr_{F_2}(φ(W))`
modulo two. ∎

### 5.1 Corollary (which channels an unmarked-base odd degree must use)

An odd-degree multisection of `Sym^2_{U_0} ℳ → 𝒥` defined over `K_0` must draw
its odd degree from the `(0,6)` axis channel or the `(2,4)` channel. The `(3,3)`
channel is even for the independent reason `Θ^2 = 2Θ^{[2]}`.

### 5.2 Corollary in index language — stated with exact care

**This is a channel theorem, not an index theorem. It does not show
`ind(Y) = 2`.** Two channels are untouched, and I will not overstate:

- **`(2,4)` remains open under full `S_3`.** The corpus's own equation (3.2) in
  `notes/2026-08-11-c904-exotic-deck-kunneth-descent.md` exhibits a **nonzero**
  contraction on the 396-dimensional `S_3`-fixed `p24` space, and in that channel
  the corpus's reading is already the direct contraction — "the direct
  contraction is already the quotient degree" (red-team note, `p24` table row) —
  which is exactly what the pass-3 ruling endorses. So odd `(2,4)` contributions
  over the unmarked base are **not** excluded by anything here.
- **`(0,6)` remains open on this locus.** An odd theta-supported curve would give
  degree five; Engel--de Gaay Fortman--Schreieder close that only at the *very
  general* cubic, and explicitly not on the one-dimensional `A_5` locus
  (`notes/2026-08-11-c904-efs-shen-symmetric-theta-index-audit.md` §3).

So Theorem C removes one of three live channels, for unmarked-base classes only.
It says nothing about algebraicity, Hodge-ness, Chow descent, or the value of
`ind(Y)`.

### 5.3 The splitting-datum reading

The marking is the degree-two datum `S_3/C_3`. Combining Theorem C with the
pass-3 certification:

- **Before the marking** (classes over `U_0`): no odd `(1,5)` residue exists.
- **After the marking** (classes over the marked base `B`): only `C_3`-invariance
  is forced, so `φ ∈ End_{C_3}(Λ_2) = M_5(F_4)`, and odd residues exist — exactly
  those with `tr_{F_4}(φ) ∉ F_2`.

So **the marked double cover is the minimal datum licensing an odd `(1,5)`
residue**, and the residues it licenses are precisely those whose coefficient
trace leaves `F_2`. This is consistent with the corpus's
restriction–corestriction constraint that a parity-changing extension must have
even degree, two being the first.

**What this minimality is not.** It is minimality for the `(1,5)` *cohomological
residue*, not for `ind(Y)`. It does not exhibit the marked cover as the minimal
splitting field of the index: the other two channels are untouched, and a
cohomological residue is not a cycle. The corpus's own standard applies — proving
a cover minimal for the index needs both an odd cycle after it and the
nonexistence of every odd cycle before it, and neither is supplied here.

## 6. Secondary item: `w`-twist feasibility scoping

Under the pass-3 ruling, odd marked-base residues are exactly the `F_4`-linear
`φ` with `tr_{F_4}(φ) ∉ F_2`. The simplest shape is a twist by
`ρ = w` itself, since `F_4 = F_2[ρ]`. This section scopes that route only; no
construction is attempted and no algebraicity is claimed.

### 6.1 Is the residual `C_3` realized by an algebraic correspondence?

**General no-go.** By pass-2 Theorem 1, `H^1(M,Z) = b^*Λ`, so the action of any
algebraic self-correspondence of `M` on `H^1` is an endomorphism of `Λ` respecting
the Hodge structure, i.e. an element of the integral Hodge endomorphism ring
`End(J)`. For the generic non-CM `E^5` structure `End(J) ⊗ Q` is the
five-dimensional coefficient endomorphism algebra acting on
`Λ ⊗ Q ≅ (coefficient space) ⊗ (rank two)`, so `tr_Z = 2·tr_coeff` is **even**.
Hence `tr_{F_2}` of the action is `0`, whereas the `F_4`-scalar `w·I_5` has
`tr_{F_2} = 1`. **So no algebraic self-correspondence of `M` (equivalently of
`J`) acts on `H^1(-,F_2)` as `ρ`.**

*Certified on the actual order*, not merely inferred from the description: all
**25** generators of the integral endomorphism lattice have even trace, all
**625** pairwise products have even trace, and the identity has trace `10`.
Independently, the `F_2`-dimension of the image of `End(J)` in `End(Λ_2)` is
**25**, whereas `M_5(F_4)` needs `50` — so the `F_4`-scalars are outside the image
on dimension grounds too.

**Inventory of the named candidate sources, with loci.**

| source                                                                                                                                                    | verdict | reason                                                                                                                                         |
| --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `End(J)`, the exotic rank-25 order                                                                                                                        | no      | even trace, certified above                                                                                                                    |
| `A_5`-automorphisms of special fibres                                                                                                                     | no      | they act through `End(J)`, hence even trace                                                                                                    |
| exotic deck as a correspondence                                                                                                                           | no      | order two, and semilinear: it *conjugates* `tr_{F_4}`, never shifts it                                                                         |
| Hecke packet edges (`notes/2026-08-10-c904-quartic-cubic-hecke-correspondence.md`: primitive multiplier-four isogenies, Smith kernel `(Z/2)^2 ⊕ (Z/4)^4`) | no      | any self-composite is an endomorphism, hence even trace                                                                                        |
| Fano-curve Rosati norms `N_C`                                                                                                                             | no      | `N_{a^*Θ} = 4I`, `N_{C_s} = 2I`, and all lie in the mod-two maximal ideal `m_F` (`notes/2026-08-11-c904-exceptional-quintic-residue-ideal.md`) |

**A hazard to flag, not a candidate.** The operator called `omega` in
`notes/2026-08-11-c904-nonaxis-elliptic-support-audit.md` §2, with
`omega^2+omega+I = 0` and `omega ∈ End_{A_5}(H_2) = F_4`, lives on the **integral
one-cycle homology lattice** `H_2`, not on `Λ = H^1`. These are different modules
and the `F_4`-structures are not identified by anything in the corpus. Do not read
that `omega` as a realization of `ρ`.

### 6.2 Composition bookkeeping, if some `Γ_ρ` did exist

For the record, since the structure of the idea is sound even though its input is
unavailable.

- A degree-preserving correspondence on the fourfold `M` has codimension four:
  for `Γ ∈ CH^c(M×M)`, `Γ_* : H^k(M) → H^{k+2c-8}(M)`, so `c = 4`. Thus
  `Γ_ρ ∈ CH^4(M×M)`, the diagonal's codimension.
- Composition of correspondences: `CH^4(M×M) ∘ CH^3(M×M) ⊆ CH^{4+3-4}(M×M) =
  CH^3(M×M)`. **So the composite stays in codimension three**, as required.
- Residue functoriality: if `φ(W) = Σ_i α_i' ⊗ [B_i]`, then acting on the first
  leg by `Γ_ρ` replaces `α_i'` by `ρ^*α_i'`, giving residue `φ ∘ ρ^*`; the trace
  becomes `tr(ρφ)`. For the old, now-known-even target `φ = I` this is
  `tr_{F_2}(ρ) = 1` — **odd**. So the twist would indeed convert the identity
  residue into an odd one.
- **Where `Γ_ρ` and `W` may not come from.** Pass-1 Theorem B: not both pullbacks
  along `b × b` from `J × J` — a pullback has both legs carrying `Θ` and hence
  even residue; the graph-sandwich shape `{}^tΓ_b ∘ Z ∘ Γ_b` is of that type (the
  precise identification with a refined pullback is flagged unverified in the
  pass-2 note). Pass-2 Theorem 3: neither may carry its odd `(1,5)` leg on the
  exceptional divisor, since `b ∘ e_X` is constant so `b_* e_{X*} = 0`. Pass-4
  §6.1: `Γ_ρ` cannot act as `ρ` on `H^1` at all.

**Conclusion of the scoping.** The leg-twist shape is closed. Any odd `(1,5)`
residue must arise from the **coupling of the two legs** — the choice of the
`B_i ∈ ∧^7Λ` modulo `L∧^5Λ` — and not from twisting one leg by an endomorphism.

### 6.3 First concrete missing lemma for a construction pass

> Exhibit **one** integral algebraic codimension-three class on `M × M`, defined
> over the marked base, whose second `(1,5)` Kunneth leg `β` has
> `b_*β ∉ L∧^5Λ + torsion`, and compute its residue `φ`.

This is the reposed target of the pass-2 note §8, and it is now the whole game:
the `(1,5)` channel has **no candidate class at all** on the marked base, and the
two obvious geometric sources (pullbacks from `J × J`; cycles supported on or
transformed through the exceptional divisor `X`) are both excluded. If such a
class is found, the follow-on is to check whether its `φ` — which must be
`C_3`-equivariant, hence `F_4`-linear — has `tr_{F_4}(φ) ∉ F_2`; the minimal
qualifying shape is `F_4`-rank one, e.g. `diag(w,0,0,0,0)`, of `F_2`-rank two.
Note that such a `φ` is necessarily **not** `S_3`-invariant, so any construction
realizing it must be genuinely marked-base and deck-asymmetric — which is exactly
what Theorem C predicts.

## 7. Flags for the C904 owner

New in this pass, in addition to the eight loci already flagged in the pass-3
note §7:

1. `notes/2026-08-10-c904-theta-rigidification-on-marked-base.md` — its result
   **extends**: the unique invariant symmetric theta divisor is fixed by the full
   `S_3`, not only by `C_3`, because the deck normalizes `C_3` and the fixed point
   is unique. So the theta rigidification descends to the **unmarked** base and the
   marking is not required for it. This is a strengthening, not a contradiction,
   but the note's title and framing suggest otherwise and downstream statements
   may have inherited the impression.
2. `notes/2026-08-11-c904-nonaxis-elliptic-support-audit.md` §2 — the operator
   `omega ∈ End_{A_5}(H_2) = F_4` is on the one-cycle homology lattice, not on
   `H^1`. Worth an explicit disambiguation, since the `F_4` coincidence invites
   exactly the wrong identification (see §6.1).

## 8. Bundle, replay, checksums

Working directory: the repository root `/home/tavis/src/othello`.

```sh
nix shell nixpkgs#sage -c sage \
  notes/2026-08-11-c908-unmarked-closure-and-w-twist.sage \
  --json notes/2026-08-11-c908-unmarked-closure-and-w-twist.json \
  --out notes/2026-08-11-c908-unmarked-closure-and-w-twist.out
```

The Sage run leaves a preparsed `.sage.py` translation which must be deleted; the
committed bundle is debris-free.

| artifact                                            |  bytes | SHA-256                                                          |
| --------------------------------------------------- | -----: | ---------------------------------------------------------------- |
| `2026-08-11-c908-unmarked-closure-and-w-twist.sage` | 11,947 | 65f747399e717315e7a11dea371cc8a413c824aace531694948436f20bee7a3c |
| `2026-08-11-c908-unmarked-closure-and-w-twist.json` |  2,491 | 138f47b9cf1e9ea960e94d940911c28fdc10c1737cd3a3e9fe740a0c9974e543 |
| `2026-08-11-c908-unmarked-closure-and-w-twist.out`  |    435 | f36fba091286408ebcd0838ee80a6e8e24d3d162c390077125b891d8b6bc91b7 |

Load-bearing input:
`notes/2026-08-10-c904-minimal-class-divisor-lattice.sage`, SHA-256
`d77752dcf242cdd3e8ecf15d34785eba583aa4c4c7770b79decd2f43e260f734`.

**Certified:** Lemma B on all 61 Frobenius-fixed canonical samples with a sharp
control; even trace of all 25 generators of the integral endomorphism order and
of all 625 pairwise products; the identity trace `10`; and the `F_2`-dimension
`25` of the mod-two image of `End(J)` in `End(Λ_2)`. **Not certified — human
proofs in this note:** Lemmas 2.2 and 2.3, Theorem A, Theorem C, and the
composition bookkeeping of §6.2; also inherited without recomputation: pass-2
Theorems 1--3 and the pass-3 ruling. **Cross-checks:** Lemma B is proved
abstractly and then verified on samples; the even-trace no-go has both a
one-line conceptual proof (`tr_Z = 2 tr_coeff`) and a computation on the actual
integral order; the sharp control shows the parity test is not vacuous.

## 9. Mystery ledger (EJ + TT closeout)

- **Settled, and it was the live risk:** the relative symmetric theta divisor,
  the theta resolution and `ℳ ×_{U_0} ℳ` all spread over the **unmarked** base.
  The deck normalizes `C_3`, and a unique `C_3`-fixed point of a torsor is
  automatically deck-fixed. The theorem does not die here.
- **Settled:** Theorem C. No unmarked-base algebraic codimension-three class
  contributes odd `(1,5)` degree, robustly in the deck convention.
- **Settled, and deliberately limited:** this is a channel theorem. `(2,4)` stays
  open under `S_3` by the corpus's own equation (3.2), and `(0,6)` stays open on
  the `A_5` locus. No index statement is promoted.
- **Settled:** the marked double cover is the minimal datum licensing an odd
  `(1,5)` residue — for the residue, not for the index.
- **Settled negatively, and this is the pass's surprise:** the `w`-twist cannot be
  realized by any algebraic self-correspondence, because every Hodge endomorphism
  of `H^1(J)` is coefficient-linear and hence has even trace. The very structure
  that creates the odd residues on the marked base — the `F_4` coefficient
  structure — is invisible to `End(J) ⊗ F_2`, which has `F_2`-dimension 25 against
  the 50 that `M_5(F_4)` needs. The odd trace must come from the coupling of the
  two legs, never from a one-leg twist.
- **Open, the frozen target for a construction pass:** exhibit one algebraic
  codimension-three class on `M × M` with second `(1,5)` leg outside
  `b^*H^5(J,Z) + torsion`. Both obvious sources are excluded, and there is
  currently no candidate.
- **Open:** whether the `(2,4)` channel admits an analogous unmarked-base closure.
  Its `S_3`-invariant contraction is nonzero, so if a closure exists there it
  cannot be by this mechanism — a different argument would be needed.
- **No manufactured mystery:** the torsion caveat in Theorem A is real but
  provably harmless, and I have not dressed it up.
