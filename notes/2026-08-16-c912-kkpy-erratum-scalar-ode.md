# The scalar-ODE calculation offered to KKPY, ready to send

**Date:** 2026-08-16 · **Lane:** `cubic-threefolds` · **Task:** C912 · **Purpose:** the short
derivation promised in the erratum message of 2026-08-16 ("I'd be happy to send the short
scalar-ODE calculation for the first point if useful"), written out so it can go immediately.

Source: arXiv:2508.05105v2, cached, sha256
`2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64`.
Both eliminations below were machine-checked with sympy; the quadric one reproduces the
paper's own displayed answer, which validates the method against their published case.

## Paste-ready text

Write `δ = u q ∂_q`. For a cubic threefold (`N = 5`, `k = 1`, `d = 3`, `d_tot = 3`), put an
unknown `b q²` in the upper-right slot of the matrix of Example 6.6(ii):

    A_b = [ 0   6q   0    b q² ]
          [ 1   0    15q  0    ]
          [ 0   1    0    6q   ]
          [ 0   0    1    0    ]

The system (6.5), `δψ = −A_b ψ`, reads

    δψ_1 = −(6q ψ_2 + b q² ψ_4) ,   δψ_2 = −(ψ_1 + 15q ψ_3) ,
    δψ_3 = −(ψ_2 + 6q ψ_4) ,        δψ_4 = −ψ_3 .

Setting `φ = ψ_4` and solving upward, using `δ(q^k g) = k u q^k g + q^k δg`,

    ψ_3 = −δφ ,
    ψ_2 = δ²φ − 6q φ ,
    ψ_1 = −δ³φ + 21q δφ + 6u q φ .

Substituting into the first equation gives

    δ⁴φ = q (27 δ² + 27 u δ + 6 u²) φ − (36 − b) q² φ .

Givental's equation (6.4), specialized to `N = 5`, `k = 1`, `d_1 = 3`, `d_tot = 3`, is

    δ⁴φ = (−1)^{N−d_tot} q · d_1 · Π_{m=1}^{d_1−1} (d_1 δ + m u) φ
        = 3q (3δ + u)(3δ + 2u) φ
        = q (27 δ² + 27 u δ + 6 u²) φ ,

with no `q²` term. The `δ²`, `δ` and constant coefficients agree between the two
computations, which fixes the rest of the matrix and isolates the corner entry; comparing the
`q²` terms forces

    b = 36 .

With that entry, `χ_K(λ) = λ²(λ² − 108q)`, matching Example 6.21. Without it,
`χ_K(λ) = λ⁴ − 108qλ² + 576q²`, which is regular semisimple for `q ≠ 0`.

**Consistency check on the method.** The same elimination applied to Example 6.6(i), with
unknowns `a_1` and `a_2` in the slots the index allows for the quadric threefold, gives

    δ⁴φ = −q ( (a_1 + a_2) δ + a_2 u ) φ ,

which is the displayed ODE of that example; comparison with (6.4) at `d = 2` gives
`a_1 + a_2 = 4`, `a_2 = 2`, reproducing the matrix displayed there. So the discrepancy is
confined to the cubic display.

## Replay

    uv run --with sympy python3 notes/scripts/c912_kkpy_erratum_scalar_ode.py

## Deliberately not included

The message did not mention Remark 3.14, Cai's paper, our block reduction, the cubic
threefold's zero packet as an object of interest, or any application. That is a disclosure
decision, not an accuracy one — see `2026-08-16-c912-cubic-zero-atom-splitting-repair.md`
§18–19 for why the Remark 3.14 item was dropped on the merits as well.

## The two questions asked, and what their answers settle

1. **Theorem 4.11 / Eq. (4.6).** Whether the passage from the formal Iritani–Koto isomorphism
   to the non-archimedean analytic maximal F-bundles is automatic once the growth condition
   holds. Their proof states that "Eq. (4.6) reduces the non-archimedean statement to the
   formal" one. This is the weakest point on our own critical path that lives on their side of
   the line.
2. **Proposition 5.22.** Whether an invariant of geometric Hodge-atomic F-bundles that is
   invariant under the two equivalences of Definition 5.21 automatically descends to Hodge
   atoms, given that Proposition 5.22 already checks the disjoint-union, blowup and
   projective-bundle relations. A yes closes the second amber item of
   `2026-08-16-c912-cubic-zero-atom-splitting-repair.md` §15 outright.

Neither question names the cubic threefold, an invariant, or an application; both are natural
for any careful reader of their §4.3 and §5.4.
