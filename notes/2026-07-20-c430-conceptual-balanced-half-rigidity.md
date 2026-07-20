# C430 conceptual balanced-half rigidity

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `THEOREM; RADICAL--HADAMARD RIGIDITY REPLACES THE H3 HALF EXHAUSTION`

## Result

The C406 `B3/H3` factorization-difference configurations satisfy a symbolic two-sheet theorem.
Their degree-at-most-two evaluation space is exactly the hyperplane of functions having equal sums
on the two `PSL_2(q)` sheets.  Consequently its orthogonal trade space is the one-dimensional sheet
sign line.  In particular, the two sheets are the only complementary equal halves with equal first
and second moments.

This is stronger than the former `binom(22,11)=705432` H3 check: it classifies **every**
field-valued signed trade orthogonal through degree two, not only `+-1` vectors of Hamming weight
eleven.  No subset exhaustion or meet-in-the-middle join is load-bearing.

## Abstract theorem

Let `k` be a field and let `Omega=Omega_+ disjoint_union Omega_-`, where both sheets have size `q`
and `q=0` in `k`.  Put `A=k^Omega`, with coordinatewise multiplication and the standard pairing

```text
<f,g> = sum_(x in Omega) f(x)g(x).
```

Let `L` be the evaluation space of affine-linear functions on a two-sheet point configuration, and
write

```text
H_+- = {a in k^(Omega_+-) : sum a = 0}.
```

Assume:

1. each sheet has zero first moment and the two sheets have equal second moments;
2. `dim L=q`, and restriction maps `L -> H_+` and `L -> H_-` both have rank `q-1`;
3. the total second-moment form has rank `q-2` and a one-dimensional radical; and
4. evaluation of a radical covector is constant on each sheet, with two distinct constants.

Then, for the coordinatewise-product square

```text
L^(2) = span_k {fg : f,g in L},
```

one has

```text
L^(2) = {(u_+,u_-) : sum u_+ = sum u_-},
(L^(2))^perp = k (1_(Omega_+) - 1_(Omega_-)).
```

Thus every signed strength-two trade is a scalar multiple of the sheet sign.  A trade taking only
the values `+-1` is the sheet sign or its negative, so its positive half is exactly one of the two
sheets.

## Proof

Let `e_+` and `e_-` be the two sheet indicators.  The radical covector evaluates as
`a_+ e_+ + a_- e_-` with `a_+ != a_-`.  Since `1=e_++e_-` also belongs to `L`, the two displayed
functions solve linearly for `e_+` and `e_-`; hence both sheet indicators lie in `L`.

The first-moment and `q=0` hypotheses put every restriction of `L` inside `H_+` or `H_-`.
The rank `q-1` hypotheses therefore make both restriction maps surjective.  Multiplication by the
sheet indicators now gives

```text
H_+ direct_sum 0  subseteq L^(2),
0 direct_sum H_-  subseteq L^(2).
```

This supplies a `2q-2` dimensional subspace of `L^(2)`.

For affine-linear `f,g`, the difference between the two sheet sums of `fg` expands into constant,
first-moment, and second-moment terms.  All vanish by the hypotheses, so every product lies in the
equal-sheet-sum hyperplane `E`; hence `L^(2) subseteq E`.

It remains to find one product outside `H_+ direct_sum H_-`.  The standard pairing on `H_+` has
radical `k e_+` and induces a nondegenerate form on the `(q-2)`-dimensional quotient
`H_+/k e_+`.  Equivalently, this is the certified rank-`q-2` second-moment form.  Choose restrictions
`a,b in H_+` with `<a,b> != 0`, and lift them to `f,g in L`.  Equal second moments give the same
nonzero pairing on the other sheet, so `fg` has equal **nonzero** sheet sums.  Therefore
`fg notin H_+ direct_sum H_-`.

Thus `L^(2)` contains `2q-1` independent directions and lies in the `2q-1` dimensional hyperplane
`E`, proving equality.  Finally `E` is the kernel of pairing with `e_+-e_-`; nondegeneracy of the
ambient coordinate pairing gives `E^perp=k(e_+-e_-)`.

## Certified `B3/H3` hypotheses

The exact certificate reconstructs the frozen C406 secant-product quotients and checks only the
inputs used by the theorem.  The final two columns are direct row-reduction cross-checks, not proof
steps.

| type | `q` | quotient dimension | affine rank | sheet restriction ranks | second-moment rank/radical | radical values by sheet | predicted/direct degree-two rank |
|:---|---:|---:|---:|:---|:---|:---|:---|
| `B3` | 7 | 6 | 7 | `6,6` | `5 / 1` | `0 / 5` | `13 / 13` |
| `H3` | 11 | 10 | 11 | `10,10` | `9 / 1` | `0 / 9` | `21 / 21` |

In both cases the certificate also checks separate zero first moments, equality of the sheet second
moments, and that the direct degree-two trade kernel is the sheet-sign line.  The H3 input therefore
uses the certified `9+1` rank/radical structure requested by C430; it does not enumerate 11-subsets.

## Reproducibility

Run from the repository root with Python 3.13.12:

```bash
python3 notes/2026-07-20-c430-conceptual-balanced-half-rigidity.py --check
python3 notes/2026-07-20-c430-conceptual-balanced-half-rigidity-replay.py --check
sha256sum -c notes/2026-07-20-c430-conceptual-balanced-half-rigidity.sha256
```

The primary generator uses the committed C406/C399 geometric constructors, verifies the abstract
theorem's finite hypotheses, and emits canonical sorted JSON.  The replay has its own modular
row-reduction, nullspace, and symmetric-square implementation; it independently obtains ranks
`13/21`, one-dimensional kernels, sheet signs, and radical separation.  It shares only the frozen
geometric constructor with the primary calculation.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| `2026-07-20-c430-conceptual-balanced-half-rigidity.py` | 8,899 | `8c10f29ff56cbda95dcb522b9cafc8196640bbe0ee9e9f93a59202d206ef9a95` |
| `2026-07-20-c430-conceptual-balanced-half-rigidity-replay.py` | 6,407 | `634181cf3780e83f337469e31d40eb3b92196d08860c68cca35fc5776a7673b2` |
| `2026-07-20-c430-conceptual-balanced-half-rigidity.json` | 3,533 | `7821439c325204b45269e2b1b29ca6174c448243d1803c9b690d9c4811def96e` |

The trusted computational boundary is exact finite-field arithmetic in the two scripts plus the
committed C406/C399 matching and conic-quotient constructors whose hashes are embedded in the JSON.
The abstract proof above is not machine-checked here.  The certificate proves the hypotheses for
the frozen `q=7,11` configurations; it does not assert that every unrelated index-two group orbit
automatically satisfies radical separation or restriction surjectivity.

## Claim and formalization boundary

The C406 priority audit already pre-empts the exceptional one-factorizations and their ordinary
Delsarte-design status.  C430 performs no new priority search and makes no new general design
classification claim.  Its contribution is the symbolic radical/interpolation mechanism for the
existing conic-quotient configurations.

For C424/F5, the H3 `2^11` meet-in-the-middle leaf can be replaced by one abstract
radical--Hadamard lemma plus the small frozen hypotheses above.  This report does not edit the
`clebsch`-owned Lean modules or change their release gate.
