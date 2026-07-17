# C218 quartic-nucleus harmonic repair family

**Lane:** `repairports`
**Status:** COMPLETE. The nucleus classification is explicit, and degree four in characteristic
three yields a second infinite repair family with a complete radius-four circuit description.

## Result

Let

```text
Gamma_d = {(1:t:...:t^d) : t in F_q} union {e_d} subset PG(d,q)
```

be the degree-`d` normal rational curve. Assume `q >= d` and write
`d=sum_i d_i p^i` in base `p=char(F_q)`. The common intersection of all osculating hyperplanes is

```text
N_hyp(Gamma_d) = span {e_j : binom(d,j) = 0 mod p},
dim N_hyp(Gamma_d) = d - product_i (d_i+1).
```

Here dimension `-1` means empty. Equivalently, the common hyperplane nucleus is nonempty exactly
when the base-`p` expansion of `d+1` has at least two nonzero digits. The span formula is the
`k=d-1` specialization of Gmainer--Havlicek's nucleus theorem; the dimension formula follows from
Lucas's theorem. The field-size qualification matters: over smaller fields, osculating structure
can depend on the chosen parametrization.

This classifies all degree/characteristic pairs in the stable field-size range, but most members do
not automatically give tractable repair ports. The first useful case beyond the paper's cubic is

```text
d=4, p=3, N_hyp(Gamma_4)={N}, N=e_2,
```

because row four of Pascal's triangle has exactly one zero modulo three.

## Quartic-nucleus theorem

For every `q=3^h >= 9`, let

```text
V(t) = (1,t,t^2,t^3,t^4),  V(infinity)=e_4,  N=e_2,
S_q = Gamma_4 union {N}.
```

The projective-system row code `Q_q` on `S_q` has

```text
Q_q = [q+2, 5, q-3]_q,
d(Q_q^perp)=5.
```

Its inclusion-minimal circuits of size at most five are exactly

```text
{N} union B,
```

where `B` is a harmonic quadruple of `P^1(F_q)`. These quadruples form a Steiner system
`S(3,4,q+1)`: every three curve points lie in a unique block. Consequently every coordinate has
exact locality four, and the complete radius-four repair ports are:

- at `N`, all harmonic quadruples `B`;
- at a curve point `x`, all `{N} union (B minus {x})` with `x in B`.

There are

```text
b = (q+1)q(q-1)/24
```

repairs at `N` and `q(q-1)/6` repairs at each curve coordinate. Every curve-target repair contains
`N`, so every curve coordinate has exact row `(nu,tau)=(1,1)`. At the nucleus the row is the
matching/transversal row of the harmonic Steiner quadruple system. For `q=9` it is exactly

```text
(nu_N,tau_N)=(2,5),
```

and the code is `[11,5,6]_9`, with 30 nucleus repairs and 12 repairs at each curve coordinate.

### Proof

The osculating hyperplane at a finite parameter `a` has coefficients proportional to the fourth
binomial row evaluated at `-a`. In characteristic three its `X_2` coefficient vanishes, and the
intersection formula above leaves precisely `N=e_2`.

Four finite curve points with distinct parameters `a,b,c,d` span a hyperplane containing `N`
exactly when

```text
e_2(a,b,c,d)=0.
```

A block containing `infinity` and finite `a,b,c` has the corresponding condition

```text
a+b+c=0.
```

Given three distinct finite parameters, put `e_1=a+b+c` and
`e_2=ab+ac+bc`. If `e_1 != 0`, the unique fourth point is

```text
d = -e_2/e_1.
```

It differs from `a,b,c`, since substituting `d=a` gives `(a-b)(a-c)`, and similarly for the other
two parameters. If `e_1=0`, then `e_2!=0`: otherwise the three parameters would be roots of
`T^3-abc`, contradicting injectivity of Frobenius. The unique completion is then `infinity`.
Conversely, a triple `infinity,a,b` completes uniquely with `c=-a-b`, again distinct in
characteristic three. This proves the Steiner property. Projectively these are exactly the images
of `{infinity,0,1,-1}`, hence the harmonic quadruples.

Any five curve points are independent. The preceding determinant criterion shows that
`{N} union B` has rank four exactly for a harmonic block `B`; deleting any point leaves four
independent columns. There are no smaller circuits, because every set consisting of `N` and three
curve points is obtained by deleting the unique fourth point from one of these circuits. This gives
the circuit and repair classification and proves `d(Q_q^perp)=5`.

A hyperplane meets `Gamma_4` in at most four distinct points and contributes at most the additional
point `N`, so its section with `S_q` has size at most five. Every harmonic block attains five.
Since `S_q` spans `PG(4,q)`, the projective-system distance is `(q+2)-5=q-3`.

## Asymptotic replication consequence

For radius four the coarse C216 inner condition is automatic:

```text
r+1 = 5 < 2 d(Q_q^perp) = 10.
```

Thus, for every fixed `q=3^h >= 9`, C216 places this entire harmonic repair port with positive
density inside asymptotically good `F_q`-linear concatenated families. This transfers the complete
Steiner repair design, not just the existence of one locality-four equation.

## Verification

[`2026-07-16-c218-quartic-nucleus-verifier.py`](2026-07-16-c218-quartic-nucleus-verifier.py)
independently checks the Lucas dimension formula in 252 degree/prime cases and replays the quartic
family over `GF(9)` and `GF(27)`. It constructs every harmonic block by unique triple completion,
checks the Steiner property, and exhaustively confirms that the mixed five-sets are exactly all
dependent five-sets. At `q=9` it also enumerates all 7,381 projective hyperplanes and all subsets of
the ten curve points, confirming `[11,5,6]_9`, harmonic independence number five, and nucleus row
`(2,5)`. The deterministic output is
[`2026-07-16-c218-quartic-nucleus-verifier.json`](2026-07-16-c218-quartic-nucleus-verifier.json).

## Prior-art and novelty boundary

The general nucleus formulas are classical. The load-bearing source is Johannes Gmainer and Hans
Havlicek, [*Nuclei of Normal Rational Curves*](https://arxiv.org/abs/1304.0088), Theorem 1 and
formula (27). The full text was read from cache key `arXiv:1304.0088`, SHA-256
`da688c01e3953319ef93f17e1676fedf0470c590a0a348a853dabb11209526d0`. Harmonic quadruples,
Steiner quadruple systems, and projective-system distance are also established mathematics.

A bounded search combining normal-rational-curve nuclei, harmonic quadruples, Steiner systems,
locality, repair codes, and storage codes found adjacent NRC-based LRC constructions and classical
`PGL(2,q)` Steiner constructions, but no source identifying this quartic-nucleus projective system's
complete radius-four repair ports or their C216 replication. The repair interpretation is therefore
a none-found candidate contribution, not a priority claim.

## Disposition

C218 meets its publication gate at scout level: it supplies a genuinely higher-degree infinite
family, exact code parameters and locality, a complete small-circuit classification, a classical
Steiner-design identification, a strict finite `(nu,tau)` row, and immediate positive-density
replication. A broad census of the other nonempty nuclei is not needed.

The next lane task is C219's reliability and Boolean analysis of complete repair ports.
