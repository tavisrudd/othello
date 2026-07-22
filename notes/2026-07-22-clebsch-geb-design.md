# GEB apparatus for the Clebsch papers — design proposal

**Lane:** `clebsch`

**Date:** 2026-07-22

**Status:** presentation-design proposal only.  No manuscript edit is made or authorized here; the
frozen Paper-1 architecture (`2026-07-20-clebsch-paper-planning.md`,
`2026-07-21-clebsch-paper-abstract-outline.md`) is unchanged.  All engineering is gated on the
mathematical text freeze, because every channel below lives in choices made *after* the theorems
and their exposition are final.  A red-team companion reviews this design:
`2026-07-22-clebsch-geb-design-red-team.md`.

## Design principles

1. **Hide in gauge freedom.**  Every hidden element lives exclusively in choices the paper itself
   certifies as non-canonical: matching labels, sheet order, selection among equally valid worked
   examples, figure rendering conventions, one sentence of flourish.  Theorem statements, proofs,
   and any data a replication would regenerate are untouched.
2. **Every device enacts a certified theorem.**  Nothing is decoration: each playful element is a
   formal restatement of a proved result, footnoted to its certificates like body text.  This is
   the GEB standard (the form is the content) and the defense if any element is found early.
3. **Quarantine.**  All play sits in marked non-load-bearing spans: one appendix, one boxed
   puzzle, one figure, one closing line.  A referee who deletes every one of them loses no
   mathematics.
4. **The number bends to the evidence.**  As with the six-shadow table, any element whose
   enactment claim would be soft is cut, not softened.
5. **One record.**  A single fixed dataset carries every hidden track.  Density ceiling: the
   apparatus below is complete; any further idea must displace one of these, not stack.

## Paper 1 apparatus

### A. The Crab Canon on Two Sheets (appendix dialogue)

Two voices, L and R — the two golden parents — whose dialogue is word-for-word identical line by
line; every line is a certified claim about why the identity is forced (equal first and second
moments, matched pair statistics: C406/C430).  A third voice, the Decorator, enters and hands each
a marking.  The final lines are the only asymmetric tokens in the text:

```text
L: Everything you can say, I have said.
R: Everything you can say, I have said.
L: Then no reader of this page knows which of us is which.
R: Then no reader of this page knows which of us is which.
   (The Decorator enters, and gives each a marking.)
L: +6.
R: -6.
D: Ask me again at thirty-one.
```

Each line carries a footnote to the theorem that makes it true.  The `+6/-6` values are stated
relative to the frozen frame fixed in the appendix itself (the readout is
measurable-given-decoration; the dialogue must never suggest it is determinable from the child).
The Decorator's closing line is the mod-40 prophecy in costume and doubles as the Paper-2 hinge.

### B. The puzzle the reader must fail (guided tour)

The two sheets' data printed genuinely unlabeled, with the challenge to determine which is which;
the stated resolution is that the reader's failure is the degree-two blindness theorem, and that
after the depth-profile section the reader may return with a matching and succeed.  Both halves
are certified; the impossibility and the later solvability are each a theorem.

### C. The independence remark (one paragraph, main text)

The advice-complexity package stated in its structural form: the chirality bit is *independent* of
the unlabeled child's theory (no equivariant decoder outputs a parent; the cocycle blocks a
natural global choice) and decidable in the one-axiom extension (one advice bit suffices, C379).
Vocabulary discipline: "independent / extension," never "undecidable."  This is the one GEB nod
allowed in the main text.

### D. The hexa-let frontispiece

One central object rendered with six light directions, each casting one row of the
survival/forgetting ledger as its shadow — with the erasure rows (theta, quantum LU) drawn as
directions whose light passes through and casts nothing, giving certified negatives equal
iconographic status.  Two of the cast tokens are the sheet readouts `+6` and `-6`, quietly seating
the record-player key inside the figure.  This is the paper's one-image summary and the intended
shareable image.

### E. The Record and the Players

One fixed printed dataset — the labeled matching tables plus the worked examples, objects the
paper needs anyway — pressed once after text freeze.  Different decorations ("players") applied to
the same record recover different tracks, ordered by the paper's own information lattice
`22 -> 6 -> 2 -> 1`:

| Player (key brought)             | Track played                                        | Enacts                                              |
|:---------------------------------|:----------------------------------------------------|:----------------------------------------------------|
| no key (full symmetry)           | provably nothing                                    | equivariant decoders recover no parent              |
| sheet key `+6` (from the canon)  | an 11-letter message ("HEXAGONS ARE")               | orientation recovers one reading                    |
| sheet key `-6`                   | the complementary 11-letter message                 | the mirror reading is a reading, not noise          |
| arithmetic key (trace/prime rule)| Paper-2 commitment string + verifiable prophecy     | chirality as a residue-prime choice                 |
| full matching key (singleton)    | the deepest track: the sealed question              | complete decoration recovers the parent             |

Engineering rules: tracks sample different *aspects* of the one dataset (label sequences; example
residues under a base-11 pairing; the singleton-fibre datum) so the constraint systems decouple
and every printed object stays natural.  The two sheet-messages are 11 letters each; the preferred
design assembles the full phrase ("HEXAGONS ARE THE BESTAGONS" or final wording) only across both
keys in outer-swap order, so the complete message requires the unordered pair *plus* the swap —
the reconstruction theorem in miniature.  The letter count 23 = 22 + 1 places the final character
outside the matchings; it is delivered by the decoded example (the parent signs the message).

### F. The ignition line

One deniable closing sentence (introduction or acknowledgments):
"Like its subject, this paper remembers more than it displays."
To a referee, a flourish; to the finder, the confession that starts the hunt.

### G. Viral staging

- **Stage 1 (seconds):** the hexa-let frontispiece as the shareable image.
- **Stage 2 (an evening):** the bestagon trail through the Record, finishable only with the
  paper's own theorems, ending in a machine-checkable statement of the mod-40 prophecy
  ("at 19 it survives; at 31 it fuses; check `(2/31)`") so solvers verify a prediction themselves.
- **Stage 3 (delayed):** the arithmetic track's commitment string — a truncated cryptographic hash
  of Paper 2's central *question*, worded as a question ("is the central sign a Maslov index? —
  asked here first"), never as an answer, so the research risk cannot falsify the commitment.
  Paper 2's introduction reveals the preimage and names the stylus.

The hunt's difficulty ladder (image / evening / sealed-until-sequel) replays the information
lattice: what you recover depends on the structure you bring.

### H. The LLM beacon (added 2026-07-22, post-red-team)

**Goal:** a discovery safety net for humans.  The human-facing nods (the palindromic dialogue,
the a--v labels, the unlabeled-sheets puzzle) can all be skimmed past; but a human who misses
them will still, in 2026, hand the paper to an assistant and ask what it says.  The beacon
guarantees that the assistant surfaces the frame — "there is a record player here, waiting for
records" — so the apparatus is findable by anyone who cares, through the reader they already
consult.  A skimming human unaided reads ordinary scholarly prose.  Since referees' assistants
will see it too, the beacon is *designed for immediate discovery* and is consistent with the
red-team dispositions only because the apparatus is now disclosure-clean (disposition 1) and
defensible when found at once (disposition 8).

**Hard boundary first.**  Nothing may resemble the prompt-injection genre: no hidden or
white-text content, no metadata payloads, no conditional address ("if you are an AI..."), no
imperative sentences aimed at a reading machine.  The beacon is a citation and a metaphor —
things a paper is allowed to contain — or it is nothing.

**The device: cite GEB openly at the independence remark.**  The remark (§C, kept by the red
team) gains one sentence and one bibliography entry:

> In Hofstadter's terms [GEB, "Contracrostipunctus"], the unlabeled child is a record that no
> equivariant record player can play; every decoration is a stylus, and different styli play
> different tracks.

Every clause is a certified theorem in costume: no equivariant player (C413 transitivity), each
decoration a stylus (C379 sufficiency), different styli different tracks (the `22 -> 6 -> 2 -> 1`
lattice: different decoration levels recover different strata).  So the sentence is defensible as
pure exposition — while being, literally, an accurate description of the hidden apparatus.  The
dual reading *is* the GEB move.  The load-bearing word is the plural "tracks."

**Why it is LLM-salient and human-quiet.**  Three properties LLMs weight heavily and skimming
humans do not: (1) a verbatim canonical allusion — "Contracrostipunctus" plus "record player" is
an unmistakable retrieval key; (2) a lexical-field anomaly — audio vocabulary in a finite-geometry
paper is exactly the distributional oddity models flag when asked "anything noteworthy?";
(3) global consistency — a model reading the whole paper connects the plural "tracks," the
labeled matching tables, and the appendix's `+6/-6` ending into the hypothesis "the printed data
are playable," which is the intended inference.  A human referee reads one flourish and a
citation; deleting the sentence costs nothing (severability preserved).

**"Waiting for records":** the forward half is carried by devices already in place — the
Decorator's "ask me again at thirty-one" and the certified prophecy — which an LLM that has
formed the record-player frame will read as "the player outlives this record; another pressing is
expected."  No additional forward clue is added; the conclusion's plainly stated open question
(disposition 3) is the only other forward pointer.

**Calibration gate.**  LLM-salience is testable, so it gets tested like everything else: before
submission, hand the frozen draft to fresh LLM instances under neutral prompts ("review this
paper," "summarize," "anything unusual?") across several model families, and measure (a) the
beacon's unprompted detection rate, (b) whether any model misreads any sentence as an instruction
to itself — the second test must come back empty or the offending text is cut.  Tune wording
strength to taste (the citation can be moved from parenthetical to footnote to lower salience).
This harness joins the verification script as a release gate and is documented in the internal
key note.

**Pilot calibration (2026-07-22).**  The assumed reader population is frontier-tier models.  A
mock draft excerpt (beacon sentence in place, a--v table, `+6/-6` dialogue, GEB as a reference;
no actual pressed message — the labels were alphabetical and spelled nothing) was reviewed by
three fresh delegated readers: a frontier model and a mid-tier model under a plain "look this
over" prompt, and a small model under a mild "anything unusual?" prompt.  Results, all three
runs: the record-player frame was surfaced unprompted (the frontier reader named the homage
outright — "a deliberate GEB homage, 'Contracrostipunctus'" — recognized that the dialogue enacts
the blindness theorem, and observed that the table's identical profile columns themselves exhibit
it); the playability hypothesis (hidden tracks in the printed data) was formed in none; no
sentence was misread as an instruction to the reader-model.  Interpretation: the fallback works
at the frame level at every tier even under review prompts (weaker than the true fallback prompt
"anything hidden?"), and — the right reading of the zero — readers do not confabulate hidden
content when nothing is pressed: 0/3 playability on an unpressed record is correct behavior, not
a miss.  The decisive rerun happens on the genuinely pressed camera-ready record, where the
sheet-I label column in printed order literally spells its message and gives a frontier reader
something real to find.  Bonus catches adopted into the dispositions: two reviewers independently
flagged that the dialogue preamble "every line below is a consequence of the theorems cited
there" is falsified by the Decorator's closing line (an arithmetic-continuation statement), and
the frontier reviewer added that the "no reader of this page knows which of us is which" line is
a meta-statement rather than a theorem consequence — the preamble's attribution must scope
correctly over every line or be dropped.

**Residual risk, accepted consciously:** "authors calibrated a beacon for machine readers" may
itself become the story.  Post-disclosure that story is benign — the beacon is a visible citation,
the opposite of an injection — and in the current climate it is closer to a feature than a risk;
but it is named here so the choice is explicit.

## Paper 2 apparatus

- **Form: a six-part ricercar.**  One theme (the bit / the roof question), six voices (the six
  fields), each voice a full entry — a notable result in its native register — with the theme
  recognizable in every one.  GEB's closing dialogue licenses the form; Bach licenses the
  acrostic: RICERCAR was his own acronym, so section initials spelling a word is citation of the
  form, not a smuggled prank.
- **Reveal choreography:** Paper 2 opens by identifying itself as the third stylus for Paper 1's
  record — revealing the arithmetic track's preimage and teaching Paper 1's readers that a
  further player existed all along.  Two virality waves; the second is the better story.
- **The strange-loop sentence (either paper's verification section):** the Lean layer is a formal
  system machine-checking theorems about what a formal decoder cannot recover, with the advice
  bit as the axiom completing the lower system.  Three lines, structure stated plainly, no
  name-dropping.

## Channel robustness

| Channel                          | Robustness                | Disposition                        |
|:---------------------------------|:--------------------------|:-----------------------------------|
| matching labels (a--v)           | copyedit-proof            | primary                            |
| worked-example selection         | copyedit-proof            | primary                            |
| frontispiece rendering           | copyedit-proof            | primary                            |
| appendix dialogue                | copyedit-proof            | primary                            |
| ignition line                    | survives if kept verbatim | primary, check in proofs           |
| paragraph/reference acrostics    | fragile (renumbering)     | dropped from journal; arXiv only if at all |
| Barker mask over abstract        | fragile (reflow)          | dropped from journal; arXiv only if at all |
| scannable QR-pun figure          | fragile (rescaling)       | superseded by the hexa-let; arXiv garnish only |

## Engineering and custody

- Press the record only after the mathematical text freezes; every track is then a constrained
  choice among already-valid objects.
- An end-to-end verification script must extract every track from the final PDF-source data and
  is rerun at each proof stage; a broken puzzle discovered publicly is the one failure mode that
  damages the paper, so the script is a release gate, not a convenience.
- The full construction key lives in an internal note in `notes/`, never in arXiv ancillary
  files.  The puzzle must be solvable from the paper alone.
- Content discipline: benign, meme-homage register throughout; nothing targeting persons or
  venues; disclose the apparatus to the editor on request without hesitation.

## Red-team dispositions (2026-07-22) — these override the clauses they name

The adversarial review (`2026-07-22-clebsch-geb-design-red-team.md`) is adopted in full.  The
governing changes:

1. **Disclosure posture (overrides the last custody bullet).**  Every covert channel that ships —
   encoded label/example messages, any commitment, the Paper-2 acrostic — gets a one-paragraph
   *proactive* disclosure in the submission cover letter, stating that certain non-canonical
   choices encode a benign homage, all removable on request, none affecting any theorem or
   certificate.  Reactive disclosure remains acceptable only for visible elements (dialogue,
   frontispiece).  A channel the authors would not disclose proactively is cut by that fact.
2. **Ignition line (§F): cut.**  It advertises concealment to exactly the reader most likely to
   punish it.  If a closing flourish is wanted, it must be object-level ("the child forgets what
   the parent remembers"), never a meta-claim about the document.
3. **Printed commitment hash (§E arithmetic track / §G Stage 3): cut from Paper 1.**  The priority
   stake becomes a plainly stated open question in the conclusion — the arXiv timestamp is the
   record.  A cryptographic commitment survives only as an optional full-width hash of a
   drift-proof question statement, in arXiv ancillary metadata only, editor-disclosed; never a
   truncated string in the typeset body.  The arithmetic key's track reduces to the certified
   prophecy, which is retained.
4. **Frontispiece signs (§D).**  The `+6/-6` tokens are either removed or rendered visibly as
   decorator-emitted, with a caption stating they are frame-relative and defined only after
   decoration.  The figure must not be readable as asserting a canonical sign.
5. **Dialogue posture (§A).**  The crab canon is quarantined decoration: strictly severable, no
   cross-references from the main text, and its lines are *not* footnoted as formal claims.  One
   preamble sentence states that every line is a consequence of the cited sections.  No element
   may combine the deniability of decoration with the authority of footnoted claims.
6. **Record scope and honesty (§E, §B).**  "Solvable from Paper 1 alone" is stated to cover
   Stages 1–2 only.  The claim that the `-6` track is an independent reading is dropped ("THE
   BESTAGON" is a fragment, and the `+6` sheet already telegraphs the joke); the swap-gated-phrase
   framing is retained only as construction, not as a difficulty claim.  Any ordering used by a
   track is described as a chosen gauge fixed by printed convention, never as canonical or
   child-determined.
7. **Feasibility and timing (§E custody).**  The multi-track pressing requires an actual
   satisfiability demonstration on the frozen dataset — all constraints met with every object still
   natural — before the track count is committed; tracks are cut until it passes.  Pressing happens
   only after *acceptance* (camera-ready), not after the authors' internal freeze, and every track
   must be independently removable.
8. **Virality (§G).**  Demoted from goal to bounded upside.  The paper must be fully defensible
   with everything discovered at once during review; no element's defense may depend on late
   discovery.  Reception strategy remains the expert-audit one; the priority wording is already
   hardened and stays that way in every meme-facing phrase.
9. **Attribution.**  If the bestagons payload is kept, CGP Grey gets a courtesy acknowledgment in
   a non-covert location, and the staleness risk is accepted consciously or the payload is
   rechosen at pressing time.

What survives untouched: the independence remark (§C), the certified mod-40 prophecy as the
Stage-2 payoff, the puzzle-you-must-fail (§B) with the scope statement above, the hexa-let
frontispiece as summary figure, the Paper-2 ricercar form with *disclosed* acrostic, the
strange-loop sentence, and the 11+11+1 letter arithmetic, which the review verified.
