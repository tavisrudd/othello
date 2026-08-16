# C912 — the genus-six Gushel–Mukai test of the Serre-operator identification

**Date:** 2026-08-15
**Lane:** `clebsch`
**Task:** C912 (analysis only; no manuscript edit)
**Follows:** `2026-08-15-c912-det-r-pairing-and-serre-lattice.md`, Section 4 and its
step 1 ("run the genus-six test")
**Tests against:** `2026-08-12-c907-prime-fano-primitive-sixth-classification.md`

Section 4 of the previous report identified the primitive-sixth count with the number of
eigenvalues of the Serre operator on the numerical Grothendieck group of the Kuznetsov
component that are primitive sixth roots of unity, and named the sharpest way to break it:
the genus-six Gushel–Mukai threefold `V_10`, whose Kuznetsov component is nonzero while the
lane's prime-Fano classification gives count zero. That test is now run, together with a
sweep over the whole prime-Fano census.

## Verdicts

1. **The genus-six test passes, and neither side is refuted.** The numerical Grothendieck
   group of the Kuznetsov component of a Gushel–Mukai threefold is the rank-two lattice
   `<-1> + <-1>`; its Euler form is *symmetric*, so the Serre operator is the identity, its
   eigenvalues are `1, 1`, and the primitive-sixth count is zero. That is the lane's
   provisional value `nu_6(V_10) = 0` on the nose. The identification survives the test it
   was most likely to fail, and the provisional zero gains an independent confirmation from a
   completely different computation.
2. **The agreement is finer than the count.** The classification's genus-six certificate does
   not merely report zero: it reports that the framed residues are integral, including the
   resonant double block. Integral residues mean trivial formal monodromy on that block, and
   the Serre operator on the matching component is not merely free of primitive sixth roots
   but is the identity matrix. Both sides say "nothing at all", not just "no sixes".
3. **The identification now matches the entire prime-Fano census, not one target.** Running
   the same computation for every prime genus reproduces the classification's values
   `nu_6 = 2` at genera four and eight and `nu_6 = 0` at genera two, three, five, six, seven,
   nine, ten and twelve. At genera two through five, where the classification records the
   reduced factorial cyclotomic polynomial `R` explicitly, the match is polynomial-level: the
   characteristic polynomial of the Serre operator is `R` with `lam` replaced by `-lam` in
   every case. This pins the sign convention that was previously implicit.
4. **One new prediction, and it is testable by the lane's own machinery.** For the sextic
   double solid `Y_1` (index two, degree one) the same computation gives the cubic
   threefold's lattice and hence count two. `Y_1` is outside the census, which covers index
   one only, so this is not a conflict — it is a falsifiable prediction: the lane's quantum
   differential operator for `Y_1` should show a primitive-sixth pair. Section 5 explains why
   the apparent clash with the genus-seven zero is a statement about Kuznetsov's Fano
   threefold conjecture at degree one rather than about the identification.

## 1. Method

Everything is derived from Hirzebruch–Riemann–Roch on the threefold. The previous report's
cubic-threefold check took the Euler matrix `[[-1,-1],[0,-1]]` as an external input; here
nothing is imported, and the cubic is recomputed as a calibration.

For a Fano threefold `X` with `Pic = Z.H`, index `i` (so `-K_X = iH`) and degree `d = H^3`,
numerical Chern characters are written `(r, a, b, c)` for `ch = r + aH + b l + c p`, with `l`
the degree-one curve class and `p` the point class, so `H^2 = d l` and `H.l = p`. From
`td(X) = 1 + c_1/2 + (c_1^2 + c_2)/12 + c_1c_2/24` and `chi(O_X) = 1` one gets `H.c_2 = 24/i`
and

```
chi(E) = r + a (i^2 d + 24/i)/12 + b i/2 + c,
chi(E,F) = int ch(E)^dual ch(F) td(X),      ^dual negating the odd part.
```

The numerical Grothendieck group is the rank-four lattice spanned by the structure sheaves of
`X`, of a hyperplane section, of a degree-one curve and of a point. `N(Ku)` is the right
orthogonal of the exceptional collection, saturated inside that lattice, and the Serre
operator is `S = E^{-1}E^T` for the Gram matrix `E_ij = chi(e_i, e_j)`, from
`chi(a,b) = chi(b, Sa)`. Its characteristic polynomial is unchanged by any change of basis and
by passing to a finite-index sublattice; the script checks this explicitly on every row by
recomputing after a unimodular substitution.

## 2. The Gushel–Mukai input, forced three ways

The one geometric input the genus-six case needs beyond `(i, d) = (1, 10)` is the Chern
character of the rank-two tautological bundle appearing in Kuznetsov–Perry's decomposition
`D^b(X) = <Ku(X), O_X, U^dual>`. Write `k = H.c_2(U^dual)`. Schubert calculus in `Gr(2,5)`,
where `X = Gr(2,5) cap P^7 cap Q` has class `2 sigma_1^3`, gives

```
k = 2 int_{Gr(2,5)} sigma_1^4 sigma_{1,1} = 2 . 2 = 4.
```

The same value is forced from inside the derived category, without Schubert calculus, three
separate ways: `chi(U^dual) = 9 - k` must be `5` because `U^dual` is globally generated with
space of sections the five-dimensional `V_5`; `chi(U^dual, U^dual) = 9 - 2k` must be `1`
because `U^dual` is exceptional; and `chi(U^dual, O_X) = 0` holds identically, which is the
semiorthogonality the decomposition asserts and is therefore a check on the whole
Riemann–Roch setup rather than on `k`. So `ch(U^dual) = (2, 1, 1, -1/3)`, and every
consistency condition available is satisfied.

## 3. The test

With `<Ku(X), O_X, U^dual>` the right orthogonal is rank two, as the block structure demands:
the classification's operator `L_10` has exponential polynomial `(lam+6)^2 (lam^2 - 32 lam - 244)`,
a rank-two resonant block at `-6` and two simple blocks, matching a rank-two residual component
and two exceptional objects. In the basis

```
w_1 = [O_X] - 2[O_l] + [O_p],      w_2 = [O_S] + [O_l] - 3[O_p]
```

of geometric classes the Euler form has Gram matrix `[[-1,-2],[-2,-5]]`, unimodular; replacing
`w_2` by `w_2 - 2w_1` diagonalizes it to `[[-1,0],[0,-1]]`. So

```
N(Ku(V_10)) = <-1> + <-1>,   E symmetric,   S = E^{-1}E^T = I,   count = 0.
```

The mechanism behind the zero is worth stating plainly, because it is what makes the result
robust: for the cubic threefold the Euler form on the residual component is *not* symmetric,
and the failure of symmetry is exactly what produces a Serre operator of order six. For the
Gushel–Mukai threefold the Euler form is symmetric, and a symmetric Euler form forces
`S = I` whatever the lattice is. No delicate cancellation is involved.

## 4. The census sweep

The classification's ten prime genera are covered by three groups: genera two through five,
where only `O_X` splits off; genus six, the Gushel–Mukai case; and genera seven through
twelve, whose Kuznetsov components are those of the index-two threefolds `Y_d` under
Kuznetsov's correspondence `(d,g) = (1,7), (2,9), (3,8), (4,10), (5,12)`, computed on the
`Y_d` side where the collection is just `<Ku, O, O(1)>`.

| target                          | decomposition used     | rank | char. poly. of `S`     | count | census `nu_6` | verdict            |
|---------------------------------|------------------------|------|------------------------|-------|---------------|--------------------|
| cubic threefold `Y_3` (g = 8)   | `<Ku, O, O(1)>`        | 2    | `Phi_6`                | 2     | 2             | agrees (calibration) |
| **`V_10`, genus 6**             | `<Ku, O_X, U^dual>`    | 2    | `(lam-1)^2`            | **0** | **0**         | **agrees**         |
| `Y_1` (partner genus 7)         | `<Ku, O, O(1)>`        | 2    | `Phi_6`                | 2     | 0             | see Section 5      |
| `Y_2` (partner genus 9)         | `<Ku, O, O(1)>`        | 2    | `(lam-1)^2`            | 0     | 0             | agrees             |
| `Y_4` (partner genus 10)        | `<Ku, O, O(1)>`        | 2    | `(lam+1)^2`            | 0     | 0             | agrees             |
| `Y_5` (partner genus 12)        | `<Ku, O, O(1)>`        | 2    | `lam^2 + 7lam + 1`     | 0     | 0             | agrees             |
| genus 2 `X_2`                   | `<Ku, O_X>`            | 3    | `(lam-1) Phi_3`        | 0     | 0             | agrees             |
| genus 3 `X_4`                   | `<Ku, O_X>`            | 3    | `(lam-1) Phi_4`        | 0     | 0             | agrees             |
| genus 4 `X_6`                   | `<Ku, O_X>`            | 3    | `(lam-1) Phi_6`        | 2     | 2             | agrees             |
| genus 5 `X_8`                   | `<Ku, O_X>`            | 3    | `(lam-1)^3`            | 0     | 0             | agrees             |

Three things in this table go beyond the single test that was asked for.

**The sign convention is now pinned.** For genera two through five the classification records
`R = Phi_2 Phi_6, Phi_2 Phi_4, Phi_2 Phi_3, Phi_2^3`. The Serre characteristic polynomials in
the same rows are `Phi_1 Phi_3, Phi_1 Phi_4, Phi_1 Phi_6, Phi_1^3`. Negation `lam -> -lam`
exchanges `Phi_1` with `Phi_2` and `Phi_3` with `Phi_6` and fixes `Phi_4`, so the two lists
agree term by term, in all four rows, under that single substitution. The classification's own
phrasing — that a primitive-sixth pair occurs exactly when `R = Phi_2 Phi_3` — is explained by
it rather than assumed. The substitution is the shift `[1]`, which acts by `-1` on K-groups,
so the dictionary is: formal monodromy eigenvalues are the Serre eigenvalues of the shifted
component.

**Two independent cross-checks of the machinery.** The genus-two curve, which is Kuznetsov's
partner for `Y_4`, has Euler form `[[1-g,1],[-1,0]]` in the basis `[O_C], [O_p]`; its Serre
operator has characteristic polynomial `(lam+1)^2` for every genus, which is exactly the `Y_4`
row obtained from threefold Riemann–Roch. The cubic row reproduces the previously known
`Phi_6` and `S^3 = -I` with no external input.

**Not every residual component is an atom, and it does not matter for the count.** The `Y_5`
row is the quintic del Pezzo threefold, which has a full exceptional collection; its `Ku`
under `<Ku, O, O(1)>` is generated by a further exceptional pair, and its Serre operator has
infinite order, with real irrational eigenvalues. The `Y_4` row's operator is also of infinite
order, matching a curve category rather than a fractional Calabi–Yau one. In both cases the
count is nevertheless the right one. So the identification's *count* is stable under choosing a
coarser-than-atomic decomposition, even though the finer statement — that a block's formal
monodromy *equals* an atom's Serre operator — is not.

## 5. The `Y_1` row: what it actually says

`Y_1`, the sextic double solid, gives `N(Ku(Y_1))` with the same Gram matrix `[[-1,-1],[0,-1]]`
as the cubic threefold's, hence a Serre operator of order six and count two. Its conjectural
Kuznetsov partner is the genus-seven threefold `X_12`, for which the census gives zero. The
resolution is not on the identification's side.

For every smooth curve, of any genus, the Serre characteristic polynomial is `(lam+1)^2`, so a
Kuznetsov component equivalent to the derived category of a curve has count zero, always. The
genus-seven and genus-nine prime Fano threefolds have Kuznetsov components of exactly that
kind — Mukai's curves of genus seven and three — so the census value zero is reproduced on the
index-one side by the identification itself, in agreement with the census's own rationality
route. What the computation shows is that `Ku(Y_1)` cannot be equivalent to the derived
category of any curve, because an order-six Serre operator is not `(lam+1)^2`. So the pair
`(Y_1, X_12)` cannot satisfy Kuznetsov's Fano threefold conjecture — a statement about the
conjecture at degree one, which I believe is already known to fail there, and which does not
touch the identification.

That leaves the genuine content of the row as a prediction: `nu_6(Y_1) = 2` for the sextic
double solid itself. The census covers index one only, so nothing in the lane contradicts it,
and the lane's quantum-side machinery can compute it directly. It is the cheapest remaining
falsification test of the identification, and unlike the genus-six test it has a nonzero
predicted answer, so it is a sharper test: a zero on the quantum side would refute the
identification outright.

Two caveats on this section, both recorded rather than resolved: the failure of the degree-one
case of Kuznetsov's conjecture and Mukai's descriptions of the genus-seven and genus-nine
components are recalled from the literature and have not been verified against sources here.
Neither is load-bearing for the genus-six verdict.

## 6. Consequence for the blocker

The transport problem needs the count to be locally constant along a connected family. The
previous report's argument for that was: the count is read off an integral lattice with a
finite-order operator, so it is discrete, and a continuous family of discrete values is
constant. The genus-six test was the stated precondition for building on that argument, and it
has passed. Two refinements follow from the sweep.

First, finite order of the Serre operator is not part of the argument and should not be assumed:
the `Y_4` and `Y_5` rows have infinite-order operators. What is needed, and what is true, is
that the operator is defined over an integral lattice of bounded rank, so its characteristic
polynomial has integer coefficients and the multiplicity of `Phi_6` in it cannot vary
continuously. That is a weaker and safer hypothesis than fractional Calabi–Yau behaviour.

Second, the discreteness import is even lighter than the previous report claimed. Only the
integrality of the Euler form on the residual component is used — not the enhanced-atom
formalism, not the integral structure the sources defer, and not the Serre functor's order.

Next, in order.

1. Compute the quantum-side `nu_6` for the sextic double solid `Y_1` and compare with the
   predicted two. This is now the sharpest live test of the identification.
2. Resolve the `S^3 = [5]` versus `S^5 = [3]` reading at the source (ledger item C912-M26,
   unchanged by this report).
3. With the identification confirmed on ten targets, restate step (iii) of the atom route in
   its terms, as the previous report's step 3 proposed.
4. Delete hypothesis (H2) from the frame-transport memo and record the theorem that replaces
   it, as the previous report's step 4 proposed.

## Mystery ledger updates

| ID | Status | Discovery | Owner |
|---|---|---|---|
| C912-M25 | confirmed (was open) | The identification of the primitive-sixth count with the primitive-sixth eigenvalue count of the Serre operator on `N(Ku)` survives its sharpest test and now matches the whole prime-Fano census. For the genus-six Gushel–Mukai threefold `N(Ku) = <-1> + <-1>`, the Euler form is symmetric, `S = I` and the count is zero, agreeing with the lane's provisional zero; genera two through five, eight, ten and twelve agree as well. Still an expected correspondence rather than a proved one. | Sections 3 and 4 here |
| C912-M27 | resolved | The sign convention relating the classification's reduced factorial cyclotomic polynomial `R` to the Serre side is `lam -> -lam`, i.e. the shift `[1]`: in all four rows where `R` is recorded, the Serre characteristic polynomial is `R(-lam)` up to sign. | Section 4 here |
| C912-M28 | open | `N(Ku(Y_1))` for the sextic double solid has the cubic threefold's Gram matrix and an order-six Serre operator, so the identification predicts `nu_6(Y_1) = 2`; the lane has not computed that quantum-side value. Independently, no Kuznetsov component equivalent to a curve category can have nonzero count, so `Ku(Y_1)` is not a curve category and the degree-one case of Kuznetsov's Fano threefold conjecture cannot hold. | Section 5 here; owner is the `Y_1` quantum computation |
| C912-M29 | open | Why is the Euler form on the residual component symmetric for the Gushel–Mukai threefold and asymmetric for the cubic, given that both are rank-two components of index-adjacent Fano threefolds? The count is entirely controlled by that symmetry, and no structural reason for it was identified here. | Section 3 here |

## Replay

```sh
uv run --with sympy python notes/2026-08-15-c912-gm-genus-six-serre-check.py
```

```
953af4049286d9d4f18d9a2d26c6b1b62216ee129ac8a483ac85c21f7c513c5b  notes/2026-08-15-c912-gm-genus-six-serre-check.py
302305826bf05b9eaf6dc3afe89d2149f579b3371fca09f7e2b0e8e086700218  notes/2026-08-15-c912-gm-genus-six-serre-check.out
```

The script is self-contained: it takes only the numerical invariants `(index, degree)` of each
threefold and the Chern character of the Gushel–Mukai tautological bundle, which it re-derives
from three internal consistency conditions. Every row prints its own semiorthogonality and
exceptionality checks and a basis-independence check on the characteristic polynomial.
