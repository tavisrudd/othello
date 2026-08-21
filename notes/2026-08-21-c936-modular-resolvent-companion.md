# C936 — Modular resolvent companion

**Date:** 2026-08-21

**Status:** complete; seven-page local paper, evidence bundle, and cold read

## Outcome

The standalone companion now lives at
`papers/cubic-gluing-resolvent/`.  Its main theorem identifies the signed
parameter of the nonstandard `A_5` cubic pencil with the sign/discriminant
resolvent of the **actual** relative elliptic norm-axis two-division cover.
The normalization is

```text
T = 81 t^2,             r^2 = T,             r = 9t
```

after one choice of deck involution.  The five principal kernels are the two
proper transitive quotients of one `S_3` two-division torsor:

```text
S_3/C_2  (three roots)       and       S_3/A_3  (two signs).
```

The paper proves the complete modular diagram: the degree-three root curve is
`X_0(6)`, the degree-two curve belongs to the inverse image of `A_3` under
reduction modulo two, and the common degree-six splitting curve belongs to
`Gamma_0(3) intersect Gamma(2)`.  It gives rational equations for all three.
After a golden/sign orientation is chosen, the rational root packet becomes
that connected cyclic `C_3` splitting cover.  The same normalization gives
the explicit signed modular parameter

```text
t(tau) = 3 (eta(3tau)/eta(tau))^6.
```

## What made the comparison actual

The crucial bridge is not equality of `j`-invariants.  On the common marked
smooth `A_5/D_5` base, the degree-five quotient pullback from the explicit VGY
elliptic Prym lands in the primitive dihedral norm axis.  Pullback/norm gives
`[5]`.  The Prym polarization calculation gives

```text
phi^* Xi = 5 Xi_0,
```

while the primitive axis inclusion gives

```text
i_H^* Xi = 5 Xi_H.
```

Factoring `phi=i_H barphi` forces `deg(barphi)=1`.  Thus the explicit Prym is
the actual polarized norm axis, and its two-torsion is the system used by the
relative principal-kernel packet.  The intervening twist
`(T+27)(T-729/5)` does not alter two-torsion.

## Boundary and stack correction

The compact sign curve is genus zero with cusp widths `2,6` and two
order-three elliptic points.  Its coarse map ramifies at the two cusps and
nowhere else.  The cubic family has four unmarked boundary values:

| `T` | meaning |
|---|---|
| `0` | modular cusp; ten singular cubic points |
| `infinity` | modular cusp; six singular cubic points |
| `-27` | modular interior order-three point; five cubic `A_2` points |
| `729/5` | ordinary modular interior point; chordal cubic |

Accordingly the abstract signed parameter line compactifies to the sign
modular curve, but the cubic family does not become a modular family at the
two additional interior degenerations.  This is the paper's principal scope
brake.

## Hostile mathematical read

The cold read found and repaired four issues before closeout:

1. the first draft misread VGY's auxiliary `a,b` as coefficients of a simple
   elliptic cubic; the source and checker now use the actual generalized
   Weierstrass coefficients from Proposition 3.2;
2. equality of the two sign-torsor classes is canonical, but a sheetwise
   identification has two deck-related choices;
3. the polarized Prym/axis comparison is stated only on the common marked
   smooth `A_5/D_5` open;
4. the modular compactification is separated from extension of the cubic or
   intermediate-Jacobian family across its boundary.

The final pass also supplies a cheap strengthening left open by C935: the
actual geometric mod-two image is **equal** to `A_3`, not merely contained in
it.  The sign subgroup maps onto `A_3`, and a loop about a deleted lift of the
order-three point `T=-27` acts by a three-cycle.

## Reproducibility and build

`make check` passes.  It performs TeX spacing lint, replays the exact SymPy
certificate, checks a separate finite enumeration of the level-six
subgroups, verifies the SHA-256 manifest, builds the manuscript, and rejects
TeX warnings.  The deterministic PDF is seven pages and was inspected as
rendered pages as well as extracted text.

The symbolic certificate checks the VGY `j`-invariant, `T=81t^2`, the Tate
discriminant, the two-division discriminant, the root map, and the full split
map.  The independent subgroup script enumerates the 36 elements of the
`Gamma_0(3)` image modulo six and verifies quotient indices `2,3,6`, the
`Gamma_0(6)` point stabilizer, and the common split kernel.

Paper commits:

- `c85a8cf75` — manuscript, PDF, claim ledger, and evidence bundle;
- `9ea876024` — exact `A_3` monodromy strengthening.

## Literature record and priority boundary

Four external sources are cited and were read at claim-specific partial
depth; zero were counted as full-text reads.

- van Geemen--Yamauchi, arXiv:1506.05346v3, Propositions 2.1, 3.1, and 3.2;
  cache SHA-256
  `f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed`.
  These provide the intermediate-Jacobian Prym and explicit elliptic quotient.
- Roulleau, arXiv:1002.4467v1, Theorem 11(D), Lemma 17, and the `A_5` pencil
  discussion; cache SHA-256
  `c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd`.
- Hartlieb, arXiv:2304.03214, Section 5, especially Lemma 5.5,
  Proposition 5.7, and Remark 5.8; cache SHA-256
  `3e6e55c0277b44fadbcbea8cd9f1d4501d307caaab6d6fd5314af36c0b49ab01`.
- Looijenga--Zi, arXiv:2109.01810v2, introduction, Theorem 1.1, Proposition
  5.1, and Theorem 5.2; cache SHA-256
  `d49c591df00b53d11cf9f763007fa800935503d732ee745e5509bbd909adf5f1`.
  This is explicitly treated as a related Winger-pencil result, not as the
  source of the cubic base comparison.

The following exact web searches were also run on 2026-08-21:

```text
"A5" cubic threefold "X_0(3)" modular curve
cubic threefold elliptic 2-division discriminant resolvent gluing
nonstandard A5 cubic pencil modular curve elliptic factor
A5 cubic threefold exotic gluing F4
```

They located no direct predecessor for the combined actual-kernel resolvent
statement.  This bounded search is not a priority proof, and the paper makes
no claim that the classical ingredients are new.  Its contribution is stated
as their identification with this specific relative principal-gluing packet.

## EJ + TT closeout and mystery ledger

**EJ settled.**  The modular identification upgrades C935's containment
`rho_2(pi_1) subset A_3` to equality: the deleted order-three point prints an
actual three-cycle.  A fresh post-close EJ pass then extracts two further
free consequences: golden orientation cyclicizes the rational three-packet,
so the degree-three pullback is already the full splitting cover, and the
signed cubic coordinate is the eta quotient
`3(eta(3tau)/eta(tau))^6`.  In the reciprocal Hauptmodul `h`, the two interior
cubic boundary values are exactly `-27` and `5`.  Both consequences are now
in the paper and its replay bundle.

**TT correction settled.**  The signed compact parameter line and the sign
modular curve are isomorphic as curves, but the smooth cubic base is a smaller
open and its family does not extend across the two modular-interior cubic
degenerations.  The paper also retains the two-choice deck ambiguity.  A fresh
post-close TT pass found one genuine proof seam: the printed `X_0(6)` rational
map had not been explicitly tied to a root of the printed two-division cubic.
The paper and exact checker now substitute

```text
T = -(4y+3)(y+3)^2/(y+1)^2,      x = -4y^4/(y+1)^2
```

and verify the cubic vanishes.  The same pass prints the normalized Cartesian
resolvent square, proves the root and split cusp passports
`(1,2,3,6)` and `(2,2,2,6,6,6)`, and notes that the quadratic twist preserves
the cyclic order-three subgroup even when it does not preserve a chosen
generator.  These repairs make the `Gamma_0(3)` rather than `Gamma_1(3)` level
claim and every arrow in the square locally auditable.

**Mysteries still open.**

- A preferred geometric golden orientation might choose between `r=9t` and
  `r=-9t`; the unordered kernel theorem does not.
- Extending the actual polarized Prym/axis comparison across the cusps would
  require a semiabelian or logarithmic Prym theorem and is not used here.
- A specialist citation-graph audit could support a formal priority claim;
  the present bounded search deliberately does not.

No discovery-track entry was added: the exact `A_3` strengthening and all
boundary corrections are direct closeout consequences of the requested
companion.
