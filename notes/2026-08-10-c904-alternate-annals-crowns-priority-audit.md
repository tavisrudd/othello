# C904 alternate Annals crowns: priority and preemption audit

**Date:** 2026-08-10
**Lane:** C904
**Scope:** read-only mathematical/literature triage; no manuscript or Lean edits
**Status:** bounded primary-source and forward-citation audit, not an exhaustive
priority claim

## Executive verdict

The best replacement for the blocked relative-half crown is the conjunction of
two mechanisms already isolated in C904 and C907:

> **Proposed crown.** There is a non-isotrivial one-parameter family of smooth
> cubic threefolds \(X_t\) such that every \(X_t\) is universally
> \(\mathrm{CH}_0\)-trivial, while every \(X_t\times\mathbf P^1\) is irrational.

The first clause is the C904 six-axis saturation theorem for the \(A_5\)-cubic
pencil. The second is the C907 quantum-monodromy stabilization theorem.
Universal \(\mathrm{CH}_0\)-triviality is unchanged by a projective-space
factor, so \(X_t\times\mathbf P^1\) itself is universally
\(\mathrm{CH}_0\)-trivial and irrational. The conceptual punchline is:

> **Diagonal triviality does not detect one-step stable irrationality, even in
> a non-isotrivial family of smooth Fano threefolds.**

This is the cleanest theorem here with a plausible Annals ceiling. It solves a
long-standing stabilization problem for cubic threefolds and separates two
major stable-birational tests in an unusually controlled family.

It is also the candidate with the largest verification risk. The irrationality
half uses a very recent source stack. It should be called an Annals theorem only
after a hostile proof review of the product formula, the blow-up spectrum in
dimension four, and weak-factorization bookkeeping. The safe wording is
“\(X\times\mathbf P^1\) is irrational” or “irrationality survives one
stabilization,” not “\(X\) is stably irrational.”

## Ranking

| Rank | Candidate crown | Readiness | Ceiling if completed | Priority verdict |
|---|---|---:|---|---|
| 1 | Positive-dimensional universally \(\mathrm{CH}_0\)-trivial \(A_5\)-cubic family with \(X\times\mathbf P^1\) irrational | about 70% now; 85% after the atom bridge is printed and independently reviewed | Annals | No predecessor for the conjunction located; hostile source review is MINOR |
| 2 | Prime-by-prime classification of arbitrary elliptic-power gluings by primitive integral Lefschetz saturation | 45–55% | Annals | Jordan-scalar positive half is proved; the exotic \(\mathbf F_4\) obstruction is the unexplained negative boundary |
| 3 | Five-sheet Hecke packet with exotic saturation and canonical log-boundary extension | 85–90% | Inventiones/JAMS; Annals with the full geometric synthesis | Exact \(\mathbf P^1(\mathbf F_4)\) packet and all cusp kernels are proved; ordinary finite-flat extension is impossible |
| 4 | Jordan-scalar minimal-class theorem for all principal elliptic-power quotients | proved; priority audit bounded | Inventiones/JAMS, Annals-adjacent | IHC and minimal-class algebraicity are preempted; primitive integral divisor-product saturation appears new |
| 5 | Six \(D_5\) axes: exact Gram form, polarization/kernel, minimal-class saturation | 90–95% | Inventiones/JEMS alone | Most proof-ready paper-specific theorem |
| 6 | Exact two-primary Chow descent/minimal base change over complex curve fields | 20–30% | Annals as a general theorem | Essential relative Chow index remains open; ambient and tautological routes are dead |
| 7 | Uniform Steenrod–Wu parity on resolved theta divisors | proved | Structural theorem/short paper | Useful obstruction compiler, too narrow for the crown alone |

By readiness, the Hecke packet, Jordan-scalar theorem, and six-axis theorem are
the strongest self-contained C904 mathematics.  By surprise and venue ceiling,
the C904+C907 conjunction remains first.  The highest-EV new theorem is the
arbitrary-gluing classification: it would explain both the uniform scalar
success and the exceptional \(\mathbf F_4\) mechanism.

**Subsequent hostile audit.**  A source-level reread of all five C907 gates
returned `MINOR`, not `MAJOR`: Cai's sixth-root block, projective-bundle
multiplicity, the dimension-two carrier exclusion, weak-factorization center
bound, and KKPYY no-cancellation criterion all pass.  The missing item is a
short printed bridge attaching fractional formal monodromy to the enhanced
local atom.  `2026-08-10-c904-c907-enhanced-atom-bridge-blueprint.md` gives a
self-contained special-case proof after the two deep big-A-model blowup and
projective-bundle decompositions.  Updated Annals confidence is about 70% now
and 85% after that bridge receives an independent quantum/F-bundle review.

## 1. Universal \(\mathrm{CH}_0\)-triviality versus one stabilization

### Exact input

The C904 six-axis calculation gives, for every smooth member of the
\(A_5\)-invariant cubic pencil, algebraicity of the primitive minimal class
\(\Theta^4/4!\) on its intermediate Jacobian. In the current argument this
yields:

- the integral Hodge conjecture for one-cycles on the intermediate Jacobian;
- a Chow decomposition of the diagonal for the cubic threefold;
- universal \(\mathrm{CH}_0\)-triviality of every smooth member.

This is uniform in a non-isotrivial pencil, not a statement about one isolated
symmetric fibre.

The independent C907 mechanism assigns to a cubic threefold a fractional
quantum formal-monodromy block with exponents \(\pm1/6\). The current product
calculation shows that the block survives product with \(\mathbf P^1\). If
\(X\times\mathbf P^1\) were rational, weak factorization through smooth centers
of dimension at most two would express its spectrum using only points, curves,
and surfaces. Those centers contribute fractional exponents only \(0\) and
\(1/2\), contradicting the surviving \(1/6\)-block.

Conditional only on full verification of the C907 factorization theorem, the
two inputs prove the proposed crown.

### Primary-source boundary

The quantum input is extremely recent:

- Jiaji Cai, *The cubic threefold is symplectically irrational*,
  arXiv:2608.01577, <https://arxiv.org/abs/2608.01577>.
- Katzarkov–Kontsevich–Pantev–Yu–Yotov, *Birational Invariants from Hodge
  Structures and Quantum Multiplication*, arXiv:2508.05105,
  <https://arxiv.org/abs/2508.05105>.
- The product and blow-up formalism also uses Iritani’s integral/quantum
  connection machinery and the exact weak-factorization functoriality audited
  in C907.

Cai’s stated theorem is symplectic irrationality of the cubic threefold
itself. It does not claim irrationality of \(X\times\mathbf P^1\). The
stabilization step is not preempted by that theorem.

### Bounded priority and forward-citation check

Exact and variant searches for

- “cubic threefold \(X\times\mathbf P^1\) irrational,”
- “cubic threefold one stabilization irrational,”
- “universally \(\mathrm{CH}_0\)-trivial cubic threefold family,” and
- visible forward references to the two quantum-monodromy preprints

did not locate the conjunction above. A 2020 MathOverflow question asked
whether a smooth cubic threefold times a projective line is irrational and
recorded the problem as open:
<https://mathoverflow.net/questions/379287/is-the-product-of-a-cubic-threefold-and-the-projective-line-irrational>.
This is not a primary citation, but it is useful evidence for the historical
boundary. Forward references located around the 2025 paper concern
Burnside/Hodge and intermediate-Jacobian invariants, not this stabilization
theorem.

There are many universally \(\mathrm{CH}_0\)-trivial irrational varieties and
many decomposition-of-diagonal families. The safe novelty claim is not “the
first such family.” It is the simultaneous theorem for the non-isotrivial
\(A_5\)-cubic pencil together with the one-step stabilization result.

### Red-team gates

Before using this as the crown, require independent verification of:

1. preservation of the \(\pm1/6\) formal block under the precise quantum
   product with \(\mathbf P^1\), with no semisimplification or resonance loss;
2. the dimension bound on every weak-factorization center for a birational map
   from a smooth rational fourfold to \(X\times\mathbf P^1\);
3. the claimed spectrum restriction for every smooth center of dimension at
   most two, including irregular surfaces;
4. additivity and cancellation control through repeated blow-ups/down;
5. the uniform C904 implication from the minimal class to universal
   \(\mathrm{CH}_0\)-triviality for every smooth pencil member.

If all five survive, this is the strongest replacement crown in the program.

## 2. The cubic–Winger–quartic \(X_0(6)\) packet

### Exact input

After explicit finite base changes, the current constructions put the
\(A_5\)-cubic and \(S_6\)-quartic intermediate-Jacobian families over the same
six-axis elliptic source. The primitive \(A_5\)-equivariant isogeny \(\Phi\)
satisfies

\[
\Phi^\dagger\Phi=[4],\qquad
\deg\Phi=2^{10},\qquad
\ker\Phi\simeq(\mathbf Z/2)^2\oplus(\mathbf Z/4)^4,
\]

with homology Smith form

\[
(1,1,1,1,2,2,4,4,4,4).
\]

The six-axis sum is \(6\operatorname{id}=3\Phi\). At the Petersen
degeneration, the toric character lattice is exactly

\[
6I-J,
\]

the integral simplex form controlling the six \(D_5\) axes on the cubic side.

The mod-two gluing space has five projective points:

- three rational points form the classical \(S_6/X_0(6)\) component;
- two exotic points form the \(A_5\)-cubic quadratic resolvent;
- the common 3-primary heart is the Winger \(\Gamma_1(3)\) family.

This yields a natural three-shadow packet over one modular source:

\[
\text{Winger }\Gamma_1(3)
\longleftrightarrow
\text{\(A_5\)-cubic exotic resolvent}
\longleftrightarrow
\text{\(S_6\)-quartic \(X_0(6)\) resolvent}.
\]

### What is preempted

The ingredients have clear owners:

- Looijenga–Zi, *The Winger pencil of plane sextics*,
  arXiv:2109.01810, <https://arxiv.org/abs/2109.01810>, establish the
  integral Winger lattice, order-three geometry, and \(\Gamma_1(3)\) period map.
- Carocca–González-Aguilera–Rodríguez, arXiv:math/0503340,
  <https://arxiv.org/abs/math/0503340>, construct the relevant Weyl ppav
  family and identify its \(X_0(6)\) modular parameter.
- Cheltsov–Kuznetsov–Shramov own the \(S_6\)-quartic pencil and its
  conic-bundle, Prym, and rational \(E^5\) descriptions; publication metadata:
  <https://pure.mpg.de/pubman/item/item_3250634>.
- Roulleau owns the six \(D_5\) elliptic fibrations and the rational \(E^5\)
  isogeny on the \(A_5\)-cubic side.

These sources preempt discovery claims for the individual modular curves,
Winger lattice, quartic pencil, \(D_5\) fibrations, or rational \(E^5\)
decompositions.

### What was not located

Bounded exact-title and forward-reference searches did not find:

- the cubic and quartic families as Hecke neighbors of one six-axis source;
- the five-point \(\mathbf P^1(\mathbf F_4)\) gluing packet split into a
  rational triple and exotic pair;
- the primitive isogeny with the kernel and Smith data above;
- the Petersen character lattice identified with the cubic \(6I-J\) lattice;
- a theorem packaging Winger, cubic, and quartic periods as these three modular
  shadows.

Visible forward references to the Winger and Weyl-ppav papers stayed within
Wiman–Edge/Winger monodromy, group-algebra decomposition, or Hecke-algebra
construction. None gave the cross-family synthesis.

### Red-team gates

At present this is an exact theorem about abelian schemes/ppav isogenies on the
smooth locus. An Annals crown still needs:

1. an algebraic relative correspondence realizing \(\Phi\), not only the
   induced homomorphism of abelian schemes;
2. finite-flat control of its kernel at the relevant cusps;
3. a geometric admissible-cover or cycle interpretation of the exotic pair;
4. proof that the \(6I-J\) boundary match respects the actual polarization
   normalization, not merely the abstract lattice;
5. descent through all deck transformations.

With these closed, this is the conceptually richest geometric crown. Without
them, it is a strong Inventiones-level ppav theorem.

## 3. Six \(D_5\) axes: exact polarization, kernel, saturation

For the six \(D_5\)-fixed elliptic axes \(E_H\subset J(X)\), normalized quotient
maps \(q_H\) and embeddings \(i_H\) satisfy

\[
q_Hi_H=[5],\qquad q_Hi_{H'}=[-1]\quad(H\ne H').
\]

The Rosati Gram matrix is

\[
G_6=6I_6-J_6.
\]

On five independent axes, the induced polarization has type
\((1,6,6,6,6)\), and the sum isogeny has degree \(6^4\). Its 2-primary gluing
choices form \(\mathbf P^1(\mathbf F_4)\); the cubic selects the exotic pair,
while the 3-primary part is the unique \(\Gamma_0(3)\)-line.

The uniform integral simplex theorem says that \(n\) two-transitive elliptic
axes with off-diagonal scalar \(-s\) have reduced Smith invariants

\[
(s,sn,\ldots,sn)
\]

and determinant \(s^{n-1}n^{n-2}\). The factor \(n^{n-2}\) is the Cayley
spanning-tree determinant. The same integral control proves minimal-class
saturation on the principal quotient of \((E^5,6I-J)\).

Roulleau, arXiv:1002.4467, constructs the six \(D_5\) fibrations and proves the
rational \(E^5\) isogeny. Those facts and the classical group-algebra
decomposition must be credited. The exact \(6I-J\) matrix, polarization type,
degree \(6^4\), exotic gluing selection, and saturation were not located in
Roulleau or bounded forward searches.

This is the strongest proof-ready theorem in the packet. As a pure
polarization theorem it is likely JEMS/Inventiones material rather than an
Annals crown. Coupled to the uniform Chow-diagonal family or the cross-family
Hecke geometry, it becomes a central theorem.

## 4. Exact two-primary descent over curve fields

On the marked exotic base, mod-two monodromy is \(C_3\) with no invariants.
Every horizontal Néron–Severi class therefore has a unique symmetric
line-bundle rigidification, and the primitive minimal Chow class can be
constructed relatively on that marked base.

The remaining unmarked descent is not controlled. After the
rationally-connected lifting step, the unresolved invariant is an integer
index \(n\). An odd \(n\), combined with the available multiplication-by-two
construction, gives the primitive class by Bézout. An even \(n\) exposes the
genuine two-primary obstruction.

A sharp special theorem would say:

> the obstruction has exact period and index two, and the marked quadratic
> cover is the minimal base change on which the primitive relative cycle exists.

A genuinely general classification for natural abelian schemes over function
fields of complex curves would have Annals scope.

The literature strongly warns against generic descent arguments. Humberto A.
Diaz, *On the failure of Galois descent for Chow groups*, Journal of Algebra
667 (2025), proves that for the function field \(F\) of a complex curve there
are smooth projective surfaces for which

\[
\operatorname{coker}\bigl(
\mathrm{CH}^2(X)\longrightarrow
\mathrm{CH}^2(X_{\bar F})^{G_F}
\bigr)
\]

is not of cofinite type:
<https://www.sciencedirect.com/science/article/abs/pii/S0021869324006859>.
This rules out casual appeal to a general descent principle and makes an exact
special calculation more interesting.

Voisin’s fixed-fibre argument uses Graber–Harris–Starr over a complex curve; it
does not supply a \(K=\mathbf C(B)\)-point of the generic lifting fibre or a
canonical descent datum. Symmetric-line-bundle torsor results control divisors,
not higher Chow cycles. Results on zero-cycles in rationally connected
families, such as Lüders, arXiv:2211.04300, do not give this codimension-four
descent.

An exact general theorem could be Annals-level; the special cubic theorem could
be Inventiones-level. The theorem is not currently proved, because the RC
lifting index and finite/Chow torsor are the open gates.

## 5. Uniform Steenrod–Wu parity on theta resolutions

Let \((A,\Theta)\) be a principally polarized abelian \(g\)-fold whose theta
divisor has an isolated point of multiplicity \(m\). Blow up the point and let
\(Y\) be the smooth strict transform. If

\[
h=\pi^*\Theta|_Y,\qquad e=E|_Y,
\]

then

\[
K_Y=h+(g-1-m)e,\qquad h|_e=0,\qquad h^2\in2H^4(Y,\mathbf Z).
\]

Cartan plus Wu gives, for every class \(z\) of the appropriate degree,

\[
\int_Y h\,\mathrm{Sq}^2z=0\pmod2.
\]

For the cubic-threefold theta resolution

\[
M=\operatorname{Bl}_0\Theta,
\]

this implies that every formal codimension-three universal-sheaf expression
invariant under twisting the universal family by a line bundle has even theta
degree. The invariant divisor lattice is saturated, so no hidden half-divisor
evades the parity wall.

The geometric identification of \(M\) with the stable-sheaf moduli space is
from Bayer–Beentjes–Feyzbakhsh–Hein–Martinelli–Rezaee–Schmidt,
*The desingularization of the theta divisor of a cubic threefold as a moduli
space*, arXiv:2011.12240 / Geometry & Topology (2024),
<https://arxiv.org/abs/2011.12240>.

Searches combining “theta divisor,” “resolution” or “blow-up,” “Wu formula,”
and “Steenrod square parity” did not locate this theorem. Visible forward
references to the 2024 paper concern categorical Torelli and
Lagrangian/moduli geometry, not this parity wall.

The statement is likely new in this formulation, but its present scope is a
no-go for formal twist-invariant universal polynomials. It does not exclude
evaluated or non-tautological cycles. It is a sharp structural obstruction,
not the main Annals theorem.

## Recommended theorem architecture

1. **Integral engine:** six-axis \(6I-J\) polarization, exact kernel, and
   minimal-class saturation.
2. **Geometric consequence:** uniform Chow-diagonal theorem for the
   non-isotrivial \(A_5\)-cubic pencil.
3. **External surprise:** after independent verification, quantum
   stabilization proves every member remains irrational after
   \(\mathbf P^1\).
4. **Conceptual contrast:** Steenrod–Wu parity explains why the obvious
   universal-sheaf route cannot produce the primitive class.
5. **Future elevation:** reserve the cubic–Winger–quartic packet for the next
   crown unless its correspondence and cusp gates close now.

This gives one memorable theorem rather than five competing themes:

> A rigid elliptic-axis lattice forces Chow-diagonal triviality throughout a
> symmetric cubic pencil, while a fractional quantum-monodromy block proves
> that the same cubics remain irrational after one stabilization.

## What not to claim

- Do not say “stably irrational” when only \(X\times\mathbf P^1\) is proved
  irrational.
- Do not say this is the first family of universally
  \(\mathrm{CH}_0\)-trivial irrational varieties.
- Do not credit C904 with the Winger modular curve, Weyl ppav \(X_0(6)\), the
  \(S_6\) quartic pencil, the \(D_5\) fibrations, or rational \(E^5\)
  decompositions.
- Do not call the cubic–quartic map a relative algebraic correspondence until
  the cycle and cusp-extension gates are proved.
- Do not claim the marked-base theta class descends through the exotic
  involution until the finite/Chow torsor is computed.
- Do not let the Steenrod–Wu wall stand for all algebraic cycles; it controls
  the formal twist-invariant tautological algebra audited so far.

## Search boundary

This was a bounded audit of primary papers already in the C904/C907 source
stack, exact-title searches, phrase searches for the five candidate theorems,
and visible forward references returned by those searches. It was not a
complete MathSciNet/Zentralblatt census. Negative findings mean “not found in
this bounded audit,” not a categorical proof of priority.
