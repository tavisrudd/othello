# C1102 — Wang–Li and Dai–Fu–Luo primary-source follow-up

Date: 2026-09-07. Gate 1 remains OPEN. This supplements the frozen acquisition
snapshot in REPORT.md; it does not replace its historical counts or source markers.
Of the two sources in this follow-up, **one was read at full text**, one at
**partial** depth. Both complete published scan sets are now accessible.
The original screenshots remain outside Git in the permanent literature cache;
`user-scan-sources.json` mirrors bibliographic metadata, original source paths,
page mapping, image byte counts and SHA-256 hashes. Load-bearing formulas were
read directly from those images, without relying on OCR.

## Wang–Li

Yiran Wang and Yongming Li, *Stabilizer Rényi entropy on qudits*, published
Quantum Information Processing (2023) 22:444. Key `10.1007/s11128-023-04186-9`.
Access: user-supplied institutional-browser screenshots, all 20 published pages.
Read depth: **partial**; detailed technical reliance on pp. 6–9, Eq. (2),
Theorem 1 and Proposition 2; examples, mixed-state section, distillation section
and reference pages visually inspected, without a complete technical audit of
those later arguments. Exact hashes are in `user-scan-sources.json`.

Eq. (2) uses total dimension d=j^n, all d^2 phase-quotient Pauli representatives
including identity, and base-two logs. Theorem 1 supplies pure-state Clifford
invariance and tensor-product additivity. Proposition 2 specializes at alpha=2
to M_2 <= log_2((d+1)/2), stated with a SIC-existence hypothesis.
For the companion's use, an independent Cauchy–Schwarz proof removes that
hypothesis from the inequality: write x_P=|<P>|^2, so x_I=1 and sum x_P=d;
then sum x_P^2 >= 1+(d-1)^2/(d^2-1)=2d/(d+1). Equality requires all nonidentity
x_P to equal 1/(d+1). Attainment therefore depends on a SIC orbit for the
chosen operator system. This is the auditor's elementary derivation, not an
attribution of an unconditional theorem to their printed proposition.

Their reference [54] motivates SIC maximality and is the next source below.
No reliance is placed on their mixed-state faithfulness or distillation claims.
The source's access gap is resolved; this alone does not resolve the graph audit.

## Dai–Fu–Luo

Hao Dai, Shuangshuang Fu, Shunlong Luo, *Detecting Magic States via Characteristic
Functions*, published International Journal of Theoretical Physics (2022) 61:35.
Key `10.1007/s10773-022-05027-8`. Access: nine user-supplied original PNG spreads,
all 18 pages. Read depth: **full text**; relied on Eq. (8), Propositions 1–2 and
proofs (pp. 5–8), examples Sec. 5 (pp. 10–15), especially Sec. 5.3(3) (p. 15),
and references/conclusion. Reading does not independently certify every example.

Eq. (8) defines L=sum_P |Tr(rho P)|. For pure states the auditor's translation
is M_{1/2}=2 log_2(L/d); this is not an M_2 definition. Proposition 2 proves
L <= 1+(d-1)sqrt(d+1) by Cauchy–Schwarz, then verifies SIC attainment when a
covariant SIC exists. Composite-system operators are explicitly introduced.
Section 5.3(3) gives product factorization and the qubit product ceiling
L <= (1+sqrt(3))^n. Combined with their Clifford invariance, the same ceiling
holds throughout Clifford orbits of those products (auditor inference).
This is a direct predecessor for the product-ceiling method, even though their
order, local dimension and application differ from the companion's use.
No cubic Hessian-rank calculation was located in this complete paper; the
source-local inspection domain is pp. 1–18, not its forward-citing literature.

## Consequences and remaining gate

Credit the characteristic-function product-ceiling method and the qudit entropy
framework. Do not position the general Clifford-product obstruction principle
as new. The companion's exact cubic spectra and their geometric applications
still require the existing six-row adjudication and manuscript-owning ledger;
this follow-up does not issue an independent novelty verdict.
No further user access is needed for these two sources. Remaining work includes
promoted-source technical review, the added Hessian seed's independent graph
gaps, and the pre-draft claim–proof–novelty ledger.

Surfaces checked for this checkpoint: task card and live handoff updated to
resolve access and carry the source follow-up; original audit REPORT linked to
this continuation without rewriting its frozen snapshot. No companion manuscript,
claim–proof–novelty ledger, public summary or snapshot was created or changed.
The manuscript and ledger are still pre-draft deliverables behind Gate 1; this
checkpoint makes no instance-novelty verdict requiring propagation to them.
