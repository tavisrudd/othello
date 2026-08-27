# C973 checkpoint — pointed GF(32) R11 Lucas closure

**Lane:** `reed-solomon` · **Date:** 2026-08-27 · **Status:** exact normalized
quotient and independent replay complete; manuscript frozen

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
largest search examines 12,866 marker/pencil candidates under the fixed
2,000,000 limit.  Since all supports are finite, they avoid the normalized
marked root.  Projective transport proves the result for every original
carrier/root pair.

For R12, contract a nonzero carrier syndrome at any marker with nonzero polar.
The polar lies in the R11 carrier.  Its pointed nonic avoids the retained
marker, so direct lifting gives a split squarefree decic in the R12 kernel.

## Structural-compression audit

The fixed-field certificate is a bridge, not the desired all-binary endpoint.
Two natural attempts to compress it were tested exactly:

1. Quotient the stored finite nonics by the affine stabilizer of infinity.
   The 1,129 witnesses still occupy 795 affine divisor types; the largest type
   occurs only 14 times.  Thus the search output is not a disguised small
   support atlas.
2. Restrict to supports consisting of an affine three-space coset plus one
   extra root, the nearest degree-nine extension of the C530/C620 additive
   family.  Its 4,960 distinct Hankel row pairs miss 503 marked syndrome
   orbits.  The analogous GF(16) family misses 168 of 317 orbits.

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

| artifact | bytes | SHA-256 |
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
| Does GF(32) contain a pointed obstruction? | no | all 1,129 marked orbits have finite nonics |
| Are lower-degree locators needed as at GF(16)? | no | degree nine succeeds on every orbit |
| Does the certificate also close R12? | yes for ordinary shallowness | one-marker lifting |
| Do the witnesses compress to a small affine divisor atlas? | no; 795 affine types occur | use equations, not stored support shapes |
| Does an affine three-space plus one root cover the carrier? | no; 503 GF(32) marked orbits remain | full final-pair trace incidence |
| Can the same in-memory quotient be used at GF(64)? | not responsibly; its carrier has about 17 million points | derive a streaming or invariant Borel quotient, or sharpen the genus-one proof |
| What remains outside characteristic two? | the GF(27) seven-dimensional carrier | a distinct module/arithmetic reduction |

Vibe: another exact field disappears with cleaner arithmetic than GF(16);
the remaining binary case now deserves a structural GF(64) argument rather
than a memory-heavy copy of this quotient.
