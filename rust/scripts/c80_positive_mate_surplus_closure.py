#!/usr/bin/env python3
"""C80: test positive-mate-surplus closure of strict-overload certificates.

Let mu(S) be the minimum, over legal moves x, of the number of legal replies
after x.  Above overload zero, define F_mu recursively by requiring mu(S)>0
and, after every opponent move, a legal reply into a strictly lower-Omega
state of F_mu.  At overload zero use the proved structural copycat boundary
B_cc, without imposing mu>0 (terminal P boundaries remain admissible).

This is the exact recursive version of the proposed "avoid premature
absorption" gate.  It tests the complete frozen q=13/q=17 escape-root domains
and the previously certified q=19 control root.

Run:
  python3 rust/scripts/c80_positive_mate_surplus_closure.py
Check:
  python3 rust/scripts/c80_positive_mate_surplus_closure.py --check
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import tempfile
from collections import Counter
from functools import lru_cache
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_adaptive_copycat_survivor.py"
ROWS = ROOT / "notes/data/c20-q13-q17-states.jsonl.gz"
OUT = ROOT / "notes/2026-07-25-c80-positive-mate-surplus-closure.json"
Q19_LABEL = (15, 16, 17, 18)


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BASE = load_module(SOURCE, "c80_mate_surplus_base")
BITS = BASE.BASE.GEOMETRY.bits


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def mask_digest(masks) -> str:
    rows = "\n".join(str(mask) for mask in sorted(masks))
    return hashlib.sha256(rows.encode()).hexdigest()


class MateSurplusKernel(BASE.CopycatKernel):
    """Strict-Omega survivor whose every positive state has mu > 0."""

    def __init__(self, q: int):
        super().__init__(q)
        self.positive_states: set[int] = set()
        self.rejections = Counter()
        self.failed_marked_fibres: dict[tuple[int, int], dict] = {}
        self.contains_cache_start = self.contains.cache_info().currsize

    @lru_cache(maxsize=None)
    def mate_counts(self, mask: int) -> tuple[tuple[int, int], ...]:
        return tuple(
            (move, self.game.legal_mask(mask | (1 << move)).bit_count())
            for move in BITS(self.game.legal_mask(mask))
        )

    def mate_surplus(self, mask: int) -> int | None:
        counts = self.mate_counts(mask)
        return min((count for _move, count in counts), default=None)

    @lru_cache(maxsize=None)
    def contains(self, mask: int) -> bool:
        old_omega = self.omega(mask)
        if old_omega == 0:
            witness = self.copycat_witness(mask)
            if witness is not None:
                self.boundary.add(mask)
                self.copycat_boundary[mask] = witness
                return True
            self.rejections["boundary_not_B_cc"] += 1
            return False

        mu = self.mate_surplus(mask)
        if mu is None or mu == 0:
            self.rejections["positive_state_mu_zero"] += 1
            return False

        for opponent in BITS(self.game.legal_mask(mask)):
            child = mask | (1 << opponent)
            reply_rows = []
            witness = None
            for reply in BITS(self.game.legal_mask(child)):
                target = child | (1 << reply)
                target_omega = self.omega(target)
                if target_omega >= old_omega:
                    continue
                target_mu = self.mate_surplus(target)
                accepted = self.contains(target)
                reply_rows.append(
                    (reply, target, target_omega, target_mu, accepted)
                )
                if accepted:
                    witness = reply
                    break
            if witness is None:
                self.rejections["uncovered_marked_opponent"] += 1
                self.failed_marked_fibres[(mask, opponent)] = {
                    "strict_reply_count": len(reply_rows),
                    "strict_positive_mu_reply_count": sum(
                        target_omega == 0 or (target_mu is not None and target_mu > 0)
                        for _reply, _target, target_omega, target_mu, _accepted
                        in reply_rows
                    ),
                    "accepted_reply_count": sum(
                        accepted
                        for _reply, _target, _target_omega, _target_mu, accepted
                        in reply_rows
                    ),
                }
                return False
            self.responses[(mask, opponent)] = witness
        self.positive_states.add(mask)
        return True


def direct_mate_count(kernel: MateSurplusKernel, mask: int, move: int) -> int:
    """Independent determinant-level count of replies after one legal move."""
    selected = [0, 1] + [cell + 2 for cell in BITS(mask | (1 << move))]
    count = 0
    for reply in BITS(kernel.game.legal_mask(mask)):
        if reply == move:
            continue
        point = reply + 2
        if all(
            not kernel.game.collinear(
                kernel.game.points[selected[i]],
                kernel.game.points[selected[j]],
                kernel.game.points[point],
            )
            for i in range(len(selected))
            for j in range(i + 1, len(selected))
        ):
            count += 1
    return count


def obstruction_row(
    kernel: MateSurplusKernel, root: int, label: tuple[int, ...]
) -> dict | None:
    """Return the first canonical rejected fibre reachable in the failed proof."""
    if kernel.contains(root):
        return None
    candidates = [
        (mask.bit_count(), kernel.omega(mask), mask, opponent)
        for mask, opponent in kernel.failed_marked_fibres
    ]
    if not candidates:
        return {
            "root": list(label),
            "reason": "root_or_descendant_has_mu_zero_before_a_marked_fibre",
        }
    _size, _omega, mask, opponent = min(candidates)
    child = mask | (1 << opponent)
    replies = []
    for reply in BITS(kernel.game.legal_mask(child)):
        target = child | (1 << reply)
        target_omega = kernel.omega(target)
        if target_omega >= kernel.omega(mask):
            continue
        target_mu = kernel.mate_surplus(target)
        replies.append(
            {
                "reply": list(kernel.game.cell_tuple(reply)),
                "target_mask": target,
                "target_omega": target_omega,
                "target_mu": target_mu,
                "mate_closure": kernel.contains(target),
            }
        )
    counts = dict(kernel.mate_counts(mask))
    direct = direct_mate_count(kernel, mask, opponent)
    assert direct == counts[opponent]
    return {
        "root": list(label),
        "state_mask": mask,
        "selected_size": mask.bit_count(),
        "state_omega": kernel.omega(mask),
        "state_mu": kernel.mate_surplus(mask),
        "opponent": list(kernel.game.cell_tuple(opponent)),
        "opponent_mate_count": counts[opponent],
        "independent_determinant_mate_count": direct,
        "strict_replies": replies,
    }


def run_order(q: int, labels: list[tuple[int, ...]]) -> dict:
    kernel = MateSurplusKernel(q)
    records = []
    for label in labels:
        mask = kernel.game.base_mask(label)
        accepted = kernel.contains(mask)
        exact_value = "N" if kernel.game.value(mask) else "P"
        records.append(
            {
                "t4": list(label),
                "omega": kernel.omega(mask),
                "mu": kernel.mate_surplus(mask),
                "mate_surplus_survivor": accepted,
                "exact_cap_value": exact_value,
                "first_obstruction": (
                    obstruction_row(kernel, mask, label)
                    if exact_value == "P" and not accepted
                    else None
                ),
            }
        )
    positive_mu_histogram = Counter(
        kernel.mate_surplus(mask) for mask in kernel.positive_states
    )
    accepted_responses = {
        (mask, opponent): reply
        for (mask, opponent), reply in kernel.responses.items()
        if mask in kernel.positive_states
    }
    assert all(
        sum(state == mask for state, _opponent in accepted_responses)
        == kernel.game.legal_mask(mask).bit_count()
        for mask in kernel.positive_states
    )
    accepted_response_rows = "\n".join(
        f"{mask}:{opponent}:{reply}"
        for (mask, opponent), reply in sorted(accepted_responses.items())
    )
    chosen_target_histogram = Counter()
    for (mask, opponent), reply in accepted_responses.items():
        target = mask | (1 << opponent) | (1 << reply)
        target_omega = kernel.omega(target)
        if target_omega == 0:
            chosen_target_histogram["B_cc"] += 1
        else:
            chosen_target_histogram[str(kernel.mate_surplus(target))] += 1

    mate_count_self_checks = []
    if kernel.positive_states:
        minimum_state = min(
            kernel.positive_states,
            key=lambda mask: (
                kernel.mate_surplus(mask),
                mask.bit_count(),
                kernel.omega(mask),
                mask,
            ),
        )
        minimum_move, cached_count = min(
            kernel.mate_counts(minimum_state), key=lambda row: (row[1], row[0])
        )
        direct_count = direct_mate_count(kernel, minimum_state, minimum_move)
        assert direct_count == cached_count
        mate_count_self_checks.append(
            {
                "state_mask": minimum_state,
                "selected_size": minimum_state.bit_count(),
                "omega": kernel.omega(minimum_state),
                "move": list(kernel.game.cell_tuple(minimum_move)),
                "legal_mask_count": cached_count,
                "independent_determinant_count": direct_count,
            }
        )
    return {
        "q": q,
        "domain": (
            "frozen escape-root domain"
            if q in (13, 17)
            else "single previously certified q19 control root"
        ),
        "roots": len(records),
        "survivor_roots": sum(row["mate_surplus_survivor"] for row in records),
        "exact_p_roots": sum(row["exact_cap_value"] == "P" for row in records),
        "accepted_root_labels": [
            row["t4"] for row in records if row["mate_surplus_survivor"]
        ],
        "positive_states": len(kernel.positive_states),
        "positive_state_mask_sha256": mask_digest(kernel.positive_states),
        "positive_mu_histogram": dict(sorted(positive_mu_histogram.items())),
        "chosen_response_target_histogram": dict(
            sorted(chosen_target_histogram.items())
        ),
        "mate_count_self_checks": mate_count_self_checks,
        "copycat_boundary_states": len(kernel.copycat_boundary),
        "copycat_boundary_mask_sha256": mask_digest(kernel.copycat_boundary),
        "certified_response_edges": len(accepted_responses),
        "response_map_sha256": hashlib.sha256(
            accepted_response_rows.encode()
        ).hexdigest(),
        "rejection_histogram": dict(sorted(kernel.rejections.items())),
        "failed_marked_fibres": len(kernel.failed_marked_fibres),
        "survivor_iff_exact_p_on_domain": all(
            row["mate_surplus_survivor"] == (row["exact_cap_value"] == "P")
            for row in records
        ),
        "records": records,
    }


def payload() -> dict:
    orders = [
        run_order(q, BASE.BASE.escape_parameters(ROWS, q))
        for q in (13, 17)
    ]
    orders.append(run_order(19, [Q19_LABEL]))
    return {
        "schema": "c80-positive-mate-surplus-closure-v1",
        "claim_scope": (
            "Exact finite recursive gate. At positive overload every accepted "
            "state has positive minimum legal-mate count and every opponent has "
            "a strict-overload reply to a lower accepted state. Overload-zero "
            "states use the structural B_cc boundary. No uniform odd-q claim."
        ),
        "orders": orders,
        "source": {
            "copycat_survivor_script": str(SOURCE.relative_to(ROOT)),
            "copycat_survivor_script_sha256": sha256(SOURCE),
            "frozen_rows": str(ROWS.relative_to(ROOT)),
            "frozen_rows_sha256": sha256(ROWS),
        },
    }


def write_output(path: Path) -> None:
    path.write_text(json.dumps(payload(), indent=2, sort_keys=True) + "\n")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        with tempfile.TemporaryDirectory() as directory:
            regenerated = Path(directory) / OUT.name
            write_output(regenerated)
            if not OUT.exists() or regenerated.read_bytes() != OUT.read_bytes():
                raise SystemExit("certificate mismatch")
        print(f"PASS {OUT.relative_to(ROOT)}")
        return
    write_output(OUT)
    for order in json.loads(OUT.read_text())["orders"]:
        print(
            f"q={order['q']} survivor={order['survivor_roots']}/"
            f"{order['roots']} positive_states={order['positive_states']} "
            f"failed_fibres={order['failed_marked_fibres']}"
        )


if __name__ == "__main__":
    main()
