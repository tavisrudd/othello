# Module 54. Projected Stokes variation and middle-extension saturation

**Packet part:** Module 54. Stable index:
`notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md`

**Status:** the projected Stokes-row formula, its dual point-line form, and
the abstract middle-extension saturation theorem below are proved.  They
reduce the first genuine \((1,1)\) receiver overlap to a finite row-projected
variation calculation, or alternatively to a normalized intermediate-
extension identification.  Existing sources do not identify the actual
fixed-phase QDM packet with either receiver, so no unconditional \(m=2\)
statement follows.

## 54.1 The row sees only a projected Malgrange block

Work over a field \(K\).  In the regular-holonomic middle-extension setup of
Malgrange used by Sabbah, let \(\Psi\) be the common nearby-cycle space and
let \(T_i\in\operatorname{GL}(\Psi)\) be the local monodromy at the finite
singularity \(u_i\).  Put

\[
 \phi_i=\operatorname{im}(1-T_i),\qquad
 c_i=(1-T_i):\Psi\longrightarrow\phi_i,\qquad
 v_i:\phi_i\lhook\joinrel\longrightarrow\Psi .                \tag{54.1}
\]

For an admissible ordering, the two directed off-diagonal maps in a pair of
Stokes matrices are

\[
             c_jv_i:\phi_i\longrightarrow\phi_j,
 \qquad
             -c_iv_j:\phi_j\longrightarrow\phi_i.             \tag{54.2}
\]

This is the exact block formula in Sabbah's Corollary 1.5.  Let

\[
                  \rho=\bigoplus_a\rho_a,
             \qquad \rho_a:\phi_a\longrightarrow K            \tag{54.3}
\]

be a normalized row on the Stokes-graded object.  Write \(\iota_a\) and
\(\pi_a\) for the inclusion and projection of the \(a\)-th summand.

### Proposition 54.1 -- projected Stokes-row formula

For one directed pair define

\[
 S^+_{i\to j}=1+\iota_jc_jv_i\pi_i,
 \qquad
 S^-_{j\to i}=1-\iota_ic_iv_j\pi_j.                            \tag{54.4}
\]

Then

\[
 \rho S^+_{i\to j}-\rho
       =(\rho_jc_jv_i)\pi_i,
 \qquad
 \rho S^-_{j\to i}-\rho
       =-(\rho_ic_iv_j)\pi_j.                                  \tag{54.5}
\]

Consequently the normalized row is fixed by the first factor exactly when

\[
           \delta_{j\leftarrow i}:=
             \rho_j(1-T_j)|_{\operatorname{im}(1-T_i)}=0,       \tag{54.6}
\]

and it is fixed by the second exactly when the reverse projected variation
\(\delta_{i\leftarrow j}\) vanishes.

#### Proof

For \(x\in\phi_i\), the only new component of
\(S^+_{i\to j}x\) is \(c_jv_i(x)\) in \(\phi_j\).  Applying
\(\rho\) gives \(\rho_jc_jv_i(x)\).  Every other summand is unchanged.
This proves the first identity; the second is identical with the displayed
sign.  Since \(v_i\) identifies \(\phi_i\) with
\(\operatorname{im}(1-T_i)\), (54.6) is the same map.  \(\square\)

For a Stokes matrix with several off-diagonal blocks, the change on one
source summand is the signed **sum** of the corresponding projected
variations.  Termwise vanishing is sufficient, but cancellation means it is
not necessary in a many-block matrix.  Formula (54.5), rather than a list of
full-block vanishings, is the exact consumer.

### Corollary 54.1A -- products, inverses, and refactorizations

Let \(G_\rho\) be the subgroup of invertible transformations \(g\) with
\(\rho g=\rho\).  Every Stokes factor whose projected variation vanishes
lies in \(G_\rho\).  Hence every ordered product, inverse, or refactorization
made from such factors also fixes \(\rho\).

This is the same subgroup law used by Modules 34 and 37.  It does not require
the Stokes factors to commute.

### Corollary 54.1B -- projectivizing does not weaken a dangerous landing

Assume \(\rho_j\ne0\).  Then the projective row line is preserved by
\(S^+_{i\to j}\),

\[
                     \rho S^+_{i\to j}=a\rho,
                 \qquad a\in K^\times,                          \tag{54.6a}
\]

if and only if \(\delta_{j\leftarrow i}=0\).  The analogous statement holds
for \(S^-_{j\to i}\) when \(\rho_i\ne0\).

#### Proof

The factor \(S^+_{i\to j}\) is the identity on \(\phi_j\).  Restricting
(54.6a) to \(\phi_j\) gives \(\rho_j=a\rho_j\), so \(a=1\).  Proposition
54.1 now says exactly that the projected variation vanishes.  The reverse
direction and the second factor are immediate.  \(\square\)

Thus (54.6) is not an unnecessarily normalized version of the Module 34
projective-line consumer.  In the only dangerous orientation—the one landing
in a row-visible block—it is the exact projective condition.

## 54.2 Full block vanishing is strictly stronger

Sabbah's coalescence criterion proves

\[
 (1-T_j)|_{\operatorname{im}(1-T_i)}=0,
 \qquad
 (1-T_i)|_{\operatorname{im}(1-T_j)}=0,                         \tag{54.7}
\]

from constancy of the complete vanishing-cycle local systems.  Proposition
54.1 consumes only their compositions with the two rows.

The distinction is real.  On \(\Psi=K^3\), choose nilpotents

\[
 N_1(e_2)=e_1,
 \qquad
 N_2(e_1)=e_2,\quad N_2(e_2)=e_3,
\]

with all other basis images zero, and set \(T_a=1+N_a\).  Then

\[
 \phi_1=Ke_1,qquad \phi_2=Ke_2\oplus Ke_3,qquad
 c_2v_1(e_1)=-e_2\ne0.                                        \tag{54.8}
\]

The row \(\rho_2(e_2)=0,\rho_2(e_3)=1\) kills this nonzero block, whereas
the row \(\rho'_2(e_2)=1,\rho'_2(e_3)=0\) detects it.  Thus a proof of
projected vanishing can be genuinely shorter than CDG block vanishing, and
there is also a sharp two-dimensional hostile shear.

There is a useful dual form.  Suppose \(\rho_j\) is represented by a vector
\(p_j\in\phi_j^\vee\) under a perfect pairing.  Then

\[
 \delta_{j\leftarrow i}(x)
       =\langle p_j,c_jv_i(x)\rangle
       =\langle v_i^\vee c_j^\vee p_j,x\rangle .                \tag{54.9}
\]

Hence the directed row law is the single vector equation

\[
                         v_i^\vee c_j^\vee p_j=0.              \tag{54.10}
\]

This is the point-line version of the finite calculation.  Orlov
semiorthogonality or point-purity can imply (54.10) only after an actual
pairing-preserving QDM/vanishing-cycle realization is supplied; algebraic
support labels alone do not type the equation.

## 54.3 The intermediate-extension alternative

The projected-variation route is not the only way to exclude a punctual
confluence defect.  There is an abstract exact substitute for the trait
saturation gate of Module 53.

Let \(j:U\hookrightarrow S\) be the complement of finitely many points in a
smooth curve, and work in the abelian category of perverse sheaves on
\(S\).  Recall that an intermediate extension \(j_{!*}L\) has no nonzero
subobject or quotient supported on \(S\setminus U\).

### Proposition 54.2 -- normalized middle-extension rigidity

Let \(A\) and \(B\) be intermediate extensions and let
\(F:A\to B\) be a morphism whose restriction \(j^*F\) is an isomorphism.
Then \(F\) is an isomorphism.

#### Proof

Exactness of \(j^*\) shows that \(\ker F\) and \(\operatorname{coker}F\)
are supported on \(S\setminus U\).  The kernel is a boundary-supported
subobject of \(A\), and the cokernel is a boundary-supported quotient of
\(B\); both vanish by the defining property of intermediate extension.
\(\square\)

### Corollary 54.2A -- no closed-only row defect

Assume the **normalized** generic primary-row comparison is realized by the
restriction of a morphism between intermediate-extension line objects, and
assume a named exact receiver reads their closed packets, rows, and
coimages.  Then the closed primary-row comparison is an isomorphism.  It
cannot acquire the \(R/(s)\) torsion defect of Module 53.

The hypotheses are load-bearing.  The raw map \(s:R\to R\) is generically
invertible but has a punctual cone; it is not the intermediate extension of
its normalized generic unit.  Ordinary stalks are not silently assumed to
be exact either: the application must name the exact nearby-cycle,
vanishing-cycle, or heart-level reader which produces the actual packet.

## 54.4 The first genuine \((1,1)\) overlap

The coordinate pilot of Modules 41 and 43 has raw weights

\[
 W_{\mathrm{coord}}
   =\{\pm e_1,\pm e_2,-e_1+e_2,0,0\},                          \tag{54.11}
\]

with total character \((-1,1)\).  Adding \((1,-1)\) produces the six
nonzero \(A_2\)-root weights together with two zeros.  The completed window
comparison has unit normalized rank jet.  Modules 49--51 prove that this
completed category neither has the raw phase nor descends to it by naive
open restriction.

Suppose the two incident actual ambient quotient packets are realized as
the two Stokes blocks \(\phi_1,\phi_2\), with the fixed-phase rank rows
\(\rho_1,\rho_2\).  The exact new local target is

\[
 \boxed{
 \rho_2(1-T_2)|_{\operatorname{im}(1-T_1)}=0,
 \qquad
 \rho_1(1-T_1)|_{\operatorname{im}(1-T_2)}=0 .}                 \tag{54.12}
\]

For one chosen sector crossing, only the directed equation actually used
by that crossing is needed; its inverse is then safe by Corollary 54.1A.
Both equations give sector-independent two-sided safety.  After restricting
to a marked source coimage line, each equation is one scalar once the
projected variation is first proved to annihilate the source row kernel.

Alternatively, it is enough to identify the normalized marked coimage on
the resonance trait with the intermediate extension of the generically
calibrated line and to verify that the actual closed fixed-phase packet is
the named exact reading of that object.  Proposition 54.2 then supplies the
closed comparison without a Stokes calculation.

Thus the first pilot now has two precise acceptance tests:

1. compute the directed row-projected variations (54.12); or
2. prove a normalized intermediate-extension and exact closed-reader
   theorem for the marked coimage.

Neither test asks for the full central connection matrix or all Stokes
blocks.

## 54.5 Relation to the punctual Fourier corner

The old dangerous shear

\[
                    v\longmapsto v+c,w,qquad \rho(w)\ne0      \tag{54.13}
\]

is exactly a nonzero matrix coefficient of a projected map (54.6) once an
inverse-Laplace realization identifies \(v,w\) with the corresponding
vanishing-cycle blocks.  Likewise, a parameter-trait intermediate extension
for the normalized coimage excludes a closed-only punctual cone.

These statements do **not** by themselves identify the projected variation
with the signed \(\delta_0\)-multiplicity of the two-variable Fourier corner.
That equality still requires a common two-variable inverse-Laplace/perverse
realization and compatibility of its row reader.  Without it,
\(\operatorname{FL}^{-1}(\delta_0)=\mathcal O\) remains the sharp
countermodel to support-only reasoning.

## 54.6 What the sources supply

- Claude Sabbah, *A short proof of a theorem of Cotti, Dubrovin and
  Guzzetti*, Corollary 1.5 and Proposition 2.2.  The source supplies the
  maps (54.2), identifies full two-sided block vanishing with the two
  cross-monodromy restrictions (54.7), and derives them from constancy of
  complete vanishing-cycle local systems.  Proposition 54.1 is the strictly
  weaker row-projected consequence.  Shared-cache SHA-256:
  `eff6be3ccc4e0a56922e5cff7d2f97c9b57a8e0a6d2fefb04dd1c7a4101cbac8`.
- Hiroshi Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3.
  The master-space Fourier comparison supplies the one-arrow formal block
  decomposition used earlier in the packet.  It does not construct the
  common two-wall regular-holonomic inverse-Laplace object, identify its
  \(T_i\) and rows with the actual fixed-phase packets in (54.12), or provide
  a resonance-trait intermediate-extension reader.
- Spenko--Van den Bergh, *Perverse schobers and GKZ systems*,
  arXiv:2007.04924v3, proves the GKZ comparison for nonresonant parameters.
  Its integral/resonant parameter is explicitly outside that theorem's
  scope.  Moreover, intermediate extension on the GKZ base is not by itself
  an intermediate-extension statement in the parameter trait.  It therefore
  does not supply Corollary 54.2A for the geometric occurrence.
  Shared-cache SHA-256:
  `73dffed6c948ac1dd48de1bab994a09e55e875b29dc69473d1d5d6d1e324fd0d`.

The CDG hypothesis that the full vanishing-cycle local systems are constant
would close (54.12), but it is stronger than necessary and has not been
verified for the QDM overlap.  Good formal structure or a formal Stokes
grading does not imply the missing row-projected identities.

## 54.7 Executable hostile calibrations

The finite replay checks:

- a nonzero full Stokes block whose row projection vanishes;
- the same block with a hostile row giving nonzero leakage; and
- failure of the projective row line to absorb a target-visible shear; and
- closure of row-fixing shears under products and inverses.

These are exact linear-algebra calibrations only.  They do not construct the
inverse-Laplace local system, the occurrence trait, or the actual QDM row.

## 54.8 EJ/TT and mystery ledger

**EJ.** The analytic target has dropped from a full two-wall Stokes matrix
to one directed covector, or to a normalized intermediate-extension line.
The dual point version (54.10) makes an Orlov/purity proof possible without
reconstructing the rest of the vanishing-cycle block.

**TT.** Keep the two middle extensions separate.  Sabbah's middle extension
lives in the pre-Laplace \(\lambda\)-line; the saturation alternative needed
by Module 53 lives in the resonance parameter trait.  A theorem in one
variable cannot be silently used in the other.  Also, full-block constancy
and projected-row constancy are different statements, as (54.8) proves.

| question | status | exact evidence or remaining gate |
|---|---|---|
| Does the row consume the full Stokes block? | **no** | Proposition 54.1 |
| Can a nonzero Stokes block be row-invisible? | **yes** | (54.8) and the finite replay |
| Does passing to the projective row line weaken the dangerous condition? | **no** | Corollary 54.1B |
| What is the dual point-line test? | **one vector equation** | (54.10) |
| Does a normalized intermediate extension acquire punctual torsion? | **no** | Proposition 54.2 |
| Does Sabbah prove the actual QDM projected variation vanishes? | **no** | the QDM inverse-Laplace/row identification is absent |
| Does the nonresonant GKZ schober supply the resonance-trait middle extension? | **no** | parameter and base variables differ; the theorem excludes resonance |
| What remains for the first \((1,1)\) pilot? | **either (54.12) or the normalized trait \(j_{!*}\) adapter, plus actual packet/row fidelity** | Sections 54.4 and 54.6 |
| Does this prove \(m=2\)? | **no** | neither occurrence-level analytic adapter is constructed |

## Boundary

The first consecutive-discrepant overlap no longer asks for a full Stokes
matrix.  In the Malgrange--Sabbah receiver, it asks for the row projection
of one or two explicit cross-variation maps; in the trait receiver, it asks
for a normalized intermediate-extension line with an exact actual-packet
reader.  These are strictly smaller, testable analytic statements.  The
existing QDM, CDG, and nonresonant GKZ sources do not identify the geometric
overlap with either statement, so the local \(m=2\) theorem remains open.
