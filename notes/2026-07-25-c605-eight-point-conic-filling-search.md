# C605 — eight-point conic-filling search

**Lane**: `clebsch`

**Status**: queued as the next Clebsch research task for a fresh session.

## Goal

Decide whether an eight-arc \(A\subset\mathrm{PG}(2,q)\) can satisfy
\[
\mathcal U(A)=\mathcal Q(\mathbb F_q)
\]
for a nonsingular conic when
\[
q\in\{13,17,19\}.
\]
These are exactly the fields left by Paper I's universal chord-defect and
passant window.  A construction must be classified up to the stated
projective equivalence; an exclusion must cover the complete normalized
search domain.

## Forced spectra

Put \(a=n_4\), where \(n_i\) counts off-arc points on exactly \(i\) secants.
The two chord moments and \(|\mathcal U(A)|=q+1\) force
\[
\begin{array}{c|c|c}
q&(n_1,n_2,n_3,n_4)&a\text{ range}\\ \hline
13&(21-a,105+3a,35-3a,a)&0\le a\le11,\\
17&(157-a,81+3a,43-3a,a)&0\le a\le14,\\
19&(261-a,33+3a,59-3a,a)&0\le a\le19.
\end{array}
\]
Use these as global cuts and as certificate checks, not as evidence of
existence.

## Required search and trust shape

Before computation, read
`notes/research-reproducibility-conventions.md` and follow its complete
paper-facing bundle requirements.

1. Fix a nonsingular conic and normalize the projective frame under its
   stabilizer; state why every conic-filling eight-arc is reached.
2. Require all eight arc points to be external to the conic and every join
   to be passant.  Enforce the forced secant-index spectrum and defect
   identity during the search.
3. Quotient by the conic stabilizer without losing labelled or exceptional
   cases; state the canonicalization and deduplication contract.
4. For every surviving object, verify independently that it is an eight-arc,
   is disjoint from the conic, has every join disjoint from the conic, and
   has uncovered locus exactly the conic.
5. Emit a compact construction or exclusion certificate with a deterministic
   checker, exact replay command, input description, stop condition, and
   SHA-256 hashes.  Add an independent replay or state precisely why none is
   available.
6. Add a Lean bridge when it materially narrows the trusted search result;
   otherwise state the exact residual trust boundary.

Do not begin with an unrestricted eight-subset enumeration.  Derive the
smallest conic-stabilizer search space first, then estimate its orbit and
memory sizes before launching the three fields.

## Acceptance

- Each of \(q=13,17,19\) ends in either a checked witness classification or
  a complete checked exclusion.
- The report states exact raw, normalized, and orbit counts and reconciles
  them with the forced spectra above.
- Paper I's theorem, trust manifest, statement identity, PDF, release
  certificate, and clean replay are updated if and only if the result
  strengthens the manuscript.
- The substantial-task closeout includes the required explicit extra-juice
  and Tao-style passes and refreshes the mystery ledger.

## Boundary

This task owns only the eight-point conic-filling boundary and its Paper I
consequence.  It does not absorb the icosahedral extension-complex,
conference-eigencode, AME/LU, or Paper II factorization programs.
