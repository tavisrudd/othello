"""Replay the native ABI adapter and its input rejection boundary.

Run with Python from the Lean package root and ERGODIS_RULE_LIBRARY configured.
The retained certificate is a byte-parity reference, not proof authority.
"""
import json
import os
from pathlib import Path
import tempfile
import unittest

from oracle import LIMIT, certificate

HERE = Path(__file__).resolve().parent


class OracleAdapter(unittest.TestCase):
    def test_native_certificate(self):
        result = certificate(HERE / "fixtures/distance.json", os.environ["ERGODIS_RULE_LIBRARY"])
        self.assertEqual(result + b"\n", (HERE / "fixtures/distance.certificate.json").read_bytes())

    def test_source_rejection(self):
        source = json.loads((HERE / "fixtures/distance.json").read_text())
        source["schema"] = "unsupported"
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "source.json"
            path.write_text(json.dumps(source))
            with self.assertRaisesRegex(ValueError, "module operation 1 failed"):
                certificate(path, os.environ["ERGODIS_RULE_LIBRARY"])
            path.write_bytes(b" " * (LIMIT + 1))
            with self.assertRaisesRegex(ValueError, "source exceeds byte limit"):
                certificate(path, os.environ["ERGODIS_RULE_LIBRARY"])


if __name__ == "__main__":
    unittest.main()
