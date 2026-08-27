use thiserror::Error;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Error)]
pub enum ProjectiveError {
    #[error("supported ternary field orders are 9 and 27")]
    UnsupportedOrder,
    #[error("projective-plane incidence construction failed")]
    InvalidIncidence,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ProjectivePoint {
    pub coordinates: [u8; 3],
    _reserved: u8,
}

const _: () = assert!(std::mem::size_of::<ProjectivePoint>() == 4);
const _: () = assert!(std::mem::align_of::<ProjectivePoint>() == 1);

#[derive(Clone, Debug)]
pub(crate) struct TernaryExtensionField {
    order: u8,
    degree: usize,
    modulus: [u8; 4],
    add: Box<[u8]>,
    multiply: Box<[u8]>,
}

impl TernaryExtensionField {
    pub(crate) fn new(order: u8) -> Result<Self, ProjectiveError> {
        let (degree, modulus) = match order {
            9 => (2, [1, 0, 1, 0]),
            27 => (3, [1, 2, 0, 1]),
            _ => return Err(ProjectiveError::UnsupportedOrder),
        };
        let table_len = order as usize * order as usize;
        let mut field = Self {
            order,
            degree,
            modulus,
            add: vec![0; table_len].into_boxed_slice(),
            multiply: vec![0; table_len].into_boxed_slice(),
        };
        for left in 0..order {
            for right in 0..order {
                let index = left as usize * order as usize + right as usize;
                field.add[index] = field.add_slow(left, right);
                field.multiply[index] = field.multiply_slow(left, right);
            }
        }
        Ok(field)
    }

    fn coefficients(&self, mut value: u8) -> [u8; 3] {
        let mut result = [0; 3];
        for coefficient in &mut result[..self.degree] {
            *coefficient = value % 3;
            value /= 3;
        }
        result
    }

    fn encode(&self, coefficients: &[u8]) -> u8 {
        let mut value = 0u8;
        let mut place = 1u8;
        for &coefficient in &coefficients[..self.degree] {
            value += coefficient % 3 * place;
            place *= 3;
        }
        value
    }

    fn add_slow(&self, left: u8, right: u8) -> u8 {
        let left = self.coefficients(left);
        let right = self.coefficients(right);
        let mut sum = [0; 3];
        for coordinate in 0..self.degree {
            sum[coordinate] = (left[coordinate] + right[coordinate]) % 3;
        }
        self.encode(&sum)
    }

    fn multiply_slow(&self, left: u8, right: u8) -> u8 {
        let left = self.coefficients(left);
        let right = self.coefficients(right);
        let mut product = [0u8; 5];
        for (left_index, &left_value) in left.iter().enumerate().take(self.degree) {
            for (right_index, &right_value) in right.iter().enumerate().take(self.degree) {
                let index = left_index + right_index;
                product[index] = (product[index] + left_value * right_value) % 3;
            }
        }
        for power in (self.degree..=(2 * self.degree - 2)).rev() {
            let leading = product[power] % 3;
            if leading == 0 {
                continue;
            }
            let shift = power - self.degree;
            for index in 0..self.degree {
                product[shift + index] =
                    (product[shift + index] + 3 - leading * self.modulus[index] % 3) % 3;
            }
        }
        self.encode(&product)
    }

    #[inline]
    pub(crate) fn add(&self, left: u8, right: u8) -> u8 {
        self.add[left as usize * self.order as usize + right as usize]
    }

    #[inline]
    pub(crate) fn multiply(&self, left: u8, right: u8) -> u8 {
        self.multiply[left as usize * self.order as usize + right as usize]
    }

    #[inline]
    pub(crate) fn pow(&self, mut base: u8, mut exponent: u8) -> u8 {
        let mut result = 1;
        while exponent != 0 {
            if exponent & 1 != 0 {
                result = self.multiply(result, base);
            }
            base = self.multiply(base, base);
            exponent >>= 1;
        }
        result
    }

    #[inline]
    pub(crate) fn inverse(&self, value: u8) -> u8 {
        debug_assert_ne!(value, 0);
        self.pow(value, self.order - 2)
    }
}

#[derive(Clone, Debug)]
pub struct ProjectivePlane {
    order: u8,
    points: Box<[ProjectivePoint]>,
    incidence: Box<[u16]>,
}

impl ProjectivePlane {
    pub fn ternary(order: u8) -> Result<Self, ProjectiveError> {
        let field = TernaryExtensionField::new(order)?;
        let expected_points = order as usize * order as usize + order as usize + 1;
        let mut points = Vec::with_capacity(expected_points);
        for y in 0..order {
            for z in 0..order {
                points.push(ProjectivePoint {
                    coordinates: [1, y, z],
                    _reserved: 0,
                });
            }
        }
        for z in 0..order {
            points.push(ProjectivePoint {
                coordinates: [0, 1, z],
                _reserved: 0,
            });
        }
        points.push(ProjectivePoint {
            coordinates: [0, 0, 1],
            _reserved: 0,
        });
        let line_size = order as usize + 1;
        let mut incidence = Vec::with_capacity(expected_points * line_size);
        for line in &points {
            let start = incidence.len();
            for (point_index, point) in points.iter().enumerate() {
                let mut value = 0u8;
                for coordinate in 0..3 {
                    value = field.add(
                        value,
                        field.multiply(point.coordinates[coordinate], line.coordinates[coordinate]),
                    );
                }
                if value == 0 {
                    incidence.push(
                        u16::try_from(point_index)
                            .map_err(|_| ProjectiveError::InvalidIncidence)?,
                    );
                }
            }
            if incidence.len() - start != line_size {
                return Err(ProjectiveError::InvalidIncidence);
            }
        }
        Ok(Self {
            order,
            points: points.into_boxed_slice(),
            incidence: incidence.into_boxed_slice(),
        })
    }

    pub fn order(&self) -> u8 {
        self.order
    }

    pub fn points(&self) -> &[ProjectivePoint] {
        &self.points
    }

    pub fn incident(&self, index: usize) -> Option<&[u16]> {
        if index >= self.points.len() {
            return None;
        }
        let line_size = self.order as usize + 1;
        let start = index * line_size;
        Some(&self.incidence[start..start + line_size])
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn ternary_planes_have_exact_incidence_parameters() {
        for (order, expected_hash) in [
            (9, 11_772_883_917_756_675_483u64),
            (27, 2_893_137_983_085_941_033u64),
        ] {
            let plane = ProjectivePlane::ternary(order).unwrap();
            let point_count = order as usize * order as usize + order as usize + 1;
            assert_eq!(plane.points().len(), point_count);
            assert!((0..point_count)
                .all(|line| plane.incident(line).unwrap().len() == order as usize + 1));
            let first = plane.incident(0).unwrap();
            for line in 1..point_count {
                let second = plane.incident(line).unwrap();
                assert_eq!(
                    first
                        .iter()
                        .filter(|point| second.binary_search(point).is_ok())
                        .count(),
                    1
                );
            }
            let hash = plane
                .incidence
                .iter()
                .fold(14_695_981_039_346_656_037u64, |hash, &point| {
                    (hash ^ u64::from(point)).wrapping_mul(1_099_511_628_211)
                });
            assert_eq!(hash, expected_hash);
        }
    }

    #[test]
    fn unsupported_order_is_rejected() {
        assert_eq!(
            ProjectivePlane::ternary(3).unwrap_err(),
            ProjectiveError::UnsupportedOrder
        );
    }
}
