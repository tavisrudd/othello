# Module 27. Dependent typing of the QDM provider crux

**Packet part:** Module 27.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** mathematical interface and transfer theorems proved; no
formalization intended; geometric provider remains open

Dependent type theory does not supply the missing QDM comparison.  Its value
here is diagnostic: it separates data which determine the type of the
boundary from propositions which kill that boundary, and makes every
forgetful step explicit.

The design below uses a Kmett-flavored concern for variance, indices, and
compositional laws, together with an Oleg Kiselyov--flavored concern for the
smallest trusted kernel and hostile models.  It is a mathematical interface,
not a proposal for a tagless DSL or a formalization project.

## 27.1 The dependent base

An actual blowup occurrence is not determined by its center alone.  Let

\[
\sigma=
(Y,\widetilde Y,Z,c,\chi,j,\rho,p)
\tag{27.1}
\]

record:

- the ambient and blowup;
- the actual center and codimension;
- the primitive character;
- the exceptional-copy label;
- the occurrence specialization or coordinate change \(\rho\); and
- the position \(p\) in the chosen weak-factorization path.

Let \(\mathbf{Occ}\) be the category of such occurrence environments and
lawful reindexing maps.  The operation-framed receiver, its objects, and its
nilpotent operation depend on \(\sigma\):

\[
\sigma\longmapsto
(\mathcal H_\sigma,\mathcal A_\sigma,\mathcal E_\sigma,
 N_\sigma,A_\sigma,B_\sigma,E_\sigma).
\tag{27.2}
\]

Here \(\mathcal H_\sigma\) is abelian and
\(\mathcal A_\sigma,\mathcal E_\sigma\subseteq\mathcal H_\sigma\) are full
subcategories.

The correct carrier is therefore the dependent sum

\[
\sum_{\sigma:\mathbf{Occ}}
(\mathcal H_\sigma,\mathcal A_\sigma,\mathcal E_\sigma,
 N_\sigma,A_\sigma,B_\sigma,E_\sigma),
\tag{27.3}
\]

not one unindexed center packet.  Projecting away \(\sigma\) is the exact
place where occurrence specialization, orientation, or path holonomy can be
lost.

## 27.2 Orientation is a type index

Let

\[
\mathbf{Or}=\{\mathsf{sub},\mathsf{quot}\},
\]

where

\[
\begin{aligned}
\mathsf{Seq}(\mathsf{sub})
  &:= [\,0\to E\to B\to A\to0\,],\\
\mathsf{Seq}(\mathsf{quot})
  &:= [\,0\to A\to B\to E\to0\,].
\end{aligned}
\tag{27.4}
\]

The associated boundary type is a dependent family:

\[
\begin{aligned}
\mathsf{Boundary}_m(\mathsf{sub})
  &:=\operatorname{Hom}
      (\ker N_A^m,E),\\
\mathsf{Boundary}_m(\mathsf{quot})
  &:=\operatorname{Hom}
      (E,\operatorname{coker}N_A^m).
\end{aligned}
\tag{27.5}
\]

This one index prevents the variance error which survived several informal
formulations.  Standard Orlov ambient-to-exceptional orthogonality inhabits
the first Hom type.  It cannot be passed as evidence for the second.

The exact sequence itself must be a term of
\(\mathsf{Seq}(o)\), not a Grothendieck-group equality or an unoriented
triangle.

## 27.3 The minimal evidence record

For \(o:\mathbf{Or}\), \(\sigma:\mathbf{Occ}\), and threshold \(m\), define a
provider record

\[
\mathsf{Provider}(o,\sigma,m)
\tag{27.6}
\]

with the following fields.

1. **Native exact data**
   \[
   \mathsf{seq}:\mathsf{Seq}_\sigma(o).
   \]
2. **Operation**
   \[
   N_\sigma:\operatorname{Id}_{\mathcal H_\sigma}
   \Rightarrow\operatorname{Id}_{\mathcal H_\sigma},
   \]
   acting on the displayed exact sequence.
3. **Actual carrier exponent**
   \[
   N_{E_\sigma}^m=0.
   \]
4. **Orientation-specific typing**
   \[
   \begin{cases}
   \ker N_{A_\sigma}^m\in\mathcal A_\sigma,\quad
   E_\sigma\in\mathcal E_\sigma,
      &o=\mathsf{sub},\\
   E_\sigma\in\mathcal E_\sigma,\quad
   \operatorname{coker}N_{A_\sigma}^m\in\mathcal A_\sigma,
      &o=\mathsf{quot}.
   \end{cases}
   \]
5. **Oriented orthogonality**
   \[
   \begin{cases}
   \operatorname{Hom}(\mathcal A_\sigma,\mathcal E_\sigma)=0,
      &o=\mathsf{sub},\\
   \operatorname{Hom}(\mathcal E_\sigma,\mathcal A_\sigma)=0,
      &o=\mathsf{quot}.
   \end{cases}
   \]
6. **Actual realization**
   an exact \(N\)-compatible functor
   \[
   U_\sigma:\mathcal H_\sigma\longrightarrow
   K[N]\text{-}\mathbf{Mod}
   \tag{27.7}
   \]
   together with specified isomorphisms identifying
   \(U_\sigma(A_\sigma),U_\sigma(B_\sigma),U_\sigma(E_\sigma)\) and the
   image of \(\mathsf{seq}\) with the actual occurrence-indexed QDM packets
   and exact comparison.

No field says that the boundary vanishes or that the top image is
transported.  Those are outputs.  Including either as an input would merely
rename the missing theorem.

Exactness and \(N\)-compatibility in item 6 are load-bearing.  Fullness is
not: the proof only transports a boundary already constructed in
\(\mathcal H_\sigma\).  Faithfulness or conservativity is useful when
nonvanishing is established upstairs, but is not needed if the actual source
and endpoint modules are supplied by the displayed isomorphisms.

## 27.4 Realization transfer

### Theorem 27.1 -- a typed provider transports the power image

Every term of

\[
\mathsf{Provider}(\mathsf{sub},\sigma,m)
\]

canonically determines

\[
\operatorname{Top}_m
  (U_\sigma B_\sigma)
\xrightarrow{\sim}
\operatorname{Top}_m
  (U_\sigma A_\sigma).
\tag{27.8}
\]

For orientation \(\mathsf{quot}\), the analogous conclusion holds when the
second orthogonality direction in the record is supplied.

#### Proof

For \(o=\mathsf{sub}\), the snake boundary is a morphism

\[
\ker N_{A_\sigma}^m\longrightarrow E_\sigma
\]

between the two Hom-orthogonal components.  It is zero by items 4--5.
Theorem 26.1 gives

\[
\operatorname{Top}_m(B_\sigma)
\xrightarrow{\sim}
\operatorname{Top}_m(A_\sigma)
\]

in \(\mathcal H_\sigma\).  The exact \(N\)-compatible functor \(U_\sigma\)
preserves images and the displayed isomorphism, giving (27.8).  The other
orientation uses the second line of (27.5).  \(\square\)

The proof is summarized by the commutative diagram

\[
\begin{CD}
\ker N_{A_\sigma}^m @>{0=\tau^{\mathrm{op}}_{\sigma,m}}>>
E_\sigma\\
@V{U_\sigma}VV @VV{U_\sigma}V\\
\ker N_{U_\sigma A_\sigma}^m
@>{0}>>
U_\sigma E_\sigma .
\end{CD}
\tag{27.9}
\]

The vertical maps include the exactness and \(N\)-compatibility
identifications.  Merely attaching component labels after forgetting to
\(K[N]\)-modules does not construct this square.

### Corollary 27.1A -- no additional ExactTop source augmentation

For the endpoint consumer, the source fields

\[
(\chi,N,N^{m+1}=0,N^mV\ne0)
\tag{27.10}
\]

and diagonal-product compatibility are sufficient.  Orientation,
component membership, and realization are provider indices; they are not a
new point/Gamma augmentation of the source.

The rank-row route remains different because its row is itself the retained
quotient.

## 27.5 Indexed State and Reader, used literally

The immutable Reader environment is

\[
\mathsf{Env}_\sigma
=(\sigma,\mathcal H_\sigma,U_\sigma,N_\sigma,\chi,m).
\tag{27.11}
\]

Let \(\Gamma\) collect the path-wide Reader data.  A local provider step is
indexed by its exact endpoints:

\[
\mathsf{LocalStep}(\Gamma;s,t;m)
:=
\sum_{o:\mathbf{Or}}
\sum_{\sigma:\mathbf{Occ}_\Gamma(s,t)}
\mathsf{Provider}(o,\sigma,m)
\times\mathsf{EndpointId}(o;s,t,\sigma).
\tag{27.12}
\]

A pair of local records does not canonically produce a provider for one
composite occurrence.  Instead form the free endpoint-indexed path:

\[
\frac{}{\mathsf{id}_s:\mathsf{TypedPath}(\Gamma;s,s;m)}
\qquad
\frac{
 \ell:\mathsf{LocalStep}(\Gamma;s,t;m)
 \quad
 p:\mathsf{TypedPath}(\Gamma;t,u;m)}
 {\ell;p:\mathsf{TypedPath}(\Gamma;s,u;m)}.
\tag{27.12a}
\]

Only the interpreted retained isomorphisms compose.  Changing \(\Gamma\) or
\(m\) requires an explicit lawful reindexing.  The present interpreter is
fixed to the ExactTop shadow.  A future general retention index would need
an actual family \(\mathsf{Retained}_r\) and eliminators exposing only that
family; a phantom parameter would enforce no non-smuggling law.  The
rank-row route is a separate interpreter which genuinely retains its
point/Gamma row.

A path map

\[
f:\sigma\to\tau
\]

must therefore carry explicit reindexing evidence for exact sequences,
component membership, \(N\), and the actual QDM realization.  Calling two
specialized packets equal is not a substitute for this map.

When these reindexing functors and their composition laws are supplied, the
family \(\sigma\mapsto\mathcal H_\sigma\) forms a fibration over
\(\mathbf{Occ}\).  A coherent provider is a section along the chosen
weak-factorization path.  A provider on every path additionally requires
functorial reindexing and Beck--Chevalley coherence.  One contradiction path
needs only one such section.

For a chosen path

\[
P=(\sigma_1\to\cdots\to\sigma_r),
\]

a **coherent provider section** is a term of
\(\mathsf{TypedPath}(\Gamma;s,t;m)\): its local provider records are joined
by lawful reindexing maps and orientation-sensitive endpoint
identifications.  These identifications, not a shared erased label, make
the interpreted local top-image isomorphisms composable.

### Theorem 27.2 -- dependent telescope

A coherent provider section along \(P\) determines a canonical composite
isomorphism between the retained top image at the initial and final
endpoints.

#### Proof

Apply Theorem 27.1 at each occurrence, reindex its output along the
specified endpoint identification, and compose.  Every adjacent source and
target agrees by the section data.  \(\square\)

The Writer output is the actual leakage morphism in the dependent Hom type
(27.5), not a scalar detached from its source and target.  The zero test is
lawful only after those indices are retained.

## 27.6 What the two mindsets contribute

### Kmett-flavored pass

1. Determine variance before naming an abstraction.
2. Promote every datum changed by reindexing to an index.
3. Treat forgetting as a named functor and demand the commutative square it
   must preserve.
4. Make composition consume matching endpoint indices.
5. Derive the smallest lawful consumer only after the rich provider has
   been typed.

This pass produces (27.4)--(27.5), the occurrence fibration, and the
realization square.

### Oleg-flavored pass

1. Keep the trusted kernel to four independent geometric constructors:
   exact sequence, exponent, component typing, and realization.
2. Give each missing constructor a hostile model.
3. Distinguish evidence which computes the conclusion from a Boolean which
   merely asserts it.
4. Do not allow an associated graded, special fibre, or forgotten packet to
   inhabit the type of the actual occurrence.
5. Normalize the proof to one elimination step: the boundary belongs to a
   zero Hom type.

This pass keeps Theorem 27.1 noncircular and exposes the exact geometric
work.

## 27.7 Hostile type-erasure table

| erased index or law | ill-typed step that becomes possible | mathematical countermodel |
|---|---|---|
| orientation | use ambient-to-exceptional Hom vanishing on \(E\to\operatorname{coker}N_A^m\) | the two Module 25 boundary formulas |
| occurrence \(\sigma\) | use an intrinsic center bound after a specialization changes the packet | occurrence-indexed \(J_{m+1}\) hostile model |
| kernel stability | infer Hom zero for \(\ker N_A^m\) from Hom zero for \(A\) | Module 26 rank-one quiver boundary |
| actual exponent | replace \(E\) by annihilated graded pieces | \(J_{m+1}\) filtered by \(J_m,J_1\) |
| exact \(N\)-compatible realization | add component labels which do not control the actual QDM boundary | constant/associated-graded receiver |
| path endpoint | compose transports with mismatched specializations | torsor holonomy around a cycle |
| flat or strict base change | promote a special-fibre image computation | \(N(e_2)=s e_1\) specialization |

This table is the practical value of dependent typing: each earlier
hypothesis-smuggling error corresponds to erasing one index or one structure
map.

## 27.8 Exact remaining theorem

The typed crux for \(m=2\) is now:

\[
p_P:\mathsf{TypedPath}(\Gamma;s_P,t_P;2),
\qquad
|p_P|=P
\tag{27.13}
\]

The source supplies its nonzero \(\operatorname{Top}_2\) line without
another augmentation.  Theorems 27.1--27.2 then supply transport.  The
unresolved fields are the exact oriented QDM realization,
component/kernel typing, endpoint reindexing, and the actual \(N^2E=0\)
carrier theorem.

## 27.9 Mystery ledger

| question | status | exact answer or gate |
|---|---|---|
| Can dependent types prove the geometric provider exists? | **settled: no** | they expose, but do not inhabit, the missing fields |
| Do we need another ExactTop source augmentation? | **settled: no** | Corollary 27.1A |
| Is faithfulness of \(U_\sigma\) load-bearing? | **settled: no for forward transport** | exact \(N\)-compatibility plus actual packet identifications suffice |
| Is exactness of \(U_\sigma\) load-bearing? | **settled: yes** | otherwise images and the snake boundary need not be preserved |
| Can labels be added after the QDM calculation? | **settled: no** | item 6 and diagram (27.9) require an independently constructed realization |
| Is global path coherence needed for one contradiction? | **settled: no** | one indexed section along one chosen path suffices |
| What geometric field remains highest EV? | **open** | construct the exact oriented QDM realization; it simultaneously certifies the typing |

## Boundary

The orientation family, minimal provider record, realization-transfer
theorem, and indexed path law are mathematical design results.  They neither
formalize nor prove the missing QDM heart, carrier exponent, or comparison.
No manuscript or Lean source is edited, and no unconditional \(m=2\) or
stable-irrationality claim is made.
