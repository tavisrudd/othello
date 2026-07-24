# Reed--Solomon deep-hole programme — companion archive (append-only)

Companion to [`../2026-07-22-reed-solomon-deep-holes.md`](../2026-07-22-reed-solomon-deep-holes.md).
Dated session notes and superseded execution material live here; the live handoff retains only the
current context map and frontier.

## 2026-07-22 — Lane creation

The lane was split from the completed C398/C474 Reed--Solomon bridge. C475 was reserved for the
first standard-GRS task: prove the descent of a bounded determinant/coefficient atlas, test exact
orbit separation in the smallest normalized cases, and stop at the first collision to determine
its complete fibre. No C475 mathematical result is claimed at lane creation.

## 2026-07-22 — Cross-paper extraction

The papers index and adjacent theorem banks sharpened the first move. On a Veronese conic the edge
determinant factors into the support bracket and one syndrome bilinear form. Monomial-rescaling
invariance then forces balanced edge ratios, with support-normalized four-cycles as the first atlas.
The live handoff records the exact formula, import order, and stop gate; heavier cocycle, modular,
and higher-order-MDS machinery remains conditional on a genuine atlas collision.

## 2026-07-22 — Gated theorem ladder

C476--C478 were reserved as three bounded successors: a five-field six-support pilot, a
collision-only fibre theorem, and fixed exceptional-family controls. Generic all-field,
semilinear-tower, higher-order-MDS, and modular/category extensions remain unallocated behind
explicit gates.

## 2026-07-22 — C499 sporadic pencil structure (closed)

C499 gave the intrinsic structure of every C491 sporadic deep-hole orbit at q in {7,8,9,11,13,17,19}
from the frozen census representatives (no regeneration). One invariant — the Frobenius orbit type of
the degree-3-cover branch divisor Delta(lambda), refined by j-invariant — sorts all sporadics into
five normal forms. The stab-12 orbits (q=7,13,19) are exactly the equianharmonic (j=0, I(Delta)=0)
pencils with stabilizer A4 (order fingerprint {1:1,2:3,3:8}); the "4 double + 4 irreducible" profile
is each a single stabilizer-orbit on the pencil line. The three q=8 size-252 orbits are one free
Gal(F_8/F_2)=C3 torsor on the a4 cubic-twist label (Frobenius orbit {t,t^2,t^4}), a structural
parallel to C484's colour C3=(0 4 1)(2 5 3) (same Galois group, free/lossy, not Gale/Hilbert-90).
Verdict: uniform structure but sporadicity is a bounded-q accident — the equianharmonic orbit
persists for every q=1 mod 3 (constructed at q=25,31,37,43,49) yet is deep only at q in {7,13,19};
elsewhere it carries totally-split members. Report and evidence bundle:
`../../2026-07-22-c499-sporadic-pencil-structure.md` (+ `.py`, `.json`, `.sha256`). Both C491
discovery-track leads settled.

## 2026-07-23 — C514 modular TRS translation quotient (closed)

C514 turns the modular full-length last-hook translation symmetry into an exact determinant
quotient.  Each support's canonical completion root gives the slice `U=T-r`, `sum(U)=1`;
the Lucas-maximal fixed flag survives projection with no connecting correction.  The hoped-for
C512 recursion fails for two proved reasons: generic annihilator lines are not consecutive-row
polar lines, and valid completion/support collisions lie on C512's forbidden marker divisor.
The report refreshes all three pinned citation graphs and makes no field census or deep-hole
classification claim.

Two subsequent extra-juice rounds add the exact difference identity
`Delta_b F_y=F_{(A_-b-1)y}`, prove that every support translation stabilizer is trivial, and
identify the valid completion-collision boundary as `X^2 Q_V` over the trace-one configuration
space in `G_m`.  These are C515's operator and boundary inputs; root existence and additive trace
classes remain its theorem gate.

## 2026-07-23 — C515 modular TRS Hasse recursion (closed)

C515 derives the complete Hasse/augmentation filtration of the C514 incidence polynomial and the
exact adjoint-kernel trace test at linearized endpoints.  It proves the decisive obstruction:
finite-difference zeros express equality of determinant values and do not lift support zeros,
with the standard fixed syndrome as the terminal counterexample.  The polar-compatible locus is
a ruled surface of dimension at most two, containing the standard direction but excluding every
pure extra Lucas-maximal direction; fixed endpoints become elementary-symmetric tests on
trace-one configurations.  The next possible theorem shape is global geometry of the full
incidence hypersurface, not another local recursion.

A requested Tao audit corrects a potential conflation of Lucas Hasse index with augmentation
depth and adds the multiplicative transfer
`N_y(U)=Res(R^q-R,F_y(R,U))`.  This orbit norm exactly preserves zero incidence while eliminating
the translation coordinate.  At a linearized endpoint it is, up to sign, the kernel-size power
of the image linearized polynomial evaluated at `-c`, making the adjoint-trace obstruction its
exact factor.

A further extra-juice pass stratifies by the additive syndrome stabilizer `H_y`: the full orbit
resultant is the forced `|H_y|`-th power of the reduced product over `F_q/H_y`.  Thus every
nontrivial stabilizer makes the raw norm inseparable, and the correct future component gate is
absolute irreducibility of the reduced coset norm.  On the full fixed flag the reduced norm is
the elementary-symmetric endpoint equation and the raw multiplicity is exactly `q`.

## 2026-07-23 — C518 modular TRS global-incidence obstruction

C518 executes the prescribed fixed-endpoint and residual-quadratic attacks without an ambient
field census.  The full-field complement identity replaces each endpoint `e_d(U)=0` by
`h_d(W)=0` on a `k+1`-point complement of sum `-1`; the Schur alternant makes this the dependence
of the columns `1,w,...,w^(k-1),w^N`, with
`N=(floor(k/p^l)+1)p^l+1`.  A primitive-element construction clears every binary `k=2` endpoint,
and fixed Frobenius subfields clear the range `p^g>k+1` for `k>=3`.

Fixing all but two support roots gives `F=C+BD`.  The residual quadratic
`DZ^2-ADZ-C` exposes the exact determinant/infinity divisor, odd branch square class,
characteristic-two Artin--Schreier trace class, residual diagonal, and fixed-root resultant while
retaining the valid completion collision.  Factorization monodromy and the ordered-root fallback
both return to the same reduced Frobenius-alternant component, and quotient rational points still
need the displayed residual lift.  The task therefore closes at its explicit obstruction exit;
the general carrier remains unallocated and is not silently assigned to C519.

A requested second extra-juice pass completely parametrizes the binary carrier by its ordered
cross-ratio `lambda`.  At level `l`, admissibility is exactly
`lambda^(2^l-1) != 1` and `lambda^(2^l-2) != 1`, giving
`(q-2^gcd(l,m)-2^gcd(l-1,m)+2)/6` unordered complements.  Every such complement avoids zero, so
every binary fixed-endpoint zero—and not only one constructed witness—lies on the valid
completion/support collision boundary `0 in U`.  This makes C514's boundary retention essential
already at `k=2`.

The requested second-order pass identifies the ordered carrier with
`P1 - ({0,infinity} union mu_(2^l-1) union mu_(2^(l-1)-1))`, of reduced deletion degree
`2^l+2^(l-1)-1`.  The second apparent deletion polynomial is the forced square
`(lambda^(2^(l-1)-1)-1)^2`, an exact binary model of C515's inseparable-multiplicity warning.
Reordering is a free `S3` torsor with quotient coordinate
`(lambda^2+lambda+1)^3/(lambda^2(lambda+1)^2)`; quotient Frobenius has cycle type
`1^6`, `2^3`, or `3^2`, and only the identity type lifts to a rational ordered support.

A requested Tao audit treats the high endpoint exponent as the semilinear quadratic
`x*x^(p^l)` rather than as a degree-`p^l+1` monomial.  After normalizing two ordered complement
roots to `0,1`, the alternant is linear in the translation coordinate:
`z Delta h_r + Delta h_(r+1)`.  Sum normalization then gives an explicit rational inverse, with
denominator `e1 h_r-h_(r+1)=s_(r,1)` by Pieri.  Thus every generic high-level carrier `p^l>k` is
rational.  The exact remaining geometry is the low-level carrier and the vertical consecutive-
Schur intersection `V(h_r,h_(r+1))`; arithmetic ordering and residual lifts remain separate.

A further extra-juice pass uses
`h_(n+1)(X,x)-x h_n(X,x)=h_(n+1)(X)` to prove consecutive complete symmetric functions coprime
in every characteristic.  The vertical Schur family is therefore lower-dimensional and the
rational high-level carrier is uniquely top-dimensional.  The product of its Vandermonde,
`h_r`, and `s_(r,1)` has degree `binom(k+1,2)+2(p^l-k)`, so Schwartz--Zippel gives that exact
high-level shallow gate.  It clears every `k=3` endpoint uniformly and leaves only low Lucas
geometry, bounded fields below the gate, and the separate residual/order torsors.

The requested second-order pass takes square roots at the characteristic-two top level:
`w^(q/2+1)=v^3` for `w=v^2`.  The endpoint becomes a fixed Schur equation
`s_(k-2,k-3,...,2,1,1,1)=0` of degree `k(k-3)/2+3`, independent of `q`.  For `k=4` this is
`e1 e4=e5`, hence five nonzero roots with both sum and inverse-sum one.  Splitting them as
`{a,a+1} union b{1,t,1+t}` gives an exact rational construction; `F4` cosets cover even extension
degree, and a degree-20 deletion bound covers every odd degree where the endpoint occurs.  Thus
all `k=4` top endpoints are shallow and the first possible persistent fixed endpoint is `k>=6`.

## 2026-07-23 — C519 modular obstruction exit

C519 derived the universal integral residual discriminant and found the task card's first additional
component.  In characteristic two it is the doubled quadric `(AD+BC)^2`, so every pullback is a
square even outside the frozen persistent and nucleus carriers.  The hyperelliptic slice strategy
therefore stops; the correct replacement is the Artin--Schreier class `D N_u/N_s^2`.  The report
also records the exact zero-image ruling classification, the characteristic-three thickened
singular scheme, all deletion/lifting semantics, and the unallocated successor gates.
The explicit extra-juice pass identifies the twisted cubic as a Frobenius graph on the reduced
Segre quadric, separating its tangent ruling from the complementary ruling.  The specialization
`B=0,C=1,D=1` gives Artin--Schreier class `1/A`; its simple pole proves that the generic
replacement cover is integral, so only the Hankel/root-compatible pullback is obstructed.
The Tao audit then identifies the residual quadratic as the divided Hessian of the contracted
binary cubic.  Its Artin--Schreier class is exactly the characteristic-two Arf invariant, and the
two Hankel-row Pluecker syzygies recover the residual equations.  The successor is therefore a
Hessian--Arf pullback classification rather than generic elimination.
The second-order extra-juice pass identifies the ambient ordered-root cover with the rational
ordered-secant projective bundle over `P1 x P1`.  A root-compatible factor pencil maps to a line
in binary-cubic space, and pulling back the ordered divided-Hessian root incidence gives an exact
`(2,2)` curve of arithmetic genus one.  Thus the genus-one strategy survives characteristic two;
the missing theorem is the reducible/nonreduced classification for these constrained Hankel
root-lines.

## 2026-07-23 — C525 ordered-Hessian pullback closure

C525 classifies the universal characteristic-two ordered-Hessian incidence after removable
twisted-cubic vertical factors.  Its separable reducible locus is the Veronese surface of
common-quadratic lines `P(qE)`; its inseparable locus is the two rulings of `AD+BC=0`.  One ruling
is the tangent boundary of that surface, while the complementary ruling admits no nontrivial
rank-two contained root-compatible pullback.  C512 therefore identifies the entire contained
syndrome pullback with the persistent catalecticant/Lucas-nucleus carrier union.

Outside the carrier, a nonzero pullback equation has degree at most four in each fixed root.
Besides the quadratic Schwartz--Vandermonde estimate, disjoint five-element interpolation blocks
give the linear sufficient threshold `q>=5(n-4)` while enforcing distinct roots automatically.
Taking the better integer threshold and the exact deletion budget `3n-4`, the genus-one
Hasse--Weil argument proves containment of every split-free syndrome in the persistent/Lucas
union.  This is not a classification of which carrier points remain deep.

The final Tao stress test closes six possible loopholes: after vertical/horizontal removal,
bidegree forces `(1,1)+(1,1)`; the projectivity normal forms include the identity; inseparability
is not conflated with nonreduced total space; split root forms are dense for the complementary
ruling identity; disjoint interpolation blocks enforce squarefreeness; and the `F4` enumeration is
only a regression, not the algebraic-closure proof.  No theorem statement changes.

## 2026-07-24 — C535 modular Hessian--Arf functoriality

C535 closes at the characterized cubic-local exit.  Over every characteristic-two base scheme,
the divided Hessian is the exterior square of the cubic catalecticant; its ordered `(2,2)`
incidence, twisted-cubic collision pullback, and nonsingular Artin--Schreier/Arf torsor commute
with arbitrary base change.  Removing a vertical collision factor does not: the residual family
requires flat or Cartier-preserving, Tor-independent base change.

The first higher-degree test separates the claims sharply.  A quartic's ordinary Hessian is again
a Frobenius square, and two quartics with the same Hessian can lie on opposite sides of the
repeated-root boundary.  But du Plessis--Wall already prove that the direct characteristic-two
quartic invariant `i_3=AD^2+BCD+EB^2` detects repeated roots.  Thus no new direct higher-degree
modular Hessian is claimed.  The ordered separable construction is intrinsically cubic and becomes
all-degree through the canonical contraction `Gamma^n E -> Gamma^3 E`; C525's constrained
consecutive-Hankel pullback remains its nonclassical PRS clause.  The full-text audit also finds
Reeder--Yu's cubic square-root discriminant, so that classical modular observation is explicitly
excluded.  C536 is unblocked as the next coherent polar-flag/Fano test.
