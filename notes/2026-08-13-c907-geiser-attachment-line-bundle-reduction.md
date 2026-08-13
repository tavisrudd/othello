# C907 — Geiser attachment as a Novikov-line continuation problem

Date: 2026-08-13

Status: Geiser peak theorem, hostile-audited and repaired.  The two
point-blowup receivers and the middle-flop comparison lie on one analytic
path after the nonextremal Novikov degree is treated as a line bundle over
the extremal Kahler coordinate.  LLW's graph correspondence is the
regular-at-`z=0` gauge transporting the primitive-sixth packet;
Chen--Tseng identify the same horizontal continuation in the large-`z`
Gamma framing and therefore transport the point/rank row.  Dreyfus is used
only on nonturning endpoint polydiscs to identify the sectorial receivers.
The complete point-centred Geiser peak, and its product with `P^2`, preserve
the Gamma rank Boolean.  This closes one peak class, not Gold.  Exact hostile
audit: `2026-08-13-c907-geiser-parameterized-continuation-hostile-audit.md`.

## 1. The apparent incompatibility

For the Geiser peak use the curve bases

\[
 (e,c)\quad\text{on }Y=\operatorname{Bl}_pX,
 \qquad
 (e',c')\quad\text{on }Y^+,
\]

where `e,e'` are point-exceptional lines and `c,c'` are the effective
flopping curves.  The middle flop gives

\[
 c'=-c,\qquad e'=e+3c.
 \tag{1}
\]

Thus, for `q=Q^e`, `s=Q^c`, `q'=Q^{e'}`, `s'=Q^{c'}`,

\[
 s'=s^{-1},\qquad q'=qs^3.
 \tag{2}
\]

The left and right large-radius rings are `C[[q,s]]` and `C[[q',s']]`.
Neither origin lies in their Laurent overlap.  Holding `q` fixed while
continuing `s` sends `q'` to infinity; holding `q'` fixed forces
`q=q's^{-3}`.  This is the exact failure of all fixed-parameter banking
proposals.

## 2. Quotient degree is a Novikov line, not a global coordinate

Lee--Lin--Qu--Wang index ordinary-flop series by a curve class modulo the
extremal ray.  Here

\[
 N_1(Y)/\mathbf Zc\cong\mathbf Z[e]
 \cong N_1(Y^+)/\mathbf Zc'.
\]

For quotient degree `a`, the left effective representatives are

\[
 ae+bc,\qquad b\ge0,
\]

while the corresponding right representative is

\[
 ae'+(3a-b)c'.
\]

The monomial equality is

\[
 q^as^b=(q')^a(s')^{3a-b}.
 \tag{3}
\]

Equation (3) means that `q` and `q'` are local frames of the same quotient
Novikov line over the compactified `s`-sphere, with transition `s^3`.
Equivalently, choosing the shifted source lift `e+3c` makes its local monomial
`qs^3` equal to `q'`.  The source extremal series then has a finite Laurent
tail down to `s^{-3a}` rather than being a power series.  This is harmless:
each quotient degree is treated separately, exactly as in LLW.

The correct common object is therefore not a bidisk with one global
nonextremal coordinate.  It is the completed direct sum of the powers of
this Novikov line, with analytic continuation in `s` and formal completion
in its fibre degree.

## 3. Local finiteness is exact

On `Y`,

\[
 c_1(Y)=2(H-E),\qquad
 c_1(Y)\cdot e=2,\qquad c_1(Y)\cdot c=0.
\]

For a genus-zero coefficient of degree `ae+bc`,

\[
 \operatorname{vdim}_{\mathbf C}\overline M_{0,n}(Y,ae+bc)=n+2a.
\]

Fixed homogeneous insertions and descendant powers therefore fix `a`.
The only infinite sum is the extremal `b`-series, precisely the series LLW
prove analytic and continue by `s'=s^{-1}`.  After product with `P^2`, a
base-line degree adds `3d` and the same conclusion holds coefficientwise.

Hence the proposed path requires no illegal map `C[[q]] -> C` and no
unproved convergence in the transverse degree.  It is a locally finite
formal family of one-variable analytic continuations.

## 4. Endpoint sectors have enough aperture

For either codimension-three point blowup, Shen--Shoemaker has
`r=3`, `s=1`, `nu=2`.  With the balanced Orlov normalization `k=1`, the two
center indices are `m=-1,0`, and the whole decomposition has the common
sector

\[
 -\pi<\arg(z/q)<\pi.
 \tag{4}
\]

An off-center point belongs to the tame/ambient block, whose own sector is
already (4).  On a positive-real continuation path, (2) preserves the phase
of the two local frames `q,q'`; the same `z`-sector can be used at both ends.
Thus neither sector width nor the pairing flip is the obstruction.

## 5. The endpoint formal-primary lemma

Let `A_L` be the whole ambient block in the left point-blowup comparison and
`A_R` the whole ambient block on the right.  At the respective endpoint
germs the leading irregular eigenvalues of the point-exceptional center
blocks are nonzero multiples of `q` or `q'`, whereas the ambient cluster
conflues at zero.  Therefore each ambient cluster is spectrally separated
from its point-exceptional center clusters when its local Novikov frame is
nonzero.

The needed statement is:

> **Endpoint formal-primary lemma.**  On a nonturning endpoint polydisc, the
> formal ambient projector supplied by the point-blowup comparison has a
> canonical sectorial realization on (4), holomorphic in the
> quotient-Novikov-line parameter and jointly flat.  Along a path avoiding
> the level-changing, turning, singular, and primitive-sixth resonance loci,
> the intrinsic formal-primary packet and Gamma point section transport to
> the corresponding right endpoint objects.

Only whole clusters occur in this statement.  The cubic primitive-sixth atom
is allowed to confluence at the endpoint and is restricted only after the
whole-block identity has been transported to a nonzero interior parameter.
This avoids the false deconfluence move.

This lemma follows from parameterized irregular-connection theory together
with the distinction between the regular LLW gauge and the large-`z`
Chen--Tseng transformation.

**Proof.**  Work first near the left endpoint with `q ne 0`.  At `s=0`, the
two point-exceptional exponential values are nonzero multiples of `q`, while
the entire ambient cluster has exponential value zero.  A small contour in
the spectral plane gives a holomorphic Riesz projector for the leading Euler
quantum product.  The recursive **formal** block diagonalization has
Sylvester denominators given by ambient--center eigenvalue differences,
which are units after shrinking.  It yields a unique parameter-holomorphic
formal projector with this leading term.  It does not give a convergent
analytic block gauge; the possible off-diagonal Stokes extension is retained.

Apply Dreyfus Proposition 1.3 after shrinking to a polydisc on which the
levels are constant.  As required before his Proposition 1.13, also remove
collisions of singular directions and points where the specialized formal
type differs from the parameterized one.  Proposition 1.13 and Lemma 1.14
then give the sectorial sum in a continuously nonsingular direction and
commutation with parameter derivatives.  Integrability supplies the remaining
joint-flatness statement: a parameter-covariant derivative of the summed
projector has zero formal germ, hence vanishes by sectorial uniqueness.  The
balanced sector (4) supplies the endpoint direction.

The same argument applies at the right endpoint.  Between the endpoints,
LLW prove that every fixed quotient-degree series is analytic in the
extremal coordinate and remains formal in the quotient degree.  Section 3
shows that, for the small connection used here, each matrix coefficient is
actually locally finite in that degree, so the quotient parameter can be
evaluated along the correlated path.

Remove from the nonzero total space of the quotient-Novikov line the ordinary
singular, level-changing, turning, and primitive-sixth resonance loci.  They
are proper analytic loci by the endpoint separation.  Their complement is
path-connected; choose a path joining the two endpoint neighbourhoods and
cover its compact image by finitely many Dreyfus polydiscs.  Choose a
continuous lifted nonsingular `z` direction.  The normalized formal-primary
projector is unique on overlaps, so its sectorial sums agree; no Stokes wall
is crossed by this lifted direction.  Equivalently, continue at one fixed
`z ne 0` and use Dreyfus only to identify the endpoint asymptotics, avoiding
any need for a uniform lower bound on Dreyfus's radius `epsilon(t)`.

There are now two comparison maps.  LLW identify the analytically continued
quantum differential equations by the cohomological graph correspondence.
This gauge is independent of `z`, hence regular at `z=0`, and transports the
formal `P6` packet.  Chen--Tseng's `U` is the matrix of the same horizontal
continuation in the two large-`z` descendant frames; it lives in the
multivalued Givental space and is not being asserted regular at `z=0`.
Their Theorem 0.2 identifies that horizontal map with Fourier--Mukai transport
on the Gamma lattice, so it sends the off-exceptional Gamma point section to
the corresponding right point section.  Thus the regular gauge transports
the packet and the Gamma/FM square transports the covector.  This proves the
lemma. `square`

The possible change of formal level at `s=0` in Dreyfus's Example 1.5 is not
a counterexample: the proof first separates the whole ambient cluster from
the nonzero point-exceptional clusters and applies the parameterized theorem
on punctured ambient parameter domains.  It never specializes the internal
cubic exponential splitting through its confluence point.

## 6. Closure of the Geiser peak

1. The left Gu--Yu--Yu/Shen--Shoemaker receiver identifies the endpoint
   cubic rank Boolean with the restriction of the intrinsic Gamma rank row
   to `P_6(Y)` inside `A_L`.
2. Continue along the quotient-Novikov line and the extremal coordinate.
   LLW's regular graph gauge transports the formal-monodromy packet;
   Chen--Tseng's Gamma/Fourier--Mukai square fixes the off-exceptional point
   class and transports the rank row across the middle flop.
3. The lemma identifies the result with `A_R` in the right balanced receiver.
   The right point-blowup theorem then identifies its Boolean with that of
   the target cubic.
4. Tensoring the entire construction with the small QDM of `P^2` preserves
   the point row, the aggregate primitive-sixth packet, and the continuation.

Therefore rank-Boolean invariance holds for the complete Geiser peak and for
its product with `P^2`:

\[
 \boxed{
 \mathfrak r_{X\times\mathbf P^2}|_{P_6}\ne0
 \iff
 \mathfrak r_{X'\times\mathbf P^2}|_{P_6}\ne0.}
 \tag{5}
\]

This does not prove Gold: a general fivefold weak factorization has peaks
other than the Geiser link.  It does, however, reduce the first genuine peak
from an undefined frame comparison to one named analytic lemma with all
algebraic and angular hypotheses explicit.

## 7. Boundaries and regressions

1. The theorem concerns a general point `p` with six distinct Atiyah curves.
   Degenerate points, colliding lines, or nonordinary tangent sections require
   a separate limiting argument.
2. It uses the finite-disjoint extension of Chen--Tseng proved in
   `2026-08-13-c907-geiser-peak-descendant-intertwiner.md`; the published
   theorem itself states one connected simple-flop center.
3. Product with `P^2` is obtained by small-QDM Kunneth naturality.  It is not
   an invocation of the unproved general ordinary-flop extension in
   Chen--Tseng Remark 3.1.
4. The path is chosen in the nonturning locus with one continuously lifted
   nonsingular direction.  A proof that crosses a Stokes wall would require
   an extra invariance argument and is not used here.
5. Nothing here says that every peak in a smooth fivefold factorization is a
   Geiser peak.  Global Gold retains the peak-coverage/classification gate.

## Sources

- J.-C. Chen and H.-H. Tseng, *Descendant and Fourier--Mukai equivalences
  for simple flops*, arXiv:2604.09962v1, especially Theorem 0.2 and Section
  3.  Cached PDF SHA-256:
  `edee1bc9cce58e216ec5973dd409a72de80db593820a912ed54325773edef6df`.
- Y.-P. Lee, H.-W. Lin, F. Qu, and C.-L. Wang, *Invariance of quantum rings
  under ordinary flops III*, arXiv:1401.7097, Theorem 0.1.1 and Sections
  1.2--1.3.  Cached PDF SHA-256:
  `eeb1d87ae279a04c0ce5e9df66ce820aa87443fa6494f21d24269891a905b19c`.
- Shen--Shoemaker, arXiv:2502.08762v2, equations (64), (78), and Remark 1.6,
  for the endpoint sectors.  Cached PDF SHA-256:
  `2c1d25490d53d1eb04da11e4ad8eec2d9834b25e765462186181292e7f085cce`.
- T. Dreyfus, *A density theorem for parameterized differential Galois
  theory*, arXiv:1203.2904, Proposition 1.3, Proposition 1.13, and Lemma 1.14,
  for parameterized Hukuhara--Turrittin forms, parameter-meromorphic
  sectorial sums, and commutation with parameter derivatives.  Cached PDF
  SHA-256:
  `927b043d9af6759673cd28be74dfe1765373e60bf6e9c94821a80dd0700dccc0`.

## EJ / TT / AA

- **EJ:** `q'=qs^3` is best read as the transition of a Novikov line.  In
  quotient degree, LLW already performs exactly the required Laurent
  reindexing.  The fixed-parameter contradiction disappears without ever
  evaluating a formal series at an unauthorized point.
- **TT:** line-bundle reindexing does not itself compare sectorial fibre
  functors.  The comparison uses a formal/sectorial endpoint projector,
  LLW's regular gauge for `P6`, and Chen--Tseng's large-`z` Gamma/FM square
  for the point row.  Conflating the last two maps reopens the frame gap.
- **AA:** this closes one peak, not a globalization theorem.  The next C907
  question is peak coverage in dimension five, not another Geiser
  continuation calculation.
