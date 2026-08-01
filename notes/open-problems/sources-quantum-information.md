# Source catalogue: quantum information

## QI-IQOQI-maintained

IQOQI Vienna, *Open Quantum Problems*, maintained list begun by Reinhard Werner
and maintained by IQOQI since 2017.

- Source: https://oqp.iqoqi.oeaw.ac.at/
- Institutional description:
  https://www.iqoqi-vienna.at/detail/news/open-quantum-problems
- Kind: living, community-curated problem list.
- Scope: specific questions of general interest across quantum information.
- Read depth: `secondary only` through the IQOQI institutional description;
  the list endpoint returned HTTP 502 on 2026-07-31.
- Coverage gap: current entries and status annotations not yet captured.

## QI-2022-five-problems

Paweł Horodecki, Łukasz Rudnicki and Karol Życzkowski, *Five Open Problems in
Quantum Information Theory*, PRX Quantum 3 (2022), 010101.

- Stable ID: DOI `10.1103/PRXQuantum.3.010101`.
- Source: https://doi.org/10.1103/PRXQuantum.3.010101
- Kind: curated list of five well-known difficult problems.
- Read depth: `partial`, abstract, popular summary and problem synopsis.

The five problems concern:

1. SIC generalized measurements in infinitely many dimensions;
2. a complete set of mutually unbiased bases in dimension six;
3. measurements saturating the multiparameter Cramér--Rao bound;
4. negative-partial-transpose bound entanglement;
5. two-copy distillability of a specified two-ququart state.

## QI-2025-transversal-review

*Review of recent progress in constructing codes with transversal non-Clifford
gates*, Perimeter Institute Recorded Seminar Archive, 2 April 2025,
PIRSA:25040104.

- Stable ID: DOI `10.48660/25040104`.
- Source: https://pirsa.org/25040104
- Kind: recent review talk explicitly advertising remaining open problems.
- Scope: asymptotically good quantum codes and transversal non-Clifford gates,
  especially algebraic-geometric constructions and transversal CCZ.
- Read depth: `abstract/metadata only`; slides/problem statements pending.

This entry's original broad framing is now stale: asymptotically good codes
with transversal CCZ existed in 2024, and addressable asymptotically good qubit
codes appeared in 2025.  The live asymptotic gap adds qLDPC and linear distance.

## QI-2024-good-transversal

Louis Golowich and Venkatesan Guruswami, *Asymptotically Good Quantum Codes
with Transversal Non-Clifford Gates*, arXiv `2408.09254`.

- Source: https://arxiv.org/abs/2408.09254
- Kind: frontier-changing construction.
- Read depth: `partial`, introduction, parameter statement and open-problem
  discussion inspected.  Cached SHA-256
  `8cdb9faa66eebce46087d7156bb8316feaf2e89f0fe818f0a421c445be31f08d`.

The construction gives asymptotically good codes with transversal CCZ for
every fixed prime-power alphabet, including qubits.  The paper leaves LDPC and
finite-size/practical constructions as open directions.

## QI-2025-addressable-transversal

Zhiyang He, Vinod Vaikuntanathan, Adam Wills and Rachel Yun Zhang,
*Asymptotically Good Quantum Codes with Addressable and Transversal
Non-Clifford Gates*, arXiv `2507.05392`.

- Source: https://arxiv.org/abs/2507.05392
- Kind: frontier-changing construction.
- Read depth: `abstract/metadata only`.

The abstract reports the first asymptotically good qubit family with
transversally addressable CCZ.  Addressability should therefore not be listed
as broadly open without additional LDPC, decoder or implementation conditions.

## QI-2026-almost-good-qLDPC-transversal

Yiming Li, Zimu Li and Zi-Wen Liu, *Transversal non-Clifford gates on
almost-good quantum LDPC and quantum locally testable codes*, arXiv
`2604.01874`.

- Source: https://arxiv.org/abs/2604.01874
- Kind: current boundary construction.
- Read depth: `abstract/metadata only`.

The source reports bounded-check-weight families with linear rate,
`tildeTheta(N)` distance and transversal multi-controlled `Z`.  The remaining
clean asymptotic target is linear distance while preserving the gate and LDPC
structure.

## QI-2025-QPIC

IEEE ISIT 2025 workshop, *Quantum Information: Open Problems, Impact, and
Challenges (Q-PIC)*.

- Source: https://www.itsoc.org/group/isit2025-workshop-quantum-information-its-puzzles-impact-and-challenges
- Kind: recent workshop organized around open questions.
- Scope: quantum security, nonlocality, error correction, sensing and networks.
- Read depth: `abstract/metadata only`, workshop description and scope.
- Status: lead only; no durable proceedings-level problem list located yet.

## QI-2025-QuIK

IEEE Information Theory Society report on the ISIT 2024 Quantum Information
Knowledge workshop, published 2025.

- Source: https://www.itsoc.org/newsletter/article/report-2024-isit-workshops
- Kind: workshop report.
- Scope: foundational and practical QEC/FTQC questions.
- Read depth: `abstract/metadata only`, workshop report.
- Status: lead only; the public report confirms an open-problem panel but does
  not enumerate its questions.
