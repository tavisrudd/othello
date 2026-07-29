# C682: global two-sided defect plan

Date: 2026-07-29

**Outcome:** The two-sided-defect part of this plan is complete. The
five-chain local determinant proves
\(\ker(\Delta_n,\Delta_{n-6}^\dagger)=0\) for every \(n>52\); see
`2026-07-29-c682-all-weight-defect-theorem.md`. The full-corner theorem
remains open at upper-support mixing and off-peak propagation.

## Objective

Replace degree-by-degree corner-minor checks by a structural argument that
either proves that degree \(22\) is the unique full-corner failure or isolates
the first precise obstruction to such a proof.

The proposed global object is the two-sided harmonic defect of the Klein
raising operator

\[
 Q_n=(\Delta_n,\Delta_{n-6}^{\dagger}):
 \operatorname{Sym}^n\longrightarrow
 \operatorname{Sym}^{n+6}\oplus\operatorname{Sym}^{n-6}.
\]

Equivalently, with

\[
 H_n=\Delta_n^\dagger\Delta_n+
       \Delta_{n-6}\Delta_{n-6}^\dagger,
\]

the defect space is

\[
 K_n=\ker Q_n=\ker H_n.
\]

This is initially a graded defect *space*. Calling it a module requires
proving that multiplication by the invariant ring, or an appropriate
matrix-factorization action, preserves the equations. That closure will not
be assumed.

The target theorem is stronger than merely determining \(K_n\): it must
connect two-sided defect vanishing to generation of every repeated
\(2.A_5\)-isotypic corner. Low-degree common kernels can be harmless in
multiplicity-free ranges, so the relevant invariant is the defect inside
repeated isotypic multiplicity spaces.

## Logical bottleneck

For one isotypic multiplicity space \(V_{\rho,n}\), put

\[
 L=\operatorname{im}\Delta_{n-6},\qquad
 U=\operatorname{im}\Delta_n^\dagger.
\]

Then \(K_{\rho,n}=0\) says only \(L+U=V_{\rho,n}\). It does **not** by itself
say that the matrix algebras supported on \(L\) and \(U\) generate
\(\operatorname{End}(V_{\rho,n})\): an orthogonal direct sum is an immediate
counterexample. A valid propagation lemma must include the incidence between
the two subspaces, and it must use neighboring full-corner hypotheses in a
well-founded order rather than circularly.

A sufficient local lemma should have the following form.

1. Neighboring full corners provide the full matrix algebras supported on
   \(L\) and \(U\).
2. \(L+U=V_{\rho,n}\).
3. The overlap graph detected by the cross-Gram maps is connected.
4. These supported matrix algebras then generate
   \(\operatorname{End}(V_{\rho,n})\).

For hyperplanes, distinctness and a nonzero cross term should suffice; in
dimension two, the two lines must be distinct and nonorthogonal. General
rank patterns require the corresponding subspace-incidence statement.

## Phase A: falsify and identify the defect spectrum

Build a reproducible modular sweep of the stacked matrix for \(Q_n\).

- Sweep a range large enough to expose periodic behavior, first through at
  least degree \(300\).
- Use two large primes.
- Decompose every nonzero kernel by McKay isotypic multiplicity.
- Recheck every exceptional degree exactly over \(\mathbf Q\).
- Record dimensions, ranks, primes, source revision, and replay commands in
  a JSON evidence bundle.
- Infer a candidate Hilbert series or finite-support statement only after
  the data are known.

Acceptance gate: an exact statement of all observed relevant defects and a
clear conjectural boundary. If later relevant defects occur, record the first
one and revise the structural target before proceeding.

## Phase B: prove the defect classification

Try the lowest-complexity symbolic route first.

1. Dehomogenize binary forms and write \((P,F)_3=0\) as a third-order
   polynomial ODE.
2. Express the adjoint equation in the same coordinate and eliminate the
   highest derivatives.
3. Determine polynomial solutions from the singularities and indicial
   conditions.
4. Restore the homogeneous and \(2.A_5\)-isotypic interpretation.

If the ODE does not expose finite support, construct the finite free
covariant modules over \(\mathbf Q[F,h]\) and write both sides of \(Q\) as
finite polynomial matrices. Natural generator degrees to test are:

- \(\mathbf1\): \(1,t\);
- \(\mathbf2\): the tautological covariant and its \(F,h,t\) transvectants,
  in degrees \(1,11,19,29\);
- \(\mathbf3'\): generators in degrees \(6,10,14,16,20,24\);
- \(\mathbf3\): reuse the existing degree-\(22\) matrix-factorization data.

The finite matrices may yield a graded free resolution, a Fitting ideal, or
a Smith-type calculation that proves the defect support.

Acceptance gate: a symbolic proof of the relevant \(K_n\) classification,
not extrapolation from a finite sweep.

## Phase C: prove corner propagation

Prove the required finite-dimensional subspace lemma and translate it into
the Clebsch corners.

- Identify exactly which path operators supply
  \(\operatorname{End}(L)\) and \(\operatorname{End}(U)\).
- Give a connected-overlap criterion in terms of explicit cross-Gram maps.
- Establish a well-founded propagation order, or replace induction by a
  simultaneous graded-module argument.
- Treat peak, off-peak, and boundary multiplicity patterns separately.
- Verify that the degree-\(22\) dark Koszul line violates the criterion in
  exactly the observed three-dimensional isotypic corner.

Acceptance gate: a written lemma whose hypotheses imply full corner
generation and whose use is noncircular.

## Phase D: close the all-weight statement

The all-weight theorem may be claimed only when all four conditions hold:

1. the relevant two-sided defects are classified symbolically;
2. the propagation lemma is proved with explicit hypotheses;
3. those hypotheses are verified in every weight, including all eventual
   residue families;
4. off-peak multiplicities are covered, not only the 21 strict-peak
   families.

If a finite free-module computation reduces the remaining hypotheses to
polynomial minors, factor only that finite structural set. The previously
identified 21 peak-family minors remain the fallback, not the starting
point.

## Failure modes and useful stopping points

- A later relevant \(K_n\neq0\): report its first degree, isotypic type, and
  exact basis; the uniqueness conjecture needs a different invariant.
- \(K_n=0\) but propagation fails: exhibit the first corner and the precise
  disconnected overlap graph.
- Propagation works but the defect equations do not form a finite module:
  retain the lemma and return to the 21 residue-family minors plus a separate
  off-peak argument.
- Free covariant matrices become intractable: preserve the exact degree and
  generator data so the obstruction is computationally sharp.

## Reproducibility and closeout

Every computational claim will ship with:

- a deterministic main script;
- a checked-in JSON evidence bundle;
- a replay/verification script;
- two-prime agreement and exact checks at exceptional degrees;
- bounded-output validation commands.

Before closeout, run the required `ej` and `tt` checks, update the C682 task
card, handoff, queue, and Mystery ledger, then commit a coherent validated
change. The final write-up will distinguish theorem, finite evidence, and
conjecture explicitly.
