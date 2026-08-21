# Module 61. The diagonal coefficient trait exists on every unit pilot

**Packet part:** Module 61. Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** the coefficient-torus/DVR-arc gate left open in Modules 59--60 is
proved for all five completed unit pilots.  The all-ones class is primitive
in the Gale quotient, so one may choose the Spenko--Van den Bergh splitting
whose normalized lift is \(\gamma(t)=t(1,\ldots,1)\).  Consequently every
coefficient in Proposition 12.6 is the same
\(q=e^{-2\pi i t}\), \(1-q\) is a uniformizer, and the crossed product normal
is \((1-q)^{|J|}\).  This closes only the decategorified \(K_0\)-schober
pilot trait.  The categorical schober family, actual AKMW occurrence,
based-loop reindexing, and fixed-phase QDM/Malgrange reader remain open.

## 61.1 Lattice criterion for a diagonal normalized lift

Consider the source exact sequence

\[
 0\longrightarrow L\xrightarrow{B^*}\mathbf Z^d
   \xrightarrow{A}N\longrightarrow0,                         \tag{61.1}
\]

and put \(\mathbf 1=(1,\ldots,1)\).  Quasi-symmetry gives
\(B(\mathbf1)=\sum_i b_i=0\), but that alone does not force a chosen splitting
to kill \(\mathbf1\).  The exact integral condition is primitivity of
\(\overline{\mathbf1}=A(\mathbf1)\in N\).

### Proposition 61.1 -- adapted integral splitting

Assume \(\overline{\mathbf1}\) is primitive in \(N\).  Then there is an
integral section \(\kappa:N\to\mathbf Z^d\) of \(A\) such that

\[
                    \kappa(\overline{\mathbf1})=\mathbf1.    \tag{61.2}
\]

The complementary cocharacter-lattice projection

\[
 \pi_L=\operatorname{id}_{\mathbf Z^d}-\kappa A:
 \mathbf Z^d\longrightarrow\operatorname{im}B^*              \tag{61.3}
\]

satisfies \(\pi_L\mathbf1=0\).  After identifying
\(\operatorname{im}B^*\cong L\), it is a splitting of the type used in the
normalized GKZ descent.

**Proof.** Extend the primitive vector \(\overline{\mathbf1}\) to a basis of
the free group \(N\).  Lift the remaining basis vectors arbitrarily and lift
\(\overline{\mathbf1}\) by \(\mathbf1\).  This defines \(\kappa\).
Equation (61.3) is the complementary projection, and
\(\pi_L\mathbf1=\mathbf1-\kappa A\mathbf1=0\). \(\square\)

### Proposition 61.2 -- exact finite primitivity certificate

For each of the five completed Module 41 signatures, form the \(8\times3\)
integer matrix

\[
                         [\,B^*\mid\mathbf1\,].              \tag{61.4}
\]

The gcd of its \(3\times3\) minors is one:

| completed signature | gcd |
|---|---:|
| blowup--blowdown | 1 |
| blowup--reverse-curve-flip | 1 |
| curve-flip--blowdown | 1 |
| flip--flip, anti-diagonal completion | 1 |
| flip--flip, diagonal completion | 1 |

Hence \(\operatorname{im}B^*+\mathbf Z\mathbf1\) is primitive in
\(\mathbf Z^8\), equivalently \(\overline{\mathbf1}\) is primitive in
\(N=\mathbf Z^8/\operatorname{im}B^*\).

**Proof.** For a full-rank integer matrix, the gcd of the maximal minors is
the index of its image in its saturation.  The exact checker enumerates all
\(\binom83\) minors for every signature.  Gcd one gives saturation.  Passing
through the already primitive sublattice \(\operatorname{im}B^*\) gives the
equivalent quotient statement. \(\square\)

## 61.2 The lawful diagonal trait

Fix the adapted splitting from Proposition 61.1 and define

\[
 \gamma(t)=t\mathbf1,\qquad
 \alpha(t)=A\gamma(t)=t\,\overline{\mathbf1}.                \tag{61.5}
\]

Then \(A\gamma(t)=\alpha(t)\) and \(\pi_L\gamma(t)=0\), so by uniqueness this
is exactly the normalized lift appearing in Proposition 12.6.  Therefore

\[
 z_j(t)=e^{-2\pi i\gamma_j(t)}
       =e^{-2\pi i t}=:q(t) \quad\text{for every }j.          \tag{61.6}
\]

### Theorem 61.3 -- admissible punctured coefficient trait

Under Spenko--Van den Bergh's standing pointed-cone and homogeneity
assumptions, (61.5) defines a sufficiently small punctured analytic trait of
nonresonant parameters.  At its center \(t=0\), \(q=1\), and

\[
                         1-q=2\pi i\,t+\mathrm O(t^2)         \tag{61.7}
\]

is a uniformizer up to a unit.  Base-changing the integral decategorified
window representation along

\[
 K_0(\overline S_C^c)\otimes_{\mathbf Z[X(H)]}R,
 \qquad e^\mu\longmapsto q^{\langle\mu,A\mathbf1\rangle},    \tag{61.7a}
\]

gives a finite-free decategorified \(K_0\)-schober trait on the fixed window
labels.  Its fibre matrices are the formulas of Proposition 12.6.

**Proof.** Let \(H_F\) be a hyperplane spanned by a facet of the pointed cone
\(\mathbf R_{\ge0}A\), and choose its rational supporting functional
\(\ell_F\), nonnegative on every \(a_i\).  Since the \(a_i\) span the cone
and the facet is proper,

\[
 \ell_F(\overline{\mathbf1})=\sum_i\ell_F(a_i)>0.            \tag{61.8}
\]

Thus the line \(t\overline{\mathbf1}\) is not contained in any central
resonance hyperplane.  Each rational affine lattice translate meets this
line discretely.  There are finitely many facet directions, so a sufficiently
small punctured disc avoids every translated resonance hyperplane.
Equation (61.7) is the Taylor expansion of the exponential.  Lemma 12.1 gives
the finite-free integral window module, and Proposition 12.4 gives the
representation maps over \(\mathbf Z[X(H)]\).  Base change by (61.7a)
therefore preserves their relations and finite freeness.  Proposition 12.6
computes the resulting fibre matrices; entrywise use of that proposition
alone would not certify the representation relations. \(\square\)

The theorem asserts nonresonance, not total nonresonance.  That is the
hypothesis used for the nonresonant GKZ local system; Proposition 12.6 itself
is stated for arbitrary \(h\in H\).

## 61.3 Consequence for the crossed pilot

### Corollary 61.3A -- the formal diagonal normal is an actual pilot trait

For every directed wall in all five completed signatures,

\[
 A_{\eta,z}
   =\prod_{j\in J}(1-z_j\eta^{-d_j})
   =(1-q)^{|J|}
 \quad\text{at }\eta=1.                                     \tag{61.9}
\]

Since every genuine wall has \(|J|\ge1\), this coefficient has finite
positive valuation.  Module 60's crossed relative row therefore vanishes on
the closed fibre of this labelled coefficient model for every directed pilot
transition.

This is a real strengthening of Module 60: the diagonal substitution is no
longer merely formal in the decategorified \(K_0\) trait.  It still does not
construct a categorical schober family or identify this model with an actual
flat schober specialization, fixed-phase cubic QDM packet, or based loop.
Those are different types and remain explicit.

## 61.4 Reproducibility and source audit

The exact primitivity check is part of:

- notes/cubic-threefolds-tasks/c925-unit-window-intersections.py;
- notes/cubic-threefolds-tasks/c925-unit-window-intersections.json.

Use the exact replay command and hashes in Module 59.  The certificate field
all_diagonal_quotient_classes_primitive is true, and every per-signature
diagonal_augmented_minor_gcd is one.

Primary source:

- Spenko--Van den Bergh, *Perverse schobers and GKZ systems*,
  arXiv:2007.04924, exact cached PDF SHA-256
  73dffed6c948ac1dd48de1bab994a09e55e875b29dc69473d1d5d6d1e324fd0d:
  (3.1)--(3.2) for the lattice/torus sequence, Section 3.6 for nonresonance,
  Section 4.3 for the splitting, Lemma 12.1 and Proposition 12.4 for the
  finite-free integral window representation, and Proposition 12.6 with
  (12.3) for the normalized coefficient \(e^{-2\pi i\gamma_j}\) and fibre
  formula.

The source does not state Proposition 61.1, the five gcd computations, or
the adapted diagonal trait.  Those are the extension proved here.

## 61.5 EJ/TT and mystery ledger

**EJ.** The all-ones substitution was not an arbitrary convenient arc.  It
is forced by an adapted integral splitting, and every pilot admits that
splitting.  One of the two Module 60 provider gates has therefore closed.

**TT.** Do not spend more time on coefficient valuation for these pilots.
The remaining issue is functorial realization: does the actual fixed-phase
packet see this same normalized schober edge and the same based loop?

| question | status | evidence or remaining gate |
|---|---|---|
| Is the all-ones quotient class primitive? | **yes for all five pilots** | Proposition 61.2 and exact certificate |
| Can the normalized lift have all coordinates equal? | **yes** | Proposition 61.1 |
| Is \(q-1\) a genuine trait parameter? | **yes up to a unit** | Theorem 61.3 |
| Is the punctured trait nonresonant? | **yes in the stated pointed homogeneous source scope** | facet-functional proof (61.8) |
| Does the crossed schober row vanish at the pilot center? | **yes** | Corollary 61.3A |
| Is this the actual cubic fixed-phase packet edge? | **open** | occurrence/based-loop/QDM--Malgrange reader |

## Boundary

The coefficient-torus arc is no longer a blocker on any completed unit
pilot.  The sole live source theorem is now the vertical realization:
identify an actual \((1,1)\) overlap and its fixed-phase directed Malgrange
packet with the provenance-tagged crossed schober edge, including the based
loop and exact closed reader.
