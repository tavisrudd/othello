# Red team: GEB apparatus for the Clebsch papers

**Lane:** `clebsch`

**Date:** 2026-07-22

This is an adversarial review of the presentation-design proposal in
`2026-07-22-clebsch-geb-design.md`, produced by a delegated reviewer working only from that
design doc and the frozen paper plan `2026-07-20-clebsch-paper-planning.md`. It attacks each
proposed element as a hostile JCTA-tier referee, editor, priority skeptic, and post-publication
critic would, grades severity (KILL / MAJOR / MINOR / NOTE), and gives a concrete mitigation or a
cut recommendation for each. It manufactures no findings: where the design is sound it says so.
The governing constraint imported from the plan is that **overclaim sensitivity is maximal** and
the paper's whole credibility rests on a certified-claims discipline; every finding is weighed
against that, because the largest risk here is not that the play fails but that it contaminates
the rigor story it sits next to.

---

## 1. Hidden-content ethics and journal policy

### 1.1 "Disclose on request" is the wrong default; the covert channels need proactive disclosure — KILL (as written)

The design's custody rule is "disclose the apparatus to the editor **on request** without
hesitation." For a frontispiece figure or a whimsical appendix dialogue, reactive disclosure is
defensible — those are visible on the page. But three elements are genuinely **covert**: the
multi-track steganographic message pressed into label/example gauge choices, the truncated
cryptographic **commitment hash** to Paper 2's question, and the Paper-2 **acrostic**. Submitting a
paper that contains an undisclosed cryptographic commitment and undisclosed encoded messages into
single-blind or double-blind peer review, and disclosing only if asked, is structurally the same
posture that produced the acrostic-in-referee-report scandals the design itself gestures at. A
referee never thinks to "request" disclosure of content they don't know exists; "on request" is
therefore functionally *nondisclosure* for exactly the elements where nondisclosure is most
damaging. If any covert channel is discovered post-acceptance, the plausible editorial response is
a correction or expression of concern for undisclosed manipulation of the manuscript — a cost that
dwarfs any virality upside and that lands directly on the certified-claims reputation the papers
are built to earn.

**Mitigation:** split disclosure by channel. Visible play (dialogue, frontispiece, ignition line if
kept) may stay reactive. Every covert channel (encoded label/example messages, commitment hash,
acrostic) requires a one-paragraph **proactive** note in the cover letter to the editor at
submission: "the appendix and figure contain a benign GEB-style homage; certain non-canonical
labelling and example choices additionally encode a playful homage message and a commitment to the
sequel's open question; all are removable on request and none affect any theorem, proof, or
certificate." This costs the surprise-on-the-editor but preserves the surprise-on-readers, and it
converts the single most reputationally dangerous element from "concealment discovered later" into
"disclosed whimsy the editor signed off on." If the authors are unwilling to disclose a channel
proactively, that channel should be cut — unwillingness to tell the editor is itself the signal
that the channel is over the line.

---

## 2. Referee and venue risk

### 2.1 The ignition line is a liability, not deniable cover — MAJOR

"Like its subject, this paper remembers more than it displays." The design frames this as "to a
referee, a flourish; to the finder, the confession that starts the hunt." That reading is
backwards under adversarial conditions. Post-scandal, an editor primed to look for concealed
content reads this line *correctly* on the first pass: it is an in-print author admission that the
manuscript carries undisclosed content. It is the one sentence that converts a curious referee into
a suspicious one and hands a hostile editor a quotable exhibit ("the authors state in their own
introduction that the paper conceals material"). It maximizes discovery probability precisely when
discovery is most harmful (during review) while adding nothing mathematical.

**Mitigation:** cut it, or, if a closing flourish is wanted, replace it with a line that is true of
the *mathematics* and carries no meta-claim about the document ("the child forgets what the parent
remembers" — about the object, not the paper). Do not ship a sentence whose literal content is "this
document hides things."

### 2.2 The appendix dialogue is the highest removal-demand risk of the visible elements — MAJOR

A "Crab Canon on Two Sheets" with a Decorator character saying "Ask me again at thirty-one" is
unusual for a JCTA-tier appendix. Reactions bifurcate: a charmed referee waves it through; a sober
one asks for its removal as unserious, and an editor worried about precedent may back that demand.
The design's quarantine principle (deleting it "loses no mathematics") is the correct defense and
should hold — but note that its own principle 2 ("every device enacts a certified theorem, footnoted
to certificates like body text") *works against* easy removal: once each line is a footnoted formal
claim, the dialogue is no longer obviously severable decoration, and a referee may (reasonably)
treat it as body text to be audited rather than an appendix to be cut. See 4.3.

**Mitigation:** keep the dialogue strictly quarantined and strictly severable — a short appendix that
can be deleted wholesale with a one-line editor note and zero cross-references from the main text.
Do not footnote its playful lines to certificates in a way that makes them load-bearing (that
trades removability for audit burden; pick removability).

### 2.3 The commitment hash reads as numerology or hidden content to a skeptic — MAJOR

A truncated cryptographic hash printed in a serious finite-geometry paper, unexplained, is the kind
of artifact a referee flags as either unserious ("why is there a hex string here?") or, worse, as
undisclosed content. It carries zero mathematical value in Paper 1 and pure downside during review.
See §5 for the commitment's own internal problems; here the point is narrower — its mere presence on
the page is a referee-suspicion trigger.

**Mitigation:** do not print the raw hash in the Paper-1 body. If a commitment is kept at all (§5
argues against), anchor it in the arXiv version's ancillary metadata or a dated timestamp, disclosed
to the editor per §1, not as an unexplained string in the typeset paper.

### 2.4 Sound elements — briefly

The **independence remark** (§C: chirality bit independent of the child's theory, decidable in the
one-axiom extension, vocabulary "independent/extension" never "undecidable") is just correct
mathematical exposition of C379 and carries no venue risk; it is the one defensible "GEB nod" in the
main text and should stay. The **frontispiece as a summary figure** is a normal thing for a paper to
have and defensible on its own terms (subject to 3.2). The **strange-loop sentence** about the Lean
layer (Paper 2 apparatus) is three lines of plain exposition and is fine.

---

## 3. Mathematical traps

### 3.1 The 11 + 11 + 1 arithmetic actually checks out — SOUND (with one soft spot, MINOR)

Verified directly: "HEXAGONS ARE THE BESTAGONS" = HEXAGONS(8) + ARE(3) + THE(3) + BESTAGONS(9) =
**23** letters. Split as sheet +6 = "HEXAGONS ARE" (11) and sheet -6 = "THE BESTAGON" (11), with the
final "S" as the 23rd character delivered outside the matchings. So 23 = 11 + 11 + 1 = 22 + 1, and
the 22 equals the label alphabet a–v (a through v is exactly 22 symbols), one letter per label,
split across the two 11-point sheets. The design's arithmetic is internally consistent — this is not
a trap, and the "22 + 1 places the final character outside the matchings, delivered by the decoded
example (the parent signs the message)" story is arithmetically clean.

**Soft spot (MINOR):** the -6 sheet's 11 letters are "THE BESTAGON," which is a *fragment*, not a
standalone reading. The design's Record table claims the -6 track shows "the mirror reading is a
reading, not noise." "THE BESTAGON" (missing its plural S) is not really a self-standing reading; it
reads as an obvious truncation of the +6 sheet's joke. The claim that the two sheets are two
independent readings is weaker than stated. Also note the +6 sheet alone already spells "HEXAGONS
ARE," which telegraphs the entire payload immediately — the "requires the unordered pair plus the
swap to complete the phrase" framing oversells the difficulty, since one sheet gives the joke away.
Keep the arithmetic; drop the claim that -6 is an independent reading and the claim that the full
joke is gated behind the swap.

### 3.2 The frontispiece states signs the dialogue is careful to relativize — MAJOR

The plan's red-team discipline is explicit: the ±6 readout must be staged as
*measurable-given-decoration, never determinable-from-child*, because chirality is a relative
invariant canonical only up to an outer coset and a frozen frame. The **dialogue** honors this — it
introduces the Decorator, then states +6/-6 relative to "the frozen frame fixed in the appendix
itself," with prose that can carry the caveat. The **frontispiece cannot.** A figure that casts "+6"
and "-6" as two shadow tokens has no natural place for the "measurable-given-decoration, relative to
a fixed frame, up to outer coset" qualifier, and a figure asserts more absolutely than prose. A
referee holding the plan's discipline will read the frontispiece as claiming a canonical/absolute
sign — the exact overclaim the plan forbids — in the paper's single most shareable object, where it
will also be quoted out of context by any viral audience.

**Mitigation:** remove the ±6 tokens from the frontispiece, or render them explicitly as
*decorator-supplied* (e.g. the sign tokens visibly emitted by a marked frame element, with a caption
stating they are frame-relative and defined only after decoration). Do not let the figure seat the
"record-player key" via bare ±6 unless the frame-relativity is on the face of the figure. If the
caption cannot carry the caveat cleanly, cut the ±6 from the figure and keep the key in the prose
appendix only.

### 3.3 The depth-profile sizes 1,4,6/1,4,6 are not a total order; the "sort" channel is a set-separation, not a canonical ordering — NOTE (correctness) / MINOR (if ever claimed canonical)

The plan states C411's depth map "is rank two and set-separating, not a faithful linear quotient,"
and the profile sizes are 1,4,6 / 1,4,6 — sizes repeat (two 1s, two 4s, two 6s across the pair). A
sort by profile size is therefore *not* a total order; ties are broken only by the sheet gauge
choice. For a *hiding* channel this is harmless — non-canonicity is the whole point, and any fixed
printed order works. The trap is only if any element (dialogue footnote, verification-script
comment, or Record table) describes the ordering as canonical or as recovered from the child; that
would be an overclaim. The design does not currently make that claim, but the phrase "depth-profile
sort" invites it.

**Mitigation:** in any text, describe the order as a *chosen* gauge (the paper's fixed frame), never
as canonical or child-determined. Ensure the verification script pins the order by an explicit
printed convention, not by an implied canonical sort.

### 3.4 The arithmetic key is not fully available to a Paper-1-only reader — MAJOR (internal inconsistency)

Custody says "the puzzle must be solvable from the paper alone." But the Record table lists an
"arithmetic key (trace/prime rule)" whose track is "Paper-2 commitment string + verifiable
prophecy," and Stage 3 explicitly seals the commitment string "until sequel," with "Paper 2's
introduction reveals the preimage." So a Paper-1-only reader can verify the *prophecy* half
(machine-checkable: at 19 it survives, at 31 it fuses, check (2/31)) but cannot obtain the
*commitment* preimage — by design. The doc is internally inconsistent about what "solvable from the
paper alone" covers: the bestagon trail (Stage 2) is, the commitment (Stage 3) is deliberately not.

**Mitigation:** state the boundary explicitly. "Solvable from Paper 1 alone" applies to Stages 1–2
only; the commitment is a sealed pointer, not a puzzle, and must be described as such wherever the
"solvable from the paper" rule appears — otherwise a solver who exhausts Paper 1 and cannot crack the
commitment concludes the puzzle is *broken*, which is precisely the "broken puzzle discovered
publicly" failure the design names as the one that damages the paper.

### 3.5 Every playful line footnoted to a certificate becomes an auditable claim — MAJOR

Principle 2 ("each playful element is a formal restatement of a proved result, footnoted to its
certificates like body text") is the design's defense, but it is also a trap in the
maximal-overclaim regime: it *converts decoration into claims a referee must audit.* The dialogue
line "L: +6. / R: -6." footnoted to a chirality certificate is now a formal assertion, and if that
footnote asserts sign-determinacy beyond what C406/C412/C379 give (see 3.2), it is a genuine
overclaim in the paper — not a harmless flourish. The richer and more footnoted the apparatus, the
larger the surface on which an overclaim can occur, and the play is exactly where wording discipline
is likely to be loosest.

**Mitigation:** pick one posture per element and do not mix them. Either an element is *quarantined
decoration* (severable, and its lines are not footnoted as formal claims — see 2.2) or it is *body
text* (fully audited to the same standard as a theorem statement, with the same caveats). Do not ship
elements that get the deniability of decoration and the authority of footnoted claims at once.

---

## 4. Engineering feasibility

### 4.1 Four simultaneous tracks in one dataset is an unproven constraint-satisfaction claim — MAJOR

The design asserts the tracks "sample different aspects... so the constraint systems decouple." That
is an assertion, not a demonstration. The simultaneous requirements are stiff: the 22 labels a–v
must spell "HEXAGONS ARE" on one sheet and "THE BESTAGON" on the other *and* the example residues
must encode the commitment string under a base-11 pairing *and* the singleton-fibre datum must carry
the sealed question *and* every printed object must remain a natural, mathematically valid choice the
paper would make anyway. "Different aspects decouple" is plausible for the label-vs-example split but
is not obviously true, and the design offers no feasibility certificate. If the constraints do *not*
decouple, the resolution is to distort a printed object away from its natural form — which breaks
principle 1 (hide only in genuine gauge freedom) and risks a referee noticing an unnatural choice.

**Mitigation:** before committing to four tracks, produce an actual satisfiability check on the
frozen dataset: demonstrate an assignment meeting all constraints with every object still natural,
or drop tracks until it does. Treat the four-track count as aspirational until proven, not as a
fixed deliverable. The design's own density-ceiling principle ("any further idea must displace one
of these, not stack") should apply downward too: if feasibility is tight, cut the commitment track
(§5) first.

### 4.2 The apparatus is brittle against the ordinary revise-and-resubmit cycle — MAJOR

"Press the record only after the mathematical text freezes" assumes the frozen text survives review.
It usually does not: referees routinely demand an added or removed worked example, a renumbered
matching, a reworked figure, or a moved appendix — *after* freeze, during revision. Any such change
can silently break a track that was pressed against the pre-revision text. The design acknowledges
"a broken puzzle discovered publicly is the one failure mode that damages the paper" but does not
reckon with the fact that referee-mandated post-freeze edits are near-certain, and that re-pressing
after each revision round both multiplies the chance the hidden content is noticed and repeatedly
re-runs the feasibility risk of 4.1.

**Mitigation:** press the record only after *acceptance* (post-revision, camera-ready freeze), not
after the authors' internal freeze. Accept that this pushes all engineering to the very end and
that a late referee change can still force cutting a track — build that into the plan as an expected
outcome, not a failure. Keep every track independently removable so losing one to a late edit does
not cascade.

### 4.3 The verification script as a release gate is necessary but insufficient — MINOR

A script that re-extracts every track from the final PDF-source at each proof stage is realistic to
build and is the right instinct. But it is a *detection* gate, not a *prevention* gate: it catches a
track broken by an edit, it cannot stop a referee's mandated edit from breaking a track, and it
cannot certify that a printed object still reads as "natural" (a semantic judgment). It also becomes
a maintenance dependency on the paper's release pipeline that a co-author or production editor may
not understand or preserve.

**Mitigation:** keep the script, but scope its claim honestly — it gates "did an edit silently break
a track," not "is the apparatus safe to ship." Pair it with a human natural-ness review of every
gauge choice it touches, and document it so production staff do not "fix" a label ordering they read
as arbitrary.

---

## 5. Commitment risks (hash-of-a-question)

### 5.1 The commitment is high-risk, low-value in Paper 1 and should be cut or radically scoped — MAJOR (recommend cut)

Hashing a *question* rather than an answer ("is the central sign a Maslov index? — asked here
first," never as an answer) is the design's clever hedge against research risk, and it does
neutralize the "the answer turned out wrong" failure. But the residual problems are real and stack:

- **Question drift.** Paper 2 is not written; the plan explicitly keeps canonicity/mechanism/
  continuation in the `crowns` lane "until its own planning report exists," and "the signed
  genuine-Weil lift remains C472's question." The *central question of Paper 2 can change* before it
  is written. If it does, the reveal either fails to match the committed preimage or looks
  post-hoc-fitted — the precise overclaim posture the plan warns against.
- **Truncation.** A truncated hash is not a sound commitment: a short digest is vulnerable to a
  skeptic claiming a different preimage was found post hoc (second-preimage / collision headroom).
  Either commit at full width (≥256-bit, published immutably and timestamped) or do not claim it is
  a cryptographic commitment — a truncated string is theater that a cryptographically literate
  referee will call out.
- **Perceived unseriousness / hidden-content flag.** Covered in 2.3.
- **Delayed or negative reveal falls flat.** If Paper 2 is delayed years, or the Maslov-index
  framing is resolved negatively or abandoned before Paper 2, the "prophecy" reveal is anticlimactic
  or faintly embarrassing, and a public commitment to an unsecured research direction is itself an
  overclaim by another name.

**Mitigation / recommendation:** cut the printed commitment from Paper 1. If the authors want a
priority stake on the *question*, the standard, low-risk instrument already exists and is not covert:
state the open question in plain prose in the Paper-1 conclusion ("we ask whether the central sign is
a Maslov index") — the arXiv timestamp *is* the priority record, no hash needed. If a cryptographic
commitment is kept for sport, make it full-width, put it only in arXiv ancillary metadata, disclose
it to the editor per §1, and hash a deliberately abstract, drift-proof statement of the question
rather than a specific framing.

### 5.2 The certified prophecy (Stage 2) is genuinely lower-risk — SOUND

Distinguish the *prophecy* (bit survives at 19, fuses at 31, check (2/31) = +1) from the *commitment*
(the hash). The prophecy is backed by C453/C466 in the plan, is machine-checkable by a solver, and
is not a bet on unwritten work. Staging a *certified* prediction that readers verify themselves is
the strong, defensible core of the viral idea and should be kept even if the commitment is cut. Keep
its wording strictly to the certified scoped statement (the plan's cliffhanger discipline), with no
H4 or universal-roof implication leaking into the meme-facing phrasing.

---

## 6. Virality assumptions

### 6.1 Virality invites hostile scrutiny of exactly the novelty claims the plan spent its discipline protecting — MAJOR

This is the strategic crux. The plan is dense with novelty boundaries ("must not claim novelty for
the 5/14/22 marker spaces... double-coset enumeration... coarse Hadamard orbital geometry...";
Paley-deflation credit to Pan–Wu–Yin; "no predecessor located within the recorded coverage" wording).
That discipline is calibrated for a *small, expert, charitable* readership that reads the audit
column. A viral paper is read by a *large, non-expert, uncharitable* audience that will not read the
priority audit but will happily amplify a "this is just classical QR/Mathieu geometry rebranded"
takedown from anyone who does. Virality does not serve reception here; it converts a carefully
hedged priority position into a public target and hands the paper's most sensitive surface to its
least charitable readers. The upside (attention) and the downside (priority claims litigated on
social media) are asymmetric against the paper.

**Mitigation:** treat virality as a *risk to be bounded*, not a goal to be maximized. If a shareable
object is kept, make it the frontispiece (a summary of *what is proved*, not a novelty boast) and
keep the meme payload strictly homage, never a claim. Do not build the paper's reception strategy on
going viral; build it on the expert reception the audit discipline is designed for, and let any
virality be a bonus that the priority wording is already hardened against.

### 6.2 The three-stage rollout assumes control the authors do not have; premature discovery is the likely case — MAJOR

The seconds/evening/sealed-until-sequel model assumes discovery happens in the intended order and on
the intended timeline. In practice the apparatus is rich (dialogue + ignition line + frontispiece
tokens), so a curious referee or an early reader finds it *during review* or *at publication*, not on
the author's schedule. Premature discovery during review triggers the removal/suspicion dynamics of
§1–2; premature discovery at publication collapses the staging (everything is found at once). The
"two virality waves, the second is the better story" plan is a nice-to-have that the authors cannot
enforce.

**Mitigation:** design for the worst case (everything found at once, during review) and treat the
staged rollout as upside if it happens. Concretely: the paper must be fully defensible and
disclosure-clean at t=0 (per §1), so that "found early" is a non-event rather than a scandal. Do not
let any element's defense depend on it being found *late*.

### 6.3 "Hexagons are the bestagons" is a specific creator's line and an aging meme — MINOR (staleness) / NOTE (attribution)

The phrase is CGP Grey's, from a 2020 video; by 2026 it is a ~6-year-old meme. Two issues: (a)
*staleness* — what reads as delightful to the authors may read as dated or trying-too-hard to a 2026+
general audience, undercutting the virality premise it is chosen to serve; (b) *attribution/courtesy*
— it is a named creator's catchphrase used as the hidden payload. Legal exposure is low (a short
phrase is generally not protectable and this is non-commercial homage), so this is not a KILL, but it
is a specific person's line lifted without acknowledgment as the paper's Easter-egg centerpiece.

**Mitigation:** if kept, add a courtesy attribution somewhere non-covert (acknowledgments or the
internal note), and accept the staleness risk consciously. If virality is the justification and the
meme is stale, the justification is already weak — reconsider whether the payload earns its
engineering cost (§4.1).

---

## 7. Cross-cutting: interaction with the rigor and Lean story

### 7.1 Playful apparatus primes referees to distrust the certified-claims discipline — MAJOR

The papers' credibility is the finite-certificate / partial-Lean / careful-audit discipline. A
referee who meets a Crab Canon, a Decorator, an ignition line advertising concealment, and a
commitment hash *before* they finish auditing the certificates may generalize "these authors play
games" onto the rigor: "if the appendix is a game, how careful is the certificate column?" This is
the reverse of the intended effect (form enacting content) and it is a real reputational-interaction
risk in a venue where the sober trust-ledger is the whole selling point. The Lean strange-loop
sentence is individually harmless, but the *aggregate* whimsy sets a tone in tension with the
trust-ledger capstone (C320) the plan is building toward.

**Mitigation:** keep the visible whimsy minimal and strictly quarantined to clearly-marked
non-load-bearing appendices/figures, so the body reads as sober throughout. The main text should
contain at most the independence remark (§C) and nothing else that signals "play." Let a reader reach
the certificates and Lean map having formed the impression of a serious paper, and meet the play only
after, clearly fenced.

### 7.2 arXiv-vs-journal divergence creates a two-versions-of-record problem — MINOR/MAJOR

The channel-robustness table deliberately puts fragile elements (acrostics, Barker mask, QR-pun)
"arXiv only." Different hidden content in the arXiv and journal versions means the two versions of
record differ in content beyond typesetting, which (a) muddies any commitment whose whole value is a
single immutable anchor (§5.1), (b) creates citation/"which version has the puzzle" confusion, and
(c) risks a reader claiming the journal "removed" content, or vice versa. For a commitment this is
disqualifying; for garnish it is merely untidy.

**Mitigation:** keep the *commitment* (if kept at all) in exactly one anchored version (arXiv
ancillary, timestamped) and never in a form that implies the journal version also carries it. For
garnish acrostics, accept arXiv-only but document the divergence in the internal note so it is not
later mistaken for tampering.

---

## Verdict

### Survive as-is
- **§C independence remark** (main text): correct exposition of C379, no venue risk. Keep.
- **§G Stage-2 certified prophecy** (survives at 19 / fuses at 31 / check (2/31)): backed by
  C453/C466, machine-checkable, not a bet on unwritten work. Keep, with strictly certified wording.
- **The 11 + 11 + 1 arithmetic** (label alphabet a–v = 22, plus the example-supplied final letter):
  verified consistent. The *scheme* is sound; see modifications for the surrounding claims.

### Survive with stated modifications
- **§A appendix dialogue (Crab Canon):** keep only if strictly severable and *not* footnoted into
  load-bearing formal claims (2.2, 3.5); disclose reactively is acceptable for this visible element.
- **§B the puzzle-you-must-fail:** keep, but state explicitly that "solvable from Paper 1 alone"
  covers Stages 1–2 only, so the sealed commitment is not mistaken for a broken puzzle (3.4).
- **§D frontispiece:** keep as a summary figure, but remove or explicitly relativize the ±6 tokens so
  the figure cannot be read as asserting a canonical/absolute sign (3.2).
- **§E the Record (multi-track):** keep the label-message and example tracks only after an actual
  feasibility/satisfiability check proves all constraints co-satisfiable with every object still
  natural (4.1); press only after *acceptance*, not internal freeze (4.2); drop the claims that -6 is
  an independent reading and that the joke is gated behind the swap (3.1).
- **Meme payload:** keep only with conscious acceptance of staleness and a courtesy attribution to
  CGP Grey in a non-covert location (6.3).
- **Covert channels generally:** any channel that ships requires *proactive* editor disclosure at
  submission (§1); a channel the authors will not disclose proactively must be cut.
- **§Paper-2 ricercar/acrostic:** the Bach/RICERCAR citation defense is reasonable *if* proactively
  disclosed; as a covert acrostic it inherits the §1 KILL posture. Survives only disclosed.

### Cut
- **§F ignition line** ("remembers more than it displays"): cut — it advertises concealment to
  exactly the reader most likely to punish it (2.1). Replace with an object-level line if a flourish
  is wanted.
- **§G Stage-3 / §E arithmetic-track printed commitment hash:** cut from Paper 1 (5.1). Replace the
  priority stake with a plainly-stated open question in the conclusion (the arXiv timestamp is the
  record). If a cryptographic commitment is kept for sport, it must be full-width, arXiv-ancillary
  only, hashing a drift-proof statement, and editor-disclosed — not a truncated string in the typeset
  body.
- **Maximal-virality as a reception strategy:** cut as a *goal* (6.1, 6.2). Bound virality as a risk;
  do not stake reception on it.

### Bottom line
The design is at its best where play *is* certified mathematics that survives deletion (the
independence remark, the certified prophecy, the frontispiece-as-summary) and at its most dangerous
where it is *covert* (commitment hash, encoded messages, acrostic) or *self-advertising* (ignition
line). The single highest-leverage change is disclosure posture: proactive editor disclosure of every
covert channel converts the largest reputational risk into signed-off whimsy. The single best cut is
the commitment hash: it is high-risk, low-value, drift-exposed, and legible as either numerology or
concealment. With the ignition line and printed commitment cut, the covert channels disclosed, the
frontispiece signs relativized, the Record's feasibility proven before pressing, and pressing
deferred to acceptance, the surviving apparatus is defensible without endangering the certified-claims
discipline that is the papers' actual asset.
