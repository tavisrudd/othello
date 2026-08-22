# C942 final formal/reproducibility cold read

**Commit:** `d35683e81f37acea1fb355f2eb301635b211c37b`

## Verdict

**FAIL on reproducibility; PASS on formal-boundary disclosure and claim accounting.**

The reviewer guide accurately limits the Lean companion, the source-only check, and the captured axiom transcript.  Its primary-paper coverage counts are exact, its Mathlib wording expressly disclaims Mathlib membership, and its links resolve.  However, the registered `hirzebruch-euler-spectrum` evidence bundle is not reproducible at this commit because its checksum manifest contains a stale hash for its tracked script.  This defect does not support `thm:every-cubic`; it affects the conditional framed refinement through `lem:hirzebruch-euler-spectrum`.

**Confidence:** 0.99 (high).  The conclusion comes from the pinned tree, an extracted source-only run, direct claim-map counts, direct checksum verification, and the registered evidence check command.

## Findings

1. **Blocking reproducibility defect: stale evidence checksum.**
   `verification/hirzebruch-euler-spectrum.sha256` records
   `b8b651ea29012ad9df32450e2705d4f53e34ec7127c2d06c5799b352c3f375dd`
   for `hirzebruch_euler_spectrum.py`, while the file at the pinned commit hashes to
   `12a6599dc5f56cfdd828aba60639458ce19a16fb1281aaccc4340ff963d25efa`.
   Running the registry's check command,
   `uv run --with sympy python3 verification/hirzebruch_euler_spectrum.py --check`,
   exits nonzero with `digest mismatch for hirzebruch_euler_spectrum.py`.
   The other two evidence manifests pass `sha256sum -c` completely.  The source-only checker misses this defect because it requires a nonempty manifest path and checks that the file exists, but does not verify the manifest contents.

2. **The Mathlib relationship is unambiguous.**
   The guide says that the repository contains “a Lean 4 companion built against Mathlib” and immediately adds “it is not part of Mathlib.”  The root README consistently calls it a companion “built against pinned Mathlib.”  A reasonable reader cannot infer Mathlib authorship, endorsement, or repository membership from the guide as written.

3. **The primary-paper coverage census is exact.**
   The primary manuscript has 15 theorem-like labels.  Their claim-map rows partition as 5 `fragment`, 9 `conditional_deduction`, 1 `absent`, and 0 `complete`.  The absent row is exactly `lem:faithful-center-base-change`.  This matches the guide.  The separate shared-package snapshot is also exact: 57 claims = 5 absent + 24 fragmentary + 27 conditional + 1 complete; 317 reviewer terminals, including 83 machinery terminals.

4. **The source-only semantics are stated exactly.**
   At the pinned commit, the extracted command
   `verification/check_formal_artifact.py --source-only` passes with 186 sources, 317 terminals, 57 claims, 83 machinery rows, 19 imported sources, and 3 evidence bundles.  Inspection of the checker confirms that this mode checks manuscript/claim annotations, statement and terminal digests, terminal partitioning, registry structure and references, dependency-graph freshness, public source conventions, axiom-audit command coverage, and one expected-axiom row per terminal.  It does not elaborate Lean and does not compare kernel output with `expected_axioms.txt`; that comparison occurs only with `--axiom-log`.  The guide, root README, Lean README, verification README, and Makefile all preserve that distinction.

5. **No fresh or one-command formal replay is promised.**
   The guide identifies `expected_axioms.txt` as an expected dependency transcript rather than a fresh kernel run, says `make check` neither builds Lean nor checks the captured transcript, and expressly says that the guide supplies no standalone formal replay command.  The Lean README separately documents a package build followed by capture and checking of the axiom-audit output.  That is a manual two-stage route, not a claim that the ordinary paper check performs a fresh formal replay.

6. **The expected-axiom registry is internally exact but historical until replayed.**
   It has one row for each of the 317 reviewer terminals.  The expected dependency sets contain only `propext`, `Classical.choice`, and `Quot.sound`, or subsets thereof: 288 rows list all three, 22 list `propext, Quot.sound`, 4 list `propext`, 1 lists `Quot.sound`, and 2 list none.  The source-only checker verifies the census, while only axiom-log mode verifies fresh observed output.

7. **The formal entry point and limitations agree.**
   `PaperInterface/Main.lean` imports the Introduction, CategoricalOneStep, FormalConnections, and ResiduePairing facades and says that geometric and literature inputs remain explicit in declaration types.  The primary claim rows substantiate that limitation: Lean does not construct the cubic QDM, the QDM comparisons, weak factorization, faithful center base change, the residue-to-formal-exponent identification, or geometric low-dimensional nullity.

8. **The registries and links resolve.**
   The imported-source registry has 19 entries, each structurally checked for a manuscript bibliography key, pinpoint, stated use, and convention match.  The evidence registry has 3 entries with tracked manifests and replay commands.  All 20 distinct internal Markdown targets across the guide, root README, Lean README, and verification README exist in the pinned tree.  The DOI redirects successfully to Zenodo and the badge URL returns HTTP 200.  Link resolution therefore passes; evidence integrity does not, for the stale hash in Finding 1.

## Strongest passage

The best passage is the guide's compact boundary statement beginning “The repository also contains a Lean 4 companion built against Mathlib; it is not part of Mathlib.”  In one short sequence it gives the primary-only counts, names the one absent lemma, lists what Lean does prove, lists the geometric and formal-classification steps it does not prove, points to the public interface and claim map, characterizes the axiom file as expected rather than freshly observed, and distinguishes `make check` from formal replay.  It is unusually hard to misread.

## First friction

The first mild friction is the change of counting scope between documents.  The guide reports the 15 primary-paper rows, while the Lean and verification READMEs report the 57-row inventory shared by all three manuscripts.  Both are correct and the guide says “For the primary paper,” but a hurried reviewer must notice that qualifier before reconciling `5/9/1/0` with `5/24/27/1`.  A parenthetical “15 primary-paper claims” would remove the momentary arithmetic pause.

