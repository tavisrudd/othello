# Cold referee report on *The Discriminant Resolvent of the \(A_5\)-Cubic Pencil*

**Date:** 2026-08-21  
**Mathematical lens:** Bert van Geemen  
**Material reviewed:** the current nine-page PDF, the complete TeX source, the three tracked verification scripts and their checked outputs, and the cited primary sources needed to test the load-bearing bridges.  I did not consult task cards, prior reports, strategy memoranda, claim ledgers, git history, or earlier reviews.

## Recommendation

**Not publishable in the current form; invite a substantially revised resubmission.**

The finite resolvent and modular-curve core is strong and, as far as I can tell, correct.  The central geometric assertion that makes it a theorem about the *actual* cubic-threefold gluing packet is not yet proved by the cited source or by the manuscript: van Geemen--Yamauchi prove an isogeny to the invariant elliptic factor, whereas Proposition 3.1 asserts a relative degree-one polarized isomorphism with the programme's primitive norm axis.  The intervening polarization and specialization argument is only stated.  Since the abstract and Theorem 1.1 explicitly distinguish this result from a mere coincidence of \(j\)-invariants, this is fatal to the present proof, even though it looks potentially repairable.

There is also a major local gap in the chordal argument: the special fibre is asserted, rather than proved, to have the indicated rational normal quartic as its full singular scheme and to be its secant cubic.  The cited published version of ACT does supply the subsequent transversality and normal-space statement.  Corollary 5.2 then needs only a short explicit equivariance/no-character/orbit-size argument.  These issues do not undermine the modular calculation, but the first prevents acceptance of the boundary theorem as written.

My confidence in this recommendation is **high (0.88)**.  My confidence that the main geometric claim is false is low; my finding is that the present sources and proof do not establish it.

## Claimed contribution in one sentence

The paper identifies the three rational and two golden members of the \(A_5\)-stable principal-kernel packet with the root and sign resolvents of the ordered nonzero two-torsion torsor on the cubic family's actual relative elliptic norm axis, and then gives its level-six modular and chordal-boundary geometry explicitly.

## Reconstructed dependency chain

1. A programme input supplies a relative elliptic norm axis \(\mathcal E\), a polarized six-axis isogeny to the intermediate Jacobian, the five-sheet local system
   \[
   \mathscr P=\mathbf P_{\mathbf F_4}(\mathbf F_4\otimes_{\mathbf F_2}\mathcal E[2]),
   \]
   and an actual two-primary kernel section lying in the golden pair.
2. The elementary five-set lemma decomposes \(\mathscr P\) into \(\mathbf P(\mathcal E[2])\) and its two-point complement, and identifies the latter with the sign torsor of the root triple.
3. The van Geemen--Yamauchi quotient gives an explicit elliptic curve with the displayed \(j\)-function.  Proposition 3.1 is meant to identify this curve, with polarization and marking, with the programme's actual \(\mathcal E\).
4. After \(T=81t^2\), the curve is put in a level-three Tate form.  Reduction of \(\Gamma_0(3)\) modulo two then identifies the root, sign, and splitting covers with the point stabilizer, sign kernel, and full kernel.
5. The explicit \(v,y,r,T\) equations determine connectedness, cyclicity after oriented pullback, ramification, and exact \(A_3\) monodromy on the punctured signed cubic line.
6. Cusp and elliptic stabilizers determine the compact passports and separate modular cusps from the two extra cubic boundary values.
7. At the chordal value, after identifying the special fibre with the secant cubic of its rational normal quartic, the exact orbit-and-ideal computation and published ACT Lemma 2.5 prove transversality and identify the twelve branch points; the general chordal degeneration theorem then gives the hyperelliptic limit, and Paulhus supplies its elliptic-power isogeny decomposition.
8. Corollary 5.2 attempts to upgrade the twelve-point divisor to uniqueness of the \(A_5\)-fixed first-order normal direction.

Items 3 and 7 are not currently closed.  Item 8 needs only the explicit final equivariance and orbit argument recorded in F4.

## Findings

### F1. Fatal: the actual-axis polarized comparison is not established

**Location.** TeX lines 246--306, especially Proposition 3.1 and its proof at lines 273--307.  The theorem-level consequences occur at lines 105--126 and 443--452.

**Exact evidence.**

- The manuscript asserts the coordinate bridge \(u=ct\), \(c^2=5\), at lines 246--248 without giving the Fourier transformation from the six-variable cubic to the van Geemen--Yamauchi model.
- It then asserts that the van Geemen--Yamauchi elliptic curve maps *isomorphically as a polarized elliptic scheme* to the primitive norm axis (lines 273--284).
- The proof says that the cited degree-five quotient construction gives a pullback map, that pullback followed by norm is \([5]\), that both relevant induced polarizations are five times a primitive principal polarization, and hence that the intervening isogeny has degree one (lines 287--297).  None of those polarization identities is derived in this paper.
- Van Geemen--Yamauchi, Proposition 3.2, states only that their explicit elliptic curve is **isogenous** to the elliptic factor of the intermediate Jacobian.  Its proof identifies the invariant tangent eigenspace and handles an exceptional smooth parameter by Néron models; it does not state the degree-one polarized comparison claimed here.  Proposition 2.1 identifies the whole intermediate Jacobian with a Prym as a principally polarized abelian variety, but it does not by itself compute the restriction of that polarization to the elliptic quotient.
- Lines 299--306 also assert an explicit quadratic twist and preservation of the cyclic level-three marking, but neither the change of variables nor the marked subgroup is displayed.  The verification script recomputes the \(j\)-function after *assuming* \(u^2=5t^2\); it does not verify the coordinate bridge, the twist, the Prym map, either polarization identity, the degree, or extension over the exceptional parameter.

This is not a cosmetic strengthening.  Equality of \(j\)-maps gives only an elliptic isomorphism class over an algebraic closure; an eigenspace gives only an isogeny factor.  The paper's root and sign local systems concern the programme's actual \(\mathcal E[2]\), so an unidentified odd- or even-degree isogeny can change precisely the level structure the theorem claims to determine.

**Concrete repair.** Replace the present paragraph proof with a proposition containing the following data and proof.

1. Define the common marked base and the chosen \(D_5\) (or order-five) marking precisely, and write the full quotient/Prym diagram over that base.
2. Construct the relative homomorphism
   \[
   \phi:E_{\mathrm{VGY}}\longrightarrow \mathcal E^{\mathrm{im}}\subset\mathcal J
   \]
   rather than inferring it from a common eigenspace.
3. Prove, as identities of relative polarizations, both
   \[
   \phi^*(\Theta|_{\mathcal E^{\mathrm{im}}})=5\lambda_{E_{\mathrm{VGY}}},
   \qquad
   \Theta|_{\mathcal E^{\mathrm{im}}}=5\lambda_{\mathcal E},
   \]
   and then spell out the degree computation forcing \(\deg\phi=1\).
4. Treat separately every smooth parameter at which the auxiliary quotient curve degenerates, following the Néron-model specialization step in van Geemen--Yamauchi Proposition 3.2.  State whether the result is over the base, after a fifth-root marking, or only after geometric base change.
5. Display the coordinate transformation proving \(u^2=5t^2\), and either display the \(c_4,c_6\) comparison producing \(D(T)\) or include it in a checkable lemma.  Identify the cyclic order-three subgroup under that comparison, not just the elliptic \(j\)-class.

Until those points are supplied, Theorem 1.1(1), the identification in (3), and transport of the exact monodromy statement in (5) do not follow for the actual norm axis.

### F2. Major: the programme input is too compressed and conflates a packet of candidates with the actual kernel

**Location.** TeX lines 89--99, the abstract's opening sentence, and the uses at lines 443--452.

**Exact evidence.** The paper says only that the six axes “form one relative elliptic norm axis” and that two named results in another preprint identify “the five principal kernels” with \(\mathscr P\).  The cited source actually distinguishes:

- an elliptic scheme over a connected smooth marked base;
- a relative \(A_5\)-equivariant isogeny from the fivefold six-axis source;
- the pullback polarization \(6I-J\);
- its two-primary discriminant local system;
- the five *possible* \(A_5\)-stable maximal isotropic halves; and
- the actual kernel section, which lies in the exotic pair and therefore trivializes the pulled-back sign torsor.

Those distinctions are load-bearing for Theorem 1.1(2) and (5).  As written, “five principal kernels” can be read as five simultaneous kernels of the intermediate-Jacobian isogeny, whereas the geometry supplies one actual kernel and a five-sheet parameter space of possible stable halves.  The present paper also does not state the base, polarization type, finite-flatness, or monodromy convention of the imported result.

**Concrete repair.** Insert a compact “programme input” proposition before Theorem 1.1.  It should name the base \(B^\circ\), the relative intermediate Jacobian, \(\mathcal E\), the isogeny
\(f:\mathcal E\otimes(\mathbf Z^\Omega/\mathbf Z\mathbf1)\to\mathcal J\), the identity \(f^*\lambda_\Theta=\lambda_{6I-J}\), the identification of the two-primary discriminant with \(H_2\otimes\mathcal E[2]\), and the five-sheet *candidate* packet.  It should then state separately that \(\ker(f)_{(2)}\) is a section selecting an exotic sheet.  Cite the precise source results at the end.  Reword the abstract to “a five-sheet packet of principal gluing kernels” or “five possible principal kernels.”

### F3. Major: the special chordal fibre is not independently identified

**Location.** TeX lines 510--580, especially lines 560--579.

**Exact evidence.**

- The table at lines 510--523 asserts that \(t^2=9/5\) is chordal.  The proof then sets
  \(C=\operatorname{Sing}(X_{t_0})\) and calls it a rational normal quartic (lines 560--564), but gives no parametrization, Jacobian-ideal calculation, or citation proving that the *full singular scheme* is that curve.
- The tracked certificate verifies twelve distinct orbit points, their singularity, \(Q=0\), the rank of evaluation on those points, and \(Q\notin I_Z(2)\cdot H^0(\mathcal O(1))\).  It does not verify that the singular ideal of \(X_{t_0}\) equals the ideal of a rational normal quartic, nor that the special cubic is its secant variety.  Thus the inclusion \(I_C(2)\subset I_Z(2)\), on which the rank argument depends, still uses an unproved geometric premise.
- The citation at lines 577--580 is correct for the **published Memoirs version**.  Its treatment on printed pages 18--20 (PDF pages 27--29), including Lemma 2.5 on pages 19--20, proves that a pencil through a chordal cubic is transverse exactly when some member restricts nontrivially to its singular rational normal curve.  It also proves, using
  \(\operatorname{Sym}^3\operatorname{Sym}^4(\mathbf C^2)\), that the kernel of restriction of cubic forms to the curve is exactly the tangent space to the chordal locus.  The arXiv preprint has different numbering: its Lemma 2.5 is the unrelated monodromy-reflection statement.  Since the bibliography cites Memoirs AMS 209 (2011), no. 985, the manuscript's citation is valid.
- CMGHL Remark 1.8 does support the subsequent statement that a transverse chordal degeneration with twelve distinct branch points limits to the corresponding genus-five hyperelliptic Jacobian.

**Concrete repair.** Give an explicit parametrization \(\nu_4:\mathbf P^1\to\mathbf P(W)\) for the singular quartic at \(t_0\) and prove
\[
\operatorname{Sing}(X_{t_0})=\nu_4(\mathbf P^1)
\]
scheme-theoretically, together with \(X_{t_0}=\operatorname{Sec}(C)\).  This may be a short exact ideal calculation, but it must appear in the prose and, if delegated to computation, the certificate must check equality/radicality with a stated trust boundary.  Once that premise is supplied, published ACT Lemma 2.5 and the existing rank calculation prove transversality and show that the branch divisor is the reduced twelve-point orbit.

### F4. Minor: Corollary 5.2 suppresses the final equivariance and orbit argument

**Location.** TeX lines 596--611.

**Exact evidence.** Published ACT Lemma 2.5 proves equivariantly that restriction to the rational normal quartic has kernel equal to the tangent space to the chordal locus.  Thus it supplies the normal quotient used at line 608; projective normality is not being asked to prove this alone.

What remains implicit is a small representation-theoretic point.  An \(A_5\)-stable projective line can carry a scalar character.  Here \(A_5\) is perfect and hence has no nontrivial complex characters.  In any event, even a semi-invariant section has invariant zero divisor, so the divisor argument can be phrased entirely projectively.  Finally, “necessarily its unique orbit \(Z\)” uses the classification of icosahedral orbit sizes \(12,20,30,60\), which should be stated or cited.

For reference, the relevant quotient is
\[
H^0(\mathbf P^4,\mathcal O(3))\longrightarrow H^0(C,\mathcal O_C(12))
\]
with kernel \(I_C(3)\), now identified by ACT with the tangent kernel.

**Repair.** Explicitly invoke the equivariant normal quotient in published ACT Lemma 2.5.  Then say: an invariant projective normal line is represented by a semi-invariant section; since \(A_5=[A_5,A_5]\), its character is trivial (or work projectively with its invariant divisor); the nonzero icosahedral orbit sizes are \(12,20,30,60\), so an effective invariant divisor of degree twelve is the unique reduced orbit of length twelve.  This proves uniqueness without a hidden character convention.

### F5. Minor: the source attribution for the explicit Weierstrass coefficients is imprecise

**Location.** TeX lines 237--245.

The displayed coefficients occur in the proof of van Geemen--Yamauchi Proposition 3.1; Proposition 3.2 is the later isogeny statement.  Cite both statements according to their actual roles.  This matters because the current citation encourages the reader to attribute more geometric content to Proposition 3.2 than it contains.

### F6. Minor: stack/coarse language is basically correct but should be made uniform

**Location.** TeX lines 109--124, 337--356, and 454--480.

The subgroup computation is correct.  The sign subgroup has index two in \(\Gamma_0(3)\), contains the order-three elliptic stabilizer, doubles the two cusp widths, and gives a genus-zero coarse curve with two order-three elliptic points.  The root subgroup is \(\Gamma_0(6)\), and the normalized fibre product has full mod-two kernel.  The manuscript also correctly says that the sign map is ramified only at the cusps **as a coarse map**, and correctly declines to identify the compact cubic pencil with the modular stack.

The phrase “coarse orbifold \(X_0(3)\)” at line 456 mixes two levels.  State once that the subgroup square is a square of analytic orbifold/modular stacks on the smooth moduli locus, while equation (4.1) is its normalized coarse square; then give the coarse ramification separately.  This would make an already sound distinction unambiguous.

### F7. Minor: the verification script's sign check does not test the stated parity assertion directly

The prose proof of Lemma 2.1 is correct.  In `resolvent_identities.py`, however, the transposition is encoded as the product \((0\ 1)(\omega\ \omega^2)\), and the script checks that this total permutation is even.  The lemma needs the induced permutations on the three-set and two-set to have the same sign; each is odd.  The tuple equality indirectly displays this, but the asserted parity test is not the mathematical assertion in the prose.  Replace it by separate parity assertions for the two restricted actions.

### F8. Optional strengthening: display the three-level cover diagram

A single diagram should distinguish the universal ordered \(E[2]\) torsor over the level-three modular base, its root/sign quotients, and their pullback to the signed cubic base.  This would show at a glance that the universal sign cover is connected, while its oriented cubic pullback is split and the pulled-back root cover is connected cyclic of degree three.

## Explicit audits requested

### Actual-axis polarized comparison

**Fails in the present proof.**  This is F1.  The cited primary paper supplies the Prym ppav and an isogeny class, not the degree-one relative polarized identification.  The special-parameter extension and marked level-three comparison are also absent.

### Programme-input self-containment

**Insufficient.**  This is F2.  The paper needs a precise imported proposition separating the five candidate halves from the one actual kernel section.

### Universal versus oriented pullback

**Passes.**  The universal sign cover has function field \(\mathbf Q(T)(\sqrt T)\) and is connected.  Pullback by \(T=81t^2\) splits it, with the two identifications \(r=\pm9t\).  Over either oriented sheet the root cover is the connected regular \(A_3\)-cover; the Kummer equation proves total ramification at the two removed lifts of \(T=-27\).  The text is unusually careful about the noncanonical deck choice.

### Stack/coarse and connected/split distinctions

**Mathematically passes, with the minor terminology repair F6.**  The normalized coarse square, cusp ramification, retained elliptic stabilizers, and the warning that the cubic compactification is not the modular stack are all correct.  Connectedness of the cyclic cubic is proved group-theoretically and by the explicit function field, rather than inferred from containment in \(A_3\).

### Modular subgroup and cusp computations

**Passes.**  The two displayed transvections generate \(\mathrm{SL}_2(\mathbf F_2)\); the point stabilizer is \(\Gamma_0(6)\) modulo level six; the sign/root intersection is \(\Gamma_0(3)\cap\Gamma(2)\).  Cusp widths are \(2,6\) on the sign cover, \(1,2,3,6\) on \(X_0(6)\), and \(2,2,2,6,6,6\) on the split cover.  The genus calculations agree with the subgroup indices and elliptic stabilizers.  The eta normalization \(h=729/T\) and the resulting \(t=3(\eta(3\tau)/\eta(\tau))^6\) are consistent with the stated deck convention.

### Chordal transversality and Corollary 5.2

**Partially passes.**  Conditional on the missing identification of the special fibre as the secant cubic of its full singular rational normal quartic (F3), the exact rank argument proves that \(Q|_C\) has the reduced twelve-point orbit as divisor.  Published ACT Lemma 2.5 correctly supplies both transversality and the equivariant normal quotient.  CMGHL then gives the hyperelliptic limit, and Paulhus Theorem 2 gives precisely the displayed \(E^5\) isogeny.  Corollary 5.2 needs only the short no-character and icosahedral orbit-size explanation in F4.

### Computation trust boundaries

The SHA-256 manifest verifies all six tracked scripts/outputs.

| Artifact | What it does certify | What it does not certify |
|---|---|---|
| `resolvent_identities.py` | Exact simplification of the VGY \(j\)-formula after the stated substitution; Tate invariants; two-division discriminant; root/sign/splitting equations; Kummer ramification and deck map | The Fourier coordinate bridge \(u^2=5t^2\); the actual-axis map; polarization degrees; the quadratic-twist change of variables; the marked cyclic order-three subgroup; any moduli identification |
| `subgroup_check.py` | The finite level-six quotient sizes, point stabilizer \(=\Gamma_0(6)\) modulo six, sign/root intersection, regular \(C_3\) action | Cusp widths, elliptic stabilizers, genus, stack/coarse local structure; these are instead proved correctly in prose |
| `chordal_transversality.py` | Exact \(A_5\) orbit size; singularity and \(Q\)-vanishing at the twelve points; evaluation ranks; \(Q\) outside the cubic ideal generated by the six quadrics through the orbit | That the full singular scheme is a rational normal quartic; that the cubic is its secant variety; the externally imported ACT normal/transversality theorem, CMGHL degeneration, or Paulhus isogeny |

The prose currently oversteps the first trust boundary and the special-fibre part of the third.  The remaining third-row items are legitimately supplied by the cited published sources rather than by computation.

## Strongest passages

1. **Lemma 2.1 and the torsor-class discussion.**  The \(\mathbf P^1(\mathbf F_4)=\mathbf P^1(\mathbf F_2)\sqcup\{\omega,\omega^2\}\) computation is short, canonical at the torsor level, and careful about the two noncanonical sheetwise identifications.
2. **The modular subgroup square.**  The point-stabilizer, sign-kernel, and full-kernel subgroups are derived from the mod-two representation rather than guessed from rational functions.  The equations then give a useful independent realization.
3. **The oriented cyclic cover.**  The Kummer identity, rational deck transformation, two branch points, inverse local monodromies, and effect of golden reversal form a compact and convincing package.
4. **Cusp versus cubic boundary.**  The paper clearly distinguishes \(T=0,\infty\) from the modular-interior cubic degenerations \(T=-27,729/5\).  This is mathematically useful and well presented.
5. **The conditional chordal rank argument.**  Once the special fibre's singular quartic is established, equality of quadratic ideals followed by \(Q\notin I_C(3)\) is an efficient exact proof that the transverse divisor is the reduced icosahedral orbit.

## Primary-source checks

- B. van Geemen--T. Yamauchi, *On intermediate Jacobians of cubic threefolds admitting an automorphism of order five*, arXiv:1506.05346, cached SHA-256 `f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed`: Proposition 2.1 gives the Prym identification as ppav; Proposition 3.2 gives only an isogeny of the explicit elliptic curve with the invariant factor and handles an exceptional parameter by Néron models.
- D. Allcock--J. Carlson--D. Toledo, *The Moduli Space of Cubic Threefolds as a Ball Quotient*, Memoirs AMS 209 (2011), no. 985, author-hosted published PDF `https://web.ma.utexas.edu/users/allcock/research/threefolds.pdf`, SHA-256 `f23841273af65b47ed26dce070c4d4adfa0f962b48246b5e030750e0df193651`: the discussion on printed pp. 18--20 / PDF pp. 27--29, especially published Lemma 2.5, proves the chordal transversality criterion and identifies the tangent kernel of restriction via the \(\operatorname{Sym}^3\operatorname{Sym}^4\) decomposition.  The cached arXiv preprint, arXiv:math/0608287, SHA-256 `a2b455c771d3bf3d9e69cd85bb672e86b57fa2d60bb3815abd577b592f1afe21`, has different numbering; its Lemma 2.5 is unrelated.  The manuscript cites the published Memoirs version and is correct.
- S. Casalaina-Martin--S. Grushevsky--K. Hulek--R. Laza, *Complete moduli of cubic threefolds and their intermediate Jacobians*, arXiv:1510.08891, cached SHA-256 `d5b3c69094eee70d5486542952f394308e3aa4bdbc5762a85588ebae4b2d7753`: Remark 1.8 supports the genus-five hyperelliptic Jacobian limit from twelve distinct branch points.
- J. Paulhus, *Elliptic factors in Jacobians of hyperelliptic curves with certain automorphism groups*, DOI 10.2140/obs.2013.1.487, cached SHA-256 `d45781c71c6f655acb795fbfb3d79402f39965ee75c2739aaff1432d549b0261`: Theorem 2 matches the displayed genus-five curve and \(E^5\) isogeny.

## Bottom line

The manuscript has a publishable modular-resolvent calculation inside it, and its best sections are both exact and conceptually clean.  Under the van Geemen lens, however, the key distinction is between an elliptic isogeny factor and the actual polarized norm axis.  The paper announces that distinction correctly but has not yet proved it.  Closing F1 is the acceptance gate; F2 and F3 are the remaining major repairs, and F4 is a short but worthwhile completion of the boundary corollary.
