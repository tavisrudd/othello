use ergodis::{
    certify_binary_extension_field, certify_binary_extension_field_exhaustive, PackedBinaryAction,
    PackedBinaryLinearMap,
};
use std::hint::black_box;

fn multiplication_by_x(degree: usize, polynomial: u64) -> PackedBinaryLinearMap {
    let mut rows = vec![0_u64; degree];
    for source in 0..degree {
        let image = if source + 1 < degree {
            1_u64 << (source + 1)
        } else {
            polynomial & ((1_u64 << degree) - 1)
        };
        let mut bits = image;
        while bits != 0 {
            let target = bits.trailing_zeros() as usize;
            rows[target] |= 1_u64 << source;
            bits &= bits - 1;
        }
    }
    PackedBinaryLinearMap::new(degree, rows).unwrap()
}

fn main() {
    let mut arguments = std::env::args().skip(1);
    let method = arguments.next().expect("method: theorem or exhaustive");
    let rounds: u64 = arguments
        .next()
        .expect("round count")
        .parse()
        .expect("integer round count");
    assert!(arguments.next().is_none());

    // AES polynomial x^8 + x^4 + x^3 + x + 1.
    let generator = multiplication_by_x(8, 0x11b);
    let action = PackedBinaryAction::new(8, Vec::new()).unwrap();
    for _ in 0..rounds {
        let certificate = match method.as_str() {
            "theorem" => certify_binary_extension_field(&action, generator.clone(), 8),
            "exhaustive" => {
                certify_binary_extension_field_exhaustive(&action, generator.clone(), 8)
            }
            _ => panic!("method must be theorem or exhaustive"),
        }
        .unwrap();
        black_box(certificate);
    }
}
