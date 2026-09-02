use ergodis::bp_osd::{
    BinaryParityCheck, BinaryValue, BpOsdConfig, BpOsdError, BpOsdWorkspace, MatrixError, OsdMethod,
};

#[path = "../src/test_alloc.rs"]
mod test_alloc;

fn hamming_code() -> BinaryParityCheck {
    BinaryParityCheck::from_rows(7, [vec![0, 2, 4, 6], vec![1, 2, 5, 6], vec![3, 4, 5, 6]]).unwrap()
}

fn syndrome(value: usize) -> [BinaryValue; 3] {
    [
        BinaryValue::from(value & 1 != 0),
        BinaryValue::from(value & 2 != 0),
        BinaryValue::from(value & 4 != 0),
    ]
}

fn verify_candidate(candidate: &[u8], expected: &[BinaryValue; 3]) -> bool {
    let rows = [[0, 2, 4, 6], [1, 2, 5, 6], [3, 4, 5, 6]];
    rows.iter().zip(expected).all(|(row, &value)| {
        let parity = row.iter().fold(0u8, |sum, &bit| sum ^ candidate[bit]);
        parity == value as u8
    })
}

#[test]
fn malformed_matrix_and_syndrome_boundaries_fail_closed() {
    assert_eq!(
        BinaryParityCheck::from_rows(3, [vec![0, 3]]).err().unwrap(),
        MatrixError::ColumnOutOfRange { row: 0, column: 3 }
    );
    let code = hamming_code();
    let mut workspace =
        BpOsdWorkspace::new(&code, BpOsdConfig::default(), OsdMethod::Zero).unwrap();
    assert_eq!(
        workspace.decode_bytes(&code, &[0, 2, 0]).err().unwrap(),
        BpOsdError::SyndromeValue { check: 1, value: 2 }
    );
}

#[test]
fn degree_one_check_uses_a_finite_message() {
    let code = BinaryParityCheck::from_rows(1, [vec![0]]).unwrap();
    let mut workspace = BpOsdWorkspace::new(
        &code,
        BpOsdConfig {
            maximum_iterations: 1,
            ..BpOsdConfig::default()
        },
        OsdMethod::Disabled,
    )
    .unwrap();
    let result = workspace.decode(&code, &[BinaryValue::One]).unwrap();
    assert!(result.syndrome_satisfied);
    assert_eq!(result.candidate, &[1]);
    assert!(result.posterior[0].is_finite());
}

#[test]
fn typed_higher_order_decode_allocates_nothing() {
    let code = hamming_code();
    let mut workspace = BpOsdWorkspace::new(
        &code,
        BpOsdConfig {
            maximum_iterations: 0,
            ..BpOsdConfig::default()
        },
        OsdMethod::Exhaustive { order: 2 },
    )
    .unwrap();
    let target = syndrome(7);
    let ((satisfied, weight), events) = test_alloc::measure_current_thread_allocations(|| {
        let result = workspace.decode(&code, &target).unwrap();
        (result.syndrome_satisfied, result.weight)
    });
    assert!(satisfied);
    assert!(weight > 0);
    assert_eq!(events, test_alloc::AllocationEvents::default());
}

#[test]
fn neutral_candidate_stream_is_stable_and_replays() {
    let code = hamming_code();
    let mut workspace = BpOsdWorkspace::new(
        &code,
        BpOsdConfig {
            maximum_iterations: 0,
            ..BpOsdConfig::default()
        },
        OsdMethod::CombinationSweep { order: 2 },
    )
    .unwrap();
    let mut checksum = 0xcbf2_9ce4_8422_2325u64;
    for value in 1..=7 {
        let target = syndrome(value);
        let result = workspace.decode(&code, &target).unwrap();
        assert!(result.syndrome_satisfied);
        assert!(verify_candidate(result.candidate, &target));
        for &bit in result.candidate {
            checksum ^= u64::from(bit);
            checksum = checksum.wrapping_mul(0x100_0000_01b3);
        }
    }
    assert_eq!(checksum, 4_903_126_080_473_013_324);
}

#[test]
fn shared_code_supports_independent_aligned_workers() {
    assert!(std::mem::align_of::<BpOsdWorkspace>() >= 64);
    let code = hamming_code();
    std::thread::scope(|scope| {
        let mut workers = Vec::with_capacity(4);
        for _ in 0..4 {
            workers.push(scope.spawn(|| {
                let mut workspace = BpOsdWorkspace::new(
                    &code,
                    BpOsdConfig {
                        maximum_iterations: 0,
                        ..BpOsdConfig::default()
                    },
                    OsdMethod::CombinationSweep { order: 2 },
                )
                .unwrap();
                let result = workspace.decode(&code, &syndrome(5)).unwrap();
                (result.syndrome_satisfied, result.candidate.to_vec())
            }));
        }
        let expected = workers.remove(0).join().unwrap();
        for worker in workers {
            assert_eq!(worker.join().unwrap(), expected);
        }
    });
}
