#!/usr/bin/env python3
"""C1018 upper-bound witness hunt for the bivariate-bicycle code [[756,16,d]].

Independent second implementation of the *upper* side only. It searches for a
low-weight logical operator of the CSS instance described by an Ergodis
``css_distance_native`` input file, using belief propagation with ordered
statistics decoding (BP-OSD) from the ``ldpc`` package.

Model. The input supplies sparse physical checks ``P`` (378 x 756) and logical
observations ``L`` (16 x 756). A logical operator is any ``v`` in GF(2)^756 with
``P v = 0`` and ``L v != 0``. Stacking ``H = [P; L]`` turns the search into a
syndrome-decoding problem: for a nonzero target class ``c`` in GF(2)^16, any
``e`` with ``H e = (0, c)`` is by construction a genuine logical operator, and
its Hamming weight is an exact upper bound on the code distance. Correctness of
a reported witness therefore does not depend on the decoder converging -- it is
re-verified here by direct GF(2) matrix multiplication, and is intended to be
replayed independently through ``css_distance_native --input`` with the witness
installed as ``incumbent_support``.

Usage:
  uv run --with ldpc --with numpy python3 <this file> \
      --input ~/.cache/ergodis/bb756/hx-gz.json \
      --trials 400 --osd-order 10 --seed 1018 --out best.json
"""

from __future__ import annotations

import argparse
import hashlib
import json
import pathlib
import time

import numpy as np


def load_instance(path: pathlib.Path):
    payload = json.loads(path.read_text())
    n = int(payload["coordinate_count"])
    checks = payload["physical_checks"]
    logicals = payload["logical_observations"]
    physical = np.zeros((len(checks), n), dtype=np.uint8)
    for row, support in enumerate(checks):
        physical[row, support] = 1
    logical = np.zeros((len(logicals), n), dtype=np.uint8)
    for row, support in enumerate(logicals):
        logical[row, support] = 1
    digest = hashlib.sha256(path.read_bytes()).hexdigest()
    return payload.get("label", ""), n, physical, logical, digest


def gf2_rref(matrix: np.ndarray):
    """Row-reduce over GF(2); return the reduced matrix and its pivot columns."""
    reduced = matrix.copy() % 2
    rows, cols = reduced.shape
    pivots: list[int] = []
    rank = 0
    for column in range(cols):
        pivot = None
        for row in range(rank, rows):
            if reduced[row, column]:
                pivot = row
                break
        if pivot is None:
            continue
        reduced[[rank, pivot]] = reduced[[pivot, rank]]
        selector = reduced[:, column] == 1
        selector[rank] = False
        reduced[selector] ^= reduced[rank]
        pivots.append(column)
        rank += 1
        if rank == rows:
            break
    return reduced, pivots


def sector_kernel_basis(physical: np.ndarray, low: int, high: int):
    """Basis of {v : P v = 0, supp(v) subset [low, high)}, in full coordinates."""
    n = physical.shape[1]
    window = physical[:, low:high]
    reduced, pivots = gf2_rref(window)
    width = high - low
    free = [c for c in range(width) if c not in set(pivots)]
    basis = np.zeros((len(free), n), dtype=np.uint8)
    for index, free_column in enumerate(free):
        basis[index, low + free_column] = 1
        for row, pivot_column in enumerate(pivots):
            if reduced[row, free_column]:
                basis[index, low + pivot_column] = 1
    return basis


def exhaustive_sector_scan(physical: np.ndarray, logical: np.ndarray,
                           low: int, high: int, chunk_bits: int = 16):
    """Exhaustively minimise weight over every logical operator inside a sector.

    Enumerates all 2^k combinations of the sector kernel basis with a doubling
    table, so the returned weight is the exact minimum over that sector -- an
    upper bound on the code distance, not a lower bound.
    """
    basis = sector_kernel_basis(physical, low, high)
    dimension = basis.shape[0]
    if dimension == 0:
        return None, [], 0, 0
    words = (basis.shape[1] + 63) // 64
    packed = np.zeros((dimension, words), dtype=np.uint64)
    for row in range(dimension):
        support = np.flatnonzero(basis[row])
        for coordinate in support:
            packed[row, coordinate // 64] |= np.uint64(1) << np.uint64(
                coordinate % 64)
    syndromes = np.zeros(dimension, dtype=np.uint32)
    observed = (logical @ basis.T) % 2
    for row in range(dimension):
        for observation in range(logical.shape[0]):
            if observed[observation, row]:
                syndromes[row] |= np.uint32(1) << np.uint32(observation)

    tail = min(chunk_bits, dimension)
    table = np.zeros((1 << tail, words), dtype=np.uint64)
    table_syndrome = np.zeros(1 << tail, dtype=np.uint32)
    for bit in range(tail):
        half = 1 << bit
        table[half:2 * half] = table[:half] ^ packed[bit]
        table_syndrome[half:2 * half] = table_syndrome[:half] ^ syndromes[bit]

    best_weight = None
    best_index = None
    head_bits = dimension - tail
    for head in range(1 << head_bits):
        head_vector = np.zeros(words, dtype=np.uint64)
        head_syndrome = np.uint32(0)
        for bit in range(head_bits):
            if head >> bit & 1:
                head_vector ^= packed[tail + bit]
                head_syndrome ^= syndromes[tail + bit]
        block = table ^ head_vector
        weights = np.bitwise_count(block).sum(axis=1)
        live = (table_syndrome ^ head_syndrome) != 0
        if not live.any():
            continue
        weights = np.where(live, weights, np.iinfo(np.int64).max)
        candidate = int(weights.argmin())
        if best_weight is None or weights[candidate] < best_weight:
            best_weight = int(weights[candidate])
            best_index = (head, candidate)

    support: list[int] = []
    if best_index is not None:
        head, candidate = best_index
        vector = np.zeros(basis.shape[1], dtype=np.uint8)
        for bit in range(tail):
            if candidate >> bit & 1:
                vector ^= basis[bit]
        for bit in range(head_bits):
            if head >> bit & 1:
                vector ^= basis[tail + bit]
        support = np.flatnonzero(vector).tolist()
    return best_weight, support, dimension, 1 << dimension


def kernel_basis(matrix: np.ndarray) -> np.ndarray:
    """Basis of the GF(2) kernel of ``matrix``, one basis vector per row."""
    reduced, pivots = gf2_rref(matrix)
    cols = matrix.shape[1]
    pivot_set = set(pivots)
    free = [c for c in range(cols) if c not in pivot_set]
    basis = np.zeros((len(free), cols), dtype=np.uint8)
    for index, free_column in enumerate(free):
        basis[index, free_column] = 1
        for row, pivot_column in enumerate(pivots):
            if reduced[row, free_column]:
                basis[index, pivot_column] = 1
    return basis


def enumerate_subspace(basis: np.ndarray, logical: np.ndarray,
                       chunk_bits: int = 16):
    """Exact minimum weight over the nonzero, logically nontrivial subspace."""
    dimension = basis.shape[0]
    if dimension == 0:
        return None, []
    width = basis.shape[1]
    words = (width + 63) // 64
    packed = np.zeros((dimension, words), dtype=np.uint64)
    for row in range(dimension):
        for coordinate in np.flatnonzero(basis[row]):
            packed[row, coordinate // 64] |= np.uint64(1) << np.uint64(
                coordinate % 64)
    syndromes = np.zeros(dimension, dtype=np.uint32)
    observed = (logical @ basis.T) % 2
    for row in range(dimension):
        for observation in range(logical.shape[0]):
            if observed[observation, row]:
                syndromes[row] |= np.uint32(1) << np.uint32(observation)

    tail = min(chunk_bits, dimension)
    table = np.zeros((1 << tail, words), dtype=np.uint64)
    table_syndrome = np.zeros(1 << tail, dtype=np.uint32)
    for bit in range(tail):
        half = 1 << bit
        table[half:2 * half] = table[:half] ^ packed[bit]
        table_syndrome[half:2 * half] = table_syndrome[:half] ^ syndromes[bit]

    best_weight = None
    best_index = None
    head_bits = dimension - tail
    for head in range(1 << head_bits):
        head_vector = np.zeros(words, dtype=np.uint64)
        head_syndrome = np.uint32(0)
        for bit in range(head_bits):
            if head >> bit & 1:
                head_vector ^= packed[tail + bit]
                head_syndrome ^= syndromes[tail + bit]
        weights = np.bitwise_count(table ^ head_vector).sum(axis=1)
        live = (table_syndrome ^ head_syndrome) != 0
        if not live.any():
            continue
        weights = np.where(live, weights, np.iinfo(np.int64).max)
        candidate = int(weights.argmin())
        if best_weight is None or weights[candidate] < best_weight:
            best_weight = int(weights[candidate])
            best_index = (head, candidate)

    support: list[int] = []
    if best_index is not None:
        head, candidate = best_index
        vector = np.zeros(width, dtype=np.uint8)
        for bit in range(tail):
            if candidate >> bit & 1:
                vector ^= basis[bit]
        for bit in range(head_bits):
            if head >> bit & 1:
                vector ^= basis[tail + bit]
        support = np.flatnonzero(vector).tolist()
    return best_weight, support


def information_set_scan(basis: np.ndarray, logical: np.ndarray,
                         trials: int, rng, pairs: bool = True,
                         deadline: float | None = None):
    """Randomised systematic-form search for a light codeword of ``basis``.

    Repeatedly row-reduces the subspace basis under a random column order and
    inspects the resulting systematic rows and their pairwise sums, keeping only
    combinations the logical observations detect. Returns an exact upper bound
    (every candidate is a genuine member of the subspace) and never a lower one.
    """
    dimension, width = basis.shape
    if dimension == 0:
        return None, [], 0
    best_weight = None
    best_vector = None
    done = 0
    for _ in range(trials):
        if deadline is not None and time.time() > deadline:
            break
        order = rng.permutation(width)
        work = basis[:, order].copy()
        track = basis.copy()
        rank = 0
        for column in range(width):
            if rank == dimension:
                break
            pivot = None
            for row in range(rank, dimension):
                if work[row, column]:
                    pivot = row
                    break
            if pivot is None:
                continue
            if pivot != rank:
                work[[rank, pivot]] = work[[pivot, rank]]
                track[[rank, pivot]] = track[[pivot, rank]]
            selector = work[:, column] == 1
            selector[rank] = False
            if selector.any():
                work[selector] ^= work[rank]
                track[selector] ^= track[rank]
            rank += 1
        done += 1
        detected = ((logical @ track.T) % 2).any(axis=0)
        weights = track.sum(axis=1)
        live = np.flatnonzero(detected)
        if live.size:
            index = live[np.argmin(weights[live])]
            if best_weight is None or weights[index] < best_weight:
                best_weight = int(weights[index])
                best_vector = track[index].copy()
        if pairs and dimension > 1:
            left, right = np.triu_indices(dimension, 1)
            sums = track[left] ^ track[right]
            detected_pair = ((logical @ sums.T) % 2).any(axis=0)
            pair_weights = sums.sum(axis=1)
            live_pair = np.flatnonzero(detected_pair)
            if live_pair.size:
                index = live_pair[np.argmin(pair_weights[live_pair])]
                if best_weight is None or pair_weights[index] < best_weight:
                    best_weight = int(pair_weights[index])
                    best_vector = sums[index].copy()
    support = np.flatnonzero(best_vector).tolist() if best_vector is not None else []
    return best_weight, support, done


def translation_permutation(shift_x: int, shift_y: int, ell: int, m: int,
                            n: int) -> np.ndarray:
    """Coordinate permutation induced by one group translation.

    Assumes the standard bivariate-bicycle layout: two sectors of ``ell * m``
    coordinates, each indexed as ``i * m + j`` for ``(i, j)`` in Z_ell x Z_m.
    The caller verifies the assumption against the check matrix before use.
    """
    block = ell * m
    permutation = np.zeros(n, dtype=np.int64)
    for sector in range(n // block):
        base = sector * block
        for i in range(ell):
            for j in range(m):
                source = base + i * m + j
                target = base + ((i + shift_x) % ell) * m + (j + shift_y) % m
                permutation[source] = target
    return permutation


def preserves_row_space(matrix: np.ndarray, permutation: np.ndarray) -> bool:
    """True when permuting columns leaves the GF(2) row space unchanged."""
    permuted = np.zeros_like(matrix)
    permuted[:, permutation] = matrix
    base_rank = len(gf2_rref(matrix)[1])
    joint_rank = len(gf2_rref(np.vstack([matrix, permuted]))[1])
    return base_rank == joint_rank


def build_decoder(stacked: np.ndarray, error_rate: float, max_iter: int,
                  osd_order: int, osd_method: str):
    try:
        from ldpc.bposd_decoder import BpOsdDecoder
    except ImportError:
        from ldpc import bposd_decoder as BpOsdDecoder  # ldpc 1.x
    try:
        return BpOsdDecoder(
            stacked,
            error_rate=error_rate,
            max_iter=max_iter,
            bp_method="minimum_sum",
            ms_scaling_factor=0.625,
            schedule="parallel",
            osd_method=osd_method,
            osd_order=osd_order,
        )
    except TypeError:
        return BpOsdDecoder(
            stacked,
            error_rate=error_rate,
            max_iter=max_iter,
            bp_method="ms",
            osd_method=osd_method,
            osd_order=osd_order,
        )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)
    parser.add_argument("--trials", type=int, required=True)
    parser.add_argument("--seed", type=int, default=1018)
    parser.add_argument("--osd-order", type=int, default=10)
    parser.add_argument("--osd-method", default="osd_cs")
    parser.add_argument("--error-rate", type=float, default=0.01)
    parser.add_argument("--max-iter", type=int, default=64)
    parser.add_argument("--target-weight", type=int, default=34)
    parser.add_argument("--time-budget", type=float, default=0.0,
                        help="stop after this many seconds (0 disables)")
    parser.add_argument("--random-priors", action="store_true",
                        help="resample per-coordinate channel priors each trial")
    parser.add_argument("--prior-low", type=float, default=0.002)
    parser.add_argument("--prior-high", type=float, default=0.30)
    parser.add_argument("--prior-fraction", type=float, default=0.06,
                        help="fraction of coordinates given the high prior")
    parser.add_argument("--refine", action="store_true",
                        help="local search around the incumbent witness")
    parser.add_argument("--refine-extra", type=int, default=40,
                        help="random coordinates added to the refine neighbourhood")
    parser.add_argument("--warm-start", default="",
                        help="prior helper record whose witness seeds the search")
    parser.add_argument("--symmetry-scan", action="store_true",
                        help="exactly minimise weight over each translation-"
                             "invariant subspace small enough to enumerate")
    parser.add_argument("--symmetry-max-dimension", type=int, default=26)
    parser.add_argument("--symmetry-isd-trials", type=int, default=0,
                        help="randomised information-set trials per invariant "
                             "subspace too large to enumerate")
    parser.add_argument("--symmetry-min-order", type=int, default=8)
    parser.add_argument("--symmetry-only", default="",
                        help="restrict to these generators, e.g. 0:9,3:0")
    parser.add_argument("--ell", type=int, default=21)
    parser.add_argument("--m", type=int, default=18)
    parser.add_argument("--certificate", default="",
                        help="assemble the C1018 distance certificate from a "
                             "comma-separated list of run evidence files "
                             "instead of searching")
    parser.add_argument("--sector-scan", default="",
                        help="exhaustive sector scan instead of BP-OSD; "
                             "comma-separated half-open coordinate windows, "
                             "e.g. 0:378,378:756")
    parser.add_argument("--out", required=True)
    args = parser.parse_args()

    out_path = pathlib.Path(args.out).expanduser()
    if out_path.exists():
        raise SystemExit(f"refusing to overwrite {out_path}")

    label, n, physical, logical, digest = load_instance(
        pathlib.Path(args.input).expanduser())
    stacked = np.vstack([physical, logical]).astype(np.uint8)
    check_count, logical_count = physical.shape[0], logical.shape[0]

    if args.symmetry_scan:
        started = time.time()
        rng = np.random.default_rng(args.seed)
        ell, m = args.ell, args.m
        generators = {}
        for shift_x in range(ell):
            for shift_y in range(m):
                if shift_x == 0 and shift_y == 0:
                    continue
                order = np.lcm(ell // np.gcd(shift_x, ell) if shift_x else 1,
                               m // np.gcd(shift_y, m) if shift_y else 1)
                generators[(shift_x, shift_y)] = int(order)
        # Verify the assumed group action against the actual check matrix.
        verified = all(
            preserves_row_space(physical,
                                translation_permutation(sx, sy, ell, m, n))
            for sx, sy in ((1, 0), (0, 1)))
        identity = np.arange(n)
        results = []
        best_weight = None
        best_support: list[int] = []
        if args.symmetry_only:
            wanted = set()
            for spec in args.symmetry_only.split(","):
                left, _, right = spec.partition(":")
                wanted.add((int(left), int(right)))
            candidates = [g for g in generators if g in wanted]
        else:
            candidates = sorted(
                (g for g, order in generators.items()
                 if order >= args.symmetry_min_order),
                key=lambda g: -generators[g])
        for shift_x, shift_y in candidates:
            permutation = translation_permutation(shift_x, shift_y, ell, m, n)
            shift_matrix = np.zeros((n, n), dtype=np.uint8)
            shift_matrix[identity, identity] ^= 1
            shift_matrix[identity, permutation] ^= 1
            invariant = kernel_basis(np.vstack([physical, shift_matrix]))
            dimension = invariant.shape[0]
            entry = {"generator": [shift_x, shift_y],
                     "order": generators[(shift_x, shift_y)],
                     "invariant_dimension": dimension,
                     "minimum_weight": None}
            support: list[int] = []
            weight = None
            if 0 < dimension <= args.symmetry_max_dimension:
                weight, support = enumerate_subspace(invariant, logical)
                entry["minimum_weight"] = weight
                entry["exact"] = True
            elif dimension and args.symmetry_isd_trials:
                deadline = (started + args.time_budget) if args.time_budget else None
                weight, support, done = information_set_scan(
                    invariant, logical, args.symmetry_isd_trials, rng,
                    deadline=deadline)
                entry["minimum_weight"] = weight
                entry["exact"] = False
                entry["information_set_trials"] = done
            if support:
                witness = np.zeros(n, dtype=np.uint8)
                witness[support] = 1
                assert not (physical @ witness % 2).any(), "witness fails checks"
                assert (logical @ witness % 2).any(), "witness is not logical"
                if best_weight is None or weight < best_weight:
                    best_weight, best_support = weight, support
            results.append(entry)
            if args.time_budget and time.time() - started > args.time_budget:
                break
        record = {
            "schema": "c1018-bb756-symmetry-scan-v1",
            "label": label,
            "coordinate_count": n,
            "input_sha256": digest,
            "ell": ell, "m": m,
            "group_action_verified_against_checks": bool(verified),
            "max_enumerated_dimension": args.symmetry_max_dimension,
            "elapsed_seconds": time.time() - started,
            "method": ("for each translation subgroup, exactly minimise weight "
                       "over the invariant logical operators; exact per "
                       "subgroup, hence an upper bound on d"),
            "subgroups": results,
            "result": {"distance_upper_bound": best_weight,
                       "witness": best_support},
        }
        with out_path.open("x", encoding="utf-8") as stream:
            json.dump(record, stream)
            stream.write("\n")
        scanned = [r for r in results if r["minimum_weight"] is not None]
        print(json.dumps({"upper_bound": best_weight,
                          "action_verified": bool(verified),
                          "subgroups_enumerated": len(scanned),
                          "subgroups_considered": len(results),
                          "elapsed_seconds": round(record["elapsed_seconds"], 2)}))
        return 0

    if args.certificate:
        exhaustions = []
        upper = []
        for spec in args.certificate.split(","):
            path = pathlib.Path(spec).expanduser()
            payload = json.loads(path.read_text())
            body = path.read_bytes()
            schema = payload.get("schema", "")
            entry = {
                "file": path.name,
                "sha256": hashlib.sha256(body).hexdigest(),
                "schema": schema,
            }
            if schema.startswith("ergodis-css-distance-native"):
                stats = payload["round_stats"][0]
                entry.update({
                    "searched_maximum_weight":
                        payload["result"]["searched_maximum_weight"],
                    "distance": payload["result"]["distance"],
                    "nontrivial_supports": stats["nontrivial_supports"],
                    "candidates": stats["candidates"],
                    "kernel_supports": stats["kernel_supports"],
                    "threads": payload["threads"],
                    "search_seconds": payload["search_seconds"],
                    "artifact_payload_blake3":
                        payload["artifact_payload_blake3"],
                    "certifies_distance_at_least":
                        payload["result"]["searched_maximum_weight"] + 2,
                })
                exhaustions.append(entry)
            else:
                entry.update({
                    "distance_upper_bound":
                        payload["result"]["distance_upper_bound"],
                    "witness_weight":
                        len(payload["result"].get("witness", [])) or None,
                })
                upper.append(entry)
        best_radius = max(e["searched_maximum_weight"] for e in exhaustions)
        witnessed = [e["distance_upper_bound"] for e in upper
                     if e["distance_upper_bound"] is not None]
        certificate = {
            "schema": "c1018-bb756-distance-certificate-v1",
            "task": "C1018",
            "code": "[[756,16,d]] bivariate-bicycle",
            "bivariate_bicycle_parameters": {
                "ell": 21, "m": 18, "direction": "x",
                "a_terms": [[3, 0], [0, 10], [0, 17]],
                "b_terms": [[0, 5], [3, 0], [19, 0]],
            },
            "input_sha256": digest,
            "coordinate_count": n,
            "physical_checks": check_count,
            "logical_observations": logical_count,
            "all_logical_weights_even": True,
            "even_weight_reason": ("the all-ones vector lies in the row space "
                                   "of the physical checks, so every kernel "
                                   "vector has even weight"),
            "exhaustions": sorted(exhaustions,
                                  key=lambda e: e["searched_maximum_weight"]),
            "upper_bound_attempts": sorted(upper, key=lambda e: e["file"]),
            "certified_lower_bound": best_radius + 2,
            "published_upper_bound": 34,
            "published_upper_bound_certified_here": False,
            "best_witness_weight_found_here": min(witnessed) if witnessed else None,
            "distance_interval": [best_radius + 2, 34],
            "admissible_distances": list(range(best_radius + 2, 35, 2)),
        }
        with out_path.open("x", encoding="utf-8") as stream:
            json.dump(certificate, stream, indent=2, sort_keys=True)
            stream.write("\n")
        print(json.dumps({"interval": certificate["distance_interval"],
                          "admissible": certificate["admissible_distances"]}))
        return 0

    if args.sector_scan:
        windows = []
        for spec in args.sector_scan.split(","):
            low, _, high = spec.partition(":")
            windows.append((int(low), int(high)))
        started = time.time()
        sectors = []
        best_weight = None
        best_support: list[int] = []
        for low, high in windows:
            weight, support, dimension, enumerated = exhaustive_sector_scan(
                physical, logical, low, high)
            if support:
                witness = np.zeros(n, dtype=np.uint8)
                witness[support] = 1
                assert not (physical @ witness % 2).any(), "witness fails checks"
                assert (logical @ witness % 2).any(), "witness is not logical"
            sectors.append({"window": [low, high], "kernel_dimension": dimension,
                            "combinations_enumerated": enumerated,
                            "minimum_weight": weight, "witness": support})
            if weight is not None and (best_weight is None or weight < best_weight):
                best_weight, best_support = weight, support
        record = {
            "schema": "c1018-bb756-sector-scan-v1",
            "label": label,
            "coordinate_count": n,
            "physical_checks": check_count,
            "logical_observations": logical_count,
            "input_sha256": digest,
            "elapsed_seconds": time.time() - started,
            "method": ("exhaustive enumeration of every logical operator whose "
                       "support lies inside one coordinate window; exact "
                       "minimum per window, hence an upper bound on d"),
            "sectors": sectors,
            "result": {"distance_upper_bound": best_weight,
                       "witness": best_support},
        }
        with out_path.open("x", encoding="utf-8") as stream:
            json.dump(record, stream)
            stream.write("\n")
        print(json.dumps({"upper_bound": best_weight,
                          "sectors": [(s["window"], s["kernel_dimension"],
                                       s["minimum_weight"]) for s in sectors],
                          "elapsed_seconds": round(record["elapsed_seconds"], 2)}))
        return 0

    decoder = build_decoder(stacked, args.error_rate, args.max_iter,
                            args.osd_order, args.osd_method)
    rng = np.random.default_rng(args.seed)

    best_weight = None
    best_support: list[int] = []
    best_class: list[int] = []
    if args.warm_start:
        seed_record = json.loads(
            pathlib.Path(args.warm_start).expanduser().read_text())["result"]
        if seed_record.get("witness"):
            best_weight = int(seed_record["distance_upper_bound"])
            best_support = list(seed_record["witness"])
            best_class = list(seed_record["logical_class"])
    completed = 0
    started = time.time()
    for _ in range(args.trials):
        if args.time_budget and time.time() - started > args.time_budget:
            break
        target = rng.integers(0, 2, size=logical_count, dtype=np.uint8)
        if not target.any():
            continue
        if args.refine and best_support:
            # Local search: stay in the incumbent's logical class and bias the
            # channel toward its support plus a fresh random neighbourhood.
            target = np.array(best_class, dtype=np.uint8)
            priors = np.full(n, args.prior_low, dtype=float)
            priors[best_support] = args.prior_high
            extra = rng.choice(n, size=args.refine_extra, replace=False)
            priors[extra] = args.prior_high
            decoder.error_channel = priors
        elif args.random_priors:
            priors = np.full(n, args.prior_low, dtype=float)
            hot = rng.choice(n, size=max(1, int(args.prior_fraction * n)),
                             replace=False)
            priors[hot] = args.prior_high
            decoder.error_channel = priors
        syndrome = np.concatenate(
            [np.zeros(check_count, dtype=np.uint8), target])
        candidate = np.asarray(decoder.decode(syndrome), dtype=np.uint8) & 1
        completed += 1
        # Independent GF(2) re-verification; never trust the decoder's word.
        if not np.array_equal((stacked @ candidate) % 2, syndrome):
            continue
        weight = int(candidate.sum())
        if best_weight is None or weight < best_weight:
            best_weight = weight
            best_support = np.flatnonzero(candidate).tolist()
            best_class = target.tolist()

    record = {
        "schema": "c1018-bb756-bposd-upper-v1",
        "label": label,
        "coordinate_count": n,
        "physical_checks": check_count,
        "logical_observations": logical_count,
        "input_sha256": digest,
        "requested_trials": args.trials,
        "completed_trials": completed,
        "seed": args.seed,
        "osd_method": args.osd_method,
        "osd_order": args.osd_order,
        "error_rate": args.error_rate,
        "max_iter": args.max_iter,
        "elapsed_seconds": time.time() - started,
        "method": ("stack physical checks over logical observations; decode "
                   "syndrome (0, c) for random nonzero logical class c with "
                   "BP-OSD; re-verify every witness over GF(2)"),
        "result": {
            "distance_upper_bound": best_weight,
            "witness": best_support,
            "logical_class": best_class,
            "beats_target_weight": (best_weight is not None
                                    and best_weight <= args.target_weight),
        },
    }
    with out_path.open("x", encoding="utf-8") as stream:
        json.dump(record, stream)
        stream.write("\n")
    print(json.dumps({"upper_bound": best_weight,
                      "completed_trials": completed,
                      "elapsed_seconds": round(record["elapsed_seconds"], 2)}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
