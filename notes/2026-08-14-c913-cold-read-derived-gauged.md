# C913 cold read — derived and gauged machinery

**Manuscript**: `papers/cubic-stabilization-irrationality`, frozen at `b3b463ecc`.
**Scope read**: `sections/08-global-transport.tex` lines 1–681 (start through
Proposition `prop:clutching-tail-holonomicity`) and `sections/appendix-one-chart.tex` in full.
Also read for context: `sections/02-point-row.tex` (definition of `\rrow`),
`sections/08-scope.tex`, `refs.bib` entries for the imported comparisons, and
`notes/2026-08-14-c913-woodward-qk-extraction.md` (verbatim source extraction of the Woodward /
González–Woodward statements the section cites).

**Method**: every algebraic identity below was recomputed independently before being accepted;
every Woodward locator used in the read scope was compared against the extraction note. Sources
not in the extraction note (Aleshkin–Liu, González–Woodward Remarks 1.18(d)/4.6/4.7) were not
re-fetched and are marked UNVERIFIED where they carry weight.

---

## Required repairs, in priority order

1. **`prop:support-collapse`, the vanishing of wall terms** (section B below). The proof needs the
   marked point carrying \(a_p\) to land in a fixed component that is semistable for some interpolated
   \(L_u\). González–Woodward Proposition 3.15(c), as cited, gives only that markings land in the
   fixed point set \(X^\zeta\); Lemma 3.17 gives semistability for the principal component only. The
   two fixed components containing the orbit limits \(w_0,w_\infty\) are exactly the ones not covered,
   and on those \(a_p=\mathrm{PD}[\overline O]\) has no reason to vanish. Supply the missing statement
   (González–Woodward Remark 3.19 is the natural source and the extraction note flags its
   transcription as incomplete), or restrict the distinguished insertion to a node as
   `08-scope.tex` item (5) already describes it. Also narrow `def:gauged-admissible`(iv) to
   \(L_u\)-semistable fixed components, since no class the paper constructs can satisfy the wider
   reading.
2. **`eq:signed-moving-slope`** (section C). The symbol \(\epsilon_a\) is never defined, and under the
   natural reading (\(\pm1\) for \(H^0\) versus \(H^1\)) the displayed identity computes
   \(\sum_a|h_a|\) and is false. The correct statement carries no signs: \(\sum_ah_a=
   c_1^{\Gm}(TW)\cdot\delta\), because a virtual line of degree \(n_a\) contributes \(n_a+1\) to the
   virtual rank on both rays. The Stirling step in `prop:clutching-tail-holonomicity` needs the
   unsigned sum, so this is not only cosmetic.
3. **Chart independence in `prop:app-one-chart`** (section A). The claim that two invariant affine
   charts impose the same condition on their overlap is false; a two-line counterexample is
   \(\mathbf P^1\) with \(a=+1\). Replace by the invariance argument (a section whose limit lies in an
   invariant affine chart lies entirely in that chart), and cover \(W_F^a\) by the charts meeting
   \(F\). The proposition survives; the argument does not.
4. **The Schürg–Toën–Vezzosi import** (section H). The cited paper's mapping-stack application is the
   reduced obstruction theory for stable maps to a K3 surface, not a general recognition theorem for
   classically constructed obstruction theories. Since Woodward's Definition 7.13 fixes only the
   complex and not the morphism, this is where the "as morphisms to a cotangent complex" upgrade
   actually rests. State as a convention that Woodward's obstruction morphism is the standard
   Kodaira–Spencer / Illusie map, then finish the identification directly.
5. **Locators** (section H). Cite QK III Section 9.4, p. 35 for the relative perfect obstruction theory
   on the *fixed* locus; cite the Graber–Pandharipande fixed-part step, which is currently invisible;
   fix the mis-citation of QK II Example 6.6(c) for invariance of virtual classes; give a theorem
   number and the equivariant relative form for the Toën–Vezzosi mapping-stack formula.
6. **`prop:clutching-tail-holonomicity`** (section J). Say D-finite, not holonomic, over an Artin
   coefficient ring; and give the paragraph that turns polynomially bounded coefficients into a
   finite-order distributional radial boundary value, which is currently asserted.

Optional repairs: drop or demote the "comparison homotopy may be taken to be the identity" claim,
which is unproved as argued and unnecessary (section F); justify the levelwise mapping space by
smoothness of the source algebra rather than polynomiality of the target, and note local triviality of
the equivariant bundle (section E); give the reason, not just the conclusion, for constancy of graph
automorphism groups along a tail (section G); add a citation for \(D\tau_{Y,-}\) being the graph
fundamental solution (section K); note the rotation-parameter inversion at the chart at infinity
(section D).

---

## Verdict summary

| Assigned item                                            | Verdict     | One-line reason                                                                                       |
|----------------------------------------------------------|-------------|-------------------------------------------------------------------------------------------------------|
| 1. Evaluation at one is a derived equivalence            | CONFIRMED\* | Statement is right and genuinely derived; the chart-independence *argument* is invalid as written       |
| 2. Square identifies obstruction theories as morphisms   | CONFIRMED   | Follows from functoriality alone                                                                        |
| 2b. "comparison homotopy may be taken to be the identity"| OVERSTATED  | The Čech computation compares two differentials, not the two composites of the square; also not needed  |
| 3. Tangent-weight sign convention, incl. chart at infinity| CONFIRMED  | Checked end to end and against Woodward Definition 9.7; one convention gloss worth a sentence            |
| 4. Hidden multiplicity in the mu_k / rigidification step  | CONFIRMED   | The r-factors depend only on b mod k, which a tail fixes; no multiplicity escapes                        |
| 5a. Toën–Vezzosi mapping-stack cotangent complex          | OVERSTATED  | No locator; applied to a non-proper quotient source, relative base, Artin target                         |
| 5b. Schürg–Toën–Vezzosi recognition of a classical theory | OVERSTATED  | The cited paper's map application is the reduced K3 stable-map theory, not a general recognition theorem |
| 6. Woodward's package used within his results             | CONFIRMED\* | Formulas match the source verbatim; two uses exceed the cited statements (see B and E below)             |
| 7. Gamma recurrence to holonomicity and boundary values   | OVERSTATED  | D-finiteness is proved; "holonomic" is the wrong word and the finite-order boundary value is unargued    |

\* = statement stands, proof needs repair.

Additional finding outside the seven listed items, and the most serious one I found:

| Finding                                              | Verdict     | Where                                        |
|-------------------------------------------------------|-------------|----------------------------------------------|
| `eq:signed-moving-slope` uses an undefined symbol and is false under the natural reading | WRONG      | `08-global-transport.tex` line 398            |
| The marked-class vanishing step covers nodes and the principal component, not the marked point | OVERSTATED | `prop:support-collapse`, lines 177–184        |
| Chart-independence in `prop:app-one-chart`            | WRONG       | `appendix-one-chart.tex` lines 210–216        |

---

## A. Chart independence in `prop:app-one-chart` is proved by a false statement

Text judged (appendix, "Chart independence"):

> Because \(W\) is projective, the limit \(\lim_{t\to0}t^ax\) exists in \(W\) for every \(x\), and
> because \(W\) is separated an extension of a section across the origin is unique when it exists.
> Two invariant affine charts therefore impose the same condition on their overlap, and the
> chartwise closed subschemes glue to the locally closed subscheme \(W_F^a\subset W\).

The middle claim is false. The chartwise condition supplied by
`lem:app-graded-extension`(b) is "the limit exists *inside this chart*", and that is chart-dependent.

Counterexample. \(W=\mathbf P^1\), \(t\cdot z=tz\), \(a=+1\). On \(U_0=\operatorname{Spec}\C[z]\)
the coordinate \(z\) has weight \(+1\), no weight space is killed, and
\(\operatorname{Spec}A^a=U_0\). On \(U_\infty=\operatorname{Spec}\C[w]\), \(w=z^{-1}\) has weight
\(-1\), so \(I_a=(w)\) and \(\operatorname{Spec}A^a=\{\infty\}\). On the overlap
\(U_0\cap U_\infty=\Gm\) the two charts impose opposite conditions: every point of the overlap
satisfies the \(U_0\) condition and none satisfies the \(U_\infty\) one.

The proposition itself is true; only the gluing argument is wrong. The correct argument is the
invariance of the chart, not the separatedness of \(W\): if \(\lim_{t\to0}t^ax=y\in F\) and \(U\) is
a \(\Gm\)-invariant affine open containing \(y\), then \(t^ax\in U\) for all small \(t\neq0\) because
\(U\) is open and the completed orbit map is continuous, hence \(x\in U\) because \(U\) is
invariant, hence the whole section lies in \(U\). So \(W_F^a\) is covered by the invariant affine
charts *meeting \(F\)*, and on each of those the chartwise description is the right one. Charts
disjoint from \(F\) compute a different stratum and must be excluded, which the present argument
does not do.

The same replacement is needed in the derived/family form, and there it is not automatic: for a
rotation-equivariant section over \(P^0_R\) one needs that the section factors through a single
invariant chart. It does, by the same invariance argument applied fibrewise plus a Zariski cover of
\(\operatorname{Spec}R\), but the appendix does not make the argument.

**Required repair**: replace the two sentences by the invariance argument, and state the chart-
factorization for families.

## B. `prop:support-collapse`: the vanishing step is established for nodes, not for the marked point

Text judged (`08-global-transport.tex`, lines 177–184):

> For each fixed degree and sufficiently large area, every nonendpoint polarization-fixed graph has
> its principal component in a fixed quotient. Moreover every marking and node lands in the
> corresponding fixed locus \cite[Proposition~3.15(c), Lemma~3.17 and
> Proposition~3.18]{GonzalezWoodward}. Its insertion therefore factors through one of the
> restrictions in \eqref{eq:marked-class-restrictions} and vanishes before division by the virtual
> normal Euler class.

What the cited statements give (verified against the extraction note):

- González–Woodward Proposition 3.15(c): "any node or marking of \(\hat C\) maps to the fixed point
  set \(P(X^Z)\)". This is the fixed point *set*, with no semistability.
- Lemma 3.17: for \(\rho>\rho_0\), a Mundet-semistable fixed map "must consist of a principal
  component mapping to \(X^{\zeta,t}/G_\zeta\) and bubbles mapping to \(X/G_\zeta\)", where
  \(X^{\zeta,t}\) is the \(L_t\)-**semistable** locus in \(X^\zeta\). Semistability is asserted for
  the principal component only.
- Proposition 3.18: same split, principal component in \(X^\zeta/G_\zeta\), bubbles in
  \(X/G_\zeta\).

What the manuscript needs is strictly more: the *marked point* carrying \(a_p\) must land in a fixed
component that is semistable for some interpolated \(L_u\). That restriction is exactly the reach of
`lem:orbit-cylinder-disjoint`(b), and the text says so explicitly after the lemma:

> A fixed component occurring at an intermediate polarization in the wall-crossing sense is
> semistable for some interpolated \(L_u\), so clause \textup{(b)} covers every wall term in the
> polarization sweep.

The gap is not cosmetic, because the two fixed components on which \(a_p\) provably fails to vanish
are reachable in principle. By the lemma's own clause (c) the limits \(w_0,w_\infty\) are unstable
for both \(L_\pm\) — and by clause (b) they lie in no \(L_u\)-semistable component — so the
components containing them are precisely the ones not covered, and \(a_p=\mathrm{PD}[\overline O]\)
meets them: its restriction to such a component is the localized class of
\(\overline O\cap F\ni w_0\), which the construction gives no reason to kill. A marked point sitting
on an outer bubble is only known (from 3.15(c)) to land in \(X^\zeta\), which includes those
components.

Note also the internal mismatch with `08-scope.tex` item (5), which describes the mechanism
differently and more safely:

> The wall contributions vanish because their attaching nodes land in intermediate fixed loci on
> which this particular class restricts to zero.

Attaching nodes to the principal component *are* in \(X^{\zeta,t}\), hence semistable, hence covered.
But \(a_p\) is inserted at a marking, not at a node, so the scope paragraph does not describe the
argument actually run in Section 8.

**Required repair**: supply the missing statement that the marked evaluation lands in an
\(L_u\)-semistable fixed component. González–Woodward Remark 3.19 (the bubble-tree description, whose
transcription the extraction note flags as truncated and needing a re-read of the page image) is the
natural place for it; if it is not there, this becomes a further hypothesis. Alternatively restrict
the distinguished insertion to a node, matching the scope paragraph.

Related: `def:gauged-admissible`(iv) says the class has "restriction to every intermediate fixed
component ... zero". On the widest reading of "intermediate fixed component", no class produced by
`lem:orbit-cylinder-disjoint` can satisfy it, for the reason just given. The definition should say
"every fixed component that is semistable for some interpolated \(L_u\)", which is what the lemma
delivers and what the rest of the argument uses.

## C. `eq:signed-moving-slope` is stated with an undefined symbol and is false under the natural reading

Text judged (line 398):

> The signed sum of the moving slopes is
> \[\sum_a\epsilon_a h_a=c_1^{\Gm}(TW)\cdot\delta.\]

\(\epsilon_a\) is never defined. The only other \(\epsilon\) in the section is
\(\epsilon_{Y,p}\), the Poincaré point covector of `lem:point-insertion-row`, which is unrelated.

The identity is a Riemann–Roch statement about the virtual index, and it is true with **no signs at
all**. A virtual line with degree \(n_a(k)=h_ak+s_a\) contributes \(n_a+1\) to the virtual rank
whether \(n_a\ge0\) (an \(H^0\) line) or \(n_a<0\) (an \(H^1\) line), so the slope of the virtual
rank is \(\sum_ah_a=c_1^{\Gm}(TW)\cdot\delta\). Under the reading that \(\epsilon_a=\pm1\) according
to \(H^0\) versus \(H^1\), the left side is \(\sum_{h_a>0}h_a-\sum_{h_a<0}h_a=\sum_a|h_a|\), which
differs from \(c_1^{\Gm}(TW)\cdot\delta\) as soon as one slope is negative — and a negative slope is
exactly the \(H^1\) ray the manuscript takes care to include two paragraphs earlier.

The growth estimate that `prop:clutching-tail-holonomicity` runs on this identity needs the unsigned
sum. Writing the single meromorphic factor of `eq:gamma-index-factor` in both rays,

- \(n\ge0\): \(1/\prod_{m=0}^n(\alpha+m\zeta)\), of log-magnitude \(-n\log n+n+O(\log n)\);
- \(n<0\): the \(H^1\) Euler class \(\prod_{m=n+1}^{-1}(\alpha+m\zeta)\), of log-magnitude
  \(|n|\log|n|-|n|+O(\log n)=-n\log|n|+n+O(\log n)\),

so both rays contribute \(-n_a\log|n_a|+n_a\) uniformly and
\[\log|c_k|=-\Bigl(\sum_ah_a\Bigr)k\log k-k\sum_ah_a\log|h_a|+\Bigl(\sum_ah_a\Bigr)k+O(\log k).\]
Neutrality \(\sum_ah_a=c_1^{\Gm}(TW)\cdot\delta=0\) kills the \(k\log k\) term and the linear term,
leaving the single exponential rate \(-\sum_ah_a\log|h_a|\) that one rescaling removes. This is the
manuscript's conclusion and it is correct; only the displayed identity is mis-stated.

Independent confirmation from the source: Woodward's Example 9.15 formula (63) has the ratio
\(\prod_j\prod_{m=-\infty}^{0}(D_j+m\zeta)\big/\prod_j\prod_{m=-\infty}^{\mu_j(d)}(D_j+m\zeta)\),
whose balance condition is \(\sum_j\mu_j(\delta)=0\) — the unsigned sum, the Calabi–Yau condition.

**Required repair**: define \(\epsilon_a\) explicitly, or replace the display by \(\sum_ah_a\) and add
the one sentence that the virtual rank counts \(n_a+1\) on both rays.

## D. Item 3 — the tangent-weight sign convention checks out end to end

Text judged (`lem:app-cech` proof):

> A vector field \(D\) has weight \(w\) when \(D(A_v)\subset A_{v+w}\), so tangent weights are
> opposite to the weights of the coordinate functions, and along the universal section a tangent
> vector of weight \(w\) acquires \(z^{-aw}\) rather than \(z^{aw}\). Hence on an invariant affine
> chart a graded module \(M=\bigoplus_wM_w\) of sections gives
> \((M\otimes_AR[z])^{\mathrm{rot}}=\bigoplus_{aw\leq0}(M_w\otimes_AR)\).

Verified as follows.

1. *Function side.* \(\psi(f)=x(f)z^{aw}\) for \(f\in A_w\) is forced by
   \(f(\sigma(\lambda z))=f(\lambda^a\sigma(z))=\lambda^{aw}f(\sigma(z))\). Regularity retains
   \(aw\ge0\) and kills \(aw<0\). This is `lem:app-graded-extension` and it is correct.
2. *Tangent side, direct computation.* \(W=\A^1\), \(t\cdot y=t^ky\), so \(y\in A_k\) and \(\partial_y\)
   has \(D\)-weight \(-k\). Rotation acts on a section \(s(z)=z^n\partial_y\) by
   \(\lambda\cdot s=\lambda^{ak-n}s\), so the invariant section is \(z^{ak}\partial_y\), regular iff
   \(ak\ge0\), i.e. iff \(a\cdot(-k)\le0\), i.e. iff \(aw\le0\) in the \(D\)-convention. This matches
   the appendix exactly, including its own \(\A^1\) sanity check.
3. *Opposite sign is the pairing, not an error.* \(D\in T_w\) pairs with \(\Omega_{-w}\), because
   \(D(f)\in A_0\) forces \(w=-v\) for \(f\in A_v\). So retaining functions with \(aw\ge0\) is the
   same condition as retaining tangent vectors with \(aw\le0\), boundary weight \(w=0\) included on
   both sides. The two conventions are dual, not contradictory.
4. *Both signs of the weight.* \(k>0,a>0\): attractor is all of \(\A^1\), tangent weight \(-k\)
   retained. \(k<0,a>0\): \(I_a=(y)\), attractor is the origin, tangent \(D\)-weight \(+k'>0\)
   excluded, tangent space zero. Both correct.
5. *Chart at infinity.* The appendix records an exponent in each chart's own coordinate
   ("so that both extension conditions below are conditions at the vanishing locus of the local
   coordinate"), so the \(\infty\)-chart condition is \(a_+w\le0\) with the same gauge \(\Gm\) and the
   same \(D\)-convention, and \(W_{F_+}^{a_+}\) is again defined by \(\lim_{t\to0}t^{a_+}x\in F_+\).
   This matches Woodward's Definition 9.7 verbatim: \(X^{\varphi_\pm}=\{x\mid\exists\lim_{z\to0}
   \varphi_\pm(z)x\}\) and \((r_\pm^*u)(z)=\varphi_\pm(z)x\), i.e. both ends use the limit at zero in
   their own coordinate. The convention is faithful to the source.

One gloss worth fixing. "Each chart carries the rotation action scaling its own coordinate" silently
inverts the rotation parameter at \(\infty\): the global rotation \(z\mapsto\lambda z\) acts on
\(z'=z^{-1}\) by \(\lambda^{-1}\). This is harmless — rotation-invariance is unchanged under
\(\lambda\mapsto\lambda^{-1}\), and the inversion is precisely what makes both extension conditions
read at the vanishing of the local coordinate — but it should be said, because a reader checking
against the global \(P\) will get \(z^{-a_+}\) and think the sign is wrong.

Verdict: CONFIRMED. Optional repair only.

## E. Item 1 — evaluation at one as a derived equivalence

Judged: `def:app-fixed-section`, `lem:app-graded-extension`, `lem:app-sign`, `prop:app-one-chart`,
`prop:app-descent`, and the in-text version inside `thm:tailwise-derived`.

Verdict: **CONFIRMED as a statement**, with the proof defect of section A and two smaller gaps. The
derived content is real, not a bijection on points, for these reasons which I checked:

- The functor is defined on simplicial commutative test algebras and the correspondence
  \(\psi\leftrightarrow x\) of `lem:app-graded-extension` is levelwise, so it commutes with derived
  base change. Correct.
- The one-chart stack genuinely has no derived structure: with the quotient-stack target the tangent
  complex is \([\Gamma(\mathfrak g)\to\Gamma(T_W)]\) over an affine chart, so there is no \(h^1\), and
  \(h^{-1}\) is the stabilizer Lie algebra, zero on the generic semistable locus. The appendix's own
  phrase "concentrated in degree zero" ignores the stacky \(-1\) term but the conclusion is right.
- The derived structure appears where it should, in the two-chart step: \(\mathfrak Z\) is a homotopy
  fibre product with an honest \(h^1\) exactly when the two attracting loci meet nontransversely
  (`rem:app-degree-one`). This is the substantive point and it is correct.
- Stabilizers match: automorphisms in the homotopy fibre product are
  \(\{(g_-,g_+):g_-=g_+\}\cong\operatorname{Stab}_{\Gm}(x)\), because the two maps to \([W/\Gm]\) are
  stratum inclusions and are injective on stabilizers; on the section side the rotation-invariant
  gauge transformations over a chart are the constants. Correct.
- Clutching data are not "preserved" but fixed: the exponents are part of
  `def:app-fixed-section`, so the equivalence is stated per clutching type. That is the right
  formulation and it matches Woodward's Lemma 9.8 (every fixed point arises from clutching) and
  Corollary 9.10.
- The fixed-section stack is defined as the stack of *equivariant* maps, which is the homotopy-fixed
  description, not a naive fixed locus. Correct choice.

Two gaps beyond section A:

1. The justification offered for the levelwise construction computing the derived mapping space is
   about the wrong object: "Nothing in Lemma~\ref{lem:app-graded-extension} required \(A\) to be
   resolved: the target \(R[z]\) is a polynomial extension of \(R\)". What makes levelwise
   \(\operatorname{Hom}(A,-)\) the derived mapping space is smoothness of the *source* algebra \(A\),
   which holds because \(W\) is smooth. One clause.
2. `prop:app-one-chart` descends to the quotient stack via "locally on \(\operatorname{Spec}R\), a
   trivialization of the \(\Gm\)-bundle together with a section as above". Local triviality of a
   rotation-equivariant \(\Gm\)-bundle on \(P^0_R\) (equivalently, that the graded Picard group of
   \(R[z]\) is \(\operatorname{Pic}(R)\times\mathbf Z\)) is used without comment, and for non-reduced
   \(R\) the non-equivariant analogue is false. One sentence, since the equivariant statement is what
   is true and what is needed.

## F. Item 2 — the 2-commutative square

Judged: `lem:app-truncation`, `prop:app-square`, and the corresponding passage of
`thm:tailwise-derived`.

**The identification as morphisms to a cotangent complex: CONFIRMED**, and by an argument simpler
than the one the appendix leans on. The assignment
\(\mathfrak X\mapsto(\tau_{[-1,0]}L_{\mathfrak X/\mathfrak M}\to L_{t_0\mathfrak X/\mathfrak M})\) is
functorial for equivalences over \(\mathfrak M\); evaluating at the equivalence
\(\operatorname{ev}_1\) gives a 2-commutative square with both verticals equivalences, hence an
isomorphism of the two morphisms, hence equal virtual classes. The appendix states exactly this. The
truncation is in fact a no-op on both sides, since `lem:app-cech` shows both complexes are perfect of
amplitude \([-1,0]\).

**"The comparison homotopy may be taken to be the identity": OVERSTATED.** Text judged:

> Indeed, both composites in the square are, after dualizing, computed on a first-order deformation
> as follows. Restrict the deformation of the section to the two charts; each restriction is a
> section of the extension subcomplex at that chart ...; then restrict both to the open orbit and
> take the difference in \(V\). For the upper route this is the \v{C}ech differential of
> \(R\pi_*u_a^*T([W/\Gm])\); for the lower route it is the structure map of the homotopy fibre
> product \(\mathfrak Z\). ... The two representatives are equal, so the comparison homotopy may be
> taken to be the identity.

What this recipe compares is the *differential of the two-term complex* in two presentations — that
is, it identifies the source and target of the **left vertical** arrow strictly. The composites of the
square are maps \(E_a\to L_{t_0\mathfrak Z/\mathfrak M}\) into the cotangent complex of a classical
truncation, and nothing in the recipe touches \(t_0\). So the identity-homotopy claim is not
established by the argument given. It is also not needed: the conclusion follows from functoriality.
Recommended fix is to delete the claim or demote it to a remark about the presentation.

Two further points on this subsection:

- `lem:app-cech` itself is **CONFIRMED**. The two-chart Čech complex computes \(R\pi_*\), invariants
  are exact for the linearly reductive rotation group and may be taken termwise, invariants over the
  open orbit are \(V\) by evaluation at one, and the identification of the two extension subcomplexes
  with the pulled-back tangent complexes of the strata follows formally from `prop:app-one-chart` plus
  functoriality — the module computation is a consistency check rather than the load-bearing step
  (which is fortunate, see D).
- The tangent complex of the derived intersection "retains the degree-one term when the two attracting
  loci meet nontransversely" is right and is the reason the derived layer earns its place.

## G. Item 4 — mu_k, rigidification, and hidden multiplicity

Judged: `prop:app-mu-k` and the corresponding paragraph of `thm:tailwise-derived`.

Verdict: **CONFIRMED** — I found no multiplicity that escapes and would break constancy along a tail.
Basis:

- (a) is right: with \(z^{1/k}\) of degree \(1/k\) the graded splitting is unchanged and \(aw<0\) is
  \(bw<0\), so the attractor ideal does not move.
- (b) is right and is what carries the argument: the inertia label is \(\widetilde\varphi(\theta)
  =\theta^b\), which depends only on \(b\bmod k\); a tail fixes \(b\bmod k\) and the sign of \(b\), and
  consecutive elements differ by \(k\). Hence the stabilizer order \(k/\gcd(b,k)\) is constant along a
  tail.
- (d) faces the multiplicity question head on and answers it with the right source. QK II
  Proposition 4.3(f),(g) says the rigidified inertia can be replaced by the inertia "at the cost of
  additional factors of \(r\) on the \(r\)-twisted sectors"; those factors depend only on the
  stabilizer order, which (b) has just fixed. The manuscript also correctly records that Woodward's
  fibre products (54)/(57) are taken over the **unrigidified** inertia, which the extraction note
  confirms.
- Exactness of \(\mu_k\)-invariants in characteristic zero and \(\pi_*\pi^*\simeq\id\) for a
  \(B\mu_k\)-gerbe are both standard and correctly used.

Two soft spots, neither of which I judge to be load-bearing:

1. "Stabilizer and graph-automorphism groups, including their localization multiplicities, are
   unchanged" is asserted, not argued. It is defensible — the principal component is parametrized with
   \(0\) and \(\infty\) distinguished, so no automorphism can exchange the ends, and the attached
   factors have fixed ordinary degree and marking set — but the manuscript states the conclusion where
   it should state the reason, and an automorphism jump at isolated degrees inside a tail is exactly
   the failure mode a referee will probe.
2. The descent argument runs "conservative, so the equivalence and the obstruction theory descend".
   Conservativity gives that a descended morphism is an equivalence iff it is one upstairs; existence
   of the descent comes from full faithfulness plus the objects being pulled back, which is asserted
   through (c) rather than checked.

## H. Item 5 — the two imported comparisons

**Toën–Vezzosi, mapping-stack cotangent complex: OVERSTATED.** Cited as bare `\cite{ToenVezzosiHAGII}`
with no theorem number, for:

> the relative cotangent complex of \(\mathfrak S_{a_-,a_+}\) over \(\mathfrak M\) is the pushforward
> along \(\pi\) of the pullback of the cotangent complex of the target, dualized as above, and the
> rotation-invariant part appears because the sections are rotation-fixed.

The HAG II statement is for a mapping stack whose source is proper and flat. Here the source of the
fixed-section stack is effectively the quotient of the (possibly orbifold) domain by the *non-proper*
\(\C^\times_{\mathrm{rot}}\), the whole construction is relative over \(\mathfrak M\), and the target
is an Artin quotient stack. That equivariant relative form is not literally the cited theorem, and
properness is precisely the hypothesis that delivers perfectness. Mitigating: perfectness is
established independently by `lem:app-cech`, so what is genuinely imported is only the deformation-
theoretic formula, which could be derived directly from `def:app-fixed-section`. Repair is a locator
plus a sentence stating the equivariant relative version used, or a direct argument.

**Schürg–Toën–Vezzosi, recognizing a classical obstruction theory as a truncation: OVERSTATED, and
outside what the cited paper gives.** The manuscript states the import as:

> a classical obstruction theory built from the deformation theory of a universal object is the
> classical truncation of the derived one

and again as

> We use here the standard comparison between a classical obstruction theory built from the
> deformation theory of a universal object and the truncation of the derived cotangent complex; that
> comparison is imported from \cite{SchurgToenVezzosi}, not reproved.

I checked the cited paper's abstract (arXiv:1102.1150, the eprint in `refs.bib`). Its map application
is specific: a derived enhancement of the stack of pointed stable maps from genus-\(g\) curves to an
algebraic K3 surface, whose induced tangent and obstruction spaces are shown to coincide with the
reduced spaces of Maulik–Okounkov–Pandharipande–Thomas. That is a construction plus a
tangent-and-obstruction-space match in one geometry, not a general recognition theorem identifying an
arbitrary classically constructed obstruction *morphism* with a derived truncation.

This matters more than a citation slip, because Woodward's Definition 7.13 specifies only the
*complex* — "a perfect obstruction theory, given by the dual of the derived push-forward of the
pull-back of the tangent complex \((Rp_*e^*T(X/G))^\vee\)" — and never writes the morphism to the
cotangent complex. So the manuscript is comparing one stated complex with one unstated morphism, and
deferring the comparison to a paper that does not make it. Since virtual classes depend on the
morphism, not just the complex, this is where the whole "as morphisms to a cotangent complex" upgrade
rests.

Repair: state as an explicit convention that Woodward's obstruction morphism is the Illusie /
Kodaira–Spencer map of the universal gauged map, then complete the identification directly — the
appendix already has the ingredients — instead of attributing a general recognition principle to
Schürg–Toën–Vezzosi.

**Two further citation defects in the same subsection.**

- `lem:app-truncation` attributes to `\cite[Definition~7.13]{WoodwardQKIII}`, with the relative forms
  `\cite[Section~8.3]{WoodwardQKIII}` and `\cite[Example~6.6(c)]{WoodwardQKII}`, a relative perfect
  obstruction theory on the *rotation-fixed* stack. Per the extraction note, those three loci are for
  three different moduli stacks: gauged maps with a single vertex, scaled gauged maps relative to
  \(\mathfrak M^{\mathrm{tw}}_{n,1}(C)\), and affine gauged maps. The statement actually needed —
  a relative perfect obstruction theory on the fixed locus, induced from the ambient one — is in
  QK III Section 9.4, p. 35: "It admits a relative perfect obstruction theory over
  \(M_{n_\pm,1}(P(1,k))\) induced from the relative perfect obstruction theory on
  \(M^G_{n_\pm,1}(P(1,k),X,d)^{C^\times}\)". That locator should be used. The underlying
  fixed-part-is-a-perfect-obstruction-theory step (Graber–Pandharipande) is never cited.
- `prop:app-square` ends with "an isomorphism of relative perfect obstruction theories over a common
  base induces equality of the associated relative virtual classes in Vistoli's bivariant Chow groups
  \cite[Example~6.6(c)]{WoodwardQKII}". Example 6.6(c) is the existence statement for the affine
  gauged-map obstruction theory; the bivariant relative virtual class construction is elsewhere in
  QK II Section 6, and the invariance statement itself is Behrend–Fantechi. Mis-citation.

## I. Item 6 — is Woodward's package used within what his results give

Verdict: **CONFIRMED for the formulas I could check, with the two exceptions already recorded.**

The manuscript is unusually explicit that the *applicability* of the package is assumed:
`def:gauged-admissible`(ii) plus "what is assumed is that this package applies to the polarization
master stacks of the given completion at every degree used, and no existing theorem asserts this for
an arbitrary W{\l}odarczyk completion". `08-scope.tex` item (5) repeats it. That is the correct
posture and I have no complaint about it.

Checked against the extraction note, use by use:

- `eq:virtual-normal-euler` reproduces (59)'s Euler class verbatim, including the two node/attaching
  factors, and the manuscript correctly restricts it to types with a nontrivial attached component,
  citing Example 9.15 for the irreducible unstable case where the source likewise says the normal
  complex is the moving part alone. Faithful.
- `eq:liouville-character` matches Corollary 9.10(c): the source's \(\exp(\bar\gamma+(d_++\varphi_+,
  \gamma)\zeta)\) is exactly the manuscript's \(\exp(\sum_jt_jD_j)\prod_jx_j^{D_j\cdot\widetilde d_+}\)
  with \(x_j=\exp(t_j\hbar)\), and the manuscript's insistence that \(\widetilde d_+\) contains both
  the bubble degree and the affine cocharacter degree is precisely what \(d_++\varphi_+\) says.
  Faithful, and this is the step where the total-degree separation condition (iii) earns its keep.
- Corollary 9.10 is stated in the source only for \(G\) a torus and \(\rho\) sufficiently large; the
  manuscript has \(G=\Gm\) and says "sufficiently large area" throughout. Within hypotheses.
- `eq:endpoint-gauged-maps` cites equation (68), which in the source is an equality of the composite
  \(\tau_{X//G,-}\circ\kappa^G_X\) with the gauged graph potential, paired against \(\alpha_\infty\).
  Reading \(A_\pm\) as the derivative of that composite is legitimate.
- `thm:tailwise-derived` explicitly claims to be *stronger* than the source's (58)–(59), which are
  K-theoretic. That flag is accurate and correctly placed.
- Definition 9.7's convention (both ends use \(\lim_{z\to0}\) in their own chart coordinate) matches
  the appendix, as recorded in D.

The two places where use exceeds citation are B (marking semistability, where 3.15(c) gives the fixed
point set and 3.17 gives semistability only for the principal component) and H (fixed-locus
obstruction theory locator plus the uncited Graber–Pandharipande step).

One structural remark, not an error: Corollary 9.10(a) describes a fixed component only as
"isomorphic to a subset of \(X//G\)", whereas the manuscript's \(t_0\mathfrak Z\) is the
scheme-theoretic intersection of two Bialynicki-Birula strata. The manuscript is choosing a scheme
structure the source leaves unspecified. Harmless for the tail comparison, which is internal to the
manuscript's own model, but a sentence identifying \(t_0\mathfrak Z\) with Woodward's fixed stack
would close it.

## J. Item 7 — Gamma recurrence, holonomicity, boundary values

Judged: `prop:clutching-tail-holonomicity` and its proof; `prop:gamma-ratio-reduction` as input;
`rem:two-tail-threshold-obstruction`.

Split verdict.

- **Recurrence to D-finiteness: CONFIRMED.** The denominator-clearing step is legitimate for the
  reason given: "Gamma arguments do not cross a pole inside a tail, since every zero-mode crossing was
  removed as a threshold". Concretely, \(\alpha+m\zeta=\zeta(m+\alpha/\zeta)\) with \(\alpha/\zeta\)
  nilpotent is invertible in \(R_N\) exactly when \(m\neq0\), and \(m=0\) is the zero mode. The passage
  from \(\sum_ip_i(k)c_{k+i}=0\) to a D-finite generating series needs no division and is fine over an
  Artin coefficient ring.
- **Wording: "holonomic" is wrong.** The statement says the generating series "is holonomic over the
  finite Artin coefficient algebra" while the proof proves "(D)-finite". Over a ring with nilpotents,
  holonomicity has no standard meaning. Use D-finite in the statement.
- **Growth estimate: correct in substance, mis-derived as written.** The Stirling cancellation works,
  but through the unsigned slope sum, not through `eq:signed-moving-slope` as displayed; see C for the
  computation. The manuscript also never states the fact that makes the cancellation uniform, namely
  that both degree rays contribute \(-n_a\log|n_a|\) to \(\log|c_k|\).
- **"tempered radial boundary values which are finite-order distributions": OVERSTATED.** The final
  implication is asserted with neither argument nor citation: "After that rescaling, radial limits of
  \(F\) therefore define finite-order distributions, with polynomial-logarithmic bounds in the radial
  parameter." The implication is true and elementary — coefficients bounded by \(Ck^N(\log k)^M\) make
  \(\sum c_ke^{ik\theta}\) a finite-order distributional derivative of a uniformly convergent series,
  and the radial limits converge in \(\mathcal D'\) — but a claim of this shape needs its one
  paragraph, plus the remark that one argues componentwise in a \(\C\)-basis of \(R_N\) for the
  vector-valued nilpotent-thickened coefficients. Good practice on the manuscript's side: it defines
  the term in place ("This is the meaning of tempered radial boundary values here") instead of
  borrowing an ambient meaning.
- **`rem:two-tail-threshold-obstruction`: CONFIRMED.** I recomputed it. \(F_0=1/(1-2x)\);
  \(F_\infty=\sum_{k<0}3^{-k}x^k=3/(x-3)\); away from the threshold the bilateral sequence is
  annihilated by \((E-2)(E-1/3)\); the two rational functions are not branches of one meromorphic
  function. The remark does what it claims, and it is the right warning to attach to the hypotheses.

## K. Remaining results in scope, individually

- `def:gauged-admissible` — assumptions clearly labelled and their standing separately discussed,
  which is the right treatment. One defect: clause (iv) as worded is unsatisfiable by the class the
  paper constructs; see B.
- `lem:point-insertion-row` — **CONFIRMED with one unstated input.** The computation is right:
  \(\widehat\Gamma\cup[\mathrm{pt}]=[\mathrm{pt}]\) since \(\widehat\Gamma=1+(\text{positive
  degree})\); \(z^{-\mu}z^{c_1}\) acts on the top class by an invertible power of \(z\);
  \(\operatorname{ch}(\OO_p)=[\mathrm{pt}]\); and unitarity of the fundamental solution against the
  \(z\mapsto e^{-\pi i}z\)-twisted pairing of `def:point-row` converts the pairing into the Poincaré
  point covector, so the composite is an invertible scalar times \(\epsilon_{Y,p}\). The unstated
  input is the first sentence of the proof, "The Gamma framing of \(\OO_p\) is the graph fundamental
  solution applied to the top cohomology class", i.e. that \(D\tau_{Y,-}\) *is* the fundamental
  solution in Woodward's graph-space normalization. That identification carries no citation and is the
  only nontrivial ingredient. The cancellation of \(c_n(z)\) between endpoints is fine since birational
  \(Y_\pm\) have equal dimension.
- `prop:support-collapse` — **OVERSTATED**, for the reason in B. Everything else in the proof holds up:
  the point-class-at-zero insertion forcing inputs onto the zero-side tree, the trivial-character
  extraction forcing \(\widetilde d_+=0\) given condition (iii), and the pointedness of the
  infinity-side semigroup ruling out a nonconstant degree-zero component. The proposition is also
  correctly careful that it "does not construct the common realization". The sentence "Their signs and
  node factors agree with Woodward's localized adiabatic identity" is asserted without support; low
  risk, but it is an assertion.
- `lem:orbit-cylinder-disjoint` — **CONFIRMED**, all three clauses, checked independently. The
  normalization is internally consistent: the fibre of \(\OO(1)\) at \([v_k]\) has weight \(-k\), so
  semistability \(k_{\min}\le0\le k_{\max}\) is the displayed \(\mu_M(y_\infty)\le0\le\mu_M(y_0)\).
  \(u\mapsto\mu_u\) is affine, positivity at both ends gives positivity on \([0,1]\), a semistable
  fixed component has \(\mu_u=0\), and the open orbit has no fixed point — so \(\overline O\cap
  F=\emptyset\) and the restriction vanishes. Clause (c)'s Kirwan computation is also right. Note that
  it is this lemma's own clause (c) which shows the two limits are unstable at both ends, and hence
  identifies the fixed components that the vanishing does *not* cover — the gap in B.
- `prop:gamma-ratio-reduction` — **CONFIRMED except for `eq:signed-moving-slope`** (see C). I verified
  `eq:gamma-index-factor` (\(\prod_{m=0}^n(\alpha+m\zeta)=\zeta^{n+1}\Gamma(\alpha/\zeta+n+1)/
  \Gamma(\alpha/\zeta)\)), `eq:adjacent-gamma-ratio`, and `eq:simple-gamma-residue`
  (\(\operatorname{Res}_{s=-m}\Gamma(s)=(-1)^m/m!\) with the Jacobian \(1/h\)). The nonneutral claim —
  the virtual-dimension equation pins \(k\) in each homogeneous coefficient, so the coefficient is
  Laurent-finite — is right in substance. `rem:higher-pole-localization-boundary` is a correctly placed
  disclaimer.
- `thm:tailwise-derived` — **CONFIRMED as a statement**, with the proof defects of A, F, and H. The
  core mechanism is sound and is the right idea: by `lem:app-sign` the strata and restriction maps
  depend on the exponents only through their signs, so the whole derived intersection, its universal
  domain, its evaluations, and its fibre products with the fixed stable-map factors are literally the
  same object along a tail, while only the universal gauged map \(z\mapsto z^ax\) varies — and the
  manuscript says exactly that.
- `prop:app-cutting` — not separately re-derived beyond checking that (a) is the cotangent triangle of
  a derived fibre product and that (b)'s "map of triangles with two identity legs and one
  quasi-isomorphism" is valid. (d)'s observation that Artin-level compatibility is vacuous for the
  identifications and meaningful only for the paired coefficients is correct and well put. I did not
  independently verify Proposition 5.21 of QK II (the fibre product over the diagonal) beyond the
  extraction note's transcription.

## L. Coverage — what I did not reach

- `rem:neutral-boundary`'s characterizations of Aleshkin–Liu (Definition 5.18, Theorem 5.21) and of
  González–Woodward Remarks 1.18(d), 4.6, 4.7 and equation (47): **UNVERIFIED**. Neither source's
  relevant pages are in the extraction note and I did not fetch them. The remark's *logical role* —
  disclaiming that either source supplies the derived-intersection argument or the threshold
  hypotheses — is the conservative direction, so an error there would weaken a disclaimer rather than
  a claim.
- González–Woodward Remark 3.19, the bubble-tree description, is the natural home for the missing
  statement in B. The extraction note explicitly flags its transcription as truncated. **UNVERIFIED**;
  it needs a re-read of the page image, and it is the single highest-value check remaining.
- Toën–Vezzosi HAG II: I did not open it to fix the exact corollary number and hypotheses; the
  mismatch recorded in H is from the shape of the application, not from a reading of the theorem.
- QK II Proposition 5.21 and QK III Proposition 7.14(b) were taken from the extraction note's
  transcription rather than from the page images.
- Material outside the assigned scope (`08-global-transport.tex` after
  `prop:clutching-tail-holonomicity`, including `def:finite-dual-cyclic-rees`, both threshold
  hypotheses, and `def:reduced-nearby`) was not read and carries no verdict here.

