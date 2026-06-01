# Austin Family Reunion 2026

Single-page website for the **Austin Family Reunion** — Fresno, California · **October 9–11, 2026**.

## Live site
- **Classic:** https://vyente-ruffin.github.io/austin-family-reunion/
- **WebGL parallax + live countdown:** https://vyente-ruffin.github.io/austin-family-reunion/parallax.html

Static HTML/CSS/JS — no build step. Registration is an external Google Form. Images and crest live in `/assets`.

## How to swap an image
1. Put your new picture in the `assets/` folder.
2. **Easiest:** give it the **same filename** as the one you're replacing (see list below). Nothing else to change.
   - Or use a new name and update the matching `src="assets/..."` in `index.html` / `parallax.html`.
3. Commit + push — the live site updates automatically in ~1 minute.

| File | Where it shows |
|---|---|
| `assets/austin.png` | Big hero background (sunset / tree) |
| `assets/tree-logo.png` | Logo in the top bar and footer |
| `assets/family-photo-1.png` | "Greetings, Family" portrait + gallery |
| `assets/family-photo-2.png` | Saturday section + gallery |
| `assets/family-photo-3.png` | Saturday section + gallery |

Tip: keep new photos a similar shape (landscape) so the layout stays clean. Compress large photos (aim under ~400 KB) for faster loading on phones.

## Status
Draft for family feedback. **Hotel** and **registration** buttons are placeholders pending final URLs.
