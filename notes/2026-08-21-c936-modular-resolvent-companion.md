# C936 — Modular resolvent companion

**Date:** 2026-08-21

**Status:** complete; eight-page local paper, evidence bundle, and cold read

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
TeX warnings.  The deterministic PDF is eight pages and was inspected as
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

A second TT pass asks for the full local monodromy tuple on the signed cubic
line.  It is rigid: with `a^2=-3`, the split coordinate satisfies

```text
r^2+27 = (v^2+3)^3/(v^2-1)^2,
(r-3a)/(r+3a) = ((v-a)/(v+a))^3.
```

Hence the cyclic cubic cover is totally ramified only over the two
`T=-27` points, exactly the fibres with five `A_2` singularities.  It is
unramified at both modular cusps and both chordal points.  The two nontrivial
local monodromies are inverse three-cycles.  The paper now promotes this to a
theorem clause and Kummer-normal-form corollary, with exact replay.  This
settles the previously implicit question of where the exact `A_3` image is
generated.

The third TT pass removes the remaining abstraction from that `C_3` action.
It is defined over the rational signed function field and generated by

```text
sigma(v) = (v-3)/(v+1),
sigma^2(v) = -(v+3)/(v-1),
sigma^3(v) = v.
```

Direct substitution gives `r(sigma(v))=r(v)`; its fixed points are exactly
`v^2=-3`.  Golden reversal is `(r,v)->(-r,-v)` and satisfies
`-sigma(-v)=sigma^{-1}(v)`.  Thus choosing a golden orientation not only
reduces the group to `A_3`: it chooses a cyclic direction on the rational
three-packet, while reversing the golden orientation reverses that direction.

**Mystery ledger.**

- **Settled in the reopened pass:** chordal transversality needs no new
  parametrization of the singular quartic.  One (C_5)-eigenline generates a
  twelve-point (A_5)-orbit in (Q=0); the quadratic-ideal ranks prove
  (Q|_C\ne0), and orbit size equals
  \(\deg\mathcal O_C(3)=12\).  Symmetry and degree therefore force the whole
  reduced transverse divisor.

- **Open:** a preferred geometric golden orientation might choose between `r=9t` and
  `r=-9t`; the unordered kernel theorem does not.  Once either convention is
  chosen, the resulting cyclic generator and its inversion under golden
  reversal are now explicit.
- **Open:** extending the actual polarized Prym/axis comparison across the cusps would
  require a semiabelian or logarithmic Prym theorem and is not used here.
- **Open:** a specialist citation-graph audit could support a formal priority claim;
  the present bounded search deliberately does not.
- **Successor question:** the orbit-saturation argument applies whenever a
  symmetric chordal degeneration supplies an orbit whose size equals the
  degree of the transverse section.  Classifying other cubic pencils for
  which this equality occurs is not needed here and remains unallocated.

No discovery-track entry was added: the exact `A_3` strengthening and all
boundary corrections are direct closeout consequences of the requested
companion.

## Reopened mathematical supplement

> **Post-red-team resolution (2026-08-21).**  The chordal condition raised by
> the two-round review is discharged.  The tracked certificate constructs a
> twelve-point \(A_5\)-orbit on the singular rational normal quartic, recovers
> its six-dimensional quadratic ideal, and proves that adjoining the actual
> transverse term \(Q\) raises the degree-three ideal rank from 22 to 23.
> Hence \(Q|_C\neq0\), and its twelve known orbit zeros form the complete
> reduced degree-twelve branch divisor.  The unconditional proof and
> literature boundary are recorded in
> `2026-08-21-c936-resolvent-rigidity-package-memo.md`.

The reopened pass checked literature before treating each question.  It
settles two of the paper's mysteries, sharpens four others, and separates
three genuine open gates from attractive but false extrapolations.

### New theorem: the chordal value `h=5`

The chordal value is not a numerical accident.  General chordal degeneration
theory identifies the limit intermediate Jacobian with the Jacobian of the
double cover of the singular rational normal curve branched over the twelve
points selected by the deformation direction.  In the present pencil that
divisor is `A_5`-invariant, hence is the unique icosahedral orbit of length
twelve.  In a standard coordinate the limit curve is

```text
C_ico: w^2 = x(x^10 + 11x^5 - 1).
```

Paulhus's Theorem 2 gives

```text
J(C_ico) ~ E_ico^5,
E_ico: y^2 = x(x^2 + 11x - 1).
```

For this elliptic curve, `c4=1984=2^6*31` and
`Delta=2000=2^4*5^3`, so

```text
j(E_ico) = 2^14*31^3/5^3 = J(729/5).
```

Thus the smooth norm-axis period lands on exactly the elliptic isogeny factor
of the hyperelliptic chordal limit.  This theorem and its proof are now in the
paper.

### New theorem: why two is exceptional

For any prime `ell` and two-dimensional `F_ell`-space `V`, put
`G=PGL(V)`.  Orbit-stabilizer gives

```text
P^1(F_{ell^2}) = G/B  disjoint union  G/C_ns,
```

where `B` is a Borel and `C_ns` a nonsplit Cartan.  Frobenius pairs the
nonrational points, and the quotient by Frobenius is `G/N_ns`.  At
`ell=2`, `N_ns=G` and `C_ns=A_3`; therefore the whole nonsplit orbit is
the degree-two sign cover.  For `ell>2` its degree is `ell(ell-1)`, so no
analogous discriminant pair exists.  This places the paper's `3+2` packet
inside the standard Borel/nonsplit-Cartan geometry and is now stated in the
paper.

Choosing one exotic sheet is equivalently choosing one of the two
`F_4`-eigenlines.  It equips `V` with an `F_4`-module structure and
identifies the surviving monodromy

```text
A_3 = C_3 = F_4^times.
```

Golden reversal is Frobenius on `F_4`, hence inversion on this cyclic group.
This explains the rational formula
`-sigma(-v)=sigma^{-1}(v)` conceptually.

### Status of the other questions

1. **Picard--Lefschetz source of the three-cycle: partly settled.**  An
   `A_2` singularity has a rank-two vanishing lattice and Coxeter monodromy
   of order three.  At a five-`A_2` fibre the five local Coxeter blocks
   commute, and the actual-axis comparison sends their product to the
   nontrivial order-three element on the elliptic norm axis.  This explains
   the modular three-cycle geometrically.  Still open is a cubic-only proof
   that computes the norm-axis projection of the five local blocks without
   passing through the elliptic comparison.

2. **Meaning of `sigma`: settled at the correct level.**  The map
   `sigma(v)=(v-3)/(v+1)` is the modular deck transformation cyclically
   relabelling the three nonzero two-torsion points.  Through the principal
   packet it cyclically relabels the three rational maximal isotropic kernels.
   Their quotients are points of the Siegel `2`-Hecke correspondence.  This
   does not produce a fibrewise automorphism of the cubic or prove that the
   quotient ppav's are intermediate Jacobians of cubic threefolds.  The latter
   is a genuine Schottky-type open question.

3. **Preferred golden orientation: negative over the unmarked rational
   base.**  The outer normalizer and golden Galois conjugation exchange the
   two sheets.  Therefore no construction equivariant for that normalizer can
   choose between `r=9t` and `r=-9t`.  A choice becomes canonical only
   after adding an oriented icosahedral realization, equivalently a real
   embedding of `Q(sqrt(5))).  The two-choice ambiguity is structural.

4. **Boundary extension: general theory exists, but the pencilwise comparison
   is incomplete.**  Toroidal Prym and intermediate-Jacobian extension
   theorems cover the general framework.  In this pencil the two modular cusps
   should carry toric degeneration; the five-`A_2` values have finite
   order-three monodromy and potential good reduction; the chordal value has
   the hyperelliptic abelian limit proved above.  Extending the actual
   polarized Prym/norm-axis isomorphism, including its kernel and
   polarization, through all four fibres remains open.

5. **The full `S_3)-torsor: geometrically realized, with a boundary.**  The
   ordered nonzero two-torsion torsor is already the common splitting cover.
   Extension of structure group along the nontransitive embedding
   `S_3 < A_5` recovers the five-set with orbit pattern `3+2`, but its
   monodromy remains `S_3`.  Hence there is a canonical reducible quintic
   etale algebra, not an irreducible `A_5)-quintic.  Klein's irreducible
   icosahedral quintic resolvents require a genuine `A_5)-extension and do
   not arise from this torsor alone.

6. **Internal versus external cubic Kummer covers: no hidden equality.**  Over
   a field containing `mu_3`, cyclic cubic covers are classes in
   `K^times/K^{times 3}`.  The internal class
   `(r-3a)/(r+3a)` has zero valuation in an independent external parameter,
   while the class of `q` has valuation one.  They are therefore independent
   and the extensions are linearly disjoint.  The common group `C_3` is
   useful for normalization but does not identify the covers.

7. **Direct Picard--Fuchs derivation: exact target, still open from the
   six-variable cubic.**  With
   `h=(eta(tau)/eta(3tau))^12`, the normalized level-three elliptic period
   satisfies

   ```text
   [theta_h^2 + (h/27)(theta_h+1/3)^2] Pi = 0.
   ```

   Equivalently its singularities are the two cusps `h=0,infinity` and the
   order-three point `h=-27`.  A Griffiths--Dwork calculation followed by
   the `A_5` norm-axis projector should extract this rank-two factor directly
   from the cubic Gauss--Manin system.  That calculation would make the cubic
   base comparison independent of the Prym quotient.

8. **The primes `2,3,5`: not yet one arithmetic theorem.**  Two controls the
   gluing resolvent, three the modular level and Coxeter monodromy, and five
   the icosahedral/golden symmetry.  Calling these the complete bad primes
   would require an integral model and reduction analysis.  No such claim is
   made.

## Supplemental literature record

This supplement names six new load-bearing sources; zero were read at full
text.  Each was read at the indicated partial depth.  The searches below were
discovery and attribution checks, not a priority audit, and no absence-of-prior-
work claim rests on them.

- Casalaina-Martin--Grushevsky--Hulek--Laza,
  arXiv:1510.08891v2, **partial**: introduction, Sections 3 and 5, especially
  the chordal hyperelliptic extension and the admissible-cover setup.  Cache
  SHA-256
  `d5b3c69094eee70d5486542952f394308e3aa4bdbc5762a85588ebae4b2d7753`.
- Allcock--Carlson--Toledo, arXiv:math/0608287 and the published Memoirs
  pagination, **partial**: the introduction and the chordal-discriminant
  discussion, especially the criterion that a cubic direction is transverse
  to the chordal locus exactly when its restriction to the singular rational
  normal quartic is nonzero.  Cache SHA-256
  `a2b455c771d3bf3d9e69cd85bb672e86b57fa2d60bb3815abd577b592f1afe21`.
- Rebolledo--Wuthrich, arXiv:1402.3498v2, **partial**: introduction and
  Section 2's nonsplit-Cartan/necklace moduli interpretation.  Cache SHA-256
  `10cee9475c4fc778526ef1d0c11bb8e73647b2305eb7897d7613ee7ca545eaed`.
- Sevilla--Shaska, arXiv:1209.1868v1, **partial**: Sections 2--3, including
  the degree-twelve icosahedral orbit polynomial.  Cache SHA-256
  `a7ce73ad611995ba7633cdccbaee714ee37b22fbc7956ae5e0dc3166f0dfbbe3`.
- Maier, arXiv:math/0611041v4, **partial**: Theorem 5.4, Section 7, and
  Table 15 for the `Gamma_0(3)` Picard--Fuchs equation.  Cache SHA-256
  `ca51653bb995355b0191fb0acc04a72f742e08ca67873f7e84a036bacf81ead5`.
- Paulhus, doi:10.2140/obs.2013.1.487, **partial**: Theorem 2 and its proof.
  Cache SHA-256
  `d45781c71c6f655acb795fbfb3d79402f39965ee75c2739aaff1432d549b0261`.
  The author's errata was also checked at **partial** depth: it corrects
  Theorem 1 and portions of the summary table, not Theorem 2.  The fetched
  errata bytes had SHA-256
  `278f15c4ab3ea4483f30af1942d39934bc5ea890cf0e2093b54779c6a48407ba`;
  the host's TLS chain could not be verified, so this errata access is recorded
  as a coverage caveat rather than cached evidence.

The topic-by-topic web queries were:

- chordal reconstruction: `icosahedral orbit 12 points rational normal
  quartic quadrics ideal chordal cubic threefold`; `chordal cubic threefold
  12 branch points rational normal quartic deformation intermediate
  Jacobian`; `binary icosahedral invariant degree 12 rational normal quartic
  A5 orbit`.  The search stopped after recovering the primary
  Allcock--Carlson--Toledo transversality criterion and finding no competing
  formulation of the paper-specific embedded-orbit reconstruction claim;
  this bounded stop is not a priority verdict.
- Picard--Lefschetz: `cubic threefold five A2 singularities monodromy
  Picard Lefschetz A5 pencil`; `A2 singularity Picard Lefschetz monodromy
  order 3 vanishing cycles`; `icosahedral A5 cubic threefold pencil five A2
  monodromy`.
- deck action and orientation: `X(2) X0(3) deck transformation v ->
  (v-3)/(v+1)`; `modular curve Gamma0(3) intersection Gamma(2)
  Hauptmodul automorphism order 3`; `A5 outer automorphism golden ratio
  conjugation icosahedron orientation`.
- boundary and chordal limit: `degeneration Prym varieties admissible double
  covers semiabelian compactification Beauville`; `cubic threefold
  intermediate Jacobian degeneration A2 singularity semiabelian Prym`;
  `chordal cubic threefold limit intermediate Jacobian hyperelliptic genus
  5`; `Jacobian y^2=x(x^10+11x^5-1) decomposition elliptic curve`.
- Hecke, Kummer, and quintic: `principally polarized abelian variety maximal
  isotropic 2 torsion Hecke correspondence`; `Kummer extensions linear
  disjoint valuations cyclic cubic criterion`; `S3 subgroup A5 orbit
  decomposition 3 2 quintic resolvent`.
- general prime and differential equation: `P1(F_p2) decomposition P1(F_p)
  complement PGL2(F_p) action nonsplit Cartan`; `A5 cubic threefold pencil
  Picard Fuchs equation`; `elliptic modular curve X0(3) Picard Fuchs
  equation eta Hauptmodul`.

## Refreshed mystery ledger

- **Settled:** the chordal `h=5` value is the elliptic factor of the
  icosahedral hyperelliptic limit.
- **Settled:** the embedded twelve-point branch orbit recovers the singular
  rational normal quartic by its quadrics, its secant chordal cubic, and the
  projective first-order normal direction.  This is stronger than the
  transversality check needed for the limit theorem.
- **Settled:** that normal direction is the unique (A_5)-fixed point of the
  projectivized normal space.  Thus the first-order hyperelliptic boundary
  limit is forced for every (A_5)-invariant transverse deformation of this
  chordal cubic, not just for the displayed pencil.
- **Settled:** the `A_3=F_4^times` coincidence is the nonsplit-Cartan
  structure selected by a golden sheet.
- **Settled negatively:** no unmarked rational construction can prefer one
  golden orientation.
- **Settled negatively:** the `S_3`-torsor does not by itself create an
  irreducible `A_5`-quintic, and the internal and external Kummer cubics are
  not the same cover.
- **Open:** a direct cubic Picard--Lefschetz computation of the norm-axis
  three-cycle.
- **Open:** extension of the polarized actual-axis comparison through all
  four boundary fibres.
- **Open:** a direct Griffiths--Dwork derivation of the level-three
  Picard--Fuchs factor from the cubic equation.
- **Open:** whether any of the fivefold `2`-Hecke quotients are again
  intermediate Jacobians of cubic threefolds.

## Cold-referee repair

The isolated van Geemen-lens report
`2026-08-21-c936-van-geemen-cold-referee.md` found one fatal and two major
gaps.  The revision closes all three.

1. **Actual-axis comparison.**  The paper now constructs the map from the
   quotient Prym to the intermediate Jacobian.  Pullback/norm and the factor
   two in the principal polarization of an étale double-cover Prym give
   `phi^*Xi=5Xi_0`.  The already-proved six-axis diagonal entry gives
   `i^*Xi=5lambda_E`.  Factoring through the unique dihedral fixed axis,
   cancelling five in the torsion-free symmetric Hom group, and taking
   degrees proves that the intervening elliptic isogeny has degree one.  The
   generic isomorphism extends over the regular smooth base by the Néron
   mapping property.
2. **Coordinate and twist bridges.**  A displayed Fourier transform of the
   six coordinates gives the van Geemen--Yamauchi normal form with `u=ct`,
   `c^2=5`.  An invariant `c4,c6` ratio proves that the remaining quadratic
   twist has square class `(T+27)(T-729/5)`.  The exact checker now verifies
   both calculations.
3. **Programme input.**  A separate proposition now distinguishes the
   five-sheet packet of candidate stable halves from the single actual
   kernel section selecting an exotic sheet.
4. **Chordal identification.**  At `ct=-3`, the Fourier equation is four
   times a displayed Hankel catalecticant.  Its reduced singular locus is the
   rank-one Hankel rational normal quartic and the cubic is its secant
   variety.  This is a direct human proof; the checker verifies the exact
   determinant identity.  The stronger request that the Jacobian singular
   scheme equal the reduced quartic would be false: the five gradient
   quadrics span a proper subspace of the six-dimensional quadratic ideal of
   a rational normal quartic.  The degeneration theorem needs the reduced
   singular curve, which is what the revision proves.
5. **Boundary corollary and terminology.**  The proof now invokes the
   equivariant normal quotient from published Allcock--Carlson--Toledo
   Lemma 2.5, the perfection of `A_5`, and the orbit sizes `12,20,30,60`.
   The VGY coefficient attribution and stack/coarse terminology are also
   corrected, and the finite-set checker tests the two restricted parities
   separately.

The updated evidence files are deterministic:

- `verification/resolvent_identities.py`: 9,552 bytes, SHA-256
  `ac3f6f808136a9e7ad39a4d936597b97e86bf2f9567a36469fc43dc4f4f3d995`;
- `verification/resolvent-identities.txt`: 829 bytes, SHA-256
  `b92b7e7f0c3931abba263f474f6df4ebeb0027e5868e8ec6b20a9cdd987fad5c`.

Replay from `papers/cubic-gluing-resolvent/` with `make check`.  The Fourier
calculation is independently recoverable from the displayed seven
coefficients in the paper, and the degree-one step is independently checked
by the two polarization identities and their degree comparison; neither
claim rests only on the symbolic execution.

The resumed cold repair audit returns **Accept** at confidence `0.94`, with
every fatal, major, and numbered minor finding closed.  Its remaining abstract
wording suggestion and optional full-support assertion were then implemented:
the abstract now says “five-sheet packet of stable principal gluing
kernels,” and the Fourier checker proves that no cubic monomial outside the
seven displayed invariant monomials occurs.

## Final exposition pass

The style-guide pass reduces the abstract to one 142-source-word paragraph.
It retains only the packet theorem, the modular realization, the cyclic
oriented pullback, and the boundary consequence.  A compact strategy paragraph
after the main theorem now marks the finite-set, actual-axis, modular-inertia,
and chordal stages; the higher-prime extension is a named skippable remark;
Sections 3 and 4 state their language changes before beginning the formulas;
and the conclusion ends on the root--discriminant relation rather than a list
of ingredients.  No theorem, hypothesis, equation, citation, or evidence
boundary changed.

## Standalone export

The paper is registered as `cubic-gluing-resolvent` and exported from
authority commit `b4006aa046ddff9f77b9d6d9a24d080f84df17b0` to
`~/src/math-papers/cubic-gluing-resolvent`.  The standalone repository begins
at commit `92a7d79` and carries the manuscript, PDF, exact verification bundle,
export manifest, provenance record, public README, CC BY 4.0 license, and the
same pinned manuscript toolchain as the authority.

The exporter audit reports zero findings, standalone `make check` passes, and
the exporter verifies all seventeen tracked files.  The rebuilt authority and
standalone PDFs have the same SHA-256 digest
`90fac5468adadb9510f60eb7b2c8083fe3a62dc85984212a9242c44ba6dd0e7c`.
An initial unpinned materialization rebuilt a different PDF byte stream; it was
moved intact to
`/tmp/persistent/tavis/export-rejected/cubic-gluing-resolvent-unpinned-20260821`
and replaced by the pinned, byte-identical export.
