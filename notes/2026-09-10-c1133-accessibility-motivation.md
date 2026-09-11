# C1133 — accessibility, motivation and literature positioning

**Lane:** `cubic-threefolds`. **Date:** 2026-09-10.
**Scope:** author-requested revision of the primary one-stabilization paper
against `papers/style-guide.md`, followed by explicit motivation and
literature-positioning scrutiny. This is an editorial pass, not a new
mathematical acceptance or exhaustive priority audit.

## Reader and hierarchy

Primary audience: birational geometers. Adjacent audience: Hodge theorists
and algebraic geometers unfamiliar with formal quantum connections.
The title remains *Irrationality of Cubic Threefolds after One Stabilization*.
The abstract is the approved replacement, below 200 words (125
whitespace-delimited source tokens when TeX math expressions count as one).
It gives the cubic result, Fano scope, center-vanishing mechanism and rational
Hodge refinement without importing the local selection criteria.

The opening explains why the dimension of the stabilizing factor matters.
The classical surface-center obstruction is explained after the theorem and
its numerical mechanism. The stable-rationality paragraph retains both the
very-general obstruction and stably rational examples: the uniform first-step
result applies to both. The Fano extension covers the complete classification.
Hodge conservation is motivated by distinguishing irrational products and,
with a separate rational Torelli input, recovering a very general hypersurface
among smooth hypersurfaces of the same degree.

## Changes and scope control

- Replace repeated introductory summaries with the geometric mechanism.
- Gloss primary factors, regular gauges and the original power-series lattice.
- Remove unused marked-grading generalities from the main block definition;
  retained data, regularity requirements and the optional appendix remain.
- Identify the coefficient-domain definition by section reference.
- Flag the rank-three persistence lemma as skippable for the cubic theorem.
- Open Hodge conservation with two-copy recovery, center vanishing,
  cancellation and rational descent, before the common-group construction.
- Replace the ambiguous theorem reference and name the companion by title.
- Keep the introductory Fano theorem and the endpoint statement/table together
  across page breaks.
- Credit three previously audited close sources in the introduction and
  bibliography. Update the owning ledger's integrated status and repeating
  surfaces; no firstness or exhaustive absence claim is introduced.

Theorem environments, stable semantic labels and formal annotation commands
in the edited sources were compared with the pre-revision source and are
unchanged. The full fixed-base comparison, all-member qualifications,
canonical-lattice requirements and rational/integral distinction remain.
No fresh kernel replay or formal coverage promotion is claimed.

## Literature evidence

**New full-paper reads in this pass: zero.** The positioning reuses one
previous full-text read and two partial reads, with the following original
passages reconsulted from the shared cache. The complete source register
remains `2026-09-09-c1133-literature-sources.json`; its nine external full-text
reads are not increased by this pass.

| Source and version | Read depth and exact basis | Attribution used |
|---|---|---|
| Katzarkov–Lee–Svoboda–Petkov, *Interpretations of Spectra*, published 2023, DOI `10.1007/978-3-031-17859-7_20` | Full text at the prior checkpoint (all 37 pages); title/publication page and pp. 375–376 reconsulted here, extracted lines 1–36 and 245–320 | Cubic exponent representatives are prior work |
| Cavenaghi–Katzarkov–Kontsevich, *Atoms meet symbols*, `arXiv:2509.15831v4` | Partial; this pass reconsulted lines 1–48, 185–295 and 1739–1785: Theorems E/F/H and Example 2.19 | Atomic doubling under a projective-line product obstructs equivariant linearization; curve-Jacobian isogeny classes enter equivariant threefold invariants |
| Benedetti–Guéré–Manivel–Perrin, *Quantum cohomology and birational geometry of Verra fourfolds*, `arXiv:2605.30450v1` | Partial; lines 1–95 reconsulted, including Theorem 1 | Rational-Hodge restrictions on cubic/Gushel–Mukai fourfold partners of Verra fourfolds are prior work |

Cached PDF SHA-256, respectively:

- `62c7f8f01c91b71bc499c534089cb2a4022f94faecbf7a8ac7661b9c44267754`
- `cb4260a1f7e1407e9dda5c090d82f0cef99bfb7c704363c518d00c36b8614119`
- `623d505a6e7de518e58d05fccc817ec7f56d795af09e681bbbcc390e00621e51`

Cache keys are the DOI/arXiv identifiers in the table. No new remote fetch,
citation-graph screen or negative search was performed. All new manuscript
source characterizations paraphrase the existing owning novelty-ledger
comparisons. The concrete scope of this paper is stated positively;
source-specific comparisons do not establish global priority.

Primary manuscript and ledger are updated. The framed companion and external
summaries are outside this revision; their pending older-source attribution
is explicitly retained in the ledger. Public synchronization is recorded below.

## Validation and release

Authority `make check` passes: spacing lint, source-only formal correspondence,
universal residue check, both Fano arithmetic replays/checksums, deterministic
PDF build and TeX warning rejection. Final layout adjustment was followed by
a complete `make check` (2026-09-10 21:36 UTC). All 32 final pages were inspected
in eight four-page contact sheets; the two identified theorem/table breaks
are repaired. Ordinary paragraph and proof continuations remain.

Final PDF: **32 pages, 248166 bytes**. The cubic proof still ends on page 13;
Part II begins on page 17 and finishes with C on page 21. Typography is unchanged.
SHA-256: `bb1823414921aef935a6de93d1b226c16156fe3b90f196d891d8513c2e334715`.
The pre-revision 32-page PDF is recoverable from `27d59bfd0^`; the initial
accessibility-only revision is commit `27d59bfd0`. The combined motivation
revision and its PDF are committed together with this report.

Standalone synchronization and replay are recorded in the final closeout below.

## EJ + TT closeout and mystery ledger

The inexpensive improvement was moving the surface-center explanation after
the principal theorem, where it explains the actual difficulty, and making
Hodge conservation answer a recovery question. Red-teaming the recovery
sentence supplied its same-degree hypersurface boundary. The older exponent
attribution and two close atomic/Hodge precedents prevent the exposition from
implying ownership of the general methods.

No new mathematical mystery arose from this editorial work. Remaining gates
are the already recorded bounded source/priority coverage, the companion's
separate attribution work, and author publication review. A fully blinded
specialist/adjacent-reader comparison remains a publication gate; this
root-agent revision is not a cold or blind assessment. C1133 remains active.
