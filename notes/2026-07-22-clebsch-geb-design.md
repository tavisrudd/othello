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
