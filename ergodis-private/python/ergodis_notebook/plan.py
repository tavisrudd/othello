"""Building candidate plans, and lowering expressions to the bytecode the
control socket accepts.

A plan is a document under `ergodis-attack-plan-v0`.  It exists in two surface
forms -- a readable expression tree and a flat stack-machine program -- but the
campaign's `candidate-try` and `candidate-apply` ops deserialize the **bytecode
form only**: sending an expression document over the socket is rejected with
"unknown field `expr`".  Lowering therefore happens on this side, mirroring
`ExpressionPlanSpec::lower` in the core, including its limits.

The vocabulary is deliberately small.  `field` and `const` are the leaves;
`add`, `sub`, `mul`, `min`, `max`, `eq`, `ne`, `lt`, `le`, `gt`, `ge`, `and`,
and `or` are binary; `not` and `abs` are unary; `select` is the one ternary.
"""

from __future__ import annotations

from typing import Any, Iterable

from .control import PLAN_SCHEMA, ControlError

MAX_PLAN_OPS = 128
MAX_PLAN_DEPTH = 32

BINARY_OPS = frozenset(
    {"add", "sub", "mul", "min", "max", "eq", "ne", "lt", "le", "gt", "ge", "and", "or"}
)
UNARY_OPS = frozenset({"not", "abs"})


# -- expression constructors -------------------------------------------------


def field(name: str) -> dict[str, Any]:
    """A batch feature, by the name it has in the campaign's `fields` list."""
    return {"op": "field", "name": name}


def const(value: int) -> dict[str, Any]:
    return {"op": "const", "value": int(value)}


def binary(op: str, left: dict[str, Any], right: dict[str, Any]) -> dict[str, Any]:
    if op not in BINARY_OPS:
        raise ControlError(f"{op} is not a binary plan operation")
    return {"op": op, "left": left, "right": right}


def unary(op: str, arg: dict[str, Any]) -> dict[str, Any]:
    if op not in UNARY_OPS:
        raise ControlError(f"{op} is not a unary plan operation")
    return {"op": op, "arg": arg}


def select(
    condition: dict[str, Any], then_value: dict[str, Any], else_value: dict[str, Any]
) -> dict[str, Any]:
    return {
        "op": "select",
        "condition": condition,
        "then": then_value,
        "else": else_value,
    }


# -- lowering ----------------------------------------------------------------


def lower(expr: dict[str, Any]) -> list[dict[str, Any]]:
    """Compile an expression tree to a flat stack-machine program.

    Postorder: operands are emitted before the operator that consumes them.
    The node and depth limits match the core's, so a program accepted here is
    accepted there.
    """
    program: list[dict[str, Any]] = []
    nodes = 0

    def emit(node: dict[str, Any], depth: int) -> None:
        nonlocal nodes
        nodes += 1
        if nodes > MAX_PLAN_OPS or depth > MAX_PLAN_DEPTH:
            raise ControlError("expression plan exceeds node or depth limit")
        op = node.get("op")
        if op == "field":
            program.append({"op": "field", "name": node["name"]})
        elif op == "const":
            program.append({"op": "const", "value": int(node["value"])})
        elif op in UNARY_OPS:
            emit(node["arg"], depth + 1)
            program.append({"op": op})
        elif op == "select":
            emit(node["condition"], depth + 1)
            emit(node["then"], depth + 1)
            emit(node["else"], depth + 1)
            program.append({"op": "select"})
        elif op in BINARY_OPS:
            emit(node["left"], depth + 1)
            emit(node["right"], depth + 1)
            program.append({"op": op})
        else:
            raise ControlError(f"unknown plan operation {op!r}")

    emit(expr, 1)
    if len(program) > MAX_PLAN_OPS:
        raise ControlError("lowered expression exceeds VM operation limit")
    return program


def plan(
    name: str,
    expr: dict[str, Any],
    role: str = "diagnostic",
    output: str = "predicate",
    scope: tuple[str, Iterable[int]] | None = None,
) -> dict[str, Any]:
    """Build a bytecode plan document ready to send to a campaign.

    `role` is `diagnostic` or `ordering`; `output` is `predicate` or `score`.

    `scope` is `(field_name, values)`.  The mask is a **membership bitset
    indexed by the field's value**, not a bitwise AND mask: scoping to
    `root_orbit == 6` sets bit 6, giving mask 64.  The two readings disagree on
    almost every value, so the mask is built here from the values themselves
    rather than written by hand.
    """
    if role not in {"diagnostic", "ordering"}:
        raise ControlError("role must be 'diagnostic' or 'ordering'")
    if output not in {"predicate", "score"}:
        raise ControlError("output must be 'predicate' or 'score'")

    document: dict[str, Any] = {
        "schema": PLAN_SCHEMA,
        "name": name,
        "role": role,
        "output": output,
        "program": lower(expr),
    }
    if scope is not None:
        scope_field, values = scope
        document["scope"] = {"field": scope_field, "mask": scope_mask(values)}
    return document


def scope_mask(values: Iterable[int]) -> int:
    """Membership bitset over field values in `0..64`."""
    mask = 0
    for value in values:
        if not 0 <= value < 64:
            raise ControlError(f"scope value {value} is outside 0..64")
        mask |= 1 << value
    return mask
