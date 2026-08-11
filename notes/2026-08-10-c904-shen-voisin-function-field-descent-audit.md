# C904 Shen--Voisin function-field descent audit

Date: 2026-08-10
Status: primary-source closure; the proposed canonical descent is **not
established**
Scope: Shen Proposition 5.7, Voisin's minimal-class criterion, and
`K=C(B)`; no manuscript or Lean change

## Executive verdict

The fixed-complex-fibre implication is sound at the theorem level:

\[
\frac{\Theta^4}{4!}\text{ algebraic}
 \Longrightarrow CH_0(X)\text{ universally trivial}
 \Longrightarrow \widetilde\theta\in CH_1(F\times F)
 \Longrightarrow (\phi_+)_*\widetilde\theta=2\eta,
\]

where `eta` is supported on the sum divisor `D_+` and has, up to the sign
convention for the principal polarization, the minimal cohomology class.
The cited theorems prove this for a smooth cubic threefold over `C`.

They do **not** prove the corresponding chain over `K=C(B)`, and they do
not make either `tilde theta` or `eta` canonical.  In particular, the two
key assertions under audit have the following answers.

1. **“The centered `tilde theta` is canonical over `K`”: no.**  Centering
   is a canonical operation *after* a cycle `theta` and a reference line
   have been chosen.  Shen's `theta` is existential and depends on a Chow
   decomposition of the diagonal, auxiliary curves and correspondences,
   lifts through universal generation by lines, and spreads from generic
   points.  The source contains no uniqueness or Galois-descent theorem
   for it.

2. **“`(phi_+)_* tilde theta=2 eta` gives a canonical `eta` over `K`”:
   no.**  Conditional on a `K`-defined `tilde theta`, the left side is a
   `K`-defined cycle.  Shen proves the existence of an integral half over
   `C`, in one sentence using symmetry.  He neither states nor proves a
   field-general integral quotient lemma, and a half is not unique: its
   ambiguity lies at least in two-torsion in the relevant Chow group.

3. **“A geometric `eta` descends up to two-torsion”: only as a necessary
   cocycle statement, not as descent.**  If

   \[
      z=(\phi_+)_*\widetilde\theta\in CH_1(J_K),\qquad
      2\eta_{\bar K}=z_{\bar K},
   \]

   then for every `sigma in Gal(bar K/K)`,

   \[
       \delta_\sigma=\sigma\eta_{\bar K}-\eta_{\bar K}
       \in CH_1(J_{\bar K})[2].
   \]

   The classes `delta_sigma` form a Galois cocycle.  This says that the
   set of geometric halves is a two-primary Chow torsor.  It does not say
   that the torsor has a `K`-point.  Even killing this cocycle would only
   produce a Galois-invariant Chow class; invariants of a geometric Chow
   group need not lie in the image of `CH_1(J_K)`.  Requiring a
   representative supported on `D_+` adds the kernel of
   `CH_1(D_{+,bar K})->CH_1(J_bar K)` to the obstruction.

Thus the proposed eleventh-pass shortcut does not close the relative
cycle gate.  The strongest safe statement is:

> The marked geometry `F`, `Theta`, `D_+`, and the sum quotient is defined
> over `K`.  A `K`-defined Chow decomposition of the cubic plus a
> field-general integral quotient argument would give the *existence* of
> a `K`-defined Shen half.  Neither input follows from the presently cited
> fibrewise complex theorem, and neither half is canonical.

## 1. What Shen proves exactly

### 1.1 Construction of `theta`

Shen, Theorem 5.1, assumes a Chow-theoretic decomposition of the diagonal
for a complex cubic threefold.  Its proof invokes Proposition 3.2 and then
chooses:

- curves `Z_i`, correspondences `Gamma_i`, and integers `n_i` realizing a
  diagonal decomposition;
- cycles `T_i` lifting the generic restrictions of `Gamma_i` through the
  universal family of lines; and
- spreads of those generic cycles.

It sets

\[
                  \theta=\sum_i n_i T_i\circ{}^tT_i.
\]

This produces *a* swap-symmetric cycle.  None of the choices is unique.
If two choices produce `theta` and `theta'`, the theorem gives no reason
for their centered difference to vanish in `CH_1(F times F)`, or even for
their pushforwards to agree in `CH_1(J)` rather than merely have the same
cohomological pairing.  The source therefore supports existence, not
canonicity.

The only genuinely field-general input in this part is Shen's Theorem
4.1: for a smooth cubic over an arbitrary field, the universal line
universally generates `CH_1` provided `CH_0(F)` has an element of degree
one.  A `K`-rational common line supplies such an element.  Proposition
3.2 and Theorem 5.1 themselves are stated over `C`.  Their proofs are
largely algebraic and plausibly extend to characteristic zero after
reproving resolution/spreading steps, but that extension is proof work,
not a cited theorem.

### 1.2 Centering and the source's type error

Shen writes

\[
 \theta_1=(\operatorname{pr}_1)_*\theta,
 \qquad
 \widetilde\theta=\theta-\theta_1\times o-o\times\theta_1.
\]

In both arXiv v2 and the published Geometry & Topology proof,
Proposition 5.7 calls `o` the zero element of `J`.  As printed, this is
ill-typed: all three terms are asserted to lie on `F times F`, so `o`
must be a point of `F` whose Abel--Jacobi image is zero.  Choosing a
reference line and normalizing its Abel--Jacobi image to zero repairs the
formula.  The common-line marking gives exactly such a `K`-point.

With that repair, centering is defined over `K` **relative to `theta`**.
It removes the marginal cohomological terms; it does not remove the Chow
choices used to construct `theta`.

### 1.3 The half on `D_+`

Shen computes, in integral singular cohomology,

\[
 \langle(\phi_+)_*[\widetilde\theta],\alpha\cup\beta\rangle
      =2\langle\alpha,\beta\rangle_X.
\]

He then writes:

> Since `tilde theta` is again a symmetric cycle, we know that
> `(phi_+)_* tilde theta = 2 eta`.

This is the complete integral-divisibility argument in the source.  The
intended geometry is the factorization

\[
 F\times F\longrightarrow \operatorname{Sym}^2F
 \longrightarrow D_+,
\]

whose first map has degree two and whose second map is birational.
However, invariance of a cycle under the swap is not, without an
additional integral quotient or equivariant moving lemma, a formal proof
that its pushforward is twice a cycle: one must control components on the
swap-fixed diagonal.  Such an argument may well repair and relativize the
sentence, but it is not supplied by Proposition 5.7.  The current
common-line note's claim that one may move the cycle off the fixed locus
should therefore be treated as a proof obligation, not as source-backed.

Even after this integral descent is supplied, `eta` depends on `theta` and
on a choice of half.  Its cohomology class is canonical; its Chow class is
not shown to be.

## 2. What Voisin proves exactly

Voisin's 2017 JEMS paper works with smooth projective complex varieties.
For a complex rationally connected threefold, Theorem 4.1 characterizes a
cohomological decomposition of the diagonal by:

1. torsion-freeness of `H^3(X,Z)`;
2. a universal codimension-two cycle on `J(X) times X`; and
3. algebraicity of the minimal class on `J(X)`.

For a complex cubic threefold, Corollary 4.4 combines this with:

- the Markushevich--Tikhomirov parameterization of `J(X)` by cycles with
  rationally connected general fibre;
- Voisin's earlier construction of a universal codimension-two cycle from
  a minimal curve and that parameterization; and
- the complex cubic theorem that cohomological and Chow decompositions of
  the diagonal are equivalent.

This proves over `C`

\[
        \Theta^4/4!\text{ algebraic}
        \quad\Longleftrightarrow\quad
        CH_0(X)\text{ universally trivial}.
\]

It is not stated over a nonclosed function field.

The earlier Voisin paper makes the rational-connectedness step explicit.
Given a minimal cycle `Gamma=sum n_i Gamma_i` on `J(X)`, one moves its
smooth curve components into the good locus of a rationally connected
parameterization `M -> J` and invokes Graber--Harris--Starr to choose lifts
`Gamma_i -> M`.  Those lifts are then combined on a symmetric power to
construct a universal cycle inducing the identity on `J`.

This is an existence argument with choices.  Over `K=C(B)`, base-changing
`M -> J` to a curve `Gamma_i/K` asks for a rational point over
`K(Gamma_i)`.  After spreading, that is a rationally connected fibration
over a variety of dimension `dim(B)+1`, not over a complex curve.  GHS
therefore does not apply.  Over `bar K`, GHS gives a geometric lift; its
descent is another finite/Chow torsor problem.

In particular, even when `B` is a curve and Tsen--GHS handles rationally
connected varieties over `K=C(B)` itself, the field needed to lift a
minimal **curve** is `K(Gamma_i)`, of transcendence degree two over `C`.
That extra variable is essential.

## 3. Classification of every choice

### 3.1 Canonical over `K` (on the marked common-line family)

The following data are algebraic over `K`, after restricting to the smooth
family and using the common line `s`:

- the cubic `X_K`, Fano surface `F_K`, and universal line;
- the Albanese/Prym intermediate Jacobian `J_K` with its principal
  polarization;
- the normalized Abel--Jacobi map
  `a_s(l)=AJ(l-s)` and its zero `a_s(s)=0`;
- `Theta=F-F`, `D_{+,s}=F+F`, and the sum/difference maps;
- `F times F -> Sym^2 F -> D_{+,s}`, with the latter birational after
  geometric base change; and
- for a **chosen** `theta_K`, its marginal, centered cycle, and the doubled
  cycle `z=(phi_+)_* tilde theta`.

The word “canonical” in the last bullet is only functoriality relative to
the chosen `theta`; it does not make `theta` canonical.

### 3.2 Rationally connected choices (GHS)

Voisin's lift of each minimal curve through the
Markushevich--Tikhomirov/Voisin Abel--Jacobi parameter space is of this
type.  GHS supplies a section over a curve over an algebraically closed
field of characteristic zero.  It supplies neither uniqueness nor descent
to `K`.

For `K=C(B)`, it applies directly only when the relevant model really has
a complex curve as base.  The curve-over-`K` needed in Voisin's construction
spreads to a higher-dimensional base, so this invocation cannot be reused
unchanged.

### 3.3 Connected-linear torsors (Steinberg)

Coordinate frames, bases, and some trivializations can form torsors under
connected linear groups.  When `K` is a one-variable complex function
field, the Steinberg/Tsen cohomological-dimension-one theorem can kill such
torsors under its hypotheses.  If `dim(B)>1`, that blanket statement is
unavailable.

More importantly, none of the load-bearing choices above has been shown to
be a connected-linear torsor.  A choice of diagonal decomposition, a lift
in a Chow group, a rational equivalence, a half of a Chow class, and a
section of a rationally connected fibration are not converted into
connected-linear torsors by the cited sources.  Steinberg therefore does
not close this gate.  One must also not substitute `PGL_n`-torsor
triviality over a general field: its `H^1` is controlled by the Brauer
group.

### 3.4 Finite, abelian, and Chow torsors

These are the actual unresolved choices:

- spreading a geometric diagonal decomposition or Shen cycle generally
  yields a cycle only after a generically finite extension of `K`;
- without the common line, normalization of the Abel--Jacobi map is an
  Albanese/degree-one-cycle problem; the marking removes this particular
  torsor;
- the lifts `T_i` form fibres of homomorphisms of Chow groups, hence
  torsors under Chow kernels, not linear groups;
- choices of rational equivalence and of spreads are Chow/Hilbert-scheme
  choices with no connectedness or rational-connectedness theorem in the
  cited argument; and
- halves of `z` form a torsor under `CH_1(J_bar K)[2]` (and the
  support-preserving version has an additional pushforward-kernel
  obstruction).

If a geometric half is defined over a finite Galois extension `L/K`, norm
only gives

\[
                    2\operatorname{Nm}_{L/K}(\eta)=[L:K]z.
\]

An odd degree would permit a Bezout recovery of a half; an even degree
does not.  The sources provide no odd-degree field of definition.

## 4. Essential complex/Hodge inputs

The following steps are not merely formal Chow manipulations over `K` in
the cited proofs.

1. The intermediate Jacobian, its principal polarization, and the
   identification `H^1(J,Z)=H^3(X,Z)` are introduced using complex Hodge
   theory.  In the marked cubic family an algebraic Prym/Albanese model can
   replace the analytic construction, but this replacement has to be
   stated.

2. The identities

   \[
   a_*[F]=\Theta^3/3!,\qquad [D_+]=3\Theta,
   \qquad \deg(F\times F\to D_+)=2
   \]

   and Shen's pairing calculation are proved using integral singular
   cohomology and the Clemens--Griffiths polarization conventions.  They
   can be checked after embedding/base change to `C`, but cohomological
   verification does not descend a Chow half.

3. The conclusion that `eta` has minimal class is an integral
   cohomological statement.  It determines a cycle class, not a unique
   Chow class.

4. Voisin's criterion connecting a minimal algebraic class, a universal
   codimension-two cycle, and a cohomological diagonal is a theorem about
   complex rationally connected threefolds and integral Hodge/singular
   cohomology.

5. The construction of the universal cycle uses GHS over complex curves.
   It is algebraic but not field-general in the form needed over
   `K(Gamma)`.

6. The passage from a cohomological diagonal to a Chow diagonal for cubic
   hypersurfaces uses the complex theorem on `Hilb^2(X)`, algebraic
   equivalence/nilpotence, and a hypothesis phrased in integral complex
   cohomology.  No `K=C(B)` version is cited.

Thus “the geometric generic fibre is a complex cubic after base change”
only proves the statement over `bar K`.  It does not provide a horizontal
cycle or a Chow decomposition over `K`.

## 5. Safe theorem package and remaining proof gates

The following relative package is safe now.

**Marked geometric package.**  The common line canonically normalizes the
relative Abel--Jacobi map.  Hence `F subset Theta`, the relative sum
divisor `D_+`, and the birational unordered map
`Sym^2 F -> D_+` are defined over the marked base.

**Fixed-fibre Shen package.**  On every complex fibre for which universal
`CH_0` triviality is known, Shen supplies some centered symmetric cycle and
some minimal cycle on `D_+` with doubled pushforward.

The missing implication is exactly:

\[
 \text{fibrewise existence over }\bar K
 \not\Rightarrow
 \text{a horizontal }\widetilde\theta_K\text{ or }\eta_K.
\]

A valid closure needs one of the following new inputs:

1. an explicit relative diagonal decomposition and explicit relative
   Shen lifts;
2. a field-general Voisin theorem plus a rational point theorem for the
   actual rationally connected fibration over `K(Gamma)`;
3. a direct canonical cycle formula (for example a tautological or
   divided-power formula) that avoids all Chow choices; or
4. a proof that the relevant finite/Chow torsor has odd index, followed by
   restriction--corestriction/Bezout.

Merely observing that conjugates of `eta` differ by two-torsion supplies
none of these.

## 6. Primary sources and read depth

1. M. Shen, *Rationality, universal generation and the integral Hodge
   conjecture*, Geometry & Topology 23 (2019), 2861--2898, especially
   Proposition 3.2, Lemma 3.4, Theorem 4.1, Theorem 5.1, Lemma 5.6, and
   Proposition 5.7.  Full relevant proofs read.  Cached as
   `arXiv:1602.07331`, SHA-256
   `2e0f3a438379830b85e0e63fce9b6d85e621c3e3d1fbbe84a4a6117773c1007c`.

2. C. Voisin, *On the universal CH0 group of cubic hypersurfaces*, JEMS
   19 (2017), 1619--1653, especially Theorems 1.1, 1.6, 1.7 and Theorem
   4.1/Corollary 4.4.  Full relevant proofs read.  Cached as
   `arXiv:1407.7261`, SHA-256
   `514e5634d920f4b8e9c6797f3de5ad34afea65624ba23cc764d329ebcdd2c4e4`.

3. C. Voisin, *Abel--Jacobi map, integral Hodge classes and decomposition
   of the diagonal*, J. Algebraic Geom. 22 (2013), 141--174, especially
   Theorems 1.4, 1.8, 1.9 and Theorem 3.1.  Full relevant proofs read.
   Cached as `arXiv:1005.5621`, SHA-256
   `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.

No primary source found in this bounded audit states the Shen
`eta` construction over a nonclosed function field, proves it canonical,
or kills its two-primary Chow descent torsor.

## Mystery ledger

- **Closed:** Shen's `theta`, `tilde theta`, and `eta` are existential, not
  canonical.
- **Closed:** common-line normalization repairs the printed `o in J` type
  error and removes the origin torsor, but not the Chow torsors.
- **Closed:** geometric conjugates of a half differ by two-torsion; this is
  a cocycle obstruction, not a descent theorem.
- **Closed:** GHS is used on complex curve components and does not directly
  solve the lift over `K(Gamma)`.
- **Open proof debt:** a field-general integral quotient lemma justifying
  “symmetric implies twice” with swap-fixed components controlled.
- **Open geometric gate:** construct a horizontal diagonal/Shen cycle, or
  prove odd index for its finite/Chow field of definition.
