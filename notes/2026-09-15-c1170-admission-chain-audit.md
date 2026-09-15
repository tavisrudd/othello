# C1170 admission-chain audit: independent verification of the six admission and module-scope reports

**Lane**: `ergodis`

**Date**: 2026-09-15

**Status**: complete.

**Scope**: independent read-only verification of the conclusions in
`notes/2026-09-14-c1170-admission-optimizations.md`,
`notes/2026-09-14-c1170-traversal-cursor.md`,
`notes/2026-09-14-c1170-admission-census-db47ee1.md`,
`notes/2026-09-14-c1170-scopes-pool-and-annotate.md`,
`notes/2026-09-14-c1170-inline-reference.md`, and
`notes/2026-09-14-c1170-module-scopes.md`, against the code and receipts in
`~/src/ergodis-private` at `main` / `6f0e9ec`. The later syntax-gaps report is
audited separately by another reviewer and is read here only for context.

Every measurement below was taken against retained binaries rather than a fresh build, so nothing
here depends on the tree's state; the census re-fit and the test-gate run were done while
`ergodis-private` stood at `6f0e9ec`. That branch advanced to `837c441` during this audit, from the
concurrent syntax-gaps review, which touches no file this audit measures.

## Verdict

**Confirmed**

- Every retained binary the six reports cite exists, every quoted sha256 matches the file on disk,
  and every one carries rustc 1.95.0 in its `.comment` section, so nothing in the chain is
  toolchain-stale (`sha256sum` and `readelf -p .comment` over the nine `ergodis-tools-*` arms).
- Every headline ratio re-derives from the committed receipts: composed ASCII admission 0.772673
  against `185015e`, 0.924742 against `49bbb9a`, 0.911998 against `3bd5e38`, 1.097623 against
  `93bb343`, plus the per-candidate ratios 0.9525, 0.8676, 0.9350, 0.9614, 0.9619 and the `prepare`
  and `prepare-touch` figures 0.904952 and 0.968028 (audit section "Re-derivation of the headline
  ratios").
- Two A/Bs re-run independently a day later — `3bd5e38` to `93bb343`, and `93bb343` to `9bfe19d` —
  reproduce the committed ratios to within three parts per million and land inside the stated
  intervals, under the playbook protocol with the non-multiplexing event set (audit section
  "Independent re-runs of two A/Bs").
- The non-interaction claims hold and hold better than stated: the per-commit products agree with
  the composed measurements to 1 to 3 parts per million on every cohort (audit section "The
  non-interaction arithmetic").
- The census fit at `db47ee1` reproduces bit-for-bit from the committed class receipt — all
  twenty-one coefficients, every synthetic residual, every leave-one-family-out figure, the
  condition number and all three cohort predictions — and the cohort figures are +0.914, +0.808 and
  +1.981 per cent as reported (audit section "The census cost model at `db47ee1`").
- The module-scope fixtures test what they claim: the seven parity cases match their seven
  descriptions one for one, and the unit test asserts error codes, spans, related sites, rendered
  diagnostic text and binder counts rather than merely admitting (audit section "The module-scope
  test fixtures").
- The 166-case corpus hash `f3d83752…` is as reported, the corpus now stands at 193 cases with
  canonical hash `c5d83625…` exactly as the syntax-gaps report states, and all seven module cases
  remain in it (audit section "The parity corpus, then and now").
- The foreign uncommitted diff still hashes `a954fbdc…` today, the value every report in the chain
  records at its start and end, so the "both arms saw the same foreign tree" claim is verified
  rather than asserted (audit section "The foreign tree").
- The frontend gate passes on the tree as it stands: 28 + 1 tests, zero-allocation regression
  included (audit section "Gates re-run at HEAD").
- Two priced-but-untaken candidates check out against the compiled code: the hash loop is eight
  instructions per byte with a two-instruction bounds check, and the `same()` byte loop is thirteen
  per byte with four removable, matching the 36,700 and 20,500 prices (audit section
  "Priced-but-untaken candidates").

**Contradicted**

- The inline-reference report's even-split counterfactual: the admission-alone ratio would be 0.931,
  not "about 0.980", and a 6.9 per cent saving is not "barely worth keeping" (defect 1).
- The module-scopes report's "the model is over-determined and holds": the three-term decomposition
  is exactly determined with one spare constraint, and its quoted per-cohort residuals measure
  coefficient rounding (defect 2).
- The census report's and the handoff's attribution of the five-per-cent pricing floor to the
  model's out-of-sample error, which is 0.8 to 2.0 per cent (defect 3).
- Three smaller numeric slips: the stated product 0.77264 (correct: 0.772674), the handoff's 0.6515
  cumulative figure (correct: 0.6513), and two rows that mix the byte and scalar variants
  (defects 5, 6, 7).

**Could not check**

- The gates at the ten individual candidate revisions, because checking them out would modify the
  working tree; the gate was re-run at `6f0e9ec` instead.
- The native/WASM parity replay itself, which builds a WASM target; the committed receipt was read
  instead.
- The uncommitted wrapped-`insert` census behind the "836 of 905 rejected by the gate" figure, which
  the report already declares as scratch.
- Peak RSS, fault counts and profile shares, which were read from the receipts and the existing
  profile files rather than re-measured.
- Whether the adopted module semantics match Rel as RelationalAI implements it: the published formal
  semantics has no module construct at all, so it can settle only the binding-precedence direction,
  which the implementation matches (audit section "The module-scope semantics against the published
  Rel formal semantics").

## Retained binaries and toolchain

Every binary the six reports name is present under `~/.cache/ergodis/bin/`, and every sha256 the
reports quote matches the file on disk. Measured with `sha256sum`:

| Binary                  | Measured sha256                                                    | Report that quotes it                     | Match |
|-------------------------|--------------------------------------------------------------------|-------------------------------------------|-------|
| `ergodis-tools-185015e` | `59d8b1e622b912077d92f5b2eae159ea170942c642ddfa15ac36ea857783e249` | admission-optimizations                   | yes   |
| `ergodis-tools-7817627` | `dd09841e345fe6b3cad95a9353dff4c6ef16c63e34c47124a6de3b6f53cf16cb` | admission-optimizations                   | yes   |
| `ergodis-tools-de35905` | `055272bd1fc6d6e2d71ca96b6d0178e63abb69b6dac212b07fa88def74aa2836` | admission-optimizations                   | yes   |
| `ergodis-tools-49bbb9a` | `06f946d59fc73657a799c4c9e8182aca0c64b82bc2186fd9e86768c739636c7a` | admission-optimizations, traversal-cursor | yes   |
| `ergodis-tools-5578357` | `f2e3790615c14d8513c9a5b93d79c4b6b29e8a440603fce15f150c94493f853a` | traversal-cursor                          | yes   |
| `ergodis-tools-db47ee1` | `6e41d1d608ea72d9c998a5b9d4ff7788e9f303a44398ebd95b1eaae3fd7920ba` | traversal-cursor, census                  | yes   |

The other retained arms these reports and their successors use are also present and hash-stable:
`ergodis-tools-3bd5e38` `41459b56…9761d782`, `ergodis-tools-93bb343` `520e6057…8d648d18`,
`ergodis-tools-9bfe19d` `c6376274…62fa5019`, plus `7b38c65`, `4b02031`, `32a18c6`, `35f4484`,
`49493a3` and `52d48eb`. Nothing the reports cite is missing.

Every one of these binaries carries `rustc version 1.95.0` in its `.comment` section, read with
`readelf -p .comment`, so no arm in the chain is toolchain-stale and no ratio in these reports
crosses a compiler pin.

## Re-derivation of the headline ratios from the committed receipts

A single script (kept in the audit scratchpad, not committed) reads a receipt, takes the
instruction means of the `admit` and `parse` operations for each cohort and variant on both arms,
and forms the admission-alone difference and ratio independently of anything the reports assert.
Every headline number re-derives:

| Receipt                                              | Cohort         | Report ratio | Re-derived   | Candidate / control instructions |
|------------------------------------------------------|----------------|--------------|--------------|----------------------------------|
| `performance-v1-admit-hash-once-7817627.json`         | ascii          | 0.9525       | 0.952507     | 1,661,006 / 1,743,825            |
| `performance-v1-admit-builtin-gate-de35905.json`      | ascii          | 0.8676       | 0.867613     | 1,441,116 / 1,661,012            |
| `performance-v1-admit-one-scan-49bbb9a.json`          | ascii          | 0.9350       | 0.934981     | 1,347,406 / 1,441,105            |
| `performance-v1-admit-composed-49bbb9a.json`          | ascii          | **0.7727**   | **0.772673** | 1,347,415 / 1,743,837            |
| `performance-v1-admit-composed-49bbb9a.json`          | unicode        | 0.7778       | 0.777783     | 1,533,927 / 1,972,180            |
| `performance-v1-admit-composed-49bbb9a.json`          | comment-string | 0.7028       | 0.702807     | 394,105 / 560,758                |
| `performance-v1-admit-cursor-5578357.json`            | ascii          | 0.9614       | 0.961361     | 1,295,352 / 1,347,415            |
| `performance-v1-admit-scan-hoist-db47ee1.json`        | ascii          | 0.9619       | 0.961908     | 1,246,010 / 1,295,352            |
| `performance-v1-admit-composed-db47ee1.json`          | ascii          | **0.9247**   | **0.924742** | 1,246,010 / 1,347,414            |
| `performance-v1-admit-inline-93bb343.json`            | ascii          | **0.9120**   | **0.911998** | 1,135,830 / 1,245,430            |
| `performance-v1-admit-modules-composed-9bfe19d.json`  | ascii          | **1.0976**   | **1.097623** | 1,246,715 / 1,135,832            |

The composed saving of 396,422 instructions and the cumulative 0.7145 of `185015e` after the
traversal task both re-derive exactly (1,246,010 / 1,743,837 = 0.714522).

## Independent re-runs of two A/Bs

Both re-runs used the committed harness under the pinned shell, seven interleaved rounds, CPU 5,
the non-multiplexing event set, and the same stage pair, exactly as the playbook and the reports
specify. Load average was 3.0 to 3.9 throughout, comparable to the original runs.

```sh
cd ~/src/ergodis-private
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
    --binary ~/.cache/ergodis/bin/ergodis-tools-93bb343 \
    --control ~/.cache/ergodis/bin/ergodis-tools-3bd5e38 \
    --rounds 7 --cpu 5 --stages parse,admit \
    --events instructions,cycles,branches,branch-misses,page-faults,minor-faults \
    --out <scratchpad>/audit-inline-93bb343.json
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/bench.py \
    --binary ~/.cache/ergodis/bin/ergodis-tools-9bfe19d \
    --control ~/.cache/ergodis/bin/ergodis-tools-93bb343 \
    --rounds 7 --cpu 5 --stages parse,admit \
    --events instructions,cycles,branches,branch-misses,page-faults,minor-faults \
    --out <scratchpad>/audit-modules-composed-9bfe19d.json
```

| A/B                   | Cohort         | Committed | My re-run                     | Inside the stated interval |
|-----------------------|----------------|-----------|-------------------------------|----------------------------|
| `3bd5e38` → `93bb343` | ascii          | 0.911998  | 0.911996 [0.911989, 0.912002] | yes                        |
| `3bd5e38` → `93bb343` | unicode        | 0.924552  | 0.924551                      | yes                        |
| `3bd5e38` → `93bb343` | comment-string | 0.949239  | 0.949255                      | yes                        |
| `93bb343` → `9bfe19d` | ascii          | 1.097623  | 1.097626 [1.097618, 1.097635] | yes                        |
| `93bb343` → `9bfe19d` | unicode        | 1.083519  | 1.083513                      | yes                        |
| `93bb343` → `9bfe19d` | comment-string | 1.146831  | 1.146829                      | yes                        |

Both runs passed the harness's own output gate (equal tokens, nodes, failures, admission summaries
and representation fingerprints on every operation and both scanner variants; `bench.py` raises
instead of writing a receipt otherwise), and both wrote receipts at 100 per cent enabled on all six
events. The agreement is at the part-per-million level, which is what the reports claim for this
protocol, on a box under a different load a day later. The measurement protocol reproduces.

## The non-interaction arithmetic

The claim that the per-commit ratios multiply to the composed ratio holds, and holds better than
the reports state.

| Chain                                      | Product of per-commit ratios | Composed measurement | Difference |
|--------------------------------------------|------------------------------|----------------------|------------|
| hash-once × builtin-gate × one-scan, ascii | 0.772675                     | 0.772673             | 2.9 ppm    |
| the same three, unicode                    | 0.777781                     | 0.777783             | 2.2 ppm    |
| the same three, comment-string             | 0.702805                     | 0.702807             | 2.5 ppm    |
| cursor × scan-hoist, ascii                 | 0.924741                     | 0.924742             | 1.1 ppm    |

One arithmetic slip, in the safe direction: the admission-optimizations report states the product
of its own rounded ratios as "0.9525 × 0.8676 × 0.9350 = 0.77264". That product is 0.772674, not
0.772640, so the agreement with the measured 0.772673 is one part per million rather than the three
parts in a hundred thousand the report claims. The conclusion (the three changes do not interact)
is unaffected and is in fact better supported.

## The census cost model at `db47ee1`

I re-ran the committed fit from the committed class receipt, writing its output to the audit
scratchpad so that nothing in the repository was touched:

```sh
cd ~/src/ergodis-private
nix develop ~/src/ergodis -c uv run --with numpy --with scipy python3 \
    analysis/rel-frontend/admit-model.py \
    --classes analysis/rel-frontend/performance-v1-admit-classes-db47ee1.json \
    --binary ~/.cache/ergodis/bin/ergodis-tools-db47ee1 \
    --work <scratchpad>/census-audit --out <scratchpad>/model-audit.json
```

Every numeric field of the re-fitted model is bit-identical to the committed
`performance-v1-admit-model-db47ee1.json`: all twenty-one coefficients, every synthetic residual,
every leave-one-family-out figure, the condition number, and all three cohort predictions. The only
structural difference is three extra recorded census counts (`hash_bytes_declare`,
`hash_bytes_reference`, `hash_bytes_bind`) that the census script at `6f0e9ec` emits and the older
committed JSON does not carry; they are recorded counts, not model columns, so they change no
coefficient. The fit is reproducible.

The out-of-sample cohort figures check out against the model's own numbers: the ASCII residual is
11,387.39 on a measured 1,246,010.59, which is +0.914 per cent; unicode 11,568.13 on 1,431,946.54,
+0.808 per cent; comment-string 7,367.90 on 371,997.18, +1.981 per cent. The report's
+0.91 / +0.81 / +1.98 are correct. The ASCII class measurement of 1,246,011 also sits inside the
composed A/B's interval for the same binary, so the class run and the A/B measured the same thing.

Every coefficient the report quotes in its per-unit table is the coefficient in the committed
model: 7.8885 per hashed name byte, 64.0840 per first sight, 5.5288 per pool node, 31.9765 per
visit, 194.2320 per definition declared, 71.4949 for the fixed part of a reference, 20.6670 per
`BUILTINS` entry examined behind the gate, and 0.0000 for both `builtin_bytes` and `colon_nodes`.
The leave-one-family-out figures also match, including the two that matter for the report's own
caution: `header` +43.69 and `qualified` +30.77 on the withheld rows, against 1 to 3 per cent for
the definition, node, ref-binder and mixed families. The condition number is 2.25 × 10^18, so the
design is numerically singular as the report says.

The claim that the model "ranks but cannot price a saving under about five per cent" is the right
practical rule but is attributed to the wrong quantity. The measured out-of-sample cohort error is
0.81 to 1.98 per cent, so a five-per-cent saving is two and a half to five times that error, not
inside it. What actually justifies a five-per-cent line is the unidentified per-unit splits — the
pool-scan against the traversal, and the binder scan against the fixed per-reference cost — whose
withheld-family residuals run to 44 and 31 per cent. The rule should be stated from those, and the
same sentence in the lane handoff carries the same misattribution.

## The module-scope semantics against the published Rel formal semantics

The paper is cached and its integrity is recorded: key `arxiv:2504.10323`, sha256
`6e1371160602b1df77d9e5a647369bcd747aec3e8a97e36d2e99f04c219194b6`, 14 pages, text extraction at
`/tmp/persistent/tavis/lit-search/text/arxiv_2504.10323.txt`, retrieved with
`python3 /tmp/persistent/tavis/lit-search/bin/litcache.py get arxiv:2504.10323`.

**Addendum A contains no module construct of any kind.** A case-insensitive search for "modul" over
the whole extracted text returns three hits, all of them the arithmetic operation "modulo"
(`grep -n -i 'modul'` on the extraction). There is no namespace, no qualified-name, and no member
notion anywhere in the paper; its environment is a single flat partial map from identifiers to
relations, and `J x K mu = mu(x)`. The published formal semantics therefore can neither confirm nor
contradict the seven rules in the report's "Semantics adopted" section, and the report's own framing
— that these are the stage's stated contract and not a claim about Rel — is accurate rather than
evasive.

The one place the paper does bear on the adopted rules is the direction of shadowing. Addendum A
defines environment extension as `mu (+) nu` with the rule that "if mu and nu consider a common
variable, nu takes precedence", that is, the inner binding wins. Adopted rules 2 and 4 say the same
thing for module chains and module parameters, and the implementation matches: `admit::lookup`
scans `w.binders` from the end backwards ("Binders of the definition being checked, innermost
first"), so a body's own parameter beats a module parameter, and `admit::enter_scope` builds the
chain innermost-first and then binds module parameters outermost-first so that an inner module's
parameter shadows an outer one. No contradiction with the published convention.

One caution about the citation. The coverage manifest at `6f0e9ec` now lists the paper in its
`references` array, described there as "Addendum A is the formal semantics of the logical core, the
contract for the C1189 reference evaluator", while the same manifest's `semantic_admission_scope`
field describes module-scoped visibility, module parameters as binders and member lookup. Those two
fields are adjacent, and nothing in the manifest says the paper is silent on modules. The module
rules come from the editor grammar (`reference_grammar_commit`
`f1b3c851d35c54bbd70b1f4eabf744d896206035`) and the `rel.relational.ai` reference documentation,
not from the paper.

## The module-scope test fixtures

Both fixture sets test what the reports claim they test.

The seven parity cases added at `7b38c65` are present in `tests/rel_frontend_portability.rs` and
match the seven descriptions in the report one for one: bare-name shadowing across a module boundary
(`module M / def a = 1 / def b = a / end / def c = a(1, 2)`), an arity split between a top-level
clause and a module clause, nested module parameters (`module M[R] / module N[S] / def f(x) = R(x)
and S`), an unknown member (`def c = M:z`), an instantiated member (`M[edge]:a(1)`), a member arity
mismatch (`M:a(1, 2)`), and a member spine continuing into symbol-keyed access (`M:N:a:tag`).

The unit test `admission_scopes_modules_binds_parameters_and_resolves_members` in
`tests/rel_frontend.rs` covers adopted rules 2, 3, 4, 5 and 7 with assertions that discriminate, not
merely with sources that admit: it asserts `ErrorCode::ArityMismatch` with the exact `found`,
`expected` and `related` span for the base-relation arity fixing and for the module clause shadowing
a top-level one; it asserts `ErrorCode::UnknownMember`, its identifier `REL0406`, its semantic
classification, the related site for both a top-level and a nested module, and the rendered
diagnostic text; it asserts the binder count (3 for `module M[R] / def f(x) = R(x) / def g = R`) so
that module parameters are counted once per body that sees them; and it asserts that an escaped use
of a module parameter is still `UnboundName`.

Two gaps in the fixtures, both small:

- Adopted rule 6, "Not merged" (two `module M` items at one level are two module symbols, so members
  of the second are not reachable through the first), has no test in either file. A search for a
  second `module M` header in `tests/rel_frontend.rs` finds none. The code is consistent with the
  rule — `insert` sets `SHADOWED` only when the owners differ, so two same-level modules are not
  flagged and the first spelling match wins — but the recorded limit is unexercised.
- The fixture for "a body's own parameter shadows a module parameter" is
  `module M[R] / def f(R) = R(1) / end`, and it only asserts that the source admits. Both spellings
  are binders, so `lookup` returns `Resolved::Binder` on the innermost match either way and the
  source admits under either shadowing direction. The direction is verified by reading `lookup`, not
  by this fixture.

## The parity corpus, then and now

The 166-case corpus hash the module-scopes report quotes,
`f3d837520b04cf5d829ecad53dc34ed0a7332b4c18ca77415244d17fa0c7c814`, is what the report states, and
the corpus has since grown under the syntax-gaps work. The committed
`analysis/rel-frontend/portability-v1.json` at `6f0e9ec` records 193 cases, 369,710 canonical bytes,
`native_wasm_byte_equal` true, and canonical SHA-256
`c5d836251b8b24e2b58c513a89a7726acc8f922533e9df681fc24ec3ca9aafba`, which is the hash the
syntax-gaps report quotes as `c5d83625…`. All seven module cases are still in the corpus source.

## Gates re-run at HEAD

```sh
cd ~/src/ergodis-private
nix develop ~/src/ergodis --command cargo test --release -p ergodis-private \
    --test rel_frontend --test rel_frontend_portability -j 4
```

28 passed and 1 passed, zero failed, including
`admission_is_deterministic_over_the_cohorts_and_does_not_allocate` (the zero-allocation regression)
and `measurement_cohorts_are_deterministic_and_do_not_allocate`. The counts grew from the 24 + 1 and
25 + 1 the reports record at their own revisions because the syntax-gaps work added tests since; the
gates the reports rely on still pass on the tree as it stands.

## The foreign tree

Every report in the chain records the uncommitted foreign diff as hashing
`a954fbdceb3a9ea474c3406ec70e7419a7fd02b2026f400f21197fb7b6a2df28` at its start and end. Running
`git diff | sha256sum` in `~/src/ergodis-private` at `6f0e9ec` today returns exactly that hash. The
foreign work has not moved across the whole chain, and the reports' statement that both arms of
every A/B saw the same foreign tree is verified rather than asserted.

## Priced-but-untaken candidates, spot-checked against the compiled code

Two of the priced candidates that the chain left on the shelf are checkable from the retained
binaries, and both prices hold.

The hash loop's per-byte bounds check, priced at 2 of 8 instructions per byte, 36,700 instructions,
2.9 per cent. Disassembling `admit::reference` in `ergodis-tools-3bd5e38` shows the loop is exactly
eight instructions per byte and the first two are the bounds check:

```text
869d30:  cmp    r11,rax
869d33:  jae    86a3c3          ; the panic path
869d39:  movzx  edx,BYTE PTR [r10+r11*1]
869d3e:  xor    ebp,edx
869d40:  imul   ebp,ebp,0x1000193
869d46:  inc    r11
869d49:  cmp    rcx,r11
869d4c:  jne    869d30
```

Two per byte over the 18,333 hashed bytes is 36,666, which is the report's 36,700.

The `same()` per-byte bounds checks, priced at 4 of 12 to 13 per byte, 20,500 instructions, 1.6 per
cent. The `symbol-same` region of `ergodis-tools-db47ee1` compiles to thirteen instructions per byte
(`0x869fd0`–`0x869fff`), of which two `cmp`/`jbe` pairs are the bounds checks and two further `mov`
instructions exist only to zero-extend the indices those checks compare. Four per byte over 5,117
compared bytes is 20,468, the report's 20,500, and the residual loop of nine per byte matches the
report's "8 to 9 per byte". If anything the price is conservative, since the two zero-extending
moves may go with the checks.

## The module-scope three-term cost model

The composed module-scope cost is real and reproduces (my own re-run of the `93bb343` to `9bfe19d`
A/B is above). What needs qualifying is the report's claim that the three-term decomposition is
"over-determined and holds".

The three coefficients are not three independent measurements. The per-body coefficient, 21.19, is
solved from the two cohort equations of the first step (`7b38c65` over `93bb343`), where the model
has two terms and two cohorts and the solve is exact by construction. Carrying that coefficient
forward, the per-reference and per-symbol coefficients at `4b02031` are then solved from the two
cohort equations of the composed `4b02031` A/B, again two equations for two unknowns:

```
ascii:           3520 R + 1545 S = 138,732 - 576 x 21.19 = 126,527   ->  R = 12.64, S = 53.10
comment-string:   768 R +  896 S =  68,134 - 512 x 21.19 =  57,285
```

which is exactly the 12.64 and 53.10 the report reports. The composed figure at `9bfe19d` then
follows by subtracting the measured per-symbol saving: 138,732 − 27,845 = 110,887 on ASCII against
110,883 measured, and 68,134 − 16,339 = 51,795 on comment-string against 51,778 measured. Those
agreements are arithmetic consequences of the three A/B steps being consistent with each other, not
an independent test of a three-term structure, and the residuals the report quotes (0.01 per cent on
ASCII, 0.4 per cent on comment-string) are dominated by rounding the coefficients to three figures.
Unicode adds nothing, because its body, reference and symbol counts are identical to ASCII's — the
report itself says so for the earlier two-term solve and should say it here too.

What the design does genuinely establish, and it is worth stating in these terms instead:

1. The three steps sum to the composed measurement to within two instructions in 110,883
   (92,311 + 46,419 − 27,845 = 110,885), which is a protocol consistency check across four
   separately retained binaries.
2. The per-symbol saving from inlining `insert` is 18.02, 18.05 and 18.23 instructions on three
   cohorts whose reference-to-symbol ratios run from 0.86 to 2.28. That is a genuinely identified
   per-symbol quantity and it is the one constraint the decomposition has to spare.

So the conclusion — that the shadow-flagging walk inside `insert` costs about 35 instructions per
symbol and is roughly half the feature's cost — is supported, but by one over-determining constraint
agreeing to 1.2 per cent, not by a model that closes on two cohorts to a quarter of a per cent.

## Defects, ranked

1. **The inline-reference report's even-split counterfactual is computed on the wrong stage and the
   conclusion drawn from it is wrong.** The report says: "Had the ASCII cohort's reference mix been
   the comment-string cohort's even split, the stage ratio would have been about 0.980 instead of
   0.912 and the change would have read as barely worth keeping." With the report's own per-site
   savings of 40.3 and 8.8 instructions, an even split of 3,520 references removes 86,434
   instructions, and the admission-alone ratio — which is what 0.912 is — would be
   (1,245,430 − 86,434) / 1,245,430 = **0.931**, a 6.9 per cent saving. The quoted 0.980 is roughly
   the full `admit` stage ratio including parse (0.977), so the sentence compares two different
   bases. A 6.9 per cent saving is above this lane's own five-per-cent line for believing a
   candidate, so "barely worth keeping" does not follow. *Fix:* restate as "about 0.931 on the
   admission stage, a 6.9 per cent saving rather than 8.8 per cent", and replace "barely worth
   keeping" with the real point, which is that the per-site split matters for pricing the next
   multi-site inline.

2. **The module-scopes report calls its three-term model over-determined when it is exactly
   determined plus one spare constraint.** Detail and the arithmetic are in the section above.
   *Fix:* replace "The model is over-determined and holds, which is what the earlier two-term fits
   could not claim" with the two statements that are true: the three A/B steps sum to the composed
   figure to within two instructions, and the per-symbol saving is cohort-independent to 1.2 per
   cent across three cohorts. Drop the per-cohort residual percentages, which measure coefficient
   rounding.

3. **The census report's five-per-cent rule is attributed to the cohort residual, which is 0.8 to
   2.0 per cent.** *Fix:* attribute the rule to the unidentified per-unit splits, quoting the
   withheld-family residuals of +43.69 per cent on `header` and +30.77 on `qualified`, which is what
   actually prevents the model from pricing a single unit's change. The lane handoff repeats the
   same sentence and needs the same correction.

4. **The lane handoff omits the module-scopes report's own strongest caveat.** Ledger item 7 of that
   report states that `admit::shadowed`, `admit::qualified` and `admit::member` execute on no bench
   cohort at all — no ASCII, Unicode or comment-string spelling is declared at two owner levels and
   no cohort writes a member spine — so the measured 1.0976 prices the guards and not the resolution
   paths they guard. The handoff paragraph gives the 1.0976 and the three-term model with no hint of
   this. *Fix:* add one clause to the handoff paragraph: the level-aware resolution path is measured
   only by the parity cases and unit tests, and a corpus variant with shadowed spellings and member
   spines is the outstanding evidence gap.

5. **An arithmetic slip in the admission-optimizations report's non-interaction check, in the safe
   direction.** It states "0.9525 × 0.8676 × 0.9350 = 0.77264 against the 0.77267 measured end to
   end". That product is 0.772674, so the agreement is one part per million rather than the three
   parts in a hundred thousand claimed. The conclusion is unaffected and is in fact better supported.
   *Fix:* correct the product and the quoted agreement.

6. **The handoff's cumulative figure after the inline is two units high in the fourth digit.** It
   says the stage stands at 0.6515 of `185015e`; the receipts give 1,135,832 / 1,743,837 = **0.6513**.
   *Fix:* change to 0.6513.

7. **Two rows mix the byte and scalar variants within one line.** The traversal-cursor report's
   composed table gives the comment-string candidate as 371,998 (the scalar figure) beside the ratio
   0.9439 (the byte figure, 372,015 / 394,112 = 0.943891); the scopes-pool report says comment-string
   admission lost "505 instructions" where the receipt gives 517 on the byte variant and 507 on the
   scalar. Cosmetic, and no conclusion turns on it. *Fix:* quote one variant per row.

8. **Two adopted module-scope rules are not exercised by any fixture.** Rule 6 ("Not merged": two
   `module M` items at one level are two module symbols) has no test at all, and the fixture for
   rule 4's "a body's own parameter shadows a module parameter" cannot fail under either shadowing
   direction, because both spellings are binders and the source admits either way. *Fix:* add a case
   with two same-level `module M` items whose second declares a member the first does not, and give
   the parameter-shadowing case different arities so the wrong direction produces an
   `ArityMismatch`.

## What the reports got right that is worth recording

- Every ratio, instruction count and interval quoted as a headline in all six reports re-derives from
  the committed receipts. I found no receipt whose numbers disagree with the report that cites it.
- Two A/Bs re-run a day later on a differently loaded box reproduce to the part-per-million level.
- The committed census fit reproduces bit-for-bit from the committed class receipt.
- The foreign-diff hash the reports carry through the whole chain reproduces today.
- The reports' own diagnoses of their mispriced Fermis (the inlining of `insert` in candidate 1, the
  `BUILTINS` walk at 228 rather than 175 instructions, the two inlining boundaries in the module
  work) are each supported by evidence in the report beyond the measurement they explain, and the
  module-scopes report's ledger is candid about what its own number does not cover.

## What I could not verify, and why

- **The gates at the individual candidate revisions.** The reports record tests, Clippy, rustfmt and
  the native/WASM parity replay at `7817627`, `de35905`, `49bbb9a`, `5578357`, `db47ee1`, `3bd5e38`,
  `93bb343`, `7b38c65`, `4b02031` and `9bfe19d`. Checking those out would modify the working tree,
  which this audit is not permitted to do. I ran the frontend test gate at `6f0e9ec` instead: 28 + 1
  pass, zero-allocation regression included. Note that the inline-reference and module-scopes reports
  themselves mark their gate rows "as run by the lead, not rerun here", so those rows have never been
  independently re-executed by anyone.
- **The parity replay itself.** `portability.py` builds a WASM target; I read the committed receipt
  rather than re-running it. The receipt's case count, canonical byte count, byte-equality flag and
  canonical hash are as quoted, and the seven module cases are present in the corpus source.
- **The wrapped-`insert` census that supports the "836 of 905 rejected by the gate" figure.** The
  admission-optimizations report states that this wrapper was a scratch script and is not committed.
  The claim it supports is checked indirectly by the measurement it predicted to 1.5 per cent, which
  I did re-derive.
- **The `perf` region maps and profile shares.** The five cited `.data` files exist under
  `~/.cache/ergodis/perf-c1170/` at the sizes the reports give, and the region map is committed, but
  re-running `perf record` would be a fresh profile rather than a check of theirs. I verified the two
  compiled loops that the priced candidates rest on instead, directly from the retained binaries.
- **Peak RSS, `prepare-touch` fault counts and retained-byte figures.** Read from the receipts, not
  re-measured.
- **Whether the module-scope semantics match Rel as implemented by RelationalAI.** The published
  formal semantics does not cover modules at all, and the lane has no executable Rel reference. The
  adopted rules can be checked for internal consistency and against the paper's binding-precedence
  convention, both of which they pass, and no further.

## Repairs applied (2026-09-15)

All eight defects are repaired. The private-repository work is one commit,
**`fb69af8`** on `main` of `~/src/ergodis-private`, "C1170: audit repairs - unmerged same-level
modules and arity-distinct parameter shadowing fixtures", one file changed, 42 insertions, staged
and committed with an explicit whole-file pathspec; the fifteen foreign uncommitted files under
`analysis/campaign-console/mockups/` and `packages/` were not touched.

| Defect | What was repaired                                                         | File                                                      | Commit    |
|--------|---------------------------------------------------------------------------|-----------------------------------------------------------|-----------|
| 1      | Even-split counterfactual restated on the admission stage as 0.931         | `notes/2026-09-14-c1170-inline-reference.md`              | uncommitted |
| 2      | "Over-determined" replaced by what the design establishes                   | `notes/2026-09-14-c1170-module-scopes.md`                 | uncommitted |
| 3      | Five-per-cent floor re-attributed to the unidentified per-unit splits       | `notes/2026-09-14-c1170-admission-census-db47ee1.md` and the handoff's census paragraph | uncommitted |
| 4      | Guards-not-paths caveat added to the module-scopes handoff paragraph        | `notes/handoffs/2026-09-05-ergodis-lane.md`               | uncommitted |
| 5      | Product corrected to 0.772674 in three places                               | `notes/2026-09-14-c1170-admission-optimizations.md`       | uncommitted |
| 6      | Cumulative figure after the inline corrected to 0.6513                      | `notes/handoffs/2026-09-05-ergodis-lane.md`               | uncommitted |
| 7      | Byte and scalar variants no longer mixed within a row                       | `notes/2026-09-14-c1170-traversal-cursor.md`, `notes/2026-09-14-c1170-scopes-pool-and-annotate.md` | uncommitted |
| 8      | Two module-scope fixtures added                                             | `tests/rel_frontend.rs` in `~/src/ergodis-private`        | `fb69af8` |

Each edited report carries a short "Audit corrections (2026-09-15)" section at its end pointing
here. The othello edits are left uncommitted for the coordinator.

### The two new fixtures, and one thing they cannot test

Both were added to the existing `admission_scopes_modules_binds_parameters_and_resolves_members`
unit test rather than to the parity corpus, to avoid racing the concurrent syntax-gaps work on that
corpus.

The first covers adopted rule 6: `module M / def a = 1 / end / module M / def b = 2 / end` admits
with `admission.modules == 2`, and `def c = M:b` on the same two modules fails with
`ErrorCode::UnknownMember` whose related site is byte 0, the first `module M` — so the second
module's members are demonstrably not reachable through the first, and the two headers are two
module symbols rather than one reopened module.

The second is arity-distinct: `def R(x, y) = 1 / module M[R] / def f = R(1) / end` admits with two
definitions, three binders and no base relation, because the binder scan runs before the symbol
probe and the module parameter wins inside the module's bodies; resolving to the top-level
definition instead would be an arity mismatch, and the companion source
`... / end / def g = R(1)` shows exactly that failure, `ArityMismatch` with found 1 and expected 2,
once the reference is outside the module. A third source pins that a body parameter may carry a
module parameter's spelling and that the module parameter is still bound in the module's other
bodies afterwards.

What no fixture can test, and this is worth recording rather than leaving as an apparent gap: the
direction of shadowing *between two binders* — a body's own parameter against a module parameter of
the same spelling — has no observable consequence in this stage. `admit::lookup` returns
`Resolved::Binder` on the first non-stale match and reads no other field of the binder, so both
candidates produce the same admission, the same summary and the same diagnostics. The direction is
fixed by code (`w.binders` is scanned from the end backwards) and is the direction the published Rel
semantics' `mu (+) nu` convention implies, but it is not falsifiable by a test at this stage. My own
defect 8 proposed an arity-distinguishing fixture for it; that proposal was wrong, and what was
built instead is the arity-distinguishing fixture for the case where it does discriminate, the
module parameter against a same-spelled top-level definition.

### Gates run after the fixture commit

```sh
cd ~/src/ergodis-private
nix develop ~/src/ergodis --command cargo test --release -p ergodis-private \
    --test rel_frontend --test rel_frontend_portability -j 4
nix develop ~/src/ergodis --command python3 analysis/rel-frontend/portability.py \
    --output <scratchpad>/portability-audit.json
```

28 passed and 1 passed, zero failed, with the new assertions live (the test binary's mtime is after
the source edit's, so the rebuild picked them up). The parity replay reports 193 cases, 369,710
canonical bytes and native/WASM exact equality, and its canonical SHA-256 is
**`c5d836251b8b24e2b58c513a89a7726acc8f922533e9df681fc24ec3ca9aafba` — unchanged**, with a
`record_summary` identical in every field to the committed receipt. The replay was written to the
audit scratchpad rather than over `analysis/rel-frontend/portability-v1.json`, because the only
difference between the fresh receipt and the committed one is the `source_sha256` entry for
`tests/rel_frontend.rs`, and the concurrent syntax-gaps work is adding a parity case that will force
a regeneration of that receipt anyway. **One follow-up for whoever lands that work: regenerate
`portability-v1.json` after both fixture edits are in, so its `tests/rel_frontend.rs` source hash
matches the committed file.** This is the same receipt-coverage weakness the module-scopes report
records as its ledger item 11.


