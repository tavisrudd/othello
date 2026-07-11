# Key-card sweep B: software and systems

**Date:** 2026-07-11  
**Scope:** independent application screen; no novelty or market validation implied

## 1. Exact repair-and-revocation analyzer — strongest candidate

- **Cards:** K6–K8, K14–K17.
- **Primitive:** turn all minimal representations/recovery groups into a hypergraph and compute jointly: disjoint availability `nu`, fractional service capacity, and transversal `tau` (simultaneous helper failures or revocations needed to disable every recovery path). Preserve this complete bounded-repair hypergraph under concatenation.
- **Workflow/customer:** cloud-storage and erasure-code teams compare candidate LRCs; a security variant audits secret-sharing/access structures for minimum participant revocation sets. Input a generator/parity-check matrix; output per-symbol repair alternatives, bottleneck helpers, adversarial cut sets, and capacity-versus-resilience plots.
- **Cheapest kill test:** implement exact enumeration plus matching/ILP cover for codes of length at most 40; compare Reed–Solomon, deployed-style LRC seeds, and K15/K16. Interview one storage-code engineer: does `tau` change a design decision after `nu` and repair bandwidth are known?
- **Mathematical advantage:** **yes, if the gap occurs in practical codes.** Counts and `nu` provably do not determine `tau`; K15/K16 provide sharp regression fixtures. Standard LRC dashboards usually expose locality/availability, not the complete integral/fractional repair profile. The advantage disappears if realistic codes always have `tau≈nu` or enumeration cannot scale.

## 2. Proof-carrying finite-search pipeline

- **Cards:** K1, K2, K18–K20.
- **Primitive:** small trusted reduction, untrusted high-performance search, compact certificates, independent rules-only replay, symmetry transport, explicit distinction between complete/early-break/unknown data, and predeclared falsifiers.
- **Workflow/customer:** vendors of combinatorial optimizers, configuration/security-policy analyzers, and research software needing auditable finite classifications. A Rust solver emits a portable certificate; a tiny checker and optional Lean theorem connect it to the customer claim.
- **Cheapest kill test:** extract a domain-neutral certificate schema and port one bounded scheduling or access-policy instance. Measure checker size, certificate/search ratio, replay time, and whether a deliberately omitted branch is reported as unknown rather than accepted.
- **Mathematical advantage:** **conditional.** Orbit transport plus formally proved bidirectional reduction can make audits much smaller than generic proof traces. SAT/SMT proof logging is already mature, so this wins only where rich group actions and domain reductions materially compress certificates.

## 3. Marked-symmetry canonicalization SDK

- **Cards:** K3, K10–K13, K19–K20.
- **Primitive:** canonical hashes and serialization that retain the least marked structure needed for correctness—Frobenius pairs, cycle voltage, or fibre labels—rather than quotienting by an over-large unmarked symmetry group.
- **Workflow/customer:** highly symmetric configuration databases, finite-field code/design catalogs, chemical/configurational enumeration, and solver transposition tables. Store one representative plus transport metadata; reject two objects that collide only after erasing a required mark.
- **Cheapest kill test:** run marked and unmarked canonicalizers on an existing configuration corpus with known counterexample pairs; compare false merges, bytes/object, and deduplication ratio against nauty/Traces-style colored graphs.
- **Mathematical advantage:** **only in promised algebraic domains.** The project supplies exact examples showing which marks are necessary. General colored-graph canonicalization already solves the generic problem and is likely preferable outside strong projective/semilinear symmetry.

## 4. Robust structured-completion monitor

- **Cards:** K6, K7, K12.
- **Primitive:** completion core plus deletion distance: identify fields/components forced by every valid completion and the smallest deletion that enables an alternative.
- **Workflow/customer:** integrity monitoring for incidence-heavy schemas, network designs, experimental block designs, or replicated configuration templates. Report “forced,” “ambiguous,” and nearest alternative completion after missing records.
- **Cheapest kill test:** model one real constrained schema and compare answers/runtime with an off-the-shelf CSP solver under random and adversarial deletions.
- **Mathematical advantage:** **narrow.** Exact secant/transversal formulas help structured geometries; generic databases lack the hereditary incidence promise, where CSP/database-dependency tools dominate.

## Negative/no-fit conclusions

1. **K4 is not yet an optimization or RL product primitive.** `Psi` decreases only under oracle-selected replies and is not a proved value-blind potential. Using it as reward shaping offers no demonstrated advantage over learned heuristics and could encode look-ahead leakage.
2. **K8 is not a cybersecurity hardness result.** Its zero-sum/deep-hole core is prior art and the transversal identity supplies robustness accounting, not a one-way function or attack barrier.
3. **K11–K12 do not justify a general serialization compressor.** Reconstruction thresholds and promised finite-geometry structure are too specialized; ordinary graph/relational compressors remain the baseline.

## Ranking

Fund a two-day prototype of the repair/revocation analyzer first; retain proof-carrying search as the architecture spinout; test marked canonicalization only with a committed high-symmetry corpus.
