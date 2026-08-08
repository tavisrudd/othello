# C787 — relative two-state intertwiner stability

**Date:** 2026-08-08

**Lane:** `ame-lu`

**Status:** complete; the exact-base gap reduces losslessly to one-state
cleaning stability

## Verdict

The remaining gap is closed, but not by a new Hessian estimate.

Let `psi` and `phi` be stabilizer `AME(2m,q)` states, `q=p^e`,
`m>=2`, and assume an exact product-unitary intertwiner
`B=Tensor_i B_i` is fixed:

```
B psi = phase * phi.
```

For a second product unitary `U`, define its two-state ray defect by

```
eps_{psi->phi}(U) = min_phase ||U psi - phase * phi||.
```

Then `W=B^dagger U` is an approximate symmetry of `psi` with exactly
the same defect.  C833's cleaning theorem therefore transfers without any
loss:

1. If `eps_{psi->phi}(U)<tau_p/8`, every `U_i` lies within normalized
   Hilbert--Schmidt distance `8 eps_{psi->phi}(U)` of `B_i K_i` for a
   one-qudit additive Clifford `K_i).
2. If `eps_{psi->phi}(U)<R_clean(n,q)`, there is an exact product-unitary
   intertwiner `H` from `psi` to `phi` and traceless Hermitian `h_i`
   of spectral spread at most `pi` such that, up to phase,

   ```
   U = H Tensor_i exp(i h_i),
   (Sum_i ||h_i||_F^2)^(1/2) <= pi sqrt(q) eps_{psi->phi}(U).
   ```

   Consequently

   ```
   Sum_i d_2(U_i,H_i)^2 <= pi^2 eps_{psi->phi}(U)^2.
   ```

Both stability constants are independent of the party count.  The certified
exact-branch radius remains

```
R_clean(n,q) = min {
  tau_p/8,
  1/(4 sqrt(2q)),
  1/(8 pi sqrt(n)),
  d_p/(1+4 pi sqrt(n))
}.
```

Thus the result does not claim a party-count-independent defect ball.

## Exact torsor reduction

Let `G(psi)` denote the exact product-unitary symmetry group of `psi`,
and let `I(psi,phi)` be the exact product-unitary intertwiner set.  A fixed
`B in I(psi,phi)` identifies

```
I(psi,phi) = B G(psi) = G(phi) B.
```

Indeed, `H` intertwines `psi` with `phi` exactly if and only if
`B^dagger H` fixes the ray of `psi`.  Left multiplication by `B`
preserves the phase-optimized Hilbert--Schmidt metrics on every local factor.
It also identifies the two defect functions:

```
eps_{psi->phi}(B W) = eps_psi(W).
```

Apply C833 to `W=B^dagger U`.  Its local cleaning/Fourier step gives
`d_2(W_i,K_i)<=8 eps`; left multiplication gives
`d_2(U_i,B_iK_i)<=8 eps`.  Under `R_clean`, C833 writes
`W=g Tensor_i exp(i h_i)` with `g in G(psi)` and the displayed
collective estimate.  Then `H=Bg` belongs to `I(psi,phi)`, proving the
global statement.

Exact LU-to-LC rigidity implies every `B_i` is itself Clifford.  This
identifies each `B_iK_i` as a Clifford, but the relative reduction does not
need that fact.

If party permutation is allowed, perform the common relabelling once and
absorb it into the base `B`; the fixed-party proof then applies verbatim.

## Hessian interpretation

The requested Hessian relativization is automatic.  If

```
f_psi(W) = eps_psi(W)^2,
f_{psi->phi}(U) = eps_{psi->phi}(U)^2,
```

then `f_{psi->phi}(BW)=f_psi(W)`.  Left translation is an isometry of the
product-unitary manifold for the local Hilbert--Schmidt metric, so the
gradient, Hessian, zero modes, and transverse coercivity at `B` are the
pullbacks of those at the identity.  No party-count factor can appear in this
change of base point.  The cleaning theorem is stronger than the infinitesimal
statement: it supplies the nonlinear certified neighbourhood, exact branch,
and collective residual bound.

## Reconciliation with the owning results

### C581 and the Appendix-B marginal theorem

C581's `2 sqrt(2) q^2 eps` bound, generalized in the manuscript to
`2 sqrt(2) q^((m+1)/2) eps`, assumes no exact base intertwiner.  It must
read one `(m+1)`-party marginal to discover the target Weyl axes.  The
coefficient `q^{-(m+1)/2}` in that marginal forces the reciprocal scale.

C787 makes the stronger exact-orbit hypothesis.  The base `B` already
identifies the target axes and stabilizer character, so the marginal discovery
step is unnecessary.  C581 remains the correct no-base theorem; C787 is the
lossless stability theorem within a known exact orbit.

### C786

C786 already observed that its general marginal argument is easier for a
one-state symmetry than for a two-state intertwiner, but it still used the
diluted marginal.  C833 later replaced that one-state entry mechanism by
three-region cleaning.  C787 performs the missing composition:

```
exact base translation + C833 cleaning = two-state exact-orbit stability.
```

Hence C786 Part II overlaps the old no-base route, while its marginal
coefficient is irrelevant after the base is fixed.

### C838

C838's affine-character obstruction concerns constructing a nearby exact
symmetry from commutator data before the branch is known.  In C787 the exact
base supplies the complete character identification before perturbation, and
C833 selects the residual exact branch at `R_clean`.  Nothing in the proof
tries to recover the affine character from localized commutators, so the C838
no-go is respected.

### C889

C889 cancels the uncontrolled Pauli correction on one chosen input leg and
therefore rounds the induced logical action at the larger atlas radius.  It
does not give a nearby exact physical intertwiner.  C787 gives that global
physical conclusion under the smaller `R_clean` radius and the additional
exact-base hypothesis.  The two results are complementary.

## Scope and sharp boundary

- The base need only exist mathematically; the theorem is a stability result
  on the exact-intertwiner torsor.  Constructing or recognizing `B` is a
  separate exact-classification problem.
- Without an exact base, the two-state marginal theorem remains necessary.
- The ratio constants `8` and `pi sqrt(q)` do not depend on `n`.
- The branch-selection radius retains its `n^{-1/2}` term.  C787 does not
  solve the open collective pre-entry problem and does not contradict the
  manuscript's explicit exclusion of a party-count-independent defect ball.
- The target is the full additive Clifford group over the underlying
  prime-field Weyl phase space.  C623 still forbids a uniform semilinear or
  split-torus strengthening.

No computation, certificate, or new literature claim is involved.  The result
is a formal consequence of the proved C833 theorem and exact LU-to-LC
rigidity.  It has no Lean coverage beyond the already recorded exact
rigidity/Choi cores.

## Manuscript disposition

The result is adopted as
`cor:relative-intertwiner-rounding` immediately after the cleaning theorem's
collective estimate.  The introduction and Appendix B now distinguish:

- exact-base two-state stability, which inherits the cleaning scale without
  loss; and
- no-base two-state detection, which retains the
  `q^{-(m+1)/2}` marginal scale.

The theorem, claim/proof/novelty, verification, and formalization maps carry the
same boundary.  No novelty adjective or new citation was added.

## Validation

- `make -C papers/ame_lu check` passes warning-free at 36 pages; the tracked
  PDF has 311,089 bytes.
- Corollary 5.4 and the transition to Proposition 5.5 render cleanly on page
  12.  The revised introduction renders cleanly on page 2.
- `make -C papers/ame_lu release-check` verifies 18 public artifacts with
  public tree
  `e0cc53fdadac4db3ced9a62c14744ff02fe487a0c4f8f6435b0db05ed5b664f4`
  and the unchanged 82-artifact formal companion tree
  `9689cefd30fe04d163d32ba93e5f84b3a67906db69e57bd1a254c411ddabb131`.
- No computation, Lean edit/build, standalone mirror, remote, deposit, tag, or
  submission was used.

## EJ + Tao closeout

The cheap upgrade is the exact torsor identity
`I(psi,phi)=B G(psi)`.  It packages all relative estimates, including future
improvements of the one-state theorem: any better one-state radius or residual
constant will transfer automatically to every exact two-state orbit.

The Tao-style question is what information the expensive marginal was buying.
It was not stability; it was orbit discovery.  Once the orbit is supplied by
`B`, homogeneity removes that entire condition number.  This cleanly assigns
the two constants to different tasks rather than treating
`q^((m+1)/2)` as slack in the same theorem.

## Mystery ledger

| Feature | Closeout status | Remaining gap or owner |
|---|---|---|
| Why did the two-state constant grow like `q^((m+1)/2)`? | **settled:** it pays for discovering the target axes from one diluted marginal, not for stability within an exact orbit | no-base theorem remains C581/Appendix B |
| Does changing the exact base alter Hessian coercivity? | **settled negatively:** left translation is isometric and conjugates the full defect germ | none |
| Can one obtain a nearby exact two-state intertwiner with an `n`-independent ratio constant? | **settled positively:** `H=Bg` and the collective constant is `pi sqrt(q)` | none |
| Is the certified radius independent of `n`? | **no:** it remains `R_clean=Theta_q(n^{-1/2})` at fixed `q` | collective pre-entry/affine-character problem from C837--C838 |
| Does C889 already imply the physical theorem? | **settled negatively:** it controls one logical image at the atlas radius, not the full physical correction | none |

No genuine mystery remains inside the exact-base problem.

## Vibe check

Clean closure.  The apparent two-state conditioning gap was a mismatch of
hypotheses: orbit discovery is expensive, while stability on a fixed exact
orbit is homogeneous and inherits the one-state constants exactly.
