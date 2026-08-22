# Quantum Referee A — the differential-equations foundation

Paper: `papers/cubic-stabilization-m1/`, built PDF
`irrationality_after_one_stabilization.pdf` (29 pp). `make check` rebuilds clean (exit 0).

Charge: Section 4 (`sections/04-one-step.tex`) through the framed operation formulas
(`prop:framed-operations`, rendered Proposition 4.7), plus every definition it rests on. Read
context-free; explanatory prose treated as claim, not background.

Label-to-number map for the statements discussed:
`def:framed-sixth-multiplicity` = Def. 4.1, `def:pro-laurent-gauge-group` = Def. 4.2,
`lem:pv-base-change` = Lem. 4.3, `rem:pro-laurent-concrete` = Rem. 4.4,
`lem:formal-base-shift` = Lem. 4.5, `lem:numerical-base-change` = Lem. 4.6,
`prop:framed-operations` = Prop. 4.7, `def:strict-novikov-admissible` = Def. 4.8,
`lem:divisor-tagging` = Lem. 4.9, `prop:low-dimensional-vanishing` = Prop. 4.10,
`thm:nu6-birational-invariance` = Thm. 4.11, `prop:cubic-packet` = Prop. 4.12.

## Overall verdict: GO, with required revisions

All five charges were reached. I found no statement in the charged scope that I believe is
false. Every quantitative claim I could check independently checked out exactly, including
the whole cubic-packet linear algebra (verified symbolically, see below) and every one of the
nine or so numbered citations to Iritani, Iritani–Koto, Katzarkov–Kontsevich–Pantev–Yu and Cai
that I checked against the sources rather than the paraphrase. The invariant is canonical, the
receiver is nonzero, the pro-Laurent construction is correct, and the ramification distinction
is maintained consistently.

What blocks an unconditional CONFIRMED is that the single inference on which the entire
section turns — that an isomorphism implemented by a gauge with only integral powers of `z`
carries one framed monodromy operator to the other — is asserted in one sentence and never
stated as a lemma or proved. The paper builds a common *coefficient* receiver but never a
common *solution* algebra carrying the turn, and the turn is an automorphism of the solution
algebra, not of the coefficients. I believe the missing statement is true and provable (I give
the rank-one case below and it goes through), so this is a proof gap, not a wrong theorem. It
must be filled before publication because without it Proposition 4.7 is unproved as written.

## Charge 1 — framed formal monodromy and `nu_6`: CONFIRMED

The cyclotomic formulation is canonical, and the multiplicity of primitive sixth roots of
unity is independent of every auxiliary choice listed in the charge. My reasoning, checking
each step of `04-one-step.tex:34-151` rather than accepting it:

**The universal exponential (4.0) is well formed.** `K` is a `Q`-vector space containing `C`
as a subspace, so a complement `V` exists. `Exp_V(c+v) = e^{2 pi i c}[v]` is a homomorphism
because the decomposition is additive. Since `V` is torsion-free the group algebra `K[V]` is a
domain with linearly independent monomials, so `Exp_V(c+v) = 1` forces `v = 0` and
`c` in `Z`. Hence `ker(Exp_V) = Z` and `Exp_V(a)` is torsion iff `a` is rational, which is
(4.0a). Both verified.

**Why the construction is needed at all is correct.** Over an abstract algebraically closed
`K` there is no `e^{2 pi i a}`, so a regular-singular module over `K((w))` has a residue but no
intrinsic monodromy; one must choose a homomorphism from `K/Z` into some multiplicative group.
The paper's `Omega_V` supplies a canonical universal such target instead of an arbitrary
choice. This is the standard move (van der Put–Singer fix such a homomorphism by hand) done
better, and it is the right way to make the object canonical. Cai does the same thing
differently, by taking `k` to be the algebraic closure of the Novikov fraction field and
adjoining formal symbols.

**The cyclotomic criterion is right.** The cyclic-block determinant (4.0b),
`char(⊕E_i)(X) = det(X^d I − U)`, is the standard identity for a block cyclic operator and I
checked it in the `d = 2` case. `d` divides `e` because the `e`-th power of the turn fixes each
block, so the induced permutation has order dividing `e`; hence `r = e/d` is an integer and
(4.0c) `U^r = M_RS,V` is dimensionally coherent. If `zeta` is a root of (4.0b) then
`zeta^d` is an eigenvalue of `U`, so `zeta^e = Exp_V(rho)` is a root of unity, so `rho` is
rational by (4.0a); conversely rational `rho` makes `mu^r` torsion, hence `mu` torsion, hence
every root of `X^d − mu` torsion. So root-of-unity eigenvalues occur exactly on the
rational-residue part, and on that part `Exp_V` is the ordinary complex exponential and carries
no dependence on `V`. The rational-residue generalized eigenspace of `M_RS,V` is `U`-invariant
(`U` commutes with `U^r`), so the criterion cuts out a genuine subobject rather than a
basis-dependent piece.

**Independence of each listed choice.**
- *Complement `V` inside the exponential extension*: independent, by the argument just given —
  the surviving part never sees `V`.
- *Levelt–Turrittin splitting and its ordering*: independent, because only the product of the
  orbit polynomials enters, not any individually labelled return map. The paper says this
  explicitly at `04-one-step.tex:126-128` and it is the correct thing to say.
- *Ramification order `e`*: independent, handled by pulling two choices to a common
  ramification `z = u^E`.
- *Algebraic coefficient extension*: independent. The Levelt–Turrittin decomposition is unique,
  the exponential factors are unchanged by enlarging an already algebraically closed
  coefficient field, so the base change of the decomposition is the decomposition, and
  multiplicities are preserved.
- *Integral change of residue representative*: independent, since `Exp_V` kills integers.

One caveat worth recording: the invariance under integral change of residue representative is
argued in one sentence ("multiplies the formal solution by an integral power of `w`"), which is
glib in the resonant case where the shearing matrix is a non-scalar integral matrix. The
conclusion is nonetheless correct, because `Exp_V(R_s) exp(2 pi i R_n)` is a complete invariant
of the regular-singular module (`Exp_V` is injective on a section of `K/Z`, and
`exp(2 pi i R_n)` has the Jordan type of `R_n` in characteristic zero).

**Definition 4.1 itself is sound.** `nu_6` sums algebraic multiplicities of `e^{i pi/3}` and
`e^{-i pi/3}` in the characteristic polynomial, both primitive sixth roots, both in `C`, and
`C` injects into every receiver used later. Multiplicity of a root in `C` is field-independent
in characteristic zero (it is the least `i` with the `i`-th derivative nonvanishing at
`zeta`), which is what makes the later cross-field comparisons legitimate. The paper does not
say this, but it is what its argument needs and it is true.

Unstated background the definition quietly relies on: that `Lambda_T` is a domain, so that its
fraction field and algebraic closure `K_T` exist. This follows from strict convexity of the
Mori cone, but the paper never says so (`04-one-step.tex:16-28`).

## Charge 2 — Levelt–Turrittin over an abstract coefficient field: DEFECT (citation scope)

The substance is fine; the sourcing is not.

Every use of Levelt–Turrittin in the paper is over `K((z))` for an abstract algebraically
closed `K` of characteristic zero, never over `C`. The existence of a ramification after which
the module decomposes into exponential-twisted regular-singular blocks, the uniqueness and
functoriality of that decomposition, and the equivariance of ramified descent are all true over
any algebraically closed field of characteristic zero with the constants acting as constants;
this is Turrittin's theorem in its algebraic form, and it is what van der Put–Singer prove.

The paper's only citation for it is Sabbah's *Introduction to Stokes Structures*
(`04-one-step.tex:84-88`, citing "Lecture 5, Section 5.c, proofs of Theorem 5.8 and
Proposition 5.10"). I pulled arXiv:0912.2762v2 and read the relevant pages. Sabbah's Lecture 5
is the **Riemann–Hilbert correspondence**, and the items numbered 5.8 and 5.10 there are both
Propositions, not a Theorem and a Proposition: 5.8 is the commutation of a diagram of functors
relating a meromorphic connection to its regular part via `H^0 DR^{rd 0}` and `H^0 DR^{mod 0}`,
and 5.10 is an equivalence induced by `H^{-1} p DR^{Iét}`. These are statements about
meromorphic connections on a complex disc and their Stokes-filtered local systems on `S^1`, in
which the Malgrange–Sibuya theorem and `A^{mod 0}` appear. They are complex-analytic. They
cannot support a statement over an abstract `K`, where there is no `S^1` and no local system.

So: what the paper uses is true, and the ramified-descent and functoriality ideas do appear in
Sabbah, but the paper does not earn its use of them over `K` from this citation. Two further
points. First, the published Springer LNM 2060 numbering may differ from the arXiv numbering I
read, so the mismatch between "Theorem 5.8" and "Proposition 5.8" may be a versioning artifact
rather than an error; the scope problem is independent of that. Second, the paper is otherwise
scrupulous about exactly this issue — it constructs `Exp_V` precisely because `e^{2 pi i a}`
does not exist over `K` — which makes the one place it leans on a complex-analytic source
conspicuous.

Fix: cite van der Put–Singer, *Galois Theory of Linear Differential Equations*, Chapter 3 (or
Turrittin directly) for existence, uniqueness and functoriality of the formal decomposition
over an algebraically closed field of characteristic zero, and keep Sabbah only for the descent
picture. This is a one-line repair.

Other places where a statement true over `C` is used over `K`, all of which the paper does
earn: `exp(2 pi i R_n)` is a finite sum using `2 pi i` in `C ⊂ K`; the Katzarkov–Kontsevich–
Pantev–Yu nef-canonical normal form is reproved in the manuscript rather than cited across
fields, and the argument it reproduces is pure linear algebra valid over any field; the
divisor-tagging Vandermonde step is explicitly justified over
`Frac(gr_v A)` in characteristic zero.

## Charge 3 — ramification: roots of Novikov monomials versus roots of `z`: CONFIRMED

I tested this hard, including in the projective-bundle and blowup comparisons, and the
distinction holds everywhere.

The structural reason it holds is that `nu_6(T)` is defined over `K_T`, an *algebraic closure*
of the numerical Novikov fraction field. Every root of a Novikov monomial is therefore already
in the coefficient field before any comparison begins: adjoining `q^{1/2}` or `q^{-1/s}` is not
an extension at all, it is a naming of an element already present. A root of `z`, by contrast,
would change the loop whose turn defines the frame, and would collapse the deck part of the
operator. The paper states this at `04-one-step.tex:153-156` and then honours it.

Checks against the sources, not the paraphrase:

- **Blowup.** The paper says the comparison field adjoins `q^{-1/s_c}` with `s_c = c−1` for
  even `c` and `2(c−1)` for odd `c` (`04-one-step.tex:411-414`). Iritani's (5.11) reads: `s =
  r−1` if `r` is even, `2(r−1)` if `r` is odd, with `r` the codimension. Exact match, including
  the parity, which is easy to get backwards.
- **Projective bundle.** The paper says `r' = r` when `r−1` is even and `2r` when `r−1` is odd,
  with reconstruction coordinate still `q^{-1/r}` (`04-one-step.tex:573-577`). Iritani–Koto
  (5.1) reads: `r' := r` when `r−1` is even, `2r` when `r−1` is odd. Exact match. Note the two
  parity conventions run opposite ways between the two source papers, and the manuscript
  transcribes each correctly rather than harmonising them into an error.
- **No root of `z` is smuggled in anywhere.** Iritani's Theorem 5.18 is an isomorphism of
  `C[z]((q^{-1/s}))[[Q, tau~]]`-modules, and by his Remark 1.3/1.5 the graded convention makes
  that ring equal to `C[q^{±1/s}][[Q, tau~]][[z]]` — a *power series* ring in `z`. So `Psi` and
  `Psi^{-1}` use only nonnegative integral powers of `z`, which is stronger than the paper's
  claim at `04-one-step.tex:408-409`. The mirror coordinates `tau` and `varsigma_j` are valued
  in rings with no `z` at all, matching the paper's "the mirror coordinates are independent of
  `z`".
- **Cubic packet.** `r = (3q)^{1/2}` is used, and the paper is explicit that this lives in
  `K_X` as a Novikov-coefficient element, not as a ramification of `z`
  (`04-one-step.tex:985-988`). Correct. Cai's own setup does the same thing implicitly, by
  working over the algebraic closure `k` of the Novikov fraction field, where `q^{1/2}` is free.
  The genuinely fractional exponents in the cubic calculation are in `z` (`z^{-1/6}`,
  `z^{-5/6}`), and those are *residue exponents* of a regular-singular block, which require no
  ramification of `z` at all — the ramification index for the cubic is 1, since both
  exponential factors `±6r/z` are unramified. The paper's framework handles this correctly.

One presentational hazard: `r` denotes three different things in Section 4 — the ratio `e/d`
(`04-one-step.tex:99`), the rank of the bundle in Proposition 4.7, and `(3q)^{1/2}` in
Proposition 4.12. Likewise `V` denotes the complement of `C` inside `K`, the fibre of the
pro-Laurent gauge group, and the vector bundle. Since the framed operator is written `M_{f,V}`,
this collision is not merely cosmetic.

## Charge 4 — field extensions and receivers: CONFIRMED on nonzeroness, DEFECT on the transport step

**Order of construction.** The paper builds the Hahn field `H_{0,j} = C((Gamma_j^coeff))` from
the coefficient exponent lattice only, takes its algebraic closure, forms the universal
exponential field `Omega_{V,j}`, and *only then* adjoins the loop coordinate as a single
integral generator `e_z`, ordered after the positive coefficient degree
(`04-one-step.tex:526-544`). This order is the right one and it is essential: it guarantees
that no root of `z` enters the exponential extension. The ordering choice is also exactly what
makes the construction work — with coefficient degree dominating, a series with unboundedly
negative `z`-powers whose coefficients have increasing degree has well-ordered support, so it
is a legitimate Hahn series. That is precisely the pro-Laurent phenomenon the paper needs to
accommodate, and putting `e_z` last is what accommodates it. I checked this and it is correct.

**Is the receiver nonzero?** Yes, and the paper's reason is the right one.
`R_j = Omega_{V,j} ⊗_{H_{0,j}} H_{tot,j}` is a tensor product of two field extensions of
`H_{0,j}`, hence nonzero, and each factor injects. `Omega_{V,j}` contains `H_{0,j}` because
`H_{0,j}` sits inside its own algebraic closure inside `Omega_{V,j}`; `H_{tot,j}` contains
`H_{0,j}` because Hahn series on a subgroup embed in Hahn series on the whole group. Same for
the analogous receiver in Lemma 4.3: `A → L_{B,F}` injective plus exactness of localization
gives `Frac(A) → Frac(A) ⊗_A L_{B,F}` injective, hence nonzero, and scalar extension by a
field preserves that.

The receiver is in general **not a domain** — a tensor product of two field extensions rarely
is. The paper never claims it is, and is careful to claim only "nonzero" and "each factor
injects". That is the correct minimal hypothesis, and it suffices, for the reason given under
Charge 1: an identity of monic polynomials in `R_j[X]` between two polynomials whose
coefficients come from subfields injecting into `R_j` forces equality of those coefficients,
and the multiplicity of a root `zeta` in `C` is detected by vanishing of derivatives, which is
preserved under injection. So "does the framed characteristic polynomial mean the same thing on
both sides of every comparison?" — yes, at the level of the polynomial identity, and the paper
has set this up correctly and deliberately.

**Where it breaks down.** What the paper does *not* establish is that the two framed operators
are conjugate over `R_j` in the first place. The framed operator is defined by Levelt–Turrittin
over a *field*, via the action of the turn on a solution algebra. `R_j` is not a field, and no
solution algebra over it is constructed. Worse, the turn as described in the paper — "they fix
`Omega_{V,j}` and the coefficient Hahn field, and no root of `z` is adjoined"
(`04-one-step.tex:542-544`) — is literally the identity on `R_j`, so as an automorphism of the
receiver it carries no information. The content has to live on the solution side.

Concretely, the paper defines `M^bulk := G M_f^{small,shifted} G^{-1}` (equation (4.1c)), which
makes Lemma 4.5's characteristic-polynomial conclusion a tautology, and then asserts in the
proof of Proposition 4.7 that this same `M^bulk` is what `Psi` transports the framed operator
of the blown-up side to ("Thus each center target summand has the framed monodromy of its
specialized small connection", `04-one-step.tex:556-558`). That identification is the whole
theorem, and it is asserted.

The missing lemma is: *if two differential modules over a common field become isomorphic after
base change to a differential ring extension, via a gauge fixed by the turn — in practice, one
using only integral powers of `z` and coefficients on which the turn acts trivially — then
their framed operators are conjugate.* This needs a common solution algebra with the turn
acting, which the paper could build the way Cai builds his `R` (adjoin `z^rho`, `e^Q`, `log z`
as formal symbols modulo the evident relations).

I believe the missing lemma is true. Base change alone certainly does not preserve framed
monodromy — over the Picard–Vessiot ring everything trivializes — so the turn-invariance
hypothesis is doing real work and cannot be dropped. But with it the statement holds. The
rank-one case is a clean check: if `g = sum c_k z^k` lies in the pro-Laurent ring and
`z d/dz (g)/g = delta`, then `k c_k = delta c_k` for every `k`, so `c_k` vanishes unless
`k = delta`, forcing `delta` to be an integer and `g = c_delta z^delta`. So a pro-Laurent gauge
shifts residues only by integers, which `Exp_V` kills. This survives localization of the
coefficients, which is the step one might worry about, because the constraint is on
`z`-exponents rather than on the filtration.

## Charge 5 — pro-Laurent gauge group, inverse-limit ring, formal base shift: CONFIRMED

This is the most carefully executed part of the section and I found no error in it.

**The inverse limit is what the paper says it is.** `lim_N GL(V ⊗ (B/F^N B)((z))) =
GL(V ⊗ L_{B,F})`: a compatible family of invertible matrices has a compatible family of
inverses, so the limit matrix is invertible over the limit ring. Remark 4.4's concrete
description is exactly right — an element is `sum_{k in Z} c_k z^k` with `c_k` in `B` such
that for every `N` all but finitely many negative `k` have `c_k` in `F^N B` — and I verified
that this set is closed under multiplication: in the coefficient of `z^m`, terms with `k` very
negative have `c_k` in `F^N`, terms with `k` very positive have `d_{m−k}` in `F^N`, so all but
finitely many terms lie in `F^N` and the sum converges. The point of the definition, that the
lower Laurent bound may decrease without limit in `N` while the family is still one invertible
matrix over one ring, is correct and is genuinely needed.

**The gauge exists and has the claimed bound.** The recursion (4.1a) is right:
`d/d eta_i` of `sum_alpha G_alpha eta^alpha` produces the factor `alpha_i + 1`, which is
invertible over `C`. The claim that `G_alpha` contains no power of `z` below `−|alpha|` follows
by induction because the quantum-product matrices are `z`-free, so one factor of `z^{-1}` is
added per unit of `|alpha|`. Substituting `eta` in `F^1 B` then puts a bulk-degree-`m` term in
`F^m B`, which is exactly the pro-Laurent condition. Modulo `F^N` the sum is finite, congruent
to the identity modulo a nilpotent ideal, hence invertible. Uniqueness gives compatibility in
`N`. All of this checks out.

**Conjugation is well defined and preserves what is claimed.** `det(X − G M G^{-1}) =
det(X − M)` over any commutative ring, so the characteristic-polynomial half is unconditional.
The frame-preservation half is the gap discussed under Charge 4.

**The treatment of the non-nilpotent unit direction is right and non-obvious.** When `a_0` is
not filtration-nilpotent, `exp(−a_0/z)` genuinely fails to lie in the pro-Laurent gauge group,
because its `z^{-n}` coefficient is `a_0^n/n!`, which does not enter deep filtration levels.
The paper does not paper over this: it separates the twist at the level of connections rather
than gauges, and observes that the twist is unramified in `z`, hence leaves the block
structure, the deck permutation and the residues untouched, so the framed operator is literally
unchanged. This matters in the application, where the blowup's `a_0 = −(c−1) lambda_j` involves
`lambda_j = e^{-2 pi i (j + r/2)/(r-1)} q^{1/(r-1)}`, which carries a *negative* weight and so
does not lie in `B_j` at all. Iritani's own footnote 12 says the `(r−1) lambda_j` term is added
precisely to keep the exponential factors well defined over his ring. The manuscript's handling
matches the source's reason for the term's existence.

**Separation and injectivity are actually proved, not assumed.** The explicit integer weight
`w(Q^{i_* d} u^{rho_C · d}) = L(H · i_* d) + rho_C · d`, with `L` chosen large, is a correct
construction: `rho_C · d` is bounded by a constant times `H · i_* d` on the effective cone
because `H|_C` is ample and the slice of the closed cone is compact. The weight is defined on
the ambient monomial lattice, so it respects all relations in the image monoid — which is the
right way to handle a non-injective monomial map. Hence `∩_N J_j^N = 0` and the maps
`R_j → B_j → L_{B_j,F}` are injective. Same for the projective-bundle case with `c_1(V) · d`.

**Divisor tagging is correct.** I checked the whole proof of Lemma 4.9. The initial-form
argument is sound: properness makes `S_mu` finite and nonempty; the domain hypothesis on the
associated graded is used exactly twice and the paper says where; substituting `t_i = a_i s`
off the finitely many bad hyperplanes makes the exponents distinct integers, and distinct
exponential characters are linearly independent by the Vandermonde on derivatives at `s = 0`
over a characteristic-zero field. The split between the two mechanisms — a filtration-constant
divisor component becomes the coefficient substitution (4.1), a positive-filtration component
is gauged away — is drawn correctly, and the observation that tagging uses only the second
mechanism is what makes `p^tag = p^spec` carry no substitution. Note that `exp(delta/z)` for
`delta` in positive filtration *does* lie in the pro-Laurent group, which is why this works.

The strict-admissibility check for the center maps is correct: giving the exceptional variable
valuation zero, `v_H(Q^{i_* d} q^{-rho_C · d/(c-1)}) = (H|_C) · d`, positive and proper because
`H|_C` is ample.

**The non-injective center map is a real feature of the source, and the paper's repair matches
the source's own caveat.** Iritani's (5.15) is flagged in his text as "(not necessarily
injective but degree-preserving)". Immediately after his Remark 5.6 he writes that because of
the constant term `h_{Z,j}` the pullback of *functions* is ill-defined while the pullback of
*connections* is well defined by the divisor equation. The manuscript's fixed-divisor
argument — that the substitution is well defined on the image because `h_{C,j}` is a scalar
multiple of `rho_C`, so it is determined by the `u`-exponent of the monomial — is a correct
and independent verification of exactly the point Iritani flags. Iritani's (5.19) does give
`h_{Z,j}` as a scalar multiple of `rho_Z`, though that line is OCR-damaged in the cache and I
am relying on a partial reading.

## Independent verification performed

Symbolic recomputation of the cubic packet (Proposition 4.12), from `K_X` and `G_X` as printed:

- `det C = −486 r^5`: confirmed exactly.
- `C^{-1} K_X C = K_0` in the printed block form `diag(6r, −6r, [[0,2],[0,0]])`: confirmed
  exactly.
- The Sylvester block-diagonalization to order `z^3`, solved from scratch: the reduced
  coefficients are `J_0 = [[0,2],[0,0]]`, `D_0 = diag(−19/18, 19/18)`, and
  `E_0 = [[0, −14/(81 r^2)], [−8/81, 0]]` — all three exactly as printed, including the zero in
  the `(1,1)` entry of `E_0`, where Cai's own text has only a `*`. So the manuscript's `E_0` is
  strictly more precise than its source and is right.
- The scalar blocks have vanishing `z^1` coefficient and `z^2` coefficients `±19/(144 r)`, both
  in `C[r, r^{-1}]`, confirming `h_±` in `z^2 R[[z]]` at the computed orders.
- The indicial elimination: `rho = 2c − 19/18` and `c(rho+1) = (19/18)c − 8/81` do eliminate to
  `rho^2 + rho + 5/36 = 0` with roots `−1/6, −5/6`, and `det L_s = (s + 1/6)(s + 5/6)`.
  Confirmed by hand and by the printed recursion matrix.
- Cross-check against Cai: his `−14/(243q)` equals the manuscript's `−14/(81 r^2)` since
  `r^2 = 3q`; his `±3 sqrt 3 q^{1/2}` eigenvalues of `K/2` match `±6r`.

Script: `/tmp/claude-1000/.../scratchpad/cubic2.py` (scratch, not committed).

Citation spot-checks against sources rather than the manuscript's paraphrase, all confirming:
Iritani Theorem 5.18 and its `(c−1)` center summands; Iritani (1.1), (5.11), (5.15), Remark
5.6, Remarks 1.3–1.5, (5.45)/(5.47), Theorem 5.18(6); Iritani–Koto Theorem 5.1(4) and (5),
Proposition 5.6, (1.1), (5.1)–(5.3), Remark 1.2, Remark 5.2; Katzarkov–Kontsevich–Pantev–Yu
Claim 6.15 with its `g = Gr + T/2`; Cai's Section 3 matrices, indicial equation and scalar
solutions. Both 2026 preprints cited (Iritani's notes, arXiv:2604.10028, and Iritani–Koto v4)
exist on arXiv with the dates the manuscript gives (v4 dated 31 January 2026; the notes posted
11 April 2026, revised 19 April 2026).

Iritani's blowup theorem carries **no** standing assumption beyond `X` smooth projective over
`C` and `Z` smooth of codimension at least two — no convergence, positivity, nef or Fano
hypothesis, and no numbered Assumption anywhere in that paper. So the manuscript is not
silently dropping a hypothesis. Iritani–Koto's only hypothesis is `V^vee` globally generated,
which the manuscript addresses via that paper's Remark 1.2.

## Severity-ranked defects

**1. Moderate — the framed-transport principle is asserted, never stated or proved.**
`sections/04-one-step.tex:198-201` (the sentence "If the gauge uses only integral powers of `z`
at every finite level, this conjugacy preserves the original-`z`-disc frame"), its one-sentence
proof at `:213-215`, and the load-bearing application at `:546-554` and `:556-558`. The paper
constructs a common coefficient receiver but no common solution algebra carrying the turn, and
the turn as described acts trivially on the receiver. Without this, Proposition 4.7 is unproved
as written. Fix: state and prove a lemma to the effect that a turn-invariant gauge conjugates
framed operators, building the solution algebra over the receiver by adjoining `z^rho`,
`log z`, `e^phi` as formal symbols. I expect this to be about a page and to go through.

**2. Low-to-moderate — Levelt–Turrittin over `K` is sourced to a complex-analytic reference.**
`sections/04-one-step.tex:84-88`. Sabbah's Lecture 5 is the Riemann–Hilbert correspondence over
`C`; its 5.8 and 5.10 are Propositions about Stokes-filtered local systems on `S^1`, and cannot
support a statement over an abstract algebraically closed field. The result used is true over
any such field. Fix: add van der Put–Singer Chapter 3 (or Turrittin) as the load-bearing
citation.

**3. Low — the ambient-endpoint faithfulness is verified only on the blown-up side.**
`sections/04-one-step.tex:564-571` proves injectivity of `beta ↦ (phi_* beta, −E · beta)` for
`N_1` of the blowup, but Proposition 4.7 says "the endpoint terms are the intrinsic small
invariants", which covers both endpoints. In fact the ambient side is fine — Iritani's (1.1)
sends `C[[Q]]` into the comparison ring "in an obvious way", i.e. by an injection — so this is
a one-clause omission, not a hole.

**4. Low — the mechanism cited for the global-generation reduction is the wrong one.**
`sections/04-one-step.tex:694-698` justifies tensoring `V` by a negative line bundle by saying
"the resulting divisor shift preserves framed monodromy by Lemma 4.5". But Iritani–Koto's
Remark 5.2 states that the Novikov embedding (5.2) is *intrinsic*, defined by the kernel of
`c_1(T_vert)`, and independent of `V` up to tensoring by a line bundle. So there is no shift to
absorb. The conclusion is right; the reason given is not the available one.

**5. Low — `Lambda_T` is not shown to be a domain.** `sections/04-one-step.tex:16-28` takes the
fraction field of the completed monoid ring without noting that strict convexity of the Mori
cone makes it a domain. One sentence.

**6. Cosmetic but not harmless — notational collisions.** `r` is the ratio `e/d` at `:99`, the
bundle rank in Proposition 4.7, and `(3q)^{1/2}` in Proposition 4.12; `V` is the complement of
`C` in `K` at `:35`, the fibre in Definition 4.2, and the vector bundle in Proposition 4.7. The
framed operator is written `M_{f,V}`, so the reader must disambiguate a subscript. Also
`def:pro-laurent-gauge-group` (`:158-173`) introduces `k` without defining it, and two labelled
equations in the divisor-tagging proof (`:763`, `:773`) carry `\label` without `\tag`, so they
resolve to a bare "4" in the `.aux` — harmless only because nothing references them.

## What I could not verify, and why

- **Iritani's (5.19)**, giving `h_{Z,j}` as a multiple of `rho_Z` and the `q`-exponent in
  `q_{Z,j}`. The cached text extraction is damaged at that line; the exponent numerator did not
  survive. The manuscript's use of "`h_{C,j}` is a scalar multiple of `rho_C`" is consistent
  with the legible fragment and with Theorem 5.18(3)+(4), but I read a reconstruction, not the
  formula. Check against the PDF before relying on it.
- **The parity claim.** Iritani's blowup paper contains no explicit statement that the
  decomposition preserves cohomological parity, only `Z`-degree homogeneity (degree 0 on the
  ambient component, degree `−c` on the center components) plus a §2.2 convention that
  deliberately *decouples* parity from degree so that fractional powers of `q` carry odd degree
  and even parity. Since `s = 2(c−1)` for odd `c` makes `q^{1/s}` have degree 1, the degree
  bookkeeping alone does **not** force parity preservation; one needs `Psi` to be parity-even.
  The manuscript rests this on Iritani's separate notes, arXiv:2604.10028v2 §2
  (`sections/04-one-step.tex:333-337`). That preprint exists with the stated date, but it is
  not in the shared cache and I did not read it. The claim is plausible on its own terms — the
  cohomological operations involved (pullback, pushforward, Fourier transform, characteristic
  class multiplication) all preserve parity, and the target bulk coordinates `varsigma_j` are
  degree 2, hence even — but it is inference, and it is load-bearing, since `nu_6` is defined
  on the *even* connection while both source theorems are for the full quantum D-module. A
  referee should read that notes reference directly.
- **Whether Iritani–Koto's Theorem 5.1(5) was "corrected in the fourth version"**
  (`sections/04-one-step.tex:651-653`). The v4 text does contain the invertibility clause
  "and is invertible over `C((q^{-1/r}))`", and v4 is indeed dated 31 January 2026, so both
  factual components check out. But v4 carries no erratum or version note, so the assertion
  that item (5) *changed* in v4 cannot be confirmed from the text; it would need a v3 diff.
- **Sabbah's published numbering.** I read arXiv:0912.2762v2; the Springer LNM 2060 numbering
  may differ, so I cannot say whether "Theorem 5.8" is a numbering slip or a version
  difference. The scope objection in defect 2 does not depend on this.
- **Anything outside the charged scope.** I did not audit Sections 2 and 3 (the cycle-theoretic
  half), Proposition 4.10's use of the surface classification beyond checking its internal
  logic, or Corollary 4.13. I did verify Proposition 4.12 symbolically even though it falls
  after the charged boundary, because it is the sole source of the nonzero value.
