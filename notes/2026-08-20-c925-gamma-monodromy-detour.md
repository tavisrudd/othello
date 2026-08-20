# Module 29. The Gamma--monodromy detour

**Packet part:** Module 29.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** abstract transfer theorem proved; Iritani's local divisor-direction
compatibility identified; coherent weak-factorization line-bundle state open

## 29.1 The apparent augmentation can be factored

The current operation is

\[
\tau_L=[\,{-}\otimes L\,],
\qquad
N_L=1-\tau_L
\tag{29.1}
\]

on complexified rational \(K\)-theory.  Module 28 showed that Iritani's
formal Laurent decomposition does not state compatibility with this
operation.

There is, however, a standard detour through the quantum connection.
Iritani's Gamma framing

\[
s_W:K(W)\longrightarrow \mathcal S(W)
\tag{29.2}
\]

identifies the complexified \(K\)-group with the flat-section space of the
quantum connection and satisfies

\[
s_W(V)(\tau-2\pi i\,c_1(L),z)
=
s_W(V\otimes L)(\tau,z).
\tag{29.3}
\]

Thus tensor-by-\(L\) is the large-radius Galois monodromy in this framing.
This is stated in Section 1.3 of:

Hiroshi Iritani, *Gamma classes and quantum cohomology*,
[arXiv:2307.15938](https://arxiv.org/abs/2307.15938).

Audited local copy:

- cache key: arXiv:2307.15938;
- SHA-256:
  462f2e0d6eff6315d9fcc2e0db78f95f14558d532d118e31b74f2270c2e0ab8a;
- 18 pages; and
- full-text extraction:
  /tmp/persistent/tavis/lit-search/text/arXiv_2307.15938.txt.

The important typing point is that the blowup comparison need not preserve
the Gamma lattice.  It is enough for it to preserve the corresponding
monodromy operator on the ambient complex flat-section space.

The abstract commutation of parameter monodromy with the whole generalized
formal-primary sector, and its Gamma application to \(N_L\), were already
proved in notes/2026-08-13-c907-formal-primary-galois-stability.md on a
fixed non-turning locus.  Module 29 does not claim that theorem anew.  It
factors it through the present provider interface and audits where
Iritani's blowup Fourier maps expose the required divisor direction.

## 29.2 Abstract transfer theorem

### Theorem 29.1 -- horizontal transfer of a tensor operation

Let \(\mathcal S_B,\mathcal S_Y,\mathcal S_E\) be finite-dimensional local
systems on a common punctured base and let

\[
\Psi:\mathcal S_B\xrightarrow{\sim}\mathcal S_Y\oplus\mathcal S_E
\tag{29.4}
\]

be a single-valued horizontal isomorphism.  Let \(\gamma\) be a based loop
whose induced loops on the three systems have monodromies
\(T_B,T_Y,T_E\).  Then

\[
\Psi T_B=(T_Y\oplus T_E)\Psi.
\tag{29.5}
\]

Consequently

\[
\Psi(1-T_B)^m
=
\bigl((1-T_Y)^m\oplus(1-T_E)^m\bigr)\Psi
\tag{29.6}
\]

for every \(m\ge0\).

If Gamma framings identify \(T_W\) with tensor-by-\(L_W\) on a chosen
complexified \(K\)-sector, equation (29.6) transports the \(N_L\)-top
without requiring \(\Psi\) to map one integral lattice to another.

#### Proof

Horizontal naturality gives
\(\Psi_{\gamma(1)}\operatorname{PT}_B(\gamma)
=\operatorname{PT}_{Y\oplus E}(\gamma)\Psi_{\gamma(0)}\).
The loop is based and \(\Psi\) is single-valued, so its endpoint maps agree,
giving (29.5).  Polynomial functional calculus gives (29.6).  Equation
(29.3) identifies the monodromy operators with the tensor actions in the
Gamma framings.  \(\square\)

### Corollary 29.1A -- formal Levelt version

Work over a subfield of \(\mathbf C\) and let the logarithmic formal
connections be equipped with a functorial Levelt/formal-solution object
allowing the required powers and logarithms of \(Q\).  Suppose:

1. chosen connection-stable logarithmic lattices exist;
2. \(\Psi\) extends invertibly between them;
3. \(\Psi\) intertwines the connection along an integral cocharacter
   \(\xi Q\partial_Q\); and
4. the formal monodromy is the deck action on those formal solution
   objects for that same cocharacter.

Then (29.5)--(29.6) hold for formal monodromy.

#### Proof

Apply the extended horizontal map coefficientwise to a formal flat
solution, including its \(Q^\alpha(\log Q)^k\) terms.  It commutes with the
deck action \(Q\mapsto e^{2\pi i}Q\), so formal monodromy is natural exactly
as in Theorem 29.1.  \(\square\)

Raw conjugacy of logarithmic residues is not by itself sufficient in a
resonant system: holomorphic higher terms can create logarithmic solutions
and additional unipotent monodromy even when the residue exponential is
trivial.  Therefore an application to the completed QDM still needs the
formal Levelt/solution compatibility above, or a separate normal-form
theorem eliminating that resonance.  No convergence in the independent
irregular \(q\)-direction is required.

This corollary is deliberately cocharacter-indexed.  Commuting with an
unrelated connection direction does not type the desired line-bundle loop.

## 29.3 What Iritani's blowup construction already supplies locally

In *Quantum cohomology of blowups*:

1. Proposition 5.1(3) says that the ambient Fourier projection intertwines
   \(z\nabla_{\xi Q\partial_Q}\) with the corresponding divisor direction on
   the ambient QDM.
2. Proposition 5.4 carries this law to the completed formal Laurent module.
3. Proposition 5.7(3) gives the center law; when the equivariant
   \(\lambda\)-component of \(\xi\) is zero, the target divisor is
   \(\xi|_Z\).
4. Corollary 5.8 carries the center law to the completion.
5. Theorem 5.18(1) assembles the projections into a connection-compatible
   direct-sum isomorphism over the common \(Q\)-base.

For a line bundle \(L\) descending from the blowup base, these are exactly
the infinitesimal directions expected from

\[
\pi^*L\quad\longmapsto\quad
\left(L,L|_Z,\ldots,L|_Z\right).
\tag{29.7}
\]

Moreover, the comparison coefficients are formal power series in integral
powers of \(Q\).  If the identified descending-\(L\) cocharacter has zero
weight in the exceptional \(q\)-direction, then the ramified Laurent
variable \(q^{1/s}\) stays fixed and the raw permutation of the
\(q\)-branches from Module 28 is not forced into this particular
\(Q\)-monodromy calculation.  Verifying that zero \(q\)-weight is part of
the still-open geometric cocharacter identification; integral \(Q\)-powers
alone do not prove it.

This does not yet promote (29.5) as an instantiated Iritani theorem.  One
must still verify in the exact completed category that the C925 cocharacter
is the common \(Q\)-cocharacter in Propositions 5.1 and 5.7 and that the
formal monodromy functor used by the cyclotomic sector is the one identified
by (29.3).  But the missing statement is now a bounded
residue/cocharacter-identification lemma, not compatibility of the entire
Gamma lattice.

## 29.4 Consequence for source sufficiency

The source package

\[
(\chi,N_L,N_L^{m+1}=0,N_L^mV\ne0)
\tag{29.8}
\]

is sufficient.  No point row and no Gamma **mark** is added to the consumer.
Gamma framing is used as a bridge theorem identifying the already chosen
operation with monodromy.

The comparison-side alternatives are now:

1. **Gamma--monodromy detour:** verify the common cocharacter and apply
   Theorem 29.1/Corollary 29.1A;
2. **direct operation framing:** construct a cyclotomic realization which
   intertwines tensor-by-\(L\) directly;
3. **ExactTop graph:** compute only the projection criterion of Module 28;
   or
4. **oriented heart:** kill the Module 25 boundary by Module 26.

The first route is cheapest when a single descending line bundle exists.

## 29.5 The global path obstruction has become explicit

A local blowup arrow has a canonical rule

\[
(Y,L)\longmapsto(\operatorname{Bl}_Z Y,\pi^*L).
\tag{29.9}
\]

A general weak-factorization zigzag does not automatically carry one
line-bundle state: when an arrow is traversed as a blowdown, the current
line bundle may have an exceptional coefficient and need not descend.
Independent per-edge choices cannot be composed by the dependent path
interface of Module 27.

Thus the exact new provider type is a coherent section

\[
(Y_i,L_i,\xi_i)
\quad\text{with}\quad
L_{i+1}\cong\pi_i^*L_i
\tag{29.10}
\]

in the appropriate orientation at every occurrence, together with endpoint
identifications and the same primitive character sector.  If instead

\[
L_{i+1}\cong\pi_i^*L_i\otimes\mathcal O(a_iE_i),
\tag{29.11}
\]

the exceptional coefficient \(a_i\) is a Writer output, not ignorable
bookkeeping: tensor-by-\(\mathcal O(a_iE_i)\) can mix the Orlov components.
One must compute its effect on the retained top or prove that it is
threshold-null.

This is precisely where the Reader/indexed-State/Writer and path-map
interfaces earn their keep.  They prevent a locally valid monodromy law
from being telescoped across incompatible line-bundle states.

## 29.6 \(m=2\) and all-\(m\) status

For \(m=2\), the Gamma--monodromy detour would discharge the comparison
strictness gate along any coherent descending-\(L\) path.  It does not prove:

1. existence of such a path for a hypothetical rationality comparison;
2. \(N_{L,E}^2=0\) for every actual specialized center occurrence; or
3. threshold-nullity of exceptional corrections (29.11).

For all \(m\), exactly the same theorem applies at threshold \(m\).
Therefore the comparison law itself is uniform.  The all-\(m\) burden is
now concentrated in a uniform path-state theorem and the indexed carrier
bound, rather than in a new monodromy theorem for each \(m\).

This is a genuine structural gain: if a cofinal fixed-factor family admits
one coherent descending line-bundle environment, the local
cocharacter/Levelt and threshold-null certificates, and the indexed carrier
bound, Corollary 24.4A upgrades its obstruction to all stabilization
indices.

## 29.7 EJ/TT audit

**EJ.** Gamma framing need not be retained by the consumer or preserved by
the blowup comparison.  It can be inserted and eliminated as an
intermediate representation theorem:

\[
\text{tensor action}
\xrightarrow[\Gamma]{\sim}
\text{large-radius monodromy}
\xrightarrow[\Psi]{\sim}
\text{component monodromies}.
\tag{29.12}
\]

This is the category-theoretic factorization that the earlier augmentation
question was missing.

**TT.** Three independent gates must not be merged:

1. local horizontal/cocharacter compatibility;
2. global coherence of the line-bundle state along the chosen path; and
3. the exceptional exponent/carrier theorem.

The first may already be latent in Iritani's Fourier-projection laws.  It
does not imply either of the other two.

## 29.8 Mystery ledger

| question | status | exact evidence or gate |
|---|---|---|
| Does tensor-by-\(L\) equal QDM Galois monodromy in the Gamma framing? | **settled: yes** | Iritani, Section 1.3, equation (29.3) |
| Must the blowup comparison preserve the Gamma lattice? | **settled: no for the complex ExactTop consumer** | Theorem 29.1 factors through monodromy |
| Does Iritani intertwine the relevant infinitesimal divisor direction? | **settled locally** | Propositions 5.1, 5.4, 5.7; Corollary 5.8; Theorem 5.18(1) |
| Is the exact formal cocharacter/monodromy identification instantiated? | **open bounded lemma** | verify the C925 \(L\)-cocharacter, zero \(q\)-weight, and formal Levelt functor in the completed cyclotomic sector |
| Does one coherent descending \(L\) exist along a rationality factorization? | **open** | construct the dependent path section (29.10) |
| Are exceptional line-bundle corrections harmless? | **open** | compute the Writer output (29.11) on \(\operatorname{Top}_m\) |
| Is the exceptional term killed at threshold? | **open** | occurrence-indexed carrier theorem |

## Boundary

Theorem 29.1 and Corollary 29.1A are formal transfer statements.  The
source audit sharply reduces the local operation-realization problem but
does not supply a global line-bundle path or the exceptional exponent.  No
unconditional \(m=2\) or all-\(m\) theorem is claimed.
