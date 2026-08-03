# C660 — independent R7 finite completeness

**Lane:** `reed-solomon`

**Status:** complete; independent coding/computational review ACCEPT

## Result

The complete redundancy-seven split-free classification has been reproduced
for

\[
q\in\{7,8,9,11,13,16,17,19,23,25,27,29,31,32\}
\]

without reading or invoking C509's quotient enumerator, quotient
representatives, stored orbit partition, or aggregate absence claims.  The
independent records were frozen before Certificate R7 was opened for
comparison.  The later comparison agrees exactly in every field on the
candidate count, split-free count, canonical orbit representatives, orbit
sizes, stabilizers, persistent/central flags, and Frobenius fusion.

This is a post-Version-1 reproducibility upgrade.  It changes no published
theorem.  In particular, the rows at \(q=7,8,9\) remain classifications of
split-free syndrome directions only; their covering-radius fields remain
null, and they are not promoted to code deep holes.

## Independent domain and completeness identity

Write \(B_\infty\subset\operatorname{PG}(5,q)\) for the pointed R6 bad locus
with the prospective sextic root fixed at infinity.  Every normalized point
with nonzero infinity contraction in \(B_\infty\) is uniquely of the form

\[
(b_0,\ldots,b_5,c),\qquad [b_0:\cdots:b_5]\in B_\infty, c\in\mathbf F_q,
\]

The zero infinity contraction is not a projective point of \(B_\infty\); its
unique projective preimage is the endpoint \([0:\cdots:0:1]\), which is
admitted separately.  Thus the exact candidate domain has

\[
q|B_\infty|+1
\]

points, with no projective duplicates.  Points whose infinity contraction is
outside \(B_\infty\) are rejected immediately.  Each candidate is then
contracted at every one of the \(q+1\) prospective roots and retained exactly
when every transported contraction lies in the corresponding pointed bad
locus.  Field by field, the certificate checks both identities

\[
|\operatorname{PG}(6,q)|=N_{\infty\text{-rejected}}+(q|B_\infty|+1),
\]

\[
q|B_\infty|+1=N_{\text{other-marker rejected}}+N_{\text{split-free}}.
\]

For \(q<16\), \(B_\infty\) is constructed literally as the complement in
\(\operatorname{PG}(5,q)\) of all spans of four distinct finite normal-rational-
curve points.  For \(q\geq16\), it is constructed from the proved R6 pointed
classification: persistent quadratic recurrences, the marked secant star,
the odd-binary nucleus line, and at \(q=19\) the independently generated
19-point transient marked orbit.  This is the one theorem-level shared input;
the R7 lifting and exhaustion are independently recomputed.

The PGL2 partition is rebuilt by breadth-first orbit traversal under inversion,
unit translation, and primitive scaling.  Orbit--stabilizer is checked against
\(|\operatorname{PGL}_2(q)|=q^3-q\).  Coefficient Frobenius is applied to each
canonical representative, and the resulting permutation gives the
semilinear fusion count.  Catalecticant rank at most two and membership in the
central binary orbit supply independently computed persistent and central
flags.

## Field ledger

The columns are \(q\), \(|\operatorname{PG}(6,q)|\), \(|B_\infty|\), candidate
count, split-free count, PGL2 orbit count, and the
persistent/central/bounded-exceptional masses.

| q | PG(6,q) | pointed | candidates | split-free | PGL2 | persistent | central | exceptional |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 7 | 137257 | 11040 | 77281 | 55860 | 197 | 224 | 0 | 55636 |
| 8 | 299593 | 14166 | 113329 | 50776 | 124 | 324 | 1 | 50451 |
| 9 | 597871 | 14479 | 130312 | 28350 | 58 | 450 | 0 | 27900 |
| 11 | 1948717 | 8130 | 89431 | 3080 | 10 | 792 | 0 | 2288 |
| 13 | 5229043 | 3147 | 40912 | 1274 | 3 | 1274 | 0 | 0 |
| 16 | 17895697 | 2553 | 40849 | 2312 | 3 | 2312 | 0 | 0 |
| 17 | 25646167 | 3027 | 51460 | 2754 | 5 | 2754 | 0 | 0 |
| 19 | 49659541 | 4162 | 79079 | 3800 | 3 | 3800 | 0 | 0 |
| 23 | 154764793 | 7131 | 164014 | 6624 | 5 | 6624 | 0 | 0 |
| 25 | 254313151 | 9051 | 226276 | 8450 | 3 | 8450 | 0 | 0 |
| 27 | 402321277 | 11287 | 304750 | 10584 | 4 | 10584 | 0 | 0 |
| 29 | 616067011 | 13863 | 402028 | 13050 | 5 | 13050 | 0 | 0 |
| 31 | 917087137 | 16803 | 520894 | 15872 | 3 | 15872 | 0 | 0 |
| 32 | 1108378657 | 18450 | 590401 | 17425 | 5 | 17424 | 1 | 0 |

The \(q=19\) pointed count is 4162 rather than 4143 because it includes the
transient 19-point marked orbit.  Its 361 additional affine lifts contribute
no split-free sextic, exactly as Certificate R7 records.

## Evidence bundle and replay

The atomic bundle is:

- `notes/2026-08-02-c660-r7-independent-generator.py`;
- `notes/2026-08-02-c660-r7-independent-certificate.json`;
- `notes/2026-08-02-c660-r7-independent-checker.py`;
- `notes/2026-08-02-c660-r7-public-comparison.json`; and
- `notes/2026-08-02-c660-r7-independent-completeness.sha256`.

The load-bearing byte counts are:

| Artifact/input | Bytes |
|---|---:|
| independent generator | 8421 |
| independent checker | 10267 |
| compact certificate | 23140 |
| frozen/public comparison | 3513 |
| direct-locus engine | 17164 |
| R5 finite-field implementation | 21745 |
| public classification record | 545925 |

From the repository root, replay the blind freeze without reading the public
record:

```text
python3 notes/2026-08-02-c660-r7-independent-generator.py --check
```

Then check the intrinsic identities and the already frozen comparison:

```text
python3 notes/2026-08-02-c660-r7-independent-checker.py \
  notes/2026-08-02-c660-r7-independent-certificate.json \
  --compare-public papers/beyond4_prs/supplement/CLASSIFICATION-RECORDS.json \
  --output-comparison notes/2026-08-02-c660-r7-public-comparison.json \
  --check-comparison
sha256sum --check notes/2026-08-02-c660-r7-independent-completeness.sha256
```

The generator is deterministic and uses no random seed.  Its final full
fourteen-field run completed in 43.66 seconds in the recorded validation environment.
The certificate is canonical JSON: fields and orbit records are sorted,
projective representatives use first-nonzero-one normalization, and all set
claims carry SHA-256 digests of sorted integer encodings.

### Structural compression

The first frozen schema occupied 207730 bytes because every orbit repeated a
decoded seven-coordinate representative, a derivable stabilizer, verbose
family labels, and a separate 64-byte orbit hash.  The final schema stores each
orbit as the canonical tuple

```text
[canonical_index, orbit_size, frobenius_target_index, family_code]
```

with one field-level partition digest.  The representative is the base-\(q\)
decode of the index, the stabilizer is \((q^3-q)/\text{orbit_size}\), and the
three family labels use a declared `P/C/E` dictionary.  Canonical compact JSON
then reduces the certificate to 23140 bytes, an 88.9% reduction, without
removing any task-card comparison datum or completeness check.

## Trust boundary

Genuinely independent from C509 are the candidate-domain construction, all
R7 contractions, split-free intersection, projective normalization and
deduplication, PGL2 orbit traversal, stabilizers, intrinsic flags, Frobenius
fusion, and both completeness identities.  No C509 executable, quotient
state, representative, orbit list, or absence assertion is imported.

Shared executable input is limited to the separately written R5 replay's
finite-field arithmetic and the already published C545 direct-locus engine;
their exact hashes are embedded in the frozen certificate.  Shared theorem
input for \(q\geq16\) is the proved/certified R6 pointed-locus classification.
For \(q<16\), even that locus is reconstructed by literal four-secant
exhaustion.  Python's standard library supplies iteration, JSON, hashing, and
dynamic module loading.  The checker independently validates the certificate
schema, normalization, two mass identities, orbit--stabilizer equations,
family masses, Frobenius permutation, and exact comparison, but it does not
constitute a second finite-field implementation.

## Review and closeout

A fresh coding/computational reader returned **ACCEPT** after one precise
documentation repair: the \(+1\) candidate is the separate zero-contraction
endpoint, not a projective point above \(B_\infty\).  The reader independently
scanned all of \(\operatorname{PG}(6,7)\), recovered the exact 77281-candidate
and 55860-split-free counts, verified all eight transported pointed loci
against literal four-secant complements, and replayed the final byte-identical
fourteen-field generator and public checker.  No coding or mathematical
blocker remains.

The required extra-juice/Tao pass asked whether the full orbit listing was
carrying structural redundancy and whether the two-stage coverage identity
could expose more than one aggregate count.  It produced the 88.9% columnar
compression above, retained separate infinity-rejection and other-marker-
rejection masses, and added fail-closed checks for the exact \(q=19\) transient
orbit.  These are task-owned trust upgrades, not new theorem claims.  The
discovery-track discriminator found no incidental lead.

## Mystery ledger

- **Transient \(q=19\) marked orbit:** settled.  It enlarges
  \(B_\infty\) by 19 points and the affine candidate domain by 361 points,
  but contributes no coherent split-free sextic.
- **Binary central singleton:** settled.  The independent flags recover one
  central orbit point at \(q=8\) and \(q=32\), exactly the odd-extension-degree
  binary case; it remains separate from the persistent mass.
- **Certificate bulk:** settled structurally by derived representatives and
  stabilizers, compact orbit tuples, and one partition digest per field.
- **Small-field radius:** intentionally not settled here.  The null radius at
  \(q=7,8,9\) is a theorem boundary, not a completeness mystery, and no code
  deep-hole promotion is made.

No genuine C660 mystery remains.
