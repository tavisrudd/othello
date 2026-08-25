#!/usr/bin/env python3
"""Generate a parallel modular grid for the generic C958 quintic inverse."""

import argparse
import contextlib
import importlib.util
import io
import json
import multiprocessing
import random
from pathlib import Path


SEARCH_PATH = Path(__file__).with_name("2026-08-25-c958-type-i1-tangent-inverse-search.py")


def load_search():
    spec = importlib.util.spec_from_file_location("c958_inverse_search", SEARCH_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


SEARCH = load_search()


def sample(arguments):
    a_value, b_value, prime = arguments
    SEARCH.PRIME = prime
    with contextlib.redirect_stdout(io.StringIO()):
        result = SEARCH.build(a_value, b_value, modular_only=True)
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--a-start", type=int)
    parser.add_argument("--a-count", type=int)
    parser.add_argument("--b-start", type=int)
    parser.add_argument("--b-count", type=int)
    parser.add_argument("--random-count", type=int)
    parser.add_argument("--seed", type=int, default=958)
    parser.add_argument("--prime", type=int, default=1_000_003)
    parser.add_argument("--workers", type=int, default=12)
    parser.add_argument("--write", type=Path, required=True)
    arguments = parser.parse_args()
    if arguments.random_count:
        rng = random.Random(arguments.seed)
        pairs = set()
        while len(pairs) < arguments.random_count:
            pair = (rng.randrange(8, 10_000), rng.randrange(8, 10_000))
            if pair[0] != pair[1]:
                pairs.add(pair)
        points = [(a_value, b_value, arguments.prime) for a_value, b_value in sorted(pairs)]
    else:
        assert None not in (arguments.a_start, arguments.a_count,
                            arguments.b_start, arguments.b_count)
        points = [
            (a_value, b_value, arguments.prime)
            for a_value in range(arguments.a_start, arguments.a_start + arguments.a_count)
            for b_value in range(arguments.b_start, arguments.b_start + arguments.b_count)
        ]
    with multiprocessing.Pool(arguments.workers) as pool:
        samples = pool.map(sample, points)
    payload = {
        "schema": "c958-generic-modular-grid-v1",
        "prime": arguments.prime,
        "samples": samples,
    }
    arguments.write.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"samples={len(samples)} output={arguments.write}")


if __name__ == "__main__":
    main()
