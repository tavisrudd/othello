# Adversarial proof and evidence audit

This is the initial referee-facing failure checklist.  A row closes only with a
specific proof location or evidence record.

| Risk | Present status | Closure gate |
|---|---|---|
| “LU=LC” is read as the false global conjecture | closed in Theorem 1.1 and Section 8 | exact linear MDS/equal-phase CSS scope stated at first use and in final boundary |
| Equality of orbit partitions is confused with classification of all LU intertwiners | closed in Theorem 1.1 | headline theorem quantifies over every intertwiner; Corollary 1.2 is separate |
| A Pauli or holonomy signature is used as an arbitrary-LU invariant | closed in Sections 4 and 6 | holonomy used only for LC; LU claims use reduced-operator covariance or basis-free contractions |
| The scalar `z` is claimed LU-complete from finite samples | closed in Sections 3--4 | exact bracket quotient plus uniform LU-to-LC rigidity, not interpolation |
| Exceptional characteristics are silently removed | closed in Sections 4, 7, and 8 | admitted pencil equation and detector-only exception table are explicit |
| The H3/GRS theorem is generalized to the whole pencil | closed in Theorem 6.1 | exact odd good non-GRS H3 domain retained |
| Four-copy rank drop is mistaken for a complete coordinate | closed after Theorem 7.1 | generic-constancy proposition and closing warning distinguish divisor from coordinate |
| Computational evidence lacks a public replay | closed by C563 | `supplement/EVIDENCE.md`, manifest, exact generators/certificates, and `verify.py --replay` |
| Classical six-point invariant theory is presented as new | closed by C562 and Sections 1/8 | novelty claim restricted to the exact full-Weyl MDS/CSS LU-rigidity scope |
| The manuscript inherits report terminology without defining conventions | closed in Section 2 | projective, monomial, Weyl, Clifford, stabilizer, GRS, and party actions defined |
