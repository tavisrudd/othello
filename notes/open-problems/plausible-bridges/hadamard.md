# Hadamard conjecture versus the Golden conference factor

**External ID:** `BIG-401`
**Verdict:** no present conjecture-level progress; order 668 supplies a sharp
independent target.

## Exact local consequence

The Golden `6 x 10` sign factor yields the ten `3+3` cuts, an `ETF(5,10)`, and
a symmetric conference matrix `S` of order 10 satisfying `S^2=9I`.  The
standard conference construction therefore gives a Hadamard matrix of order
20.

Order 20 is classical.  The reverse-factorization rigidity theorem explains
the Golden origin of this particular realization, but it neither creates a
new Hadamard order nor supplies an operation

```text
conference/Hadamard at n -> conference/Hadamard at larger n.
```

The later cut-moment calculations at Paley orders 14 and 18 analyze existing
conference matrices; they do not construct them.  There is therefore no
current implication toward existence at every order divisible by four.

## What would make the local direction real

- a functorial order-growing conference construction;
- a new conference matrix at an order not covered by known constructions;
- a sign-factor obstruction that proves nonexistence in a previously open
  structured family.

The first would be major.  The present `6 -> 10` semantic explanation is not
evidence that such a tower exists.

## Independent attack: the smallest unknown order

The 2024 construction database listed 668, 716, 892 and 1132 as the unresolved
orders at most 1208.  A July 2026 paper confirms that 668 remains the smallest
and attacks it through Legendre pairs of length 333.  Such a pair would yield
a Hadamard matrix of order 668.

Ramos--Hulak--de Queiroz analyze the 30 possible common multiplier subgroups
after compression and exclude 21, including every subgroup of order at least
9.  Nine structured cases with multiplier size at most 6 remain, while the
unrestricted Legendre-pair problem remains open.

This suggests a concrete independent programme:

1. reproduce all 21 certificates and canonicalize the nine surviving orbit
   systems;
2. combine mod-3/mod-9 compression, power spectral density constraints and
   exact meet-in-the-middle enumeration;
3. emit proof-carrying pseudo-Boolean certificates for every excluded case;
4. if all structured cases fail, move to other Goethals--Seidel/SDS ansatzes
   without confusing ansatz failure with nonexistence of order 668.

Completing the nine multiplier cases is plausibly tractable.  Constructing or
ruling out an unrestricted order-668 Hadamard matrix remains much harder.

## Promotion gate

Mention the Hadamard conjecture as more than context only after obtaining a
new order, a new infinite construction family, or a certified obstruction to
a previously unresolved major ansatz.  A symmetric conference matrix of order
334 would solve order 668, but nothing in the current Golden factorization
points to one.

## Sources and local audit trail

- Matteo Cati and Dima Pasechnik, *A database of constructions of Hadamard
  matrices*, arXiv `2411.18897`; `partial`, cached SHA-256
  `12b04b17459e088618af96b624bff0d83eb072626f7de706a94a4b10746c34d6`.
- Arthur F. Ramos, David B. Hulak and Ruy J. G. B. de Queiroz, *Multiplier
  obstructions for Legendre pairs of length 333*, arXiv `2607.20765`;
  `partial`, cached SHA-256
  `de396e62dc6d1cf43b9fea51d753318464bc8ed773c6b3f6cf6cb5fa681a1c70`.
- `notes/2026-07-31-c729-simplex-conference-factorization.md`.
- `notes/2026-07-31-c729-conference-cut-moments.md`.
