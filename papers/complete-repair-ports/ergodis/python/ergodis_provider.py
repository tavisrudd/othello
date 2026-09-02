"""Provider-neutral asynchronous execution for Ergodis proposal tickets.

Backends implement one attempt.  This runner owns claim/defer transitions,
absolute execution deadlines, typed failure reporting, and streamed completion.
It never polls and never invents retry policy outside the daemon ledger.
"""

from __future__ import annotations

import asyncio
import time
from collections.abc import Awaitable, Callable, Mapping
from dataclasses import dataclass
from pathlib import Path
from typing import BinaryIO, cast

from ergodis_client import (
    ProposalFailure,
    ProposalRequestSchema,
    ProposalTicket,
    ProposalTicketView,
    ProtocolError,
)

type ProviderCall = Callable[["ProviderInvocation"], Awaitable[BinaryIO]]
type ClockMilliseconds = Callable[[], int]
type AsyncSleep = Callable[[float], Awaitable[None]]


@dataclass(frozen=True, slots=True)
class ProviderInvocation:
    """One attempt under the daemon's immutable execution deadline."""

    ticket_key: str
    attempt: int
    execute_by_ms: int
    remaining_ms: int
    maximum_return_bytes: int
    request_path: Path
    request_schema: ProposalRequestSchema


class ProviderFailure(Exception):
    """A backend-classified failure safe to feed to daemon retry policy."""

    def __init__(
        self,
        failure: ProposalFailure,
        message: str = "provider attempt failed",
        *,
        retry_after_ms: int | None = None,
    ) -> None:
        if retry_after_ms is not None and (
            type(retry_after_ms) is not int or retry_after_ms <= 0
        ):
            raise ValueError("retry_after_ms must be a positive integer")
        super().__init__(message)
        self.failure = failure
        self.retry_after_ms = retry_after_ms


class ProviderRunner:
    """Drive one durable ticket until it is deferred, busy, or terminal."""

    def __init__(
        self,
        *,
        clock_ms: ClockMilliseconds | None = None,
        sleep: AsyncSleep = asyncio.sleep,
    ) -> None:
        self._clock_ms = clock_ms or _unix_epoch_ms
        self._sleep = sleep

    async def run(
        self, ticket: ProposalTicket, call: ProviderCall
    ) -> ProposalTicketView:
        """Run policy-approved attempts; close every returned result stream."""
        while True:
            claimed = await ticket.claim_async()
            claim = claimed.claim
            if claim is None:
                raise ProtocolError("provider claim response omitted claim state")
            kind = claim.get("kind")
            if kind == "deferred":
                await self._sleep_until(_required_milliseconds(claim, "not_before_ms"))
                continue
            if kind == "provider-deferred":
                await self._sleep_until(_required_milliseconds(claim, "retry_at_ms"))
                continue
            if kind in {"busy", "provider-busy", "terminal"}:
                return claimed
            if kind != "started":
                raise ProtocolError("provider claim has an unknown state")
            attempt = _required_attempt(claim)
            execute_by_ms = _execution_deadline(claimed)
            remaining_ms = execute_by_ms - self._clock_ms()
            if remaining_ms <= 0:
                outcome = await ticket.report_failure_async(
                    attempt, ProposalFailure.EXECUTION_TIMEOUT
                )
                if _is_retry_wait(outcome):
                    continue
                return outcome
            invocation = ProviderInvocation(
                ticket.key,
                attempt,
                execute_by_ms,
                remaining_ms,
                _maximum_return_bytes(claimed),
                _request_path(ticket, claimed),
                _request_schema(claimed),
            )
            try:
                async with asyncio.timeout(remaining_ms / 1_000):
                    result = await call(invocation)
            except TimeoutError:
                outcome = await ticket.report_failure_async(
                    attempt, ProposalFailure.EXECUTION_TIMEOUT
                )
            except ProviderFailure as error:
                outcome = await ticket.report_failure_async(
                    attempt,
                    error.failure,
                    provider_retry_after_ms=error.retry_after_ms,
                )
            except OSError:
                outcome = await ticket.report_failure_async(
                    attempt, ProposalFailure.TRANSIENT_TRANSPORT
                )
            except Exception:
                outcome = await ticket.report_failure_async(
                    attempt, ProposalFailure.BACKEND_CRASH
                )
            else:
                with result:
                    return await ticket.complete_async(attempt, result)
            if _is_retry_wait(outcome):
                continue
            return outcome

    async def _sleep_until(self, not_before_ms: int) -> None:
        delay_ms = not_before_ms - self._clock_ms()
        if delay_ms > 0:
            await self._sleep(delay_ms / 1_000)


def _unix_epoch_ms() -> int:
    return time.time_ns() // 1_000_000


def _required_milliseconds(value: object, key: str) -> int:
    result = _required_mapping(value, "provider state").get(key)
    if isinstance(result, bool) or not isinstance(result, int) or result < 0:
        raise ProtocolError(f"provider state {key} is not milliseconds")
    return result


def _required_attempt(claim: Mapping[str, object]) -> int:
    attempt = claim.get("attempt")
    if (
        isinstance(attempt, bool)
        or not isinstance(attempt, int)
        or not 0 <= attempt <= 255
    ):
        raise ProtocolError("provider claim attempt is not a u8")
    return attempt


def _execution_deadline(view: ProposalTicketView) -> int:
    spec = _required_mapping(view.ticket.get("spec"), "provider ticket specification")
    deadlines = spec.get("deadlines")
    return _required_milliseconds(deadlines, "execute_by_ms")


def _maximum_return_bytes(view: ProposalTicketView) -> int:
    spec = _required_mapping(view.ticket.get("spec"), "provider ticket specification")
    maximum = spec.get("max_return_bytes")
    if isinstance(maximum, bool) or not isinstance(maximum, int) or maximum <= 0:
        raise ProtocolError("provider ticket return-byte bound is invalid")
    return maximum


def _request_path(ticket: ProposalTicket, view: ProposalTicketView) -> Path:
    artifact = view.request_artifact
    if artifact is None:
        raise ProtocolError("provider claim omitted its request artifact")
    relative = artifact.get("relative_path")
    if not isinstance(relative, str) or not relative:
        raise ProtocolError("provider request artifact path is invalid")
    supplied = Path(relative)
    if supplied.is_absolute():
        raise ProtocolError("provider request artifact path must be run-relative")
    root = ticket.session.client.run_dir
    resolved = (root / supplied).resolve()
    if resolved != root and root not in resolved.parents:
        raise ProtocolError("provider request artifact path escapes run directory")
    return resolved


def _request_schema(view: ProposalTicketView) -> ProposalRequestSchema:
    if view.request_schema is None:
        raise ProtocolError("provider claim omitted its request schema")
    return view.request_schema


def _is_retry_wait(view: ProposalTicketView) -> bool:
    status = _required_mapping(view.ticket.get("status"), "provider ticket status")
    state = status.get("state")
    if not isinstance(state, str):
        raise ProtocolError("provider ticket status state is invalid")
    return state == "retry-wait"


def _required_mapping(value: object, description: str) -> Mapping[str, object]:
    if not isinstance(value, Mapping):
        raise ProtocolError(f"{description} is not an object")
    return cast(Mapping[str, object], value)
