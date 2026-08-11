# C904 relative Shen descent and charge-three polarization audit

Date: 2026-08-11

Status: bounded claim-specific primary-source audit; no manuscript or Lean
change

Read depth: zero sources were newly read cover-to-cover. Ten primary sources
were read at the claim-specific partial depths recorded in Section 8. The
negative conclusion is bounded: MathSciNet and zbMATH were not covered, and no
three-graph forward-citation enumeration was attempted.

## Executive verdict

No audited theorem computes or kills

\[
 \ker\!\left(CH_1(D_K)/2\longrightarrow
                  CH_1(D_{\overline K})/2\right),
 \qquad K=\mathbf C(B),
\]

for the generic Fano-sum divisor of the marked cubic family. No audited theorem
computes the arithmetic generic index of

\[
             \operatorname {Sym}^2\Theta_K\longrightarrow J_K,
\]

and no audited source spreads Shen's supported minimal curve horizontally over
a curve base. Shen and Voisin prove fixed-complex-fibre existence statements;
the 2025--26 results of Engel--de Gaay Fortman--Schreieder, Scavia--Suzuki,
Beckmann--de Gaay Fortman, and Kahn control ambient algebraicity, integral
Fourier transforms, or etale Chow groups, not support on `D`, integral halving,
or ordinary-Chow descent modulo two.

The exact surviving obstruction is therefore genuine rather than an omitted
standard citation. If

\[
 z\in CH_1(D_K),\qquad z_{\overline K}=2\eta_{\overline K},
\]

then

\[
 o_K(z)=[z]\in
 \ker\!\left(CH_1(D_K)/2\to CH_1(D_{\overline K})/2\right)
\]

vanishes exactly when a complete integral half exists over `K`. Restriction to
every finite odd-degree extension is injective modulo two, by
restriction--corestriction. Thus one odd-degree field carrying the complete half
relation closes the gate; a geometric half, an invariant cohomology class, or a
fibrewise complex construction does not.

The most promising source-backed bypass is now on the charge-three side. Li--
Lin--Pertusi--Zhao prove that the relevant primitive Bridgeland moduli spaces are
fine, that the Abel--Jacobi relative Neron--Severi group has rank one, and that a
general fibre is Fano with primitive canonical class. They do **not** compute
the top self-intersection of that primitive class; indeed their Question 8.10
explicitly leaves the fibre Picard group, cohomology, and a Verlinde formula
open. After identifying the classical `M9` open with the appropriate primitive
Bridgeland component, a GRR computation of

\[
                    (-K_{V})^4,
 \qquad V=(M_9\to J)_\eta,
\]

is the highest-EV next move. An odd value gives an odd `K`-zero-cycle and hence
index one immediately. An even value closes the entire globally restricted
determinant-line route, though not hidden fibrewise Picard classes or arbitrary
zero-cycles.

The rational-simple-connectedness route does not presently bypass this
calculation. De Jong--He--Starr require much more than rational connectedness,
and their section theorem is over the function field of a surface. The generic
Abel--Jacobi fibre is over `C(J)`, of transcendence degree five. A section after
restriction to a surface in `J` is not a point over `C(J)`. If instead one
constructs a proper rationally connected choice space over `C(B)`, ordinary
Graber--Harris--Starr already gives a point; the missing step is the choice
space, not rational simple connectedness.

## 1. The exact descent obstruction

Let `D=D_{+,K}` and assume a relative construction has produced
`z in CH_1(D)` whose geometric restriction is twice a class. Then

\[
 o_K(z)=[z]\in\ker(CH_1(D)/2\to CH_1(D_{\bar K})/2)
\]

is canonical and

\[
                        o_K(z)=0
 \quad\Longleftrightarrow\quad z\in2CH_1(D).
\]

For a finite extension `L/K`, proper pushforward and flat pullback give
`cor res=[L:K]`. Hence if `[L:K]=2q+1` and
`2 eta_L=res(z)`, then

\[
                \operatorname {cor}(\eta_L)-qz
\]

is a `K`-half of `z`. Equivalently,

\[
                  CH_1(D)/2\longrightarrow CH_1(D_L)/2
\]

is injective for every odd-degree extension. This argument is independent of
smoothness of `D`.

The set of geometric halves is a torsor under
`CH_1(D_bar)[2]`, not under `J[2]`. Even a Galois-invariant geometric half need
not descend to ordinary Chow, and a descended class need not carry the rational
equivalence `2 eta=z` over `K`. The canonical kernel class above packages both
failures without pretending that higher Chow groups satisfy Galois descent.

Humberto Diaz's 2025 theorem is a useful hostile check: over a function field
of a complex curve, higher-codimension Chow descent can have a cokernel not of
cofinite type already for zero-cycles on smooth projective surfaces. This is a
cokernel theorem, not a computation of the present kernel, but it rules out any
appeal to `cd(K)=1` as a generic higher-Chow descent principle.

## 2. Fixed-fibre theorems do not relativize the half

### Shen

Shen's Theorem 5.1 starts with a Chow-theoretic decomposition of the diagonal
of one smooth complex cubic threefold and constructs an existential symmetric
cycle `theta in CH_1(F x F)`. Proposition 5.7 centers it and states

\[
                  (\phi_+)_*\widetilde\theta=2\eta,
\]

where `eta` is supported on `D_+` and has minimal cohomology class. The proof is
over `C`; it contains no uniqueness, Galois-descent, relative Hilbert/Chow
parameter space, or horizontal spreading statement. The inputs used to build
`theta` include a chosen decomposition of the diagonal, auxiliary curves and
correspondences, and lifts through universal generation by lines. Centering is
canonical only after these choices have been made.

The sentence deriving an integral half from symmetry is therefore not a
field-general descent theorem. Applied over `K_bar`, it supplies exactly the
geometric divisibility needed to define `o_K(z)` and no more.

### Voisin

Voisin's 2017 Theorem 1.7 proves over `C` that a smooth cubic threefold has
universally trivial `CH_0` exactly when the minimal class of its intermediate
Jacobian is algebraic. It neither states a function-field version nor spreads a
chosen decomposition, Shen cycle, or supported half over a curve base.

Voisin's earlier 2013 Theorems 1.8 and 1.9 do provide a genuine relative
template: relative degree-five and degree-six elliptic-curve parameter spaces
with rationally connected Abel--Jacobi fibres allow sections over curves to be
lifted by Graber--Harris--Mazur--Starr. The output is algebraicity of degree-four
integral Hodge classes on the total cubic fibration. The hypotheses do not
parameterize integral halves on `D_+`, and the theorem gives no support or
rational-equivalence statement in `CH^3(D_+)`. It is a blueprint for the kind
of representable rationally connected half-space that would suffice, not that
half-space itself.

## 3. The 2025--26 ambient results stop before support and descent

1. **Engel--de Gaay Fortman--Schreieder.** Their Theorem 1.3 says that every
   curve on the intermediate Jacobian of a very general complex cubic is an
   even multiple of the minimal class. Their matroidal spreading argument
   works on a generically finite cover of a full complex degeneration family.
   It neither computes ordinary Chow descent over `C(B)` nor applies its
   `R_10` monodromy after restriction to the special one-dimensional `A5`
   family. It supplies no class on `D_K` and no theta-sum multisection.

2. **Beckmann--de Gaay Fortman.** Proposition 3.11 and the surrounding
   Fourier-transform criteria are stated over arbitrary fields, but the
   existence of a `K`-defined minimal cycle is an input. Their constructions
   live on an abelian variety and its powers; they do not preserve support on
   `D_+` and do not compute the restriction kernel modulo two.

3. **Scavia--Suzuki.** Theorem 1.2 extends the direct-summand/minimal-class
   criterion to arbitrary fields. Once the polarization and minimal class are
   algebraic over `K`, it produces a split embedding into a product of
   Jacobians of curves with degree-one zero-cycles. C904 already has an ambient
   `K`-cycle of minimal class. The theorem adds no support on `D_+`, no integral
   half of Shen's cycle, and no odd theta-sum multisection.

4. **Kahn.** Theorem 1.10 gives relative divided powers and Fourier transforms
   for etale Chow groups only after inverting `M!`; over a curve base this
   destroys the two-primary information at issue. Proposition B.6 concerns
   torsion in the cokernel of an ordinary cycle-class map, not the kernel of
   ordinary-Chow base change. Kahn explicitly presents ordinary Chow as the
   theory where these torsion asperities remain. No statement there kills
   `o_K(z)`.

Thus none of these theorems upgrades ambient algebraicity to a horizontal
intrinsic curve on `D_+`.

## 4. The theta-sum index remains arithmetic

The fixed geometric lifting calculation gives index one after algebraic
closure: Shen's degree-two unordered Fano lift and the degree-five exceptional
plane-quintic cut combine by `3*2-5=1`. This is a statement over `K_bar` once a
geometric supported half has been chosen.

It does not compute the arithmetic index over `K`. The obstruction is precisely
the field of definition of the complete half relation. No audited source proves
that a degree-one signed zero-cycle on the geometric generic fibre descends, and
none proves that every field of definition has even degree. The honest current
alternatives are therefore:

- construct the half over `K`;
- construct it over one odd-degree extension and corestrict;
- compute `o_K(z)` as nonzero and thereby prove every halving field has even
  degree; or
- bypass `D_+` by producing an odd zero-cycle on another proper model of the
  same generic-index problem.

## 5. Charge-three Picard and top-intersection bypass

Let `V` be the smooth general fourfold fibre of the charge-three Abel--Jacobi
map. Voisin constructs the nine-dimensional stable-bundle component `M9` and a
dominant rational map from elliptic sextics, but computes neither `Pic(V)` nor a
top divisor intersection.

Li--Lin--Pertusi--Zhao provide the strongest current theorem-level input for a
compactified categorical model:

- Corollary 3.9: for a primitive numerical class, the Bridgeland moduli space is
  smooth, irreducible, projective, and fine;
- Proposition 7.6 and Corollary 7.7: in the positive-dimensional-fibre range,
  the total moduli space has `b_1=10`, `b_2=46`, and the Abel--Jacobi relative
  Neron--Severi group has rank one;
- Theorem 7.10: a general fibre is a smooth Fano variety with primitive
  canonical class.

These results do not yet identify every fibrewise line bundle as the
restriction of a global determinant line. In fact Question 8.10 asks whether
the general fibre has Picard rank one, asks for a Verlinde formula, and asks for
its cohomology. Neither the paper nor the older `M9` sources print
`(-K_V)^4`, a determinant-line fourth self-intersection, or an odd-degree
zero-cycle.

Accordingly the proposed immediate implication is valid but presently
unproved:

> If a `K`-defined determinant/anticanonical line bundle `L` on `V` has
> `L^4` odd, then `L^4` is an odd zero-cycle and
> `ind(V)=1`.

The source-backed calculation to attempt is GRR for the universal family on
the fine Bridgeland moduli space, followed by pushforward along Abel--Jacobi.
One needs first to identify the twist `E(-1)` of Voisin's classical charge-three
bundles with the relevant primitive numerical class and verify that the chosen
Bridgeland compactification has the same generic fibre. Then compute the
integer coefficient in

\[
       \Phi_*\bigl(c_1(-K_{M/J})^4\bigr)=[n]\,[J].
\]

Parity of `n` is enough. Rank-one relative Neron--Severi plus primitivity makes
this one calculation decisive for all line bundles restricted from the global
fine moduli space. It does not control line bundles existing only on the
geometric generic fibre, which is exactly the gap retained in Question 8.10.

## 6. Rational simple connectedness does not globalize this lift

De Jong--He--Starr's exact surface theorem is Corollary 12.2 (introduced as
Corollary 1.1). For a flat proper morphism `X -> S`, with `S` a smooth
projective surface, it assumes:

- away from a codimension-two subset, the total space is smooth and the fibres
  are geometrically irreducible;
- a globally defined relatively ample invertible sheaf;
- on the geometric generic fibre, Hypothesis 6.8 and a very twisting surface.

Hypothesis 6.8 is not just rational connectedness or even the informal
two-point slogan for rational simple connectedness. For a chosen notion of
lines, the one-point evaluation must have nonempty, irreducible, rationally
connected geometric fibres over an open set. In addition, chains of a fixed
length of free lines must have nonempty, irreducible, birationally rationally
connected fibres over an open in `X x_S X`. The very twisting surface is a
separate positivity input. The global relatively ample line is the hypothesis
that removes the Brauer--Severi counterexample.

Neither charge-three source verifies these conditions.

- Voisin proves that `M_{6,1} -> J` has rationally connected general fibre and
  constructs a dominant map `M_{6,1} -->> M_9` with general fibre `P^3`. The
  `P^3` fibres parameterize sections of a fixed bundle and hence collapse to
  points of `M_9`; they do not give rational curves joining two general points
  of an Abel--Jacobi fibre of `M_9`. Her sweeping residual rational curves on
  `M_{6,1}` are used to determine its MRC quotient, not to prove irreducibility
  or rational connectedness of two-pointed curve spaces on `M_9`.
- Li--Lin--Pertusi--Zhao prove that the general compactified Abel--Jacobi fibre
  is Fano, hence rationally connected, and use projective spaces of extensions
  to test the canonical class. They do not study the evaluation morphisms of
  lines through one or two general points, chains of those lines, or very
  twisting surfaces. Their Question 8.10 still asks even whether the general
  fibre is unirational.

There is also a decisive base-dimension mismatch. The fourfold
`V=(M_9 -> J)_eta` is defined over `C(J)`, where `dim J=5`. De
Jong--He--Starr's theorem applies over function fields of surfaces. Restricting
the Abel--Jacobi family to a surface `S subset J` could at best produce a
`C(S)`-point; it neither specializes upward nor supplies a zero-cycle over the
generic point of `J`. For a marked one-parameter cubic family the total
intermediate-Jacobian base has dimension six, so the mismatch persists.

Conversely, if the desired half or odd carrier could be represented by a
proper rationally connected parameter space over `K=C(B)`, ordinary
Graber--Harris--Starr over the curve already supplies a `K`-point. Thus an RSC
proof for the charge-three fibre would be substantial new geometry but would
not, by the cited surface theorem alone, globalize the current generic-index
lift.

**Verdict:** dead as a direct application. A viable resurrection would require
either a higher-dimensional-base section theorem with the requisite higher
rational connectedness, or a reduction of the actual generic-index problem to
a two-dimensional base. Neither reduction appears in the audited sources.

## 7. Sharpest safe theorem/obstruction formulation

The following is the strongest unpreempted formulation supported by the audit:

> **Relative Shen halving obstruction.** For the generic marked cubic over
> `K=C(B)`, a relative Shen cycle `z in CH_1(D_{+,K})` that becomes twice a
> supported minimal curve geometrically has a canonical obstruction
> `o_K(z)` in the geometric kernel of `CH_1(D_{+,K})/2`. It vanishes exactly
> when the integral half exists over `K`, and it remains nonzero after every
> odd-degree extension. Consequently an odd-degree complete half relation is
> equivalent, by restriction--corestriction, to a `K`-half.

This does not assert that `o_K(z)` is nonzero, that it is the only obstruction
to the full theta-sum index, or that `CH_1(D_bar)[2]` is finite. It is an exact
theorem identifying the direct crown's unresolved arithmetic datum.

## 8. Primary-source/read-depth ledger

1. **Mingmin Shen, _Rationality, universal generation and the integral Hodge
   conjecture_, arXiv:1602.07331.** Read depth: **claim-specific partial**,
   Theorem 5.1, Lemma 5.6, Proposition 5.7 and their proofs. Cached PDF key
   `arXiv:1602.07331`, SHA-256
   `2e0f3a438379830b85e0e63fce9b6d85e621c3e3d1fbbe84a4a6117773c1007c`.

2. **Claire Voisin, _On the universal CH0 group of cubic hypersurfaces_,
   arXiv:1407.7261 / JEMS 2017.** Read depth: **claim-specific partial**,
   Theorems 1.1, 1.6, 1.7 and 4.1 with the displayed proof of the minimal-class
   implication. Cached preprint key `arXiv:1407.7261`, SHA-256
   `514e5634d920f4b8e9c6797f3de5ad34afea65624ba23cc764d329ebcdd2c4e4`.

3. **Claire Voisin, _Abel-Jacobi map, integral Hodge classes and
   decomposition of the diagonal_, arXiv:1005.5621.** Read depth:
   **claim-specific partial**, Theorems 1.8, 1.9, 2.1, the construction of
   `M9` and `D_{3,3}`, and Theorem 2.11. Cached PDF key
   `arXiv:1005.5621`, SHA-256
   `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.

4. **Philip Engel, Olivier de Gaay Fortman, Stefan Schreieder, _Matroids and
   the integral Hodge conjecture for abelian varieties_,
   arXiv:2507.15704.** Read depth: **claim-specific partial**, Introduction,
   Theorems 1.1, 1.3, 1.6 and the spreading discussion in Section 1.4. Cached
   PDF key `arXiv:2507.15704`, SHA-256
   `f0284c8249c07ab5e3d9e5e49504662fad26de205563ab5a48aea27e742741ee`.

5. **Thorsten Beckmann, Olivier de Gaay Fortman, _Integral Fourier
   transforms and the integral Hodge conjecture for one-cycles on abelian
   varieties_, arXiv:2202.05230.** Read depth: **claim-specific partial**,
   notation over arbitrary fields, Sections 3.1--3.3, Proposition 3.11 and
   Corollary 4.3. Cached PDF key `arXiv:2202.05230`, SHA-256
   `ab63a64cc5be9444c4eb36609f4831e662e0f95b19e9be07d5ddb5d7d82f9fbc`.

6. **Federico Scavia, Fumiaki Suzuki, _On direct summands of products of
   Jacobians over arbitrary fields_, arXiv:2507.09821.** Read depth:
   **claim-specific partial**, Introduction and Theorems 1.1--1.2. Cached PDF
   key `arXiv:2507.09821`, SHA-256
   `56dad8d0137d146439109273591157a6660eda49d570bc640f53b1d25e6bdb9f`.

7. **Bruno Kahn, _Divided powers on abelian varieties_,
   arXiv:2602.11135.** Read depth: **claim-specific partial**, Introduction,
   Theorems 1.2, 1.10, and Appendix B.6--B.7. Cached PDF key
   `arXiv:2602.11135`, SHA-256
   `7a3c5abca22e76dbfe4d7ff8b72410b7e40c10243ad025bba3d94693f36ae883`.

8. **Humberto A. Diaz, _On the failure of Galois descent for Chow groups_,
   Journal of Algebra 667 (2025), 203--210, DOI
   `10.1016/j.jalgebra.2024.11.035`.** Read depth:
   **abstract/metadata and publisher preview only**, abstract, introduction,
   Theorem 1.1, Corollary 1.2 and displayed proof outline through the
   ScienceDirect full preview. The PDF was not accessible and is not cached.

9. **Chunyi Li, Yinbang Lin, Laura Pertusi, Xiaolei Zhao,
   _Higher dimensional moduli spaces on Kuznetsov components of Fano
   threefolds_, arXiv:2406.09124 / J. Reine Angew. Math. 832 (2026),
   81--151.** Read depth: **claim-specific partial**, Introduction,
   Corollary 3.9, Proposition 7.6, Corollary 7.7, Theorem 7.10 and Question
   8.10. Cached preprint key `arXiv:2406.09124`, SHA-256
   `c1aa5d752c9c081827d0aa2cec4ab6408e3868449ef3f7e7ba11a7f936bbdb25`.

10. **A. J. de Jong, Xuhua He, Jason Michael Starr, _Families of
    rationally simply connected varieties over surfaces and torsors for
    semisimple groups_, arXiv:0809.5224 / Publ. Math. IHES 114 (2011),
    1--85.** Read depth: **claim-specific partial**, Introduction and
    Corollaries 1.1/12.2, Theorem 1.2, Hypothesis 6.8, and the role of very
    twisting surfaces. Cached preprint key `arXiv:0809.5224`, SHA-256
    `44e7af4595261743df7d310274682bb69010f93377977da857be0d4936b1cc68`.

## 9. Search boundary

The bounded title/abstract/full-text screens used the following queries:

```text
2025 2026 "CH_1" theta divisor cubic threefold descent
2025 2026 "Sym^2 Theta" intermediate Jacobian cubic threefold
"Rationality, universal generation and the integral Hodge conjecture" cited Shen relative
"kernel" Chow group base change mod 2 function field curve CH^3
base change kernel Chow groups mod n algebraic closure theorem function field complex curve
restriction kernel CH^3(X)/2 algebraic closure Hochschild Serre motivic cohomology
Galois descent Chow groups modulo n function field C curve CH3
Chow group mod 2 restriction algebraic closure kernel unramified cohomology
cubic threefold moduli rank 2 c2=3 stable bundles Abel-Jacobi generic fiber Picard determinant line bundle intersection
M9 cubic threefold instanton moduli determinant line bundle Picard group
charge 3 instantons cubic threefold moduli Abel Jacobi fiber fourfold polarization
rank two stable sheaves cubic threefold c2=3 moduli Picard intersection numbers
"M_9" cubic threefold vector bundles Picard
"charge 3" "cubic threefold" instanton moduli Picard
"M_9" cubic threefold "rationally simply connected"
"charge 3" cubic threefold instanton "rationally simply connected"
"Abel-Jacobi" cubic threefold Fano fourfold "very twisting surface"
cubic threefold Bridgeland moduli rationally simply connected
```

The searches found the explicit 2026 Li--Lin--Pertusi--Zhao open question and
the 2025 Diaz negative theorem, but no source computing the requested kernel,
theta-sum index, or charge-three fourth self-intersection. This licenses only a
bounded negative. The exact-title RSC searches likewise found no charge-three
`M_9` or cubic-intermediate-Jacobian fibre theorem. MathSciNet and zbMATH are
**not covered**; Google Scholar's automated interface was not used. No
forward-citation count was claimed.

## Mystery ledger

- **Settled:** the fixed-fibre geometric half and fixed-fibre `2/5` lift do
  not descend automatically over `C(B)`.
- **Settled:** EFS, BdGF, Scavia--Suzuki and Kahn do not compute the ordinary
  mod-two Chow restriction kernel or preserve support on `D_+`.
- **Settled:** `cd(K)=1` is not an automatic higher-Chow descent theorem.
- **Settled:** current sources do not print the charge-three determinant-line
  fourth self-intersection; the latest source explicitly leaves the needed
  Picard/cohomology/Verlinde data open.
- **Open:** compute `o_K(z)`, or find an odd-degree complete half relation.
- **Open:** identify Voisin's `M9` generic fibre with the relevant fine
  Bridgeland compactification and compute `(-K_V)^4` by GRR.
- **Dead as stated:** replace ordinary Chow by etale Chow after inverting a
  factorial; this discards the two-primary obstruction.
- **Dead as stated:** use ambient minimal-class algebraicity or a direct
  Jacobian summand to infer support on `D_+`.
- **Dead as stated:** infer an odd zero-cycle from primitivity of `-K_V`
  without computing its fourth self-intersection.
- **Dead as stated:** apply the de Jong--He--Starr surface theorem directly to
  the generic Abel--Jacobi fibre over the five-dimensional base `J`.
- **Open but not presently a closure:** prove the charge-three fibre satisfies
  Hypothesis 6.8 and contains a very twisting surface; no audited rational-curve
  family supplies the needed two-point evaluation geometry.
