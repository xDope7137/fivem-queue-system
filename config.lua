--[[
    bp_queue -- server-only settings.

    Everything about how the queue looks and behaves is set in game: run
    /queueadmin and open Settings. This file holds only what must never reach a
    player's screen, credentials, and who counts as staff.

    Changes here take effect on the next restart of bp_queue.
]]

-- -------------------------------------------------------------- credentials --

-- Discord bot that checks guild membership and roles.
-- Bot token from https://discord.com/developers/applications
QueueCfg.discord.guild = ''
QueueCfg.discord.token = ''

-- Tebex secret for package lookups. Leave this empty: the queue reads the
-- official convar from your server.cfg,
--
--     set sv_tebexSecret "your-game-server-secret"
--
-- and falls back to `tebex_secret` when that is not set. Use `set`, never
-- `setr` or `sets`: those two hand the value to every player, and this secret
-- can refund payments. Fill it in here only to force a secret that wins over
-- server.cfg. Find it in Tebex under Integrations > Game Servers.
QueueCfg.tebex.secret = ''

-- The read-only HTTP bridge for a Discord bot. Sent by the caller as
-- `Authorization: Bearer <token>`. staffToken opens the routes that can read
-- somebody else's row; leave it empty to keep them closed.
QueueCfg.bridge.token = ''
QueueCfg.bridge.staffToken = ''

-- Optional webhook the bridge posts an occupancy line to. Empty sends nothing.
QueueCfg.bridge.status.webhook = ''

-- The in-game panel. Off removes /queueadmin entirely, settings included.
QueueCfg.admin.enabled = true

-- -------------------------------------------------------------- staff ranks --

-- Who may open the panel, and what each rank may change or do once inside.
--
-- Ranks are checked highest first and the first match wins. A player matches a
-- rank through any of:
--
--   ids     identifiers, e.g. 'license:abc...', 'discord:1234...', 'fivem:123'
--   ace     ace names; `add_ace group.admin admin allow` in your server.cfg
--           makes everybody in group.admin pass the 'admin' entry below
--   groups  framework groups, per framework: qbx (Qbox), qb (QBCore),
--           esx (ESX), nd (ND_Core). Ignored when that framework is not running
--   roles   Discord role ids, from the same lookup the queue already does
--
-- Qbox and QBCore keep their permission levels as aces, so on those the ace
-- and groups entries say the same thing. ESX and ND_Core keep groups of their
-- own, which only exist once the character has loaded. That is always true by
-- the time somebody opens the panel.
--
-- `edit` lists the Settings sections a rank may change: '*' for all of them,
-- or section names like 'brand', or one field like 'seats.warmupMs'. Sections
-- a rank cannot change are still shown, read-only. The section names are:
--   brand info seats pools access whitelist schedule grace discord avatars tebex roles
--   lanes grants storage admin rejection bridge labels tiers text testMode debug
--
-- `actions` lists the live queue controls a rank may use, '*' for all:
--   hold warm capacity loading schedule reweigh move lane grant drop
QueueCfg.staff = {
    -- Which framework to read groups from: 'auto' uses the first one running,
    -- or name one of qbx, qb, esx, nd, ox. 'ace' ignores frameworks entirely.
    -- Aces and identifiers are checked whatever this says.
    source = 'auto',

    -- Rank given to txAdmin admins, false to ignore them. txAdmin only reports
    -- its admins when its in-game menu is enabled (txAdmin-menuEnabled).
    txAdmin = 'admin',

    -- Rank given to anybody holding command.queue, which is how the panel was
    -- opened before ranks existed. false to stop honouring it.
    legacyAce = 'admin',

    ranks = {
        {
            key     = 'god',
            label   = 'God',
            ids     = {},
            ace     = { 'queue.god', 'god' },
            groups  = { qbx = { 'god' }, qb = { 'god' }, esx = { 'owner', 'superadmin' }, nd = { 'god' } },
            roles   = {},
            edit    = '*',
            actions = '*',
        },
        {
            key     = 'admin',
            label   = 'Admin',
            ids     = {},
            ace     = { 'queue.admin', 'admin' },
            groups  = { qbx = { 'admin' }, qb = { 'admin' }, esx = { 'admin' }, nd = { 'admin' } },
            roles   = {},
            edit    = {
                'brand', 'info', 'text', 'labels', 'tiers', 'seats', 'access', 'whitelist', 'schedule',
                'grace', 'pools', 'lanes', 'roles', 'rejection', 'tebex', 'avatars', 'grants',
            },
            actions = '*',
        },
        {
            key     = 'mod',
            label   = 'Moderator',
            ids     = {},
            ace     = { 'queue.mod', 'mod' },
            groups  = { qbx = { 'mod' }, qb = { 'mod' }, esx = { 'mod', 'moderator' }, nd = { 'mod' } },
            roles   = {},
            edit    = {},
            actions = { 'hold', 'move', 'lane', 'drop' },
        },
    },
}
