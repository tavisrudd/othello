# C900 sealed finite-geometry re-review

Date: 2026-08-09

## Review boundary

This is a context-clean review of the current manuscript
`papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`.
I read the abstract and introduction, the conic specialization, the equality
spectra, the characteristic-two equality proof, and the even-characteristic
nucleus section.  I did not consult any dossier, prior report, synthesis,
proof audit, handoff, trust manifest, review note, classifier, Lean artifact,
or version history.

## Verdict

**GO.**  There is no actionable human-proof or exposition defect in the
reviewed scope.

## Findings

None.  In particular, there is no unsupported implication to identify; the
first potentially delicate implication, the exclusion of the
\(q=\binom{k-1}{2}+1\) even-characteristic equality branch, is supported all
the way through the sign contradiction.

## Independent checks

1. **Opening scope and terminology.**  The abstract first fixes the principal
   application to an arc disjoint from a nonsingular conic and complete on
   its complement; its subsequent characteristic-two equality claims are
   therefore scoped to zero-defect \(\mathcal C\)-complete pairs, with the
   explicit ranges odd \(k\ge 7\) and even \(k\ge 6\).  The introduction makes
   the same scope explicit again.  Definition 1.1 correctly distinguishes
   relative completeness, \(U(A)\subseteq\mathcal C\), from complete
   exteriority, \(\mathcal C\subseteq U(A)\).  It also separates this notion
   from hyperfocusedness, which constrains the focus set of secants on an
   external line rather than the full uncovered locus.

2. **Equality spectra.**  For even \(k\), putting \(Q=k-2\) gives
   \(|Z|=Q^2-1\), and the zero-defect equation gives
   \[
   s=q+1-\frac{(q-Q)(2q-Q(Q+1))}{2}.
   \]
   The bounds \(0\le s\le q+1\) leave exactly
   \(q=Q,\binom{Q+1}{2},\binom{Q+1}{2}+1\), with the stated values of \(s\).
   For odd \(k\), putting \(Q=k-1\) gives
   \(s=q-(q-Q)(q-(\binom Q2-1))\), and the same integer argument leaves
   exactly the three displayed orders and multiplicities.  The elementary
   power-of-two exclusions in the odd branch are valid.  At \(q=Q\), the
   unique zero-index point outside an oval is its nucleus, so \(s=q\) is
   equivalent to the prescribed conic containing that nucleus; the converse
   index pattern also proves relative completeness and zero defect.

3. **Nucleus parity and tangent language.**  When the conic nucleus \(\nu\)
   lies in \(A\), precisely the \(k-1\) secants joining \(\nu\) to the other
   arc points are tangent to the conic; any further such secant would contain
   three arc points.  When \(\nu\notin A\), relative completeness makes
   \(r(\nu)>0\), and the conic-tangent secants are exactly the secants through
   \(\nu\).  Hence the two congruences for \(I_{\mathcal C}(A)\) are correct.
   The manuscript consistently means tangent to the conic, not tangent to
   the arc.

4. **Chord involutions and invariance.**  For a centre
   \(R\notin\mathcal C\), pairing the two conic intersections on each line
   through \(R\), with a double tangent contact fixed, defines an involution
   on \(\mathcal C(\mathbb F_q)\).  In characteristic two the nucleus gives
   the identity, while every other centre off the conic has exactly one
   tangent and hence one fixed conic point.  If \(Y\) has maximum index, its
   secants pair all points of even-sized \(A\); the partner of any
   \(R\in A\) shows that \(\sigma_R(Y)\) lies on an arc secant, and zero
   defect raises its positive conic index to the maximum.  Thus the
   maximum-index conic set \(S\) is invariant.  The contact \(T\) of the
   chosen tangent secant has positive index and therefore belongs to \(S\).

5. **Normalization and sign contradiction.**  Sending the conic to
   \(XZ=Y^2\) and \(T\) to \((1,0,0)\) sends its tangent to \(Z=0\).  For
   \(c(u)=(u^2,u,1)\), the chord \(c(u)c(v)\) meets that tangent at
   \((u+v,1,0)\); hence a centre \((a,1,0)\) acts by \(u\mapsto u+a\).
   The nucleus is \(a=0\).  The two distinct arc points \(P,Q\) on the
   tangent have distinct nonzero parameters, so their involutions and their
   product are the three nonidentity translations with parameters
   \(a_P,a_Q,a_P+a_Q\).  Each preserves \(S\), fixes exactly \(T\), and, since
   \(|S|=k-1\equiv3\pmod4\), restricts to an odd permutation of \(S\).
   This contradicts multiplicativity of sign for the product and correctly
   eliminates the last non-hyperoval order.

## Frozen conclusion

The reviewed characteristic-two statements have the claimed hypotheses,
the terminology is not conflated, and the nucleus/involution argument is a
complete coordinate-free-to-coordinate proof.  No repair is recommended.
