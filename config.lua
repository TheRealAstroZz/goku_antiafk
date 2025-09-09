Config = {}

-- General
Config.Debug = true

-- AFK logic
Config.AfkWarningThreshold = 30  -- minutes idle before showing captcha
Config.KickTime = 60             -- seconds to solve captcha before kick

-- Captcha
Config.CaptchaLength = 6         -- characters
Config.CaseSensitive = true

-- ACE exemptions (server.cfg: add_ace group.admin command.bypassafk allow)
Config.ExemptPermissions = {
    -- "group.admin",
    -- "group.mod",
    -- "command.bypassafk"
}

Config.Webhook = "https://discord.com/api/webhooks/1413561304991535255/xF7YSpgXGkbFhmReqhvW6I4rBHsF-h9xb34rh9kX8-HsPAR2VBPnVUjVR7SOKcYzpbAN" -- wenn leer, nutzt das Script den ConVar goku_antiafk_webhook
Config.WebhookAvatar = "https://i.postimg.cc/WbQxXbM4/I-never-realized-you-couldn-t-upload-your-own-avatar-Imgur.jpg"
Config.WebhookLogo   = Config.WebhookAvatar  -- Author/Thumbnail/Footer-Logo

Config.WebhookCompact = true    -- true: weniger Felder, false: alle Felder
Config.WebhookThreadName = ""   -- optional: setzt Thread-Titel in Forum/Medien-Channels

-- Farben
Config.EmbedColorSolved = 0x2ECC71  -- grün
Config.EmbedColorKick   = 0xE74C3C  -- rot

-- Datenschutz-Optionen
Config.LogIP = true

-- UI
Config.Title = "🛑 — Anti‑AFK"
Config.Description = "You were flagged as inactive. Type the captcha correctly to stay connected."
Config.ButtonText = "Confirm"
Config.AllowCancel = false
Config.ServerName = "ForsakenWorld"

-- Styling presets (set in CSS vars via NUI message)
Config.PanelStyle = "modern"      -- default, modern, minimal, futuristic, retro
Config.CaptchaStyle = "default"   -- default, neon, minimalist, gradient, 3d, glitch, cyber, retro-arcade, holographic, paper, matrix

Config.KickMessage = "You were kicked for being AFK too long."

Config.Notification = {
    Success = "Captcha verified successfully!",
    Error   = "Captcha verification failed. Please try again.",
    Cancel  = "Captcha verification cancelled."
}
