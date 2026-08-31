# Private Ergodis performance registry

This directory is internal process infrastructure and must not be exported.
The registry intentionally includes incomplete public kernels; omission is not
a passing status.

Run the strict gate from the repository root:

```sh
python3 ergodis-private/performance/check_kernel_registry.py
```

It validates the schema, complete gate dimensions, source/evidence paths, and
then exits nonzero while any required gate is open. During remediation,
`--allow-open` prints the bounded backlog with a successful exit status.
