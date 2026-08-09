# C756 all-\(k\) status and assumption audit

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** consolidated
research status; no manuscript edit

## Verdict

The all-\(k\) conjecture remains plausible, but the recorded nonsaturated
program was materially narrower than the theorem.  Its defect-two star model
starts with a hypothetical **all-internal** arc and therefore gives an
all-passant dual arrangement.  No recorded theorem says that a nonsaturated
conic-filling arc must be all-internal, all-external, or even of one point
type.  The saturated dichotomy proves uniform type only in the saturated
branch.

Consequently the exact \(q=53\) aligned computation is valid and useful, but
it closes only a conditional subbranch:

\[
 \text{all-internal at }(q,k)=(53,12),\quad
 \text{all-passant dual arrangement},\quad
 \text{aligned anisotropic covariance}.
\]

It does not close the nonsaturated \(q=53\) case, and \(q=53\) is not the
first unclassified field.  At \(k=12\), the first open defects are

\[
 (q,\delta)=(47,8),(49,6),(53,2),
 \qquad \delta=\binom{11}{2}-q.
\]

The live C756 card and lane maps are replaced with that correction.  The
highest-EV next step is a point-type-stratified nonsaturated reduction before
more work on the conditional nonaligned Gram system.

## 1. What is theorem-grade now

### Universal reductions

For a nonsingular conic \(C\), the assertion that the uncovered locus of an
arc \(A\) is exactly \(C\) is equivalent to:

1. every chord of \(A\) is external to \(C\); and
2. the chords cover every point off \(C\).

Even characteristic is impossible because the conic nucleus cannot be
covered by an external chord.  In odd characteristic, chord externality is
the fixed quadratic-character condition on the binary-quadratic resultant.
The covering LP and the spare-external-line argument are uniform in \(k\).
The latter gives the exact alternative:

- nonsaturated: \(\binom{k-1}{2}\ge q\), sharpened by the direction quotient
  to \(\binom{k-1}{2}\ge q+2\); or
- saturated: every arc point has the same conic type, with
  \(k=(q+1)/2\) in the all-external case and \(k=(q+3)/2\) in the
  all-internal case.

The exact bounded classification covers every \(k\) over every odd prime
power \(q\le43\).  Only the \(q=5\) projective four-frame and the \(q=11\)
Clebsch hexagon occur.

### Saturated-external

This branch is closed uniformly.  An exterior set of \((q+1)/2\) external
conic points that is an arc occurs only for \(q\in\{3,7,11\}\), in one
conic-stabilizer orbit per field; covering selects the \(q=11\) hexagon.
The proof was independently cold-read.  Publication and specialist safeguards
belong to C894, not C756.

### Saturated-internal

For \(q=2m-1\), polarity turns a hypothetical example into \(m+1\) passants
in dual-arc position.  Their pairwise intersections form an internal star
configuration \(\mathcal B(Y)\), and covering is exactly the assertion that
\(\mathcal B(Y)\) meets every secant and every passant.  Tangents avoid it.

The following necessary structure is exact:

- the line-profile identity, excluding \(q=7\);
- the certified diagonal allocation, excluding the rigid \(q=9\) profile;
- the positive global quadrangle bias forced by covering;
- signed spectral balance and the outside matching tight frame
  \(R^{\mathsf T}R=(m-2)((m+1)I-J)\);
- the dual star-blocking formulation.

What is not proved is the final global incompatibility: for \(q>5\), a
coherent dual star in this class must miss some non-tangent line.

### Nonsaturated, with its proper condition

Deleting an arc point \(P\) and choosing a spare external line gives the
direction factorization

\[
 D_P(T)=(T^q-T)E_P(T),\qquad
 \deg E_P=\delta=\binom{k-1}{2}-q.
\]

The defect-zero and defect-one cases are excluded.  This conclusion does not
depend on a uniform point type.

The later star, separator, covariance, torus, and aligned computations do.
They begin with an all-internal arc, whose polar lines are all passants and
whose pairwise polar-line intersections are internal.  Within that conditional
model at \((53,12)\):

- all sixteen spare internal centers force the moment collapse through
  degree fifteen;
- rank-zero and rank-one covariance are excluded by degree-nine node
  separators;
- nonsingular covariance yields the rank-two critical system
  \(\nabla\mathcal Z=0\) with nonzero off-diagonal separator Hessian;
- elliptic overlap reduces anisotropic covariance to the aligned case or
  traces \(-10,-14\), and split covariance to seven trace/zero rows;
- the aligned case is closed exactly: split offset descent has no admissible
  eleven-state clique, while trace-zero descent has 44 normalized candidates
  in four dihedral orbits and all fail all eleven critical equations after
  the center shift is recovered.

Those are real theorems and certified finite results.  Their quantifier is the
all-internal/all-passant conditional subbranch.

## 2. Assumptions currently in play

### Reasonable working hypotheses, not conclusions

1. **The masked Rédei quotient should have a uniform obstruction for
   \(h\ge1\).**  This is a good target because it would feed the defect squeeze,
   but no bounded-degree carrier has yet been found.
2. **The star realization should be much more rigid than an arbitrary near
   transversal.**  Arbitrary internal near transversals exist, so the star
   equations are genuinely necessary.  Their sufficiency for a contradiction
   is still unknown.
3. **Nonzero separator Hessian plus forced character data should cause a
   collision or zero.**  The aligned search supports this mechanism, but the
   nonaligned and split rows are not proved inconsistent.
4. **The theorem is true.**  The known endpoints, uniform reductions, and
   saturated-external theorem support it.  The bounded data do not make a
   counterexample remote enough to treat truth as an input.

### Unproved assumptions that had leaked into the route

1. **A nonsaturated counterexample can be taken all-internal.**  No such
   reduction is recorded.  External and mixed-type arc points remain open.
2. **The polar arrangement consists only of passants.**  This follows from
   all-internal primal points, not from nonsaturation.  External primal points
   polarize to secants, so a mixed arc gives a mixed secant/passant
   arrangement and different node-character formulas.
3. **\(q=53\) is the first open or representative case.**  It is only the
   first defect-two case.  Fields \(47\) and \(49\) are already beyond the
   exhaustive classification and have defects eight and six.
4. **Closing defect two will propagate to every \(\delta\ge2\).**  This is
   the intended use of a masked Rédei theorem, not a theorem presently in
   hand.
5. **The smallest defect is necessarily the hardest or most dangerous.**  A
   larger defect has less moment rigidity, and a counterexample could first
   occur at \(47\) or \(49\).
6. **Degree sixteen should never be crossed.**  Degree sixteen is merely the
   first mask not controlled by the current centerwise moments.  Blindly
   computing higher masks is low value, but a degree-sixteen cross-center
   identity could be exactly the missing invariant.
7. **The remaining covariance rows are the next unconditional frontier.**
   They are the next frontier only inside the all-internal \(q=53\)
   subbranch.

### Ideas that evidence has already weakened or falsified

- A local diagonal-sign contradiction does not exist in the proposed form:
  all diagonal types occur, and positive coherent bias occurs from \(q=17\).
- The abstract signed matching frame is not known to be impossible for
  \(m>3\); the frame identities alone are necessary, not contradictory.
- The self-dual signed incidence/Smith-torsion route supplied no finisher; in
  the tested fields its nonzero Smith invariants are all one.
- One- and two-slice Rédei selectors largely repackage the old
  matching-composite gate.
- “Counting cannot close, and no refinement can” was too strong.  Untyped
  low moments did stall, but structured counting later produced moment
  collapse, positive \(T_4\) bias, and the matching tight frame.

## 3. Information the current reductions discard

The main losses are structural, not just algebraic degree:

- the number and placement of internal versus external primal arc points;
- hence the secant/passant type of every polar line;
- the deleted point's type and the resulting number of spare centers
  (sixteen for the internal \(q=53\) model, fifteen for an external deleted
  point);
- which center produced which moment equation once they are collapsed into a
  common mask;
- simultaneous compatibility among all star rows, rather than one row or one
  covariance form at a time;
- the projective realization and concurrency constraints behind an abstract
  matching frame;
- the relation, if any, between defects \(2,6,8\) and general \(\delta\).

The existing all-passant node resultant cannot simply be reused in a mixed
arrangement: both the line-type character and the offset parameterization
change.

## 4. What may be missing

### Highest-EV mathematical gaps

1. **Point-type stratification.**  Introduce the number of external primal
   points, condition on the type of the deleted point, and derive the mixed
   secant/passant polar equations before specializing to a torus.  Either
   prove uniform type in the nonsaturated branch or carry all type profiles.
2. **First-open-field counterexample audit.**  Search \(q=47,49,53\) with
   type and stabilizer pruning.  A bounded SAT/ILP/orbit search could prevent
   investing in a false theorem and would expose which type profiles survive.
3. **A general-defect carrier.**  Find an invariant that relates the split
   quotient \(E_P\) for different deleted points and survives for arbitrary
   \(\delta\), rather than assuming the defect-two antipodal form propagates.
4. **Saturated-internal global coherence.**  Use simultaneous angle
   bijections, the equality eigenvector, star syzygies, or a relative-blocking
   polynomial to prove that a coherent star misses a non-tangent line.
5. **Cross-center star algebra.**  Compute the Hilbert--Burch/apolar structure
   of the full star ideal and identify the first center-sensitive relation.
   A targeted degree-sixteen identity is admissible.

### Cheap questions left by the exact \(q=53\) aligned result

- Why are there exactly four dihedral candidate orbits?
- Why is the gradient product constant, equal to the nonsquare \(34\)?
- Is there a human collision or zero-separator proof behind the 44-case
  certificate?

These may reveal the correct invariant, but they do not outrank the missing
point-type reduction.

### EJ + Tao closeout: aggregate the spare lines before choosing a type

There is a free type-sensitive count that the one-center route discarded.
An external primal point lies on \((q-1)/2\) passants and an internal primal
point on \((q+1)/2\).  All \(k-1\) chords through it are passants.  Hence, if
\(e\) of the \(k\) arc points are external, the number of ordered
deleted-point/spare-passant pairs is

\[
 e\left(\frac{q-1}{2}-(k-1)\right)
 +(k-e)\left(\frac{q+1}{2}-(k-1)\right)
 =k\left(\frac{q+1}{2}-(k-1)\right)-e. \tag{F}
\]

For \(k=12\), each deleted external/internal point therefore supplies the
following number of spare-line direction quotients:

| \(q\) | \(\delta\) | external point | internal point |
|---:|---:|---:|---:|
| 47 | 8 | 12 | 13 |
| 49 | 6 | 13 | 14 |
| 53 | 2 | 15 | 16 |

Thus type is visible as a one-unit imbalance in the multiplicity of the same
degree-\(\delta\) quotient system.  The first type audit should sum identities
over all pairs \((P,\ell)\) before fixing one internal point and one passant.
This may determine \(e\), or at least rule out type profiles, without building
the full mixed node resultant.  It also sharpens the counterexample-search
specification: search by \(e\) and enforce every spare-line quotient, not only
one normalized center.

## 5. Evidence and trust boundaries

- The \(q\le43\) claim has the main exhaustive certificate and internal
  cross-checks; a wholly independent uncovered-set replay was performed only
  through \(q\le19\).
- The saturated-external proof has a successful cold referee read.  Its
  specialized local-Paley lemma has not yet received the external-specialist
  safeguard routed to C894.
- The \(q=53\) aligned search has an exact committed script and certificate,
  and its node and critical invariants are recomputed independently from the
  search recurrence.  It does not have a second independent exhaustive search
  implementation.
- No computation currently classifies all point-type profiles at
  \(q=47,49,53\).

## 6. Revised live assessment

| Component | Honest status | Decisive missing gate |
|---|---|---|
| Universal reduction | strong | none known |
| Bounded all-\(k\), \(q\le43\) | exact computational closure | broader independent replay is optional assurance |
| Saturated-external | closed | C894 human publication safeguards only |
| Saturated-internal | sharply constrained, open | global dual-star nonblocking theorem |
| Nonsaturated, arbitrary type | early | point-type stratification and first-open-field audit |
| \(q=53\), all-internal, aligned | closed | none inside this conditional branch |
| \(q=53\), all-internal, other covariance | open conditional subbranch | collision/zero from Gram plus character rows |
| General \(\delta\ge2\) | open | cross-point masked Rédei carrier |

The former 40% figure for the nonsaturated branch counted deep progress inside
one unproved type specialization.  It should not be used for the theorem as a
whole.  Near-term odds of a complete all-\(k\) proof are lower than the former
20--25% estimate; the exact value is too sensitive to the type audit to make
more precise.  A counterexample remains a live possibility.

## 7. Decision and next gate

Pause the nonaligned/split covariance enumeration as the main C756 route.  It
remains a valid conditional subproblem and its existing work is retained.
First derive a nonsaturated type ledger for \(q=47,49,53\):

1. deleted point internal versus external;
2. number of external points in the remaining arc;
3. polar line types and node types;
4. spare-line center counts and direction masks;
5. the aggregate spare-line identity (F) and its type-profile consequences;
6. which moment, separator, and covariance statements survive unchanged.

Acceptance is either a proof that nonsaturation forces the all-internal model,
or a complete set of mixed-type equations and bounded search domains.  Only
then can the all-passant Gram route be assigned its correct weight in the full
theorem.

## Mystery ledger

- **Unsettled — type uniformity:** no evidence yet says whether mixed-type
  nonsaturated candidates exist past the pairwise character test.  Owner:
  C756 point-type audit.
- **Unsettled — first survivor:** no all-type search exists at \(q=47,49,53\).
  Owner: C756 bounded counterexample audit after type stratification.
- **Unsettled — defect propagation:** no relation promotes \(\delta=2\) to
  general \(\delta\).  Owner: future masked Rédei carrier inside C756.
- **Unsettled — saturated star coherence:** all local and spectral identities
  remain compatible.  Owner: C756 dual-star nonblocking gate.
- **Partly settled — aligned 44-orbit phenomenon:** exact nonexistence is
  certified, but the four orbits and constant gradient product lack a human
  mechanism.  Owner: optional invariant extraction after the type audit.
- **Settled by the EJ + Tao closeout — first type-sensitive scalar:** the
  aggregate number of spare-line quotient instances is exactly (F), so the
  external-point count is not invisible.  The open gate is whether summing the
  masks over those instances forces that count or a restricted type profile.
  Owner: C756 point-type audit.
- **Settled by this audit — scope of the aligned result:** it is now explicitly
  conditional on the all-internal/all-passant \(q=53\) model and is no longer
  presented as closure of the nonsaturated field.

## Authorities

- Universal and bounded classification:
  `notes/2026-08-01-c756-all-k-conic-filling.md`.
- Saturated-internal branch:
  `notes/2026-08-01-c756-saturated-internal-branch.md`.
- Nonsaturated direction quotient:
  `notes/2026-08-01-c756-nonsaturated-direction-reduction.md`.
- Exact all-internal premise of the star model:
  `notes/2026-08-09-c756-defect-two-star-near-transversal.md`.
- Saturated-external proof and cold read:
  `notes/2026-08-08-c756-saturated-exterior-consolidated-proof.md` and
  `notes/2026-08-08-c756-consolidated-proof-cold-referee-read.md`.
- Conditional aligned closure:
  `notes/2026-08-09-c756-aligned-critical-closure.md`.
