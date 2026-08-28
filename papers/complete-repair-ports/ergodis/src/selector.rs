//! Exact successive specialization of finite-field selector polynomials.

use crate::field::FiniteField;
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
    shape_slots: usize,
    variables: usize,
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

    pub fn workspace(&self) -> DenseSelectorWorkspace {
        DenseSelectorWorkspace {
            left: vec![0; self.coefficients.len()].into_boxed_slice(),
            right: vec![0; self.coefficients.len()].into_boxed_slice(),
            assignment: Vec::with_capacity(self.degrees.len()),
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
                let mut powers = [0_u8; 252];
                powers[0] = 1;
                for exponent in 1..width {
                    powers[exponent] = F::mul(powers[exponent - 1], value);
                }
                let mut residual_nonzero = false;
                for tail in 0..residual_len {
                    let coefficients = &source[tail * width..(tail + 1) * width];
                    let mut result = 0_u8;
                    for exponent in 0..width {
                        result = F::add(result, F::mul(coefficients[exponent], powers[exponent]));
                    }
                    target[tail] = result;
                    residual_nonzero |= result != 0;
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
        let mut value = 0_u8;
        for (index, &coefficient) in self.coefficients.iter().enumerate() {
            let mut remaining = index;
            let mut monomial = coefficient;
            for (&degree, &coordinate) in self.degrees.iter().zip(assignment) {
                let width = usize::from(degree) + 1;
                let exponent = remaining % width;
                remaining /= width;
                for _ in 0..exponent {
                    monomial = F::mul(monomial, coordinate);
                }
            }
            value = F::add(value, monomial);
        }
        Ok(value)
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
}
