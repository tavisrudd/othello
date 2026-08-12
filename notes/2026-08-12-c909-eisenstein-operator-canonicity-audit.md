# C909 — Eisenstein operator canonicity: exact packet theorem and no comparison map

Date: 2026-08-12

Status: exact audit of the `O_3` packet.  It corrects the weak wording in the
earlier two-shadow note: `-M` is canonical **relative to a specified formal
rank-two block and the positive formal meridian**.  There is still no
canonical identification with the exotic mod-two marking.  No manuscript,
PDF, mirror, Lean, or commit change.

## The exact local theorem

Put

\[
 \mathcal O_3=\mathbf Z[t]/(t^2+t+1)=\mathbf Z[\zeta_3].
\tag{1}
\]

Let `(V,M)` be a specified rank-two complex formal-monodromy block of the
cubic connection, with the positive complex meridian as its monodromy
generator.  If its formal exponents are `-1/6,-5/6` modulo `Z`, then

\[
 \operatorname{Spec}(M)=
 \{e^{-\pi i/3},e^{\pi i/3}\},
 \qquad M^2-M+1=0.
\tag{2}
\]

Define the endomorphism

\[
 N:=-M.
\tag{3}
\]

Then, exactly,

\[
 \begin{aligned}
 -e^{\pi i/3}&=e^{-2\pi i/3}=\zeta_3^2,\\
 -e^{-\pi i/3}&=e^{ 2\pi i/3}=\zeta_3,
 \end{aligned}
 \qquad
 N^2+N+1=0.
\tag{4}
\]

Consequently

\[
 \rho_M:\mathcal O_3\longrightarrow\operatorname{End}_{\mathbf C}(V),
 \qquad t\longmapsto N=-M,
\tag{5}
\]

is a canonical unital `O_3`-action relative to `(V,M)`.  It is injective and
after scalar extension is the split action

\[
 \mathcal O_3\otimes\mathbf C\simeq\mathbf C\times\mathbf C
 \longrightarrow\operatorname{End}(V),
 \qquad
 t\longmapsto(\zeta_3,\zeta_3^2),
\tag{6}
\]

up to interchanging the two eigenspaces.  No eigenline is selected in (5).

**Proof.**  Exponentiation of the two residues gives (2).  Cayley--Hamilton
gives the displayed polynomial for `M`; substituting `N=-M` gives (4), hence
(5).  The roots in (4) are distinct, so the complexified algebra is the
two-idempotent algebra in (6).  Every isomorphism of pairs `(V,M)` commutes
with `-M`; thus this construction is functorial, not a chosen diagonalization.

The hypothesis “specified block” is load-bearing.  A statement which knows
only that some summand has this spectrum supplies an isomorphism class of
`O_3`-modules, not a globally defined endomorphism of a designated bundle.
Likewise, the quantum/atom argument that retains only the formal spectrum
does not by itself construct `V` globally over the cubic parameter space.

## The two involutions

The nontrivial involution of the order is

\[
 \iota:\mathcal O_3\longrightarrow\mathcal O_3,
 \qquad t\longmapsto t^2=-1-t.
\tag{7}
\]

There are two exact realizations, but they live in different fibre functors.

At two,

\[
 \mathcal O_3/2=\mathbf F_2[t]/(t^2+t+1)=\mathbf F_4,
 \qquad\operatorname{Frob}_2(x)=x^2.
\tag{8}
\]

For the `A_5` heart, `D=End_{F_2A_5}(H)=F_4`.  The two exotic slopes are
the two elements `a` of `D\setminus F_2`, or equivalently the two
`F_2`-algebra embeddings

\[
 \operatorname{Hom}_{\mathbf F_2\text{-alg}}(\mathcal O_3/2,D)
 =\{t\mapsto\omega,\ t\mapsto\omega^2\}.
\tag{9}
\]

Frobenius exchanges them and implements (7).  The two graph kernels are the
graphs `Gamma_omega,Gamma_{omega^2}`; they are geometric points of the
inert special fibre, not two topological `F_2`-points of `Spec F_4`.

On the quantum block, reversing the oriented meridian replaces `M` by
`M^{-1}`.  It therefore replaces the action (5) by

\[
 -M^{-1}=N^{-1}=N^2,
\tag{10}
\]

which is precomposition of `rho_M` with `iota`.  Scalar complex conjugation
also exchanges the two factors of (6).  If the cubic/connection carries an
actual real structure, its semilinear conjugation has that effect on the
eigenvalue packet.  For a general complex cubic, however, “complex
conjugation” means only the Galois action on `O_3\otimes C`, not an
automorphism of its quantum connection.  Thus the exact common statement is

\[
 \operatorname{Frob}_2\quad\text{and}\quad
 (\text{meridian reversal, or scalar conjugation})
 \quad\text{both realize }\iota\in\operatorname{Aut}(\mathcal O_3).
\tag{11}
\]

It is incorrect to say they are equal monodromies on a common geometric
family.

## Is this more than analogy?

Yes, but only at the coefficient-packet level.  Equations (5) and (9) give
two rigorous realizations of the same finite-etale quadratic order at two
different places:

\[
 \mathcal O_3[1/3]
 \quad\rightsquigarrow\quad
 \begin{cases}
  \mathcal O_3/2\simeq\mathbf F_4\subset\operatorname{End}_{F_2A_5}(H),\\
  \mathcal O_3\otimes\mathbf C\subset\operatorname{End}_{\mathbf C}(V),
 \quad t\mapsto-M.
 \end{cases}
\tag{12}
\]

This is a valid and useful proof compression: the exceptional finite-etale
pair and the negative sixth-root monodromy pair are both governed by
`Phi_3`, and their swaps are the same order involution.  In particular, the
minus normalization is now canonical relative to formal monodromy; it is
not a post hoc relabelling of eigenvalues.

It is **not** a comparison theorem.  The cycle side has an intrinsic
unordered `C_2`-packet, while (5), if global, is already an oriented
`O_3`-action and its constant-eigenvalue idempotents split the bare quantum
label cover.  To identify the two families over a base `S`, one must first
specify a quantum descent/orientation torsor `Q` and prove

\[
 [Q]=[K_{\rm ex}]\quad\text{in }H^1_{\rm et}(S,C_2).
\tag{13}
\]

Neither the shared polynomial, nor the local operation `M\mapsto-M`, proves
this equality.  No common integral `O_3`-lattice, correspondence, or
intertwiner is presently supplied.

## EJ + TT closeout / mystery ledger

**EJ settled:** the corrected root calculation is
`-e^{pi i/3}=zeta_3^2` and `-e^{-pi i/3}=zeta_3`; hence `t\mapsto-M` is the
canonical `O_3` action on any designated, positively oriented formal block.

**TT correction:** do not call complex conjugation a quantum symmetry for an
arbitrary complex cubic.  Use meridian reversal for the intrinsic formal
involution, or assume and state a real structure.

**Open gate:** globalize the distinguished rank-two block and exhibit a
quantum `C_2` descent torsor.  Only then can (13) be tested against the
exotic-kernel selector.  Until then this remains a real common coefficient
packet, not a cycle--quantum bridge.
