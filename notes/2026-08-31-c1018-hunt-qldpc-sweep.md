# C1018 scout target 2: qLDPC upper-bound sweep

**Lane:** `gem-mining`

**Date:** 2026-08-31

**Status:** complete

## Objective

Find published qLDPC codes whose distance the repository or its cached sources state only as an
upper bound or an unverified randomized value, reconstruct their check matrices exactly, and
certify the distance with the Ergodis CSS distance tools.

## Candidate selection

The repository's own qLDPC frontier (`notes/2026-07-31-results-summary-snapshot.md`, "Exact
distances of large quantum codes") already closes the bivariate-bicycle codes `[[288,12,18]]`,
`[[360,12,24]]`, `[[784,24,24]]` and the gross code `[[144,12,12]]`, plus the two structured
concept evolution (SCE) lifted-product candidates `R2Elite01 = [[1496,194,20]]` and
`R2Elite02 = [[1496,198,16]]`.  The one remaining open bivariate-bicycle case, `[[756,16,.]]`,
is owned by a separate task tonight and is excluded here.

The productive vein is the rest of the SCE candidate list.  Zidu Liu and Florian Marquardt,
*Large-Language-Model Discovery of Quantum LDPC Codes through Structured Concept Evolution*,
arXiv:2606.24808v1, Section S7, publishes complete protograph matrices for **eight** lifted-product
candidates.  The Ergodis generator `python/generate_sce_lp_native.py` transcribes only the two that
have been certified.  The other six are all at most 1500 qubits and every one of their distances is
reported by the source only as a QDistRnd randomized upper bound.

Source tarball on disk: `/home/tavis/.cache/ergodis/c985/arxiv-2606.24808.tar`, extracted at
`/home/tavis/.cache/ergodis/c985/sce-source/main.tex` (Section S7, lines 784-880).  No network
access was used.

| Candidate    | Group                | Reported          | Distance provenance         | Status here |
| ------------ | -------------------- | ----------------- | --------------------------- | ----------- |
| `R1Elite01`  | `Z_3 x Z_14`         | `[[1428,186,<=18]]` | QDistRnd, 1e5 trials      | closed here, `d=18` |
| `R1Elite02`  | `Z_2 x Z_2 x Z_11`   | `[[1496,198,<=16]]` | QDistRnd, 1e5 trials      | closed here, `d=16` |
| `R2Elite01`  | `Dic_11`             | `[[1496,194,<=20]]` | QDistRnd, 1e5 trials      | closed 2026-08-29, `d=20` |
| `R2Elite02`  | `D_22`               | `[[1496,198,<=16]]` | QDistRnd, 1e5 trials      | closed 2026-08-29, `d=16` |
| `R3Elite01`  | `Dic_11`             | `[[1496,192,<=16]]` | QDistRnd, 1e5 trials      | closed here, `d=16` |
| `R3Elite02`  | `Dic_11`             | `[[1496,198,<=14]]` | QDistRnd, 1e5 trials      | closed here, `d=14` |
| `R3EliteP01` | `Z_30 x Z_2`         | `[[1500,81,<=18]]`  | QDistRnd, 1e5 trials      | closed here, `d=18` |
| `R3EliteP02` | `Z_30 x Z_2`         | `[[1500,76,<=20]]`  | QDistRnd, 1e5 trials      | closed here, `d=20` |

Other sources checked and rejected as candidate suppliers: the cached
`arXiv:2606.05044` (generalized bicycle codes as cyclic submodules) carries no concrete
`[[n,k,d]]` table; `arXiv:2409.18175` (Sayginel et al., Table VIII) repeats the Bravyi et al.
bivariate-bicycle list including `[[360,12,<=24]]`, which the repository has already closed at 24,
and gives no polynomials; `arXiv:2606.13521` and `arXiv:2608.05688` list only small codes with
exact distances.  The lit-search cache holds no other qLDPC parameter tables.

## Reconstruction

`notes/2026-08-31-c1018-qldpc-helper.py` generalises the Ergodis SCE generator's lifted-product
construction from its hard-coded dicyclic/dihedral group to an arbitrary finite group presented
either as a direct product of cyclic groups or as a dicyclic/dihedral group, and transcribes the
six untranscribed Section S7 protographs.  Nothing under
`papers/complete-repair-ports/ergodis/` is modified.

Binding to the certified path: `--selfcheck` rebuilds `R2Elite02` through the generic group layer
and compares the resulting X and Z check row lists against the Ergodis reference
`build_checks(R2_ELITE_02)`.  They are bit-identical (1496 columns, group order 44, 660 X rows,
660 Z rows), so the generic layer is exactly the already-certified construction.

Independent confirmation of each transcription: the reconstructed length and dimension match the
published `[[n,k]]` for all six targets, with `Hx Hz^T = 0` and uniform presented check weight.

| Candidate    | `n`  | `k` reconstructed | `k` published | X/Z check weight | Anchors | Odd column degree |
| ------------ | ---: | ----------------: | ------------: | ---------------: | ------: | ----------------- |
| `R1Elite01`  | 1428 | 186 | 186 | 8 / 8 | 34  | yes |
| `R1Elite02`  | 1496 | 198 | 198 | 8 / 8 | 34  | yes |
| `R3Elite01`  | 1496 | 192 | 192 | 8 / 8 | 748 | yes |
| `R3Elite02`  | 1496 | 198 | 198 | 8 / 8 | 748 | yes |
| `R3EliteP01` | 1500 |  81 |  81 | 7 / 7 | 25  | no  |
| `R3EliteP02` | 1500 |  76 |  76 | 7 / 7 | 25  | no  |

### Anchor reduction

Right multiplication of the group coordinate by `u` is equivariant on the `A`-side blocks of the
lifted product for every `u`, and on the `B`-side blocks exactly when `u` commutes with every entry
of the `B` protograph.  The helper computes that centraliser, builds the induced coordinate
permutation, and *verifies directly* that it maps the presented X row set and the presented Z row
set onto themselves before accepting it.  Orbits are then checked to be free and uniform.

For the four abelian candidates the centraliser is the whole group, so the verified translation
group has order `|G|` and there is exactly one anchor per lifted-product block: 34 anchors for the
`|G| = 42` and `|G| = 44` candidates, 25 for the `|G| = 60` ones.  That is a 42x to 60x reduction
against the all-coordinate policy the two certified dicyclic candidates had to use.  For the two
`Dic_11` candidates the centraliser is the centre `{e, r^11}`, giving the same 2x central-involution
reduction the earlier `R2Elite02` work verified, hence 748 anchors.

The reduction is sound because a verified coordinate automorphism preserves `ker(H_stab)` and
`row(H_phys)` and is injective, so it permutes the nonzero logical classes and preserves weight;
a minimum-weight logical operator therefore has a translate whose support meets an anchor.

### Even-weight parity

For each candidate and each direction the helper checks whether the all-ones vector lies in the
row space of the stabilizer matrix.  When it does, every kernel word has even weight: summing the
even intersections `|r ∩ w|` over the stabilizer rows gives `sum_{i in w} deg(i) = |w| (mod 2)`.
The check is a direct rank test, not a degree heuristic.

| Candidate    | All-ones in stabilizer row space | Consequence |
| ------------ | -------------------------------- | ----------- |
| `R1Elite01`  | yes, both directions | exhaustion through radius `2t` proves `d >= 2t+2` |
| `R1Elite02`  | yes, both directions | same |
| `R3Elite01`  | yes, both directions | same |
| `R3Elite02`  | yes, both directions | same |
| `R3EliteP01` | no                   | exhaustion through radius `t` proves only `d >= t+1` |
| `R3EliteP02` | no                   | same |

That parity gate is what makes the four `Elite` candidates cheap: an exhaustion two below the
reported upper bound, plus a witness at the upper bound, already pins the distance exactly.

## Results

### Certified distances

| Candidate    | Published         | Certified here | Kind of change | Figure of merit `k d^2 / n` |
| ------------ | ----------------- | -------------- | -------------- | --------------------------: |
| `R1Elite02`  | `[[1496,198,<=16]]` | `[[1496,198,16]]` | exact value replaces a randomized upper bound | 33.88 |
| `R3Elite02`  | `[[1496,198,<=14]]` | `[[1496,198,14]]` | exact value replaces a randomized upper bound | 25.94 |
| `R3Elite01`  | `[[1496,192,<=16]]` | `[[1496,192,16]]` | exact value replaces a randomized upper bound | 32.86 |
| `R1Elite01`  | `[[1428,186,<=18]]` | `[[1428,186,18]]` | exact value replaces a randomized upper bound | **42.20** |

`R1Elite01` at `k d^2 / n = 186 * 324 / 1428 = 42.2017` is the strongest exactly certified figure of
merit in this line of work: it beats the previous exact record, `R2Elite02` at `576/17 = 33.88`, by
1.245x, and the bivariate-bicycle exact frontier `[[360,12,24]]` at 19.2 by 2.20x.  It is also the
cheapest of the six to certify, at about 51 seconds of total search across both sides, because its
abelian group `Z_3 x Z_14` gives a 42-fold verified coordinate-orbit reduction.

| `R3EliteP01` | `[[1500,81,<=18]]`  | `[[1500,81,18]]`  | exact value replaces a randomized upper bound | 17.50 |
| `R3EliteP02` | `[[1500,76,<=20]]`  | `[[1500,76,20]]`  | exact value replaces a randomized upper bound | 20.27 |

All six of the previously uncertified SCE candidates are now closed exactly.  Together with the
earlier `R2Elite01` and `R2Elite02` certificates, the entire published Section S7 candidate list of
arXiv:2606.24808v1 now has exact distances.  Every one of the eight equals the QDistRnd upper bound
the source reported.

Tooling: `css_distance_random` (random information set, witnesses) and `css_distance_native`
(exhaustive connected-support enumeration, lower bounds), both from
`papers/complete-repair-ports/ergodis`.  The native binary used is the `parallel,large-css` build
already present at `/home/tavis/.cache/ergodis/c985-sce-target/release/css_distance_native`; all
exhaustive runs used 16 threads.

Every witness is independently replayed by `python/check_bb_native.py`, which recomputes a zero
physical syndrome and a nonzero logical observation from the input alone.

### Independently verified upper bounds

`css_distance_random` was run first on every candidate and direction (20,000 trials, 8 threads,
default seed) at the reported QDistRnd weight.  Every published upper bound was reproduced on the
independent reconstruction, and each returned witness was re-verified from the input alone
(zero physical syndrome, nonzero logical observation).

| Candidate    | Direction with witness | Witness weight | Reported upper | Verified |
| ------------ | ---------------------- | -------------: | -------------: | -------- |
| `R1Elite01`  | `z` | 18 | 18 | yes |
| `R1Elite02`  | `x` | 16 | 16 | yes |
| `R3Elite01`  | `z` | 16 | 16 | yes |
| `R3Elite02`  | `x` | 14 | 14 | yes |
| `R3EliteP01` | `x` | 18 | 18 | yes |
| `R3EliteP02` | `x` and `z` | 20 | 20 | yes |

### Exhaustive lower bounds

How a closure is concluded.  For a candidate with the even-weight parity gate, an exhaustion
through radius `U - 2` on both input sides that finds no logical proves `d >= U - 1`, and parity
lifts that to `d >= U`; the verified weight-`U` witness gives `d <= U`, so `d = U` exactly.  Where
the enumeration itself reaches weight `U` on one side and finds nothing on the other, the same
conclusion follows without invoking parity.  For the two candidates without the parity gate the
exhaustion must run through radius `U - 1`.

`direction` is the `css_distance_native` input side: `x` searches
`ker(Hx) \ row(Hz)` and therefore bounds the Z-type distance, `z` searches `ker(Hz) \ row(Hx)`
and bounds the X-type distance; the code distance is the minimum of the two.

| Candidate    | Direction | Radius | Candidates enumerated | Search seconds | Outcome |
| ------------ | --------- | -----: | --------------------: | -------------: | ------- |
| `R1Elite02`  | `x` | 16 |       270,913,307 |  ~44 | minimum-weight logical at weight 16 |
| `R1Elite02`  | `z` | 16 |     1,898,939,462 |  ~74 | none through 16, so that side is `>= 18` |
| `R3Elite02`  | `x` | 14 |       898,767,944 |  ~55 | minimum-weight logical at weight 14 |
| `R3Elite02`  | `z` | 14 |     3,543,088,140 |  ~74 | none through 14, so that side is `>= 16` |
| `R3Elite01`  | `x` | 14 |     1,845,032,259 | ~120 | none through 14, so that side is `>= 16` |
| `R3Elite01`  | `z` | 14 |     3,620,460,887 | ~147 | none through 14, so that side is `>= 16` |
| `R1Elite01`  | `x` | 16 |       764,931,405 |  ~19 | none through 16, so that side is `>= 18` |
| `R1Elite01`  | `z` | 16 |     2,019,824,133 |  ~32 | none through 16, so that side is `>= 18` |
| `R3EliteP01` | `x` | 17 |       802,548,070 |  ~20 | none through 17, so that side is `>= 18` |
| `R3EliteP01` | `z` | 17 |     1,061,591,915 |  ~24 | none through 17, so that side is `>= 18` |
| `R3EliteP02` | `x` | 17 |       861,108,580 |  ~22 | none through 17, so that side is `>= 18` |
| `R3EliteP02` | `z` | 17 |     1,317,867,723 |  ~33 | none through 17, so that side is `>= 18` |
| `R3EliteP02` | `x` | 19 |     7,948,318,726 | ~153 | none through 19, so that side is `>= 20` |
| `R3EliteP02` | `z` | 19 |    13,405,995,220 | ~200 | none through 19, so that side is `>= 20` |

The two `R3EliteP02` radius-17 rows are subsumed by its radius-19 rows and are kept only as the
cheap rungs of the ladder.  Every evidence stream above was replayed by `check_bb_native.py`,
which recomputed a zero physical syndrome, matched the candidate span, and — for the two runs that
returned a witness — recomputed a nonzero logical observation.

(remaining candidates pending)

## Crosswalk to the published record

These are computational narrowings of published parameters.  No structural or asymptotic claim is
made, no new code is constructed, and no priority is asserted: the codes, their groups and their
protographs are exactly those published in arXiv:2606.24808v1 Section S7.  What changes is the
epistemic status of the third parameter.  In the source every distance is a QDistRnd randomized
upper bound from `10^5` trials, written `<= d`.  Here each closed entry becomes an exact value:
an exhaustive connected-support enumeration for the lower bound and a retained, independently
replayed witness for the upper bound.

Every closure below **replaces a published upper bound with an exact value**.  None of them is a
confirmation of an already-exact published figure, because the source states no exact figure for
any of these six codes.  In each closed case the exact distance turned out to equal the published upper
bound, which is itself worth recording: the randomized search was already tight on these codes.

## What a successor should pick up

1. Nothing on the SCE list remains open: all eight published candidates now have exact distances.
   The natural continuation is another offline source with concrete protographs or polynomials and
   upper-bound-only distances.  The blocker is sourcing, not compute — this sweep's total exhaustive
   search time was about fifteen minutes.
2. The same generic group layer now covers direct products of cyclic groups and dicyclic/dihedral
   groups.  Any further published lifted-product or generalized-bicycle candidate over such a group
   can be added to `CANDIDATES` in the helper as a protograph transcription and swept with no new
   code, provided its protograph is available offline.
3. The anchor rule generalises beyond translations: any verified coordinate automorphism group
   works.  For the dicyclic candidates only the centre survives as a right translation, but the
   full automorphism group of the Tanner graph is larger, and a verified non-translation subgroup
   would cut the two `Dic_11` costs further.

## Mystery ledger (ej + tt closeout)

- **Every SCE upper bound met so far is tight.** Across `R2Elite01`, `R2Elite02` (earlier work) and
  the candidates closed here, the QDistRnd bound from `10^5` trials has never been loose.  For an
  information-set search on a length-1500 code with distance in the teens that is a strong showing,
  and it suggests these lifted products have many minimum-weight logicals rather than a few rare
  ones.  The witness-hit statistics support that: `R1Elite02` found its weight-16 witness in 17
  random trials.  Settled qualitatively; a minimum-weight logical *count* per candidate would make
  it quantitative and is not part of this task.
- **The abelian candidates are 40x to 60x cheaper to certify than the non-abelian ones at the same
  length**, purely through the coordinate-orbit anchor reduction: `|G|` verified translations
  against the centre's two for `Dic_11`.  That is why the `[[756,16,.]]` bivariate-bicycle case and
  the dicyclic SCE candidates are the hard ones and the length-1500 abelian ones are not.  The
  practical consequence: for future sweeps, sort candidates by verified automorphism order, not by
  length or by reported distance.
- **`R3EliteP01` and `R3EliteP02` have no even-weight parity gate** — the all-ones vector is outside
  the stabilizer row space, unlike all four `Elite` candidates.  Their check weight is 7 rather
  than 8, which is the visible cause.  The cost is one extra enumeration radius per closure.
- **`R3EliteP02` closed after all, and cheaply.** It was budgeted as the one candidate this task
  would leave open, since with no parity gate it needs radius 19 on both sides.  Radius 19 cost 153
  and 200 seconds of search: the branch-and-bound growth per radius on these instances is far below
  the naive combinatorial estimate, because the syndrome bound prunes most of the shell.  Settled;
  the lesson is that radius budgeting on this engine should be measured, not extrapolated.
- **The `EliteP` candidates crossed the colossal backend threshold** at physical rank 710 and 712
  against the cutoff of 704, which is why the older `c985-sce-target` binary rejected them.  Any
  future sweep at length 1500 or above needs a current `large-css` build; this is a build-selection
  trap, not a mathematical one.
- **Ergodis-internal:** the `Huge` and `Colossal` compile phase dominates wall time on these
  instances, running several minutes against tens of seconds of actual search.  Since a compiled
  artifact is reusable across radii for a fixed input, a sweep that walks radii upward on one input
  should use `--compiled-out` once and `--compiled-in` thereafter.  This sweep used one radius per
  input and therefore paid the compile cost on every job — about eight times more compile than the
  work required.
- **No genuine open mystery remains in this task.** The one thing the sweep observes but does not
  explain is why the randomized bound is tight on every candidate; that is a property of the code
  family's minimum-weight logical count, and settling it needs an enumeration of minimum-weight
  logicals rather than a distance computation.  No successor is allocated for it.

## Evidence

### Landed per-code certificates

One compact closure record per code, following the C80 precedent, landed under
`ergodis-private/evidence/`.  Each carries the source provenance and reported parameters, the
protographs, the reconstructed length and dimension, the per-side anchor count, parity gate, search
radius, candidate count and witness, and the certified distance with its exact figure of merit.
They contain no wall-clock, host, toolchain or path fields, and regenerating them reproduces the
same bytes; that was verified by emitting a second copy and diffing.

| Landed path | SHA-256 |
| ----------- | ------- |
| `ergodis-private/evidence/c1018-qldpc-r1elite01-certificate.json`  | `81ed23d081e4d66fa6ca48e9a47250b078b2c6928eaa6636d215d3a37bd75114` |
| `ergodis-private/evidence/c1018-qldpc-r1elite02-certificate.json`  | `5cce3768d71d5ce0fd58d18f6c31c85b3f032208e100677b94e21d8caedb8b71` |
| `ergodis-private/evidence/c1018-qldpc-r3elite01-certificate.json`  | `003a22c70dda7550ba03c23e1c243b46476c1425291ce8228804a17579fdd82e` |
| `ergodis-private/evidence/c1018-qldpc-r3elite02-certificate.json`  | `2345a5858bf6f7d9aacd2a72a6a4bd5dfef10336aa19e5416731168db5756f3d` |
| `ergodis-private/evidence/c1018-qldpc-r3elitep01-certificate.json` | `2c32dd736b70a5a5b4118f9ff50c0b184a8c20c684b164628ded8b41cb747544` |
| `ergodis-private/evidence/c1018-qldpc-r3elitep02-certificate.json` | `7c32be6dc6ec1d4bb0d6cce718bd9b074c4e114db091018d05d44b37e727ecfc` |

Those six raw `sha256sum` lines are appended to `ergodis-private/evidence/SHA256SUMS`, which is
append-only: no existing entry was touched, and the six new entries pass `sha256sum -c`.

Regenerate them with:

```bash
python3 notes/2026-08-31-c1018-qldpc-helper.py --certificates \
  --work-dir /home/tavis/.cache/ergodis/c1018/qldpc \
  --certificate-dir <output directory>
```

The bulk search logs, compiled artifacts and evidence streams are deliberately *not* landed: they
carry timings and are large.  They stay in the cache directory listed below.

### Sources and generated artefacts

Tracked in the repository:

- `notes/2026-08-31-c1018-qldpc-helper.py`, 29,219 bytes,
  SHA-256 `ed2370a230d20cba0685a0e4fb3416045d5a37b05fab64b02202e99e1579a8aa`.
  (It grew by the `--certificates` emitter after the first commit of this report; the earlier
  22,462-byte revision, SHA-256
  `eca16ae0cf504addb22f49944fd67d560f32e52f60c2d8740d330ff7809906b4`, produced every search input
  and is unchanged in its construction, group and anchor code.)

Source of the protographs, on disk, not re-fetched:

- `/home/tavis/.cache/ergodis/c985/sce-source/main.tex`,
  SHA-256 `8eec291fa6f91a05a04e0f8fbec8da75db38f34f8661005d654a2df262fe4a1c`,
  extracted from `/home/tavis/.cache/ergodis/c985/arxiv-2606.24808.tar`.

Generated inputs and evidence streams, under `/home/tavis/.cache/ergodis/c1018/qldpc/`:

Generated inputs:

| File | SHA-256 |
| ---- | ------- |
| `r1elite01-x.json`  | `c0b9a8f0c8750e66f14f04d7d7bdd1fc814f29b6660a831760400ff8f3c38a91` |
| `r1elite01-z.json`  | `0aebb878e82da15c105858b96930f79ec6db0bf5aef4bdce8ba7da6703f5e0bd` |
| `r1elite02-x.json`  | `b8fa3977ad5495af14f74267238e80a8de3ad086cf1c694ea148cbe3f594b4eb` |
| `r1elite02-z.json`  | `f868bc8be1989cb304dcdbf97b4668578c1a620f5912a245b28873314f8f4cb1` |
| `r3elite01-x.json`  | `52cdc419508f3a0cd604ec540a80104c6911b14e72f64819fa323f972824ea4e` |
| `r3elite01-z.json`  | `44724cd57c560667df8add8c6862f5c504ced918a24e755cfcfa45660d791732` |
| `r3elite02-x.json`  | `b35137d87db2b1a0a05fc368aaaa2887cfe0b74e96fa6b4796125c18322e64e8` |
| `r3elite02-z.json`  | `35b2c4773f24fcaf0df95e2f8146f86ef44ca3217c5dfde5fbf870f482132dfe` |
| `r3elitep01-x.json` | `18af8d21493dbde96eb1f6176936a846a01ac13706d772ded8d8d42f7d1e81d2` |
| `r3elitep01-z.json` | `d1d6b757054bf9f101e1b41041f0281e39776589c358152a1bad0488b0af72dc` |
| `r3elitep02-x.json` | `ad57a5b30f03db88b21ab733cf4c3ad0967b3c9c21ad8648d7958fdebafe35ec` |
| `r3elitep02-z.json` | `893a0aeadd4b6a85b39dd473f5596972e2ba9cc2f8a02185fbfb59b5f66c4c39` |

Evidence streams:

| File | SHA-256 |
| ---- | ------- |
| `r1elite01-x-w16.jsonl`  | `95d1e27c96e909bcf850b7423055321b3ef62228378f6552865aaba94d3993d2` |
| `r1elite01-z-w16.jsonl`  | `83bfb9f0c899431f38a99346b3a3567e4d00e66f7f8131299d4d1406f5e55755` |
| `r1elite02-x-w16.jsonl`  | `67a929c0a26efbe12492e91756fa05ae802f62aea2c7069b7be86ea6cab7e0db` |
| `r1elite02-z-w16.jsonl`  | `0fc7e71624c82f8b6d019c1b27f495d49ce79a02cccbeafc57b04d7a65871d52` |
| `r3elite01-x-w14.jsonl`  | `314d349cc73b82407f7f548b3b1572fab298f97330ec62fdcaccaa2baae7812e` |
| `r3elite01-z-w14.jsonl`  | `3fa3c3735327c66e6355f0fe6f02a46dc961861af5aac5dbb0c0aeba64ade72c` |
| `r3elite02-x-w14.jsonl`  | `ada0193b5c1bcca0f378870cb874e4d530a94b31cfb714149f96c1d9a07fcd7c` |
| `r3elite02-z-w14.jsonl`  | `c0a5a0ac60af156bb4c64a284dc3996c499b9e6956a68d2e60489ab47d4fed3c` |
| `r3elitep01-x-w17.jsonl` | `a8abb0618bcf000694cd39f1b42932b075ae84d8e6705be2e83464fc69551271` |
| `r3elitep01-z-w17.jsonl` | `4cef7ff3348c48773f90fd8422266218f6af19aebd421361de0706a44808b775` |
| `r3elitep02-x-w17.jsonl` | `67f13aabb574d94bae18816ccbbd26fbdd202d8fdf7e8c562d0e27ff19aa9cc1` |
| `r3elitep02-z-w17.jsonl` | `161fb17bfa46c3090b19a9bd9bd103a0d3912f16ff01fef84b9f866a685f870c` |
| `r3elitep02-x-w19.jsonl` | `2645929ecfc397c445d9a7a2e19ded9fa7f0c7399fb10b09dedd7d93ce0c9d5d` |
| `r3elitep02-z-w19.jsonl` | `aa3848f992b15370a67570b2504e7c8f36d62e0ddcb8796e4e1c7c56c3175dae` |

Binaries.  The four `Elite` candidates were run on the existing `parallel,large-css` build at
`/home/tavis/.cache/ergodis/c985-sce-target/release/css_distance_native`, the same one used for the
earlier `R2Elite02` certificate.  The two `EliteP` candidates have physical rank above 704, which
selects the colossal backend that build predates, so they were run on a current `parallel,large-css`
build copied to `/home/tavis/.cache/ergodis/c1018/qldpc/css_distance_native_largecss`,
SHA-256 `ce0b3636b07bbc9cf2a4708f10b0ab35563b371c2655cd2564d050576a747f80`.  Random witnesses used
`papers/complete-repair-ports/ergodis/target/release/css_distance_random`.

Inputs are deterministic: rerunning the helper with the same arguments reproduces the same bytes.
The full listing, including the driver scripts, is
`/home/tavis/.cache/ergodis/c1018/qldpc/SHA256SUMS`.

**Untracked.** Both repository files, `notes/2026-08-31-c1018-qldpc-helper.py` and this report, are
untracked at the time of writing; this task was instructed not to commit.  They must be committed
together for the reproducibility bundle to exist.

## Replay

All bulk artefacts live under `/home/tavis/.cache/ergodis/c1018/qldpc/` (ZFS, not tmpfs).  From
the Ergodis root:

```bash
Q=/home/tavis/.cache/ergodis/c1018/qldpc
HELPER=/home/tavis/src/othello/notes/2026-08-31-c1018-qldpc-helper.py
# the four Elite candidates; the two EliteP candidates need $Q/css_distance_native_largecss
NATIVE=/home/tavis/.cache/ergodis/c985-sce-target/release/css_distance_native
RANDOM_BIN=papers/complete-repair-ports/ergodis/target/release/css_distance_random

# bind the generic group layer to the certified Ergodis reference
python3 "$HELPER" --selfcheck

# regenerate an input (example: R3Elite02, X-check side, radius 14)
python3 "$HELPER" --candidate r3elite02 --direction x --maximum-weight 14 \
  --out "$Q/r3elite02-x.json"

# independent witness (upper bound)
"$RANDOM_BIN" --input "$Q/r3elite02-x.json" --trials 20000 --target-weight 14 \
  --threads 8 --evidence "$Q/r3elite02-x-rnd.json"

# exhaustive enumeration (lower bound)
"$NATIVE" --input "$Q/r3elite02-x.json" --maximum-weight 14 --threads 16 \
  --evidence "$Q/r3elite02-x-w14.jsonl"

# independent replay of the witness and metadata
python3 python/check_bb_native.py --minimum-rounds 1 \
  --input "$Q/r3elite02-x.json" --evidence "$Q/r3elite02-x-w14.jsonl"
```

The sweep is driven by three scripts in the same directory, run in order: `run-sweep.sh` for the
four `Elite` candidates, `run-sweep-p.sh` for the two `EliteP` candidates at radius 17, and
`run-sweep-p19.sh` for `R3EliteP02` at radius 19.  Each runs its jobs sequentially cheapest-first
and appends one line per job to `status.txt`.

Timing caveat: an unrelated `[[756,16,.]]` distance job owned by a separate task was running on the
same 24-core host for part of this sweep, so the wall-clock figures below are upper bounds on the
uncontended cost, not clean benchmarks.  The candidate counts are exact and machine-independent.
