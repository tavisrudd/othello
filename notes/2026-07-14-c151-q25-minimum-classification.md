# C151 — exact Q25 repair minimum and extremizers

**Lane**: `alt-orbit-repair` — see `CLAUDE.md` § Lane routing.

**Status:** ACTIVE — the universal `≥32` certificate is kernel-checked for all `1189` residual
classes, and all five proposed minimizer representatives have kernel-checked cardinality exactly
`32`; the checked residual cover and equality-orbit completeness remain in development.

## Target

For an eight-point Frobenius-invariant cap in `PG(2,25)` with exactly two fixed points, prove that
the number of legal nonfixed conjugate-pair extensions is at least `32`, prove that `32` is attained,
and classify the equality cases up to the residual projective stabilizer.

The paper-facing theorem must keep three logically distinct claims separate:

1. the universal lower bound `card legalPairs >= 32`;
2. explicit equality examples, making the bound exact; and
3. completeness of the five residual equality classes.

## Compute-checked scout

The independent C150 enumerator found `469600` normalized exceptional-profile arcs and reproduced
the minimum `32`.  Exactly `1600` arcs attain the minimum.  Under the order-`400` residual
`PGL(3,5)` stabilizer they form exactly five classes:

| canonical orbit triple | class size | stabilizer order |
|---|---:|---:|
| `65,93,154` | 200 | 2 |
| `65,96,216` | 400 | 1 |
| `65,98,251` | 400 | 1 |
| `65,119,232` | 200 | 2 |
| `65,123,279` | 400 | 1 |

The sizes sum to `1600`.  Exact legality count `32` for one normalized representative of each row
is now kernel-checked below.  The claim that these five residual orbits contain all and only the
`1600` equality configurations remains evidence until the residual cover and orbit-size
certificates are connected to the semantic action.

The independent residual-quotient scout `notes/2026-07-15-c151-residual-quotient.cpp` classifies
the entire `469600`-arc census under the order-`400` ordered-fixed-pair subgroup.  There are exactly
`1189` classes: `30` orbits of size `200` with stabilizer order `2`, and `1159` free orbits of size
`400`.  Every class meets the orbit-`5` slice; the slice has `7044` arcs, with intersections of size
`3` and `6` respectively.  The identities

```text
30*200 + 1159*400 = 469600,
30*3   + 1159*6   = 7044
```

are checked by the scout, as is legal-count invariance on `475600` representative/group images.
The deterministic `1189`-row CSV is `62205` bytes with SHA-256
`cb6d0bdd0ad0eb216fa306cf3e69d0142aeb934e8513cb52da54f149acd2597a`.
Source SHA-256: `6e82f4351ff818b01a089ed43d4b8de078b39b0997875cae7557f67bd0723a5b`.
Independent replay takes `1.62 s` wall and `33,588 kB` peak RSS on core `19`.

The lane-local independent generator
`notes/2026-07-15-c151-row-witnesses.py` converts those internal orbit indices to the stable Lean
numbering and independently rechecks all ten-point caps.  The five representatives become the
normalized rows

```text
(5,58,169)  (5,61,81)  (5,63,141)  (5,97,109)  (5,113,194),
```

and each has exactly `32` legal orbit numbers.  Their complete witness lists are emitted by the
generator.  Lean checks the proposed codes individually in the split-witness micro-prototype rather
than trusting the generator.

The built-in five-representative replay passes in `1.40 s` wall and `17,284 kB` peak RSS on core
`19`.  Generator SHA-256:
`402830cf528655b13d5fb9244c0fc9c3d471c2c53d58a4e7b2ede3306b0ee51e`.

The independent mask generator `notes/2026-07-15-c151-mask-generator.py` emits five `UInt64`
words for each representative's freshness, secant, carrier, and legal masks.  It separately
evaluates the reflected factorization and the original successive-`RawExtension` definition for
all `5 * 310` row/candidate pairs; the two routes agree, reproduce all `160` witnesses from the
first generator, and give legal popcount `32` on every row.  Replay takes `0.42 s` wall and
`21,200 kB` peak RSS.  Source SHA-256:
`b26f4569c4a94c843e09f1c8c81f1d6d205c4bc4b62a55a02cc38d78bc732e65`; canonical data SHA-256:
`7217ddbef742f187749c7472e2e351b14e5d0fa600b4b4b0331006860dacdaf8`.

## Certificate architecture

Do not extend C143 by storing 32 explicit `LegalPair` witnesses in every valid row.  That repeats
the dominant determinant payload sixteen-fold.  Use a stable reflected-count checker instead:

1. define the finite set of legal orbit codes and its cardinality once;
2. encode, for a normalized row, the candidate orbits obstructed by occupied points or by a secant
   of the eight-point configuration;
3. prove once that an orbit code is outside this obstruction mask if and only if it is a
   `LegalPair`;
4. generate compact row certificates whose only varying payload is the obstruction mask or an
   equivalent coverage summary, and kernel-check a popcount bound;
5. transport legal-pair cardinality through the existing stabilizer and base-field normalizations;
6. separately certify the five attaining representatives and the completeness of their residual
   orbits.

`Q25MinimumChecker.lean` implements the semantic heart of steps 2–3 downstream of the stable C143
checker.  For a conjugation-invariant old configuration it factors `LegalPair S o` into freshness,
avoidance of the old secants by one representative, and avoidance of the candidate pair's fixed
carrier by every old point.  The conjugate representative's secant conditions then follow by
conjugating the determinant.  Thus a row mask needs only joins of the `28` old point-pairs and the
`8` old-point carrier incidences; it need not replay `RawExtension` for all `310` candidates.

The checker target builds successfully with `LEAN_NUM_THREADS=4`, cores `20-23`, and
`choom -n 1000`: `46 s` target time, `51.56 s` wall, `3,399,172 kB` peak RSS.  SHA-256:

- source: `332e74e88d8bbc7bb4adf6f6679d13e33e14109270cb3d8dc678227f979c6c4d`;
- `.olean`: `32dc880527b1c848975910029a9534df41d96603eee3aaca5cfe5a19031b40fe`;
- trace: `d25335633a0ef172a51e5b91b71b4d05f961411617c5a33b7ad30c20b1113ff1`.

The first development gate is a one-row prototype: the semantic mask bridge, its source/object
size, and replay time must beat a direct 32-witness row before full generation is authorized.

`Q25MinimumMask.lean` supplies the generic five-word mask API and proves that a sound mask of
cardinality at least `32` injects into the actual `LegalPair` set.  Its final guarded build succeeds
in `18 s` target time and `26.52 s` wall at `3,290,480 kB` peak RSS.  The first literal row prototype,
`Q25MinimumMaskMicro.lean`, kernel-checks the proposed popcount `32`, its first set bit, and one
split reflected soundness leaf in `9.7 s` target time and `14.53 s` wall at `3,960,084 kB` peak RSS.
This is the first count architecture to pass the one-row memory gate.

`Q25MinimumMaskRow0058169.lean` completes that gate with all `32` soundness leaves, an exhaustive
`Fin 310` dispatcher, conjugation invariance, and the final theorem
`32 ≤ (legalOrbitSet equalityRepresentative).card`.  Its final warning-free guarded rebuild
succeeds in `119 s` target time and `2:07.26` wall at `8,488,244 kB` peak RSS.
`lake build --no-build` reports the target
current, and the paper-facing row theorem has only `[propext, Classical.choice, Quot.sound]` in its
axiom audit.  SHA-256:

- source: `47df79840013f628bde50ee6f5468f976ddf6174920bca50e4f16871b2954a3e`;
- `.olean`: `2a4737df9e2e0d2869d5e077decefdb3de901da659ec85f6e25969b6cba6e5b7`;
- trace: `3b5433a86c76b3b661f10ae995093aa1ac3296a86ac6e8a46d3e90f452591c8e`.

The pre-build recovery snapshot is
`/home/tavis/.cache/othello-project-oleans-c151-maskgate-20260715-1345` (`644 MB`, `18950` files).

`Q25ResidualAction.lean` identifies the generated residual action with the existing projective
normalizer by an executable affine formula on `Idx25`.  The two admissible coordinates each form a
`20`-element type, so the checked parameter family has cardinality `400`.  The module proves cap
preservation, orbit-pair transport, legality equivalence, and exact preservation of
`legalOrbitSet.card`; generated cover rows can therefore reduce the executable image while the
semantic theorem reuses the projective proof.  Its guarded build succeeds in `10 s` target time and
`16.95 s` wall at `3,421,580 kB` peak RSS.  The no-build gate reports it current; its cardinality
transport has only `[propext, Classical.choice, Quot.sound]` in the axiom audit.

The independently replayed residual-cover generator
`notes/2026-07-15-c151-residual-cover.cpp` exhausts the `46056` normalized rows containing orbit
`5`: `39012` carry an explicit bad-triple witness and `7044` are valid.  It maps every valid row to
one of the `1189` canonical residual classes and checks all `56352` transported point images plus
all `7044` legality invariance claims.  The class-orbit histogram is `30` of size `200` and `1159`
of size `400`; replay takes `0.41 s` wall at `8,284 kB` peak RSS.  The source SHA-256 is
`73d442df3be986c1082af8e3498ddd0496c09b86dd24963ea6d887a8f9b7680d`; the canonical CSV stream
SHA-256 is `62aa26c98deb98cb786fa1b21957b91ec16b1e2bd2a6319129c31449eb0effe3`.

`Q25LineMaskChecker.lean` supplies the shared determinant layer: an explicit nonzero-scale witness
identifies a point-pair cross product with one of `651` canonical dual lines, after which one generic
theorem replaces every determinant against that pair by a reusable line-incidence bit.  The same
interface certifies conjugation-fixed candidate carrier lines.  Its guarded interface build succeeds
in `19 s` target time and `24.25 s` wall at `3,398,164 kB` peak RSS.

The independently replayed line-mask generator
`notes/2026-07-15-c151-line-mask-generator.py` checks all `651` canonical lines, all `8060`
selected-representative incidences, and all `310` carrier witnesses.  The `31` carrier lines are
exactly the conjugation-fixed lines and each carries `10` nonfixed orbit pairs.  Its five-word mask
table occupies `26040` raw bytes; replay takes `3.38 s` wall at `22,408 kB` peak RSS.  Source
SHA-256 is `c1142234ba46eb06c5b73c43c0c8e14e0cdce6ef58c4d347ee8c3f046edaa9ff`; semantic-data
SHA-256 is `a67b4321bce4d034630b311ec249ae5e589a62fd57b580568d38326cc956231d`.

`Q25LineMaskPrototype.lean` kernel-checks all `310` incidence bits for the canonical line through
the two normalized fixed points and its explicit nonzero-scale line witness.  The guarded build
succeeds in `5.9 s` target time and `11.13 s` wall at `3,528,832 kB` peak RSS: about twenty times
less target time and under half the memory of the direct full-row certificate.  The no-build gate is
current; the certificate audit uses only `[propext, Quot.sound]`, while the line-witness audit adds
`[Classical.choice]`.  SHA-256:

- source: `a10b95d74913ef6d8a02f25606cc6f90e4b8f393cb9a9e21ca4daed53f597a1b`;
- `.olean`: `f6406a072962e89a39ec5241e2fa265368784f1b4f36ea85c05ae40207406dbc`;
- trace: `3b4717b72b99ab4e7819467d28787396b18480df7962a4229bd62e87ca2cc9a3`.

The deterministic generated tree `Q25LineMaskData/` now promotes all `651` canonical line masks:
`66` bounded leaf modules (ten lines each, except the final singleton) plus `All.lean`.  Each line
has its own literal mask, separate `Fin 310` exactness theorem, and `LineMaskCertificate`; the full
source is `345675` bytes.  A three-worker guarded aggregate build succeeds in `6:40.81` wall at
`4,682,396 kB` peak RSS, and the no-build gate reports all `8714` jobs current.  Representative
first/middle/last certificate audits use only `[propext, Quot.sound]`.  Generator source SHA-256 is
`fa67feb9d96ab96ff24c2516fdb97f08ae063a6ced3e199c76bad2de2ba39e31`; semantic data SHA-256 is
`a67b4321bce4d034630b311ec249ae5e589a62fd57b580568d38326cc956231d`; deterministic generated-tree
SHA-256 is `9c07c6c466844a0926bdcdb9ee205280a75f00436d78c16d3a964fbe6828e229`.
Aggregate SHA-256:

- source: `bf536c7da6a950f6ff3bd72c11fd70ecbe87a95dffb543bc7015a678660f7637`;
- `.olean`: `bb963cf5420803d5c3412770516ce1d54a56a48867183bb8644898acedcea8f6`;
- trace: `ba7e4f81f4110c10b74ed9fe8f8b6a5034c1807f5bfbd2bece5b0f650120cd80`.

The pre-aggregate recovery snapshot is
`/home/tavis/.cache/othello-project-oleans-c151-line-table-prebuild-20260715` (`645 MB`).

`Q25CarrierLineData/` promotes the `310` candidate-pair carriers in `31` bounded leaves and exposes
total line, line-mask, carrier-line, scale, and certificate dispatchers.  The generated tree has
`33` files and `148698` bytes.  Its three-worker guarded dispatcher build succeeds in `172 s`
target time and `3:58.09` wall at `10,936,680 kB` peak RSS; downstream consumers reuse that one-time
object.  The aggregate no-build gate reports all `8747` jobs current.  Current generator source
SHA-256 is `1b5731306dbe629f679a8773e71e8be13c097d654838abf088284258a850f7be`;
semantic data SHA-256 remains
`a67b4321bce4d034630b311ec249ae5e589a62fd57b580568d38326cc956231d`; carrier-tree SHA-256 is
`4f6a0ab1aee7085fbfb5b65f233d0132ad15d05daca1984ede710ffcc8682421`.  Aggregate SHA-256:

- source: `264980d51d5b6a1ea3c136aa1d176e9ce834ec22c4874e52d79cd0b60a84025a`;
- `.olean`: `62b4ade92f5eb20c967e456a4fc45094818a5614542844feb23c0b26fb31e8e8`;
- trace: `5e19ff904c903cb5eb909813cf5997991e4ecb1e2e0688dc58eeeed1015e55ff`.

The independent shared-line composition generator
`notes/2026-07-15-c151-shared-line-composition.py` checks all `1189 * 310 = 368590`
representative/candidate decisions against direct `LegalPair`.  Every row has `28` distinct secants;
its compact payload has SHA-256
`cf4d4903662c4f0cd0edb9a76c6c4427102304a1647df1c90340434ca769bf0a`.  Freshness always blocks
`3` candidates and carrier incidence always blocks `140`; secant obstruction ranges from `227` to
`244`, and the exact legal-count histogram ranges from `32` to `47` with five rows at `32`.

`Q25LineMaskComposition.lean` turns five word-level bitwise-disjointness checks into the full
`Fin 310` mask-avoidance predicate and composes shared line/carrier certificates into
`ReflectedMaskCertificate`.  `Q25RowCompositionPrototype.lean` applies it to `(5,58,169)`; the
optimized guarded build succeeds in `12 s` target time and `16.54 s` wall at `4,180,372 kB` peak
RSS.  The no-build gate is current, and the paper-facing lower-bound theorem has only
`[propext, Classical.choice, Quot.sound]` in its axiom audit.  SHA-256:

- composition source: `678096e7f41f0c72381dbf896fe51d755106495f0eb61ef5c81bca91cb8f28eb`;
- prototype-data source: `ff0c42bfa6c4b36f32b5d15c9f1c57f97686c0c90a031da267fa08b42e36cf59`;
- prototype source: `f1f594bec36de6a9cf0034de3bd8b51e7070d314f3b9e33798f48b67e7d5d3ef`;
- prototype `.olean`: `8005a1f49a0d84120b0d34cb658aa0d0a3b099319cf14165b5f59e3599bf4455`;
- prototype trace: `b4e54f7f780e9a91027d129f781659662e91b08c28e93babd2075140d69431f9`.

The deterministic bulk tree `Q25RowCompositionData/` contains `238` bounded leaves and an aggregate
for all `1189` residual classes. Each class receives a literal allowed mask, shared line/scale
composition certificates, and a final theorem that its semantic `legalOrbitSet` has cardinality at
least `32`. The generated source has `239` files and `3712330` bytes; independent regeneration is
byte-identical. Generator SHA-256 is
`d569833d0340c3454299e4e6654d1fa9a67fc249db4f1e4102c59105c6292645`; generated-tree SHA-256 is
`125e92f4f835f0c699cbe12f361ebe47747b38b80cfe1db2d7140ae8f19af04a`.

The guarded three-worker aggregate build completed all `8987` jobs in `1:15:37` wall time at
`5388488 kB` peak RSS with zero swaps and exit status `0`. A trace-only replay reports all targets
up to date in `13.77 s` wall time at `552168 kB` peak RSS. Representative first/middle/last
lower-bound theorems all have axiom profile `[propext, Classical.choice, Quot.sound]`; the
forbidden-token and whitespace scans are clean. Aggregate SHA-256:

- source: `bdeec058a3ab7b17af547f8c1a834fdf217817e680317da29ff195e083e0e019`;
- `.olean`: `80237b7ad099d0ae948f2e747ed3c9f73cfd53137e913f162eee65c068205203`;
- trace: `95e18b0a5f82eaeffa7cd96f062f10eac2bca1adb991ac02af0fa74fffbca1ae`.

The current recovery snapshot
`/home/tavis/.cache/othello-project-oleans-c151-rowbulk-passed-20260715-163832` preserves all
post-pass project objects (`20710` files, `2.4 GB` logical; reflink-backed on disk). The copied
aggregate `.olean` hash matches the live artifact.

### Five-row attainment gate

`Q25ExactnessComposition.lean` supplies the reverse-inclusion half missing from the bulk lower
bound: a literal cover of every bit outside the allowed mask by a sound freshness, secant, or
carrier obstruction proves that the semantic legal-orbit set is contained in the literal allowed
set.  Combining this upper bound with the existing row-composition lower bound gives exact
cardinality `32` for the five proposed minimizer representatives.

The generated exactness leaves are split one representative per module under
`Q25ExactMinimumRows/`.  A single module containing all five certificates was safely OOM-killed
before producing an object (`2:17.79` wall, `17,396,476 kB` peak RSS, exit `137`); splitting the
independent elaborations is therefore part of the certificate architecture, not merely a build
convenience.  With `LEAN_NUM_THREADS=1`, cores `20-23`, and `choom -n 1000`, all five leaves pass
strictly serially with zero swap:

| representative class | normalized row | wall time | peak RSS |
|---:|---:|---:|---:|
| `0065` | `(5,58,169)` | `3:28.61` | `13,737,708 kB` |
| `0267` | `(5,61,81)` | `3:51.52` | `15,161,984 kB` |
| `0445` | `(5,63,141)` | `2:50.67` | `14,368,092 kB` |
| `0772` | `(5,97,109)` | `2:56.25` | `16,118,552 kB` |
| `1002` | `(5,113,194)` | `3:11.77` | `15,973,704 kB` |

The import-only aggregate passes in `10.58 s` wall at `3,379,276 kB` peak RSS.  Its trace-only
replay passes in `7.23 s` wall at `552,900 kB` peak RSS.  All five equality theorems have axiom
profile `[propext, Classical.choice, Quot.sound]`; the generated exactness sources are free of the
forbidden validation tokens.  The guarded serial-run logs are under
`/home/tavis/.cache/othello-lean-logs/c151-exactness-20260715-171252`.

Generator SHA-256 is
`1e6ebe132972fa03987474a71d49974a60b31f04ee5a68d2d9c94f70b0864755`; semantic exactness-data
SHA-256 is `bc8b59f3ae69f139550d24046bf8f1764411fd4c203875d19cb14c40f39dfc4c`.
The generic composition source/object/trace hashes are respectively
`8190dc2d29e63da6b04da0d43eb412c40cde07c8f3f815bca17f1b8f9a35eeda`,
`c133c29d3eacfb56d6f41399b2b9cd3589fff5a43e0620ee797d8c5698764112`, and
`5654dea94b87c9712aa10035ef29755af14a802799ea2b27f955498d68816757`.
Aggregate source/object/trace hashes are respectively
`9173a2a2a3ef379dbf4a2781265af0217651df171a5aebd9283ed16f685e204c`,
`5ef3dc6fc3b9ed59f1958f1039d2d599d47e816557b35351f48b5d45353fec0f`, and
`290ddfef9a57256333483c49cdbdf4e849ce6ae58582c748318a6ae130a5b10d`.
The post-pass disk-backed reflink snapshot is
`/home/tavis/.cache/othello-project-oleans-c151-exactness-passed-20260715-1730`
(`20745` files, `2.4 GB` logical); its copied aggregate `.olean` hash matches the live artifact.

### Prototype sizing

The discarded direct-count prototype reduced the cardinality of all `310` `LegalPair` decisions on
a known valid row.  Its guarded single-row build was OOM-killed before producing its leaf: `566 s`
for the target (`9:33.26` whole command), `16,127,604 kB` peak RSS, exit `137`, with
`LEAN_NUM_THREADS=4`, `choom -n 1000`, and cores `20-23`.  No pre-existing object was invalidated.
Direct cardinality reduction is therefore not a viable row format.

The discarded monolithic witness prototype reflected the first equality representative's `32`
distinct legal orbit codes into a `Finset` and tried to check the whole subset relation with one
`by decide`.  It too was OOM-killed before producing a leaf: `559 s` for the target (`9:33.19`
whole command), `15,890,872 kB` peak RSS, exit `137`, under the same guard.  Thus merely replacing
the full count by one large witness proposition does not solve the elaboration problem.

`Q25MinimumWitnessMicro.lean` now measures the C143-style fallback: reduce each `LegalPair` claim as
a small theorem and compose the resulting constants by ordinary finset reasoning.  The shared-mask
checker remains preferable; the split-witness result determines whether this fallback is at least
safe enough for the five attainment representatives.

The split-witness leaf succeeds: one independently generated legality theorem builds in `17 s`
target time and `23.28 s` wall with `4,173,224 kB` peak RSS under the same guard.  This makes split
witnesses viable for the five explicit attainment representatives, but not economical for a
universal census.

A discarded reflected-count prototype filtered all `310` candidates by `ReflectedLegal` and asked
for cardinality `32` in one `by decide`.  Despite the semantic factorization, it was OOM-killed
after `489 s` target time (`8:14.49` whole command), at `17,362,420 kB` peak RSS, exit `137`.
Therefore the semantic bridge alone does not make a monolithic count reducible: the count layer
must consume literal compact masks, with determinant-to-bit correctness split into small leaves.

### Residual-transport memory gate

`Q25ResidualCoverBridge.lean` now replaces the opaque finite-set equality check by a generic
eight-point certificate: a pointwise source-to-target map together with an explicit right inverse
proves the required image equality and hence reuses the existing exact legal-cardinality transport.
The generated prototype uses the permutation `(0,1,7,6,4,5,2,3)` on source row `(5,40,196)` and
passes its exact queue gate in `11.31 s` wall at `3,398,676 kB` peak RSS.

The independent transport generator checks all `7,044` valid residual rows against the canonical
CSV, including a forward permutation and inverse law for each row.  Lean checks the resulting
certificates in `1,036` modules, capped at eight valid rows and hence at most `64` concrete point
equalities per module. The import aggregate and its trace-only no-build gate pass. Only `16`
point-permutation patterns occur; their transport stream has FNV-1a-64 `4e503df3c383731d`.  This
count is an engineering compression fact about the deterministic chosen transporters, not yet a
geometric classification claim.

## Equality classification plan

- Use the checked `400`-element residual action and the now-checked exact counts on the five
  representatives.
- Give every bad normalized row a checked `BadWitnessValid` certificate and every valid row a
  checked residual transport to its canonical representative.
- Connect each transported canonical representative to its literal `Q25RowCompositionData` class;
  neither a stored `classIndex` nor a stored `legalCount` is a semantic theorem by itself.
- Prove the representative orbits disjoint by canonical codes and exhaust the equality rows.
- Certify orbit-stabilizer sizes `200,400,400,200,400` separately; legal-cardinality transport does
  not validate the generated `orbitSize` field.

## Validation gates

- independent checker reproduces the legal-count histogram and the five classes;
- every generated claim reduces to coordinate definitions in Lean;
- no `axiom`, `sorry`, `admit`, `native_decide`, `ofReduceBool`, or `Lean.ofReduceBool`;
- axiom audit on the paper-facing theorems;
- source/object hashes and capped-build timing recorded here;
- manuscript promoted only after all three target claims are checked.

## Current next step

Add a thin dispatcher for each existing payload leaf: bad entries use
`not_rawCap_of_badWitness`, while valid entries use the checked point-permutation transport. Add
explicit class-link theorems from transported canonical rows to the literal
`Q25RowCompositionData` classes.  Only after that cover closes should the five equality orbits and
their stabilizer sizes be promoted as a complete classification.
