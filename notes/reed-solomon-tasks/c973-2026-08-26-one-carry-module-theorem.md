# C973 one-carry Lucas-module theorem

Date: 2026-08-26  
Status: proved; structural input for the arbitrary-redundancy programme

This theorem is the `D=1` specialization of the later coupled exact sequences
in `c973-2026-08-26-digit-stripping-exact-sequence.md`.  Retain it as the
short worked corollary used by the characteristic-seven certificate argument,
not as a separate general architecture.

## Theorem

Let the characteristic be `p`, let

```
r-2 = p+a,             0 <= a <= p-3,
m = p-a-3,
```

and put `n=r-1=p+a+1`.  Then the maximal adjacent-zero Lucas carrier is

```
M^max_{r,p} = P<e_{a+2},e_{a+3},...,e_{p-1}>.
```

It has vector dimension `m+1`.  More strongly, it is projectively the
standard degree-`m` divided-power module.  An explicit equivariant basis is

```
g_k = binom(a+2+k,k) e_{a+2+k},       0 <= k <= m.
```

Thus

```
M^max_{r,p}  ~=  P(Gamma^m E)
```

as a `PGL_2`-variety.  No semisimplicity or characteristic-zero binomial
rescaling is used: all displayed scalars are nonzero modulo `p`.

## Proof

Lucas' criterion on row `p+a`, whose base-`p` digits are `(1,a)`, says that
the nonzero positions are exactly

```
{0,...,a} union {p,...,p+a}.
```

The adjacent zero pairs therefore occur exactly at
`j=a+2,...,p-1`, proving the coordinate-span assertion.

Write `s=a+2`, so `m=p-s-1`.  Under translation `t -> t+u`, normal-rational-
curve equivariance gives

```
e_j -> sum_{i=j}^n binom(i,j) u^(i-j) e_i.
```

If `s<=j<=p-1` and `p<=i<=n=p+a+1`, Lucas gives
`binom(i,j)=0`, because the low digit of `i` is at most `a+1<j`.
Hence the carrier is stable and, for `0<=k<=m`,

```
g_k -> sum_{l=k}^m
       [c_k binom(s+l,s+k)/c_l] u^(l-k) g_l,
c_k = binom(s+k,k).
```

The bracket equals `binom(l,k)` by cancellation of factorials.  This is the
standard translation action on `Gamma^m E`.  Scaling acts on `g_k` with
weight `lambda^(s+k)`; removing the common projective factor `lambda^s`
leaves the standard weights `lambda^k`.

Finally inversion sends `e_{s+k}` to

```
e_{n-s-k}=e_{p-1-k}=e_{s+m-k}.
```

Since

```
c_k = binom(p-m-1+k,k) = (-1)^k binom(m,k)  (mod p),
```

one has `c_{m-k}=(-1)^m c_k`.  Inversion therefore differs from the standard
basis reversal by one common scalar.  Translations, scalings, and inversion
generate `PGL_2`, completing the projective equivariance proof.

## Consequences

The tail of every first one-carry block has uniformly bounded orbit geometry:

| `a` | `m` | carrier | pointed carrier/root orbits |
|---:|---:|---|---:|
| `p-3` | `0` | a point | 1 |
| `p-4` | `1` | `P(E)` | 2 (equal/distinct) |
| `p-5` | `2` | binary quadratics | 5 in odd characteristic |

For `p=7`, these are exactly R13, R12, and R11.  The seven q=49 certificates
in `c973-char7-pointed-orbits.json` close the degree-two and degree-one rows;
pointed lifting closes degree zero.  Lucas row `2p-2` then has only one zero
and the carrier disappears at the next redundancy.

This theorem changes the software target.  For these digit families, an
ambient marker enumeration is conceptually wasteful.  The correct interface
is:

```
(p,a, binary-form orbit, forbidden-root orbit) -> locator certificate.
```

For `m<=2`, the number of inputs is independent of `q`.  For larger `m`, the
remaining research question is whether pointed shallow-witness existence can
be proved uniformly on `P(Gamma^m E)` without classifying all binary-form
orbits.

## Paper integration note

In the separate paper-update item, use this as the structural lemma and make
the characteristic-seven R11--R13 closure its worked corollary.  It should
replace, rather than supplement, redundancy-by-redundancy prose.  The proof is
short enough for the recursive-carrier section; the seven locators stay in
the supplement.

## Mystery ledger

- Settled: the R11/R12/R13 progression is one module theorem, not three
  unrelated finite-stage phenomena.
- Settled: the rescaling is valid in characteristic `p`; its coefficients
  never cross index `p` and are nonzero.
- Open: analogous closed module formulas for later multi-digit blocks, where
  Frobenius tensor factors should replace this single divided-power factor.
- Open: a uniform pointed-abundance theorem on `P(Gamma^m E)` for unbounded
  `m`; orbit classification itself is unlikely to be the efficient route.
- Owner: C973 mathematical continuation; manuscript integration remains a
  separate successor item.

Vibe: this is the unifying upgrade; more raw R-level computation would now be
the wrong abstraction.
