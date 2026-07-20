# C430 conceptual balanced-half rigidity

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `THEOREM; RADICAL--HADAMARD RIGIDITY REPLACES THE H3 HALF EXHAUSTION; TRADE LINE IS THE OUTER-ODD PROJECTIVE-COVER SOCLE`

## Result

The C406 `B3/H3` factorization-difference configurations satisfy a symbolic two-sheet theorem.
Their degree-at-most-two evaluation space is exactly the hyperplane of functions having equal sums
on the two `PSL_2(q)` sheets.  Consequently its orthogonal trade space is the one-dimensional sheet
sign line.  In particular, the two sheets are the only complementary equal halves with equal first
and second moments.

This is stronger than the former `binom(22,11)=705432` H3 check: it classifies **every**
field-valued signed trade orthogonal through degree two, not only `+-1` vectors of Hamming weight
eleven.  No subset exhaustion or meet-in-the-middle join is load-bearing.

It also gives a direct recovery algorithm: compute the unique linear second-moment radical,
evaluate it on the `2q` points, and take its two level sets.  These are exactly the two sheets.

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

## C412 socle identification

The modular interpretation suggested after C430 is exact, not merely an analogy.  Let `L` be the
eleven-dimensional H3 affine evaluation space on the 22 quotient points.  Its evaluation pairing
has rank nine and a two-dimensional radical.  Direct calculation gives

```text
rad(L) = span {e_+,e_-},
```

where `e_+` and `e_-` are the two sheet indicators.  C412 independently identifies the
permutation module on each sheet with the projective cover `P(1)` having Loewy series `1|9|1`; its
constant line is `soc(P(1))`.  Therefore

```text
rad(L) = soc(P(1)_+) direct_sum soc(P(1)_-).
```

The outer element swaps these two socles.  Their even line is the global constant function, while
their outer-odd line is `e_+-e_-`, exactly C430's one-dimensional degree-two trade kernel.  On the
`A4`-fixed orbit-sum slice this same line has C412 coordinates `[1,1,1]` and is precisely the depth
socle killed by the rank-two depth map.

This closes the proposed C430--C412 identification:

```text
C430 sheet-sign trade line = C412 outer-odd projective-cover socle line.
```

It does **not** identify the relative-cubic Tate plane with the depth plane; C412's divided-transfer
obstruction remains unchanged.

## Free corollaries and reuse test

1. **Recognition:** the unordered sheets are recovered by one nullspace and two-level evaluation,
   rather than balanced-subset search.
2. **Formalization:** C424/F5 needs one abstract radical--Hadamard lemma and small rank/radical
   leaves, not a `2^11` meet-in-the-middle checker.
3. **Portable obstruction:** any proposed two-sheet strength-two trade is killed once restriction
   surjectivity and radical separation are proved.  Failure of either condition localizes the only
   place an exotic trade can live.
4. **Modular meaning:** in the H3 case the constant and signed radical lines are the even and odd
   combinations of the two projective-cover socles.  This is the canonical starting point for
   C433, while the integral/Frobenius behavior of the odd line is a bounded input to C429.
5. **Information lattice:** the intrinsic algebra chain is now
   `affine radical -> sheet indicators -> equal-sheet-sum product algebra -> sheet-sign trade line`,
   a concrete local model for C434's proposed `K\G/H` functor.

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
| `2026-07-20-c430-conceptual-balanced-half-rigidity.py` | 12,559 | `ef2e6f0c9249ebf038f9d54ec80ceb48abdfe8601e89d4da3d34a5c9a6b9c337` |
| `2026-07-20-c430-conceptual-balanced-half-rigidity-replay.py` | 8,869 | `20e6c214786aab7ae2be7e512fa01774a6bafd08d6153941c3880acadb8a2a8c` |
| `2026-07-20-c430-conceptual-balanced-half-rigidity.json` | 4,646 | `eebfd0525c94ac0bcb7965ab33b6d11a698242e608d9d1a40cebaa0a2b451098` |

The trusted computational boundary is exact finite-field arithmetic in the two scripts plus the
committed C406/C399 matching and conic-quotient constructors whose hashes are embedded in the JSON.
The socle identification additionally consumes C412's committed projective-cover certificate,
whose hash is also embedded in the JSON.  The abstract proof above is not machine-checked here.
The certificate proves the hypotheses for the frozen `q=7,11` configurations; it does not assert
that every unrelated index-two group orbit automatically satisfies radical separation or
restriction surjectivity.

## Claim and formalization boundary

The C406 priority audit already pre-empts the exceptional one-factorizations and their ordinary
Delsarte-design status.  C430 performs no new priority search and makes no new general design
classification claim.  Its contribution is the symbolic radical/interpolation mechanism for the
existing conic-quotient configurations.

For C424/F5, the H3 `2^11` meet-in-the-middle leaf can be replaced by one abstract
radical--Hadamard lemma plus the small frozen hypotheses above.  This report does not edit the
`clebsch`-owned Lean modules or change their release gate.
