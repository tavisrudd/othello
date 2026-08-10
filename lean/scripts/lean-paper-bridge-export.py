#!/usr/bin/env python3
"""Materialize deterministic reviewer packages for cheap certificate bridges."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import tempfile
import tomllib
from pathlib import Path


REPO = Path(__file__).resolve().parents[2]
CONFIG_PATH = "lean/trust/paper-bridges.toml"
FLAKE_LOCK_PATH = "lean/paper-bridges/flake.lock"
TOOLCHAIN = "leanprover/lean4:v4.32.0-rc1"
MATHLIB_REV = "571b8a8e54219b4d393f75f4b8653fac08197fcc"


def git(*args: str, text: bool = True) -> str | bytes:
    result = subprocess.run(
        ["git", *args], cwd=REPO, check=True, capture_output=True, text=text
    )
    return result.stdout


def blob(commit: str, path: str) -> bytes:
    return git("show", f"{commit}:{path}", text=False)


def config_at(commit: str) -> dict:
    return tomllib.loads(blob(commit, CONFIG_PATH).decode("utf-8"))


def select_bridge(document: dict, name: str) -> dict:
    matches = [bridge for bridge in document.get("bridge", []) if bridge["name"] == name]
    if len(matches) != 1:
        raise ValueError(f"unknown or duplicate paper bridge {name}")
    return matches[0]


def lakefile(bridge: dict) -> str:
    return f'''name = "{bridge["repository"]}"
defaultTargets = ["{bridge["lean_library"]}"]

[[require]]
name = "finitegeom"
git = "https://github.com/tavisrudd/finitegeom"
rev = "{bridge["finitegeom_commit"]}"

[[require]]
name = "{bridge["certificate_package"]}"
git = "https://github.com/tavisrudd/{bridge["certificate_package"]}"
rev = "{bridge["certificate_commit"]}"

[[lean_lib]]
name = "{bridge["lean_library"]}"
roots = ["{bridge["module"]}"]
'''


def flake(bridge: dict) -> str:
    package = bridge["certificate_package"]
    gate = bridge["certificate_gate"]
    module = bridge["module"]
    return f'''{{
  description = "Lean compatibility bridge for {bridge["name"]}";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {{ nixpkgs, ... }}:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {{
      apps = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${{system}};
          verify = pkgs.writeShellApplication {{
            name = "verify-paper-certificate-bridge";
            runtimeInputs = with pkgs; [ elan git curl cacert gmp zlib coreutils ];
            text = ''
              if test "$#" -ne 1; then
                echo "usage: nix run .#verify -- /path/to/certificate.lake-pack.tar.gz" >&2
                exit 2
              fi
              certificate_pack="$(realpath "$1")"
              test -f "$certificate_pack"
              lake update
              certificate_root=".lake/packages/{package}"
              test -d "$certificate_root"
              (cd "$certificate_root" && lake unpack "$certificate_pack")
              (cd "$certificate_root" && lake build --no-build {gate})
              lake build {module}
            '';
          }};
        in {{
          default = {{ type = "app"; program = "${{verify}}/bin/verify-paper-certificate-bridge"; }};
          verify = {{ type = "app"; program = "${{verify}}/bin/verify-paper-certificate-bridge"; }};
        }});
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${{system}};
        in {{ default = pkgs.mkShell {{ packages = with pkgs; [ elan git curl cacert gmp zlib ]; }}; }});
    }};
}}
'''


def readme(bridge: dict) -> str:
    if bridge["name"] == "clebsch-rigidity":
        scope = (
            "This Lean package identifies the order-eleven certificate coordinates with "
            "the witness and projective-point tables used in the Clebsch rigidity formalization."
        )
    else:
        scope = (
            "This Lean package identifies the order-sixteen certificate field and canonical "
            "projective representatives with the geometric model used for arcs outside a conic."
        )
    return f'''# {bridge["repository"]}

{scope}

The compatibility theorem is `{bridge["module"]}`. The upstream certificate is
frozen at `{bridge["certificate_commit"]}` and the finite-geometry library is
frozen at `{bridge["finitegeom_commit"]}`. The certificate imports Mathlib only;
this small package is the first point at which both formal models are imported.

## Verify

Obtain the certificate Lake pack whose SHA-256 digest is
`{bridge["cache_sha256"]}`, then run:

```sh
nix run .#verify -- /path/to/{bridge["cache_archive"]}
```

The command restores the frozen certificate artifacts, requires its aggregate
trace to be current without compilation, and builds only the compatibility module.

## License

This repository is licensed under the Creative Commons Attribution 4.0
International License. See `LICENSE`.
'''


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def materialized_files(commit: str, bridge: dict) -> dict[str, bytes]:
    module_path = bridge["module"].replace(".", "/") + ".lean"
    source = blob(commit, "lean/" + bridge["source"])
    license_text = blob(commit, bridge["license_source"])
    flake_lock = blob(commit, FLAKE_LOCK_PATH)
    files = {
        module_path: source,
        "LICENSE": license_text,
        "lakefile.toml": lakefile(bridge).encode(),
        "lean-toolchain": (TOOLCHAIN + "\n").encode(),
        "flake.nix": flake(bridge).encode(),
        "flake.lock": flake_lock,
        "README.md": readme(bridge).encode(),
    }
    manifest = {
        "schema_version": 1,
        "source_commit": commit,
        "roots": [bridge["module"]],
        "sources": [
            {
                "path": module_path,
                "bytes": len(source),
                "sha256": sha256(source),
            }
        ],
        "module_count": 1,
        "license": {
            "path": "LICENSE",
            "sha256": sha256(license_text),
        },
        "dependencies": {
            "finitegeom": bridge["finitegeom_commit"],
            bridge["certificate_package"]: bridge["certificate_commit"],
        },
        "certificate_cache_sha256": bridge["cache_sha256"],
    }
    files["MANIFEST.json"] = (
        json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    ).encode()
    return files


def destination_safe(destination: Path) -> None:
    resolved = destination.expanduser().resolve()
    if not resolved.is_absolute() or str(resolved).startswith(("/tmp/", "/dev/shm/")):
        raise ValueError("destination must be an absolute disk-backed path outside tmpfs")
    if resolved.exists():
        raise ValueError(f"destination already exists: {resolved}")


def write_files(destination: Path, files: dict[str, bytes]) -> None:
    for relative, data in files.items():
        relative_path = Path(relative)
        if relative_path.is_absolute() or ".." in relative_path.parts:
            raise ValueError(f"unsafe materialized path: {relative}")
        path = destination / relative_path
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)


def source_identity(commit: str) -> dict[str, str]:
    fields = (
        str(git("show", "-s", "--format=%an%x00%ae%x00%aI", commit))
        .strip()
        .split("\0")
    )
    if len(fields) != 3 or not all(fields):
        raise ValueError(f"cannot derive Git identity from {commit}")
    name, email, timestamp = fields
    return {
        "GIT_AUTHOR_NAME": name,
        "GIT_AUTHOR_EMAIL": email,
        "GIT_AUTHOR_DATE": timestamp,
        "GIT_COMMITTER_NAME": name,
        "GIT_COMMITTER_EMAIL": email,
        "GIT_COMMITTER_DATE": timestamp,
    }


def adopt(
    commit: str,
    bridge: dict,
    files: dict[str, bytes],
    libraries_root: Path,
) -> tuple[Path, str]:
    libraries_root = libraries_root.expanduser().resolve()
    if not libraries_root.is_dir():
        raise ValueError(f"libraries root is missing: {libraries_root}")
    repository = bridge["repository"]
    if Path(repository).name != repository:
        raise ValueError(f"unsafe repository name: {repository}")
    destination = libraries_root / repository
    destination_safe(destination)
    staging_root = Path.home() / ".cache/othello-lean-build/paper-bridge-adopt"
    staging_root.mkdir(parents=True, exist_ok=True)
    staging = Path(tempfile.mkdtemp(prefix=bridge["name"] + "-", dir=staging_root))
    write_files(staging, files)
    subprocess.run(
        ["git", "init", "--initial-branch", "main", str(staging)],
        check=True,
        capture_output=True,
        text=True,
    )
    subprocess.run(
        ["git", "-C", str(staging), "add", "--", *sorted(files)],
        check=True,
        capture_output=True,
        text=True,
    )
    environment = os.environ.copy()
    environment.update(source_identity(commit))
    subprocess.run(
        [
            "git",
            "-C",
            str(staging),
            "-c",
            "commit.gpgsign=false",
            "commit",
            "-m",
            "Initial reviewer package",
        ],
        check=True,
        capture_output=True,
        text=True,
        env=environment,
    )
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.move(str(staging), str(destination))
    adopted_commit = subprocess.run(
        ["git", "-C", str(destination), "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    return destination, adopted_commit


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-ref", required=True)
    parser.add_argument("--bridge", required=True)
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("plan")
    materialize = subparsers.add_parser("materialize")
    materialize.add_argument("--destination", type=Path, required=True)
    adoption = subparsers.add_parser("adopt")
    adoption.add_argument(
        "--libraries-root", type=Path, default=Path.home() / "src/lean"
    )
    args = parser.parse_args()
    commit = str(git("rev-parse", f"{args.source_ref}^{{commit}}")).strip()
    bridge = select_bridge(config_at(commit), args.bridge)
    files = materialized_files(commit, bridge)
    if args.command == "plan":
        print(f"bridge={bridge['name']} source_commit={commit}")
        for path in sorted(files):
            print(path)
        return 0
    if args.command == "adopt":
        destination, adopted_commit = adopt(
            commit, bridge, files, args.libraries_root
        )
        print(f"adopted {bridge['name']} at {destination} commit={adopted_commit}")
        return 0
    destination_safe(args.destination)
    destination = args.destination.expanduser().resolve()
    write_files(destination, files)
    print(f"materialized {bridge['name']} at {destination}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
