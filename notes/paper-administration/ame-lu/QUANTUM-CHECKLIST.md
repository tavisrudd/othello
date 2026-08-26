# Quantum submission checklist

Checked against Quantum's author instructions and arXiv's submission
instructions on 2026-07-24.

Status: **policy-compatible local candidate; author and account gates open**

## Manuscript and artifact

- [x] The main theorem and its hypotheses appear on the first page.
- [x] The manuscript has no journal-specific length or format conflict.
- [x] The preprint source has a deterministic paper-only export.
- [x] The evidence supplement has a complete hash check and full replay.
- [x] The formal companion is fixed by exact file and toolchain hashes.
- [x] Bibliography entries with DOIs contain DOI links.
- [x] An independent mathematical cold read returned GO for the
  content-identical manuscript.
- [ ] Add the mandatory author-contribution statement.
- [ ] State the scope of language-model assistance in that contribution
  statement.
- [ ] Insert the stable public repository or archive identifier.

## arXiv and Quantum metadata

- [ ] Confirm author name and order.
- [ ] Confirm affiliation, corresponding email, and ORCID.
- [ ] Confirm funding information or its absence.
- [ ] Confirm acknowledgments and contribution wording.
- [ ] Choose an arXiv license; Quantum publication ultimately requires the
  accepted arXiv version under CC BY 4.0.
- [ ] Confirm `quant-ph` as the primary or cross-listed arXiv category.
- [ ] Confirm the work is not under consideration at another journal.
- [ ] Confirm copyright and supplement-distribution authority.
- [ ] Choose two or three suitable Quantum editors and any suggested referees.
- [ ] Confirm a Scholastica account and explicit submission authorization.

## External actions

- [ ] Upload the arXiv source bundle through the author's account.
- [ ] Select XeLaTeX and `main.tex`; inspect the generated PDF.
- [ ] Record the arXiv identifier in the release metadata.
- [ ] Submit the arXiv identifier to Quantum only after explicit author
  authorization.

No upload, license grant, account change, or journal submission is part of the
local release gate.

## Policy sources

- Quantum, `https://quantum-journal.org/instructions/authors/`
- arXiv submission overview, `https://info.arxiv.org/help/submit/index.html`
- arXiv TeX submission instructions,
  `https://info.arxiv.org/help/submit_tex.html`
