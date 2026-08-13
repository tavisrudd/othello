# C907 — Gold constancy-and-unit-column attack

Date: 2026-08-13

Status: one-arrow theorem and endpoint product proved; Gold remains open at a
multi-arrow coherence gate.  The explicit large-radius point section repairs
the one-arrow Artin receiver, but independently fixed exceptional parameters
do not compose through weak factorization.  The attempted scalar-constant
banking repair also fails: it does not construct a functorial horizontal
morphism from the formal primitive-sixth packet to the Gamma rank line.  Gold
means irrationality of \(X\times\mathbf P^2\) for every smooth cubic
threefold.  The former attack
asked for the center row of a large-radius-to-cusp connection matrix.  That is
stronger than the rank-functional proof needs.  In the oriented Orlov order,
center admixtures pair to zero against the ambient functional.  The remaining
theorem is a constancy-and-unit-column lemma in a common sectorial receiver,
plus a bounded codimension-two normalization repair.

The same per-arrow architecture is uniform in the stabilization dimension.
Its first application is Gold.  A subsequent rank-telescope audit shows that
the apparent high-codimension ordering issue is invisible to rank; promotion
to Platinum now needs only a final all-codimension source audit rather than a
new mechanism.

## 1. Which proof this repairs

Two conditional \(m=2\) proofs coexist on disk.

1. The Jordan-carrier proof follows an endpoint \(J_3\).  It needs a strict
   enriched blow-up biproduct and exclusion of the same indecomposable from
   every smooth threefold center.
2. The coniveau/rank proof follows

   \[
   \operatorname{rk}(E)=(-1)^{\dim Y}\chi(\mathcal O_p,E)
   \tag{1}
   \]

   on Gamma lifts of the primitive-sixth ambient sector (the sign is `-` in
   Gold's fivefold dimension).  Every exceptional
   Orlov object has ambient rank zero.

This note repairs only the second proof.  If its comparison lemma lands, the
universal threefold carrier theorem is bypassed; it is not proved as a
by-product.

## 2. The oriented Orlov order

Let \(p:\widetilde Y=\operatorname{Bl}_Z Y\to Y\) be a blow-up of a smooth
fivefold along a smooth center of codimension \(c\).  In Shen--Shoemaker's
notation a blow-up has

\[
 s=1,\qquad r=c,\qquad \nu=r-s=c-1.
 \tag{2}
\]

Thus \(1\leq\nu\leq4\) for a nontrivial fivefold blow-up.  Choose \(k=0\) in
their family of semiorthogonal decompositions:

\[
 D^b(\widetilde Y)=
 \left\langle
 Lp^*D^b(Y),D^b_0(Z),\ldots,D^b_{\nu-1}(Z)
 \right\rangle .
 \tag{3}
\]

For every center object \(C\) and ambient object \(A\),

\[
 \chi(C,Lp^*A)=0.
 \tag{4}
\]

The opposite Orlov order gives the reverse Euler orthogonality, not (4).
Therefore “different exponential factors are orthogonal” is unsafe unless the
pairing orientation and phase/order are fixed.

## 3. Sector aperture and the pairing flip

The ambient ray in Shen--Shoemaker is

\[
 \arg(z/q)=\frac{1-s}{\nu}\pi=0,
 \tag{5}
\]

and the center rays are

\[
 \arg(z/q)=-\frac{(2m+1)\pi}{\nu},
 \qquad 0\leq m<\nu.
 \tag{6}
\]

For \(\nu>1\), the center Meijer expansion used in Proposition 7.5 holds on

\[
 \left|\arg(z/q)+\frac{(2m+1)\pi}{\nu}\right|
 <\left(1+\frac1\nu\right)\pi,
 \tag{7}
\]

and the ambient expansion of Proposition 8.2 holds on

\[
 |\arg(z/q)|<\frac\pi2+\frac\pi\nu.
 \tag{8}
\]

The ambient aperture is strictly wider than \(\pi\), the uniqueness width for
the level-one exponentials here.  Remark 1.6 supplies a common choice for the
\(k=0\) order when

\[
 \frac{\nu-6}{4}<0<\frac{3(\nu+2)}4.
 \tag{9}
\]

This is automatic for Gold because \(\nu\leq4\).  Shrinking slightly removes
all boundary rays.

The derivation of (7) explicitly assumes \(\nu>1\); substituting \(\nu=1\)
would give the wrong width.  Appendix A, Theorem A.1 instead sets
\(\epsilon=1/2\).  For \(m=0\), its center sector is

\[
 -\frac{5\pi}{2}<\arg(z/q)<\frac\pi2,
\]

while the tame ambient sector is

\[
 -\frac{3\pi}{2}<\arg(z/q)<\frac{3\pi}{2}.
\]

Their correct common codimension-two sector is

\[
 -\frac{3\pi}{2}<\arg(z/q)<\frac\pi2
 \quad(m=0,k=0),
 \tag{10}
\]

and, for the reversed order,

\[
 -\frac\pi2<\arg(z/q)<\frac{3\pi}{2}
 \quad(m=-1,k=1).
 \tag{11}
\]

Both have width \(2\pi\), contain the relevant tame ray and the
\(z\mapsto e^{-\pi i}z\) pairing flip, and exceed the uniqueness width.

The two-flat-section convention is imported from the Gamma-integral
structure; Shen--Shoemaker do not state it:

\[
 [s_1,s_2)=\langle s_1(e^{-\pi i}z),s_2(z)\rangle,
 \qquad [s(E_1),s(E_2))=\chi(E_1,E_2).
 \tag{12}
\]

For each center block one chooses a ray in the common aperture on which the
first factor after the clockwise flip is recessive and the ambient second
factor is tame.  A constant flat pairing that tends to zero is zero, giving
(4) analytically.  In codimension two the unique center exponent is
\(\lambda=-q\), its solution factor is \(e^{q/z}\), and (10) contains both
required rays.

This proves one oriented triangularity direction.  It does not determine the
opposite half of the center row, and Gold does not need that half.

## 4. Center-row invisibility

Write an analytically continued point section schematically as

\[
 s_{\mathrm{pt}}^{\mathrm{LR}}
 =s_{\mathrm{pt}}^{\mathrm{amb}}
  +\sum_j a_j s_j^{\mathrm{ctr}}.
 \tag{13}
\]

For an ambient branch \(s_A^{\mathrm{amb}}\), (4) and (12) give

\[
 [s_j^{\mathrm{ctr}},s_A^{\mathrm{amb}})=0,
 \tag{14}
\]

and hence

\[
 [s_{\mathrm{pt}}^{\mathrm{LR}},s_A^{\mathrm{amb}})
 =[s_{\mathrm{pt}}^{\mathrm{amb}},s_A^{\mathrm{amb}}).
 \tag{15}
\]

The rank functional never reads the coefficients \(a_j\).  Equation (15) does
not prove they vanish and does not restore the retracted universal
point-covector theorem.

## 5. What Shen--Shoemaker supply

Shen--Shoemaker prove a Gamma/Orlov asymptotic theorem for projective bundles,
blow-ups, and standard flips after restricting quantum multiplication to the
extremal curve ray.  Their asymptotics take \(z\to0\) at a fixed nonzero
complex value of \(q\); \(q\) is analytic here, not formal.

Their tame conclusion is not generic in the argument.  Definition 1.3 and
Theorem 1.4 select the ray (5).  What saves Gold is the common aperture of
Remark 1.6 and (7)--(11), not coverage of every generic ray.

The source already proves the following parts that had been assigned to a new
degeneration lemma.

- Lemma 9.4 constructs the Rees deformation of a bundle extension and gives
  canonical cohomology identifications under which the extremal flat solution
  operators \(\Phi^T(q,z)\) and cohomological Fourier--Mukai maps agree.
- Lemmas 9.5--9.6 use flag pullback and repeated extension splitting;
  Corollary 9.7 transports the strong asymptotic statements to arbitrary local
  models.
- Theorem 9.9 and Proposition 9.10 compare the global extremal descendant
  fundamental solution coefficientwise with the normal local model.
- Theorem 9.14 identifies the Gamma image of the ambient Fourier--Mukai
  component as a strong tame asymptotic class.

There are two exact boundaries.

### 5.1 Extremal specialization

All non-extremal Novikov variables are set to zero.  The cubic
primitive-sixth atoms live in the ambient variables and merge into the tame
ambient cluster at this specialization.  Remark 8.6 expects a full-variable
analogue using Brown's toric-bundle \(I\)-functions but does not prove it.

The correction is not to analytically deconfluence the atom.  The safe proof
never follows an atom to \(Q=0\); Section 7 factors it out as intrinsic data of
the base variety.

### 5.2 Codimension-two normalization

Theorem 4.4 assumes \(r-s>1\) for its \(J\)-function formula, and Section 7's
nonzero-exponential derivation again invokes this assumption.  Remark 4.5(3)
says that for \(r-s\leq1\) the displayed series is an \(I\)-function on
Givental's cone rather than the \(J\)-function.  Theorems 1.4 and 9.14 omit
the restriction, but their strict dependency chain does not supply the
\(\nu=1\) bridge.

There is a short internal repair.  In formula (35), when
\((r,s)=(2,1)\), the positive-degree \(d\) term has \(z\)-order

\[
 1+s(d-1)-rd=-d.
 \tag{16}
\]

Thus the displayed series actually has the required
\(ze^{t/z}+O(z^{-1})\) normalization, contrary to the blanket warning in
Remark 4.5(3).  The same remark states that the series lies on Givental's
cone.  Cone membership plus (16) identifies it with the \(J\)-function by
uniqueness of the standard \(J\)-slice.  This repairs the tame proof's input;
the full argument and corrected Appendix-A sector are in
`2026-08-13-c907-shen-shoemaker-codim2-repair.md`.

## 6. Exact rings and the constancy bridge

Iritani's full formal decomposition is over

\[
 R_{\mathrm{cusp}}
 =\mathbf C[z]((q^{-1/s_0}))[[Q,\widetilde\tau]],
 \tag{17}
\]

where \(q=\infty\) is the exceptional Laurent cusp and \(s_0\) is a
ramification index.  Theorem 5.18 and formulas (5.41)--(5.43) say that the
ambient and center summands are preserved by every \(\nabla_{Q_i}\), that the
decomposition \(\Psi\) commutes with these connections, and that it
intertwines the pairing.

Shen--Shoemaker work instead on the analytic extremal slice

\[
 Q=0,\qquad q\in\mathbf C^*,\qquad z\to0
 \text{ in the sectors (7)--(11)}.
 \tag{18}
\]

These coefficient settings are not identified as full solution completions.
The required smaller bridge is a receiver obtained by fixing a nonzero \(q\)
in an overlap domain, shrinking one common
\(z\)-sector, and take sectorial functions in \(z\) with coefficients formal
in \(Q\).  Only block-level summation is performed.  The confluencing atoms
inside the ambient block are never split.

The receiver now exists.  Evaluate Iritani's positive-`z` formal gauge at a
fixed nonzero `q` coefficientwise, reduce the formal Novikov ring modulo each
finite ample-energy Artin quotient, and apply ordinary level-one
multisummation.  Nilpotent parameter corrections do not move scalar
anti-Stokes rays, and uniqueness makes the finite-level gauges compatible.
The inverse limit is the desired formal-parameter sectorial gauge.  The
complete proof, including the genus-zero dimension bound that makes every
finite-level `q` dependence polynomial, is in
`2026-08-13-c907-formal-novikov-sectorial-receiver.md`.

The resulting block lifts have literal constant pairings:

\[
 \partial_{Q_i}[s_1,s_2)=0.
 \tag{19}
\]

This remains smaller than a full-variable asymptotic decomposition.  It uses
only center-versus-unsplit-ambient separation and never analytically
continues a large-radius `q`-series through the Laurent cusp.

## 7. Never specialize the atom

The primitive-sixth atom's exponential is \(O(Q)\).  Its subline inside the
ambient block is therefore not defined over \(\mathbf C[[Q]]\) at \(Q=0\).
Factor the measured functional instead as

\[
 \underbrace{\text{coordinates of the blow-up point in the ambient
 large-radius frame}}_{\text{comparison datum}}
 \quad\times\quad
 \underbrace{\text{the base's intrinsic LR-to-atom matrix}}_{
 \text{unchanged across the arrow}}.
 \tag{20}
\]

The second factor is the same object on both sides of the blow-up arrow and is
never evaluated at \(Q=0\).  Only the first factor is compared.  It is defined
before the ambient atom splits and has no confluence problem.

This yields the sharp remaining statement.

> **Constancy-and-unit-column lemma.** In the common receiver of Section 6:
>
> 1. the ambient and center sectorial block lifts are jointly
>    \(\nabla_Q\)-flat;
> 2. the pairings extracting the point section's block coordinates are
>    independent of \(Q\) by (19);
> 3. at \(Q=0\), the oriented Shen--Shoemaker asymptotics and (12) kill every
>    center contribution to the ambient rank functional; and
> 4. the ambient coordinate matrix of \(s(\mathcal O_p)\), in the pulled-back
>    large-radius frame of the base, is the unit column.

Item 4 is exact.  At \(Q=0\), positive exceptional-degree stable maps lie in
the exceptional divisor and cannot meet a point chosen off it.  The intrinsic
large-radius point column therefore has no exceptional \(q\)-tail, lies in
both solution completions, and formula (5.44) sends it to
\(\mathrm{pt}\oplus0\).  This legal overlap calculation is proved in
`2026-08-13-c907-extremal-point-unit-column.md`.

The lemma gives, for every base primitive-sixth Gamma branch \(s_A\),

\[
 [s^{\mathrm{LR}}_{\mathcal O_p},\widetilde s_A)
 =[s^{\mathrm{LR}}_{\mathcal O_{p(Y)}},s_A),
 \tag{21}
\]

where \(p\) is chosen off the center.  Arbitrary center admixture is allowed
and is killed by (14).  Equation (21) compares only the unsplit ambient
large-radius frame; the base's LR-to-atom matrix is multiplied afterward.

## 8. Gold implication and assembly

The cubic Barnes calculation proves that the rank functional is nonzero on
both primitive-sixth ambient lines.  Projective five-space has empty
primitive-sixth sector.  Equation (21) holds for every individual blow-up
arrow by the receiver lemma.  If a primitive-sixth vector on a blow-up has nonzero rank,
its ambient projection has nonzero rank because every exceptional projection
has rank zero.  This gives the reverse statement for a blow-down without
choosing an inverse sectorial gauge.  Iteration is not yet legal.  After two
arrows, the first nonzero exceptional parameter becomes a formal ambient
variable for the second, and no map evaluates an arbitrary formal series at
that nonzero value.  Moreover, horizontal scalar constancy does not repair
this by itself: the two receivers can embed the intermediate `z=0` formal
packet differently by a Stokes shear.  The exact gate is a functorial
morphism `P_6 -> 1`, a proof that the relevant Stokes transitions preserve
the Gamma rank restriction, or one coherent two-arrow/whole-zigzag receiver.
See `2026-08-13-c907-formal-constant-banking.md`.

Quantum Kunneth and product naturality of the extended Gamma integral
structure give \(m+1\) copies of the cubic packet on
\(X\times\mathbf P^m\), with nonzero product rank functional.  Projective
space has no primitive-sixth formal packet.  For \(m=2\), these endpoint facts
would contradict a birational map to \(\mathbf P^5\) once the common zigzag
receiver is constructed.  The exact product and conditional telescope are in
`2026-08-13-c907-rank-telescope-and-product.md`.
No universal threefold carrier theorem, center-row computation, or
point-purity degeneration lemma occurs in its critical path.

## 9. Platinum boundary

The constancy-and-unit-column mechanism is per-arrow and does not mention
\(m\).  The tame aperture has width \((1+2/\nu)\pi>\pi\) for every \(\nu\),
so uniqueness itself does not fail.  The `k=0` ordering window first fails at
exactly \(\nu=6\), hence first for \(m=4\): \(\nu=c-1\), while
\(c\le3+m\).  Thus `k=0` covers Gold and all of `m=3`.

The full window has width \(\nu/2+3\) and always contains an allowed integer
`k`.  More importantly, the rank telescope is unchanged when `k` is nonzero:
all `O(kE)`-twisted center objects remain supported on the exceptional divisor
and have rank zero, while the ambient functor remains pullback.  The first
nonzero-`k` arrows are codimension-seven point blow-ups in sevenfolds, and
their center packets are empty in any case.

The all-codimension source audit is clean.  Gold and Platinum therefore share
the same honest residue: a coherent realization of the Gamma rank morphism on
the formal primitive-sixth packet across incident arrows.  No carrier theorem
or new codimension-dependent asymptotic mechanism is expected.

## 10. Publishable stepping stone

A focused source-extension package now exists independently of the Gold
application:

1. the oriented flat-pairing lemma, including the fivefold common-aperture
   bound and the correct \(\nu=1\) sectors;
2. the codimension-two \(I\)-to-\(J\) repair;
3. the Artin-quotient formal-parameter sectorial receiver and explicit
   extremal unit column, weaker than a full Stokes decomposition; and
4. the conditional rank telescope and cubic-stabilization application.

Items 1--2 are self-contained as a correction/extension section.  A
standalone publication claim still requires the normal novelty and priority
audit.  Items 3--4 supply a substantially larger paper architecture if the
multi-arrow receiver is added.

## AA / EJ / TT / mystery ledger

- **AA:** attack the unsplit ambient large-radius coordinates, not the atom
  and not the center row.  Use flatness for constancy only after constructing
  the formal-parameter sectorial receiver; use the \(\nu=1\) unit-column
  calculation as the first exact regression.
- **EJ:** reverse the SOD order as a falsifier.  In the center-first order,
  \(\chi(C,Lp^*A)\) need not vanish.  Also substitute \(\nu=1\) into the
  printed Proposition 7.5 aperture: the wrong width exposes the hidden
  hypothesis immediately.
- **TT:** name both coefficient settings.  Constancy in \(Q\) does not itself
  identify the \(q=\infty\) formal receiver with a fixed-\(q\) analytic one;
  the Artin-quotient construction is the needed common block-level receiver.
- **Settled:** center-row invisibility; Gold aperture; codimension-two
  \(I\)-to-\(J\) repair; extremal point unit column; the formal-Novikov
  one-arrow sectorial receiver; block-level constancy; the all-codimension
  source audit; and the \(X\times\mathbf P^2\) product step.
- **Open:** the common multi-arrow receiver.  Independent fixed-`q` Artin
  receivers cannot be composed because old exceptional variables become
  unevaluable formal ambient series.  A formal novelty/priority audit is also
  required before publication claims.

## Sources

- Y. Shen, M. Shoemaker, *Quantum spectrum and Gamma structure for standard
  flips*, arXiv:2502.08762v2, especially Theorems 1.4 and 4.4, Remark 1.6,
  Remark 4.5, Remark 8.6, Lemmas 9.4--9.6, Theorem 9.9, Proposition 9.10,
  Theorem 9.14, and Appendix A.  Shared-cache SHA-256:
  `2c1d25490d53d1eb04da11e4ad8eec2d9834b25e765462186181292e7f085cce`.
- H. Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3, Theorem
  5.18, formulas (5.41)--(5.43), and Section 5.8.
- H. Iritani, *Gamma classes and quantum cohomology*, arXiv:2307.15938v1,
  Section 1.2.
- T. Dreyfus, *A density theorem in parameterized differential Galois
  theory*, arXiv:1203.2904v4, Sections 1.2--1.4.  Shared-cache SHA-256:
  `927b043d9af6759673cd28be74dfe1765373e60bf6e9c94821a80dd0700dccc0`.
