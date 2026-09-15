# C1170 syntax-gaps report — independent verification audit

**Lane**: `ergodis`
**Date**: 2026-09-15
**Subject**: `notes/2026-09-14-c1170-syntax-gaps.md`, checked against `~/src/ergodis-private` at
`6f0e9ec`, the retained binaries under `~/.cache/ergodis/bin/`, and the pinned reference set under
`~/.cache/ergodis/rel-frontend-reference/`.

This was a read-only audit. No tracked file in `~/src/ergodis-private` or `~/src/othello` was
modified, nothing was staged or committed there, and the foreign uncommitted files under
`analysis/campaign-console/` and elsewhere were not touched. Replay outputs were written to a
scratch directory rather than over the committed receipts, and the two probe programs compiled
against the frontend source live only in the scratch directory.

## Verdict

Confirmed:

1. All seven retained binaries hash exactly to the report's table, including the unmeasured
   `ergodis-tools-fe4fda7`.
2. The parity corpus replays byte-identically today: 193 cases, 369,710 canonical bytes, canonical
   SHA-256 `c5d836251b8b24e2b58c513a89a7726acc8f922533e9df681fc24ec3ca9aafba`, native and WASM
   byte-equal, and every field of the regenerated report equal to the committed
   `analysis/rel-frontend/portability-v1.json` — including the native and WASM library hashes.
3. The frontend test suite passes at `HEAD`: 28 passed in `rel_frontend` and 1 in
   `rel_frontend_portability`, 0 failed, with the three new family tests and the zero-allocation
   regression among them. Strict Clippy on the library and both test targets is clean and
   `rustfmt --check` is clean.
4. Every A/B number printed in the report is in its committed receipt, to the last digit I checked,
   across all five receipts, and each receipt carries the correct pair of binary hashes. The
   composed ratio re-derives as 1.065117 [1.065116, 1.065119] on the ASCII parse stage and 1.095625
   on the scan-only cohort.
5. An independent replay of the composed A/B run today reproduces those numbers: ASCII parse
   1.065117 [1.065116, 1.065119] (identical to the receipt) and scan-only 1.095627
   [1.095624, 1.095630] against the receipt's 1.095625 [1.095620, 1.095631], with A/A instruction
   nulls within three parts per million of unity.
6. The supporting mechanism evidence all reproduces: the symbol-size table is exact at every one of
   the five revisions, the kernel-scoped profile shares are exact at both ends with no libc,
   allocator, formatting or panic symbol, the directly measured scan stage agrees with the
   cohort proxy to within 0.05 per cent, the representation is identical across all seven binaries,
   the six-event set runs at 100.00 per cent enabled, and the foreign-diff hash is still
   `a954fbdc…`.
7. Both recorded divergences are real and correctly characterized. A probe against the frontend
   source shows `U+0903` starting an identifier and `doc "100% sure"` rejecting as
   `MalformedInterpolation`/`REL0105`.
8. The cohort-content claim holds where the report's decisive argument rests on it: the
   comment-string cohort contains no caret and no per cent sign at all, and the ASCII cohort
   contains no identifier character outside the reference's classes.

Contradicted:

1. The headline sentence "none of the cost is the features executing" is too strong, and its stated
   justification is false for one of the three cohorts it names: the Unicode cohort contains 2,048
   identifier characters outside the reference's letter classes, and the report's own mystery item 5
   attributes the Unicode family's largest cost to a new comparison executing on every character of
   the shared path. Defect 1 below.
2. The two "deliberate widenings of `ConstructorId`" are not widenings: the pinned grammar already
   admits both `^end` and `^_x`. The actual widenings, which the report does not name, are `^_` and
   a caret over the widened letter class. Defect 2 below.
3. "An interpolated literal in a definition head is `UnsupportedSemantics`, which is the reference's
   rule … reached without a special case" describes a rejection that is not about interpolation: a
   definition head containing any literal is rejected the same way. Defect 3 below.
4. "Each case in them is checked on both scanner variants with the token stream compared byte for
   byte" is false for the caret test, whose accept loops run the byte scanner only. Defect 4 below.
5. Remaining gap 3 asks for date and datetime literals to be added to the coverage manifest; commit
   `b51f627`, which the report's own header names as the end of its range, already added them.
   Defect 6 below.
6. "Peak RSS is unchanged" is contradicted by the composed receipt, where the candidate sits about
   one per cent below the control on every operation. Defect 11 below.

Could not check:

1. Whether a Lezer parser really resolves `a^b` the way the report reads the token-precedence
   declaration. That needs the parser generator, which is not in the pinned set. The report states
   this uncertainty itself and does not rest a contract on it beyond the state-masking argument.
2. The four non-composed A/Bs were re-derived from their committed receipts but not re-run. The
   composed replay is the protocol check; re-running the other four would cost about twenty minutes
   of pinned-core time and was not required to settle any contested number.
3. Mystery items 6, 7 and 8 remain open exactly as the report says. Closing them needs the
   `perf annotate` pass over named address ranges that the report identifies as the evidence gap;
   I did not run it.

## Per-claim detail

### 1. Retained binary hashes

```
$ for R in 9bfe19d 80f3305 1cc34ae d1f24ba f7337c4 fe4fda7 e8b4c7c; do
    sha256sum ~/.cache/ergodis/bin/ergodis-tools-$R; done
c6376274ac2892c1b044a1fb8ed89a1852876e14caa499100036cf9862fa5019  …-9bfe19d
d19f6c1ea1281e7870491d2b96876c810b4a01a0f1e06596d24dd9f6627b3fcb  …-80f3305
c6bc454fde44dee338086d3eebb84e2e86c9485946d9eec1134b87e575cf3e7f  …-1cc34ae
0546f0f771613f48ff9b5e5a7c72abff6169f06bb38bb58b6db7558970383184  …-d1f24ba
2a4e4bf8832bbd260aa6c3d8eb3baaeb825442a5d3e02f8c9dd1049c64e1ce30  …-f7337c4
2ccba71a57d1e5d19a104d026108ccf798310561669f17b1a50a0c565eb7a57b  …-fe4fda7
7431e0e83236a850081204b5310786d8570073ba127a731f7435ca2bf06b6ecb  …-e8b4c7c
```

All seven match. `MANIFEST.tsv` carries each row with the `dirty` flag, rustc 1.95.0, the release
profile and no features, as the report states.

### 2. Parity corpus

```
$ nix develop ~/src/ergodis --command python3 analysis/rel-frontend/portability.py \
    --output <scratch>/portability-replay.json
193 cases, 369710 canonical bytes, native/WASM exact equality
```

The regenerated report differs from the committed `portability-v1.json` in no field at all, so the
canonical hash, the record summary, the four decoder negative controls and the two compiled library
hashes are all reproducible. The before/after table checks out against the tree: the "before"
column is the receipt at `5710a77` (166 cases, 356,228 bytes, `f3d83752…`), and the diff
`5710a77..HEAD` on the portability test adds 27 case rows and changes the expected outcome of
exactly two existing rows, `def result = ^Person` and `def result = "%(f["nested"])"`, as the report
declares. The report's claim that `5710a77` adds only receipts and documentation over `9bfe19d` is
confirmed by the diffstat: six files, five of them receipts plus the regenerated parity JSON, no
Rust source.

Every case in that corpus runs both scanner variants and asserts equality of the result, the token
slice and the node slice before any record is written, which I confirmed by reading the harness.

### 3. Test suite, Clippy, formatting

```
$ nix develop ~/src/ergodis --command cargo test --release -p ergodis-private \
    --test rel_frontend --test rel_frontend_portability -j 8
running 28 tests … test result: ok. 28 passed; 0 failed
running 1 test  … test result: ok. 1 passed; 0 failed
```

`caret_entity_references_are_decided_by_position`,
`string_interpolation_parts_expressions_and_nesting`,
`reference_unicode_identifier_and_space_boundaries` and
`repeated_success_and_compact_failure_do_not_allocate` all pass. Clippy with `-D warnings` over the
library and both test targets exits 0 with no diagnostics, and `rustfmt --check --edition 2021` over
the frontend sources and both test files exits 0.

### 4. The A/B receipts and one replay

Re-derived from `analysis/rel-frontend/performance-v1-syntax-gaps-composed-e8b4c7c.json`, candidate
`7431e0e8…` over control `c6376274…`, seven rounds, six events, pinned to CPU 5:

| Operation                  |    candidate |      control |    ratio | delta    |
| -------------------------- | -----------: | -----------: | -------: | -------: |
| ascii/parse/byte           |  2,671,114.4 |  2,507,812.2 | 1.065117 | +163,302 |
| ascii/admit/byte           |  3,930,001.9 |  3,754,528.7 | 1.046736 | +175,473 |
| malformed-early/parse/byte |  1,203,178.9 |  1,098,166.4 | 1.095625 | +105,012 |

Every row of all five results tables in the report matches its receipt, as do the A/A nulls and the
scalar cross-table in "The scalar variant is the control on the diagnosis". The decomposition table
is arithmetically consistent: the scanner column sums to the composed scan-only delta, the parser
column is the ASCII parse delta minus it, the admission column is the ASCII admit delta minus the
parse delta, and the per-unit figures follow from 15,489 tokens, 12,288 nodes and the 3,520
references the driver reports. The driver's output gate is real: in all five receipts every
candidate operation's record has the same tokens, nodes, fingerprint, retained bytes, failure and
admission summary as its control, and the ASCII cohort is
(15,489, 12,288, `10c991dc5579904e`, 6,606,852) in every one.

The independent replay:

```
$ nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
    --binary ~/.cache/ergodis/bin/ergodis-tools-e8b4c7c \
    --control ~/.cache/ergodis/bin/ergodis-tools-9bfe19d \
    --rounds 7 --cpu 5 --stages prepare,prepare-touch,parse,admit \
    --events instructions,cycles,branches,branch-misses,page-faults,minor-faults \
    --out <scratch>/ab-replay-composed.json
```

| Operation                  | replay 2026-09-15            | committed receipt            |
| -------------------------- | ---------------------------- | ---------------------------- |
| ascii/parse/byte           | 1.065117 [1.065116, 1.065119] | 1.065117 [1.065116, 1.065119] |
| ascii/parse/scalar         | 1.039455 [1.039454, 1.039455] | 1.039454 [1.039454, 1.039455] |
| unicode/parse/byte         | 1.013041 [1.013040, 1.013042] | 1.013042 [1.013041, 1.013042] |
| comment-string/parse/byte  | 1.034629 [1.034626, 1.034632] | 1.034623 [1.034619, 1.034628] |
| malformed-early/parse/byte | 1.095627 [1.095624, 1.095630] | 1.095625 [1.095620, 1.095631] |

Load average was 3.3 during the replay, against the report's stated 2 to 10; instruction ratios are
insensitive to that, as the playbook says. The replay's A/A instruction nulls are 0.9999972 to
1.0000002, so the protocol held on my run too. The headline ratio reproduces to seven digits and
every other operation's replay interval overlaps its receipt interval.

The non-multiplexing check reproduces as well: a direct `perf stat -x,` of the six-event set on the
ASCII admit stage of `ergodis-tools-e8b4c7c` reports 100.00 in the enabled column on all six rows.

### 5. Mechanism evidence

The symbol-size table is exact at every revision:

| Revision  | byte scan | scalar scan | `Parser::expression` | `admit::run` |
| --------- | --------: | ----------: | -------------------: | -----------: |
| `9bfe19d` |     4,280 |       5,630 |                5,780 |        5,102 |
| `80f3305` |     4,472 |       5,935 |                5,933 |        6,209 |
| `1cc34ae` |     4,997 |       6,694 |                6,816 |        6,430 |
| `d1f24ba` |     5,055 |       7,024 |                6,816 |        6,430 |
| `e8b4c7c` |     5,299 |       7,277 |                6,816 |        6,430 |

At `9bfe19d` and `80f3305` the symbol is `Workspace::scan_variant`; from `1cc34ae` on it is
`lexer::scan`, which is the report's inliner-threshold claim visible in the symbol table. The
percentage growths (24, 29, 18 and 26 per cent) follow. At `e8b4c7c` the two `entity_reference`
symbols are 352 and 368 bytes and the two `string_body` symbols 1,850 and 1,872, as stated.
`f7337c4`, which the report does not tabulate, has `Parser::expression` at 6,104 and `admit::run` at
5,408: the two merged arms did shrink their symbols while costing +30,143 and +57,458 instructions,
which strengthens the report's instructive negative rather than weakening it.

The kernel-scoped profiles under `~/.cache/ergodis/perf-c1170-gaps/` give
`Workspace::scan_variant` 88.80, `lexer::keyword` 9.40 and `from_utf8` 1.60 at `9bfe19d`, and
`lexer::scan` 92.09, `lexer::keyword` 6.38 and `from_utf8` 1.38 at `e8b4c7c` — the report's figures
exactly. Below the report's listing threshold the only other symbol is `__vdso_clock_gettime` at
0.07 per cent, which is the harness timer outside the loop, not a call in it.

I re-measured the scan stage directly with two-point differencing rather than the report's
single-point snapshot, pinned to CPU 5:

| Variant | `9bfe19d` | `e8b4c7c` | delta    | report's delta | cohort proxy |
| ------- | --------: | --------: | -------: | -------------: | -----------: |
| byte    | 1,099,213 | 1,204,385 | +105,172 |       +105,221 |     +105,012 |
| scalar  | 2,459,635 | 2,554,123 |  +94,488 |        +94,540 |      +94,368 |

The absolute counts sit about 2,100 instructions below the report's because two-point differencing
removes process startup, and the deltas agree to within 0.05 per cent. The corroboration claim
stands.

### 6. Contracts against the pinned reference

Every file in `~/.cache/ergodis/rel-frontend-reference/` verifies against `SHA256SUMS.txt`, except
that the manifest carries a line for itself, which cannot verify by construction and predates this
task. All quoted grammar and documentation text is present and quoted accurately. Three line
citations are off by a few lines: the caret appears as an `Operator` alternative at line 431 rather
than 429, the Mathematical Operators range `$[∀-⋿]` is at line 480 rather than 477, and
"In the case of a simple identifier, the parentheses may be omitted" is at line 530 rather than 526.
The `EscapeChar` production at line 503 does admit `'\\' '%'` as claimed, and `staticChar`,
`multiStaticChar`, `DocstringLiteral` and `CharLiteral` are exactly as quoted.

The implementation matches the stated contracts where I probed it. `start` is `_` or
`char::is_alphabetic`, `continuation` adds `char::is_ascii_digit` and nothing else, `space` is
`char::is_whitespace` plus `U+FEFF`, and `'\u{2200}'..='\u{22ff}'` is a `CustomOp` fall-through arm
after the spelled-out operators. `INTERPOLATION_DEPTH` is 8 and `Level` is a `#[repr(C)]`
twelve-byte record, so the "eight twelve-byte entries, 96 bytes" description is right.
`ends_operand` lists the kinds the contract names.

Two contract statements are contradicted by the reference itself and one by the implementation; they
are defects 2, 3 and 7 below.

### 7. The two recorded divergences, and a search for others

Both recorded divergences reproduce. Probing the frontend source directly:

```
"def result = ः"      parse=ok  tokens=[… Name@13..16 …]        (U+0903 starts an identifier)
"def result = xः"     parse=ok  tokens=[… Name@13..17 …]        (and continues one)
"doc \"100% sure\" def f = 1"   parse-err=MalformedInterpolation@8..9 id=REL0105
```

The `Other_Alphabetic` divergence also applies to continuation, not only to starts; the report's
prose and its fixture mention only the start case. Same root cause, so this is a wording gap rather
than a second divergence.

Searching for divergences the report missed, the probe covers: `%` in a line comment (accepted, no
divergence), `%` in a triple-quoted string (opens an interpolation, which the grammar's
`multiStaticChar` requires), `raw"""a % b"""` (literal, correct), `'%'` (a character literal,
correct), `"\%"` (literal sign, correct), `"%^x"` (`MalformedInterpolation`, correct — a caret is
not an identifier start after `%`), `x and ^E` and `a.^b` (entity references, correct under the
operand rule), `1^^E` (power then entity reference), `^^E` (`ExpectedExpression`, as the contract
says), and the whole whitespace and operator boundary set (`U+0085`, `U+000C`, `U+FEFF` separate
tokens; `U+200D` and `U+2300` are `UnexpectedCharacter`; `U+FF11` no longer continues an identifier;
`U+FF41` and `U+2167` start one). All agree between the byte and scalar variants.

Two further findings from that probe are in the defects list: the caret widenings (defect 2) and the
definition-head rejection (defect 3). One observation that is not a defect: `U+2200` itself is
`Kind::Forall` and `U+2203` is `Kind::Exists`, so the lower end of the Mathematical Operators block
is a quantifier rather than an infix operator. The contract's qualifier — "with the spellings that
already had a kind keeping it" — covers this, and the fixture's choice of `U+2201` as the lower
tested edge follows from it, though the report never says why the edge it tests is not the edge it
names.

### 8. The "none of the cost is the features executing" claim

The cohort census, computed from the generator templates in `src/rel_frontend/corpus.rs` at 512
definitions:

| Cohort         | bytes  | carets | per cent signs | identifier chars outside the reference's letter classes |
| -------------- | -----: | -----: | -------------: | ------------------------------------------------------: |
| ascii          | 43,008 |    128 |             64 |                                                        0 |
| unicode        | 61,888 |    128 |             64 |                                                    2,048 |
| comment-string | 65,610 |      0 |              0 |                                                        0 |

The 43,008 bytes and 128 carets match the report's census exactly. Every per cent sign is the
modulo operator outside a string, and no caret is followed immediately by an identifier start, so
the claim that no cohort contains an entity reference or an interpolation is correct, and the
"decisive fact" — the comment-string cohort holds no caret and no per cent sign yet moved +22,148
under the caret candidate — is exactly right. The third clause is not: the Unicode cohort's
identifiers are full of accented Greek letters outside `α-ω` and of `格子`, all of which reach the
changed `start` and `continuation` predicates. See defect 1.

### 9. Mystery ledger and remaining gaps

Ledger items 1 through 5 and item 9 are settled on evidence I reproduced: the cohort census, the
receipt deltas, the symbol table, the direct scan measurement and the kernel-scoped profile. Item 6
is arithmetically as stated (the interpolation candidate's ASCII admit delta of +59,641 minus its
parse delta of +65,961 is −6,320, with `admit::run` 6,430 bytes at both revisions). Items 7 and 8
are open with the evidence gap correctly identified. Nothing on the list is manufactured and I found
no settled item that is actually open.

Of the four remaining gaps, the first, second and fourth are accurate. The third is stale: see
defect 6.

### 10. The lane handoff paragraph

`notes/handoffs/2026-09-05-ergodis-lane.md`, "Syntax gaps by manifest family", is an accurate
summary of the report on every point I checked: the three contracts, the parity corpus and hash, the
zero-allocation gate, the composed 1.0651 and scan-only 1.0956, the two reverted arm merges and the
kept byte-order-mark move, the two recorded divergences, and the control for the next frontend A/B.
It inherits one thing from the report that should be fixed in both places: the parenthetical "the
cohorts contain none of the new syntax" is the claim contradicted in defect 1. It also opens the
commit range at `80f3305` where the report's header opens it at `5710a77`, which is immaterial.

## Defects, ranked

1. **The "none of the cost is the features executing" claim overreaches on the Unicode family.**
   Severity: moderate — it is the report's headline diagnosis and the sentence the handoff repeats.
   The Unicode cohort contains 2,048 identifier characters outside the reference's letter classes,
   so the `start` and `continuation` predicates the family changed do execute on it; and the
   report's own mystery item 5 explains the family's largest measured cost as one
   `c == '\u{feff}'` comparison executing on every character of the shared path, which is executed
   work, not layout. Proposed fix: scope the claim to the families it holds for. Say that the caret
   and interpolation families never fire on any bench cohort, verified by the census, and that
   their cost is therefore entirely the compiled shape; and say separately that the Unicode
   family's cost is partly executed work — the byte-order-mark comparison, which the kept repair
   removed from the shared path — and partly shape. The composed 1.065117 does not change.

2. **Both "deliberate widenings of `ConstructorId`" are conformant to the pinned grammar, and the
   two real widenings are unrecorded.** Severity: moderate, because the widenings are the report's
   own record of where the prototype leaves the reference. `syntax.grammar` line 420 gives
   `idCharInit { $[a-zA-Zα-ωΑ-Ω_] }`, which contains the underscore, so `_x` is
   `idCharInit idChar+` and `^_x` is a valid `ConstructorId`; and keyword specialization is
   `@specialize<BasicId, term>`, which does not reach the separate `ConstructorId` token, so `^end`
   is a `ConstructorId` too — the same argument the report makes two paragraphs later for
   `InterpolationId`. What the prototype does widen, confirmed by probe, is `^_` (a lone underscore
   after the caret, which `idCharSingle { $[a-zA-Zα-ωΑ-Ω] }` excludes) and a caret over the widened
   letter class, so that `^ß`, `^Σ` and `^格子` all scan as one `EntityRef`. Proposed fix: replace
   the two named widenings with these two, and note that `^end` and `^_x` conform.

3. **The definition-head rejection is not the reference's interpolation rule.** Severity:
   low-moderate. The report says an interpolated literal in a definition head is
   `UnsupportedSemantics`, "which is the reference's rule that interpolation may not occur there,
   reached without a special case". A probe shows `def f["a"] = 1` — no interpolation anywhere — is
   also `UnsupportedSemantics` at the same span, so the rejection is the admission stage refusing
   any literal in a head, and it happens to subsume the reference's rule rather than implement it.
   The fixture that claims to cover this is the clearest case of a test not testing what it says:
   under the comment "An interpolation in a definition head is not a name the stage declares", the
   interpolation test parsed and admitted `def f = 1`, a plain definition with no interpolation and
   no head literal, and asserted that it succeeds. Proposed fix: restate as "a definition head
   containing any literal is `UnsupportedSemantics`, which subsumes the reference's rule that
   interpolation may not occur there", and replace that fixture with `def f["%x"] = 1`,
   `def f("%x") = 1` and `def f["a"] = 1`, all asserted to be `UnsupportedSemantics`.

4. **The both-variants claim is false for the caret fixture.** Severity: low, because the parity
   corpus covers the same sources on both variants. The Fixtures section says each case in the
   three tests is checked on both scanner variants with the token stream compared byte for byte.
   In `caret_entity_references_are_decided_by_position` only the three reference-corpus declaration
   cases do that; the accept, entity-reference, rejection and admission loops all call `w.parse`,
   which is `parse_variant::<true>`, the byte scanner alone. The interpolation and Unicode tests do
   compare both variants per case. Proposed fix: either route the caret cases through the same
   two-variant helper the other two tests use, or narrow the sentence to name which cases are
   two-variant in that test.

5. **Parity-case attribution is swapped and one count is wrong.** Severity: low; the total is right
   and the hash is what the gate rests on. The commits table credits `d1f24ba` with nine parity
   cases and the Parity section credits interpolation with ten and the Unicode family with nine.
   Per-commit diffs give seven new caret cases plus one changed outcome at `80f3305`, nine new
   interpolation cases plus one changed outcome at `1cc34ae`, ten new Unicode cases at `d1f24ba`
   and one at `fe4fda7`, which is the 27 that takes the corpus from 166 to 193. As written, the
   report's own enumeration sums to 28. Proposed fix: state the per-commit counts as 7 + 9 + 10 + 1
   with the two changed outcomes called out separately.

6. **Remaining gap 3 asks for work that the report's own commit range already did.** Severity: low.
   It says date and datetime literals "are not in the manifest at all and should be added to it as
   a named gap"; `b51f627` added "date and datetime literals" to the `literals` family's remaining
   list, and the text is there at `HEAD`. Proposed fix: delete that sentence from the gap and keep
   the gap to the items that really are outstanding.

7. **The stated operand-ending kind list is one kind short of the shipped code.** Severity: low.
   The contract enumerates fourteen kinds; `ends_operand` at the final revision has fifteen,
   because `fe4fda7` added `Kind::StringClose`. The header note explains `fe4fda7` separately, so
   this is an internal inconsistency rather than a wrong claim. Proposed fix: add `StringClose` to
   the contract's list with the one-clause reason the code comment gives.

8. **The justification for narrowing the digit class is not exact.** Severity: low. The report says
   the grammar "is the only statement of a digit class anywhere in the reference set". The lexical
   page's prose says an identifier's first character "can be followed by zero or more Unicode
   letters, underscores, or numbers", which is a wider, vaguer statement about the same class, and
   the page's "currently incomplete" remark is explicitly about the letter ranges, not the digits.
   The choice to take prose for letters and grammar for digits is defensible; the reason given for
   it is not quite the reason available. Proposed fix: say that the prose is specific about letters
   and vague about "numbers", that the only precise digit class in the reference set is the
   grammar's `0-9`, and that the incompleteness note covers only the letter ranges.

9. **Three reference line citations are off by a few lines.** Severity: low. The caret as an
   `Operator` alternative is line 431, the Mathematical Operators range is line 480, and the
   parentheses-omitted sentence is line 530. The quoted text is correct in each case.

10. **Two small census and symbol imprecisions.** Severity: very low, neither touches a measured
    number. The caret Fermi prices "about 1,600" applications in the admission stage, where the
    driver reports 1,024 applications and 3,520 references on the ASCII cohort. And
    `lexer::entity_reference` appears at `80f3305` as two out-of-line symbols of 724 bytes, one per
    scanner monomorphization, not one; the report says "an out-of-line symbol" in the singular
    there and correctly says "two" at `e8b4c7c`.

11. **Peak RSS is stated as unchanged and is not.** Severity: low, and the direction is favourable.
    Every operation in the composed receipt records the candidate's peak resident set as 64 to 100
    KiB *below* the control's — 5,948 against 6,016 KiB on the ASCII parse stage, about 1.1 per
    cent, and the same sign on all twenty-seven operations — even though the candidate executable
    is 33,688 bytes larger. Proposed fix: report peak RSS as moved by about one per cent in the
    candidate's favour, with the cause unexplained, rather than as unchanged; or, if the intended
    claim was that no pool grew, say that instead and cite the identical 6,606,852-byte retained
    total, which does hold at every revision.

## What I could not verify, and why

- The Lezer reading of `a^b`. Resolving the `@precedence { ConstructorId Operator }` declaration
  against a real LR state table needs the parser generator, which the pinned reference set does not
  include. The report states the uncertainty and does not build a contract on it beyond the
  state-masking argument, which is sound as an argument about how Lezer tokenizers work.
- The caret, interpolation, Unicode and repair A/Bs were checked against their committed receipts
  but not re-run. The composed replay is the check on the protocol and on the two numbers the
  report headlines; re-running the other four would take roughly twenty minutes of pinned-core time
  and no contested claim depends on it.
- Mystery items 6, 7 and 8 stay open. Closing them needs the per-region `perf annotate` pass over
  `lexer::scan` and `admit::run` that the report names as the single evidence gap behind all three,
  and that was outside this audit.
- Why the candidate's peak resident set is consistently about one per cent below the control's
  (defect 11). I diffed the series in the composed receipt and the sign is uniform, but a cause
  would need a mapping-level look at both processes, which was outside this audit.

## Repairs applied

All eleven defects are repaired. The code repairs are commit `837c441` in `~/src/ergodis-private`,
"C1170: audit repairs - head-interpolation fixture, caret cases on both scanner variants", which
touches `tests/rel_frontend.rs` and `analysis/rel-frontend/portability-v1.json` and nothing else;
the foreign uncommitted files were not staged and their diff still hashes `a954fbdc…`. The document
repairs are uncommitted edits in `~/src/othello`, left for the coordinator to commit.

1. The claim that none of the cost is the features executing is now scoped to the caret and
   interpolation families, with the cohort census quoted and the Unicode family's mixed term named.
   The status paragraph, the vibe check and the composed conclusion were all rewritten, in
   `notes/2026-09-14-c1170-syntax-gaps.md`; the same sentence was scoped in the "Syntax gaps by
   manifest family" paragraph of `notes/handoffs/2026-09-05-ergodis-lane.md`.
2. `^end` and `^_x` are recorded as conformant, with `idCharInit`'s underscore and the
   `@specialize<BasicId, …>` argument given, and `^_` and a caret over the widened letter class are
   recorded as the two real widenings, in `notes/2026-09-14-c1170-syntax-gaps.md`.
3. The definition-head rejection is restated as subsuming the reference's rule, with
   `def f["a"] = 1` as the evidence, and the fixture list updated, in
   `notes/2026-09-14-c1170-syntax-gaps.md`. In the code, the mis-labelled `def f = 1` fixture is
   replaced by `def f["%x"] = 1`, `def f("%x") = 1` and `def f["a"] = 1`, each asserted
   `UnsupportedSemantics`, in `tests/rel_frontend.rs` at commit `837c441`.
4. The caret test's accept, entity-reference, rejection, declaration and admission cases now all run
   through a two-variant helper that compares tokens and nodes, in `tests/rel_frontend.rs` at commit
   `837c441`.
5. The per-commit parity-row counts are corrected to seven, nine, ten and one, with the two changed
   outcomes separated from the new cases, in `notes/2026-09-14-c1170-syntax-gaps.md`.
6. The stale request to add date and datetime literals is replaced by the note that `b51f627` named
   them, in `notes/2026-09-14-c1170-syntax-gaps.md`.
7. `StringClose` is added to the operand-ending kind list with its `fe4fda7` provenance, in
   `notes/2026-09-14-c1170-syntax-gaps.md`.
8. The digit-class justification is rewritten around the page's letters-only incompleteness note and
   its vague "numbers" prose, in `notes/2026-09-14-c1170-syntax-gaps.md`.
9. The line citations are corrected to 431 for the caret as an operator, 480 for the Mathematical
   Operators range and 530 for the parentheses sentence, in
   `notes/2026-09-14-c1170-syntax-gaps.md`.
10. The Fermi's application count is marked as written before the census, against the driver's
    1,024, and `lexer::entity_reference` is described as two symbols, in
    `notes/2026-09-14-c1170-syntax-gaps.md`.
11. Peak resident set is reported as about one per cent lower in the candidate rather than
    unchanged, in `notes/2026-09-14-c1170-syntax-gaps.md`.

Gates after the repairs, all under `nix develop ~/src/ergodis --command …`: the frontend suite is 28
passed and 0 failed in `rel_frontend` plus 1 passed in `rel_frontend_portability`; the
zero-allocation regression passes on its own as well; strict Clippy over the library and both test
targets is clean and `rustfmt --check` is clean; and the parity replay gives 193 cases, 369,710
canonical bytes and native/WASM byte equality with the canonical SHA-256 unchanged at
`c5d836251b8b24e2b58c513a89a7726acc8f922533e9df681fc24ec3ca9aafba`. The regenerated
`portability-v1.json` differs from its previous revision in one field only, the recorded source
hash of `tests/rel_frontend.rs`; the canonical hash, the case count, the record summary and both
compiled library hashes are identical.

A note on the repaired report: the "Audit corrections (2026-09-15)" section appended to
`2026-09-14-c1170-syntax-gaps.md` points back to this file, so the correction trail is recoverable
from either end.

Two concurrency notes for whoever commits the document edits. In the private repository a parallel
session's commit `fb69af8`, "C1170: audit repairs - unmerged same-level modules and arity-distinct
parameter shadowing fixtures", landed on top of `837c441` and added forty-two lines to the same test
file without touching any of the hunks above; the suite passes at that head. In `~/src/othello` the
working tree also carries that session's edits to `2026-09-14-c1170-admission-census-db47ee1.md`,
`2026-09-14-c1170-inline-reference.md` and `2026-09-14-c1170-module-scopes.md`, and the lane handoff
`handoffs/2026-09-05-ergodis-lane.md` may hold hunks from both sessions, so it should be inspected
with `git diff HEAD -- notes/handoffs/2026-09-05-ergodis-lane.md` before staging rather than swept
in whole.
