#!/usr/bin/env python3
"""Audit the two-phase dictionary certificates without replaying C++ internals."""

import json
import sys


def load(path):
    with open(path, encoding="utf-8") as source:
        return json.load(source)


def traversal(record):
    return {key: value for key, value in record.items()
            if key != "dictionary_classes_used"}


def main():
    if len(sys.argv) != 5:
        raise SystemExit(
            "usage: replay.py Q3 Q5 INDEPENDENT_Q3 OUTPUT"
        )
    q3 = load(sys.argv[1])
    q5 = load(sys.argv[2])
    independent = load(sys.argv[3])

    for expected_q, record in ((3, q3), (5, q5)):
        assert record["selector"] == "two-phase-fixed-prefix-live-dictionary"
        assert record["field_order"] == expected_q
        assert record["type_index"] == 0
        assert record["train_value_conflicts"] == 0
        assert traversal(record["exact_replay"]) == traversal(record["normal_replay"])
        assert record["normal_replay"]["dictionary_classes_used"] <= \
            record["exact_replay"]["dictionary_classes_used"]
        assert record["dictionary_absolute_keys"] == \
            record["exact_dictionary_classes"]
        assert record["train_quotient_classes"] == \
            record["exact_dictionary_classes"]
        assert record["train_normal_form_classes"] == \
            record["compressed_dictionary_classes"]

    assert q3["train_follower_nimber"] == independent["follower_nimber"] == 1
    assert q3["normal_replay"]["follower_nimber"] == 1
    assert not q3["normal_replay"]["stopped_at_limit"]
    assert q5["train_follower_nimber"] == -1
    assert q5["normal_replay"]["follower_nimber"] == -1
    assert q5["normal_replay"]["stopped_at_limit"]

    result = {
        "field_orders": [3, 5],
        "independent_q3_follower_nimber": independent["follower_nimber"],
        "q3_dictionary_class_reduction":
            q3["exact_dictionary_classes"] - q3["compressed_dictionary_classes"],
        "q5_dictionary_class_reduction":
            q5["exact_dictionary_classes"] - q5["compressed_dictionary_classes"],
        "q5_dictionary_hits": q5["normal_replay"]["dictionary_hits"],
        "q5_replay_class_reduction_used":
            q5["exact_replay"]["dictionary_classes_used"] -
            q5["normal_replay"]["dictionary_classes_used"],
        "q5_replay_limit_vertices": q5["normal_replay"]["limit_vertices"],
        "q5_value_returned": False,
        "traversals_equal": True,
    }
    with open(sys.argv[4], "w", encoding="utf-8") as output:
        json.dump(result, output, sort_keys=True, separators=(",", ":"))
        output.write("\n")


if __name__ == "__main__":
    main()
