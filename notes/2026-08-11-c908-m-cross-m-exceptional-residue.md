# C908: the (1,5) residue on M x M and the exceptional divisor

Date: 2026-08-11

Status: **negative for the proposed candidate family, with an exact mechanism**;
two of the pass-2 geometric premises corrected; **not** a structural negative.
C908 mathematics only. No manuscript, PDF, mirror, Lean, or foreign-note edit.

Notation throughout: `J` is the generic exotic `A5` intermediate Jacobian
(a ppav of dimension five), `Theta ⊂ J` its theta divisor with its unique
singular point at the origin — an ordinary triple point whose projectivized
tangent cone is the cubic threefold `X ⊂ P^4`. `sigma : M -> Theta` is the
blow-up at the origin, `i : Theta -> J` the inclusion, `b = i o sigma : M -> J`,
`h = b^* Theta`, `iota : M -> M` the lift of inversion. The exceptional divisor
of `sigma` is `X` itself; write `e_X : X -> M` for that inclusion, with
`N_{X/M} = O_X(-H)`. `Lambda = H^1(J,Z)` of rank ten, `Lambda_2 = Lambda (x) F_2`,
`L = Theta ^ (-)`. **I write `e_X` rather than `j` for the exceptional inclusion
because the C904 Kunneth audit already uses `j = (1,iota)` for the anti-graph.**

## 1. The frozen residue functional

### 1.1 Derivation from the committed degree formula

From `notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md`: for
`Z in CH^3(Sym^2 M)` with `s_* Z = d[J]`, `Gamma = q^* cl(Z)`,
`lambda(Z) = (1/2)(1,iota)^* Gamma`, and (1.2) `d = int_M h . lambda(Z)`. The
integral transfer generators in bidegree `(r, 6-r)` are
`x (x) y + (-1)^{r(6-r)} y (x) x`; for `r = 1` this is `x (x) y - y (x) x`.
Inversion acts by `(-1)^k` on the inherited odd groups, so

\[ (1,\iota)^*(x\otimes y - y\otimes x) = x\,\iota^*y - y\,\iota^*x
   = -xy + yx = -2xy , \]

whence `lambda = -xy` and, for a `(1,5)` component `sum_i c_i (alpha_i (x) beta_i
- beta_i (x) alpha_i)`,

\[ \boxed{\;d_{(1,5)} \;=\; -\sum_i c_i \int_M h\,\alpha_i\,\beta_i\;}. \]

By Theorem 1 below every `alpha_i` is `b^* alpha_i'` with `alpha_i' in Lambda`, so
the projection formula turns this into

\[ \boxed{\;d_{(1,5)} \;=\; -\sum_i c_i \int_J \Theta\,\alpha_i'\,b_*\beta_i\;}
   \qquad\text{(the frozen functional).} \]

This agrees termwise with equation (2.1) of the Kunneth audit
(`± int_J f_*alpha . f_*beta`, using `f_* alpha = Theta alpha'`) and with the
mod-two pairing (2.3) `(a,[B]) -> int_J Theta . a . B`.

### 1.2 Well-definedness over Z, and the fixed dual pair of bases

Two integrality facts make the readout a genuine integral bilinear form rather
than a rational one.

- `L : Lambda -> ∧^3 Lambda` has **all elementary divisors 1** (certified), so
  its image is saturated and `alpha'` is recovered integrally from
  `b_* alpha = Theta . alpha'`. Without this, `alpha'` would only be defined
  after inverting some integer and the mod-two readout would be ill-posed.
- `L : ∧^5 Lambda -> ∧^7 Lambda` has Smith form `1^110 2^10` (certified,
  independently reproducing equation (2.2) of the Kunneth audit), so
  `Q_15 := coker(L) = (Z/2)^10`, and the pairing
  `P(a,[B]) = int_J Theta . a . B mod 2` kills `im(L)`, has rank ten, and is
  therefore **perfect** on `Lambda_2 x Q_15` (certified).

Fixed dual pair of bases. The Clemens--Griffiths Abel--Jacobi isomorphism
`phi : H^3(X,Z) -> Lambda` is integral and carries the cup form to the
polarization form; both are unimodular, so `phi` identifies the two lattices
together with their unimodular forms. Fix the exotic principal basis
`u_0,...,u_9` of `Lambda` with Gram matrix `S` (recorded in the certificate);
`phi^{-1}(u_k)` is the corresponding basis of `H^3(X,Z)`. The perfect pairing `P`
identifies `Q_15 ≅ Lambda_2^∨`, hence

\[ \Lambda_2\otimes Q_{15}\;\cong\;\operatorname{End}_{\mathbf F_2}(\Lambda_2), \]

and a `(1,5)` residue is an element `phi_res` of that endomorphism group.
"Realizing the coefficient identity mod 2" means: `phi_res` is the identity of
the five-dimensional `F_4`-coefficient lattice, i.e. the identity `I_10` of
`End_{F_2}(Lambda_2)`. **Its parity readout is normalization-dependent — see
section 6; do not use the phrase without saying which readout is meant.**

## 2. Verified: premise (a)

**Theorem 1.** `b^* : H^1(J,Z) -> H^1(M,Z)` and `b^* : H^3(J,Z) -> H^3(M,Z)` are
isomorphisms. In particular the first leg of any `(1,5)` class on `M x M` is a
pullback.

*Proof.* Two steps.

(i) `Theta` is an ample effective divisor in the smooth projective fivefold `J`,
so `J \ Theta` is affine of dimension five and the Lefschetz theorem for a
possibly singular ample divisor gives `H^k(J,Z) ≅ H^k(Theta,Z)` for
`k ≤ dim J - 2 = 3`. Hence `H^1(J,Z) ≅ H^1(Theta,Z)` and
`H^3(J,Z) ≅ H^3(Theta,Z)`.

(ii) Put `U = M \ X = Theta \ {0}`. The Gysin sequence of the divisor `X ⊂ M`
reads `... -> H^{k-2}(X,Z) -> H^k(M,Z) -> H^k(U,Z) -> ...`. Since
`H^{-1}(X,Z) = 0` and `H^1(X,Z) = 0` (a cubic threefold is simply connected),
restriction `H^k(M,Z) -> H^k(U,Z)` is injective for `k = 1` and `k = 3`.
Removing the single point `0` from the four-dimensional `Theta` changes nothing
in degrees `k ≤ 6`, so `H^k(U,Z) ≅ H^k(Theta,Z)` for `k = 1,3`. The composite
`H^k(Theta,Z) --sigma^*--> H^k(M,Z) --restrict--> H^k(U,Z) = H^k(Theta,Z)` is
the identity, so `sigma^*` is surjective; injectivity of the restriction then
forces `sigma^*` to be bijective. Compose with (i). ∎

This is the rigorous form of the audit's "weak Lefschetz identifies `H^3(M,Z)`
with `H^3(J,Z)`", and it confirms premise (a): because `H^1(X,Z) = 0`, the
exceptional divisor contributes nothing to `H^1(M,Z)`.

## 3. Corrected: premise (b)

**Theorem 2 (Gysin isomorphism).**
`b_* : H^5(M,Z)/{\rm tors} \longrightarrow H^7(J,Z) = ∧^7 Lambda` is an
**isomorphism**.

*Proof.* Poincare duality on the smooth projective fourfold `M` gives a
unimodular pairing `H^5(M,Z)/tors x H^3(M,Z) -> Z`, i.e. an isomorphism
`P_M : H^5(M,Z)/tors -> H^3(M,Z)^∨`. Poincare duality on `J` gives a unimodular
`P_J : ∧^7 Lambda -> (∧^3 Lambda)^∨`. The projection formula
`int_M beta . b^*x = int_J b_*beta . x` says exactly
`P_M = (b^*)^∨ o P_J o b_*`. By Theorem 1, `b^* : ∧^3 Lambda -> H^3(M,Z)` is an
isomorphism, so `(b^*)^∨` is one; `P_M` and `P_J` are isomorphisms; hence `b_*`
is an isomorphism. ∎

**Corollary 2.1 (the correct geometric realization of the residual).** Since
`b_* b^* = Theta . (-)` (as `sigma` is birational, `b_*b^* = i_*sigma_*sigma^*i^*
= i_*i^* = Theta.(-)`), Theorem 2 identifies

\[ \operatorname{coker}\bigl(L:\textstyle\bigwedge^5\Lambda\to\bigwedge^7\Lambda\bigr)
   \;\cong\; H^5(M,\mathbf Z)\big/\bigl(b^*H^5(J,\mathbf Z)+{\rm tors}\bigr)
   \;\cong\;(\mathbf Z/2)^{10}. \]

So the residual `(Z/2)^10` measures the **failure of `b^*` to be surjective on
`H^5`** — a non-pullback phenomenon, exactly as pass-1 Theorem B predicted.

**Corollary 2.2 (premise (b) is false).** `b o e_X` is the constant map to
`0 in J`, so `(b o e_X)_*` factors through `H^{k-6}({\rm pt})`, which vanishes
for `k = 3`. Hence `b_* e_{X*} = 0` on `H^3(X,Z)`. Combining with Theorem 2,
`e_{X*}H^3(X,Z)` lies in the **torsion** of `H^5(M,Z)`.

Therefore `coker(L)` is **not** realized by `e_{X*}H^3(X,Z) ⊂ H^5(M,Z)`: that
subgroup is precisely in the kernel of the readout, and is torsion. (The `Z/3`
in the link's `H^4(L,Z) = Z^10 (+) Z/3` recorded in
`notes/2026-08-11-c904-theta-resolution-topology-integral-projector-audit.md`
is consistent with `e_{X*}H^3(X,Z)` being three-primary, hence invisible mod
two; the note itself does not establish the full integral torsion of `H^*(M,Z)`,
and nothing here needs it.)

## 4. Theorem 3 (exceptional-leg vanishing) and what it kills

**Theorem 3.** Let `W in CH^3(M x M)` and suppose the second leg of the `(1,5)`
Kunneth component of `cl(W)` lies in `e_{X*}H^3(X,Z)` (equivalently, that
component lies in `Lambda (x) e_{X*}H^3(X,Z)`). Then the `(1,5)` residue of `W`
vanishes — identically, and independently of any trace normalization.

*Proof.* By section 1 the readout is `-sum_i c_i int_J Theta alpha_i' b_*beta_i`,
and `b_*beta_i = 0` by Corollary 2.2. ∎

The mechanism is worth stating plainly: **the residue functional is built from
`b_*`, and `b` contracts the exceptional divisor to a point, so the readout is
blind to `X` exactly where the candidate construction puts its content.**

## 5. The candidates, with exact codimension bookkeeping

### 5.1 Candidate (i): the universal codimension-two cycle

*Literature input, verified.* Voisin, *On the universal CH0 group of cubic
hypersurfaces*, arXiv:1407.7261v2 (cache sha256
`514e5634d920f4b8e9c6797f3de5ad34afea65624ba23cc764d329ebcdd2c4e4`), Theorem 1.6
= Theorem 4.1: a rationally connected threefold admits a cohomological
decomposition of the diagonal iff (1) `H^3(X,Z)` is torsion-free, (2) there is a
universal codimension-two cycle on `J(X) x X`, and (3) `theta^4/4!` is
algebraic; and Theorem 1.7 = Corollary 4.4: for a smooth cubic threefold,
universally trivial `CH_0` iff `theta^4/4!` is algebraic. Read depth and loci as
recorded in the committed
`notes/2026-08-11-c908-reviewer-claims-verification.md` (Claim 1, VERIFIED, full
text). The C904 six-axis saturation theorem makes `theta^4/4!` algebraic on every
smooth `A5` member of Roulleau's pencil, hence `CH_0` is universally trivial,
hence a Chow — a fortiori cohomological — decomposition of the diagonal exists,
hence **condition (2) holds and a universal cycle `Z in CH^2(J x X)` exists on
our family.** Its `(1,3)` Kunneth component is, by definition of universality,
the Clemens--Griffiths identity in `Lambda (x) H^3(X,Z)`.

*Bookkeeping.* `dim(M x X) = 7`; `(b x 1_X)^* Z in CH^2(M x X)`; `e_X` has
codimension one in `M`; so

\[ W_1 \;:=\; (1_M\times e_X)_*\,(b\times 1_X)^*Z \;\in\; CH^{2+1}(M\times M)
   = CH^3(M\times M). \]

Codimension three exactly — the sketch's shape is right. Kunneth: `[Z]` has
components in bidegrees `(0,4), (1,3), (2,2), (4,0)` (the `(3,1)` component
vanishes since `H^1(X) = 0`), and `(b^* (x) e_{X*})` sends `(1,3)` to
`H^1(M) (x) H^5(M)`. So `W_1` does have a `(1,5)` component, and it is exactly
`(b^* (x) e_{X*})` of the Clemens--Griffiths identity — the intended shape.

*Residue: **ZERO**.* Its second leg lies in `e_{X*}H^3(X,Z)`, so Theorem 3
applies. No trace normalization is involved.

The same conclusion holds for every variant that places an odd-degree leg on the
exceptional divisor: `(e_X x 1_M)_*(1_X x b)^*{}^tZ` (whose only odd mixed
component is `(5,1)`, first leg `e_{X*}H^3(X,Z)`), and any composite
`Z o {}^tZ` pushed to `J x J` and pulled back, which is killed instead by pass-1
Theorem B.

### 5.2 Candidate (ii): the Fano incidence correspondence

`F` is the Fano surface, `P ⊂ F x X` the universal line (codimension two in the
fivefold `F x X`), and after common-line normalization `a_s : F -> J` satisfies
`a_s(F) ⊂ Theta` with `a_s(s) = 0` and `a_s` injective, so `a_s^{-1}(0) = {s}`
and `a_s` lifts to `mu : \tilde F = Bl_s F -> M`.

*Bookkeeping, and why it fails before any parity question.* `dim \tilde F = 2`.
A codimension-three cycle on `M x M` has dimension five. Pushing forward from
`\tilde F x \tilde F` (dimension four) cannot reach dimension five at all.
Pushing forward from `\tilde F x X` (dimension five) can only reach it with the
full fundamental class, giving the **decomposable** product

\[ (\mu\times e_X)_*[\tilde F\times X] \;=\; \mu_*[\tilde F]\,\times\,e_{X*}[X]
   \;\in\; CH^2(M)\otimes CH^1(M)\subset CH^3(M\times M), \]

whose Kunneth support is the even bidegree `(4,2)`: it has **no `(1,5)`
component whatsoever**. Using `P` itself (dimension three) lands in
codimension five, not three. Mixed forms `(mu x 1_M)_*` of a divisor on
`\tilde F x M` are either decomposable or, when built from `b` on the second
factor, pullbacks killed by pass-1 Theorem B.

*Residue: **not applicable / ZERO**.* The Fano incidence data does not produce a
`(1,5)` component at codimension three by any of these routes. This is a
dimension count, not a parity computation, and I record it as such.

## 6. The normalization discrepancy — flagged, not adjudicated

My derivation in section 1.1 gives, unambiguously,
`d_{(1,5)} ≡ sum_i c_i int_J Theta alpha_i' b_*beta_i (mod 2)`, which under the
perfect pairing `P` is the **`F_2`-linear trace** of the residue endomorphism
`phi_res in End_{F_2}(Lambda_2)`. Two committed C904 notes instead assert that
the unordered degree is the **five-dimensional `F_4`-coefficient trace**:
`notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md` §2.3 ("Its
unordered degree is the coefficient trace. The identity therefore has degree
five, not ten") and
`notes/2026-08-11-c904-exotic-deck-final-move-red-team.md` (executive verdict:
"This is the five-dimensional **coefficient** trace, not the ordinary
`F_2`-linear trace on the ten-dimensional Hodge lattice; the latter is even and
is divided by two on passage to the symmetric quotient").

The two readouts genuinely disagree on the Clemens--Griffiths identity, and the
certificate pins the arithmetic exactly:

- `F_2`-linear trace of `I_10` = `10 = 0 mod 2` (even);
- `F_4`-coefficient trace of `I_5` = `5 = 1 mod 2` (odd);
- for any `F_4`-linear `phi` on `F_4^5`, `tr_{F_2}(phi) = Tr_{F_4/F_2}(tr_{F_4}(phi))`
  (verified on all eight canonical samples), and `Tr_{F_4/F_2}(x) = x + x^2`
  vanishes on `F_2` and equals 1 on `{w, w^2}`.

So under the `F_2`-linear readout a coefficient-linear residue is odd **exactly
when its `F_4`-coefficient trace lies outside `F_2`** — the identity is then
even, and a residue such as `w . I_5` is odd. Under the coefficient-trace
readout the identity is odd.

**Where I think the disagreement sits.** The factor two from the transfer
generator (`(1,iota)^*(x (x) y - y (x) x) = -2xy`) is already consumed by the
`1/2` in `lambda(Z) = (1/2)(1,iota)^*Gamma`; I can find no second halving in the
chain, which is what the coefficient-trace normalization would require. If that
reading is right, then the raw contraction *is* the degree, the full-`S_3`
vanishing recorded as equation (2.1) of the exotic-deck note would after all be a
genuine `(1,5)` parity obstruction, and the "sharp construction target" of
realizing the coefficient **identity** would be aiming at an even class.

**I am not asserting this.** It contradicts two committed notes, one of which
reports an independent exact replay in support of its own reading, and the
resolution turns on the precise integral transfer basis of `H^6(Sym^2 M, Z)` in
bidegree `(1,5)` — specifically whether `q^*` of an integral class can have a
`(1,5)` component that is not an integral combination of `x (x) y - y (x) x`.
That is a Nakaoka/Gugnin question about the symmetric-square lattice, not
something my certificate settles. **Recommended adjudication:** re-derive
`d_{(1,5)}` for one explicit class with known degree, in both normalizations, and
have the owner of those notes rule. Every conclusion in sections 2--5 of this
note is independent of the outcome, because the candidate residues vanish before
any trace is taken.

## 7. Verdict

**NEGATIVE for the candidates in (c), with an exact mechanism** — and
deliberately not more.

1. Candidate (i), the universal codimension-two cycle transformed into
   `CH^3(M x M)` through the exceptional divisor, has **residue exactly zero**.
   Mechanism: `b o e_X` is constant, so `b_* e_{X*} = 0`; the residue functional
   is blind to the exceptional divisor. Robust to the section-6 dispute.
2. Candidate (ii), the Fano incidence correspondence, produces **no `(1,5)`
   component at codimension three** by any of the routes checked; the obstruction
   is a dimension count (`dim \tilde F = 2`), not parity.
3. **This is NOT a structural negative.** Theorem 2 shows
   `b_* : H^5(M,Z)/tors ≅ ∧^7 Lambda` is onto, so classes with odd residue exist
   cohomologically; Corollary 2.1 locates them precisely in
   `H^5(M,Z)/(b^*H^5(J,Z) + tors) = (Z/2)^10`. The `(1,5)` channel is not closed;
   only this candidate family is.
4. **Nothing about descent or the unordered-theta index is claimed.** Even had a
   candidate produced an odd residue, converting it into `ind(Y) = 1` requires
   the separate symmetric-descent and anti-graph-normalization audit, and then
   the Bezout step against the known multiplier two. That chain is untouched
   here.
5. Integral versus rational, and algebraic versus Hodge, at the two places it
   matters: the readout's integrality rests on the two certified Smith forms
   (§1.2) and is genuinely integral, not merely rational; and no statement in
   this note asserts that any class is algebraic beyond candidate (i), whose
   algebraicity is inherited from Voisin's universal cycle via the verified chain
   in §5.1.

## 8. Reposed target

Combining pass-1 Theorem B with Theorems 1--3: the first leg is always a
pullback (Theorem 1); pullback second legs give `b_*beta in L∧^5Lambda`, hence
even; exceptional second legs give `b_*beta = 0`, hence zero. So an odd `(1,5)`
residue requires

\[ \beta\;\in\;H^5(M,\mathbf Z)\;\setminus\;
   \bigl(b^*H^5(J,\mathbf Z)+e_{X*}H^3(X,\mathbf Z)+{\rm tors}\bigr), \]

as the second Kunneth leg of an integral **algebraic** codimension-three class on
`M x M`. By Corollary 2.1 the target quotient is exactly `(Z/2)^10`, and by
Corollary 2.2 the exceptional divisor does not help populate it. The next
concrete question is therefore: **which algebraic codimension-three cycles on
`M x M` have a second `(1,5)` leg outside `b^*H^5(J,Z) + tors`?** Neither of the
two obvious geometric sources on this fourfold — pullbacks from `J x J` and
cycles supported on or transformed through `X` — can do it. That is a genuinely
narrower and better-posed question than the one pass 2 started from.

## 9. Bundle, replay, checksums

Working directory: the repository root `/home/tavis/src/othello`.

```sh
nix shell nixpkgs#sage -c sage \
  notes/2026-08-11-c908-m-cross-m-exceptional-residue.sage \
  --json notes/2026-08-11-c908-m-cross-m-exceptional-residue.json \
  --out notes/2026-08-11-c908-m-cross-m-exceptional-residue.out
```

The Sage run leaves a preparsed `.sage.py` translation which must be deleted; the
committed bundle is debris-free.

| artifact                                             |  bytes | SHA-256                                                          |
| ---------------------------------------------------- | -----: | ---------------------------------------------------------------- |
| `2026-08-11-c908-m-cross-m-exceptional-residue.sage` | 12,495 | ef962fa32dc4d57409b02cd594a59bb0e07c60295836d2eab305b68afa9ace23 |
| `2026-08-11-c908-m-cross-m-exceptional-residue.json` |  5,436 | 7ae69251e2d2c3a316cf5a37cc7ab80a3432fc603154fa1c023e511d6564b9ea |
| `2026-08-11-c908-m-cross-m-exceptional-residue.out`  |    474 | 073a983b636474a53b7505033c9251b0e73064c87fe605fb268b106c0d9f278d |

Load-bearing input:
`notes/2026-08-10-c904-minimal-class-divisor-lattice.sage`, SHA-256
`d77752dcf242cdd3e8ecf15d34785eba583aa4c4c7770b79decd2f43e260f734`.

**What the certificate covers and what it does not.** Certified: the two Smith
forms, perfection of the mod-two readout pairing, and the finite-field
arithmetic of the two competing normalizations. Not certified — all human proofs
in this note: Theorem 1, Theorem 2 and its corollaries, Theorem 3, and the
codimension bookkeeping of §5. Cross-checks: the `1^110 2^10` Smith form
independently reproduces equation (2.2) of the C904 Kunneth parity audit from a
separate code path; the readout derivation of §1.1 is checked termwise against
equations (2.1) and (2.3) of that audit; and `L : Lambda -> ∧^3 Lambda` being
saturated is a new integrality fact not previously recorded.

## 10. Mystery ledger (EJ + TT closeout)

- **Settled:** premise (a) is true and now has a rigorous proof
  (`H^1(J,Z) ≅ H^1(M,Z)`, and the same for `H^3`).
- **Settled, correcting premise (b):** the residual `(Z/2)^10` is
  `H^5(M,Z)/(b^*H^5(J,Z)+tors)`, **not** `e_{X*}H^3(X,Z)`; the latter is in the
  kernel of the readout and is torsion.
- **Settled:** `b_* : H^5(M,Z)/tors -> ∧^7 Lambda` is an isomorphism. This
  upgrades the audit's "identification" to a proof and shows odd residues exist
  cohomologically.
- **Settled:** the residue functional is blind to the exceptional divisor,
  because `b` contracts it. This kills candidate (i) outright and is robust to
  every normalization question.
- **Settled:** candidate (ii) fails on dimension grounds before parity.
- **Settled (new integrality):** `Theta ^ (-) : Lambda -> ∧^3 Lambda` has
  saturated image, so the readout is integral rather than merely rational.
- **Open and now sharp:** which algebraic codimension-three cycles on `M x M`
  have second `(1,5)` leg outside `b^*H^5(J,Z) + tors`? Both obvious geometric
  sources are excluded.
- **Open, and a genuine surprise:** the exceptional divisor — the only geometry
  distinguishing `M` from `Theta`, and the thing pass-1 pointed at — turns out to
  be exactly what the readout cannot see. The non-pullback classes that populate
  `(Z/2)^10` must come from somewhere else, and I have no candidate source for
  them.
- **Open, flagged for adjudication, not manufactured:** the trace normalization
  of §6. It changes which residue is the target (`I_5` versus a class with
  `F_4`-trace outside `F_2`) and it changes whether the exotic-deck vanishing is
  a parity obstruction. It does not change anything else in this note.
