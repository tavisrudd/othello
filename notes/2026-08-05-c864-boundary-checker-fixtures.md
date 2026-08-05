# C864 — adversarial fixtures for the certificate boundary checker

**Lane:** `build-sys` · **Date:** 2026-08-05

**Verdict: three of the four required return paths are now covered by tests and pass.  The fourth,
a novel generated family, cannot be covered without adding a detection rule the checker does not
have, and that rule changes what the boundary gate means.  It is a decision, not a test.**

## Replay

```sh
python3 lean/scripts/test_lean_certificate_boundary.py
```

Ten tests, all passing.  The suite runs no Lean, takes no lock, and builds its fixtures in
temporary directories.

## What is now covered

The execution order requires the permanent boundary test to reject a novel generated family, an
imported external leaf, a copied generator, and an edited package pin.

- **The payload returning as monorepo source.**  A file whose module name falls under a package's
  owned prefixes is rejected wherever it appears in the tracked tree.  This is the return path that
  matters most, and it had no test.
- **An imported external leaf.**  A monorepo module importing an owned module is rejected.  Already
  covered; unchanged.
- **A copied generator.**  A file whose basename is a declared forbidden artifact is rejected
  anywhere under `lean/` or `papers/`.  Already covered; see the limitation below.
- **An edited package pin.**  Three distinct paths, all previously untested: a commit pin moved off
  the revision the official checkout holds, a manifest reseal the monorepo's hash pin was not
  updated to follow, and a sealed source altered inside the official checkout after its seal.  The
  third matters because it is how a generated leaf could be edited in the package without any
  monorepo change at all.

## The undetectable case, and why it is a decision

Both remaining adversarial cases turn on the same limitation: the checker recognizes only what a
package has already declared.  It matches module prefixes and artifact basenames listed in
`lean/trust/certificate-packages.toml`.

- A **novel generated family** — a new directory of generated leaves belonging to no declared
  package — matches no prefix and passes.
- A **generator copied under a different filename** matches no declared basename and passes.

Catching either requires recognizing generated content by what it is rather than by what was
declared: the self-identifying banner that the workspace rules already require every generated
source to carry.  That rule is straightforward to write and would close both cases at once.

It cannot simply be switched on.  The monorepo currently carries 9,332 Lean files bearing a
generated banner — the order-25 residual class link data, the order-eleven families whose extraction
has not run, and others.  A banner rule with no allowance turns the boundary gate red across the
whole tree immediately, which is a change to what the gate asserts rather than a new violation
being caught.

The shape that works is a declared pending-family allowlist: each entry names a generated family
still resident in the monorepo and the package that will own it.  A banner-bearing family outside
both the owned prefixes and that allowlist is then rejected as novel, which is exactly the required
fixture, while today's tree stays green.  The allowlist shrinks as each extraction lands and is
empty at closeout, so it doubles as the completion evidence for the externalization itself.

This changes the boundary gate's meaning and adds a declaration file, so it is surfaced for a
decision rather than taken.  Until it is decided, the two cases stay uncovered and the checker's
guarantee is the narrower one: it rejects the return of a family that has already been extracted,
not the arrival of one that never was.
