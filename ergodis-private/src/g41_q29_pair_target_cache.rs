//! Sealed discovery-only cache for exact aggregate q29 pair-sum targets.

use std::io::{Read, Write};

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g41_q29_profile_shard::G41Q29PairTarget;

const MAGIC: [u8; 8] = *b"G41PTG01";
const SCHEMA_VERSION: u32 = 1;
const CARRIER: u32 = 522;
const QUOTIENT: u32 = 29;
const COORDINATES: u32 = 7;
const MAX_TARGETS: usize = 1 << 24;
const SEMANTICS: &[u8] = b"ergodis-private/g41-q29-pair-target-cache/v1; carrier=522; quotient=29; extractor=compile_g41_q29_aggregate_block_tablebase/v1; exact seven-coordinate A+C profile sum; archetype bits 1=B1+B1 and 2=B5+B5; targets canonical strict order; aggregate relaxation is discovery-only and carries no source exclusion authority";

#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize)]
pub struct G41Q29PairTargetSourceBinding {
    pub signatures: [[u8; 4]; 4],
    pub profile_counts: [u32; 4],
    pub profile_digests: [[u8; 32]; 4],
}

#[derive(Clone, Debug, PartialEq, Eq, Serialize)]
pub struct G41Q29PairTargetCacheReport {
    pub source: G41Q29PairTargetSourceBinding,
    pub targets: u32,
    pub target_digest: [u8; 32],
    pub provenance: &'static str,
}

pub struct G41Q29PairTargetCache {
    pub report: G41Q29PairTargetCacheReport,
    pub targets: Box<[G41Q29PairTarget]>,
}

pub fn verify_g41_q29_pair_target_source(
    cache: &G41Q29PairTargetCache,
    expected: G41Q29PairTargetSourceBinding,
) -> Result<(), G41Q29PairTargetCacheError> {
    if cache.report.source != expected {
        return Err(G41Q29PairTargetCacheError::SemanticMismatch);
    }
    Ok(())
}

#[derive(Debug, Error)]
pub enum G41Q29PairTargetCacheError {
    #[error("q29 pair-target cache I/O failed")]
    Io(#[from] std::io::Error),
    #[error("q29 pair-target cache resource bound exceeded")]
    StateBudget,
    #[error("q29 pair-target cache semantic binding or payload failed")]
    SemanticMismatch,
}

fn semantics_digest() -> [u8; 32] {
    Sha256::digest(SEMANTICS).into()
}

fn update_target(hasher: &mut Sha256, target: &G41Q29PairTarget) {
    for &coordinate in &target.coordinates {
        hasher.update(coordinate.to_le_bytes());
    }
    hasher.update([target.archetype_bits, 0]);
}

fn target_digest(targets: &[G41Q29PairTarget]) -> [u8; 32] {
    let mut hasher = Sha256::new();
    for target in targets {
        update_target(&mut hasher, target);
    }
    hasher.finalize().into()
}

fn valid_target(target: &G41Q29PairTarget) -> bool {
    target.coordinates.iter().all(|&value| value <= 523)
        && matches!(target.archetype_bits, 1..=3)
        && target._pad == 0
}

fn validate_targets(targets: &[G41Q29PairTarget]) -> Result<(), G41Q29PairTargetCacheError> {
    if targets.is_empty()
        || targets.len() > MAX_TARGETS
        || targets.iter().any(|target| !valid_target(target))
        || targets.windows(2).any(|pair| pair[0] >= pair[1])
    {
        return Err(G41Q29PairTargetCacheError::SemanticMismatch);
    }
    Ok(())
}

fn write_u32(writer: &mut impl Write, value: u32) -> Result<(), std::io::Error> {
    writer.write_all(&value.to_le_bytes())
}

fn read_u32(reader: &mut impl Read) -> Result<u32, std::io::Error> {
    let mut bytes = [0_u8; 4];
    reader.read_exact(&mut bytes)?;
    Ok(u32::from_le_bytes(bytes))
}

pub fn write_g41_q29_pair_target_cache(
    targets: &[G41Q29PairTarget],
    source: G41Q29PairTargetSourceBinding,
    mut writer: impl Write,
) -> Result<G41Q29PairTargetCacheReport, G41Q29PairTargetCacheError> {
    validate_targets(targets)?;
    let digest = target_digest(targets);
    writer.write_all(&MAGIC)?;
    write_u32(&mut writer, SCHEMA_VERSION)?;
    write_u32(&mut writer, CARRIER)?;
    write_u32(&mut writer, QUOTIENT)?;
    write_u32(&mut writer, COORDINATES)?;
    writer.write_all(&semantics_digest())?;
    for signature in source.signatures {
        writer.write_all(&signature)?;
    }
    for count in source.profile_counts {
        write_u32(&mut writer, count)?;
    }
    for digest in source.profile_digests {
        writer.write_all(&digest)?;
    }
    write_u32(&mut writer, targets.len() as u32)?;
    writer.write_all(&digest)?;
    for target in targets {
        for &coordinate in &target.coordinates {
            writer.write_all(&coordinate.to_le_bytes())?;
        }
        writer.write_all(&[target.archetype_bits, 0])?;
    }
    writer.flush()?;
    Ok(G41Q29PairTargetCacheReport {
        source,
        targets: targets.len() as u32,
        target_digest: digest,
        provenance: "sealed discovery-only aggregate q29 pair-target cache; extractor semantics, source profile commitments, canonical target order, and payload digest are verified on read",
    })
}

pub fn read_g41_q29_pair_target_cache(
    mut reader: impl Read,
) -> Result<G41Q29PairTargetCache, G41Q29PairTargetCacheError> {
    let mut magic = [0_u8; 8];
    reader.read_exact(&mut magic)?;
    let schema = read_u32(&mut reader)?;
    let carrier = read_u32(&mut reader)?;
    let quotient = read_u32(&mut reader)?;
    let coordinates = read_u32(&mut reader)?;
    let mut bound_semantics = [0_u8; 32];
    reader.read_exact(&mut bound_semantics)?;
    if magic != MAGIC
        || schema != SCHEMA_VERSION
        || carrier != CARRIER
        || quotient != QUOTIENT
        || coordinates != COORDINATES
        || bound_semantics != semantics_digest()
    {
        return Err(G41Q29PairTargetCacheError::SemanticMismatch);
    }
    let mut signatures = [[0_u8; 4]; 4];
    for signature in &mut signatures {
        reader.read_exact(signature)?;
    }
    let mut profile_counts = [0_u32; 4];
    for count in &mut profile_counts {
        *count = read_u32(&mut reader)?;
    }
    let mut profile_digests = [[0_u8; 32]; 4];
    for digest in &mut profile_digests {
        reader.read_exact(digest)?;
    }
    let count = read_u32(&mut reader)? as usize;
    if count == 0 || count > MAX_TARGETS {
        return Err(G41Q29PairTargetCacheError::StateBudget);
    }
    let mut bound_digest = [0_u8; 32];
    reader.read_exact(&mut bound_digest)?;
    let mut targets = Vec::with_capacity(count);
    for _ in 0..count {
        let mut target = G41Q29PairTarget::default();
        for coordinate in &mut target.coordinates {
            let mut bytes = [0_u8; 2];
            reader.read_exact(&mut bytes)?;
            *coordinate = u16::from_le_bytes(bytes);
        }
        let mut tail = [0_u8; 2];
        reader.read_exact(&mut tail)?;
        target.archetype_bits = tail[0];
        target._pad = tail[1];
        targets.push(target);
    }
    let mut trailing = [0_u8; 1];
    if reader.read(&mut trailing)? != 0 {
        return Err(G41Q29PairTargetCacheError::SemanticMismatch);
    }
    validate_targets(&targets)?;
    if target_digest(&targets) != bound_digest {
        return Err(G41Q29PairTargetCacheError::SemanticMismatch);
    }
    let source = G41Q29PairTargetSourceBinding {
        signatures,
        profile_counts,
        profile_digests,
    };
    Ok(G41Q29PairTargetCache {
        report: G41Q29PairTargetCacheReport {
            source,
            targets: count as u32,
            target_digest: bound_digest,
            provenance: "sealed discovery-only aggregate q29 pair-target cache; extractor semantics, source profile commitments, canonical target order, and payload digest are verified on read",
        },
        targets: targets.into_boxed_slice(),
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    fn source() -> G41Q29PairTargetSourceBinding {
        G41Q29PairTargetSourceBinding {
            signatures: [[1; 4], [2; 4], [3; 4], [4; 4]],
            profile_counts: [5, 6, 7, 8],
            profile_digests: [[9; 32], [10; 32], [11; 32], [12; 32]],
        }
    }

    #[test]
    fn pair_target_cache_round_trip_and_forgery_rejection() {
        let targets = [
            G41Q29PairTarget {
                coordinates: [100; 7],
                archetype_bits: 1,
                _pad: 0,
            },
            G41Q29PairTarget {
                coordinates: [200; 7],
                archetype_bits: 3,
                _pad: 0,
            },
        ];
        let mut bytes = Vec::new();
        let issued = write_g41_q29_pair_target_cache(&targets, source(), &mut bytes).unwrap();
        let decoded = read_g41_q29_pair_target_cache(bytes.as_slice()).unwrap();
        assert_eq!(&*decoded.targets, &targets);
        assert_eq!(decoded.report, issued);
        verify_g41_q29_pair_target_source(&decoded, source()).unwrap();
        let mut forged_source = source();
        forged_source.profile_counts[0] += 1;
        assert!(matches!(
            verify_g41_q29_pair_target_source(&decoded, forged_source),
            Err(G41Q29PairTargetCacheError::SemanticMismatch)
        ));

        let last = bytes.len() - 1;
        bytes[last] ^= 1;
        assert!(matches!(
            read_g41_q29_pair_target_cache(bytes.as_slice()),
            Err(G41Q29PairTargetCacheError::SemanticMismatch)
        ));
    }
}
