# C443 M3a — integral quotient and reduction specification

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Status:** frozen formulation for M3b; no computational verdict

**Executor:** `5.6-sol-xhigh`, standing in for the program's Fable formulation role

This note discharges the formulation gate that the Weil-roof execution program labels “Fable.”
It was produced by `5.6-sol-xhigh` as the explicit stand-in for that role.  M3b must implement this
specification verbatim.  In particular, it may not manufacture an integral answer by applying the
Chinese remainder theorem to the already-known mod-11 tensors.  The generic object must be
constructed first from C458's frozen golden sheet frame; the two reductions are then tests of that
object.

## 1. Rings, automorphisms, and prohibited denominators

Put

```text
E_0 = Z[zeta]/(zeta^4+zeta^3+zeta^2+zeta+1),
phi = 1+zeta+zeta^(-1),                 O_0 = Z[phi] <= E_0.
```

Let `kappa(zeta)=zeta^(-1)` and `sigma(zeta)=zeta^2`.  Thus `E_0^kappa=O_0`,
`sigma(phi)=1-phi`, and `sigma^2=kappa`.  M3b may localize to

```text
E=E_0[1/N],             O=O_0[1/N]
```

only after deriving the squarefree rational denominator set `N` from every coefficient actually
used.  The integer 11 is never inverted.  The canonical JSON must give a stage-by-stage denominator
ledger, the norm of every algebraic denominator before it is folded into `N`, and the literal checks
`gcd(N,11)=1` and `11 not in denominator_primes`.  A required denominator above 11 is the program's
guardrail-3 blocker; M3b must stop rather than change this specification.

The two primes of `O_0` above 11 are represented by `phi -> 8` (`pi`) and `phi -> 4` (`pibar`).
For computations in `E_0`, the two primes above `pi` are `zeta -> 3,4`, and those above `pibar`
are `zeta -> 5,9`.  Agreement within each `kappa`-pair is part of descent, not an assumption.

## 2. Frozen golden conic and its split cover

Use C458's anisotropic conic, with no coordinate change,

```text
C: q=x^2+y^2+z^2=0.
```

In `E_0`, put `r=zeta-zeta^(-1)` and

```text
u=(-phi,r,1),       e=(phi,-r,1),       w=u cross e=(2r,2phi,0),
B=[u w e].
```

M3b must verify directly

```text
q(u)=q(e)=0,       u.e=2,       q(w)=-4,
q(B[X,Y,Z])=4(XZ-Y^2).
```

The order-60 golden reflection group `H` is exactly the hash-pinned C442/C458 group over `O_0`.
Let `R` be C440's frozen 12-element orbit of **primitive homogeneous** root vectors `[s:t]` in
`E_0^2`; C440/M1 already verify that these vectors have good reduction at all four roots
`zeta=3,4,5,9`.  Define

```text
V_+={B[s^2,st,t^2] : [s:t] in R}.
```

M3b must verify that `V_+=H.u` as a projective set and has 12 points.  The conjugate set is
`V_-=sigma(V_+)`, and both lie on the same frozen conic.  The primitive vectors from `R`, not an
affine chart normalization of `B^(-1)p`, are the representatives used to scale secants.  This is
load-bearing: a point specializing to infinity may not be normalized by inverting a coordinate
that lies above 11.

On the 12 points of `V_+`, compute the `H`-orbits of perfect matchings.  Let `M_0` be the unique
`H`-fixed polar matching.  The positive sheet `F_+` is required to be

```text
{M_0} union O_10,
```

where `O_10` is the unique size-ten matching orbit for which the eleven matchings form a
one-factorization of `K_12`.  This uniqueness, the eleven matching records, and every edge count
are acceptance objects.  Define `F_-=sigma(F_+)` on `V_-`; do not choose it from mod-11 data.

Failure of the 12-point orbit, the unique fixed matching, the unique one-factorizing size-ten
orbit, or Galois transport is a blocker.  The full 22-point `PGL_2(11)` orbit is deliberately not
lifted; M3b lifts one `1+10` `A5`-visible sheet and obtains the other by golden conjugation, exactly
as required by the master-stroke boundary.

## 3. Integral products and quotient lattices

Let `S_d(A)` denote degree-`d` ternary forms.  Freeze the lexicographic monomial bases

```text
B_d=((a,b,d-a-b): 0<=a<=d, 0<=b<=d-a)
```

in that order.  For the standard conic endpoints given by C440's primitive vectors `[s_i:t_i]`,
use C406's exact secant scaling

```text
L_ij=t_i t_j X-(s_i t_j+t_i s_j)Y+s_i s_j Z.
```

Pull `L_ij` back to the golden plane through `B^(-1)` (respectively `sigma(B)^(-1)`) and let
`P_M` be the product of its six secants.  The product of the twelve endpoint factors is common to
every matching.  Normalize it once, sheetwise and before taking moments, to C440's frozen Klein
form `xy(x^10+11x^5y^5-y^10)`; the normalization divisor and its norm belong in the denominator
ledger and must be an 11-unit.  Pointwise or matching-dependent rescaling is forbidden.  M3b must
check, rather than assume, that all normalized `P_M` within one sheet have one common restriction
to `C` and that `sigma(P_M)=P_sigma(M)`.

The quotient construction is the integral, coefficient-one division

```text
P=q Phi(P)+R(P),              deg_z R(P)<2.
```

It is obtained by repeatedly replacing `z^2` with `-x^2-y^2`; no matrix inversion or averaging is
permitted in this step.  Consequently the exact lattices and bases are:

- `S_4(O)` with the 15-element basis `B_4` for every quotient vector `Phi(P_M)`;
- `S_6(O)/(q S_4(O))` with the 13 normal monomials in `B_6` having `z`-degree at most one;
- `Sym^k(S_4(O))`, for `k=1,2,3`, with the unscaled ordered-index basis
  `i_1<=...<=i_k` (dimensions `15,120,680`).

The unscaled symmetric basis is load-bearing: no factorial, polarization, or multinomial
denominator is allowed.  M3b must expose both quotient and remainder for every matching and verify
`P_M=q Phi(P_M)+R(P_M)` coefficient-by-coefficient.

## 4. Descent and the three moments

For `k=1,2,3`, form the raw positive-sheet moment

```text
T_k=sum_(M in F_+) Phi(P_M)^(symmetric k) in Sym^k(S_4(E)).
```

Descend it before taking the sheet difference:

```text
T_k^0=(T_k+kappa(T_k))/2 in Sym^k(S_4(O)),
mu_k=T_k^0-sigma(T_k^0) in Sym^k(S_4(O)).
```

The factor `1/2` is the only pre-authorized localization; its actual necessity and every further
denominator still belong in the ledger.  The certificate must verify coefficientwise that
`kappa(T_k^0)=T_k^0` and

```text
sigma(mu_k)=-mu_k.
```

No vanishing over characteristic zero is assumed.  If `mu_1` or `mu_2` is nonzero integrally but
lies in `11 Sym^k(S_4(O))`, record the exact divided tensor and state that the lower moments vanish
only after specialization.  `mu_3` must be nonzero in characteristic zero and must not be divisible
by either prime above 11.

## 5. The commuting squares

M3b must construct both routes in each square and compare canonical coefficient arrays, not only
ranks or hashes.

### Square P — products

```text
golden matching over E  --six secants-->  P_M over E
       | reduction                            | reduction
       v                                      v
matching on P^1(F_11)  --C406 scaling-->  P_M over F_11.
```

At `pi`, `F_+` must reduce to the C406 sheet containing the base singleton and `F_-` to its other
sheet.  At `pibar` the roles must reverse.  The reduced polar matchings must be exactly C458's
base/J-mate records.  The four `zeta` roots `3,4,5,9` must give pairwise-identical descended data
over their common `O` prime.  After the single common Klein-section normalization, the products
must equal C406's products exactly; no per-matching scalar comparison is accepted.

### Square Q — conic division

```text
S_6(E)  --Phi--> S_4(E)
  | reduction             | reduction
  v                       v
S_6(F_11)--Phi--> S_4(F_11).
```

This square should commute formally because division by the monic `z^2` term is integral; the
certificate must still compare every matching.  After the reduced split-conic projectivity and a
single common affine translation, the resulting quotient-point lists must equal C406's frozen
H3 quotient lists.  The common translation is allowed because C406 chose a base matching whereas
`Phi` above chose an integral normal-form splitting; matching-dependent translations are forbidden.

### Square M — moments

```text
(T_k^0-sigma T_k^0) over O  --reduction-->  reduced mu_k
             |                                  |
             | direct construction              | equality
             v                                  v
      signed moments of the two frozen C406 sheets.
```

For both primes, acceptance requires `mu_1=0`, `mu_2=0`, and `mu_3!=0` after reduction, with the
complete reduced arrays equal to a fresh C406 reconstruction.  The two reduced cubic arrays must
be negatives of one another after the frozen sheet identification.

## 6. The `+/-6` shadow and selector-safe wording

Earlier notes use `+/-6` for two related normalizations; M3b must report both and not conflate them.

1. Under C411's rank-two depth pushforward, evaluate the first coordinate of the third signed
   symmetric moment.  With `F_+` oriented as the sheet containing C458's `pi` reduction, this is
   `+6 mod 11`; at `pibar` it is `-6 mod 11`.
2. The singleton depth profiles themselves begin with `-6` for C458's base matching and `+6` for
   its J-mate, as frozen by C442/C458.

The paper-safe object is the line `O mu_3` together with its golden sign character.  A generator is
oriented only after choosing the prime/golden matching.  In accordance with C448, M3b must not call
`mu_3` a canonical point selector from the undecorated child: the unordered two-fibre and tensor
line are canonical, while choosing a member or a signed generator costs the same one orientation
bit.

## 7. Literal acceptance bundle and falsifiers

M3b's evidence bundle is

```text
notes/2026-07-21-c443-commuting-with-reduction.md
notes/2026-07-21-c443-commuting-with-reduction.py
notes/2026-07-21-c443-commuting-with-reduction-replay.py
notes/2026-07-21-c443-commuting-with-reduction.json
notes/2026-07-21-c443-commuting-with-reduction.sha256
```

The primary checker must hash-pin C406, C440, C442, and C458; give every basis, lattice rank,
matching, denominator, reduction map, coefficientwise square verdict, moment support/hash, and the
two `+/-6` normalizations in canonical JSON; and provide a `--check` mode that leaves the worktree
unchanged.  The replay must independently reconstruct the two finite reductions and the three
moment comparisons without importing the primary checker.

The task stops with a dated blocker note if any one of the following occurs:

- a denominator above 11 is required;
- the golden construction fails to produce the specified `1+10` sheet before reduction;
- either product or quotient square fails coefficientwise;
- the descended reductions depend on the choice `zeta=3` versus `4`, or `5` versus `9`;
- either reduced lower moment is nonzero;
- the reduced cubic is zero, is not the frozen C406 cubic, or fails the conjugate-sign test;
- obtaining the result requires a convention change, matching-dependent affine correction, or
  post-hoc CRT interpolation.

If a falsifier triggers, M1--M2 and C458 remain intact.  The integral theorem retreats to the
sheet/matching level, and the tensor clause is cut exactly as prescribed by the Weil-roof program.
