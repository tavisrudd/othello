#!/usr/bin/env sage
"""Exact q=169 first-wall check for the C665 uniform spill.

This specializes the generic first-wall construction to p=13, s=6.  It
is deliberately the first field that separates the two candidate trace
formulas: p-2-s=5, whereas s/2=3.
"""

import argparse
import importlib.machinery
import importlib.util
import json
from pathlib import Path

from sage.all import GF, matrix


HERE = Path(__file__).resolve().parent
CONNECTING_PATH = HERE / "2026-07-29-c665-q121-connecting-functional.sage"
CERTIFICATE = HERE / "2026-07-29-c665-q169-wall-check.json"


def load_module(name, path):
    loader = importlib.machinery.SourceFileLoader(name, str(path))
    spec = importlib.util.spec_from_loader(loader.name, loader)
    if spec is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


def calculate():
    connecting = load_module("c665_q169_connecting", CONNECTING_PATH)
    domain = connecting.domain
    h1 = connecting.h1
    base = connecting.base

    p = 13
    q = p * p
    field = GF(q, name="a")
    generator = field.gen()
    degree = (q - 3) // 2
    a = (p - 3) // 2
    b = (p - 1) // 2
    nonsquare = field.multiplicative_generator()
    parameters = (field.one(), generator)

    base.P = p
    base.Q = q
    base.FIELD = field
    base.A = generator
    base.DEGREE = degree
    base.TORUS_MODULUS = q - 1

    domain.FIELD = field
    domain.P = p
    domain.A = generator
    domain.MODULUS = q - 1
    domain.NONSQUARE = nonsquare
    domain.PARAMETERS = parameters

    connecting.FIELD = field
    connecting.P = p
    connecting.A = generator
    connecting.MODULUS = q - 1
    connecting.NONSQUARE = nonsquare
    connecting.PARAMETERS = parameters

    h1.FIELD = field
    h1.P = p
    h1.A = generator
    h1.base = base

    actions = [
        base.binary_translation(parameter, degree)
        for parameter in parameters
    ] + [base.binary_inversion(degree)]
    bottom_indices = tuple(
        digit0 + p * digit1
        for digit0 in range(a + 1)
        for digit1 in range(b + 1)
    )
    bottom_set = set(bottom_indices)
    upper_indices = tuple(
        index for index in range(degree + 1) if index not in bottom_set
    )
    order = bottom_indices + upper_indices
    position = {old: new for new, old in enumerate(order)}
    adapted = [
        matrix(
            field,
            degree + 1,
            degree + 1,
            {
                (position[row], position[column]): value
                for (row, column), value in action.dict().items()
            },
        )
        for action in actions
    ]
    bottom_dimension = len(bottom_indices)
    assert bottom_dimension * 2 == degree + 1
    bottom_actions = tuple(
        action[:bottom_dimension, :bottom_dimension] for action in adapted
    )
    upper_actions = tuple(
        action[bottom_dimension:, bottom_dimension:] for action in adapted
    )
    extension_blocks = tuple(
        action[:bottom_dimension, bottom_dimension:] for action in adapted
    )
    weights = tuple(degree - 2 * index for index in order)
    bottom_weights = weights[:bottom_dimension]
    upper_weights = weights[bottom_dimension:]
    bottom = connecting.MatrixModule(
        "B=L(5,6)",
        bottom_actions,
        bottom_weights,
        tuple(nonsquare ** (weight // 2) for weight in bottom_weights),
    )
    upper = connecting.MatrixModule(
        "A=L(6,5)",
        upper_actions,
        upper_weights,
        tuple(nonsquare ** (weight // 2) for weight in upper_weights),
    )
    c0 = connecting.CachedModule(domain.SymmetricSquareModule(bottom))
    middle = connecting.CachedModule(domain.TensorModule(bottom, upper))
    c2 = connecting.CachedModule(domain.SymmetricSquareModule(upper))
    d1, _d2 = connecting.adjacent_cochains(
        bottom,
        upper,
        extension_blocks,
        c0.module,
        middle.module,
        c2.module,
    )

    cache = {}

    def factor_maps(layer, digits):
        key = (id(layer), tuple(digits))
        if key not in cache:
            simple = domain.SimpleModule(tuple(digits))
            cache[key] = (
                simple,
                *connecting.normalized_factor_maps(layer, simple),
            )
        return cache[key]

    source_degree = 6
    source = domain.SimpleModule((source_degree, 0))
    t_digits = (p - 2, 1)
    r_digits = (p - 2 - source_degree, 1)
    y_digits = (0, 2)
    t_simple, _, i_t, _ = factor_maps(middle, t_digits)
    r_simple, _, i_r, _ = factor_maps(middle, r_digits)
    y_simple, _, _, p_y = factor_maps(c0, y_digits)
    _, _, _, p_source = factor_maps(c0, (source_degree, 0))

    trace_target = domain.TensorModule(r_simple, t_simple)
    trace_hom, trace_homs = connecting.hom_basis(source, trace_target)
    assert trace_hom["dimension"] == 1
    d1_to_source = tuple(
        p_source * value * i_r for value in d1[:2]
    )
    trace_values = connecting.traced_m_cross_row(
        source,
        trace_homs[0],
        r_simple,
        t_simple,
        d1_to_source,
    )
    trace_scalar = connecting.h1_scalar(trace_values, t_simple)
    assert trace_scalar == field(p - 2 - source_degree)

    spill_target = domain.TensorModule(t_simple, r_simple)
    spill_hom, spill_homs = connecting.hom_basis(source, spill_target)
    assert spill_hom["dimension"] == 1
    d1_to_y = tuple(p_y * value * i_t for value in d1[:2])
    source_inverses = tuple(
        action**-1 for action in source.actions[:2]
    )
    spill_values = tuple(
        d1_to_y[which].tensor_product(r_simple.actions[which])
        * spill_homs[0]
        * source_inverses[which]
        for which in range(2)
    )
    spill_supports = [len(value.dict()) for value in spill_values]
    assert all(spill_supports)

    torus_fixed_cochains = sum(
        (target_weight - source_weight) % (q - 1) == 0
        for target_weight in domain.TensorModule(
            y_simple, r_simple
        ).weights
        for source_weight in source.weights
    )
    assert torus_fixed_cochains == 0

    return {
        "schema": 1,
        "p": p,
        "q": q,
        "source": [source_degree, 0],
        "T": list(t_digits),
        "R": list(r_digits),
        "Y": list(y_digits),
        "trace_hom": trace_hom,
        "trace_scalar": connecting.field_coordinates(trace_scalar),
        "p_minus_2_minus_s": p - 2 - source_degree,
        "s_over_2": source_degree // 2,
        "spill_hom": spill_hom,
        "spill_supports": spill_supports,
        "spill_block_ranks": [value.rank() for value in d1_to_y],
        "torus_fixed_cochains": torus_fixed_cochains,
        "conclusion": (
            "the q=169 first wall has nonzero scalar 5 and a nonzero "
            "spill into a component with no torus-fixed cochain"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = calculate()
    rendered = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.write:
        CERTIFICATE.write_text(rendered)
        print(f"wrote {CERTIFICATE.name}")
    else:
        assert CERTIFICATE.read_text() == rendered
        print("C665 q=169 first-wall certificate OK")


if __name__ == "__main__":
    main()
