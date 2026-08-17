# C907 — publication readiness after the peak-shadow audit

Date: 2026-08-13

Status: editorial verdict, not a new mathematical theorem.  C907 currently
contains one focused correction/extension which is already reviewed and
archived, one
substantial conditional wall-crossing package, and one rigorous obstruction
package explaining why the final Gold lemma cannot be replaced by cheaper
formal or singular shadows.  Gold itself is not proved.

## 1. Focused correction/extension: complete and archived

The cleanest independent paper is the discrepancy-one (`nu=r-s=1`)
extension of Shen--Shoemaker's standard-flip asymptotics.  The C911 lane has
already produced the reviewed manuscript, passed the authority and
standalone checks, exported the repository, and deposited it under DOI
`10.5281/zenodo.21924799`.

The source audit found two concrete omissions in the printed proof chain:

1. the local hypergeometric expression is dismissed as not `J`-normalized
   when `nu<=1`, but for `(r,s)=(2,1)` its positive-degree terms have
   strictly negative `z`-order, so cone membership gives the required
   `J`-normalization directly;
2. the nonzero-sector proof invokes the `nu>1` Barnes aperture, while the
   paper's own Appendix A treats `nu=1` with `epsilon=1/2` and supplies the
   correct sector.

The repair is exact, short, and source-local.  It extends the stated
Gamma/Orlov asymptotic theorem to codimension-two blowups without requiring
a new global wall-crossing theory.  Publication status: **complete/archived**;
any journal submission or author correspondence is a dissemination choice,
not unfinished mathematical drafting.

Primary audit:
`2026-08-13-c907-shen-shoemaker-codim2-repair.md`,
`cubic-threefolds-tasks/c911-shen-shoemaker-flip-repair-note.md`, and the
codimension-two portions of the live C907 card.

## 2. Main rank-row package: substantial conditional paper

The following components are theorem-grade or reduced to named source
extensions:

- the exact all-codimension one-wall ambient point-column identity in a
  fixed sectorial receiver;
- oriented Euler/Gamma orthogonality of center blocks;
- the finite fivefold standard-wall portfolio;
- the discrepancy-one global simple-VGIT realization;
- Morelli/AKMW unit-circuit coverage, excluding hidden index-two weighted
  walls in the chosen pi-nonsingular factorization;
- intrinsic ordinary-flop point-row preservation;
- the complete point-centred Geiser peak and its `P2` product;
- the `P2` endpoint product and projective-space packet multiplicity;
- K-positive carrier-face peaks under the explicit positivity/nonturning
  hypotheses.

These results support a coherent paper of the form:

> Rank covectors under quantum birational wall crossing, conditional on a
> carrier-dressed two-wall boundary-pairing theorem.

The condition is now a single named morphism, not a vague analytic input.
This is publishable as a conditional/structural theorem if the hypothesis is
prominent and the local positive classes are presented as unconditional
corollaries.  Readiness estimate: **75--85%** after consolidation; lower if
marketed as unconditional stable irrationality.

## 3. The obstruction/shadow package: a rigorous publishable section

Four exact regressions now prove that the remaining datum is minimal.

1. The safe `dP7` carrier peak already has an ambient--wall `A1`
   discriminant collision and transposition braid.
2. The incomplete-Gamma connection realizes the forbidden ambient target
   with algebraic geometric periods, Kummer exponent `1/6`, and after
   doubling/tagging an integral paired Stokes lattice and the `P2`
   nilpotent label.
3. Localized partial Fourier--Laplace is exact but nonconservative: it kills
   `C[t]=D_t/D_t partial_t`.  The incomplete-Gamma coefficient is exactly a
   lost constant of integration.
4. Normal-GKZ coordinate restriction and projection have opposite variance;
   at least one is zero.  The ordinary packet and compact-support point row
   must therefore be retained as a dual pairing, not forced into one common
   reduced image.

Together these are a genuine no-go theorem for broad proof architectures:
formal exponential labels, spectral braids, pairing/integrality, purity of
graded pieces, localized GKZ, and a single common contiguity image cannot by
themselves determine the Gamma rank row.  All four attacks select the same
minimum survivor:

\[
 K_!\longrightarrow K_*;qquad
 \operatorname{can},\operatorname{var},
\]

with Verdier duality, orientations, and the ordered path data.  This package
is publishable as a substantial section or short companion note because it
contains explicit countermodels and a positive minimality conclusion, not
merely a list of failed attempts.  Readiness estimate: **70--80%**; it needs
one unified notation and a clean statement of the class of proof strategies
being excluded.

Core notes:

- `2026-08-13-c907-dp7-spectral-braid-shadow-failure.md`;
- `2026-08-13-c907-minimal-ambient-target-stokes-countermodel.md`;
- `2026-08-13-c907-marked-singular-shadow-sieve.md`;
- `2026-08-13-c907-oriented-residual-excision-reduction.md`.

## 4. Exact Gold boundary

Gold (`X x P2`) is not yet a theorem.  It is equivalent, in the assembled
architecture, to the following carrier-dressed unit-circuit statement:

> the primitive-sixth component of the two-wall unlocalized boundary
> pairing has zero output zero-section multiplicity.

Equivalently, the categorical/window rank-zero correction and the analytic
Gamma/Stokes correction agree on the one compact-support point row.  The
order-zero toric pilot already proves the proper-support/rank half by
intersecting the bad images of two compactifications; the open part is the
directed `! -> *`, `can/var` marking after carrier dressing.

The theorem should not currently be advertised as following from:

- Iritani's formal blowup decomposition;
- Shen--Shoemaker's one-ray asymptotics alone;
- formal constant banking or an Artin inverse limit;
- absence of an ambient--wall braid;
- purity/semisimplicity of associated graded Hodge pieces;
- quasi-symmetric completion followed only by localized Fourier--Laplace.

## 5. Editorial recommendation

The safest publication sequence is:

1. circulate/submit the already archived codimension-two correction;
2. consolidate the unconditional one-wall, ordinary-flop, Geiser, and
   unit-circuit results with the obstruction package;
3. state the double-boundary pairing theorem as the sole hypothesis of the
   global Gold corollary;
4. promote Gold to the title/abstract only after that boundary theorem is
   proved.

Numerically: the correction is complete; the broader paper has most of
its architecture and examples; Gold remains one binary but load-bearing
lemma away.  The amount of completed work is publication-scale even if that
last lemma ultimately fails.

## EJ / TT / AA

- **EJ:** separate the already citable source correction from the global
  Gold claim; they have very different risk profiles.
- **TT:** the negative results add value because they prove minimality of the
  remaining boundary diagram.  Do not present them as abandoned routes.
- **AA:** if Gold resists, publish the correction plus the exact one-wall and
  no-go packages; do not weaken the final theorem into an uncheckable
  “compatibility expected” clause.
