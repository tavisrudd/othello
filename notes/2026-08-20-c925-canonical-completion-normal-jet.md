# Module 42. Canonical completion needs the normal-jet augmentation

**Packet part:** Module 42.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** the raw GKZ face-restriction obstruction, the quantum-Serre
rank/point annihilation, and the equivariant first-normal-jet repair on the
rank shadow are proved; an occurrence-level equivariant QDM adapter and its
residual saturation remain open

## 42.1 The completion is a local canonical model

Let a torus \(T\) act on a vector space \(W\) with weights
\(\beta_1,\ldots,\beta_n\), and put

\[
                         \kappa=\sum_i\beta_i.                  \tag{42.1}
\]

For the usual quotient-line convention, the canonical bundle of a smooth
GIT quotient \(X=W/\!/T\) has character \(-\kappa\).  Thus Module 41's
completed representation

\[
                       W^{\mathrm{can}}=W\oplus\mathbf C_{-\kappa}
                                                                    \tag{42.2}
\]

is the standard local-canonical or \(p\)-field representation.  In a chamber
where

\[
 (W\oplus\mathbf C_{-\kappa})^{\mathrm{ss}}
       =W^{\mathrm{ss}}\oplus\mathbf C,                          \tag{42.2a}
\]

its quotient is the total space of \(K_X\).  Equality (42.2a) is a geometric
phase certificate, not a consequence of the character sum: adding a weight
can change semistability.  With the opposite associated-line convention all
characters are dualized.

This places the proposed bridge inside quantum Serre duality.  It does not,
however, make descent to the ordinary QDM automatic.

## 42.2 Ordinary GKZ face restriction does not remove the new coordinate

Write the completed charge matrix as

\[
 Q=(q_1\ \cdots\ q_n\ q_p),\qquad q_p=-\kappa\ne0,              \tag{42.3}
\]

and let \(a_1,\ldots,a_n,a_p\) be a Gale-dual configuration, so that the row
lattice of \(Q\) is the kernel of

\[
             \mathbf Z^{n+1}\longrightarrow N_A,
             \qquad e_i\longmapsto a_i.                         \tag{42.4}
\]

### Proposition 42.1 -- the old coordinates are not a Gale face

The subset \(\{a_1,\ldots,a_n\}\) is not a face separated from \(a_p\).

#### Proof

If it were such a face, a real functional \(h\) on \(N_A\) would satisfy

\[
                      h(a_i)=0\ (i\le n),\qquad h(a_p)>0.        \tag{42.5}
\]

Its pullback to \(\mathbf R^{n+1}\) would be \(c e_p^*\) for some \(c>0\).
For this pullback to descend through (42.4), it must annihilate every row of
\(Q\).  Its values on those rows are the components of \(c q_p\), which are
not all zero.  This is impossible.  \(\square\)

Therefore the face-restriction theorem in Steiner, *Dualizing, projecting,
and restricting GKZ systems*, Theorem 5.8, does not apply to deletion of the
canonical coordinate.  That theorem is valuable when the retained columns
form a face of a normal pointed semigroup configuration; (42.3) fails the
face hypothesis before normality is considered.  This is a scope
obstruction, not a theorem that every non-face restriction vanishes.

## 42.3 Quantum Serre identifies the raw rank defect

Let \(X\) be smooth projective, let \(E=K_X^{-1}\), and let

\[
                       j:X\hookrightarrow E^\vee=K_X            \tag{42.6}
\]

be the zero section.  Its normal bundle is \(E^\vee\), so the algebraic
self-intersection formula gives

\[
 j^*j_*[V]=\lambda_{-1}(E)[V]
          =(1-[E])[V]\qquad\text{in }K(X).                      \tag{42.7}
\]

When \(E\) is convex, Iritani--Mann--Mignon, Theorem 3.14, constructs the
non-equivariant quantum-Serre morphism

\[
 e(E)\cup:\QDM_{(e,E)}(X)\longrightarrow\QDM(E^\vee)            \tag{42.8}
\]

after the stated parameter pullback.  Under the additional regular-section
hypotheses of their Proposition 4.5, its top square identifies (42.7), under
their \(\widehat\Gamma\)-integral framings, with (42.8) up to the explicit
invertible scalar

\[
                 c(z)=(-2\pi\sqrt{-1}z)^{-\operatorname{rk}E}.  \tag{42.8a}
\]

### Proposition 42.2 -- the forward Serre map kills the consumed row

For every \(V\in K(X)\),

\[
                    \operatorname{rk}(j^*j_*V)=0.               \tag{42.9}
\]

For every closed point \(y\in X\),

\[
                         j^*j_*[\mathcal O_y]=0.                 \tag{42.10}
\]

Consequently the natural non-equivariant quantum-Serre bridge is not a
rank-row-preserving isomorphism for the canonical completion.

#### Proof

The rank of \(1-[E]\) is zero, proving (42.9).  Tensoring a line bundle with
a skyscraper sheaf at a point does not change its K-class, so

\[
 (1-[E])[\mathcal O_y]=[\mathcal O_y]-[\mathcal O_y]=0.
\]

Within the additional hypotheses above, compatibility with the Gamma
framing is the top square of Proposition 4.5; the nonzero scalar (42.8a)
does not change the vanishing.  \(\square\)

The same defect is visible in cohomology: multiplication by the positive
degree class \(e(E)\) kills the top point class.  Quantum Serre supplies a
canonical **forward** bridge from Euler-twisted \(X\) to local \(E^\vee\),
but it is the wrong unaugmented map for Module 34's marked quotient line.  It
is not an invertible descent from the completion; any reverse adapter is
additional structure.

## 42.4 The first equivariant normal jet restores the sparse row

Let \(q\) be the **primitive** character by which \(\mathbf G_m\) scales the
fibres of \(E^\vee\).  The equivariant conormal has class \(q^{-1}E\), so the
self-intersection operator is

\[
                 \Theta_q(V)=(1-q^{-1}[E])V.                    \tag{42.11}
\]

On the rank quotient and on the point class it satisfies

\[
\begin{aligned}
 \operatorname{rk}(\Theta_q(V))&=(1-q^{-1})\operatorname{rk}(V),\\
 \Theta_q([\mathcal O_y])&=(1-q^{-1})[\mathcal O_y].             \tag{42.12}
\end{aligned}
\]

### Theorem 42.3 -- normalized normal-jet law

Let \(R\) be the unramified local ring at \(q=1\), with uniformizer
\(s=1-q^{-1}\).
After passing to either the rank coimage or the point line, \(\Theta_q\) has
valuation exactly one and

\[
                     s^{-1}\Theta_q\big|_{\mathrm{row}}=1.      \tag{42.13}
\]

Equivalently, the first conormal coefficient of the equivariant
self-intersection map is the identity on the consumed sparse shadow.

#### Proof

Both assertions are the identities (42.12).  The factor \(s\) is a
uniformizer at \(q=1\); dividing by it on either one-dimensional shadow gives
the identity.  \(\square\)

This division is **not** asserted on the full K-group or QDM.  There
\(1-q^{-1}[E]\) need not be divisible by \(1-q^{-1}\).  The normalization is
lawful precisely after the rank-row/point-line optic has forgotten the
unconsumed directions.

### Theorem 42.4 -- rank-one jet transport

Let \(R\) be a DVR with uniformizer \(s\), let \(L_-\) and \(L_+\) be free
rank-one \(R\)-modules, and let

\[
                         F:L_-\longrightarrow L_+               \tag{42.13a}
\]

have valuation one.  Then there is a unique \(R\)-map \(F_{\mathrm{norm}}\)
such that

\[
                         F=sF_{\mathrm{norm}},                  \tag{42.13b}
\]

and its special fibre

\[
 \overline F_{\mathrm{jet}}:
 L_-/sL_-\xrightarrow{\ \sim\ }L_+/sL_+                        \tag{42.13c}
\]

is an isomorphism.  Equivalently, \(F\) induces an isomorphism

\[
 L_-/sL_-\xrightarrow{\ \sim\ }sL_+/s^2L_+,
\]

which becomes (42.13c) after using the named conormal generator \(s\).

#### Proof

In bases of \(L_\pm\), the map \(F\) is multiplication by \(su\) for a unit
\(u\in R^\times\).  Thus \(F_{\mathrm{norm}}\) is multiplication by \(u\),
and its reduction is multiplication by \(\bar u\ne0\).  Uniqueness follows
because \(L_+\) is torsion-free.  \(\square\)

The raw special fibre of \(F\) is still zero.  For example,
\(s:R\to R\) has nonzero first jet and residual valuation zero, but its cone
has \(R/(s)\)-torsion.  Therefore Theorem 42.4 does not satisfy Theorem 40.4
for the **ordinary** closed-fibre consumer.  It supplies a new jet-line
consumer, and a geometric provider must identify (42.13c) with the transition
used in the birational telescope.

## 42.5 Typed interpretation

The canonical-completion route therefore needs one additional Reader/State
field:

\[
 \boxed{\text{fibre-scaling character }q
        \quad+\quad
        \text{first conormal jet at }q=1.}                       \tag{42.14}
\]

For a typed occurrence map

\[
 F:(P_-,r_-)\longrightarrow(P_+,r_+),\qquad
 F(P_-)\subseteq P_+,\quad
 F(P_-\cap\ker r_-)\subseteq P_+\cap\ker r_+,                  \tag{42.15a}
\]

let \(\bar F:L_-\to L_+\) be its induced map on the marked rank coimages
\(L_\pm=P_\pm/(P_\pm\cap\ker r_\pm)\).  When
\(\bar F=s\bar F_{\mathrm{norm}}\), the retained consumer is

\[
 \mathsf{JetRank}(P_-,r_-;P_+,r_+;F)
   =\bar F_{\mathrm{norm}}\bmod s:
      L_-/sL_-\longrightarrow L_+/sL_+.                         \tag{42.15}
\]

where the initial coefficient is taken after removing the known universal
factor \(1-q^{-1}\).  This is a parameterized path object: forgetting \(q\)
before taking the jet sends the row to zero and cannot be repaired later.
The output is the special-fibre line map (42.13c), not the raw specialization
of \(\Theta_q\).

In this primitive unramified \(q\)-trait and for named canonical source and
target lattices, the Module 40 valuation target changes accordingly.  The raw
canonical bridge has forced valuation one, not zero.  The new saturation
question is

\[
 \boxed{\nu_{q=1}(\text{actual marked overlap})=1,
        \quad\text{with initial row coefficient nonzero}.}      \tag{42.16}
\]

After subtracting the universal Writer contribution \(1\), residual
valuation zero is exactly the rank-one hypothesis of Theorem 42.4.  A value
greater than one is additional closed-support torsion beyond quantum Serre's
unavoidable normal factor.  Even at residual value zero, the ordinary raw
closed-fibre map remains zero; the jet transition must be consumed in its
own typed path interface.

Both normalizations are load-bearing.  Rescaling a target lattice by \(s\)
changes the valuation, and under a ramified parameter
\(q-1=u t^e\) the universal baseline is \(e\), not \(1\).

## 42.6 Conditional route to the unit overlaps

For one of Module 41's oriented unit-overlap models, the completion route is
rank-safe if the following occurrence-level data are constructed:

1. the common completed GIT/GKZ model, the geometric-phase certificate
   (42.2a), and a primitive fibre-scaling character \(q\) with an unramified
   \(q=1\) trait;
2. an equivariant quantum-Serre or GLSM adapter carrying the actual primitive
   packet and Gamma point line into one common receiver, in the variance
   consumed by Module 34;
3. named canonical source/target trait lattices whose marked packet coimages
   \(L_\pm\) are nonzero free of rank one, with exact base change and no
   hidden \(s\)-rescaling;
4. a factorization on those coimages
   \(F=(1-q^{-1})F_{\mathrm{norm}}\), with \(F_{\mathrm{norm}}\) integral;
5. zero residual Smith/Gamma valuation, so
   \(F_{\mathrm{norm}}\bmod(q-1)\) is invertible; and
6. a typed identification of that special-fibre normal-jet map with the
   actual endpoint rank lines, plus adjacent reindexing and orientation
   coherence along the chosen birational path.

Then Theorem 42.4 gives an isomorphism for every edge in the **jet-enriched**
rank-line path, and the proof pattern of Module 34 telescopes those
isomorphisms.  One may apply Module 40's DVR saturation logic to
\(F_{\mathrm{norm}}\), after item 6 identifies its closed fibre; Theorem 40.4
does not apply to the raw \(F\).  Existing quantum Serre theorems do not
themselves provide items 1--6 for a discrepant AKMW overlap.

## 42.7 Source and scope audit

- Coates--Givental, *Quantum Riemann--Roch, Lefschetz and Serre*,
  arXiv:math/0110142, proves the Euler/inverse-Euler quantum-Serre relation.
- Iritani--Mann--Mignon, *Quantum Serre theorem as a duality between quantum
  D-modules*, arXiv:1412.4523v2, Theorem 3.14 gives the precise forward QDM
  morphism for smooth projective \(X\) and convex \(E\).  Under its additional
  regular-section hypotheses, Proposition 4.5 gives the Gamma/K-theory
  diagram, including the scalar (42.8a); its Section 4 specializes the
  Novikov variable to one.  Applying it to a local wall occurrence, restoring
  the required Novikov family, or reversing its variance requires a separate
  geometric adapter.
- Steiner, *Dualizing, projecting, and restricting GKZ systems*,
  arXiv:1805.02727v4, Theorem 5.8, assumes a face of a normal pointed
  semigroup configuration.  Proposition 42.1 shows why that theorem does not
  delete the canonical charge coordinate here.

The algebraic K-theory and first-jet statements in Proposition 42.2 and
Theorem 42.3 are proved directly.  No cited theorem is read as the missing
occurrence-level saturation result.

## 42.8 EJ/TT and mystery ledger

**EJ.** The failed raw bridge is universal rather than occurrence-specific:
its Writer valuation is exactly one on the rank row.  The required
augmentation is correspondingly tiny--one equivariant normal parameter and
one jet.  We do not need the full equivariant completed QDM as the final
consumer.

**TT.** Do not demand zero valuation from the unnormalized canonical bridge;
quantum Serre proves that this is false.  Also do not divide by
\(1-q^{-1}\) on the full object: only the marked sparse shadow is divisible.
The provider theorem must type the optic before normalization and must
supply the required comparison variance.

| question | status | exact evidence or gate |
|---|---|---|
| Is deletion of the added charge a standard GKZ face restriction? | **no** | Proposition 42.1 |
| Does the forward non-equivariant Serre bridge preserve rank or the point line? | **no** | Proposition 42.2 |
| What is its exact rank-shadow defect? | **one universal simple normal factor** | Theorem 42.3 |
| Is another augmentation needed for this route? | **yes: the fibre character and first jet** | (42.14)--(42.15) |
| Does quantum Serre already type the actual AKMW overlap? | **no** | occurrence/convexity/variance/common-receiver gate |
| Does a nonzero jet make the raw closed fibre invertible? | **no** | \(s:R\to R\) countermodel |
| What finite calculation remains? | **residual valuation zero plus identification of the jet map** | Theorem 42.4 and item 6 |

## Boundary

The standard forward quantum-Serre map from the unaugmented canonical
completion cannot by itself close \(m=2\): that map annihilates the marked
point/rank shadow.  The equivariant first normal jet repairs that shadow
inside a new jet-line consumer and changes the numerical target from raw
valuation zero to raw valuation one with nonzero initial coefficient.  It
does not invert the ordinary closed-fibre map.  What remains is an
occurrence-level equivariant Gamma/QDM adapter in the required variance,
proof that no additional resonant torsion raises that valuation, and a typed
identification of the normalized jet map along the birational path.
