# Astra targeted recheck: four paper errata (2026-09-06)

Source: Astra's targeted recheck pass across four manuscripts. Each item was
re-verified against the source before editing; none changes a headline theorem.

## MDS–CSS transversal groups (`papers/mds_css_transversal_groups`)

1. **Choi-to-logical label map.** `sections/03-diagonal-isoduality.tex`, proof
   of the diagonal-isoduality transversal theorem, said an input symplectic
   block `A` induces the logical block `A^{-T}`. That transfers the
   inverse-transpose rule for unitaries to their Pauli-label matrices. The
   correct rule: the logical unitary is `U^{-T} = conj(U)`, and complex
   conjugation fixes `X(a)` and sends `Z(b)` to `Z(-b)`, so the logical block
   is `KAK` with `K = diag(1,-1)`. Counterexample: over `F_5`, `U|x> = |2x>`
   has label matrix `diag(2,3)`; `U` is a real permutation, so the logical
   block is `diag(2,3)` itself, while `A^{-T} = diag(3,2)`. Conjugation by `K`
   is still an automorphism of `SL_2(q)` preserving the diagonal torus, so the
   surjectivity conclusion is unchanged. Only this sentence used the wrong
   rule; the unitary-level statement (`L^{-T}` adjoined as the input factor)
   is correct and untouched.
2. **Generic-rank takeaway.** `sections/06-lu-invariants.tex`: "no fixed copy
   number can recover a nonconstant pencil coordinate on the generic locus"
   was narrowed. The dense open may have no rational points, and polynomial
   LU invariants separate any finite collection of inequivalent states at some
   finite copy number. The retained claim is generic constancy as a regular
   function; the open question is uniformity of the copy bound as `q` or the
   family grows.

## Arcs complete outside a conic (`papers/arcs_complete_outside_conic`)

3. **Reconstruction coda opening fails at q=3.** The coda claimed every
   conic-complete arc has `C(k,2) >= q+1` via the first-moment count. In
   `PG(2,3)` the coordinate triangle has the three coordinate lines as
   secants; its uncovered locus is the four all-nonzero points, which is
   exactly the conic `X^2+Y^2+Z^2=0`. So it is conic-complete with
   `C(3,2)=3 < 4`. Repaired by restricting the assertion to `q >= 4` with the
   short derivation (`q^2-k <= C(k,2)(q-1)`, so `C(k,2) <= q` forces `k >= q`
   and then `C(k,2) >= C(q,2) > q`), and recording the example, which gives
   `rho_C(3) = 3` (a 2-arc leaves nine uncovered points, so no smaller arc is
   conic-complete). Not added to the exact-small-orders theorem in the
   introduction; that is a body-statement change for the author to decide.
4. **Dual star–matching corollary** now states `k >= 4` explicitly, matching
   the matching-design theorem it invokes.
5. **Coding dictionary**: "points on secants" became "points outside `A` on
   secants" where coset weight two is meant.

## Irrationality after one stabilization (`papers/cubic-stabilization-m1`)

6. **Invariance of the modified residue.** The proof used the commutant of a
   nonzero rank-one nilpotent to get `C_∂ = q_∂ N` while nilpotence of `N`
   away from the base point was the thing being proved. Repaired inline
   without a new numbered statement: over the complete local ring of the
   formal bulk germ, the rank-two cluster continues (separated eigenvalues),
   `N` specializes to a nonzero nilpotent, so `v, Nv` is a basis by Nakayama
   and `N` is cyclic; the centralizer of a cyclic 2x2 matrix is `O I + O N`
   regardless of nilpotence, and trace-centering kills the `I` component.
   The flatness recursion then proceeds as before. Proposition statement and
   Lean coverage annotations are unchanged.

## Cubic stabilization irrationality (`papers/cubic-stabilization-irrationality`)

7. **Appendix A cover display.** `⋃_i {D_i M_i ≠ 0} = {Δ ≠ 0}` is false as
   an equality of subsets of the `(a,b)`-plane (at `a=0, b=2`, `Δ=0` but
   `D_1 M_1 ≠ 0`). The proposition only uses the containment
   `{Δ ≠ 0} ⊆ ⋃_i {D_i M_i ≠ 0}`, which is what the Gröbner certificate
   proves. The display now states the containment.

## Not acted on

Astra reported no demonstrated gap in the cubic one-stabilization argument;
the earlier comments on faithful center base change, comparison gauges, and
integral descent were audit priorities, not errors.
