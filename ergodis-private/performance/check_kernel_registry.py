#!/usr/bin/env python3
"""Validate and summarize the private Ergodis performance gate registry."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


SCHEMA = "ergodis-private-performance-kernel-registry-v1"
STATUSES = {"pass", "open", "na"}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "registry",
        nargs="?",
        type=Path,
        default=Path(__file__).with_name("kernel-registry-v1.json"),
    )
    parser.add_argument(
        "--allow-open",
        action="store_true",
        help="report open gates without making them a failing exit status",
    )
    args = parser.parse_args()

    registry = json.loads(args.registry.read_text(encoding="utf-8"))
    if registry.get("schema") != SCHEMA:
        raise SystemExit("unsupported performance-registry schema")
    dimensions = registry.get("dimensions")
    if not isinstance(dimensions, list) or len(dimensions) != len(set(dimensions)):
        raise SystemExit("dimensions must be a unique nonempty list")

    repository = Path(__file__).resolve().parents[2]
    seen: set[str] = set()
    open_gates: list[tuple[str, str, str]] = []
    counts = {status: 0 for status in STATUSES}
    kernels = registry.get("kernels")
    if not isinstance(kernels, list) or not kernels:
        raise SystemExit("registry must contain kernels")

    for kernel in kernels:
        kernel_id = kernel.get("id")
        if not isinstance(kernel_id, str) or not kernel_id or kernel_id in seen:
            raise SystemExit(f"invalid or duplicate kernel id: {kernel_id!r}")
        seen.add(kernel_id)
        source = kernel.get("source")
        if not isinstance(source, str) or not (repository / source).is_file():
            raise SystemExit(f"{kernel_id}: missing source {source!r}")
        extras = set(kernel) - {"id", "source", *dimensions}
        missing = set(dimensions) - set(kernel)
        if extras or missing:
            raise SystemExit(
                f"{kernel_id}: extra dimensions={sorted(extras)} missing={sorted(missing)}"
            )
        for dimension in dimensions:
            gate = kernel[dimension]
            status = gate.get("status") if isinstance(gate, dict) else None
            if status not in STATUSES:
                raise SystemExit(f"{kernel_id}/{dimension}: invalid status {status!r}")
            counts[status] += 1
            if status == "pass":
                evidence = gate.get("evidence")
                if not isinstance(evidence, list) or not evidence:
                    raise SystemExit(f"{kernel_id}/{dimension}: pass lacks evidence")
                for item in evidence:
                    if not isinstance(item, str) or not (repository / item).is_file():
                        raise SystemExit(
                            f"{kernel_id}/{dimension}: missing evidence {item!r}"
                        )
            else:
                reason = gate.get("reason")
                if not isinstance(reason, str) or not reason.strip():
                    raise SystemExit(f"{kernel_id}/{dimension}: {status} lacks reason")
                if status == "open":
                    open_gates.append((kernel_id, dimension, reason))

    print(
        f"kernels={len(kernels)} pass={counts['pass']} open={counts['open']} "
        f"not_applicable={counts['na']}"
    )
    for kernel_id, dimension, reason in open_gates:
        print(f"OPEN {kernel_id} {dimension}: {reason}")
    return 0 if args.allow_open or not open_gates else 1


if __name__ == "__main__":
    raise SystemExit(main())
