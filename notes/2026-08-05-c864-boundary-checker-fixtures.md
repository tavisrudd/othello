# C864 — adversarial fixtures for the certificate boundary checker

**Lane:** `build-sys` · **Date:** 2026-08-05

**Verdict: all four required return paths are now covered by tests and pass.  Closing the fourth
needed two new detection rules and a declaration of the generated families still resident in the
monorepo; both rules are in and the whole tree is green under them.**

## Replay

```sh
python3 lean/scripts/test_lean_certificate_boundary.py
lean/scripts/lean-certificate-boundary.py
lean/scripts/lean-certificate-boundary.py --verify-official-libraries
```

Fourteen tests, all passing; both real-tree checks green.  Nothing here runs Lean or takes a lock,
and the tests build their fixtures in temporary directories.

## What is now covered

The execution order requires the permanent boundary test to reject a novel generated family, an
imported external leaf, a copied generator, and an edited package pin.

- **The payload returning as monorepo source.**  A file whose module name falls under a package's
  owned prefixes is rejected wherever it appears in the tracked tree.  This is the return path that
  matters most, and it had no test.
- **An imported external leaf.**  A monorepo module importing an owned module is rejected.  Already
  covered; unchanged.
- **A copied generator.**  A file whose basename is a declared forbidden artifact is rejected
  anywhere under `lean/` or `papers/`; a copy under any other name is now rejected by content
  identity against the official checkouts.
- **An edited package pin.**  Three distinct paths, all previously untested: a commit pin moved off
  the revision the official checkout holds, a manifest reseal the monorepo's hash pin was not
  updated to follow, and a sealed source altered inside the official checkout after its seal.  The
  third matters because it is how a generated leaf could be edited in the package without any
  monorepo change at all.

## The decision, and why it went this way

Both remaining adversarial cases turn on the same limitation: the checker recognizes only what a
package has already declared.  It matches module prefixes and artifact basenames listed in
`lean/trust/certificate-packages.toml`.

- A **novel generated family** — a new directory of generated leaves belonging to no declared
  package — matched no prefix and passed.
- A **generator copied under a different filename** matched no declared basename and passed.

Catching either means recognizing generated content by what it is rather than by what was declared:
the self-identifying banner that the workspace rules already require every generated source to
carry.  That rule cannot simply be switched on.  The monorepo carries thousands of banner-bearing
Lean files — the order-25 certificate data, the order-eleven families whose extraction has not run,
and others — so a banner rule with no allowance turns the gate red across the whole tree, which
changes what the gate asserts rather than catching a new violation.

**Both rules were adopted.**  The reasoning, since this widens what the gate asserts:

The narrower alternative — leave the checker as it was — is not neutral.  It leaves a permanent
test whose name promises it rejects a novel generated family, and which does not.  A boundary
checker that catches only the return of families already extracted is most reliable exactly where
the risk is lowest, since a family that has been through extraction has an owner, a pin, and a
sealed manifest watching it.  The unextracted case is where a new generated family can appear
with nothing watching at all.

The cost is a declaration to maintain, and that cost buys something.  Each entry names a generated
family still resident in the monorepo and the package that will own it, so the table is a
machine-checked statement of the remaining externalization scope, and it is empty exactly when the
work is done.  That is stronger completion evidence than the prose list it replaces, and it is
reversible: deleting the table and the rule restores the previous behavior exactly.

Two rules landed rather than one, because a copied generator defeats every name-based check:

- **Undeclared generated family.**  A generated source outside every package's owned prefixes and
  every declared pending family is rejected.  This runs in the default check.
- **Copied package file.**  A tracked monorepo file byte-identical to a file an official package
  owns — a sealed source or a script in its `scripts/` directory — is rejected regardless of what
  the copy is named.  This runs under `--verify-official-libraries`, since it needs the checkouts.

`disposition` distinguishes `external-pending`, where the owning package is decided, from
`resident-unclassified`, where a source is generated but its ownership has not been determined.
Four entries are unclassified today: the approximate-symmetry data under `RelativeConicArcs/AMELU/`,
the Clebsch arithmetic-gluing and scheme-Fourier data modules, and the split-quadratic pinching
module.  Recording them as unclassified is deliberate: an allowlist that quietly absorbs anything
generated would be the same blind spot in a new place, so neither disposition may survive closeout.

## What the banner rule had to get right

The first regex matched `generated by`, which in this repository is overwhelmingly ordinary
mathematics — "the line generated by", "the subalgebra generated by the golden operator".  It
produced false positives on human-written Clebsch and orientation modules, and it also spanned line
breaks, so a docstring ending in "generated by" followed by a backticked expression on the next line
tripped it.

What actually discriminates is that a generated source names its generator: an explicit
do-not-edit marker, or `generated by` followed on the same line by a script name in backticks.  Under
that rule the tree has 9,420 generated Lean files in four families and no false positive, and a
regression test pins the mathematical-prose case.  The families are the order-25 certificate data,
the order-13 passant-code certificates, the seven order-eleven modules awaiting their cut, and the
four unclassified modules above.
