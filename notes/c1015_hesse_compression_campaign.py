#!/usr/bin/env python3
"""Build the frozen Ergodis feature batch for the C1015 Hesse-line compression.

The rows are all subfamilies of the twelve affine lines of AG(2,3).  A row is
positive exactly when incidence alone certifies zero total projective
intersection: two selected nonparallel lines meet at a Hesse point and some
third selected line avoids that point.
"""

import argparse
import itertools
import json
from pathlib import Path


POINTS = tuple(itertools.product(range(3), repeat=2))
LINES = tuple(
    sorted(
        {
            tuple(
                point_index
                for point_index, point in enumerate(POINTS)
                if (
                    (point[0] - first[0]) * (second[1] - first[1])
                    - (point[1] - first[1]) * (second[0] - first[0])
                )
                % 3
                == 0
            )
            for first_index, second_index in itertools.combinations(range(9), 2)
            for first, second in ((POINTS[first_index], POINTS[second_index]),)
        }
    )
)
assert len(LINES) == 12


def direction(line):
    first, second = (POINTS[index] for index in line[:2])
    delta = ((second[0] - first[0]) % 3, (second[1] - first[1]) % 3)
    negative = tuple(-coordinate % 3 for coordinate in delta)
    return min(delta, negative)


FIELDS = (
    "line_count",
    "direction_count",
    "covered_point_count",
    "max_point_multiplicity",
    "incident_pair_count",
    "witness_slack",
)


def row(mask):
    chosen = tuple(index for index in range(12) if mask & (1 << index))
    multiplicities = tuple(
        sum(point in LINES[index] for index in chosen) for point in range(9)
    )
    maximum = max(multiplicities, default=0)
    line_count = len(chosen)
    values = (
        line_count,
        len({direction(LINES[index]) for index in chosen}),
        sum(value > 0 for value in multiplicities),
        maximum,
        sum(value * (value - 1) // 2 for value in multiplicities),
        line_count - maximum,
    )
    expected = maximum >= 2 and line_count > maximum
    return {
        "id": mask,
        "weight": 1,
        "expected": expected,
        "values": values,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("output", type=Path)
    parser.add_argument("--certificate", type=Path)
    arguments = parser.parse_args()
    rows = tuple(row(mask) for mask in range(1 << 12))
    header = {
        "schema": "ergodis-campaign-data-v0",
        "presentation": "c1015-hesse-line-subfamilies-v1",
        "problem": "hesse-common-intersection-compression",
        "fields": FIELDS,
        "rows": len(rows),
    }
    with arguments.output.open("x", encoding="utf-8") as stream:
        stream.write(json.dumps(header, separators=(",", ":")) + "\n")
        for item in rows:
            stream.write(json.dumps(item, separators=(",", ":")) + "\n")
    positives = sum(item["expected"] for item in rows)
    predicates = {
        "line_outside_max_pencil": lambda values: values[5] > 0,
        "incident_line_pair": lambda values: values[3] > 1,
        "conjunction": lambda values: values[3] > 1 and values[5] > 0,
    }
    evaluations = {}
    for name, predicate in predicates.items():
        mismatches = [item for item in rows if predicate(item["values"]) != item["expected"]]
        false_positives = sum(
            predicate(item["values"]) and not item["expected"] for item in rows
        )
        false_negatives = sum(
            not predicate(item["values"]) and item["expected"] for item in rows
        )
        evaluations[name] = {
            "correct": len(rows) - len(mismatches),
            "false_positives": false_positives,
            "false_negatives": false_negatives,
            "first_mismatch_id": mismatches[0]["id"] if mismatches else None,
            "first_mismatch_values": mismatches[0]["values"] if mismatches else None,
        }
    certificate = {
        "schema": "c1015-hesse-compression-campaign-v1",
        "rows": len(rows),
        "distinct_feature_vectors": len({item["values"] for item in rows}),
        "positive": positives,
        "negative": len(rows) - positives,
        "full_family_values": rows[-1]["values"],
        "full_family_forces_zero": rows[-1]["expected"],
        "evaluations": evaluations,
        "ergodis_control_result": {
            "ceiling_unavoidable_errors": 0,
            "batch_perfect_plans": 1,
            "batch_plan_count": 3,
            "tree_synthesis_issue": "plan result sort does not match its declared output",
        },
    }
    if arguments.certificate is not None:
        with arguments.certificate.open("x", encoding="utf-8") as stream:
            json.dump(certificate, stream, indent=2, sort_keys=True)
            stream.write("\n")
    print(json.dumps(certificate, sort_keys=True))


if __name__ == "__main__":
    main()
