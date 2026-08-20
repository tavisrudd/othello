# Module 40. Resonant GKZ saturation and the overlap valuation

**Packet part:** Module 40.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** the DVR and derived saturation theorems are proved; the cited HMS
theorem supplies an independent crepant toric trivial-parameter rank
precedent, not the fixed-phase QDM occurrence provider; the discrepant
fivefold overlaps still need an occurrence-uniform trait realization,
generic calibration, saturation theorem, and exact coimage base change

## 40.1 Why nonresonant GKZ does not specialize for free

There are two distinct theorems in the current GKZ/window literature.

1.  Spenko--Van den Bergh identify the quasi-symmetric GKZ perverse sheaf
    with their GIT schober decategorification for a **nonresonant** parameter
    \(\alpha\), with \(h=\exp(2\pi i\alpha)\).  Their Theorem 1.6 does not
    include the geometric specialization \(h=1\): the discussion immediately
    following the theorem observes that \(h=1\) corresponds to integral
    \(\alpha\), at the opposite extreme from nonresonance, and leaves the
    resonant case to future work.
2.  Their later HMS theorem independently treats the trivial-parameter GKZ
    system for
    a projective crepant resolution of a Gorenstein affine toric variety,
    under its stated star-shaped/scheme hypotheses.  It identifies the
    monodromy action on \(K_0(X)_{\mathbf C}\) with the trivial-parameter GKZ action and
    places it in the equivariant exact sequence
    \[
      0\longrightarrow X(T)
       \longrightarrow K_0(\operatorname{coh}\partial X)
       \longrightarrow K_0(X)
       \xrightarrow{\operatorname{rk}}\mathbf Z
       \longrightarrow0.                                      \tag{40.1}
    \]
    The natural equivariant comparison with the companion Gauss--Manin exact
    sequence makes the final \(\mathbf Z\)-quotient trivial under monodromy.
    Thus the rank quotient is protected for this independent
    \(\beta=0\) GKZ action in that crepant toric range.  This is not a theorem
    that a nonresonant family specializes or is saturated.

The second theorem is a genuine positive **precedent** for Module 39: the
resonant GKZ action can preserve exactly the rank quotient that we consume.
It is not, by itself, an identification with the fixed-phase QDM occurrence
map, and it does not cover a general consecutive-discrepant overlap.  In
particular, a neutral curve class has \(c_1\)-degree zero, but this does not
make either incident wall representation quasi-symmetric or make its
birational model crepant.

The correct question is therefore not whether a generic comparison exists.
It is whether that comparison is **saturated at the integral parameter**.

## 40.2 The marked saturation theorem

Let \(R\) be a discrete valuation ring with uniformizer \(s\), fraction field
\(K\), and residue field \(k=R/(s)\).  Think of \(s\ne0\) as a nonresonant
parameter and \(s=0\) as the geometric integral parameter.

Let \(Q\) be a finite \(R\)-module and let

\[
             p:R\longrightarrow Q                              \tag{40.2}
\]

be the marked point/rank section.  Suppose that its generic fibre

\[
             p_K:K\xrightarrow{\sim}Q_K                         \tag{40.3}
\]

is an isomorphism.  Define the resonant defect

\[
             T_p:=\operatorname{coker}(p).                       \tag{40.4}
\]

### Theorem 40.1 -- marked DVR saturation

Under (40.3):

1. \(p\) is injective and \(T_p\) is a finite torsion \(R\)-module;
2. the following are equivalent:
   \[
   T_p=0;
   \quad T_p\text{ is torsion-free};
   \quad Rp\subset Q\text{ is saturated};
   \quad p_k:k\longrightarrow Q\otimes_Rk\text{ is an isomorphism};       \tag{40.5}
   \]
3. there are unique positive integers \(n_1,\ldots,n_r\), up to order,
   such that
   \[
      T_p\cong\bigoplus_{j=1}^r R/(s^{n_j}),
      \qquad
      \mu_{\mathrm{res}}(p):=\operatorname{length}_R(T_p)
        =\sum_j n_j.                                             \tag{40.6}
   \]

Thus a generic one-dimensional marked quotient specializes to the desired
one-dimensional marked quotient exactly when its resonant defect vanishes.

#### Proof

If \(a\in\ker p\), then \(a\) vanishes after tensoring with \(K\).  Since
\(R\hookrightarrow K\), this forces \(a=0\).  The generic fibre of the
cokernel is zero by (40.3), so every element of the finite module \(T_p\) is
killed by a power of \(s\).

A torsion module over a domain is torsion-free only when it is zero.  This is
also exactly the saturation condition for \(Rp\subset Q\).  Right exactness
after tensoring (40.2) with \(k\) gives

\[
       k\xrightarrow{p_k}Q\otimes_Rk\longrightarrow T_p/sT_p
       \longrightarrow0.                                       \tag{40.7}
\]

Hence surjectivity of \(p_k\) forces \(T_p/sT_p=0\), and Nakayama gives
\(T_p=0\).  The converse is immediate.  If \(T_p=0\), then \(p_k\) is an
isomorphism.  Finally, (40.6) is the structure theorem for finite torsion
modules over a DVR.  \(\square\)

The smallest hostile model is

\[
     Q=R\,p\oplus R/(s)\,e.                                     \tag{40.8}
\]

Its generic fibre is exactly \(Kp\), while its resonant fibre is
\(kp\oplus ke\).  The extra class is invisible on the nonresonant locus and
appears only at \(s=0\).  This is the algebraic form of the punctual Fourier
corner that Module 39 cannot discard.

### Corollary 40.1A -- the overlap index is a Writer law

Let \(L,L'\) be free rank-one \(R\)-modules and let
\(f:L\to L'\) become an isomorphism over \(K\).  After choosing bases,

\[
              f=u s^{\nu(f)},
              \qquad u\in R^\times,
              \quad \nu(f)\in\mathbf N.                         \tag{40.9}
\]

Then

\[
 \nu(f)=\operatorname{length}_R\operatorname{coker}(f),
 \qquad
 f_k\text{ is an isomorphism}\Longleftrightarrow\nu(f)=0,        \tag{40.10}
\]

and for composable maps

\[
                         \nu(gf)=\nu(g)+\nu(f).                  \tag{40.11}
\]

This is the resonant analogue of Module 39's crossed Writer defect.  Units
are forgotten; the nonnegative valuation is the entire obstruction for an
integral forward transition.  If arbitrary lattice identifications are
allowed, the relative index is \(\mathbf Z\)-valued and inverses negate it.

## 40.3 The derived defect

The overlap comparison may naturally be a complex rather than one module.
The same obstruction persists.

### Theorem 40.2 -- derived marked saturation

Let \(C\) be a bounded complex of finite free \(R\)-modules and suppose

\[
                         C\otimes_RK\simeq0.                     \tag{40.12}
\]

Then every \(H^i(C)\) is finite torsion, and the following are equivalent:

\[
 C\simeq0;
 \qquad
 C\otimes_R^{\mathbf L}k\simeq0;
 \qquad
 H^i(C)\text{ is torsion-free for every }i.                      \tag{40.13}
\]

#### Proof

Localization is exact, so (40.12) makes every finite \(H^i(C)\) torsion.
The universal-coefficient sequence over the DVR is

\[
 0\longrightarrow H^i(C)\otimes_Rk
  \longrightarrow H^i(C\otimes_R^{\mathbf L}k)
  \longrightarrow
  \operatorname{Tor}_1^R(H^{i+1}(C),k)
  \longrightarrow0.                                             \tag{40.14}
\]

If the middle terms vanish, then \(H^i(C)/sH^i(C)=0\) for every \(i\), so
Nakayama gives \(H^i(C)=0\).  Conversely an acyclic complex has acyclic
derived fibres.  Finally, a finite module which is both torsion and
torsion-free is zero.  \(\square\)

Perfectness does not replace saturation.  The two-term perfect complex

\[
                         [R\xrightarrow{s}R]                     \tag{40.15}
\]

is generically acyclic, but its closed fibre has zero differential and one
copy of \(k\) in each of two adjacent cohomological degrees.  A derived GKZ
or schober family therefore needs cohomological strictness at resonance, not
merely a perfect family of terms.

Categorically, restriction to the punctured trait

\[
 j^*:D^b_{\mathrm{coh}}(R)\longrightarrow D^b_{\mathrm{fd}}(K)              \tag{40.16}
\]

forgets the entire subcategory supported at \((s)\).  A generic window/GKZ
theorem proves only that the comparison cone lies in this kernel.  Theorem
40.2 identifies the missing closed-fibre question: is that supported cone
zero?

## 40.4 A finite Gamma-valuation test

Once an overlap coefficient is written in normalized Mellin--Barnes form,
its resonance index is elementary.

### Proposition 40.3 -- Gamma order at an integral parameter

Let

\[
 F(s)=u(s)
  \prod_j\Gamma(n_j+a_js)^{\epsilon_j}
  \prod_\ell(1-e^{2\pi i b_\ell s})^{\delta_\ell},               \tag{40.17}
\]

where \(u\) is a holomorphic unit germ, \(n_j\in\mathbf Z\),
\(a_j,b_\ell\ne0\), and \(\epsilon_j,\delta_\ell\in\mathbf Z\).
Then

\[
 \operatorname{ord}_{s=0}F
   =-\sum_{j:n_j\le0}\epsilon_j+\sum_\ell\delta_\ell.             \tag{40.18}
\]

In particular, \(F\) extends as a holomorphic nonvanishing germ at the
resonant point exactly when the right-hand side is zero.

#### Proof

The Gamma function has a simple pole at every nonpositive integer and is
holomorphic and nonzero at every positive integer.  Each exponential factor
has a simple zero because \(b_\ell\ne0\).  Orders add under products.
\(\square\)

For a matrix comparison one must compute the valuations of its invariant
factors, or at least of the determinant and the relevant row minor.  An
entrywise zero/pole count is not sufficient because minors can cancel.
Nevertheless, after the analytic coefficient is known, (40.18) makes the
remaining test finite for the six neutral slope types in Module 39.

## 40.5 Conditional resonance route to \(m=2\)

For an occurrence \(\sigma\) at a consecutive-discrepant overlap, a provider
must first construct a one-parameter trait \(R_\sigma\) through the geometric
integral parameter and canonical finite \(R_\sigma\)-flat module models of
the two full receivers, their supported-span submodules, primitive-packet
submodules, and row maps to \(R_\sigma\).  If the
geometric construction begins in a derived category, a named exact
realization and cohomological degree must first produce these finite module
lattices and commute with the two fibres.  The provider must also construct
an \(R_\sigma\)-linear full comparison \(T_{\sigma,R}\) whose
closed fibre is the actual QDM overlap map and which carries

\[
 C^-_{\sigma,R}\xrightarrow{\sim}C^+_{\sigma,R},
 \qquad
 P^-_{\sigma,R}\xrightarrow{\sim}P^+_{\sigma,R}.                \tag{40.19}
\]

In particular, ``carries'' means **onto**, not merely into.  Define the
marked primitive-packet rank coimages

\[
 \mathcal L^\pm_\sigma
   :=P^\pm_{\sigma,R}/
      \bigl(P^\pm_{\sigma,R}\cap\ker r^\pm_{\sigma,R}\bigr).    \tag{40.19a}
\]

They include the zero-object case.  The full comparison must carry the two
row-null intersections into one another, and hence induce

\[
 F_\sigma:\mathcal L^-_\sigma
      \longrightarrow\mathcal L^+_\sigma.                      \tag{40.19b}
\]

This is the lattice whose zero/nonzero marker is consumed by the proof.
Using \(V/\ker r\) while forgetting the position of \(P\) is insufficient:
an ambient isomorphism can have valuation zero while rotating a row-null
primitive packet to a row-visible one.  The occurrence, phase, projector,
orientation, and endpoint certificates are all part of (40.19b).  Rescaling
one lattice by a power of \(s\) changes its valuation, so the canonical trait
model is load-bearing provider data, not a choice made after the calculation.
The closed-fibre identification includes the base-change isomorphisms

\[
 \beta^\pm_\sigma:
 \mathcal L^\pm_\sigma\otimes_{R_\sigma}k_\sigma
 \xrightarrow{\sim}
 P^\pm_{\sigma,k}/
   \bigl(P^\pm_{\sigma,k}\cap\ker r^\pm_{\sigma,k}\bigr).        \tag{40.19c}
\]

This is independent of saturation of \(F_\sigma\).  For example, take
\(P_R=R\) and \(r_R=s:R\to R\).  The generic and integral coimage over
\(R\) is \(R\), so its tensor with \(k\) is \(k\); but \(r_k=0\), and the
actual closed-fibre coimage is zero.  Thus even a perfectly saturated
comparison between the \(R\)-coimages does not supply (40.19c).

### Theorem 40.4 -- conditional saturated-overlap theorem

Assume the audited ordinary/isolated-wall inputs of Module 39.  Suppose that
for every consecutive-discrepant overlap on one chosen weak factorization:

1. the canonical trait model above exists, the actual supported spans and
   primitive packets are transported **onto** their targets, and (40.19b) is
   induced by the actual full comparison;
2. the generic point of \(R_\sigma\) lies in the scope of a window/GKZ or
   equivalent sectorial theorem and
   \(F_\sigma\otimes K_\sigma\) is an isomorphism;
3. the cohomology of the two-term perfect complex
   \(\operatorname{Cone}(F_\sigma)\) is
   \(R_\sigma\)-torsion-free; and
4. specialization is exact on the named coimages and identifies the closed
   fibre of (40.19b) with the map induced by the actual fixed-phase QDM
   comparison on \(P/(P\cap\ker r)\).

Then \(X\times\mathbf P^2\) is irrational.

#### Proof

The generic isomorphism makes every cohomology module of the cone torsion.
Item 3 and Theorem 40.2 make the cone zero.  Item 4 therefore gives an
isomorphism on the closed primitive-packet rank coimages.  Apply the
one-path quotient telescope of Module 34 to the packet-restricted rows; the
ordinary and isolated-discrepant transitions are already supplied by Module
39, and (40.19b) supplies every remaining adjacent transition.  The source
coimage is nonzero and the audited projective endpoint coimage is zero, a
contradiction.  \(\square\)

This theorem can bypass a direct resonant Stokes calculation.  It does not
remove the local theorem for free: it replaces it by three independently
typed questions.

\[
 \boxed{\text{canonical trait/QDM model}}
 \qquad+\qquad
 \boxed{\text{generic calibration}}
 \qquad+\qquad
 \boxed{\text{saturation + exact base change}}.                 \tag{40.20}
\]

The first neutral toric shadow does not automatically pass the first box.
Its two charge rows have sums \(-2\) and \(+1\); the neutral class has total
degree zero, but the incident representation is not thereby
quasi-symmetric.  The current nonresonant schober theorem therefore cannot
be applied to it merely because the mixed curve is neutral.

## 40.6 The concrete typed interface

The Kmett/Oleg-style design is an indexed proof-carrying record, not an
untyped collection of interchangeable realizations:

\[
\begin{aligned}
 \operatorname{OverlapFamily}(\sigma)=\{\;&R_\sigma,
   \mathcal L^-_\sigma,\mathcal L^+_\sigma,F_\sigma,\\
 &\text{supported-span certificate},
   \text{generic calibration},
   \text{closed QDM identification}\;\},                         \tag{40.21}\\
 \operatorname{Saturated}(\sigma)=\{\;&
   H^*(\operatorname{Cone}F_\sigma)
   \text{ is }R_\sigma\text{-torsion-free}\;\}.                  \tag{40.22}
\end{aligned}
\]

Closed-fibre transport consumes both records.  There is deliberately no
eliminator from generic calibration alone to the closed comparison.  That
typing rule prevents the exact hypothesis smuggling exposed by (40.8) and
(40.15).

The sparse-shadow diagram is

\[
\begin{CD}
 \mathcal L^-_\sigma @>{F_\sigma}>> \mathcal L^+_\sigma\\
 @V{-\otimes K}VV                         @VV{-\otimes K}V\\
 \mathcal L^-_{\sigma,K} @>{\sim}>> \mathcal L^+_{\sigma,K}\\
 @. @.\\[-6pt]
 \mathcal L^-_{\sigma,k} @>{\dashrightarrow}>>
      \mathcal L^+_{\sigma,k}.
\end{CD}                                                       \tag{40.23}
\]

The dashed arrow becomes an isomorphism only after (40.22).  What the
generic shadow forgot is not necessarily lost: it survives as an object of
the closed-support kernel of \(j^*\).  This is exactly the “forgotten but
not gone” phenomenon anticipated by the sparse-shadow viewpoint.

## 40.7 What the physics-side resonance machinery contributes

Euler--Koszul reduction methods used for resonant GKZ systems in
mathematical physics are relevant because they expose resonance through
exact sequences and smaller subsystems.  They do not, by themselves,
identify the distinguished fixed-phase rank quotient or prove that its
torsion defect vanishes.  Likewise, a mixed Gauss--Manin realization for a
resonant parameter supplies a geometric receiver but not the GIT/window row
calibration.

Their useful contribution here is methodological: compute the resonant
subquotient rather than analytically continue a generic basis and assume no
rank jump.  For each of Module 39's six slopes, the finite target is:

1. write the normalized overlap matrix over a trait;
2. reduce it by Euler--Koszul/residue exact sequences;
3. compute its Smith or Gamma valuation on the marked rank row; and
4. prove that valuation is zero.

If all six values vanish, Theorem 40.4 closes \(m=2\).  A positive value is
equally decisive: it exhibits the precise resonant punctual class that the
rank-row route must kill by another selector.

## 40.8 Executable calibration

The shared finite replay checks:

- the hostile module (40.8): generic dimension one, resonant dimension two;
- the scalar family \(s^n\): generic invertibility and closed-fibre
  invertibility exactly at \(n=0\);
- additivity of the valuation under composition;
- the perfect-complex counterexample (40.15); and
- failure of marked coimage base change for \(r_R=s\); and
- finite Gamma-order bookkeeping for products at integral arguments.

These are algebraic witnesses only.  They do not construct the actual
two-wall overlap matrix or prove its saturation.

## 40.9 Source and scope audit

- Spenko--Van den Bergh, *Perverse schobers and GKZ systems*,
  arXiv:2007.04924v3, Theorem 1.6 and the following paragraph.  The cached
  full text used here has SHA-256
  73dffed6c948ac1dd48de1bab994a09e55e875b29dc69473d1d5d6d1e324fd0d.
- Spenko--Van den Bergh, *HMS symmetries of toric boundary divisors*,
  arXiv:2403.15660, Theorem 1.4, Theorem 1.7, Proposition 11.8,
  Corollary 1.8, and the stated assumptions following the introduction.
  The rank conclusion uses the natural equivariant diagram and the trivial
  outer Gauss--Manin quotient; Theorem 1.7 alone is only the integral exact
  sequence.
- Steiner, *A-Hypergeometric Modules and Gauss--Manin Systems*,
  arXiv:1712.00500.  Its mixed Gauss--Manin realization results do not state
  GIT/window or marked-rank compatibility.
- Grimm--Hoefnagels, *Reductions of GKZ Systems and Applications to
  Cosmological Correlators*, arXiv:2409.13815.  The resonant reduction is an
  Euler--Koszul exact-sequence method, not a rank-row transport theorem.

The DVR saturation theorems, derived counterexample, Writer law, and Gamma
valuation are proved in this module.  The application to \(m=2\) is
conditional on the occurrence-indexed generic and closed-fibre inputs in
Theorem 40.4.

## 40.10 EJ/TT and mystery ledger

**EJ.** The resonant gap is not an amorphous analytic-continuation problem.
It is a finite closed-support object.  On a row line it is one valuation; in
the derived receiver it is the torsion cohomology of one comparison cone.
This opens a six-case Smith/Gamma calculation instead of a universal
threefold-center classification.

**TT.** A theorem on the punctured parameter line cannot see a punctual
class at the omitted point.  Conversely, do not demand equality of full
resonant GKZ systems: the final consumer needs only saturation and exact
base change of the marked primitive-packet rank coimage.

| question | status | exact evidence or gate |
|---|---|---|
| Does generic nonresonant schober/GKZ comparison include \(h=1\)? | **no** | source explicitly excludes integral \(\alpha\) |
| Is an integral GKZ rank quotient known in a useful case? | **yes, as a precedent** | crepant toric HMS and (40.1); fixed-phase QDM identification is separate |
| What can appear only at resonance? | **finite parameter torsion** | Theorems 40.1--40.2 |
| Is perfectness of the family enough? | **no** | (40.15) |
| Is the defect compositional on row lines? | **yes** | (40.11) |
| Can Gamma normalization reduce it to arithmetic? | **yes, once the actual coefficient is known** | Proposition 40.3 |
| Does neutral \(c_1\)-degree imply quasi-symmetry? | **no** | first neutral charge matrix has row sums \(-2,+1\) |
| Does this prove \(m=2\)? | **no** | canonical trait/QDM models, generic calibration, saturation, and exact coimage base change remain open for discrepant overlaps |

## Boundary

The naive instruction “prove the comparison generically and specialize”
is now closed negative.  The independent crepant toric \(\beta=0\) GKZ rank
case is positive as a precedent, not as the QDM occurrence provider.  For a
consecutive-discrepant fivefold overlap, the exact replacement is saturation
plus exact base change of the marked primitive-packet rank coimage.  In the
nonzero free rank-one case this is equivalently zero valuation; the zero and
derived cases use the full cone/invariant-factor criterion.  This can bypass
a direct resonant Stokes theorem, but no current source or calculation
supplies the certificates for the six neutral slope types.  No unconditional
\(m=2\) theorem follows.
