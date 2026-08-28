#!/usr/bin/env python3
"""Write a Boa List-functor fixture matching observational_sota_driver."""

import argparse
from pathlib import Path


MASK = (1 << 64) - 1


def next_random(state: int) -> int:
    state ^= state << 13 & MASK
    state ^= state >> 7
    state ^= state << 17 & MASK
    return state & MASK


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("family", choices=("chain", "random", "redundant", "colors"))
    parser.add_argument("states", type=int)
    parser.add_argument("generators", type=int)
    parser.add_argument("outputs", type=int)
    parser.add_argument("destination", type=Path)
    args = parser.parse_args()
    if args.states < 2 or args.generators < 1 or args.outputs < 2:
        parser.error("states >= 2, generators >= 1, and outputs >= 2 are required")
    if args.family == "colors" and args.states % args.outputs:
        parser.error("colors requires outputs to divide states")

    random_states = [
        0x9E37_79B9_7F4A_7C15
        ^ (generator % 4 if args.family == "redundant" else generator)
        for generator in range(args.generators)
    ]
    with args.destination.open("w", encoding="ascii") as output:
        for state in range(args.states):
            observation = state % args.outputs if args.family == "colors" else int(
                state == args.states - 1
            )
            targets = []
            for generator in range(args.generators):
                effective_generator = generator % 4 if args.family == "redundant" else generator
                if args.family == "colors":
                    target = (state + effective_generator + 1) % args.states
                elif args.family == "chain" or effective_generator == 0:
                    target = min(state + 1, args.states - 1)
                else:
                    random_states[generator] = next_random(random_states[generator])
                    target = random_states[generator] % args.states
                targets.append(f"@{target}")
            output.write(f"List[{observation}]{{{','.join(targets)}}}\n")


if __name__ == "__main__":
    main()
