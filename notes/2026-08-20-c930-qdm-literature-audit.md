# C930 quantum-D-module literature audit

**Lane:** `cubic-threefolds`

**Scope:** the strictly \(m=1\) categorical proof spine for
`papers/cubic-stabilization-epilogue/`

**Status:** complete for the C930 theorem graph; repeat the point-of-use check
if a mathematical claim changes during manuscript refounding

## Verdict

The unconditional atomic marker and the conditional framed-sixth marker have
a complete primary-source map.  Every imported quantum-D-module statement is
either attached to an exact theorem, equation, remark, or section below, or is
identified as an author-proved adapter.  Hypotheses 5.7R and 5.7T remain
hypotheses rather than literature imports.

The audit found one bibliography omission: Beauville's complete-intersection
paper was the primary source for the cubic small quantum algebra but had no
bibliography entry.  The C930 repair adds `\bibitem{Beauville}`.  The existing
Iritani, Iritani--Koto, Behrend, Batyrev, Givental, Cotti, and Cai entries are
present and correctly keyed.

## Frozen primary sources

| key | exact source | audited locator | cached PDF SHA-256 |
|---|---|---|---|
| `Beauville` | A. Beauville, *Quantum cohomology of complete intersections*, arXiv:alg-geom/9501008v1 | main theorem and formulas (2.1)--(2.3) | `9d022796aefa01fd601820e415c5462bdfc255b3b4fe158af64b51f7bf0a83e3` |
| `IritaniBlowup` | H. Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3 | Remark 2.3; Remark 5.6; (5.15); (5.27)--(5.30); (5.38)--(5.43); Sections 5.8.1--5.8.2; Theorem 5.18 | `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b` |
| `IritaniKoto` | H. Iritani and Y. Koto, *Quantum cohomology of projective bundles*, arXiv:2307.03696v4 | Remark 1.2; (1.1); (5.2); Theorem 5.1; Remarks 5.2--5.3; (5.11)--(5.12); Proposition 5.6 | `5139f8e0c9d46f8ccb8cb415396a0fb1fb357719b7dcfbca46234a9735b57624` |

The arXiv API was checked on 2026-08-20.  It still reports these exact latest
versions: Iritani v3, updated 2025-02-04, and Iritani--Koto v4, updated
2026-01-31.  The v4 record explicitly notes a correction to Theorem 5.1(5),
so all manuscript citations and calculations must continue to name v4.

## Claim-by-claim QDM source map

| claim consumed by C930 | source locator | exact scope consumed | status |
|---|---|---|---|
| Cubic small quantum multiplication and the constants \(\ell_0=6\), \(\ell_1=15\), \(\mu=27\) | `Beauville`, main theorem and (2.1)--(2.3) | derive the three displayed products and the \(4\times4\) Euler matrix internally | imported formula; internal derivation |
| Blowup QDM direct-sum decomposition | `IritaniBlowup`, Theorem 5.18(1)--(2) | horizontal, pairing-compatible isomorphism over the formal Laurent coefficient ring | imported theorem |
| Blowup coordinate independence and separation of summands | `IritaniBlowup`, Theorem 5.18(4), (6), (7) | asymptotic separation and invertible combined bulk Jacobian | imported theorem |
| Blowup ambient and center coefficient maps | `IritaniBlowup`, (5.15), (5.38)--(5.43), Remarks 2.3 and 5.6 | common coefficient spine and the precise noninjective center Novikov map | imported formulas; numerical/divisor faithful extension proved in C925 |
| Blowup reconstruction displacement | `IritaniBlowup`, (5.27)--(5.30), Sections 5.8.1--5.8.2 | exact scalar/divisor leading terms and the residual generated tail | imported asymptotics; framed residual tail is exactly Hypothesis 5.7R |
| Projective-bundle QDM direct-sum decomposition | `IritaniKoto`, Theorem 5.1(1)--(2) | horizontal, pairing-compatible sum of \(r\) base QDMs | imported theorem |
| Projective-bundle coordinate independence | `IritaniKoto`, Theorem 5.1(4)--(6) | leading roots, invertible bulk Jacobian, and summand separation | imported theorem |
| Projective-bundle coefficient embedding and bundle-twist convention | `IritaniKoto`, (1.1), (5.2), Remarks 1.2 and 5.2 | injective base Novikov map and invariance under tensoring the bundle by a line bundle | imported formulas |
| Projective-bundle reconstruction displacement | `IritaniKoto`, Proposition 5.6 and (5.11)--(5.12) | exact scalar/divisor leading terms and normalized initial coordinate | imported asymptotics; framed residual tail is exactly Hypothesis 5.7R |
| Regularity at the connection variable \(z=0\) | both comparison theorems as isomorphisms of `C[z]`-modules; `IritaniKoto`, Remark 5.3 | comparison and inverse introduce no negative powers or roots of \(z\) | imported ring statement; formal-monodromy consequence proved in the paper |
| Even restriction | homogeneity in `IritaniBlowup`, Theorem 5.18(3), and `IritaniKoto`, Theorem 5.1(3), together with the explicit Fourier/pull-push formulas | after odd bulk variables are set to zero, the comparison preserves parity and the even-even Jacobian is invertible | author-proved parity adapter |
| External-product QDM | `BehrendProduct`, main product formula | genus-zero invariants of a product are the tensor product of those of the factors | imported theorem; numerical base change is internal |
| \(\mathbf P^n\) and Fano toric small quantum presentations | `Batyrev`, Section 5, and `Givental`, Theorem 0.1 | endpoint \(\mathbf P^4\), \(\mathbf P^2\), and Hirzebruch base calculations | imported presentation in stated Fano scope |
| Hirzebruch-surface transported presentations | `Cotti`, Theorems 9.3.1 and 9.3.3; `McDuffSalamon`, Chapter 7 | the two parity families and deformation invariance used in the framed center audit | imported results plus internal quartic calculation |
| Primitive-sixth cubic exponents | `Beauville` for the starting matrix; compare `Cai`, Sections 3--4 | the indicial polynomial and both exponent classes are derived in the manuscript | internal proof; Cai is corroborating context only |

## Non-QDM geometric inputs adjacent to the compiler

These are not QDM claims, but they must remain cited at their point of use.

| claim | source |
|---|---|
| projective weak factorization with smooth centers | `AKMW`, Theorem 0.1.1 |
| product formula for genus-zero Gromov--Witten invariants | `BehrendProduct`, main theorem |
| minimal-surface alternative used in center nullity | `BeauvilleSurfaces`, Chapter VI |

Both current classification sentences now cite the chosen standard
reference.  No adjacent geometric bibliography choice remains open.

## Point-of-use citation requirements for the refounding

1. Cite `Beauville` where the cubic products are displayed, not merely in the
   introduction.
2. Cite `IritaniBlowup` Theorem 5.18 at the blowup provider record and cite
   the relevant equation again where the center coefficient map is used.
3. Cite `IritaniKoto` Theorem 5.1 at the projective-bundle provider record;
   cite Remark 1.2 and Remark 5.2 only where the bundle twist is performed.
4. Cite `BehrendProduct` in the product specialization that produces
   \(X\times\mathbf P^1\).
5. Keep 5.7R and 5.7T labelled as hypotheses.  No citation may be phrased as
   proving either one.
6. Cite `Cai` only for comparison after the internal indicial calculation;
   the proof must begin from the Beauville matrix.
7. Keep `IritaniNotes` supplementary.  The categorical \(m=1\) theorem does
   not require an analytic/Stokes or integral-structure upgrade.

## Boundary

This audit certifies literature coverage and the fidelity of the source map.
It does not certify the imported theorems themselves.  It also makes no claim
about higher stabilization, Gamma-row transport, or any all-\(m\) provider.
