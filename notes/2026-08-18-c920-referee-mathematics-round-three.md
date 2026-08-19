# C920 referee report, round three (final): the minimal-ruled 5.7T removal

Scope: `git diff 3736b643a..a74cf275c -- papers/cubic-stabilization-epilogue/sections
papers/cubic-stabilization-epilogue/cubic_stabilization_epilogue.tex
papers/cubic-stabilization-epilogue/verification`. Earlier reports:
`notes/2026-08-18-c920-referee-mathematics.md` (round one) and
`...-round-two.md`; "round-two item N" below refers to the second.

**Verdict: every round-two item was applied and each applied change is correct, except that
item 12 was applied in only one of its two locations. The adversarial re-read found one new
false statement, introduced by the item-14 repair itself: the claim that the degenerate case
never arises for a center specialization is false for \(F_0\) and contradicts the proof of
`prop:hirzebruch-specialized-vanishing` two pages later. One older false clause also survives
in `rem:tagging-scope` in a new form. Neither affects any proof; both are one-sentence fixes.
Nothing else in the new mathematical content is false, unproved, or overclaimed.**

---

## Part 1: were the round-two items applied correctly?

1. **OK — round-two item 4, first sentence.** The lead-in now reads "The remaining centers are
   the rational geometrically ruled surfaces, that is the Hirzebruch surfaces \(F_a\); these are
   the minimal surfaces not yet covered, together with \(F_1\), which is geometrically ruled
   without being minimal." Correct: at that point in the text the minimal surfaces still
   untreated are exactly the \(F_a\) with \(a\ne1\), since nef-canonical minimal surfaces,
   \(\PP^2\) and the positive-genus ruled surfaces are already handled, and the minimal rational
   surfaces are \(\PP^2\) and \(F_a\) (\(a\ne1\)).

2. **MINOR (still false) — round-two item 4, second sentence, `rem:tagging-scope`.** The
   rewrite is "The quartic of Lemma~\ref{lem:hirzebruch-euler-spectrum} was derived for the
   Hirzebruch surfaces and is not available for such a center, whose even cohomology has rank
   greater than four." The first clause is true and by itself does the job. The appended rank
   claim is false. A center that is neither minimal nor geometrically ruled is an iterated point
   blowup of some minimal surface \(M\), and its even cohomology has rank \(2+b_2(M)+n\) with
   \(n\ge1\) blowups. Taking \(M\) a fake projective plane (\(b_2=1\), \(K_M\) ample) and
   \(n=1\), the surface \(\operatorname{Bl}_pM\) is of general type, not minimal, not
   geometrically ruled, and its even cohomology has rank exactly four. (The only minimal
   surfaces with \(b_2=1\) are \(\PP^2\) and the fake projective planes; \(\PP^2\) blown up once
   is \(F_1\), which is excluded, so the fake projective plane is the genuine witness.) I raised
   this same counterexample in round two; the rewrite preserved the claim in a new form. Fix:
   delete the clause "whose even cohomology has rank greater than four" and stop after "is not
   available for such a center".

3. **OK — round-two item 7, generator docstring.** `hirzebruch_euler_spectrum.py` now opens
   "Euler spectrum of a specialized Hirzebruch surface", identifies the \(F_a\) as the rational
   geometrically ruled surfaces and notes that they are the minimal ones apart from \(F_1\), and
   describes the single family (extensions whose class is a multiple of the class of a nowhere
   vanishing pair of sections of \(\OO(k)\) and \(\OO(a-k)\)) with the transport determined by
   the intersection form alone. The superseded iteration and the "first Chern number determines
   it" phrasing are gone. The certificate still replays: `sha256sum -c` passes on both tracked
   files, and `--check` prints "certificate and digests agree".

4. **OK — round-two item 8, Truncation.** Now "By the virtual dimension count, and by the
   fundamental-class axiom at the lower end, a three-point invariant of \(F_a\) with two divisor
   insertions and \(\beta\ne0\) vanishes unless \(1\le c_1(T)\cdot\beta\le2\)". Both the
   \(\beta\ne0\) qualifier and the two named inputs are correct and are exactly what the bound
   needs, and "only finitely many Novikov monomials survive" replaces the miscounted "three".

5. **OK — round-two item 9, the family.** "that is the pullback of the universal extension along
   \(t\mapsto t\varepsilon\)" and "scaling a nonzero extension class by a unit leaves the middle
   term unchanged, so \(E_t\cong E_1\) for every \(t\ne0\)" are both correct and are exactly the
   two facts that were being used silently.

6. **OK — round-two item 10, the identity specialization.** "the identity map of \(\Lambda_T\),
   which is strictly Novikov-admissible with \(\ell=H\cdot(-)\) for an ample \(H\), and
   graded-monomial because its associated graded is the monoid algebra of the effective monoid,
   whose monomials are a basis." This is correct and it now points at machinery the paper
   already establishes: \(\Lambda_T=\C[[\mathrm{NE}^{\mathbf Z}_{\rm num}(T)]]\) is shown to be a
   domain in Section 5's opening, with the ample degree positive and proper and the lowest
   homogeneous part of a product equal to the product of the lowest homogeneous parts, which is
   precisely "complete separated valued \(\C\)-domain with domain associated graded".

7. **OK — round-two item 11.** "the second because \(\chi\) is a monoid map, so
   \(w^2=\chi(Q^{2s})\)" replaces the vestigial domain clause. Correct, and it is the right
   reason.

8. **PARTIAL — round-two item 12, the "surface" qualifier.** Applied in
   `sections/06-synthesis.tex:72` ("5.7T remains only for surface centers that are neither
   minimal nor geometrically ruled") but **not** in the introduction:
   `sections/01-introduction.tex:222` still reads "it remains only for centers that are neither
   minimal nor geometrically ruled", and `:230` still reads "Hypothesis~5.7T for centers that
   are neither minimal nor geometrically ruled". Since points and curves are also blowup
   centers and neither adjective applies to them, the unqualified prose reads as assuming 5.7T
   for those too — the opposite of what is proved. `rem:tagging-scope:1120` also lacks it, but
   there the following sentence ("Every such surface is an iterated point blowup") disambiguates.
   Add "surface" at `01-introduction.tex:222` and `:230`.

9. **OK — round-two item 13, the rank count.** "The displayed relations therefore hold in the
   specialized ring, and the resulting surjection from the presented algebra, which is free of
   rank four, onto the specialized quantum cohomology, also free of rank four, is an
   isomorphism." Correct: a surjection of free modules of equal finite rank over a commutative
   ring is injective. Two sub-claims are asserted rather than shown, both one-liners — that the
   odd presentation \(A[S^\flat,F]/(S^{\flat2}+S^\flat F-u,\;F^2-wS^\flat)\) is free with basis
   \(1,F,S^\flat,S^\flat F\) (I checked the two reduction routes for \(S^{\flat2}F\) agree, so
   it is), and that the map is surjective (it is: the point class is \(S^\flat\star F\) for
   \(a\) even and \(S^\flat\star F+wS^\flat\) for \(a\) odd, so divisors generate).

10. **NEW MAJOR (false, and self-contradictory) — round-two item 14 introduced an incorrect
    sentence.** `lem:ruled-degeneracy-dichotomy` now ends: "Case~(b) is recorded so that a
    degenerate specialization is described rather than assumed away; by
    Lemma~\ref{lem:center-specialization-nondegenerate} it does not arise for any center
    specialization." The second clause is false. `lem:center-specialization-nondegenerate` is
    stated only for \(a\ge1\); the dichotomy keeps the notation of
    `lem:hirzebruch-euler-spectrum`, which covers \(a\ge0\); and for \(a=0\) case (b) does
    arise for center specializations. The manuscript says so itself twice — the lead-in
    paragraph ("the quadric surface \(F_0\) is handled separately ... because \(\chi\) may send
    its two ruling classes to the same value and the quartic below then degenerates") and the
    proof of `prop:hirzebruch-specialized-vanishing` ("\(\chi\) may identify the two ruling
    classes, and the discriminant of Lemma~\ref{lem:hirzebruch-euler-spectrum} then vanishes").
    It is not a hypothetical: take \(Y=\PP^4\) and \(C\) a smooth quadric surface inside a
    hyperplane \(\PP^3\subset\PP^4\), a codimension-two center with \(C\cong F_0\). Then
    \(i_*f=i_*s\) is the line class, and \(\rho_C=c_1(N_{C/\PP^4})=\OO(3)|_C\) pairs to \(3\)
    with both rulings, so \eqref{eq:center-novikov-specialization} gives \(u=w\) exactly and
    \(\operatorname{disc}P_0=0\).
    Fix: "…by Lemma~\ref{lem:center-specialization-nondegenerate} it does not arise for a center
    specialization when \(a\ge1\); for \(a=0\) it can arise, and
    Proposition~\ref{prop:hirzebruch-specialized-vanishing} handles that case by the product
    route, without using the spectrum."

## Part 2: adversarial read of the whole new mathematical content

I re-derived the new material from scratch, without leaning on the earlier rounds, and
recomputed the symbolic parts. Everything below is correct.

11. **OK — the deformation.** \(k=\lfloor a/2\rfloor\ge1\) and \(a-k=\lceil a/2\rceil\ge1\) for
    \(a\ge2\), so both line bundles have at least two sections and a general pair has no common
    zero; the resulting \(\OO\hookrightarrow\OO(k)\oplus\OO(a-k)\) has locally free quotient of
    degree \(a\), hence \(\OO(a)\); the extension is nonsplit because
    \(\OO(k)\oplus\OO(a-k)\not\cong\OO\oplus\OO(a)\) for \(1\le k\le a-1\), so
    \(\varepsilon\ne0\) (used implicitly, worth one word);
    \(\PP(\OO(k)\oplus\OO(a-k))\cong\PP(\OO\oplus\OO(a-2k))=F_{a\bmod2}\) by twisting with
    \(\OO(-k)\). Semipositivity is right: for \(\dim_\R M=4\) the McDuff–Salamon condition
    "\(3-n\le c_1(A)<0\)" reads "\(1\le c_1(A)<0\)", vacuous, and every fibre of the family is a
    symplectic four-manifold, so the invariants are defined and deformation-invariant
    throughout. Parallel transport is unambiguous because \(\A^1\) is simply connected, and the
    intersection form is transported because Ehresmann gives a diffeomorphism. \(\psi\) fixes
    \(f\) because the ruling is global over the base; \(\psi(s)=\alpha s_0+\beta f\) with
    \(\psi(s)\cdot f=s\cdot f=1\) forces \(\alpha=1\), and \(\psi(s)^2=-a\) with
    \(s_0^2=-(a-2k)\) forces \(\beta=-k\). Hence \(\psi(s+kf)=s_0\) and, dually,
    \(S^\flat=S+kF\mapsto S_0\) (I checked the dual computation: \(S\mapsto S_0-kF\),
    \(F\mapsto F\)). The Chern-number claim that round one flagged as unnecessary is gone.

12. **OK — the two base cases.** \(F_0\): with the fibre \(F=H_A\) and section \(S_0=H_B\), the
    product formula gives \(S_0\star S_0=Q^{f}\) and \(F\star F=Q^{s_0}\) — the index bookkeeping
    is right, not swapped. \(F_1\): \(c_1\cdot f=2\), \(c_1\cdot s_0=1\), so
    \(c_1\cdot(mf+ns_0)=2m+n\); the effective classes with \(0<2m+n\le2\) are exactly \(s_0\),
    \(2s_0\), \(f\); \(\langle\;\rangle_{s_0}=1\), \(\langle\mathrm{pt}\rangle_f=1\),
    \(\langle\mathrm{pt}\rangle_{2s_0}=0\), and the support argument for the last is genuinely
    needed because both divisors pair nontrivially with \(2s_0\). Applying the divisor axiom I
    reproduce \(S_0\star S_0=-\mathrm{pt}+Q^{s_0}S_0+Q^f\), \(S_0\star F=\mathrm{pt}-Q^{s_0}S_0\),
    \(F\star F=Q^{s_0}S_0\), hence the displayed presentation. The Batyrev/Givental import is
    used only for \(F_1\), which is Fano, and the manuscript now says plainly that the direct
    reading is what is used; there is no residual reliance on the toric presentation for any
    \(a\ge2\), which was the fatal-error check.

13. **OK — the truncation.** \(c_1(T)\cdot\beta=2m+(2-a)n\) equals \(2(m-nk)+2n\) for \(a=2k\)
    and \(2(m-nk)+n\) for \(a=2k+1\); effectivity of \(\psi(\beta)=(m-nk)f+ns_0\) on
    \(F_{a\bmod2}\) is \(m\ge nk,\;n\ge0\) (the effective cone of both \(F_0\) and \(F_1\) is
    spanned by \(f\) and \(s_0\)), which also forces \(m\ge0\); combining, \(c_1\cdot\beta\le2\)
    gives \(n\le1\) resp. \(n\le2\), and case by case \(n=0\Rightarrow m=1\),
    \(n=1\Rightarrow m=k\), \(n=2\Rightarrow m=2k\). Surviving classes \(f,\,s+kf\) (even) and
    \(f,\,s+kf,\,2(s+kf)\) (odd), exactly as claimed. Note the bound also disposes of the
    infinite family \(\beta=ns\) with \(c_1\cdot\beta=0\) that exists for \(a=2\), twice over.
    Independent confirmation for \(a=2\): direct computation gives \(S^\flat\star S^\flat=Q^f\),
    \(F\star F=Q^{s+f}\), \(S^\flat\star F=\mathrm{pt}\), matching the even presentation, and the
    certificate's `gromov_witten` check reproduces the same three products symbolically.

14. **OK — the two quartics and the two discriminants.** Rebuilding both multiplication matrices
    from the presentations in the basis \(1,F,S^\flat,S^\flat F\) reproduces the two displayed
    matrices exactly, with characteristic polynomials \(X^4-8(u+w)X^2+16(u-w)^2\) and
    \(X^4+wX^3-8uX^2-36uwX+16u^2-27uw^2\) and discriminants \(2^{24}u^2w^2(u-w)^2\) and
    \(-u^2w^2(256u+27w^2)^3\). Cross-check for the even case: the \(F_0\) tensor structure gives
    eigenvalues \(2(\pm\alpha\pm\beta)\) with \(\alpha^2=u,\beta^2=w\), whose product is that
    quartic. Consistency of the conventions also checks out: \(c_1(F_a)=2S+(a+2)F\),
    \(S^{\flat2}=-a+2k\in\{0,-1\}\), \(c_1=2S^\flat+2F\) resp. \(2S^\flat+3F\).

15. **OK — the degeneracy analysis.** With \(u,w\ne0\) the discriminant vanishes exactly on
    \(u=w\) (even) and \(256u+27w^2=0\) (odd). At \(u=w\), \(P_a=X^2(X^2-16u)\), double root
    \(0\), simple roots \(\pm4\sqrt u\ne0\). At \(w=16\sigma\), \(u=-27\sigma^2\),
    \(P_a=(X+18\sigma)^2(X^2-20\sigma X+612\sigma^2)\) — I expanded both sides and they agree,
    including the constant \(198288\sigma^4\) — with quadratic roots \(10\sigma\pm16\varepsilon\),
    \(\varepsilon^2=-2\sigma^2\), distinct from each other and from \(-18\sigma\) since
    \(\sigma=w/16\ne0\). Exhaustiveness of the two block shapes is genuinely established, since
    the explicit factorizations exhibit the multiplicity pattern \(1,1,2\), and the rank-two
    Cayley–Hamilton argument for \(N^2=0\) is correct.

16. **OK — the non-collision arithmetic.** With \(p=\ell(f)\), \(r=\ell(s)\) both positive and
    \(\ell\) additive (\(\chi\) a monoid map, \(v\) a valuation): for \(a=2k\), \(k\ge1\),
    \(v(w)=r+kp>p=v(u)\) so \(u\ne w\); for \(a=2k+1\), \(k\ge1\), \(v(w^2)=2r+2kp\ge2r+2p>p\),
    and since \(256,27\) are units of the \(\C\)-domain \(A\) and \(v(-x)=v(x)\), the equation
    \(256u=-27w^2\) would force \(v(u)=v(w^2)\). For \(a=1\), if \(p=2r\) the degree-\(p\) symbol
    map is additive and \(\sigma_p(256u+27w^2)=256\operatorname{gr}\chi(Q^f)+
    27\operatorname{gr}\chi(Q^{2s})\), a nonzero combination of members of \(B\) because
    \(283\ne0\). The rewritten step is now non-circular and the reason attached to
    \(w^2=\chi(Q^{2s})\) is the right one. The exclusion of \(a=0\) from this lemma is necessary
    and is correctly made — which is exactly what item 10 above gets wrong in the dichotomy.

17. **OK — the quadric product route.** The chain is sound: the product formula over
    \(\Lambda_{\PP^1}\otimes\Lambda_{\PP^1}=\Lambda_T\), entries in \(\Lambda_T\) so \(\chi\)
    applies entrywise, \(U_T=U_1\otimes1+1\otimes U_2\) and \(\mu_T=\mu_1\otimes1+1\otimes\mu_2\)
    so the \(z\)-connection is the tensor product, each factor a sum of rank-one pieces with
    trivial framed regular monodromy, and Levelt–Turrittin compatible with tensor products — the
    cross-reference to `prop:projective-product-nu` is accurate, that proof does assert exactly
    that. The route genuinely avoids needing \(u\ne w\): even when \(u=w\) the total module is a
    direct sum of rank-one pieces with trivial framed monodromy, notwithstanding the rank-two
    Euler block at eigenvalue \(0\). And the \(a\ge1\) branch is complete, since every rational
    geometrically ruled surface is some \(F_a\) by Grothendieck splitting.

18. **OK — hypothesis bookkeeping.** The scope "Hypothesis 5.7T only for surface centers that are
    neither minimal nor geometrically ruled" is exactly what is proved, neither weaker nor
    stronger: the direct cases cover nef-canonical targets, \(\PP^2\), positive-genus ruled
    surfaces (with 5.7R) and every \(F_a\) (graded-monomial for \(F_1\)); by Enriques–Kodaira
    those exhaust the minimal surfaces; and \(F_1\) is the only geometrically ruled surface that
    fails to be minimal, so the complement is exactly the stated class. The graded-monomial
    condition on `prop:low-dimensional-vanishing` is correctly narrowed to \(T\cong F_1\) and is
    discharged at its unique call site by `lem:center-maps-monomial`; the minimal-model branch
    never needs it, because \(F_1\) is never a minimal model. `lem:center-maps-monomial` is
    correct: the associated graded of the center coefficient ring is a Laurent monoid ring with
    monomial basis and \(\chi_j(Q_C^d)=Q^{i_*d}u^{\rho_C\cdot d}\) is one of those monomials with
    coefficient one. All eight occurrences of the scope phrase agree, subject to item 8.

19. **MINOR nits, none affecting correctness.**
    - The \(F_1\) base-case paragraph still says "a three-point invariant with two divisor
      insertions is nonzero only for \(2m+n\le2\)" without the \(\beta\ne0\) qualifier that the
      Truncation paragraph now carries; the classical terms \(\mp\mathrm{pt}\) do appear in the
      displayed answers, so the two paragraphs should be phrased alike.
    - `prop:low-dimensional-vanishing` states its hypothesis as "5.7T only for surface centers
      that are neither minimal nor geometrically ruled" while its own variable is the target
      \(T\); "for a surface \(T\) that is neither minimal nor geometrically ruled" would match.
    - \(\varepsilon\ne0\) in the family construction is used but not said (item 11 above).
    - The generator docstring's "is the general rational geometrically ruled surface" should
      read "is the general form of a rational geometrically ruled surface".

---

## Summary

Applied correctly: round-two items 4 (first sentence), 7, 8, 9, 10, 11, 13, 14 (in intent).
Applied in one of two places: item 12 (the introduction still lacks "surface" twice).
Still wrong: item 4's second sentence, in a new form — the rank-greater-than-four claim is
false for a one-point blowup of a fake projective plane.
Newly wrong: the item-14 sentence, which asserts the degenerate case never arises for a center
specialization; it is false for \(F_0\), where the manuscript's own quadric paragraph says the
opposite, and an explicit center witness is a quadric surface in a hyperplane of \(\PP^4\).

Beyond those three sentences, I found nothing in the new mathematical content that is false,
unproved, or overclaimed. The deformation, the truncation, both quartics, both discriminants,
the degeneracy dichotomy, the valuation and symbol-map arithmetic, the quadric product route,
and the hypothesis bookkeeping are all correct as written, and the certificate replays and
agrees with independent computation.
