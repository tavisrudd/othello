# C864 — non-Lean certificate payload and build-artifact sweep

**Lane:** `build-sys` · **Date:** 2026-08-05

**Verdict: the monorepo's certificate generators were invisible to every boundary rule, because
they live under `notes/` and the checker scans `lean` and `papers` only.  All nineteen order-25
generator, replay-program, and replay-data files are now declared and machine-checked.  The
extractions also left build residue nothing deletes on its own: 114 order-eleven point-orbit
modules in the monorepo and three order-16 modules in finitegeom, whose removal needs a build window.
No mirror or backup checkout carries non-Lean payload.**

## Replay

```sh
lean/scripts/lean-certificate-boundary.py
lean/scripts/lean-certificate-boundary.py --verify-official-libraries
python3 -m unittest test_lean_certificate_boundary test_lean_certificate_portfolio_audit  # in lean/scripts
lean/scripts/lean-certificate-portfolio-audit.py --payload --build-artifacts . \
  ~/src/lean/finitegeom ~/src/lean/finitegeom-q16-certificates \
  ~/src/lean/finitegeom-clebsch-q11-certificates ~/src/lean/finitegeom-golden-quantum-statistics \
  ~/src/lean/finitegeom-projective-cap-q11-certificates \
  ~/src/lean/finitegeom-projective-cap-q13-certificates ~/src/lean/finitegeom-q25-certificates \
  ~/src/math-papers/clebsch-rigidity ~/src/math-papers/arcs-complete-outside-conic \
  ~/src/math-papers/clebsch-passages ~/src/math-papers/q13-passant-code \
  ~/src/math-papers/golden-quantum-statistics ~/src/math-papers/mds-css-transversal-groups \
  ~/src/othello-n18 ~/src/othello-n18-certify
```

Everything here reads file contents and file sizes.  No Lean, no Lake, no lock, no writes outside
the monorepo's own tracked sources.  The sweep ran while the Paper I remediation held the shared
tree, and touched nothing that lane owns.

## What finds non-Lean payload

A generated Lean leaf announces itself in its own banner.  Its generator does not: it is a Python
or C++ program that carries no banner, sits in a directory the family does not, and is caught by
the existing rules only once an adopted package lists its basename or holds a byte-identical copy.
Neither applies while the family is still resident — which is exactly when the generator most needs
declaring, because the ownership boundary moves the generator with the family it writes.

The banner names it, so the banner is what the new rule reads.  For every generated Lean source
under `lean` and `papers`, `undeclared_generator_references` in `lean-certificate-boundary.py`
resolves the generator the banner names — repository-relative, Lean-root-relative, or a bare
basename meaning "beside the family" — and requires the resolved file to fall under a declared
pending or resident family.  An unresolvable reference is not a violation: a generated source may
name a program that was never kept.  Output is one line per generator rather than per leaf, since a
single order-25 generator writes 2,716 of them.

The same reading, without the pass/fail, is now `--payload` on
`lean-certificate-portfolio-audit.py`, and the build-residue rule below is `--build-artifacts`.
Both are covered by the new `test_lean_certificate_portfolio_audit.py`; the boundary rule adds three
fixtures — generator outside the scan roots rejected, declared generator accepted, absent generator
ignored — to the existing suite, which is green at seventeen tests.

## Finding: the order-25 generators were undeclared, and are now declared

Eleven generators are named by the monorepo's generated sources.  Ten are the order-25 family's,
under `notes/`; the eleventh writes a resident table in finitegeom.  Counted by leaves they write:

| generator | generated sources |
|---|---|
| `notes/2026-07-15-c151-residual-transport-generator.py`    | 2,716 |
| `notes/2026-07-17-c151-residual-conclusion-generator.py`   | 1,375 |
| `notes/2026-07-18-c151-exhaustion-conclusion-generator.py` | 1,375 |
| `notes/2026-07-16-c151-residual-class-link-generator.py`   | 1,340 |
| `notes/2026-07-15-c151-residual-cover-generator.py`        | 1,316 |
| `notes/2026-07-18-c151-exhaustion-dispatch-generator.py`   |   304 |
| `notes/2026-07-15-c151-shared-line-composition.py`         |   239 |
| `notes/2026-07-18-c151-strict-class-bound-generator.py`    |   239 |
| `notes/2026-07-15-c151-line-mask-generator.py`             |   100 |
| `notes/2026-07-15-c151-exactness-generator.py`             |     5 |
| `lean/verification/clebsch_arithmetic_gluing/generate.py`  |     1 |

The order-25 entry in `lean/trust/certificate-packages.toml` declared its Lean prefix only, so the
programs that write those 9,009 modules — plus the two C++ replay programs, the replay checker, and
the checker's data — were declared nowhere.  A second `pending_family` entry now lists all nineteen
files explicitly, owned by `finitegeom-q25-certificates`.  The dated `notes/*-c151-*.md` reports are
research records and stay; only executable payload and its data are listed.  The consequence is the
same one the order-16 cut accepted: when order-25 is externalized those nineteen files leave the
monorepo, and the reports that cite them point at the package instead.

The eleventh generator writes `ClebschArithmeticGluingData`, one of the two frozen tables the
monorepo keeps permanently.  Its `resident_family` entry now covers `lean/verification/` for both
tables, on the reasoning that a frozen human-scale table is only reviewable beside the program that
wrote it.

The order-13 passant-code certificates needed no change: their generators sit inside
`papers/q13-passant-code/lean-certificates/`, already declared whole.

## Finding: the extractions left build residue that nothing removes

Deleting a family's sources does not delete what building them left behind, and no source-level rule
sees it.  Measured as disk blocks:

| root | stale modules | files | on disk | what it is |
|---|---|---|---|---|
| monorepo `lean/`     | 114 | 912 | 51.5 MB | order-eleven point-orbit family, extracted by C864 |
| monorepo `lean/`     |  11 |  88 | 11.1 MB | `PaperIOrientation*`, renamed by the Paper I remediation |
| finitegeom repo    |   3 |  24 |  1.6 MB | order-16 certificate modules, extracted by C864 |
| finitegeom repo    |  11 |  88 | 11.1 MB | the same rename, not yet re-exported |
| `finitegeom-clebsch-q11-certificates` | 1 | 8 | 0.4 MB | `Q11DyeAxioms`, built here, sourced from finitegeom |

The order-16 monorepo residue is gone, as the card records; the point-orbit cut left its own and it
was never swept.  Nothing was deleted here.  Unlinking build outputs under a tree another lane is
actively building is exactly the interference the lane rules forbid, so removal belongs in the same
window as the finitegeom re-export — at which point the orientation-rename residue in both trees resolves
too, and it is the Paper I lane's to account for either way.

The order-16 package and both projective-cap candidates carry no residue at all.

## Finding: the order-25 replay data has no committed copy anywhere

The order-25 replay checker reads a 1.7 MB residual-cover table.  The monorepo does not track it:
the checker's own replay line points at `/home/tavis/.cache/c151-residual-cover.csv`, an untracked
cache file.  The candidate package holds a byte-identical copy at `artifacts/residual-cover.csv` —
in a repository with zero commits, so that copy is uncommitted working-tree state as well.  Every
byte of this input therefore exists only outside version control, in two places that a cache prune
or a mistaken clean would take.  The one tracked artifact of the pair,
`notes/2026-07-18-c151-minimum-mask-spectrum.json`, differs from the candidate's copy in exactly one
line, the recorded source path — the same package-local repath the declared banner normalization
performs.

The candidate having no commits is the larger fact behind this one: all 9,531 transformed sources,
seventeen scripts, and two artifacts are untracked or merely staged.  The order-25 externalization
already plans to re-extract rather than adopt those bytes, so the loss would be recoverable, but the
csv would not be, because no generator run reproduces it without the search it came from.

## Finding: the payload sets do not agree in either direction

The monorepo carries nineteen order-25 payload files, the candidate seals nineteen support files,
and they are not the same nineteen.  The monorepo has `notes/2026-07-15-c151-residual-quotient.cpp`,
a replay program the candidate lacks entirely; the candidate has the residual-cover table the
monorepo does not track.  Sixteen Python programs and one C++ program appear in both, all
seventeen differing — banner and generator-path repaths, Lean identifier renames from the `c151`
prefix to `q25Certificate`, and in the replay checker a rewrite that omits generator-hash banner
lines from its comparison and tolerates modules outside the imported closure.  That rewrite is
declared in the candidate's `PROVENANCE.md`; the identifier renames in the generators are not, and
the declared `q25-banner-normalization-v1` transformation covers sealed Lean sources rather than the
programs.  Re-extraction is the moment to fix both directions: derive the package's scripts from the
monorepo originals under a named transformation, and carry the missing replay program across.

## Finding: three candidate packages still depend on a finitegeom revision carrying order-16 payload

Every package resolves finitegeom into `.lake/packages/finitegeom`, at whatever revision its lock
names, and those checkouts are part of the sweep's scope.  finitegeom at `a7665be`, which the order-16
package pins, and finitegeom's own `HEAD` at `ac7e4ee` both carry only `Q16Classification.lean`.  The
two projective-cap candidates and the order-25 candidate resolve `9711f4a`, and the order-eleven
package resolves `85dfde9`; all four of those checkouts still carry `Q16CertificateLevels`,
`Q16Reduction`, and `Q16StepKernel` alongside it.

This is not a shadow to delete.  A dependency checkout is a reproducible materialization of a
published revision, and the ownership boundary explicitly does not reach into Git history.  What it
means is that until the pins move, three candidates would build against a base that still contains
extracted order-16 sources — so the finitegeom re-export window should refresh those locks, not only the
adopted packages' pins, and the order-eleven package's lock is one more thing that window has to
carry.

## Finding: packages seal non-Lean payload three different ways

The order-16 package records `generator` and `verification_artifacts`; the order-eleven package
records `generator` alone; the order-25 candidate records nineteen `support_files` with sizes and
hashes.  No schema requires any of them, and no check compares a package's generator against the
monorepo program it came from — `lean-package-source-audit.py` iterates sealed Lean sources.  Two
adopted packages therefore seal their Lean payload exactly and their non-Lean payload by convention.
Settling the field is cheap and belongs with the reverse-direction audit already queued.

## Clean roots

The six paper mirrors, both backup working trees, and the golden quantum statistics library carry no
generated Lean source, no generator reference, and no build residue.  The mirrors were the place the
order-16 cleanup had to chase shadows; none came back, and the non-Lean sweep finds nothing the Lean
sweep missed.  Two files match a naive name search and are unrelated scholarly data: a
`first_wall_q169.json` in the Clebsch factorization evidence and a Lucas-carrier evidence file naming
the field of order sixteen.

## Record correction

The card describes the Al-Seraji--Al-Ogali consistency check as anchored to the "package-owned"
`RelativeConicArcs.Q16Classification.rejection_profile`.  That module is base-owned: the order-16
package lists it under `external_imports` in its manifest and holds no copy, and the monorepo and
base carry byte-identical sources.  The separation argument is unaffected — the theorem sits outside
the certificate payload either way — but the attribution is wrong wherever it is repeated.

## What this leaves for the window

Delete the 114-module point-orbit residue in the monorepo and the three-module order-16 residue in
finitegeom, in the same window as the finitegeom re-export; account for the orientation-rename residue with
the re-export that causes it; and refresh the four dependency locks that still resolve a base
revision carrying extracted order-16 sources.  Everything else here is either landed or belongs to the order-25
extraction, which now has a declared, machine-checked payload list to extract against.
