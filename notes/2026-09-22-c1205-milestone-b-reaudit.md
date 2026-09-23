# C1205 milestone b: re-audit of the binding-site repair

**Lane**: `ergodis`
**Date**: 2026-09-22
**Auditor**: fresh Opus sub, read-only on every repository.
**Subject**: private `c1205b` `8d11ce4` (repair commits `8abe414`, `43527c6` over `267acdd`), core
`064cde2`; the High finding (H1) of `notes/2026-09-22-c1205-milestone-b-audit.md` and its repair
record ("Repairs after audit" under "Milestone b" in
`notes/2026-09-22-c1205-rel-transferable-evidence-report.md`).

Summary: H1 as found is closed. Every binding site is now recomputed from a source body, and every
forgery of the source surface I built is refused or accepted with the model unchanged. One new
High that the repair did not introduce: the verifier accepts a program statement that is not
range-restricted. It then evaluates the unbound variable over the whole dictionary, so a consistent
forgery is accepted whose result holds a value that appears in no literal and no fact. One Medium:
most of the new chain-shape checks are not discriminated by any test, and two of them are
soundness checks (demonstrated under mutation). Two Low findings and one Info. The gates are green.

## Findings, by severity

### N1 (High): a statement that is not range-restricted is accepted, and its result follows the dictionary

Evidence. The probe test `reaudit_unsafe_rule_with_a_dictionary_domain` (in
`~/.cache/ergodis/worktrees/reaudit-c1205b-probe/ergodis-private/tests/rel_chain/reaudit.rs`) takes
the honest `SINK` chain (`tests/rel_chain.rs`) and changes the statement's
`sink(y) = node(y) and not src(y)` into `sink(y) :- node(1), not src(y)`: the literal `node(y)`
gets the constant `1`. It also makes the same change in the layer rule, so `y` has no binding
site (`bindings` = `[[]]`, which `validate` recomputes and accepts). The complement record is
rebuilt over the fallback domain (`DomainSource::Dictionary([])`, values `0..dictionary`), the
layer is re-certified by `Demand`, and the statement identity, digests and result entry are
recomputed. Results:

| Variant                                          | Verifier                         | `sink`           |
|--------------------------------------------------|----------------------------------|------------------|
| honest                                           | accepted                         | {4}              |
| `node(y)` made `node(1)`                         | accepted                         | {4, 5}           |
| the same, and `99` appended to `values`          | accepted                         | {4, 5, 99}       |

In the padded variant, every layer's `domain`, each complement's `dictionary` and the integer
`type_range` are raised by one and each layer is re-certified. The value `99` occurs in no
literal, no fact and no extension.

Why. `site_signature` (`src/rel_chain.rs`) gives a variable with no site the whole dictionary as
its domain. That is exact only when the rule is range-restricted, which the frontend enforces
(`passes::range_restrict`: every variable of the head and of every negated or comparison literal
occurs in a positive or aggregate literal of the rule). `rel_verify::validate` never checks that
condition. Nor does it check that a dictionary value is used anywhere. The diff `267acdd..8d11ce4`
does not touch this path, so the gap predates the repair; the earlier audit did not report it.
The repair's module header ("a binding site is a positive literal of the rule's source body
holding the variable") argues exactness for variables that have sites and does not cover
variables that have none.

Failure scenario. A reader takes the statement's rules as Datalog rules. `sink(y) :- node(1), not
src(y)` has no stratified model under range-restricted semantics. Under active-domain semantics
its model is {4, 5}, never 99. The verifier nevertheless accepts `sink` = {4, 5, 99}, and the
forger can put any value into that result by padding the dictionary. `--source-check` refuses the
chain, but it is off by default, which is the same situation H1 was in.

Repair. In `validate`, after `validate_chains`, apply the frontend's range-restriction rule to
every rule over its source body (`source_body()`). For a chain, apply it to the root's head and
the shared source body. Link rules can be individually unsafe by design; the source-body check
together with the chain checks covers them (see N2). An aggregate literal binds, as in the
frontend. Optionally refuse a dictionary value that no literal, fact or type range needs, which
also removes one free choice from the statement. Turn the probe into a refusal test in
`consistent_forgeries_are_refused_by_what_they_contradict`, with the padded variant.

### N2 (Medium): most chain-shape checks are not discriminated; two are soundness checks

Evidence. Each check that the diff adds was mutated alone in the scratch copy
`~/.cache/ergodis/worktrees/reaudit-c1205b-mut` (`driver.py`, per-mutant logs in `logs/`,
summary in `results.txt`). Each mutant was run against `--test rel_chain --test rel_check`, and
the source was restored afterwards (`diff` clean).

| Mutant           | Check removed                                                      | Result                                              |
|------------------|--------------------------------------------------------------------|-----------------------------------------------------|
| names            | repeated relation name                                             | killed                                              |
| spellings        | repeated spelling                                                  | killed                                              |
| operator         | operator outside its sign's set                                    | killed                                              |
| chains-off       | `validate_chains` not run                                          | killed                                              |
| sites-eq         | bindings equal the source body's sites                             | killed                                              |
| sites-own-body   | sites from the rule's own body instead of its source               | killed (round trip refuses honest chains)           |
| src-read         | the source body is read by no rule                                 | killed                                              |
| atom-in-source   | every chain atom is a source atom                                  | killed                                              |
| record-order     | construction records in declaration order (M2 repair)              | killed                                              |
| src-range        | `source` inside the literal pool                                   | survives: out-of-range source then panics (N4)      |
| src-own          | `source` is not the rule's own body                                | survives; equivalent (src-read refuses it)          |
| members<2        | a source body names at least two rules                             | survives; semantically equivalent (N3 spelling)     |
| heads-distinct   | two members derive one relation                                    | survives; equivalent given defined-once             |
| link-twice       | an auxiliary read twice                                            | survives; equivalent given read-once                |
| one-root         | exactly one root                                                   | survives; equivalent given tree                     |
| aux-flag         | a link's relation is flagged auxiliary                             | survives; near-equivalent                           |
| **defined-once** | a link's relation has one defining rule                            | survives; **soundness** (below)                     |
| read-once        | a link's relation is read once                                     | survives; correspondence                            |
| **no-facts**     | a link's relation has no statement facts                           | survives; **soundness, demonstrated** (below)       |
| reader-sign      | a link is read positively                                          | survives; correspondence                            |
| reader-terms     | a link is read with its head's terms                               | survives; correspondence                            |
| head-distinct    | a link head holds distinct variables                               | survives; correspondence                            |
| tree             | every member reached from the root once                            | survives; correspondence                            |
| unmatched        | every source atom is joined by the chain                           | survives; correspondence                            |
| head-in-body     | a link head holds only variables of its body                       | survives; correspondence                            |
| drop             | a link keeps every variable the rest of the chain reads            | survives; correspondence                            |

The repair record's mutation table covers only the two whole H1 checks ("H1 sites" and "H1
chain"). Inside `validate_chains`, only `src-read` and `atom-in-source` are pinned.

Soundness demonstration (no-facts). Probe `reaudit_auxiliary_fact` on

```text
def a = {1; 2}
def b = {1; 2; 3}
def c = {2}
def z = {7}
def p(x) = a(x) and b(x) and not c(x)
```

under the `Binarize` policy, which gives `aux(x) :- a(x), b(x)` and `p(x) :- aux(x), not c(x)`,
with sites of `x` = `a`, `b`. The probe adds the statement fact `aux(7)`, adds the same fact to
the layer, re-certifies, and recomputes the results. The unmutated verifier refuses the chain at
`rules[1].head` ("a link that is not a chain's own auxiliary"). With the no-facts clause removed,
the verifier accepts it with `p` = {1}. The stated program with that fact has `p` = {1, 7}: the
complement is built over the domain {1, 2, 3}, which does not contain 7. The defined-once check
guards the same premise: a second rule `aux(x) :- z(x)` would feed 7 into the link in the same
way. This case was argued, not built.

The checks marked "correspondence" make the root derive exactly what the source body derives.
With the current code they do not bear on the sites. Removing one of them still leaves every
member's variable values inside its source-site domain, or leaves the rule unsafe (N1). Once N1
is repaired by checking range restriction on the source body, they become soundness checks too.
A source-body safety check says nothing about a chain that fails to join a source atom (unmatched,
tree) or projects a binder away (drop, reader-terms). Example: with drop removed, a link that
projects away `x` from `a(x), d(x)` leaves the root evaluating `not c(x)` over `a ∪ d` rather than
`a ∩ d`.

Repair. Add one consistent forgery per surviving non-equivalent check to
`a_binarized_chain_is_checked_against_its_source_body` or to the statement-forgery test. Use the
`Layer` helper, as the probe does, so that under each mutant the forged chain is accepted rather
than refused somewhere else. At minimum cover no-facts (the probe above), defined-once, unmatched,
tree, drop and reader-terms. Record src-own, heads-distinct, link-twice and one-root as equivalent
mutants.

### N3 (Low): one lowering has several accepted statements, so the identity is not canonical

Evidence (probe `reaudit_source_forgeries`, on `LONG` and on a wider rule `WIDE`, under both
policies). Each of these is accepted with the same model and a different identity:

1. The source body reversed in place, with sites and record provenance recomputed (A).
2. The source body copied to the end of the literal pool and the members pointed at the copy (B).
   This leaves the original region as literals that no rule and no source reads.
3. Every member's `source` removed and the sites recomputed from each rule's own body (C). This is
   accepted for `LONG`. For `WIDE` the domain values also move, so the probe, which only refreshes
   names, is refused at a record.

Every variant is refused under `--source-check`, which compares the re-lowered statement. Every
edit to a source literal (each term, and the sign) is refused: 54 variants over the four chains.
So are an extra atom, a missing atom, and a source on the root alone.

Why. Nothing fixes where the source body lies, its order, or whether an auxiliary-deriving rule
must carry a source. This is the same class as the earlier audit's M2.

Repair. Require `source[0] == rules[root].head + 1`, which is the producer's layout. Require every
rule that derives an auxiliary relation to carry a source. Refuse pool literals that are no rule's
head or body and lie in no source. The order of the source body stays free unless the producer
pins it, so record it as the one free order or leave it to `--source-check`.

### N4 (Low): an out-of-pool `source` is refused by one untested line; without it the verifier panics

Evidence. Mutant src-range survives. Without the check, `validate_chains` indexes `in_rule` and
`sites_in` slices `literals` past the end, which panics instead of refusing. Repair: add a
statement with `source: [n, n + 1]` (and `[5, 3]`) to the refusal tests.

### N5 (Info): auxiliary relations are in the result table

Evidence. The result table carries every auxiliary relation (`LONG`: 1 under `Nary`, 3 under
`Binarize`; `WIDE`: 3 and 5). A link rule can be unsafe on its own, as the verifier's header says,
so its entry is the chain's intermediate join over the source body's sites. It is not the model of
the link rule read alone. The statement determines that value, so nothing here can be forged.
Repair: state that the claim covers the source relations exactly and the auxiliary relations as
intermediate joins, or leave auxiliary relations out of the result table.

## Answers to the questions

1. **Forgeries on the new surface.** None was accepted with a wrong model. Refused: every edited
   source literal, an extra or missing atom, a source body another rule reads (the committed test), a
   source on one rule, a root without a source while its links keep theirs, and an
   auxiliary relation given a statement fact. Accepted with the model unchanged (N3): a reversed
   or relocated source, and an un-binarized spelling of `LONG`. The argument for why no
   wrong-model forgery exists through sites: every value a member's variable takes comes from a
   source atom it joins, from a link whose single defining rule is a member (by induction on the
   tree), or from a complement or filter over the same site domain. So the domain built from the
   source sites contains it. That argument assumes defined-once and no-facts (N2) and a
   range-restricted rule (N1). The one wrong-model acceptance found goes through N1, not through
   the new surface.
2. **Is the binarization check complete and sound?** It is sound as argued above. It is complete
   for what the lowering emits. The corpus round trip reproduces 470 chains accepted, 252
   multi-layer and 25 binarized under the default `Nary` policy. Under the `Binarize` policy, which
   `lowering.json` can select and which the committed round trip never runs, the corpus gives 470
   accepted, 294 binarized and 0 refused. `binarized_sources` rests on each rule's body lying
   directly after its head. Every rule constructor in `lower/build.rs` (the definition rule and
   the forall witness rule) and the binarizer build rules that way, and `vars` bases are distinct
   per rule, so the parent map cannot collide.
3. **The in-process `check`.** No gap for the offline claim. `verify_parts` treats the bindings
   only as claims and recomputes every one of them. `check` trusts the bind pass, and `rel-lower
   --chain` publishes without running the verifier. A bind-pass defect would therefore publish a
   chain that `rel-verify` refuses, which fails closed. The `rel_rebuild` header now says this.
4. **Do the new tests fail when the checks are removed?** For the H1 core, yes: sites-eq,
   sites-own-body, chains-off, src-read and atom-in-source are killed. For most of
   `validate_chains`, no; see N2, which includes the two surviving soundness checks.
5. **Gates at `8d11ce4`**, on a `git archive` export with the core worktree (`064cde2`, clean) as
   its sibling, under `nix develop <core worktree>` and profile `reaudit`. `cargo fmt --all
   --check` passes. `cargo clippy --all-targets --all-features -- -D warnings` passes.
   `cargo test --all-features` passes: 44 result blocks, 1201 tests, 0 failed. No `cargo clean`
   was needed on the real worktree, which was never built.

## Verdict

The High finding H1 is closed. The binding sites are no longer trusted: they are recomputed from
a source body that the verifier ties to the chain, and the audit's forgery and its binarized
analogue are refused. The offline claim ("accepted chain ⇒ the stratified model of the stated
program") still does not hold in default mode, because of N1: an unsafe statement is accepted
with a dictionary-dependent result. Repair N1, and add the N2 forgeries for no-facts,
defined-once and the correspondence checks before or with it, since N1's repair makes those
checks load-bearing. Then milestone b's verifier claim is supportable. N3 to N5 can follow.

## Scratch locations and method notes

- `~/.cache/ergodis/worktrees/reaudit-c1205b-base/ergodis-private`: `git archive 8d11ce4`, gates.
- `~/.cache/ergodis/worktrees/reaudit-c1205b-probe/ergodis-private`: the same plus
  `tests/rel_chain/reaudit.rs` (all probes), wired into `tests/rel_chain.rs` by one `mod` line.
  The no-facts mutant was applied there once for `reaudit_auxiliary_fact` and reverted; its
  `src/rel_verify.rs` matches `8d11ce4`. Built under profile `reaudprobe`.
- `~/.cache/ergodis/worktrees/reaudit-c1205b-mut/`: mutation copy, `driver.py`, `results.txt`,
  `logs/`, and the pristine sources in `orig/`.
- Each sibling `ergodis` is a symbolic link to the core worktree. All builds used separate
  profiles (`reaudit`, `reaudprobe`), so the shared `dev` artifacts are untouched. Running two
  scratch copies under one profile at the same time produced a two-versions `ergodis_contract`
  error in the probe build. It was avoided by giving the probe its own profile, and no artifact
  outside those profiles was cleaned.
