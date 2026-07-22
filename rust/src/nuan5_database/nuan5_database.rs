
use aes_gcm::{
  aead::{Aead, KeyInit},
  Aes256Gcm, Key,
};
use hkdf::Hkdf;
use sha2::Sha256;
use std::fs;

const KEY: &[u8; 32] = b"9C46C6BF431F5AFFF97A2002AEDFA8B7";
const SALT_LEN: usize = 16;
const NONCE_LEN: usize = 12;

fn derive_key(salt: &[u8; SALT_LEN]) -> Key<Aes256Gcm>{
  let hkdf = Hkdf::<Sha256>::new(Some(salt), KEY);
  let mut okm = [0u8; 32];
  hkdf.expand(b"aes-gcm-filebox", &mut okm).unwrap();
  okm.into()
}

pub fn nuan5_database_decrypt(input: &str) -> Option<Vec<u8>>{
  let data = fs::read(input).ok()?;

  if data.len() < SALT_LEN + NONCE_LEN + 16 {
    return None;
  }

  let salt: [u8; SALT_LEN] = data[..SALT_LEN].try_into().ok()?;
  let nonce: [u8; NONCE_LEN] = data[SALT_LEN..SALT_LEN + NONCE_LEN].try_into().ok()?;
  let ciphertext = &data[SALT_LEN + NONCE_LEN..];

  let aes_key = derive_key(&salt);
  let cipher = Aes256Gcm::new(&aes_key);

  cipher.decrypt(&nonce.into(), ciphertext).ok()
}