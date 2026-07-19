# C151 — exact Q25 repair minimum and extremizers

**Lane**: `alt-orbit-repair` — see `CLAUDE.md` § Lane routing.

**Status:** REPORTED — the universal normalized-row `≥32` theorem is kernel-checked for all `46,056`
rows in the orbit-`5` slice, all five proposed minimizer representatives have kernel-checked
cardinality exactly `32`, the `≥32` bound is lifted to every semantic invariant eight-arc with
exactly two fixed points, and equality-orbit exhaustion is kernel-checked: every normalized row
attaining `32` lies in the `1600`-element union of the five certified orbits. The matching lift of
exhaustion to semantic arcs is the one remaining step and is stated as such in
§ "What this does not certify".

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

### Normalized-row conclusion gate

`Q25ResidualConclusionData/` composes every checked mixed-row dispatch with its semantic
conclusion. A bad payload contradicts the assumed `RawCap`; a valid payload transports legal-pair
cardinality to its linked `Q25RowCompositionData` canonical class and reuses that class's checked
`≥32` theorem. The generated tree contains `1,071` conclusion leaves, `303` bounded `b`-aggregates,
and one import aggregate: `1,375` files, `5,012,425` bytes, covering all `46,056` normalized rows.

The exact aggregate queue target
`RelativeConicArcs.Q25ResidualConclusionData.All` passed with one Lean worker on cores `20-23` and
`choom -n 1000`: `4:30:31` wall, `3,903,872 kB` peak RSS, exit status `0`, followed by a successful
trace-only aggregate gate. The run record is
`/home/tavis/.cache/othello-lean-build/run-20260717-174300-2f6693be`.

Regeneration from the independently checked canonical CSV is byte-identical:

```sh
cd /home/tavis/src/othello
out=$(mktemp -d /home/tavis/.cache/c151-conclusion-check.XXXXXX)
python3 notes/2026-07-17-c151-residual-conclusion-generator.py \
  --csv /home/tavis/.cache/c151-residual-cover.csv \
  --write-lean-modules "$out/Q25ResidualConclusionData"
diff -qr lean/RelativeConicArcs/Q25ResidualConclusionData \
  "$out/Q25ResidualConclusionData"
```

The canonical CSV SHA-256 is
`62aa26c98deb98cb786fa1b21957b91ec16b1e2bd2a6319129c31449eb0effe3`; the generator SHA-256 is
`43954385dbbf428ae1450adcb31c7cc353f5f62c1d8295113ea671041b49983c` (`7,620` bytes); and the
generated-tree SHA-256 is
`9cdcc9510dc573971bd326c89fbabbdcb6ab5144a527db7347f60556cf5775d2`. The aggregate source,
object, and trace SHA-256 hashes are respectively
`0959d27a0c6ceca1722e7ba4722eb958723ec0b4fb7cae514cebfa79f0e3bc65`,
`f125f1dd465fc6a7ed7b409966b4b3a05f0e2d17ea89d9d5fd5128b658a9632a`, and
`fc0c96cb71db6e158a8a0ba3677bfa912e8f38a24afab8a2a15474a724329dc2`.

A forbidden-token scan is clean. Representative conclusion leaves containing valid and bad rows
both have axiom profile `[propext, Classical.choice, Quot.sound]`. The trusted boundary remains the
Lean kernel, the checked coordinate/action bridges, and the literal generated certificates; this
gate proves the lower bound only for normalized orbit-`5` rows and does not by itself prove that
every semantic exceptional-profile arc normalizes into that slice or classify the equality orbits.

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

## Residual-orbit certification: blocker, evaluator, and route (2026-07-18)

### Orbit sizes: generator output until 2026-07-18, now certified

`orbitSize` is a payload field in `Q25ResidualCoverData/Schema.lean` and appears in no proof; the
bridge docstring already says the stored `legalCount`, `classIndex`, and `orbitSize` fields are not
proof inputs. The sizes `200,400,400,200,400` were therefore generator output throughout, not
theorems.

They are now kernel-checked, together with pairwise disjointness and the union `1600`, by the
orbit–stabilizer route below. The certified statements and their replay commands are in
§ "Certified residual-orbit layer".

### The blocker was one opaque atom, not size

`Q25ResidualMinimumOrbits.lean` does not compile: every `decide` in it fails to reduce. The cause is
a single kernel-opaque operation. `scale x = algebraMap F5 K25 (imagPart x)⁻¹`, and inversion on
`F5 = ZMod 5` is `ZMod.inv`, which routes through `Nat.gcdA`/`xgcdAux` well-founded recursion that
the kernel will not unfold. `algebraMap` is not opaque (`assemble` is proved by `decide`), and
`GF25.inv` is a literal 25-entry table. Every generated transport leaf already works around this by
hand, with `simp [residualApply, shift, scale, realPart, imagPart, ...] <;> decide`. No `decide`
touching a residual image could have reduced at any problem size.

`Q25ResidualFast.lean` removes the atom once and symbolically: on `F5`, inversion is cubing, since
`a ^ 4 = 1` away from zero and both sides vanish at `0`. This needs no table and no data to audit.
It exports `scaleFast`, `shiftFast`, `residualApplyFast`, and the bridge `residualApply_eq_fast`.
The module elaborates warning-free in `5.7 s` and builds green as an exact queue target.

### Measured cost probes

Run against the fast evaluator on the first minimizer row `(5,58,169)`; both are measurements, not
paper-facing theorems.

Probe A **passes** in about three seconds, and is the fact the route depends on:

```lean
(Finset.univ.filter fun g : ResidualParameter =>
    probeRow.image (residualApplyFast g.1.1 g.2.1) = probeRow).card = 2
```

This kernel-checks stabilizer order `2` for the row, matching the C150 scout table's prediction.

Probe B **fails**: `(orbitKeys probeRow).card = 200` through sorted `rank` keys gets stuck on
`List.decidableBAll`, because `Finset.sort` bottoms out in `List.mergeSort` — the same class of
well-founded recursion as the original blocker. A packed-`Nat` bitmask key using the kernel's GMP
arithmetic would avoid sorting, but is not needed by the route below.

### Two approaches are ruled out

- **Materializing orbits.** `Finset.image` is `Multiset.dedup ∘ Multiset.map`; deduplicating 400
  eight-element `Finset Idx25` values is quadratic membership testing, and the 1600-element union
  is quadratic again. The Q11 authors recorded literal blocks at smaller scale for exactly this
  reason. Fatal independently of the opaque atom.
- **Sorted-key fallback.** Dead by Probe B.

### Route: orbit–stabilizer, which never materializes an orbit

Orbit sizes come from `400 / |stab|`, so `200` is arithmetic on a verified stabilizer order. Ordered
by risk, with the riskiest mathematics first; steps 1–5 landed on 2026-07-18:

1. **Done.** Multiplication on `AdmissibleCoordinate` by the recovered-parameter formula, with
   `apply (g * h) = apply g ∘ apply h`. The scale/shift pair is a bijection onto `AGL(1,5)`, so the
   parameter exists; the identity parameter is `x = ω`. This is the soundness lemma of the design.
2. **Done.** Group instance, axioms by `decide`. The axioms were decided on the 25-element
   coordinate type rather than the 20-element subtype: associativity is `15,625` cases that way
   against `8,000`, and the raw type avoids subtype overhead in the kernel. `ResidualParameter`
   inherits the product group. Never put the group on the 400-element product: `mul_assoc` there is
   `6.4 · 10⁷` cases.
3. **Done.** `MulAction` compatibility factored: only the two parameter-level facts are decided
   (`scale` multiplicativity, `shift` composition), and the `.affine`/`.infinity` cases are derived
   symbolically with `.vertical` by `rfl`. Deciding compatibility directly is about `10⁸` cases.
4. **Done.** Mathlib's `Set`-orbit and `Subgroup`-stabilizer bridged to the
   `Finset.image`/`Finset.filter` forms, then the five sizes.
5. **Done.** Non-conjugacy of the five representatives, equal-or-disjoint, and the union
   cardinality `1600`.
6. **Open.** Exhaustion as a separate theorem against the residual-cover machinery.

Two traps recorded by the design review. Every decided statement must be phrased through
`Finset.image` of the *fast* function with a `simp` bridge to the embedding form, never
`Finset.map (parameterEmbedding g)`, whose `toFun` reintroduces the slow `residualApply`. And
equal-or-disjoint requires identity, closure, and inverses: `Q25ResidualAction` proves each map
injective but nothing about composition, so a bespoke lemma missing an inverse hypothesis can
typecheck without yielding the union theorem. Note also that no `Finset` `Disjoint` is decided
anywhere in the repo; decide `(A ∩ B) = ∅` explicitly and bridge.

The full cost analysis and correctness flags are in
[the design review](2026-07-18-c151-orbit-completeness-fable-review.md).

### Certified residual-orbit layer (2026-07-18)

Four committed modules under `lean/RelativeConicArcs/`. The recovered parameter is
`mulCoord g h = algebraMap (imagPart h) * g + algebraMap (realPart h)`, which is `(φ h)⁻¹ g`; the
inverse parameter is the map's own image of `ω`.

| Module | Terminal | Statement |
|---|---|---|
| `Q25ResidualComposition.lean` | `residualApplyFast_mul` | `apply (g * h) = apply g ∘ apply h` |
| `Q25ResidualGroup.lean` | `card_residualOrbit_mul_card_residualStabilizer` | `orbit.card * stabilizer.card = 400` |
| `Q25ResidualMinimumOrbits.lean` | `card_residualOrbit_*` | orbit sizes `200,400,400,200,400` |
| `Q25ResidualMinimumOrbits.lean` | `card_minimumOrbitUnion` | the five orbits union to `1600` |
| `Q25ResidualEquality.lean` | `isMinimumResidualClass_iff_mem_minimumOrbitUnion` | `IsMinimumResidualClass C ↔ C ∈ minimumOrbitUnion` |

Only two shapes are ever decided: the parameter-level `scale`/`shift` identities over `K25` pairs,
and, per row, one `400`-parameter stabilizer filter plus one `400`-parameter non-reachability
statement. Stabilizer orders are `2,1,1,2,1`; disjointness uses ten non-reachability decides. No
orbit is materialized anywhere in the proof, and `residualApply` never appears inside a `decide`.

Replay, from `/home/tavis/src/othello/lean`:

```sh
scripts/lean-build-queue.py run \
  RelativeConicArcs.Q25ResidualComposition RelativeConicArcs.Q25ResidualGroup \
  RelativeConicArcs.Q25ResidualMinimumOrbits RelativeConicArcs.Q25ResidualEquality \
  --profile single --threads 1 --cores 20-23
```

Exact-target queue results, one Lean worker on cores `20-23` with `choom -n 1000`, all exit status
`0` and each followed by a successful trace-only aggregate gate:
`Q25ResidualComposition` `0:34.61` wall at `5,128,248 kB` peak RSS
(`/home/tavis/.cache/othello-lean-build/run-20260718-224412-ca2cdfa8`);
`Q25ResidualMinimumOrbits` `2:06.52` at `8,865,192 kB`
(`run-20260718-225434-11fc8755`), and `1:45` on rebuild after the group module gained its bridge
lemmas; `Q25ResidualGroup` `0:08.95` at `3,479,772 kB` (`run-20260718-225036-24c896f3`);
`Q25ResidualEquality` `0:08.16` at `3,394,252 kB` (`run-20260718-230121-8a185f8a`). A confirming
re-run reports all four already trace-current (`run-20260718-230347-5b035a23`).

Source SHA-256 and byte counts:

| File | SHA-256 | Bytes |
|---|---|---|
| `Q25ResidualComposition.lean` | `86482e38daed26fc35e77821ed3681e8c3847a7b7b0114dd6c90a277536e6c63` | `4,292` |
| `Q25ResidualGroup.lean` | `5991948725b455837dd228703729879a42f4a387c19620612b18dfbc9d3a713d` | `7,744` |
| `Q25ResidualMinimumOrbits.lean` | `8ca5af076c2660767d6153ef04b3cde96dc5808d45908d07e9ccdbb66be1f49b` | `9,568` |
| `Q25ResidualEquality.lean` | `8723073b569ef941a7594944a295e3b5ba8a7429d24c2368fa7cac093c8f6747` | `2,593` |

A forbidden-token scan over the four files is clean. The axiom profile of
`residualApplyFast_mul`, `card_residualOrbit_mul_card_residualStabilizer`,
`card_residualStabilizer_0065`, `card_residualOrbit_0065`, `card_minimumOrbitUnion`, and
`isMinimumResidualClass_iff_mem_minimumOrbitUnion` is `[propext, Classical.choice, Quot.sound]`
with no `sorryAx`.

What this does not certify: that the five orbits *exhaust* the rows attaining `32`, and that every
semantic exceptional-profile arc normalizes into the orbit-`5` slice. Until both land, `32` is not
the exact semantic minimum and the five classes are not a complete extremal classification.

## Exhaustion route: the strict bound is already tracked data (2026-07-18)

Each canonical class carries a `RowCompositionCertificate` over an `OrbitMask` of orbit codes its
fresh/secant/carrier certificates prove legal. The structure field is
`card_le : 32 ≤ (maskOrbitSet allowed).card`, so the threshold is a constant of the structure and
the mask's own cardinality reaches no Lean statement.

Reading those cardinalities out of the tracked `Q25RowCompositionData` leaves gives the spectrum
`32`–`47` over all `1,189` classes, and exactly five classes attain `32`: `65`, `267`, `445`,
`772`, `1002`. These are the five certified minimizer rows. Every other class already carries a mask
of at least `33` elements.

Because the mask is a *subset* of the legal orbit set, a mask of `n` elements certifies
`n ≤ legalOrbitSet.card`. The strict bound that rules out every non-minimizer class is therefore
already present as tracked, kernel-checkable data: exhaustion needs no new mask generation, only a
`decide` at threshold `33` against masks that are already committed.

Two structural facts make the rest reusable rather than regenerated:

- `ValidRowPayload.TransportValid b p` is
  `(rowConfig b p.c).image (residualApply p.y p.z) = p.canonicalConfig`. The transport is an element
  of the certified residual action, not merely an eight-point permutation; the permutation
  certificate is only the cheap way to prove that image equality. A valid row's transport therefore
  yields orbit membership, and `ValidRowPayload.legalCard_eq` gives *equality* of legal
  cardinalities between a row and its canonical class.
- `ValidRowPayload.source_card_ge_of_canonical` is already generic in the bound `n`, so the existing
  dispatch payload tree is reusable at threshold `33`; only a new conclusion layer is required.

The resulting argument: dispatch each normalized row; a bad payload contradicts the assumed
`RawCap`; a valid payload transports legal cardinality to its canonical class, and a class whose
mask has at least `33` elements cannot attain `32`. So a row attaining `32` links to one of the five
classes and lies in their residual orbits, closing against
`isMinimumResidualClass_iff_mem_minimumOrbitUnion`.

### Mask-spectrum evidence bundle

Replay, from `/home/tavis/src/othello`:

```sh
python3 notes/2026-07-18-c151-minimum-mask-spectrum.py \
  --check notes/2026-07-18-c151-minimum-mask-spectrum.json
```

| File | SHA-256 | Bytes |
|---|---|---|
| `2026-07-18-c151-minimum-mask-spectrum.py` | `151b34ce6d0e1c0d3d18b9f12623e504ca0095c0bca506c7f657db6ddb410a94` | `7,549` |
| `2026-07-18-c151-minimum-mask-spectrum.json` | `236c9abe08fda2c03d076868d23a4577b65ff9ebe2afdf85c560836a77c5fd17` | `10,393` |

The script parses only tracked Lean sources and fails loudly on schema drift: a wrong mask-word
count, a duplicated class, a class set other than `0..1188`, or any class below the certified `32`.
The independent cross-check reads the `legal` column of the residual-cover CSV
(`62aa26c98deb98cb786fa1b21957b91ec16b1e2bd2a6319129c31449eb0effe3`), which is derived from the
generator rather than from the Lean tree; it agrees with the mask cardinality on all `1,189`
classes. That CSV is an untracked cache, so `--check` compares only the tracked-source-derived
fields and records the cross-check status separately.

What this does not certify: the mask cardinality is a lower bound on the legal count, not the exact
count, except at the five rows where equality is separately checked. The CSV agreement cross-checks
the generator against the Lean tree; it is not a proof that a mask equals its legal orbit set. None
of this is yet a Lean theorem — it identifies which decides to run and shows the data for them is
already committed.

## Semantic normalization lift (2026-07-18)

The lift is checked. `Q25MinimumClassification.lean` carries the projective statement

```lean
theorem f2_card_globalLegalPairs_ge_32 (C : Finset Point25)
    (hArc : Arc C) (hInv : IsInvariant … C) (hcard : C.card = 8)
    (hfixed : (fixedArcPoints F5 K25 C).card = 2) :
    32 ≤ (globalLegalPairs F5 K25 gf25_degree C).card
```

so the `≥ 32` bound now reaches semantic invariant eight-arcs in `PG(2,25)`, not only normalized
rows. The route is the two projective normalizations: `card_legalOrbitSet_liftMapIdx` moves the
legal-orbit cardinality along a base-field map that sends the two fixed points to the standard pair,
and `card_legalOrbitSet_residual` moves it along the residual map that sends the selected orbit to
orbit number `5`; `concludeNormalizedRow` then discharges the resulting row.

Replay, from `/home/tavis/src/othello/lean`:

```sh
scripts/lean-build-queue.py run \
  RelativeConicArcs.Q25MinimumClassification \
  RelativeConicArcs.Q25ResidualCoverPrototype.RowConclusion \
  --profile single --threads 1 --cores 20-23
```

Exact-target queue results, one Lean worker on cores `20-23` with `choom -n 1000`, exit status `0`
and a passing trace-only aggregate gate (`run-20260718-234601-babdf8aa`):
`Q25MinimumClassification` `0:11.23` wall at `4,139,416 kB` peak RSS, and
`Q25ResidualCoverPrototype.RowConclusion` `0:08.94` at `3,446,736 kB`. Those figures are rebuild
costs against a warm dispatch tree; the first build of the tree itself took about `30` minutes.

| Artifact | SHA-256 | Bytes |
|---|---|---|
| `Q25MinimumClassification.lean` | `cfca4eaac132b0c6e84bdda86e1ed964ed5386c8a98e2e1120bac34d8017bad1` | `14,489` |
| `Q25ResidualConclusionDispatchData/` (304 files, tree hash) | `3c57ff993f217b6df9ece1d6067b91a0ff2bc7fdfa316766a6566f611e7e6c71` | `3,969,686` |
| `2026-07-17-c151-residual-conclusion-dispatch-generator.py` | `1af4f75f0c6653f2813020336cd9eb5b176849d362c9cff1f3d8f4a00e16e357` | `6,185` |

The tree hash follows the generators' `tree_sha256` convention: sorted relative paths, each with a
four-byte path length, the path, an eight-byte content length, and the contents. The axiom profile
of `f2_card_globalLegalPairs_ge_32`, `indexed_f2_card_legalOrbitSet_ge_32`, and
`normalized_card_legalOrbitSet_ge_32` is `[propext, Classical.choice, Quot.sound]` with no
`sorryAx`.

The `Q25MinimumClassification.lean` hash above is the state at this date. C331 later factored the
two normalization steps out of these proofs so the exhaustion lift could reuse them; all three
statements above are unchanged and their axiom profile is unchanged. The current hash is in
§ "Semantic equality-orbit exhaustion".

What this does not certify: that `32` is attained, or that the rows attaining it are exactly the
five certified orbits. This is a lower bound on every semantic exceptional-profile arc and nothing
more.

## Exhaustion design (2026-07-18)

Exhaustion (step 6) runs through a class-level strict-bound layer proving
`33 ≤ (maskOrbitSet allowed).card` for the `1,184` non-minimizer classes, then a conclusion layer
reusing the existing dispatch payloads at that threshold. It is delivered in
§ "Equality-orbit exhaustion".

The design is fixed by what is already committed, and needs no change to any frozen checker core:

- `RowCompositionCertificate` pins only its `card_le` field at `32`; `fresh`, `secants`, and
  `carrier` are threshold-free, and `toReflectedMaskCertificate` derives soundness from those three
  alone. A downstream threshold-generic copy of `card_legalOrbitSet_ge_32` therefore reuses every
  committed class certificate at `33` against a fresh `decide` on the same literal mask. Do not edit
  `Q25MinimumMask.lean` to generalize it in place: that invalidates the whole generated closure.
- For the five minimizer classes the transport itself supplies the membership. `TransportValid`
  yields `(rowConfig b p.c).map (residualEmbedding p.y p.z _ _) = p.canonicalConfig`, and
  `ResidualParameter` is exactly a pair of coordinates with nonzero imaginary part, so
  `⟨⟨p.y, _⟩, ⟨p.z, _⟩⟩` witnesses `ResidualMapsTo`. Each `minimumRow####` is literally a `rowConfig`
  of its canonical pair, so a payload naming that pair lands on the representative definitionally.

The resulting per-row terminal is a disjunction,
`33 ≤ (legalOrbitSet (rowConfig b c)).card ∨ IsMinimumResidualClass (rowConfig b c)`, which closes
exhaustion against `isMinimumResidualClass_iff_mem_minimumOrbitUnion`.

### Exhaustion bridge (2026-07-18)

`Q25ExhaustionBridge.lean` carries that design as kernel-checked lemmas, so what remains for
exhaustion is generated bulk rather than open mathematics.

| Terminal | Statement |
|---|---|
| `card_legalOrbitSet_ge_of_sound` | sound mask bits inject into the legal set at a free threshold `n` |
| `ValidRowPayload.residualMapsTo_canonical` | a checked transport is a residual-action element, so its row maps to the canonical representative |
| `isMinimumResidualClass_of_transport` | a payload naming one of the five representatives places its row in that class |
| `mem_minimumOrbitUnion_of_card_eq_32` | the per-row disjunction plus `card = 32` yields membership in the `1600`-element union |

Replay, from `/home/tavis/src/othello/lean`:

```sh
scripts/lean-build-queue.py run RelativeConicArcs.Q25ExhaustionBridge \
  --profile single --threads 1 --cores 20-23
```

Exit status `0` at `0:08.59` wall and `3,403,736 kB` peak RSS
(`run-20260718-235047-fa24d2d4`), followed by a passing trace-only aggregate gate. Source SHA-256
`70ddc85cdbec74538b8ac859ad3de72451affb3fc0be089b8fadd31ecd197bbc`, `4,198` bytes. The axiom profile
of all four terminals is `[propext, Classical.choice, Quot.sound]` with no `sorryAx`.

The module contains no `decide` and no generated data; it states the reductions only. The two
generated layers it feeds are recorded in the next section.

## Equality-orbit exhaustion (2026-07-19)

Exhaustion is checked. Every normalized row attaining `32` lies in the `1600`-element union of the
five certified minimizer orbits, so within the normalized-row domain `32` is the exact minimum and
the five orbits are the complete set of minimizers.

| Module | Terminal | Statement |
|---|---|---|
| `Q25Exhaustion.lean` | `mem_minimumOrbitUnion_of_normalized_card_eq_32` | a normalized row with `card = 32` lies in `minimumOrbitUnion` |
| `Q25Exhaustion.lean` | `card_ge_33_of_not_mem_minimumOrbitUnion` | a normalized row outside the union carries at least `33` |
| `Q25ExhaustionDispatchData/All.lean` | `concludeNormalizedRowExhaustion` | the per-row disjunction for all `46,056` normalized rows |

### Two measured simplifications

The route in § "Exhaustion route" projected a per-row strict class-link tree mirroring the committed
`L_*` modules. That layer is unnecessary, and both facts were established by probe rather than
assumed.

After `fin_cases` the payload appears as an inlined structure literal, and that literal's
`.canonicalConfig` is definitionally the class triple — which is exactly what the committed
`_canonicalClassLink` theorems prove by `rfl`. So `exact` unifies the class-level bound against the
per-row goal with no intermediate theorem, and the non-minimizer branch cites
`Q25RowCompositionStrictData.class####LegalOrbitSet_card_ge_33` directly. A `rewrite` cannot do
this: it needs a syntactic occurrence of the named payload constant, which `fin_cases` has already
consumed. That rewrite failure is what identified the definitional route.

The same defeq removes the minimizer branch's dependency: plain `rfl` discharges
`p.canonicalConfig = minimumRow####`, because each `minimumRow####` is literally the `rowConfig` of
its canonical pair. The exhaustion tree therefore imports only the committed dispatch payloads, the
new strict-class layer, and `Q25ExhaustionBridge` — not the `7,044`-record class-link tree.

Avoided cost: `1,036` modules and `7,044` records that would have elaborated at about `9` seconds
per leaf, against a measured `4.5` seconds per conclusion leaf for the route taken.

### Layer shapes and branch accounting

`Q25RowCompositionStrictData` emits, for each of the `1,184` non-minimizer classes,

```lean
theorem class####LegalOrbitSet_card_ge_33 :
    33 ≤ (legalOrbitSet (normalizedConfig class####A class####B class####C)).card :=
  Q25ExhaustionBridge.card_legalOrbitSet_ge_of_sound
    (normalizedConfig_isConjInvariant class####A class####B class####C)
    class####ReflectedMaskCertificate.sound
    (by decide)
```

reusing each committed certificate's threshold-free `sound` field against a fresh `decide` on the
same literal mask. `Q25MinimumMask.lean` and `Q25RowCompositionData/` are untouched, so the
generated `≥ 32` closure remains valid.

The conclusion tree's branches partition the rows exactly:

| Branch | Rows | Discharge |
|---|---|---|
| bad payload | `39,012` | `BadRowPayload.not_rawCap` contradicts the assumed `RawCap` |
| valid, non-minimizer class | `7,020` | strict class bound transported by `source_card_ge_of_canonical` |
| valid, minimizer class | `24` | `isMinimumResidualClass_of_transport` with `rfl` |
| total | `46,056` | matches the declared row count across all `1,071` leaves |

The `24` minimizer rows split `3,6,6,3,6` over classes `65,267,445,772,1002`, matching the certified
orbit sizes `200,400,400,200,400` and the stabilizer orders `2,1,1,2,1`. This is the C150 scout's
slice-intersection identity — size-`200` classes meet the orbit-`5` slice in `3` arcs and size-`400`
classes in `6` — reproduced here from independent sources: the row counts come from the cover CSV
via the generator, the orbit sizes from the orbit–stabilizer theorems. It is a consistency check on
the residual layer, not a new fact.

### Evidence bundle

Regeneration check, from `/home/tavis/src/othello` — regenerates all three trees into a temporary
location and compares file sets and contents, leaving the worktree unchanged:

```sh
python3 notes/2026-07-18-c151-exhaustion-check.py \
  --csv /home/tavis/.cache/c151-residual-cover.csv
```

All three trees verify byte-identical to regeneration. The checker is deliberately a separate script
rather than a `--check` mode on the generators: each generated header embeds its own generator's
SHA-256, so editing a generator changes that hash and invalidates every file it produced, forcing a
full re-elaboration for a comment-only change.

Regeneration, from `/home/tavis/src/othello`:

```sh
python3 notes/2026-07-18-c151-strict-class-bound-generator.py \
  --write-lean-modules lean/RelativeConicArcs/Q25RowCompositionStrictData
python3 notes/2026-07-18-c151-exhaustion-conclusion-generator.py \
  --csv /home/tavis/.cache/c151-residual-cover.csv \
  --write-lean-modules lean/RelativeConicArcs/Q25ExhaustionConclusionData
python3 notes/2026-07-18-c151-exhaustion-dispatch-generator.py \
  --csv /home/tavis/.cache/c151-residual-cover.csv \
  --write-lean-modules lean/RelativeConicArcs/Q25ExhaustionDispatchData
```

Both the strict-bound generator and the conclusion generator fail loudly on drift: the minimizer set
parsed from the tracked masks must be exactly `{65,267,445,772,1002}`, no class may fall below the
certified `32`, and every valid row must link to a class carrying a strict bound.

| Artifact | SHA-256 | Bytes |
|---|---|---|
| `2026-07-18-c151-strict-class-bound-generator.py` | `ae3000367fb9ddc8a3f8e9d23a42af768259428444563d1620e281a4d2244e56` | `7,933` |
| `2026-07-18-c151-exhaustion-conclusion-generator.py` | `c11d9ad4b6a684cf1a89b398e8ed41dfd4dbd233f49d7b6d93ef073ba600fef0` | `9,804` |
| `2026-07-18-c151-exhaustion-dispatch-generator.py` | `b6781ba3803d3245c2f1b7920142b60917d0220aae4274b8aa1e580104091965` | `6,504` |
| `2026-07-18-c151-exhaustion-check.py` | `f6fb32389f3495ad8e864e9e450ae719d07f4f5a80c990cb0e867e9a08a76b04` | `5,027` |
| `Q25Exhaustion.lean` | `258c76b53b9978ebcddf707648331bfaa1dda989cbca496fd469441318a1662e` | `1,932` |
| `Gates/AlternateOrbitRepairQ25Minimum.lean` | `157659964712d38b98b8747d30e21550f906cdf1a45b3de87c1f2b8ae216ee6b` | `817` |
| `Q25RowCompositionStrictData/` (239 files, tree hash) | `06c7a32664558a087c4dddc7da22507b9bba8b7817f607edd7a1384a7607ba5c` | `601,684` |
| `Q25ExhaustionConclusionData/` (1,375 files, tree hash) | `6618d8fb99cdf5eea4a056298afbc0a1640c751c8a484ba0540c78997669f376` | `5,555,347` |
| `Q25ExhaustionDispatchData/` (304 files, tree hash) | `0cd8384bcb4d5ae48453fa24729713adfdf2704acdba8d3a6e4f44a4c45dcea5` | `4,133,357` |

Load-bearing inputs: the canonical cover CSV
`62aa26c98deb98cb786fa1b21957b91ec16b1e2bd2a6319129c31449eb0effe3`, which is an untracked cache, and
the mask stream parsed from the tracked composition sources, digest
`7b81e34650fd7f1607332cd6845a56e477a01e80b832dab06fbfcbcc0cbd55e0`. The tree hashes follow the
generators' `tree_sha256` convention: sorted relative paths, each with a four-byte path length, the
path, an eight-byte content length, and the contents.

### Build measurements

Replay, from `/home/tavis/src/othello/lean`:

```sh
scripts/lean-build-queue.py run \
  RelativeConicArcs.Q25RowCompositionStrictData.All \
  RelativeConicArcs.Q25ExhaustionConclusionData.All \
  RelativeConicArcs.Q25ExhaustionDispatchData.All \
  RelativeConicArcs.Q25Exhaustion \
  RelativeConicArcs.Gates.AlternateOrbitRepairQ25Minimum \
  --profile single --threads 1 --cores 20-23
```

One Lean worker on cores `20-23` with `choom -n 1000`, all exit status `0`, each run followed by a
passing trace-only aggregate gate. First build of the three trees
(`run-20260719-004939-a0269230`):

| Target | Wall | Peak RSS |
|---|---|---|
| `Q25RowCompositionStrictData.All` | `15:09.37` | `3,637,608 kB` |
| `Q25ExhaustionConclusionData.All` | `1:10:22` | `3,912,512 kB` |
| `Q25ExhaustionDispatchData.All` | `31:38.18` | `4,033,664 kB` |

Total first build `1:57:09`. The terminal and gate are cheap against the warm tree:
`Q25Exhaustion` `0:10.35` at `3,922,432 kB` (`run-20260719-024843-88b63519`) and
`Gates.AlternateOrbitRepairQ25Minimum` `0:16.37` at `4,142,324 kB`
(`run-20260719-025018-2817cf83`). A following exact-target run reports all five trace-current
(`run-20260719-025106-96ebe470`).

This is the measured cost C319 is gated on. It is serial because no measured profile covers roughly
`3.4` GiB per worker; profiles are owned by the `build-sys` lane and were not modified here.

A forbidden-token scan over the new sources is clean. The axiom profile of
`mem_minimumOrbitUnion_of_normalized_card_eq_32`, `card_ge_33_of_not_mem_minimumOrbitUnion`,
`concludeNormalizedRowExhaustion`, `concludeExhB_058`, `concludeExhR_058_C_159_208`,
`class0000LegalOrbitSet_card_ge_33`, and `class1188LegalOrbitSet_card_ge_33` is
`[propext, Classical.choice, Quot.sound]` with no `sorryAx`.

### What this does not certify

Exhaustion is proved for normalized rows, not yet for semantic arcs. The `≥ 32` bound was carried to
every invariant eight-arc in `PG(2,25)` with exactly two fixed points by
`f2_card_globalLegalPairs_ge_32`; the matching lift of *exhaustion* — that every semantic arc
attaining `32` normalizes into the orbit union — is not stated. Its ingredients exist
(`card_legalOrbitSet_liftMapIdx` and `card_legalOrbitSet_residual` move legal-orbit cardinality
along both normalizations in the required direction), so this is a stating step rather than open
mathematics, but until it lands the complete extremal classification remains a normalized-row
statement.

That gap is closed by C331; see § "Semantic equality-orbit exhaustion". The mask-cardinality and
cover-CSV caveats in the paragraph below are unaffected and still apply.

The mask cardinality remains a lower bound on the legal count rather than the exact count, except at
the five rows where equality is separately checked; exhaustion needs only the bound. The cover CSV
is an untracked cache, so the tracked evidence is the generated Lean trees and the parsed mask
stream, not the CSV.

## Semantic equality-orbit exhaustion (2026-07-19)

**C331.** Exhaustion is lifted to semantic arcs. Every invariant eight-arc in `PG(2,25)` with
exactly two fixed points whose semantic legal-pair count is `32` is carried by a base-field
collineation into the `1600`-element union of the five certified minimizer orbits. With the lower
bound already lifted by `f2_card_globalLegalPairs_ge_32`, `32` is the exact **semantic** minimum and
the five orbits are the complete extremal set, modulo the boundary recorded below.

| Module | Terminal | Statement |
|---|---|---|
| `Q25SemanticExhaustion.lean` | `f2_normalizes_into_minimumOrbitUnion` | an invariant eight-arc attaining `32` has a base normalization landing in `minimumOrbitUnion` |
| `Q25SemanticExhaustion.lean` | `f2_card_globalLegalPairs_ge_33_of_not_normalizing` | the contrapositive: an arc no base normalization of which lands in the union carries at least `33` |
| `Q25SemanticExhaustion.lean` | `indexed_exists_base_normalization_mem_minimumOrbitUnion` | the same conclusion for an indexed invariant eight-cap |
| `Q25SemanticExhaustion.lean` | `normalized_mem_minimumOrbitUnion_of_card_eq_32` | a normalized configuration attaining `32` lies in the union, with no surviving map |
| `Q25SemanticExhaustion.lean` | `card_legalOrbitSet_eq_32_of_globalLegalPairs_eq_32` | a semantic count of `32` pins the indexed count to `32` |

### Three facts carry the lift, and none is new mathematics

**The normalization steps are threshold-free, so they run in both directions.** The C151 lower-bound
proof performed both projective normalizations inline. They are now stated separately in
`Q25MinimumClassification.lean` as `exists_base_normalizedConfig` (a base-field collineation carries
an indexed invariant eight-cap onto a `normalizedConfig`) and `exists_residual_rowConfig` (a member
of the order-`400` residual action carries that configuration onto a canonical row of the orbit-`5`
slice). Neither mentions `32`. `card_legalOrbitSet_liftMapIdx` and `card_legalOrbitSet_residual` are
*equalities* of legal-orbit cardinality, so the same two steps that carried `≥ 32` up to a semantic
arc carry `card = 32` down to a normalized row, where
`mem_minimumOrbitUnion_of_normalized_card_eq_32` applies. The reported C151 terminals keep their
statements verbatim and are re-proved from the extracted steps.

**The semantic count is pinned by a sandwich, so no new bridge is needed.** The semantic theorem
counts `globalLegalPairs`, the exhaustion tree counts `legalOrbitSet`, and only an *injection*
`legalOrbitSet ↪ globalLegalPairs` was ever available. That suffices: it gives
`legalOrbitSet.card ≤ 32` from the hypothesis, `indexed_f2_card_legalOrbitSet_ge_32` gives
`32 ≤ legalOrbitSet.card`, and antisymmetry closes it. Surjectivity of that injection is never
needed and is not proved; in the equality case it follows, but only there.

**The residual step is absorbed, so only the base collineation survives into the statement.**
`minimumOrbitUnion` is a union of five full residual orbits, hence invariant under the order-`400`
action. `mem_minimumOrbitUnion_of_residualMapsTo` records that: a set mapping onto a member is a
member. So `normalized_mem_minimumOrbitUnion_of_card_eq_32` concludes membership for the
configuration itself with no existential, and the semantic statement quantifies over one map rather
than two. These three transport lemmas are placed in the new module rather than in
`Q25ResidualEquality.lean` because that module is imported by the generated exhaustion trees, whose
re-elaboration is measured in hours; the Lean guide's freeze-the-core invariant applies directly.

### No new generated bulk

C331 adds no certificates, no `decide`, and no generated data. `Q25RowCompositionStrictData/`,
`Q25ExhaustionConclusionData/`, `Q25ExhaustionDispatchData/`, and every C151 generator are untouched,
so the regeneration check in § "Equality-orbit exhaustion" still verifies the tracked trees
byte-identically and its recorded hashes stand.

### Evidence bundle

Replay, from `/home/tavis/src/othello/lean`:

```sh
scripts/lean-build-queue.py run \
  RelativeConicArcs.Q25MinimumClassification \
  RelativeConicArcs.Q25SemanticExhaustion \
  RelativeConicArcs.Gates.AlternateOrbitRepairQ25Minimum \
  --profile single --threads 1 --cores 20-23
```

One Lean worker on cores `20-23` with `choom -n 1000`, all exit status `0`, each run followed by a
passing trace-only aggregate gate. `Q25MinimumClassification` `0:12.16` wall at `4,140,768 kB` peak
RSS (`run-20260719-032358-dbdcc0e1`), against the `0:11.23` at `4,139,416 kB` recorded for the
module before the refactor; `Q25SemanticExhaustion` `0:12.87` at `4,174,396 kB` and
`Gates.AlternateOrbitRepairQ25Minimum` `0:10.97` at `4,156,388 kB`
(`run-20260719-032529-07b74668`). A following exact-target run reports all three trace-current
(`run-20260719-032705-9c689b73`). These are rebuild costs against the warm C151 trees; the trees
themselves are unchanged and were not rebuilt.

| Artifact | SHA-256 | Bytes |
|---|---|---|
| `Q25SemanticExhaustion.lean` | `bb2023496881ef3241a86d638efa54f70631178c08c2cb9b10fb8b6ed8ff716d` | `8,707` |
| `Q25MinimumClassification.lean` | `0d10c556513d6dcd22e7ebbd9432b0b3f8166c5bb20e1b51386e4c2f1d72d864` | `19,071` |
| `Gates/AlternateOrbitRepairQ25Minimum.lean` | `2146cd08d6a9d5a5b550fea8e4193840db79758ceda5c18160f37e97b8ce4e4a` | `1,286` |

A forbidden-token scan over the three sources is clean. The axiom profile of the five C331 terminals
above, of `mem_minimumOrbitUnion_of_residualMapsTo`, of the refactored C151 terminals
`f2_card_globalLegalPairs_ge_32`, `indexed_f2_card_legalOrbitSet_ge_32`, and
`normalized_card_legalOrbitSet_ge_32`, of the two extracted normalization steps, and of
`mem_minimumOrbitUnion_of_normalized_card_eq_32` is `[propext, Classical.choice, Quot.sound]` with no
`sorryAx`, `native_decide`, or `Lean.ofReduceBool` — twelve declarations audited, all identical.

The cross-check available here is a regression one rather than an independent recomputation, and it
is the relevant one: this is a proof-only change over frozen data. The three reported C151 terminals
keep their statements character-for-character, are re-proved from the extracted steps rather than
from their former inline copies, and rebuild green at the previously measured cost with an unchanged
axiom profile. No independent second implementation of the normalization exists, and none is claimed.

### What this does not certify

The classification is stated up to normalization, not as a list. `f2_normalizes_into_minimumOrbitUnion`
asserts that *some* base-field collineation lands the arc in the union; it does not claim that
collineation is unique, does not enumerate the semantic arcs attaining `32`, and does not count them.

The hypotheses are exactly the exceptional profile: an invariant eight-arc in `PG(2,25)` with
exactly two fixed points. Nothing is claimed for other fixed-point counts, other arc sizes, other
`q`, or non-invariant arcs.

The injection from indexed legal orbits into semantic legal pairs is used only as an inequality.
Its surjectivity is not proved in general.

Every C151 boundary still applies unchanged: the mask cardinality remains a lower bound on the legal
count except at the five rows where equality is separately checked, and the cover CSV remains an
untracked cache, so the tracked evidence is the generated Lean trees and the parsed mask stream.
