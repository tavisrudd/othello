# C518 — modular TRS trace-one global incidence

**Lane:** `reed-solomon` · **Date queued:** 2026-07-23 · **Status:** complete by exit-gate
obstruction

## Objective

Turn C515's exact modular last-hook normal forms into the strongest justified global
zero-existence theorem on the distinct trace-one support space. The local Hasse and
finite-difference operators are closed by obstruction; this task instead studies
\[
 \mathcal Z_y=
 \{(r,U): |U|=s-1,\ \sum U=1,\ \operatorname{disc}(Q_U)\ne0,\
 F_y(r,U)=0\}.
\]
The valid completion/support collision locus `0 in U`, with determinant member
`X^2 Q_V`, remains inside the domain.

Execute the alternative attacks in this order, stopping as soon as a theorem with a
classified exceptional locus and an effective field gate is obtained:

1. **Lucas-fixed endpoints.** Decide the distinct trace-one equations
   `e_k(U)=0` for every additional Lucas-maximal fixed direction. Give a uniform
   construction or classify the exact persistent arithmetic obstruction. Use the
   `U={0} union V` boundary recursion when it is honest.
2. **Residual-quadratic slice.** Fix `s-3` roots and solve for the last two.
   Derive the determinant, discriminant, diagonal, and fixed-root collision divisors;
   prove a character-sum/cover bound or identify the exact degeneracy strata.
3. **Factorization-family monodromy.** Regard `F_y(r,U)=0` at fixed `r` as a
   hyperplane family of monic degree-`s-1` polynomials with root sum one. Compute
   geometric monodromy on each surviving Hasse stratum and apply a splitting-family
   rational-point theorem only after the identity twist and deletion degrees are
   explicit.
4. **Ordered-root incidence fallback.** Pull the equation to ordered roots,
   eliminate the trace-one coordinate, and prove geometric integrality of a suitable
   incidence component directly if the monodromy route needs an equation-level proof.
5. **Universal contained/transverse synthesis, conditional.** Promote to a
   C512-shaped theorem only if steps 1--4 expose a finite, intrinsic list of
   persistent carriers. Otherwise state the exact unresolved component gate.
6. **Stabilizer quotient, only where needed.** For `H_y != 0`, use the quotient
   coordinate `P_H(r)` together with the exact rational lifting torsor. The reduced
   coset norm records a component union and is never itself an irreducibility target.
7. **Value-distribution fallback.** Use additive Fourier/moment bounds only if
   component geometry fails for a stated reason; do not treat finite-difference
   vanishing as zero-lifting.

## Entry evidence

- `notes/2026-07-23-c514-modular-trs-translation-quotient.md`
- `notes/2026-07-23-c515-modular-trs-hasse-recursion.md`

C514 supplies the canonical completion-root slice and Lucas fixed flag. C515 supplies
the Hasse normal form, adjoint-kernel trace endpoints, ruled polar locus, exact orbit
norm, stabilizer factorization, and the counterexample to local zero-lifting.

## Hard gates and stop rules

- Normalize before computing; no ambient syndrome or field census.
- The raw and reduced orbit norms are explicit products of translated/coset incidence
  factors. Neither whole product may be proposed as an absolute-irreducibility target.
- A quotient rational point counts only with a proved lift to an original
  `r in F_q`.
- Retain the distinct-root, trace-one, infinity, and `0 in U` collision semantics in
  every projection or compactification.
- If a paper-facing computational claim is required, first create the atomic
  report/generator/certificate/checksum bundle and independent replay required by
  `notes/research-reproducibility-conventions.md`.
- Before any novelty or priority sentence, run a claim-specific literature audit.
- Stop with a precise obstruction if endpoint constructions and residual geometry do
  not supply a theorem-derived finite-field bound; do not substitute a census.

## Exit gate

One of:

1. a global high-field zero-existence/deep-hole theorem with an explicit exceptional
   carrier list, exact rational lifting, collision treatment, and effective threshold;
   or
2. a proved obstruction identifying the first incidence component or arithmetic
   torsor that defeats all seven ordered attacks.

In either case, record exactly which Lucas-fixed endpoints are shallow or persistent
and whether the residual-quadratic route reaches the generic Hasse stratum.

## Deliverable

Task report: `notes/2026-07-23-c518-modular-trs-global-incidence.md`.

## Outcome

The task reached exit gate 2.  Every fixed endpoint is the explicit complement
Frobenius-alternant carrier `A_(k,l)`; all binary endpoints and a uniform fixed-subfield range are
shallow.  The binary carrier is completely parametrized and counted, and every one of its zeros
lies on the valid completion/support collision boundary.  Its ordered component is a rational
open curve with an explicit reduced deletion divisor; reordering is a free `S3` torsor whose
identity, transposition, and three-cycle Frobenius classes give the complete quotient-lifting
law.  The residual-quadratic slice has exact determinant, branch, diagonal, collision, and
Kummer/Artin--Schreier lifting classes.  Outside the proved shallow ranges, factorization
monodromy and ordered-root incidence meet the same reduced carrier.  A Tao audit resolves its
generic geometry at every high Lucas level `p^l>k`: it is rational, with exceptional divisors
given by consecutive Schur functions.  Those functions are coprime, so the vertical locus has
lower dimension and the rational component is uniquely top-dimensional.  Schwartz--Zippel gives
the explicit high-level shallow gate
`q > binom(k+1,2)+2(p^l-k)`, clearing every `k=3` endpoint uniformly.  The remaining gate is
low-level geometry, the bounded high-level fields below that threshold, and rational avoidance
of the ordering/residual torsors; no universal contained/transverse synthesis or field census
was substituted.
