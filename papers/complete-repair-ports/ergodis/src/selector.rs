//! Exact successive specialization of finite-field selector polynomials.

use crate::field::{FieldElement, FiniteField};
use std::convert::Infallible;
use std::marker::PhantomData;
use thiserror::Error;

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum SelectorError {
    #[error("selector degree and coefficient shape do not agree")]
    Shape,
    #[error("selector coefficient is not a canonical field element")]
    Coefficient,
    #[error("selector is the zero polynomial")]
    Zero,
    #[error("a selector coordinate degree is not smaller than the field order")]
    DegreeBound,
    #[error("selector workspace belongs to a different polynomial shape")]
    Workspace,
    #[error("successive specialization found no nonzero residual")]
    Extraction,
}

#[derive(Debug, Error)]
pub enum SelectorRunError<E> {
    #[error(transparent)]
    Selector(#[from] SelectorError),
    #[error("selector evidence sink failed")]
    Evidence(E),
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct SelectorStep {
    pub variable: u32,
    pub value: u8,
    pub residual_nonzero: bool,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct SelectorAnswer {
    pub assignment: Box<[u8]>,
    pub partial_tests: u64,
}

/// Dense coefficient tensor with the first variable varying fastest.
#[derive(Clone, Debug)]
pub struct DenseSelector<F: FiniteField> {
    degrees: Box<[u8]>,
    coefficients: Box<[u8]>,
    _field: PhantomData<F>,
}

/// Reusable exactly-sized scratch storage for successive specialization.
pub struct DenseSelectorWorkspace {
    left: Box<[u8]>,
    right: Box<[u8]>,
    assignment: Vec<u8>,
    powers: [u8; 252],
    shape_slots: usize,
    variables: usize,
}

const SPARSE_INDEX_BITS: u32 = 56;
const SPARSE_INDEX_MASK: u64 = (1_u64 << SPARSE_INDEX_BITS) - 1;

#[repr(transparent)]
#[derive(Clone, Copy, Debug, Default)]
struct SparseTerm(u64);

const _: () = assert!(std::mem::size_of::<SparseTerm>() == 8);
const _: () = assert!(std::mem::align_of::<SparseTerm>() == 8);

impl SparseTerm {
    #[inline(always)]
    fn new(index: u64, coefficient: u8) -> Self {
        Self(index | (u64::from(coefficient) << SPARSE_INDEX_BITS))
    }

    #[inline(always)]
    fn index(self) -> u64 {
        self.0 & SPARSE_INDEX_MASK
    }

    #[inline(always)]
    fn coefficient(self) -> u8 {
        (self.0 >> SPARSE_INDEX_BITS) as u8
    }

    #[inline(always)]
    fn set_coefficient(&mut self, coefficient: u8) {
        self.0 = self.index() | (u64::from(coefficient) << SPARSE_INDEX_BITS);
    }
}

/// Sparse mixed-radix monomial representation of an exact selector.
#[derive(Clone, Debug)]
pub struct SparseSelector<F: FiniteField> {
    degrees: Box<[u8]>,
    terms: Box<[SparseTerm]>,
    coefficient_slots: u64,
    _field: PhantomData<F>,
}

/// Reusable fixed-capacity scratch storage for sparse specialization.
pub struct SparseSelectorWorkspace {
    left: Box<[SparseTerm]>,
    right: Box<[SparseTerm]>,
    assignment: Vec<u8>,
    powers: [u8; 252],
    term_capacity: usize,
    variables: usize,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum SelectorStrategy {
    #[default]
    Auto,
    Dense,
    Sparse,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum SelectorBackend {
    Dense,
    Sparse,
}

#[derive(Clone, Debug)]
pub enum CompiledSelector<F: FiniteField> {
    Dense(DenseSelector<F>),
    Sparse(SparseSelector<F>),
}

pub enum CompiledSelectorWorkspace {
    Dense(DenseSelectorWorkspace),
    Sparse(SparseSelectorWorkspace),
}

impl<F: FiniteField> DenseSelector<F> {
    pub fn new(
        degrees: impl Into<Box<[u8]>>,
        coefficients: impl Into<Box<[u8]>>,
    ) -> Result<Self, SelectorError> {
        F::validate().map_err(|_| SelectorError::Coefficient)?;
        let degrees = degrees.into();
        let coefficients = coefficients.into();
        let mut slots = 1_usize;
        for &degree in &degrees {
            if u16::from(degree) >= u16::from(F::ORDER) {
                return Err(SelectorError::DegreeBound);
            }
            slots = slots
                .checked_mul(usize::from(degree) + 1)
                .ok_or(SelectorError::Shape)?;
        }
        if coefficients.len() != slots {
            return Err(SelectorError::Shape);
        }
        if coefficients
            .iter()
            .any(|&coefficient| coefficient >= F::ORDER)
        {
            return Err(SelectorError::Coefficient);
        }
        if coefficients.iter().all(|&coefficient| coefficient == 0) {
            return Err(SelectorError::Zero);
        }
        Ok(Self {
            degrees,
            coefficients,
            _field: PhantomData,
        })
    }

    pub fn variables(&self) -> usize {
        self.degrees.len()
    }

    pub fn coefficient_slots(&self) -> usize {
        self.coefficients.len()
    }

    pub fn storage_bytes(&self) -> usize {
        self.degrees.len() + self.coefficients.len()
    }

    pub fn workspace(&self) -> DenseSelectorWorkspace {
        DenseSelectorWorkspace {
            left: vec![0; self.coefficients.len()].into_boxed_slice(),
            right: vec![0; self.coefficients.len()].into_boxed_slice(),
            assignment: Vec::with_capacity(self.degrees.len()),
            powers: [0; 252],
            shape_slots: self.coefficients.len(),
            variables: self.degrees.len(),
        }
    }

    pub fn select_nonzero(
        &self,
        workspace: &mut DenseSelectorWorkspace,
    ) -> Result<SelectorAnswer, SelectorError> {
        match self.select_nonzero_with_sink(workspace, |_| Ok::<_, Infallible>(())) {
            Ok(answer) => Ok(answer),
            Err(SelectorRunError::Selector(error)) => Err(error),
            Err(SelectorRunError::Evidence(error)) => match error {},
        }
    }

    /// Select one coordinate at a time while streaming every decision.
    ///
    /// Scratch buffers and the assignment vector are exactly pre-sized by
    /// workspace construction. The specialization loop itself does not
    /// allocate; a preallocated sink preserves that property.
    pub fn select_nonzero_with_sink<E>(
        &self,
        workspace: &mut DenseSelectorWorkspace,
        mut sink: impl FnMut(SelectorStep) -> Result<(), E>,
    ) -> Result<SelectorAnswer, SelectorRunError<E>> {
        if workspace.shape_slots != self.coefficients.len()
            || workspace.variables != self.degrees.len()
        {
            return Err(SelectorError::Workspace.into());
        }
        workspace.left.copy_from_slice(&self.coefficients);
        workspace.assignment.clear();
        let mut active_left = true;
        let mut active_len = self.coefficients.len();
        let mut partial_tests = 0_u64;

        for (variable, &degree) in self.degrees.iter().enumerate() {
            let width = usize::from(degree) + 1;
            let residual_len = active_len / width;
            let mut accepted = false;
            for value in 0..F::ORDER {
                partial_tests += 1;
                let (source, target) = if active_left {
                    (
                        &workspace.left[..active_len],
                        &mut workspace.right[..residual_len],
                    )
                } else {
                    (
                        &workspace.right[..active_len],
                        &mut workspace.left[..residual_len],
                    )
                };
                workspace.powers[0] = 1;
                for exponent in 1..width {
                    workspace.powers[exponent] =
                        (FieldElement::<F>::from_canonical(workspace.powers[exponent - 1])
                            * FieldElement::from_canonical(value))
                        .value();
                }
                let mut residual_nonzero = false;
                for tail in 0..residual_len {
                    let coefficients = &source[tail * width..(tail + 1) * width];
                    let mut result = FieldElement::<F>::from_canonical(0);
                    for (&coefficient, &power) in
                        coefficients.iter().zip(&workspace.powers[..width])
                    {
                        result = result
                            + FieldElement::from_canonical(coefficient)
                                * FieldElement::from_canonical(power);
                    }
                    target[tail] = result.value();
                    residual_nonzero |= result.value() != 0;
                }
                sink(SelectorStep {
                    variable: variable as u32,
                    value,
                    residual_nonzero,
                })
                .map_err(SelectorRunError::Evidence)?;
                if residual_nonzero {
                    workspace.assignment.push(value);
                    active_left = !active_left;
                    active_len = residual_len;
                    accepted = true;
                    break;
                }
            }
            if !accepted {
                return Err(SelectorError::Extraction.into());
            }
        }
        Ok(SelectorAnswer {
            assignment: workspace.assignment.clone().into_boxed_slice(),
            partial_tests,
        })
    }

    /// Directly evaluate an assignment for independent witness replay.
    pub fn evaluate(&self, assignment: &[u8]) -> Result<u8, SelectorError> {
        if assignment.len() != self.degrees.len()
            || assignment.iter().any(|&value| value >= F::ORDER)
        {
            return Err(SelectorError::Shape);
        }
        let mut value = FieldElement::<F>::from_canonical(0);
        for (index, &coefficient) in self.coefficients.iter().enumerate() {
            let mut remaining = index;
            let mut monomial = FieldElement::<F>::from_canonical(coefficient);
            for (&degree, &coordinate) in self.degrees.iter().zip(assignment) {
                let width = usize::from(degree) + 1;
                let exponent = remaining % width;
                remaining /= width;
                for _ in 0..exponent {
                    monomial = monomial * FieldElement::from_canonical(coordinate);
                }
            }
            value = value + monomial;
        }
        Ok(value.value())
    }
}

impl<F: FiniteField> SparseSelector<F> {
    /// Construct from `(mixed_radix_monomial_index, coefficient)` pairs.
    /// Duplicate indices are combined exactly and zero coefficients discarded.
    pub fn new(
        degrees: impl Into<Box<[u8]>>,
        mut terms: Vec<(u64, u8)>,
    ) -> Result<Self, SelectorError> {
        F::validate().map_err(|_| SelectorError::Coefficient)?;
        let degrees = degrees.into();
        let mut coefficient_slots = 1_u64;
        for &degree in &degrees {
            if u16::from(degree) >= u16::from(F::ORDER) {
                return Err(SelectorError::DegreeBound);
            }
            coefficient_slots = coefficient_slots
                .checked_mul(u64::from(degree) + 1)
                .ok_or(SelectorError::Shape)?;
            if coefficient_slots > SPARSE_INDEX_MASK + 1 {
                return Err(SelectorError::Shape);
            }
        }
        if terms
            .iter()
            .any(|&(index, coefficient)| index >= coefficient_slots || coefficient >= F::ORDER)
        {
            return Err(SelectorError::Coefficient);
        }
        terms.sort_unstable_by_key(|&(index, _)| index);
        let mut canonical: Vec<SparseTerm> = Vec::with_capacity(terms.len());
        for (index, coefficient) in terms {
            if coefficient == 0 {
                continue;
            }
            if let Some(last) = canonical.last_mut().filter(|last| last.index() == index) {
                last.set_coefficient(
                    (FieldElement::<F>::from_canonical(last.coefficient())
                        + FieldElement::from_canonical(coefficient))
                    .value(),
                );
            } else {
                canonical.push(SparseTerm::new(index, coefficient));
            }
        }
        canonical.retain(|term| term.coefficient() != 0);
        if canonical.is_empty() {
            return Err(SelectorError::Zero);
        }
        Ok(Self {
            degrees,
            terms: canonical.into_boxed_slice(),
            coefficient_slots,
            _field: PhantomData,
        })
    }

    pub fn variables(&self) -> usize {
        self.degrees.len()
    }

    pub fn coefficient_slots(&self) -> u64 {
        self.coefficient_slots
    }

    pub fn term_count(&self) -> usize {
        self.terms.len()
    }

    pub fn storage_bytes(&self) -> usize {
        self.degrees.len() + std::mem::size_of_val(&*self.terms)
    }

    pub fn workspace(&self) -> SparseSelectorWorkspace {
        SparseSelectorWorkspace {
            left: vec![SparseTerm::default(); self.terms.len()].into_boxed_slice(),
            right: vec![SparseTerm::default(); self.terms.len()].into_boxed_slice(),
            assignment: Vec::with_capacity(self.degrees.len()),
            powers: [0; 252],
            term_capacity: self.terms.len(),
            variables: self.degrees.len(),
        }
    }

    pub fn select_nonzero(
        &self,
        workspace: &mut SparseSelectorWorkspace,
    ) -> Result<SelectorAnswer, SelectorError> {
        match self.select_nonzero_with_sink(workspace, |_| Ok::<_, Infallible>(())) {
            Ok(answer) => Ok(answer),
            Err(SelectorRunError::Selector(error)) => Err(error),
            Err(SelectorRunError::Evidence(error)) => match error {},
        }
    }

    /// Select coordinates with exact sparse residual combination and streamed
    /// evidence. No allocation occurs in the specialization loop.
    pub fn select_nonzero_with_sink<E>(
        &self,
        workspace: &mut SparseSelectorWorkspace,
        mut sink: impl FnMut(SelectorStep) -> Result<(), E>,
    ) -> Result<SelectorAnswer, SelectorRunError<E>> {
        if workspace.term_capacity != self.terms.len() || workspace.variables != self.degrees.len()
        {
            return Err(SelectorError::Workspace.into());
        }
        workspace.left.copy_from_slice(&self.terms);
        workspace.assignment.clear();
        let mut active_left = true;
        let mut active_len = self.terms.len();
        let mut partial_tests = 0_u64;

        for (variable, &degree) in self.degrees.iter().enumerate() {
            let width = u64::from(degree) + 1;
            let mut accepted = false;
            for value in 0..F::ORDER {
                partial_tests += 1;
                let (source, target) = if active_left {
                    (&workspace.left[..active_len], &mut workspace.right[..])
                } else {
                    (&workspace.right[..active_len], &mut workspace.left[..])
                };
                workspace.powers[0] = 1;
                for exponent in 1..=usize::from(degree) {
                    workspace.powers[exponent] =
                        (FieldElement::<F>::from_canonical(workspace.powers[exponent - 1])
                            * FieldElement::from_canonical(value))
                        .value();
                }
                let mut output = 0;
                let mut cursor = 0;
                while cursor < source.len() {
                    let tail = source[cursor].index() / width;
                    let mut result = FieldElement::<F>::from_canonical(0);
                    while cursor < source.len() && source[cursor].index() / width == tail {
                        let exponent = (source[cursor].index() % width) as usize;
                        result = result
                            + FieldElement::from_canonical(source[cursor].coefficient())
                                * FieldElement::from_canonical(workspace.powers[exponent]);
                        cursor += 1;
                    }
                    if result.value() != 0 {
                        target[output] = SparseTerm::new(tail, result.value());
                        output += 1;
                    }
                }
                let residual_nonzero = output != 0;
                sink(SelectorStep {
                    variable: variable as u32,
                    value,
                    residual_nonzero,
                })
                .map_err(SelectorRunError::Evidence)?;
                if residual_nonzero {
                    workspace.assignment.push(value);
                    active_left = !active_left;
                    active_len = output;
                    accepted = true;
                    break;
                }
            }
            if !accepted {
                return Err(SelectorError::Extraction.into());
            }
        }
        Ok(SelectorAnswer {
            assignment: workspace.assignment.clone().into_boxed_slice(),
            partial_tests,
        })
    }

    pub fn evaluate(&self, assignment: &[u8]) -> Result<u8, SelectorError> {
        if assignment.len() != self.degrees.len()
            || assignment.iter().any(|&value| value >= F::ORDER)
        {
            return Err(SelectorError::Shape);
        }
        let mut result = FieldElement::<F>::from_canonical(0);
        for term in &self.terms {
            let mut index = term.index();
            let mut monomial = FieldElement::<F>::from_canonical(term.coefficient());
            for (&degree, &coordinate) in self.degrees.iter().zip(assignment) {
                let width = u64::from(degree) + 1;
                let exponent = index % width;
                index /= width;
                for _ in 0..exponent {
                    monomial = monomial * FieldElement::from_canonical(coordinate);
                }
            }
            result = result + monomial;
        }
        Ok(result.value())
    }
}

impl<F: FiniteField> CompiledSelector<F> {
    /// Compile a sparse input using an explicit backend or the conservative
    /// storage crossover. Auto selects sparse only when it is no larger than
    /// the equivalent dense coefficient tensor.
    pub fn from_terms(
        degrees: impl Into<Box<[u8]>>,
        terms: Vec<(u64, u8)>,
        strategy: SelectorStrategy,
    ) -> Result<Self, SelectorError> {
        let sparse = SparseSelector::<F>::new(degrees, terms)?;
        let dense_bytes = usize::try_from(sparse.coefficient_slots)
            .ok()
            .and_then(|slots| slots.checked_add(sparse.degrees.len()));
        let use_sparse = match strategy {
            SelectorStrategy::Sparse => true,
            SelectorStrategy::Dense => false,
            SelectorStrategy::Auto => dense_bytes
                .map(|bytes| sparse.storage_bytes() <= bytes)
                .unwrap_or(true),
        };
        if use_sparse {
            return Ok(Self::Sparse(sparse));
        }
        let slots = usize::try_from(sparse.coefficient_slots).map_err(|_| SelectorError::Shape)?;
        let mut coefficients = vec![0_u8; slots];
        for term in &sparse.terms {
            coefficients[term.index() as usize] = term.coefficient();
        }
        Ok(Self::Dense(DenseSelector::<F>::new(
            sparse.degrees,
            coefficients,
        )?))
    }

    pub fn backend(&self) -> SelectorBackend {
        match self {
            Self::Dense(_) => SelectorBackend::Dense,
            Self::Sparse(_) => SelectorBackend::Sparse,
        }
    }

    pub fn storage_bytes(&self) -> usize {
        match self {
            Self::Dense(selector) => selector.storage_bytes(),
            Self::Sparse(selector) => selector.storage_bytes(),
        }
    }

    pub fn workspace(&self) -> CompiledSelectorWorkspace {
        match self {
            Self::Dense(selector) => CompiledSelectorWorkspace::Dense(selector.workspace()),
            Self::Sparse(selector) => CompiledSelectorWorkspace::Sparse(selector.workspace()),
        }
    }

    pub fn select_nonzero(
        &self,
        workspace: &mut CompiledSelectorWorkspace,
    ) -> Result<SelectorAnswer, SelectorError> {
        match (self, workspace) {
            (Self::Dense(selector), CompiledSelectorWorkspace::Dense(workspace)) => {
                selector.select_nonzero(workspace)
            }
            (Self::Sparse(selector), CompiledSelectorWorkspace::Sparse(workspace)) => {
                selector.select_nonzero(workspace)
            }
            _ => Err(SelectorError::Workspace),
        }
    }

    pub fn evaluate(&self, assignment: &[u8]) -> Result<u8, SelectorError> {
        match self {
            Self::Dense(selector) => selector.evaluate(assignment),
            Self::Sparse(selector) => selector.evaluate(assignment),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::field::Prime;

    #[test]
    fn successive_specialization_preserves_a_nonzero_residual() {
        // Q(x,y) = x + y over F_5, with x varying fastest.
        let selector = DenseSelector::<Prime<5>>::new([1, 1], [0, 1, 1, 0]).unwrap();
        let mut workspace = selector.workspace();
        let mut evidence = Vec::new();
        let answer = selector
            .select_nonzero_with_sink(&mut workspace, |step| {
                evidence.push(step);
                Ok::<_, Infallible>(())
            })
            .unwrap();
        assert_eq!(&*answer.assignment, &[0, 1]);
        assert_eq!(answer.partial_tests, 3);
        assert_eq!(selector.evaluate(&answer.assignment).unwrap(), 1);
        assert_eq!(
            evidence,
            vec![
                SelectorStep {
                    variable: 0,
                    value: 0,
                    residual_nonzero: true,
                },
                SelectorStep {
                    variable: 1,
                    value: 0,
                    residual_nonzero: false,
                },
                SelectorStep {
                    variable: 1,
                    value: 1,
                    residual_nonzero: true,
                },
            ]
        );
    }

    #[test]
    fn shape_zero_and_degree_fail_closed() {
        assert_eq!(
            DenseSelector::<Prime<5>>::new([1, 1], [0, 1]).unwrap_err(),
            SelectorError::Shape
        );
        assert_eq!(
            DenseSelector::<Prime<5>>::new([0], [0]).unwrap_err(),
            SelectorError::Zero
        );
        assert_eq!(
            DenseSelector::<Prime<5>>::new([5], [1, 0, 0, 0, 0, 0]).unwrap_err(),
            SelectorError::DegreeBound
        );
    }

    #[test]
    fn all_bivariate_quadratics_over_f3_obey_the_mq_bound() {
        for encoded in 1_u32..3_u32.pow(9) {
            let mut value = encoded;
            let mut coefficients = [0_u8; 9];
            for coefficient in &mut coefficients {
                *coefficient = (value % 3) as u8;
                value /= 3;
            }
            let selector = DenseSelector::<Prime<3>>::new([2, 2], coefficients).unwrap();
            let mut workspace = selector.workspace();
            let answer = selector.select_nonzero(&mut workspace).unwrap();
            assert!(answer.partial_tests <= 6);
            assert_ne!(selector.evaluate(&answer.assignment).unwrap(), 0);
        }
    }

    #[test]
    fn sparse_and_dense_specialization_agree_exhaustively_over_f3() {
        for encoded in 1_u32..3_u32.pow(9) {
            let mut value = encoded;
            let mut coefficients = [0_u8; 9];
            let mut terms = Vec::new();
            for (index, coefficient) in coefficients.iter_mut().enumerate() {
                *coefficient = (value % 3) as u8;
                value /= 3;
                if *coefficient != 0 {
                    terms.push((index as u64, *coefficient));
                }
            }
            let dense = DenseSelector::<Prime<3>>::new([2, 2], coefficients).unwrap();
            let sparse = SparseSelector::<Prime<3>>::new([2, 2], terms).unwrap();
            let dense_answer = dense.select_nonzero(&mut dense.workspace()).unwrap();
            let sparse_answer = sparse.select_nonzero(&mut sparse.workspace()).unwrap();
            assert_eq!(sparse_answer, dense_answer);
            assert_eq!(
                sparse.evaluate(&sparse_answer.assignment).unwrap(),
                dense.evaluate(&dense_answer.assignment).unwrap()
            );
        }
    }

    #[test]
    fn compiled_selector_dispatches_at_the_storage_crossover() {
        let sparse_terms = (0..32)
            .map(|term| ((term * 3_125 / 32) as u64, (term % 6 + 1) as u8))
            .collect::<Vec<_>>();
        let automatic = CompiledSelector::<Prime<7>>::from_terms(
            [4; 5],
            sparse_terms.clone(),
            Default::default(),
        )
        .unwrap();
        assert_eq!(automatic.backend(), SelectorBackend::Sparse);
        let forced_dense =
            CompiledSelector::<Prime<7>>::from_terms([4; 5], sparse_terms, SelectorStrategy::Dense)
                .unwrap();
        assert_eq!(forced_dense.backend(), SelectorBackend::Dense);
        let automatic_answer = automatic
            .select_nonzero(&mut automatic.workspace())
            .unwrap();
        let dense_answer = forced_dense
            .select_nonzero(&mut forced_dense.workspace())
            .unwrap();
        assert_eq!(automatic_answer, dense_answer);

        let full_terms = (0..3_125)
            .map(|term| (term as u64, (term % 6 + 1) as u8))
            .collect();
        let full =
            CompiledSelector::<Prime<7>>::from_terms([4; 5], full_terms, SelectorStrategy::Auto)
                .unwrap();
        assert_eq!(full.backend(), SelectorBackend::Dense);
    }
}
