# C1039 planted theorem-gap admission bundle

Private, discovery-only evidence. No paper-facing claim, no general admission-soundness claim, no
claim of transfer to unplanted corpora, and no claim that evolve discovered mathematics.

## Replay

```sh
cd ergodis-private
cargo build -p hadamard-2092 --release
rm -rf ~/.cache/ergodis/c1039-replay
~/.cache/ergodis/target/ergodis-private/release/hadamard evolve theorem-gap \
  --output-dir ~/.cache/ergodis/c1039-replay > /tmp/c1039-certificate.json
sha256sum /tmp/c1039-certificate.json ~/.cache/ergodis/c1039-replay/views/*.jsonl
```

The command creates its output directory and refuses to overwrite an existing one. Its stdout is
the certificate; it carries no wall-clock, path, or host field, so two invocations are
byte-identical. The generated views are recompressed here with `gzip -9 -n`.

## Contents and hashes

`SHA256SUMS` covers the files in this directory. The two `view_digests` entries in
`certificate.json` are the SHA-256 sums of the *uncompressed* view files, in the order
`training`, `direct-model`; they are recomputed inside the generator as it writes, so they check
the generator against the bytes on disk independently.

| File | What it is |
|---|---|
| `certificate.json` | the run's full admission record |
| `planted-gap-training.jsonl.gz` | the training view the proposer saw |
| `planted-gap-direct-model.jsonl.gz` | the complete direct-model view admission replays against |

## Independent replay

`ergodis-private/src/planted_gap_corpus.rs` carries the latent oracle
(`planted_residuals`, `planted_truth`). The command re-derives every direct-model label from that
oracle before admission runs and fails closed on any disagreement, so the labels in the corpus
file and the labels admission uses come from two separate code paths. Each recorded
counterexample names a direct-model row index whose latent tuple is recomputed by
`planted_residuals(PlantedView::DirectModel, row)` without reading the file.
