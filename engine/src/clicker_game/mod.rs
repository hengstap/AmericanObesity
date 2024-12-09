//! The [clicker-game](/clicker-game/mod.rs) is responsible for holding the state
//! associated with a clicker game, such that we can reload and replay a given
//! game save-state file, and serialize/deserialize it to/from disk.
#[allow(dead_code)]
pub const SAVE_FILE_VERSION: &str = env!("CARGO_PKG_VERSION");
