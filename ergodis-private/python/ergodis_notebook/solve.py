"""Running Ergodis solves from a notebook, one-shot or long and watched.

Two shapes of solve exist and they want different handling:

* an ordinary exact workflow -- JSON in, JSON out, seconds -- which is just a
  subprocess call and is what `run_json` covers; and
* a long controlled search that attaches to a campaign, streams coarse progress
  snapshots as JSONL, and can be steered while it runs, which is what `Solve`
  covers.

The second is the one worth a notebook.  Progress records are written by an
auxiliary watcher thread inside the search, not by the hot loop, so tailing the
file costs the search nothing.
"""

from __future__ import annotations

import json
import os
import signal
import subprocess
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Iterator, Sequence

from .campaign import Campaign
from .paths import binary


def run_json(
    subcommand: str,
    payload: dict[str, Any],
    binary_name: str = "ergodis",
    extra_args: Sequence[str] = (),
    timeout: float | None = None,
) -> dict[str, Any]:
    """Run one exact workflow: JSON on stdin, parsed JSON back.

    This is the same request/response discipline the browser WebAssembly
    adapter uses for its one exposed workflow, so a payload that works here is
    the payload that works there.
    """
    command = [str(binary(binary_name)), subcommand, "--input", "-", *extra_args]
    result = subprocess.run(
        command,
        input=json.dumps(payload).encode(),
        capture_output=True,
        timeout=timeout,
    )
    if result.returncode != 0:
        raise RuntimeError(
            f"{binary_name} {subcommand} failed: {result.stderr.decode().strip()}"
        )
    return json.loads(result.stdout)


class ProgressTail:
    """Incremental reader over a solve's progress JSONL file."""

    def __init__(self, path: os.PathLike[str] | str) -> None:
        self.path = Path(path)
        self._offset = 0
        self._partial = b""

    def read(self) -> list[dict[str, Any]]:
        if not self.path.exists():
            return []
        with self.path.open("rb") as handle:
            handle.seek(self._offset)
            chunk = handle.read()
            self._offset = handle.tell()
        if not chunk:
            return []
        buffer = self._partial + chunk
        lines = buffer.split(b"\n")
        self._partial = lines.pop()
        return [json.loads(line) for line in lines if line.strip()]


@dataclass
class Solve:
    """A running search subprocess with a progress file and a campaign behind it."""

    process: subprocess.Popen[bytes]
    progress_file: Path | None
    campaign: Campaign | None = None
    command: list[str] = field(default_factory=list)
    _progress: ProgressTail | None = field(init=False, default=None)
    _stdout: bytes | None = field(init=False, default=None)
    _stderr: bytes | None = field(init=False, default=None)

    def __post_init__(self) -> None:
        if self.progress_file is not None:
            self._progress = ProgressTail(self.progress_file)

    @classmethod
    def launch(
        cls,
        binary_name: str,
        args: Sequence[str],
        campaign: Campaign | None = None,
        progress_file: os.PathLike[str] | str | None = None,
        build: bool = False,
    ) -> "Solve":
        """Start a search binary as a subprocess.

        When `campaign` is given, `--run-dir` is supplied from its manifest, so
        the search attaches to that control plane.  When `progress_file` is
        given, `--progress-file` is supplied and the file becomes tailable.
        """
        command = [str(binary(binary_name, build=build))]
        if campaign is not None:
            command += ["--run-dir", str(campaign.manifest.run_dir)]
        if progress_file is not None:
            command += ["--progress-file", str(progress_file)]
        command += [str(argument) for argument in args]

        process = subprocess.Popen(
            command, stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        return cls(
            process=process,
            progress_file=Path(progress_file) if progress_file is not None else None,
            campaign=campaign,
            command=command,
        )

    # -- observation ---------------------------------------------------------

    def alive(self) -> bool:
        return self.process.poll() is None

    def new_progress(self) -> list[dict[str, Any]]:
        """Progress snapshots written since the previous call."""
        return self._progress.read() if self._progress is not None else []

    def follow_progress(
        self, interval: float = 0.25
    ) -> Iterator[dict[str, Any]]:
        """Yield progress snapshots until the search exits."""
        while True:
            records = self.new_progress()
            for record in records:
                yield record
            if not self.alive():
                for record in self.new_progress():
                    yield record
                return
            if not records:
                time.sleep(interval)

    # -- completion ----------------------------------------------------------

    def wait(self, timeout: float | None = None) -> int:
        code = self.process.wait(timeout=timeout)
        self._collect()
        return code

    def _collect(self) -> None:
        if self._stdout is None and self.process.stdout is not None:
            self._stdout = self.process.stdout.read()
        if self._stderr is None and self.process.stderr is not None:
            self._stderr = self.process.stderr.read()

    @property
    def stdout(self) -> str:
        self._collect()
        return (self._stdout or b"").decode()

    @property
    def stderr(self) -> str:
        self._collect()
        return (self._stderr or b"").decode()

    def result(self) -> Any:
        """The search's final JSON document, once it has exited."""
        text = self.stdout.strip()
        if not text:
            raise RuntimeError(f"search produced no output: {self.stderr.strip()}")
        return json.loads(text)

    def stop(self, timeout: float = 10.0) -> None:
        """Terminate the search.

        This is a hard stop for a search this session started.  Steering a
        running search is the campaign's job -- activate or deactivate a plan --
        not a signal.
        """
        if not self.alive():
            return
        self.process.send_signal(signal.SIGTERM)
        try:
            self.process.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            self.process.kill()
            self.process.wait(timeout=timeout)

    def __enter__(self) -> "Solve":
        return self

    def __exit__(self, *_exception: object) -> None:
        self.stop()


def alignment_search(
    campaign: Campaign,
    points: int,
    budget: int,
    progress_file: os.PathLike[str] | str,
    initial: Sequence[int] = (0,),
    symmetry: bool = False,
    compact_seen: bool = False,
    evolution_profile: bool = False,
    pulse_interval: int | None = None,
    seen_capacity: int | None = None,
    build: bool = False,
) -> Solve:
    """Start the C880 aligned-attachment search under a campaign.

    This is the concrete controlled search that exists today, and the worked
    example for what a monitored solve looks like.  Larger `budget` values are
    the slow direction; start small when exploring.

    `seen_capacity` sizes the exact state table, which is pre-sized and never
    grows: a search that outgrows it exits with "the pre-sized search table is
    full" rather than degrading, so raising it is the fix for that failure.
    """
    args: list[str] = [
        "--points",
        str(points),
        "--budget",
        str(budget),
        "--initial",
        ",".join(str(index) for index in initial),
    ]
    if pulse_interval is not None:
        args += ["--pulse-interval", str(pulse_interval)]
    if seen_capacity is not None:
        args += ["--seen-capacity", str(seen_capacity)]
    if symmetry:
        args.append("--symmetry")
    if compact_seen:
        args.append("--compact-seen")
    if evolution_profile:
        args.append("--evolution-profile")
    return Solve.launch(
        "alignment-controlled",
        args,
        campaign=campaign,
        progress_file=progress_file,
        build=build,
    )
