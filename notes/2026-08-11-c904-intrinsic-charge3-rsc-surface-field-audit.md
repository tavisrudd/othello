# C904: intrinsic charge-three curves over the support-surface fields

Date: 2026-08-11

Status: exact no-go for the named curve families and theorem-applicability
audit; Paper V research only; no manuscript or Lean change

## Verdict

The currently explicit intrinsic charge-three curve families do not meet the
de Jong--He--Starr surface-section hypotheses and do not produce an odd
zero-cycle over any of the finitely many support fields

\[
                         K_i=k(S_i).
\]

There are three separate reasons.

1. The degree-fifteen \(D_{3,3}\) packet is a family of auxiliary
   \(\mathbf P^1\)'s **contracted** by the forgetful map to the charge-three
   Abel fibre.  Its two-point evaluation on the Abel fibre factors through
   the diagonal.  It supplies no rational curve there.
2. The explicit Hecke \(\mathbf P^1\)'s lie in the non-locally-free boundary
   divisor of a compactification.  Their evaluation image is contained in
   that divisor, so the family is not dominating on the fourfold.  Pointwise
   unobstructedness of the boundary sheaves does not prove that the whole
   curves deform to free curves covering the interior.
3. Voisin's residual rational curves prove geometric rational connectedness
   through the maximal-rationally-connected quotient argument.  The proof
   does not establish rational simple connectedness by chains of free lines,
   a rationally connected general two-point evaluation fibre, or a very
   twisting surface.

Thus the de Jong--He--Starr theorem cannot presently be applied over the
surfaces \(S_i\).  This is not evidence that the generic charge-three
fourfold is not rationally simply connected.  It is a decisive no-go for the
explicit \(D_{3,3}\), Hecke, and presently printed residual-curve packages.

## 1. Exact fieldwise parity of the D33 relay

Let \(V\) be a smooth proper model of the generic charge-three Abel fibre,
let \(D\) be the type-\((3,3)\) incidence, and let \(Y\) be the unordered
theta fibre.  On the general-cubic open where the all-good packet theorem is
proved, the exact degree-fifteen/degree-three relay is stable under every
field extension.  Therefore

\[
 v_2(\operatorname {ind}V_{K_i})
 =v_2(\operatorname {ind}D_{K_i})
 =v_2(\operatorname {ind}Y_{K_i}).               \tag{1.1}
\]

For the special marked A5 support fields, (1.1) remains conditional on the
all-good packet open meeting the generic pullback of \(M_9\).  This
specialization gate was not proved by the exact model.  Whether available
unconditionally or only conditionally, the degree-fifteen packet cannot
improve parity: it only transfers whatever oddness is already present at an
endpoint.

The geometric reason is equally explicit.  Over a dense open of \(V\), the
normalization of \(D\to V\) factors as

\[
                 D^\circ\longrightarrow P^\circ\longrightarrow V^\circ,
\]

where \(P^\circ\to V^\circ\) is the finite degree-fifteen packet and
\(D^\circ\to P^\circ\) is a \(\mathbf P^1\)-bundle.  Every packet
\(\mathbf P^1\) parametrizes sections/decompositions of one fixed bundle
\(E\); forgetting those data maps the entire curve to \([E]\in V\).
Consequently the evaluation morphism of these curves on \(V\) has image in
\(\Delta_V\subset V\times V\).  Chains remain contracted.

This also explains the apparent arithmetic circularity.  The degree-fifteen
scheme is defined over \(K_i(V)\), after choosing the generic point of
\(V\).  It is a degree-fifteen zero-cycle on the auxiliary fibre, not a
degree-fifteen point of \(V/K_i\).  Pushing it back to \(V\) only multiplies
an already chosen point degree by fifteen, exactly as (1.1) records.

## 2. The Hecke lines fail dominance

The Faenzi elementary transform

\[
                 0\longrightarrow G\longrightarrow E
                   \longrightarrow\mathcal O_L\longrightarrow0
\]

has quotient choices

\[
             \mathbf P\operatorname {Hom}(E|_L,\mathcal O_L)\simeq\mathbf P^1.
\]

For charge two to charge three, these curves fill the generic
non-locally-free divisor \(B\) of the nine-dimensional charge-three moduli
component.  After fixing the Abel--Jacobi value, they fill only the
three-dimensional divisor \(B_{\eta_J}\) in the fourfold \(V\).  Hence

\[
 \operatorname {im}(\mathrm {ev})\subset B_{\eta_J}\subsetneq V,
 \qquad
 \operatorname {im}(\mathrm {ev}_2)\subset
 B_{\eta_J}\times B_{\eta_J}\subsetneq V\times V.
\]

The displayed Hecke family is therefore not even a dominating family of
rational curves on \(V\), a prerequisite far weaker than rational simple
connectedness.

Faenzi proves that a general boundary sheaf is unobstructed and deforms to a
bundle.  That is a pointwise statement in the nine-dimensional moduli.  It
does not compute the normal line of a Hecke \(\mathbf P^1\), prove that a
whole curve smooths out of the boundary, or give the tangent splitting
needed for freeness.  A deformation of these curves could still be useful,
but it is a new family requiring a new normal-bundle theorem.

This audit does not revisit the inherited charge-two conic: its index-two
status over the support fields is already exact and is logically separate
from the curve-family obstruction here.

## 3. What the surface theorem actually requires

De Jong--He--Starr Corollary 1.1 applies to a morphism of nonsingular
projective varieties \(X\to S\), with \(S\) a surface, under three relevant
hypotheses:

1. geometric irreducibility over a codimension-two open of \(S\);
2. a globally defined relatively ample invertible sheaf over that open; and
3. a geometric generic fibre rationally simply connected by chains of free
   lines and containing a very twisting surface.

The third condition is much stronger than geometric rational connectedness.
The same paper explicitly warns that even Brauer--Severi families over a
surface can lack a rational section unless the global polarization/Brauer
condition is controlled.

For the charge-three Abel family over each \(S_i\), none of the three inputs
has been packaged in the needed form:

- no smooth projective compactification of the relevant Abel fibre family
  has been identified;
- no relative ample class and its extension across the codimension-one
  boundary has been computed; and
- no component of stable maps has the required free-line chain and
  very-twisting properties.

The first two are not bookkeeping.  The current charge-three source audit
shows that the Gieseker compactification has not been identified with the
closure of Voisin's component over the Abel base, and its relative Picard and
canonical data are unknown.

## 4. Voisin's residual curves prove RC, not RSC

Voisin constructs rational curves \(R_C\subset M_{6,1}\) by linking a
degree-six rational curve \(C\) to a pencil of residual elliptic sextics on
quartic ruled surfaces.  These curves sweep \(M_{6,1}\).  Combined with the
divisors of types \((3,3)\) and \((5,1)\), they identify the maximal
rationally connected quotient with \(J\), proving rational connectedness of
the general Abel fibre.

The proof uses a one-point/divisor incidence principle for a sweeping family.
It does not study

\[
 \overline M_{0,2}(V,\beta)\longrightarrow V\times V,
\]

does not prove rational connectedness of a general evaluation fibre, and does
not construct a very twisting surface in the one-pointed stable-map space.
Nor does it show that the projected curves are lines for a relatively ample
class on a proper Abel-fibre model.  Ordinary MRC control therefore cannot be
inserted into de Jong--He--Starr as if it were RSC.

This is the only named family that reaches the interior and remains a live
upgrade candidate.  Its exact next gates are:

1. construct the proper projected family on a chosen compactification of
   \(V\);
2. compute \(f^*T_V\) and the normal splitting of a general projected
   residual curve;
3. prove dominance and rational connectedness of a two-point chain
   evaluation space; and
4. construct the required very twisting surface and relative polarization.

Without at least the first two, even freeness is unaudited.

## 5. Consequence for odd zero-cycles on the support surfaces

For every \(K_i=k(S_i)\), the unconditional available implication is

\[
 \operatorname {ind}(V_{K_i})\mid2.
\]

Conditional on the all-good packet specialization, one additionally has

\[
 v_2(\operatorname {ind}V_{K_i})
 =v_2(\operatorname {ind}Y_{K_i}).
\]

The explicit intrinsic charge-three curves add no odd degree.  If a future
RSC package satisfied the surface theorem, it would give a \(K_i\)-point and
close the gate at once.  Presently, however, neither a theorem-grade RSC
package nor an odd zero-cycle results from the known families.

## Sources and read depth

This pass read **zero papers in full** and three sources claim-specifically.

1. A. J. de Jong, Xuhua He, and Jason Michael Starr, *Families of rationally
   simply connected varieties over surfaces and torsors for semisimple
   groups*, arXiv:`0809.5224`.  Read depth: **partial**, cached arXiv version,
   introduction through Corollary 1.1 and its stated hypotheses.  Cache
   SHA-256
   `44e7af4595261743df7d310274682bb69010f93377977da857be0d4936b1cc68`.
2. Claire Voisin, *Abel--Jacobi map, integral Hodge classes and decomposition
   of the diagonal*, arXiv:`1005.5621`.  Read depth: **partial**, cached arXiv
   version, Theorem 2.1 and proof through Lemmas 2.4--2.10, including the
   residual curves \(R_C\) and the MRC argument.  Cache SHA-256
   `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.
3. Daniele Faenzi, *Even and odd instanton bundles on Fano threefolds of
   Picard number one*, arXiv:`1109.3858`.  Read depth: **partial**, cached
   arXiv version, Theorem 3.1 Steps 2--3.  Cache SHA-256
   `0024a632f2ca141eb4f3c09c43c65a3464646fd72fd951417abb2a3a9db90e8f`.

No new forward-citation or global-absence claim is made.  The conclusions are
theorem-applicability statements for the explicit families above.

## EJ + TT closeout / mystery ledger

- **Settled:** the degree-fifteen packet \(\mathbf P^1\)'s are contracted in
  \(V\), so they cannot be free lines or RSC chains there.
- **Settled:** the explicit Hecke lines evaluate only into the boundary
  divisor and are not a dominating family on \(V\).
- **Settled:** wherever the all-good D33 packet specializes, the relay
  preserves the 2-primary index after every extension; it cannot create
  oddness.  The marked-A5 specialization itself remains conditional.
- **Settled:** Voisin's printed argument proves RC/MRC, not the two-point and
  very-twisting conditions required over a surface.
- **Open, highest EV:** compute the normal/tangent splitting of Voisin's
  projected residual curve \(R_C\) on a proper Abel-fibre model.  A positive
  very-free result would be the first real step toward RSC.
- **Open:** compute the normal line of the Hecke \(\mathbf P^1\).  If it is
  positive, deformations may escape the boundary; if nonpositive, the Hecke
  family is intrinsically trapped.
- **Open:** construct the relative ample polarization and a very twisting
  surface over each support surface.

Vibe: no odd point, but a sharp geometric triage.  D33 and the visible Hecke
lines are dead for RSC; only the projected residual curves merit a further
serious attack.
