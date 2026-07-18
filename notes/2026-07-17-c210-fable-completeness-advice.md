# C210 Fable completeness advice (a!=0 D_AS)

**Lane**: `relconic` (advice record; C210 active)

Date: 2026-07-17. Read-only strategic advice by a Fable sub-agent on closing the
a!=0 `D_AS` completeness question left open by
[`2026-07-17-c210-a-nonzero-dAS-branches.md`](2026-07-17-c210-a-nonzero-dAS-branches.md),
against the a=0 template
([`2026-07-17-c210-a-zero-artin-schreier-divisor.md`](2026-07-17-c210-a-zero-artin-schreier-divisor.md)).
No code changed; no heavy computation run.

## 1. Verdict up front

Neither R1 nor R2 as stated. R1 is wrong-shaped (section 3), and R2 as written
assumes the "pollution" reading of the 2-dimensional excess surface, which has
not been earned (section 2). Recommended order: a cheap finite-field
census/liftability probe that decides whether the excess surface is pollution
or a missing fourth branch; then per-branch explicit splits plus the
merged-pole port (mandatory for branch 3 regardless of route, section 6); then
the second-layer trace test (the crux, section 5); and only then the full
completeness certificate, as a refined R2 in at most four base variables
(section 4). If the probe finds extra points, the "missing branch" path
preempts everything except the splits.

## 2. The load-bearing observation: pair-zeros with a nonzero A_i always lift

Char-2 identity, immediate from `c_i = h0*A_i + B_i`:

    A_i*c_j + A_j*c_i = E_ij.

Consequences, all exact:

- On the chart `A_0 != 0`, setting `h0 = B_0/A_0` gives `c_j = E_0j/A_0`; and
  off `e*(e+delta)*delta*p*N = 0` each `E_0j` vanishes iff `R_0j` does. So
  **every** base point `(delta,p,w,a)` in `V(R01,R02)` lifts to a genuine
  `D_AS` point at any `(e,b)` where `A_0 != 0` (and `R12 = 0` is then
  automatic: `A_0*E12 = A_1*(A_0*B_2) + A_2*(A_0*B_1) = 0` using
  `E01 = E02 = 0`).
- Therefore "`V(P01,P12,P02)` is polluted by the degenerate `A_i=0` locus" is
  a strong claim, not a bookkeeping remark. Off the exclusions the excess
  surface `S` has exactly two possible natures: (a) `S` lies inside the common
  vanishing of **every** `(e,b)`-coefficient of `A_0,A_1,A_2` (an ideal
  `CA` in `GF(2)[delta,a,p,w]`) — true pollution, routed to the all-A case —
  or (b) `S` carries points with some `A_i != 0`, in which case it is a
  **genuine missing branch family with 2-dimensional base**, not pollution.
  There is no third option.
- (b) would not be a failure; it would be the interesting outcome. A new branch
  feeds the same second-layer trace test as branches 1-3 and is another place
  the sought construction could hide.

The a=0 analogy cuts both ways here: a=0 did have an h0-free candidate, but it
also had residuals that were `(delta,p,w)`-only with no `a` to hide structure
in. Do not assume (a) by analogy; decide it (step 0 below, near-free).

## 3. R1 verdict: wrong-shaped, not just heavy

Exact ideal equality of the saturated `(c0,c1,c2)` with
`(delta+p, w^2+w, h0-h0_3)` is expected to **fail even when completeness is
true**, for two structural reasons:

- The saturated ideal legitimately retains components supported on `theta=0`
  (and `N`-adjacent loci) that are arithmetically empty over `GF(8^m)`, odd
  `m`, but algebraically present. The a=0 completeness itself was arithmetic,
  not scheme-theoretic — its residual contained a `theta=0` part excluded by
  the odd-tower argument, not by the ideal.
- The system is visibly non-reduced (the `E_ij` carry `R_ij^2` squares), so
  equality would need a radical computation in seven variables — exactly the
  computation that already had to be killed.

Frame the target arithmetically from the start: *every rational point of
`V(c0,c1,c2)` over `GF(8^m)`, `m` odd, off `delta*p*N*K1*K2=0`, lies on branch
1, 2, or 3.* That is what downstream collision-forcing consumes, and it is
strictly easier than any ideal equality. Keep R1 only as an optional final
confirmation in the dehomogenized at-most-four-variable ring (step 5).

## 4. Recipe (ordered)

**Step 0 — GF(8) census + liftability probe (no Groebner; do first).**
Enumerate `(e,delta,a,b,p,w,h0)` in `GF(8)^7` with `delta,p,a != 0` — note
`N != 0` and `theta != 0` hold automatically over `GF(8)` (their roots live in
`GF(4)\GF(2)`) — test `c0=c1=c2=0`, and compare **as a set** against the
three-branch union, exactly the a=0 census discipline. Split the counts by
`K1*K2=0` versus not (the `c_i` characterization is only derived off
`K1*K2=0`; on it the census is a census of the polynomial system, pending
step 2). Volume is about `7^3*8^4` bases; with `h0`-linearity, evaluate
`A_i,B_i` per base and solve — small enough for table-driven Python, trivial
in Rust. Separately, probe `S` where it is thin over `GF(8)`: take `GF(512)`
points on `S` off branch 3 (`delta != p` or both, `w` outside `GF(2)`), sweep
`(e,b,h0)`, and test lifts directly. Census clean + probes lift-free supports
(a); any extra point localizes the missing branch rationally and switches the
plan to the new-branch path.

**Step 1 — cheap structure certificates for the residuals.** One Singular
block: (i) variable support of `R01,R12,R02` (expected `(delta,p,w,a)`-only —
the elimination evidence suggests it but nothing committed certifies it); (ii)
`(delta,p)`-homogeneity with `a,w` weight 0 (the a=0 report's tractability
lever; check it, do not inherit it); (iii) the two uncommitted pairwise gcds
`gcd(R01,R02)`, `gcd(R12,R02)` — a common factor would name `S` immediately.
Then set `p=1` everywhere: the allowed locus has `p != 0`, so with homogeneity
the chart is lossless for arithmetic points. Everything after this lives in
`GF(2)[delta,w,a]` for Case 1.

**Step 2 — membership hardening: explicit splits + merged-pole port.**
Prerequisite for the trace test and for referee-solid branch membership; see
section 6. Do this before the completeness proof proper.

**Step 3 — second-layer trace test on the (now certified) branch list.** See
section 5 for why this precedes full completeness.

**Step 4 — completeness certificate (refined R2, case split).**

- *Lemma (prose, one paragraph):* off `delta*p*N*K1*K2=0` and `e` outside
  `{0,delta}`, `D_AS` is the union over charts
  `{A_i != 0, base in V(pair_i), h0 = B_i/A_i}` plus the all-A locus
  `{A_0=A_1=A_2=0, B_0=B_1=B_2=0, h0 free}`. Cite the section-2 identity; this
  is linear algebra, not computation.
- *Case 2 (all-A) first*, since it is where any true pollution must live:
  eliminate `e` then `b` from `(A_0,A_1,A_2,B_0,B_1,B_2)` by resultants
  (`deg_e <= 2` keeps these small); target the a=0 pattern "all-alpha forces
  `theta=0`". Also check explicitly whether the all-A locus meets
  `{delta=p, theta=1}`: if it does, branch 3 acquires an `h0`-free sublocus
  that must be named and fed to the trace test as its own case.
- *Case 1 per pair*, after `p=1`: gcd-check, then `Res_a` of each pair, factor
  the resulting bivariate `(delta,w)` polynomials (cheap in Singular), expect
  `(delta+1)`-powers, `w`, `w+1`, `theta`, plus possibly `S`'s equation. For
  each surviving factor: verify by substitution back (resultants produce
  extraneous factors; never trust one unsubstantiated), then classify it as
  branch 3, `theta=0` (arithmetically excluded, `GF(4)` gcd as in a=0),
  inside `V(CA)` (exact reduction of each `CA` generator modulo the factor —
  routes to Case 2), or a new branch.
- *Certificate discipline:* Rabinowitsch 1-in-ideal checks for the
  containments (tiny after `p=1` and pair reduction: three base variables plus
  auxiliaries, and the lifted cofactors are themselves checkable
  certificates); exact division/gcd/resultant otherwise; saturate by single
  polynomials sequentially, never by products; `p=1` before any `std`; no
  `minAssGTZ`/`primdec` anywhere (known-wrong precedent on the a=0 analogue).

**Step 5 — optional:** the R1-style ideal equality, but only in the
dehomogenized reduced ring where it costs minutes, as confirmation rather than
proof.

## 5. Q3, sequencing: probe first, crux second, completeness third

- The trace test is on the critical path in **every** scenario — three
  branches or four, complete or not. Full completeness is load-bearing only in
  the all-collision-forcing endgame.
- An arc-legal rootless branch is terminal (a construction) and demotes
  completeness to bookkeeping. The asymmetry favors testing the branches you
  have before proving you have them all.
- The exception is step 0: near-free, and it decides whether the branch list
  the trace test runs on is even the right list. A missing 2-dimensional
  branch family discovered *after* a negative trace verdict on branches 1-3
  would be the expensive ordering; discovered before, it is the jackpot
  ordering.
- Accepted risk: if all branches prove collision-forcing, completeness returns
  as the final gate having been delayed by one work item — but that item
  (splits + merged-pole port) was mandatory for the trace test anyway.

Order: step 0, step 2, step 3, step 4, step 5.

## 6. Q4, merged-pole traps: branch 3 lives entirely on K1*K2=0

At `delta=p`: `K1 = p^2*w^2` and `K2 = p^2*(w+1)^2`, so the `w=0` half of
branch 3 sits on `K1=0` and the `w=1` half on `K2=0` — **every** branch-3
point is a merged-pole point. But the committed `c_i` characterization of
`D_AS` is derived off `delta*p*N*K1*K2=0` (the branch checker says so
explicitly). As committed, branch 3's membership in `D_AS` is a
closure/limit statement, not yet a factorization statement. Two obligations:

1. **Port the a=0 merged-pole lemma.** At a common root `rho` of `G1,G2a`,
   `D'(rho)=0` for the same one-line reason as a=0 (`D = delta*N*G1*G2a`, both
   factors vanish at `rho`), so `W(rho) = f'(rho)^2` and AS-triviality still
   forces the `G2a`-divisibility conditions; the port is near-verbatim because
   `Res(G1,G2a) = Res(G1,G2)` identically. This gives the "only shrinks
   `D_AS`" direction on `a != 0`.
2. **Better: bypass residue calculus for membership entirely.** On each
   branch, substitute the branch conditions and forced `h0` and exhibit the
   explicit split `F = (tau^2 + bQ*tau + A_br)(tau^2 + bQ*tau + A_br')` by
   exact division — the a=0 report's `L1/L2` pattern one level up. This is
   cheap, immune to every pole-degeneracy question, upgrades branch
   membership from "satisfies the residue conditions" to "factors, by
   identity", and produces exactly the `A(u)` per branch that the
   second-layer trace test `Tr(A/(bQ)^2)=0` consumes. Do it for all three
   branches, not just branch 3.

Further pre-emptions:

- Witness fields: `GF(8)`/`GF(512)` only (odd tower). `GF(64)` is the a=0
  report's own flagged trap — an even-tower field where `N=0` and `theta=0`
  acquire rational points.
- On branch 3, `w` in `GF(2)` and `theta=1` make `G1 = u^2 + u*p + p^2` the
  rootless trace-one quadratic — the same object as the a=0 split-locus
  argument. Expect and exploit that structure in the branch-3 trace test
  rather than treating the branch generically.
- The trace test on branch 3 evaluates `A(u)/(bQ)^2` in a configuration where
  a `G1` root coincides with a `G2a` root; set up its pole bookkeeping from
  the merged geometry directly instead of specializing the generic-pole
  formulas.

## 7. Q2: the a=0-to-a!=0 deformation shortcut is a trap; salvage it as a check

As a proof it fails for three crisp reasons:

- Completeness is a fiber-wise radical statement, and the residual scheme is
  not known (or likely) to be flat over the `a`-line. A component supported
  over `{a != 0}` can specialize at `a=0` **into** the known a=0 branches or
  the excluded loci and leave no independent trace there; a=0 completeness
  therefore bounds where extra `a != 0` components *land*, not whether they
  *exist*.
- The scheme is non-reduced (`R_ij^2` squares), so any conservation-of-degree
  or multiplicity argument would need bookkeeping nobody has done.
- The exclusion divisors themselves move with `a` (`N`, `Res(G2a,G2a')`), so
  "the fiber over `a=0`" and "the locus the theorem is about" do not agree at
  the boundary.

Salvage: any candidate extra component **must** have its `a -> 0` closure
inside the a=0 divisor union `theta=0` union exclusions. That is a fast
falsifier for candidate factors in step 4 — and note the excess surface `S`
passes it (its ideal sits inside `(delta+p, w^2+w)`, consistent with limiting
into branch 3's base), which is precisely why the check can only falsify,
never confirm.

Files relied on: `/home/tavis/src/othello/notes/2026-07-17-c210-a-nonzero-artin-schreier-form.md`,
`.../2026-07-17-c210-a-nonzero-preflight-resultants.md`,
`.../2026-07-17-c210-a-nonzero-residue-conditions.md`,
`.../2026-07-17-c210-a-nonzero-dAS-branches.md` (snag statement, `E_ij`
factorizations), `.../2026-07-17-c210-a-zero-artin-schreier-divisor.md`
(Statement 2-5, Method notes),
`/home/tavis/src/othello/papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_dAS_branches.py`
(excluded-locus scope line),
`.../analyze_c210_a_zero_artin_schreier_divisor.py` (two-chart certificate
structure).
