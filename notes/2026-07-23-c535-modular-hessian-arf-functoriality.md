# C535 — modular Hessian--Arf functoriality boundary

**Lane:** `reed-solomon` · **Date:** 2026-07-24 · **Status:** complete at the
characterized cubic-local exit

## Result

C519/C525's ordered divided Hessian is functorial over characteristic-two base
schemes, but the strongest honest statement is **cubic-local**.  It is not a new
all-degree Hessian of a binary form.  Its all-degree universality comes from the
canonical contraction
\[
 \Gamma^nE\times\operatorname{Sym}^{n-3}E^\vee\longrightarrow\Gamma^3E
\]
followed by the binary-cubic divided Hessian.

This distinction matters already for quartics.  Their ordinary characteristic-two
Hessian is again a Frobenius square, but the direct modular repeated-root invariant
\[
 i_3=AD^2+BCD+EB^2
\]
is established literature.  It is a scalar discriminator, not an ordered separable
root cover.  The functorial ordered-root/Arf object is obtained instead by contracting
the quartic to a pencil of cubics and applying the cubic construction.

The exact exit is therefore the task card's **characterized stop**:

> the divided-Hessian--Arf construction is intrinsically cubic, and is canonically
> universal in every higher degree only after the residual contraction functor.

No source located in the claim-specific audit states C525's constrained
consecutive-Hankel pullback equality.  This is not a priority claim: the square-root
cubic discriminant, quartic modular invariants, quadratic Arf class, twisted-cubic
geometry, and ordinary base-change formalism are explicitly excluded.

## 1. Coordinate-free cubic construction

Let \(S\) be an \(\mathbf F_2\)-scheme and \(E\) a rank-two locally free
\(\mathcal O_S\)-module.  For \(c\in\Gamma^3E\), contraction gives the
catalecticant
\[
 C_c:E^\vee\longrightarrow\Gamma^2E.
\]
Taking its second exterior power and using the canonical identities
\[
 \bigwedge\nolimits^2(\Gamma^2E)
 \simeq(\Gamma^2E)^\vee\otimes\det(\Gamma^2E),
 \qquad
 (\Gamma^2E)^\vee\simeq\operatorname{Sym}^2E^\vee,
 \qquad
 \det(\Gamma^2E)\simeq(\det E)^3
\]
gives a quadratic covariant
\[
 \mathfrak h(c)\in
 \operatorname{Sym}^2E^\vee\otimes(\det E)^4.                \tag{1}
\]
This is the divided Hessian.  In a local frame, with
\(c=(A,B,C,D)\), its coefficients are
\[
 N_u=AC+B^2,\qquad N_s=AD+BC,\qquad \Delta=BD+C^2,            \tag{2}
\]
up to the harmless reversal forced by the chosen root-coordinate convention.

Equation (1) is made only from contraction, exterior power, and canonical tensor
identifications.  Consequently it commutes with arbitrary base change and with
isomorphisms of \(E\).  In coordinates this is C519's divided Hessian
\[
 N_uX^2+N_sXY+\Delta Y^2.                                    \tag{3}
\]
The determinant twist in (1) records the relative `GL(E)` weight; it disappears
from the zero scheme.

For a rank-two locally free pencil \(L\subset\Gamma^3E\), the tautological cubic
on \(\mathbf P(L)\) and (1) define
\[
 \mathcal C_L\subset\mathbf P(L)\times_S\mathbf P(E).
\]
It is the zero scheme of a section of bidegree `(2,2)`.  This construction:

- commutes with every base change \(S'\to S\);
- is transported by every isomorphism of \(E\) and every change of basis of \(L\);
- is unchanged as a zero scheme when the cubic is scaled by a unit; and
- specializes over a field to C525's ordered-Hessian incidence.

Thus the natural object is the incidence scheme, not a chosen affine
Artin--Schreier equation.

## 2. Collision scheme and the maximal base-change statement

The zero scheme of the covariant \(\mathfrak h\) is the divided twisted cubic
\[
 C_3=\mathbf P(E)\longrightarrow\mathbf P(\Gamma^3E).
\]
Indeed, in a frame its ideal is exactly
\[
 (AC+B^2,\ AD+BC,\ BD+C^2),
\]
the three catalecticant minors.  Therefore the vertical collision scheme of a
pencil is intrinsically
\[
 Z_L=\mathbf P(L)\times_{\mathbf P(\Gamma^3E)}C_3.            \tag{4}
\]
Both (4) and the unreduced incidence \(\mathcal C_L\) commute with arbitrary base
change.  This is the scheme-level replacement for the field-language assertion
that vertical factors are precisely intersections with the twisted cubic.

There is a necessary boundary.  “Remove the vertical factor” means a colon ideal,
division by an effective Cartier equation, or saturation.  It commutes with flat
base change, and more generally with a base change for which the collision divisor
remains effective Cartier and the relevant quotient is Tor-independent.  It does
not commute with arbitrary nonflat base change.  The elementary model
\[
 F=tG\quad\text{over }k[t]
\]
already shows this: residualizing first gives \(G\), while after the base change
\(t\mapsto0\), both \(F\) and the proposed divisor equation vanish and the quotient
cannot be recovered from the pulled-back incidence.

Hence the maximal unconditional naturality theorem is:

1. incidence plus collision subscheme under arbitrary base change;
2. the residual moving incidence under flat/Cartier-preserving base change; and
3. C525's geometric component classification fibrewise over fields.

An assertion that residual factor removal itself is natural under every base change
would be false.

## 3. The Arf torsor

On the open locus where the polar coefficient \(N_s\) is invertible, (3) is a
nonsingular binary quadratic.  Its root divisor is finite étale of degree two and
therefore a canonical \(\mathbf Z/2\)-torsor.  In a local root frame its
Artin--Schreier representative is
\[
 \frac{\Delta N_u}{N_s^2}.                                  \tag{5}
\]
Changing the root frame changes (5) by \(h^2+h\), so the invariant object is the
class
\[
 [\Delta N_u/N_s^2]\in H^1_{\mathrm{\acute et}}
   (-,\mathbf Z/2),
\]
not the displayed rational function.  The torsor, its class, and its pullback all
commute with arbitrary base change inside the nonsingular open.  Over an affine
field base this recovers C519/C525's familiar quotient by
\(\{h^2+h\}\).

This also separates three notions that cannot be conflated:

- the cubic discriminant is the Frobenius square \(N_s^2\);
- the ordered-root cover is separable exactly on the open \(N_s\ne0\); and
- rational splitting is the vanishing of the torsor class, not the squareness of
  the discriminant.

## 4. First higher-degree test

Write a binary quartic in ordinary characteristic-two coordinates as
\[
 f=Ax^4+Bx^3y+Cx^2y^2+Dxy^3+Ey^4.
\]
Its pure second derivatives vanish and its mixed derivative is
\[
 f_{xy}=Bx^2+Dy^2.
\]
Thus its ordinary Hessian determinant is
\[
 (Bx^2+Dy^2)^2,                                              \tag{6}
\]
so the Frobenius-square information loss persists beyond cubics.

Equation (6) does not even determine the repeated-root boundary.  The quartics
\[
 x^3y,\qquad x^3y+y^4
\]
have the same ordinary Hessian \(x^4\), while their modular invariants
\(i_3=AD^2+BCD+EB^2\) are respectively \(0\) and \(1\).
Du Plessis--Wall prove over an algebraically closed characteristic-two field that
the quartic invariant ring is \(K[i_2,i_3]\), with
\[
 i_2=BD+C^2,\qquad i_3=AD^2+BCD+EB^2,
\]
and that \(i_3=0\) characterizes repeated roots.  Therefore a claim that the first
direct higher-degree modular discriminant replacement is new would be false.

What survives is the ordered construction.  Contracting \(f\) by
\(\lambda=(u,v)\) gives the cubic
\[
 (A',B',C',D')
 =(uA+vB,\ uB+vC,\ uC+vD,\ uD+vE).
\]
Applying (2) produces three quadratic forms in \((u,v)\), hence a canonical
`(2,2)` incidence in contraction parameter and residual root.  This is exactly the
quartic instance of the general map
\[
 \mathfrak H_n(f,P)=\mathfrak h(\iota_Pf),\qquad
 P\in\operatorname{Sym}^{n-3}E^\vee.                         \tag{7}
\]
Equation (7) is natural under arbitrary base change before residualization.  For a
root-compatible pencil \(P=R\lambda\), it is C525's all-degree slice.  No
independent higher-degree divided-Hessian covariant is needed or licensed by this
test.

## 5. Universal theorem and exact PRS corollary

### Cubic-local modular replacement theorem

Over an \(\mathbf F_2\)-scheme, the construction
\[
 (f,P)\longmapsto
 \operatorname{Hess}^{\mathrm{div}}(\iota_Pf)
\]
is a natural transformation from contracted divided-power binary forms to
line-bundle-valued binary quadratics.  Its ordered zero incidence and its
twisted-cubic collision pullback commute with arbitrary base change.  On the
nonsingular open, its ordered roots form the canonical Artin--Schreier/Arf torsor.
Residualization commutes exactly under the flat/Cartier-preserving boundary above.

This theorem is independent of Reed--Solomon language.  The specifically new
task-owned clause is not the classical Arf invariant or the modular discriminant
square root; it is the combination with C525's constrained consecutive-contraction
pullback.

### PRS corollary

For a characteristic-two PRS syndrome \(f\) and a split fixed factor \(R\), take
\(P=R\lambda\) in (7).  C525's fieldwise classification says that, after the
collision divisor is removed, every geometrically degenerate root-compatible slice
is pulled back from:

- the persistent common-quadratic Veronese surface; or
- the tangent-quadric rulings, whose complementary ruling has contraction rank at
  most one.

C512 then identifies the complete nontrivial contained syndrome pullback with the
persistent catalecticant/Lucas-nucleus carrier union.  C535 changes no field
threshold or deletion constant: C525's
\[
 q\ge\min\{(n-4)(n+11)/2+1,\ 9(n-4)\},\qquad
 \delta_n^{(2)}\le3n-4
\]
and its genus-one avoidance condition remain the exact effective corollary.

## 6. Claim-specific literature audit

**Full-text count:** two sources were read in full.  One additional source was read
partially at the exact characteristic-two binary-cubic paragraph.  Earlier C519/C525
metadata-only line-orbit searches were reviewed but are not counted as full text.

### Full text

- Marcus J. Slupinski and Robert J. Stanton, *The Special Symplectic Structure of
  Binary Cubics*, arXiv `0906.4309v1`, published as DOI
  `10.1007/978-0-8176-4817-6_8` — **read depth: full text**, all sections; shared
  cache key `arXiv:0906.4309`, SHA-256
  `8754633abdd5e7271aa81cabdd7685a0d25c43e2a79bde26875301b63e165b0f`.
  The paper's moment-map/Hessian formulas are close to (2), but its standing
  hypothesis is characteristic different from two and three.  It cannot supply the
  modular torsor or constrained pullback.
- Andrew du Plessis and C. T. C. Wall, *The moduli space of binary quintics*, DOI
  `10.1007/s40879-017-0187-8` — **read depth: full text**, open-access published
  version, all sections, with Section 6 load-bearing; cache key
  `10.1007/s40879-017-0187-8`, SHA-256
  `5e1c11f2e3152680a7c485527fcc7c73ea520b25462e0c35b5f47bad44b15447`.
  Section 6.2 proves the characteristic-two quartic invariant statement used above.
  It pre-empts any originality claim for \(i_2,i_3\), but does not construct the
  contracted ordered-Hessian incidence or the consecutive-Hankel pullback.

### Partial and discovery-depth sources

- Mark Reeder and Jiu-Kang Yu, *Epipelagic representations and invariant theory*,
  DOI `10.1090/S0894-0347-2013-00780-8` — **read depth: partial**, the published
  version's characteristic-two \(G_2\) paragraph immediately following equation
  (51), accessed through the search-indexed full-text PDF.  The publisher and
  mirror download endpoints were not cacheable in this session.  It explicitly
  records
  \(\operatorname{disc}(ax^3+bx^2y+cxy^2+dy^3)=(ad+bc)^2\)
  and uses the corresponding square-root invariant in its extended stable-vector
  problem.  It does not discuss the
  divided Hessian, Arf torsor, line incidence, or constrained pullback.
- Kaipa--Patanker--Pradhan `arXiv:2312.07118`,
  Kaipa--Pradhan `arXiv:2509.15332`, and
  Davydov--Marcugini--Pambianco `arXiv:2103.12655` —
  **read depth: abstract/metadata only**, reused from C525's delta.  The first two
  explicitly exclude characteristics two and three; the third advertises finite
  line-type/orbit classification, not the scheme-level ordered-Hessian theorem.

### Search record

The load-bearing web-index queries on 2026-07-24 were:

```text
binary cubic invariants characteristic 2 divided powers Hessian Arf full text PDF
modular invariants binary quartic characteristic two Hessian discriminant inseparable PDF
binary forms characteristic 2 resolvent Arf invariant discriminant full text
invariant theory binary cubic over F2 covariants Hessian PDF
"binary quartics" "characteristic 2" invariant ring
"binary cubics" "characteristic 2" invariants
"AD+BC" binary cubic characteristic 2 invariant
"divided Hessian" binary forms
"binary cubic" "base change" Hessian characteristic 2 Arf
"Artin-Schreier" "binary cubic" Hessian
```

Three exact OpenAlex searches,

```text
"ordered Hessian" "binary cubic"
"divided Hessian" "binary cubic"
"Hessian Arf" cubic
```

resolved successfully with `0/0/0` results.  This is only an exact-phrase screen,
not proof of absence.  A broader title screen examined the first ten results for
each of three queries in both Crossref and OpenAlex (`60` records total):
`binary cubic characteristic 2 Hessian Arf`, `divided Hessian binary cubic`, and
`ordered Hessian characteristic two`.  The only mathematically adjacent promoted
item was ordinary-characteristic reduction of binary cubics/quartics; the rest were
lexical Hessian noise.  The screen used returned titles only, so no source is assigned
a read depth from that screen.

**Verdict.**  No exact predecessor for the constrained ordered-Hessian pullback or
its base-scheme formulation was located within this coverage.  Reeder--Yu pre-empt
the cubic square-root-discriminant observation, and du Plessis--Wall pre-empt the
direct quartic modular invariant.  The surviving statement is therefore deliberately
narrow and remains qualified “no predecessor located,” not “first” or “new.”

Coverage gaps: MathSciNet is **NOT COVERED** because institutional authentication
is unavailable; Google Scholar was not used because automated access is blocked;
zbMATH Open was not independently refreshed.  No forward-citation exhaustion or
paper-facing priority claim is made.

## Extra-juice and Tao closeout

The closeout found and settled three cheap overclaim risks.

1. **Arbitrary base change was too broad after factor removal.**  The theorem now
   separates the universally natural incidence/collision pair from
   flat/Cartier-preserving residualization.
2. **“Beyond cubic” could wrongly claim a new quartic discriminator.**  The
   du Plessis--Wall \(i_3\) theorem removes that claim.
3. **The square-Hessian calculation alone was too weak.**  The pair
   \(x^3y,\ x^3y+y^4\) proves that the same ordinary Hessian can straddle the
   repeated-root boundary, while contraction recovers the ordered separable object.

The resulting statement has the smallest stable shape: a coordinate-free cubic
covariant, a canonical Artin--Schreier torsor, an exact base-change boundary, and an
all-degree contraction corollary.

## Mystery ledger

Settled:

- **Is the construction natural over characteristic-two base schemes?** Yes for
  the incidence, collision scheme, and nonsingular Arf torsor.
- **Does removal of vertical collision factors commute with arbitrary base
  change?** No; it requires the stated flat/Cartier-preserving hypothesis.
- **Does the Frobenius-square Hessian failure persist for quartics?** Yes.
- **Is the direct quartic modular repeated-root invariant new here?** No;
  \(i_3\) is established literature.
- **Is there a genuinely higher-degree ordered divided Hessian?** Not in the
  tested sense.  The canonical separable object is the cubic divided Hessian after
  contraction.
- **What is the maximal PRS-independent theorem?** The cubic-local natural
  transformation and its Arf torsor, with C525's constrained pullback as the
  nonclassical clause.

No genuine task-owned mystery remains.  C536 separately owns the next coherent
polar-flag/Fano boundary; C533 separately owns C525's numerical sharpening.

## Validation boundary

The proof is structural and uses no new finite computation.  The coordinate
identities are direct exterior-minor and derivative calculations displayed above.
No paper-facing computational claim or reproducibility bundle is introduced.
