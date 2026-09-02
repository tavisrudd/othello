//! Streamed, bounded, create-only payload artifacts for proposal tickets.

use super::ProposalIdempotencyKey;
use serde::Serialize;
use std::fs::{self, File, OpenOptions};
use std::io::{self, Read, Write};
use std::os::unix::fs::{OpenOptionsExt, PermissionsExt};
use std::path::{Path, PathBuf};

const INCOMING_DIRECTORY: &str = "incoming";
const RESULTS_DIRECTORY: &str = "results";
const COPY_BUFFER_BYTES: usize = 64 * 1024;

#[derive(Clone, Debug, Eq, PartialEq, Serialize)]
pub struct ProposalArtifact {
    pub relative_path: PathBuf,
    pub blake3: [u8; 32],
    pub bytes: u64,
}

#[derive(Debug, thiserror::Error)]
pub enum ProposalArtifactError {
    #[error("proposal artifact I/O failed: {0}")]
    Io(#[from] io::Error),
    #[error("proposal artifact identity or path is invalid")]
    InvalidPath,
    #[error("proposal artifact exceeds its declared byte bound")]
    TooLarge,
    #[error("published proposal artifact does not match ticket metadata")]
    MetadataMismatch,
    #[error("proposal artifact store is poisoned after an ambiguous durable write")]
    Poisoned,
}

pub struct ProposalArtifactStore {
    run_dir: PathBuf,
    incoming: PathBuf,
    results: PathBuf,
    temp_sequence: u64,
    poisoned: bool,
}

impl ProposalArtifactStore {
    pub fn create(run_dir: &Path, root: &Path) -> Result<Self, ProposalArtifactError> {
        let run_dir = run_dir.canonicalize()?;
        fs::create_dir(root)?;
        fs::set_permissions(root, fs::Permissions::from_mode(0o700))?;
        let incoming = root.join(INCOMING_DIRECTORY);
        let results = root.join(RESULTS_DIRECTORY);
        for directory in [&incoming, &results] {
            fs::create_dir(directory)?;
            fs::set_permissions(directory, fs::Permissions::from_mode(0o700))?;
            sync_directory(directory)?;
        }
        sync_directory(root)?;
        if let Some(parent) = root.parent().filter(|path| !path.as_os_str().is_empty()) {
            sync_directory(parent)?;
        }
        Ok(Self {
            run_dir,
            incoming,
            results,
            temp_sequence: 1,
            poisoned: false,
        })
    }

    pub fn create_session(&self, session_id: &str) -> Result<(), ProposalArtifactError> {
        validate_session_id(session_id)?;
        for parent in [&self.incoming, &self.results] {
            let directory = parent.join(session_id);
            fs::create_dir(&directory)?;
            fs::set_permissions(&directory, fs::Permissions::from_mode(0o700))?;
            sync_directory(&directory)?;
            sync_directory(parent)?;
        }
        Ok(())
    }

    pub fn upload_relative_path(
        &self,
        session_id: &str,
        key: ProposalIdempotencyKey,
        attempt: u8,
    ) -> Result<PathBuf, ProposalArtifactError> {
        self.relative(&self.upload_path(session_id, key, attempt)?)
    }

    pub fn publish(
        &mut self,
        session_id: &str,
        key: ProposalIdempotencyKey,
        attempt: u8,
        maximum_bytes: u64,
    ) -> Result<ProposalArtifact, ProposalArtifactError> {
        self.ensure_healthy()?;
        if maximum_bytes == 0 {
            return Err(ProposalArtifactError::TooLarge);
        }
        let destination = self.result_path(session_id, key)?;
        if destination.exists() {
            return self.inspect_result_path(&destination, maximum_bytes, None);
        }
        let source = self.upload_path(session_id, key, attempt)?;
        let mut input = open_private_regular(&source)?;
        let sequence = self.next_temp_sequence()?;
        let temporary = destination
            .parent()
            .ok_or(ProposalArtifactError::InvalidPath)?
            .join(format!(".tmp-{}-{sequence:016x}", std::process::id()));
        let result = self.copy_publish(&mut input, &temporary, &destination, maximum_bytes);
        if result.is_err() {
            if matches!(&result, Err(ProposalArtifactError::Io(_))) {
                self.poisoned = true;
            }
            let _ = fs::remove_file(&temporary);
            return result;
        }
        fs::remove_file(source)?;
        sync_directory(&self.incoming.join(session_id))?;
        result
    }

    pub fn inspect(
        &self,
        session_id: &str,
        key: ProposalIdempotencyKey,
        maximum_bytes: u64,
        expected: Option<([u8; 32], u64)>,
    ) -> Result<ProposalArtifact, ProposalArtifactError> {
        self.ensure_healthy()?;
        self.inspect_result_path(&self.result_path(session_id, key)?, maximum_bytes, expected)
    }

    fn copy_publish(
        &self,
        input: &mut File,
        temporary: &Path,
        destination: &Path,
        maximum_bytes: u64,
    ) -> Result<ProposalArtifact, ProposalArtifactError> {
        let mut output = OpenOptions::new()
            .write(true)
            .create_new(true)
            .mode(0o600)
            .custom_flags(libc::O_NOFOLLOW)
            .open(temporary)?;
        let mut hasher = blake3::Hasher::new();
        let mut bytes = 0_u64;
        let mut buffer = [0_u8; COPY_BUFFER_BYTES];
        loop {
            let count = input.read(&mut buffer)?;
            if count == 0 {
                break;
            }
            bytes = bytes
                .checked_add(count as u64)
                .ok_or(ProposalArtifactError::TooLarge)?;
            if bytes > maximum_bytes {
                return Err(ProposalArtifactError::TooLarge);
            }
            hasher.update(&buffer[..count]);
            output.write_all(&buffer[..count])?;
        }
        output.sync_all()?;
        fs::hard_link(temporary, destination)?;
        fs::set_permissions(destination, fs::Permissions::from_mode(0o400))?;
        fs::remove_file(temporary)?;
        sync_directory(
            destination
                .parent()
                .ok_or(ProposalArtifactError::InvalidPath)?,
        )?;
        Ok(ProposalArtifact {
            relative_path: self.relative(destination)?,
            blake3: *hasher.finalize().as_bytes(),
            bytes,
        })
    }

    fn inspect_result_path(
        &self,
        path: &Path,
        maximum_bytes: u64,
        expected: Option<([u8; 32], u64)>,
    ) -> Result<ProposalArtifact, ProposalArtifactError> {
        let mut input = open_private_regular(path)?;
        let mut hasher = blake3::Hasher::new();
        let mut bytes = 0_u64;
        let mut buffer = [0_u8; COPY_BUFFER_BYTES];
        loop {
            let count = input.read(&mut buffer)?;
            if count == 0 {
                break;
            }
            bytes = bytes
                .checked_add(count as u64)
                .ok_or(ProposalArtifactError::TooLarge)?;
            if bytes > maximum_bytes {
                return Err(ProposalArtifactError::TooLarge);
            }
            hasher.update(&buffer[..count]);
        }
        let blake3 = *hasher.finalize().as_bytes();
        if expected.is_some_and(|expected| expected != (blake3, bytes)) {
            return Err(ProposalArtifactError::MetadataMismatch);
        }
        Ok(ProposalArtifact {
            relative_path: self.relative(path)?,
            blake3,
            bytes,
        })
    }

    fn upload_path(
        &self,
        session_id: &str,
        key: ProposalIdempotencyKey,
        attempt: u8,
    ) -> Result<PathBuf, ProposalArtifactError> {
        validate_session_id(session_id)?;
        Ok(self
            .incoming
            .join(session_id)
            .join(format!("{}-{attempt:02x}.upload", key.to_hex())))
    }

    fn result_path(
        &self,
        session_id: &str,
        key: ProposalIdempotencyKey,
    ) -> Result<PathBuf, ProposalArtifactError> {
        validate_session_id(session_id)?;
        Ok(self
            .results
            .join(session_id)
            .join(format!("{}.result", key.to_hex())))
    }

    fn relative(&self, path: &Path) -> Result<PathBuf, ProposalArtifactError> {
        path.strip_prefix(&self.run_dir)
            .map(Path::to_path_buf)
            .map_err(|_| ProposalArtifactError::InvalidPath)
    }

    fn next_temp_sequence(&mut self) -> Result<u64, ProposalArtifactError> {
        let sequence = self.temp_sequence;
        self.temp_sequence = self
            .temp_sequence
            .checked_add(1)
            .ok_or(ProposalArtifactError::InvalidPath)?;
        Ok(sequence)
    }

    fn ensure_healthy(&self) -> Result<(), ProposalArtifactError> {
        if self.poisoned {
            Err(ProposalArtifactError::Poisoned)
        } else {
            Ok(())
        }
    }
}

fn validate_session_id(session_id: &str) -> Result<(), ProposalArtifactError> {
    if session_id.len() != 32
        || !session_id
            .bytes()
            .all(|byte| byte.is_ascii_digit() || (b'a'..=b'f').contains(&byte))
    {
        return Err(ProposalArtifactError::InvalidPath);
    }
    Ok(())
}

fn open_private_regular(path: &Path) -> Result<File, ProposalArtifactError> {
    let file = OpenOptions::new()
        .read(true)
        .custom_flags(libc::O_NOFOLLOW)
        .open(path)?;
    let metadata = file.metadata()?;
    if !metadata.is_file() || metadata.permissions().mode() & 0o077 != 0 {
        return Err(ProposalArtifactError::InvalidPath);
    }
    Ok(file)
}

fn sync_directory(path: &Path) -> Result<(), ProposalArtifactError> {
    File::open(path)?.sync_all()?;
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn key() -> ProposalIdempotencyKey {
        ProposalIdempotencyKey::new("session", 1, [3; 32]).unwrap()
    }

    #[test]
    fn upload_is_streamed_published_and_replayed() {
        let temporary = tempfile::tempdir().unwrap();
        let run = temporary.path().join("run");
        fs::create_dir(&run).unwrap();
        let mut store = ProposalArtifactStore::create(&run, &run.join("artifacts")).unwrap();
        let session = "0123456789abcdef0123456789abcdef";
        store.create_session(session).unwrap();
        let upload = run.join(store.upload_relative_path(session, key(), 0).unwrap());
        let mut output = OpenOptions::new()
            .write(true)
            .create_new(true)
            .mode(0o600)
            .open(&upload)
            .unwrap();
        output.write_all(b"compact result\n").unwrap();
        output.sync_all().unwrap();
        let artifact = store.publish(session, key(), 0, 1024).unwrap();
        assert_eq!(artifact.bytes, 15);
        assert_eq!(
            artifact.blake3,
            *blake3::hash(b"compact result\n").as_bytes()
        );
        assert!(!upload.exists());
        assert_eq!(
            store
                .inspect(
                    session,
                    key(),
                    1024,
                    Some((artifact.blake3, artifact.bytes))
                )
                .unwrap(),
            artifact
        );
        assert_eq!(store.publish(session, key(), 0, 1024).unwrap(), artifact);
    }

    #[test]
    fn oversize_and_symlink_uploads_fail_closed() {
        let temporary = tempfile::tempdir().unwrap();
        let run = temporary.path().join("run");
        fs::create_dir(&run).unwrap();
        let mut store = ProposalArtifactStore::create(&run, &run.join("artifacts")).unwrap();
        let session = "0123456789abcdef0123456789abcdef";
        store.create_session(session).unwrap();
        let upload = run.join(store.upload_relative_path(session, key(), 0).unwrap());
        fs::write(&upload, [7; 17]).unwrap();
        fs::set_permissions(&upload, fs::Permissions::from_mode(0o600)).unwrap();
        assert!(matches!(
            store.publish(session, key(), 0, 16),
            Err(ProposalArtifactError::TooLarge)
        ));
        assert!(!run
            .join("artifacts/results")
            .join(session)
            .join(format!("{}.result", key().to_hex()))
            .exists());

        fs::remove_file(&upload).unwrap();
        let outside = run.join("outside");
        fs::write(&outside, b"small").unwrap();
        std::os::unix::fs::symlink(&outside, &upload).unwrap();
        assert!(matches!(
            store.publish(session, key(), 0, 16),
            Err(ProposalArtifactError::Io(error))
                if error.raw_os_error() == Some(libc::ELOOP)
        ));
        assert_eq!(fs::read(outside).unwrap(), b"small");
    }
}
