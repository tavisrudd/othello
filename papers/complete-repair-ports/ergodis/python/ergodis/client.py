from __future__ import annotations

import os
from collections.abc import Callable, Mapping
from dataclasses import dataclass
from typing import Self

from ._rpc import RpcClient
from .character import QuadraticCharacter


@dataclass(frozen=True, slots=True)
class PrimeField:
    _rpc: RpcClient
    order: int

    @property
    def quadratic_character(self) -> QuadraticCharacter:
        return QuadraticCharacter(self._rpc, self.order)


class Client:
    """Pythonic façade over one persistent Ergodis worker process."""

    __slots__ = ("_rpc",)

    def __init__(self, binary: os.PathLike[str] | str | None = None):
        self._rpc = RpcClient(binary)

    def prime_field(self, order: int, /) -> PrimeField:
        return PrimeField(self._rpc, order)

    def GF(self, order: int, /) -> PrimeField:
        """Sage-compatible spelling for a prime-field proxy."""
        return self.prime_field(order)

    def call[T](
        self,
        method: str,
        params: Mapping[str, object],
        /,
        *,
        decode: Callable[[object], T],
    ) -> T:
        """Typed escape hatch for newly registered methods."""
        return self._rpc.call(method, params, decode=decode)

    def discover(self) -> Mapping[str, object]:
        return self._rpc.discover()

    def close(self) -> None:
        self._rpc.close()

    def __enter__(self) -> Self:
        return self

    def __exit__(self, exc_type: object, exc_value: object, traceback: object) -> None:
        self.close()
