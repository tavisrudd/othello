# C906 — exceptional-tower judo after the classical fold

Date: 2026-08-10  
Status: theorem packet proved at the finite-carrier level; novelty remains gated  
Scope: research note only; no manuscript or Lean changes

## Executive verdict

The unmarked `E_6 -> E_7 -> E_8 -> E_9 -> E_10` residue/fold tower is not a
new theorem.  Brouwer--Van Maldeghem, Proposition 3.6.1, after
Brouwer--Shult, gives the relevant quadratic-graph rank descent in general
rank.  The `E_8 -> 56 -> 28 -> 27` bottom is also classical by name: the
`E_8` root-pair graph, Gosset graph, its antipodal quotient, and the Schlaefli
graph.  The binary code maps are a thin evaluation-code translation and must
not be sold as a crown.

What the classical account does **not** package, and what survives as our
best judo, is an exact composition theorem with a sparse Clebsch entry:

1. the marked projective/operator data of Papers I--III and V selects an
   oriented golden double-six on the `27`-line `E_6` carrier;
2. the tritangent-support kernel forgets that golden marking but reconstructs
   the entire bare `E_6` line/tritangent geometry from its minimum shell;
3. after retaining a residue flag, the classical tower is exactly reversible
   through `E_10`;
4. after forgetting the flag it is not canonically reversible, and the exact
   labelled fibres are computable;
5. the bottom loss is already large: `432` golden markings, `864` full
   ordered operator/apolar markings, or `1728` full Paper-V gateway markings
   lie over one bare `E_6` carrier.

Thus the worthwhile statement is not “there is an exceptional tower.”  It is:

> A sparse Clebsch shadow gives a canonical **entry into a marked classical
> residue tower**; the marked maps are bidirectional, while the unmarked maps
> have explicit homogeneous fibres measuring exactly the golden and residue
> data that were forgotten.

This exact composition was not located in the bounded audit below.  That is
not an absence proof.  It is a candidate framing, not yet a manuscript-bound
novelty claim.

## 1. Keep the two `E_8` carriers separate

There are two different objects called `E_8` in the working notes.

- **McKay/operator carrier (C705):** the characteristic-zero affine-`E_8`
  McKay operator package attached to the binary icosahedral representation,
  with six outer axes, a tensor `Z`, and the Segre/Igusa null projections.
- **Quadratic/root-pair carrier (C865/C870):** the `120` nonsingular vectors of
  an eight-dimensional plus quadratic space over `F_2`, equivalently `E_8`
  root pairs, carrying the affine evaluation code `[120,9,56]`.

No direct map or tensor identification between these two `E_8` objects has
been proved.  Their justified meeting point is lower:

```text
full marked Clebsch projective/operator package
      |  C682: harmonic/transvectant construction
      v
oriented operator/apolar double-six
      |  C695: canonical completion
      v
27 lines + 45 tritangents + Cartan support on E6
      |  binary support kernel
      v
C6 = [27,6,12]  <->  bare Schlaefli line/tritangent geometry
      |  marked quadratic suspension / residue
      v
E7, E8, E9, E10 quadratic evaluation carriers
```

Paper IV does not currently enter this diagram.  Its reconstruction of the
marked `PG(2,13)` from minimum-word pair data is a separate gateway theorem.

## 2. Exact bottom interface

### Theorem C906-A — the bare `E_6` code is an exact line-geometry carrier

Let `T` be the `45 x 27` binary incidence matrix of the tritangent planes
against the `27` lines on a smooth cubic surface, and put

`C_6 = ker_F2(T)`.

For the Clebsch/Schlaefli configuration:

1. `C_6` has parameters `[27,6,12]` and weight enumerator
   `1 + 36 z^12 + 27 z^16`;
2. its `36` minimum supports are exactly the `36` double-sixes;
3. two coordinates lie together in `8` minimum supports exactly when the
   corresponding lines meet, and in `6` exactly when they are skew;
4. the `45` tritangents are exactly the triangles in the recovered line
   intersection graph;
5. the minimum shell spans `C_6`.

Consequently the bare code and the bare `27`-line/tritangent incidence
geometry reconstruct one another up to isomorphism.

**Proof/evidence.**  C682 gives the human dictionary.  The exact certificate
`notes/2026-08-04-c682-e6-e8-code-ladder.py --check` exhausts the `64`
codewords, identifies all `36` minimum supports with double-sixes, computes
the pair counts `6/8`, recovers the triangles, and checks spanning.  No claim
about golden markings or signed Cartan coefficients is included.

### Corollary C906-A1 — automorphisms

Every coordinate permutation of `C_6` preserves the minimum-shell pair
counts and hence the Schlaefli incidence.  Conversely every line-incidence
automorphism preserves the tritangent kernel.  Therefore

`Aut(C_6) = Aut(Schlaefli geometry) = W(E_6)`, of order `51840`.

This equality is at the permutation-carrier level.  It does not recover a
particular integral root lattice, a sign choice for roots, or Cartan cubic
coefficients.

## 3. Exact golden fibres over the bare `E_6` carrier

### Theorem C906-B — bottom marking ledger

Fix one labelled bare `E_6` line configuration.  Its relevant marking sets are
homogeneous `W(E_6)`-sets with the following stabilizers and sizes.

| retained bottom data | stabilizer | labelled fibre |
|---|---:|---:|
| unordered double-six | `S_6 x C_2` | `51840/1440 = 36` |
| unordered double-six + chosen unoriented golden axis | `S_5 x C_2` | `216` |
| unordered double-six + oriented golden axis | `A_5 x C_2` | `432` |
| ordered double-six + oriented golden axis | `A_5` | `864` |
| preceding full operator/apolar data + selected Paper-V chordal companion | subgroup of index `2` in `A_5`-stabilized gateway | `1728` |

Here the first `C_2` exchanges the two rows of the double-six.  The six golden
axis lines form the natural six-point `S_6` orbit; the stabilizer of an
unoriented one is `S_5`, and choosing its icosahedral orientation cuts this to
`A_5`.  Ordering the two rows removes the commuting row-exchange `C_2`.
The final factor `2` is the Paper-V gateway fibre proved in C905: the
conference source alone does not select one of its two chordal companions,
and the surviving involution exchanges them.

These are homogeneous fibres, **not torsors**: stabilizers remain.  The table
also proves the sharp negative statement that the bare binary `E_6` code
cannot intrinsically select the golden Clebsch input.  Any such selection
would be a fixed point for `W(E_6)`, whereas each displayed nontrivial orbit is
transitive.

### What is genuinely composed here

Classical cubic-surface theory knows the `27` lines and double-sixes.
Classical exceptional-graph theory knows the residue tower.  The Papers I--V
work supplies a different ingredient: a sparse projective/operator shadow
canonically selects one **oriented** member of the `432`-element golden orbit,
then the operator/apolar construction selects the ordered lift.  The exact
orbit ledger is the interface between those two classical bodies of work.

That is the primary “what classical missed” candidate.  It must be presented
as an exact composition and information-loss theorem, not as discovery of
either classical endpoint.

## 4. Marked residue tower

### Definitions

For a quadratic form `q`, write `B_q(x,y)=q(x)+q(y)+q(x+y)`.

- Let `W_6` be a six-dimensional minus quadratic space over `F_2`.
  Its singular set, including zero, has `28` elements; the `27` nonzero ones
  carry `C_6` by evaluation of linear forms.
- Let `A=<a,b>` be an anisotropic plane:
  `q(a)=q(b)=B(a,b)=1`.
- A **residue flag** retains at every even level the chosen nonsingular point
  whose link is taken, and at the next step retains the chosen antipodal class
  used for shortening.  At the odd level, a level orientation is optional and
  is not part of the unoriented carrier below.

### Theorem C906-C — exact marked `E_6 -> E_8` suspension

Put `V_8=A orthogonal_sum W_6`.  It is plus type.  Mark `a`.  Among the `120`
nonsingular vectors of `V_8`, the `56` vectors `u` for which `a+u` is also
nonsingular form `28` antipodal pairs

`{ b+s, a+b+s }`, for `q(s)=0` in `W_6`.

The pair-constant subcode of the affine evaluation code `[120,9,56]`,
restricted to this link and folded over those pairs, is literally the affine
evaluation code `[28,7,12]` on the singular set of `W_6`.  Shortening at the
pair `s=0` is literally `C_6=[27,6,12]`.

**Proof.**  For `q(s)=0`, both displayed vectors have norm one and sum to
`a`.  Conversely any decomposition of `a` into two nonsingular vectors has a
unique displayed `s`.  A linear function on `A orthogonal_sum W_6` is constant
on each pair exactly when it vanishes on `a`; its common value is an affine
linear function of `s`.  All affine linear functions occur.  At `s=0`, a word
has zero coordinate exactly when its constant term is zero, leaving the six
linear evaluations on the other `27` points.

### Theorem C906-D — exact marked `E_8 -> E_10` suspension

Let `(X_8,Q)` be plus type and retain a nonsingular `t`.  Define

`q_t(x)=Q(x)+B_Q(t,x)`.

Then `q_t` is minus type and translation by `t` gives an exact bijection

`{x:q_t(x)=0} -> {y:Q(y)=1}`, `x |-> x+t`.

Suspend `(X_8,q_t)` by an anisotropic plane to a plus ten-space `V_10`, and
mark its vector `a`.  The affine evaluation code on the `496` nonsingular
vectors is `[496,11,240]`.  The link of `a` has `240` vectors and restriction
gives `[240,10,112]`, the `E_9` carrier.  Its `120` antipodal pairs are

`{ b+s, a+b+s }`, for `q_t(s)=0`.

The pair-constant subcode, folded over these pairs and transported by
`s |-> s+t`, is literally the original `[120,9,56]` `E_8` evaluation code.

**Proof.**  The translation identity is
`q_t(x)=Q(x+t)+Q(t)=Q(x+t)+1`.  The remaining statements repeat the proof of
C906-C in dimension eight.  The code dimensions follow because the affine
function restrictions have only the one link-hyperplane relation; the exact
weight distributions are independently exhausted by the verifier below.

### Corollary C906-D1 — marked bidirectionality

In the category whose objects retain the quadratic carrier and its nested
residue flag, C906-C and C906-D are mutually inverse up to isometry.  Thus a
marked `E_6` carrier has a canonical isomorphism class of suspensions through
`E_10`, and taking the marked link, antipodal quotient, and shortening returns
the original marked carrier.

This is “bidirectional” only in the marked category.  It is not a canonical
upward map on bare codes or bare graphs.

## 5. Exact forgotten-flag fibres

### Theorem C906-E — residue-choice counts

For a fixed labelled quadratic carrier, the nested residue flags returning to
`E_6` have the following cardinalities:

| top carrier | residue choices to `E_6` |
|---|---:|
| `E_6` | `1` |
| `E_7` | `28` |
| `E_8` | `120*28 = 3360` |
| `E_9` | `120*28 = 3360` |
| `E_10` | `496*120*28 = 1666560` |

At `E_9` the antipodal quotient is the `120`-point `E_8` carrier.  If one
also asks which of the two global levels is “first,” there is an additional
orientation `C_2`; it is deliberately excluded from the table.

Multiplying by the bottom fibres in C906-B gives:

| top | golden `432` | operator/apolar `864` | full Paper V `1728` |
|---|---:|---:|---:|
| `E_6` | `432` | `864` | `1728` |
| `E_7` | `12096` | `24192` | `48384` |
| `E_8` | `1451520` | `2903040` | `5806080` |
| `E_9` | `1451520` | `2903040` | `5806080` |
| `E_10` | `719953920` | `1439907840` | `2879815680` |

The products are labelled set-fibre counts.  They are not assertions of free
group actions.  In particular, root-pair quotients have inertia (the sign/root
reflection kernel), so torsor language would be wrong.

### Corollary C906-E1 — no intrinsic upward section

There is no automorphism-equivariant rule that chooses the first residue
point from a bare `E_7`, `E_8`, or `E_10` carrier.  Each automorphism group is
transitive on the relevant `28`, `120`, or `496` coordinates and has no fixed
point.  Therefore the lack of a bare inverse is a mathematical impossibility,
not merely an unproved upgrade.  What can be improved is the input: retain a
flag, or supply another sparse invariant that canonically singles one out.

## 6. Reproducibility record

The exact finite verifier is
`notes/2026-08-10-c906-marked-residue-tower.py`; its canonical transcript is
`notes/2026-08-10-c906-marked-residue-tower.out`.

Replay from `/home/tavis/src/othello`:

```sh
python3 -m py_compile notes/2026-08-10-c906-marked-residue-tower.py
diff -u notes/2026-08-10-c906-marked-residue-tower.out \
  <(python3 notes/2026-08-10-c906-marked-residue-tower.py)
python3 notes/2026-08-04-c682-e6-e8-code-ladder.py --check
```

Load-bearing conventions: deterministic enumeration of all vectors in
`F_2^6`, `F_2^8`, and `F_2^10`; an anisotropic plane has
`q(u,v)=u+uv+v`; the six-space is two hyperbolic planes plus one anisotropic
plane; codes are restrictions of all linear functions at `E_6` and all
affine linear functions thereafter.  There are no dependencies beyond Python
3 and no randomness.

Hashes and byte counts:

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-08-10-c906-marked-residue-tower.py` | `6557` | `7f0696046d815c882c82e44d61b8214f94dc7aa30905d735a50c5a7fa026be20` |
| `2026-08-10-c906-marked-residue-tower.out` | `637` | `1aaf8e2fe70dce65e9f5e3894a5d77614c9d9e6aea05c6055708a2a8ce042cab` |

The new verifier checks all ambient vectors, codewords, link points, pairs,
parameters, weight enumerators, and literal folded-code equalities.  The older
C682 verifier independently checks the lower `[120,9,56] -> [28,7,12] ->
[27,6,12]` ladder through the root/line certificate.  There is no second
implementation of the `E_10` calculation; the independent check there is the
displayed coordinate proof, and the exhaustive program is only a finite
sanity check.  Neither program proves novelty, canonicity after forgetting a
flag, or recovery of integral/signed data.

## 7. Hard red team: exact boundaries

### N1 — support is not arithmetic

Reduction to the binary tritangent-support kernel forgets the signs and
relative coefficients of the Cartan cubic.  C697 records nontrivial
multiplicative gauge data and a determinant twist over `Q`; none of it is
visible in `C_6`.  Therefore the binary tower cannot recover the integral
`E_6`, `E_8`, or indefinite `E_10` lattice, a root orientation, or the
`Q(sqrt(5))` descent data.

**Judo:** the arithmetic question is a lifting problem over the explicit
`432/864` bottom fibre, not an automatic benefit of the mod-two tower.

### N2 — the full Paper-V package is not in the bare code

The bare `E_6` carrier does not choose a double-six, golden orientation, row
order, or chordal companion.  The exact fibre `1728` is a sharp witness.  A
claim that “the code reconstructs the Clebsch gateway” without these retained
marks is false.

### N3 — the two `E_8`s do not identify

The C705 McKay/operator `E_8` and the C865 quadratic/root-pair `E_8` have no
proved direct comparison.  Naming coincidence, matching exceptional labels,
and a shared descent to `E_6` do not define a map.

### N4 — bare upward recovery is impossible

The counts in C906-E are not merely uncertainty in the proof.  Transitivity
rules out an intrinsic residue choice.  A future theorem must either retain a
flag or find new input that breaks the symmetry.

### N5 — `E_9` loses a level orientation

The radical/antipodal quotient remembers the `E_8` pairs but not a preferred
global half.  Any assertion of an oriented inverse has an additional `C_2`
obligation.

### N6 — `E_10` binary data is not the hyperbolic Kac--Moody object

The `[496,11,240]` quadratic evaluation carrier is finite.  Calling it
`E_10` records the exceptional ladder label; it does not recover an integral
indefinite root system or its Weyl dynamics.  Those require new data and new
proofs.

### N7 — reverse recovery stops at the carrier

Even the fully marked downward path returns the marked Paper-V/`E_6` carrier,
not automatically the Paper-I code, Paper-II quotient tensor, Paper-III
two-graph/global cover, or Paper-IV conic code.  Each further return must use
the separate proved gateway interface from C905.

## 8. Literature audit and priority ledger

The audit follows `notes/literature-audit-conventions.md`.  No manuscript
novelty sentence is proposed.

### Read sources

1. **A. E. Brouwer and H. Van Maldeghem, _Strongly Regular Graphs_.**
   Author-hosted preprint, whole PDF cached with SHA-256
   `fa73d72e86bbd8dc3fbfcbca45679cb8f2671d777e91c009eeff0a563fd9289d`.
   Read depth for this task: partial -- §§1.2.7, 3.3, 3.6 and Proposition
   3.6.1, 10.10, 10.39, and cited bibliography entries.  Proposition 3.6.1
   gives the general local quadratic-graph/Taylor-extension descent; §§10.10
   and 10.39 name the small exceptional chain.  Preprint and published page
   numbers differ, so only stable section/proposition IDs should be cited.

2. **A. E. Brouwer and E. E. Shult, “Graphs with odd cocliques,” _European
   Journal of Combinatorics_ 11 (1990), 99--104.**  Read depth: secondary only,
   through the attribution and bibliography in the preceding book.  It was
   not obtained.  This is a gate before any historical priority sentence more
   specific than “Brouwer--Van Maldeghem, after Brouwer--Shult.”

3. **A. R. Calderbank and W. M. Kantor, “The geometry of two-weight codes,”
   _Bulletin of the London Mathematical Society_ 18 (1986), 97--122.**  Cache
   key `10.1112/blms/18.2.97`, full text, SHA-256
   `986eeff4e7b4d259876242ee3659a627c28057abe5a087dcdd9e9bdb7181b05d`.
   The RT2 family and graph/code dictionary are present.  The full-text audit
   found duality, complementation, and field change, but no inter-rank fold.
   That omission does not rescue novelty because the graph descent is
   published elsewhere.

4. **L. Manivel, “Configurations of lines and models of Lie algebras,”**
   arXiv:`math/0507118`.  Cached SHA-256
   `216e859a766c31fccd2e614dee85fb77b94116cdba31c0c82ce37aaf218d8ec6`.
   Read depth: partial, especially Example 3 on the `27` lines/`E_6`
   configuration.  It supports the classical line/Lie dictionary, not the
   sparse-entry composition.

5. **Internal exact sources:** C682, C695, C697, C705, C865, C870, C872,
   C874, and C905 were read at the sections governing their stated
   interfaces.  C874 supersedes the earlier tower-novelty optimism in C865
   and C870.

### Exact web searches added for C906

Search depth was result-title/snippet screening followed by opening only
apparently relevant results.  Queries were run on 2026-08-10:

1. `"[27,6,12]" code "27 lines" cubic surface`
2. `binary code 27 lines cubic surface double six minimum weight`
3. `reconstruct 27 lines cubic surface from code double-sixes`
4. `Taylor extension quadratic form code reconstruction marked residue`
5. `W(E6) 36 double sixes stabilizer S6 x C2 27 lines`
6. `Schlafli graph automorphism group W(E6) double six stabilizer`
7. `27 lines cubic surface 36 double six W(E6) action`
8. `icosahedral A5 marked double six Clebsch cubic 27 lines`
9. `A5 subgroup W(E6) double six Clebsch cubic surface`
10. `minimum weight codewords double six Schläfli graph code`
11. `sparse reconstruction marked E6 27 lines code`

The screening found classical confirmations of `36` double-sixes,
`|W(E_6)|=51840`, and the Clebsch `A_5` geometry.  It did not surface the exact
minimum-shell reconstruction C906-A or the sparse Clebsch-entry/fibre
composition C906-B--E.  This is only a bounded screen.  In particular, a
recent snippet using `W(A_5)` meant the Weyl group `S_6`, not the golden
icosahedral group `A_5`; it cannot be used as evidence for our orientation
claim.

### Claim status

| proposed claim | status after audit |
|---|---|
| general exceptional fold/tower | **PRE-EMPTED / classical** |
| small `E_8 -> E_7 -> E_6` graph chain | **PRE-EMPTED / classical by name** |
| corresponding evaluation-code fold and enumerators | **thin translation; not a crown** |
| bare `E_6` code minimum shell reconstructs line/tritangent incidence | proved here/from C682; exact prior statement not located; novelty gated |
| sparse Clebsch marking enters the classical marked tower with exact fibres | exact composition proved; not located; novelty gated |
| recovery of integral/arithmetic exceptional structures | false from present input |

The next literature gate, if this is promoted toward a paper, is a focused
full-text audit of coding-theoretic treatments of the Schlaefli graph and
`[27,6,12]` code, plus the original Brouwer--Shult paper and literature on
marked residues/buildings.  No stronger novelty wording is licensed before
that gate.

## 9. Framing and reusable theorem statements

### Strongest honest punchline

> The Clebsch construction does not create a new exceptional tower.  It
> supplies sparse canonical entry data for a classical one, and the exact
> fibres show how much Clebsch structure the classical unmarked carrier has
> forgotten.

### Abstract-scale reusable statement

> The binary tritangent kernel of the Clebsch `27`-line configuration
> reconstructs the complete bare Schlaefli incidence from its minimum shell.
> An oriented golden double-six then gives a marked entry into the classical
> quadratic residue tower through `E_10`.  The marked descent is reversible;
> after forgetting the marks, the fibres have sizes `432`, `864`, or `1728`
> at `E_6` and grow by the exact residue factors `28`, `120`, and `496`.

### What not to put in a paper

- “We discover an `E_6`--`E_10` tower.”
- “The `E_8` code canonically contains the Clebsch cubic.”
- “The binary carrier recovers the integral `E_10` root system.”
- “The McKay `E_8` tensor equals the mod-two root-pair carrier.”
- “Bidirectional” without the word **marked** and the forgotten-flag fibres.

## 10. EJ + TT closeout

### Extra juice extracted

1. The best surviving invariant is not another parameter computation but the
   exact **loss ledger**: `432/864/1728` at the bottom and
   `28,120,496` residue multipliers above it.
2. The literal-code equalities are stronger and cleaner than a mere
   weight-enumerator match.  They give a reusable carrier lemma, although not
   a standalone novelty crown.
3. The mod-two failure to recover signs reframes the number-theory direction
   sharply: classify arithmetic lifts over a fixed binary carrier and ask
   which sparse golden mark cuts down the lift fibre.
4. The no-section argument turns “not bidirectional” into a sharp
   impossibility theorem.  Any successful unmarked reverse theorem must add a
   symmetry-breaking shadow, not just improve the proof.

### Tao-style questions and answers

- **Is the construction functorial, or only a coordinate trick?**  It is
  functorial in the groupoid of quadratic carriers with residue flags; the
  coordinate proof establishes the natural isomorphism class.
- **What is the minimal retained datum?**  A residue flag for reversibility;
  at the Clebsch entry, an unordered double-six plus oriented golden axis for
  the `432`-fibre version, or an ordered double-six for the full operator map.
- **Where does canonicity first fail?**  Immediately when the golden mark is
  forgotten at `E_6`, and again at every unmarked residue choice.
- **Can higher rank repair lower information loss?**  No.  Suspension embeds
  the lower ambiguity into a larger homogeneous fibre; it does not create a
  section.
- **Could a local-to-global theorem characterize the whole tower?**  The
  graph literature already contains strong local recognition.  Our viable
  refinement would have to recognize the *marked sparse entry*, not the bare
  graph.

## 11. Mystery ledger

| feature | status | exact remaining gate / owner |
|---|---|---|
| Why the golden `A_5` orbit is the useful slice of the `432` bottom markings | partly settled by C682/C695; conceptual uniqueness still open | classify `A_5`-orbits/centralizers inside `W(E_6)` with the operator cubic retained |
| Whether C906-A appears verbatim in coding literature | open | focused full-text `[27,6,12]`/Schlaefli code audit |
| Whether the sparse-entry + fibre composition appears in building/residue language | open | original Brouwer--Shult plus marked-building literature audit |
| Arithmetic lifts of one binary tritangent support | open and genuinely new-shaped | successor: classify signed Cartan lifts modulo gauge and golden marking |
| Direct comparison of the two `E_8` carriers | no evidence; deliberately not inferred | requires a separately defined functor and invariant match |
| `E_9` oriented-level recovery | settled negatively for unmarked input | add explicit `C_2` level orientation if required |
| Marked finite quadratic tower through `E_10` | settled | C906-C--E and exhaustive verifier |

No other genuine mystery is needed for C906.  The classical tower itself is
closed as pre-empted; the live opportunity is the sparse marked-entry and
arithmetic-lift interface.

## Final disposition

- **Mathematics:** GO as a research theorem packet.
- **Novelty:** HOLD pending the two focused literature gates.
- **Manuscript action:** none.
- **Best future use:** a short gateway theorem/series synthesis only if the
  exact composition, not the classical tower, is the advertised result.

Vibe check: the original tower crown is gone, but the judo is mathematically
cleaner -- a sharp marked/unmarked reconstruction theorem with exact fibres
and an honest arithmetic lifting frontier.
