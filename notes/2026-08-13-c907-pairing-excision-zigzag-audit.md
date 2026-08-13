# C907 pairing excision: the compact/ordinary zigzag

**Lane:** `clebsch`  
**Verdict:** four-point support for the compact (`j_!`) value cycles does
**not** by itself determine the directed Seifert package.  It does give the
full package after one precise, self-dual exterior-excision assertion and an
identification of the *central Lefschetz pair*, not merely of the formula or
four Morse germs.

This records the directions of the relevant maps.  They matter: compact
excision and ordinary restriction point in opposite directions.

## 1. Global and bounded objects

Let `a:U -> B=Delta x Omega` be the original open map, with `Omega` a closed
value disk, and put `A=Z[1/6]`.  Choose a bounded residual neighbourhood
`V=U intersect N` whose closure lies over `B`; it contains the four residual
sections in its interior and no value-critical point on its artificial tube
boundary.  Write

\[
 K_!=Ra_!A_U,\qquad K_*=Ra_*A_U,
 \qquad
 K^V_!=R(a|_V)_!A_V,\qquad K^V_*=R(a|_V)_*A_V .                 \tag{1}
\]

Equivalently, after a proper actual-open compactification `j:U -> X` of
`a`,

\[
 K_!=R\bar a_*j_!A_U,\qquad K_*=R\bar a_*Rj_*A_U.              \tag{2}
\]

For the open inclusion `v:V -> U`, functoriality supplies the two maps

\[
 e_!:K^V_!=Ra_!v_!A_V\longrightarrow K_!,
 \qquad
 r_*:K_*\longrightarrow K^V_*=Ra_*Rv_*A_V .                    \tag{3}
\]

The first is extension by zero and the second is restriction/ordinary
extension.  Hence there is no canonical same-direction map from the global
compact/ordinary arrow to the bounded compact/ordinary arrow.  Instead the
natural `can` arrow forms the commutative zigzag

\[
 K^V_!\xrightarrow{e_!}K_!\xrightarrow{\rm can}K_*
 \xrightarrow{r_*}K^V_*,
 \qquad
 r_*\,{\rm can}\,e_!={\rm can}_V .                             \tag{4}
\]

The analogous assertion holds for `var`, after its fixed monodromy and
shift convention.  It is this zigzag, rather than a rank equality, that
remembers the relative boundary condition used by the Seifert form.

## 2. The exact exterior condition

Put

\[
 C_!=\operatorname{Cone}(e_!),\qquad
 C_*=\operatorname{Cone}(r_*),\qquad
 \Psi_u=\psi_\delta\phi_{L-u}.                                  \tag{5}
\]

The sharp residual-excision condition is

\[
 \Psi_uC_!=0\quad\hbox{and}\quad\Psi_uC_*=0
 \quad(u\in\Omega),                                             \tag{6}
\]

with the two zeroes compatible with (4).  It makes both arrows in (3)
isomorphisms after `Psi_u`; conjugating (4) then identifies the global
compact/ordinary `can/var` diagram with the bounded one.

The two zeroes are not normally independent.  If the actual-boundary
stratification makes (3) a Verdier-dual pair, then, up to the fixed dimension
shift and orientation twist,

\[
 D_B(C_!)\simeq C_*[-1].                                         \tag{7}
\]

Proper duality and the duality compatibility of nearby and vanishing cycles
therefore carry `Psi_u C_!=0` to `Psi_u C_*=0`.  This use of duality requires
the coefficient self-duality, constructibility of both `j_!A` and `Rj_*A`,
and a controlled tube/exterior decomposition.  A tangent/Fitting certificate
only for `j_!A` does not by itself establish (7), nor does it prove that no
cycle is born at the artificial tube boundary.

Thus the landed statement

\[
 \operatorname{Supp}\Psi_u(j_!A)\subset\{\text{four residual lifts}\}
 \tag{8}
\]

is enough for compact rank after the local Morse calculation, but it becomes
pairing-level excision only after it is promoted to the cone statement (6)
(or to the `!` statement together with the duality data in (7)).

## 3. Conditional directed-pairing theorem

Assume all of the following.

1. The self-dual cone condition (6) holds over the value disk, and is
   compatible with `can`, `var`, and proper direct image.
2. At `delta=0`, the **bounded compact/ordinary Lefschetz pair** in (1), not
   just its interior function, is identified with the pair for
   \[
   f_Q(y)+ZW.                                                     \tag{9}
   \]
   In particular it identifies the `j_! -> Rj_*` boundary map and the
   Poincare--Verdier normalization.
3. The four central critical points are nondegenerate, their values remain
   distinct in `Omega`, and there is no boundary-value singularity.  Fix a
   regular boundary value, an ordered nonbraiding path star, one `can/var`
   convention, and the complex orientation (with the transverse quadratic
   thimble normalized to self-Seifert value `+1`).

Then the intrinsic global iterated value-cycle diagram is isomorphic to the
bounded residual diagram as a compact/ordinary, duality, `can/var` package.
Parameterized Morse transport over the contractible parameter disk preserves
the ordered generators and all Seifert entries.  Thom--Sebastiani at (9)
therefore gives the full residual directed `P^3` Seifert package, not only a
rank-four lattice.

## 4. Exact obstruction to the shorter inference

Neither (8) nor the equality of the central *interior* potential with
`f_Q+ZW` supplies item 1 or item 2.  Verdier duality pairs `Ra_!` with
`Ra_*`; it does not make the compact object self-dual, choose a relative
boundary map, or select an ordered oriented thimble basis.  A Hurwitz move
preserves the proper family, the four local `A_1` groups, and their support,
while changing the labelled Seifert matrix.  Consequently the ordinary
exterior cone (or its duality identification) and the full central
compact/ordinary-pair comparison are the irreducible missing data.

No common global collar is required once these two assertions are supplied.

## EJ/TT ledger

- **EJ:** the remaining topology is one self-dual cone vanishing plus one
  oriented central pair identification; it is not another fan calculation.
- **TT:** compact and ordinary localisation run in opposite directions.
  Treating them as one restriction map silently loses the Seifert boundary
  condition.
- **Settled:** support/local Morse theory gives the rank-four compact object.
- **Open:** dual-compatible exterior cone acyclicity, the central pair map,
  and the fixed orientation/path normalization.
