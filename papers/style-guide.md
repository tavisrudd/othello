# Paper style guide

This guide records shared editorial standards for research papers in this
repository. Journal instructions and mathematical correctness take priority.
The aim is expert-speed exposition: accessible across adjacent disciplines
without diluting the mathematics or making specialists wade through textbook
background.

## Stylistic model

The primary model is Milnor's reader-first transparency, held inside Serre's
structural and verbal discipline.

At sentence level, add Strunk and White's injunction to “make every word tell”:
omit needless words, prefer direct and concrete language, and revise until each
sentence advances the argument. Economy must serve clarity; never compress away
an essential mathematical step.

- Make the central idea visible early. Give the reader the right picture,
  illuminating special case, or governing mechanism before asking them to carry
  technical detail.
- Use that guidance to transfer understanding, not to add warmth for its own
  sake. An intuition, example, or transition earns its place only if it changes
  how the argument is understood.
- Give the paper a severe skeleton: state the main theorem precisely and early,
  at its natural level of generality; introduce definitions where they become
  useful; and cut throat-clearing, inflated context, and secondary branches that
  compete with the main line.
- Keep the tone calm. Do not advertise one's own result as “remarkable,”
  “surprising,” or “powerful,” and do not hedge a precise claim. State what is
  proved and let its content carry the emphasis.
- Expand the point where understanding is won. Compress what is genuinely
  routine. Terseness is not a virtue when it hides the mechanism or makes a
  referee reconstruct an essential step.

A qualified reader should be able to say why the proof works, where the
difficulty lies, and what the result changes. When formal or computational
artifacts settle correctness, use the prose to explain the mathematics and mark
the exact trust boundary.

For proof-strategy sections, Thurston's *On Proof and Progress in Mathematics*
offers a useful diagnostic: exposition should transfer understanding.

## Governing principles

1. Lead with the mathematical object, question, and result. Literature,
   provenance, and verification should support that story rather than delay it.
2. Make every word tell. Delete repetition, throat-clearing, defensive prose,
   and implementation detail that does not help the reader understand or assess
   a claim.
3. Preserve hierarchy. Main ideas, secondary refinements, exact census data,
   provenance boundaries, and verification mechanics should not receive equal
   rhetorical weight.
4. State claims at their natural strength, with their hypotheses and trust
   boundary visible. Do not oversell a computation as a conceptual theorem or
   undersell a conceptual theorem by surrounding it with audit detail.

## Layered exposition

Identify the primary venue audience and the adjacent expert audiences before
revising. Write at the primary audience's pace, but state conventions wherever
an adjacent expert could reasonably interpret the object differently.

- At first use, pair specialized terminology with a one-clause operational
  gloss: “a synthematic total, that is, a one-factorization of \(K_6\).” Put
  whichever form best orients the intended reader first; use the expert term
  without repeated explanation thereafter.
- Translate at disciplinary interfaces, not everywhere. For example, identify
  an “uncovered point” with a “weight-three syndrome direction” once, then use
  whichever vocabulary fits the local argument.
- Do not reteach standard theory. Do state conventions when adjacent fields may
  disagree about projective representatives, code equivalence, group actions,
  labeled versus unlabeled objects, or degenerate cases.
- Give a one- or two-sentence roadmap before an argument that changes
  mathematical languages or has several conceptual stages. Compress routine
  steps, but expose every step carrying completeness, equivariance, exceptional
  cases, or a change of language.
- Put optional background in a remark or related-work paragraph that an expert
  can skip without breaking the proof. Use footnotes only when the venue permits
  them and the material is genuinely parenthetical.
- Prefer a concrete example before a dense equivariant or categorical
  construction. One example should illuminate the general definition, not
  duplicate its proof.

Layering is not “dumbing down.” It exposes the route through the argument while
leaving the technical content intact.

## Introductions and abstracts

As a diagnostic, the abstract should answer:

1. What object or problem is studied?
2. What is the principal theorem?
3. What is the mechanism or conceptual advance?
4. What are the most important consequences or boundaries?

Use exact counts only when they help distinguish the result. Avoid turning the
abstract into a table of contents.

In the introduction:

- establish notation only as needed to state the problem;
- present the object and a precise main theorem on page 1 or 2 when the format
  permits, before an extended literature survey;
- follow the theorem with a plain-language paragraph identifying the key new
  idea, the obstruction it overcomes, and the honest scope of the result;
- identify the structural contrast or consequence that makes the result worth
  remembering, without announcing that it is surprising;
- give an authoritative novelty account proportionate to the theorem structure;
- distinguish conceptual proofs from finite verification clearly, without
  repeating the same trust statement after every result;
- end with a roadmap only if section titles do not already supply one.

Do not repeat novelty disclaimers in later sections unless a local result has a
genuinely separate priority boundary.

### Default opening sequence

Unless the venue or subject demands another order, the opening should have this
shape:

1. Name the object and question with only the notation needed to understand
   them.
2. State the principal theorem precisely, including the hypotheses and the
   honest level of generality.
3. Explain the key idea in plain mathematical terms. A reader who stops here
   should know what is new besides the conclusion.
4. Give a short strategy of proof: identify the conceptual stages, say where the
   real difficulty lives, and distinguish conceptual reduction from formal or
   finite verification.
5. Situate the result accurately and generously in the closest literature, then
   give a roadmap only if it helps readers separate the main path from optional
   applications.

Treat this sequence as the default. In a short paper, it may occupy a few
well-shaped paragraphs instead of five labeled subsections.

## Theorem and proof architecture

- Lead with the form of the result that carries the contribution—qualitative
  structure or exact classification. Put only genuinely secondary histograms,
  orbit ledgers, or machine-readable refinements in a corollary, table, equation,
  or appendix.
- Keep one theorem focused on one conceptual scale. Split global classification,
  local stability, and embedded perturbation results when combining them hides
  the headline.
- Before a proof, identify any classical result on which it depends and any
  exhaustive finite step. Inside the proof, say exactly where each enters.
- For a substantial proof, provide a strategy paragraph or section that gives
  the honest causal picture rather than a list of lemma numbers. Name the step
  at which a plausible naive argument fails or the genuine bottleneck begins.
- Separate conceptual reduction from finite exclusion with visible paragraphs,
  lemmas, or proof headings.
- Expand genuine bottlenecks. Compress routine algebra and standard reductions.
- Before a subtle step, give one sentence of orientation; after it, state the
  mathematical gain if that gain is not already visible. Give routine steps no
  ceremonial commentary.
- Avoid “clearly,” “obviously,” and “it follows” when the omitted bridge is the
  point a referee is likely to test.
- Do not interrupt proofs with checker filenames, hashes, archive promises, or
  novelty defenses.

## Computational and formal evidence

A computer-assisted paper should distinguish:

1. mathematical statements proved in the text;
2. classical results imported by citation;
3. kernel-checked formal proofs;
4. certificate-checked computations; and
5. trusted program executions or symbolic calculations.

State explicitly when these categories interact. For every essential finite
computation, record the mathematical search domain, completeness or termination
argument, symmetry reduction, deduplication, exact-arithmetic assumptions, and
acceptance criterion. Identify the artifact and entry point, toolchain version,
inputs, deterministic seed or nondeterminism policy, expected output, resource
requirements, and archival version. Say whether the claim is certificate-checked,
independently reproduced, or trusted as an execution.

Give the body enough information to understand completeness; give the verification
section or appendix enough information to reproduce it. A central computation may
need an algorithm box, lemma, or compact prose description. Artifact names may
appear beside the exact claim they certify when that improves auditability, but
filenames, hashes, and commands should not interrupt a mathematical proof.

For a formal result, name the formal theorem and toolchain; report axioms,
admitted declarations, unsafe or native execution, external computation, and
generated certificates. Explain the lemma or correspondence that connects formal
definitions to the paper statement. “Verified in Lean” is not a trust statement.
Avoid repeating the same verification note after every result. Mention a
substantial formalization once in the abstract or introduction, matter-of-factly;
link a stable repository or archival release and say exactly which paper
statements it covers. Do not use the artifact rhetorically as proof that doubt is
impossible.

Formalization changes the division of labor but does not remove authorial
responsibility. The artifact checks a formal statement within an explicit trust
base; the paper must still communicate the idea and justify the correspondence
between its definitions and the formal ones. When machine or AI assistance was
used, required disclosures should be factual and brief. Mathematical command
should be evident in the exposition. Choose the right example, warn the reader
at the right place, describe the difficulty honestly, and arrange the proof so
that its idea is visible.

## Literature, novelty, and tone

- Cite the source that proves the statement actually used, preferably at theorem
  or page level.
- Verify citations used in a proof against the original source, including
  hypotheses and conventions. Cite secondary accounts for exposition, not as
  evidence for a stronger theorem than they establish.
- Distinguish “known object,” “known classification,” “known raw data,” and “new
  interpretation or consequence.”
- Treat related work as part of the proof of relevance. Search it
  scrupulously, describe neighboring results at their strongest accurate level,
  and be generous about precedence and influence. Never manufacture contrast by
  weakening another paper's theorem or omitting a close predecessor.
- State priority boundaries once and neutrally. Repeated disclaimers sound
  defensive and obscure the contribution.
- Do not describe neighboring work at length merely to explain that it studies a
  different object. One sentence or a footnote is usually enough.
- Avoid venue-directed prose (“the framing this venue expects”) and review-dialogue
  residue (“to address a possible objection”). State the mathematical reason
  directly.
- Do not call a result novel without a proportionate literature check.

## Terminology and notation

- Introduce one notation for one role and reuse it consistently.
- Avoid near-synonyms for technical objects unless the equivalence is itself
  useful across disciplines.
- When two established terms differ by discipline, give both once and choose one
  locally: “extension locus (projective deep-hole syndrome locus).”
- Warn once about a likely ambiguity, close to first use. Do not build several
  defensive remarks around similar terms.
- Define acronyms at first use unless they are universal for the target venue.
- Prefer semantic notation over notation tied to an implementation.
- Before they are needed, state domains, quantifiers, equivalence relations,
  action conventions, projectivization conventions, and excluded degenerate
  cases. Keep theorem statements, examples, tables, computations, and formal
  definitions synchronized.

## Figures, tables, and exact data

Use a figure when it explains an incidence structure, correspondence, orbit
relationship, or proof mechanism that prose cannot show as quickly. Every figure
must have a job in the argument, remain legible at publication size, and remain
interpretable without color alone. Captions should define visual encodings and
state the mathematical point of the figure.

Use tables for repeated comparisons, trust maps, class distributions, and exact
mappings. Lead with the conclusion the table supports. Do not force readers to
extract the theorem from a histogram.

Captions should be intelligible without repeating the surrounding paragraph.
Check float placement and accessibility in the rendered PDF, not only the source.

## Sentence and paragraph discipline

- As a diagnostic, assign each paragraph one principal rhetorical job. A paragraph
  may join setup to its immediate conclusion when the link is the point.
- Put the topic sentence first unless a short setup is genuinely necessary.
- Prefer verbs to nominalizations and direct statements to metacommentary.
- Break sentences that carry a claim, qualification, citation history, and
  consequence simultaneously.
- Remove phrases such as “it is worth noting,” “for completeness,” “in the best
  possible way,” and “we emphasize that” unless the emphasis changes how the
  result must be read.
- Avoid the generic register common in chatbot output. Corpus studies repeatedly
  single out “delve,” “intricate,” “meticulous,” “pivotal,” and “underscore.”
  Other excess words include “comprehensive,” “crucial,” “enhance,” “insights,”
  “nuanced,” “showcase,” “realm,” “seamless,” “unveil,” and “utilize.” None is
  forbidden when it is exact. Clusters, repetition, and ornamental use call for
  revision.
- Check the syntax as well as the vocabulary. Instruction-tuned models favor
  noun-heavy prose, nominalizations, present-participial clauses, and phrasal
  coordination. Rewrite stacked abstractions; repeated “..., highlighting ...”
  endings; uniform sentence and paragraph shapes; automatic transitions such as
  “Moreover” and “Furthermore”; and stage labels that tell readers what the
  section is doing after its structure has made that plain.
- Cut canned rhetorical moves: corrective “not merely X but Y” contrasts,
  habitual groups of three, symmetric mini-slogans, and generic closing claims
  about broad significance. State the point directly.
- Use these features as revision prompts, never as an authorship detector. The
  corpus evidence describes population-level patterns; a word or construction
  cannot establish how an individual passage was written.
- Avoid architectural metaphors for logical dependence. Name the theorem,
  hypothesis, computation, or inference that is actually needed.
- Parentheses should clarify locally, not contain a second argument.
- Lists should reveal parallel structure; they should not substitute for
  hierarchy.

## Conclusions and open problems

End mathematically, not administratively. A verification appendix or trust table
should not be the reader's final impression.

When a paper benefits from a conclusion, it should:

- restate the conceptual bridge rather than repeat the abstract;
- explain what the central construction or exceptional example teaches about the
  broader phenomenon;
- separate proved boundaries from plausible extensions;
- formulate a small number of concrete open problems with enough context to be
  actionable.

## Revision and review protocol

Before submission:

1. Read only the theorem statements and section openings. They should tell a
   coherent story.
2. Read paragraph by paragraph and name each paragraph's job. Merge, move, or cut
   paragraphs without a unique job.
3. Review the diff for accidental changes to hypotheses, quantifiers, notation,
   citations, and mathematical claims.
4. Build from clean source; inspect warnings, references, page count, floats,
   tables, and figures.
5. Ask a mathematically qualified cold reader to report both strong passages and
   points of friction. Do not show that reader the previous review.
6. Address high-impact hierarchy and comprehension problems before polishing
   isolated sentences.

Before submission, ask an expert in either primary discipline to find the main
theorem, follow every language change, identify the trust boundary, and skip
secondary detail without losing the argument.

The checklist for chatbot-like prose draws on corpus work by
[Kobak et al.](https://doi.org/10.1126/sciadv.adt3813),
[Juzek and Ward](https://aclanthology.org/2025.coling-main.426/),
[Reinhart et al.](https://pmc.ncbi.nlm.nih.gov/articles/PMC11874169/), and
[Kousha and Thelwall](https://doi.org/10.1007/s11192-026-05601-5).
