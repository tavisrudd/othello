# C913 cold read, round 6 — gauged transport, one-chart appendix, scope item (5)

Date: 2026-08-15. Manuscript: `papers/cubic-stabilization-irrationality/`, frozen at
`b3e7eb883`. Referee: independent, no prior involvement with this text.

## Scope and method

Read in full and judged:

- `sections/08-global-transport.tex`, lines 1–916 — from the start of the section through the end
  of the proof of `prop:clutching-tail-holonomicity`. This covers `def:gauged-admissible`,
  `rem:iv-semistable-restriction`, the clause-by-clause standing paragraph, `rem:endpoint-only`,
  `lem:point-insertion-row`, `prop:support-collapse`, `lem:orbit-cylinder-disjoint`, the
  Włodarczyk terminology paragraph, `prop:gamma-ratio-reduction`,
  `rem:higher-pole-localization-boundary`, `rem:neutral-boundary`, `thm:tailwise-derived`, and
  `prop:clutching-tail-holonomicity`. (I also read `rem:two-tail-threshold-obstruction`, lines
  918–936, which sits just past the scope boundary, and checked its example.)
- `sections/appendix-one-chart.tex` in full (808 lines).
- `sections/08-scope.tex` item (5), and items (6)–(7) for consistency with what the scoped proofs
  actually assume.
- `sections/01-introduction.tex` lines 110–118 (the paragraph beginning "The conditional proof uses
  a smooth projective equivariant completion"), plus lines 95–165 for self-description.

Read for context: `sections/02-point-row.tex` in full.

Independently recomputed, not accepted from the text: the Gamma index identity
`eq:gamma-index-factor` on both degree rays and its agreement with the standard equivariant
$H^0$/$H^1$ weight sets on $\mathbf P^1$; the adjacent-ratio identity `eq:adjacent-gamma-ratio`;
the one-character residue normalization `eq:simple-gamma-residue`; the Riemann–Roch slope identity
`eq:total-moving-slope`; the full Stirling expansion of $\log|c_k|$ including the $\zeta$-scale
term and the two-ray uniformity; the $\mathcal D'(S^1)$ boundary-value estimate; the
$\Gm$ fibre-weight numerical criterion and every step of `lem:orbit-cylinder-disjoint`; the
freeness/localization/injectivity chain in `rem:iv-semistable-restriction`; the Gamma-framed
point-section computation behind `lem:point-insertion-row`; the graded-extension and
attractor-ideal computations of `lem:app-graded-extension`, `lem:app-sign`, `prop:app-one-chart`
(including the $\mathbf P^1$ chart-dependence counterexample and the $U_F$ covering argument);
the tangent-weight sign convention and the $aw\le 0$ selection in `lem:app-cech` (checked against
Białynicki-Birula on the manuscript's own $\A^1$ example, both signs of $k$); the cotangent
triangle of the iterated derived fibre product in `prop:app-cutting`(a); the $\mu_k$/gerbe descent
in `prop:app-mu-k`; and the two-tail counterexample in `rem:two-tail-threshold-obstruction`.

Sources read at full text from the shared disk-backed cache `/tmp/persistent/tavis/lit-search/`:

| key                  | paper                                                      | sha256 (first 16)   |
|----------------------|------------------------------------------------------------|---------------------|
| `arXiv:1208.1727`    | González–Woodward, VGIT wall-crossing for GW invariants     | `2c99203c8e1d7dd3`  |
| `arXiv:1408.5864`    | Woodward, Quantum Kirwan II                                 | `018530b8cc031ab5`  |
| `arXiv:1408.5869`    | Woodward, Quantum Kirwan III                                | `5aa794f4d83dd8d1`  |
| `arXiv:math/9904074` | Włodarczyk, Birational cobordisms                           | `ac86c460c3a03928`  |
| `arXiv:2301.01266`   | Aleshkin–Liu, Higgs–Coulomb correspondence in abelian GLSMs | `921af8ed2105d6a5`  |

Locators checked against those sources, one by one: Woodward III Definition 7.13(a),
Proposition 7.14(b) and its proof, Section 8.3, Definition 9.7, Lemmas 9.8 and 9.9,
Corollary 9.10(a)–(c), Example 9.15, equations (54), (56)–(59) and the signed Euler-class display
following (59), the normalization introduced at (64), Section 9.4 and equation (68);
Woodward II Proposition 5.21(a), Example 4.3(f),(g), Section 4.3, Example 6.6(c);
González–Woodward Propositions 3.14, 3.15(c), 3.18, Lemma 3.17, Remark 3.19, Corollary 3.20,
Lemma 3.21 and its proof, Remark 1.18(d), Remark 4.6, equation (47), Remark 4.7;
Włodarczyk Definition 5, Lemma 6, Proposition 2(B') and its proof, and the definition
$L(X,D;X',D') = \mathcal O_X(-D)\cup_{V\times K^*}\mathcal O_{X'}(D')_\infty$;
Aleshkin–Liu Definition 5.18, Remark 5.20, Theorem 5.21.

Not available in the cache, so judged against standard knowledge only and marked UNVERIFIED
below: Behrend–Fantechi §4, Graber–Pandharipande, Toën–Vezzosi HAG II, Schürg–Toën–Vezzosi,
Mumford–Fogarty–Kirwan GIT Chapter 2 §2.1 Theorem 2.1.

## Required repairs

**R1 (minor, one clause).** `prop:clutching-tail-holonomicity`, the parenthetical justifying the
displayed polynomial recurrence: "take a linear relation among the first $r\dim_{\C}R_N+1$ shifts"
is false as a general statement about a vector-valued solution of a first-order system, and I give
an explicit counterexample below. The proposition's conclusion — $(D)$-finiteness — is unaffected;
the safe count is $(r\dim_{\C}R_N)^2+1$, by the same one-line argument. Details in Finding R1.

That is the only required repair I found.

## Optional improvements

**O1.** The main text asserts "Woodward's relative perfect obstruction theory *is* the natural
truncation map $E_a\to L_{t_0\mathfrak S_{a_-,a_+}/\mathfrak M}$ `\cite[Definition~7.13]`", which
reads as a citation; Definition 7.13(a) fixes the complex $(Rp_*e^*T(X/G))^\vee$ and does not write
a morphism, exactly as `conv:app-obstruction-morphism` says. Half a clause ("in the reading fixed
in Convention …, compared there in Lemma …") would remove the tension.

**O2.** `k` is overloaded inside `08-global-transport.tex`: it is the affine-degree index in
`eq:affine-moving-degree` and throughout the growth estimate, and the orbifold cover order in the
paragraph beginning "On a $k$-fold orbifold chart", which is also the appendix's exclusive use.
The sentence "consecutive degrees inside a tail differ by the stabilizer order of
Proposition `prop:app-mu-k`(b)" therefore says, in the reader's eye, that consecutive $k$ differ
by $k$. Renaming the orbifold order (e.g. $\kappa$) in the main text would fix it.

**O3.** `prop:app-descent` does not state $a_\pm\ne0$, but its proof applies `prop:app-one-chart`,
which requires it, and its right-hand side names components $F_\pm$ that exponent zero does not
select. The surrounding prose after `lem:app-sign` explains why zero is a removed threshold, so
this is only a missing hypothesis line in the statement.

**O4.** In the proof of `lem:app-truncation`, "the relative cotangent complex … is the pushforward
along $\pi$ of the pullback of the *cotangent* complex of the target, dualized as above" inverts
the two operations; the object actually used, and the one $E_a$ is defined from, is the dual of the
pushforward of the pulled-back *tangent* complex.

**O5.** The main text calls $F^0_{\le0}V$ and $F^\infty_{\le0}V$ "extension subbundles" that "are
the tangent bundles of the two attracting loci". `lem:app-cech` identifies them as pullbacks of
$T([W^{a_\pm}_{F_\pm}/\Gm])$ — tangent complexes of quotient stacks, and only their $h^{-1}$
vanishing (finite stabilizers) makes "bundle" defensible. The appendix's word, "subcomplexes", is
the accurate one.

**O6.** González–Woodward and Włodarczyk are cited as journal articles (JAG 24 and JAG 9), but
every locator used matches the arXiv preprints (`1208.1727v7`, `math/9904074v1`), which the
literature audit already pins by SHA-256. A one-line note that internal numbering follows the
arXiv version would protect the locators against publisher renumbering. Both bib entries already
carry `eprint`, so the reader can get there.

**O7.** `prop:app-cutting`(a) says "the direct sum of the three factor obstruction theories" while
the proof writes cotangent complexes, and calls the triangle "relative" while displaying the
absolute one. Cosmetic.

**O8.** In `prop:support-collapse`, "whose two sections carry opposite weights" is attached to
`\cite[Lemma~3.21 and its proof]{GonzalezWoodward}`. What the proof of Lemma 3.21 supplies is the
exact triangle with the trivial factor from the fibre of $\mathbf P(D(L_-)\oplus D(L_+))$; the
opposite-weight statement is the manuscript's own (correct, standard) observation about the two
fixed sections of that $\mathbf P^1$. Splitting the sentence would make the boundary exact.

## Verdict table

| Statement / passage | Verdict |
|-------------------------------------------------|------------------------------------------------|
| `def:gauged-admissible` (i)–(iv) and the clause-by-clause standing paragraph | Correct and complete as a register; matches the body and `08-scope.tex` item (5) |
| `rem:iv-semistable-restriction` | Correct; freeness + localization ⇒ injectivity chain verified |
| `rem:endpoint-only` | Correct; the universal quantifier over maps is genuinely needed |
| `lem:point-insertion-row` and its proof | Correct given the registered normalization input; scalar $c_n(z)$ recomputed |
| `prop:support-collapse` | Correct; every González–Woodward and Woodward locator supports what it is cited for |
| `lem:orbit-cylinder-disjoint` (a)–(c) | Correct; numerical criterion, affineness in $u$, and support argument all verified |
| Włodarczyk terminology / resolution paragraph | Correct; Definition 5 and the proof of Proposition 2(B') say exactly this |
| `prop:gamma-ratio-reduction` | Correct; `eq:gamma-index-factor`, `eq:total-moving-slope`, `eq:adjacent-gamma-ratio`, `eq:simple-gamma-residue` all recomputed |
| `rem:higher-pole-localization-boundary` | Correct and appropriately restrictive |
| `rem:neutral-boundary` | Correct; Aleshkin–Liu and González–Woodward locators verified |
| `thm:tailwise-derived` and proof | Correct; proof establishes the statement at the strength later used |
| `prop:clutching-tail-holonomicity` | Statement correct; growth and distribution estimates verified; **one wrong step in the proof (R1)** |
| `rem:two-tail-threshold-obstruction` | Correct; the bilateral example checks out |
| `conv:app-obstruction-morphism` | Accurate description of what Definition 7.13 does and does not fix |
| `lem:app-graded-extension`, `lem:app-sign` | Correct |
| `prop:app-one-chart` | Correct; chart-dependence counterexample and $U_F$ covering both check out |
| `prop:app-descent` | Correct; missing $a_\pm\ne0$ hypothesis (O3) |
| `lem:app-cech`, `rem:app-degree-one` | Correct; sign convention independently confirmed |
| `lem:app-truncation` | Correct; wording slip (O4) |
| `prop:app-square` | Correct, including the Behrend–Fantechi Picard-stack paragraph (UNVERIFIED against BF itself) |
| `prop:app-mu-k` (a)–(d) | Correct; rigidified-inertia locator matches Woodward II Example 4.3(g) verbatim |
| `prop:app-cutting` (a)–(d) | Correct; three-factor presentation is Woodward's equation (54), and the reason given for avoiding (57) is right |
| `rem:app-imports` | Accurate; matches `conv:app-obstruction-morphism` and the appendix opening |
| `08-scope.tex` item (5) | Complete; I found no input used in `prop:support-collapse` that it fails to register |
| Introduction paragraph, lines 110–118 | Accurate self-description |

## Findings

### R1 (required, minor). The shift count in the $(D)$-finiteness argument is wrong

Quoted text, `sections/08-global-transport.tex`, proof of `prop:clutching-tail-holonomicity`:

> If \(c_k\in R_N^r\) is the resulting virtual pushforward, Gamma recurrence gives a rational
> finite-state recurrence in \(k\).  Clearing its denominators yields
> \[ \sum_{i=0}^d p_i(k)c_{k+i}=0, \qquad p_i(k)\in R_N[k], \]
> on the tail, with scalar \(p_i\): fix a \(\C\)-basis of \(R_N\), view the Gamma recurrence as a
> first-order system of size \(r\dim_{\C}R_N\) over \(\C(k)\), and take a linear relation among the
> first \(r\dim_{\C}R_N+1\) shifts.

Write $M=r\dim_{\C}R_N$ and $c_{k+1}=A(k)c_k$ with $A(k)\in M_M(\C(k))$. The assertion is that the
$M+1$ *vector*-valued sequences $c,\sigma c,\dots,\sigma^{M}c$ are $\C(k)$-linearly dependent with
*scalar* coefficients. That is false in general.

Counterexample. Take $M=2$ and the companion system $A(k)=\begin{pmatrix}0&1\\1&k\end{pmatrix}$,
i.e. $c_k=(u_k,u_{k+1})$ with $u_{k+2}=u_k+k\,u_{k+1}$. Pick $u$ with $u_k,u_{k+1}$ independent
over $\C(k)$ (the operator $\sigma^2-k\sigma-1$ admits no first-order right factor over $\C(k)$:
$u_{k+1}=g(k)u_k$ would force $g(k+1)=k+1/g(k)$, which has no rational solution). In the basis
$(u_k,0),(u_{k+1},0),(0,u_k),(0,u_{k+1})$ of $\mathcal V^{\oplus 2}$ one computes
$u_{k+3}=(k+1)u_k+(1+k+k^2)u_{k+1}$ and hence

- $c = (1,0,0,1)$,
- $\sigma c = (0,1,1,k)$,
- $\sigma^2 c = (1,k,k+1,1+k+k^2)$.

A relation $p_0c+p_1\sigma c+p_2\sigma^2c=0$ forces $p_0=-p_2$ from the first coordinate and
$p_1=-kp_2$ from the second; the third coordinate then reads $p_1+(k+1)p_2=p_2=0$, so
$p_0=p_1=p_2=0$. The three shifts are independent, and $M+1=3$ does not suffice.

Why the conclusion survives. Let $\mathcal V=\mathrm{span}_{\C(k)}\{c^{(1)},\dots,c^{(M)}\}$, so
$\dim\mathcal V\le M$; every component of $\sigma^ic=B_i(k)c$ is a $\C(k)$-combination of the
$c^{(j)}$, so all shifts lie in $\mathcal V^{\oplus M}$, of dimension $\le M^2$. Hence
$M^2+1$ shifts are dependent, and the displayed recurrence exists with $d\le M^2$. Equivalently:
run the manuscript's own argument componentwise — for each $l$ the shifts $\sigma^ic^{(l)}$ all lie
in $\mathcal V$, so $M+1$ of them are dependent — and then take a least common left multiple of the
$M$ resulting scalar operators.

Repair. Replace "$r\dim_{\C}R_N+1$" by "$(r\dim_{\C}R_N)^2+1$", or replace the clause with the
componentwise-plus-LCLM reading. Nothing downstream uses the order $d$: the proposition asserts only
that a linear recurrence with polynomial coefficients exists, the growth estimate is independent of
$d$, and `rem:two-tail-threshold-obstruction` and the threshold hypotheses do not refer to it.

### What I checked and found correct, with the computation

**`eq:gamma-index-factor` on both rays.** With $x=\alpha_a/\zeta$,
$\prod_{m=0}^{n}(\alpha_a+m\zeta)=\zeta^{n+1}\Gamma(x+n+1)/\Gamma(x)$, so the reciprocal is
$\zeta^{-n-1}\Gamma(x)/\Gamma(x+n+1)$, matching the display for $n\ge0$. For $n<0$ the reversed-product
convention gives $1/\prod_{m=0}^{n}=\prod_{m=n+1}^{-1}(\alpha_a+m\zeta)$, and
$\zeta^{-n-1}\Gamma(x)/\Gamma(x+n+1)=\prod_{i=1}^{-n-1}(\alpha_a-i\zeta)$ — the same thing, a product
of $|n|-1$ factors, exactly the equivariant weight set of $H^1(\mathbf P^1,\mathcal O(n))$, while for
$n\ge0$ the weights $\alpha_a,\alpha_a+\zeta,\dots,\alpha_a+n\zeta$ are those of $H^0$. So the single
meromorphic expression really does deliver $e(H^1)/e(H^0)$ on both rays, and the manuscript's
sentence "the two degree rays are not assigned unrelated Gamma products" is earned, not asserted.

**`eq:total-moving-slope`.** $\chi(\mathcal O(n_a))=n_a+1$ on both rays, so the slope of the virtual
rank is $\sum_ah_a$; the index is of $T(W/\Gm)=[TW-\mathfrak g]$ with $\mathfrak g$ trivial of degree
zero, and the fixed part is constant along the tail by `thm:tailwise-derived`, so the whole slope
sits in the moving index and equals $c_1^{\Gm}(TW)\cdot\delta$. The manuscript's explicit warning
that no $\mathrm{sign}(n_a)$ is inserted is the right one to give.

**`eq:adjacent-gamma-ratio` and `eq:simple-gamma-residue`.** $(hk+a)^{-1}=\Gamma(hk+a)/\Gamma(hk+a+1)$
is immediate. For the residue: with $u=h\sigma+\alpha$, $\sigma-\sigma_0=(u+m)/h$, so
$\operatorname{Res}_{\sigma=\sigma_0}\Gamma(h\sigma+\alpha)=h^{-1}\operatorname{Res}_{u=-m}\Gamma(u)
=(-1)^m/(h\,m!)$. Both correct, and `rem:higher-pole-localization-boundary` correctly refuses to
extend this to coincident or higher poles.

**The Stirling display.** For $n_a\ge0$ the log-magnitude is
$-(n_a+1)\log|\zeta|-\log|\Gamma(x_a+n_a+1)/\Gamma(x_a)| = -n_a\log n_a+n_a-n_a\log|\zeta|+O(\log n_a)$;
for $n_a<0$ the $H^1$ product of $|n_a|-1$ factors gives
$|n_a|\log|n_a|-|n_a|+|n_a|\log|\zeta|+O(\log|n_a|)$, which is the same expression
$-n_a\log|n_a|+n_a-n_a\log|\zeta|$ written with $|n_a|=-n_a$. Substituting $n_a=h_ak+s_a$ and using
$\log|n_a|=\log k+\log|h_a|+O(1/k)$ reproduces the four displayed terms exactly, with the $s_a$
contributions falling into $O(\log k)$. Neutrality kills the $k\log k$ term, the $(\sum h_a)k$ term
and the $\zeta$-scale term, leaving $-k\sum_ah_a\log|h_a|$, which is what the single rescaling
removes. The manuscript's insistence on writing the $\zeta$-scale term out before imposing
neutrality is what makes the two-ray uniformity checkable, and it checks.

**The distributional estimate.** With $|c_k|\le Ck^N(\log k)^M$ and $q>N+2$, $\sum_k|c_k/k^q|$
converges; $g_r(\theta)=\sum b_kr^ke^{ik\theta}$ converges uniformly on $r\le1$ by the M-test, so
$g_1$ is continuous, and $\partial_\theta^q(b_ke^{ik\theta})=c_ke^{ik\theta}$ recovers the series.
Continuity of $\partial_\theta^q$ on $\mathcal D'(S^1)$ gives the radial limit with order $\le q$.
The omitted $k=0$ term is a constant, order $0$. Correct as written.

**`lem:orbit-cylinder-disjoint`.** The fibre-weight criterion is derived correctly from the
embedding: $[t\cdot v]\to[v_{k_{\min}}]$ as $t\to0$ and $[v_{k_{\max}}]$ as $t\to\infty$, the
$\mathcal O(1)$-fibre at $[v_k]$ has weight $-k$, and semistability of $[v]$ is $k_{\min}\le0\le
k_{\max}$ (equivalently $0\notin\overline{\Gm v}$), which is exactly $\mu_M(y_\infty)\le0\le
\mu_M(y_0)$. (a) freeness gives trivial stabilizer, $\mathbf P^1\to W$ extends by projectivity and
adds precisely the two limits, and stability at $L_-$ gives $\mu_0(w_0)>0>\mu_0(w_\infty)$, hence
$w_0\ne w_\infty$. (b) $\mu_u$ is affine in $u$ and positive at both ends at $w_0$, negative at both
ends at $w_\infty$, hence keeps sign on $[0,1]$; a fixed component semistable at $L_u$ has
$\mu_u\equiv0$ on it, so it contains neither limit, and $O$ contains no fixed point. (c) both limits
are unstable at $u\in\{0,1\}$, so $\overline O\cap W^{\mathrm{ss}}(L_\pm)=O$, $O$ is closed there,
and its equivariant Poincaré dual descends to the point class of the free quotient; the vanishing on
$F$ is the standard supported-class argument, $H^*_{\Gm,\overline O}(W)\to H^*_{\Gm,\overline O\cap
F}(F)=0$. All correct, and the hypotheses used (ampleness, equivariance, stable = semistable, free
semistable loci, bistability of $x$) are exactly the ones `def:gauged-admissible`(i) plus the
registered bistability input supply.

**`rem:iv-semistable-restriction`.** Perfection of Białynicki-Birula gives
$\dim H^*(W)=\dim H^*(W^{\Gm})$, hence equivariant formality, hence freeness of $H^*_{\Gm}(W;\Q)$;
Borel localization makes the kernel of restriction to the fixed locus torsion; a torsion submodule
of a free module is zero, so restriction is injective; and the two endpoint point classes are
nonzero. The remark's refusal to lean on a parity argument, and its Frankel cross-check, are both
sound. This is the remark that makes `def:gauged-admissible`(iv)'s restriction to *semistable* fixed
components necessary rather than merely convenient, and the paper is right to say so.

**`lem:point-insertion-row`.** With `eq:gamma-framed-section` and $\mathrm{ch}(\mathcal O_p)=[\mathrm{pt}]$:
$\widehat\Gamma_Y$ and $z^{c_1(Y)}$ act as the identity on the top class, $(2\pi i)^{\deg/2}$ contributes
$(2\pi i)^n$, $z^{-\mu}$ contributes $z^{-n/2}$, and $(2\pi)^{-n/2}$ is a constant; so
$s_Y(\mathcal O_p)=c\,L_Y[\mathrm{pt}]$ with $c$ invertible and depending only on $n$ and the
conventions. Unitarity of $L_Y$ for the $e^{-\pi i}z$-twisted pairing then gives
$[L_Y\phi,\,cL_Y[\mathrm{pt}])=c(\phi,[\mathrm{pt}])_Y$, which is `eq:point-insertion-row`. The
cancellation of $c_{\dim Y_\pm}(z)$ in `prop:support-collapse` is legitimate because $Y_\pm$ are
birational and hence equidimensional. The one imported input is stated in the proof and again in
`08-scope.tex` item (5).

### Source comparisons

**Woodward III Corollary 9.10(c) vs `eq:liouville-character`.** The source gives
$\exp(\bar\gamma+(d_++\phi_+,\gamma)\zeta)$. With $\gamma=\sum_jt_jD_j$ this is
$\exp(\sum_jt_j\bar D_j)\prod_j\exp(t_j\zeta(D_j\cdot(d_++\phi_+)))$, i.e. the manuscript's display
with $\widetilde d_+=d_++\phi_+$ and $x_j=\exp(t_j\zeta)$. The gloss "the bubble degree together
with the affine cocharacter degree of the gauged principal component" is exactly $d_++\phi_+$.
Supported.

**Woodward III Section 9.4 vs the distinguished output evaluation.** The source defines
$F^G_{n_\pm,1}(d)$ as "the locus of bundles with sections that are constant in some trivialization in
a neighborhood of $B\Z_k$" with markings mapping to $0\in\mathbf P(1,k)$, and then "the evaluation
map $F^G_{n_\pm,1}(d)\to I_{X//G}$ at $B\Z_k$". The manuscript's sentence is a faithful paraphrase,
including the point that this evaluation is not the value at $0$ or $\infty$ where bubbling occurs.
Supported.

**Woodward III equation (68).** The source equates $\int_{[I_{X//G}]}\tau_{X//G,-}(\kappa(\dots))\cup
\alpha_\infty$ with $\int_{[I_{X//G}]}\tau^{G,n}_{X,-}(\alpha_1,\dots,\alpha_n,1)\cup\alpha_\infty$,
and concludes $(\tau_{X//G,-}\circ\kappa^G_X)(\alpha)=\tau^G_{X,-}(\alpha)$. The manuscript's
description — the composite equated with the gauged graph potential *in the distinguished output
slot*, with `eq:endpoint-gauged-maps` its input derivative — is exactly right, including the care
about which slot. Supported.

**Woodward III (59) and the display after it vs `eq:virtual-normal-euler`.** The source's
$\mathrm{Eul}(N_\pm)=\mathrm{Eul}((Rp_*e^*T(X/G))_{\mathrm{mov}})(\mp\zeta)(\mp\zeta-\psi)$ is
reproduced verbatim; the source's prose assigns node deformation and attaching-point deformation to
the two extra factors, and the $\psi$ is "the cotangent line of the node", so the manuscript's
"move the attaching point and smooth the node, respectively" assigns them correctly. The source's
own caveat "assuming there is some non-trivial component attached" licenses the manuscript's
restriction, and Example 9.15 states outright that for the irreducible unstable domain the normal
complex is the moving part alone. The normalization pin to where (64) is introduced is right: that
is where $/\!\mp\!\zeta(\mp\zeta-\psi)$ appears. Supported.

**González–Woodward Lemma 3.17 + Proposition 3.18 vs the wall-term argument.** Lemma 3.17: for
$\rho>\rho_0$ (degree-dependent), a Mundet-semistable $L_t$-fixed map has principal component
mapping to $X^{\zeta,t}/G_\zeta$ with $X^{\zeta,t}$ the $L_t$-semistable locus of $X^\zeta$;
Proposition 3.18 places every $\C^\times$-fixed component of the master space in the image of
$M^{G_\zeta}_n(C,X,L_t,\zeta)$ for some $t\in(-1,1)$. The manuscript's "For each fixed degree and
sufficiently large area" matches the degree-dependence of $\rho_0$. Remark 3.19's fibre product is
over $(X^\zeta)^r$, not $X^{\zeta,t}$, which is precisely the manuscript's point that the framings
are compared in the ambient $W^{\mathsf w}$ and the principal side carries the semistability.
Proposition 3.15(c) places an arbitrary node or marking only in $P(X^Z)$, with no semistability,
which is what the manuscript uses to explain why an ordinary marking on a bubble tree is not
covered. Lemma 3.21's proof supplies the exact triangle with the trivial
$\mathbf P(D(L_-)\oplus D(L_+))$-fibre factor. Corollary 3.20 gives the $\C^\times$-equivariant
relative perfect obstruction theory on the fixed components, pulled back from the master space, as
a special case of Graber–Pandharipande, with the hypothesis that automorphism groups are finite
modulo $\C^\times_\zeta$ — which `def:gauged-admissible`(ii)'s proper-DM clause registers. Every one
of these locators says about the same object, in the same direction, what it is cited for.

**González–Woodward Remark 1.18(d), Remark 4.6, equation (47), Remark 4.7 vs `rem:neutral-boundary`.**
Remark 1.18(d): in the crepant case the wall-crossing term is, after summing over degrees, a sum of
derivatives of delta functions. Remark 4.6: any $\sum f(d)q^d$ with $f$ polynomial is such a sum and
is almost everywhere zero. Equation (47) is the a.e.-vanishing display. Remark 4.7 says the results
say nothing about convergence and give equality only *if* the two potentials happen to be analytic
with overlapping domains. The manuscript's characterization — a weaker distributional statement, and
the authors explicitly declining analytic continuation without an independent convergence input —
is accurate, and the direction of the caveat is right.

**Aleshkin–Liu Definition 5.18, Remark 5.20, Theorem 5.21 vs `rem:neutral-boundary`.** The source's
setup has two maximal cones of the secondary fan adjacent along a codimension-one wall, an integral
generator $h$ defining a circuit, the Calabi–Yau condition $\sum_ih_i=0$ from $\sum_iD_i=0$, the
grade-restriction inequality (5.37) which Remark 5.20 names, and Theorem 5.21 giving convergence and
equality of the wall and chamber hemisphere partition functions on an open set. Finite-dimensional,
linear, abelian. The manuscript's list of the five features is exact, and its statement that this
supplies neither the derived-intersection argument nor the marked threshold comparisons is a
restriction, not an overclaim.

**Woodward II Example 4.3(f),(g) vs `prop:app-mu-k`(d).** (g) is $\bar I_{\mathcal X,r}
:=I_{\mathcal X,r}/B\mu_r$ with the canonical quotient cover $\pi:I_{\mathcal X}\to\bar I_{\mathcal X}$
inducing an isomorphism on rational cohomology, so that $\bar I$ may be replaced by $I$ "at the cost
of additional factors of $r$ on the $r$-twisted sectors". The manuscript reproduces the formula and
the factor statement verbatim, and its added remarks — $\pi_*\pi^*\simeq\mathrm{id}$ for a
$B\mu_k$-gerbe in characteristic zero because $\pi_*$ takes the weight-zero part, hence $\pi^*$ is
fully faithful and conservative, hence equivariant morphisms of pulled-back objects descend and are
equivalences downstairs iff upstairs — are correct. It is also correct that Woodward's equations
(54) and (57) take the fibre products over the *rigidified* inertia stack, which is why the descent
step is needed at all. Supported.

**Woodward II Proposition 5.21(a) and III Proposition 7.14(b).** 5.21(a) is exactly the
identification of $M^G_{n,\Gamma}(C,X)$ with $M^G_{n,\Gamma'}(C,X)\times_{(X/G)^2}(X/G)$ over the
diagonal, and III's proof of 7.14(b) cites it for that. Definition 7.13(a) states the complex
$(Rp_*e^*T(X/G))^\vee$ absolutely; Section 8.3 states the relative form over the twisted domain
stack for scaled gauged maps; II Example 6.6(c) states it for affine gauged maps. The appendix's
three-way description of where Woodward's index complex lives is accurate in all three places, and
`conv:app-obstruction-morphism`'s claim that Definition 7.13 fixes a complex and not a morphism is
correct on inspection.

**Włodarczyk Proposition 2(B') and Definition 5.** Definition 5 reads "A cobordism $B$ is projective
if $B$ is a quasiprojective variety", so the manuscript's terminology paragraph is exact.
Proposition 2(B') gives a smooth projective cobordism between birationally equivalent smooth
projective varieties in characteristic zero; its proof takes $\overline L(X,D;X',0)$, a
$K^*$-equivariant projective completion of $L(X,D;X',0)$, and then its canonical $K^*$-equivariant
resolution $\overline B$. Since $L(X,D;X',D')=\mathcal O_X(-D)\cup_{V\times K^*}\mathcal O_{X'}(D')_\infty$,
the manuscript's "the equivariant projective completion of the glued double line-bundle space,
followed by its canonical equivariant resolution" is exactly the construction; $L$ is smooth because
it is glued from two line bundles over smooth varieties, so a functorial resolution is an isomorphism
over it. $B_+=\mathcal O_{X'}(D')_\infty\setminus S_\infty$ and $B_-=\mathcal O_X(-D)\setminus S_0$
with $B_\pm/K^*\simeq X',X$ are the "punctured line-bundle opens with the two endpoint varieties as
geometric quotients", and $V\times K^*$ is literally the trivialized cylinder over the common open.
The manuscript is right that a canonical resolution being an isomorphism over the smooth locus is a
standard property and not part of the cited proposition, and right that the cited theorem does not
verify conditions (i)–(iii). Supported throughout.

### Registers and self-description

`08-scope.tex` item (5) lists: every condition of `def:gauged-admissible`; the Włodarczyk boundary;
bistability of the cylinder orbit, stated in the precise form used in the body ("the identification
of the extreme quotients … restricts over the common birational open to the cobordism quotients");
the virtual Kalkman identity with its endpoint normalization under (ii) and the unexhibited
master-space normal complex; and the graph-space normalization input to `lem:point-insertion-row`.
Going back through the proof of `prop:support-collapse` step by step, I did not find an input it
uses that item (5) fails to register. The two places where an input could have slipped through are
both covered: the invertibility of the virtual normal Euler class is attributed in
`prop:gamma-ratio-reduction` to (ii) on the ground that virtual localization inverts that class,
which is a fair reading of (ii)'s "the localized large-area formula applies coefficientwise"; and
the simultaneous use of the rotation circle and the polarization circle falls under the same clause,
which explicitly extends to "the virtual Kalkman identity for the polarization sweep". The proof also
takes care to separate the two circles notationally ($\zeta$ vs $\mathsf w$) and to say that
González–Woodward use the opposite convention.

The appendix opening and `rem:app-imports` agree with each other and with the body: one comparison
(the mapping-stack cotangent formula) is precedent rather than proof, with its properness hypothesis
explicitly not invoked because the equivariant relative form is read off from
`def:app-fixed-section` and perfectness is proved in `lem:app-cech`; the Behrend–Fantechi realization
step is used rather than reproved and is said so; Schürg–Toën–Vezzosi is precedent for the mechanism
and not a general recognition theorem; and the recognition of Definition 7.13 inside the truncation
is explicitly *not* imported but fixed by convention and compared in `lem:app-truncation`. The
closing sentence — "no derived statement is used at any point where a virtual class or a localization
contribution is finally evaluated" — is consistent with `prop:app-square`, which returns everything
to classical truncations. The only friction I found between the body's self-description and the
appendix's is O1.

The introduction paragraph at lines 110–118 describes the argument accurately: the orbit cylinder,
the Kirwan restrictions, the vanishing on interpolated-semistable fixed strata, the placement at the
output evaluation, and the separate role of rotation localization ("it produces the graph factor and
the degree extraction that isolates it"). Everything it asserts is under the hypothesis of
`thm:intro-birational-conditional`, which quantifies over gauged-admissible cobordisms, and
bistability sits inside `def:gauged-admissible`(iv), so the paragraph is not overclaiming by omitting
it. `rem:endpoint-only`'s insistence that the universal quantifier over maps cannot be dropped is
logically necessary and correctly argued.

## Coverage

What this pass did **not** reach:

- `sections/08-global-transport.tex` from line 917 to the end (1374 lines total). That includes
  `def:finite-dual-cyclic-rees`, `hyp:marked-threshold-wall`, `def:reduced-nearby`,
  `hyp:marked-threshold-zero`, `lem:cyclic-row-support`, `thm:birational-point-primary`,
  `rem:verification-status` and `conj:gamma-window`. I read `rem:two-tail-threshold-obstruction`
  (lines 918–936) and verified its example because it is the stated justification for the threshold
  hypotheses, but I did not audit the hypotheses themselves, the Rees–Stokes saturation definition,
  the nearby/vanishing-cycle conventions, or the direction of the `var` convention.
- Sections 03–07 and 09, and `08-scope.tex` items (1)–(4) and (8), beyond the consistency reading of
  items (6)–(7) noted above.
- `sections/01-introduction.tex` outside lines 95–165.
- Behrend–Fantechi §4, Graber–Pandharipande, Toën–Vezzosi HAG II, Schürg–Toën–Vezzosi, and
  Mumford–Fogarty–Kirwan GIT Chapter 2 §2.1 Theorem 2.1 are **UNVERIFIED** at the level of the
  locator: they are not in the shared cache and I did not fetch them. Each is used for a statement I
  recognize as standard and stated in the right direction (BF §4 for the passage between the
  deformation-theoretic obstruction theory and a morphism to the cotangent complex, realized after
  passing to a smooth cover; GP for the fixed part of an ambient relative POT being a relative POT
  on the fixed locus; HAG II for the mapping-stack cotangent formula whose properness hypothesis the
  manuscript explicitly declines to invoke; STV as precedent; GIT for the numerical criterion, which
  the manuscript in any case rederives from scratch for $\Gm$ and which I verified independently).
  Verifying them would take fetching the five sources and matching the section and theorem numbers.
- I did **not** independently verify that the two circle actions (domain rotation and the VGIT
  master-space circle) admit a joint fixed-point analysis of the shape the proof of
  `prop:support-collapse` uses. The manuscript registers this under
  `def:gauged-admissible`(ii) rather than proving it, and I judged the register adequate, but no
  cited theorem in González–Woodward or Woodward III states the combined case, and I did not
  attempt to construct it. Verifying it would mean building the joint fixed-locus decomposition of
  the rotation-and-polarization master stack.
- The published (Journal of Algebraic Geometry) versions of González–Woodward and Włodarczyk were
  not consulted; all locators were matched against the arXiv preprints. See O6.

Nothing was left in progress at the point I stopped: R1 is fully worked out with an explicit
counterexample and an explicit repair, and every optional item O1–O8 was established rather than
suspected. No finding in this report is provisional.

The counts below are over what this pass actually reached, as delimited above.
