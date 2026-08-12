# Sub-A2: monodromy of cubic threefolds, relative Gieseker moduli, LLPZ Example 5.7

## 0. Cache status — correction to my previous report

**Both arXiv papers were already in the shared cache all along.** My earlier report said
`not cached`; that was **my error**, caused by querying the bare arXiv id instead of the
normalized key. The cache uses the `arXiv:` prefix (as the README's contract states:
"Key = normalized DOI ... or arXiv id (`arXiv:1104.0324`)"). Querying `arXiv:2011.12240` returns
the entry immediately.

| key | sha256 | bytes | pages | status | fetched | url in manifest |
|---|---|---|---|---|---|---|
| `arXiv:2011.12240` | `ce005e812a7223208938c266281b88c2dbcfc3e125079eb98fcba76b8d365c8a` | 989022 | 26 | ok | 2026-08-10 | `https://arxiv.org/pdf/2011.12240v2` |
| `arXiv:2406.09124` | `c1aa5d752c9c081827d0aa2cec4ab6408e3868449ef3f7e7ba11a7f936bbdb25` | 730828 | 68 | ok | 2026-08-11 | `https://arxiv.org/pdf/2406.09124` |

The bytes I downloaded independently hash **identically** to the cached blobs, so the two fetches
agree and the previous extraction stands on the same bytes. `litcache.py add` correctly refused
both with `REFUSED: key already cached`; **no insertion was needed and none was forced.**

Practical note for future sessions: `litcache.py get 2011.12240` silently reports `not cached` for
a key that is present as `arXiv:2011.12240`. Always query with the `arXiv:` prefix, or run
`list | rg <id>` before concluding a paper is absent.

---

## 1. Beauville, monodromy of universal families of hypersurfaces

### 1a. Source identity

Found on the author's own university page — this is Beauville's posted copy of the published
article, not a third-party retyping.

- **Arnaud Beauville, "Le groupe de monodromie des familles universelles d'hypersurfaces et
  d'intersections complètes"**, in *Complex Analysis and Algebraic Geometry* (Göttingen 1985),
  Lecture Notes in Mathematics **1194**, Springer-Verlag, Berlin, 1986, **pp. 8–18**.
- URL fetched 2026-08-11: `https://math.univ-cotedazur.fr/~beauvill/pubs/mono.pdf`
- Cached as **`BEAUVILLE:LNM1194-monodromie`**, sha256
  **`4f6eb4e0bbe04ce8787754aba897e1552f47f47853fa34f421f8b30ac58ed045`**, 11 PDF pages.
  The PDF is a scan of the printed article; the embedded printed
  page-number footers run 10, 11, 12, 13, 14, ..., 18, confirming the pagination 8–18 (the volume's
  own numbering), with p. 8 the title page.
- The text layer is **OCR of a typescript and is noticeably mangled** (accents lost, `é`→`~`,
  `Sp^0`→`SpO`/`Spo`, subscripts flattened, `Γ`→`F`/`£`/`?`). Every quote below is transcribed by
  me from the OCR with the obvious character-level corruption repaired; I flag each repair. The
  mathematical content — group names, the parity dichotomy — is unambiguous in the OCR.

**This is the primary source, not a secondary restatement.**

### 1b. The theorem (odd dimension) — verbatim, then translated

Section **3, "Dimension impaire"** (p. 12). Setup, immediately preceding the theorem (lines
137–146 of the layout extraction):

> Soit `(L,Δ)` un réseau évanescent symplectique. Le groupe `Γ_Δ` est alors contenu dans le groupe
> symplectique `Sp(L)`. On appelle **forme quadratique mod. 2** sur le réseau symplectique `L` une
> fonction `q : L → Z/2Z` satisfaisant `q(x+y) = q(x) + q(y) + (x·y)`. Si on a `q(δ) = 1` pour tout
> `δ ∈ Δ`, le groupe `Γ_Δ` est contenu dans le sous-groupe `Sp⁰(L,q)` de `Sp(L)` formé des
> automorphismes symplectiques qui préservent `q`.

**THÉORÈME 4** (p. 12), verbatim (OCR repaired: `F`→`Γ`, `SpO`→`Sp⁰`, `~`→`Z`, `77`→`Z`):

> **THEOREME 4.-  Supposons `n` impair.**
> **(i)  Si `d` est pair, le groupe de monodromie `Γ_{n,d}` est le groupe symplectique
> `Sp(Hⁿ(X, Z))`;**
> **(ii)  si `d` est impair, il existe sur `Hⁿ(X, Z)` une forme quadratique mod. 2 `q_X`
> invariante par monodromie, et on a `Γ_{n,d} = Sp⁰(Hⁿ(X,Z), q_X)`.**

Translation:

> **Theorem 4. Suppose `n` is odd.**
> **(i) If `d` is even, the monodromy group `Γ_{n,d}` is the symplectic group `Sp(Hⁿ(X,Z))`;**
> **(ii) if `d` is odd, there exists on `Hⁿ(X,Z)` a monodromy-invariant mod-2 quadratic form
> `q_X`, and one has `Γ_{n,d} = Sp⁰(Hⁿ(X,Z), q_X)`**

where `Sp⁰(L,q) := { g ∈ Sp(L) : q ∘ g = q }`, the stabilizer of `q` in the integral symplectic
group.

### 1c. **THE PREMISE OF THE TASK IS WRONG FOR (n,d) = (3,3).**

The task asked me to confirm that for cubic threefolds the monodromy is the **full** symplectic
group of the middle integral cohomology, and to check that `(3,3)` is not on an exceptional list.
What Beauville proves is the opposite for this parity:

- `n = 3` is odd and **`d = 3` is odd**, so we are in **case (ii)**, not case (i).
- **`Γ_{3,3} = Sp⁰(H³(X,Z), q_X) ⊊ Sp(H³(X,Z))`.** For a cubic threefold `H³(X,Z) ≅ Z¹⁰`
  (unimodular symplectic, `g = 5`), so the monodromy is the stabilizer of a canonical mod-2
  quadratic form on `Z¹⁰`, a proper subgroup of `Sp₁₀(Z)`.
- `(3,3)` is **not** an exception to a full-Sp statement; it falls under the *odd-degree* branch,
  which is a general rule, not an exception. Full `Sp` holds for odd `n` and **even** `d` only.

`d = 3` is explicitly covered by the proof, not excluded. The proof needs a hypersurface of
dimension `n`, degree `d` with an `E₆` singularity, and Beauville supplies one for `d = 3`
(p. 12, lines 178–179):

> Pour `d = 3`, on utilise encore la surface cubique avec une singularité de type `E₆`, en ajoutant
> une somme de carrés à son équation.

("For `d = 3`, one again uses the cubic surface with an `E₆` singularity, adding a sum of squares
to its equation.")

**The only cases deferred** in Theorem 4's proof (p. 12, lines 168–169):

> On laisse de nouveau au lecteur le cas des quadriques, ainsi que celui des cubiques planes.

("We again leave to the reader the case of quadrics, and that of plane cubics.") I.e. `d = 2`, and
`(n,d) = (1,3)`. **Cubic *threefolds* `(n,d) = (3,3)` are not deferred** — "plane cubics" is
`n = 1`. There is no other exceptional list for hypersurfaces in this paper.

### 1d. Cross-check via Théorème 6 (complete intersections), which says the form is *canonical*

Section 5 generalizes to complete intersections of multidegree `d = (d₁,…,d_r)` in `P^{n+r}`
(p. 17). **THÉORÈME 6**, verbatim (OCR repaired):

> **THEOREME 6.- Supposons `n = 2ν − 1`, et `d ≠ (2,2)`. Soit `p` le nombre des degrés `d_i` qui
> sont pairs.**
> **(i) Si `binom(ν+p−1, ν)` est pair, il existe une forme quadratique canonique `q_X` mod. 2 sur
> `Hⁿ(X,Z)`, et on a `Γ_{n,d} = Sp⁰(Hⁿ(X,Z), q_X)`.**
> **(ii) Si `binom(ν+p−1, ν)` est impair, le groupe de monodromie `Γ_{n,d}` est égal à
> `Sp(Hⁿ(X,Z))`.**

Specialize to a hypersurface: `r = 1`, `d = (3)`, `n = 3`, so `ν = 2`, and `p = 0` (degree 3 is
odd). Then `binom(ν+p−1, ν) = binom(1,2) = 0`, which is **even** ⇒ case (i) ⇒
`Γ_{3,3} = Sp⁰(H³(X,Z), q_X)`. **Consistent with Theorem 4(ii), and Theorem 6 additionally calls
`q_X` canonical** ("une forme quadratique **canonique** `q_X`"), which Theorem 4(ii) states only as
existence. So for cubic threefolds the invariant mod-2 quadratic form is canonical, not a choice.

(Note the separate `d = (2,2)` carve-out in Theorem 6, p. 17: there the monodromy is that of the
universal family of hyperelliptic curves, and `Γ_{n,d}` consists of symplectic automorphisms whose
mod-2 reduction lies in a subgroup of `Sp(Hⁿ(X, Z/2))` isomorphic to a symmetric group. Irrelevant
to `(3,3)` but it is the one genuine exceptional multidegree.)

### 1e. Answers to the two specific sub-questions

**Integral group or arithmetic subgroup?** Stated for the **integral** group: the objects are
`Hⁿ(X,Z)` with its intersection form (a unimodular symplectic lattice for `n` odd, cf. §3's
"réseau évanescent symplectique unimodulaire" in Théorème 3), and the conclusions name
`Sp(Hⁿ(X,Z))` and `Sp⁰(Hⁿ(X,Z), q_X)` — the full integral symplectic group and the full integral
stabilizer of `q_X`, not merely finite-index or Zariski-dense subgroups. Beauville's route is
Janssen's classification of vanishing lattices (Théorème 3, p. 12: for a unimodular symplectic
vanishing lattice whose `Δ` contains 6 elements with mod-2 intersection diagram of type `E₆`,
either `Γ_Δ = Sp(L)` or `Γ_Δ = Sp⁰(L,q)` for some mod-2 quadratic form `q`), so both alternatives
are *equalities* with integrally-defined groups.

**Does surjectivity mod 2 follow trivially?** **No — and for cubic threefolds the natural mod-2
surjectivity statement is false as usually phrased.** Because `Γ_{3,3} = Sp⁰(H³(X,Z), q_X)`, the
mod-2 reduction lands inside `O(q̄_X) ⊂ Sp(H³(X, F₂)) = Sp₁₀(F₂)`, the orthogonal group of the
induced quadratic form — a **proper** subgroup of `Sp₁₀(F₂)`. So the monodromy does **not** surject
onto `Sp₁₀(F₂)`. Surjection onto `O(q̄_X)` is the correct statement; Beauville does **not** state or
prove it in this paper (he works with the integral group throughout), so if a drafted theorem needs
mod-2 surjectivity onto `O(q̄_X)`, that step needs its own citation — it does not follow from
Theorem 4 by inspection. What Beauville does give, and what is closest in spirit, is
**Proposition 2** (p. 13), the translation of Theorem 4 into an irreducibility statement:

> **PROPOSITION 2.- L'espace des hypersurfaces `X` de dimension impaire `n` et de degré `d`, munies
> d'une base symplectique de `Hⁿ(X,Z)` si `d` est pair (resp. d'une base symplectique adaptée à
> `q_X`, si `d` est impair) est irréductible.**

("The space of hypersurfaces `X` of odd dimension `n` and degree `d`, equipped with a symplectic
basis of `Hⁿ(X,Z)` if `d` is even (resp. a symplectic basis adapted to `q_X`, if `d` is odd), is
irreducible.") — where a symplectic basis `e₁,…,e_{2g}` is *adapted to `q`* if `q(e_i) = 0` for
`i ≤ 2g−2` and `q(e_{2g−1}) = 1`, the value `q(e_{2g})` then being the **Arf invariant** of `q`
(p. 13, lines 244–247). Beauville does not compute `Arf(q_X)` for cubic threefolds anywhere in this
paper.

Context for orientation, from §2 (p. 11, line 106): for cubic **surfaces**, "le groupe de monodromie
`Γ_{2,3}` est le groupe de Weyl" — the classical `W(E₆)` statement.

---

## 2. Relative Gieseker moduli over a base

### 2a. Source identities and cache keys

| what | key added to cache | sha256 | pages |
|---|---|---|---|
| Beauville, LNM 1194, pp. 8–18 | `BEAUVILLE:LNM1194-monodromie` | `4f6eb4e0bbe04ce8787754aba897e1552f47f47853fa34f421f8b30ac58ed045` | 11 |
| Simpson, Publ. IHÉS 79 (1994), 47–129 | `NUMDAM:PMIHES_1994__79__47_0` | `c75ffddf60b20eea2d93fa12e1d030cda524d9f8e2b4df4d60014bc8130a7054` | 84 |
| Huybrechts–Lehn, **1st ed.** (Vieweg E31, 1997) | `ISBN:9783528069070` | `c6b2e504ed5825c8ee42eb44f4773cee8864ad85f157fc46ca91eaecfd7d5ec6` | 281 |

**Edition caveat on Huybrechts–Lehn — read this before citing.** The copy I obtained
(`https://ncatlab.org/nlab/files/HuybrechtsLehn.pdf`) is the **first edition** (Aspects of
Mathematics E31, Vieweg 1997): the title page carries the authors' Essen/Bielefeld addresses and
there is no "Preface to the second edition" and no Cambridge Mathematical Library front matter. I
could not obtain second-edition bytes (the scispace link advertised as "Second Edition" returned an
**HTML page, not a PDF** — exactly the failure mode the cache README warns about, so it was not
ingested).

**The numbering is nonetheless verified to agree with the second edition** by cross-check: the
BBFHMRS cubic-threefold paper cites `[HL10]` (= the 2010 second edition) at **Proposition 1.1.10**
and **Proposition 1.5.2**, and both land on exactly those statements in this first-edition PDF
(`Proposition 1.1.10 — Let E be a coherent sheaf of codimension c on a smooth projective…` and
`Proposition 1.5.2 — Jordan-Hölder filtrations always exist…`). Part I numbering is therefore
stable across the two editions, and Theorem 4.3.7 / §4.6 are both in Part I, Chapter 4. Page
numbers quoted below are the **first edition's**; second-edition page numbers may differ, so cite
by theorem number, not page.

### 2b. Huybrechts–Lehn Theorem 4.3.7 — **the number in the brief is correct**

Theorem 4.3.7, pp. 92–93, verbatim (OCR repaired: `!`→`→`, `X=S`→`X/S`, `` `` ``→subscripts):

> **Theorem 4.3.7 — Let `f : X → S` be a projective morphism of `k`-schemes of finite type with
> geometrically connected fibres, and let `O_X(1)` be a line bundle on `X` very ample relative to
> `S`. Then for a given polynomial `P` there is a projective morphism `M_{X/S}(P) → S` which
> universally corepresents the functor**
>
> ```
> M_{X/S} : (Sch/S)^o → (Sets),
> ```
>
> **which by definition associates to an `S`-scheme `T` of finite type the set of isomorphism
> classes of `T`-flat families of semistable sheaves on the fibres of the morphism
> `X_T := T ×_S X → T` with Hilbert polynomial `P`. In particular, for any closed point `s ∈ S` one
> has `M_{X/S}(P)_s ≅ M_{X_s}(P)`. Moreover, there is an open subscheme
> `M^s_{X/S}(P) ⊂ M_{X/S}(P)` that universally corepresents the subfunctor
> `M^s_{X/S} ⊂ M_{X/S}` of families of geometrically stable sheaves.**

Preceded by (p. 92): "Occasionally, one also needs to consider relative moduli spaces, i.e. moduli
spaces of semistable sheaves on the fibres of a projective morphism `X → S`. It is easy to
generalize the previous construction to this case." The proof reduces to the absolute
Theorem 4.3.3 plus the fact that `M_{X/S}(P) := R//SL(P(m))` is a **universal** good quotient
(Theorem 4.2.10), and ends "We omit the details."

**Base generality — a real mismatch with the brief.** The brief said "Noetherian base". HL 4.3.7
requires `S` to be a **`k`-scheme of finite type**, not an arbitrary Noetherian base. Simpson is
narrower still (finite type over `Spec(C)`). If the drafted theorem genuinely needs a Noetherian
base, **neither citation covers it as stated** and the statement should be restricted to finite
type over a field, which is certainly enough for a family of cubic threefolds over a variety.

### 2c. The universal-family half — §4.6, and why HL alone does **not** give the étale-local form

§4.6 "Universal Families" begins on p. 105. **Definition 4.6.1** (p. 105) is the twist-ambiguity
formulation, verbatim:

> **Definition 4.6.1 — A flat family `E` of stable sheaves on `X` parametrized by `M^s` is called
> universal, if the following holds: if `F` is an `S`-flat family of stable sheaves on `X` with
> Hilbert polynomial `P` and if `Φ_F : S → M^s` is the induced morphism, then there is a line
> bundle `L` on `S` such that `F ⊗ p^*L ≅ Φ_F^* E`. An `M^s`-flat family `E` is called
> quasi-universal, if there is a locally free `O_S`-module `W` such that `F ⊗ p^*W ≅ Φ_F^* E`.**

> Clearly, `M^s` represents the moduli functor `M^s` if and only if a universal family exists.
> Though this will in general not be the case, **quasi-universal families always exist.**

**Proposition 4.6.2** (p. 106): there exist `GL(V)`-linearized vector bundles on `R^s` of
`Z`-weight 1; `Hom(p^*A, F̃)` descends to a quasi-universal family and every quasi-universal family
so arises; **"If `A` is a line bundle then `E` is universal."**

**Theorem 4.6.5** (p. 107) is the obstruction criterion, verbatim:

> **Theorem 4.6.5 — If the greatest common divisor of all numbers `χ(c ⊗ B)`, where `B` runs
> through some family of coherent sheaves on `X`, equals 1, then there is a universal family on
> `M(c)^s × X`.**

with `Corollary 4.6.6` (gcd of the Hilbert-polynomial coefficients `a_0,…,a_d` is 1) and
`Corollary 4.6.7` (for a smooth surface, `gcd(r, c_1·H, ½c_1·(c_1−K_X) − c_2) = 1`). Also
`Exercise 4.6.4`: any two quasi-universal families `E', E''` satisfy
`E' ⊗ p^*W'' ≅ E'' ⊗ p^*W'` for locally free `W', W''` on `M^s`.

**Two corrections to the brief here.**

1. **HL §4.6 does not use Brauer-group language at all.** The obstruction is phrased via GIT
   `Z`-weights and a gcd of Euler characteristics — there is no Brauer class, no `α`-twisted sheaf,
   no `Br(M)` in this section. The "Brauer-obstruction formulation" is the modern rephrasing
   (Căldăraru-style), equivalent but **not** what HL states. Note that Theorem 4.6.5 is *exactly*
   the mechanism LLPZ Corollary 3.9 invokes ("there exists a character `w` such that
   `χ(w,v) = 1`"), just narrated in Brauer language there.
2. **HL §4.6 does not state the étale-local universal family.** It gives a *global* criterion for a
   *global* universal family, plus global existence of quasi-universal families. Nothing in §4.6
   says "étale-locally on `M^s` a universal family exists, unique up to twist".

### 2d. Simpson Theorem 1.21 — **verified, and it is the one that states the étale-local form**

Carlos T. Simpson, "Moduli of representations of the fundamental group of a smooth projective
variety I", Publ. Math. IHÉS **79** (1994), 47–129; **Theorem 1.21 is on p. 71**. Standing setup
(p. 63, and restated p. 70): "Suppose `S` is a scheme of finite type over `Spec(C)` and suppose
`X → S` is projective", with `O_X(1)` relatively very ample.

Verbatim from the page (this Numdam scan's OCR is poor — `M(fl^ P)` / `M(^x? P)` is
`M(O_{X/S}, P)`, `^'univ`/`^pmiv` is `F_univ`, `p-stable` is `p`-stable; I repair only these):

> **Theorem 1.21. — Let `M(O_{X/S}, P)` be the good quotient given by the construction of [Mu],
> applied to the group action on `Hilb(V ⊗ O(−N), P, d)`.**
> **(1) There exists a natural transformation `φ : 𝔐(O_{X/S}, P) → M(O_{X/S}, P)` such that
> `M(O_{X/S}, P)` universally corepresents `𝔐(O_{X/S}, P)`.**
> **(2) `M(O_{X/S}, P)` is a projective scheme.**
> **(3) The points of `M(O_{X/S}, P)` represent the equivalence classes of semistable sheaves under
> the relation that `E_1 ~ E_2` if `gr(E_1) = gr(E_2)`.**
> **(4) There is an open subset `M^s(O_{X/S}, P) ⊂ M(O_{X/S}, P)`, with inverse image equal to
> `Q^s`, whose points represent isomorphism classes of `p`-stable sheaves. Locally in the étale
> topology on `M^s(O_{X/S}, P)` there is a universal sheaf `F_univ` such that if `F` is an element
> of `𝔐^s(O_{X/S}, P)(S')` whose fibers are `p`-stable, then the pull-back of `F_univ` via
> `S' → M^s(O_{X/S}, P)` is isomorphic to `F` after tensoring with the pull-back of a line bundle
> on `S'`.**
> **(5) If `x ∈ M^s(O_{X/S}, P)` is a point such that `Q^s` is smooth at the inverse image of `x`,
> then `M^s(O_{X/S}, P)` is smooth at `x`.**

**Part (4) is verbatim the requested statement**: coarse moduli on the stable locus, étale-locally
carrying a universal family, unique up to tensoring by a line bundle pulled back from the base.

### 2e. Recommendation

**Cite both, one for each half — a single citation does not cover the brief.**

- **Huybrechts–Lehn, Theorem 4.3.7** for *existence and projectivity over the base*. It is the
  cleanest on that half: it names the morphism `M_{X/S}(P) → S`, says **projective morphism**
  (relative projectivity, unambiguous), says **universally corepresents**, identifies the fibres
  `M_{X/S}(P)_s ≅ M_{X_s}(P)`, and carves out the open stable subscheme. Simpson's 1.21(2) says
  only "is a projective scheme" — projective over `S` in his relative setup, but the relative
  phrasing is not explicit on the page.
- **Simpson, Theorem 1.21(4)** for the *étale-local universal family up to a line-bundle twist*.
  HL §4.6 does not state this; HL gives instead a global gcd criterion (Theorem 4.6.5) and global
  quasi-universal families (Proposition 4.6.2). If the drafted theorem leans on the étale-local
  formulation, **Simpson 1.21(4) is required and HL cannot be substituted for it.**
- If a *global* universal family on the cubic-threefold moduli space is what is actually wanted,
  the right citation is **HL Theorem 4.6.5** (gcd of `χ(c ⊗ B)` equals 1), which is the same
  mechanism as LLPZ Corollary 3.9's Brauer argument — and, per my previous report, that criterion
  is satisfied for `v = α + β` because `χ(−α, α+β) = 1`.

---

## 3. LLPZ (arXiv:2406.09124v1) Example 5.7 — re-quoted precisely

Located pp. 27–29 (paper's own numbering), immediately after §5.3's Example 5.6. Header, verbatim:

> **Example 5.7** (Stable objects with character `β + γ`, see [BBF⁺24, Theorem 7.1] for more
> details).

So LLPZ explicitly defer to **BBFHMRS Theorem 7.1** — this example is a restatement/refinement of
the other paper's main theorem, not an independent proof.

### 3a. The construction of `P̃_σ(β,γ)` via the relative `Ext¹` sheaf, with the exact projections

Verbatim (p. 27–28):

> Denote by `U_β` and `U_γ` the universal family on `M_σ^s(β)` and `M_σ^s(γ)`. Consider the
> relative `Ext¹` sheaf `H¹( p_{12,*} Hom(p_{23}^* U_γ, p_{13}^* U_β) )`, and we denote its
> projectivization over `M_σ^s(β) × M_σ^s(γ)` by `P̃_σ(β,γ)`.

The projections are from the **triple product** `M_σ^s(β) × M_σ^s(γ) × Y_3`:
`p_{13}` onto `M_σ^s(β) × Y_3` (where `U_β` lives), `p_{23}` onto `M_σ^s(γ) × Y_3` (where `U_γ`
lives), and `p_{12}` onto `M_σ^s(β) × M_σ^s(γ)` — i.e. the pushforward **kills the threefold
factor**, and `H¹` of it is the relative `Ext¹(U_γ, U_β)`. Note the variance: `U_γ` is the
*source*, `U_β` the *target*, matching `Hom(E_γ, E_β[1])`.

This is the **tilde** version, defined over the whole product; contrast Definition 4.8's
`P_σ(v,w)`, which is defined only over the non-jumping locus `M_σ^s(v,w)^†` and is only a
Brauer–Severi variety. The tilde version exists here because the jumping is completely controlled:

> ```
> hom(E_γ, E_β[1]) = 2  when E_β = L(E_γ)[−1];
>                    1  otherwise.
> ```
>
> So the natural map `π_{β,γ} : P̃_σ(β,γ) → M_σ^s(β) × M_σ^s(γ)` is one-to-one on general points
> and has a `P¹`-fiber on the diagonal `Δ` of `M_σ^s(β) × M_σ^s(γ)`, while identifying
> `M_σ^s(γ)` and `M_σ^s(β)` via `L[−1]`. As each irreducible component is with at least the
> expected dimension, the space `P̃_σ(β,γ)` is irreducible. **As a variety, `P̃_σ(β,γ)` is
> isomorphic to `Bl_Δ(F(Y_3) × F(Y_3))`.**

Then, by Lemma 2.12, every `0 ≠ f ∈ Hom(E_γ, E_β[1])` gives a σ-stable
`E_f := Cone(E_γ --f--> E_β[1])[−1]`, so there is a **morphism** (not merely rational)
`ẽ_{β,γ} : P̃_σ(β,γ) → M_σ^s(β+γ)`, extending `e_{β,γ}` across the jumping locus, and by
Proposition 4.14 it is dominant and generically finite.

### 3b. The generic object and the degree — **two different 6's, do not conflate them**

Verbatim (p. 28):

> Denote by `P_{ℓ,ℓ'}` the projective subspace spanned by `ℓ` and `ℓ'` in `P⁴` when `ℓ ∩ ℓ' = ∅`,
> or the tangent space of `Y_3` at `ℓ ∩ ℓ'` when `ℓ ∩ ℓ'` is a point. In particular, the space
> `P_{ℓ,ℓ'} ≅ P³`. Denote by `S_{ℓ,ℓ'} := P_{ℓ,ℓ'} ∩ Y_3` and `ι : S_{ℓ,ℓ'} → Y_3` the embedding.
> Then the map `g` is determined up to a scalar by the property that `E_g` is supported on
> `S_{ℓ,ℓ'}`. When `ℓ ∩ ℓ' = ∅`, the object `E_g ≅ ι_* O_{S_{ℓ,ℓ'}}(−ℓ)` and
> `e(I_ℓ, F_{ℓ'}) ≅ ι_* O_{S_{ℓ,ℓ'}}(ℓ' − ℓ)`.
>
> **In other words, a general object in `M_σ^s(β + γ)` is of the form
> `ι_* O_{S_{ℓ,ℓ'}}(ℓ' − ℓ)`.** This induces a rational map from `M_σ^s(β+γ)` to `(P⁴)^*` of
> degree 72. In the general case that `S_{ℓ,ℓ'}` is a smooth cubic surface, there are exactly six
> ordered pairs of lines `(ℓ_i, ℓ'_i)` on `S_{ℓ,ℓ'}` such that `[ℓ_i − ℓ'_i] = [ℓ − ℓ']`. **So the
> degree of the morphism `ẽ_{β,γ} is 6`.**

**The `6:1` label in the summary diagram is a *different* map.** Transcribing the diagram (p. 29)
faithfully:

```
                    Bl_1^{-1}(Δ_{F(Y3)})  --6:1-->  Y3
                            |                        | pr
                            v            ẽ_{β,γ}     v
   Δ_{F(Y3)} →  Bl_Δ(F(Y3) × F(Y3))  ----------->  M_σ^s(β+γ)      {pt}
                            |                        | Bl_2          |
                       Bl_1 |                        v               v
              F(Y3) × F(Y3)  --Abel–Jacobi-->      J(Y3)    ⊃    Θ_{J(Y3)}
```

The `6:1` labels the arrow **`Bl_1^{-1}(Δ_{F(Y3)}) → Y_3`** from the exceptional divisor of
`Bl_Δ(F × F)` (a `P¹`-bundle over `F(Y_3)`, of dimension 3) onto the cubic threefold — this is the
universal-line incidence variety `{(ℓ, p) : p ∈ ℓ}` mapping by `(ℓ,p) ↦ p`, which is 6:1 because
**six lines pass through a general point of a smooth cubic threefold**. The degree-6 of
`ẽ_{β,γ}` is the *separate* fact above, from the six ordered pairs of lines on a cubic surface with
a fixed difference class. Both are 6, for unrelated reasons.

`Bl_2` is `Φ_{β+γ}`, the contraction of `Y_3 ⊂ M_σ^s(β+γ)` to the singular point `{pt} ∈ Θ`.

### 3c. (i) What the example says about a universal family on `M_σ^s(β+γ)` — **nothing. Gap.**

The example uses universal families **only on the Fano surface factors** (`U_β` on `M_σ^s(β)` and
`U_γ` on `M_σ^s(γ)`) to build the relative `Ext¹` sheaf. It makes **no statement whatsoever** about
a universal family on `M_σ^s(β+γ)`, and no statement about pulling one back to
`Bl_Δ(F(Y_3) × F(Y_3))` along `ẽ_{β,γ}`. Searched: the whole of §5.3 and the surrounding text; the
strings `universal` and `Brauer` do not occur anywhere between the start of Example 5.7 and §5.4.

What *is* available, but only by combining with material elsewhere in the paper and not asserted in
the example: `β + γ` is primitive, so **Corollary 3.9** gives a universal family `U` on
`M_σ^s(β+γ) × Y_3`; and the cone construction `E_f = Cone(E_γ → E_β[1])[−1]` in families would
express `ẽ_{β,γ}^* U` as a cone of pullbacks of `U_γ` and `U_β` twisted by the tautological bundle
of the projectivization. **The paper never writes that down.** If the drafted theorem needs
`ẽ_{β,γ}^* U` explicitly, it must be constructed, not cited.

### 3d. (ii) Compatibility with the Abel–Jacobi map, and the normalization

The example's diagram commutes with `F(Y_3) × F(Y_3) --Abel–Jacobi--> J(Y_3) ⊃ Θ_{J(Y_3)}` along
the bottom, but the example itself does **not** state the compatibility as a proposition. The
statement is made in the proof of **Theorem 7.2** (p. 49), verbatim:

> The space `M_σ^s(β + α) ≅ M_σ^s(β + γ)`, and as that in Example 5.7, the map `Φ_{β+γ}` is the
> **resolution of the Theta divisor** in `J_{β+γ}(Y_3)`. In particular, its image is connected.

**Which map, and with which normalization.** From §5.2 (p. 27), the Abel–Jacobi map used
throughout is the **cycle-theoretic second Chern class with no base-point subtraction**:

```
Φ_v : M_σ(v) → J_v(Y_3) ,   F ↦ c_2(F)
```

where `J_v(Y_3)` denotes *the component of `CH_1(Y_3)` receiving the image* of `Φ_v` — i.e. the
normalization is pushed into the choice of target torsor rather than into a base point. The
introduction (p. 4) gives the base-pointed variant `Φ : M_σ(v) → J(Y_3), F ↦ c_2(F) − c_2(F_0)`
after choosing `F_0`. Compatibility of the diagram rests on **additivity** (p. 27):

> the group structure on the Chow group gives us a map `+ : J_v(Y_3) × J_w(Y_3) → J_{v+w}(Y_3)`.
> For `E_v ∈ M_σ^s(v)`, `E_w ∈ M_σ^s(w)` and a σ-stable extension
> `E_f = Cone(E_v --f--> E_w[1])[−1]`, we have `Φ_v(E_v) + Φ_w(E_w) = Φ_{v+w}(E_f)`.

That identity is exactly what makes the square
`Bl_Δ(F×F) → M_σ^s(β+γ) → J(Y_3)` equal to `Bl_Δ(F×F) → F×F → J(Y_3)` (sum of the two lines'
Abel–Jacobi classes).

**Normalization mismatch worth flagging.** BBFHMRS use `Ψ : M̄_X(v) → J(X)`, `E ↦ c̃_2(E) − H²`
(base class `H²`, matching Beauville's twisted-cubic base point of class `H²`), whereas LLPZ use
`Φ_v(F) = c_2(F)` into a torsor `J_v(Y_3)`. The two agree only after fixing the identification of
`J_v(Y_3)` with `J(Y_3)`; LLPZ never pin that identification, and in particular **never state where
the singular point `0 ∈ Θ` sits** in their normalization. BBFHMRS do: `c̃_2(K_P) = H²`, so
`Ψ(K_P) = 0`. If the drafted theorem needs the origin pinned, cite **BBFHMRS Lemma 7.4**, not LLPZ.
