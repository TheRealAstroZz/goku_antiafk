# goku_antiafk
Standalone Anti‑AFK with Captcha for FiveM

**Author:** Goku | .astrozz

## Install
1. Put the `goku_antiafk` folder into resources.
2. In `server.cfg`: `ensure goku_antiafk`
3. (Optional) Add ACE bypass, e.g.
   ```cfg
   add_ace group.admin command.bypassafk allow
   add_principal identifier.steam:YOURSTEAMHEX group.admin
   ```
4. Tweak settings in `config.lua`.

## Notes
* The UI uses NUI Callback Strict Mode (fxmanifest flag). If you're on an older build, set `nui_callback_strict_mode 'false'`.
* Resource name is used by NUI for callbacks. Keep the folder name `goku_antiafk` unless you also change it inside `web/app.js`.

## Debug
Set `Config.Debug = true` and use `/antiAFK_test` (client) or `/antiAFK_open` (server) to trigger the UI.
