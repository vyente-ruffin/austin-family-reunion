# Austin Family Reunion — site handoff & working guide

This README is the **single source of truth for continuing work**. A new session should be able to
read this and pick up with zero discovery. If you change how the site works, update this file.

The site is the **Austin Family Reunion**'s home (the recurring family gathering) — not only the
2026 event. The current/next reunion is **Fresno, CA · October 9–11, 2026**.

---

## TL;DR for a new session
1. Edit **`parallax.html`** (the real homepage source).
2. **Always** `cp parallax.html index.html` after editing (they must stay identical — see below).
3. Preview locally: `cd /Users/sudo/austinreunion-site && python3 -m http.server 8011` → open `http://10.69.3.132:8011/parallax.html?v=N` (bump `N` to dodge cache).
4. Ship: `git add -A && git commit && git push origin master` → live on `https://austinreunion.com` in ~1–2 min.
5. Don't touch DNS or the GitHub Pages domain/cert config (see Hosting). The cert is in a known stuck state but the site is fully live over HTTPS.

---

## Where things are
- **Local repo:** `/Users/sudo/austinreunion-site` (a git repo; branch `master`).
- **GitHub:** `vyente-ruffin/austin-family-reunion` (private). Pages source = `master` branch, root `/`.
- **Live:** `https://austinreunion.com`, `https://www.austinreunion.com`, `https://austinreunion.com/register` — all serve over HTTPS (valid cert, Google Trust Services).
- **GitHub Pages URL:** `https://vyente-ruffin.github.io/austin-family-reunion/` (redirects to the custom domain).

## Canonical files (IMPORTANT)
- **`parallax.html`** = the homepage **source of truth**. Edit this.
- **`index.html`** = what the domain root serves. It is currently a **byte-for-byte copy of `parallax.html`**. After any edit to `parallax.html`, run `cp parallax.html index.html`. (If they drift, the live homepage won't match what you edited — this caused confusion before.)
- **`register.html`** = the standalone "Register / Reunion Info" page → `austinreunion.com/register`. Nav links point here.
- **`CNAME`** = `austinreunion.com` (tells GitHub Pages the custom domain — do not delete).
- **Dead drafts — ignore / do not edit:** `v1.html`–`v10.html`, `classic-stronger-roots.html`, `family-reunion-landing-page.html`, `family-reunion-bottom-left.html`, `index-original-backup.html`. Left in place on purpose (don't delete without asking).

## Images
- Two image dirs: **`assets/`** (original generated art) and **`images/`** (newer real photos). Both are used.
- **Greeting image** (next to "Greetings, Family"): `assets/fresno-mural.png`.
- **History gallery** ("Reunions Through the Years"): `assets/family-photo-1.png` (2022 Las Vegas), `images/2024.jpg` (2024 Houston), `assets/family-photo-3.png` (Fresno 2026).
- **OG/social image:** `images/austin-fam-og.png` — a **1200×630 (1.91:1) top-anchored crop** of `austin-fam.png` so link-preview cards (iMessage/SMS/Facebook crop to ~1.91:1) don't clip the tops of heads. Referenced via absolute `https://austinreunion.com/...` with explicit `og:image:width/height`. (The old `austin-fam.png` is 4:3 and got center-cropped → clipped heads. If you reshoot, regenerate this crop top-anchored the same way as the `.pbanner` strip.)
- Image sizing is CSS-driven (`object-fit:cover`, `width:100%`) — **no exact dimensions required**; just match the rough aspect (landscape for gallery/greeting, square for committee avatars). Big & sharp (~1200px) is fine.

### Optimize before adding (IMPORTANT — phone photos are huge)
Raw phone photos are ~6000px / 8 MB. **Never commit those** — they make the page slow, especially on phones. Downscale to a web copy first (target **≤ ~500 KB, max ~1600px**):
```bash
cd /Users/sudo/austinreunion-site
# JPEG photo -> web jpg (~1600px, quality 78):
sips -s format jpeg -s formatOptions 78 -Z 1600 images/SOURCE.JPG --out images/NAME-web.jpg
# PNG graphic that's still heavy -> convert to jpg to shrink:
sips -s format jpeg -s formatOptions 80 -Z 1600 images/SOURCE.png --out images/NAME-web.jpg
du -h images/NAME-web.jpg   # confirm it's small
```
Keep the original if you want, but reference the `-web` copy in the HTML.

### Swapping a "Reunions Through the Years" gallery photo
The 3 gallery photos are forced to a **uniform 4:3** via `.gallery img{aspect-ratio:4/3;object-fit:cover}` (line ~158), so any image auto-stretches/crops to match — you do NOT resize for shape, only for file weight (above). Current sources:
- 2022 Las Vegas → `images/2022-web.jpg`
- 2024 Houston → `images/2024.jpg`
- Fresno 2026 → `images/coming-soon-web.jpg` (placeholder; swap for the real Fresno photo after the event)
To swap one: optimize the new image (above), then change that `<figure>`'s `src=` in `parallax.html`, `cp parallax.html index.html`, preview, push.

## Page section map (`parallax.html`)
- `<head>`: title, description, **Open Graph + Twitter** tags (framed as the family's reunion home; "next up: 2026 Fresno").
- Nav (`<nav class="main">`): History · Reunion Info (`register.html`) · Register · **Facebook icon** → `https://www.facebook.com/groups/248323684164389` (group), opens new tab.
- **Hero** (`.hero`): WebGL parallax via three.js (CDN `unpkg.com/three@0.160.0`). Plain JS `<script>` near the bottom. Has a reduced-motion + `<img class="hero-fallback">` fallback. Tunables that control the flicker: cover `scale` (1.6) and scroll drift (`s*0.9`) in the script — keep drift < overscan or the transparent canvas shows through at the top.
- **Countdown** to Oct 9, 2026 (live JS).
- **Greetings** split section (text + `fresno-mural.png`).
- **Committee** (`.people`, `id="committee"`): 4×2 grid, name under each. 8 members. 5 have photos (`images/Darrell.png`, `images/Leshea.png`, `images/Lamarr.png`, `images/Bianca.png`, `images/Connie.png`); 3 still use initials avatars (`YL` Yvonne Sherii Lee-Long, `KW` Kamilah White, `LH` La Shan Harris). To add a photo: drop `images/<Name>.png` and replace that member's `<div class="avatar">XX</div>` with `<img class="avatar" src="images/<Name>.png" alt="Full Name" />`.
- **History** (`id="history"`): the 3-photo gallery above.
- **Parallax banner** (`.pbanner`): a CSS `background-attachment:fixed` parallax strip using `images/austin-fam-strip.jpg` — a **top-anchored crop** of `austin-fam.png` made with `sips -c 600 1448 --cropOffset 60 0` so faces aren't clipped while keeping the fixed-parallax effect. If you swap this image, crop it to a wide short face-strip the same way (centered crops clip the upper heads).
- **Register CTAs → Google Form.** Every "Register" / "Register Today" / "Register for the Reunion" button (in BOTH `parallax.html` and `register.html`) links to **`https://forms.gle/RDdt1tTXfw2FbaG8A`** (`target="_blank"`). To change the form, update that URL everywhere in both files (e.g. `grep -rl forms.gle .`). "Reunion Info" and "See the Weekend" are NOT register buttons — they point to `register.html`.
- Hero CTA buttons ("Register Today" / "See the Weekend") are forced equal width via `.hero .cta-row .btn{min-width:220px}`.

## Edit → preview → ship workflow
```bash
cd /Users/sudo/austinreunion-site
# 1. edit parallax.html
# 2. sync the served homepage:
cp parallax.html index.html
# 3. local preview (LAN: http://10.69.3.132:8011/parallax.html?v=N  — same Wi-Fi, bump N for cache)
python3 -m http.server 8011
# 4. push live:
git add -A
git commit -m "..."
git push origin master
# 5. live on https://austinreunion.com in ~1-2 min (GitHub Pages rebuild). Hard-refresh (Cmd+Shift+R) to beat browser cache.
```
Verify live after push: `curl -sL https://austinreunion.com/ | grep <your marker>`.

## Hosting / DNS (do NOT change without reason)
- **Registrar/DNS:** GoDaddy (`domaincontrol.com`). DNS is already set correctly:
  - apex `@` -> 4 A records `185.199.108.153 / .109 / .110 / .111` (GitHub Pages)
  - `www` -> CNAME `vyente-ruffin.github.io`
  - No CAA records (Let's Encrypt/Google allowed).
  - (GoDaddy has an API; a key was used once and should be rotated. Don't store it in the repo.)
- **GitHub Pages custom domain** = `austinreunion.com`, set in repo Pages settings + the `CNAME` file.
- **Cert status (known quirk):** `https_certificate.state` has been stuck at **`new`** in the GitHub API for a long time, but the **real cert is issued and the site serves HTTPS fine** (apex + www + /register all 200). Because the API says `new`, the **"Enforce HTTPS" toggle is blocked** (`https_enforced=false`). This is the only outstanding item and it's cosmetic (http->https auto-redirect).
  - **DO NOT** remove/re-add the custom domain to "fix" it — every toggle **resets GitHub's cert clock** and made it worse. Leave it alone.
  - To finish enforce when GitHub's API flips to `approved`: `gh api -X PUT repos/vyente-ruffin/austin-family-reunion/pages -F https_enforced=true` (or tick "Enforce HTTPS" in repo Settings -> Pages — the web UI sometimes works when the API 404s).

## Gotchas (learned the hard way)
- **`index.html` must mirror `parallax.html`** — always `cp` after editing, or the live homepage is stale.
- **Browser/CDN cache:** after a push, use `?v=N` or hard-refresh; GitHub Pages also caches ~minutes.
- **Don't nudge the GitHub domain/cert.** It's live; nudging only resets issuance.
- **OG image/url must be absolute** (`https://austinreunion.com/...`) — relative breaks social previews. To refresh a stale Facebook preview, run the URL through Facebook's Sharing Debugger -> "Scrape Again."
- **three.js hero flicker** = transparent canvas (`alpha:true`) showing through when the parallax plane drifts past its oversize. Fix is tuning (`scale` up / drift down), not a rewrite.
- **Hero load-flash:** `.hero` has a CSS `background:#1c130b url('assets/austin.png') center/cover` placeholder so there's a real image before the WebGL texture loads (textures are transparent until downloaded). Don't remove it.
- **Do NOT put `backdrop-filter: blur()` over the WebGL hero.** The countdown boxes (`.count .u`) intentionally use a solid `rgba` bg, not blur — backdrop-filter over the constantly-re-rendering canvas flickers on load/mouse-move (documented Chromium bug). Use a more opaque solid background instead.

## Current status (as of last session)
- Live over HTTPS: yes — apex + www + /register.
- Recent changes shipped: Fresno greeting image; history captions + real 2022/2024 photos + Fresno-2026 coming-soon placeholder (uniform 4:3); committee 4x2 grid (5 real photos + 3 initials); Facebook nav icon; OG/Twitter tags; all Register CTAs → Google Form; hero load-flash fix (CSS placeholder) + countdown backdrop-filter removed (flicker); parallax banner top-anchored face strip; features strip height halved; equal-width hero buttons.
- **Open items:** (1) Enforce-HTTPS flag pending GitHub cert API; (2) 3 committee members still on initials avatars (Yvonne, Kamilah, La Shan) — awaiting photos; (3) `assets/welcome-austin-2026.png` exists but is unused (greeting now uses `fresno-mural.png`).
