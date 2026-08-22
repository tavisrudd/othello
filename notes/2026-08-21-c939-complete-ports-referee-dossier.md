# C939 complete repair ports — cold-referee dossier

Date: 2026-08-21

This packet defines the independent review protocol for the C939 revision of
*Complete Bounded Repair Ports: Transfer, Reliability, and Geometric
Structure*. It is context, not a review report. Reports belong in separate
dated C939 notes.

## Frozen reading copy

- PDF: papers/complete-repair-ports/complete_repair_ports.pdf
- Paper-path commit: 3c5d6cf5dfcf49b70bad7e146ac2419a8d3c0cff
- PDF SHA-256:
  62fdcd7f0a9875e3b8d7a17dce415cedd0c7937b8aea5b83b64155b1d5eab7be
- Length: 22 pages.

The referee reads the PDF first. Source, control ledgers, previous C678
reviews, and this task's proof notes remain hidden until the PDF verdict is
written.

## C939 delta under review

The revision promotes one theorem chain:

1. two explicit rank-four sparse-paving seeds over \(\mathbb F_7\) have the
   same complete pointed subset profile;
2. their two target circuit-hyperplanes have different intersection patterns,
   giving radius-three reliability \(2s^3-s^6\) versus \(2s^3-s^5\);
3. both inner codes have parameters \([7,4,3]_7\), dual distance four, and
   exact pointed zero-functional cost \(z_0=8\);
4. one common asymptotically good \(\mathbb F_{7^4}\)-linear outer family
   therefore gives matched concatenated formulas \(7N,4K_N,d\ge3D_N\); and
5. exact radius-three support and coefficient ports occur at every target in
   a designated class of density \(1/7\).

The paper explicitly does **not** claim that the two large concatenated codes
have the same full pointed-Tutte invariant. Full pointed-profile equality is
a seed statement. It also explicitly records unmatched availability: two for
the disjoint seed and one for the overlapping seed.

## Required falsification attempts

The referee must try to break each of the following:

- Does the sparse-paving count really determine the complete pointed profile
  from only the two circuit-hyperplane counts?
- Do the displayed minor data prove both primal distance three and dual
  distance four?
- Does a target circuit-hyperplane prove \(\mu_0(0)=4\), rather than only an
  upper bound?
- Is the transfer inequality correctly translated as \(r+1<z_0\), and does
  \(r=3,z_0=8\) clear it?
- Can one outer family be used for both inner encoders without changing the
  length, dimension, or distance-bound formulas?
- Does exact port equality preserve the two reliability polynomials after
  coordinate relabeling?
- Does any sentence accidentally promote seed-level pointed-profile equality
  to a full invariant of the concatenated codes?
- Does the synthesis corollary claim any datum not functorially determined by
  the exact bounded support/coefficient port?

## Review outputs

### Cold correctness report

Return GO, MINOR, MAJOR, or BLOCK; identify the strongest proof mechanism and
first confidence drop; list every required correction with page and theorem
label; separate correctness, missing proof, scope, formal correspondence,
reproducibility, and exposition; and state the result of each falsification
attempt.

### Percentile and upgrade report

Score the revision against:

- annual papers in coding theory/local repair with finite-geometry or matroid
  methods; and
- annual mathematics papers generally, for dimensions that transfer across
  specialties.

Give ranges and best estimates for correctness, theorem novelty, conceptual
originality, technical depth, proof completeness, specialty significance,
breadth, exposition, examples/formal support, reproducibility, and overall
strength. Then give a prioritized list of upgrades that would both unify and
strengthen the paper, with estimated percentile lift, effort, and risk.

## Release gate

The revision may be exported only after:

1. the cold correctness report has no blocker;
2. every required correction is resolved and rebuilt;
3. the formal gate and public finite replay pass;
4. a fresh reread of the corrected PDF finds no correctness blocker; and
5. the reviewed commit, PDF hash, and standalone export agree.
