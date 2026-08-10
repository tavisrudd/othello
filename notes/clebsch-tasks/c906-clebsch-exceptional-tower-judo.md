# C906 — Clebsch exceptional-tower judo

**Lane:** clebsch

**Status:** complete 2026-08-10; theorem packet, exact evidence, literature
audit, and framing are in `notes/2026-08-10-c906-exceptional-tower-judo.md`;
no manuscript or Lean edits were made

## Goal

Use C905's proved marked-carrier interface to test whether sparse Clebsch
shadows canonically enter the existing \(E_6\)-and-beyond tower and whether
the entry object can be recovered from the exceptional output.

The levels are not claimed as new. Existing authority includes:

- C705: affine-\(E_8\) operator parent of the Segre--Igusa sisters;
- C865: affine-\(E_9\) level code and fold through \(E_8,E_7,E_6\);
- C870: rank-generic root-link antipodal fold, with exceptional low levels.

The possible new spin is the structure map: sparse-input recognition,
canonical marked entry, functorial propagation, exact fibres of the folds,
and reverse recovery where it is actually possible.

## Boundaries

- Do not edit any paper or Lean source.
- Do not market classical exceptional objects or the known level codes as
  new.
- Do not call a fold invertible without computing its fibre.
- Tensor equality with the Cartan cubic must be exact; matching support,
  dimensions, or orbit counts is insufficient.
- Run a fresh literature audit for general two-weight-family folds and for
  reconstruction of marked \(E_6\) data.

## Gates

1. Reconcile the object, marking, coefficient, and map conventions of
   C705/C865/C870.
2. Construct or reject the map from C905's marked carrier to the
   \(27\)-dimensional \(E_6\) object.
3. Prove canonical uniqueness and reverse recovery, or identify the exact
   obstruction.
4. Compute the information fibre of every tower map used.
5. Run hard red team, TT, and EJ through EJ7.
6. Hand surviving interfaces to the remaining upgrade tasks without
   manuscript promotion.

## Closed outcome

The unmarked fold/tower is pre-empted by the classical quadratic-graph
residue theory.  The surviving judo is the exact sparse marked-entry and
information-loss theorem: the Paper-V/Clebsch gateway selects an oriented
golden marking over the bare `E_6` carrier; marked quadratic suspension and
residue are inverse through `E_10`; forgetting the bottom data has fibres
`432`, `864`, or `1728`, and forgetting the nested residues contributes the
exact factors `28`, `120`, and `496`.  Transitivity proves that a bare upward
section is impossible.  The exact composition and arithmetic-lift direction
remain behind focused literature gates and were not promoted to a manuscript.
