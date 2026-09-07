# Provenance of this bundle

Received 2026-09-07 from the user as `clebsch_quantum_research_bundle.zip` (28766 bytes) together
with `clebsch_quantum_research_memo.md`; both were produced by ChatGPT (Astra) on 2026-09-04.
Copied here unmodified; `SHA256SUMS` verified on receipt, and the loose memo is byte-identical
to the bundled one.

Checks performed on receipt:

- `uv run --with numpy python clebsch_quantum_verify.py --output recomputed.json` passes
  ("All requested exact checks passed"); the `--enumerators` and `--bruteforce-seven` modes were
  not rerun because the independent replay in the parent directory already recomputed both
  enumerators (Rust subset-rank enumeration and a brute-force `7^7` word count).
- The `E` matrices and complete weight enumerators in `clebsch_quantum_data.json` equal the
  values transcribed from the memo and independently verified in `../REPORT.md`.
- The memo's `p = 7` rank-one Hessian certificate is incomplete as written (see `../REPORT.md`);
  the bundle's `no_rank_one_hessian: true` flag is its own full check and agrees with ours.

Owning task: C1090 (`clebsch`).  This bundle is third-party input, not a repository claim.
