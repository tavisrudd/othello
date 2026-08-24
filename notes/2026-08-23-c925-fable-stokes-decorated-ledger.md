# The Stokes-decorated ledger: definition over chain rings and one-step Iritani transport

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

Executes the red-team note's §4(i) target
(`2026-08-23-c925-fable-birational-invariance-redteam.md`): make the
Stokes-decorated ledger — the block ledger with the gluing invariant
\(ss'\) recorded on split pairs — rigorous over the chain coefficient
fields, and prove its transport through one Iritani blow-up step.  Outcome:
the decoration is defined **valuatively**, not analytically, so the open
fixed-\(\varepsilon\) cluster-factor problem (HR) of
`2026-08-23-c925-fable-rank-two-confluence-gamma-ii.md` §3 is sidestepped
entirely; the one-step transport theorem is proved modulo a single named
integrality hypothesis (INT-\(\Psi\)) on Iritani's comparison, which
Iritani's own asymptotics prove on the initial slice \(Q=\tilde\tau=0\).
An exact model certificate replays every mechanism, including a negative
control that realizes the red-team's hiding mechanism exactly.

## 1. The definitional obstruction, and the valuative escape

Stokes data do not exist for connections over an abstract coefficient field:
over \(K((z))\) the Levelt–Turrittin decomposition is purely formal, all
gluing between distinct exponential sheets dies, and analytic
(multisummation) Stokes matrices need convergent coefficients.  The chain
fields — \(\mathbf C((q^{-1/s}))[[Q,\tilde\tau]]\)-type rings at each edge —
are formal, and the (HR) obstruction shows that even in the analytic
category the fixed-\(\varepsilon\) rank-two cluster factor inside higher
rank is open.  So "record \(ss'\) on split pairs" cannot mean an analytic
Stokes multiplier over the chain field.

The escape: the chain fields are not abstract — they are **valued**, and the
split pairs the telescope must protect are exactly the pairs whose
separation has positive valuation (they merge at the edge's large-radius
specialization).  For such a pair, the confluence rule (R2.4)
(\(a^2/(g_+g_-)=4\sin^2\pi e\), proved in the confluence note) says the
mutual Stokes product of the split pair is determined by the Levelt
exponent class \(\{e,-e\}\) of the merged block:
\(ss' = 2\cos 2\pi e - 2\).  The merged block lives at the specialization,
and its class is **algebraic** (the lane's elementary-modification recipe).
So the decoration can be defined as specialization data and *deserves* the
name Stokes decoration by (R2.4): at convergent parameters it equals the
analytic limit of the pair's mutual Stokes product.  What is genuinely
transcendental — the Stokes data of pairs that stay separated at the
specialization — is exactly what the telescope never needs.

## 2. Definition

**Edge objects.**  An edge of the telescope carries: a chain field \(K\)
with a complete valuation subring \(O\) (the large-radius ring, e.g.
\(\mathbf C[[q^{-1/s}]][[Q,\tilde\tau]]\) inside its Laurent-fraction
field), maximal-ideal-type specialization \(O\to\kappa\)
(\(q^{-1/s},\ \tilde\tau\to0\); \(\kappa\) carries the next vertex's
Novikov structure), and a **model**: a finite free \(O[[z]]\)-lattice
\(\mathcal L\) in a \(K[[z]]\)-module \(M\) with
\(\nabla_{z\partial_z}=z\partial_z-z^{-1}U+B(z)\) preserving
\(\mathcal L\)-spectral structure as below.  Quantum D-modules with their
cohomology lattices and Novikov rings are edge objects canonically; for
Iritani's centre summands the scalar shift \(-(r-1)\lambda_j\) is a scalar
exponential twist, and everything below uses only \(\operatorname{ad}U\)
and eigenvalue differences, hence is invariant under scalar twists.

**Clusters.**  Over \(\bar K\) the spectrum of \(U\) (the \(z^{-1}\)-leading
operator) partitions by the Newton polygon of its characteristic polynomial
and by residual separation: a **cluster** is a minimal subset of spectral
values whose mutual differences have positive valuation (or vanish) while
every difference to the complement has valuation \(\le 0\) with nonzero
residue (unit separation) or negative valuation (large separation, the
centre-versus-base case).  A **merging pair** is a two-element cluster of
rank-one sheets: split over \(K\), colliding at \(\kappa\).

**Flat cluster projector.**  For each cluster, the \(z=0\) spectral
projector \(\pi\) (Bezout/partial fractions in \(U\) against the
complementary characteristic factor; \(O\)-integral because the
cross-cluster resultant is a unit or large) extends to a unique
\(z\)-formal \(\nabla_{z\partial_z}\)-flat projector
\(\Pi=\pi+\sum_{k\ge1}\Pi_kz^k\); the recursion
\([U,\Pi_{k+1}]=k\Pi_k-\sum_i[\,B_i,\Pi_{k-i}\,]\) divides only by
cross-cluster differences, never by the internal separation of the merging
pair, so every \(\Pi_k\) is \(O\)-integral.  The **cluster lattice** is
\(V:=\Pi(\mathcal L)\), a flat free \(O[[z]]\)-summand-with-connection.

**Decoration.**  The Stokes-decorated ledger of an edge object is its
generic-fibre ledger (blocks, Jordan types, exponent classes over
\(\bar K\), with the usual Kummer/Galois bookkeeping) together with, for
every merging pair, the **Levelt exponent class of the merged block of the
special fibre \(V\otimes\kappa\)** — equivalently the value
\(ss'=2\cos2\pi e-2\).  A pair split from a marked block carries
\(e=1/6\), \(ss'=-1\); a plain tangency of sheets carries \(e=0\),
\(ss'=0\) (the Cotti–Dubrovin–Guzzetti stratum); the strict unmarked merge
carries \(e=1/2\), \(ss'=-4\).  Clusters of size \(>2\) carry the whole
special-fibre cluster germ as their decoration; nothing below changes.

Three remarks.  (i) The decoration is an invariant of the **integral
model**, not of the \(K\)-object: the certificate's leg 4 exhibits two
integral families with identical generic spectral data and different merged
classes.  This is the red-team's hiding mechanism stated exactly, and it is
why comparisons must be integral.  (ii) No analytic content is assumed:
(HR) remains open and unneeded.  The bridge to genuine Stokes data is
(R2.4) plus the \(o(1)\) sliver bound, both proved.  (iii) The Levelt
reformulation (`…-marker-is-levelt-exponent.md`) removed lattice
dependence for the class **at a point**; the decoration reinstates
integrality only in the **family** direction, which is a far smaller demand
than the superseded calibration/Rees-port machinery — one comparison
integrality instead of a transported native order.

## 3. One-step transport through Iritani's decomposition

Setting: \(\tilde X=\mathrm{Bl}_ZX\), centre codimension \(r\), Iritani
(arXiv:2307.13555v3) Theorem 5.18:
\(\Psi:\mathrm{QDM}(\tilde X)^{la}\to\tau^*\mathrm{QDM}(X)^{la}\oplus
\bigoplus_{j=0}^{r-2}\varsigma_j^*\mathrm{QDM}(Z)^{la}\) over
\(\mathbf C[z]((q^{-1/s}))[[Q,\tilde\tau]]\), commuting with the full
quantum connection (property 1), intertwining the polarizations with the
direct-sum polarization (property 2), with the initial-condition
asymptotics of property (4)/display (5.28).  The relevant valuation is
\(q^{-1/s}\)-adic; the base summand is integral
(\(\tau(\tilde\tau)\in H^*(X)((q^{-1}))[[Q,\tilde\tau]]\) with
\(\tau|_{Q=\tilde\tau=0}=q^{-1}[Z]+O(q^{-2})\)), and its special fibre is
\(X\)'s own quantum connection at the shifted small point — the next
vertex's edge object.

**Hypothesis (INT-\(\Psi\)).**  In the bases
\(\{\varphi^*\phi_{X,i}\}\cup\{\jmath_*(p^l\pi^*\phi_{Z,m})\}\) and
\(\{\phi_{X,i}\}\), the base row-block of \(\Psi\) is
\(q^{-1/s}\)-integral at every order of \(z\), \(Q\), \(\tilde\tau\), with
specialization \((I,0)\).

**Proposition (initial slice).**  (INT-\(\Psi\)) holds at
\(Q=\tilde\tau=0\).  *Proof.*  Property (4) (equivalently the block matrix
(5.28) and its Neumann tail): the base block is
\(\mathrm{id}+O(q^{-1})\) and the exceptional-to-base block is
\(O(q^{-1})\), where \(O(q^{-1})\) denotes \(q\)-valuation inside the
module \(H^*(X)[z]((q^{-1/s}))\) — uniform in \(z\).  \(\square\)

**Theorem (one-step transport).**  Assume (INT-\(\Psi\)) at the edge.  Then
\(\Psi\) induces a bijection between the merging pairs of
\(\mathrm{QDM}(\tilde X)\)'s decorated ledger lying over the base cluster
and the merging pairs of the summand \(\tau^*\mathrm{QDM}(X)\), and the
decorations agree.  In particular a marked block of \(X\)'s specialized
ledger that splits along the chain-induced bulk curve is detected on
\(\tilde X\)'s side as a merging pair decorated \(ss'=-1\): **markedness
cannot hide by splitting across one Iritani step, in either direction.**

*Proof.*  Five steps.

1. *\(z=0\) evaluation.*  \(z\mapsto0\) is a ring map, so
   \(\Psi_0:=\Psi|_{z=0}\) is invertible; the \(z^{-1}\)-coefficient of
   property (1) gives \(\Psi_0U_{\tilde X}=U'\Psi_0\) with \(U'\) the
   direct-sum leading operator, and property (2) at \(z=0\) makes
   \(\Psi_0\) an isometry.  Hence the characteristic polynomial of
   \(U_{\tilde X}\) factors as
   \(\chi_{U_X\circ\tau}\cdot\prod_j\chi_{U_Z\circ\varsigma_j}\), Newton
   clusters correspond, and spectral projectors transport:
   \(\Psi_0\,\pi\,\Psi_0^{-1}=\pi'\) for the matching interpolation
   polynomial.

2. *Flat projectors transport.*  \(\Psi\Pi\Psi^{-1}\) is a flat projector
   extending \(\pi'\); for the whole base cluster the unique such extension
   is the constant summand projector (the summand is
   \(\nabla\)-stable), so \(\Psi\) maps the base-cluster flat subspace onto
   \(\tau^*\mathrm{QDM}(X)\otimes K[[z]]\); likewise the flat extension of
   any sub-cluster projector matches on the two sides.

3. *Integral cluster lattice on the blow-up side.*  \(\pi\) and every
   \(\Pi_k\) are \(O\)-integral (§2: cross-cluster divisions are unit or
   large; \(U_{\tilde X}\)'s own \(\lambda\)-large centre entries only make
   those inverses smaller).  Set
   \(V':=\Pi\bigl(\varphi^*L_X[[z]]\bigr)\), the flat image of the
   pullback sublattice — intrinsic to \(\tilde X\).

4. *Integral comparison.*  Let
   \(\Theta:=\mathrm{proj}_{S}\circ\Psi|_{V'}\) with
   \(S=\tau^*\mathrm{QDM}(X)\).  By step 2,
   \(\Theta(\Pi x)=\mathrm{proj}_S\Psi(x)\), so on the generators
   \(\Pi(\varphi^*\phi_{X,i})\) the matrix of \(\Theta\) is the base
   row-block of \(\Psi\): \(O\)-integral with specialization
   \((I,0)\) by (INT-\(\Psi\)).  An integral map of finite free modules
   over the complete local ring \(O[[z]]\) whose reduction is invertible is
   an isomorphism (Nakayama for surjectivity, equal rank plus
   torsion-freeness for injectivity).  Hence
   \(\Theta:(V',\nabla)\xrightarrow{\ \sim\ }(S,\nabla_S)\otimes O[[z]]\)
   is a flat \(O[[z]]\)-isomorphism.

5. *Specialize.*  \(\Theta\otimes\kappa\) is a flat isomorphism of
   \(\kappa[[z]]\)-connection germs, so the special fibres have identical
   formal invariants; the decoration of every merging pair — the Levelt
   class of its merged block, a formal-germ invariant (lemma H-B) — is
   preserved, and step 1's spectral bijection matches the pairs.
   \(\square\)

**Corollary (initial slice, unconditional).**  On the exceptional
D-module slice \(Q=\tilde\tau=0\) (Iritani Remark 5.19 — the slice where
the lane's exact audits live), the decorated ledger transports through one
blow-up step with no hypothesis.

**Centre summands.**  The same proof runs for pairs in a centre cluster
after two normalizations, both harmless: the scalar exponential shift
\(-(r-1)\lambda_j\) (the construction is scalar-twist invariant) and the
column normalization \(q_{Z,j}(-1)^l\lambda_j^{l+1}\) of property (4),
which rescales the pushforward sublattice by \(q\)-power diagonals before
step 3.  For the AKMW application this case carries only point and curve
centres, whose blocks are unmarked of class \(\{1/2,1/2\}\); the marked
content always rides the base summand, so the theorem above is the
load-bearing case.

## 4. What (INT-\(\Psi\)) is, and how to get it

The hypothesis fails for nothing in the initial slice; the open content is
the \([[Q,\tilde\tau]]\)-directions.  Pure degree bookkeeping does not
settle it (homogeneity ties a \(Q^d\)-correction of \(q\)-valuation \(-w\)
to \(2k+2c_1{\cdot}d+\deg\text{-spread}=2(r-1)w\)-type relations, which
pin signs only for large \(c_1\cdot d\)).  Two identified routes:

1. **Reconstruction integrality.**  Iritani §5.8: \(\Psi\), \(\tau\),
   \(\varsigma_j\) are uniquely reconstructed from the initial conditions
   and genus-zero invariants by flatness order by order in
   \((Q,\tilde\tau)\).  If each reconstruction step divides only by
   cross-cluster data and graded-nonresonant integers, integrality
   propagates from the initial slice.  This is the natural theorem to
   prove next; it is a statement about one explicit recursion.
2. **\(q\partial_q\)-flatness bootstrap.**  Property (1) in the
   \(q\partial_q\)-direction gives a first-order system for the
   \(q\)-expansion of \(\Psi\) whose homogeneous part multiplies the
   \(q\)-valuation-\(v\) coefficient by \(v\); a joint induction with the
   integrality of \(\tau,\varsigma_j\) could close it.  The
   \(\lambda\)-large centre entries make this delicate; route 1 looks
   cleaner.

The negative control (leg 4) shows no proof can avoid some such
hypothesis: the decoration genuinely lives on the integral model.

## 5. Exact model certificate

`notes/cubic-threefolds-tasks/c925-fable-decorated-ledger-transport-check.py`
(SHA-256
`cc559a5c7d8062f54305022fc61824c115a4e274cb255dc468f45aa19cc26a85`),
output `c925-fable-decorated-ledger-transport-check-output.txt`
(SHA-256
`2c911be7fd05b1ac9f71fc99455cd6cc0f6f75505c8c4abb00f4b04d60842d04`).
Replay:

    uv run --with sympy python3 \
      notes/cubic-threefolds-tasks/c925-fable-decorated-ledger-transport-check.py

Exact sympy over \(\mathbf Q(\varepsilon)\), \(\varepsilon\) the
large-radius variable.  Leg 1: the C924 marked-block family
\(z^2Y'=(U_\varepsilon+zD+z^2L)Y\), \(U_\varepsilon=
\bigl(\begin{smallmatrix}0&2\\\varepsilon&0\end{smallmatrix}\bigr)\), is
\(\varepsilon\)-integral and a general Moser-shearing extractor returns
special-fibre class \(\{1/6,5/6\}\), cross-checking the confluence
certificate's \(\operatorname{diag}(1,z)\) leg.  Leg 2: embedded as a
2-cluster beside a deliberately non-integral separated sheet
\(u_3=3+1/\varepsilon\) (the \(\lambda\)-shift shape) and mixed by an
integral model comparison \(G=G_0(1+\varepsilon zC_1+\varepsilon z^2C_2)\),
\(G_0=1+O(\varepsilon)\), the flat cluster projector has intrinsic
\(z=0\) seed, is idempotent, flat, \(\varepsilon\)-integral at all five
kept orders, and unique.  Leg 3: the compressed cluster connection on the
mixed side is \(\varepsilon\)-integral and its special-fibre class is
again \(\{1/6,5/6\}\) — the transport conclusion computed intrinsically on
the far side.  Leg 4: the negative control of §2(i), classes
\(\{1/6,5/6\}\) versus \(\{0,0\}\) over the same \(U_\varepsilon\).  No
second implementation; leg 1 is the cross-check against the confluence
certificate and `c924-finite-cubic-check.py`.

## 6. Effect on the programme map

1. The red-team's target "make the \(ss'\)-decorated ledger rigorous over
   the chain fields" is done; "transport along chain fields" is reduced,
   for one edge, to (INT-\(\Psi\)) — proved on the initial slice, open in
   the \([[Q,\tilde\tau]]\)-directions with two concrete routes (§4).
2. The (HR) sliver obstruction is bypassed for ledger purposes: no
   analytic cluster factor is consumed anywhere.
3. The \(b_3=0\) tail closure now has a precise technical spine: prove
   (INT-\(\Psi\)) in general (§4 route 1), compose edges (the
   specialization of one edge is the next edge's generic structure — the
   chain version is bookkeeping over §3 once each edge holds), and feed
   the decorated telescope into the H-C second half.  A marked block can
   then hide nowhere along an AKMW chain: split pairs carry \(ss'=-1\)
   visibly at every vertex, including \(b_3=0\) carriers.

## Mystery ledger (EJ+TT closeout, 2026-08-23)

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | The decoration is definable over chain fields valuatively (merged-block class at the edge specialization), with (R2.4) as the bridge to analytic Stokes data; (HR) is not consumed. | §1–2; certificate legs 1–3. |
| settled | One-step Iritani transport, both directions, given (INT-\(\Psi\)); unconditional on the initial slice via property (4)/(5.28). | §3; the five-step proof; leg 3 replays the mechanism exactly. |
| settled | The decoration is a model invariant, not a generic-fibre invariant: same split-pair data, different merged classes. | Leg 4; this is the red-team hiding mechanism made exact, and why (INT-\(\Psi\)) cannot be dropped. |
| open, sharpened | (INT-\(\Psi\)) in the \([[Q,\tilde\tau]]\)-directions: \(q\)-integrality of \(\Psi\)'s base row-block beyond the initial slice. | §4, two routes; route 1 (reconstruction integrality, Iritani §5.8) is the recommended successor. |
| open | Chain composition and the decorated telescope endpoint (compose §3 across an AKMW chain; endpoint comparison at \(\mathbf P^3/\mathbf P^5\)). | §6.3; mechanical once (INT-\(\Psi\)) holds per edge, but the composition bookkeeping is unwritten. |
| observed, unexplained | In leg 3 the compressed connection's integrality needed no use of the polarization at all — pairing enters only the \(ss'\) dictionary, not the transport. If polarization is reinstated, step 4's Nakayama argument may extend to prove the transported lattice is self-dual, which would transport the first Rees jet too, not just the class. | Cheap candidate strengthening; not needed for the tail. |

## Next

`go C925 cubic-threefolds` — prove (INT-\(\Psi\)) beyond the initial slice
via the reconstruction recursion (Iritani §5.8, route 1 of §4); on success
the chain composition of §6.3 is bookkeeping and the decorated telescope
stands.
