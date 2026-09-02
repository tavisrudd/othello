//! Sealed binary cache for the exact g41 common-quotient digit interfaces.

use std::io::{Read, Write};

use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::g41_joint_quotient_search::{
    replay_witness, G41JointDigitWitnessReport, G41JointQuotientSearchError,
    G41JointQuotientWitness,
};

const MAGIC: [u8; 8] = *b"G41DGT01";
const SCHEMA_VERSION: u32 = 1;
const CARRIER: u32 = 522;
const QUOTIENT: u32 = 18;
const MULTIPLIER: u32 = 41;
const MAX_ROOTS: usize = 768;
const MAX_WITNESSES: usize = 1 << 22;
const SEMANTICS: &[u8] = b"ergodis-private/g41-common-quotient-digit-witnesses/v1; carrier=522; quotient=18; multiplier=41; canonical six-slot digit packing; exact energy=230; exact PAF targets=15080 at shifts 1,2,3,6,9; root masks bound to root_id; all payload witnesses directly replayed";

#[derive(Debug, Error)]
pub enum G41DigitWitnessCacheError {
    #[error("g41 digit witness cache I/O failed")]
    Io(#[from] std::io::Error),
    #[error("g41 digit witness cache resource bound exceeded")]
    StateBudget,
    #[error("g41 digit witness cache semantic binding or payload failed")]
    SemanticMismatch,
    #[error(transparent)]
    Quotient(#[from] G41JointQuotientSearchError),
}

fn semantic_digest() -> [u8; 32] {
    Sha256::digest(SEMANTICS).into()
}

fn update_u32(hasher: &mut Sha256, value: u32) {
    hasher.update(value.to_le_bytes());
}

fn update_witness(hasher: &mut Sha256, witness: &G41JointQuotientWitness) {
    update_u32(hasher, witness.root_id);
    hasher.update(witness.masks);
    for &digit in &witness.digits {
        update_u32(hasher, digit);
    }
}

fn payload_digest(report: &G41JointDigitWitnessReport) -> [u8; 32] {
    let mut hasher = Sha256::new();
    for &offset in report.root_offsets.iter() {
        update_u32(&mut hasher, offset);
    }
    for witness in report.witnesses.iter() {
        update_witness(&mut hasher, witness);
    }
    hasher.finalize().into()
}

fn validate_report(report: &G41JointDigitWitnessReport) -> Result<(), G41DigitWitnessCacheError> {
    let roots = report.roots_examined as usize;
    if roots == 0
        || roots > MAX_ROOTS
        || report.witnesses.is_empty()
        || report.witnesses.len() > MAX_WITNESSES
        || report.digit_witnesses != report.witnesses.len() as u64
        || report.root_offsets.len() != roots + 1
        || report.root_offsets[0] != 0
        || report.root_offsets[roots] as usize != report.witnesses.len()
    {
        return Err(G41DigitWitnessCacheError::SemanticMismatch);
    }
    let mut minimum = u32::MAX;
    let mut maximum = 0_u32;
    for root in 0..roots {
        let start = report.root_offsets[root];
        let end = report.root_offsets[root + 1];
        if end <= start || end as usize > report.witnesses.len() {
            return Err(G41DigitWitnessCacheError::SemanticMismatch);
        }
        let count = end - start;
        minimum = minimum.min(count);
        maximum = maximum.max(count);
        for witness in &report.witnesses[start as usize..end as usize] {
            if witness.masks
                != std::array::from_fn(|block| ((witness.root_id >> (6 * block)) & 63) as u8)
            {
                return Err(G41DigitWitnessCacheError::SemanticMismatch);
            }
            replay_witness(witness)?;
        }
    }
    if minimum != report.minimum_root_witnesses || maximum != report.maximum_root_witnesses {
        return Err(G41DigitWitnessCacheError::SemanticMismatch);
    }
    Ok(())
}

fn write_u32(writer: &mut impl Write, value: u32) -> Result<(), std::io::Error> {
    writer.write_all(&value.to_le_bytes())
}

fn write_u64(writer: &mut impl Write, value: u64) -> Result<(), std::io::Error> {
    writer.write_all(&value.to_le_bytes())
}

pub fn write_g41_digit_witness_cache(
    report: &G41JointDigitWitnessReport,
    mut writer: impl Write,
) -> Result<[u8; 32], G41DigitWitnessCacheError> {
    validate_report(report)?;
    let digest = payload_digest(report);
    writer.write_all(&MAGIC)?;
    write_u32(&mut writer, SCHEMA_VERSION)?;
    write_u32(&mut writer, CARRIER)?;
    write_u32(&mut writer, QUOTIENT)?;
    write_u32(&mut writer, MULTIPLIER)?;
    write_u32(&mut writer, report.roots_examined)?;
    write_u64(&mut writer, report.digit_witnesses)?;
    write_u32(&mut writer, report.minimum_root_witnesses)?;
    write_u32(&mut writer, report.maximum_root_witnesses)?;
    writer.write_all(&semantic_digest())?;
    writer.write_all(&digest)?;
    for &offset in report.root_offsets.iter() {
        write_u32(&mut writer, offset)?;
    }
    for witness in report.witnesses.iter() {
        write_u32(&mut writer, witness.root_id)?;
        writer.write_all(&witness.masks)?;
        for &digit in &witness.digits {
            write_u32(&mut writer, digit)?;
        }
    }
    writer.flush()?;
    Ok(digest)
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

pub fn read_g41_digit_witness_cache(
    mut reader: impl Read,
) -> Result<G41JointDigitWitnessReport, G41DigitWitnessCacheError> {
    let mut magic = [0_u8; 8];
    reader.read_exact(&mut magic)?;
    let schema = read_u32(&mut reader)?;
    let carrier = read_u32(&mut reader)?;
    let quotient = read_u32(&mut reader)?;
    let multiplier = read_u32(&mut reader)?;
    let roots = read_u32(&mut reader)?;
    let witnesses = read_u64(&mut reader)?;
    let minimum = read_u32(&mut reader)?;
    let maximum = read_u32(&mut reader)?;
    let mut bound_semantics = [0_u8; 32];
    let mut bound_payload = [0_u8; 32];
    reader.read_exact(&mut bound_semantics)?;
    reader.read_exact(&mut bound_payload)?;
    if magic != MAGIC
        || schema != SCHEMA_VERSION
        || carrier != CARRIER
        || quotient != QUOTIENT
        || multiplier != MULTIPLIER
        || roots == 0
        || roots as usize > MAX_ROOTS
        || witnesses == 0
        || witnesses as usize > MAX_WITNESSES
        || bound_semantics != semantic_digest()
    {
        return Err(G41DigitWitnessCacheError::SemanticMismatch);
    }
    let mut root_offsets = Vec::with_capacity(roots as usize + 1);
    for _ in 0..=roots {
        root_offsets.push(read_u32(&mut reader)?);
    }
    let mut payload = Vec::with_capacity(witnesses as usize);
    for _ in 0..witnesses {
        let root_id = read_u32(&mut reader)?;
        let mut masks = [0_u8; 4];
        reader.read_exact(&mut masks)?;
        let mut digits = [0_u32; 4];
        for digit in &mut digits {
            *digit = read_u32(&mut reader)?;
        }
        payload.push(G41JointQuotientWitness {
            root_id,
            masks,
            digits,
        });
    }
    let mut trailing = [0_u8; 1];
    if reader.read(&mut trailing)? != 0 {
        return Err(G41DigitWitnessCacheError::SemanticMismatch);
    }
    let report = G41JointDigitWitnessReport {
        roots_examined: roots,
        digit_witnesses: witnesses,
        minimum_root_witnesses: minimum,
        maximum_root_witnesses: maximum,
        root_offsets: root_offsets.into_boxed_slice(),
        witnesses: payload.into_boxed_slice(),
        provenance: "sealed g41 digit-witness cache; extractor semantics and payload digest verified; every witness directly replays all ten quotient equations; no fine-orbit exclusion authority",
    };
    if payload_digest(&report) != bound_payload {
        return Err(G41DigitWitnessCacheError::SemanticMismatch);
    }
    validate_report(&report)?;
    Ok(report)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn singleton_report() -> G41JointDigitWitnessReport {
        let witness = G41JointQuotientWitness {
            root_id: 3_759_256,
            masks: [24, 50, 21, 14],
            digits: [2_217_246, 1_958_432, 1_958_307, 1_972_636],
        };
        G41JointDigitWitnessReport {
            roots_examined: 1,
            digit_witnesses: 1,
            minimum_root_witnesses: 1,
            maximum_root_witnesses: 1,
            root_offsets: Box::new([0, 1]),
            witnesses: Box::new([witness]),
            provenance: "test",
        }
    }

    #[test]
    fn cache_round_trip_replays_bound_payload() {
        let report = singleton_report();
        let mut bytes = Vec::new();
        let digest = write_g41_digit_witness_cache(&report, &mut bytes).unwrap();
        let decoded = read_g41_digit_witness_cache(bytes.as_slice()).unwrap();
        assert_eq!(decoded.witnesses, report.witnesses);
        assert_eq!(payload_digest(&decoded), digest);
    }

    #[test]
    fn cache_rejects_forged_payload_and_trailing_bytes() {
        let report = singleton_report();
        let mut bytes = Vec::new();
        write_g41_digit_witness_cache(&report, &mut bytes).unwrap();
        let last = bytes.len() - 1;
        bytes[last] ^= 1;
        assert!(matches!(
            read_g41_digit_witness_cache(bytes.as_slice()),
            Err(G41DigitWitnessCacheError::SemanticMismatch)
                | Err(G41DigitWitnessCacheError::Quotient(_))
        ));

        let mut bytes = Vec::new();
        write_g41_digit_witness_cache(&report, &mut bytes).unwrap();
        bytes.push(0);
        assert!(matches!(
            read_g41_digit_witness_cache(bytes.as_slice()),
            Err(G41DigitWitnessCacheError::SemanticMismatch)
        ));
    }
}
