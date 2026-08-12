# C908 follow-on: the graph-sandwich lemma — composed-form correspondences are exactly pullbacks

Date: 2026-08-11

Status: **the integral identity holds, with no correction term and no excess
class**; consequently Theorem B of `notes/2026-08-11-c908-p15-fourier-saturation.md`
applies verbatim to every composed-form integral lift of `Pi_15`, and the crown is
forced off the abelian fivefold. Mathematics only; no manuscript, PDF, mirror,
Lean, script, or certificate change; no pre-existing file edited.

This note closes the item recorded as the first follow-on lemma in
`notes/2026-08-11-c908-p15-fourier-saturation.md` §5 and §8:
*is `{}^t Gamma_b o Lambda_J^2 o Gamma_b` a refined pullback `(b x b)^* Lambda_J^2`?*

## 0. Verdict in one paragraph

Yes, and integrally, and in far greater generality than needed: for **any** proper
morphism `f: M -> J` of smooth varieties over a field, proper over the base, and
**any** class `alpha` in `CH^*(J x J)`, the graph sandwich
`{}^t Gamma_f o alpha o Gamma_f` equals `(f x f)^* alpha` in `CH^*(M x M)` on the
nose. The proof needs only flat pull-back of a graph cycle, the projection formula
for a proper morphism of smooth varieties, and contravariant functoriality of
pull-back. It never intersects two badly-positioned cycles, so no Tor-independence
hypothesis and no excess class enters; the one fibre square where excess could
conceivably have appeared is verified Tor-independent below anyway. The identity
holds in integral Chow groups, hence also in integral cohomology. **No correction
term exists to compute.**

The consequence for the crown is a strengthening, not a weakening, of the C908
no-go: the set of composed-form classes is *precisely* the image of `(b x b)^*`,
so Theorem B kills all of them at once, and the surviving crown candidate must
satisfy the necessary condition

> `Gamma` is **not** in the image of `(b x b)^*: H^6(J x J, Z) -> H^6(M x M, Z)`,

i.e. it cannot be assembled as `b^* o (anything on J x J) o b_*`. Every
denominator-clearing of Lieberman's rational inverse-Lefschetz operator on the
abelian fivefold `J` — Milne's construction included — produces exactly a class in
that image and is therefore dead, independently of whether the denominators can be
cleared at all.

## 1. Setting, conventions, degree bookkeeping

All varieties are smooth and projective over a fixed field `k`; `M` has dimension
`m`, `J` dimension `n`. `CH^*` is the integral Chow ring; `H^*(-, Z)` is singular
cohomology of the associated complex analytic space when `k = C`. Nothing below
uses the specific geometry of the theta resolution until §5.

**Correspondence composition.** For `X, Y, Z` smooth projective, `a` in
`CH^*(X x Y)`, `c` in `CH^*(Y x Z)`, write

\[
   c \circ a \;=\; p_{13*}\bigl(p_{12}^*a \cdot p_{23}^*c\bigr)\;\in\;CH^*(X\times Z),
   \tag{1.1}
\]

with `p_{ij}` the projections from `X x Y x Z`. Composition is associative and
`Gamma_g o Gamma_f = Gamma_{g o f}` (Fulton §16.1, Prop. 16.1.1). The induced
map on Chow groups is `a_*(x) = p_{Y*}(a . p_X^* x)`, and `(c o a)_* = c_* o a_*`.

**Degree bookkeeping.** If `a` is in `CH^p(X x Y)` and `c` in `CH^q(Y x Z)`, then
`c o a` is in `CH^{p+q-\dim Y}(X x Z)`. (Immediate from (1.1): the product has
codimension `p+q` in a variety of dimension `d_X + d_Y + d_Z`, and `p_{13*}`
preserves cycle dimension.)

**Graphs.** `gamma_f = (id_M, f): M -> M x J` is a closed embedding with image
`Gamma_f`; put `Gamma_f = gamma_{f*}[M]` in `CH^n(M x J)`. Likewise
`{}^t gamma_f = (f, id_M): M -> J x M` with image class `{}^t Gamma_f` in
`CH^n(J x M)`. Both are regular embeddings because the respective targets are
smooth, but *regularity is not used below*: only properness and smoothness of
source and target matter.

**The two induced maps.** For `x` in `CH^*(M)` and `y` in `CH^*(J)`:

\[
  (\Gamma_f)_*(x) \;=\; p_{J*}\bigl(\gamma_{f*}[M]\cdot p_M^*x\bigr)
  \;=\; p_{J*}\gamma_{f*}\bigl(\gamma_f^*p_M^*x\bigr) \;=\; f_*x,
  \tag{1.2}
\]
\[
  ({}^t\Gamma_f)_*(y) \;=\; p_{M*}\bigl({}^t\gamma_{f*}[M]\cdot p_J^*y\bigr)
  \;=\; p_{M*}{}^t\gamma_{f*}\bigl(f^*y\bigr) \;=\; f^*y .
  \tag{1.3}
\]

Both use only the projection formula in the form (2.1) below, plus
`p_J o gamma_f = f`, `p_M o gamma_f = id`, `p_M o {}^t gamma_f = id`,
`p_J o {}^t gamma_f = f`. Degrees: `({}^t Gamma_f)_*` sends `CH^j(J)` to
`CH^j(M)`, as `f^*` must.

Hence for `alpha` in `CH^*(J x J)` the sandwich `{}^t Gamma_f o alpha o Gamma_f`
induces `f^* o alpha_* o f_*` on `CH^*(M)` — the operator written
`b^* o Lambda_J^2 o b_*` in `notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md`
§§2.3, 3. The two notations name the same object; (1.2)–(1.3) is the translation.

**Degrees for the case at hand.** With `dim J = 5`, an operator lowering
cohomological degree by `2` is a correspondence of codimension `4`, so Lieberman's
`Lambda_J` lies in `CH^4(J x J)_Q` and `Lambda_J^2` in
`CH^{4+4-5}(J x J)_Q = CH^3(J x J)_Q`. With `dim M = 4`, `n = 5`, the sandwich of a
codimension-`k` class is again codimension `k`:

\[
  \Gamma_b \in CH^5(M\times J),\quad
  \alpha\in CH^k(J\times J)\ \Longrightarrow\
  \alpha\circ\Gamma_b\in CH^{5+k-5}(M\times J)=CH^k(M\times J),
\]
\[
  {}^t\Gamma_b\in CH^5(J\times M)\ \Longrightarrow\
  {}^t\Gamma_b\circ\bigl(\alpha\circ\Gamma_b\bigr)\in CH^{k+5-5}(M\times M)=CH^k(M\times M).
\]

So `Pi_15 = {}^t Gamma_b o Lambda_J^2 o Gamma_b` sits in `CH^3(M x M)_Q`,
matching both source notes, and `(b x b)^*` likewise preserves codimension `3`.
The degree bookkeeping is therefore consistent with the identity being asserted,
which it need not have been.

## 2. External inputs, with loci

Proved-from-scratch material is marked in §3; everything here is cited.

- **(F1) Flat pull-back of cycles.** Fulton, *Intersection Theory*, 2nd ed.
  (Springer, 1998), §1.7. For `p` flat and `V` a subvariety of the target,
  `p^*[V] = [p^{-1}V]` with `p^{-1}V` the scheme-theoretic preimage.
- **(F2) Pull-back to a smooth target, via the graph.** Fulton §8.1: for
  `h: X -> Y` with `Y` smooth, `h^*` is defined by `h^*(y) = gamma_h^!([X] x y)`
  using the regular embedding `gamma_h: X -> X x Y`; when `h` is flat this agrees
  with the flat pull-back of (F1).
- **(F3) Ring structure, functoriality, projection formula.** Fulton Prop. 8.3:
  for morphisms of smooth varieties, `h^*` is a ring homomorphism,
  `(h' o h)^* = h^* o h'^*`, and for `h` proper
  `h_*(x . h^* y) = h_*(x) . y`. Specialized to `x = [X]`:
  \[
     h_*\bigl(h^*y\bigr) \;=\; h_*[X]\cdot y .
     \tag{2.1}
  \]
  Identity (2.1) is the only nontrivial engine of §3.
- **(F4) Refined Gysin maps and their proper push-forward compatibility.** Fulton
  §6.2, Theorem 6.2(a). Used only in §4 (the excess/Tor discussion), not in the
  proof.
- **(F5) Excess intersection formula.** Fulton §6.3, Prop. 6.3. Used only to
  locate where a correction term *would* have appeared.
- **(F6) Gysin maps for local complete intersection morphisms.** Fulton §6.6,
  Prop. 6.6. Any morphism of smooth varieties is l.c.i. (factor it as graph —
  a regular embedding, the target being smooth — followed by a smooth projection),
  and its l.c.i. Gysin map coincides with the graph-construction pull-back (F2).
- **(F7) Composition of correspondences.** Fulton Ch. 16, §16.1, Prop. 16.1.1:
  the definition (1.1), associativity, `Gamma_g o Gamma_f = Gamma_{g o f}`, and
  `(c o a)_* = c_* o a_*`.
- **(F8) Cycle class map.** Fulton Ch. 19, §19.1: `cl` commutes with proper
  push-forward, with pull-back along morphisms of smooth varieties, and with
  intersection products; hence with correspondence composition.
- **(L1) Lieberman / Milne.** J. S. Milne, *Lefschetz classes on abelian
  varieties*, Duke Math. J. 96 (1999), §5, esp. Thm. 5.9 and Rem. 5.11 — the
  rational algebraicity of the inverse-Lefschetz operator `Lambda_J` on an abelian
  variety. Read depth: claim-specific partial (inherited from
  `notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md` §6, which records
  the cached PDF hash). Used only to say what `Lambda_J^2` *is*; the lemma is
  independent of it.
- **(R1) Repo-internal, cited not reproved.** Theorem B and Lemma A of
  `notes/2026-08-11-c908-p15-fourier-saturation.md` §§4.2, 5; the weak-Lefschetz
  identifications `H^1(M,Z) = b^*H^1(J,Z)`, `b^*: H^3(J,Z) -> H^3(M,Z)`
  an isomorphism, and the Smith form
  `coker(L: \wedge^5 Lambda -> \wedge^7 Lambda) = (Z/2)^{10}` from
  `notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md` §§2.2, 2.3, eq.
  (2.2)–(2.3).

**Numbering caveat.** The Fulton section and statement numbers above are recalled,
not checked against a copy — no copy of the book is present on this host or in
`/tmp/persistent/tavis/lit-search/`. The *statements* are standard and are used
exactly as quoted; before any of this reaches a manuscript, the numbers
(especially "Prop. 8.3", "Theorem 6.2(a)", "Prop. 16.1.1") must be verified
against the second edition.

## 3. The graph-sandwich lemma

Stated in the generality the proof gives, which costs nothing and is worth having:
the two legs may be different morphisms.

> **Lemma 3.1 (one-sided half-steps).** Let `M, N, J` be smooth projective over
> `k`, and `f: M -> J`, `g: N -> J` morphisms.
>
> (i) For every `alpha` in `CH^*(J x J)`,
> \[ \alpha\circ\Gamma_f \;=\; (f\times id_J)^*\alpha \quad\text{in } CH^*(M\times J). \]
>
> (ii) For every `beta` in `CH^*(M x J)`,
> \[ {}^t\Gamma_g\circ\beta \;=\; (id_M\times g)^*\beta \quad\text{in } CH^*(M\times N). \]

*Proof of (i).* Work in `M x J x J`, dimension `m + 2n`, smooth. The projection
`p_{12}: M x J x J -> M x J` is flat and
`p_{12}^{-1}(\Gamma_f) = \Gamma_f \times J` scheme-theoretically, this being
reduced and irreducible; so by (F1) and (F2)

\[
  p_{12}^*\Gamma_f \;=\; [\Gamma_f\times J]\;=\;
  (\gamma_f\times id_J)_*[M\times J],
  \tag{3.1}
\]

the last equality because `gamma_f x id_J: M x J -> M x J x J` is a closed
embedding onto `Gamma_f x J`. Write `j = gamma_f x id_J`. Both `M x J` and
`M x J x J` are smooth and `j` is proper, so (2.1) applies with
`y = p_{23}^* alpha`:

\[
  p_{12}^*\Gamma_f\cdot p_{23}^*\alpha
  \;=\; j_*[M\times J]\cdot p_{23}^*\alpha
  \;=\; j_*\bigl(j^*p_{23}^*\alpha\bigr).
  \tag{3.2}
\]

Now `p_{23} o j: (x,y) |-> (x, f(x), y) |-> (f(x), y)` is `f x id_J`, so by
functoriality (F3) `j^* p_{23}^* alpha = (f x id_J)^* alpha`. And
`p_{13} o j: (x,y) |-> (x, f(x), y) |-> (x,y)` is the identity of `M x J`, so
`p_{13*} j_* = id`. Substituting into (1.1),

\[
  \alpha\circ\Gamma_f \;=\; p_{13*}j_*\bigl((f\times id_J)^*\alpha\bigr)
  \;=\; (f\times id_J)^*\alpha . \qquad\square
\]

*Proof of (ii).* Work in `M x J x N`, smooth. Here `p_{23}` is flat and
`p_{23}^{-1}({}^t\Gamma_g) = M \times {}^t\Gamma_g`, which is the image of the
closed embedding `j' = id_M \times {}^t\gamma_g: M \times N \to M \times J \times N`,
`(x,z) \mapsto (x, g(z), z)`. So `p_{23}^*({}^t\Gamma_g) = j'_*[M\times N]` and,
by (2.1) again,

\[
  p_{12}^*\beta\cdot p_{23}^*({}^t\Gamma_g)
  \;=\; j'_*\bigl(j'^*p_{12}^*\beta\bigr).
\]

Here `p_{12} o j': (x,z) |-> (x, g(z))` is `id_M x g`, and
`p_{13} o j': (x,z) |-> (x,z)` is the identity of `M x N`. Hence
`{}^t\Gamma_g \circ \beta = (id_M \times g)^*\beta`. `\square`

> **Theorem 3.2 (graph sandwich = pullback, integrally).** With `M, N, J, f, g` as
> in Lemma 3.1 and `alpha` in `CH^k(J x J)`,
> \[
>   {}^t\Gamma_g\circ\alpha\circ\Gamma_f \;=\; (f\times g)^*\alpha
>   \qquad\text{in } CH^k(M\times N).
> \]
> In particular, for `f = g`,
> `{}^t\Gamma_f \circ \alpha \circ \Gamma_f = (f\times f)^*\alpha` in
> `CH^k(M \times M)`.

*Proof.* By associativity (F7) the triple composite is unambiguous; compute it as
`{}^t\Gamma_g \circ (\alpha \circ \Gamma_f)`. Lemma 3.1(i) gives
`\alpha\circ\Gamma_f = (f\times id_J)^*\alpha` in `CH^k(M\times J)`; Lemma 3.1(ii)
gives `{}^t\Gamma_g\circ(f\times id_J)^*\alpha = (id_M\times g)^*(f\times id_J)^*\alpha`.
By functoriality (F3) this is `\bigl((f\times id_J)\circ(id_M\times g)\bigr)^*\alpha`,
and `(x,z)\mapsto(x,g(z))\mapsto(f(x),g(z))` is `f\times g`. `\square`

> **Corollary 3.3 (integral cohomology).** The same identity holds in
> `H^{2k}(M\times N, Z)` for the topological correspondence composition and the
> topological pull-back, either by applying `cl` to Theorem 3.2 (F8) or by repeating
> the proof verbatim: (3.1) becomes the statement that the pull-back of the
> Poincare-dual class of a submanifold along a submersion is the dual class of the
> preimage submanifold, and (2.1) is the topological projection formula for a proper
> map of closed oriented manifolds.

**Which theory the argument supports.** Both, with `CH^*` primary. Nothing in §3
is rational, nothing is torsion-sensitive, and no divisibility is invoked.

**Sharpening worth recording.** Theorem 3.2 says the map

\[
   \Sigma: CH^k(J\times J)\longrightarrow CH^k(M\times M),\qquad
   \Sigma(L) = {}^t\Gamma_f\circ L\circ\Gamma_f
\]

*is* `(f\times f)^*`. So "of composed form through `J x J`" and "in the image of
`(f x f)^*`" are the same condition, not one contained in the other. That equality
of conditions is what makes §5 a clean dichotomy.

## 4. Where excess or Tor-failure could have entered, and why it does not

The task framing anticipated a refined-Gysin computation over a fibre square, with
a possible excess correction supported on the exceptional locus. The proof above
avoids the issue structurally; for completeness, all three places a correction
could have appeared are examined.

**(a) The candidate dangerous square.** Since `b x b = (b x id_J) o (id_M x b)`,
one might compute `(b x b)^*` as a composite of two refined Gysin maps across

\[
\begin{array}{ccc}
 M\times M & \xrightarrow{\;id_M\times b\;} & M\times J\\
 \downarrow{\scriptstyle b\times id_M} & & \downarrow{\scriptstyle b\times id_J}\\
 J\times M & \xrightarrow{\;id_J\times b\;} & J\times J
\end{array}
\tag{4.1}
\]

which is a fibre square: `(M\times J)\times_{J\times J}(J\times M) = M\times M`,
since the condition `(b(x), y) = (y', b(z))` forces `y = b(z)`, `y' = b(x)` and
leaves `(x,z)` free. Composing refined Gysin maps across (4.1) without an excess
term requires Tor-independence. It holds:

> **Lemma 4.1.** The square (4.1) is Tor-independent, i.e.
> `Tor_p^{\mathcal O_{J\times J}}(\mathcal O_{M\times J}, \mathcal O_{J\times M}) = 0`
> for `p > 0`, the degree-zero term being `\mathcal O_{M\times M}`.

*Proof.* Locally on `J`, choose a resolution `F_\bullet \to \mathcal O_M` of
`\mathcal O_M` by `\mathcal O_J`-flat sheaves. Then
`F_\bullet\boxtimes\mathcal O_J \to \mathcal O_{M\times J}` is a resolution by
`\mathcal O_{J\times J}`-flat sheaves, since an exterior tensor product of a
`\mathcal O_J`-flat sheaf with `\mathcal O_J` is flat over
`\mathcal O_J\boxtimes\mathcal O_J`. Therefore

\[
 Tor_*^{\mathcal O_{J\times J}}(\mathcal O_{M\times J},\mathcal O_{J\times M})
 = H_*\bigl((F_\bullet\boxtimes\mathcal O_J)\otimes_{\mathcal O_{J\times J}}
   (\mathcal O_J\boxtimes\mathcal O_M)\bigr)
 = H_*\bigl(F_\bullet\boxtimes\mathcal O_M\bigr)
 = H_*(F_\bullet)\boxtimes\mathcal O_M,
\]

using that exterior tensoring with a fixed sheaf over the base field is exact.
This is `\mathcal O_M\boxtimes\mathcal O_M = \mathcal O_{M\times M}` in degree `0`
and zero above. `\square`

So even the route that could have produced an excess term produces none: by (F4)
and (F6), `(b\times b)^! = (id_M\times b)^!\circ(b\times id_J)^!` with no excess
class, in agreement with Theorem 3.2. Note that Lemma 4.1 is insensitive to the
singularity of `Theta` and to the exceptional divisor of `sigma`; it only uses
flatness of `\mathcal O_J` over itself.

**(b) l.c.i.-ness of `b`.** The task's justification (`sigma` a blow-up morphism,
`i` a regular embedding) is correct but fragile, because `Theta` is singular at the
origin and `sigma: M \to Theta` is a morphism to a singular variety. The robust
statement is (F6): `b` is a morphism between smooth varieties, hence l.c.i.
regardless of any factorization, and `b^*` is the ordinary Chow-ring pull-back.
Nothing in §3 refers to `Theta`, `sigma`, `i`, or the exceptional locus; the proof
would be identical for a morphism `M \to J` with no factorization through a divisor
at all. This is worth stating because it removes the only place where the
resolution's geometry could have injected a correction.

**(c) Where excess *does* live: representatives, not classes.** If one insists on
computing `{}^t\Gamma_b \circ L \circ \Gamma_b` as a proper intersection of
representative cycles in `M \times J \times J`, the intersection of
`\Gamma_b \times J` with `p_{23}^{-1}(\mathrm{supp}\,L)` will in general be
excess-dimensional, and the excess formula (F5) is then genuinely needed to name the
resulting cycle. That excess is invisible at the level of rational-equivalence
classes: identity (2.1) computes the class without ever positioning two cycles
against each other, because one of the two factors is a fundamental class pushed
forward from a smooth subvariety. **This is the exact answer to "where does excess
enter": in cycle representatives only, never in the class identity.** There is no
correction term to compute, and no excess class supported on the exceptional locus
arises. Recorded as a negative with the searched domain being all of §3's proof:
every step is an equality of classes with no positioning hypothesis.

## 5. Specialization to the theta resolution

Now `b: M \to J` is the theta resolution of
`notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md`: `M` a smooth
projective fourfold, `J` a smooth projective abelian fivefold, `b_*[M] = [\Theta]`.

Define the **composed-form lattice** in codimension three,

\[
  \mathrm{Comp}^3 \;=\;
  \bigl\{\,{}^t\Gamma_b\circ L\circ\Gamma_b \;:\; L\in CH^3(J\times J)\,\bigr\}
  \;\subseteq\; CH^3(M\times M),
\]

and its cohomological analogue `Comp^3_{top}` with `L` ranging over
`H^6(J\times J,\mathbf Z)`.

> **Proposition 5.1 (composed form = pull-back).**
> `\mathrm{Comp}^3 = (b\times b)^*CH^3(J\times J)` and
> `\mathrm{Comp}^3_{top} = (b\times b)^*H^6(J\times J,\mathbf Z)`, and
> `cl(\mathrm{Comp}^3) \subseteq \mathrm{Comp}^3_{top}`.

*Proof.* Theorem 3.2 with `f = g = b`, `k = 3`; Corollary 3.3 for the topological
statement; (F8) for the compatibility. `\square`

> **Corollary 5.2 (every composed-form lift has even residue).** For every `L` in
> `CH^3(J\times J)` or in `H^6(J\times J,\mathbf Z)`, the class
> `{}^t\Gamma_b\circ L\circ\Gamma_b` has vanishing `(1,5)` mod-two Lefschetz
> residue.

*Proof.* Proposition 5.1 puts the class in the image of `(b\times b)^*`; Theorem B
of `notes/2026-08-11-c908-p15-fourier-saturation.md` §5 (input **R1**) kills the
residue of every such class. `\square`

> **Corollary 5.3 (the specialization asked for).** Suppose `Lambda_J^2` admits an
> integral lift, i.e. there is `L_0` in `CH^3(J\times J)` — or merely in
> `H^6(J\times J,\mathbf Z)` — with `L_0 \otimes \mathbf Q = \Lambda_J^2`. Then
> `{}^t\Gamma_b\circ L_0\circ\Gamma_b` is an integral lift of
> `\Pi_{15} = {}^t\Gamma_b\circ\Lambda_J^2\circ\Gamma_b` (composition being
> `\mathbf Q`-linear and defined over `\mathbf Z`), it equals
> `(b\times b)^*L_0`, and its `(1,5)` mod-two Lefschetz residue vanishes. Hence
> **no** composed-form integral lift of `\Pi_{15}` can realize the coefficient
> identity, and the answer does not depend on which lift `L_0` is chosen, nor on
> whether such an `L_0` exists at all.

**The mechanism, stated conceptually.** Corollary 5.2 is not an accident of the
`(1,5)` bookkeeping. For a composed-form class the two Künneth legs of the residue
functional are `b^*\alpha'` and `b^*\beta'`, and by the projection formula (2.1)

\[
  b_*b^*(x) \;=\; b_*[M]\cdot x \;=\; \Theta\cdot x ,
  \tag{5.1}
\]

so *both* Gysin images carry a factor `\Theta`, the degree functional (equation
(2.1) of the C904 note) becomes `\int_J \Theta^2\alpha'\beta'`, and Lemma A of the
C908 note (`\Theta^2 = 2\Theta^{[2]}` integrally on the exotic principal lattice)
makes it even. In one sentence: **a composed-form correspondence is divisible by
`\Theta` on each leg, and `\Theta^2` is even.** Note that (5.1) needs neither
`\sigma_*\sigma^* = id` nor the resolution's structure — only `b_*[M] = [\Theta]`
and the projection formula — which makes the mechanism robust against any
re-analysis of the exceptional geometry.

**Closure properties of the composed family (why it can never contain the
diagonal).** `\mathrm{Comp}^*` is closed under correspondence composition: since
`\Gamma_b\circ{}^t\Gamma_b` is the correspondence inducing `b_*b^* = \Theta\cdot(-)`
on `CH^*(J)`, namely `(\Theta\times 1)\cdot\Delta_J` in `CH^6(J\times J)`, one has

\[
 \bigl({}^t\Gamma_b\circ L_1\circ\Gamma_b\bigr)\circ
 \bigl({}^t\Gamma_b\circ L_2\circ\Gamma_b\bigr)
 = {}^t\Gamma_b\circ\Bigl(L_1\circ\bigl((\Theta\times1)\cdot\Delta_J\bigr)\circ L_2\Bigr)
   \circ\Gamma_b ,
\]

again composed form. It is also closed under transpose and, by (F3), is a subring
of `CH^*(M\times M)` for the intersection product. But it is **not unital**: every
element acquires the factor `\Theta` of (5.1), so `\Delta_M \notin \mathrm{Comp}^*`.
This is the structural reason the composed family cannot supply an inverse-Lefschetz
projector at two: one is trying to *divide* the diagonal by one power of `\Theta`,
and every composed-form class is instead *multiplied* by one.

## 6. The residue functional, and why Corollary 5.2 is not vacuous

**Convention (inherited, not re-derived).** Following
`notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md` §2 and
`notes/2026-08-11-c908-p15-fourier-saturation.md` §5, work inside the free integral
Künneth lattice of `H^6(M\times M,\mathbf Z)` and let `\Gamma^{1,5}` denote the
`(1,5)` Künneth component, written `\sum_s \alpha_s\otimes\beta_s` with `\alpha_s`
in `H^1(M,\mathbf Z)`, `\beta_s` in `H^5(M,\mathbf Z)`. Define the **`(1,5)`
mod-two Lefschetz residue**

\[
  r(\Gamma) \;=\; \sum_s\int_J b_*\alpha_s\cup b_*\beta_s \ \ \bmod 2
  \;\in\;\mathbf Z/2 ,
  \tag{6.1}
\]

the mod-two reduction of the `(1,5)` contribution (equation (2.1) of the C904 note)
to the unordered-theta degree. The results of §3–§5 are independent of this
convention; §6–§8 use it.

> **Proposition 6.1 (Gysin surjectivity in degree five).**
> `b_*: H^5(M,\mathbf Z)\to H^7(J,\mathbf Z) = \wedge^7\Lambda` is surjective.

*Proof.* `H^*(J,\mathbf Z)` is torsion-free, so Poincare duality on `J` makes
`y\mapsto(x\mapsto\int_J y\cup x)` an isomorphism
`H^7(J,\mathbf Z)\to\mathrm{Hom}(H^3(J,\mathbf Z),\mathbf Z)`. By the projection
formula, `b_*\beta` corresponds to the functional `x\mapsto\int_M\beta\cup b^*x`.
Input **R1** gives that `b^*: H^3(J,\mathbf Z)\to H^3(M,\mathbf Z)` is an
isomorphism, so it suffices that
`H^5(M,\mathbf Z)\to\mathrm{Hom}(H^3(M,\mathbf Z),\mathbf Z)` be surjective; that is
Poincare duality on the closed oriented eight-manifold `M`, whose pairing between
the free parts of `H^5` and `H^3` is unimodular. `\square`

*Dependency flag.* Proposition 6.1 is the one place where the strength of the cited
weak-Lefschetz statement matters. If `b^*` on `H^3` were only injective with
finite-index image, `b_*` would have only finite-index image and Corollary 6.2 below
would weaken accordingly. The C904 note states the isomorphism; it is used as
stated.

> **Corollary 6.2 (non-vacuity).** `r` is surjective onto `\mathbf Z/2` already on
> the `(1,5)` Künneth sublattice `H^1(M,\mathbf Z)\otimes H^5(M,\mathbf Z)`.

*Proof.* Pick `B` in `\wedge^7\Lambda` whose class in
`\mathrm{coker}(L)\otimes\mathbf F_2 = (\mathbf Z/2)^{10}` is nonzero (**R1**, eq.
(2.2)). By the perfect mod-two pairing (**R1**, eq. (2.3)) there is `\alpha'` in
`\Lambda` with `\int_J\Theta\alpha'B` odd. By Proposition 6.1 choose `\beta` in
`H^5(M,\mathbf Z)` with `b_*\beta = B`, and set `\alpha = b^*\alpha'`, so that
`b_*\alpha = \Theta\alpha'` by (5.1). Then
`r(\alpha\otimes\beta)=\int_J\Theta\alpha' B` is odd. `\square`

So Corollary 5.2 cuts a nontrivial functional down to zero on a proper subgroup: the
composed-form no-go is a real restriction, and there is **no integral-topological
obstruction** in the `(1,5)` channel. Everything remaining is a question of
algebraicity, exactly as the C904 note framed it.

Note also what the proof of Corollary 6.2 exhibits: an odd-residue class whose
degree-**one** leg *is* a pullback. That is not in conflict with Theorem B, which
requires the whole class — both legs — to come from `J\times J`.

## 7. The escape is confined to the degree-five leg

> **Proposition 7.1.** (i) `r` vanishes on
> `H^1(M,\mathbf Z)\otimes b^*H^5(J,\mathbf Z)`.
> (ii) For every `\alpha` in `H^1(M,\mathbf Z)` and `\beta` in
> `H^5(M,\mathbf Z)`, `r(\alpha\otimes\beta)` depends on `\beta` only through the
> class of `b_*\beta` in
> `\mathrm{coker}(L)\otimes\mathbf F_2 = (\mathbf Z/2)^{10}`.
> (iii) Consequently `r` factors as a perfect `\mathbf F_2`-pairing
> `(\Lambda/2\Lambda)\times\bigl(\mathrm{coker}(L)\otimes\mathbf F_2\bigr)\to\mathbf F_2`
> composed with `(\alpha,\beta)\mapsto(\alpha',[b_*\beta])`, where
> `\alpha = b^*\alpha'`.

*Proof.* Input **R1** gives `H^1(M,\mathbf Z) = b^*H^1(J,\mathbf Z)`, so write
`\alpha = b^*\alpha'` and `b_*\alpha = \Theta\alpha'` by (5.1). Then
`r(\alpha\otimes\beta) = \int_J\Theta\alpha'\,b_*\beta \bmod 2`, which is exactly the
pairing (2.3) of the C904 note; that pairing kills `L\wedge^5\Lambda` and `2\wedge^7\Lambda`
and is perfect on the quotients, giving (ii) and (iii). For (i), `\beta = b^*\beta'`
gives `b_*\beta = \Theta\beta'` in `L\wedge^5\Lambda`. `\square`

**Reading.** Because the degree-one leg of any `(1,5)` tensor is *automatically* a
pullback, the failure of pullback-ness demanded by Theorem B must be carried
entirely by the degree-five leg, and only through its Gysin image modulo
`\Theta\wedge^5\Lambda`. Two structural corollaries follow.

> **Corollary 7.2.** `b_*` induces a surjection
> `H^5(M,\mathbf Z)/b^*H^5(J,\mathbf Z)\twoheadrightarrow(\mathbf Z/2)^{10}`.

*Proof.* Proposition 6.1 (surjectivity onto `\wedge^7\Lambda`) together with
`b_*b^*H^5(J,\mathbf Z) = \Theta\wedge\wedge^5\Lambda = L(\wedge^5\Lambda)`, whose
quotient in `\wedge^7\Lambda` is `(\mathbf Z/2)^{10}` by **R1**. `\square`

So the escaping degree-five classes exist in quantity; the crown's difficulty is not
their existence but their algebraic realizability as a Künneth leg of a
codimension-three cycle class.

## 8. Two corrections/sharpenings to the C908 structural reframing

### 8.1 The residue is a push-forward invariant

> **Theorem 8.1.** For `\Gamma` in the free integral Künneth lattice of
> `H^6(M\times M,\mathbf Z)`,
> \[
>   r(\Gamma) \;=\; \varepsilon\Bigl(\bigl((b\times b)_*\Gamma\bigr)^{(3,7)}\Bigr),
>   \qquad
>   \varepsilon\bigl(\textstyle\sum_s x_s\otimes y_s\bigr)=\sum_s\int_J x_s\cup y_s \bmod 2,
> \]
> where `(b\times b)_*: H^6(M\times M,\mathbf Z)\to H^{10}(J\times J,\mathbf Z)` and
> `(-)^{(3,7)}` is the `(3,7)` Künneth component.

*Proof.* `(b\times b)_*` is the tensor product `b_*\otimes b_*` on Künneth
components of the free lattice, and it sends `H^1(M)\otimes H^5(M)` to
`H^3(J)\otimes H^7(J)` while sending every other `(p,6-p)` component to
`H^{p+2}(J)\otimes H^{8-p}(J)`, a different bidegree. So the `(3,7)` component of
`(b\times b)_*\Gamma` is `\sum_s b_*\alpha_s\otimes b_*\beta_s`, and `\varepsilon` of
it is (6.1). `\square`

This is the cleanest available form of the whole obstruction: **the `(1,5)` mod-two
residue of a correspondence on `M\times M` is computed downstairs, on `J\times J`,
from the push-forward alone.** Three immediate re-derivations:

- *Theorem B, conceptually.* For `\Gamma = (b\times b)^*L` the projection formula
  gives `(b\times b)_*\Gamma = \bigl([\Theta]\boxtimes[\Theta]\bigr)\cup L`, whose
  `(3,7)` component is `\sum(\Theta\alpha')\otimes(\Theta\beta')`; `\varepsilon` of
  that is `\int_J\Theta^2\alpha'\beta'`, even by Lemma A. The push-forward of a
  pull-back is divisible by `\Theta` in each factor — that single sentence is the
  whole of Theorem B.
- *A reposed downstairs gate.* Since `\Gamma` in `CH^3(M\times M) = CH_5(M\times M)`
  pushes to `CH_5(J\times J) = CH^5(J\times J)`, supported on `\Theta\times\Theta`,
  the crown is equivalent to: **find a five-dimensional algebraic cycle class on
  `J\times J`, in the image of `(b\times b)_*`, whose `(3,7)` Künneth component has
  odd `\varepsilon`.** This is a question about cycles on the abelian fivefold and
  is a candidate target for the integral Künneth-lattice machinery already built for
  C908, which operates on exactly these lattices.
- *Attainable residues are all of `\mathbf F_2`.* From the `(1,5)` channel the
  attainable `(3,7)` components lie in `(\Theta\wedge\Lambda)\otimes\wedge^7\Lambda`,
  on which `\varepsilon` is the perfect pairing of Proposition 7.1(iii) — consistent
  with Corollary 6.2.

### 8.2 Exceptional-locus support does **not** help in this channel

`notes/2026-08-11-c908-p15-fourier-saturation.md` §5 concludes that "the exceptional
divisor `E|_M = X` ... is the only geometry available to a non-pullback class". That
is right as a statement about what is *left over* after Theorem B, but it is
misleading as a construction hint: classes supported on the exceptional locus have
**zero** `(1,5)` residue.

> **Theorem 8.2.** Let `E \subset M` be the exceptional divisor of
> `\sigma: M = \mathrm{Bl}_0\Theta\to\Theta`, so `b(E) = \{0\}` and `\dim E = 3`
> (`E \cong X`, the cubic threefold; C908 §5). Let `\Gamma` in
> `H^6(M\times M,\mathbf Z)` be supported on `E\times M \cup M\times E`, i.e. a sum
> `(\iota_E\times id_M)_*\gamma_1 + (id_M\times\iota_E)_*\gamma_2` with `\gamma_i` in
> `H^4(E\times M,\mathbf Z)`, `H^4(M\times E,\mathbf Z)`. Then `r(\Gamma)=0`.
> In particular every algebraic cycle on `M\times M` all of whose components lie in
> `E\times M\cup M\times E` has even `(1,5)` residue.

*Proof.* Gysin maps respect Künneth on the free lattice.
(a) `(\iota_E\times id)_*` sends `H^p(E)\otimes H^q(M)` to
`H^{p+2}(M)\otimes H^q(M)`; a `(1,5)` output needs `p = -1`, so
`\bigl((\iota_E\times id)_*\gamma_1\bigr)^{1,5} = 0`.
(b) `(id\times\iota_E)_*` sends `H^p(M)\otimes H^q(E)` to
`H^p(M)\otimes H^{q+2}(M)`; a `(1,5)` output needs `p=1`, `q=3`, so the degree-five
legs lie in `\iota_{E*}H^3(E,\mathbf Z)`. But `b\circ\iota_E` is the constant map
`E\to\{0\}\subset J`, which factors as `E\to\mathrm{pt}\xrightarrow{\iota_0}J`;
push-forward along `E\to\mathrm{pt}` takes `H^3(E,\mathbf Z)` into
`H^{3-6}(\mathrm{pt}) = 0`. Hence `b_*\iota_{E*} = 0` on `H^3(E,\mathbf Z)` and every
term of (6.1) vanishes. `\square`

Equivalently in the language of Theorem 8.1: `(b\times b)_*` of an
exceptionally-supported class is supported on `\{0\}\times\Theta\cup\Theta\times\{0\}`
and has no `(3,7)` Künneth component at all.

**Consistency check, and what it forces.** Theorem 8.2 does not contradict
Corollary 7.2. Rather, combining them:

\[
   H^5(M,\mathbf Z) \;\supsetneq\;
   b^*H^5(J,\mathbf Z) + \iota_{E*}H^3(E,\mathbf Z),
   \tag{8.1}
\]

strictly, because `b_*` kills the second summand, sends the first onto
`\Theta\wedge^5\Lambda`, and is surjective onto `\wedge^7\Lambda` (Proposition 6.1).
The ten escaping directions of Proposition 7.1 are therefore carried neither by
pullbacks from `J` nor by the exceptional divisor: they come from the part of
`H^5` of the **singular** theta divisor `\Theta` that is not `b^*`-visible. That is
a sharper and different construction target than "twist by `E`", and it is the
main structural output of this note beyond the lemma itself. It also explains why
the two-primary triviality of the link of the theta singularity (its `H^4` being
`\mathbf Z^{10}\oplus\mathbf Z/3`, C908 §5) is not the relevant invariant here:
the residue never sees the link, because it factors through a push-forward that
annihilates everything supported over the singular point.

## 9. What is **not** covered

The lemma closes the composed-form family completely and nothing else. Explicitly
outside its reach:

1. **Integral lifts of `\Pi_{15}` that are not of composed form.** These are the
   generic case, for two independent reasons. (a) `\Lambda_J^2` is produced by
   Lieberman/Milne (**L1**) only rationally; it need not admit any integral lift on
   `J\times J`, in which case `\mathrm{Comp}^3` contains no lift of `\Pi_{15}` at
   all and Corollary 5.3 is a statement about an empty family — the useful content
   then being Corollary 5.2, which is unconditional. (b) Even when a rational class
   `\Gamma_{\mathbf Q}` lies in the image of `(b\times b)^*_{\mathbf Q}`, an integral
   `\Gamma` with `\Gamma_{\mathbf Q} = \Pi_{15}` need not lie in
   `(b\times b)^*CH^3(J\times J)` or in `(b\times b)^*H^6(J\times J,\mathbf Z)`:
   those images are **not saturated** in general, and `n\Gamma\in\mathrm{im}` does
   not imply `\Gamma\in\mathrm{im}`. Precisely this failure of saturation is the
   room the crown must live in.
2. **Composites plus a correction.** `{}^t\Gamma_b\circ L\circ\Gamma_b + \kappa` with
   `\kappa` not a pullback. Additivity of `r` gives
   `r(\text{composite}+\kappa) = r(\kappa)`, so the composed part is simply
   invisible; the lemma says nothing about `\kappa` — except when `\kappa` is itself
   exceptionally supported, where Theorem 8.2 applies.
3. **Correspondences factoring through other varieties.** If
   `\Gamma = {}^t\Gamma_g\circ L\circ\Gamma_g` for `g: M\to V` with `V` smooth
   projective, Theorem 3.2 gives `\Gamma = (g\times g)^*L`, but `r(\Gamma) = 0` is
   *not* automatic — it needs `b_*g^*` to be `\Theta`-divisible. It **is**
   automatic when `g` factors as `h\circ b`: then `(g\times g)^* = (b\times b)^*(h\times h)^*`
   and Corollary 5.2 applies. So: **any correspondence built from a morphism of `M`
   that factors through `b` is dead.** Morphisms of `M` not factoring through `b`
   are not covered.
4. **Chow-theoretic refinements invisible to `cl`.** Everything from §6 on is
   cohomological; homologically trivial cycles and higher Beauville grades are
   outside the residue's field of view (same boundary as C908 §6).
5. **The `(2,4)` channel** (44 dyadic directions). Theorem 3.2 and Proposition 5.1
   are channel-independent, so composed-form classes are pullbacks there too; but
   the analogue of Theorem B for `(2,4)` is not established here, and Theorems 8.1
   and 8.2 were written for `(1,5)` (the bidegree bookkeeping in Theorem 8.2(a)
   changes: for `(2,4)`, `p+2=2` needs `p=0`, which does **not** vanish, so
   exceptionally-supported classes are *not* obviously dead in the `(2,4)` channel).
6. **Existence.** Nothing here constructs any class. The output is entirely a
   narrowing.

## 10. Consequences for the crown

Combining Corollary 5.2, Theorem 8.2 and the additivity of `r`: write any
`\Gamma` in `H^6(M\times M,\mathbf Z)` as

\[
   \Gamma \;=\; (b\times b)^*L \;+\; \Gamma_{\mathrm{exc}} \;+\; \Gamma_{\mathrm{rest}},
\]

with `\Gamma_{\mathrm{exc}}` supported on `E\times M\cup M\times E`. Then
`r(\Gamma) = r(\Gamma_{\mathrm{rest}})`. Hence the reposed gate:

> **Gate (sharpened form of C908 §5).** Construct an integral algebraic
> codimension-three class on `M\times M` with a component that is neither a
> pull-back along `b\times b` from `J\times J` nor supported on
> `E\times M\cup M\times E`, whose `(1,5)` mod-two Lefschetz residue is odd; or
> prove `r = 0` on `CH^3(M\times M)`.
>
> Equivalent downstairs form (Theorem 8.1): find a five-dimensional algebraic cycle
> class on `J\times J` in the image of `(b\times b)_*` whose `(3,7)` Künneth
> component has odd `\varepsilon`.

What the lemma **forces**, stated without hedging:

1. The entire Lieberman/Milne apparatus on the abelian fivefold is unusable for the
   crown. Any class it produces lives on `J\times J`; pulling it back to `M\times M`
   — which is exactly what the composed form does, integrally, with no
   correction — lands in the kernel of `r`. Clearing denominators, choosing a
   different integral lift, or Fourier-transforming on `J\times J` (C908 §4.4)
   cannot change this.
2. The crown class cannot be produced by *any* two-sided graph sandwich through a
   variety that receives `J`, by §9 item 3.
3. The non-pullback-ness must sit in the degree-five Künneth leg (Proposition 7.1),
   in a part of `H^5(M,\mathbf Z)` visible neither to `b^*` nor to the exceptional
   divisor (equation (8.1)).
4. The obstruction is purely one of algebraicity: `r` is surjective on integral
   cohomology (Corollary 6.2), so no integral-topological argument can close the
   `(1,5)` channel, and no integral-topological accident can open it.

## 11. Ledger: proved here, cited, conjectured

| statement | status |
| ------------------------------------------------------------ | -------------------------------------------------- |
| Lemma 3.1, Theorem 3.2, Corollary 3.3 (graph sandwich)       | **proved here**, from (F1)–(F3), (F7)              |
| Proposition 5.1, Corollaries 5.2–5.3                         | **proved here**, given Theorem B (**R1**)          |
| Lemma 4.1 (Tor-independence of the square (4.1))             | **proved here**                                    |
| `b` is l.c.i.; no excess correction exists                   | **proved here**, from (F6) and §3                  |
| Proposition 6.1, Corollary 6.2, Proposition 7.1, Cor. 7.2    | **proved here**, given the weak-Lefschetz iso and eqs. (2.2)–(2.3) (**R1**) |
| Theorems 8.1, 8.2 and equation (8.1)                         | **proved here**, on the free integral Künneth lattice |
| Theorem B and Lemma A of C908; eqs. (2.2)–(2.3) and the weak-Lefschetz identifications of C904 | **cited**, repo-internal (**R1**) |
| Rational algebraicity of `\Lambda_J`                         | **cited** (**L1**), used only descriptively        |
| Fulton statement numbers                                     | **cited from memory**, statements standard, numbering unverified (see §2 caveat) |
| Existence of any odd-residue algebraic class                 | **open**, nothing here bears on it                 |
| `(2,4)`-channel analogues of Theorems B, 8.1, 8.2            | **open / not attempted**                           |

## 12. Mystery ledger

- **Settled (the assigned question).** `{}^t\Gamma_b\circ L\circ\Gamma_b` *is*
  `(b\times b)^*L`, integrally, in `CH^*` and in `H^*(-,\mathbf Z)`. There is no
  Tor-failure, no excess term, and nothing supported on the exceptional locus to
  compute. The identity holds for any proper morphism of smooth projective
  varieties and, in fact, for two different legs (`f\times g`).
- **Settled.** "Composed form through `J\times J`" and "in the image of
  `(b\times b)^*`" are the *same* condition (§3, sharpening), so Theorem B kills the
  composed family exactly, with no gap between the two descriptions.
- **Settled.** The proof is independent of the singularity of `\Theta`, of `\sigma`,
  and of the factorization `b = i\circ\sigma`. The stated justification of
  l.c.i.-ness via blow-up plus regular embedding is true but unnecessary; the robust
  reason is that any morphism of smooth varieties is l.c.i.
- **Settled, and a correction to a foreign note.** C908 §5's hint that the
  exceptional divisor is where a non-pullback class must come from is not usable in
  the `(1,5)` channel: exceptionally-supported classes have residue zero (Theorem
  8.2). The escape lives in the non-`b^*`-visible part of `H^5` of the singular
  theta divisor (equation (8.1)). Raised for the owner of that note; not edited
  here.
- **Settled.** The `(1,5)` residue is a function of `(b\times b)_*\Gamma` alone
  (Theorem 8.1), which converts the crown into a question about five-dimensional
  algebraic cycles on `J\times J` supported on `\Theta\times\Theta`. This is a
  strictly downstairs reformulation and did not previously exist in the corpus.
- **Settled.** The no-go is not vacuous and not topological: `r` is surjective on
  integral cohomology (Corollary 6.2).
- **Open, and now the sharpest single question.** Is the image of `(b\times b)_*`
  on `CH_5(M\times M)` large enough to contain a class with odd `\varepsilon` on its
  `(3,7)` component? Equivalently: is `r` identically zero on `CH^3(M\times M)`?
  The C908 Künneth-lattice machinery operates on exactly the lattices involved, so
  this is a plausible next computation rather than a purely structural question.
- **Open.** Identify `H^5(M,\mathbf Z)/\bigl(b^*H^5(J,\mathbf Z)+\iota_{E*}H^3(E,\mathbf Z)\bigr)`
  geometrically — equation (8.1) shows it is nonzero and surjects onto the ten
  escaping directions, but no generator is exhibited here.
- **Open.** Whether `\Lambda_J^2` admits any integral lift on `J\times J`. Made moot
  for the crown by Corollary 5.2, but it remains an unanswered question of
  independent interest about Lefschetz classes on an abelian fivefold.
- **Open.** The `(2,4)` channel: composed-form classes are pullbacks there too, but
  the parity mechanism (Theorem B) and the exceptional-support no-go (Theorem 8.2)
  have not been redone in that bidegree, and the bookkeeping in Theorem 8.2(a) does
  *not* transfer.
- **No manufactured mystery.** The one genuine surprise is how little the identity
  needs: no lci machinery, no fibre square, no Tor-independence, no properties of the
  theta resolution. The anticipated excess-class correction does not exist, and the
  reason is that a graph sandwich never positions two cycles against each other.
