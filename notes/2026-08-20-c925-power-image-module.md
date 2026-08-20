# Module 25. Power-image shadows and the exact extension leakage

**Packet part:** Module 25.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

Module 24 used a strict operation-framed biproduct to prevent shorter center
strings from assembling into the source string.  That hypothesis transports
far more than the final Boolean consumer needs.  The exact minimal
replacement is a canonical snake-lemma boundary.  It forgets harmless
nonsplit extensions while retaining precisely the part of an extension which
creates a block above the chosen threshold.

This module does not change the rank-row route and does not prove a new QDM
comparison theorem.  It weakens and exactly types the alternative Jordan
provider.

## 25.1 The universal image shadow

Let \(\mathcal A\) be an abelian category and let

\[
\eta:\operatorname{Id}_{\mathcal A}\Longrightarrow
\operatorname{Id}_{\mathcal A}
\tag{25.1}
\]

be a natural endomorphism.  Define

\[
\operatorname{Top}_\eta(A)=\operatorname{im}(\eta_A).
\tag{25.2}
\]

### Proposition 25.1 -- image-shadow functor

The assignment \(A\mapsto\operatorname{Top}_\eta(A)\) is an additive
functor.  It is the canonical image subquotient through which the natural
map \(\eta_A:A\to A\) factors.  Consequently every consumer of the image of
\(\eta\) can be applied after this one retained shadow.

### Proof

For a morphism \(f:A\to B\), naturality gives

\[
f\eta_A=\eta_Bf.
\]

Hence \(f\) maps \(\operatorname{im}\eta_A\) into
\(\operatorname{im}\eta_B\), and the induced maps respect identity and
composition.  Images commute with finite biproducts in an abelian category,
so the functor is additive.  The last assertion is the universal
epi--mono image factorization of \(\eta_A\). ∎

For finite-dimensional nilpotent \(K[N]\)-modules, take

\[
\eta=N^m,
\qquad
\operatorname{Top}_m(V)=N^mV.
\tag{25.3}
\]

If \(V\cong\bigoplus_sJ_s^{\oplus n_s}\), then

\[
\dim_K\operatorname{Top}_m(V)
=\sum_s n_s\max(s-m,0).
\tag{25.4}
\]

Thus

\[
h_m(V)=\mathbf1\{\operatorname{Top}_m(V)\ne0\}
\tag{25.5}
\]

is exactly the high-length Boolean marker of Module 24.  Formula (25.3),
unlike a chosen Jordan decomposition, is a genuine functor on every
\(N\)-linear map.

## 25.2 The power-Bockstein leakage

Consider a short exact sequence in \(\mathcal A\),

\[
0\longrightarrow A\xrightarrow{i}B\xrightarrow{p}E\longrightarrow0,
\tag{25.6}
\]

and assume

\[
\eta_E=0.
\tag{25.7}
\]

Apply the snake lemma to the endomorphism \(\eta\) of (25.6).  Since
\(\ker\eta_E=E\), it gives a canonical boundary

\[
\partial_\eta(25.6):
E\longrightarrow\operatorname{coker}(\eta_A).
\tag{25.8}
\]

### Theorem 25.2 -- exact image-leakage sequence

There is a canonical short exact sequence

\[
0\longrightarrow
\operatorname{Top}_\eta(A)
\longrightarrow
\operatorname{Top}_\eta(B)
\longrightarrow
\operatorname{im}\partial_\eta(25.6)
\longrightarrow0.
\tag{25.9}
\]

In particular,

\[
\partial_\eta(25.6)=0
\quad\Longleftrightarrow\quad
\operatorname{Top}_\eta(A)\xrightarrow{\sim}
\operatorname{Top}_\eta(B).
\tag{25.10}
\]

The boundary is natural for commuting morphisms of short exact sequences.
For fixed \(A,E\) satisfying (25.7), it depends additively on the Yoneda
extension class:

\[
\beta_{\eta;A,E}:\operatorname{Ext}^1_{\mathcal A}(E,A)
\longrightarrow
\operatorname{Hom}_{\mathcal A}
\bigl(E,\operatorname{coker}\eta_A\bigr),
\qquad
[B]\longmapsto\partial_\eta(B).
\tag{25.11}
\]

### Proof

Condition (25.7) implies \(p\eta_B=\eta_Ep=0\), so
\(\operatorname{im}\eta_B\) lies inside \(i(A)\).  Modulo
\(i(\operatorname{im}\eta_A)\), its class is exactly the image of the snake
boundary.  This proves (25.9), and (25.10) follows because the first map is
already monic.  Naturality is snake-lemma naturality.  Connecting morphisms
add under Baer sum, which gives (25.11). ∎

In \(K[N]\)-modules with \(\eta=N^m\), identify \(A\) with its image in
\(B\).  For \(e\in E\), choose a lift \(b\in B\).  Since \(N_E^me=0\),
one has \(N_B^mb\in A\), and

\[
\tau_m(e)=N_B^mb\pmod{N_A^mA}
\tag{25.12}
\]

is the boundary (25.8).  Changing the lift by \(a\in A\) changes (25.12)
by \(N_A^ma\), so it is well defined.  It is \(K[N]\)-linear because
\(Nb\) lifts \(Ne\).

Over a field, (25.9) gives the exact numerical identity

\[
\dim\operatorname{Top}_m(B)
=\dim\operatorname{Top}_m(A)+\operatorname{rank}\tau_m.
\tag{25.13}
\]

Thus \(\tau_m\), not the full extension class, is the complete defect seen
by the high-length consumer.

If the geometric heart supplies the opposite orientation

\[
0\to E\to B\to A\to0,
\qquad \eta_E=0,
\tag{25.13a}
\]

the same snake diagram gives

\[
\partial_\eta^{\mathrm{op}}:\ker\eta_A\to E
\tag{25.13b}
\]

and a canonical exact sequence

\[
0\to\operatorname{im}\partial_\eta^{\mathrm{op}}
\to\operatorname{Top}_\eta(B)
\to\operatorname{Top}_\eta(A)\to0.
\tag{25.13c}
\]

Hence zero opposite boundary again gives a top-image isomorphism.  An
ExactTop provider may use either orientation, but it must state which
boundary it kills.

### Corollary 25.2A -- orthogonality kills leakage

If

\[
\operatorname{Hom}_{\mathcal A}
\bigl(E,\operatorname{coker}\eta_A\bigr)=0,
\tag{25.14}
\]

then \(\partial_\eta=0\).  Character separation, weight separation,
semiorthogonality, and support-versus-generic localization can each supply
(25.14) when they are available in the actual comparison category.

If an exact scalar extension is applied to (25.6), the boundary base-changes
with it.  An exact duality compatible with \(\eta\) carries the boundary to
the boundary for the dual exact sequence, up to the usual variance and sign.
Neither statement forces vanishing, but both reduce duplicated occurrence
checks.

### Corollary 25.2B -- oriented exact-heart criterion

Suppose \(\mathcal E,\mathcal U\subseteq\mathcal A\) are full subcategories
with

\[
\operatorname{Hom}_{\mathcal A}(\mathcal E,\mathcal U)=0.
\tag{25.14a}
\]

If the exceptional quotient \(E\) lies in \(\mathcal E\) and
\(\operatorname{coker}\eta_A\) lies in \(\mathcal U\), then
\(\partial_\eta=0\).  This applies to an oriented semiorthogonal heart or a
recollement heart only after the operation-framed analytic comparison has
actually been lifted into that heart.  An algebraic semiorthogonal
decomposition by itself does not type the QDM boundary.

For \(R=K[t]\) and \(\eta=t^m\), there is an equivalent change-of-rings
formulation:

\[
\tau_m=0
\quad\Longleftrightarrow\quad
t^m(B/t^mA)=0.
\tag{25.14b}
\]

Thus zero leakage says exactly that the pushed-out extension

\[
0\to A/t^mA\to B/t^mA\to E\to0
\tag{25.14c}
\]

lives in \(R/(t^m)\)-modules.  It does not say that this truncated extension
splits.

## 25.3 Exact cyclic classification

Put \(R=K[t]\) and \(J_a=R/(t^a)\).  An extension

\[
0\longrightarrow J_b\longrightarrow B_x\longrightarrow J_a
\longrightarrow0
\tag{25.15}
\]

is represented by

\[
x\in\operatorname{Ext}^1_R(J_a,J_b)
\cong R/(t^{\min(a,b)}).
\tag{25.16}
\]

Choose a lift \(v\) of the cyclic generator with relation \(t^av=x\).
For \(m\ge a\), the boundary is

\[
\tau_m(\bar1)=t^{m-a}x\pmod{t^mJ_b}.
\tag{25.17}
\]

If \(m\ge\max(a,b)\) and \(x\ne0\) has \(t\)-adic valuation \(v_t(x)\),
then

\[
\tau_m=0
\quad\Longleftrightarrow\quad
v_t(x)\ge a+b-m,
\tag{25.18}
\]

where a nonpositive right side makes the condition automatic.  Moreover,

\[
\operatorname{rank}\tau_m
=\max(0,a+b-m-v_t(x)).
\tag{25.19}
\]

The split class has rank zero.

For a general extension, choose only a \(K\)-linear splitting and write

\[
N_B=
\begin{pmatrix}
N_A&\delta\\
0&N_E
\end{pmatrix}.
\tag{25.19a}
\]

Then the intrinsic boundary is represented by the cross term

\[
\Omega_m(\delta)=
\sum_{j=0}^{m-1}
N_A^{m-1-j}\delta N_E^j
\pmod{N_A^mA}.
\tag{25.19b}
\]

Changing the linear splitting changes \(\Omega_m\) by
\(N_A^mh-hN_E^m\), which is zero in the target under \(N_E^m=0\).
At \(m=2\), the entire obstruction is therefore

\[
\Omega_2(\delta)=N_A\delta+\delta N_E.
\tag{25.19c}
\]

This is the concrete twofold cross-composite to compute in a Rees or Stokes
comparison.  It is not an \(\operatorname{Ext}^2\)-class:
\(K[t]\) has global dimension one.

### Consequences

1. If \(a+b\le m\), every extension is invisible to
   \(\operatorname{Top}_m\), even when it is nonsplit.
2. The hostile sequence

   \[
   0\to J_1\to J_{m+1}\to J_m\to0
   \tag{25.20}
   \]

   has nonzero \(\tau_m\) and creates exactly one new top line.
3. At \(m=2\), every nonzero class of types
   \((a,b)=(2,1),(1,2),(2,2)\) is detected, while the nonsplit
   \(J_1\)-by-\(J_1\) extension \(J_2\) is invisible and harmless.

Thus the weakening is optimal: it forgets precisely those extensions which
cannot create a block above the threshold.  At \(m=2\) it does not make a
dangerous second composite disappear; it isolates that composite from all
irrelevant first-extension data.

There is also no hidden saving against an already-retained top block.  For
\(1\le\ell\le m\), formula (25.17) gives an injection

\[
\operatorname{Ext}^1_R(J_\ell,J_{m+1})
\hookrightarrow
\operatorname{Hom}_R
\bigl(J_\ell,J_{m+1}/t^mJ_{m+1}\bigr).
\tag{25.20a}
\]

Hence every nonzero extension component from a center string into the unique
source top string is visible to \(\tau_m\).  The power-image shadow discards
only extension data which cannot affect the endpoint obstruction.

## 25.4 The ExactTop provider

Fix a primitive character \(\theta\), a threshold \(m\ge1\), and one chosen
weak-factorization path.  An occurrence-indexed ExactTop provider assigns to
every forward blowup \(\widetilde Y\to Y\) a short exact sequence in one
common \(K[N]\)-linear category,

\[
0\longrightarrow V_{Y;\sigma}
\longrightarrow V_{\widetilde Y;\widetilde\sigma}
\longrightarrow E_{\pi;\sigma}
\longrightarrow0,
\tag{25.21}
\]

together with certificates

\[
N^mE_{\pi;\sigma}=0,
\qquad
\tau_{\pi,m}=0.
\tag{25.22}
\]

The indices record the actual coordinate specialization, reconstruction,
normalization, coefficient extension, operation frame, and path provenance.
The quotient in (25.21) is the actual exceptional quotient, not merely an
associated-graded list of center pieces.

### Theorem 25.3 -- exact-top weak-factorization telescope

Assume that for every hypothetical birational map from the source to the
projective endpoint there exists a chosen weak factorization such that:

1. the source has \(\operatorname{Top}_m\ne0\);
2. the projective endpoint has \(\operatorname{Top}_m=0\); and
3. every actual arrow of that weak factorization has an ExactTop
   provider in the selected character.

Then the source is not birational to the projective endpoint.

### Proof

Theorem 25.2 makes every forward blowup induce a canonical isomorphism on
\(\operatorname{Top}_m\).  Use its inverse for a blowdown and compose along
the chosen zigzag.  This identifies the source and target image shadows,
contradicting their endpoint values. ∎

For one contradiction path, no path-independence theorem is needed.  A
functor on the whole comparison groupoid additionally requires
pseudonaturality under occurrence base change and Beck--Chevalley coherence
for exchange squares.

### Corollary 25.3A -- strictness can be weakened exactly

Input 24.S, Hypothesis 24.C, and strict Hypothesis 24.B imply the hypotheses
of Theorem 25.3.  For the Boolean all-\(m\) conclusion, Hypothesis 24.B may be
replaced by the weaker occurrence-indexed data (25.21)--(25.22), provided
the exponent certificate is proved for the actual exceptional quotient.

The associated-graded center bound alone does not prove that certificate:
\(J_{m+1}\) has a filtration with subquotients \(J_m\) and \(J_1\), both
killed by \(N^m\), although \(N^mJ_{m+1}\ne0\).  Exactness and the actual
quotient are load-bearing.

## 25.5 The sharpened \(m=2\) and all-\(m\) gates

At \(m=2\), the source satisfies

\[
\operatorname{Top}_2(J_3)\cong K,
\tag{25.23}
\]

and the projective target has zero primitive-sixth shadow.  The Jordan route
therefore needs only, at every actual fivefold blowup occurrence,

\[
0\to V_Y\to V_{\widetilde Y}\to E_\pi\to0,
\qquad
N^2E_\pi=0,
\qquad
\tau_{\pi,2}=0.
\tag{25.24}
\]

The last condition is exactly the surviving ambient--exceptional
cross-extension obstruction after the independent C907 internal carrier
bound.  It permits nonsplit \(J_1\)-by-\(J_1\) extensions and rejects every
cyclic extension which can manufacture a \(J_3\).  This is genuinely weaker
than a full Stokes/Rees split, but on the three dangerous \(m=2\) cyclic
Ext-spaces the boundary computed in (25.17)--(25.19) is injective, so it is
not a cheap formal proof of \(m=2\).

For general stabilization index \(m\), the binary source has

\[
\operatorname{Top}_m(J_{m+1})\cong K.
\tag{25.25}
\]

The conditional all-\(m\) theorem follows from an occurrence-indexed
ExactTop provider for each member of one cofinal fixed-factor family.  The
provider may vary with \(m\); Theorem 24.1 supplies the final passage from
that cofinal family to every index.

For the line-bundle operator \(N_L=1-\tau_L\), projection formula makes the
algebraic \(K_0\) Orlov component maps split whenever the line bundle
descends.  If an exact cyclotomic realization preserves those component maps,
then its boundary vanishes as well; this analytic lift is an input, not a
formal consequence of the algebraic SOD.  At a base-ideal/Rees resolution,
the exact remaining operation-framed statement is no longer “split the full
packet”: construct the oriented exact sequence, prove the actual exceptional
term is killed by \(N_L^m\), and kill its single snake boundary.  For \(m=2\),
this is the precise power-image shadow of the normal-splitting and stationary
Picard--Lefschetz cross-composite gates.

The most promising geometric specialization of (25.24) uses the opposite
orientation (25.13a).  The standard Orlov blowup order is

\[
\langle\text{exceptional components},\ \text{ambient component}\rangle,
\]

so its semiorthogonality kills ambient-to-exceptional morphisms, not the
reverse.  If the analytic operation-framed comparison is lifted to an
enriched exact heart \(\mathcal A_{\mathrm{op-fr}}\), with \(N^2\) a natural
endomorphism there, \(E_\pi\) exceptional, and the ambient object \(V_Y\) in
the right component, then the relevant sufficient condition is

\[
\operatorname{Hom}_{\mathcal A_{\mathrm{op-fr}}}
(\ker N_{V_Y}^2,E_\pi)=0.
\tag{25.25a}
\]

This kills the opposite boundary without splitting the packet.  The
forgetful realization to \(K[N]\)-modules must be exact and zero-preserving.
Plain \(K[N]\)-module orthogonality cannot help: any two nonzero finite
nilpotent \(K[N]\)-modules admit a nonzero map.  A nearby-cycle version puts
\(E_\pi\) in the boundary-supported subcategory and the ambient kernel in a
clean intermediate extension.  Both are narrower than full Gamma--Orlov
compatibility, but neither analytic lift or cleanliness theorem is currently
available for arbitrary blowups.

## 25.6 Relation to the rank row and sparse shadows

The two surviving providers have the same software shape but different
variance:

| retained shadow | comparison shape | complete defect | vanishing gives |
|---|---|---|---|
| quotient row \(V/\ker r\) | isomorphism \(\Phi\) | \(\delta_\Phi=r_+\Phi|_{\ker r_-}\) | row transport up to nonzero scalar |
| power image \(N^mV\) | short exact extension | \(\tau_m:E\to A/N^mA\) | image-shadow isomorphism |

Both defects are natural Hom-valued sparse shadows.  The rich Stokes/Rees
comparison can be forgotten once the appropriate defect and its zero
certificate have been emitted.  In the Reader/indexed-State/Writer language:

- the Reader carries the occurrence index \(\sigma\);
- State carries the transported row line or power image;
- Writer records \(\delta\) or \(\tau_m\);
- the lens reads only the defect required by the endpoint consumer; and
- a path functor maps geometric comparison paths to these retained states.

The full extension class has not disappeared: (25.11) maps it to the only
quotient which can affect \(\operatorname{Top}_m\).  Its kernel is exactly
the information which this proof is allowed to forget.  This is a literal
reconstruction-from-sparse-shadows instance: one reconstructs the needed
endpoint equality, not the rich object.

## 25.7 Other specializations and imported machinery

The construction works for any natural polynomial operation

\[
\eta=p(T),
\tag{25.26}
\]

including a primitive-character projector followed by \(N^m\).  It therefore
imports the following standard categorical mechanisms without changing the
geometric provider:

1. **semisimple or split spectral packages:** when the actual exact category
   is semisimple, or the actual occurrence sequence splits, its boundary is
   zero; semisimple-looking constituents or an associated graded do not
   suffice;
2. **character, weight, or support orthogonality:** (25.14) kills the boundary
   without constructing a splitting;
3. **flat coefficient extension:** the boundary can be checked after a
   faithful flat cyclotomic or Novikov scalar extension;
4. **duality:** conjugate primitive sectors carry dual boundary checks; and
5. **Yoneda/Baer linearity:** several local analytic contributions are tested
   by their sum in one explicit Hom-space rather than by reconstructing a
   Stokes matrix.

The image shadow is a final consumer, not a monoidal source provider.  For a
diagonal nilpotent,

\[
D=N_V\otimes1+1\otimes N_W,
\qquad
D^m=
\sum_{i=0}^m\binom mi\,N_V^i\otimes N_W^{m-i}.
\tag{25.26a}
\]

Therefore same-threshold
\(\operatorname{Top}_m(V),\operatorname{Top}_m(W)\) do not determine
\(\operatorname{Top}_m(V\otimes W)\).  A full \(N\)-image filtration with
its induced \(N\)-maps and diagonal-operation compatibility, or the
corresponding structured Rees object, is sufficient source data, but not
necessary: factor nilpotence ceilings, extremal top lines, and
diagonal-operation product compatibility already suffice by Proposition
25.5.

There is nevertheless an exact shifted tensor law.

### Proposition 25.4 -- product stability at the shifted threshold

Suppose (25.6) is an exact sequence of \(K[N]\)-modules with

\[
N^mE=0,\qquad \tau_m=0,
\]

and let \((W,S)\) satisfy \(S^{k+1}=0\).  Tensor (25.6) over \(K\) with
\(W\), using the diagonal operator

\[
D=N\otimes1+1\otimes S.
\]

Then

\[
D^{m+k}(E\otimes W)=0
\quad\text{and}\quad
\tau_{m+k}(B\otimes W)=0.
\tag{25.26b}
\]

### Proof

The correction is killed because a nonzero term in the binomial expansion of
\(D^{m+k}\) would require simultaneously an \(N\)-exponent at most \(m-1\)
and an \(S\)-exponent at most \(k\), whose sum cannot be \(m+k\).

Since \(\tau_m=0\), Theorem 25.2 gives \(N_B^mB=N_A^mA\) inside \(B\).
Every nonzero term of \(D_B^{m+k}\) has \(N\)-exponent at least \(m\), so its
image agrees with the corresponding term from \(A\otimes W\).  Hence

\[
D_B^{m+k}(B\otimes W)=D_A^{m+k}(A\otimes W),
\]

which is the shifted zero-boundary criterion. ∎

The same conclusion holds for the opposite orientation (25.13a) and its
boundary (25.13b): the level-\(m\) top-image isomorphism tensors to the
level-\(m+k\) top-image isomorphism, while the exceptional tensor factor is
killed at that shifted threshold.

This transports a proved arrow through an external projective factor.  It
does not reduce arbitrary higher-dimensional weak-factorization arrows to
products of lower-dimensional ones.

### Corollary 25.4A -- upward threshold stability

If \(N^mE=0\) and \(\tau_m=0\), then for every \(r\ge m\),

\[
N^rE=0,\qquad \tau_r=0,\qquad
\operatorname{Top}_r(A)\xrightarrow{\sim}\operatorname{Top}_r(B).
\tag{25.26bb}
\]

Indeed \(N_B^mB=N_A^mA\), and applying \(N^{r-m}\) gives equality at level
\(r\).  Lower thresholds need not be clean:
\(0\to J_1\to J_2\to J_1\to0\) has \(\tau_2=0\) but
\(\tau_1\ne0\).

### Proposition 25.5 -- extremal tensor image

Let \((M_i,N_i)\), \(1\le i\le r\), satisfy
\(N_i^{a_i+1}=0\), put \(A=\sum_i a_i\), and use the diagonal nilpotent
\(D=\sum_iN_i\) on \(\bigotimes_iM_i\).  Then

\[
D^{A+1}=0
\tag{25.26c}
\]

and

\[
D^A=
\binom{A}{a_1,\ldots,a_r}
\bigotimes_iN_i^{a_i}.
\tag{25.26d}
\]

If the multinomial coefficient is nonzero in \(K\), then

\[
\operatorname{Top}_A\Bigl(\bigotimes_iM_i\Bigr)
\cong
\bigotimes_i\operatorname{Top}_{a_i}(M_i).
\tag{25.26e}
\]

### Proof

In every multinomial term of total degree \(A\), a surviving exponent is at
most \(a_i\).  Equality of the sums forces every exponent to equal \(a_i\),
giving (25.26d).  At total degree \(A+1\), the pigeonhole principle forces
one exponent above its bound.  Taking images proves (25.26e). ∎

In characteristic zero, one-dimensional extremal image lines therefore give
one canonical top block.  Taking every \(M_i=J_{k+1}\), \(a_i=k\), recovers
the unique \(J_{kr+1}\) of Proposition 24.3 without the full
Clebsch--Gordan decomposition.  Heterogeneous factors give the same direct
proof of (24.13b).

Guéré/BFGMP-style separated spectral probes and the KKPYY split atom ledger
fit the split algebraic skeleton of this framework after their own providers
have produced a common lawful exact category.  This statement does not
subsume or replace their geometric comparison theorems.  The new content is
the nonsplit branch needed by the operation-framed cubic problem.

## 25.8 Exact boundary

Theorems 25.1--25.3 and the cyclic calculation are formal algebra.  They do
not construct the occurrence-indexed exact QDM sequence, prove
\(N^mE_\pi=0\) for the actual exceptional quotient, or kill
\(\tau_{\pi,m}\).  They do not repair the separate adjacent-receiver
coherence gate of the rank-row route.

The improvement is exact but limited: the operation-framed programme no
longer needs full Krull--Schmidt/Stokes splitting.  It needs one exponent
certificate and one natural Bockstein-zero certificate per actual arrow.
At \(m=2\), the latter is still the genuine geometric second-composite
problem.  The highest-value next regression is to express the base-ideal or
normal-splitting Rees comparison as (25.21) and compute its
\(\tau_{\pi,2}\) directly.

---
