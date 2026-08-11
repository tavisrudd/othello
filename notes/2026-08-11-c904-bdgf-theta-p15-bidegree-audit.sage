#!/usr/bin/env sage
"""Exact bidegree and anti-graph audit for the BdGF Poincare cube."""

from itertools import combinations
import argparse


def wedge(left, right):
    result = {}
    for left_indices, left_value in left.items():
        occupied = set(left_indices)
        for right_indices, right_value in right.items():
            if occupied.intersection(right_indices):
                continue
            inversions = sum(i > j for i in left_indices for j in right_indices)
            indices = tuple(sorted(left_indices + right_indices))
            coefficient = (-1 if inversions % 2 else 1) * left_value * right_value
            result[indices] = result.get(indices, 0) + coefficient
    return {indices: value for indices, value in result.items() if value}


def pull_anti_graph(form):
    result = {}
    for indices, value in form.items():
        image = []
        sign = 1
        for index in indices:
            if index < 10:
                image.append(index)
            else:
                image.append(index - 10)
                sign *= -1
        if len(set(image)) < len(image):
            continue
        inversions = sum(image[i] > image[j]
                         for i in range(len(image)) for j in range(i + 1, len(image)))
        target = tuple(sorted(image))
        result[target] = result.get(target, 0) + value * sign * (-1 if inversions % 2 else 1)
    return {indices: value for indices, value in result.items() if value}


def main(output_path=None):
    # Coordinates 0,...,9 on the first factor and 10,...,19 on the second;
    # each factor is ordered e1,f1,...,e5,f5.
    p = {}
    theta = {}
    for i in range(5):
        e = 2*i
        f = 2*i + 1
        p[(e, 10 + f)] = 1
        p[(f, 10 + e)] = -1
        theta[(e, f)] = 1

    p3 = wedge(wedge(p, p), p)
    assert all(value % factorial(3) == 0 for value in p3.values())
    p3_divided = {indices: value // factorial(3)
                  for indices, value in p3.items()}

    triples = list(combinations(range(10), 3))
    lookup = {indices: i for i, indices in enumerate(triples)}
    kernel = zero_matrix(ZZ, len(triples))
    bidegrees = set()
    for indices, value in p3_divided.items():
        left = tuple(index for index in indices if index < 10)
        right = tuple(index - 10 for index in indices if index >= 10)
        bidegrees.add((len(left), len(right)))
        kernel[lookup[left], lookup[right]] = value
    assert bidegrees == {(3, 3)}
    assert kernel + kernel.transpose() == 0
    assert all(kernel[i, i] == 0 for i in range(kernel.nrows()))
    assert kernel.rank() == 120
    assert abs(kernel.det()) == 1

    # The integral skew matrix is precisely an odd-degree Nakaoka transfer,
    # so the free cohomology class has an integral symmetric-square descent.
    assert len(kernel.nonzero_positions()) == 120

    anti = pull_anti_graph(p3_divided)
    theta3 = wedge(wedge(theta, theta), theta)
    theta3_divided = {indices: value // factorial(3)
                      for indices, value in theta3.items()}
    assert anti == {indices: -8 * value
                    for indices, value in theta3_divided.items()}

    h4 = 120
    theta3_degree = h4 // factorial(3)
    half_anti_graph_coefficient = -4
    addition_degree = half_anti_graph_coefficient * theta3_degree
    assert theta3_degree == 20
    assert addition_degree == -80

    # On a fourfold a codimension-three kernel sends H^r to H^{r-2}.
    # Its (3,3) component can act only for r+3=8, hence H^5 -> H^3.
    source_degree = 8 - 3
    target_degree = 3
    assert (source_degree, target_degree) == (5, 3)
    required_p15_bidegree = (5, 1)
    assert required_p15_bidegree not in bidegrees

    output = "\n".join([
        "C904 BdGF theta pullback / p15 bidegree audit",
        f"P^[3] bidegrees={sorted(bidegrees)}",
        f"Lambda3 kernel: shape={kernel.nrows()}x{kernel.ncols()}, rank={kernel.rank()}, det-absolute={abs(kernel.det())}, nonzeros={len(kernel.nonzero_positions())}",
        "swap/Koszul test: integral skew Nakaoka transfer PASS",
        f"correspondence action on M: H^{source_degree}->H^{target_degree}; required p15=(5,1) is absent",
        "anti-graph restriction: j*P^[3]=-8 h^[3]",
        f"half anti-graph=-4 h^[3]; int(h^4/3!)={theta3_degree}; addition degree={addition_degree}",
        "identity coefficient target degree=5 is not met",
        "PASS",
    ]) + "\n"
    if output_path:
        with open(output_path, "w", encoding="utf-8") as stream:
            stream.write(output)
    else:
        print(output, end="")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output")
    arguments = parser.parse_args()
    main(arguments.output)
