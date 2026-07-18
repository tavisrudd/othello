# C210: bounded obstruction for the two-repair-coset mechanism

**Lane**: `relconic` (final C210 report)

Date: 2026-07-18.

## Theorem

Let `k=GF(q)`, `q=8^m` with `m` odd, and consider the C210 trace-one
two-repair-coset ansatz with `delta*p!=0`.

1. **Uniform nonconstant-height obstruction.** For every `q>=32768`, every
   specialization with `(a,b)!=(0,0)` has a reconstructible genuine
   seed--cross-repair collision. It therefore does not define an arc, before
   any affine-coverage question is asked.
2. **Sharper exceptional-stratum bound.** The entire `a=0,b!=0` stratum, the
   entire `a!=0,b=0` stratum, and every factorization branch on
   `a!=0,b!=0` are already collision-forcing for every odd-tower `q>=512`.
   The larger `32768` bound is needed here only for the absolutely irreducible
   complement of the `a!=0,b!=0` factorization divisor.
3. **Constant-height scalar extensions.** On `a=b=0`, the committed full
   `GF(8)` arc-legality/collision classification proves that no arc-legal
   trace-one base configuration remains collision-free throughout its odd
   scalar tower. This is the exact fixed-coefficient scalar-extension scope of
   the constant-height packet.

Consequently the selected two-repair-coset route cannot supply the desired
infinite sharp-scale construction in its certified scope. This is a mechanism
obstruction, not a nonexistence theorem for `C`-complete `O(sqrt(q))` arcs and
not an obstruction to a different repair architecture.

## Global reconstruction obstruction

The universal collision quadratics satisfy the exact trace-one identity

    H = D_quad*B_quad+A_quad*E_quad = delta*N*G1,
    N = a^2+a+1,
    G1 = u^2+u*p+p^2*(w^2+w+1).

It is independent of `b`. In an odd-degree extension of `GF(2)`, `N` has no
root because its roots lie in `GF(4)`. Also, after `u=p*v`,

    G1/p^2 = v^2+v+theta,       theta=w^2+w+1,
    Tr(theta)=Tr(w^2+w)+Tr(1)=1.

Thus `G1` has no rational root and `H!=0` at every rational finite `u` on the
whole odd tower. Every rational resultant point reconstructs the unique common
quadratic root `r=J/H`; the split boundary `H=J=0` has no odd-tower rational
point. This exact identity, already rebuilt from the universal quadratics by
`analyze_c210_a_nonzero_b_zero.py`, closes the purported final reconstruction
gate globally rather than only branch by branch.

## The `a!=0,b!=0` complement: explicit `q>=32768` bound

On `a!=0,b!=0`, the quartic collision cover has one factorization divisor
`D_AS`. The arithmetic-completeness theorem proves that `D_AS` is exactly the
three displayed residue branches over every odd-degree field. The second-layer
and genuineness packets prove that all three branches carry genuine collisions
for `q>=512`.

Off `D_AS`, the cover is absolutely irreducible. Its affine resultant has
`u`-degree at most six and `t`-degree four. Its closure in
`P^1_u x P^1_t` therefore has bidegree at most `(6,4)`, so the normalization
has

    g <= (6-1)*(4-1) = 15.

Hasse--Weil gives

    #C(k) >= q+1-30*sqrt(q).

At most four normalized points lie above `u=infinity` and at most six above
`t=infinity`, so at most ten boundary points are unusable. For `q>=32768`,

    q+1-30*sqrt(q) > 10.

The remaining point is finite. The global `H` identity makes it
reconstructible. The only seed/repair coincidences are the `e=0` and
`e=delta` factors, which lie inside branches 1 and 2 of `D_AS`; hence a point
off `D_AS` is genuine. This proves clause 1 on `a!=0,b!=0` without an
unspecified Lang--Weil constant.

The same bound does not certify the off-divisor complement at `q=512`:
`q+1-30*sqrt(q)` is then negative. No claim about that bounded field is
silently inferred.

## The remaining nonconstant strata

On `a=0,b!=0`, the factorization divisor has exactly three branches, each
split into rational collision-bearing components. Off that divisor the curve
is absolutely irreducible of bidegree at most `(6,2)`, so `g<=5`; at most eight
points lie on the two projective boundary fibers. The inequality

    q+1-10*sqrt(q) > 8

holds for every odd-tower `q>=512`. The same global `H` identity specializes
with `N=1`, and the off-divisor locus excludes the two seed-coincidence
branches, so the supplied point is reconstructible and genuine.

On `a!=0,b=0`, the committed Artin--Schreier normalization has genus at most
four and at most seven deleted points. Its exact bound

    q+1-8*sqrt(q) > 7

holds for every odd-tower `q>=512`. The report separately identifies and
removes the two repeated-point factors, proving genuine collisions on them as
well.

Together with the complete `a!=0,b!=0` branch classification, these estimates
exhaust every nonconstant-height stratum.

## Constant-height boundary

For `a=b=0`, the collision resultant is independent of `t` and the arc gate
must be imposed before factor parity. The committed unnormalized `GF(8)`
classification checked `150,528` configurations: `7,512` were collision-free
for both seed colors, and none was arc-legal. Equivalently, among the twelve
arc-legal common-trace-one configurations, every one has an odd-degree
collision factor for at least one seed color. Thus no fixed `GF(8)`
constant-height configuration stays an arc throughout the intended odd scalar
tower.

This finite classification is not promoted into a theorem about arbitrary new
coefficient choices made independently over every larger field. Such a family
would require a new construction statement and lies beyond this bounded
mechanism obstruction.

## Evidence and replay

The load-bearing bundles are:

- generic Artin--Schreier form and uniqueness of `D_AS`:
  [`2026-07-17-c210-a-nonzero-artin-schreier-form.md`](2026-07-17-c210-a-nonzero-artin-schreier-form.md);
- odd-degree completeness of the three branches:
  [`2026-07-17-c210-a-nonzero-dAS-arithmetic-completeness.md`](2026-07-17-c210-a-nonzero-dAS-arithmetic-completeness.md);
- second-layer point supply and projective genuineness:
  [`2026-07-17-c210-a-nonzero-second-layer.md`](2026-07-17-c210-a-nonzero-second-layer.md)
  and
  [`2026-07-18-c210-a-nonzero-genuineness.md`](2026-07-18-c210-a-nonzero-genuineness.md);
- global `H` identity and `b=0,a!=0` point bound:
  [`2026-07-17-c210-a-nonzero-b-zero.md`](2026-07-17-c210-a-nonzero-b-zero.md);
- `a=0,b!=0` divisor and rational components:
  [`2026-07-17-c210-a-zero-artin-schreier-divisor.md`](2026-07-17-c210-a-zero-artin-schreier-divisor.md);
- constant-height arc/collision intersection and the generic bidegrees:
  [`2026-07-16-c210-square-root-mechanism-audit.md`](2026-07-16-c210-square-root-mechanism-audit.md).

All load-bearing scripts, canonical outputs, SHA-256 hashes, and byte counts
are listed in
[`2026-07-17-c210-reproducibility-manifest.md`](2026-07-17-c210-reproducibility-manifest.md)
and pinned by `papers/arcs_complete_outside_conic/analyze_c210_SHA256SUMS`.
Replay from `papers/arcs_complete_outside_conic/` with:

```bash
python3 analyze_c210_a_nonzero_dAS_completeness.py | diff - analyze_c210_a_nonzero_dAS_completeness_output.txt
python3 analyze_c210_a_nonzero_b_zero.py | diff - analyze_c210_a_nonzero_b_zero_output.txt
python3 analyze_c210_a_zero_artin_schreier_divisor.py | diff - analyze_c210_a_zero_artin_schreier_divisor_output.txt
python3 analyze_c210_collision_curve_constant_height_arc.py | diff - analyze_c210_collision_curve_constant_height_arc_output.txt
sha256sum -c analyze_c210_SHA256SUMS
```

Independent cross-checks include the exact `GF(8)` and `GF(512)` residue
censuses, direct projective incidence over `GF(64)`, and the full unnormalized
constant-height arc census. The infinite-tail point bounds use only the exact
bidegrees, absolute irreducibility results, normalization genus bounds, and
Hasse--Weil; no finite census is extrapolated.

## Evidence boundary

- The theorem closes the selected two-repair-coset mechanism, not C210 as a
  general existence problem.
- The uniform nonconstant-height threshold is `q>=32768`. The smaller
  `q=512` off-`D_AS` complement and the recorded `q=8` branch exceptions remain
  bounded fields outside that clause.
- No affine-coverage claim is made: collision-freeness is a prerequisite, and
  every specialization in the theorem already fails it.
- No primary decomposition, heuristic factorization, or unquantified
  Lang--Weil assertion is load-bearing.
