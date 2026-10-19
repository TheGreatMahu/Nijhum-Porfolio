# Nijhum Portfolio

Single-file, journalism-themed portfolio (newspaper design, sliding work windows, admin editor).

## Files
- index.html : the whole site (HTML, CSS and JS in one file)

## Run it
Open index.html in a browser, or upload it to any static host (Netlify, GitHub Pages, Vercel, etc.).
Fonts load from Google Fonts, so an internet connection is needed for the typefaces.

## Edit content by hand
All default content lives in the `DEF` object near the top of the `<script>`:
photo, name, CV lists, and the `segs` array (the 4 segments, their Drive links and slide items).
Put images in the same folder and use paths like "photo.jpg" -- NOTE: the site only accepts image
URLs starting with https:, /_blob/ or data:image, so for local files either use full https URLs
(e.g. a hosted image) or change the `U` function in index.html to allow relative paths.

## Admin panel (#/admin)
The admin panel and its Save & publish button rely on claude.ai's hosted-page features
(editor login, image uploads, republishing). They work only on the claude.ai-hosted version,
not on a copy hosted elsewhere. To get a standalone admin with its own login, the site needs a
small backend (e.g. Firebase or Supabase); ask Claude to build that version.
