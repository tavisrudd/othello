# Complete-ports: checks of the Astra cold read

**Lane:** `complete-ports`

The user requested a cold referee sub-agent and explicitly selected
`gpt-6-astra`. It was spawned with no conversation history and instructed not
to read earlier reviews, revision reports, or the reviewer guide. The initial
reviewer was interrupted before its review was used. The Astra report is
`notes/2026-09-07-complete-ports-astra-cold-referee.md`.

Review input: manuscript commit `82f252fcd`, 43-page PDF SHA-256
`3f7915129e8fbffc48b7799dc959d4d490ea2bff7d28ee906b9ae4fd1bedcbc7`.
The manuscript remained unchanged during the review. No Lean or benchmark run
was performed. The author's standing preference for Astra cold reads is now
recorded in the shared AGENTS.md/CLAUDE.md guide.

## Independent checks of provisional findings

1. **Cost composition versus nonconfinement interface.** The figure needs to
   carry the nonzero-kernel cost separately. For binary generator columns
   G1=(e1 | e2,e1+e2,0) and G2=(e1 | e2,e1+e2,e2), ordinary minima are
   lambda(0)=0 and lambda(b)=1 for each nonzero b. Normalized target minima in
   label order (0,e1,e2,e1+e2) are (2,0,1,1) for both codes. The zero column
   gives dual distance one in the first code; the duplicate column gives
   distance two in the second, and there is no weight-one dual word there.
   With full outer alphabet L^2, the exact Gamma values are 2+1 and 2+2.
   Thus lambda and mu alone do not determine Gamma. The displayed Gamma
   formula already retains d(I-perp) and is unaffected. Composition of the
   ordinary cost tables remains correct. This is a human finite calculation,
   not an executed enumeration.
2. **Minimal-support iff.** The final sentence in the pointed-confinement
   proof extends equivalence to inclusion-minimal members. The full outer
   code preserves minimal supports at every radius even though Gamma is
   finite. The safe statement is that equation confinement implies minimal
   support transfer; the converse fails. This agrees with the new operational
   confinement theorem.
3. **Timing conventions.** The measurement-protocol paragraph calls the times
   in-process, claims eleven/seven rounds, and refers to a displayed less-than-
   one-microsecond result. The later application table is explicitly external
   process timing and displays speedup ratios rather than that value. These
   descriptions must be reconciled against the pinned evidence before the
   empirical claims are treated as coherent. No timings were rerun here.
4. **F4 coordinates.** Relative to message basis (1,omega), the binary column
   e1 represents the trace coefficient omega^2: Tr(omega^2)=1 and
   Tr(omega^2 omega)=Tr(1)=0. The table uses the unscaled column labels;
   multiplication by omega^2 converts all of them to the preceding trace
   convention. Common scaling preserves the outer dual line, so the minima
   one and two survive. Make the chosen functional identification explicit.

## Disposition

The cold read requests review, not an automatic manuscript rewrite. These
findings are retained for a scoped correction pass; no manuscript patch or
publication gate closure is inferred. C325 and C953 remain open.

### Mystery ledger — ej + tt review closeout

The cheap check is to distinguish incorrect statements from incomplete
exposition. The principal Gamma formula includes the missing kernel cost,
while the figure forgets it; the F4 minimum survives the convention correction.
The minimal-support converse is actually false, not merely unexplained.
The benchmark discrepancy needs the original evidence protocol, rather than
another benchmark execution. No incidental discovery outside this review was
identified. Any further findings are recorded in the independent report.

## Final report received

Astra completed the full manuscript-source/proof/figure/bibliography read,
with visual inspection of PDF pages 1–4, 27, 32–33, and 40. It also identifies
missing fixed software/evidence and companion artifact identifiers. That
finding is a reproducibility limitation, not evidence that the artifacts do
not exist. Optional improvements concern the early main statement, the
leaf-relative congruence scope, the simplex comparison class, and the size
of the software detour. The final report records all audit limits explicitly.

All 16 pinned manuscript/PDF/figure/bibliography files are byte-identical to
the review input. This report closes the requested cold read, not the
correction pass or the aggregate C953 referee/export gate.
