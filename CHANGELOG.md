# Changelog

## 1.2.0 (2026-11-08)

### Fixed
- The waiting card no longer ships with our test server's name, tagline and texts. The server name now comes from your sv_projectName, the prefix is [Queue] and the tagline, blurb and about text start empty.

### New
- Upgrading from the free queue is automatic. On its first start, bp_queue copies the panel settings from bp_queue_free, then stops bp_queue_free and keeps it from starting again.

### Updating
- Replace the folder but keep your config.lua. Nothing in config.lua changed.
- Coming from the free queue: leave the bp_queue_free folder in place for the first start so the settings can be copied, then remove ensure bp_queue_free. Staff ranks live in config.lua, so copy those across by hand.
