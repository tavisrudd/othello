# C902 Paper III cheap-upgrade integration and cold review

Date: 2026-08-09

Status: reopened integration in progress; cold mathematical gates pass after
repair; the deterministic build is warning-free at 33 pages, while the tracked
page-count contract remains 32 pending author approval.

## Applied scope

Only the three audited survivors were applied to the canonical Paper III source:

1. `thm:triangle-pfaffian-recognition` follows the existing four-shadow theorem.
   It proves that nonzero triangle--Pfaffian proportionality for a real symmetric
   even-order matrix with nonzero off-diagonal entries forces order six and a
   positive scalar square.  Equal absolute values give exactly the pentagon
   conference class, with the proportionality sign recording the orientation
   character of the signed label space.  Zero proportionality, zero support,
   and remote weighted solutions remain excluded.
2. “Why the determinant” now identifies `det B_T` as a determinant-line element.
   The cold review corrected the proposed norm sign: after compatible
   orientations, the ordinary field norm satisfies
   `det[D_x,C_T]=-8000 N_{E/Q}(det B_T)`.  The positive block square is the
   signed odd-rank determinant-line contraction, not the unsigned ordinary
   field norm.
3. The golden-exchanger paragraph now says that deck exchange preserves the
   unmarked algebra `Q[C]=Q[-C]` while reversing the marked generator and
   relative orientation.

Candidates 1, 5, and 8 remain already-landed no-ops; C894 remains deferred;
Gaunt proposition promotion remains rejected.

## Trust reconciliation

- The new theorem has stable label `thm:triangle-pfaffian-recognition` and was
  added to the statement extractor's ordered label inventory.
- The nine-row contract is unchanged.  `OPER-1` now owns the theorem and signed
  norm wording and cites both the golden-return and four-shadow formal maps and
  axiom reports.  The row distinguishes formal scalar-square/sign recognition
  from the manuscript's real positivity step.
- `ORIENT-1` now records preservation of the unmarked generated algebra and
  reversal of its marked generator.
- The generated statement identity was refreshed, and the verification README
  now records nine theorem-like statements.

## Frozen cold reviews

The reviewers received the scoped uncommitted source without the C902 wording
packet or one another's reports.

- Algebra/constants: `notes/2026-08-09-c902-cold-algebra-review.md`.  Its initial
  pass missed the ordinary-norm sign; after the other readers exposed the issue,
  its explicit regrade independently derived `N(det B)=-det(B)^2` and passed the
  repaired `-8000` formula.
- Marking/architecture: `notes/2026-08-09-c902-cold-marking-architecture-review.md`.
  Initial verdict `REPAIR REQUIRED` for the norm sign; repaired verdict `PASS`.
  The marked/unmarked distinction, signed-label orientation character, and
  source--shadow--return placement pass.
- Trust/exposition: `notes/2026-08-09-c902-cold-trust-exposition-review.md`.
  Initial verdict `BLOCK` for the sign, an overbroad pre-theorem sentence, and
  missing four-shadow evidence in `OPER-1`; all three were repaired.  Final
  verdict `PASS` after statement, axiom-hash, JSON, and source-hygiene checks.

## Validation state

Passed:

- statement-identity regeneration and check;
- nine-row trust/scaffold validation;
- TeX spacing/source-hygiene lint;
- arithmetic, orientation, and harmonic primary/replay/hash gates;
- source-only passages, golden-return, and four-shadow formal replays;
- warning-free deterministic XeLaTeX build at 33 pages; and
- three repaired cold-review regrades.

Rendered pages 11 and 16--20 were inspected at full-page resolution: the marked
spectral sentence remains with its exchanger calculation; the recognition
theorem and proof fit cleanly on page 18; the norm display breaks at a logical
paragraph boundary into page 19; and the following exchange theorem retains its
section hierarchy.  Page 33 contains only the last four bibliography entries,
with no orphaned heading, clipped display, or box warning.

Gate resolution:

- The author approved the 33-page validation contract on 2026-08-09.
  `check_manuscript_build.py` now pins 33 pages, the deterministic tracked PDF
  was refreshed, and the complete authoritative release gate passes, including
  all three pinned Lean source-closure checks.
- Standalone synchronization remains downstream of the dossier-primed cold
  referee pass requested before closeout.

## Mystery ledger (`ej` + `tt`)

- **Settled — norm sign.**  The positive block determinant and the ordinary
  quadratic field norm differ by the odd-rank swap sign.  Three cold regrades
  now agree on `-8000`; the original C862/C902 `+8000 N` wording is corrected in
  every C902 durable packet.
- **Settled — formal owner.**  No tenth trust row is needed.  The existing
  four-shadow formal map already proves the scalar-square and sign-matrix
  recognition mechanisms; adding it to `OPER-1` closes the evidence-map gap.
- **Settled — page budget.**  The theorem costs one page after local
  compression; the author approved the resulting 33-page contract and the
  deterministic build now passes at that count.
- **No other genuine mystery remains.**  The weighted remote locus and C894
  safeguards are deliberate boundaries owned outside this reopened integration.
