# Clebsch targets 4, 5, 7, and 8 import audit

**Lane:** `clebsch`

**Date:** 2026-07-26

## Imported provenance

The user supplied a report and adjacent archive produced in a prior ChatGPT
conversation. They are preserved byte-for-byte as:

| File | Bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-26-clebsch-targets-4-5-7-8-report.md` | 31648 | `b4e8efd95ad7e676e25d07f65f839c58c08f9d8305220009a238f1a13bbfb538` |
| `notes/artifacts/2026-07-26-clebsch-targets-4-5-7-8-bundle.tar.gz` | 32929 | `fccf74353979809538d20a614100967932341afa0da0438a5fa4724b4d32d1b5` |

The adjacent `2026-07-26-clebsch-targets-4-5-7-8-SHA256SUMS`
freezes these identities. Import preserves provenance; it does not promote
the report's literature or banked-input assertions to repository proofs.

## Replay

Run from `/home/tavis/src/othello`:

```text
task_tmp=$(mktemp -d /home/tavis/.cache/clebsch-targets-XXXXXX)
tar -xzf notes/artifacts/2026-07-26-clebsch-targets-4-5-7-8-bundle.tar.gz -C "$task_tmp"
cmp -s notes/2026-07-26-clebsch-targets-4-5-7-8-report.md \
  "$task_tmp/output/clebsch_targets_4_5_7_8_report.md"
cd "$task_tmp/research"
python3 -m unittest -v test_repair_port_compiler.py
python3 hitchin_mathieu_torsor_certificate.py
```

The archive has seven members. The embedded report is byte-identical to the
separate import. All seven repair-port tests pass. The torsor script
reproduces the roots \(4,8\), their exchange, the relevant group orders,
the conditional product order \(95040\), and the two equivariant bijections
between unmarked free \(C_2\)-torsors.

The load-bearing archive members are:

| Member | Bytes | SHA-256 |
|---|---:|---|
| `research/repair_port_compiler.py` | 15515 | `feb78e38422eabdfab4756f6bdc46c4b2869051d2ac96aa2d274344c4929a85b` |
| `research/clebsch_repair_port.json` | 365 | `8c985306e7037add8dc2e0489387a829d3debddb34f12ccbf2ab8efd28d37a99` |
| `research/clebsch_repair_port_certificate.json` | 214669 | `4791a3f4c664ff0b92824cfeb49e68d91ac78652657a629eecd5446512cc8237` |
| `research/test_repair_port_compiler.py` | 3270 | `c89a3b1313e7c50144e7f25155664daf2e882c2f5b705882d84c82e2ce380c8b` |
| `research/hitchin_mathieu_torsor_certificate.py` | 2129 | `e016e8085c15a95b982d10f488ddc918b3114db4cf535b75129a4a0e78053b87` |
| `research/hitchin_mathieu_torsor_certificate.json` | 905 | `a496f3f53d62c09c8ce59e47bbe127b5f9cc920c61df75f1d53983913eca4554` |

## Mathematical disposition

**Target 4 is admitted as a conceptual input, with a citation gate.** The
general localization theorem is correct: for an integral algebra with a
nontrivial involution and nonzero odd element \(C\), localization at \(C^2\)
is the direct sum of the invariant algebra and \(C\) times that algebra.
The first-observable and moment corollaries follow. On the sign-twisted
Clebsch four-space, the claimed first odd generator is
\(e_3=\sigma_3\). C653 must verify the classical \(A_5\)-invariant-ring
source and characteristic hypotheses before manuscript use.

**Target 5 remains conditional and is routed to C652.** The elementary
free-torsor argument and subgroup product-order calculation are correct
given the stated inputs. The script explicitly does not recompute the two
\(M_{11}\) embeddings in \(M_{12}\), their
\(\operatorname{PSL}_2(11)\) intersection, Hadamard row--column exchange,
or compatibility of reduced Hitchin exchange with \(T_{11}\). Those four
identifications are the mathematical bridge and remain unproved here.

**Target 7 is a reduction, not a theorem.** The punctured
simultaneous-isotopy lemma remains open. This belongs to the continuation
program, not Paper III.

**Target 8 is a positive software prototype outside this lane.** The bundle
supports its bounded prime-field Clebsch example, including coefficient
fibres, support clutter, reliability, adaptive policy, and code
reconstruction. General extension fields, compressed fibres, correlated
failures, and transfer-certificate composition are not implemented. Any
promotion belongs to the complete-ports lane.

## Trust boundary

The replay checks deterministic Python computations with exact modular
arithmetic except for the report's displayed decimal reliability and cost
summaries. It is not an independent implementation of the compiler. The
torsor script checks consequences of declared group-theoretic inputs rather
than the inputs themselves. The report's novelty conclusions remain
targeted-search claims from the prior conversation until the owning
literature gate verifies the cited sources and search record.
