//! Exact finite ordered-resource algebras and Pareto composition.

use thiserror::Error;

/// Finite ordered commutative monoid with compact elements `0..element_count`.
///
/// Call [`validate_finite_ordered_monoid`] at an adapter or trust boundary
/// before relying on the algebraic laws for contextual compilation.
pub trait FiniteOrderedMonoid {
    fn element_count(&self) -> u32;
    fn identity(&self) -> u32;
    fn combine(&self, left: u32, right: u32) -> u32;
    fn leq(&self, left: u32, right: u32) -> bool;
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct OrderedMonoidCertificate {
    pub elements: u32,
}

#[derive(Debug, Error, PartialEq, Eq)]
pub enum OrderedResourceError {
    #[error("an ordered monoid needs at least one element")]
    Empty,
    #[error("ordered-monoid element {element} is out of range")]
    Element { element: u32 },
    #[error("element {element} violates the identity law")]
    Identity { element: u32 },
    #[error("elements {left} and {right} violate commutativity")]
    Commutative { left: u32, right: u32 },
    #[error("elements {first}, {second}, and {third} violate associativity")]
    Associative { first: u32, second: u32, third: u32 },
    #[error("the order is not reflexive at element {element}")]
    Reflexive { element: u32 },
    #[error("distinct elements {left} and {right} violate antisymmetry")]
    Antisymmetric { left: u32, right: u32 },
    #[error("elements {first}, {second}, and {third} violate transitivity")]
    Transitive { first: u32, second: u32, third: u32 },
    #[error("order monotonicity fails for {left} <= {right} after adding {addend}")]
    Monotone { left: u32, right: u32, addend: u32 },
    #[error("extensivity fails for elements {left} and {right}")]
    Extensive { left: u32, right: u32 },
    #[error("a resource-space dimension or product exceeds compact storage")]
    Overflow,
    #[error("resource vector has the wrong dimension or exceeds its cap")]
    ResourceShape,
}

/// Exhaustively certify the laws needed by the finite ordered-monoid theorem.
pub fn validate_finite_ordered_monoid<M: FiniteOrderedMonoid>(
    monoid: &M,
) -> Result<OrderedMonoidCertificate, OrderedResourceError> {
    let count = monoid.element_count();
    if count == 0 {
        return Err(OrderedResourceError::Empty);
    }
    let identity = monoid.identity();
    validate_element(count, identity)?;
    for left in 0..count {
        if !monoid.leq(left, left) {
            return Err(OrderedResourceError::Reflexive { element: left });
        }
        let identity_left = monoid.combine(identity, left);
        let left_identity = monoid.combine(left, identity);
        validate_element(count, identity_left)?;
        validate_element(count, left_identity)?;
        if identity_left != left || left_identity != left {
            return Err(OrderedResourceError::Identity { element: left });
        }
        for right in 0..count {
            let sum = monoid.combine(left, right);
            validate_element(count, sum)?;
            let reverse_sum = monoid.combine(right, left);
            validate_element(count, reverse_sum)?;
            if sum != reverse_sum {
                return Err(OrderedResourceError::Commutative { left, right });
            }
            if left != right && monoid.leq(left, right) && monoid.leq(right, left) {
                return Err(OrderedResourceError::Antisymmetric { left, right });
            }
            if !monoid.leq(left, sum) {
                return Err(OrderedResourceError::Extensive { left, right });
            }
            for third in 0..count {
                let sum_third = monoid.combine(sum, third);
                let right_third = monoid.combine(right, third);
                validate_element(count, sum_third)?;
                validate_element(count, right_third)?;
                let left_right_third = monoid.combine(left, right_third);
                validate_element(count, left_right_third)?;
                if sum_third != left_right_third {
                    return Err(OrderedResourceError::Associative {
                        first: left,
                        second: right,
                        third,
                    });
                }
                let left_third = monoid.combine(left, third);
                validate_element(count, left_third)?;
                if monoid.leq(left, right) && !monoid.leq(left_third, right_third) {
                    return Err(OrderedResourceError::Monotone {
                        left,
                        right,
                        addend: third,
                    });
                }
                if monoid.leq(left, right) && monoid.leq(right, third) && !monoid.leq(left, third) {
                    return Err(OrderedResourceError::Transitive {
                        first: left,
                        second: right,
                        third,
                    });
                }
            }
        }
    }
    Ok(OrderedMonoidCertificate { elements: count })
}

fn validate_element(count: u32, element: u32) -> Result<(), OrderedResourceError> {
    if element >= count {
        return Err(OrderedResourceError::Element { element });
    }
    Ok(())
}

/// Coordinatewise ordered resource vectors with capped additive composition.
#[derive(Clone, Debug)]
pub struct CappedAdditiveMonoid {
    caps: Box<[u16]>,
    strides: Box<[u32]>,
    element_count: u32,
}

impl CappedAdditiveMonoid {
    pub fn new(caps: impl Into<Box<[u16]>>) -> Result<Self, OrderedResourceError> {
        let caps = caps.into();
        let mut strides = Vec::with_capacity(caps.len());
        let mut count = 1_u32;
        for &cap in caps.iter() {
            strides.push(count);
            count = count
                .checked_mul(u32::from(cap) + 1)
                .ok_or(OrderedResourceError::Overflow)?;
        }
        Ok(Self {
            caps,
            strides: strides.into_boxed_slice(),
            element_count: count,
        })
    }

    pub fn caps(&self) -> &[u16] {
        &self.caps
    }

    pub fn encode(&self, resources: &[u16]) -> Result<u32, OrderedResourceError> {
        if resources.len() != self.caps.len()
            || resources
                .iter()
                .zip(self.caps.iter())
                .any(|(&value, &cap)| value > cap)
        {
            return Err(OrderedResourceError::ResourceShape);
        }
        Ok(resources
            .iter()
            .zip(self.strides.iter())
            .map(|(&value, &stride)| u32::from(value) * stride)
            .sum())
    }

    pub fn decode(&self, element: u32) -> Result<Box<[u16]>, OrderedResourceError> {
        validate_element(self.element_count, element)?;
        Ok(self
            .caps
            .iter()
            .zip(self.strides.iter())
            .map(|(&cap, &stride)| ((element / stride) % (u32::from(cap) + 1)) as u16)
            .collect())
    }
}

impl FiniteOrderedMonoid for CappedAdditiveMonoid {
    fn element_count(&self) -> u32 {
        self.element_count
    }

    fn identity(&self) -> u32 {
        0
    }

    fn combine(&self, left: u32, right: u32) -> u32 {
        debug_assert!(left < self.element_count && right < self.element_count);
        let mut result = 0_u32;
        for (&cap, &stride) in self.caps.iter().zip(self.strides.iter()) {
            let radix = u32::from(cap) + 1;
            let left_value = (left / stride) % radix;
            let right_value = (right / stride) % radix;
            let value = left_value.saturating_add(right_value).min(u32::from(cap));
            result += value * stride;
        }
        result
    }

    fn leq(&self, left: u32, right: u32) -> bool {
        debug_assert!(left < self.element_count && right < self.element_count);
        self.caps
            .iter()
            .zip(self.strides.iter())
            .all(|(&cap, &stride)| {
                let radix = u32::from(cap) + 1;
                (left / stride) % radix <= (right / stride) % radix
            })
    }
}

/// Canonical antichain representing an upward-closed set of feasible costs.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ParetoFront {
    elements: Box<[u32]>,
}

impl ParetoFront {
    pub fn new<M: FiniteOrderedMonoid>(
        monoid: &M,
        candidates: impl IntoIterator<Item = u32>,
    ) -> Result<Self, OrderedResourceError> {
        let candidates = candidates.into_iter();
        let mut elements = Vec::with_capacity(candidates.size_hint().0);
        for candidate in candidates {
            validate_element(monoid.element_count(), candidate)?;
            insert_minimal(monoid, &mut elements, candidate);
        }
        elements.sort_unstable();
        Ok(Self {
            elements: elements.into_boxed_slice(),
        })
    }

    pub fn identity<M: FiniteOrderedMonoid>(monoid: &M) -> Result<Self, OrderedResourceError> {
        Self::new(monoid, [monoid.identity()])
    }

    pub fn elements(&self) -> &[u32] {
        &self.elements
    }

    pub fn choice<M: FiniteOrderedMonoid>(
        &self,
        monoid: &M,
        other: &Self,
    ) -> Result<Self, OrderedResourceError> {
        let mut elements = Vec::with_capacity(self.elements.len() + other.elements.len());
        for &candidate in self.elements.iter().chain(other.elements.iter()) {
            insert_minimal(monoid, &mut elements, candidate);
        }
        elements.sort_unstable();
        Ok(Self {
            elements: elements.into_boxed_slice(),
        })
    }

    pub fn compose<M: FiniteOrderedMonoid>(
        &self,
        monoid: &M,
        other: &Self,
    ) -> Result<Self, OrderedResourceError> {
        let capacity = self
            .elements
            .len()
            .checked_mul(other.elements.len())
            .ok_or(OrderedResourceError::Overflow)?;
        let mut elements = Vec::with_capacity(capacity);
        for &left in self.elements.iter() {
            for &right in other.elements.iter() {
                let candidate = monoid.combine(left, right);
                validate_element(monoid.element_count(), candidate)?;
                insert_minimal(monoid, &mut elements, candidate);
            }
        }
        elements.sort_unstable();
        Ok(Self {
            elements: elements.into_boxed_slice(),
        })
    }

    pub fn admits<M: FiniteOrderedMonoid>(
        &self,
        monoid: &M,
        budget: u32,
    ) -> Result<bool, OrderedResourceError> {
        validate_element(monoid.element_count(), budget)?;
        Ok(self
            .elements
            .iter()
            .any(|&element| monoid.leq(element, budget)))
    }
}

fn insert_minimal<M: FiniteOrderedMonoid>(monoid: &M, elements: &mut Vec<u32>, candidate: u32) {
    if elements
        .iter()
        .any(|&element| monoid.leq(element, candidate))
    {
        return;
    }
    elements.retain(|element| !monoid.leq(candidate, *element));
    elements.push(candidate);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn capped_resources_validate_and_compose_exact_fronts() {
        let monoid = CappedAdditiveMonoid::new([2, 2]).unwrap();
        assert_eq!(
            validate_finite_ordered_monoid(&monoid).unwrap(),
            OrderedMonoidCertificate { elements: 9 }
        );
        let a = ParetoFront::new(
            &monoid,
            [
                monoid.encode(&[1, 0]).unwrap(),
                monoid.encode(&[0, 1]).unwrap(),
            ],
        )
        .unwrap();
        let composed = a.compose(&monoid, &a).unwrap();
        let decoded: Vec<_> = composed
            .elements()
            .iter()
            .map(|&element| monoid.decode(element).unwrap())
            .collect();
        assert_eq!(
            decoded,
            vec![
                vec![2, 0].into_boxed_slice(),
                vec![1, 1].into_boxed_slice(),
                vec![0, 2].into_boxed_slice(),
            ]
        );
        assert!(composed
            .admits(&monoid, monoid.encode(&[2, 1]).unwrap())
            .unwrap());
        assert!(!composed
            .admits(&monoid, monoid.encode(&[0, 1]).unwrap())
            .unwrap());
        assert_eq!(
            composed.admits(&monoid, monoid.element_count()),
            Err(OrderedResourceError::Element {
                element: monoid.element_count()
            })
        );
    }

    #[derive(Clone, Copy)]
    struct TableMonoid {
        count: u32,
        identity: u32,
        combine: &'static [u32],
        order: &'static [bool],
    }

    impl FiniteOrderedMonoid for TableMonoid {
        fn element_count(&self) -> u32 {
            self.count
        }

        fn identity(&self) -> u32 {
            self.identity
        }

        fn combine(&self, left: u32, right: u32) -> u32 {
            self.combine[(left * self.count + right) as usize]
        }

        fn leq(&self, left: u32, right: u32) -> bool {
            self.order[(left * self.count + right) as usize]
        }
    }

    #[test]
    fn validator_rejects_out_of_range_outputs_before_reusing_them() {
        let bad = TableMonoid {
            count: 2,
            identity: 0,
            combine: &[0, 1, 1, 2],
            order: &[true, true, false, true],
        };
        assert_eq!(
            validate_finite_ordered_monoid(&bad),
            Err(OrderedResourceError::Element { element: 2 })
        );
    }

    #[test]
    fn pareto_choice_and_composition_obey_semiring_laws() {
        let monoid = CappedAdditiveMonoid::new([2, 2]).unwrap();
        let front = |points: &[[u16; 2]]| {
            ParetoFront::new(
                &monoid,
                points.iter().map(|point| monoid.encode(point).unwrap()),
            )
            .unwrap()
        };
        let a = front(&[[1, 0], [0, 1]]);
        let b = front(&[[2, 0], [0, 1]]);
        let c = front(&[[0, 2], [1, 0]]);
        let empty = ParetoFront::new(&monoid, []).unwrap();
        let one = ParetoFront::identity(&monoid).unwrap();

        assert_eq!(a.choice(&monoid, &a).unwrap(), a);
        assert_eq!(
            a.choice(&monoid, &b).unwrap(),
            b.choice(&monoid, &a).unwrap()
        );
        assert_eq!(a.compose(&monoid, &one).unwrap(), a);
        assert_eq!(a.compose(&monoid, &empty).unwrap(), empty);
        assert_eq!(
            a.compose(&monoid, &b)
                .unwrap()
                .compose(&monoid, &c)
                .unwrap(),
            a.compose(&monoid, &b.compose(&monoid, &c).unwrap())
                .unwrap()
        );
        assert_eq!(
            a.compose(&monoid, &b.choice(&monoid, &c).unwrap()).unwrap(),
            a.compose(&monoid, &b)
                .unwrap()
                .choice(&monoid, &a.compose(&monoid, &c).unwrap())
                .unwrap()
        );
    }
}
