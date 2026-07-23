# C498 — deep holes of PRS(q−5) (redundancy six) via the quintic NRC in PG(5,q)

**Lane:** `reed-solomon` · **Date opened:** 2026-07-22 · **Gate:** claim-specific literature audit (entry)

## Objective (from queue row)

Settle the C491 NRC-ledger entry lemma for redundancy six:
1. Split-member existence for **nets of binary quartics** with trivial gcd (the Hankel kernel of a
   generic point at r=6 is a net = 2-dim projective linear system of binary quartics).
2. **Lang–Weil on the fiber-square surface** replaces C491's Aubry–Perret on the (2,2) fiber-square
   *curve* (r=5).
3. Exceptional nets classified as higher analogues of the O±/nucleus/wild loci.
4. Adapt the C491 census+replay harness to `q ≤ 16`.
5. Either prove the covering-radius gate `ρ = 5` from the Seroussi–Roth range
   (`q−5 ≥ floor((q−1)/2)` iff `q ≥ 9`) or state the exact gap.

Maintain the NRC bridge ledger. Task report → `notes/2026-07-22-c498-prs-redundancy-six.md`.

## Entry gate — literature audit (in progress)

The deliverable depends on the absence of prior work (novelty for redundancy six / k=q−5), so
`notes/literature-audit-conventions.md` binds. C491's audit
(`notes/2026-07-22-c491-prs-redundancy-five-literature-audit.md` + search log) is the direct
precedent and covers the k≤q−4 coding forward-tree; C498 extends it on three axes:

- **Axis A (coding):** `notes/2026-07-22-c498-audit-axisA-coding-forward-citation.md` — refresh
  three-graph closure on the pinned seeds, re-screen with a q−5 / redundancy-six discriminator.
- **Axis B (split-member lemma):** `notes/2026-07-22-c498-audit-axisB-split-member-linear-systems.md`
  — totally-split squarefree members of nets/webs of binary forms over F_q; Lang–Weil / Bertini
  over finite fields on incidence surfaces.
- **Axis C (orbit toolkit):** `notes/2026-07-22-c498-audit-axisC-quintic-orbits-nets.md` — PGL₂(q)
  orbits of binary quintic forms over F_q; nets of binary quartics as geometric objects.

Verdict-owning synthesis: `notes/2026-07-22-c498-prs-redundancy-six-literature-audit.md`.

Pinned seeds (reuse from C491 search log, do NOT re-resolve by title):
- SEED-A `arXiv:1901.05445` = `10.1109/TIT.2019.2940962`, OpenAlex `W2973880421` (ZWK redundancy four).
- SEED-B `arXiv:1612.05447` = `10.1109/TIT.2017.2706677`, OpenAlex `W2563545890` (Kaipa 2017, ≤3).

## Status

**COMPLETE (2026-07-23).**  The all-field existence theorem, persistent/modular orbit law, and
bounded exceptional classification are closed.  The final intrinsic fingerprint is the
shared-root collision energy of the `1+3` net members, plus the
odd-characteristic quintic root type.  It gives exactly
\(18/5/2/2/1\) \(P\Gamma L_2\)-normal forms at q=7/8/9/11/13; see
`notes/2026-07-23-c498-small-exceptional-normal-forms.md` and its atomic evidence bundle.
Energy zero is the all-field intrinsic detector of the recurring characteristic-two `3`-nucleus
orbit.

**Entry-gate literature audit PASSED (2026-07-22): NOT PRE-EMPTED.** Verdict + wording constraints in
`notes/2026-07-22-c498-prs-redundancy-six-literature-audit.md` (synthesis, verdict-owning), backed by
the three axis reports above. Mathematics clear to proceed. Key downstream constraints:

- Split-member lemma is novel as stated but must engage Oyono–Ritzenthaler (`arXiv:1006.0873`, split
  lines on smooth plane quartics, q≥127) and Cesaratto–Matera–Pérez (`arXiv:1408.7014`, totally-split
  counts on linear families); cite Lang–Weil-surface machinery (Cafure–Matera, Ghorpade–Lachaud,
  Charles–Poonen, Poonen, Aubry–Perret), don't re-derive.
- Binary-quintic `F_q`-orbit classification and net-of-quartics classification do NOT exist — C498
  must build both. Toolkit: KPP `arXiv:2312.07118` (+char-3 `arXiv:2508.11229`), Ishitsuka
  `arXiv:2605.04935` (catalecticant-rank/Waring stratification; quintic space NOT coregular),
  NRC nucleus `arXiv:1304.0088` (degree-5 nucleus is char 3).
- Scope novelty to the deep-hole/orbit classification: the scalar covering radius ρ=5 is
  Seroussi–Roth-known. Pin the floor/ceil threshold (q≥9 vs q≥11) against the SR 1986 original.
- The q≤16 census does NOT verify the asymptotic split-member lemma (best explicit bound q≥127);
  state the provable-threshold band once the surface bound is computed.
- Keep "to our knowledge" qualified (MathSciNet NOT COVERED).

**Computational calibration complete (2026-07-22).** The atomic Rust/JSON/Python bundle and interim
report are `notes/2026-07-22-c498-prs-redundancy-six.*`.  Exhaustive definition/Hankel agreement
holds through all prime powers q≤27 in the tested range; exceptional trivial-gcd orbit counts are
18/11/4/2/1 at q=7/8/9/11/13 and zero at q=16/17/19/23/25/27.  The independent Python replay is
exhaustive through q≤16 and structural for the extra-juice fields 17..27.  Covering radius 5 holds
throughout, including q=7,8.

The theoretical entry geometry is corrected: a plain fiber-square surface does not force the
residual quadratic to split.  For a basepoint-free net W, use the off-diagonal ordered-triple
collinearity surface det(phi_W(t1),phi_W(t2),phi_W(t3))=0 (or the discriminant double cover of the
ordered-pair surface).  Dividing by the three pairwise brackets gives a symmetric (2,2,2) surface,
generically K3, whose Sym^3(P1)=P3 quotient is a quadric.  Next math step: classify reducible,
singular, and degree-2-to-conic cases; prove smooth geometric irreducibility on the generic
stratum; and apply the K3 22q error bound after removing diagonals/ramification.
