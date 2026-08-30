import unittest

from semantic_subspace_core import (
    enumerate_affine_subspaces,
    linearized_exponents,
    prime_field_basis,
    verify_prime_subspace,
)


class SemanticSubspaceCoreTest(unittest.TestCase):
    def test_extracts_basis_of_prime_plane(self) -> None:
        elements = {0, 1, 2, 3, 4, 5, 6, 7, 8}

        def coordinates(value: int) -> tuple[int, int]:
            return (value % 3, value // 3)

        def add(left: int, right: int) -> int:
            return ((left % 3 + right % 3) % 3) + 3 * (
                (left // 3 + right // 3) % 3
            )

        basis = prime_field_basis(elements, coordinates, 3)
        self.assertEqual(basis, [1, 3])
        self.assertTrue(verify_prime_subspace(elements, basis, add, 3))
        self.assertEqual(
            len(enumerate_affine_subspaces(elements, 1, coordinates, add, 3)),
            12,
        )

    def test_rejects_non_linearized_polynomial(self) -> None:
        self.assertEqual(linearized_exponents([0, 2, 0, 1, 0, 0, 0, 0, 0, 1], 3), [1, 3, 9])
        with self.assertRaises(ValueError):
            linearized_exponents([0, 1, 1, 0], 3)


if __name__ == "__main__":
    unittest.main()
