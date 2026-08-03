# C835 — trust audit for cleaning-based global rounding (2026-08-02)

## Verdict

The C833 theorem remains valid, but its novelty boundary needed correction.
The exact qualitative implication “three cleanable regions plus exact
transversal logical action implies logical Clifford” is prior art, most
directly Pastawski--Yoshida, Lemma 5, specialized to three regions.
Bravyi--König supplies the nested-commutator localization lineage, and
Bravyi--Terhal supplies the stabilizer cleaning lemma.
Jochym-O'Connor--Kubica--Yoder gives a complementary exact hierarchy bound
through disjointness.

C833's surviving paper-local content is quantitative:

1. the implementation metric permits leakage, E(T,L) <= eps;
2. scalar compression on the last correctable region gives the explicit
   nested-commutator estimate d_sc([[L,P],Q]) <= 8 eps;
3. Weyl Fourier concentration converts those approximate scalar
   commutators into d_2(L,Clifford) <= 8 eps;
4. applying this at every AME leg and using the stabilizer overlap gap
   yields the explicit global defect threshold and residual estimate.

This is a moderate downgrade to the proof-mechanism framing and a small
downgrade to the paper as a whole.  It does not pre-empt the approximate
global-rounding theorem.  No claim of exhaustive novelty for the robust
constants is made by this audit.

## Scope repair

The local quantitative lemma was unnecessarily stated only for the
[[2m-1,1,m]]_q AME-derived code.  Its proof uses only:

- one logical qudit in a stabilizer code;
- a partition of the physical parties into three correctable regions;
- a transversal physical unitary approximately implementing a logical
  unitary.

The manuscript now states the lemma at that natural boundary.  The AME
theorem remains its application: the distance-m code has the partition
sizes m-1,m-1,1.

## Claim/source map

| Claim used here | Precedent and locator | Audit outcome |
|---|---|---|
| A logical Pauli can be cleaned from a correctable region | Bravyi--Terhal, Lemma 1 | inherited exact input |
| Nested commutators localize after cleaning | Bravyi--König, proof of Theorem 1 | inherited proof architecture |
| A transversal logical unitary on three cleanable regions is Clifford | Pastawski--Yoshida, Lemma 5 with m=2 | direct qualitative precedent |
| General stabilizer-code transversal gates lie in a finite hierarchy level | Jochym-O'Connor--Kubica--Yoder, Theorem 5 and Corollary 6 | complementary exact context |
| Leakage-aware 8 eps scalar-commutator estimate | C833 quantitative cleaning lemma | manuscript-local quantitative claim |
| Approximate scalar Weyl commutators force explicit Clifford proximity | C833 nested Weyl commutator lemma | manuscript-local quantitative claim |
| Per-leg estimates compose to the stated AME global threshold | C833 global-rounding theorem | manuscript-local quantitative claim |

## Source ledger

The shared literature cache was queried before fetching.  All four entries
were absent and were then fetched from arXiv and cached.

| Key | SHA-256 | Read depth | Relevant content |
|---|---|---|---|
| arXiv:0810.1983 | 43feac62dfd946576653be0dc29a9ca8b1d50bb9e8e27428556e29eee7fb59cf | claim-specific: organization and full statement/proof of Lemma 1 | cleaning dichotomy and cleaned representatives |
| arXiv:1206.1609 | 027fe684e2fa254e25dc11771e3a9064225e69989442ab54c58e3aa266ed9d93 | full text | commutator localization, correctable-region scalar action, hierarchy iteration |
| arXiv:1408.1720 | 6eba050d7f767067ff16d7f4b22e9868bb91c6dc49844b1fec935c6dc24052bb | abstract, introduction, Sections II.D--II.E, Lemmas 3--5 and proof, conclusions | exact general cleanable-region theorem |
| arXiv:1710.07256 | a4adba8c4e92f8369bbb67a3134add9ff3418d7f3bd0839d2ed2fbdf73002933 | abstract, introduction, intuition, cleaning/scrubbing lemmas, Theorem 5 and discussion | disjointness hierarchy bound |

The search was deliberately bounded to the trust question: ownership of
the exact cleaning/commutator mechanism and the correct general-code
scope.  It is not an absence search over all approximate
Eastin--Knill-type results, and the manuscript makes no corresponding
novelty claim.

## Manuscript changes

- Added the four exact-code precedents to the bibliography.
- Conceded the exact three-region Clifford obstruction immediately before
  the quantitative proof.
- Identified the leakage estimate, Fourier constant, and AME composition
  as the paper-local claims.
- Generalized the quantitative cleaning lemma to every one-logical-qudit
  stabilizer code with a three-correctable-region partition.
- Synchronized the introduction and verification/trust boundary.

No computation or certificate is used.
