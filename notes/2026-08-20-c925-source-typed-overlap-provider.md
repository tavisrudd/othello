# Module 55. Source-typed overlap providers

**Packet part:** Module 55. Stable index:
`notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md`

**Status:** the source interface below is a proved type-level packaging of
Modules 53--54.  A concrete Haskell GADT replay compiles and runs.  The
interface makes variable, occurrence, phase, normalization, direction, and
row-reader mismatches unrepresentable by the consumer.  It does not create
the geometric witnesses required by either source constructor.

## 55.1 Put the distinction at the producer boundary

The current local theorem has two independent analytic routes.  Module 56
also gives a trusted way to construct the first route from two compatible
one-wall factors:

1. a pre-Laplace \(\lambda\)-line receiver with a vanishing projected Stokes
   variation; or
2. a resonance-parameter trait whose **normalized** marked coimage is an
   intermediate extension and has an exact closed-packet reader.

They must not be represented by one record with optional fields.  The two
middle-extension variables are different, and a nonresonant GKZ object is
not an integral-trait object.  Use the following indices:

\[
 \begin{aligned}
 o&:\mathsf{Occurrence},& s&:\mathsf{Side},\\
 \gamma&:\mathsf{BasedLoop},& \chi&:\mathsf{PhaseCharacter},\\
 \epsilon&:\mathsf{Direction},& r&:\mathsf{Resonance},\\
 n&:\mathsf{Normalization},& d&:\mathsf{VanishingOrder}.
 \end{aligned}                                                   \tag{55.1}
\]

The actual endpoint packet type is

\[
                 \mathsf{Packet}(o,s,\gamma,\chi).              \tag{55.2}
\]

An endpoint package can be constructed only from left and right packets
with the same \((o,\gamma,\chi)\), two row-fidelity witnesses, and a lawful
reindexing witness:

\[
 \frac{
  P_-:\mathsf{Packet}(o,-,\gamma,\chi)\quad
  P_+:\mathsf{Packet}(o,+,\gamma,\chi)\quad
  R_-\quad R_+\quad I
 }{
  \mathsf{Endpoints}(o,\gamma,\chi)}.                            \tag{55.3}
\]

Thus a later theorem cannot quietly change occurrence, loop, deck
character, row, or adjacent reindexing.

## 55.2 Two closed source constructors

The projected route has its own nominal source type:

\[
\begin{aligned}
\mathsf{ProjectedSource}(o,\gamma,\chi):={}&
  \mathsf{LambdaReceiver}(o,\gamma,\chi)\\
 &\times\mathsf{LambdaPacketRowRealization}(o,-,\gamma,\chi)\\
 &\times\mathsf{LambdaPacketRowRealization}(o,+,\gamma,\chi)\\
 &\times\mathsf{Direction}(\epsilon)\\
 &\times\mathsf{ProjectedVariationZero}(o,\gamma,\chi,\epsilon).
                                                                    \tag{55.4}
\end{aligned}
\]

The trait route deliberately uses different types:

\[
\begin{aligned}
\mathsf{TraitSource}(o,\gamma,\chi):={}&
 \mathsf{TraitMiddleExtension}(o,\gamma,\chi,\mathsf{Integral})\\
 &\times\mathsf{CoimageComparison}
      (o,\gamma,\chi,\mathsf{Residual},d)\\
 &\times\mathsf{ExactClosedPacketRowReader}(o,\gamma,\chi).     \tag{55.5}
\end{aligned}
\]

There is no coercion

\[
 \mathsf{LambdaReceiver}\longrightarrow\mathsf{TraitMiddleExtension},
 \qquad
 \mathsf{GkzSource}(\mathsf{Nonresonant})
     \longrightarrow
 \mathsf{TraitMiddleExtension}(\mathsf{Integral}).              \tag{55.6}
\]

Likewise the trait constructor accepts a residual comparison, not a raw
one.  The sole smart constructor

\[
 \mathsf{normalizeCoimage}:
 \mathsf{ConormalFactor}(d)
 \to\mathsf{CoimageComparison}(\mathsf{Raw},d)
 \to\mathsf{CoimageComparison}(\mathsf{Residual},d)             \tag{55.7}
\]

can be called only when the factor and raw comparison have the same
vanishing-order index, and it retains only the residual unit.
This prevents the raw \(s:R\to R\) map from masquerading as a closed-fibre
isomorphism.

Finally define the closed sum type

\[
\begin{aligned}
\mathsf{SafeOverlap}(o,\gamma,\chi)
 :={}&\mathsf{ByProjectedVariation}
       (\mathsf{Endpoints},\mathsf{ProjectedSource})\\
 &\mid\mathsf{ByTraitMiddleExtension}
       (\mathsf{Endpoints},\mathsf{TraitSource}).                \tag{55.8}
\end{aligned}
\]

The telescope is given only the eliminator

\[
       \mathsf{consumeSafeOverlap}:
       \mathsf{SafeOverlap}(o,\gamma,\chi)
       \longrightarrow\mathsf{RowTransition}(o,\gamma,\chi).    \tag{55.9}
\]

It never receives a bare Stokes matrix, a bare generic comparison, or an
untyped closed-fibre map.

### Theorem 55.1 -- source safety

Any value of \(\mathsf{SafeOverlap}(o,\gamma,\chi)\) contains exactly the
source evidence needed to invoke one of the two local row theorems:

- the first constructor instantiates Proposition 54.1 in the named
  direction and with the actual row-faithful endpoint realizations;
- the second instantiates Proposition 54.2 and Corollary 54.2A with an
  integral trait, a normalized coimage map, and an exact actual-packet
  reader.

Therefore (55.9) cannot be invoked on a source in which the analytic
variable, resonance status, normalization, occurrence, loop, character,
row, reindexing, or direction is absent or mismatched.

#### Proof

Eliminate the closed GADT (55.8).  In the first branch its constructor fields
are precisely the hypotheses of Proposition 54.1 together with the endpoint
typing of Module 34.  In the second branch the constructor fields are the
hypotheses of Proposition 54.2 and its exact-reader corollary.  No third
constructor exists.  All indices in the conclusion are inherited from the
single endpoint package.  \(\square\)

## 55.3 What becomes unrepresentable

With constructors kept private to their source adapters, none of the
following terms type-check:

1. using Sabbah's \(\lambda\)-line middle extension as the resonance trait;
2. passing the nonresonant Spenko--Van den Bergh GKZ source at the integral
   parameter;
3. passing a raw conormal map where a residual unit is required;
4. normalizing with a conormal factor of the wrong vanishing order;
5. comparing packets from different overlap occurrences;
6. comparing different based loops or deck characters without a typed
   reindexing;
7. reversing an edge without changing the direction index;
8. consuming a generic packet without an actual closed-packet row reader;
9. constructing a safe overlap from an unproved full-block slogan such as
   “good formal structure”.

The implementation should expose smart constructors only from theorems
which prove the corresponding witnesses.  Exporting
\(\mathsf{ProjectedVariationZero}\) or
\(\mathsf{ExactClosedPacketRowReader}\) as freely callable constructors
would defeat
the design.

This is a concrete indexed GADT interface, not a tagless-final encoding.
The source alternatives are visible in the data type and the consumer is an
ordinary total eliminator.

## 55.4 What types cannot do

Types make hypothesis smuggling harder; they do not prove the hypotheses.
The open mathematical work is still to implement at least one trusted source
adapter:

\[
\begin{aligned}
&\mathsf{projectedAdapter}_{11}:
   \mathsf{GeometricOccurrence}_{11}
     \to\mathsf{ProjectedSource}_{11},                          \tag{55.10}\\
\text{or}\qquad
&\mathsf{traitAdapter}_{11}:
   \mathsf{GeometricOccurrence}_{11}
     \to\mathsf{TraitSource}_{11}.                              \tag{55.11}
\end{aligned}
\]

Constructing either map is exactly the analytic theorem.  An implementation
which postulates its output, chooses a lattice after seeing the closed fibre,
or defines the row reader by the desired equality is circular even though it
type-checks.

The right trust boundary is therefore:

\[
 \boxed{\text{source papers and new geometry build the witnesses}}
 \quad\longrightarrow\quad
 \boxed{\mathsf{SafeOverlap}}
 \quad\longrightarrow\quad
 \boxed{\text{generic telescope}}.                              \tag{55.12}
\]

All downstream composition is then formal and cannot reopen the local
analytic assumptions.

Module 56 refines the first producer without adding a third consumer branch.
Its private smart constructor has the shape

\[
 \mathsf{doubleNormal}_{i\to j}:
   \mathsf{CommonRawRow}
   \to\mathsf{CanVarFactor}_i(\mathsf{Positive})
   \to\mathsf{CanVarFactor}_j(\mathsf{Positive})
   \to\mathsf{ExactClosedCanVarReader}_{i\to j}
   \to\mathsf{ProjectedVariationZero}_{i\to j}.               \tag{55.13}
\]

The two factors carry the same occurrence, receiver, raw-row, loop, and
character indices.  Their hidden constructors contain both one-wall row
equations in (56.4).  Thus (55.13) cannot be filled by two unrelated
one-arrow theorems or by a labelled but unidentified Thom operator.

## 55.5 Compile-checked toy

The concrete replay is

`notes/cubic-threefolds-tasks/c925-source-typed-overlap-toy.hs`.

It constructs:

- one projected provider with a direction-indexed zero-variation witness;
- one integral-trait provider obtained only after normalizing a raw
  order-one conormal comparison; and
- the common safe-overlap eliminator.

The file also records five representative rejected expressions.  They are
left as comments because uncommenting any one makes the program fail to
type-check.  The executable output checks the two lawful constructors, their
shared endpoint index, and the existence of mismatched loop, character,
direction, and nonresonant indices which cannot fill the safe constructor.
It remains a typing replay, not a proof of a QDM provider.

## 55.6 EJ/TT and mystery ledger

**EJ.** The best upstream abstraction is not a richer universal receiver.  It
is a smaller closed source sum: exactly two ways to manufacture a safe row
edge, with all variable changes and normalizations visible in their result
types.  This lets later all-\(m\) work reuse the telescope without inheriting
the analytic implementation.

**TT.** Phantom indices alone prove nothing.  The useful guarantee comes from
closed constructors, occurrence-indexed actual-packet fields, and trusted
smart constructors for the proof witnesses.  Also, source types should
encode the variable itself, not merely attach a string tag saying “middle
extension”.

| question | status | exact evidence or remaining gate |
|---|---|---|
| Can the \(\lambda\)-line and resonance trait be confused downstream? | **no** | distinct nominal source types in (55.4)--(55.6) |
| Can a raw conormal zero be consumed as an isomorphism? | **no** | normalization index and smart constructor (55.7) |
| Can occurrences, loops, or characters be silently changed? | **no** | endpoint indices (55.2)--(55.3) |
| Does every safe provider yield the row transition? | **yes** | Theorem 55.1 |
| Do the types prove either geometric source adapter exists? | **no** | (55.10)--(55.11) are the remaining theorems |
| Which source adapter is currently highest EV? | **the Module 56 exact can/var reader** | the projected covector then follows formally from two one-wall divided-rank laws |

## Boundary

The consumer can now be written so that every known illegal source state is
unrepresentable: wrong analytic variable, wrong resonance, wrong
normalization, wrong occurrence, wrong phase path, missing row fidelity, and
missing direction all fail before the telescope is called.  This is a real
architectural gain, not a geometric proof.  The open theorem is concentrated
upstream in the smart constructor for either (55.10) or (55.11).  Module 56
proves the algebra used by the most economical implementation of (55.10).
