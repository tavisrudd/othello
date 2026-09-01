use std::marker::PhantomData;
use std::ops::{Add, Mul, Sub};

use serde::{Deserialize, Serialize};
use thiserror::Error;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Error)]
pub enum FieldError {
    #[error("the modulus must be prime and lie in 2..=251")]
    InvalidModulus,
    #[error("zero has no multiplicative inverse")]
    ZeroInverse,
    #[error("field element lies outside the canonical encoding")]
    InvalidElement,
    #[error("extension degree must be positive and the field order must fit in 256 elements")]
    InvalidExtensionDegree,
    #[error("the modulus must be monic, reduced, and irreducible over the prime field")]
    InvalidExtensionModulus,
    #[error("the field is not the requested binary extension GF(2^h)")]
    BinaryExtensionMismatch,
}

mod private {
    pub trait Sealed {}

    pub trait FieldOps {
        fn add(left: u8, right: u8) -> u8;
        fn sub(left: u8, right: u8) -> u8;
        fn mul(left: u8, right: u8) -> u8;
        fn inverse(value: u8) -> Result<u8, super::FieldError>;
    }
}

/// Exact identity of a finite-field presentation and its byte encoding.
///
/// Finite fields of the same order are abstractly isomorphic, but matrices of
/// encoded bytes cannot be silently moved across different polynomial bases.
/// The lower coefficients encode `a_0 + a_1 p + ...`; the monic leading
/// coefficient is implicit. All supported fields have order at most 256, so
/// this representation is exact rather than hashed.
#[repr(transparent)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub struct FieldPresentation(u64);

const _: () = assert!(std::mem::size_of::<FieldPresentation>() == 8);
const _: () = assert!(std::mem::align_of::<FieldPresentation>() == 8);

const FIELD_PRESENTATION_MAGIC: u64 = 0x4552_4746_0000_0000;

impl FieldPresentation {
    const fn new(characteristic: u8, degree: u8, lower_modulus: u16) -> Self {
        Self(
            FIELD_PRESENTATION_MAGIC
                | ((characteristic as u64) << 24)
                | ((degree as u64) << 16)
                | lower_modulus as u64,
        )
    }
}

/// Marker for a monomorphized finite field whose elements fit in one byte.
///
/// Implementations use a canonical integer encoding in `0..ORDER`. CLI field
/// dispatch happens before client loops. Public arithmetic is deliberately
/// available only through [`FieldElement`], which validates raw bytes once and
/// then carries no runtime tag.
///
/// Raw-byte arithmetic is not part of this trait's public surface:
///
/// ```compile_fail
/// use ergodis::{FiniteField, Prime};
/// let _ = <Prime<5> as FiniteField>::mul(2, 3);
/// ```
pub trait FiniteField: private::Sealed + private::FieldOps + Copy + Send + Sync + 'static {
    const ORDER: u8;
    const CHARACTERISTIC: u8;
    const PRESENTATION: FieldPresentation;

    fn validate() -> Result<(), FieldError>;
}

/// Canonically encoded element branded by its exact static field.
///
/// Raw bytes are checked once by [`FieldElement::new`]. Arithmetic between
/// branded values then needs no repeated range or presentation test. The
/// marker occupies no storage.
///
/// Elements of distinct fields cannot be mixed:
///
/// ```compile_fail
/// use ergodis::{FieldElement, Prime};
/// let left = FieldElement::<Prime<5>>::new(1).unwrap();
/// let right = FieldElement::<Prime<7>>::new(1).unwrap();
/// let _ = left + right;
/// ```
#[repr(transparent)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct FieldElement<F: FiniteField> {
    value: u8,
    _field: PhantomData<fn() -> F>,
}

const _: () = assert!(std::mem::size_of::<FieldElement<Prime<2>>>() == 1);
const _: () = assert!(std::mem::align_of::<FieldElement<Prime<2>>>() == 1);

impl<F: FiniteField> FieldElement<F> {
    #[inline]
    pub fn new(value: u8) -> Result<Self, FieldError> {
        F::validate()?;
        if value >= F::ORDER {
            return Err(FieldError::InvalidElement);
        }
        Ok(Self::from_canonical(value))
    }

    #[inline(always)]
    pub const fn value(self) -> u8 {
        self.value
    }

    #[inline]
    pub fn inverse(self) -> Result<Self, FieldError> {
        F::inverse(self.value).map(Self::from_canonical)
    }

    #[inline(always)]
    pub(crate) const fn from_canonical(value: u8) -> Self {
        Self {
            value,
            _field: PhantomData,
        }
    }
}

impl<F: FiniteField> Add for FieldElement<F> {
    type Output = Self;

    #[inline(always)]
    fn add(self, right: Self) -> Self {
        Self::from_canonical(F::add(self.value, right.value))
    }
}

impl<F: FiniteField> Sub for FieldElement<F> {
    type Output = Self;

    #[inline(always)]
    fn sub(self, right: Self) -> Self {
        Self::from_canonical(F::sub(self.value, right.value))
    }
}

impl<F: FiniteField> Mul for FieldElement<F> {
    type Output = Self;

    #[inline(always)]
    fn mul(self, right: Self) -> Self {
        Self::from_canonical(F::mul(self.value, right.value))
    }
}

/// Monomorphized arithmetic for a small prime field.
///
/// The modulus is resolved at the call site, not tested inside client loops.
/// Invalid moduli remain inspectable through [`Prime::validate`], but cannot be
/// instantiated into arithmetic:
///
/// ```compile_fail
/// use ergodis::{FieldElement, Prime};
/// let _ = FieldElement::<Prime<9>>::new(2);
/// ```
#[derive(Debug, Clone, Copy, Default)]
pub struct Prime<const P: u8>;

impl<const P: u8> private::Sealed for Prime<P> {}

impl<const P: u8> Prime<P> {
    const VALID_MODULUS: () = assert!(P >= 2 && is_prime(P));

    #[inline(always)]
    fn require_valid_modulus() {
        let () = Self::VALID_MODULUS;
    }

    pub fn validate() -> Result<(), FieldError> {
        if P < 2 || !is_prime(P) {
            return Err(FieldError::InvalidModulus);
        }
        Ok(())
    }

    #[inline(always)]
    pub(crate) fn add(left: u8, right: u8) -> u8 {
        Self::require_valid_modulus();
        let sum = left as u16 + right as u16;
        (sum % P as u16) as u8
    }

    #[inline(always)]
    pub(crate) fn sub(left: u8, right: u8) -> u8 {
        Self::require_valid_modulus();
        ((left as u16 + P as u16 - right as u16) % P as u16) as u8
    }

    #[inline(always)]
    pub(crate) fn mul(left: u8, right: u8) -> u8 {
        Self::require_valid_modulus();
        ((left as u16 * right as u16) % P as u16) as u8
    }

    pub(crate) fn inverse(value: u8) -> Result<u8, FieldError> {
        Self::require_valid_modulus();
        if value == 0 {
            return Err(FieldError::ZeroInverse);
        }
        Ok(Self::pow(value, P as u16 - 2))
    }

    #[inline]
    pub(crate) fn pow(mut base: u8, mut exponent: u16) -> u8 {
        Self::require_valid_modulus();
        let mut result = 1u8;
        while exponent != 0 {
            if exponent & 1 != 0 {
                result = Self::mul(result, base);
            }
            base = Self::mul(base, base);
            exponent >>= 1;
        }
        result
    }
}

impl<const P: u8> FiniteField for Prime<P> {
    const ORDER: u8 = {
        let () = Self::VALID_MODULUS;
        P
    };
    const CHARACTERISTIC: u8 = P;
    const PRESENTATION: FieldPresentation = FieldPresentation::new(P, 1, 0);

    #[inline]
    fn validate() -> Result<(), FieldError> {
        Self::validate()
    }
}

impl<const P: u8> private::FieldOps for Prime<P> {
    #[inline(always)]
    fn add(left: u8, right: u8) -> u8 {
        Self::add(left, right)
    }

    #[inline(always)]
    fn sub(left: u8, right: u8) -> u8 {
        Self::sub(left, right)
    }

    #[inline(always)]
    fn mul(left: u8, right: u8) -> u8 {
        Self::mul(left, right)
    }

    #[inline]
    fn inverse(value: u8) -> Result<u8, FieldError> {
        Self::inverse(value)
    }
}

/// Canonical polynomial-basis arithmetic for
/// `GF(4) = GF(2)[a] / (a^2 + a + 1)`.
///
/// The low bit is the coefficient of `1` and the high bit is the coefficient
/// of `a`: `0`, `1`, `a`, and `a + 1` are encoded as `0`, `1`, `2`, and `3`.
#[derive(Debug, Clone, Copy, Default)]
pub struct Gf4;

impl private::Sealed for Gf4 {}

impl FiniteField for Gf4 {
    const ORDER: u8 = 4;
    const CHARACTERISTIC: u8 = 2;
    const PRESENTATION: FieldPresentation = FieldPresentation::new(2, 2, 3);

    #[inline]
    fn validate() -> Result<(), FieldError> {
        Ok(())
    }
}

impl private::FieldOps for Gf4 {
    #[inline(always)]
    fn add(left: u8, right: u8) -> u8 {
        left ^ right
    }

    #[inline(always)]
    fn sub(left: u8, right: u8) -> u8 {
        left ^ right
    }

    #[inline(always)]
    fn mul(left: u8, right: u8) -> u8 {
        let left_constant = left & 1;
        let left_alpha = left >> 1;
        let right_constant = right & 1;
        let right_alpha = right >> 1;
        let alpha_product = left_alpha & right_alpha;
        let constant = (left_constant & right_constant) ^ alpha_product;
        let alpha = (left_constant & right_alpha) ^ (left_alpha & right_constant) ^ alpha_product;
        constant | (alpha << 1)
    }

    #[inline]
    fn inverse(value: u8) -> Result<u8, FieldError> {
        match value {
            0 => Err(FieldError::ZeroInverse),
            1 => Ok(1),
            2 => Ok(3),
            3 => Ok(2),
            _ => Err(FieldError::InvalidElement),
        }
    }
}

#[cfg(test)]
impl Gf4 {
    #[inline(always)]
    pub(crate) fn add(left: u8, right: u8) -> u8 {
        <Self as private::FieldOps>::add(left, right)
    }

    #[inline(always)]
    pub(crate) fn sub(left: u8, right: u8) -> u8 {
        <Self as private::FieldOps>::sub(left, right)
    }

    #[inline(always)]
    pub(crate) fn mul(left: u8, right: u8) -> u8 {
        <Self as private::FieldOps>::mul(left, right)
    }

    #[inline]
    pub(crate) fn inverse(value: u8) -> Result<u8, FieldError> {
        <Self as private::FieldOps>::inverse(value)
    }
}

/// Table-backed arithmetic for a runtime-selected field `GF(p^h)` of order at
/// most 256.
///
/// This type is deliberately a finite *field*, not an arbitrary algebra with
/// `p^h` elements.  In particular, `SmallField::new(2, 2)` constructs `GF(4)`;
/// it does not describe `Z/4Z` or `F_2[u]/(u^2)`.  Elements are stored as raw
/// bytes, so callers importing externally encoded algebra data must establish
/// that field identity before using it with this type.
///
/// Elements use the polynomial-basis encoding
/// `a_0 + a_1 x + ... + a_(h-1) x^(h-1) -> sum a_i p^i`. Construction is a
/// cold operation: it locates or validates an irreducible monic modulus and
/// builds flat addition, subtraction, multiplication, and inverse tables.
/// Arithmetic thereafter allocates nothing and performs one indexed lookup.
#[derive(Clone, Debug)]
pub struct SmallField {
    order: u16,
    characteristic: u8,
    degree: u8,
    modulus: Box<[u8]>,
    add: Box<[u8]>,
    subtract: Box<[u8]>,
    multiply: Box<[u8]>,
    inverse: Box<[u8]>,
}

/// Monomorphized arithmetic view of a validated runtime field `GF(2^H)`.
///
/// Construction checks the characteristic and order once.  Arithmetic then
/// uses XOR for addition/subtraction and a shift-indexed multiplication table;
/// no run-constant field-kind branch remains in client loops.  As with
/// [`FiniteField`], arithmetic operands must use the canonical field encoding.
#[repr(transparent)]
#[derive(Clone, Copy, Debug)]
pub struct BinarySmallField<'a, const H: u8>(&'a SmallField);

const _: () = assert!(std::mem::size_of::<BinarySmallField<'static, 1>>() == 8);
const _: () = assert!(std::mem::align_of::<BinarySmallField<'static, 1>>() == 8);

struct BinaryDegree<const H: u8>;

/// Canonically encoded element of a binary extension field of degree `H`.
///
/// Construction is checked by [`BinarySmallField::element`]. The degree marker
/// occupies no storage, so arrays and slices have the same layout as `u8`.
#[repr(transparent)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct BinaryElement<const H: u8> {
    value: u8,
    _degree: PhantomData<BinaryDegree<H>>,
}

const _: () = assert!(std::mem::size_of::<BinaryElement<1>>() == 1);
const _: () = assert!(std::mem::align_of::<BinaryElement<1>>() == 1);

impl<const H: u8> BinaryElement<H> {
    #[inline(always)]
    pub const fn value(self) -> u8 {
        self.value
    }

    #[inline(always)]
    pub(crate) const fn from_canonical(value: u8) -> Self {
        Self {
            value,
            _degree: PhantomData,
        }
    }
}

impl<'a, const H: u8> BinarySmallField<'a, H> {
    pub fn new(field: &'a SmallField) -> Result<Self, FieldError> {
        let expected_order = 1_u16
            .checked_shl(u32::from(H))
            .filter(|&order| H != 0 && order <= 256)
            .ok_or(FieldError::BinaryExtensionMismatch)?;
        if field.characteristic != 2 || field.order != expected_order {
            return Err(FieldError::BinaryExtensionMismatch);
        }
        Ok(Self(field))
    }

    #[inline]
    pub const fn degree(self) -> u8 {
        H
    }

    #[inline]
    pub const fn order(self) -> u16 {
        1_u16 << H
    }

    #[inline]
    pub fn element(self, value: u8) -> Result<BinaryElement<H>, FieldError> {
        if u16::from(value) >= self.order() {
            return Err(FieldError::InvalidElement);
        }
        Ok(BinaryElement::from_canonical(value))
    }

    #[inline(always)]
    pub const fn zero(self) -> BinaryElement<H> {
        BinaryElement::from_canonical(0)
    }

    #[inline(always)]
    pub const fn one(self) -> BinaryElement<H> {
        BinaryElement::from_canonical(1)
    }

    #[inline(always)]
    pub fn add_element(self, left: BinaryElement<H>, right: BinaryElement<H>) -> BinaryElement<H> {
        BinaryElement::from_canonical(left.value ^ right.value)
    }

    #[inline(always)]
    pub fn sub_element(self, left: BinaryElement<H>, right: BinaryElement<H>) -> BinaryElement<H> {
        self.add_element(left, right)
    }

    #[inline(always)]
    pub fn mul_element(self, left: BinaryElement<H>, right: BinaryElement<H>) -> BinaryElement<H> {
        BinaryElement::from_canonical(self.mul_canonical(left.value, right.value))
    }

    #[inline(always)]
    pub fn add(self, left: u8, right: u8) -> u8 {
        assert!(
            u16::from(left) < self.order() && u16::from(right) < self.order(),
            "field element is not reduced"
        );
        left ^ right
    }

    #[inline(always)]
    pub fn sub(self, left: u8, right: u8) -> u8 {
        self.add(left, right)
    }

    #[inline(always)]
    pub fn mul(self, left: u8, right: u8) -> u8 {
        assert!(
            u16::from(left) < self.order() && u16::from(right) < self.order(),
            "field element is not reduced"
        );
        self.mul_canonical(left, right)
    }

    #[inline(always)]
    pub(crate) fn mul_canonical(self, left: u8, right: u8) -> u8 {
        debug_assert!(u16::from(left) < self.order() && u16::from(right) < self.order());
        self.0.multiply[(usize::from(left) << H) | usize::from(right)]
    }

    #[inline]
    pub fn inverse(self, value: u8) -> Result<u8, FieldError> {
        if value == 0 {
            return Err(FieldError::ZeroInverse);
        }
        self.0
            .inverse
            .get(usize::from(value))
            .copied()
            .ok_or(FieldError::InvalidElement)
    }

    #[inline(always)]
    pub(crate) fn inverse_nonzero(self, value: u8) -> u8 {
        debug_assert!(value != 0 && u16::from(value) < self.order());
        self.0.inverse[usize::from(value)]
    }
}

impl SmallField {
    /// Construct the canonical field using the lexicographically first monic
    /// irreducible polynomial in polynomial-basis encoding.
    ///
    /// The arguments identify `GF(characteristic^degree)`, not merely an
    /// algebra of that cardinality.  Equal-cardinality rings are not accepted
    /// or inferred by this constructor.
    pub fn new(characteristic: u8, degree: u8) -> Result<Self, FieldError> {
        extension_order(characteristic, degree)?;
        let modulus =
            first_irreducible(characteristic, degree).ok_or(FieldError::InvalidExtensionModulus)?;
        Self::from_modulus(characteristic, &modulus[..=usize::from(degree)])
    }

    /// Validate once and borrow this runtime field as `GF(2^H)` arithmetic.
    pub fn binary_extension<const H: u8>(&self) -> Result<BinarySmallField<'_, H>, FieldError> {
        BinarySmallField::new(self)
    }

    /// Construct a field from low-to-high coefficients of a monic irreducible
    /// polynomial. The slice length is `h + 1`.
    pub fn from_modulus(characteristic: u8, modulus: &[u8]) -> Result<Self, FieldError> {
        let degree = modulus
            .len()
            .checked_sub(1)
            .and_then(|degree| u8::try_from(degree).ok())
            .ok_or(FieldError::InvalidExtensionDegree)?;
        let order = extension_order(characteristic, degree)?;
        if modulus.last() != Some(&1)
            || modulus
                .iter()
                .any(|&coefficient| coefficient >= characteristic)
            || !polynomial_is_irreducible(characteristic, modulus)
        {
            return Err(FieldError::InvalidExtensionModulus);
        }
        let table_len = usize::from(order) * usize::from(order);
        let mut add = vec![0; table_len];
        let mut subtract = vec![0; table_len];
        let mut multiply = vec![0; table_len];
        for left in 0..order {
            for right in 0..order {
                let slot = usize::from(left) * usize::from(order) + usize::from(right);
                add[slot] = extension_add(left, right, characteristic, degree, false);
                subtract[slot] = extension_add(left, right, characteristic, degree, true);
                multiply[slot] = extension_multiply(left, right, characteristic, degree, modulus);
            }
        }
        let mut inverse = vec![0; usize::from(order)];
        for value in 1..order {
            let row = usize::from(value) * usize::from(order);
            let candidate = (1..order)
                .find(|&candidate| multiply[row + usize::from(candidate)] == 1)
                .ok_or(FieldError::InvalidExtensionModulus)?;
            inverse[usize::from(value)] = candidate as u8;
        }
        Ok(Self {
            order,
            characteristic,
            degree,
            modulus: modulus.into(),
            add: add.into_boxed_slice(),
            subtract: subtract.into_boxed_slice(),
            multiply: multiply.into_boxed_slice(),
            inverse: inverse.into_boxed_slice(),
        })
    }

    #[inline]
    pub const fn order(&self) -> u16 {
        self.order
    }

    #[inline]
    pub const fn characteristic(&self) -> u8 {
        self.characteristic
    }

    #[inline]
    pub const fn degree(&self) -> u8 {
        self.degree
    }

    #[inline]
    pub fn modulus(&self) -> &[u8] {
        &self.modulus
    }

    /// Return the exact characteristic, degree, and polynomial-basis identity.
    pub fn presentation(&self) -> FieldPresentation {
        let characteristic = u16::from(self.characteristic);
        let mut place = 1_u16;
        let mut lower_modulus = 0_u16;
        for &coefficient in &self.modulus[..usize::from(self.degree)] {
            lower_modulus += u16::from(coefficient) * place;
            place *= characteristic;
        }
        debug_assert_eq!(place, self.order);
        FieldPresentation::new(self.characteristic, self.degree, lower_modulus)
    }

    #[inline(always)]
    pub fn add(&self, left: u8, right: u8) -> u8 {
        self.add[self.table_index(left, right)]
    }

    #[inline(always)]
    pub(crate) fn add_canonical(&self, left: u8, right: u8) -> u8 {
        debug_assert!(u16::from(left) < self.order && u16::from(right) < self.order);
        self.add[usize::from(left) * usize::from(self.order) + usize::from(right)]
    }

    #[inline(always)]
    pub fn sub(&self, left: u8, right: u8) -> u8 {
        self.subtract[self.table_index(left, right)]
    }

    #[inline(always)]
    pub fn mul(&self, left: u8, right: u8) -> u8 {
        self.multiply[self.table_index(left, right)]
    }

    #[inline(always)]
    pub(crate) fn mul_canonical(&self, left: u8, right: u8) -> u8 {
        debug_assert!(u16::from(left) < self.order && u16::from(right) < self.order);
        self.multiply[usize::from(left) * usize::from(self.order) + usize::from(right)]
    }

    #[inline]
    pub fn inverse(&self, value: u8) -> Result<u8, FieldError> {
        if value == 0 {
            return Err(FieldError::ZeroInverse);
        }
        self.inverse
            .get(usize::from(value))
            .copied()
            .ok_or(FieldError::InvalidElement)
    }

    #[inline(always)]
    pub(crate) fn inverse_nonzero_canonical(&self, value: u8) -> u8 {
        debug_assert!(value != 0 && u16::from(value) < self.order);
        self.inverse[usize::from(value)]
    }

    #[inline]
    pub fn pow(&self, mut base: u8, mut exponent: u16) -> u8 {
        let mut result = 1;
        while exponent != 0 {
            if exponent & 1 != 0 {
                result = self.mul(result, base);
            }
            base = self.mul(base, base);
            exponent >>= 1;
        }
        result
    }

    #[inline(always)]
    fn table_index(&self, left: u8, right: u8) -> usize {
        let left = usize::from(left);
        let right = usize::from(right);
        let order = usize::from(self.order);
        assert!(
            left < order && right < order,
            "field element is not reduced"
        );
        left * order + right
    }
}

fn extension_order(characteristic: u8, degree: u8) -> Result<u16, FieldError> {
    if !is_prime(characteristic) {
        return Err(FieldError::InvalidModulus);
    }
    if degree == 0 {
        return Err(FieldError::InvalidExtensionDegree);
    }
    let mut order = 1u16;
    for _ in 0..degree {
        order = order
            .checked_mul(u16::from(characteristic))
            .filter(|&order| order <= 256)
            .ok_or(FieldError::InvalidExtensionDegree)?;
    }
    Ok(order)
}

fn first_irreducible(characteristic: u8, degree: u8) -> Option<[u8; 9]> {
    let degree = usize::from(degree);
    if degree > 8 {
        return None;
    }
    let candidate_count = usize::from(characteristic).pow(degree as u32);
    for encoded in 0..candidate_count {
        let mut value = encoded;
        let mut candidate = [0u8; 9];
        for coefficient in &mut candidate[..degree] {
            *coefficient = (value % usize::from(characteristic)) as u8;
            value /= usize::from(characteristic);
        }
        candidate[degree] = 1;
        if polynomial_is_irreducible(characteristic, &candidate[..=degree]) {
            return Some(candidate);
        }
    }
    None
}

fn polynomial_is_irreducible(characteristic: u8, polynomial: &[u8]) -> bool {
    let degree = polynomial.len() - 1;
    if degree == 1 {
        return true;
    }
    if polynomial[0] == 0 {
        return false;
    }
    for divisor_degree in 1..=degree / 2 {
        let divisor_count = usize::from(characteristic).pow(divisor_degree as u32);
        for encoded in 0..divisor_count {
            let mut value = encoded;
            let mut divisor = [0u8; 9];
            for coefficient in &mut divisor[..divisor_degree] {
                *coefficient = (value % usize::from(characteristic)) as u8;
                value /= usize::from(characteristic);
            }
            divisor[divisor_degree] = 1;
            if polynomial_divides(characteristic, polynomial, &divisor[..=divisor_degree]) {
                return false;
            }
        }
    }
    true
}

fn polynomial_divides(characteristic: u8, polynomial: &[u8], divisor: &[u8]) -> bool {
    let divisor_degree = divisor.len() - 1;
    let mut remainder = [0u8; 9];
    remainder[..polynomial.len()].copy_from_slice(polynomial);
    for power in (divisor_degree..polynomial.len()).rev() {
        let leading = remainder[power];
        if leading == 0 {
            continue;
        }
        let shift = power - divisor_degree;
        for index in 0..=divisor_degree {
            let product = u16::from(leading) * u16::from(divisor[index]);
            remainder[shift + index] = ((u16::from(remainder[shift + index])
                + u16::from(characteristic)
                - product % u16::from(characteristic))
                % u16::from(characteristic)) as u8;
        }
    }
    remainder[..divisor_degree].iter().all(|&value| value == 0)
}

fn extension_add(left: u16, right: u16, characteristic: u8, degree: u8, subtract: bool) -> u8 {
    let characteristic = u16::from(characteristic);
    let mut left = left;
    let mut right = right;
    let mut encoded = 0u16;
    let mut place = 1u16;
    for _ in 0..degree {
        let left_coefficient = left % characteristic;
        let right_coefficient = right % characteristic;
        let coefficient = if subtract {
            (left_coefficient + characteristic - right_coefficient) % characteristic
        } else {
            (left_coefficient + right_coefficient) % characteristic
        };
        encoded += coefficient * place;
        place *= characteristic;
        left /= characteristic;
        right /= characteristic;
    }
    encoded as u8
}

fn extension_multiply(
    mut left: u16,
    mut right: u16,
    characteristic: u8,
    degree: u8,
    modulus: &[u8],
) -> u8 {
    let degree = usize::from(degree);
    let characteristic_u16 = u16::from(characteristic);
    let mut left_coefficients = [0u16; 8];
    let mut right_coefficients = [0u16; 8];
    for index in 0..degree {
        left_coefficients[index] = left % characteristic_u16;
        right_coefficients[index] = right % characteristic_u16;
        left /= characteristic_u16;
        right /= characteristic_u16;
    }
    let mut product = [0u16; 15];
    for (left_index, &left_coefficient) in left_coefficients[..degree].iter().enumerate() {
        for (right_index, &right_coefficient) in right_coefficients[..degree].iter().enumerate() {
            let slot = left_index + right_index;
            product[slot] =
                (product[slot] + left_coefficient * right_coefficient) % characteristic_u16;
        }
    }
    for power in (degree..=(2 * degree - 2)).rev() {
        let leading = product[power];
        if leading == 0 {
            continue;
        }
        let shift = power - degree;
        for index in 0..degree {
            let reduction = leading * u16::from(modulus[index]) % characteristic_u16;
            product[shift + index] =
                (product[shift + index] + characteristic_u16 - reduction) % characteristic_u16;
        }
    }
    let mut encoded = 0u16;
    let mut place = 1u16;
    for coefficient in &product[..degree] {
        encoded += *coefficient * place;
        place *= characteristic_u16;
    }
    encoded as u8
}

const fn is_prime(value: u8) -> bool {
    if value < 2 {
        return false;
    }
    let mut divisor = 2u8;
    while (divisor as u16) * (divisor as u16) <= value as u16 {
        if value.is_multiple_of(divisor) {
            return false;
        }
        divisor += 1;
    }
    true
}

#[cfg(test)]
mod tests {
    use super::*;

    fn typed_elements_agree<F: FiniteField>() {
        F::validate().unwrap();
        for left in 0..F::ORDER {
            let typed_left = FieldElement::<F>::new(left).unwrap();
            assert_eq!(typed_left.value(), left);
            if left != 0 {
                assert_eq!(
                    typed_left.inverse().unwrap().value(),
                    F::inverse(left).unwrap()
                );
            }
            for right in 0..F::ORDER {
                let typed_right = FieldElement::<F>::new(right).unwrap();
                assert_eq!((typed_left + typed_right).value(), F::add(left, right));
                assert_eq!((typed_left - typed_right).value(), F::sub(left, right));
                assert_eq!((typed_left * typed_right).value(), F::mul(left, right));
            }
        }
        assert!(matches!(
            FieldElement::<F>::new(F::ORDER),
            Err(FieldError::InvalidElement)
        ));
    }

    #[test]
    fn static_field_elements_are_checked_once_and_exactly_branded() {
        typed_elements_agree::<Prime<2>>();
        typed_elements_agree::<Prime<7>>();
        typed_elements_agree::<Prime<251>>();
        typed_elements_agree::<Gf4>();
        assert!(matches!(
            Prime::<9>::validate(),
            Err(FieldError::InvalidModulus)
        ));
    }

    #[test]
    fn static_field_element_hot_arithmetic_allocates_nothing() {
        let multiplier = FieldElement::<Prime<7>>::new(3).unwrap();
        let addend = FieldElement::<Prime<7>>::new(5).unwrap();
        let mut value = FieldElement::<Prime<7>>::new(1).unwrap();
        let (checksum, events) = crate::test_alloc::measure_allocations(|| {
            let _guard = crate::test_alloc::HotLoopAllocationGuard::enter();
            let mut checksum = 0_u8;
            for _ in 0..100_000 {
                value = value * multiplier + addend;
                checksum ^= value.value();
            }
            checksum
        });
        assert_eq!(checksum, 0);
        assert_eq!(events, crate::test_alloc::AllocationEvents::default());
    }

    #[test]
    fn inverses_replay_for_small_primes() {
        Prime::<2>::validate().unwrap();
        Prime::<251>::validate().unwrap();
        assert!(Prime::<9>::validate().is_err());
        for value in 1..7 {
            assert_eq!(
                Prime::<7>::mul(value, Prime::<7>::inverse(value).unwrap()),
                1
            );
        }
    }

    #[test]
    fn gf4_exhaustively_satisfies_field_laws() {
        for a in 0..4 {
            assert_eq!(Gf4::add(a, 0), a);
            assert_eq!(Gf4::mul(a, 0), 0);
            assert_eq!(Gf4::mul(a, 1), a);
            for b in 0..4 {
                assert!(Gf4::add(a, b) < 4);
                assert!(Gf4::mul(a, b) < 4);
                assert_eq!(Gf4::add(a, b), Gf4::add(b, a));
                assert_eq!(Gf4::mul(a, b), Gf4::mul(b, a));
                for c in 0..4 {
                    assert_eq!(Gf4::add(Gf4::add(a, b), c), Gf4::add(a, Gf4::add(b, c)));
                    assert_eq!(Gf4::mul(Gf4::mul(a, b), c), Gf4::mul(a, Gf4::mul(b, c)));
                    assert_eq!(
                        Gf4::mul(a, Gf4::add(b, c)),
                        Gf4::add(Gf4::mul(a, b), Gf4::mul(a, c))
                    );
                }
            }
            if a != 0 {
                assert_eq!(Gf4::mul(a, Gf4::inverse(a).unwrap()), 1);
            }
        }
        assert_eq!(Gf4::mul(2, 2), 3);
        assert_eq!(Gf4::mul(2, 3), 1);
        assert_eq!(Gf4::inverse(4), Err(FieldError::InvalidElement));
    }

    #[test]
    fn runtime_prime_power_fields_cover_campaign_orders() {
        for (characteristic, degree, order) in [
            (2, 3, 8),
            (3, 2, 9),
            (2, 4, 16),
            (5, 2, 25),
            (3, 3, 27),
            (2, 5, 32),
            (2, 6, 64),
        ] {
            let field = SmallField::new(characteristic, degree).unwrap();
            assert_eq!(field.order(), order);
            for left in 0..order as u8 {
                assert_eq!(field.add(left, 0), left);
                assert_eq!(field.mul(left, 0), 0);
                assert_eq!(field.mul(left, 1), left);
                if left != 0 {
                    assert_eq!(field.mul(left, field.inverse(left).unwrap()), 1);
                }
                for right in 0..order as u8 {
                    assert!(u16::from(field.add(left, right)) < order);
                    assert!(u16::from(field.mul(left, right)) < order);
                    assert_eq!(field.add(left, right), field.add(right, left));
                    assert_eq!(field.mul(left, right), field.mul(right, left));
                    assert_eq!(field.sub(field.add(left, right), right), left);
                }
            }
        }
    }

    fn binary_extension_agrees<const H: u8>() {
        let field = SmallField::new(2, H).unwrap();
        let binary = field.binary_extension::<H>().unwrap();
        assert_eq!(binary.degree(), H);
        assert_eq!(binary.order(), field.order());
        for left in 0..field.order() {
            let left = left as u8;
            let typed_left = binary.element(left).unwrap();
            assert_eq!(binary.inverse(left), field.inverse(left));
            for right in 0..field.order() {
                let right = right as u8;
                let typed_right = binary.element(right).unwrap();
                assert_eq!(binary.add(left, right), field.add(left, right));
                assert_eq!(binary.sub(left, right), field.sub(left, right));
                assert_eq!(binary.mul(left, right), field.mul(left, right));
                assert_eq!(
                    binary.add_element(typed_left, typed_right).value(),
                    field.add(left, right)
                );
                assert_eq!(
                    binary.mul_element(typed_left, typed_right).value(),
                    field.mul(left, right)
                );
            }
        }
        if field.order() < 256 {
            assert_eq!(
                binary.element(field.order() as u8),
                Err(FieldError::InvalidElement)
            );
        }
    }

    #[test]
    fn binary_extension_view_matches_runtime_tables() {
        binary_extension_agrees::<3>();
        binary_extension_agrees::<4>();
        binary_extension_agrees::<5>();
        binary_extension_agrees::<6>();
        binary_extension_agrees::<7>();
        binary_extension_agrees::<8>();
        assert!(matches!(
            SmallField::new(3, 2).unwrap().binary_extension::<3>(),
            Err(FieldError::BinaryExtensionMismatch)
        ));
        assert!(matches!(
            SmallField::new(2, 3).unwrap().binary_extension::<4>(),
            Err(FieldError::BinaryExtensionMismatch)
        ));
    }

    #[test]
    fn binary_extension_public_arithmetic_rejects_unreduced_operands() {
        let field = SmallField::new(2, 3).unwrap();
        let binary = field.binary_extension::<3>().unwrap();
        assert!(std::panic::catch_unwind(|| binary.add(8, 0)).is_err());
        assert!(std::panic::catch_unwind(|| binary.sub(0, 8)).is_err());
        assert!(std::panic::catch_unwind(|| binary.mul(8, 1)).is_err());
        assert_eq!(binary.inverse(8), Err(FieldError::InvalidElement));
    }

    #[test]
    fn runtime_field_validates_moduli_and_matches_gf4_encoding() {
        assert!(SmallField::new(6, 1).is_err());
        assert!(SmallField::new(2, 0).is_err());
        assert!(SmallField::new(3, 6).is_err());
        assert!(SmallField::from_modulus(2, &[1, 0, 1]).is_err());
        let field = SmallField::new(2, 2).unwrap();
        assert_eq!(field.modulus(), &[1, 1, 1]);
        for left in 0..4 {
            for right in 0..4 {
                assert_eq!(field.add(left, right), Gf4::add(left, right));
                assert_eq!(field.mul(left, right), Gf4::mul(left, right));
            }
        }
        let largest = SmallField::new(2, 8).unwrap();
        assert_eq!(largest.order(), 256);
        assert_eq!(largest.mul(255, largest.inverse(255).unwrap()), 1);
    }

    #[test]
    fn presentation_identity_is_exact_and_encoding_sensitive() {
        let canonical_gf4 = SmallField::new(2, 2).unwrap();
        assert_eq!(canonical_gf4.presentation(), Gf4::PRESENTATION);
        assert_eq!(
            SmallField::new(7, 1).unwrap().presentation(),
            Prime::<7>::PRESENTATION
        );

        let first_gf8 = SmallField::from_modulus(2, &[1, 1, 0, 1]).unwrap();
        let second_gf8 = SmallField::from_modulus(2, &[1, 0, 1, 1]).unwrap();
        assert_eq!(first_gf8.order(), second_gf8.order());
        assert_ne!(first_gf8.presentation(), second_gf8.presentation());
    }
}
