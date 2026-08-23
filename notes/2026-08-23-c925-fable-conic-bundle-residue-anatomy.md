# Anatomy of the conic-bundle residue: over P^2 the smooth-discriminant case is exactly the MM 2-24 family, and the open frontier is nodal rational discriminants

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

Scopes class (a) of the carrier structure theorem
(`2026-08-23-c925-fable-carrier-mmp-reduction.md` §2.2): relatively
minimal conic bundles \(V\to S\) with \(\Delta\ne\emptyset\), \(q(S)=0\),
and \(b_3(V)=0\).  The aim is to identify the actual test objects for the
Prym-counting prediction before spending computation on them.

## 1. Minimality forces the cover to be irreducible componentwise

For a conic bundle \(V\to S\) (\(V\), \(S\) smooth, every fibre a plane
conic) with discriminant \(\Delta\), the curve \(\widetilde\Delta\)
parametrizing the lines of the degenerate fibres is a double cover of
\(\Delta\).  If the cover splits over some irreducible component
\(\Delta_i\) — in particular whenever \(\Delta_i\) is smooth and simply
connected, since the cover is étale over the smooth locus — then the two
line families over \(\Delta_i\) are globally distinguished and one of them
can be contracted over \(S\): \(V\to S\) is not relatively minimal
(\(\rho(V/S)\ge2\)).  Contrapositive: **for a relatively minimal conic
bundle, the cover is irreducible over every component of \(\Delta\)**, so
every smooth component satisfies \(\pi_1\ne1\), i.e. has genus \(\ge1\).
(Classical; see Sarkisov's standard-model theory or Prokhorov's conic
bundle survey.  The split-cover contraction is the same move that makes
degree \(\le2\) discriminants non-minimal.)

## 2. Vanishing b3 with smooth discriminant: genus at most one

For a standard conic bundle over a rational surface with \(\Delta\)
smooth, \(H^3(V)\) is the anti-invariant part of \(H^1(\widetilde\Delta)\)
and the intermediate Jacobian is \(\mathrm{Prym}(\widetilde\Delta/\Delta)\)
(Beauville, *Variétés de Prym et jacobiennes intermédiaires*, 1977), of
dimension \(g(\Delta)-1\) for a connected étale double cover.  So
\(b_3(V)=0\) with \(\Delta\) smooth and the cover irreducible forces
\(g(\Delta)\le1\); genus \(0\) is excluded by §1 (simply connected), so
\(g(\Delta)=1\).

**Over \(S=\mathbf P^2\)** this pins the smooth-discriminant case
completely: \(\Delta\) is a smooth plane cubic and the cover is one of its
three nontrivial étale double covers — and that is precisely the MM 2-24
geometry, already ledger-closed unconditionally by the projective-bundle
route.  Degrees \(1\) and \(2\) admit **no** relatively minimal conic
bundle at all (line, smooth conic, and line pairs and double lines are
simply connected or split for other reasons), and smooth degree \(\ge4\)
has \(g\ge3\), hence \(b_3\ge4\): outside the tail.  Whether every smooth
member of the abstract conic-bundle family with \((\Delta,\text{cover})\)
data of degree 3 is isomorphic (not just birational) to a \((1,2)\)
divisor is not needed: any relatively minimal standard conic bundle over
\(\mathbf P^2\) with \(d=3\) is a smooth Fano threefold of the 2-24
deformation type by the classification, and the enumeration closes the
whole family.

## 3. The open frontier: nodal rational discriminants

The one way to keep \(b_3=0\) with \(\deg\Delta\ge4\) is singular
\(\Delta\): for admissible covers of nodal curves the Prym acquires a
multiplicative (torus) part from the cycles, which contributes to
\(H^3\)-adjacent weight-one data but not to the abelian part; a nodal
\(\Delta\) whose components all have geometric genus \(0\), with the cover
irreducible thanks to monodromy around the node cycles, can have
vanishing abelian Prym while remaining relatively minimal.  The smallest
such candidate over \(\mathbf P^2\) compatible with §1 and the Fano bound
(the Fano conic bundles over \(\mathbf P^2\) all have \(d\le3\)) is a
**nodal quintic of geometric genus zero** (or a suitable nodal quartic if
the cover data permit — the quartic case needs the same check and is not
excluded here).  These are the genuine test objects for the
Prym-counting prediction:

> on a relatively minimal conic bundle with vanishing abelian Prym, the
> quantum ledger contains no \(\{1/6,5/6\}\) block.

Caveats recorded rather than assumed: (i) the nodal-Prym dimension
bookkeeping above (abelian vs multiplicative part, admissible-cover
conventions at the nodes where the fibre is a double line) must be
verified against Beauville's admissible-cover formalism before any object
is declared \(b_3=0\); (ii) smoothness of the total space over the nodes
constrains the local cover data; (iii) whether such a \(V\) can actually
occur as a telescope carrier is a separate (and skippable) question — the
uniform statement is what (GS-carrier) wants.

## 4. Computation plan (queued, not run)

1. Settle (i)–(ii) from Beauville and write down one explicit smooth
   relatively minimal \(V\to\mathbf P^2\) with nodal rational
   discriminant of degree 4 or 5 and \(b_3=0\), e.g. inside
   \(\mathbf P(\mathcal E)\) for a rank-3 bundle \(\mathcal E\) with a
   symmetric map \(\mathcal E\to\mathcal E^\vee\otimes L\) of the right
   degeneracy type.
2. Its small quantum data: \(V\) is a divisor in the toric or
   split-bundle ambient \(\mathbf P(\mathcal E)\), so the two-parameter
   quantum-Lefschetz \(I\)-function applies; expect (from the MM 2-24
   experience) a non-étale ambient algebra with a fat eigenvalue-0 part —
   the informative output is the reduced nonzero spectrum and, if the
   discovery-track lead holds (excess at eigenvalue 0 with multiplicity
   \(\dim\ker i^*\)), a lower bound on the semisimple part.
3. In parallel, the \(b_3\ne0\) side of the same family (smooth quintic
   discriminant: the cubic threefold blown up, or the generic quintic
   conic bundle) calibrates the marked-block count against
   \(\dim\mathrm{Prym}\) — the dictionary predicts marked blocks appear
   only through cubic-type Prym factors, and the quintic conic bundle
   which IS the cubic threefold (blown up along a line) must show exactly
   one.

## Mystery ledger (EJ+TT closeout, 2026-08-23)

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | Relative minimality forces irreducible covers componentwise; smooth simply connected discriminant components are impossible. | §1, classical contraction move. |
| settled | Over \(\mathbf P^2\), smooth-discriminant members of class (a) are exactly the MM 2-24 family (closed); \(d\le2\) is empty; smooth \(d\ge4\) has \(b_3\ge4\). | §2, Beauville + §1. |
| open, sharpened | Class (a) over \(\mathbf P^2\) = nodal rational discriminants (\(d=4,5\) first candidates) with irreducible covers and vanishing abelian Prym; nodal-Prym bookkeeping must be verified before construction. | §3 caveats (i)–(ii). |
| open | Non-rational \(q=0\) bases (Enriques sliver) untouched by this note. | carried from the structure theorem. |
| queued | Explicit \(d=4/5\) construction + ambient \(I\)-function spectrum; quintic-discriminant calibration on the blown-up cubic. | §4 plan. |

No manufactured mysteries: class (a) over rational bases is now a
one-parameter-family-sized target, not a wilderness.
