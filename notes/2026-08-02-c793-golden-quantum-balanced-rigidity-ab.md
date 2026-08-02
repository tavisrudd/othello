# C793 — Golden quantum balanced-rigidity A/B integration

**Lane:** `golden`

**Status:** complete; rigidity variant selected, repaired, and accepted

## Outcome

The rigidity-and-design variant B beat the frozen hierarchy-first baseline A.
The blind PRA comparison graded A at B and B at B+, selecting B because the
conference-rigidity theorem gives the paper a sharper mathematical headline
without displacing the observable hierarchy or the experimental boundary.
After referee repairs, a fresh selected-PDF reader graded the paper A-minus
(9/10), accept.  A final local cold read restricted to the approved title and
abstract also returned A-minus, accept with minor clarification; all three
clarifications were applied.

The approved title is

> *Orientation, exchange statistics, and rigidity in the Golden six-mode
> conference interferometer*.

The final semantic artifact is
`golden-quantum-statistics-rigidity-referee-approved` at commit `b0fb4007`.
The authoritative PDF has 14 pages, 127,436 bytes, and SHA-256
`877e9e6b0c418c23a30852c18129ef1587cc3160effd49984377fc0903e72a6b`.

## Frozen comparison

- Baseline A: `golden-quantum-statistics-observable-hierarchy-selected`, PDF
  SHA-256
  `20cbfa987ad87be5ab038f11a1848bcadb9739e28c3d356e649d7b9c400ef330`.
- Tested B: `golden-quantum-statistics-conference-rigidity-candidate` at
  `e0b9b17c`, PDF SHA-256
  `c0bde7c7d819518ba62537b400bfb30b30999c4328ee4c298d8db34fd2c3cb3d`.
- Repaired selection before title/abstract polish:
  `golden-quantum-statistics-rigidity-selected` at `7a89d44a`.
- Final approved selection:
  `golden-quantum-statistics-rigidity-referee-approved` at `b0fb4007`.

The blind files used descriptive aliases, `orientation-hierarchy` and
`conference-rigidity`, with no task identifier or private path exposed to the
reader.

## Mathematical-physics red team

The formulas and classification survived.  The repair pass:

- made the conference-rigidity proof self-contained through the commutator,
  cross-Gram spectrum, four-walk identity, inclusion-matrix injectivity,
  switching, and the Ramsey obstruction;
- stated the complement convention, small-order cases, and principal-angle
  meaning explicitly;
- retained the exact purity quantization and order-ten 36/90 split;
- credited the aligned design to Greaves--Suda and the mean/variance mechanism
  to classical Johnson inclusion calculus; and
- demoted C794's labelled inverse theorem to a collective-boundary remark.

The general theorem is now locally assessable.  Paper III is an exact parallel
source rather than an opaque proof dependency.

## Quantum-optics red team

The audit found two latent physical defects and the selected manuscript fixes
both:

- intensity or input-interference tomography alone cannot determine output
  row phases or determinant sign, so the protocol now requires complex-field
  measurement against a common local oscillator and a common input--output
  phase calibration;
- the balanced direct transfer has determinant minus one, so its compilation
  needs one sign flip (a pi phase) per copy in addition to 15 Givens rotations,
  for 45 Givens rotations and three phases across three copies.

The repaired text also distinguishes determinant amplitude from counting
probability, uses the normalized antisymmetric output projection with no
spurious factorial, states the exact safe determinant threshold
`4/(15 sqrt(5))`, and keeps every direct-fermion trial budget conditional on
an externally supplied antisymmetric three-photon qutrit source.

## Blind-referee repairs

The winning variant was promoted from B+ to A-minus by:

- supplying the self-contained rigidity proof;
- keeping the higher-order aligned-design statistics subordinate;
- separating mixture target weight from squared Uhlmann fidelity;
- distinguishing the collective C794 inverse from a local observable; and
- aligning title and abstract with the paper's actual theorem hierarchy.

The final abstract-only cold reader found no title mismatch or material
omission.  Its minor repairs restored the determinant theorem's “up to scale”
qualification, named `313/125` as a symmetric-cube trace and `16/125` as a
filled-fermion probability, and separated the six Joubert amplitudes from the
six length-ten protocol sign words of pairwise Hamming distance six.

## Trust and scope

- Human proof: observable hierarchy, minimal determinant degree, cross-Gram
  formula, rigidity classification, and order-six benchmark.
- Classical citation: Greaves--Suda aligned 3-design, Johnson inclusion
  calculus, and the inclusion-matrix rank theorem.
- Paper-local exact evidence: the 20 balanced and 44 unbalanced masks,
  exchange traces, permanent values, chiral filter, decoder, and 15-cell
  compilation.
- Imported manuscript boundary: Paper III's aligned-design faithfulness is
  cited only as a subordinate collective inverse corollary.
- External experimental dependency: no characterized totally antisymmetric
  three-photon qutrit source is claimed.

## Validation

- Authoritative package: `make check` passed after the final abstract repair;
  the warning-free build produced 14 pages.
- Evidence: `python3 verification/verify.py --check` passed.
- Extracted tagged package: `make check` passed from
  `/tmp/golden-final-extract.wShvUv` with no repository auxiliaries.
- Final selected PDF: 127,436 bytes; SHA-256
  `877e9e6b0c418c23a30852c18129ef1587cc3160effd49984377fc0903e72a6b`.

The extracted PDF differs bytewise because the TeX backend embeds
build-dependent metadata; the full mathematical and packaging gate passes.

## `ej` + `tt` closeout

The closeout exposed five cheap gains, all taken: a self-contained rigidity
proof, explicit least-degree lower bound, complement/projective-cut
conventions, exact order-ten purity strata, and experimentally correct phase
and parity requirements.  The final abstract cold read then removed the last
amplitude/sign-code ambiguity.

### Mystery ledger

- **Why order six is unique:** settled by inclusion descent plus the
  `R(3,3)=6` obstruction.
- **What survives at higher order:** settled as a universal statistical
  envelope, not a universal spectrum.
- **Whether the full labelled landscape recovers orientation:** settled at
  the discrete signing level up to complement/global negation by C794, but it
  remains a collective inverse and not a local orientation observable.
- **Physical sign access:** settled as requiring common-reference coherent
  calibration; probabilities alone remain sign-blind.
- **External source performance:** intentionally open and externally owned;
  the paper states a design limit rather than certifying a source.

No genuine task-owned mathematical mystery remains.  Adversarial certificate
distance belongs to C794, and source development belongs to a separately
allocated experimental task.  The red-team findings were sought deliverables,
so the discovery-track discriminator produces no incidental-log entry.

## Vibe

The variant earned its broader title: the paper now has a memorable general
rigidity theorem, an exceptional Golden endpoint, and a clean laboratory
boundary without pretending that any one layer proves the others.
