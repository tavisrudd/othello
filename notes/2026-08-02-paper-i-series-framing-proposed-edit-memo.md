# Proposed Paper I edit memo — from exceptional object to strict recovery mechanism

**Lane:** `clebsch`

**Status:** proposal only; no manuscript source has been edited

**Target:** the next simultaneous forward release of Papers I--IV

## Editorial objective

Prevent a referee from reading Paper I as an exhaustive study of one exceptional
configuration.  The paper should remain honest that the Clebsch hexagon is an
exceptional classified object, while making the reusable reconstruction mechanism
the primary conceptual contribution:

```text
coarse observable data
    -> latent carrier
    -> unordered decomposition
    -> first surviving odd covariant
    -> oriented cubic and its realizations.
```

The simultaneous release changes the evidentiary posture.  Papers II--IV are not
future promises and should not be described as such.  They are accompanying,
independently checkable evidence that the same recovery architecture survives
changes of field, carrier, quotient, and representation.

## Governing claim

Use the following distinction consistently:

> The Clebsch objects are exceptional as classified configurations.  The strict
> recovery mechanism is not confined to a single object: across the four papers,
> progressively richer observable algebras recover a carrier, an unordered
> decomposition, its exact orbit, and finally its orientation.

Do **not** claim that Clebsch configurations are generic, that C494 proves an
arbitrary-`q` theorem, or that every stage of the four-paper series has a common
formal dependency.  The series-level claim is replication of a mechanism across
distinct exact settings, not prevalence in a parameter space.

## C494 evidence to promote

C494 supplies a precise information-theoretic bridge rather than a loose analogy.
For the frozen `B3` and `H3` matching configurations, it kernel-checks:

- equality of `(sheet,D')` fibres with the displayed `K`-orbits;
- failure of the two shared-edge counts without the sheet coordinate to separate
  all `K`-orbits;
- actual strict inclusions of rational invariant-function subalgebras; and
- dimension chains
  \[
    1<2<6<14 \quad(B_3/\mathbf F_7),
    \qquad
    1<2<6<22 \quad(H_3/\mathbf F_{11}).
  \]

This proves that the orientation/sheet datum is load-bearing information.  It is
not decorative structure added after the orbit has already been recovered.

The accepted boundary must travel with every use of C494: it is finite and exact
at `q=7,11`; it does not prove a general double-coset theorem, canonical
association-scheme identification, or general-`q` result.  The projective
derivation of the displayed tables is outside that Lean gate.

### Proposed Paper III upgrade

Paper III should use C494 as the finite, exact instance of a **strict recovery
ladder**.  Its operator and harmonic passages then become realizations of
information recovered at successive levels, rather than a catalogue of
Clebsch coincidences.  Before Paper I attributes this upgrade to Paper III, the
Paper III forward version must contain an exact theorem/proposition locator and
must state the C494 boundary above.  Until that integration exists, Paper I may
cite the C494 result through the paper that actually owns the theorem, but must
not silently transfer proof ownership.

## Proposed Paper I interventions

These are proposed edits only.  Apply them later as one coherent exposition pass
after the formal spine and correspondence audit are closed.

### 1. Abstract

The abstract currently begins at the `q=11` specialization and mentions the
uniform field window only at the end.  Add one sentence naming the inverse
mechanism before specializing:

> We study when coarse nearest-codeword data recover a projective code and when
> the first odd invariant of the recovered ambiguity data supplies its missing
> orientation.

Near the end, add a restrained simultaneous-series sentence:

> The accompanying papers test the same recovery ladder on conic matching
> quotients, characteristic-zero golden descent and operator realizations, and a
> distinct finite-field passant code.

Avoid listing every companion theorem in the abstract.

### 2. First two pages of the introduction

Move the series architecture ahead of the long literature survey.  The reader
should encounter the general inverse problem, the recovery ladder, and only then
the sharp Clebsch closure.

Proposed paragraph:

> The point of the example is not that the Clebsch hexagon is typical.  It is a
> sharp instance in which a reconstruction ladder closes completely.  Coarse
> syndrome incidence recovers the carrier; nearest-codeword ambiguity recovers
> an unordered support decomposition; triangle holonomy, the first surviving odd
> covariant, recovers its orientation.  The simultaneously released companion
> papers vary the field, carrier, quotient, and representation while retaining
> this sequence of information gains.

### 3. Separate mechanism from specialization

Insert a compact table after the principal Paper I theorems:

| Mechanism-level ingredient | Paper I specialization |
|:--|:--|
| chord-defect identity and partial-cover bounds | six-arcs in `PG(2,11)` |
| syndrome locus as a projective observable | the nonsingular conic |
| ambiguity data recover a two-sheet/two-graph structure | the Clebsch support bipartition |
| first odd covariant orients an unordered decomposition | triangle holonomy and the support cubic |
| diagonal determinant pencil exposes the odd term | the golden order-six conference operator |
| exact rigidity closes the inverse problem | the Clebsch orbit and its `A5` stabilizer |

This table should distinguish what transfers from what is exceptional without
weakening the sharp theorem.

### 4. Add a strict-information paragraph

After the orientation theorem, explain why orientation is mathematically
necessary rather than an attractive embellishment:

> The companion matching calculation makes this loss of information exact.  In
> the `B3/F7` and `H3/F11` cases, the constant, sheet, orbit, and full function
> algebras form strict towers of dimensions `1<2<6<14` and `1<2<6<22`; the
> shared-edge profile without the sheet merges distinct orbits, whereas
> `(sheet,D')` has exactly the orbit fibres.  Thus the odd orientation datum is a
> genuine additional recovery step.

Replace the informal names and ASCII dimensions with the final mathematical
notation and exact simultaneous-paper theorem locators during implementation.

### 5. Replace the late series paragraph

The existing paragraph beginning “This is Paper I of a four-paper sequence” is
too late and too bibliographic.  Retain a short roadmap there, but make it a
summary of four independent inverse problems:

1. Paper I: deep-hole syndrome locus to code, support, and orientation;
2. Paper II: quadratic trade to matching sheets and their cubic orientation;
3. Paper III: golden descent and transport of the oriented source through
   conference, exterior, determinant/Pfaffian, and harmonic realizations,
   augmented by the strict recovery-ladder interpretation;
4. Paper IV: a different finite-field reconstruction problem for the
   `q=13` passant code.

Use present tense throughout.  Remove “forthcoming,” “later paper,” and any
language that makes the simultaneous papers sound speculative.

### 6. Title and subtitle

Do not rename Paper I merely to sound general.  Its current title honestly names
the sharp object and inverse datum.  If a framing change is desired, add a short
running subtitle or series-deck phrase such as “A strict reconstruction ladder”
rather than replacing the canonical title.

### 7. Cover letter and shared release metadata

Prepare a one-page series synopsis to accompany simultaneous submission.  It
should contain:

- the recovery-ladder diagram;
- one sentence on the independent mathematical question of each paper;
- a statement that no companion is a hidden proof dependency of Paper I;
- exact stable public locators and version identifiers for all four papers; and
- the mechanism/specialization distinction.

Use the same restrained two-sentence series description in repository READMEs,
release notes, and submission comments.  Do not duplicate a long manifesto in
all four manuscripts.

## Reviewer-perception checks

The final exposition pass should be tested against four predictable readings.

### “This is only a sporadic configuration.”

Answer with repeated mechanism, not with a claim of genericity: two finite
fields in the strict information lattice, three Coxeter types in the quotient
rank picture, characteristic-zero arithmetic/operator transport, and the
separate `q=13` code problem.

### “The sequels are being used to complete Paper I.”

State logical independence explicitly.  Paper I's proofs and trust manifest
must close on their own.  The other papers provide simultaneous transfer and
replication evidence.

### “This is one result split into several papers.”

Name the different inverse problems and theorem interfaces.  The shared ladder
is the organizing principle; each paper changes both the observable input and
the structure reconstructed.

### “The information-lattice claim is computational evidence.”

State the exact trust boundary: C494 uses explicit finite `B3/H3` data with
kernel checking plus a symbolic subalgebra-finrank theorem.  Do not present it
as a general structural proof beyond those two cases.

## Language rules for the eventual edit

Prefer:

- “simultaneously released companion papers”;
- “replicated reconstruction mechanism”;
- “strict information gain” or “strict recovery ladder”;
- “exceptional specialization in which the ladder closes completely”; and
- “logically independent, structurally connected.”

Avoid:

- “representative example” or “generic model”;
- “the sequels will show”;
- “universal information lattice” unless a universal theorem is actually
  proved;
- “orientation is encoded already” when C494 shows the sheet coordinate is
  load-bearing; and
- any Paper III attribution without an exact forward-version theorem locator.

## Deferred implementation checklist

No item below is authorized by this memo itself.

1. Finish Paper I's O1--O8 formal spine and correspondence audit.
2. Confirm the final Paper III location and statement of the C494-based upgrade.
3. Confirm stable public locators and simultaneous version identifiers for
   Papers II--IV.
4. Draft the abstract, early introduction paragraph, mechanism/specialization
   table, strict-information paragraph, and revised roadmap as one patch.
5. Run a cold read asking specifically whether Paper I appears to be a case
   study, a hidden multi-paper dependency, or a salami-sliced result.
6. Reconcile every cross-paper statement with the trust manifests before
   synchronizing the standalone Paper I repository.

## Recommended editorial decision

Adopt the strict recovery ladder as the series-level organizing principle, but
keep Paper I's theorem statements and title centered on the Clebsch inverse
problem.  The strongest answer to the “exceptional object” objection is not a
broader slogan; it is the simultaneous availability of exact companion
theorems, with C494 proving that the missing orientation is a strict and
measurable increment of information.
