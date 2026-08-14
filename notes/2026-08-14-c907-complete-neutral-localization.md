# C907 — complete-neutral localization for a smooth projective master

Date: 2026-08-14

**Status:** new theorem package, internally proved and source-audited; external
referee check still required.  This note closes the last common-coefficient
gate in the global-cobordism route.  It is not a theorem stated by Woodward or
Aleshkin--Liu.  Woodward supplies the exhaustive fixed-locus and virtual-normal
formulas; the balanced Barnes continuation below is the new synthesis.

## 1. Statement

Let `G=C*` act on the smooth projective equivariant completion `W` of a
Wlodarczyk cobordism.  Let two extreme
linearizations have smooth free semistable loci and smooth projective
quotients `Y_-` and `Y_+`.  Fix:

- a finite ample-energy/bulk Artin quotient of the equivariant Novikov ring;
- a class modulo a primitive affine gauge direction `delta`;
- the rotation-equivariant localized gauged potentials with parameter `zeta`.

Assume the unbounded direction is neutral:

\[
 c_1^G(TW)\cdot\delta=0.                                      \tag{1}
\]

Then the complete virtual-localization sums for the two endpoint
polarizations are residue expansions of one vector-valued balanced
Mellin--Barnes kernel.  This remains true after arbitrary input/bulk
derivatives and the Rees substitution

\[
 Q^d\longmapsto z^{c_1^G(TW)\cdot d}Q^d.                       \tag{2}
\]

If (1) fails, every homogeneous Artin coefficient is Laurent-finite in the
`delta` direction.  Consequently all Rees-homogenized endpoint localized
linearized quantum-Kirwan maps coexist over one meromorphic differential
field.

## 2. Fixed-locus completeness and the node factor

Woodward Part III, Corollary 9.10, describes every fixed point for rotation
of the graph curve by clutching one-parameter subgroups and attaching stable
maps.  His equations (57)--(59) split the normal complex.  In particular,

\[
 \operatorname{Eul}(N_\pm)=
 \operatorname{Eul}\!\left(
   (R\pi_*\operatorname{ev}^*T(W/G))_{\mathrm{mov}}
 \right)(\mp\zeta)(\mp\zeta-\psi).                             \tag{3}
\]

The last two factors come from smoothing the node and moving the attaching
point.  They do not depend on the affine gauge degree.  Thus gluing cannot
delete one tail of the degree lattice, manufacture a degree-dependent pole,
or replace a complete residue by an incomplete Gamma function.

At fixed Artin order there are finitely many ordinary degrees, fixed
components, stabilizer orders, and bubble graphs.  The affine gauge integer
is the only unbounded label.

## 3. The moving index is a balanced Gamma kernel

Clear the finite stabilizer denominators and apply the splitting principle.
On the principal weighted component, a virtual line in the moving index has
nilpotent Chern root `alpha_a` and degree

\[
 n_a(k)=h_a k+s_a.                                               \tag{4}
\]

For all integer `n`, its inverse index Euler factor is the meromorphic
identity

\[
 \frac{1}{\prod_{m=0}^{n}(\alpha_a+m\zeta)}
 =\zeta^{-n-1}
   \frac{\Gamma(\alpha_a/\zeta)}
        {\Gamma(\alpha_a/\zeta+n+1)}.                            \tag{5}
\]

For `n<0`, equation (5) reads the Euler class of `H^1`; for `n>=0`, it reads
the inverse Euler class of `H^0`.  It is therefore one formula on the whole
integer tower, not two unrelated chamber formulas.

The signed sum of its slopes is

\[
 \sum_a\epsilon_a h_a=c_1^G(TW)\cdot\delta.                     \tag{6}
\]

The gauge Lie algebra has slope zero.  Moving modes on attached fixed bubbles
have fixed rank at the chosen ordinary degree.  Their Euler factors are
finite products of linear functions of `k`, possibly inverted.  Each inverse
linear factor is an adjacent Gamma ratio,

\[
 (hk+a)^{-1}=\frac{\Gamma(hk+a)}{\Gamma(hk+a+1)},                \tag{7}
\]

whose numerator and denominator have the same slope.  Hence bubble moving
modes do not alter (6) or the Stirling decay.  Equivariant insertions are
polynomial in `k`; Chern roots and psi classes are nilpotent at Artin level;
the Liouville class supplies the Fourier exponential.

Under (1), the full expression is therefore an Artin-valued balanced Gamma
kernel of the kind treated in
`2026-08-14-c907-neutral-slice-gamma-kernel.md`.  Polynomial factors are
Fourier derivatives.  Nilpotent shifts are finite parameter derivatives.
Adjacent ratios have zero net slope.

The contour orientation is fixed by the virtual-localization orientation,
not chosen after seeing the two series.  For one moving character,

\[
 \operatorname*{Res}_{h\sigma+\alpha=-m}
 \Gamma(h\sigma+\alpha)\,d\sigma
 =\frac{(-1)^m}{h\,m!}.                                        \tag{8}
\]

The factorial is the Euler factor of the `m` moving polynomial modes, `1/h`
is the finite stabilizer/Jacobian factor after clearing denominators, and the
sign is the complex virtual-normal orientation.  Taking products of (8) and
nilpotent parameter derivatives reproduces the full inverse Euler class of
each rotation-fixed locus.  Conversely Corollary 9.10 says that every such
locus occurs.  Thus the geometric fixed terms are literally, with their
orientations and multiplicities, the residues of this one contour integrand;
they are not merely a sequence satisfying the same recurrence.

One must sum all gluing types before moving the contour.  A pole in (7) can
be the boundary presentation of another fixed graph.  Woodward's cutting and
gluing identities and the exhaustive union (57) provide the complete finite
sum.  Moving the contour then produces every wall residue exactly once.  The
two extreme degree half-series are its two chamber expansions.

## 4. Positive directions and passage out of Artin level

If `c_1^G(TW).delta` is nonzero, the virtual-dimension equation determines the
gauge exponent in every fixed homogeneous coefficient.  The dependence is
therefore Laurent-polynomial.  In neutral directions Section 3 supplies the
common Barnes field.  Combining the factors over a basis of the numerical
degree lattice gives one coefficient field for both endpoints.

All statements commute with quotient maps between Artin truncations:
localization, Gamma identities, differentiation, and contour continuation
are coefficientwise.  Their inverse limit never substitutes a nonzero number
for a topologically nilpotent Novikov variable.

## 5. Finite common packet without a finite global source

Let `A_i` be the Rees-homogenized derivative of the endpoint localized gauged
potential.  Woodward's localized adiabatic identity (68) gives

\[
 A_i=D\tau_{Y_i,-}\,D\kappa_i.                                  \tag{9}
\]

The graph fundamental solution `D tau` is invertible.  Formal smooth-endpoint
quantum-Kirwan surjectivity therefore makes `A_i` surjective.  Sections 3--4
put both maps over one differential field.  Their kernels are stable under
the common source connection.

The equivariant source itself need not have finite rank.  Set

\[
 \overline M=M/(\ker A_-\cap\ker A_+).                          \tag{10}
\]

It injects into the direct sum of the two finite endpoint modules, hence is
finite.  Its formal monodromy has primary decomposition, and a surjective
intertwiner maps its `lambda`-primary part onto the endpoint
`lambda`-primary part.  Thus both primitive-sixth packets are conservative
images of the same finite primary packet.

The global orbit-cylinder point class gives a common row on the two maps by
the commuting-rotation support-collapse theorem.  Applying the finite-module
Boolean lemma yields

\[
 r_-|P_6(Y_-)\ne0\quad\Longleftrightarrow\quad
 r_+|P_6(Y_+)\ne0.                                              \tag{11}
\]

For `Y_-=X x P^2` and `Y_+=P^5`, the left side is true and the right side is
false by the endpoint calculation.  Hence these varieties cannot be
birational.

## 6. Hostile checks and scope

1. **Not a formal-completion substitution.**  The common field is built from
   Laurent-finite coefficients and analytic balanced kernels before the
   inverse Artin limit.
2. **Not scalar trace factorization.**  The common maps are the oriented
   localized gauged maps (9); the point row was isolated separately.
3. **Not one graph at a time.**  Boundary poles require the complete finite
   graph sum before contour movement.
4. **Not full Fourier-cone preservation.**  Only the quotient (10) and its
   primitive-sixth primary part are used.
5. **Not a published nonlinear theorem.**  Aleshkin--Liu prove the balanced
   contour theorem for abelian linear GLSMs.  The reduction of the nonlinear
   master to such coefficientwise kernels uses Woodward's virtual normal
   formula and is new here.
6. **Orbifold denominators.**  A finite ramified cover clears them; descent is
   by the finite deck action after the identity is proved upstairs.
7. **Grade restriction versus surjectivity.**  Choose one character in the
   nonempty grade-restriction window (Aleshkin--Liu Remark 5.4 permits
   `B=-t`).  Polynomial equivariant inputs are Fourier derivatives of that
   kernel.  Its endpoint line-bundle twist is invertible, so classical Kirwan
   lifts followed by these derivatives still span the finite target packet.

The dependency-free regression
`2026-08-14-c907-complete-neutral-localization-check.py` verifies the uniform
finite-product continuation (5), its recurrence across `n=-1`, the adjacent
Gamma ratio (7), and the first balanced seven-charge suspect.

## Sources

- Chris T. Woodward, *Quantum Kirwan morphism and Gromov--Witten invariants
  of quotients III*, arXiv:1408.5869v7, Corollary 9.10, equations
  (57)--(59), Definition 9.13, and equation (68); cached PDF SHA-256
  `5aa794f4d83dd8d127aab769d95a71a4691d7a35d220e81ca73c5b8bb360ea51`.
- Konstantin Aleshkin and Chiu-Chu Melissa Liu, *Higgs--Coulomb
  correspondence and Wall-Crossing in abelian GLSMs*, arXiv:2301.01266v1,
  Definition 5.18 and Theorem 5.21; cached PDF SHA-256
  `921af8ed2105d6a511c0cf485550a263e222983c6fcc628b44c838bb3d8de81f`.
- Eduardo Gonzalez and Chris T. Woodward, *A wall-crossing formula for
  Gromov--Witten invariants under variation of GIT quotient*,
  arXiv:1208.1727v7, Proposition 3.15(c) and the virtual Kalkman formula;
  cached PDF SHA-256
  `2c99203c8e1d7dd373112629bbfac0760e7a3812d348e9110a1eb2b894d9d84c`.
