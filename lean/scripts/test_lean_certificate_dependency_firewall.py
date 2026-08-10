#!/usr/bin/env python3
"""Tests for the certificate-package dependency firewall."""

from __future__ import annotations

import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("lean-certificate-dependency-firewall.py")
MATHLIB_URL = "https://github.com/leanprover-community/mathlib4"
MATHLIB_REV = "a" * 40


class CertificateDependencyFirewallTests(unittest.TestCase):
    def fixture(self, directory: str) -> tuple[Path, Path]:
        root = Path(directory)
        libraries = root / "libraries"
        package = libraries / "certs"
        package.mkdir(parents=True)
        config = root / "policy.toml"
        config.write_text(
            'schema_version = 1\n[[certificate]]\nname = "certs"\n'
            'checkout = "certs"\nheavy = true\n'
            'allowed_direct_dependencies = ["mathlib"]\n'
            'source_root = "Certs"\nmodule_prefix = "Certs"\n',
            encoding="utf-8",
        )
        (package / "Certs").mkdir()
        (package / "Certs/Certificate.lean").write_text(
            "import Mathlib.Data.Fin.Basic\nimport Certs.Model\n",
            encoding="utf-8",
        )
        self.write_package(package, [("mathlib", MATHLIB_URL, MATHLIB_REV)])
        return config, libraries

    def write_package(self, package: Path, dependencies: list[tuple[str, str, str]]) -> None:
        requires = "".join(
            f'\n[[require]]\nname = "{name}"\ngit = "{url}"\nrev = "{rev}"\n'
            for name, url, rev in dependencies
        )
        (package / "lakefile.toml").write_text(
            f'name = "certs"\n{requires}', encoding="utf-8"
        )
        (package / "lake-manifest.json").write_text(
            json.dumps(
                {
                    "packages": [
                        {
                            "name": name,
                            "url": url,
                            "rev": rev,
                            "inputRev": rev,
                            "inherited": False,
                        }
                        for name, url, rev in dependencies
                    ]
                }
            )
            + "\n",
            encoding="utf-8",
        )

    def run_check(self, config: Path, libraries: Path) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [
                sys.executable,
                str(SCRIPT),
                "--config",
                str(config),
                "--libraries-root",
                str(libraries),
            ],
            text=True,
            capture_output=True,
            check=False,
        )

    def test_mathlib_only_package_passes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            config, libraries = self.fixture(directory)
            self.assertEqual(self.run_check(config, libraries).returncode, 0)

    def test_direct_finitegeom_dependency_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            config, libraries = self.fixture(directory)
            self.write_package(
                libraries / "certs",
                [
                    ("mathlib", MATHLIB_URL, MATHLIB_REV),
                    ("finitegeom", "https://github.com/tavisrudd/finitegeom", "b" * 40),
                ],
            )
            result = self.run_check(config, libraries)
            self.assertEqual(result.returncode, 1)
            self.assertIn("direct dependencies are ['finitegeom', 'mathlib']", result.stdout)

    def test_project_owned_dependency_under_an_allowed_name_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            config, libraries = self.fixture(directory)
            self.write_package(
                libraries / "certs",
                [("mathlib", "https://github.com/tavisrudd/disguised", MATHLIB_REV)],
            )
            result = self.run_check(config, libraries)
            self.assertEqual(result.returncode, 1)
            self.assertIn("project-owned dependency mathlib", result.stdout)

    def test_stale_manifest_dependency_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            config, libraries = self.fixture(directory)
            manifest = libraries / "certs/lake-manifest.json"
            document = json.loads(manifest.read_text(encoding="utf-8"))
            document["packages"].append(
                {
                    "name": "finitegeom",
                    "url": "https://github.com/tavisrudd/finitegeom",
                    "rev": "b" * 40,
                    "inputRev": "b" * 40,
                    "inherited": False,
                }
            )
            manifest.write_text(json.dumps(document) + "\n", encoding="utf-8")
            result = self.run_check(config, libraries)
            self.assertEqual(result.returncode, 1)
            self.assertIn(
                "manifest direct dependencies are ['finitegeom', 'mathlib']", result.stdout
            )

    def test_project_source_import_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            config, libraries = self.fixture(directory)
            (libraries / "certs/Certs/Certificate.lean").write_text(
                "import RelativeConicArcs.Foundation\n",
                encoding="utf-8",
            )
            result = self.run_check(config, libraries)
            self.assertEqual(result.returncode, 1)
            self.assertIn(
                "forbidden source import RelativeConicArcs.Foundation", result.stdout
            )


if __name__ == "__main__":
    unittest.main()
