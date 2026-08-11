# C904 exotic-deck residuals: hostile audit of the proposed final move

Date: 2026-08-11

Status: theorem-logic and priority audit; independent exact integral replay
confirmed the normalization verdict, with its atomic certificate correction
being packaged separately; no manuscript or Lean edits

## Executive verdict

**The exotic \(C_2\) calculation is not a final index gate.**  It is a useful
consistency check on the two mixed Kunneth residuals, but neither possible
outcome proves the desired quadratic-splitting theorem.

There is also a decisive prediction before any matrix computation.  The
\((1,5)\) residual contains the coefficient identity.  The exotic deck
normalizes the residual \(C_3\), hence acts on

\[
  \operatorname {End}_{C_3}(V^5)\simeq M_5(\mathbf F_4)
\]

by semilinear conjugation, possibly composed with transpose.  In every such
normalization the identity matrix is fixed, and its unordered degree is

\[
                 \delta_{15}^{\mathrm{sym}}(I_5)
                 =\operatorname {tr}_{\mathrm{coeff}}(I_5)
                 =5=1\pmod2.
\]

This is the five-dimensional **coefficient** trace, not the ordinary
\(\mathbf F_2\)-linear trace on the ten-dimensional Hodge lattice; the
latter is even and is divided by two on passage to the symmetric quotient.

Thus the full \(S_3=C_3\rtimes C_2\) **divided Hodge residual** must still
contain the fixed identity with odd \(p15\) degree.  If an exact replay
reports no such class, it has either retained only the ordered contraction
or identified the two sheets, source/target duality, or quotient pairing
incorrectly.
The independent exact replay confirms this prediction:

| Channel | full-\(S_3\) fixed dimension | raw contraction | actual quotient degree |
|---|---:|---|---|
| \(p15\) | 25 | identically even | odd; fixed identity has degree \(5\equiv1\) |
| \(p24\) | 396 | odd | odd; the direct contraction is already the quotient degree |

Thus neither mixed channel has a deck-theoretic parity obstruction.  This
still says nothing by itself about integral algebraization or Chow descent.

More fundamentally:

- a **fixed odd residual** is only an invariant integral Hodge/cohomology
  possibility; it does not produce an algebraic Chow multisection;
- **even degree on all fixed \(p15/p24\) residuals** would remove only the
  mixed channels; the \((0,6)\) odd theta-supported-curve channel remains;
- the primitive odd Hodge curve class in that axis channel is itself
  deck-fixed, so no finite monodromy computation can prove its
  nonalgebraicity;
- minimal quadratic splitting requires both an odd cycle after the quadratic
  extension and nonexistence of every odd cycle before it.  Residual
  representation theory supplies neither statement.

The immediate Annals crown should therefore be the now-closed
C904+C907 one-step-stabilization theorem.  The full \(p\)-typical gluing
classification has the greater pure-mathematics ceiling if completed, but it
still has a major global antisymmetrizer/carry gate and two further
classification gates.  The deck calculation is a lemma or route-killer, not
a crown.

This note makes no new literature-absence claim.  It uses the primary-source
boundaries already audited for the symmetric-product lattice, integral
Lefschetz filtration, invariant cycles, rational inverse Lefschetz, and the
quantum-atom stabilization theorem.

## 1. What the finite calculation can actually test

Let \(R_{15}\) and \(R_{24}\) denote the mod-two transfer residuals

\[
\begin{split}
 R_{15}&=\Lambda_2\otimes Q_{15},\\
 R_{24}&=U_{24}\otimes Q_{24},
\end{split}.
\]

The \(p24\) residual has its direct perfect quotient-degree contraction

\[
        \delta_{24}:R_{24}\to\mathbf F_2.
\]

For \(p15\) one must distinguish two operations.  The raw top-wedge pairing
is the **ordered** trace modulo two,

\[
       \bar\delta_{15}(T)=\operatorname {Tr}_{10}(A)\pmod2,
\]

and loses the desired information.  On the Hodge centralizer the actual
unordered symmetric-square degree is the divided trace

\[
       \delta_{15}^{\mathrm{sym}}(T)
       =\frac12\operatorname {Tr}_{10}(A)
       =\operatorname {tr}_{\mathrm{coeff}}(A)\pmod2.     \tag{1.1}
\]

Reducing the ordered trace modulo two before dividing makes it identically
blind to the coefficient identity.  This is exactly the ordered-versus-
unordered error already corrected in the full Kunneth audit.

The marked cover has residual \(C_3\), while the exotic deck involution
\(\sigma\) conjugates its generator to its inverse.  The unmarked
cohomological candidates therefore lie in the full \(S_3\)-fixed spaces.
The exact finite questions are

\[
 \delta_{15}^{\mathrm{sym}}(R_{15,\mathrm{Hdg}}^{S_3})
   \stackrel{?}=0,\qquad
 \delta_{24}(R_{24}^{S_3})\stackrel{?}=0.                 \tag{1.2}
\]

This is a necessary-condition calculation.  An algebraic cycle over the
unmarked generic field spreads after shrinking and its integral cohomology
class is monodromy invariant.  Therefore a fixed-space vanishing in (1.2)
would rule out an odd contribution from that channel.

The converse fails twice:

1. invariant integral cohomology need not be algebraic;
2. an invariant algebraic class after base change need not descend in
   integral Chow.

There is an additional integral-lift warning in \(p15\): a fixed residual
coset need not have a fixed integral lift through the Lefschetz extension.
That affine/Bockstein problem is again invisible if one retains only the
semisimplified mod-two quotient.

The second failure is exactly two-primary.  Averaging across \(C_2\) gives
\(1+\sigma\) and doubles degree.  The relevant descent class lives in a
Tate or connecting quotient of the **Chow/presentation kernel**, not in the
fixed subspace of \(R_{15}\) or \(R_{24}\).

## 2. Why \(p15\) must retain an odd divided Hodge residual

Over \(\mathbf F_2\), let \(V\) be the irreducible two-dimensional
\(C_3\)-module.  The exact preceding replay gives

\[
        \Lambda_2\simeq Q_{15}\simeq V^5.
\]

The perfect degree pairing identifies

\[
       R_{15}^{C_3}\simeq\operatorname {End}_{C_3}(V^5)
       \simeq M_5(\mathbf F_4).                           \tag{2.1}
\]

An involution normalizing \(C_3\) induces the nontrivial automorphism of
\(\mathbf F_4/\mathbf F_2\).  After choices of coefficient bases, its action
on (2.1) has one of the natural forms

\[
 A\longmapsto P\bar A P^{-1},
 \qquad\text{or}\qquad
 A\longmapsto P\bar A^{\,t}P^{-1}.                       \tag{2.2}
\]

The second possibility accounts for exchanging a tensor with its
pairing-dual.  In either case \(I_5\) is fixed.  Its **divided symmetric
degree**, not its raw ordered contraction, is the coefficient trace, so

\[
              \delta_{15}^{\mathrm{sym}}(I_5)=5=1\in\mathbf F_2.
                                                               \tag{2.3}
\]

This argument is basis-free: the identity is the natural transformation on
the five-dimensional multiplicity object.  Geometrically it is the same
polarization-canonical Hodge tensor realized rationally by

\[
     {}^t\Gamma_b\circ\Lambda_J^2\circ\Gamma_b
       \in CH^3(M\times M)_{\mathbf Q}.
\]

Every ingredient is preserved by a polarized deck isomorphism.  The
remaining question is whether this rational class has an integral or
\(\mathbf Z_{(2)}\)-algebraic representative.  A deck matrix cannot answer
that question.

### Replay acceptance criteria

The exact two-sheet computation should verify:

1. each sheet has its own principal integral basis and Lefschetz quotient;
2. the deck map is an integral symplectic isomorphism between those bases,
   not an endomorphism guessed after reducing modulo two;
3. it conjugates the \(C_3\) generator to its inverse on every exterior
   power and quotient;
4. it preserves the residual pairing with source and target transported
   contragrediently;
5. it records separately the raw ordered pairing and the integral divided
   coefficient trace in \(p15\);
6. the full-deck \(p15\) Hodge residual contains the natural identity class
   with divided degree one.

A failure of item 6 rejects the degree normalization; it does not establish
index two.  Passing item 6 still does not prove that the residual has a
deck-fixed integral algebraic lift.

## 3. Why even mixed invariants would still not prove index two

For

\[
     s:\operatorname {Sym}^2M\longrightarrow J
\]

the full half-anti-graph theorem has four degree-six Kunneth channels:

\[
         (0,6),\quad(1,5),\quad(2,4),\quad(3,3).
\]

The \((3,3)\) channel is unconditionally even.  The proposed deck replay
addresses only the middle two.  The \((0,6)\) channel is an actual algebraic
curve on \(M\), and an odd contribution is exactly an odd theta-supported
curve.  No current theorem rules this out.

Indeed its primitive cohomology class
\[
                   c=\Theta^4/4!
\]
is deck-fixed and has odd theta degree five.  What is open is its support
and algebraicity on the theta resolution, not its monodromy.  Consequently
even a hypothetical proof of both vanishings in (1.2) would leave the
original primitive-theta Chow gate untouched.

The sharp conditional statement is:

> If (i) every full-deck fixed algebraic class in \(R_{15}\) and \(R_{24}\)
> has even contraction, (ii) no deck-invariant odd theta-supported algebraic
> curve exists, and (iii) the known degree-two multisection is retained,
> then the unmarked generic index is two.

The finite replay can address only the cohomological shadow of (i), and
(2.3) shows that the correctly divided Hodge shadow does not vanish in
\(p15\).

## 4. What would prove a minimal quadratic split

Let \(K'/K\) be the exotic quadratic extension and \(Y/K\) the generic
unordered-theta fibre.  The phrase “the exotic cover is the minimal
splitting cover” requires all of the following:

1. **Upper bound downstairs:** an explicit degree-two zero-cycle, so
   \(\operatorname {ind}(Y)\mid2\).  This is already available.
2. **Nontriviality downstairs:** prove \(Y\) has no odd-degree zero-cycle,
   hence \(\operatorname {ind}(Y)=2\).
3. **Splitting upstairs:** construct an odd-degree zero-cycle on
   \(Y_{K'}\), hence \(\operatorname {ind}(Y_{K'})=1\).
4. **Identification of the obstruction:** preferably exhibit the nonzero
   class in a Chow-theoretic Tate quotient or in the kernel of the
   presentation/cycle-class map, and show that \(K'\) kills it.

Once item 2 is known, restriction--corestriction implies that no odd-degree
extension can split the index.  But that proves only parity-minimality.
Item 3 is still needed to identify this particular quadratic cover as a
splitting cover.

A non-invariant odd class on the marked sheet would not by itself close item
3 unless it is algebraic and gives an actual generic multisection.  A fixed
odd residual downstairs would not close it either.  Conversely a nonzero
Tate class in residual cohomology is not the required Chow obstruction.

## 5. Source and priority boundary

The source-owned mechanisms are:

- the integral cohomology pullback lattice of a symmetric square;
- the integral symplectic Lefschetz filtration and its failure to split
  equivariantly;
- algebraic-cycle \(\Rightarrow\) integral monodromy invariance;
- rational algebraicity of inverse Lefschetz on an abelian variety;
- restriction/corestriction and the factor two in quadratic averaging.

None of those should receive novelty language in C904.  The exact
\(A_5\)-deck action on the two residual pairings is a C904-specific finite
calculation, but at present it is only a consistency lemma.  The genuinely
new unresolved statement would be one of:

1. integral algebraization of the natural odd \(p15\) identity;
2. a proof that every such integral lift is Chow-obstructed downstairs;
3. exact period/index two for the unmarked unordered-theta generic fibre,
   together with splitting on the exotic cover.

No comprehensive priority negative is asserted here.  The preceding bounded
audits found no exact source for these three C904-specific Chow statements,
but did not complete MathSciNet, zbMATH, or three-graph forward-citation
closure.

### Inherited primary-source read depths

- Dmitry Gugnin, *On Integral Cohomology Ring of Symmetric Products*,
  arXiv:1502.01862.  **Read depth: claim-specific partial**, Theorem 1,
  PDF pp. 4--7.  Cached PDF SHA-256
  74c1d9704d7ddd24f76f314162a44c05727db9770648f6d285679e23b67b4107.
- Analisa Faulkner Valiente and Mike Miller Eismeier, *A Lefschetz
  decomposition over Z, and applications*, arXiv:2507.00844v1.
  **Read depth: claim-specific partial**, Introduction, Theorems 1.1--1.2,
  Corollary 2.10, and Lemmas 2.12--2.13.  Cached PDF SHA-256
  3a3ef5208198526fdfcdeaabc00abbae77650b2015bce5806cce92e3d8a0ac91.
- Donu Arapura, Francois Greer, and Yilong Zhang, *Failure of the invariant
  cycle theorem over Z*, arXiv:2602.07302v2.  **Read depth: claim-specific
  partial**, Introduction, §8, and Appendix C.  Cached PDF SHA-256
  3ca6b0233b6ad3e41b568a0a31347014a77ba3f2693c565e69c063f891bf5f06.
- J. S. Milne, *Lefschetz classes on abelian varieties*.
  **Read depth: claim-specific partial**, §5, especially Proposition 5.7,
  Theorem 5.9, and Remark 5.11.  Cached PDF SHA-256
  28ae245e58748438b7070680cac83f8b2f695c43f1643b59cde21eb94077fe53.
- Humberto Diaz, *On the failure of Galois descent for Chow groups*.
  **Read depth: abstract/metadata and publisher preview only**, inherited
  from the relative-Shen audit.  It is used only as a warning that
  invariant Chow classes need not descend, not as a theorem about the
  present family.

## 6. Highest-EV alternate Annals upgrades

### 6.1 C904+C907: first choice for the immediate crown

The one-step-stabilization bridge has now passed an independent hostile
review with **MINOR**, and the corrections are in the theorem blueprint.
The exact statement is:

> There is a non-isotrivial one-parameter family of smooth cubic threefolds
> \(X_t\) such that every \(X_t\) is universally
> \(\mathrm {CH}_0\)-trivial, while every \(X_t\times\mathbf P^1\) is
> irrational.

The quantum half uses an additive sixth-root formal-monodromy multiplicity,
the projective-bundle formula, an exact low-dimensional carrier exclusion,
and weak-factorization no-cancellation.  It proves one-step persistence,
not full stable irrationality.

**Readiness:** high; the paper-local formal-isomonodromy lemma and
small/big-connection scalar-extension sentence are now printed in the
blueprint.

**Ceiling:** Annals-plausible.  It resolves a named one-stabilization problem
for cubic threefolds and sharply separates universal
\(\mathrm {CH}_0\)-triviality from rationality after one stabilization in a
non-isotrivial Fano family.

**Risk:** the decisive quantum sources are very recent preprints, so the
special-case bridge should be proved in full rather than hidden behind
terminology.

Source depth for this ranking:

- Jiaji Cai, *The cubic threefold is symplectically irrational*,
  arXiv:2608.01577v1.  **Read depth: claim-specific partial**, Proposition 6
  and the adjacent formal calculation.  Cached PDF SHA-256
  06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e.
- Katzarkov--Kontsevich--Pantev--Yu--Yotov, *Birational Invariants from
  Hodge Structures and Quantum Multiplication*, arXiv:2508.05105v2.
  **Read depth: claim-specific partial**, Theorems 4.5 and 4.11,
  Definitions 5.10 and 5.20--5.21, Proposition 5.17, Proposition 5.22,
  Claim 6.15, and Example 6.21.  Cached PDF SHA-256
  2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64.

### 6.2 Full \(p\)-typical gluing classification: highest pure-math ceiling

The target remains:

> classify the complete \(p\)-primary divisor-product saturation quotient
> of every principally polarized elliptic-power gluing by the orthogonal
> primary type of its self-dual finite gluing module, intrinsically across
> all Lagrangian charts, and realize every permitted \(p\)-power on
> polarized-indecomposable ppav's.

This is deeper and more structural than the cross-paper crown, and a full
classification with unbounded exact indecomposable realizations is
Annals-shaped.  It is not the theorem nearest completion.

Three major gates remain:

1. prove the global complete-antisymmetrizer/open-chain obstruction; local
   signed square-switch descent is false;
2. pass from regular cyclic primary blocks to arbitrary block partitions
   and bilinear types, including mixed-block interactions;
3. remove the graph chart and prove intrinsic symplectic/Lagrangian
   invariance.

The exact order-four indecomposable example, Jordan-scalar theorem, and
stabilized order-\(2,3,4\) towers are substantial.  They support an
Inventiones/JAMS package now.  They do not yet amount to the full
\(p\)-typical classification.

### 6.3 Ranking

| Candidate | Current readiness | Ceiling | Hostile verdict |
|---|---:|---|---|
| C904+C907 one-step-stabilization family | high | Annals-plausible | **GO after MINOR bridge repair**, now incorporated |
| full intrinsic \(p\)-typical gluing classification | medium-low | Annals if complete | highest pure-math upside, three major gates |
| six-axis exact polarization/kernel/saturation | very high | Inventiones/JEMS | strongest self-contained Paper V theorem |
| exotic-deck \(p15/p24\) finite move | high as a calculation | lemma only | cannot decide index or minimal splitting |

## 7. EJ + TT closeout and mystery ledger

The cheap closeout upgrade is conceptual rather than computational: the
coefficient identity turns the proposed vanishing test into a positive
target.  The next useful finite datum is not another invariant-space
dimension, but the integral extension class measuring whether that fixed
odd Hodge residual has a deck-fixed algebraic lift.  This identifies the
precise point at which representation theory ends and Chow theory begins.

Mystery ledger:

1. **Settled -- ordered versus unordered degree.**  The ordinary
   ten-dimensional trace is even; the symmetric-quotient degree is its
   integral half and equals the odd five-dimensional coefficient trace on
   the identity.
2. **Settled -- ceiling of deck invariant counting.**  Fixed-space
   vanishing is only a necessary cohomological obstruction, while a fixed
   odd class is only a possible Hodge channel.  Neither implication reaches
   Chow descent or index by itself.
3. **Open -- integral algebraization of the fixed \(p15\) identity.**  The
   exact evidence gap is a deck-equivariant integral or
   \(\mathbf Z_{(2)}\)-algebraic inverse-Lefschetz projector on the theta
   resolution.  This belongs to a successor on integral CK/Lefschetz
   projectors, not to the finite replay.
4. **Open -- the primitive theta-supported curve.**  The axis class is
   monodromy fixed and has odd degree, but its algebraic support on the theta
   divisor remains the original Chow gate.
5. **Open -- exact quadratic splitting.**  The missing evidence is an odd
   multisection over the exotic quadratic field plus a nonzero downstairs
   Chow obstruction.  Restriction--corestriction alone supplies neither.
6. **Open -- full \(p\)-typical classification.**  The unexplained degrees
   of freedom are the global antisymmetrizer carry, arbitrary primary
   bilinear blocks, and chart independence.  These are the theorem gates of
   the separate high-ceiling program.

No additional mystery is manufactured from the size of the \(p24\) fixed
space: without algebraization, that dimension has no index-theoretic
meaning.

## 8. Recommendation

1. Finish and retain the exact exotic-deck replay as a negative theorem and
   normalization check; do not frame it as the final index proof.
2. Land the C904+C907 one-step-stabilization theorem as the immediate crown,
   with the special-case atom bridge printed.
3. Continue the \(p\)-typical classification as a separate high-ceiling
   theorem program.  Its next target is the global complete-antisymmetrizer
   obstruction, not another local switch or finite deck census.
4. Return to the quadratic index only with genuinely Chow-theoretic input:
   an odd multisection upstairs, a nonzero descent obstruction downstairs,
   or a support theorem for the primitive theta curve.

Vibe: the finite deck move is mathematically clean but cannot convert a
two-local algebraicity problem into representation theory.  The exact
\(p15\) identity predicts its own failure as a vanishing argument.
