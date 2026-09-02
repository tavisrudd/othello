#!/usr/bin/env python3
"""Summarize an interleaved two-arm Ergodis TSV with paired log-ratio t scores."""

from __future__ import annotations

import argparse
import csv
import math
import statistics
from collections.abc import Sequence
from pathlib import Path


IGNORED_COLUMNS = frozenset({"round", "variant", "seed"})


def parse_args(argv: Sequence[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    return parser.parse_args(argv)


def load_pairs(path: Path) -> tuple[list[str], dict[int, dict[str, dict[str, str]]]]:
    with path.open(newline="", encoding="utf-8") as source:
        reader = csv.DictReader(source, delimiter="\t")
        if reader.fieldnames is None:
            raise ValueError("missing TSV header")
        required = {"round", "variant"}
        if not required.issubset(reader.fieldnames):
            raise ValueError("TSV is missing round or variant")
        metrics = [column for column in reader.fieldnames if column not in IGNORED_COLUMNS]
        pairs: dict[int, dict[str, dict[str, str]]] = {}
        for row in reader:
            round_index = int(row["round"])
            variant = row["variant"]
            if variant not in {"baseline", "candidate"}:
                raise ValueError(f"unknown variant {variant!r}")
            by_variant = pairs.setdefault(round_index, {})
            if variant in by_variant:
                raise ValueError(f"duplicate {variant} row for round {round_index}")
            by_variant[variant] = row
    if not pairs:
        raise ValueError("no samples")
    for round_index, pair in pairs.items():
        if set(pair) != {"baseline", "candidate"}:
            raise ValueError(f"incomplete round {round_index}")
    return metrics, pairs


def summarize_metric(
    metric: str, pairs: dict[int, dict[str, dict[str, str]]]
) -> tuple[float, float, float, float, int]:
    baseline: list[float] = []
    candidate: list[float] = []
    log_ratios: list[float] = []
    for round_index in sorted(pairs):
        base_value = float(pairs[round_index]["baseline"][metric])
        candidate_value = float(pairs[round_index]["candidate"][metric])
        if not (base_value > 0.0 and candidate_value > 0.0):
            raise ValueError(f"nonpositive {metric} value in round {round_index}")
        baseline.append(base_value)
        candidate.append(candidate_value)
        log_ratios.append(math.log(base_value / candidate_value))
    mean_log_ratio = statistics.fmean(log_ratios)
    if len(log_ratios) == 1:
        t_score = math.nan
    else:
        deviation = statistics.stdev(log_ratios)
        t_score = math.inf if deviation == 0.0 else mean_log_ratio / (deviation / math.sqrt(len(log_ratios)))
    return (
        statistics.median(baseline),
        statistics.median(candidate),
        math.exp(mean_log_ratio),
        t_score,
        len(log_ratios),
    )


def main(argv: Sequence[str] | None = None) -> int:
    args = parse_args(argv)
    metrics, pairs = load_pairs(args.input)
    if args.output.exists():
        raise FileExistsError(args.output)
    with args.output.open("x", newline="", encoding="utf-8") as sink:
        writer = csv.writer(sink, delimiter="\t", lineterminator="\n")
        writer.writerow(
            [
                "metric",
                "baseline_median",
                "candidate_median",
                "baseline_over_candidate_geomean",
                "paired_log_t",
                "rounds",
            ]
        )
        for metric in metrics:
            baseline, candidate, ratio, t_score, rounds = summarize_metric(metric, pairs)
            writer.writerow(
                [
                    metric,
                    f"{baseline:.12g}",
                    f"{candidate:.12g}",
                    f"{ratio:.12g}",
                    f"{t_score:.12g}",
                    rounds,
                ]
            )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
