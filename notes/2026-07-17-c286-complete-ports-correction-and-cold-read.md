# C286 complete-ports correction and cold-read pass

**Lane:** `complete-ports`

**Status:** COMPLETE — the C285 correction list was applied to the private six-part manuscript,
three context-light paragraph-by-paragraph cold reads were logged and reconciled, the same readers
verified the resolutions, and the 11-page PDF rebuilt without warnings. C220 remains omitted and
undecided. No public export, repository initialization, Lean edit, license decision, remote change,
or push occurred.

## Result

The six-part theorem spine survives. The correction pass closed every source/claim blocker in
C285 and one additional substantive defect found independently on the cold read:

1. coefficient fibers now contain ordinary target-normalized recovery vectors rather than
   projective classes;
2. the vacuous dual-distance sentence and mismatched proof were removed from the basic-invariants
   proposition;
3. the exact transfer theorem now assumes at least two outer blocks and takes the minimum of the
   nonzero functional-tuple cost and the exact all-zero branch
   `z_x(I)=mu_x(0)+d(I^perp)`;
4. the abstract uses the correct side of the pointed-obstruction inequality;
5. the simultaneous random primal/dual GV argument and both primal and dual AG distance bounds are
   visible in the source;
6. the harmonic transfer paragraph distinguishes the automatic inner-dual bound from the still
   required outer gate;
7. the q-ary EXIT area normalization, reliability attribution, pointed-Tutte source equation, and
   all-field Poisson overlap counts are explicit;
8. the closure operator no longer collides with the locality deficit `L_4`;
9. the verification section distinguishes a Lean axiom from other manuscript-level classical
   inputs and uses valid TeX module notation; and
10. the conclusion now states the bounded/full-radius relation in the correct direction and no
    longer exposes an internal C220 editorial decision.

The bibliography adds Colbourn for reliability, Stichtenoth's coding-theory book for the generic
AG route, and Tricot for the standard `PGL(2,q)` design-orbit context. Chen--Ling--Xing is pinned to
Theorems 2.3/2.1 and Las Vergnas to equation (3.1). The proof ledger, novelty review, and README are
synchronized with the corrected source.

## Independent cold reads

Three subagents received disjoint source ranges and only the C188 cold-read format example. They
were instructed not to read C285, the proof/novelty ledgers, handoffs, or other reviews, and not to
edit the manuscript. Each log covers the assigned range sequentially by paragraph or numbered
environment and classifies concrete corrections:

- [`2026-07-17-c286-cold-read-front-half.md`](2026-07-17-c286-cold-read-front-half.md) — front
  matter through prescribed realization;
- [`2026-07-17-c286-cold-read-reliability-tutte.md`](2026-07-17-c286-cold-read-reliability-tutte.md)
  — reliability, bounded EXIT, and pointed Tutte; and
- [`2026-07-17-c286-cold-read-flagships-back.md`](2026-07-17-c286-cold-read-flagships-back.md) —
  geometric flagships through conclusion.

The front reader independently found the coefficient-fiber and obstruction-direction defects and
also caught the omitted zero-functional branch in the theorem labeled exact. The middle reader
found no formula error but exposed the contraction/code notation collision, the implicit `Z^0`
specialization, and the missing removal of the target from cocircuit blockers. The back reader
found no mathematical blocker and requested focused proof, quantifier, conclusion, and
publication-register cleanup.

After correction, the same three readers re-read their ranges and appended resolution sections.
All mathematical, expository, citation, and source-notation findings passed. The front reader's one
residual noun change (“representative” to “vector”) was then applied. No reader requested a
structural rewrite.

## Build and inspection

From `papers/complete-repair-ports/`:

```text
nix shell nixpkgs#tectonic -c tectonic complete_repair_ports.tex
```

Tectonic exited zero with no warning, undefined-reference, undefined-citation, or error line. The
PDF remains 11 US-letter pages. The first page, the exact-transfer theorem page, and the final
bibliography page were rendered at 120 dpi and visually inspected; the new two-branch minimum fits
cleanly and no clipping or malformed citation was found.

Key final artifacts are:

| Artifact | Bytes | SHA-256 |
|---|---:|---|
| `complete_repair_ports.tex` | 29228 | `1a49d85dfeb4291513f3ce435f17cd9294dff90e439b0250ad8b6feec7f5a4ad` |
| `complete_repair_ports.pdf` | 127957 | `d16c6fcbc67ee1e1c71e63cf11ec5d29260c6cf2c14a61492a247e2c51ffdb59` |
| `refs.bib` | 9710 | `ee1aee8a27a6f11f1f26d0ec6fa194eee910a63fc0d3f0cc26d13fad454695bd` |
| front-half cold-read log | 12513 | `ab382758bf551e0ed00285360be3ace29bdb6faf344fa3b32e4ae363f5de6e7b` |
| reliability/Tutte cold-read log | 7936 | `165dcb55b2ade986e4854e66d874ab561a56a0dc5c03ef600309d1730820aeda` |
| flagships/back cold-read log | 10635 | `08b4272e0cb15f1e3e60a2cc1c61f09a5a5a4e767da64b3c0bdd1ee65d49c320` |

This is an editorial/citation review, not a new computational certificate. The existing C218,
C219, C226, C227, C243, and C244 evidence bundles were not regenerated or changed.

## Remaining gates

The private mathematical draft is ready for the user's C220 decision. The bounded recommendation
remains to omit C220; this task did not decide it.

Public circulation still requires replacing private C-task provenance with a versioned public
checker/archive identity, exact public Lean roots and closure manifest, repository
destination/remote, license, and the separately owned shared-Lean export. Those are release gates,
not defects silently papered over by this private correction pass.
