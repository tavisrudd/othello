# C909 — the Eisenstein two-shadow theorem and its exact limit

Date: 2026-08-12

Status: proved coefficient-packet comparison and hostile no-go for a stronger
unmarked family comparison.  No manuscript, PDF, mirror, Lean, or commit
change.

## Verdict

There is a real common quadratic datum, but it is weaker than an identification
of the cycle and quantum constructions.  The correct shared object is the
Eisenstein order

\[
 \mathcal O=\mathbf Z[t]/(t^2+t+1)=\mathbf Z[\zeta_3].
\tag{1}
\]

Its inert fibre at two is `F_4`, while its two complex embeddings are the
primitive third roots.  The exotic two-primary graph slopes and the
*negative* formal monodromy of the cubic rank-two block are respectively
the mod-two and complex shadows of this same order.  Frobenius and complex
conjugation are both the nonidentity automorphism of `O`.

What is **not** proved, and does not follow from this observation, is a
canonical isomorphism between the exotic-kernel marking cover and a quantum
cover over the cubic parameter space.  The order supplies the same abstract
`C_2`-label symmetry; an equality of the two family torsors needs an extra
comparison datum.  In the presently known generic family the exotic selector
is a nontrivial sign cover, whereas the bare complex eigenvalue pair of a
globally defined monodromy operator is split.  They therefore cannot simply
be declared the same cover.

## 1. The universal Eisenstein packet

Let

\[
 \mathscr E=\operatorname{Spec}\mathcal O[1/3]
 \longrightarrow\operatorname{Spec}\mathbf Z[1/3].
\tag{2}
\]

It is finite etale quadratic, with deck group

\[
 \operatorname{Aut}(\mathcal O)=\{1,\iota\},\qquad
 \iota(t)=t^2=-1-t.
\tag{3}
\]

At the prime two,

\[
 \mathcal O/2\mathcal O
  =\mathbf F_2[t]/(t^2+t+1)=\mathbf F_4,
\tag{4}
\]

because the polynomial has no root in `F_2`.  Its two geometric points are
the roots `omega,omega^2`, and arithmetic Frobenius is

\[
 \operatorname{Frob}_2(t)=t^2=\iota(t).
\tag{5}
\]

At the complex fibre,

\[
 \mathcal O\otimes\mathbf C\simeq\mathbf C\times\mathbf C,
 \qquad t\longmapsto(\zeta_3,\zeta_3^2),
\tag{6}
\]

and complex conjugation interchanges the two factors by the same
involution `iota`.  Thus (4) and (6) are literally two fibres of one finite
etale quadratic packet.  The qualifier `etale` here excludes the ramified
prime three; no assertion is being made at three.

## 2. The exotic graph shadow

Let `H` be the six-point `A_5` heart in characteristic two.  The established
local calculation has

\[
 D=\operatorname{End}_{\mathbf F_2A_5}(H)=\mathbf F_4.
\tag{7}
\]

In the hyperbolic multiplicity presentation `H\oplus H`, the non-rational
stable maximal-isotropic graphs form

\[
 \mathcal K_{\rm ex}
 =\mathbf P^1(D)\setminus\mathbf P^1(\mathbf F_2)
 =\{\Gamma_\omega,\Gamma_{\omega^2}\}.
\tag{8}
\]

Every `a` in `D\setminus F_2` satisfies `a^2+a+1=0`; conversely those are
the two primitive elements of `D`.  Hence, after an `F_2`-algebra
identification

\[
 \jmath:\mathcal O/2\mathcal O\xrightarrow{\sim}D,
\tag{9}
\]

the two graphs in (8) are the geometric points of the special fibre (4).
The nontrivial automorphism of `D/F_2` sends

\[
 \Gamma_a\longmapsto\Gamma_{a^2},
\tag{10}
\]

exactly as in (5).  This is the finite-etale coefficient algebra behind the
exotic slope, so it is also the local input to finite-etale graph saturation.

There is a necessary canonicity qualification.  The **unordered** packet
`K_ex` and its free `C_2` action are intrinsic to the marked `A_5` module and
hyperbolic multiplicity problem.  An identification (9), or an individual
choice of `Gamma_omega`, is not intrinsic: the two choices of (9) differ by
`iota`.  Equivalently,

\[
 \operatorname{Isom}_{\mathbf F_2\text{-alg}}(\mathcal O/2,D)
\tag{11}
\]

is a free `C_2`-torsor.  A golden orientation or any equivalent marking can
select a point, but the bare exotic kernel does not.

Strictly speaking, `Spec F_4` has one topological point over `F_2`; the
two-element set in (8) is its set of geometric points.  This distinction is
essential when discussing descent.

## 3. The quantum shadow

For the distinguished rank-two formal block of a smooth cubic threefold, the
two formal residues are

\[
 -\frac16,\qquad-\frac56\pmod{\mathbf Z}.
\tag{12}
\]

Its formal monodromy `M` consequently has eigenvalues

\[
 \zeta_6^{-1},\qquad\zeta_6,
\tag{13}
\]

and therefore satisfies `M^2-M+1=0` on that block.  Put `N=-M`.  Then

\[
 N^2+N+1=0,
 \qquad
 \operatorname{Spec}(N)=\{\zeta_3,\zeta_3^2\}.
\tag{14}
\]

Thus

\[
 t\longmapsto N=-M
\tag{15}
\]

is an `O\otimes C`-action on the formal rank-two block, and its eigenspace
packet is exactly the complex fibre (6).  Complex conjugation swaps the
eigenvalues, hence acts by `iota`.

The minus sign in (15) is not cosmetic: it identifies the displayed
eigenvalues with the roots of the same polynomial used in (4).  Without it,
the eigenvalues satisfy `X^2-X+1`; this still generates the same Eisenstein
order because `zeta_6=1+zeta_3`, but it reverses the convenient primitive-root
labelling.

As on the graph side, an ordered identification requires a choice.  With the
residues printed as in (12), one possible marked convention is

\[
 -\tfrac16\longleftrightarrow\zeta_3,
 \qquad
 -\tfrac56\longleftrightarrow\zeta_3^2.
\tag{16}
\]

Complex conjugation reverses this convention.  The unmarked spectrum, not an
ordered pair of eigenlines, is what follows canonically from (12)--(14).

## 4. Precise two-shadow descent criterion

The meaningful categorical formulation is a statement about orientation
torsors, not an unsupported direct map between cohomology and quantum
connections.  Let `S` be a connected base on which both constructions are
defined.  Suppose that

* `K -> S` is the etale `C_2`-torsor of choices of an exotic graph marking;
  and
* `Q -> S` is an etale `C_2`-torsor of choices of an `O`-orientation of the
  rank-two quantum block (if such a descent datum has been constructed).

Then an `O`-compatible identification of the two marked packets exists if
and only if

\[
 [K]=[Q]\quad\text{in }H^1_{\rm et}(S,C_2).
\tag{17}
\]

When it exists, the set of identifications is a torsor under
`H^0(S,C_2)`.  This is simply the equivalence between etale `C_2`-torsors and
forms of the two-point `Aut(O)`-set, but it is non-tautological in use: it
isolates the exact global datum that must be checked rather than silently
identifying two conjugate pairs.

**Proof.**  The isomorphism torsor
`Isom_{C_2}(K,Q)` is nonempty exactly when the two torsors have the same
cohomology class.  If it is nonempty, composition with the deck involution
gives the simply transitive `H^0(S,C_2)` action.  The local identifications
(9) and (15) are precisely trivialisations after an etale cover, so the
criterion is compatible with the two fibres of `E`.

There is an immediate hostile consequence.  If the rank-two quantum block
and `N` are globally defined over a complex base, then its two distinct
eigenvalues produce global idempotents

\[
 \frac{N-\zeta_3^2}{\zeta_3-\zeta_3^2},\qquad
 \frac{N-\zeta_3}{\zeta_3^2-\zeta_3},
\tag{18}
\]

and the bare eigenvalue-label torsor is split.  It can agree with a nontrivial
exotic sign cover only after adding a different, genuinely nontrivial quantum
orientation/descent structure.  Constant residues alone do not provide one.

Thus the assertion that "Frobenius equals complex conjugation" is correct
only in the coefficient group `Aut(O)=C_2`; it is false if read as equality
of parameter-space monodromies.

## 5. What the shared order does and does not compress

The order gives a concise common proof fragment:

\[
 \Phi_3(t)=t^2+t+1
 \quad\rightsquigarrow\quad
 \begin{cases}
  \text{two exotic finite-etale slopes modulo }2,\\
  \text{two negative quantum monodromy roots over }\mathbf C,
 \end{cases}
\tag{19}
\]

with the same involution on both sides.  This compresses the root bookkeeping,
the orientation reversal rule, and the explanation of why the two exceptional
kernel choices are an etale rather than a nilpotent phenomenon.  It also
suggests the right global test: compare the two `C_2` torsor classes, not
individual eigenvalue labels.

It does **not** replace either independent proof engine:

* the cycle side still requires the polarized graph-lattice calculation,
  finite-etale saturation, and the actual minimal-class/Voisin hypothesis;
* the birational side still requires formal-isomonodromy, the exclusion of
  sixth-root monodromy from low-dimensional carriers, and weak-factorization
  atom persistence.

In particular, an `O` action modulo two and an `O` action on a complex formal
block do not produce a common integral `O`-lattice, a correspondence, a Chow
cycle, or a comparison functor.  The current strongest conclusion is a
**common quadratic etale label algebra with independent geometric shadows**.

## EJ + TT closeout / mystery ledger

**EJ settled:** the apparently ad hoc `F_4` pair and the sixth-root quantum
pair are both fibres of the Eisenstein packet `Spec O`; the negative-monodromy
normalization makes the polynomial identity literal.

**TT correction:** the common `C_2` involution is not a common family
monodromy.  The nontrivial-sign-cover phenomenon on the gluing side is not
explained by the local formal residues alone.

**Open gate:** construct a natural quantum `O`-orientation torsor over the
same smooth cubic base and compute its class in `H^1(S,C_2)`.  Only after
proving equality with the exotic selector class can one promote the
coincidence to a family-level Eisenstein bridge.  No such structure has been
constructed here.
