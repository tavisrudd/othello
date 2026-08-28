# C973 checkpoint — pointed GF(32) R11 Lucas closure

**Lane:** `reed-solomon` · **Date:** 2026-08-27 · **Status:** exact normalized
quotient and independent replay complete; **quotient rebuilt 2026-08-28 after
external review found the wrong group action — see "Review repair" below**;
manuscript frozen

> **Reading order.**  Every count below the Result is the superseded
> 2026-08-27 version.  Superseded figures are tagged `[corrected 2026-08-28]`
> inline and the corrected quotient, tables, and hashes are in the closing
> **Review repair (2026-08-28)** section.  The Result itself is unchanged and
> is now supported by verified witnesses on all 1,129 true orbits.

## Result

Every syndrome in the maximal R11 binary Lucas carrier over
`GF(32)=GF(2)[x]/(x^5+x^2+1)` has, for every prescribed projective root, a
split squarefree degree-nine Hankel-kernel member avoiding that root.
Therefore the carrier is pointedly shallow, `GF(32)` leaves the possible R11
modular-exception set, and one-marker lifting makes the binary R12 carrier
shallow over `GF(32)`.

Together with the GF(16) checkpoint and the uniform `q>=128` theorem, the
only unresolved binary R11 field is now `GF(64)`.  Across all
characteristics, the exact unresolved set is

```text
GF(27), GF(64).
```

No manuscript, supplement, software, mirror, or release path is changed.

## Exact quotient proof

Normalize the prescribed root to infinity under `PGL2(GF(32))`.  The marked
problem is then the action of the upper Borel stabilizer on

\[
             \mathbf P\langle e_3,e_4,e_5,e_6,e_7\rangle.
\]

Translation and primitive diagonal scaling generate that stabilizer.  Closing
the `1,082,401` points of this projective carrier under those two exact
degree-nine divided-power action matrices gives `1,129` orbits.  This is the
complete theorem-derived marked quotient, not an ambient syndrome census.

Every orbit representative has a verified finite degree-nine locator.  The
largest search examines 12,866 `[corrected 2026-08-28: 139]` marker/pencil
candidates under the fixed 2,000,000 limit.  Since all supports are finite,
they avoid the normalized marked root.  Projective transport proves the result
for every original carrier/root pair.  `[corrected 2026-08-28: the orbit count
1,129 is right, but the 2026-08-27 partition was computed with the wrong
action, so this transport step did not hold; see the Review repair section.]`

For R12, contract a nonzero carrier syndrome at any marker with nonzero polar.
The polar lies in the R11 carrier.  Its pointed nonic avoids the retained
marker, so direct lifting gives a split squarefree decic in the R12 kernel.

## Structural-compression audit

The fixed-field certificate is a bridge, not the desired all-binary endpoint.
Two natural attempts to compress it were tested exactly:

1. Quotient the stored finite nonics by the affine stabilizer of infinity.
   The 1,129 witnesses still occupy 795 `[corrected 2026-08-28: 882]` affine
   divisor types; the largest type occurs only 14 `[corrected 2026-08-28: 11]`
   times.  Thus the search output is not a disguised small support atlas.
2. Restrict to supports consisting of an affine three-space coset plus one
   extra root, the nearest degree-nine extension of the C530/C620 additive
   family.  Its 4,960 distinct Hankel row pairs miss 503 marked syndrome
   orbits.  The analogous GF(16) family misses 168 of 317 orbits.
   `[corrected 2026-08-28: both counts were indexed by the superseded
   quotient.  The family is stable under the affine group, so the covered set
   of syndromes is genuinely orbit-defined; on the corrected quotient it misses
   62 of the 1,129 GF(32) orbits and 139 of the 317 GF(16) orbits.  As
   group-independent point counts, which is how these negatives should be
   stated, it covers 1,052,513 of 1,082,401 GF(32) carrier points and 42,481 of
   69,905 GF(16) carrier points.]`

Both restatements leave the conclusion intact: the additive
three-space-plus-one family does not cover the carrier, so it is not a hidden
small support atlas.

These negatives rule out two certificate-compression shortcuts.  They do not
obstruct a structural theorem: every split nonic still has the exact
seven-roots-plus-final-pair trace description.  The high-EV GF(64) route is to
make prescribed-root avoidance intrinsic in that trace cover, rather than
paying six additional deletion points after the C620 genus-one estimate.  A
successful argument would also retroactively demote the GF(16)/GF(32)
certificates to calibration evidence.

The bounded structural audit replays by

```text
nix shell nixpkgs#python3 -c python3 \
  notes/reed-solomon-tasks/c973-binary-pointed-support-structure.py
```

## Evidence and replay

Deterministic regeneration through the public locator and verifier is:

```text
nix shell nixpkgs#python3 -c python3 \
  notes/reed-solomon-tasks/c973-r11-gf32-pointed-quotient.py --check
```

The independent replay does not call the toolkit.  It reconstructs the full
million-point carrier quotient and verifies every support polynomial against
the two Hankel equations:

```text
nix shell nixpkgs#python3 -c python3 \
  notes/reed-solomon-tasks/c973-r11-gf32-pointed-quotient-replay.py
```

The checksum gate is:

```text
(cd notes/reed-solomon-tasks && \
 sha256sum -c c973-r11-gf32-pointed-quotient.sha256)
```

`[corrected 2026-08-28: the generator, replay, and certificate were replaced;
the current hashes are in the Review repair section.  The
structural-compression audit script is unchanged — it reads the certificate,
so rerunning it now emits the corrected numbers above.]`

| artifact | bytes | SHA-256 (superseded) |
|---|---:|---|
| generator | 6,544 | `6c74ffcf8ed0a4dc3540598d5eb15ccf5195132fc06268094c53d7433a86f667` |
| independent replay | 1,600 | `ef90999cd508d932b3fdcbdb3bd31d4a0f37db47d281c41089289c202a2adffe` |
| canonical certificate | 123,045 | `88cfa57ea71964c5723c42493f36d6c60072ecab423caf4664245cf0ab360a1c` |
| structural-compression audit | 4,707 | `bd2503d9f22026c103d2f2aa59c692de9b5fd561c8a846acd903d5bb6001da2d` |

The fixed-field existence result is computational after the structural orbit
reduction.  It proves nothing for GF(64) or characteristic three by
interpolation.  The independent layer shares the previously checked
polynomial-basis arithmetic helper but shares neither locator search nor
toolkit verification.

## `ej` + `tt` closeout

The `ej` pass propagates the one-pointed R11 theorem through binary R12 at no
additional computational cost.  It also records the sharp contrast with
GF(16): every GF(32) orbit already has a degree-nine locator, so there is no
lower-degree exceptional stratum to explain.

The `tt` pass asks whether the small candidate counts can replace the exact
quotient.  They cannot: early success is only an algorithmic feature.  The
mathematical quantifier comes from the complete 1,129-orbit Borel reduction
and projective transport.  It then asks whether a small affine support atlas
explains that quotient.  The exact compression audit rejects both the observed
support-orbit atlas and the additive-three-space-plus-one family.

## Mystery ledger

| mystery | status | exact next gate |
|---|---|---|
| Does GF(32) contain a pointed obstruction? | no | all 1,129 marked orbits have finite nonics `[corrected 2026-08-28: now the true Borel orbits]` |
| Are lower-degree locators needed as at GF(16)? | no | degree nine succeeds on every orbit (still true on the corrected quotient) |
| Does the certificate also close R12? | yes for ordinary shallowness | one-marker lifting |
| Do the witnesses compress to a small affine divisor atlas? | no; 795 `[corrected 2026-08-28: 882]` affine types occur | use equations, not stored support shapes |
| Does an affine three-space plus one root cover the carrier? | no; 503 `[corrected 2026-08-28: 62 orbits, 29,888 of 1,082,401 points]` GF(32) marked orbits remain | full final-pair trace incidence |
| Can the same in-memory quotient be used at GF(64)? | not responsibly; its carrier has about 17 million points | derive a streaming or invariant Borel quotient, or sharpen the genus-one proof |
| What remains outside characteristic two? | the GF(27) seven-dimensional carrier | a distinct module/arithmetic reduction |

Vibe: another exact field disappears with cleaner arithmetic than GF(16);
the remaining binary case now deserves a structural GF(64) argument rather
than a memory-heavy copy of this quotient.

## Review repair (2026-08-28)

An independent cold read (`c973-2026-08-28-review-coding.md`) found that the
2026-08-27 quotient was taken by the wrong group.  The certificate has been
rebuilt; the Result is unchanged.

### What was wrong

This generator and replay delegate to their GF(16) siblings, so they inherited
the same defect.  Both built their "upper Borel" matrices from C531's
`action_entry` — the PGL_2 action on **degree-nine** binary forms, i.e. the R10
syndrome space — restricted to `e_3..e_7`, a slice that is not invariant under
that action (`e_3 -> e_2 + e_3`).  The truncated matrices are not symmetries of
the R11 Hankel system the same scripts verify against.  The R11 syndrome has
divided-power degree `n = r - 1 = 10`, so the correct translation action is
`e_j -> sum_{i>=j} binom(i,j) a^(i-j) e_i`, under which `<e_3,...,e_7>` is
invariant because `binom(i,j) = 0 mod 2` for `i in {8,9,10}`, `j in {3,...,7}`.
Measured on 1,200 independently generated `(syndrome, support)` pairs, the
correct matrix is equivariant with `t -> t+1` 1,200 times and the truncated one
9 times.

Consequently the 1,129 stored representatives met only **135 of the 1,129**
true Borel orbits, and valid projective transport from them reached **97,345 of
the 1,082,401** carrier points, i.e. 9.0 %.

As at GF(16), the wrong group has **exactly the same orbit count**, 1,129, so
that number is not a valid check on the action.  **Validate against
equivariance, not against 1,129.**

### Why the conclusion survives

Every one of the 1,129 true Borel-orbit representatives has an explicit
verified finite degree-nine witness — first established during the review by an
independent two-point-switch search, and now reproduced by the rebuilt
certificate, in which all 1,129 come from the public
`simultaneous-locator --forbid-infinity` command.  Since all supports are
finite, this is the pointed-at-infinity statement; `<e_3,...,e_7>` is
`PGL_2`-stable (`j -> 10-j` maps `{3,...,7}` to itself), so projective
transport gives the full pointed result and the R12 lift is unaffected.  The
1,129 supports stored on 2026-08-27 also satisfy the complete apolarity system:
only the quotient and the transport step were wrong.

### The corrected quotient

The generator and the replay each now run a fail-closed, seeded 1,000-pair
equivariance gate (`splitmix64`, seed `0xC973_2026_0828`) asserting
`is_locator(z, S) == is_locator(z.M, phi(S))` for both generators, on a
syndrome drawn from the kernel of `S` and on an independent uniform syndrome.
The gate rejects the 2026-08-27 action.

| quantity | 2026-08-27 (superseded) | 2026-08-28 (current) |
|---|---:|---:|
| projective carrier points | 1,082,401 | 1,082,401 |
| marked orbits | 1,129 (wrong group) | 1,129 (true Borel) |
| orbits with a verified finite witness | 1,129 | 1,129 |
| degree-nine witnesses | 1,129 | 1,129 |
| orbits with no pointed locator | 0 | 0 |
| largest stored search count | 12,866 | 139 |
| equivariance pairs asserted | 0 | 1,000 |
| affine divisor types among the witnesses | 795 | 882 |
| orbits missed by three-space-plus-one | 503 | 62 |

True Borel orbit sizes at GF(32): `{1:1, 32:4, 248:20, 496:36, 992:1068}`.

### Replay

```text
nix shell nixpkgs#python3 -c python3 \
  notes/reed-solomon-tasks/c973-r11-gf32-pointed-quotient.py --check
nix shell nixpkgs#python3 -c python3 \
  notes/reed-solomon-tasks/c973-r11-gf32-pointed-quotient-replay.py
nix shell nixpkgs#python3 -c python3 \
  notes/reed-solomon-tasks/c973-binary-pointed-support-structure.py
(cd notes/reed-solomon-tasks && \
 sha256sum -c c973-r11-gf32-pointed-quotient.sha256)
```

Deterministic regeneration takes 95 s; the replay takes 20 s at a resident set
of 112 MB.  The replay shares no code with either generator, never calls the
toolkit, recomputes the full million-point orbit partition on packed integers,
requires the stored representatives to be exactly the orbit minima, and
re-verifies every support against the complete apolarity system.

| artifact | bytes | SHA-256 |
|---|---:|---|
| generator | 3,496 | `5c89bd64f9d80f52d1d2d419f373a5bcc00e8a8966f477c3ab4b420170bf208e` |
| independent replay | 1,351 | `87f37d494f97dbd837ff5c843ed54579d9ec7c5617add6b39b4cc52b5bac2a30` |
| canonical certificate | 159,731 | `4b7ff0d8eddcd71819657b7cd3cd724ecd6ceedd83c6a36acb67601633c7979f` |
| structural-compression audit | 4,707 | `bd2503d9f22026c103d2f2aa59c692de9b5fd561c8a846acd903d5bb6001da2d` |
