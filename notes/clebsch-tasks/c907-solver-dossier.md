# C907 solver dossier

**Lane:** `clebsch`

Load with `c907-quantum-monodromy-stabilization.md` when attacking the open
moonshot.  This is proof-design context, not attribution, outreach, or a
literature audit.

## Exact reduction

For a smooth cubic threefold `X`, C907 already proves:

- `X x P^m` has `m+1` cubic `+/-1/6` blocks;
- the endpoint Tate width is `m`, equivalently enriched unipotent length
  `m+1`;
- every self-carrier center contribution has width at most `m-2`; and
- coarse multiplicity cannot obstruct rationality for `m >= 2`.

For `m=2`, the target reduces to two theorems.

1. **Strict codimension-two blow-up comparison.**  On the cubic-isotypic
   Stokes/Rees piece,
   \[
   gr_{1/6}A(Bl_ZY)=gr_{1/6}A(Y)\oplus T\,gr_{1/6}A(Z),
   \]
   compatibly with the Gamma lattice and composition.
2. **Threefold carrier bound.**  Every smooth projective threefold `Z` has
   enriched cubic-isotypic length `ell_(1/6)(Z) <= 1`.

The endpoint has length three; centers of dimension at most two have no cubic
atom; threefold centers have codimension two and contribute one shift.  The two
theorems therefore imply `X x P^2` irrational.

## Solver profile

| Lens | Contribution |
| --- | --- |
| Hiroshi Iritani | Master-space Fourier map, quantum blow-up theorem, local exceptional valuations, Gamma lattice, mutation-system/Riemann--Hilbert formulation. Closest single architect. |
| Claude Sabbah / Takuro Mochizuki | Stokes filtrations, irregular Hodge and wild twistor `D`-modules, strict projective functoriality, rescaling, gluing, Thom--Sebastiani. |
| Tony Yue Yu / Shaowu Zhang | Formal `F`-bundle uniqueness and the topological Laplace bridge from spectral/Stokes data to vanishing cycles. |
| Alexander Kuznetsov | Cubic residual category, mutations, Serre dynamics, and gluing-sensitive fractional-CY formulations. |
| Janos Kollar | Arbitrary threefold centers, MMP limits, and hostile review of any claimed Fano/Mori-fibre exhaustion. |
| Jiaji Cai | Exact cubic block and the small-to-big quantum connection bridge. |

The analytic theorem plausibly needs the Iritani plus Sabbah/Mochizuki and
Yu/Zhang skill sets.  The carrier theorem needs a separate cubic-category and
threefold-birational input.

## Attack order

1. Define `ell_(1/6)` on the full rank-four cubic hypergeometric module as
   phase-invariant width of its zero-exponential Stokes graded piece.  Match it
   with the Rees valuations and enriched Serre block only in proved pilots.
2. **Current first pass:** prove or refute `ell_(1/6)(Z) <= 1` for
   nef-canonical threefolds.  Quintic Calabi--Yau and sextic general-type
   hypersurfaces are mandatory tests.  Derive a structural bound before any
   database scan.
3. Specialize Iritani's comparison to codimension two.  Extend the strict
   `Q=theta=0` double-associated-graded pilot to first Novikov order.  Express
   failure as an explicit extension class of Stokes-filtered local systems or
   mutation systems.
4. Transport that class through topological Laplace transform.  Test a toric
   center and one non-toric complete-intersection center.  Prove vanishing or
   identify the minimum correction datum.
5. If both gates pass, telescope the strict associated-graded formula through
   weak factorization and audit explicitly that extensions cannot join center
   blocks into the endpoint length-three block.

Only after the `m=2` theorem should the program generalize the analytic
comparison to every codimension and the carrier bound to `width <= dim-3`.

## Questions that control the work

- What Betti/Stokes datum is lost by the unique formal `F`-bundle map?
- Can the middle zero-exponential piece be isolated functorially without
  making it a nonexistent global submodule?
- Is width invariant under Stokes mutation although the flag is not?
- Does topological Laplace transform make the center term a canonical
  vanishing-cycle summand?
- What exact extension class obstructs Gamma-lattice strictness in codimension
  two?
- Does the nef-canonical normal form bound enriched length in dimension three,
  or only exponent support?
- Can a Calabi--Yau or general-type threefold furnish a length-two
  counterexample?

## Reject immediately

- raw atom multiplicity or another bounded polynomial search;
- globalizing Cai's local rank-two block (the full module is irreducible);
- Euler/Serre data without a strict filtration;
- plain `C[[t]]` Krull--Schmidt without the unipotent operator;
- global eigenbranch labels;
- prime-power loop arguments without global functoriality;
- a Fano database presented as all threefold centers;
- general Serre-dimension monotonicity;
- Bittner coherence presented as existence of the filtered assignment; or
- fixed-Landau--Ginzburg compactification independence presented as A-model
  target blow-up functoriality.

## Source spine

- Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555: Theorem 5.18,
  (5.19), (5.27), (5.28), Remark 1.5.
- Iritani, *Gamma classes and quantum cohomology*, arXiv:2307.15938.
- Iritani, *Global Mirrors and Discrepant Transformations for Toric
  Deligne--Mumford Stacks*, arXiv:1906.00801: Theorem 1.3,
  Remark 1.4(3), Conjecture 8.3, Proposition 8.5.
- Hinault--Yu--Zhang--Zhang, arXiv:2411.02266.
- Yu--Zhang, *Topological Laplace Transform and Decomposition of nc-Hodge
  Structures*, arXiv:2405.19549.
- Sabbah, *Irregular Hodge theory*, arXiv:1511.00176: Theorems 0.3, 0.7,
  3.39; Sabbah--Yu, arXiv:1406.1339.
- KKPYY, *Birational Invariants from Hodge Structures and Quantum
  Multiplication*, arXiv:2508.05105.
- C907 full report: `../2026-08-10-c907-quantum-monodromy-stabilization.md`.
