# C210 mechanism notebook (legacy discovery-track filename)

**Date opened:** 2026-07-16
**Lane:** `relconic`
**Classification:** task-work notebook, not a discovery track under the normalized
[discovery-track conventions](discovery-track-conventions.md). Most entries record construction
signals, rejected mechanisms, and active proof routes that the C210 program was explicitly pursuing.
The file is retained at its existing path for stable links; do not append new planned work here. The
theorem-facing record remains
[`2026-07-16-c210-square-root-mechanism-audit.md`](2026-07-16-c210-square-root-mechanism-audit.md).
Confidence tags are `CHECKED`, `REASONED`, and `OPEN`.

## 2026-07-16 — literature and Baer geometry

- **The almost-complete-conic route points in the wrong direction (`REASONED`).** An almost-complete
  subset of a conic leaves points of that same conic uncovered. After projective transport, more
  than four such points force the exceptional conic to be that conic by Bézout, putting the selected
  points on the prescribed conic instead of avoiding it. **Disposition:** retain as a cheap transfer
  rejection, not as a global obstruction.

- **Containment in one Baer subplane is an infinite-family obstruction (`CHECKED`).** If the ambient
  order is `s^2` and an arc lies in a Baer subplane of order `s`, its nonsecant Baer lines leave at
  least `(s^2-s)^2/2` external points uncovered, more than an ambient conic can absorb for `s>=3`.
  **Question:** do analogous fiber counts obstruct arcs concentrated in a bounded number of Baer
  cosets? **Disposition:** revisit only if the transversal construction stalls.

- **The lower-bound constant reappears as a fiber-surjectivity threshold (`REASONED`).** A Baer-line
  external fiber has about `s^2` points, while a `k~c*s` arc has about `c^2*s^2/2` secants. The first
  counting point at which pair-intersection maps can be surjective is `c>=sqrt(2)`, matching the
  defect lower bound. **Question:** can collision multiplicity in these maps recover the exact defect
  remainder? **Disposition:** conceptual guide; do not expand unless it yields a proof tool.

## 2026-07-16 — layered parabola experiments

- **Two parallel subfield parabolas give a uniform conic-disjoint `2s`-arc (`REASONED`, formula
  checked computationally).** For offsets with difference outside the subfield, the mixed
  determinant is `(u-t)((v-t)(v-u)+delta)` and cannot vanish. **Question:** is this union already a
  named translation-arc construction? **Disposition:** require a dedicated priority check before
  any novelty claim.

- **The direct two-layer coverage intuition failed (`CHECKED`, bounded).** The family is relatively
  complete only at `s=3` among `s=3,4,5,7,8`; at `s=8` it nevertheless leaves 330 required points,
  far fewer than the earlier C201 mechanisms. **Disposition:** use it as a high-coverage seed, not a
  claimed construction.

- **A full third layer over the original subfield is impossible for a trivial geometric reason
  (`REASONED`).** Each vertical line already contains the two seed points, so a third point with the
  same horizontal parameter makes a collinear triple. **Disposition:** repair layers must use a
  nontrivial additive coset or a partial domain.

- **Constant coset repair succeeds sporadically at `s=5` (`CHECKED`, bounded).** Two full coset
  layers give complete 15-arcs, while `s=7` has no arc-legal layer. **Question:** is the `s=5`
  success an isolated small-field coincidence or a member of a different congruence family?
  **Disposition:** do not pursue until a symbolic parameter law appears.

## 2026-07-16 — repair graphs

- **All chord calculations collapse to one height-interpolation formula (`REASONED`; 52,488 cases
  checked over `GF(9)`).** For points `(x,x^2+h)` and `(x',x'^2+h')`, the chord height at `y` is
  `h+(y-x)(h'-h)/(x'-x)-(y-x)(y-x')`. **Disposition:** use as the sole coordinate interface for
  collision and coverage work.

- **Internal repair-arc legality is a divided-difference condition (`REASONED`).** Three repair
  parameters are noncollinear exactly when `1+g[r,s,u] != 0`. Affine `g` is internally harmless,
  but every legal affine layer at the tested orders has zero slope and merely recovers a constant
  layer. **Disposition:** affine heights closed as a bounded mechanism.

- **Quadratic repair-pair collisions become split-polynomial tests (`REASONED`; survivors checked
  projectively).** For each seed point, the quadratic coefficients determine a unique `(p,q) in
  F^2`; collision occurs exactly when `X^2-pX+q` splits distinctly. In characteristic two this is
  `p!=0` and `tr(q/p^2)=0`. **Question:** can all arc conditions be expressed as a small family of
  Boolean trace identities? **Disposition:** active proof route.

## 2026-07-16 — the q=64 nonlinear signal

- **Nonlinear quadratic repair first survives at `s=8` (`CHECKED`, bounded).** Twelve nonlinear
  full repair layers give 24-arcs; none survive at `s=3,4,5,7`. **Disposition:** treat `s=8` as a
  construction signal, not evidence of a theorem for all even `s`.

- **The twelve raw solutions are three genuine seed-stabilizer orbits (`CHECKED`).** Exhausting the
  conic stabilizer and six field automorphisms leaves an order-eight seed stabilizer consisting only
  of subfield translations. Each coefficient block of four is one orbit under
  `c -> c+a*d^2+b*d`. **Question:** are the three orbit representatives equivalent after allowing
  the seed itself to move within the larger two-layer family? **Disposition:** optional; fixed-seed
  inequivalence is enough for the current construction route.

- **Every nonlinear survivor is complete in the affine plane (`CHECKED`).** Its nineteen uncovered
  projective points all lie at infinity. Any two missing directions extend it to an ordinary
  complete 26-arc, since their mutual secant covers the line at infinity. This was not the property
  optimized by the quadratic probe. **Disposition:** promote affine completeness to the main C210
  construction signal.

- **Repair--repair chords are irrelevant to affine coverage (`CHECKED`, q=64).** Among the six
  secant classes, the unique minimal class cover is `AA,AB,AR,BB,BR`; `RR` is needed only for arc
  legality. The cross-layer classes miss 56 points, either same-seed class reduces this to 14, and
  both close the gap. **Question:** can the 56 and 14 residues be characterized as trace quadrics or
  affine subspaces? **Disposition:** active symbolic coverage route.

- **Same-layer chord values form a split-polynomial trace set (`REASONED`; all 56 non-subfield
  fibers checked at q=64).** For `U outside F`,
  `S_U={U*p+q:p!=0, tr(q/p^2)=0}` has size `s(s-1)/2`. **Disposition:** use the two seed translates
  of `S_y` to absorb the residual cross-layer holes.

## 2026-07-16 — trace-parametrized family signal

- **One orbit representative is determined by a single element `beta` (`CHECKED` at q=64).** With
  `alpha=1`, it satisfies `eta=beta`, `lambda=a/b=Tr_E/F(beta)`,
  `b^2=beta^3/lambda`, `a=lambda*b`, and `c=b^(-2)`. **Question:** which trace-one minimal
  polynomials make the resulting three layers an arc and affine-complete? **Disposition:** active.

- **The trace-parametrized formula succeeds on one six-element Frobenius orbit (`CHECKED`, bounded).**
  At `s=8`, the successful `beta` values are the conjugates of a root of
  `X^6+X+1`; all six give affine-complete 24-arcs and complete 26-arcs after two directions. The same
  formula gives no arc at `s=4`. **Question:** is the relevant infinite condition a family of
  trace-one elements satisfying an additive or linearized polynomial, rather than all quadratic
  extensions? **Disposition:** derive the general trace identities before testing `s=16`.

- **The six successful parameters have a basis-free trace/norm characterization (`CHECKED`,
  bounded).** They are exactly the `beta` with `tr(Tr(beta))=0` and
  `N(beta)=Tr(beta)^5`; irreducibility is `tr(Tr(beta)^3)=1`. **Disposition:** retain this as the
  exact explanation of the first q=64 orbit.

- **The obvious infinite scalar extension is killed by reciprocal trace (`REASONED`, using the
  classical Weil bound).** For the `GF(8)` coefficient pattern, one-repair/two-seed legality would
  require that no nonzero `z` satisfy `tr(z)=tr(z^(-1))=0`. The exact count is
  `(s-3+K_s)/4`, so `|K_s|<=2*sqrt(s)` makes it positive for every `s>=16`; `GF(8)` is the exceptional
  zero-count case. **Question:** do the other two q=64 orbits change the reciprocal map enough to
  evade the same Kloosterman obstruction? **Disposition:** this is the next symbolic gate.
