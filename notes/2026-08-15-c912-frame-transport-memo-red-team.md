# Red team of the frame-transport memo (2026-08-15-c912-frame-transport-memo.tex)

**Lane:** `clebsch` · **Task:** C912 · **Date:** 2026-08-15

Target: `notes/2026-08-15-c912-frame-transport-memo.tex`.
Checked against `papers/cubic-stabilization-m1/sections/04-one-step.tex`,
`papers/cubic-stabilization-m1/irrationality_after_one_stabilization.aux`,
`papers/cubic-stabilization-m1/lean/verification/check_formal_artifact.py`,
`.../lean/verification/claims.json`, `.../lean/README.md`, `.../verification/README.md`.
Read-only; nothing under `papers/` was touched.

Headline: the memo's Section 2 is a correct theory of a solution algebra whose
exponential symbols carry **constant** coefficients, and its Section 3 is about the regime
where they carry **Novikov** coefficients. In that regime the Section 2 algebra is not
merely unavailable — its Constants Lemma is **false**, with an explicit counterexample
(§3 below). Separately, the memo's two positive claims — scale invariance of the criterion
and its validity at the cubic endpoint — are refuted as stated by the draft's own weight
normalisation.

---

## 1. The solution algebra $\mathcal U_e$ — PLAUSIBLE (claim right, proof wrong; definition too narrow)

**Freeness.** The stated proof is wrong. It says "the $w^\rho$ generate the group algebra of
$\Omega_V/\mathbf Z$ over $\mathcal H_e$ … both groups are torsion-free". $\Omega_V/\mathbf Z$
is *not* torsion-free: it contains $\mathbf Q/\mathbf Z$, which is all torsion. Since the
rational residue exponents are exactly the ones $\nu_6$ counts, this is not a harmless slip
in the surrounding context.

The conclusion nevertheless holds, by a different argument the memo should substitute:
$\mathcal H_e[\Omega_V]$ is free over $\mathcal H_e[\mathbf Z]=\mathcal H_e[t,t^{-1}]$ on any
set $\Lambda$ of coset representatives, and $\mathcal U_e$ is its base change along
$\mathcal H_e[t,t^{-1}]\to\mathcal H_e$, $t\mapsto w$ (a surjection with kernel $(t-w)$, $w$
a unit). Base change of a free module is free on the same basis, so $\mathcal U_e$ is free on
$\Lambda$, hence nonzero, and $\mathcal H\subset\mathcal U_e$. The relations are consistent
(the crossed-product multiplication $w^\rho w^{\rho'}=w^n w^{\rho''}$ is well defined), the
derivation is consistent with the integer identification ($w^n$ sits at $e_z$-exponent $n/e$
and $\theta_w=e\theta$ multiplies it by $n$), and $E(\varphi)$, $\ell$ contribute a
torsion-free group algebra and a polynomial variable respectively. Not circular.

**The real defect is the range of $\varphi$.** The memo takes
$\varphi\in w^{-1}\Omega_V[w^{-1}]$, i.e. exponential factors with coefficients in the
*constant* field $\Omega_V$. A module over $\mathcal H$ with $\Gamma\neq0$ has exponential
factors with coefficients in (the algebraic closure of) $\mathcal C=\Omega_V(\!(\Gamma)\!)$ —
the cubic's own factors $e^{\mp 6r/z}$, $r=(3q)^{1/2}$, are of exactly this kind. So
$\mathcal U_e$ as defined cannot host the solutions of the modules the memo wants to
transport. Widening the range is not a cosmetic repair: see §3.

**Also wrong as written: $\rho\in\Omega_V$.** $\operatorname{Exp}_V$ is defined in (4.0) only
on $(K,+)$, where $K=\mathbf C\oplus V$ and $\Omega_V$ is an algebraic closure of
$\operatorname{Frac}K[V]$, strictly larger than $K$. The memo adjoins $w^\rho$ for all
$\rho\in\Omega_V$ and then sets $\sigma(w^\rho)=\operatorname{Exp}_V(\rho/e)w^\rho$, which is
undefined for $\rho\in\Omega_V\setminus K$. Either restrict $\rho$ to $K$ (and then say why the
residues of a module over $\mathcal H$ land in $K$ — they do not, once $\Gamma\ne0$), or rebuild
$\operatorname{Exp}$ over $\overline{\mathcal C}$, which reintroduces the coefficient
duplication the memo objects to in §3.

## 2. The turn $\sigma$ — CONFIRMED on the algebra as defined (two proof errors, one convention gap)

Verified:

- The action on $\mathcal H_e$ is multiplication of the coefficient at $(\gamma,j/e)$ by the
  character $\chi(\gamma,j/e)=e^{2\pi ij/e}$ of the value group. A character-twist of a Hahn
  field is a ring automorphism (additive, multiplicative because $\chi$ is a homomorphism,
  bijective, support-preserving so well-ordering is untouched).
- Identity on $\mathcal H$: there $j\in e\mathbf Z$, so $\chi=1$. Hence identity on $\mathcal C$.
- Consistency with the integer case: $w^n$ has $e_z$-exponent $n/e$, and
  $\operatorname{Exp}_V(n/e)=e^{2\pi in/e}$ because $n/e\in\mathbf Q\subset\mathbf C$ has zero
  $V$-component. Multiplicativity in $\rho$ is exactly the homomorphism property of
  $\operatorname{Exp}_V$ on $(K,+)$ — which is why the domain error in §1 matters here.
- Commutation with $\theta_w$: holds, but **not for the stated reason**. The memo says "both
  $\sigma$ and $\theta_w$ are diagonal in the basis"; $\sigma(\ell)=\ell+2\pi i/e$ and
  $\theta_w(\ell^m)=m\ell^{m-1}$ are neither diagonal. The check is direct:
  $\sigma\theta_w(\ell^m)=m(\ell+\tfrac{2\pi i}{e})^{m-1}=\theta_w\sigma(\ell^m)$.
- $\sigma^e$ on a regular-singular block: $\sigma^e(w^{R_s})=\operatorname{Exp}_V(R_s)w^{R_s}$
  and $\sigma^e(e^{R_n\ell})=e^{R_n\ell}\exp(2\pi iR_n)$, giving $M_{\mathrm{RS},V}$ as in the
  draft. $\sigma$ permutes the $E(\varphi)$-blocks, which is the draft's descent action, so
  (4.0b)–(4.0c) are compatible.

Two things to fix. First, the memo does not say whether $R$ is the residue for $\theta$ or for
$\theta_w=e\theta$; the two differ by a factor $e$ and the identification with the draft's
$M_{\mathrm{RS},V}$ depends on the choice. State it. Second, the memo asserts "the last
sentence is the definition: the draft's operator is by construction the action of the lifted
turn on the Levelt–Turrittin solution basis". It is not a definition — the draft computes the
framed characteristic polynomial through the cyclic-block determinant (4.0b)
$\chi(X)=\det(X^dI-U)$. Matching $Y^{-1}\sigma(Y)$ to that needs one line, and the memo should
supply it rather than call it definitional.

## 3. The Constants Lemma — CONFIRMED as stated, **REFUTED** for the intended range of $\varphi$

As stated (with $\varphi\in w^{-1}\Omega_V[w^{-1}]$) the proof survives every attack I made:

- $v$ is additive because the coefficient field is a field; $\theta_w$ multiplies coefficients
  by integers and therefore never enlarges a support, so $v(\theta_wc)\ge v(c)$ (and $=\infty$
  if it kills $c$) — correct.
- Exponential blocks: every monomial of $\theta_w\varphi$ has $\Gamma$-part $0$ and strictly
  negative $e_z$-part, so $v(\theta_w\varphi)<0$ and
  $v(\theta_w(\varphi)c)<v(c)\le v(\theta_w c+\rho c)$ — the lowest term genuinely cannot
  cancel. Correct.
- The $\ell$-degree descent, the step $\theta_w(c)+\rho c=0\Rightarrow c=0$ for $\rho\notin
  \mathbf Z$ (each monomial gives $(j+\rho)c=0$ with $j\in\mathbf Z$), the $\rho=0$ argument
  comparing $e_z$-degree-zero components, and the identification of $\mathcal H_e^{\theta_w=0}$
  with $\mathcal C$ are all correct. Minor: the $\varphi=0,\rho\ne0$ case needs the same
  descending induction on $m$ that the $\varphi\ne0$ case gets explicitly; as written it quotes
  only the homogeneous equation.

**The gap when $\Gamma$ is nontrivial is fatal, not repairable.** Take $\gamma\in\Gamma$,
$\gamma>0$, and $\varphi=x^\gamma w^{-1}$ — the shape of every actual quantum exponential
factor, since $\lambda\sim q^{1/2}$ has positive Novikov weight. Then
$v(\theta_w\varphi)=(\gamma,-1/e)>0$ in the coefficient-dominant order, so the memo's
domination argument reverses. Worse, solve $\theta_w(c)=\theta_w(\varphi)c$ directly:
$$c=\sum_{n\ge0}\frac{(-1)^n}{n!}\,x^{n\gamma}w^{-n},$$
whose support $\{(n\gamma,-n/e)\}_{n\ge0}$ is increasing, hence well ordered, hence
$c\in\mathcal H_e$. So $cE(\varphi)$ is a nonzero $\theta_w$-constant outside $\mathcal C$:
**the Constants Lemma is false** once $\varphi$ is allowed Novikov coefficients of positive
weight. Equivalently, $\exp(-\lambda/z)$ with $w(\lambda)>0$ is *already an element of the
draft's coefficient-dominant Hahn field*; adjoining $E(\varphi)$ as a free symbol duplicates an
existing element and inflates the constants. Since Proposition "framed operator is the matrix
of the turn" rests entirely on the Constants Lemma, that proposition fails in the same regime.

Corollary worth putting in the memo: over the draft's order the exponential factors are units,
not symbols, and the entire irregularity cost sits in the Gevrey-divergent unit part
$u(z)$ of the formal solution — which is where §3's rate argument actually lives.

## 4. Characterisation and transport theorem — algebra CONFIRMED (one wrong formula, one wrong sentence); **hypothesis vacuous in the application**

Algebra checks:

- $\theta(Y^{-1})=Y^{-1}\Omega$ and $\theta(Y^{-1}v)=Y^{-1}(\theta v+\Omega v)$: correct.
- Gauge convention: with $\Omega'=G\Omega G^{-1}-\theta(G)G^{-1}$ one gets
  $\theta(GY)=\theta(G)Y-G\Omega Y=-\Omega'(GY)$. Correct, and it is the convention consistent
  with the draft's (4.1c) $M^{\rm bulk}=GM^{\rm small,shifted}G^{-1}$.
- $\sigma(GY)=G\sigma(Y)=GYM$: correct, given $\sigma(G)=G$.
- Frame change $Y'=(GY)C_0$, $M'=C_0^{-1}MC_0$: correct.
- **Wrong formula.** "it is invertible with inverse $Y^{-1}\sigma(Y^{-1})^{-1}$" — that
  expression *is* $M$, since $\sigma(Y^{-1})^{-1}=\sigma(Y)$. The inverse is
  $\sigma(Y^{-1})Y$. Simpler: $M=Y^{-1}\sigma(Y)$ is a product of invertibles.
- **Wrong sentence.** The theorem's last clause reads $\sigma(GY)=(GY)M$ "in the transported
  frame $GY$, whose matrix in the original frame of $D'$ is $GMG^{-1}$". The original frame of
  $D'$ is $Y'$, which differs from $GY$ by $C_0\in\mathrm{GL}_n(\mathcal C)$, not by $G$; the
  matrix there is $C_0^{-1}MC_0$. $GMG^{-1}$ arises only if $M$ is regarded as a matrix
  attached to a *module* frame rather than to the solution frame. That is precisely the
  conflation the memo accuses the draft of committing at (4.1c), so the memo must say which of
  the two objects it means, in both places.

**The hypothesis. This is the most important finding of the review.** The theorem assumes each
module has a fundamental solution matrix over $\mathcal U_e$, and the memo supplies one only by
citing Levelt–Turrittin "for every module over $\Omega_V(\!(z)\!)$", i.e. only when $\Gamma=0$.
The two hypotheses are jointly unsatisfiable in the application:

- If $\Gamma=0$ then $\mathcal H=\Omega_V(\!(z)\!)$, solutions exist — but the pro-Laurent
  comparison gauge has unbounded negative $z$-order and is **not** in $\mathrm{GL}_n(\mathcal H)$,
  so the theorem does not apply.
- If $\Gamma\ne0$ with the $e_z$-coordinate ordered last (the draft's order, line 557 of the
  section), the gauge is in $\mathcal H$ — but $\mathcal H$ is *not* a formal Laurent series
  field over its constants ($\mathcal C(\!(z)\!)\not\subset\mathcal H$ and
  $\mathcal H\not\subset\mathcal C(\!(z)\!)$), and Levelt–Turrittin is unavailable. Concretely,
  the $e_z$-component of the Hahn valuation is *not* a valuation on $\mathcal H$: with
  $f=x^{(0,0)}+x^{(1,-100)}$ and $g=-x^{(0,0)}$ one has $\pi_{e_z}v(f)=\pi_{e_z}v(g)=0$ but
  $\pi_{e_z}v(f+g)=-100$. No Newton polygon, no slope filtration, no Turrittin algorithm.
  Nor is there a convenient classical subfield to descend to: the two-term element
  $f=1-zx^{-\gamma}$ has inverse $-\sum_{k\ge1}z^{-k}x^{k\gamma}$, so the bounded-$z$-order
  elements of $\mathcal H$ do not form a field.

So in the intended application the theorem is a true statement with no verified instances. The
memo must say this plainly in Section 2, not only obliquely in Section 3. Note also that an
abstract Picard–Vessiot ring for any module over $\mathcal H$ does exist (constants
$\Omega_V(\!(\Gamma)\!)$, algebraically closed after passing to the divisible hull), so the
missing ingredient is *not* a solution algebra: it is a canonical Levelt–Turrittin normal form
singling out which element of the differential Galois group is "the turn". Framing the gap that
way makes route 2 of the memo's Section 4 the natural successor, and shows why route 2 cannot
be a pure valuation argument (see above).

## 5. The two rates

**(a) Pro-Laurent gain — CONFIRMED.** Recursion (4.1a)
$(\alpha_i+1)G_{\alpha+e_i}=-z^{-1}[(\phi_i\star_\eta)G]_\alpha$ with $\alpha_i+1$ invertible
over $\mathbf C$; the draft's own conclusion is that $G_\alpha$ has no power of $z$ below
$-|\alpha|$ and that a term of total bulk degree $m$ lies in $F^mB$. Every monomial of $J_j^N$
has weight $\ge N$, so the $z^{-k}$ coefficient has coefficient-weight $\ge k$ and the weight of
that monomial is $\ge k(a-b)$. Sufficiency for well-ordering is right; the memo's "exactly when
$a>b$" claims a necessity it never proves, and it silently assumes a weight bound going to
$+\infty$ implies well-ordered support (true here only because of the draft's separate
finite-below argument, which the memo should cite).

**(b) Splitting loss — CONFIRMED for the unramified case, incomplete otherwise.** The
per-order Sylvester equation is exactly the draft's own construction (4.9d): "at order $n$ the
block-off-diagonal coefficient is removed by a Sylvester equation $[K_0,A_n]=B_n$", with $K_0$
the leading matrix, so one division by eigenvalue differences per order, and the accumulated
cost is $w(A_n)\ge -n\,w(\Delta\lambda)$. The draft's displayed $E_0$ entry $-14/(81r^2)$ at
$z$-order $2$ confirms the rate numerically: one factor of $r^{-1}$, i.e. one
$w(\Delta\lambda)=w(r)$, per unit of $z$-power. Three gaps:

1. **Ramification does cost more.** After $z=w^e$ the divisions happen once per $w$-order,
   i.e. $e$ times per unit of $z$-power, while the pro-Laurent gain is still one filtration
   unit per unit of $z$-pole. The criterion in the ramified case is $e\,w(\Delta\lambda)<
   \varepsilon$. The memo should either add the hypothesis "no $z$-ramification" (satisfied at
   the cubic, where the draft proves the exponential blocks are unramified in $z$) or carry
   the factor $e$.
2. **The regular-singular claim is unproved.** "Residue differences offset by integers … are
   nonzero constants and cost nothing" is verified only in the cubic block, where
   $\det L_s=(s+1/6)(s+5/6)$ is constant. In general it needs the homogeneity argument
   (residue eigenvalues are rational because the connection is graded); state it.
3. **$w(\Delta\lambda)$ is not determined by $w(\lambda)$ when $\rho(C)>1$.** Two eigenvalues
   that are homogeneous of the same quantum degree can have leading terms that cancel in $w$,
   because $w$ and the quantum grading are different functionals on the exponent lattice.
   Then $w(\Delta\lambda)\gg w(\lambda)$ and the Fano-index reading of §6 does not apply. The
   memo hedges once ("when the relevant eigenvalue is a root of a monomial") and then argues
   as if the hedge were general.

**(c) Scale invariance — REFUTED.** The claim is that rescaling $w$ moves both rates by the
same factor, "so the choice of the integer $L$ … is not a free parameter here". The first half
is true and irrelevant; the second half is false. $L$ is not a global rescaling. The draft
fixes $w(u)=1$ and $w(s_{j,\ell})=1$ *independently of $L$* (line 453) and sets
$w(Q^{i_*d}u^{\rho_C\cdot d})=L(H\cdot i_*d)+\rho_C\cdot d$ (line 450). Hence
$\varepsilon=\min$ generator weight $=w(u)=1$ always, while the weight of the Novikov generator
whose root gives $\Delta\lambda$ grows linearly in $L$. The ratio $w(\Delta\lambda)/\varepsilon$
is therefore $L$-dependent, and the draft's instruction "choose an integer $L$ so large that …"
drives it up. Consequences:

- With the draft's $L$, the criterion fails at essentially *every* comparison that has two
  distinct exponential factors, including the cubic endpoint — not just at index one.
- With the minimal admissible $L$ it can hold: for $\mathbf P_X(V)$ with $c_1(V)\cdot\ell=0$
  one may take $L=1$, giving $w(Q^\ell)=1=\varepsilon$ and
  $w(\Delta\lambda)=w(q^{1/2})=1/2<\varepsilon$.

So tuning $L$ is the cheapest available repair and the memo tells the author the opposite. The
part that survives every normalisation is the necessary condition: $w(Q^{d_0})\ge\varepsilon$
holds for any admissible weight, so $c_1\cdot d_0\ge2$ is necessary regardless of $L$.

## 6. The Fano-index reading — grading CONFIRMED, first consequence REFUTED as stated, second CONFIRMED

**Grading.** No factor-of-two error. The draft's own low-dimensional vanishing proof records
that the $Q^\beta$-component of $c_1\star$ maps $H^i\to H^{i+2-2c_1\cdot\beta}$; assigning
$Q^d$ the degree $c_1\cdot d$ and cohomology its complex degree makes $c_1\star$ homogeneous of
degree one, exactly as the memo says. Cross-checked on the draft's explicit cubic block:
$K_X=c_1\star=2P\star$ (its first column is $2P$), $K_0$ has eigenvalues $\pm6r,0,0$ with
$r=(3q)^{1/2}$, and $c_1\cdot\ell=2$ with $P\cdot\ell=1$, so $\lambda=6\sqrt{3q}$ has degree
$2/2=1$. Using real degrees throughout ($\deg Q^d=2c_1\cdot d$, eigenvalues of degree $2$)
leaves the ratio $\deg\lambda/\deg Q^{d_0}=1/(c_1\cdot d_0)$ unchanged, so the threshold does
not move.

**"It holds at the cubic endpoint with weight one half" — REFUTED as stated.** The computation
$w(\Delta\lambda)=\varepsilon/2$ is correct only if $\varepsilon$ is read as $w(q)$, i.e. in the
intrinsic endpoint normalisation where $q$ is the lightest generator. In the receiver the
criterion is actually stated over, $\varepsilon=w(u)=1$ and $w(q\text{-image})=L(H\cdot\ell)+
\dots$, so the memo compares two different normalisations. Corrected statement: the criterion
at the cubic endpoint is $L(H\cdot i_*d_0)+\rho_C\cdot d_0<c_1\cdot d_0$, which holds for the
minimal admissible $L$ and fails for large $L$.

**"It fails as soon as $c_1\cdot d_0=1$" — CONFIRMED**, and it is the robust half. The
separation argument forces $w\ge\varepsilon$ on every generator of $J_j$, and $Q^{d_0}$'s image
is a generator, so $w(Q^{d_0})<\varepsilon\cdot 1$ is unsatisfiable under any admissible weight.
The regular-singular bullet ($C=0$, no divisions) is correct.

The summary sentence "the gap is confined to centers whose small even connection has at least
two distinct exponential factors separated by an eigenvalue difference of low fractional index"
is too optimistic on two counts: the $L$-dependence above, and item 5(b)(3) — with Picard rank
greater than one the index does not control $w(\Delta\lambda)$.

## 7. The three reasons the receiver cannot host the lemma

**Finite tensors — REFUTED.** Two errors. (i) The pro-Laurent bulk gauge needs no infinite
tensor at all: its coefficients lie in the completed monoid ring, which the draft embeds into
$H_{0,j}$, so the whole gauge lies in the single factor $H_{{\rm tot},j}=
\mathbf C(\!(\Gamma^{\rm coeff}_j\oplus\mathbf Z e_z)\!)$ and $G\otimes1\in\mathscr R_j$. (ii)
For the Levelt–Turrittin *splitting* gauge, the coefficients $P_k$ all lie in one **finite**
extension of $H_{0,j}$ — the splitting field of the characteristic polynomial of the leading
matrix together with finitely many residue exponents — so their $H_{0,j}$-span is
finite-dimensional and the series is a finite tensor $\sum_ib_i\otimes h_i$ *provided* each
$h_i$ has admissible support. The obstruction is therefore entirely the support condition, i.e.
reason three; reason one adds nothing and should be deleted. The trailing claim "adjoining
formal symbols to $\mathscr R_j$ does not add it" is asserted without argument.

**The multiplication map is not well defined — CONFIRMED.** In
$\Omega_{V,j}(\!(\Gamma^{\rm coeff}_j\oplus\mathbf Z e_z)\!)$ the copy of $H_{0,j}$ coming from
$\Omega_{V,j}$ consists of degree-zero *constants*, while the copy coming from
$H_{{\rm tot},j}$ consists of *monomial series* $\sum c_\gamma x^\gamma$. They are different
elements, so $ah_0\otimes h\mapsto a\iota_\Omega(h_0)h$ and $a\otimes h_0h\mapsto
a\iota_H(h_0)h$ disagree. Correct as stated.

But the conclusion "the tensor product cannot be dissolved by hand" is too strong, and the memo
misses the enlargement: **do not build $\mathscr R_j$ at all.** Extend the $\Gamma$-valuation of
$H_{0,j}$ to $\overline{H_{0,j}}$ and then to $\Omega_{V,j}$, and take the field of $z$-series
$\sum_kc_kz^k$ with $c_k\in\Omega_{V,j}$ whose support $\{(v_\Omega(c_k),k)\}$ is well ordered
in the chosen (possibly mixed) order. This has one copy of the coefficients, is a field (which
also removes the non-domain worry the memo raises only in route 2 — $\mathscr R_j$ is a tensor
product of two fields and its use as the coefficient ring for characteristic polynomials and
algebraic multiplicities deserves an explicit remark), hosts the pro-Laurent gauge, and hosts
the exponential factors as honest units. It does **not** remove the rate criterion, and it does
not by itself supply Levelt–Turrittin — but it is a strictly better receiver than (4.4c) and
the memo should propose it in place of the "obvious enlargement" it refutes.

I also considered, and reject, the reading that lets the two copies do different jobs (module
coefficients as constants in $\Omega_{V,j}$, gauge bookkeeping as $\Gamma$-monomials). The
gauge relation $\Omega'=G\Omega G^{-1}-\theta(G)G^{-1}$ ties $G$ and $\Omega$ through the same
Novikov variables, so a single copy is forced; with the constants reading the gauge leaves the
field, with the monomial reading the exponential factors become $\Gamma$-supported and §3's
counterexample applies. That is the honest justification of the memo's paragraph and it should
replace the current one.

**No single Hahn field holds both families — CONFIRMED, and stronger than the memo argues.**
The description "a formal solution whose coefficient degrees run to $-\infty$ at fixed
$z$-power" is wrong; the correct statement is that they run to $-\infty$ *as the $z$-power
grows*, at rate $w(\Delta\lambda)$. With that correction both verdicts and the swap are right.
The stronger form: the two support families point in the directions $(+1,-1)$ and $(-C,+1)$,
whose sum is $(1-C,0)$, so the cone they generate is salient — and any additive order at all
admits both — precisely when $C<1$. Better still, the criterion is not about orders at all.
The $z^n$-coefficient of $GP$ is $\sum_mg_mp_{n+m}$, whose terms have weight
$\ge m(1-C)-nC$; for $C\ge1$ infinitely many terms have bounded weight, so the coefficient is
undefined in *any* completion, ordered or not. That answers the memo's own Question 1
negatively and Question 4 affirmatively (the criterion is structural, not an artifact of
proving transport through an ordered receiver), and the memo should say so instead of leaving
them open.

## 8. The levelwise route — CONFIRMED (with one correction)

$\Delta\lambda$ is a fractional power of an image Novikov monomial, so strictly it is not an
element of $J_j$; some power of it is, which is enough — it is topologically nilpotent in every
$B_j/F^NB_j$, hence not invertible, hence the splitting cannot be performed levelwise. The
second reason is also right and matches the draft, which repeatedly insists that no framed
operator is placed over a nonfield quotient (Definition 4.2 and the proof of Lemma 4.5). Fix
the wording from "lies in $J_j$" to "has a power in $J_j$, hence is topologically nilpotent at
every finite level".

## 9. Placement advice — page numbers and gate claim CONFIRMED; renumbering hazard missed

All statement numbers and page numbers check out against the current `.aux`: Definition 4.1
p.15, Definition 4.2 p.15, Lemma 4.3 p.16, Remark 4.4 p.16, Lemma 4.5 p.16, Proposition 4.7
p.18, Section 4 begins p.14. The two quoted sentences from Lemma 4.3 and its proof, the
display (4.1c), and the sentence "each center target summand has the framed monodromy of its
specialized small connection" are verbatim. "Apply Levelt–Turrittin after a ramification
$z=w^e$" is early in the section (p.14) and "The frame matters" sits immediately before
Definition 4.2 (p.15), so both placement anchors are correct.

The gate claim is correct in every detail. `check_formal_artifact.py` requires exactly one
`(thm|prop|lem|cor|def):` label per `theorem/proposition/lemma/corollary/definition`
environment in `sections/*.tex`, requires the set of claim-map `manuscript_label` values to
equal the set of manuscript labels, requires nonempty `objects`/`hypotheses`/`conclusion`/
`cautions` and a `declarations` list (empty exactly when coverage is `absent`), and requires
the generated "Checked coverage snapshot: N claims; …" string to appear in both
`lean/README.md` and `verification/README.md`. Both currently read "26 claims; 3 absent; 13
fragmentary; 9 conditional", and `claims.json` has 26 rows, so adding one theorem-like
environment forces edits to `claims.json` and to both READMEs. `lem:frame-transport` is a valid
label form.

Two things the placement section gets wrong. First, its own plan breaks the numbering it uses:
inserting the ground field, solution algebra, Constants Lemma and characterisation proposition
before and after Definition 4.1 renumbers every later statement, so "Lemma 4.3", "Lemma 4.5"
and "Proposition 4.7" in the memo will no longer name the right objects (equation tags are
manual `\tag`s and are safe). Say the edits by label, not by number. Second, items 4 and 5 tell
the author to replace Lemma 4.3's asserted clause by a reference to the new lemma — but Lemma
4.3 lives over the pro-Laurent receiver, where §3 argues the new lemma does not apply. The
"If the mathematics is settled" hedge at the top of the section is not enough; the placement
list should be explicitly conditional on the receiver repair.

Beyond the memo's scope, worth telling the author: the identical obstruction hits Lemma 4.9
(divisor tagging, p.23), which embeds "the gauge of Lemma 4.5, whose negative $z$-order is
unbounded" and "every transported operator" into one ordered Hahn field. Whatever repair the
receiver gets, that lemma needs the same treatment.

---

## What must change before the memo is sent, in priority order

1. **State the scissors in Section 2, not Section 3.** The transport theorem's two hypotheses —
   $G\in\mathrm{GL}_n(\mathcal H)$ and a fundamental matrix over $\mathcal U_e$ — are jointly
   unsatisfiable in the application: $\Gamma=0$ loses the gauge, $\Gamma\ne0$ loses
   Levelt–Turrittin because the $e_z$-component of the Hahn valuation is not a valuation
   (explicit counterexample in §4 above) and the bounded-$z$-order subring is not a field. As it
   stands the memo proves a theorem with no verified instances and says so only obliquely.
2. **Withdraw or restrict the Constants Lemma.** With $\varphi$ ranging over Novikov-coefficient
   exponential factors — the only case that matters — it is false:
   $c=\sum_n\frac{(-1)^n}{n!}x^{n\gamma}w^{-n}\in\mathcal H_e$ satisfies
   $\theta_w(c)+\theta_w(\varphi)c=0$ for $\varphi=x^\gamma w^{-1}$, $\gamma>0$, so $cE(\varphi)$
   is a constant outside $\mathcal C$. Equivalently $e^{-\lambda/z}$ is already a unit of the
   draft's Hahn field. Add the hypothesis explicitly and say what breaks without it.
3. **Delete the scale-invariance paragraph and rewrite the criterion as $L$-dependent.** The
   draft pins $w(u)=w(s_{j,\ell})=1$ regardless of $L$, so $\varepsilon=1$ while the Novikov
   generators' weights grow linearly in $L$. The criterion is
   $L(H\cdot i_*d_0)+\rho_C\cdot d_0<c_1\cdot d_0$. With the draft's "choose $L$ so large" it
   fails everywhere, including the cubic endpoint; with the minimal admissible $L$ it holds at
   the cubic endpoint. Tuning $L$ is the cheapest repair available and the memo currently
   forecloses it. Keep the $L$-independent core: $c_1\cdot d_0\ge2$ is necessary.
4. **Fix the cubic-endpoint bullet's normalisation.** As written it computes $\varepsilon$ as
   $w(q)$ and the criterion with $\varepsilon=w(u)$; state one normalisation and recompute.
5. **Replace the finite-tensor objection.** It is false for the pro-Laurent gauge (which lives
   in $H_{{\rm tot},j}$ alone) and false for the splitting gauge (whose coefficients lie in one
   finite extension of $H_{0,j}$). Replace it with the correct reason the tensor product cannot
   be dissolved: the gauge relation ties $G$ and $\Omega$ through one copy of the Novikov
   coefficients.
6. **Add the missed receiver.** $z$-series over $\Omega_{V,j}$ with a well-ordered
   $(v_\Omega(c_k),k)$ support — one copy of the coefficients, a field rather than a tensor
   product of two fields, hosts the gauge and the exponentials. Note in passing that
   $\mathscr R_j$ is not a domain and that reading algebraic multiplicities in $\mathscr R_j[X]$
   needs a remark.
7. **Upgrade Section 3's third reason.** The obstruction is not about well-ordering: for
   $C\ge1$ the $z^n$-coefficient of the single product $GP$ is an infinite sum of terms of
   bounded weight, undefined in any completion. This settles the memo's own Questions 1 and 4
   and should replace them.
8. **Repair the proofs whose conclusions survive:** the freeness argument (use base change along
   $\mathcal H_e[t,t^{-1}]\to\mathcal H_e$; $\Omega_V/\mathbf Z$ has torsion), the
   $\sigma$–$\theta_w$ commutation (not diagonal in $\ell$), the inverse of $M$ (it is
   $\sigma(Y^{-1})Y$), the range of $\rho$ (in $K$, not $\Omega_V$, or extend
   $\operatorname{Exp}$), the $\theta$-versus-$\theta_w$ residue convention, and the
   $\varphi=0,\rho\ne0$ descending induction.
9. **Fix the theorem's last sentence.** $GMG^{-1}$ is not the matrix of the turn in any solution
   frame; say whether $M_{\mathrm f,V}$ denotes the solution-frame matrix or a module-frame
   matrix, and use it consistently against the draft's (4.1c).
10. **Add the missing hypotheses to the splitting rate:** no $z$-ramification (or carry the
    factor $e$), a proof that residue differences are constants, and the warning that
    $w(\Delta\lambda)$ is not controlled by the Fano index once the Picard rank exceeds one.
11. **Fix the levelwise wording** ($\Delta\lambda$ has a power in $J_j$; it is not in $J_j$).
12. **Placement section:** refer to statements by label, since the plan renumbers Section 4;
    mark items 4–6 as conditional on the receiver repair; and note that Lemma 4.9 (divisor
    tagging, p.23) carries the same obstruction and needs the same treatment. The gate claim
    itself is accurate and needs no change.
