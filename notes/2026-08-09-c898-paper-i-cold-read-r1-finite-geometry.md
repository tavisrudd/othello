# C898 Paper I cold read, round 1 — finite-geometry persona

**Initial human-proof report frozen before supplement inspection:** 2026-08-09

**Persona packet:** Packet S, finite-geometry persona (Storme/Szőnyi packet),
constructed from published conventions rather than impersonating either scholar.

**Frozen PDF:** `papers/clebsch-rigidity/clebsch_rigidity.pdf`

**PDF SHA-256:**
`95ccf1ff32180fd806608002d69a912c5a1aae26a8fb5778d553a88b62803d83`

**Categorical verdict:** **MAJOR**

## Strongest theorem I believe the paper proves

The order-eleven rigidity theorem is convincing: for a six-arc
\(A\subset\operatorname{PG}(2,11)\), containment of its uncovered locus in any
quadratic zero set already forces the unique Clebsch projective class, and then
the uncovered locus is the full rational point set of the associated nonsingular
conic.  The accompanying fixed-conic orbit statement follows.  The chord-defect
identity and the conic-filling field window also survive this read.  This judgment
does not include Proposition 2.2's asserted stabilizer in characteristic five.

## Causal proof reconstruction

For six points the universal chord count gives
\(|U(A)|=22-c(A)\), because an off-arc point lies on at most three chords and
the defect is exactly the number of triple-chord concurrences.  Dye's quadrangle
argument bounds \(c(A)\leq 10\), hence \(|U(A)|\geq12\).  If \(U(A)\) lies on a
conic, a nonsingular conic has twelve rational points; a degenerate conic has its
rational points on at most two rational lines (or only its singular point), and
Lemma 4.1 bounds each line's uncovered contribution by six.  Thus
\(|U(A)|\leq12\), equality holds, and \(c(A)=10\).  Dye's equality
classification then puts \(A\) in the Clebsch orbit.  Its fifteen joins are
passants to Dye's associated conic, so all twelve conic points are uncovered;
the count makes this inclusion equality and Bezout excludes a different
degenerate containing conic.

The line bound has the right multiplicities: intersections of the fifteen
chords with a line disjoint from the arc are color classes of edges of \(K_6\),
with at most three disjoint edges per point.  Equality at five classes would be
a one-factorization, and the displayed affine normalization makes three of its
directions force \(2xy=0\), impossible in odd characteristic.  The universal
defect identity likewise follows by counting chord--point incidences and pairs
of disjoint chords; its correction term has the stated sign.

For the field window, a conic-filling arc has every chord passant.  The
\(k-1\) chords through a vertex are bounded by the maximum number
\((q+1)/2\) of passants through an off-conic point, giving
\(q\geq2k-3\).  The chords cover the conic complement, so Blokhuis--Brouwer--
Szőnyi Proposition 1.6 gives
\(\binom{k}{2}\geq3(q-1)/2\), hence the upper bound.  The even-order exclusion
uses the oval nucleus correctly.

## Earliest unsupported implication

The first implication I cannot justify is in Proposition 2.2's stabilizer
paragraph: the manuscript says that the relabelling map exchanges the two roots,
so the stabilizer has index two in the order-120 combinatorial group and is
\(A_5\), uniformly in odd characteristic.  In characteristic five the two roots
coalesce and the displayed matrix has determinant
\(\varphi-\bar\varphi=0\), so it is not a projectivity and the asserted
surjectivity does not exist.  Dye's Theorem 3 explicitly gives the larger
stabilizer \(S_5\) in characteristic five.

## Controlling findings

1. **Proof / citation — false characteristic-five stabilizer.** Proposition 2.2
   and Remark 2.3 assert \(A_5\) in every odd characteristic, contrary to Dye's
   Theorem 3, which has the explicit characteristic-five exception \(S_5\).
   The manuscript's own proof fails there because its root-exchanging matrix is
   singular.  This is a false theorem-level field-family clause, not merely an
   omitted citation qualification.  State \(S_5\) in characteristic five and
   \(A_5\) otherwise, and audit every later use of the uniform assertion.

2. **Novelty/significance — the order-eleven equality case has a close
   symmetry-free predecessor.** Blokhuis--Seress--Wilbrink report a computer
   classification, up to isomorphism, of complete exterior sets at \(q=11\):
   exactly one six-arc and one Pasch configuration.  Consequently the condition
   \(U(A)=C(\mathbb F_{11})\), together with the arc hypothesis, was already
   classified without assuming \(A_5\).  The genuinely new finite-geometry
   claim should be delimited as the conceptual passage from mere conic
   containment to equality/Clebsch rigidity, plus the concurrence spectrum and
   uniform field window, rather than the whole symmetry-free criterion.

3. **Citation / normalization — the predecessor's equivalence relation needs an
   explicit bridge.** The paper says the arc hypothesis “selects the Clebsch
   branch” from the Blokhuis--Seress--Wilbrink list, but does not state whether
   their “up to isomorphism” is projective equivalence under the fixed conic's
   stabilizer, nor prove in that paragraph that their unique six-arc is the
   displayed Clebsch orbit.  Either give that bridge precisely or weaken the
   historical inference.  This matters both to Corollary 4.2's novelty boundary
   and to the claimed reconstruction equivalence.

4. **Citation / exposition — the Storme--Van Maldeghem incompleteness citation is
   indirect.** Proposition 13 classifies complete two-transitive arcs and omits
   the order-eleven six-arc; it does not literally state “the arc is incomplete
   at \(q=11\).”  The inference is valid only after recalling that the displayed
   \(K_2\) has the required two-transitive \(A_5\)-action.  Add that sentence or
   cite a source that states incompleteness directly.

## Novelty relative to Packet S

Relative to the packet, the defensible new finite-geometry content is the
conceptual conic-containment-to-Clebsch implication, the seven-value concurrence
spectrum, and the uniform conic-filling field window; the exact order-eleven
complete-exterior six-set classification is already present computationally in
Blokhuis--Seress--Wilbrink.

## Initial verdict rationale

**MAJOR.** The central order-eleven inverse argument is strong and appears
correct, but an advertised uniform theorem is false in characteristic five and
its proof fails for a visible algebraic reason.  Correcting that theorem and
tightening the predecessor boundary are acceptance gates; neither changes the
order-eleven rigidity proof.

## Public-supplement postscript

After freezing the report above, I inspected only
`papers/clebsch-rigidity/verification/`, as permitted by the dossier.  Its trust
manifest records a kernel-checked order-eleven containing-quadratic rigidity
implication, which reinforces the initial conclusion that Theorem 1.1's finite-
geometry spine is sound.  It does **not** resolve Finding 1: for the statement
group containing Proposition 2.2, the only listed Lean terminal proves the
uncovered-locus polynomial, while the golden normal form is left conceptual and
the characteristic-five stabilizer is not checked.  The manifest cites Dye's
Theorem 1 and edge criterion for that row but supplies no verification of the
uniform stabilizer clause.  The supplement likewise does not settle the
historical equivalence issue in Findings 2--3 or make the indirect citation in
Finding 4 explicit.  The verdict therefore remains **MAJOR**.
