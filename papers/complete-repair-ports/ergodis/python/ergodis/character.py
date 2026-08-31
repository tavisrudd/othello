from __future__ import annotations

from collections.abc import Iterable, Mapping, Sequence
from dataclasses import dataclass
from typing import Protocol, SupportsInt, TypeIs, cast

from ._rpc import RpcClient


type Coefficient = int | SupportsInt
type PolynomialLike = Polynomial | Iterable[Coefficient]
type LinearTwist = tuple[int, int]


class _SympyPolynomial(Protocol):
    def all_coeffs(self) -> Sequence[Coefficient]: ...


@dataclass(frozen=True, slots=True)
class Polynomial:
    """Dense polynomial with coefficients in ascending degree order."""

    coefficients: tuple[int, ...]

    def __init__(self, coefficients: Iterable[Coefficient]):
        object.__setattr__(self, "coefficients", tuple(int(value) for value in coefficients))

    @classmethod
    def from_sympy(cls, polynomial: object) -> Polynomial:
        all_coeffs = getattr(polynomial, "all_coeffs", None)
        if not callable(all_coeffs):
            raise TypeError("expected an object with an all_coeffs() method")
        typed = cast(_SympyPolynomial, polynomial)
        return cls(reversed(typed.all_coeffs()))


@dataclass(frozen=True, slots=True)
class CharacterCensus:
    value: int
    positive: int
    negative: int
    zero: int

    def __post_init__(self) -> None:
        if min(self.positive, self.negative, self.zero) < 0:
            raise ValueError("character census counts must be nonnegative")
        if self.value != self.positive - self.negative:
            raise ValueError("character census value does not match its witness counts")

    @property
    def total(self) -> int:
        return self.positive + self.negative + self.zero


@dataclass(frozen=True, slots=True)
class CharacterSumQuery:
    name: str
    polynomial: Polynomial
    twist: LinearTwist | None = None

    def __init__(
        self,
        name: str,
        polynomial: PolynomialLike,
        *,
        twist: LinearTwist | None = None,
    ):
        object.__setattr__(self, "name", name)
        object.__setattr__(self, "polynomial", _polynomial(polynomial))
        object.__setattr__(self, "twist", twist)


@dataclass(frozen=True, slots=True)
class NamedCharacterCensus:
    name: str
    census: CharacterCensus


@dataclass(frozen=True, slots=True)
class CharacterSumBatch:
    modulus: int
    results: tuple[NamedCharacterCensus, ...]

    def __getitem__(self, name: str) -> CharacterCensus:
        for result in self.results:
            if result.name == name:
                return result.census
        raise KeyError(name)


class QuadraticCharacter:
    __slots__ = ("_rpc", "modulus")

    def __init__(self, rpc: RpcClient, modulus: int):
        self._rpc = rpc
        self.modulus = modulus

    def sum(
        self,
        polynomial: PolynomialLike,
        /,
        *,
        twist: LinearTwist | None = None,
    ) -> CharacterCensus:
        result = self.sum_many([CharacterSumQuery("sum", polynomial, twist=twist)])
        return result.results[0].census

    def sum_many(self, queries: Iterable[CharacterSumQuery], /) -> CharacterSumBatch:
        encoded: list[dict[str, object]] = []
        for query in queries:
            item: dict[str, object] = {
                "name": query.name,
                "coefficients": query.polynomial.coefficients,
            }
            if query.twist is not None:
                item["linear_twist"] = query.twist
            encoded.append(item)
        return self._rpc.call(
            "character_sum.census",
            {"modulus": self.modulus, "queries": encoded},
            decode=_decode_batch,
        )


def _polynomial(value: PolynomialLike) -> Polynomial:
    return value if isinstance(value, Polynomial) else Polynomial(value)


def _is_mapping(value: object) -> TypeIs[dict[str, object]]:
    if not isinstance(value, dict):
        return False
    untyped = cast(dict[object, object], value)
    return all(isinstance(key, str) for key in untyped)


def _integer(mapping: Mapping[str, object], key: str) -> int:
    value = mapping.get(key)
    if not isinstance(value, int) or isinstance(value, bool):
        raise TypeError(f"expected integer field {key!r}")
    return value


def _decode_batch(value: object) -> CharacterSumBatch:
    if not _is_mapping(value):
        raise TypeError("character-sum result is not an object")
    modulus = _integer(value, "modulus")
    raw_queries = value.get("queries")
    if not isinstance(raw_queries, list):
        raise TypeError("character-sum queries result is not a list")
    results: list[NamedCharacterCensus] = []
    for raw in cast(list[object], raw_queries):
        if not _is_mapping(raw):
            raise TypeError("character-sum query result is malformed")
        name = raw.get("name")
        if not isinstance(name, str):
            raise TypeError("character-sum query result has no string name")
        census = CharacterCensus(
            value=_integer(raw, "sum"),
            positive=_integer(raw, "positive"),
            negative=_integer(raw, "negative"),
            zero=_integer(raw, "zero"),
        )
        results.append(NamedCharacterCensus(name, census))
    return CharacterSumBatch(modulus, tuple(results))
