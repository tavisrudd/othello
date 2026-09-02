"""Bounded stdlib client for the optional Ergodis campaign protocol.

The socket transport is the reference binding.  It intentionally keeps large
evidence out of messages: callers stream run-relative files returned by the
daemon instead of materializing them in memory.
"""

from __future__ import annotations

import asyncio
from dataclasses import dataclass
from enum import StrEnum
import io
import json
import os
from pathlib import Path
import socket
import struct
from types import MappingProxyType
from typing import Any, BinaryIO, Iterator, Mapping, Self, cast


SCHEMA = "ergodis-control-experimental-v0"
MAX_FRAME_BYTES = 64 * 1024
_U64_MAX = (1 << 64) - 1
_LENGTH = struct.Struct("<I")


class ProtocolError(RuntimeError):
    """The peer or local manifest violated the bounded protocol."""


class RemoteError(RuntimeError):
    """Ergodis rejected an otherwise valid request."""


@dataclass(frozen=True)
class Response:
    request_id: int
    epoch: int
    result: Mapping[str, Any]


def _read_exact(stream: io.BufferedIOBase | io.RawIOBase, length: int) -> bytearray:
    chunks = bytearray(length)
    view = memoryview(chunks)
    offset = 0
    while offset != length:
        count = stream.readinto(view[offset:])
        if not count:
            raise ProtocolError("truncated frame")
        offset += count
    return chunks


def _read_frame(
    stream: io.BufferedIOBase | io.RawIOBase, limit: int = MAX_FRAME_BYTES
) -> bytearray:
    length = _LENGTH.unpack(_read_exact(stream, _LENGTH.size))[0]
    if length > limit:
        raise ProtocolError(f"frame length {length} exceeds {limit}")
    return _read_exact(stream, length)


def _write_frame(stream: io.BufferedIOBase | io.RawIOBase, payload: bytes) -> None:
    if len(payload) > MAX_FRAME_BYTES:
        raise ProtocolError(f"frame length {len(payload)} exceeds {MAX_FRAME_BYTES}")
    stream.write(_LENGTH.pack(len(payload)))
    stream.write(payload)
    stream.flush()


def _reject_json_constant(token: str) -> None:
    raise ValueError(f"non-finite JSON number {token}")


def _decode_json(payload: bytes | bytearray, description: str) -> Any:
    try:
        return json.loads(payload, parse_constant=_reject_json_constant)
    except (UnicodeDecodeError, ValueError, RecursionError) as error:
        raise ProtocolError(f"invalid {description} JSON") from error


def _decode_object(payload: bytes | bytearray, description: str) -> Mapping[str, Any]:
    value = _decode_json(payload, description)
    if not isinstance(value, dict):
        raise ProtocolError(f"{description} is not an object")
    return cast(Mapping[str, Any], value)


class Session:
    """One isolated campaign endpoint with monotone client request IDs."""

    def __init__(
        self,
        run_dir: Path,
        socket_path: Path,
        run_id: str,
        nonce: str,
        *,
        timeout: float = 10.0,
    ) -> None:
        self.run_dir = run_dir.resolve()
        self.socket_path = socket_path
        self.run_id = run_id
        self._nonce = nonce
        self.timeout = timeout
        self._next_request_id = 1

    @classmethod
    def from_run_dir(cls, run_dir: Path | str, *, timeout: float = 10.0) -> "Session":
        root = Path(run_dir).resolve()
        with (root / "manifest.json").open("rb") as source:
            encoded = source.read(MAX_FRAME_BYTES + 1)
        if len(encoded) > MAX_FRAME_BYTES:
            raise ProtocolError("manifest exceeds protocol frame bound")
        manifest = _decode_object(encoded, "manifest")
        if manifest.get("schema") != SCHEMA:
            raise ProtocolError("unsupported manifest schema")
        try:
            socket_value = manifest["socket"]
            run_id = manifest["run_id"]
            nonce = manifest["nonce"]
            if not all(
                isinstance(value, str) and 1 <= len(value) <= 4096
                for value in (socket_value, run_id, nonce)
            ):
                raise ProtocolError("invalid manifest identity field")
            return cls(
                root,
                Path(socket_value),
                run_id,
                nonce,
                timeout=timeout,
            )
        except KeyError as error:
            raise ProtocolError(f"manifest omitted {error.args[0]}") from error

    def request(
        self,
        operation: str,
        arguments: Mapping[str, Any] | None = None,
        *,
        max_bytes: int = 8192,
    ) -> Response:
        request_id, encoded = self._prepare_request(operation, arguments, max_bytes)
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as connection:
            connection.settimeout(self.timeout)
            connection.connect(str(self.socket_path))
            with connection.makefile("rwb", buffering=0) as stream:
                _write_frame(stream, encoded)
                payload = _read_frame(stream, max_bytes)
        return self._accept_response(request_id, payload)

    async def request_async(
        self,
        operation: str,
        arguments: Mapping[str, Any] | None = None,
        *,
        max_bytes: int = 8192,
    ) -> Response:
        """Send one request without blocking the caller's event loop."""
        request_id, encoded = self._prepare_request(operation, arguments, max_bytes)
        writer: asyncio.StreamWriter | None = None
        try:
            async with asyncio.timeout(self.timeout):
                reader, writer = await asyncio.open_unix_connection(
                    str(self.socket_path)
                )
                writer.write(_LENGTH.pack(len(encoded)))
                writer.write(encoded)
                await writer.drain()
                length = _LENGTH.unpack(await reader.readexactly(_LENGTH.size))[0]
                if length > max_bytes:
                    raise ProtocolError(f"frame length {length} exceeds {max_bytes}")
                payload = await reader.readexactly(length)
        except asyncio.IncompleteReadError as error:
            raise ProtocolError("truncated frame") from error
        finally:
            if writer is not None:
                writer.close()
                await writer.wait_closed()
        return self._accept_response(request_id, payload)

    def _prepare_request(
        self,
        operation: str,
        arguments: Mapping[str, Any] | None,
        max_bytes: int,
    ) -> tuple[int, bytes]:
        if type(max_bytes) is not int or not 1 <= max_bytes <= MAX_FRAME_BYTES:
            raise ValueError(f"max_bytes must be in 1..={MAX_FRAME_BYTES}")
        request_id = self._next_request_id
        if request_id > _U64_MAX:
            raise ProtocolError("request ID space exhausted")
        self._next_request_id += 1
        request = {
            "schema": SCHEMA,
            "request_id": request_id,
            "run_id": self.run_id,
            "nonce": self._nonce,
            "max_bytes": max_bytes,
            "op": operation,
            "args": dict(arguments or {}),
        }
        try:
            encoded = json.dumps(
                request, separators=(",", ":"), allow_nan=False
            ).encode("utf-8")
        except (TypeError, ValueError, RecursionError) as error:
            raise ProtocolError("request is not finite JSON") from error
        return request_id, encoded

    def _accept_response(self, request_id: int, payload: bytes | bytearray) -> Response:
        response = _decode_object(payload, "response")
        peer_request_id = response.get("request_id")
        if (
            response.get("schema") != SCHEMA
            or isinstance(peer_request_id, bool)
            or not isinstance(peer_request_id, int)
            or peer_request_id != request_id
            or response.get("run_id") != self.run_id
        ):
            raise ProtocolError("response handshake rejected")
        epoch = response.get("epoch")
        ok = response.get("ok")
        result = response.get("result")
        if (
            isinstance(epoch, bool)
            or not isinstance(epoch, int)
            or not 0 <= epoch <= _U64_MAX
        ):
            raise ProtocolError("response epoch is not a u64")
        if not isinstance(ok, bool):
            raise ProtocolError("response ok field is not Boolean")
        if not isinstance(result, dict):
            raise ProtocolError("response result is not an object")
        result = cast(Mapping[str, Any], result)
        if not ok:
            raise RemoteError(str(result.get("error", "request rejected")))
        return Response(request_id, epoch, result)

    def capabilities(self) -> Mapping[str, Any]:
        result = self.request("capabilities").result
        if result.get("schema") != SCHEMA:
            raise ProtocolError("capability schema mismatch")
        if result.get("framing") != "u32-le-length-prefixed-json":
            raise ProtocolError("unsupported framing")
        peer_limit = result.get("max_frame_bytes")
        if (
            isinstance(peer_limit, bool)
            or not isinstance(peer_limit, int)
            or not 1 <= peer_limit <= MAX_FRAME_BYTES
        ):
            raise ProtocolError("invalid peer frame limit")
        if result.get("proof_authority") is not False:
            raise ProtocolError("campaign transport cannot claim proof authority")
        timeout_ms = result.get("socket_io_timeout_ms")
        if (
            isinstance(timeout_ms, bool)
            or not isinstance(timeout_ms, int)
            or not 1 <= timeout_ms <= 60_000
        ):
            raise ProtocolError("invalid peer socket timeout")
        if result.get("large_results") != "run-relative-create-only-files":
            raise ProtocolError("unsupported large-result policy")
        operations_value = result.get("operations")
        if not isinstance(operations_value, list):
            raise ProtocolError("invalid operation inventory")
        operation_objects = cast(list[object], operations_value)
        if any(not isinstance(operation, str) for operation in operation_objects):
            raise ProtocolError("invalid operation inventory")
        operations = cast(list[str], operations_value)
        if not {"capabilities", "status"}.issubset(operations):
            raise ProtocolError("invalid operation inventory")
        return result

    def open_proposal_session(
        self, offer: ProposalSessionOffer | None = None
    ) -> ExternalProposalSession:
        offer = offer or ProposalSessionOffer()
        result = self.request("proposal-session-open", offer.arguments()).result
        return ExternalProposalSession.from_result(self, result)

    async def open_proposal_session_async(
        self, offer: ProposalSessionOffer | None = None
    ) -> ExternalProposalSession:
        offer = offer or ProposalSessionOffer()
        result = (
            await self.request_async("proposal-session-open", offer.arguments())
        ).result
        return ExternalProposalSession.from_result(self, result)

    def iter_evidence_lines(
        self, relative_path: Path | str, *, max_line_bytes: int = 1024 * 1024
    ) -> Iterator[bytes]:
        """Stream a daemon-returned run-relative file with bounded line memory."""
        if type(max_line_bytes) is not int or max_line_bytes < 1:
            raise ValueError("max_line_bytes must be positive")
        supplied = Path(relative_path)
        if supplied.is_absolute():
            raise ProtocolError("evidence path must be run-relative")
        resolved = (self.run_dir / supplied).resolve()
        if resolved != self.run_dir and self.run_dir not in resolved.parents:
            raise ProtocolError("evidence path escapes run directory")
        with resolved.open("rb") as source:
            while line := source.readline(max_line_bytes + 1):
                if len(line) > max_line_bytes:
                    raise ProtocolError("evidence line exceeds configured limit")
                yield line

    def iter_evidence_json(
        self, relative_path: Path | str, *, max_line_bytes: int = 1024 * 1024
    ) -> Iterator[Any]:
        for line_number, line in enumerate(
            self.iter_evidence_lines(relative_path, max_line_bytes=max_line_bytes), 1
        ):
            yield _decode_json(line, f"evidence at line {line_number}")


class ProposalRole(StrEnum):
    ORDERING = "ordering"
    HEURISTIC = "heuristic"
    NECESSARY_REDUCTION = "necessary-reduction"
    EXACT_TRANSPORT = "exact-transport"

    @property
    def mask(self) -> int:
        return 1 << tuple(ProposalRole).index(self)


class ProposalFailure(StrEnum):
    MALFORMED = "malformed"
    FORBIDDEN_ROLE = "forbidden-role"
    SEMANTIC_REJECTION = "semantic-rejection"
    STALE_SNAPSHOT = "stale-snapshot"
    BUDGET_LIMIT = "budget-limit"
    DETERMINISTIC_BACKEND = "deterministic-backend"
    TRANSIENT_TRANSPORT = "transient-transport"
    PROVIDER_RATE_LIMIT = "provider-rate-limit"
    QUEUE_TIMEOUT = "queue-timeout"
    EXECUTION_TIMEOUT = "execution-timeout"
    BACKEND_CRASH = "backend-crash"
    PROTOCOL_FAULT = "protocol-fault"


@dataclass(frozen=True, slots=True, kw_only=True)
class ProposalSessionOffer:
    roles: frozenset[ProposalRole] = frozenset({ProposalRole.HEURISTIC})
    ttl_ms: int = 15 * 60 * 1000
    maximum_queries: int = 16
    maximum_outstanding: int = 4
    maximum_revisions: int = 8
    maximum_work_units: int = 1_000_000
    maximum_return_bytes: int = 64 * 1024

    def __post_init__(self) -> None:
        if not self.roles:
            raise ValueError("roles must be a nonempty ProposalRole set")
        for name in (
            "ttl_ms",
            "maximum_queries",
            "maximum_outstanding",
            "maximum_revisions",
            "maximum_work_units",
            "maximum_return_bytes",
        ):
            value = getattr(self, name)
            if type(value) is not int or value <= 0:
                raise ValueError(f"{name} must be a positive integer")
        if self.maximum_outstanding > self.maximum_queries:
            raise ValueError("maximum_outstanding exceeds maximum_queries")

    def arguments(self) -> Mapping[str, Any]:
        return {
            "allowed_roles": sum(role.mask for role in self.roles),
            "ttl_ms": self.ttl_ms,
            "maximum_queries": self.maximum_queries,
            "maximum_outstanding": self.maximum_outstanding,
            "maximum_revisions": self.maximum_revisions,
            "maximum_work_units": self.maximum_work_units,
            "maximum_return_bytes": self.maximum_return_bytes,
        }


@dataclass(frozen=True, slots=True)
class ProposalTicketView:
    ticket_key: str
    ticket: Mapping[str, Any]
    usage: Mapping[str, Any]
    claim: Mapping[str, Any] | None = None
    action: Mapping[str, Any] | str | None = None
    upload_relative_path: Path | None = None
    artifact: Mapping[str, Any] | None = None

    @classmethod
    def from_result(cls, result: Mapping[str, Any]) -> Self:
        ticket_key = _required_string(result, "ticket_key")
        ticket = _required_mapping(result, "ticket")
        usage = _required_mapping(result, "usage")
        claim_value = result.get("claim")
        if claim_value is not None and not isinstance(claim_value, dict):
            raise ProtocolError("proposal claim is not an object")
        claim = (
            None
            if claim_value is None
            else MappingProxyType(dict(cast(Mapping[str, Any], claim_value)))
        )
        action_value = result.get("action")
        if action_value is not None and not isinstance(action_value, (dict, str)):
            raise ProtocolError("proposal retry action has an invalid shape")
        action: Mapping[str, Any] | str | None = (
            MappingProxyType(dict(cast(Mapping[str, Any], action_value)))
            if isinstance(action_value, dict)
            else action_value
        )
        upload_value = result.get("upload_relative_path")
        if upload_value is not None and (
            not isinstance(upload_value, str) or not upload_value
        ):
            raise ProtocolError("proposal upload path is invalid")
        artifact_value = result.get("artifact")
        if artifact_value is not None and not isinstance(artifact_value, dict):
            raise ProtocolError("proposal artifact is not an object")
        return cls(
            ticket_key,
            MappingProxyType(dict(ticket)),
            MappingProxyType(dict(usage)),
            claim,
            action,
            None if upload_value is None else Path(upload_value),
            (
                None
                if artifact_value is None
                else MappingProxyType(dict(cast(Mapping[str, Any], artifact_value)))
            ),
        )


@dataclass(frozen=True, slots=True)
class ExternalProposalSession:
    client: Session
    session_id: str
    source_fingerprint: str
    limits: Mapping[str, Any]
    initial_usage: Mapping[str, Any]

    @classmethod
    def from_result(cls, client: Session, result: Mapping[str, Any]) -> Self:
        return cls(
            client,
            _required_string(result, "session_id"),
            _required_string(result, "source_fingerprint"),
            MappingProxyType(dict(_required_mapping(result, "limits"))),
            MappingProxyType(dict(_required_mapping(result, "usage"))),
        )

    def submit(
        self,
        *,
        request_id: int,
        payload_blake3: str,
        proposer_id: int,
        role: ProposalRole,
        cost_units: int,
        maximum_return_bytes: int,
        queue_timeout_ms: int = 30_000,
        execution_timeout_ms: int = 5 * 60 * 1000,
        admission_timeout_ms: int = 10 * 60 * 1000,
        retention_timeout_ms: int = 15 * 60 * 1000,
    ) -> ProposalTicket:
        result = self.client.request(
            "proposal-submit",
            self._submission_arguments(
                request_id=request_id,
                payload_blake3=payload_blake3,
                proposer_id=proposer_id,
                role=role,
                cost_units=cost_units,
                maximum_return_bytes=maximum_return_bytes,
                queue_timeout_ms=queue_timeout_ms,
                execution_timeout_ms=execution_timeout_ms,
                admission_timeout_ms=admission_timeout_ms,
                retention_timeout_ms=retention_timeout_ms,
            ),
        ).result
        return ProposalTicket(self, ProposalTicketView.from_result(result))

    async def submit_async(
        self,
        *,
        request_id: int,
        payload_blake3: str,
        proposer_id: int,
        role: ProposalRole,
        cost_units: int,
        maximum_return_bytes: int,
        queue_timeout_ms: int = 30_000,
        execution_timeout_ms: int = 5 * 60 * 1000,
        admission_timeout_ms: int = 10 * 60 * 1000,
        retention_timeout_ms: int = 15 * 60 * 1000,
    ) -> ProposalTicket:
        result = (
            await self.client.request_async(
                "proposal-submit",
                self._submission_arguments(
                    request_id=request_id,
                    payload_blake3=payload_blake3,
                    proposer_id=proposer_id,
                    role=role,
                    cost_units=cost_units,
                    maximum_return_bytes=maximum_return_bytes,
                    queue_timeout_ms=queue_timeout_ms,
                    execution_timeout_ms=execution_timeout_ms,
                    admission_timeout_ms=admission_timeout_ms,
                    retention_timeout_ms=retention_timeout_ms,
                ),
            )
        ).result
        return ProposalTicket(self, ProposalTicketView.from_result(result))

    def reserve_revision(
        self, payload_blake3: str, role: ProposalRole
    ) -> Mapping[str, Any]:
        result = self.client.request(
            "proposal-revision-reserve",
            {
                "session_id": self.session_id,
                "canonical_payload_blake3": _validate_digest(payload_blake3),
                "role": _validate_role(role).value,
            },
        ).result
        return MappingProxyType(dict(result))

    async def reserve_revision_async(
        self, payload_blake3: str, role: ProposalRole
    ) -> Mapping[str, Any]:
        result = (
            await self.client.request_async(
                "proposal-revision-reserve",
                {
                    "session_id": self.session_id,
                    "canonical_payload_blake3": _validate_digest(payload_blake3),
                    "role": _validate_role(role).value,
                },
            )
        ).result
        return MappingProxyType(dict(result))

    def _submission_arguments(self, **arguments: Any) -> Mapping[str, Any]:
        request_id = _positive_int(arguments["request_id"], "request_id")
        proposer_id = _bounded_int(
            arguments["proposer_id"], "proposer_id", 0, (1 << 16) - 1
        )
        role = _validate_role(arguments["role"])
        names = (
            "cost_units",
            "maximum_return_bytes",
            "queue_timeout_ms",
            "execution_timeout_ms",
            "admission_timeout_ms",
            "retention_timeout_ms",
        )
        checked = {name: _positive_int(arguments[name], name) for name in names}
        if not (
            checked["queue_timeout_ms"]
            <= checked["execution_timeout_ms"]
            <= checked["admission_timeout_ms"]
            <= checked["retention_timeout_ms"]
        ):
            raise ValueError("proposal timeouts must be nondecreasing")
        return {
            "session_id": self.session_id,
            "request_id": request_id,
            "canonical_payload_blake3": _validate_digest(arguments["payload_blake3"]),
            "proposer_id": proposer_id,
            "role": role.value,
            **checked,
        }


@dataclass(frozen=True, slots=True)
class ProposalTicket:
    session: ExternalProposalSession
    view: ProposalTicketView

    @property
    def key(self) -> str:
        return self.view.ticket_key

    def status(self) -> ProposalTicketView:
        return self._simple("proposal-status")

    async def status_async(self) -> ProposalTicketView:
        return await self._simple_async("proposal-status")

    def claim(self) -> ProposalTicketView:
        return self._simple("proposal-worker-claim")

    async def claim_async(self) -> ProposalTicketView:
        return await self._simple_async("proposal-worker-claim")

    def cancel(self) -> ProposalTicketView:
        return self._simple("proposal-cancel")

    async def cancel_async(self) -> ProposalTicketView:
        return await self._simple_async("proposal-cancel")

    def result(self) -> ProposalTicketView:
        return self._simple("proposal-result")

    async def result_async(self) -> ProposalTicketView:
        return await self._simple_async("proposal-result")

    def report_failure(
        self,
        attempt: int,
        failure: ProposalFailure,
        *,
        provider_retry_after_ms: int | None = None,
    ) -> ProposalTicketView:
        return ProposalTicketView.from_result(
            self.session.client.request(
                "proposal-worker-failure",
                self._failure_arguments(attempt, failure, provider_retry_after_ms),
            ).result
        )

    async def report_failure_async(
        self,
        attempt: int,
        failure: ProposalFailure,
        *,
        provider_retry_after_ms: int | None = None,
    ) -> ProposalTicketView:
        return ProposalTicketView.from_result(
            (
                await self.session.client.request_async(
                    "proposal-worker-failure",
                    self._failure_arguments(attempt, failure, provider_retry_after_ms),
                )
            ).result
        )

    def complete(self, attempt: int, source: BinaryIO) -> ProposalTicketView:
        """Stream a result artifact and durably complete this attempt."""
        claimed = self.claim()
        self._stage_result(attempt, source, claimed)
        return ProposalTicketView.from_result(
            self.session.client.request(
                "proposal-worker-complete",
                self._completion_arguments(attempt),
            ).result
        )

    async def complete_async(
        self, attempt: int, source: BinaryIO
    ) -> ProposalTicketView:
        """Asynchronously claim, stream off-loop, and complete this attempt."""
        claimed = await self.claim_async()
        await asyncio.to_thread(self._stage_result, attempt, source, claimed)
        return ProposalTicketView.from_result(
            (
                await self.session.client.request_async(
                    "proposal-worker-complete",
                    self._completion_arguments(attempt),
                )
            ).result
        )

    def _simple(self, operation: str) -> ProposalTicketView:
        return ProposalTicketView.from_result(
            self.session.client.request(operation, self._identity_arguments()).result
        )

    async def _simple_async(self, operation: str) -> ProposalTicketView:
        return ProposalTicketView.from_result(
            (
                await self.session.client.request_async(
                    operation, self._identity_arguments()
                )
            ).result
        )

    def _identity_arguments(self) -> Mapping[str, Any]:
        return {"session_id": self.session.session_id, "ticket_key": self.key}

    def _failure_arguments(
        self,
        attempt: int,
        failure: object,
        provider_retry_after_ms: int | None,
    ) -> Mapping[str, Any]:
        if not isinstance(failure, ProposalFailure):
            raise TypeError("failure must be a ProposalFailure")
        retry_after = None
        if provider_retry_after_ms is not None:
            retry_after = _positive_int(
                provider_retry_after_ms, "provider_retry_after_ms"
            )
        return {
            **self._identity_arguments(),
            "attempt": _bounded_int(attempt, "attempt", 0, 255),
            "failure": failure.value,
            "provider_retry_after_ms": retry_after,
        }

    def _completion_arguments(self, attempt: int) -> Mapping[str, Any]:
        return {
            **self._identity_arguments(),
            "attempt": _bounded_int(attempt, "attempt", 0, 255),
        }

    def _stage_result(
        self, attempt: int, source: BinaryIO, claimed: ProposalTicketView
    ) -> None:
        claim = claimed.claim
        if claim is None or claim.get("kind") not in {"started", "busy"}:
            raise ProtocolError("proposal attempt is not claimable")
        claim_attempt = claim.get("attempt")
        if isinstance(claim_attempt, bool) or claim_attempt != attempt:
            raise ProtocolError("proposal claim names a different attempt")
        relative_path = claimed.upload_relative_path
        if relative_path is None:
            raise ProtocolError("proposal claim omitted its upload path")
        spec = _required_mapping(claimed.ticket, "spec")
        maximum_bytes = _positive_int(spec.get("max_return_bytes"), "max_return_bytes")
        destination = _confined_run_path(self.session.client.run_dir, relative_path)
        descriptor = os.open(
            destination,
            os.O_WRONLY | os.O_CREAT | os.O_EXCL | os.O_NOFOLLOW,
            0o600,
        )
        total = 0
        try:
            with os.fdopen(descriptor, "wb", buffering=0) as output:
                while chunk := source.read(64 * 1024):
                    total += len(chunk)
                    if total > maximum_bytes:
                        raise ProtocolError("proposal result exceeds ticket byte bound")
                    output.write(chunk)
                output.flush()
                os.fsync(output.fileno())
        except BaseException:
            destination.unlink(missing_ok=True)
            raise


def _confined_run_path(run_dir: Path, relative_path: Path) -> Path:
    if relative_path.is_absolute():
        raise ProtocolError("proposal artifact path must be run-relative")
    destination = run_dir / relative_path
    parent = destination.parent.resolve()
    if parent != run_dir and run_dir not in parent.parents:
        raise ProtocolError("proposal artifact path escapes run directory")
    return parent / destination.name


def _required_string(value: Mapping[str, Any], key: str) -> str:
    result = value.get(key)
    if not isinstance(result, str) or not result:
        raise ProtocolError(f"proposal response omitted {key}")
    return result


def _required_mapping(value: Mapping[str, Any], key: str) -> Mapping[str, Any]:
    result = value.get(key)
    if not isinstance(result, dict):
        raise ProtocolError(f"proposal response {key} is not an object")
    return cast(Mapping[str, Any], result)


def _positive_int(value: Any, name: str) -> int:
    return _bounded_int(value, name, 1, _U64_MAX)


def _bounded_int(value: Any, name: str, minimum: int, maximum: int) -> int:
    if (
        isinstance(value, bool)
        or not isinstance(value, int)
        or not minimum <= value <= maximum
    ):
        raise ValueError(f"{name} must be in {minimum}..={maximum}")
    return value


def _validate_digest(value: Any) -> str:
    if (
        not isinstance(value, str)
        or len(value) != 64
        or any(character not in "0123456789abcdef" for character in value)
    ):
        raise ValueError("BLAKE3 digest must be 64 lowercase hexadecimal digits")
    return value


def _validate_role(value: Any) -> ProposalRole:
    if not isinstance(value, ProposalRole):
        raise TypeError("role must be a ProposalRole")
    return value
