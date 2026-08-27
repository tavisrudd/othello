"""Small ternary extension fields and projective-plane incidence oracles."""

from __future__ import annotations

from dataclasses import dataclass


_IRREDUCIBLE = {
    9: (1, 0, 1),
    27: (1, 2, 0, 1),
}


@dataclass(frozen=True)
class ProjectivePlane:
    order: int
    points: tuple[tuple[int, int, int], ...]
    on_line: tuple[tuple[int, ...], ...]
    through_point: tuple[tuple[int, ...], ...]


class TernaryExtensionField:
    """Table-driven arithmetic for the supported fields GF(9) and GF(27)."""

    def __init__(self, order: int) -> None:
        try:
            self.modulus = _IRREDUCIBLE[order]
        except KeyError as error:
            raise ValueError("supported field orders are 9 and 27") from error
        self.order = order
        self.degree = len(self.modulus) - 1
        coefficients = tuple(self._coefficients(value) for value in range(order))
        self.add_table = tuple(
            tuple(
                self._encode(tuple((x + y) % 3 for x, y in zip(left, right)))
                for right in coefficients
            )
            for left in coefficients
        )
        self.mul_table = tuple(
            tuple(self._multiply_coefficients(left, right) for right in coefficients)
            for left in coefficients
        )

    def _coefficients(self, value: int) -> tuple[int, ...]:
        result = []
        for _ in range(self.degree):
            result.append(value % 3)
            value //= 3
        return tuple(result)

    def _encode(self, coefficients: tuple[int, ...] | list[int]) -> int:
        value = 0
        place = 1
        for coefficient in coefficients[: self.degree]:
            value += (coefficient % 3) * place
            place *= 3
        return value

    def _multiply_coefficients(
        self, left: tuple[int, ...], right: tuple[int, ...]
    ) -> int:
        product = [0] * (2 * self.degree - 1)
        for left_index, left_value in enumerate(left):
            for right_index, right_value in enumerate(right):
                product[left_index + right_index] = (
                    product[left_index + right_index] + left_value * right_value
                ) % 3
        for power in range(len(product) - 1, self.degree - 1, -1):
            leading = product[power] % 3
            if leading:
                shift = power - self.degree
                for index in range(self.degree):
                    product[shift + index] = (
                        product[shift + index] - leading * self.modulus[index]
                    ) % 3
        return self._encode(product)

    def add(self, left: int, right: int) -> int:
        return self.add_table[left][right]

    def multiply(self, left: int, right: int) -> int:
        return self.mul_table[left][right]


def ternary_projective_plane(order: int) -> ProjectivePlane:
    field = TernaryExtensionField(order)
    points = tuple(
        [(1, y, z) for y in range(order) for z in range(order)]
        + [(0, 1, z) for z in range(order)]
        + [(0, 0, 1)]
    )
    on_line = []
    for line in points:
        members = []
        for point_index, point in enumerate(points):
            value = 0
            for coordinate, coefficient in zip(point, line):
                value = field.add(value, field.multiply(coordinate, coefficient))
            if value == 0:
                members.append(point_index)
        on_line.append(tuple(members))
    through_point = [[] for _ in points]
    for line_index, members in enumerate(on_line):
        for point_index in members:
            through_point[point_index].append(line_index)
    return ProjectivePlane(
        order=order,
        points=points,
        on_line=tuple(on_line),
        through_point=tuple(tuple(lines) for lines in through_point),
    )
