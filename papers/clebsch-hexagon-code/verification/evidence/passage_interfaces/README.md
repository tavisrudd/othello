# Passage-interface evidence

This bundle supplies deterministic finite evidence for the paper's theta, Fourier, code-transport,
fixed-party, and bitorsor boundary statements.

- `theta-matching.py` reconstructs matching Lagrangians, finite quadratic refinements, and their
  value histograms from `matching-orbits.json`.  The divisor-theoretic interpretation uses David
  Mumford, *Tata Lectures on Theta II* (1984), Proposition 6.1, pp. 3.95--3.97.
- `fourier-weil.py` reconstructs the displayed rank-eight and rank-sixteen Fourier matrices from
  the separately frozen scheme and common-duality tables and checks their square, trace, and
  weighted-adjoint identities.  The input tables' geometric meanings remain external semantic
  inputs.
- `quantum-state-equivalence.py` and `quantum-family-classification.py` exhaust the stated
  six-party stabilizer-state parameter domains.
- `quantum-chirality.py` compares complete codeword-support transport with the parity-check
  intertwiner.
- `fixed-party-equivalence.py` independently compares the character-sum support argument with a
  complete transition-forced local-Clifford search while preserving party labels.

Run `python3 verify.py`.  The command first checks every tracked source and certificate against
`manifest.sha256`, then regenerates and compares each derived certificate.  These checks establish
the displayed finite tables and exhaustive searches.  They do not establish superspeciality,
divisor-theoretic theta semantics, a canonical geometric reconstruction of every matching, an
ambient Schrödinger/Weil normalization, or classification under arbitrary complex local unitaries.
