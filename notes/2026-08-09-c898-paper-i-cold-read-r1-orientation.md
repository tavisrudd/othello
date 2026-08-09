# C898 Paper I cold read, round 1 — orientation

**PDF SHA-256:** `95ccf1ff32180fd806608002d69a912c5a1aae26a8fb5778d553a88b62803d83`  
**Persona packet:** Packet H — Haemers/Gillespie orientation read  
**Initial human-proof verdict:** **MINOR**

## Strongest theorem

On the assigned surface, the strongest theorem I believe the paper proves is Theorem 8.1 together with the commutant part of Corollary 8.2: the reconstructed syndrome and decoder data determine an unordered orientation torsor on six axes, equivalently the two support-orbit signs and a pair of opposite switching classes `[B]`, `[-B]`, with `B^2=5I`; triangle products recover the support cubic, the diagonal determinant pencil recovers the same cubic, and the intrinsic odd-lattice commutant is `Z[B] \cong Z[\sqrt5]`. The singular-node and full projective-symmetry assertions of Corollary 8.2 are credible, but their human-readable proof is less complete than the proof of the orientation theorem itself.

## Causal proof reconstruction

Nearest-weight-two ambiguity recovers the ten Brianchon points and the ten perfect matchings outside the invariant total of five self-polar matchings. Pairing two matchings in that total gives an alternating six-cycle; its alternating vertex classes identify each Brianchon point with a complementary pair of three-supports, producing the unordered `10+10` support split.

The twelve conic points form an `A5/C5` set. Pairing the two fixed points of each Sylow `5`-subgroup gives the six-axis quotient `A5/D5`. Either five-valent orbital on the twelve points acts on fibre-odd functions as a symmetric zero-diagonal sign matrix `B`; changing fibre representatives gives `DBD`, while exchanging the two orbitals gives `-B`. After fixing one fibre and gauging its five incident signs positive, the remaining signs are the sides versus diagonals of a pentagon. This gives `B^2=5I`.

The switching-invariant triangle products `B_ij B_jk B_ki` are constant with opposite signs on the two complementary `A5`-orbits of triples, so they equal the support-cubic coefficients after the unavoidable overall sign choice. Conversely, the four-point two-graph identities recover the switching class, and signed pair balance recovers `B^2=5I`. Principal-minor expansion plus Jacobi's identity then gives the displayed diagonal determinant pencil.

Finally, the cubic's six claimed nodes recover the axis frame; frame permutations reduce its projective automorphism group to the normalizer `S5`, with the sign-preserving subgroup `A5`. Over `Q(\sqrt5)`, the odd module splits into the two conjugate three-dimensional icosahedral modules, so Schur descent gives `End_{Q A5}=Q[B]`; diagonal and off-diagonal entries then cut the integral order down exactly to `Z[B]`.

## Earliest unsupported implication

The first implication I could not justify from the displayed paper alone occurs in the proof of Proposition 7.3 (p. 16): from the degree-six `A5` action the text asserts a unique preserved total of five perfect matchings, preservation by the full exotic `S5` normalizer, and exchange of the two support orbits by its outer coset. These are small, true-looking permutation claims, but Figure 1 lists the matchings without displaying generators or an action table that verifies all three assertions.

## Controlling findings

1. **Exposition / finite witness.** Proposition 7.3 and the frame-symmetry paragraph rely on the action of the exotic normalizer on the five matchings and the two triple orbits. The later phrase “the displayed table supplies normalizers” has no corresponding generator/action table in the PDF. A compact table of two generators on coordinates, matchings, support classes, and the cubic sign would close both uses.

2. **Computation / proof exposition.** The singular-locus exhaustion on p. 21 is stated rather than shown: after mentioning differentiation of `det(\Phi_x)=-C(x)`, the text says that the five quadrics vanish exactly on the six centered axes and points to kernel-checked declarations. This is load-bearing for recovering the node frame and hence for the `S5` projective-symmetry conclusion. It is not evidence against correctness, but it is a missing human-proof bridge in the PDF.

3. **Citation / novelty boundary.** `B` is a symmetric conference matrix of order six. Haemers--Parsaei Majd explicitly record that every order-six conference matrix is Paley up to switching and simultaneous permutation. The manuscript constructs the matrix and proves the needed identity, but never names this classical identification or cites the small-order uniqueness; doing so would make clear that the new content is intrinsic recovery and synchronization, not a new order-six conference object.

4. **Normalization.** The sentence “Negation is the switching `D_0=1, D_i=-1`” on p. 20 is too compressed: global negation is not itself switching here; rather, one negates `B` and then applies that switch to return to the gauge `B_0i=1`, replacing the pentagon by its pentagram. The surrounding enumeration reaches the correct conclusion that `[B]` and `[-B]` are distinct and pair the twelve switching classes into six unoriented classes.

## Novelty relative to Packet H

Relative to the classical two-graph, conference-matrix, and synthematic-total material in Packet H, the new contribution is the intrinsic recovery of the classical order-six orientation class from decoder/support data and its synchronization with the support cubic, determinant pencil, and integral order `Z[\sqrt5]`.

## Frozen initial conclusion

**MINOR.** I found no false sign, equivalence, or commutant statement in the assigned chain. The orientation theorem is causally reconstructible from the text; the controlling defects are the absent finite action witness, the compressed singular-locus exhaustion, the classical conference citation boundary, and one misleading normalization sentence.

## Public-supplement postscript

After freezing the report above, I inspected and ran only the permitted Paper I supplement `papers/clebsch-rigidity/check_orientation_two_graph.py` (SHA-256 `fa6f415debda3fc5963b55933371ffcba8e1cd32a825581d6fe0b0d09a2b2c3b`). Its exact replay succeeds. It constructs the `A5/C5` and `A5/D5` actions, derives the fibre-odd operator, checks `B^2=5I`, the `10+10` triangle signs, complement reversal, all four-point identities, pair balance, and the twelve switching gauges. It also enumerates oriented and unoriented cubic stabilizers of orders `60` and `120`. This resolves the mathematical correctness concern behind finding 1, though the PDF still lacks the promised compact witness.

The same checker computes reduced Gröbner bases on all five projective charts, obtains exactly the six axis nodes, checks Hessian rank four at each, verifies the projective-frame condition, and recounts the automorphism groups. This resolves the correctness concern behind finding 2, while leaving the human-proof compression in the paper. It does not resolve the missing classical order-six Paley/conference citation or the misleading negation sentence. The categorical verdict remains **MINOR**.
