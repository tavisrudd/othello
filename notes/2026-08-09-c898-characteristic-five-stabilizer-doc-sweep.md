# C898 characteristic-five stabilizer documentation sweep

**Date:** 2026-08-09  
**Scope:** human-readable Markdown/prose only; no manuscript, Lean source, task
queue, C898 dossier/review/synthesis, handoff, or standalone mirror was edited.

## Result

One non-manuscript documentation file contained the precise false field-uniform
claim and was repaired:

- `notes/2026-08-03-c855-dye-orbit-uniqueness.md`: its opening verdict and
  stabilizer by-product claimed an `A5` projective stabilizer in every odd
  characteristic. The text now scopes `A5` to `char K ≠ 5` and records Dye's
  `S5` stabilizer in characteristic five; the index-two/root-count argument is
  explicitly restricted to distinct roots.

The named snapshot was inspected and changed **not at all**:
`notes/2026-07-31-results-summary-snapshot.md` discusses the `q=11` case, where
the `A5` wording is correct. Its separate priority sentence names Dye's
stabilizer in that same order-eleven context, so it is not an all-field claim.

## Search scopes and classifications

1. `notes/2026-07-31-results-summary-snapshot.md`, inspected around the
   Clebsch rigidity and priority-boundary sections: **correct**, q=11-specific
   `A5` claims.
2. `notes/*.md`, excluding task cards, handoffs, and archives, searched for
   stabilizer/A5/odd-characteristic/characteristic-five combinations:
   - `notes/2026-07-14-c161-tfae-iv-v-priority.md`: **correct**, explicitly says
     Dye gives `A5` outside characteristic five and specializes to q=11.
   - `notes/2026-08-03-c855-dye-orbit-uniqueness.md`: **incorrect**, repaired
     as above. Its equality-classification and polarity statements remaining
     “every odd characteristic” are unrelated and **correct**.
   - `notes/2026-07-19-c373-clebsch-scheme-automorphisms.md`: **correct**, the
     order-five/conic fiber explicitly says the stabilizer grows from `A5` to
     order 120 (`S5`).
   - `notes/2026-07-31-c731-clebsch-ame-syndrome-bridge-red-team.md` and
     `notes/2026-07-28-c682-mod11-transvectant-matching-bridge.md`:
     **correct/irrelevant**, q=11 or a separate mod-11 construction.
   - Other hits mentioning “odd characteristic” concerned unrelated rank,
     arc, or operator statements: **irrelevant**, not stabilizer claims.
3. `papers/**/*.tex|md`, excluding build/generated trees: **no matching
   documentation hit** in the bounded search. The manuscript's known
   Proposition 2.2 defect is recorded below as an excluded downstream item.
4. Top-level Markdown outside `notes/`, `papers/`, and `lean/`: **no matching
   hit**.

## Excluded downstream artifacts needing root remediation

The C898 cold-read and synthesis artifacts correctly record the defect but were
out of scope for editing:

- `notes/2026-08-09-c898-paper-i-cold-read-r1-finite-geometry.md` (false
  Proposition 2.2 clause and required `S5` correction);
- `notes/2026-08-09-c898-paper-i-cold-read-round-1-synthesis.md` (adopted A1);
- `notes/2026-08-09-clebsch-paper-i-reviewer-dossier.md` (review context);
- the Paper I manuscript under `papers/clebsch-rigidity/`, including
  Proposition 2.2 and downstream uses.

Root should apply the manuscript correction and audit its downstream prose;
the review artifacts should remain unchanged.

**Count:** 1 erroneous editable hit fixed; 0 snapshot edits; 5 excluded
downstream artifact groups flagged; no ambiguous stabilizer claims found.
