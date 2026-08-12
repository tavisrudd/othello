# C908: Fourier saturation of the p15 numerical lattice on B = J x J

Date: 2026-08-11

Status: **negative closure, unconditional and stronger than the frozen target**;
plus a normalization correction to the source note and a structural reframing of
where the surviving crown can live. C908 mathematics only. No manuscript, PDF,
mirror, Lean, or reviewer-dossier change; no pre-existing file edited.

## 1. Frozen target

From `notes/2026-08-11-c904-integral-fourier-numerical-p15-boundary.md` §6,
equation (0.3): with `B = J x J` and
`Q^3_alg(B) = N^3(B)/D^3_PD(B)`, decide

\[ \bar\rho_{15}\;:\;\mathcal Q^3_{\rm alg}(B)\longrightarrow
   \operatorname{End}(J)/2\operatorname{End}(J), \]

either by constructing `Gamma in CH^3(B)` with `rho_15([Gamma]) ≡ Id (mod 2)`
(positive closure) or by proving `bar rho_15 = 0` (negative closure). Pass-1
plan: test whether `D^3_PD(B)` is stable under the integral Fourier transform,
since the source note records that "failure of such stability could itself
produce a class in (0.1)".

Deciding (0.3) is not a finite computation in the naive sense: `N^3(B)` cannot
be enumerated. The computation below sidesteps enumeration entirely by
evaluating `rho_15` on the **whole ambient integral Kunneth lattice**, which
contains the `rho_15`-relevant part of every codimension-three class on `B`
whatsoever.

## 2. Verdict

1. **Sanity gate passes.** The committed C904 certificate
   `rho_15(D^3_PD(B)) = 2 End(J)` (equation (0.2)) is reproduced exactly: 3000
   divisor-cube generators, image rank 25, `End(J)`-quotient elementary divisors
   twenty-five copies of 2, normalized identity of order 2, canonical
   `P·(Theta^2/2)` scalar of absolute value 12, and the same after adjoining the
   375 divided squares.
2. **`bar rho_15 = 0`, unconditionally.** `rho_15` of the *entire* integral
   `(5,1)` Kunneth lattice is exactly `2 Z^100`; intersected with the saturated
   rank-25 endomorphism lattice this is exactly `2 End(J)`. Hence
   `rho_15(N^3(B)) ⊆ 2 End(J) = rho_15(D^3_PD(B))` for trivial reasons, no odd
   element exists, the identity coset is not attained, and **no enlargement of
   `D^3_PD(B)` inside `N^3(B)` can change `bar rho_15`** — Fourier images or
   otherwise.
3. **Fourier saturation is therefore moot, and stabilizes in one step.** `F` is
   unimodular and carries the full integral `(5,9)` lattice isomorphically onto
   the full integral `(5,1)` lattice, so `rho_15(F(D^7_PD(B))) ⊆ 2 End(J)`,
   `rho_15(Dtilde^3) = 2 End(J)`, and the two-degree iteration stabilizes
   immediately.
4. **Normalization correction to the source note.** Under the committed
   `rho_15` normalization, positive closure of (0.3) was never attainable: the
   readout carries an integral factor `Theta^2 = 2 Theta^{[2]}`, so *every*
   integral class has even `rho_15`. As literally posed, (0.3) is vacuous rather
   than open. This is a correction to a foreign note's framing; that note is not
   edited here.
5. **The surviving crown moves.** The evenness is not an artefact: because
   `b_* b^* = Theta·(-)` on the theta resolution, the `(1,5)` mod-two Lefschetz
   residue of **any** class pulled back along `b x b` from `J x J` vanishes
   identically (Theorem B below). The odd `(1,5)` correspondence, if it exists,
   must live on `M x M` and must **not** be a pullback from `J x J` — it has to
   use the exceptional geometry of the theta resolution.

## 3. Conventions (all load-bearing)

- **Lattice model.** `Lambda = H^1(J,Z)` of rank `DIM = 10`; `J` the generic
  non-CM exotic `A5` intermediate Jacobian, `GENUS = dim J = 5`. `H^*(J,Z)` is
  modelled as the exterior algebra on `Lambda`, forms represented as dictionaries
  keyed by strictly increasing index tuples; `int_J` is the coefficient of the
  top tuple `(0,...,9)`. The exterior product is the `wedge` routine of
  `notes/2026-08-10-c904-minimal-class-divisor-lattice.sage`, reused verbatim.
- **Principal lattice.** `principal_lattice("omega", 1)` supplies the exotic
  principal basis and Gram matrix `S`; `Theta = two_form(S)`. The Gram matrix is
  recorded in the certificate under
  `inputs.symplectic_gram_of_exotic_principal_lattice`. Principality is checked
  two ways: `S` is unimodular (`det S = 1`) and `Theta^{[5]}` is the positive top
  class.
- **`NS(B)` and its degree-`d` divided-power lattice.** `NS(B)` has rank
  `55 = 15 + 15 + 25`: the 15 integral Neron--Severi two-forms on each factor,
  and the 25 cross divisors `P_T` with cross block `Omega T^t` for `T` in the
  saturated rank-25 integral coefficient-endomorphism order. This is exactly the
  generator convention of
  `notes/2026-08-11-c904-full-ns-cube-p15-lattice.sage`, **including** its BdGF
  divided squares. `D^d_PD(B)` is the lattice spanned by all degree-`d`
  divided-power monomials `prod D_i^{[m_i]}` in those 55 classes.
- **`rho_15`.** The committed machinery computes, for the degree-three monomial
  `D_i D_j P_T`,
  `action[r,i] = sum_l C[l,r] * int_J( Theta^2 . S . u_i . u_l )` with
  `S = D_i ^ D_j` and `C = Omega T^t`. The `(5,1)` Kunneth component of that
  monomial is `w = sum_{l,r} C[l,r] (S ^ u_l) (x) v_r`, and writing
  `w = sum_r w_(r) (x) v_r`,
  \[ \rho_{15}(w)[r,i] \;=\; -\int_J \Theta^2\wedge w_{(r)}\wedge u_i . \]
  The right-hand side depends on `w` alone, so it **defines** `rho_15` on the
  whole integral `(5,1)` lattice. The generator verifies that this extension
  reproduces the committed per-monomial `action` vector on **all 3000**
  divisor-cube generators; a single disagreement aborts the run.
  Output lives in `M_10(Z) = Z^100`; the normalized identity is `I_10`;
  `End(J)` is the saturated rank-25 sublattice of `Z^100`.
- **Fourier transform.** `F(x) = p_{2*}(exp(c_1(P)) . p_1^* x)`, integral because
  `c_1(P)` has integral divided powers. On `J` it sends `H^k -> H^{10-k}`; on
  `B = J x J` it is the exterior product of the two factor transforms, so
  `H^{(p,q)} -> H^{(10-p,10-q)}` and the source of the target `(5,1)` is
  `(5,9)`. On a monomial it collapses to a single term,
  \[ F(u_I) \;=\; \varepsilon(I)\,\textstyle\bigwedge^{10-|I|}(\varphi_\Theta^*)(u_{I^c}),
     \qquad \varepsilon(I)=[\,u_I\wedge u_{I^c}\,]_{\rm top}, \]
  where `varphi_Theta^*: H^1(J-hat) -> H^1(J)` is the pullback along the
  polarization isogeny. **This identification is the Gram matrix `S` itself, not
  its inverse**: the Poincare class on `J x J-hat` is the canonical element
  `sum_i u_i (x) u_i^*`, and `(1 x varphi_Theta)^* p` is the Mumford class
  `sum_{i,j} S_{ij} u_i (x) u_j`, so `varphi_Theta^*(u_j^*) = sum_m S_{jm} u_m`.
  In a *standard* symplectic basis `S^{-1} = -S`, so the two choices differ only
  by signs and the distinction is invisible; the exotic principal lattice is not
  in standard form, and taking the inverse makes
  `F(Theta^{[k]}) = ± Theta^{[5-k]}` fail. That invariant check is what pinned
  the convention.
- **Signs.** A global Koszul sign in `F_B = F_J (x) F_J` is constant on a fixed
  Kunneth bidegree, and the overall sign of `rho_15` is a global constant.
  Neither affects any quantity reported here (image lattice, elementary
  divisors, parity, identity coset).
- **Determinism.** No randomness. Every enumeration is canonical: lexicographic
  index tuples via `itertools.combinations`, multisets via
  `combinations_with_replacement`, LLL-reduced lattice bases.

## 4. Results

### 4.1 Sanity gate (item 1 of the specification)

| quantity                                                 | value        | expected from (0.2) |
| -------------------------------------------------------- | ------------ | ------------------- |
| `NS(J)` rank / `End(J)` rank / `NS(B)` rank              | 15 / 25 / 55 | 15 / 25 / 55        |
| divisor-cube generators                                  | 3000         | 3000                |
| image rank                                               | 25           | 25                  |
| canonical `P·(Theta^2/2)` scalar, absolute value         | 12           | 12                  |
| `End(J)` / image elementary divisors                     | `2^25`       | `2^25`              |
| normalized identity order                                | 2            | 2                   |
| divided-square generators                                | 375          | 375                 |
| `End(J)` / divided image elementary divisors             | `2^25`       | `2^25`              |
| normalized identity order (divided)                      | 2            | 2                   |
| abstract `(5,1)` extension agrees on all 3000 generators | yes          | new check           |

The two input scripts hash to
`d77752dcf242cdd3e8ecf15d34785eba583aa4c4c7770b79decd2f43e260f734` and
`3417088e84d81961796f2bb12d16ad9f1b0a33e3a7f2fce462142c2799eec15a`, matching the
values recorded in `notes/2026-08-11-c904-bdgf-theta-and-full-ns-p15-audit.md`.

### 4.2 Lemma A (readout evenness)

`Theta ^ Theta` has **all** coefficients even on the exotic principal lattice, so
`Theta^2 = 2 Theta^{[2]}` with `Theta^{[2]}` integral. Since
`rho_15(w)[r,i] = -int_J Theta^2 ^ w_(r) ^ u_i`, every integral `(5,1)` class has
`rho_15(w) in 2 M_10(Z)`. This is a one-line consequence, independent of any
enumeration; it is the conceptual cross-check on the whole computation.

### 4.3 Theorem A (ambient exactness) — the main computation

Evaluating `rho_15` on the standard `Z`-basis `u_I (x) v_r` of the **full**
integral `(5,1)` Kunneth lattice (252 five-subsets times 10 indices = 2520
generators):

- image rank **100** in `Z^100`;
- all coefficients even;
- the halved readout matrix `A[I,i]/2` has row space exactly `Z^10`
  (echelon pivots `(1,...,1)`, rank 10), so the image is **exactly `2 Z^100`**;
- intersection with the saturated rank-25 `End(J)` is exactly `2 End(J)`
  (inclusion elementary divisors all 2);
- the divisor-cube image of (0.2) **equals** that intersection;
- the normalized identity has order 2 in the image;
- reduction of the image modulo `2 End(J)` is the zero subgroup.

Hence for any subgroup `N` of `H^6(B,Z)` whose `rho_15`-images lie in `End(J)`,
`rho_15(N) ⊆ 2 Z^100 ∩ End(J) = 2 End(J)`. In particular
`rho_15(N^3(B)) ⊆ 2 End(J)`, so `bar rho_15 = 0`.

### 4.4 Fourier transform (items 3, 4, 5)

- `F` on `Lambda^5` is a `252 x 252` integer matrix with `|det| = 1` and all
  elementary divisors 1; on `Lambda^9 -> Lambda^1` it is `10 x 10` with
  `|det| = 1`. So `F` is **unimodular**, as it must be, being a signed
  permutation composed with an exterior power of a unimodular matrix.
- `F(Theta^{[k]}) = ± Theta^{[5-k]}` for `k = 0,...,5`. This is the convention
  check described in §3.
- `rho_15(F(-))` on the standard `Z`-basis `u_I (x) v_K` of the full integral
  `(5,9)` lattice (252 x 10 = 2520 generators) has image **equal** to the
  ambient `(5,1)` image of §4.3, with the same intersection `2 End(J)` and the
  same identity order 2. This is forced: `F` is a lattice isomorphism
  `(5,9) -> (5,1)`.
- Consequently `Dtilde^3 = D^3_PD(B) + F(D^7_PD(B))` has
  `rho_15(Dtilde^3) = 2 End(J)`; the same argument in the other degree gives
  `rho_15` of the `F`-image of `D^3_PD(B)` inside `N^7(B)` no extra room, and the
  pair of lattices stabilizes after **one** iteration.

**Not computed, deliberately:** the index of `Dtilde^3` in `N^3(B)` as a
sublattice of the rank-38760 group `H^6(B,Z)`. That is not needed for (0.3) —
`rho_15` factors through the `(5,1)` component, whose ambient image is already
exhausted — and no saturation data for `N^3(B)` in codimension three on the
tenfold `B` exists in the corpus. Recorded as a scope boundary, not a result.

### 4.5 Cross-check: the explicit degree-seven family

The bidegrees are pinned exactly. A degree-seven divided-power monomial with `a`
factors from `NS(J)_1`, `b` cross factors and `c` factors from `NS(J)_2` has
bidegree `(2a+b, b+2c)`; requiring `(5,9)` and `a+b+c = 7` forces
\[ (a,b,c)\in\{(2,1,4),\,(1,3,3),\,(0,5,2)\}, \]
in particular `b` odd. The corresponding raw monomial counts are

| type                |          count |
| ------------------- | -------------: |
| `(a,b,c) = (2,1,4)` |      9,180,000 |
| `(a,b,c) = (1,3,3)` |     29,835,000 |
| `(a,b,c) = (0,5,2)` |     14,250,600 |
| total               | **53,265,600** |

Enumerating these is infeasible and, by Theorem A, unnecessary. The generator
nevertheless computes the `(2,1,4)` family in full through `F`, using
per-slot LLL bases (`L^2_PD` of rank 50, the 25 crosses, `L^4_PD` of rank 15,
giving `18750` generators) and the factorization
`M = -B_z^T C^T A_x` derived in the script: image rank 25, all coefficients
even, contained in the ambient image, intersection with `End(J)` exactly
`2 End(J)`, identity order 2. Consistent with Theorem A.

### 4.6 Cross-check: the Lefschetz cokernel

Independently recomputed here: `L = Theta ^ (-) : Lambda^5 Lambda -> Lambda^7 Lambda`
(ranks 252 -> 120) has nonzero elementary divisors `1^110 2^10`, i.e. cokernel
`(Z/2)^10`. This reproduces equation (2.2) of
`notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md` and equation
(3.3) of `notes/2026-08-11-c904-c3-kunneth-descent-boundary.md` from an
independent code path, and it localizes *why* the ambient image is even — see
§5.

## 5. Theorem B (pullback vanishing) and the structural reframing

The evenness of §4.3 is not a normalization artefact. The `(1,5)` degree
functional of the Kunneth audit is, in that note's equations (2.1) and (2.3),
`int_J f_*alpha . f_*beta` for a transfer tensor with `alpha in H^1(M)` and
`beta in H^5(M)`, and the live residue is the class of `f_*beta` in
`coker(L) = (Z/2)^10`.

Let `b = i o sigma` with `sigma: M -> Theta` the resolution and
`i: Theta -> J` the inclusion. Then

\[ b_* b^*(x) \;=\; i_*\sigma_*\sigma^* i^* x \;=\; i_* i^* x \;=\; \Theta\wedge x, \]

because `sigma` is birational. Now take any `Gamma in H^6(J x J, Z)`. Kunneth
components pull back componentwise, `(b x b)^* = b^* (x) b^*`, so the `(1,5)`
component of `(b x b)^* Gamma` has legs `b^* alpha'` and `b^* beta'` with
`alpha' in H^1(J)`, `beta' in H^5(J)`. Both Gysin images therefore acquire a
factor `Theta`, and the degree functional is

\[ \int_J (\Theta\alpha')(\Theta\beta') \;=\; \int_J \Theta^2\alpha'\beta'
   \;\equiv\;0 \pmod 2 \]

by Lemma A. Hence:

> **Theorem B.** For every class `Gamma in H^6(J x J, Z)`, the `(1,5)` mod-two
> Lefschetz residue of `(b x b)^* Gamma` vanishes. No codimension-three class on
> `J x J` — divisor-generated or not, Fourier-transformed or not, algebraic or
> merely integral — can realize the odd `(1,5)` coefficient identity on
> `M x M`.

This retro-explains every even outcome recorded for this channel: the 3000
divisor cubes, the 375 BdGF divided squares, and the BdGF class `P^3/3!` are all
pullbacks from `J x J`. (The universal-Chern/`pi_3^X` route of
`notes/2026-08-11-c904-universal-pi3-gamma-parity.md` is not a pullback from
`J x J`; it dies by the independent gamma-filtration mechanism there. So Theorem
B and that note cover complementary families.)

It also sharpens where the crown can be. The rational realization
`Pi_15 = {}^t Gamma_b o Lambda_J^2 o Gamma_b` has the graph-composition form of a
refined pullback of `Lambda_J^2` from `J x J`; if that identification holds, then
Theorem B says no integral representative of it can have odd residue, and the
required class must be genuinely non-pullback. **The precise identification of
`{}^t Gamma_b o Lambda_J^2 o Gamma_b` with a refined pullback `(b x b)^* Lambda_J^2`
is not verified here** and is the first follow-on lemma worth doing.

Consequently the reposed gate is:

> Construct an integral algebraic codimension-three class on `M x M` which is
> **not** a pullback along `b x b` from `J x J` and whose `(1,5)` mod-two
> Lefschetz residue is the coefficient identity; or prove that the residue
> vanishes on the whole of `CH^3(M x M)`.

The exceptional divisor `E|_M = X` (the cubic threefold itself, with
`N_{X/M} = O_X(-H)`) is the only geometry available to a non-pullback class, and
the theta resolution is known to contribute no two-primary local topological
defect (its link has `H^4 = Z^10 (+) Z/3`). Both facts are in
`notes/2026-08-11-c904-theta-resolution-topology-integral-projector-audit.md`.

## 6. What this does and does not certify

**Certified.** Everything in §4, plus Lemma A and Theorem B (the latter two are
human proofs whose only computational input is Lemma A). The negative statement
of §4.3 has the **maximal** searched domain — every integral class in the `(5,1)`
and `(5,9)` Kunneth components of `H^6(B,Z)` and `H^14(B,Z)` — so it is not a
finite exhaustion promoted to a nonexistence claim; there is no enumeration
bound to state. Stop condition: the image of the full ambient Kunneth lattice
was computed exactly and equals `2 Z^100`.

**Not certified.**

- Algebraicity or Hodge-ness of any individual class. `rho_15` is applied to the
  full integral lattice, which is larger than the algebraic one; that only makes
  the negative conclusion stronger, and gives nothing positive.
- Any statement about classes on `M x M` that are **not** pullbacks along
  `b x b`. Theorem B is silent there, and that is exactly where the surviving
  crown lives.
- The `(2,4)` channel (44 dyadic directions, 396-dimensional `S_3`-invariant
  space). No analogue of (0.3) exists for it yet.
- The index of `Dtilde^3` in `N^3(B)` (see §4.4).
- Anything about `CH^3` beyond numerical/cohomological classes: homologically
  trivial and positive-Beauville-grade cycles are invisible to `rho_15`.

## 7. Bundle, replay, checksums

Working directory for every command: the repository root
`/home/tavis/src/othello`.

Primary generator:

```sh
nix shell nixpkgs#sage -c sage notes/2026-08-11-c908-p15-fourier-saturation.sage \
  --json notes/2026-08-11-c908-p15-fourier-saturation.json \
  --out notes/2026-08-11-c908-p15-fourier-saturation.out
```

Independent replay (imports nothing from Sage; the `sage -python` wrapper is used
only because it is guaranteed present on this host):

```sh
nix shell nixpkgs#sage -c sage -python \
  notes/2026-08-11-c908-p15-fourier-saturation-replay.py \
  > notes/2026-08-11-c908-p15-fourier-saturation-replay.out
```

The Sage run leaves a preparsed `notes/2026-08-11-c908-p15-fourier-saturation.sage.py`
translation, which must be deleted; the committed bundle is debris-free.

| artifact                                            |  bytes | SHA-256                                                            |
| --------------------------------------------------- | -----: | ------------------------------------------------------------------ |
| `2026-08-11-c908-p15-fourier-saturation.sage`       | 32,871 | `d1f7082a8bd8a8cb3922c862820a0185e4cefb59b832ca82da0a14b4ceb1ed28` |
| `2026-08-11-c908-p15-fourier-saturation.json`       | 14,244 | `748f91812bc7f35f4760837ecca9a09ce8119e14054c92d615d2d34e027909a2` |
| `2026-08-11-c908-p15-fourier-saturation.out`        |    798 | `27a9a6fde3ed8272c9873fc7a36588f0bc454bc5d1c250e16bccb474eba1cb4d` |
| `2026-08-11-c908-p15-fourier-saturation-replay.py`  |  8,747 | `123d3f35c7358fb8661ab4775648b3bc56d095d84fb468c235ec767360fd3ff5` |
| `2026-08-11-c908-p15-fourier-saturation-replay.out` |    572 | `b30bebb9b839c8ab79dff87665c79fab0d20e67fc0c96660b9c8596871221fa2` |

Load-bearing inputs (hashes checked by the generator and written into the
certificate):

| input                                                | SHA-256                                                            |
| ---------------------------------------------------- | ------------------------------------------------------------------ |
| `2026-08-10-c904-minimal-class-divisor-lattice.sage` | `d77752dcf242cdd3e8ecf15d34785eba583aa4c4c7770b79decd2f43e260f734` |
| `2026-08-11-c904-full-ns-cube-p15-lattice.sage`      | `3417088e84d81961796f2bb12d16ad9f1b0a33e3a7f2fce462142c2799eec15a` |

**Cross-checks available.** (i) The independent replay above, a from-scratch
pure-integer implementation (own exterior algebra, own Hermite reduction, own
Bareiss determinant) that hard-codes only the printed Gram matrix and confirms
Lemma A, principality, everywhere-evenness of the readout pairing, that its
halved matrix spans `Z^10`, `det(Gram) = 1`, and
`F(Theta^{[k]}) = ± Theta^{[5-k]}`. (ii) The `L : Lambda^5 -> Lambda^7`
elementary divisors `1^110 2^10` match the committed C904 value from a separate
code path. (iii) The abstract `(5,1)` extension of `rho_15` is checked against
the committed per-monomial `action` on all 3000 generators. (iv) Lemma A is a
human proof, so Theorem A's evenness half needs no computational trust at all;
only its *exactness* (image `= 2 Z^100`, not smaller) is computational.

## 8. Mystery ledger (EJ + TT closeout)

- **Settled:** `bar rho_15 = 0` for the committed normalization, unconditionally,
  with the maximal possible searched domain. The Fourier-stability question the
  source note raised cannot produce an odd class in this channel.
- **Settled:** the even no-go denominator enlarges from `D^3_PD(B)` all the way
  to the entire ambient integral `(5,1)` Kunneth lattice. This is strictly
  stronger than the requested "Fourier-saturated lattice" strengthening.
- **Settled:** the Fourier convention. The dual identification is the Gram
  matrix, not its inverse; the distinction is invisible in a standard symplectic
  basis and real in the exotic one.
- **Corrected:** (0.3) as literally posed was vacuous, not open — the readout
  carries `Theta^2 = 2 Theta^{[2]}`. Raised for the owner of
  `notes/2026-08-11-c904-integral-fourier-numerical-p15-boundary.md`; not edited
  here. That note is also currently **untracked** in git, so the definition of
  the frozen target is absent from every reproducibility claim until committed.
- **Settled (new theorem):** no class pulled back along `b x b` from `J x J` can
  have odd `(1,5)` residue. This subsumes the divisor-cube, BdGF divided-square
  and `P^3/3!` no-goes under one mechanism.
- **Open, first follow-on lemma:** is
  `{}^t Gamma_b o Lambda_J^2 o Gamma_b` a refined pullback `(b x b)^* Lambda_J^2`?
  If yes, Theorem B proves its integral lift cannot have odd residue and the
  crown is forced onto non-pullback classes.
- **Open:** construct an integral algebraic codimension-three class on `M x M`
  supported on or twisted by the exceptional divisor `E|_M = X`, i.e. genuinely
  non-pullback, and compute its `(1,5)` residue; or prove residue vanishing on
  all of `CH^3(M x M)`.
- **Open:** the `(2,4)` channel has no finite reduction analogous to (0.3).
- **No manufactured mystery:** the unexpected sharpness noted in the C904 bdgf
  audit ("the equality with the *entire* doubled endomorphism order is
  unexpectedly sharp") is now explained: the divisor cubes already attain the
  ambient maximum `2 Z^100 ∩ End(J)`, so nothing finer than `2 End(J)` was ever
  available to them.
