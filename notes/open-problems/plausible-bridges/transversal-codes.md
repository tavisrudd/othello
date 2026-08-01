# Transversal non-Clifford gates versus local AME rigidity

**External ID:** `BIG-709`
**Verdict:** genuine specialist adjacency, but the former headline target has
been solved and the local theorem addresses a disjoint finite family.

## The frontier moved

The 2024 Golowich--Guruswami construction gave asymptotically good quantum
codes with transversal CCZ over every fixed prime-power alphabet, including
qubits.  A 2025 construction added transversally addressable non-Clifford gates
for asymptotically good qubit codes.  Those statements must no longer be listed
as open.

The live asymptotic target is stronger:

> Construct genuinely asymptotically good qLDPC codes—bounded check weight,
> constant rate and linear distance—with a useful transversal non-Clifford
> logical gate, ideally with addressability and practical decoding.

A 2026 cupcap construction reaches `[[N, Theta(N), tildeTheta(N)]]` qLDPC and
qLTC parameters with transversal multi-controlled `Z`: almost-good, but not
yet linear distance.

## Exact local theorem and mismatch

The repository proves that product-unitary equivalences between stabilizer
`AME(2m,q)` states are factorwise Clifford.  Under the Choi correspondence this
controls `[[2m-1,1,m]]_q` quantum-MDS encoders.  For prime-field linear
MDS--CSS codes it also computes exact diagonal transversal groups, with a
larger `F_q^2 semidirect SL_2(q)` branch only under diagonal isoduality.

This is a sharp rigidity/classification theorem, but the code family encodes
one logical qudit and is not an asymptotically good qLDPC family.  It therefore
acts as a no-go boundary, not a construction toward the live famous target.

## What may transfer

- holonomy-centralizer calculations can certify the exact transversal group of
  a proposed finite code;
- the Clifford-rigidity proof may expose which hypotheses a non-Clifford
  construction must violate;
- the Choi/AME formulation can classify small quantum-MDS test cases.

None supplies LDPC checks, constant rate or linear distance.

## Independent attack routes

1. **Upgrade cupcap codes from almost-good to good.**  Improve the covering or
   homological construction so systolic distance becomes `Theta(N)` while
   preserving bounded checks and the nontrivial cupcap gate.  This is direct,
   high-risk and conceptually clean.
2. **Multiplication-compatible expander/AG codes.**  Combine bounded-weight
   quantum Tanner/lifted-product constructions with triorthogonal or
   multiplication-friendly structures.  The hard compatibility is retaining
   both linear distance and a non-Clifford transversal form.
3. **Finite-size exact search.**  Use symplectic normal forms, logical-action
   constraints, holonomy centralizers and SAT to find short qLDPC codes with a
   precisely certified transversal group and decoder.  This is tractable and
   useful, though not a solution of the asymptotic problem.

## Promotion gate

For famous-frontier positioning, require a family with explicit
`(n,k,d)`, check-weight and gate parameters that improves a 2024--2026
benchmark.  For local positioning, the current result can already be presented
as an exact rigidity theorem for the quantum-MDS/AME regime.

## Sources and local audit trail

- Louis Golowich and Venkatesan Guruswami, *Asymptotically Good Quantum Codes
  with Transversal Non-Clifford Gates*, arXiv `2408.09254`; `partial`, cached
  SHA-256
  `8cdb9faa66eebce46087d7156bb8316feaf2e89f0fe818f0a421c445be31f08d`.
- Zhiyang He, Vinod Vaikuntanathan, Adam Wills and Rachel Yun Zhang,
  *Asymptotically Good Quantum Codes with Addressable and Transversal
  Non-Clifford Gates*, arXiv `2507.05392`; `abstract/metadata only`:
  https://arxiv.org/abs/2507.05392.
- Yiming Li, Zimu Li and Zi-Wen Liu, *Transversal non-Clifford gates on
  almost-good quantum LDPC and quantum locally testable codes*, arXiv
  `2604.01874`; `abstract/metadata only`:
  https://arxiv.org/abs/2604.01874.
- `notes/2026-07-25-c649-stabilizer-ame-full-weyl-rigidity.md`.
