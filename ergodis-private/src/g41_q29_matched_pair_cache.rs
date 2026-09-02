//! Sealed reader for exact q29 profile pairs retained by the global target set.

use std::io::Read;

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g41_q29_exact_tablebase::{G41Q29AggregateBlockTablebase, G41Q29ExactProfile};
use crate::g41_q29_pair_target_cache::{G41Q29PairTargetCache, G41Q29PairTargetSourceBinding};
use crate::g41_q29_profile_shard::G41Q29MatchedPair;

const MAGIC: [u8; 8] = *b"G41MPR01";
const MAX_RECORDS: usize = 1 << 24;
const SEMANTICS: &[u8] = b"ergodis-private/g41-q29-matched-profile-pairs/v1; carrier=522; quotient=29; exact seven-coordinate profile sums; target indices bound to G41PTG01 canonical target order; sides 0=A+C and 1=B+B; B archetype bits 1=B1 and 2=B5; every record independently replays against committed source profiles";

#[derive(Clone, Debug, PartialEq, Eq, Serialize)]
pub struct G41Q29MatchedPairCacheReport {
    pub source: G41Q29PairTargetSourceBinding,
    pub target_digest: [u8; 32],
    pub records: u64,
    pub pair_records: [u64; 3],
    pub exact_profile_quartets: [u64; 2],
    pub record_digest: [u8; 32],
    pub provenance: &'static str,
}

pub struct G41Q29MatchedPairCache {
    pub report: G41Q29MatchedPairCacheReport,
    pub records: Box<[G41Q29MatchedPair]>,
}

#[derive(Debug, Error)]
pub enum G41Q29MatchedPairCacheError {
    #[error("q29 matched-pair cache I/O failed")]
    Io(#[from] std::io::Error),
    #[error("q29 matched-pair cache resource bound exceeded")]
    StateBudget,
    #[error("q29 matched-pair cache semantic binding or payload failed")]
    SemanticMismatch,
}

fn read_u32(reader: &mut impl Read) -> Result<u32, std::io::Error> {
    let mut bytes = [0_u8; 4];
    reader.read_exact(&mut bytes)?;
    Ok(u32::from_le_bytes(bytes))
}

fn read_u64(reader: &mut impl Read) -> Result<u64, std::io::Error> {
    let mut bytes = [0_u8; 8];
    reader.read_exact(&mut bytes)?;
    Ok(u64::from_le_bytes(bytes))
}

fn update_record(hasher: &mut Sha256, record: G41Q29MatchedPair) {
    hasher.update(record.target.to_le_bytes());
    hasher.update(record.first.to_le_bytes());
    hasher.update(record.second.to_le_bytes());
    hasher.update([record.archetype_bits, record.side]);
    hasher.update(record._pad.to_le_bytes());
}

fn record_key(record: &G41Q29MatchedPair) -> (u32, u8, u8, u32, u32) {
    (
        record.target,
        record.side,
        record.archetype_bits,
        record.first,
        record.second,
    )
}

fn pair_sum(first: G41Q29ExactProfile, second: G41Q29ExactProfile) -> Option<[u16; 7]> {
    let mut output = [0_u16; 7];
    for (coordinate, value) in output.iter_mut().enumerate() {
        *value = first.coordinate(coordinate) + second.coordinate(coordinate);
        if *value > 523 {
            return None;
        }
    }
    Some(output)
}

fn replay_record(
    record: G41Q29MatchedPair,
    targets: &G41Q29PairTargetCache,
    tables: &[G41Q29AggregateBlockTablebase; 4],
) -> bool {
    let (first, second) = if record.side == 0 && matches!(record.archetype_bits, 1..=3) {
        (&tables[0].profiles, &tables[3].profiles)
    } else if record.side == 1 && record.archetype_bits == 1 {
        (&tables[1].profiles, &tables[1].profiles)
    } else if record.side == 1 && record.archetype_bits == 2 {
        (&tables[2].profiles, &tables[2].profiles)
    } else {
        return false;
    };
    let Some(&first) = first.get(record.first as usize) else {
        return false;
    };
    let Some(&second) = second.get(record.second as usize) else {
        return false;
    };
    let Some(sum) = pair_sum(first, second) else {
        return false;
    };
    let Some(target) = targets.targets.get(record.target as usize) else {
        return false;
    };
    let expected = if record.side == 0 {
        target.coordinates
    } else {
        target.coordinates.map(|value| 523 - value)
    };
    record._pad == 0
        && record.archetype_bits & target.archetype_bits == record.archetype_bits
        && sum == expected
}

fn quartet_counts(records: &[G41Q29MatchedPair]) -> Option<[u64; 2]> {
    let mut counts = [0_u64; 2];
    let mut cursor = 0_usize;
    while cursor < records.len() {
        let target = records[cursor].target;
        let end = records[cursor..].partition_point(|record| record.target == target) + cursor;
        let split = records[cursor..end].partition_point(|record| record.side == 0) + cursor;
        if records[cursor..split].iter().any(|record| record.side != 0)
            || records[split..end].iter().any(|record| record.side != 1)
        {
            return None;
        }
        for archetype in 0..2 {
            let bit = 1_u8 << archetype;
            let left = records[cursor..split]
                .iter()
                .filter(|record| record.archetype_bits & bit != 0)
                .count() as u64;
            let right = records[split..end]
                .iter()
                .filter(|record| record.archetype_bits == bit)
                .count() as u64;
            counts[archetype] = counts[archetype].checked_add(left.checked_mul(right)?)?;
        }
        cursor = end;
    }
    Some(counts)
}

pub fn read_g41_q29_matched_pair_cache(
    mut reader: impl Read,
    targets: &G41Q29PairTargetCache,
    expected_source: G41Q29PairTargetSourceBinding,
    tables: &[G41Q29AggregateBlockTablebase; 4],
) -> Result<G41Q29MatchedPairCache, G41Q29MatchedPairCacheError> {
    let mut magic = [0_u8; 8];
    reader.read_exact(&mut magic)?;
    let semantics_len = read_u32(&mut reader)? as usize;
    if magic != MAGIC || semantics_len != SEMANTICS.len() {
        return Err(G41Q29MatchedPairCacheError::SemanticMismatch);
    }
    let mut semantics = vec![0_u8; semantics_len];
    reader.read_exact(&mut semantics)?;
    let mut target_digest = [0_u8; 32];
    reader.read_exact(&mut target_digest)?;
    let count = read_u64(&mut reader)? as usize;
    let mut bound_record_digest = [0_u8; 32];
    reader.read_exact(&mut bound_record_digest)?;
    if semantics != SEMANTICS
        || target_digest != targets.report.target_digest
        || targets.report.source != expected_source
        || count == 0
        || count > MAX_RECORDS
        || tables.each_ref().map(|table| table.report.profile_digest)
            != expected_source.profile_digests
        || tables.each_ref().map(|table| table.profiles.len() as u32)
            != expected_source.profile_counts
    {
        return Err(G41Q29MatchedPairCacheError::SemanticMismatch);
    }
    let mut records = Vec::with_capacity(count);
    let mut hasher = Sha256::new();
    let mut pair_records = [0_u64; 3];
    for _ in 0..count {
        let target = read_u32(&mut reader)?;
        let first = read_u32(&mut reader)?;
        let second = read_u32(&mut reader)?;
        let mut tail = [0_u8; 2];
        reader.read_exact(&mut tail)?;
        let mut pad = [0_u8; 2];
        reader.read_exact(&mut pad)?;
        let record = G41Q29MatchedPair {
            target,
            first,
            second,
            archetype_bits: tail[0],
            side: tail[1],
            _pad: u16::from_le_bytes(pad),
        };
        update_record(&mut hasher, record);
        if !replay_record(record, targets, tables) {
            return Err(G41Q29MatchedPairCacheError::SemanticMismatch);
        }
        if record.side == 0 {
            pair_records[0] += 1;
        } else {
            pair_records[usize::from(record.archetype_bits.trailing_zeros() as u8) + 1] += 1;
        }
        records.push(record);
    }
    let mut trailing = [0_u8; 1];
    let actual_record_digest: [u8; 32] = hasher.finalize().into();
    if reader.read(&mut trailing)? != 0
        || records
            .windows(2)
            .any(|pair| record_key(&pair[0]) >= record_key(&pair[1]))
        || actual_record_digest != bound_record_digest
    {
        return Err(G41Q29MatchedPairCacheError::SemanticMismatch);
    }
    let exact_profile_quartets =
        quartet_counts(&records).ok_or(G41Q29MatchedPairCacheError::StateBudget)?;
    Ok(G41Q29MatchedPairCache {
        report: G41Q29MatchedPairCacheReport {
            source: expected_source,
            target_digest,
            records: count as u64,
            pair_records,
            exact_profile_quartets,
            record_digest: bound_record_digest,
            provenance: "sealed q29 matched-pair cache; exact semantics, target order and digest, source profile counts and digests, payload digest, strict record order, every seven-coordinate source pair, and merged quartet multiplicity are independently rebound on read",
        },
        records: records.into_boxed_slice(),
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::g41_q29_exact_tablebase::G41Q29AggregateBlockReport;
    use crate::g41_q29_pair_target_cache::{
        read_g41_q29_pair_target_cache, write_g41_q29_pair_target_cache,
    };
    use crate::g41_q29_profile_shard::G41Q29PairTarget;

    fn table(
        signature: [u8; 4],
        profiles: Vec<G41Q29ExactProfile>,
        digest: [u8; 32],
    ) -> G41Q29AggregateBlockTablebase {
        G41Q29AggregateBlockTablebase {
            report: G41Q29AggregateBlockReport {
                signature,
                row_sum: 0,
                group_contribution_states: [0; 3],
                coefficient_states_after_group: [0; 3],
                exact_coefficient_states: profiles.len() as u32,
                exact_correlation_profiles: profiles.len() as u32,
                profile_digest: digest,
                profiles_exceeding_defect_budget: 0,
                workspace_bytes: 0,
                provenance: "test",
            },
            profiles: profiles.into_boxed_slice(),
        }
    }

    fn source(tables: &[G41Q29AggregateBlockTablebase; 4]) -> G41Q29PairTargetSourceBinding {
        G41Q29PairTargetSourceBinding {
            signatures: tables.each_ref().map(|table| table.report.signature),
            profile_counts: tables.each_ref().map(|table| table.profiles.len() as u32),
            profile_digests: tables.each_ref().map(|table| table.report.profile_digest),
        }
    }

    fn matched_bytes(records: &[G41Q29MatchedPair], target_digest: [u8; 32]) -> Vec<u8> {
        let mut hasher = Sha256::new();
        for &record in records {
            update_record(&mut hasher, record);
        }
        let digest: [u8; 32] = hasher.finalize().into();
        let mut bytes = Vec::new();
        bytes.extend_from_slice(&MAGIC);
        bytes.extend_from_slice(&(SEMANTICS.len() as u32).to_le_bytes());
        bytes.extend_from_slice(SEMANTICS);
        bytes.extend_from_slice(&target_digest);
        bytes.extend_from_slice(&(records.len() as u64).to_le_bytes());
        bytes.extend_from_slice(&digest);
        for record in records {
            bytes.extend_from_slice(&record.target.to_le_bytes());
            bytes.extend_from_slice(&record.first.to_le_bytes());
            bytes.extend_from_slice(&record.second.to_le_bytes());
            bytes.extend_from_slice(&[record.archetype_bits, record.side]);
            bytes.extend_from_slice(&record._pad.to_le_bytes());
        }
        bytes
    }

    #[test]
    fn matched_cache_rebinds_records_and_rejects_forged_semantics() {
        let profile = |value| G41Q29ExactProfile::from_coordinates([value; 7]);
        let tables = [
            table([1; 4], vec![profile(100)], [1; 32]),
            table([2; 4], vec![profile(136), profile(137)], [2; 32]),
            table([3; 4], vec![profile(136), profile(137)], [3; 32]),
            table([4; 4], vec![profile(150)], [4; 32]),
        ];
        let source = source(&tables);
        let targets = [G41Q29PairTarget {
            coordinates: [250; 7],
            archetype_bits: 1,
            _pad: 0,
        }];
        let mut target_bytes = Vec::new();
        write_g41_q29_pair_target_cache(&targets, source, &mut target_bytes).unwrap();
        let target_cache = read_g41_q29_pair_target_cache(target_bytes.as_slice()).unwrap();
        let records = [
            G41Q29MatchedPair {
                target: 0,
                first: 0,
                second: 0,
                archetype_bits: 1,
                side: 0,
                _pad: 0,
            },
            G41Q29MatchedPair {
                target: 0,
                first: 0,
                second: 1,
                archetype_bits: 1,
                side: 1,
                _pad: 0,
            },
            G41Q29MatchedPair {
                target: 0,
                first: 1,
                second: 0,
                archetype_bits: 1,
                side: 1,
                _pad: 0,
            },
        ];
        let bytes = matched_bytes(&records, target_cache.report.target_digest);
        let decoded =
            read_g41_q29_matched_pair_cache(bytes.as_slice(), &target_cache, source, &tables)
                .unwrap();
        assert_eq!(decoded.report.pair_records, [1, 2, 0]);
        assert_eq!(decoded.report.exact_profile_quartets, [2, 0]);

        let mut forged_records = records;
        forged_records[1].second = 0;
        let forged = matched_bytes(&forged_records, target_cache.report.target_digest);
        assert!(matches!(
            read_g41_q29_matched_pair_cache(forged.as_slice(), &target_cache, source, &tables),
            Err(G41Q29MatchedPairCacheError::SemanticMismatch)
        ));
        let mut forged_source = source;
        forged_source.profile_digests[0][0] ^= 1;
        assert!(matches!(
            read_g41_q29_matched_pair_cache(
                bytes.as_slice(),
                &target_cache,
                forged_source,
                &tables
            ),
            Err(G41Q29MatchedPairCacheError::SemanticMismatch)
        ));
    }
}
