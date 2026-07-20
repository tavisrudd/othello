# C321 — Clebsch exact certificates for Singular-backed claims

**Lane:** `clebsch`

**Status:** queued after C320 inventory

This file is both the cold-read task specification and the required durable result report. Complete
it in place with exact claims, equations, certificates, independent specification checks, replay,
hashes, trust boundaries, judgment calls, and review. Do not substitute a terminal transcript or a
second run of the same opaque calculation.

## Required outcome

For each load-bearing positive Singular claim, extract a compact cofactor, factorization, ideal
membership, or other witness checkable by a small exact-arithmetic verifier. For each
completeness/nonexistence claim, independently rederive the input system from the stated geometry and
check semantic invariants before running the exhaustive computation. A second CAS run on the same
input is not an independent specification check.

The final bundle contains a deterministic generator, explicit schema, canonical compact data,
checker and its trust argument, exact replay command and working directory, dependency versions,
all conventions/parameters, byte counts and SHA-256 hashes, and an independent rederivation or
reference implementation. It states exactly what each artifact proves and does not prove. Large
artifacts require an approved manifest/sharding/root-hash strategy before generation.

## Referee-facing standards and guarded failure modes

- Never promote finite exhaustion beyond its exact domain, assumptions, field, normalization, and
  stop condition. Distinguish a found witness, ideal membership, radical membership, dimension
  calculation, and completeness of a classification.
- Do not let generated output assert its own correctness. The verifier checks witness semantics;
  completeness claims additionally require independently justified input coverage.
- Check for vacuous ideals, saturated-versus-unsaturated drift, affine/projective mismatch,
  denominator or characteristic exceptions, lost components, multiplicities, coordinate
  normalization, random seeds, monomial order, and CAS/version sensitivity.
- Hashes prove identity only. Canonical regeneration and independent semantic checks establish
  reproducibility; the exact verifier establishes only the proposition its code actually checks.
- Public artifacts use mathematical names and self-contained provenance, with no task IDs, private
  notes, agents/sessions, machine-local paths, workflow chronology, or novelty/priority claim.

## Required judgment-call record

For every claim record the certificate form chosen, alternatives considered, why the checker is
adequate, how the input was independently derived, trusted CAS features, sharding/size decisions,
failed routes, effect on the paper/C320 tier, and reopening condition. Record “no adequate compact
certificate” as an external boundary, never as silent evidence.

## Required closing review and archival checklist

Keep C321 live. Complete the artifact bundle, report, checklist, and C320 delta, then explicitly
request an independent referee-style review of the mathematical specification, exact checker,
coverage argument, replay, hashes, and paper correspondence. Any finding or `NO-GO` blocks
completion and archival. Fix every issue, regenerate/recheck the whole affected bundle, update this
report, and request post-fix review. Only a recorded final `GO` permits C321 to be archived.

- [ ] Enumerate every load-bearing Singular claim and state its exact mathematical proposition.
- [ ] Classify it as positive witness, equality/membership, completeness/exhaustion, or other precise
  type; assign its final C320 trust route.
- [ ] For positive claims, provide compact exact witnesses and an independently readable checker.
- [ ] For completeness claims, independently derive the input system from geometry and verify
  coverage/invariants before accepting any CAS result.
- [ ] Record field, ring, variables, grading, ideals/saturation, monomial order, parameters,
  normalizations, dependency versions, seeds, and all exceptional cases.
- [ ] Ensure checker soundness is not a restatement of generated conclusions and that data cannot
  bake in the proposition unchecked.
- [ ] Provide canonical generator/schema/data/checker/replay files with final byte counts, hashes,
  exact commands, and independent cross-checks.
- [ ] State every limitation, failed route, bounded negative, trusted CAS primitive, and omitted
  claim without overstatement or novelty implication.
- [ ] Audit public names/comments/provenance for referee-facing self-containment and one-way internal
  references.
- [ ] Complete the judgment-call record and proposed C320 ledger delta for every claim.
- [ ] Record independent review, every fix/regeneration, post-fix review, and final `GO`.
- [ ] Only after final `GO`, archive C321 with the atomic evidence bundle and completed report.
