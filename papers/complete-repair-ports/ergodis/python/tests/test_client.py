import os
import unittest
from typing import cast

from ergodis import (
    CharacterSumQuery,
    Client,
    ErgodisRpcError,
    Polynomial,
)


@unittest.skipUnless(os.environ.get("ERGODIS_RPC_BIN"), "set ERGODIS_RPC_BIN")
class ClientTests(unittest.TestCase):
    def test_pythonic_field_api_batching_bigints_and_error_recovery(self):
        class SympyLikePolynomial:
            def all_coeffs(self) -> list[int]:
                return [36, -108, 213, -246, 213, -108, 36]

        phi = Polynomial([36, -108, 213, -246, 213, -108, 36])
        self.assertEqual(Polynomial.from_sympy(SympyLikePolynomial()), phi)
        descended = Polynomial([36, -108, 105, -36])
        with Client() as client:
            methods = client.discover()["methods"]
            self.assertIn("character_sum.census", cast(list[object], methods))
            character = client.GF(5).quadratic_character
            batch = character.sum_many(
                [
                    CharacterSumQuery("S", phi),
                    CharacterSumQuery("S1", descended),
                    CharacterSumQuery("S2", descended, twist=(1, -4)),
                ]
            )
            self.assertEqual([result.census.value for result in batch.results], [2, -1, 3])
            self.assertEqual(batch["S"].total, 5)
            with self.assertRaises(ErgodisRpcError):
                client.GF(9).quadratic_character.sum([1])
            huge_square = 7 * 10**100 + 1
            self.assertEqual(client.GF(7).quadratic_character.sum([huge_square]).value, 7)


if __name__ == "__main__":
    unittest.main()
