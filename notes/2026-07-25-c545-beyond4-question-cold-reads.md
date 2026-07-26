# Beyond-four PRS question cold reads

**Lane:** `reed-solomon`

**Scope.** Two independent readers saw the complete 35-page draft without
prior reviews, ledgers, task records, or each other's response. Each answered:
what questions the paper begs, what its implications suggest proving next,
and what strong connections it misses. A separate read compared the bundled
Clebsch-factorization manuscript with the PRS paper.

## Immediate consequence exposed by the reads

The first reader noticed that the uniform transverse range already forces the
covering-radius equality that the draft stated conditionally. Seroussi--Roth,
Theorem 1, applied to the dual \(r\)-dimensional GRS code of length \(q+1\),
gives nonextendability. Dür's theorem, as stated in Kaipa Section IV, equates
that nonextendability with completeness of the normal rational curve and hence
\[
 \rho(\operatorname{PRS}(q+1-r))=r-1,
 \qquad r\leq\left\lfloor\frac q2\right\rfloor+2,
\]
apart from the even-field dimension-three exception. For \(r\geq6\),
\[
 Q_r=6r-15+\left\lfloor2\sqrt{6r-17}\right\rfloor
 \geq 2r-3,
\]
so \(q\geq Q_r\) implies the displayed Seroussi--Roth range and avoids the
exception. The uniform theorem therefore gives unconditional deep-hole
containment in \(\mathcal P_r\cup\mathcal M_r\), and in characteristic
greater than \(r-1\) gives the exact persistent deep-hole list.

The source was checked against the cached primary PDF
DOI `10.1109/TIT.1986.1057188`, SHA-256
`0b5c152819f91d5e410146ada3527b5b795a55fc6170c14a27e43b8c3e39a5f9`,
especially Theorem 1. Kaipa Section IV's theorem of Dür and Proposition 4(1)
supply the noncircular completeness--radius passage and the exact
Seroussi--Roth parameter range. Kaipa's Theorem 2 is not used for the radius:
at length \(q+1\), its Proposition 1 hypothesis already assumes the desired
covering-radius equality.

An extra-juice pass added the original Dür citation, DOI
`10.1016/0012-365X(94)90256-9`. Its publisher abstract confirms the
completeness criterion; the exact if-and-only-if form used in the proof is
checked in Kaipa Section IV.

## Questions ranked by expected value

1. **Exact modular membership.** Classify the split-free subset of every
   higher Lucas consecutive-support carrier, beginning with
   \(\mathbb P\langle e_2,\ldots,e_7\rangle\subset\Gamma^9E\).
   Redundancies six and seven suggest an extension-degree or subfield
   criterion, but no such theorem is known at the first fresh carrier.
2. **Stable counts and orbit counts.** State the all-level persistent count
   \(q(q+1)^2/2\), prove disjointness uniformly, and turn the
   \(T/T^{r-1}\), inversion, Frobenius, and tangent-cocycle laws into explicit
   Burnside formulas.
3. **The three R7 radius cases.** Determine the covering radii at
   \(q=7,8,9\), preferably by compact covering certificates rather than an
   ambient undocumented census.
4. **Explain R5 sporadicity.** Normalize the integral \((2,2)\) fiber-square
   curves and test whether their Jacobians, twists, Frobenius traces, or
   \(j\)-invariants characterize the sporadic fields.
5. **Improve the uniform threshold.** Replace the six-deletions-per-marker
   union bound by intersection or simultaneous-marker geometry. The opposite
   trends of the last sporadic fields \(19,13,11\) and the gates \(23,29,37\)
   show substantial slack.
6. **Scheme-level stability.** Determine whether the recursive bad ideal is
   radical after persistent/modular saturation and whether embedded primary
   structure can be excluded uniformly.
7. **Quantum equivalence at \(q=8\).** Determine the actual monomial,
   local-Clifford, and local-unitary classes among the 1116 relative
   extensions and whether sporadic versus nonsporadic type survives.
8. **Effective decoding.** Turn the recurrence/Hankel criterion and coherent
   contraction into a constructive Prony--Berlekamp--Massey-style exact
   decoder with proved complexity.

## Strong connections worth developing

- Modular \(\mathrm{SL}_2\) representation theory: Weyl and divided-power
  modules, Frobenius twists, Lucas supports, and Steinberg tensor structure.
- Linearized and subspace polynomials, with Moore determinants controlling
  rational root spaces on modular carriers.
- Degree-three Hurwitz spaces, exceptional covers, and effective
  function-field Chebotarev for the R5 cyclic/\(S_3\) split.
- Elliptic curves and cubic resolvents for the genus-one off-diagonal
  fiber square.
- Prony reconstruction, linear recurrences, and Berlekamp--Massey with
  distinct rational poles.
- Rational versus geometric symmetric-tensor rank on the secant/tangent
  varieties detected by catalecticants.
- Colon ideals, residual exact sequences, and configuration-space
  compactifications as intrinsic languages for marked contraction and
  collision boundaries.

## Clebsch-factorization comparison inside the PRS paper

The relevant theorem is not merely that the companion also uses conics.
Its matching products have a common restriction to the conic, while division
of their differences by the conic equation retains factorization memory in
the \(3,6,10\)-dimensional \(A_3,B_3,H_3\) quotient spaces; balanced cases
recover two sheets quadratically and orient them cubically. This is
complementary to coherent polar contraction: both retain factor data erased
by a natural reduction, but neither theorem is an input to the other.

The PRS introduction should state that exact comparison and cite the
companion there. Its bibliography should use the companion's current title,
*Factorization memory in a conic ideal: the \(A_3\), \(B_3\), and \(H_3\)
configurations*.

## Lean closure and final diagnostic passes

The radius inference is now formalized in
`RelativeConicArcs.PRSUniformCoveringRadius`.  Lean checks the exact integer
threshold, proves that \(r\geq6\) and \(q\geq Q_r\) imply the full
Seroussi--Roth dimension range, checks the endpoint
\((q,r)=(8,6)\), and composes the imported nonextendability and radius
implications with the existing split-free/deep interface.  The formal
structure keeps the field order, dual-GRS identification, Seroussi--Roth
implication, Dür equivalence, and concrete radius proposition separate.  Thus
the new theorem closes the inference used by the paper without representing
either cited coding theorem as kernel proved.

The Tao-style pass changes the organization of the conclusion rather than its
mathematical scope.  The natural invariant is the exact dimension range
\[
  r\leq\left\lfloor q/2\right\rfloor+2,
\]
not the sufficient inequality \(q\geq2r-3\).  Factoring the proof through that
range both captures the \(q=8,r=6\) endpoint and exposes the uniform threshold
as only one source of radius input.  It also makes clear that improving the
geometric threshold cannot improve this coding-theoretic endpoint; the two
questions have independent slack.

The extra-juice pass finds no stronger unconditional classification hidden in
the present argument.  Its useful additional consequence is architectural:
any future improvement of the transverse threshold can reuse the same radius
adapter as soon as it proves \(2r\leq q+4\).  Conversely, small fields outside
that inequality still need an independent radius certificate even if their
split-free census is complete.

The degrees of freedom are now explicit:

- the threshold and endpoint arithmetic are locked down in Lean;
- the two literature implications and the concrete code identifications are
  external semantic inputs, not proof gaps disguised as definitions;
- the geometric classification controls which split-free directions survive,
  while the coding theorem controls whether split-free means deep;
- the modular carriers retain genuine arithmetic freedom, beginning with the
  higher Lucas carrier assigned to C620.

## Post-radius full-draft cold reads

Two new readers independently read only the current 36-page manuscript after
the radius proof and Lean adapter were added.  They did not see this note,
earlier reviews, handoffs, formalization ledgers, verification maps, or each
other's report.  One read as a coding theorist and one as an algebraic
geometer.  Both answered:

1. What questions does the paper beg?
2. What does it imply that one should check or try to prove?
3. What strong connections does it miss?
4. What does it undersell?
5. What does it oversell?

### Independent consensus

Both readers ranked exact split-free membership in the higher Lucas carriers
as the strongest next mathematical theorem.  They asked for a base-\(p\)-digit
or subfield criterion, exact \(\PGL_2/\PGammaL_2\) orbit decomposition, and a
decision whether a fresh carrier contributes a whole component, a bounded
orbit set, or nothing.

Both then selected the same next cluster:

- sharpen \(Q_r\), preferably by quotienting the ordered cover or replacing
  the union-bound deletions by Chebotarev or intersection geometry;
- settle the R7 covering radii at \(q=7,8,9\);
- explain the decreasing last sporadic fields \(19,13,11\) through the
  arithmetic of the genus-one fiber square rather than raw census data;
- derive explicit Burnside formulas from
  \(T/T^{r-1}\) modulo inversion and Frobenius;
- turn the recurrence/Hankel criterion into a proved recognition or decoding
  algorithm with a complexity bound.

Both independently identified the same missed connections:

- modular \(\mathrm{SL}_2\) representation theory, Frobenius twists, Weyl and
  divided-power modules, and Lucas digit structure;
- rational squarefree apolar rank, Waring/cactus rank, secant varieties, and
  \(\operatorname{Hilb}^2(\mathbb P^1)\);
- Prony reconstruction and Berlekamp--Massey recurrence theory;
- Hurwitz spaces, exceptional covers, arithmetic dynamics, and effective
  Chebotarev for the cubic-cover and sporadic-field phenomena.

### What the draft undersells

The readers agreed that the cleanest all-level payoff is buried:
when \(q\geq Q_r\) and \(\operatorname{char}\mathbb F_q>r-1\), the
projective deep-hole count is
\[
 \frac{q(q+1)^2}{2}
\]
for every \(r\geq6\), independent of redundancy.  They also judged the marked
contraction to be a reusable coherence principle, not merely proof
bookkeeping, and found the recurrence interpretation too brief to communicate
its algorithmic meaning.  The geometry reader regarded the R5 genus-one
fiber-square argument as the conceptual heart of the fixed-level results and
thought the census tables currently receive more rhetorical weight.

### What the draft oversells or states imprecisely

Both readers warned that “complete all-field” can sound broader than the
actual “every prime power \(q\geq7\)” scope.  Both also observed that the
article alone does not display enough invariants to reconstruct the large
R6/R7 exceptional orbit lists; exactness there necessarily carries the
supplement and certificate trust boundary.  The geometry reader further
objected that “all-level irreducible-component exclusion” sounds
scheme-theoretic although the stated assertion concerns reduced irreducible
components and does not exclude embedded primary structure.

## Subsequent blind referee closure

The local defects and the two all-level proof bridges identified above were
repaired, then a fresh manuscript-only referee was commissioned.  Its first
major-revision report exposed a remaining conflation of exact-linear-gcd,
ordinary-collision, and recursively contained branches.  After the terminal
carrier, exact bottom ledger, fixed-factor transport, collision, and separate
uniform-package branches were rewritten, the referee returned **Accept** with
no remaining release-blocking proof defect.

The repair sequence, exact formal boundary, final PDF hash, and the consensus
discussion queue are recorded in
`notes/2026-07-25-c545-beyond4-referee-repair-signoff.md`.

The coding reader found two concrete local inconsistencies:

- Table `tab:classification-status` still calls the \(q\geq Q_r\) deep-hole
  conclusion conditional on radius, although the printed
  Seroussi--Roth--Dür argument now makes radius automatic.
- Section 3 says \(\dim W_f=r-3\) without first restricting to the rank-two
  Hankel locus.  A rank-one Hankel matrix has
  \(\dim W_f=r-2\); the common-quadratic hypothesis should explicitly exclude
  that case before the dimension count is used.

The introduction's final related-work sentence also calls the transverse
induction mechanism conditional, which undersells the now unconditional
threshold theorem and should be reconciled with the headline.

### Adversarial audit required for the arbitrary-level theorem

The two reports diverged in severity but not in location.  The coding reader
treated the integral bottom-component ledger and its recursive transport as
the principal referee audit burden, without identifying a contradiction.  The
geometry reader could not find two explicit bridges and would not accept the
arbitrary-\(r\) theorem until they are isolated:

1. an induction proving that every reduced irreducible component of the
   recursively pointed bad locus, including noninjective, identically
   colliding, and fresh Lucas branches, forces the asserted bottom
   catalecticant-rowspace containment and enters the finite bottom-component
   ledger;
2. one proposition instantiating the one-step lower-package hypotheses at
   every iteration, including uniform scheme-degree bounds, properness of the
   deletion schemes after specialization, and the claimed
   \(13+6(r-5)\) and \(d_j\) budgets.

These are reader objections, not established counterexamples.  They are now
release-blocking proof-audit questions: either point to the exact existing
lemmas and make the implications explicit in the manuscript, or add the
missing lemmas and proofs.  Both readers regarded the separately developed
R5--R7 classifications as substantially more secure, subject to certificate
replay and expansion of a few compressed coordinate exhaustions.

## Mystery ledger

Settled:

- The uniform radius gate is automatic for \(q\geq Q_r\); it is not an open
  premise in the all-level range. A targeted specialist confirmed the
  conclusion and repaired the proof chain to Seroussi--Roth plus Dür, avoiding
  the circular use of Kaipa's Theorem 2.
- The exact Seroussi--Roth endpoint also promotes redundancy six at \(q=8\);
  only \(q=7\) needs the finite radius certificate, while the certificate
  remains an independent \(q=8\) confirmation.
- Lean now checks the threshold-to-dimension-range implication, the
  \(q=8,r=6\) endpoint, and the logical composition of the separately supplied
  Seroussi--Roth and Dür steps.
- Clebsch factorization supplies a precise comparison about retained
  factorization data, not a proof input for the PRS classifications.
- Both readers independently selected higher modular-carrier arithmetic as
  the strongest next theorem.

Open:

- Two adversarial proof obligations for the arbitrary-level stable-component
  and uniform-threshold theorems must be closed or precisely discharged before
  release: recursive bad-locus transport to the bottom component ledger, and
  uniform instantiation of every iterated lower-package/deletion hypothesis.
- The exact split-free subset of the first fresh Lucas carrier is owned by
  C620.
- R7 at \(q=7,8,9\), explicit stable orbit counts, scheme-level radicality,
  and the elliptic explanation of sporadicity remain unallocated questions.
- A first-principles Lean development of generalized Reed--Solomon duality,
  one-coordinate MDS extension, and Dür's covering-radius equivalence is
  outside the present formal boundary; the paper now says so exactly.
- The public Version 1 release gates remain owned by C545.
