# Relative-conic lane after C201

**Lane**: `relconic`

**Date:** 2026-07-16
**Status:** C210 ACTIVE — the `a=b=0` and `a=0,b!=0` strata are both closed (the Artin--Schreier
divisor `D3` is explicit, complete, and collision-forcing on every branch). On `a!=0`
(t-degree-four) the cover is now reduced to a **single** Artin--Schreier form
`F = psi^2 + sigma*psi + R1`, `psi = tau^2+bQ*tau`, `sigma = a*delta*N*G1*G2a`, `R1 = a^2*Q^2*B0`,
so the whole a!=0 factorization locus is one AS divisor `D_AS = {R1/sigma^2 in AS-image}`
(step 1; uniqueness complete on `a*delta*N*b!=0` via the alternate-slope odd-degree exclusion).
Step-2(a) preflight is now **done and clean** (no new degeneracy locus): `Res_u(G2a,G2a')=delta^4*p^2*N^2`
(a=0's `delta^4*p^2` times the arithmetically-empty `N^2`, so `G2a` stays separable off `delta*p=0`);
`Res_u(Q,G2a)=delta^2*N*K1*K2`; `Res_u(G1,G2a)=Res_u(G1,G2)=p^2*K1*K2` inherited free
(`G2a==G2 mod G1`); and the infinity place is AS-**trivial** (value `(e/delta)^2+(e/delta)`), so
`D_AS` is fixed entirely by the finite `G1,G2a` residues
([`2026-07-17-c210-a-nonzero-preflight-resultants.md`](../2026-07-17-c210-a-nonzero-preflight-resultants.md)).
Step-2(b) part 1 is also done: `W==0 mod G1` identically (the a=0 accident recurs, so `G1` adds no
condition) and `W mod G2a` gives exactly three `h1`-free, `h0`-linear conditions with content
`(delta*N)^6` -- the a=0 `P0,P1,P2` shape, not five
([`2026-07-17-c210-a-nonzero-residue-conditions.md`](../2026-07-17-c210-a-nonzero-residue-conditions.md)).
Step-2(b) part 2 gives the three explicit branches (a-deformed a=0 branches), each verified in `D_AS`:
`e=0` (`h0=0`), `e=delta` (`h0=p^2*theta+e^2+e*b+e*a*p`), `delta=p,theta=1`
(`h0=e^2*a^2+e*a^2*p+e*a*p+e^2+e*b+e*p`), `h1` free, each recovering the a=0 value at `a=0`
([`2026-07-17-c210-a-nonzero-dAS-branches.md`](../2026-07-17-c210-a-nonzero-dAS-branches.md)).
Step 2 remaining, in order: (b-part-2 completeness) show these three are ALL of `D_AS` off
`delta*p*N*K1*K2=0` -- the cross-determinant variety strictly contains them, so the extra locus must be
shown spurious (no consistent `h0` lift) or excluded, by exact division/resultant/radical work (NOT
minAssGTZ -- wrong on the a=0 analogue);
(c) per branch decide collision-forcing vs arc-legal via the **second-layer** `tau`-quadratic
trace test `Tr(A/(bQ)^2)=0` (a=0's components were `t`-linear; here `tau^2+bQ*tau+A`, and an
arc-legal rootless branch is where a construction could hide); (d) the `a!=0` reconstruction-split
locus `H=J=0` (the a=0 `H->delta*G1` pullback is stratum-specific); (e) close the unowned
`b=0,a!=0` degenerate stratum (`psi=tau^2` inseparable). Committed Fable review of this plan:
[`2026-07-17-c210-fable-review.md`](../2026-07-17-c210-fable-review.md).

## Current state

C201 is reported as a negative bounded mechanism gate.  Its archived handoff
is [`done/2026-07-16-c201-even-field-quadratic-rank.md`](done/2026-07-16-c201-even-field-quadratic-rank.md),
and the final synthesis is
[`2026-07-16-c201-bounded-mechanism-closure.md`](../2026-07-16-c201-bounded-mechanism-closure.md).
The tested q=64 families fail at coverage before quadratic rank becomes
informative.  C209 therefore remains dormant.  C210 inherits only the bounded
“coverage first, rank second” design lesson.

The current manuscript was not edited by C201.

C154 is now reported in
[`2026-07-16-c154-reed-muller-deep-holes.md`](../2026-07-16-c154-reed-muller-deep-holes.md).
The dedicated Reed--Muller pass found exact descriptions by bent functions, Hamming association
subschemes, explicit maximizers, and affine/coset types, but no complete deep-hole locus equal to
the full rational-point set of a named positive-dimensional variety.  The precise bounded-audit
novelty posture survives.  The paper needed no claim-boundary change; its conclusion received one
independent proof-stage copyedit requested by the user.

C144 is reported in
[`2026-07-14-c144-shared-library-gate-architecture.md`](../2026-07-14-c144-shared-library-gate-architecture.md).
Import-only validation targets now separate the relconic, Baer, and alternate-orbit closures; the
alternate-orbit lane uses three compatible modules because its independently compiled terminals
cannot all share one Lean environment. Build orchestration and notification mechanics remain owned
by the `build-sys` lane.

## Recommended order

1. **C210 — square-root construction program.**  The initial mechanism audit proves an
   infinite-family obstruction for arcs contained in one Baer subplane and selects the genuinely
   Baer-transversal route. The first two-layer parabola family is a uniform conic-disjoint `2s`-arc
   and an ordinary complete 6-arc at `s=3`, but direct relative coverage fails for `s=4,5,7,8`.
   Greedy completion remains near `3s` in the larger tested fields. A full parabola repair layer on
   a nontrivial additive coset succeeds sporadically at `s=5`, nearly succeeds at `s=4`, but has no
   arc-legal instance at `s=7`; that uniform mechanism is closed. Next derive the collision and
   coverage equations for a graph or partial-coset repair of at most `s` points. Those equations
   now reduce internal arc legality to the second-divided-difference condition
   `1+g[r,s,u] != 0`; full affine-height graphs add nothing beyond the constant layers throughout
   the five tested orders. For quadratic heights, each
   two-repair/one-seed collision is equivalent to one subfield quadratic splitting distinctly.
   Twelve genuinely nonlinear `3s=24` repair arcs survive at `s=8`, all with nineteen uncovered
   points; two points at infinity complete the best to an ordinary 26-arc. No nonlinear layer
   survives at `s=3,4,5,7`. Exact conic-stabilizer recognition gives three orbits of four, generated
   internally by subfield translations. All nineteen uncovered points lie at infinity, so these
   are complete affine 24-arcs and any two missing directions give ordinary complete 26-arcs. A
   uniform characteristic-two version would yield the target `3s+2` construction. Next derive its
   affine-coverage and arc conditions as trace identities in `lambda=a/b`. Same-layer chord values
   now have the exact split-polynomial trace description `S_U={Up+q:p!=0, tr(q/p^2)=0}`. The unique
   minimal q=64 coverage route is `AA,AB,AR,BB,BR`, so repair--repair secants can be omitted from the
   coverage proof. Next show that the complement of `AB,AR,BR` lies in the two seed translates of
   `S_y`. The first orbit admits a complete trace parametrization, but its natural `GF(8)` scalar
   extension is obstructed for every `s>=16`: a one-repair collision is forced by a nonzero
   `z` with `tr(z)=tr(z^(-1))=0`, and the Kloosterman/Weil count guarantees such `z`. The other two
   q=64 orbits now have explicit `GF(8)+GF(8)*omega` normal forms. After sending the roots of each
   forced pair-sum polynomial to `0,1`, all six orbit/seed collision gates reduce to the same
   `tr(1/(x^2+x))=0` condition. Hence all three direct full-domain scalar extensions have the same
   Kloosterman obstruction. The mandatory same-seed deletions for a partial domain are now exact:
   the two bad sets are translates of
   `B_s={x!=0,1:tr(1/(x^2+x))=0}` by `delta=tau,tau^6,tau^5` in the three orbits. Their union has
   size `3s/4+O(sqrt(s))`, leaving at most `s/4+O(sqrt(s))` repair parameters before the other arc
   gates. The mixed-seed variables now eliminate to one explicit quintic `M(r,d)` for each repair
   parameter. As a curve in `(r,d)`, it is geometrically irreducible: in the `r` coordinate it is a
   separable additive quartic, and the rational right side has an odd order-three pole. This rules
   out component-level forced collisions but does not yet prove that rootless quintic fibers meet
   the two same-seed trace complements in positive density. The monodromy calculation now closes
   that gap: eight simple branch values give transposition inertia and force full `S5`, while the
   two same-seed Artin--Schreier characters are ramification-independent from its sign cover. The
   joint group is `S5 x C2 x C2`, so Chebotarev gives a domain of
   `11s/120+O(sqrt(s))` parameters surviving every one-repair collision gate along
   `F=GF(8^m)`, odd `m`. The two seed-colored two-repair/one-seed collision graphs each have maximum
   degree three: their equations are linear in the second repair parameter and eliminate to a
   cubic in the seed parameter with nonzero leading coefficient. Their union therefore has maximum
   degree six, and a greedy independent set leaves at least
   `11s/840-O(sqrt(s))` repair points. Together with the quadratic divided-difference condition,
   this closes every arc-legality gate for the partial-domain mechanism. Next analyze affine
   coverage after this thinning; in particular, determine whether seed--repair secants from such a
   sparse domain can cover the residue left by the two full seed layers. The exact q=64 audit shows
   that naive thinning fails maximally: among 288 seed-uncovered affine targets, 80 have singleton
   repair candidates, every repair parameter is forced by at least eight targets, and only the full
   repair layer covers. The general seed--repair collinearity condition splits into two cubic
   coordinate equations in `(r,t)`. Their common components are now completely classified: the
   only positive-dimensional cases are targets on the repair graph or on a seed layer, and a short
   coefficient comparison rules out every quadratic component uniformly. Generic targets have at
   most nine candidates per seed color. A repair target has candidate hyperedge exactly
   `{r} union N_A(r) union N_B(r)`; after restricting to the one-repair survivor set, every maximal
   independent set in the induced degree-six collision graph covers all required repair targets
   automatically. The q=64 non-repair singleton targets now give a much stronger extension
   obstruction. Their two seed-color elimination schemes have extra odd closed-point degrees only
   `3`, `5`, and `7`; for every repair parameter there is a forcing target of each pure type.
   Hence affine coverage forces the full repair layer whenever `105` does not divide the odd
   extension degree `m`, while that full layer is collision-obstructed for `m>1`. The degree-`3`,
   `5`, and `7` residue-hypergraph gate now closes the last `105 | m` subtower as well: among 400
   exact candidate vertices only twenty degree-five vertices survive the one-repair gates, and
   sixty-eight of seventy-two required target hyperedges are empty. Thus every fixed-coefficient
   scalar extension of the three q=64 quadratic orbits is closed. The coefficient-parametric
   resultant now has leading term `a1*y1*(a1^2+a1+1)`, hence exact degree seven off `y1=0`; on
   `y1=0`, the two seed-color degree-six coefficients differ by `a1*tau`, so one remains nonzero.
   Squarefree specializations make both strata generically separable. The rational incidence
   source and isolated double-root witnesses now force full arithmetic/geometric groups `S7` and
   `S6`; composing with the one-repair collision group `H=S5 x C2 x C2` gives `H wr S7` and
   `H wr S6`. One seed color therefore gives a rational legal candidate on only about `8.76%` of
   coefficient-generic targets. The mixed seed class now has `S5` monodromy, the same-layer trace
   covers are independent, and isolated seed-color branch witnesses give the full joint group
   `((H wr S7) x (H wr S7)) x (S5 x C2 x C2)`. It leaves density `0.0763116...` missed by every
   seed--seed chord and every one-repair-legal seed--repair chord. Repair--repair coverage is one
   independent Artin--Schreier character, halving the full uncovered density to `0.0381558...`.
   Thus even the coefficient-generic full repair layer is not affine-complete, and thinning cannot
   help. The normalized q=64 coefficient slice now has exactly twelve legal affine-complete graphs,
   namely the three known four-point translation blocks; those translation families are already
   covered by the frozen scalar-extension closure. However, all three representatives retain full
   geometric and arithmetic `S7` for the degree-seven seed--repair cover. Their q=64 completeness
   is therefore a small-field arithmetic exception, not a degree-seven monodromy drop. The full
   specialization gate now retains every factor at all three representatives: isolated
   transpositions give both `S7` top covers, the one-repair collision group supplies both `H wr S7`
   factors, all sixteen lower Frobenius characters occur, and an isolated repair branch prevents a
   geometric `C2_RR` coupling. Thus all twelve translated q=64 layers retain the full group (27),
   not merely its degree-seven quotient. The translation quotient is now exact: geometrically
   `c1` is eliminable because `c1 -> c1+a1*d^2+b1*d`, while over a finite field it contributes only
   the twist bit `Tr(a1*c1/b1^2)` when `b1!=0`. The mixed-collision `S5` branch calculation is now
   exact on the four-variable quotient. Its reduced drop divisors are `b1=0`,
   `eta1^2+c0+1=0`, and
   `k^2+C*k+C^2=0` for `k=c0+1`, `C=eta1^2+sqrt(tau)*eta1`; the last splits into two conjugate
   geometric components. Their intersections are classified, neither arithmetic twist changes
   them, and all three q=64 blocks avoid them. The two degree-seven coverage covers now have exact
   degree-eight ramification-source equations on the four-variable quotient. Neither is everywhere
   inseparable on the `GF(8)` repair stratum, and they cannot coalesce on any coefficient stratum:
   their difference has the coefficient-independent term `tau^4*y1`. Every one of the `3136`
   rational quotient coefficients now has an exact simple branch-image witness for both seed
   colors, including every rational point of the known mixed-cover divisors. The two conjugate
   geometric components of the mixed Hasse divisor, their `b1=0` intersections, and both conjugate
   critical/triple intersections now also retain exact simple coverage-branch witnesses over
   `GF(64)`. The omitted trace-one translation class retains such witnesses for both seed colors at
   all `2744` applicable rational quotient coefficients. Thus the known lower factors and the
   arithmetic twist are not coverage-drop components. The source side is now completely uniform:
   `W=s*omega*D` and `Y=lambda*D` give a non-endpoint reduced ramification source at every
   repair-stratum coefficient specialization, with transverse derivative
   `s*(s+b1)*Norm(D)^2`. This section is injective onto its image. For a second source, the
   differences `u=r'+r`, `v=d'+d` give two quadratic target-collision equations and one quintic
   ramification equation in `v`, independent of `k`, seed color, and the original `r`. After the
   known `u^2` source factor is removed, the collision resultant has 111 terms and degree five in
   `u`. The linear subresultant satisfies `L0=u*M0` and
   `L1|_(u=0)=s*(lambda+1)^2*Norm(D)`. The final elimination is now chart-free. At `u=0`, the two
   residual collision equations imply `s*Norm(D)=0`, so there is no external source. For `u!=0`, a
   second ramification source forces a multiple root of the saturated collision quintic. In
   characteristic two its discriminant reduces to a 3352-term resultant of two quadratics in
   `z=u^2`; after removing `e*lambda^4*(lambda+1)`, imposing
   `s*e=d^2+e^2+k`, and clearing `e^6`, the coefficient of `lambda^3*d^18` is exactly `e*a^4`.
   Hence the multiple-root condition is nonzero on the reduced section at every repair-stratum
   coefficient point, for both seed colors, including the old `L1=0` boundary. There is no new
   geometric self-collision divisor. Cross-seed isolation is also uniform: inserting the shift
   `tau*omega` gives a 216-term degree-seven collision resultant, whose repeated-root condition is
   a 100056-term cubic--cubic resultant in `z=u^2`. After removing
   `e*Norm(D)*(lambda+1)^6`, imposing `s*e=d^2+e^2+k`, and clearing `e^10`, the coefficient of
   `lambda^8*d^30` is exactly `tau*e^2*a^4`. Thus each seed cover has an isolated simple branch
   away from the other at every repair coefficient. On `GF(8^m)`, odd `m`, the cover degree is
   always seven because `a^2+a+1!=0`; irreducibility plus these isolated transpositions gives the
   uniform top group `S7 x S7`. There is no residual coverage top-group drop. The remaining lower
   mixed-collision strata `b=0`, `e^2+k=0`, and `D_H=0`, including every classified intersection,
   are now closed by projecting away legality: even under the worst possible rank-two sign
   coupling, a density at least `1331/216000` of affine targets has no chord from any seed--seed,
   seed--repair, or repair--repair class, even when the full quadratic repair graph is allowed.
   Deleting to an arc-legal domain cannot add coverage. This closes the single quadratic graph
   ansatz, not C210. The first new Baer-transversal gate adds a second repair coset. Its `2+1`
   cross-repair triples reduce exactly to `p!=0` and `Tr(q/p^2)=0`, with `deg p<=2`, `deg q<=3`.
   Artin--Schreier classification forces any infinite collision-avoiding pair to share the same
   ordered quadratic/linear coefficient pair `(a,b)`; all 48 pairs among the twelve certified q=64
   blocks lie off that locus and fail directly. On the shared-`(a,b)` locus, the missing
   one-seed/one-point-from-each-repair condition is now two explicit quadratics in one repair
   parameter. Their 452-term Sylvester resultant has coefficient-parametric bidegree `(6,4)`;
   off `H=DB+AE=0`, every rational point reconstructs the unique rational repair parameter
   `r=(DC+AF)/H`, while `H=0` reduces to the explicit shared-quadratic split locus `H=J=0`.
   The two oriented trace-one conditions are in fact identical on the shared-`(a,b)` locus. An
   exact `GF(8)` specialization satisfying that trace bit has no rational point on the beta-seed
   collision curve, so the Frobenius issue is real; however, its degree-eight curve stays
   irreducible over extension degrees `2`, `4`, and `8`, hence is absolutely irreducible. Its
   nonzero degree-two `H` boundary cannot contain the curve, so Lang--Weil forces reconstructible
   collisions over all sufficiently large scalar extensions. Exact factorization of the universal
   452-term resultant gives one factor, and the absolutely irreducible fiber makes geometric
   integrality generic even after pullback to the trace-one cover. Thus only the proper closed
   coefficient locus of factorization, degree drop, or `H=J=0` containment remains. Next compute
   those exceptional divisors and their intersections, and test affine coverage only if a genuinely
   collision-free stratum survives. The trace-one cover now has exact `t`-degrees `4`, `2`, and
   `0` on `a!=0`, `a=0,b!=0`, and `a=b=0`. The divisor `a=0` remains generically absolutely
   irreducible and collision-forcing. On `a=b=0`, the curve is univariate; all twelve normalized
   q=64 trace-one two-layer arcs acquire a collision over relative degree three. On the full
   coefficient-varying `a=b=0` locus, `H=delta*p^2*(z^2+z+1)` never vanishes on an odd scalar
   extension, so the reconstruction boundary disappears. The resultant is `H^2*h0+N(z)`; its
   exact inseparable divisor `h1=e^2+e*p` is collision-forcing because it reduces to a cubic in
   `z^2`. The separable complement has genuine pre-legality arithmetic survivors: an exact
   normalized GF(8) quotient has 270 of 5376 tuples with no odd factor for either seed color, while
   none of the twelve arc-legal trace-one pairs survives. Imposing arc legality now empties the
   joint gate. The census scaling that fixes `p=1` is a symmetry of the collision polynomial but not
   of the plane geometry: every arc-legal trace-one arc has constant pair-sum `p` in `{14,22,24}`,
   never `p=1`, so the whole normalized `p=1` slice — all 270 survivors included — is arc-illegal.
   Enumerating the entire constant-height two-layer arc space gives 22 arcs and 12 trace-one arcs,
   each colliding for at least one seed color; a full brute force confirms none of the 7512 both-seed
   collision-free configurations is arc-legal. Hence the arc-condition locus and the even-factor
   survivor set are disjoint and the `a=b=0` constant-height locus is closed. The `a=0,b!=0` stratum
   is now reduced: on `a=0` the trace-one cover is the conic `A2*t^2+A1*t+A0` with `A2=b^2*Q^2`
   (a perfect square, `Q=u^2+u*delta+delta^2`), `A1=delta*b*G1*G2`
   (`G1=u^2+u*p+p^2*theta`, `G2=u^3+u^2*delta+u*p^2*theta+delta*p^2*theta+delta^2*p`,
   `theta=w^2+w+1`, both irreducible and monic in `u`), and `A0` irreducible of `u`-degree six, with
   `gcd(A2,A1)=b` and `gcd(A2,A0)=gcd(A1,A0)=1`. The common-`u`-factor and `A1==0` reducibility
   mechanisms are therefore absent on `delta!=0,b!=0` (`A1==0` would force `delta*b=0`), so the whole
   stratum collapses to the single Artin--Schreier divisor `D3`: `phi=A0*A2/A1^2` in the
   Artin--Schreier image of `GF(2)-bar(params)(u)`. That divisor is now explicit and the stratum
   is closed: `W=(A0')^2*Q^4+A0*Q^2*(D')^2` vanishes identically mod `G1`, and mod `G2` gives
   three `h1`-free conditions whose complete solution off `delta*b*p=0` is `{e=0, h0=0}`,
   `{e=delta, h0=p^2*theta+e^2+e*b}`, and `{delta=p, theta=1, h0=e*(e+b+p)}` (two-chart resultant
   elimination; the `theta=0` and `h0`-free candidates force `delta=0`; the merged-pole locus
   `Res(G1,G2)=p^2*K1*K2` can only shrink `D3`). Every branch splits into explicitly rational
   components — no conjugate-component escape — and the `delta=p` witness reproduces its two
   collision lines `L1,L2` exactly in projective incidence over GF(64). `H` pulls back to
   `delta*G1`, rootless over every odd-tower field, so the `H=J=0` split locus is arithmetically
   empty and `r=J/H` always reconstructs; off `D3` Lang--Weil then forces collisions. Hence no
   collision-free coefficient stratum exists on `a=0,b!=0`; the `p=0`, `delta=0`, `b=0`
   boundaries are owned by the coincident-pair, single-coset, and `a=b=0` gates. On `a!=0`
   (t-degree four) the cover reduces to a single Artin--Schreier form
   `F=psi^2+sigma*psi+R1` (`psi=tau^2+bQ*tau`, `sigma=a*delta*N*G1*G2a`, `R1=a^2*Q^2*B0`), so the
   whole a!=0 factorization locus is one AS divisor `D_AS={R1/sigma^2 in AS-image}`
   ([`2026-07-17-c210-a-nonzero-artin-schreier-form.md`](../2026-07-17-c210-a-nonzero-artin-schreier-form.md)).
   The step-2(a) preflight is done and clean: `Res_u(G2a,G2a')=delta^4*p^2*N^2`,
   `Res_u(Q,G2a)=delta^2*N*K1*K2`, `Res_u(G1,G2a)=Res_u(G1,G2)=p^2*K1*K2` inherited free, and the
   infinity place is AS-trivial (value `(e/delta)^2+(e/delta)`), so the residue setup mirrors a=0 up
   to the arithmetically-empty `N` factors
   ([`2026-07-17-c210-a-nonzero-preflight-resultants.md`](../2026-07-17-c210-a-nonzero-preflight-resultants.md)).
   Step-2(b) part 1 is done: with `W=(B0')^2*Q^4+B0*Q^2*(D')^2`, `D=delta*N*G1*G2a`, `W==0 mod G1`
   identically (a=0 accident recurs; no `G1` condition) and `W mod G2a` gives exactly three `h1`-free,
   `h0`-linear conditions `C0,C1,C2` (content `(delta*N)^6`), the same shape as a=0's `P0,P1,P2`
   ([`2026-07-17-c210-a-nonzero-residue-conditions.md`](../2026-07-17-c210-a-nonzero-residue-conditions.md)).
   Step-2(b) part 2 is done for the branches themselves: `D_AS` has the three a=0 branches, a-deformed
   -- `e=0` (`h0=0`), `e=delta` (`h0=p^2*theta+e^2+e*b+e*a*p`), and `delta=p,theta=1`
   (`h0=e^2*a^2+e*a^2*p+e*a*p+e^2+e*b+e*p`), `h1` free, each verified to kill all three conditions and
   each recovering the a=0 value at `a=0`
   ([`2026-07-17-c210-a-nonzero-dAS-branches.md`](../2026-07-17-c210-a-nonzero-dAS-branches.md)).
   **Completeness is still open**: the cross-determinant variety strictly contains these three, so the
   extra locus must be shown spurious (no consistent `h0` lift) or inside `delta*p*N*K1*K2=0` by exact
   division/resultant/radical work (NOT minAssGTZ -- wrong on the a=0 analogue). Then decide each branch
   collision-forcing vs arc-legal via the second-layer `Tr(A/(bQ)^2)=0` test, before any affine-coverage test.
   Do not reopen the quadratic coefficient census or replace the symbolic gate with a larger plane census. See
   [`2026-07-16-c210-square-root-mechanism-audit.md`](../2026-07-16-c210-square-root-mechanism-audit.md).

## Entry action

If the user selects `relconic`, C188 and C223 need no residual work. Read the nested Lean guide
before any new Lean edit, generator run, build, or staleness probe.

## Durable companions

- lane discovery track (incidental observations only):
  [`2026-07-16-relconic-discovery-track.md`](../2026-07-16-relconic-discovery-track.md)
- C210 mechanism notebook (legacy filename; task history, not a discovery track):
  [`2026-07-16-c210-discovery-track.md`](../2026-07-16-c210-discovery-track.md)
- C210 pipeline reproducibility manifest (sha256/byte counts, check command):
  [`2026-07-17-c210-reproducibility-manifest.md`](../2026-07-17-c210-reproducibility-manifest.md);
  machine-checkable list `papers/arcs_complete_outside_conic/analyze_c210_SHA256SUMS`
- C210 a=0 stratum independent verification + promotion note:
  [`2026-07-17-c210-a-zero-verification.md`](../2026-07-17-c210-a-zero-verification.md)
- C210 a=0 closure report (explicit AS divisor, branch decomposition, witnesses):
  [`2026-07-17-c210-a-zero-artin-schreier-divisor.md`](../2026-07-17-c210-a-zero-artin-schreier-divisor.md)
- C210 a!=0 step 1 (reduction to a single AS form `F=psi^2+sigma*psi+R1`):
  [`2026-07-17-c210-a-nonzero-artin-schreier-form.md`](../2026-07-17-c210-a-nonzero-artin-schreier-form.md)
- C210 a!=0 step-2(a) preflight (resultants + infinity-place AS-triviality; residue setup clean):
  [`2026-07-17-c210-a-nonzero-preflight-resultants.md`](../2026-07-17-c210-a-nonzero-preflight-resultants.md)
- C210 a!=0 step-2(b) part 1 (residue conditions: G1 trivial, three h0-linear G2a conditions):
  [`2026-07-17-c210-a-nonzero-residue-conditions.md`](../2026-07-17-c210-a-nonzero-residue-conditions.md)
- C210 a!=0 step-2(b) part 2 (three explicit D_AS branches + forced h0; completeness open):
  [`2026-07-17-c210-a-nonzero-dAS-branches.md`](../2026-07-17-c210-a-nonzero-dAS-branches.md)
- C210 a!=0 step-1/step-2 Fable review (traps, progress bar, landing odds):
  [`2026-07-17-c210-fable-review.md`](../2026-07-17-c210-fable-review.md)
- C201 mechanism-audit notebook (legacy filename; task history, not a discovery track):
  [`2026-07-16-c201-discovery-track.md`](../2026-07-16-c201-discovery-track.md)
- live global queue:
  [`2026-07-07-codex-task-queue.md`](../2026-07-07-codex-task-queue.md)
- prior aggregate relconic map:
  [`2026-07-13-relative-conic-arcs-strengthening.md`](2026-07-13-relative-conic-arcs-strengthening.md)
