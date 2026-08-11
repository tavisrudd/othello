# C904 Fano sum/difference quotients and two-primary transfer

Date: 2026-08-10
Status: exact quotient/transfer theorem; no manuscript or Lean edits
Scope: Shen's cycle `eta`, `F x F`, `Sym^2 F`, and the `15/30/60`
multisection candidates

## Executive verdict

The sum construction has one genuine odd quotient, but every construction
that lifts to ordered pairs and returns by transfer is even.

Let `s(u,v)=(v,u)`, let `q:F x F->Sym^2 F`, and write

`phi_+(u,v)=phi(u)+phi(v)`, `phi_-(u,v)=phi(u)-phi(v)`.

Then

- `phi_+ s=phi_+`; it factors through `Sym^2 F`, and the induced map
  `Sym^2 F -> D_+` is birational;
- `phi_- s=[-1]phi_-`; it does not map to `Theta` from the symmetric square,
  but it maps to the Kummer quotient `Theta/{+/-1}`;
- both ordered pullback theta volumes are 30;
- the sum factorization is `2 * 15`, while the difference factorization is
  `6 * 5`.

Shen's cycle `eta` is exactly the intrinsic quotient escape.  His centered
symmetric cycle `tilde theta` satisfies

`phi_{+*}(tilde theta)=2 eta`, with `-[eta]=Theta^4/4!`,

whereas

`phi_{-*}(tilde theta)` has class twice the minimal class and admits no
second division from the swap quotient.  The odd cycle is obtained by
descending to `Sym^2 F` and taking the half **there**; it is not produced by
the ordered-pair norm `q_*q^*`.

For the `A5` candidates, stabilizers `V4`, `C2`, and `1` give orbit degrees

`15,30,60`.

Restriction--corestriction on any two-primary class multiplies by these
degrees.  Modulo two the multipliers are `(1,0,0)`.  Consequently:

> A nonzero ordered-pair/Brauer class cannot split after the degree-15
> `V4`-stabilized base change.  Degree 30 or 60 is parity-inconclusive.

Thus the only odd multisection candidate is an obstruction-preserving one,
not a splitting mechanism.

## 1. Exact cohomological normalization

In a Darboux basis put

`Theta_i=sum_j a_ij b_ij`,

and normalize the Poincare class by

`P=m^*Theta-Theta_1-Theta_2`.

Then

`phi_+^*Theta=Theta_1+Theta_2+P`,

`phi_-^*Theta=Theta_1+Theta_2-P`.

Using `[F]=Theta^3/3!`, exact exterior algebra gives

`int_(F x F) (phi_+^*Theta)^4/4! = 30`,

`int_(F x F) (phi_-^*Theta)^4/4! = 30`.

Shen proves `[D_+]=3Theta`, `deg(phi_+)=2`; hence

`int_(D_+)Theta^4/4!=15`, and `30=2*15`.

Clemens--Griffiths prove `im(phi_-)=Theta`, `deg(phi_-)=6`; hence

`int_Theta Theta^4/4!=5`, and `30=6*5`.

These identities also give

`phi_{+*}[F x F]=phi_{-*}[F x F]=6Theta`.

Let `kappa:Theta->Theta/{+/-1}`.  Since `kappa phi_-` is swap invariant, it
factors through a map

`bar phi_-:Sym^2 F->Theta/{+/-1}`.

Degree bookkeeping gives

`2 deg(bar phi_-)=2*6`, so `deg(bar phi_-)=6`.

Unlike the sum map, the difference/Kummer factorization does not halve the
generic degree.

## 2. Shen's centered symmetric cycle

Shen's Theorem 5.1 supplies a swap-symmetric one-cycle
`theta in CH_1(F x F)`.  If `theta_1=pr_{1*}theta`, define the centered cycle

`tilde theta=theta-theta_1 x o-o x theta_1`.

For `alpha,beta in H^1(J,Z)`, with hats denoting their pullbacks to `F`,

`phi_+^*alpha=alpha_hat tensor 1+1 tensor alpha_hat`,

`phi_-^*alpha=alpha_hat tensor 1-1 tensor alpha_hat`.

Expanding the two products and using swap symmetry gives the opposite
cross-term pairings

`<phi_{+*}[tilde theta],alpha beta>=+2<alpha,beta>_X`,

`<phi_{-*}[tilde theta],alpha beta>=-2<alpha,beta>_X`.

The two marginal terms were removed precisely so no extra
`phi_*[theta_1]` pairing remains.  This is the cohomological source of the
factor two.

For the sum map, a symmetric one-cycle can be moved away from the
codimension-two fixed diagonal and descended through the free swap quotient.
Since `phi_+` has the swap as its generic degree-two fibre, Shen obtains the
integral Chow equality

`phi_{+*}(tilde theta)=2 eta`.

The cycle `eta` is supported on `D_+` and its negative is the minimal class.
For the difference map the swap changes the target by `[-1]`; the analogous
descent is to the Kummer quotient, and lifting back restores the factor two.
It yields a symmetric theta-supported representative of `2c`, not `c`.

## 3. The `C2` and `V4` quotient lattice

Inside `A5`, take a double transposition subgroup `C2` and the Klein four
subgroup containing its three double transpositions.  Their orders and
indices are

| stabilizer `H` | `|H|` | `[A5:H]` |
|---|---:|---:|
| `V4` | 4 | 15 |
| `C2` | 2 | 30 |
| `1` | 1 | 60 |

The internal tower `1<C2<V4` consists of two successive degree-two
quotients.  Hence every internal norm/transfer is zero modulo two.  The
external quotient `A5/V4`, however, has odd degree 15.

Let `L/K` be any of the corresponding generically finite field extensions
and let `alpha` be a two-torsion etale/Brauer class.  Then

`cor_(L/K)(res_(L/K) alpha)=[L:K] alpha`.

For degree 15 this is `alpha` modulo two, so restriction is injective.  If
the ordered-pair cover is nontrivial before base change, it stays nontrivial
on every degree-15 `V4` multisection.  For degrees 30 and 60 the composite
vanishes modulo two and gives no answer either way.

More generally the two-adic valuations of the three degrees are `(0,1,2)`.
If a two-primary class splits after degree `d`, transfer forces
`2^v alpha=0` for `v=v_2(d)`.  Thus degree 15 cannot kill any nonzero
two-primary class, degree 30 can kill only classes of exponent at most two,
and degree 60 only classes of exponent at most four.  For the present
order-two ordered-pair class, the last two cases remain inconclusive.

This statement applies when the candidate is generically finite over the
actual field carrying `alpha`.  The degree-21 intersection curve found in
the sparse-component audit maps to the one-dimensional pencil base, not
generically finitely to `D_+`; its odd degree therefore does not trigger
this restriction--corestriction injection for the ordered-pair class on
`D_+`.

## 4. Uniform parity theorem for `Sym^2 F`

For the quotient `q:F x F->Sym^2 F`,

`q_*q^*=2`, and `q^*q_*=1+s`.

Therefore any integral correspondence that

1. lifts from `Sym^2 F` to ordered pairs,
2. performs its construction upstairs, and
3. returns by the norm/transfer,

has even multiplier and vanishes on every mod-two invariant.  The same is
true for any construction containing one of the internal degree-two steps
`1<C2<V4`.

This is the precise uniform parity statement.  It does **not** say that all
cycles intrinsic to `Sym^2 F` are even: `eta` is the counterexample.  Rather:

> Oddness through `Sym^2 F` requires an integral quotient class not obtained
> by an ordered lift-and-transfer round trip.

Shen's quotient half is such a class.  Any proposed new construction should
state where this integral descent enters; if its proof only writes
`q_*q^*`, a factor two is unavoidable.

## 5. Replay

```sh
nix shell nixpkgs#python3 -c python3 \
  notes/2026-08-10-c904-fano-quotient-transfer-replay.py
```

The replay independently checks the two 30-volume identities in exact
20-generator exterior algebra, constructs `A5`, `C2`, and `V4` explicitly,
and verifies the orbit and mod-two transfer degrees.

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-10-c904-fano-quotient-transfer-replay.py` | 3,851 | `28d41525d7fe9c0de2cb604ad767c11e09a459a2fb9e91689b46ec551576dd8d` |
| `notes/2026-08-10-c904-fano-quotient-transfer-replay.out` | 393 | `96291f19c5e668e2a78e2487a7915bb8beeaec53c4bdbdfdc30aa1a10ccf7c36` |

## 6. Sources and boundaries

- C. H. Clemens and P. A. Griffiths, *The intermediate Jacobian of the cubic
  threefold*, Theorem 13.4 and proof: difference image `Theta`, degree six.
- M. Shen, *Rationality, universal generation and the integral Hodge
  conjecture*, Theorem 5.1, Lemma 5.6, and Proposition 5.7: the symmetric
  cycle, sum divisor/degree, centered cycle, and `eta`.

The exterior and finite-group calculations are exact.  The transfer theorem
is formal.  None computes the restriction of the ordered-pair two-torsion
line to a lower-dimensional sparse component; that remains the Picard/
monodromy gate isolated in the preceding audit.

## Mystery ledger

- **Settled:** sum and difference ordered volumes are both 30, decomposing
  as `2*15` and `6*5` respectively.
- **Settled:** the `15/30/60` candidates are exactly the `V4/C2/1`
  stabilizer indices.
- **Settled:** degree 15 preserves every nonzero two-primary obstruction;
  degrees 30 and 60 are inconclusive.
- **Settled:** ordered lift-and-transfer constructions through `Sym^2 F`
  are uniformly even; Shen's `eta` escapes by intrinsic quotient descent.
- **Open:** an explicit Picard/monodromy calculation of the ordered-pair
  class on the unique odd sparse component.
