#!/usr/bin/env python3
"""Reduce interleaved contextual-state benchmark logs to compact JSON."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

TIME_RE = re.compile(r"time:\s+\[[0-9.]+ \S+ ([0-9.]+) (\S+)")
WORK_RE = re.compile(r"([a-z_]+)=([0-9]+)")
SCALE = {"ns": 1.0, "µs": 1_000.0, "ms": 1_000_000.0}


def timing_samples(path: Path) -> dict[str, list[float]]:
    samples: dict[str, list[float]] = {}
    current: str | None = None
    for line in path.read_text().splitlines():
        if line.startswith("BEGIN "):
            current = line.removeprefix("BEGIN ")
            continue
        match = TIME_RE.search(line)
        if current is not None and match is not None:
            value, unit = match.groups()
            samples.setdefault(current, []).append(float(value) * SCALE[unit])
            current = None
    return samples


def memory_and_work(path: Path) -> tuple[dict[str, int], dict[str, dict[str, int]]]:
    memory: dict[str, int] = {}
    work: dict[str, dict[str, int]] = {}
    for line in path.read_text().splitlines():
        if line.startswith("MAXRSS_KIB "):
            _, name, value = line.split()
            memory[name] = int(value)
        elif line.startswith("CONTEXT_WORK "):
            _, name, fields = line.split(maxsplit=2)
            work[name] = {key: int(value) for key, value in WORK_RE.findall(fields)}
    return memory, work


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--timing-log", type=Path, required=True)
    parser.add_argument("--memory-log", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    timings = timing_samples(args.timing_log)
    memory, work = memory_and_work(args.memory_log)
    measurements = {
        name: {
            "central_ns": values,
            "mean_central_ns": sum(values) / len(values),
            "peak_rss_kib": memory.get(name),
        }
        for name, values in sorted(timings.items())
    }
    value = {
        "schema": "ergodis-contextual-ab-v1",
        "noncanonical": True,
        "protocol": {
            "timing": "two rounds with A/B order reversed; 15 Criterion samples, 1 s warmup, 0.5 s measurement",
            "memory": "separate A/B processes; 10 Criterion samples, 0.2 s warmup and measurement; GNU time maximum RSS",
        },
        "measurements": measurements,
        "work": {name: fields for name, fields in sorted(work.items())},
    }
    args.output.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
