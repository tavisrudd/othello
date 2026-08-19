# C920 referee report: mathematics of the minimal-ruled 5.7T removal

Scope: `git diff 3736b643a..b4d416a62 -- papers/cubic-stabilization-epilogue/sections
papers/cubic-stabilization-epilogue/cubic_stabilization_epilogue.tex`, plus the immediately
surrounding text of `sections/05-framed-monodromy.tex`. Nothing outside that diff is reviewed.
(The working tree is at `17e2d2a6f`, which differs from `b4d416a62` only by the equation-tag
renumbering noted in item 16.)

**Verdict: the core computation is correct and the removal of Hypothesis 5.7T for Hirzebruch
centers is sound in substance, but two MAJOR write-up defects (a false statement in the
deformation family, and a deleted intrinsic-vanishing step now silently assumed) plus a MAJOR
terminology collision around "minimal" must be fixed before the claim is provable as written.**

Independent verification: both quartics, both discriminants, both degenerate factorizations,
the F_1 Gromov-Witten cross-check, and the class-by-class truncation of the F_a quantum
product were recomputed from scratch (sympy plus hand computation); all agree with the
manuscript. The evidence certificate `verification/hirzebruch-euler-spectrum.json` also agrees.

---

1. **MAJOR — `lem:minimal-ruled-euler-spectrum`, proof, "Reduction to a <= 1".** The sentence
   "for \(t\ne0\), \(\PP(E_t)=\PP(\OO(1)\oplus\OO(a-1))\cong F_{a-2}\)" is false for
   \(a\ge4\). Semicontinuity of \(t\mapsto h^0(E_t(-a+1))\) makes the locus where
   \(E_t\cong\OO(1)\oplus\OO(a-1)\) a *proper closed* subset of
   \(\operatorname{Ext}^1(\OO(a),\OO)\setminus\{0\}\): for \(a=4\) the general nonzero
   extension has \(E_t\cong\OO(2)\oplus\OO(2)\), so the general fibre is \(F_0\), not \(F_2\).
   (For \(a=2,3\) the stated claim happens to be correct.) The conclusion survives, but only
   after a fix. Two clean fixes, either acceptable:
   (a) replace "for \(t\ne0\)" by "for a suitable \(t\ne0\)", noting that an extension with
   \(E_t\cong\OO(1)\oplus\OO(a-1)\) exists because one can choose
   \(s_1\in H^0(\OO(1))\), \(s_2\in H^0(\OO(a-1))\) without a common zero when \(a\ge2\), and
   restrict the family to the line \(\C t\);
   (b) better, skip the iteration entirely: with \(k=\lfloor a/2\rfloor\) and \(a\ge2\) there is
   an extension \(0\to\OO\to\OO(k)\oplus\OO(a-k)\to\OO(a)\to0\), so a *single* one-parameter
   family joins \(F_a\) to \(F_{a-2k}=F_{a\bmod2}\), and the transport is directly
   \(s\mapsto s_0-kf\) (the same computation: \((s_0-kf)^2=-(a-2k)-2k=-a\)), which is exactly
   the identification the lemma then uses. This also removes the need to iterate.
   The same erroneous phrasing appears in `verification/imported-sources.json`, entry
   `McDuffSalamon:deformation-invariance` ("its zero fibre and general fibre are the two
   surfaces"), and must be corrected in step with the manuscript.

2. **MAJOR — `lem:minimal-ruled-euler-spectrum`, proof, "The quartic", first sentence.**
   "Specializing along \(\chi\) and using the identification above, the specialized small
   quantum cohomology of \(F_a\) is \(A[S^\flat,F]\) modulo \(\ldots\)" is asserted in one
   clause, and it is precisely the load-bearing step — for \(a\ge3\) the small quantum product
   of \(F_a\) a priori involves an infinite Novikov sum (this is exactly why the Batyrev
   presentation fails there), so the reader is entitled to the truncation argument. The claim
   is *true*; I verified it. Supply the two-line proof: transport \(\psi\) is the lattice
   isomorphism with \(\psi(mf+ns)=(m-nk)f+ns_0\), it is injective, and by deformation
   invariance \(\langle\cdots\rangle^{F_a}_\beta=0\) unless \(\psi(\beta)\) is effective; a
   two-divisor three-point invariant needs \(c_1(F_a)\cdot\beta\in\{1,2\}\), and combining
   \(c_1\cdot\beta=2m+(2-a)n\) with \(m\ge nk\) forces \(n\le1\) (\(a\) even) resp. \(n\le2\)
   (\(a\) odd). The surviving classes are exactly \(\beta=f\) and \(\beta=s+kf\) for \(a\) even,
   and \(\beta\in\{f,\;s+kf,\;2(s+kf)\}\) for \(a\) odd — matching \(u\), \(w\), and the class
   that contributes zero. Adding this also makes it visible that the Novikov monomials
   occurring are effective on \(F_a\) itself, which the current text leaves unclear (note
   \(\psi(s)=s_0-kf\) is *not* effective on \(F_{a\bmod2}\), so the loose sentence before the
   lemma, "the small quantum cohomology of a Hirzebruch surface depends on its index only
   through the parity", is not literally an isomorphism of rings over Novikov rings).

3. **MAJOR — `prop:low-dimensional-vanishing`, proof, final paragraph.** The diff deleted the
   sentence that established the intrinsic vanishing of the minimal model, but the surviving
   nonminimal branch still needs it: "Every nonminimal smooth projective surface is obtained
   from a minimal one by point blowups; under Hypothesis 5.7R the blowup formula
   \eqref{eq:blowup-nu} adds only point terms, and those are zero, so the intrinsic small
   invariant vanishes." The blowup formula gives
   \(\nu_6(\widetilde T)=\nu_6(T_{\min})+\sum\nu_6(\mathrm{pt};\chi_j)\); the conclusion
   requires \(\nu_6(T_{\min})=0\), which is nowhere asserted in the new text. The deleted
   paragraph supplied precisely this for rational ruled minimal models
   ("Proposition~\ref{prop:framed-operations} and the unconditional value \(\nu_6(\PP^1)=0\)
   give \(\nu_6(T)=0\)"). Fix: restore one sentence stating that every minimal surface has
   intrinsic \(\nu_6=0\) — nef canonical and \(\PP^2\) by
   `prop:direct-specialized-lowdim`(i),(ii) at the identity specialization, rational ruled by
   `prop:framed-operations` with \(\nu_6(\PP^1)=0\) (or by
   `prop:minimal-ruled-specialized-vanishing` at the identity specialization), and ruled over
   positive genus by (iii).

4. **MAJOR — "minimal" is used in two incompatible senses, and the sharpness claims depend on
   which is meant.** `prop:minimal-ruled-specialized-vanishing` is titled "minimal rational
   ruled centers" and covers \(F_a\) for all \(a\ge0\), i.e. it includes \(F_1\); but \(F_1\)
   is *not* a minimal surface (it is \(\operatorname{Bl}_p\PP^2\)), and the very next paragraph
   of `prop:low-dimensional-vanishing` uses "minimal/nonminimal" in the strict surface-theory
   sense ("Every nonminimal smooth projective surface is obtained from a minimal one by point
   blowups"). Consequences, all in the diff:
   - "Minimal rational ruled surfaces are covered by
     Proposition~\ref{prop:minimal-ruled-specialized-vanishing} \ldots monomiality of \(\chi\)
     is used only there, and only when the surface is \(F_1\)" is internally inconsistent:
     under the strict sense the clause is vacuous, and under the loose sense the following
     paragraph's "It remains to treat nonminimal surfaces" double-counts \(F_1\).
   - Since \(F_1\) is a nonminimal surface, the hypothesis "Hypothesis 5.7T for nonminimal
     surface targets only" already covers \(F_1\), which makes the added `monomial` hypothesis
     look redundant even though it is genuinely needed to keep \(F_1\) out of the 5.7T branch.
   Fix: everywhere in the diff (introduction, §5 preamble, `rem:tagging-scope`, §6, the
   proposition title and statement) say "rational geometrically ruled surface", i.e. "the
   Hirzebruch surfaces \(F_a\), \(a\ge0\)", and state explicitly that \(F_1\), though
   nonminimal, is routed through `prop:minimal-ruled-specialized-vanishing` and not through
   Hypothesis 5.7T. With that wording the scope claim "5.7T only for nonminimal surface
   centers" should be sharpened to "only for surface centers that are not geometrically ruled
   over a curve", which is what is actually proved.

5. **OK — Batyrev/Givental are used only for \(F_1\), and even there inessentially.** The proof
   invokes `\cite[Section 5]{Batyrev}` and `\cite[Theorem 0.1]{Givental}` only for \(F_1\),
   which is Fano, and then gives a complete independent Gromov–Witten derivation of the same
   two relations. Every \(a\ge2\) is reached by deformation invariance, not by the toric
   presentation. I checked for residual reliance and found none: the toric presentation is
   never applied to a non-Fano \(F_a\). The `imported-sources.json` conventions record this
   correctly. No fatal error here.

6. **OK — the \(F_1\) Gromov–Witten cross-check is correct in every detail.** \(c_1=2S+3F\),
   \(c_1\cdot f=2\), \(c_1\cdot s_0=1\), hence \(c_1\cdot(mf+ns_0)=2m+n\); a three-point
   invariant with two divisor insertions is nonzero only for \(0\le c_1\cdot\beta\le2\); the
   effective classes meeting that are \(s_0\), \(f\), \(2s_0\); \(\langle\,\rangle_{s_0}=1\),
   \(\langle\mathrm{pt}\rangle_f=1\), \(\langle\mathrm{pt}\rangle_{2s_0}=0\). Applying the
   divisor axiom I reproduce exactly
   \(S_0\star S_0=-\mathrm{pt}+Q^{s_0}S_0+Q^f\), \(S_0\star F=\mathrm{pt}-Q^{s_0}S_0\),
   \(F\star F=Q^{s_0}S_0\), hence \(S_0\star S_0+S_0\star F=Q^f\). The support argument ruling
   out \(2s_0\) is genuinely needed (both divisor factors pair nontrivially with \(2s_0\)) and
   is correctly given. The \(F_0\) products \(S_0\star S_0=Q^f\), \(F\star F=Q^{s_0}\) are also
   correct with the stated fibre/section conventions.

7. **OK — both quartics are exactly right.** I rebuilt both multiplication matrices from the
   presentations (basis \(1,F,S^\flat,S^\flat F\); for \(a\) odd using
   \(S^{\flat2}=u-S^\flat F\), \(F^2=wS^\flat\), and
   \(c_1\star S^\flat F=wu+2uF-wS^\flat F\)) and obtained precisely the two displayed matrices,
   with characteristic polynomials \(X^4-8(u+w)X^2+16(u-w)^2\) and
   \(X^4+wX^3-8uX^2-36uwX+16u^2-27uw^2\). Independent cross-check for the even case: the
   \(F_0\) tensor structure gives eigenvalues \(2(\pm\alpha\pm\beta)\) with \(\alpha^2=u\),
   \(\beta^2=w\), whose product is exactly the even quartic. Also \(c_1(F_a)=2S+(a+2)F\),
   \(S^{\flat2}=-a+2k\in\{0,-1\}\), and \(c_1=2S^\flat+2F\) resp. \(2S^\flat+3F\) are correct.

8. **OK — both discriminants are exactly right.** \(\operatorname{disc}=2^{24}u^2w^2(u-w)^2\)
   (\(2^{24}=16777216\)) and \(-u^2w^2(256u+27w^2)^3\), confirmed symbolically.

9. **OK / MINOR — `lem:ruled-degeneracy-trichotomy`, factorizations and distinctness.** Both
   factorizations check out: \(u=w\) gives \(X^2(X^2-16u)\); \(w=16\sigma\),
   \(u=-27\sigma^2\) gives \((X+18\sigma)^2(X^2-20\sigma X+612\sigma^2)\) with quadratic roots
   \(10\sigma\pm16\varepsilon\), \(\varepsilon^2=-2\sigma^2\). Distinctness of the two simple
   roots needs only \(\sigma\ne0\), which follows from \(w\ne0\). One numerical slip: the
   coincidence \(10\sigma\pm16\varepsilon=-18\sigma\) forces \(1296\sigma^2=0\), not
   \(81\sigma^2=0\) — the two are equivalent in characteristic zero (\(1296=16\cdot81\)), but
   the displayed constant should be corrected or the division by \(16\) made explicit.
   Exhaustiveness ("No other block shape occurs") *is* established, because the two explicit
   factorizations exhibit the full multiplicity pattern \(1,1,2\) on the degeneracy locus, and
   \(u,w\ne0\) makes the locus exactly the one named. The rank-two Cayley–Hamilton argument for
   \(N^2=0\) is correct.

10. **MINOR — `lem:ruled-degeneracy-trichotomy` is a dichotomy, and case (b) is dead.** The
    lemma is named a trichotomy but states two mutually exclusive alternatives. Moreover case
    (b) is consumed nowhere in the manuscript: \(a\ge1\) is handled by case (a) via
    `lem:center-specialization-nondegenerate`, and \(a=0\) is handled by the tensor argument
    that deliberately avoids the spectrum. Either rename it, or make it earn its place — the
    evidence certificate already records the strictly stronger fact
    (`semisimple_at_double_root: true`, `eigenspace_dimension_at_double_root: 2`), so the
    manuscript's "whose nilpotent part squares to zero" understates what is known; state
    semisimplicity instead if case (b) is to be retained.

11. **OK / MINOR — `lem:center-specialization-nondegenerate`, valuation arguments.** All three
    branches are correct. With \(v(u)=p=\ell(f)\) and \(v(w)=r+kp\), \(r=\ell(s)\): for
    \(a=2k\), \(k\ge1\), \(v(w)>v(u)\) hence \(u\ne w\); for \(a=2k+1\), \(k\ge1\),
    \(v(w^2)=2r+2kp\ge 2r+2p>p=v(u)\), and \(256,27\) are units of the \(\C\)-domain \(A\), so
    \(256u=-27w^2\) is impossible. Additivity of \(\ell\) is legitimate (\(\chi\) is a monoid
    map and \(v\) a valuation). Note the lemma correctly *excludes* \(a=0\): there \(k=0\) and
    \(v(u)=p\), \(v(w)=r\) can coincide and \(u=w\) genuinely can occur, which is exactly why
    item 13's tensor argument is needed.

12. **MINOR — `lem:center-specialization-nondegenerate`, the \(a=1\) leading-term step.** The
    conclusion is correct, but the display
    \(\operatorname{gr}(256u+27w^2)=256\operatorname{gr}(u)+27\operatorname{gr}(w)^2\) is
    circular as written: \(\operatorname{gr}(x)\) denotes the leading term, which presupposes
    \(v(256u+27w^2)=p\), i.e. the very nonvanishing being proved. Rewrite via the symbol map at
    a fixed degree: let \(\sigma_p:A_{\ge p}\to A_{\ge p}/A_{>p}\); \(\sigma_p\) is additive,
    \(\sigma_p(u)=\operatorname{gr}\chi(Q^f)\) and
    \(\sigma_p(w^2)=\operatorname{gr}\chi(Q^{2s})\) since both have valuation exactly \(p\), so
    \(\sigma_p(256u+27w^2)=256\sigma_p(u)+27\sigma_p(w^2)\ne0\) by monomiality, whence
    \(256u+27w^2\ne0\). The two auxiliary facts used are fine: \(\operatorname{gr}(w)^2=
    \operatorname{gr}(w^2)\) needs the assumed domain associated graded, and \(2s\) is
    effective so its leading term lies in \(B\); \(256+27=283\ne0\) covers the coincident case.

13. **OK — `prop:minimal-ruled-specialized-vanishing`, the \(\PP^1\times\PP^1\) argument, is
    sound and does genuinely avoid \(u\ne w\).** The chain is: Behrend's product formula gives
    \(QH^*(F_0)=QH^*(\PP^1)^{\otimes2}\) over
    \(\Lambda_{\PP^1}\otimes\Lambda_{\PP^1}=\Lambda_T\); the connection matrix has entries in
    \(\Lambda_T\) so \(\chi\) applies entrywise; \(U_T=U_1\otimes1+1\otimes U_2\) and
    \(\mu_T=\mu_1\otimes1+1\otimes\mu_2\), so the specialized \(z\)-connection is the tensor
    product of the two factors' connections; each factor has two distinct Euler eigenvalues
    \(\pm2\sqrt{\chi(Q^{f_i})}\) and hence, by `lem:simple-euler-block`, is a sum of rank-one
    pieces with trivial framed regular monodromy; the formal decomposition of a tensor product
    is the tensor of the decompositions, so the total module is a direct sum of rank-one pieces
    with trivial framed regular monodromy even when exponential factors collide. That last
    point is exactly the \(u=w\) case: the spectrum then really is \(X^2(X^2-16u)\) with a
    rank-two block at \(0\), and the argument correctly bypasses it. The manuscript's remark
    "the two rulings may well have the same image" is accurate and important.

14. **OK — the \(a\ge1\) branch of `prop:minimal-ruled-specialized-vanishing` is complete.**
    `lem:center-specialization-nondegenerate` (\(a\ge1\), monomial if \(a=1\)) gives
    \(\operatorname{disc}P_a\ne0\), the trichotomy case (a) gives four rank-one blocks after
    passage to the algebraic closure of \(\operatorname{Frac}A\), and `lem:simple-euler-block`
    kills each. Together with \(a=0\) this covers every \(F_a\), hence every rational
    geometrically ruled surface by Grothendieck splitting. No missing index.

15. **OK — hypothesis bookkeeping is consistent, with the caveat of item 4.** I checked every
    occurrence of "5.7T" in the manuscript: introduction (three places), §5 preamble,
    `rem:tagging-scope`, `prop:low-dimensional-vanishing`, `thm:nu6-birational-invariance`,
    `cor:v14-one-step`, §6. All now read "for nonminimal surface centers/targets only" and no
    stale "both Hypotheses" survives. The new `monomial` hypothesis on
    `prop:low-dimensional-vanishing` is discharged at its unique call site
    (`thm:nu6-birational-invariance`) by the paragraph after `def:monomial-specialization`, and
    that paragraph does justify monomiality for the center maps
    \eqref{eq:center-novikov-specialization}: with the exceptional Laurent variable given
    valuation zero and \(v_H\) induced by an ample \(H\), the associated graded is the Laurent
    monoid ring on the numerical Novikov monomials of \(T\) and \(u\), whose monomials are a
    \(\C\)-basis, and \(\chi_j(Q_C^d)=Q^{i_*d}u^{\rho_C\cdot d}\) is such a monomial with
    coefficient \(1\). Noninjectivity of \(\chi_j\) is harmless for monomiality. The paragraph
    is terse — it would read better if it said explicitly which valuation the associated graded
    is taken with respect to — but it is not wrong.

16. **MINOR — terminology collision on the word "monomial".** `def:strict-novikov-admissible`
    already opens with "A **monomial map** \(\chi:\Lambda_T\to A\)" (meaning a monoid map on
    Novikov monomials), and `def:monomial-specialization` now defines "\(\chi\) is
    **monomial**" as a different, strictly stronger condition on \(\operatorname{gr}A\). Two
    senses of the same adjective on the same object, three hundred lines apart, in hypotheses
    that are quoted verbatim in `prop:low-dimensional-vanishing`. Rename one — e.g.
    "graded-monomial specialization" or "\(B\)-monomial".

17. **MINOR — `rem:tagging-scope`, last sentence.** "The even cohomology of a nonminimal
    surface also has rank four plus the number of blowups" is false in general: it is
    \(2+b_2(T_{\min})+n\), which is \(3+n\) for iterated blowups of \(\PP^2\) and depends on
    \(b_2\) for a non-rational minimal model. The intended point (the rank-four quartic does not
    apply) survives; state it as "rank strictly greater than four".

18. **MINOR — citation phrasing and choice.** "the toric quantum Stanley--Reisner presentation
    \cite[Section~5]{Batyrev}, a theorem by the mirror theorem for Fano toric manifolds
    \cite[Theorem~0.1]{Givental}" is ungrammatical; intended sense is "…, which is a theorem
    for Fano toric manifolds by Givental's mirror theorem". Separately, deformation invariance
    of genus-zero invariants along a *smooth projective* family is cited to
    \cite[Chapter 7]{McDuffSalamon}, which proves it symplectically for semipositive targets
    (fine for surfaces, but a mismatch of category); an algebraic reference (Behrend–Fantechi
    or Li–Tian) would match the family actually constructed. Neither is a correctness problem.

19. **MINOR — `lem:minimal-ruled-euler-spectrum`, statement.** "\(s\) the negative-section
    class" is not well defined for \(a=0\), where every section has self-intersection \(0\) and
    the choice amounts to picking one of the two rulings. Harmless — the even quartic and its
    discriminant are symmetric in \(u\) and \(w\) — but say so, or say "a section of
    self-intersection \(-a\)".

20. **MINOR — `lem:minimal-ruled-euler-spectrum`, proof, transport.** "That transport fixes the
    fibre class" is asserted without reason; it holds because the ruling is global over the base
    (the total space maps to \(\PP^1\times\operatorname{Ext}^1\)), so the fibre class is a flat
    section of the local system, and one clause saying so removes the objection. Also, the
    identification is already pinned down by "fixes \(f\) and preserves the intersection form":
    writing \(\psi(s)=\alpha s'+\beta f\), pairing with \(f\) gives \(\alpha=1\) and
    \(\psi(s)^2=-a\) gives \(\beta=-1\). The first Chern number is not needed for uniqueness,
    so the parenthetical claim that it is what "determines it" is inaccurate (harmlessly).

21. **OK (already fixed) — equation-tag collision.** In the reviewed diff the two new displays
    carried `\tag{5.6}` and `\tag{5.6a}`, colliding with the existing `\tag{5.6}` at the
    divisor-tagging map. Commit `17e2d2a6f` renumbered them to `5.5a`/`5.5b`. No action.

---

## Summary of required changes

- Item 1 (family construction, false for \(a\ge4\)) — must fix; one-line repair available.
- Item 2 (truncation of the \(F_a\) quantum product for \(a\ge3\)) — must supply; the omitted
  step is precisely where the Batyrev presentation would fail, so a referee will demand it.
- Item 3 (intrinsic vanishing of the minimal model, deleted by the diff) — must restore.
- Item 4 (\(F_1\) is not minimal; "minimal rational ruled" collides with the minimal/nonminimal
  case split, muddling both sharpness claims) — must reword; the honest sharp statement is that
  5.7T survives only for surface centers that are not geometrically ruled over a curve.
- Items 9–20 are corrections and clarifications that do not affect the truth of any claim.

Nothing in the diff is mathematically false apart from item 1 and the incidental slips in items
9 and 17; the removal of Hypothesis 5.7T for Hirzebruch-surface centers is correct as a result.
