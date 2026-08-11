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
GITIGNORE = "/.lake/\n/lake-manifest.json\n"


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
    gate_path = bridge["certificate_gate"].replace(".", "/")
    module_path = bridge["module"].replace(".", "/") + ".lean"
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
              if test "$#" -ne 1 && test "$#" -ne 3; then
                echo "usage: nix run .#verify -- /path/to/certificate.lake-pack.tar.gz [finitegeom-source certificate-source]" >&2
                exit 2
              fi
              certificate_pack="$(realpath "$1")"
              test -f "$certificate_pack"
              export LEAN_NUM_THREADS=1
              local_sources=0
              if test "$#" -eq 3; then
                finitegeom_source="$(realpath "$2")"
                certificate_source="$(realpath "$3")"
                test "$(git -C "$finitegeom_source" rev-parse --is-inside-work-tree)" = true
                test "$(git -C "$certificate_source" rev-parse --is-inside-work-tree)" = true
                test "$(git -C "$finitegeom_source" rev-parse HEAD)" = '{bridge["finitegeom_commit"]}'
                test -z "$(git -C "$finitegeom_source" status --short --untracked-files=no)"
                test "$(git -C "$certificate_source" rev-parse HEAD)" = '{bridge["certificate_commit"]}'
                test -z "$(git -C "$certificate_source" status --short --untracked-files=no)"
                local_sources=1
                export GIT_CONFIG_COUNT=2
                export GIT_CONFIG_KEY_0="url.file://$finitegeom_source/.insteadOf"
                export GIT_CONFIG_VALUE_0="https://github.com/tavisrudd/finitegeom"
                export GIT_CONFIG_KEY_1="url.file://$certificate_source/.insteadOf"
                export GIT_CONFIG_VALUE_1="https://github.com/tavisrudd/{package}"
              fi
              printf '%s  %s\n' \
                '{bridge["cache_sha256"]}' \
                "$certificate_pack" \
                | sha256sum --check --status
              if test "$local_sources" -eq 0 || ! test -f lake-manifest.json; then
                lake update
              fi
              finitegeom_root=".lake/packages/finitegeom"
              certificate_root=".lake/packages/{package}"
              if test "$local_sources" -eq 1; then
                rm -rf "$finitegeom_root"
                ln -s "$finitegeom_source" "$finitegeom_root"
                rm -rf "$certificate_root"
                ln -s "$certificate_source" "$certificate_root"
              else
                (cd "$certificate_root" && lake unpack "$certificate_pack")
              fi
              test -d "$certificate_root"
              printf '%s  %s\n' \
                '{bridge["certificate_olean_sha256"]}' \
                "$certificate_root/.lake/build/lib/lean/{gate_path}.olean" \
                | sha256sum --check --status
              printf '%s  %s\n' \
                '{bridge["certificate_trace_sha256"]}' \
                "$certificate_root/.lake/build/lib/lean/{gate_path}.trace" \
                | sha256sum --check --status
              if test "$local_sources" -eq 1; then
                (cd "$finitegeom_root" && lake build --no-build {bridge["finitegeom_import"]})
              else
                (cd "$finitegeom_root" && lake build {bridge["finitegeom_import"]})
              fi
              lake env lean {module_path}
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
    elif bridge["name"] == "arcs-complete-outside-conic":
        scope = (
            "This Lean package identifies the order-sixteen certificate field and canonical "
            "projective representatives with the geometric model used for arcs outside a conic."
        )
    elif bridge["name"] == "projective-cap-q11":
        scope = (
            "This Lean package identifies the order-eleven certificate's residual-grid model "
            "with the projective-cap game and transports the certified local outcome to every "
            "rank-three projective model."
        )
    elif bridge["name"] == "sample-paper":
        scope = "This Lean package checks the sample certificate compatibility theorem."
    else:
        raise ValueError(f"no reviewer-facing scope for paper bridge {bridge['name']}")
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

The command verifies the pack and frozen certificate aggregate hashes, checks the
human module imported by the bridge (building it only in a clean public replay),
and elaborates the compatibility source directly. With explicit local source
checkouts it reuses their sealed artifacts; a public replay restores the pack.
It never asks Lake to build a certificate target.

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
        ".gitignore": GITIGNORE.encode(),
    }
    manifest = {
        "schema_version": 1,
        "source_commit": commit,
        "roots": [bridge["module"]],
        "sources": [
            {
                "path": module_path,
                "module": bridge["module"],
                "bytes": len(source),
                "sha256": sha256(source),
            },
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


def sync(
    commit: str,
    bridge: dict,
    files: dict[str, bytes],
    libraries_root: Path,
    allow_delete: bool = False,
) -> tuple[Path, str]:
    libraries_root = libraries_root.expanduser().resolve()
    repository = bridge["repository"]
    if Path(repository).name != repository:
        raise ValueError(f"unsafe repository name: {repository}")
    destination = libraries_root / repository
    if not destination.is_dir():
        raise ValueError(f"bridge checkout is missing: {destination}")
    head = subprocess.run(
        ["git", "-C", str(destination), "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    expected_head = bridge.get("bridge_commit")
    if expected_head is None and bridge.get("status") == "authority-pending-export":
        manifest = json.loads(
            subprocess.run(
                ["git", "-C", str(destination), "show", f"{head}:MANIFEST.json"],
                check=True,
                capture_output=True,
                text=True,
            ).stdout
        )
        previous_source = manifest.get("source_commit")
        if not isinstance(previous_source, str):
            raise ValueError("pending bridge manifest has no source commit")
        previous_bridge = select_bridge(config_at(previous_source), bridge["name"])
        previous_files = materialized_files(previous_source, previous_bridge)
        tracked_at_head = set(
            subprocess.run(
                ["git", "-C", str(destination), "ls-tree", "-r", "--name-only", head],
                check=True,
                capture_output=True,
                text=True,
            ).stdout.splitlines()
        )
        if tracked_at_head != set(previous_files):
            raise ValueError("pending bridge is not an exact prior exporter output")
        for relative, expected in previous_files.items():
            actual = subprocess.run(
                ["git", "-C", str(destination), "show", f"{head}:{relative}"],
                check=True,
                capture_output=True,
            ).stdout
            if actual != expected:
                raise ValueError("pending bridge is not an exact prior exporter output")
        expected_head = head
    if expected_head is None:
        raise ValueError("active bridge has no recorded bridge commit")
    if head != expected_head:
        raise ValueError(
            f"bridge HEAD is {head}, expected {expected_head}"
        )
    status = subprocess.run(
        ["git", "-C", str(destination), "status", "--short"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout
    unexpected_status = [
        line
        for line in status.splitlines()
        if line[3:] != "lake-manifest.json" and not line[3:].startswith(".lake/")
    ]
    if unexpected_status:
        raise ValueError(f"bridge checkout is dirty: {destination}")
    tracked = set(
        subprocess.run(
            ["git", "-C", str(destination), "ls-files"],
            check=True,
            capture_output=True,
            text=True,
        ).stdout.splitlines()
    )
    removed = tracked - set(files)
    if removed and not allow_delete:
        raise ValueError(f"bridge sync would delete tracked paths: {sorted(removed)}")
    for relative in sorted(removed):
        path = destination / relative
        if path.is_file() or path.is_symlink():
            path.unlink()
    write_files(destination, files)
    subprocess.run(
        ["git", "-C", str(destination), "add", "--", *sorted(files)],
        check=True,
        capture_output=True,
        text=True,
    )
    if removed:
        subprocess.run(
            ["git", "-C", str(destination), "add", "-u", "--", *sorted(removed)],
            check=True,
            capture_output=True,
            text=True,
        )
    if not subprocess.run(
        ["git", "-C", str(destination), "diff", "--cached", "--quiet"],
        check=False,
    ).returncode:
        return destination, head
    environment = os.environ.copy()
    environment.update(source_identity(commit))
    subprocess.run(
        [
            "git",
            "-C",
            str(destination),
            "-c",
            "commit.gpgsign=false",
            "commit",
            "-m",
            "Refresh reviewer package",
        ],
        check=True,
        capture_output=True,
        text=True,
        env=environment,
    )
    updated = subprocess.run(
        ["git", "-C", str(destination), "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    return destination, updated


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
    synchronization = subparsers.add_parser("sync")
    synchronization.add_argument(
        "--libraries-root", type=Path, default=Path.home() / "src/lean"
    )
    synchronization.add_argument("--allow-delete", action="store_true")
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
    if args.command == "sync":
        destination, updated_commit = sync(
            commit, bridge, files, args.libraries_root, args.allow_delete
        )
        print(f"synchronized {bridge['name']} at {destination} commit={updated_commit}")
        return 0
    destination_safe(args.destination)
    destination = args.destination.expanduser().resolve()
    write_files(destination, files)
    print(f"materialized {bridge['name']} at {destination}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
