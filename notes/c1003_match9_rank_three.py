#!/usr/bin/env python3
"""Exact C1003 checks for the four MATCH(9,4,1) deletion classes.

Run inside the arcs paper's ``manuscript-cas`` Nix shell so that Singular is
on PATH.  The script treats the tracked MATCH(10,5,1) JSON as input; it does
not re-enumerate Mathon's two classes.
"""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
from pathlib import Path
import re
import subprocess


ROOT = Path(__file__).resolve().parents[1]
CHECKER = ROOT / "papers/arcs_complete_outside_conic/check_match10_rank_three.py"
DATA = CHECKER.with_suffix(".json")


def load_checker():
    spec = importlib.util.spec_from_file_location("match10", CHECKER)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


M10 = load_checker()


def reduce_design(parent, deleted: int):
    old_vertices = [vertex for vertex in range(10) if vertex != deleted]
    relabel = {vertex: index for index, vertex in enumerate(old_vertices)}
    design = []
    for block in parent:
        reduced = tuple(
            sorted(
                tuple(sorted((relabel[a], relabel[b])))
                for a, b in block
                if deleted not in (a, b)
            )
        )
        assert len(reduced) == 4
        design.append(reduced)
    return tuple(sorted(design))


def validate_match9(design) -> None:
    assert len(design) == 63 and len(set(design)) == 63
    pairs = {}
    edge_counts = {edge: 0 for edge in itertools.combinations(range(9), 2)}
    omissions = {vertex: 0 for vertex in range(9)}
    for block in design:
        used = {vertex for edge in block for vertex in edge}
        assert len(block) == 4 and len(used) == 8
        omissions[next(iter(set(range(9)) - used))] += 1
        for edge in block:
            edge_counts[edge] += 1
        for pair in itertools.combinations(block, 2):
            key = tuple(sorted(pair))
            pairs[key] = pairs.get(key, 0) + 1
    assert len(pairs) == 378 and set(pairs.values()) == {1}
    assert set(edge_counts.values()) == {7}
    assert set(omissions.values()) == {7}


def complete_design(design):
    completed = []
    for block in design:
        used = {vertex for edge in block for vertex in edge}
        omitted = next(iter(set(range(9)) - used))
        completed.append(tuple(sorted(block + ((omitted, 9),))))
    result = tuple(sorted(completed))
    M10.validate_matching_design(result)
    return result


def perfect_matchings(vertices):
    vertices = tuple(vertices)
    if not vertices:
        return [()]
    first = vertices[0]
    answer = []
    for index in range(1, len(vertices)):
        second = vertices[index]
        rest = vertices[1:index] + vertices[index + 1 :]
        edge = tuple(sorted((first, second)))
        for tail in perfect_matchings(rest):
            answer.append(tuple(sorted((edge,) + tail)))
    return answer


def factorization_pair_dictionary():
    vertices = tuple(range(6))
    matchings = perfect_matchings(vertices)
    all_edges = set(itertools.combinations(vertices, 2))
    factorizations = []
    for indices in itertools.combinations(range(15), 5):
        edges = [edge for index in indices for edge in matchings[index]]
        if len(set(edges)) == 15 and set(edges) == all_edges:
            factorizations.append(frozenset(indices))
    assert len(factorizations) == 6
    dictionary = {}
    for index, matching in enumerate(matchings):
        owners = tuple(
            factorization_index
            for factorization_index, factorization in enumerate(factorizations)
            if index in factorization
        )
        assert len(owners) == 2
        dictionary[matching] = owners
    return dictionary


FACTORIZATION_PAIR = factorization_pair_dictionary()


def local_obstruction(design):
    for six_set in itertools.combinations(range(9), 6):
        local = {vertex: index for index, vertex in enumerate(six_set)}
        six = set(six_set)
        supported = []
        supporting_blocks = []
        for block in design:
            inside = tuple(sorted(edge for edge in block if set(edge) <= six))
            if len(inside) == 3:
                supported.append(
                    tuple(
                        sorted(
                            tuple(sorted((local[a], local[b]))) for a, b in inside
                        )
                    )
                )
                supporting_blocks.append(block)
        adjacency = [set() for _ in range(6)]
        for matching in supported:
            first, second = FACTORIZATION_PAIR[matching]
            adjacency[first].add(second)
            adjacency[second].add(first)
        unseen = set(range(6))
        components = []
        while unseen:
            seed = min(unseen)
            stack = [seed]
            component = set()
            while stack:
                vertex = stack.pop()
                if vertex in component:
                    continue
                component.add(vertex)
                stack.extend(adjacency[vertex] - component)
            unseen -= component
            components.append(component)
        cluster = all(
            right in adjacency[left]
            for component in components
            for left in component
            for right in component
            if left != right
        )
        odd_component = any(len(component) % 2 for component in components)
        if not (cluster and odd_component):
            return {
                "six_set": six_set,
                "supported_count": len(supported),
                "component_sizes": tuple(sorted(map(len, components))),
                "supporting_blocks": tuple(supporting_blocks),
            }
    return None


def equations(design):
    variables = tuple(
        variable
        for vertex in range(4, 9)
        for variable in (f"x{vertex}", f"y{vertex}")
    )
    points = (
        ("1", "0", "0"),
        ("0", "1", "0"),
        ("0", "0", "1"),
        ("1", "1", "1"),
    ) + tuple((f"x{vertex}", f"y{vertex}", "1") for vertex in range(4, 9))
    result = []
    metadata = []
    for block_index, block in enumerate(design):
        lines = [M10.polynomial_cross(points[a], points[b]) for a, b in block]
        for line_index, line in enumerate(lines[2:], start=3):
            result.append(M10.polynomial_determinant(lines[0], lines[1], line))
            metadata.append((block_index, block, line_index))
    assert len(result) == 126
    return variables, result, metadata


def singular(program: str) -> str:
    completed = subprocess.run(
        ["Singular", "-q"],
        input=program,
        text=True,
        capture_output=True,
        check=True,
    )
    return completed.stdout


def groebner(design, characteristic: int, *, ordering: str = "lp"):
    variables, polys, _ = equations(design)
    program = "\n".join(
        [
            f"ring r={characteristic},({','.join(variables)},u),{ordering};",
            f"ideal I={','.join(polys)},u*x8*(x8-1)-1;",
            "ideal G=std(I);",
            'print("SIZE");print(size(G));print("DIM");print(dim(G));',
            'print("UNIT");if(size(G)==1 && G[1]==1){print(1);}else{print(0);}',
            'print("BASIS");print(G);quit;',
        ]
    )
    output = singular(program)
    lines = [line.strip() for line in output.splitlines() if line.strip()]
    positions = {label: lines.index(label) for label in ("SIZE", "DIM", "UNIT", "BASIS")}
    return {
        "size": int(lines[positions["SIZE"] + 1]),
        "dimension": int(lines[positions["DIM"] + 1]),
        "unit": int(lines[positions["UNIT"] + 1]),
        "basis": tuple(lines[positions["BASIS"] + 1 :]),
    }


ODD_BASIS = (
    "x8-y8,",
    "y7-y8,",
    "x7-y8,",
    "y6-x8,",
    "x6+y7-x8-y8,",
    "y5-y8,",
    "x5-y7,",
    "y4+y7-x8-y8,",
    "x4+y5-x8-y8,",
    "y8^2-y5+y7-y8",
)


CHAR2_BASES = {
    0: (
        "u^3+u^2+1,",
        "y8+u,",
        "x8+y8^3+y8^2+y8,",
        "y7+x8^2+x8*y8+x8+y8^2+y8,",
        "x7+y8^2,",
        "y6+x7,",
        "x6+y8,",
        "y5+x6+y6+x8,",
        "x5+y5+x7+y7,",
        "y4+x8,",
        "x4+y5",
    ),
    9: (
        "u^3+u^2+1,",
        "y8+u+1,",
        "x8+y8^3,",
        "y7+x8^2+x8*y8+y8^2,",
        "x7+y8,",
        "y6+x8,",
        "x6+y6+x7+y7,",
        "y5+x7*y8+x8+y8,",
        "x5+y7,",
        "y4+x6,",
        "x4+y4+x5+y5",
    ),
}


def odd_integral_lift(design):
    variables, polys, _ = equations(design)
    target = ",".join(item.rstrip(",") for item in ODD_BASIS)
    program = "\n".join(
        [
            f"ring r=0,({','.join(variables)}),dp;",
            f"ideal I={','.join(polys)};",
            f"ideal K={target};",
            "matrix T=lift(I,K);",
            "matrix E=matrix(K)-matrix(I)*T;",
            'print("IDENTITY");print(E);print("MATRIX");print(T);quit;',
        ]
    )
    output = singular(program)
    prefix, matrix = output.split("MATRIX\n", 1)
    identity = prefix.split("IDENTITY\n", 1)[1]
    assert set(identity.replace(",", "").replace(" ", "").replace("\n", "")) <= {"0"}
    denominators = {int(value) for value in re.findall(r"/([0-9]+)", matrix)}

    def prime_divisors(value: int):
        result = set()
        divisor = 2
        while divisor * divisor <= value:
            while value % divisor == 0:
                result.add(divisor)
                value //= divisor
            divisor += 1
        if value > 1:
            result.add(value)
        return result

    primes = sorted(
        set().union(*(prime_divisors(value) for value in denominators))
        if denominators
        else set()
    )
    return {
        "identity_verified": True,
        "denominator_primes": primes,
        "matrix_bytes": len(matrix.encode()),
        "matrix_sha256": hashlib.sha256(matrix.encode()).hexdigest(),
    }


def seven_equation_core(design):
    variables, polys, metadata = equations(design)
    indices = (30, 108, 100, 75, 56, 76, 64)
    chosen = [polys[index] for index in indices]
    eliminate = "x4*y4*x5*y5*x6*y6*x7*y7*y8"
    program = "\n".join(
        [
            f"ring r=0,({','.join(variables)}),dp;",
            f"ideal I={','.join(chosen)};",
            f"ideal E=eliminate(I,{eliminate});",
            'print("ELIMINATION");print(E);quit;',
        ]
    )
    output = singular(program)
    polynomial = output.split("ELIMINATION\n", 1)[1].strip()
    assert polynomial == "x8^4-2*x8^3+x8^2"
    return {
        "equation_indices": indices,
        "constraints": tuple(metadata[index] for index in indices),
        "elimination_polynomial": polynomial,
    }


def main() -> None:
    data = json.loads(DATA.read_text())
    classes = {entry["name"]: entry for entry in data["classes"]}
    report = {
        "schema": "c1003-match9-rank-three-v1",
        "source_json_sha256": hashlib.sha256(DATA.read_bytes()).hexdigest(),
        "deletions": {},
        "algebra": {},
    }
    reduced = {}
    for name, entry in classes.items():
        parent = tuple(tuple(tuple(edge) for edge in block) for block in entry["matching_design"])
        for deleted in range(10):
            design = reduce_design(parent, deleted)
            validate_match9(design)
            completion = complete_design(design)
            key = f"{name}:delete-{deleted}"
            reduced[key] = design
            report["deletions"][key] = {
                "completion_sha256": M10.digest_object(completion),
                "local_obstruction": local_obstruction(design),
            }

    local_survivors = tuple(
        key
        for key, result in report["deletions"].items()
        if result["local_obstruction"] is None
    )
    assert local_survivors == ("classical-hyperoval:delete-9",)
    report["local_survivors"] = local_survivors

    # Labels 0 and 9 represent the two pointed-orbits in each Mathon class.
    for deleted in (0, 9):
        key = f"classical-hyperoval:delete-{deleted}"
        result = groebner(reduced[key], 2)
        assert result["unit"] == 0 and result["basis"] == CHAR2_BASES[deleted]
        report["algebra"][key + ":char2"] = result
    for deleted in (0, 9):
        key = f"mathon-nonhyperoval:delete-{deleted}"
        result = groebner(reduced[key], 2)
        assert result["unit"] == 1
        report["algebra"][key + ":char2"] = result

    survivor = reduced["classical-hyperoval:delete-9"]
    odd = groebner(survivor, 0, ordering="dp")
    # The saturated basis is the unit ideal; the unsaturated basis and its
    # integral lift give the more informative all-odd-characteristic result.
    assert odd["unit"] == 1
    report["algebra"]["classical-hyperoval:delete-9:char0-saturated"] = odd
    report["algebra"]["classical-hyperoval:delete-9:odd-lift"] = odd_integral_lift(survivor)
    assert report["algebra"]["classical-hyperoval:delete-9:odd-lift"]["denominator_primes"] == [2]
    report["algebra"]["classical-hyperoval:delete-9:seven-equation-core"] = seven_equation_core(survivor)

    print(json.dumps(report, indent=2, sort_keys=True))
    print("C1003 MATCH(9,4,1) checks passed")


if __name__ == "__main__":
    main()
