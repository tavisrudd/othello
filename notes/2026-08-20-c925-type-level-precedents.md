# C925 -- solved precedents for type-level provider safety

**Lane:** cubic-threefolds

**Status:** primary-source precedent audit complete; two imports promoted to
Module 27

## Outcome

There are mature examples in which types genuinely eliminate the same
*shape* of error now appearing in the QDM provider:

- composing transitions whose intermediate states do not match;
- reusing evidence in the wrong occurrence environment;
- reversing a covariant/contravariant interface;
- reading data not declared by a sparse consumer; and
- treating an arbitrary path conversion as a lawful reindexing.

They do not prove the missing geometric QDM witness.  Their exact value is
to make a global proof compositional once local geometric certificates have
been constructed.

The two highest-EV imports are:

1. source/target-indexed provider arrows; and
2. occurrence-indexed environments with explicit lawful reindexing.

Together they motivate the coherent-section correction in Theorem 27.2.

## 1. Parameterized computations

Atkey replaces a computation type depending on one state by one depending
on its initial and final states.  Composition exists only when the
intermediate indices agree.  The paper gives categorical semantics and
typed calculi for this parameterized structure.

Primary source:
[Atkey, *Parameterised notions of computation*](https://doi.org/10.1017/S095679680900728X).

The QDM import is

\[
\mathsf{Step}(r,\Gamma;s,t;m),
\tag{P.1}
\]

where:

- \(r\) is the declared retained shadow;
- \(\Gamma\) is the fixed occurrence/path environment;
- \(s,t\) are the exact source and target states; and
- \(m\) is the leakage threshold.

Composition has only the matching form

\[
\mathsf{Step}(r,\Gamma;s,t;m)
\times
\mathsf{Step}(r,\Gamma;t,u;m)
\longrightarrow
\mathsf{Step}(r,\Gamma;s,u;m).
\tag{P.2}
\]

This eliminates composition across merely similar, but differently
specialized, intermediate packets.  The index shape alone does not
construct the arrow or its composition law: Atkey's structure includes the
indexed bind.  Our safe import below is the free typed path on independently
constructed local QDM providers.

## 2. Hoare-style proof-carrying transitions

Hoare Type Theory places preconditions and postconditions in the type of a
stateful computation and proves modular composition laws, including
framing/separation principles.

Primary source:
[Nanevski--Morrisett--Birkedal, *Hoare Type Theory, Polymorphism and
Separation*](https://doi.org/10.1017/S0956796808006953).

For C925, a local step should carry proof-relevant preconditions:

\[
\text{same coefficient spine, actual occurrence, exact orientation,
kernel-stable component, actual exponent},
\]

and establish:

\[
\text{the typed endpoint plus the induced }\operatorname{Top}_m
\text{ isomorphism}.
\]

This prevents an unproved provider field from being represented as a
Boolean flag.  The local geometric proof is still an input.

## 3. Context- and scope-safe evidence

Allais--Atkey--Chapman--McBride--McKinna index terms, variables,
environments, renamings, and substitutions by their exact contexts.  Their
generic operations and proofs preserve scope by construction.

Primary sources:
[arXiv:2001.11001](https://arxiv.org/abs/2001.11001),
[journal DOI](https://doi.org/10.1017/S0956796820000076).

The direct QDM analogue is a fresh occurrence index

\[
\sigma=(Z,\chi,j,\rho,p).
\]

A center theorem at \(\sigma\) cannot discharge the obligation at
\(\sigma'\) without an explicit equality or reindexing map.  This is the
closest solved precedent for the specialization-smuggling problem in
Modules 24--27.

The limitation is exact: a well-scoped reindexing term still needs a
geometric construction and proof of its laws.

## 4. Functorial reindexing and data migration

Spivak models schemas as categories and instances as functors.  A schema
functor induces canonical restriction and Kan-extension migrations, so
projection, join, and reindexing have explicit functorial semantics.

Primary sources:
[arXiv:1009.1166](https://arxiv.org/abs/1009.1166),
[journal DOI](https://doi.org/10.1016/j.ic.2012.05.001).

The import is not a claim that a QDM comparison is a database migration.  It
is the law:

\[
F:\Gamma\to\Delta
\]

must induce an actual reindexing functor and naturality/Beck--Chevalley cell
before evidence may move from \(\Gamma\) to \(\Delta\).  A bare path-mapping
function is insufficient.

Nothing in the abstract Kan-extension formalism proves the required QDM
base-change square.

## 5. Variance-safe optics

Profunctor optics give a uniform compositional representation of
heterogeneous access/update interfaces while exposing their covariant and
contravariant positions.

Primary sources:
[Pickering--Gibbons--Wu, *Profunctor Optics: Modular Data
Accessors*](https://arxiv.org/abs/1703.10857),
[journal DOI](https://doi.org/10.22152/programming-journal.org/2017/1/7).

The C925 import is already visible in (27.5): orientation changes the source
and target of the leakage Hom.  A proof of

\[
\operatorname{Hom}(\text{ambient},\text{exceptional})=0
\]

cannot inhabit the reversed boundary type.  This is a variance discipline,
not evidence that the common geometric source or optic exists.

## 6. Explicit capability rows

Kiselyov--Sabry--Swords use type-indexed open unions so the available
effects/capabilities are explicit and handlers remove or reinterpret them
modularly.

Primary sources:
[Kiselyov--Sabry--Swords, *Extensible Effects: An Alternative to Monad
Transformers*](https://doi.org/10.1145/2503778.2503791),
[author PDF](https://legacy.cs.indiana.edu/~sabry/papers/exteff.pdf).

Without importing their implementation technique, the useful mindset is to
index a consumer by the retained capability set:

\[
r=\{\text{character},N,\operatorname{Top}_m\}.
\tag{P.3}
\]

The occurrence remains in the Reader environment \(\Gamma\).  A consumer
given only \(r\) cannot lawfully inspect a Gamma row or full Stokes matrix.
Capability membership records availability, not truth; each geometric
certificate still needs proof.

## 7. Parametric non-smuggling

Relational parametricity derives uniformity laws for genuinely polymorphic
programs.

Primary source:
[Wadler, *Theorems for free!*](https://doi.org/10.1145/99370.99404).

The semantic QDM analogue is:

> a consumer natural in the hidden rich provider and exposed only to a
> declared shadow cannot distinguish two providers with the same shadow.

Modules 20 and 23 already prove algebraic versions through sufficient
shadow quotients.  The precedent explains why the retention interface must
be an abstraction boundary rather than prose.  Casts, reflection, or an
imported theorem which already names hidden data would invalidate the
argument.

## 8. Faithful realizations and reconstruction

Deligne--Milne show, under rigid abelian tensor hypotheses, that exact tensor
realizations have strong faithfulness and reconstruction properties.

Primary source:
[Deligne--Milne, *Tannakian
Categories*](https://www.math.columbia.edu/~dejong/tannakian/Deligne-Milne-Tannakian-Categories.pdf).

This is a useful boundary comparison, not a hypothesis imported into C925.
Theorem 27.1 needs only an exact \(N\)-compatible realization carrying the
displayed sequence to the actual QDM sequence.  Exact faithfulness would
permit stronger reflection back upstairs, but requiring it now would
overstate the endpoint proof's needs and rename a major geometric theorem.

## Promoted interface

Let \(\Gamma\) be the immutable Reader environment.  The oriented local
generator around the record (27.6) is

\[
\mathsf{LocalStep}(\Gamma;s,t;m)
:=
\sum_{o:\mathbf{Or}}
\sum_{\sigma:\mathbf{Occ}_\Gamma(s,t)}
\mathsf{Provider}(o,\sigma,m)
\times\mathsf{EndpointId}(o;s,t,\sigma).
\tag{P.4}
\]

Two local generators do not produce a provider for a fictitious composite
occurrence.  Instead take the free endpoint-indexed category

\[
\mathsf{TypedPath}(\Gamma;s,t;m)
:=
\mathsf{FreeCat}(\mathsf{LocalStep})(s,t).
\tag{P.5}
\]

Theorem 27.2 interprets this typed path into the composite
\(\operatorname{Top}_m\)-isomorphism.  Changing \(\Gamma\) or \(m\) requires
an explicit reindexing morphism with its coherence evidence.

The current interpreter is fixed to the ExactTop retention

\[
r=\{\chi,N,\operatorname{Top}_m\}.
\]

The occurrence \(\sigma\) remains in \(\Gamma\).  A genuinely general
retention parameter would require a family \(\mathsf{Retained}_r\) and
eliminators exposing only that family; a phantom \(r\) proves nothing.  The
rank-row route is a separate interpreter which additionally retains the
point/Gamma row.  This is the precise sense in which the latter uses another
augmentation and the former does not.

## The resulting no-smuggling theorem

Theorem 27.2 is the mathematical core:

> a coherent path of locally certified provider arrows, with matching typed
> endpoints and lawful occurrence reindexing, yields the composite retained
> top-image isomorphism.

The occurrence-indexed path adds the design theorem:

> evidence attached to occurrence \(\sigma\) cannot enter a proof at
> \(\sigma'\) unless the interface contains a lawful reindexing witness.

The separate claim that a consumer can use only data named by \(r\) becomes
a literal theorem only relative to a specified typed syntax or semantic
abstraction boundary.  The present wrapper does not implement that
abstraction.  In this mathematics-only packet it is a rigor discipline,
while Modules 20 and 23 provide the corresponding categorical quotient
theorems.

## Mystery ledger

| question | status | evidence or remaining gate |
|---|---|---|
| Are there solved precedents for typed pre/post composition? | **settled: yes** | Atkey and Hoare Type Theory |
| Are there solved precedents for occurrence-safe evidence? | **settled: yes** | context- and scope-safe syntax |
| Is an arbitrary path map enough? | **settled: no** | functorial migration requires explicit naturality/coherence |
| Can types stop a sparse consumer reading hidden data? | **conditionally yes** | genuine capability/parametric abstraction is required |
| Do these precedents prove a QDM provider exists? | **settled: no** | all require local evidence terms |
| Which imports are promoted? | **settled** | source/target provider arrows and occurrence-safe reindexing |

## Boundary

This audit identifies and imports solved type-level composition disciplines.
It does not import tagless-final machinery, start a formalization, or add a
geometric hypothesis.  The exact oriented QDM realization, endpoint
reindexing, and actual exceptional exponent remain open.  No manuscript or
Lean source is edited.
